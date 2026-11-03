; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_karm_core_KA_LBL_MAX: dq 65535
section .text
section .data
__g_karm_core_KA_HASH_MASK: dq 131071
section .text
section .data
__g_karm_core_KA_REL_MAX: dq 262144
section .text
section .data
__g_karm_core_KA_MOVSZ_MAX: dq 1048575
section .text
section .bss
__g_karm_core_kc_code: resq 1048576
section .text
section .bss
__g_karm_core_kc_data: resq 524288
section .text
section .data
__g_karm_core_kc_code_len: dq 0
section .text
section .data
__g_karm_core_kc_data_len: dq 0
section .text
section .data
__g_karm_core_kc_bss_len: dq 0
section .text
section .data
__g_karm_core_kc_final_code: dq 0
section .text
section .data
__g_karm_core_kc_final_data: dq 0
section .text
section .data
__g_karm_core_kc_base: dq 0
section .text
section .data
__g_karm_core_kc_pass_n: dq 0
section .text
section .data
__g_karm_core_kc_salign: dq 0
section .text
section .data
__g_karm_core_kc_rsign: dq 0
section .text
section .data
__g_karm_core_kc_nrel: dq 0
section .text
section .data
__g_karm_core_kc_rel_n: dq 0
section .text
section .data
__g_karm_core_kc_rel_text: dq 0
section .text
section .bss
__g_karm_core_kc_rel_off: resq 262144
section .text
section .data
__g_karm_core_kc_sec: dq 0
section .text
section .data
__g_karm_core_kc_pos: dq 0
section .text
section .data
__g_karm_core_kc_end: dq 0
section .text
section .data
__g_karm_core_kc_src: dq 0
section .text
section .data
__g_karm_core_kc_len: dq 0
section .text
section .data
__g_karm_core_kc_line: dq 0
section .text
section .bss
__g_karm_core_kc_linebuf: resq 128
section .text
section .bss
__g_karm_core_kc_word: resq 32
section .text
section .data
__g_karm_core_kc_wordlen: dq 0
section .text
section .bss
__g_karm_core_kc_mnem_buf: resq 8
section .text
section .data
__g_karm_core_kc_rest: dq 0
section .text
section .bss
__g_karm_core_kc_ops: resq 192
section .text
section .data
__g_karm_core_kc_nops_n: dq 0
section .text
section .bss
__g_karm_core_kc_last: resq 32
section .text
section .data
__g_karm_core_kc_lastlen: dq 0
section .text
section .bss
__g_karm_core_kc_name: resq 64
section .text
section .data
__g_karm_core_kc_deflbl: dq 0
section .text
section .data
__g_karm_core_kc_err_count: dq 0
section .text
section .bss
__g_karm_core_kc_err_lines: resq 64
section .text
section .bss
__g_karm_core_kc_err_kind: resq 64
section .text
section .bss
__g_karm_core_kc_err_mnem: resq 128
section .text
section .data
__g_karm_core_kc_movseq: dq 0
section .text
section .bss
__g_karm_core_kc_movsz: resq 131072
section .text
section .data
__g_karm_core_kc_unres_f: dq 0
section .text
section .data
__g_karm_core_kc_ep: dq 0
section .text
section .data
__g_karm_core_kc_everr: dq 0
section .text
section .data
__g_karm_core_kc_evok_f: dq 0
section .text
section .bss
__g_karm_core_kc_tmp: resq 32
section .text
section .bss
__g_karm_core_kc_seq: resq 8
section .text
section .data
__g_karm_core_kc_rnum_v: dq 0
section .text
section .data
__g_karm_core_kc_shamt_v: dq 0
section .text
section .data
__g_karm_core_kc_item_f: dq 0
section .text
section .data
__g_karm_core_kc_lb_count: dq 0
section .text
section .bss
__g_karm_core_kc_lb_noff: resq 65536
section .text
section .bss
__g_karm_core_kc_lb_nlen: resq 65536
section .text
section .bss
__g_karm_core_kc_lb_sec: resq 65536
section .text
section .bss
__g_karm_core_kc_lb_val: resq 65536
section .text
section .bss
__g_karm_core_kc_lb_pool: resq 262144
section .text
section .data
__g_karm_core_kc_lb_pool_len: dq 0
section .text
section .bss
__g_karm_core_kc_lb_hash: resq 65536
section .text
section .data
__g_karm_core_kc_km_base: dq 0
section .text
section .data
__g_karm_core_kc_km_kind: dq 0
section .text
section .data
__g_karm_core_kc_km_imm: dq 0
section .text
section .data
__g_karm_core_kc_km_idx: dq 0
section .text
section .data
__g_karm_core_kc_km_idxw: dq 0
section .text
section .data
__g_karm_core_kc_km_ext: dq 0
section .text
section .data
__g_karm_core_kc_km_amt: dq 0
section .text
section .data
__g_karm_core_kc_km_pre: dq 0
section .text
kc_g8:
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
kc_p8:
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
kc_g32:
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
kc_p32:
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
kc_g64:
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
kc_p64:
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
kc_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g64
    add rsp, 32
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kc_put:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p64
    add rsp, 32
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kc_init:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0x400080
    mov [rel __g_karm_core_kc_base], rax
    mov rax, 16
    mov [rel __g_karm_core_kc_salign], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_err_count], rax
    sub rsp, 32
    call kc_reset_labels
    add rsp, 32
    jmp .__ret_8
.__ret_8:
    mov rsp, rbp
    pop rbp
    ret
kc_set_base:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_karm_core_kc_base], rax
    mov rax, 0
    jmp .__ret_9
.__ret_9:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_set_align:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_karm_core_kc_salign], rax
    mov rax, 0
    jmp .__ret_10
.__ret_10:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_align:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_karm_core_kc_salign]
    sub rax, 1
    mov rbx, rax
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, rbx
    not rax
    mov rcx, rax
    pop rax
    and rax, rcx
    jmp .__ret_11
.__ret_11:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kc_align_code:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_karm_core_kc_salign]
    sub rax, 1
    mov r12, rax
    mov rax, [rel __g_karm_core_kc_base]
    and rax, r12
    mov rbx, rax
    mov rax, r13
    add rax, rbx
    add rax, r12
    push rax
    mov rax, r12
    not rax
    mov rcx, rax
    pop rax
    and rax, rcx
    sub rax, rbx
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kc_get_data_off:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_code_len]
    push rax
    pop rcx
    sub rsp, 32
    call kc_align_code
    add rsp, 32
    jmp .__ret_13
.__ret_13:
    mov rsp, rbp
    pop rbp
    ret
kc_get_code_len:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_code_len]
    jmp .__ret_14
.__ret_14:
    mov rsp, rbp
    pop rbp
    ret
kc_get_data_len:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_data_len]
    jmp .__ret_15
.__ret_15:
    mov rsp, rbp
    pop rbp
    ret
kc_label:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L17:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L18
    add rbx, 1
.L19:
    jmp .L17
.L18:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call kc_find_exact
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L20
    mov rax, 1
    neg rax
    jmp .__ret_16
    jmp .L21
.L20:
.L21:
    mov rcx, rbx
    sub rsp, 32
    call kc_label_addr
    add rsp, 32
    jmp .__ret_16
.__ret_16:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_reloc_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_rel_n]
    jmp .__ret_22
.__ret_22:
    mov rsp, rbp
    pop rbp
    ret
kc_reloc_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_rel_off]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_at
    add rsp, 32
    jmp .__ret_23
.__ret_23:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_reloc_text:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_rel_text]
    jmp .__ret_24
.__ret_24:
    mov rsp, rbp
    pop rbp
    ret
kc_assemble:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov [rel __g_karm_core_kc_src], rax
    mov rax, rbx
    mov [rel __g_karm_core_kc_len], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_err_count], rax
    sub rsp, 32
    call kc_reset_labels
    add rsp, 32
    mov rax, 0
    mov [rel __g_karm_core_kc_final_code], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_final_data], rax
    mov rax, 1
    mov [rel __g_karm_core_kc_pass_n], rax
    sub rsp, 32
    call kc_run_pass
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_code_len]
    mov [rel __g_karm_core_kc_final_code], rax
    mov rax, [rel __g_karm_core_kc_data_len]
    mov [rel __g_karm_core_kc_final_data], rax
    mov rax, 2
    mov [rel __g_karm_core_kc_pass_n], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_rel_n], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_rel_text], rax
    sub rsp, 32
    call kc_run_pass
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_err_count]
    cmp rax, 0
    je .L26
    mov rax, 0
    jmp .__ret_25
    jmp .L27
.L26:
.L27:
    mov rax, 1
    jmp .__ret_25
.__ret_25:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kc_build_image:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_karm_core_kc_code_len]
    push rax
    pop rcx
    sub rsp, 32
    call kc_align_code
    add rsp, 32
    mov r14, rax
    lea rax, [rel __g_karm_core_kc_code]
    mov r13, rax
    mov rax, [rel __g_karm_core_kc_code_len]
    mov r12, rax
.L29:
    cmp r12, r14
    jge .L30
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r12, 1
.L31:
    jmp .L29
.L30:
    lea rax, [rel __g_karm_core_kc_data]
    mov rbx, rax
    mov rax, 0
    mov r12, rax
.L32:
    mov rax, r12
    push rax
    mov rax, [rel __g_karm_core_kc_data_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L33
    mov rax, r13
    add rax, r14
    add rax, r12
    push rax
    mov rax, rbx
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r12, 1
.L34:
    jmp .L32
.L33:
    mov rax, r14
    push rax
    mov rax, [rel __g_karm_core_kc_data_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_get_code:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_karm_core_kc_code]
    jmp .__ret_35
.__ret_35:
    mov rsp, rbp
    pop rbp
    ret
kc_get_size:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_code_len]
    jmp .__ret_36
.__ret_36:
    mov rsp, rbp
    pop rbp
    ret
kc_get_bss_size:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_bss_len]
    jmp .__ret_37
.__ret_37:
    mov rsp, rbp
    pop rbp
    ret
kc_get_entry:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
section .data
.str39: db 95,115,116,97,114,116,0
section .text
    lea rax, [rel .str39]
    push rax
    pop rcx
    mov rdx, 6
    sub rsp, 32
    call kc_find_exact
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L40
    mov rax, 0
    jmp .__ret_38
    jmp .L41
.L40:
.L41:
    mov rcx, rbx
    sub rsp, 32
    call kc_label_addr
    add rsp, 32
    jmp .__ret_38
.__ret_38:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_get_error_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_err_count]
    jmp .__ret_42
.__ret_42:
    mov rsp, rbp
    pop rbp
    ret
kc_get_error_line_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_err_lines]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_at
    add rsp, 32
    mov rcx, 4294967295
    and rax, rcx
    jmp .__ret_43
.__ret_43:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_get_error_mnem:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_err_mnem]
    push rax
    mov rax, rbx
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_44
.__ret_44:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_get_error_text:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_err_kind]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_at
    add rsp, 32
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    cmp rbx, 1
    jne .L46
section .data
.str48: db 117,110,107,110,111,119,110,32,105,110,115,116,114,117,99,116,105,111,110,0
section .text
    lea rax, [rel .str48]
    jmp .__ret_45
    jmp .L47
.L46:
.L47:
    cmp rbx, 2
    jne .L49
section .data
.str51: db 111,112,101,114,97,110,100,115,32,116,104,105,115,32,105,110,115,116,114,117,99,116,105,111,110,32,100,111,101,115,32,110,111,116,32,116,97,107,101,0
section .text
    lea rax, [rel .str51]
    jmp .__ret_45
    jmp .L50
.L49:
.L50:
    cmp rbx, 3
    jne .L52
section .data
.str54: db 118,97,108,117,101,32,111,114,32,100,105,115,116,97,110,99,101,32,111,117,116,32,111,102,32,114,97,110,103,101,0
section .text
    lea rax, [rel .str54]
    jmp .__ret_45
    jmp .L53
.L52:
.L53:
    cmp rbx, 4
    jne .L55
section .data
.str57: db 117,110,100,101,102,105,110,101,100,32,115,121,109,98,111,108,0
section .text
    lea rax, [rel .str57]
    jmp .__ret_45
    jmp .L56
.L55:
.L56:
    cmp rbx, 5
    jne .L58
section .data
.str60: db 108,97,98,101,108,32,100,101,102,105,110,101,100,32,116,119,105,99,101,0
section .text
    lea rax, [rel .str60]
    jmp .__ret_45
    jmp .L59
.L58:
.L59:
    cmp rbx, 6
    jne .L61
section .data
.str63: db 110,101,101,100,115,32,97,32,118,97,108,117,101,32,107,110,111,119,110,32,111,110,32,116,104,101,32,102,105,114,115,116,32,112,97,115,115,0
section .text
    lea rax, [rel .str63]
    jmp .__ret_45
    jmp .L62
.L61:
.L62:
    cmp rbx, 7
    jne .L64
section .data
.str66: db 105,109,109,101,100,105,97,116,101,32,99,97,110,110,111,116,32,98,101,32,101,110,99,111,100,101,100,32,97,115,32,97,110,32,65,82,77,54,52,32,98,105,116,32,109,97,115,107,0
section .text
    lea rax, [rel .str66]
    jmp .__ret_45
    jmp .L65
.L64:
.L65:
section .data
.str67: db 117,110,107,110,111,119,110,32,115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str67]
    jmp .__ret_45
.__ret_45:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_pass:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_pass_n]
    jmp .__ret_68
.__ret_68:
    mov rsp, rbp
    pop rbp
    ret
kc_nops:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_nops_n]
    jmp .__ret_69
.__ret_69:
    mov rsp, rbp
    pop rbp
    ret
kc_set_nops:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_karm_core_kc_nops_n], rax
    mov rax, 0
    jmp .__ret_70
.__ret_70:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_mnem:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_karm_core_kc_mnem_buf]
    jmp .__ret_71
.__ret_71:
    mov rsp, rbp
    pop rbp
    ret
kc_unres:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_unres_f]
    jmp .__ret_72
.__ret_72:
    mov rsp, rbp
    pop rbp
    ret
kc_clear_unres:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_karm_core_kc_unres_f], rax
    mov rax, 0
    jmp .__ret_73
.__ret_73:
    mov rsp, rbp
    pop rbp
    ret
kc_evok:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_evok_f]
    jmp .__ret_74
.__ret_74:
    mov rsp, rbp
    pop rbp
    ret
kc_rnum:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_rnum_v]
    jmp .__ret_75
.__ret_75:
    mov rsp, rbp
    pop rbp
    ret
