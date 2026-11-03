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
section .bss
__g_xarm_xa_state: resq 271
section .text
xa_get_state:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_xarm_xa_state]
    jmp .__ret_4
.__ret_4:
    mov rsp, rbp
    pop rbp
    ret
xarm_set_os:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xarm_S_OS]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_set
    add rsp, 32
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xarm_set_lib:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_xarm_S_LIB]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_set
    add rsp, 32
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xarm_error_line:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xarm_S_ERR_LINE]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    jmp .__ret_7
.__ret_7:
    mov rsp, rbp
    pop rbp
    ret
xarm_error_text:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xarm_S_ERR_MSG]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    jmp .__ret_8
.__ret_8:
    mov rsp, rbp
    pop rbp
    ret
xarm_error_insn:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xarm_S_ERR_INSN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    jmp .__ret_9
.__ret_9:
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
    jne .L11
    sub rsp, 32
    call xa_get_state
    add rsp, 32
    mov [rel __g_xarm_xl_st], rax
    sub rsp, 32
    call xl_init
    add rsp, 32
    jmp .L12
.L11:
.L12:
    mov rax, [rel __g_xarm_xl_st]
    add rax, rbx
    jmp .__ret_10
.__ret_10:
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
    jmp .__ret_13
.__ret_13:
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
    jmp .__ret_14
.__ret_14:
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
    jmp .__ret_15
.__ret_15:
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
    jmp .__ret_16
.__ret_16:
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
.str18: db 101,0
section .text
    lea rax, [rel .str18]
    push rax
section .data
.str19: db 101,113,0
section .text
    lea rax, [rel .str19]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str20: db 122,0
section .text
    lea rax, [rel .str20]
    push rax
section .data
.str21: db 101,113,0
section .text
    lea rax, [rel .str21]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str22: db 110,101,0
section .text
    lea rax, [rel .str22]
    push rax
section .data
.str23: db 110,101,0
section .text
    lea rax, [rel .str23]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str24: db 110,122,0
section .text
    lea rax, [rel .str24]
    push rax
section .data
.str25: db 110,101,0
section .text
    lea rax, [rel .str25]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, 0
    jmp .__ret_17
.__ret_17:
    mov rsp, rbp
    pop rbp
    ret
xl_init:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_xarm_xl_ready]
    cmp rax, 0
    je .L27
    mov rax, 0
    jmp .__ret_26
    jmp .L28
.L27:
.L28:
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
.str29: db 114,97,120,0
section .text
    lea rax, [rel .str29]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str30: db 114,99,120,0
section .text
    lea rax, [rel .str30]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str31: db 114,100,120,0
section .text
    lea rax, [rel .str31]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str32: db 114,98,120,0
section .text
    lea rax, [rel .str32]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str33: db 114,115,112,0
section .text
    lea rax, [rel .str33]
    push rax
    pop rcx
    mov rdx, 4
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str34: db 114,98,112,0
section .text
    lea rax, [rel .str34]
    push rax
    pop rcx
    mov rdx, 5
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str35: db 114,115,105,0
section .text
    lea rax, [rel .str35]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str36: db 114,100,105,0
section .text
    lea rax, [rel .str36]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str37: db 114,56,0
section .text
    lea rax, [rel .str37]
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str38: db 114,57,0
section .text
    lea rax, [rel .str38]
    push rax
    pop rcx
    mov rdx, 9
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str39: db 114,49,48,0
section .text
    lea rax, [rel .str39]
    push rax
    pop rcx
    mov rdx, 10
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str40: db 114,49,49,0
section .text
    lea rax, [rel .str40]
    push rax
    pop rcx
    mov rdx, 11
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str41: db 114,49,50,0
section .text
    lea rax, [rel .str41]
    push rax
    pop rcx
    mov rdx, 12
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str42: db 114,49,51,0
section .text
    lea rax, [rel .str42]
    push rax
    pop rcx
    mov rdx, 13
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str43: db 114,49,52,0
section .text
    lea rax, [rel .str43]
    push rax
    pop rcx
    mov rdx, 14
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str44: db 114,49,53,0
section .text
    lea rax, [rel .str44]
    push rax
    pop rcx
    mov rdx, 15
    mov r8, 8
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str45: db 101,97,120,0
section .text
    lea rax, [rel .str45]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str46: db 101,99,120,0
section .text
    lea rax, [rel .str46]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str47: db 101,100,120,0
section .text
    lea rax, [rel .str47]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str48: db 101,98,120,0
section .text
    lea rax, [rel .str48]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str49: db 101,115,112,0
section .text
    lea rax, [rel .str49]
    push rax
    pop rcx
    mov rdx, 4
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str50: db 101,98,112,0
section .text
    lea rax, [rel .str50]
    push rax
    pop rcx
    mov rdx, 5
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str51: db 101,115,105,0
section .text
    lea rax, [rel .str51]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str52: db 101,100,105,0
section .text
    lea rax, [rel .str52]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str53: db 114,56,100,0
section .text
    lea rax, [rel .str53]
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str54: db 114,57,100,0
section .text
    lea rax, [rel .str54]
    push rax
    pop rcx
    mov rdx, 9
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str55: db 114,49,48,100,0
section .text
    lea rax, [rel .str55]
    push rax
    pop rcx
    mov rdx, 10
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str56: db 114,49,49,100,0
section .text
    lea rax, [rel .str56]
    push rax
    pop rcx
    mov rdx, 11
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str57: db 114,49,50,100,0
section .text
    lea rax, [rel .str57]
    push rax
    pop rcx
    mov rdx, 12
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str58: db 114,49,51,100,0
section .text
    lea rax, [rel .str58]
    push rax
    pop rcx
    mov rdx, 13
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str59: db 114,49,52,100,0
section .text
    lea rax, [rel .str59]
    push rax
    pop rcx
    mov rdx, 14
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str60: db 114,49,53,100,0
section .text
    lea rax, [rel .str60]
    push rax
    pop rcx
    mov rdx, 15
    mov r8, 4
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str61: db 97,120,0
section .text
    lea rax, [rel .str61]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str62: db 99,120,0
section .text
    lea rax, [rel .str62]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str63: db 100,120,0
section .text
    lea rax, [rel .str63]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str64: db 98,120,0
section .text
    lea rax, [rel .str64]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str65: db 115,105,0
section .text
    lea rax, [rel .str65]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str66: db 100,105,0
section .text
    lea rax, [rel .str66]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 2
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str67: db 97,108,0
section .text
    lea rax, [rel .str67]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str68: db 99,108,0
section .text
    lea rax, [rel .str68]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str69: db 100,108,0
section .text
    lea rax, [rel .str69]
    push rax
    pop rcx
    mov rdx, 2
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str70: db 98,108,0
section .text
    lea rax, [rel .str70]
    push rax
    pop rcx
    mov rdx, 3
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str71: db 115,105,108,0
section .text
    lea rax, [rel .str71]
    push rax
    pop rcx
    mov rdx, 6
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str72: db 100,105,108,0
section .text
    lea rax, [rel .str72]
    push rax
    pop rcx
    mov rdx, 7
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str73: db 114,56,98,0
section .text
    lea rax, [rel .str73]
    push rax
    pop rcx
    mov rdx, 8
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str74: db 114,57,98,0
section .text
    lea rax, [rel .str74]
    push rax
    pop rcx
    mov rdx, 9
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str75: db 114,49,48,98,0
section .text
    lea rax, [rel .str75]
    push rax
    pop rcx
    mov rdx, 10
    mov r8, 1
    sub rsp, 32
    call xl_reg
    add rsp, 32
section .data
.str76: db 114,49,49,98,0
section .text
    lea rax, [rel .str76]
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
.str77: db 108,0
section .text
    lea rax, [rel .str77]
    push rax
section .data
.str78: db 108,116,0
section .text
    lea rax, [rel .str78]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str79: db 110,103,101,0
section .text
    lea rax, [rel .str79]
    push rax
section .data
.str80: db 108,116,0
section .text
    lea rax, [rel .str80]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str81: db 108,101,0
section .text
    lea rax, [rel .str81]
    push rax
section .data
.str82: db 108,101,0
section .text
    lea rax, [rel .str82]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str83: db 110,103,0
section .text
    lea rax, [rel .str83]
    push rax
section .data
.str84: db 108,101,0
section .text
    lea rax, [rel .str84]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str85: db 103,0
section .text
    lea rax, [rel .str85]
    push rax
section .data
.str86: db 103,116,0
section .text
    lea rax, [rel .str86]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str87: db 110,108,101,0
section .text
    lea rax, [rel .str87]
    push rax
section .data
.str88: db 103,116,0
section .text
    lea rax, [rel .str88]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str89: db 103,101,0
section .text
    lea rax, [rel .str89]
    push rax
section .data
.str90: db 103,101,0
section .text
    lea rax, [rel .str90]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str91: db 110,108,0
section .text
    lea rax, [rel .str91]
    push rax
section .data
.str92: db 103,101,0
section .text
    lea rax, [rel .str92]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str93: db 98,0
section .text
    lea rax, [rel .str93]
    push rax
section .data
.str94: db 108,111,0
section .text
    lea rax, [rel .str94]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str95: db 99,0
section .text
    lea rax, [rel .str95]
    push rax
section .data
.str96: db 108,111,0
section .text
    lea rax, [rel .str96]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str97: db 110,97,101,0
section .text
    lea rax, [rel .str97]
    push rax
section .data
.str98: db 108,111,0
section .text
    lea rax, [rel .str98]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str99: db 98,101,0
section .text
    lea rax, [rel .str99]
    push rax
section .data
.str100: db 108,115,0
section .text
    lea rax, [rel .str100]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str101: db 110,97,0
section .text
    lea rax, [rel .str101]
    push rax
section .data
.str102: db 108,115,0
section .text
    lea rax, [rel .str102]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str103: db 97,0
section .text
    lea rax, [rel .str103]
    push rax
section .data
.str104: db 104,105,0
section .text
    lea rax, [rel .str104]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str105: db 110,98,101,0
section .text
    lea rax, [rel .str105]
    push rax
section .data
.str106: db 104,105,0
section .text
    lea rax, [rel .str106]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str107: db 97,101,0
section .text
    lea rax, [rel .str107]
    push rax
section .data
.str108: db 104,115,0
section .text
    lea rax, [rel .str108]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str109: db 110,98,0
section .text
    lea rax, [rel .str109]
    push rax
section .data
.str110: db 104,115,0
section .text
    lea rax, [rel .str110]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str111: db 110,99,0
section .text
    lea rax, [rel .str111]
    push rax
section .data
.str112: db 104,115,0
section .text
    lea rax, [rel .str112]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str113: db 115,0
section .text
    lea rax, [rel .str113]
    push rax
section .data
.str114: db 109,105,0
section .text
    lea rax, [rel .str114]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str115: db 110,115,0
section .text
    lea rax, [rel .str115]
    push rax
section .data
.str116: db 112,108,0
section .text
    lea rax, [rel .str116]
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
.str117: db 115,0
section .text
    lea rax, [rel .str117]
    push rax
section .data
.str118: db 109,105,0
section .text
    lea rax, [rel .str118]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str119: db 110,115,0
section .text
    lea rax, [rel .str119]
    push rax
section .data
.str120: db 112,108,0
section .text
    lea rax, [rel .str120]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str121: db 108,0
section .text
    lea rax, [rel .str121]
    push rax
section .data
.str122: db 108,116,0
section .text
    lea rax, [rel .str122]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str123: db 103,101,0
section .text
    lea rax, [rel .str123]
    push rax
section .data
.str124: db 103,101,0
section .text
    lea rax, [rel .str124]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str125: db 108,101,0
section .text
    lea rax, [rel .str125]
    push rax
section .data
.str126: db 108,101,0
section .text
    lea rax, [rel .str126]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str127: db 103,0
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
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_logic_end], rax
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_add], rax
    sub rsp, 32
    call xl_cc_eq
    add rsp, 32
section .data
.str129: db 115,0
section .text
    lea rax, [rel .str129]
    push rax
section .data
.str130: db 109,105,0
section .text
    lea rax, [rel .str130]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str131: db 110,115,0
section .text
    lea rax, [rel .str131]
    push rax
section .data
.str132: db 112,108,0
section .text
    lea rax, [rel .str132]
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
.str133: db 97,0
section .text
    lea rax, [rel .str133]
    push rax
section .data
.str134: db 103,116,0
section .text
    lea rax, [rel .str134]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str135: db 110,98,101,0
section .text
    lea rax, [rel .str135]
    push rax
section .data
.str136: db 103,116,0
section .text
    lea rax, [rel .str136]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str137: db 97,101,0
section .text
    lea rax, [rel .str137]
    push rax
section .data
.str138: db 103,101,0
section .text
    lea rax, [rel .str138]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str139: db 110,98,0
section .text
    lea rax, [rel .str139]
    push rax
section .data
.str140: db 103,101,0
section .text
    lea rax, [rel .str140]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str141: db 110,99,0
section .text
    lea rax, [rel .str141]
    push rax
section .data
.str142: db 103,101,0
section .text
    lea rax, [rel .str142]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str143: db 98,0
section .text
    lea rax, [rel .str143]
    push rax
section .data
.str144: db 108,116,0
section .text
    lea rax, [rel .str144]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str145: db 99,0
section .text
    lea rax, [rel .str145]
    push rax
section .data
.str146: db 108,116,0
section .text
    lea rax, [rel .str146]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str147: db 98,101,0
section .text
    lea rax, [rel .str147]
    push rax
section .data
.str148: db 108,101,0
section .text
    lea rax, [rel .str148]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
section .data
.str149: db 110,97,0
section .text
    lea rax, [rel .str149]
    push rax
section .data
.str150: db 108,101,0
section .text
    lea rax, [rel .str150]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_cc
    add rsp, 32
    mov rax, [rel __g_xarm_xl_cc_n]
    mov [rel __g_xarm_xl_cc_fp_end], rax
    mov rax, 0
    jmp .__ret_26
