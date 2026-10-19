; ==============================================================================
; KRON COMPILER - LEXER: THE DOOR TO IT
;
; The lexer is written in Kron, in lexer.kr. kronc --module turns it into
; lexer_kr.asm, which kron_all.asm includes after this file; BUILD.bat and
; BOOTSTRAP.bat make it again with each compiler they build.
;
; These are the entry points the hand-written parts call, under the names
; and with the registers they always had. Each one saves every register but
; rax, so the callers keep what they hold, aligns the stack and calls the
; Kron function (Kron's convention: arguments in rcx, rdx, r8, r9, r10).
;
;   jup_lexer_init(rcx = src, rdx = len, r8 = token buffer, r9 = &count)
;                                        -> rax = 1
;   jup_lexer_run()                      -> rax = tokens, TOK_EOF included;
;                                           -1 on an error
;   lexer_keyword_name(rdi = token type) -> rax = the keyword's text, or 0
;   lexer_error_kind()                   -> rax = 1 a character Kron does not
;                                           use, 2 a text with no closing
;                                           quote, 3 too many tokens
;   lexer_error_token()                  -> rax = a token where the error is
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"

section .text
    global jup_lexer_init
    global jup_lexer_run
    global lexer_keyword_name
    global lexer_error_kind
    global lexer_error_token

; KL_ENTER / KL_LEAVE: every register but rax kept, rbp the frame
%macro KL_ENTER 0
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

%macro KL_LEAVE 0
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

jup_lexer_init:
    KL_ENTER
    mov  r10, TOKEN_BUFFER_SIZE / TOKEN_SIZE
    call klx_init
    KL_LEAVE

jup_lexer_run:
    KL_ENTER
    call klx_run
    KL_LEAVE

lexer_keyword_name:
    KL_ENTER
    mov  rcx, rdi
    call klx_keyword_name
    KL_LEAVE

lexer_error_kind:
    KL_ENTER
    call klx_error_kind
    KL_LEAVE

lexer_error_token:
    KL_ENTER
    call klx_error_token
    KL_LEAVE
