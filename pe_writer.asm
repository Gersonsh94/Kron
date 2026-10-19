; ==============================================================================
; PE_WRITER v3 - writes a PE32+ executable with a 3-section layout (like NASM+GoLink)
;
; Reproduces the layout GoLink produces (ref.exe, which works):
;   .text  (R+X)  RVA 0x1000  [code][thunks]
;   .data  (R+W)  RVA 0x2000  [data][bss]
;   .idata (R)    RVA 0x3000  [kernel32 import table]
;
; kasm resolves the [rel data/bss] assuming a FLAT layout (data right after the
; code). Since .data lives here at RVA 0x2000 (separate), this writer RE-PATCHES
; each disp32 of those [rel] against the real RVA of .data, using the introspection
; of fixups kasm exposes (kasm_get_fixup_*).
;
; pw_write(rcx = buffer >= 2MB) -> rax = total length. Windows x64, no CRT.
; ==============================================================================

bits 64
default rel

extern kasm_get_code
extern kasm_get_code_size
extern kasm_get_data
extern kasm_get_data_size
extern kasm_get_bss_size
extern kasm_get_ext_count
extern kasm_get_ext_name
extern kasm_get_extref_count
extern kasm_get_extref_at
extern kasm_get_extref_sym
extern kasm_find_label
extern kasm_label_addr
extern kasm_get_fixup_count
extern kasm_get_fixup_at
extern kasm_get_fixup_label
extern kasm_get_fixup_addend
extern kasm_get_fixup_kind
extern kasm_get_label_section
extern codegen_export_count, codegen_export_name

%define FILE_ALIGN  0x200
%define SECT_ALIGN  0x1000
%define SIZEOFHDRS  0x400
%define THUNK_SIZE  6
%define TEXT_RVA    0x1000
%define DATA_RVA    0x2000
%define IDATA_RVA   0x3000

section .bss
    pw_buf          resq 1
    pw_code_ptr     resq 1
    pw_code_len     resq 1
    pw_data_ptr     resq 1
    pw_data_len     resq 1
    pw_bss_len      resq 1
    pw_ext_count    resq 1
    pw_xref_count   resq 1
    pw_thunks_off   resq 1          ; offset of the thunks inside .text
    pw_text_vsize   resq 1
    pw_text_raw     resq 1
    pw_text_foff    resq 1
    pw_bss_off_sec  resq 1          ; offset of bss inside .data
    pw_data_vsize   resq 1
    pw_data_raw     resq 1
    pw_data_foff    resq 1
    pw_idata_foff   resq 1
    pw_idata_size   resq 1
    pw_data_rva     resq 1          ; worked out: it does not always fit in 0x2000
    pw_idata_rva    resq 1
    pw_idt_rva      resq 1
    pw_ilt_rva      resq 1
    pw_iat_rva      resq 1
    pw_names_intra  resq 1
    pw_hint_rva     resq 128
    pw_entry_rva    resq 1
    pw_total        resq 1
    pw_base         resq 1          ; ImageBase: a program's, or a library's
    pw_exp_n        resq 1          ; a library: how many exports
    pw_exp_order    resq 4096       ; their numbers, sorted by name
    pw_exp_dir      resq 1          ; offset of the export directory in .idata
    pw_exp_size     resq 1
    pw_rel_dir      resq 1          ; and of the base relocations
    pw_rel_size     resq 1
    pw_rel_page     resq 1          ; the page of the block being written
    pw_rel_block    resq 1          ; where that block starts
    pw_name         resb 320        ; "__ce_" and an export's name

section .data
    pw_gui db 0                   ; 1: GUI subsystem (set by main for --window)
    pw_dll db 0                   ; 1: a DLL (--lib); main sets pw_dll_file too
    pw_dll_file dq 0              ; the DLL's own name, without its folder
    pw_dll_name     db "kernel32.dll", 0
    pw_main_name    db "main", 0
    pw_dllmain_name db "__dll_main", 0

section .text
    global pw_write
    global pw_gui, pw_dll, pw_dll_file

pw_put8:
    mov  rax, [rel pw_buf]
    mov  [rax + rcx], dl
    ret
pw_put16:
    mov  rax, [rel pw_buf]
    mov  [rax + rcx], dx
    ret
pw_put32:
    mov  rax, [rel pw_buf]
    mov  [rax + rcx], edx
    ret
pw_put64:
    mov  rax, [rel pw_buf]
    mov  [rax + rcx], rdx
    ret
pw_align:
    dec  rcx
    add  rax, rcx
    not  rcx
    and  rax, rcx
    ret

