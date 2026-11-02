; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_xwasm_S_IN: dq 16
section .text
section .data
__g_xwasm_S_IN_END: dq 24
section .text
section .data
__g_xwasm_S_LINE_NO: dq 32
section .text
section .data
__g_xwasm_S_ERR: dq 40
section .text
section .data
__g_xwasm_S_ERR_LINE: dq 48
section .text
section .data
__g_xwasm_S_ERR_MSG: dq 56
section .text
section .data
__g_xwasm_S_REST: dq 64
section .text
section .data
__g_xwasm_S_SKIPPING: dq 80
section .text
section .data
__g_xwasm_S_ERR_INSN: dq 88
section .text
section .data
__g_xwasm_S_LINE: dq 248
section .text
section .data
__g_xwasm_S_MN: dq 1272
section .text
section .data
__g_xwasm_S_OPS: dq 2072
section .text
section .data
__g_xwasm_OP_KIND: dq 0
section .text
section .data
__g_xwasm_OP_REG: dq 1
section .text
section .data
__g_xwasm_OP_RSIZE: dq 2
section .text
section .data
__g_xwasm_OP_XMM: dq 3
section .text
section .data
__g_xwasm_OP_MSIZE: dq 4
section .text
section .data
__g_xwasm_OP_SCALE: dq 5
section .text
section .data
__g_xwasm_OP_BASE: dq 6
section .text
section .data
__g_xwasm_OP_INDEX: dq 7
section .text
section .data
__g_xwasm_OP_VAL: dq 8
section .text
section .data
__g_xwasm_OP_REL: dq 16
section .text
section .data
__g_xwasm_OP_TEXT: dq 24
section .text
section .data
__g_xwasm_K_REG: dq 1
section .text
section .data
__g_xwasm_K_XMM: dq 2
section .text
section .data
__g_xwasm_K_IMM: dq 3
section .text
section .data
__g_xwasm_K_MEM: dq 4
section .text
section .data
__g_xwasm_K_LABEL: dq 5
section .text
section .data
__g_xwasm_FK_NONE: dq 0
section .text
section .data
__g_xwasm_FK_SUB: dq 1
section .text
section .data
__g_xwasm_FK_RES: dq 2
section .text
section .data
__g_xwasm_FK_ADD: dq 3
section .text
section .data
__g_xwasm_FK_FP: dq 4
section .text
section .data
__g_xwasm_L_PC: dq 0
section .text
section .data
__g_xwasm_L_FA: dq 2
section .text
section .data
__g_xwasm_L_FB: dq 3
section .text
section .data
__g_xwasm_L_FR: dq 4
section .text
section .data
__g_xwasm_L_T0: dq 5
section .text
section .data
__g_xwasm_L_T1: dq 6
section .text
section .data
__g_xwasm_L_T2: dq 7
section .text
section .data
__g_xwasm_L_FX: dq 8
section .text
section .data
__g_xwasm_L_FY: dq 9
section .text
section .data
__g_xwasm_L_R0: dq 10
section .text
section .data
__g_xwasm_XW_SYNC: dq 4194303
section .text
section .data
__g_xwasm_LK_CODE: dq 1
section .text
section .data
__g_xwasm_LK_DATA: dq 2
section .text
section .data
__g_xwasm_LK_BSS: dq 3
section .text
section .data
__g_xwasm_XW_DATA_BASE: dq 65536
section .text
section .data
__g_xwasm_XW_STACK: dq 8388608
section .text
section .data
__g_xwasm_XW_MAXLBL: dq 262144
section .text
section .data
__g_xwasm_XW_HASH: dq 65536
section .text
section .data
__g_xwasm_XW_NAMES: dq 8388608
section .text
section .data
__g_xwasm_XW_MAXFN: dq 65536
section .text
section .data
__g_xwasm_XW_BODY_MAX: dq 8388608
section .text
section .data
__g_xwasm_XW_CODE_MAX: dq 33554432
section .text
section .data
__g_xwasm_XW_DATA_MAX: dq 8388608
section .text
section .data
__g_xwasm_B_CODE: dq 0
section .text
section .data
__g_xwasm_B_SECT: dq 1
section .text
section .data
__g_xwasm_B_TMP: dq 2
section .text
section .data
__g_xwasm_B_TB: dq 3
section .text
section .data
__g_xwasm_xv_st: dq 0
section .text
section .data
__g_xwasm_xv_out: dq 0
section .text
section .data
__g_xwasm_xv_out_cap: dq 0
section .text
section .data
__g_xwasm_xv_on: dq 0
section .text
section .data
__g_xwasm_xv_pass: dq 0
section .text
section .data
__g_xwasm_xv_sec: dq 0
section .text
section .data
__g_xwasm_xv_addr: dq 0
section .text
section .data
__g_xwasm_xv_dsize: dq 0
section .text
section .data
__g_xwasm_xv_bsize: dq 0
section .text
section .data
__g_xwasm_xv_bss_base: dq 0
section .text
section .data
__g_xwasm_xv_heap_base: dq 0
section .text
section .data
__g_xwasm_xv_fn: dq 0
section .text
section .data
__g_xwasm_xv_blk: dq 0
section .text
section .data
__g_xwasm_xv_nfn: dq 0
section .text
section .data
__g_xwasm_xv_fk: dq 0
section .text
section .data
__g_xwasm_xv_term: dq 0
section .text
section .data
__g_xwasm_xv_iff: dq 0
section .text
section .data
__g_xwasm_xv_start_fn: dq 0
section .text
section .data
__g_xwasm_xv_lmode: dq 0
section .text
section .data
__g_xwasm_xv_regs: dq 0
section .text
section .data
__g_xwasm_xv_nfn_total: dq 0
section .text
section .data
__g_xwasm_xv_addr_total: dq 0
section .text
section .data
__g_xwasm_xv_qn: dq 0
section .text
section .data
__g_xwasm_xv_ql: dq 0
section .text
section .data
__g_xwasm_xv_add: dq 0
section .text
section .bss
__g_xwasm_xv_glob: resq 32
section .text
section .bss
__g_xwasm_xv_qbuf: resq 64
section .text
section .bss
__g_xwasm_xv_tok: resq 8
section .text
section .bss
__g_xwasm_xv_cnt: resq 4
section .text
section .bss
__g_xwasm_xv_names: resq 1048576
section .text
section .data
__g_xwasm_xv_names_n: dq 0
section .text
section .bss
__g_xwasm_xv_l_off: resq 131072
section .text
section .bss
__g_xwasm_xv_l_len: resq 131072
section .text
section .bss
__g_xwasm_xv_l_kind: resq 32768
section .text
section .bss
__g_xwasm_xv_l_tgt: resq 32768
section .text
section .bss
__g_xwasm_xv_l_fn: resq 131072
section .text
section .bss
__g_xwasm_xv_l_blk: resq 131072
section .text
section .bss
__g_xwasm_xv_l_val: resq 262144
section .text
section .bss
__g_xwasm_xv_l_next: resq 131072
section .text
section .data
__g_xwasm_xv_l_n: dq 0
section .text
section .bss
__g_xwasm_xv_hash: resq 32768
section .text
section .bss
__g_xwasm_xv_f_addr: resq 65536
section .text
section .bss
__g_xwasm_xv_f_nblk: resq 32768
section .text
section .bss
__g_xwasm_xv_f_regs: resq 32768
section .text
section .bss
__g_xwasm_xv_body: resq 1048576
section .text
section .data
__g_xwasm_xv_body_n: dq 0
section .text
section .bss
__g_xwasm_xv_code: resq 4194304
section .text
section .bss
__g_xwasm_xv_data: resq 1048576
section .text
section .bss
__g_xwasm_xv_sect: resq 524288
section .text
section .bss
__g_xwasm_xv_tmp: resq 8
section .text
section .bss
__g_xwasm_xv_tb: resq 32
section .text
xv_g8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_p8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 0
    jmp .__ret_1
.__ret_1:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_g32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov eax, dword [rax]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_p32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, 0
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_g64:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_p64:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_s32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 2147483648
    cmp rax, rcx
    jl .L7
    mov rax, rbx
    mov rcx, 4294967296
    sub rax, rcx
    jmp .__ret_6
    jmp .L8
.L7:
.L8:
    mov rax, rbx
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_s:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_xv_st]
    cmp rax, 0
    jne .L10
    sub rsp, 32
    call xa_get_state
    add rsp, 32
    mov [rel __g_xwasm_xv_st], rax
    jmp .L11
.L10:
.L11:
    mov rax, [rel __g_xwasm_xv_st]
    add rax, rbx
    jmp .__ret_9
.__ret_9:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_get:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_set:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p64
    add rsp, 32
    jmp .__ret_13
.__ret_13:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_err:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xwasm_S_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_get
    add rsp, 32
    jmp .__ret_14
.__ret_14:
    mov rsp, rbp
    pop rbp
    ret
xv_op:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_S_OPS]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
    mov rax, rbx
    mov rcx, 32
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_15
.__ret_15:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    jmp .__ret_16
.__ret_16:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    jmp .__ret_17
.__ret_17:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_rs:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_RSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    jmp .__ret_18
.__ret_18:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_val:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_VAL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    jmp .__ret_19
.__ret_19:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_wb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_xv_body_n]
    push rax
    mov rax, [rel __g_xwasm_XW_BODY_MAX]
    sub rax, 16
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L21
section .data
.str23: db 111,117,116,112,117,116,32,98,117,102,102,101,114,32,102,117,108,108,0
section .text
    lea rax, [rel .str23]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_20
    jmp .L22
.L21:
.L22:
    lea rax, [rel __g_xwasm_xv_body]
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_body_n]
    add rax, 1
    mov [rel __g_xwasm_xv_body_n], rax
    mov rax, 0
    jmp .__ret_20
.__ret_20:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_wuleb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rbx, rax
.L25:
    mov rax, rbx
    shr rax, 7
    cmp rax, 0
    je .L26
    mov rax, rbx
    and rax, 127
    or rax, 128
    push rax
    pop rcx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, rbx
    shr rax, 7
    mov rbx, rax
.L27:
    jmp .L25
.L26:
    mov rax, rbx
    and rax, 127
    push rax
    pop rcx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_24
.__ret_24:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_wsleb:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rax, rbx
    mov r13, rax
.L29:
    mov rax, 1
    test rax, rax
    jz .L30
    mov rax, r13
    and rax, 127
    mov r12, rax
    mov rax, r13
    sar rax, 7
    mov r13, rax
    mov rax, r12
    and rax, 64
    mov rbx, rax
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L36
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L36
    mov rax, 1
    jmp .L37
.L36:
    mov rax, 0
.L37:
    test rax, rax
    jnz .L34
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L38
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L38
    mov rax, 1
    jmp .L39
.L38:
    mov rax, 0
.L39:
    test rax, rax
    jnz .L34
    mov rax, 0
    jmp .L35
.L34:
    mov rax, 1
.L35:
    test rax, rax
    jz .L32
    mov rcx, r12
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_28
    jmp .L33
.L32:
.L33:
    mov rax, r12
    or rax, 128
    push rax
    pop rcx
    sub rsp, 32
    call xv_wb
    add rsp, 32
.L31:
    jmp .L29
.L30:
    mov rax, 0
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i64const:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 66
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wsleb
    add rsp, 32
    jmp .__ret_40
.__ret_40:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i32const:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 65
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wsleb
    add rsp, 32
    jmp .__ret_41
.__ret_41:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_lget:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 32
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_42
.__ret_42:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_lset:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 33
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_43
.__ret_43:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_ltee:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 34
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_44
.__ret_44:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_gget_raw:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 35
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_45
.__ret_45:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_gset_raw:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 36
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_46
.__ret_46:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_gget:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L50
    mov rax, [rel __g_xwasm_xv_lmode]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L50
    mov rax, 1
    jmp .L51
.L50:
    mov rax, 0
.L51:
    test rax, rax
    jz .L48
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_L_R0]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    jmp .__ret_47
    jmp .L49
.L48:
.L49:
    mov rcx, rbx
    sub rsp, 32
    call xv_gget_raw
    add rsp, 32
    jmp .__ret_47
.__ret_47:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_gset:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L55
    mov rax, [rel __g_xwasm_xv_lmode]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L55
    mov rax, 1
    jmp .L56
.L55:
    mov rax, 0
.L56:
    test rax, rax
    jz .L53
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_L_R0]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    jmp .__ret_52
    jmp .L54
.L53:
.L54:
    mov rcx, rbx
    sub rsp, 32
    call xv_gset_raw
    add rsp, 32
    jmp .__ret_52
.__ret_52:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_sync_in:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xwasm_xv_lmode]
    cmp rax, 0
    jne .L58
    mov rax, 0
    jmp .__ret_57
    jmp .L59
.L58:
.L59:
    mov rax, [rel __g_xwasm_xv_regs]
    push rax
    mov rax, [rel __g_xwasm_XW_SYNC]
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L60:
    cmp rbx, 32
    jge .L61
    mov rax, r12
    mov rcx, rbx
    shr rax, cl
    and rax, 1
    cmp rax, 0
    je .L63
    mov rcx, rbx
    sub rsp, 32
    call xv_gget_raw
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_L_R0]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    jmp .L64
.L63:
.L64:
    add rbx, 1
.L62:
    jmp .L60
.L61:
    mov rax, 0
    jmp .__ret_57
.__ret_57:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_sync_out:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xwasm_xv_lmode]
    cmp rax, 0
    jne .L66
    mov rax, 0
    jmp .__ret_65
    jmp .L67
.L66:
.L67:
    mov rax, [rel __g_xwasm_xv_regs]
    push rax
    mov rax, [rel __g_xwasm_XW_SYNC]
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L68:
    cmp rbx, 32
    jge .L69
    mov rax, r12
    mov rcx, rbx
    shr rax, cl
    and rax, 1
    cmp rax, 0
    je .L71
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_L_R0]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_gset_raw
    add rsp, 32
    jmp .L72
.L71:
.L72:
    add rbx, 1
.L70:
    jmp .L68
.L69:
    mov rax, 0
    jmp .__ret_65
.__ret_65:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_73
.__ret_73:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_simd:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 253
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_74
.__ret_74:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_simd_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xv_simd
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_75
.__ret_75:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_base:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_B_CODE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L77
    lea rax, [rel __g_xwasm_xv_code]
    jmp .__ret_76
    jmp .L78
.L77:
.L78:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L79
    lea rax, [rel __g_xwasm_xv_sect]
    jmp .__ret_76
    jmp .L80
.L79:
.L80:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_B_TMP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L81
    lea rax, [rel __g_xwasm_xv_tmp]
    jmp .__ret_76
    jmp .L82
