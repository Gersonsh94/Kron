; ==============================================================================
; KRON COMPILER - PARSER: THE DOOR TO IT
;
; The parser is written in Kron: parser.kr and the files it imports
; (parser_stmt.kr, parser_expr.kr, parser_titan.kr, parser_ng.kr).
; kronc --module turns them into parser_kr.asm, which kron_all.asm includes
; after this file; BUILD.bat and BOOTSTRAP.bat make it again with each
; compiler they build (KRONPARTS.bat).
;
; These are the entry points the hand-written parts call, under the names
; and with the registers they always had. Each saves every register but rax,
; aligns the stack and calls the Kron function (Kron's convention: arguments
; in rcx, rdx, r8, r9, r10).
;
;   jup_parser_init(rdi = tokens, rsi = count, rdx = tree buffer, rcx = size)
;   jup_parser_run()                -> rax = 1 parsed, 0 an error
;   parser_get_ast_root()           -> rax = the PROGRAM node
;   parser_get_error_token()        -> rax = the type of the token it stopped at
;   parser_get_error_line/_col/_len -> rax = where that token is, how long
;   parser_get_position()           -> rax = its index
;   parser_get_expected()           -> rax = the token type it looked for
;   parser_get_custom_msg()         -> rax = a message of its own, or 0
;   parser_get_error()              -> rax = "Parser: invalid structure"
;   token_name(rdi = token type)    -> rax = a name for it, for messages
;   parser_token_count()            -> rax = the tokens after generics
;   parser_ast_used()               -> rax = bytes of the tree buffer used
;
; The parser's globals are the Kron module's, named __g_parser_<name>:
; main reads __g_parser_par_used_slice and the like, codegen the
; __g_parser_par_ps_* and __g_parser_par_ls_* tables.
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"

extern arg_input, src_buffer, lmap_out, lmap_file, lmap_count

section .text
    global jup_parser_init
    global jup_parser_run
    global parser_get_ast_root
    global parser_get_error
    global parser_get_error_token
    global parser_get_error_line
    global parser_get_error_col
    global parser_get_error_len
    global parser_get_position
    global parser_get_expected
    global parser_get_custom_msg
    global parser_token_count
    global parser_ast_used
    global token_name

; KP_ENTER / KP_LEAVE: every register but rax kept, rbp the frame
%macro KP_ENTER 0
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

%macro KP_LEAVE 0
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

jup_parser_init:
    KP_ENTER
    push rdi
    push rsi
    push rdx
    push rcx
    lea  rcx, [rel arg_input]
    lea  rdx, [rel src_buffer]
    lea  r8,  [rel lmap_out]
    lea  r9,  [rel lmap_file]
    lea  r10, [rel lmap_count]
    call prs_env
    pop  r9
    pop  r8
    pop  rdx
    pop  rcx
    call prs_init
    KP_LEAVE

jup_parser_run:
    KP_ENTER
    call prs_run
    KP_LEAVE

parser_get_ast_root:
    KP_ENTER
    call prs_ast_root
    KP_LEAVE

parser_get_error:
    KP_ENTER
    call prs_error_msg
    KP_LEAVE

parser_get_error_token:
    KP_ENTER
    call prs_error_token
    KP_LEAVE

parser_get_error_line:
    KP_ENTER
    call prs_error_line
    KP_LEAVE

parser_get_error_col:
    KP_ENTER
    call prs_error_col
    KP_LEAVE

parser_get_error_len:
    KP_ENTER
    call prs_error_len
    KP_LEAVE

parser_get_position:
    KP_ENTER
    call prs_position
    KP_LEAVE

parser_get_expected:
    KP_ENTER
    call prs_expected
    KP_LEAVE

parser_get_custom_msg:
    KP_ENTER
    call prs_custom_msg
    KP_LEAVE

parser_token_count:
    KP_ENTER
    call prs_token_count
    KP_LEAVE

parser_ast_used:
    KP_ENTER
    call prs_ast_used
    KP_LEAVE

token_name:
    KP_ENTER
    mov  rcx, rdi
    call prs_token_name
    KP_LEAVE