pw_write:
    push rbp
    mov  rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15
    push rdi
    push rsi
    sub  rsp, 40

    mov  [rel pw_buf], rcx

    sub  rsp,32
    call kasm_get_code
    add  rsp,32
    mov  [rel pw_code_ptr], rax
    sub  rsp,32
    call kasm_get_code_size
    add  rsp,32
    mov  [rel pw_code_len], rax
    sub  rsp,32
    call kasm_get_data
    add  rsp,32
    mov  [rel pw_data_ptr], rax
    sub  rsp,32
    call kasm_get_data_size
    add  rsp,32
    mov  [rel pw_data_len], rax
    sub  rsp,32
    call kasm_get_bss_size
    add  rsp,32
    mov  [rel pw_bss_len], rax
    sub  rsp,32
    call kasm_get_ext_count
    add  rsp,32
    mov  [rel pw_ext_count], rax
    sub  rsp,32
    call kasm_get_extref_count
    add  rsp,32
    mov  [rel pw_xref_count], rax

    ; ---- EntryPoint = TEXT_RVA + offset(main), or of __dll_main ----
    mov  rax, 0x0000000140000000
    mov  [rel pw_base], rax
    lea  rcx, [rel pw_main_name]
    mov  rdx, 4
    cmp  byte [rel pw_dll], 0
    je   .entry_name
    mov  rax, 0x0000000180000000     ; where a DLL would rather go
    mov  [rel pw_base], rax
    lea  rcx, [rel pw_dllmain_name]
    mov  rdx, 10
.entry_name:
    sub  rsp,32
    call kasm_find_label
    add  rsp,32
    cmp  eax, -1
    je   .no_main
    sub  rsp,32
    call kasm_label_addr
    add  rsp,32
    add  rax, TEXT_RVA
    mov  [rel pw_entry_rva], rax
    jmp  .entry_set
.no_main:
    mov  qword [rel pw_entry_rva], TEXT_RVA
.entry_set:

    ; ---- layout .text: [code][thunks] ----
    mov  rax, [rel pw_code_len]
    mov  rcx, 16
    call pw_align
    mov  [rel pw_thunks_off], rax        ; thunks after the code (align16)
    mov  rbx, [rel pw_ext_count]
    imul rbx, THUNK_SIZE
    add  rax, rbx
    mov  [rel pw_text_vsize], rax
    mov  rcx, FILE_ALIGN
    call pw_align
    mov  [rel pw_text_raw], rax
    mov  qword [rel pw_text_foff], SIZEOFHDRS

    ; ---- layout .data: [data][bss] ----
    mov  rax, [rel pw_data_len]
    mov  rcx, 16
    call pw_align
    mov  [rel pw_bss_off_sec], rax        ; bss after data (align16)
    add  rax, [rel pw_bss_len]
    mov  [rel pw_data_vsize], rax
    mov  rax, [rel pw_data_len]           ; only data goes into the file
    mov  rcx, FILE_ALIGN
    call pw_align
    mov  [rel pw_data_raw], rax
    mov  rax, [rel pw_text_foff]
    add  rax, [rel pw_text_raw]
    mov  [rel pw_data_foff], rax

    ; ---- .idata foff ----
    mov  rax, [rel pw_data_foff]
    add  rax, [rel pw_data_raw]
    mov  [rel pw_idata_foff], rax

    ; ---- section RVAs, derived from the real size ----
    ; With fixed RVAs, a .text longer than one page overlapped .data and
    ; Windows rejected the image.
    mov  rax, TEXT_RVA
    add  rax, [rel pw_text_vsize]
    mov  rcx, SECT_ALIGN
    call pw_align
    mov  [rel pw_data_rva], rax
    add  rax, [rel pw_data_vsize]
    mov  rcx, SECT_ALIGN
    call pw_align
    mov  [rel pw_idata_rva], rax

    ; ---- internal .idata layout: IDT|ILT|IAT|names|dll ----
    mov  r12, [rel pw_ext_count]
    mov  rax, [rel pw_idata_rva]
    mov  [rel pw_idt_rva], rax
    mov  rax, [rel pw_idata_rva]
    add  rax, 40
    mov  [rel pw_ilt_rva], rax
    mov  rbx, r12
    inc  rbx
    imul rbx, 8
    add  rax, rbx
    mov  [rel pw_iat_rva], rax
    add  rax, rbx
    mov  rcx, rax
    sub  rcx, [rel pw_idata_rva]
    mov  [rel pw_names_intra], rcx

    ; ---- clear the headers ----
    mov  rdi, [rel pw_buf]
    xor  eax, eax
    mov  rcx, SIZEOFHDRS
    rep  stosb

    ; ---- clear .text and .data in the file as well ----
    ; Only the code and the data bytes are copied in. The rest of each
    ; section, up to its file alignment, kept whatever the buffer held before,
    ; and the buffer had just held the assembly text. .bss starts inside that
    ; last block of .data, so variables that must begin at zero began with
    ; leftover text: __fail_next was 0x20200a7862722068 ("h rbx\n  ") and
    ; the first fail of every program crashed.
    mov  rdi, [rel pw_buf]
    add  rdi, SIZEOFHDRS
    xor  eax, eax
    mov  rcx, [rel pw_idata_foff]
    sub  rcx, SIZEOFHDRS
    rep  stosb

    ; DOS
    xor  rcx, rcx
    mov  dx, 0x5A4D
    call pw_put16
    mov  rcx, 0x3C
    mov  edx, 0xB8
    call pw_put32
    ; PE sig
    mov  rcx, 0xB8
    mov  edx, 0x00004550
    call pw_put32
    ; COFF
    mov  rcx, 0xBC
    mov  dx, 0x8664
    call pw_put16
    mov  rcx, 0xBC+2
    mov  dx, 3                    ; 3 sections
    call pw_put16
    mov  rcx, 0xBC+16
    mov  dx, 240
    call pw_put16
    mov  rcx, 0xBC+18
    mov  dx, 0x0023              ; EXEC | LARGE_ADDR | RELOCS_STRIPPED
    cmp  byte [rel pw_dll], 0
    je   .coff_ch
    mov  dx, 0x2022              ; EXEC | LARGE_ADDR | DLL: relocations kept