kc_shamt:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_shamt_v]
    jmp .__ret_76
.__ret_76:
    mov rsp, rbp
    pop rbp
    ret
kc_mbase:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_base]
    jmp .__ret_77
.__ret_77:
    mov rsp, rbp
    pop rbp
    ret
kc_mkind:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_kind]
    jmp .__ret_78
.__ret_78:
    mov rsp, rbp
    pop rbp
    ret
kc_mimm:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_imm]
    jmp .__ret_79
.__ret_79:
    mov rsp, rbp
    pop rbp
    ret
kc_midx:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_idx]
    jmp .__ret_80
.__ret_80:
    mov rsp, rbp
    pop rbp
    ret
kc_mext:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_ext]
    jmp .__ret_81
.__ret_81:
    mov rsp, rbp
    pop rbp
    ret
kc_mamt:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_amt]
    jmp .__ret_82
.__ret_82:
    mov rsp, rbp
    pop rbp
    ret
kc_mpre:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_km_pre]
    jmp .__ret_83
.__ret_83:
    mov rsp, rbp
    pop rbp
    ret
kc_run_pass:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_karm_core_kc_code_len], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_data_len], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_bss_len], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_sec], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_line], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_movseq], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_lastlen], rax
    lea rax, [rel __g_karm_core_kc_last]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_src]
    mov [rel __g_karm_core_kc_pos], rax
    mov rax, [rel __g_karm_core_kc_src]
    push rax
    mov rax, [rel __g_karm_core_kc_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_karm_core_kc_end], rax
.L85:
    sub rsp, 32
    call kc_read_line
    add rsp, 32
    cmp rax, 0
    je .L86
    sub rsp, 32
    call kc_do_line
    add rsp, 32
.L87:
    jmp .L85
.L86:
    mov rax, 0
    jmp .__ret_84
.__ret_84:
    mov rsp, rbp
    pop rbp
    ret
kc_read_line:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rax, [rel __g_karm_core_kc_pos]
    mov r15, rax
    mov rax, r15
    push rax
    mov rax, [rel __g_karm_core_kc_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L89
    mov rax, 0
    jmp .__ret_88
    jmp .L90
.L89:
.L90:
    mov rax, [rel __g_karm_core_kc_line]
    add rax, 1
    mov [rel __g_karm_core_kc_line], rax
    lea rax, [rel __g_karm_core_kc_linebuf]
    mov [rbp-16], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L91:
    mov rax, r15
    push rax
    mov rax, [rel __g_karm_core_kc_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L92
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 10
    jne .L94
    add r15, 1
    jmp .L92
    jmp .L95
.L94:
.L95:
    cmp rbx, 13
    je .L96
    cmp r13, 0
    je .L98
    cmp rbx, r13
    jne .L100
    mov rax, 0
    mov r13, rax
    jmp .L101
.L100:
.L101:
    jmp .L99
.L98:
    cmp rbx, 59
    jne .L102
    mov rax, 1
    mov r12, rax
    jmp .L103
.L102:
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L108
    mov rax, r15
    add rax, 1
    push rax
    mov rax, [rel __g_karm_core_kc_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L108
    mov rax, 1
    jmp .L109
.L108:
    mov rax, 0
.L109:
    test rax, rax
    jz .L106
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L106
    mov rax, 1
    jmp .L107
.L106:
    mov rax, 0
.L107:
    test rax, rax
    jz .L104
    mov rax, 1
    mov r12, rax
    jmp .L105
.L104:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L112
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L112
    mov rax, 0
    jmp .L113
.L112:
    mov rax, 1
.L113:
    test rax, rax
    jz .L110
    mov rax, rbx
    mov r13, rax
    jmp .L111
.L110:
.L111:
.L105:
.L103:
.L99:
    cmp r12, 0
    je .L114
.L116:
    mov rax, r15
    push rax
    mov rax, [rel __g_karm_core_kc_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L119
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L119
    mov rax, 1
    jmp .L120
.L119:
    mov rax, 0
.L120:
    test rax, rax
    jz .L117
    add r15, 1
.L118:
    jmp .L116
.L117:
    mov rax, r15
    push rax
    mov rax, [rel __g_karm_core_kc_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L121
    add r15, 1
    jmp .L122
.L121:
.L122:
    jmp .L92
    jmp .L115
.L114:
.L115:
    cmp r14, 1000
    jge .L123
    mov rax, [rbp-16]
    add rax, r14
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r14, 1
    jmp .L124
.L123:
.L124:
    jmp .L97
.L96:
.L97:
    add r15, 1
.L93:
    jmp .L91
.L92:
    mov rax, [rbp-16]
    add rax, r14
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, r15
    mov [rel __g_karm_core_kc_pos], rax
    mov rax, 1
    jmp .__ret_88
.__ret_88:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kc_skipb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rbx, rax
.L126:
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L129
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L129
    mov rax, 0
    jmp .L130
.L129:
    mov rax, 1
.L130:
    test rax, rax
    jz .L127
    add rbx, 1
.L128:
    jmp .L126
.L127:
    mov rax, rbx
    jmp .__ret_125
.__ret_125:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_getword:
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
    lea rax, [rel __g_karm_core_kc_word]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L132:
    mov rax, 1
    test rax, rax
    jz .L133
    mov rcx, r14
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L141
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L141
    mov rax, 0
    jmp .L142
.L141:
    mov rax, 1
.L142:
    test rax, rax
    jnz .L139
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L139
    mov rax, 0
    jmp .L140
.L139:
    mov rax, 1
.L140:
    test rax, rax
    jnz .L137
    mov rax, rbx
    mov rcx, 58
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L137
    mov rax, 0
    jmp .L138
.L137:
    mov rax, 1
.L138:
    test rax, rax
    jz .L135
    jmp .L133
    jmp .L136
.L135:
.L136:
    cmp r12, 250
    jge .L143
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r12, 1
    jmp .L144
.L143:
.L144:
    add r14, 1
.L134:
    jmp .L132
.L133:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, r12
    mov [rel __g_karm_core_kc_wordlen], rax
    mov rax, r14
    jmp .__ret_131
.__ret_131:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kc_word_to_mnem:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    lea rax, [rel __g_karm_core_kc_word]
    mov r14, rax
    lea rax, [rel __g_karm_core_kc_mnem_buf]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L146:
    mov rax, 1
    test rax, rax
    jz .L147
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    cmp rbx, 0
    jne .L149
    mov rax, 0
    jmp .__ret_145
    jmp .L150
.L149:
.L150:
    add r12, 1
    cmp r12, 60
    jl .L151
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_145
    jmp .L152
.L151:
.L152:
.L148:
    jmp .L146
.L147:
    mov rax, 0
    jmp .__ret_145
.__ret_145:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_do_line:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 1
    neg rax
    mov [rel __g_karm_core_kc_deflbl], rax
    lea rax, [rel __g_karm_core_kc_linebuf]
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    jne .L154
    mov rax, 0
    jmp .__ret_153
    jmp .L155
.L154:
.L155:
    mov rcx, rbx
    sub rsp, 32
    call kc_getword
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_word_to_mnem
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 58
    jne .L156
    sub rsp, 32
    call kc_define_label
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    jne .L158
    mov rax, 0
    jmp .__ret_153
    jmp .L159
.L158:
.L159:
    mov rcx, rbx
    sub rsp, 32
    call kc_getword
    add rsp, 32
    mov rbx, rax
    jmp .L157
.L156:
    mov rcx, rbx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_peek_datadir
    add rsp, 32
    cmp rax, 0
    je .L160
    sub rsp, 32
    call kc_define_label
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_getword
    add rsp, 32
    mov rbx, rax
    jmp .L161
.L160:
.L161:
.L157:
    sub rsp, 32
    call kc_word_to_mnem
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov [rel __g_karm_core_kc_rest], rax
    mov rcx, rbx
    sub rsp, 32
    call kc_split
    add rsp, 32
    sub rsp, 32
    call kc_dispatch
    add rsp, 32
    jmp .__ret_153
.__ret_153:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_peek_datadir:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    lea rax, [rel __g_karm_core_kc_tmp]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L163:
    mov rax, 1
    test rax, rax
    jz .L164
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L170
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L170
    mov rax, 0
    jmp .L171
.L170:
    mov rax, 1
.L171:
    test rax, rax
    jnz .L168
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L168
    mov rax, 0
    jmp .L169
.L168:
    mov rax, 1
.L169:
    test rax, rax
    jz .L166
    jmp .L164
    jmp .L167
.L166:
.L167:
    cmp r12, 16
    jl .L172
    mov rax, 0
    jmp .__ret_162
    jmp .L173
.L172:
.L173:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r12, 1
.L165:
    jmp .L163
.L164:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str182: db 100,98,0
section .text
    lea rax, [rel .str182]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L180
    mov rax, r13
    push rax
section .data
.str183: db 100,119,0
section .text
    lea rax, [rel .str183]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L180
    mov rax, 0
    jmp .L181
.L180:
    mov rax, 1
.L181:
    test rax, rax
    jnz .L178
    mov rax, r13
    push rax
section .data
.str184: db 100,100,0
section .text
    lea rax, [rel .str184]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L178
    mov rax, 0
    jmp .L179
.L178:
    mov rax, 1
.L179:
    test rax, rax
    jnz .L176
    mov rax, r13
    push rax
section .data
.str185: db 100,113,0
section .text
    lea rax, [rel .str185]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L176
    mov rax, 0
    jmp .L177
.L176:
    mov rax, 1
.L177:
    test rax, rax
    jz .L174
    mov rax, 1
    jmp .__ret_162
    jmp .L175
.L174:
.L175:
    mov rax, r13
    push rax
section .data
.str194: db 114,101,115,98,0
section .text
    lea rax, [rel .str194]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L192
    mov rax, r13
    push rax
section .data
.str195: db 114,101,115,119,0
section .text
    lea rax, [rel .str195]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L192
    mov rax, 0
    jmp .L193
.L192:
    mov rax, 1
.L193:
    test rax, rax
    jnz .L190
    mov rax, r13
    push rax
section .data
.str196: db 114,101,115,100,0
section .text
    lea rax, [rel .str196]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L190
    mov rax, 0
    jmp .L191
.L190:
    mov rax, 1
.L191:
    test rax, rax
    jnz .L188
    mov rax, r13
    push rax
section .data
.str197: db 114,101,115,113,0
section .text
    lea rax, [rel .str197]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L188
    mov rax, 0
    jmp .L189
.L188:
    mov rax, 1
.L189:
    test rax, rax
    jz .L186
    mov rax, 1
    jmp .__ret_162
    jmp .L187
.L186:
.L187:
    mov rax, r13
    push rax
section .data
.str202: db 101,113,117,0
section .text
    lea rax, [rel .str202]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L200
    mov rax, r13
    push rax
section .data
.str203: db 116,105,109,101,115,0
section .text
    lea rax, [rel .str203]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L200
    mov rax, 0
    jmp .L201
.L200:
    mov rax, 1
.L201:
    test rax, rax
    jz .L198
    mov rax, 1
    jmp .__ret_162
    jmp .L199
.L198:
.L199:
    mov rax, 0
    jmp .__ret_162
.__ret_162:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_streq:
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
.L205:
    mov rax, 1
    test rax, rax
    jz .L206
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L208
    mov rax, 0
    jmp .__ret_204
    jmp .L209
.L208:
.L209:
    cmp rbx, 0
    jne .L210
    mov rax, 1
    jmp .__ret_204
    jmp .L211
.L210:
.L211:
    add r12, 1
.L207:
    jmp .L205
.L206:
    mov rax, 0
    jmp .__ret_204
.__ret_204:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_split:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_ops]
    mov [rbp-16], rax
    mov rax, 0
    mov r15, rax
.L213:
    cmp r15, 6
    jge .L214
    mov rax, r15
    mov rcx, 256
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-16]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r15, 1
.L215:
    jmp .L213
.L214:
    mov rax, 0
    mov [rel __g_karm_core_kc_nops_n], rax
    mov rcx, rbx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    jne .L216
    mov rax, 0
    jmp .__ret_212
    jmp .L217
.L216:
.L217:
    mov rax, 0
    mov r15, rax
.L218:
    mov rax, 1
    test rax, rax
    jz .L219
    cmp r15, 6
    jl .L221
    mov rax, 7
    mov [rel __g_karm_core_kc_nops_n], rax
    mov rax, 0
    jmp .__ret_212
    jmp .L222
.L221:
.L222:
    mov rax, r15
    mov rcx, 256
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-16]
    add rax, rcx
    mov [rbp-40], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov [rbp-72], rax
.L223:
    mov rax, [rbp-72]
    cmp rax, 0
    jne .L224
    mov rcx, r14
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L226
    mov rcx, [rbp-40]
    mov rdx, r13
    sub rsp, 32
    call kc_finish
    add rsp, 32
    mov rax, r15
    add rax, 1
    mov [rel __g_karm_core_kc_nops_n], rax
    mov rax, 0
    jmp .__ret_212
    jmp .L227
.L226:
.L227:
    mov rax, [rbp-56]
    cmp rax, 0
    je .L228
    mov rax, rbx
    mov rcx, [rbp-56]
    cmp rax, rcx
    jne .L230
    mov rax, 0
    mov [rbp-56], rax
    jmp .L231
.L230:
.L231:
    jmp .L229
.L228:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L234
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
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
    mov rax, rbx
    mov [rbp-56], rax
    jmp .L233
.L232:
    cmp rbx, 91
    jne .L236
    add r12, 1
    jmp .L237
.L236:
    cmp rbx, 93
    jne .L238
    sub r12, 1
    jmp .L239
.L238:
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L242
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L242
    mov rax, 1
    jmp .L243
.L242:
    mov rax, 0
.L243:
    test rax, rax
    jz .L240
    mov rax, 1
    mov [rbp-72], rax
    jmp .L241
.L240:
.L241:
.L239:
.L237:
.L233:
.L229:
    mov rax, [rbp-72]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L246
    mov rax, r13
    mov rcx, 250
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L246
    mov rax, 1
    jmp .L247
.L246:
    mov rax, 0
.L247:
    test rax, rax
    jz .L244
    mov rax, [rbp-40]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r13, 1
    jmp .L245
.L244:
.L245:
    add r14, 1
.L225:
    jmp .L223
.L224:
    mov rcx, [rbp-40]
    mov rdx, r13
    sub rsp, 32
    call kc_finish
    add rsp, 32
    add r15, 1
.L220:
    jmp .L218
.L219:
    mov rax, 0
    jmp .__ret_212
.__ret_212:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
kc_finish:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov rbx, rax
.L249:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L252
    mov rax, r12
    add rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L254
    mov rax, r12
    add rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L254
    mov rax, 0
    jmp .L255
.L254:
    mov rax, 1
.L255:
    test rax, rax
    jz .L252
    mov rax, 1
    jmp .L253
.L252:
    mov rax, 0
.L253:
    test rax, rax
    jz .L250
    sub rbx, 1
.L251:
    jmp .L249
.L250:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_248
.__ret_248:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_op:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_ops]
    push rax
    mov rax, rbx
    mov rcx, 256
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_256
.__ret_256:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_err:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rbx, rcx
    mov rax, [rel __g_karm_core_kc_err_count]
    mov r15, rax
    cmp r15, 64
    jl .L258
    mov rax, 0
    jmp .__ret_257
    jmp .L259
.L258:
.L259:
    lea rax, [rel __g_karm_core_kc_err_kind]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, rbx
    sub rsp, 32
    call kc_put
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_err_lines]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_karm_core_kc_line]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_err_mnem]
    push rax
    mov rax, r15
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    lea rax, [rel __g_karm_core_kc_mnem_buf]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L260:
    mov rax, 1
    test rax, rax
    jz .L261
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    cmp rbx, 0
    jne .L263
    jmp .L261
    jmp .L264
