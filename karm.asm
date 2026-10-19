; ==============================================================================
; KARM - the ARM64 assembler for Kron
;
; Reads ARM64 assembly text and writes machine code, as kasm does for x86-64.
; Two passes: the first measures every line and records where each label
; lands, the second writes the instructions with every address known.
;
; Syntax: ARM's operand syntax, kasm's directives.
;   section .text / .data / .bss     global NAME     NAME equ EXPR
;   db / dw / dd / dq  ITEMS          resb / resw / resd / resq  N
;   times N db|dw|dd|dq V            align N
;   name:   .local:  (a local label belongs to the last name before it)
;   comments start with ';' or '//'. Immediates take '#' or not.
;
; Instructions (64-bit x and 32-bit w registers, d and s for reals):
;   mov movz movn movk  add sub adds subs cmp cmn neg  mul madd msub sdiv
;   udiv  and orr eor ands bic orn eon tst mvn  lsl lsr asr ror  cset csel
;   csinc csneg  sxtb sxth sxtw uxtb uxth  ldr str ldrb strb ldrh strh ldrsb
;   ldrsh ldrsw ldur stur ldp stp  ldxr stxr ldaxr stlxr  b bl b.cond cbz
;   cbnz br blr ret  adr adrp adrl  svc nop dmb  fmov fadd fsub fmul fdiv
;   fsqrt fneg fabs fcmp scvtf ucvtf fcvtzs fcvtzu fcvtns fcvt  prfm  dc civac
;   Vector registers: q for 128-bit loads and stores; vN.16b with mov, and,
;   orr, eor; vN.2d with fadd, fsub, fmul, fdiv. dq takes reals (dq 1.5).
;   adrl Xd, label is two instructions (adrp + add): any address in the image.
;
; The image is code, then data, then bss, at the base address set with
; karm_set_base; each section starts on a multiple of the alignment set with
; karm_set_align (16 unless told: macOS wants its 16 KB pages, so that the
; code and the data can be mapped with different rights). Every address is
; final in pass two. The places in .data where a dq holds an address are
; kept (karm_reloc_*): an image that the system may load anywhere (macOS)
; needs them moved with it.
; ==============================================================================

bits 64

extern parse_float                ; kasm: the text of a real -> xmm0
default rel

section .bss
    ka_code        resb 8388608       ; code; karm_build_image appends the data
    ka_data        resb 4194304
    ka_code_len    resq 1
    ka_data_len    resq 1
    ka_bss_len     resq 1
    ka_final_code    resq 1             ; section lengths at the end of pass one
    ka_final_data    resq 1
    ka_base        resq 1
    ka_pass        resq 1
    ka_salign      resq 1             ; sections start on multiples of this
    ka_rsign       resq 1             ; sign of the term being read: 1 or -1
    ka_nrel        resq 1             ; address terms in an expression, signed
    ka_rel_n       resq 1             ; dq of an address in .data: how many
    ka_rel_text    resq 1             ; ... and in .text, which nothing can move
    ka_rel_off     resq 262144        ; their offsets in .data
    ka_sec         resq 1             ; 0 text, 1 data, 2 bss
    ka_pos         resq 1
    ka_end         resq 1
    ka_src         resq 1
    ka_len         resq 1
    ka_line        resq 1
    ka_linebuf     resb 1024
    ka_word        resb 256
    ka_wordlen     resq 1
    ka_mnem        resb 64
    ka_rest        resq 1
    ka_ops         resb 1536          ; six operands of 256 bytes
    ka_nops        resq 1
    ka_last        resb 256           ; last non-local label
    ka_lastlen     resq 1
    ka_name        resb 512
    ka_namelen     resq 1
    ka_deflbl      resq 1
    ka_err_count   resq 1
    ka_err_lines   resd 64
    ka_err_kind    resd 64
    ka_err_mnem    resb 1024
    ka_movseq      resq 1
    ka_movsz       resb 1048576
    ka_unres       resq 1
    ka_ep          resq 1             ; expression cursor
    ka_everr       resq 1
    ka_tmp         resb 256
    ka_seq         resq 6             ; mov immediate: up to four words
    lb_count       resq 1
    lb_noff        resd 65536
    lb_nlen        resd 65536
    lb_sec         resd 65536
    lb_val         resq 65536
    lb_pool        resb 2097152
    lb_pool_len    resq 1
    lb_hash        resd 131072
    km_base        resq 1             ; memory operand, filled by ka_mem
    km_kind        resq 1             ; 0 [Xn], 1 [Xn, #imm], 2 [Xn, Rm{, ext}]
    km_imm         resq 1
    km_idx         resq 1
    km_idxw        resq 1             ; 1 when the index is a w register
    km_ext         resq 1             ; 0 lsl/uxtx, 1 sxtw, 2 uxtw, 3 sxtx
    km_amt         resq 1             ; shift amount, -1 when none
    km_pre         resq 1             ; '!' after the bracket

section .data
    ka_e_unknown   db "unknown instruction", 0
    ka_e_operand   db "operands this instruction does not take", 0
    ka_e_range     db "value or distance out of range", 0
    ka_e_undef     db "undefined symbol", 0
    ka_e_dup       db "label defined twice", 0
    ka_e_known     db "needs a value known on the first pass", 0
    ka_e_bitmask   db "immediate cannot be encoded as an ARM64 bit mask", 0
    ka_e_section   db "unknown section", 0
    ka_start_name  db "_start", 0

    ; mnemonics
    km_mov    db "mov", 0
    km_movz   db "movz", 0
    km_movn   db "movn", 0
    km_movk   db "movk", 0
    km_add    db "add", 0
    km_sub    db "sub", 0
    km_adds   db "adds", 0
    km_subs   db "subs", 0
    km_cmp    db "cmp", 0
    km_cmn    db "cmn", 0
    km_neg    db "neg", 0
    km_mul    db "mul", 0
    km_madd   db "madd", 0
    km_msub   db "msub", 0
    km_sdiv   db "sdiv", 0
    km_udiv   db "udiv", 0
    km_and    db "and", 0
    km_orr    db "orr", 0
    km_eor    db "eor", 0
    km_ands   db "ands", 0
    km_bic    db "bic", 0
    km_orn    db "orn", 0
    km_eon    db "eon", 0
    km_tst    db "tst", 0
    km_mvn    db "mvn", 0
    km_lsl    db "lsl", 0
    km_lsr    db "lsr", 0
    km_asr    db "asr", 0
    km_ror    db "ror", 0
    km_cset   db "cset", 0
    km_csel   db "csel", 0
    km_csinc  db "csinc", 0
    km_csneg  db "csneg", 0
    km_sxtb   db "sxtb", 0
    km_sxth   db "sxth", 0
    km_sxtw   db "sxtw", 0
    km_uxtb   db "uxtb", 0
    km_uxth   db "uxth", 0
    km_ldr    db "ldr", 0
    km_str    db "str", 0
    km_ldrb   db "ldrb", 0
    km_strb   db "strb", 0
    km_ldrh   db "ldrh", 0
    km_strh   db "strh", 0
    km_ldrsb  db "ldrsb", 0
    km_ldrsh  db "ldrsh", 0
    km_ldrsw  db "ldrsw", 0
    km_ldur   db "ldur", 0
    km_stur   db "stur", 0
    km_ldurb  db "ldurb", 0
    km_sturb  db "sturb", 0
    km_ldurh  db "ldurh", 0
    km_sturh  db "sturh", 0
    km_ldp    db "ldp", 0
    km_stp    db "stp", 0
    km_ldxr   db "ldxr", 0
    km_stxr   db "stxr", 0
    km_ldaxr  db "ldaxr", 0
    km_stlxr  db "stlxr", 0
    km_b      db "b", 0
    km_bl     db "bl", 0
    km_cbz    db "cbz", 0
    km_cbnz   db "cbnz", 0
    km_br     db "br", 0
    km_blr    db "blr", 0
    km_ret    db "ret", 0
    km_adr    db "adr", 0
    km_adrp   db "adrp", 0
    km_adrl   db "adrl", 0
    km_svc    db "svc", 0
    km_nop    db "nop", 0
    km_dmb    db "dmb", 0
    km_fmov   db "fmov", 0
    km_fadd   db "fadd", 0
    km_fsub   db "fsub", 0
    km_fmul   db "fmul", 0
    km_fdiv   db "fdiv", 0
    km_fsqrt  db "fsqrt", 0
    km_fneg   db "fneg", 0
    km_fabs   db "fabs", 0
    km_fcmp   db "fcmp", 0
    km_scvtf  db "scvtf", 0
    km_ucvtf  db "ucvtf", 0
    km_fcvtzs db "fcvtzs", 0
    km_fcvtzu db "fcvtzu", 0
    km_fcvt   db "fcvt", 0
    km_fcvtns db "fcvtns", 0
    km_prfm   db "prfm", 0
    km_dc     db "dc", 0
    ks_pldl1keep db "pldl1keep", 0
    ks_civac  db "civac", 0
    ; directives
    kd_section db "section", 0
    kd_global  db "global", 0
    kd_extern  db "extern", 0
    kd_align   db "align", 0
    kd_db      db "db", 0
    kd_dw      db "dw", 0
    kd_dd      db "dd", 0
    kd_dq      db "dq", 0
    kd_resb    db "resb", 0
    kd_resw    db "resw", 0
    kd_resd    db "resd", 0
    kd_resq    db "resq", 0
    kd_equ     db "equ", 0
    kd_times   db "times", 0
    ks_text    db ".text", 0
    ks_data    db ".data", 0
    ks_bss     db ".bss", 0
    ; condition names, two letters each, in encoding order (hs = cs, lo = cc)
    ka_conds   db "eqnecsccmiplvsvchilsgeltgtlealnv"

section .text

global karm_init
global karm_set_base
global karm_assemble
global karm_build_image
global karm_get_code
global karm_get_size
global karm_get_bss_size
global karm_get_entry
global karm_had_error
global karm_get_error_count
global karm_get_error_line_at
global karm_get_error_mnem
global karm_get_error_text
global karm_set_align, karm_get_code_len, karm_get_data_len, karm_label
global karm_get_data_off
global karm_reloc_count, karm_reloc_at, karm_reloc_text

; mnemonic dispatch: compare ka_mnem with a name, jump on a match
%macro KM_IS 2
    lea  rcx, [rel ka_mnem]
    lea  rdx, [rel %1]
    call ka_streq
    test rax, rax
    jnz  %2
%endmacro

; ==============================================================================
; PUBLIC INTERFACE (Windows x64 convention: rcx, rdx; rbx rsi rdi r12-r15 kept)
; ==============================================================================

karm_init:
    push rdi
    mov  qword [rel ka_base], 0x400080
    mov  qword [rel ka_salign], 16
    mov  qword [rel ka_err_count], 0
    call ka_reset_labels
    pop  rdi
    ret

; karm_set_base(rcx = address of the first byte of the image in memory)
karm_set_base:
    mov  [rel ka_base], rcx
    ret

; karm_set_align(rcx = a power of two): where .data and .bss start
karm_set_align:
    mov  [rel ka_salign], rcx
    ret

; ka_align(rdx) -> rdx rounded up to the section alignment
ka_align:
    push rax
    mov  rax, [rel ka_salign]
    dec  rax
    add  rdx, rax
    not  rax
    and  rdx, rax
    pop  rax
    ret

; ka_align_code(rdx = the length of the code) -> rdx = where .data starts in
; the image: the first address on a section boundary in MEMORY. With a base
; on a boundary -- every executable -- that is the length rounded up; a
; library's image starts 512 bytes into its first page, and its .data has
; to start on a page of its own all the same.
ka_align_code:
    push rax
    push rcx
    mov  rax, [rel ka_salign]
    dec  rax
    mov  rcx, [rel ka_base]
    and  rcx, rax
    add  rdx, rcx
    add  rdx, rax
    not  rax
    and  rdx, rax
    sub  rdx, rcx
    pop  rcx
    pop  rax
    ret

; karm_get_data_off() -> rax = where .data starts, from the image's start
karm_get_data_off:
    push rdx
    mov  rdx, [rel ka_code_len]
    call ka_align_code
    mov  rax, rdx
    pop  rdx
    ret

karm_get_code_len:
    mov  rax, [rel ka_code_len]
    ret
karm_get_data_len:
    mov  rax, [rel ka_data_len]
    ret

; karm_label(rcx = name, 0-terminated) -> rax = its address, -1 when unknown
karm_label:
    push rsi
    push rdi
    mov  rsi, rcx
    xor  ecx, ecx
.len:
    cmp  byte [rsi + rcx], 0
    je   .have
    inc  rcx
    jmp  .len
.have:
    call ka_find_exact
    cmp  rax, -1
    je   .out
    call ka_label_addr
.out:
    pop  rdi
    pop  rsi
    ret

karm_reloc_count:
    mov  rax, [rel ka_rel_n]
    ret
; karm_reloc_at(rcx = index) -> rax = offset in .data of a dq holding an address
karm_reloc_at:
    lea  rax, [rel ka_rel_off]
    mov  rax, [rax + rcx*8]
    ret
karm_reloc_text:
    mov  rax, [rel ka_rel_text]
    ret

; karm_assemble(rcx = text, rdx = length) -> rax = 1 when it assembled
karm_assemble:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    mov  [rel ka_src], rcx
    mov  [rel ka_len], rdx
    mov  qword [rel ka_err_count], 0
    call ka_reset_labels
    mov  qword [rel ka_final_code], 0
    mov  qword [rel ka_final_data], 0
    mov  qword [rel ka_pass], 1
    call ka_run_pass
    mov  rax, [rel ka_code_len]
    mov  [rel ka_final_code], rax
    mov  rax, [rel ka_data_len]
    mov  [rel ka_final_data], rax
    mov  qword [rel ka_pass], 2
    mov  qword [rel ka_rel_n], 0
    mov  qword [rel ka_rel_text], 0
    call ka_run_pass
    xor  eax, eax
    cmp  qword [rel ka_err_count], 0
    jne  .out
    mov  eax, 1
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

; karm_build_image() -> rax = length of code + padding + data, in ka_code
karm_build_image:
    push rsi
    push rdi
    mov  rdx, [rel ka_code_len]
    call ka_align_code
    mov  rax, rdx
    mov  rdi, rax
    mov  rcx, [rel ka_code_len]
    jmp  .pad
.pad:
    cmp  rcx, rdi
    jae  .padded
    lea  rdx, [rel ka_code]
    mov  byte [rdx + rcx], 0
    inc  rcx
    jmp  .pad
.padded:
    lea  rsi, [rel ka_data]
    lea  rdx, [rel ka_code]
    add  rdx, rdi
    xor  ecx, ecx
    jmp  .copy
.copy:
    cmp  rcx, [rel ka_data_len]
    jae  .copied
    mov  al, [rsi + rcx]
    mov  [rdx + rcx], al
    inc  rcx
    jmp  .copy
.copied:
    mov  rax, rdi
    add  rax, [rel ka_data_len]
    pop  rdi
    pop  rsi
    ret

karm_get_code:
    lea  rax, [rel ka_code]
    ret

karm_get_size:
    mov  rax, [rel ka_code_len]
    ret

karm_get_bss_size:
    mov  rax, [rel ka_bss_len]
    ret

; karm_get_entry() -> rax = address of _start, 0 when there is none
karm_get_entry:
    push rsi
    lea  rsi, [rel ka_start_name]
    mov  rcx, 6
    call ka_find_exact
    cmp  rax, -1
    je   .none
    call ka_label_addr
    pop  rsi
    ret
.none:
    xor  eax, eax
    pop  rsi
    ret

karm_had_error:
    mov  rax, [rel ka_err_count]
    ret

karm_get_error_count:
    mov  rax, [rel ka_err_count]
    ret

; karm_get_error_line_at(rcx = index) -> rax = line
karm_get_error_line_at:
    lea  rax, [rel ka_err_lines]
    mov  eax, [rax + rcx*4]
    ret

; karm_get_error_mnem(rcx = index) -> rax = the mnemonic of that line
karm_get_error_mnem:
    lea  rax, [rel ka_err_mnem]
    shl  rcx, 4
    add  rax, rcx
    ret

; karm_get_error_text(rcx = index) -> rax = what went wrong
karm_get_error_text:
    lea  rax, [rel ka_err_kind]
    mov  eax, [rax + rcx*4]
    cmp  eax, 1
    je   .k1
    cmp  eax, 2
    je   .k2
    cmp  eax, 3
    je   .k3
    cmp  eax, 4
    je   .k4
    cmp  eax, 5
    je   .k5
    cmp  eax, 6
    je   .k6
    cmp  eax, 7
    je   .k7
    lea  rax, [rel ka_e_section]
    ret
.k1:
    lea  rax, [rel ka_e_unknown]
    ret
.k2:
    lea  rax, [rel ka_e_operand]
    ret
.k3:
    lea  rax, [rel ka_e_range]
    ret
.k4:
    lea  rax, [rel ka_e_undef]
    ret
.k5:
    lea  rax, [rel ka_e_dup]
    ret
.k6:
    lea  rax, [rel ka_e_known]
    ret
.k7:
    lea  rax, [rel ka_e_bitmask]
    ret

; ==============================================================================
; PASSES AND LINES
; ==============================================================================

ka_run_pass:
    mov  qword [rel ka_code_len], 0
    mov  qword [rel ka_data_len], 0
    mov  qword [rel ka_bss_len], 0
    mov  qword [rel ka_sec], 0
    mov  qword [rel ka_line], 0
    mov  qword [rel ka_movseq], 0
    mov  qword [rel ka_lastlen], 0
    mov  byte [rel ka_last], 0
    mov  rax, [rel ka_src]
    mov  [rel ka_pos], rax
    add  rax, [rel ka_len]
    mov  [rel ka_end], rax
    jmp  .next
.next:
    call ka_read_line
    test rax, rax
    jz   .done
    call ka_do_line
    jmp  .next
.done:
    ret

; ka_read_line() -> rax = 0 at the end of the text. Copies one line into
; ka_linebuf without its comment (';' or '//' outside quotes) or its '\r'.
ka_read_line:
    push rsi
    push rdi
    mov  rsi, [rel ka_pos]
    cmp  rsi, [rel ka_end]
    jae  .eof
    inc  qword [rel ka_line]
    lea  rdi, [rel ka_linebuf]
    xor  ecx, ecx                    ; bytes copied
    xor  edx, edx                    ; open quote, 0 when outside
    jmp  .ch
.ch:
    cmp  rsi, [rel ka_end]
    jae  .eol
    mov  al, [rsi]
    cmp  al, 10
    je   .eol_nl
    cmp  al, 13
    je   .skipc
    test dl, dl
    jnz  .inq
    cmp  al, ';'
    je   .comment
    cmp  al, '/'
    jne  .notcom
    mov  r8, rsi
    inc  r8
    cmp  r8, [rel ka_end]
    jae  .notcom
    cmp  byte [r8], '/'
    je   .comment
    jmp  .notcom
.notcom:
    cmp  al, 0x27
    je   .openq
    cmp  al, 0x22
    je   .openq
    jmp  .store
.openq:
    mov  dl, al
    jmp  .store
.inq:
    cmp  al, dl
    jne  .store
    xor  edx, edx
    jmp  .store
.store:
    cmp  ecx, 1000
    jae  .skipc
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .skipc
.skipc:
    inc  rsi
    jmp  .ch
.comment:
    ; drop the rest of the line
    cmp  rsi, [rel ka_end]
    jae  .eol
    cmp  byte [rsi], 10
    je   .eol_nl
    inc  rsi
    jmp  .comment
.eol_nl:
    inc  rsi
    jmp  .eol
.eol:
    mov  byte [rdi + rcx], 0
    mov  [rel ka_pos], rsi
    mov  eax, 1
    pop  rdi
    pop  rsi
    ret
.eof:
    xor  eax, eax
    pop  rdi
    pop  rsi
    ret

; ka_do_line(): one line -- label, then instruction or directive
ka_do_line:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    mov  qword [rel ka_deflbl], -1
    lea  rsi, [rel ka_linebuf]
    call ka_skipb
    cmp  byte [rsi], 0
    je   .out
    call ka_getword
    call ka_word_to_mnem
    cmp  byte [rsi], ':'
    jne  .nocolon
    call ka_define_label
    inc  rsi
    call ka_skipb
    cmp  byte [rsi], 0
    je   .out
    call ka_getword
    jmp  .mnem
.nocolon:
    ; NASM style: 'name db ...' is a label without its colon
    push rsi
    call ka_skipb
    call ka_peek_datadir
    pop  rsi
    test rax, rax
    jz   .mnem
    call ka_define_label
    call ka_skipb
    call ka_getword
    jmp  .mnem
.mnem:
    ; the word becomes the mnemonic
    lea  rdi, [rel ka_mnem]
    lea  rdx, [rel ka_word]
    xor  ecx, ecx
    jmp  .cpm
.cpm:
    mov  al, [rdx + rcx]
    mov  [rdi + rcx], al
    test al, al
    jz   .cpm_done
    inc  ecx
    cmp  ecx, 60
    jb   .cpm
    mov  byte [rdi + rcx], 0
    jmp  .cpm_done
.cpm_done:
    call ka_skipb
    mov  [rel ka_rest], rsi
    call ka_split
    call ka_dispatch
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

; ka_word_to_mnem(): until the mnemonic is known, errors name the first word
ka_word_to_mnem:
    push rsi
    push rdi
    lea  rsi, [rel ka_word]
    lea  rdi, [rel ka_mnem]
    xor  ecx, ecx
    jmp  .l
.l:
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    test al, al
    jz   .d
    inc  ecx
    cmp  ecx, 60
    jb   .l
    mov  byte [rdi + rcx], 0
    jmp  .d
.d:
    pop  rdi
    pop  rsi
    ret

; ka_skipb(rsi) -> rsi past blanks and tabs
ka_skipb:
    cmp  byte [rsi], ' '
    je   .a
    cmp  byte [rsi], 9
    je   .a
    ret
.a:
    inc  rsi
    jmp  ka_skipb

; ka_getword(rsi) -> ka_word holds the word, lower-cased; rsi past it.
; A word ends at a blank, a tab, ':' or the end of the line.
ka_getword:
    lea  rdi, [rel ka_word]
    xor  ecx, ecx
    jmp  .l
.l:
    mov  al, [rsi]
    test al, al
    jz   .e
    cmp  al, ' '
    je   .e
    cmp  al, 9
    je   .e
    cmp  al, ':'
    je   .e
    cmp  ecx, 250
    jae  .skip
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .skip
.skip:
    inc  rsi
    jmp  .l
.e:
    mov  byte [rdi + rcx], 0
    mov  [rel ka_wordlen], rcx
    ret

; ka_peek_datadir(rsi) -> rax = 1 when the next word is a data directive
ka_peek_datadir:
    push rsi
    lea  rdi, [rel ka_tmp]
    xor  ecx, ecx
    jmp  .l
.l:
    mov  al, [rsi]
    test al, al
    jz   .e
    cmp  al, ' '
    je   .e
    cmp  al, 9
    je   .e
    cmp  ecx, 16
    jae  .no
    mov  [rdi + rcx], al
    inc  ecx
    inc  rsi
    jmp  .l
.e:
    mov  byte [rdi + rcx], 0
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_db]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_dw]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_dd]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_dq]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_resb]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_resw]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_resd]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_resq]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_equ]
    call ka_streq
    test rax, rax
    jnz  .yes
    lea  rcx, [rel ka_tmp]
    lea  rdx, [rel kd_times]
    call ka_streq
    test rax, rax
    jnz  .yes
    jmp  .no