.coff_ch:
    call pw_put16

    ; Optional
    mov  rcx, 0xD0
    mov  dx, 0x020B
    call pw_put16
    mov  rcx, 0xD0+2
    mov  dl, 14
    call pw_put8
    mov  rcx, 0xD0+4
    mov  edx, dword [rel pw_text_raw]
    call pw_put32                ; SizeOfCode
    mov  rcx, 0xD0+16
    mov  edx, dword [rel pw_entry_rva]
    call pw_put32                ; AddressOfEntryPoint = main
    mov  rcx, 0xD0+20
    mov  edx, TEXT_RVA
    call pw_put32                ; BaseOfCode
    mov  rcx, 0xD0+24
    mov  rdx, [rel pw_base]
    call pw_put64                ; ImageBase
    mov  rcx, 0xD0+32
    mov  edx, SECT_ALIGN
    call pw_put32
    mov  rcx, 0xD0+36
    mov  edx, FILE_ALIGN
    call pw_put32
    mov  rcx, 0xD0+40
    mov  dx, 6
    call pw_put16
    mov  rcx, 0xD0+48
    mov  dx, 6
    call pw_put16
    mov  rcx, 0xD0+60
    mov  edx, SIZEOFHDRS
    call pw_put32
    mov  rcx, 0xD0+68
    mov  dx, 3                   ; console
    cmp  byte [rel pw_gui], 0
    je   .subsys
    mov  dx, 2                   ; GUI: Windows opens no console (--window)
    jmp  .subsys
.subsys:
    call pw_put16
    mov  rcx, 0xD0+70
    mov  dx, 0                   ; DllCharacteristics = 0 (no ASLR)
    cmp  byte [rel pw_dll], 0
    je   .dllch
    mov  dx, 0x0060              ; a DLL goes where there is room: relocated
.dllch:
    call pw_put16
    mov  rcx, 0xD0+72
    mov  rdx, 0x800000           ; stack reserve: 8 MB (graphics drivers use
    call pw_put64                ; deep stacks; commit stays 64 KB)
    mov  rcx, 0xD0+80
    mov  rdx, 0x10000
    call pw_put64
    mov  rcx, 0xD0+88
    mov  rdx, 0x100000
    call pw_put64
    mov  rcx, 0xD0+96
    mov  rdx, 0x1000
    call pw_put64
    mov  rcx, 0xD0+108
    mov  edx, 16
    call pw_put32

    ; DataDirectory[1] IMPORT
    mov  rcx, 0xD0+112+8
    mov  edx, dword [rel pw_idt_rva]
    call pw_put32
    mov  rcx, 0xD0+112+8+4
    mov  edx, 40
    call pw_put32
    ; DataDirectory[12] IAT
    mov  rcx, 0xD0+112+96
    mov  edx, dword [rel pw_iat_rva]
    call pw_put32
    mov  rcx, 0xD0+112+96+4
    mov  rax, [rel pw_ext_count]
    inc  rax
    imul rax, 8
    mov  edx, eax
    call pw_put32

    ; ---- Section headers @ 0x1C0 ----
    ; .text
    mov  rcx, 0x1C0
    mov  rdx, 0x0000747865742E    ; ".text"
    call pw_put64
    mov  rcx, 0x1C0+8
    mov  edx, dword [rel pw_text_vsize]
    call pw_put32
    mov  rcx, 0x1C0+12
    mov  edx, TEXT_RVA
    call pw_put32
    mov  rcx, 0x1C0+16
    mov  edx, dword [rel pw_text_raw]
    call pw_put32
    mov  rcx, 0x1C0+20
    mov  edx, dword [rel pw_text_foff]
    call pw_put32
    mov  rcx, 0x1C0+36
    mov  edx, 0x60000020         ; R+X+CODE
    call pw_put32
    ; .data
    mov  rcx, 0x1C0+40
    mov  rdx, 0x0000617461642E    ; ".data"
    call pw_put64
    mov  rcx, 0x1C0+40+8
    mov  edx, dword [rel pw_data_vsize]
    call pw_put32
    mov  rcx, 0x1C0+40+12
    mov  edx, dword [rel pw_data_rva]
    call pw_put32
    mov  rcx, 0x1C0+40+16
    mov  edx, dword [rel pw_data_raw]
    call pw_put32
    ; PointerToRawData: if RawSize==0, it must be 0 (otherwise Windows maps garbage
    ; from .idata over .data and corrupts the section). Like ref.exe.
    mov  rcx, 0x1C0+40+20
    mov  rax, [rel pw_data_raw]
    test rax, rax
    jnz  .data_has_raw
    xor  edx, edx                ; RawSize 0 -> PointerToRawData 0
    call pw_put32
    jmp  .data_hdr_flags
