; =============================================================================
; KRON COMPILER - LINKER
; Architecture: x86-64 NASM win64 + GoLink
; no external dependencies
; =============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"

section .data

    msg_link_start  db "Kron Linker v1.0 starting...", 13, 10, 0
    msg_link_done   db "Linking complete: ", 0
    msg_link_err    db "Link error: ", 0
    msg_undef_sym   db "Undefined symbol: ", 0
    msg_dup_sym     db "Duplicate symbol: ", 0
    lnk_msg_newline     db 13, 10, 0

    seg_text_name   db ".text", 0
    seg_data_name   db ".data", 0
    seg_bss_name    db ".bss", 0

section .bss

    linker_state    resb 256
    output_buf      resb 16777216       ; 16 MB
    output_pos      resq 1
    output_size     resq 1
    global_symtab   resb 131072         ; 128 KB symbol table
    global_symcount resq 1
    reloc_table     resb 65536          ; 64 KB reloc table
    reloc_count     resq 1
    seg_text_data   resb 4194304        ; 4 MB .text
    seg_text_size   resq 1
    seg_data_data   resb 2097152        ; 2 MB .data
    seg_data_size   resq 1
    seg_bss_size    resq 1
    output_fd       resq 1
    output_filename resb 512
    link_error_buf  resb 512
    link_has_error  resb 1

section .text

    global jup_linker_init
    global jup_linker_run
    global linker_get_error

    extern jup_alloc
    extern WriteFile
    extern CreateFileA
    extern CloseHandle
    extern GetStdHandle
    extern ExitProcess

; =============================================================================
; jup_linker_init()  rcx=filename_out  rdx=target (0=ELF,1=PE)
; =============================================================================
jup_linker_init:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32                        ; shadow space

    ; Clear the state
    xor  rax, rax
    mov  [rel link_has_error], al
    mov  [rel output_pos],     rax
    mov  [rel global_symcount],rax
    mov  [rel reloc_count],    rax
    mov  [rel seg_text_size],  rax
    mov  [rel seg_data_size],  rax
    mov  [rel seg_bss_size],   rax

    ; Copy the file name
    lea  rdi, [rel output_filename]
    mov  rsi, rcx
    call strcpy_safe

    mov  rax, 1
    add  rsp, 32
    pop  rbp
    ret

; =============================================================================
; jup_linker_run()  rcx=target (0=ELF64, 1=PE32+)
; =============================================================================
jup_linker_run:
    push rbp
    mov  rbp, rsp
    sub  rsp, 32
    push rbx
    push r12

    mov  r12, rcx                       ; target

    ; Resolve symbols
    call linker_resolve_symbols
    test rax, rax
    jnz  .error

    ; Emit the binary for the target
    test r12, r12
    jz   .emit_elf
    cmp  r12, 1
    je   .emit_pe
    jmp  .emit_elf

.emit_elf:
    call emit_elf64_binary
    jmp  .write

.emit_pe:
    call emit_pe32_binary

.write:
    test rax, rax
    jnz  .error

    ; Write to the file (Windows API)
    lea  rcx, [rel output_filename]
    mov  rdx, 0x40000000                ; GENERIC_WRITE
    xor  r8,  r8                        ; no share
    xor  r9,  r9                        ; security=NULL
    sub  rsp, 24
    mov  qword [rsp+32], 2              ; CREATE_ALWAYS
    mov  qword [rsp+40], 0x80           ; FILE_ATTRIBUTE_NORMAL
    mov  qword [rsp+48], 0              ; templateFile=NULL
    call CreateFileA
    add  rsp, 24

    cmp  rax, -1
    je   .file_error
    mov  [rel output_fd], rax

    ; Write data
    mov  rcx, rax
    lea  rdx, [rel output_buf]
    mov  r8,  [rel output_pos]
    xor  r9,  r9
    sub  rsp, 40
    mov  qword [rsp+32], 0
    call WriteFile
    add  rsp, 40

    mov  rcx, [rel output_fd]
    call CloseHandle

    xor  rax, rax
    jmp  .done

.file_error:
    mov  rax, 2                         ; ERR_FILE_WRITE
    jmp  .done

.error:
    mov  byte [rel link_has_error], 1
    mov  rax, 1

.done:
    pop  r12
    pop  rbx
    add  rsp, 32
    pop  rbp
    ret

; =============================================================================
; linker_resolve_symbols  -  Resolves every relocation
; =============================================================================
linker_resolve_symbols:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13

    mov  r12, [rel reloc_count]
    xor  rbx, rbx