.L81:
.L82:
    lea rax, [rel __g_xwasm_xv_tb]
    jmp .__ret_76
.__ret_76:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_n:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_xwasm_xv_cnt]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    jmp .__ret_83
.__ret_83:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_set_n:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    lea rax, [rel __g_xwasm_xv_cnt]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p64
    add rsp, 32
    jmp .__ret_84
.__ret_84:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_ob:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rcx, r13
    sub rsp, 32
    call xv_n
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call xv_base
    add rsp, 32
    add rax, rbx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    jmp .__ret_85
.__ret_85:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_obuleb:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov rbx, rax
.L87:
    mov rax, rbx
    shr rax, 7
    cmp rax, 0
    je .L88
    mov rax, r12
    push rax
    mov rax, rbx
    and rax, 127
    or rax, 128
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, rbx
    shr rax, 7
    mov rbx, rax
.L89:
    jmp .L87
.L88:
    mov rax, r12
    push rax
    mov rax, rbx
    and rax, 127
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_ob
    add rsp, 32
    jmp .__ret_86
.__ret_86:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_obsleb:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rbx, rdx
    mov rax, rbx
    mov r13, rax
.L91:
    mov rax, 1
    test rax, rax
    jz .L92
    mov rax, r13
    and rax, 127
    mov r12, rax
    mov rax, r13
    sar rax, 7
    mov r13, rax
    mov rax, r12
    and rax, 64
    mov rbx, rax
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L98
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L98
    mov rax, 1
    jmp .L99
.L98:
    mov rax, 0
.L99:
    test rax, rax
    jnz .L96
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L100
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L100
    mov rax, 1
    jmp .L101
.L100:
    mov rax, 0
.L101:
    test rax, rax
    jnz .L96
    mov rax, 0
    jmp .L97
.L96:
    mov rax, 1
.L97:
    test rax, rax
    jz .L94
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call xv_ob
    add rsp, 32
    jmp .__ret_90
    jmp .L95
.L94:
.L95:
    mov rax, r14
    push rax
    mov rax, r12
    or rax, 128
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_ob
    add rsp, 32
.L93:
    jmp .L91
.L92:
    mov rax, 0
    jmp .__ret_90
.__ret_90:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_obstr:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
.L103:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 0
    je .L104
    add r12, 1
.L105:
    jmp .L103
.L104:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call xv_obuleb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L106:
    cmp rbx, r12
    jge .L107
    mov rax, r14
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_ob
    add rsp, 32
    add rbx, 1
.L108:
    jmp .L106
.L107:
    mov rax, 0
    jmp .__ret_102
.__ret_102:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_hash_of:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L110:
    cmp rbx, r13
    jge .L111
    mov rax, r12
    shl rax, 5
    sub rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    add rbx, 1
.L112:
    jmp .L110
.L111:
    mov rax, r12
    shr rax, 16
    mov rcx, rax
    mov rax, r12
    xor rax, rcx
    mov r12, rax
    mov rax, [rel __g_xwasm_XW_HASH]
    sub rax, 1
    mov rcx, rax
    mov rax, r12
    and rax, rcx
    jmp .__ret_109
.__ret_109:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_lfind:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    lea rax, [rel __g_xwasm_xv_hash]
    push rax
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call xv_hash_of
    add rsp, 32
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    mov r13, rax
.L114:
    cmp r13, 0
    je .L115
    sub r13, 1
    lea rax, [rel __g_xwasm_xv_l_len]
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    cmp rax, r14
    jne .L117
    lea rax, [rel __g_xwasm_xv_names]
    push rax
    lea rax, [rel __g_xwasm_xv_l_off]
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L119:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L122
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L122
    mov rax, 1
    jmp .L123
.L122:
    mov rax, 0
.L123:
    test rax, rax
    jz .L120
    add rbx, 1
.L121:
    jmp .L119
.L120:
    cmp rbx, r14
    jl .L124
    mov rax, r13
    jmp .__ret_113
    jmp .L125
.L124:
.L125:
    jmp .L118
.L117:
.L118:
    lea rax, [rel __g_xwasm_xv_l_next]
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    mov r13, rax
.L116:
    jmp .L114
.L115:
    mov rax, 1
    neg rax
    jmp .__ret_113
.__ret_113:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_label_get:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call xv_lfind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L127
    mov rax, rbx
    jmp .__ret_126
    jmp .L128
.L127:
.L128:
    mov rax, [rel __g_xwasm_xv_l_n]
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_XW_MAXLBL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L131
    mov rax, [rel __g_xwasm_xv_names_n]
    add rax, r13
    push rax
    mov rax, [rel __g_xwasm_XW_NAMES]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L131
    mov rax, 0
    jmp .L132
.L131:
    mov rax, 1
.L132:
    test rax, rax
    jz .L129
section .data
.str133: db 116,111,111,32,109,97,110,121,32,108,97,98,101,108,115,32,111,114,32,102,117,110,99,116,105,111,110,115,0
section .text
    lea rax, [rel .str133]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_126
    jmp .L130
.L129:
.L130:
    lea rax, [rel __g_xwasm_xv_l_off]
    push rax
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_names_n]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_len]
    push rax
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call xv_p32
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L134:
    cmp rbx, r13
    jge .L135
    lea rax, [rel __g_xwasm_xv_names]
    push rax
    mov rax, [rel __g_xwasm_xv_names_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, rbx
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add rbx, 1
.L136:
    jmp .L134
.L135:
    mov rax, [rel __g_xwasm_xv_names_n]
    add rax, r13
    mov [rel __g_xwasm_xv_names_n], rax
    lea rax, [rel __g_xwasm_xv_l_kind]
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_tgt]
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_val]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p64
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_fn]
    push rax
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 1
    neg rax
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_blk]
    push rax
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 1
    neg rax
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call xv_hash_of
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_xwasm_xv_l_next]
    push rax
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    lea rax, [rel __g_xwasm_xv_hash]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_hash]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_l_n]
    add rax, 1
    mov [rel __g_xwasm_xv_l_n], rax
    mov rax, r12
    jmp .__ret_126
.__ret_126:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_qual:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov rcx, r15
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    je .L138
    mov rax, r15
    mov [rel __g_xwasm_xv_qn], rax
    mov rax, r14
    mov [rel __g_xwasm_xv_ql], rax
    mov rax, 0
    jmp .__ret_137
    jmp .L139
.L138:
.L139:
    lea rax, [rel __g_xwasm_xv_qbuf]
    mov r13, rax
    lea rax, [rel __g_xwasm_xv_glob]
    mov rbx, rax
    mov rax, 0
    mov r12, rax
.L140:
    mov rax, rbx
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L143
    mov rax, r12
    mov rcx, 250
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L143
    mov rax, 1
    jmp .L144
.L143:
    mov rax, 0
.L144:
    test rax, rax
    jz .L141
    mov rax, r13
    add rax, r12
    push rax
    mov rax, rbx
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add r12, 1
.L142:
    jmp .L140
.L141:
    mov rax, 0
    mov rbx, rax
.L145:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L148
    mov rax, r12
    mov rcx, 500
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L148
    mov rax, 1
    jmp .L149
.L148:
    mov rax, 0
.L149:
    test rax, rax
    jz .L146
    mov rax, r13
    add rax, r12
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add r12, 1
    add rbx, 1
.L147:
    jmp .L145
.L146:
    mov rax, r13
    mov [rel __g_xwasm_xv_qn], rax
    mov rax, r12
    mov [rel __g_xwasm_xv_ql], rax
    mov rax, 0
    jmp .__ret_137
.__ret_137:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_name_len:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
.L151:
    mov rax, 1
    test rax, rax
    jz .L152
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L166
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L166
    mov rax, 0
    jmp .L167
.L166:
    mov rax, 1
.L167:
    test rax, rax
    jnz .L164
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L164
    mov rax, 0
    jmp .L165
.L164:
    mov rax, 1
.L165:
    test rax, rax
    jnz .L162
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L162
    mov rax, 0
    jmp .L163
.L162:
    mov rax, 1
.L163:
    test rax, rax
    jnz .L160
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L160
    mov rax, 0
    jmp .L161
.L160:
    mov rax, 1
.L161:
    test rax, rax
    jnz .L158
    mov rax, rbx
    mov rcx, 93
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L158
    mov rax, 0
    jmp .L159
.L158:
    mov rax, 1
.L159:
    test rax, rax
    jnz .L156
    mov rax, rbx
    mov rcx, 58
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L156
    mov rax, 0
    jmp .L157
.L156:
    mov rax, 1
.L157:
    test rax, rax
    jz .L154
    mov rax, r12
    jmp .__ret_150
    jmp .L155
.L154:
.L155:
    add r12, 1
.L153:
    jmp .L151
.L152:
    mov rax, r12
    jmp .__ret_150
.__ret_150:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_label_ref:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, r13
    sub rsp, 32
    call xv_name_len
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call xv_qual
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_qn]
    push rax
    mov rax, [rel __g_xwasm_xv_ql]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_label_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov [rel __g_xwasm_xv_add], rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 43
    jne .L169
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov [rel __g_xwasm_xv_add], rax
    jmp .L170
.L169:
    mov rcx, rbx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 45
    jne .L171
    mov rax, 0
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_xwasm_xv_add], rax
    jmp .L172
.L171:
.L172:
.L170:
    mov rax, r12
    jmp .__ret_168
.__ret_168:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_lval:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    lea rax, [rel __g_xwasm_xv_l_kind]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L174
section .data
.str176: db 108,97,98,101,108,32,110,111,116,32,100,101,102,105,110,101,100,0
section .text
    lea rax, [rel .str176]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_173
    jmp .L175
.L174:
.L175:
    lea rax, [rel __g_xwasm_xv_l_val]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_LK_BSS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L177
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_xv_bss_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L178
.L177:
.L178:
    mov rax, rbx
    jmp .__ret_173
.__ret_173:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_ref_value:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xv_label_ref
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_xwasm_xv_add]
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xv_lval
    add rsp, 32
    add rax, rbx
    jmp .__ret_179
.__ret_179:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_translate:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r13, rcx
    mov r12, rdx
    mov r14, r8
    mov rbx, r9
    mov rax, r14
    mov [rel __g_xwasm_xv_out], rax
    mov rax, rbx
    mov [rel __g_xwasm_xv_out_cap], rax
    mov rax, [rel __g_xwasm_S_IN]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, [rel __g_xwasm_S_IN_END]
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, [rel __g_xwasm_S_ERR]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, [rel __g_xwasm_S_ERR_LINE]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, [rel __g_xwasm_S_ERR_INSN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, [rel __g_xwasm_S_ERR_MSG]
    push rax
section .data
.str181: db 110,111,32,87,101,98,65,115,115,101,109,98,108,121,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str181]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, 0
    mov [rel __g_xwasm_xv_l_n], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_names_n], rax
    mov rax, 1
    neg rax
    mov [rel __g_xwasm_xv_start_fn], rax
    mov rax, 0
    mov rbx, rax
.L182:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_XW_HASH]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L183
    lea rax, [rel __g_xwasm_xv_hash]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p32
    add rsp, 32
    add rbx, 1
.L184:
    jmp .L182
.L183:
    mov rax, 1
    mov rbx, rax
.L185:
    cmp rbx, 3
    jg .L186
    mov rax, rbx
    mov [rel __g_xwasm_xv_pass], rax
    mov rax, [rel __g_xwasm_S_IN]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, [rel __g_xwasm_S_IN_END]
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_set
    add rsp, 32
    sub rsp, 32
    call xv_run_pass
    add rsp, 32
    sub rsp, 32
    call xv_err
    add rsp, 32
    cmp rax, 0
    je .L188
    mov rax, 1
    neg rax
    jmp .__ret_180
    jmp .L189
.L188:
.L189:
    cmp rbx, 2
    jne .L190
    sub rsp, 32
    call xv_layout
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_nfn]
    mov [rel __g_xwasm_xv_nfn_total], rax
    mov rax, [rel __g_xwasm_xv_addr]
    mov [rel __g_xwasm_xv_addr_total], rax
    jmp .L191
.L190:
.L191:
    add rbx, 1
.L187:
    jmp .L185
.L186:
    sub rsp, 32
    call xv_module
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call xv_err
    add rsp, 32
    cmp rax, 0
    je .L192
    mov rax, 1
    neg rax
    jmp .__ret_180
    jmp .L193
.L192:
.L193:
    mov rax, rbx
    jmp .__ret_180