.data_has_raw:
    mov  edx, dword [rel pw_data_foff]
    call pw_put32
.data_hdr_flags:
    mov  rcx, 0x1C0+40+36
    mov  edx, 0xC0000040         ; R+W+INIT_DATA
    call pw_put32
    ; .idata
    mov  rcx, 0x1C0+80
    mov  rdx, 0x000061746164692E  ; ".idata"
    call pw_put64
    mov  rcx, 0x1C0+80+12
    mov  edx, dword [rel pw_idata_rva]
    call pw_put32
    mov  rcx, 0x1C0+80+20
    mov  edx, dword [rel pw_idata_foff]
    call pw_put32
    mov  rcx, 0x1C0+80+36
    mov  edx, 0x40000040         ; R+INIT_DATA
    call pw_put32

    ; ---- copy CODE into .text (offset 0) ----
    mov  rdi, [rel pw_buf]
    add  rdi, [rel pw_text_foff]
    mov  rsi, [rel pw_code_ptr]
    mov  rcx, [rel pw_code_len]
    rep  movsb

    ; ---- copy DATA into .data ----
    mov  rcx, [rel pw_data_len]
    test rcx, rcx
    jz   .no_data
    mov  rdi, [rel pw_buf]
    add  rdi, [rel pw_data_foff]
    mov  rsi, [rel pw_data_ptr]
    rep  movsb
.no_data:

    ; ---- THUNKS at the end of .text ----
    xor  r13, r13
.thunk_loop:
    cmp  r13, [rel pw_ext_count]
    jae  .thunks_done
    mov  rax, r13
    imul rax, THUNK_SIZE
    add  rax, [rel pw_thunks_off]
    add  rax, [rel pw_text_foff]
    mov  r14, rax
    mov  rcx, r14
    mov  dl, 0xFF
    call pw_put8
    lea  rcx, [r14+1]
    mov  dl, 0x25
    call pw_put8
    ; disp32 = IATslot_rva - (thunk_rva + 6)
    mov  rax, [rel pw_iat_rva]
    mov  rbx, r13
    imul rbx, 8
    add  rax, rbx
    mov  rbx, TEXT_RVA
    add  rbx, [rel pw_thunks_off]
    mov  r8, r13
    imul r8, THUNK_SIZE
    add  rbx, r8
    add  rbx, 6
    sub  rax, rbx
    lea  rcx, [r14+2]
    mov  edx, eax
    call pw_put32
    inc  r13
    jmp  .thunk_loop
.thunks_done:

    ; ---- PATCH external call sites (E8 rel32 -> thunk) ----
    xor  r13, r13
.patch_loop:
    cmp  r13, [rel pw_xref_count]
    jae  .patch_done
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_extref_at
    add  rsp,32
    mov  r14, rax
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_extref_sym
    add  rsp,32
    mov  r15, rax
    mov  rax, TEXT_RVA
    add  rax, [rel pw_thunks_off]
    mov  rbx, r15
    imul rbx, THUNK_SIZE
    add  rax, rbx
    mov  rbx, TEXT_RVA
    add  rbx, r14
    add  rbx, 4
    sub  rax, rbx
    mov  rcx, [rel pw_text_foff]
    add  rcx, r14
    mov  edx, eax
    call pw_put32
    inc  r13
    jmp  .patch_loop
.patch_done:

    ; ---- RE-PATCH [rel data/bss]: kasm resolved them in a flat layout;
    ; here they are rewritten to point at the real RVA of .data. ----
    sub  rsp,32
    call kasm_get_fixup_count
    add  rsp,32
    mov  r12, rax                 ; total number of fixups
    xor  r13, r13