.__ret_26:
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
.L152:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 32
    jne .L153
    add rbx, 1
.L154:
    jmp .L152
.L153:
    mov rax, rbx
    jmp .__ret_151
.__ret_151:
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
.L156:
    mov rax, 1
    test rax, rax
    jz .L157
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
    je .L159
    mov rax, 0
    jmp .__ret_155
    jmp .L160
.L159:
.L160:
    cmp rbx, 0
    jne .L161
    mov rax, 1
    jmp .__ret_155
    jmp .L162
.L161:
.L162:
    add r12, 1
.L158:
    jmp .L156
.L157:
    mov rax, 0
    jmp .__ret_155
.__ret_155:
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
.L164:
    mov rax, 1
    test rax, rax
    jz .L165
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L167
    mov rax, 1
    jmp .__ret_163
    jmp .L168
.L167:
.L168:
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
    je .L169
    mov rax, 0
    jmp .__ret_163
    jmp .L170
.L169:
.L170:
    add r12, 1
.L166:
    jmp .L164
.L165:
    mov rax, 0
    jmp .__ret_163
.__ret_163:
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
    je .L172
    mov rax, 0
    jmp .__ret_171
    jmp .L173
.L172:
.L173:
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
.L174:
    mov rax, 1
    test rax, rax
    jz .L175
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
    jne .L177
    mov rax, 0
    jmp .__ret_171
    jmp .L178
.L177:
.L178:
    add r12, 1
    cmp r12, 150
    jl .L179
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_171
    jmp .L180
.L179:
.L180:
.L176:
    jmp .L174
.L175:
    mov rax, 0
    jmp .__ret_171
.__ret_171:
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
    jl .L182
    mov rax, 0
    jmp .__ret_181
    jmp .L183
.L182:
.L183:
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
.L184:
    mov rax, r15
    mov rcx, [rbp-16]
    cmp rax, rcx
    jge .L185
    mov rcx, r15
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    add r15, 1
    cmp r12, 10
    jne .L187
    jmp .L185
    jmp .L188
.L187:
.L188:
    mov rax, 1
    mov rbx, rax
    mov rax, r12
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L191
    mov rax, [rbp-48]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L191
    mov rax, 0
    jmp .L192
.L191:
    mov rax, 1
.L192:
    test rax, rax
    jz .L189
    mov rax, 0
    mov rbx, rax
    jmp .L190
.L189:
    cmp r13, 0
    je .L193
    cmp r12, r13
    jne .L195
    mov rax, 0
    mov r13, rax
    jmp .L196
.L195:
.L196:
    jmp .L194
.L193:
    cmp r12, 59
    jne .L197
    mov rax, 1
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
    jmp .L198
.L197:
    mov rax, r12
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L201
    mov rax, r12
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L201
    mov rax, 0
    jmp .L202
.L201:
    mov rax, 1
.L202:
    test rax, rax
    jz .L199
    mov rax, r12
    mov r13, rax
    jmp .L200
.L199:
    cmp r12, 9
    jne .L203
    mov rax, 32
    mov r12, rax
    jmp .L204
.L203:
.L204:
.L200:
.L198:
.L194:
.L190:
    cmp rbx, 0
    je .L205
    cmp r14, 1000
    jl .L207
    mov rax, 1
    mov [rbp-56], rax
    jmp .L208
.L207:
    mov rax, [rbp-24]
    add rax, r14
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r14, 1
.L208:
    jmp .L206
.L205:
.L206:
.L186:
    jmp .L184
.L185:
    mov rax, [rel __g_xarm_S_IN]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call xl_set
    add rsp, 32
.L209:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L212
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
    jz .L212
    mov rax, 1
    jmp .L213
.L212:
    mov rax, 0
.L213:
    test rax, rax
    jz .L210
    sub r14, 1
.L211:
    jmp .L209
.L210:
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
    je .L214
section .data
.str216: db 108,105,110,101,32,108,111,110,103,101,114,32,116,104,97,110,32,49,48,48,48,32,99,104,97,114,97,99,116,101,114,115,0
section .text
    lea rax, [rel .str216]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    jmp .L215
.L214:
.L215:
    mov rax, 1
    jmp .__ret_181
.__ret_181:
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
.str220: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str220]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L218
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 0
    jmp .__ret_217
    jmp .L219
.L218:
.L219:
    mov rcx, r13
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 46
    jne .L221
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    jmp .__ret_217
    jmp .L222
.L221:
.L222:
    mov rax, r13
    mov r12, rax
.L223:
    mov rax, 1
    test rax, rax
    jz .L224
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
    jnz .L228
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
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
    sub rsp, 32
    call xl_get
    add rsp, 32
    jmp .__ret_217
    jmp .L227
.L226:
.L227:
    cmp rbx, 58
    jne .L230
    jmp .L224
    jmp .L231
.L230:
.L231:
    add r12, 1
.L225:
    jmp .L223
.L224:
    mov rax, r13
    push rax
section .data
.str238: db 95,95,99,99,97,108,108,58,0
section .text
    lea rax, [rel .str238]
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
    jnz .L236
    mov rax, r13
    push rax
section .data
.str239: db 95,95,112,116,95,101,110,116,114,121,58,0
section .text
    lea rax, [rel .str239]
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
    jnz .L236
    mov rax, 0
    jmp .L237
.L236:
    mov rax, 1
.L237:
    test rax, rax
    jnz .L234
    mov rax, r13
    push rax
section .data
.str240: db 95,95,99,101,110,116,114,121,58,0
section .text
    lea rax, [rel .str240]
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
    jnz .L234
    mov rax, 0
    jmp .L235
.L234:
    mov rax, 1
.L235:
    test rax, rax
    jz .L232
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 2
    jmp .__ret_217
    jmp .L233
.L232:
.L233:
    mov rax, [rel __g_xarm_S_SKIPPING]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_set
    add rsp, 32
    mov rax, 0
    jmp .__ret_217
.__ret_217:
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
.L242:
    mov rax, 1
    test rax, rax
    jz .L243
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L245
    jmp .L243
    jmp .L246
.L245:
.L246:
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
.L244:
    jmp .L242
.L243:
    mov rax, 0
    jmp .__ret_241
.__ret_241:
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
    jmp .__ret_247
.__ret_247:
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
    jge .L249
    mov rcx, 45
    sub rsp, 32
    call xl_putc
    add rsp, 32
.L251:
    mov rax, 1
    test rax, rax
    jz .L252
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
    jne .L254
    jmp .L252
    jmp .L255
.L254:
.L255:
.L253:
    jmp .L251
.L252:
    jmp .L250
.L249:
.L256:
    mov rax, 1
    test rax, rax
    jz .L257
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
    jne .L259
    jmp .L257
    jmp .L260
.L259:
.L260:
.L258:
    jmp .L256
.L257:
.L250:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .__ret_248
.__ret_248:
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
.L262:
    mov rax, 1
    test rax, rax
    jz .L263
    mov rax, r12
    and rax, 15
    mov rbx, rax
    sub r13, 1
    cmp rbx, 10
    jge .L265
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
    jmp .L266
.L265:
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
.L266:
    mov rax, r12
    shr rax, 4
    mov r12, rax
    cmp r12, 0
    jne .L267
    jmp .L263
    jmp .L268
.L267:
.L268:
.L264:
    jmp .L262
.L263:
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .__ret_261
.__ret_261:
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
    jz .L272
    mov rax, r12
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L274
    mov rax, r12
    mov rcx, 119
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L274
    mov rax, 0
    jmp .L275
.L274:
    mov rax, 1
.L275:
    test rax, rax
    jz .L272
    mov rax, 1
    jmp .L273
.L272:
    mov rax, 0
.L273:
    test rax, rax
    jz .L270
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
    jmp .__ret_269
    jmp .L271
.L270:
.L271:
    mov rcx, r12
    sub rsp, 32
    call xl_putc
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call xl_put_dec
    add rsp, 32
    jmp .__ret_269
.__ret_269:
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
.L277:
    mov rax, 1
    test rax, rax
    jz .L278
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L280
    jmp .L278
    jmp .L281
.L280:
.L281:
    add r14, 1
    cmp r12, 37
    je .L282
    mov rcx, r12
    sub rsp, 32
    call xl_putc
    add rsp, 32
    jmp .L283
.L282:
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
    jne .L284
    mov rax, [rbp-24]
    mov rbx, rax
    jmp .L285
.L284:
.L285:
    cmp r13, 2
    jne .L286
    mov rax, [rbp-32]
    mov rbx, rax
    jmp .L287
.L286:
.L287:
    cmp r13, 3
    jne .L288
    mov rax, [rbp-40]
    mov rbx, rax
    jmp .L289
.L288:
.L289:
    cmp r13, 4
    jne .L290
    mov rax, [rbp-48]
    mov rbx, rax
    jmp .L291
.L290:
.L291:
    add r13, 1
    cmp r12, 100
    jne .L292
    mov rcx, rbx
    sub rsp, 32
    call xl_put_dec
    add rsp, 32
    jmp .L293
.L292:
    cmp r12, 104
    jne .L294
    mov rcx, rbx
    sub rsp, 32
    call xl_put_hex
    add rsp, 32
    jmp .L295
.L294:
    cmp r12, 115
    jne .L296
    mov rcx, rbx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .L297
.L296:
    cmp r12, 68
    jne .L298
    mov rcx, 100
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    jmp .L299
.L298:
    cmp r12, 81
    jne .L300
    mov rcx, 113
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    jmp .L301
.L300:
    cmp r12, 86
    jne .L302
    mov rcx, 118
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
    jmp .L303
.L302:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call xl_put_reg
    add rsp, 32
.L303:
.L301:
.L299:
.L297:
.L295:
.L293:
.L283:
.L279:
    jmp .L277
.L278:
    mov rax, 0
    jmp .__ret_276
.__ret_276:
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
    jmp .__ret_304
.__ret_304:
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
    jmp .__ret_305
.__ret_305:
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
    jmp .__ret_306
.__ret_306:
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
    jmp .__ret_307
.__ret_307:
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
    jmp .__ret_308
.__ret_308:
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
    jne .L310
    mov rax, 0
    jmp .__ret_309
    jmp .L311
.L310:
.L311:
    mov rax, rbx
    mov [rbp-24], rax
    mov rax, rbx
    mov r14, rax
.L312:
    mov rax, 1
    test rax, rax
    jz .L313
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
    jnz .L317
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L317
    mov rax, 0
    jmp .L318
.L317:
    mov rax, 1
.L318:
    test rax, rax
    jz .L315
    jmp .L313
    jmp .L316
.L315:
.L316:
    cmp rbx, 58
    jne .L319
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
.str321: db 58,10,0
section .text
    lea rax, [rel .str321]
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
.str324: db 95,115,116,97,114,116,0
section .text
    lea rax, [rel .str324]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L322
section .data
.str325: db 32,32,32,32,109,111,118,32,120,50,56,44,32,115,112,10,0
section .text
    lea rax, [rel .str325]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    jmp .L323
.L322:
.L323:
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
    jne .L326
    mov rax, 0
    jmp .__ret_309
    jmp .L327
.L326:
.L327:
    mov rax, r15
    mov r12, rax
.L328:
    mov rax, 1
    test rax, rax
    jz .L329
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
    jne .L331
    jmp .L329
    jmp .L332
.L331:
.L332:
.L330:
    jmp .L328
.L329:
    mov rax, r15
    mov r14, rax
    mov rax, r15
    mov [rbp-24], rax
    jmp .L320
.L319:
    add r14, 1
.L320:
.L314:
    jmp .L312
.L313:
    mov rax, r14
    mov rcx, [rbp-24]
    sub rax, rcx
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 30
    jle .L333
    mov rax, 30
    mov [rbp-64], rax
    jmp .L334
.L333:
.L334:
    mov rax, [rel __g_xarm_S_MN]
    push rax
    pop rcx
    sub rsp, 32
    call xl_s
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L335:
    mov rax, r12
    mov rcx, [rbp-64]
    cmp rax, rcx
    jge .L336
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
    jz .L340
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L340
    mov rax, 1
    jmp .L341
.L340:
    mov rax, 0
.L341:
    test rax, rax
    jz .L338
    add rbx, 32
    jmp .L339
.L338:
.L339:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r12, 1
.L337:
    jmp .L335
.L336:
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
.str348: db 100,101,102,97,117,108,116,0
section .text
    lea rax, [rel .str348]
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
    jnz .L346
    mov rax, r13
    push rax
section .data
.str349: db 98,105,116,115,0
section .text
    lea rax, [rel .str349]
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
    jnz .L346
    mov rax, 0
    jmp .L347
.L346:
    mov rax, 1
.L347:
    test rax, rax
    jnz .L344
    mov rax, r13
    push rax
section .data
.str350: db 101,120,116,101,114,110,0
section .text
    lea rax, [rel .str350]
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
    jnz .L344
    mov rax, 0
    jmp .L345
.L344:
    mov rax, 1
.L345:
    test rax, rax
    jz .L342
    mov rax, 0
    jmp .__ret_309
    jmp .L343
.L342:
.L343:
    mov rax, r13
    push rax
section .data
.str353: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str353]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L351
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
.str354: db 10,0
section .text
    lea rax, [rel .str354]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_309
    jmp .L352
.L351:
.L352:
    mov rax, r13
    push rax
section .data
.str357: db 103,108,111,98,97,108,0
section .text
    lea rax, [rel .str357]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L355
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
.str358: db 10,0
section .text
    lea rax, [rel .str358]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_309
    jmp .L356
.L355:
.L356:
    mov rcx, r13
    sub rsp, 32
    call xl_is_data
    add rsp, 32
    cmp rax, 0
    je .L359
