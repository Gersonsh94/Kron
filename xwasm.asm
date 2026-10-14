; ==============================================================================
; XWASM - lowers the x86-64 text the code generator writes to WebAssembly
;
; For the web, kronc generates the same Linux program it generates for Linux
; on x86-64, and this pass turns it into a .wasm module: every feature of the
; language, the runtime and the library included, reaches the browser the
; moment it works on Linux. It is the sibling of xarm, and reads the x86 text
; with xarm's reader.
;
; The x86-64 machine is kept exactly, so nothing above this pass changes:
;
;   registers   rax .. r15 are wasm globals 0..15 (i64); xmm0 .. xmm15 are
;               globals 16..31 (v128). A double is lane 0 of its v128.
;   memory      one linear memory. .data starts at 0x10000, .bss after it,
;               then an 8 MB stack; the host maps everything past that.
;   stack       rsp is an ordinary register: push and pop are 8 bytes in
;               memory, so every frame offset the generator computed holds.
;   addresses   code has addresses too: an instruction's address is its
;               number in the text. A call pushes the address after it, so
;               [rbp+8] is a return address as on x86, the failure trace
;               walks the same chain, and a function's address is the number
;               its table slot has: call rax is call_indirect through it.
;   functions   a label that is not local (no leading dot) in .text starts a
;               wasm function. Inside, the labels jumped to are the blocks of
;               a dispatch loop: loop, one block per label, br_table on the
;               block number in a local.
;   flags       cmp, test and the arithmetic keep what they compared in
;               locals; the jcc or setcc after them asks the question
;               directly. A condition always follows its flags in the text
;               the generator writes.
;   syscall     a call to the host's env.syscall(rax, rdi, rsi, rdx, r10, r8,
;               r9): the host answers as Linux would, and 1000 and up are
;               the browser's (the window, the canvas).
;
; xwasm_translate(rcx = x86 text, rdx = length, r8 = output, r9 = capacity)
;   -> rax = length of the module, or -1 on an error
; xwasm_error_line() / xwasm_error_text() / xwasm_error_insn(): as xarm's
; Windows x64 convention: rbx rsi rdi rbp r12-r15 are kept.
; ==============================================================================

bits 64
default rel

global xwasm_translate
global xwasm_error_line
global xwasm_error_text
global xwasm_error_insn

extern xa_read_line, xa_split, xa_parse_ops, xa_streq, xa_prefix, xa_skipb
extern xa_parse_num, xa_find_reg, xa_fail
extern xa_in, xa_in_end, xa_line_no, xa_err, xa_err_line, xa_err_msg
extern xa_err_insn, xa_line, xa_mn, xa_rest, xa_nops, xa_opt, xa_ops
extern parse_float

; operand record, as xarm writes it (32 bytes)
%define OP_KIND   0
%define OP_REG    1
%define OP_RSIZE  2
%define OP_XMM    3
%define OP_MSIZE  4
%define OP_SCALE  5
%define OP_BASE   6
%define OP_INDEX  7
%define OP_VAL    8
%define OP_REL    16
%define OP_TEXT   24

%define K_REG   1
%define K_XMM   2
%define K_IMM   3
%define K_MEM   4
%define K_LABEL 5

; who set the flags
%define FK_NONE 0
%define FK_SUB  1               ; cmp, sub: fa - fb
%define FK_RES  2               ; and or xor test inc dec neg: fr
%define FK_ADD  3               ; add: fr = fa + fb
%define FK_FP   4               ; ucomisd, comisd: fx ? fy

; the locals of every function
%define L_PC  0                 ; i32: the block to run
%define L_A   1                 ; i32: an address used twice
%define L_FA  2                 ; i64 x 6
%define L_FB  3
%define L_FR  4
%define L_T0  5
%define L_T1  6
%define L_T2  7
%define L_FX  8                 ; f64 x 2
%define L_FY  9

; label kinds
%define LK_NONE 0
%define LK_CODE 1
%define LK_DATA 2
%define LK_BSS  3

XW_DATA_BASE equ 0x10000
XW_STACK     equ 0x800000       ; 8 MB, as getrlimit says
XW_MAXLBL    equ 262144
XW_HASH      equ 65536
XW_NAMES     equ 8388608
XW_MAXFN     equ 65536
XW_BODY_MAX  equ 8388608
XW_CODE_MAX  equ 33554432
XW_DATA_MAX  equ 8388608
XW_ELEM_MAX  equ 2097152
XW_SECT_MAX  equ 4194304

%macro XW 2
    lea  rcx, [rel xa_mn]
    lea  rdx, [rel %1]
    call xa_streq
    test eax, eax
    jnz  %2
%endmacro

; one byte, then a run of bytes, into the function body
%macro OPC 1
    mov  al, %1
    call wb
%endmacro

section .bss
    xw_out       resq 1
    xw_out_cap   resq 1
    xw_pass      resq 1         ; 1 jump targets, 2 layout, 3 emit
    xw_sec       resq 1         ; 0 text, 1 data, 2 bss
    xw_addr      resq 1         ; instruction counter: a code address
    xw_dsize     resq 1         ; bytes of .data so far
    xw_bsize     resq 1         ; bytes of .bss so far
    xw_bss_base  resq 1
    xw_heap_base resq 1
    xw_fn        resq 1         ; current function, -1 none
    xw_blk       resq 1         ; current block in it
    xw_nfn       resq 1         ; functions found
    xw_fk        resq 1         ; who set the flags, while emitting
    xw_term      resq 1         ; the last instruction was jmp or ret
    xw_iff       resq 1         ; 1 inside an if: one more level to br out
    xw_start_fn  resq 1         ; function of _start
    xw_glob      resb 256       ; innermost non-local label, for scoping
    xw_qbuf      resb 512       ; a name with its scope
    xw_tmp       resb 64
    ; labels
    xw_names     resb XW_NAMES
    xw_names_n   resq 1
    xw_l_off     resd XW_MAXLBL
    xw_l_len     resd XW_MAXLBL
    xw_l_kind    resb XW_MAXLBL
    xw_l_tgt     resb XW_MAXLBL ; jumped to inside its function
    xw_l_fn      resd XW_MAXLBL
    xw_l_blk     resd XW_MAXLBL
    xw_l_val     resq XW_MAXLBL
    xw_l_next    resd XW_MAXLBL
    xw_l_n       resq 1
    xw_hash      resd XW_HASH
    ; functions
    xw_f_addr    resq XW_MAXFN  ; its code address: its table slot
    xw_f_nblk    resd XW_MAXFN
    ; output pieces
    xw_body      resb XW_BODY_MAX
    xw_body_n    resq 1
    xw_code      resb XW_CODE_MAX
    xw_code_n    resq 1
    xw_data      resb XW_DATA_MAX
    xw_elem      resb XW_ELEM_MAX
    xw_elem_n    resq 1
    xw_sect      resb XW_SECT_MAX
    xw_sect_n    resq 1
    xw_err_kind  resq 1
    xw_nfn_total resq 1         ; functions, as pass 2 counted them
    xw_addr_total resq 1        ; instructions: the table's size

section .data
    w_text     db "text", 0
    w_dot_text db ".text", 0
    w_dot_data db ".data", 0
    w_dot_bss  db ".bss", 0
    w_data     db "data", 0
    w_bss      db "bss", 0
    w_start    db "_start", 0
    w_rel      db "rel ", 0
    xe_form     db "no WebAssembly form for this instruction", 0
    xe_operand  db "operand WebAssembly cannot take here", 0
    xe_flags    db "condition with nothing setting the flags before it", 0
    xe_full     db "output buffer full", 0
    xe_label    db "label not defined", 0
    xe_many     db "too many labels or functions", 0
    xe_data     db "data directive not understood", 0
    xe_jump     db "jump to a label of another function", 0

    ; mnemonics
    wm_default  db "default", 0
    wm_bits     db "bits", 0
    wm_extern   db "extern", 0
    wm_global   db "global", 0
    wm_section  db "section", 0
    wm_db       db "db", 0
    wm_dw       db "dw", 0
    wm_dd       db "dd", 0
    wm_dq       db "dq", 0
    wm_resb     db "resb", 0
    wm_resw     db "resw", 0
    wm_resd     db "resd", 0
    wm_resq     db "resq", 0
    wm_mov      db "mov", 0
    wm_movzx    db "movzx", 0
    wm_movsx    db "movsx", 0
    wm_movsxd   db "movsxd", 0
    wm_lea      db "lea", 0
    wm_push     db "push", 0
    wm_pop      db "pop", 0
    wm_add      db "add", 0
    wm_sub      db "sub", 0
    wm_and      db "and", 0
    wm_or       db "or", 0
    wm_xor      db "xor", 0
    wm_inc      db "inc", 0
    wm_dec      db "dec", 0
    wm_neg      db "neg", 0
    wm_not      db "not", 0
    wm_cmp      db "cmp", 0
    wm_test     db "test", 0
    wm_imul     db "imul", 0
    wm_cqo      db "cqo", 0
    wm_idiv     db "idiv", 0
    wm_div      db "div", 0
    wm_shl      db "shl", 0
    wm_sal      db "sal", 0
    wm_shr      db "shr", 0
    wm_sar      db "sar", 0
    wm_rol      db "rol", 0
    wm_ror      db "ror", 0
    wm_xchg     db "xchg", 0
    wm_jmp      db "jmp", 0
    wm_call     db "call", 0
    wm_ret      db "ret", 0
    wm_syscall  db "syscall", 0
    wm_nop      db "nop", 0
    wm_pause    db "pause", 0
    wm_mfence   db "mfence", 0
    wm_prefetch db "prefetcht0", 0
    wm_clflush  db "clflush", 0
    wm_movsd    db "movsd", 0
    wm_movss    db "movss", 0
    wm_movq     db "movq", 0
    wm_movaps   db "movaps", 0
    wm_movups   db "movups", 0
    wm_movapd   db "movapd", 0
    wm_movupd   db "movupd", 0
    wm_addsd    db "addsd", 0
    wm_subsd    db "subsd", 0
    wm_mulsd    db "mulsd", 0
    wm_divsd    db "divsd", 0
    wm_sqrtsd   db "sqrtsd", 0
    wm_addpd    db "addpd", 0
    wm_subpd    db "subpd", 0
    wm_mulpd    db "mulpd", 0
    wm_divpd    db "divpd", 0
    wm_addps    db "addps", 0
    wm_subps    db "subps", 0
    wm_mulps    db "mulps", 0
    wm_divps    db "divps", 0
    wm_xorps    db "xorps", 0
    wm_xorpd    db "xorpd", 0
    wm_andps    db "andps", 0
    wm_andpd    db "andpd", 0
    wm_orpd     db "orpd", 0
    wm_orps     db "orps", 0
    wm_ucomisd  db "ucomisd", 0
    wm_comisd   db "comisd", 0
    wm_cvtsi2sd db "cvtsi2sd", 0
    wm_cvttsd2si db "cvttsd2si", 0
    wm_cvtsd2si db "cvtsd2si", 0
    wm_cvtss2sd db "cvtss2sd", 0
    wm_cvtsd2ss db "cvtsd2ss", 0
    wm_set      db "set", 0

    ; conditions: name (4 bytes), code
    ;   0 e  1 ne  2 l  3 ge  4 le  5 g  6 b  7 ae  8 be  9 a  10 s  11 ns
    w_conds:
    db "e",0,0,0, 0,  "z",0,0,0, 0,  "ne",0,0, 1,  "nz",0,0, 1
    db "l",0,0,0, 2,  "nge",0, 2,    "ge",0,0, 3,  "nl",0,0, 3
    db "le",0,0, 4,   "ng",0,0, 4,   "g",0,0,0, 5, "nle",0, 5
    db "b",0,0,0, 6,  "c",0,0,0, 6,  "nae",0, 6,   "ae",0,0, 7
    db "nb",0,0, 7,   "nc",0,0, 7,   "be",0,0, 8,  "na",0,0, 8
    db "a",0,0,0, 9,  "nbe",0, 9,    "s",0,0,0, 10, "ns",0,0, 11
    db 0

section .text

; ==============================================================================
; OUTPUT HELPERS
; ==============================================================================