.fix_loop:
    cmp  r13, r12
    jae  .fix_done
    ; kind: only kind 3 is re-patched (RIP to a data/bss label)
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_fixup_kind
    add  rsp,32
    cmp  eax, 6
    je   .fix_abs64
    cmp  eax, 3
    jne  .fix_next
    ; label index
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_fixup_label
    add  rsp,32
    mov  r15, rax                 ; label idx
    cmp  r15d, -1
    je   .fix_next
    ; section of the label (1=data, 2=bss). If it is text (0), leave it alone.
    mov  rcx, r15
    sub  rsp,32
    call kasm_get_label_section
    add  rsp,32
    mov  r10, rax                 ; section
    cmp  r10, 1
    jb   .fix_next                ; section 0 (text) -> skip
    ; offset of the label inside its section
    mov  rax, r15
    sub  rsp,32
    call kasm_label_addr
    add  rsp,32
    mov  r11, rax                 ; offset_in_sec
    ; base RVA of the section: data and bss both in .data (DATA_RVA).
    ; bss goes after data: if section==2, add bss_off_sec.
    mov  r8, [rel pw_data_rva]
    cmp  r10, 2
    jne  .fix_isdata
    add  r8, [rel pw_bss_off_sec]
.fix_isdata:
    add  r8, r11                  ; target = base + offset_in_sec
    ; addend
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_fixup_addend
    add  rsp,32
    add  r8, rax                  ; + addend
    ; fix_at: offset of the disp32 in the code
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_fixup_at
    add  rsp,32
    mov  r14, rax                 ; fix_at
    ; disp32 = target - (TEXT_RVA + fix_at + 4)
    mov  rbx, TEXT_RVA
    add  rbx, r14
    add  rbx, 4
    mov  rax, r8
    sub  rax, rbx
    ; write into the code (file offset = text_foff + fix_at)
    mov  rcx, [rel pw_text_foff]
    add  rcx, r14
    mov  edx, eax
    call pw_put32
    jmp  .fix_next               ; the kind 3 path ends here: do not fall into the one below
.fix_abs64:
    ; A 'dq label' inside .data: kasm reserved eight bytes and noted where.
    ; Here they are filled with the final virtual address, which is only known
    ; once the sections are fixed.
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_fixup_label
    add  rsp,32
    mov  r15, rax
    cmp  r15d, -1
    je   .fix_next
    mov  rcx, r15
    sub  rsp,32
    call kasm_get_label_section
    add  rsp,32
    mov  r10, rax                 ; 0 text, 1 data, 2 bss
    mov  rax, r15
    sub  rsp,32
    call kasm_label_addr
    add  rsp,32
    mov  r11, rax                 ; offset inside its section
    cmp  r10, 0
    jne  .fa_data
    mov  r8, TEXT_RVA
    jmp  .fa_have
.fa_data:
    mov  r8, [rel pw_data_rva]
    cmp  r10, 2
    jne  .fa_have
    add  r8, [rel pw_bss_off_sec]
.fa_have:
    add  r8, r11
    add  r8, [rel pw_base]        ; absolute virtual address
    mov  rcx, r13
    sub  rsp,32
    call kasm_get_fixup_at
    add  rsp,32
    mov  rcx, [rel pw_data_foff]
    add  rcx, rax                 ; fix_at is an offset inside .data
    mov  rdx, r8
    call pw_put64
    jmp  .fix_next

.fix_next:
    inc  r13
    jmp  .fix_loop
.fix_done:

    ; ---- BUILD .idata ----
    mov  r12, [rel pw_idata_foff]
    mov  r13, [rel pw_idata_rva]
    mov  rdi, [rel pw_buf]
    add  rdi, r12
    xor  eax, eax
    mov  rcx, 2048
    rep  stosb

    mov  rcx, r12
    mov  edx, dword [rel pw_ilt_rva]
    call pw_put32
    lea  rcx, [r12+16]
    mov  edx, dword [rel pw_iat_rva]
    call pw_put32

    mov  r14, [rel pw_names_intra]
    xor  r15, r15
.name_loop:
    cmp  r15, [rel pw_ext_count]
    jae  .names_done
    mov  rax, r13
    add  rax, r14
    lea  rbx, [rel pw_hint_rva]
    mov  [rbx + r15*8], rax
    mov  rcx, r15
    sub  rsp,32
    call kasm_get_ext_name
    add  rsp,32
    mov  rsi, rax
    mov  rdi, [rel pw_buf]
    add  rdi, r12
    add  rdi, r14
    add  rdi, 2
    xor  r8, r8
.copy_name:
    mov  al, [rsi + r8]
    mov  [rdi + r8], al
    test al, al
    jz   .name_done1
    inc  r8
    jmp  .copy_name