section .data
.str361: db 32,32,32,32,0
section .text
    lea rax, [rel .str361]
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
.str362: db 10,0
section .text
    lea rax, [rel .str362]
    push rax
    pop rcx
    sub rsp, 32
    call xl_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_309
    jmp .L360
.L359:
.L360:
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
    je .L363
    mov rax, 0
    jmp .__ret_309
    jmp .L364
.L363:
.L364:
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
    jmp .__ret_309
.__ret_309:
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
.str368: db 100,98,0
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
    jmp .__ret_365
    jmp .L367
.L366:
.L367:
    mov rax, rbx
    push rax
section .data
.str371: db 100,119,0
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
    jmp .__ret_365
    jmp .L370
.L369:
.L370:
    mov rax, rbx
    push rax
section .data
.str374: db 100,100,0
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
    jmp .__ret_365
    jmp .L373
.L372:
.L373:
    mov rax, rbx
    push rax
section .data
.str377: db 100,113,0
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
    jmp .__ret_365
    jmp .L376
.L375:
.L376:
    mov rax, rbx
    push rax
section .data
.str380: db 114,101,115,98,0
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
    jmp .__ret_365
    jmp .L379
.L378:
.L379:
    mov rax, rbx
    push rax
section .data
.str383: db 114,101,115,119,0
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
    jmp .__ret_365
    jmp .L382
.L381:
.L382:
    mov rax, rbx
    push rax
section .data
.str386: db 114,101,115,100,0
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
    jmp .__ret_365
    jmp .L385
.L384:
.L385:
    mov rax, rbx
    push rax
section .data
.str389: db 114,101,115,113,0
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
    jmp .__ret_365
    jmp .L388
.L387:
.L388:
    mov rax, rbx
    push rax
section .data
.str392: db 116,105,109,101,115,0
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
    jmp .__ret_365
    jmp .L391
.L390:
.L391:
    mov rax, rbx
    push rax
section .data
.str395: db 97,108,105,103,110,0
section .text
    lea rax, [rel .str395]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L393
    mov rax, 1
    jmp .__ret_365
    jmp .L394
.L393:
.L394:
    mov rax, rbx
    push rax
section .data
.str398: db 101,113,117,0
section .text
    lea rax, [rel .str398]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L396
    mov rax, 1
    jmp .__ret_365
    jmp .L397
.L396:
.L397:
    mov rax, 0
    jmp .__ret_365
.__ret_365:
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
.L400:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L403
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
    jz .L403
    mov rax, 1
    jmp .L404
.L403:
    mov rax, 0
.L404:
    test rax, rax
    jz .L401
    sub rbx, 1
.L402:
    jmp .L400
.L401:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_399
.__ret_399:
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
    jne .L406
    mov rax, 0
    jmp .__ret_405
    jmp .L407
.L406:
.L407:
    mov rax, 0
    mov r14, rax
.L408:
    mov rax, 1
    test rax, rax
    jz .L409
    cmp r14, 3
    jl .L411
section .data
.str413: db 110,111,32,65,82,77,54,52,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str413]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_405
    jmp .L412
.L411:
.L412:
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
.L414:
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L415
    mov rcx, r15
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L417
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
    jmp .__ret_405
    jmp .L418
.L417:
.L418:
    mov rax, [rbp-48]
    cmp rax, 0
    je .L419
    mov rax, rbx
    mov rcx, [rbp-48]
    cmp rax, rcx
    jne .L421
    mov rax, 0
    mov [rbp-48], rax
    jmp .L422
.L421:
.L422:
    jmp .L420
.L419:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L425
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L425
    mov rax, 0
    jmp .L426
.L425:
    mov rax, 1
.L426:
    test rax, rax
    jz .L423
    mov rax, rbx
    mov [rbp-48], rax
    jmp .L424
.L423:
    cmp rbx, 91
    jne .L427
    add r12, 1
    jmp .L428
.L427:
    cmp rbx, 93
    jne .L429
    sub r12, 1
    jmp .L430
.L429:
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L433
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L433
    mov rax, 1
    jmp .L434
.L433:
    mov rax, 0
.L434:
    test rax, rax
    jz .L431
    mov rax, 1
    mov [rbp-64], rax
    jmp .L432
.L431:
.L432:
.L430:
.L428:
.L424:
.L420:
    mov rax, [rbp-64]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L437
    mov rax, r13
    mov rcx, 250
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L437
    mov rax, 1
    jmp .L438
.L437:
    mov rax, 0
.L438:
    test rax, rax
    jz .L435
    mov rax, [rbp-32]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add r13, 1
    jmp .L436
.L435:
.L436:
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L439
    add r15, 1
    jmp .L440
.L439:
.L440:
.L416:
    jmp .L414
.L415:
    mov rcx, [rbp-32]
    mov rdx, r13
    sub rsp, 32
    call xl_split_fin
    add rsp, 32
    add r15, 1
    add r14, 1
.L410:
    jmp .L408
.L409:
    mov rax, 0
    jmp .__ret_405
.__ret_405:
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
.L442:
    cmp rbx, 96
    jge .L443
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    add rbx, 1
.L444:
    jmp .L442
.L443:
    mov rax, 0
    mov rbx, rax
.L445:
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
    jge .L446
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
.L447:
    jmp .L445
.L446:
    mov rax, 0
    jmp .__ret_441
.__ret_441:
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
    jne .L449
    mov rax, 0
    jmp .__ret_448
    jmp .L450
.L449:
.L450:
    mov rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L451:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    je .L452
    add r12, 1
    add rbx, 1
.L453:
    jmp .L451
.L452:
    mov rcx, r12
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 32
    je .L454
    mov rax, 0
    jmp .__ret_448
    jmp .L455
.L454:
.L455:
    mov rax, r12
    jmp .__ret_448
.__ret_448:
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
.str457: db 113,119,111,114,100,0
section .text
    lea rax, [rel .str457]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L458
    mov rax, 4
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str460: db 100,119,111,114,100,0
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
    mov rax, 16
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str463: db 111,119,111,114,100,0
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
    jne .L464
    mov rax, 2
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str466: db 119,111,114,100,0
section .text
    lea rax, [rel .str466]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    jmp .L465
.L464:
.L465:
    cmp rbx, 0
    jne .L467
    mov rax, 1
    mov r12, rax
    mov rax, r14
    push rax
section .data
.str469: db 98,121,116,101,0
section .text
    lea rax, [rel .str469]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_sizeword
    add rsp, 32
    mov rbx, rax
    jmp .L468
.L467:
.L468:
    cmp rbx, 0
    je .L470
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
    jmp .L471
.L470:
.L471:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 91
    je .L472
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
    je .L474
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
    jmp .__ret_456
    jmp .L475
.L474:
.L475:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L480
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
    jz .L480
    mov rax, 1
    jmp .L481
.L480:
    mov rax, 0
.L481:
    test rax, rax
    jz .L478
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
    jz .L478
    mov rax, 1
    jmp .L479
.L478:
    mov rax, 0
.L479:
    test rax, rax
    jz .L476
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
    jz .L486
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L486
    mov rax, 1
    jmp .L487
.L486:
    mov rax, 0
.L487:
    test rax, rax
    jz .L484
    mov rax, rbx
    mov rcx, 15
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L484
    mov rax, 1
    jmp .L485
.L484:
    mov rax, 0
.L485:
    test rax, rax
    jz .L482
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
    jmp .__ret_456
    jmp .L483
.L482:
.L483:
    jmp .L477
.L476:
.L477:
    mov rcx, r14
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_ok]
    cmp rax, 0
    je .L488
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
    jmp .__ret_456
    jmp .L489
.L488:
.L489:
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
    jmp .__ret_456
    jmp .L473
.L472:
.L473:
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
.L490:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L493
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 93
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L493
    mov rax, 1
    jmp .L494
.L493:
    mov rax, 0
.L494:
    test rax, rax
    jz .L491
    add rbx, 1
.L492:
    jmp .L490
.L491:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 93
    jne .L495
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
    jmp .L496
.L495:
.L496:
.L497:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L500
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
    jz .L500
    mov rax, 1
    jmp .L501
.L500:
    mov rax, 0
.L501:
    test rax, rax
    jz .L498
    sub rbx, 1
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call xl_p8
    add rsp, 32
.L499:
    jmp .L497
.L498:
    mov rax, r14
    push rax
section .data
.str504: db 114,101,108,32,0
section .text
    lea rax, [rel .str504]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L502
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
    jmp .__ret_456
    jmp .L503
.L502:
.L503:
    mov rax, r14
    mov [rbp-80], rax
    mov rax, 0
    mov r13, rax
    lea rax, [rel __g_xarm_xl_tb]
    mov r12, rax
.L505:
    mov rax, 1
    test rax, rax
    jz .L506
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
    jne .L508
    mov rax, 0
    jmp .__ret_456
    jmp .L509
.L508:
.L509:
    cmp rbx, 43
    jne .L510
    add r14, 1
    mov rax, 0
    mov r13, rax
    jmp .L511
.L510:
    cmp rbx, 45
    jne .L512
    add r14, 1
    mov rax, 1
    mov r13, rax
    jmp .L513
.L512:
    mov rax, 0
    mov [rbp-112], rax
.L514:
    mov rax, 1
    test rax, rax
    jz .L515
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
    jnz .L521
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L521
    mov rax, 0
    jmp .L522
.L521:
    mov rax, 1
.L522:
    test rax, rax
    jnz .L519
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L519
    mov rax, 0
    jmp .L520
.L519:
    mov rax, 1
.L520:
    test rax, rax
    jz .L517
    jmp .L515
    jmp .L518
.L517:
.L518:
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L525
    mov rax, [rbp-112]
    mov rcx, 30
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L525
    mov rax, 1
    jmp .L526
.L525:
    mov rax, 0
.L526:
    test rax, rax
    jz .L523
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
    jmp .L524
.L523:
.L524:
    add r14, 1
.L516:
    jmp .L514
.L515:
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
.L527:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L530
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 42
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L530
    mov rax, 1
    jmp .L531
.L530:
    mov rax, 0
.L531:
    test rax, rax
    jz .L528
    add rbx, 1
.L529:
    jmp .L527
.L528:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 42
    jne .L532
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
    jne .L534
section .data
.str536: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str536]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_456
    jmp .L535
.L534:
.L535:
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
    jne .L537
section .data
.str539: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str539]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_456
    jmp .L538
.L537:
.L538:
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
    jmp .L533
.L532:
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
    je .L540
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
    jne .L542
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
    jmp .L543
.L542:
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
.L543:
    mov rax, 0
    mov r13, rax
    jmp .L541
.L540:
    mov rcx, r12
    sub rsp, 32
    call xl_parse_num
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_ok]
    cmp rax, 0
    je .L544
    cmp r13, 0
    je .L546
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L547
.L546:
.L547:
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
    jmp .L545
.L544:
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
    je .L548
section .data
.str550: db 97,32,108,97,98,101,108,32,97,110,100,32,97,32,114,101,103,105,115,116,101,114,32,105,110,32,111,110,101,32,109,101,109,111,114,121,32,111,112,101,114,97,110,100,0
section .text
    lea rax, [rel .str550]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_456
    jmp .L549
.L548:
.L549:
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
    jmp .__ret_456
.L545:
.L541:
.L533:
.L513:
.L511:
.L507:
    jmp .L505
.L506:
    mov rax, 0
    jmp .__ret_456
.__ret_456:
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
.L552:
    mov rax, r15
    push rax
    mov rax, [rel __g_xarm_xl_rg_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L553
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
.L555:
    cmp r13, 1
    jne .L556
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
    jz .L560
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L560
    mov rax, 1
    jmp .L561
.L560:
    mov rax, 0
.L561:
    test rax, rax
    jz .L558
    add rbx, 32
    jmp .L559
.L558:
.L559:
    cmp r12, rbx
    je .L562
    mov rax, 0
    mov r13, rax
    jmp .L563
.L562:
    cmp r12, 0
    jne .L564
    mov rax, 2
    mov r13, rax
    jmp .L565
.L564:
    add r14, 1
.L565:
.L563:
.L557:
    jmp .L555
.L556:
    cmp r13, 2
    jne .L566
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
    jmp .__ret_551
    jmp .L567
.L566:
.L567:
    add r15, 1
.L554:
    jmp .L552
.L553:
    mov rax, 0
    mov [rel __g_xarm_xl_rsize], rax
    mov rax, 1
    neg rax
    jmp .__ret_551
.__ret_551:
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
    jne .L569
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
    jnz .L573
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
    jnz .L573
    mov rax, 0
    jmp .L574
.L573:
    mov rax, 1
.L574:
    test rax, rax
    jz .L571
    mov rax, 0
    jmp .__ret_568
    jmp .L572
.L571:
.L572:
    mov rax, 1
    mov [rel __g_xarm_xl_ok], rax
    mov rax, rbx
    jmp .__ret_568
    jmp .L570
.L569:
.L570:
    mov rax, 0
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 45
    jne .L575
    mov rax, 1
    mov r13, rax
    add r14, 1
    jmp .L576
.L575:
.L576:
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
    jnz .L579
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
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
    mov rax, 0
    jmp .__ret_568
    jmp .L578
.L577:
.L578:
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L583
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
    jnz .L585
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
    jnz .L585
    mov rax, 0
    jmp .L586
.L585:
    mov rax, 1
.L586:
    test rax, rax
    jz .L583
    mov rax, 1
    jmp .L584
.L583:
    mov rax, 0
.L584:
    test rax, rax
    jz .L581
    add r14, 2
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    jne .L587
    mov rax, 0
    jmp .__ret_568
    jmp .L588
.L587:
.L588:
.L589:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    je .L590
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov rbx, rax
    cmp r15, 48
    jge .L592
    mov rax, 0
    jmp .__ret_568
    jmp .L593
.L592:
.L593:
    cmp r15, 57
    jg .L594
    mov rax, r15
    sub rax, 48
    mov rbx, rax
    jmp .L595
.L594:
    or r15, 32
    mov rax, r15
    mov rcx, 97
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L598
    mov rax, r15
    mov rcx, 102
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L598
    mov rax, 0
    jmp .L599
.L598:
    mov rax, 1
.L599:
    test rax, rax
    jz .L596
    mov rax, 0
    jmp .__ret_568
    jmp .L597
.L596:
.L597:
    mov rax, r15
    sub rax, 87
    mov rbx, rax
.L595:
    mov rax, r12
    shl rax, 4
    add rax, rbx
    mov r12, rax
    add r14, 1
.L591:
    jmp .L589
.L590:
    jmp .L582
.L581:
.L600:
    mov rcx, r14
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 0
    je .L601
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
    jnz .L605
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L605
    mov rax, 0
    jmp .L606
.L605:
    mov rax, 1
.L606:
    test rax, rax
    jz .L603
    mov rax, 0
    jmp .__ret_568
    jmp .L604
.L603:
.L604:
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
.L602:
    jmp .L600
.L601:
.L582:
    cmp r13, 0
    je .L607
    mov rax, 0
    sub rax, r12
    mov r12, rax
    jmp .L608
.L607:
.L608:
    mov rax, 1
    mov [rel __g_xarm_xl_ok], rax
    mov rax, r12
    jmp .__ret_568
.__ret_568:
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
    jmp .__ret_609
.__ret_609:
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
    jmp .__ret_610
.__ret_610:
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
    jmp .__ret_611
.__ret_611:
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
    jmp .__ret_612
.__ret_612:
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
    jmp .__ret_613
.__ret_613:
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
    jmp .__ret_614
.__ret_614:
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
    jne .L616
    mov rax, 120
    jmp .__ret_615
    jmp .L617
.L616:
.L617:
    mov rax, 119
    jmp .__ret_615
.__ret_615:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
xl_bad:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str619: db 110,111,32,65,82,77,54,52,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str619]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_618
.__ret_618:
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
.str621: db 32,32,32,32,109,111,118,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str621]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_620
.__ret_620:
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
    je .L623
section .data
.str625: db 32,32,32,32,97,100,114,108,32,120,49,54,44,32,37,115,10,0
section .text
    lea rax, [rel .str625]
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
    jmp .__ret_622
    jmp .L624
.L623:
.L624:
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
    je .L626
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
    jne .L628
    mov rax, 1
    mov r12, rax
    jmp .L629
.L628:
    cmp rbx, 4
    jne .L630
    mov rax, 2
    mov r12, rax
    jmp .L631
.L630:
    cmp rbx, 8
    jne .L632
    mov rax, 3
    mov r12, rax
    jmp .L633
.L632:
.L633:
.L631:
.L629:
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
    jne .L634
section .data
.str636: db 32,32,32,32,108,115,108,32,120,49,54,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str636]
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
    jmp .__ret_622
    jmp .L635
.L634:
.L635:
section .data
.str637: db 32,32,32,32,97,100,100,32,120,49,54,44,32,37,120,44,32,37,120,44,32,108,115,108,32,35,37,100,10,0
section .text
    lea rax, [rel .str637]
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
    jmp .__ret_622
    jmp .L627
.L626:
.L627:
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
    je .L638
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
    jmp .__ret_622
    jmp .L639
.L638:
.L639:
section .data
.str640: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str640]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 16
    mov [rel __g_xarm_xl_mb], rax
    mov rax, 0
    jmp .__ret_622
.__ret_622:
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
.str642: db 0
section .text
    lea rax, [rel .str642]
    mov r12, rax
    cmp r15, 1
    jne .L643
section .data
.str645: db 98,0
section .text
    lea rax, [rel .str645]
    mov r12, rax
    jmp .L644
.L643:
    cmp r15, 2
    jne .L646
section .data
.str648: db 104,0
section .text
    lea rax, [rel .str648]
    mov r12, rax
    jmp .L647
.L646:
.L647:
.L644:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_mo]
    cmp rax, 0
    jne .L649
    mov rax, 1
    mov rbx, rax
    jmp .L650
.L649:
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L655
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
    jz .L655
    mov rax, 1
    jmp .L656
.L655:
    mov rax, 0
.L656:
    test rax, rax
    jz .L653
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, r15
    cqo
    idiv rcx
    mov rcx, 4095
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L653
    mov rax, 1
    jmp .L654
.L653:
    mov rax, 0
.L654:
    test rax, rax
    jz .L651
section .data
.str657: db 108,100,114,0
section .text
    lea rax, [rel .str657]
    mov rbx, rax
    cmp r14, 0
    je .L658
section .data
.str660: db 115,116,114,0
section .text
    lea rax, [rel .str660]
    mov rbx, rax
    jmp .L659
.L658:
.L659:
section .data
.str661: db 32,32,32,32,37,115,37,115,32,37,115,44,32,91,37,120,44,32,35,37,100,93,10,0
section .text
    lea rax, [rel .str661]
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
    jmp .__ret_641
    jmp .L652
.L651:
.L652:
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
    jz .L664
    mov rax, [rel __g_xarm_xl_mo]
    mov rcx, 255
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L664
    mov rax, 1
    jmp .L665
.L664:
    mov rax, 0
.L665:
    test rax, rax
    jz .L662
section .data
.str666: db 108,100,117,114,0
section .text
    lea rax, [rel .str666]
    mov rbx, rax
    cmp r14, 0
    je .L667
section .data
.str669: db 115,116,117,114,0
section .text
    lea rax, [rel .str669]
    mov rbx, rax
    jmp .L668
.L667:
.L668:
section .data
.str670: db 32,32,32,32,37,115,37,115,32,37,115,44,32,91,37,120,44,32,35,37,100,93,10,0
section .text
    lea rax, [rel .str670]
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
    jmp .__ret_641
    jmp .L663
.L662:
.L663:
    mov rax, 16
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_mb]
    cmp rax, 16
    jne .L671
    mov rax, 17
    mov rbx, rax
    jmp .L672
.L671:
.L672:
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
.str673: db 32,32,32,32,97,100,100,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str673]
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
.L650:
section .data
.str674: db 108,100,114,0
section .text
    lea rax, [rel .str674]
    mov rbx, rax
    cmp r14, 0
    je .L675
section .data
.str677: db 115,116,114,0
section .text
    lea rax, [rel .str677]
    mov rbx, rax
    jmp .L676
.L675:
.L676:
section .data
.str678: db 32,32,32,32,37,115,37,115,32,37,115,44,32,91,37,120,93,10,0
section .text
    lea rax, [rel .str678]
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
    jmp .__ret_641
.__ret_641:
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
    jmp .__ret_679
.__ret_679:
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
    jz .L683
    mov rcx, r12
    sub rsp, 32
    call xl_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L683
    mov rax, 1
    jmp .L684
.L683:
    mov rax, 0
.L684:
    test rax, rax
    jz .L681
    cmp r15, r14
    je .L685
section .data
.str687: db 32,32,32,32,109,111,118,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str687]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r14
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L686
.L685:
.L686:
    mov rax, 0
    jmp .__ret_680
    jmp .L682
.L681:
.L682:
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L690
    mov rax, r13
    mov rcx, 4096
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L690
    mov rax, 1
    jmp .L691
.L690:
    mov rax, 0
.L691:
    test rax, rax
    jz .L688
section .data
.str692: db 32,32,32,32,97,100,100,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str692]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r15
    mov r9, r14
    mov r10, r13
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_680
    jmp .L689
.L688:
.L689:
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L695
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
    jz .L695
    mov rax, 1
    jmp .L696
.L695:
    mov rax, 0
.L696:
    test rax, rax
    jz .L693
section .data
.str697: db 32,32,32,32,115,117,98,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str697]
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
    jmp .__ret_680
    jmp .L694
.L693:
.L694:
    mov rax, 16
    mov rbx, rax
    cmp r14, 16
    jne .L698
    mov rax, 17
    mov rbx, rax
    jmp .L699
.L698:
.L699:
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str700: db 32,32,32,32,97,100,100,37,115,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str700]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r15
    mov r9, r14
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_680
.__ret_680:
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
    je .L702
    mov rax, 65535
    mov r12, rax
    mov rax, 65536
    neg rax
    mov rbx, rax
    jmp .L703
.L702:
.L703:
section .data
.str704: db 32,32,32,32,97,110,100,32,120,49,55,44,32,37,120,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str704]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
section .data
.str705: db 32,32,32,32,97,110,100,32,37,120,44,32,37,120,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str705]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r13
    mov r9, rbx
    sub rsp, 32
    call xl_f3
    add rsp, 32
section .data
.str706: db 32,32,32,32,111,114,114,32,37,120,44,32,37,120,44,32,120,49,55,10,0
section .text
    lea rax, [rel .str706]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r13
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_701
.__ret_701:
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
    jne .L708
    mov rax, 119
    mov rbx, rax
    cmp r14, 4
    jle .L710
    mov rax, 120
    mov rbx, rax
    jmp .L711
.L710:
.L711:
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
    jmp .__ret_707
    jmp .L709
.L708:
.L709:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L712
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
    jle .L714
section .data
.str716: db 120,49,54,0
section .text
    lea rax, [rel .str716]
    jmp .__ret_707
    jmp .L715
.L714:
.L715:
section .data
.str717: db 119,49,54,0
section .text
    lea rax, [rel .str717]
    jmp .__ret_707
    jmp .L713
.L712:
.L713:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L718
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
    jne .L720
    mov rax, r14
    mov r12, rax
    jmp .L721
.L720:
.L721:
section .data
.str722: db 119,49,54,0
section .text
    lea rax, [rel .str722]
    mov rbx, rax
    cmp r12, 4
    jle .L723
section .data
.str725: db 120,49,54,0
section .text
    lea rax, [rel .str725]
    mov rbx, rax
    jmp .L724
.L723:
.L724:
    mov rcx, r13
    mov rdx, 0
    mov r8, r12
    mov r9, rbx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rax, rbx
    jmp .__ret_707
    jmp .L719
.L718:
.L719:
section .data
.str726: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str726]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
section .data
.str727: db 120,49,54,0
section .text
    lea rax, [rel .str727]
    jmp .__ret_707
.__ret_707:
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
    je .L729
    mov rax, 4294967295
    mov rbx, rax
    jmp .L730
.L729:
.L730:
    mov rax, r13
    and rax, rbx
    mov r13, rax
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L733
    mov rax, r13
    mov rcx, rbx
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L733
    mov rax, 0
    jmp .L734
.L733:
    mov rax, 1
.L734:
    test rax, rax
    jz .L731
    mov rax, 0
    jmp .__ret_728
    jmp .L732
.L731:
.L732:
    mov rax, r12
    mov r15, rax
.L735:
    cmp r15, 2
    jle .L736
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
    je .L738
    jmp .L736
    jmp .L739
.L738:
.L739:
    mov rax, r12
    mov r15, rax
.L737:
    jmp .L735
.L736:
    mov rax, 1
    neg rax
    mov r14, rax
    cmp r15, 64
    je .L740
    mov rax, 1
    mov rcx, r15
    shl rax, cl
    sub rax, 1
    mov r14, rax
    jmp .L741
.L740:
.L741:
    mov rax, r13
    and rax, r14
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L742:
    cmp r12, r15
    jge .L743
    mov rax, r13
    mov rcx, r12
    shr rax, cl
    mov [rbp-88], rax
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    sub rax, r12
    cmp rax, 64
    jge .L745
    mov rax, r15
    sub rax, r12
    mov rcx, rax
    mov rax, r13
    shl rax, cl
    mov rbx, rax
    jmp .L746
.L745:
.L746:
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
    jz .L749
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
    jz .L749
    mov rax, 1
    jmp .L750
.L749:
    mov rax, 0
.L750:
    test rax, rax
    jz .L747
    mov rax, 1
    jmp .__ret_728
    jmp .L748
.L747:
.L748:
    add r12, 1
.L744:
    jmp .L742
.L743:
    mov rax, 0
    jmp .__ret_728
.__ret_728:
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
    jne .L752
section .data
.str754: db 99,111,110,100,105,116,105,111,110,32,119,105,116,104,32,110,111,116,104,105,110,103,32,115,101,116,116,105,110,103,32,116,104,101,32,102,108,97,103,115,32,98,101,102,111,114,101,32,105,116,0
section .text
    lea rax, [rel .str754]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_751
    jmp .L753
.L752:
.L753:
    mov rax, [rel __g_xarm_xl_fpend]
    cmp rax, 0
    je .L755
    mov rax, [rel __g_xarm_xl_fpend]
    sub rax, 1
    mov rbx, rax
    mov rax, [rel __g_xarm_xl_fpw]
    cmp rax, 0
    jne .L757
section .data
.str759: db 32,32,32,32,116,115,116,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str759]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L758
.L757:
section .data
.str760: db 32,32,32,32,116,115,116,32,37,119,44,32,37,119,10,0
section .text
    lea rax, [rel .str760]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
.L758:
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    jmp .L756
.L755:
.L756:
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
    jne .L761
    mov rax, [rel __g_xarm_xl_cc_sub]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_sub_end]
    mov rbx, rax
    jmp .L762
.L761:
    mov rax, [rel __g_xarm_xl_fk]
    push rax
    mov rax, [rel __g_xarm_F_LOGIC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L763
    mov rax, [rel __g_xarm_xl_cc_logic]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_logic_end]
    mov rbx, rax
    jmp .L764
.L763:
    mov rax, [rel __g_xarm_xl_fk]
    push rax
    mov rax, [rel __g_xarm_F_ADD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L765
    mov rax, [rel __g_xarm_xl_cc_add]
    mov r12, rax
    mov rax, [rel __g_xarm_xl_cc_add_end]
    mov rbx, rax
    jmp .L766
.L765:
.L766:
.L764:
.L762:
.L767:
    cmp r12, rbx
    jge .L768
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
    je .L770
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
    jmp .__ret_751
    jmp .L771
.L770:
.L771:
    add r12, 1
.L769:
    jmp .L767
.L768:
section .data
.str772: db 99,111,110,100,105,116,105,111,110,32,116,104,101,115,101,32,102,108,97,103,115,32,99,97,110,110,111,116,32,97,110,115,119,101,114,32,111,110,32,65,82,77,54,52,0
section .text
    lea rax, [rel .str772]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_751
.__ret_751:
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
.str776: db 109,111,118,0
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
    call xl_i_mov
    add rsp, 32
    jmp .__ret_773
    jmp .L775
.L774:
.L775:
    mov rax, rbx
    push rax
section .data
.str779: db 109,111,118,122,120,0
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
    call xl_i_movzx
    add rsp, 32
    jmp .__ret_773
    jmp .L778
.L777:
.L778:
    mov rax, rbx
    push rax
section .data
.str782: db 108,101,97,0
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
    call xl_i_lea
    add rsp, 32
    jmp .__ret_773
    jmp .L781
.L780:
.L781:
    mov rax, rbx
    push rax
section .data
.str785: db 112,117,115,104,0
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
    sub rsp, 32
    call xl_i_push
    add rsp, 32
    jmp .__ret_773
    jmp .L784
.L783:
.L784:
    mov rax, rbx
    push rax
section .data
.str788: db 112,111,112,0
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
    sub rsp, 32
    call xl_i_pop
    add rsp, 32
    jmp .__ret_773
    jmp .L787
.L786:
.L787:
    mov rax, rbx
    push rax
section .data
.str791: db 97,100,100,0
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
    mov rcx, 0
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_773
    jmp .L790
.L789:
.L790:
    mov rax, rbx
    push rax
section .data
.str794: db 115,117,98,0
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
    mov rcx, 1
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_773
    jmp .L793
.L792:
.L793:
    mov rax, rbx
    push rax
section .data
.str797: db 97,110,100,0
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
    mov rcx, 2
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_773
    jmp .L796
.L795:
.L796:
    mov rax, rbx
    push rax
section .data
.str800: db 111,114,0
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
    mov rcx, 3
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_773
    jmp .L799
.L798:
.L799:
    mov rax, rbx
    push rax
section .data
.str803: db 120,111,114,0
section .text
    lea rax, [rel .str803]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L801
    mov rcx, 4
    sub rsp, 32
    call xl_arith
    add rsp, 32
    jmp .__ret_773
    jmp .L802
.L801:
.L802:
    mov rax, rbx
    push rax
section .data
.str806: db 105,110,99,0
section .text
    lea rax, [rel .str806]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L804
section .data
.str807: db 97,100,100,115,0
section .text
    lea rax, [rel .str807]
    push rax
    mov rax, [rel __g_xarm_F_ADD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_incdec
    add rsp, 32
    jmp .__ret_773
    jmp .L805
.L804:
.L805:
    mov rax, rbx
    push rax
section .data
.str810: db 100,101,99,0
section .text
    lea rax, [rel .str810]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L808
section .data
.str811: db 115,117,98,115,0
section .text
    lea rax, [rel .str811]
    push rax
    mov rax, [rel __g_xarm_F_SUB]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_incdec
    add rsp, 32
    jmp .__ret_773
    jmp .L809
.L808:
.L809:
    mov rax, rbx
    push rax
section .data
.str814: db 110,101,103,0
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
    call xl_i_neg
    add rsp, 32
    jmp .__ret_773
    jmp .L813
.L812:
.L813:
    mov rax, rbx
    push rax
section .data
.str817: db 110,111,116,0
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
    call xl_i_not
    add rsp, 32
    jmp .__ret_773
    jmp .L816
.L815:
.L816:
    mov rax, rbx
    push rax
section .data
.str820: db 99,109,112,0
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
    call xl_i_cmp
    add rsp, 32
    jmp .__ret_773
    jmp .L819
.L818:
.L819:
    mov rax, rbx
    push rax
section .data
.str823: db 116,101,115,116,0
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
    sub rsp, 32
    call xl_i_test
    add rsp, 32
    jmp .__ret_773
    jmp .L822
.L821:
.L822:
    mov rax, rbx
    push rax
section .data
.str826: db 105,109,117,108,0
section .text
    lea rax, [rel .str826]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L824
    sub rsp, 32
    call xl_i_imul
    add rsp, 32
    jmp .__ret_773
    jmp .L825
.L824:
.L825:
    mov rax, rbx
    push rax
section .data
.str829: db 99,113,111,0
section .text
    lea rax, [rel .str829]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L827
section .data
.str830: db 32,32,32,32,97,115,114,32,120,50,44,32,120,48,44,32,35,54,51,10,0
section .text
    lea rax, [rel .str830]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_773
    jmp .L828
.L827:
.L828:
    mov rax, rbx
    push rax
section .data
.str833: db 105,100,105,118,0
section .text
    lea rax, [rel .str833]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L831
section .data
.str834: db 115,100,105,118,0
section .text
    lea rax, [rel .str834]
    push rax
    pop rcx
    sub rsp, 32
    call xl_divide
    add rsp, 32
    jmp .__ret_773
    jmp .L832
.L831:
.L832:
    mov rax, rbx
    push rax
section .data
.str837: db 100,105,118,0
section .text
    lea rax, [rel .str837]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L835
section .data
.str838: db 117,100,105,118,0
section .text
    lea rax, [rel .str838]
    push rax
    pop rcx
    sub rsp, 32
    call xl_divide
    add rsp, 32
    jmp .__ret_773
    jmp .L836
.L835:
.L836:
    mov rax, rbx
    push rax
section .data
.str841: db 115,104,108,0
section .text
    lea rax, [rel .str841]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L839
section .data
.str842: db 108,115,108,0
section .text
    lea rax, [rel .str842]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_773
    jmp .L840
.L839:
.L840:
    mov rax, rbx
    push rax
section .data
.str845: db 115,97,108,0
section .text
    lea rax, [rel .str845]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L843
section .data
.str846: db 108,115,108,0
section .text
    lea rax, [rel .str846]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_773
    jmp .L844
.L843:
.L844:
    mov rax, rbx
    push rax
section .data
.str849: db 115,104,114,0
section .text
    lea rax, [rel .str849]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L847
section .data
.str850: db 108,115,114,0
section .text
    lea rax, [rel .str850]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_773
    jmp .L848
.L847:
.L848:
    mov rax, rbx
    push rax
section .data
.str853: db 115,97,114,0
section .text
    lea rax, [rel .str853]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L851
section .data
.str854: db 97,115,114,0
section .text
    lea rax, [rel .str854]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_773
    jmp .L852
.L851:
.L852:
    mov rax, rbx
    push rax
section .data
.str857: db 114,111,108,0
section .text
    lea rax, [rel .str857]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L855
section .data
.str858: db 114,111,114,0
section .text
    lea rax, [rel .str858]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_773
    jmp .L856
.L855:
.L856:
    mov rax, rbx
    push rax
section .data
.str861: db 114,111,114,0
section .text
    lea rax, [rel .str861]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L859
section .data
.str862: db 114,111,114,0
section .text
    lea rax, [rel .str862]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_shift
    add rsp, 32
    jmp .__ret_773
    jmp .L860
.L859:
.L860:
    mov rax, rbx
    push rax
section .data
.str865: db 120,99,104,103,0
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
    call xl_i_xchg
    add rsp, 32
    jmp .__ret_773
    jmp .L864
.L863:
.L864:
    mov rax, rbx
    push rax
section .data
.str868: db 106,109,112,0
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
    sub rsp, 32
    call xl_i_jmp
    add rsp, 32
    jmp .__ret_773
    jmp .L867
.L866:
.L867:
    mov rax, rbx
    push rax
section .data
.str871: db 99,97,108,108,0
section .text
    lea rax, [rel .str871]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L869
    sub rsp, 32
    call xl_i_call
    add rsp, 32
    jmp .__ret_773
    jmp .L870
.L869:
.L870:
    mov rax, rbx
    push rax
section .data
.str874: db 114,101,116,0
section .text
    lea rax, [rel .str874]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L872
section .data
.str875: db 32,32,32,32,114,101,116,10,0
section .text
    lea rax, [rel .str875]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_773
    jmp .L873
.L872:
.L873:
    mov rax, rbx
    push rax
section .data
.str878: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str878]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L876
section .data
.str879: db 32,32,32,32,109,111,118,32,120,49,55,44,32,120,51,48,10,32,32,32,32,98,108,32,95,95,115,121,115,120,10,32,32,32,32,109,111,118,32,120,51,48,44,32,120,49,55,10,0
section .text
    lea rax, [rel .str879]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_773
    jmp .L877
.L876:
.L877:
    mov rax, rbx
    push rax
section .data
.str882: db 109,111,118,115,100,0
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
    sub rsp, 32
    call xl_i_movsd
    add rsp, 32
    jmp .__ret_773
    jmp .L881
.L880:
.L881:
    mov rax, rbx
    push rax
section .data
.str885: db 109,111,118,115,115,0
section .text
    lea rax, [rel .str885]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L883
    sub rsp, 32
    call xl_i_movss
    add rsp, 32
    jmp .__ret_773
    jmp .L884
.L883:
.L884:
    mov rax, rbx
    push rax
section .data
.str888: db 99,118,116,115,115,50,115,100,0
section .text
    lea rax, [rel .str888]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L886
section .data
.str889: db 32,32,32,32,102,99,118,116,32,37,68,44,32,115,37,100,10,0
section .text
    lea rax, [rel .str889]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fcvt_sd
    add rsp, 32
    jmp .__ret_773
    jmp .L887
.L886:
.L887:
    mov rax, rbx
    push rax
section .data
.str892: db 99,118,116,115,100,50,115,115,0
section .text
    lea rax, [rel .str892]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L890
section .data
.str893: db 32,32,32,32,102,99,118,116,32,115,37,100,44,32,37,68,10,0
section .text
    lea rax, [rel .str893]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fcvt_sd
    add rsp, 32
    jmp .__ret_773
    jmp .L891
.L890:
.L891:
    mov rax, rbx
    push rax
section .data
.str896: db 109,111,118,113,0
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
    call xl_i_movsd
    add rsp, 32
    jmp .__ret_773
    jmp .L895
.L894:
.L895:
    mov rax, rbx
    push rax
section .data
.str899: db 109,111,118,117,112,115,0
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
    jmp .__ret_773
    jmp .L898
.L897:
.L898:
    mov rax, rbx
    push rax
section .data
.str902: db 109,111,118,117,112,100,0
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
    jmp .__ret_773
    jmp .L901
.L900:
.L901:
    mov rax, rbx
    push rax
section .data
.str905: db 109,111,118,97,112,115,0
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
    sub rsp, 32
    call xl_i_movups
    add rsp, 32
    jmp .__ret_773
    jmp .L904
.L903:
.L904:
    mov rax, rbx
    push rax
section .data
.str908: db 109,111,118,97,112,100,0
section .text
    lea rax, [rel .str908]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L906
    sub rsp, 32
    call xl_i_movups
    add rsp, 32
    jmp .__ret_773
    jmp .L907
.L906:
.L907:
    mov rax, rbx
    push rax
section .data
.str911: db 97,100,100,115,100,0
section .text
    lea rax, [rel .str911]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L909
section .data
.str912: db 102,97,100,100,0
section .text
    lea rax, [rel .str912]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_773
    jmp .L910
.L909:
.L910:
    mov rax, rbx
    push rax
section .data
.str915: db 115,117,98,115,100,0
section .text
    lea rax, [rel .str915]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L913
section .data
.str916: db 102,115,117,98,0
section .text
    lea rax, [rel .str916]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_773
    jmp .L914
.L913:
.L914:
    mov rax, rbx
    push rax
section .data
.str919: db 109,117,108,115,100,0
section .text
    lea rax, [rel .str919]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L917
section .data
.str920: db 102,109,117,108,0
section .text
    lea rax, [rel .str920]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_773
    jmp .L918
.L917:
.L918:
    mov rax, rbx
    push rax
section .data
.str923: db 100,105,118,115,100,0
section .text
    lea rax, [rel .str923]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L921
section .data
.str924: db 102,100,105,118,0
section .text
    lea rax, [rel .str924]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_773
    jmp .L922
.L921:
.L922:
    mov rax, rbx
    push rax
section .data
.str927: db 115,113,114,116,115,100,0
section .text
    lea rax, [rel .str927]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L925
section .data
.str928: db 102,115,113,114,116,0
section .text
    lea rax, [rel .str928]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call xl_fscalar
    add rsp, 32
    jmp .__ret_773
    jmp .L926
.L925:
.L926:
    mov rax, rbx
    push rax
section .data
.str931: db 97,100,100,112,100,0
section .text
    lea rax, [rel .str931]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L929
section .data
.str932: db 102,97,100,100,0
section .text
    lea rax, [rel .str932]
    push rax
section .data
.str933: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str933]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L930
.L929:
.L930:
    mov rax, rbx
    push rax
section .data
.str936: db 115,117,98,112,100,0
section .text
    lea rax, [rel .str936]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L934
section .data
.str937: db 102,115,117,98,0
section .text
    lea rax, [rel .str937]
    push rax
section .data
.str938: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str938]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L935
.L934:
.L935:
    mov rax, rbx
    push rax
section .data
.str941: db 109,117,108,112,100,0
section .text
    lea rax, [rel .str941]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L939
section .data
.str942: db 102,109,117,108,0
section .text
    lea rax, [rel .str942]
    push rax
section .data
.str943: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str943]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L940
.L939:
.L940:
    mov rax, rbx
    push rax
section .data
.str946: db 100,105,118,112,100,0
section .text
    lea rax, [rel .str946]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L944
section .data
.str947: db 102,100,105,118,0
section .text
    lea rax, [rel .str947]
    push rax