.L263:
.L264:
    add r12, 1
    cmp r12, 15
    jl .L265
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    jmp .L261
    jmp .L266
.L265:
.L266:
.L262:
    jmp .L260
.L261:
    mov rax, r15
    add rax, 1
    mov [rel __g_karm_core_kc_err_count], rax
    mov rax, 0
    jmp .__ret_257
.__ret_257:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kc_err2:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_karm_core_kc_pass_n]
    cmp rax, 2
    jne .L268
    mov rcx, rbx
    sub rsp, 32
    call kc_err
    add rsp, 32
    jmp .__ret_267
    jmp .L269
.L268:
.L269:
    mov rax, 0
    jmp .__ret_267
.__ret_267:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_bad:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 2
    sub rsp, 32
    call kc_err2
    add rsp, 32
    jmp .__ret_270
.__ret_270:
    mov rsp, rbp
    pop rbp
    ret
kc_range:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    jmp .__ret_271
.__ret_271:
    mov rsp, rbp
    pop rbp
    ret
kc_reset_labels:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, 0
    mov [rel __g_karm_core_kc_lb_count], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_lb_pool_len], rax
    lea rax, [rel __g_karm_core_kc_lb_hash]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L273:
    cmp rbx, 524288
    jge .L274
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p64
    add rsp, 32
    add rbx, 8
.L275:
    jmp .L273
.L274:
    mov rax, 0
    jmp .__ret_272
.__ret_272:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kc_hash:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 2166136261
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L277:
    cmp rbx, r13
    jge .L278
    mov rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rcx, 16777619
    imul rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    add rbx, 1
.L279:
    jmp .L277
.L278:
    mov rax, r12
    push rax
    mov rax, [rel __g_karm_core_KA_HASH_MASK]
    mov rcx, rax
    pop rax
    and rax, rcx
    jmp .__ret_276
.__ret_276:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_find_exact:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r15, rcx
    mov r14, rdx
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call kc_hash
    add rsp, 32
    mov r13, rax
.L281:
    mov rax, 1
    test rax, rax
    jz .L282
    lea rax, [rel __g_karm_core_kc_lb_hash]
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
    call kc_g32
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L284
    mov rax, 1
    neg rax
    jmp .__ret_280
    jmp .L285
.L284:
.L285:
    mov rax, rbx
    sub rax, 1
    mov r12, rax
    lea rax, [rel __g_karm_core_kc_lb_nlen]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call kc_at
    add rsp, 32
    cmp rax, r14
    jne .L286
    lea rax, [rel __g_karm_core_kc_lb_pool]
    push rax
    lea rax, [rel __g_karm_core_kc_lb_noff]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call kc_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
.L288:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L291
    mov rax, [rbp-48]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L291
    mov rax, 1
    jmp .L292
.L291:
    mov rax, 0
.L292:
    test rax, rax
    jz .L289
    add rbx, 1
.L290:
    jmp .L288
.L289:
    cmp rbx, r14
    jl .L293
    mov rax, r12
    jmp .__ret_280
    jmp .L294
.L293:
.L294:
    jmp .L287
.L286:
.L287:
    mov rax, r13
    add rax, 1
    push rax
    mov rax, [rel __g_karm_core_KA_HASH_MASK]
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r13, rax
.L283:
    jmp .L281
.L282:
    mov rax, 1
    neg rax
    jmp .__ret_280
.__ret_280:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
kc_add_label:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov rax, [rel __g_karm_core_kc_lb_count]
    mov r14, rax
    mov rax, r14
    push rax
    mov rax, [rel __g_karm_core_KA_LBL_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L296
    mov rax, 1
    neg rax
    jmp .__ret_295
    jmp .L297
.L296:
.L297:
    mov rax, [rel __g_karm_core_kc_lb_pool_len]
    mov r13, rax
    lea rax, [rel __g_karm_core_kc_lb_noff]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r13
    sub rsp, 32
    call kc_put
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_lb_nlen]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r15
    sub rsp, 32
    call kc_put
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_lb_pool]
    add rax, r13
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L298:
    cmp rbx, r15
    jge .L299
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, [rbp-8]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add rbx, 1
.L300:
    jmp .L298
.L299:
    mov rax, r12
    add rax, r15
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, r13
    add rax, r15
    add rax, 1
    mov [rel __g_karm_core_kc_lb_pool_len], rax
    mov rcx, [rbp-8]
    mov rdx, r15
    sub rsp, 32
    call kc_hash
    add rsp, 32
    mov rbx, rax
.L301:
    lea rax, [rel __g_karm_core_kc_lb_hash]
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
    call kc_g32
    add rsp, 32
    cmp rax, 0
    je .L302
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, [rel __g_karm_core_KA_HASH_MASK]
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
.L303:
    jmp .L301
.L302:
    lea rax, [rel __g_karm_core_kc_lb_hash]
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p32
    add rsp, 32
    mov rax, r14
    add rax, 1
    mov [rel __g_karm_core_kc_lb_count], rax
    mov rax, r14
    jmp .__ret_295
.__ret_295:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
kc_fullname:
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
    lea rax, [rel __g_karm_core_kc_name]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 46
    jne .L305
    lea rax, [rel __g_karm_core_kc_last]
    mov rbx, rax
.L307:
    mov rax, r12
    push rax
    mov rax, [rel __g_karm_core_kc_lastlen]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L308
    mov rax, r13
    add rax, r12
    push rax
    mov rax, rbx
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r12, 1
.L309:
    jmp .L307
.L308:
    jmp .L306
.L305:
.L306:
    mov rax, 0
    mov rbx, rax
.L310:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L313
    mov rax, r12
    mov rcx, 500
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L313
    mov rax, 1
    jmp .L314
.L313:
    mov rax, 0
.L314:
    test rax, rax
    jz .L311
    mov rax, r13
    add rax, r12
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r12, 1
    add rbx, 1
.L312:
    jmp .L310
.L311:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, r12
    jmp .__ret_304
.__ret_304:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kc_define_label:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    lea rax, [rel __g_karm_core_kc_word]
    mov r14, rax
    mov rax, [rel __g_karm_core_kc_wordlen]
    mov r13, rax
    cmp r13, 0
    jne .L316
    mov rax, 0
    jmp .__ret_315
    jmp .L317
.L316:
.L317:
    mov rcx, r14
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 46
    je .L318
    lea rax, [rel __g_karm_core_kc_last]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L320:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L323
    mov rax, rbx
    mov rcx, 250
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L323
    mov rax, 1
    jmp .L324
.L323:
    mov rax, 0
.L324:
    test rax, rax
    jz .L321
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add rbx, 1
.L322:
    jmp .L320
.L321:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, rbx
    mov [rel __g_karm_core_kc_lastlen], rax
    jmp .L319
.L318:
.L319:
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call kc_fullname
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_karm_core_kc_name]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call kc_find_exact
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_pass_n]
    cmp rax, 1
    je .L325
    mov rax, rbx
    mov [rel __g_karm_core_kc_deflbl], rax
    mov rax, 0
    jmp .__ret_315
    jmp .L326
.L325:
.L326:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L327
    mov rcx, 5
    sub rsp, 32
    call kc_err
    add rsp, 32
    jmp .__ret_315
    jmp .L328
.L327:
.L328:
    lea rax, [rel __g_karm_core_kc_name]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call kc_add_label
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L329
    mov rax, 0
    jmp .__ret_315
    jmp .L330
.L329:
.L330:
    mov rax, rbx
    mov [rel __g_karm_core_kc_deflbl], rax
    lea rax, [rel __g_karm_core_kc_lb_sec]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_karm_core_kc_sec]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_lb_val]
    push rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_cur_off
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_315
.__ret_315:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
kc_cur_off:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 0
    jne .L332
    mov rax, [rel __g_karm_core_kc_code_len]
    jmp .__ret_331
    jmp .L333
.L332:
.L333:
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 1
    jne .L334
    mov rax, [rel __g_karm_core_kc_data_len]
    jmp .__ret_331
    jmp .L335
.L334:
.L335:
    mov rax, [rel __g_karm_core_kc_bss_len]
    jmp .__ret_331
.__ret_331:
    mov rsp, rbp
    pop rbp
    ret
kc_label_addr:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_lb_val]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_at
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_karm_core_kc_lb_sec]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 3
    jne .L337
    mov rax, r12
    jmp .__ret_336
    jmp .L338
.L337:
.L338:
    mov rax, r12
    push rax
    mov rax, [rel __g_karm_core_kc_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    cmp rbx, 0
    jne .L339
    mov rax, r12
    jmp .__ret_336
    jmp .L340
.L339:
.L340:
    mov rax, r12
    push rax
    mov rax, [rel __g_karm_core_kc_final_code]
    push rax
    pop rcx
    sub rsp, 32
    call kc_align_code
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    cmp rbx, 1
    jne .L341
    mov rax, r12
    jmp .__ret_336
    jmp .L342
.L341:
.L342:
    mov rax, r12
    push rax
    mov rax, [rel __g_karm_core_kc_final_data]
    push rax
    pop rcx
    sub rsp, 32
    call kc_align
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_336
.__ret_336:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_pc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call kc_cur_off
    add rsp, 32
    push rax
    mov rax, [rel __g_karm_core_kc_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 0
    jne .L344
    mov rax, rbx
    jmp .__ret_343
    jmp .L345
.L344:
.L345:
    mov rax, rbx
    push rax
    mov rax, [rel __g_karm_core_kc_final_code]
    push rax
    pop rcx
    sub rsp, 32
    call kc_align_code
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 1
    jne .L346
    mov rax, rbx
    jmp .__ret_343
    jmp .L347
.L346:
.L347:
    mov rax, rbx
    push rax
    mov rax, [rel __g_karm_core_kc_final_data]
    push rax
    pop rcx
    sub rsp, 32
    call kc_align
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_343
.__ret_343:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_emit32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 0
    jne .L349
    lea rax, [rel __g_karm_core_kc_code]
    push rax
    mov rax, [rel __g_karm_core_kc_code_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p32
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_code_len]
    add rax, 4
    mov [rel __g_karm_core_kc_code_len], rax
    jmp .L350
.L349:
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 1
    jne .L351
    lea rax, [rel __g_karm_core_kc_data]
    push rax
    mov rax, [rel __g_karm_core_kc_data_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p32
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_data_len]
    add rax, 4
    mov [rel __g_karm_core_kc_data_len], rax
    jmp .L352
.L351:
    mov rax, [rel __g_karm_core_kc_bss_len]
    add rax, 4
    mov [rel __g_karm_core_kc_bss_len], rax
.L352:
.L350:
    mov rax, 0
    jmp .__ret_348
.__ret_348:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_emit8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 0
    jne .L354
    lea rax, [rel __g_karm_core_kc_code]
    push rax
    mov rax, [rel __g_karm_core_kc_code_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_code_len]
    add rax, 1
    mov [rel __g_karm_core_kc_code_len], rax
    jmp .L355
.L354:
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 1
    jne .L356
    lea rax, [rel __g_karm_core_kc_data]
    push rax
    mov rax, [rel __g_karm_core_kc_data_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_data_len]
    add rax, 1
    mov [rel __g_karm_core_kc_data_len], rax
    jmp .L357
.L356:
    mov rax, [rel __g_karm_core_kc_bss_len]
    add rax, 1
    mov [rel __g_karm_core_kc_bss_len], rax
.L357:
.L355:
    mov rax, 0
    jmp .__ret_353
.__ret_353:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_emit_n:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
.L359:
    cmp rbx, 0
    jle .L360
    mov rax, r12
    and rax, 255
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit8
    add rsp, 32
    mov rax, r12
    shr rax, 8
    mov r12, rax
    sub rbx, 1
.L361:
    jmp .L359
.L360:
    mov rax, 0
    jmp .__ret_358
.__ret_358:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r12, rcx
    mov rax, 0
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 115
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L367
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 112
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L367
    mov rax, 1
    jmp .L368
.L367:
    mov rax, 0
.L368:
    test rax, rax
    jz .L365
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L365
    mov rax, 1
    jmp .L366
.L365:
    mov rax, 0
.L366:
    test rax, rax
    jz .L363
    mov rax, 31
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, 5
    jmp .__ret_362
    jmp .L364
.L363:
.L364:
    cmp rbx, 102
    jne .L369
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 112
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L373
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L373
    mov rax, 1
    jmp .L374
.L373:
    mov rax, 0
.L374:
    test rax, rax
    jz .L371
    mov rax, 29
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, 1
    jmp .__ret_362
    jmp .L372
.L371:
.L372:
    mov rax, 0
    jmp .__ret_362
    jmp .L370
.L369:
.L370:
    cmp rbx, 108
    jne .L375
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 114
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L379
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L379
    mov rax, 1
    jmp .L380
.L379:
    mov rax, 0
.L380:
    test rax, rax
    jz .L377
    mov rax, 30
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, 1
    jmp .__ret_362
    jmp .L378
.L377:
.L378:
    mov rax, 0
    jmp .__ret_362
    jmp .L376
.L375:
.L376:
    cmp rbx, 118
    jne .L381
    mov rcx, r12
    sub rsp, 32
    call kc_reg_vec
    add rsp, 32
    jmp .__ret_362
    jmp .L382
.L381:
.L382:
    mov rax, 0
    mov r14, rax
    cmp rbx, 120
    jne .L383
    mov rax, 1
    mov r14, rax
    jmp .L384
.L383:
.L384:
    cmp rbx, 119
    jne .L385
    mov rax, 2
    mov r14, rax
    jmp .L386
.L385:
.L386:
    cmp rbx, 100
    jne .L387
    mov rax, 3
    mov r14, rax
    jmp .L388
.L387:
.L388:
    cmp rbx, 115
    jne .L389
    mov rax, 4
    mov r14, rax
    jmp .L390
.L389:
.L390:
    cmp rbx, 113
    jne .L391
    mov rax, 6
    mov r14, rax
    jmp .L392
.L391:
.L392:
    cmp r14, 0
    jne .L393
    mov rax, 0
    jmp .__ret_362
    jmp .L394
.L393:
.L394:
    mov rax, r12
    add rax, 1
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 122
    jne .L395
    mov rax, r14
    mov rcx, 2
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L401
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 114
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L401
    mov rax, 0
    jmp .L402
.L401:
    mov rax, 1
.L402:
    test rax, rax
    jnz .L399
    mov rax, r13
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L399
    mov rax, 0
    jmp .L400
.L399:
    mov rax, 1
.L400:
    test rax, rax
    jz .L397
    mov rax, 0
    jmp .__ret_362
    jmp .L398
.L397:
.L398:
    mov rax, 31
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, r14
    jmp .__ret_362
    jmp .L396
.L395:
.L396:
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    sub rax, 48
    mov r12, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L405
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L405
    mov rax, 0
    jmp .L406
.L405:
    mov rax, 1
.L406:
    test rax, rax
    jz .L403
    mov rax, 0
    jmp .__ret_362
    jmp .L404
.L403:
.L404:
    mov rax, r12
    mov rbx, rax
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L407
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    sub rax, 48
    mov r12, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L411
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L411
    mov rax, 0
    jmp .L412
.L411:
    mov rax, 1
.L412:
    test rax, rax
    jz .L409
    mov rax, 0
    jmp .__ret_362
    jmp .L410
.L409:
.L410:
    mov rax, rbx
    mov rcx, 10
    imul rax, rcx
    add rax, r12
    mov rbx, rax
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L413
    mov rax, 0
    jmp .__ret_362
    jmp .L414
.L413:
.L414:
    jmp .L408
.L407:
.L408:
    mov rax, rbx
    mov rcx, 31
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L417
    mov rax, rbx
    mov rcx, 31
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L419
    mov rax, r14
    mov rcx, 2
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L419
    mov rax, 1
    jmp .L420
.L419:
    mov rax, 0
.L420:
    test rax, rax
    jnz .L417
    mov rax, 0
    jmp .L418
.L417:
    mov rax, 1
.L418:
    test rax, rax
    jz .L415
    mov rax, 0
    jmp .__ret_362
    jmp .L416
.L415:
.L416:
    mov rax, rbx
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, r14
    jmp .__ret_362
.__ret_362:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kc_reg_vec:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rbx, rcx
    mov rax, rbx
    add rax, 1
    mov r15, rax
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    sub rax, 48
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L424
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L424
    mov rax, 0
    jmp .L425
.L424:
    mov rax, 1
.L425:
    test rax, rax
    jz .L422
    mov rax, 0
    jmp .__ret_421
    jmp .L423
.L422:
.L423:
    mov rax, rbx
    mov r14, rax
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 46
    je .L426
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    sub rax, 48
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L430
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L430
    mov rax, 0
    jmp .L431
.L430:
    mov rax, 1
.L431:
    test rax, rax
    jz .L428
    mov rax, 0
    jmp .__ret_421
    jmp .L429
.L428:
.L429:
    mov rax, r14
    mov rcx, 10
    imul rax, rcx
    add rax, rbx
    mov r14, rax
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 46
    je .L432
    mov rax, 0
    jmp .__ret_421
    jmp .L433
.L432:
.L433:
    jmp .L427
.L426:
.L427:
    cmp r14, 31
    jle .L434
    mov rax, 0
    jmp .__ret_421
    jmp .L435
.L434:
.L435:
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r13, rax
    mov rax, r15
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r12, rax
    mov rax, r15
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp r13, 49
    jne .L436
    mov rax, r12
    mov rcx, 54
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L442
    mov rax, rbx
    mov rcx, 98
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
    mov rax, r15
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L440
    mov rax, 1
    jmp .L441
.L440:
    mov rax, 0
.L441:
    test rax, rax
    jz .L438
    mov rax, r14
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, 7
    jmp .__ret_421
    jmp .L439
.L438:
.L439:
    mov rax, 0
    jmp .__ret_421
    jmp .L437
.L436:
.L437:
    cmp r13, 52
    jne .L444
    mov rax, r12
    mov rcx, 115
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L448
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L448
    mov rax, 1
    jmp .L449
.L448:
    mov rax, 0
.L449:
    test rax, rax
    jz .L446
    mov rax, r14
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, 9
    jmp .__ret_421
    jmp .L447
.L446:
.L447:
    mov rax, 0
    jmp .__ret_421
    jmp .L445
.L444:
.L445:
    mov rax, r13
    mov rcx, 50
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L454
    mov rax, r12
    mov rcx, 100
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L454
    mov rax, 1
    jmp .L455
.L454:
    mov rax, 0
.L455:
    test rax, rax
    jz .L452
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L452
    mov rax, 1
    jmp .L453
.L452:
    mov rax, 0
.L453:
    test rax, rax
    jz .L450
    mov rax, r14
    mov [rel __g_karm_core_kc_rnum_v], rax
    mov rax, 8
    jmp .__ret_421
    jmp .L451
.L450:
.L451:
    mov rax, 0
    jmp .__ret_421
.__ret_421:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
kc_opreg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_reg
    add rsp, 32
    jmp .__ret_456
.__ret_456:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_cond:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r14, rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r13, rax
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L458
    mov rax, 1
    neg rax
    jmp .__ret_457
    jmp .L459
.L458:
.L459:
    mov rax, r14
    mov rcx, 104
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L462
    mov rax, r13
    mov rcx, 115
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L462
    mov rax, 1
    jmp .L463
.L462:
    mov rax, 0
.L463:
    test rax, rax
    jz .L460
    mov rax, 2
    jmp .__ret_457
    jmp .L461
.L460:
.L461:
    mov rax, r14
    mov rcx, 108
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L466
    mov rax, r13
    mov rcx, 111
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L466
    mov rax, 1
    jmp .L467
.L466:
    mov rax, 0
.L467:
    test rax, rax
    jz .L464
    mov rax, 3
    jmp .__ret_457
    jmp .L465
.L464:
.L465:
section .data
.str468: db 101,113,110,101,99,115,99,99,109,105,112,108,118,115,118,99,104,105,108,115,103,101,108,116,103,116,108,101,97,108,110,118,0
section .text
    lea rax, [rel .str468]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L469:
    cmp rbx, 16
    jge .L470
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, r14
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L474
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, r13
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
    mov rax, rbx
    jmp .__ret_457
    jmp .L473
.L472:
.L473:
    add rbx, 1
.L471:
    jmp .L469
.L470:
    mov rax, 1
    neg rax
    jmp .__ret_457
.__ret_457:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kc_shiftop:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov rax, 0
    mov [rel __g_karm_core_kc_shamt_v], rax
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r14, rax
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r13, rax
    mov rax, r15
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, 1
    neg rax
    mov r12, rax
    mov rax, r14
    mov rcx, 108
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L481
    mov rax, r13
    mov rcx, 115
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L481
    mov rax, 1
    jmp .L482
.L481:
    mov rax, 0
.L482:
    test rax, rax
    jz .L479
    mov rax, rbx
    mov rcx, 108
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L479
    mov rax, 1
    jmp .L480
.L479:
    mov rax, 0
.L480:
    test rax, rax
    jz .L477
    mov rax, 0
    mov r12, rax
    jmp .L478
.L477:
    mov rax, r14
    mov rcx, 108
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L487
    mov rax, r13
    mov rcx, 115
    cmp rax, rcx
    sete al
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
    mov rax, rbx
    mov rcx, 114
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L485
    mov rax, 1
    jmp .L486
.L485:
    mov rax, 0
.L486:
    test rax, rax
    jz .L483
    mov rax, 1
    mov r12, rax
    jmp .L484
.L483:
    mov rax, r14
    mov rcx, 97
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L493
    mov rax, r13
    mov rcx, 115
    cmp rax, rcx
    sete al
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
    mov rax, rbx
    mov rcx, 114
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L491
    mov rax, 1
    jmp .L492
.L491:
    mov rax, 0
.L492:
    test rax, rax
    jz .L489
    mov rax, 2
    mov r12, rax
    jmp .L490
.L489:
    mov rax, r14
    mov rcx, 114
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L499
    mov rax, r13
    mov rcx, 111
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L499
    mov rax, 1
    jmp .L500
.L499:
    mov rax, 0
.L500:
    test rax, rax
    jz .L497
    mov rax, rbx
    mov rcx, 114
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L497
    mov rax, 1
    jmp .L498
.L497:
    mov rax, 0
.L498:
    test rax, rax
    jz .L495
    mov rax, 3
    mov r12, rax
    jmp .L496
.L495:
.L496:
.L490:
.L484:
.L478:
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L501
    mov rax, 1
    neg rax
    jmp .__ret_476
    jmp .L502
.L501:
.L502:
    mov rax, r15
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L503
    mov rax, 1
    neg rax
    jmp .__ret_476
    jmp .L504
.L503:
.L504:
    mov rax, rbx
    mov [rel __g_karm_core_kc_shamt_v], rax
    mov rax, r12
    jmp .__ret_476
.__ret_476:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kc_eval:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_everr], rax
    sub rsp, 32
    call kc_expr
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L506
    mov rax, 1
    mov [rel __g_karm_core_kc_everr], rax
    jmp .L507
.L506:
.L507:
    mov rax, 0
    mov [rel __g_karm_core_kc_evok_f], rax
    mov rax, [rel __g_karm_core_kc_everr]
    cmp rax, 0
    jne .L508
    mov rax, 1
    mov [rel __g_karm_core_kc_evok_f], rax
    jmp .L509
.L508:
.L509:
    mov rax, rbx
    jmp .__ret_505
.__ret_505:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_flip:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    push rax
    mov rax, [rel __g_karm_core_kc_rsign]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_karm_core_kc_rsign], rax
    mov rax, 0
    jmp .__ret_510
.__ret_510:
    mov rsp, rbp
    pop rbp
    ret
kc_expr:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    sub rsp, 32
    call kc_term
    add rsp, 32
    mov r12, rax
.L512:
    mov rax, 1
    test rax, rax
    jz .L513
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 43
    jne .L515
    mov rax, [rel __g_karm_core_kc_ep]
    add rax, 1
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, r12
    push rax
    sub rsp, 32
    call kc_term
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L516
.L515:
    cmp rbx, 45
    jne .L517
    mov rax, [rel __g_karm_core_kc_ep]
    add rax, 1
    mov [rel __g_karm_core_kc_ep], rax
    sub rsp, 32
    call kc_flip
    add rsp, 32
    sub rsp, 32
    call kc_term
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_flip
    add rsp, 32
    sub r12, rbx
    jmp .L518
.L517:
    mov rax, r12
    jmp .__ret_511
.L518:
.L516:
.L514:
    jmp .L512
.L513:
    mov rax, r12
    jmp .__ret_511
.__ret_511:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_term:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call kc_factor
    add rsp, 32
    mov rbx, rax
.L520:
    mov rax, 1
    test rax, rax
    jz .L521
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 42
    je .L523
    mov rax, rbx
    jmp .__ret_519
    jmp .L524
.L523:
.L524:
    mov rax, [rel __g_karm_core_kc_ep]
    add rax, 1
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_factor
    add rsp, 32
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rbx, rax
.L522:
    jmp .L520
.L521:
    mov rax, rbx
    jmp .__ret_519
.__ret_519:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_symchar:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 95
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L530
    mov rax, rbx
    mov rcx, 46
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L530
    mov rax, 0
    jmp .L531
.L530:
    mov rax, 1
.L531:
    test rax, rax
    jnz .L528
    mov rax, rbx
    mov rcx, 36
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L528
    mov rax, 0
    jmp .L529
.L528:
    mov rax, 1
.L529:
    test rax, rax
    jz .L526
    mov rax, 1
    jmp .__ret_525
    jmp .L527
.L526:
.L527:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L538
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L538
    mov rax, 1
    jmp .L539
.L538:
    mov rax, 0
.L539:
    test rax, rax
    jnz .L536
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L540
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L540
    mov rax, 1
    jmp .L541
.L540:
    mov rax, 0
.L541:
    test rax, rax
    jnz .L536
    mov rax, 0
    jmp .L537
.L536:
    mov rax, 1
.L537:
    test rax, rax
    jnz .L534
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L542
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L542
    mov rax, 1
    jmp .L543
.L542:
    mov rax, 0
.L543:
    test rax, rax
    jnz .L534
    mov rax, 0
    jmp .L535
.L534:
    mov rax, 1
.L535:
    test rax, rax
    jz .L532
    mov rax, 1
    jmp .__ret_525
    jmp .L533
.L532:
.L533:
    mov rax, 0
    jmp .__ret_525
.__ret_525:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_factor:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 35
    jne .L545
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r12, rax
    jmp .L546
.L545:
.L546:
    mov rax, r12
    mov [rel __g_karm_core_kc_ep], rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 45
    jne .L547
    mov rax, [rel __g_karm_core_kc_ep]
    add rax, 1
    mov [rel __g_karm_core_kc_ep], rax
    sub rsp, 32
    call kc_flip
    add rsp, 32
    sub rsp, 32
    call kc_factor
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_flip
    add rsp, 32
    mov rax, 0
    sub rax, rbx
    jmp .__ret_544
    jmp .L548
.L547:
.L548:
    cmp rbx, 40
    jne .L549
    mov rax, [rel __g_karm_core_kc_ep]
    add rax, 1
    mov [rel __g_karm_core_kc_ep], rax
    sub rsp, 32
    call kc_expr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_karm_core_kc_ep]
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 41
    je .L551
    mov rax, 1
    mov [rel __g_karm_core_kc_everr], rax
    mov rax, 0
    jmp .__ret_544
    jmp .L552
.L551:
.L552:
    mov rax, rbx
    add rax, 1
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, r12
    jmp .__ret_544
    jmp .L550