; wb(al): one byte of the function body. Preserves every register.
wb:
    push rcx
    mov  rcx, [rel xw_body_n]
    cmp  rcx, XW_BODY_MAX - 16
    jae  .full
    push rdx
    lea  rdx, [rel xw_body]
    mov  [rdx + rcx], al
    pop  rdx
    inc  rcx
    mov  [rel xw_body_n], rcx
    pop  rcx
    ret
.full:
    pop  rcx
    push rcx
    lea  rcx, [rel xe_full]
    call xa_fail
    pop  rcx
    ret

; wuleb(rax): unsigned LEB128 into the body. Preserves every register.
wuleb:
    push rax
    push rcx
.l:
    mov  rcx, rax
    shr  rcx, 7
    test rcx, rcx
    jz   .last
    push rax
    and  al, 0x7F
    or   al, 0x80
    call wb
    pop  rax
    shr  rax, 7
    jmp  .l
.last:
    and  al, 0x7F
    call wb
    pop  rcx
    pop  rax
    ret

; wsleb(rax): signed LEB128 into the body. Preserves every register.
wsleb:
    push rax
    push rcx
    push rdx
.l:
    mov  rcx, rax
    and  ecx, 0x7F                   ; the low seven bits
    sar  rax, 7
    ; done when the rest is all sign: 0 with bit 6 clear, -1 with it set
    mov  edx, ecx
    and  edx, 0x40                   ; the sign bit of this group
    test rax, rax
    jnz  .notzero
    test edx, edx
    jz   .last
    jmp  .more
.notzero:
    cmp  rax, -1
    jne  .more
    test edx, edx
    jnz  .last
.more:
    mov  edx, ecx
    or   edx, 0x80
    push rax
    mov  al, dl
    call wb
    pop  rax
    jmp  .l
.last:
    mov  al, cl
    call wb
    pop  rdx
    pop  rcx
    pop  rax
    ret

; i64const(rax): i64.const value
w_i64const:
    push rax
    mov  al, 0x42
    call wb
    pop  rax
    call wsleb
    ret

; i32const(rax)
w_i32const:
    push rax
    mov  al, 0x41
    call wb
    pop  rax
    call wsleb
    ret

; w_gget(eax = global) / w_gset(eax = global)
w_gget:
    push rax
    mov  al, 0x23
    call wb
    pop  rax
    call wuleb
    ret
w_gset:
    push rax
    mov  al, 0x24
    call wb
    pop  rax
    call wuleb
    ret

; w_lget(eax = local) / w_lset / w_ltee
w_lget:
    push rax
    mov  al, 0x20
    call wb
    pop  rax
    call wuleb
    ret
w_lset:
    push rax
    mov  al, 0x21
    call wb
    pop  rax
    call wuleb
    ret
w_ltee:
    push rax
    mov  al, 0x22
    call wb
    pop  rax
    call wuleb
    ret

; w_mem(al = opcode): a load or store with memarg align 0, offset 0
w_mem:
    call wb
    xor  eax, eax
    call wb
    call wb
    ret

; w_simd(eax = SIMD opcode): 0xFD then the opcode as LEB
w_simd:
    push rax
    mov  al, 0xFD
    call wb
    pop  rax
    call wuleb
    ret

; w_simd_mem(eax = SIMD opcode): with memarg 0, 0
w_simd_mem:
    call w_simd
    push rax
    xor  eax, eax
    call wb
    call wb
    pop  rax
    ret

; ---- bytes into another buffer: rdi = base, rsi = pointer to its count ----

; ob(al): one byte at [rdi + [rsi]]
ob:
    push rcx
    mov  rcx, [rsi]
    mov  [rdi + rcx], al
    inc  rcx
    mov  [rsi], rcx
    pop  rcx
    ret

; obuleb(rax)
obuleb:
    push rax
    push rcx
.l:
    mov  rcx, rax
    shr  rcx, 7
    test rcx, rcx
    jz   .last
    push rax
    and  al, 0x7F
    or   al, 0x80
    call ob
    pop  rax
    shr  rax, 7
    jmp  .l
.last:
    and  al, 0x7F
    call ob
    pop  rcx
    pop  rax
    ret

; obsleb(rax)
obsleb:
    push rax
    push rcx
    push rdx
.l:
    mov  rcx, rax
    and  ecx, 0x7F
    sar  rax, 7
    mov  edx, ecx
    and  edx, 0x40
    test rax, rax
    jnz  .nz
    test edx, edx
    jz   .last
    jmp  .more
.nz:
    cmp  rax, -1
    jne  .more
    test edx, edx
    jnz  .last
.more:
    mov  edx, ecx
    or   edx, 0x80
    push rax
    mov  al, dl
    call ob
    pop  rax
    jmp  .l
.last:
    mov  al, cl
    call ob
    pop  rdx
    pop  rcx
    pop  rax
    ret

; obstr(rcx = zero-ended name): its length, then its bytes
obstr:
    push rcx
    push rdx
    xor  edx, edx
.len:
    cmp  byte [rcx + rdx], 0
    je   .have
    inc  edx
    jmp  .len
.have:
    mov  eax, edx
    call obuleb
    xor  edx, edx
.cp:
    mov  al, [rcx + rdx]
    test al, al
    jz   .done
    call ob
    inc  edx
    jmp  .cp
.done:
    pop  rdx
    pop  rcx
    ret

; ==============================================================================
; LABELS
; ==============================================================================

; xw_hash_of(rcx = name, rdx = length) -> eax = bucket
xw_hash_of:
    push rcx
    push rdx
    push rsi
    xor  eax, eax
.h:
    test rdx, rdx
    jz   .d
    mov  rsi, rax
    shl  rax, 5
    sub  rax, rsi
    movzx esi, byte [rcx]
    add  rax, rsi
    inc  rcx
    dec  rdx
    jmp  .h
.d:
    mov  rsi, rax
    shr  rsi, 16
    xor  rax, rsi
    and  eax, XW_HASH - 1
    pop  rsi
    pop  rdx
    pop  rcx
    ret

; xw_lfind(rcx = name, rdx = length) -> eax = label, or -1
xw_lfind:
    push rbx
    push rsi
    push rdi
    push r8
    push r9
    call xw_hash_of
    lea  rsi, [rel xw_hash]
    mov  ebx, [rsi + rax*4]
.l:
    test ebx, ebx
    jz   .nf
    dec  ebx
    lea  rsi, [rel xw_l_len]
    mov  eax, [rsi + rbx*4]
    cmp  rax, rdx
    jne  .next
    lea  rsi, [rel xw_l_off]
    mov  eax, [rsi + rbx*4]
    lea  rsi, [rel xw_names]
    add  rsi, rax
    xor  r8d, r8d
.c:
    cmp  r8, rdx
    jae  .found
    mov  al, [rsi + r8]
    cmp  al, [rcx + r8]
    jne  .next
    inc  r8
    jmp  .c
.next:
    lea  rsi, [rel xw_l_next]
    mov  ebx, [rsi + rbx*4]
    jmp  .l
.found:
    mov  eax, ebx
    jmp  .out
.nf:
    mov  eax, -1
.out:
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xw_lget(rcx = name, rdx = length) -> eax = label, made when it is new
xw_lget:
    push rbx
    push rsi
    push rdi
    call xw_lfind
    cmp  eax, -1
    jne  .out
    mov  rbx, [rel xw_l_n]
    cmp  rbx, XW_MAXLBL
    jae  .full
    mov  rax, [rel xw_names_n]
    add  rax, rdx
    cmp  rax, XW_NAMES
    jae  .full
    ; the name
    mov  rax, [rel xw_names_n]
    lea  rsi, [rel xw_l_off]
    mov  [rsi + rbx*4], eax
    lea  rsi, [rel xw_l_len]
    mov  [rsi + rbx*4], edx
    lea  rdi, [rel xw_names]
    add  rdi, rax
    xor  esi, esi
.cp:
    cmp  rsi, rdx
    jae  .cpd
    mov  al, [rcx + rsi]
    mov  [rdi + rsi], al
    inc  rsi
    jmp  .cp
.cpd:
    mov  rax, [rel xw_names_n]
    add  rax, rdx
    mov  [rel xw_names_n], rax
    ; a fresh entry
    xor  eax, eax
    lea  rsi, [rel xw_l_kind]
    mov  [rsi + rbx], al
    lea  rsi, [rel xw_l_tgt]
    mov  [rsi + rbx], al
    lea  rsi, [rel xw_l_val]
    mov  [rsi + rbx*8], rax
    mov  eax, -1
    lea  rsi, [rel xw_l_fn]
    mov  [rsi + rbx*4], eax
    lea  rsi, [rel xw_l_blk]
    mov  [rsi + rbx*4], eax
    ; into its bucket
    call xw_hash_of
    lea  rsi, [rel xw_hash]
    mov  edi, [rsi + rax*4]
    lea  r8, [rel xw_l_next]
    mov  [r8 + rbx*4], edi
    mov  edi, ebx
    inc  edi
    mov  [rsi + rax*4], edi
    inc  qword [rel xw_l_n]
    mov  eax, ebx
    jmp  .out
.full:
    lea  rcx, [rel xe_many]
    call xa_fail
    xor  eax, eax
.out:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xw_qual(rsi = name, rdx = length) -> rcx, rdx = the name with its scope:
; a name starting with '.' belongs to the last label that does not
xw_qual:
    cmp  byte [rsi], '.'
    je   .local
    mov  rcx, rsi
    ret
.local:
    push rax
    push rdi
    push r8
    lea  rdi, [rel xw_qbuf]
    xor  ecx, ecx
    lea  r8, [rel xw_glob]
.g:
    mov  al, [r8 + rcx]
    test al, al
    jz   .gd
    cmp  ecx, 250
    jae  .gd
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .g
.gd:
    xor  r8d, r8d
.lc:
    cmp  r8, rdx
    jae  .ld
    cmp  ecx, 500
    jae  .ld
    mov  al, [rsi + r8]
    mov  [rdi + rcx], al
    inc  ecx
    inc  r8
    jmp  .lc
.ld:
    mov  rdx, rcx
    lea  rcx, [rel xw_qbuf]
    pop  r8
    pop  rdi
    pop  rax
    ret

; xw_name_len(rsi = text) -> rdx = length of the name at its start: up to a
; blank, ',', '+', '-', ']', ':' or the end
xw_name_len:
    xor  edx, edx
.l:
    mov  al, [rsi + rdx]
    test al, al
    jz   .o
    cmp  al, ' '
    je   .o
    cmp  al, ','
    je   .o
    cmp  al, '+'
    je   .o
    cmp  al, '-'
    je   .o
    cmp  al, ']'
    je   .o
    cmp  al, ':'
    je   .o
    inc  edx
    jmp  .l
.o:
    ret

; xw_label_ref(rsi = name text) -> eax = its label (made if new), rdx =
; anything after the name: +N or -N, 0 otherwise
xw_label_ref:
    push rbx
    push rsi
    call xw_name_len
    mov  rbx, rdx
    push rsi
    call xw_qual
    call xw_lget
    pop  rsi
    add  rsi, rbx
    xor  edx, edx
    call xa_skipb
    cmp  byte [rsi], '+'
    je   .plus
    cmp  byte [rsi], '-'
    je   .minus
    jmp  .out
.plus:
    inc  rsi
    call xa_skipb
    push rax
    mov  rcx, rsi
    call xa_parse_num
    mov  rdx, rax
    pop  rax
    jmp  .out
.minus:
    inc  rsi
    call xa_skipb
    push rax
    mov  rcx, rsi
    call xa_parse_num
    neg  rax
    mov  rdx, rax
    pop  rax
.out:
    pop  rsi
    pop  rbx
    ret

; xw_lval(eax = label) -> rax = its value; a label never defined fails
xw_lval:
    push rcx
    mov  ecx, eax
    lea  rax, [rel xw_l_kind]
    movzx eax, byte [rax + rcx]
    test eax, eax
    jz   .undef
    cmp  eax, LK_BSS
    lea  rax, [rel xw_l_val]
    mov  rax, [rax + rcx*8]
    jne  .have
    add  rax, [rel xw_bss_base]      ; .bss labels count from its start
.have:
    pop  rcx
    ret
.undef:
    push rcx
    lea  rcx, [rel xe_label]
    call xa_fail
    pop  rcx
    xor  eax, eax
    pop  rcx
    ret

; ==============================================================================
; THE THREE PASSES
;   1  which local labels are jumped to: those become blocks
;   2  where everything goes: code addresses, functions, blocks, data
;   3  the module: function bodies and the data image
; ==============================================================================

