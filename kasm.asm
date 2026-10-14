; ==============================================================================
; KASM - Kron Assembler
; Turns the text the code generator produces into x86-64 machine code bytes,
; replacing NASM. Two passes: the first records where every label lands, the
; second emits bytes with all references resolved.
;
; Scope: exactly the instruction forms cg_emit can produce. Not a general
; assembler, and deliberately so - it only has to understand its own output.
; ==============================================================================

bits 64
default rel

%include "kron_types.inc"

extern GetStdHandle
extern WriteFile

; Capacities. A program with the whole standard library, its failure-trace
; labels and tables, is several times the size the first limits were set for.
KASM_CODE_MAX  equ 8388608
KASM_DATA_MAX  equ 4194304
KASM_NAMES_MAX equ 4194304
KASM_LBL_MAX   equ 131072
KASM_HASH_SIZE equ 65536
KASM_FIX_MAX   equ 524288

section .bss
    ; --- output ---
    kasm_code      resb KASM_CODE_MAX     ; emitted machine code
    kasm_code_len  resq 1
    kasm_data      resb KASM_DATA_MAX     ; .data contents
    kasm_data_len  resq 1
    kasm_bss_len   resq 1             ; .bss size, reserved not emitted

    ; --- label table ---
    lbl_names      resb KASM_NAMES_MAX    ; packed zero-terminated names
    lbl_names_len  resq 1
    lbl_name_off   resd KASM_LBL_MAX      ; offset into lbl_names
    lbl_addr       resq KASM_LBL_MAX      ; resolved address
    lbl_section    resb KASM_LBL_MAX      ; 0 = text, 1 = data, 2 = bss
    ; A hash of the names, so finding a label does not read every label
    ; before it: buckets hold index + 1 of the newest label in them, and
    ; lbl_chain the one added to the same bucket before it.
    lbl_hash       resd KASM_HASH_SIZE
    lbl_chain      resd KASM_LBL_MAX
    lbl_count      resq 1

    ; --- pending references, resolved in pass two ---
    fix_at         resd KASM_FIX_MAX      ; where in the code the field sits
    fix_label      resd KASM_FIX_MAX
    fix_addend     resd KASM_FIX_MAX      ; +N offset from a [rel label+N] operand
    fix_kind       resb KASM_FIX_MAX      ; 0 = rel32, 1 = abs64, 2 = abs32
    fix_count      resq 1
    cur_fix_kind   resq 1
    data_base      resq 1
    bss_base       resq 1             ; runtime base of .bss (after data)
    bss_cursor     resq 1             ; running offset within .bss during a pass
    ; --- external symbols ---
    ext_names      resb 16384
    ext_names_len  resq 1
    ext_name_off   resd 512
    ext_count      resq 1
    ; call sites that reference an external symbol
    extref_at      resd 512
    extref_sym     resd 512
    extref_count   resq 1
    ; old extern index -> new index after pruning, or -1 when the symbol
    ; turned out to be defined by one of the modules being assembled
    ext_map        resd 512
    ext_used       resd 512     ; 1 when some call site references the extern
    prn_new        resq 1

    ; --- current line ---
    line_buf       resb 1024
    lbl_rest       resb 512           ; text following 'label:' on the same line
    tok_a          resb 64            ; mnemonic
    tok_b          resb 512           ; first operand
    tok_c          resb 512           ; second operand

    cur_section    resb 1             ; 0 text, 1 data, 2 bss
    kasm_pass      resb 1             ; 1 or 2
    kasm_error     resb 1
    op_size        resb 1             ; 1 when the operand had a 'byte' prefix
    db_quote       resb 1             ; quote character that opened the run
    db_phase       resb 1             ; 0 = walking tok_b, 1 = walking tok_c
    dst_base       resq 1             ; base register of a [base+disp] destination
    src_base       resq 1             ; same, for the source operand
    rex8_force     resb 1             ; an 8-bit operand needs REX present
    sse_pfx        resb 1             ; F2 for the double forms, F3 for single
    dl_size        resb 1             ; width of the current dw/dd/dq list
    expr_ptr       resq 1             ; cursor of the expression being evaluated
    last_label     resb 64            ; name of the label on the current line
    cur_global     resb 64            ; innermost non-local label, for scoping
    qual_buf       resb 160           ; 'global' + '.local' built here
    sib_disp       resd 1             ; displacement of a [base+index*scale+N]
    ; The whole project reaches the assembler as one translation unit, and it
    ; declares a few thousand constants; 512 filled up a fifth of the way in
    ; and everything after that was dropped without a word.
    equ_names      resb 262144        ; packed names of equ constants
    equ_names_len  resq 1
    equ_name_off   resd 8192
    equ_value      resq 8192
    equ_count      resq 1
    dst_addend     resq 1             ; addend of the first operand, kept across
                                      ; the second parse_operand, which resets it
    kasm_line      resq 1             ; source line being assembled
    kasm_err_line  resq 1             ; line where the first error was found
    err_lines      resd 64            ; every unsupported line, not just the first
    err_dst        resd 64            ; operand kind of the destination
    err_src        resd 64            ; operand kind of the source
    err_count      resq 1
    err_mnem       resb 1024          ; 16 bytes of tok_a per error, so a
                                      ; report names the instruction itself
    cur_addend     resq 1             ; addend for the pending [rel label+N] fixup
    dbg_written    resq 1
    dbg_buf        resb 8

section .data
    ; register name table, in encoding order
    ; every entry is exactly 5 bytes so the stride is uniform
    reg64_names:
        db "rax",0,0, "rcx",0,0, "rdx",0,0, "rbx",0,0
        db "rsp",0,0, "rbp",0,0, "rsi",0,0, "rdi",0,0
        db "r8",0,0,0, "r9",0,0,0, "r10",0,0, "r11",0,0
        db "r12",0,0, "r13",0,0, "r14",0,0, "r15",0,0
    reg32_names:
        db "eax",0,0, "ecx",0,0, "edx",0,0, "ebx",0,0
        db "esp",0,0, "ebp",0,0, "esi",0,0, "edi",0,0
        db "r8d",0,0, "r9d",0,0, "r10d",0, "r11d",0
        db "r12d",0, "r13d",0, "r14d",0, "r15d",0
    reg8_names:
        db "al",0,0,0, "cl",0,0,0, "dl",0,0,0, "bl",0,0,0
        db "spl",0,0,  "bpl",0,0,  "sil",0,0,  "dil",0,0
        db "r8b",0,0,  "r9b",0,0,  "r10b",0,   "r11b",0
        db "r12b",0,   "r13b",0,   "r14b",0,   "r15b",0
    reg16_names:
        db "ax",0,0,0, "cx",0,0,0, "dx",0,0,0, "bx",0,0,0
        db "sp",0,0,0, "bp",0,0,0, "si",0,0,0, "di",0,0,0
        db "r8w",0,0,  "r9w",0,0,  "r10w",0,   "r11w",0
        db "r12w",0,   "r13w",0,   "r14w",0,   "r15w",0
    xmm_names:
        db "xmm0",0, "xmm1",0, "xmm2",0, "xmm3",0
        db "xmm4",0, "xmm5",0, "xmm6",0, "xmm7",0

section .text

global kasm_init
global parse_float

; jdbg(al = marker character) - writes one character to stdout
jdbg:
    push rbx
    push rcx
    push rdx
    push r8
    push r9
    push r10
    push r11
    sub  rsp, 56
    mov  [rel dbg_buf], al
    mov  rcx, -11
    call GetStdHandle
    mov  rcx, rax
    lea  rdx, [rel dbg_buf]
    mov  r8, 1
    lea  r9, [rel dbg_written]
    mov  qword [rsp+32], 0
    call WriteFile
    add  rsp, 56
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdx
    pop  rcx
    pop  rbx
    ret

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

; ==============================================================================
; kasm_init()
; ==============================================================================
kasm_init:
    mov  qword [rel kasm_code_len], 0
    mov  qword [rel kasm_data_len], 0
    mov  qword [rel kasm_bss_len], 0
    mov  qword [rel lbl_count], 0
    ; empty buckets
    lea  rax, [rel lbl_hash]
    xor  ecx, ecx
.clr_hash:
    mov  dword [rax], 0
    add  rax, 4
    inc  rcx
    cmp  rcx, KASM_HASH_SIZE
    jb   .clr_hash
    mov  qword [rel lbl_names_len], 1     ; offset 0 reserved for "no name"
    mov  byte  [rel lbl_names], 0
    mov  qword [rel fix_count], 0
    mov  byte  [rel cur_section], 0
    mov  byte  [rel kasm_error], 0
    mov  qword [rel kasm_line], 0
    mov  qword [rel kasm_err_line], 0
    mov  qword [rel err_count], 0
    mov  qword [rel equ_count], 0
    mov  qword [rel equ_names_len], 0
    mov  byte  [rel cur_global], 0
    mov  qword [rel ext_count], 0
    mov  qword [rel ext_names_len], 1
    mov  byte  [rel ext_names], 0
    mov  qword [rel extref_count], 0
    mov  qword [rel kasm_bss_len], 0
    ret

; kasm_build_image() -> rax = total length of the flat image
; Appends the data section after the code, at the 16-byte aligned base the
; RIP fixups were resolved against.
kasm_build_image:
    push rbx
    push rsi
    push rdi
    mov  rax, [rel kasm_code_len]
    mov  rbx, [rel data_base]
    ; zero-fill the gap
    lea  rdi, [rel kasm_code]
    add  rdi, rax
.pad:
    cmp  rax, rbx
    jae  .pad_done
    mov  byte [rdi], 0
    inc  rdi
    inc  rax
    jmp  .pad
.pad_done:
    ; copy the data section into place
    lea  rsi, [rel kasm_data]
    mov  rcx, [rel kasm_data_len]
.copy:
    test rcx, rcx
    jz   .copy_done
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .copy
.copy_done:
    mov  rax, rbx
    add  rax, [rel kasm_data_len]
    pop  rdi
    pop  rsi
    pop  rbx
    ret

kasm_get_code:
    lea  rax, [rel kasm_code]
    ret
kasm_get_code_size:
    mov  rax, [rel kasm_code_len]
    ret
kasm_get_data:
    lea  rax, [rel kasm_data]
    ret
kasm_get_data_size:
    mov  rax, [rel kasm_data_len]
    ret
kasm_get_bss_size:
    mov  rax, [rel kasm_bss_len]
    ret
kasm_get_error_count:
    mov  rax, [rel err_count]
    ret

; kasm_get_error_line_at(rcx = index) -> rax = source line
; kasm_get_error_dst(rcx = index) -> rax = destination operand kind
kasm_get_error_dst:
    lea  rax, [rel err_dst]
    mov  eax, [rax + rcx*4]
    ret

; kasm_get_error_src(rcx = index) -> rax = source operand kind
kasm_get_error_src:
    lea  rax, [rel err_src]
    mov  eax, [rax + rcx*4]
    ret

kasm_get_error_line_at:
    lea  rax, [rel err_lines]
    mov  eax, [rax + rcx*4]
    ret

kasm_get_error_line:
    mov  rax, [rel kasm_err_line]
    ret

kasm_had_error:
    movzx eax, byte [rel kasm_error]
    ret

; kasm_get_error_mnem(rcx = index) -> rax = pointer to the mnemonic text
kasm_get_error_mnem:
    lea  rax, [rel err_mnem]
    shl  rcx, 4
    add  rax, rcx
    ret

; record_err_mnem(rcx = error index) copies tok_a into that slot.
; Line numbers alone proved useless: kasm counts lines of its own preprocessed
; text, which does not line up with the file nasm -E writes.
record_err_mnem:
    push rbx
    push rsi
    push rdi
    lea  rdi, [rel err_mnem]
    shl  rcx, 4
    add  rdi, rcx
    lea  rsi, [rel tok_a]
    xor  ebx, ebx
.rem_cp:
    cmp  ebx, 15
    jae  .rem_end
    mov  al, [rsi]
    test al, al
    jz   .rem_end
    mov  [rdi], al
    inc  rsi
    inc  rdi
    inc  ebx
    jmp  .rem_cp
.rem_end:
    mov  byte [rdi], 0
    pop  rdi
    pop  rsi
    pop  rbx
    ret

kasm_get_ext_count:
    mov  rax, [rel ext_count]
    ret
; kasm_get_ext_name(rcx = index) -> rax = pointer to the name
kasm_get_ext_name:
    lea  rax, [rel ext_name_off]
    mov  eax, [rax + rcx*4]
    lea  rdx, [rel ext_names]
    add  rax, rdx
    ret
kasm_get_extref_count:
    mov  rax, [rel extref_count]
    ret
; kasm_get_extref_at(rcx = index) -> rax = code offset of the field
kasm_get_extref_at:
    lea  rax, [rel extref_at]
    mov  eax, [rax + rcx*4]
    ret
; kasm_get_extref_sym(rcx = index) -> rax = which external symbol
kasm_get_extref_sym:
    lea  rax, [rel extref_sym]
    mov  eax, [rax + rcx*4]
    ret

; ==============================================================================
; BYTE EMISSION
; In pass one nothing is written; only the position counter advances, so that
; every label gets the address it will really have.
; ==============================================================================

; emit_b(al = byte)
emit_b:
    push rcx
    push rdx
    push r8
    cmp  byte [rel kasm_pass], 1
    je   .count
    movzx ecx, byte [rel cur_section]
    cmp   cl, 1
    je    .to_data
    mov  rcx, [rel kasm_code_len]
    cmp  rcx, KASM_CODE_MAX
    jae  .full
    lea  r8, [rel kasm_code]
    mov  [r8 + rcx], al
    inc  qword [rel kasm_code_len]
    jmp  .out
.to_data:
    mov  rcx, [rel kasm_data_len]
    cmp  rcx, KASM_DATA_MAX
    jae  .full
    lea  r8, [rel kasm_data]
    mov  [r8 + rcx], al
    inc  qword [rel kasm_data_len]
    jmp  .out
.full:
    mov  byte [rel kasm_error], 1
    jmp  .out
.count:
    movzx ecx, byte [rel cur_section]
    cmp   cl, 1
    je    .count_data
    inc  qword [rel kasm_code_len]
    jmp  .out
.count_data:
    inc  qword [rel kasm_data_len]
.out:
    pop  r8
    pop  rdx
    pop  rcx
    ret

; emit_w(ax = word)
emit_w:
    push rax
    call emit_b
    pop  rax
    shr  eax, 8
    call emit_b
    ret

; emit_d(eax = dword)
emit_d:
    push rax
    call emit_b
    pop  rax
    push rax
    shr  eax, 8
    call emit_b
    pop  rax
    push rax
    shr  eax, 16
    call emit_b
    pop  rax
    shr  eax, 24
    call emit_b
    ret

; emit_q(rax = qword)
emit_q:
    push rax
    call emit_d
    pop  rax
    shr  rax, 32
    call emit_d
    ret

; bss_round8(rax = bytes reserved) -> rax rounded up to a multiple of 8.
; Nothing used to pad these, so 'flag resb 1' left the next variable on an odd
; address and packed the section far tighter than a real linker does. Any write
; that overran its object by a byte then landed on its neighbour -- which is
; how a one-byte error flag ended up being set by the pointer stored after it.
bss_round8:
    add  rax, 7
    and  rax, -8
    ret

; here() -> rax = current offset in the active section
here:
    movzx eax, byte [rel cur_section]
    cmp   al, 1
    je    .data
    cmp   al, 2
    je    .bss
    mov  rax, [rel kasm_code_len]
    ret
.data:
    mov  rax, [rel kasm_data_len]
    ret
.bss:
    mov  rax, [rel bss_cursor]
    ret

; ==============================================================================
; ENCODING HELPERS
; ==============================================================================

; emit_rex(dil = W, sil = reg, dl = rm)  emits a REX prefix when one is needed
emit_rex:
    push rbx
    xor  ebx, ebx
    test dil, dil
    jz   .no_w
    or   bl, 0x08
.no_w:
    test sil, 0x08
    jz   .no_r
    or   bl, 0x04
.no_r:
    test dl, 0x08
    jz   .no_b
    or   bl, 0x01
.no_b:
    test bl, bl
    jnz  .emit
    ; An 8-bit operand may be spl/bpl/sil/dil, which are only reachable when a
    ; REX byte is present. This assembler has no names for ah/ch/dh/bh, so a
    ; bare 0x40 is never the wrong choice.
    cmp  byte [rel rex8_force], 0
    je   .done
.emit:
    mov  al, 0x40
    or   al, bl
    call emit_b
.done:
    pop  rbx
    ret

; emit_modrm(dil = mod, sil = reg, dl = rm)
; sse_rex(esi = ModRM reg, edx = ModRM rm or base, 0 when neither is used):
; the REX byte, no W, when either is r8..r15 / xmm8..xmm15. It goes after the
; F2 / F3 / 66 prefix and before 0F. Preserves every register but rax.
sse_rex:
    push rdi
    push rsi
    push rdx
    xor  edi, edi
    call emit_rex
    pop  rdx
    pop  rsi
    pop  rdi
    ret

emit_modrm:
    mov  al, dil
    shl  al, 6
    mov  cl, sil
    and  cl, 0x07
    shl  cl, 3
    or   al, cl
    mov  cl, dl
    and  cl, 0x07
    or   al, cl
    call emit_b
    ret

; emit_rip(sil = reg, eax = label index)
; encodes the RIP-relative form: mod=00, rm=101, then a disp32 fixup.
; The displacement is resolved once the data base address is known.
emit_rip:
    push rax
    mov  dil, 0
    mov  dl, 5                    ; rm = 101 means RIP-relative in 64-bit mode
    call emit_modrm
    pop  rax
    mov  dil, 3                   ; kind 3 = RIP-relative to a data label
    call add_fixup
    xor  eax, eax
    call emit_d
    ret

; emit_sib_modrm(sil = reg field, edx = base | index<<8 | scale<<16)
; Emits only ModRM(mod=00,rm=100) and the SIB byte. Used when the opcode and
; its prefixes have already gone out, as with movsd (F2 0F 11).
; Registers r8..r15 would need a REX byte before the opcode, which is no
; longer possible at this point, so those are refused by the caller.
emit_sib_modrm:
    push rbx
    push rbp
    mov  ebx, edx
    and  ebx, 0xFF               ; base
    mov  ebp, edx
    shr  ebp, 8
    and  ebp, 0xFF               ; index
    shr  edx, 16
    and  edx, 0x03               ; scale
    push rdx
    ; An explicit displacement forces mod=10, exactly as emit_sib_mem does.
    ; Without this, 'movzx edx, byte [rcx + rax - N]' silently lost its -N.
    cmp  dword [rel sib_disp], 0
    jne  .em_disp32
    mov  rax, rbx
    and  al, 0x07
    cmp  al, 0x05
    je   .em_disp8
    xor  edi, edi
    jmp  .em_modrm
.em_disp32:
    mov  dil, 2
    jmp  .em_modrm
.em_disp8:
    mov  dil, 1
.em_modrm:
    push rdi
    mov  dl, 4
    call emit_modrm
    pop  rdi
    pop  rdx
    mov  al, dl
    shl  al, 6
    mov  cl, bpl
    and  cl, 0x07
    shl  cl, 3
    or   al, cl
    mov  cl, bl
    and  cl, 0x07
    or   al, cl
    call emit_b
    cmp  dil, 2
    jne  .em_maybe8
    mov  eax, [rel sib_disp]
    call emit_d
    jmp  .em_out
.em_maybe8:
    test dil, dil
    jz   .em_out
    xor  eax, eax
    call emit_b
.em_out:
    pop  rbp
    pop  rbx
    ret

; emit_mem_base_disp(sil = reg field, dl = base register, eax = amount to
; subtract from the base). Emits ModRM with mod=10 plus disp32, and the SIB
; byte that rsp/r12 as a base always requires.
emit_mem_base_disp:
    push rbx
    mov  ebx, eax
    neg  ebx                     ; the real signed displacement
    mov  al, dl
    and  al, 0x07
    cmp  al, 0x04
    je   .embd_sib
    mov  dil, 2                  ; mod = 10, disp32 follows
    call emit_modrm
    mov  eax, ebx
    call emit_d
    pop  rbx
    ret
.embd_sib:
    mov  dil, 2
    call emit_modrm              ; rm = 100 -> SIB follows
    mov  al, 0x24                ; no index, base = rsp/r12
    call emit_b
    mov  eax, ebx
    call emit_d
    pop  rbx
    ret

; emit_sib_mem(al = opcode, sil = reg field, edx = base | index<<8 | scale<<16)
; Emits  REX.W <opcode> ModRM(mod=00,rm=100) SIB  for [base + index*scale].
; A base of rbp/r13 cannot use mod=00, so those get mod=01 with disp8 = 0.
emit_sib_mem:
    ; dil carries the REX.W bit so the same helper serves 64, 32, 16 and 8
    ; bit stores.
    push rbx
    push rbp
    push rdi
    push rax                     ; keep the opcode
    mov  ebx, edx
    and  ebx, 0xFF               ; base
    mov  ebp, edx
    shr  ebp, 8
    and  ebp, 0xFF               ; index
    shr  edx, 16
    and  edx, 0x03               ; scale (log2)
    push rdx                     ; scale
    ; REX + W (from dil) + R (reg) + X (index) + B (base)
    mov  al, 0x40
    test dil, 1
    jz   .es_no_w
    or   al, 0x08
.es_no_w:
    test sil, 0x08
    jz   .es_no_r
    or   al, 0x04
.es_no_r:
    test bpl, 0x08
    jz   .es_no_x
    or   al, 0x02
.es_no_x:
    test bl, 0x08
    jz   .es_no_b
    or   al, 0x01
.es_no_b:
    cmp  al, 0x40
    jne  .es_emit_rex
    ; This helper builds its own REX instead of going through emit_rex, so the
    ; 8-bit flag has to be honoured here too: without a REX byte, reg=7 means
    ; bh rather than dil.
    cmp  byte [rel rex8_force], 0
    je   .es_skip_rex
.es_emit_rex:
    call emit_b
.es_skip_rex:
    pop  rdx                     ; scale back
    pop  rax                     ; opcode back
    push rdx
    call emit_b                  ; the opcode
    ; ModRM: rm = 100 selects a SIB byte
    cmp  dword [rel sib_disp], 0
    jne  .es_disp32              ; an explicit displacement forces mod=10
    mov  rax, rbx
    and  al, 0x07
    cmp  al, 0x05
    je   .es_disp8
    xor  edi, edi                ; mod = 00
    jmp  .es_modrm
.es_disp32:
    mov  dil, 2                  ; mod = 10, disp32 follows
    jmp  .es_modrm
.es_disp8:
    mov  dil, 1                  ; mod = 01, disp8 follows
.es_modrm:
    push rdi
    mov  dl, 4                   ; rm = 100
    call emit_modrm
    pop  rdi
    pop  rdx                     ; scale
    ; SIB = scale<<6 | (index&7)<<3 | (base&7)
    mov  al, dl
    shl  al, 6
    mov  cl, bpl
    and  cl, 0x07
    shl  cl, 3
    or   al, cl
    mov  cl, bl
    and  cl, 0x07
    or   al, cl
    call emit_b
    cmp  dil, 2
    jne  .es_maybe8
    mov  eax, [rel sib_disp]
    call emit_d
    jmp  .es_out
.es_maybe8:
    test dil, dil
    jz   .es_out
    xor  eax, eax
    call emit_b                  ; disp8 = 0
.es_out:
    pop  rdi
    pop  rbp
    pop  rbx
    ret

; emit_mem_reg(sil = reg field, dl = base register)
; Encodes [base]. Two x86-64 encodings need special care:
;   base&7 == 100b (rsp/r12) -> ModRM.rm=100 REQUIRES a following SIB byte
;   base&7 == 101b (rbp/r13) -> mod=00 means RIP-relative, so mod=01 disp8=0
emit_mem_reg:
    mov  al, dl
    and  al, 0x07
    cmp  al, 0x04
    je   .need_sib
    cmp  al, 0x05
    je   .need_disp8
    xor  edi, edi                 ; mod = 00, plain [base]
    call emit_modrm
    ret
.need_sib:
    xor  edi, edi                 ; mod = 00
    call emit_modrm               ; rm = 100 -> SIB follows
    mov  al, 0x24                 ; scale=0, index=none(100), base=100
    call emit_b
    ret
.need_disp8:
    mov  dil, 1                   ; mod = 01 (disp8)
    call emit_modrm
    xor  eax, eax
    call emit_b                   ; disp8 = 0
    ret

; emit_mem_rbp(sil = reg, eax = positive displacement)
; encodes [rbp - disp], choosing disp8 when the offset fits in a signed byte
emit_mem_rbp:
    push rax
    cmp  eax, 128
    ja   .disp32
    mov  dil, 1                   ; mod = disp8
    mov  dl, 5
    call emit_modrm
    pop  rax
    neg  eax
    call emit_b
    ret