.no:
    xor  eax, eax
    pop  rsi
    ret
.yes:
    mov  eax, 1
    pop  rsi
    ret

; ka_streq(rcx, rdx) -> rax = 1 when the two zero-terminated strings match
ka_streq:
    push rsi
    xor  esi, esi
    jmp  .l
.l:
    movzx eax, byte [rcx + rsi]
    movzx r8d, byte [rdx + rsi]
    cmp  rax, r8
    jne  .no
    test rax, rax
    jz   .yes
    inc  rsi
    jmp  .l
.no:
    xor  eax, eax
    pop  rsi
    ret
.yes:
    mov  eax, 1
    pop  rsi
    ret

; ka_split(rsi = operand text) -> ka_ops[0..5], ka_nops. Commas split
; operands, except inside brackets or quotes; each operand is trimmed.
ka_split:
    push rsi
    push rdi
    push rbx
    ; every operand starts empty: a missing one must not read the last line's
    lea  rdi, [rel ka_ops]
    mov  byte [rdi], 0
    mov  byte [rdi + 256], 0
    mov  byte [rdi + 512], 0
    mov  byte [rdi + 768], 0
    mov  byte [rdi + 1024], 0
    mov  byte [rdi + 1280], 0
    mov  qword [rel ka_nops], 0
    xor  ebx, ebx                    ; operand index
    call ka_skipb
    cmp  byte [rsi], 0
    je   .out
    jmp  .start
.start:
    cmp  ebx, 6
    jae  .too_many
    mov  rdi, rbx
    shl  rdi, 8
    lea  rax, [rel ka_ops]
    add  rdi, rax
    xor  ecx, ecx                    ; length
    xor  edx, edx                    ; dl = quote, dh unused
    xor  r8d, r8d                    ; bracket depth
    call ka_skipb
    jmp  .ch
.ch:
    mov  al, [rsi]
    test al, al
    jz   .end_all
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
    test r8, r8
    jnz  .put
    ; end of this operand
    call .finish
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
    inc  r8
    jmp  .put
.close:
    dec  r8
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
.end_all:
    call .finish
    inc  ebx
    jmp  .out
.too_many:
    ; more than six operands: no instruction takes that many, so ka_need
    ; refuses it instead of the extra ones being dropped
    mov  ebx, 7
    jmp  .out
.out:
    mov  [rel ka_nops], rbx
    pop  rbx
    pop  rdi
    pop  rsi
    ret
; .finish: terminate the operand at rdi, trimming trailing blanks
.finish:
    jmp  .fin_l
.fin_l:
    test ecx, ecx
    jz   .fin_d
    mov  al, [rdi + rcx - 1]
    cmp  al, ' '
    je   .fin_t
    cmp  al, 9
    je   .fin_t
    jmp  .fin_d
.fin_t:
    dec  ecx
    jmp  .fin_l
.fin_d:
    mov  byte [rdi + rcx], 0
    ret

; ka_op(ecx = index) -> rsi = operand text
ka_op:
    mov  rsi, rcx
    shl  rsi, 8
    lea  rax, [rel ka_ops]
    add  rsi, rax
    ret

; ka_err(ecx = kind): recorded in pass two (duplicate labels in pass one)
ka_err:
    push rsi
    push rdi
    mov  rax, [rel ka_err_count]
    cmp  rax, 64
    jae  .out
    lea  rdx, [rel ka_err_kind]
    mov  [rdx + rax*4], ecx
    mov  rcx, [rel ka_line]
    lea  rdx, [rel ka_err_lines]
    mov  [rdx + rax*4], ecx
    ; the mnemonic, 15 characters at most
    mov  rdi, rax
    shl  rdi, 4
    lea  rdx, [rel ka_err_mnem]
    add  rdi, rdx
    lea  rsi, [rel ka_mnem]
    xor  ecx, ecx
    jmp  .cp
.cp:
    mov  dl, [rsi + rcx]
    mov  [rdi + rcx], dl
    test dl, dl
    jz   .cpd
    inc  ecx
    cmp  ecx, 15
    jb   .cp
    mov  byte [rdi + rcx], 0
    jmp  .cpd
.cpd:
    inc  rax
    mov  [rel ka_err_count], rax
    jmp  .out
.out:
    pop  rdi
    pop  rsi
    ret

; ka_err2(ecx = kind): an error, but only on pass two
ka_err2:
    cmp  qword [rel ka_pass], 2
    jne  .no
    jmp  ka_err
.no:
    ret

; ==============================================================================
; LABELS
; ==============================================================================

ka_reset_labels:
    push rdi
    mov  qword [rel lb_count], 0
    mov  qword [rel lb_pool_len], 0
    lea  rdi, [rel lb_hash]
    xor  eax, eax
    mov  rcx, 524288
    rep  stosb
    pop  rdi
    ret

; ka_hash(rsi = name, rcx = length) -> eax = slot
ka_hash:
    push rsi
    push rcx
    mov  eax, 2166136261
    jmp  .l
.l:
    test rcx, rcx
    jz   .d
    movzx edx, byte [rsi]
    xor  rax, rdx
    imul rax, rax, 16777619
    shl  rax, 32
    shr  rax, 32
    inc  rsi
    dec  rcx
    jmp  .l
.d:
    and  eax, 131071
    pop  rcx
    pop  rsi
    ret

; ka_find_exact(rsi = name, rcx = length) -> rax = index, -1 when absent
ka_find_exact:
    push rbx
    push rdi
    push r8
    push r9
    call ka_hash
    mov  ebx, eax
    jmp  .probe
.probe:
    lea  rdx, [rel lb_hash]
    mov  eax, [rdx + rbx*4]
    test eax, eax
    jz   .absent
    dec  eax
    ; compare the name
    lea  rdx, [rel lb_nlen]
    mov  r8d, [rdx + rax*4]
    cmp  r8, rcx
    jne  .next
    lea  rdx, [rel lb_noff]
    mov  r8d, [rdx + rax*4]
    lea  rdi, [rel lb_pool]
    add  rdi, r8
    xor  r9d, r9d
    jmp  .cmp
.cmp:
    cmp  r9, rcx
    jae  .found
    movzx edx, byte [rsi + r9]
    movzx r8d, byte [rdi + r9]
    cmp  rdx, r8
    jne  .next
    inc  r9
    jmp  .cmp
.next:
    inc  ebx
    and  ebx, 131071
    jmp  .probe
.found:
    pop  r9
    pop  r8
    pop  rdi
    pop  rbx
    ret
.absent:
    mov  rax, -1
    pop  r9
    pop  r8
    pop  rdi
    pop  rbx
    ret

; ka_add_label(rsi = name, rcx = length) -> rax = new index
ka_add_label:
    push rbx
    push rdi
    push r8
    mov  rax, [rel lb_count]
    cmp  rax, 65535
    jae  .full
    mov  r8, rax
    ; name into the pool
    mov  rdx, [rel lb_pool_len]
    lea  rbx, [rel lb_noff]
    mov  [rbx + r8*4], edx
    lea  rbx, [rel lb_nlen]
    mov  [rbx + r8*4], ecx
    lea  rdi, [rel lb_pool]
    add  rdi, rdx
    xor  ebx, ebx
    jmp  .cp
.cp:
    cmp  rbx, rcx
    jae  .cpd
    mov  al, [rsi + rbx]
    mov  [rdi + rbx], al
    inc  rbx
    jmp  .cp
.cpd:
    mov  byte [rdi + rbx], 0
    add  rdx, rcx
    inc  rdx
    mov  [rel lb_pool_len], rdx
    ; into the hash table
    call ka_hash
    mov  ebx, eax
    jmp  .probe
.probe:
    lea  rdx, [rel lb_hash]
    mov  eax, [rdx + rbx*4]
    test eax, eax
    jz   .slot
    inc  ebx
    and  ebx, 131071
    jmp  .probe
.slot:
    mov  rax, r8
    inc  eax
    mov  [rdx + rbx*4], eax
    mov  rax, r8
    inc  r8
    mov  [rel lb_count], r8
    pop  r8
    pop  rdi
    pop  rbx
    ret
.full:
    mov  rax, -1
    pop  r8
    pop  rdi
    pop  rbx
    ret

; ka_fullname(rsi = name, rcx = length) -> rsi = ka_name, rcx = length.
; A name that starts with '.' is local: the last ordinary label goes first.
ka_fullname:
    push rdi
    push rbx
    lea  rdi, [rel ka_name]
    xor  ebx, ebx
    cmp  byte [rsi], '.'
    jne  .own
    mov  rdx, [rel ka_lastlen]
    xor  r8d, r8d
    jmp  .pre
.pre:
    cmp  r8, rdx
    jae  .own
    lea  rax, [rel ka_last]
    mov  al, [rax + r8]
    mov  [rdi + rbx], al
    inc  rbx
    inc  r8
    jmp  .pre
.own:
    xor  r8d, r8d
    jmp  .ol
.ol:
    cmp  r8, rcx
    jae  .done
    cmp  rbx, 500
    jae  .done
    mov  al, [rsi + r8]
    mov  [rdi + rbx], al
    inc  rbx
    inc  r8
    jmp  .ol
.done:
    mov  byte [rdi + rbx], 0
    mov  rcx, rbx
    lea  rsi, [rel ka_name]
    pop  rbx
    pop  rdi
    ret

; ka_define_label(): ka_word is a label defined here, in the current section
ka_define_label:
    push rsi
    push rdi
    lea  rsi, [rel ka_word]
    mov  rcx, [rel ka_wordlen]
    test rcx, rcx
    jz   .out
    cmp  byte [rsi], '.'
    je   .local
    ; an ordinary label becomes the prefix of the local ones that follow
    lea  rdi, [rel ka_last]
    xor  edx, edx
    jmp  .cl
.cl:
    cmp  rdx, rcx
    jae  .cld
    cmp  rdx, 250
    jae  .cld
    mov  al, [rsi + rdx]
    mov  [rdi + rdx], al
    inc  rdx
    jmp  .cl
.cld:
    mov  byte [rdi + rdx], 0
    mov  [rel ka_lastlen], rdx
    jmp  .local
.local:
    call ka_fullname
    call ka_find_exact
    cmp  qword [rel ka_pass], 1
    jne  .pass2
    cmp  rax, -1
    je   .new
    mov  ecx, 5
    call ka_err
    jmp  .out