xwasm_translate:
    push rbx
    push rsi
    push rdi
    push rbp
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 8
    mov  [rel xw_out], r8
    mov  [rel xw_out_cap], r9
    mov  [rel xa_in], rcx
    mov  rbp, rcx                    ; start of the text
    add  rcx, rdx
    mov  [rel xa_in_end], rcx
    mov  r15, rcx                    ; its end
    xor  eax, eax
    mov  [rel xa_err], rax
    mov  [rel xa_err_line], rax
    mov  byte [rel xa_err_insn], 0
    lea  rax, [rel xe_form]
    mov  [rel xa_err_msg], rax
    mov  qword [rel xw_l_n], 0
    mov  qword [rel xw_names_n], 0
    mov  qword [rel xw_start_fn], -1
    lea  rdi, [rel xw_hash]
    xor  ecx, ecx
    xor  eax, eax
.clr:
    mov  [rdi + rcx*4], eax
    inc  ecx
    cmp  ecx, XW_HASH
    jb   .clr
    mov  r12d, 1
.pass:
    mov  [rel xw_pass], r12
    mov  [rel xa_in], rbp
    mov  [rel xa_in_end], r15
    call xw_run_pass
    cmp  qword [rel xa_err], 0
    jne  .failed
    cmp  r12d, 2
    jne  .next
    call xw_layout                   ; where .bss, the stack and the heap go
    mov  rax, [rel xw_nfn]
    mov  [rel xw_nfn_total], rax
    mov  rax, [rel xw_addr]
    mov  [rel xw_addr_total], rax
.next:
    inc  r12d
    cmp  r12d, 3
    jbe  .pass
    cmp  qword [rel xa_err], 0
    jne  .failed
    call xw_module
    cmp  qword [rel xa_err], 0
    jne  .failed
    jmp  .out
.failed:
    mov  rax, -1
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

xwasm_error_line:
    mov  rax, [rel xa_err_line]
    ret
xwasm_error_text:
    mov  rax, [rel xa_err_msg]
    ret
xwasm_error_insn:
    lea  rax, [rel xa_err_insn]
    ret

; xw_run_pass(): every line once
xw_run_pass:
    push rbx
    xor  eax, eax
    mov  [rel xa_line_no], rax
    mov  [rel xw_sec], rax
    mov  [rel xw_addr], rax
    mov  [rel xw_dsize], rax
    mov  [rel xw_bsize], rax
    mov  [rel xw_nfn], rax
    mov  [rel xw_code_n], rax
    mov  [rel xw_elem_n], rax
    mov  byte [rel xw_glob], 0
    mov  qword [rel xw_fn], -1
    mov  qword [rel xw_fk], FK_NONE
.l:
    cmp  qword [rel xa_err], 0
    jne  .out
    call xa_read_line
    test eax, eax
    jz   .end
    call xw_line
    jmp  .l
.end:
    cmp  qword [rel xw_pass], 3
    jne  .out
    call xw_fn_close                 ; the last function
.out:
    pop  rbx
    ret

; xw_layout(): after pass 2. .bss after .data, the stack after .bss, the heap
; after the stack; the name the program gets as argv[0] at the end of .data.
xw_layout:
    mov  rax, [rel xw_dsize]
    add  rax, 16
    mov  [rel xw_dsize], rax         ; room for "kron" and its 0
    mov  rax, XW_DATA_BASE
    add  rax, [rel xw_dsize]
    add  rax, 15
    and  rax, -16
    mov  [rel xw_bss_base], rax
    add  rax, [rel xw_bsize]
    add  rax, 0xFFFF
    and  rax, -65536
    add  rax, XW_STACK
    mov  [rel xw_heap_base], rax     ; also the top of the stack
    ret

; ==============================================================================
; ONE LINE
; ==============================================================================

xw_line:
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
.word:
    mov  rbx, rsi
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
    mov  rcx, rsi
    sub  rcx, rbx                    ; length
    push rsi
    mov  rsi, rbx
    mov  rdx, rcx
    call xw_label
    pop  rsi
    inc  rsi
    call xa_skipb
    cmp  byte [rsi], 0
    je   .out
    jmp  .word
.word_end:
    ; the mnemonic, lowercased, into xa_mn
    mov  rcx, rsi
    sub  rcx, rbx
    cmp  rcx, 30
    jbe  .mlen
    mov  rcx, 30
.mlen:
    lea  rdi, [rel xa_mn]
    xor  edx, edx
.mn:
    cmp  rdx, rcx
    jae  .mnd
    mov  al, [rbx + rdx]
    cmp  al, 'A'
    jb   .mst
    cmp  al, 'Z'
    ja   .mst
    add  al, 32
.mst:
    mov  [rdi + rdx], al
    inc  rdx
    jmp  .mn
.mnd:
    mov  byte [rdi + rdx], 0
    call xa_skipb
    mov  [rel xa_rest], rsi
    XW wm_default, .out
    XW wm_bits, .out
    XW wm_extern, .out
    XW wm_global, .out
    XW wm_section, .section
    XW wm_db, .db
    XW wm_dw, .dw
    XW wm_dd, .dd
    XW wm_dq, .dq
    XW wm_resb, .resb
    XW wm_resw, .resw
    XW wm_resd, .resd
    XW wm_resq, .resq
    ; an instruction
    cmp  qword [rel xw_sec], 0
    jne  .out                        ; no code outside .text
    call xa_split
    call xa_parse_ops
    cmp  qword [rel xa_err], 0
    jne  .out
    mov  rax, [rel xw_pass]
    cmp  rax, 1
    je   .p1
    cmp  rax, 3
    je   .p3
    jmp  .count
.p1:
    call xw_targets
    jmp  .count
.p3:
    lea  r12, [rel xa_ops]
    lea  r13, [rel xa_ops + 32]
    lea  r14, [rel xa_ops + 64]
    call xw_insn
.count:
    inc  qword [rel xw_addr]
    jmp  .out
.section:
    mov  rsi, [rel xa_rest]
    mov  qword [rel xw_sec], 0
    mov  rcx, rsi
    lea  rdx, [rel w_dot_data]
    call xa_streq
    test eax, eax
    jnz  .sdata
    mov  rcx, rsi
    lea  rdx, [rel w_dot_bss]
    call xa_streq
    test eax, eax
    jnz  .sbss
    jmp  .out
.sdata:
    mov  qword [rel xw_sec], 1
    jmp  .out
.sbss:
    mov  qword [rel xw_sec], 2
    jmp  .out
.db:
    mov  ecx, 1
    jmp  .data
.dw:
    mov  ecx, 2
    jmp  .data
.dd:
    mov  ecx, 4
    jmp  .data
.dq:
    mov  ecx, 8
.data:
    call xw_items
    jmp  .out
.resb:
    mov  ecx, 1
    jmp  .res
.resw:
    mov  ecx, 2
    jmp  .res
.resd:
    mov  ecx, 4
    jmp  .res
.resq:
    mov  ecx, 8
.res:
    push rcx
    mov  rcx, [rel xa_rest]
    call xa_parse_num
    pop  rcx
    test edx, edx
    jz   .bad_data
    imul rax, rcx                    ; bytes
    cmp  qword [rel xw_sec], 2
    je   .res_bss
    ; zeros in .data
    mov  rdx, [rel xw_dsize]
    add  rdx, rax
    mov  [rel xw_dsize], rdx
    jmp  .out
.res_bss:
    mov  rdx, [rel xw_bsize]
    add  rdx, rax
    mov  [rel xw_bsize], rdx
    jmp  .out
.bad_data:
    lea  rcx, [rel xe_data]
    call xa_fail
.out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; xw_label(rsi = name, rdx = length)
xw_label:
    push rbx
    push r12
    push r13
    mov  r12, rsi
    mov  r13, rdx
    cmp  byte [rsi], '.'
    je   .scoped
    ; a label that is not local opens a new scope
    lea  rdi, [rel xw_glob]
    xor  ecx, ecx
.g:
    cmp  rcx, rdx
    jae  .gd
    cmp  ecx, 250
    jae  .gd
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .g
.gd:
    mov  byte [rdi + rcx], 0
.scoped:
    mov  rsi, r12
    mov  rdx, r13
    call xw_qual
    call xw_lget
    mov  ebx, eax                    ; the label
    mov  rax, [rel xw_pass]
    cmp  rax, 2
    je   .define
    cmp  rax, 3
    je   .emit
    jmp  .out
.define:
    mov  rax, [rel xw_sec]
    cmp  rax, 1
    je   .d_data
    cmp  rax, 2
    je   .d_bss
    ; code
    lea  rcx, [rel xw_l_kind]
    mov  dl, LK_CODE
    mov  [rcx + rbx], dl
    mov  rax, [rel xw_addr]
    lea  rcx, [rel xw_l_val]
    mov  [rcx + rbx*8], rax
    cmp  byte [r12], '.'
    je   .d_local
    ; a function
    mov  rax, [rel xw_nfn]
    cmp  rax, XW_MAXFN
    jae  .many
    mov  [rel xw_fn], rax
    lea  rcx, [rel xw_f_addr]
    mov  rdx, [rel xw_addr]
    mov  [rcx + rax*8], rdx
    lea  rcx, [rel xw_f_nblk]
    mov  edx, 1
    mov  [rcx + rax*4], edx
    lea  rcx, [rel xw_l_fn]
    mov  [rcx + rbx*4], eax
    lea  rcx, [rel xw_l_blk]
    xor  edx, edx
    mov  [rcx + rbx*4], edx
    inc  qword [rel xw_nfn]
    ; _start: where the module starts
    mov  rsi, r12
    mov  rdx, r13
    cmp  rdx, 6
    jne  .out
    cmp  dword [rsi], '_sta'
    jne  .out
    cmp  word [rsi + 4], 'rt'
    jne  .out
    mov  [rel xw_start_fn], rax
    jmp  .out
.d_local:
    mov  rax, [rel xw_fn]
    cmp  rax, -1
    je   .out
    lea  rcx, [rel xw_l_fn]
    mov  [rcx + rbx*4], eax
    lea  rcx, [rel xw_l_tgt]
    movzx edx, byte [rcx + rbx]
    test edx, edx
    jz   .out
    ; jumped to: a block of its own
    lea  rcx, [rel xw_f_nblk]
    mov  edx, [rcx + rax*4]
    lea  r8, [rel xw_l_blk]
    mov  [r8 + rbx*4], edx
    inc  edx
    mov  [rcx + rax*4], edx
    jmp  .out
.d_data:
    lea  rcx, [rel xw_l_kind]
    mov  dl, LK_DATA
    mov  [rcx + rbx], dl
    mov  rax, [rel xw_dsize]
    add  rax, XW_DATA_BASE
    lea  rcx, [rel xw_l_val]
    mov  [rcx + rbx*8], rax
    jmp  .out
.d_bss:
    lea  rcx, [rel xw_l_kind]
    mov  dl, LK_BSS
    mov  [rcx + rbx], dl
    mov  rax, [rel xw_bsize]
    lea  rcx, [rel xw_l_val]
    mov  [rcx + rbx*8], rax
    jmp  .out
.emit:
    cmp  qword [rel xw_sec], 0
    jne  .out
    cmp  byte [r12], '.'
    je   .e_local
    ; a new function: the one before it ends here
    call xw_fn_close
    call xw_fn_open
    jmp  .out
.e_local:
    lea  rcx, [rel xw_l_blk]
    mov  eax, [rcx + rbx*4]
    cmp  eax, 1
    jl   .out                        ; not jumped to: no new block
    ; the next block: the end of the block whose code comes now
    mov  [rel xw_blk], rax
    OPC  0x0B
    mov  qword [rel xw_fk], FK_NONE
    mov  qword [rel xw_term], 0
    jmp  .out
.many:
    lea  rcx, [rel xe_many]
    call xa_fail
.out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; xw_targets(): pass 1. A jump to a local label marks it.
xw_targets:
    push rbx
    lea  rcx, [rel xa_mn]
    cmp  byte [rcx], 'j'
    jne  .out
    lea  r8, [rel xa_ops]
    cmp  byte [r8 + OP_KIND], K_LABEL
    jne  .out
    mov  rsi, [r8 + OP_TEXT]
    cmp  byte [rsi], '.'
    jne  .out
    call xw_name_len
    call xw_qual
    call xw_lget
    lea  rcx, [rel xw_l_tgt]
    mov  dl, 1
    mov  [rcx + rax], dl
