; ==============================================================================
; KARM - the ARM64 assembler for Kron: THE DOOR TO IT
;
; The assembler is written in Kron, in three parts: karm_core.kr (lines,
; labels, expressions, operands, emission, directives), karm_alu.kr (mov,
; arithmetic, logic, shifts, selects) and karm_mem.kr (loads and stores,
; branches, addresses, reals). kronc --module turns each into its _kr.asm,
; which kron_all.asm includes after this file; BUILD.bat and BOOTSTRAP.bat
; make them again with each compiler they build.
;
; main.asm, the ELF writer and the Mach-O writer call the old names. Each
; keeps every register but rax, aligns the stack and calls the kc_ function
; it stands for.
; ==============================================================================

bits 64
default rel

section .text

global karm_init, karm_set_base, karm_set_align, karm_assemble, karm_build_image, karm_get_code, karm_get_size
global karm_get_bss_size, karm_get_entry, karm_had_error, karm_get_error_count, karm_get_error_line_at, karm_get_error_mnem, karm_get_error_text
global karm_get_code_len, karm_get_data_len, karm_get_data_off, karm_label, karm_reloc_count, karm_reloc_at, karm_reloc_text
extern kc_assemble, kc_build_image, kc_get_bss_size, kc_get_code, kc_get_code_len, kc_get_data_len, kc_get_data_off, kc_get_entry, kc_get_error_count, kc_get_error_line_at
extern kc_get_error_mnem, kc_get_error_text, kc_get_size, kc_init, kc_label, kc_reloc_at, kc_reloc_count, kc_reloc_text, kc_set_align, kc_set_base

; every register but rax kept, the stack aligned, the Kron function called
%macro KARM_DOOR 1
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call %1
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret
%endmacro

; karm_init()
karm_init:
    KARM_DOOR kc_init

; karm_set_base(rcx = address of the first byte of the image in memory)
karm_set_base:
    KARM_DOOR kc_set_base

; karm_set_align(rcx = a power of two): where .data and .bss start
karm_set_align:
    KARM_DOOR kc_set_align

; karm_assemble(rcx = text, rdx = length) -> rax = 1 when it assembled
karm_assemble:
    KARM_DOOR kc_assemble

; karm_build_image() -> rax = length of code + padding + data, in the code buffer
karm_build_image:
    KARM_DOOR kc_build_image

; karm_get_code() -> rax = the code buffer
karm_get_code:
    KARM_DOOR kc_get_code

; karm_get_size() -> rax = length of the code
karm_get_size:
    KARM_DOOR kc_get_size

; karm_get_bss_size() -> rax = length of .bss
karm_get_bss_size:
    KARM_DOOR kc_get_bss_size

; karm_get_entry() -> rax = address of _start, 0 when there is none
karm_get_entry:
    KARM_DOOR kc_get_entry

; karm_had_error() -> rax = how many errors
karm_had_error:
    KARM_DOOR kc_get_error_count

; karm_get_error_count() -> rax = how many errors
karm_get_error_count:
    KARM_DOOR kc_get_error_count

; karm_get_error_line_at(rcx = index) -> rax = line
karm_get_error_line_at:
    KARM_DOOR kc_get_error_line_at

; karm_get_error_mnem(rcx = index) -> rax = the mnemonic of that line
karm_get_error_mnem:
    KARM_DOOR kc_get_error_mnem

; karm_get_error_text(rcx = index) -> rax = what went wrong
karm_get_error_text:
    KARM_DOOR kc_get_error_text

; karm_get_code_len() -> rax = length of the code
karm_get_code_len:
    KARM_DOOR kc_get_code_len

; karm_get_data_len() -> rax = length of .data
karm_get_data_len:
    KARM_DOOR kc_get_data_len

; karm_get_data_off() -> rax = where .data starts, from the image's start
karm_get_data_off:
    KARM_DOOR kc_get_data_off

; karm_label(rcx = name, 0-terminated) -> rax = its address, -1 when unknown
karm_label:
    KARM_DOOR kc_label

; karm_reloc_count() -> rax = how many dq in .data hold an address
karm_reloc_count:
    KARM_DOOR kc_reloc_count

; karm_reloc_at(rcx = index) -> rax = offset in .data of a dq holding an address
karm_reloc_at:
    KARM_DOOR kc_reloc_at

; karm_reloc_text() -> rax = how many dq in .text hold one, which nothing can move
karm_reloc_text:
    KARM_DOOR kc_reloc_text