.new:
    call ka_add_label
    cmp  rax, -1
    je   .out
    mov  [rel ka_deflbl], rax
    lea  rdx, [rel lb_sec]
    mov  rcx, [rel ka_sec]
    mov  [rdx + rax*4], ecx
    call ka_cur_off
    lea  rdx, [rel lb_val]
    mov  [rdx + rax*8], rcx
    jmp  .out
.pass2:
    mov  [rel ka_deflbl], rax
    jmp  .out
.out:
    pop  rdi
    pop  rsi
    ret

; ka_cur_off(rax kept) -> rcx = offset of the current position in its section
ka_cur_off:
    mov  rcx, [rel ka_code_len]
    cmp  qword [rel ka_sec], 0
    je   .o
    mov  rcx, [rel ka_data_len]
    cmp  qword [rel ka_sec], 1
    je   .o
    mov  rcx, [rel ka_bss_len]
    jmp  .o
.o:
    ret

; ka_label_addr(rax = index) -> rax = final address
ka_label_addr:
    push rbx
    push rcx
    mov  rbx, rax
    lea  rdx, [rel lb_val]
    mov  rax, [rdx + rbx*8]
    lea  rdx, [rel lb_sec]
    mov  ecx, [rdx + rbx*4]
    cmp  ecx, 3
    je   .out
    add  rax, [rel ka_base]
    cmp  ecx, 0
    je   .out
    mov  rdx, [rel ka_final_code]
    call ka_align_code
    add  rax, rdx
    cmp  ecx, 1
    je   .out
    mov  rdx, [rel ka_final_data]
    call ka_align
    add  rax, rdx
    jmp  .out
.out:
    pop  rcx
    pop  rbx
    ret

; ka_pc() -> rax = address of the current position
ka_pc:
    push rcx
    push rdx
    call ka_cur_off
    mov  rax, rcx
    add  rax, [rel ka_base]
    cmp  qword [rel ka_sec], 0
    je   .out
    mov  rdx, [rel ka_final_code]
    call ka_align_code
    add  rax, rdx
    cmp  qword [rel ka_sec], 1
    je   .out
    mov  rdx, [rel ka_final_data]
    call ka_align
    add  rax, rdx
    jmp  .out
.out:
    pop  rdx
    pop  rcx
    ret

; ==============================================================================
; EMISSION
; ==============================================================================

; ka_emit32(ecx = word)
ka_emit32:
    push rbx
    push rdx
    cmp  qword [rel ka_sec], 0
    jne  .notext
    mov  rbx, [rel ka_code_len]
    lea  rdx, [rel ka_code]
    mov  [rdx + rbx], ecx
    add  rbx, 4
    mov  [rel ka_code_len], rbx
    jmp  .out
.notext:
    cmp  qword [rel ka_sec], 1
    jne  .bss
    mov  rbx, [rel ka_data_len]
    lea  rdx, [rel ka_data]
    mov  [rdx + rbx], ecx
    add  rbx, 4
    mov  [rel ka_data_len], rbx
    jmp  .out
.bss:
    add  qword [rel ka_bss_len], 4
    jmp  .out
.out:
    pop  rdx
    pop  rbx
    ret

; ka_emit8(cl = byte)
ka_emit8:
    push rbx
    push rdx
    cmp  qword [rel ka_sec], 0
    jne  .notext
    mov  rbx, [rel ka_code_len]
    lea  rdx, [rel ka_code]
    mov  [rdx + rbx], cl
    inc  rbx
    mov  [rel ka_code_len], rbx
    jmp  .out
.notext:
    cmp  qword [rel ka_sec], 1
    jne  .bss
    mov  rbx, [rel ka_data_len]
    lea  rdx, [rel ka_data]
    mov  [rdx + rbx], cl
    inc  rbx
    mov  [rel ka_data_len], rbx
    jmp  .out
.bss:
    inc  qword [rel ka_bss_len]
    jmp  .out
.out:
    pop  rdx
    pop  rbx
    ret

; ka_emit_n(rax = value, r8 = bytes): little-endian
ka_emit_n:
    push rbx
    mov  rbx, rax
    jmp  .l
.l:
    test r8, r8
    jz   .d
    mov  rcx, rbx
    call ka_emit8
    shr  rbx, 8
    dec  r8
    jmp  .l
.d:
    pop  rbx
    ret

; ==============================================================================
; OPERANDS
; ==============================================================================

; ka_reg(rsi = text) -> eax = class, edx = number
;   class 0 none, 1 x, 2 w, 3 d, 4 s, 5 sp (number 31). xzr and wzr are
;   x31 and w31; fp is x29, lr is x30.
ka_reg:
    push rsi
    movzx eax, byte [rsi]
    cmp  al, 's'
    jne  .not_sp
    cmp  byte [rsi+1], 'p'
    jne  .not_sp
    cmp  byte [rsi+2], 0
    jne  .not_sp
    mov  eax, 5
    mov  edx, 31
    pop  rsi
    ret
.not_sp:
    cmp  al, 'f'
    jne  .not_fp
    cmp  byte [rsi+1], 'p'
    jne  .none
    cmp  byte [rsi+2], 0
    jne  .none
    mov  eax, 1
    mov  edx, 29
    pop  rsi
    ret
.not_fp:
    cmp  al, 'l'
    jne  .not_lr
    cmp  byte [rsi+1], 'r'
    jne  .none
    cmp  byte [rsi+2], 0
    jne  .none
    mov  eax, 1
    mov  edx, 30
    pop  rsi
    ret
.not_lr:
    cmp  al, 'v'
    je   .vec
    mov  r8d, 1
    cmp  al, 'x'
    je   .cls
    mov  r8d, 2
    cmp  al, 'w'
    je   .cls
    mov  r8d, 3
    cmp  al, 'd'
    je   .cls
    mov  r8d, 4
    cmp  al, 's'
    je   .cls
    mov  r8d, 6
    cmp  al, 'q'
    je   .cls
    jmp  .none
.vec:
    ; vN.16b -> class 7, vN.2d -> class 8
    inc  rsi
    movzx eax, byte [rsi]
    sub  eax, '0'
    cmp  eax, 9
    ja   .none
    mov  edx, eax
    inc  rsi
    movzx eax, byte [rsi]
    cmp  al, '.'
    je   .vdot
    sub  eax, '0'
    cmp  eax, 9
    ja   .none
    imul edx, edx, 10
    add  edx, eax
    inc  rsi
    cmp  byte [rsi], '.'
    jne  .none
    jmp  .vdot
.vdot:
    cmp  edx, 31
    ja   .none
    cmp  byte [rsi+1], '1'
    jne  .v2d
    cmp  byte [rsi+2], '6'
    jne  .none
    cmp  byte [rsi+3], 'b'
    jne  .none
    cmp  byte [rsi+4], 0
    jne  .none
    mov  eax, 7
    pop  rsi
    ret
.v2d:
    cmp  byte [rsi+1], '4'
    je   .v4s
    cmp  byte [rsi+1], '2'
    jne  .none
    cmp  byte [rsi+2], 'd'
    jne  .none
    cmp  byte [rsi+3], 0
    jne  .none
    mov  eax, 8
    pop  rsi
    ret
.v4s:
    ; vN.4s -> class 9: four singles
    cmp  byte [rsi+2], 's'
    jne  .none
    cmp  byte [rsi+3], 0
    jne  .none
    mov  eax, 9
    pop  rsi
    ret
.cls:
    inc  rsi
    ; zr for x and w
    cmp  byte [rsi], 'z'
    jne  .num
    cmp  r8d, 2
    ja   .none
    cmp  byte [rsi+1], 'r'
    jne  .none
    cmp  byte [rsi+2], 0
    jne  .none
    mov  eax, r8d
    mov  edx, 31
    pop  rsi
    ret
.num:
    movzx eax, byte [rsi]
    sub  eax, '0'
    cmp  eax, 9
    ja   .none
    mov  edx, eax
    inc  rsi
    movzx eax, byte [rsi]
    test al, al
    jz   .have
    sub  eax, '0'
    cmp  eax, 9
    ja   .none
    imul edx, edx, 10
    add  edx, eax
    inc  rsi
    cmp  byte [rsi], 0
    jne  .none
    jmp  .have
.have:
    cmp  edx, 31
    ja   .none
    ; x31 and w31 are not names: 31 is zr or sp by context
    cmp  edx, 31
    jne  .ok
    cmp  r8d, 2
    jbe  .none
    jmp  .ok
.ok:
    mov  eax, r8d
    pop  rsi
    ret
.none:
    xor  eax, eax
    xor  edx, edx
    pop  rsi
    ret

; ka_opreg(ecx = operand index) -> eax = class, edx = number
ka_opreg:
    push rsi
    call ka_op
    call ka_reg
    pop  rsi
    ret

; ka_cond(rsi = two letters) -> rax = condition 0..15, -1 when unknown
ka_cond:
    push rbx
    movzx eax, byte [rsi]
    movzx edx, byte [rsi+1]
    cmp  byte [rsi+2], 0
    jne  .no
    ; hs and lo are the other names of cs and cc
    cmp  al, 'h'
    jne  .nhs
    cmp  dl, 's'
    jne  .nhs
    mov  eax, 2
    pop  rbx
    ret
.nhs:
    cmp  al, 'l'
    jne  .nlo
    cmp  dl, 'o'
    jne  .nlo
    mov  eax, 3
    pop  rbx
    ret
.nlo:
    lea  r8, [rel ka_conds]
    xor  ebx, ebx
    jmp  .l
.l:
    cmp  ebx, 16
    jae  .no
    mov  r9, rbx
    shl  r9, 1
    movzx r10d, byte [r8 + r9]
    cmp  rax, r10
    jne  .n
    inc  r9
    movzx r10d, byte [r8 + r9]
    cmp  rdx, r10
    jne  .n
    mov  eax, ebx
    pop  rbx
    ret
.n:
    inc  ebx
    jmp  .l
.no:
    mov  rax, -1
    pop  rbx
    ret

; ka_shiftop(rsi = "lsl #3") -> rax = 0 lsl, 1 lsr, 2 asr, 3 ror, -1 none;
; rdx = amount
ka_shiftop:
    push rbx
    mov  rbx, -1
    cmp  byte [rsi], 'l'
    jne  .n1
    cmp  byte [rsi+1], 's'
    jne  .no
    cmp  byte [rsi+2], 'l'
    jne  .n2
    xor  ebx, ebx
    jmp  .amt
.n2:
    cmp  byte [rsi+2], 'r'
    jne  .no
    mov  ebx, 1
    jmp  .amt
.n1:
    cmp  byte [rsi], 'a'
    jne  .n3
    cmp  byte [rsi+1], 's'
    jne  .no
    cmp  byte [rsi+2], 'r'
    jne  .no
    mov  ebx, 2
    jmp  .amt
.n3:
    cmp  byte [rsi], 'r'
    jne  .no
    cmp  byte [rsi+1], 'o'
    jne  .no
    cmp  byte [rsi+2], 'r'
    jne  .no
    mov  ebx, 3
    jmp  .amt
.amt:
    push rsi
    add  rsi, 3
    call ka_eval
    pop  rsi
    test rdx, rdx
    jz   .no
    mov  rdx, rax
    mov  rax, rbx
    pop  rbx
    ret
.no:
    mov  rax, -1
    xor  edx, edx
    pop  rbx
    ret

; ==============================================================================
; EXPRESSIONS: + - * on numbers, characters and symbols, with parentheses.
; ka_eval(rsi = text) -> rax = value, rdx = 1 when well formed. An unknown
; symbol counts as 0 and sets ka_unres; on pass two it is an error.
; ==============================================================================
ka_eval:
    push rsi
    mov  [rel ka_ep], rsi
    mov  qword [rel ka_everr], 0
    call ka_expr
    ; nothing may follow but blanks
    mov  rsi, [rel ka_ep]
    call ka_skipb
    cmp  byte [rsi], 0
    je   .end
    mov  qword [rel ka_everr], 1
    jmp  .end
.end:
    xor  edx, edx
    cmp  qword [rel ka_everr], 0
    jne  .out
    mov  edx, 1
    jmp  .out
.out:
    pop  rsi
    ret

ka_expr:
    push rbx
    call ka_term
    mov  rbx, rax
    jmp  .l
.l:
    mov  rsi, [rel ka_ep]
    call ka_skipb
    mov  [rel ka_ep], rsi
    cmp  byte [rsi], '+'
    je   .add
    cmp  byte [rsi], '-'
    je   .sub
    mov  rax, rbx
    pop  rbx
    ret
.add:
    inc  qword [rel ka_ep]
    call ka_term
    add  rbx, rax
    jmp  .l
.sub:
    inc  qword [rel ka_ep]
    call ka_flip
    call ka_term
    call ka_flip
    sub  rbx, rax
    jmp  .l

ka_term:
    push rbx
    call ka_factor
    mov  rbx, rax
    jmp  .l
.l:
    mov  rsi, [rel ka_ep]
    call ka_skipb
    mov  [rel ka_ep], rsi
    cmp  byte [rsi], '*'
    je   .mul
    mov  rax, rbx
    pop  rbx
    ret
.mul:
    inc  qword [rel ka_ep]
    call ka_factor
    imul rbx, rax
    jmp  .l

ka_factor:
    push rbx
    mov  rsi, [rel ka_ep]
    call ka_skipb
    cmp  byte [rsi], '#'
    jne  .nohash
    inc  rsi
    call ka_skipb
    jmp  .nohash
.nohash:
    mov  [rel ka_ep], rsi
    movzx eax, byte [rsi]
    cmp  al, '-'
    je   .neg
    cmp  al, '('
    je   .paren
    cmp  al, 0x27
    je   .char
    cmp  al, '0'
    jb   .sym
    cmp  al, '9'
    jbe  .number
    jmp  .sym
.neg:
    inc  qword [rel ka_ep]
    call ka_flip
    call ka_factor
    call ka_flip
    neg  rax
    pop  rbx
    ret
.paren:
    inc  qword [rel ka_ep]
    call ka_expr
    mov  rsi, [rel ka_ep]
    call ka_skipb
    cmp  byte [rsi], ')'
    jne  .bad
    inc  rsi
    mov  [rel ka_ep], rsi
    pop  rbx
    ret
.char:
    movzx eax, byte [rsi+1]
    cmp  byte [rsi+2], 0x27
    jne  .bad
    add  rsi, 3
    mov  [rel ka_ep], rsi
    pop  rbx
    ret
.number:
    xor  ebx, ebx
    cmp  byte [rsi], '0'
    jne  .dec
    cmp  byte [rsi+1], 'x'
    jne  .dec
    add  rsi, 2
    jmp  .hex
.hex:
    movzx eax, byte [rsi]
    cmp  al, '0'
    jb   .numdone
    cmp  al, '9'
    jbe  .hdig
    cmp  al, 'a'
    jb   .hupper
    cmp  al, 'f'
    ja   .numdone
    sub  eax, 87
    jmp  .hput
.hupper:
    cmp  al, 'A'
    jb   .numdone
    cmp  al, 'F'
    ja   .numdone
    sub  eax, 55
    jmp  .hput
.hdig:
    sub  eax, '0'
    jmp  .hput
.hput:
    shl  rbx, 4
    add  rbx, rax
    inc  rsi
    jmp  .hex
.dec:
    movzx eax, byte [rsi]
    cmp  al, '0'
    jb   .numdone
    cmp  al, '9'
    ja   .numdone
    sub  eax, '0'
    imul rbx, rbx, 10
    add  rbx, rax
    inc  rsi
    jmp  .dec
.numdone:
    mov  [rel ka_ep], rsi
    mov  rax, rbx
    pop  rbx
    ret
.sym:
    ; a symbol: letters, digits, '_', '.', '$'
    mov  rbx, rsi
    xor  ecx, ecx
    jmp  .sl
.sl:
    movzx eax, byte [rsi + rcx]
    cmp  al, '_'
    je   .sc
    cmp  al, '.'
    je   .sc
    cmp  al, '$'
    je   .sc
    cmp  al, '0'
    jb   .se
    cmp  al, '9'
    jbe  .sc
    cmp  al, 'A'
    jb   .se
    cmp  al, 'Z'
    jbe  .sc
    cmp  al, 'a'
    jb   .se
    cmp  al, 'z'
    jbe  .sc
    jmp  .se
.sc:
    inc  ecx
    jmp  .sl
.se:
    test ecx, ecx
    jz   .bad
    lea  rax, [rsi + rcx]
    mov  [rel ka_ep], rax
    mov  rsi, rbx
    call ka_fullname
    call ka_find_exact
    cmp  rax, -1
    je   .unknown
    ; an address (a label of a section, not an equ) counts with its sign
    lea  rdx, [rel lb_sec]
    mov  edx, [rdx + rax*4]
    cmp  edx, 3
    je   .addr
    mov  rdx, [rel ka_rsign]
    add  [rel ka_nrel], rdx