.out:
    pop  rbx
    ret

; ==============================================================================
; FUNCTIONS
; ==============================================================================

; xw_fn_open(): pass 3, at a label that is not local in .text
xw_fn_open:
    mov  rax, [rel xw_nfn]
    mov  [rel xw_fn], rax
    inc  qword [rel xw_nfn]
    mov  qword [rel xw_body_n], 0
    mov  qword [rel xw_blk], 0
    mov  qword [rel xw_term], 0
    mov  qword [rel xw_iff], 0
    mov  qword [rel xw_fk], FK_NONE
    ; locals: pc and an address (i32), six i64, two f64
    OPC  3
    OPC  2
    OPC  0x7F
    OPC  6
    OPC  0x7E
    OPC  2
    OPC  0x7C
    mov  rax, [rel xw_fn]
    lea  rcx, [rel xw_f_nblk]
    mov  ecx, [rcx + rax*4]
    cmp  ecx, 2
    jb   .flat
    ; loop, a block per label, br_table on pc
    OPC  0x03
    OPC  0x40
    push rcx
.blocks:
    OPC  0x02
    OPC  0x40
    dec  ecx
    jnz  .blocks
    pop  rcx
    xor  eax, eax
    call w_lget
    OPC  0x0E
    mov  eax, ecx
    call wuleb
    xor  edx, edx
.tab:
    mov  eax, edx
    call wuleb
    inc  edx
    cmp  edx, ecx
    jb   .tab
    xor  eax, eax
    call wuleb                       ; default: block 0
    OPC  0x0B                        ; the end of block 0: its code follows
.flat:
    ret

; xw_fn_close(): pass 3. Falling off the end goes on into the next function,
; as on x86; then the loop and the function end.
xw_fn_close:
    push rbx
    mov  rbx, [rel xw_fn]
    cmp  rbx, -1
    je   .out
    cmp  qword [rel xw_term], 0
    jne  .ended
    mov  rax, rbx
    inc  rax
    cmp  rax, [rel xw_nfn_total]
    jae  .nonext
    OPC  0x10                        ; call the next one
    mov  rax, rbx
    add  rax, 3                      ; +1 next, +2 past syscall and the start
    call wuleb
    OPC  0x0F
    jmp  .ended
.nonext:
    OPC  0x00                        ; unreachable
.ended:
    lea  rcx, [rel xw_f_nblk]
    mov  ecx, [rcx + rbx*4]
    cmp  ecx, 2
    jb   .noloop
    OPC  0x0B                        ; the loop
.noloop:
    OPC  0x0B                        ; the function
    ; size, then the body, into the code section
    lea  rdi, [rel xw_code]
    lea  rsi, [rel xw_code_n]
    mov  rax, [rel xw_body_n]
    call obuleb
    mov  rcx, [rel xw_body_n]
    mov  rdx, [rel xw_code_n]
    mov  rax, rdx
    add  rax, rcx
    cmp  rax, XW_CODE_MAX - 64
    jae  .full
    lea  r8, [rel xw_body]
    xor  r9d, r9d
.cp:
    cmp  r9, rcx
    jae  .cpd
    mov  al, [r8 + r9]
    mov  [rdi + rdx], al
    inc  rdx
    inc  r9
    jmp  .cp
.cpd:
    mov  [rel xw_code_n], rdx
    mov  qword [rel xw_fn], -1
    jmp  .out
.full:
    lea  rcx, [rel xe_full]
    call xa_fail
.out:
    pop  rbx
    ret

; ==============================================================================
; DATA
; ==============================================================================

; xw_items(ecx = bytes per item): db / dw / dd / dq. Pass 2 counts, pass 3
; writes the bytes, labels resolved.
xw_items:
    push rbx
    push r12
    push r13
    push r14
    mov  r12d, ecx                   ; size
    mov  r13, [rel xa_rest]          ; cursor
.item:
    mov  rsi, r13
    call xa_skipb
    mov  r13, rsi
    mov  al, [r13]
    test al, al
    jz   .out
    cmp  al, ','
    je   .comma
    cmp  al, 0x27
    je   .str
    cmp  al, 0x22
    je   .str
    ; a token up to the next ',' into xw_tmp, trimmed
    lea  rdi, [rel xw_tmp]
    xor  ecx, ecx
.tok:
    mov  al, [r13]
    test al, al
    jz   .tokd
    cmp  al, ','
    je   .tokd
    cmp  ecx, 60
    jae  .tskip
    mov  [rdi + rcx], al
    inc  ecx
.tskip:
    inc  r13
    jmp  .tok
.tokd:
    test ecx, ecx
    jz   .tz
    cmp  byte [rdi + rcx - 1], ' '
    jne  .tz
    dec  ecx
    jmp  .tokd
.tz:
    mov  byte [rdi + rcx], 0
    ; a real: dq with a '.' in a token that starts like a number
    cmp  r12d, 8
    jne  .notreal
    mov  al, [rdi]
    cmp  al, '-'
    je   .rscan
    cmp  al, '0'
    jb   .notreal
    cmp  al, '9'
    ja   .notreal
.rscan:
    xor  edx, edx
.rs:
    mov  al, [rdi + rdx]
    test al, al
    jz   .notreal
    cmp  al, '.'
    je   .real
    inc  edx
    jmp  .rs
.real:
    lea  rcx, [rel xw_tmp]
    call parse_float
    sub  rsp, 16
    movsd [rsp], xmm0
    mov  rax, [rsp]
    add  rsp, 16
    jmp  .value
.notreal:
    lea  rcx, [rel xw_tmp]
    call xa_parse_num
    test edx, edx
    jnz  .value
    ; a label, perhaps with +N
    xor  eax, eax
    cmp  qword [rel xw_pass], 3
    jne  .value
    lea  rsi, [rel xw_tmp]
    call xw_label_ref
    push rdx
    call xw_lval
    pop  rdx
    add  rax, rdx
.value:
    mov  ecx, r12d
    call xw_put_value
    jmp  .item
.comma:
    inc  r13
    jmp  .item
.str:
    mov  bl, al                      ; the quote
    inc  r13
.sc:
    mov  al, [r13]
    test al, al
    jz   .out
    inc  r13
    cmp  al, bl
    je   .item
    movzx eax, al
    mov  ecx, r12d
    call xw_put_value
    jmp  .sc
.out:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; xw_put_value(rax = value, ecx = bytes): at the end of .data (pass 3
; writes, both count). Nothing outside .data.
xw_put_value:
    cmp  qword [rel xw_sec], 1
    je   .data
    cmp  qword [rel xw_sec], 2
    jne  .o
    mov  rdx, [rel xw_bsize]
    add  rdx, rcx
    mov  [rel xw_bsize], rdx
.o:
    ret
.data:
    mov  rdx, [rel xw_dsize]
    cmp  qword [rel xw_pass], 3
    jne  .count
    push rcx
    push rdi
    lea  rdi, [rel xw_data]
    add  rdi, rdx
.w:
    mov  [rdi], al
    shr  rax, 8
    inc  rdi
    dec  ecx
    jnz  .w
    pop  rdi
    pop  rcx
.count:
    add  rdx, rcx
    cmp  rdx, XW_DATA_MAX - 64
    jae  .full
    mov  [rel xw_dsize], rdx
    ret
.full:
    lea  rcx, [rel xe_full]
    call xa_fail
    ret

; ==============================================================================
; OPERANDS INTO WASM
; ==============================================================================

; w_ld_op(esi = bytes, edx = 1 sign-extend) -> the load opcode in al
w_ld_op:
    test edx, edx
    jnz  .signed
    mov  al, 0x29
    cmp  esi, 8
    je   .o
    mov  al, 0x35
    cmp  esi, 4
    je   .o
    mov  al, 0x33
    cmp  esi, 2
    je   .o
    mov  al, 0x31
.o:
    ret
.signed:
    mov  al, 0x29
    cmp  esi, 8
    je   .o
    mov  al, 0x34
    cmp  esi, 4
    je   .o
    mov  al, 0x32
    cmp  esi, 2
    je   .o
    mov  al, 0x30
    ret

; w_store(esi = bytes): [i32 address, i64 value] are on the stack
w_store:
    mov  al, 0x37
    cmp  esi, 8
    je   .go
    mov  al, 0x3E
    cmp  esi, 4
    je   .go
    mov  al, 0x3D
    cmp  esi, 2
    je   .go
    mov  al, 0x3C
.go:
    call w_mem
    ret

; w_mask(esi = bytes): i64.and to the low bytes, nothing for 8
w_mask:
    cmp  esi, 8
    jae  .o
    push rax
    mov  rax, 0xFF
    cmp  esi, 1
    je   .k
    mov  rax, 0xFFFF
    cmp  esi, 2
    je   .k
    mov  rax, 0xFFFFFFFF
.k:
    call w_i64const
    OPC  0x83
    pop  rax
.o:
    ret

; w_addr64(rdi = memory operand): its address, as an i64
w_addr64:
    push rbx
    push r12
    mov  r12, rdi
    mov  rsi, [r12 + OP_REL]
    test rsi, rsi
    jz   .regs
    call xw_label_ref
    push rdx
    call xw_lval
    pop  rdx
    add  rax, rdx
    add  rax, [r12 + OP_VAL]
    call w_i64const
    jmp  .out
.regs:
    xor  ebx, ebx                    ; something on the stack yet
    movzx eax, byte [r12 + OP_BASE]
    cmp  eax, 0xFF
    je   .noba
    call w_gget
    mov  ebx, 1
.noba:
    movzx eax, byte [r12 + OP_INDEX]
    cmp  eax, 0xFF
    je   .noix
    call w_gget
    movzx eax, byte [r12 + OP_SCALE]
    cmp  eax, 1
    jbe  .noscale
    call w_i64const
    OPC  0x7E                        ; i64.mul
.noscale:
    test ebx, ebx
    jz   .ix_first
    OPC  0x7C                        ; i64.add
.ix_first:
    mov  ebx, 1
.noix:
    mov  rax, [r12 + OP_VAL]
    test ebx, ebx
    jz   .disp_only
    test rax, rax
    jz   .out
    call w_i64const
    OPC  0x7C
    jmp  .out
.disp_only:
    call w_i64const
.out:
    pop  r12
    pop  rbx
    ret

; w_addr32(rdi = memory operand): its address as the i32 memory takes
w_addr32:
    mov  rax, [rdi + OP_REL]
    test rax, rax
    jz   .regs
    ; a label: a constant
    push r12
    mov  r12, rdi
    mov  rsi, rax
    call xw_label_ref
    push rdx
    call xw_lval
    pop  rdx
    add  rax, rdx
    add  rax, [r12 + OP_VAL]
    call w_i32const
    pop  r12
    ret
.regs:
    call w_addr64
    OPC  0xA7                        ; i32.wrap_i64
    ret

; w_rd(rdi = operand, esi = bytes, edx = 1 to sign-extend): its value, an i64
w_rd:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, esi
    mov  ebx, edx
    movzx eax, byte [r12 + OP_KIND]
    cmp  eax, K_REG
    je   .reg
    cmp  eax, K_IMM
    je   .imm
    cmp  eax, K_MEM
    je   .mem
    cmp  eax, K_LABEL
    je   .lbl
    lea  rcx, [rel xe_operand]
    call xa_fail
    jmp  .out
.reg:
    movzx eax, byte [r12 + OP_REG]
    call w_gget
    test ebx, ebx
    jnz  .sreg
    mov  esi, r13d
    call w_mask
    jmp  .out
.sreg:
    ; sign-extend the low bytes: shift up, then arithmetically down
    cmp  r13d, 8
    jae  .out
    mov  eax, 64
    mov  ecx, r13d
    shl  ecx, 3
    sub  eax, ecx
    push rax
    call w_i64const
    OPC  0x86                        ; i64.shl
    pop  rax
    call w_i64const
    OPC  0x87                        ; i64.shr_s
    jmp  .out
.imm:
    mov  rax, [r12 + OP_VAL]
    call w_i64const
    jmp  .out
.lbl:
    mov  rsi, [r12 + OP_TEXT]
    call xw_label_ref
    push rdx
    call xw_lval
    pop  rdx
    add  rax, rdx
    call w_i64const
    jmp  .out