.disp32:
    mov  dil, 2
    mov  dl, 5
    call emit_modrm
    pop  rax
    neg  eax
    call emit_d
    ret

; ==============================================================================
; LABEL TABLE
; ==============================================================================

; kasm_add_extern(rcx = name ptr, rdx = length)
kasm_add_extern:
    push rbx
    push rsi
    push rdi
    push r12
    mov  rsi, rcx
    mov  r12, rdx
    ; Every module redeclares the same kernel32 externs. Without this test
    ; the import table grew one entry per declaration instead of one per
    ; name.  rcx and rdx still hold the name and its length.
    call kasm_find_extern
    cmp  eax, -1
    jne  .done
    mov  rbx, [rel ext_count]
    ; Room for 512: every name on an 'extern' line is registered now, the
    ; module-internal ones too (kasm_prune_externs drops those later).
    cmp  rbx, 512
    jae  .done
    mov  rax, [rel ext_names_len]
    lea  rdi, [rel ext_name_off]
    mov  [rdi + rbx*4], eax
    lea  rdi, [rel ext_names]
    add  rdi, rax
.cp:
    test r12, r12
    jz   .cp_end
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  r12
    jmp  .cp
.cp_end:
    mov  byte [rdi], 0
    lea  rax, [rel ext_names]
    sub  rdi, rax
    inc  rdi
    mov  [rel ext_names_len], rdi
    inc  rbx
    mov  [rel ext_count], rbx
.done:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret


; ==============================================================================
; kasm_prune_externs()
; The resolution step a linker owes its inputs, run once both passes are done.
; A name declared 'extern' in one module is very often defined in another; once
; the modules are assembled together it is an internal symbol, not an import.
; Emitting it as an import made Windows try to bind it against kernel32 and
; refuse to start the image, silently, before main ever ran.
; Every extern is looked up in the label table here: the ones that are defined
; are dropped, the rest are compacted, and the recorded call sites are remapped
; so the thunk indices pe_writer builds still line up.
; ==============================================================================
kasm_prune_externs:
    push rbx
    push rsi
    push rdi
    push r12

    ; ---- mark the externs that some call site actually reaches ----
    ; A declared but never called extern still produced an import entry, and
    ; the loader refuses the whole image over a name kernel32 does not have.
    xor  rbx, rbx
.clr:
    cmp  rbx, 512
    jae  .clr_done
    lea  rdi, [rel ext_used]
    xor  eax, eax
    mov  [rdi + rbx*4], eax
    inc  rbx
    jmp  .clr
.clr_done:
    xor  rbx, rbx
.mark:
    cmp  rbx, [rel extref_count]
    jae  .mark_done
    lea  rdi, [rel extref_sym]
    mov  eax, [rdi + rbx*4]
    mov  rcx, rax
    mov  eax, 1
    lea  rdx, [rel ext_used]
    mov  [rdx + rcx*4], eax
    inc  rbx
    jmp  .mark
.mark_done:

    ; ---- classify: defined here, or a genuine import? ----
    mov  qword [rel prn_new], 0
    xor  rbx, rbx
.cls:
    cmp  rbx, [rel ext_count]
    jae  .compact
    mov  rcx, rbx
    call kasm_get_ext_name
    mov  r12, rax
    mov  rcx, r12
    call str_len_local
    mov  rdx, rax
    mov  rcx, r12
    call kasm_find_label
    cmp  eax, -1
    jne  .cls_internal           ; another module defines it
    lea  rdi, [rel ext_used]
    mov  eax, [rdi + rbx*4]
    test eax, eax
    jz   .cls_internal           ; declared but never called: not an import
    mov  rax, [rel prn_new]      ; keep it: undefined here and really called
    lea  rdi, [rel ext_map]
    mov  [rdi + rbx*4], eax
    inc  rax
    mov  [rel prn_new], rax
    jmp  .cls_next
.cls_internal:
    mov  rax, -1                 ; not an import: drop it
    lea  rdi, [rel ext_map]
    mov  [rdi + rbx*4], eax
.cls_next:
    inc  rbx
    jmp  .cls

; ---- compact the name table in place ----
; A kept name never moves to a higher offset than it already occupies, so the
; ascending byte copy stays correct even when source and destination overlap.
.compact:
    mov  qword [rel prn_new], 0
    mov  eax, 1                  ; new ext_names_len; offset 0 stays reserved
    mov  r12, rax
    xor  rbx, rbx
.cmp_loop:
    cmp  rbx, [rel ext_count]
    jae  .cmp_done
    lea  rdi, [rel ext_map]
    mov  eax, [rdi + rbx*4]
    cmp  eax, -1
    je   .cmp_next
    mov  rcx, rbx
    call kasm_get_ext_name       ; read the old offset before overwriting it
    mov  rsi, rax
    lea  rdi, [rel ext_names]
    add  rdi, r12
    mov  rcx, [rel prn_new]
    lea  rdx, [rel ext_name_off]
    mov  rax, r12
    mov  [rdx + rcx*4], eax
    inc  rcx
    mov  [rel prn_new], rcx
.cmp_cp:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    inc  r12
    test al, al
    jnz  .cmp_cp
.cmp_next:
    inc  rbx
    jmp  .cmp_loop
.cmp_done:
    mov  rax, [rel prn_new]
    mov  [rel ext_count], rax
    mov  rax, r12
    mov  [rel ext_names_len], rax

    ; ---- remap the recorded call sites onto the new indices ----
    mov  qword [rel prn_new], 0
    xor  rbx, rbx
.xr:
    cmp  rbx, [rel extref_count]
    jae  .xr_done
    lea  rdi, [rel extref_sym]
    mov  eax, [rdi + rbx*4]
    mov  rcx, rax
    lea  rax, [rel ext_map]
    mov  eax, [rax + rcx*4]
    cmp  eax, -1
    je   .xr_next                ; resolved as a label; its fixup already stands
    mov  rcx, [rel prn_new]
    lea  rdx, [rel extref_sym]
    mov  [rdx + rcx*4], eax
    lea  rdi, [rel extref_at]
    mov  eax, [rdi + rbx*4]
    lea  rdx, [rel extref_at]
    mov  [rdx + rcx*4], eax
    inc  rcx
    mov  [rel prn_new], rcx
.xr_next:
    inc  rbx
    jmp  .xr
.xr_done:
    mov  rax, [rel prn_new]
    mov  [rel extref_count], rax

    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; kasm_find_extern(rcx = name ptr, rdx = length) -> rax = index, or -1
kasm_find_extern:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rcx
    mov  r13, rdx
    xor  rbx, rbx
.l:
    cmp  rbx, [rel ext_count]
    jae  .nf
    lea  rdi, [rel ext_name_off]
    mov  eax, [rdi + rbx*4]
    lea  rdi, [rel ext_names]
    add  rdi, rax
    mov  rsi, r12
    mov  rcx, r13
.cmp:
    test rcx, rcx
    jz   .cmp_end
    mov  al, [rdi]
    cmp  al, [rsi]
    jne  .next
    inc  rdi
    inc  rsi
    dec  rcx
    jmp  .cmp
.cmp_end:
    cmp  byte [rdi], 0
    jne  .next
    mov  rax, rbx
    jmp  .out
.next:
    inc  rbx
    jmp  .l
.nf:
    mov  rax, -1
.out:
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; kasm_add_extref(eax = symbol index) : records that the dword about to be
; emitted is a call into an external symbol, for the linker to patch
kasm_add_extref:
    push rbx
    push rcx
    push rdx
    mov  rbx, [rel extref_count]
    cmp  rbx, 512
    jae  .done
    push rax
    call here
    mov  ecx, eax
    pop  rax
    lea  rdx, [rel extref_at]
    mov  [rdx + rbx*4], ecx
    lea  rdx, [rel extref_sym]
    mov  [rdx + rbx*4], eax
    inc  rbx
    mov  [rel extref_count], rbx
.done:
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; kasm_add_label(rcx = name ptr, rdx = length)
kasm_add_label:
    push rbx
    push rsi
    push rdi
    push r12
    mov  rsi, rcx
    mov  r12, rdx
    ; If this name is already known, refresh its address instead of adding a
    ; duplicate. Pass 2 then supersedes pass 1, and apply_fixups (which runs
    ; after pass 2) resolves against the final layout.
    push rsi
    push r12
    mov  rcx, rsi
    mov  rdx, r12
    call kasm_find_label
    pop  r12
    pop  rsi
    cmp  eax, -1
    je   .fresh
    mov  rbx, rax                ; existing index
    call here
    lea  rdi, [rel lbl_addr]
    mov  [rdi + rbx*8], rax
    movzx eax, byte [rel cur_section]
    lea  rdi, [rel lbl_section]
    mov  [rdi + rbx], al
    jmp  .done
.fresh:
    mov  rbx, [rel lbl_count]
    cmp  rbx, KASM_LBL_MAX
    jae  .lbl_full
    ; the name buffer was never checked: overflowing it corrupted memory
    ; and the assembler died with no message on the largest sources.
    mov  rax, [rel lbl_names_len]
    add  rax, r12
    add  rax, 2
    cmp  rax, KASM_NAMES_MAX
    jae  .lbl_full
    ; into the hash: this label goes first in its bucket
    push rcx
    push rdx
    mov  rcx, rsi
    mov  rdx, r12
    call lbl_hash_of
    lea  rdi, [rel lbl_hash]
    mov  ecx, [rdi + rax*4]
    lea  rdx, [rel lbl_chain]
    mov  [rdx + rbx*4], ecx
    mov  rcx, rbx
    inc  rcx
    mov  [rdi + rax*4], ecx
    pop  rdx
    pop  rcx
    ; store the name
    mov  rax, [rel lbl_names_len]
    lea  rdi, [rel lbl_name_off]
    mov  [rdi + rbx*4], eax
    lea  rdi, [rel lbl_names]
    add  rdi, rax
.cp:
    test r12, r12
    jz   .cp_end
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  r12
    jmp  .cp
.cp_end:
    mov  byte [rdi], 0
    lea  rax, [rel lbl_names]
    sub  rdi, rax
    inc  rdi
    mov  [rel lbl_names_len], rdi
    ; store address and section
    call here
    lea  rdi, [rel lbl_addr]
    mov  [rdi + rbx*8], rax
    movzx eax, byte [rel cur_section]
    lea  rdi, [rel lbl_section]
    mov  [rdi + rbx], al
    inc  rbx
    mov  [rel lbl_count], rbx
    jmp  .done
.lbl_full:
    ; same failure mode as the constant table: dropping labels silently made
    ; every later reference resolve to nothing
    mov  byte [rel kasm_error], 1
.done:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; lbl_hash_of(rcx = name ptr, rdx = length) -> rax = its bucket
; Preserves every other register.
lbl_hash_of:
    push rcx
    push rdx
    push rsi
    xor  eax, eax
.h:
    test rdx, rdx
    jz   .h_done
    mov  rsi, rax
    shl  rax, 5
    sub  rax, rsi
    movzx esi, byte [rcx]
    add  rax, rsi
    inc  rcx
    dec  rdx
    jmp  .h
.h_done:
    mov  rsi, rax
    shr  rsi, 16
    xor  rax, rsi
    and  rax, 0xFFFF
    pop  rsi
    pop  rdx
    pop  rcx
    ret

; kasm_find_label(rcx = name ptr, rdx = length) -> rax = index, or -1
kasm_find_label:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rcx
    mov  r13, rdx
    call lbl_hash_of
    lea  rdi, [rel lbl_hash]
    mov  ebx, [rdi + rax*4]
.l:
    test rbx, rbx
    jz   .nf
    dec  rbx
    lea  rdi, [rel lbl_name_off]
    mov  eax, [rdi + rbx*4]
    lea  rdi, [rel lbl_names]
    add  rdi, rax
    ; compare rdi against r12/r13
    mov  rsi, r12
    mov  rcx, r13
.cmp:
    test rcx, rcx
    jz   .cmp_end
    mov  al, [rdi]
    cmp  al, [rsi]
    jne  .next
    inc  rdi
    inc  rsi
    dec  rcx
    jmp  .cmp
.cmp_end:
    cmp  byte [rdi], 0
    jne  .next
    mov  rax, rbx
    jmp  .out
.next:
    lea  rdi, [rel lbl_chain]
    mov  ebx, [rdi + rbx*4]
    jmp  .l
.nf:
    mov  rax, -1
.out:
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; kasm_label_addr(rax = index) -> rax = address
kasm_label_addr:
    lea  rcx, [rel lbl_addr]
    mov  rax, [rcx + rax*8]
    ret

; --- Fixup introspection: lets an external linker (pe_writer) re-resolve
;     [rel data/bss] references against real section RVAs. ---
kasm_get_fixup_count:
    mov  rax, [rel fix_count]
    ret
kasm_get_fixup_at:
    lea  rax, [rel fix_at]
    mov  eax, [rax + rcx*4]
    ret
kasm_get_fixup_label:
    lea  rax, [rel fix_label]
    mov  eax, [rax + rcx*4]
    ret
kasm_get_fixup_addend:
    lea  rax, [rel fix_addend]
    mov  eax, [rax + rcx*4]
    ret
kasm_get_fixup_kind:
    lea  rax, [rel fix_kind]
    movzx eax, byte [rax + rcx]
    ret
kasm_get_label_section:
    lea  rax, [rel lbl_section]
    movzx eax, byte [rax + rcx]
    ret

; ==============================================================================
; FIXUPS
; add_fixup(eax = label index, dil = kind) records that the dword just about to
; be emitted needs patching once every label is known.
; ==============================================================================
add_fixup:
    push rbx
    push rcx
    mov  rbx, [rel fix_count]
    cmp  rbx, KASM_FIX_MAX
    jae  .fix_full
    push rax
    call here
    mov  ecx, eax
    pop  rax
    push rdx
    lea  rdx, [rel fix_at]
    mov  [rdx + rbx*4], ecx
    lea  rdx, [rel fix_label]
    mov  [rdx + rbx*4], eax
    lea  rdx, [rel fix_kind]
    mov  [rdx + rbx], dil
    push rax
    mov  eax, [rel cur_addend]
    lea  rdx, [rel fix_addend]
    mov  [rdx + rbx*4], eax
    pop  rax
    pop  rdx
    inc  rbx
    mov  [rel fix_count], rbx
    jmp  .done
.fix_full:
    ; dropping it would leave a reference pointing nowhere, silently
    mov  byte [rel kasm_error], 1
.done:
    pop  rcx
    pop  rbx
    ret

; ==============================================================================
; OPERAND CLASSIFICATION
; parse_operand(rcx = text ptr) -> eax = kind, edx = value, r8d = extra
;   kind 0 : none / unrecognised
;   kind 1 : 64-bit register        edx = number
;   kind 2 : immediate              rdx = value
;   kind 3 : [rbp-N]                edx = N
;   kind 4 : label reference        edx = label index (-1 when still unknown)
;   kind 5 : [rel label]            edx = label index
;   kind 6 : xmm register           edx = number
;   kind 7 : 8-bit register         edx = number
;   kind 8 : 32-bit register        edx = number
;   kind 9 : [reg]                  edx = register number
;   kind 10: 16-bit register        edx = number
; ==============================================================================
parse_operand:
    push rbx
    push rsi
    push rdi
    push r12
    ; Every operand starts with a clean addend. Only the [rel label+N] form
    ; sets one; leaving a stale value here made unrelated fixups (jumps to
    ; plain labels) inherit the previous instruction's addend.
    mov  qword [rel cur_addend], 0
    mov  rsi, rcx
    ; A size prefix may appear on either operand ('mov eax, dword [rax]'),
    ; so skip it here rather than only in the tokeniser's first slot.
    test rsi, rsi
    jz   .no_pfx
    ; Match the whole keyword. Testing one letter plus a space at a fixed
    ; offset reads past the end of a short operand such as 'bl', where the
    ; leftover byte from the previous token could pass for a space.
    cmp  byte [rsi], 'b'
    jne  .pfx_q
    cmp  byte [rsi+1], 'y'
    jne  .no_pfx
    cmp  byte [rsi+2], 't'
    jne  .no_pfx
    cmp  byte [rsi+3], 'e'
    jne  .no_pfx
    cmp  byte [rsi+4], ' '
    jne  .no_pfx
    mov  byte [rel op_size], 1
    add  rsi, 5
    jmp  .no_pfx
.pfx_q:
    cmp  byte [rsi], 'q'
    je   .pfx_q8
    cmp  byte [rsi], 'd'
    jne  .pfx_w
    cmp  byte [rsi+1], 'w'
    jne  .no_pfx
    cmp  byte [rsi+2], 'o'
    jne  .no_pfx
    cmp  byte [rsi+3], 'r'
    jne  .no_pfx
    cmp  byte [rsi+4], 'd'
    jne  .no_pfx
    cmp  byte [rsi+5], ' '
    jne  .no_pfx
    mov  byte [rel op_size], 4
    add  rsi, 6
    jmp  .no_pfx
.pfx_q8:
    cmp  byte [rsi+1], 'w'
    jne  .no_pfx
    cmp  byte [rsi+2], 'o'
    jne  .no_pfx
    cmp  byte [rsi+3], 'r'
    jne  .no_pfx
    cmp  byte [rsi+4], 'd'
    jne  .no_pfx
    cmp  byte [rsi+5], ' '
    jne  .no_pfx
    mov  byte [rel op_size], 8
    add  rsi, 6
    jmp  .no_pfx
.pfx_w:
    cmp  byte [rsi], 'w'
    jne  .no_pfx
    cmp  byte [rsi+1], 'o'
    jne  .no_pfx
    cmp  byte [rsi+2], 'r'
    jne  .no_pfx
    cmp  byte [rsi+3], 'd'
    jne  .no_pfx
    cmp  byte [rsi+4], ' '
    jne  .no_pfx
    mov  byte [rel op_size], 2
    add  rsi, 5
.no_pfx:
    test rsi, rsi
    jz   .none
    cmp  byte [rsi], 0
    je   .none

    ; memory operand?
    cmp  byte [rsi], '['
    je   .mem

    ; an expression can start with '(' or with the unary '~'
    cmp  byte [rsi], '~'
    je   .as_expr
    cmp  byte [rsi], '('
    jne  .not_paren
.as_expr:
    mov  rcx, rsi
    call parse_expr
    mov  rdx, rax
    mov  eax, 2
    jmp  .out
.not_paren:

    ; character literal?  'x' is an immediate equal to that byte
    cmp  byte [rsi], 0x27
    jne  .not_char
    ; A character literal may head an expression: "'a' - 10", which is how
    ; the hex-digit bias is written.  Taking byte [rsi+1] and returning threw
    ; the rest away, so 'a'-10 evaluated as 'a' and every hex digit A-F came
    ; out ten short.  Scan PAST the closing quote, so an operator inside the
    ; quotes -- '-' or '+' as literals -- is not mistaken for arithmetic.
    cmp  byte [rsi+2], 0x27      ; well-formed 'x' ?
    jne  .ch_plain
    lea  rcx, [rsi+3]            ; first byte after the closing quote
.ch_scan:
    mov  al, [rcx]
    test al, al
    jz   .ch_plain
    cmp  al, '+'
    je   .ch_is_expr
    cmp  al, '-'
    je   .ch_is_expr
    cmp  al, '*'
    je   .ch_is_expr
    cmp  al, '/'
    je   .ch_is_expr
    cmp  al, '&'
    je   .ch_is_expr
    cmp  al, '|'
    je   .ch_is_expr
    cmp  al, '<'
    je   .ch_is_expr
    cmp  al, '>'
    je   .ch_is_expr
    inc  rcx
    jmp  .ch_scan
.ch_is_expr:
    mov  rcx, rsi
    call parse_expr
    mov  rdx, rax
    mov  eax, 2
    jmp  .out
.ch_plain:
    ; Up to four characters, packed little-endian: 'jupi' is 0x6970756a.
    ; This took byte [rsi+1] and stopped, so every multi-character compare
    ; tested against its first letter. That is what silently disabled module
    ; header detection: 'cmp dword [r14], 'jupi'' could never match.
    ;
    ; The value is built by multiplying rather than shifting by a variable
    ; amount, because 'shl reg, cl' appears nowhere else in this assembler
    ; and it has to assemble itself.
    push rbx
    push rcx
    lea  rcx, [rsi+1]            ; past the opening quote
    xor  edx, edx
    mov  ebx, 1                  ; place value: 1, 256, 65536, 16777216
.chp_loop:
    movzx eax, byte [rcx]
    cmp  al, 0x27                ; closing quote
    je   .chp_done
    test al, al
    jz   .chp_done
    cmp  ebx, 0
    je   .chp_skip               ; past four characters: ignore the rest
    imul eax, ebx
    or   edx, eax
    imul ebx, ebx, 256
.chp_skip:
    inc  rcx
    jmp  .chp_loop
.chp_done:
    pop  rcx
    pop  rbx
    mov  eax, 2                  ; kind 2 = immediate
    jmp  .out
.not_char:

    ; numeric immediate?
    mov  al, [rsi]
    cmp  al, '-'
    jne  .not_neg
    movzx eax, byte [rsi+1]      ; '-' followed by a digit is an immediate
    cmp  al, '0'
    jb   .try_reg
    cmp  al, '9'
    ja   .try_reg
    jmp  .is_num
.not_neg:
    cmp  al, '0'
    jb   .try_reg
    cmp  al, '9'
    ja   .try_reg
.is_num:
    ; An expression may also begin with a number: '0xBC+18'. Scan for an
    ; arithmetic operator exactly as .as_label does; a bare number (including
    ; a negative immediate such as -11) still goes through parse_number.
    push rsi
    mov  rcx, rsi
.in_scan:
    mov  al, [rcx]
    test al, al
    jz   .in_plain
    cmp  al, '+'
    je   .in_is_expr
    cmp  al, '*'
    je   .in_is_expr
    cmp  al, '/'
    je   .in_is_expr
    cmp  al, '&'
    je   .in_is_expr
    cmp  al, '|'
    je   .in_is_expr
    cmp  al, '<'
    je   .in_is_expr
    cmp  al, '>'
    je   .in_is_expr
    cmp  al, ' '
    jne  .in_next
    cmp  byte [rcx+1], '-'       ; ' - ' is a subtraction, not a sign
    je   .in_is_expr
.in_next:
    inc  rcx
    jmp  .in_scan
.in_is_expr:
    pop  rsi
    mov  rcx, rsi
    call parse_expr
    mov  rdx, rax
    mov  eax, 2
    jmp  .out
.in_plain:
    pop  rsi
    mov  rcx, rsi
    call parse_number            ; -> rax = value
    mov  rdx, rax
    mov  eax, 2
    jmp  .out

.try_reg:
    ; 64-bit register?
    mov  rcx, rsi
    lea  rdx, [rel reg64_names]
    call match_reg_table
    cmp  eax, -1
    je   .try_xmm
    mov  edx, eax
    mov  eax, 1
    jmp  .out
.try_xmm:
    ; xmm0 .. xmm15, read by number: xmm8 and up need a REX byte, which every
    ; SSE form below now writes (sse_rex)
    cmp  byte [rsi], 'x'
    jne  .try_r8
    cmp  byte [rsi+1], 'm'
    jne  .try_r8
    cmp  byte [rsi+2], 'm'
    jne  .try_r8
    movzx eax, byte [rsi+3]
    sub  eax, '0'
    cmp  eax, 9
    ja   .try_r8
    movzx ecx, byte [rsi+4]
    test ecx, ecx
    jz   .xmm_have
    sub  ecx, '0'
    cmp  ecx, 9
    ja   .try_r8
    cmp  byte [rsi+5], 0
    jne  .try_r8
    imul eax, eax, 10
    add  eax, ecx
    cmp  eax, 15
    ja   .try_r8
.xmm_have:
    mov  edx, eax
    mov  eax, 6
    jmp  .out
.try_r8:
    mov  rcx, rsi
    lea  rdx, [rel reg8_names]
    call match_reg_table
    cmp  eax, -1
    je   .try_r32
    mov  edx, eax
    mov  eax, 7
    jmp  .out
.try_r32:
    mov  rcx, rsi
    lea  rdx, [rel reg32_names]
    call match_reg_table
    cmp  eax, -1
    je   .try_r16
    mov  edx, eax
    mov  eax, 8
    jmp  .out
.try_r16:
    mov  rcx, rsi
    lea  rdx, [rel reg16_names]
    call match_reg_table
    cmp  eax, -1
    je   .as_label
    mov  edx, eax
    mov  eax, 10
    jmp  .out

.as_label:
    ; An expression may begin with a name: 'SYMTAB_BUCKETS * 8'. Label names
    ; never contain an arithmetic operator, so finding one settles it.
    push rsi
    mov  rcx, rsi
.al_scan:
    mov  al, [rcx]
    test al, al
    jz   .al_not_expr
    cmp  al, '+'
    je   .al_is_expr
    cmp  al, '*'
    je   .al_is_expr
    cmp  al, '/'
    je   .al_is_expr
    cmp  al, '&'
    je   .al_is_expr
    cmp  al, '|'
    je   .al_is_expr
    cmp  al, '<'
    je   .al_is_expr
    cmp  al, '>'
    je   .al_is_expr
    cmp  al, ' '
    jne  .al_next
    cmp  byte [rcx+1], '-'       ; ' - ' is a subtraction, not part of a name
    je   .al_is_expr