.name_done1:
    add  r14, 2
    add  r14, r8
    inc  r14
    test r14, 1
    jz   .name_even
    inc  r14
.name_even:
    inc  r15
    jmp  .name_loop
.names_done:

    mov  rax, r13
    add  rax, r14
    mov  r8, rax
    mov  rdi, [rel pw_buf]
    add  rdi, r12
    add  rdi, r14
    lea  rsi, [rel pw_dll_name]
    xor  r9, r9
.copy_dll:
    mov  al, [rsi + r9]
    mov  [rdi + r9], al
    test al, al
    jz   .dll_done
    inc  r9
    jmp  .copy_dll
.dll_done:
    add  r14, r9
    inc  r14
    mov  [rel pw_idata_size], r14
    lea  rcx, [r12+12]
    mov  edx, r8d
    call pw_put32

    xor  r15, r15
.tab_loop:
    cmp  r15, [rel pw_ext_count]
    jae  .tab_done
    lea  rbx, [rel pw_hint_rva]
    mov  r9, [rbx + r15*8]
    mov  r10, r15
    imul r10, 8
    mov  rcx, [rel pw_ilt_rva]
    sub  rcx, r13
    add  rcx, r12
    add  rcx, r10
    mov  rdx, r9
    call pw_put64
    mov  rcx, [rel pw_iat_rva]
    sub  rcx, r13
    add  rcx, r12
    add  rcx, r10
    mov  rdx, r9
    call pw_put64
    inc  r15
    jmp  .tab_loop
.tab_done:
    cmp  byte [rel pw_dll], 0
    je   .no_dll_tables
    call pw_dll_tables
.no_dll_tables:

    ; .idata sizes
    mov  rcx, 0x1C0+80+8
    mov  edx, dword [rel pw_idata_size]
    call pw_put32
    mov  rax, [rel pw_idata_size]
    mov  rcx, FILE_ALIGN
    call pw_align
    mov  rcx, 0x1C0+80+16
    mov  edx, eax
    call pw_put32

    ; SizeOfImage = align(IDATA_RVA + idata_size, SECT_ALIGN) + one page of margin
    mov  rax, [rel pw_idata_rva]
    add  rax, [rel pw_idata_size]
    mov  rcx, SECT_ALIGN
    call pw_align
    add  rax, SECT_ALIGN
    mov  rcx, 0xD0+56
    mov  edx, eax
    call pw_put32

    ; total file = idata_foff + align(idata_size, FILE_ALIGN)
    mov  rax, [rel pw_idata_size]
    mov  rcx, FILE_ALIGN
    call pw_align
    add  rax, [rel pw_idata_foff]
    mov  [rel pw_total], rax

    mov  rax, [rel pw_total]
    add  rsp, 40
    pop  rsi
    pop  rdi
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    pop  rbp
    ret

; ==============================================================================
; pw_dll_tables(): a DLL's export directory and base relocations, after the
; imports in .idata (r12 = its file offset, r13 = its RVA; pw_idata_size its
; length so far, grown here).
;   the export directory: 40 bytes, then the addresses of the functions --
;   each export's __ce_ entry -- the addresses of their names, sorted (the
;   loader looks them up by halving), the numbers that go with them, the
;   names, and the DLL's own name
;   the relocations: one block per page of .data, an entry for every word
;   that holds an address, so that the DLL may load anywhere
; ==============================================================================
pw_dll_tables:
    push rbx
    push rsi
    push rdi
    push r14
    push r15
    sub  rsp, 40
    call codegen_export_count
    mov  [rel pw_exp_n], rax
    ; the order of the names: a sort of their numbers, by insertion
    xor  ebx, ebx
.ord_init:
    cmp  rbx, [rel pw_exp_n]
    jae  .ord_sort
    lea  rax, [rel pw_exp_order]
    mov  [rax + rbx*8], rbx
    inc  rbx
    jmp  .ord_init
.ord_sort:
    mov  rbx, 1
.ord_i:
    cmp  rbx, [rel pw_exp_n]
    jae  .ord_done
    mov  rsi, rbx
.ord_j:
    test rsi, rsi
    jz   .ord_next
    lea  rax, [rel pw_exp_order]
    mov  rcx, [rax + rsi*8 - 8]
    mov  rdx, [rax + rsi*8]
    call pw_name_cmp                 ; eax = 1 when name rcx > name rdx
    test eax, eax
    jz   .ord_next
    lea  rax, [rel pw_exp_order]
    mov  rcx, [rax + rsi*8 - 8]
    mov  rdx, [rax + rsi*8]
    mov  [rax + rsi*8 - 8], rdx
    mov  [rax + rsi*8], rcx
    dec  rsi
    jmp  .ord_j
.ord_next:
    inc  rbx
    jmp  .ord_i