.__ret_180:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
xv_run_pass:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xwasm_S_LINE_NO]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, 0
    mov [rel __g_xwasm_xv_sec], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_addr], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_dsize], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_bsize], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_nfn], rax
    mov rax, [rel __g_xwasm_B_CODE]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_glob]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, 1
    neg rax
    mov [rel __g_xwasm_xv_fn], rax
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, [rel __g_xwasm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set
    add rsp, 32
.L195:
    mov rax, 1
    test rax, rax
    jz .L196
    sub rsp, 32
    call xv_err
    add rsp, 32
    cmp rax, 0
    je .L198
    mov rax, 0
    jmp .__ret_194
    jmp .L199
.L198:
.L199:
    sub rsp, 32
    call xl_read_line
    add rsp, 32
    cmp rax, 0
    jne .L200
    jmp .L196
    jmp .L201
.L200:
.L201:
    sub rsp, 32
    call xv_lib_skip
    add rsp, 32
    cmp rax, 0
    jne .L202
    sub rsp, 32
    call xl_native_skip
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L204
    sub rsp, 32
    call xv_line
    add rsp, 32
    jmp .L205
.L204:
    cmp rbx, 2
    jne .L206
    sub rsp, 32
    call xv_native_stub
    add rsp, 32
    jmp .L207
.L206:
.L207:
.L205:
    jmp .L203
.L202:
.L203:
.L197:
    jmp .L195
.L196:
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 3
    jne .L208
    sub rsp, 32
    call xv_fn_close
    add rsp, 32
    jmp .L209
.L208:
.L209:
    mov rax, 0
    jmp .__ret_194
.__ret_194:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_lib_skip:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xwasm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str213: db 95,95,108,105,98,95,101,110,116,101,114,58,0
section .text
    lea rax, [rel .str213]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L211
section .data
.str214: db 95,95,108,105,98,95,101,110,116,101,114,58,10,114,101,116,10,0
section .text
    lea rax, [rel .str214]
    push rax
    pop rcx
    sub rsp, 32
    call xv_feed
    add rsp, 32
    mov rax, [rel __g_xwasm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, 1
    jmp .__ret_210
    jmp .L212
.L211:
.L212:
    mov rax, rbx
    push rax
section .data
.str217: db 95,95,108,105,98,95,114,101,97,100,121,58,0
section .text
    lea rax, [rel .str217]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L215
section .data
.str218: db 95,95,108,105,98,95,114,101,97,100,121,58,10,114,101,116,10,0
section .text
    lea rax, [rel .str218]
    push rax
    pop rcx
    sub rsp, 32
    call xv_feed
    add rsp, 32
    mov rax, [rel __g_xwasm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, 1
    jmp .__ret_210
    jmp .L216
.L215:
.L216:
    mov rax, 0
    jmp .__ret_210
.__ret_210:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_feed:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rax, rbx
    mov r14, rax
    mov rax, [rel __g_xwasm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    mov r13, rax
.L220:
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 0
    je .L221
    mov rax, 0
    mov r12, rax
.L223:
    mov rax, 1
    test rax, rax
    jz .L224
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    add r14, 1
    cmp rbx, 10
    jne .L226
    jmp .L224
    jmp .L227
.L226:
.L227:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add r12, 1
.L225:
    jmp .L223
.L224:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    sub rsp, 32
    call xv_line
    add rsp, 32
.L222:
    jmp .L220
.L221:
    mov rax, 0
    jmp .__ret_219
.__ret_219:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_native_stub:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xwasm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str231: db 95,95,99,99,97,108,108,58,0
section .text
    lea rax, [rel .str231]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L229
section .data
.str232: db 95,95,99,99,97,108,108,58,10,109,111,118,32,114,99,120,44,32,114,49,49,10,99,97,108,108,32,95,95,101,120,116,95,114,101,115,111,108,118,101,10,120,111,114,32,101,97,120,44,32,101,97,120,10,120,111,114,112,115,32,120,109,109,48
    db 44,32,120,109,109,48,10,114,101,116,10,0
section .text
    lea rax, [rel .str232]
    push rax
    pop rcx
    sub rsp, 32
    call xv_feed
    add rsp, 32
    jmp .__ret_228
    jmp .L230
.L229:
.L230:
    mov rax, rbx
    push rax
section .data
.str235: db 95,95,99,101,110,116,114,121,58,0
section .text
    lea rax, [rel .str235]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L233
section .data
.str236: db 95,95,99,101,110,116,114,121,58,10,114,101,116,10,0
section .text
    lea rax, [rel .str236]
    push rax
    pop rcx
    sub rsp, 32
    call xv_feed
    add rsp, 32
    jmp .__ret_228
    jmp .L234
.L233:
.L234:
section .data
.str237: db 95,95,112,116,95,101,110,116,114,121,58,10,114,101,116,10,0
section .text
    lea rax, [rel .str237]
    push rax
    pop rcx
    sub rsp, 32
    call xv_feed
    add rsp, 32
    jmp .__ret_228
.__ret_228:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_layout:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xwasm_xv_dsize]
    add rax, 16
    mov [rel __g_xwasm_xv_dsize], rax
    mov rax, [rel __g_xwasm_XW_DATA_BASE]
    push rax
    mov rax, [rel __g_xwasm_xv_dsize]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 15
    push rax
    mov rax, 16
    neg rax
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
    mov rax, rbx
    mov [rel __g_xwasm_xv_bss_base], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_xv_bsize]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 65535
    push rax
    mov rax, 65536
    neg rax
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_XW_STACK]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_xwasm_xv_heap_base], rax
    mov rax, 0
    jmp .__ret_238
.__ret_238:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_line:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rax, [rel __g_xwasm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r15, rax
    mov rcx, r15
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 0
    jne .L240
    mov rax, 0
    jmp .__ret_239
    jmp .L241
.L240:
.L241:
    mov rax, r15
    mov r14, rax
.L242:
    mov rax, 1
    test rax, rax
    jz .L243
    mov rax, r15
    mov r14, rax
    mov rcx, r15
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
.L245:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L250
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L250
    mov rax, 1
    jmp .L251
.L250:
    mov rax, 0
.L251:
    test rax, rax
    jz .L248
    mov rax, rbx
    mov rcx, 58
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L248
    mov rax, 1
    jmp .L249
.L248:
    mov rax, 0
.L249:
    test rax, rax
    jz .L246
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
.L247:
    jmp .L245
.L246:
    cmp rbx, 58
    je .L252
    jmp .L243
    jmp .L253
.L252:
.L253:
    mov rax, r14
    push rax
    mov rax, r15
    sub rax, r14
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_label
    add rsp, 32
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r15, rax
    mov rcx, r15
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 0
    jne .L254
    mov rax, 0
    jmp .__ret_239
    jmp .L255
.L254:
.L255:
.L244:
    jmp .L242
.L243:
    mov rax, r15
    sub rax, r14
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 30
    jle .L256
    mov rax, 30
    mov [rbp-32], rax
    jmp .L257
.L256:
.L257:
    mov rax, [rel __g_xwasm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L258:
    mov rax, r12
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L259
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L263
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L263
    mov rax, 1
    jmp .L264
.L263:
    mov rax, 0
.L264:
    test rax, rax
    jz .L261
    add rbx, 32
    jmp .L262
.L261:
.L262:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add r12, 1
.L260:
    jmp .L258
.L259:
    mov rax, r13
    mov rcx, [rbp-32]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xwasm_S_REST]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_set
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str273: db 100,101,102,97,117,108,116,0
section .text
    lea rax, [rel .str273]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L271
    mov rax, r13
    push rax
section .data
.str274: db 98,105,116,115,0
section .text
    lea rax, [rel .str274]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L271
    mov rax, 0
    jmp .L272
.L271:
    mov rax, 1
.L272:
    test rax, rax
    jnz .L269
    mov rax, r13
    push rax
section .data
.str275: db 101,120,116,101,114,110,0
section .text
    lea rax, [rel .str275]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L269
    mov rax, 0
    jmp .L270
.L269:
    mov rax, 1
.L270:
    test rax, rax
    jnz .L267
    mov rax, r13
    push rax
section .data
.str276: db 103,108,111,98,97,108,0
section .text
    lea rax, [rel .str276]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L267
    mov rax, 0
    jmp .L268
.L267:
    mov rax, 1
.L268:
    test rax, rax
    jz .L265
    mov rax, 0
    jmp .__ret_239
    jmp .L266
.L265:
.L266:
    mov rax, r13
    push rax
section .data
.str279: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str279]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L277
    mov rax, 0
    mov [rel __g_xwasm_xv_sec], rax
    mov rax, rbx
    push rax
section .data
.str282: db 46,100,97,116,97,0
section .text
    lea rax, [rel .str282]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L280
    mov rax, 1
    mov [rel __g_xwasm_xv_sec], rax
    jmp .L281
.L280:
    mov rax, rbx
    push rax
section .data
.str285: db 46,98,115,115,0
section .text
    lea rax, [rel .str285]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L283
    mov rax, 2
    mov [rel __g_xwasm_xv_sec], rax
    jmp .L284
.L283:
.L284:
.L281:
    mov rax, 0
    jmp .__ret_239
    jmp .L278
.L277:
.L278:
    mov rax, r13
    push rax
section .data
.str288: db 100,98,0
section .text
    lea rax, [rel .str288]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L286
    mov rcx, 1
    sub rsp, 32
    call xv_items
    add rsp, 32
    jmp .__ret_239
    jmp .L287
.L286:
.L287:
    mov rax, r13
    push rax
section .data
.str291: db 100,119,0
section .text
    lea rax, [rel .str291]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L289
    mov rcx, 2
    sub rsp, 32
    call xv_items
    add rsp, 32
    jmp .__ret_239
    jmp .L290
.L289:
.L290:
    mov rax, r13
    push rax
section .data
.str294: db 100,100,0
section .text
    lea rax, [rel .str294]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L292
    mov rcx, 4
    sub rsp, 32
    call xv_items
    add rsp, 32
    jmp .__ret_239
    jmp .L293
.L292:
.L293:
    mov rax, r13
    push rax
section .data
.str297: db 100,113,0
section .text
    lea rax, [rel .str297]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L295
    mov rcx, 8
    sub rsp, 32
    call xv_items
    add rsp, 32
    jmp .__ret_239
    jmp .L296
.L295:
.L296:
    mov rax, r13
    push rax
section .data
.str300: db 114,101,115,98,0
section .text
    lea rax, [rel .str300]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L298
    mov rcx, 1
    sub rsp, 32
    call xv_res
    add rsp, 32
    jmp .__ret_239
    jmp .L299
.L298:
.L299:
    mov rax, r13
    push rax
section .data
.str303: db 114,101,115,119,0
section .text
    lea rax, [rel .str303]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L301
    mov rcx, 2
    sub rsp, 32
    call xv_res
    add rsp, 32
    jmp .__ret_239
    jmp .L302
.L301:
.L302:
    mov rax, r13
    push rax
section .data
.str306: db 114,101,115,100,0
section .text
    lea rax, [rel .str306]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L304
    mov rcx, 4
    sub rsp, 32
    call xv_res
    add rsp, 32
    jmp .__ret_239
    jmp .L305
.L304:
.L305:
    mov rax, r13
    push rax
section .data
.str309: db 114,101,115,113,0
section .text
    lea rax, [rel .str309]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L307
    mov rcx, 8
    sub rsp, 32
    call xv_res
    add rsp, 32
    jmp .__ret_239
    jmp .L308
.L307:
.L308:
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 0
    je .L310
    mov rax, 0
    jmp .__ret_239
    jmp .L311
.L310:
.L311:
    sub rsp, 32
    call xl_split
    add rsp, 32
    sub rsp, 32
    call xl_parse_ops
    add rsp, 32
    sub rsp, 32
    call xv_err
    add rsp, 32
    cmp rax, 0
    je .L312
    mov rax, 0
    jmp .__ret_239
    jmp .L313
.L312:
.L313:
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 1
    jne .L314
    sub rsp, 32
    call xv_targets
    add rsp, 32
    jmp .L315
.L314:
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 2
    jne .L316
    sub rsp, 32
    call xv_regscan
    add rsp, 32
    jmp .L317
.L316:
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 3
    jne .L318
    sub rsp, 32
    call xv_insn
    add rsp, 32
    jmp .L319
.L318:
.L319:
.L317:
.L315:
    mov rax, [rel __g_xwasm_xv_addr]
    add rax, 1
    mov [rel __g_xwasm_xv_addr], rax
    mov rax, 0
    jmp .__ret_239
.__ret_239:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
xv_res:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, [rel __g_xwasm_S_REST]
    push rax
    pop rcx
    sub rsp, 32
    call xv_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call xl_last_ok
    add rsp, 32
    cmp rax, 0
    jne .L321
section .data
.str323: db 100,97,116,97,32,100,105,114,101,99,116,105,118,101,32,110,111,116,32,117,110,100,101,114,115,116,111,111,100,0
section .text
    lea rax, [rel .str323]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_320
    jmp .L322
.L321:
.L322:
    mov rax, rbx
    imul rax, r12
    mov rbx, rax
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 2
    jne .L324
    mov rax, [rel __g_xwasm_xv_bsize]
    add rax, rbx
    mov [rel __g_xwasm_xv_bsize], rax
    jmp .L325
.L324:
    mov rax, [rel __g_xwasm_xv_dsize]
    add rax, rbx
    mov [rel __g_xwasm_xv_dsize], rax
.L325:
    mov rax, 0
    jmp .__ret_320
.__ret_320:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_label:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    je .L327
    lea rax, [rel __g_xwasm_xv_glob]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L329:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L332
    mov rax, rbx
    mov rcx, 250
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L332
    mov rax, 1
    jmp .L333
.L332:
    mov rax, 0
.L333:
    test rax, rax
    jz .L330
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add rbx, 1
.L331:
    jmp .L329
.L330:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    jmp .L328
.L327:
.L328:
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call xv_qual
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_qn]
    push rax
    mov rax, [rel __g_xwasm_xv_ql]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_label_get
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 2
    jne .L334
    mov rcx, rbx
    mov rdx, r14
    mov r8, r13
    sub rsp, 32
    call xv_define
    add rsp, 32
    jmp .__ret_326
    jmp .L335
.L334:
.L335:
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 3
    je .L336
    mov rax, 0
    jmp .__ret_326
    jmp .L337
.L336:
.L337:
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 0
    je .L338
    mov rax, 0
    jmp .__ret_326
    jmp .L339
.L338:
.L339:
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    je .L340
    sub rsp, 32
    call xv_fn_close
    add rsp, 32
    sub rsp, 32
    call xv_fn_open
    add rsp, 32
    mov rax, 0
    jmp .__ret_326
    jmp .L341
.L340:
.L341:
    lea rax, [rel __g_xwasm_xv_l_blk]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_s32
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jge .L342
    mov rax, 0
    jmp .__ret_326
    jmp .L343
.L342:
.L343:
    mov rax, rbx
    mov [rel __g_xwasm_xv_blk], rax
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_term], rax
    mov rax, 0
    jmp .__ret_326
.__ret_326:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_define:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 1
    jne .L345
    lea rax, [rel __g_xwasm_xv_l_kind]
    add rax, r14
    push rax
    mov rax, [rel __g_xwasm_LK_DATA]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_val]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_dsize]
    push rax
    mov rax, [rel __g_xwasm_XW_DATA_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_344
    jmp .L346
.L345:
.L346:
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 2
    jne .L347
    lea rax, [rel __g_xwasm_xv_l_kind]
    add rax, r14
    push rax
    mov rax, [rel __g_xwasm_LK_BSS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_val]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_bsize]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_344
    jmp .L348
.L347:
.L348:
    lea rax, [rel __g_xwasm_xv_l_kind]
    add rax, r14
    push rax
    mov rax, [rel __g_xwasm_LK_CODE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_val]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_addr]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p64
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    jne .L349
    mov rax, [rel __g_xwasm_xv_fn]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L351
    mov rax, 0
    jmp .__ret_344
    jmp .L352
.L351:
.L352:
    lea rax, [rel __g_xwasm_xv_l_fn]
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_tgt]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 0
    jne .L353
    mov rax, 0
    jmp .__ret_344
    jmp .L354
.L353:
.L354:
    lea rax, [rel __g_xwasm_xv_f_nblk]
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_xwasm_xv_l_blk]
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_nblk]
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    mov rax, 0
    jmp .__ret_344
    jmp .L350
.L349:
.L350:
    mov rax, [rel __g_xwasm_xv_nfn]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_XW_MAXFN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L355
section .data
.str357: db 116,111,111,32,109,97,110,121,32,108,97,98,101,108,115,32,111,114,32,102,117,110,99,116,105,111,110,115,0
section .text
    lea rax, [rel .str357]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_344
    jmp .L356