.al_next:
    inc  rcx
    jmp  .al_scan
.al_is_expr:
    pop  rsi
    mov  rcx, rsi
    call parse_expr
    mov  rdx, rax
    mov  eax, 2                  ; immediate
    jmp  .out
.al_not_expr:
    pop  rsi
    ; a name that matches an equ constant is an immediate, not a jump target
    push rsi
    mov  rcx, rsi
    call str_len_local
    mov  rdx, rax
    mov  rcx, rsi
    call find_equ
    pop  rsi
    cmp  eax, -1
    je   .as_label_real
    lea  rdx, [rel equ_value]
    mov  rdx, [rdx + rax*8]
    mov  eax, 2                  ; immediate
    jmp  .out
.as_label_real:
    ; anything else is a symbol name
    mov  rcx, rsi
    call str_len_local
    mov  rdx, rax
    mov  rcx, rsi
    call qualify_label
    call kasm_find_label
    mov  edx, eax
    mov  eax, 4
    jmp  .out

.mem:
    inc  rsi                     ; skip '['
    ; [rel label]
    cmp  byte [rsi], 'r'
    jne  .mem_reg
    cmp  byte [rsi+1], 'e'
    jne  .mem_reg
    cmp  byte [rsi+2], 'l'
    jne  .mem_reg
    cmp  byte [rsi+3], ' '
    jne  .mem_reg
    add  rsi, 4
    ; measure the name up to ']' OR '+' (whichever comes first)
    mov  qword [rel cur_addend], 0
    mov  rcx, rsi
    call len_until_plus_or_bracket   ; rax = length of the name
    mov  rdx, rax
    ; an addend may follow: [rel x+8], [rel x + 2*8], [rel x - 4]. It took
    ; only '+' and a plain number, right after the name: [rel x + 32] lost
    ; its 32, and [rel x + 2*8] was taken as x + 2.
    mov  r8, rsi
    add  r8, rax
    jmp  .rel_blank
.rel_blank:
    cmp  byte [r8], ' '
    jne  .rel_sign
    inc  r8
    jmp  .rel_blank
.rel_sign:
    cmp  byte [r8], '+'
    je   .rel_add
    cmp  byte [r8], '-'
    jne  .rel_no_addend
    push rdx
    push r12
    lea  rcx, [r8+1]
    call parse_expr
    pop  r12
    neg  eax
    mov  [rel cur_addend], eax
    pop  rdx
    jmp  .rel_no_addend
.rel_add:
    push rdx
    push r12
    lea  rcx, [r8+1]
    call parse_expr
    pop  r12
    mov  [rel cur_addend], eax
    pop  rdx
.rel_no_addend:
    ; rdx already holds the name length measured above
    mov  rcx, rsi
    call qualify_label
    call kasm_find_label
    mov  edx, eax
    mov  eax, 5
    jmp  .out

.mem_reg:
    ; [rbp-N] or [reg] or [reg+reg]
    mov  rcx, rsi
    lea  rdx, [rel reg64_names]
    call match_reg_prefix        ; -> eax = reg, ecx = chars consumed
    cmp  eax, -1
    je   .none
    mov  r12d, eax
    add  rsi, rcx
    ; hand-written assembly spaces its operands: [r12 + 0] as well as [rbp-8],
    ; so skip blanks before and after the sign.
    call skip_blanks_rsi
    cmp  byte [rsi], '-'
    je   .mem_disp
    cmp  byte [rsi], '+'
    je   .mem_maybe_index
    mov  edx, r12d
    mov  eax, 9                  ; plain [reg]
    jmp  .out
.mem_maybe_index:
    inc  rsi                     ; step over '+'
    call skip_blanks_rsi
    dec  rsi                     ; .mem_disp_pos expects to consume one char
    mov  al, [rsi+1]
    cmp  al, 'r'
    je   .mem_index
    cmp  al, 'e'
    je   .mem_index
    jmp  .mem_disp_pos
.mem_index:
    inc  rsi
    mov  rcx, rsi
    lea  rdx, [rel reg64_names]
    call match_reg_prefix
    cmp  eax, -1
    je   .none
    mov  edx, r12d
    mov  ecx, eax
    shl  ecx, 8
    or   edx, ecx
    ; optional scale: [base + index*N] with N in {1,2,4,8}
    ; encoded as log2(N) in bits 16-17, which is the SIB scale field.
    ; match_reg_prefix does not advance rsi, so step over the register name
    ; before looking for the '*'.
.mem_skip_reg:
    mov  al, [rsi]
    cmp  al, 'a'
    jb   .mem_skip_digit
    cmp  al, 'z'
    jbe  .mem_skip_adv
.mem_skip_digit:
    cmp  al, '0'
    jb   .mem_scale
    cmp  al, '9'
    ja   .mem_scale
.mem_skip_adv:
    inc  rsi
    jmp  .mem_skip_reg
.mem_scale:
    mov  al, [rsi]
    cmp  al, '*'
    jne  .mem_scale_done
    mov  al, [rsi+1]
    cmp  al, '2'
    je   .msc_2
    cmp  al, '4'
    je   .msc_4
    cmp  al, '8'
    je   .msc_8
    jmp  .mem_scale_done         ; *1 or anything else: scale stays 0
.msc_2:
    or   edx, 0x010000
    jmp  .mem_scale_done
.msc_4:
    or   edx, 0x020000
    jmp  .mem_scale_done
.msc_8:
    or   edx, 0x030000
.mem_scale_done:
    ; an optional displacement may follow: [r9 + rcx*4 - 4]
    mov  dword [rel sib_disp], 0
    push rdx
.msd_skipreg:
    mov  al, [rsi]
    cmp  al, '*'
    je   .msd_adv
    cmp  al, '0'
    jb   .msd_chkalpha
    cmp  al, '9'
    jbe  .msd_adv
.msd_chkalpha:
    or   al, 0x20
    cmp  al, 'a'
    jb   .msd_after
    cmp  al, 'z'
    ja   .msd_after
.msd_adv:
    inc  rsi
    jmp  .msd_skipreg
.msd_after:
    call skip_blanks_rsi
    mov  al, [rsi]
    cmp  al, '+'
    je   .msd_plus
    cmp  al, '-'
    je   .msd_minus
    jmp  .msd_out
.msd_plus:
    inc  rsi
    call skip_blanks_rsi
    mov  rcx, rsi
    push r12
    call parse_expr
    pop  r12
    mov  [rel sib_disp], eax
    jmp  .msd_out
.msd_minus:
    inc  rsi
    call skip_blanks_rsi
    mov  rcx, rsi
    push r12
    call parse_expr
    pop  r12
    neg  eax
    mov  [rel sib_disp], eax
.msd_out:
    pop  rdx
    mov  eax, 12                 ; [base+index*scale(+disp)] SIB
    jmp  .out
.mem_disp:
    inc  rsi
    call skip_blanks_rsi
    mov  rcx, rsi
    push r12
    call parse_expr              ; resolves 'equ' constants, not just digits
    pop  r12
    mov  edx, eax
    cmp  r12d, 5                 ; rbp keeps the historical kind 3
    jne  .mem_disp_other
    mov  eax, 3                  ; [rbp-N]
    jmp  .out
.mem_disp_other:
    mov  r8d, r12d               ; base register goes in the extra slot
    mov  eax, 13                 ; [base-N]
    jmp  .out
.mem_disp_pos:
    cmp  r12d, 4                 ; rsp?
    jne  .mem_disp_pos_generic
    inc  rsi
    call skip_blanks_rsi
    mov  rcx, rsi
    push r12
    call parse_expr
    pop  r12
    mov  edx, eax
    mov  eax, 11                 ; [rsp+N]
    jmp  .out
.mem_disp_pos_generic:
    inc  rsi
    call skip_blanks_rsi
    mov  rcx, rsi
    push r12
    call parse_expr
    pop  r12
    neg  eax
    mov  edx, eax
    cmp  r12d, 5
    jne  .mem_dpos_other
    mov  eax, 3
    jmp  .out
.mem_dpos_other:
    mov  r8d, r12d
    mov  eax, 13
    jmp  .out

.none:
    xor  eax, eax
    xor  edx, edx
.out:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; match_reg_table(rcx = text, rdx = table) -> eax = index or -1
; table entries are 4 bytes each, 16 entries
match_reg_table:
    push r8
    mov  r8d, 16
    call match_reg_table_n
    pop  r8
    ret

; match_reg_table_n(rcx = text, rdx = table, r8d = count) -> eax = index or -1
match_reg_table_n:
    push rbx
    push rsi
    push rdi
    xor  ebx, ebx
.l:
    cmp  ebx, r8d
    jae  .nf
    mov  rdi, rdx
    mov  eax, ebx
    imul eax, eax, 5
    add  rdi, rax
.cmp_start:
    mov  rsi, rcx
.cmp:
    mov  al, [rdi]
    test al, al
    jz   .end_of_name
    cmp  al, [rsi]
    jne  .next
    inc  rdi
    inc  rsi
    jmp  .cmp
.end_of_name:
    cmp  byte [rsi], 0
    jne  .next
    mov  eax, ebx
    jmp  .out
.next:
    inc  ebx
    jmp  .l
.nf:
    mov  eax, -1
.out:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; match_reg_prefix(rcx = text, rdx = table) -> eax = index or -1, ecx = length
match_reg_prefix:
    push rbx
    push rsi
    push rdi
    push r9
    mov  r9, rcx
    xor  ebx, ebx
.l:
    cmp  ebx, 16
    jae  .nf
    mov  rdi, rdx
    mov  eax, ebx
    imul eax, eax, 5
    add  rdi, rax
    mov  rsi, r9
    xor  ecx, ecx
.cmp:
    mov  al, [rdi]
    test al, al
    jz   .matched
    cmp  al, [rsi]
    jne  .next
    inc  rdi
    inc  rsi
    inc  ecx
    jmp  .cmp
.matched:
    mov  eax, ebx
    jmp  .out
.next:
    inc  ebx
    jmp  .l
.nf:
    mov  eax, -1
    xor  ecx, ecx
.out:
    pop  r9
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; parse_float(rcx = text) -> xmm0 = the value
; Accepts [-]ddd[.ddd]. Needed because `dq 3.14` in a data section must become
; an IEEE-754 double, not the integer 3.
; ==============================================================================
parse_float:
    push rbx
    push rsi
    push rdi
    push rcx
    mov  rsi, rcx
    xor  edi, edi                ; sign flag
    cmp  byte [rsi], '-'
    jne  .pf_int
    mov  edi, 1
    inc  rsi
.pf_int:
    xor  rax, rax
.pf_il:
    movzx ebx, byte [rsi]
    cmp  bl, '0'
    jb   .pf_idone
    cmp  bl, '9'
    ja   .pf_idone
    imul rax, rax, 10
    sub  rbx, 48
    add  rax, rbx
    inc  rsi
    jmp  .pf_il
.pf_idone:
    cvtsi2sd xmm0, rax
    cmp  byte [rsi], '.'
    jne  .pf_sign
    inc  rsi
    xor  rax, rax                ; fraction digits
    mov  rcx, 1                  ; matching power of ten
    xor  edx, edx                ; digits taken so far
.pf_fl:
    movzx ebx, byte [rsi]
    cmp  bl, '0'
    jb   .pf_fdone
    cmp  bl, '9'
    ja   .pf_fdone
    cmp  edx, 17                 ; a double holds ~17 digits; ignore the rest
    jae  .pf_fskip
    imul rax, rax, 10
    sub  rbx, 48
    add  rax, rbx
    imul rcx, rcx, 10
    inc  edx
.pf_fskip:
    inc  rsi
    jmp  .pf_fl
.pf_fdone:
    test rax, rax
    jz   .pf_exp
    cvtsi2sd xmm1, rax
    cvtsi2sd xmm2, rcx
    divsd xmm1, xmm2
    addsd xmm0, xmm1
.pf_exp:
    ; e+N / e-N: times or divided by ten, N times
    movzx ebx, byte [rsi]
    cmp  bl, 'e'
    je   .pf_e
    cmp  bl, 'E'
    jne  .pf_sign
.pf_e:
    inc  rsi
    xor  edx, edx                ; 1 when the exponent is negative
    cmp  byte [rsi], '+'
    jne  .pf_eneg
    inc  rsi
    jmp  .pf_edig
.pf_eneg:
    cmp  byte [rsi], '-'
    jne  .pf_edig
    mov  edx, 1
    inc  rsi
.pf_edig:
    xor  ecx, ecx
.pf_el:
    movzx ebx, byte [rsi]
    cmp  bl, '0'
    jb   .pf_eapply
    cmp  bl, '9'
    ja   .pf_eapply
    imul ecx, ecx, 10
    sub  ebx, 48
    add  ecx, ebx
    inc  rsi
    cmp  ecx, 400
    jb   .pf_el
    mov  ecx, 400
    jmp  .pf_el
.pf_eapply:
    mov  rax, 10
    cvtsi2sd xmm1, rax
.pf_es:
    test ecx, ecx
    jz   .pf_sign
    test edx, edx
    jnz  .pf_ediv
    mulsd xmm0, xmm1
    jmp  .pf_enext
.pf_ediv:
    divsd xmm0, xmm1
.pf_enext:
    dec  ecx
    jmp  .pf_es
.pf_sign:
    test edi, edi
    jz   .pf_out
    xorps xmm1, xmm1
    subsd xmm1, xmm0
    movsd xmm0, xmm1
.pf_out:
    pop  rcx
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; parse_number(rcx = text) -> rax = value, handles decimal and 0x hex
; ==============================================================================
; Expression evaluator.  Hand-written assembly uses forms the code generator
; never emits:   ((2 * 1024 * 1024) / 24)   and   ($ - table) / 16
;
; parse_expr(rcx = text) -> rax = value
; Recursive descent over two precedence levels, with parentheses, decimal and
; hex numbers, character literals, '$' for the current offset, and names that
; resolve against the equ constants and then the label table.
; ==============================================================================
parse_expr:
    mov  [rel expr_ptr], rcx
    call ex_or
    ret

ex_or:
    push rbx
    call ex_and
    mov  rbx, rax
.l:
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    cmp  byte [rcx], '|'
    jne  .out
    inc  qword [rel expr_ptr]
    call ex_and
    or   rbx, rax
    jmp  .l
.out:
    mov  rax, rbx
    pop  rbx
    ret

ex_and:
    push rbx
    call ex_shift
    mov  rbx, rax
.l:
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    cmp  byte [rcx], '&'
    jne  .out
    inc  qword [rel expr_ptr]
    call ex_shift
    and  rbx, rax
    jmp  .l
.out:
    mov  rax, rbx
    pop  rbx
    ret

ex_shift:
    push rbx
    call ex_addsub
    mov  rbx, rax
.l:
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    mov  al, [rcx]
    cmp  al, '<'
    je   .maybe_shl
    cmp  al, '>'
    je   .maybe_shr
    jmp  .out
.maybe_shl:
    cmp  byte [rcx+1], '<'
    jne  .out
    add  qword [rel expr_ptr], 2
    call ex_addsub
    mov  rcx, rax
    shl  rbx, cl
    jmp  .l
.maybe_shr:
    cmp  byte [rcx+1], '>'
    jne  .out
    add  qword [rel expr_ptr], 2
    call ex_addsub
    mov  rcx, rax
    sar  rbx, cl
    jmp  .l
.out:
    mov  rax, rbx
    pop  rbx
    ret

ex_skipws:
    push rcx
.l:
    mov  rcx, [rel expr_ptr]
    mov  al, [rcx]
    cmp  al, ' '
    je   .adv
    cmp  al, 9
    jne  .out
.adv:
    inc  qword [rel expr_ptr]
    jmp  .l
.out:
    pop  rcx
    ret

ex_addsub:
    push rbx
    call ex_muldiv
    mov  rbx, rax
.l:
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    mov  al, [rcx]
    cmp  al, '+'
    je   .plus
    cmp  al, '-'
    je   .minus
    mov  rax, rbx
    pop  rbx
    ret
.plus:
    inc  qword [rel expr_ptr]
    call ex_muldiv
    add  rbx, rax
    jmp  .l
.minus:
    inc  qword [rel expr_ptr]
    call ex_muldiv
    sub  rbx, rax
    jmp  .l

ex_muldiv:
    push rbx
    call ex_primary
    mov  rbx, rax
.l:
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    mov  al, [rcx]
    cmp  al, '*'
    je   .mul
    cmp  al, '/'
    je   .div
    mov  rax, rbx
    pop  rbx
    ret
.mul:
    inc  qword [rel expr_ptr]
    call ex_primary
    imul rbx, rax
    jmp  .l
.div:
    inc  qword [rel expr_ptr]
    call ex_primary
    test rax, rax
    jz   .l                      ; division by zero: leave the value alone
    push rax
    mov  rax, rbx
    cqo
    pop  rcx
    idiv rcx
    mov  rbx, rax
    jmp  .l

ex_primary:
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    mov  al, [rcx]
    cmp  al, '('
    je   .paren
    cmp  al, '$'
    je   .here_sym
    cmp  al, 0x27
    je   .charlit
    cmp  al, '-'
    je   .negate
    cmp  al, '~'
    je   .bitnot
    cmp  al, '0'
    jb   .symbol
    cmp  al, '9'
    ja   .symbol
    jmp  ex_number
.paren:
    inc  qword [rel expr_ptr]
    call ex_addsub
    push rax
    call ex_skipws
    mov  rcx, [rel expr_ptr]
    cmp  byte [rcx], ')'
    jne  .no_close
    inc  qword [rel expr_ptr]
.no_close:
    pop  rax
    ret
.here_sym:
    inc  qword [rel expr_ptr]
    call here
    ret
.negate:
    inc  qword [rel expr_ptr]
    call ex_primary
    neg  rax
    ret
.bitnot:
    inc  qword [rel expr_ptr]
    call ex_primary
    not  rax
    ret
.charlit:
    ; A quoted literal may hold up to four characters, packed little-endian:
    ; 'jupi' is 0x6970756a, not 0x6a. This path read one byte and stepped a
    ; fixed three, so every multi-character compare in the compiler tested
    ; against its first letter alone. The other site was fixed months ago;
    ; this one was missed, and it is the one the module-header check uses.
    push rbx
    push rdx
    mov  rcx, [rel expr_ptr]
    inc  rcx                         ; past the opening quote
    xor  eax, eax
    mov  edx, 1                      ; place value of the next character
    xor  ebx, ebx                    ; characters consumed
.cl_loop:
    movzx r8d, byte [rcx]
    cmp  r8b, 0x27                   ; closing quote
    je   .cl_done
    cmp  r8b, 0x22                   ; closing double quote
    je   .cl_done
    test r8b, r8b
    jz   .cl_done
    cmp  ebx, 4
    jae  .cl_skip
    ; Build the value by multiplying instead of shifting by a variable
    ; amount: 'shl r8d, cl' appears nowhere else in this assembler, and it
    ; has to assemble itself with whatever it supports.
    push rcx
    mov  ecx, edx                    ; 1, 256, 65536, 16777216
    imul r8d, ecx
    pop  rcx
    or   eax, r8d
    imul edx, edx, 256
.cl_skip:
    inc  ebx
    inc  rcx
    jmp  .cl_loop
.cl_done:
    inc  rcx                         ; past the closing quote
    mov  [rel expr_ptr], rcx
    pop  rdx
    pop  rbx
    ret
.symbol:
    jmp  ex_symbol

; decimal or 0x hex, advancing expr_ptr
ex_number:
    push rbx
    mov  rcx, [rel expr_ptr]
    cmp  byte [rcx], '0'
    jne  .dec
    mov  al, [rcx+1]
    cmp  al, 'x'
    je   .hex
    cmp  al, 'X'
    je   .hex
.dec:
    xor  rax, rax
.dl:
    mov  rcx, [rel expr_ptr]
    movzx ebx, byte [rcx]
    cmp  bl, '0'
    jb   .out
    cmp  bl, '9'
    ja   .out
    imul rax, rax, 10
    sub  rbx, 48
    add  rax, rbx
    inc  qword [rel expr_ptr]
    jmp  .dl
.hex:
    add  qword [rel expr_ptr], 2
    xor  rax, rax
.hl:
    mov  rcx, [rel expr_ptr]
    movzx ebx, byte [rcx]
    cmp  bl, '0'
    jb   .out
    cmp  bl, '9'
    jbe  .hdig
    or   bl, 0x20                ; fold to lower case
    cmp  bl, 'a'
    jb   .out
    cmp  bl, 'f'
    ja   .out
    sub  rbx, 87                 ; 'a' - 10
    jmp  .hadd
.hdig:
    sub  rbx, 48
.hadd:
    shl  rax, 4
    add  rax, rbx
    inc  qword [rel expr_ptr]
    jmp  .hl
.out:
    pop  rbx
    ret

; a name: an equ constant if known, otherwise a label offset, else zero
ex_symbol:
    push rbx
    push rsi
    mov  rsi, [rel expr_ptr]
    xor  rbx, rbx                ; name length
.scan:
    movzx eax, byte [rsi + rbx]
    cmp  al, '_'
    je   .take
    cmp  al, '.'
    je   .take
    cmp  al, '0'
    jb   .scan_done
    cmp  al, '9'
    jbe  .take
    or   al, 0x20
    cmp  al, 'a'
    jb   .scan_done
    cmp  al, 'z'
    ja   .scan_done
.take:
    inc  rbx
    jmp  .scan
.scan_done:
    add  [rel expr_ptr], rbx
    mov  rcx, rsi
    mov  rdx, rbx
    call find_equ
    cmp  eax, -1
    je   .try_label
    lea  rdx, [rel equ_value]
    mov  rax, [rdx + rax*8]
    pop  rsi
    pop  rbx
    ret
.try_label:
    mov  rcx, rsi
    mov  rdx, rbx
    call qualify_label
    call kasm_find_label
    cmp  eax, -1
    je   .unknown
    call kasm_label_addr
    pop  rsi
    pop  rbx
    ret
.unknown:
    xor  rax, rax
    pop  rsi
    pop  rbx
    ret

; find_equ(rcx = name, rdx = length) -> rax = index or -1
find_equ:
    push rbx
    push rsi
    push rdi
    push r12
    mov  rsi, rcx
    mov  r12, rdx
    xor  rbx, rbx
.l:
    cmp  rbx, [rel equ_count]
    jae  .no
    lea  rdi, [rel equ_name_off]
    mov  eax, [rdi + rbx*4]
    lea  rdi, [rel equ_names]
    add  rdi, rax
    xor  rcx, rcx
.cmp:
    cmp  rcx, r12
    je   .end_of_name
    mov  al, [rsi + rcx]
    cmp  al, [rdi + rcx]
    jne  .next
    inc  rcx
    jmp  .cmp
.end_of_name:
    cmp  byte [rdi + rcx], 0
    jne  .next
    mov  rax, rbx
    jmp  .out
.next:
    inc  rbx
    jmp  .l
.no:
    mov  rax, -1
.out:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; add_equ(rcx = name, rdx = length, r8 = value)
add_equ:
    push rbx
    push rsi
    push rdi
    ; The same header reaches the assembler once per module, so a constant
    ; may be defined many times with the same value. Refresh it in place
    ; instead of filling the table with copies.
    push rcx
    push rdx
    push r8
    call find_equ
    pop  r8
    pop  rdx
    pop  rcx
    cmp  eax, -1
    je   .fresh
    lea  rdx, [rel equ_value]
    mov  [rdx + rax*8], r8
    jmp  .out
.fresh:
    mov  rbx, [rel equ_count]
    cmp  rbx, 8192
    jae  .equ_full
    mov  rax, [rel equ_names_len]
    add  rax, rdx
    add  rax, 2
    cmp  rax, 262144
    jae  .equ_full
    mov  rax, [rel equ_names_len]
    lea  rdi, [rel equ_name_off]
    mov  [rdi + rbx*4], eax
    lea  rdi, [rel equ_names]
    add  rdi, rax
    mov  rsi, rcx
    xor  rcx, rcx
.cp:
    cmp  rcx, rdx
    je   .cp_done
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    inc  rcx
    jmp  .cp
.cp_done:
    mov  byte [rdi + rcx], 0
    inc  rcx
    add  [rel equ_names_len], rcx
    lea  rdi, [rel equ_value]
    mov  [rdi + rbx*8], r8
    inc  rbx
    mov  [rel equ_count], rbx
    jmp  .out
.equ_full:
    ; Running out of room here used to be silent, and every constant declared
    ; afterwards then evaluated as zero -- which is how CG_MAX_VARS became 0
    ; and codegen refused the first variable it was asked to allocate.
    mov  byte [rel kasm_error], 1
.out:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

