; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_xarm_S_OS: dq 0
section .text
section .data
__g_xarm_S_LIB: dq 8
section .text
section .data
__g_xarm_S_IN: dq 16
section .text
section .data
__g_xarm_S_IN_END: dq 24
section .text
section .data
__g_xarm_S_LINE_NO: dq 32
section .text
section .data
__g_xarm_S_ERR: dq 40
section .text
section .data
__g_xarm_S_ERR_LINE: dq 48
section .text
section .data
__g_xarm_S_ERR_MSG: dq 56
section .text
section .data
__g_xarm_S_REST: dq 64
section .text
section .data
__g_xarm_S_NOPS: dq 72
section .text
section .data
__g_xarm_S_SKIPPING: dq 80
section .text
section .data
__g_xarm_S_ERR_INSN: dq 88
section .text
section .data
__g_xarm_S_LINE: dq 248
section .text
section .data
__g_xarm_S_MN: dq 1272
section .text
section .data
__g_xarm_S_OPT: dq 1304
section .text
section .data
__g_xarm_S_OPS: dq 2072
section .text
section .data
__g_xarm_OP_KIND: dq 0
section .text
section .data
__g_xarm_OP_REG: dq 1
section .text
section .data
__g_xarm_OP_RSIZE: dq 2
section .text
section .data
__g_xarm_OP_XMM: dq 3
section .text
section .data
__g_xarm_OP_MSIZE: dq 4
section .text
section .data
__g_xarm_OP_SCALE: dq 5
section .text
section .data
__g_xarm_OP_BASE: dq 6
section .text
section .data
__g_xarm_OP_INDEX: dq 7
section .text
section .data
__g_xarm_OP_VAL: dq 8
section .text
section .data
__g_xarm_OP_REL: dq 16
section .text
section .data
__g_xarm_OP_TEXT: dq 24
section .text
section .data
__g_xarm_K_REG: dq 1
section .text
section .data
__g_xarm_K_XMM: dq 2
section .text
section .data
__g_xarm_K_IMM: dq 3
section .text
section .data
__g_xarm_K_MEM: dq 4
section .text
section .data
__g_xarm_K_LABEL: dq 5
section .text
section .data
__g_xarm_F_NONE: dq 0
section .text
section .data
__g_xarm_F_SUB: dq 1
section .text
section .data
__g_xarm_F_LOGIC: dq 2
section .text
section .data
__g_xarm_F_ADD: dq 3
section .text
section .data
__g_xarm_F_FP: dq 4
section .text
section .data
__g_xarm_xl_st: dq 0
section .text
section .data
__g_xarm_xl_ready: dq 0
section .text
section .data
__g_xarm_xl_out: dq 0
section .text
section .data
__g_xarm_xl_out_end: dq 0
section .text
section .data
__g_xarm_xl_fk: dq 0
section .text
section .data
__g_xarm_xl_fpend: dq 0
section .text
section .data
__g_xarm_xl_fpw: dq 0
section .text
section .data
__g_xarm_xl_uniq: dq 0
section .text
section .data
__g_xarm_xl_mb: dq 0
section .text
section .data
__g_xarm_xl_mo: dq 0
section .text
section .data
__g_xarm_xl_ok: dq 0
section .text
section .data
__g_xarm_xl_rsize: dq 0
section .text
section .data
__g_xarm_xl_rn_next: dq 0
section .text
section .bss
__g_xarm_xl_rn_bufs: resq 4
section .text
section .bss
__g_xarm_xl_nb: resq 4
section .text
section .bss
__g_xarm_xl_tb: resq 4
section .text
section .data
__g_xarm_xl_o1: dq 0
section .text
section .data
__g_xarm_xl_o2: dq 0
section .text
section .data
__g_xarm_xl_o3: dq 0
section .text
section .bss
__g_xarm_xl_rmap: resq 16
section .text
section .bss
__g_xarm_xl_rg_name: resq 64
section .text
section .bss
__g_xarm_xl_rg_num: resq 64
section .text
section .bss
__g_xarm_xl_rg_size: resq 64
section .text
section .data
__g_xarm_xl_rg_n: dq 0
section .text
section .bss
__g_xarm_xl_cc_x86: resq 96
section .text
section .bss
__g_xarm_xl_cc_arm: resq 96
section .text
section .data
__g_xarm_xl_cc_n: dq 0
section .text
section .data
__g_xarm_xl_cc_sub: dq 0
section .text
section .data
__g_xarm_xl_cc_sub_end: dq 0
section .text
section .data
__g_xarm_xl_cc_logic: dq 0
section .text
section .data
__g_xarm_xl_cc_logic_end: dq 0
section .text
section .data
__g_xarm_xl_cc_add: dq 0
section .text
section .data
__g_xarm_xl_cc_add_end: dq 0
section .text
section .data
__g_xarm_xl_cc_fp: dq 0
section .text
section .data
__g_xarm_xl_cc_fp_end: dq 0
section .text
xl_g8:
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
xl_p8:
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
xl_g64:
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
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_p64:
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
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_s:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xarm_xl_st]
    cmp rax, 0
    jne .L5
    sub rsp, 32
    call xa_get_state
    add rsp, 32
    mov [rel __g_xarm_xl_st], rax
    sub rsp, 32
    call xl_init
    add rsp, 32
    jmp .L6
.L5:
.L6:
    mov rax, [rel __g_xarm_xl_st]
    add rax, rbx
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_get:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call xl_s
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_set:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
    call xl_s
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p64
    add rsp, 32
    jmp .__ret_8
.__ret_8:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    lea rax, [rel __g_xarm_xl_rg_name]
    push rax
    mov rax, [rel __g_xarm_xl_rg_n]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rg_num]
    push rax
    mov rax, [rel __g_xarm_xl_rg_n]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rg_size]
    push rax
    mov rax, [rel __g_xarm_xl_rg_n]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, [rel __g_xarm_xl_rg_n]
    add rax, 1
    mov [rel __g_xarm_xl_rg_n], rax
    mov rax, 0
    jmp .__ret_9
.__ret_9:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_cc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    lea rax, [rel __g_xarm_xl_cc_x86]
    push rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_cc_arm]
    push rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, [rel __g_xarm_xl_cc_n]
    add rax, 1
    mov [rel __g_xarm_xl_cc_n], rax
    mov rax, 0
    jmp .__ret_10
.__ret_10:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_cc_eq:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str12: db 101,0
section .text
    lea rax, [rel .str12]
    push rax
section .data
.str13: db 101,113,0
section .text
    lea rax, [rel .str13]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str14: db 122,0
section .text
    lea rax, [rel .str14]
    push rax
section .data
.str15: db 101,113,0
section .text
    lea rax, [rel .str15]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str16: db 110,101,0
section .text
    lea rax, [rel .str16]
    push rax
section .data
.str17: db 110,101,0
section .text
    lea rax, [rel .str17]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str18: db 110,122,0
section .text
    lea rax, [rel .str18]
    push rax
section .data
.str19: db 110,101,0
section .text
    lea rax, [rel .str19]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, 0
    jmp .__ret_11
.__ret_11:
    mov rsp, rbp
    pop rbp
    ret
xl_init:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xarm_xl_ready]
    cmp rax, 0
    je .L21
    mov rax, 0
    jmp .__ret_20
    jmp .L22
.L21:
.L22:
    mov rax, 1
    mov [rel __g_xarm_xl_ready], rax
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 0
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 1
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 2
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 3
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 19
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 4
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 28
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 5
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 29
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 6
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 7
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 5
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 8
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 6
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 9
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 7
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 10
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 11
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 9
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 20
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 21
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 22
    sub rsp, 32
    call xl_p64
    add rsp, 32
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, 15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 23
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, 0
    mov [rel __g_xarm_xl_rg_n], rax
section .data
.str23: db 114,97,120,0
section .text
    lea rax, [rel .str23]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str24: db 114,99,120,0
section .text
    lea rax, [rel .str24]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str25: db 114,100,120,0
section .text
    lea rax, [rel .str25]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str26: db 114,98,120,0
section .text
    lea rax, [rel .str26]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str27: db 114,115,112,0
section .text
    lea rax, [rel .str27]
    push rax
    pop rcx
    mov rdx, 4
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str28: db 114,98,112,0
section .text
    lea rax, [rel .str28]
    push rax
    pop rcx
    mov rdx, 5
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str29: db 114,115,105,0
section .text
    lea rax, [rel .str29]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str30: db 114,100,105,0
section .text
    lea rax, [rel .str30]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str31: db 114,56,0
section .text
    lea rax, [rel .str31]
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str32: db 114,57,0
section .text
    lea rax, [rel .str32]
    push rax
    pop rcx
    mov rdx, 9
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str33: db 114,49,48,0
section .text
    lea rax, [rel .str33]
    push rax
    pop rcx
    mov rdx, 10
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str34: db 114,49,49,0
section .text
    lea rax, [rel .str34]
    push rax
    pop rcx
    mov rdx, 11
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str35: db 114,49,50,0
section .text
    lea rax, [rel .str35]
    push rax
    pop rcx
    mov rdx, 12
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str36: db 114,49,51,0
section .text
    lea rax, [rel .str36]
    push rax
    pop rcx
    mov rdx, 13
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str37: db 114,49,52,0
section .text
    lea rax, [rel .str37]
    push rax
    pop rcx
    mov rdx, 14
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str38: db 114,49,53,0
section .text
    lea rax, [rel .str38]
    push rax
    pop rcx
    mov rdx, 15
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str39: db 101,97,120,0
section .text
    lea rax, [rel .str39]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str40: db 101,99,120,0
section .text
    lea rax, [rel .str40]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str41: db 101,100,120,0
section .text
    lea rax, [rel .str41]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str42: db 101,98,120,0
section .text
    lea rax, [rel .str42]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str43: db 101,115,112,0
section .text
    lea rax, [rel .str43]
    push rax
    pop rcx
    mov rdx, 4
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str44: db 101,98,112,0
section .text
    lea rax, [rel .str44]
    push rax
    pop rcx
    mov rdx, 5
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str45: db 101,115,105,0
section .text
    lea rax, [rel .str45]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str46: db 101,100,105,0
section .text
    lea rax, [rel .str46]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str47: db 114,56,100,0
section .text
    lea rax, [rel .str47]
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str48: db 114,57,100,0
section .text
    lea rax, [rel .str48]
    push rax
    pop rcx
    mov rdx, 9
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str49: db 114,49,48,100,0
section .text
    lea rax, [rel .str49]
    push rax
    pop rcx
    mov rdx, 10
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str50: db 114,49,49,100,0
section .text
    lea rax, [rel .str50]
    push rax
    pop rcx
    mov rdx, 11
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str51: db 114,49,50,100,0
section .text
    lea rax, [rel .str51]
    push rax
    pop rcx
    mov rdx, 12
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str52: db 114,49,51,100,0
section .text
    lea rax, [rel .str52]
    push rax
    pop rcx
    mov rdx, 13
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str53: db 114,49,52,100,0
section .text
    lea rax, [rel .str53]
    push rax
    pop rcx
    mov rdx, 14
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str54: db 114,49,53,100,0
section .text
    lea rax, [rel .str54]
    push rax
    pop rcx
    mov rdx, 15
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str55: db 97,120,0
section .text
    lea rax, [rel .str55]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str56: db 99,120,0
section .text
    lea rax, [rel .str56]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str57: db 100,120,0
section .text
    lea rax, [rel .str57]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str58: db 98,120,0
section .text
    lea rax, [rel .str58]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str59: db 115,105,0
section .text
    lea rax, [rel .str59]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str60: db 100,105,0
section .text
    lea rax, [rel .str60]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str61: db 97,108,0
section .text
    lea rax, [rel .str61]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str62: db 99,108,0
section .text
    lea rax, [rel .str62]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str63: db 100,108,0
section .text
    lea rax, [rel .str63]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str64: db 98,108,0
section .text
    lea rax, [rel .str64]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str65: db 115,105,108,0
section .text
    lea rax, [rel .str65]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str66: db 100,105,108,0
section .text
    lea rax, [rel .str66]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str67: db 114,56,98,0
section .text
    lea rax, [rel .str67]
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str68: db 114,57,98,0
section .text
    lea rax, [rel .str68]
    push rax
    pop rcx
    mov rdx, 9
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str69: db 114,49,48,98,0
section .text
    lea rax, [rel .str69]
    push rax
    pop rcx
    mov rdx, 10
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str70: db 114,49,49,98,0
section .text
    lea rax, [rel .str70]
    push rax
    pop rcx
    mov rdx, 11
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
    mov rax, 0
    mov [rel __g_xarm_xl_cc_n], rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_sub], rax
    sub rsp, 32
    call xl_cc_eq
    add rsp, 32
section .data
.str71: db 108,0
section .text
    lea rax, [rel .str71]
    push rax
section .data
.str72: db 108,116,0
section .text
    lea rax, [rel .str72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str73: db 110,103,101,0
section .text
    lea rax, [rel .str73]
    push rax
section .data
.str74: db 108,116,0
section .text
    lea rax, [rel .str74]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str75: db 108,101,0
section .text
    lea rax, [rel .str75]
    push rax
section .data
.str76: db 108,101,0
section .text
    lea rax, [rel .str76]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str77: db 110,103,0
section .text
    lea rax, [rel .str77]
    push rax
section .data
.str78: db 108,101,0
section .text
    lea rax, [rel .str78]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str79: db 103,0
section .text
    lea rax, [rel .str79]
    push rax
section .data
.str80: db 103,116,0
section .text
    lea rax, [rel .str80]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str81: db 110,108,101,0
section .text
    lea rax, [rel .str81]
    push rax
section .data
.str82: db 103,116,0
section .text
    lea rax, [rel .str82]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str83: db 103,101,0
section .text
    lea rax, [rel .str83]
    push rax
section .data
.str84: db 103,101,0
section .text
    lea rax, [rel .str84]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str85: db 110,108,0
section .text
    lea rax, [rel .str85]
    push rax
section .data
.str86: db 103,101,0
section .text
    lea rax, [rel .str86]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str87: db 98,0
section .text
    lea rax, [rel .str87]
    push rax
section .data
.str88: db 108,111,0
section .text
    lea rax, [rel .str88]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str89: db 99,0
section .text
    lea rax, [rel .str89]
    push rax
section .data
.str90: db 108,111,0
section .text
    lea rax, [rel .str90]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str91: db 110,97,101,0
section .text
    lea rax, [rel .str91]
    push rax
section .data
.str92: db 108,111,0
section .text
    lea rax, [rel .str92]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str93: db 98,101,0
section .text
    lea rax, [rel .str93]
    push rax
section .data
.str94: db 108,115,0
section .text
    lea rax, [rel .str94]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str95: db 110,97,0
section .text
    lea rax, [rel .str95]
    push rax
section .data
.str96: db 108,115,0
section .text
    lea rax, [rel .str96]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str97: db 97,0
section .text
    lea rax, [rel .str97]
    push rax
section .data
.str98: db 104,105,0
section .text
    lea rax, [rel .str98]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str99: db 110,98,101,0
section .text
    lea rax, [rel .str99]
    push rax
section .data
.str100: db 104,105,0
section .text
    lea rax, [rel .str100]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str101: db 97,101,0
section .text
    lea rax, [rel .str101]
    push rax
section .data
.str102: db 104,115,0
section .text
    lea rax, [rel .str102]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str103: db 110,98,0
section .text
    lea rax, [rel .str103]
    push rax
section .data
.str104: db 104,115,0
section .text
    lea rax, [rel .str104]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str105: db 110,99,0
section .text
    lea rax, [rel .str105]
    push rax
section .data
.str106: db 104,115,0
section .text
    lea rax, [rel .str106]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str107: db 115,0
section .text
    lea rax, [rel .str107]
    push rax
section .data
.str108: db 109,105,0
section .text
    lea rax, [rel .str108]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str109: db 110,115,0
section .text
    lea rax, [rel .str109]
    push rax
section .data
.str110: db 112,108,0
section .text
    lea rax, [rel .str110]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_sub_end], rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_logic], rax
    sub rsp, 32
    call xl_cc_eq
    add rsp, 32
section .data
.str111: db 115,0
section .text
    lea rax, [rel .str111]
    push rax