.addr:
    call ka_label_addr
    pop  rbx
    ret
.unknown:
    mov  qword [rel ka_unres], 1
    xor  eax, eax
    pop  rbx
    ret
.bad:
    mov  qword [rel ka_everr], 1
    xor  eax, eax
    pop  rbx
    ret

; ka_imm(ecx = operand index) -> rax = value, rdx = 1 when it is a value.
; Registers are not values.
ka_imm:
    push rsi
    call ka_op
    call ka_reg
    test eax, eax
    jnz  .no
    call ka_eval
    pop  rsi
    ret
.no:
    xor  eax, eax
    xor  edx, edx
    pop  rsi
    ret

; ka_undef_check(): on pass two, an unknown symbol in the last expression
; is an error. Call right after ka_eval / ka_imm with ka_unres cleared before.
ka_undef_check:
    cmp  qword [rel ka_unres], 0
    je   .ok
    mov  ecx, 4
    call ka_err2
    jmp  .ok
.ok:
    ret

; ka_mem(rsi = text) -> rax = 1 when it is a memory operand; fills km_*
;   [Xn]  [Xn, #imm]  [Xn, #imm]!  [Xn, Xm]  [Xn, Xm, lsl #s]
;   [Xn, Wm, sxtw]  [Xn, Wm, uxtw #s]
ka_mem:
    push rbx
    push rsi
    push rdi
    mov  qword [rel km_kind], 0
    mov  qword [rel km_imm], 0
    mov  qword [rel km_amt], -1
    mov  qword [rel km_pre], 0
    mov  qword [rel km_ext], 0
    mov  qword [rel km_idxw], 0
    cmp  byte [rsi], '['
    jne  .no
    inc  rsi
    call ka_skipb
    ; the base register, up to ',' or ']'
    call .piece
    push rsi
    lea  rsi, [rel ka_tmp]
    call ka_reg
    pop  rsi
    cmp  eax, 1
    je   .base_ok
    cmp  eax, 5
    je   .base_ok
    jmp  .no
.base_ok:
    mov  [rel km_base], rdx
    cmp  byte [rsi], ']'
    je   .close
    cmp  byte [rsi], ','
    jne  .no
    inc  rsi
    call ka_skipb
    call .piece
    ; an index register, or an immediate
    push rsi
    lea  rsi, [rel ka_tmp]
    call ka_reg
    pop  rsi
    cmp  eax, 1
    je   .index_x
    cmp  eax, 2
    je   .index_w
    ; immediate
    push rsi
    lea  rsi, [rel ka_tmp]
    call ka_eval
    pop  rsi
    test rdx, rdx
    jz   .no
    mov  [rel km_imm], rax
    mov  qword [rel km_kind], 1
    cmp  byte [rsi], ']'
    je   .close
    jmp  .no
.index_w:
    mov  qword [rel km_idxw], 1
    mov  qword [rel km_ext], 2
    jmp  .index
.index_x:
    jmp  .index
.index:
    mov  [rel km_idx], rdx
    mov  qword [rel km_kind], 2
    cmp  byte [rsi], ']'
    je   .close
    cmp  byte [rsi], ','
    jne  .no
    inc  rsi
    call ka_skipb
    call .piece
    ; lsl #s, or an extension with an optional amount
    lea  rdi, [rel ka_tmp]
    cmp  byte [rdi], 'l'
    je   .lsl
    cmp  byte [rdi], 's'
    je   .sx
    cmp  byte [rdi], 'u'
    je   .ux
    jmp  .no
.lsl:
    push rsi
    lea  rsi, [rel ka_tmp]
    call ka_shiftop
    pop  rsi
    test rax, rax
    jnz  .no
    mov  [rel km_amt], rdx
    jmp  .after_ext
.sx:
    cmp  byte [rdi+1], 'x'
    jne  .no
    cmp  byte [rdi+2], 't'
    jne  .no
    mov  qword [rel km_ext], 1
    cmp  byte [rdi+3], 'w'
    je   .ext_amt
    cmp  byte [rdi+3], 'x'
    jne  .no
    mov  qword [rel km_ext], 3
    jmp  .ext_amt
.ux:
    cmp  byte [rdi+1], 'x'
    jne  .no
    cmp  byte [rdi+2], 't'
    jne  .no
    cmp  byte [rdi+3], 'w'
    jne  .no
    mov  qword [rel km_ext], 2
    jmp  .ext_amt
.ext_amt:
    add  rdi, 4
    cmp  byte [rdi], 0
    je   .after_ext
    push rsi
    mov  rsi, rdi
    call ka_eval
    pop  rsi
    test rdx, rdx
    jz   .no
    mov  [rel km_amt], rax
    jmp  .after_ext
.after_ext:
    cmp  byte [rsi], ']'
    je   .close
    jmp  .no
.close:
    inc  rsi
    call ka_skipb
    cmp  byte [rsi], '!'
    jne  .end
    mov  qword [rel km_pre], 1
    inc  rsi
    call ka_skipb
    jmp  .end
.end:
    cmp  byte [rsi], 0
    jne  .no
    mov  eax, 1
    pop  rdi
    pop  rsi
    pop  rbx
    ret
.no:
    xor  eax, eax
    pop  rdi
    pop  rsi
    pop  rbx
    ret
; .piece: copy rsi up to ',' or ']' into ka_tmp, trimmed; rsi at the delimiter
.piece:
    lea  rdi, [rel ka_tmp]
    xor  ecx, ecx
    jmp  .pl
.pl:
    mov  al, [rsi]
    test al, al
    jz   .pe
    cmp  al, ','
    je   .pe
    cmp  al, ']'
    je   .pe
    cmp  ecx, 250
    jae  .ps
    mov  [rdi + rcx], al
    inc  ecx
    jmp  .ps
.ps:
    inc  rsi
    jmp  .pl
.pe:
    jmp  .pt
.pt:
    test ecx, ecx
    jz   .pd
    cmp  byte [rdi + rcx - 1], ' '
    jne  .pd
    dec  ecx
    jmp  .pt
.pd:
    mov  byte [rdi + rcx], 0
    ret

; ==============================================================================
; DISPATCH
; ==============================================================================
ka_dispatch:
    mov  qword [rel ka_unres], 0
    ; directives
    KM_IS kd_section, kh_section
    KM_IS kd_global,  kh_ignore
    KM_IS kd_extern,  kh_extern
    KM_IS kd_align,   kh_align
    KM_IS kd_db,      kh_db
    KM_IS kd_dw,      kh_dw
    KM_IS kd_dd,      kh_dd
    KM_IS kd_dq,      kh_dq
    KM_IS kd_resb,    kh_resb
    KM_IS kd_resw,    kh_resw
    KM_IS kd_resd,    kh_resd
    KM_IS kd_resq,    kh_resq
    KM_IS kd_equ,     kh_equ
    KM_IS kd_times,   kh_times
    ; instructions
    KM_IS km_mov,    kh_mov
    KM_IS km_movz,   kh_movz
    KM_IS km_movn,   kh_movn
    KM_IS km_movk,   kh_movk
    KM_IS km_add,    kh_add
    KM_IS km_sub,    kh_sub
    KM_IS km_adds,   kh_adds
    KM_IS km_subs,   kh_subs
    KM_IS km_cmp,    kh_cmp
    KM_IS km_cmn,    kh_cmn
    KM_IS km_neg,    kh_neg
    KM_IS km_mul,    kh_mul
    KM_IS km_madd,   kh_madd
    KM_IS km_msub,   kh_msub
    KM_IS km_sdiv,   kh_sdiv
    KM_IS km_udiv,   kh_udiv
    KM_IS km_and,    kh_and
    KM_IS km_orr,    kh_orr
    KM_IS km_eor,    kh_eor
    KM_IS km_ands,   kh_ands
    KM_IS km_bic,    kh_bic
    KM_IS km_orn,    kh_orn
    KM_IS km_eon,    kh_eon
    KM_IS km_tst,    kh_tst
    KM_IS km_mvn,    kh_mvn
    KM_IS km_lsl,    kh_lsl
    KM_IS km_lsr,    kh_lsr
    KM_IS km_asr,    kh_asr
    KM_IS km_ror,    kh_ror
    KM_IS km_cset,   kh_cset
    KM_IS km_csel,   kh_csel
    KM_IS km_csinc,  kh_csinc
    KM_IS km_csneg,  kh_csneg
    KM_IS km_sxtb,   kh_sxtb
    KM_IS km_sxth,   kh_sxth
    KM_IS km_sxtw,   kh_sxtw
    KM_IS km_uxtb,   kh_uxtb
    KM_IS km_uxth,   kh_uxth
    KM_IS km_ldr,    kh_ldr
    KM_IS km_str,    kh_str
    KM_IS km_ldrb,   kh_ldrb
    KM_IS km_strb,   kh_strb
    KM_IS km_ldrh,   kh_ldrh
    KM_IS km_strh,   kh_strh
    KM_IS km_ldrsb,  kh_ldrsb
    KM_IS km_ldrsh,  kh_ldrsh
    KM_IS km_ldrsw,  kh_ldrsw
    KM_IS km_ldur,   kh_ldur
    KM_IS km_stur,   kh_stur
    KM_IS km_ldurb,  kh_ldurb
    KM_IS km_sturb,  kh_sturb
    KM_IS km_ldurh,  kh_ldurh
    KM_IS km_sturh,  kh_sturh
    KM_IS km_ldp,    kh_ldp
    KM_IS km_stp,    kh_stp
    KM_IS km_ldxr,   kh_ldxr
    KM_IS km_stxr,   kh_stxr
    KM_IS km_ldaxr,  kh_ldaxr
    KM_IS km_stlxr,  kh_stlxr
    KM_IS km_b,      kh_b
    KM_IS km_bl,     kh_bl
    KM_IS km_cbz,    kh_cbz
    KM_IS km_cbnz,   kh_cbnz
    KM_IS km_br,     kh_br
    KM_IS km_blr,    kh_blr
    KM_IS km_ret,    kh_ret
    KM_IS km_adr,    kh_adr
    KM_IS km_adrp,   kh_adrp
    KM_IS km_adrl,   kh_adrl
    KM_IS km_svc,    kh_svc
    KM_IS km_nop,    kh_nop
    KM_IS km_dmb,    kh_dmb
    KM_IS km_fmov,   kh_fmov
    KM_IS km_fadd,   kh_fadd
    KM_IS km_fsub,   kh_fsub
    KM_IS km_fmul,   kh_fmul
    KM_IS km_fdiv,   kh_fdiv
    KM_IS km_fsqrt,  kh_fsqrt
    KM_IS km_fneg,   kh_fneg
    KM_IS km_fabs,   kh_fabs
    KM_IS km_fcmp,   kh_fcmp
    KM_IS km_scvtf,  kh_scvtf
    KM_IS km_ucvtf,  kh_ucvtf
    KM_IS km_fcvtzs, kh_fcvtzs
    KM_IS km_fcvtzu, kh_fcvtzu
    KM_IS km_fcvt,   kh_fcvt
    KM_IS km_fcvtns, kh_fcvtns
    KM_IS km_prfm,   kh_prfm
    KM_IS km_dc,     kh_dc
    ; b.cond
    lea  rsi, [rel ka_mnem]
    cmp  byte [rsi], 'b'
    jne  .unknown
    cmp  byte [rsi+1], '.'
    jne  .unknown
    jmp  kh_bcond
.unknown:
    mov  ecx, 1
    call ka_err2
    ret

; every handler ends with ret; a syntax error goes through kh_bad
kh_bad:
    mov  ecx, 2
    call ka_err2
    ret
kh_range:
    mov  ecx, 3
    call ka_err2
    ret
kh_ignore:
    ret

; ==============================================================================
; DIRECTIVES
; ==============================================================================
kh_section:
    xor  ecx, ecx
    call ka_op
    mov  rdi, rsi
    mov  rcx, rsi
    lea  rdx, [rel ks_text]
    call ka_streq
    test rax, rax
    jnz  .t
    mov  rcx, rdi
    lea  rdx, [rel ks_data]
    call ka_streq
    test rax, rax
    jnz  .d
    mov  rcx, rdi
    lea  rdx, [rel ks_bss]
    call ka_streq
    test rax, rax
    jnz  .b
    mov  ecx, 8
    call ka_err2
    ret
.t:
    mov  qword [rel ka_sec], 0
    ret
.d:
    mov  qword [rel ka_sec], 1
    ret
.b:
    mov  qword [rel ka_sec], 2
    ret

kh_extern:
    ; Linux ARM64 programs import nothing: every name must be defined here
    jmp  kh_bad

; align N: zero bytes in data, nop in code, until the position is a multiple
kh_align:
    xor  ecx, ecx
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    mov  rbx, rax
    test rbx, rbx
    jz   kh_bad
    jmp  .l
.l:
    call ka_cur_off
    mov  rax, rcx
    xor  edx, edx
    div  rbx
    test rdx, rdx
    jz   .done
    cmp  qword [rel ka_sec], 0
    jne  .byte
    mov  rax, rcx
    and  rax, 3
    test rax, rax
    jnz  .byte
    mov  ecx, 0xD503201F
    call ka_emit32
    jmp  .l
.byte:
    xor  ecx, ecx
    call ka_emit8
    jmp  .l
.done:
    ret

; db / dw / dd / dq: numbers, characters, strings (bytes only), and for dq
; also labels -- their final address.
kh_db:
    mov  r12, 1
    jmp  kh_data
kh_dw:
    mov  r12, 2
    jmp  kh_data
kh_dd:
    mov  r12, 4
    jmp  kh_data
kh_dq:
    mov  r12, 8
    jmp  kh_data
kh_data:
    ; the items are read from the line itself, not from the six operand
    ; slots: a data line can hold any number of them
    mov  rsi, [rel ka_rest]
    jmp  .item
.item:
    call ka_item
    test rax, rax
    jz   .done
    push rsi
    lea  rsi, [rel ka_ops]
    call ka_data_item
    pop  rsi
    test rax, rax
    jz   kh_bad
    jmp  .item
.done:
    ret

; ka_item(rsi = cursor in a data line) -> rax = 1 and the next item, trimmed,
; in the first operand slot; rsi past it and its comma. rax = 0 at the end.
ka_item:
    push rdi
    call ka_skipb
    cmp  byte [rsi], 0
    je   .none
    lea  rdi, [rel ka_ops]
    xor  ecx, ecx
    xor  edx, edx                    ; dl = open quote
    jmp  .ch
.ch:
    mov  al, [rsi]
    test al, al
    jz   .end
    test dl, dl
    jnz  .inq
    cmp  al, ','
    je   .comma
    cmp  al, 0x27
    je   .q
    cmp  al, 0x22
    je   .q
    jmp  .put
.q:
    mov  dl, al
    jmp  .put
.inq:
    cmp  al, dl
    jne  .put
    xor  edx, edx
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
.comma:
    inc  rsi
    jmp  .end
.end:
    ; trim the spaces after the item
    test ecx, ecx
    jz   .term
    mov  al, [rdi + rcx - 1]
    cmp  al, ' '
    je   .trim
    cmp  al, 9
    je   .trim
    jmp  .term
.trim:
    dec  ecx
    jmp  .end
.term:
    mov  byte [rdi + rcx], 0
    mov  eax, 1
    pop  rdi
    ret
.none:
    xor  eax, eax
    pop  rdi
    ret

; ka_data_item(rsi = one item, r12 = size) -> rax = 1 when it was written:
; a number or expression, a quoted string (its bytes), or for dq a real
ka_data_item:
    push rbx
    movzx eax, byte [rsi]
    cmp  al, 0x27
    je   .str
    cmp  al, 0x22
    je   .str
    cmp  r12, 8
    jne  .num
    ; dq with a '.' in a token that starts like a number is a real: its
    ; IEEE-754 bits. '.label' and 'name.local' are addresses.
    cmp  al, '-'
    je   .dot0
    cmp  al, '+'
    je   .dot0
    cmp  al, '0'
    jb   .num
    cmp  al, '9'
    ja   .num
.dot0:
    mov  rcx, rsi
    jmp  .dot
.dot:
    mov  al, [rcx]
    test al, al
    jz   .num
    cmp  al, '.'
    je   .real
    inc  rcx
    jmp  .dot
.real:
    mov  rcx, rsi
    call parse_float
    sub  rsp, 16
    movsd [rsp], xmm0
    mov  rax, [rsp]
    add  rsp, 16
    mov  r8, 8
    call ka_emit_n
    jmp  .ok
.num:
    mov  qword [rel ka_unres], 0
    mov  qword [rel ka_rsign], 1
    mov  qword [rel ka_nrel], 0
    call ka_eval
    test rdx, rdx
    jz   .bad
    call ka_undef_check
    ; an address in a dq: where it is, for an image that moves
    cmp  r12, 8
    jne  .emit
    cmp  qword [rel ka_nrel], 1
    jne  .emit
    cmp  qword [rel ka_pass], 2
    jne  .emit
    call ka_note_reloc
.emit:
    mov  r8, r12
    call ka_emit_n
    jmp  .ok
.str:
    ; 'x' of one character is a number; a longer string is its bytes
    mov  bl, al
    inc  rsi
    jmp  .sl
.sl:
    mov  al, [rsi]
    test al, al
    jz   .ok
    cmp  al, bl
    je   .ok
    movzx eax, al
    mov  r8, r12
    call ka_emit_n
    inc  rsi
    jmp  .sl
.ok:
    mov  eax, 1
    pop  rbx
    ret
.bad:
    xor  eax, eax
    pop  rbx
    ret

; ka_flip(): the next term counts with the other sign
ka_flip:
    push rax
    mov  rax, [rel ka_rsign]
    neg  rax
    mov  [rel ka_rsign], rax
    pop  rax
    ret

; ka_note_reloc(): the dq about to be written holds an address
ka_note_reloc:
    push rcx
    push rdx
    cmp  qword [rel ka_sec], 1
    jne  .not_data
    mov  rcx, [rel ka_rel_n]
    cmp  rcx, 262144
    jae  .out
    lea  rdx, [rel ka_rel_off]
    push rax
    mov  rax, [rel ka_data_len]
    mov  [rdx + rcx*8], rax
    pop  rax
    inc  rcx
    mov  [rel ka_rel_n], rcx
    jmp  .out
.not_data:
    cmp  qword [rel ka_sec], 0
    jne  .out
    inc  qword [rel ka_rel_text]
.out:
    pop  rdx
    pop  rcx
    ret

; resb / resw / resd / resq N: space. In .bss it only counts; elsewhere zeros
kh_resb:
    mov  r12, 1
    jmp  kh_res
kh_resw:
    mov  r12, 2
    jmp  kh_res
kh_resd:
    mov  r12, 4
    jmp  kh_res
kh_resq:
    mov  r12, 8
    jmp  kh_res
kh_res:
    xor  ecx, ecx
    mov  qword [rel ka_unres], 0
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    cmp  qword [rel ka_unres], 0
    jne  .unknown
    imul rax, r12
    cmp  qword [rel ka_sec], 2
    jne  .zeros
    add  [rel ka_bss_len], rax
    ret
.zeros:
    mov  rbx, rax
    jmp  .zl
.zl:
    test rbx, rbx
    jz   .zd
    xor  ecx, ecx
    call ka_emit8
    dec  rbx
    jmp  .zl
.zd:
    ret
.unknown:
    mov  ecx, 6
    call ka_err
    ret

; NAME equ EXPR: the label of this line becomes a constant
kh_equ:
    mov  rbx, [rel ka_deflbl]
    cmp  rbx, -1
    je   kh_bad
    xor  ecx, ecx
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    lea  rdx, [rel lb_sec]
    mov  ecx, 3
    mov  [rdx + rbx*4], ecx
    lea  rdx, [rel lb_val]
    mov  [rdx + rbx*8], rax
    ret

; times N db|dw|dd|dq V: the value repeated
kh_times:
    ; ka_rest is "N db V": N is the first word, the rest is a data line
    mov  rsi, [rel ka_rest]
    call ka_getword
    push rsi
    lea  rsi, [rel ka_word]
    mov  qword [rel ka_unres], 0
    call ka_eval
    pop  rsi
    test rdx, rdx
    jz   kh_bad
    cmp  qword [rel ka_unres], 0
    jne  .unknown
    mov  r14, rax                    ; count
    call ka_skipb
    call ka_getword
    mov  r12, 1
    lea  rcx, [rel ka_word]
    lea  rdx, [rel kd_db]
    call ka_streq
    test rax, rax
    jnz  .size
    mov  r12, 2
    lea  rcx, [rel ka_word]
    lea  rdx, [rel kd_dw]
    call ka_streq
    test rax, rax
    jnz  .size
    mov  r12, 4
    lea  rcx, [rel ka_word]
    lea  rdx, [rel kd_dd]
    call ka_streq
    test rax, rax
    jnz  .size
    mov  r12, 8
    lea  rcx, [rel ka_word]
    lea  rdx, [rel kd_dq]
    call ka_streq
    test rax, rax
    jnz  .size
    jmp  kh_bad
.size:
    call ka_skipb
    call ka_eval
    test rdx, rdx
    jz   kh_bad
    mov  r15, rax
    jmp  .rep
.rep:
    test r14, r14
    jz   .done
    mov  rax, r15
    mov  r8, r12
    call ka_emit_n
    dec  r14
    jmp  .rep
.done:
    ret
.unknown:
    mov  ecx, 6
    call ka_err
    ret

; ==============================================================================
; HELPERS FOR INSTRUCTIONS
; ==============================================================================

; ka_rrr(ecx = base word, r12d = Rd, r13d = Rn, r14d = Rm): emit
ka_rrr:
    mov  eax, r14d
    and  eax, 31
    shl  eax, 16
    or   ecx, eax
    mov  eax, r13d
    and  eax, 31
    shl  eax, 5
    or   ecx, eax
    mov  eax, r12d
    and  eax, 31
    or   ecx, eax
    call ka_emit32
    ret

; ka_need(ecx = count) -> rax = 1 when there are exactly that many operands
ka_need:
    xor  eax, eax
    cmp  rcx, [rel ka_nops]
    jne  .o
    mov  eax, 1
    jmp  .o
.o:
    ret

; ka_sf(eax = class) -> eax = 0x80000000 for an x register, 0 for w
ka_sf:
    cmp  eax, 2
    je   .w
    mov  eax, 0x80000000
    ret
.w:
    xor  eax, eax
    ret

; ==============================================================================
; MOV AND THE WIDE IMMEDIATES
; ==============================================================================

; mov Rd, Rm | mov Rd, #imm | mov to or from sp
kh_mov:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    test eax, eax
    jz   kh_bad
    cmp  eax, 7
    je   .vmov
    cmp  eax, 3
    jae  .rd_sp_or_fp
    mov  r15d, eax                   ; class of Rd
    mov  r12d, edx
    jmp  .src
.vmov:
    ; mov vD.16b, vN.16b is orr vD.16b, vN.16b, vN.16b
    mov  r12d, edx
    mov  ecx, 1
    call ka_opreg
    cmp  eax, 7
    jne  kh_bad
    mov  r13d, edx
    mov  r14d, edx
    mov  ecx, 0x4EA01C00
    call ka_rrr
    ret
.rd_sp_or_fp:
    cmp  eax, 5
    jne  kh_bad
    mov  r15d, 1
    mov  r12d, 31
    jmp  .from_sp
.src:
    mov  ecx, 1
    call ka_opreg
    test eax, eax
    jz   .imm
    cmp  eax, 5
    je   .from_sp
    cmp  eax, r15d
    jne  kh_bad
    ; ORR Rd, ZR, Rm
    mov  r14d, edx
    mov  r13d, 31
    mov  eax, r15d
    call ka_sf
    mov  ecx, 0x2A000000
    or   ecx, eax
    call ka_rrr
    ret
.from_sp:
    ; ADD Rd, Rn, #0 -- one side is sp
    mov  ecx, 1
    call ka_opreg
    cmp  eax, 5
    je   .sp_src
    cmp  eax, 1
    jne  kh_bad
    jmp  .sp_src
.sp_src:
    mov  r13d, edx
    mov  ecx, 0x91000000
    mov  r14d, 0
    mov  eax, r13d
    and  eax, 31
    shl  eax, 5
    or   ecx, eax
    mov  eax, r12d
    and  eax, 31
    or   ecx, eax
    call ka_emit32
    ret
.imm:
    mov  ecx, 1
    mov  qword [rel ka_unres], 0
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    mov  r13, rax
    mov  r14d, r15d
    jmp  ka_movimm

; ka_movimm(r12d = Rd, r13 = value, r14d = class): MOVZ/MOVN then MOVK.
; How many words a value takes depends on the value; pass one records it
; per occurrence, so pass two writes exactly as many even when the value
; was not known yet (padding with a MOVK that repeats a chunk).
ka_movimm:
    mov  r15d, 4                     ; chunks
    cmp  r14d, 2
    jne  .w64
    mov  r15d, 2
    mov  eax, r13d
    mov  r13, rax                    ; 32 bits
    jmp  .w64
.w64:
    ; nz = chunks that are not 0, nf = chunks that are not 0xFFFF
    xor  r8d, r8d
    xor  r9d, r9d
    xor  ecx, ecx
    jmp  .cnt
.cnt:
    cmp  ecx, r15d
    jae  .counted
    mov  rax, r13
    mov  edx, ecx
    shl  edx, 4
    push rcx
    mov  ecx, edx
    shr  rax, cl
    pop  rcx
    and  eax, 0xFFFF
    test eax, eax
    jz   .c1
    inc  r8d
    jmp  .c1
.c1:
    cmp  eax, 0xFFFF
    je   .c2
    inc  r9d
    jmp  .c2
.c2:
    inc  ecx
    jmp  .cnt
.counted:
    ; build the sequence in ka_seq, its length in rbx
    xor  ebx, ebx
    mov  eax, r14d
    call ka_sf
    mov  r10d, eax                   ; sf bit
    cmp  r9d, r8d
    jb   .use_movn
    ; MOVZ: first nonzero chunk (chunk 0 when the value is zero)
    mov  r11d, 0x52800000
    xor  edi, edi                    ; inverted chunks: no
    jmp  .build
.use_movn:
    mov  r11d, 0x12800000
    mov  edi, 1
    jmp  .build
.build:
    xor  ecx, ecx
    xor  esi, esi                    ; first word written: no
    jmp  .bl
.bl:
    cmp  ecx, r15d
    jae  .built
    mov  rax, r13
    mov  edx, ecx
    shl  edx, 4
    push rcx
    mov  ecx, edx
    shr  rax, cl
    pop  rcx
    and  eax, 0xFFFF
    ; skip the chunks the first word already gives
    test edi, edi
    jnz  .skip_ff
    test eax, eax
    jz   .bnext
    jmp  .emitc
.skip_ff:
    cmp  eax, 0xFFFF
    je   .bnext
    jmp  .emitc
.emitc:
    test esi, esi
    jnz  .movk
    ; the first word: MOVZ or MOVN with this chunk
    test edi, edi
    jz   .first
    xor  eax, 0xFFFF
    jmp  .first
.first:
    mov  edx, r11d
    mov  esi, 1
    jmp  .put
.movk:
    mov  edx, 0x72800000
    jmp  .put
.put:
    or   edx, r10d
    shl  eax, 5
    or   edx, eax
    mov  eax, ecx
    shl  eax, 21
    or   edx, eax
    mov  eax, r12d
    and  eax, 31
    or   edx, eax
    lea  rax, [rel ka_seq]
    mov  [rax + rbx*4], edx
    inc  rbx
    jmp  .bnext
.bnext:
    inc  ecx
    jmp  .bl
.built:
    test esi, esi
    jnz  .have
    ; every chunk was skipped: the value is 0 (MOVZ #0) or all ones (MOVN #0)
    mov  edx, r11d
    or   edx, r10d
    mov  eax, r12d
    and  eax, 31
    or   edx, eax
    lea  rax, [rel ka_seq]
    mov  [rax], edx
    mov  ebx, 1
    jmp  .have
.have:
    ; the size recorded for this occurrence
    mov  rcx, [rel ka_movseq]
    inc  qword [rel ka_movseq]
    cmp  rcx, 1048575
    jae  .sized
    lea  rdx, [rel ka_movsz]
    cmp  qword [rel ka_pass], 1
    jne  .p2
    mov  rax, rbx
    cmp  qword [rel ka_unres], 0
    je   .rec
    mov  eax, r15d                   ; unknown yet: room for every chunk
    jmp  .rec
.rec:
    mov  [rdx + rcx], al
    jmp  .pad
.p2:
    push rcx
    push rdx
    call ka_undef_check
    pop  rdx
    pop  rcx
    movzx eax, byte [rdx + rcx]
    cmp  rax, rbx
    jb   .grew
    ; pad with MOVK of chunk 0, which writes what is already there
    jmp  .pad
.pad:
    cmp  rbx, rax
    jae  .sized
    mov  edx, 0x72800000
    or   edx, r10d
    push rax
    mov  rax, r13
    and  eax, 0xFFFF
    shl  eax, 5
    or   edx, eax
    mov  eax, r12d
    and  eax, 31
    or   edx, eax
    lea  rax, [rel ka_seq]
    mov  [rax + rbx*4], edx
    pop  rax
    inc  rbx
    jmp  .pad
.grew:
    mov  ecx, 6
    call ka_err
    jmp  .sized
.sized:
    xor  r8d, r8d
    jmp  .out
.out:
    cmp  r8, rbx
    jae  .done
    lea  rax, [rel ka_seq]
    mov  ecx, [rax + r8*4]
    push r8
    call ka_emit32
    pop  r8
    inc  r8
    jmp  .out
.done:
    ret

; movz / movn / movk Rd, #imm16 {, lsl #s}
kh_movz:
    mov  r15d, 0x52800000
    jmp  kh_movw
kh_movn:
    mov  r15d, 0x12800000
    jmp  kh_movw
kh_movk:
    mov  r15d, 0x72800000
    jmp  kh_movw
kh_movw:
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    je   .rd
    cmp  eax, 2
    jne  kh_bad
    jmp  .rd
.rd:
    mov  r12d, edx
    mov  r14d, eax
    call ka_sf
    or   r15d, eax
    mov  ecx, 1
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    cmp  rax, 0xFFFF
    ja   kh_range
    mov  r13, rax
    xor  ebx, ebx                    ; hw
    cmp  qword [rel ka_nops], 3
    jb   .enc
    mov  ecx, 2
    call ka_op
    call ka_shiftop
    test rax, rax
    jnz  kh_bad
    test rdx, 15
    jnz  kh_range
    mov  rbx, rdx
    shr  rbx, 4
    cmp  r14d, 2
    jne  .hw64
    cmp  rbx, 1
    ja   kh_range
    jmp  .enc
.hw64:
    cmp  rbx, 3
    ja   kh_range
    jmp  .enc
.enc:
    mov  ecx, r15d
    mov  eax, ebx
    shl  eax, 21
    or   ecx, eax
    mov  eax, r13d
    shl  eax, 5
    or   ecx, eax
    mov  eax, r12d
    or   ecx, eax
    call ka_emit32
    ret

; ==============================================================================
; ADD AND SUB
; ==============================================================================
; r15d: 0 add, 1 sub, 2 adds, 3 subs. Operands Rd, Rn, Rm{, shift #n} or #imm.
kh_add:
    xor  r15d, r15d
    jmp  kh_addsub
kh_sub:
    mov  r15d, 1
    jmp  kh_addsub
kh_adds:
    mov  r15d, 2
    jmp  kh_addsub
kh_subs:
    mov  r15d, 3
    jmp  kh_addsub
kh_addsub:
    cmp  qword [rel ka_nops], 3
    jb   kh_bad
    cmp  qword [rel ka_nops], 4
    ja   kh_bad
    xor  ecx, ecx
    call ka_opreg
    test eax, eax
    jz   kh_bad
    mov  ebx, eax                    ; class of Rd (5 = sp)
    mov  r12d, edx
    mov  ecx, 1
    call ka_opreg
    test eax, eax
    jz   kh_bad
    mov  edi, eax                    ; class of Rn
    mov  r13d, edx
    mov  ecx, 2
    call ka_opreg
    test eax, eax
    jz   .imm
    ; register form
    mov  r14d, edx
    mov  esi, eax                    ; class of Rm
    ; width: w only when every register is w
    mov  eax, 0x80000000
    cmp  ebx, 2
    jne  .wsel
    xor  eax, eax
    jmp  .wsel
.wsel:
    mov  r10d, eax
    ; sp in Rd or Rn needs the extended-register form
    cmp  ebx, 5
    je   .ext
    cmp  edi, 5
    je   .ext
    ; shifted register: 0x0B000000 add, 0x4B sub, 0x2B adds, 0x6B subs
    mov  ecx, 0x0B000000
    mov  eax, r15d
    and  eax, 1
    shl  eax, 30
    or   ecx, eax
    mov  eax, r15d
    shr  eax, 1
    shl  eax, 29
    or   ecx, eax
    or   ecx, r10d
    cmp  qword [rel ka_nops], 4
    jb   .rr
    push rcx
    mov  ecx, 3
    call ka_op
    call ka_shiftop
    pop  rcx
    cmp  rax, 2
    ja   kh_bad
    cmp  rdx, 63
    ja   kh_range
    shl  eax, 22
    or   ecx, eax
    shl  edx, 10
    or   ecx, edx
    jmp  .rr
.rr:
    call ka_rrr
    ret
.ext:
    ; extended register, UXTX (option 011) for x, UXTW (010) for w
    mov  ecx, 0x0B206000
    cmp  r10d, 0
    jne  .ext64
    mov  ecx, 0x0B204000
    jmp  .ext64
.ext64:
    mov  eax, r15d
    and  eax, 1
    shl  eax, 30
    or   ecx, eax
    mov  eax, r15d
    shr  eax, 1
    shl  eax, 29
    or   ecx, eax
    or   ecx, r10d
    call ka_rrr
    ret
.imm:
    mov  ecx, 2
    mov  qword [rel ka_unres], 0
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    call ka_undef_check
    ; a negative value turns add into sub and back
    test rax, rax
    jns  .pos
    neg  rax
    xor  r15d, 1
    jmp  .pos
.pos:
    xor  r9d, r9d                    ; sh
    cmp  rax, 4095
    jbe  .fits
    test rax, 0xFFF
    jnz  .bigimm
    shr  rax, 12
    cmp  rax, 4095
    ja   .bigimm
    mov  r9d, 1
    jmp  .fits
.bigimm:
    ; out of range: still one word, so the sizes do not move
    mov  ecx, 3
    call ka_err2
    xor  eax, eax
    jmp  .fits
.fits:
    ; 0x11000000 add, 0x51 sub, 0x31 adds, 0x71 subs
    mov  ecx, 0x11000000
    mov  edx, r15d
    and  edx, 1
    shl  edx, 30
    or   ecx, edx
    mov  edx, r15d
    shr  edx, 1
    shl  edx, 29
    or   ecx, edx
    cmp  ebx, 2
    je   .w
    or   ecx, 0x80000000
    jmp  .w
.w:
    shl  r9d, 22
    or   ecx, r9d
    and  eax, 0xFFF
    shl  eax, 10
    or   ecx, eax
    mov  eax, r13d
    shl  eax, 5
    or   ecx, eax
    or   ecx, r12d
    call ka_emit32
    ret

; cmp Rn, op / cmn Rn, op: subs / adds with Rd = zr
kh_cmp:
    mov  r15d, 3
    jmp  kh_cmpn
kh_cmn:
    mov  r15d, 2
    jmp  kh_cmpn
kh_cmpn:
    ; shift the operands right by one, Rd = zr of the same width
    call ka_shift_ops
    xor  ecx, ecx
    call ka_op
    mov  ecx, 1
    call ka_opreg
    lea  rdi, [rel ka_ops]
    mov  byte [rdi], 'x'
    cmp  eax, 2
    jne  .z
    mov  byte [rdi], 'w'
    jmp  .z
.z:
    mov  byte [rdi+1], 'z'
    mov  byte [rdi+2], 'r'
    mov  byte [rdi+3], 0
    jmp  kh_addsub

; neg Rd, Rm: sub Rd, zr, Rm
kh_neg:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    ; ops: Rd, Rm -> Rd, zr, Rm
    lea  rsi, [rel ka_ops]
    lea  rdi, [rel ka_ops]
    add  rsi, 256
    add  rdi, 512
    call ka_copyop
    xor  ecx, ecx
    call ka_opreg
    lea  rdi, [rel ka_ops]
    add  rdi, 256
    mov  byte [rdi], 'x'
    cmp  eax, 2
    jne  .z
    mov  byte [rdi], 'w'
    jmp  .z
.z:
    mov  byte [rdi+1], 'z'
    mov  byte [rdi+2], 'r'
    mov  byte [rdi+3], 0
    mov  qword [rel ka_nops], 3
    mov  r15d, 1
    jmp  kh_addsub

; ka_copyop(rsi = from, rdi = to): one operand string
ka_copyop:
    xor  ecx, ecx
    jmp  .l
.l:
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    test al, al
    jz   .d
    inc  ecx
    cmp  ecx, 255
    jb   .l
    jmp  .d
.d:
    ret

; ka_shift_ops(): operands move one place right; ka_nops grows by one
ka_shift_ops:
    push rsi
    push rdi
    mov  rbx, [rel ka_nops]
    cmp  rbx, 5
    jae  .out
    jmp  .l
.l:
    test rbx, rbx
    jz   .d
    lea  rsi, [rel ka_ops]
    mov  rax, rbx
    dec  rax
    shl  rax, 8
    add  rsi, rax
    lea  rdi, [rsi + 256]
    call ka_copyop
    dec  rbx
    jmp  .l
.d:
    inc  qword [rel ka_nops]
    jmp  .out
.out:
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; MULTIPLY AND DIVIDE
; ==============================================================================
; ka_rrr_w(ecx = 64-bit base): Rd, Rn, Rm from operands 0..2, same width
ka_three:
    push rcx
    mov  ecx, 3
    call ka_need
    pop  rcx
    test rax, rax
    jz   .bad
    push rcx
    xor  ecx, ecx
    call ka_opreg
    pop  rcx
    cmp  eax, 1
    je   .x
    cmp  eax, 2
    jne  .bad
    and  ecx, 0x7FFFFFFF
    jmp  .x
.x:
    mov  r15d, eax
    mov  r12d, edx
    push rcx
    mov  ecx, 1
    call ka_opreg
    pop  rcx
    cmp  eax, r15d
    jne  .bad
    mov  r13d, edx
    push rcx
    mov  ecx, 2
    call ka_opreg
    pop  rcx
    cmp  eax, r15d
    jne  .bad
    mov  r14d, edx
    call ka_rrr
    mov  eax, 1
    ret
.bad:
    xor  eax, eax
    ret

kh_mul:
    mov  ecx, 0x9B007C00             ; MADD with zr as the addend
    jmp  kh_three
kh_sdiv:
    mov  ecx, 0x9AC00C00
    jmp  kh_three
kh_udiv:
    mov  ecx, 0x9AC00800
    jmp  kh_three
kh_three:
    call ka_three
    test eax, eax
    jz   kh_bad
    ret

; madd / msub Rd, Rn, Rm, Ra
kh_madd:
    mov  ebx, 0x9B000000
    jmp  kh_mfour
kh_msub:
    mov  ebx, 0x9B008000
    jmp  kh_mfour
kh_mfour:
    mov  ecx, 4
    call ka_need
    test rax, rax
    jz   kh_bad
    mov  ecx, 3
    call ka_opreg
    test eax, eax
    jz   kh_bad
    shl  edx, 10
    or   ebx, edx
    mov  qword [rel ka_nops], 3
    mov  ecx, ebx
    call ka_three
    test eax, eax
    jz   kh_bad
    ret

; ==============================================================================
; LOGICAL
; ==============================================================================
; r15d: register base (64-bit), r14d: immediate base (0 = no immediate form)
kh_and:
    mov  r15d, 0x8A000000
    mov  r14d, 0x92000000
    jmp  kh_logic
kh_orr:
    mov  r15d, 0xAA000000
    mov  r14d, 0xB2000000
    jmp  kh_logic
kh_eor:
    mov  r15d, 0xCA000000
    mov  r14d, 0xD2000000
    jmp  kh_logic
kh_ands:
    mov  r15d, 0xEA000000
    mov  r14d, 0xF2000000
    jmp  kh_logic
kh_bic:
    mov  r15d, 0x8A200000
    xor  r14d, r14d
    jmp  kh_logic
kh_orn:
    mov  r15d, 0xAA200000
    xor  r14d, r14d
    jmp  kh_logic
kh_eon:
    mov  r15d, 0xCA200000
    xor  r14d, r14d
    jmp  kh_logic
kh_logic:
    ; vN.16b: three registers, no immediate
    push rcx
    xor  ecx, ecx
    call ka_opreg
    pop  rcx
    cmp  eax, 7
    jne  .scalar
    mov  edi, 0x6E201C00
    cmp  r15d, 0xCA000000
    je   .vec
    mov  edi, 0x4E201C00
    cmp  r15d, 0x8A000000
    je   .vec
    mov  edi, 0x4EA01C00
    cmp  r15d, 0xAA000000
    je   .vec
    jmp  kh_bad
.vec:
    mov  ecx, edi
    mov  edx, 7
    call ka_vec3
    test eax, eax
    jz   kh_bad
    ret
.scalar:
    cmp  qword [rel ka_nops], 3
    jb   kh_bad
    cmp  qword [rel ka_nops], 4
    ja   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    je   .rd
    cmp  eax, 5
    je   .rd_sp
    cmp  eax, 2
    jne  kh_bad
    jmp  .rd
.rd_sp:
    ; only the immediate forms of and/orr/eor write sp
    mov  eax, 1
    jmp  .rd
.rd:
    mov  ebx, eax                    ; width class
    mov  r12d, edx
    mov  ecx, 1
    call ka_opreg
    cmp  eax, ebx
    jne  kh_bad
    mov  r13d, edx
    mov  ecx, 2
    call ka_opreg
    test eax, eax
    jz   .imm
    cmp  eax, ebx
    jne  kh_bad
    push rdx
    mov  ecx, r15d
    cmp  ebx, 2
    jne  .shf
    and  ecx, 0x7FFFFFFF
    jmp  .shf
.shf:
    cmp  qword [rel ka_nops], 4
    jb   .noshift
    push rcx
    mov  ecx, 3
    call ka_op
    call ka_shiftop
    pop  rcx
    cmp  rax, -1
    je   .badpop
    cmp  rdx, 63
    ja   .rangepop
    shl  eax, 22
    or   ecx, eax
    shl  edx, 10
    or   ecx, edx
    jmp  .noshift
.noshift:
    pop  rdx
    mov  r14d, edx
    call ka_rrr
    ret
.badpop:
    pop  rdx
    jmp  kh_bad
.rangepop:
    pop  rdx
    jmp  kh_range
.imm:
    test r14d, r14d
    jz   kh_bad
    mov  ecx, 2
    mov  qword [rel ka_unres], 0
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    call ka_undef_check
    mov  rdx, 64
    cmp  ebx, 2
    jne  .enc
    mov  rdx, 32
    and  r14d, 0x7FFFFFFF
    jmp  .enc
.enc:
    call ka_bitmask
    cmp  rax, -1
    je   .nomask
    ; rax = N:immr:imms in bits 22..10 order (N<<12 | immr<<6 | imms)
    shl  eax, 10
    or   r14d, eax
    mov  eax, r13d
    shl  eax, 5
    or   r14d, eax
    or   r14d, r12d
    mov  ecx, r14d
    call ka_emit32
    ret
.nomask:
    mov  ecx, 7
    call ka_err2
    ; still one word
    xor  ecx, ecx
    call ka_emit32
    ret

; ka_bitmask(rax = value, rdx = width 32 or 64) -> rax = N<<12 | immr<<6 |
; imms, or -1 when the value is not a repeated rotated run of ones
ka_bitmask:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rdx                    ; width
    cmp  r12, 32
    jne  .w64
    mov  ebx, eax
    mov  rax, rbx
    ; replicate the 32-bit value so the search below works on 64 bits
    mov  rbx, rax
    shl  rbx, 32
    or   rax, rbx
    jmp  .w64
.w64:
    mov  r13, rax                    ; value
    test r13, r13
    jz   .no
    mov  rax, r13
    not  rax
    test rax, rax
    jz   .no
    ; the smallest element size e that repeats across 64 bits
    mov  rsi, 2
    jmp  .size
.size:
    cmp  rsi, 64
    ja   .no
    cmp  rsi, r12
    ja   .no
    ; mask of e bits
    mov  rcx, rsi
    cmp  rcx, 64
    je   .m64
    mov  rdi, 1
    shl  rdi, cl
    dec  rdi
    jmp  .mask
.m64:
    mov  rdi, -1
    jmp  .mask
.mask:
    ; does value == replicate(value & mask, e)?
    mov  rbx, r13
    and  rbx, rdi                    ; element
    mov  rax, rbx
    mov  rcx, rsi
    jmp  .rep
.rep:
    cmp  rcx, 64
    jae  .repd
    mov  rdx, rax
    shl  rdx, cl
    or   rax, rdx
    shl  rcx, 1
    jmp  .rep
.repd:
    cmp  rax, r13
    je   .found
    shl  rsi, 1
    jmp  .size
.found:
    ; rbx = element of rsi bits; count its ones
    xor  r8d, r8d
    mov  rax, rbx
    jmp  .pop
.pop:
    test rax, rax
    jz   .popd
    mov  rdx, rax
    and  rdx, 1
    add  r8, rdx
    shr  rax, 1
    jmp  .pop
.popd:
    ; ones must be 1..e-1, and the element a rotation of (1<<ones)-1
    test r8, r8
    jz   .no
    cmp  r8, rsi
    jae  .no
    mov  rcx, r8
    mov  r9, 1
    shl  r9, cl
    dec  r9                          ; the run, unrotated
    xor  r10d, r10d                  ; rotation
    jmp  .rot
.rot:
    cmp  r10, rsi
    jae  .no
    ; ror(run, r10) within rsi bits
    mov  rax, r9
    mov  rcx, r10
    shr  rax, cl
    mov  rdx, r9
    mov  rcx, rsi
    sub  rcx, r10
    cmp  rcx, 64
    jae  .noleft
    shl  rdx, cl
    jmp  .left
.noleft:
    xor  edx, edx
    jmp  .left
.left:
    or   rax, rdx
    and  rax, rdi
    cmp  rax, rbx
    je   .rotfound
    inc  r10
    jmp  .rot
.rotfound:
    ; imms = (~(e*2 - 1) & 0x3F) | (ones - 1); N = 1 for e = 64
    mov  rax, rsi
    shl  rax, 1
    dec  rax
    not  rax
    and  rax, 0x3F
    mov  rdx, r8
    dec  rdx
    or   rax, rdx                    ; imms
    xor  ecx, ecx
    cmp  rsi, 64
    jne  .nn
    mov  ecx, 1
    mov  rax, r8
    dec  rax
    jmp  .nn
.nn:
    shl  ecx, 12
    mov  rdx, r10
    shl  rdx, 6
    or   rax, rdx
    or   rax, rcx
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret
.no:
    mov  rax, -1
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; tst Rn, op: ands zr, Rn, op
kh_tst:
    call ka_shift_ops
    mov  ecx, 1
    call ka_opreg
    lea  rdi, [rel ka_ops]
    mov  byte [rdi], 'x'
    cmp  eax, 2
    jne  .z
    mov  byte [rdi], 'w'
    jmp  .z
.z:
    mov  byte [rdi+1], 'z'
    mov  byte [rdi+2], 'r'
    mov  byte [rdi+3], 0
    jmp  kh_ands

; mvn Rd, Rm{, shift}: orn Rd, zr, Rm
kh_mvn:
    ; Rd, Rm[, sh] -> Rd, zr, Rm[, sh]
    mov  rbx, [rel ka_nops]
    cmp  rbx, 2
    jb   kh_bad
    cmp  rbx, 3
    ja   kh_bad
    cmp  rbx, 3
    jne  .two
    lea  rsi, [rel ka_ops]
    add  rsi, 512
    lea  rdi, [rel ka_ops]
    add  rdi, 768
    call ka_copyop
    jmp  .two
.two:
    lea  rsi, [rel ka_ops]
    add  rsi, 256
    lea  rdi, [rel ka_ops]
    add  rdi, 512
    call ka_copyop
    inc  qword [rel ka_nops]
    xor  ecx, ecx
    call ka_opreg
    lea  rdi, [rel ka_ops]
    add  rdi, 256
    mov  byte [rdi], 'x'
    cmp  eax, 2
    jne  .z
    mov  byte [rdi], 'w'
    jmp  .z
.z:
    mov  byte [rdi+1], 'z'
    mov  byte [rdi+2], 'r'
    mov  byte [rdi+3], 0
    jmp  kh_orn

; ==============================================================================
; SHIFTS
; ==============================================================================
; lsl/lsr/asr/ror Rd, Rn, Rm  -> LSLV & co.
; lsl/lsr/asr/ror Rd, Rn, #s  -> UBFM / SBFM / EXTR
kh_lsl:
    xor  r15d, r15d
    jmp  kh_shift
kh_lsr:
    mov  r15d, 1
    jmp  kh_shift
kh_asr:
    mov  r15d, 2
    jmp  kh_shift
kh_ror:
    mov  r15d, 3
    jmp  kh_shift
kh_shift:
    mov  ecx, 3
    call ka_need
    test rax, rax
    jz   kh_bad
    mov  ecx, 2
    call ka_opreg
    test eax, eax
    jz   .imm
    ; register: 0x9AC02000 + type * 0x400
    mov  ecx, r15d
    shl  ecx, 10
    or   ecx, 0x9AC02000
    call ka_three
    test eax, eax
    jz   kh_bad
    ret
.imm:
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    je   .w
    cmp  eax, 2
    jne  kh_bad
    jmp  .w
.w:
    mov  ebx, eax
    mov  r12d, edx
    mov  ecx, 1
    call ka_opreg
    cmp  eax, ebx
    jne  kh_bad
    mov  r13d, edx
    mov  ecx, 2
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    mov  r8, 63
    mov  r9d, 0xD3400000             ; UBFM x (N=1)
    mov  r10d, 0x93400000            ; SBFM x
    mov  r11d, 0x93C00000            ; EXTR x
    cmp  ebx, 2
    jne  .chk
    mov  r8, 31
    mov  r9d, 0x53000000
    mov  r10d, 0x13000000
    mov  r11d, 0x13800000
    jmp  .chk
.chk:
    cmp  rax, r8
    ja   .range
    mov  rsi, rax                    ; amount
    cmp  r15d, 0
    je   .lsl
    cmp  r15d, 1
    je   .lsr
    cmp  r15d, 2
    je   .asr
    ; ror: EXTR Rd, Rn, Rn, #s
    mov  ecx, r11d
    mov  eax, r13d
    shl  eax, 16
    or   ecx, eax
    mov  eax, esi
    shl  eax, 10
    or   ecx, eax
    jmp  .regs
.lsl:
    ; immr = (-s) mod width, imms = width-1-s
    mov  ecx, r9d
    mov  rax, r8
    inc  rax
    sub  rax, rsi
    and  rax, r8
    shl  eax, 16
    or   ecx, eax
    mov  rax, r8
    sub  rax, rsi
    shl  eax, 10
    or   ecx, eax
    jmp  .regs
.lsr:
    mov  ecx, r9d
    jmp  .right
.asr:
    mov  ecx, r10d
    jmp  .right
.right:
    mov  eax, esi
    shl  eax, 16
    or   ecx, eax
    mov  eax, r8d
    shl  eax, 10
    or   ecx, eax
    jmp  .regs
.regs:
    mov  eax, r13d
    shl  eax, 5
    or   ecx, eax
    or   ecx, r12d
    call ka_emit32
    ret
.range:
    mov  ecx, 3
    call ka_err2
    xor  ecx, ecx
    call ka_emit32
    ret

; ==============================================================================
; CONDITIONAL SELECT AND EXTENSIONS
; ==============================================================================
; cset Rd, cond: CSINC Rd, zr, zr, invert(cond)
kh_cset:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    je   .w
    cmp  eax, 2
    jne  kh_bad
    jmp  .w
.w:
    call ka_sf
    mov  ebx, eax
    mov  r12d, edx
    mov  ecx, 1
    call ka_op
    call ka_cond
    cmp  rax, 14
    jae  kh_bad
    xor  eax, 1
    shl  eax, 12
    mov  ecx, 0x1A9F07E0
    or   ecx, ebx
    or   ecx, eax
    or   ecx, r12d
    call ka_emit32
    ret

; csel/csinc/csneg Rd, Rn, Rm, cond
kh_csel:
    mov  ebx, 0x9A800000
    jmp  kh_csx
kh_csinc:
    mov  ebx, 0x9A800400
    jmp  kh_csx
kh_csneg:
    mov  ebx, 0xDA800400
    jmp  kh_csx
kh_csx:
    mov  ecx, 4
    call ka_need
    test rax, rax
    jz   kh_bad
    mov  ecx, 3
    call ka_op
    call ka_cond
    cmp  rax, -1
    je   kh_bad
    shl  eax, 12
    or   ebx, eax
    mov  qword [rel ka_nops], 3
    mov  ecx, ebx
    call ka_three
    test eax, eax
    jz   kh_bad
    ret

; sxtb/sxth Rd, Wn (Rd x or w), sxtw Xd, Wn, uxtb/uxth Wd, Wn
kh_sxtb:
    mov  ebx, 7
    mov  r14d, 1
    jmp  kh_ext
kh_sxth:
    mov  ebx, 15
    mov  r14d, 1
    jmp  kh_ext
kh_sxtw:
    mov  ebx, 31
    mov  r14d, 1
    jmp  kh_ext
kh_uxtb:
    mov  ebx, 7
    xor  r14d, r14d
    jmp  kh_ext
kh_uxth:
    mov  ebx, 15
    xor  r14d, r14d
    jmp  kh_ext
kh_ext:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    je   .rd
    cmp  eax, 2
    jne  kh_bad
    jmp  .rd
.rd:
    mov  r15d, eax
    mov  r12d, edx
    mov  ecx, 1
    call ka_opreg
    cmp  eax, 2
    jne  kh_bad
    mov  r13d, edx
    ; SBFM / UBFM Rd, Rn, #0, #imms
    test r14d, r14d
    jz   .u
    mov  ecx, 0x13000000
    cmp  r15d, 1
    jne  .enc
    mov  ecx, 0x93400000
    jmp  .enc
.u:
    ; unsigned forms write a w register (the upper half is zeroed)
    mov  ecx, 0x53000000
    jmp  .enc
.enc:
    mov  eax, ebx
    shl  eax, 10
    or   ecx, eax
    mov  eax, r13d
    shl  eax, 5
    or   ecx, eax
    or   ecx, r12d
    call ka_emit32
    ret

; ==============================================================================
; LOADS AND STORES
; ==============================================================================
; ka_ldst(ebx = unsigned-offset opcode, r15d = log2 of the size): Rt is
; operand 0 (checked by the caller), memory operand 1, maybe a post-index 2.
; r12d = Rt. r14d = 1 forces the unscaled form (ldur/stur).
ka_ldst:
    mov  ecx, 1
    call ka_op
    cmp  byte [rsi], '['
    jne  .literal
    call ka_mem
    test rax, rax
    jz   kh_bad
    mov  r13, [rel km_base]
    cmp  qword [rel ka_nops], 3
    je   .post
    cmp  qword [rel ka_nops], 2
    jne  kh_bad
    mov  rax, [rel km_kind]
    cmp  rax, 2
    je   .reg
    mov  rax, [rel km_imm]
    cmp  qword [rel km_pre], 0
    jne  .pre
    test r14d, r14d
    jnz  .unscaled
    ; unsigned offset when aligned and in range
    test rax, rax
    js   .unscaled
    mov  rcx, r15
    mov  rdx, 1
    shl  rdx, cl
    dec  rdx
    test rax, rdx
    jnz  .unscaled
    shr  rax, cl
    cmp  rax, 4095
    ja   .unscaled_or_range
    shl  eax, 10
    mov  ecx, ebx
    or   ecx, eax
    jmp  .regs
.unscaled_or_range:
    mov  rax, [rel km_imm]
    jmp  .unscaled
.unscaled:
    cmp  rax, -256
    jl   .range
    cmp  rax, 255
    jg   .range
    and  eax, 0x1FF
    shl  eax, 12
    mov  ecx, ebx
    and  ecx, 0xFEFFFFFF
    or   ecx, eax
    jmp  .regs
.pre:
    cmp  rax, -256
    jl   .range
    cmp  rax, 255
    jg   .range
    and  eax, 0x1FF
    shl  eax, 12
    mov  ecx, ebx
    and  ecx, 0xFEFFFFFF
    or   ecx, eax
    or   ecx, 0xC00
    jmp  .regs
.post:
    ; [Xn], #imm
    cmp  qword [rel km_kind], 0
    jne  kh_bad
    mov  ecx, 2
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    cmp  rax, -256
    jl   .range
    cmp  rax, 255
    jg   .range
    and  eax, 0x1FF
    shl  eax, 12
    mov  ecx, ebx
    and  ecx, 0xFEFFFFFF
    or   ecx, eax
    or   ecx, 0x400
    jmp  .regs
.reg:
    ; [Xn, Rm{, ext #s}]: option 011 lsl, 110 sxtw, 010 uxtw, 111 sxtx
    mov  ecx, ebx
    and  ecx, 0xFEFFFFFF
    or   ecx, 0x00200800
    mov  rax, [rel km_ext]
    mov  edx, 3
    cmp  rax, 1
    jne  .o2
    mov  edx, 6
    jmp  .opt
.o2:
    cmp  rax, 2
    jne  .o3
    mov  edx, 2
    jmp  .opt
.o3:
    cmp  rax, 3
    jne  .opt
    mov  edx, 7
    jmp  .opt
.opt:
    shl  edx, 13
    or   ecx, edx
    mov  rax, [rel km_amt]
    cmp  rax, -1
    je   .no_s
    test rax, rax
    jz   .no_s
    cmp  rax, r15
    jne  .range
    or   ecx, 0x1000
    jmp  .no_s
.no_s:
    mov  rax, [rel km_idx]
    and  eax, 31
    shl  eax, 16
    or   ecx, eax
    jmp  .regs
.literal:
    ; ldr Rt, label: PC-relative, +-1 MB (loads only)
    test ebx, 0x00400000
    jz   kh_bad
    mov  qword [rel ka_unres], 0
    call ka_eval
    test rdx, rdx
    jz   kh_bad
    call ka_undef_check
    mov  rdx, rax
    call ka_pc
    sub  rdx, rax
    test rdx, 3
    jnz  .lit_range
    sar  rdx, 2
    cmp  rdx, -262144
    jl   .lit_range
    cmp  rdx, 262143
    jg   .lit_range
    jmp  .lit_ok
.lit_range:
    cmp  qword [rel ka_pass], 2
    jne  .lit_zero
    mov  ecx, 3
    call ka_err
    jmp  .lit_zero
.lit_zero:
    xor  edx, edx
    jmp  .lit_ok
.lit_ok:
    ; 0x58 x, 0x18 w, 0x5C d, 0x1C s, 0x98 ldrsw
    mov  ecx, 0x58000000
    cmp  ebx, 0xF9400000
    je   .lit_enc
    mov  ecx, 0x18000000
    cmp  ebx, 0xB9400000
    je   .lit_enc
    mov  ecx, 0x5C000000
    cmp  ebx, 0xFD400000
    je   .lit_enc
    mov  ecx, 0x1C000000
    cmp  ebx, 0xBD400000
    je   .lit_enc
    mov  ecx, 0x98000000
    cmp  ebx, 0xB9800000
    je   .lit_enc
    jmp  kh_bad
.lit_enc:
    and  edx, 0x7FFFF
    shl  edx, 5
    or   ecx, edx
    or   ecx, r12d
    call ka_emit32
    ret
.regs:
    mov  eax, r13d
    and  eax, 31
    shl  eax, 5
    or   ecx, eax
    mov  eax, r12d
    and  eax, 31
    or   ecx, eax
    call ka_emit32
    ret
.range:
    mov  ecx, 3
    call ka_err2
    xor  ecx, ecx
    call ka_emit32
    ret

; ldr/str: the size follows the register class
kh_ldr:
    mov  r14d, 0
    mov  edi, 1
    jmp  kh_ldstr
kh_str:
    mov  r14d, 0
    xor  edi, edi
    jmp  kh_ldstr
kh_ldur:
    mov  r14d, 1
    mov  edi, 1
    jmp  kh_ldstr
kh_stur:
    mov  r14d, 1
    xor  edi, edi
    jmp  kh_ldstr
kh_ldstr:
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    cmp  eax, 1
    je   .x
    cmp  eax, 2
    je   .w
    cmp  eax, 3
    je   .d
    cmp  eax, 4
    je   .s
    cmp  eax, 6
    je   .q
    jmp  kh_bad
.q:
    mov  ebx, 0x3D800000
    mov  r15d, 4
    jmp  .go
.x:
    mov  ebx, 0xF9000000
    mov  r15d, 3
    jmp  .go
.w:
    mov  ebx, 0xB9000000
    mov  r15d, 2
    jmp  .go
.d:
    mov  ebx, 0xFD000000
    mov  r15d, 3
    jmp  .go
.s:
    mov  ebx, 0xBD000000
    mov  r15d, 2
    jmp  .go
.go:
    test edi, edi
    jz   .st
    or   ebx, 0x00400000
    jmp  .st
.st:
    jmp  ka_ldst

; the sized forms take a w register (ldrsb/ldrsh x or w, ldrsw x)
kh_ldrb:
    mov  ebx, 0x39400000
    xor  r15d, r15d
    jmp  kh_ldsz_w
kh_strb:
    mov  ebx, 0x39000000
    xor  r15d, r15d
    jmp  kh_ldsz_w
kh_ldrh:
    mov  ebx, 0x79400000
    mov  r15d, 1
    jmp  kh_ldsz_w
kh_strh:
    mov  ebx, 0x79000000
    mov  r15d, 1
    jmp  kh_ldsz_w
; the unscaled byte and halfword forms: [Xn, #-N], which is how a packed
; local array element is stored below the frame pointer
kh_ldurb:
    mov  ebx, 0x39400000
    xor  r15d, r15d
    jmp  kh_ldsz_u
kh_sturb:
    mov  ebx, 0x39000000
    xor  r15d, r15d
    jmp  kh_ldsz_u
kh_ldurh:
    mov  ebx, 0x79400000
    mov  r15d, 1
    jmp  kh_ldsz_u
kh_sturh:
    mov  ebx, 0x79000000
    mov  r15d, 1
    jmp  kh_ldsz_u
kh_ldsz_u:
    mov  r14d, 1
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 2
    jne  kh_bad
    mov  r12d, edx
    jmp  ka_ldst
kh_ldsz_w:
    xor  r14d, r14d
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 2
    jne  kh_bad
    mov  r12d, edx
    jmp  ka_ldst
kh_ldrsb:
    mov  ebx, 0x39800000
    xor  r15d, r15d
    jmp  kh_ldsx
kh_ldrsh:
    mov  ebx, 0x79800000
    mov  r15d, 1
    jmp  kh_ldsx
kh_ldsx:
    xor  r14d, r14d
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    cmp  eax, 1
    je   ka_ldst
    cmp  eax, 2
    jne  kh_bad
    or   ebx, 0x00400000             ; the w forms
    jmp  ka_ldst
kh_ldrsw:
    mov  ebx, 0xB9800000
    mov  r15d, 2
    xor  r14d, r14d
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    jne  kh_bad
    mov  r12d, edx
    jmp  ka_ldst

; ldp/stp Rt1, Rt2, [Xn{, #imm}]{!} | [Xn], #imm
kh_ldp:
    mov  edi, 1
    jmp  kh_pair
kh_stp:
    xor  edi, edi
    jmp  kh_pair
kh_pair:
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    mov  ebx, 0x29000000             ; w: signed offset
    mov  r15d, 2
    cmp  eax, 2
    je   .cls
    mov  ebx, 0xA9000000             ; x
    mov  r15d, 3
    cmp  eax, 1
    je   .cls
    mov  ebx, 0x6D000000             ; d
    cmp  eax, 3
    je   .cls
    jmp  kh_bad
.cls:
    mov  r14d, eax
    mov  ecx, 1
    call ka_opreg
    cmp  eax, r14d
    jne  kh_bad
    mov  r13d, edx
    test edi, edi
    jz   .mem
    or   ebx, 0x00400000
    jmp  .mem
.mem:
    mov  ecx, 2
    call ka_op
    call ka_mem
    test rax, rax
    jz   kh_bad
    cmp  qword [rel km_kind], 2
    je   kh_bad
    mov  rax, [rel km_imm]
    cmp  qword [rel ka_nops], 4
    jne  .notpost
    ; post-index
    cmp  qword [rel km_kind], 0
    jne  kh_bad
    mov  ecx, 3
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    and  ebx, 0xFE7FFFFF             ; bits 24:23 = 01
    or   ebx, 0x00800000
    jmp  .imm7
.notpost:
    cmp  qword [rel ka_nops], 3
    jne  kh_bad
    cmp  qword [rel km_pre], 0
    je   .imm7
    or   ebx, 0x01800000             ; bits 24:23 = 11
    jmp  .imm7
.imm7:
    mov  rcx, r15
    mov  rdx, 1
    shl  rdx, cl
    dec  rdx
    test rax, rdx
    jnz  .range
    sar  rax, cl
    cmp  rax, -64
    jl   .range
    cmp  rax, 63
    jg   .range
    and  eax, 0x7F
    shl  eax, 15
    or   ebx, eax
    mov  eax, r13d
    shl  eax, 10
    or   ebx, eax
    mov  rax, [rel km_base]
    shl  eax, 5
    or   ebx, eax
    or   ebx, r12d
    mov  ecx, ebx
    call ka_emit32
    ret
.range:
    mov  ecx, 3
    call ka_err2
    xor  ecx, ecx
    call ka_emit32
    ret

; exclusive: ldxr/ldaxr Rt, [Xn]; stxr/stlxr Ws, Rt, [Xn]
kh_ldxr:
    mov  ebx, 0xC85F7C00
    jmp  kh_ldex
kh_ldaxr:
    mov  ebx, 0xC85FFC00
    jmp  kh_ldex
kh_ldex:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    cmp  eax, 1
    je   .m
    cmp  eax, 2
    jne  kh_bad
    and  ebx, 0xBFFFFFFF
    jmp  .m
.m:
    mov  ecx, 1
    call ka_op
    call ka_mem
    test rax, rax
    jz   kh_bad
    cmp  qword [rel km_kind], 0
    jne  kh_bad
    mov  rax, [rel km_base]
    shl  eax, 5
    or   ebx, eax
    or   ebx, r12d
    mov  ecx, ebx
    call ka_emit32
    ret
kh_stxr:
    mov  ebx, 0xC8007C00
    jmp  kh_stex
kh_stlxr:
    mov  ebx, 0xC800FC00
    jmp  kh_stex
kh_stex:
    mov  ecx, 3
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 2
    jne  kh_bad
    shl  edx, 16
    or   ebx, edx
    mov  ecx, 1
    call ka_opreg
    mov  r12d, edx
    cmp  eax, 1
    je   .m
    cmp  eax, 2
    jne  kh_bad
    and  ebx, 0xBFFFFFFF
    jmp  .m
.m:
    mov  ecx, 2
    call ka_op
    call ka_mem
    test rax, rax
    jz   kh_bad
    cmp  qword [rel km_kind], 0
    jne  kh_bad
    mov  rax, [rel km_base]
    shl  eax, 5
    or   ebx, eax
    or   ebx, r12d
    mov  ecx, ebx
    call ka_emit32
    ret

; ==============================================================================
; BRANCHES AND ADDRESSES
; ==============================================================================
; ka_target(ecx = operand) -> rax = target - pc (0 when not known yet)
ka_target:
    call ka_op
    mov  qword [rel ka_unres], 0
    call ka_eval
    test rdx, rdx
    jz   .bad
    call ka_undef_check
    cmp  qword [rel ka_unres], 0
    jne  .zero
    mov  rdx, rax
    call ka_pc
    sub  rdx, rax
    mov  rax, rdx
    mov  edx, 1
    ret
.zero:
    xor  eax, eax
    mov  edx, 1
    ret
.bad:
    xor  eax, eax
    xor  edx, edx
    ret

; b / bl label: +-128 MB
kh_b:
    mov  ebx, 0x14000000
    jmp  kh_b26
kh_bl:
    mov  ebx, 0x94000000
    jmp  kh_b26
kh_b26:
    mov  ecx, 1
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_target
    test rdx, rdx
    jz   kh_bad
    sar  rax, 2
    cmp  rax, -33554432
    jl   .range
    cmp  rax, 33554431
    jg   .range
    and  eax, 0x3FFFFFF
    or   ebx, eax
    mov  ecx, ebx
    call ka_emit32
    ret
.range:
    mov  ecx, 3
    call ka_err2
    mov  ecx, ebx
    call ka_emit32
    ret

; b.cond label: +-1 MB
kh_bcond:
    lea  rsi, [rel ka_mnem]
    add  rsi, 2
    call ka_cond
    cmp  rax, -1
    je   .unknown
    mov  ebx, eax
    or   ebx, 0x54000000
    jmp  ka_b19_0
.unknown:
    mov  ecx, 1
    call ka_err2
    ret

; ka_b19_0(ebx = word): label in operand 0, imm19 in bits 23..5
ka_b19_0:
    xor  ecx, ecx
    call ka_target
    test rdx, rdx
    jz   kh_bad
    jmp  ka_b19

ka_b19:
    sar  rax, 2
    cmp  rax, -262144
    jl   .range
    cmp  rax, 262143
    jg   .range
    and  eax, 0x7FFFF
    shl  eax, 5
    or   ebx, eax
    mov  ecx, ebx
    call ka_emit32
    ret
.range:
    mov  ecx, 3
    call ka_err2
    mov  ecx, ebx
    call ka_emit32
    ret

; cbz / cbnz Rt, label
kh_cbz:
    mov  ebx, 0x34000000
    jmp  kh_cb
kh_cbnz:
    mov  ebx, 0x35000000
    jmp  kh_cb
kh_cb:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    je   .x
    cmp  eax, 2
    jne  kh_bad
    jmp  .r
.x:
    or   ebx, 0x80000000
    jmp  .r
.r:
    or   ebx, edx
    mov  ecx, 1
    call ka_target
    test rdx, rdx
    jz   kh_bad
    jmp  ka_b19

; br / blr Xn, ret {Xn}
kh_br:
    mov  ebx, 0xD61F0000
    jmp  kh_breg
kh_blr:
    mov  ebx, 0xD63F0000
    jmp  kh_breg
kh_breg:
    mov  ecx, 1
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    jne  kh_bad
    shl  edx, 5
    or   ebx, edx
    mov  ecx, ebx
    call ka_emit32
    ret
kh_ret:
    mov  ebx, 0xD65F0000
    cmp  qword [rel ka_nops], 0
    jne  kh_breg
    mov  ecx, 0xD65F03C0
    call ka_emit32
    ret

; adr Xd, label: +-1 MB
kh_adr:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    jne  kh_bad
    mov  r12d, edx
    mov  ecx, 1
    call ka_target
    test rdx, rdx
    jz   kh_bad
    cmp  rax, -1048576
    jl   .range
    cmp  rax, 1048575
    jg   .range
    jmp  .enc
.range:
    mov  ecx, 3
    call ka_err2
    xor  eax, eax
    jmp  .enc
.enc:
    mov  ecx, 0x10000000
    jmp  ka_adr_enc

; ka_adr_enc(ecx = base, rax = offset, r12d = Rd): immlo 30:29, immhi 23:5
ka_adr_enc:
    mov  edx, eax
    and  edx, 3
    shl  edx, 29
    or   ecx, edx
    sar  rax, 2
    and  eax, 0x7FFFF
    shl  eax, 5
    or   ecx, eax
    or   ecx, r12d
    call ka_emit32
    ret

; adrp Xd, label: page of the label, +-4 GB
kh_adrp:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    jne  kh_bad
    mov  r12d, edx
    call ka_adrp_word
    ret

; ka_adrp_word(r12d = Rd, operand 1 = label): emits ADRP; rax = label
ka_adrp_word:
    mov  ecx, 1
    call ka_op
    mov  qword [rel ka_unres], 0
    call ka_eval
    test rdx, rdx
    jz   .bad
    call ka_undef_check
    mov  r13, rax                    ; the label's address
    call ka_pc
    mov  rdx, r13
    shr  rdx, 12
    shr  rax, 12
    sub  rdx, rax
    mov  rax, rdx
    cmp  qword [rel ka_unres], 0
    je   .enc
    xor  eax, eax
    jmp  .enc
.enc:
    mov  ecx, 0x90000000
    call ka_adr_enc
    mov  rax, r13
    ret
.bad:
    xor  eax, eax
    mov  r13, rax
    ret

; adrl Xd, label: ADRP Xd, label + ADD Xd, Xd, #(label & 0xFFF) -- any
; address in the image, always two words
kh_adrl:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, 1
    jne  kh_bad
    mov  r12d, edx
    call ka_adrp_word
    mov  rax, r13
    and  eax, 0xFFF
    shl  eax, 10
    mov  ecx, 0x91000000
    or   ecx, eax
    mov  eax, r12d
    shl  eax, 5
    or   ecx, eax
    or   ecx, r12d
    call ka_emit32
    ret

; svc #imm16, nop, dmb ish
kh_svc:
    xor  ecx, ecx
    call ka_imm
    test rdx, rdx
    jz   kh_bad
    and  eax, 0xFFFF
    shl  eax, 5
    mov  ecx, 0xD4000001
    or   ecx, eax
    call ka_emit32
    ret
kh_nop:
    mov  ecx, 0xD503201F
    call ka_emit32
    ret
kh_dmb:
    ; only 'dmb ish', the barrier threads need
    mov  ecx, 0xD5033BBF
    call ka_emit32
    ret

; ==============================================================================
; FLOATING POINT (d = double, s = single)
; ==============================================================================
; fmov: Dd, Dn | Dd, Xn | Xd, Dn | Sd, Wn | Wd, Sn | Sd, Sn
kh_fmov:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    mov  ebx, eax
    mov  ecx, 1
    call ka_opreg
    mov  r13d, edx
    mov  r14d, 0
    ; pick the word by the two classes
    cmp  ebx, 3
    jne  .n1
    cmp  eax, 3
    jne  .n1a
    mov  ecx, 0x1E604000
    jmp  .enc
.n1a:
    cmp  eax, 1
    jne  kh_bad
    mov  ecx, 0x9E670000
    jmp  .enc
.n1:
    cmp  ebx, 1
    jne  .n2
    cmp  eax, 3
    jne  kh_bad
    mov  ecx, 0x9E660000
    jmp  .enc
.n2:
    cmp  ebx, 4
    jne  .n3
    cmp  eax, 4
    jne  .n2a
    mov  ecx, 0x1E204000
    jmp  .enc
.n2a:
    cmp  eax, 2
    jne  kh_bad
    mov  ecx, 0x1E270000
    jmp  .enc
.n3:
    cmp  ebx, 2
    jne  kh_bad
    cmp  eax, 4
    jne  kh_bad
    mov  ecx, 0x1E260000
    jmp  .enc
.enc:
    call ka_rrr
    ret

; ka_fclass(ecx = operand) -> eax = 0 for d, 0x... type bits; edx = number.
; ka_fop3(ecx = base for d): Fd, Fn, Fm of one class; s clears bit 22
ka_fop3:
    push rcx
    mov  ecx, 3
    call ka_need
    pop  rcx
    test rax, rax
    jz   .bad
    push rcx
    xor  ecx, ecx
    call ka_opreg
    pop  rcx
    cmp  eax, 3
    je   .d
    cmp  eax, 4
    jne  .bad
    and  ecx, 0xFFBFFFFF
    jmp  .d
.d:
    mov  r15d, eax
    mov  r12d, edx
    push rcx
    mov  ecx, 1
    call ka_opreg
    pop  rcx
    cmp  eax, r15d
    jne  .bad
    mov  r13d, edx
    push rcx
    mov  ecx, 2
    call ka_opreg
    pop  rcx
    cmp  eax, r15d
    jne  .bad
    mov  r14d, edx
    call ka_rrr
    mov  eax, 1
    ret
.bad:
    xor  eax, eax
    ret

kh_fadd:
    mov  ecx, 0x1E602800
    mov  edi, 0x4E60D400
    jmp  kh_f3
kh_fsub:
    mov  ecx, 0x1E603800
    mov  edi, 0x4EE0D400
    jmp  kh_f3
kh_fmul:
    mov  ecx, 0x1E600800
    mov  edi, 0x6E60DC00
    jmp  kh_f3
kh_fdiv:
    mov  ecx, 0x1E601800
    mov  edi, 0x6E60FC00
    jmp  kh_f3
kh_f3:
    ; vN.2d takes the vector form in edi
    push rcx
    xor  ecx, ecx
    call ka_opreg
    pop  rcx
    cmp  eax, 9
    je   .vec4s
    cmp  eax, 8
    jne  .scalar
    mov  ecx, edi
    mov  edx, 8
    call ka_vec3
    test eax, eax
    jz   kh_bad
    ret
.vec4s:
    ; .4s: the .2d word with sz (bit 22) clear
    mov  ecx, edi
    and  ecx, 0xFFBFFFFF
    mov  edx, 9
    call ka_vec3
    test eax, eax
    jz   kh_bad
    ret
.scalar:
    call ka_fop3
    test eax, eax
    jz   kh_bad
    ret

; one source: fsqrt / fneg / fabs Fd, Fn
kh_fsqrt:
    mov  ebx, 0x1E61C000
    jmp  kh_f2
kh_fneg:
    mov  ebx, 0x1E614000
    jmp  kh_f2
kh_fabs:
    mov  ebx, 0x1E60C000
    jmp  kh_f2
kh_f2:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    mov  r15d, eax
    cmp  eax, 3
    je   .src
    cmp  eax, 4
    jne  kh_bad
    and  ebx, 0xFFBFFFFF
    jmp  .src
.src:
    mov  ecx, 1
    call ka_opreg
    cmp  eax, r15d
    jne  kh_bad
    mov  r13d, edx
    xor  r14d, r14d
    mov  ecx, ebx
    call ka_rrr
    ret

; fcmp Fn, Fm | Fn, #0.0
kh_fcmp:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    mov  ebx, 0x1E602000
    mov  r15d, eax
    cmp  eax, 3
    je   .n
    cmp  eax, 4
    jne  kh_bad
    and  ebx, 0xFFBFFFFF
    jmp  .n
.n:
    mov  r13d, edx
    mov  ecx, 1
    call ka_opreg
    test eax, eax
    jz   .zero
    cmp  eax, r15d
    jne  kh_bad
    mov  r14d, edx
    xor  r12d, r12d
    mov  ecx, ebx
    call ka_rrr
    ret
.zero:
    ; '#0.0' or '#0'
    or   ebx, 8
    xor  r14d, r14d
    xor  r12d, r12d
    mov  ecx, ebx
    call ka_rrr
    ret

; conversions between integer and real registers
;   scvtf/ucvtf Fd, Rn     fcvtzs/fcvtzu Rd, Fn
kh_scvtf:
    mov  ebx, 0x1E220000
    mov  r11d, 1
    jmp  kh_cvt
kh_ucvtf:
    mov  ebx, 0x1E230000
    mov  r11d, 1
    jmp  kh_cvt
kh_fcvtzs:
    mov  ebx, 0x1E380000
    xor  r11d, r11d
    jmp  kh_cvt
kh_fcvtzu:
    mov  ebx, 0x1E390000
    xor  r11d, r11d
    jmp  kh_cvt
kh_fcvtns:
    ; to the nearest integer, ties to even: the x86-64 default rounding
    mov  ebx, 0x1E200000
    xor  r11d, r11d
    jmp  kh_cvt
kh_cvt:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    mov  r15d, eax
    mov  ecx, 1
    call ka_opreg
    mov  r13d, edx
    ; r15 = class of the destination, eax = class of the source
    test r11d, r11d
    jz   .tofix
    ; to real: Fd from Rn
    mov  ecx, r15d
    mov  edx, eax
    jmp  .classes
.tofix:
    ; Rd from Fn
    mov  ecx, eax
    mov  edx, r15d
    jmp  .classes
.classes:
    ; ecx = real class (3 d / 4 s), edx = integer class (1 x / 2 w)
    cmp  ecx, 3
    je   .rd
    cmp  ecx, 4
    jne  kh_bad
    jmp  .rs
.rd:
    or   ebx, 0x00400000
    jmp  .rs
.rs:
    cmp  edx, 1
    je   .ix
    cmp  edx, 2
    jne  kh_bad
    jmp  .enc
.ix:
    or   ebx, 0x80000000
    jmp  .enc
.enc:
    xor  r14d, r14d
    mov  ecx, ebx
    call ka_rrr
    ret

; fcvt Dd, Sn | Sd, Dn
kh_fcvt:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_opreg
    mov  r12d, edx
    mov  ebx, eax
    mov  ecx, 1
    call ka_opreg
    mov  r13d, edx
    xor  r14d, r14d
    cmp  ebx, 3
    jne  .tos
    cmp  eax, 4
    jne  kh_bad
    mov  ecx, 0x1E22C000
    call ka_rrr
    ret
.tos:
    cmp  ebx, 4
    jne  kh_bad
    cmp  eax, 3
    jne  kh_bad
    mov  ecx, 0x1E624000
    call ka_rrr
    ret

; ka_vec3(ecx = base word, edx = class) -> eax = 1 when Vd, Vn, Vm are three
; registers of that class and the word was written
ka_vec3:
    push rbx
    push rdi
    mov  ebx, ecx
    mov  edi, edx
    mov  ecx, 3
    call ka_need
    test rax, rax
    jz   .bad
    xor  ecx, ecx
    call ka_opreg
    cmp  eax, edi
    jne  .bad
    mov  r12d, edx
    mov  ecx, 1
    call ka_opreg
    cmp  eax, edi
    jne  .bad
    mov  r13d, edx
    mov  ecx, 2
    call ka_opreg
    cmp  eax, edi
    jne  .bad
    mov  r14d, edx
    mov  ecx, ebx
    call ka_rrr
    mov  eax, 1
    pop  rdi
    pop  rbx
    ret
.bad:
    xor  eax, eax
    pop  rdi
    pop  rbx
    ret

; prfm pldl1keep, [Xn]: a hint to bring the line into the first-level cache
kh_prfm:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_op
    mov  rcx, rsi
    lea  rdx, [rel ks_pldl1keep]
    call ka_streq
    test rax, rax
    jz   kh_bad
    mov  ecx, 1
    call ka_op
    cmp  byte [rsi], '['
    jne  kh_bad
    call ka_mem
    test rax, rax
    jz   kh_bad
    cmp  qword [rel km_kind], 0
    jne  kh_bad
    cmp  qword [rel km_imm], 0
    jne  kh_range
    mov  eax, [rel km_base]
    and  eax, 31
    shl  eax, 5
    mov  ecx, 0xF9800000
    or   ecx, eax
    call ka_emit32
    ret

; dc civac, Xn: clean and invalidate the cache line holding the address
kh_dc:
    mov  ecx, 2
    call ka_need
    test rax, rax
    jz   kh_bad
    xor  ecx, ecx
    call ka_op
    mov  rcx, rsi
    lea  rdx, [rel ks_civac]
    call ka_streq
    test rax, rax
    jz   kh_bad
    mov  ecx, 1
    call ka_opreg
    cmp  eax, 1
    jne  kh_bad
    mov  ecx, 0xD50B7E20
    and  edx, 31
    or   ecx, edx
    call ka_emit32
    ret