section .data
.str948: db 32,32,32,32,37,115,32,37,86,46,50,100,44,32,37,86,46,50,100,44,32,37,86,46,50,100,10,0
section .text
    lea rax, [rel .str948]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L945
.L944:
.L945:
    mov rax, rbx
    push rax
section .data
.str951: db 97,100,100,112,115,0
section .text
    lea rax, [rel .str951]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L949
section .data
.str952: db 102,97,100,100,0
section .text
    lea rax, [rel .str952]
    push rax
section .data
.str953: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str953]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L950
.L949:
.L950:
    mov rax, rbx
    push rax
section .data
.str956: db 115,117,98,112,115,0
section .text
    lea rax, [rel .str956]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L954
section .data
.str957: db 102,115,117,98,0
section .text
    lea rax, [rel .str957]
    push rax
section .data
.str958: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str958]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L955
.L954:
.L955:
    mov rax, rbx
    push rax
section .data
.str961: db 109,117,108,112,115,0
section .text
    lea rax, [rel .str961]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L959
section .data
.str962: db 102,109,117,108,0
section .text
    lea rax, [rel .str962]
    push rax
section .data
.str963: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str963]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L960
.L959:
.L960:
    mov rax, rbx
    push rax
section .data
.str966: db 100,105,118,112,115,0
section .text
    lea rax, [rel .str966]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L964
section .data
.str967: db 102,100,105,118,0
section .text
    lea rax, [rel .str967]
    push rax
section .data
.str968: db 32,32,32,32,37,115,32,37,86,46,52,115,44,32,37,86,46,52,115,44,32,37,86,46,52,115,10,0
section .text
    lea rax, [rel .str968]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L965
.L964:
.L965:
    mov rax, rbx
    push rax
section .data
.str971: db 120,111,114,112,115,0
section .text
    lea rax, [rel .str971]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L969
section .data
.str972: db 101,111,114,0
section .text
    lea rax, [rel .str972]
    push rax
section .data
.str973: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str973]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L970
.L969:
.L970:
    mov rax, rbx
    push rax
section .data
.str976: db 120,111,114,112,100,0
section .text
    lea rax, [rel .str976]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L974
section .data
.str977: db 101,111,114,0
section .text
    lea rax, [rel .str977]
    push rax
section .data
.str978: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str978]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L975
.L974:
.L975:
    mov rax, rbx
    push rax
section .data
.str981: db 97,110,100,112,115,0
section .text
    lea rax, [rel .str981]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L979
section .data
.str982: db 97,110,100,0
section .text
    lea rax, [rel .str982]
    push rax
section .data
.str983: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str983]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L980
.L979:
.L980:
    mov rax, rbx
    push rax
section .data
.str986: db 97,110,100,112,100,0
section .text
    lea rax, [rel .str986]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L984
section .data
.str987: db 97,110,100,0
section .text
    lea rax, [rel .str987]
    push rax
section .data
.str988: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str988]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L985
.L984:
.L985:
    mov rax, rbx
    push rax
section .data
.str991: db 111,114,112,100,0
section .text
    lea rax, [rel .str991]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L989
section .data
.str992: db 111,114,114,0
section .text
    lea rax, [rel .str992]
    push rax
section .data
.str993: db 32,32,32,32,37,115,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str993]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_fpacked
    add rsp, 32
    jmp .__ret_773
    jmp .L990
.L989:
.L990:
    mov rax, rbx
    push rax
section .data
.str996: db 117,99,111,109,105,115,100,0
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
    call xl_i_ucomisd
    add rsp, 32
    jmp .__ret_773
    jmp .L995
.L994:
.L995:
    mov rax, rbx
    push rax
section .data
.str999: db 99,111,109,105,115,100,0
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
    sub rsp, 32
    call xl_i_ucomisd
    add rsp, 32
    jmp .__ret_773
    jmp .L998
.L997:
.L998:
    mov rax, rbx
    push rax
section .data
.str1002: db 99,118,116,115,105,50,115,100,0
section .text
    lea rax, [rel .str1002]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1000
    sub rsp, 32
    call xl_i_cvtsi2sd
    add rsp, 32
    jmp .__ret_773
    jmp .L1001
.L1000:
.L1001:
    mov rax, rbx
    push rax
section .data
.str1005: db 99,118,116,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str1005]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1003
section .data
.str1006: db 102,99,118,116,122,115,0
section .text
    lea rax, [rel .str1006]
    push rax
    pop rcx
    sub rsp, 32
    call xl_tofix
    add rsp, 32
    jmp .__ret_773
    jmp .L1004
.L1003:
.L1004:
    mov rax, rbx
    push rax
section .data
.str1009: db 99,118,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str1009]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1007
section .data
.str1010: db 102,99,118,116,110,115,0
section .text
    lea rax, [rel .str1010]
    push rax
    pop rcx
    sub rsp, 32
    call xl_tofix
    add rsp, 32
    jmp .__ret_773
    jmp .L1008
.L1007:
.L1008:
    mov rax, rbx
    push rax
section .data
.str1013: db 112,114,101,102,101,116,99,104,116,48,0
section .text
    lea rax, [rel .str1013]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1011
section .data
.str1014: db 32,32,32,32,112,114,102,109,32,112,108,100,108,49,107,101,101,112,44,32,91,37,120,93,10,0
section .text
    lea rax, [rel .str1014]
    push rax
    pop rcx
    sub rsp, 32
    call xl_cacheop
    add rsp, 32
    jmp .__ret_773
    jmp .L1012
.L1011:
.L1012:
    mov rax, rbx
    push rax
section .data
.str1017: db 99,108,102,108,117,115,104,0
section .text
    lea rax, [rel .str1017]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1015
section .data
.str1018: db 32,32,32,32,100,99,32,99,105,118,97,99,44,32,37,120,10,0
section .text
    lea rax, [rel .str1018]
    push rax
    pop rcx
    sub rsp, 32
    call xl_cacheop
    add rsp, 32
    jmp .__ret_773
    jmp .L1016
.L1015:
.L1016:
    mov rax, rbx
    push rax
section .data
.str1021: db 110,111,112,0
section .text
    lea rax, [rel .str1021]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1019
section .data
.str1022: db 32,32,32,32,110,111,112,10,0
section .text
    lea rax, [rel .str1022]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_773
    jmp .L1020
.L1019:
.L1020:
    mov rax, rbx
    push rax
section .data
.str1025: db 112,97,117,115,101,0
section .text
    lea rax, [rel .str1025]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1023
section .data
.str1026: db 32,32,32,32,110,111,112,10,0
section .text
    lea rax, [rel .str1026]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_773
    jmp .L1024
.L1023:
.L1024:
    mov rax, rbx
    push rax
section .data
.str1029: db 109,102,101,110,99,101,0
section .text
    lea rax, [rel .str1029]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_streq
    add rsp, 32
    cmp rax, 0
    je .L1027
section .data
.str1030: db 32,32,32,32,100,109,98,32,105,115,104,10,0
section .text
    lea rax, [rel .str1030]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_773
    jmp .L1028
.L1027:
.L1028:
    mov rcx, rbx
    sub rsp, 32
    call xl_g8
    add rsp, 32
    cmp rax, 106
    jne .L1031
    sub rsp, 32
    call xl_i_jcc
    add rsp, 32
    jmp .__ret_773
    jmp .L1032
.L1031:
.L1032:
    mov rax, rbx
    push rax
section .data
.str1035: db 115,101,116,0
section .text
    lea rax, [rel .str1035]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_prefix
    add rsp, 32
    cmp rax, 0
    je .L1033
    sub rsp, 32
    call xl_i_setcc
    add rsp, 32
    jmp .__ret_773
    jmp .L1034
.L1033:
.L1034:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_773
.__ret_773:
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
    jne .L1037
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
    jne .L1039
    mov rcx, r15
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
    cmp r13, 8
    jne .L1041
    cmp r12, rbx
    je .L1043
section .data
.str1045: db 32,32,32,32,109,111,118,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1045]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1044
.L1043:
.L1044:
    mov rax, 0
    jmp .__ret_1036
    jmp .L1042
.L1041:
.L1042:
    cmp r13, 4
    jne .L1046
section .data
.str1048: db 32,32,32,32,109,111,118,32,37,119,44,32,37,119,10,0
section .text
    lea rax, [rel .str1048]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1036
    jmp .L1047
.L1046:
.L1047:
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
    jmp .__ret_1036
    jmp .L1040
.L1039:
.L1040:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1049
    cmp r13, 8
    jne .L1051
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
    jmp .__ret_1036
    jmp .L1052
.L1051:
.L1052:
    cmp r13, 4
    jne .L1053
section .data
.str1055: db 32,32,32,32,109,111,118,32,37,119,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1055]
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
    jmp .__ret_1036
    jmp .L1054
.L1053:
.L1054:
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
    jmp .__ret_1036
    jmp .L1050
.L1049:
.L1050:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1056
    cmp r13, 4
    jge .L1058
    mov rax, r15
    push rax
    mov rax, 0
    push rax
    mov rax, r13
    push rax
section .data
.str1060: db 119,49,54,0
section .text
    lea rax, [rel .str1060]
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
    jmp .__ret_1036
    jmp .L1059
.L1058:
.L1059:
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
    jmp .__ret_1036
    jmp .L1057
.L1056:
.L1057:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1036
    jmp .L1038
.L1037:
.L1038:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1061
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1036
    jmp .L1062
.L1061:
.L1062:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1063
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
    jmp .__ret_1036
    jmp .L1064
.L1063:
.L1064:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1065
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
    jne .L1067
    mov rax, 8
    mov r13, rax
    jmp .L1068
.L1067:
.L1068:
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L1069
section .data
.str1071: db 119,122,114,0
section .text
    lea rax, [rel .str1071]
    mov rbx, rax
    cmp r13, 4
    jle .L1072
section .data
.str1074: db 120,122,114,0
section .text
    lea rax, [rel .str1074]
    mov rbx, rax
    jmp .L1073
.L1072:
.L1073:
    jmp .L1070
.L1069:
    mov rcx, 17
    mov rdx, r12
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
section .data
.str1075: db 119,49,55,0
section .text
    lea rax, [rel .str1075]
    mov rbx, rax
    cmp r13, 4
    jle .L1076
section .data
.str1078: db 120,49,55,0
section .text
    lea rax, [rel .str1078]
    mov rbx, rax
    jmp .L1077
.L1076:
.L1077:
.L1070:
    mov rcx, r14
    mov rdx, 1
    mov r8, r13
    mov r9, rbx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .__ret_1036
    jmp .L1066
.L1065:
.L1066:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1036
.__ret_1036:
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
    jne .L1080
    mov rax, 65535
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 1
    jne .L1082
    mov rax, 255
    mov rbx, rax
    jmp .L1083
.L1082:
.L1083:
section .data
.str1084: db 32,32,32,32,97,110,100,32,37,120,44,32,37,120,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str1084]
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
    jmp .__ret_1079
    jmp .L1081
.L1080:
.L1081:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1085
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1079
    jmp .L1086
.L1085:
.L1086:
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
    jne .L1087
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1079
    jmp .L1088
.L1087:
.L1088:
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
    jmp .__ret_1079
.__ret_1079:
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
    je .L1090
section .data
.str1092: db 32,32,32,32,97,100,114,108,32,37,120,44,32,37,115,10,0
section .text
    lea rax, [rel .str1092]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1089
    jmp .L1091
.L1090:
.L1091:
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
.str1093: db 0
section .text
    lea rax, [rel .str1093]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_add_imm
    add rsp, 32
    jmp .__ret_1089
.__ret_1089:
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
    jne .L1095
section .data
.str1097: db 32,32,32,32,115,116,114,32,37,120,44,32,91,120,50,56,44,32,35,45,56,93,33,10,0
section .text
    lea rax, [rel .str1097]
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
    jmp .__ret_1094
    jmp .L1096
.L1095:
.L1096:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1098
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1094
    jmp .L1099
.L1098:
.L1099:
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
.str1100: db 32,32,32,32,115,116,114,32,37,120,44,32,91,120,50,56,44,32,35,45,56,93,33,10,0
section .text
    lea rax, [rel .str1100]
    push rax
    pop rcx
    mov rdx, 16
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1094
.__ret_1094:
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
    je .L1102
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1101
    jmp .L1103
.L1102:
.L1103:
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
    jne .L1104
section .data
.str1106: db 32,32,32,32,108,100,114,32,120,50,56,44,32,91,120,50,56,93,10,0
section .text
    lea rax, [rel .str1106]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    jmp .__ret_1101
    jmp .L1105
.L1104:
.L1105:
section .data
.str1107: db 32,32,32,32,108,100,114,32,37,120,44,32,91,120,50,56,93,44,32,35,56,10,0
section .text
    lea rax, [rel .str1107]
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
    jmp .__ret_1101
.__ret_1101:
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
    jne .L1109
section .data
.str1111: db 97,100,100,115,0
section .text
    lea rax, [rel .str1111]
    jmp .__ret_1108
    jmp .L1110
.L1109:
.L1110:
    cmp rbx, 1
    jne .L1112
section .data
.str1114: db 115,117,98,115,0
section .text
    lea rax, [rel .str1114]
    jmp .__ret_1108
    jmp .L1113
.L1112:
.L1113:
    cmp rbx, 2
    jne .L1115
section .data
.str1117: db 97,110,100,115,0
section .text
    lea rax, [rel .str1117]
    jmp .__ret_1108
    jmp .L1116
.L1115:
.L1116:
    cmp rbx, 3
    jne .L1118
section .data
.str1120: db 111,114,114,0
section .text
    lea rax, [rel .str1120]
    jmp .__ret_1108
    jmp .L1119
.L1118:
.L1119:
section .data
.str1121: db 101,111,114,0
section .text
    lea rax, [rel .str1121]
    jmp .__ret_1108
.__ret_1108:
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
    jne .L1123