section .data
.str112: db 109,105,0
section .text
    lea rax, [rel .str112]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str113: db 110,115,0
section .text
    lea rax, [rel .str113]
    push rax
section .data
.str114: db 112,108,0
section .text
    lea rax, [rel .str114]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str115: db 108,0
section .text
    lea rax, [rel .str115]
    push rax
section .data
.str116: db 108,116,0
section .text
    lea rax, [rel .str116]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str117: db 103,101,0
section .text
    lea rax, [rel .str117]
    push rax
section .data
.str118: db 103,101,0
section .text
    lea rax, [rel .str118]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str119: db 108,101,0
section .text
    lea rax, [rel .str119]
    push rax
section .data
.str120: db 108,101,0
section .text
    lea rax, [rel .str120]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str121: db 103,0
section .text
    lea rax, [rel .str121]
    push rax
section .data
.str122: db 103,116,0
section .text
    lea rax, [rel .str122]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_logic_end], rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_add], rax
    sub rsp, 32
    call xl_cc_eq
    add rsp, 32
section .data
.str123: db 115,0
section .text
    lea rax, [rel .str123]
    push rax
section .data
.str124: db 109,105,0
section .text
    lea rax, [rel .str124]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str125: db 110,115,0
section .text
    lea rax, [rel .str125]
    push rax
section .data
.str126: db 112,108,0
section .text
    lea rax, [rel .str126]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_add_end], rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_fp], rax
    sub rsp, 32
    call xl_cc_eq
    add rsp, 32
section .data
.str127: db 97,0
section .text
    lea rax, [rel .str127]
    push rax
section .data
.str128: db 103,116,0
section .text
    lea rax, [rel .str128]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str129: db 110,98,101,0
section .text
    lea rax, [rel .str129]
    push rax
section .data
.str130: db 103,116,0
section .text
    lea rax, [rel .str130]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str131: db 97,101,0
section .text
    lea rax, [rel .str131]
    push rax
section .data
.str132: db 103,101,0
section .text
    lea rax, [rel .str132]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str133: db 110,98,0
section .text
    lea rax, [rel .str133]
    push rax
section .data
.str134: db 103,101,0
section .text
    lea rax, [rel .str134]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str135: db 110,99,0
section .text
    lea rax, [rel .str135]
    push rax
section .data
.str136: db 103,101,0
section .text
    lea rax, [rel .str136]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str137: db 98,0
section .text
    lea rax, [rel .str137]
    push rax
section .data
.str138: db 108,116,0
section .text
    lea rax, [rel .str138]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str139: db 99,0
section .text
    lea rax, [rel .str139]
    push rax
section .data
.str140: db 108,116,0
section .text
    lea rax, [rel .str140]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str141: db 98,101,0
section .text
    lea rax, [rel .str141]
    push rax
section .data
.str142: db 108,101,0
section .text
    lea rax, [rel .str142]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str143: db 110,97,0
section .text
    lea rax, [rel .str143]
    push rax
section .data
.str144: db 108,101,0
section .text
    lea rax, [rel .str144]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_fp_end], rax
    mov rax, 0
    jmp .__ret_20
.__ret_20:
    mov rsp, rbp
    pop rbp
    ret
xl_skipb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rbx, rax
.L146:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 32
    jne .L147
    add rbx, 1
.L148:
    jmp .L146
.L147:
    mov rax, rbx
    jmp .__ret_145
.__ret_145:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_streq:
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
.L150:
    mov rax, 1
    test rax, rax
    jz .L151
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L153
    mov rax, 0
    jmp .__ret_149
    jmp .L154
.L153:
.L154:
    cmp rbx, 0
    jne .L155
    mov rax, 1
    jmp .__ret_149
    jmp .L156
.L155:
.L156:
    add r12, 1
.L152:
    jmp .L150
.L151:
    mov rax, 0
    jmp .__ret_149
.__ret_149:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_prefix:
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
.L158:
    mov rax, 1
    test rax, rax
    jz .L159
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L161
    mov rax, 1
    jmp .__ret_157
    jmp .L162
.L161:
.L162:
    mov rax, rbx
    push rax
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L163
    mov rax, 0
    jmp .__ret_157
    jmp .L164
.L163:
.L164:
    add r12, 1
.L160:
    jmp .L158
.L159:
    mov rax, 0
    jmp .__ret_157
.__ret_157:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_fail:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rax, [rel __g_xarm_S_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 0
    je .L166
    mov rax, 0
    jmp .__ret_165
    jmp .L167
.L166:
.L167:
    mov rax, [rel __g_xarm_S_ERR]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR_MSG]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR_LINE]
    push rax
    mov rax, [rel __g_xarm_S_LINE_NO]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_xarm_S_ERR_INSN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L168:
    mov rax, 1
    test rax, rax
    jz .L169
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    cmp rbx, 0
    jne .L171
    mov rax, 0
    jmp .__ret_165
    jmp .L172
.L171:
.L172:
    add r12, 1
    cmp r12, 150
    jl .L173
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_165
    jmp .L174
.L173:
.L174:
.L170:
    jmp .L168
.L169:
    mov rax, 0
    jmp .__ret_165
.__ret_165:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_read_line:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rax, [rel __g_xarm_S_IN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    mov r15, rax
    mov rax, [rel __g_xarm_S_IN_END]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    mov [rbp-16], rax
    mov rax, r15
    mov rcx, [rbp-16]
    cmp rax, rcx
    jl .L176
    mov rax, 0
    jmp .__ret_175
    jmp .L177
.L176:
.L177:
    mov rax, [rel __g_xarm_S_LINE_NO]
    push rax
    mov rax, [rel __g_xarm_S_LINE_NO]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov [rbp-24], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
.L178:
    mov rax, r15
    mov rcx, [rbp-16]
    cmp rax, rcx
    jge .L179
    mov rcx, r15
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    add r15, 1
    cmp r12, 10
    jne .L181
    jmp .L179
    jmp .L182
.L181:
.L182:
    mov rax, 1
    mov rbx, rax
    mov rax, r12
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L185
    mov rax, [rbp-48]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L185
    mov rax, 0
    jmp .L186
.L185:
    mov rax, 1
.L186:
    test rax, rax
    jz .L183
    mov rax, 0
    mov rbx, rax
    jmp .L184
.L183:
    cmp r13, 0
    je .L187
    cmp r12, r13
    jne .L189
    mov rax, 0
    mov r13, rax
    jmp .L190
.L189:
.L190:
    jmp .L188
.L187:
    cmp r12, 59
    jne .L191
    mov rax, 1
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
    jmp .L192
.L191:
    mov rax, r12
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L195
    mov rax, r12
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L195
    mov rax, 0
    jmp .L196
.L195:
    mov rax, 1
.L196:
    test rax, rax
    jz .L193
    mov rax, r12
    mov r13, rax
    jmp .L194
.L193:
    cmp r12, 9
    jne .L197
    mov rax, 32
    mov r12, rax
    jmp .L198
.L197:
.L198:
.L194:
.L192:
.L188:
.L184:
    cmp rbx, 0
    je .L199
    cmp r14, 1000
    jl .L201
    mov rax, 1
    mov [rbp-56], rax
    jmp .L202
.L201:
    mov rax, [rbp-24]
    add rax, r14
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r14, 1
.L202:
    jmp .L200
.L199:
.L200:
.L180:
    jmp .L178
.L179:
    mov rax, [rel __g_xarm_S_IN]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call xl_set
    add rsp, 32
.L203:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L206
    mov rax, [rbp-24]
    add rax, r14
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L206
    mov rax, 1
    jmp .L207
.L206:
    mov rax, 0
.L207:
    test rax, rax
    jz .L204
    sub r14, 1
.L205:
    jmp .L203
.L204:
    mov rax, [rbp-24]
    add rax, r14
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rbp-56]
    cmp rax, 0
    je .L208
section .data
.str210: db 108,105,110,101,32,108,111,110,103,101,114,32,116,104,97,110,32,49,48,48,48,32,99,104,97,114,97,99,116,101,114,115,0
section .text
    lea rax, [rel .str210]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .L209
.L208:
.L209:
    mov rax, 1
    jmp .__ret_175
.__ret_175:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
xl_native_skip:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_xarm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
section .data
.str214: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str214]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L212
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 0
    jmp .__ret_211
    jmp .L213
.L212:
.L213:
    mov rcx, r13
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 46
    jne .L215
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    jmp .__ret_211
    jmp .L216
.L215:
.L216:
    mov rax, r13
    mov r12, rax
.L217:
    mov rax, 1
    test rax, rax
    jz .L218
    mov rcx, r12
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L222
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L222
    mov rax, 0
    jmp .L223
.L222:
    mov rax, 1
.L223:
    test rax, rax
    jz .L220
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    jmp .__ret_211
    jmp .L221
.L220:
.L221:
    cmp rbx, 58
    jne .L224
    jmp .L218
    jmp .L225
.L224:
.L225:
    add r12, 1
.L219:
    jmp .L217
.L218:
    mov rax, r13
    push rax
section .data
.str232: db 95,95,99,99,97,108,108,58,0
section .text
    lea rax, [rel .str232]
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
    jnz .L230
    mov rax, r13
    push rax
section .data
.str233: db 95,95,112,116,95,101,110,116,114,121,58,0
section .text
    lea rax, [rel .str233]
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
    jnz .L230
    mov rax, 0
    jmp .L231
.L230:
    mov rax, 1
.L231:
    test rax, rax
    jnz .L228
    mov rax, r13
    push rax
section .data
.str234: db 95,95,99,101,110,116,114,121,58,0
section .text
    lea rax, [rel .str234]
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
    jnz .L228
    mov rax, 0
    jmp .L229
.L228:
    mov rax, 1
.L229:
    test rax, rax
    jz .L226
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 2
    jmp .__ret_211
    jmp .L227
.L226:
.L227:
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 0
    jmp .__ret_211
.__ret_211:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_put:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
.L236:
    mov rax, 1
    test rax, rax
    jz .L237
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L239
    jmp .L237
    jmp .L240
.L239:
.L240:
    mov rax, [rel __g_xarm_xl_out]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rel __g_xarm_xl_out]
    add rax, 1
    mov [rel __g_xarm_xl_out], rax
    add r12, 1
.L238:
    jmp .L236
.L237:
    mov rax, 0
    jmp .__ret_235
.__ret_235:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_putc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xarm_xl_out]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rel __g_xarm_xl_out]
    add rax, 1
    mov [rel __g_xarm_xl_out], rax
    mov rax, 0
    jmp .__ret_241
.__ret_241:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_put_dec:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    lea rax, [rel __g_xarm_xl_nb]
    mov r13, rax
    mov rax, 31
    mov r12, rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, rbx
    mov rbx, rax
    cmp rbx, 0
    jge .L243
    mov rcx, 45
    sub rsp, 32
    call xl_putc
    add rsp, 32
.L245:
    mov rax, 1
    test rax, rax
    jz .L246
    sub r12, 1
    mov rax, r13
    add rax, r12
    push rax
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, rax
    mov rax, 48
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rbx, rax
    cmp rbx, 0
    jne .L248
    jmp .L246
    jmp .L249
.L248:
.L249:
.L247:
    jmp .L245
.L246:
    jmp .L244
.L243:
.L250:
    mov rax, 1
    test rax, rax
    jz .L251
    sub r12, 1
    mov rax, r13
    add rax, r12
    push rax
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, rax
    mov rax, 48
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rbx, rax
    cmp rbx, 0
    jne .L253
    jmp .L251
    jmp .L254
.L253:
.L254:
.L252:
    jmp .L250
.L251:
.L244:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .__ret_242
.__ret_242:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_put_hex:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rcx, 48
    sub rsp, 32
    call xl_putc
    add rsp, 32
    mov rcx, 120
    sub rsp, 32
    call xl_putc
    add rsp, 32
    lea rax, [rel __g_xarm_xl_nb]
    mov r14, rax
    mov rax, 31
    mov r13, rax
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, rbx
    mov r12, rax
.L256:
    mov rax, 1
    test rax, rax
    jz .L257
    mov rax, r12
    and rax, 15
    mov rbx, rax
    sub r13, 1
    cmp rbx, 10
    jge .L259
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 48
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    jmp .L260
.L259:
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 87
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
.L260:
    mov rax, r12
    shr rax, 4
    mov r12, rax
    cmp r12, 0
    jne .L261
    jmp .L257
    jmp .L262
.L261:
.L262:
.L258:
    jmp .L256
.L257:
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .__ret_255
.__ret_255:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_put_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov rcx, 31
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L266
    mov rax, r12
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L268
    mov rax, r12
    mov rcx, 119
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L268
    mov rax, 0
    jmp .L269
.L268:
    mov rax, 1
.L269:
    test rax, rax
    jz .L266
    mov rax, 1
    jmp .L267
.L266:
    mov rax, 0
.L267:
    test rax, rax
    jz .L264
    mov rcx, r12
    sub rsp, 32
    call xl_putc
    add rsp, 32
    mov rcx, 122
    sub rsp, 32
    call xl_putc
    add rsp, 32
    mov rcx, 114
    sub rsp, 32
    call xl_putc
    add rsp, 32
    mov rax, 0
    jmp .__ret_263
    jmp .L265
.L264:
.L265:
    mov rcx, r12
    sub rsp, 32
    call xl_putc
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xl_put_dec
    add rsp, 32
    jmp .__ret_263
.__ret_263:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_fmt:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov [rbp-32], r9
    mov [rbp-40], r10
    mov [rbp-48], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L271:
    mov rax, 1
    test rax, rax
    jz .L272
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L274
    jmp .L272
    jmp .L275
.L274:
.L275:
    add r14, 1
    cmp r12, 37
    je .L276
    mov rcx, r12
    sub rsp, 32
    call xl_putc
    add rsp, 32
    jmp .L277
.L276:
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    add r14, 1
    mov rax, [rbp-16]
    mov rbx, rax
    cmp r13, 1
    jne .L278
    mov rax, [rbp-24]
    mov rbx, rax
    jmp .L279
.L278:
.L279:
    cmp r13, 2
    jne .L280
    mov rax, [rbp-32]
    mov rbx, rax
    jmp .L281
.L280:
.L281:
    cmp r13, 3
    jne .L282
    mov rax, [rbp-40]
    mov rbx, rax
    jmp .L283
.L282:
.L283:
    cmp r13, 4
    jne .L284
    mov rax, [rbp-48]
    mov rbx, rax
    jmp .L285
.L284:
.L285:
    add r13, 1
    cmp r12, 100
    jne .L286
    mov rcx, rbx
    sub rsp, 32
    call xl_put_dec
    add rsp, 32
    jmp .L287
.L286:
    cmp r12, 104
    jne .L288
    mov rcx, rbx
    sub rsp, 32
    call xl_put_hex
    add rsp, 32
    jmp .L289
.L288:
    cmp r12, 115
    jne .L290
    mov rcx, rbx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .L291
.L290:
    cmp r12, 68
    jne .L292
    mov rcx, 100
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    jmp .L293
.L292:
    cmp r12, 81
    jne .L294
    mov rcx, 113
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    jmp .L295
.L294:
    cmp r12, 86
    jne .L296
    mov rcx, 118
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    jmp .L297
.L296:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
.L297:
.L295:
.L293:
.L291:
.L289:
.L287:
.L277:
.L273:
    jmp .L271
.L272:
    mov rax, 0
    jmp .__ret_270