.mem:
    mov  rdi, r12
    call w_addr32
    mov  esi, r13d
    mov  edx, ebx
    call w_ld_op
    call w_mem
.out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; w_wreg(edi = register, esi = bytes): the i64 on the stack into it, as x86
; writes: 8 and 4 bytes replace (4 clears the top half), 1 and 2 merge
w_wreg:
    push rbx
    push r12
    mov  ebx, edi
    mov  r12d, esi
    cmp  esi, 4
    jb   .merge
    call w_mask
    mov  eax, ebx
    call w_gset
    jmp  .out
.merge:
    call w_mask
    mov  eax, L_T2
    call w_lset
    mov  eax, ebx
    call w_gget
    mov  rax, -256
    cmp  r12d, 1
    je   .m
    mov  rax, -65536
.m:
    call w_i64const
    OPC  0x83                        ; and
    mov  eax, L_T2
    call w_lget
    OPC  0x84                        ; or
    mov  eax, ebx
    call w_gset
.out:
    pop  r12
    pop  rbx
    ret

; w_opsize(rdi = operand, esi = default) -> eax = its size in bytes
w_opsize:
    movzx eax, byte [rdi + OP_KIND]
    cmp  eax, K_REG
    jne  .notreg
    movzx eax, byte [rdi + OP_RSIZE]
    ret
.notreg:
    movzx eax, byte [rdi + OP_MSIZE]
    test eax, eax
    jnz  .o
    mov  eax, esi
.o:
    ret

; w_push_t0(): rsp -= 8, then [rsp] = local T0
w_push_t0:
    mov  eax, 4
    call w_gget
    mov  rax, 8
    call w_i64const
    OPC  0x7D                        ; sub
    mov  eax, L_T1
    call w_ltee
    mov  eax, 4
    call w_gset
    mov  eax, L_T1
    call w_lget
    OPC  0xA7
    mov  eax, L_T0
    call w_lget
    mov  al, 0x37
    call w_mem
    ret

; w_push_ret(): a call's return address: the instruction after it
w_push_ret:
    mov  rax, [rel xw_addr]
    inc  rax
    call w_i64const
    mov  eax, L_T0
    call w_lset
    call w_push_t0
    ret

; ==============================================================================
; ONE INSTRUCTION. r12 r13 r14 = the three operand records.
; ==============================================================================

xw_insn:
    mov  qword [rel xw_term], 0
    XW wm_mov,      xi_mov
    XW wm_push,     xi_push
    XW wm_pop,      xi_pop
    XW wm_add,      xi_add
    XW wm_sub,      xi_sub
    XW wm_cmp,      xi_cmp
    XW wm_jmp,      xi_jmp
    XW wm_call,     xi_call
    XW wm_lea,      xi_lea
    XW wm_test,     xi_test
    XW wm_ret,      xi_ret
    XW wm_xor,      xi_xor
    XW wm_and,      xi_and
    XW wm_or,       xi_or
    XW wm_movzx,    xi_movzx
    XW wm_movsx,    xi_movsx
    XW wm_movsxd,   xi_movsx
    XW wm_imul,     xi_imul
    XW wm_inc,      xi_inc
    XW wm_dec,      xi_dec
    XW wm_neg,      xi_neg
    XW wm_not,      xi_not
    XW wm_cqo,      xi_cqo
    XW wm_idiv,     xi_idiv
    XW wm_div,      xi_div
    XW wm_shl,      xi_shl
    XW wm_sal,      xi_shl
    XW wm_shr,      xi_shr
    XW wm_sar,      xi_sar
    XW wm_rol,      xi_rol
    XW wm_ror,      xi_ror
    XW wm_xchg,     xi_xchg
    XW wm_syscall,  xi_syscall
    XW wm_nop,      xi_nothing
    XW wm_pause,    xi_nothing
    XW wm_mfence,   xi_nothing
    XW wm_prefetch, xi_nothing
    XW wm_clflush,  xi_nothing
    XW wm_movsd,    xi_movsd
    XW wm_movss,    xi_movss
    XW wm_movq,     xi_movq
    XW wm_movaps,   xi_movaps
    XW wm_movups,   xi_movaps
    XW wm_movapd,   xi_movaps
    XW wm_movupd,   xi_movaps
    XW wm_addsd,    xi_addsd
    XW wm_subsd,    xi_subsd
    XW wm_mulsd,    xi_mulsd
    XW wm_divsd,    xi_divsd
    XW wm_sqrtsd,   xi_sqrtsd
    XW wm_addpd,    xi_addpd
    XW wm_subpd,    xi_subpd
    XW wm_mulpd,    xi_mulpd
    XW wm_divpd,    xi_divpd
    XW wm_addps,    xi_addps
    XW wm_subps,    xi_subps
    XW wm_mulps,    xi_mulps
    XW wm_divps,    xi_divps
    XW wm_xorps,    xi_xorps
    XW wm_xorpd,    xi_xorps
    XW wm_andps,    xi_andps
    XW wm_andpd,    xi_andps
    XW wm_orpd,     xi_orps
    XW wm_orps,     xi_orps
    XW wm_ucomisd,  xi_ucomisd
    XW wm_comisd,   xi_ucomisd
    XW wm_cvtsi2sd, xi_cvtsi2sd
    XW wm_cvttsd2si, xi_cvttsd2si
    XW wm_cvtsd2si, xi_cvtsd2si
    XW wm_cvtss2sd, xi_cvtss2sd
    XW wm_cvtsd2ss, xi_cvtsd2ss
    ; jcc and setcc
    lea  rsi, [rel xa_mn]
    cmp  byte [rsi], 'j'
    je   xi_jcc
    lea  rcx, [rel xa_mn]
    lea  rdx, [rel wm_set]
    call xa_prefix
    test eax, eax
    jnz  xi_setcc
xi_bad:
    lea  rcx, [rel xe_form]
    call xa_fail
    ret
xi_badop:
    lea  rcx, [rel xe_operand]
    call xa_fail
    ret
xi_nothing:
    ret

; ---- moves ---------------------------------------------------------------------
xi_mov:
    movzx eax, byte [r12 + OP_KIND]
    cmp  eax, K_REG
    je   .toreg
    cmp  eax, K_MEM
    jne  xi_badop
    ; to memory: the width is the prefix's, or the source register's
    mov  rdi, r12
    mov  esi, 8
    call w_opsize
    movzx ecx, byte [r12 + OP_MSIZE]
    test ecx, ecx
    jnz  .msz
    cmp  byte [r13 + OP_KIND], K_REG
    jne  .msz
    movzx eax, byte [r13 + OP_RSIZE]
.msz:
    mov  ebx, eax
    mov  rdi, r12
    call w_addr32
    mov  rdi, r13
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    mov  esi, ebx
    call w_store
    ret
.toreg:
    cmp  byte [r13 + OP_KIND], K_XMM
    je   xi_badop
    movzx ebx, byte [r12 + OP_RSIZE]
    mov  rdi, r13
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    movzx edi, byte [r12 + OP_REG]
    mov  esi, ebx
    call w_wreg
    ret

xi_movzx:
    xor  edx, edx
    jmp  xi_mov_ext
xi_movsx:
    mov  edx, 1
xi_mov_ext:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    push rdx
    mov  rdi, r13
    mov  esi, 1
    call w_opsize
    mov  esi, eax
    pop  rdx
    mov  rdi, r13
    call w_rd
    movzx edi, byte [r12 + OP_REG]
    movzx esi, byte [r12 + OP_RSIZE]
    cmp  esi, 4
    jne  .w
    ; a 32-bit destination: the value is already below 2^32 when it was
    ; zero-extended; sign-extended it has to be cut to 32 bits
.w:
    call w_wreg
    ret

xi_lea:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    cmp  byte [r13 + OP_KIND], K_MEM
    jne  xi_badop
    mov  rdi, r13
    call w_addr64
    movzx edi, byte [r12 + OP_REG]
    mov  esi, 8
    call w_wreg
    ret

xi_push:
    mov  rdi, r12
    mov  esi, 8
    xor  edx, edx
    call w_rd
    mov  eax, L_T0
    call w_lset
    call w_push_t0
    ret

xi_pop:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    mov  eax, 4
    call w_gget
    OPC  0xA7
    mov  al, 0x29
    call w_mem
    mov  eax, L_T0
    call w_lset
    mov  eax, 4
    call w_gget
    mov  rax, 8
    call w_i64const
    OPC  0x7C
    mov  eax, 4
    call w_gset
    mov  eax, L_T0
    call w_lget
    movzx edi, byte [r12 + OP_REG]
    mov  esi, 8
    call w_wreg
    ret

xi_xchg:
    movzx eax, byte [r12 + OP_KIND]
    cmp  eax, K_MEM
    je   .mem_first
    movzx eax, byte [r13 + OP_KIND]
    cmp  eax, K_MEM
    je   .mem_second
    ; two registers
    movzx ebx, byte [r12 + OP_RSIZE]
    mov  rdi, r12
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    mov  eax, L_T0
    call w_lset
    mov  rdi, r13
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    movzx edi, byte [r12 + OP_REG]
    mov  esi, ebx
    call w_wreg
    mov  eax, L_T0
    call w_lget
    movzx edi, byte [r13 + OP_REG]
    mov  esi, ebx
    call w_wreg
    ret
.mem_second:
    mov  rax, r12
    mov  r12, r13
    mov  r13, rax
.mem_first:
    ; r12 = memory, r13 = register. The swap with memory is the lock of
    ; x86, and threads share the memory: an atomic exchange.
    movzx ebx, byte [r13 + OP_RSIZE]
    mov  rdi, r12
    call w_addr32
    mov  rdi, r13
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    OPC  0xFE
    mov  al, 0x42                    ; i64.atomic.rmw.xchg
    mov  ecx, 3
    cmp  ebx, 8
    je   .xop
    mov  al, 0x47                    ; i64.atomic.rmw32.xchg_u
    mov  ecx, 2
    cmp  ebx, 4
    je   .xop
    mov  al, 0x46                    ; rmw16
    mov  ecx, 1
    cmp  ebx, 2
    je   .xop
    mov  al, 0x45                    ; rmw8
    xor  ecx, ecx
.xop:
    call wb
    mov  eax, ecx
    call wuleb                       ; the alignment atomics require
    xor  eax, eax
    call wuleb
    movzx edi, byte [r13 + OP_REG]
    mov  esi, ebx
    call w_wreg
    ret

; ---- arithmetic ----------------------------------------------------------------
; rbx = the wasm op, r15 = who sets the flags
xi_add:
    mov  ebx, 0x7C
    mov  r15d, FK_ADD
    jmp  xi_arith
xi_sub:
    mov  ebx, 0x7D
    mov  r15d, FK_SUB
    jmp  xi_arith
xi_and:
    mov  ebx, 0x83
    mov  r15d, FK_RES
    jmp  xi_arith
xi_or:
    mov  ebx, 0x84
    mov  r15d, FK_RES
    jmp  xi_arith
xi_xor:
    mov  ebx, 0x85
    mov  r15d, FK_RES
xi_arith:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx edi, byte [r12 + OP_RSIZE]
    push rdi
    mov  rdi, r12
    mov  rsi, [rsp]
    xor  edx, edx
    call w_rd
    cmp  r15d, FK_RES
    je   .a1
    mov  eax, L_FA
    call w_ltee
.a1:
    mov  rdi, r13
    mov  rsi, [rsp]
    xor  edx, edx
    call w_rd
    cmp  r15d, FK_RES
    je   .a2
    mov  eax, L_FB
    call w_ltee
.a2:
    mov  al, bl
    call wb
    mov  eax, L_FR
    call w_ltee
    movzx edi, byte [r12 + OP_REG]
    pop  rsi
    call w_wreg
    mov  [rel xw_fk], r15
    ret

xi_cmp:
    mov  rdi, r12
    mov  esi, 8
    call w_opsize
    mov  ebx, eax
    cmp  byte [r12 + OP_KIND], K_MEM
    jne  .go
    cmp  byte [r13 + OP_KIND], K_REG
    jne  .go
    movzx ebx, byte [r13 + OP_RSIZE]
.go:
    mov  rdi, r12
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    mov  eax, L_FA
    call w_lset
    mov  rdi, r13
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    mov  eax, L_FB
    call w_lset
    mov  qword [rel xw_fk], FK_SUB
    ret