section .data
.str1125: db 97,100,100,0
section .text
    lea rax, [rel .str1125]
    jmp .__ret_1122
    jmp .L1124
.L1123:
.L1124:
    cmp rbx, 1
    jne .L1126
section .data
.str1128: db 115,117,98,0
section .text
    lea rax, [rel .str1128]
    jmp .__ret_1122
    jmp .L1127
.L1126:
.L1127:
    cmp rbx, 2
    jne .L1129
section .data
.str1131: db 97,110,100,0
section .text
    lea rax, [rel .str1131]
    jmp .__ret_1122
    jmp .L1130
.L1129:
.L1130:
    cmp rbx, 3
    jne .L1132
section .data
.str1134: db 111,114,114,0
section .text
    lea rax, [rel .str1134]
    jmp .__ret_1122
    jmp .L1133
.L1132:
.L1133:
section .data
.str1135: db 101,111,114,0
section .text
    lea rax, [rel .str1135]
    jmp .__ret_1122
.__ret_1122:
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
    jne .L1137
    mov rax, [rel __g_xarm_F_ADD]
    jmp .__ret_1136
    jmp .L1138
.L1137:
.L1138:
    cmp rbx, 1
    jne .L1139
    mov rax, [rel __g_xarm_F_SUB]
    jmp .__ret_1136
    jmp .L1140
.L1139:
.L1140:
    mov rax, [rel __g_xarm_F_LOGIC]
    jmp .__ret_1136
.__ret_1136:
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
    jne .L1142
    mov rcx, r13
    sub rsp, 32
    call xl_arith_mem
    add rsp, 32
    jmp .__ret_1141
    jmp .L1143
.L1142:
.L1143:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1144
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1141
    jmp .L1145
.L1144:
.L1145:
    mov rcx, r14
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov rbx, rax
    cmp rbx, 4
    jge .L1146
    mov rcx, r13
    sub rsp, 32
    call xl_arith_partial
    add rsp, 32
    jmp .__ret_1141
    jmp .L1147
.L1146:
.L1147:
    mov rcx, r14
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov r14, rax
    cmp r13, 2
    jl .L1148
    mov rcx, r13
    mov rdx, rbx
    mov r8, r14
    sub rsp, 32
    call xl_arith_logic
    add rsp, 32
    jmp .__ret_1141
    jmp .L1149
.L1148:
.L1149:
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
    jz .L1152
    mov rax, rbx
    mov rcx, 4
    cmp rax, rcx
    setne al
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
    mov rcx, r12
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 1
    jne .L1154
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1158
    mov rax, r12
    mov rcx, 4096
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1158
    mov rax, 1
    jmp .L1159
.L1158:
    mov rax, 0
.L1159:
    test rax, rax
    jz .L1156
section .data
.str1160: db 32,32,32,32,115,117,98,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1160]
    push rax
section .data
.str1161: db 115,0
section .text
    lea rax, [rel .str1161]
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
    jmp .L1157
.L1156:
    mov rax, 0
    sub rax, r12
    mov r12, rax
.L1157:
    jmp .L1155
.L1154:
.L1155:
    cmp rbx, 0
    jne .L1162
    mov rax, r14
    push rax
    mov rax, r14
    push rax
    mov rax, r12
    push rax
section .data
.str1164: db 115,0
section .text
    lea rax, [rel .str1164]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_add_imm
    add rsp, 32
    jmp .L1163
.L1162:
.L1163:
    jmp .L1151
.L1150:
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
.str1165: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1165]
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
.L1151:
    mov rcx, r13
    sub rsp, 32
    call xl_ar_fk
    add rsp, 32
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1141
.__ret_1141:
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
    jz .L1171
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
    jz .L1171
    mov rax, 1
    jmp .L1172
.L1171:
    mov rax, 0
.L1172:
    test rax, rax
    jz .L1169
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
    jz .L1169
    mov rax, 1
    jmp .L1170
.L1169:
    mov rax, 0
.L1170:
    test rax, rax
    jz .L1167
    mov rcx, [rbp-24]
    mov rdx, 0
    sub rsp, 32
    call xl_imm_to
    add rsp, 32
    mov rax, 1
    mov r13, rax
    jmp .L1168
.L1167:
.L1168:
    cmp r13, 0
    jne .L1173
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
    jne .L1175
    mov rcx, r14
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov rbx, rax
    mov rax, 64
    mov [rbp-80], rax
    cmp r15, 8
    je .L1177
    mov rax, 32
    mov [rbp-80], rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    jmp .L1178
.L1177:
.L1178:
    mov rcx, rbx
    mov rdx, [rbp-80]
    sub rsp, 32
    call xl_logic_ok
    add rsp, 32
    cmp rax, 0
    je .L1179
section .data
.str1181: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str1181]
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
    jmp .L1180
.L1179:
.L1180:
    jmp .L1176
.L1175:
.L1176:
    cmp r13, 0
    jne .L1182
    mov rcx, r14
    mov rdx, r15
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1184: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1184]
    push rax
    pop rcx
    mov rdx, [rbp-56]
    mov r8, r12
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .L1183
.L1182:
.L1183:
    jmp .L1174
.L1173:
.L1174:
    mov rax, [rel __g_xarm_F_LOGIC]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, [rbp-8]
    cmp rax, 2
    je .L1185
    mov rax, [rbp-24]
    add rax, 1
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 1
    mov [rel __g_xarm_xl_fpw], rax
    cmp r15, 8
    jne .L1187
    mov rax, 0
    mov [rel __g_xarm_xl_fpw], rax
    jmp .L1188
.L1187:
.L1188:
    jmp .L1186
.L1185:
.L1186:
    mov rax, 0
    jmp .__ret_1166
.__ret_1166:
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
    jne .L1190
section .data
.str1192: db 32,32,32,32,109,111,118,32,119,49,55,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1192]
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
.str1193: db 119,49,55,0
section .text
    lea rax, [rel .str1193]
    mov rbx, rax
    jmp .L1191
.L1190:
    mov rcx, r14
    mov rdx, 4
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
.L1191:
section .data
.str1194: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1194]
    push rax
    mov rcx, [rbp-8]
    sub rsp, 32
    call xl_ar_plain
    add rsp, 32
    push rax
section .data
.str1195: db 119,49,54,0
section .text
    lea rax, [rel .str1195]
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
    jmp .__ret_1189
.__ret_1189:
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
    jne .L1197
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
    jne .L1199
    mov rcx, r14
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r13, rax
    jmp .L1200
.L1199:
.L1200:
    jmp .L1198
.L1197:
.L1198:
section .data
.str1201: db 119,49,55,0
section .text
    lea rax, [rel .str1201]
    mov r12, rax
    cmp r13, 4
    jle .L1202
section .data
.str1204: db 120,49,55,0
section .text
    lea rax, [rel .str1204]
    mov r12, rax
    jmp .L1203
.L1202:
.L1203:
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
    jge .L1205
    mov rax, 4
    mov rbx, rax
    jmp .L1206
.L1205:
.L1206:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1207: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1207]
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
    jl .L1208
    mov rax, 18
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 1
    mov [rel __g_xarm_xl_fpw], rax
    cmp r13, 4
    jle .L1210
    mov rax, 0
    mov [rel __g_xarm_xl_fpw], rax
    jmp .L1211
.L1210:
.L1211:
    jmp .L1209
.L1208:
.L1209:
    mov rax, 0
    jmp .__ret_1196
.__ret_1196:
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
    je .L1213
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1212
    jmp .L1214
.L1213:
.L1214:
    mov rax, 120
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 8
    je .L1215
    mov rax, 119
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 4
    je .L1217
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1212
    jmp .L1218
.L1217:
.L1218:
    jmp .L1216
.L1215:
.L1216:
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
.str1219: db 32,32,32,32,37,115,32,37,115,44,32,37,115,44,32,35,49,10,0
section .text
    lea rax, [rel .str1219]
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
    jmp .__ret_1212
.__ret_1212:
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
    je .L1221
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1220
    jmp .L1222
.L1221:
.L1222:
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
section .data
.str1223: db 32,32,32,32,115,117,98,115,32,37,120,44,32,120,122,114,44,32,37,120,10,0
section .text
    lea rax, [rel .str1223]
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
    jmp .__ret_1220
.__ret_1220:
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
    je .L1225
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1224
    jmp .L1226
.L1225:
.L1226:
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
section .data
.str1227: db 32,32,32,32,109,118,110,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1227]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1224
.__ret_1224:
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
    jne .L1229
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
    jne .L1231
    mov rax, 8
    mov r15, rax
    jmp .L1232
.L1231:
.L1232:
section .data
.str1233: db 119,49,55,0
section .text
    lea rax, [rel .str1233]
    mov r13, rax
    cmp r15, 4
    jle .L1234
section .data
.str1236: db 120,49,55,0
section .text
    lea rax, [rel .str1236]
    mov r13, rax
    jmp .L1235
.L1234:
.L1235:
    mov rcx, r12
    mov rdx, 0
    mov r8, r15
    mov r9, r13
    sub rsp, 32
    call xl_mem
    add rsp, 32
    jmp .L1230
.L1229:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1237
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
    jmp .L1238
.L1237:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1228
.L1238:
.L1230:
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
    jne .L1239
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
    jz .L1243
    mov rax, rbx
    mov rcx, 4096
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1243
    mov rax, 1
    jmp .L1244
.L1243:
    mov rax, 0
.L1244:
    test rax, rax
    jz .L1241
section .data
.str1245: db 32,32,32,32,99,109,112,32,37,115,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1245]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, 1
    mov r12, rax
    jmp .L1242
.L1241:
.L1242:
    jmp .L1240
.L1239:
.L1240:
    cmp r12, 0
    jne .L1246
    mov rax, r15
    mov rbx, rax
    cmp rbx, 4
    jge .L1248
    mov rax, 4
    mov rbx, rax
    jmp .L1249
.L1248:
.L1249:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1250: db 32,32,32,32,99,109,112,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1250]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1247
.L1246:
.L1247:
    mov rax, [rel __g_xarm_F_SUB]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1228
.__ret_1228:
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
    je .L1252
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1251
    jmp .L1253
.L1252:
.L1253:
    mov rcx, rbx
    sub rsp, 32
    call xl_rs
    add rsp, 32
    mov r14, rax
    cmp r14, 4
    jge .L1254
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1251
    jmp .L1255
.L1254:
.L1255:
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
    jne .L1256
    mov rcx, r15
    sub rsp, 32
    call xl_val
    add rsp, 32
    mov r12, rax
    mov rax, 64
    mov rbx, rax
    cmp r14, 8
    je .L1258
    mov rax, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    jmp .L1259
.L1258:
.L1259:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call xl_logic_ok
    add rsp, 32
    cmp rax, 0
    je .L1260
section .data
.str1262: db 32,32,32,32,116,115,116,32,37,115,44,32,35,37,104,10,0
section .text
    lea rax, [rel .str1262]
    push rax
    pop rcx
    mov rdx, [rbp-32]
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
    mov rax, 1
    mov r13, rax
    jmp .L1261
.L1260:
.L1261:
    jmp .L1257
.L1256:
.L1257:
    cmp r13, 0
    jne .L1263
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call xl_src
    add rsp, 32
    mov rbx, rax
section .data
.str1265: db 32,32,32,32,116,115,116,32,37,115,44,32,37,115,10,0
section .text
    lea rax, [rel .str1265]
    push rax
    pop rcx
    mov rdx, [rbp-32]
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .L1264
.L1263:
.L1264:
    mov rax, [rel __g_xarm_F_LOGIC]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1251
.__ret_1251:
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
    je .L1267
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1266
    jmp .L1268
.L1267:
.L1268:
    mov rax, [rel __g_xarm_S_NOPS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 3
    jne .L1269
    mov rcx, r12
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_IMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1271
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1266
    jmp .L1272
.L1271:
.L1272:
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
.str1273: db 32,32,32,32,109,117,108,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1273]
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
    jmp .__ret_1266
    jmp .L1270
.L1269:
.L1270:
    cmp rbx, 2
    je .L1274
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1266
    jmp .L1275
.L1274:
.L1275:
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
    jne .L1276
    mov rcx, r13
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
    jmp .L1277
.L1276:
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call xl_src
    add rsp, 32
.L1277:
section .data
.str1278: db 32,32,32,32,109,117,108,32,37,120,44,32,37,120,44,32,37,120,10,0
section .text
    lea rax, [rel .str1278]
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
    jmp .__ret_1266
.__ret_1266:
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
    je .L1280
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1279
    jmp .L1281
.L1280:
.L1281:
    mov rcx, rbx
    sub rsp, 32
    call xl_opr
    add rsp, 32
    mov rbx, rax
section .data
.str1282: db 32,32,32,32,37,115,32,120,49,54,44,32,120,48,44,32,37,120,10,0
section .text
    lea rax, [rel .str1282]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call xl_f2
    add rsp, 32
section .data
.str1283: db 32,32,32,32,109,115,117,98,32,120,50,44,32,120,49,54,44,32,37,120,44,32,120,48,10,0
section .text
    lea rax, [rel .str1283]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call xl_f1
    add rsp, 32
section .data
.str1284: db 32,32,32,32,109,111,118,32,120,48,44,32,120,49,54,10,0
section .text
    lea rax, [rel .str1284]
    push rax
    pop rcx
    sub rsp, 32
    call xl_f0
    add rsp, 32
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_1279
.__ret_1279:
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
    je .L1286
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1285
    jmp .L1287
.L1286:
.L1287:
    mov rcx, r12
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 8
    je .L1288
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1285
    jmp .L1289
.L1288:
.L1289:
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
    jne .L1290
    mov rcx, rbx
    sub rsp, 32
    call xl_val
    add rsp, 32
    and rax, 63
    mov rbx, rax
    cmp r13, 0
    je .L1292
    mov rax, 0
    sub rax, rbx
    and rax, 63
    mov rbx, rax
    jmp .L1293