.__ret_270:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
xl_f0:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    mov rdx, 0
    mov r8, 0
    mov r9, 0
    mov r10, 0
    mov rax, 0
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_298
.__ret_298:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_f1:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    mov r9, 0
    mov r10, 0
    mov rax, 0
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_299
.__ret_299:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_f2:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    mov r9, 0
    mov r10, 0
    mov rax, 0
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_300
.__ret_300:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_f3:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rbx, r9
    mov rcx, r14
    mov rdx, r13
    mov r8, r12
    mov r9, rbx
    mov r10, 0
    mov rax, 0
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_301
.__ret_301:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_f4:
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
    mov r13, r8
    mov r12, r9
    mov rbx, r10
    mov rcx, r15
    mov rdx, r14
    mov r8, r13
    mov r9, r12
    mov r10, rbx
    mov rax, 0
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_302
.__ret_302:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xl_do_line:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov rax, [rel __g_xarm_S_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov r15, rax
    mov rcx, r15
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    jne .L304
    mov rax, 0
    jmp .__ret_303
    jmp .L305
.L304:
.L305:
    mov rax, rbx
    mov [rbp-24], rax
    mov rax, rbx
    mov r14, rax
.L306:
    mov rax, 1
    test rax, rax
    jz .L307
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L311
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L311
    mov rax, 0
    jmp .L312
.L311:
    mov rax, 1
.L312:
    test rax, rax
    jz .L309
    jmp .L307
    jmp .L310
.L309:
.L310:
    cmp rbx, 58
    jne .L313
    mov rcx, r14
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rcx, [rbp-24]
    sub rsp, 32
    call xl_put
    add rsp, 32
section .data
.str315: db 58,10,0
section .text
    lea rax, [rel .str315]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, [rbp-24]
    push rax
section .data
.str318: db 95,115,116,97,114,116,0
section .text
    lea rax, [rel .str318]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L316
section .data
.str319: db 32,32,32,32,109,111,118,32,120,50,56,44,32,115,112,10,0
section .text
    lea rax, [rel .str319]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .L317
.L316:
.L317:
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    jne .L320
    mov rax, 0
    jmp .__ret_303
    jmp .L321
.L320:
.L321:
    mov rax, r15
    mov r12, rax
.L322:
    mov rax, 1
    test rax, rax
    jz .L323
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r14, 1
    add r12, 1
    cmp rbx, 0
    jne .L325
    jmp .L323
    jmp .L326
.L325:
.L326:
.L324:
    jmp .L322
.L323:
    mov rax, r15
    mov r14, rax
    mov rax, r15
    mov [rbp-24], rax
    jmp .L314
.L313:
    add r14, 1
.L314:
.L308:
    jmp .L306
.L307:
    mov rax, r14
    mov rcx, [rbp-24]
    sub rax, rcx
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 30
    jle .L327
    mov rax, 30
    mov [rbp-64], rax
    jmp .L328
.L327:
.L328:
    mov rax, [rel __g_xarm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L329:
    mov rax, r12
    mov rcx, [rbp-64]
    cmp rax, rcx
    jge .L330
    mov rax, [rbp-24]
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L334
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L334
    mov rax, 1
    jmp .L335
.L334:
    mov rax, 0
.L335:
    test rax, rax
    jz .L332
    add rbx, 32
    jmp .L333
.L332:
.L333:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r12, 1
.L331:
    jmp .L329
.L330:
    mov rax, r13
    mov rcx, [rbp-64]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rel __g_xarm_S_REST]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str342: db 100,101,102,97,117,108,116,0
section .text
    lea rax, [rel .str342]
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
    jnz .L340
    mov rax, r13
    push rax
section .data
.str343: db 98,105,116,115,0
section .text
    lea rax, [rel .str343]
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
    jnz .L340
    mov rax, 0
    jmp .L341
.L340:
    mov rax, 1
.L341:
    test rax, rax
    jnz .L338
    mov rax, r13
    push rax
section .data
.str344: db 101,120,116,101,114,110,0
section .text
    lea rax, [rel .str344]
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
    jnz .L338
    mov rax, 0
    jmp .L339
.L338:
    mov rax, 1
.L339:
    test rax, rax
    jz .L336
    mov rax, 0
    jmp .__ret_303
    jmp .L337
.L336:
.L337:
    mov rax, r13
    push rax
section .data
.str347: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str347]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L345
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rcx, r15
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
section .data
.str348: db 10,0
section .text
    lea rax, [rel .str348]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_303
    jmp .L346
.L345:
.L346:
    mov rax, r13
    push rax
section .data
.str351: db 103,108,111,98,97,108,0
section .text
    lea rax, [rel .str351]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L349
    mov rcx, r15
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
section .data
.str352: db 10,0
section .text
    lea rax, [rel .str352]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_303
    jmp .L350
.L349:
.L350:
    mov rcx, r13
    sub rsp, 32
    call xl_is_data
    add rsp, 32
    cmp rax, 0
    je .L353
section .data
.str355: db 32,32,32,32,0
section .text
    lea rax, [rel .str355]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
section .data
.str356: db 10,0
section .text
    lea rax, [rel .str356]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_303
    jmp .L354
.L353:
.L354:
    sub rsp, 32
    call xl_split
    add rsp, 32
    sub rsp, 32
    call xl_parse_ops
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 0
    je .L357
    mov rax, 0
    jmp .__ret_303
    jmp .L358
.L357:
.L358:
    mov rax, [rel __g_xarm_S_OPS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov [rel __g_xarm_xl_o1], rax
    mov rax, [rel __g_xarm_xl_o1]
    add rax, 32
    mov [rel __g_xarm_xl_o2], rax
    mov rax, [rel __g_xarm_xl_o1]
    add rax, 64
    mov [rel __g_xarm_xl_o3], rax
    sub rsp, 32
    call xl_insn
    add rsp, 32
    mov rax, 0
    jmp .__ret_303
.__ret_303:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
xl_is_data:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str362: db 100,98,0
section .text
    lea rax, [rel .str362]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L360
    mov rax, 1
    jmp .__ret_359
    jmp .L361
.L360:
.L361:
    mov rax, rbx
    push rax
section .data
.str365: db 100,119,0
section .text
    lea rax, [rel .str365]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L363
    mov rax, 1
    jmp .__ret_359
    jmp .L364
.L363:
.L364:
    mov rax, rbx
    push rax
section .data
.str368: db 100,100,0
section .text
    lea rax, [rel .str368]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L366
    mov rax, 1
    jmp .__ret_359
    jmp .L367
.L366:
.L367:
    mov rax, rbx
    push rax
section .data
.str371: db 100,113,0
section .text
    lea rax, [rel .str371]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L369
    mov rax, 1
    jmp .__ret_359
    jmp .L370
.L369:
.L370:
    mov rax, rbx
    push rax
section .data
.str374: db 114,101,115,98,0
section .text
    lea rax, [rel .str374]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L372
    mov rax, 1
    jmp .__ret_359
    jmp .L373
.L372:
.L373:
    mov rax, rbx
    push rax
section .data
.str377: db 114,101,115,119,0
section .text
    lea rax, [rel .str377]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L375
    mov rax, 1
    jmp .__ret_359
    jmp .L376
.L375:
.L376:
    mov rax, rbx
    push rax
section .data
.str380: db 114,101,115,100,0
section .text
    lea rax, [rel .str380]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L378
    mov rax, 1
    jmp .__ret_359
    jmp .L379
.L378:
.L379:
    mov rax, rbx
    push rax
section .data
.str383: db 114,101,115,113,0
section .text
    lea rax, [rel .str383]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L381
    mov rax, 1
    jmp .__ret_359
    jmp .L382
.L381:
.L382:
    mov rax, rbx
    push rax
section .data
.str386: db 116,105,109,101,115,0
section .text
    lea rax, [rel .str386]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L384
    mov rax, 1
    jmp .__ret_359
    jmp .L385
.L384:
.L385:
    mov rax, rbx
    push rax
section .data
.str389: db 97,108,105,103,110,0
section .text
    lea rax, [rel .str389]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L387
    mov rax, 1
    jmp .__ret_359
    jmp .L388
.L387:
.L388:
    mov rax, rbx
    push rax
section .data
.str392: db 101,113,117,0
section .text
    lea rax, [rel .str392]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L390
    mov rax, 1
    jmp .__ret_359
    jmp .L391
.L390:
.L391:
    mov rax, 0
    jmp .__ret_359
.__ret_359:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_split_fin:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov rbx, rax
.L394:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L397
    mov rax, r12
    add rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L397
    mov rax, 1
    jmp .L398
.L397:
    mov rax, 0
.L398:
    test rax, rax
    jz .L395
    sub rbx, 1
.L396:
    jmp .L394
.L395:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_393
.__ret_393:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_split:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rax, [rel __g_xarm_S_OPT]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov [rbp-8], rax
    mov rcx, [rbp-8]
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rbp-8]
    add rax, 256
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rbp-8]
    add rax, 512
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rel __g_xarm_S_NOPS]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_REST]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r15, rax
    mov rcx, r15
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    jne .L400
    mov rax, 0
    jmp .__ret_399
    jmp .L401
.L400:
.L401:
    mov rax, 0
    mov r14, rax
.L402:
    mov rax, 1
    test rax, rax
    jz .L403
    cmp r14, 3
    jl .L405
section .data
.str407: db 110,111,32,65,82,77,54,52,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str407]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_399
    jmp .L406
.L405:
.L406:
    mov rax, r14
    mov rcx, 256
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-8]
    add rax, rcx
    mov [rbp-32], rax
    mov rcx, r15
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-64], rax
.L408:
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L409
    mov rcx, r15
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L411
    mov rcx, [rbp-32]
    mov rdx, r13
    sub rsp, 32
    call xl_split_fin
    add rsp, 32
    mov rax, [rel __g_xarm_S_NOPS]
    push rax
    mov rax, r14
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 0
    jmp .__ret_399
    jmp .L412
.L411:
.L412:
    mov rax, [rbp-48]
    cmp rax, 0
    je .L413
    mov rax, rbx
    mov rcx, [rbp-48]
    cmp rax, rcx
    jne .L415
    mov rax, 0
    mov [rbp-48], rax
    jmp .L416
.L415:
.L416:
    jmp .L414
.L413:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L419
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L419
    mov rax, 0
    jmp .L420
.L419:
    mov rax, 1
.L420:
    test rax, rax
    jz .L417
    mov rax, rbx
    mov [rbp-48], rax
    jmp .L418
.L417:
    cmp rbx, 91
    jne .L421
    add r12, 1
    jmp .L422
.L421:
    cmp rbx, 93
    jne .L423
    sub r12, 1
    jmp .L424
.L423:
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L427
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L427
    mov rax, 1
    jmp .L428
.L427:
    mov rax, 0
.L428:
    test rax, rax
    jz .L425
    mov rax, 1
    mov [rbp-64], rax
    jmp .L426
.L425:
.L426:
.L424:
.L422:
.L418:
.L414:
    mov rax, [rbp-64]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L431
    mov rax, r13
    mov rcx, 250
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L431
    mov rax, 1
    jmp .L432
.L431:
    mov rax, 0
.L432:
    test rax, rax
    jz .L429
    mov rax, [rbp-32]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r13, 1
    jmp .L430
.L429:
.L430:
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L433
    add r15, 1
    jmp .L434
.L433:
.L434:
.L410:
    jmp .L408
.L409:
    mov rcx, [rbp-32]
    mov rdx, r13
    sub rsp, 32
    call xl_split_fin
    add rsp, 32
    add r15, 1
    add r14, 1
.L404:
    jmp .L402
.L403:
    mov rax, 0
    jmp .__ret_399
.__ret_399:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
xl_parse_ops:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, [rel __g_xarm_S_OPS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L436:
    cmp rbx, 96
    jge .L437
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add rbx, 1
.L438:
    jmp .L436
.L437:
    mov rax, 0
    mov rbx, rax
.L439:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_S_NOPS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L440
    mov rax, [rel __g_xarm_S_OPT]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    push rax
    mov rax, rbx
    mov rcx, 256
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 32
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_parse_op
    add rsp, 32
    add rbx, 1
.L441:
    jmp .L439
.L440:
    mov rax, 0
    jmp .__ret_435
.__ret_435:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_sizeword:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    jne .L443
    mov rax, 0
    jmp .__ret_442
    jmp .L444
.L443:
.L444:
    mov rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L445:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    je .L446
    add r12, 1
    add rbx, 1
.L447:
    jmp .L445
.L446:
    mov rcx, r12
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 32
    je .L448
    mov rax, 0
    jmp .__ret_442
    jmp .L449
.L448:
.L449:
    mov rax, r12
    jmp .__ret_442
.__ret_442:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_parse_op:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov [rbp-176], r15
    mov rbx, rcx
    mov r15, rdx
    mov rax, rbx
    mov r14, rax
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 255
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 255
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_SCALE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 8
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str451: db 113,119,111,114,100,0
section .text
    lea rax, [rel .str451]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L452
    mov rax, 4
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str454: db 100,119,111,114,100,0
section .text
    lea rax, [rel .str454]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    jmp .L453
.L452:
.L453:
    cmp rbx, 0
    jne .L455
    mov rax, 16
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str457: db 111,119,111,114,100,0
section .text
    lea rax, [rel .str457]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    jmp .L456
.L455:
.L456:
    cmp rbx, 0
    jne .L458
    mov rax, 2
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str460: db 119,111,114,100,0
section .text
    lea rax, [rel .str460]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    jmp .L459
.L458:
.L459:
    cmp rbx, 0
    jne .L461
    mov rax, 1
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str463: db 98,121,116,101,0
section .text
    lea rax, [rel .str463]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    jmp .L462
.L461:
.L462:
    cmp rbx, 0
    je .L464
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r14, rax
    jmp .L465
.L464:
.L465:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 91
    je .L466
    mov rcx, r14
    sub rsp, 32
    call xl_find_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L468
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_RSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xarm_xl_rsize]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L469
.L468:
.L469:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L474
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 109
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L474
    mov rax, 1
    jmp .L475
.L474:
    mov rax, 0
.L475:
    test rax, rax
    jz .L472
    mov rax, r14
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 109
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L472
    mov rax, 1
    jmp .L473
.L472:
    mov rax, 0
.L473:
    test rax, rax
    jz .L470
    mov rax, r14
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_ok]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L480
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L480
    mov rax, 1
    jmp .L481
.L480:
    mov rax, 0
.L481:
    test rax, rax
    jz .L478
    mov rax, rbx
    mov rcx, 15
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L478
    mov rax, 1
    jmp .L479
.L478:
    mov rax, 0
.L479:
    test rax, rax
    jz .L476
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_XMM]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L477
.L476:
.L477:
    jmp .L471
.L470:
.L471:
    mov rcx, r14
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_ok]
    cmp rax, 0
    je .L482
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_VAL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L483
.L482:
.L483:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xarm_K_LABEL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L467
.L466:
.L467:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r14, rax
    mov rax, r14
    mov rbx, rax
.L484:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L487
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 93
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L487
    mov rax, 1
    jmp .L488
.L487:
    mov rax, 0
.L488:
    test rax, rax
    jz .L485
    add rbx, 1
.L486:
    jmp .L484
.L485:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 93
    jne .L489
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    jmp .L490
.L489:
.L490:
.L491:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L494
    mov rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L494
    mov rax, 1
    jmp .L495
.L494:
    mov rax, 0
.L495:
    test rax, rax
    jz .L492
    sub rbx, 1
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
.L493:
    jmp .L491
.L492:
    mov rax, r14
    push rax
section .data
.str498: db 114,101,108,32,0
section .text
    lea rax, [rel .str498]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L496
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_REL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L497
.L496:
.L497:
    mov rax, r14
    mov [rbp-80], rax
    mov rax, 0
    mov r13, rax
    lea rax, [rel __g_xarm_xl_tb]
    mov r12, rax
.L499:
    mov rax, 1
    test rax, rax
    jz .L500
    mov rcx, r14
    sub rsp, 32
    call xl_skipb
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L502
    mov rax, 0
    jmp .__ret_450
    jmp .L503
.L502:
.L503:
    cmp rbx, 43
    jne .L504
    add r14, 1
    mov rax, 0
    mov r13, rax
    jmp .L505
.L504:
    cmp rbx, 45
    jne .L506
    add r14, 1
    mov rax, 1
    mov r13, rax
    jmp .L507
.L506:
    mov rax, 0
    mov [rbp-112], rax
.L508:
    mov rax, 1
    test rax, rax
    jz .L509
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L515
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L515
    mov rax, 0
    jmp .L516
.L515:
    mov rax, 1
.L516:
    test rax, rax
    jnz .L513
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L513
    mov rax, 0
    jmp .L514
.L513:
    mov rax, 1
.L514:
    test rax, rax
    jz .L511
    jmp .L509
    jmp .L512
.L511:
.L512:
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L519
    mov rax, [rbp-112]
    mov rcx, 30
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L519
    mov rax, 1
    jmp .L520
.L519:
    mov rax, 0
