; ==============================================================================
; XWASM - the x86-64 text the code generator writes, lowered to WebAssembly:
; THE DOOR TO IT
;
; The pass is written in Kron, in xwasm.kr, and reads the x86 text with
; xarm's reader (xarm.kr). kronc --module turns it into xwasm_kr.asm, which
; kron_all.asm includes after this file; BUILD.bat and BOOTSTRAP.bat make it
; again with each compiler they build.
;
; xwasm_translate(rcx = x86 text, rdx = length, r8 = output, r9 = capacity)
;   -> rax = length of the module, or -1 on an error (xv_translate)
; xwasm_error_line() / xwasm_error_text() / xwasm_error_insn(): as xarm's;
; the error is in the state xarm's door keeps.
; xwasm_translate keeps every register but rax and aligns the stack.
; ==============================================================================

bits 64
default rel

global xwasm_translate
global xwasm_error_line
global xwasm_error_text
global xwasm_error_insn

extern xv_translate
extern xa_err_line, xa_err_msg, xa_err_insn

section .text

xwasm_translate:
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
    call xv_translate
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

xwasm_error_line:
    mov  rax, [rel xa_err_line]
    ret
xwasm_error_text:
    mov  rax, [rel xa_err_msg]
    ret
xwasm_error_insn:
    lea  rax, [rel xa_err_insn]
    ret