.L355:
.L356:
    mov rax, rbx
    mov [rel __g_xwasm_xv_fn], rax
    lea rax, [rel __g_xwasm_xv_f_addr]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_addr]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p64
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_nblk]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_regs]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 23
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_fn]
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_l_blk]
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p32
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_nfn]
    add rax, 1
    mov [rel __g_xwasm_xv_nfn], rax
    mov rax, r12
    mov rcx, 6
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L360
    mov rax, r13
    push rax
section .data
.str362: db 95,115,116,97,114,116,0
section .text
    lea rax, [rel .str362]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L360
    mov rax, 1
    jmp .L361
.L360:
    mov rax, 0
.L361:
    test rax, rax
    jz .L358
    mov rax, rbx
    mov [rel __g_xwasm_xv_start_fn], rax
    jmp .L359
.L358:
.L359:
    mov rax, 0
    jmp .__ret_344
.__ret_344:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_targets:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rax, [rel __g_xwasm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 106
    je .L364
    mov rax, 0
    jmp .__ret_363
    jmp .L365
.L364:
.L365:
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L366
    mov rax, 0
    jmp .__ret_363
    jmp .L367
.L366:
.L367:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    je .L368
    mov rax, 0
    jmp .__ret_363
    jmp .L369
.L368:
.L369:
    mov rax, rbx
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xv_name_len
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_qual
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_qn]
    push rax
    mov rax, [rel __g_xwasm_xv_ql]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_label_get
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_xwasm_xv_l_tgt]
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_363
.__ret_363:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_regscan:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rax, [rel __g_xwasm_xv_fn]
    mov r15, rax
    mov rax, r15
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L371
    mov rax, 0
    jmp .__ret_370
    jmp .L372
.L371:
.L372:
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L373:
    cmp r13, 3
    jge .L374
    mov rcx, r13
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L376
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    and rax, 15
    mov rcx, rax
    pop rax
    shl rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L377
.L376:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L378
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_XMM]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    and rax, 15
    add rax, 16
    mov rcx, rax
    pop rax
    shl rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L379
.L378:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L380
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 16
    jge .L382
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    shl rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L383
.L382:
.L383:
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 16
    jge .L384
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    shl rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L385
.L384:
.L385:
    jmp .L381
.L380:
.L381:
.L379:
.L377:
    add r13, 1
.L375:
    jmp .L373
.L374:
    mov rax, [rel __g_xwasm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    push rax
section .data
.str388: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str388]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L386
    or r14, 65535
    jmp .L387
.L386:
.L387:
    lea rax, [rel __g_xwasm_xv_f_regs]
    push rax
    mov rax, r15
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    or rax, r14
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p32
    add rsp, 32
    mov rax, 0
    jmp .__ret_370
.__ret_370:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_fn_open:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xwasm_xv_nfn]
    mov [rel __g_xwasm_xv_fn], rax
    mov rax, [rel __g_xwasm_xv_nfn]
    add rax, 1
    mov [rel __g_xwasm_xv_nfn], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_body_n], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_blk], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_term], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_iff], rax
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rcx, 5
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 127
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 6
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 126
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 126
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 123
    sub rsp, 32
    call xv_wb
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_regs]
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    mov [rel __g_xwasm_xv_regs], rax
    mov rax, 1
    mov [rel __g_xwasm_xv_lmode], rax
    sub rsp, 32
    call xv_sync_in
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_nblk]
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    mov r12, rax
    cmp r12, 2
    jge .L390
    mov rax, 0
    jmp .__ret_389
    jmp .L391
.L390:
.L391:
    mov rcx, 3
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 64
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L392:
    cmp rbx, r12
    jge .L393
    mov rcx, 2
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 64
    sub rsp, 32
    call xv_wb
    add rsp, 32
    add rbx, 1
.L394:
    jmp .L392
.L393:
    mov rax, [rel __g_xwasm_L_PC]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 14
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L395:
    cmp rbx, r12
    jge .L396
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    add rbx, 1
.L397:
    jmp .L395
.L396:
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, 0
    jmp .__ret_389
.__ret_389:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_fn_close:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, [rel __g_xwasm_xv_fn]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L399
    mov rax, 0
    jmp .__ret_398
    jmp .L400
.L399:
.L400:
    mov rax, [rel __g_xwasm_xv_term]
    cmp rax, 0
    jne .L401
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, [rel __g_xwasm_xv_nfn_total]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L403
    sub rsp, 32
    call xv_sync_out
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, rbx
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 15
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L404
.L403:
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
.L404:
    jmp .L402
.L401:
.L402:
    lea rax, [rel __g_xwasm_xv_f_nblk]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    cmp rax, 2
    jl .L405
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L406
.L405:
.L406:
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_B_CODE]
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obuleb
    add rsp, 32
    mov rax, [rel __g_xwasm_B_CODE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_XW_CODE_MAX]
    sub rax, 64
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L407
section .data
.str409: db 111,117,116,112,117,116,32,98,117,102,102,101,114,32,102,117,108,108,0
section .text
    lea rax, [rel .str409]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_398
    jmp .L408
.L407:
.L408:
    mov rax, 0
    mov rbx, rax
.L410:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L411
    lea rax, [rel __g_xwasm_xv_code]
    add rax, r12
    add rax, rbx
    push rax
    lea rax, [rel __g_xwasm_xv_body]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add rbx, 1
.L412:
    jmp .L410
.L411:
    mov rax, [rel __g_xwasm_B_CODE]
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    mov rax, 1
    neg rax
    mov [rel __g_xwasm_xv_fn], rax
    mov rax, 0
    mov [rel __g_xwasm_xv_lmode], rax
    mov rax, 0
    jmp .__ret_398
.__ret_398:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_items:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov r15, rcx
    mov rax, [rel __g_xwasm_S_REST]
    push rax
    pop rcx
    sub rsp, 32
    call xv_get
    add rsp, 32
    mov r14, rax
    lea rax, [rel __g_xwasm_xv_tok]
    mov r13, rax
.L414:
    mov rax, 1
    test rax, rax
    jz .L415
    mov rcx, r14
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L417
    mov rax, 0
    jmp .__ret_413
    jmp .L418
.L417:
.L418:
    cmp rbx, 44
    jne .L419
    add r14, 1
    jmp .L420
.L419:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L423
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L423
    mov rax, 0
    jmp .L424
.L423:
    mov rax, 1
.L424:
    test rax, rax
    jz .L421
    mov rax, rbx
    mov [rbp-40], rax
    add r14, 1
    mov rax, 1
    mov r12, rax
.L425:
    cmp r12, 1
    jne .L426
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L428
    mov rax, 0
    jmp .__ret_413
    jmp .L429
.L428:
.L429:
    add r14, 1
    mov rax, rbx
    mov rcx, [rbp-40]
    cmp rax, rcx
    jne .L430
    mov rax, 0
    mov r12, rax
    jmp .L431
.L430:
    mov rcx, rbx
    mov rdx, r15
    sub rsp, 32
    call xv_put_value
    add rsp, 32
.L431:
.L427:
    jmp .L425
.L426:
    jmp .L422
.L421:
    mov rax, 0
    mov rbx, rax
.L432:
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L435
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L435
    mov rax, 1
    jmp .L436
.L435:
    mov rax, 0
.L436:
    test rax, rax
    jz .L433
    cmp rbx, 60
    jge .L437
    mov rax, r13
    add rax, rbx
    push rax
    mov rcx, r14
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add rbx, 1
    jmp .L438
.L437:
.L438:
    add r14, 1
.L434:
    jmp .L432
.L433:
.L439:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L442
    mov rax, r13
    add rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L442
    mov rax, 1
    jmp .L443
.L442:
    mov rax, 0
.L443:
    test rax, rax
    jz .L440
    sub rbx, 1
.L441:
    jmp .L439
.L440:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L446
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L448
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L450
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L450
    mov rax, 1
    jmp .L451
.L450:
    mov rax, 0
.L451:
    test rax, rax
    jnz .L448
    mov rax, 0
    jmp .L449
.L448:
    mov rax, 1
.L449:
    test rax, rax
    jz .L446
    mov rax, 1
    jmp .L447
.L446:
    mov rax, 0
.L447:
    test rax, rax
    jz .L444
    mov rax, 0
    mov rbx, rax
.L452:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 0
    je .L453
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    jne .L455
    mov rax, 1
    mov r12, rax
    jmp .L456
.L455:
.L456:
    add rbx, 1
.L454:
    jmp .L452
.L453:
    jmp .L445
.L444:
.L445:
    cmp r12, 0
    je .L457
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
    call cg_float_bits
    add rsp, 32
    mov rbx, rax
    jmp .L458
.L457:
    mov rcx, r13
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call xl_last_ok
    add rsp, 32
    cmp rax, 0
    jne .L459
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 3
    jne .L461
    mov rcx, r13
    sub rsp, 32
    call xv_ref_value
    add rsp, 32
    mov rbx, rax
    jmp .L462
.L461:
.L462:
    jmp .L460
.L459:
.L460:
.L458:
    mov rcx, rbx
    mov rdx, r15
    sub rsp, 32
    call xv_put_value
    add rsp, 32
.L422:
.L420:
.L416:
    jmp .L414
.L415:
    mov rax, 0
    jmp .__ret_413
.__ret_413:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
xv_put_value:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 2
    jne .L464
    mov rax, [rel __g_xwasm_xv_bsize]
    add rax, r14
    mov [rel __g_xwasm_xv_bsize], rax
    mov rax, 0
    jmp .__ret_463
    jmp .L465
.L464:
.L465:
    mov rax, [rel __g_xwasm_xv_sec]
    cmp rax, 1
    je .L466
    mov rax, 0
    jmp .__ret_463
    jmp .L467
.L466:
.L467:
    mov rax, [rel __g_xwasm_xv_dsize]
    mov r13, rax
    mov rax, [rel __g_xwasm_xv_pass]
    cmp rax, 3
    jne .L468
    mov rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L470:
    cmp rbx, r14
    jge .L471
    lea rax, [rel __g_xwasm_xv_data]
    add rax, r13
    add rax, rbx
    push rax
    mov rax, r12
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, r12
    shr rax, 8
    mov r12, rax
    add rbx, 1
.L472:
    jmp .L470
.L471:
    jmp .L469
.L468:
.L469:
    add r13, r14
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_XW_DATA_MAX]
    sub rax, 64
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L473
section .data
.str475: db 111,117,116,112,117,116,32,98,117,102,102,101,114,32,102,117,108,108,0
section .text
    lea rax, [rel .str475]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_463
    jmp .L474
.L473:
.L474:
    mov rax, r13
    mov [rel __g_xwasm_xv_dsize], rax
    mov rax, 0
    jmp .__ret_463
.__ret_463:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_ld_op:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    cmp r12, 8
    jne .L477
    mov rax, 41
    jmp .__ret_476
    jmp .L478
.L477:
.L478:
    cmp rbx, 0
    jne .L479
    cmp r12, 4
    jne .L481
    mov rax, 53
    jmp .__ret_476
    jmp .L482
.L481:
.L482:
    cmp r12, 2
    jne .L483
    mov rax, 51
    jmp .__ret_476
    jmp .L484
.L483:
.L484:
    mov rax, 49
    jmp .__ret_476
    jmp .L480
.L479:
.L480:
    cmp r12, 4
    jne .L485
    mov rax, 52
    jmp .__ret_476
    jmp .L486
.L485:
.L486:
    cmp r12, 2
    jne .L487
    mov rax, 50
    jmp .__ret_476
    jmp .L488
.L487:
.L488:
    mov rax, 48
    jmp .__ret_476
.__ret_476:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_store:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 8
    jne .L490
    mov rcx, 55
    sub rsp, 32
    call xv_mem
    add rsp, 32
    jmp .__ret_489
    jmp .L491
.L490:
.L491:
    cmp rbx, 4
    jne .L492
    mov rcx, 62
    sub rsp, 32
    call xv_mem
    add rsp, 32
    jmp .__ret_489
    jmp .L493
.L492:
.L493:
    cmp rbx, 2
    jne .L494
    mov rcx, 61
    sub rsp, 32
    call xv_mem
    add rsp, 32
    jmp .__ret_489
    jmp .L495
.L494:
.L495:
    mov rcx, 60
    sub rsp, 32
    call xv_mem
    add rsp, 32
    jmp .__ret_489
.__ret_489:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_mask:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    cmp r12, 8
    jl .L497
    mov rax, 0
    jmp .__ret_496
    jmp .L498
.L497:
.L498:
    mov rax, 4294967295
    mov rbx, rax
    cmp r12, 1
    jne .L499
    mov rax, 255
    mov rbx, rax
    jmp .L500
.L499:
    cmp r12, 2
    jne .L501
    mov rax, 65535
    mov rbx, rax
    jmp .L502
.L501:
.L502:
.L500:
    mov rcx, rbx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 131
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_496
.__ret_496:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_addr64:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov r13, rcx
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_REL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L504
    mov rcx, rbx
    sub rsp, 32
    call xv_ref_value
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call xv_val
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    jmp .__ret_503
    jmp .L505
.L504:
.L505:
    mov rax, 0
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 255
    je .L506
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rax, 1
    mov r12, rax
    jmp .L507
.L506:
.L507:
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 255
    je .L508
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_SCALE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jle .L510
    mov rcx, rbx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 126
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L511
.L510:
.L511:
    cmp r12, 0
    je .L512
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L513
.L512:
.L513:
    mov rax, 1
    mov r12, rax
    jmp .L509
.L508:
.L509:
    mov rcx, r13
    sub rsp, 32
    call xv_val
    add rsp, 32
    mov rbx, rax
    cmp r12, 0
    jne .L514
    mov rcx, rbx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    jmp .__ret_503
    jmp .L515
.L514:
.L515:
    cmp rbx, 0
    je .L516
    mov rcx, rbx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L517
.L516:
.L517:
    mov rax, 0
    jmp .__ret_503
.__ret_503:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_addr32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_REL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L519
    mov rcx, rbx
    sub rsp, 32
    call xv_ref_value
    add rsp, 32
    push rax
    mov rcx, r12
    sub rsp, 32
    call xv_val
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    jmp .__ret_518
    jmp .L520
.L519:
.L520:
    mov rcx, r12
    sub rsp, 32
    call xv_addr64
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_518
.__ret_518:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_rd:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rcx, r14
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L522
    mov rcx, r14
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_gget
    add rsp, 32
    cmp r12, 0
    jne .L524
    mov rcx, r13
    sub rsp, 32
    call xv_mask
    add rsp, 32
    jmp .__ret_521
    jmp .L525
.L524:
.L525:
    cmp r13, 8
    jge .L526
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 64
    sub rax, rcx
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 134
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 135
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L527
.L526:
.L527:
    mov rax, 0
    jmp .__ret_521
    jmp .L523
.L522:
.L523:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L528
    mov rcx, r14
    sub rsp, 32
    call xv_val
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    jmp .__ret_521
    jmp .L529
.L528:
.L529:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L530
    mov rcx, r14
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call xv_ld_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_mem
    add rsp, 32
    jmp .__ret_521
    jmp .L531
.L530:
.L531:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L532
    mov rax, r14
    push rax
    mov rax, [rel __g_xwasm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_ref_value
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    jmp .__ret_521
    jmp .L533
.L532:
.L533:
section .data
.str534: db 111,112,101,114,97,110,100,32,87,101,98,65,115,115,101,109,98,108,121,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str534]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_521
.__ret_521:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_wreg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    cmp rbx, 4
    jl .L536
    mov rcx, rbx
    sub rsp, 32
    call xv_mask
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_gset
    add rsp, 32
    jmp .__ret_535
    jmp .L537
.L536:
.L537:
    mov rcx, rbx
    sub rsp, 32
    call xv_mask
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T2]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_gget
    add rsp, 32
    cmp rbx, 1
    jne .L538
    mov rax, 256
    neg rax
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    jmp .L539
.L538:
    mov rax, 65536
    neg rax
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
.L539:
    mov rcx, 131
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T2]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 132
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_gset
    add rsp, 32
    jmp .__ret_535
.__ret_535:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_opsize:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L541
    mov rcx, rbx
    sub rsp, 32
    call xv_rs
    add rsp, 32
    jmp .__ret_540
    jmp .L542
.L541:
.L542:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L543
    mov rax, rbx
    jmp .__ret_540
    jmp .L544
.L543:
.L544:
    mov rax, r12
    jmp .__ret_540
.__ret_540:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_push_t0:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 125
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T1]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ltee
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T1]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 55
    sub rsp, 32
    call xv_mem
    add rsp, 32
    jmp .__ret_545
.__ret_545:
    mov rsp, rbp
    pop rbp
    ret
xv_push_ret:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xwasm_xv_addr]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    sub rsp, 32
    call xv_push_t0
    add rsp, 32
    jmp .__ret_546
.__ret_546:
    mov rsp, rbp
    pop rbp
    ret
xv_bad:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str548: db 110,111,32,87,101,98,65,115,115,101,109,98,108,121,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str548]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_547
.__ret_547:
    mov rsp, rbp
    pop rbp
    ret
xv_badop:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str550: db 111,112,101,114,97,110,100,32,87,101,98,65,115,115,101,109,98,108,121,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str550]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_549
.__ret_549:
    mov rsp, rbp
    pop rbp
    ret
xv_insn:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov [rel __g_xwasm_xv_term], rax
    mov rax, [rel __g_xwasm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str554: db 109,111,118,0
section .text
    lea rax, [rel .str554]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L552
    sub rsp, 32
    call xv_i_mov
    add rsp, 32
    jmp .__ret_551
    jmp .L553
.L552:
.L553:
    mov rax, rbx
    push rax
section .data
.str557: db 112,117,115,104,0
section .text
    lea rax, [rel .str557]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L555
    sub rsp, 32
    call xv_i_push
    add rsp, 32
    jmp .__ret_551
    jmp .L556
.L555:
.L556:
    mov rax, rbx
    push rax
section .data
.str560: db 112,111,112,0
section .text
    lea rax, [rel .str560]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L558
    sub rsp, 32
    call xv_i_pop
    add rsp, 32
    jmp .__ret_551
    jmp .L559
.L558:
.L559:
    mov rax, rbx
    push rax
section .data
.str563: db 97,100,100,0
section .text
    lea rax, [rel .str563]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L561
    mov rax, 124
    push rax
    mov rax, [rel __g_xwasm_FK_ADD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_arith
    add rsp, 32
    jmp .__ret_551
    jmp .L562
.L561:
.L562:
    mov rax, rbx
    push rax
section .data
.str566: db 115,117,98,0
section .text
    lea rax, [rel .str566]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L564
    mov rax, 125
    push rax
    mov rax, [rel __g_xwasm_FK_SUB]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_arith
    add rsp, 32
    jmp .__ret_551
    jmp .L565
.L564:
.L565:
    mov rax, rbx
    push rax
section .data
.str569: db 99,109,112,0
section .text
    lea rax, [rel .str569]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L567
    sub rsp, 32
    call xv_i_cmp
    add rsp, 32
    jmp .__ret_551
    jmp .L568
.L567:
.L568:
    mov rax, rbx
    push rax
section .data
.str572: db 106,109,112,0
section .text
    lea rax, [rel .str572]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L570
    sub rsp, 32
    call xv_i_jmp
    add rsp, 32
    jmp .__ret_551
    jmp .L571
.L570:
.L571:
    mov rax, rbx
    push rax
section .data
.str575: db 99,97,108,108,0
section .text
    lea rax, [rel .str575]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L573
    sub rsp, 32
    call xv_i_call
    add rsp, 32
    jmp .__ret_551
    jmp .L574
.L573:
.L574:
    mov rax, rbx
    push rax
section .data
.str578: db 108,101,97,0
section .text
    lea rax, [rel .str578]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L576
    sub rsp, 32
    call xv_i_lea
    add rsp, 32
    jmp .__ret_551
    jmp .L577
.L576:
.L577:
    mov rax, rbx
    push rax
section .data
.str581: db 116,101,115,116,0
section .text
    lea rax, [rel .str581]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L579
    sub rsp, 32
    call xv_i_test
    add rsp, 32
    jmp .__ret_551
    jmp .L580
.L579:
.L580:
    mov rax, rbx
    push rax
section .data
.str584: db 114,101,116,0
section .text
    lea rax, [rel .str584]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L582
    sub rsp, 32
    call xv_i_ret
    add rsp, 32
    jmp .__ret_551
    jmp .L583
.L582:
.L583:
    mov rax, rbx
    push rax
section .data
.str587: db 120,111,114,0
section .text
    lea rax, [rel .str587]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L585
    mov rax, 133
    push rax
    mov rax, [rel __g_xwasm_FK_RES]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_arith
    add rsp, 32
    jmp .__ret_551
    jmp .L586
.L585:
.L586:
    mov rax, rbx
    push rax
section .data
.str590: db 97,110,100,0
section .text
    lea rax, [rel .str590]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L588
    mov rax, 131
    push rax
    mov rax, [rel __g_xwasm_FK_RES]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_arith
    add rsp, 32
    jmp .__ret_551
    jmp .L589
.L588:
.L589:
    mov rax, rbx
    push rax
section .data
.str593: db 111,114,0
section .text
    lea rax, [rel .str593]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L591
    mov rax, 132
    push rax
    mov rax, [rel __g_xwasm_FK_RES]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_arith
    add rsp, 32
    jmp .__ret_551
    jmp .L592
.L591:
.L592:
    mov rax, rbx
    push rax
section .data
.str596: db 109,111,118,122,120,0
section .text
    lea rax, [rel .str596]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L594
    mov rcx, 0
    sub rsp, 32
    call xv_mov_ext
    add rsp, 32
    jmp .__ret_551
    jmp .L595
.L594:
.L595:
    mov rax, rbx
    push rax
section .data
.str599: db 109,111,118,115,120,0
section .text
    lea rax, [rel .str599]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L597
    mov rcx, 1
    sub rsp, 32
    call xv_mov_ext
    add rsp, 32
    jmp .__ret_551
    jmp .L598
.L597:
.L598:
    mov rax, rbx
    push rax
section .data
.str602: db 109,111,118,115,120,100,0
section .text
    lea rax, [rel .str602]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L600
    mov rcx, 1
    sub rsp, 32
    call xv_mov_ext
    add rsp, 32
    jmp .__ret_551
    jmp .L601
.L600:
.L601:
    mov rax, rbx
    push rax
section .data
.str605: db 105,109,117,108,0
section .text
    lea rax, [rel .str605]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L603
    sub rsp, 32
    call xv_i_imul
    add rsp, 32
    jmp .__ret_551
    jmp .L604
.L603:
.L604:
    mov rax, rbx
    push rax
section .data
.str608: db 105,110,99,0
section .text
    lea rax, [rel .str608]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L606
    mov rcx, 124
    sub rsp, 32
    call xv_incdec
    add rsp, 32
    jmp .__ret_551
    jmp .L607
.L606:
.L607:
    mov rax, rbx
    push rax
section .data
.str611: db 100,101,99,0
section .text
    lea rax, [rel .str611]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L609
    mov rcx, 125
    sub rsp, 32
    call xv_incdec
    add rsp, 32
    jmp .__ret_551
    jmp .L610
.L609:
.L610:
    mov rax, rbx
    push rax
section .data
.str614: db 110,101,103,0
section .text
    lea rax, [rel .str614]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L612
    sub rsp, 32
    call xv_i_neg
    add rsp, 32
    jmp .__ret_551
    jmp .L613
.L612:
.L613:
    mov rax, rbx
    push rax
section .data
.str617: db 110,111,116,0
section .text
    lea rax, [rel .str617]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L615
    sub rsp, 32
    call xv_i_not
    add rsp, 32
    jmp .__ret_551
    jmp .L616
.L615:
.L616:
    mov rax, rbx
    push rax
section .data
.str620: db 99,113,111,0
section .text
    lea rax, [rel .str620]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L618
    sub rsp, 32
    call xv_i_cqo
    add rsp, 32
    jmp .__ret_551
    jmp .L619
.L618:
.L619:
    mov rax, rbx
    push rax
section .data
.str623: db 105,100,105,118,0
section .text
    lea rax, [rel .str623]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L621
    mov rcx, 127
    sub rsp, 32
    call xv_divide
    add rsp, 32
    jmp .__ret_551
    jmp .L622
.L621:
.L622:
    mov rax, rbx
    push rax
section .data
.str626: db 100,105,118,0
section .text
    lea rax, [rel .str626]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L624
    mov rcx, 128
    sub rsp, 32
    call xv_divide
    add rsp, 32
    jmp .__ret_551
    jmp .L625
.L624:
.L625:
    mov rax, rbx
    push rax
section .data
.str629: db 115,104,108,0
section .text
    lea rax, [rel .str629]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L627
    mov rcx, 134
    sub rsp, 32
    call xv_shift
    add rsp, 32
    jmp .__ret_551
    jmp .L628
.L627:
.L628:
    mov rax, rbx
    push rax
section .data
.str632: db 115,97,108,0
section .text
    lea rax, [rel .str632]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L630
    mov rcx, 134
    sub rsp, 32
    call xv_shift
    add rsp, 32
    jmp .__ret_551
    jmp .L631
.L630:
.L631:
    mov rax, rbx
    push rax
section .data
.str635: db 115,104,114,0
section .text
    lea rax, [rel .str635]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L633
    mov rcx, 136
    sub rsp, 32
    call xv_shift
    add rsp, 32
    jmp .__ret_551
    jmp .L634
.L633:
.L634:
    mov rax, rbx
    push rax
section .data
.str638: db 115,97,114,0
section .text
    lea rax, [rel .str638]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L636
    mov rcx, 135
    sub rsp, 32
    call xv_shift
    add rsp, 32
    jmp .__ret_551
    jmp .L637
.L636:
.L637:
    mov rax, rbx
    push rax
section .data
.str641: db 114,111,108,0
section .text
    lea rax, [rel .str641]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L639
    mov rcx, 137
    sub rsp, 32
    call xv_shift
    add rsp, 32
    jmp .__ret_551
    jmp .L640
.L639:
.L640:
    mov rax, rbx
    push rax
section .data
.str644: db 114,111,114,0
section .text
    lea rax, [rel .str644]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L642
    mov rcx, 138
    sub rsp, 32
    call xv_shift
    add rsp, 32
    jmp .__ret_551
    jmp .L643
.L642:
.L643:
    mov rax, rbx
    push rax
section .data
.str647: db 120,99,104,103,0
section .text
    lea rax, [rel .str647]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L645
    sub rsp, 32
    call xv_i_xchg
    add rsp, 32
    jmp .__ret_551
    jmp .L646
.L645:
.L646:
    mov rax, rbx
    push rax
section .data
.str650: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str650]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L648
    sub rsp, 32
    call xv_i_syscall
    add rsp, 32
    jmp .__ret_551
    jmp .L649
.L648:
.L649:
    mov rax, rbx
    push rax
section .data
.str653: db 110,111,112,0
section .text
    lea rax, [rel .str653]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L651
    mov rax, 0
    jmp .__ret_551
    jmp .L652
.L651:
.L652:
    mov rax, rbx
    push rax
section .data
.str656: db 112,97,117,115,101,0
section .text
    lea rax, [rel .str656]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L654
    mov rax, 0
    jmp .__ret_551
    jmp .L655
.L654:
.L655:
    mov rax, rbx
    push rax
section .data
.str659: db 109,102,101,110,99,101,0
section .text
    lea rax, [rel .str659]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L657
    mov rax, 0
    jmp .__ret_551
    jmp .L658
.L657:
.L658:
    mov rax, rbx
    push rax
section .data
.str662: db 112,114,101,102,101,116,99,104,116,48,0
section .text
    lea rax, [rel .str662]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L660
    mov rax, 0
    jmp .__ret_551
    jmp .L661
.L660:
.L661:
    mov rax, rbx
    push rax
section .data
.str665: db 99,108,102,108,117,115,104,0
section .text
    lea rax, [rel .str665]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L663
    mov rax, 0
    jmp .__ret_551
    jmp .L664
.L663:
.L664:
    mov rax, rbx
    push rax
section .data
.str668: db 109,111,118,115,100,0
section .text
    lea rax, [rel .str668]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L666
    mov rcx, 0
    sub rsp, 32
    call xv_i_movsx_x
    add rsp, 32
    jmp .__ret_551
    jmp .L667
.L666:
.L667:
    mov rax, rbx
    push rax
section .data
.str671: db 109,111,118,115,115,0
section .text
    lea rax, [rel .str671]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L669
    mov rcx, 1
    sub rsp, 32
    call xv_i_movsx_x
    add rsp, 32
    jmp .__ret_551
    jmp .L670
.L669:
.L670:
    mov rax, rbx
    push rax
section .data
.str674: db 109,111,118,113,0
section .text
    lea rax, [rel .str674]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L672
    sub rsp, 32
    call xv_i_movq
    add rsp, 32
    jmp .__ret_551
    jmp .L673
.L672:
.L673:
    mov rax, rbx
    push rax
section .data
.str677: db 109,111,118,97,112,115,0
section .text
    lea rax, [rel .str677]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L675
    sub rsp, 32
    call xv_i_movaps
    add rsp, 32
    jmp .__ret_551
    jmp .L676
.L675:
.L676:
    mov rax, rbx
    push rax
section .data
.str680: db 109,111,118,117,112,115,0
section .text
    lea rax, [rel .str680]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L678
    sub rsp, 32
    call xv_i_movaps
    add rsp, 32
    jmp .__ret_551
    jmp .L679
.L678:
.L679:
    mov rax, rbx
    push rax
section .data
.str683: db 109,111,118,97,112,100,0
section .text
    lea rax, [rel .str683]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L681
    sub rsp, 32
    call xv_i_movaps
    add rsp, 32
    jmp .__ret_551
    jmp .L682
.L681:
.L682:
    mov rax, rbx
    push rax
section .data
.str686: db 109,111,118,117,112,100,0
section .text
    lea rax, [rel .str686]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L684
    sub rsp, 32
    call xv_i_movaps
    add rsp, 32
    jmp .__ret_551
    jmp .L685
.L684:
.L685:
    mov rax, rbx
    push rax
section .data
.str689: db 97,100,100,115,100,0
section .text
    lea rax, [rel .str689]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L687
    mov rcx, 160
    sub rsp, 32
    call xv_fscalar
    add rsp, 32
    jmp .__ret_551
    jmp .L688
.L687:
.L688:
    mov rax, rbx
    push rax
section .data
.str692: db 115,117,98,115,100,0
section .text
    lea rax, [rel .str692]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L690
    mov rcx, 161
    sub rsp, 32
    call xv_fscalar
    add rsp, 32
    jmp .__ret_551
    jmp .L691
.L690:
.L691:
    mov rax, rbx
    push rax
section .data
.str695: db 109,117,108,115,100,0
section .text
    lea rax, [rel .str695]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L693
    mov rcx, 162
    sub rsp, 32
    call xv_fscalar
    add rsp, 32
    jmp .__ret_551
    jmp .L694
.L693:
.L694:
    mov rax, rbx
    push rax
section .data
.str698: db 100,105,118,115,100,0
section .text
    lea rax, [rel .str698]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L696
    mov rcx, 163
    sub rsp, 32
    call xv_fscalar
    add rsp, 32
    jmp .__ret_551
    jmp .L697
.L696:
.L697:
    mov rax, rbx
    push rax
section .data
.str701: db 115,113,114,116,115,100,0
section .text
    lea rax, [rel .str701]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L699
    sub rsp, 32
    call xv_i_sqrtsd
    add rsp, 32
    jmp .__ret_551
    jmp .L700
.L699:
.L700:
    mov rax, rbx
    push rax
section .data
.str704: db 97,100,100,112,100,0
section .text
    lea rax, [rel .str704]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L702
    mov rcx, 240
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L703
.L702:
.L703:
    mov rax, rbx
    push rax
section .data
.str707: db 115,117,98,112,100,0
section .text
    lea rax, [rel .str707]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L705
    mov rcx, 241
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L706
.L705:
.L706:
    mov rax, rbx
    push rax
section .data
.str710: db 109,117,108,112,100,0
section .text
    lea rax, [rel .str710]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L708
    mov rcx, 242
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L709
.L708:
.L709:
    mov rax, rbx
    push rax
section .data
.str713: db 100,105,118,112,100,0
section .text
    lea rax, [rel .str713]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L711
    mov rcx, 243
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L712
.L711:
.L712:
    mov rax, rbx
    push rax
section .data
.str716: db 97,100,100,112,115,0
section .text
    lea rax, [rel .str716]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L714
    mov rcx, 228
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L715
.L714:
.L715:
    mov rax, rbx
    push rax
section .data
.str719: db 115,117,98,112,115,0
section .text
    lea rax, [rel .str719]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L717
    mov rcx, 229
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L718
.L717:
.L718:
    mov rax, rbx
    push rax
section .data
.str722: db 109,117,108,112,115,0
section .text
    lea rax, [rel .str722]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L720
    mov rcx, 230
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L721
.L720:
.L721:
    mov rax, rbx
    push rax
section .data
.str725: db 100,105,118,112,115,0
section .text
    lea rax, [rel .str725]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L723
    mov rcx, 231
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L724
.L723:
.L724:
    mov rax, rbx
    push rax
section .data
.str728: db 120,111,114,112,115,0
section .text
    lea rax, [rel .str728]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L726
    mov rcx, 81
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L727
.L726:
.L727:
    mov rax, rbx
    push rax
section .data
.str731: db 120,111,114,112,100,0
section .text
    lea rax, [rel .str731]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L729
    mov rcx, 81
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L730
.L729:
.L730:
    mov rax, rbx
    push rax
section .data
.str734: db 97,110,100,112,115,0
section .text
    lea rax, [rel .str734]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L732
    mov rcx, 78
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L733
.L732:
.L733:
    mov rax, rbx
    push rax
section .data
.str737: db 97,110,100,112,100,0
section .text
    lea rax, [rel .str737]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L735
    mov rcx, 78
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L736
.L735:
.L736:
    mov rax, rbx
    push rax
section .data
.str740: db 111,114,112,100,0
section .text
    lea rax, [rel .str740]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L738
    mov rcx, 80
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L739
.L738:
.L739:
    mov rax, rbx
    push rax
section .data
.str743: db 111,114,112,115,0
section .text
    lea rax, [rel .str743]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L741
    mov rcx, 80
    sub rsp, 32
    call xv_packed
    add rsp, 32
    jmp .__ret_551
    jmp .L742
.L741:
.L742:
    mov rax, rbx
    push rax
section .data
.str746: db 117,99,111,109,105,115,100,0
section .text
    lea rax, [rel .str746]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L744
    sub rsp, 32
    call xv_i_ucomisd
    add rsp, 32
    jmp .__ret_551
    jmp .L745
.L744:
.L745:
    mov rax, rbx
    push rax
section .data
.str749: db 99,111,109,105,115,100,0
section .text
    lea rax, [rel .str749]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L747
    sub rsp, 32
    call xv_i_ucomisd
    add rsp, 32
    jmp .__ret_551
    jmp .L748
.L747:
.L748:
    mov rax, rbx
    push rax
section .data
.str752: db 99,118,116,115,105,50,115,100,0
section .text
    lea rax, [rel .str752]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L750
    sub rsp, 32
    call xv_i_cvtsi2sd
    add rsp, 32
    jmp .__ret_551
    jmp .L751
.L750:
.L751:
    mov rax, rbx
    push rax
section .data
.str755: db 99,118,116,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str755]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L753
    mov rcx, 0
    sub rsp, 32
    call xv_cvt_int
    add rsp, 32
    jmp .__ret_551
    jmp .L754
.L753:
.L754:
    mov rax, rbx
    push rax
section .data
.str758: db 99,118,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str758]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L756
    mov rcx, 1
    sub rsp, 32
    call xv_cvt_int
    add rsp, 32
    jmp .__ret_551
    jmp .L757
.L756:
.L757:
    mov rax, rbx
    push rax
section .data
.str761: db 99,118,116,115,115,50,115,100,0
section .text
    lea rax, [rel .str761]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L759
    sub rsp, 32
    call xv_i_cvtss2sd
    add rsp, 32
    jmp .__ret_551
    jmp .L760
.L759:
.L760:
    mov rax, rbx
    push rax
section .data
.str764: db 99,118,116,115,100,50,115,115,0
section .text
    lea rax, [rel .str764]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L762
    sub rsp, 32
    call xv_i_cvtsd2ss
    add rsp, 32
    jmp .__ret_551
    jmp .L763
.L762:
.L763:
    mov rcx, rbx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 106
    jne .L765
    sub rsp, 32
    call xv_i_jcc
    add rsp, 32
    jmp .__ret_551
    jmp .L766
.L765:
.L766:
    mov rax, rbx
    push rax
section .data
.str769: db 115,101,116,0
section .text
    lea rax, [rel .str769]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L767
    sub rsp, 32
    call xv_i_setcc
    add rsp, 32
    jmp .__ret_551
    jmp .L768
.L767:
.L768:
    sub rsp, 32
    call xv_bad
    add rsp, 32
    jmp .__ret_551
.__ret_551:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i_mov:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L771
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L773
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_770
    jmp .L774
.L773:
.L774:
    mov rcx, r13
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_770
    jmp .L772
.L771:
.L772:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L775
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_770
    jmp .L776
.L775:
.L776:
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call xv_opsize
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xwasm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L779
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L779
    mov rax, 1
    jmp .L780
.L779:
    mov rax, 0
.L780:
    test rax, rax
    jz .L777
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    jmp .L778
.L777:
.L778:
    mov rcx, r13
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_store
    add rsp, 32
    jmp .__ret_770
.__ret_770:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_mov_ext:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L782
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_781
    jmp .L783
.L782:
.L783:
    mov rax, rbx
    push rax
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call xv_opsize
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, r13
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_781
.__ret_781:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i_lea:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L787
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L787
    mov rax, 0
    jmp .L788
.L787:
    mov rax, 1
.L788:
    test rax, rax
    jz .L785
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_784
    jmp .L786
.L785:
.L786:
    mov rcx, rbx
    sub rsp, 32
    call xv_addr64
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_784
.__ret_784:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_i_push:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    sub rsp, 32
    call xv_push_t0
    add rsp, 32
    jmp .__ret_789
.__ret_789:
    mov rsp, rbp
    pop rbp
    ret
xv_i_pop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L791
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_790
    jmp .L792
.L791:
.L792:
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 41
    sub rsp, 32
    call xv_mem
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_790
.__ret_790:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i_xchg:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r14, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L794
    mov rcx, r14
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L796
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rcx, r14
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_793
    jmp .L797
.L796:
.L797:
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r14, rax
    jmp .L795
.L794:
.L795:
    mov rcx, r14
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov r13, rax
    mov rcx, r12
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    mov rcx, r14
    mov rdx, r13
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, 254
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, 69
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 8
    jne .L798
    mov rax, 66
    mov r12, rax
    mov rax, 3
    mov rbx, rax
    jmp .L799
.L798:
    cmp r13, 4
    jne .L800
    mov rax, 71
    mov r12, rax
    mov rax, 2
    mov rbx, rax
    jmp .L801
.L800:
    cmp r13, 2
    jne .L802
    mov rax, 70
    mov r12, rax
    mov rax, 1
    mov rbx, rax
    jmp .L803
.L802:
.L803:
.L801:
.L799:
    mov rcx, r12
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_793
.__ret_793:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_arith:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L805
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_804
    jmp .L806
.L805:
.L806:
    mov rcx, r13
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_xwasm_FK_RES]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L807
    mov rax, [rel __g_xwasm_L_FA]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ltee
    add rsp, 32
    jmp .L808
.L807:
.L808:
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_xwasm_FK_RES]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L809
    mov rax, [rel __g_xwasm_L_FB]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ltee
    add rsp, 32
    jmp .L810
.L809:
.L810:
    mov rcx, r15
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ltee
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    mov rax, r14
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_804
.__ret_804:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_i_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call xv_opsize
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L814
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L814
    mov rax, 1
    jmp .L815
.L814:
    mov rax, 0
.L815:
    test rax, rax
    jz .L812
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    jmp .L813
.L812:
.L813:
    mov rcx, r13
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FA]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FB]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_SUB]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_811
.__ret_811:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i_test:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call xv_opsize
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, 131
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_RES]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_816
.__ret_816:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_incdec:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L818
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_817
    jmp .L819
.L818:
.L819:
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ltee
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_RES]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_817
.__ret_817:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i_neg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L821
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_820
    jmp .L822
.L821:
.L822:
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, 0
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, 125
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ltee
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_RES]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_820
.__ret_820:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_i_not:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L824
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_823
    jmp .L825
.L824:
.L825:
    mov rcx, r12
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, 1
    neg rax
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 133
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_823
.__ret_823:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_i_imul:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r14, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 2
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L827
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_826
    jmp .L828
.L827:
.L828:
    mov rcx, r14
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    cmp rax, 0
    je .L829
    mov rcx, r13
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    jmp .L830
.L829:
    mov rcx, r14
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
.L830:
    mov rcx, 126
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_826
.__ret_826:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_i_cqo:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 63
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 135
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_gset
    add rsp, 32
    jmp .__ret_831
.__ret_831:
    mov rsp, rbp
    pop rbp
    ret
xv_divide:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T1]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T1]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T0]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_T1]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_832
.__ret_832:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L834
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_833
    jmp .L835
.L834:
.L835:
    mov rcx, r13
    sub rsp, 32
    call xv_rs
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r12
    mov rdx, 8
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L836
    mov rcx, 63
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 131
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L837
.L836:
.L837:
    mov rcx, r14
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_833
.__ret_833:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_i_ret:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gset
    add rsp, 32
    sub rsp, 32
    call xv_sync_out
    add rsp, 32
    mov rcx, 15
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, 1
    mov [rel __g_xwasm_xv_term], rax
    mov rax, 0
    jmp .__ret_838
.__ret_838:
    mov rsp, rbp
    pop rbp
    ret
xv_i_syscall:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call xv_sync_out
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 7
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 6
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 10
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 9
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gset_raw
    add rsp, 32
    sub rsp, 32
    call xv_sync_in
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_839
.__ret_839:
    mov rsp, rbp
    pop rbp
    ret
xv_i_call:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L841
    sub rsp, 32
    call xv_push_ret
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    sub rsp, 32
    call xv_sync_out
    add rsp, 32
    mov rcx, 17
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    sub rsp, 32
    call xv_sync_in
    add rsp, 32
    jmp .L842
.L841:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L843
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_fn_of
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L845
    sub rsp, 32
    call xv_push_ret
    add rsp, 32
    sub rsp, 32
    call xv_sync_out
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    sub rsp, 32
    call xv_sync_in
    add rsp, 32
    jmp .L846
.L845:
.L846:
    jmp .L844
.L843:
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_840
.L844:
.L842:
    mov rax, [rel __g_xwasm_FK_NONE]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_840
.__ret_840:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_i_jmp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L848
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_847
    jmp .L849
.L848:
.L849:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_goto
    add rsp, 32
    mov rax, 1
    mov [rel __g_xwasm_xv_term], rax
    mov rax, 0
    jmp .__ret_847
.__ret_847:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i_jcc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xwasm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xv_condcode
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L851
    sub rsp, 32
    call xv_bad
    add rsp, 32
    jmp .__ret_850
    jmp .L852
.L851:
.L852:
    mov rcx, rbx
    sub rsp, 32
    call xv_cond
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L853
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_850
    jmp .L854
.L853:
.L854:
    mov rcx, 4
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 64
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, 1
    mov [rel __g_xwasm_xv_iff], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_goto
    add rsp, 32
    mov rax, 0
    mov [rel __g_xwasm_xv_iff], rax
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_850
.__ret_850:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i_setcc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xwasm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xv_s
    add rsp, 32
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call xv_condcode
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L856
    sub rsp, 32
    call xv_bad
    add rsp, 32
    jmp .__ret_855
    jmp .L857
.L856:
.L857:
    mov rcx, rbx
    sub rsp, 32
    call xv_cond
    add rsp, 32
    mov rcx, 173
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L858
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_855
    jmp .L859
.L858:
.L859:
    mov rcx, rbx
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_855
.__ret_855:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_fn_of:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xv_label_ref
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_xwasm_xv_l_kind]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_LK_CODE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L861
section .data
.str863: db 108,97,98,101,108,32,110,111,116,32,100,101,102,105,110,101,100,0
section .text
    lea rax, [rel .str863]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_860
    jmp .L862
.L861:
.L862:
    lea rax, [rel __g_xwasm_xv_l_blk]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    cmp rax, 0
    je .L864
section .data
.str866: db 106,117,109,112,32,116,111,32,97,32,108,97,98,101,108,32,111,102,32,97,110,111,116,104,101,114,32,102,117,110,99,116,105,111,110,0
section .text
    lea rax, [rel .str866]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_860
    jmp .L865
.L864:
.L865:
    lea rax, [rel __g_xwasm_xv_l_fn]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    add rax, 2
    mov rcx, 4294967295
    and rax, rcx
    jmp .__ret_860
.__ret_860:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_goto:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    cmp rax, 46
    je .L868
    mov rcx, rbx
    sub rsp, 32
    call xv_fn_of
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L870
    mov rax, 0
    jmp .__ret_867
    jmp .L871
.L870:
.L871:
    sub rsp, 32
    call xv_sync_out
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 15
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_867
    jmp .L869
.L868:
.L869:
    mov rcx, rbx
    sub rsp, 32
    call xv_label_ref
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_xwasm_xv_l_fn]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L872
section .data
.str874: db 106,117,109,112,32,116,111,32,97,32,108,97,98,101,108,32,111,102,32,97,110,111,116,104,101,114,32,102,117,110,99,116,105,111,110,0
section .text
    lea rax, [rel .str874]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_867
    jmp .L873
.L872:
.L873:
    lea rax, [rel __g_xwasm_xv_l_blk]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_s32
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L875
section .data
.str877: db 106,117,109,112,32,116,111,32,97,32,108,97,98,101,108,32,111,102,32,97,110,111,116,104,101,114,32,102,117,110,99,116,105,111,110,0
section .text
    lea rax, [rel .str877]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_867
    jmp .L876
.L875:
.L876:
    mov rcx, rbx
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    mov rax, [rel __g_xwasm_L_PC]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_nblk]
    push rax
    mov rax, [rel __g_xwasm_xv_fn]
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g32
    add rsp, 32
    sub rax, 1
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    mov rcx, 12
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_xv_blk]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_xwasm_xv_iff]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    jmp .__ret_867
.__ret_867:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xv_condcode:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str883: db 101,0
section .text
    lea rax, [rel .str883]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L881
    mov rax, rbx
    push rax
section .data
.str884: db 122,0
section .text
    lea rax, [rel .str884]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L881
    mov rax, 0
    jmp .L882
.L881:
    mov rax, 1
.L882:
    test rax, rax
    jz .L879
    mov rax, 0
    jmp .__ret_878
    jmp .L880
.L879:
.L880:
    mov rax, rbx
    push rax
section .data
.str889: db 110,101,0
section .text
    lea rax, [rel .str889]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L887
    mov rax, rbx
    push rax
section .data
.str890: db 110,122,0
section .text
    lea rax, [rel .str890]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L887
    mov rax, 0
    jmp .L888
.L887:
    mov rax, 1
.L888:
    test rax, rax
    jz .L885
    mov rax, 1
    jmp .__ret_878
    jmp .L886
.L885:
.L886:
    mov rax, rbx
    push rax
section .data
.str895: db 108,0
section .text
    lea rax, [rel .str895]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L893
    mov rax, rbx
    push rax
section .data
.str896: db 110,103,101,0
section .text
    lea rax, [rel .str896]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L893
    mov rax, 0
    jmp .L894
.L893:
    mov rax, 1
.L894:
    test rax, rax
    jz .L891
    mov rax, 2
    jmp .__ret_878
    jmp .L892
.L891:
.L892:
    mov rax, rbx
    push rax
section .data
.str901: db 103,101,0
section .text
    lea rax, [rel .str901]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L899
    mov rax, rbx
    push rax
section .data
.str902: db 110,108,0
section .text
    lea rax, [rel .str902]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L899
    mov rax, 0
    jmp .L900
.L899:
    mov rax, 1
.L900:
    test rax, rax
    jz .L897
    mov rax, 3
    jmp .__ret_878
    jmp .L898
.L897:
.L898:
    mov rax, rbx
    push rax
section .data
.str907: db 108,101,0
section .text
    lea rax, [rel .str907]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L905
    mov rax, rbx
    push rax
section .data
.str908: db 110,103,0
section .text
    lea rax, [rel .str908]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L905
    mov rax, 0
    jmp .L906
.L905:
    mov rax, 1
.L906:
    test rax, rax
    jz .L903
    mov rax, 4
    jmp .__ret_878
    jmp .L904
.L903:
.L904:
    mov rax, rbx
    push rax
section .data
.str913: db 103,0
section .text
    lea rax, [rel .str913]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L911
    mov rax, rbx
    push rax
section .data
.str914: db 110,108,101,0
section .text
    lea rax, [rel .str914]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L911
    mov rax, 0
    jmp .L912
.L911:
    mov rax, 1
.L912:
    test rax, rax
    jz .L909
    mov rax, 5
    jmp .__ret_878
    jmp .L910
.L909:
.L910:
    mov rax, rbx
    push rax
section .data
.str921: db 98,0
section .text
    lea rax, [rel .str921]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L919
    mov rax, rbx
    push rax
section .data
.str922: db 99,0
section .text
    lea rax, [rel .str922]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L919
    mov rax, 0
    jmp .L920
.L919:
    mov rax, 1
.L920:
    test rax, rax
    jnz .L917
    mov rax, rbx
    push rax
section .data
.str923: db 110,97,101,0
section .text
    lea rax, [rel .str923]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L917
    mov rax, 0
    jmp .L918
.L917:
    mov rax, 1
.L918:
    test rax, rax
    jz .L915
    mov rax, 6
    jmp .__ret_878
    jmp .L916
.L915:
.L916:
    mov rax, rbx
    push rax
section .data
.str930: db 97,101,0
section .text
    lea rax, [rel .str930]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L928
    mov rax, rbx
    push rax
section .data
.str931: db 110,98,0
section .text
    lea rax, [rel .str931]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L928
    mov rax, 0
    jmp .L929
.L928:
    mov rax, 1
.L929:
    test rax, rax
    jnz .L926
    mov rax, rbx
    push rax
section .data
.str932: db 110,99,0
section .text
    lea rax, [rel .str932]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L926
    mov rax, 0
    jmp .L927
.L926:
    mov rax, 1
.L927:
    test rax, rax
    jz .L924
    mov rax, 7
    jmp .__ret_878
    jmp .L925
.L924:
.L925:
    mov rax, rbx
    push rax
section .data
.str937: db 98,101,0
section .text
    lea rax, [rel .str937]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L935
    mov rax, rbx
    push rax
section .data
.str938: db 110,97,0
section .text
    lea rax, [rel .str938]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L935
    mov rax, 0
    jmp .L936
.L935:
    mov rax, 1
.L936:
    test rax, rax
    jz .L933
    mov rax, 8
    jmp .__ret_878
    jmp .L934
.L933:
.L934:
    mov rax, rbx
    push rax
section .data
.str943: db 97,0
section .text
    lea rax, [rel .str943]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L941
    mov rax, rbx
    push rax
section .data
.str944: db 110,98,101,0
section .text
    lea rax, [rel .str944]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L941
    mov rax, 0
    jmp .L942
.L941:
    mov rax, 1
.L942:
    test rax, rax
    jz .L939
    mov rax, 9
    jmp .__ret_878
    jmp .L940
.L939:
.L940:
    mov rax, rbx
    push rax
section .data
.str947: db 115,0
section .text
    lea rax, [rel .str947]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L945
    mov rax, 10
    jmp .__ret_878
    jmp .L946
.L945:
.L946:
    mov rax, rbx
    push rax
section .data
.str950: db 110,115,0
section .text
    lea rax, [rel .str950]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L948
    mov rax, 11
    jmp .__ret_878
    jmp .L949
.L948:
.L949:
    mov rax, 1
    neg rax
    jmp .__ret_878
.__ret_878:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_subop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L952
    mov rax, 81
    jmp .__ret_951
    jmp .L953
.L952:
.L953:
    cmp rbx, 1
    jne .L954
    mov rax, 82
    jmp .__ret_951
    jmp .L955
.L954:
.L955:
    cmp rbx, 2
    jne .L956
    mov rax, 83
    jmp .__ret_951
    jmp .L957
.L956:
.L957:
    cmp rbx, 3
    jne .L958
    mov rax, 89
    jmp .__ret_951
    jmp .L959
.L958:
.L959:
    cmp rbx, 4
    jne .L960
    mov rax, 87
    jmp .__ret_951
    jmp .L961
.L960:
.L961:
    cmp rbx, 5
    jne .L962
    mov rax, 85
    jmp .__ret_951
    jmp .L963
.L962:
.L963:
    cmp rbx, 6
    jne .L964
    mov rax, 84
    jmp .__ret_951
    jmp .L965
.L964:
.L965:
    cmp rbx, 7
    jne .L966
    mov rax, 90
    jmp .__ret_951
    jmp .L967
.L966:
.L967:
    cmp rbx, 8
    jne .L968
    mov rax, 88
    jmp .__ret_951
    jmp .L969
.L968:
.L969:
    mov rax, 86
    jmp .__ret_951
.__ret_951:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_resop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L971
    mov rax, 81
    jmp .__ret_970
    jmp .L972
.L971:
.L972:
    cmp rbx, 1
    jne .L973
    mov rax, 82
    jmp .__ret_970
    jmp .L974
.L973:
.L974:
    cmp rbx, 2
    jne .L975
    mov rax, 83
    jmp .__ret_970
    jmp .L976
.L975:
.L976:
    cmp rbx, 3
    jne .L977
    mov rax, 89
    jmp .__ret_970
    jmp .L978
.L977:
.L978:
    cmp rbx, 4
    jne .L979
    mov rax, 87
    jmp .__ret_970
    jmp .L980
.L979:
.L980:
    cmp rbx, 5
    jne .L981
    mov rax, 85
    jmp .__ret_970
    jmp .L982
.L981:
.L982:
    cmp rbx, 8
    jne .L983
    mov rax, 81
    jmp .__ret_970
    jmp .L984
.L983:
.L984:
    cmp rbx, 9
    jne .L985
    mov rax, 82
    jmp .__ret_970
    jmp .L986
.L985:
.L986:
    cmp rbx, 10
    jne .L987
    mov rax, 83
    jmp .__ret_970
    jmp .L988
.L987:
.L988:
    cmp rbx, 11
    jne .L989
    mov rax, 89
    jmp .__ret_970
    jmp .L990
.L989:
.L990:
    mov rax, 0
    jmp .__ret_970
.__ret_970:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_byres:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L994
    mov rax, rbx
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L994
    mov rax, 0
    jmp .L995
.L994:
    mov rax, 1
.L995:
    test rax, rax
    jz .L992
    mov rcx, 80
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_991
    jmp .L993
.L992:
.L993:
    mov rcx, 0
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_resop
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_991
.__ret_991:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_cond:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, [rel __g_xwasm_xv_fk]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_FK_SUB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L997
    mov rax, [rel __g_xwasm_L_FA]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FB]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    cmp r12, 10
    jge .L999
    mov rcx, r12
    sub rsp, 32
    call xv_subop
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_996
    jmp .L1000
.L999:
.L1000:
    mov rcx, 125
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    cmp r12, 10
    jne .L1001
    mov rcx, 83
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_996
    jmp .L1002
.L1001:
.L1002:
    mov rcx, 89
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_996
    jmp .L998
.L997:
.L998:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_FK_RES]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1003
    cmp r12, 6
    jne .L1005
    mov rcx, 0
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    jmp .__ret_996
    jmp .L1006
.L1005:
.L1006:
    cmp r12, 7
    jne .L1007
    mov rcx, 1
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    jmp .__ret_996
    jmp .L1008
.L1007:
.L1008:
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_byres
    add rsp, 32
    jmp .__ret_996
    jmp .L1004
.L1003:
.L1004:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_FK_ADD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1009
    mov rax, r12
    mov rcx, 6
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1013
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1013
    mov rax, 0
    jmp .L1014
.L1013:
    mov rax, 1
.L1014:
    test rax, rax
    jz .L1011
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_byres
    add rsp, 32
    jmp .__ret_996
    jmp .L1012
.L1011:
.L1012:
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FA]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 84
    sub rsp, 32
    call xv_wb
    add rsp, 32
    cmp r12, 6
    jne .L1015
    mov rax, 0
    jmp .__ret_996
    jmp .L1016
.L1015:
.L1016:
    cmp r12, 7
    jne .L1017
    mov rcx, 69
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_996
    jmp .L1018
.L1017:
.L1018:
    mov rax, [rel __g_xwasm_L_FR]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 80
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 114
    sub rsp, 32
    call xv_wb
    add rsp, 32
    cmp r12, 8
    jne .L1019
    mov rax, 0
    jmp .__ret_996
    jmp .L1020
.L1019:
.L1020:
    mov rcx, 69
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_996
    jmp .L1010
.L1009:
.L1010:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_FK_FP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1021
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1025
    mov rax, r12
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1025
    mov rax, 0
    jmp .L1026
.L1025:
    mov rax, 1
.L1026:
    test rax, rax
    jz .L1023
    mov rax, 97
    mov rbx, rax
    jmp .L1024
.L1023:
    mov rax, r12
    mov rcx, 6
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1029
    mov rax, r12
    mov rcx, 7
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1029
    mov rax, 0
    jmp .L1030
.L1029:
    mov rax, 1
.L1030:
    test rax, rax
    jz .L1027
    mov rax, 99
    mov rbx, rax
    jmp .L1028
.L1027:
    mov rax, r12
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1033
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1033
    mov rax, 0
    jmp .L1034
.L1033:
    mov rax, 1
.L1034:
    test rax, rax
    jz .L1031
    mov rax, 101
    mov rbx, rax
    jmp .L1032
.L1031:
section .data
.str1035: db 99,111,110,100,105,116,105,111,110,32,119,105,116,104,32,110,111,116,104,105,110,103,32,115,101,116,116,105,110,103,32,116,104,101,32,102,108,97,103,115,32,98,101,102,111,114,101,32,105,116,0
section .text
    lea rax, [rel .str1035]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_996
.L1032:
.L1028:
.L1024:
    mov rax, [rel __g_xwasm_L_FX]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FY]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FX]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FX]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 98
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FY]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FY]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lget
    add rsp, 32
    mov rcx, 98
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 114
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 114
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, r12
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1040
    mov rax, r12
    mov rcx, 7
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1040
    mov rax, 0
    jmp .L1041
.L1040:
    mov rax, 1
.L1041:
    test rax, rax
    jnz .L1038
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1038
    mov rax, 0
    jmp .L1039
.L1038:
    mov rax, 1
.L1039:
    test rax, rax
    jz .L1036
    mov rcx, 69
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_996
    jmp .L1037
.L1036:
.L1037:
    mov rax, 0
    jmp .__ret_996
    jmp .L1022
.L1021:
.L1022:
section .data
.str1042: db 99,111,110,100,105,116,105,111,110,32,119,105,116,104,32,110,111,116,104,105,110,103,32,115,101,116,116,105,110,103,32,116,104,101,32,102,108,97,103,115,32,98,101,102,111,114,101,32,105,116,0
section .text
    lea rax, [rel .str1042]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_996
.__ret_996:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_xget:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_XMM]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call xv_gget
    add rsp, 32
    jmp .__ret_1043
.__ret_1043:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_xset:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_OP_XMM]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call xv_gset
    add rsp, 32
    jmp .__ret_1044
.__ret_1044:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_lane0_get:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    je .L1046
    mov rcx, 31
    sub rsp, 32
    call xv_simd
    add rsp, 32
    jmp .L1047
.L1046:
    mov rcx, 33
    sub rsp, 32
    call xv_simd
    add rsp, 32
.L1047:
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_1045
.__ret_1045:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_lane0_set:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    je .L1049
    mov rcx, 32
    sub rsp, 32
    call xv_simd
    add rsp, 32
    jmp .L1050
.L1049:
    mov rcx, 34
    sub rsp, 32
    call xv_simd
    add rsp, 32
.L1050:
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_1048
.__ret_1048:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i_movsx_x:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1052
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1054
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1051
    jmp .L1055
.L1054:
.L1055:
    mov rcx, r13
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    cmp r14, 0
    je .L1056
    mov rcx, 90
    sub rsp, 32
    call xv_simd_mem
    add rsp, 32
    jmp .L1057
.L1056:
    mov rcx, 91
    sub rsp, 32
    call xv_simd_mem
    add rsp, 32
.L1057:
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_1051
    jmp .L1053
.L1052:
.L1053:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1058
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1051
    jmp .L1059
.L1058:
.L1059:
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1060
    mov rcx, r12
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    cmp r14, 0
    je .L1062
    mov rcx, 92
    sub rsp, 32
    call xv_simd_mem
    add rsp, 32
    jmp .L1063
.L1062:
    mov rcx, 93
    sub rsp, 32
    call xv_simd_mem
    add rsp, 32
.L1063:
    mov rcx, r13
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1051
    jmp .L1061
.L1060:
.L1061:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1064
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1051
    jmp .L1065
.L1064:
.L1065:
    mov rcx, r13
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call xv_lane0_set
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1051
.__ret_1051:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xv_i_movaps:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1067
    mov rcx, r13
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_simd_mem
    add rsp, 32
    jmp .__ret_1066
    jmp .L1068
.L1067:
.L1068:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1069
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1066
    jmp .L1070
.L1069:
.L1070:
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1071
    mov rcx, r12
    sub rsp, 32
    call xv_addr32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_simd_mem
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1066
    jmp .L1072
.L1071:
.L1072:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1073
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1066
    jmp .L1074
.L1073:
.L1074:
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1066
.__ret_1066:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i_movq:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1076
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1075
    jmp .L1077
.L1076:
.L1077:
    sub rsp, 32
    call xv_v128_zero
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, 30
    sub rsp, 32
    call xv_simd
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1075
.__ret_1075:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_v128_zero:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 12
    sub rsp, 32
    call xv_simd
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L1079:
    cmp rbx, 16
    jge .L1080
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    add rbx, 1
.L1081:
    jmp .L1079
.L1080:
    mov rax, 0
    jmp .__ret_1078
.__ret_1078:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_fscalar:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1085
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1085
    mov rax, 0
    jmp .L1086
.L1085:
    mov rax, 1
.L1086:
    test rax, rax
    jz .L1083
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1082
    jmp .L1084
.L1083:
.L1084:
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_set
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1082
.__ret_1082:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i_sqrtsd:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rcx, 159
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_set
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1087
.__ret_1087:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_packed:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1091
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1091
    mov rax, 0
    jmp .L1092
.L1091:
    mov rax, 1
.L1092:
    test rax, rax
    jz .L1089
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1088
    jmp .L1090
.L1089:
.L1090:
    mov rcx, r12
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xv_simd
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1088
.__ret_1088:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_i_ucomisd:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FX]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rax, [rel __g_xwasm_L_FY]
    push rax
    pop rcx
    sub rsp, 32
    call xv_lset
    add rsp, 32
    mov rax, [rel __g_xwasm_FK_FP]
    mov [rel __g_xwasm_xv_fk], rax
    mov rax, 0
    jmp .__ret_1093
.__ret_1093:
    mov rsp, rbp
    pop rbp
    ret
xv_i_cvtsi2sd:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1095
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1094
    jmp .L1096
.L1095:
.L1096:
    mov rcx, rbx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 0
    sub rsp, 32
    call xv_rd
    add rsp, 32
    mov rcx, 185
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_set
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1094
.__ret_1094:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_cvt_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1098
    sub rsp, 32
    call xv_badop
    add rsp, 32
    jmp .__ret_1097
    jmp .L1099
.L1098:
.L1099:
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    cmp r12, 0
    je .L1100
    mov rcx, 158
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .L1101
.L1100:
.L1101:
    mov rcx, 252
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 6
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_reg
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call xv_wreg
    add rsp, 32
    jmp .__ret_1097
.__ret_1097:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_i_cvtss2sd:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rcx, 187
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_set
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1102
.__ret_1102:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_i_cvtsd2ss:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call xv_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_xget
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_lane0_get
    add rsp, 32
    mov rcx, 182
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_lane0_set
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_xset
    add rsp, 32
    jmp .__ret_1103
.__ret_1103:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_sb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_ob
    add rsp, 32
    jmp .__ret_1104
.__ret_1104:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_suleb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_obuleb
    add rsp, 32
    jmp .__ret_1105
.__ret_1105:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_ssleb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_obsleb
    add rsp, 32
    jmp .__ret_1106
.__ret_1106:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_sstr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_obstr
    add rsp, 32
    jmp .__ret_1107
.__ret_1107:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_obytes:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_xwasm_xv_on]
    add rax, r12
    push rax
    mov rax, [rel __g_xwasm_xv_out_cap]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1109
section .data
.str1111: db 111,117,116,112,117,116,32,98,117,102,102,101,114,32,102,117,108,108,0
section .text
    lea rax, [rel .str1111]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_1108
    jmp .L1110
.L1109:
.L1110:
    mov rax, 0
    mov rbx, rax
.L1112:
    cmp rbx, r12
    jge .L1113
    mov rax, [rel __g_xwasm_xv_out]
    push rax
    mov rax, [rel __g_xwasm_xv_on]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add rbx, 1
.L1114:
    jmp .L1112
.L1113:
    mov rax, [rel __g_xwasm_xv_on]
    add rax, r12
    mov [rel __g_xwasm_xv_on], rax
    mov rax, 0
    jmp .__ret_1108
.__ret_1108:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xv_head:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xv_ob
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_tmp]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_obuleb
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_tmp]
    push rax
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    jmp .__ret_1115
.__ret_1115:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xv_flush:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_head
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_sect]
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    jmp .__ret_1116
.__ret_1116:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xv_module:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, 0
    mov [rel __g_xwasm_xv_on], rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_start_fn]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1118
section .data
.str1120: db 108,97,98,101,108,32,110,111,116,32,100,101,102,105,110,101,100,0
section .text
    lea rax, [rel .str1120]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .__ret_1117
    jmp .L1119
.L1118:
.L1119:
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 97
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 115
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 109
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_ob
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TMP]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_ob
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_tmp]
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 96
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 96
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 7
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1121:
    cmp r12, 7
    jge .L1122
    mov rcx, 126
    sub rsp, 32
    call xv_sb
    add rsp, 32
    add r12, 1
.L1123:
    jmp .L1121
.L1122:
    mov rcx, 1
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 126
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 96
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 126
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_suleb
    add rsp, 32
section .data
.str1124: db 101,110,118,0
section .text
    lea rax, [rel .str1124]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
section .data
.str1125: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str1125]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_suleb
    add rsp, 32
section .data
.str1126: db 101,110,118,0
section .text
    lea rax, [rel .str1126]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
section .data
.str1127: db 109,101,109,111,114,121,0
section .text
    lea rax, [rel .str1127]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_heap_base]
    shr rax, 16
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 65536
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_nfn_total]
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1128:
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_xv_nfn_total]
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1129
    mov rcx, 0
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    add r12, 1
.L1130:
    jmp .L1128
.L1129:
    mov rcx, 2
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 112
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_addr_total]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_addr_total]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rcx, 33
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1131:
    cmp r12, 16
    jge .L1132
    mov rcx, 126
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 66
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_sb
    add rsp, 32
    add r12, 1
.L1133:
    jmp .L1131
.L1132:
    mov rax, 0
    mov r12, rax
.L1134:
    cmp r12, 16
    jge .L1135
    mov rcx, 123
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 253
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 12
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L1137:
    cmp rbx, 16
    jge .L1138
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    add rbx, 1
.L1139:
    jmp .L1137
.L1138:
    mov rcx, 11
    sub rsp, 32
    call xv_sb
    add rsp, 32
    add r12, 1
.L1136:
    jmp .L1134
.L1135:
    mov rcx, 126
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 66
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_heap_base]
    push rax
    pop rcx
    sub rsp, 32
    call xv_ssleb
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 6
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call xv_suleb
    add rsp, 32
section .data
.str1140: db 107,114,111,110,95,116,104,114,101,97,100,0
section .text
    lea rax, [rel .str1140]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_nfn_total]
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
section .data
.str1141: db 107,114,111,110,95,115,116,97,114,116,0
section .text
    lea rax, [rel .str1141]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_suleb
    add rsp, 32
section .data
.str1142: db 107,114,111,110,95,104,101,97,112,0
section .text
    lea rax, [rel .str1142]
    push rax
    pop rcx
    sub rsp, 32
    call xv_sstr
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 32
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 7
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_nfn_total]
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1143:
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_xv_nfn_total]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1144
    mov rcx, 0
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 65
    sub rsp, 32
    call xv_sb
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_f_addr]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g64
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_ssleb
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    add r12, 1
.L1145:
    jmp .L1143
.L1144:
    mov rcx, 9
    sub rsp, 32
    call xv_flush
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 12
    sub rsp, 32
    call xv_flush
    add rsp, 32
    sub rsp, 32
    call xv_thread_body
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_nfn_total]
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    sub rsp, 32
    call xv_start_body
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_body_n]
    push rax
    pop rcx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1146:
    mov rax, r12
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1147
    lea rax, [rel __g_xwasm_xv_body]
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xv_sb
    add rsp, 32
    add r12, 1
.L1148:
    jmp .L1146
.L1147:
    mov rax, 10
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    mov rax, [rel __g_xwasm_B_CODE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xwasm_B_TB]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_head
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_sect]
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_code]
    push rax
    mov rax, [rel __g_xwasm_B_CODE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_tb]
    push rax
    mov rax, [rel __g_xwasm_B_TB]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_data]
    push rax
    mov rax, [rel __g_xwasm_xv_dsize]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 107
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    mov rdx, 114
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    mov rdx, 111
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, rbx
    add rax, 3
    push rax
    pop rcx
    mov rdx, 110
    sub rsp, 32
    call xv_p8
    add rsp, 32
    mov rax, 4
    mov r12, rax
.L1149:
    cmp r12, 16
    jge .L1150
    mov rax, rbx
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_p8
    add rsp, 32
    add r12, 1
.L1151:
    jmp .L1149
.L1150:
    mov rax, [rel __g_xwasm_xv_dsize]
    add rax, 16
    mov rbx, rax
    mov rcx, 1
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_sb
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xv_suleb
    add rsp, 32
    mov rax, 11
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_head
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_sect]
    push rax
    mov rax, [rel __g_xwasm_B_SECT]
    push rax
    pop rcx
    sub rsp, 32
    call xv_n
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    lea rax, [rel __g_xwasm_xv_data]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xv_obytes
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_on]
    jmp .__ret_1117
.__ret_1117:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xv_start_body:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_xwasm_xv_body_n], rax
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_XW_DATA_BASE]
    push rax
    pop rcx
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_dsize]
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    mov rcx, 252
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 252
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 9
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_heap_base]
    sub rax, 64
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_heap_base]
    sub rax, 64
    push rax
    pop rcx
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 55
    sub rsp, 32
    call xv_mem
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_heap_base]
    sub rax, 56
    push rax
    pop rcx
    sub rsp, 32
    call xv_i32const
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_dsize]
    push rax
    mov rax, [rel __g_xwasm_XW_DATA_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 55
    sub rsp, 32
    call xv_mem
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_xv_start_fn]
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    jmp .__ret_1152
.__ret_1152:
    mov rsp, rbp
    pop rbp
    ret
xv_thread_body:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov [rel __g_xwasm_xv_body_n], rax
    mov rcx, 0
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 32
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 24
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 125
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 24
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 41
    sub rsp, 32
    call xv_mem
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 32
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 124
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 41
    sub rsp, 32
    call xv_mem
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call xv_gset
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_i64const
    add rsp, 32
    mov rcx, 55
    sub rsp, 32
    call xv_mem
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_gget
    add rsp, 32
    mov rcx, 167
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 17
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call xv_wuleb
    add rsp, 32
    mov rcx, 11
    sub rsp, 32
    call xv_wb
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TB]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xv_set_n
    add rsp, 32
    mov rax, [rel __g_xwasm_B_TB]
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_obuleb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L1154:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xwasm_xv_body_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1155
    mov rax, [rel __g_xwasm_B_TB]
    push rax
    lea rax, [rel __g_xwasm_xv_body]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xv_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_ob
    add rsp, 32
    add rbx, 1
.L1156:
    jmp .L1154
.L1155:
    mov rax, 0
    jmp .__ret_1153
.__ret_1153:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
