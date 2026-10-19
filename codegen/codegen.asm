; ==============================================================================
; KRON COMPILER - CODE GENERATOR: THE DOOR TO IT
;
; The code generator is written in Kron, in codegen.kr and the cg_*.kr files
; it imports. kronc --module turns it into codegen_kr.asm, which
; kron_all.asm includes after this file; BUILD.bat and BOOTSTRAP.bat make it
; again with each compiler they build (KRONPARTS.bat).
;
; These are the entry points the hand-written parts call, under the names
; and with the registers they always had. Each saves every register but the
; ones it answers in, aligns the stack and calls the Kron function (Kron's
; convention: arguments in rcx, rdx, r8, r9, r10, the result in rax).
;
;   jup_codegen_init(rdi = output buffer, rsi = its size)
;   jup_codegen_set_target(dil = TARGET_*)
;   jup_codegen_set_lib(dil = 1 for a library)
;   jup_codegen_run(rdi = the PROGRAM node) -> rax = 1 written, 0 an error;
;                                 an internal one leaves its number in dbg_which
;   codegen_get_code()       -> rax = the text
;   codegen_get_code_size()  -> rax = its length
;   codegen_uses_extern()    -> eax = 1 when an extern function is called
;   codegen_has_exports()    -> eax = 1 when the program exports something
;   codegen_export_count()   -> eax = how many functions a library exports
;   codegen_export_name(ecx) -> rax = the name, rdx = its length
;   cg_thread_error_tok()    -> rax = the access the thread check refused
;   cg_type_error()          -> rax = message, rdx = token, r8 = hint
;
; main.asm sets cg_debug, cg_as_module and cg_mod_tag before the run and
; reads dbg_which after it; they live here and go to the Kron side at
; jup_codegen_run.
;
; And three the Kron side calls (extern "kronc" in codegen.kr), each saving
; every register but rax:
;
;   cg_lmap(rcx = expanded line) -> rax = its file; the line in the file
;                                   goes to cg_lmap_line (main.asm's map)
;   cg_float_bits(rcx = text of a real, rdx = 1 for f32) -> rax = its bits
;                                   (kasm's parse_float, so both agree)
;   cg_parser_q(rcx = which, rdx = i) -> rax = the parser's tables of
;                                   ptr<S> and list<S> declarations:
;                                   1 ps_n  2 ps_decl[i]  3 ps_type[i]
;                                   4 ls_n  5 ls_decl[i]  6 ls_type[i]
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"

extern print_string
extern lmap_lookup
extern parse_float
extern __g_parser_par_ps_decl, __g_parser_par_ps_type, __g_parser_par_ps_n
extern __g_parser_par_ls_decl, __g_parser_par_ls_type, __g_parser_par_ls_n

section .bss
    dbg_which    resb 1          ; why the output failed: 1 full, 2 locals
    cg_debug     resb 1          ; --debug: hooks before statements, records
    cg_as_module resb 1          ; --module: the functions alone, no program
    cg_mod_tag   resb 72         ; '<name>_': what a module's data labels carry

section .text
    global dbg_which
    global cg_debug
    global cg_as_module, cg_mod_tag
    global jup_codegen_init
    global jup_codegen_run
    global jup_codegen_set_target
    global jup_codegen_set_lib
    global codegen_get_code
    global codegen_get_code_size
    global codegen_uses_extern
    global codegen_has_exports
    global codegen_export_count
    global codegen_export_name
    global cg_thread_error_tok
    global cg_type_error
    global cg_lmap
    global cg_float_bits
    global cg_parser_q

; KC_ENTER / KC_LEAVE: every register but rax kept, rbp the frame. The saved
; rdx is at [rbp - 24], the saved r8 at [rbp - 48].
%macro KC_ENTER 0
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
    sub  rsp, 48                     ; the shadow space, and a slot at +32
%endmacro

%macro KC_LEAVE 0
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

jup_codegen_init:
    KC_ENTER
    mov  rcx, rdi
    mov  rdx, rsi
    call cgk_init
    KC_LEAVE

jup_codegen_set_target:
    KC_ENTER
    movzx ecx, dil
    call cgk_set_target
    KC_LEAVE

jup_codegen_set_lib:
    KC_ENTER
    movzx ecx, dil
    call cgk_set_lib
    KC_LEAVE

; the flags and the module's tag go over, the program is generated, and why
; it failed comes back
jup_codegen_run:
    KC_ENTER
    mov  [rsp + 32], rdi
    movzx ecx, byte [rel cg_debug]
    movzx edx, byte [rel cg_as_module]
    call cgk_flags                   ; rax = the Kron side's cg_mod_tag
    lea  rsi, [rel cg_mod_tag]
    xor  ecx, ecx
.tag:
    mov  dl, [rsi + rcx]
    mov  [rax + rcx], dl
    inc  ecx
    cmp  ecx, 72
    jb   .tag
    mov  rcx, [rsp + 32]
    call cgk_run
    mov  [rsp + 32], rax
    call cgk_dbg_which
    mov  [rel dbg_which], al
    mov  rax, [rsp + 32]
    KC_LEAVE

codegen_get_code:
    KC_ENTER
    call cgk_code
    KC_LEAVE

codegen_get_code_size:
    KC_ENTER
    call cgk_code_size
    KC_LEAVE

codegen_uses_extern:
    KC_ENTER
    call cgk_uses_extern
    KC_LEAVE

codegen_has_exports:
    KC_ENTER
    call cgk_has_exports
    KC_LEAVE

codegen_export_count:
    KC_ENTER
    call cgk_export_count
    KC_LEAVE

codegen_export_name:
    KC_ENTER
    mov  ecx, ecx
    mov  [rsp + 32], rcx
    call cgk_export_nlen
    mov  [rbp - 24], rax             ; the saved rdx
    mov  rcx, [rsp + 32]
    call cgk_export_name
    KC_LEAVE

cg_thread_error_tok:
    KC_ENTER
    call cgk_thread_tok
    KC_LEAVE

cg_type_error:
    KC_ENTER
    call cgk_err_tok
    mov  [rbp - 24], rax             ; the saved rdx
    call cgk_err_hint
    mov  [rbp - 48], rax             ; the saved r8
    call cgk_err_msg
    KC_LEAVE

cg_lmap:
    KC_ENTER
    call lmap_lookup                 ; rcx = line -> rax = file, rdx = line
    mov  [rel __g_codegen_cg_lmap_line], rdx
    KC_LEAVE

cg_float_bits:
    KC_ENTER
    mov  rbx, rdx                    ; kept: KC_LEAVE restores rbx
    call parse_float                 ; rcx = text -> xmm0
    test rbx, rbx
    jz   .fb_double
    cvtsd2ss xmm0, xmm0
    movq rax, xmm0
    mov  eax, eax                    ; the four bytes of the single
    KC_LEAVE
.fb_double:
    movq rax, xmm0
    KC_LEAVE

cg_parser_q:
    KC_ENTER
    cmp  rcx, 1
    je   .pq_psn
    cmp  rcx, 2
    je   .pq_psd
    cmp  rcx, 3
    je   .pq_pst
    cmp  rcx, 4
    je   .pq_lsn
    cmp  rcx, 5
    je   .pq_lsd
    lea  rax, [rel __g_parser_par_ls_type]
    mov  rax, [rax + rdx*8]
    KC_LEAVE
.pq_psn:
    mov  rax, [rel __g_parser_par_ps_n]
    KC_LEAVE
.pq_psd:
    lea  rax, [rel __g_parser_par_ps_decl]
    mov  rax, [rax + rdx*8]
    KC_LEAVE
.pq_pst:
    lea  rax, [rel __g_parser_par_ps_type]
    mov  rax, [rax + rdx*8]
    KC_LEAVE
.pq_lsn:
    mov  rax, [rel __g_parser_par_ls_n]
    KC_LEAVE
.pq_lsd:
    lea  rax, [rel __g_parser_par_ls_decl]
    mov  rax, [rax + rdx*8]
    KC_LEAVE
