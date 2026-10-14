; ==============================================================================
; KRN WRITER - Kron eXecutable container
; Takes the bytes kasm produced and wraps them in the KRN format described in
; KRN_FORMAT.md: a 128-byte header, a section table, a string pool, the section
; data, and a signature block.
;
; This is Kron's own executable format. Nothing here is inherited from PE or
; ELF; the layout is the one the specification defines.
; ==============================================================================

bits 64
default rel

%include "kron_types.inc"

; --- header field offsets ---
%define KRN_MAGIC            0x214E524B   ; 'KRN!' little-endian
%define KRN_HDR_SIZE         128
%define KRN_SECT_ENTRY       32
%define KRN_REQ_ENTRY        32
%define KRN_EXP_ENTRY        24

%define KRN_ARCH_X86_64      1
%define KRN_ARCH_ARM64       2
%define KRN_ARCH_RISCV64     3

%define KRN_KIND_KERNEL      1
%define KRN_KIND_DRIVER      2
%define KRN_KIND_APPLICATION 3
%define KRN_KIND_LIBRARY     4

%define KRN_SEC_CODE         1
%define KRN_SEC_DATA         2
%define KRN_SEC_BSS          3

%define JSIG_MAGIC           0x4749534A   ; 'JSIG' little-endian
%define JSIG_ALG_DIGEST      1            ; integrity only, no key

section .bss
    krn_buf        resb 2097152      ; the file being assembled
    krn_len        resq 1
    krn_kind       resq 1
    krn_ring       resq 1
    krn_caps       resq 1
    krn_strpool    resb 4096
    krn_strlen     resq 1

section .data
    sec_name_code: db ".code", 0
    sec_name_data: db ".data", 0
    sec_name_bss:  db ".bss", 0

section .text

global krn_init
global krn_set_kind
global krn_set_ring
global krn_set_caps
global krn_build
global krn_get_image
global krn_get_size

extern kasm_get_code
extern kasm_get_code_size
extern kasm_get_data
extern kasm_get_data_size
extern kasm_get_bss_size

; ==============================================================================
krn_init:
    mov  qword [rel krn_len], 0
    mov  qword [rel krn_kind], KRN_KIND_APPLICATION
    mov  qword [rel krn_ring], 3
    mov  qword [rel krn_caps], 0
    mov  qword [rel krn_strlen], 1        ; offset 0 means "no name"
    mov  byte  [rel krn_strpool], 0
    ret

krn_set_kind:
    mov  [rel krn_kind], rcx
    ret
krn_set_ring:
    mov  [rel krn_ring], rcx
    ret
krn_set_caps:
    mov  [rel krn_caps], rcx
    ret
krn_get_image:
    lea  rax, [rel krn_buf]
    ret
krn_get_size:
    mov  rax, [rel krn_len]
    ret

; ==============================================================================
; krn_add_string(rcx = zero-terminated name) -> rax = offset in the pool
; ==============================================================================
krn_add_string:
    push rsi
    push rdi
    mov  rsi, rcx
    mov  rax, [rel krn_strlen]
    lea  rdi, [rel krn_strpool]
    add  rdi, rax
    push rax
.l:
    mov  cl, [rsi]
    mov  [rdi], cl
    test cl, cl
    jz   .d
    inc  rsi
    inc  rdi
    jmp  .l
.d:
    inc  rdi
    lea  rcx, [rel krn_strpool]
    sub  rdi, rcx
    mov  [rel krn_strlen], rdi
    pop  rax
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; krn_build() -> rax = total file length
;
; Layout, in the order the specification lays it out:
;   header | section table | string pool | section data | signature
; ==============================================================================
krn_build:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15

    lea  rbx, [rel krn_buf]

    ; --- zero the header ---
    xor  rcx, rcx
.clr:
    cmp  rcx, KRN_HDR_SIZE
    jae  .clr_done
    mov  byte [rbx + rcx], 0
    inc  rcx
    jmp  .clr