parse_number:
    push rbx
    push rsi
    push r12
    mov  rsi, rcx
    xor  r12d, r12d              ; sign flag
    cmp  byte [rsi], '-'
    jne  .nosign
    mov  r12d, 1
    inc  rsi
.nosign:
    xor  rax, rax
    cmp  byte [rsi], '0'
    jne  .dec
    cmp  byte [rsi+1], 'x'
    je   .hex
    cmp  byte [rsi+1], 'X'
    je   .hex
.dec:
    xor  rax, rax
.dl:
    movzx ebx, byte [rsi]
    cmp  bl, '0'
    jb   .done
    cmp  bl, '9'
    ja   .done
    sub  bl, '0'
    imul rax, rax, 10
    add  rax, rbx
    inc  rsi
    jmp  .dl
.hex:
    add  rsi, 2
    xor  rax, rax
.hl:
    movzx ebx, byte [rsi]
    cmp  bl, '0'
    jb   .done
    cmp  bl, '9'
    jbe  .hdig
    or   bl, 0x20
    cmp  bl, 'a'
    jb   .done
    cmp  bl, 'f'
    ja   .done
    sub  bl, 'a' - 10
    jmp  .hadd
.hdig:
    sub  bl, '0'
.hadd:
    shl  rax, 4
    add  rax, rbx
    inc  rsi
    jmp  .hl
.done:
    test r12d, r12d
    jz   .nonegate
    neg  rax
.nonegate:
    pop  r12
    pop  rsi
    pop  rbx
    ret

; str_len_local(rcx = ptr) -> rax = length
str_len_local:
    xor  rax, rax
.l:
    cmp  byte [rcx + rax], 0
    je   .d
    inc  rax
    jmp  .l
.d:
    ret

; len_until_bracket(rcx = ptr) -> rax = chars before ']' or end
len_until_bracket:
    xor  rax, rax
.l:
    movzx edx, byte [rcx + rax]
    test dl, dl
    jz   .d
    cmp  dl, ']'
    je   .d
    inc  rax
    jmp  .l
.d:
    ret

; len_until_plus_or_bracket(rcx=text) -> rax = chars of the name: up to a
; '+', '-', blank or ']'
len_until_plus_or_bracket:
    xor  rax, rax
.l:
    movzx edx, byte [rcx + rax]
    test dl, dl
    jz   .d
    cmp  dl, ']'
    je   .d
    cmp  dl, '+'
    je   .d
    cmp  dl, '-'
    je   .d
    cmp  dl, ' '
    je   .d
    inc  rax
    jmp  .l
.d:
    ret

; ==============================================================================
; LINE TOKENISER
; Splits "    mov rax, [rbp-8]" into tok_a="mov", tok_b="rax", tok_c="[rbp-8]".
; A line ending in ':' is a label definition and leaves tok_a empty.
; ==============================================================================
; split_line(rcx = line ptr) -> al = 1 when it is a label definition
split_line:
    push rbx
    push rsi
    push rdi
    mov  rsi, rcx
    mov  byte [rel tok_a], 0
    mov  byte [rel tok_b], 0
    mov  byte [rel tok_c], 0

    ; skip leading blanks
.skip:
    mov  al, [rsi]
    cmp  al, ' '
    je   .adv
    cmp  al, 9
    je   .adv
    jmp  .have
.adv:
    inc  rsi
    jmp  .skip
.have:
    test al, al
    jz   .empty
    cmp  al, ';'
    je   .empty

    ; copy the first word
    lea  rdi, [rel tok_a]
    xor  ebx, ebx
.w1:
    mov  al, [rsi]
    test al, al
    jz   .w1_end
    cmp  al, ' '
    je   .w1_end
    cmp  al, 9
    je   .w1_end
    cmp  al, ':'
    je   .is_label
    cmp  ebx, 62
    jae  .w1_end
    mov  [rdi + rbx], al
    inc  ebx
    inc  rsi
    jmp  .w1
.w1_end:
    mov  byte [rdi + rbx], 0
    ; NASM allows a label to omit its colon when a data directive follows,
    ; as in   kw_var db "var", 0   -- peek ahead and treat it as a label.
    push rsi
    call skip_blanks_rsi
    mov  rcx, rsi
    call is_data_dir
    test al, al
    jz   .w1_not_label
    add  rsp, 8                  ; drop the saved rsi, keep the advanced one
    jmp  .is_label_body
.w1_not_label:
    pop  rsi

    mov  byte [rel op_size], 0
    call skip_blanks_rsi
    cmp  byte [rsi], 'b'
    jne  .not_byte
    cmp  byte [rsi+1], 'y'
    jne  .not_byte
    cmp  byte [rsi+2], 't'
    jne  .not_byte
    cmp  byte [rsi+3], 'e'
    jne  .not_byte
    cmp  byte [rsi+4], ' '
    jne  .not_byte
    mov  byte [rel op_size], 1
    add  rsi, 5
    jmp  .size_done
.not_byte:
    cmp  byte [rsi], 'q'
    jne  .not_qword
    cmp  byte [rsi+1], 'w'
    jne  .not_qword
    cmp  byte [rsi+2], 'o'
    jne  .not_qword
    cmp  byte [rsi+3], 'r'
    jne  .not_qword
    cmp  byte [rsi+4], 'd'
    jne  .not_qword
    cmp  byte [rsi+5], ' '
    jne  .not_qword
    mov  byte [rel op_size], 8
    add  rsi, 6
    jmp  .size_done
.not_qword:
    cmp  byte [rsi], 'd'
    jne  .not_dword
    cmp  byte [rsi+1], 'w'
    jne  .not_dword
    cmp  byte [rsi+2], 'o'
    jne  .not_dword
    cmp  byte [rsi+3], 'r'
    jne  .not_dword
    cmp  byte [rsi+4], 'd'
    jne  .not_dword
    cmp  byte [rsi+5], ' '
    jne  .not_dword
    mov  byte [rel op_size], 4
    add  rsi, 6
    jmp  .size_done
.not_dword:
    cmp  byte [rsi], 'w'
    jne  .size_done
    cmp  byte [rsi+1], 'o'
    jne  .size_done
    cmp  byte [rsi+2], 'r'
    jne  .size_done
    cmp  byte [rsi+3], 'd'
    jne  .size_done
    cmp  byte [rsi+4], ' '
    jne  .size_done
    mov  byte [rel op_size], 2
    add  rsi, 5
.size_done:
    call skip_blanks_rsi
    lea  rdi, [rel tok_b]
    xor  ebx, ebx
    xor  edx, edx                ; quote state: 0 outside, else the open quote
.w2:
    mov  al, [rsi]
    test al, al
    jz   .w2_end
    test dl, dl
    jnz  .w2_inq
    cmp  al, ','
    je   .w2_comma
    cmp  al, ';'
    je   .w2_end
    cmp  al, 0x27
    je   .w2_open
    cmp  al, 0x22
    je   .w2_open
    jmp  .w2_store
.w2_open:
    mov  dl, al
    jmp  .w2_store
.w2_inq:
    cmp  al, dl
    jne  .w2_store
    xor  edx, edx
.w2_store:
    cmp  ebx, 510
    jae  .w2_end
    mov  [rdi + rbx], al
    inc  ebx
    inc  rsi
    jmp  .w2
.w2_comma:
    inc  rsi
.w2_end:
    ; trim trailing blanks
    call trim_tok_b
    mov  byte [rdi + rbx], 0
    call trim_tok_b

    ; second operand
    call skip_blanks_rsi
    lea  rdi, [rel tok_c]
    xor  ebx, ebx
    xor  edx, edx                ; quote state
.w3:
    mov  al, [rsi]
    test al, al
    jz   .w3_end
    test dl, dl
    jnz  .w3_inq
    ; a ';' inside a character literal is data, not a comment. Cutting
    ; there turned  cmp r14b, ';'  into  cmp r14b, 0  and the lexer
    ; stopped recognising semicolons altogether.
    cmp  al, ';'
    je   .w3_end
    cmp  al, 0x27
    je   .w3_open
    cmp  al, 0x22
    je   .w3_open
    jmp  .w3_store
.w3_open:
    mov  dl, al
    jmp  .w3_store
.w3_inq:
    cmp  al, dl
    jne  .w3_store
    xor  edx, edx
.w3_store:
    cmp  ebx, 510
    jae  .w3_end
    mov  [rdi + rbx], al
    inc  ebx
    inc  rsi
    jmp  .w3
.w3_end:
    mov  byte [rdi + rbx], 0
    call trim_tok_c
    xor  al, al
    jmp  .out

.is_label:
    mov  byte [rdi + rbx], 0
    ; a definition may follow on the same line, as in  name: dq 0
    inc  rsi                     ; step past ':'
.is_label_body:
    call skip_blanks_rsi
    cmp  byte [rsi], 0
    je   .label_only
    cmp  byte [rsi], ';'
    je   .label_only
    ; Keep the remainder verbatim. Splitting it into two tokens only ever
    ; suited a data directive; an instruction has three, and both operands
    ; ended up crammed into tok_b.
    push rsi
    lea  rdi, [rel lbl_rest]
    xor  ebx, ebx
.lr_save:
    mov  al, [rsi]
    test al, al
    jz   .lr_save_end
    cmp  ebx, 510
    jae  .lr_save_end
    mov  [rdi + rbx], al
    inc  ebx
    inc  rsi
    jmp  .lr_save
.lr_save_end:
    mov  byte [rdi + rbx], 0
    pop  rsi
    ; move the remainder into tok_b / tok_c as if it were its own line
    lea  rdi, [rel tok_b]
    xor  ebx, ebx
.lw1:
    mov  al, [rsi]
    test al, al
    jz   .lw1_end
    cmp  al, ' '
    je   .lw1_end
    cmp  al, 9
    je   .lw1_end
    cmp  ebx, 510
    jae  .lw1_end
    mov  [rdi + rbx], al
    inc  ebx
    inc  rsi
    jmp  .lw1
.lw1_end:
    mov  byte [rdi + rbx], 0
    call skip_blanks_rsi
    lea  rdi, [rel tok_c]
    xor  ebx, ebx
    xor  edx, edx                ; quote state
.lw2:
    mov  al, [rsi]
    test al, al
    jz   .lw2_end
    test dl, dl
    jnz  .lw2_inq
    ; a ';' inside a character literal is data, not a comment. Cutting
    ; there turned  cmp r14b, ';'  into  cmp r14b, 0  and the lexer
    ; stopped recognising semicolons altogether.
    cmp  al, ';'
    je   .lw2_end
    cmp  al, 0x27
    je   .lw2_open
    cmp  al, 0x22
    je   .lw2_open
    jmp  .lw2_store
.lw2_open:
    mov  dl, al
    jmp  .lw2_store
.lw2_inq:
    cmp  al, dl
    jne  .lw2_store
    xor  edx, edx
.lw2_store:
    cmp  ebx, 510
    jae  .lw2_end
    mov  [rdi + rbx], al
    inc  ebx
    inc  rsi
    jmp  .lw2
.lw2_end:
    mov  byte [rdi + rbx], 0
    call trim_tok_c
    mov  al, 2                   ; label plus a trailing definition
    jmp  .out
.label_only:
    mov  al, 1
    jmp  .out
.empty:
    xor  al, al
.out:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

skip_blanks_rsi:
.l:
    mov  al, [rsi]
    cmp  al, ' '
    je   .a
    cmp  al, 9
    je   .a
    ret
.a:
    inc  rsi
    jmp  .l

trim_tok_b:
    push rax
    push rcx
    lea  rcx, [rel tok_b]
    call trim_trailing
    pop  rcx
    pop  rax
    ret
trim_tok_c:
    push rax
    push rcx
    lea  rcx, [rel tok_c]
    call trim_trailing
    pop  rcx
    pop  rax
    ret
trim_trailing:
    push rsi
    mov  rsi, rcx
    call str_len_local
    mov  rcx, rsi
.l:
    test rax, rax
    jz   .d
    movzx edx, byte [rcx + rax - 1]
    cmp  dl, ' '
    je   .cut
    cmp  dl, 9
    je   .cut
    jmp  .d
.cut:
    dec  rax
    mov  byte [rcx + rax], 0
    jmp  .l
.d:
    pop  rsi
    ret

; copy_tok(rcx = src, rdx = dst)
copy_tok:
    push rsi
    push rdi
    mov  rsi, rcx
    mov  rdi, rdx
.l:
    mov  al, [rsi]
    mov  [rdi], al
    test al, al
    jz   .d
    inc  rsi
    inc  rdi
    jmp  .l
.d:
    pop  rdi
    pop  rsi
    ret

; is_data_dir(rcx = text) -> al = 1 when it starts with a data directive
; followed by whitespace: db, dq, resb, resq, times.
is_data_dir:
    push rsi
    push rdi
    push rbx
    mov  rsi, rcx
    lea  rbx, [rel dd_table]
.dd_next:
    mov  rdi, [rbx]
    test rdi, rdi
    jz   .dd_no
    mov  rcx, rsi
    mov  rdx, rdi
.dd_cmp:
    mov  al, [rdx]
    test al, al
    jz   .dd_endname
    cmp  al, [rcx]
    jne  .dd_advance
    inc  rcx
    inc  rdx
    jmp  .dd_cmp
.dd_endname:
    mov  al, [rcx]               ; must be followed by blank or end
    cmp  al, ' '
    je   .dd_yes
    cmp  al, 9
    je   .dd_yes
.dd_advance:
    add  rbx, 8
    jmp  .dd_next
.dd_yes:
    mov  al, 1
    pop  rbx
    pop  rdi
    pop  rsi
    ret
.dd_no:
    xor  al, al
    pop  rbx
    pop  rdi
    pop  rsi
    ret

; qualify_label(rcx = name, rdx = length) -> rcx = name, rdx = length
; A name starting with '.' belongs to the innermost non-local label, exactly
; as in NASM. Without this, the .l and .out of every routine collide, which
; matters the moment the assembler is pointed at its own source.
qualify_label:
    cmp  byte [rcx], '.'
    je   .ql_build
    ret                          ; already global: leave it alone
.ql_build:
    push rsi
    push rdi
    push rbx
    mov  rsi, rcx
    mov  rbx, rdx
    lea  rdi, [rel qual_buf]
    xor  rcx, rcx
    lea  rdx, [rel cur_global]
.ql_cg:
    mov  al, [rdx + rcx]
    test al, al
    jz   .ql_cg_done
    cmp  rcx, 60
    jae  .ql_cg_done
    mov  [rdi + rcx], al
    inc  rcx
    jmp  .ql_cg
.ql_cg_done:
    xor  rdx, rdx
.ql_loc:
    cmp  rdx, rbx
    je   .ql_out
    cmp  rcx, 156
    jae  .ql_out
    mov  al, [rsi + rdx]
    mov  [rdi + rcx], al
    inc  rcx
    inc  rdx
    jmp  .ql_loc
.ql_out:
    mov  byte [rdi + rcx], 0
    mov  rdx, rcx
    lea  rcx, [rel qual_buf]
    pop  rbx
    pop  rdi
    pop  rsi
    ret

; str_eq(rcx = a, rdx = b) -> al = 1 when equal
str_eq:
    push rsi
    push rdi
    mov  rsi, rcx
    mov  rdi, rdx
.l:
    mov  al, [rsi]
    cmp  al, [rdi]
    jne  .no
    test al, al
    jz   .yes
    inc  rsi
    inc  rdi
    jmp  .l
.no:
    xor  al, al
    pop  rdi
    pop  rsi
    ret
.yes:
    mov  al, 1
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; INSTRUCTION ENCODING
; encode_line() assembles whatever is in tok_a / tok_b / tok_c.
; ==============================================================================
%macro MNEMONIC_IS 2
    lea  rcx, [rel tok_a]
    lea  rdx, [rel %1]
    call str_eq
    test al, al
    jnz  %2
%endmacro

section .data
    m_mov:   db "mov",0
    m_xchg:  db "xchg",0
    m_push:  db "push",0
    m_pop:   db "pop",0
    m_add:   db "add",0
    m_sub:   db "sub",0
    m_imul:  db "imul",0
    m_mul:   db "mul",0
    m_idiv:  db "idiv",0
    m_div:   db "div",0
    m_cqo:   db "cqo",0
    m_cmp:   db "cmp",0
    m_test:  db "test",0
    m_xor:   db "xor",0
    m_neg:   db "neg",0
    m_inc:   db "inc",0
    m_dec:   db "dec",0
    m_lea:   db "lea",0
    m_ret:   db "ret",0
    m_call:  db "call",0
    m_jmp:   db "jmp",0
    m_je:    db "je",0
    m_jz:    db "jz",0
    m_jne:   db "jne",0
    m_jnz:   db "jnz",0
    m_jns:   db "jns",0
    m_jbe:   db "jbe",0
    m_hlt:   db "hlt",0
    m_cli:   db "cli",0
    m_syscl: db "syscall",0
    m_iretq: db "iretq",0
    m_movzx: db "movzx",0
    m_movsx: db "movsx",0
    m_sete:  db "sete",0
    m_setne: db "setne",0
    m_setl:  db "setl",0
    m_setg:  db "setg",0
    m_setle: db "setle",0
    m_setge: db "setge",0
    m_setb:  db "setb",0
    m_setae: db "setae",0
    m_seta:  db "seta",0
    m_setbe: db "setbe",0
    m_in:    db "in",0
    m_out:   db "out",0
    ; --- packed SSE: four floats or two doubles at a time ---------------
    ; Same shape as the scalar forms, different prefix: none for 'ps',
    ; 66 for 'pd'. The opcodes are identical.
    m_addps: db "addps",0
    m_subps: db "subps",0
    m_mulps: db "mulps",0
    m_divps: db "divps",0
    m_addpd: db "addpd",0
    m_subpd: db "subpd",0
    m_mulpd: db "mulpd",0
    m_divpd: db "divpd",0
    m_movaps:db "movaps",0
    m_movups:db "movups",0
    m_movapd:db "movapd",0
    m_movupd:db "movupd",0
    m_sqrtps:db "sqrtps",0
    m_sqrtpd:db "sqrtpd",0
    m_movsd: db "movsd",0
    m_movss: db "movss",0
    m_cvtss2sd: db "cvtss2sd",0
    m_cvtsd2ss: db "cvtsd2ss",0
    m_addsd: db "addsd",0
    m_subsd: db "subsd",0
    m_mulsd: db "mulsd",0
    m_divsd: db "divsd",0
    m_comisd:db "comisd",0
    m_ucomisd:db "ucomisd",0
    m_shl:   db "shl",0
    m_shr:   db "shr",0
    m_sar:   db "sar",0
    m_rol:   db "rol",0
    m_ror:   db "ror",0
    m_clflush:db "clflush",0
    m_prefetcht0:db "prefetcht0",0
    m_ja:     db "ja",0
    m_jae:    db "jae",0
    m_jb:     db "jb",0
    m_jg:     db "jg",0
    m_jge:    db "jge",0
    m_jl:     db "jl",0
    m_jle:    db "jle",0
    m_js2:    db "js",0
    m_and:    db "and",0
    m_or:     db "or",0
    m_not:    db "not",0
    m_rep:    db "rep",0
    m_movsb:  db "movsb",0
    m_stosb:  db "stosb",0
    m_cvtsi: db "cvtsi2sd",0
    m_cvtsd: db "cvtsd2si",0
    m_cvttsd:db "cvttsd2si",0
    m_xorps: db "xorps",0
    m_movq:  db "movq",0

section .text

; encode_line() -> emits the bytes for the instruction currently tokenised
encode_line:
    push rbx
    push rsi                     ; run_pass keeps the source cursor here
    push rdi
    push r12
    push r13
    push r14
    push r15

    mov  byte [rel rex8_force], 0
    cmp  byte [rel tok_a], 0
    je   .done

    MNEMONIC_IS m_mov,   .i_mov
    MNEMONIC_IS m_push,  .i_push
    MNEMONIC_IS m_pop,   .i_pop
    MNEMONIC_IS m_add,   .i_add
    MNEMONIC_IS m_sub,   .i_sub
    MNEMONIC_IS m_imul,  .i_imul
    MNEMONIC_IS m_mul,   .i_mul
    MNEMONIC_IS m_idiv,  .i_idiv
    MNEMONIC_IS m_div,   .i_div
    MNEMONIC_IS m_cqo,   .i_cqo
    MNEMONIC_IS m_cmp,   .i_cmp
    MNEMONIC_IS m_test,  .i_test
    MNEMONIC_IS m_xor,   .i_xor
    MNEMONIC_IS m_neg,   .i_neg
    MNEMONIC_IS m_inc,   .i_inc
    MNEMONIC_IS m_dec,   .i_dec
    MNEMONIC_IS m_lea,   .i_lea
    MNEMONIC_IS m_ret,   .i_ret
    MNEMONIC_IS m_call,  .i_call
    MNEMONIC_IS m_jmp,   .i_jmp
    MNEMONIC_IS m_je,    .i_je
    MNEMONIC_IS m_jz,    .i_je
    MNEMONIC_IS m_jne,   .i_jne
    MNEMONIC_IS m_jnz,   .i_jne
    MNEMONIC_IS m_jns,   .i_jns
    MNEMONIC_IS m_jbe,   .i_jbe
    MNEMONIC_IS m_hlt,   .i_hlt
    MNEMONIC_IS m_cli,   .i_cli
    MNEMONIC_IS m_syscl, .i_syscall
    MNEMONIC_IS m_iretq, .i_iretq
    MNEMONIC_IS m_movzx, .i_movzx
    MNEMONIC_IS m_movsx, .i_movsx
    MNEMONIC_IS m_sete,  .i_sete
    MNEMONIC_IS m_setne, .i_setne
    MNEMONIC_IS m_setl,  .i_setl
    MNEMONIC_IS m_setg,  .i_setg
    MNEMONIC_IS m_setle, .i_setle
    MNEMONIC_IS m_setge, .i_setge
    MNEMONIC_IS m_setb,  .i_setb
    MNEMONIC_IS m_setae, .i_setae
    MNEMONIC_IS m_seta,  .i_seta
    MNEMONIC_IS m_setbe, .i_setbe
    MNEMONIC_IS m_in,    .i_in
    MNEMONIC_IS m_out,   .i_out
    MNEMONIC_IS m_addps, .i_addps
    MNEMONIC_IS m_subps, .i_subps
    MNEMONIC_IS m_mulps, .i_mulps
    MNEMONIC_IS m_divps, .i_divps
    MNEMONIC_IS m_addpd, .i_addpd
    MNEMONIC_IS m_subpd, .i_subpd
    MNEMONIC_IS m_mulpd, .i_mulpd
    MNEMONIC_IS m_divpd, .i_divpd
    MNEMONIC_IS m_movaps,.i_movaps
    MNEMONIC_IS m_movups,.i_movups
    MNEMONIC_IS m_movapd,.i_movapd
    MNEMONIC_IS m_movupd,.i_movupd
    MNEMONIC_IS m_sqrtps,.i_sqrtps
    MNEMONIC_IS m_sqrtpd,.i_sqrtpd
    MNEMONIC_IS m_movsd, .i_movsd
    MNEMONIC_IS m_movss, .i_movss
    MNEMONIC_IS m_cvtss2sd, .i_cvtss2sd
    MNEMONIC_IS m_cvtsd2ss, .i_cvtsd2ss
    MNEMONIC_IS m_addsd, .i_addsd
    MNEMONIC_IS m_subsd, .i_subsd
    MNEMONIC_IS m_mulsd, .i_mulsd
    MNEMONIC_IS m_divsd, .i_divsd
    MNEMONIC_IS m_comisd,.i_comisd
    MNEMONIC_IS m_ucomisd,.i_ucomisd
    MNEMONIC_IS m_shl,   .i_shl
    MNEMONIC_IS m_shr,   .i_shr
    MNEMONIC_IS m_sar,   .i_sar
    MNEMONIC_IS m_rol,   .i_rol
    MNEMONIC_IS m_ror,   .i_ror
    MNEMONIC_IS m_clflush, .i_clflush
    MNEMONIC_IS m_prefetcht0, .i_prefetcht0
    MNEMONIC_IS m_ja, .i_ja
    MNEMONIC_IS m_jae, .i_jae
    MNEMONIC_IS m_jb, .i_jb
    MNEMONIC_IS m_jg, .i_jg
    MNEMONIC_IS m_jge, .i_jge
    MNEMONIC_IS m_jl, .i_jl
    MNEMONIC_IS m_jle, .i_jle
    MNEMONIC_IS m_js2, .i_js2
    MNEMONIC_IS m_and, .i_and
    MNEMONIC_IS m_or, .i_or
    MNEMONIC_IS m_not, .i_not
    MNEMONIC_IS m_rep, .i_rep
    MNEMONIC_IS m_movsb, .i_movsb
    MNEMONIC_IS m_stosb, .i_stosb
    MNEMONIC_IS m_cvtsi, .i_cvtsi
    MNEMONIC_IS m_cvtsd, .i_cvtsd
    MNEMONIC_IS m_cvttsd,.i_cvttsd
    MNEMONIC_IS m_xorps, .i_xorps
    MNEMONIC_IS m_movq,  .i_movq
    MNEMONIC_IS m_xchg,  .i_xchg
    ; unknown mnemonic in pass two is an error worth reporting
    cmp  byte [rel kasm_pass], 2
    jne  .done
    mov  byte [rel kasm_error], 1
    mov  rax, [rel kasm_line]
    cmp  qword [rel kasm_err_line], 0
    jne  .rec_more
    mov  [rel kasm_err_line], rax
.rec_more:
    mov  rcx, [rel err_count]
    cmp  rcx, 64
    jae  .done
    lea  rdx, [rel err_lines]
    mov  [rdx + rcx*4], eax
    lea  rdx, [rel err_dst]
    mov  [rdx + rcx*4], r12d
    lea  rdx, [rel err_src]
    mov  [rdx + rcx*4], r14d
    push rcx
    call record_err_mnem
    pop  rcx
    inc  rcx
    mov  [rel err_count], rcx
    jmp  .done

; ---- xchg [reg], reg32 / reg64 ----
; 87 /r, encoded like 'mov [reg], reg' with its own opcode. With a memory
; operand the exchange is atomic without a lock prefix: it is what the Linux
; runtime builds its locks on (futex), as Windows does inside the system.
.i_xchg:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax
    mov  r13, rdx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax
    mov  r15, rdx
    cmp  r12d, 9
    jne  .unsupported
    cmp  r14d, 8
    je   .xchg_32
    cmp  r14d, 1
    jne  .unsupported
    mov  dil, 1
    jmp  .xchg_go
.xchg_32:
    xor  edi, edi
    jmp  .xchg_go
.xchg_go:
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x87
    call emit_b
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done

; ---- mov ----
.i_mov:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax               ; dst kind
    mov  r13, rdx                ; dst value (full 64 bits: an immediate
                                 ; such as 0x8000000000000000 must survive)
    ; parse_operand clears cur_addend on entry, so the destination's addend
    ; (as in [rel buf+1]) must be saved before the source is parsed.
    mov  rax, [rel cur_addend]
    mov  [rel dst_addend], rax
    mov  [rel dst_base], r8
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax               ; src kind
    mov  r15, rdx                ; src value (full 64 bits)
    mov  [rel src_base], r8      ; base register of a [base+disp] source

    cmp  r12d, 1
    je   .mov_to_reg
    cmp  r12d, 8
    je   .mov_to_r32             ; 32-bit destination
    cmp  r12d, 12
    je   .mov_to_sib
    cmp  r12d, 13
    je   .mov_to_bd
    cmp  r12d, 3
    je   .mov_to_mem
    cmp  r12d, 9
    je   .mov_to_memreg
    cmp  r12d, 5
    je   .mov_to_rip
    cmp  r12d, 11
    je   .mov_to_rsp
    cmp  r12d, 7
    je   .mov_to_reg8
    cmp  r12d, 10
    je   .mov_to_reg16
    ; No branch matched the destination. An 8-bit destination (kind 7) lands
    ; here, so 'mov al, [rsi + rcx]' used to vanish without a word.
    jmp  .unsupported
.mov_to_r32:
    ; 32-bit destination: no REX.W. Sources: imm32, reg32, [rel label], [reg].
    cmp  r14d, 3
    je   .m32_rbp
    cmp  r14d, 2
    je   .m32_imm
    cmp  r14d, 8
    je   .m32_rr
    cmp  r14d, 5
    je   .m32_rip
    cmp  r14d, 9
    je   .m32_mem
    cmp  r14d, 13
    je   .m32_bd
    cmp  r14d, 12
    je   .m32_sib
    jmp  .unsupported
.m32_rbp:
    ; mov reg32, [rbp-N] -> 8B /r: an i32 or u32 struct field in the frame
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 5
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done
.m32_sib:
    ; mov reg32, [base+index*scale] -> 8B /r + SIB, no REX.W
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    mov  al, 0x8B
    call emit_sib_mem
    jmp  .done
.m32_bd:
    ; mov reg32, [base+disp] -> 8B /r without REX.W
    ; Read the base from the saved copy rather than from r8, which only
    ; happens to still hold it at this point.
    xor  edi, edi
    mov  esi, r13d
    mov  edx, [rel src_base]
    push r8
    call emit_rex
    mov  al, 0x8B
    call emit_b
    pop  r8
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.m32_mem:
    ; mov reg32, [reg]  ->  8B /r, no REX.W
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.m32_imm:
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xB8
    mov  cl, r13b
    and  cl, 0x07
    or   al, cl
    call emit_b
    mov  eax, r15d
    call emit_d
    jmp  .done
.m32_rr:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.m32_rip:
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done

.mov_to_rsp:
    cmp  r14d, 1
    je   .mov_rsp_reg
    cmp  r14d, 2
    jne  .unsupported
    mov  dil, 1
    xor  esi, esi
    xor  edx, edx
    call emit_rex
    mov  al, 0xC7
    call emit_b
    mov  r8d, r13d
    cmp  r8d, 127
    ja   .rsp_disp32
    mov  dil, 1
    xor  esi, esi
    mov  dl, 4
    call emit_modrm
    mov  al, 0x24
    call emit_b
    mov  al, r8b
    call emit_b
    jmp  .rsp_imm
.rsp_disp32:
    mov  dil, 2
    xor  esi, esi
    mov  dl, 4
    call emit_modrm
    mov  al, 0x24
    call emit_b
    mov  eax, r8d
    call emit_d
.rsp_imm:
    mov  eax, r15d
    call emit_d
    jmp  .done
.mov_rsp_reg:
    ; mov [rsp+N], reg64 -> REX.W 89 /r, SIB 24, disp8 or disp32
    mov  dil, 1
    mov  esi, r15d
    xor  edx, edx
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  r8d, r13d
    mov  dil, 1
    cmp  r8d, 127
    jbe  .mrr_mod
    mov  dil, 2
    jmp  .mrr_mod
.mrr_mod:
    push rdi
    mov  esi, r15d
    mov  dl, 4
    call emit_modrm
    mov  al, 0x24
    call emit_b
    pop  rdi
    cmp  dil, 2
    je   .mrr_d32
    mov  al, r8b
    call emit_b
    jmp  .done
.mrr_d32:
    mov  eax, r8d
    call emit_d
    jmp  .done
.mov_to_rip:
    ; the fixup takes cur_addend, which parsing the source cleared: put the
    ; destination's back, or 'mov [rel buf+8], rax' writes to buf
    mov  rax, [rel dst_addend]
    mov  [rel cur_addend], rax
    cmp  r14d, 7
    je   .mov_to_rip8
    cmp  r14d, 8
    je   .mov_to_rip32
    cmp  r14d, 10
    je   .mov_to_rip16
    cmp  r14d, 2
    je   .mov_to_rip_imm
    cmp  r14d, 1
    jne  .unsupported
    mov  dil, 1
    mov  esi, r15d
    mov  edx, 0
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_rip
    jmp  .done
.mov_to_rip16:
    mov  al, 0x66
    call emit_b
    xor  edi, edi
    mov  esi, r15d
    mov  edx, 0
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_rip
    jmp  .done
.mov_to_rip32:
    ; mov [rel label], reg32 -> 89 /r without REX.W
    xor  edi, edi
    mov  esi, r15d
    mov  edx, 0
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_rip
    jmp  .done
.mov_to_rip_imm:
    ; mov byte  [rel label], imm8   ->  C6 05 disp32 ib
    ; mov qword [rel label], imm32  ->  REX.W C7 05 disp32 id
    cmp  byte [rel op_size], 1
    je   .mtri_byte
    cmp  byte [rel op_size], 2
    je   .mtri_word
    xor  edi, edi
    cmp  byte [rel op_size], 4
    je   .mtri_nw                ; dword: same encoding without REX.W
    mov  dil, 1
.mtri_nw:
    xor  esi, esi
    mov  edx, 0
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi                ; /0
    ; The RIP displacement counts to the END of the instruction and four
    ; bytes of immediate still follow, so bias the fixup by that much.
    ; SUBTRACT: the operand may already carry an addend, as in [rel buf+1].
    mov  rax, [rel dst_addend]   ; the destination's own +N
    mov  [rel cur_addend], rax
    sub  qword [rel cur_addend], 4
    mov  eax, r13d
    call emit_rip
    mov  eax, r15d
    call emit_d
    jmp  .done
.mtri_word:
    ; 66 C7 05 disp32 iw.  The size prefix was ignored, so a 'word' store
    ; wrote eight bytes and flattened the fields next to it.
    mov  al, 0x66
    call emit_b
    xor  edi, edi
    xor  esi, esi
    mov  edx, 0
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi
    mov  rax, [rel dst_addend]
    mov  [rel cur_addend], rax
    sub  qword [rel cur_addend], 2   ; two bytes of immediate follow
    mov  eax, r13d
    call emit_rip
    mov  eax, r15d
    call emit_w
    jmp  .done

.mtri_byte:
    mov  al, 0xC6
    call emit_b
    xor  esi, esi                ; /0
    mov  rax, [rel dst_addend]   ; the destination's own +N
    mov  [rel cur_addend], rax
    sub  qword [rel cur_addend], 1    ; one byte of immediate follows
    mov  eax, r13d
    call emit_rip
    mov  eax, r15d
    call emit_b
    jmp  .done
.mov_to_rip8:
    ; The source is an 8-bit register: spl/bpl/sil/dil only exist with a REX
    ; byte present. Without it, reg=7 encodes bh instead of dil, and the
    ; instruction also comes out one byte short, so the RIP displacement
    ; lands on the neighbouring variable.
    cmp  r15d, 4
    jb   .mrip8_go
    mov  byte [rel rex8_force], 1
.mrip8_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, 0
    call emit_rex
    mov  al, 0x88
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_rip
    jmp  .done

.mov_to_bd:
    ; mov [base+disp], reg64/reg32/reg16  |  mov qword/dword [base+disp], imm
    cmp  r14d, 1
    je   .mbd_r64
    cmp  r14d, 8
    je   .mbd_r32
    cmp  r14d, 10
    je   .mbd_r16
    cmp  r14d, 2
    je   .mbd_imm
    cmp  r14d, 7
    je   .mbd_r8
    jmp  .unsupported
.mbd_r8:
    ; 88 /r : store a byte register at [base+disp]
    cmp  r15d, 4
    jb   .mbd8_go
    mov  byte [rel rex8_force], 1
.mbd8_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0x88
    call emit_b
    mov  esi, r15d
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    jmp  .done
.mbd_r32:
    ; 89 /r without REX.W
    xor  edi, edi
    mov  esi, r15d
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    jmp  .done
.mbd_r16:
    ; 66 89 /r : the operand-size prefix comes before any REX
    mov  al, 0x66
    call emit_b
    xor  edi, edi
    mov  esi, r15d
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    jmp  .done
.mbd_r64:
    mov  dil, 1
    mov  esi, r15d
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    jmp  .done
.mbd_imm8:
    ; C6 /0 ib
    xor  edi, edi
    xor  esi, esi
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0xC6
    call emit_b
    xor  esi, esi
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    mov  eax, r15d
    call emit_b
    jmp  .done
.mbd_imm16:
    ; 66 C7 /0 iw
    mov  al, 0x66
    call emit_b
    xor  edi, edi
    xor  esi, esi
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    mov  eax, r15d
    call emit_w
    jmp  .done

.mbd_imm:
    ; C6 /0 ib | 66 C7 /0 iw | C7 /0 id | REX.W C7 /0 id
    cmp  byte [rel op_size], 1
    je   .mbd_imm8
    cmp  byte [rel op_size], 2
    je   .mbd_imm16
    xor  edi, edi
    cmp  byte [rel op_size], 4
    je   .mbd_norexw
    mov  dil, 1                  ; REX.W for qword
.mbd_norexw:
    xor  esi, esi
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi                ; /0
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    mov  eax, r15d
    call emit_d
    jmp  .done
.mov_to_sib:
    ; mov [base+index*scale], reg   for 64, 32, 16 and 8 bit sources,
    ; and  mov byte [base+index], imm8
    cmp  r14d, 7
    je   .msib_r8
    cmp  r14d, 8
    je   .msib_r32
    cmp  r14d, 10
    je   .msib_r16
    cmp  r14d, 2
    je   .msib_imm
    cmp  r14d, 1
    jne  .unsupported
    mov  dil, 1                  ; REX.W
    mov  esi, r15d
    mov  edx, r13d
    mov  al, 0x89
    call emit_sib_mem
    jmp  .done
.msib_r32:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    mov  al, 0x89
    call emit_sib_mem
    jmp  .done
.msib_r16:
    mov  al, 0x66                ; operand-size prefix goes before any REX
    call emit_b
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    mov  al, 0x89
    call emit_sib_mem
    jmp  .done
.msib_r8:
    ; the source may be spl/bpl/sil/dil, which need a REX byte to exist
    cmp  r15d, 4
    jb   .msib8_go
    mov  byte [rel rex8_force], 1
.msib8_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    mov  al, 0x88                ; 88 /r stores a byte register
    call emit_sib_mem
    jmp  .done
.msib_imm:
    cmp  byte [rel op_size], 1
    jne  .unsupported
    xor  edi, edi
    xor  esi, esi                ; /0
    mov  edx, r13d
    mov  al, 0xC6
    call emit_sib_mem
    mov  eax, r15d
    call emit_b
    jmp  .done
.mov_from_sib:
    ; mov reg64, [base+index*scale]   ->  REX.W 8B /r + SIB
    mov  dil, 1                  ; REX.W
    mov  esi, r13d               ; destination register
    mov  edx, r15d               ; packed base|index|scale
    mov  al, 0x8B
    call emit_sib_mem
    jmp  .done

; ---- mov reg16, <src> ----
; A 16-bit destination had no branch either. The operand-size prefix 0x66 goes
; out first, before any REX, and then the encoding mirrors the 32-bit forms.
.mov_to_reg16:
    mov  al, 0x66
    call emit_b
    cmp  r14d, 2
    je   .mr16_imm
    cmp  r14d, 10
    je   .mr16_r16
    cmp  r14d, 9
    je   .mr16_mem
    cmp  r14d, 5
    je   .mr16_rip
    cmp  r14d, 12
    je   .mr16_sib
    cmp  r14d, 13
    je   .mr16_bd
    jmp  .unsupported
.mr16_imm:
    ; B8+rw iw
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xB8
    mov  cl, r13b
    and  cl, 0x07
    or   al, cl
    call emit_b
    mov  eax, r15d
    call emit_w
    jmp  .done
.mr16_r16:
    ; 89 /r
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.mr16_mem:
    ; 8B /r   [reg]
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.mr16_rip:
    ; 8B /r   [rel label]
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.mr16_sib:
    ; 8B /r + SIB
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    mov  al, 0x8B
    call emit_sib_mem
    jmp  .done
.mr16_bd:
    ; 8B /r   [base+disp]
    xor  edi, edi
    mov  esi, r13d
    mov  edx, [rel src_base]
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done

; ---- mov reg8, <src> ----
; The dispatcher had no branch for an 8-bit destination, so every one of these
; was dropped without a word. print_string lost its 'mov al, [rsi + rcx]' that
; way and spun forever on a byte that never changed.
.mov_to_reg8:
    ; spl/bpl/sil/dil are indices 4..7 and only exist when a REX byte is
    ; present; al/cl/dl/bl need no prefix, so do not pay for one.
    cmp  r13d, 4
    jb   .mr8_dispatch
    mov  byte [rel rex8_force], 1
.mr8_dispatch:
    cmp  r14d, 7
    je   .mr8_r8
    cmp  r14d, 2
    je   .mr8_imm
    cmp  r14d, 9
    je   .mr8_mem
    cmp  r14d, 12
    je   .mr8_sib
    cmp  r14d, 13
    je   .mr8_bd
    cmp  r14d, 5
    je   .mr8_rip
    cmp  r14d, 3
    je   .mr8_rbp
    jmp  .unsupported
.mr8_r8:
    ; 88 /r   reg8 -> reg8.  Either side may be one of the REX-only registers.
    cmp  r15d, 4
    jb   .mr8_r8_go
    mov  byte [rel rex8_force], 1
.mr8_r8_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x88
    call emit_b
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.mr8_imm:
    ; B0+r ib
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xB0
    mov  cl, r13b
    and  cl, 0x07
    or   al, cl
    call emit_b
    mov  eax, r15d
    call emit_b
    jmp  .done
.mr8_mem:
    ; 8A /r   [reg] -> reg8
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x8A
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.mr8_sib:
    ; 8A /r + SIB   [base+index*scale] -> reg8
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    mov  al, 0x8A
    call emit_sib_mem
    jmp  .done
.mr8_bd:
    ; 8A /r   [base+disp] -> reg8
    xor  edi, edi
    mov  esi, r13d
    mov  edx, [rel src_base]
    call emit_rex
    mov  al, 0x8A
    call emit_b
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.mr8_rip:
    ; 8A /r   [rel label] -> reg8
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x8A
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.mr8_rbp:
    ; 8A /r   [rbp-N] -> reg8
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 5
    call emit_rex
    mov  al, 0x8A
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done


.mov_to_reg:
    cmp  r14d, 12
    je   .mov_from_sib
    cmp  r14d, 2
    je   .mov_r_imm
    cmp  r14d, 1
    je   .mov_r_r
    cmp  r14d, 3
    je   .mov_r_mem
    cmp  r14d, 5
    je   .mov_r_rip
    cmp  r14d, 9
    je   .mov_r_memreg
    cmp  r14d, 13
    je   .mov_r_bd
    cmp  r14d, 11
    je   .mov_r_rsp
    cmp  r14d, 4
    je   .mov_r_label
    ; This was the last silent bail in the encoder; every unhandled source
    ; simply vanished, which is how 'mov rdi, [rsp + 48]' disappeared from
    ; read_file and left the byte count undefined.
    jmp  .unsupported
.mov_r_label:
    ; mov reg64, label
    ; Encoded as 'lea reg64, [rel label]'. The register ends up holding the
    ; same address, and RIP-relative is what the fixup table and pe_writer
    ; already resolve; an absolute form would need the image base, which
    ; this assembler never sees.
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x8D
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done

.mov_r_memreg:
    ; 8B /r   mov reg64, [reg]
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.mov_r_bd:
    ; 8B /r   mov reg64, [base +/- N]
    mov  dil, 1
    mov  esi, r13d
    mov  edx, [rel src_base]
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.mov_r_rsp:
    ; 8B /r   mov reg64, [rsp + N]
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 4
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  edx, 4
    mov  eax, r15d
    neg  eax                     ; emit_mem_base_disp subtracts its argument
    call emit_mem_base_disp
    jmp  .done

.mov_r_rip:
    ; REX.W 8B /r with RIP-relative addressing
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.mov_r_imm:
    ; A value that fits in an unsigned 32-bit field needs no REX.W, because
    ; writing eax zero-extends. Anything wider, or negative, needs the
    ; 64-bit form -- test the whole value, not just its low half.
    mov  rax, r15
    shr  rax, 32
    test rax, rax
    jnz  .mov_imm64              ; high half set -> needs imm64
    test r15d, r15d
    js   .mov_imm64
    ; B8+rd imm32
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex                 ; only emits REX when the register needs it
    mov  al, 0xB8
    mov  cl, r13b
    and  cl, 0x07
    or   al, cl
    call emit_b
    mov  eax, r15d
    call emit_d
    jmp  .done
.mov_imm64:
    mov  dil, 1
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xB8
    mov  cl, r13b
    and  cl, 0x07
    or   al, cl
    call emit_b
    mov  rax, r15                ; the full 64-bit immediate
    call emit_q
    jmp  .done
.mov_r_r:
    ; REX.W 89 /r   (src -> dst)
    mov  dil, 1
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.mov_r_mem:
    ; REX.W 8B /r  [rbp-N]
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 5
    call emit_rex
    mov  al, 0x8B
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done

.mov_to_mem:
    ; REX.W 89 /r  [rbp-N], reg
    cmp  r14d, 2
    je   .mov_to_mem_imm
    cmp  r14d, 8
    je   .mtm_r32
    cmp  r14d, 10
    je   .mtm_r16
    cmp  r14d, 7
    je   .mtm_r8
    cmp  r14d, 1
    jne  .unsupported
    jmp  .mtm_r64
; Narrow stores into the frame: the elements of a packed local array.
;   mov [rbp-N], eax  ->  89 /r     mov [rbp-N], ax  ->  66 89 /r
;   mov [rbp-N], al   ->  88 /r
.mtm_r16:
    mov  al, 0x66
    call emit_b
.mtm_r32:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, 5
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_mem_rbp
    jmp  .done
.mtm_r8:
    ; spl, bpl, sil and dil exist only behind a REX byte
    cmp  r15d, 4
    jb   .mtm_r8_go
    cmp  r15d, 8
    jae  .mtm_r8_go
    mov  byte [rel rex8_force], 1
.mtm_r8_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, 5
    call emit_rex
    mov  al, 0x88
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_mem_rbp
    jmp  .done
.mtm_r64:
    mov  dil, 1
    mov  esi, r15d
    mov  edx, 5
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  eax, r13d
    call emit_mem_rbp
    jmp  .done

.mov_to_mem_imm:
    ; mov byte  [rbp-N], imm8   ->  C6 /0 ib
    ; mov word  [rbp-N], imm16  ->  66 C7 /0 iw
    ; mov dword [rbp-N], imm32  ->  C7 /0 id
    ; mov qword [rbp-N], imm32  ->  REX.W C7 /0 id   (sign-extended)
    ; codegen writes the qword form for the length of a stream initialised
    ; from a literal. Only the NASM path had ever assembled it: the test
    ; suite builds through NASM, so the direct kasm path failed unseen.
    cmp  byte [rel op_size], 1
    je   .mtm_byte
    cmp  byte [rel op_size], 2
    je   .mtm_word
    cmp  byte [rel op_size], 4
    je   .mtm_dword
    ; a qword store takes a sign-extended imm32: anything wider is refused
    mov  rax, r15
    shr  rax, 31
    test rax, rax
    jz   .mtm_qword
    inc  rax
    shr  rax, 33
    cmp  rax, 1
    jne  .unsupported
    jmp  .mtm_qword
.mtm_qword:
    mov  dil, 1
    xor  esi, esi
    mov  edx, 5
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi
    mov  eax, r13d
    call emit_mem_rbp
    mov  eax, r15d
    call emit_d
    jmp  .done
.mtm_dword:
    mov  al, 0xC7
    call emit_b
    xor  esi, esi
    mov  eax, r13d
    call emit_mem_rbp
    mov  eax, r15d
    call emit_d
    jmp  .done
.mtm_word:
    mov  al, 0x66
    call emit_b
    mov  al, 0xC7
    call emit_b
    xor  esi, esi
    mov  eax, r13d
    call emit_mem_rbp
    mov  eax, r15d
    call emit_w
    jmp  .done
.mtm_byte:
    mov  al, 0xC6
    call emit_b
    xor  esi, esi
    mov  eax, r13d
    call emit_mem_rbp
    mov  eax, r15d
    call emit_b
    jmp  .done

.mov_to_memreg:
    cmp  r14d, 2
    je   .mov_to_memreg_imm
    cmp  r14d, 7
    je   .mov_to_memreg8
    cmp  r14d, 8
    je   .mov_to_memreg32
    cmp  r14d, 10
    je   .mov_to_memreg16
    ; REX.W 89 /r  [reg], reg
    cmp  r14d, 1
    jne  .unsupported
    mov  dil, 1
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done
.mov_to_memreg16:
    ; mov [reg], reg16  ->  66 89 /r  (operand-size prefix, no REX.W)
    mov  al, 0x66
    call emit_b
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done
.mov_to_memreg32:
    ; mov [reg], reg32  ->  89 /r, no REX.W
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x89
    call emit_b
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done
.mov_to_memreg_imm:
    ; mov byte [reg], imm8   ->  C6 /0 ib
    ; mov word [reg], imm16  ->  66 C7 /0 iw
    ; mov qword [reg], imm32 ->  REX.W C7 /0 id     (dword: no REX.W)
    cmp  byte [rel op_size], 1
    je   .mtmi_byte
    cmp  byte [rel op_size], 2
    je   .mtmi_word
    xor  edi, edi
    cmp  byte [rel op_size], 4
    je   .mtmi_norexw
    mov  dil, 1                  ; REX.W for qword
.mtmi_norexw:
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi                ; /0
    mov  edx, r13d
    call emit_mem_reg
    mov  eax, r15d
    call emit_d
    jmp  .done
.mtmi_word:
    ; 66 C7 /0 iw.  A 'word' store used to emit eight bytes and flatten the
    ; fields that follow it in the record.
    mov  al, 0x66
    call emit_b
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xC7
    call emit_b
    xor  esi, esi
    mov  edx, r13d
    call emit_mem_reg
    mov  eax, r15d
    call emit_w
    jmp  .done