xi_test:
    mov  rdi, r12
    mov  esi, 8
    call w_opsize
    mov  ebx, eax
    mov  rdi, r12
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    mov  rdi, r13
    mov  esi, ebx
    xor  edx, edx
    call w_rd
    OPC  0x83
    mov  eax, L_FR
    call w_lset
    mov  qword [rel xw_fk], FK_RES
    ret

xi_inc:
    mov  ebx, 0x7C
    jmp  xi_incdec
xi_dec:
    mov  ebx, 0x7D
xi_incdec:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx eax, byte [r12 + OP_RSIZE]
    mov  r15d, eax
    mov  rdi, r12
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    mov  rax, 1
    call w_i64const
    mov  al, bl
    call wb
    mov  eax, L_FR
    call w_ltee
    movzx edi, byte [r12 + OP_REG]
    mov  esi, r15d
    call w_wreg
    mov  qword [rel xw_fk], FK_RES
    ret

xi_neg:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx eax, byte [r12 + OP_RSIZE]
    mov  r15d, eax
    xor  eax, eax
    call w_i64const
    mov  rdi, r12
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    OPC  0x7D
    mov  eax, L_FR
    call w_ltee
    movzx edi, byte [r12 + OP_REG]
    mov  esi, r15d
    call w_wreg
    mov  qword [rel xw_fk], FK_RES
    ret

xi_not:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx eax, byte [r12 + OP_RSIZE]
    mov  r15d, eax
    mov  rdi, r12
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    mov  rax, -1
    call w_i64const
    OPC  0x85
    movzx edi, byte [r12 + OP_REG]
    mov  esi, r15d
    call w_wreg
    ret

xi_imul:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx eax, byte [r12 + OP_RSIZE]
    mov  r15d, eax
    cmp  byte [r14 + OP_KIND], 0
    jne  .three
    mov  rdi, r12
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    mov  rdi, r13
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    jmp  .mul
.three:
    mov  rdi, r13
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    mov  rdi, r14
    mov  esi, r15d
    xor  edx, edx
    call w_rd
.mul:
    OPC  0x7E
    movzx edi, byte [r12 + OP_REG]
    mov  esi, r15d
    call w_wreg
    mov  qword [rel xw_fk], FK_NONE
    ret

xi_cqo:
    xor  eax, eax
    call w_gget
    mov  rax, 63
    call w_i64const
    OPC  0x87
    mov  eax, 2
    call w_gset
    ret

; idiv / div src: rax = rax / src, rdx = rax % src. The generator always
; extends rax into rdx first (cqo, or rdx zeroed), so the 128-bit dividend
; is rax's value.
xi_idiv:
    mov  ebx, 0x7F                   ; div_s, then rem_s = +2
    jmp  xi_divide
xi_div:
    mov  ebx, 0x80                   ; div_u, then rem_u = +2
xi_divide:
    mov  rdi, r12
    mov  esi, 8
    xor  edx, edx
    call w_rd
    mov  eax, L_T1
    call w_lset
    xor  eax, eax
    call w_gget
    mov  eax, L_T0
    call w_lset
    mov  eax, L_T0
    call w_lget
    mov  eax, L_T1
    call w_lget
    mov  al, bl
    call wb
    xor  eax, eax
    call w_gset
    mov  eax, L_T0
    call w_lget
    mov  eax, L_T1
    call w_lget
    mov  al, bl
    add  al, 2
    call wb
    mov  eax, 2
    call w_gset
    mov  qword [rel xw_fk], FK_NONE
    ret

xi_shl:
    mov  ebx, 0x86
    jmp  xi_shift
xi_shr:
    mov  ebx, 0x88
    jmp  xi_shift
xi_sar:
    mov  ebx, 0x87
    jmp  xi_shift
xi_rol:
    mov  ebx, 0x89
    jmp  xi_shift
xi_ror:
    mov  ebx, 0x8A
xi_shift:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx eax, byte [r12 + OP_RSIZE]
    mov  r15d, eax
    mov  rdi, r12
    mov  esi, r15d
    xor  edx, edx
    call w_rd
    mov  rdi, r13
    mov  esi, 8
    xor  edx, edx
    call w_rd                        ; an immediate, or cl as all of rcx
    cmp  byte [r13 + OP_KIND], K_REG
    jne  .op
    mov  rax, 63
    call w_i64const
    OPC  0x83
.op:
    mov  al, bl
    call wb
    movzx edi, byte [r12 + OP_REG]
    mov  esi, r15d
    call w_wreg
    mov  qword [rel xw_fk], FK_NONE
    ret

; ---- control -------------------------------------------------------------------
xi_ret:
    mov  eax, 4
    call w_gget
    mov  rax, 8
    call w_i64const
    OPC  0x7C
    mov  eax, 4
    call w_gset
    OPC  0x0F
    mov  qword [rel xw_term], 1
    ret

xi_syscall:
    xor  eax, eax                    ; rax rdi rsi rdx r10 r8 r9
    call w_gget
    mov  eax, 7
    call w_gget
    mov  eax, 6
    call w_gget
    mov  eax, 2
    call w_gget
    mov  eax, 10
    call w_gget
    mov  eax, 8
    call w_gget
    mov  eax, 9
    call w_gget
    OPC  0x10
    xor  eax, eax
    call wuleb                       ; function 0: env.syscall
    xor  eax, eax
    call w_gset
    mov  qword [rel xw_fk], FK_NONE
    ret

xi_call:
    movzx eax, byte [r12 + OP_KIND]
    cmp  eax, K_REG
    je   .reg
    cmp  eax, K_LABEL
    jne  xi_badop
    mov  rsi, [r12 + OP_TEXT]
    call xw_fn_of                    ; eax = wasm function
    cmp  eax, -1
    je   .out
    push rax
    call w_push_ret
    OPC  0x10
    pop  rax
    call wuleb
    jmp  .out
.reg:
    call w_push_ret
    movzx eax, byte [r12 + OP_REG]
    call w_gget
    OPC  0xA7
    OPC  0x11
    xor  eax, eax
    call wuleb                       ; type 0
    xor  eax, eax
    call wuleb                       ; table 0
.out:
    mov  qword [rel xw_fk], FK_NONE
    ret

xi_jmp:
    cmp  byte [r12 + OP_KIND], K_LABEL
    jne  xi_badop
    mov  rsi, [r12 + OP_TEXT]
    call w_goto
    mov  qword [rel xw_term], 1
    ret

xi_jcc:
    lea  rsi, [rel xa_mn + 1]
    call xw_condcode
    cmp  eax, -1
    je   xi_bad
    mov  ecx, eax
    call w_cond
    cmp  byte [r12 + OP_KIND], K_LABEL
    jne  xi_badop
    OPC  0x04
    OPC  0x40
    mov  qword [rel xw_iff], 1
    mov  rsi, [r12 + OP_TEXT]
    call w_goto
    mov  qword [rel xw_iff], 0
    OPC  0x0B
    ret

xi_setcc:
    lea  rsi, [rel xa_mn + 3]
    call xw_condcode
    cmp  eax, -1
    je   xi_bad
    mov  ecx, eax
    call w_cond
    OPC  0xAD                        ; i64.extend_i32_u
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    movzx edi, byte [r12 + OP_REG]
    mov  esi, 1
    call w_wreg
    ret

; xw_fn_of(rsi = label text) -> eax = the wasm function it starts, or -1
; after a failure
xw_fn_of:
    call xw_label_ref
    mov  ecx, eax
    lea  rdx, [rel xw_l_kind]
    movzx edx, byte [rdx + rcx]
    cmp  edx, LK_CODE
    jne  .undef
    lea  rdx, [rel xw_l_blk]
    mov  edx, [rdx + rcx*4]
    test edx, edx
    jnz  .notfn
    lea  rdx, [rel xw_l_fn]
    mov  eax, [rdx + rcx*4]
    add  eax, 2
    ret
.notfn:
    lea  rcx, [rel xe_jump]
    call xa_fail
    mov  eax, -1
    ret
.undef:
    lea  rcx, [rel xe_label]
    call xa_fail
    mov  eax, -1
    ret

; w_goto(rsi = label text): a jump. To a block of this function: pc, then
; back to the dispatch; to another function: call it, then return.
w_goto:
    push rbx
    cmp  byte [rsi], '.'
    jne  .function
    call xw_label_ref
    mov  ecx, eax
    lea  rdx, [rel xw_l_fn]
    mov  edx, [rdx + rcx*4]
    cmp  rdx, [rel xw_fn]
    jne  .other
    lea  rdx, [rel xw_l_blk]
    mov  eax, [rdx + rcx*4]
    cmp  eax, 0
    jl   .other
    call w_i32const
    mov  eax, L_PC
    call w_lset
    ; depth: the blocks still open after this one, then the loop
    mov  rax, [rel xw_fn]
    lea  rdx, [rel xw_f_nblk]
    mov  eax, [rdx + rax*4]
    dec  eax
    sub  rax, [rel xw_blk]
    add  rax, [rel xw_iff]
    push rax
    OPC  0x0C
    pop  rax
    call wuleb
    jmp  .out
.function:
    call xw_fn_of
    cmp  eax, -1
    je   .out
    push rax
    OPC  0x10
    pop  rax
    call wuleb
    OPC  0x0F
    jmp  .out
.other:
    lea  rcx, [rel xe_jump]
    call xa_fail
.out:
    pop  rbx
    ret

; xw_condcode(rsi = condition name) -> eax = its code, -1 when unknown
xw_condcode:
    lea  rdi, [rel w_conds]
.l:
    cmp  byte [rdi], 0
    je   .none
    xor  ecx, ecx
.c:
    mov  al, [rdi + rcx]
    cmp  al, [rsi + rcx]
    jne  .next
    test al, al
    jz   .yes
    inc  ecx
    cmp  ecx, 4
    jb   .c
    cmp  byte [rsi + 4], 0
    je   .yes
.next:
    add  rdi, 5
    jmp  .l
.yes:
    movzx eax, byte [rdi + 4]
    ret
.none:
    mov  eax, -1
    ret

; w_cond(ecx = condition code): an i32, 1 when the flags say so
w_cond:
    push rbx
    mov  ebx, ecx
    mov  rax, [rel xw_fk]
    cmp  eax, FK_SUB
    je   .sub
    cmp  eax, FK_RES
    je   .res
    cmp  eax, FK_ADD
    je   .add
    cmp  eax, FK_FP
    je   .fp
    lea  rcx, [rel xe_flags]
    call xa_fail
    jmp  .out
.sub:
    cmp  ebx, 10
    jae  .sub_sign
    mov  eax, L_FA
    call w_lget
    mov  eax, L_FB
    call w_lget
    lea  rax, [rel w_subops]
    mov  al, [rax + rbx]
    call wb
    jmp  .out
.sub_sign:
    mov  eax, L_FA
    call w_lget
    mov  eax, L_FB
    call w_lget
    OPC  0x7D
    jmp  .sign
.res:
    cmp  ebx, 6
    je   .false
    cmp  ebx, 7
    je   .true
    mov  eax, L_FR
    call w_lget
    jmp  .byres
.add:
    cmp  ebx, 6
    jb   .add_res
    cmp  ebx, 9
    ja   .add_res
    ; carry: the sum came out below the first operand
    mov  eax, L_FR
    call w_lget
    mov  eax, L_FA
    call w_lget
    OPC  0x54                        ; lt_u: carry
    cmp  ebx, 6
    je   .out
    cmp  ebx, 7
    je   .not
    ; be: carry or zero; a: neither
    mov  eax, L_FR
    call w_lget
    OPC  0x50
    OPC  0x72                        ; i32.or
    cmp  ebx, 8
    je   .out
    jmp  .not
.add_res:
    mov  eax, L_FR
    call w_lget
.byres:
    ; e ne l ge le g . . be a s ns, on a result against zero
    cmp  ebx, 0
    je   .eqz
    cmp  ebx, 8
    je   .eqz
    xor  eax, eax
    call w_i64const
    lea  rax, [rel w_resops]
    mov  al, [rax + rbx]
    call wb
    jmp  .out
.eqz:
    OPC  0x50
    jmp  .out
.sign:
    xor  eax, eax
    call w_i64const
    mov  al, 0x53                    ; lt_s
    cmp  ebx, 10
    je   .sgo
    mov  al, 0x59                    ; ge_s