.L520:
    test rax, rax
    jz .L517
    mov rax, r12
    mov rcx, [rbp-112]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, [rbp-112]
    add rax, 1
    mov [rbp-112], rax
    jmp .L518
.L517:
.L518:
    add r14, 1
.L510:
    jmp .L508
.L509:
    mov rax, r12
    mov rcx, [rbp-112]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, r12
    mov rbx, rax
.L521:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L524
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 42
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L524
    mov rax, 1
    jmp .L525
.L524:
    mov rax, 0
.L525:
    test rax, rax
    jz .L522
    add rbx, 1
.L523:
    jmp .L521
.L522:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 42
    jne .L526
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call xl_find_reg
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L528
section .data
.str530: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str530]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L529
.L528:
.L529:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_ok]
    cmp rax, 0
    jne .L531
section .data
.str533: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str533]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L532
.L531:
.L532:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_SCALE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    mov r13, rax
    jmp .L527
.L526:
    mov rcx, r12
    sub rsp, 32
    call xl_find_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L534
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 255
    jne .L536
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    jmp .L537
.L536:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
.L537:
    mov rax, 0
    mov r13, rax
    jmp .L535
.L534:
    mov rcx, r12
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_ok]
    cmp rax, 0
    je .L538
    cmp r13, 0
    je .L540
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L541
.L540:
.L541:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_VAL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_VAL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, 0
    mov r13, rax
    jmp .L539
.L538:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 255
    je .L542
section .data
.str544: db 97,32,108,97,98,101,108,32,97,110,100,32,97,32,114,101,103,105,115,116,101,114,32,105,110,32,111,110,101,32,109,101,109,111,114,121,32,111,112,101,114,97,110,100,0
section .text
    lea rax, [rel .str544]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
    jmp .L543
.L542:
.L543:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_REL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, [rbp-80]
    sub rsp, 32
    call xl_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_450
.L539:
.L535:
.L527:
.L507:
.L505:
.L501:
    jmp .L499
.L500:
    mov rax, 0
    jmp .__ret_450
.__ret_450:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov r15, [rbp-176]
    mov rsp, rbp
    pop rbp
    ret
xl_find_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    sub rsp, 32
    call xl_init
    add rsp, 32
    mov rax, 0
    mov r15, rax
.L546:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_xl_rg_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L547
    lea rax, [rel __g_xarm_xl_rg_name]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    mov [rbp-24], rax
    mov rax, 0
    mov r14, rax
    mov rax, 1
    mov r13, rax
.L549:
    cmp r13, 1
    jne .L550
    mov rax, [rbp-24]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    mov rax, [rbp-8]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L554
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L554
    mov rax, 1
    jmp .L555
.L554:
    mov rax, 0
.L555:
    test rax, rax
    jz .L552
    add rbx, 32
    jmp .L553
.L552:
.L553:
    cmp r12, rbx
    je .L556
    mov rax, 0
    mov r13, rax
    jmp .L557
.L556:
    cmp r12, 0
    jne .L558
    mov rax, 2
    mov r13, rax
    jmp .L559
.L558:
    add r14, 1
.L559:
.L557:
.L551:
    jmp .L549
.L550:
    cmp r13, 2
    jne .L560
    lea rax, [rel __g_xarm_xl_rg_size]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    mov [rel __g_xarm_xl_rsize], rax
    lea rax, [rel __g_xarm_xl_rg_num]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    jmp .__ret_545
    jmp .L561
.L560:
.L561:
    add r15, 1
.L548:
    jmp .L546
.L547:
    mov rax, 0
    mov [rel __g_xarm_xl_rsize], rax
    mov rax, 1
    neg rax
    jmp .__ret_545
.__ret_545:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
xl_parse_num:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rbx, rcx
    mov rax, rbx
    mov r14, rax
    mov rax, 0
    mov [rel __g_xarm_xl_ok], rax
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 39
    jne .L563
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 39
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L567
    mov rax, r14
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L567
    mov rax, 0
    jmp .L568
.L567:
    mov rax, 1
.L568:
    test rax, rax
    jz .L565
    mov rax, 0
    jmp .__ret_562
    jmp .L566
.L565:
.L566:
    mov rax, 1
    mov [rel __g_xarm_xl_ok], rax
    mov rax, rbx
    jmp .__ret_562
    jmp .L564
.L563:
.L564:
    mov rax, 0
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 45
    jne .L569
    mov rax, 1
    mov r13, rax
    add r14, 1
    jmp .L570
.L569:
.L570:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L573
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L573
    mov rax, 0
    jmp .L574
.L573:
    mov rax, 1
.L574:
    test rax, rax
    jz .L571
    mov rax, 0
    jmp .__ret_562
    jmp .L572
.L571:
.L572:
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L577
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L579
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 88
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L579
    mov rax, 0
    jmp .L580
.L579:
    mov rax, 1
.L580:
    test rax, rax
    jz .L577
    mov rax, 1
    jmp .L578
.L577:
    mov rax, 0
.L578:
    test rax, rax
    jz .L575
    add r14, 2
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    jne .L581
    mov rax, 0
    jmp .__ret_562
    jmp .L582
.L581:
.L582:
.L583:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    je .L584
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov rbx, rax
    cmp r15, 48
    jge .L586
    mov rax, 0
    jmp .__ret_562
    jmp .L587
.L586:
.L587:
    cmp r15, 57
    jg .L588
    mov rax, r15
    sub rax, 48
    mov rbx, rax
    jmp .L589
.L588:
    or r15, 32
    mov rax, r15
    mov rcx, 97
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L592
    mov rax, r15
    mov rcx, 102
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L592
    mov rax, 0
    jmp .L593
.L592:
    mov rax, 1
.L593:
    test rax, rax
    jz .L590
    mov rax, 0
    jmp .__ret_562
    jmp .L591
.L590:
.L591:
    mov rax, r15
    sub rax, 87
    mov rbx, rax
.L589:
    mov rax, r12
    shl rax, 4
    add rax, rbx
    mov r12, rax
    add r14, 1
.L585:
    jmp .L583
.L584:
    jmp .L576
.L575:
.L594:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    je .L595
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L599
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L599
    mov rax, 0
    jmp .L600
.L599:
    mov rax, 1
.L600:
    test rax, rax
    jz .L597
    mov rax, 0
    jmp .__ret_562
    jmp .L598
.L597:
.L598:
    mov rax, r12
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, rbx
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    add r14, 1
.L596:
    jmp .L594
.L595:
.L576:
    cmp r13, 0
    je .L601
    mov rax, 0
    sub rax, r12
    mov r12, rax
    jmp .L602
.L601:
.L602:
    mov rax, 1
    mov [rel __g_xarm_xl_ok], rax
    mov rax, r12
    jmp .__ret_562
.__ret_562:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
xl_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_KIND]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    jmp .__ret_603
.__ret_603:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_rs:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_RSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    jmp .__ret_604
.__ret_604:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_xmm:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_XMM]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    jmp .__ret_605
.__ret_605:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_val:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_VAL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    jmp .__ret_606
.__ret_606:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_arm:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_xarm_xl_rmap]
    push rax
    mov rax, rbx
    and rax, 15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    jmp .__ret_607
.__ret_607:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_opr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_arm
    add rsp, 32
    jmp .__ret_608
.__ret_608:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_xw:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 8
    jne .L610
    mov rax, 120
    jmp .__ret_609
    jmp .L611
.L610:
.L611:
    mov rax, 119
    jmp .__ret_609
.__ret_609:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_bad:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str613: db 110,111,32,65,82,77,54,52,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str613]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_612
.__ret_612:
    mov rsp, rbp
    pop rbp
    ret
xl_imm_to:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
section .data
.str615: db 32,32,32,32,109,111,118,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str615]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_614
.__ret_614:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_addr:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov r13, rcx
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_REL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L617
section .data
.str619: db 32,32,32,32,97,100,114,108,32,120,49,54,44,32,37,115,10,0
section .text
    lea rax, [rel .str619]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 0
    mov [rel __g_xarm_xl_mo], rax
    mov rax, 0
    jmp .__ret_616
    jmp .L618
.L617:
.L618:
    mov rcx, r13
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov [rel __g_xarm_xl_mo], rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 255
    je .L620
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_SCALE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    cmp rbx, 2
    jne .L622
    mov rax, 1
    mov r12, rax
    jmp .L623
.L622:
    cmp rbx, 4
    jne .L624
    mov rax, 2
    mov r12, rax
    jmp .L625
.L624:
    cmp rbx, 8
    jne .L626
    mov rax, 3
    mov r12, rax
    jmp .L627
.L626:
.L627:
.L625:
.L623:
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_INDEX]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_arm
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 255
    jne .L628
section .data
.str630: db 32,32,32,32,108,115,108,32,120,49,54,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str630]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 0
    jmp .__ret_616
    jmp .L629
.L628:
.L629:
section .data
.str631: db 32,32,32,32,97,100,100,32,120,49,54,44,32,37,120,44,32,37,120,44,32,108,115,108,32,35,37,100,10,0
section .text
    lea rax, [rel .str631]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_arm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    mov r9, r12
    sub rsp, 32
    call xl_f3
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 0
    jmp .__ret_616
    jmp .L621
.L620:
.L621:
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 255
    je .L632
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_BASE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_arm
    add rsp, 32
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 0
    jmp .__ret_616
    jmp .L633
.L632:
.L633:
section .data
.str634: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str634]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 0
    jmp .__ret_616
.__ret_616:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xl_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rbx, rcx
    mov r14, rdx
    mov r15, r8
    mov r13, r9
    mov rcx, rbx
    sub rsp, 32
    call xl_addr
    add rsp, 32
section .data
.str636: db 0
section .text
    lea rax, [rel .str636]
    mov r12, rax
    cmp r15, 1
    jne .L637
section .data
.str639: db 98,0
section .text
    lea rax, [rel .str639]
    mov r12, rax
    jmp .L638
.L637:
    cmp r15, 2
    jne .L640
section .data
.str642: db 104,0
section .text
    lea rax, [rel .str642]
    mov r12, rax
    jmp .L641
.L640:
.L641:
.L638:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_mo]
    cmp rax, 0
    jne .L643
    mov rax, 1
    mov rbx, rax
    jmp .L644
.L643:
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L649
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, r15
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L649
    mov rax, 1
    jmp .L650
.L649:
    mov rax, 0
.L650:
    test rax, rax
    jz .L647
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, r15
    cqo
    idiv rcx
    mov rcx, 4095
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L647
    mov rax, 1
    jmp .L648
.L647:
    mov rax, 0
.L648:
    test rax, rax
    jz .L645
section .data
.str651: db 108,100,114,0
section .text
    lea rax, [rel .str651]
    mov rbx, rax
    cmp r14, 0
    je .L652
section .data
.str654: db 115,116,114,0
section .text
    lea rax, [rel .str654]
    mov rbx, rax
    jmp .L653
.L652:
.L653:
section .data
.str655: db 32,32,32,32,37,115,37,115,32,37,115,44,32,91,37,120,44,32,35,37,100,93,10,0
section .text
    lea rax, [rel .str655]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
    pop rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_635
    jmp .L646
.L645:
.L646:
    mov rax, [rel __g_xarm_xl_mo]
    push rax
    mov rax, 256
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L658
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, 255
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L658
    mov rax, 1
    jmp .L659
.L658:
    mov rax, 0
.L659:
    test rax, rax
    jz .L656
section .data
.str660: db 108,100,117,114,0
section .text
    lea rax, [rel .str660]
    mov rbx, rax
    cmp r14, 0
    je .L661
section .data
.str663: db 115,116,117,114,0
section .text
    lea rax, [rel .str663]
    mov rbx, rax
    jmp .L662
.L661:
.L662:
section .data
.str664: db 32,32,32,32,37,115,37,115,32,37,115,44,32,91,37,120,44,32,35,37,100,93,10,0
section .text
    lea rax, [rel .str664]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
    pop rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .__ret_635
    jmp .L657
.L656:
.L657:
    mov rax, 16
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_mb]
    cmp rax, 16
    jne .L665
    mov rax, 17
    mov rbx, rax
    jmp .L666
.L665:
.L666:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str667: db 32,32,32,32,97,100,100,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str667]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, rbx
    sub rsp, 32
    call xl_f3
    add rsp, 32
    mov rax, rbx
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 1
    mov rbx, rax
.L644:
section .data
.str668: db 108,100,114,0
section .text
    lea rax, [rel .str668]
    mov rbx, rax
    cmp r14, 0
    je .L669
section .data
.str671: db 115,116,114,0
section .text
    lea rax, [rel .str671]
    mov rbx, rax
    jmp .L670
.L669:
.L670:
section .data
.str672: db 32,32,32,32,37,115,37,115,32,37,115,44,32,91,37,120,93,10,0
section .text
    lea rax, [rel .str672]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_635
.__ret_635:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
xl_regname:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_xarm_xl_rn_next]
    add rax, 1
    and rax, 3
    mov [rel __g_xarm_xl_rn_next], rax
    lea rax, [rel __g_xarm_xl_rn_bufs]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_rn_next]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    mov r12, rax
    mov rax, [rel __g_xarm_xl_out]
    mov rbx, rax
    mov rax, r12
    mov [rel __g_xarm_xl_out], rax
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    mov rax, [rel __g_xarm_xl_out]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, rbx
    mov [rel __g_xarm_xl_out], rax
    mov rax, r12
    jmp .__ret_673
.__ret_673:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_add_imm:
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
    mov r13, r8
    mov r12, r9
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L677
    mov rcx, r12
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L677
    mov rax, 1
    jmp .L678
.L677:
    mov rax, 0
.L678:
    test rax, rax
    jz .L675
    cmp r15, r14
    je .L679
section .data
.str681: db 32,32,32,32,109,111,118,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str681]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r14
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L680
.L679:
.L680:
    mov rax, 0
    jmp .__ret_674
    jmp .L676
.L675:
.L676:
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L684
    mov rax, r13
    mov rcx, 4096
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L684
    mov rax, 1
    jmp .L685
.L684:
    mov rax, 0
.L685:
    test rax, rax
    jz .L682
section .data
.str686: db 32,32,32,32,97,100,100,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str686]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r15
    mov r9, r14
    mov r10, r13
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_674
    jmp .L683
.L682:
.L683:
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L689
    mov rax, r13
    push rax
    mov rax, 4096
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L689
    mov rax, 1
    jmp .L690
.L689:
    mov rax, 0
.L690:
    test rax, rax
    jz .L687
section .data
.str691: db 32,32,32,32,115,117,98,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str691]
    push rax
    mov rax, r12
    push rax
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    mov rax, 0
    sub rax, r13
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_674
    jmp .L688
.L687:
.L688:
    mov rax, 16
    mov rbx, rax
    cmp r14, 16
    jne .L692
    mov rax, 17
    mov rbx, rax
    jmp .L693
.L692:
.L693:
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str694: db 32,32,32,32,97,100,100,37,115,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str694]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r15
    mov r9, r14
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_674
.__ret_674:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xl_merge_low:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rbx, rcx
    mov r15, rdx
    mov r14, r8
    mov rcx, rbx
    sub rsp, 32
    call xl_arm
    add rsp, 32
    mov r13, rax
    mov rax, 255
    mov r12, rax
    mov rax, 256
    neg rax
    mov rbx, rax
    cmp r14, 1
    je .L696
    mov rax, 65535
    mov r12, rax
    mov rax, 65536
    neg rax
    mov rbx, rax
    jmp .L697
.L696:
.L697:
section .data
.str698: db 32,32,32,32,97,110,100,32,120,49,55,44,32,37,120,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str698]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
section .data
.str699: db 32,32,32,32,97,110,100,32,37,120,44,32,37,120,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str699]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r13
    mov r9, rbx
    sub rsp, 32
    call xl_f3
    add rsp, 32
section .data
.str700: db 32,32,32,32,111,114,114,32,37,120,44,32,37,120,44,32,120,49,55,10,0
section .text
    lea rax, [rel .str700]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r13
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_695
.__ret_695:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xl_src:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r13, rcx
    mov r14, rdx
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L702
    mov rax, 119
    mov rbx, rax
    cmp r14, 4
    jle .L704
    mov rax, 120
    mov rbx, rax
    jmp .L705
