; ==============================================================================
; XARM - the x86-64 text the code generator writes, lowered to ARM64 text:
; THE DOOR TO IT
;
; The pass is written in Kron, in xarm.kr. kronc --module turns it into
; xarm_kr.asm, which kron_all.asm includes after this file; BUILD.bat and
; BOOTSTRAP.bat make it again with each compiler they build.
;
; This file keeps what the rest of the assembly reaches by name:
;
;   xarm_set_os(rcx = 0 Linux, 1 macOS): which shim the program gets. macOS
;     runs the same Linux program: its shim answers the Linux calls from XNU.
;   xarm_set_lib(rcx = 1 for a library, --lib)
;   xarm_translate(rcx = x86 text, rdx = length, r8 = output, r9 = capacity)
;     -> rax = length of the ARM64 text, or -1 on an error (xl_translate)
;   xarm_error_line()  -> rax = line of the x86 text that failed
;   xarm_error_text()  -> rax = what was wrong (zero-terminated)
;   xarm_error_insn()  -> rax = the instruction itself (zero-terminated)
;
;   the reader of x86 text that xwasm shares, with the registers it always
;   took and gave: xa_read_line, xa_native_skip, xa_split, xa_parse_ops,
;   xa_streq, xa_prefix, xa_skipb, xa_parse_num, xa_find_reg, xa_fail, and
;   the state they share, one block (xa_get_state gives it to xarm.kr):
;   xa_in xa_in_end xa_line_no xa_err xa_err_line xa_err_msg xa_err_insn
;   xa_line xa_mn xa_rest xa_nops xa_opt xa_ops xa_skipping
;
;   the system call shims appended to every program (xa_get_tail).
;
; Every door keeps every register but the ones it answers in, and aligns
; the stack for the Kron function it calls.
; ==============================================================================

bits 64
default rel

global xarm_translate
global xarm_error_line
global xarm_error_text
global xarm_error_insn
global xarm_set_os
global xarm_set_lib
global xa_get_state, xa_get_tail
; the reader of x86 text, shared with xwasm
global xa_read_line, xa_split, xa_parse_ops, xa_streq, xa_prefix, xa_skipb
global xa_native_skip, xa_skipping
global xa_parse_num, xa_find_reg, xa_fail
global xa_in, xa_in_end, xa_line_no, xa_err, xa_err_line, xa_err_msg
global xa_err_insn, xa_line, xa_mn, xa_rest, xa_nops, xa_opt, xa_ops

extern xl_translate, xl_read_line, xl_native_skip, xl_split, xl_parse_ops
extern xl_streq, xl_prefix, xl_skipb, xl_parse_num, xl_find_reg, xl_fail
extern xl_last_ok, xl_last_size

; the state, one block; xarm.kr knows each piece by its offset (S_ there)
section .bss
    xa_os        resq 1         ; +0     0 Linux, 1 macOS
    xa_lib       resq 1         ; +8     1 for a library: __centry in the tail
    xa_in        resq 1         ; +16
    xa_in_end    resq 1         ; +24
    xa_line_no   resq 1         ; +32
    xa_err       resq 1         ; +40
    xa_err_line  resq 1         ; +48
    xa_err_msg   resq 1         ; +56
    xa_rest      resq 1         ; +64
    xa_nops      resq 1         ; +72
    xa_skipping  resq 1         ; +80    inside a routine the tail supplies
    xa_err_insn  resb 160       ; +88
    xa_line      resb 1024      ; +248
    xa_mn        resb 32        ; +1272
    xa_opt       resb 768       ; +1304  three operand texts of 256 bytes
    xa_ops       resb 96        ; +2072  three operand records of 32 bytes

; every register but rax kept, the stack aligned for the call
%macro XA_IN 0
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
%endmacro

%macro XA_OUT 0
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
%endmacro

; where XA_IN saved rdx and rsi: a door that answers in them writes there
%define XA_SAVED_RDX 128
%define XA_SAVED_RSI 120

section .text

; ==============================================================================
; PUBLIC
; ==============================================================================
xarm_error_line:
    mov  rax, [rel xa_err_line]
    ret
xarm_error_text:
    mov  rax, [rel xa_err_msg]
    ret
xarm_error_insn:
    lea  rax, [rel xa_err_insn]
    ret

xarm_set_os:
    mov  [rel xa_os], rcx
    ret

xarm_set_lib:
    mov  [rel xa_lib], rcx
    ret

xarm_translate:
    XA_IN
    call xl_translate
    XA_OUT
    ret

; xa_get_state() -> rax = the state block
xa_get_state:
    lea  rax, [rel xa_os]
    ret

; xa_get_tail(rcx = 0 Linux, 1 macOS, 2 a Linux library, 3 a macOS one)
;   -> rax = the text appended to the program
xa_get_tail:
    lea  rax, [rel xa_tail]
    cmp  rcx, 1
    jne  .t2
    lea  rax, [rel xa_tail_mac]
.t2:
    cmp  rcx, 2
    jne  .t3
    lea  rax, [rel xa_tail_lib]
.t3:
    cmp  rcx, 3
    jne  .t4
    lea  rax, [rel xa_tail_lib_mac]
.t4:
    ret

; ==============================================================================
; THE READER, FOR XWASM
; ==============================================================================

; xa_read_line() -> eax = 1 and xa_line holds the next line, its comment
; removed and its blanks trimmed; eax = 0 at the end of the text
xa_read_line:
    XA_IN
    call xl_read_line
    XA_OUT
    ret

; xa_native_skip() -> eax = 0 when the line just read is translated, 1 when
; it is dropped, 2 when it is the label that starts a dropped routine
xa_native_skip:
    XA_IN
    call xl_native_skip
    XA_OUT
    ret

; xa_split(): xa_rest -> up to three operand texts, trimmed, in xa_opt
xa_split:
    XA_IN
    call xl_split
    XA_OUT
    ret

; xa_parse_ops(): every operand text into its record
xa_parse_ops:
    XA_IN
    call xl_parse_ops
    XA_OUT
    ret

; xa_streq(rcx, rdx) -> eax = 1 when the two strings are equal
xa_streq:
    XA_IN
    call xl_streq
    XA_OUT
    ret

; xa_prefix(rcx = text, rdx = prefix) -> eax = 1 when text starts with it
xa_prefix:
    XA_IN
    call xl_prefix
    XA_OUT
    ret

; xa_skipb(rsi) -> rsi past blanks
xa_skipb:
    push rax
    XA_IN
    sub  rsp, 8
    mov  rcx, rsi
    call xl_skipb
    mov  [rsp + 8 + XA_SAVED_RSI], rax
    add  rsp, 8
    XA_OUT
    pop  rax
    ret

; xa_parse_num(rcx = text) -> rax = value, edx = 1 when the whole text is a
; number: [-]decimal, [-]0xhex, or 'c'
xa_parse_num:
    XA_IN
    call xl_parse_num
    push rax
    sub  rsp, 8
    call xl_last_ok
    add  rsp, 8
    mov  [rsp + 8 + XA_SAVED_RDX], rax
    pop  rax
    XA_OUT
    ret

; xa_find_reg(rcx = text) -> eax = x86 register 0..15 and edx = size, or
; eax = -1 when the text is no register name
xa_find_reg:
    XA_IN
    call xl_find_reg
    push rax
    sub  rsp, 8
    call xl_last_size
    add  rsp, 8
    mov  [rsp + 8 + XA_SAVED_RDX], rax
    pop  rax
    mov  eax, eax
    XA_OUT
    ret

; xa_fail(rcx = message): the first error stops the translation
xa_fail:
    XA_IN
    call xl_fail
    XA_OUT
    ret

; ==============================================================================
; THE SYSTEM CALL SHIM, appended to every program
; ==============================================================================
section .data
xa_tail:
db 10
db "; __sysx: a Linux system call with the x86-64 numbering Kron uses on every", 10
db "; Linux. x0 = number; x5 x4 x2 x8 x6 x7 = rdi rsi rdx r10 r8 r9. The result", 10
db "; is in x0 and every other register survives except rcx and r11 (x1 x9),", 10
db "; as with the x86-64 instruction. x17 holds the caller's return address.", 10
db "section .text", 10
db "__sysx:", 10
db "    mov x10, x2", 10
db "    mov x11, x4", 10
db "    mov x12, x5", 10
db "    mov x13, x6", 10
db "    mov x14, x7", 10
db "    mov x15, x8", 10
db "    mov x9, x0", 10
db "    cmp x0, #335", 10
db "    b.hs .bad", 10
db "    adrl x16, __sysx_tab", 10
db "    ldrh w8, [x16, x0, lsl #1]", 10
db "    mov x16, #0xffff", 10
db "    cmp x8, x16", 10
db "    b.eq .bad", 10
db "    mov x0, x12", 10
db "    mov x1, x11", 10
db "    mov x2, x10", 10
db "    mov x3, x15", 10
db "    mov x4, x13", 10
db "    mov x5, x14", 10
db "    cmp x9, #2", 10
db "    b.eq .open", 10
db "    cmp x9, #56", 10
db "    b.eq .clone", 10
db "    cmp x9, #33", 10
db "    b.eq .dup2", 10
db "    cmp x9, #83", 10
db "    b.eq .mkdir", 10
db "    cmp x9, #87", 10
db "    b.eq .unlink", 10
db "    cmp x9, #84", 10
db "    b.eq .rmdir", 10
db "    cmp x9, #82", 10
db "    b.eq .rename", 10
db "    cmp x9, #4", 10
db "    b.eq .stat", 10
db "    cmp x9, #6", 10
db "    b.eq .lstat", 10
db "    cmp x9, #21", 10
db "    b.eq .access", 10
db "    cmp x9, #22", 10
db "    b.eq .pipe", 10
db "    cmp x9, #57", 10
db "    b.eq .fork", 10
db "    cmp x9, #58", 10
db "    b.eq .fork", 10
db "    cmp x9, #89", 10
db "    b.eq .readlink", 10
db "    cmp x9, #90", 10
db "    b.eq .chmod", 10
db "    b .go", 10
db "; the calls ARM64 only has in their *at form, relative to the current folder", 10
db ".open:", 10
db "    mov x3, x2", 10
db "    mov x2, x1", 10
db "    mov x1, x0", 10
db "    mov x0, #-100", 10
db "    b .go", 10
db ".mkdir:", 10
db "    mov x2, x1", 10
db "    mov x1, x0", 10
db "    mov x0, #-100", 10
db "    b .go", 10
db ".unlink:", 10
db "    mov x2, #0", 10
db "    mov x1, x0", 10
db "    mov x0, #-100", 10
db "    b .go", 10
db ".rmdir:", 10
db "    mov x2, #0x200", 10
db "    mov x1, x0", 10
db "    mov x0, #-100", 10
db "    b .go", 10
db ".rename:", 10
db "    mov x3, x1", 10
db "    mov x2, #-100", 10
db "    mov x1, x0", 10
db "    mov x0, #-100", 10
db "    b .go", 10
db ".dup2:", 10
db "    mov x2, #0", 10
db "    b .go", 10
db "; stat and lstat are newfstatat; access is faccessat; readlink and chmod", 10
db "; their *at forms; pipe is pipe2 with no flags; fork is clone(SIGCHLD)", 10
db ".stat:", 10
db "    mov x3, #0", 10
db "    b .at3", 10
db ".lstat:", 10
db "    mov x3, #0x100", 10
db ".at3:", 10
db "    mov x2, x1", 10
db "    mov x1, x0", 10
db "    mov x0, #-100", 10
db "    b .go", 10
db ".access:", 10
db "    mov x3, #0", 10
db "    b .at3", 10
db ".readlink:", 10
db "    mov x3, x2", 10
db "    b .at3", 10
db ".chmod:", 10
db "    mov x3, #0", 10
db "    b .at3", 10
db ".pipe:", 10
db "    mov x1, #0", 10
db "    b .go", 10
db ".fork:", 10
db "    mov x0, #17", 10
db "    mov x1, #0", 10
db "    mov x2, #0", 10
db "    mov x3, #0", 10
db "    mov x4, #0", 10
db "    b .go", 10
db "; clone takes tls and child_tid the other way round; the child starts on", 10
db "; the new stack, which on ARM64 means sp, and x28 is the stack Kron uses", 10
db ".clone:", 10
db "    mov x9, x3", 10
db "    mov x3, x4", 10
db "    mov x4, x9", 10
db "    svc #0", 10
db "    cbnz x0, .back", 10
db "    mov x28, sp", 10
db "    b .back", 10
db ".go:", 10
db "    svc #0", 10
db "    b .back", 10
db ".bad:", 10
db "    mov x0, #-38", 10
db ".back:", 10
db "    mov x2, x10", 10
db "    mov x4, x11", 10
db "    mov x5, x12", 10
db "    mov x6, x13", 10
db "    mov x7, x14", 10
db "    mov x8, x15", 10
db "    ret", 10
db 10
db "; __ccall: an extern function called in the AAPCS64 convention. As on", 10
db "; x86-64: the arguments pushed in order (the last at [x8], r10), x9 (r11) =", 10
db "; the function's record, x0 (rax) = the shape of the call, x2 (rdx) = the", 10
db "; widths. Integers go in x0-x7, reals in d0-d7 (s for an f32), the rest on", 10
db "; the stack. The C code runs on sp, moved under the Kron stack (x28) first.", 10
db "; Kron keeps x4 x5 (rsi rdi) and all of v6-v15 across a call; AAPCS64 keeps", 10
db "; none of them whole, so they are saved here.", 10
db "__ccall:", 10
db "    ldr x16, [x9]", 10
db "    cbnz x16, .cc_go", 10
db "    stp x0, x2, [x28, #-16]!", 10
db "    stp x8, x9, [x28, #-16]!", 10
db "    ; the frame x86-64 would have, so that a failure's trace finds the call", 10
db "    str x30, [x28, #-8]!", 10
db "    str x29, [x28, #-8]!", 10
db "    mov x29, x28", 10
db "    mov x1, x9", 10
db "    str x30, [x28, #-8]!", 10
db "    bl __ext_resolve", 10
db "    ldr x30, [x28], #8", 10
db "    mov x16, x0", 10
db "    ldr x29, [x28], #8", 10
db "    ldr x30, [x28], #8", 10
db "    ldp x8, x9, [x28], #16", 10
db "    ldp x0, x2, [x28], #16", 10
db "    cbz x16, .cc_none", 10
db "    str x16, [x9]", 10
db ".cc_go:", 10
db "    sub x24, x28, #512", 10
db "    and x24, x24, #0xfffffffffffffff0", 10
db "    mov x25, sp", 10
db "    mov sp, x24", 10
db "    stp x4, x5, [x24, #128]", 10
db "    stp x29, x30, [x24, #144]", 10
db "    str q6, [x24, #176]", 10
db "    str q7, [x24, #192]", 10
db "    str q8, [x24, #208]", 10
db "    str q9, [x24, #224]", 10
db "    str q10, [x24, #240]", 10
db "    str q11, [x24, #256]", 10
db "    str q12, [x24, #272]", 10
db "    str q13, [x24, #288]", 10
db "    str q14, [x24, #304]", 10
db "    str q15, [x24, #320]", 10
db "    mov x26, x0", 10
db "    mov x27, x9", 10
db "    and x11, x26, #255", 10
db "    lsr x3, x26, #48", 10
db "    and x3, x3, #255", 10
db "    mov x10, #0", 10
db "    mov x12, #0", 10
db "    mov x13, #0", 10
db "    mov x14, #0", 10
db ".cc_arg:", 10
db "    cmp x10, x11", 10
db "    b.hs .cc_load", 10
db "    sub x15, x11, x10", 10
db "    sub x15, x15, #1", 10
db "    ldr x15, [x8, x15, lsl #3]", 10
db "    add x16, x10, #8", 10
db "    lsr x16, x26, x16", 10
db "    and x16, x16, #1", 10
db "    cbz x16, .cc_int", 10
db "    add x16, x10, #32", 10
db "    lsr x16, x26, x16", 10
db "    and x16, x16, #1", 10
db "    cbz x16, .cc_dbl", 10
db "    fmov d16, x15", 10
db "    fcvt s16, d16", 10
db "    fmov w15, s16", 10
db ".cc_dbl:", 10
db "    cmp x13, #8", 10
db "    b.hs .cc_spill", 10
db "    add x16, x24, #400", 10
db "    str x15, [x16, x13, lsl #3]", 10
db "    add x13, x13, #1", 10
db "    b .cc_next", 10
db ".cc_int:", 10
db "    cmp x12, #8", 10
db "    b.hs .cc_spill", 10
db "    add x16, x24, #336", 10
db "    str x15, [x16, x12, lsl #3]", 10
db "    add x12, x12, #1", 10
db "    b .cc_next", 10
db ".cc_spill:", 10
db "    str x15, [x24, x14]", 10
db "    add x14, x14, #8", 10
db ".cc_next:", 10
db "    add x10, x10, #1", 10
db "    b .cc_arg", 10
db ".cc_load:", 10
db "    add x16, x24, #336", 10
db "    ldp x0, x1, [x16]", 10
db "    ldp x2, x3, [x16, #16]", 10
db "    ldp x4, x5, [x16, #32]", 10
db "    ldp x6, x7, [x16, #48]", 10
db "    add x16, x24, #400", 10
db "    ldp d0, d1, [x16]", 10
db "    ldp d2, d3, [x16, #16]", 10
db "    ldp d4, d5, [x16, #32]", 10
db "    ldp d6, d7, [x16, #48]", 10
db "    ldr x16, [x27]", 10
db "    blr x16", 10
db "    lsr x9, x26, #24", 10
db "    and x9, x9, #255", 10
db "    cmp x9, #1", 10
db "    b.ne .cc_r2", 10
db "    sxtw x0, w0", 10
db "    b .cc_done", 10
db ".cc_r2:", 10
db "    cmp x9, #2", 10
db "    b.ne .cc_r3", 10
db "    mov w0, w0", 10
db "    b .cc_done", 10
db ".cc_r3:", 10
db "    cmp x9, #3", 10
db "    b.ne .cc_r4", 10
db "    and x0, x0, #255", 10
db "    b .cc_done", 10
db ".cc_r4:", 10
db "    cmp x9, #4", 10
db "    b.ne .cc_r5", 10
db "    and x0, x0, #65535", 10
db "    b .cc_done", 10
db ".cc_r5:", 10
db "    cmp x9, #5", 10
db "    b.ne .cc_r6", 10
db "    sxth x0, w0", 10
db "    b .cc_done", 10
db ".cc_r6:", 10
db "    cmp x9, #6", 10
db "    b.ne .cc_r9", 10
db "    sxtb x0, w0", 10
db "    b .cc_done", 10
db ".cc_r9:", 10
db "    cmp x9, #9", 10
db "    b.ne .cc_done", 10
db "    fcvt d0, s0", 10
db ".cc_done:", 10
db "    ldr q6, [x24, #176]", 10
db "    ldr q7, [x24, #192]", 10
db "    ldr q8, [x24, #208]", 10
db "    ldr q9, [x24, #224]", 10
db "    ldr q10, [x24, #240]", 10
db "    ldr q11, [x24, #256]", 10
db "    ldr q12, [x24, #272]", 10
db "    ldr q13, [x24, #288]", 10
db "    ldr q14, [x24, #304]", 10
db "    ldr q15, [x24, #320]", 10
db "    ldp x4, x5, [x24, #128]", 10
db "    ldp x29, x30, [x24, #144]", 10
db "    mov sp, x25", 10
db "    ret", 10
db ".cc_none:", 10
db "    mov x0, #0", 10
db "    fmov d0, xzr", 10
db "    ret", 10
db 10
db "; __pt_entry(x0 = the thread's Kron stack): where pthread_create starts a", 10
db "; thread of the program -- pop the function and its argument, leave the room", 10
db "; a call has, call -- then clear the id word and wake whoever waits on it.", 10
db "; The registers the system library expects back are kept on the pthread's", 10
db "; own stack.", 10
db "__pt_entry:", 10
db "    stp x29, x30, [sp, #-16]!", 10
db "    stp x27, x28, [sp, #-16]!", 10
db "    stp x25, x26, [sp, #-16]!", 10
db "    stp x23, x24, [sp, #-16]!", 10
db "    stp x21, x22, [sp, #-16]!", 10
db "    stp x19, x20, [sp, #-16]!", 10
db "    stp d8, d9, [sp, #-16]!", 10
db "    stp d10, d11, [sp, #-16]!", 10
db "    stp d12, d13, [sp, #-16]!", 10
db "    stp d14, d15, [sp, #-16]!", 10
db "    mov x19, x0", 10
db "    ldr x9, [x19]", 10
db "    ldr x1, [x19, #8]", 10
db "    add x28, x19, #16", 10
db "    sub x28, x28, #32", 10
db "    str x30, [x28, #-8]!", 10
db "    blr x9", 10
db "    ldr x30, [x28], #8", 10
db "    ldr x0, [x19, #16]", 10
db "    str wzr, [x0]", 10
db "    mov x1, #1", 10
db "    mov x2, #0x7fffffff", 10
db "    mov x3, #0", 10
db "    mov x8, #98", 10
db "    svc #0", 10
db "    ldp d14, d15, [sp], #16", 10
db "    ldp d12, d13, [sp], #16", 10
db "    ldp d10, d11, [sp], #16", 10
db "    ldp d8, d9, [sp], #16", 10
db "    ldp x19, x20, [sp], #16", 10
db "    ldp x21, x22, [sp], #16", 10
db "    ldp x23, x24, [sp], #16", 10
db "    ldp x25, x26, [sp], #16", 10
db "    ldp x27, x28, [sp], #16", 10
db "    ldp x29, x30, [sp], #16", 10
db "    mov x0, #0", 10
db "    ret", 10
db 10
db "; x86-64 number -> ARM64 number, 0xffff where ARM64 has none", 10
db "section .data", 10
db "__sysx_tab:", 10
db "    dw 63, 64, 56, 57, 79, 80, 79, 65535, 62, 222, 226, 215, 214, 134, 135, 65535", 10
db "    dw 29, 67, 68, 65, 66, 48, 59, 65535, 124, 65535, 65535, 65535, 233, 65535, 65535, 65535", 10
db "    dw 23, 24, 65535, 101, 65535, 65535, 65535, 172, 65535, 198, 203, 202, 206, 207, 211, 212", 10
db "    dw 210, 200, 201, 204, 205, 199, 208, 209, 220, 220, 220, 221, 93, 260, 129, 160", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 25, 32, 82, 83, 45, 46, 65535, 17", 10
db "    dw 49, 50, 38, 34, 35, 65535, 65535, 35, 65535, 78, 53, 65535, 65535, 65535, 65535, 166", 10
db "    dw 169, 163, 65535, 65535, 65535, 65535, 174, 65535, 176, 65535, 65535, 65535, 65535, 65535, 173, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 178, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 130, 65535, 98, 65535, 123, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 61, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 113, 114, 115, 94, 65535, 21, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 56, 34, 65535, 65535, 65535, 79, 35, 38, 65535, 65535, 65535, 65535, 48, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 242, 65535, 65535, 20, 24, 59, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 278, 65535", 10
db "    dw 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535", 10
db 0
xa_tail_lib:
db 10
db "section .text", 10
db "; __centry: where C enters a function a Kron library exports, in the AAPCS64", 10
db "; convention. x9 (r11) = the export's record (dq function, shape, widths,", 10
db "; signed); the integers in x0-x7, the reals in d0-d7, each in order, the rest", 10
db "; on the caller's stack. They go in a row, in the order of the parameters,", 10
db "; to __lib_enter (Kron code, x86-64's convention lowered): until it moves to", 10
db "; this thread's Kron stack, x28 points into the C stack, and sp 64 KB under", 10
db "; it. C keeps x19-x29 and d8-d15; Kron uses some of them, so all are kept.", 10
db "__centry:", 10
db "    stp x29, x30, [sp, #-16]!", 10
db "    stp x27, x28, [sp, #-16]!", 10
db "    stp x25, x26, [sp, #-16]!", 10
db "    stp x23, x24, [sp, #-16]!", 10
db "    stp x21, x22, [sp, #-16]!", 10
db "    stp x19, x20, [sp, #-16]!", 10
db "    stp d8, d9, [sp, #-16]!", 10
db "    stp d10, d11, [sp, #-16]!", 10
db "    stp d12, d13, [sp, #-16]!", 10
db "    stp d14, d15, [sp, #-16]!", 10
db "    mov x19, sp", 10
db "    sub sp, sp, #256", 10
db "    mov x10, sp", 10
db "    stp x0, x1, [x10]", 10
db "    stp x2, x3, [x10, #16]", 10
db "    stp x4, x5, [x10, #32]", 10
db "    stp x6, x7, [x10, #48]", 10
db "    stp d0, d1, [x10, #64]", 10
db "    stp d2, d3, [x10, #80]", 10
db "    stp d4, d5, [x10, #96]", 10
db "    stp d6, d7, [x10, #112]", 10
db "    ldr x11, [x9, #8]", 10
db "    and x12, x11, #255", 10
db "    mov x13, #0", 10
db "    mov x14, #0", 10
db "    mov x15, #0", 10
db "    add x16, x19, #160", 10
db "    mov x17, #0", 10
db ".ce_arg:", 10
db "    cmp x13, x12", 10
db "    b.hs .ce_go", 10
db "    add x3, x13, #8", 10
db "    lsr x3, x11, x3", 10
db "    and x3, x3, #1", 10
db "    cbz x3, .ce_int", 10
db "    cmp x15, #8", 10
db "    b.hs .ce_stk", 10
db "    add x3, x10, #64", 10
db "    ldr x4, [x3, x15, lsl #3]", 10
db "    add x15, x15, #1", 10
db "    b .ce_put", 10
db ".ce_int:", 10
db "    cmp x14, #8", 10
db "    b.hs .ce_stk", 10
db "    ldr x4, [x10, x14, lsl #3]", 10
db "    add x14, x14, #1", 10
db "    b .ce_put", 10
db ".ce_stk:", 10
db "    ldr x4, [x16, x17]", 10
db "    add x17, x17, #8", 10
db ".ce_put:", 10
db "    add x3, x10, #128", 10
db "    str x4, [x3, x13, lsl #3]", 10
db "    add x13, x13, #1", 10
db "    b .ce_arg", 10
db ".ce_go:", 10
db "    sub x28, x10, #16", 10
db "    mov x3, #65536", 10
db "    sub x3, x28, x3", 10
db "    mov sp, x3", 10
db "    mov x1, x9", 10
db "    add x2, x10, #128", 10
db "    str x30, [x28, #-8]!", 10
db "    bl __lib_enter", 10
db "    ldr x30, [x28], #8", 10
db "    mov sp, x19", 10
db "    ldp d14, d15, [sp], #16", 10
db "    ldp d12, d13, [sp], #16", 10
db "    ldp d10, d11, [sp], #16", 10
db "    ldp d8, d9, [sp], #16", 10
db "    ldp x19, x20, [sp], #16", 10
db "    ldp x21, x22, [sp], #16", 10
db "    ldp x23, x24, [sp], #16", 10
db "    ldp x25, x26, [sp], #16", 10
db "    ldp x27, x28, [sp], #16", 10
db "    ldp x29, x30, [sp], #16", 10
db "    ret", 10
db 0
xa_tail_lib_mac:
db 10
db "section .text", 10
db "; __centry: where C enters a function a Kron library exports, in the AAPCS64", 10
db "; convention. x9 (r11) = the export's record (dq function, shape, widths,", 10
db "; signed); the integers in x0-x7, the reals in d0-d7, each in order, the rest", 10
db "; on the caller's stack, packed by width as Apple's convention has it. They go in a row, in the order of the parameters,", 10
db "; to __lib_enter (Kron code, x86-64's convention lowered): until it moves to", 10
db "; this thread's Kron stack, x28 points into the C stack, and sp 64 KB under", 10
db "; it. C keeps x19-x29 and d8-d15; Kron uses some of them, so all are kept.", 10
db "__centry:", 10
db "    stp x29, x30, [sp, #-16]!", 10
db "    stp x27, x28, [sp, #-16]!", 10
db "    stp x25, x26, [sp, #-16]!", 10
db "    stp x23, x24, [sp, #-16]!", 10
db "    stp x21, x22, [sp, #-16]!", 10
db "    stp x19, x20, [sp, #-16]!", 10
db "    stp d8, d9, [sp, #-16]!", 10
db "    stp d10, d11, [sp, #-16]!", 10
db "    stp d12, d13, [sp, #-16]!", 10
db "    stp d14, d15, [sp, #-16]!", 10
db "    mov x19, sp", 10
db "    sub sp, sp, #256", 10
db "    mov x10, sp", 10
db "    stp x0, x1, [x10]", 10
db "    stp x2, x3, [x10, #16]", 10
db "    stp x4, x5, [x10, #32]", 10
db "    stp x6, x7, [x10, #48]", 10
db "    stp d0, d1, [x10, #64]", 10
db "    stp d2, d3, [x10, #80]", 10
db "    stp d4, d5, [x10, #96]", 10
db "    stp d6, d7, [x10, #112]", 10
db "    ldr x11, [x9, #8]", 10
db "    and x12, x11, #255", 10
db "    mov x13, #0", 10
db "    mov x14, #0", 10
db "    mov x15, #0", 10
db "    add x16, x19, #160", 10
db "    mov x17, #0", 10
db ".ce_arg:", 10
db "    cmp x13, x12", 10
db "    b.hs .ce_go", 10
db "    add x3, x13, #8", 10
db "    lsr x3, x11, x3", 10
db "    and x3, x3, #1", 10
db "    cbz x3, .ce_int", 10
db "    cmp x15, #8", 10
db "    b.hs .ce_stk", 10
db "    add x3, x10, #64", 10
db "    ldr x4, [x3, x15, lsl #3]", 10
db "    add x15, x15, #1", 10
db "    b .ce_put", 10
db ".ce_int:", 10
db "    cmp x14, #8", 10
db "    b.hs .ce_stk", 10
db "    ldr x4, [x10, x14, lsl #3]", 10
db "    add x14, x14, #1", 10
db "    b .ce_put", 10
db ".ce_stk:", 10
db "    ldr x5, [x9, #16]", 10
db "    lsl x3, x13, #1", 10
db "    lsr x5, x5, x3", 10
db "    and x5, x5, #3", 10
db "    cbz x5, .ce_s8", 10
db "    cmp x5, #1", 10
db "    b.eq .ce_s4", 10
db "    cmp x5, #2", 10
db "    b.eq .ce_s2", 10
db "    ldrb w4, [x16, x17]", 10
db "    add x17, x17, #1", 10
db "    b .ce_put", 10
db ".ce_s2:", 10
db "    add x17, x17, #1", 10
db "    and x17, x17, #0xfffffffffffffffe", 10
db "    ldrh w4, [x16, x17]", 10
db "    add x17, x17, #2", 10
db "    b .ce_put", 10
db ".ce_s4:", 10
db "    add x17, x17, #3", 10
db "    and x17, x17, #0xfffffffffffffffc", 10
db "    ldr w4, [x16, x17]", 10
db "    add x17, x17, #4", 10
db "    b .ce_put", 10
db ".ce_s8:", 10
db "    add x17, x17, #7", 10
db "    and x17, x17, #0xfffffffffffffff8", 10
db "    ldr x4, [x16, x17]", 10
db "    add x17, x17, #8", 10
db ".ce_put:", 10
db "    add x3, x10, #128", 10
db "    str x4, [x3, x13, lsl #3]", 10
db "    add x13, x13, #1", 10
db "    b .ce_arg", 10
db ".ce_go:", 10
db "    sub x28, x10, #16", 10
db "    mov x3, #65536", 10
db "    sub x3, x28, x3", 10
db "    mov sp, x3", 10
db "    mov x1, x9", 10
db "    add x2, x10, #128", 10
db "    str x30, [x28, #-8]!", 10
db "    bl __lib_enter", 10
db "    ldr x30, [x28], #8", 10
db "    mov sp, x19", 10
db "    ldp d14, d15, [sp], #16", 10
db "    ldp d12, d13, [sp], #16", 10
db "    ldp d10, d11, [sp], #16", 10
db "    ldp d8, d9, [sp], #16", 10
db "    ldp x19, x20, [sp], #16", 10
db "    ldp x21, x22, [sp], #16", 10
db "    ldp x23, x24, [sp], #16", 10
db "    ldp x25, x26, [sp], #16", 10
db "    ldp x27, x28, [sp], #16", 10
db "    ldp x29, x30, [sp], #16", 10
db "    ret", 10
db 0
xa_tail_mac:
db 10
db "; ==============================================================================", 10
db "; macOS: the program is the Linux one; these routines give it what it asks", 10
db "; of Linux, from XNU (svc #0x80, the number in x16, an error as a positive", 10
db "; errno with the carry set) and, for threads, from the system library.", 10
db ";", 10
db "; __mac_main   dyld's entry (argc x0, argv x1, envp x2): the stack Linux hands", 10
db ";              to _start -- argc, the arguments, 0, the environment, 0 -- then", 10
db ";              _start", 10
db "; __sysx       a Linux system call, x86-64 numbering: x0 = number; x5 x4 x2", 10
db ";              x8 x6 x7 = rdi rsi rdx r10 r8 r9. The result in x0, -errno with", 10
db ";              Linux's numbers on a failure; every register Kron uses survives", 10
db ";              but rcx and r11 (x1 x9). x17 holds the caller's return address.", 10
db ";              Call 1100, which Linux does not have, answers 1: macOS.", 10
db ";              Its frame: 2 KB under x28, the Kron stack, which nothing below", 10
db ";              its top uses; calls into the system library run on a stack", 10
db ";              under that.", 10
db "; __mac_thread where a thread of the program starts (pthread_create)", 10
db "; ==============================================================================", 10
db "section .text", 10
db "__mac_main:", 10
db "    adrl x9, __mac_envp", 10
db "    str x2, [x9]", 10
db "    mov x10, #0", 10
db ".ec:", 10
db "    ldr x11, [x2, x10, lsl #3]", 10
db "    cbz x11, .ecd", 10
db "    add x10, x10, #1", 10
db "    b .ec", 10
db ".ecd:", 10
db "    add x11, x0, x10", 10
db "    add x11, x11, #3", 10
db "    lsl x11, x11, #3", 10
db "    add x11, x11, #15", 10
db "    and x11, x11, #0xfffffffffffffff0", 10
db "    mov x13, sp", 10
db "    sub x12, x13, x11", 10
db "    mov sp, x12", 10
db "    str x0, [x12]", 10
db "    add x13, x12, #8", 10
db "    mov x14, #0", 10
db ".av:", 10
db "    cmp x14, x0", 10
db "    b.hs .avd", 10
db "    ldr x15, [x1, x14, lsl #3]", 10
db "    str x15, [x13, x14, lsl #3]", 10
db "    add x14, x14, #1", 10
db "    b .av", 10
db ".avd:", 10
db "    str xzr, [x13, x14, lsl #3]", 10
db "    add x14, x14, #1", 10
db "    lsl x15, x14, #3", 10
db "    add x13, x13, x15", 10
db "    mov x14, #0", 10
db ".ev:", 10
db "    cmp x14, x10", 10
db "    b.hs .evd", 10
db "    ldr x15, [x2, x14, lsl #3]", 10
db "    str x15, [x13, x14, lsl #3]", 10
db "    add x14, x14, #1", 10
db "    b .ev", 10
db ".evd:", 10
db "    str xzr, [x13, x14, lsl #3]", 10
db "    b _start", 10
db 10
db "__sysx:", 10
db "    sub x16, x28, #2048", 10
db "    and x16, x16, #0xfffffffffffffff0", 10
db "    stp x2, x4, [x16]", 10
db "    stp x5, x6, [x16, #16]", 10
db "    stp x7, x8, [x16, #32]", 10
db "    stp x17, x30, [x16, #48]", 10
db "    mov x24, x16", 10
db "    mov x9, x0", 10
db "    mov x0, x5", 10
db "    mov x1, x4", 10
db "    mov x3, x8", 10
db "    mov x4, x6", 10
db "    mov x5, x7", 10
db "    ; 1100: the system under the Linux program -- 1 macOS (2 the web)", 10
db "    cmp x9, #1100", 10
db "    b.eq .is_mac", 10
db "    cmp x9, #335", 10
db "    b.hs .nosys", 10
db "    adrl x16, __msys_tab", 10
db "    ldrh w16, [x16, x9, lsl #1]", 10
db "    cbz x16, .nosys", 10
db "    cmp x16, #1000", 10
db "    b.hs .special", 10
db ".direct:", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    b .back", 10
db ".nosys:", 10
db "    mov x0, #-38", 10
db "    b .back", 10
db ".zero:", 10
db "    mov x0, #0", 10
db "    b .back", 10
db ".is_mac:", 10
db "    mov x0, #1", 10
db "    b .back", 10
db "; macOS errno -> Linux errno, negated", 10
db ".fail:", 10
db "    mov x9, #11", 10
db "    cmp x0, #35", 10
db "    b.eq .fneg", 10
db "    mov x9, #38", 10
db "    cmp x0, #78", 10
db "    b.eq .fneg", 10
db "    mov x9, #39", 10
db "    cmp x0, #66", 10
db "    b.eq .fneg", 10
db "    mov x9, #36", 10
db "    cmp x0, #63", 10
db "    b.eq .fneg", 10
db "    mov x9, #40", 10
db "    cmp x0, #62", 10
db "    b.eq .fneg", 10
db "    mov x9, #110", 10
db "    cmp x0, #60", 10
db "    b.eq .fneg", 10
db "    mov x9, #111", 10
db "    cmp x0, #61", 10
db "    b.eq .fneg", 10
db "    mov x9, #98", 10
db "    cmp x0, #48", 10
db "    b.eq .fneg", 10
db "    mov x9, #104", 10
db "    cmp x0, #54", 10
db "    b.eq .fneg", 10
db "    mov x9, #107", 10
db "    cmp x0, #57", 10
db "    b.eq .fneg", 10
db "    mov x9, #115", 10
db "    cmp x0, #36", 10
db "    b.eq .fneg", 10
db "    mov x9, #95", 10
db "    cmp x0, #45", 10
db "    b.eq .fneg", 10
db "    mov x9, x0", 10
db ".fneg:", 10
db "    neg x0, x9", 10
db ".back:", 10
db "    ldp x2, x4, [x24]", 10
db "    ldp x5, x6, [x24, #16]", 10
db "    ldp x7, x8, [x24, #32]", 10
db "    ldp x17, x30, [x24, #48]", 10
db "    ret", 10
db ".special:", 10
db "    cmp x9, #0", 10
db "    b.eq .read", 10
db "    cmp x9, #2", 10
db "    b.eq .open", 10
db "    cmp x9, #3", 10
db "    b.eq .close", 10
db "    cmp x9, #4", 10
db "    b.eq .stat", 10
db "    cmp x9, #5", 10
db "    b.eq .fstat", 10
db "    cmp x9, #6", 10
db "    b.eq .lstat", 10
db "    cmp x9, #9", 10
db "    b.eq .mmap", 10
db "    cmp x9, #13", 10
db "    b.eq .zero", 10
db "    cmp x9, #14", 10
db "    b.eq .zero", 10
db "    cmp x9, #22", 10
db "    b.eq .pipe", 10
db "    cmp x9, #24", 10
db "    b.eq .yield", 10
db "    cmp x9, #35", 10
db "    b.eq .sleep", 10
db "    cmp x9, #41", 10
db "    b.eq .socket", 10
db "    cmp x9, #42", 10
db "    b.eq .connect", 10
db "    cmp x9, #43", 10
db "    b.eq .accept", 10
db "    cmp x9, #44", 10
db "    b.eq .sendto", 10
db "    cmp x9, #45", 10
db "    b.eq .recvfrom", 10
db "    cmp x9, #49", 10
db "    b.eq .bind", 10
db "    cmp x9, #54", 10
db "    b.eq .setsockopt", 10
db "    cmp x9, #56", 10
db "    b.eq .clone", 10
db "    cmp x9, #57", 10
db "    b.eq .fork", 10
db "    cmp x9, #58", 10
db "    b.eq .fork", 10
db "    cmp x9, #79", 10
db "    b.eq .getcwd", 10
db "    cmp x9, #96", 10
db "    b.eq .gettimeofday", 10
db "    cmp x9, #202", 10
db "    b.eq .futex", 10
db "    cmp x9, #204", 10
db "    b.eq .affinity", 10
db "    cmp x9, #217", 10
db "    b.eq .getdents", 10
db "    cmp x9, #228", 10
db "    b.eq .clock", 10
db "    cmp x9, #257", 10
db "    b.eq .openat", 10
db "    cmp x9, #318", 10
db "    b.eq .getrandom", 10
db "    b .nosys", 10
db 10
db "; ---- files ---------------------------------------------------------------------", 10
db "; /proc/self/environ does not exist on macOS: a descriptor of its own reads", 10
db "; the environment dyld handed over, each NAME=value ending in a 0", 10
db ".read:", 10
db "    mov x9, #0x7fffff00", 10
db "    cmp x0, x9", 10
db "    b.eq .envread", 10
db "    mov x16, #3", 10
db "    b .direct", 10
db ".envread:", 10
db "    adrl x9, __mac_envp", 10
db "    ldr x10, [x9]", 10
db "    adrl x9, __mac_envi", 10
db "    ldr x11, [x9]", 10
db "    ldr x12, [x9, #8]", 10
db "    mov x13, #0", 10
db ".er:", 10
db "    cmp x13, x2", 10
db "    b.hs .erd", 10
db "    ldr x14, [x10, x11, lsl #3]", 10
db "    cbz x14, .erd", 10
db "    ldrb w15, [x14, x12]", 10
db "    strb w15, [x1, x13]", 10
db "    add x13, x13, #1", 10
db "    add x12, x12, #1", 10
db "    cbnz w15, .er", 10
db "    add x11, x11, #1", 10
db "    mov x12, #0", 10
db "    b .er", 10
db ".erd:", 10
db "    str x11, [x9]", 10
db "    str x12, [x9, #8]", 10
db "    mov x0, x13", 10
db "    b .back", 10
db ".close:", 10
db "    mov x9, #0x7fffff00", 10
db "    cmp x0, x9", 10
db "    b.eq .zero", 10
db "    mov x16, #6", 10
db "    b .direct", 10
db ".open:", 10
db "    adrl x9, __mac_envname", 10
db "    mov x10, #0", 10
db ".oe:", 10
db "    ldrb w11, [x0, x10]", 10
db "    ldrb w12, [x9, x10]", 10
db "    cmp w11, w12", 10
db "    b.ne .oflags", 10
db "    add x10, x10, #1", 10
db "    cbnz w11, .oe", 10
db "    adrl x9, __mac_envi", 10
db "    str xzr, [x9]", 10
db "    str xzr, [x9, #8]", 10
db "    mov x0, #0x7fffff00", 10
db "    b .back", 10
db ".openat:", 10
db "    ; openat(dir, path, flags, mode): AT_FDCWD is -100 on Linux, -2 here", 10
db "    cmn x0, #100", 10
db "    b.ne .oat", 10
db "    mov x0, #-2", 10
db ".oat:", 10
db "    mov x10, x1", 10
db "    mov x1, x2", 10
db "    bl .oflagbits", 10
db "    mov x2, x1", 10
db "    mov x1, x10", 10
db "    mov x16, #463", 10
db "    b .direct", 10
db ".oflags:", 10
db "    bl .oflagbits", 10
db "    mov x16, #5", 10
db "    b .direct", 10
db "; x1: Linux open flags -> macOS ones (x9, x16 used)", 10
db ".oflagbits:", 10
db "    and x9, x1, #3", 10
db "    tst x1, #0x40", 10
db "    b.eq .of1", 10
db "    orr x9, x9, #0x200", 10
db ".of1:", 10
db "    tst x1, #0x80", 10
db "    b.eq .of2", 10
db "    orr x9, x9, #0x800", 10
db ".of2:", 10
db "    tst x1, #0x200", 10
db "    b.eq .of3", 10
db "    orr x9, x9, #0x400", 10
db ".of3:", 10
db "    tst x1, #0x400", 10
db "    b.eq .of4", 10
db "    orr x9, x9, #0x8", 10
db ".of4:", 10
db "    tst x1, #0x800", 10
db "    b.eq .of5", 10
db "    orr x9, x9, #0x4", 10
db ".of5:", 10
db "    tst x1, #0x10000", 10
db "    b.eq .of6", 10
db "    orr x9, x9, #0x100000", 10
db ".of6:", 10
db "    tst x1, #0x20000", 10
db "    b.eq .of7", 10
db "    orr x9, x9, #0x100", 10
db ".of7:", 10
db "    tst x1, #0x80000", 10
db "    b.eq .of8", 10
db "    orr x9, x9, #0x1000000", 10
db ".of8:", 10
db "    mov x1, x9", 10
db "    ret", 10
db 10
db "; stat, lstat, fstat: macOS's stat64 into the scratch, then the fields in", 10
db "; the places Linux x86-64 has them", 10
db ".stat:", 10
db "    mov x10, x1", 10
db "    add x1, x24, #256", 10
db "    mov x16, #338", 10
db "    b .st_go", 10
db ".lstat:", 10
db "    mov x10, x1", 10
db "    add x1, x24, #256", 10
db "    mov x16, #340", 10
db "    b .st_go", 10
db ".fstat:", 10
db "    mov x10, x1", 10
db "    add x1, x24, #256", 10
db "    mov x16, #339", 10
db ".st_go:", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    add x11, x24, #256", 10
db "    mov x12, #0", 10
db ".st_z:", 10
db "    str xzr, [x10, x12]", 10
db "    add x12, x12, #8", 10
db "    cmp x12, #144", 10
db "    b.lo .st_z", 10
db "    ldrsw x12, [x11]", 10
db "    str x12, [x10]", 10
db "    ldr x12, [x11, #8]", 10
db "    str x12, [x10, #8]", 10
db "    ldrh w12, [x11, #6]", 10
db "    str x12, [x10, #16]", 10
db "    ldrh w12, [x11, #4]", 10
db "    str w12, [x10, #24]", 10
db "    ldr w12, [x11, #16]", 10
db "    str w12, [x10, #28]", 10
db "    ldr w12, [x11, #20]", 10
db "    str w12, [x10, #32]", 10
db "    ldrsw x12, [x11, #24]", 10
db "    str x12, [x10, #40]", 10
db "    ldr x12, [x11, #96]", 10
db "    str x12, [x10, #48]", 10
db "    ldrsw x12, [x11, #112]", 10
db "    str x12, [x10, #56]", 10
db "    ldr x12, [x11, #104]", 10
db "    str x12, [x10, #64]", 10
db "    ldp x12, x13, [x11, #32]", 10
db "    stp x12, x13, [x10, #72]", 10
db "    ldp x12, x13, [x11, #48]", 10
db "    stp x12, x13, [x10, #88]", 10
db "    ldp x12, x13, [x11, #64]", 10
db "    stp x12, x13, [x10, #104]", 10
db "    mov x0, #0", 10
db "    b .back", 10
db 10
db "; getdents64 is getdirentries64; each record moves its type and its name two", 10
db "; bytes down, to where Linux has them", 10
db ".getdents:", 10
db "    mov x5, x1", 10
db "    add x3, x24, #64", 10
db "    mov x16, #344", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    mov x10, #0", 10
db ".gd:", 10
db "    cmp x10, x0", 10
db "    b.hs .back", 10
db "    add x11, x5, x10", 10
db "    ldrh w12, [x11, #16]", 10
db "    cbz w12, .back", 10
db "    ldrb w13, [x11, #20]", 10
db "    mov x14, #0", 10
db ".gdn:", 10
db "    add x15, x14, #21", 10
db "    ldrb w9, [x11, x15]", 10
db "    add x15, x14, #19", 10
db "    strb w9, [x11, x15]", 10
db "    add x14, x14, #1", 10
db "    cbnz w9, .gdn", 10
db "    strb w13, [x11, #18]", 10
db "    add x10, x10, x12", 10
db "    b .gd", 10
db 10
db ".getcwd:", 10
db "    mov x10, x0", 10
db "    cmp x1, #1024", 10
db "    b.hs .gc1", 10
db "    mov x0, #-34", 10
db "    b .back", 10
db ".gc1:", 10
db "    adrl x0, __mac_dot", 10
db "    mov x1, #0x100000", 10
db "    mov x2, #0", 10
db "    mov x16, #5", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    mov x11, x0", 10
db "    mov x1, #50", 10
db "    mov x2, x10", 10
db "    mov x16, #92", 10
db "    svc #0x80", 10
db "    cset x12, cs", 10
db "    mov x13, x0", 10
db "    mov x0, x11", 10
db "    mov x16, #6", 10
db "    svc #0x80", 10
db "    mov x0, x13", 10
db "    cbnz x12, .fail", 10
db "    mov x0, #0", 10
db ".gcl:", 10
db "    ldrb w9, [x10, x0]", 10
db "    add x0, x0, #1", 10
db "    cbnz w9, .gcl", 10
db "    b .back", 10
db 10
db "; ---- memory --------------------------------------------------------------------", 10
db ".mmap:", 10
db "    and x9, x3, #0x3", 10
db "    tst x3, #0x10", 10
db "    b.eq .mm0", 10
db "    orr x9, x9, #0x10", 10
db ".mm0:", 10
db "    tst x3, #0x20", 10
db "    b.eq .mm1", 10
db "    orr x9, x9, #0x1000", 10
db ".mm1:", 10
db "    mov x3, x9", 10
db "    mov x16, #197", 10
db "    b .direct", 10
db 10
db "; ---- processes -----------------------------------------------------------------", 10
db ".pipe:", 10
db "    mov x10, x0", 10
db "    mov x16, #42", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    str w0, [x10]", 10
db "    str w1, [x10, #4]", 10
db "    mov x0, #0", 10
db "    b .back", 10
db ".fork:", 10
db "    mov x16, #2", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    cbz x1, .back", 10
db "    mov x0, #0", 10
db "    b .back", 10
db ".yield:", 10
db "    mov x0, #0", 10
db "    mov x16, #-60", 10
db "    svc #0x80", 10
db "    mov x0, #0", 10
db "    b .back", 10
db 10
db "; ---- time ----------------------------------------------------------------------", 10
db "; the wall clock: gettimeofday, which fills the structure or, on older", 10
db "; systems, returns the seconds and microseconds in x0 and x1", 10
db ".walltime:", 10
db "    add x0, x24, #64", 10
db "    str xzr, [x0]", 10
db "    str xzr, [x0, #8]", 10
db "    mov x1, #0", 10
db "    mov x2, #0", 10
db "    mov x16, #116", 10
db "    svc #0x80", 10
db "    cbz x0, .wt1", 10
db "    mov x13, x0", 10
db "    mov w14, w1", 10
db "    ret", 10
db ".wt1:", 10
db "    add x9, x24, #64", 10
db "    ldr x13, [x9]", 10
db "    ldr w14, [x9, #8]", 10
db "    ret", 10
db ".gettimeofday:", 10
db "    mov x10, x0", 10
db "    bl .walltime", 10
db "    cbz x10, .zero", 10
db "    str x13, [x10]", 10
db "    str x14, [x10, #8]", 10
db "    b .zero", 10
db ".clock:", 10
db "    mov x10, x1", 10
db "    cmp x0, #0", 10
db "    b.eq .clk_wall", 10
db "    cmp x0, #5", 10
db "    b.eq .clk_wall", 10
db "    ; the rest are monotonic: the system counter and its frequency", 10
db "    dd 0xD53BE040", 10
db "    dd 0xD53BE001", 10
db "    udiv x11, x0, x1", 10
db "    msub x12, x11, x1, x0", 10
db "    mov x13, #1000000000", 10
db "    mul x12, x12, x13", 10
db "    udiv x12, x12, x1", 10
db "    str x11, [x10]", 10
db "    str x12, [x10, #8]", 10
db "    b .zero", 10
db ".clk_wall:", 10
db "    bl .walltime", 10
db "    mov x9, #1000", 10
db "    mul x14, x14, x9", 10
db "    str x13, [x10]", 10
db "    str x14, [x10, #8]", 10
db "    b .zero", 10
db "; nanosleep: select with nothing to watch and a timeout", 10
db ".sleep:", 10
db "    ldr x10, [x0]", 10
db "    ldr x11, [x0, #8]", 10
db "    mov x9, #1000", 10
db "    udiv x11, x11, x9", 10
db "    add x4, x24, #64", 10
db "    str x10, [x4]", 10
db "    str w11, [x4, #8]", 10
db "    str wzr, [x4, #12]", 10
db "    mov x0, #0", 10
db "    mov x1, #0", 10
db "    mov x2, #0", 10
db "    mov x3, #0", 10
db "    mov x16, #93", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    b .zero", 10
db 10
db "; ---- the processors, random bytes ----------------------------------------------", 10
db "; sched_getaffinity: as many bits as sysctl hw.ncpu says", 10
db ".affinity:", 10
db "    mov x10, x1", 10
db "    mov x11, x2", 10
db "    add x0, x24, #64", 10
db "    mov w9, #6", 10
db "    str w9, [x0]", 10
db "    mov w9, #3", 10
db "    str w9, [x0, #4]", 10
db "    mov x1, #2", 10
db "    add x2, x24, #72", 10
db "    str xzr, [x2]", 10
db "    add x3, x24, #80", 10
db "    mov x9, #4", 10
db "    str x9, [x3]", 10
db "    mov x4, #0", 10
db "    mov x5, #0", 10
db "    mov x16, #202", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    add x9, x24, #72", 10
db "    ldr w12, [x9]", 10
db "    cmp x12, #1", 10
db "    b.ge .af1", 10
db "    mov x12, #1", 10
db ".af1:", 10
db "    cmp x12, #64", 10
db "    b.le .af2", 10
db "    mov x12, #64", 10
db ".af2:", 10
db "    cmp x10, #8", 10
db "    b.hs .af3", 10
db "    mov x0, #-22", 10
db "    b .back", 10
db ".af3:", 10
db "    mov x13, #1", 10
db "    lsl x13, x13, x12", 10
db "    sub x13, x13, #1", 10
db "    cmp x12, #64", 10
db "    b.ne .af4", 10
db "    mov x13, #-1", 10
db ".af4:", 10
db "    str x13, [x11]", 10
db "    mov x0, #8", 10
db "    b .back", 10
db "; getrandom: getentropy, 256 bytes at a time", 10
db ".getrandom:", 10
db "    mov x10, x0", 10
db "    mov x11, x1", 10
db "    mov x12, #0", 10
db ".gr:", 10
db "    cmp x12, x11", 10
db "    b.hs .grd", 10
db "    sub x1, x11, x12", 10
db "    cmp x1, #256", 10
db "    b.ls .gr1", 10
db "    mov x1, #256", 10
db ".gr1:", 10
db "    mov x13, x1", 10
db "    add x0, x10, x12", 10
db "    mov x16, #500", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    add x12, x12, x13", 10
db "    b .gr", 10
db ".grd:", 10
db "    mov x0, x11", 10
db "    b .back", 10
db 10
db "; ---- sockets -------------------------------------------------------------------", 10
db "; a socket that writes to a closed peer gets an error, not a signal", 10
db ".socket:", 10
db "    mov x16, #97", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db ".nosigpipe:", 10
db "    mov x10, x0", 10
db "    add x3, x24, #64", 10
db "    mov w9, #1", 10
db "    str w9, [x3]", 10
db "    mov x1, #0xffff", 10
db "    mov x2, #0x1022", 10
db "    mov x4, #4", 10
db "    mov x16, #105", 10
db "    svc #0x80", 10
db "    mov x0, x10", 10
db "    b .back", 10
db ".accept:", 10
db "    mov x16, #30", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    b .nosigpipe", 10
db "; the address: macOS has its length in the first byte, the family in the", 10
db "; second, where Linux has a 16-bit family", 10
db ".connect:", 10
db "    mov x16, #98", 10
db "    b .sa", 10
db ".bind:", 10
db "    mov x16, #104", 10
db ".sa:", 10
db "    cmp x2, #128", 10
db "    b.ls .sa1", 10
db "    mov x2, #128", 10
db ".sa1:", 10
db "    add x10, x24, #64", 10
db "    mov x11, #0", 10
db ".sa2:", 10
db "    cmp x11, x2", 10
db "    b.hs .sa3", 10
db "    ldrb w12, [x1, x11]", 10
db "    strb w12, [x10, x11]", 10
db "    add x11, x11, #1", 10
db "    b .sa2", 10
db ".sa3:", 10
db "    ldrb w12, [x1]", 10
db "    strb w2, [x10]", 10
db "    strb w12, [x10, #1]", 10
db "    mov x1, x10", 10
db "    b .direct", 10
db "; MSG_DONTWAIT is 0x40 on Linux, 0x80 here; MSG_NOSIGNAL has no equal (the", 10
db "; socket has SO_NOSIGPIPE); MSG_WAITALL is 0x100 there, 0x40 here", 10
db ".sendto:", 10
db "    and x9, x3, #0x1", 10
db "    tst x3, #0x4", 10
db "    b.eq .sd0", 10
db "    orr x9, x9, #0x4", 10
db ".sd0:", 10
db "    tst x3, #0x40", 10
db "    b.eq .sd1", 10
db "    orr x9, x9, #0x80", 10
db ".sd1:", 10
db "    mov x3, x9", 10
db "    mov x16, #133", 10
db "    b .direct", 10
db ".recvfrom:", 10
db "    and x9, x3, #0x3", 10
db "    tst x3, #0x40", 10
db "    b.eq .rf1", 10
db "    orr x9, x9, #0x80", 10
db ".rf1:", 10
db "    tst x3, #0x100", 10
db "    b.eq .rf2", 10
db "    orr x9, x9, #0x40", 10
db ".rf2:", 10
db "    mov x3, x9", 10
db "    mov x16, #29", 10
db "    b .direct", 10
db "; SOL_SOCKET is 1 on Linux, 0xffff here, and the options are numbered apart", 10
db ".setsockopt:", 10
db "    cmp x1, #1", 10
db "    b.ne .so_go", 10
db "    mov x1, #0xffff", 10
db "    cmp x2, #2", 10
db "    b.ne .so1", 10
db "    mov x2, #4", 10
db "    b .so_go", 10
db ".so1:", 10
db "    cmp x2, #9", 10
db "    b.ne .so2", 10
db "    mov x2, #8", 10
db "    b .so_go", 10
db ".so2:", 10
db "    cmp x2, #15", 10
db "    b.ne .so3", 10
db "    mov x2, #0x200", 10
db "    b .so_go", 10
db ".so3:", 10
db "    cmp x2, #13", 10
db "    b.ne .so_go", 10
db "    mov x2, #0x80", 10
db ".so_go:", 10
db "    mov x16, #105", 10
db "    b .direct", 10
db 10
db "; ---- threads -------------------------------------------------------------------", 10
db "; futex: __ulock_wait and __ulock_wake, on the same 32-bit word", 10
db ".futex:", 10
db "    and x9, x1, #127", 10
db "    cbz x9, .fwait", 10
db "    cmp x9, #1", 10
db "    b.eq .fwake", 10
db "    b .nosys", 10
db ".fwait:", 10
db "    mov x1, x0", 10
db "    mov x0, #1", 10
db "    mov x3, #0", 10
db "    mov x16, #515", 10
db "    svc #0x80", 10
db "    b.cs .fail", 10
db "    b .zero", 10
db ".fwake:", 10
db "    mov x1, x0", 10
db "    mov x0, #1", 10
db "    cmp x2, #1", 10
db "    b.le .fw1", 10
db "    mov x0, #0x101", 10
db ".fw1:", 10
db "    mov x2, #0", 10
db "    mov x16, #516", 10
db "    svc #0x80", 10
db "    b.cc .zero", 10
db "    cmp x0, #2", 10
db "    b.eq .zero", 10
db "    b .fail", 10
db "; clone, as __thread_start uses it: x1 = the thread's Kron stack (function", 10
db "; and argument on it), x2 = the word that gets the thread's id now, x3 = the", 10
db "; word cleared and woken when the thread ends. A pthread runs it.", 10
db ".clone:", 10
db "    str x3, [x1, #16]", 10
db "    lsr x9, x1, #12", 10
db "    and x9, x9, #0x7fffffff", 10
db "    orr x9, x9, #1", 10
db "    str w9, [x2]", 10
db "    mov x26, x9", 10
db "    mov x27, x2", 10
db "    mov x10, x1", 10
db "    ; a frame for the system library, under the scratch; the vector", 10
db "    ; registers kept, since Kron keeps reals in them across a system call", 10
db "    mov x25, sp", 10
db "    sub x9, x24, #512", 10
db "    mov sp, x9", 10
db "    str q0, [sp, #0]", 10
db "    str q1, [sp, #16]", 10
db "    str q2, [sp, #32]", 10
db "    str q3, [sp, #48]", 10
db "    str q4, [sp, #64]", 10
db "    str q5, [sp, #80]", 10
db "    str q6, [sp, #96]", 10
db "    str q7, [sp, #112]", 10
db "    str q8, [sp, #128]", 10
db "    str q9, [sp, #144]", 10
db "    str q10, [sp, #160]", 10
db "    str q11, [sp, #176]", 10
db "    str q12, [sp, #192]", 10
db "    str q13, [sp, #208]", 10
db "    str q14, [sp, #224]", 10
db "    str q15, [sp, #240]", 10
db "    add x0, sp, #256", 10
db "    mov x1, #0", 10
db "    adrl x2, __mac_thread", 10
db "    mov x3, x10", 10
db "    adrl x16, __mac_got_create", 10
db "    ldr x16, [x16]", 10
db "    blr x16", 10
db "    cbnz x0, .cl_fail", 10
db "    add x9, sp, #256", 10
db "    ldr x0, [x9]", 10
db "    adrl x16, __mac_got_detach", 10
db "    ldr x16, [x16]", 10
db "    blr x16", 10
db "    mov x0, x26", 10
db "    b .cl_out", 10
db ".cl_fail:", 10
db "    str wzr, [x27]", 10
db "    mov x0, #-11", 10
db ".cl_out:", 10
db "    ldr q0, [sp, #0]", 10
db "    ldr q1, [sp, #16]", 10
db "    ldr q2, [sp, #32]", 10
db "    ldr q3, [sp, #48]", 10
db "    ldr q4, [sp, #64]", 10
db "    ldr q5, [sp, #80]", 10
db "    ldr q6, [sp, #96]", 10
db "    ldr q7, [sp, #112]", 10
db "    ldr q8, [sp, #128]", 10
db "    ldr q9, [sp, #144]", 10
db "    ldr q10, [sp, #160]", 10
db "    ldr q11, [sp, #176]", 10
db "    ldr q12, [sp, #192]", 10
db "    ldr q13, [sp, #208]", 10
db "    ldr q14, [sp, #224]", 10
db "    ldr q15, [sp, #240]", 10
db "    mov sp, x25", 10
db "    b .back", 10
db 10
db "; pthread_create's start routine, x0 = the thread's Kron stack: what the", 10
db "; child of clone does in __thread_start -- pop the function and its argument,", 10
db "; leave the room a call has, call -- then, the function done, clear the id", 10
db "; word and wake whoever waits on it. The registers the system library", 10
db "; expects back are kept on the thread's own stack.", 10
db "__pt_entry:", 10
db "__mac_thread:", 10
db "    stp x29, x30, [sp, #-16]!", 10
db "    stp x27, x28, [sp, #-16]!", 10
db "    stp x25, x26, [sp, #-16]!", 10
db "    stp x23, x24, [sp, #-16]!", 10
db "    stp x21, x22, [sp, #-16]!", 10
db "    stp x19, x20, [sp, #-16]!", 10
db "    stp d8, d9, [sp, #-16]!", 10
db "    stp d10, d11, [sp, #-16]!", 10
db "    stp d12, d13, [sp, #-16]!", 10
db "    stp d14, d15, [sp, #-16]!", 10
db "    mov x19, x0", 10
db "    ldr x9, [x19]", 10
db "    ldr x1, [x19, #8]", 10
db "    add x28, x19, #16", 10
db "    sub x28, x28, #32", 10
db "    str x30, [x28, #-8]!", 10
db "    blr x9", 10
db "    ldr x30, [x28], #8", 10
db "    ldr x1, [x19, #16]", 10
db "    str wzr, [x1]", 10
db "    mov x0, #0x101", 10
db "    mov x2, #0", 10
db "    mov x16, #516", 10
db "    svc #0x80", 10
db "    ldp d14, d15, [sp], #16", 10
db "    ldp d12, d13, [sp], #16", 10
db "    ldp d10, d11, [sp], #16", 10
db "    ldp d8, d9, [sp], #16", 10
db "    ldp x19, x20, [sp], #16", 10
db "    ldp x21, x22, [sp], #16", 10
db "    ldp x23, x24, [sp], #16", 10
db "    ldp x25, x26, [sp], #16", 10
db "    ldp x27, x28, [sp], #16", 10
db "    ldp x29, x30, [sp], #16", 10
db "    mov x0, #0", 10
db "    ret", 10
db 10
db "; __ccall: an extern function called in the AAPCS64 convention. As on", 10
db "; x86-64: the arguments pushed in order (the last at [x8], r10), x9 (r11) =", 10
db "; the function's record, x0 (rax) = the shape of the call, x2 (rdx) = the", 10
db "; widths. Integers go in x0-x7, reals in d0-d7 (s for an f32), the rest on", 10
db "; the stack -- packed by width, and every variadic one there, as Apple's", 10
db "; convention has it. The C code runs on sp, moved under the Kron stack (x28) first.", 10
db "; Kron keeps x4 x5 (rsi rdi) and all of v6-v15 across a call; AAPCS64 keeps", 10
db "; none of them whole, so they are saved here.", 10
db "__ccall:", 10
db "    ldr x16, [x9]", 10
db "    cbnz x16, .cc_go", 10
db "    stp x0, x2, [x28, #-16]!", 10
db "    stp x8, x9, [x28, #-16]!", 10
db "    ; the frame x86-64 would have, so that a failure's trace finds the call", 10
db "    str x30, [x28, #-8]!", 10
db "    str x29, [x28, #-8]!", 10
db "    mov x29, x28", 10
db "    mov x1, x9", 10
db "    str x30, [x28, #-8]!", 10
db "    bl __ext_resolve", 10
db "    ldr x30, [x28], #8", 10
db "    mov x16, x0", 10
db "    ldr x29, [x28], #8", 10
db "    ldr x30, [x28], #8", 10
db "    ldp x8, x9, [x28], #16", 10
db "    ldp x0, x2, [x28], #16", 10
db "    cbz x16, .cc_none", 10
db "    str x16, [x9]", 10
db ".cc_go:", 10
db "    sub x24, x28, #512", 10
db "    and x24, x24, #0xfffffffffffffff0", 10
db "    mov x25, sp", 10
db "    mov sp, x24", 10
db "    stp x4, x5, [x24, #128]", 10
db "    stp x29, x30, [x24, #144]", 10
db "    str q6, [x24, #176]", 10
db "    str q7, [x24, #192]", 10
db "    str q8, [x24, #208]", 10
db "    str q9, [x24, #224]", 10
db "    str q10, [x24, #240]", 10
db "    str q11, [x24, #256]", 10
db "    str q12, [x24, #272]", 10
db "    str q13, [x24, #288]", 10
db "    str q14, [x24, #304]", 10
db "    str q15, [x24, #320]", 10
db "    mov x26, x0", 10
db "    mov x27, x9", 10
db "    and x11, x26, #255", 10
db "    lsr x3, x26, #48", 10
db "    and x3, x3, #255", 10
db "    cbnz x3, .cc_va", 10
db "    mov x3, #255", 10
db ".cc_va:", 10
db "    mov x10, #0", 10
db "    mov x12, #0", 10
db "    mov x13, #0", 10
db "    mov x14, #0", 10
db ".cc_arg:", 10
db "    cmp x10, x11", 10
db "    b.hs .cc_load", 10
db "    sub x15, x11, x10", 10
db "    sub x15, x15, #1", 10
db "    ldr x15, [x8, x15, lsl #3]", 10
db "    add x16, x10, #8", 10
db "    lsr x16, x26, x16", 10
db "    and x16, x16, #1", 10
db "    cbz x16, .cc_int", 10
db "    add x16, x10, #32", 10
db "    lsr x16, x26, x16", 10
db "    and x16, x16, #1", 10
db "    cbz x16, .cc_dbl", 10
db "    fmov d16, x15", 10
db "    fcvt s16, d16", 10
db "    fmov w15, s16", 10
db ".cc_dbl:", 10
db "    cmp x10, x3", 10
db "    b.hs .cc_vspill", 10
db "    cmp x13, #8", 10
db "    b.hs .cc_spill", 10
db "    add x16, x24, #400", 10
db "    str x15, [x16, x13, lsl #3]", 10
db "    add x13, x13, #1", 10
db "    b .cc_next", 10
db ".cc_int:", 10
db "    cmp x10, x3", 10
db "    b.hs .cc_vspill", 10
db "    cmp x12, #8", 10
db "    b.hs .cc_spill", 10
db "    add x16, x24, #336", 10
db "    str x15, [x16, x12, lsl #3]", 10
db "    add x12, x12, #1", 10
db "    b .cc_next", 10
db ".cc_spill:", 10
db "    lsl x16, x10, #1", 10
db "    lsr x16, x2, x16", 10
db "    and x16, x16, #3", 10
db "    cbz x16, .cc_vspill", 10
db "    cmp x16, #1", 10
db "    b.eq .cc_s4", 10
db "    cmp x16, #2", 10
db "    b.eq .cc_s2", 10
db "    strb w15, [x24, x14]", 10
db "    add x14, x14, #1", 10
db "    b .cc_next", 10
db ".cc_s2:", 10
db "    add x14, x14, #1", 10
db "    and x14, x14, #0xfffffffffffffffe", 10
db "    strh w15, [x24, x14]", 10
db "    add x14, x14, #2", 10
db "    b .cc_next", 10
db ".cc_s4:", 10
db "    add x14, x14, #3", 10
db "    and x14, x14, #0xfffffffffffffffc", 10
db "    str w15, [x24, x14]", 10
db "    add x14, x14, #4", 10
db "    b .cc_next", 10
db ".cc_vspill:", 10
db "    add x14, x14, #7", 10
db "    and x14, x14, #0xfffffffffffffff8", 10
db "    str x15, [x24, x14]", 10
db "    add x14, x14, #8", 10
db ".cc_next:", 10
db "    add x10, x10, #1", 10
db "    b .cc_arg", 10
db ".cc_load:", 10
db "    add x16, x24, #336", 10
db "    ldp x0, x1, [x16]", 10
db "    ldp x2, x3, [x16, #16]", 10
db "    ldp x4, x5, [x16, #32]", 10
db "    ldp x6, x7, [x16, #48]", 10
db "    add x16, x24, #400", 10
db "    ldp d0, d1, [x16]", 10
db "    ldp d2, d3, [x16, #16]", 10
db "    ldp d4, d5, [x16, #32]", 10
db "    ldp d6, d7, [x16, #48]", 10
db "    ldr x16, [x27]", 10
db "    blr x16", 10
db "    lsr x9, x26, #24", 10
db "    and x9, x9, #255", 10
db "    cmp x9, #1", 10
db "    b.ne .cc_r2", 10
db "    sxtw x0, w0", 10
db "    b .cc_done", 10
db ".cc_r2:", 10
db "    cmp x9, #2", 10
db "    b.ne .cc_r3", 10
db "    mov w0, w0", 10
db "    b .cc_done", 10
db ".cc_r3:", 10
db "    cmp x9, #3", 10
db "    b.ne .cc_r4", 10
db "    and x0, x0, #255", 10
db "    b .cc_done", 10
db ".cc_r4:", 10
db "    cmp x9, #4", 10
db "    b.ne .cc_r5", 10
db "    and x0, x0, #65535", 10
db "    b .cc_done", 10
db ".cc_r5:", 10
db "    cmp x9, #5", 10
db "    b.ne .cc_r6", 10
db "    sxth x0, w0", 10
db "    b .cc_done", 10
db ".cc_r6:", 10
db "    cmp x9, #6", 10
db "    b.ne .cc_r9", 10
db "    sxtb x0, w0", 10
db "    b .cc_done", 10
db ".cc_r9:", 10
db "    cmp x9, #9", 10
db "    b.ne .cc_done", 10
db "    fcvt d0, s0", 10
db ".cc_done:", 10
db "    ldr q6, [x24, #176]", 10
db "    ldr q7, [x24, #192]", 10
db "    ldr q8, [x24, #208]", 10
db "    ldr q9, [x24, #224]", 10
db "    ldr q10, [x24, #240]", 10
db "    ldr q11, [x24, #256]", 10
db "    ldr q12, [x24, #272]", 10
db "    ldr q13, [x24, #288]", 10
db "    ldr q14, [x24, #304]", 10
db "    ldr q15, [x24, #320]", 10
db "    ldp x4, x5, [x24, #128]", 10
db "    ldp x29, x30, [x24, #144]", 10
db "    mov sp, x25", 10
db "    ret", 10
db ".cc_none:", 10
db "    mov x0, #0", 10
db "    fmov d0, xzr", 10
db "    ret", 10
db 10
db "section .data", 10
db "align 8", 10
db "__mac_got_create: dq 0", 10
db "__mac_got_detach: dq 0", 10
db "__mac_envp: dq 0", 10
db "__mac_envi: dq 0", 10
db "__mac_envo: dq 0", 10
db '__mac_envname: db "/proc/self/environ", 0', 10
db '__mac_dot: db ".", 0', 10
db "align 2", 10
db "; Linux x86-64 number -> macOS number; 0 none, 1000 a case of its own", 10
db "__msys_tab:", 10
db "    dw 1000, 4, 1000, 1000, 1000, 1000, 1000, 230, 199, 1000, 0, 73, 0, 1000, 1000, 0", 10
db "    dw 54, 153, 154, 0, 0, 33, 1000, 93, 1000, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 41, 90, 0, 1000, 0, 0, 0, 20, 0, 1000, 1000, 1000, 1000, 1000, 0, 0", 10
db "    dw 134, 1000, 106, 32, 31, 0, 1000, 118, 1000, 1000, 1000, 59, 1, 7, 37, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 92, 0, 0, 0, 200, 201, 0, 1000", 10
db "    dw 12, 13, 128, 136, 137, 0, 0, 10, 0, 58, 15, 124, 0, 0, 0, 60", 10
db "    dw 1000, 194, 0, 0, 0, 0, 24, 0, 47, 0, 0, 25, 43, 0, 39, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 195, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 372, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 1000, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 1000, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 1000, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1000, 0", 10
db "    dw 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0", 10
db 0
section .text