.mtmi_byte:
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xC6
    call emit_b
    xor  esi, esi
    mov  edx, r13d
    call emit_mem_reg
    mov  eax, r15d
    call emit_b
    jmp  .done
.mov_to_memreg8:
    ; mov [reg], reg8  ->  88 /r
    ; the source may be spl/bpl/sil/dil, which need a REX byte to exist
    cmp  r15d, 4
    jb   .mmr8_go
    mov  byte [rel rex8_force], 1
.mmr8_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    call emit_rex
    mov  al, 0x88
    call emit_b
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done

; ---- push / pop ----
.i_push:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax
    mov  r14d, eax
    cmp  eax, 5
    je   .push_rip
    cmp  eax, 1
    jne  .unsupported
    cmp  edx, 8
    jb   .push_lo
    mov  al, 0x41
    call emit_b
.push_lo:
    mov  al, 0x50
    mov  cl, dl
    and  cl, 0x07
    or   al, cl
    call emit_b
    jmp  .done

; Placed AFTER the register form on purpose. Sitting before it, the REX
; prefix emitted for r8..r15 fell straight through into this branch and
; every 'push r8'..'push r15' came out as a prefix followed by FF /6. The
; compiler still ran -- NASM had built it -- but the binary its own kasm
; produced could not assemble anything.
.push_rip:
    ; 'push qword [rel label]' is FF /6, with the extension in the reg field
    ; of the ModRM byte. No REX at all: a push in 64-bit mode is already
    ; eight bytes wide, and REX.W here would be wrong.
    mov  r13d, edx               ; label index
    mov  al, 0xFF
    call emit_b
    mov  esi, 6
    mov  eax, r13d
    call emit_rip
    jmp  .done

.i_pop:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax
    mov  r14d, eax
    cmp  eax, 1
    jne  .unsupported
    cmp  edx, 8
    jb   .pop_lo
    mov  al, 0x41
    call emit_b
.pop_lo:
    mov  al, 0x58
    mov  cl, dl
    and  cl, 0x07
    or   al, cl
    call emit_b
    jmp  .done

; ---- arithmetic with a shared shape ----
.i_add:
    mov  bl, 0x01
    mov  r8b, 0                  ; /0 for the immediate form
    jmp  .arith
.i_sub:
    mov  bl, 0x29
    mov  r8b, 5
    jmp  .arith
.i_cmp:
    mov  bl, 0x39
    mov  r8b, 7
    jmp  .arith
.i_and:
    mov  bl, 0x21
    mov  r8b, 4
    jmp  .arith
.i_or:
    mov  bl, 0x09
    mov  r8b, 1
    jmp  .arith
.i_not:
    mov  bl, 2                   ; F7 /2
    jmp  .unary_f7
.i_xor:
    mov  bl, 0x31
    mov  r8b, 6
    jmp  .arith
.i_test:
    mov  bl, 0x85
    mov  r8b, 0
    jmp  .arith

.arith:
    push r8
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  [rel dst_base], r8      ; parse_operand returns the base register in r8
    mov  r12d, eax
    mov  r13d, edx
    ; parse_operand clears cur_addend on entry, so the destination's addend
    ; (as in [rel counter+8]) must be saved before the source is parsed.
    mov  rax, [rel cur_addend]
    mov  [rel dst_addend], rax
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  [rel src_base], r8
    mov  r14d, eax
    mov  r15d, edx
    pop  r8
    cmp  r12d, 12
    je   .arith_sib_imm
    cmp  r12d, 7
    je   .arith_r8               ; kind 7 = 8-bit register
    cmp  r12d, 8
    je   .arith_r32              ; kind 8 = 32-bit register
    cmp  r12d, 5
    je   .arith_mem_imm
    cmp  r12d, 9
    je   .arith_mem_imm
    cmp  r12d, 13
    je   .arith_mem_imm
    cmp  r12d, 1
    jne  .unsupported
    cmp  r14d, 1
    je   .arith_rr
    cmp  r14d, 2
    je   .arith_ri
    cmp  r14d, 5
    je   .arith_r_rip
    cmp  r14d, 9
    je   .arith_r_mem
    cmp  r14d, 13
    je   .arith_r_bd
    jmp  .unsupported
.arith_mem_imm:
    ; group1 with a memory destination:
    ;   80 /n ib | 81 /n id  for an immediate, or the plain opcode for a
    ;   register source ('add [rel counter], rax')
    cmp  r14d, 1
    je   .arith_mem_reg
    cmp  r14d, 8
    je   .arith_mem_reg32        ; 'add [rel X], edx' -- same form, no REX.W
    cmp  r14d, 2
    jne  .unsupported
    push r8
    push r12
    ; the operand-size prefix goes out before any REX byte
    cmp  byte [rel op_size], 2
    jne  .ami_nopfx
    mov  al, 0x66
    call emit_b
.ami_nopfx:
    xor  edi, edi
    cmp  byte [rel op_size], 1
    je   .ami_norexw
    cmp  byte [rel op_size], 2
    je   .ami_norexw
    cmp  byte [rel op_size], 4
    je   .ami_norexw
    mov  dil, 1                  ; REX.W for qword
    jmp  .ami_norexw             ; do NOT fall into the register-source path

.arith_mem_reg32:
    ; 'op [mem], reg32': identical encoding without the REX.W bit
    push r8
    xor  edi, edi
    jmp  .amr_common

.arith_mem_reg:
    ; 'op [mem], reg64' uses the r/m form of the opcode unchanged
    push r8
    mov  dil, 1
.amr_common:
    mov  esi, r15d
    mov  edx, r13d
    cmp  r12d, 5
    jne  .amr_chk_bd
    mov  edx, 0                  ; RIP-relative has no base register
    jmp  .amr_rex
.amr_chk_bd:
    cmp  r12d, 13
    jne  .amr_rex
    mov  edx, [rel dst_base]
.amr_rex:
    call emit_rex
    mov  al, bl
    call emit_b
    pop  r8
    mov  esi, r15d
    cmp  r12d, 5
    je   .amr_rip
    cmp  r12d, 13
    je   .amr_bd
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done
.amr_rip:
    mov  eax, r13d
    call emit_rip
    jmp  .done
.amr_bd:
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    jmp  .done
.ami_norexw:
    xor  esi, esi
    mov  edx, r13d
    cmp  r12d, 13
    jne  .ami_rex
    ; r8 holds the group-1 digit here, not a register number. Using it as the
    ; base made 'cmp byte [rsi+1], c' assemble as 'cmp byte [rdi+1], c',
    ; because the digit for cmp is 7 and rdi is register 7.
    mov  edx, [rel dst_base]
.ami_rex:
    cmp  r12d, 5
    jne  .ami_do_rex
    mov  edx, 0                  ; RIP-relative has no base register
.ami_do_rex:
    call emit_rex
    ; test has no group-1 form: it is F7 /0 (F6 /0 for a byte). Taking 81 /0
    ; made 'test dword [rel x], 63' an add that wrote 63 into x.
    cmp  bl, 0x85
    je   .ami_test
    mov  al, 0x81
    cmp  byte [rel op_size], 1
    jne  .ami_op
    mov  al, 0x80
    jmp  .ami_op
.ami_test:
    mov  al, 0xF7
    cmp  byte [rel op_size], 1
    jne  .ami_op
    mov  al, 0xF6
    jmp  .ami_op
.ami_op:
    call emit_b
    pop  r12
    pop  r8
    movzx esi, r8b               ; /n from the mnemonic table
    cmp  r12d, 5
    je   .ami_rip
    cmp  r12d, 13
    je   .ami_bd
    mov  edx, r13d
    call emit_mem_reg
    jmp  .ami_imm
.ami_rip:
    ; The RIP displacement counts to the END of the instruction and the
    ; immediate still follows, so bias the fixup by its size.
    ; SUBTRACT: the operand may already carry an addend, as in [rel buf+1].
    mov  rax, [rel dst_addend]
    mov  [rel cur_addend], rax
    cmp  byte [rel op_size], 1
    je   .ami_rip_i8
    cmp  byte [rel op_size], 2
    je   .ami_rip_i16
    sub  qword [rel cur_addend], 4
    jmp  .ami_rip_go
.ami_rip_i8:
    sub  qword [rel cur_addend], 1
    jmp  .ami_rip_go
.ami_rip_i16:
    sub  qword [rel cur_addend], 2
.ami_rip_go:
    mov  eax, r13d
    call emit_rip
    jmp  .ami_imm
.ami_bd:
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
.ami_imm:
    mov  eax, r15d
    cmp  byte [rel op_size], 1
    je   .ami_imm8
    cmp  byte [rel op_size], 2
    je   .ami_imm16
    call emit_d
    jmp  .done
.ami_imm16:
    call emit_w
    jmp  .done

.ami_imm8:
    call emit_b
    jmp  .done
.arith_rev_op:
    ; 'op reg, [mem]' uses the reversed opcode, two above the r/m form:
    ;   add 01->03, or 09->0B, and 21->23, sub 29->2B, xor 31->33, cmp 39->3B.
    ; test is symmetric, so 85 already has memory as its r/m operand.
    mov  al, bl
    cmp  al, 0x85
    je   .arith_rev_done
    add  al, 2
.arith_rev_done:
    ret
.arith_r_rip:
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    call .arith_rev_op
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.arith_r_mem:
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    call .arith_rev_op
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.arith_r_bd:
    mov  dil, 1
    mov  esi, r13d
    mov  edx, [rel src_base]
    push r8
    call emit_rex
    call .arith_rev_op
    call emit_b
    pop  r8
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.arith_r32:
    ; 32-bit operands: same encodings as 64-bit but without REX.W
    cmp  r14d, 8
    je   .ar32_rr
    cmp  r14d, 2
    je   .ar32_ri
    cmp  r14d, 12
    je   .ar32_sib
    cmp  r14d, 9
    je   .ar32_mem
    cmp  r14d, 13
    je   .ar32_bd
    cmp  r14d, 5
    je   .ar32_rip
    jmp  .unsupported
.ar32_sib:
    ; 'op reg32, [base+index*scale]' : reversed opcode, no REX.W
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    call .arith_rev_op
    call emit_sib_mem
    jmp  .done
.ar32_mem:
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    call .arith_rev_op
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.ar32_bd:
    xor  edi, edi
    mov  esi, r13d
    mov  edx, [rel src_base]
    push r8
    call emit_rex
    call .arith_rev_op
    call emit_b
    pop  r8
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.ar32_rip:
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    call .arith_rev_op
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.ar32_rr:
    xor  edi, edi                ; no REX.W
    mov  esi, r15d
    mov  edx, r13d
    push r8
    call emit_rex                ; only emits REX if r8..r15 used
    mov  al, bl
    call emit_b
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    pop  r8
    jmp  .done
.ar32_test:
    ; F7 /0 id
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xF7
    call emit_b
    mov  dil, 3
    xor  esi, esi
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_d
    jmp  .done

.ar32_ri:
    cmp  bl, 0x85
    je   .ar32_test              ; same story as .ari_test, without REX.W
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    push r8
    call emit_rex
    cmp  r15d, 127
    ja   .ar32_i32
    mov  al, 0x83
    call emit_b
    pop  r8
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_b
    jmp  .done
.ar32_i32:
    mov  al, 0x81
    call emit_b
    pop  r8
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_d
    jmp  .done

.arith_r8_rip:
    ; op reg8, [rel label]
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, bl
    inc  al
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.arith_r8_rbp:
    ; op reg8, [rbp-N]
    xor  edi, edi
    mov  esi, r13d
    mov  edx, 5
    call emit_rex
    mov  al, bl
    inc  al
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done
.arith_r8_bd:
    ; op reg8, [base+disp]
    xor  edi, edi
    mov  esi, r13d
    mov  edx, [rel src_base]
    push r8
    call emit_rex
    mov  al, bl
    inc  al
    call emit_b
    pop  r8
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.arith_r8_mem:
    ; 'op reg8, [reg]' : the 8-bit reversed opcode is bl + 1
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, bl
    inc  al
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.arith_r8_sib:
    ; 'op reg8, [base+index]' : the 8-bit reversed opcode is bl + 1
    ;   cmp 39 -> 38 (r/m8,r8) -> 3A (r8,r/m8)
    xor  edi, edi
    mov  esi, r13d
    mov  edx, r15d
    mov  al, bl
    inc  al
    call emit_sib_mem
    jmp  .done
.arith_r8_rr:
    ; The 8-bit register-to-register opcode is the 64-bit one minus 1:
    ;   cmp 39->38, test 85->84, add 01->00, sub 29->28, xor 31->30,
    ;   and 21->20, or 09->08.
    ; Either side may be spl/bpl/sil/dil, which need a REX byte to exist at
    ; all: 'test dil, dil' without one assembles as 'test bh, bh'.
    cmp  r13d, 4
    jb   .ar8rr_chk_src
    mov  byte [rel rex8_force], 1
.ar8rr_chk_src:
    cmp  r15d, 4
    jb   .ar8rr_go
    mov  byte [rel rex8_force], 1
.ar8rr_go:
    xor  edi, edi
    mov  esi, r15d
    mov  edx, r13d
    push r8
    call emit_rex                ; only emits REX when a register needs it
    mov  al, bl
    dec  al
    call emit_b
    pop  r8
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.arith_r8:
    ; 8-bit register destination. Every source form the assembler can name is
    ; accepted here; the reversed 8-bit opcode is always bl + 1
    ;   cmp 39 -> 38 (r/m8,r8) -> 3A (r8,r/m8)
    ; spl/bpl/sil/dil require a REX byte in every one of these forms, so raise
    ; the flag once here rather than in each branch below.
    cmp  r13d, 4
    jb   .arith_r8_dispatch
    mov  byte [rel rex8_force], 1
.arith_r8_dispatch:
    cmp  r14d, 12
    je   .arith_r8_sib
    cmp  r14d, 9
    je   .arith_r8_mem
    cmp  r14d, 7
    je   .arith_r8_rr
    cmp  r14d, 5
    je   .arith_r8_rip
    cmp  r14d, 3
    je   .arith_r8_rbp
    cmp  r14d, 13
    je   .arith_r8_bd
    cmp  r14d, 2
    jne  .unsupported
    cmp  bl, 0x85
    je   .r8i_test                ; test r/m8, imm8 is F6 /0, not 80 /n
    mov  eax, r13d
    cmp  eax, 8
    jae  .r8i_rexb
    cmp  eax, 4
    jb   .r8i_op
    mov  al, 0x40                 ; spl/bpl/sil/dil need a bare REX
    call emit_b
    jmp  .r8i_op
.r8i_test:
    ; F6 /0 ib
    mov  eax, r13d
    cmp  eax, 8
    jae  .r8t_rexb
    cmp  eax, 4
    jb   .r8t_op
    mov  al, 0x40                 ; spl/bpl/sil/dil need a bare REX
    call emit_b
    jmp  .r8t_op
.r8t_rexb:
    mov  al, 0x41                 ; REX.B
    call emit_b
.r8t_op:
    mov  al, 0xF6
    call emit_b
    mov  dil, 3
    xor  esi, esi                 ; /0
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_b
    jmp  .done
.r8i_rexb:
    mov  al, 0x41                 ; REX.B for r8b..r15b
    call emit_b
.r8i_op:
    mov  al, 0x80                 ; group1 r/m8, imm8
    call emit_b
    mov  dil, 3                   ; mod = 11 (register direct)
    movzx esi, r8b                ; /n opcode extension
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_b                   ; imm8
    jmp  .done
.arith_sib_imm:
    ; op byte [base + index*scale +- disp], imm8. This used to write the SIB
    ; byte without the scale and without the displacement, and to encode
    ; test as add: 'test byte [rdi + rcx - 1], 1' became 'add byte [rdi +
    ; rcx], 1'. Now the scale and the displacement go through
    ; emit_sib_modrm, and test takes its own opcode, F6 /0.
    cmp  r14d, 2
    jne  .unsupported
    cmp  byte [rel op_size], 1
    jne  .unsupported
    push rbx
    mov  ecx, r13d
    and  ecx, 0xFF               ; base
    mov  edx, r13d
    shr  edx, 8
    and  edx, 0xFF               ; index
    mov  al, 0x40
    test dl, 0x08
    jz   .sib_no_x
    or   al, 0x02
.sib_no_x:
    test cl, 0x08
    jz   .sib_no_b
    or   al, 0x01
.sib_no_b:
    cmp  al, 0x40
    je   .sib_no_rex
    call emit_b
.sib_no_rex:
    mov  al, 0x80                ; group 1 r/m8, imm8
    cmp  bl, 0x85
    jne  .sib_op
    mov  al, 0xF6                ; test r/m8, imm8 is F6 /0
    xor  r8d, r8d
    jmp  .sib_op
.sib_op:
    call emit_b
    mov  sil, r8b
    mov  edx, r13d
    call emit_sib_modrm
    mov  eax, r15d
    call emit_b
    pop  rbx
    jmp  .done
.arith_rr:
    mov  dil, 1
    mov  esi, r15d
    mov  edx, r13d
    push r8
    call emit_rex
    mov  al, bl
    call emit_b
    mov  dil, 3
    mov  esi, r15d
    mov  edx, r13d
    call emit_modrm
    pop  r8
    jmp  .done
.ari_test:
    ; REX.W F7 /0 id -- there is no imm8 form for test
    mov  dil, 1
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xF7
    call emit_b
    mov  dil, 3
    xor  esi, esi
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_d
    jmp  .done

.arith_ri:
    ; 'test' does not belong to group 1: its immediate form is F7 /0, while
    ; 81 /0 is ADD. Sharing the group-1 path assembled 'test r14, N' as
    ; 'add r14, N', which both corrupted the register and set the wrong flags.
    cmp  bl, 0x85
    je   .ari_test
    mov  dil, 1
    xor  esi, esi
    mov  edx, r13d
    push r8
    call emit_rex
    ; 83 /n ib when the immediate fits in a signed byte, otherwise 81 /n id
    cmp  r15d, 127
    ja   .ari_32
    mov  al, 0x83
    call emit_b
    pop  r8
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_b
    jmp  .done
.ari_32:
    mov  al, 0x81
    call emit_b
    pop  r8
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_d
    jmp  .done

; ---- imul reg, reg ----
.i_imul:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax               ; destination kind: 1 = reg64, 8 = reg32
    mov  r13d, edx               ; destination register
    ; Three-operand form: 'imul rax, rax, 4'. The tokeniser leaves
    ; "rax, 4" in tok_c, so look for the comma and split there.
    lea  rsi, [rel tok_c]
.imul_scan:
    mov  al, [rsi]
    test al, al
    jz   .imul_two
    cmp  al, ','
    je   .imul_three
    inc  rsi
    jmp  .imul_scan
.imul_three:
    mov  byte [rsi], 0           ; cut so the register parses on its own
    push rsi
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx               ; source register
    pop  rsi
    mov  byte [rsi], ','         ; put the token back
    inc  rsi
.imul_skip_sp:
    cmp  byte [rsi], ' '
    jne  .imul_imm
    inc  rsi
    jmp  .imul_skip_sp
.imul_imm:
    mov  rcx, rsi
    push r13
    push r15
    call parse_expr              ; 'imul rcx, r12, TOKEN_SIZE' needs the equ
    pop  r15
    pop  r13
    mov  r14, rax                ; the immediate
.imul_emit:
    ; REX.W only for a 64-bit destination. Forcing it turned
    ; 'imul eax, eax, N' into the 64-bit form, which keeps the upper half of
    ; the register instead of clearing it.
    xor  edi, edi
    cmp  r12d, 1
    jne  .ie_norexw
    mov  dil, 1
.ie_norexw:
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  rax, r14
    movsx rcx, al
    cmp  rcx, r14
    jne  .imul_i32               ; does not fit in a signed byte
    mov  al, 0x6B                ; imul r64, r/m64, imm8
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    mov  rax, r14
    call emit_b
    jmp  .done
.imul_i32:
    mov  al, 0x69                ; imul r64, r/m64, imm32
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    mov  rax, r14
    call emit_d
    jmp  .done
.imul_two:
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax
    mov  r15d, edx
    cmp  r14d, 2
    jne  .imul_two_reg
    ; 'imul reg, imm' is shorthand for 'imul reg, reg, imm'. Treating the
    ; immediate as a register number produced 'imul rax, r8' and a token
    ; pointer built from an uninitialised register.
    mov  rax, r15
    mov  r14, rax                ; the immediate
    mov  rax, r13
    mov  r15, rax                ; source register = destination
    jmp  .imul_emit
.imul_two_reg:
    xor  edi, edi
    cmp  r12d, 1
    jne  .itr_norexw
    mov  dil, 1
.itr_norexw:
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xAF
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; ---- unary group F7 ----
.i_mul:
    mov  bl, 4                   ; F7 /4
    jmp  .unary_f7
.i_idiv:
    mov  bl, 7
    jmp  .unary_f7
.i_div:
    mov  bl, 6
    jmp  .unary_f7
.i_neg:
    mov  bl, 3
    jmp  .unary_f7
.unary_f7:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  [rel dst_base], r8
    mov  r12d, eax
    mov  r14d, eax
    cmp  eax, 8
    je   .unary_f7_r32
    cmp  eax, 1
    jne  .unsupported
    mov  r13d, edx
    mov  dil, 1
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xF7
    call emit_b
    mov  dil, 3
    movzx esi, bl
    mov  edx, r13d
    call emit_modrm
    jmp  .done

.unary_f7_r32:
    ; neg/not/mul/div on a 32-bit register: same encoding without REX.W
    mov  r13d, edx
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xF7
    call emit_b
    mov  dil, 3
    movzx esi, bl
    mov  edx, r13d
    call emit_modrm
    jmp  .done

; ---- inc / dec, group FF ----
.i_inc:
    mov  bl, 0
    jmp  .unary_ff
.i_dec:
    mov  bl, 1
.unary_ff:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  [rel dst_base], r8
    mov  r12d, eax
    mov  r14d, eax
    cmp  eax, 5
    je   .unary_ff_rip
    cmp  eax, 8
    je   .unary_ff_r32
    cmp  eax, 7
    je   .unary_ff_r8
    cmp  eax, 13
    je   .unary_ff_bd
    cmp  eax, 1
    jne  .unsupported
    mov  r13d, edx
    mov  dil, 1
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xFF
    call emit_b
    mov  dil, 3
    movzx esi, bl
    mov  edx, r13d
    call emit_modrm
    jmp  .done

.unary_ff_r32:
    ; inc/dec of a 32-bit register: FF /0 or /1 with no REX.W
    mov  r13d, edx
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xFF
    call emit_b
    mov  dil, 3
    movzx esi, bl
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.unary_ff_r8:
    ; inc/dec of an 8-bit register uses the separate FE opcode
    mov  r13d, edx
    cmp  r13d, 4
    jb   .uff8_go
    mov  byte [rel rex8_force], 1
.uff8_go:
    xor  edi, edi
    xor  esi, esi
    mov  edx, r13d
    call emit_rex
    mov  al, 0xFE
    call emit_b
    mov  dil, 3
    movzx esi, bl
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.unary_ff_bd:
    ; inc/dec [base +/- N], honouring byte/word/dword/qword
    mov  r13d, edx               ; displacement, already negated by the parser
    cmp  byte [rel op_size], 2
    jne  .uffb_nopfx
    mov  al, 0x66
    call emit_b
.uffb_nopfx:
    xor  edi, edi
    cmp  byte [rel op_size], 1
    je   .uffb_go
    cmp  byte [rel op_size], 2
    je   .uffb_go
    cmp  byte [rel op_size], 4
    je   .uffb_go
    mov  dil, 1                  ; REX.W only for qword
.uffb_go:
    xor  esi, esi
    mov  edx, [rel dst_base]
    call emit_rex
    mov  al, 0xFF
    cmp  byte [rel op_size], 1
    jne  .uffb_op
    mov  al, 0xFE                ; byte form has its own opcode
.uffb_op:
    call emit_b
    movzx esi, bl
    mov  edx, [rel dst_base]
    mov  eax, r13d
    call emit_mem_base_disp
    jmp  .done

.unary_ff_rip:
    ; inc/dec [rel label].  FE for byte, 66 FF for word, FF for dword and
    ; REX.W FF for qword; the size used to be ignored and every one of these
    ; touched eight bytes.
    mov  r13d, edx               ; label index
    cmp  byte [rel op_size], 2
    jne  .uffr_nopfx
    mov  al, 0x66
    call emit_b
.uffr_nopfx:
    xor  edi, edi
    cmp  byte [rel op_size], 1
    je   .uffr_go
    cmp  byte [rel op_size], 2
    je   .uffr_go
    cmp  byte [rel op_size], 4
    je   .uffr_go
    mov  dil, 1                  ; REX.W only for qword
.uffr_go:
    xor  esi, esi
    xor  edx, edx
    call emit_rex
    mov  al, 0xFF
    cmp  byte [rel op_size], 1
    jne  .uffr_op
    mov  al, 0xFE                ; byte form has its own opcode
.uffr_op:
    call emit_b
    movzx esi, bl
    mov  eax, r13d
    call emit_rip
    jmp  .done

; ---- lea reg, [rbp-N] ----
.i_lea:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax               ; dst kind, so a report names the real operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax
    mov  r15d, edx
    mov  [rel src_base], r8      ; base register of a [base+disp] source
    cmp  r14d, 5
    je   .lea_rip
    cmp  r14d, 11
    je   .lea_rsp
    cmp  r14d, 12
    je   .lea_sib
    cmp  r14d, 9
    je   .lea_memreg
    cmp  r14d, 13
    je   .lea_bd
    cmp  r14d, 3
    ; only [rel label] and [rbp+/-N] encode here; 'lea r9, [rsp + 48]' does not
    jne  .unsupported
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 5
    call emit_rex
    mov  al, 0x8D
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done
.lea_sib:
    ; lea reg, [base + index*scale]
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    mov  al, 0x8D
    call emit_sib_mem
    jmp  .done
.lea_memreg:
    ; lea reg, [base]
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x8D
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done

.lea_rsp:
    ; lea reg, [rsp + N].  Only [rel label] and [rbp+/-N] used to encode, so
    ; the &bytes_written argument of every WriteFile call went missing.
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 4                  ; rsp
    call emit_rex
    mov  al, 0x8D
    call emit_b
    mov  esi, r13d
    mov  edx, 4
    mov  eax, r15d
    neg  eax                     ; emit_mem_base_disp subtracts its argument
    call emit_mem_base_disp
    jmp  .done
.lea_bd:
    ; lea reg, [base +/- N] for any base register
    mov  dil, 1
    mov  esi, r13d
    mov  edx, [rel src_base]
    call emit_rex
    mov  al, 0x8D
    call emit_b
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done
.lea_rip:
    mov  dil, 1
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x8D
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done

; ---- control flow ----
.i_ret:
    mov  al, 0xC3
    call emit_b
    jmp  .done
.i_rep:
    ; 'rep' is a prefix byte; the string op follows on the same line, so the
    ; tokeniser leaves it in tok_b. Emit F3 then fall through to it.
    mov  al, 0xF3
    call emit_b
    lea  rcx, [rel tok_b]
    lea  rdx, [rel m_movsb]
    call str_eq
    test al, al
    jnz  .i_movsb
    lea  rcx, [rel tok_b]
    lea  rdx, [rel m_stosb]
    call str_eq
    test al, al
    jnz  .i_stosb
    jmp  .unsupported
.i_movsb:
    mov  al, 0xA4
    call emit_b
    jmp  .done
.i_stosb:
    mov  al, 0xAA
    call emit_b
    jmp  .done
.i_hlt:
    mov  al, 0xF4
    call emit_b
    jmp  .done
.i_cli:
    mov  al, 0xFA
    call emit_b
    jmp  .done
.i_syscall:
    mov  al, 0x0F
    call emit_b
    mov  al, 0x05
    call emit_b
    jmp  .done
.i_cqo:
    mov  al, 0x48                ; REX.W
    call emit_b
    mov  al, 0x99
    call emit_b
    jmp  .done
.i_iretq:
    mov  al, 0x48
    call emit_b
    mov  al, 0xCF
    call emit_b
    jmp  .done

.i_call:
    lea  rcx, [rel tok_b]
    call parse_operand
    cmp  eax, 1
    jne  .i_call_direct
    push rdx
    xor  edi, edi
    xor  esi, esi
    call emit_rex
    mov  al, 0xFF
    call emit_b
    pop  rdx
    mov  dil, 3
    mov  sil, 2
    call emit_modrm
    jmp  .done
.i_call_direct:
    mov  al, 0xE8
    call emit_b
    jmp  .rel32_target
.i_jmp:
    mov  al, 0xE9
    call emit_b
    jmp  .rel32_target
.i_ja:
    mov  bl, 0x87
    jmp  .jcc
.i_jae:
    mov  bl, 0x83
    jmp  .jcc
.i_jb:
    mov  bl, 0x82
    jmp  .jcc
.i_jg:
    mov  bl, 0x8F
    jmp  .jcc
.i_jge:
    mov  bl, 0x8D
    jmp  .jcc
.i_jl:
    mov  bl, 0x8C
    jmp  .jcc
.i_jle:
    mov  bl, 0x8E
    jmp  .jcc
.i_js2:
    mov  bl, 0x88
    jmp  .jcc
.i_je:
    mov  bl, 0x84
    jmp  .jcc
.i_jne:
    mov  bl, 0x85
    jmp  .jcc
.i_jns:
    mov  bl, 0x89
    jmp  .jcc
.i_jbe:
    mov  bl, 0x86
.jcc:
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
.rel32_target:
    lea  rcx, [rel tok_b]
    call parse_operand
    cmp  eax, 4
    jne  .rel_zero
    cmp  edx, -1
    je   .rel_zero
    ; record a fixup and reserve the field
    push rdx
    mov  eax, edx
    xor  edi, edi                ; kind 0 = rel32
    call add_fixup
    pop  rdx
    xor  eax, eax
    call emit_d
    jmp  .done
.rel_zero:
    ; not a local label: it may be an external symbol the linker will resolve
    lea  rcx, [rel tok_b]
    push rcx
    call str_len_local
    mov  rdx, rax
    pop  rcx
    call kasm_find_extern
    cmp  eax, -1
    je   .rel_unknown
    call kasm_add_extref
.rel_unknown:
    xor  eax, eax
    call emit_d
    jmp  .done

; ---- setcc al ----
.i_sete:
    mov  bl, 0x94
    jmp  .setcc
.i_setne:
    mov  bl, 0x95
    jmp  .setcc
.i_setl:
    mov  bl, 0x9C
    jmp  .setcc
.i_setg:
    mov  bl, 0x9F
    jmp  .setcc
.i_setle:
    mov  bl, 0x9E
    jmp  .setcc
.i_setb:
    mov  bl, 0x92
    jmp  .setcc
.i_setae:
    mov  bl, 0x93
    jmp  .setcc
.i_seta:
    mov  bl, 0x97
    jmp  .setcc
.i_setbe:
    mov  bl, 0x96
    jmp  .setcc
.i_setge:
    mov  bl, 0x9D
.setcc:
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    mov  al, 0xC0                ; modrm for al
    call emit_b
    jmp  .done

; ---- movzx rax, al ----
.movzx_mem:
    ; 0F B6 /r (byte source) or 0F B7 /r (word source) through [reg].
    ; peek8 compiles to  movzx rax, byte [rax]  -- without this the register
    ; form was emitted instead, reading the low byte of the address itself.
    xor  edi, edi
    cmp  r12d, 1
    jne  .mzm_norexw
    mov  dil, 1                  ; REX.W for a 64-bit destination
.mzm_norexw:
    ; A 32-bit source cannot be encoded as movzx: writing a 32-bit
    ; register already clears the upper half. nasm quietly assembles
    ; 'movzx rdx, dword [x]' as a plain 32-bit load, so do the same
    ; instead of falling back to the byte form and reading one byte.
    cmp  byte [rel op_size], 4
    je   .mz32_load
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xB6
    cmp  byte [rel op_size], 2
    jne  .mzm_op
    mov  al, 0xB7
.mzm_op:
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.movzx_rbp:
    ; 0F B6/B7 /r through [rbp-N]: a u8 or u16 struct field in the frame
    xor  edi, edi
    cmp  r12d, 1
    jne  .mzp_norexw
    mov  dil, 1
.mzp_norexw:
    cmp  byte [rel op_size], 4
    je   .mz32_load
    mov  esi, r13d
    mov  edx, 5
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xB6
    cmp  byte [rel op_size], 2
    jne  .mzp_op
    mov  al, 0xB7
.mzp_op:
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done
.mz32_load:
    ; 'movzx reg, dword [mem]' is just a 32-bit load. Reuse the paths that
    ; already encode 8B correctly for every addressing form.
    cmp  r14d, 3
    je   .m32_rbp
    cmp  r14d, 9
    je   .m32_mem
    cmp  r14d, 13
    je   .m32_bd
    cmp  r14d, 12
    je   .m32_sib
    cmp  r14d, 5
    je   .m32_rip
    jmp  .unsupported

.movzx_sib:
    ; 0F B6/B7 /r + SIB.  emit_sib_mem cannot serve here: it puts the REX byte
    ; immediately before its single opcode, and the prefix has to precede the
    ; 0F escape.  Build it by hand, then emit ModRM and SIB separately.
    xor  eax, eax
    cmp  r12d, 1
    jne  .mzs_now
    or   al, 0x08                ; REX.W for a 64-bit destination
.mzs_now:
    mov  ecx, r13d
    and  ecx, 8
    cmp  ecx, 0
    je   .mzs_nor
    or   al, 0x04                ; REX.R from the destination register
.mzs_nor:
    mov  ecx, r15d
    shr  ecx, 8
    and  ecx, 8
    cmp  ecx, 0
    je   .mzs_nox
    or   al, 0x02                ; REX.X from the index register
.mzs_nox:
    mov  ecx, r15d
    and  ecx, 8
    cmp  ecx, 0
    je   .mzs_nob
    or   al, 0x01                ; REX.B from the base register
.mzs_nob:
    cmp  al, 0
    je   .mzs_esc
    or   al, 0x40
    call emit_b
.mzs_esc:
    cmp  byte [rel op_size], 4
    je   .mz32_load
    mov  al, 0x0F
    call emit_b
    mov  al, 0xB6
    cmp  byte [rel op_size], 2
    jne  .mzs_op
    mov  al, 0xB7
.mzs_op:
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call emit_sib_modrm
    jmp  .done
.movzx_bd:
    ; 0F B6/B7 /r through [base+disp]
    xor  edi, edi
    cmp  r12d, 1
    jne  .mzb_norexw
    mov  dil, 1
.mzb_norexw:
    ; A 32-bit source cannot be encoded as movzx: writing a 32-bit
    ; register already clears the upper half. nasm quietly assembles
    ; 'movzx rdx, dword [x]' as a plain 32-bit load, so do the same
    ; instead of falling back to the byte form and reading one byte.
    cmp  byte [rel op_size], 4
    je   .mz32_load
    mov  esi, r13d
    mov  edx, [rel src_base]
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xB6
    cmp  byte [rel op_size], 2
    jne  .mzb_op
    mov  al, 0xB7
.mzb_op:
    call emit_b
    mov  esi, r13d
    mov  edx, [rel src_base]
    mov  eax, r15d
    call emit_mem_base_disp
    jmp  .done

.movzx_rip:
    ; 0F B7 /r : movzx r, r/m16 through a RIP-relative address.
    ; REX.W only when the destination is a 64-bit register (kind 1).
    xor  edi, edi
    cmp  r12d, 1
    jne  .mzr_norexw
    mov  dil, 1
.mzr_norexw:
    ; A 32-bit source cannot be encoded as movzx: writing a 32-bit
    ; register already clears the upper half. nasm quietly assembles
    ; 'movzx rdx, dword [x]' as a plain 32-bit load, so do the same
    ; instead of falling back to the byte form and reading one byte.
    cmp  byte [rel op_size], 4
    je   .mz32_load
    mov  esi, r13d
    mov  edx, 0
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xB6                ; byte source unless 'word' was written
    cmp  byte [rel op_size], 2
    jne  .mzr_op
    mov  al, 0xB7
.mzr_op:
    call emit_b
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done

.i_movsx:
    ; REX.W 0F BE /r : sign-extend an 8-bit register into a 64-bit one
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax
    mov  r15d, edx
    cmp  r14d, 7
    jne  .unsupported
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xBE
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done
.i_movzx:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  [rel src_base], r8
    mov  r14d, eax
    mov  r15d, edx
    cmp  r14d, 5
    je   .movzx_rip              ; movzx reg, word [rel label]
    cmp  r14d, 3
    je   .movzx_rbp              ; movzx reg, byte/word [rbp-N]
    cmp  r14d, 9
    je   .movzx_mem              ; movzx reg, byte/word [reg]
    cmp  r14d, 12
    je   .movzx_sib              ; movzx reg, byte [base+index*scale]
    cmp  r14d, 13
    je   .movzx_bd               ; movzx reg, byte [base+disp]
    cmp  r14d, 7
    je   .movzx_rr
    cmp  r14d, 10
    je   .movzx_rr
    ; Falling through to the register form silently turned
    ; 'movzx r14d, byte [r13+rax+N]' into 'movzx r14, r13b'.
    jmp  .unsupported
.movzx_rr:
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0xB6
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; ---- SSE double precision ----
; arithmetic on two xmm registers: F2 0F <op> /r
; ==============================================================================
; Packed SSE. Four floats ('ps') or two doubles ('pd') per instruction, which
; is the whole point: one mulps does four multiplies where mulsd does one.
;
; Encoding is the scalar shape with a different prefix:
;   ps  ->  0F <op> /r          (no prefix at all)
;   pd  ->  66 0F <op> /r
; The opcodes are shared: 58 add, 5C sub, 59 mul, 5E div, 51 sqrt.
; ==============================================================================
; ==============================================================================
; movaps / movups / movapd / movupd -- moving four floats or two doubles.
;
;   movaps xmm, [mem]   0F 28 /r        movaps [mem], xmm   0F 29 /r
;   movups              0F 10 / 0F 11
;   movapd           66 0F 28 / 66 0F 29
;   movupd           66 0F 10 / 66 0F 11
;
; 'a' is the aligned form and faults on a misaligned address; 'u' does not
; and costs nothing extra on any recent processor. Use movups unless the
; buffer is known to be 16-byte aligned.
; ==============================================================================
.i_movaps:
    mov  bl, 0x28
    xor  r8d, r8d
    jmp  .sse_mov
.i_movups:
    mov  bl, 0x10
    xor  r8d, r8d
    jmp  .sse_mov
.i_movapd:
    mov  bl, 0x28
    mov  r8d, 0x66
    jmp  .sse_mov
.i_movupd:
    mov  bl, 0x10
    mov  r8d, 0x66
    jmp  .sse_mov

.sse_mov:
    push r8
    push rbx
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax               ; dst kind
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax               ; src kind
    mov  r15d, edx
    pop  rbx
    pop  r8
    cmp  r12d, 6
    je   .sm_load                ; destination is a register: it is a load
    ; destination is memory: the store opcode is the load one plus 1
    inc  bl
    test r8d, r8d
    jz   .sm_st_nopfx
    mov  al, r8b
    call emit_b
.sm_st_nopfx:
    mov  esi, r15d
    xor  edx, edx
    cmp  r12d, 9
    jne  .sm_st_rex
    mov  edx, r13d
.sm_st_rex:
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    cmp  r12d, 3
    je   .sm_st_rbp
    cmp  r12d, 9
    je   .sm_st_reg
    jmp  .unsupported
.sm_st_rbp:
    mov  esi, r15d
    mov  eax, r13d
    call emit_mem_rbp
    jmp  .done
.sm_st_reg:
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done
.sm_load:
    test r8d, r8d
    jz   .sm_ld_nopfx
    mov  al, r8b
    call emit_b
.sm_ld_nopfx:
    mov  esi, r13d
    xor  edx, edx
    cmp  r14d, 6
    je   .sm_ld_rm
    cmp  r14d, 9
    jne  .sm_ld_rex
.sm_ld_rm:
    mov  edx, r15d
.sm_ld_rex:
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    cmp  r14d, 6
    je   .sm_ld_reg
    cmp  r14d, 3
    je   .sm_ld_rbp
    cmp  r14d, 9
    je   .sm_ld_mem
    jmp  .unsupported
.sm_ld_reg:
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done
.sm_ld_rbp:
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done
.sm_ld_mem:
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done

.i_addps:
    mov  bl, 0x58
    xor  r8d, r8d                ; no prefix
    jmp  .sse_packed
.i_subps:
    mov  bl, 0x5C
    xor  r8d, r8d
    jmp  .sse_packed
.i_mulps:
    mov  bl, 0x59
    xor  r8d, r8d
    jmp  .sse_packed
.i_divps:
    mov  bl, 0x5E
    xor  r8d, r8d
    jmp  .sse_packed
.i_sqrtps:
    mov  bl, 0x51
    xor  r8d, r8d
    jmp  .sse_packed
.i_addpd:
    mov  bl, 0x58
    mov  r8d, 0x66
    jmp  .sse_packed
.i_subpd:
    mov  bl, 0x5C
    mov  r8d, 0x66
    jmp  .sse_packed
.i_mulpd:
    mov  bl, 0x59
    mov  r8d, 0x66
    jmp  .sse_packed
.i_divpd:
    mov  bl, 0x5E
    mov  r8d, 0x66
    jmp  .sse_packed
.i_sqrtpd:
    mov  bl, 0x51
    mov  r8d, 0x66
    jmp  .sse_packed

.sse_packed:
    ; op xmm, xmm -- register to register only for now. A memory source is
    ; the same encoding with a different ModRM, and goes in once this form
    ; is verified against NASM.
    push r8
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx               ; dst xmm
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx               ; src xmm
    pop  r8
    test r8d, r8d
    jz   .sp_noprefix
    mov  al, r8b
    call emit_b
.sp_noprefix:
    mov  esi, r13d
    mov  edx, r15d
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

.i_addsd:
    mov  bl, 0x58
    jmp  .sse_arith_d
.i_subsd:
    mov  bl, 0x5C
    jmp  .sse_arith_d
.i_mulsd:
    mov  bl, 0x59
    jmp  .sse_arith_d
.i_divsd:
    mov  bl, 0x5E
    jmp  .sse_arith_d
; cvtsd2ss xmm, xmm : F2 0F 5A /r   (double to single)
; cvtss2sd xmm, xmm : F3 0F 5A /r   (single to double)
; Register forms only: [f32; N] loads with movss and converts in place.
.i_cvtsd2ss:
    mov  bl, 0x5A
    jmp  .sse_arith_d
.i_cvtss2sd:
    mov  bl, 0x5A
    mov  byte [rel sse_pfx], 0xF3
    jmp  .sse_arith
.sse_arith_d:
    mov  byte [rel sse_pfx], 0xF2
.sse_arith:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx               ; dst xmm
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx               ; src xmm
    mov  al, [rel sse_pfx]
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; comisd xmm, xmm : 66 0F 2F /r
; ---- cache control: one memory operand, no REX.W, no result ----
; clflush [reg]    : 0F AE /7
; prefetcht0 [reg] : 0F 18 /1
.i_clflush:
    mov  bl, 0xAE
    mov  r8b, 7
    jmp  .cacheop
.i_prefetcht0:
    mov  bl, 0x18
    mov  r8b, 1
.cacheop:
    push r8
    push rbx
    lea  rcx, [rel tok_b]
    call parse_operand
    pop  rbx
    pop  r8
    cmp  eax, 9                  ; only the plain [reg] form is accepted
    jne  .unsupported
    mov  r13d, edx               ; base register
    cmp  r13d, 8                 ; r8-r15 need REX.B
    jb   .cache_op0
    mov  al, 0x41
    call emit_b
.cache_op0:
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    movzx esi, r8b               ; /n digit
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done

.i_rol:
    mov  r8b, 0                  ; D3 /0 : rotate left
    jmp  .shift
.i_ror:
    mov  r8b, 1                  ; D3 /1 : rotate right
    jmp  .shift
.i_shl:
    mov  r8b, 4
    jmp  .shift
.i_sar:
    mov  r8b, 7
    jmp  .shift
.i_shr:
    mov  r8b, 5
.shift:
    ; REX.W D3 /n  (by cl)   |   REX.W C1 /n ib  (by immediate)
    push r8
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax
    mov  r15d, edx
    pop  r8
    xor  r9d, r9d                ; 0 = 64-bit operand, 1 = 32-bit
    cmp  r12d, 7
    je   .shift_r8
    cmp  r12d, 8
    jne  .shift_chk64
    mov  r9d, 1
    jmp  .shift_src
.shift_chk64:
    cmp  r12d, 1
    jne  .unsupported
.shift_src:
    cmp  r14d, 7
    je   .shift_cl
    cmp  r14d, 2
    je   .shift_imm
    jmp  .unsupported
.shift_r8:
    ; C0 /n ib : shift an 8-bit register by an immediate
    cmp  r14d, 2
    jne  .unsupported
    mov  eax, r13d
    cmp  eax, 8
    jae  .sh8_rexb
    cmp  eax, 4
    jb   .sh8_op
    mov  al, 0x40
    call emit_b
    jmp  .sh8_op
.sh8_rexb:
    mov  al, 0x41
    call emit_b
.sh8_op:
    mov  al, 0xC0
    call emit_b
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_b
    jmp  .done
.shift_cl:
    cmp  r15d, 1                 ; only cl is a valid shift count register
    jne  .unsupported
    mov  dil, 1
    test r9d, r9d
    jz   .sh_wcl
    xor  edi, edi                ; 32-bit: no REX.W
.sh_wcl:
    xor  esi, esi
    mov  edx, r13d
    push r8
    call emit_rex
    mov  al, 0xD3
    call emit_b
    pop  r8
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    jmp  .done
.shift_imm:
    mov  dil, 1
    test r9d, r9d
    jz   .sh_wim
    xor  edi, edi                ; 32-bit: no REX.W
.sh_wim:
    xor  esi, esi
    mov  edx, r13d
    push r8
    call emit_rex
    mov  al, 0xC1
    call emit_b
    pop  r8
    mov  dil, 3
    movzx esi, r8b
    mov  edx, r13d
    call emit_modrm
    mov  eax, r15d
    call emit_b
    jmp  .done

.i_ucomisd:
    ; 66 0F 2E /r : unordered compare, same shape as comisd (0F 2F)
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx
    mov  al, 0x66
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0x2E
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

.i_comisd:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx
    mov  al, 0x66
    call emit_b
    mov  esi, r13d
    mov  edx, r15d
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0x2F
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; xorps xmm, xmm : 0F 57 /r
.i_xorps:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx
    mov  esi, r13d
    mov  edx, r15d
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0x57
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; cvtsi2sd xmm, r64 : F2 REX.W 0F 2A /r
.i_cvtsi:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx
    mov  al, 0xF2
    call emit_b
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0x2A
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; cvtsd2si r64, xmm : F2 REX.W 0F 2D /r
.i_cvtsd:
    mov  bl, 0x2D
    jmp  .sse_to_int
; cvttsd2si r64, xmm : F2 REX.W 0F 2C /r
.i_cvttsd:
    mov  bl, 0x2C
.sse_to_int:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx
    mov  al, 0xF2
    call emit_b
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    push rbx
    call emit_rex
    pop  rbx
    mov  al, 0x0F
    call emit_b
    mov  al, bl
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; movq xmm, r64 : 66 REX.W 0F 6E /r
.i_movq:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r15d, edx
    mov  al, 0x66
    call emit_b
    mov  dil, 1
    mov  esi, r13d
    mov  edx, r15d
    call emit_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0x6E
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; movsd : F2 0F 10 (load) or F2 0F 11 (store)
.i_movss:
    ; movss: the movsd encodings with F3 in place of F2
    mov  byte [rel sse_pfx], 0xF3
    jmp  .movsd_body
.i_movsd:
    mov  byte [rel sse_pfx], 0xF2
.movsd_body:
    lea  rcx, [rel tok_b]
    call parse_operand
    mov  r12d, eax
    mov  r13d, edx
    lea  rcx, [rel tok_c]
    call parse_operand
    mov  r14d, eax
    mov  r15d, edx

    cmp  r12d, 6
    je   .movsd_load
    ; destination is memory: F2 0F 11 /r
    mov  al, [rel sse_pfx]
    call emit_b
    mov  esi, r15d
    xor  edx, edx
    cmp  r12d, 9
    jne  .movsd_st_rex
    mov  edx, r13d
.movsd_st_rex:
    call sse_rex
    mov  al, 0x0F
    call emit_b
    mov  al, 0x11
    call emit_b
    cmp  r12d, 3
    je   .movsd_st_rbp
    cmp  r12d, 9
    je   .movsd_st_reg
    cmp  r12d, 5
    je   .movsd_st_rip
    cmp  r12d, 12
    je   .movsd_st_sib
    jmp  .unsupported
.movsd_st_sib:
    mov  eax, r13d
    and  eax, 0x0808             ; base or index in r8..r15?
    jnz  .unsupported
    mov  esi, r15d               ; xmm source
    mov  edx, r13d
    call emit_sib_modrm
    jmp  .done
.movsd_st_rip:
    mov  esi, r15d
    mov  eax, r13d
    call emit_rip
    jmp  .done
.movsd_st_rbp:
    mov  esi, r15d
    mov  eax, r13d
    call emit_mem_rbp
    jmp  .done
.movsd_st_reg:
    mov  esi, r15d
    mov  edx, r13d
    call emit_mem_reg
    jmp  .done

.movsd_load:
    mov  al, [rel sse_pfx]
    call emit_b
    mov  esi, r13d
    xor  edx, edx
    cmp  r14d, 6
    je   .movsd_ld_rm
    cmp  r14d, 9
    jne  .movsd_ld_rex
.movsd_ld_rm:
    mov  edx, r15d
.movsd_ld_rex:
    call sse_rex
    cmp  r14d, 6
    je   .movsd_xx
    mov  al, 0x0F
    call emit_b
    mov  al, 0x10
    call emit_b
    cmp  r14d, 3
    je   .movsd_ld_rbp
    cmp  r14d, 9
    je   .movsd_ld_reg
    cmp  r14d, 5
    je   .movsd_ld_rip
    cmp  r14d, 12
    je   .movsd_ld_sib
    jmp  .unsupported
.movsd_ld_sib:
    mov  eax, r15d
    and  eax, 0x0808             ; base or index in r8..r15?
    jnz  .unsupported
    mov  esi, r13d               ; xmm destination
    mov  edx, r15d
    call emit_sib_modrm
    jmp  .done
.movsd_ld_rip:
    mov  esi, r13d
    mov  eax, r15d
    call emit_rip
    jmp  .done
.movsd_ld_rbp:
    mov  esi, r13d
    mov  eax, r15d
    call emit_mem_rbp
    jmp  .done
.movsd_ld_reg:
    mov  esi, r13d
    mov  edx, r15d
    call emit_mem_reg
    jmp  .done
.movsd_xx:
    ; register to register
    mov  al, 0x0F
    call emit_b
    mov  al, 0x10
    call emit_b
    mov  dil, 3
    mov  esi, r13d
    mov  edx, r15d
    call emit_modrm
    jmp  .done

; ---- port I/O ----
.i_in:
    mov  al, 0xEC                ; in al, dx
    call emit_b
    jmp  .done
.i_out:
    mov  al, 0xEE                ; out dx, al
    call emit_b
    jmp  .done

.unsupported:
    ; A known mnemonic with an operand form this assembler cannot encode.
    ; Reporting it matters: silently skipping produced binaries that looked
    ; fine and crashed at runtime.
    cmp  byte [rel kasm_pass], 2
    jne  .done
    mov  byte [rel kasm_error], 1
    mov  rax, [rel kasm_line]
    cmp  qword [rel kasm_err_line], 0
    jne  .rec_more2
    mov  [rel kasm_err_line], rax
.rec_more2:
    mov  rcx, [rel err_count]
    cmp  rcx, 64
    jae  .done
    lea  rdx, [rel err_lines]
    mov  [rdx + rcx*4], eax
    lea  rdx, [rel err_dst]
    mov  [rdx + rcx*4], r12d
    lea  rdx, [rel err_src]
    mov  [rdx + rcx*4], r14d
    push rcx
    call record_err_mnem
    pop  rcx
    inc  rcx
    mov  [rel err_count], rcx
    jmp  .done

.done:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; DIRECTIVES
; handle_directive() -> al = 1 when the line was a directive and is now handled
; ==============================================================================
section .data
    d_section: db "section",0
    d_bits:    db "bits",0
    d_global:  db "global",0
    d_extern:  db "extern",0
    d_default: db "default",0
    d_db:      db "db",0
    d_dq:      db "dq",0
    d_times:   db "times",0
    d_equ:     db "equ",0
    dd_table: dq d_db, d_dq, d_dw, d_dd, d_resb, d_resw, d_resd, d_resq, d_times, d_equ, 0
    d_resb:    db "resb",0
    d_resq:    db "resq",0
    d_resw:  db "resw",0
    d_resd:  db "resd",0
    d_dw:    db "dw",0
    d_dd:    db "dd",0
    s_dot_text: db ".text",0
    s_dot_data: db ".data",0
    s_dot_bss:  db ".bss",0

section .text
handle_directive:
    push rbx
    push rsi
    push rdi
    MNEMONIC_IS d_section, .sec
    MNEMONIC_IS d_bits,    .ignore
    MNEMONIC_IS d_global,  .ignore
    MNEMONIC_IS d_extern,  .decl_extern
    MNEMONIC_IS d_default, .ignore
    MNEMONIC_IS d_db,      .data_db
    MNEMONIC_IS d_dq,      .data_dq
    MNEMONIC_IS d_resb,    .res_b
    MNEMONIC_IS d_resq,    .res_q
    MNEMONIC_IS d_resw,    .res_w
    MNEMONIC_IS d_resd,    .res_d
    MNEMONIC_IS d_dw,      .data_dw
    MNEMONIC_IS d_dd,      .data_dd
    MNEMONIC_IS d_equ,     .decl_equ
    MNEMONIC_IS d_times,   .data_times
    xor  al, al
    pop  rdi
    pop  rsi
    pop  rbx
    ret

.sec:
    lea  rcx, [rel tok_b]
    lea  rdx, [rel s_dot_data]
    call str_eq
    test al, al
    jnz  .to_data
    lea  rcx, [rel tok_b]
    lea  rdx, [rel s_dot_bss]
    call str_eq
    test al, al
    jnz  .to_bss
    mov  byte [rel cur_section], 0
    jmp  .yes
.to_data:
    mov  byte [rel cur_section], 1
    jmp  .yes
.to_bss:
    mov  byte [rel cur_section], 2
    jmp  .yes

.data_times:
    ; 'times N db V' arrives with tok_b holding "N db V"
    push r12
    push r13
    lea  rcx, [rel tok_b]
    call parse_number
    mov  r12, rax                ; repeat count
    ; step over the count and the directive name to reach the value
    lea  rsi, [rel tok_b]
.dt_skipnum:
    mov  al, [rsi]
    cmp  al, '0'
    jb   .dt_afternum
    cmp  al, '9'
    ja   .dt_afternum
    inc  rsi
    jmp  .dt_skipnum
.dt_afternum:
    call skip_blanks_rsi
    mov  r13b, 1                 ; 1 = byte, 8 = qword
    cmp  byte [rsi], 'd'
    jne  .dt_emit_setup
    cmp  byte [rsi+1], 'q'
    jne  .dt_skipdir
    mov  r13b, 8
.dt_skipdir:
    add  rsi, 2
    call skip_blanks_rsi
.dt_emit_setup:
    mov  rcx, rsi
    call parse_number
    mov  rsi, rax                ; the value to repeat
.dt_loop:
    test r12, r12
    jz   .dt_done
    mov  rax, rsi
    cmp  r13b, 8
    je   .dt_q
    call emit_b
    jmp  .dt_next
.dt_q:
    call emit_q
.dt_next:
    dec  r12
    jmp  .dt_loop
.dt_done:
    pop  r13
    pop  r12
    jmp  .yes
.decl_equ:
    ; 'name equ <expr>' arrives with the name already shifted away, so use the
    ; copy kept when the label was seen.
    lea  rcx, [rel tok_b]
    call parse_expr
    mov  r8, rax
    lea  rcx, [rel last_label]
    call str_len_local
    mov  rdx, rax
    lea  rcx, [rel last_label]
    call add_equ
    jmp  .yes
.decl_extern:
    cmp  byte [rel kasm_pass], 1
    jne  .yes                    ; only collect them once
    lea  rcx, [rel tok_b]
    push rcx
    call str_len_local
    mov  rdx, rax
    pop  rcx
    call kasm_add_extern
    ; 'extern A, B, C': split_line leaves A in tok_b and "B, C" in tok_c.
    ; Only A used to be registered; the rest of the line was dropped without
    ; a word, so an import declared third on a line never reached the table.
    push rsi
    push rdi
    lea  rsi, [rel tok_c]
    jmp  .dx_next
.dx_next:
    call skip_blanks_rsi
    cmp  byte [rsi], 0
    je   .dx_done
    cmp  byte [rsi], ','
    jne  .dx_name
    inc  rsi
    jmp  .dx_next
.dx_name:
    mov  rdi, rsi
    jmp  .dx_scan
.dx_scan:
    mov  al, [rdi]
    test al, al
    jz   .dx_end
    cmp  al, ','
    je   .dx_end
    cmp  al, ' '
    je   .dx_end
    cmp  al, 9
    je   .dx_end
    inc  rdi
    jmp  .dx_scan
.dx_end:
    mov  rcx, rsi
    mov  rdx, rdi
    sub  rdx, rsi
    mov  rsi, rdi
    call kasm_add_extern
    jmp  .dx_next
.dx_done:
    pop  rdi
    pop  rsi
    jmp  .yes
; resb / resq reserve space in .bss without emitting bytes
.res_b:
    lea  rcx, [rel tok_b]
    call parse_expr
    call bss_round8
    add  [rel kasm_bss_len], rax
    add  [rel bss_cursor], rax
    jmp  .yes
.res_w:
    lea  rcx, [rel tok_b]
    call parse_expr
    shl  rax, 1
    call bss_round8
    add  [rel kasm_bss_len], rax
    add  [rel bss_cursor], rax
    jmp  .yes
.res_d:
    lea  rcx, [rel tok_b]
    call parse_expr
    shl  rax, 2
    call bss_round8
    add  [rel kasm_bss_len], rax
    add  [rel bss_cursor], rax
    jmp  .yes
.res_q:
    lea  rcx, [rel tok_b]
    call parse_expr
    shl  rax, 3
    call bss_round8
    add  [rel kasm_bss_len], rax
    add  [rel bss_cursor], rax
    jmp  .yes

.data_db:
    ; db "text",0  |  db n1,n2,n3,...
    ; With a label ('lbl: db 1,2,3') the tokeniser leaves the whole list in
    ; tok_b and clears tok_c; without one it splits across tok_b and tok_c.
    ; Walk both buffers so either shape emits every value.
    mov  byte [rel db_phase], 0
    lea  rcx, [rel tok_b]
    ; nasm accepts either quote character, and the generated runtime uses
    ; single quotes ("__outname: db 'out.bmp', 0"). Recognising only the
    ; double one left the text unconsumed and the walker spun on it forever.
    mov  byte [rel db_quote], '"'
    cmp  byte [rcx], '"'
    je   .db_str
    cmp  byte [rcx], 0x27
    jne  .db_tail
    mov  byte [rel db_quote], 0x27
.db_str:
    inc  rcx
.db_loop:
    mov  al, [rcx]
    test al, al
    jz   .yes
    cmp  al, [rel db_quote]
    je   .db_after
    push rcx
    call emit_b
    pop  rcx
    inc  rcx
    jmp  .db_loop
.db_after:
    ; values after the closing quote, such as  db "text",0
    inc  rcx
.db_tail:
    mov  al, [rcx]
    test al, al
    jz   .db_next_buf
    cmp  al, ','
    je   .db_tail_adv
    cmp  al, ' '
    je   .db_tail_adv
    cmp  al, 9
    je   .db_tail_adv
    ; A quoted run may appear anywhere in the list, as in
    ;   db 13, 10, "Build succeeded!", 13, 10, 0
    ; Bailing out here dropped the text and left the label pointing at
    ; whatever string came next in the section.
    cmp  al, '"'
    je   .db_tail_dq
    cmp  al, 0x27
    je   .db_tail_sq
    cmp  al, '0'
    jb   .db_next_buf
    cmp  al, '9'
    ja   .db_next_buf
    push rcx
    call parse_number
    call emit_b
    pop  rcx
.db_skip_num:
    ; past the whole number: 0x51 is four characters, and stopping at the
    ; 'x' ended the list there, so 'db 0x51, 0x52' gave one byte
    mov  al, [rcx]
    test al, al
    jz   .db_tail
    cmp  al, ','
    je   .db_tail
    cmp  al, ' '
    je   .db_tail
    cmp  al, 9
    je   .db_tail
    inc  rcx
    jmp  .db_skip_num
.db_tail_dq:
    mov  byte [rel db_quote], '"'
    jmp  .db_tail_str
.db_tail_sq:
    mov  byte [rel db_quote], 0x27
.db_tail_str:
    inc  rcx
.db_ts_loop:
    mov  al, [rcx]
    test al, al
    jz   .db_next_buf
    cmp  al, [rel db_quote]
    je   .db_ts_end
    push rcx
    call emit_b
    pop  rcx
    inc  rcx
    jmp  .db_ts_loop
.db_ts_end:
    inc  rcx
    jmp  .db_tail

.db_next_buf:
    cmp  byte [rel db_phase], 0
    jne  .yes
    mov  byte [rel db_phase], 1
    lea  rcx, [rel tok_c]
    jmp  .db_tail
.db_tail_adv:
    inc  rcx
    jmp  .db_tail

.data_dw:
    mov  byte [rel dl_size], 2
    jmp  .data_list
.data_dd:
    mov  byte [rel dl_size], 4
    jmp  .data_list
.data_dq:
    ; a '.' in a token that starts like a number means a floating point
    ; literal; 'dq .label' and 'dq name.local' are addresses
    lea  rsi, [rel tok_b]
    mov  al, [rsi]
    cmp  al, '-'
    je   .dq_scan
    cmp  al, '+'
    je   .dq_scan
    cmp  al, '0'
    jb   .dq_int
    cmp  al, '9'
    ja   .dq_int
.dq_scan:
    mov  al, [rsi]
    test al, al
    jz   .dq_int
    cmp  al, ','
    je   .dq_int                 ; only the first value decides
    cmp  al, '.'
    je   .dq_float
    inc  rsi
    jmp  .dq_scan
.dq_int:
    mov  byte [rel dl_size], 8

; ---- dw / dd / dq, one or many values per line ----
; Only the first value used to be emitted, and only when it was a plain
; number. A table written as
;     dq kw_fn, KW_FN
; produced eight zero bytes instead of a pointer and its id, which collapsed
; the whole keyword table and left every keyword unrecognised.
.data_list:
    mov  byte [rel db_phase], 0
    lea  rcx, [rel tok_b]
.dl_scan:
    mov  al, [rcx]
    test al, al
    jz   .dl_next_buf
    cmp  al, ','
    je   .dl_adv
    cmp  al, ' '
    je   .dl_adv
    cmp  al, 9
    je   .dl_adv
    call dl_is_label
    test al, al
    jnz  .dl_label
    call parse_expr              ; rcx = text; leaves expr_ptr past the value
    mov  rcx, [rel expr_ptr]
    push rcx
    call dl_emit
    pop  rcx
    jmp  .dl_scan
.dl_label:
    push rcx
    call dl_tok_len
    mov  rdx, rax
    pop  rcx
    push rcx
    push rdx
    call qualify_label           ; '.x' belongs to the label above it
    call kasm_find_label
    mov  qword [rel cur_addend], 0
    mov  dil, 6                  ; absolute address, filled in by the linker
    call add_fixup
    pop  rdx
    pop  rcx
    add  rcx, rdx                ; step past the name
    push rcx
    xor  eax, eax
    call dl_emit                 ; reserve the field
    pop  rcx
    jmp  .dl_scan
.dl_adv:
    inc  rcx
    jmp  .dl_scan
.dl_next_buf:
    cmp  byte [rel db_phase], 0
    jne  .yes
    mov  byte [rel db_phase], 1
    lea  rcx, [rel tok_c]
    jmp  .dl_scan
.dq_float:
    lea  rcx, [rel tok_b]
    call parse_float
    sub  rsp, 16
    movsd [rsp], xmm0
    mov  rax, [rsp]
    add  rsp, 16
    call emit_q
    jmp  .yes

.ignore:
.yes:
    mov  al, 1
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; kasm_assemble(rcx = source text, rdx = length) -> rax = 1 ok, 0 on error
; Pass one records label addresses; pass two emits bytes and fills references.
; ==============================================================================
kasm_assemble:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    mov  r13, rcx                ; source
    mov  r14, rdx                ; length

    mov  byte [rel kasm_pass], 1
    mov  qword [rel bss_cursor], 0
    call run_pass
    mov  byte [rel kasm_pass], 2
    mov  qword [rel kasm_code_len], 0
    mov  qword [rel kasm_data_len], 0
    mov  qword [rel bss_cursor], 0
    mov  byte  [rel cur_section], 0
    mov  qword [rel fix_count], 0
    ; Pass one records an extref for every forward reference, because the
    ; label is not in the table yet. Pass two resolves those correctly as
    ; fixups, so the pass-one guesses must not survive: the linker would
    ; overwrite a correct internal call with a jump to an import thunk.
    mov  qword [rel extref_count], 0
    ; .bss is measured on both passes; without this it was reserved twice.
    mov  qword [rel kasm_bss_len], 0
    call run_pass
    ; data follows the code, aligned to 16 bytes
    mov  rax, [rel kasm_code_len]
    add  rax, 15
    and  rax, -16
    mov  [rel data_base], rax
    ; .bss follows .data in the flat layout kasm resolves against, on a
    ; 16-byte boundary like the PE writer puts it: a futex word or an
    ; atomic exchange needs an aligned address, and .data has any length.
    add  rax, [rel kasm_data_len]
    add  rax, 15
    and  rax, -16
    mov  [rel bss_base], rax
    call apply_fixups
    call kasm_prune_externs

    movzx eax, byte [rel kasm_error]
    test  eax, eax
    jnz   .err
    mov   rax, 1
    jmp   .out
.err:
    xor  rax, rax
.out:
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; run_pass() walks the source line by line using r13/r14
run_pass:
    mov  qword [rel kasm_line], 0
    push rbx
    push rsi
    push rdi
    push r12
    mov  rsi, r13
    mov  r12, r14

.next_line:
    test r12, r12
    jz   .done
    inc  qword [rel kasm_line]
    ; copy one line into line_buf
    lea  rdi, [rel line_buf]
    xor  ebx, ebx
.copy:
    test r12, r12
    jz   .line_ready
    mov  al, [rsi]
    inc  rsi
    dec  r12
    cmp  al, 10
    je   .line_ready
    cmp  al, 13
    je   .copy
    cmp  ebx, 510
    jae  .copy
    mov  [rdi + rbx], al
    inc  ebx
    jmp  .copy
.line_ready:
    mov  byte [rdi + rbx], 0

    ; Ignore preprocessor lines such as the %line markers NASM writes when
    ; it is used as a preprocessor (nasm -E).
    lea  rcx, [rel line_buf]
.lr_skip_ws:
    mov  al, [rcx]
    cmp  al, ' '
    je   .lr_ws_adv
    cmp  al, 9
    jne  .lr_check
.lr_ws_adv:
    inc  rcx
    jmp  .lr_skip_ws
.lr_check:
    cmp  al, '%'
    je   .next_line
    ; nasm -E writes directives in brackets: [extern X], [bits 64].
    ; Strip them so the ordinary directive path sees them.
    cmp  al, '['
    jne  .lr_go
    mov  byte [rcx], ' '
    mov  rdx, rcx
.lr_find_close:
    mov  al, [rdx]
    test al, al
    jz   .lr_go
    cmp  al, ']'
    jne  .lr_close_adv
    mov  byte [rdx], 0
    jmp  .lr_go
.lr_close_adv:
    inc  rdx
    jmp  .lr_find_close
.lr_go:

    lea  rcx, [rel line_buf]
    call split_line
    test al, al
    jnz  .label_def

.after_label:
    cmp  byte [rel tok_a], 0
    je   .next_line
    call handle_directive
    test al, al
    jnz  .next_line
    call encode_line
    jmp  .next_line

.label_def:
    push rax                     ; 1 = plain label, 2 = label with a definition
    ; Register in BOTH passes: pass 1 seeds the table so forward references
    ; resolve, pass 2 refreshes each address against the final layout.
    ; kasm_add_label updates an existing name instead of duplicating it.
    lea  rcx, [rel tok_a]
    lea  rdx, [rel last_label]
    call copy_tok                ; keep the name for a possible 'equ'
    ; A label without a leading dot opens the scope that the '.name' labels
    ; after it belong to, exactly as in NASM.
    cmp  byte [rel tok_a], '.'
    je   .lbl_keep_scope
    lea  rcx, [rel tok_a]
    lea  rdx, [rel cur_global]
    call copy_tok
.lbl_keep_scope:
    lea  rcx, [rel tok_a]
    push rcx
    call str_len_local
    mov  rdx, rax
    pop  rcx
    call qualify_label
    call kasm_add_label
.lbl_after:
    pop  rax
    cmp  al, 2
    jne  .next_line
    ; A data directive keeps the historical two-token shift, which several of
    ; the db/dq paths rely on. Anything else is a real instruction and gets
    ; tokenised properly, so that '.n_eof: lea rax, [rel tn_eof]' works.
    ; is_data_dir wants a blank after the name, so hand it the saved text
    ; rather than the null-terminated token.
    lea  rcx, [rel lbl_rest]
    call is_data_dir
    test al, al
    jnz  .lbl_shift
    lea  rcx, [rel lbl_rest]
    call split_line
    jmp  .after_label
.lbl_shift:
    lea  rcx, [rel tok_b]
    lea  rdx, [rel tok_a]
    call copy_tok
    lea  rcx, [rel tok_c]
    lea  rdx, [rel tok_b]
    call copy_tok
    mov  byte [rel tok_c], 0
    jmp  .after_label

.done:
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; apply_fixups()
; Every rel32 field recorded during pass two is patched with the distance from
; the end of the instruction to the target label.
; ==============================================================================
; dl_tok_len(rcx = text) -> rax = length up to a comma, blank or end of string.
; str_len_local measures to the terminator, which for "kw_fn, 102" is the whole
; remainder: the name never matched and the table stayed full of zeros.
dl_tok_len:
    push rdx
    xor  rax, rax
.dtl:
    mov  dl, [rcx + rax]
    test dl, dl
    jz   .dtl_out
    cmp  dl, ','
    je   .dtl_out
    cmp  dl, ' '
    je   .dtl_out
    cmp  dl, 9
    je   .dtl_out
    inc  rax
    jmp  .dtl
.dtl_out:
    pop  rdx
    ret

; dl_emit(rax = value) writes dl_size bytes into the current section
dl_emit:
    cmp  byte [rel dl_size], 2
    je   .de_w
    cmp  byte [rel dl_size], 4
    je   .de_d
    call emit_q
    ret
.de_w:
    call emit_w
    ret
.de_d:
    call emit_d
    ret

; dl_is_label(rcx = text) -> al = 1 when the token names a known label.
; Constants declared with 'equ' resolve through parse_expr, so only real
; labels take the fixup path.
dl_is_label:
    push rbx
    push rcx
    push rdx
    mov  al, [rcx]
    cmp  al, '0'
    jb   .dil_alpha
    cmp  al, '9'
    jbe  .dil_no
.dil_alpha:
    call dl_tok_len
    mov  rdx, rax
    ; Ask the constant table first. The preprocessor turns '%define X V' into
    ; 'X equ V', and that line also registers X as a label, so every constant
    ; would otherwise look like an address -- and they all share one, since
    ; the definitions sit together in the include file.
    push rcx
    push rdx
    call find_equ
    pop  rdx
    pop  rcx
    cmp  eax, -1
    jne  .dil_no                 ; a named constant: emit its value
    call qualify_label
    call kasm_find_label
    cmp  eax, -1
    je   .dil_no
    mov  al, 1
    jmp  .dil_out
.dil_no:
    xor  al, al
.dil_out:
    pop  rdx
    pop  rcx
    pop  rbx
    ret

apply_fixups:
    push rbx
    push rsi
    push rdi
    xor  rbx, rbx
.l:
    cmp  rbx, [rel fix_count]
    jae  .done
    lea  rdi, [rel fix_at]
    mov  esi, [rdi + rbx*4]      ; where the field sits
    lea  rdi, [rel fix_label]
    mov  eax, [rdi + rbx*4]      ; which label
    cmp  eax, -1
    je   .next
    push rsi
    push rax
    lea  rdi, [rel fix_kind]
    movzx edi, byte [rdi + rbx]
    mov  [rel cur_fix_kind], edi
    cmp  edi, 6
    je   .skip_abs               ; absolute data slots are the linker's job
    pop  rax
    push rax
    call kasm_label_addr         ; -> rax = target address
    mov  r8, rax
    pop  rax
    ; a data label lives after the code, so add the data base
    push rax
    lea  rdi, [rel lbl_section]
    movzx edi, byte [rdi + rax]
    cmp  edi, 1
    je   .add_data_base
    cmp  edi, 2
    je   .add_bss_base
    jmp  .no_data_base
.add_data_base:
    mov  rax, [rel data_base]
    add  r8, rax
    jmp  .no_data_base
.add_bss_base:
    mov  rax, [rel bss_base]
    add  r8, rax
.no_data_base:
    ; add the addend of [rel label+N]
    push rax
    lea  rax, [rel fix_addend]
    mov  eax, [rax + rbx*4]
    add  r8, rax
    pop  rax
    pop  rax
    mov  rax, r8
    pop  rsi
    ; displacement = target - (field + 4)
    mov  ecx, esi
    add  ecx, 4
    sub  eax, ecx
    ; write the dword at kasm_code + esi
    lea  rdi, [rel kasm_code]
    mov  [rdi + rsi], eax
    jmp  .next
.skip_abs:
    pop  rax
    pop  rsi
.next:
    inc  rbx
    jmp  .l
.done:
    pop  rdi
    pop  rsi
    pop  rbx
    ret