.L704:
.L705:
    mov rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    jmp .__ret_701
    jmp .L703
.L702:
.L703:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L706
    mov rax, 16
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_val
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
    cmp r14, 4
    jle .L708
section .data
.str710: db 120,49,54,0
section .text
    lea rax, [rel .str710]
    jmp .__ret_701
    jmp .L709
.L708:
.L709:
section .data
.str711: db 119,49,54,0
section .text
    lea rax, [rel .str711]
    jmp .__ret_701
    jmp .L707
.L706:
.L707:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L712
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L714
    mov rax, r14
    mov r12, rax
    jmp .L715
.L714:
.L715:
section .data
.str716: db 119,49,54,0
section .text
    lea rax, [rel .str716]
    mov rbx, rax
    cmp r12, 4
    jle .L717
section .data
.str719: db 120,49,54,0
section .text
    lea rax, [rel .str719]
    mov rbx, rax
    jmp .L718
.L717:
.L718:
    mov rcx, r13
    mov rdx, 0
    mov r8, r12
    mov r9, rbx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rax, rbx
    jmp .__ret_701
    jmp .L713
.L712:
.L713:
section .data
.str720: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str720]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
section .data
.str721: db 120,49,54,0
section .text
    lea rax, [rel .str721]
    jmp .__ret_701
.__ret_701:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_logic_ok:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov [rbp-128], r15
    mov r13, rcx
    mov r12, rdx
    mov rax, 1
    neg rax
    mov rbx, rax
    cmp r12, 64
    je .L723
    mov rax, 4294967295
    mov rbx, rax
    jmp .L724
.L723:
.L724:
    mov rax, r13
    and rax, rbx
    mov r13, rax
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L727
    mov rax, r13
    mov rcx, rbx
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L727
    mov rax, 0
    jmp .L728
.L727:
    mov rax, 1
.L728:
    test rax, rax
    jz .L725
    mov rax, 0
    jmp .__ret_722
    jmp .L726
.L725:
.L726:
    mov rax, r12
    mov r15, rax
.L729:
    cmp r15, 2
    jle .L730
    mov rax, r15
    shr rax, 1
    mov r12, rax
    mov rax, 1
    mov rcx, r12
    shl rax, cl
    sub rax, 1
    mov rbx, rax
    mov rax, r13
    and rax, rbx
    push rax
    mov rax, r13
    mov rcx, r12
    shr rax, cl
    and rax, rbx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L732
    jmp .L730
    jmp .L733
.L732:
.L733:
    mov rax, r12
    mov r15, rax
.L731:
    jmp .L729
.L730:
    mov rax, 1
    neg rax
    mov r14, rax
    cmp r15, 64
    je .L734
    mov rax, 1
    mov rcx, r15
    shl rax, cl
    sub rax, 1
    mov r14, rax
    jmp .L735
.L734:
.L735:
    mov rax, r13
    and rax, r14
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L736:
    cmp r12, r15
    jge .L737
    mov rax, r13
    mov rcx, r12
    shr rax, cl
    mov [rbp-88], rax
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    sub rax, r12
    cmp rax, 64
    jge .L739
    mov rax, r15
    sub rax, r12
    mov rcx, rax
    mov rax, r13
    shl rax, cl
    mov rbx, rax
    jmp .L740
.L739:
.L740:
    mov rax, [rbp-88]
    or rax, rbx
    and rax, r14
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L743
    mov rax, rbx
    add rax, 1
    mov rcx, rax
    mov rax, rbx
    and rax, rcx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L743
    mov rax, 1
    jmp .L744
.L743:
    mov rax, 0
.L744:
    test rax, rax
    jz .L741
    mov rax, 1
    jmp .__ret_722
    jmp .L742
.L741:
.L742:
    add r12, 1
.L738:
    jmp .L736
.L737:
    mov rax, 0
    jmp .__ret_722
.__ret_722:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
xl_cond:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_xarm_xl_fk]
    push rax
    mov rax, [rel __g_xarm_F_NONE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L746
section .data
.str748: db 99,111,110,100,105,116,105,111,110,32,119,105,116,104,32,110,111,116,104,105,110,103,32,115,101,116,116,105,110,103,32,116,104,101,32,102,108,97,103,115,32,98,101,102,111,114,101,32,105,116,0
section .text
    lea rax, [rel .str748]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_745
    jmp .L747
.L746:
.L747:
    mov rax, [rel __g_xarm_xl_fpend]
    cmp rax, 0
    je .L749
    mov rax, [rel __g_xarm_xl_fpend]
    sub rax, 1
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_fpw]
    cmp rax, 0
    jne .L751
section .data
.str753: db 32,32,32,32,116,115,116,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str753]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L752
.L751:
section .data
.str754: db 32,32,32,32,116,115,116,32,37,119,44,32,37,119,10,0
section .text
    lea rax, [rel .str754]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
.L752:
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    jmp .L750
.L749:
.L750:
    mov rax, [rel __g_xarm_xl_cc_fp]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_fp_end]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_fk]
    push rax
    mov rax, [rel __g_xarm_F_SUB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L755
    mov rax, [rel __g_xarm_xl_cc_sub]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_sub_end]
    mov rbx, rax
    jmp .L756
.L755:
    mov rax, [rel __g_xarm_xl_fk]
    push rax
    mov rax, [rel __g_xarm_F_LOGIC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L757
    mov rax, [rel __g_xarm_xl_cc_logic]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_logic_end]
    mov rbx, rax
    jmp .L758
.L757:
    mov rax, [rel __g_xarm_xl_fk]
    push rax
    mov rax, [rel __g_xarm_F_ADD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L759
    mov rax, [rel __g_xarm_xl_cc_add]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_add_end]
    mov rbx, rax
    jmp .L760
.L759:
.L760:
.L758:
.L756:
.L761:
    cmp r12, rbx
    jge .L762
    mov rax, r13
    push rax
    lea rax, [rel __g_xarm_xl_cc_x86]
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
    call xl_g64
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L764
    lea rax, [rel __g_xarm_xl_cc_arm]
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
    call xl_g64
    add rsp, 32
    jmp .__ret_745
    jmp .L765
.L764:
.L765:
    add r12, 1
.L763:
    jmp .L761
.L762:
section .data
.str766: db 99,111,110,100,105,116,105,111,110,32,116,104,101,115,101,32,102,108,97,103,115,32,99,97,110,110,111,116,32,97,110,115,119,101,114,32,111,110,32,65,82,77,54,52,0
section .text
    lea rax, [rel .str766]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_745
.__ret_745:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_insn:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str770: db 109,111,118,0
section .text
    lea rax, [rel .str770]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L768
    sub rsp, 32
    call xl_i_mov
    add rsp, 32
    jmp .__ret_767
    jmp .L769
.L768:
.L769:
    mov rax, rbx
    push rax
section .data
.str773: db 109,111,118,122,120,0
section .text
    lea rax, [rel .str773]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L771
    sub rsp, 32
    call xl_i_movzx
    add rsp, 32
    jmp .__ret_767
    jmp .L772
.L771:
.L772:
    mov rax, rbx
    push rax
section .data
.str776: db 108,101,97,0
section .text
    lea rax, [rel .str776]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L774
    sub rsp, 32
    call xl_i_lea
    add rsp, 32
    jmp .__ret_767
    jmp .L775
.L774:
.L775:
    mov rax, rbx
    push rax
section .data
.str779: db 112,117,115,104,0
section .text
    lea rax, [rel .str779]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L777
    sub rsp, 32
    call xl_i_push
    add rsp, 32
    jmp .__ret_767
    jmp .L778
.L777:
.L778:
    mov rax, rbx
    push rax
section .data
.str782: db 112,111,112,0
section .text
    lea rax, [rel .str782]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L780
    sub rsp, 32
    call xl_i_pop
    add rsp, 32
    jmp .__ret_767
    jmp .L781
.L780:
.L781:
    mov rax, rbx
    push rax
section .data
.str785: db 97,100,100,0
section .text
    lea rax, [rel .str785]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L783
    mov rcx, 0
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_767
    jmp .L784
.L783:
.L784:
    mov rax, rbx
    push rax
section .data
.str788: db 115,117,98,0
section .text
    lea rax, [rel .str788]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L786
    mov rcx, 1
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_767
    jmp .L787
.L786:
.L787:
    mov rax, rbx
    push rax
section .data
.str791: db 97,110,100,0
section .text
    lea rax, [rel .str791]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L789
    mov rcx, 2
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_767
    jmp .L790
.L789:
.L790:
    mov rax, rbx
    push rax
section .data
.str794: db 111,114,0
section .text
    lea rax, [rel .str794]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L792
    mov rcx, 3
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_767
    jmp .L793
.L792:
.L793:
    mov rax, rbx
    push rax
section .data
.str797: db 120,111,114,0
section .text
    lea rax, [rel .str797]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L795
    mov rcx, 4
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_767
    jmp .L796
.L795:
.L796:
    mov rax, rbx
    push rax
section .data
.str800: db 105,110,99,0
section .text
    lea rax, [rel .str800]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L798
section .data
.str801: db 97,100,100,115,0
section .text
    lea rax, [rel .str801]
    push rax
    mov rax, [rel __g_xarm_F_ADD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_incdec
    add rsp, 32
    jmp .__ret_767
    jmp .L799
.L798:
.L799:
    mov rax, rbx
    push rax
section .data
.str804: db 100,101,99,0
section .text
    lea rax, [rel .str804]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L802
section .data
.str805: db 115,117,98,115,0
section .text
    lea rax, [rel .str805]
    push rax
    mov rax, [rel __g_xarm_F_SUB]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_incdec
    add rsp, 32
    jmp .__ret_767
    jmp .L803
.L802:
.L803:
    mov rax, rbx
    push rax
section .data
.str808: db 110,101,103,0
section .text
    lea rax, [rel .str808]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L806
    sub rsp, 32
    call xl_i_neg
    add rsp, 32
    jmp .__ret_767
    jmp .L807
.L806:
.L807:
    mov rax, rbx
    push rax
section .data
.str811: db 110,111,116,0
section .text
    lea rax, [rel .str811]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L809
    sub rsp, 32
    call xl_i_not
    add rsp, 32
    jmp .__ret_767
    jmp .L810
.L809:
.L810:
    mov rax, rbx
    push rax
section .data
.str814: db 99,109,112,0
section .text
    lea rax, [rel .str814]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L812
    sub rsp, 32
    call xl_i_cmp
    add rsp, 32
    jmp .__ret_767
    jmp .L813
.L812:
.L813:
    mov rax, rbx
    push rax
section .data
.str817: db 116,101,115,116,0
section .text
    lea rax, [rel .str817]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L815
    sub rsp, 32
    call xl_i_test
    add rsp, 32
    jmp .__ret_767
    jmp .L816
.L815:
.L816:
    mov rax, rbx
    push rax
section .data
.str820: db 105,109,117,108,0
section .text
    lea rax, [rel .str820]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L818
    sub rsp, 32
    call xl_i_imul
    add rsp, 32
    jmp .__ret_767
    jmp .L819
.L818:
.L819:
    mov rax, rbx
    push rax
section .data
.str823: db 99,113,111,0
section .text
    lea rax, [rel .str823]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L821
section .data
.str824: db 32,32,32,32,97,115,114,32,120,50,44,32,120,48,44,32,35,54,51,10,0
section .text
    lea rax, [rel .str824]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_767
    jmp .L822
.L821:
.L822:
    mov rax, rbx
    push rax
section .data
.str827: db 105,100,105,118,0
section .text
    lea rax, [rel .str827]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L825
section .data
.str828: db 115,100,105,118,0
section .text
    lea rax, [rel .str828]
    push rax
    pop rcx
    sub rsp, 32
    call xl_divide
    add rsp, 32
    jmp .__ret_767
    jmp .L826
.L825:
.L826:
    mov rax, rbx
    push rax
section .data
.str831: db 100,105,118,0
section .text
    lea rax, [rel .str831]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L829
section .data
.str832: db 117,100,105,118,0
section .text
    lea rax, [rel .str832]
    push rax
    pop rcx
    sub rsp, 32
    call xl_divide
    add rsp, 32
    jmp .__ret_767
    jmp .L830
.L829:
.L830:
    mov rax, rbx
    push rax
section .data
.str835: db 115,104,108,0
section .text
    lea rax, [rel .str835]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L833
section .data
.str836: db 108,115,108,0
section .text
    lea rax, [rel .str836]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_767
    jmp .L834
.L833:
.L834:
    mov rax, rbx
    push rax
section .data
.str839: db 115,97,108,0
section .text
    lea rax, [rel .str839]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L837
section .data
.str840: db 108,115,108,0
section .text
    lea rax, [rel .str840]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_767
    jmp .L838
.L837:
.L838:
    mov rax, rbx
    push rax
section .data
.str843: db 115,104,114,0
section .text
    lea rax, [rel .str843]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L841
section .data
.str844: db 108,115,114,0
section .text
    lea rax, [rel .str844]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_767
    jmp .L842
.L841:
.L842:
    mov rax, rbx
    push rax
section .data
.str847: db 115,97,114,0
section .text
    lea rax, [rel .str847]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L845
section .data
.str848: db 97,115,114,0
section .text
    lea rax, [rel .str848]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_767
    jmp .L846
.L845:
.L846:
    mov rax, rbx
    push rax
section .data
.str851: db 114,111,108,0
section .text
    lea rax, [rel .str851]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L849
section .data
.str852: db 114,111,114,0
section .text
    lea rax, [rel .str852]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_767
    jmp .L850
.L849:
.L850:
    mov rax, rbx
    push rax
section .data
.str855: db 114,111,114,0
section .text
    lea rax, [rel .str855]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L853
section .data
.str856: db 114,111,114,0
section .text
    lea rax, [rel .str856]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_767
    jmp .L854
.L853:
.L854:
    mov rax, rbx
    push rax
section .data
.str859: db 120,99,104,103,0
section .text
    lea rax, [rel .str859]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L857
    sub rsp, 32
    call xl_i_xchg
    add rsp, 32
    jmp .__ret_767
    jmp .L858
.L857:
.L858:
    mov rax, rbx
    push rax
section .data
.str862: db 106,109,112,0
section .text
    lea rax, [rel .str862]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L860
    sub rsp, 32
    call xl_i_jmp
    add rsp, 32
    jmp .__ret_767
    jmp .L861
.L860:
.L861:
    mov rax, rbx
    push rax
section .data
.str865: db 99,97,108,108,0
section .text
    lea rax, [rel .str865]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L863
    sub rsp, 32
    call xl_i_call
    add rsp, 32
    jmp .__ret_767
    jmp .L864
.L863:
.L864:
    mov rax, rbx
    push rax
section .data
.str868: db 114,101,116,0
section .text
    lea rax, [rel .str868]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L866
section .data
.str869: db 32,32,32,32,114,101,116,10,0
section .text
    lea rax, [rel .str869]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_767
    jmp .L867
.L866:
.L867:
    mov rax, rbx
    push rax
section .data
.str872: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str872]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L870
section .data
.str873: db 32,32,32,32,109,111,118,32,120,49,55,44,32,120,51,48,10,32,32,32,32,98,108,32,95,95,115,121,115,120,10,32,32,32,32,109,111,118,32,120,51,48,44,32,120,49,55,10,0
section .text
    lea rax, [rel .str873]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_767
    jmp .L871
.L870:
.L871:
    mov rax, rbx
    push rax
section .data
.str876: db 109,111,118,115,100,0
section .text
    lea rax, [rel .str876]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L874
    sub rsp, 32
    call xl_i_movsd
    add rsp, 32
    jmp .__ret_767
    jmp .L875
.L874:
.L875:
    mov rax, rbx
    push rax
section .data
.str879: db 109,111,118,115,115,0
section .text
    lea rax, [rel .str879]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L877
    sub rsp, 32
    call xl_i_movss
    add rsp, 32
    jmp .__ret_767
    jmp .L878
.L877:
.L878:
    mov rax, rbx
    push rax
section .data
.str882: db 99,118,116,115,115,50,115,100,0
section .text
    lea rax, [rel .str882]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L880
section .data
.str883: db 32,32,32,32,102,99,118,116,32,37,68,44,32,115,37,100,10,0
section .text
    lea rax, [rel .str883]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fcvt_sd
    add rsp, 32
    jmp .__ret_767
    jmp .L881