.L1292:
.L1293:
section .data
.str1294: db 32,32,32,32,37,115,32,37,120,44,32,37,120,44,32,35,37,100,10,0
section .text
    lea rax, [rel .str1294]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r12
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_1285
    jmp .L1291
.L1290:
.L1291:
    cmp r13, 0
    je .L1295
section .data
.str1297: db 32,32,32,32,115,117,98,32,120,49,54,44,32,120,122,114,44,32,120,49,10,32,32,32,32,114,111,114,32,37,120,44,32,37,120,44,32,120,49,54,10,0
section .text
    lea rax, [rel .str1297]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r12
    sub rsp, 32
    call xl_f2
    add rsp, 32
    jmp .__ret_1285
    jmp .L1296
.L1295:
.L1296:
section .data
.str1298: db 32,32,32,32,37,115,32,37,120,44,32,37,120,44,32,120,49,10,0
section .text
    lea rax, [rel .str1298]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r12
    mov r9, r12
    sub rsp, 32
    call xl_f3
    add rsp, 32
    jmp .__ret_1285
.__ret_1285:
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
    je .L1300
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
    je .L1302
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1299
    jmp .L1303
.L1302:
.L1303:
    jmp .L1301
.L1300:
.L1301:
    mov rcx, r13
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1304
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1299
    jmp .L1305
.L1304:
.L1305:
    mov rcx, rbx
    sub rsp, 32
    call xl_addr
    add rsp, 32
    mov rax, [rel __g_xarm_xl_mo]
    cmp rax, 0
    je .L1306
    mov rax, 16
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
section .data
.str1308: db 0
section .text
    lea rax, [rel .str1308]
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
    jmp .L1307
.L1306:
.L1307:
    mov rax, [rel __g_xarm_xl_uniq]
    add rax, 1
    mov [rel __g_xarm_xl_uniq], rax
section .data
.str1309: db 46,120,97,37,100,58,10,0
section .text
    lea rax, [rel .str1309]
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
    jne .L1310
section .data
.str1312: db 32,32,32,32,108,100,97,120,114,32,120,49,53,44,32,91,37,120,93,10,32,32,32,32,115,116,108,120,114,32,119,49,52,44,32,37,120,44,32,91,37,120,93,10,32,32,32,32,99,98,110,122,32,119,49,52,44,32,46,120,97,37,100,10
    db 32,32,32,32,109,111,118,32,37,120,44,32,120,49,53,10,0
section .text
    lea rax, [rel .str1312]
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
    jmp .L1311
.L1310:
    mov rcx, r13
    sub rsp, 32
    call xl_rs
    add rsp, 32
    cmp rax, 4
    jne .L1313
section .data
.str1315: db 32,32,32,32,108,100,97,120,114,32,119,49,53,44,32,91,37,120,93,10,32,32,32,32,115,116,108,120,114,32,119,49,52,44,32,37,119,44,32,91,37,120,93,10,32,32,32,32,99,98,110,122,32,119,49,52,44,32,46,120,97,37,100,10
    db 32,32,32,32,109,111,118,32,37,119,44,32,119,49,53,10,0
section .text
    lea rax, [rel .str1315]
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
    jmp .L1314
.L1313:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1299
.L1314:
.L1311:
    mov rax, [rel __g_xarm_F_NONE]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    jmp .__ret_1299
.__ret_1299:
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
    jne .L1317
section .data
.str1319: db 32,32,32,32,98,114,32,37,120,10,0
section .text
    lea rax, [rel .str1319]
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
    jmp .__ret_1316
    jmp .L1318
.L1317:
.L1318:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1320
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1316
    jmp .L1321
.L1320:
.L1321:
section .data
.str1322: db 32,32,32,32,98,32,37,115,10,0
section .text
    lea rax, [rel .str1322]
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
    jmp .__ret_1316
.__ret_1316:
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
    jne .L1324
section .data
.str1326: db 32,32,32,32,115,116,114,32,120,51,48,44,32,91,120,50,56,44,32,35,45,56,93,33,10,32,32,32,32,98,108,114,32,37,120,10,32,32,32,32,108,100,114,32,120,51,48,44,32,91,120,50,56,93,44,32,35,56,10,0
section .text
    lea rax, [rel .str1326]
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
    jmp .__ret_1323
    jmp .L1325
.L1324:
.L1325:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_LABEL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1327
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1323
    jmp .L1328
.L1327:
.L1328:
section .data
.str1329: db 32,32,32,32,115,116,114,32,120,51,48,44,32,91,120,50,56,44,32,35,45,56,93,33,10,32,32,32,32,98,108,32,37,115,10,32,32,32,32,108,100,114,32,120,51,48,44,32,91,120,50,56,93,44,32,35,56,10,0
section .text
    lea rax, [rel .str1329]
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
    jmp .__ret_1323
.__ret_1323:
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
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call xl_cond
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1333
section .data
.str1335: db 32,32,32,32,98,46,37,115,32,37,115,10,0
section .text
    lea rax, [rel .str1335]
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
    je .L1337
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1336
    jmp .L1338
.L1337:
.L1338:
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
    je .L1339
section .data
.str1341: db 32,32,32,32,99,115,101,116,32,37,120,44,32,37,115,10,0
section .text
    lea rax, [rel .str1341]
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
    jmp .L1340
.L1339:
.L1340:
    mov rax, 0
    jmp .__ret_1336
.__ret_1336:
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
    jne .L1343
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1345
section .data
.str1347: db 32,32,32,32,102,109,111,118,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1347]
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
    jmp .__ret_1342
    jmp .L1346
.L1345:
.L1346:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1348
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
    jmp .__ret_1342
    jmp .L1349
.L1348:
.L1349:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1350
section .data
.str1352: db 32,32,32,32,102,109,111,118,32,37,68,44,32,37,120,10,0
section .text
    lea rax, [rel .str1352]
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
    jmp .__ret_1342
    jmp .L1351
.L1350:
.L1351:
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1342
    jmp .L1344
.L1343:
.L1344:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1353
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1342
    jmp .L1354
.L1353:
.L1354:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1355
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
    jmp .__ret_1342
    jmp .L1356
.L1355:
.L1356:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_REG]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1357
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1342
    jmp .L1358
.L1357:
.L1358:
section .data
.str1359: db 32,32,32,32,102,109,111,118,32,37,120,44,32,37,68,10,0
section .text
    lea rax, [rel .str1359]
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
    jmp .__ret_1342
.__ret_1342:
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
    jne .L1361
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1363
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1360
    jmp .L1364
.L1363:
.L1364:
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
    jmp .__ret_1360
    jmp .L1362
.L1361:
.L1362:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1367
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1367
    mov rax, 0
    jmp .L1368
.L1367:
    mov rax, 1
.L1368:
    test rax, rax
    jz .L1365
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1360
    jmp .L1366
.L1365:
.L1366:
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
    jmp .__ret_1360
.__ret_1360:
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
    jnz .L1372
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
    jnz .L1372
    mov rax, 0
    jmp .L1373
.L1372:
    mov rax, 1
.L1373:
    test rax, rax
    jz .L1370
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1369
    jmp .L1371
.L1370:
.L1371:
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
    jmp .__ret_1369
.__ret_1369:
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
    jne .L1375
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1377
section .data
.str1379: db 32,32,32,32,109,111,118,32,37,86,46,49,54,98,44,32,37,86,46,49,54,98,10,0
section .text
    lea rax, [rel .str1379]
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
    jmp .__ret_1374
    jmp .L1378
.L1377:
.L1378:
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1380
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1374
    jmp .L1381
.L1380:
.L1381:
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
    jmp .__ret_1374
    jmp .L1376
.L1375:
.L1376:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1384
    mov rax, rbx
    push rax
    mov rax, [rel __g_xarm_K_XMM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1384
    mov rax, 0
    jmp .L1385
.L1384:
    mov rax, 1
.L1385:
    test rax, rax
    jz .L1382
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1374
    jmp .L1383
.L1382:
.L1383:
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
    jmp .__ret_1374
.__ret_1374:
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
    jne .L1387
    mov rcx, rbx
    sub rsp, 32
    call xl_xmm
    add rsp, 32
    jmp .__ret_1386
    jmp .L1388
.L1387:
.L1388:
    mov rcx, rbx
    sub rsp, 32
    call xl_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_xarm_K_MEM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1389
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
    mov rax, 8
    push rax
section .data
.str1391: db 100,49,54,0
section .text
    lea rax, [rel .str1391]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_mem
    add rsp, 32
    mov rax, 16
    jmp .__ret_1386
    jmp .L1390
.L1389:
.L1390:
section .data
.str1392: db 111,112,101,114,97,110,100,32,65,82,77,54,52,32,99,97,110,110,111,116,32,116,97,107,101,32,104,101,114,101,0
section .text
    lea rax, [rel .str1392]
    push rax
    pop rcx
    sub rsp, 32
    call xl_fail
    add rsp, 32
    mov rax, 0
    jmp .__ret_1386
.__ret_1386:
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
    je .L1394
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1393
    jmp .L1395
.L1394:
.L1395:
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
    je .L1396
section .data
.str1398: db 32,32,32,32,37,115,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1398]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, rbx
    mov r9, r12
    sub rsp, 32
    call xl_f3
    add rsp, 32
    jmp .__ret_1393
    jmp .L1397
.L1396:
.L1397:
section .data
.str1399: db 32,32,32,32,37,115,32,37,68,44,32,37,68,44,32,37,68,10,0
section .text
    lea rax, [rel .str1399]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, rbx
    mov r9, rbx
    mov r10, r12
    sub rsp, 32
    call xl_f4
    add rsp, 32
    jmp .__ret_1393
.__ret_1393:
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
    jnz .L1403
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
    jnz .L1403
    mov rax, 0
    jmp .L1404
.L1403:
    mov rax, 1
.L1404:
    test rax, rax
    jz .L1401
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1400
    jmp .L1402
.L1401:
.L1402:
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
    jmp .__ret_1400
.__ret_1400:
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
    je .L1406
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1405
    jmp .L1407
.L1406:
.L1407:
    sub rsp, 32
    call xl_fsrc
    add rsp, 32
    mov rbx, rax
section .data
.str1408: db 32,32,32,32,102,99,109,112,32,37,68,44,32,37,68,10,0
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
    mov rax, [rel __g_xarm_F_FP]
    mov [rel __g_xarm_xl_fk], rax
    mov rax, 0
    mov [rel __g_xarm_xl_fpend], rax
    mov rax, 0
    jmp .__ret_1405
.__ret_1405:
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
    jnz .L1412
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
.str1414: db 32,32,32,32,115,99,118,116,102,32,37,68,44,32,37,115,10,0
section .text
    lea rax, [rel .str1414]
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
    jmp .__ret_1409
.__ret_1409:
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
    jnz .L1418
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
    jnz .L1418
    mov rax, 0
    jmp .L1419
.L1418:
    mov rax, 1
.L1419:
    test rax, rax
    jz .L1416
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1415
    jmp .L1417
.L1416:
.L1417:
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
.str1420: db 32,32,32,32,37,115,32,37,115,44,32,37,68,10,0
section .text
    lea rax, [rel .str1420]
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
    jmp .__ret_1415
.__ret_1415:
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
    je .L1422
    sub rsp, 32
    call xl_bad
    add rsp, 32
    jmp .__ret_1421
    jmp .L1423
.L1422:
.L1423:
    mov rcx, rbx
    sub rsp, 32
    call xl_addr
    add rsp, 32
    mov rax, [rel __g_xarm_xl_mo]
    cmp rax, 0
    je .L1424
    mov rax, 16
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    mov rax, [rel __g_xarm_xl_mo]
    push rax
section .data
.str1426: db 0
section .text
    lea rax, [rel .str1426]
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
    jmp .L1425
.L1424:
.L1425:
    mov rax, r12
    push rax
    mov rax, [rel __g_xarm_xl_mb]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_f1
    add rsp, 32
    jmp .__ret_1421
.__ret_1421:
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
.str1428: db 110,111,32,65,82,77,54,52,32,102,111,114,109,32,102,111,114,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str1428]
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
.L1429:
    mov rax, 1
    test rax, rax
    jz .L1430
    mov rax, [rel __g_xarm_S_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 0
    je .L1432
    mov rax, 1
    neg rax
    jmp .__ret_1427
    jmp .L1433
.L1432:
.L1433:
    mov rax, [rel __g_xarm_xl_out]
    push rax
    mov rax, [rel __g_xarm_xl_out_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1434
    mov rax, [rel __g_xarm_S_ERR_MSG]
    push rax
section .data
.str1436: db 111,117,116,112,117,116,32,98,117,102,102,101,114,32,102,117,108,108,0
section .text
    lea rax, [rel .str1436]
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
    jmp .__ret_1427
    jmp .L1435
.L1434:
.L1435:
    sub rsp, 32
    call xl_read_line
    add rsp, 32
    cmp rax, 0
    jne .L1437
    jmp .L1430
    jmp .L1438
.L1437:
.L1438:
    sub rsp, 32
    call xl_native_skip
    add rsp, 32
    cmp rax, 0
    jne .L1439
    sub rsp, 32
    call xl_do_line
    add rsp, 32
    jmp .L1440
.L1439:
.L1440:
.L1431:
    jmp .L1429
.L1430:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_xarm_S_OS]
    push rax
    pop rcx
    sub rsp, 32
    call xl_get
    add rsp, 32
    cmp rax, 1
    jne .L1441
    mov rax, 1
    mov rbx, rax
    jmp .L1442
.L1441:
.L1442:
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
    je .L1443
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
    jmp .L1444
.L1443:
.L1444:
    mov rax, [rel __g_xarm_xl_out]
    sub rax, r12
    jmp .__ret_1427
.__ret_1427:
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
    jmp .__ret_1445
.__ret_1445:
    mov rsp, rbp
    pop rbp
    ret