.L549:
.L550:
    cmp rbx, 39
    jne .L553
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 39
    je .L555
    mov rax, 1
    mov [rel __g_karm_core_kc_everr], rax
    mov rax, 0
    jmp .__ret_544
    jmp .L556
.L555:
.L556:
    mov rax, r12
    add rax, 3
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    jmp .__ret_544
    jmp .L554
.L553:
.L554:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L559
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L559
    mov rax, 1
    jmp .L560
.L559:
    mov rax, 0
.L560:
    test rax, rax
    jz .L557
    mov rax, 0
    mov r14, rax
    mov rax, r12
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L563
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L563
    mov rax, 1
    jmp .L564
.L563:
    mov rax, 0
.L564:
    test rax, rax
    jz .L561
    add r13, 2
.L565:
    mov rax, 1
    test rax, rax
    jz .L566
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r12, rax
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L570
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L570
    mov rax, 1
    jmp .L571
.L570:
    mov rax, 0
.L571:
    test rax, rax
    jz .L568
    mov rax, r12
    sub rax, 48
    mov rbx, rax
    jmp .L569
.L568:
    mov rax, r12
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L574
    mov rax, r12
    mov rcx, 102
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L574
    mov rax, 1
    jmp .L575
.L574:
    mov rax, 0
.L575:
    test rax, rax
    jz .L572
    mov rax, r12
    sub rax, 87
    mov rbx, rax
    jmp .L573
.L572:
    mov rax, r12
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L578
    mov rax, r12
    mov rcx, 70
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L578
    mov rax, 1
    jmp .L579
.L578:
    mov rax, 0
.L579:
    test rax, rax
    jz .L576
    mov rax, r12
    sub rax, 55
    mov rbx, rax
    jmp .L577
.L576:
.L577:
.L573:
.L569:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L580
    jmp .L566
    jmp .L581
.L580:
.L581:
    mov rax, r14
    shl rax, 4
    add rax, rbx
    mov r14, rax
    add r13, 1
.L567:
    jmp .L565
.L566:
    jmp .L562
.L561:
.L582:
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L585
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L585
    mov rax, 1
    jmp .L586
.L585:
    mov rax, 0
.L586:
    test rax, rax
    jz .L583
    mov rax, r14
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rcx, r13
    sub rsp, 32
    call kc_g8
    add rsp, 32
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    add r13, 1
.L584:
    jmp .L582
.L583:
.L562:
    mov rax, r13
    mov [rel __g_karm_core_kc_ep], rax
    mov rax, r14
    jmp .__ret_544
    jmp .L558
.L557:
.L558:
    mov rax, 0
    mov rbx, rax
.L587:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_symchar
    add rsp, 32
    cmp rax, 0
    je .L588
    add rbx, 1
.L589:
    jmp .L587
.L588:
    cmp rbx, 0
    jne .L590
    mov rax, 1
    mov [rel __g_karm_core_kc_everr], rax
    mov rax, 0
    jmp .__ret_544
    jmp .L591
.L590:
.L591:
    mov rax, r12
    add rax, rbx
    mov [rel __g_karm_core_kc_ep], rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call kc_fullname
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_karm_core_kc_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_find_exact
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L592
    mov rax, 1
    mov [rel __g_karm_core_kc_unres_f], rax
    mov rax, 0
    jmp .__ret_544
    jmp .L593
.L592:
.L593:
    lea rax, [rel __g_karm_core_kc_lb_sec]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_at
    add rsp, 32
    cmp rax, 3
    je .L594
    mov rax, [rel __g_karm_core_kc_nrel]
    push rax
    mov rax, [rel __g_karm_core_kc_rsign]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_karm_core_kc_nrel], rax
    jmp .L595
.L594:
.L595:
    mov rcx, rbx
    sub rsp, 32
    call kc_label_addr
    add rsp, 32
    jmp .__ret_544
.__ret_544:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov rsp, rbp
    pop rbp
    ret
kc_imm:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_reg
    add rsp, 32
    cmp rax, 0
    je .L597
    mov rax, 0
    mov [rel __g_karm_core_kc_evok_f], rax
    mov rax, 0
    jmp .__ret_596
    jmp .L598
.L597:
.L598:
    mov rcx, rbx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    jmp .__ret_596
.__ret_596:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_undef_check:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_unres_f]
    cmp rax, 0
    je .L600
    mov rcx, 4
    sub rsp, 32
    call kc_err2
    add rsp, 32
    jmp .L601
.L600:
.L601:
    mov rax, 0
    jmp .__ret_599
.__ret_599:
    mov rsp, rbp
    pop rbp
    ret
kc_piece:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_tmp]
    mov r13, rax
    mov rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L603:
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L608
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L608
    mov rax, 1
    jmp .L609
.L608:
    mov rax, 0
.L609:
    test rax, rax
    jz .L606
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 93
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L606
    mov rax, 1
    jmp .L607
.L606:
    mov rax, 0
.L607:
    test rax, rax
    jz .L604
    cmp rbx, 250
    jge .L610
    mov rax, r13
    add rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add rbx, 1
    jmp .L611
.L610:
.L611:
    add r12, 1
.L605:
    jmp .L603
.L604:
.L612:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L615
    mov rax, r13
    add rax, rbx
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L615
    mov rax, 1
    jmp .L616
.L615:
    mov rax, 0
.L616:
    test rax, rax
    jz .L613
    sub rbx, 1
.L614:
    jmp .L612
.L613:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, r12
    jmp .__ret_602
.__ret_602:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kc_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rbx, rcx
    mov rax, 0
    mov [rel __g_karm_core_kc_km_kind], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_km_imm], rax
    mov rax, 1
    neg rax
    mov [rel __g_karm_core_kc_km_amt], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_km_pre], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_km_ext], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_km_idxw], rax
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 91
    je .L618
    mov rax, 0
    jmp .__ret_617
    jmp .L619
.L618:
.L619:
    lea rax, [rel __g_karm_core_kc_tmp]
    mov r13, rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_piece
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call kc_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L622
    mov rax, rbx
    mov rcx, 5
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L622
    mov rax, 1
    jmp .L623
.L622:
    mov rax, 0
.L623:
    test rax, rax
    jz .L620
    mov rax, 0
    jmp .__ret_617
    jmp .L621
.L620:
.L621:
    mov rax, [rel __g_karm_core_kc_rnum_v]
    mov [rel __g_karm_core_kc_km_base], rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 93
    je .L624
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 44
    je .L626
    mov rax, 0
    jmp .__ret_617
    jmp .L627
.L626:
.L627:
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_piece
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call kc_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L630
    mov rax, rbx
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L630
    mov rax, 0
    jmp .L631
.L630:
    mov rax, 1
.L631:
    test rax, rax
    jz .L628
    cmp rbx, 2
    jne .L632
    mov rax, 1
    mov [rel __g_karm_core_kc_km_idxw], rax
    mov rax, 2
    mov [rel __g_karm_core_kc_km_ext], rax
    jmp .L633
.L632:
.L633:
    mov rax, [rel __g_karm_core_kc_rnum_v]
    mov [rel __g_karm_core_kc_km_idx], rax
    mov rax, 2
    mov [rel __g_karm_core_kc_km_kind], rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 93
    je .L634
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 44
    je .L636
    mov rax, 0
    jmp .__ret_617
    jmp .L637
.L636:
.L637:
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_piece
    add rsp, 32
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call kc_mem_ext
    add rsp, 32
    cmp rax, 0
    jne .L638
    mov rax, 0
    jmp .__ret_617
    jmp .L639
.L638:
.L639:
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 93
    je .L640
    mov rax, 0
    jmp .__ret_617
    jmp .L641
.L640:
.L641:
    jmp .L635
.L634:
.L635:
    jmp .L629
.L628:
    mov rcx, r13
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L642
    mov rax, 0
    jmp .__ret_617
    jmp .L643
.L642:
.L643:
    mov rax, rbx
    mov [rel __g_karm_core_kc_km_imm], rax
    mov rax, 1
    mov [rel __g_karm_core_kc_km_kind], rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 93
    je .L644
    mov rax, 0
    jmp .__ret_617
    jmp .L645
.L644:
.L645:
.L629:
    jmp .L625
.L624:
.L625:
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 33
    jne .L646
    mov rax, 1
    mov [rel __g_karm_core_kc_km_pre], rax
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r12, rax
    jmp .L647
.L646:
.L647:
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L648
    mov rax, 0
    jmp .__ret_617
    jmp .L649
.L648:
.L649:
    mov rax, 1
    jmp .__ret_617
.__ret_617:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kc_mem_ext:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rcx, r12
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 108
    jne .L651
    mov rcx, r12
    sub rsp, 32
    call kc_shiftop
    add rsp, 32
    cmp rax, 0
    je .L653
    mov rax, 0
    jmp .__ret_650
    jmp .L654
.L653:
.L654:
    mov rax, [rel __g_karm_core_kc_shamt_v]
    mov [rel __g_karm_core_kc_km_amt], rax
    mov rax, 1
    jmp .__ret_650
    jmp .L652
.L651:
.L652:
    cmp rbx, 115
    jne .L655
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L659
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 116
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L659
    mov rax, 0
    jmp .L660
.L659:
    mov rax, 1
.L660:
    test rax, rax
    jz .L657
    mov rax, 0
    jmp .__ret_650
    jmp .L658
.L657:
.L658:
    mov rax, 1
    mov [rel __g_karm_core_kc_km_ext], rax
    mov rax, r12
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 120
    jne .L661
    mov rax, 3
    mov [rel __g_karm_core_kc_km_ext], rax
    jmp .L662
.L661:
    mov rax, r12
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 119
    je .L663
    mov rax, 0
    jmp .__ret_650
    jmp .L664
.L663:
.L664:
.L662:
    jmp .L656
.L655:
    cmp rbx, 117
    jne .L665
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L671
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 116
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L671
    mov rax, 0
    jmp .L672
.L671:
    mov rax, 1
.L672:
    test rax, rax
    jnz .L669
    mov rax, r12
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 119
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L669
    mov rax, 0
    jmp .L670
.L669:
    mov rax, 1
.L670:
    test rax, rax
    jz .L667
    mov rax, 0
    jmp .__ret_650
    jmp .L668
.L667:
.L668:
    mov rax, 2
    mov [rel __g_karm_core_kc_km_ext], rax
    jmp .L666
.L665:
    mov rax, 0
    jmp .__ret_650
.L666:
.L656:
    mov rax, r12
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L673
    mov rax, r12
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L675
    mov rax, 0
    jmp .__ret_650
    jmp .L676
.L675:
.L676:
    mov rax, rbx
    mov [rel __g_karm_core_kc_km_amt], rax
    jmp .L674
.L673:
.L674:
    mov rax, 1
    jmp .__ret_650
.__ret_650:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_is:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_karm_core_kc_mnem_buf]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    jmp .__ret_677
.__ret_677:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_dispatch:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_karm_core_kc_unres_f], rax
section .data
.str681: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str681]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L679
    sub rsp, 32
    call kc_section
    add rsp, 32
    jmp .__ret_678
    jmp .L680
.L679:
.L680:
section .data
.str684: db 103,108,111,98,97,108,0
section .text
    lea rax, [rel .str684]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L682
    mov rax, 0
    jmp .__ret_678
    jmp .L683
.L682:
.L683:
section .data
.str687: db 101,120,116,101,114,110,0
section .text
    lea rax, [rel .str687]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L685
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_678
    jmp .L686
.L685:
.L686:
section .data
.str690: db 97,108,105,103,110,0
section .text
    lea rax, [rel .str690]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L688
    sub rsp, 32
    call kc_align_dir
    add rsp, 32
    jmp .__ret_678
    jmp .L689
.L688:
.L689:
section .data
.str693: db 100,98,0
section .text
    lea rax, [rel .str693]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L691
    mov rcx, 1
    sub rsp, 32
    call kc_data_dir
    add rsp, 32
    jmp .__ret_678
    jmp .L692
.L691:
.L692:
section .data
.str696: db 100,119,0
section .text
    lea rax, [rel .str696]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L694
    mov rcx, 2
    sub rsp, 32
    call kc_data_dir
    add rsp, 32
    jmp .__ret_678
    jmp .L695
.L694:
.L695:
section .data
.str699: db 100,100,0
section .text
    lea rax, [rel .str699]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L697
    mov rcx, 4
    sub rsp, 32
    call kc_data_dir
    add rsp, 32
    jmp .__ret_678
    jmp .L698
.L697:
.L698:
section .data
.str702: db 100,113,0
section .text
    lea rax, [rel .str702]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L700
    mov rcx, 8
    sub rsp, 32
    call kc_data_dir
    add rsp, 32
    jmp .__ret_678
    jmp .L701
.L700:
.L701:
section .data
.str705: db 114,101,115,98,0
section .text
    lea rax, [rel .str705]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L703
    mov rcx, 1
    sub rsp, 32
    call kc_res
    add rsp, 32
    jmp .__ret_678
    jmp .L704
.L703:
.L704:
section .data
.str708: db 114,101,115,119,0
section .text
    lea rax, [rel .str708]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L706
    mov rcx, 2
    sub rsp, 32
    call kc_res
    add rsp, 32
    jmp .__ret_678
    jmp .L707
.L706:
.L707:
section .data
.str711: db 114,101,115,100,0
section .text
    lea rax, [rel .str711]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L709
    mov rcx, 4
    sub rsp, 32
    call kc_res
    add rsp, 32
    jmp .__ret_678
    jmp .L710
.L709:
.L710:
section .data
.str714: db 114,101,115,113,0
section .text
    lea rax, [rel .str714]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L712
    mov rcx, 8
    sub rsp, 32
    call kc_res
    add rsp, 32
    jmp .__ret_678
    jmp .L713
.L712:
.L713:
section .data
.str717: db 101,113,117,0
section .text
    lea rax, [rel .str717]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L715
    sub rsp, 32
    call kc_equ
    add rsp, 32
    jmp .__ret_678
    jmp .L716
.L715:
.L716:
section .data
.str720: db 116,105,109,101,115,0
section .text
    lea rax, [rel .str720]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L718
    sub rsp, 32
    call kc_times
    add rsp, 32
    jmp .__ret_678
    jmp .L719
.L718:
.L719:
    sub rsp, 32
    call kc_dispatch_insn
    add rsp, 32
    jmp .__ret_678
.__ret_678:
    mov rsp, rbp
    pop rbp
    ret
kc_dispatch_insn:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str724: db 109,111,118,0
section .text
    lea rax, [rel .str724]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L722
    sub rsp, 32
    call ko_mov
    add rsp, 32
    jmp .__ret_721
    jmp .L723