.sgo:
    call wb
    jmp  .out
.fp:
    ; x86 after ucomisd: an unordered pair sets ZF, PF and CF together
    cmp  ebx, 0
    je   .fe
    cmp  ebx, 1
    je   .fe
    cmp  ebx, 6
    je   .fb
    cmp  ebx, 7
    je   .fb
    cmp  ebx, 8
    je   .fbe
    cmp  ebx, 9
    je   .fbe
    lea  rcx, [rel xe_flags]
    call xa_fail
    jmp  .out
.fe:
    mov  ecx, 0x61                   ; f64.eq
    jmp  .fcmp
.fb:
    mov  ecx, 0x63                   ; f64.lt
    jmp  .fcmp
.fbe:
    mov  ecx, 0x65                   ; f64.le
.fcmp:
    push rcx
    mov  eax, L_FX
    call w_lget
    mov  eax, L_FY
    call w_lget
    pop  rax
    call wb
    ; or unordered
    mov  eax, L_FX
    call w_lget
    mov  eax, L_FX
    call w_lget
    OPC  0x62
    mov  eax, L_FY
    call w_lget
    mov  eax, L_FY
    call w_lget
    OPC  0x62
    OPC  0x72
    OPC  0x72
    ; ne, ae, a are the opposite
    cmp  ebx, 1
    je   .not
    cmp  ebx, 7
    je   .not
    cmp  ebx, 9
    je   .not
    jmp  .out
.not:
    OPC  0x45                        ; i32.eqz
    jmp  .out
.false:
    xor  eax, eax
    call w_i32const
    jmp  .out
.true:
    mov  eax, 1
    call w_i32const
.out:
    pop  rbx
    ret

section .data
    ; (decimal: a seed kasm reads only the first hex value of a db list)
    ;          e   ne  l   ge  le  g   b   ae  be  a
    w_subops db 81, 82, 83, 89, 87, 85, 84, 90, 88, 86
    ; against zero, by code: e ne l ge le g b ae be a s ns
    w_resops db 81, 82, 83, 89, 87, 85, 0, 0, 81, 82, 83, 89
section .text

; ---- reals ---------------------------------------------------------------------

; w_xget(r = operand) / w_xset: an xmm register's v128
%macro XGET 1
    movzx eax, byte [%1 + OP_XMM]
    add  eax, 16
    call w_gget
%endmacro
%macro XSET 1
    movzx eax, byte [%1 + OP_XMM]
    add  eax, 16
    call w_gset
%endmacro

; lane0(ebx = 0 f64 / 1 f32): extract lane 0
w_lane0_get:
    mov  eax, 33                     ; f64x2.extract_lane
    test ebx, ebx
    jz   .g
    mov  eax, 31                     ; f32x4.extract_lane
.g:
    call w_simd
    OPC  0
    ret
w_lane0_set:
    mov  eax, 34                     ; f64x2.replace_lane
    test ebx, ebx
    jz   .g
    mov  eax, 32                     ; f32x4.replace_lane
.g:
    call w_simd
    OPC  0
    ret

xi_movss:
    mov  ebx, 1
    jmp  xi_movsx_x
xi_movsd:
    xor  ebx, ebx
xi_movsx_x:
    movzx eax, byte [r12 + OP_KIND]
    cmp  eax, K_MEM
    je   .store
    cmp  eax, K_XMM
    jne  xi_badop
    movzx eax, byte [r13 + OP_KIND]
    cmp  eax, K_MEM
    je   .load
    cmp  eax, K_XMM
    jne  xi_badop
    ; register to register: lane 0 only, the rest of the destination kept
    XGET r12
    XGET r13
    call w_lane0_get
    call w_lane0_set
    XSET r12
    ret
.load:
    mov  rdi, r13
    call w_addr32
    mov  eax, 93                     ; v128.load64_zero
    test ebx, ebx
    jz   .ld
    mov  eax, 92                     ; v128.load32_zero
.ld:
    call w_simd_mem
    XSET r12
    ret
.store:
    cmp  byte [r13 + OP_KIND], K_XMM
    jne  xi_badop
    mov  rdi, r12
    call w_addr32
    XGET r13
    mov  eax, 91                     ; v128.store64_lane
    test ebx, ebx
    jz   .st
    mov  eax, 90                     ; v128.store32_lane
.st:
    call w_simd_mem
    OPC  0                           ; lane 0
    ret

xi_movaps:
    movzx eax, byte [r12 + OP_KIND]
    cmp  eax, K_MEM
    je   .store
    cmp  eax, K_XMM
    jne  xi_badop
    movzx eax, byte [r13 + OP_KIND]
    cmp  eax, K_MEM
    je   .load
    cmp  eax, K_XMM
    jne  xi_badop
    XGET r13
    XSET r12
    ret
.load:
    mov  rdi, r13
    call w_addr32
    xor  eax, eax                    ; v128.load
    call w_simd_mem
    XSET r12
    ret
.store:
    mov  rdi, r12
    call w_addr32
    XGET r13
    mov  eax, 11                     ; v128.store
    call w_simd_mem
    ret

xi_movq:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  xi_badop
    ; the 64 bits into lane 0, the upper lane cleared
    call w_v128_zero
    mov  rdi, r13
    mov  esi, 8
    xor  edx, edx
    call w_rd
    mov  eax, 30                     ; i64x2.replace_lane
    call w_simd
    OPC  0
    XSET r12
    ret

; w_v128_zero(): v128.const of sixteen zero bytes
w_v128_zero:
    mov  eax, 12
    call w_simd
    push rcx
    mov  ecx, 16
.z:
    OPC  0
    dec  ecx
    jnz  .z
    pop  rcx
    ret

; scalar double arithmetic: ebx = the f64 op
xi_addsd:
    mov  r15d, 0xA0
    jmp  xi_fscalar
xi_subsd:
    mov  r15d, 0xA1
    jmp  xi_fscalar
xi_mulsd:
    mov  r15d, 0xA2
    jmp  xi_fscalar
xi_divsd:
    mov  r15d, 0xA3
xi_fscalar:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  xi_badop
    cmp  byte [r13 + OP_KIND], K_XMM
    jne  xi_badop
    xor  ebx, ebx
    XGET r12
    XGET r12
    call w_lane0_get
    XGET r13
    call w_lane0_get
    mov  al, r15b
    call wb
    call w_lane0_set
    XSET r12
    ret

xi_sqrtsd:
    xor  ebx, ebx
    XGET r12
    XGET r13
    call w_lane0_get
    OPC  0x9F
    call w_lane0_set
    XSET r12
    ret

; packed: r15 = the SIMD op
xi_addpd:
    mov  r15d, 240
    jmp  xi_packed
xi_subpd:
    mov  r15d, 241
    jmp  xi_packed
xi_mulpd:
    mov  r15d, 242
    jmp  xi_packed
xi_divpd:
    mov  r15d, 243
    jmp  xi_packed
xi_addps:
    mov  r15d, 228
    jmp  xi_packed
xi_subps:
    mov  r15d, 229
    jmp  xi_packed
xi_mulps:
    mov  r15d, 230
    jmp  xi_packed
xi_divps:
    mov  r15d, 231
    jmp  xi_packed
xi_xorps:
    mov  r15d, 81
    jmp  xi_packed
xi_andps:
    mov  r15d, 78
    jmp  xi_packed
xi_orps:
    mov  r15d, 80
xi_packed:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  xi_badop
    cmp  byte [r13 + OP_KIND], K_XMM
    jne  xi_badop
    XGET r12
    XGET r13
    mov  eax, r15d
    call w_simd
    XSET r12
    ret

xi_ucomisd:
    xor  ebx, ebx
    XGET r12
    call w_lane0_get
    mov  eax, L_FX
    call w_lset
    XGET r13
    call w_lane0_get
    mov  eax, L_FY
    call w_lset
    mov  qword [rel xw_fk], FK_FP
    ret

xi_cvtsi2sd:
    cmp  byte [r12 + OP_KIND], K_XMM
    jne  xi_badop
    xor  ebx, ebx
    XGET r12
    mov  rdi, r13
    mov  esi, 8
    xor  edx, edx
    call w_rd
    OPC  0xB9                        ; f64.convert_i64_s
    call w_lane0_set
    XSET r12
    ret

xi_cvttsd2si:
    xor  r15d, r15d
    jmp  xi_cvt_int
xi_cvtsd2si:
    mov  r15d, 1
xi_cvt_int:
    cmp  byte [r12 + OP_KIND], K_REG
    jne  xi_badop
    xor  ebx, ebx
    XGET r13
    call w_lane0_get
    test r15d, r15d
    jz   .t
    OPC  0x9E                        ; f64.nearest: x86 rounds to even
.t:
    OPC  0xFC
    OPC  6                           ; i64.trunc_sat_f64_s
    movzx edi, byte [r12 + OP_REG]
    mov  esi, 8
    call w_wreg
    ret

xi_cvtss2sd:
    XGET r12
    mov  ebx, 1
    XGET r13
    call w_lane0_get                 ; the single
    OPC  0xBB                        ; f64.promote_f32
    xor  ebx, ebx
    call w_lane0_set
    XSET r12
    ret

xi_cvtsd2ss:
    XGET r12
    xor  ebx, ebx
    XGET r13
    call w_lane0_get                 ; the double
    OPC  0xB6                        ; f32.demote_f64
    mov  ebx, 1
    call w_lane0_set
    XSET r12
    ret

; ==============================================================================
; THE MODULE
; ==============================================================================

; xw_sb(al) / xw_suleb(rax) / xw_ssleb(rax) / xw_sstr(rcx): into the section
; being built
xw_sb:
    push rdi
    push rsi
    lea  rdi, [rel xw_sect]
    lea  rsi, [rel xw_sect_n]
    call ob
    pop  rsi
    pop  rdi
    ret
xw_suleb:
    push rdi
    push rsi
    lea  rdi, [rel xw_sect]
    lea  rsi, [rel xw_sect_n]
    call obuleb
    pop  rsi
    pop  rdi
    ret
xw_ssleb:
    push rdi
    push rsi
    lea  rdi, [rel xw_sect]
    lea  rsi, [rel xw_sect_n]
    call obsleb
    pop  rsi
    pop  rdi
    ret
xw_sstr:
    push rdi
    push rsi
    lea  rdi, [rel xw_sect]
    lea  rsi, [rel xw_sect_n]
    call obstr
    pop  rsi
    pop  rdi
    ret

; xw_obytes(rsi = bytes, rcx = count): into the output
xw_obytes:
    push rdi
    push rdx
    mov  rdi, [rel xw_out]
    mov  rdx, [rel xw_on]
    mov  rax, rdx
    add  rax, rcx
    cmp  rax, [rel xw_out_cap]
    jae  .full
.c:
    test rcx, rcx
    jz   .d
    mov  al, [rsi]
    mov  [rdi + rdx], al
    inc  rsi
    inc  rdx
    dec  rcx
    jmp  .c
.d:
    mov  [rel xw_on], rdx
    pop  rdx
    pop  rdi
    ret
.full:
    push rcx
    lea  rcx, [rel xe_full]
    call xa_fail
    pop  rcx
    pop  rdx
    pop  rdi
    ret

; xw_flush(al = section id): the section built in xw_sect, with its size
xw_flush:
    push rbx
    mov  bl, al
    lea  rsi, [rel xw_tmp]
    mov  [rsi], bl
    mov  rcx, 1
    call xw_obytes
    ; the size as LEB, into xw_tmp, then out
    mov  rax, [rel xw_sect_n]
    lea  rdi, [rel xw_tmp]
    mov  qword [rel xw_tmp_n], 0
    lea  rsi, [rel xw_tmp_n]
    call obuleb
    lea  rsi, [rel xw_tmp]
    mov  rcx, [rel xw_tmp_n]
    call xw_obytes
    lea  rsi, [rel xw_sect]
    mov  rcx, [rel xw_sect_n]
    call xw_obytes
    mov  qword [rel xw_sect_n], 0
    pop  rbx
    ret

xw_module:
    push rbx
    push r12
    mov  qword [rel xw_on], 0
    mov  qword [rel xw_sect_n], 0
    cmp  qword [rel xw_start_fn], -1
    jne  .have_start
    lea  rcx, [rel xe_label]
    call xa_fail
    jmp  .out