.loop:
    cmp  rbx, r12
    jge  .done

    lea  r13, [rel reloc_table]
    mov  rax, rbx
    mov  rcx, RELOC_ENTRY_SIZE
    mul  rcx
    add  r13, rax

    ; Look up a symbol
    lea  rdi, [rel global_symtab]
    mov  rsi, [rel global_symcount]
    lea  rdx, [r13 + RELOC_SYM_NAME]
    call find_symbol

    test rax, rax
    jz   .undefined

    mov  rcx, [rax + SYM_ADDRESS]
    mov  rdi, r13
    mov  rsi, rcx
    call apply_reloc

    test rax, rax
    jnz  .err

    inc  rbx
    jmp  .loop

.undefined:
    lea  rdi, [rel link_error_buf]
    lea  rsi, [rel msg_undef_sym]
    call strcpy_safe
    mov  byte [rel link_has_error], 1
    mov  rax, ERR_UNDEF_SYMBOL
    jmp  .exit

.err:
    mov  byte [rel link_has_error], 1
    mov  rax, ERR_LINK_FAILED
    jmp  .exit

.done:
    xor  rax, rax
.exit:
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret

; =============================================================================
; apply_reloc  rdi=reloc_entry  rsi=sym_address
; =============================================================================
apply_reloc:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12

    mov  rbx, rdi
    mov  r12, rsi

    movzx eax, byte [rbx + RELOC_TYPE]

    cmp  eax, RELOC_ABS64
    je   .abs64
    cmp  eax, RELOC_REL32
    je   .rel32
    cmp  eax, RELOC_ABS32
    je   .abs32

    mov  rax, ERR_BAD_RELOC
    jmp  .exit

.abs64:
    mov  rdi, [rbx + RELOC_OFFSET]
    mov  [rdi], r12
    xor  rax, rax
    jmp  .exit

.rel32:
    mov  rdi, [rbx + RELOC_OFFSET]
    mov  rax, r12
    sub  rax, rdi
    sub  rax, 4
    mov  [rdi], eax
    xor  rax, rax
    jmp  .exit

.abs32:
    mov  rdi, [rbx + RELOC_OFFSET]
    mov  eax, r12d
    mov  [rdi], eax
    xor  rax, rax

.exit:
    pop  r12
    pop  rbx
    pop  rbp
    ret

; =============================================================================
; emit_elf64_binary  -  Produces ELF64 for Linux
; =============================================================================
emit_elf64_binary:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13

    lea  rbx, [rel output_buf]
    mov  qword [rel output_pos], 0

    ; ELF magic + ident
    mov  dword [rbx],    0x464C457F     ; \x7fELF
    mov  byte  [rbx+4],  2              ; 64-bit
    mov  byte  [rbx+5],  1              ; little-endian
    mov  byte  [rbx+6],  1              ; version
    mov  byte  [rbx+7],  0              ; OS/ABI SysV
    mov  qword [rbx+8],  0              ; padding

    mov  word  [rbx+16], 2              ; ET_EXEC
    mov  word  [rbx+18], 0x3E           ; x86-64
    mov  dword [rbx+20], 1              ; version
    mov  qword [rbx+24], 0x401000       ; entry
    mov  qword [rbx+32], 64             ; phoff
    mov  qword [rbx+40], 0              ; shoff
    mov  dword [rbx+48], 0              ; flags
    mov  word  [rbx+52], 64             ; ehsize
    mov  word  [rbx+54], 56             ; phentsize
    mov  word  [rbx+56], 2              ; phnum (.text + .data)
    mov  word  [rbx+58], 64             ; shentsize
    mov  word  [rbx+60], 0              ; shnum
    mov  word  [rbx+62], 0              ; shstrndx

    ; Work out the segment offsets
    mov  r12, 64 + 56*2                 ; offset of .text in the file
    mov  r13, r12
    add  r13, [rel seg_text_size]       ; offset of .data in the file

    ; Program Header .text
    lea  rdi, [rbx + 64]
    mov  dword [rdi],    1              ; PT_LOAD
    mov  dword [rdi+4],  5              ; R|X
    mov  qword [rdi+8],  r12
    mov  rax, 0x400000
    add  rax, r12
    mov  qword [rdi+16], rax
    mov  qword [rdi+24], rax
    mov  rax, [rel seg_text_size]
    mov  qword [rdi+32], rax
    mov  qword [rdi+40], rax
    mov  qword [rdi+48], 0x1000

    ; Program Header .data
    lea  rdi, [rbx + 120]
    mov  dword [rdi],    1              ; PT_LOAD
    mov  dword [rdi+4],  6              ; R|W
    mov  qword [rdi+8],  r13
    mov  rax, 0x600000
    add  rax, r13
    mov  qword [rdi+16], rax
    mov  qword [rdi+24], rax
    mov  rax, [rel seg_data_size]
    mov  qword [rdi+32], rax
    mov  qword [rdi+40], rax
    mov  qword [rdi+48], 0x1000

    ; Copy .text
    lea  rdi, [rbx + r12]
    lea  rsi, [rel seg_text_data]
    mov  rcx, [rel seg_text_size]
    rep  movsb

    ; Copy .data
    lea  rdi, [rbx + r13]
    lea  rsi, [rel seg_data_data]
    mov  rcx, [rel seg_data_size]
    rep  movsb

    ; output_pos = r13 + seg_data_size
    mov  rax, r13
    add  rax, [rel seg_data_size]
    mov  [rel output_pos], rax

    xor  rax, rax
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret

; =============================================================================
; emit_pe32_binary  -  Produces PE32+ for Windows
; =============================================================================
emit_pe32_binary:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13

    lea  rbx, [rel output_buf]

    ; Minimal DOS header
    mov  word  [rbx],     0x5A4D        ; MZ
    mov  dword [rbx+60],  0xB8          ; e_lfanew

    ; PE Signature
    lea  rdi, [rbx + 0xB8]
    mov  dword [rdi], 0x00004550        ; PE\0\0

    ; COFF Header
    mov  word  [rdi+4],  0x8664         ; AMD64
    mov  word  [rdi+6],  2              ; NumberOfSections
    mov  dword [rdi+8],  0              ; TimeDateStamp
    mov  dword [rdi+12], 0
    mov  dword [rdi+16], 0
    mov  word  [rdi+20], 240            ; SizeOfOptionalHeader
    mov  word  [rdi+22], 0x0022         ; Characteristics

    ; Optional Header PE32+
    lea  rdi, [rbx + 0xB8 + 24]
    mov  word  [rdi],    0x020B         ; Magic PE32+
    mov  byte  [rdi+2],  14             ; MajorLinkerVersion
    mov  byte  [rdi+3],  0
    mov  rax, [rel seg_text_size]
    mov  dword [rdi+4],  eax            ; SizeOfCode
    mov  rax, [rel seg_data_size]
    mov  dword [rdi+8],  eax
    mov  rax, [rel seg_bss_size]
    mov  dword [rdi+12], eax
    mov  dword [rdi+16], 0x1000         ; AddressOfEntryPoint
    mov  dword [rdi+20], 0x1000         ; BaseOfCode
    ; ImageBase does not fit: 'mov qword [mem], imm' takes a 32-bit signed
    ; immediate, so this wrote 0x40000000 and NASM warned about it. The
    ; image still ran because Windows relocates it, but the field was not
    ; what the line said.
    mov  rax, 0x140000000
    mov  qword [rdi+24], rax            ; ImageBase
    mov  dword [rdi+32], 0x1000         ; SectionAlignment
    mov  dword [rdi+36], 0x200          ; FileAlignment
    mov  word  [rdi+40], 6              ; MajorOSVersion
    mov  word  [rdi+42], 0
    mov  word  [rdi+48], 6              ; MajorSubsystemVersion
    mov  word  [rdi+50], 0
    mov  dword [rdi+56], 0
    mov  rax, [rel seg_text_size]
    add  rax, [rel seg_data_size]
    add  rax, [rel seg_bss_size]
    add  rax, 0x3000
    mov  dword [rdi+60], eax            ; SizeOfImage
    mov  dword [rdi+64], 0x400          ; SizeOfHeaders
    mov  dword [rdi+68], 0              ; CheckSum
    mov  word  [rdi+72], 3              ; Subsystem CUI
    mov  word  [rdi+74], 0x8160         ; DllCharacteristics

    ; Section Headers
    lea  rdi, [rbx + 0xB8 + 24 + 240]

    ; .text section header
    mov  dword [rdi],    0x74786574     ; "text"
    mov  dword [rdi+4],  0x00000000
    mov  rax, [rel seg_text_size]
    mov  dword [rdi+8],  eax            ; VirtualSize
    mov  dword [rdi+12], 0x1000         ; VirtualAddress
    mov  dword [rdi+16], eax            ; SizeOfRawData
    mov  dword [rdi+20], 0x400          ; PointerToRawData
    mov  dword [rdi+24], 0
    mov  dword [rdi+28], 0
    mov  word  [rdi+32], 0
    mov  word  [rdi+34], 0
    mov  dword [rdi+36], 0x60000020     ; Execute|Read|Code

    ; .data section header
    lea  rdi, [rbx + 0xB8 + 24 + 240 + 40]
    mov  dword [rdi],    0x61746164     ; "data"
    mov  dword [rdi+4],  0x00000000
    mov  rax, [rel seg_data_size]
    mov  dword [rdi+8],  eax
    mov  rax, [rel seg_text_size]
    add  rax, 0x1000
    mov  dword [rdi+12], eax
    mov  rax, [rel seg_data_size]
    mov  dword [rdi+16], eax
    mov  rax, [rel seg_text_size]
    add  rax, 0x400
    mov  dword [rdi+20], eax
    mov  dword [rdi+24], 0
    mov  dword [rdi+28], 0
    mov  word  [rdi+32], 0
    mov  word  [rdi+34], 0
    mov  dword [rdi+36], 0xC0000040     ; Read|Write|Data

    ; Copy .text to offset 0x400
    lea  rdi, [rbx + 0x400]
    lea  rsi, [rel seg_text_data]
    mov  rcx, [rel seg_text_size]
    rep  movsb

    ; Copy .data
    mov  rax, [rel seg_text_size]
    add  rax, 0x400
    lea  rdi, [rbx + rax]
    lea  rsi, [rel seg_data_data]
    mov  rcx, [rel seg_data_size]
    rep  movsb

    ; output_pos
    mov  rax, [rel seg_text_size]
    add  rax, [rel seg_data_size]
    add  rax, 0x400
    mov  [rel output_pos], rax

    xor  rax, rax
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret

; =============================================================================
; Helper functions
; =============================================================================

find_symbol:
    ; rdi=symtab  rsi=count  rdx=name
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13

    mov  rbx, rdi
    mov  r12, rsi
    mov  r13, rdx
    xor  rcx, rcx

.fs_loop:
    cmp  rcx, r12
    jge  .fs_not_found

    mov  rax, rcx
    mov  rdi, SYM_ENTRY_SIZE
    mul  rdi
    add  rax, rbx

    lea  rdi, [rax + SYM_NAME]
    mov  rsi, r13
    call strcmp_asm
    test rax, rax
    jz   .fs_found

    inc  rcx
    jmp  .fs_loop

.fs_found:
    mov  rax, rcx
    mov  rdi, SYM_ENTRY_SIZE
    mul  rdi
    add  rax, rbx
    jmp  .fs_exit

.fs_not_found:
    xor  rax, rax

.fs_exit:
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret

add_global_symbol:
    push rbp
    mov  rbp, rsp
    push rbx

    mov  rbx, rdi
    mov  rax, [rel global_symcount]
    mov  rcx, SYM_ENTRY_SIZE
    mul  rcx

    lea  rdi, [rel global_symtab]
    add  rdi, rax
    mov  rsi, rbx
    mov  rcx, SYM_ENTRY_SIZE
    rep  movsb

    inc  qword [rel global_symcount]
    xor  rax, rax
    pop  rbx
    pop  rbp
    ret

linker_get_error:
    lea  rax, [rel link_error_buf]
    ret

; =============================================================================
; lnk_print_string  rcx=str  (Windows: usa WriteFile a stdout)
; =============================================================================
lnk_print_string:
    push rbp
    mov  rbp, rsp
    push rbx
    sub  rsp, 48

    mov  rbx, rcx
    ; Work out the length
    xor  rdx, rdx
.ps_len:
    cmp  byte [rbx + rdx], 0
    je   .ps_write
    inc  rdx
    jmp  .ps_len
.ps_write:
    ; GetStdHandle(-11)
    mov  rcx, -11
    call GetStdHandle

    mov  rcx, rax                       ; hFile
    mov  rdx, rbx                       ; lpBuffer
    ; r8 already has the len in rdx... move it
    mov  r8,  rdx                       ; nNumberOfBytesToWrite
    xor  r9,  r9
    mov  qword [rsp+32], 0
    call WriteFile

    add  rsp, 48
    pop  rbx
    pop  rbp
    ret

strcpy_safe:
    push rbp
    mov  rbp, rsp
.sc_loop:
    mov  al, [rsi]
    mov  [rdi], al
    test al, al
    jz   .sc_done
    inc  rsi
    inc  rdi
    jmp  .sc_loop
.sc_done:
    pop  rbp
    ret

strcmp_asm:
    push rbp
    mov  rbp, rsp
    push rbx
.sa_loop:
    mov  al,  [rdi]
    mov  bl,  [rsi]
    cmp  al,  bl
    jne  .sa_neq
    test al,  al
    jz   .sa_eq
    inc  rdi
    inc  rsi
    jmp  .sa_loop
.sa_eq:
    xor  rax, rax
    jmp  .sa_exit
.sa_neq:
    movsx rax, al
    movsx rbx, bl
    sub   rax, rbx
.sa_exit:
    pop  rbx
    pop  rbp
    ret