.L880:
.L881:
    mov rax, rbx
    push rax
section .data
.str886: db 99,118,116,115,100,50,115,115,0
section .text
    lea rax, [rel .str886]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L884
section .data
.str887: db 32,32,32,32,102,99,118,116,32,115,37,100,44,32,37,68,10,0
section .text
    lea rax, [rel .str887]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fcvt_sd
    add rsp, 32
    jmp .__ret_767
    jmp .L885
.L884:
.L885:
    mov rax, rbx
    push rax
section .data
.str890: db 109,111,118,113,0
section .text
    lea rax, [rel .str890]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L888
    sub rsp, 32
    call xl_i_movsd
    add rsp, 32
    jmp .__ret_767
    jmp .L889
.L888:
.L889:
    mov rax, rbx
    push rax
section .data
.str893: db 109,111,118,117,112,115,0
section .text
    lea rax, [rel .str893]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L891
    sub rsp, 32
    call xl_i_movups
    add rsp, 32
    jmp .__ret_767
    jmp .L892
.L891:
.L892:
    mov rax, rbx
    push rax
section .data
.str896: db 109,111,118,117,112,100,0
section .text
    lea rax, [rel .str896]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L894
    sub rsp, 32
    call xl_i_movups
    add rsp, 32
    jmp .__ret_767
    jmp .L895
.L894:
.L895:
    mov rax, rbx
    push rax
section .data
.str899: db 109,111,118,97,112,115,0
section .text
    lea rax, [rel .str899]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L897
    sub rsp, 32
    call xl_i_movups
    add rsp, 32
    jmp .__ret_767
    jmp .L898
.L897:
.L898:
    mov rax, rbx
    push rax
section .data
.str902: db 109,111,118,97,112,100,0
section .text
    lea rax, [rel .str902]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L900
    sub rsp, 32
    call xl_i_movups
    add rsp, 32
    jmp .__ret_767
    jmp .L901
.L900:
.L901:
    mov rax, rbx
    push rax
section .data
.str905: db 97,100,100,115,100,0
section .text
    lea rax, [rel .str905]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L903
section .data
.str906: db 102,97,100,100,0
section .text
    lea rax, [rel .str906]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_767
    jmp .L904
.L903:
.L904:
    mov rax, rbx
    push rax
section .data
.str909: db 115,117,98,115,100,0
section .text
    lea rax, [rel .str909]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L907
section .data
.str910: db 102,115,117,98,0
section .text
    lea rax, [rel .str910]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_767
    jmp .L908
.L907:
.L908:
    mov rax, rbx
    push rax
section .data
.str913: db 109,117,108,115,100,0
section .text
    lea rax, [rel .str913]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L911
section .data
.str914: db 102,109,117,108,0
section .text
    lea rax, [rel .str914]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_767
    jmp .L912
.L911:
.L912:
    mov rax, rbx
    push rax
section .data
.str917: db 100,105,118,115,100,0
section .text
    lea rax, [rel .str917]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L915
section .data
.str918: db 102,100,105,118,0
section .text
    lea rax, [rel .str918]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_767
    jmp .L916
.L915:
.L916:
    mov rax, rbx
    push rax
section .data
.str921: db 115,113,114,116,115,100,0
section .text
    lea rax, [rel .str921]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L919
section .data
.str922: db 102,115,113,114,116,0
section .text
    lea rax, [rel .str922]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_767
    jmp .L920
.L919:
.L920:
    mov rax, rbx
    push rax
section .data
.str925: db 97,100,100,112,100,0
section .text
    lea rax, [rel .str925]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L923
section .data
.str926: db 102,97,100,100,0
section .text
    lea rax, [rel .str926]
    push rax
section .data
.str927: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str927]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L924
.L923:
.L924:
    mov rax, rbx
    push rax
section .data
.str930: db 115,117,98,112,100,0
section .text
    lea rax, [rel .str930]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L928
section .data
.str931: db 102,115,117,98,0
section .text
    lea rax, [rel .str931]
    push rax
section .data
.str932: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str932]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L929
.L928:
.L929:
    mov rax, rbx
    push rax
section .data
.str935: db 109,117,108,112,100,0
section .text
    lea rax, [rel .str935]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L933
section .data
.str936: db 102,109,117,108,0
section .text
    lea rax, [rel .str936]
    push rax
section .data
.str937: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str937]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L934
.L933:
.L934:
    mov rax, rbx
    push rax
section .data
.str940: db 100,105,118,112,100,0
section .text
    lea rax, [rel .str940]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L938
section .data
.str941: db 102,100,105,118,0
section .text
    lea rax, [rel .str941]
    push rax
section .data
.str942: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str942]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L939
.L938:
.L939:
    mov rax, rbx
    push rax
section .data
.str945: db 97,100,100,112,115,0
section .text
    lea rax, [rel .str945]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L943
section .data
.str946: db 102,97,100,100,0
section .text
    lea rax, [rel .str946]
    push rax
section .data
.str947: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str947]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L944
.L943:
.L944:
    mov rax, rbx
    push rax
section .data
.str950: db 115,117,98,112,115,0
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
section .data
.str951: db 102,115,117,98,0
section .text
    lea rax, [rel .str951]
    push rax
section .data
.str952: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str952]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L949
.L948:
.L949:
    mov rax, rbx
    push rax
section .data
.str955: db 109,117,108,112,115,0
section .text
    lea rax, [rel .str955]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L953
section .data
.str956: db 102,109,117,108,0
section .text
    lea rax, [rel .str956]
    push rax
section .data
.str957: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str957]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L954
.L953:
.L954:
    mov rax, rbx
    push rax
section .data
.str960: db 100,105,118,112,115,0
section .text
    lea rax, [rel .str960]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L958
section .data
.str961: db 102,100,105,118,0
section .text
    lea rax, [rel .str961]
    push rax
section .data
.str962: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str962]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L959
.L958:
.L959:
    mov rax, rbx
    push rax
section .data
.str965: db 120,111,114,112,115,0
section .text
    lea rax, [rel .str965]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L963
section .data
.str966: db 101,111,114,0
section .text
    lea rax, [rel .str966]
    push rax
section .data
.str967: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str967]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L964
.L963:
.L964:
    mov rax, rbx
    push rax
section .data
.str970: db 120,111,114,112,100,0
section .text
    lea rax, [rel .str970]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L968
section .data
.str971: db 101,111,114,0
section .text
    lea rax, [rel .str971]
    push rax
section .data
.str972: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str972]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L969
.L968:
.L969:
    mov rax, rbx
    push rax
section .data
.str975: db 97,110,100,112,115,0
section .text
    lea rax, [rel .str975]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L973
section .data
.str976: db 97,110,100,0
section .text
    lea rax, [rel .str976]
    push rax
section .data
.str977: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str977]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L974
.L973:
.L974:
    mov rax, rbx
    push rax
section .data
.str980: db 97,110,100,112,100,0
section .text
    lea rax, [rel .str980]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L978
section .data
.str981: db 97,110,100,0
section .text
    lea rax, [rel .str981]
    push rax
section .data
.str982: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str982]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L979
.L978:
.L979:
    mov rax, rbx
    push rax
section .data
.str985: db 111,114,112,100,0
section .text
    lea rax, [rel .str985]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L983
section .data
.str986: db 111,114,114,0
section .text
    lea rax, [rel .str986]
    push rax
section .data
.str987: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str987]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_767
    jmp .L984
.L983:
.L984:
    mov rax, rbx
    push rax
section .data
.str990: db 117,99,111,109,105,115,100,0
section .text
    lea rax, [rel .str990]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L988
    sub rsp, 32
    call xl_i_ucomisd
    add rsp, 32
    jmp .__ret_767
    jmp .L989
.L988:
.L989:
    mov rax, rbx
    push rax
section .data
.str993: db 99,111,109,105,115,100,0
section .text
    lea rax, [rel .str993]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L991
    sub rsp, 32
    call xl_i_ucomisd
    add rsp, 32
    jmp .__ret_767
    jmp .L992
.L991:
.L992:
    mov rax, rbx
    push rax
section .data
.str996: db 99,118,116,115,105,50,115,100,0
section .text
    lea rax, [rel .str996]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L994
    sub rsp, 32
    call xl_i_cvtsi2sd
    add rsp, 32
    jmp .__ret_767
    jmp .L995
.L994:
.L995:
    mov rax, rbx
    push rax
section .data
.str999: db 99,118,116,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str999]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L997
section .data
.str1000: db 102,99,118,116,122,115,0
section .text
    lea rax, [rel .str1000]
    push rax
    pop rcx
    sub rsp, 32
    call xl_tofix
    add rsp, 32
    jmp .__ret_767
    jmp .L998
.L997:
.L998:
    mov rax, rbx
    push rax
section .data
.str1003: db 99,118,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str1003]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1001
section .data
.str1004: db 102,99,118,116,110,115,0
section .text
    lea rax, [rel .str1004]
    push rax
    pop rcx
    sub rsp, 32
    call xl_tofix
    add rsp, 32
    jmp .__ret_767
    jmp .L1002
.L1001:
.L1002:
    mov rax, rbx
    push rax
section .data
.str1007: db 112,114,101,102,101,116,99,104,116,48,0
section .text
    lea rax, [rel .str1007]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1005
section .data
.str1008: db 32,32,32,32,112,114,102,109,32,112,108,100,108,49,107,101,101,112,44,32,91,37,120,93,10,0
section .text
    lea rax, [rel .str1008]
    push rax
    pop rcx
    sub rsp, 32
    call xl_cacheop
    add rsp, 32
    jmp .__ret_767
    jmp .L1006
.L1005:
.L1006:
    mov rax, rbx
    push rax
section .data
.str1011: db 99,108,102,108,117,115,104,0
section .text
    lea rax, [rel .str1011]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1009
section .data
.str1012: db 32,32,32,32,100,99,32,99,105,118,97,99,44,32,37,120,10,0
section .text
    lea rax, [rel .str1012]
    push rax
    pop rcx
    sub rsp, 32
    call xl_cacheop
    add rsp, 32
    jmp .__ret_767
    jmp .L1010
.L1009:
.L1010:
    mov rax, rbx
    push rax
section .data
.str1015: db 110,111,112,0
section .text
    lea rax, [rel .str1015]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1013
section .data
.str1016: db 32,32,32,32,110,111,112,10,0
section .text
    lea rax, [rel .str1016]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_767
    jmp .L1014
.L1013:
.L1014:
    mov rax, rbx
    push rax
section .data
.str1019: db 112,97,117,115,101,0
section .text
    lea rax, [rel .str1019]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1017
section .data
.str1020: db 32,32,32,32,110,111,112,10,0
section .text
    lea rax, [rel .str1020]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_767
    jmp .L1018
.L1017:
.L1018:
    mov rax, rbx
    push rax
section .data
.str1023: db 109,102,101,110,99,101,0
section .text
    lea rax, [rel .str1023]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1021
section .data
.str1024: db 32,32,32,32,100,109,98,32,105,115,104,10,0
section .text
    lea rax, [rel .str1024]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_767
    jmp .L1022
.L1021:
.L1022:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 106
    jne .L1025
    sub rsp, 32
    call xl_i_jcc
    add rsp, 32
    jmp .__ret_767
    jmp .L1026
.L1025:
.L1026:
    mov rax, rbx
    push rax
section .data
.str1029: db 115,101,116,0
section .text
    lea rax, [rel .str1029]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L1027
    sub rsp, 32
    call xl_i_setcc
    add rsp, 32
    jmp .__ret_767
    jmp .L1028
.L1027:
.L1028:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_767
.__ret_767:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_i_mov:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov rax, [rel __g_xarm_xl_o1]
    mov r14, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r15, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1031
    mov rcx, r14
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1033
    mov rcx, r15
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
    cmp r13, 8
    jne .L1035
    cmp r12, rbx
    je .L1037
section .data
.str1039: db 32,32,32,32,109,111,118,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1039]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1038
.L1037:
.L1038:
    mov rax, 0
    jmp .__ret_1030
    jmp .L1036
.L1035:
.L1036:
    cmp r13, 4
    jne .L1040
section .data
.str1042: db 32,32,32,32,109,111,118,32,37,119,44,32,37,119,10,0
section .text
    lea rax, [rel .str1042]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1030
    jmp .L1041
.L1040:
.L1041:
    mov rax, r14
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call xl_merge_low
    add rsp, 32
    jmp .__ret_1030
    jmp .L1034
.L1033:
.L1034:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1043
    cmp r13, 8
    jne .L1045
    mov rax, r12
    push rax
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
    jmp .__ret_1030
    jmp .L1046
.L1045:
.L1046:
    cmp r13, 4
    jne .L1047
section .data
.str1049: db 32,32,32,32,109,111,118,32,37,119,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1049]
    push rax
    mov rax, r12
    push rax
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1030
    jmp .L1048
.L1047:
.L1048:
    mov rax, 16
    push rax
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 16
    mov r8, r13
    sub rsp, 32
    call xl_merge_low
    add rsp, 32
    jmp .__ret_1030
    jmp .L1044
.L1043:
.L1044:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1050
    cmp r13, 4
    jge .L1052
    mov rax, r15
    push rax
    mov rax, 0
    push rax
    mov rax, r13
    push rax
section .data
.str1054: db 119,49,54,0
section .text
    lea rax, [rel .str1054]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 16
    mov r8, r13
    sub rsp, 32
    call xl_merge_low
    add rsp, 32
    jmp .__ret_1030
    jmp .L1053
.L1052:
.L1053:
    mov rax, r15
    push rax
    mov rax, 0
    push rax
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1030
    jmp .L1051
.L1050:
.L1051:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1030
    jmp .L1032
.L1031:
.L1032:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1055
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1030
    jmp .L1056
.L1055:
.L1056:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1057
    mov rcx, r15
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, rbx
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    mov rcx, r15
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1030
    jmp .L1058
.L1057:
.L1058:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1059
    mov rax, r14
    push rax
    mov rax, [rel __g_xarm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1061
    mov rax, 8
    mov r13, rax
    jmp .L1062
.L1061:
.L1062:
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L1063
section .data
.str1065: db 119,122,114,0
section .text
    lea rax, [rel .str1065]
    mov rbx, rax
    cmp r13, 4
    jle .L1066
section .data
.str1068: db 120,122,114,0
section .text
    lea rax, [rel .str1068]
    mov rbx, rax
    jmp .L1067
.L1066:
.L1067:
    jmp .L1064
.L1063:
    mov rcx, 17
    mov rdx, r12
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str1069: db 119,49,55,0
section .text
    lea rax, [rel .str1069]
    mov rbx, rax
    cmp r13, 4
    jle .L1070
section .data
.str1072: db 120,49,55,0
section .text
    lea rax, [rel .str1072]
    mov rbx, rax
    jmp .L1071
.L1070:
.L1071:
.L1064:
    mov rcx, r14
    mov rdx, 1
    mov r8, r13
    mov r9, rbx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1030
    jmp .L1060
.L1059:
.L1060:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1030
.__ret_1030:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
xl_i_movzx:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r13, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1074
    mov rax, 65535
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 1
    jne .L1076
    mov rax, 255
    mov rbx, rax
    jmp .L1077
.L1076:
.L1077:
section .data
.str1078: db 32,32,32,32,97,110,100,32,37,120,44,32,37,120,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str1078]
    push rax
    mov rax, r12
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, rbx
    sub rsp, 32
    call xl_f3
    add rsp, 32
    jmp .__ret_1073
    jmp .L1075
.L1074:
.L1075:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1079
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1073
    jmp .L1080
.L1079:
.L1080:
    mov rax, r13
    push rax
    mov rax, [rel __g_xarm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1081
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1073
    jmp .L1082
.L1081:
.L1082:
    mov rax, r13
    push rax
    mov rax, 0
    push rax
    mov rax, rbx
    push rax
    mov rcx, 119
    mov rdx, r12
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1073
.__ret_1073:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xl_i_lea:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xarm_xl_o1]
    push rax
    pop rcx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_xarm_xl_o2]
    push rax
    mov rax, [rel __g_xarm_OP_REL]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1084