.have_start:
    ; magic and version
    lea  rsi, [rel w_magic]
    mov  rcx, 8
    call xw_obytes
    ; types: 0 () -> (), 1 (i64 x 7) -> i64, 2 (i64) -> ()
    mov  eax, 3
    call xw_suleb
    mov  al, 0x60
    call xw_sb
    xor  eax, eax
    call xw_sb
    call xw_sb
    mov  al, 0x60
    call xw_sb
    mov  al, 7
    call xw_sb
    mov  ecx, 7
.t7:
    mov  al, 0x7E
    call xw_sb
    dec  ecx
    jnz  .t7
    mov  al, 1
    call xw_sb
    mov  al, 0x7E
    call xw_sb
    mov  al, 0x60
    call xw_sb
    mov  al, 1
    call xw_sb
    mov  al, 0x7E
    call xw_sb
    xor  eax, eax
    call xw_sb
    mov  al, 1
    call xw_flush
    ; imports: env.syscall, and env.memory: shared, so that the threads of
    ; the program, each an instance of the module in a worker, see one
    ; memory. From the heap's start up to 4 GB; the host may give less, and
    ; where there is no shared memory it clears the flag before compiling.
    mov  eax, 2
    call xw_suleb
    lea  rcx, [rel w_env]
    call xw_sstr
    lea  rcx, [rel w_syscall]
    call xw_sstr
    xor  eax, eax
    call xw_sb
    mov  eax, 1
    call xw_suleb
    lea  rcx, [rel w_env]
    call xw_sstr
    lea  rcx, [rel w_memory]
    call xw_sstr
    mov  al, 2
    call xw_sb
    mov  al, 3                       ; shared, with a maximum
    call xw_sb
    mov  rax, [rel xw_heap_base]
    shr  rax, 16
    add  rax, 16
    call xw_suleb
    mov  eax, 65536
    call xw_suleb
    mov  al, 2
    call xw_flush
    ; functions: the start, one per function found, the thread entry
    mov  rax, [rel xw_nfn_total]
    add  rax, 2
    call xw_suleb
    mov  rbx, [rel xw_nfn_total]
    inc  rbx
.ft:
    xor  eax, eax
    call xw_suleb
    dec  rbx
    jnz  .ft
    mov  eax, 2
    call xw_suleb
    mov  al, 3
    call xw_flush
    ; the table: a slot per code address
    mov  eax, 1
    call xw_suleb
    mov  al, 0x70
    call xw_sb
    mov  al, 1
    call xw_sb
    mov  rax, [rel xw_addr_total]
    inc  rax
    call xw_suleb
    mov  rax, [rel xw_addr_total]
    inc  rax
    call xw_suleb
    mov  al, 4
    call xw_flush
    ; globals: 16 integer registers, 16 xmm, the heap's start
    mov  eax, 33
    call xw_suleb
    mov  ebx, 16
.gi:
    mov  al, 0x7E
    call xw_sb
    mov  al, 1
    call xw_sb
    mov  al, 0x42
    call xw_sb
    xor  eax, eax
    call xw_sb
    mov  al, 0x0B
    call xw_sb
    dec  ebx
    jnz  .gi
    mov  ebx, 16
.gx:
    mov  al, 0x7B
    call xw_sb
    mov  al, 1
    call xw_sb
    mov  al, 0xFD
    call xw_sb
    mov  al, 12
    call xw_sb
    mov  ecx, 16
.gz:
    xor  eax, eax
    call xw_sb
    dec  ecx
    jnz  .gz
    mov  al, 0x0B
    call xw_sb
    dec  ebx
    jnz  .gx
    mov  al, 0x7E
    call xw_sb
    xor  eax, eax
    call xw_sb
    mov  al, 0x42
    call xw_sb
    mov  rax, [rel xw_heap_base]
    call xw_ssleb
    mov  al, 0x0B
    call xw_sb
    mov  al, 6
    call xw_flush
    ; exports
    mov  eax, 3
    call xw_suleb
    lea  rcx, [rel w_kthread]
    call xw_sstr
    xor  eax, eax
    call xw_sb
    mov  rax, [rel xw_nfn_total]
    add  rax, 2
    call xw_suleb
    lea  rcx, [rel w_kstart]
    call xw_sstr
    xor  eax, eax
    call xw_sb
    mov  eax, 1
    call xw_suleb
    lea  rcx, [rel w_kheap]
    call xw_sstr
    mov  al, 3
    call xw_sb
    mov  eax, 32
    call xw_suleb
    mov  al, 7
    call xw_flush
    ; elements: each function in the slot of its address
    mov  rax, [rel xw_nfn_total]
    call xw_suleb
    xor  ebx, ebx
.el:
    cmp  rbx, [rel xw_nfn_total]
    jae  .el_done
    xor  eax, eax
    call xw_sb
    mov  al, 0x41
    call xw_sb
    lea  rax, [rel xw_f_addr]
    mov  rax, [rax + rbx*8]
    call xw_ssleb
    mov  al, 0x0B
    call xw_sb
    mov  eax, 1
    call xw_suleb
    mov  rax, rbx
    add  rax, 2
    call xw_suleb
    inc  rbx
    jmp  .el
.el_done:
    mov  al, 9
    call xw_flush
    ; data count: one segment, passive, which kron_start copies in; the
    ; threads' instances leave memory as they find it
    mov  eax, 1
    call xw_suleb
    mov  al, 12
    call xw_flush
    ; the thread entry's body, kept aside: it goes after the others
    call xw_thread_body
    ; code: the start, the bodies pass 3 made, the thread entry
    mov  rax, [rel xw_nfn_total]
    add  rax, 2
    call xw_suleb
    call xw_start_body               ; into xw_body
    mov  rax, [rel xw_body_n]
    call xw_suleb
    xor  ebx, ebx
.cb:
    cmp  rbx, [rel xw_body_n]
    jae  .cbd
    lea  rax, [rel xw_body]
    mov  al, [rax + rbx]
    call xw_sb
    inc  rbx
    jmp  .cb
.cbd:
    ; the rest is long: the section's size, then the two parts
    mov  al, 10
    lea  rsi, [rel xw_tmp]
    mov  [rsi], al
    mov  rcx, 1
    call xw_obytes
    mov  rax, [rel xw_sect_n]
    add  rax, [rel xw_code_n]
    add  rax, [rel xw_tb_n]
    lea  rdi, [rel xw_tmp]
    mov  qword [rel xw_tmp_n], 0
    lea  rsi, [rel xw_tmp_n]
    call obuleb
    lea  rsi, [rel xw_tmp]
    mov  rcx, [rel xw_tmp_n]
    call xw_obytes
    lea  rsi, [rel xw_sect]
    mov  rcx, [rel xw_sect_n]
    call xw_obytes
    lea  rsi, [rel xw_code]
    mov  rcx, [rel xw_code_n]
    call xw_obytes
    lea  rsi, [rel xw_tb]
    mov  rcx, [rel xw_tb_n]
    call xw_obytes
    mov  qword [rel xw_sect_n], 0
    ; data: one passive segment; argv[0] in 16 bytes after it (pass 3
    ; counted .data without them; the layout made room)
    mov  rbx, [rel xw_dsize]
    lea  rdi, [rel xw_data]
    mov  eax, 'kron'
    mov  [rdi + rbx], eax
    xor  eax, eax
    mov  [rdi + rbx + 4], eax
    mov  [rdi + rbx + 8], rax
    add  rbx, 16
    mov  eax, 1
    call xw_suleb
    mov  al, 1                       ; passive
    call xw_sb
    mov  rax, rbx
    call xw_suleb
    mov  al, 11
    lea  rsi, [rel xw_tmp]
    mov  [rsi], al
    mov  rcx, 1
    call xw_obytes
    mov  rax, [rel xw_sect_n]
    add  rax, rbx
    lea  rdi, [rel xw_tmp]
    mov  qword [rel xw_tmp_n], 0
    lea  rsi, [rel xw_tmp_n]
    call obuleb
    lea  rsi, [rel xw_tmp]
    mov  rcx, [rel xw_tmp_n]
    call xw_obytes
    lea  rsi, [rel xw_sect]
    mov  rcx, [rel xw_sect_n]
    call xw_obytes
    lea  rsi, [rel xw_data]
    mov  rcx, rbx
    call xw_obytes
    mov  rax, [rel xw_on]
.out:
    pop  r12
    pop  rbx
    ret

; xw_start_body(): kron_start. The stack as Linux hands it to _start --
; argc 1, argv[0] "kron", no environment -- then _start, entered as a jump
; (no return address: it never returns).
xw_start_body:
    mov  qword [rel xw_body_n], 0
    xor  eax, eax
    call wb                          ; no locals
    ; .data into place: memory.init 0, then data.drop 0
    mov  rax, XW_DATA_BASE
    call w_i32const
    xor  eax, eax
    call w_i32const
    mov  rax, [rel xw_dsize]
    add  rax, 16
    call w_i32const
    OPC  0xFC
    OPC  8
    OPC  0
    OPC  0
    OPC  0xFC
    OPC  9
    OPC  0
    mov  rax, [rel xw_heap_base]
    sub  rax, 64
    call w_i64const
    mov  eax, 4
    call w_gset
    mov  rax, [rel xw_heap_base]
    sub  rax, 64
    call w_i32const
    mov  rax, 1
    call w_i64const
    mov  al, 0x37
    call w_mem
    mov  rax, [rel xw_heap_base]
    sub  rax, 56
    call w_i32const
    mov  rax, [rel xw_dsize]
    add  rax, XW_DATA_BASE
    call w_i64const
    mov  al, 0x37
    call w_mem
    OPC  0x10
    mov  rax, [rel xw_start_fn]
    add  rax, 2
    call wuleb
    OPC  0x0B
    ret

; xw_thread_body(): kron_thread(stack), into xw_tb with its size before it.
; What the child of clone does in __thread_start: its stack holds the
; function and the argument; pop both, make the room a call leaves, call.
; When the function returns, so does kron_thread, and the host ends the
; thread as Linux would: the thread id word cleared, its waiters woken.
xw_thread_body:
    push rbx
    mov  qword [rel xw_body_n], 0
    xor  eax, eax
    call wb                          ; no locals but the parameter
    OPC  0x20                        ; rsp = stack - 24
    xor  eax, eax
    call wuleb
    mov  rax, 24
    call w_i64const
    OPC  0x7D
    mov  eax, 4
    call w_gset
    mov  eax, 4                      ; rax = [stack]
    call w_gget
    mov  rax, 24
    call w_i64const
    OPC  0x7C
    OPC  0xA7
    mov  al, 0x29
    call w_mem
    xor  eax, eax
    call w_gset
    mov  eax, 4                      ; rcx = [stack + 8]
    call w_gget
    mov  rax, 32
    call w_i64const
    OPC  0x7C
    OPC  0xA7
    mov  al, 0x29
    call w_mem
    mov  eax, 1
    call w_gset
    mov  eax, 4                      ; the return address: none
    call w_gget
    OPC  0xA7
    xor  eax, eax
    call w_i64const
    mov  al, 0x37
    call w_mem
    xor  eax, eax                    ; call rax
    call w_gget
    OPC  0xA7
    OPC  0x11
    xor  eax, eax
    call wuleb
    xor  eax, eax
    call wuleb
    OPC  0x0B
    ; size, then the body
    mov  rax, [rel xw_body_n]
    lea  rdi, [rel xw_tb]
    mov  qword [rel xw_tb_n], 0
    lea  rsi, [rel xw_tb_n]
    call obuleb
    xor  ebx, ebx
.copy:
    cmp  rbx, [rel xw_body_n]
    jae  .done
    lea  rax, [rel xw_body]
    mov  al, [rax + rbx]
    lea  rdi, [rel xw_tb]
    lea  rsi, [rel xw_tb_n]
    call ob
    inc  rbx
    jmp  .copy
.done:
    pop  rbx
    ret

section .data
    w_kthread db "kron_thread", 0
    w_magic   db 0, 'a', 's', 'm', 1, 0, 0, 0
    w_env     db "env", 0
    w_syscall db "syscall", 0
    w_memory  db "memory", 0
    w_kstart  db "kron_start", 0
    w_kheap   db "kron_heap", 0
section .bss
    xw_on      resq 1
    xw_tmp_n   resq 1
    xw_tb      resb 256
    xw_tb_n    resq 1
section .text