.ord_done:
    ; where it goes: after the imports, on 8 bytes; what follows cleared
    mov  rax, [rel pw_idata_size]
    add  rax, 7
    and  rax, -8
    mov  [rel pw_exp_dir], rax
    mov  rdi, [rel pw_buf]
    add  rdi, r12
    add  rdi, rax
    xor  eax, eax
    mov  rcx, 65536
    rep  stosb
    mov  rax, [rel pw_exp_dir]
    mov  r14, rax                    ; r14: the next free offset in .idata
    add  r14, 40
    mov  rbx, [rel pw_exp_n]
    ; AddressOfFunctions, AddressOfNames, AddressOfNameOrdinals
    mov  r15, r14                    ; the functions
    mov  rax, rbx
    shl  rax, 2
    add  r14, rax
    mov  rdi, r14                    ; the names' addresses
    add  r14, rax
    mov  rsi, r14                    ; the numbers
    mov  rax, rbx
    shl  rax, 1
    add  r14, rax
    add  r14, 3
    and  r14, -4
    ; the directory
    mov  rcx, r12
    add  rcx, [rel pw_exp_dir]
    push rcx
    ; Base 1, NumberOfFunctions, NumberOfNames
    add  rcx, 16
    mov  edx, 1
    call pw_put32
    pop  rcx
    push rcx
    lea  rcx, [rcx + 20]
    mov  edx, ebx
    call pw_put32
    pop  rcx
    push rcx
    lea  rcx, [rcx + 24]
    mov  edx, ebx
    call pw_put32
    pop  rcx
    push rcx
    lea  rcx, [rcx + 28]
    lea  rdx, [r13 + r15]
    call pw_put32
    pop  rcx
    push rcx
    lea  rcx, [rcx + 32]
    lea  rdx, [r13 + rdi]
    call pw_put32
    pop  rcx
    push rcx
    lea  rcx, [rcx + 36]
    lea  rdx, [r13 + rsi]
    call pw_put32
    pop  rcx
    ; each export, in the sorted order: its entry, its name, its number
    xor  ebx, ebx
.ex_loop:
    cmp  rbx, [rel pw_exp_n]
    jae  .ex_done
    lea  rax, [rel pw_exp_order]
    mov  rax, [rax + rbx*8]
    mov  [rsp + 32], rax             ; its number
    ; the name's address, then the name
    lea  rcx, [r12 + rdi]
    lea  rcx, [rcx + rbx*4]
    lea  rdx, [r13 + r14]
    call pw_put32
    mov  rcx, [rsp + 32]
    call codegen_export_name         ; rax = the name, rdx = its length
    push rsi
    push rdi
    mov  rsi, rax
    mov  rdi, [rel pw_buf]
    add  rdi, r12
    add  rdi, r14
    xor  ecx, ecx
.ex_cp:
    cmp  rcx, rdx
    jae  .ex_cpd
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    inc  rcx
    jmp  .ex_cp
.ex_cpd:
    mov  byte [rdi + rcx], 0
    ; the label of its entry: __ce_<name>
    lea  rdi, [rel pw_name]
    mov  byte [rdi], '_'
    mov  byte [rdi + 1], '_'
    mov  byte [rdi + 2], 'c'
    mov  byte [rdi + 3], 'e'
    mov  byte [rdi + 4], '_'
    xor  ecx, ecx
.ex_ln:
    cmp  rcx, rdx
    jae  .ex_lnd
    mov  al, [rsi + rcx]
    mov  [rdi + rcx + 5], al
    inc  rcx
    jmp  .ex_ln
.ex_lnd:
    mov  byte [rdi + rcx + 5], 0
    pop  rdi
    pop  rsi
    lea  r14, [r14 + rdx + 1]
    ; its number in the ordinal table: the slot it has in the functions,
    ; which is the sorted position too
    lea  rcx, [r12 + rsi]
    lea  rcx, [rcx + rbx*2]
    mov  edx, ebx
    call pw_put16
    ; the function: the entry's RVA
    push rdx
    lea  rcx, [rel pw_name]
    mov  rdx, 5
.ex_len:
    cmp  byte [rcx + rdx], 0
    je   .ex_len_ok
    inc  rdx
    jmp  .ex_len
.ex_len_ok:
    sub  rsp, 32
    call kasm_find_label
    add  rsp, 32
    pop  rdx
    cmp  eax, -1
    je   .ex_next
    sub  rsp, 32
    call kasm_label_addr
    add  rsp, 32
    add  rax, TEXT_RVA
    lea  rcx, [r12 + r15]
    lea  rcx, [rcx + rbx*4]
    mov  edx, eax
    call pw_put32
.ex_next:
    inc  rbx
    jmp  .ex_loop
