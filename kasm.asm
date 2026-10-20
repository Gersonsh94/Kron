; ==============================================================================
; KASM - THE KRON ASSEMBLER: THE DOOR TO IT
;
; The assembler is written in Kron, in kasm.kr and the ks_*.kr files it
; imports. kronc --module turns it into kasm_kr.asm, which kron_all.asm
; includes after this file; BUILD.bat and BOOTSTRAP.bat make it again with
; each compiler they build (KRONPARTS.bat).
;
; These are the entry points the hand-written parts call -- main, the PE,
; ELF and KRN writers, karm and xwasm -- under the names and with the
; registers they always had. Each saves every register but rax, aligns the
; stack and calls the Kron function (Kron's convention: arguments in rcx,
; rdx, r8, r9, r10, the result in rax).
;
;   kasm_init()
;   kasm_assemble(rcx = source text, rdx = length) -> rax = 1 ok, 0 an error
;   kasm_build_image()            -> rax = the flat image's length
;   kasm_get_code() / _code_size() / _data() / _data_size() / _bss_size()
;   kasm_had_error()              -> eax
;   kasm_get_error_line()         -> rax = where the first error was
;   kasm_get_error_count()        -> rax
;   kasm_get_error_line_at(rcx) / _dst(rcx) / _src(rcx) / _mnem(rcx)
;   kasm_get_ext_count() / kasm_get_ext_name(rcx)
;   kasm_get_extref_count() / _extref_at(rcx) / _extref_sym(rcx)
;   kasm_find_label(rcx = name, rdx = length) -> rax = index, or -1
;   kasm_label_addr(rax = index)  -> rax = its address
;   kasm_get_fixup_count() / _fixup_at(rcx) / _label(rcx) / _addend(rcx)
;   kasm_get_fixup_kind(rcx) / kasm_get_label_section(rcx)
;   parse_float(rcx = text)       -> xmm0 = the value (karm, xwasm and the
;                                    code generator read reals through it)
; ==============================================================================

default rel
bits 64

section .text
    global kasm_init
    global kasm_assemble
    global kasm_build_image
    global kasm_get_code
    global kasm_get_code_size
    global kasm_get_data
    global kasm_get_data_size
    global kasm_get_bss_size
    global kasm_find_label
    global kasm_had_error
    global kasm_get_error_line
    global kasm_get_error_count
    global kasm_get_error_line_at
    global kasm_get_error_dst
    global kasm_get_error_src
    global kasm_get_error_mnem
    global kasm_get_ext_count
    global kasm_get_ext_name
    global kasm_get_extref_count
    global kasm_get_extref_at
    global kasm_get_extref_sym
    global kasm_label_addr
    global kasm_get_fixup_count
    global kasm_get_fixup_at
    global kasm_get_fixup_label
    global kasm_get_fixup_addend
    global kasm_get_fixup_kind
    global kasm_get_label_section
    global parse_float

; KK_ENTER / KK_LEAVE: every register but rax kept, rbp the frame
%macro KK_ENTER 0
    push rbp
    mov  rbp, rsp
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    and  rsp, -16
    sub  rsp, 32
%endmacro

%macro KK_LEAVE 0
    lea  rsp, [rbp - 104]
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rbp
    ret
%endmacro

kasm_init:
    KK_ENTER
    call ks_init
    KK_LEAVE
kasm_assemble:
    KK_ENTER
    call ks_assemble
    KK_LEAVE
kasm_build_image:
    KK_ENTER
    call ks_build_image
    KK_LEAVE
kasm_get_code:
    KK_ENTER
    call ksk_code
    KK_LEAVE
kasm_get_code_size:
    KK_ENTER
    call ksk_code_size
    KK_LEAVE
kasm_get_data:
    KK_ENTER
    call ksk_data
    KK_LEAVE
kasm_get_data_size:
    KK_ENTER
    call ksk_data_size
    KK_LEAVE
kasm_get_bss_size:
    KK_ENTER
    call ksk_bss_size
    KK_LEAVE
kasm_find_label:
    KK_ENTER
    call ks_find_label
    KK_LEAVE
kasm_had_error:
    KK_ENTER
    call ksk_had_error
    KK_LEAVE
kasm_get_error_line:
    KK_ENTER
    call ksk_error_line
    KK_LEAVE
kasm_get_error_count:
    KK_ENTER
    call ksk_error_count
    KK_LEAVE
kasm_get_error_line_at:
    KK_ENTER
    call ksk_error_line_at
    KK_LEAVE
kasm_get_error_dst:
    KK_ENTER
    call ksk_error_dst
    KK_LEAVE
kasm_get_error_src:
    KK_ENTER
    call ksk_error_src
    KK_LEAVE
kasm_get_error_mnem:
    KK_ENTER
    call ksk_error_mnem
    KK_LEAVE
kasm_get_ext_count:
    KK_ENTER
    call ksk_ext_count
    KK_LEAVE
kasm_get_ext_name:
    KK_ENTER
    call ksk_ext_name
    KK_LEAVE
kasm_get_extref_count:
    KK_ENTER
    call ksk_extref_count
    KK_LEAVE
kasm_get_extref_at:
    KK_ENTER
    call ksk_extref_at
    KK_LEAVE
kasm_get_extref_sym:
    KK_ENTER
    call ksk_extref_sym
    KK_LEAVE
kasm_get_fixup_count:
    KK_ENTER
    call ksk_fixup_count
    KK_LEAVE
kasm_get_fixup_at:
    KK_ENTER
    call ksk_fixup_at
    KK_LEAVE
kasm_get_fixup_label:
    KK_ENTER
    call ksk_fixup_label
    KK_LEAVE
kasm_get_fixup_addend:
    KK_ENTER
    call ksk_fixup_addend
    KK_LEAVE
kasm_get_fixup_kind:
    KK_ENTER
    call ksk_fixup_kind
    KK_LEAVE
kasm_get_label_section:
    KK_ENTER
    call ksk_label_section
    KK_LEAVE

; the index comes in rax
kasm_label_addr:
    KK_ENTER
    mov  rcx, rax
    call ksk_label_addr
    KK_LEAVE

; the bits of the double, from kasm's own reading of a real
parse_float:
    KK_ENTER
    call ks_parse_float
    movq xmm0, rax
    KK_LEAVE