.L722:
.L723:
section .data
.str727: db 109,111,118,122,0
section .text
    lea rax, [rel .str727]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L725
    mov rcx, 0x52800000
    sub rsp, 32
    call ko_movw
    add rsp, 32
    jmp .__ret_721
    jmp .L726
.L725:
.L726:
section .data
.str730: db 109,111,118,110,0
section .text
    lea rax, [rel .str730]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L728
    mov rcx, 0x12800000
    sub rsp, 32
    call ko_movw
    add rsp, 32
    jmp .__ret_721
    jmp .L729
.L728:
.L729:
section .data
.str733: db 109,111,118,107,0
section .text
    lea rax, [rel .str733]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L731
    mov rcx, 0x72800000
    sub rsp, 32
    call ko_movw
    add rsp, 32
    jmp .__ret_721
    jmp .L732
.L731:
.L732:
section .data
.str736: db 97,100,100,0
section .text
    lea rax, [rel .str736]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L734
    mov rcx, 0
    sub rsp, 32
    call ko_addsub
    add rsp, 32
    jmp .__ret_721
    jmp .L735
.L734:
.L735:
section .data
.str739: db 115,117,98,0
section .text
    lea rax, [rel .str739]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L737
    mov rcx, 1
    sub rsp, 32
    call ko_addsub
    add rsp, 32
    jmp .__ret_721
    jmp .L738
.L737:
.L738:
section .data
.str742: db 97,100,100,115,0
section .text
    lea rax, [rel .str742]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L740
    mov rcx, 2
    sub rsp, 32
    call ko_addsub
    add rsp, 32
    jmp .__ret_721
    jmp .L741
.L740:
.L741:
section .data
.str745: db 115,117,98,115,0
section .text
    lea rax, [rel .str745]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L743
    mov rcx, 3
    sub rsp, 32
    call ko_addsub
    add rsp, 32
    jmp .__ret_721
    jmp .L744
.L743:
.L744:
section .data
.str748: db 99,109,112,0
section .text
    lea rax, [rel .str748]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L746
    mov rcx, 3
    sub rsp, 32
    call ko_cmpn
    add rsp, 32
    jmp .__ret_721
    jmp .L747
.L746:
.L747:
section .data
.str751: db 99,109,110,0
section .text
    lea rax, [rel .str751]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L749
    mov rcx, 2
    sub rsp, 32
    call ko_cmpn
    add rsp, 32
    jmp .__ret_721
    jmp .L750
.L749:
.L750:
section .data
.str754: db 110,101,103,0
section .text
    lea rax, [rel .str754]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L752
    sub rsp, 32
    call ko_neg
    add rsp, 32
    jmp .__ret_721
    jmp .L753
.L752:
.L753:
section .data
.str757: db 109,117,108,0
section .text
    lea rax, [rel .str757]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L755
    mov rcx, 0x9B007C00
    sub rsp, 32
    call ko_three_op
    add rsp, 32
    jmp .__ret_721
    jmp .L756
.L755:
.L756:
section .data
.str760: db 109,97,100,100,0
section .text
    lea rax, [rel .str760]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L758
    mov rcx, 0x9B000000
    sub rsp, 32
    call ko_mfour
    add rsp, 32
    jmp .__ret_721
    jmp .L759
.L758:
.L759:
section .data
.str763: db 109,115,117,98,0
section .text
    lea rax, [rel .str763]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L761
    mov rcx, 0x9B008000
    sub rsp, 32
    call ko_mfour
    add rsp, 32
    jmp .__ret_721
    jmp .L762
.L761:
.L762:
section .data
.str766: db 115,100,105,118,0
section .text
    lea rax, [rel .str766]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L764
    mov rcx, 0x9AC00C00
    sub rsp, 32
    call ko_three_op
    add rsp, 32
    jmp .__ret_721
    jmp .L765
.L764:
.L765:
section .data
.str769: db 117,100,105,118,0
section .text
    lea rax, [rel .str769]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L767
    mov rcx, 0x9AC00800
    sub rsp, 32
    call ko_three_op
    add rsp, 32
    jmp .__ret_721
    jmp .L768
.L767:
.L768:
section .data
.str772: db 97,110,100,0
section .text
    lea rax, [rel .str772]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L770
    mov rcx, 0x8A000000
    mov rdx, 0x92000000
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L771
.L770:
.L771:
section .data
.str775: db 111,114,114,0
section .text
    lea rax, [rel .str775]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L773
    mov rcx, 0xAA000000
    mov rdx, 0xB2000000
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L774
.L773:
.L774:
section .data
.str778: db 101,111,114,0
section .text
    lea rax, [rel .str778]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L776
    mov rcx, 0xCA000000
    mov rdx, 0xD2000000
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L777
.L776:
.L777:
section .data
.str781: db 97,110,100,115,0
section .text
    lea rax, [rel .str781]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L779
    mov rcx, 0xEA000000
    mov rdx, 0xF2000000
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L780
.L779:
.L780:
section .data
.str784: db 98,105,99,0
section .text
    lea rax, [rel .str784]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L782
    mov rcx, 0x8A200000
    mov rdx, 0
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L783
.L782:
.L783:
section .data
.str787: db 111,114,110,0
section .text
    lea rax, [rel .str787]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L785
    mov rcx, 0xAA200000
    mov rdx, 0
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L786
.L785:
.L786:
section .data
.str790: db 101,111,110,0
section .text
    lea rax, [rel .str790]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L788
    mov rcx, 0xCA200000
    mov rdx, 0
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_721
    jmp .L789
.L788:
.L789:
section .data
.str793: db 116,115,116,0
section .text
    lea rax, [rel .str793]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L791
    sub rsp, 32
    call ko_tst
    add rsp, 32
    jmp .__ret_721
    jmp .L792
.L791:
.L792:
section .data
.str796: db 109,118,110,0
section .text
    lea rax, [rel .str796]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L794
    sub rsp, 32
    call ko_mvn
    add rsp, 32
    jmp .__ret_721
    jmp .L795
.L794:
.L795:
section .data
.str799: db 108,115,108,0
section .text
    lea rax, [rel .str799]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L797
    mov rcx, 0
    sub rsp, 32
    call ko_shift
    add rsp, 32
    jmp .__ret_721
    jmp .L798
.L797:
.L798:
section .data
.str802: db 108,115,114,0
section .text
    lea rax, [rel .str802]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L800
    mov rcx, 1
    sub rsp, 32
    call ko_shift
    add rsp, 32
    jmp .__ret_721
    jmp .L801
.L800:
.L801:
section .data
.str805: db 97,115,114,0
section .text
    lea rax, [rel .str805]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L803
    mov rcx, 2
    sub rsp, 32
    call ko_shift
    add rsp, 32
    jmp .__ret_721
    jmp .L804
.L803:
.L804:
section .data
.str808: db 114,111,114,0
section .text
    lea rax, [rel .str808]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L806
    mov rcx, 3
    sub rsp, 32
    call ko_shift
    add rsp, 32
    jmp .__ret_721
    jmp .L807
.L806:
.L807:
section .data
.str811: db 99,115,101,116,0
section .text
    lea rax, [rel .str811]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L809
    sub rsp, 32
    call ko_cset
    add rsp, 32
    jmp .__ret_721
    jmp .L810
.L809:
.L810:
section .data
.str814: db 99,115,101,108,0
section .text
    lea rax, [rel .str814]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L812
    mov rcx, 0x9A800000
    sub rsp, 32
    call ko_csx
    add rsp, 32
    jmp .__ret_721
    jmp .L813
.L812:
.L813:
section .data
.str817: db 99,115,105,110,99,0
section .text
    lea rax, [rel .str817]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L815
    mov rcx, 0x9A800400
    sub rsp, 32
    call ko_csx
    add rsp, 32
    jmp .__ret_721
    jmp .L816
.L815:
.L816:
section .data
.str820: db 99,115,110,101,103,0
section .text
    lea rax, [rel .str820]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L818
    mov rcx, 0xDA800400
    sub rsp, 32
    call ko_csx
    add rsp, 32
    jmp .__ret_721
    jmp .L819
.L818:
.L819:
section .data
.str823: db 115,120,116,98,0
section .text
    lea rax, [rel .str823]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L821
    mov rcx, 7
    mov rdx, 1
    sub rsp, 32
    call ko_ext
    add rsp, 32
    jmp .__ret_721
    jmp .L822
.L821:
.L822:
section .data
.str826: db 115,120,116,104,0
section .text
    lea rax, [rel .str826]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L824
    mov rcx, 15
    mov rdx, 1
    sub rsp, 32
    call ko_ext
    add rsp, 32
    jmp .__ret_721
    jmp .L825
.L824:
.L825:
section .data
.str829: db 115,120,116,119,0
section .text
    lea rax, [rel .str829]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L827
    mov rcx, 31
    mov rdx, 1
    sub rsp, 32
    call ko_ext
    add rsp, 32
    jmp .__ret_721
    jmp .L828
.L827:
.L828:
section .data
.str832: db 117,120,116,98,0
section .text
    lea rax, [rel .str832]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L830
    mov rcx, 7
    mov rdx, 0
    sub rsp, 32
    call ko_ext
    add rsp, 32
    jmp .__ret_721
    jmp .L831
.L830:
.L831:
section .data
.str835: db 117,120,116,104,0
section .text
    lea rax, [rel .str835]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L833
    mov rcx, 15
    mov rdx, 0
    sub rsp, 32
    call ko_ext
    add rsp, 32
    jmp .__ret_721
    jmp .L834
.L833:
.L834:
    sub rsp, 32
    call kc_dispatch_mem
    add rsp, 32
    jmp .__ret_721
.__ret_721:
    mov rsp, rbp
    pop rbp
    ret
kc_dispatch_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
section .data
.str839: db 108,100,114,0
section .text
    lea rax, [rel .str839]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L837
    mov rcx, 1
    mov rdx, 0
    sub rsp, 32
    call kq_ldstr
    add rsp, 32
    jmp .__ret_836
    jmp .L838
.L837:
.L838:
section .data
.str842: db 115,116,114,0
section .text
    lea rax, [rel .str842]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L840
    mov rcx, 0
    mov rdx, 0
    sub rsp, 32
    call kq_ldstr
    add rsp, 32
    jmp .__ret_836
    jmp .L841
.L840:
.L841:
section .data
.str845: db 108,100,114,98,0
section .text
    lea rax, [rel .str845]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L843
    mov rcx, 0x39400000
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L844
.L843:
.L844:
section .data
.str848: db 115,116,114,98,0
section .text
    lea rax, [rel .str848]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L846
    mov rcx, 0x39000000
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L847
.L846:
.L847:
section .data
.str851: db 108,100,114,104,0
section .text
    lea rax, [rel .str851]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L849
    mov rcx, 0x79400000
    mov rdx, 1
    mov r8, 0
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L850
.L849:
.L850:
section .data
.str854: db 115,116,114,104,0
section .text
    lea rax, [rel .str854]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L852
    mov rcx, 0x79000000
    mov rdx, 1
    mov r8, 0
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L853
.L852:
.L853:
section .data
.str857: db 108,100,114,115,98,0
section .text
    lea rax, [rel .str857]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L855
    mov rcx, 0x39800000
    mov rdx, 0
    sub rsp, 32
    call kq_ldsx
    add rsp, 32
    jmp .__ret_836
    jmp .L856
.L855:
.L856:
section .data
.str860: db 108,100,114,115,104,0
section .text
    lea rax, [rel .str860]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L858
    mov rcx, 0x79800000
    mov rdx, 1
    sub rsp, 32
    call kq_ldsx
    add rsp, 32
    jmp .__ret_836
    jmp .L859
.L858:
.L859:
section .data
.str863: db 108,100,114,115,119,0
section .text
    lea rax, [rel .str863]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L861
    sub rsp, 32
    call kq_ldrsw
    add rsp, 32
    jmp .__ret_836
    jmp .L862
.L861:
.L862:
section .data
.str866: db 108,100,117,114,0
section .text
    lea rax, [rel .str866]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L864
    mov rcx, 1
    mov rdx, 1
    sub rsp, 32
    call kq_ldstr
    add rsp, 32
    jmp .__ret_836
    jmp .L865
.L864:
.L865:
section .data
.str869: db 115,116,117,114,0
section .text
    lea rax, [rel .str869]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L867
    mov rcx, 0
    mov rdx, 1
    sub rsp, 32
    call kq_ldstr
    add rsp, 32
    jmp .__ret_836
    jmp .L868
.L867:
.L868:
section .data
.str872: db 108,100,117,114,98,0
section .text
    lea rax, [rel .str872]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L870
    mov rcx, 0x39400000
    mov rdx, 0
    mov r8, 1
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L871
.L870:
.L871:
section .data
.str875: db 115,116,117,114,98,0
section .text
    lea rax, [rel .str875]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L873
    mov rcx, 0x39000000
    mov rdx, 0
    mov r8, 1
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L874
.L873:
.L874:
section .data
.str878: db 108,100,117,114,104,0
section .text
    lea rax, [rel .str878]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L876
    mov rcx, 0x79400000
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L877
.L876:
.L877:
section .data
.str881: db 115,116,117,114,104,0
section .text
    lea rax, [rel .str881]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L879
    mov rcx, 0x79000000
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call kq_ldsz
    add rsp, 32
    jmp .__ret_836
    jmp .L880
.L879:
.L880:
section .data
.str884: db 108,100,112,0
section .text
    lea rax, [rel .str884]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L882
    mov rcx, 1
    sub rsp, 32
    call kq_pair
    add rsp, 32
    jmp .__ret_836
    jmp .L883
.L882:
.L883:
section .data
.str887: db 115,116,112,0
section .text
    lea rax, [rel .str887]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L885
    mov rcx, 0
    sub rsp, 32
    call kq_pair
    add rsp, 32
    jmp .__ret_836
    jmp .L886
.L885:
.L886:
section .data
.str890: db 108,100,120,114,0
section .text
    lea rax, [rel .str890]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L888
    mov rcx, 0xC85F7C00
    sub rsp, 32
    call kq_ldex
    add rsp, 32
    jmp .__ret_836
    jmp .L889
.L888:
.L889:
section .data
.str893: db 115,116,120,114,0
section .text
    lea rax, [rel .str893]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L891
    mov rcx, 0xC8007C00
    sub rsp, 32
    call kq_stex
    add rsp, 32
    jmp .__ret_836
    jmp .L892