.clr_done:

    ; --- names into the string pool ---
    lea  rcx, [rel sec_name_code]
    call krn_add_string
    mov  r12, rax                        ; offset of ".code"
    lea  rcx, [rel sec_name_data]
    call krn_add_string
    mov  r13, rax                        ; offset of ".data"
    lea  rcx, [rel sec_name_bss]
    call krn_add_string
    mov  r14, rax                        ; offset of ".bss"

    ; --- where each part of the file starts ---
    ; three sections follow the header
    mov  rsi, KRN_HDR_SIZE
    mov  rdi, rsi
    add  rdi, KRN_SECT_ENTRY * 3         ; string pool offset
    mov  r15, rdi
    add  r15, [rel krn_strlen]
    ; align the section data to 16
    add  r15, 15
    and  r15, -16                        ; file offset of the first section body

    ; --- header fields ---
    mov  dword [rbx + 0x00], KRN_MAGIC
    mov  word  [rbx + 0x04], 1           ; format version
    mov  word  [rbx + 0x06], KRN_HDR_SIZE
    mov  word  [rbx + 0x08], KRN_ARCH_X86_64
    mov  rax, [rel krn_kind]
    mov  word  [rbx + 0x0A], ax
    mov  rax, [rel krn_ring]
    mov  word  [rbx + 0x0C], ax
    mov  word  [rbx + 0x0E], 0           ; flags

    ; entry point: the code section starts at virtual address 0x1000
    mov  qword [rbx + 0x10], 0x1000
    mov  qword [rbx + 0x18], 0x400000    ; image base
    mov  qword [rbx + 0x28], 0x100000    ; stack reservation
    mov  qword [rbx + 0x30], 0           ; heap: the program manages its own

    mov  dword [rbx + 0x38], 3           ; section count
    mov  dword [rbx + 0x3C], KRN_HDR_SIZE
    mov  dword [rbx + 0x40], 0           ; requirement count
    mov  dword [rbx + 0x44], 0
    mov  dword [rbx + 0x48], 0           ; export count
    mov  dword [rbx + 0x4C], 0
    mov  eax, edi
    mov  dword [rbx + 0x50], eax         ; string pool offset
    mov  rax, [rel krn_strlen]
    mov  dword [rbx + 0x54], eax
    mov  rax, [rel krn_caps]
    mov  qword [rbx + 0x68], rax

    ; --- copy the string pool into place ---
    lea  rsi, [rel krn_strpool]
    lea  rdi, [rbx + KRN_HDR_SIZE + KRN_SECT_ENTRY * 3]
    mov  rcx, [rel krn_strlen]
