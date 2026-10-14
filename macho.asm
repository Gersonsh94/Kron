; ==============================================================================
; MACHO - the executable for macOS on Apple silicon (Mach-O, arm64)
;
; karm has assembled the program with its code at 0x100004000 and .data on
; the next 16 KB page, as macOS maps them: code readable and executable,
; data readable and writable, never both. This writes the file around that
; image:
;
;   0x0000      the header and its load commands (the first page of __TEXT)
;   0x4000      the code                                          __TEXT
;   T           .data, then .bss in memory only                   __DATA
;   L           what dyld and the kernel read:                    __LINKEDIT
;                 rebase   every dq of .data that holds an address, so the
;                          image can be loaded anywhere (macOS requires it)
;                 bind     the two pointers the shim calls in the system
;                          library: pthread_create and pthread_detach
;                 exports  __mh_execute_header
;                 symbols  and their names
;                 the code signature: Apple silicon runs nothing unsigned,
;                 and an ad-hoc signature -- the SHA-256 of each 4 KB of the
;                 file, no certificate -- is what a linker writes and the
;                 kernel accepts for a program built on the machine or
;                 copied to it
;
; dyld starts the program at __mac_main (xarm's macOS shim), which lays out
; the stack Linux would and goes on to _start.
;
; macho_write(rcx = output, rdx = the program's name, 0-terminated)
;   -> rax = length of the file, 0 when the image cannot be made
; Windows x64 convention: rbx rsi rdi rbp r12-r15 are kept.
; ==============================================================================

bits 64
default rel

global macho_write

extern karm_build_image, karm_get_code, karm_get_code_len, karm_get_data_len
extern karm_get_bss_size, karm_label, karm_reloc_count, karm_reloc_at
extern karm_reloc_text

MO_BASE   equ 0x100000000
MO_PAGE   equ 0x4000
MO_CODE   equ 0x4000             ; where the code starts, in the file and in memory

section .bss
    mo_out       resq 1          ; the file being written
    mo_n         resq 1          ; its length so far
    mo_lc        resq 1          ; where the next load command goes
    mo_ncmds     resq 1
    mo_name      resq 1
    mo_code_len  resq 1
    mo_data_len  resq 1
    mo_bss_len   resq 1
    mo_text_sz   resq 1          ; __TEXT: header page + code, page-aligned
    mo_data_fsz  resq 1          ; __DATA in the file, page-aligned
    mo_data_vsz  resq 1          ; and in memory, with .bss
    mo_le_off    resq 1
    mo_rebase    resq 2          ; offset, size
    mo_bind      resq 2
    mo_export    resq 2
    mo_symoff    resq 1
    mo_stroff    resq 1
    mo_strsize   resq 1
    mo_sig_off   resq 1
    mo_sig_size  resq 1
    mo_entry     resq 1
    mo_got1      resq 1          ; offsets in __DATA of the two pointers
    mo_got2      resq 1
    mo_identlen  resq 1
    mo_ncode     resq 1          ; 4 KB pages the signature covers
    ; SHA-256
    mo_h         resd 8
    mo_v         resd 8          ; a b c d e f g h
    mo_w         resd 64
    mo_blk       resb 128
    mo_digest    resb 32

section .data
    mo_s_pagezero db "__PAGEZERO", 0
    mo_s_text     db "__TEXT", 0
    mo_s_data     db "__DATA", 0
    mo_s_linkedit db "__LINKEDIT", 0
    mo_s_textsec  db "__text", 0
    mo_s_datasec  db "__data", 0
    mo_s_bsssec   db "__bss", 0
    mo_s_dyld     db "/usr/lib/dyld", 0
    mo_s_libsys   db "/usr/lib/libSystem.B.dylib", 0
    mo_s_mh       db "__mh_execute_header", 0
    mo_s_create   db "_pthread_create", 0
    mo_s_detach   db "_pthread_detach", 0
    mo_l_main     db "__mac_main", 0
    mo_l_got1     db "__mac_got_create", 0
    mo_l_got2     db "__mac_got_detach", 0
    ; SHA-256: the first 32 bits of the fractional parts of the cube roots of
    ; the first 64 primes, and of the square roots of the first 8
    mo_k:
    dd 1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221
    dd 3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580
    dd 3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986
    dd 2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895
    dd 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037
    dd 2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344
    dd 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779
    dd 1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298
    mo_h0:
    dd 1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225

section .text

; ==============================================================================
; macho_write
; ==============================================================================
macho_write:
    push rbx
    push rsi
    push rdi
    push rbp
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    mov  [rel mo_out], rcx
    mov  [rel mo_name], rdx
    ; an address in a dq of the code cannot move with the image
    call karm_reloc_text
    test rax, rax
    jnz  .fail
    ; the image: code, padding to a page, .data
    call karm_build_image
    call karm_get_code_len
    mov  [rel mo_code_len], rax
    call karm_get_data_len
    mov  [rel mo_data_len], rax
    call karm_get_bss_size
    mov  [rel mo_bss_len], rax
    mov  rax, [rel mo_code_len]
    call mo_page
    add  rax, MO_CODE
    mov  [rel mo_text_sz], rax
    mov  rax, [rel mo_data_len]
    call mo_page
    mov  [rel mo_data_fsz], rax
    mov  rbx, rax
    mov  rax, [rel mo_bss_len]
    call mo_page
    add  rax, rbx
    mov  [rel mo_data_vsz], rax
    ; the labels the file needs: the entry and the two pointers to bind
    lea  rcx, [rel mo_l_main]
    call karm_label
    cmp  rax, -1
    je   .fail
    mov  rcx, MO_BASE
    sub  rax, rcx
    mov  [rel mo_entry], rax
    lea  rcx, [rel mo_l_got1]
    call karm_label
    cmp  rax, -1
    je   .fail
    call mo_data_off
    mov  [rel mo_got1], rax
    lea  rcx, [rel mo_l_got2]
    call karm_label
    cmp  rax, -1
    je   .fail
    call mo_data_off
    mov  [rel mo_got2], rax

    ; the header page, empty for now; the code and the data after it
    mov  rdi, [rel mo_out]
    xor  eax, eax
    mov  rcx, MO_CODE
    call mo_fill
    call karm_get_code
    mov  rsi, rax
    mov  rdi, [rel mo_out]
    add  rdi, MO_CODE
    mov  rcx, [rel mo_code_len]
    call mo_copy
    mov  rdi, [rel mo_out]
    add  rdi, MO_CODE
    add  rdi, [rel mo_code_len]
    mov  rcx, [rel mo_text_sz]
    sub  rcx, MO_CODE
    sub  rcx, [rel mo_code_len]
    xor  eax, eax
    call mo_fill
    ; .data: karm put it after the code padded to a page, as here
    call karm_get_code
    mov  rsi, rax
    mov  rax, [rel mo_code_len]
    call mo_page
    add  rsi, rax
    mov  rdi, [rel mo_out]
    add  rdi, [rel mo_text_sz]
    mov  rcx, [rel mo_data_len]
    call mo_copy
    mov  rdi, [rel mo_out]
    add  rdi, [rel mo_text_sz]
    add  rdi, [rel mo_data_len]
    mov  rcx, [rel mo_data_fsz]
    sub  rcx, [rel mo_data_len]
    xor  eax, eax
    call mo_fill
    mov  rax, [rel mo_text_sz]
    add  rax, [rel mo_data_fsz]
    mov  [rel mo_le_off], rax
    mov  [rel mo_n], rax

    ; ---- __LINKEDIT -----------------------------------------------------------
    ; rebase: type pointer, then for each address its offset in __DATA
    mov  rax, [rel mo_n]
    mov  [rel mo_rebase], rax
    call karm_reloc_count
    mov  r12, rax
    test r12, r12
    jz   .rb_done
    mov  al, 0x11                    ; REBASE_OPCODE_SET_TYPE_IMM | POINTER
    call mo_b
    xor  ebx, ebx
.rb:
    cmp  rbx, r12
    jae  .rb_end
    mov  rcx, rbx
    call karm_reloc_at
    mov  r13, rax
    mov  al, 0x22                    ; SET_SEGMENT_AND_OFFSET_ULEB, segment 2
    call mo_b
    mov  rax, r13
    call mo_uleb
    mov  al, 0x51                    ; DO_REBASE_IMM_TIMES 1
    call mo_b
    inc  rbx
    jmp  .rb
.rb_end:
    xor  eax, eax                    ; DONE
    call mo_b
.rb_done:
    call mo_align8
    mov  rax, [rel mo_n]
    sub  rax, [rel mo_rebase]
    mov  [rel mo_rebase + 8], rax
    ; bind: library 1, each symbol at its pointer
    mov  rax, [rel mo_n]
    mov  [rel mo_bind], rax
    mov  al, 0x11                    ; SET_DYLIB_ORDINAL_IMM 1
    call mo_b
    mov  al, 0x51                    ; SET_TYPE_IMM POINTER
    call mo_b
    mov  al, 0x40                    ; SET_SYMBOL_TRAILING_FLAGS_IMM 0
    call mo_b
    lea  rsi, [rel mo_s_create]
    call mo_str
    mov  al, 0x72                    ; SET_SEGMENT_AND_OFFSET_ULEB, segment 2
    call mo_b
    mov  rax, [rel mo_got1]
    call mo_uleb
    mov  al, 0x90                    ; DO_BIND
    call mo_b
    mov  al, 0x40
    call mo_b
    lea  rsi, [rel mo_s_detach]
    call mo_str
    mov  al, 0x72
    call mo_b
    mov  rax, [rel mo_got2]
    call mo_uleb
    mov  al, 0x90
    call mo_b
    xor  eax, eax                    ; DONE
    call mo_b
    call mo_align8
    mov  rax, [rel mo_n]
    sub  rax, [rel mo_bind]
    mov  [rel mo_bind + 8], rax
    ; exports: a trie with one name, __mh_execute_header at offset 0
    mov  rax, [rel mo_n]
    mov  [rel mo_export], rax
    xor  eax, eax                    ; root: not a symbol
    call mo_b
    mov  al, 1                       ; one edge
    call mo_b
    lea  rsi, [rel mo_s_mh]
    call mo_str
    mov  al, 23                      ; the child node, from the trie's start
    call mo_b
    mov  al, 2                       ; a symbol: flags 0, offset 0
    call mo_b
    xor  eax, eax
    call mo_b
    call mo_b
    call mo_b                        ; no edges
    call mo_align8
    mov  rax, [rel mo_n]
    sub  rax, [rel mo_export]
    mov  [rel mo_export + 8], rax
    ; symbols: __mh_execute_header, then the two the program takes from the
    ; system library. Their names: " ", 0, then each one
    mov  rax, [rel mo_n]
    mov  [rel mo_symoff], rax
    mov  eax, 2                      ; name at 2
    call mo_d
    mov  al, 0x0F                    ; N_SECT | N_EXT
    call mo_b
    mov  al, 1                       ; section 1, __text
    call mo_b
    mov  eax, 0x10                   ; REFERENCED_DYNAMICALLY
    call mo_w16
    mov  rax, MO_BASE
    call mo_q
    mov  eax, 22                     ; 2 + 20
    call mo_d
    mov  al, 1                       ; N_UNDF | N_EXT
    call mo_b
    xor  eax, eax
    call mo_b
    mov  eax, 0x100                  ; library ordinal 1
    call mo_w16
    xor  eax, eax
    call mo_q
    mov  eax, 38                     ; 22 + 16
    call mo_d
    mov  al, 1
    call mo_b
    xor  eax, eax
    call mo_b
    mov  eax, 0x100
    call mo_w16
    xor  eax, eax
    call mo_q
    mov  rax, [rel mo_n]
    mov  [rel mo_stroff], rax
    mov  al, ' '
    call mo_b
    xor  eax, eax
    call mo_b
    lea  rsi, [rel mo_s_mh]
    call mo_str
    lea  rsi, [rel mo_s_create]
    call mo_str
    lea  rsi, [rel mo_s_detach]
    call mo_str
    call mo_align8
    mov  rax, [rel mo_n]
    sub  rax, [rel mo_stroff]
    mov  [rel mo_strsize], rax
    ; the signature goes at a multiple of 16; its size is known now
    mov  rax, [rel mo_n]
    add  rax, 15
    and  rax, -16
    mov  rcx, rax
    sub  rcx, [rel mo_n]
    mov  rdi, [rel mo_out]
    add  rdi, [rel mo_n]
    xor  eax, eax
    call mo_fill
    mov  rax, [rel mo_n]
    add  rax, 15
    and  rax, -16
    mov  [rel mo_n], rax
    mov  [rel mo_sig_off], rax
    add  rax, 4095
    shr  rax, 12
    mov  [rel mo_ncode], rax
    mov  rsi, [rel mo_name]
    xor  ecx, ecx
.idl:
    cmp  byte [rsi + rcx], 0
    je   .idd
    inc  rcx
    jmp  .idl
.idd:
    inc  rcx                         ; with its 0
    add  rcx, 15
    and  rcx, -16
    mov  [rel mo_identlen], rcx
    ; 24 (super blob and its index) + 88 (code directory) + name + hashes
    mov  rax, [rel mo_ncode]
    shl  rax, 5
    add  rax, 112
    add  rax, rcx
    mov  [rel mo_sig_size], rax

    ; ---- the header and the load commands ----------------------------------
    call mo_commands

    ; ---- the signature: hashes of every 4 KB before it, header included -----
    call mo_signature
    mov  rax, [rel mo_n]
    jmp  .out
.fail:
    xor  eax, eax
.out:
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; mo_data_off(rax = address of a .data label) -> rax = its offset in __DATA
mo_data_off:
    mov  rcx, MO_BASE
    sub  rax, rcx
    sub  rax, [rel mo_text_sz]
    ret

; mo_page(rax) -> rax rounded up to 16 KB
mo_page:
    add  rax, 16383
    and  rax, -16384
    ret

; ==============================================================================
; THE LOAD COMMANDS
; ==============================================================================
mo_commands:
    push rbx
    push r12
    mov  rax, [rel mo_out]
    add  rax, 32
    mov  [rel mo_lc], rax
    mov  qword [rel mo_ncmds], 0
    ; __PAGEZERO: the first 4 GB, no access
    mov  eax, 0x19                   ; LC_SEGMENT_64
    mov  ecx, 72
    call mo_cmd
    lea  rsi, [rel mo_s_pagezero]
    call mo_lc_name
    xor  eax, eax
    call mo_lc_q                     ; vmaddr
    mov  rax, MO_BASE
    call mo_lc_q                     ; vmsize
    xor  eax, eax
    call mo_lc_q                     ; fileoff
    call mo_lc_q                     ; filesize
    call mo_lc_d                     ; maxprot
    call mo_lc_d                     ; initprot
    call mo_lc_d                     ; nsects
    call mo_lc_d                     ; flags
    ; __TEXT: the header page and the code, read and execute
    mov  eax, 0x19
    mov  ecx, 152
    call mo_cmd
    lea  rsi, [rel mo_s_text]
    call mo_lc_name
    mov  rax, MO_BASE
    call mo_lc_q
    mov  rax, [rel mo_text_sz]
    call mo_lc_q
    xor  eax, eax
    call mo_lc_q
    mov  rax, [rel mo_text_sz]
    call mo_lc_q
    mov  eax, 5
    call mo_lc_d
    call mo_lc_d
    mov  eax, 1
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    lea  rsi, [rel mo_s_textsec]     ; section __text
    call mo_lc_name
    lea  rsi, [rel mo_s_text]
    call mo_lc_name
    mov  rax, 0x100004000
    call mo_lc_q                     ; addr
    mov  rax, [rel mo_code_len]
    call mo_lc_q                     ; size
    mov  eax, MO_CODE
    call mo_lc_d                     ; offset
    mov  eax, 2
    call mo_lc_d                     ; align 2^2
    xor  eax, eax
    call mo_lc_d                     ; reloff
    call mo_lc_d                     ; nreloc
    mov  eax, 0x80000400             ; PURE_INSTRUCTIONS | SOME_INSTRUCTIONS
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    call mo_lc_d
    call mo_lc_d
    ; __DATA: .data and .bss, read and write
    mov  eax, 0x19
    mov  ecx, 232
    call mo_cmd
    lea  rsi, [rel mo_s_data]
    call mo_lc_name
    mov  rax, MO_BASE
    add  rax, [rel mo_text_sz]
    call mo_lc_q
    mov  rax, [rel mo_data_vsz]
    call mo_lc_q
    mov  rax, [rel mo_text_sz]
    call mo_lc_q
    mov  rax, [rel mo_data_fsz]
    call mo_lc_q
    mov  eax, 3
    call mo_lc_d
    call mo_lc_d
    mov  eax, 2
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    lea  rsi, [rel mo_s_datasec]     ; section __data
    call mo_lc_name
    lea  rsi, [rel mo_s_data]
    call mo_lc_name
    mov  rax, MO_BASE
    add  rax, [rel mo_text_sz]
    call mo_lc_q
    mov  rax, [rel mo_data_len]
    call mo_lc_q
    mov  rax, [rel mo_text_sz]
    call mo_lc_d
    mov  eax, 4                      ; align 2^4
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    call mo_lc_d
    call mo_lc_d                     ; S_REGULAR
    call mo_lc_d
    call mo_lc_d
    call mo_lc_d
    lea  rsi, [rel mo_s_bsssec]      ; section __bss
    call mo_lc_name
    lea  rsi, [rel mo_s_data]
    call mo_lc_name
    mov  rax, MO_BASE
    add  rax, [rel mo_text_sz]
    add  rax, [rel mo_data_fsz]
    call mo_lc_q
    mov  rax, [rel mo_bss_len]
    call mo_lc_q
    xor  eax, eax
    call mo_lc_d                     ; offset: none, it is zeros
    mov  eax, 4
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    call mo_lc_d
    mov  eax, 1                      ; S_ZEROFILL
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    call mo_lc_d
    call mo_lc_d
    ; __LINKEDIT
    mov  eax, 0x19
    mov  ecx, 72
    call mo_cmd
    lea  rsi, [rel mo_s_linkedit]
    call mo_lc_name
    mov  rax, MO_BASE
    add  rax, [rel mo_text_sz]
    add  rax, [rel mo_data_vsz]
    call mo_lc_q
    mov  rax, [rel mo_sig_off]
    add  rax, [rel mo_sig_size]
    sub  rax, [rel mo_le_off]
    mov  rbx, rax
    call mo_page
    call mo_lc_q                     ; vmsize
    mov  rax, [rel mo_le_off]
    call mo_lc_q
    mov  rax, rbx
    call mo_lc_q                     ; filesize
    mov  eax, 1
    call mo_lc_d
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d
    call mo_lc_d
    ; LC_DYLD_INFO_ONLY
    mov  eax, 0x80000022
    mov  ecx, 48
    call mo_cmd
    mov  rax, [rel mo_rebase]
    call mo_lc_d
    mov  rax, [rel mo_rebase + 8]
    call mo_lc_d
    mov  rax, [rel mo_bind]
    call mo_lc_d
    mov  rax, [rel mo_bind + 8]
    call mo_lc_d
    xor  eax, eax
    call mo_lc_d                     ; weak bind
    call mo_lc_d
    call mo_lc_d                     ; lazy bind
    call mo_lc_d
    mov  rax, [rel mo_export]
    call mo_lc_d
    mov  rax, [rel mo_export + 8]
    call mo_lc_d
    ; LC_SYMTAB
    mov  eax, 2
    mov  ecx, 24
    call mo_cmd
    mov  rax, [rel mo_symoff]
    call mo_lc_d
    mov  eax, 3
    call mo_lc_d
    mov  rax, [rel mo_stroff]
    call mo_lc_d
    mov  rax, [rel mo_strsize]
    call mo_lc_d
    ; LC_DYSYMTAB: no locals, one defined, two undefined
    mov  eax, 0x0B
    mov  ecx, 80
    call mo_cmd
    xor  eax, eax
    call mo_lc_d                     ; ilocalsym
    call mo_lc_d                     ; nlocalsym
    call mo_lc_d                     ; iextdefsym
    mov  eax, 1
    call mo_lc_d                     ; nextdefsym
    call mo_lc_d                     ; iundefsym
    mov  eax, 2
    call mo_lc_d                     ; nundefsym
    xor  eax, eax
    mov  ebx, 12
.dys:
    call mo_lc_d
    dec  ebx
    jnz  .dys
    ; LC_LOAD_DYLINKER
    mov  eax, 0x0E
    mov  ecx, 32
    call mo_cmd
    mov  eax, 12
    call mo_lc_d
    lea  rsi, [rel mo_s_dyld]
    mov  ecx, 20
    call mo_lc_str
    ; LC_UUID: from the code's first bytes and the size, the same for the
    ; same program
    mov  eax, 0x1B
    mov  ecx, 24
    call mo_cmd
    mov  rsi, [rel mo_out]
    mov  rax, [rsi + MO_CODE]
    xor  rax, [rel mo_code_len]
    call mo_lc_q
    mov  rax, [rel mo_data_len]
    shl  rax, 20
    xor  rax, [rel mo_bss_len]
    mov  rcx, 0x4000000000000000     ; version 4 bits, as a UUID has
    or   rax, rcx
    call mo_lc_q
    ; LC_BUILD_VERSION: macOS 11, the first on Apple silicon
    mov  eax, 0x32
    mov  ecx, 24
    call mo_cmd
    mov  eax, 1                      ; PLATFORM_MACOS
    call mo_lc_d
    mov  eax, 0x000B0000             ; minos 11.0
    call mo_lc_d
    call mo_lc_d                     ; sdk 11.0
    xor  eax, eax
    call mo_lc_d                     ; no tools
    ; LC_MAIN
    mov  eax, 0x80000028
    mov  ecx, 24
    call mo_cmd
    mov  rax, [rel mo_entry]
    call mo_lc_q
    xor  eax, eax
    call mo_lc_q
    ; LC_LOAD_DYLIB libSystem
    mov  eax, 0x0C
    mov  ecx, 56
    call mo_cmd
    mov  eax, 24
    call mo_lc_d                     ; name offset
    mov  eax, 2
    call mo_lc_d                     ; timestamp
    mov  eax, 0x05270000             ; current version 1319
    call mo_lc_d
    mov  eax, 0x00010000             ; compatibility 1.0
    call mo_lc_d
    lea  rsi, [rel mo_s_libsys]
    mov  ecx, 32
    call mo_lc_str
    ; LC_CODE_SIGNATURE
    mov  eax, 0x1D
    mov  ecx, 16
    call mo_cmd
    mov  rax, [rel mo_sig_off]
    call mo_lc_d
    mov  rax, [rel mo_sig_size]
    call mo_lc_d
    ; the header itself
    mov  rdi, [rel mo_out]
    mov  dword [rdi], 0xFEEDFACF     ; MH_MAGIC_64
    mov  dword [rdi + 4], 0x0100000C ; CPU_TYPE_ARM64
    mov  dword [rdi + 8], 0          ; all subtypes
    mov  dword [rdi + 12], 2         ; MH_EXECUTE
    mov  rax, [rel mo_ncmds]
    mov  [rdi + 16], eax
    mov  rax, [rel mo_lc]
    sub  rax, rdi
    sub  rax, 32
    mov  [rdi + 20], eax
    mov  dword [rdi + 24], 0x00200085 ; NOUNDEFS DYLDLINK TWOLEVEL PIE
    mov  dword [rdi + 28], 0
    pop  r12
    pop  rbx
    ret

; mo_cmd(eax = command, ecx = its size): starts one
mo_cmd:
    push rax
    mov  rax, [rel mo_ncmds]
    inc  rax
    mov  [rel mo_ncmds], rax
    pop  rax
    call mo_lc_d
    mov  eax, ecx
    call mo_lc_d
    ret

; mo_lc_d(eax) / mo_lc_q(rax): the next 4 or 8 bytes of the load commands
mo_lc_d:
    push rdi
    mov  rdi, [rel mo_lc]
    mov  [rdi], eax
    add  rdi, 4
    mov  [rel mo_lc], rdi
    pop  rdi
    ret
mo_lc_q:
    push rdi
    mov  rdi, [rel mo_lc]
    mov  [rdi], rax
    add  rdi, 8
    mov  [rel mo_lc], rdi
    pop  rdi
    ret
; mo_lc_name(rsi): a name in 16 bytes, padded with zeros
mo_lc_name:
    mov  ecx, 16
    jmp  mo_lc_str
; mo_lc_str(rsi = text, ecx = bytes): the text, padded with zeros to ecx
mo_lc_str:
    push rdi
    push rbx
    mov  rdi, [rel mo_lc]
    xor  ebx, ebx
.l:
    cmp  ebx, ecx
    jae  .d
    mov  al, [rsi]
    test al, al
    jz   .z
    mov  [rdi + rbx], al
    inc  rsi
    inc  ebx
    jmp  .l
.z:
    mov  [rdi + rbx], al             ; al is 0 here
    inc  ebx
    jmp  .l
.d:
    add  rdi, rcx
    mov  [rel mo_lc], rdi
    pop  rbx
    pop  rdi
    ret

; ==============================================================================
; THE CODE SIGNATURE (ad-hoc): a super blob holding one code directory
; ==============================================================================
mo_signature:
    push rbx
    push r12
    push r13
    push r14
    mov  rdi, [rel mo_out]
    add  rdi, [rel mo_sig_off]
    mov  r12, rdi
    ; the super blob: magic, length, one index (code directory at 24)
    mov  eax, 0xFADE0CC0
    call mo_be32
    mov  rax, [rel mo_sig_size]
    call mo_be32
    mov  eax, 1
    call mo_be32
    xor  eax, eax
    call mo_be32                     ; CSSLOT_CODEDIRECTORY
    mov  eax, 24
    call mo_be32
    xor  eax, eax
    call mo_be32                     ; padding to 24
    ; the code directory, version 0x20400
    mov  r13, rdi                    ; its start
    mov  eax, 0xFADE0C02
    call mo_be32
    mov  rax, [rel mo_sig_size]
    sub  rax, 24
    call mo_be32                     ; length
    mov  eax, 0x20400
    call mo_be32                     ; version
    mov  eax, 0x20002
    call mo_be32                     ; flags: adhoc, linker-signed
    mov  rax, [rel mo_identlen]
    add  rax, 88
    call mo_be32                     ; hashOffset
    mov  eax, 88
    call mo_be32                     ; identOffset
    xor  eax, eax
    call mo_be32                     ; nSpecialSlots
    mov  rax, [rel mo_ncode]
    call mo_be32                     ; nCodeSlots
    mov  rax, [rel mo_sig_off]
    call mo_be32                     ; codeLimit
    mov  byte [rdi], 32              ; hashSize
    mov  byte [rdi + 1], 2           ; hashType: SHA-256
    mov  byte [rdi + 2], 0           ; platform
    mov  byte [rdi + 3], 12          ; pageSize: 4 KB
    add  rdi, 4
    xor  eax, eax
    call mo_be32                     ; spare2
    call mo_be32                     ; scatterOffset
    call mo_be32                     ; teamOffset
    call mo_be32                     ; spare3
    call mo_be32                     ; codeLimit64
    call mo_be32
    call mo_be32                     ; execSegBase
    call mo_be32
    call mo_be32                     ; execSegLimit: __TEXT
    mov  rax, [rel mo_text_sz]
    call mo_be32
    xor  eax, eax
    call mo_be32                     ; execSegFlags: the main binary
    mov  eax, 1
    call mo_be32
    ; the identifier, padded
    mov  rsi, [rel mo_name]
    mov  rcx, [rel mo_identlen]
    xor  ebx, ebx
.id:
    cmp  rbx, rcx
    jae  .idd
    mov  al, [rsi]
    mov  [rdi + rbx], al
    test al, al
    jz   .idz
    inc  rsi
.idz:
    inc  rbx
    jmp  .id
.idd:
    add  rdi, rcx
    ; one hash per 4 KB of the file before the signature
    xor  r14, r14
.page:
    cmp  r14, [rel mo_ncode]
    jae  .done
    mov  rsi, [rel mo_out]
    mov  rax, r14
    shl  rax, 12
    add  rsi, rax
    mov  rcx, [rel mo_sig_off]
    sub  rcx, rax
    cmp  rcx, 4096
    jbe  .len
    mov  rcx, 4096
.len:
    push rdi
    call mo_sha256
    pop  rdi
    lea  rsi, [rel mo_digest]
    mov  rcx, 32
    call mo_copy
    add  rdi, 32
    inc  r14
    jmp  .page
.done:
    mov  rax, [rel mo_sig_off]
    add  rax, [rel mo_sig_size]
    mov  [rel mo_n], rax
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; mo_be32(eax): four bytes at rdi, the most significant first; rdi moves
mo_be32:
    push rcx
    mov  ecx, eax
    shr  ecx, 24
    mov  [rdi], cl
    mov  ecx, eax
    shr  ecx, 16
    mov  [rdi + 1], cl
    mov  ecx, eax
    shr  ecx, 8
    mov  [rdi + 2], cl
    mov  [rdi + 3], al
    add  rdi, 4
    pop  rcx
    ret

; ==============================================================================
; SHA-256 of rcx bytes at rsi, into mo_digest
; ==============================================================================
mo_sha256:
    push rbx
    push r12
    push r13
    push r14
    mov  r12, rsi
    mov  r13, rcx                    ; left
    mov  r14, rcx                    ; the whole length
    lea  rsi, [rel mo_h0]
    lea  rdi, [rel mo_h]
    mov  rcx, 32
    call mo_copy
.full:
    cmp  r13, 64
    jb   .last
    mov  rsi, r12
    call mo_sha_block
    add  r12, 64
    sub  r13, 64
    jmp  .full
.last:
    ; the rest, 0x80, zeros, and the length in bits at the end of one or two
    ; blocks
    lea  rdi, [rel mo_blk]
    xor  eax, eax
    mov  rcx, 128
    call mo_fill
    mov  rsi, r12
    lea  rdi, [rel mo_blk]
    mov  rcx, r13
    call mo_copy
    lea  rdi, [rel mo_blk]
    mov  al, 0x80
    mov  [rdi + r13], al
    mov  rbx, 64
    cmp  r13, 56
    jb   .one
    mov  rbx, 128
.one:
    mov  rax, r14
    shl  rax, 3
    mov  rcx, 8
.blen:
    dec  rbx
    mov  [rdi + rbx], al
    shr  rax, 8
    dec  rcx
    jnz  .blen
    add  rbx, 8
    lea  rsi, [rel mo_blk]
    call mo_sha_block
    cmp  rbx, 128
    jne  .out
    lea  rsi, [rel mo_blk + 64]
    call mo_sha_block
.out:
    ; the digest, each word most significant byte first
    lea  rsi, [rel mo_h]
    lea  rdi, [rel mo_digest]
    xor  ecx, ecx
.dg:
    mov  eax, [rsi + rcx*4]
    call mo_be32
    inc  ecx
    cmp  ecx, 8
    jb   .dg
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; mo_sha_block(rsi = 64 bytes): one block into mo_h
mo_sha_block:
    push rbx
    push rdi
    push r12
    push r13
    lea  rdi, [rel mo_w]
    xor  ecx, ecx
.load:
    movzx eax, byte [rsi]
    shl  eax, 8
    movzx ebx, byte [rsi + 1]
    or   eax, ebx
    shl  eax, 8
    movzx ebx, byte [rsi + 2]
    or   eax, ebx
    shl  eax, 8
    movzx ebx, byte [rsi + 3]
    or   eax, ebx
    mov  [rdi + rcx*4], eax
    add  rsi, 4
    inc  ecx
    cmp  ecx, 16
    jb   .load
.sched:
    ; w[i] = w[i-16] + s0(w[i-15]) + w[i-7] + s1(w[i-2])
    mov  eax, [rdi + rcx*4 - 60]
    mov  ebx, eax
    ror  ebx, 7
    mov  edx, eax
    ror  edx, 18
    xor  ebx, edx
    shr  eax, 3
    xor  ebx, eax
    mov  eax, [rdi + rcx*4 - 8]
    mov  edx, eax
    ror  edx, 17
    mov  r8d, eax
    ror  r8d, 19
    xor  edx, r8d
    shr  eax, 10
    xor  edx, eax
    add  ebx, edx
    add  ebx, [rdi + rcx*4 - 64]
    add  ebx, [rdi + rcx*4 - 28]
    mov  [rdi + rcx*4], ebx
    inc  ecx
    cmp  ecx, 64
    jb   .sched
    ; a..h from h
    lea  rsi, [rel mo_h]
    lea  rdi, [rel mo_v]
    mov  rcx, 32
    call mo_copy
    lea  r12, [rel mo_v]
    lea  r13, [rel mo_k]
    xor  ecx, ecx
.round:
    ; t1 = h + S1(e) + ch(e, f, g) + k[i] + w[i]
    mov  eax, [r12 + 16]             ; e
    mov  ebx, eax
    ror  ebx, 6
    mov  edx, eax
    ror  edx, 11
    xor  ebx, edx
    mov  edx, eax
    ror  edx, 25
    xor  ebx, edx                    ; S1
    mov  edx, eax
    and  edx, [r12 + 20]             ; e & f
    not  eax
    and  eax, [r12 + 24]             ; ~e & g
    xor  edx, eax                    ; ch
    add  ebx, edx
    add  ebx, [r12 + 28]             ; + h
    add  ebx, [r13 + rcx*4]          ; + k
    lea  rdx, [rel mo_w]
    add  ebx, [rdx + rcx*4]          ; + w  -> t1 in ebx
    ; t2 = S0(a) + maj(a, b, c)
    mov  eax, [r12]                  ; a
    mov  edx, eax
    ror  edx, 2
    mov  r8d, eax
    ror  r8d, 13
    xor  edx, r8d
    mov  r8d, eax
    ror  r8d, 22
    xor  edx, r8d                    ; S0
    mov  r8d, eax
    and  r8d, [r12 + 4]              ; a & b
    mov  r9d, eax
    and  r9d, [r12 + 8]              ; a & c
    xor  r8d, r9d
    mov  r9d, [r12 + 4]
    and  r9d, [r12 + 8]              ; b & c
    xor  r8d, r9d                    ; maj
    add  edx, r8d                    ; t2
    ; the shift: h g f e d c b a
    mov  eax, [r12 + 24]
    mov  [r12 + 28], eax
    mov  eax, [r12 + 20]
    mov  [r12 + 24], eax
    mov  eax, [r12 + 16]
    mov  [r12 + 20], eax
    mov  eax, [r12 + 12]
    add  eax, ebx
    mov  [r12 + 16], eax             ; e = d + t1
    mov  eax, [r12 + 8]
    mov  [r12 + 12], eax
    mov  eax, [r12 + 4]
    mov  [r12 + 8], eax
    mov  eax, [r12]
    mov  [r12 + 4], eax
    add  ebx, edx
    mov  [r12], ebx                  ; a = t1 + t2
    inc  ecx
    cmp  ecx, 64
    jb   .round
    ; h += a..h
    lea  rsi, [rel mo_h]
    xor  ecx, ecx
.add:
    mov  eax, [r12 + rcx*4]
    mov  edx, [rsi + rcx*4]
    add  edx, eax
    mov  [rsi + rcx*4], edx
    inc  ecx
    cmp  ecx, 8
    jb   .add
    pop  r13
    pop  r12
    pop  rdi
    pop  rbx
    ret

; ==============================================================================
; OUTPUT HELPERS
; ==============================================================================
; mo_b(al) / mo_w16(ax) / mo_d(eax) / mo_q(rax): appended to the file
mo_b:
    push rdi
    push rcx
    mov  rcx, [rel mo_n]
    mov  rdi, [rel mo_out]
    mov  [rdi + rcx], al
    inc  rcx
    mov  [rel mo_n], rcx
    pop  rcx
    pop  rdi
    ret
mo_w16:
    push rdi
    push rcx
    mov  rcx, [rel mo_n]
    mov  rdi, [rel mo_out]
    mov  [rdi + rcx], ax
    add  rcx, 2
    mov  [rel mo_n], rcx
    pop  rcx
    pop  rdi
    ret
mo_d:
    push rdi
    push rcx
    mov  rcx, [rel mo_n]
    mov  rdi, [rel mo_out]
    mov  [rdi + rcx], eax
    add  rcx, 4
    mov  [rel mo_n], rcx
    pop  rcx
    pop  rdi
    ret
mo_q:
    push rdi
    push rcx
    mov  rcx, [rel mo_n]
    mov  rdi, [rel mo_out]
    mov  [rdi + rcx], rax
    add  rcx, 8
    mov  [rel mo_n], rcx
    pop  rcx
    pop  rdi
    ret
; mo_uleb(rax): unsigned LEB128
mo_uleb:
    push rbx
    mov  rbx, rax
.l:
    mov  rax, rbx
    and  eax, 0x7F
    shr  rbx, 7
    test rbx, rbx
    jz   .last
    or   eax, 0x80
    call mo_b
    jmp  .l
.last:
    call mo_b
    pop  rbx
    ret
; mo_str(rsi): a name and its 0
mo_str:
.l:
    mov  al, [rsi]
    call mo_b
    inc  rsi
    test al, al
    jnz  .l
    ret
; mo_align8: zeros up to a multiple of 8
mo_align8:
.l:
    mov  rax, [rel mo_n]
    test al, 7
    jz   .d
    xor  eax, eax
    call mo_b
    jmp  .l
.d:
    ret
; mo_fill(rdi, rcx bytes, al)
mo_fill:
    test rcx, rcx
    jz   .d
.l:
    mov  [rdi], al
    inc  rdi
    dec  rcx
    jnz  .l
.d:
    ret
; mo_copy(rsi -> rdi, rcx bytes); rsi and rdi are kept
mo_copy:
    push rsi
    push rdi
    push rcx
    test rcx, rcx
    jz   .d
.l:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jnz  .l
.d:
    pop  rcx
    pop  rdi
    pop  rsi
    ret