.L891:
.L892:
section .data
.str896: db 108,100,97,120,114,0
section .text
    lea rax, [rel .str896]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L894
    mov rcx, 0xC85FFC00
    sub rsp, 32
    call kq_ldex
    add rsp, 32
    jmp .__ret_836
    jmp .L895
.L894:
.L895:
section .data
.str899: db 115,116,108,120,114,0
section .text
    lea rax, [rel .str899]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L897
    mov rcx, 0xC800FC00
    sub rsp, 32
    call kq_stex
    add rsp, 32
    jmp .__ret_836
    jmp .L898
.L897:
.L898:
section .data
.str902: db 98,0
section .text
    lea rax, [rel .str902]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L900
    mov rcx, 0x14000000
    sub rsp, 32
    call kq_b26
    add rsp, 32
    jmp .__ret_836
    jmp .L901
.L900:
.L901:
section .data
.str905: db 98,108,0
section .text
    lea rax, [rel .str905]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L903
    mov rcx, 0x94000000
    sub rsp, 32
    call kq_b26
    add rsp, 32
    jmp .__ret_836
    jmp .L904
.L903:
.L904:
section .data
.str908: db 99,98,122,0
section .text
    lea rax, [rel .str908]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L906
    mov rcx, 0x34000000
    sub rsp, 32
    call kq_cb
    add rsp, 32
    jmp .__ret_836
    jmp .L907
.L906:
.L907:
section .data
.str911: db 99,98,110,122,0
section .text
    lea rax, [rel .str911]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L909
    mov rcx, 0x35000000
    sub rsp, 32
    call kq_cb
    add rsp, 32
    jmp .__ret_836
    jmp .L910
.L909:
.L910:
section .data
.str914: db 98,114,0
section .text
    lea rax, [rel .str914]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L912
    mov rcx, 0xD61F0000
    sub rsp, 32
    call kq_breg
    add rsp, 32
    jmp .__ret_836
    jmp .L913
.L912:
.L913:
section .data
.str917: db 98,108,114,0
section .text
    lea rax, [rel .str917]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L915
    mov rcx, 0xD63F0000
    sub rsp, 32
    call kq_breg
    add rsp, 32
    jmp .__ret_836
    jmp .L916
.L915:
.L916:
section .data
.str920: db 114,101,116,0
section .text
    lea rax, [rel .str920]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L918
    sub rsp, 32
    call kq_ret
    add rsp, 32
    jmp .__ret_836
    jmp .L919
.L918:
.L919:
section .data
.str923: db 97,100,114,0
section .text
    lea rax, [rel .str923]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L921
    sub rsp, 32
    call kq_adr
    add rsp, 32
    jmp .__ret_836
    jmp .L922
.L921:
.L922:
section .data
.str926: db 97,100,114,112,0
section .text
    lea rax, [rel .str926]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L924
    sub rsp, 32
    call kq_adrp
    add rsp, 32
    jmp .__ret_836
    jmp .L925
.L924:
.L925:
section .data
.str929: db 97,100,114,108,0
section .text
    lea rax, [rel .str929]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L927
    sub rsp, 32
    call kq_adrl
    add rsp, 32
    jmp .__ret_836
    jmp .L928
.L927:
.L928:
section .data
.str932: db 115,118,99,0
section .text
    lea rax, [rel .str932]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L930
    sub rsp, 32
    call kq_svc
    add rsp, 32
    jmp .__ret_836
    jmp .L931
.L930:
.L931:
section .data
.str935: db 110,111,112,0
section .text
    lea rax, [rel .str935]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L933
    mov rcx, 0xD503201F
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_836
    jmp .L934
.L933:
.L934:
section .data
.str938: db 100,109,98,0
section .text
    lea rax, [rel .str938]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L936
    mov rcx, 0xD5033BBF
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_836
    jmp .L937
.L936:
.L937:
section .data
.str941: db 102,109,111,118,0
section .text
    lea rax, [rel .str941]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L939
    sub rsp, 32
    call kq_fmov
    add rsp, 32
    jmp .__ret_836
    jmp .L940
.L939:
.L940:
section .data
.str944: db 102,97,100,100,0
section .text
    lea rax, [rel .str944]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L942
    mov rcx, 0x1E602800
    mov rdx, 0x4E60D400
    sub rsp, 32
    call kq_f3
    add rsp, 32
    jmp .__ret_836
    jmp .L943
.L942:
.L943:
section .data
.str947: db 102,115,117,98,0
section .text
    lea rax, [rel .str947]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L945
    mov rcx, 0x1E603800
    mov rdx, 0x4EE0D400
    sub rsp, 32
    call kq_f3
    add rsp, 32
    jmp .__ret_836
    jmp .L946
.L945:
.L946:
section .data
.str950: db 102,109,117,108,0
section .text
    lea rax, [rel .str950]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L948
    mov rcx, 0x1E600800
    mov rdx, 0x6E60DC00
    sub rsp, 32
    call kq_f3
    add rsp, 32
    jmp .__ret_836
    jmp .L949
.L948:
.L949:
section .data
.str953: db 102,100,105,118,0
section .text
    lea rax, [rel .str953]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L951
    mov rcx, 0x1E601800
    mov rdx, 0x6E60FC00
    sub rsp, 32
    call kq_f3
    add rsp, 32
    jmp .__ret_836
    jmp .L952
.L951:
.L952:
section .data
.str956: db 102,115,113,114,116,0
section .text
    lea rax, [rel .str956]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L954
    mov rcx, 0x1E61C000
    sub rsp, 32
    call kq_f2
    add rsp, 32
    jmp .__ret_836
    jmp .L955
.L954:
.L955:
section .data
.str959: db 102,110,101,103,0
section .text
    lea rax, [rel .str959]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L957
    mov rcx, 0x1E614000
    sub rsp, 32
    call kq_f2
    add rsp, 32
    jmp .__ret_836
    jmp .L958
.L957:
.L958:
section .data
.str962: db 102,97,98,115,0
section .text
    lea rax, [rel .str962]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L960
    mov rcx, 0x1E60C000
    sub rsp, 32
    call kq_f2
    add rsp, 32
    jmp .__ret_836
    jmp .L961
.L960:
.L961:
section .data
.str965: db 102,99,109,112,0
section .text
    lea rax, [rel .str965]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L963
    sub rsp, 32
    call kq_fcmp
    add rsp, 32
    jmp .__ret_836
    jmp .L964
.L963:
.L964:
section .data
.str968: db 115,99,118,116,102,0
section .text
    lea rax, [rel .str968]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L966
    mov rcx, 0x1E220000
    mov rdx, 1
    sub rsp, 32
    call kq_cvt
    add rsp, 32
    jmp .__ret_836
    jmp .L967
.L966:
.L967:
section .data
.str971: db 117,99,118,116,102,0
section .text
    lea rax, [rel .str971]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L969
    mov rcx, 0x1E230000
    mov rdx, 1
    sub rsp, 32
    call kq_cvt
    add rsp, 32
    jmp .__ret_836
    jmp .L970
.L969:
.L970:
section .data
.str974: db 102,99,118,116,122,115,0
section .text
    lea rax, [rel .str974]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L972
    mov rcx, 0x1E380000
    mov rdx, 0
    sub rsp, 32
    call kq_cvt
    add rsp, 32
    jmp .__ret_836
    jmp .L973
.L972:
.L973:
section .data
.str977: db 102,99,118,116,122,117,0
section .text
    lea rax, [rel .str977]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L975
    mov rcx, 0x1E390000
    mov rdx, 0
    sub rsp, 32
    call kq_cvt
    add rsp, 32
    jmp .__ret_836
    jmp .L976
.L975:
.L976:
section .data
.str980: db 102,99,118,116,0
section .text
    lea rax, [rel .str980]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L978
    sub rsp, 32
    call kq_fcvt
    add rsp, 32
    jmp .__ret_836
    jmp .L979
.L978:
.L979:
section .data
.str983: db 102,99,118,116,110,115,0
section .text
    lea rax, [rel .str983]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L981
    mov rcx, 0x1E200000
    mov rdx, 0
    sub rsp, 32
    call kq_cvt
    add rsp, 32
    jmp .__ret_836
    jmp .L982
.L981:
.L982:
section .data
.str986: db 112,114,102,109,0
section .text
    lea rax, [rel .str986]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L984
    sub rsp, 32
    call kq_prfm
    add rsp, 32
    jmp .__ret_836
    jmp .L985
.L984:
.L985:
section .data
.str989: db 100,99,0
section .text
    lea rax, [rel .str989]
    push rax
    pop rcx
    sub rsp, 32
    call kc_is
    add rsp, 32
    cmp rax, 0
    je .L987
    sub rsp, 32
    call kq_dc
    add rsp, 32
    jmp .__ret_836
    jmp .L988
.L987:
.L988:
    lea rax, [rel __g_karm_core_kc_mnem_buf]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 98
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L992
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 46
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L992
    mov rax, 1
    jmp .L993
.L992:
    mov rax, 0
.L993:
    test rax, rax
    jz .L990
    sub rsp, 32
    call kq_bcond
    add rsp, 32
    jmp .__ret_836
    jmp .L991
.L990:
.L991:
    mov rcx, 1
    sub rsp, 32
    call kc_err2
    add rsp, 32
    jmp .__ret_836
.__ret_836:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_section:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str997: db 46,116,101,120,116,0
section .text
    lea rax, [rel .str997]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L995
    mov rax, 0
    mov [rel __g_karm_core_kc_sec], rax
    mov rax, 0
    jmp .__ret_994
    jmp .L996
.L995:
.L996:
    mov rax, rbx
    push rax
section .data
.str1000: db 46,100,97,116,97,0
section .text
    lea rax, [rel .str1000]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L998
    mov rax, 1
    mov [rel __g_karm_core_kc_sec], rax
    mov rax, 0
    jmp .__ret_994
    jmp .L999
.L998:
.L999:
    mov rax, rbx
    push rax
section .data
.str1003: db 46,98,115,115,0
section .text
    lea rax, [rel .str1003]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L1001
    mov rax, 2
    mov [rel __g_karm_core_kc_sec], rax
    mov rax, 0
    jmp .__ret_994
    jmp .L1002
.L1001:
.L1002:
    mov rcx, 8
    sub rsp, 32
    call kc_err2
    add rsp, 32
    jmp .__ret_994
.__ret_994:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_align_dir:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1007
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1007
    mov rax, 0
    jmp .L1008
.L1007:
    mov rax, 1
.L1008:
    test rax, rax
    jz .L1005
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1004
    jmp .L1006
.L1005:
.L1006:
.L1009:
    sub rsp, 32
    call kc_cur_off
    add rsp, 32
    mov rcx, rbx
    cqo
    idiv rcx
    mov rax, rdx
    cmp rax, 0
    je .L1010
    mov rax, [rel __g_karm_core_kc_sec]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1014
    sub rsp, 32
    call kc_cur_off
    add rsp, 32
    and rax, 3
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1014
    mov rax, 1
    jmp .L1015
.L1014:
    mov rax, 0
.L1015:
    test rax, rax
    jz .L1012
    mov rcx, 0xD503201F
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .L1013
.L1012:
    mov rcx, 0
    sub rsp, 32
    call kc_emit8
    add rsp, 32
.L1013:
.L1011:
    jmp .L1009
.L1010:
    mov rax, 0
    jmp .__ret_1004
.__ret_1004:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_data_dir:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_karm_core_kc_rest]
    mov rbx, rax
.L1017:
    mov rax, 1
    test rax, rax
    jz .L1018
    mov rcx, rbx
    sub rsp, 32
    call kc_item
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_item_f]
    cmp rax, 0
    jne .L1020
    mov rax, 0
    jmp .__ret_1016
    jmp .L1021
.L1020:
.L1021:
    mov rcx, r12
    sub rsp, 32
    call kc_data_item
    add rsp, 32
    cmp rax, 0
    jne .L1022
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1016
    jmp .L1023
.L1022:
.L1023:
.L1019:
    jmp .L1017
.L1018:
    mov rax, 0
    jmp .__ret_1016
.__ret_1016:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kc_item:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov [rel __g_karm_core_kc_item_f], rax
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    jne .L1025
    mov rax, r15
    jmp .__ret_1024
    jmp .L1026
.L1025:
.L1026:
    lea rax, [rel __g_karm_core_kc_ops]
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L1027:
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L1028
    mov rcx, r15
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1032
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1032
    mov rax, 1
    jmp .L1033
.L1032:
    mov rax, 0
.L1033:
    test rax, rax
    jz .L1030
    add r15, 1
    jmp .L1028
    jmp .L1031
.L1030:
.L1031:
    cmp r12, 0
    je .L1034
    cmp rbx, r12
    jne .L1036
    mov rax, 0
    mov r12, rax
    jmp .L1037
.L1036:
.L1037:
    jmp .L1035
.L1034:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1040
    mov rax, rbx
    mov rcx, 34
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
    jz .L1038
    mov rax, rbx
    mov r12, rax
    jmp .L1039
.L1038:
.L1039:
.L1035:
    cmp r13, 250
    jge .L1042
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    add r13, 1
    jmp .L1043
.L1042:
.L1043:
    add r15, 1
.L1029:
    jmp .L1027
.L1028:
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call kc_finish
    add rsp, 32
    mov rax, 1
    mov [rel __g_karm_core_kc_item_f], rax
    mov rax, r15
    jmp .__ret_1024
.__ret_1024:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kc_data_item:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r13, rcx
    lea rax, [rel __g_karm_core_kc_ops]
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1047
    mov rax, r12
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1047
    mov rax, 0
    jmp .L1048
.L1047:
    mov rax, 1
.L1048:
    test rax, rax
    jz .L1045
    mov rax, r14
    add rax, 1
    mov rbx, rax
.L1049:
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1052
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rcx, r12
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1052
    mov rax, 1
    jmp .L1053
.L1052:
    mov rax, 0
.L1053:
    test rax, rax
    jz .L1050
    mov rcx, rbx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call kc_emit_n
    add rsp, 32
    add rbx, 1
.L1051:
    jmp .L1049
.L1050:
    mov rax, 1
    jmp .__ret_1044
    jmp .L1046
.L1045:
.L1046:
    mov rax, r13
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1056
    mov rax, r12
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1060
    mov rax, r12
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1060
    mov rax, 0
    jmp .L1061
.L1060:
    mov rax, 1
.L1061:
    test rax, rax
    jnz .L1058
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1062
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L1062
    mov rax, 1
    jmp .L1063
.L1062:
    mov rax, 0