.cpstr:
    test rcx, rcx
    jz   .cpstr_done
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .cpstr
.cpstr_done:

    ; --- section 0: code ---
    lea  rdi, [rbx + KRN_HDR_SIZE]
    mov  eax, r12d
    mov  dword [rdi + 0x00], eax         ; name offset
    mov  dword [rdi + 0x04], KRN_SEC_CODE
    mov  qword [rdi + 0x08], 0x1000      ; virtual address
    mov  eax, r15d
    mov  dword [rdi + 0x10], eax         ; file offset
    call kasm_get_code_size
    mov  dword [rdi + 0x14], eax         ; size in the file
    mov  dword [rdi + 0x18], eax         ; size in memory
    mov  dword [rdi + 0x1C], 5           ; read | execute
    mov  r8d, eax                        ; keep the code length

    ; --- section 1: data, placed right after the code, aligned to 16 ---
    lea  rdi, [rbx + KRN_HDR_SIZE + KRN_SECT_ENTRY]
    mov  eax, r13d
    mov  dword [rdi + 0x00], eax
    mov  dword [rdi + 0x04], KRN_SEC_DATA
    mov  eax, r8d
    add  eax, 15
    and  eax, -16
    mov  r9d, eax                        ; offset of the data within the image
    add  eax, 0x1000
    mov  qword [rdi + 0x08], rax         ; virtual address
    mov  eax, r15d
    add  eax, r9d
    mov  dword [rdi + 0x10], eax         ; file offset
    call kasm_get_data_size
    mov  dword [rdi + 0x14], eax
    mov  dword [rdi + 0x18], eax
    mov  dword [rdi + 0x1C], 3           ; read | write
    mov  r10d, eax                       ; keep the data length

    ; --- section 2: bss, reserved but not stored ---
    lea  rdi, [rbx + KRN_HDR_SIZE + KRN_SECT_ENTRY * 2]
    mov  eax, r14d
    mov  dword [rdi + 0x00], eax
    mov  dword [rdi + 0x04], KRN_SEC_BSS
    mov  eax, r9d
    add  eax, r10d
    add  eax, 15
    and  eax, -16
    add  eax, 0x1000
    mov  qword [rdi + 0x08], rax
    mov  dword [rdi + 0x10], 0           ; nothing in the file
    mov  dword [rdi + 0x14], 0
    call kasm_get_bss_size
    mov  dword [rdi + 0x18], eax         ; size in memory only
    mov  dword [rdi + 0x1C], 3

    ; --- copy the code body ---
    call kasm_get_code
    mov  rsi, rax
    lea  rdi, [rbx + r15]
    call kasm_get_code_size
    mov  rcx, rax
.cpcode:
    test rcx, rcx
    jz   .cpcode_done
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .cpcode
.cpcode_done:

    ; --- pad, then copy the data body ---
    lea  rdi, [rbx + r15]
    add  rdi, r9
    call kasm_get_data
    mov  rsi, rax
    call kasm_get_data_size
    mov  rcx, rax
.cpdata:
    test rcx, rcx
    jz   .cpdata_done
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .cpdata
.cpdata_done:

    ; --- total length before the signature ---
    mov  rax, r15
    add  rax, r9
    add  rax, r10
    add  rax, 15
    and  rax, -16
    mov  [rel krn_len], rax

    ; --- signature block ---
    call krn_sign

    mov  rax, [rel krn_len]
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; krn_sign()
; Appends a JSIG block holding a digest of everything before it. Algorithm 1
; means integrity without authenticity: the file can be checked for tampering
; but not attributed to a signer. Key-based algorithms slot into the same block.
; ==============================================================================
krn_sign:
    push rbx
    push rsi
    push rdi
    push r12

    lea  rbx, [rel krn_buf]
    mov  r12, [rel krn_len]              ; how many bytes are being signed

    ; record where the signature sits before writing it
    mov  eax, r12d
    mov  dword [rbx + 0x58], eax
    mov  dword [rbx + 0x5C], 48          ; block size

    ; --- FNV-1a digest over the signed range ---
    mov  rax, 0xCBF29CE484222325         ; offset basis
    xor  rcx, rcx
.hash:
    cmp  rcx, r12
    jae  .hash_done
    movzx edx, byte [rbx + rcx]
    xor  rax, rdx
    mov  rsi, 0x100000001B3              ; prime
    imul rax, rsi
    inc  rcx
    jmp  .hash
.hash_done:
    mov  rsi, rax                        ; the digest

    lea  rdi, [rbx + r12]
    mov  dword [rdi + 0x00], JSIG_MAGIC
    mov  word  [rdi + 0x04], JSIG_ALG_DIGEST
    mov  word  [rdi + 0x06], 0           ; no key identifier
    mov  dword [rdi + 0x08], 8           ; digest size
    mov  dword [rdi + 0x0C], 0           ; no signature bytes
    mov  [rdi + 0x10], r12               ; how much was signed
    mov  [rdi + 0x18], rsi               ; the digest itself
    mov  qword [rdi + 0x20], 0
    mov  qword [rdi + 0x28], 0

    add  r12, 48
    mov  [rel krn_len], r12

    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret
