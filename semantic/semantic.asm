; ==============================================================================
; KRON COMPILER - SEMANTIC PASS: THE DOOR TO IT
;
; The semantic pass is written in Kron, in semantic.kr. kronc --module turns
; it into semantic_kr.asm, which kron_all.asm includes after this file;
; BUILD.bat and BOOTSTRAP.bat make it again with each compiler they build
; (KRONPARTS.bat).
;
; These are the entry points the hand-written parts call, under the names
; and with the registers they always had. Each saves every register but rax
; (and rdx, for the two that return a length there), aligns the stack and
; calls the Kron function (Kron's convention: arguments in rcx, rdx, r8, r9,
; r10).
;
;   jup_semantic_init(rdi = symbol memory, rsi = its size)  -> rax = 0
;   jup_semantic_run(rdi = the PROGRAM node)   -> rax = 0 right, -1 an error
;   jup_semantic_set_error(rcx = token, rdx = kind): an error found later,
;                                    reported the same way
;   jup_semantic_error_kind()       -> rax = what went wrong (semantic.kr)
;   jup_semantic_error_line/_col/_len() -> rax = where, and how long
;   jup_semantic_error_name()       -> rax = the name's text, rdx = length
;   jup_semantic_suggestion()       -> rax = the closest declared name,
;                                      rdx = its length; 0 for none
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"

section .text
    global jup_semantic_init
    global jup_semantic_run
    global jup_semantic_set_error
    global jup_semantic_error_kind
    global jup_semantic_error_line
    global jup_semantic_error_col
    global jup_semantic_error_len
    global jup_semantic_error_name
    global jup_semantic_suggestion

; KS_ENTER / KS_LEAVE: every register but rax kept, rbp the frame
%macro KS_ENTER 0
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

%macro KS_LEAVE 0
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

jup_semantic_init:
    KS_ENTER
    mov  rcx, rdi
    mov  rdx, rsi
    call sem_init
    KS_LEAVE

jup_semantic_run:
    KS_ENTER
    mov  rcx, rdi
    call sem_run
    KS_LEAVE

jup_semantic_set_error:
    KS_ENTER
    call sem_set_error
    KS_LEAVE

jup_semantic_error_kind:
    KS_ENTER
    call sem_kind
    KS_LEAVE

jup_semantic_error_line:
    KS_ENTER
    call sem_line
    KS_LEAVE

jup_semantic_error_col:
    KS_ENTER
    call sem_col
    KS_LEAVE

jup_semantic_error_len:
    KS_ENTER
    call sem_len
    KS_LEAVE

jup_semantic_error_name:
    KS_ENTER
    call sem_len
    mov  [rbp - 24], rax              ; the saved rdx
    call sem_name
    KS_LEAVE

jup_semantic_suggestion:
    KS_ENTER
    sub  rsp, 16                     ; a slot of its own, above the shadow
    call sem_suggest_name
    mov  [rsp + 32], rax
    call sem_suggest_len
    mov  [rbp - 24], rax              ; the saved rdx
    mov  rax, [rsp + 32]
    KS_LEAVE