.ex_done:
    ; the DLL's own name
    mov  rcx, [rel pw_exp_dir]
    add  rcx, r12
    add  rcx, 12
    lea  rdx, [r13 + r14]
    call pw_put32
    mov  rsi, [rel pw_dll_file]
    mov  rdi, [rel pw_buf]
    add  rdi, r12
    xor  ecx, ecx
.dn_cp:
    mov  al, [rsi + rcx]
    mov  [rdi + r14], al
    inc  rcx
    inc  r14
    test al, al
    jnz  .dn_cp
    mov  rax, r14
    sub  rax, [rel pw_exp_dir]
    mov  [rel pw_exp_size], rax
    ; DataDirectory[0], the exports
    mov  rcx, 0xD0+112
    mov  rdx, [rel pw_exp_dir]
    add  rdx, r13
    call pw_put32
    mov  rcx, 0xD0+112+4
    mov  edx, dword [rel pw_exp_size]
    call pw_put32
    ; ---- the base relocations ----
    add  r14, 3
    and  r14, -4
    mov  [rel pw_rel_dir], r14
    mov  qword [rel pw_rel_page], -1
    mov  qword [rel pw_rel_block], -1
    sub  rsp, 32
    call kasm_get_fixup_count
    add  rsp, 32
    mov  r15, rax
    xor  ebx, ebx
.rl_loop:
    cmp  rbx, r15
    jae  .rl_done
    mov  rcx, rbx
    sub  rsp, 32
    call kasm_get_fixup_kind
    add  rsp, 32
    cmp  eax, 6
    jne  .rl_next
    mov  rcx, rbx
    sub  rsp, 32
    call kasm_get_fixup_label
    add  rsp, 32
    cmp  eax, -1
    je   .rl_next
    mov  rcx, rbx
    sub  rsp, 32
    call kasm_get_fixup_at
    add  rsp, 32
    add  rax, [rel pw_data_rva]      ; the word's RVA
    mov  rsi, rax
    and  rax, -4096
    cmp  rax, [rel pw_rel_page]
    je   .rl_entry
    ; a new page: close the block, open another
    push rax
    call pw_rel_close
    pop  rax
    mov  [rel pw_rel_page], rax
    mov  [rel pw_rel_block], r14
    lea  rcx, [r12 + r14]
    mov  edx, eax
    call pw_put32
    add  r14, 8
.rl_entry:
    mov  rdx, rsi
    and  rdx, 4095
    or   rdx, 0xA000                 ; IMAGE_REL_BASED_DIR64
    lea  rcx, [r12 + r14]
    call pw_put16
    add  r14, 2
.rl_next:
    inc  rbx
    jmp  .rl_loop
.rl_done:
    call pw_rel_close
    mov  rax, r14
    sub  rax, [rel pw_rel_dir]
    mov  [rel pw_rel_size], rax
    mov  rcx, 0xD0+112+40            ; DataDirectory[5]
    mov  rdx, [rel pw_rel_dir]
    add  rdx, r13
    call pw_put32
    mov  rcx, 0xD0+112+44
    mov  edx, dword [rel pw_rel_size]
    call pw_put32
    mov  [rel pw_idata_size], r14
    add  rsp, 40
    pop  r15
    pop  r14
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; pw_rel_close(): the block being written gets its size, padded to four bytes
; (r12 = .idata in the file, r14 = the next free offset, grown)
pw_rel_close:
    mov  rax, [rel pw_rel_block]
    cmp  rax, -1
    je   .rc_out
    test r14, 2
    jz   .rc_even
    lea  rcx, [r12 + r14]
    xor  edx, edx
    call pw_put16
    add  r14, 2
.rc_even:
    mov  rdx, r14
    sub  rdx, [rel pw_rel_block]
    mov  rcx, [rel pw_rel_block]
    add  rcx, r12
    add  rcx, 4
    call pw_put32
.rc_out:
    ret

; pw_name_cmp(rcx, rdx = two exports' numbers) -> eax = 1 when the first's
; name sorts after the second's
pw_name_cmp:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rdx
    call codegen_export_name
    mov  rsi, rax
    mov  r13, rdx
    mov  rcx, r12
    call codegen_export_name
    mov  rdi, rax                    ; the second, rdx its length
    xor  ecx, ecx
.nc_l:
    cmp  rcx, r13
    jae  .nc_first_ended
    cmp  rcx, rdx
    jae  .nc_after                   ; the second ended first: it is shorter
    mov  al, [rsi + rcx]
    mov  bl, [rdi + rcx]
    cmp  al, bl
    ja   .nc_after
    jb   .nc_before
    inc  rcx
    jmp  .nc_l
.nc_first_ended:
.nc_before:
    xor  eax, eax
    jmp  .nc_out
.nc_after:
    mov  eax, 1
.nc_out:
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret
