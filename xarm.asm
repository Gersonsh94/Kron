; ==============================================================================
; XARM - lowers the x86-64 text the code generator writes to ARM64 text
;
; kronc has one code generator. For Linux on ARM64 it generates the same
; program it generates for Linux on x86-64, and this pass rewrites each
; instruction into its ARM64 equivalent, which karm then assembles. Every
; feature of the language, the runtime included, reaches ARM64 the moment it
; works on x86-64.
;
; The x86-64 machine is kept exactly, so nothing above this pass changes:
;
;   registers   rax rcx rdx rbx rsp rbp rsi rdi r8 r9 r10 r11 r12-r15
;               x0  x1  x2  x19 x28 x29 x4  x5  x6 x7 x8  x9  x20-x23
;               xmmN is vN (dN for one double)
;   scratch     x16 x17 (inside one instruction), x10-x15 (the system call)
;   stack       x28 is rsp: push and pop are 8 bytes, as on x86-64, so every
;               frame offset the generator computed stays right. The ARM sp
;               is left alone.
;   calls       call f  ->  str x30, [x28, #-8]!   bl f   ldr x30, [x28], #8
;               The caller keeps its own return address in the slot the x86
;               call would have used, so [rbp+16] is still the first stack
;               argument and ret is a plain ret.
;   flags       cmp, test, add, sub and ucomisd set the ARM flags; the
;               condition of each jcc and setcc is mapped by what set them.
;   syscall     __sysx: Kron uses the Linux x86-64 numbers on every Linux;
;               the call maps them to the ARM64 ones and moves the arguments.
;
; xarm_set_os(rcx = 0 Linux, 1 macOS): which shim the program gets. macOS
; runs the same Linux program: its shim answers the Linux calls from XNU.
; xarm_translate(rcx = x86 text, rdx = length, r8 = output, r9 = capacity)
;   -> rax = length of the ARM64 text, or -1 on an error
; xarm_error_line()  -> rax = line of the x86 text that failed
; xarm_error_text()  -> rax = what was wrong (zero-terminated)
; xarm_error_insn()  -> rax = the instruction itself (zero-terminated)
; Windows x64 convention: rbx rsi rdi rbp r12-r15 are kept.
; ==============================================================================

bits 64
default rel

global xarm_translate
global xarm_error_line
global xarm_error_text
global xarm_error_insn
global xarm_set_os
global xarm_set_lib
; the reader of x86 text, shared with xwasm
global xa_read_line, xa_split, xa_parse_ops, xa_streq, xa_prefix, xa_skipb
global xa_native_skip, xa_skipping
global xa_parse_num, xa_find_reg, xa_fail
global xa_in, xa_in_end, xa_line_no, xa_err, xa_err_line, xa_err_msg
global xa_err_insn, xa_line, xa_mn, xa_rest, xa_nops, xa_opt, xa_ops

; operand record, 32 bytes
%define OP_KIND   0     ; 0 none, 1 reg, 2 xmm, 3 imm, 4 mem, 5 label
%define OP_REG    1     ; x86 register 0..15
%define OP_RSIZE  2     ; 1 2 4 8
%define OP_XMM    3     ; xmm number
%define OP_MSIZE  4     ; byte/word/dword/qword/oword prefix, 0 none
%define OP_SCALE  5
%define OP_BASE   6     ; 0xFF none
%define OP_INDEX  7     ; 0xFF none
%define OP_VAL    8     ; immediate, or displacement
%define OP_REL    16    ; label text of [rel L] / [L], 0 none
%define OP_TEXT   24    ; the operand text

%define K_REG   1
%define K_XMM   2
%define K_IMM   3
%define K_MEM   4
%define K_LABEL 5

; flag setters
%define F_NONE  0
%define F_SUB   1
%define F_LOGIC 2
%define F_ADD   3
%define F_FP    4

%macro XM 2
    lea  rcx, [rel xa_mn]
    lea  rdx, [rel %1]
    call xa_streq
    test eax, eax
    jnz  %2
%endmacro

%macro ARG 2
    mov  qword [rel xa_args + %1*8], %2
%endmacro

section .bss
    xa_os        resq 1         ; 0 Linux, 1 macOS
    xa_in        resq 1
    xa_in_end    resq 1
    xa_out       resq 1
    xa_out_end   resq 1
    xa_line_no   resq 1
    xa_err       resq 1
    xa_err_line  resq 1
    xa_err_msg   resq 1
    xa_err_insn  resb 160
    xa_line      resb 1024
    xa_mn        resb 32
    xa_rest      resq 1
    xa_nops      resq 1
    xa_opt       resb 768          ; three operand texts of 256 bytes
    xa_ops       resb 96           ; three operand records
    xa_args      resq 8
    xa_fk        resq 1            ; who set the flags
    xa_fpend     resq 1            ; register to tst before the next condition, +1
    xa_fpw       resq 1            ; that register is a w register
    xa_uniq      resq 1
    xa_skipping  resq 1            ; inside a routine the tail supplies natively
    xa_lib       resq 1            ; 1 for a library: __centry goes in the tail
    xa_mb        resq 1            ; addr: base register
    xa_mo        resq 1            ; addr: offset
    xa_numbuf    resb 32
    xa_cc        resq 1            ; the ARM condition chosen

section .data
    ; x86 register -> ARM register
    xa_rmap  db 0, 1, 2, 19, 28, 29, 4, 5, 6, 7, 8, 9, 20, 21, 22, 23

    ; register names: 5 bytes of name, index, size
    xa_regs:
    db "rax",0,0, 0, 8,  "rcx",0,0, 1, 8,  "rdx",0,0, 2, 8,  "rbx",0,0, 3, 8
    db "rsp",0,0, 4, 8,  "rbp",0,0, 5, 8,  "rsi",0,0, 6, 8,  "rdi",0,0, 7, 8
    db "r8",0,0,0, 8, 8,  "r9",0,0,0, 9, 8,  "r10",0,0, 10, 8, "r11",0,0, 11, 8
    db "r12",0,0, 12, 8, "r13",0,0, 13, 8, "r14",0,0, 14, 8, "r15",0,0, 15, 8
    db "eax",0,0, 0, 4,  "ecx",0,0, 1, 4,  "edx",0,0, 2, 4,  "ebx",0,0, 3, 4
    db "esp",0,0, 4, 4,  "ebp",0,0, 5, 4,  "esi",0,0, 6, 4,  "edi",0,0, 7, 4
    db "r8d",0,0, 8, 4,  "r9d",0,0, 9, 4,  "r10d",0, 10, 4, "r11d",0, 11, 4
    db "r12d",0, 12, 4, "r13d",0, 13, 4, "r14d",0, 14, 4, "r15d",0, 15, 4
    db "ax",0,0,0, 0, 2,  "cx",0,0,0, 1, 2,  "dx",0,0,0, 2, 2,  "bx",0,0,0, 3, 2
    db "si",0,0,0, 6, 2,  "di",0,0,0, 7, 2
    db "al",0,0,0, 0, 1,  "cl",0,0,0, 1, 1,  "dl",0,0,0, 2, 1,  "bl",0,0,0, 3, 1
    db "sil",0,0, 6, 1,  "dil",0,0, 7, 1,  "r8b",0,0, 8, 1,  "r9b",0,0, 9, 1
    db "r10b",0, 10, 1, "r11b",0, 11, 1
    db 0

    ; conditions: x86 name (4 bytes) and ARM name (4 bytes)
    xa_cc_sub:
    db "e",0,0,0, "eq",0,0,  "z",0,0,0, "eq",0,0,  "ne",0,0, "ne",0,0,  "nz",0,0, "ne",0,0
    db "l",0,0,0, "lt",0,0,  "nge",0, "lt",0,0,    "le",0,0, "le",0,0,  "ng",0,0, "le",0,0
    db "g",0,0,0, "gt",0,0,  "nle",0, "gt",0,0,    "ge",0,0, "ge",0,0,  "nl",0,0, "ge",0,0
    db "b",0,0,0, "lo",0,0,  "c",0,0,0, "lo",0,0,  "nae",0, "lo",0,0
    db "be",0,0, "ls",0,0,   "na",0,0, "ls",0,0,   "a",0,0,0, "hi",0,0,  "nbe",0, "hi",0,0
    db "ae",0,0, "hs",0,0,   "nb",0,0, "hs",0,0,   "nc",0,0, "hs",0,0
    db "s",0,0,0, "mi",0,0,  "ns",0,0, "pl",0,0
    db 0
    xa_cc_logic:
    db "e",0,0,0, "eq",0,0,  "z",0,0,0, "eq",0,0,  "ne",0,0, "ne",0,0,  "nz",0,0, "ne",0,0
    db "s",0,0,0, "mi",0,0,  "ns",0,0, "pl",0,0
    db "l",0,0,0, "lt",0,0,  "ge",0,0, "ge",0,0,   "le",0,0, "le",0,0,  "g",0,0,0, "gt",0,0
    db 0
    xa_cc_add:
    db "e",0,0,0, "eq",0,0,  "z",0,0,0, "eq",0,0,  "ne",0,0, "ne",0,0,  "nz",0,0, "ne",0,0
    db "s",0,0,0, "mi",0,0,  "ns",0,0, "pl",0,0
    db 0
    ; after ucomisd: an unordered result (a NaN) counts as below, as on x86
    xa_cc_fp:
    db "e",0,0,0, "eq",0,0,  "z",0,0,0, "eq",0,0,  "ne",0,0, "ne",0,0,  "nz",0,0, "ne",0,0
    db "a",0,0,0, "gt",0,0,  "nbe",0, "gt",0,0,    "ae",0,0, "ge",0,0,  "nb",0,0, "ge",0,0
    db "nc",0,0, "ge",0,0,   "b",0,0,0, "lt",0,0,  "c",0,0,0, "lt",0,0
    db "be",0,0, "le",0,0,   "na",0,0, "le",0,0
    db 0

    ; mnemonics
    xm_default  db "default", 0
    xm_bits     db "bits", 0
    xm_extern   db "extern", 0
    xm_section  db "section", 0
    xm_global   db "global", 0
    xm_db       db "db", 0
    xm_dw       db "dw", 0
    xm_dd       db "dd", 0
    xm_dq       db "dq", 0
    xm_resb     db "resb", 0
    xm_resw     db "resw", 0
    xm_resd     db "resd", 0
    xm_resq     db "resq", 0
    xm_times    db "times", 0
    xm_align    db "align", 0
    xm_equ      db "equ", 0
    xm_mov      db "mov", 0
    xm_movzx    db "movzx", 0
    xm_lea      db "lea", 0
    xm_push     db "push", 0
    xm_pop      db "pop", 0
    xm_add      db "add", 0
    xm_sub      db "sub", 0
    xm_and      db "and", 0
    xm_or       db "or", 0
    xm_xor      db "xor", 0
    xm_inc      db "inc", 0
    xm_dec      db "dec", 0
    xm_neg      db "neg", 0
    xm_not      db "not", 0
    xm_cmp      db "cmp", 0
    xm_test     db "test", 0
    xm_imul     db "imul", 0
    xm_cqo      db "cqo", 0
    xm_idiv     db "idiv", 0
    xm_div      db "div", 0
    xm_shl      db "shl", 0
    xm_sal      db "sal", 0
    xm_shr      db "shr", 0
    xm_sar      db "sar", 0
    xm_rol      db "rol", 0
    xm_ror      db "ror", 0
    xm_xchg     db "xchg", 0
    xm_jmp      db "jmp", 0
    xm_call     db "call", 0
    xm_ret      db "ret", 0
    xm_syscall  db "syscall", 0
    xm_movsd    db "movsd", 0
    xm_movss    db "movss", 0
    xm_cvtss2sd db "cvtss2sd", 0
    xm_cvtsd2ss db "cvtsd2ss", 0
    xm_movq     db "movq", 0
    xm_movups   db "movups", 0
    xm_movupd   db "movupd", 0
    xm_movaps   db "movaps", 0
    xm_movapd   db "movapd", 0
    xm_addsd    db "addsd", 0
    xm_subsd    db "subsd", 0
    xm_mulsd    db "mulsd", 0
    xm_divsd    db "divsd", 0
    xm_sqrtsd   db "sqrtsd", 0
    xm_addpd    db "addpd", 0
    xm_subpd    db "subpd", 0
    xm_mulpd    db "mulpd", 0
    xm_divpd    db "divpd", 0
    xm_addps    db "addps", 0
    xm_subps    db "subps", 0
    xm_mulps    db "mulps", 0
    xm_divps    db "divps", 0
    xm_xorps    db "xorps", 0
    xm_xorpd    db "xorpd", 0
    xm_andpd    db "andpd", 0
    xm_andps    db "andps", 0
    xm_orpd     db "orpd", 0
    xm_ucomisd  db "ucomisd", 0
    xm_comisd   db "comisd", 0
    xm_cvtsi2sd db "cvtsi2sd", 0
    xm_cvttsd2si db "cvttsd2si", 0
    xm_cvtsd2si db "cvtsd2si", 0
    xm_prefetch db "prefetcht0", 0
    xm_clflush  db "clflush", 0
    xm_nop      db "nop", 0
    xm_pause    db "pause", 0
    xm_mfence   db "mfence", 0
    xm_start    db "_start", 0
    xm_rel      db "rel ", 0
    xm_byte     db "byte", 0
    xm_word     db "word", 0
    xm_dword    db "dword", 0
    xm_qword    db "qword", 0
    xm_oword    db "oword", 0

    ; error texts
    e_form     db "no ARM64 form for this instruction", 0
    e_operand  db "operand ARM64 cannot take here", 0
    e_flags    db "condition with nothing setting the flags before it", 0
    e_cond     db "condition these flags cannot answer on ARM64", 0
    e_full     db "output buffer full", 0
    e_label    db "a label and a register in one memory operand", 0
    e_long     db "line longer than 1000 characters", 0

    ; output pieces
    s_ind      db "    ", 0
    xa_nl       db 10, 0
    xa_colon_nl db ":", 10, 0
    s_start    db "    mov x28, sp", 10, 0

    ; formats: %x x-register, %w w-register, %d signed, %h hex, %s text,
    ; %D d-register, %Q q-register, %V v-register (arguments in xa_args)
    f_mov_imm   db "    mov %x, #%d", 10, 0
    f_mov_wimm  db "    mov %w, #%d", 10, 0
    f_mov_rr    db "    mov %x, %x", 10, 0
    f_mov_ww    db "    mov %w, %w", 10, 0
    f_adrl      db "    adrl x16, %s", 10, 0
    f_adrl_r    db "    adrl %x, %s", 10, 0
    f_lsl16     db "    lsl x16, %x, #%d", 10, 0
    f_add16     db "    add x16, %x, %x, lsl #%d", 10, 0
    f_addi      db "    add%s %x, %x, #%d", 10, 0
    f_subi      db "    sub%s %x, %x, #%d", 10, 0
    f_addr      db "    add%s %x, %x, %x", 10, 0
    f_addwi     db "    add%s %w, %w, #%d", 10, 0
    f_subwi     db "    sub%s %w, %w, #%d", 10, 0
    f_addwr     db "    add%s %w, %w, %w", 10, 0
    f_rrr       db "    %s %x, %x, %x", 10, 0
    f_www       db "    %s %w, %w, %w", 10, 0
    f_rri       db "    %s %x, %x, #%h", 10, 0
    f_wwi       db "    %s %w, %w, #%h", 10, 0
    f_and_keep  db "    and x17, %x, #%h", 10, 0
    f_and_clear db "    and %x, %x, #%h", 10, 0
    f_orr17     db "    orr %x, %x, x17", 10, 0
    f_push      db "    str %x, [x28, #-8]!", 10, 0
    f_pop       db "    ldr %x, [x28], #8", 10, 0
    f_pop_sp    db "    ldr x28, [x28]", 10, 0
    f_cmp_i     db "    cmp %s, #%d", 10, 0
    f_cmp_r     db "    cmp %s, %s", 10, 0
    f_tst_i     db "    tst %s, #%h", 10, 0
    f_tst_r     db "    tst %s, %s", 10, 0
    f_tst_x     db "    tst %x, %x", 10, 0
    f_tst_w     db "    tst %w, %w", 10, 0
    f_mul       db "    mul %x, %x, %x", 10, 0
    f_cqo       db "    asr x2, x0, #63", 10, 0
    f_div       db "    %s x16, x0, %x", 10, 0
    f_msub      db "    msub x2, x16, %x, x0", 10, 0
    f_mov0_16   db "    mov x0, x16", 10, 0
    f_shi       db "    %s %x, %x, #%d", 10, 0
    f_shr_cl    db "    %s %x, %x, x1", 10, 0
    f_rol_cl    db "    sub x16, xzr, x1", 10, "    ror %x, %x, x16", 10, 0
    f_mvn       db "    mvn %x, %x", 10, 0
    f_neg       db "    subs %x, xzr, %x", 10, 0
    f_incdec    db "    %s %s, %s, #1", 10, 0
    f_xa_lbl    db ".xa%d:", 10, 0
    f_xa_body_w db "    ldaxr w15, [%x]", 10, "    stlxr w14, %w, [%x]", 10, "    cbnz w14, .xa%d", 10, "    mov %w, w15", 10, 0
    f_xa_body_x db "    ldaxr x15, [%x]", 10, "    stlxr w14, %x, [%x]", 10, "    cbnz w14, .xa%d", 10, "    mov %x, x15", 10, 0
    f_b         db "    b %s", 10, 0
    f_br        db "    br %x", 10, 0
    f_bl        db "    str x30, [x28, #-8]!", 10, "    bl %s", 10, "    ldr x30, [x28], #8", 10, 0
    f_blr       db "    str x30, [x28, #-8]!", 10, "    blr %x", 10, "    ldr x30, [x28], #8", 10, 0
    f_ret       db "    ret", 10, 0
    f_sys       db "    mov x17, x30", 10, "    bl __sysx", 10, "    mov x30, x17", 10, 0
    f_bcond     db "    b.%s %s", 10, 0
    f_cset      db "    cset %x, %s", 10, 0
    f_fmov_dd   db "    fmov %D, %D", 10, 0
    f_cvt_s2d   db "    fcvt %D, s%d", 10, 0
    f_cvt_d2s   db "    fcvt s%d, %D", 10, 0
    f_fmov_dx   db "    fmov %D, %x", 10, 0
    f_fmov_xd   db "    fmov %x, %D", 10, 0
    f_vmov      db "    mov %V.16b, %V.16b", 10, 0
    f_f3        db "    %s %D, %D, %D", 10, 0
    f_f2        db "    %s %D, %D", 10, 0
    f_v3        db "    %s %V.2d, %V.2d, %V.2d", 10, 0
    f_v3s       db "    %s %V.4s, %V.4s, %V.4s", 10, 0
    f_vb3       db "    %s %V.16b, %V.16b, %V.16b", 10, 0
    f_fcmp      db "    fcmp %D, %D", 10, 0
    f_scvtf     db "    scvtf %D, %s", 10, 0
    f_fcvt      db "    %s %s, %D", 10, 0
    f_prfm      db "    prfm pldl1keep, [%x]", 10, 0
    f_dc        db "    dc civac, %x", 10, 0
    f_nop       db "    nop", 10, 0
    f_dmb       db "    dmb ish", 10, 0
    f_ldst      db "    %s%s %s, [%x]", 10, 0
    f_ldst_o    db "    %s%s %s, [%x, #%d]", 10, 0
    f_add_tmp   db "    add %x, %x, %x", 10, 0
    f_movw16    db "    mov w17, #%d", 10, 0

    o_ldr   db "ldr", 0
    o_str   db "str", 0
    o_ldur  db "ldur", 0
    o_stur  db "stur", 0
    o_b     db "b", 0
    o_h     db "h", 0
    o_none  db 0
    o_s     db "s", 0
    o_adds  db "adds", 0
    o_subs  db "subs", 0
    o_add   db "add", 0
    o_sub   db "sub", 0
    o_ands  db "ands", 0
    o_and   db "and", 0
    o_orr   db "orr", 0
    o_eor   db "eor", 0
    o_lsl   db "lsl", 0
    o_lsr   db "lsr", 0
    o_asr   db "asr", 0
    o_ror   db "ror", 0
    o_sdiv  db "sdiv", 0
    o_udiv  db "udiv", 0
    o_fadd  db "fadd", 0
    o_fsub  db "fsub", 0
    o_fmul  db "fmul", 0
    o_fdiv  db "fdiv", 0
    o_fsqrt db "fsqrt", 0
    o_fcvtzs db "fcvtzs", 0
    o_fcvtns db "fcvtns", 0
    o_x16   db "x16", 0
    o_w16   db "w16", 0
    o_x17   db "x17", 0
    o_w17   db "w17", 0
    o_xzr   db "xzr", 0
    o_wzr   db "wzr", 0
    xm_ns_sec   db "section", 0
    xm_ns_ccall db "__ccall:", 0
    xm_ns_ptent db "__pt_entry:", 0
    xm_ns_centry db "__centry:", 0
    o_d16   db "d16", 0

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

; xarm_set_lib(rcx = 1 for a library, --lib)
xarm_set_lib:
    mov  [rel xa_lib], rcx
    ret

xarm_translate:
    push rbx
    push rsi
    push rdi
    push rbp
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 8
    mov  [rel xa_in], rcx
    add  rcx, rdx
    mov  [rel xa_in_end], rcx
    mov  [rel xa_out], r8
    mov  rbp, r8                     ; start of the output
    add  r8, r9
    sub  r8, 65536                   ; room for the last line and the tail
    mov  [rel xa_out_end], r8
    xor  eax, eax
    mov  [rel xa_line_no], rax
    mov  [rel xa_err], rax
    mov  [rel xa_err_line], rax
    mov  [rel xa_fk], rax
    mov  [rel xa_fpend], rax
    mov  [rel xa_uniq], rax
    mov  [rel xa_skipping], rax
    lea  rax, [rel e_form]
    mov  [rel xa_err_msg], rax
    mov  byte [rel xa_err_insn], 0
    jmp  .line
.line:
    cmp  qword [rel xa_err], 0
    jne  .failed
    mov  rax, [rel xa_out]
    cmp  rax, [rel xa_out_end]
    jae  .full
    call xa_read_line
    test eax, eax
    jz   .tail
    call xa_native_skip
    test eax, eax
    jnz  .line
    call xa_do_line
    jmp  .line
.tail:
    ; the system call shim and its table
    lea  rsi, [rel xa_tail]
    cmp  qword [rel xa_os], 1
    jne  .tail_put
    lea  rsi, [rel xa_tail_mac]
.tail_put:
    call xa_put
    ; a library: where C comes in
    cmp  qword [rel xa_lib], 0
    je   .tail_done
    lea  rsi, [rel xa_tail_lib]
    cmp  qword [rel xa_os], 1
    jne  .tail_lib
    lea  rsi, [rel xa_tail_lib_mac]
.tail_lib:
    call xa_put
.tail_done:
    mov  rax, [rel xa_out]
    sub  rax, rbp
    jmp  .out
.full:
    lea  rax, [rel e_full]
    mov  [rel xa_err_msg], rax
    mov  rax, [rel xa_line_no]
    mov  [rel xa_err_line], rax
    jmp  .failed
.failed:
    mov  rax, -1
    jmp  .out
.out:
    add  rsp, 8
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; INPUT
; ==============================================================================

; xa_read_line() -> eax = 1 and xa_line holds the next line, its comment
; removed and its blanks trimmed; eax = 0 at the end of the text
xa_read_line:
    push rsi
    push rdi
    mov  rsi, [rel xa_in]
    cmp  rsi, [rel xa_in_end]
    jae  .eof
    inc  qword [rel xa_line_no]
    lea  rdi, [rel xa_line]
    xor  ecx, ecx                    ; length
    xor  edx, edx                    ; open quote
    xor  r8d, r8d                    ; 1 once a comment started
    xor  r9d, r9d                    ; 1 when the line did not fit
    jmp  .ch
.ch:
    cmp  rsi, [rel xa_in_end]
    jae  .eol
    mov  al, [rsi]
    inc  rsi
    cmp  al, 10
    je   .eol
    cmp  al, 13
    je   .ch
    test r8d, r8d
    jnz  .ch
    test dl, dl
    jnz  .inq
    cmp  al, ';'
    je   .comment
    cmp  al, 0x27
    je   .q
    cmp  al, 0x22
    je   .q
    cmp  al, 9
    jne  .put
    mov  al, ' '
    jmp  .put
.q:
    mov  dl, al
    jmp  .put
.inq:
    cmp  al, dl
    jne  .put
    xor  edx, edx
    jmp  .put
.comment:
    mov  r8d, 1
    jmp  .ch
.long:
    ; a line past the buffer is an error, never quietly cut short
    mov  r9d, 1
    jmp  .ch
.put:
    cmp  ecx, 1000
    jae  .long
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .ch
.eol:
    mov  [rel xa_in], rsi
    ; trim the end
    jmp  .trim
.trim:
    test ecx, ecx
    jz   .term
    cmp  byte [rdi + rcx - 1], ' '
    jne  .term
    dec  ecx
    jmp  .trim
.term:
    mov  byte [rdi + rcx], 0
    test r9d, r9d
    jz   .fits
    lea  rcx, [rel e_long]
    call xa_fail
    jmp  .fits
.fits:
    mov  eax, 1
    pop  rdi
    pop  rsi
    ret
.eof:
    xor  eax, eax
    pop  rdi
    pop  rsi
    ret

; xa_native_skip() -> eax = 0 when the line just read is translated, 1 when it
; is dropped, 2 when it is the label that starts a dropped routine: it belongs
; to a routine of the preamble that only makes sense on x86-64 and that the
; tail supplies in ARM64 code instead -- __ccall, which speaks the system's C
; convention, and __pt_entry, where a pthread starts. The routine ends at the
; next label that is not local, or at a section line.
xa_native_skip:
    push rsi
    lea  rsi, [rel xa_line]
    call xa_skipb
    mov  rcx, rsi
    lea  rdx, [rel xm_ns_sec]
    call xa_prefix
    test eax, eax
    jnz  .ns_end
    cmp  byte [rsi], '.'
    je   .ns_keep
    ; a label: the first word ends in ':'
    mov  rcx, rsi
.ns_w:
    mov  al, [rcx]
    test al, al
    jz   .ns_keep
    cmp  al, ' '
    je   .ns_keep
    cmp  al, ':'
    je   .ns_label
    inc  rcx
    jmp  .ns_w
.ns_label:
    mov  rcx, rsi
    lea  rdx, [rel xm_ns_ccall]
    call xa_prefix
    test eax, eax
    jnz  .ns_begin
    mov  rcx, rsi
    lea  rdx, [rel xm_ns_ptent]
    call xa_prefix
    test eax, eax
    jnz  .ns_begin
    mov  rcx, rsi
    lea  rdx, [rel xm_ns_centry]
    call xa_prefix
    test eax, eax
    jnz  .ns_begin
.ns_end:
    mov  qword [rel xa_skipping], 0
    xor  eax, eax
    pop  rsi
    ret
.ns_begin:
    mov  qword [rel xa_skipping], 1
    mov  eax, 2
    pop  rsi
    ret
.ns_keep:
    mov  rax, [rel xa_skipping]
    pop  rsi
    ret

; xa_skipb(rsi) -> rsi past blanks
xa_skipb:
    cmp  byte [rsi], ' '
    jne  .o
    inc  rsi
    jmp  xa_skipb
.o:
    ret

; xa_streq(rcx, rdx) -> eax = 1 when the two strings are equal
xa_streq:
    push rsi
    push rdi
    mov  rsi, rcx
    mov  rdi, rdx
    jmp  .l
.l:
    mov  al, [rsi]
    cmp  al, [rdi]
    jne  .no
    test al, al
    jz   .yes
    inc  rsi
    inc  rdi
    jmp  .l
.yes:
    mov  eax, 1
    pop  rdi
    pop  rsi
    ret
.no:
    xor  eax, eax
    pop  rdi
    pop  rsi
    ret

; xa_prefix(rcx = text, rdx = prefix) -> eax = 1 when text starts with it
xa_prefix:
    push rsi
    push rdi
    mov  rsi, rcx
    mov  rdi, rdx
    jmp  .l
.l:
    mov  al, [rdi]
    test al, al
    jz   .yes
    cmp  al, [rsi]
    jne  .no
    inc  rsi
    inc  rdi
    jmp  .l
.yes:
    mov  eax, 1
    pop  rdi
    pop  rsi
    ret
.no:
    xor  eax, eax
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; OUTPUT
; ==============================================================================

; xa_put(rsi = zero-terminated text): appended to the output. Keeps all but rax.
xa_put:
    push rsi
    push rdi
    mov  rdi, [rel xa_out]
    jmp  .l
.l:
    mov  al, [rsi]
    test al, al
    jz   .d
    mov  [rdi], al
    inc  rsi
    inc  rdi
    jmp  .l
.d:
    mov  [rel xa_out], rdi
    pop  rdi
    pop  rsi
    ret

; xa_putc(al)
xa_putc:
    push rdi
    mov  rdi, [rel xa_out]
    mov  [rdi], al
    inc  rdi
    mov  [rel xa_out], rdi
    pop  rdi
    ret

; xa_put_dec(rax = signed value)
xa_put_dec:
    push rbx
    push rcx
    push rdx
    push rsi
    mov  rbx, rax
    test rbx, rbx
    jns  .pos
    mov  al, '-'
    call xa_putc
    neg  rbx
    jmp  .pos
.pos:
    ; digits backwards into xa_numbuf (unsigned: -2^63 negates to itself)
    lea  rsi, [rel xa_numbuf + 31]
    mov  byte [rsi], 0
    mov  rax, rbx
    mov  rcx, 10
    jmp  .dig
.dig:
    xor  edx, edx
    div  rcx
    add  dl, '0'
    dec  rsi
    mov  [rsi], dl
    test rax, rax
    jnz  .dig
    call xa_put
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; xa_put_hex(rax = value) as 0x...
xa_put_hex:
    push rbx
    push rcx
    push rsi
    mov  rbx, rax
    mov  al, '0'
    call xa_putc
    mov  al, 'x'
    call xa_putc
    lea  rsi, [rel xa_numbuf + 31]
    mov  byte [rsi], 0
    jmp  .dig
.dig:
    mov  rax, rbx
    and  eax, 15
    cmp  al, 10
    jb   .num
    add  al, 'a' - 10
    jmp  .st
.num:
    add  al, '0'
    jmp  .st
.st:
    dec  rsi
    mov  [rsi], al
    shr  rbx, 4
    test rbx, rbx
    jnz  .dig
    call xa_put
    pop  rsi
    pop  rcx
    pop  rbx
    ret

; xa_put_reg(al = class letter, rdx = number): x0..x30, xzr; w..; d q v
xa_put_reg:
    push rax
    push rdx
    cmp  rdx, 31
    jne  .num
    cmp  al, 'x'
    je   .zr
    cmp  al, 'w'
    je   .zr
    jmp  .num
.zr:
    call xa_putc
    mov  al, 'z'
    call xa_putc
    mov  al, 'r'
    call xa_putc
    pop  rdx
    pop  rax
    ret
.num:
    call xa_putc
    mov  rax, rdx
    call xa_put_dec
    pop  rdx
    pop  rax
    ret

; xa_fmt(rcx = format), the values in xa_args. Keeps all but rax.
xa_fmt:
    push rbx
    push rcx
    push rdx
    push rsi
    mov  rsi, rcx
    xor  ebx, ebx                    ; next argument
    jmp  .l
.l:
    mov  al, [rsi]
    test al, al
    jz   .d
    inc  rsi
    cmp  al, '%'
    je   .pc
    call xa_putc
    jmp  .l
.pc:
    mov  al, [rsi]
    inc  rsi
    lea  rcx, [rel xa_args]
    mov  rdx, [rcx + rbx*8]
    inc  ebx
    cmp  al, 'd'
    je   .dec
    cmp  al, 'h'
    je   .hex
    cmp  al, 's'
    je   .str
    cmp  al, 'D'
    je   .dreg
    cmp  al, 'Q'
    je   .qreg
    cmp  al, 'V'
    je   .vreg
    ; x or w
    call xa_put_reg
    jmp  .l
.dreg:
    mov  al, 'd'
    call xa_put_reg
    jmp  .l
.qreg:
    mov  al, 'q'
    call xa_put_reg
    jmp  .l
.vreg:
    mov  al, 'v'
    call xa_put_reg
    jmp  .l
.dec:
    mov  rax, rdx
    call xa_put_dec
    jmp  .l
.hex:
    mov  rax, rdx
    call xa_put_hex
    jmp  .l
.str:
    push rsi
    mov  rsi, rdx
    call xa_put
    pop  rsi
    jmp  .l
.d:
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; xa_fail(rcx = message): the first error stops the translation
xa_fail:
    push rsi
    push rdi
    cmp  qword [rel xa_err], 0
    jne  .o
    mov  qword [rel xa_err], 1
    mov  [rel xa_err_msg], rcx
    mov  rax, [rel xa_line_no]
    mov  [rel xa_err_line], rax
    lea  rsi, [rel xa_line]
    lea  rdi, [rel xa_err_insn]
    xor  ecx, ecx
    jmp  .cp
.cp:
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    test al, al
    jz   .o
    inc  ecx
    cmp  ecx, 150
    jb   .cp
    mov  byte [rdi + rcx], 0
    jmp  .o
.o:
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; ONE LINE
; ==============================================================================
xa_do_line:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    lea  rsi, [rel xa_line]
    call xa_skipb
    cmp  byte [rsi], 0
    je   .out
    ; the first word: a label when it ends in ':'
    mov  rbx, rsi
    jmp  .w
.w:
    mov  al, [rsi]
    test al, al
    jz   .word_end
    cmp  al, ' '
    je   .word_end
    cmp  al, ':'
    je   .label
    inc  rsi
    jmp  .w
.label:
    ; a label: written on its own line, the rest of the line follows
    mov  byte [rsi], 0
    push rsi
    mov  rsi, rbx
    call xa_put
    pop  rsi
    push rsi
    lea  rsi, [rel xa_colon_nl_s]
    call xa_put
    pop  rsi
    mov  qword [rel xa_fk], F_NONE
    mov  qword [rel xa_fpend], 0
    mov  rcx, rbx
    lea  rdx, [rel xm_start]
    call xa_streq
    test eax, eax
    jz   .after_label
    push rsi
    lea  rsi, [rel s_start]
    call xa_put
    pop  rsi
    jmp  .after_label
.after_label:
    inc  rsi
    call xa_skipb
    cmp  byte [rsi], 0
    je   .out
    ; shift the rest of the line to the start of xa_line and go again
    lea  rdi, [rel xa_line]
    jmp  .shift
.shift:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    test al, al
    jnz  .shift
    lea  rsi, [rel xa_line]
    mov  rbx, rsi
    jmp  .w
.word_end:
    ; the mnemonic, lowercased, into xa_mn
    mov  rcx, rsi
    sub  rcx, rbx
    cmp  rcx, 30
    jbe  .mn_len
    mov  rcx, 30
    jmp  .mn_len
.mn_len:
    lea  rdi, [rel xa_mn]
    xor  edx, edx
    jmp  .mn
.mn:
    cmp  rdx, rcx
    jae  .mn_d
    mov  al, [rbx + rdx]
    cmp  al, 'A'
    jb   .mn_st
    cmp  al, 'Z'
    ja   .mn_st
    add  al, 32
    jmp  .mn_st
.mn_st:
    mov  [rdi + rdx], al
    inc  rdx
    jmp  .mn
.mn_d:
    mov  byte [rdi + rdx], 0
    call xa_skipb
    mov  [rel xa_rest], rsi
    ; lines that are dropped
    XM xm_default, .out
    XM xm_bits, .out
    XM xm_extern, .out
    ; lines that pass unchanged
    XM xm_section, .section
    XM xm_global, .verbatim0
    XM xm_db, .verbatim
    XM xm_dw, .verbatim
    XM xm_dd, .verbatim
    XM xm_dq, .verbatim
    XM xm_resb, .verbatim
    XM xm_resw, .verbatim
    XM xm_resd, .verbatim
    XM xm_resq, .verbatim
    XM xm_times, .verbatim
    XM xm_align, .verbatim
    XM xm_equ, .verbatim
    ; an instruction
    call xa_split
    call xa_parse_ops
    cmp  qword [rel xa_err], 0
    jne  .out
    lea  r12, [rel xa_ops]
    lea  r13, [rel xa_ops + 32]
    lea  r14, [rel xa_ops + 64]
    call xa_insn
    jmp  .out
.section:
    mov  qword [rel xa_fk], F_NONE
    mov  qword [rel xa_fpend], 0
    jmp  .verbatim0
.verbatim0:
    lea  rsi, [rel xa_line]
    call xa_skipb
    call xa_put
    lea  rsi, [rel xa_nl]
    call xa_put
    jmp  .out
.verbatim:
    lea  rsi, [rel s_ind]
    call xa_put
    lea  rsi, [rel xa_line]
    call xa_skipb
    call xa_put
    lea  rsi, [rel xa_nl]
    call xa_put
    jmp  .out
.out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

section .data
    xa_colon_nl_s db ":", 10, 0
section .text

; xa_split(): xa_rest -> up to three operand texts, trimmed, in xa_opt
xa_split:
    push rbx
    push rsi
    push rdi
    lea  rdi, [rel xa_opt]
    mov  byte [rdi], 0
    mov  byte [rdi + 256], 0
    mov  byte [rdi + 512], 0
    mov  qword [rel xa_nops], 0
    mov  rsi, [rel xa_rest]
    call xa_skipb
    cmp  byte [rsi], 0
    je   .out
    xor  ebx, ebx
    jmp  .start
.start:
    cmp  ebx, 3
    jae  .too_many
    mov  rdi, rbx
    shl  rdi, 8
    lea  rax, [rel xa_opt]
    add  rdi, rax
    call xa_skipb
    xor  ecx, ecx
    xor  edx, edx                    ; quote
    xor  r8d, r8d                    ; brackets
    jmp  .ch
.ch:
    mov  al, [rsi]
    test al, al
    jz   .last
    test dl, dl
    jnz  .inq
    cmp  al, 0x27
    je   .q
    cmp  al, 0x22
    je   .q
    cmp  al, '['
    je   .open
    cmp  al, ']'
    je   .close
    cmp  al, ','
    jne  .put
    test r8d, r8d
    jnz  .put
    call .fin
    inc  rsi
    inc  ebx
    jmp  .start
.q:
    mov  dl, al
    jmp  .put
.inq:
    cmp  al, dl
    jne  .put
    xor  edx, edx
    jmp  .put
.open:
    inc  r8d
    jmp  .put
.close:
    dec  r8d
    jmp  .put
.put:
    cmp  ecx, 250
    jae  .skip
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .skip
.skip:
    inc  rsi
    jmp  .ch
.last:
    call .fin
    inc  ebx
    mov  [rel xa_nops], rbx
    jmp  .out
.too_many:
    lea  rcx, [rel e_form]
    call xa_fail
    jmp  .out
.out:
    pop  rdi
    pop  rsi
    pop  rbx
    ret
.fin:
    test ecx, ecx
    jz   .fin_t
    cmp  byte [rdi + rcx - 1], ' '
    jne  .fin_t
    dec  ecx
    jmp  .fin
.fin_t:
    mov  byte [rdi + rcx], 0
    ret

; ==============================================================================
; OPERANDS
; ==============================================================================

; xa_parse_ops(): every operand text into its record
xa_parse_ops:
    push rbx
    push rsi
    push rdi
    lea  rdi, [rel xa_ops]
    xor  eax, eax
    mov  ecx, 12
    jmp  .clr
.clr:
    mov  [rdi + rcx*8 - 8], rax
    dec  ecx
    jnz  .clr
    xor  ebx, ebx
    jmp  .one
.one:
    cmp  rbx, [rel xa_nops]
    jae  .out
    mov  rsi, rbx
    shl  rsi, 8
    lea  rax, [rel xa_opt]
    add  rsi, rax
    mov  rdi, rbx
    shl  rdi, 5
    lea  rax, [rel xa_ops]
    add  rdi, rax
    call xa_parse_op
    inc  ebx
    jmp  .one
.out:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xa_parse_op(rsi = text, rdi = record)
xa_parse_op:
    push rbx
    push r12
    mov  [rdi + OP_TEXT], rsi
    mov  byte [rdi + OP_BASE], 0xFF
    mov  byte [rdi + OP_INDEX], 0xFF
    mov  byte [rdi + OP_SCALE], 1
    ; a size prefix
    mov  rcx, rsi
    lea  rdx, [rel xm_qword]
    mov  bl, 8
    call .sizeword
    test eax, eax
    jnz  .sized
    lea  rdx, [rel xm_dword]
    mov  bl, 4
    call .sizeword
    test eax, eax
    jnz  .sized
    lea  rdx, [rel xm_oword]
    mov  bl, 16
    call .sizeword
    test eax, eax
    jnz  .sized
    lea  rdx, [rel xm_word]
    mov  bl, 2
    call .sizeword
    test eax, eax
    jnz  .sized
    lea  rdx, [rel xm_byte]
    mov  bl, 1
    call .sizeword
    test eax, eax
    jnz  .sized
    jmp  .body
.sized:
    mov  [rdi + OP_MSIZE], bl
    mov  rsi, rax
    call xa_skipb
    jmp  .body
.body:
    cmp  byte [rsi], '['
    je   .mem
    ; a register
    mov  rcx, rsi
    call xa_find_reg
    cmp  eax, -1
    je   .not_reg
    mov  byte [rdi + OP_KIND], K_REG
    mov  [rdi + OP_REG], al
    mov  [rdi + OP_RSIZE], dl
    jmp  .out
.not_reg:
    ; xmmN
    cmp  byte [rsi], 'x'
    jne  .not_xmm
    cmp  byte [rsi+1], 'm'
    jne  .not_xmm
    cmp  byte [rsi+2], 'm'
    jne  .not_xmm
    lea  rcx, [rsi + 3]
    call xa_parse_num
    test edx, edx
    jz   .not_xmm
    cmp  rax, 15
    ja   .not_xmm
    mov  byte [rdi + OP_KIND], K_XMM
    mov  [rdi + OP_XMM], al
    jmp  .out
.not_xmm:
    mov  rcx, rsi
    call xa_parse_num
    test edx, edx
    jz   .label
    mov  byte [rdi + OP_KIND], K_IMM
    mov  [rdi + OP_VAL], rax
    jmp  .out
.label:
    mov  byte [rdi + OP_KIND], K_LABEL
    mov  [rdi + OP_TEXT], rsi
    jmp  .out
.mem:
    mov  byte [rdi + OP_KIND], K_MEM
    inc  rsi
    call xa_skipb
    ; cut the closing bracket
    mov  rcx, rsi
    jmp  .find_close
.find_close:
    mov  al, [rcx]
    test al, al
    jz   .closed
    cmp  al, ']'
    je   .cut
    inc  rcx
    jmp  .find_close
.cut:
    mov  byte [rcx], 0
    jmp  .closed
.closed:
    ; trim the end
    jmp  .trim_m
.trim_m:
    cmp  rcx, rsi
    jbe  .trimmed
    cmp  byte [rcx - 1], ' '
    jne  .trimmed
    dec  rcx
    mov  byte [rcx], 0
    jmp  .trim_m
.trimmed:
    mov  rcx, rsi
    lea  rdx, [rel xm_rel]
    call xa_prefix
    test eax, eax
    jz   .terms
    add  rsi, 4
    call xa_skipb
    mov  [rdi + OP_REL], rsi
    jmp  .out
.terms:
    ; [ term (+|-) term ... ]: registers, reg*scale, numbers
    mov  r12, rsi                    ; the whole inside, for a plain [label]
    xor  ebx, ebx                    ; sign: 0 plus, 1 minus
    jmp  .term
.term:
    call xa_skipb
    cmp  byte [rsi], 0
    je   .out
    cmp  byte [rsi], '+'
    je   .plus
    cmp  byte [rsi], '-'
    je   .minus
    ; one term up to + - or the end, into xa_numbuf
    push rdi
    lea  rdi, [rel xa_numbuf]
    xor  ecx, ecx
    jmp  .tc
.tc:
    mov  al, [rsi]
    test al, al
    jz   .tend
    cmp  al, '+'
    je   .tend
    cmp  al, '-'
    je   .tend
    cmp  al, ' '
    je   .tsk
    cmp  ecx, 30
    jae  .tsk
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .tsk
.tsk:
    inc  rsi
    jmp  .tc
.tend:
    mov  byte [rdi + rcx], 0
    pop  rdi
    ; reg*scale ?
    lea  rcx, [rel xa_numbuf]
    jmp  .star
.star:
    mov  al, [rcx]
    test al, al
    jz   .nostar
    cmp  al, '*'
    je   .scaled
    inc  rcx
    jmp  .star
.scaled:
    mov  byte [rcx], 0
    inc  rcx
    push rcx
    lea  rcx, [rel xa_numbuf]
    call xa_find_reg
    pop  rcx
    cmp  eax, -1
    je   .bad
    mov  [rdi + OP_INDEX], al
    push rax
    call xa_parse_num
    test edx, edx
    jz   .bad_pop
    mov  [rdi + OP_SCALE], al
    pop  rax
    xor  ebx, ebx
    jmp  .term
.bad_pop:
    pop  rax
    jmp  .bad
.nostar:
    lea  rcx, [rel xa_numbuf]
    call xa_find_reg
    cmp  eax, -1
    je   .tnum
    cmp  byte [rdi + OP_BASE], 0xFF
    jne  .as_index
    mov  [rdi + OP_BASE], al
    xor  ebx, ebx
    jmp  .term
.as_index:
    mov  [rdi + OP_INDEX], al
    xor  ebx, ebx
    jmp  .term
.tnum:
    lea  rcx, [rel xa_numbuf]
    call xa_parse_num
    test edx, edx
    jz   .tlabel
    test ebx, ebx
    jz   .tadd
    neg  rax
    jmp  .tadd
.tadd:
    add  [rdi + OP_VAL], rax
    xor  ebx, ebx
    jmp  .term
.tlabel:
    ; [label] or [label+N]: like [rel ...], but only with no register
    cmp  byte [rdi + OP_BASE], 0xFF
    jne  .bad_label
    mov  [rdi + OP_REL], r12
    jmp  .out
.plus:
    inc  rsi
    xor  ebx, ebx
    jmp  .term
.minus:
    inc  rsi
    mov  ebx, 1
    jmp  .term
.bad_label:
    lea  rcx, [rel e_label]
    call xa_fail
    jmp  .out
.bad:
    lea  rcx, [rel e_operand]
    call xa_fail
    jmp  .out
.out:
    pop  r12
    pop  rbx
    ret
; .sizeword(rcx = text, rdx = word) -> rax = text after "word " or 0
.sizeword:
    push rcx
    call xa_prefix
    pop  rcx
    test eax, eax
    jz   .sw_no
    ; the word must be followed by a blank
    mov  rax, rcx
    jmp  .sw_len
.sw_len:
    cmp  byte [rdx], 0
    je   .sw_end
    inc  rax
    inc  rdx
    jmp  .sw_len
.sw_end:
    cmp  byte [rax], ' '
    jne  .sw_no
    ret
.sw_no:
    xor  eax, eax
    ret

; xa_find_reg(rcx = text) -> eax = x86 register 0..15 and edx = size, or
; eax = -1 when the text is no register name
xa_find_reg:
    push rbx
    push rsi
    push rdi
    push r9
    lea  rbx, [rel xa_regs]
    jmp  .e
.e:
    cmp  byte [rbx], 0
    je   .none
    mov  rsi, rcx
    mov  rdi, rbx
    xor  edx, edx
    jmp  .c
.c:
    cmp  edx, 5
    jae  .full
    movzx eax, byte [rdi + rdx]
    movzx r9d, byte [rsi + rdx]
    ; uppercase letters in the text count as lowercase
    cmp  r9d, 'A'
    jb   .cmpc
    cmp  r9d, 'Z'
    ja   .cmpc
    add  r9d, 32
    jmp  .cmpc
.cmpc:
    cmp  eax, r9d
    jne  .next
    test eax, eax
    jz   .found
    inc  edx
    jmp  .c
.full:
    cmp  byte [rsi + 5], 0
    jne  .next
    jmp  .found
.found:
    movzx eax, byte [rbx + 5]
    movzx edx, byte [rbx + 6]
    pop  r9
    pop  rdi
    pop  rsi
    pop  rbx
    ret
.next:
    add  rbx, 7
    jmp  .e
.none:
    mov  eax, -1
    xor  edx, edx
    pop  r9
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xa_parse_num(rcx = text) -> rax = value, edx = 1 when the whole text is a
; number: [-]decimal, [-]0xhex, or 'c'
xa_parse_num:
    push rbx
    push rsi
    mov  rsi, rcx
    xor  ebx, ebx                    ; negative
    cmp  byte [rsi], 0x27
    je   .chr
    cmp  byte [rsi], '-'
    jne  .digits
    mov  ebx, 1
    inc  rsi
    jmp  .digits
.digits:
    movzx eax, byte [rsi]
    sub  eax, '0'
    cmp  eax, 9
    ja   .no
    xor  eax, eax
    cmp  byte [rsi], '0'
    jne  .dec
    cmp  byte [rsi+1], 'x'
    je   .hex0
    cmp  byte [rsi+1], 'X'
    je   .hex0
    jmp  .dec
.dec:
    movzx ecx, byte [rsi]
    test ecx, ecx
    jz   .done
    sub  ecx, '0'
    cmp  ecx, 9
    ja   .no
    imul rax, rax, 10
    add  rax, rcx
    inc  rsi
    jmp  .dec
.hex0:
    add  rsi, 2
    cmp  byte [rsi], 0
    je   .no
    jmp  .hex
.hex:
    movzx ecx, byte [rsi]
    test ecx, ecx
    jz   .done
    cmp  ecx, '0'
    jb   .no
    cmp  ecx, '9'
    jbe  .h09
    or   ecx, 32
    cmp  ecx, 'a'
    jb   .no
    cmp  ecx, 'f'
    ja   .no
    sub  ecx, 'a' - 10
    jmp  .hadd
.h09:
    sub  ecx, '0'
    jmp  .hadd
.hadd:
    shl  rax, 4
    add  rax, rcx
    inc  rsi
    jmp  .hex
.chr:
    movzx eax, byte [rsi+1]
    cmp  byte [rsi+2], 0x27
    jne  .no
    cmp  byte [rsi+3], 0
    jne  .no
    mov  edx, 1
    pop  rsi
    pop  rbx
    ret
.done:
    test ebx, ebx
    jz   .pos
    neg  rax
    jmp  .pos
.pos:
    mov  edx, 1
    pop  rsi
    pop  rbx
    ret
.no:
    xor  eax, eax
    xor  edx, edx
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; EMITTING HELPERS
; ==============================================================================

; xa_arm(al = x86 register) -> rax = ARM register number
xa_arm:
    movzx eax, al
    lea  rdx, [rel xa_rmap]
    movzx eax, byte [rdx + rax]
    ret

; xa_opr(rcx = operand record) -> rax = ARM register of that register operand
xa_opr:
    push rdx
    mov  al, [rcx + OP_REG]
    call xa_arm
    pop  rdx
    ret

; xa_imm_to(rcx = ARM register, rdx = value): mov Xn, #value
xa_imm_to:
    ARG  0, rcx
    ARG  1, rdx
    push rcx
    lea  rcx, [rel f_mov_imm]
    call xa_fmt
    pop  rcx
    ret

; xa_addr(rcx = memory operand) -> xa_mb = base ARM register, xa_mo = offset.
; Uses x16 for [rel L], [L] and an index.
xa_addr:
    push rbx
    mov  rbx, rcx
    mov  rax, [rbx + OP_REL]
    test rax, rax
    jz   .regs
    ARG  0, rax
    lea  rcx, [rel f_adrl]
    call xa_fmt
    mov  qword [rel xa_mb], 16
    mov  qword [rel xa_mo], 0
    pop  rbx
    ret
.regs:
    mov  rax, [rbx + OP_VAL]
    mov  [rel xa_mo], rax
    cmp  byte [rbx + OP_INDEX], 0xFF
    je   .noidx
    ; the shift for the scale
    movzx eax, byte [rbx + OP_SCALE]
    xor  edx, edx
    cmp  eax, 2
    jne  .s4
    mov  edx, 1
    jmp  .shs
.s4:
    cmp  eax, 4
    jne  .s8
    mov  edx, 2
    jmp  .shs
.s8:
    cmp  eax, 8
    jne  .shs
    mov  edx, 3
    jmp  .shs
.shs:
    push rdx
    mov  al, [rbx + OP_INDEX]
    call xa_arm
    pop  rdx
    cmp  byte [rbx + OP_BASE], 0xFF
    jne  .both
    ARG  0, rax
    ARG  1, rdx
    lea  rcx, [rel f_lsl16]
    call xa_fmt
    mov  qword [rel xa_mb], 16
    pop  rbx
    ret
.both:
    push rax
    push rdx
    mov  al, [rbx + OP_BASE]
    call xa_arm
    pop  rdx
    pop  rcx
    ARG  0, rax
    ARG  1, rcx
    ARG  2, rdx
    lea  rcx, [rel f_add16]
    call xa_fmt
    mov  qword [rel xa_mb], 16
    pop  rbx
    ret
.noidx:
    cmp  byte [rbx + OP_BASE], 0xFF
    je   .nobase
    mov  al, [rbx + OP_BASE]
    call xa_arm
    mov  [rel xa_mb], rax
    pop  rbx
    ret
.nobase:
    lea  rcx, [rel e_operand]
    call xa_fail
    mov  qword [rel xa_mb], 16
    pop  rbx
    ret

; xa_mem(rcx = memory operand, edx = 0 load / 1 store, r8 = access size
; 1 2 4 8 16, r9 = the register text): one load or store
xa_mem:
    push rbx
    push rsi
    push rdi
    push r12
    mov  r12, rdx                    ; store?
    mov  rbx, r8                     ; size
    mov  rsi, r9                     ; register text
    call xa_addr
    ; suffix b / h
    lea  rdi, [rel o_none]
    cmp  rbx, 1
    jne  .nb
    lea  rdi, [rel o_b]
    jmp  .sfx
.nb:
    cmp  rbx, 2
    jne  .sfx
    lea  rdi, [rel o_h]
    jmp  .sfx
.sfx:
    mov  rax, [rel xa_mo]
    test rax, rax
    jz   .plain
    js   .unscaled
    ; scaled unsigned offset: a multiple of the size, at most 4095 of them
    xor  edx, edx
    div  rbx
    test rdx, rdx
    jnz  .unscaled
    cmp  rax, 4095
    ja   .unscaled
    lea  rax, [rel o_ldr]
    test r12, r12
    jz   .so
    lea  rax, [rel o_str]
    jmp  .so
.so:
    ARG  0, rax
    ARG  1, rdi
    ARG  2, rsi
    mov  rax, [rel xa_mb]
    ARG  3, rax
    mov  rax, [rel xa_mo]
    ARG  4, rax
    lea  rcx, [rel f_ldst_o]
    call xa_fmt
    jmp  .out
.unscaled:
    mov  rax, [rel xa_mo]
    cmp  rax, -256
    jl   .far
    cmp  rax, 255
    jg   .far
    lea  rax, [rel o_ldur]
    test r12, r12
    jz   .uo
    lea  rax, [rel o_stur]
    jmp  .uo
.uo:
    ARG  0, rax
    ARG  1, rdi
    ARG  2, rsi
    mov  rax, [rel xa_mb]
    ARG  3, rax
    mov  rax, [rel xa_mo]
    ARG  4, rax
    lea  rcx, [rel f_ldst_o]
    call xa_fmt
    jmp  .out
.far:
    ; the offset into a scratch register, added to the base
    mov  rcx, 16
    cmp  qword [rel xa_mb], 16
    jne  .ftmp
    mov  rcx, 17
    jmp  .ftmp
.ftmp:
    push rcx
    mov  rdx, [rel xa_mo]
    call xa_imm_to
    pop  rcx
    ARG  0, rcx
    ARG  2, rcx
    mov  rax, [rel xa_mb]
    ARG  1, rax
    push rcx
    lea  rcx, [rel f_add_tmp]
    call xa_fmt
    pop  rcx
    mov  [rel xa_mb], rcx
    jmp  .plain
.plain:
    lea  rax, [rel o_ldr]
    test r12, r12
    jz   .po
    lea  rax, [rel o_str]
    jmp  .po
.po:
    ARG  0, rax
    ARG  1, rdi
    ARG  2, rsi
    mov  rax, [rel xa_mb]
    ARG  3, rax
    lea  rcx, [rel f_ldst]
    call xa_fmt
    jmp  .out
.out:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xa_regname(al = class 'x' 'w' 'd' 'q', rdx = number) -> rax = its text,
; in one of four rotating buffers (an instruction names at most three)
xa_regname:
    push rdi
    push rsi
    push rcx
    mov  rcx, [rel xa_rn_next]
    inc  rcx
    and  rcx, 3
    mov  [rel xa_rn_next], rcx
    shl  rcx, 3
    lea  rdi, [rel xa_rn_bufs]
    add  rdi, rcx
    push rdi
    ; write through the output cursor, then move it back
    mov  rsi, [rel xa_out]
    push rsi
    call xa_put_reg
    pop  rsi
    mov  rcx, [rel xa_out]
    sub  rcx, rsi
    xor  eax, eax
    jmp  .cp
.cp:
    cmp  rax, rcx
    jae  .cpd
    mov  dl, [rsi + rax]
    mov  [rdi + rax], dl
    inc  rax
    jmp  .cp
.cpd:
    mov  byte [rdi + rax], 0
    mov  [rel xa_out], rsi
    pop  rax
    pop  rcx
    pop  rsi
    pop  rdi
    ret

section .bss
    xa_rn_next resq 1
    xa_rn_bufs resb 32
section .text

; xa_add_imm(rcx = Rd, rdx = Rn, r8 = offset, r9 = "s" or "") Rd = Rn + off
xa_add_imm:
    push rbx
    push rsi
    push rdi
    push r12
    mov  rbx, rcx
    mov  rsi, rdx
    mov  rdi, r8
    mov  r12, r9
    test rdi, rdi
    jnz  .some
    cmp  byte [r12], 0
    jne  .some
    cmp  rbx, rsi
    je   .out
    ARG  0, rbx
    ARG  1, rsi
    lea  rcx, [rel f_mov_rr]
    call xa_fmt
    jmp  .out
.some:
    cmp  rdi, 0
    jl   .neg
    cmp  rdi, 4096
    jge  .big
    ARG  0, r12
    ARG  1, rbx
    ARG  2, rsi
    ARG  3, rdi
    lea  rcx, [rel f_addi]
    call xa_fmt
    jmp  .out
.neg:
    cmp  rdi, -4096
    jle  .big
    mov  rax, rdi
    neg  rax
    ARG  0, r12
    ARG  1, rbx
    ARG  2, rsi
    ARG  3, rax
    lea  rcx, [rel f_subi]
    call xa_fmt
    jmp  .out
.big:
    mov  rcx, 16
    cmp  rsi, 16
    jne  .bt
    mov  rcx, 17
    jmp  .bt
.bt:
    push rcx
    mov  rdx, rdi
    call xa_imm_to
    pop  rcx
    ARG  0, r12
    ARG  1, rbx
    ARG  2, rsi
    ARG  3, rcx
    lea  rcx, [rel f_addr]
    call xa_fmt
    jmp  .out
.out:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xa_add_wimm: the same for w registers with a small immediate (partial ops)

; xa_merge_low(rcx = x86 register written, rdx = ARM register holding the new
; low part, r8 = size 1 or 2): the x86 partial write, upper bits kept
xa_merge_low:
    push rbx
    push rsi
    push rdi
    mov  rsi, rdx
    mov  rdi, r8
    mov  al, cl
    call xa_arm
    mov  rbx, rax
    mov  rax, 0xFF
    cmp  rdi, 1
    je   .k
    mov  rax, 0xFFFF
    jmp  .k
.k:
    ARG  0, rsi
    ARG  1, rax
    lea  rcx, [rel f_and_keep]
    call xa_fmt
    mov  rax, 0xFFFFFFFFFFFFFF00
    cmp  rdi, 1
    je   .c
    mov  rax, 0xFFFFFFFFFFFF0000
    jmp  .c
.c:
    ARG  0, rbx
    ARG  1, rbx
    ARG  2, rax
    lea  rcx, [rel f_and_clear]
    call xa_fmt
    ARG  0, rbx
    ARG  1, rbx
    lea  rcx, [rel f_orr17]
    call xa_fmt
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xa_src(rcx = operand, rdx = size 4 or 8) -> rax = text of an ARM register
; holding it: the register itself, or x16/w16 loaded with the immediate or
; the memory
xa_src:
    push rbx
    push rsi
    mov  rbx, rcx
    mov  rsi, rdx
    mov  al, [rbx + OP_KIND]
    cmp  al, K_REG
    je   .reg
    cmp  al, K_IMM
    je   .imm
    cmp  al, K_MEM
    je   .mem
    lea  rcx, [rel e_operand]
    call xa_fail
    lea  rax, [rel o_x16]
    jmp  .out
.reg:
    mov  rcx, rbx
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  rsi, 4
    ja   .rn
    mov  al, 'w'
    jmp  .rn
.rn:
    call xa_regname
    jmp  .out
.imm:
    mov  rcx, 16
    mov  rdx, [rbx + OP_VAL]
    call xa_imm_to
    lea  rax, [rel o_x16]
    cmp  rsi, 4
    ja   .out
    lea  rax, [rel o_w16]
    jmp  .out
.mem:
    movzx r8d, byte [rbx + OP_MSIZE]
    test r8d, r8d
    jnz  .ms
    mov  r8, rsi
    jmp  .ms
.ms:
    lea  r9, [rel o_x16]
    cmp  r8, 4
    ja   .ml
    lea  r9, [rel o_w16]
    jmp  .ml
.ml:
    push r9
    mov  rcx, rbx
    xor  edx, edx
    call xa_mem
    pop  rax
    jmp  .out
.out:
    pop  rsi
    pop  rbx
    ret

; xa_logic_ok(rcx = value, edx = 32 or 64) -> eax = 1 when an ARM logical
; instruction can take it as an immediate (a rotated run of ones, repeated)
xa_logic_ok:
    push rbx
    push rsi
    push rdi
    push r12
    mov  rbx, rcx
    mov  esi, edx                    ; bits
    ; mask to the width
    mov  rdi, -1
    cmp  esi, 64
    je   .m
    mov  edi, 0xFFFFFFFF
    jmp  .m
.m:
    and  rbx, rdi
    test rbx, rbx
    jz   .no
    cmp  rbx, rdi
    je   .no
    ; the smallest element size whose halves repeat
    mov  r12d, esi                   ; size
    jmp  .halve
.halve:
    cmp  r12d, 2
    jbe  .elem
    mov  ecx, r12d
    shr  ecx, 1                      ; half
    mov  rax, 1
    shl  rax, cl
    dec  rax                         ; low mask of half bits
    mov  rdx, rbx
    and  rdx, rax
    mov  r8, rbx
    shr  r8, cl
    and  r8, rax
    cmp  rdx, r8
    jne  .elem
    mov  r12d, ecx
    jmp  .halve
.elem:
    ; e = the element; m = its mask
    mov  ecx, r12d
    mov  rdi, -1
    cmp  ecx, 64
    je   .em
    mov  rdi, 1
    shl  rdi, cl
    dec  rdi
    jmp  .em
.em:
    mov  rsi, rbx
    and  rsi, rdi                    ; e
    xor  r8d, r8d                    ; rotation
    jmp  .rot
.rot:
    cmp  r8d, r12d
    jae  .no
    ; rot = ((e >> r) | (e << (size - r))) & m
    mov  rax, rsi
    mov  ecx, r8d
    shr  rax, cl
    mov  rdx, rsi
    mov  ecx, r12d
    sub  ecx, r8d
    cmp  ecx, 64
    jae  .nosh
    shl  rdx, cl
    jmp  .shd
.nosh:
    xor  edx, edx
    jmp  .shd
.shd:
    or   rax, rdx
    and  rax, rdi
    test rax, rax
    jz   .rnext
    lea  rdx, [rax + 1]
    test rax, rdx
    jz   .yes
    jmp  .rnext
.rnext:
    inc  r8d
    jmp  .rot
.yes:
    mov  eax, 1
    jmp  .out
.no:
    xor  eax, eax
    jmp  .out
.out:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xa_cond(rcx = x86 condition text) -> rax = ARM condition text, or 0 after
; recording the error
xa_cond:
    push rbx
    push rsi
    mov  rsi, rcx
    mov  rax, [rel xa_fk]
    test rax, rax
    jz   .noflags
    ; a pending tst first: or and xor leave the ARM flags alone
    mov  rax, [rel xa_fpend]
    test rax, rax
    jz   .table
    dec  rax
    ARG  0, rax
    ARG  1, rax
    lea  rcx, [rel f_tst_x]
    cmp  qword [rel xa_fpw], 0
    je   .tstx
    lea  rcx, [rel f_tst_w]
    jmp  .tstx
.tstx:
    call xa_fmt
    mov  qword [rel xa_fpend], 0
    jmp  .table
.table:
    mov  rax, [rel xa_fk]
    lea  rbx, [rel xa_cc_sub]
    cmp  rax, F_SUB
    je   .look
    lea  rbx, [rel xa_cc_logic]
    cmp  rax, F_LOGIC
    je   .look
    lea  rbx, [rel xa_cc_add]
    cmp  rax, F_ADD
    je   .look
    lea  rbx, [rel xa_cc_fp]
    jmp  .look
.look:
    cmp  byte [rbx], 0
    je   .nocond
    mov  rcx, rsi
    mov  rdx, rbx
    call xa_streq
    test eax, eax
    jnz  .hit
    add  rbx, 8
    jmp  .look
.hit:
    lea  rax, [rbx + 4]
    pop  rsi
    pop  rbx
    ret
.noflags:
    lea  rcx, [rel e_flags]
    call xa_fail
    xor  eax, eax
    pop  rsi
    pop  rbx
    ret
.nocond:
    lea  rcx, [rel e_cond]
    call xa_fail
    xor  eax, eax
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; ONE INSTRUCTION. r12 r13 r14 = the three operand records.
; ==============================================================================
xa_insn:
    XM xm_mov,      i_mov
    XM xm_movzx,    i_movzx
    XM xm_lea,      i_lea
    XM xm_push,     i_push
    XM xm_pop,      i_pop
    XM xm_add,      i_add
    XM xm_sub,      i_sub
    XM xm_and,      i_and
    XM xm_or,       i_or
    XM xm_xor,      i_xor
    XM xm_inc,      i_inc
    XM xm_dec,      i_dec
    XM xm_neg,      i_neg
    XM xm_not,      i_not
    XM xm_cmp,      i_cmp
    XM xm_test,     i_test
    XM xm_imul,     i_imul
    XM xm_cqo,      i_cqo
    XM xm_idiv,     i_idiv
    XM xm_div,      i_div
    XM xm_shl,      i_shl
    XM xm_sal,      i_shl
    XM xm_shr,      i_shr
    XM xm_sar,      i_sar
    XM xm_rol,      i_rol
    XM xm_ror,      i_ror
    XM xm_xchg,     i_xchg
    XM xm_jmp,      i_jmp
    XM xm_call,     i_call
    XM xm_ret,      i_ret
    XM xm_syscall,  i_syscall
    XM xm_movsd,    i_movsd
    XM xm_movss,    i_movss
    XM xm_cvtss2sd, i_cvtss2sd
    XM xm_cvtsd2ss, i_cvtsd2ss
    XM xm_movq,     i_movsd
    XM xm_movups,   i_movups
    XM xm_movupd,   i_movups
    XM xm_movaps,   i_movups
    XM xm_movapd,   i_movups
    XM xm_addsd,    i_addsd
    XM xm_subsd,    i_subsd
    XM xm_mulsd,    i_mulsd
    XM xm_divsd,    i_divsd
    XM xm_sqrtsd,   i_sqrtsd
    XM xm_addpd,    i_addpd
    XM xm_subpd,    i_subpd
    XM xm_mulpd,    i_mulpd
    XM xm_divpd,    i_divpd
    XM xm_addps,    i_addps
    XM xm_subps,    i_subps
    XM xm_mulps,    i_mulps
    XM xm_divps,    i_divps
    XM xm_xorps,    i_xorps
    XM xm_xorpd,    i_xorps
    XM xm_andps,    i_andps
    XM xm_andpd,    i_andps
    XM xm_orpd,     i_orps
    XM xm_ucomisd,  i_ucomisd
    XM xm_comisd,   i_ucomisd
    XM xm_cvtsi2sd, i_cvtsi2sd
    XM xm_cvttsd2si, i_cvttsd2si
    XM xm_cvtsd2si, i_cvtsd2si
    XM xm_prefetch, i_prefetch
    XM xm_clflush,  i_clflush
    XM xm_nop,      i_nop
    XM xm_pause,    i_nop
    XM xm_mfence,   i_mfence
    ; jcc and setcc
    lea  rcx, [rel xa_mn]
    cmp  byte [rcx], 'j'
    je   i_jcc
    lea  rdx, [rel xm_set]
    call xa_prefix
    test eax, eax
    jnz  i_setcc
    jmp  i_bad

section .data
    xm_set db "set", 0
section .text

i_bad:
    lea  rcx, [rel e_form]
    call xa_fail
    ret

; the operand kinds of the first two operands, in al and cl
%macro KINDS 0
    mov  al, [r12 + OP_KIND]
    mov  cl, [r13 + OP_KIND]
%endmacro

; ---- mov ---------------------------------------------------------------------
i_mov:
    KINDS
    cmp  al, K_REG
    jne  .to_mem
    cmp  cl, K_REG
    je   .rr
    cmp  cl, K_IMM
    je   .ri
    cmp  cl, K_MEM
    je   .rm
    jmp  i_bad
.rr:
    movzx ebx, byte [r12 + OP_RSIZE]
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    mov  rcx, r13
    call xa_opr
    mov  rdi, rax
    cmp  ebx, 8
    jne  .rr4
    cmp  rsi, rdi
    je   .done
    ARG  0, rsi
    ARG  1, rdi
    lea  rcx, [rel f_mov_rr]
    call xa_fmt
    ret
.rr4:
    cmp  ebx, 4
    jne  .rrp
    ARG  0, rsi
    ARG  1, rdi
    lea  rcx, [rel f_mov_ww]
    call xa_fmt
    ret
.rrp:
    movzx ecx, byte [r12 + OP_REG]
    mov  rdx, rdi
    mov  r8, rbx
    call xa_merge_low
    ret
.ri:
    movzx ebx, byte [r12 + OP_RSIZE]
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    cmp  ebx, 8
    jne  .ri4
    mov  rcx, rsi
    mov  rdx, [r13 + OP_VAL]
    call xa_imm_to
    ret
.ri4:
    cmp  ebx, 4
    jne  .rip
    mov  eax, [r13 + OP_VAL]          ; the low 32 bits, zero-extended
    ARG  0, rsi
    ARG  1, rax
    lea  rcx, [rel f_mov_wimm]
    call xa_fmt
    ret
.rip:
    mov  rcx, 16
    mov  rdx, [r13 + OP_VAL]
    call xa_imm_to
    movzx ecx, byte [r12 + OP_REG]
    mov  rdx, 16
    mov  r8, rbx
    call xa_merge_low
    ret
.rm:
    movzx ebx, byte [r12 + OP_RSIZE]
    mov  rcx, r12
    call xa_opr
    mov  rdx, rax
    cmp  ebx, 4
    jb   .rmp
    mov  al, 'x'
    cmp  ebx, 8
    je   .rmn
    mov  al, 'w'
    jmp  .rmn
.rmn:
    call xa_regname
    mov  r9, rax
    mov  rcx, r13
    xor  edx, edx
    mov  r8, rbx
    call xa_mem
    ret
.rmp:
    ; a partial load: into w16, then merged
    mov  rcx, r13
    xor  edx, edx
    mov  r8, rbx
    lea  r9, [rel o_w16]
    call xa_mem
    movzx ecx, byte [r12 + OP_REG]
    mov  rdx, 16
    mov  r8, rbx
    call xa_merge_low
    ret
.to_mem:
    cmp  al, K_MEM
    jne  i_bad
    cmp  cl, K_REG
    je   .mr
    cmp  cl, K_IMM
    je   .mi
    jmp  i_bad
.mr:
    movzx ebx, byte [r13 + OP_RSIZE]
    mov  rcx, r13
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  ebx, 8
    je   .mrn
    mov  al, 'w'
    jmp  .mrn
.mrn:
    call xa_regname
    mov  r9, rax
    mov  rcx, r12
    mov  edx, 1
    mov  r8, rbx
    call xa_mem
    ret
.mi:
    movzx ebx, byte [r12 + OP_MSIZE]
    test ebx, ebx
    jnz  .mis
    mov  ebx, 8
    jmp  .mis
.mis:
    mov  rax, [r13 + OP_VAL]
    test rax, rax
    jnz  .mi_val
    lea  r9, [rel o_xzr]
    cmp  ebx, 4
    ja   .mi_st
    lea  r9, [rel o_wzr]
    jmp  .mi_st
.mi_val:
    mov  rcx, 17
    mov  rdx, rax
    call xa_imm_to
    lea  r9, [rel o_x17]
    cmp  ebx, 4
    ja   .mi_st
    lea  r9, [rel o_w17]
    jmp  .mi_st
.mi_st:
    mov  rcx, r12
    mov  edx, 1
    mov  r8, rbx
    call xa_mem
    ret
.done:
    ret

; ---- movzx -------------------------------------------------------------------
i_movzx:
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    mov  al, [r13 + OP_KIND]
    cmp  al, K_REG
    je   .reg
    cmp  al, K_MEM
    jne  i_bad
    ; zero-extending load: ldrb / ldrh into the w register
    movzx r8d, byte [r13 + OP_MSIZE]
    test r8d, r8d
    jz   i_bad
    push r8
    mov  rdx, rsi
    mov  al, 'w'
    call xa_regname
    mov  r9, rax
    pop  r8
    mov  rcx, r13
    xor  edx, edx
    call xa_mem
    ret
.reg:
    mov  rcx, r13
    call xa_opr
    mov  rdi, rax
    mov  rax, 0xFF
    cmp  byte [r13 + OP_RSIZE], 1
    je   .z
    mov  rax, 0xFFFF
    jmp  .z
.z:
    ARG  0, rsi
    ARG  1, rdi
    ARG  2, rax
    lea  rcx, [rel f_and_clear]
    call xa_fmt
    ret

; ---- lea ---------------------------------------------------------------------
i_lea:
    mov  rcx, r12
    call xa_opr
    mov  rbx, rax
    mov  rax, [r13 + OP_REL]
    test rax, rax
    jz   .regs
    ARG  0, rbx
    ARG  1, rax
    lea  rcx, [rel f_adrl_r]
    call xa_fmt
    ret
.regs:
    mov  rcx, r13
    call xa_addr
    mov  rcx, rbx
    mov  rdx, [rel xa_mb]
    mov  r8, [rel xa_mo]
    lea  r9, [rel o_none]
    call xa_add_imm
    ret

; ---- push / pop --------------------------------------------------------------
i_push:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  .imm
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    lea  rcx, [rel f_push]
    call xa_fmt
    ret
.imm:
    cmp  byte [r12 + OP_KIND], K_IMM
    jne  i_bad
    mov  rcx, 16
    mov  rdx, [r12 + OP_VAL]
    call xa_imm_to
    ARG  0, 16
    lea  rcx, [rel f_push]
    call xa_fmt
    ret
i_pop:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    ; pop rsp: a load into the base with writeback is unpredictable on
    ; ARM64, and the popped value is the new stack anyway
    cmp  byte [r12 + OP_REG], 4
    jne  .not_sp
    lea  rcx, [rel f_pop_sp]
    call xa_fmt
    ret
.not_sp:
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    lea  rcx, [rel f_pop]
    call xa_fmt
    ret

; ---- add sub and or xor ------------------------------------------------------
; rdi = which: 0 add, 1 sub, 2 and, 3 or, 4 xor
i_add:
    xor  edi, edi
    jmp  xa_arith
i_sub:
    mov  edi, 1
    jmp  xa_arith
i_and:
    mov  edi, 2
    jmp  xa_arith
i_or:
    mov  edi, 3
    jmp  xa_arith
i_xor:
    mov  edi, 4
    jmp  xa_arith

section .data
    ; per operation: flag-setting ARM name, flags kind, pending tst
    xa_ar_name dq o_adds, o_subs, o_ands, o_orr, o_eor
    xa_ar_plain dq o_add, o_sub, o_and, o_orr, o_eor
    xa_ar_fk   dq F_ADD, F_SUB, F_LOGIC, F_LOGIC, F_LOGIC
section .text

xa_arith:
    mov  al, [r12 + OP_KIND]
    cmp  al, K_MEM
    je   .mem
    cmp  al, K_REG
    jne  i_bad
    movzx ebx, byte [r12 + OP_RSIZE]
    cmp  ebx, 4
    jb   .partial
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax                    ; Rd
    cmp  edi, 2
    jae  .logic
    ; add / sub: the flags as x86 sets them (adds / subs)
    cmp  byte [r13 + OP_KIND], K_IMM
    jne  .as_reg
    cmp  ebx, 4
    je   .as_reg
    mov  r8, [r13 + OP_VAL]
    ; sub of 0..4095 stays a subs, so the carry means what x86 means by it
    cmp  edi, 1
    jne  .as_add
    cmp  r8, 0
    jl   .as_negsub
    cmp  r8, 4096
    jge  .as_negsub
    lea  rax, [rel o_s]
    ARG  0, rax
    ARG  1, rsi
    ARG  2, rsi
    ARG  3, r8
    lea  rcx, [rel f_subi]
    call xa_fmt
    jmp  .fl
.as_negsub:
    neg  r8
    jmp  .as_add
.as_add:
    mov  rcx, rsi
    mov  rdx, rsi
    lea  r9, [rel o_s]
    call xa_add_imm
    jmp  .fl
.as_reg:
    mov  rcx, r13
    mov  rdx, rbx
    call xa_src
    mov  r8, rax
    mov  rdx, rsi
    mov  al, 'x'
    cmp  ebx, 8
    je   .as_n
    mov  al, 'w'
    jmp  .as_n
.as_n:
    push r8
    call xa_regname
    pop  r8
    lea  rcx, [rel xa_ar_name]
    mov  rcx, [rcx + rdi*8]
    ARG  0, rcx
    ARG  1, rax
    ARG  2, rax
    ARG  3, r8
    lea  rcx, [rel f_ops3s]
    call xa_fmt
    jmp  .fl
.fl:
    lea  rax, [rel xa_ar_fk]
    mov  rax, [rax + rdi*8]
    mov  [rel xa_fk], rax
    mov  qword [rel xa_fpend], 0
    ret
.logic:
    ; xor r, r is zero
    cmp  edi, 4
    jne  .lg
    cmp  byte [r13 + OP_KIND], K_REG
    jne  .lg
    mov  al, [r13 + OP_REG]
    cmp  al, [r12 + OP_REG]
    jne  .lg
    mov  rcx, rsi
    xor  edx, edx
    call xa_imm_to
    jmp  .lg_flags
.lg:
    ; the name: and sets flags (ands); orr and eor do not, so a tst is owed
    lea  rax, [rel xa_ar_name]
    mov  r15, [rax + rdi*8]
    ; text of Rd
    mov  rdx, rsi
    mov  al, 'x'
    cmp  ebx, 8
    je   .lgn
    mov  al, 'w'
    jmp  .lgn
.lgn:
    call xa_regname
    mov  r14, rax
    cmp  byte [r13 + OP_KIND], K_IMM
    jne  .lg_reg
    mov  rcx, [r13 + OP_VAL]
    mov  edx, 64
    cmp  ebx, 8
    je   .lgc
    mov  edx, 32
    mov  ecx, ecx
    jmp  .lgc
.lgc:
    push rcx
    call xa_logic_ok
    pop  rcx
    test eax, eax
    jz   .lg_reg
    ARG  0, r15
    ARG  1, r14
    ARG  2, r14
    ARG  3, rcx
    lea  rcx, [rel f_ops3h]
    call xa_fmt
    jmp  .lg_flags
.lg_reg:
    mov  rcx, r13
    mov  rdx, rbx
    call xa_src
    ARG  0, r15
    ARG  1, r14
    ARG  2, r14
    ARG  3, rax
    lea  rcx, [rel f_ops3s]
    call xa_fmt
    jmp  .lg_flags
.lg_flags:
    mov  qword [rel xa_fk], F_LOGIC
    mov  qword [rel xa_fpend], 0
    cmp  edi, 2
    je   .lg_out
    lea  rax, [rsi + 1]
    mov  [rel xa_fpend], rax
    xor  eax, eax
    cmp  ebx, 8
    je   .lgw
    mov  eax, 1
    jmp  .lgw
.lgw:
    mov  [rel xa_fpw], rax
    jmp  .lg_out
.lg_out:
    ret
.partial:
    ; 8 or 16 bits: computed in w16, the low part merged back
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    cmp  byte [r13 + OP_KIND], K_IMM
    jne  .p_reg
    mov  rax, [r13 + OP_VAL]
    and  eax, 0xFFFF
    ARG  0, rax
    lea  rcx, [rel f_movw16]
    call xa_fmt
    lea  r8, [rel o_w17]
    jmp  .p_op
.p_reg:
    mov  rcx, r13
    mov  rdx, 4
    call xa_src
    mov  r8, rax
    jmp  .p_op
.p_op:
    lea  rax, [rel xa_ar_plain]
    mov  rax, [rax + rdi*8]
    ARG  0, rax
    lea  rax, [rel o_w16]
    ARG  1, rax
    push r8
    mov  rdx, rsi
    mov  al, 'w'
    call xa_regname
    pop  r8
    ARG  2, rax
    ARG  3, r8
    lea  rcx, [rel f_ops3s]
    call xa_fmt
    movzx ecx, byte [r12 + OP_REG]
    mov  rdx, 16
    mov  r8, rbx
    call xa_merge_low
    mov  qword [rel xa_fk], F_NONE
    mov  qword [rel xa_fpend], 0
    ret
.mem:
    ; read, operate, write back
    movzx ebx, byte [r12 + OP_MSIZE]
    test ebx, ebx
    jnz  .msz
    mov  ebx, 8
    cmp  byte [r13 + OP_KIND], K_REG
    jne  .msz
    movzx ebx, byte [r13 + OP_RSIZE]
    jmp  .msz
.msz:
    lea  r15, [rel o_x17]
    cmp  ebx, 4
    ja   .mld
    lea  r15, [rel o_w17]
    jmp  .mld
.mld:
    mov  rcx, r12
    xor  edx, edx
    mov  r8, rbx
    mov  r9, r15
    call xa_mem
    mov  rcx, r13
    mov  rdx, rbx
    cmp  rdx, 4
    jae  .msrc
    mov  rdx, 4
    jmp  .msrc
.msrc:
    call xa_src
    mov  r8, rax
    lea  rax, [rel xa_ar_name]
    mov  rax, [rax + rdi*8]
    ARG  0, rax
    ARG  1, r15
    ARG  2, r15
    ARG  3, r8
    lea  rcx, [rel f_ops3s]
    call xa_fmt
    mov  rcx, r12
    mov  edx, 1
    mov  r8, rbx
    mov  r9, r15
    call xa_mem
    lea  rax, [rel xa_ar_fk]
    mov  rax, [rax + rdi*8]
    mov  [rel xa_fk], rax
    mov  qword [rel xa_fpend], 0
    cmp  edi, 3
    jb   .xm_out
    ; orr / eor on memory: the tst is on x17
    mov  qword [rel xa_fpend], 18
    xor  eax, eax
    cmp  ebx, 4
    ja   .mw
    mov  eax, 1
    jmp  .mw
.mw:
    mov  [rel xa_fpw], rax
    jmp  .xm_out
.xm_out:
    ret

section .data
    f_ops3s db "    %s %s, %s, %s", 10, 0
    f_ops3h db "    %s %s, %s, #%h", 10, 0
section .text

; ---- inc dec neg not ---------------------------------------------------------
i_inc:
    lea  rdi, [rel o_adds]
    mov  r15, F_ADD
    jmp  xa_incdec
i_dec:
    lea  rdi, [rel o_subs]
    mov  r15, F_SUB
    jmp  xa_incdec
xa_incdec:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  byte [r12 + OP_RSIZE], 8
    je   .n
    mov  al, 'w'
    cmp  byte [r12 + OP_RSIZE], 4
    jne  i_bad
    jmp  .n
.n:
    call xa_regname
    ARG  0, rdi
    ARG  1, rax
    ARG  2, rax
    lea  rcx, [rel f_incdec]
    call xa_fmt
    mov  [rel xa_fk], r15
    mov  qword [rel xa_fpend], 0
    ret
i_neg:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    ARG  1, rax
    lea  rcx, [rel f_neg]
    call xa_fmt
    mov  qword [rel xa_fk], F_SUB
    mov  qword [rel xa_fpend], 0
    ret
i_not:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    ARG  1, rax
    lea  rcx, [rel f_mvn]
    call xa_fmt
    ret

; ---- cmp test ----------------------------------------------------------------
i_cmp:
    mov  al, [r12 + OP_KIND]
    cmp  al, K_MEM
    je   .mem
    cmp  al, K_REG
    jne  i_bad
    movzx ebx, byte [r12 + OP_RSIZE]
    mov  rcx, r12
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  ebx, 8
    je   .rn
    mov  al, 'w'
    jmp  .rn
.rn:
    call xa_regname
    mov  rsi, rax
    jmp  .second
.mem:
    movzx ebx, byte [r12 + OP_MSIZE]
    test ebx, ebx
    jnz  .ms
    mov  ebx, 8
    jmp  .ms
.ms:
    lea  rsi, [rel o_x17]
    cmp  ebx, 4
    ja   .ml
    lea  rsi, [rel o_w17]
    jmp  .ml
.ml:
    mov  rcx, r12
    xor  edx, edx
    mov  r8, rbx
    mov  r9, rsi
    call xa_mem
    jmp  .second
.second:
    cmp  byte [r13 + OP_KIND], K_IMM
    jne  .reg
    mov  rax, [r13 + OP_VAL]
    test rax, rax
    js   .reg
    cmp  rax, 4096
    jae  .reg
    ARG  0, rsi
    ARG  1, rax
    lea  rcx, [rel f_cmp_i]
    call xa_fmt
    jmp  .fl
.reg:
    mov  rcx, r13
    mov  rdx, rbx
    cmp  rdx, 4
    jae  .rs
    mov  rdx, 4
    jmp  .rs
.rs:
    call xa_src
    ARG  0, rsi
    ARG  1, rax
    lea  rcx, [rel f_cmp_r]
    call xa_fmt
    jmp  .fl
.fl:
    mov  qword [rel xa_fk], F_SUB
    mov  qword [rel xa_fpend], 0
    ret

i_test:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    movzx ebx, byte [r12 + OP_RSIZE]
    cmp  ebx, 4
    jb   i_bad
    mov  rcx, r12
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  ebx, 8
    je   .rn
    mov  al, 'w'
    jmp  .rn
.rn:
    call xa_regname
    mov  rsi, rax
    cmp  byte [r13 + OP_KIND], K_IMM
    jne  .reg
    mov  rcx, [r13 + OP_VAL]
    mov  edx, 64
    cmp  ebx, 8
    je   .lc
    mov  edx, 32
    mov  ecx, ecx
    jmp  .lc
.lc:
    push rcx
    call xa_logic_ok
    pop  rcx
    test eax, eax
    jz   .reg
    ARG  0, rsi
    ARG  1, rcx
    lea  rcx, [rel f_tst_i]
    call xa_fmt
    jmp  .fl
.reg:
    mov  rcx, r13
    mov  rdx, rbx
    call xa_src
    ARG  0, rsi
    ARG  1, rax
    lea  rcx, [rel f_tst_r]
    call xa_fmt
    jmp  .fl
.fl:
    mov  qword [rel xa_fk], F_LOGIC
    mov  qword [rel xa_fpend], 0
    ret

; ---- imul cqo idiv div -------------------------------------------------------
i_imul:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    cmp  qword [rel xa_nops], 3
    je   .three
    cmp  qword [rel xa_nops], 2
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    cmp  byte [r13 + OP_KIND], K_REG
    jne  .src
    mov  rcx, r13
    call xa_opr
    jmp  .emit
.src:
    mov  rcx, r13
    mov  rdx, 8
    call xa_src
    mov  rax, 16
    jmp  .emit
.emit:
    ARG  0, rsi
    ARG  1, rsi
    ARG  2, rax
    lea  rcx, [rel f_mul]
    call xa_fmt
    mov  qword [rel xa_fk], F_NONE
    ret
.three:
    cmp  byte [r14 + OP_KIND], K_IMM
    jne  i_bad
    mov  rcx, 16
    mov  rdx, [r14 + OP_VAL]
    call xa_imm_to
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    mov  rcx, r13
    call xa_opr
    ARG  0, rsi
    ARG  1, rax
    ARG  2, 16
    lea  rcx, [rel f_mul]
    call xa_fmt
    mov  qword [rel xa_fk], F_NONE
    ret
i_cqo:
    lea  rcx, [rel f_cqo]
    call xa_fmt
    ret
i_idiv:
    lea  rdi, [rel o_sdiv]
    jmp  xa_divide
i_div:
    lea  rdi, [rel o_udiv]
    jmp  xa_divide
xa_divide:
    ; rdx:rax / r -> rax quotient, rdx remainder (rdx holds only the sign
    ; extension or zero, which is all the generator ever puts there)
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    ARG  0, rdi
    ARG  1, rsi
    lea  rcx, [rel f_div]
    call xa_fmt
    ARG  0, rsi
    lea  rcx, [rel f_msub]
    call xa_fmt
    lea  rcx, [rel f_mov0_16]
    call xa_fmt
    mov  qword [rel xa_fk], F_NONE
    ret

; ---- shifts ------------------------------------------------------------------
i_shl:
    lea  rdi, [rel o_lsl]
    jmp  xa_shift
i_shr:
    lea  rdi, [rel o_lsr]
    jmp  xa_shift
i_sar:
    lea  rdi, [rel o_asr]
    jmp  xa_shift
i_ror:
    lea  rdi, [rel o_ror]
    jmp  xa_shift
i_rol:
    xor  edi, edi                    ; rol: ror by the opposite amount
    jmp  xa_shift
xa_shift:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    cmp  byte [r12 + OP_RSIZE], 8
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    mov  rsi, rax
    mov  qword [rel xa_fk], F_NONE
    mov  qword [rel xa_fpend], 0
    cmp  byte [r13 + OP_KIND], K_IMM
    je   .imm
    ; by cl
    test rdi, rdi
    jz   .rol_cl
    ARG  0, rdi
    ARG  1, rsi
    ARG  2, rsi
    lea  rcx, [rel f_shr_cl]
    call xa_fmt
    ret
.rol_cl:
    ARG  0, rsi
    ARG  1, rsi
    lea  rcx, [rel f_rol_cl]
    call xa_fmt
    ret
.imm:
    mov  rax, [r13 + OP_VAL]
    and  eax, 63
    test rdi, rdi
    jnz  .imm_e
    ; rol #c is ror #(64 - c)
    neg  eax
    and  eax, 63
    lea  rdi, [rel o_ror]
    jmp  .imm_e
.imm_e:
    ARG  0, rdi
    ARG  1, rsi
    ARG  2, rsi
    ARG  3, rax
    lea  rcx, [rel f_shi]
    call xa_fmt
    ret

; ---- xchg [mem], reg: the atomic swap the locks are built on -----------------
i_xchg:
    mov  rbx, r12
    mov  rsi, r13
    cmp  byte [r12 + OP_KIND], K_MEM
    je   .ok
    mov  rbx, r13
    mov  rsi, r12
    cmp  byte [rbx + OP_KIND], K_MEM
    jne  i_bad
    jmp  .ok
.ok:
    cmp  byte [rsi + OP_KIND], K_REG
    jne  i_bad
    mov  rcx, rbx
    call xa_addr
    mov  rax, [rel xa_mo]
    test rax, rax
    jz   .based
    mov  rcx, 16
    mov  rdx, [rel xa_mb]
    mov  r8, rax
    lea  r9, [rel o_none]
    call xa_add_imm
    mov  qword [rel xa_mb], 16
    jmp  .based
.based:
    inc  qword [rel xa_uniq]
    mov  rax, [rel xa_uniq]
    ARG  0, rax
    lea  rcx, [rel f_xa_lbl]
    call xa_fmt
    mov  rcx, rsi
    call xa_opr
    mov  rdi, [rel xa_mb]
    mov  rdx, [rel xa_uniq]
    ARG  0, rdi
    ARG  1, rax
    ARG  2, rdi
    ARG  3, rdx
    ARG  4, rax
    lea  rcx, [rel f_xa_body_x]
    cmp  byte [rsi + OP_RSIZE], 8
    je   .em
    lea  rcx, [rel f_xa_body_w]
    cmp  byte [rsi + OP_RSIZE], 4
    jne  i_bad
    jmp  .em
.em:
    call xa_fmt
    mov  qword [rel xa_fk], F_NONE
    ret

; ---- jumps and calls ---------------------------------------------------------
i_jmp:
    cmp  byte [r12 + OP_KIND], K_REG
    je   .reg
    cmp  byte [r12 + OP_KIND], K_LABEL
    jne  i_bad
    mov  rax, [r12 + OP_TEXT]
    ARG  0, rax
    lea  rcx, [rel f_b]
    call xa_fmt
    ret
.reg:
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    lea  rcx, [rel f_br]
    call xa_fmt
    ret
i_call:
    mov  qword [rel xa_fk], F_NONE
    mov  qword [rel xa_fpend], 0
    cmp  byte [r12 + OP_KIND], K_REG
    je   .reg
    cmp  byte [r12 + OP_KIND], K_LABEL
    jne  i_bad
    mov  rax, [r12 + OP_TEXT]
    ARG  0, rax
    lea  rcx, [rel f_bl]
    call xa_fmt
    ret
.reg:
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    lea  rcx, [rel f_blr]
    call xa_fmt
    ret
i_ret:
    lea  rcx, [rel f_ret]
    call xa_fmt
    ret
i_syscall:
    lea  rcx, [rel f_sys]
    call xa_fmt
    mov  qword [rel xa_fk], F_NONE
    ret
i_jcc:
    cmp  byte [r12 + OP_KIND], K_LABEL
    jne  i_bad
    lea  rcx, [rel xa_mn + 1]
    call xa_cond
    test rax, rax
    jz   .o
    ARG  0, rax
    mov  rax, [r12 + OP_TEXT]
    ARG  1, rax
    lea  rcx, [rel f_bcond]
    call xa_fmt
    jmp  .o
.o:
    ret
i_setcc:
    ; setcc al writes the whole register on ARM: the generator always
    ; follows it with movzx, so nothing is lost
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    lea  rcx, [rel xa_mn + 3]
    call xa_cond
    test rax, rax
    jz   .o
    mov  rsi, rax
    mov  rcx, r12
    call xa_opr
    ARG  0, rax
    ARG  1, rsi
    lea  rcx, [rel f_cset]
    call xa_fmt
    jmp  .o
.o:
    ret

; ---- floating point ----------------------------------------------------------
i_movsd:
    KINDS
    cmp  al, K_XMM
    jne  .from_x
    cmp  cl, K_XMM
    je   .xx
    cmp  cl, K_MEM
    je   .xm
    cmp  cl, K_REG
    je   .xr
    jmp  i_bad
.xx:
    movzx eax, byte [r12 + OP_XMM]
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rax
    ARG  1, rdx
    lea  rcx, [rel f_fmov_dd]
    call xa_fmt
    ret
.xm:
    movzx edx, byte [r12 + OP_XMM]
    mov  al, 'd'
    call xa_regname
    mov  r9, rax
    mov  rcx, r13
    xor  edx, edx
    mov  r8, 8
    call xa_mem
    ret
.xr:
    mov  rcx, r13
    call xa_opr
    movzx edx, byte [r12 + OP_XMM]
    ARG  0, rdx
    ARG  1, rax
    lea  rcx, [rel f_fmov_dx]
    call xa_fmt
    ret
.from_x:
    cmp  cl, K_XMM
    jne  i_bad
    cmp  al, K_MEM
    je   .mx
    cmp  al, K_REG
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rax
    ARG  1, rdx
    lea  rcx, [rel f_fmov_xd]
    call xa_fmt
    ret
.mx:
    movzx edx, byte [r13 + OP_XMM]
    mov  al, 'd'
    call xa_regname
    mov  r9, rax
    mov  rcx, r12
    mov  edx, 1
    mov  r8, 8
    call xa_mem
    ret

; movss: four bytes through an s register, for [f32; N]
i_movss:
    KINDS
    cmp  al, K_XMM
    jne  .st
    cmp  cl, K_MEM
    jne  i_bad
    movzx edx, byte [r12 + OP_XMM]
    mov  al, 's'
    call xa_regname
    mov  r9, rax
    mov  rcx, r13
    xor  edx, edx
    mov  r8, 4
    call xa_mem
    ret
.st:
    cmp  al, K_MEM
    jne  i_bad
    cmp  cl, K_XMM
    jne  i_bad
    movzx edx, byte [r13 + OP_XMM]
    mov  al, 's'
    call xa_regname
    mov  r9, rax
    mov  rcx, r12
    mov  edx, 1
    mov  r8, 4
    call xa_mem
    ret

; cvtss2sd / cvtsd2ss xmm, xmm: fcvt between the s and d views
i_cvtss2sd:
    lea  r8, [rel f_cvt_s2d]
    jmp  xa_fcvt_sd
i_cvtsd2ss:
    lea  r8, [rel f_cvt_d2s]
xa_fcvt_sd:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  i_bad
    cmp  byte [r13 + OP_KIND], K_XMM
    jne  i_bad
    movzx eax, byte [r12 + OP_XMM]
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rax
    ARG  1, rdx
    mov  rcx, r8
    call xa_fmt
    ret

i_movups:
    KINDS
    cmp  al, K_XMM
    jne  .store
    cmp  cl, K_XMM
    je   .xx
    cmp  cl, K_MEM
    jne  i_bad
    movzx edx, byte [r12 + OP_XMM]
    mov  al, 'q'
    call xa_regname
    mov  r9, rax
    mov  rcx, r13
    xor  edx, edx
    mov  r8, 16
    call xa_mem
    ret
.xx:
    movzx eax, byte [r12 + OP_XMM]
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rax
    ARG  1, rdx
    lea  rcx, [rel f_vmov]
    call xa_fmt
    ret
.store:
    cmp  al, K_MEM
    jne  i_bad
    cmp  cl, K_XMM
    jne  i_bad
    movzx edx, byte [r13 + OP_XMM]
    mov  al, 'q'
    call xa_regname
    mov  r9, rax
    mov  rcx, r12
    mov  edx, 1
    mov  r8, 16
    call xa_mem
    ret

; scalar arithmetic: rdi = ARM name
i_addsd:
    lea  rdi, [rel o_fadd]
    jmp  xa_fscalar
i_subsd:
    lea  rdi, [rel o_fsub]
    jmp  xa_fscalar
i_mulsd:
    lea  rdi, [rel o_fmul]
    jmp  xa_fscalar
i_divsd:
    lea  rdi, [rel o_fdiv]
    jmp  xa_fscalar
i_sqrtsd:
    lea  rdi, [rel o_fsqrt]
    jmp  xa_fscalar
xa_fscalar:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  i_bad
    call xa_fsrc
    movzx edx, byte [r12 + OP_XMM]
    lea  rcx, [rel o_fsqrt]
    cmp  rdi, rcx
    je   .two
    ARG  0, rdi
    ARG  1, rdx
    ARG  2, rdx
    ARG  3, rax
    lea  rcx, [rel f_f3]
    call xa_fmt
    ret
.two:
    ARG  0, rdi
    ARG  1, rdx
    ARG  2, rax
    lea  rcx, [rel f_f2]
    call xa_fmt
    ret

; xa_fsrc() -> rax = number of the d register holding the second operand
; (d16 loaded from memory when it is memory)
xa_fsrc:
    cmp  byte [r13 + OP_KIND], K_XMM
    jne  .mem
    movzx eax, byte [r13 + OP_XMM]
    ret
.mem:
    cmp  byte [r13 + OP_KIND], K_MEM
    jne  .bad
    mov  rcx, r13
    xor  edx, edx
    mov  r8, 8
    lea  r9, [rel o_d16]
    call xa_mem
    mov  eax, 16
    ret
.bad:
    lea  rcx, [rel e_operand]
    call xa_fail
    xor  eax, eax
    ret

; packed: rdi = ARM name, two doubles at once
i_addpd:
    lea  rdi, [rel o_fadd]
    jmp  xa_fpacked
i_subpd:
    lea  rdi, [rel o_fsub]
    jmp  xa_fpacked
i_mulpd:
    lea  rdi, [rel o_fmul]
    jmp  xa_fpacked
i_divpd:
    lea  rdi, [rel o_fdiv]
    jmp  xa_fpacked
; four singles: the same with the .4s arrangement
i_addps:
    lea  rdi, [rel o_fadd]
    jmp  xa_fpacked4
i_subps:
    lea  rdi, [rel o_fsub]
    jmp  xa_fpacked4
i_mulps:
    lea  rdi, [rel o_fmul]
    jmp  xa_fpacked4
i_divps:
    lea  rdi, [rel o_fdiv]
    jmp  xa_fpacked4
xa_fpacked4:
    lea  rsi, [rel f_v3s]
    jmp  xa_fpacked_go
xa_fpacked:
    lea  rsi, [rel f_v3]
xa_fpacked_go:
    KINDS
    cmp  al, K_XMM
    jne  i_bad
    cmp  cl, K_XMM
    jne  i_bad
    movzx eax, byte [r12 + OP_XMM]
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rdi
    ARG  1, rax
    ARG  2, rax
    ARG  3, rdx
    mov  rcx, rsi
    call xa_fmt
    ret

; bitwise on the whole register: rdi = ARM name
i_xorps:
    lea  rdi, [rel o_eor]
    jmp  xa_fbits
i_andps:
    lea  rdi, [rel o_and]
    jmp  xa_fbits
i_orps:
    lea  rdi, [rel o_orr]
    jmp  xa_fbits
xa_fbits:
    KINDS
    cmp  al, K_XMM
    jne  i_bad
    cmp  cl, K_XMM
    jne  i_bad
    movzx eax, byte [r12 + OP_XMM]
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rdi
    ARG  1, rax
    ARG  2, rax
    ARG  3, rdx
    lea  rcx, [rel f_vb3]
    call xa_fmt
    ret

i_ucomisd:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  i_bad
    call xa_fsrc
    movzx edx, byte [r12 + OP_XMM]
    ARG  0, rdx
    ARG  1, rax
    lea  rcx, [rel f_fcmp]
    call xa_fmt
    mov  qword [rel xa_fk], F_FP
    mov  qword [rel xa_fpend], 0
    ret

i_cvtsi2sd:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  i_bad
    cmp  byte [r13 + OP_KIND], K_REG
    jne  i_bad
    mov  rcx, r13
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  byte [r13 + OP_RSIZE], 8
    je   .n
    mov  al, 'w'
    jmp  .n
.n:
    call xa_regname
    movzx edx, byte [r12 + OP_XMM]
    ARG  0, rdx
    ARG  1, rax
    lea  rcx, [rel f_scvtf]
    call xa_fmt
    ret

i_cvttsd2si:
    lea  rdi, [rel o_fcvtzs]
    jmp  xa_tofix
i_cvtsd2si:
    ; to the nearest, ties to even: the x86-64 default rounding
    lea  rdi, [rel o_fcvtns]
    jmp  xa_tofix
xa_tofix:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  i_bad
    cmp  byte [r13 + OP_KIND], K_XMM
    jne  i_bad
    mov  rcx, r12
    call xa_opr
    mov  rdx, rax
    mov  al, 'x'
    cmp  byte [r12 + OP_RSIZE], 8
    je   .n
    mov  al, 'w'
    jmp  .n
.n:
    call xa_regname
    movzx edx, byte [r13 + OP_XMM]
    ARG  0, rdi
    ARG  1, rax
    ARG  2, rdx
    lea  rcx, [rel f_fcvt]
    call xa_fmt
    ret

; ---- cache and ordering ------------------------------------------------------
i_prefetch:
    lea  rdi, [rel f_prfm]
    jmp  xa_cacheop
i_clflush:
    lea  rdi, [rel f_dc]
    jmp  xa_cacheop
xa_cacheop:
    cmp  byte [r12 + OP_KIND], K_MEM
    jne  i_bad
    mov  rcx, r12
    call xa_addr
    mov  rax, [rel xa_mo]
    test rax, rax
    jz   .b
    mov  rcx, 16
    mov  rdx, [rel xa_mb]
    mov  r8, rax
    lea  r9, [rel o_none]
    call xa_add_imm
    mov  qword [rel xa_mb], 16
    jmp  .b
.b:
    mov  rax, [rel xa_mb]
    ARG  0, rax
    mov  rcx, rdi
    call xa_fmt
    ret
i_nop:
    lea  rcx, [rel f_nop]
    call xa_fmt
    ret
i_mfence:
    lea  rcx, [rel f_dmb]
    call xa_fmt
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