section .data
.str1086: db 32,32,32,32,97,100,114,108,32,37,120,44,32,37,115,10,0
section .text
    lea rax, [rel .str1086]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1083
    jmp .L1085
.L1084:
.L1085:
    mov rax, [rel __g_xarm_xl_o2]
    push rax
    pop rcx
    sub rsp, 32
    call xl_addr
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
section .data
.str1087: db 0
section .text
    lea rax, [rel .str1087]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_add_imm
    add rsp, 32
    jmp .__ret_1083
.__ret_1083:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_i_push:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1089
section .data
.str1091: db 32,32,32,32,115,116,114,32,37,120,44,32,91,120,50,56,44,32,35,45,56,93,33,10,0
section .text
    lea rax, [rel .str1091]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1088
    jmp .L1090
.L1089:
.L1090:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1092
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1088
    jmp .L1093
.L1092:
.L1093:
    mov rax, 16
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_val
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str1094: db 32,32,32,32,115,116,114,32,37,120,44,32,91,120,50,56,44,32,35,45,56,93,33,10,0
section .text
    lea rax, [rel .str1094]
    push rax
    pop rcx
    mov rdx, 16
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1088
.__ret_1088:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_i_pop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1096
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1095
    jmp .L1097
.L1096:
.L1097:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 4
    jne .L1098
section .data
.str1100: db 32,32,32,32,108,100,114,32,120,50,56,44,32,91,120,50,56,93,10,0
section .text
    lea rax, [rel .str1100]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_1095
    jmp .L1099
.L1098:
.L1099:
section .data
.str1101: db 32,32,32,32,108,100,114,32,37,120,44,32,91,120,50,56,93,44,32,35,56,10,0
section .text
    lea rax, [rel .str1101]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1095
.__ret_1095:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_ar_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L1103
section .data
.str1105: db 97,100,100,115,0
section .text
    lea rax, [rel .str1105]
    jmp .__ret_1102
    jmp .L1104
.L1103:
.L1104:
    cmp rbx, 1
    jne .L1106
section .data
.str1108: db 115,117,98,115,0
section .text
    lea rax, [rel .str1108]
    jmp .__ret_1102
    jmp .L1107
.L1106:
.L1107:
    cmp rbx, 2
    jne .L1109
section .data
.str1111: db 97,110,100,115,0
section .text
    lea rax, [rel .str1111]
    jmp .__ret_1102
    jmp .L1110
.L1109:
.L1110:
    cmp rbx, 3
    jne .L1112
section .data
.str1114: db 111,114,114,0
section .text
    lea rax, [rel .str1114]
    jmp .__ret_1102
    jmp .L1113
.L1112:
.L1113:
section .data
.str1115: db 101,111,114,0
section .text
    lea rax, [rel .str1115]
    jmp .__ret_1102
.__ret_1102:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_ar_plain:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L1117
section .data
.str1119: db 97,100,100,0
section .text
    lea rax, [rel .str1119]
    jmp .__ret_1116
    jmp .L1118
.L1117:
.L1118:
    cmp rbx, 1
    jne .L1120
section .data
.str1122: db 115,117,98,0
section .text
    lea rax, [rel .str1122]
    jmp .__ret_1116
    jmp .L1121
.L1120:
.L1121:
    cmp rbx, 2
    jne .L1123
section .data
.str1125: db 97,110,100,0
section .text
    lea rax, [rel .str1125]
    jmp .__ret_1116
    jmp .L1124
.L1123:
.L1124:
    cmp rbx, 3
    jne .L1126
section .data
.str1128: db 111,114,114,0
section .text
    lea rax, [rel .str1128]
    jmp .__ret_1116
    jmp .L1127
.L1126:
.L1127:
section .data
.str1129: db 101,111,114,0
section .text
    lea rax, [rel .str1129]
    jmp .__ret_1116
.__ret_1116:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_ar_fk:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L1131
    mov rax, [rel __g_xarm_F_ADD]
    jmp .__ret_1130
    jmp .L1132
.L1131:
.L1132:
    cmp rbx, 1
    jne .L1133
    mov rax, [rel __g_xarm_F_SUB]
    jmp .__ret_1130
    jmp .L1134
.L1133:
.L1134:
    mov rax, [rel __g_xarm_F_LOGIC]
    jmp .__ret_1130
.__ret_1130:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_arith:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov r13, rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov r14, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1136
    mov rcx, r13
    sub rsp, 32
    call xl_arith_mem
    add rsp, 32
    jmp .__ret_1135
    jmp .L1137
.L1136:
.L1137:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1138
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1135
    jmp .L1139
.L1138:
.L1139:
    mov rcx, r14
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov rbx, rax
    cmp rbx, 4
    jge .L1140
    mov rcx, r13
    sub rsp, 32
    call xl_arith_partial
    add rsp, 32
    jmp .__ret_1135
    jmp .L1141
.L1140:
.L1141:
    mov rcx, r14
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r14, rax
    cmp r13, 2
    jl .L1142
    mov rcx, r13
    mov rdx, rbx
    mov r8, r14
    sub rsp, 32
    call xl_arith_logic
    add rsp, 32
    jmp .__ret_1135
    jmp .L1143
.L1142:
.L1143:
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1146
    mov rax, rbx
    mov rcx, 4
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1146
    mov rax, 1
    jmp .L1147
.L1146:
    mov rax, 0
.L1147:
    test rax, rax
    jz .L1144
    mov rcx, r12
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 1
    jne .L1148
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1152
    mov rax, r12
    mov rcx, 4096
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1152
    mov rax, 1
    jmp .L1153
.L1152:
    mov rax, 0
.L1153:
    test rax, rax
    jz .L1150
section .data
.str1154: db 32,32,32,32,115,117,98,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1154]
    push rax
section .data
.str1155: db 115,0
section .text
    lea rax, [rel .str1155]
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    mov r9, r14
    mov r10, r12
    sub rsp, 32
    call xl_f4
    add rsp, 32
    mov rax, 1
    mov rbx, rax
    jmp .L1151
.L1150:
    mov rax, 0
    sub rax, r12
    mov r12, rax
.L1151:
    jmp .L1149
.L1148:
.L1149:
    cmp rbx, 0
    jne .L1156
    mov rax, r14
    push rax
    mov rax, r14
    push rax
    mov rax, r12
    push rax
section .data
.str1158: db 115,0
section .text
    lea rax, [rel .str1158]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_add_imm
    add rsp, 32
    jmp .L1157
.L1156:
.L1157:
    jmp .L1145
.L1144:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov rbx, rax
section .data
.str1159: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1159]
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_ar_name
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    mov r9, rbx
    mov r10, r12
    sub rsp, 32
    call xl_f4
    add rsp, 32
.L1145:
    mov rcx, r13
    sub rsp, 32
    call xl_ar_fk
    add rsp, 32
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1135
.__ret_1135:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
xl_arith_logic:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov [rbp-24], r8
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, [rbp-8]
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1165
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1165
    mov rax, 1
    jmp .L1166
.L1165:
    mov rax, 0
.L1166:
    test rax, rax
    jz .L1163
    mov rax, r14
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1163
    mov rax, 1
    jmp .L1164
.L1163:
    mov rax, 0
.L1164:
    test rax, rax
    jz .L1161
    mov rcx, [rbp-24]
    mov rdx, 0
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
    mov rax, 1
    mov r13, rax
    jmp .L1162
.L1161:
.L1162:
    cmp r13, 0
    jne .L1167
    mov rcx, [rbp-8]
    sub rsp, 32
    call xl_ar_name
    add rsp, 32
    mov [rbp-56], rax
    mov rcx, r15
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    pop rcx
    mov rdx, [rbp-24]
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1169
    mov rcx, r14
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov rbx, rax
    mov rax, 64
    mov [rbp-80], rax
    cmp r15, 8
    je .L1171
    mov rax, 32
    mov [rbp-80], rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    jmp .L1172
.L1171:
.L1172:
    mov rcx, rbx
    mov rdx, [rbp-80]
    sub rsp, 32
    call xl_logic_ok
    add rsp, 32
    cmp rax, 0
    je .L1173
section .data
.str1175: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str1175]
    push rax
    pop rcx
    mov rdx, [rbp-56]
    mov r8, r12
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    mov rax, 1
    mov r13, rax
    jmp .L1174
.L1173:
.L1174:
    jmp .L1170
.L1169:
.L1170:
    cmp r13, 0
    jne .L1176
    mov rcx, r14
    mov rdx, r15
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1178: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1178]
    push rax
    pop rcx
    mov rdx, [rbp-56]
    mov r8, r12
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .L1177
.L1176:
.L1177:
    jmp .L1168
.L1167:
.L1168:
    mov rax, [rel __g_xarm_F_LOGIC]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, [rbp-8]
    cmp rax, 2
    je .L1179
    mov rax, [rbp-24]
    add rax, 1
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 1
    mov [rel __g_xarm_xl_fpw], rax
    cmp r15, 8
    jne .L1181
    mov rax, 0
    mov [rel __g_xarm_xl_fpw], rax
    jmp .L1182
.L1181:
.L1182:
    jmp .L1180
.L1179:
.L1180:
    mov rax, 0
    jmp .__ret_1160
.__ret_1160:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
xl_arith_partial:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov r15, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r14, rax
    mov rcx, r15
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r13, rax
    mov rcx, r15
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1184
section .data
.str1186: db 32,32,32,32,109,111,118,32,119,49,55,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1186]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_val
    add rsp, 32
    and rax, 65535
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
section .data
.str1187: db 119,49,55,0
section .text
    lea rax, [rel .str1187]
    mov rbx, rax
    jmp .L1185
.L1184:
    mov rcx, r14
    mov rdx, 4
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
.L1185:
section .data
.str1188: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1188]
    push rax
    mov rcx, [rbp-8]
    sub rsp, 32
    call xl_ar_plain
    add rsp, 32
    push rax
section .data
.str1189: db 119,49,54,0
section .text
    lea rax, [rel .str1189]
    push rax
    mov rcx, 119
    mov rdx, r12
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_REG]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 16
    mov r8, r13
    sub rsp, 32
    call xl_merge_low
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1183
.__ret_1183:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
xl_arith_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov r15, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r14, rax
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1191
    mov rax, 8
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1193
    mov rcx, r14
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r13, rax
    jmp .L1194
.L1193:
.L1194:
    jmp .L1192
.L1191:
.L1192:
section .data
.str1195: db 119,49,55,0
section .text
    lea rax, [rel .str1195]
    mov r12, rax
    cmp r13, 4
    jle .L1196
section .data
.str1198: db 120,49,55,0
section .text
    lea rax, [rel .str1198]
    mov r12, rax
    jmp .L1197
.L1196:
.L1197:
    mov rcx, r15
    mov rdx, 0
    mov r8, r13
    mov r9, r12
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rax, r13
    mov rbx, rax
    cmp rbx, 4
    jge .L1199
    mov rax, 4
    mov rbx, rax
    jmp .L1200
.L1199:
.L1200:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1201: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1201]
    push rax
    mov rcx, [rbp-8]
    sub rsp, 32
    call xl_ar_name
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    mov rcx, r15
    mov rdx, 1
    mov r8, r13
    mov r9, r12
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rcx, [rbp-8]
    sub rsp, 32
    call xl_ar_fk
    add rsp, 32
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, [rbp-8]
    cmp rax, 3
    jl .L1202
    mov rax, 18
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 1
    mov [rel __g_xarm_xl_fpw], rax
    cmp r13, 4
    jle .L1204
    mov rax, 0
    mov [rel __g_xarm_xl_fpw], rax
    jmp .L1205
.L1204:
.L1205:
    jmp .L1203
.L1202:
.L1203:
    mov rax, 0
    jmp .__ret_1190
.__ret_1190:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
xl_incdec:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1207
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1206
    jmp .L1208
.L1207:
.L1208:
    mov rax, 120
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 8
    je .L1209
    mov rax, 119
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 4
    je .L1211
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1206
    jmp .L1212
.L1211:
.L1212:
    jmp .L1210
.L1209:
.L1210:
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov rbx, rax
section .data
.str1213: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,35,49,10,0
section .text
    lea rax, [rel .str1213]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, rbx
    mov r9, rbx
    sub rsp, 32
    call xl_f3
    add rsp, 32
    mov rax, r13
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1206
.__ret_1206:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_i_neg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1215
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1214
    jmp .L1216
.L1215:
.L1216:
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
section .data
.str1217: db 32,32,32,32,115,117,98,115,32,37,120,44,32,120,122,114,44,32,37,120,10,0
section .text
    lea rax, [rel .str1217]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, [rel __g_xarm_F_SUB]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1214
.__ret_1214:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_i_not:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1219
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1218
    jmp .L1220
.L1219:
.L1220:
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
section .data
.str1221: db 32,32,32,32,109,118,110,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1221]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1218
.__ret_1218:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_i_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r14, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1223
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_OP_MSIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jne .L1225
    mov rax, 8
    mov r15, rax
    jmp .L1226
.L1225:
.L1226:
section .data
.str1227: db 119,49,55,0
section .text
    lea rax, [rel .str1227]
    mov r13, rax
    cmp r15, 4
    jle .L1228
section .data
.str1230: db 120,49,55,0
section .text
    lea rax, [rel .str1230]
    mov r13, rax
    jmp .L1229
.L1228:
.L1229:
    mov rcx, r12
    mov rdx, 0
    mov r8, r15
    mov r9, r13
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .L1224
.L1223:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1231
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r15, rax
    mov rcx, r15
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov r13, rax
    jmp .L1232
.L1231:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1222
.L1232:
.L1224:
    mov rax, 0
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1233
    mov rcx, r14
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1237
    mov rax, rbx
    mov rcx, 4096
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1237
    mov rax, 1
    jmp .L1238
.L1237:
    mov rax, 0
.L1238:
    test rax, rax
    jz .L1235
section .data
.str1239: db 32,32,32,32,99,109,112,32,37,115,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1239]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, 1
    mov r12, rax
    jmp .L1236
.L1235:
.L1236:
    jmp .L1234
.L1233:
.L1234:
    cmp r12, 0
    jne .L1240
    mov rax, r15
    mov rbx, rax
    cmp rbx, 4
    jge .L1242
    mov rax, 4
    mov rbx, rax
    jmp .L1243
.L1242:
.L1243:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1244: db 32,32,32,32,99,109,112,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1244]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1241
.L1240:
.L1241:
    mov rax, [rel __g_xarm_F_SUB]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1222
.__ret_1222:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
xl_i_test:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1246
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1245
    jmp .L1247
.L1246:
.L1247:
    mov rcx, rbx
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r14, rax
    cmp r14, 4
    jge .L1248
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1245
    jmp .L1249
.L1248:
.L1249:
    mov rcx, r14
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov [rbp-32], rax
    mov rax, 0
    mov r13, rax
    mov rcx, r15
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1250
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov r12, rax
    mov rax, 64
    mov rbx, rax
    cmp r14, 8
    je .L1252
    mov rax, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    jmp .L1253
.L1252:
.L1253:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call xl_logic_ok
    add rsp, 32
    cmp rax, 0
    je .L1254
section .data
.str1256: db 32,32,32,32,116,115,116,32,37,115,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str1256]
    push rax
    pop rcx
    mov rdx, [rbp-32]
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, 1
    mov r13, rax
    jmp .L1255
.L1254:
.L1255:
    jmp .L1251
.L1250:
.L1251:
    cmp r13, 0
    jne .L1257
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1259: db 32,32,32,32,116,115,116,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1259]
    push rax
    pop rcx
    mov rdx, [rbp-32]
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1258
.L1257:
.L1258:
    mov rax, [rel __g_xarm_F_LOGIC]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1245
.__ret_1245:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
xl_i_imul:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rax, [rel __g_xarm_xl_o1]
    mov r14, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r13, rax
    mov rax, [rel __g_xarm_xl_o3]
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1261
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1260
    jmp .L1262
.L1261:
.L1262:
    mov rax, [rel __g_xarm_S_NOPS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 3
    jne .L1263
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1265
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1260
    jmp .L1266
.L1265:
.L1266:
    mov rax, 16
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_val
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str1267: db 32,32,32,32,109,117,108,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1267]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 16
    sub rsp, 32
    call xl_f3
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_1260
    jmp .L1264
.L1263:
.L1264:
    cmp rbx, 2
    je .L1268
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1260
    jmp .L1269
.L1268:
.L1269:
    mov rcx, r14
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rax, 16
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1270
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
    jmp .L1271
.L1270:
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call xl_src
    add rsp, 32
.L1271:
section .data
.str1272: db 32,32,32,32,109,117,108,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1272]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r12
    mov r9, rbx
    sub rsp, 32
    call xl_f3
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_1260
.__ret_1260:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_divide:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1274
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1273
    jmp .L1275
.L1274:
.L1275:
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
section .data
.str1276: db 32,32,32,32,37,115,32,120,49,54,44,32,120,48,44,32,37,120,10,0
section .text
    lea rax, [rel .str1276]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
section .data
.str1277: db 32,32,32,32,109,115,117,98,32,120,50,44,32,120,49,54,44,32,37,120,44,32,120,48,10,0
section .text
    lea rax, [rel .str1277]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_f1
    add rsp, 32
section .data
.str1278: db 32,32,32,32,109,111,118,32,120,48,44,32,120,49,54,10,0
section .text
    lea rax, [rel .str1278]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_1273
.__ret_1273:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1280
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1279
    jmp .L1281
.L1280:
.L1281:
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 8
    je .L1282
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1279
    jmp .L1283
.L1282:
.L1283:
    mov rcx, r12
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1284
    mov rcx, rbx
    sub rsp, 32
    call xl_val
    add rsp, 32
    and rax, 63
    mov rbx, rax
    cmp r13, 0
    je .L1286
    mov rax, 0
    sub rax, rbx
    and rax, 63
    mov rbx, rax
    jmp .L1287
.L1286:
.L1287:
section .data
.str1288: db 32,32,32,32,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1288]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r12
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_1279
    jmp .L1285
.L1284:
.L1285:
    cmp r13, 0
    je .L1289
section .data
.str1291: db 32,32,32,32,115,117,98,32,120,49,54,44,32,120,122,114,44,32,120,49,10,32,32,32,32,114,111,114,32,37,120,44,32,37,120,44,32,120,49,54,10,0
section .text
    lea rax, [rel .str1291]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1279
    jmp .L1290
.L1289:
.L1290:
section .data
.str1292: db 32,32,32,32,37,115,32,37,120,44,32,37,120,44,32,120,49,10,0
section .text
    lea rax, [rel .str1292]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r12
    mov r9, r12
    sub rsp, 32
    call xl_f3
    add rsp, 32
    jmp .__ret_1279
.__ret_1279:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_i_xchg:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r13, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1294
    mov rax, [rel __g_xarm_xl_o2]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o1]
    mov r13, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1296
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1293
    jmp .L1297
.L1296:
.L1297:
    jmp .L1295
.L1294:
.L1295:
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1298
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1293
    jmp .L1299
.L1298:
.L1299:
    mov rcx, rbx
    sub rsp, 32
    call xl_addr
    add rsp, 32
    mov rax, [rel __g_xarm_xl_mo]
    cmp rax, 0
    je .L1300
    mov rax, 16
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
section .data
.str1302: db 0
section .text
    lea rax, [rel .str1302]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_add_imm
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    jmp .L1301
.L1300:
.L1301:
    mov rax, [rel __g_xarm_xl_uniq]
    add rax, 1
    mov [rel __g_xarm_xl_uniq], rax
section .data
.str1303: db 46,120,97,37,100,58,10,0
section .text
    lea rax, [rel .str1303]
    push rax
    mov rax, [rel __g_xarm_xl_uniq]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_xarm_xl_mb]
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 8
    jne .L1304
section .data
.str1306: db 32,32,32,32,108,100,97,120,114,32,120,49,53,44,32,91,37,120,93,10,32,32,32,32,115,116,108,120,114,32,119,49,52,44,32,37,120,44,32,91,37,120,93,10,32,32,32,32,99,98,110,122,32,119,49,52,44,32,46,120,97,37,100,10
    db 32,32,32,32,109,111,118,32,37,120,44,32,120,49,53,10,0
section .text
    lea rax, [rel .str1306]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_xl_uniq]
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    mov rax, r12
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .L1305
.L1304:
    mov rcx, r13
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 4
    jne .L1307
section .data
.str1309: db 32,32,32,32,108,100,97,120,114,32,119,49,53,44,32,91,37,120,93,10,32,32,32,32,115,116,108,120,114,32,119,49,52,44,32,37,119,44,32,91,37,120,93,10,32,32,32,32,99,98,110,122,32,119,49,52,44,32,46,120,97,37,100,10
    db 32,32,32,32,109,111,118,32,37,119,44,32,119,49,53,10,0
section .text
    lea rax, [rel .str1309]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_xl_uniq]
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    mov rax, r12
    sub rsp, 32
    call xl_fmt
    add rsp, 32
    jmp .L1308
.L1307:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1293
.L1308:
.L1305:
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_1293
.__ret_1293:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_i_jmp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1311
section .data
.str1313: db 32,32,32,32,98,114,32,37,120,10,0
section .text
    lea rax, [rel .str1313]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1310
    jmp .L1312
.L1311:
.L1312:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1314
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1310
    jmp .L1315
.L1314:
.L1315:
section .data
.str1316: db 32,32,32,32,98,32,37,115,10,0
section .text
    lea rax, [rel .str1316]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1310
.__ret_1310:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_i_call:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1318
section .data
.str1320: db 32,32,32,32,115,116,114,32,120,51,48,44,32,91,120,50,56,44,32,35,45,56,93,33,10,32,32,32,32,98,108,114,32,37,120,10,32,32,32,32,108,100,114,32,120,51,48,44,32,91,120,50,56,93,44,32,35,56,10,0
section .text
    lea rax, [rel .str1320]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1317
    jmp .L1319
.L1318:
.L1319:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1321
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1317
    jmp .L1322
.L1321:
.L1322:
section .data
.str1323: db 32,32,32,32,115,116,114,32,120,51,48,44,32,91,120,50,56,44,32,35,45,56,93,33,10,32,32,32,32,98,108,32,37,115,10,32,32,32,32,108,100,114,32,120,51,48,44,32,91,120,50,56,93,44,32,35,56,10,0
section .text
    lea rax, [rel .str1323]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1317
.__ret_1317:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_i_jcc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1325
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1324
    jmp .L1326
.L1325:
.L1326:
    mov rax, [rel __g_xarm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_cond
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1327
section .data
.str1329: db 32,32,32,32,98,46,37,115,32,37,115,10,0
section .text
    lea rax, [rel .str1329]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_OP_TEXT]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g64
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1328
.L1327:
.L1328:
    mov rax, 0
    jmp .__ret_1324
.__ret_1324:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_i_setcc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1331
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1330
    jmp .L1332
.L1331:
.L1332:
    mov rax, [rel __g_xarm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call xl_cond
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1333
section .data
.str1335: db 32,32,32,32,99,115,101,116,32,37,120,44,32,37,115,10,0
section .text
    lea rax, [rel .str1335]
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1334
.L1333:
.L1334:
    mov rax, 0
    jmp .__ret_1330
.__ret_1330:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_i_movsd:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_xarm_xl_o1]
    mov r14, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1337
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1339
section .data
.str1341: db 32,32,32,32,102,109,111,118,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1341]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1336
    jmp .L1340
.L1339:
.L1340:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1342
    mov rax, r13
    push rax
    mov rax, 0
    push rax
    mov rax, 8
    push rax
    mov rax, 100
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1336
    jmp .L1343
.L1342:
.L1343:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1344
section .data
.str1346: db 32,32,32,32,102,109,111,118,32,37,68,44,32,37,120,10,0
section .text
    lea rax, [rel .str1346]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1336
    jmp .L1345
.L1344:
.L1345:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1336
    jmp .L1338
.L1337:
.L1338:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1347
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1336
    jmp .L1348
.L1347:
.L1348:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1349
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, 8
    push rax
    mov rax, 100
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1336
    jmp .L1350
.L1349:
.L1350:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1351
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1336
    jmp .L1352
.L1351:
.L1352:
section .data
.str1353: db 32,32,32,32,102,109,111,118,32,37,120,44,32,37,68,10,0
section .text
    lea rax, [rel .str1353]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1336
.__ret_1336:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_i_movss:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_xarm_xl_o1]
    mov r14, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1355
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1357
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1354
    jmp .L1358
.L1357:
.L1358:
    mov rax, r13
    push rax
    mov rax, 0
    push rax
    mov rax, 4
    push rax
    mov rax, 115
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1354
    jmp .L1356
.L1355:
.L1356:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1361
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1361
    mov rax, 0
    jmp .L1362
.L1361:
    mov rax, 1
.L1362:
    test rax, rax
    jz .L1359
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1354
    jmp .L1360
.L1359:
.L1360:
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, 4
    push rax
    mov rax, 115
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1354
.__ret_1354:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_fcvt_sd:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1366
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1366
    mov rax, 0
    jmp .L1367
.L1366:
    mov rax, 1
.L1367:
    test rax, rax
    jz .L1364
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1363
    jmp .L1365
.L1364:
.L1365:
    mov rax, r13
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1363
.__ret_1363:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_i_movups:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_xarm_xl_o1]
    mov r14, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1369
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1371
section .data
.str1373: db 32,32,32,32,109,111,118,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str1373]
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1368
    jmp .L1372
.L1371:
.L1372:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1374
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1368
    jmp .L1375
.L1374:
.L1375:
    mov rax, r13
    push rax
    mov rax, 0
    push rax
    mov rax, 16
    push rax
    mov rax, 113
    push rax
    mov rcx, r14
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1368
    jmp .L1370
.L1369:
.L1370:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1378
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1378
    mov rax, 0
    jmp .L1379
.L1378:
    mov rax, 1
.L1379:
    test rax, rax
    jz .L1376
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1368
    jmp .L1377
.L1376:
.L1377:
    mov rax, r14
    push rax
    mov rax, 1
    push rax
    mov rax, 16
    push rax
    mov rax, 113
    push rax
    mov rcx, r13
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1368
.__ret_1368:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_fsrc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_xarm_xl_o2]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1381
    mov rcx, rbx
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    jmp .__ret_1380
    jmp .L1382
.L1381:
.L1382:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1383
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
    mov rax, 8
    push rax
section .data
.str1385: db 100,49,54,0
section .text
    lea rax, [rel .str1385]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rax, 16
    jmp .__ret_1380
    jmp .L1384
.L1383:
.L1384:
section .data
.str1386: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str1386]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_1380
.__ret_1380:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_fscalar:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1388
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1387
    jmp .L1389
.L1388:
.L1389:
    sub rsp, 32
    call xl_fsrc
    add rsp, 32
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    mov rbx, rax
    cmp r13, 0
    je .L1390
section .data
.str1392: db 32,32,32,32,37,115,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1392]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, rbx
    mov r9, r12
    sub rsp, 32
    call xl_f3
    add rsp, 32
    jmp .__ret_1387
    jmp .L1391
.L1390:
.L1391:
section .data
.str1393: db 32,32,32,32,37,115,32,37,68,44,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1393]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, rbx
    mov r9, rbx
    mov r10, r12
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_1387
.__ret_1387:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_fpacked:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1397
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1397
    mov rax, 0
    jmp .L1398
.L1397:
    mov rax, 1
.L1398:
    test rax, rax
    jz .L1395
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1394
    jmp .L1396
.L1395:
.L1396:
    mov rcx, rbx
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, r14
    push rax
    mov rax, rbx
    push rax
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_1394
.__ret_1394:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_i_ucomisd:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1400
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1399
    jmp .L1401
.L1400:
.L1401:
    sub rsp, 32
    call xl_fsrc
    add rsp, 32
    mov rbx, rax
section .data
.str1402: db 32,32,32,32,102,99,109,112,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1402]
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, [rel __g_xarm_F_FP]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1399
.__ret_1399:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_i_cvtsi2sd:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rax, [rel __g_xarm_xl_o1]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1406
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1406
    mov rax, 0
    jmp .L1407
.L1406:
    mov rax, 1
.L1407:
    test rax, rax
    jz .L1404
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1403
    jmp .L1405
.L1404:
.L1405:
    mov rcx, rbx
    sub rsp, 32
    call xl_rs
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov rbx, rax
section .data
.str1408: db 32,32,32,32,115,99,118,116,102,32,37,68,44,32,37,115,10,0
section .text
    lea rax, [rel .str1408]
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1403
.__ret_1403:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
xl_tofix:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_o2]
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1412
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1412
    mov rax, 0
    jmp .L1413
.L1412:
    mov rax, 1
.L1413:
    test rax, rax
    jz .L1410
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1409
    jmp .L1411
.L1410:
.L1411:
    mov rcx, rbx
    sub rsp, 32
    call xl_rs
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_xw
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_regname
    add rsp, 32
    mov rbx, rax
section .data
.str1414: db 32,32,32,32,37,115,32,37,115,44,32,37,68,10,0
section .text
    lea rax, [rel .str1414]
    push rax
    mov rax, r13
    push rax
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f3
    add rsp, 32
    jmp .__ret_1409
.__ret_1409:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
xl_cacheop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_xarm_xl_o1]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1416
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1415
    jmp .L1417
.L1416:
.L1417:
    mov rcx, rbx
    sub rsp, 32
    call xl_addr
    add rsp, 32
    mov rax, [rel __g_xarm_xl_mo]
    cmp rax, 0
    je .L1418
    mov rax, 16
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
section .data
.str1420: db 0
section .text
    lea rax, [rel .str1420]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_add_imm
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    jmp .L1419
.L1418:
.L1419:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1415
.__ret_1415:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
xl_translate:
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
    mov rbx, r9
    sub rsp, 32
    call xl_init
    add rsp, 32
    mov rax, [rel __g_xarm_S_IN]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_IN_END]
    push rax
    mov rax, r14
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, r12
    mov [rel __g_xarm_xl_out], rax
    mov rax, r12
    add rax, rbx
    sub rax, 65536
    mov [rel __g_xarm_xl_out_end], rax
    mov rax, [rel __g_xarm_S_LINE_NO]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR_LINE]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    mov [rel __g_xarm_xl_uniq], rax
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR_MSG]
    push rax
section .data
.str1422: db 110,111,32,65,82,77,54,52,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str1422]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR_INSN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
.L1423:
    mov rax, 1
    test rax, rax
    jz .L1424
    mov rax, [rel __g_xarm_S_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 0
    je .L1426
    mov rax, 1
    neg rax
    jmp .__ret_1421
    jmp .L1427
.L1426:
.L1427:
    mov rax, [rel __g_xarm_xl_out]
    push rax
    mov rax, [rel __g_xarm_xl_out_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1428
    mov rax, [rel __g_xarm_S_ERR_MSG]
    push rax
section .data
.str1430: db 111,117,116,112,117,116,32,98,117,102,102,101,114,32,102,117,108,108,0
section .text
    lea rax, [rel .str1430]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, [rel __g_xarm_S_ERR_LINE]
    push rax
    mov rax, [rel __g_xarm_S_LINE_NO]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_1421
    jmp .L1429
.L1428:
.L1429:
    sub rsp, 32
    call xl_read_line
    add rsp, 32
    cmp rax, 0
    jne .L1431
    jmp .L1424
    jmp .L1432
.L1431:
.L1432:
    sub rsp, 32
    call xl_native_skip
    add rsp, 32
    cmp rax, 0
    jne .L1433
    sub rsp, 32
    call xl_do_line
    add rsp, 32
    jmp .L1434
.L1433:
.L1434:
.L1425:
    jmp .L1423
.L1424:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_xarm_S_OS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 1
    jne .L1435
    mov rax, 1
    mov rbx, rax
    jmp .L1436
.L1435:
.L1436:
    mov rcx, rbx
    sub rsp, 32
    call xa_get_tail
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, [rel __g_xarm_S_LIB]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 0
    je .L1437
    mov rax, 2
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xa_get_tail
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .L1438
.L1437:
.L1438:
    mov rax, [rel __g_xarm_xl_out]
    sub rax, r12
    jmp .__ret_1421
.__ret_1421:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
xl_last_ok:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xarm_xl_ok]
    jmp .__ret_1439
.__ret_1439:
    mov rsp, rbp
    pop rbp
    ret