.L1063:
    test rax, rax
    jnz .L1058
    mov rax, 0
    jmp .L1059
.L1058:
    mov rax, 1
.L1059:
    test rax, rax
    jz .L1056
    mov rax, 1
    jmp .L1057
.L1056:
    mov rax, 0
.L1057:
    test rax, rax
    jz .L1054
    mov rax, 0
    mov rbx, rax
.L1064:
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 0
    je .L1065
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    cmp rax, 46
    jne .L1067
    mov rcx, r14
    mov rdx, 0
    sub rsp, 32
    call cg_float_bits
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call kc_emit_n
    add rsp, 32
    mov rax, 1
    jmp .__ret_1044
    jmp .L1068
.L1067:
.L1068:
    add rbx, 1
.L1066:
    jmp .L1064
.L1065:
    jmp .L1055
.L1054:
.L1055:
    mov rax, 0
    mov [rel __g_karm_core_kc_unres_f], rax
    mov rax, 1
    mov [rel __g_karm_core_kc_rsign], rax
    mov rax, 0
    mov [rel __g_karm_core_kc_nrel], rax
    mov rcx, r14
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L1069
    mov rax, 0
    jmp .__ret_1044
    jmp .L1070
.L1069:
.L1070:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    mov rax, r13
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1075
    mov rax, [rel __g_karm_core_kc_nrel]
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1075
    mov rax, 1
    jmp .L1076
.L1075:
    mov rax, 0
.L1076:
    test rax, rax
    jz .L1073
    mov rax, [rel __g_karm_core_kc_pass_n]
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1073
    mov rax, 1
    jmp .L1074
.L1073:
    mov rax, 0
.L1074:
    test rax, rax
    jz .L1071
    sub rsp, 32
    call kc_note_reloc
    add rsp, 32
    jmp .L1072
.L1071:
.L1072:
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
    call kc_emit_n
    add rsp, 32
    mov rax, 1
    jmp .__ret_1044
.__ret_1044:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kc_note_reloc:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 1
    jne .L1078
    mov rax, [rel __g_karm_core_kc_rel_n]
    push rax
    mov rax, [rel __g_karm_core_KA_REL_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1080
    lea rax, [rel __g_karm_core_kc_rel_off]
    push rax
    mov rax, [rel __g_karm_core_kc_rel_n]
    push rax
    mov rax, [rel __g_karm_core_kc_data_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    mov rax, [rel __g_karm_core_kc_rel_n]
    add rax, 1
    mov [rel __g_karm_core_kc_rel_n], rax
    jmp .L1081
.L1080:
.L1081:
    jmp .L1079
.L1078:
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 0
    jne .L1082
    mov rax, [rel __g_karm_core_kc_rel_text]
    add rax, 1
    mov [rel __g_karm_core_kc_rel_text], rax
    jmp .L1083
.L1082:
.L1083:
.L1079:
    mov rax, 0
    jmp .__ret_1077
.__ret_1077:
    mov rsp, rbp
    pop rbp
    ret
kc_res:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov [rel __g_karm_core_kc_unres_f], rax
    mov rcx, 0
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L1085
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1084
    jmp .L1086
.L1085:
.L1086:
    mov rax, [rel __g_karm_core_kc_unres_f]
    cmp rax, 0
    je .L1087
    mov rcx, 6
    sub rsp, 32
    call kc_err
    add rsp, 32
    jmp .__ret_1084
    jmp .L1088
.L1087:
.L1088:
    mov rax, rbx
    imul rax, r12
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_sec]
    cmp rax, 2
    jne .L1089
    mov rax, [rel __g_karm_core_kc_bss_len]
    add rax, rbx
    mov [rel __g_karm_core_kc_bss_len], rax
    mov rax, 0
    jmp .__ret_1084
    jmp .L1090
.L1089:
.L1090:
.L1091:
    cmp rbx, 0
    jle .L1092
    mov rcx, 0
    sub rsp, 32
    call kc_emit8
    add rsp, 32
    sub rbx, 1
.L1093:
    jmp .L1091
.L1092:
    mov rax, 0
    jmp .__ret_1084
.__ret_1084:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_equ:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_karm_core_kc_deflbl]
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1095
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1094
    jmp .L1096
.L1095:
.L1096:
    mov rcx, 0
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L1097
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1094
    jmp .L1098
.L1097:
.L1098:
    lea rax, [rel __g_karm_core_kc_lb_sec]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, 3
    sub rsp, 32
    call kc_put
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_lb_val]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call kc_put
    add rsp, 32
    mov rax, 0
    jmp .__ret_1094
.__ret_1094:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kc_times:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rax, [rel __g_karm_core_kc_rest]
    push rax
    pop rcx
    sub rsp, 32
    call kc_getword
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov [rel __g_karm_core_kc_unres_f], rax
    lea rax, [rel __g_karm_core_kc_word]
    push rax
    pop rcx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L1100
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1099
    jmp .L1101
.L1100:
.L1101:
    mov rax, [rel __g_karm_core_kc_unres_f]
    cmp rax, 0
    je .L1102
    mov rcx, 6
    sub rsp, 32
    call kc_err
    add rsp, 32
    jmp .__ret_1099
    jmp .L1103
.L1102:
.L1103:
    mov rcx, r14
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_getword
    add rsp, 32
    mov r14, rax
    lea rax, [rel __g_karm_core_kc_word]
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    push rax
section .data
.str1106: db 100,98,0
section .text
    lea rax, [rel .str1106]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L1104
    mov rax, 1
    mov r12, rax
    jmp .L1105
.L1104:
    mov rax, rbx
    push rax
section .data
.str1109: db 100,119,0
section .text
    lea rax, [rel .str1109]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L1107
    mov rax, 2
    mov r12, rax
    jmp .L1108
.L1107:
    mov rax, rbx
    push rax
section .data
.str1112: db 100,100,0
section .text
    lea rax, [rel .str1112]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L1110
    mov rax, 4
    mov r12, rax
    jmp .L1111
.L1110:
    mov rax, rbx
    push rax
section .data
.str1115: db 100,113,0
section .text
    lea rax, [rel .str1115]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    je .L1113
    mov rax, 8
    mov r12, rax
    jmp .L1114
.L1113:
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1099
.L1114:
.L1111:
.L1108:
.L1105:
    mov rcx, r14
    sub rsp, 32
    call kc_skipb
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_evok_f]
    cmp rax, 0
    jne .L1116
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_1099
    jmp .L1117
.L1116:
.L1117:
.L1118:
    cmp r13, 0
    jle .L1119
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call kc_emit_n
    add rsp, 32
    sub r13, 1
.L1120:
    jmp .L1118
.L1119:
    mov rax, 0
    jmp .__ret_1099
.__ret_1099:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kc_sf:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 2
    jne .L1122
    mov rax, 0
    jmp .__ret_1121
    jmp .L1123
.L1122:
.L1123:
    mov rax, 0x80000000
    jmp .__ret_1121
.__ret_1121:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_movimm:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov [rbp-176], r15
    mov [rbp-8], rcx
    mov rbx, rdx
    mov [rbp-24], r8
    mov rax, 4
    mov [rbp-32], rax
    mov rax, rbx
    mov r15, rax
    mov rax, [rbp-24]
    cmp rax, 2
    jne .L1125
    mov rax, 2
    mov [rbp-32], rax
    mov rax, r15
    mov rcx, 4294967295
    and rax, rcx
    mov r15, rax
    jmp .L1126
.L1125:
.L1126:
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r14, rax
.L1127:
    mov rax, r14
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L1128
    mov rax, r14
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    shr rax, cl
    and rax, 65535
    mov r13, rax
    cmp r13, 0
    je .L1130
    add r12, 1
    jmp .L1131
.L1130:
.L1131:
    cmp r13, 65535
    je .L1132
    add rbx, 1
    jmp .L1133
.L1132:
.L1133:
    add r14, 1
.L1129:
    jmp .L1127
.L1128:
    mov rcx, [rbp-24]
    sub rsp, 32
    call kc_sf
    add rsp, 32
    mov [rbp-80], rax
    mov rax, 0x52800000
    mov [rbp-88], rax
    mov rax, 0
    mov [rbp-96], rax
    cmp rbx, r12
    jge .L1134
    mov rax, 0x12800000
    mov [rbp-88], rax
    mov rax, 1
    mov [rbp-96], rax
    jmp .L1135
.L1134:
.L1135:
    lea rax, [rel __g_karm_core_kc_seq]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-120], rax
    mov rax, 0
    mov r14, rax
.L1136:
    mov rax, r14
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L1137
    mov rax, r14
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    shr rax, cl
    and rax, 65535
    mov rbx, rax
    mov rax, 0
    mov [rbp-136], rax
    mov rax, [rbp-96]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1141
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1141
    mov rax, 1
    jmp .L1142
.L1141:
    mov rax, 0
.L1142:
    test rax, rax
    jz .L1139
    mov rax, 1
    mov [rbp-136], rax
    jmp .L1140
.L1139:
.L1140:
    mov rax, [rbp-96]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1145
    mov rax, rbx
    mov rcx, 65535
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1145
    mov rax, 1
    jmp .L1146
.L1145:
    mov rax, 0
.L1146:
    test rax, rax
    jz .L1143
    mov rax, 1
    mov [rbp-136], rax
    jmp .L1144
.L1143:
.L1144:
    mov rax, [rbp-136]
    cmp rax, 0
    jne .L1147
    mov rax, 0x72800000
    mov [rbp-144], rax
    mov rax, [rbp-120]
    cmp rax, 0
    jne .L1149
    mov rax, [rbp-96]
    cmp rax, 0
    je .L1151
    xor rbx, 65535
    jmp .L1152
.L1151:
.L1152:
    mov rax, [rbp-88]
    mov [rbp-144], rax
    mov rax, 1
    mov [rbp-120], rax
    jmp .L1150
.L1149:
.L1150:
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, [rbp-144]
    mov rcx, [rbp-80]
    or rax, rcx
    push rax
    mov rax, rbx
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r14
    shl rax, 21
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, [rbp-8]
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    add r12, 1
    jmp .L1148
.L1147:
.L1148:
    add r14, 1
.L1138:
    jmp .L1136
.L1137:
    mov rax, [rbp-120]
    cmp rax, 0
    jne .L1153
    mov rax, r13
    push rax
    mov rax, 0
    push rax
    mov rax, [rbp-88]
    mov rcx, [rbp-80]
    or rax, rcx
    push rax
    mov rax, [rbp-8]
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    mov rax, 1
    mov r12, rax
    jmp .L1154
.L1153:
.L1154:
    mov rax, [rel __g_karm_core_kc_movseq]
    mov r14, rax
    mov rax, [rel __g_karm_core_kc_movseq]
    add rax, 1
    mov [rel __g_karm_core_kc_movseq], rax
    mov rax, r14
    push rax
    mov rax, [rel __g_karm_core_KA_MOVSZ_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1155
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_pass_n]
    cmp rax, 1
    jne .L1157
    mov rax, r12
    mov rbx, rax
    mov rax, [rel __g_karm_core_kc_unres_f]
    cmp rax, 0
    je .L1159
    mov rax, [rbp-32]
    mov rbx, rax
    jmp .L1160
.L1159:
.L1160:
    lea rax, [rel __g_karm_core_kc_movsz]
    add rax, r14
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    jmp .L1158
.L1157:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    lea rax, [rel __g_karm_core_kc_movsz]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, r12
    jge .L1161
    mov rcx, 6
    sub rsp, 32
    call kc_err
    add rsp, 32
    mov rax, r12
    mov rbx, rax
    jmp .L1162
.L1161:
.L1162:
.L1158:
.L1163:
    cmp r12, rbx
    jge .L1164
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, 0x72800000
    mov rcx, [rbp-80]
    or rax, rcx
    push rax
    mov rax, r15
    and rax, 65535
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, [rbp-8]
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_put
    add rsp, 32
    add r12, 1
.L1165:
    jmp .L1163
.L1164:
    jmp .L1156
.L1155:
.L1156:
    mov rax, 0
    mov r14, rax
.L1166:
    cmp r14, r12
    jge .L1167
    mov rcx, r13
    mov rdx, r14
    sub rsp, 32
    call kc_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    add r14, 1
.L1168:
    jmp .L1166
.L1167:
    mov rax, 0
    jmp .__ret_1124
.__ret_1124:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov r15, [rbp-176]
    mov rsp, rbp
    pop rbp
    ret
kc_rrr:
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
    mov rax, rbx
    and rax, 31
    shl rax, 16
    mov rcx, rax
    mov rax, r14
    or rax, rcx
    push rax
    mov rax, r12
    and rax, 31
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r13
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_1169
.__ret_1169:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kc_need:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_karm_core_kc_nops_n]
    cmp rax, rbx
    jne .L1171
    mov rax, 1
    jmp .__ret_1170
    jmp .L1172
.L1171:
.L1172:
    mov rax, 0
    jmp .__ret_1170
.__ret_1170:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_copyop:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov r14, rax
    mov rcx, rbx
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L1174:
    cmp r12, 255
    jge .L1175
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_p8
    add rsp, 32
    cmp rbx, 0
    jne .L1177
    mov rax, 0
    jmp .__ret_1173
    jmp .L1178
.L1177:
.L1178:
    add r12, 1
.L1176:
    jmp .L1174
.L1175:
    mov rax, 0
    jmp .__ret_1173
.__ret_1173:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kc_shift_ops:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_karm_core_kc_nops_n]
    mov rbx, rax
    cmp rbx, 5
    jl .L1180
    mov rax, 0
    jmp .__ret_1179
    jmp .L1181
.L1180:
.L1181:
.L1182:
    cmp rbx, 0
    jle .L1183
    mov rax, rbx
    sub rax, 1
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kc_copyop
    add rsp, 32
    sub rbx, 1
.L1184:
    jmp .L1182
.L1183:
    mov rax, [rel __g_karm_core_kc_nops_n]
    add rax, 1
    mov [rel __g_karm_core_kc_nops_n], rax
    mov rax, 0
    jmp .__ret_1179
.__ret_1179:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kc_zr:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rcx, rbx
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 120
    sub rsp, 32
    call kc_p8
    add rsp, 32
    cmp r12, 2
    jne .L1186
    mov rcx, rbx
    mov rdx, 119
    sub rsp, 32
    call kc_p8
    add rsp, 32
    jmp .L1187
.L1186:
.L1187:
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    mov rdx, 122
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    mov rdx, 114
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, rbx
    add rax, 3
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kc_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_1185
.__ret_1185:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
