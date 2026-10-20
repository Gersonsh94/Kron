; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_kasm_KASM_CODE_MAX: dq 8388608
section .text
section .data
__g_kasm_KASM_DATA_MAX: dq 4194304
section .text
section .data
__g_kasm_KASM_NAMES_MAX: dq 4194304
section .text
section .data
__g_kasm_KASM_LBL_MAX: dq 131072
section .text
section .data
__g_kasm_KASM_HASH_SIZE: dq 65536
section .text
section .data
__g_kasm_KASM_FIX_MAX: dq 524288
section .text
section .data
__g_kasm_KASM_EXT_MAX: dq 512
section .text
section .data
__g_kasm_KASM_EQU_MAX: dq 8192
section .text
section .data
__g_kasm_KASM_EQU_NAMES: dq 262144
section .text
section .bss
__g_kasm_kasm_code: resq 1048576
section .text
section .data
__g_kasm_kasm_code_len: dq 0
section .text
section .bss
__g_kasm_kasm_data: resq 524288
section .text
section .data
__g_kasm_kasm_data_len: dq 0
section .text
section .data
__g_kasm_kasm_org: dq 0
section .text
section .data
__g_kasm_kasm_org_set: dq 0
section .text
section .data
__g_kasm_p1_data_base: dq 0
section .text
section .data
__g_kasm_p1_bss_base: dq 0
section .text
section .data
__g_kasm_kasm_bss_len: dq 0
section .text
section .bss
__g_kasm_lbl_names: resq 524288
section .text
section .data
__g_kasm_lbl_names_len: dq 0
section .text
section .bss
__g_kasm_lbl_name_off: resq 131072
section .text
section .bss
__g_kasm_lbl_addr: resq 131072
section .text
section .bss
__g_kasm_lbl_section: resq 131072
section .text
section .bss
__g_kasm_lbl_pass: resq 131072
section .text
section .data
__g_kasm_lbl_is_equ: dq 0
section .text
section .bss
__g_kasm_lbl_hash: resq 65536
section .text
section .bss
__g_kasm_lbl_chain: resq 131072
section .text
section .data
__g_kasm_lbl_count: dq 0
section .text
section .bss
__g_kasm_fix_at: resq 524288
section .text
section .bss
__g_kasm_fix_label: resq 524288
section .text
section .bss
__g_kasm_fix_addend: resq 524288
section .text
section .bss
__g_kasm_fix_kind: resq 524288
section .text
section .data
__g_kasm_fix_count: dq 0
section .text
section .data
__g_kasm_cur_fix_kind: dq 0
section .text
section .data
__g_kasm_data_base: dq 0
section .text
section .data
__g_kasm_bss_base: dq 0
section .text
section .data
__g_kasm_bss_cursor: dq 0
section .text
section .bss
__g_kasm_ext_names: resq 2048
section .text
section .data
__g_kasm_ext_names_len: dq 0
section .text
section .bss
__g_kasm_ext_name_off: resq 512
section .text
section .data
__g_kasm_ext_count: dq 0
section .text
section .bss
__g_kasm_extref_at: resq 512
section .text
section .bss
__g_kasm_extref_sym: resq 512
section .text
section .data
__g_kasm_extref_count: dq 0
section .text
section .bss
__g_kasm_ext_map: resq 512
section .text
section .bss
__g_kasm_ext_used: resq 512
section .text
section .data
__g_kasm_prn_new: dq 0
section .text
section .bss
__g_kasm_line_buf: resq 128
section .text
section .bss
__g_kasm_lbl_rest: resq 64
section .text
section .bss
__g_kasm_tok_a: resq 8
section .text
section .bss
__g_kasm_tok_b: resq 64
section .text
section .bss
__g_kasm_tok_c: resq 64
section .text
section .data
__g_kasm_cur_section: dq 0
section .text
section .data
__g_kasm_kasm_pass: dq 0
section .text
section .data
__g_kasm_kasm_error: dq 0
section .text
section .data
__g_kasm_op_size: dq 0
section .text
section .data
__g_kasm_db_quote: dq 0
section .text
section .data
__g_kasm_db_phase: dq 0
section .text
section .data
__g_kasm_dst_base: dq 0
section .text
section .data
__g_kasm_src_base: dq 0
section .text
section .data
__g_kasm_rex8_force: dq 0
section .text
section .data
__g_kasm_sse_pfx: dq 0
section .text
section .data
__g_kasm_dl_size: dq 0
section .text
section .data
__g_kasm_expr_ptr: dq 0
section .text
section .bss
__g_kasm_last_label: resq 8
section .text
section .bss
__g_kasm_cur_global: resq 8
section .text
section .bss
__g_kasm_qual_buf: resq 20
section .text
section .data
__g_kasm_qual_len: dq 0
section .text
section .data
__g_kasm_sib_disp: dq 0
section .text
section .bss
__g_kasm_equ_names: resq 32768
section .text
section .data
__g_kasm_equ_names_len: dq 0
section .text
section .bss
__g_kasm_equ_name_off: resq 8192
section .text
section .bss
__g_kasm_equ_value: resq 8192
section .text
section .data
__g_kasm_equ_count: dq 0
section .text
section .data
__g_kasm_dst_addend: dq 0
section .text
section .data
__g_kasm_kasm_line: dq 0
section .text
section .data
__g_kasm_kasm_err_line: dq 0
section .text
section .bss
__g_kasm_err_lines: resq 64
section .text
section .bss
__g_kasm_err_dst: resq 64
section .text
section .bss
__g_kasm_err_src: resq 64
section .text
section .data
__g_kasm_err_count: dq 0
section .text
section .bss
__g_kasm_err_mnem: resq 512
section .text
section .data
__g_kasm_cur_addend: dq 0
section .text
section .data
__g_kasm_po_val: dq 0
section .text
section .data
__g_kasm_po_r8: dq 0
section .text
section .data
__g_kasm_po_ecx: dq 0
section .text
section .data
__g_kasm_sl_n: dq 0
section .text
section .data
__g_kasm_en_r12: dq 0
section .text
section .data
__g_kasm_en_r13: dq 0
section .text
section .data
__g_kasm_en_r14: dq 0
section .text
section .data
__g_kasm_en_r15: dq 0
section .text
section .data
__g_kasm_rp_left: dq 0
section .text
section .data
__g_kasm_rp_len: dq 0
section .text
section .data
__g_kasm_rp_src: dq 0
section .text
section .data
__g_kasm_pf_val: dq 0
section .text
ks_emit_b:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_kasm_pass]
    cmp rax, 1
    jne .L1
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 1
    jne .L3
    mov rax, [rel __g_kasm_kasm_data_len]
    add rax, 1
    mov [rel __g_kasm_kasm_data_len], rax
    jmp .L4
.L3:
    mov rax, [rel __g_kasm_kasm_code_len]
    add rax, 1
    mov [rel __g_kasm_kasm_code_len], rax
.L4:
    mov rax, 0
    jmp .__ret_0
    jmp .L2
.L1:
.L2:
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 1
    jne .L5
    mov rax, [rel __g_kasm_kasm_data_len]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_KASM_DATA_MAX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L7
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, 0
    jmp .__ret_0
    jmp .L8
.L7:
.L8:
    lea rax, [rel __g_kasm_kasm_data]
    add rax, rbx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, [rel __g_kasm_kasm_data_len]
    add rax, 1
    mov [rel __g_kasm_kasm_data_len], rax
    mov rax, 0
    jmp .__ret_0
    jmp .L6
.L5:
.L6:
    mov rax, [rel __g_kasm_kasm_code_len]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_KASM_CODE_MAX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L9
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, 0
    jmp .__ret_0
    jmp .L10
.L9:
.L10:
    lea rax, [rel __g_kasm_kasm_code]
    add rax, rbx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, [rel __g_kasm_kasm_code_len]
    add rax, 1
    mov [rel __g_kasm_kasm_code_len], rax
    mov rax, 0
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_w:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, rbx
    shr rax, 8
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_11
.__ret_11:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, rbx
    shr rax, 8
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, rbx
    shr rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, rbx
    shr rax, 24
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_q:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    mov rax, rbx
    shr rax, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_13
.__ret_13:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_bss_round8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 7
    push rax
    mov rax, 8
    neg rax
    mov rcx, rax
    pop rax
    and rax, rcx
    jmp .__ret_14
.__ret_14:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_here:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 1
    jne .L16
    mov rax, [rel __g_kasm_kasm_data_len]
    jmp .__ret_15
    jmp .L17
.L16:
.L17:
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 2
    jne .L18
    mov rax, [rel __g_kasm_bss_cursor]
    jmp .__ret_15
    jmp .L19
.L18:
.L19:
    mov rax, [rel __g_kasm_kasm_code_len]
    jmp .__ret_15
.__ret_15:
    mov rsp, rbp
    pop rbp
    ret
ks_crnum:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 99
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L25
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 114
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L25
    mov rax, 0
    jmp .L26
.L25:
    mov rax, 1
.L26:
    test rax, rax
    jnz .L23
    mov rax, r12
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L23
    mov rax, 0
    jmp .L24
.L23:
    mov rax, 1
.L24:
    test rax, rax
    jz .L21
    mov rax, 1
    neg rax
    jmp .__ret_20
    jmp .L22
.L21:
.L22:
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    sub rax, 48
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rbx, rax
    mov rcx, 8
    mov rdx, rbx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L27
    mov rax, 1
    neg rax
    jmp .__ret_20
    jmp .L28
.L27:
.L28:
    mov rax, rbx
    jmp .__ret_20
.__ret_20:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_rex:
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
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    and rax, 255
    cmp rax, 0
    je .L30
    or rbx, 8
    jmp .L31
.L30:
.L31:
    mov rax, r13
    and rax, 8
    cmp rax, 0
    je .L32
    or rbx, 4
    jmp .L33
.L32:
.L33:
    mov rax, r12
    and rax, 8
    cmp rax, 0
    je .L34
    or rbx, 1
    jmp .L35
.L34:
.L35:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L38
    mov rax, [rel __g_kasm_rex8_force]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L38
    mov rax, 1
    jmp .L39
.L38:
    mov rax, 0
.L39:
    test rax, rax
    jz .L36
    mov rax, 0
    jmp .__ret_29
    jmp .L37
.L36:
.L37:
    mov rax, 64
    or rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_29
.__ret_29:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_sse_rex:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, 0
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    jmp .__ret_40
.__ret_40:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_modrm:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, r13
    shl rax, 6
    push rax
    mov rax, r12
    and rax, 7
    shl rax, 3
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, rbx
    and rax, 7
    mov rcx, rax
    pop rax
    or rax, rcx
    and rax, 255
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_41
.__ret_41:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_err_record:
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
    mov rax, [rel __g_kasm_err_count]
    mov rbx, rax
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, [rel __g_kasm_kasm_err_line]
    cmp rax, 0
    jne .L43
    mov rax, [rel __g_kasm_kasm_line]
    mov [rel __g_kasm_kasm_err_line], rax
    jmp .L44
.L43:
.L44:
    mov rcx, rbx
    mov rdx, 64
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L45
    mov rax, 0
    jmp .__ret_42
    jmp .L46
.L45:
.L46:
    lea rax, [rel __g_kasm_err_lines]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_kasm_line]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_err_dst]
    push rax
    mov rax, rbx
    push rax
    mov rcx, r14
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_err_src]
    push rax
    mov rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_record_err_mnem
    add rsp, 32
    cmp r12, 0
    je .L47
    mov rcx, rbx
    sub rsp, 32
    call ks_record_err_ops
    add rsp, 32
    jmp .L48
.L47:
.L48:
    mov rax, rbx
    add rax, 1
    mov [rel __g_kasm_err_count], rax
    mov rax, 0
    jmp .__ret_42
.__ret_42:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_unknown_label:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_pass]
    cmp rax, 2
    je .L50
    mov rax, 0
    jmp .__ret_49
    jmp .L51
.L50:
.L51:
    mov rcx, 99
    mov rdx, 0
    mov r8, 1
    sub rsp, 32
    call ks_err_record
    add rsp, 32
    jmp .__ret_49
.__ret_49:
    mov rsp, rbp
    pop rbp
    ret
ks_dup_label:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_pass]
    cmp rax, 1
    je .L53
    mov rax, 0
    jmp .__ret_52
    jmp .L54
.L53:
.L54:
    mov rcx, 98
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call ks_err_record
    add rsp, 32
    jmp .__ret_52
.__ret_52:
    mov rsp, rbp
    pop rbp
    ret
ks_record_err_mnem:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    lea rax, [rel __g_kasm_err_mnem]
    push rax
    mov rax, rbx
    mov rcx, 64
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L56:
    cmp r12, 15
    jge .L57
    lea rax, [rel __g_kasm_tok_a]
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L59
    jmp .L57
    jmp .L60
.L59:
.L60:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r12, 1
.L58:
    jmp .L56
.L57:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    jmp .__ret_55
.__ret_55:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_record_err_ops:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rbx, rcx
    lea rax, [rel __g_kasm_err_mnem]
    push rax
    mov rax, rbx
    mov rcx, 64
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r15, rax
    mov rax, 0
    mov r14, rax
    lea rax, [rel __g_kasm_tok_b]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L62:
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 0
    je .L63
    add r14, 1
.L64:
    jmp .L62
.L63:
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    mov rdx, 32
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r14, 1
.L65:
    cmp r14, 62
    jge .L66
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L68
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r13, 1
    add r14, 1
    jmp .L69
.L68:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L72
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L72
    mov rax, 0
    jmp .L73
.L72:
    mov rax, 1
.L73:
    test rax, rax
    jz .L70
    jmp .L66
    jmp .L71
.L70:
.L71:
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    mov rdx, 44
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r14, 1
    lea rax, [rel __g_kasm_tok_c]
    mov r13, rax
    mov rax, 1
    mov r12, rax
.L69:
.L67:
    jmp .L65
.L66:
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    jmp .__ret_61
.__ret_61:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_rip:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, rbx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    jne .L75
    sub rsp, 32
    call ks_unknown_label
    add rsp, 32
    jmp .L76
.L75:
.L76:
    mov rcx, 0
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, rbx
    mov rdx, 3
    sub rsp, 32
    call ks_add_fixup
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_74
.__ret_74:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_sib_modrm:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov rbx, rdx
    mov rax, rbx
    and rax, 255
    mov r14, rax
    mov rax, rbx
    shr rax, 8
    and rax, 255
    mov r13, rax
    mov rax, rbx
    shr rax, 16
    and rax, 3
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_sib_disp]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    cmp rax, 0
    je .L78
    mov rax, 2
    mov rbx, rax
    jmp .L79
.L78:
    mov rax, r14
    and rax, 7
    cmp rax, 5
    jne .L80
    mov rax, 1
    mov rbx, rax
    jmp .L81
.L80:
.L81:
.L79:
    mov rcx, rbx
    mov rdx, r15
    mov r8, 4
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, r12
    shl rax, 6
    push rax
    mov rax, r13
    and rax, 7
    shl rax, 3
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r14
    and rax, 7
    mov rcx, rax
    pop rax
    or rax, rcx
    and rax, 255
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp rbx, 2
    jne .L82
    mov rax, [rel __g_kasm_sib_disp]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_77
    jmp .L83
.L82:
.L83:
    cmp rbx, 0
    je .L84
    mov rcx, 0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_77
    jmp .L85
.L84:
.L85:
    mov rax, 0
    jmp .__ret_77
.__ret_77:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_mem_base_disp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, 0
    sub rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rbx, rax
    mov rcx, 2
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, r12
    and rax, 7
    cmp rax, 4
    jne .L87
    mov rcx, 0x24
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L88
.L87:
.L88:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_86
.__ret_86:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_sib_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov rbx, r8
    mov [rbp-32], r9
    mov rax, rbx
    and rax, 255
    mov r14, rax
    mov rax, rbx
    shr rax, 8
    and rax, 255
    mov r13, rax
    mov rax, rbx
    shr rax, 16
    and rax, 3
    mov [rbp-56], rax
    mov rax, 64
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-32]
    and rax, 1
    cmp rax, 0
    je .L90
    or r12, 8
    jmp .L91
.L90:
.L91:
    mov rax, r15
    and rax, 8
    cmp rax, 0
    je .L92
    or r12, 4
    jmp .L93
.L92:
.L93:
    mov rax, r13
    and rax, 8
    cmp rax, 0
    je .L94
    or r12, 2
    jmp .L95
.L94:
.L95:
    mov rax, r14
    and rax, 8
    cmp rax, 0
    je .L96
    or r12, 1
    jmp .L97
.L96:
.L97:
    mov rax, r12
    mov rcx, 64
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L100
    mov rax, [rel __g_kasm_rex8_force]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L100
    mov rax, 0
    jmp .L101
.L100:
    mov rax, 1
.L101:
    test rax, rax
    jz .L98
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L99
.L98:
.L99:
    mov rcx, [rbp-8]
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_sib_disp]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    cmp rax, 0
    je .L102
    mov rax, 2
    mov rbx, rax
    jmp .L103
.L102:
    mov rax, r14
    and rax, 7
    cmp rax, 5
    jne .L104
    mov rax, 1
    mov rbx, rax
    jmp .L105
.L104:
.L105:
.L103:
    mov rcx, rbx
    mov rdx, r15
    mov r8, 4
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rbp-56]
    shl rax, 6
    push rax
    mov rax, r13
    and rax, 7
    shl rax, 3
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r14
    and rax, 7
    mov rcx, rax
    pop rax
    or rax, rcx
    and rax, 255
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp rbx, 2
    jne .L106
    mov rax, [rel __g_kasm_sib_disp]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_89
    jmp .L107
.L106:
.L107:
    cmp rbx, 0
    je .L108
    mov rcx, 0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_89
    jmp .L109
.L108:
.L109:
    mov rax, 0
    jmp .__ret_89
.__ret_89:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_mem_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, r12
    and rax, 7
    mov rbx, rax
    cmp rbx, 4
    jne .L111
    mov rcx, 0
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, 0x24
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_110
    jmp .L112
.L111:
.L112:
    cmp rbx, 5
    jne .L113
    mov rcx, 1
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_110
    jmp .L114
.L113:
.L114:
    mov rcx, 0
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_110
.__ret_110:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_emit_mem_rbp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, 128
    push rax
    mov rcx, rbx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L116
    mov rcx, 2
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, 0
    sub rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_115
    jmp .L117
.L116:
.L117:
    mov rcx, 1
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, 0
    sub rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_115
.__ret_115:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_add_extern:
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
    mov rax, [rel __g_kasm_ext_count]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call ks_find_extern
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L119
    mov rax, 0
    jmp .__ret_118
    jmp .L120
.L119:
.L120:
    mov rcx, r13
    mov rdx, 512
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L121
    mov rax, 0
    jmp .__ret_118
    jmp .L122
.L121:
.L122:
    lea rax, [rel __g_kasm_ext_name_off]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_ext_names_len]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_ext_names]
    push rax
    mov rax, [rel __g_kasm_ext_names_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
.L123:
    cmp rbx, r14
    jge .L124
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add rbx, 1
.L125:
    jmp .L123
.L124:
    mov rax, r12
    add rax, r14
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, [rel __g_kasm_ext_names_len]
    add rax, r14
    add rax, 1
    mov [rel __g_kasm_ext_names_len], rax
    mov rax, r13
    add rax, 1
    mov [rel __g_kasm_ext_count], rax
    mov rax, 0
    jmp .__ret_118
.__ret_118:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_ext_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_ext_names]
    push rax
    lea rax, [rel __g_kasm_ext_name_off]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_126
.__ret_126:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_prune_externs:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
.L128:
    cmp r14, 512
    jge .L129
    lea rax, [rel __g_kasm_ext_used]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, 0
    sub rsp, 32
    call ks_qs
    add rsp, 32
    add r14, 1
.L130:
    jmp .L128
.L129:
    mov rax, 0
    mov r14, rax
.L131:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_extref_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L132
    lea rax, [rel __g_kasm_ext_used]
    push rax
    lea rax, [rel __g_kasm_extref_sym]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
    call ks_qs
    add rsp, 32
    add r14, 1
.L133:
    jmp .L131
.L132:
    mov rax, 0
    mov [rel __g_kasm_prn_new], rax
    mov rax, 0
    mov r14, rax
.L134:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_ext_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L135
    mov rcx, r14
    sub rsp, 32
    call ks_ext_name
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rcx, rbx
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L139
    lea rax, [rel __g_kasm_ext_used]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rcx, 0
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
    jz .L137
    lea rax, [rel __g_kasm_ext_map]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, 0xFFFFFFFF
    sub rsp, 32
    call ks_qs
    add rsp, 32
    jmp .L138
.L137:
    lea rax, [rel __g_kasm_ext_map]
    push rax
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_prn_new]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, [rel __g_kasm_prn_new]
    add rax, 1
    mov [rel __g_kasm_prn_new], rax
.L138:
    add r14, 1
.L136:
    jmp .L134
.L135:
    mov rax, 0
    mov [rel __g_kasm_prn_new], rax
    mov rax, 1
    mov r13, rax
    mov rax, 0
    mov r14, rax
.L141:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_ext_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L142
    lea rax, [rel __g_kasm_ext_map]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    je .L144
    mov rcx, r14
    sub rsp, 32
    call ks_ext_name
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_kasm_ext_name_off]
    push rax
    mov rax, [rel __g_kasm_prn_new]
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, [rel __g_kasm_prn_new]
    add rax, 1
    mov [rel __g_kasm_prn_new], rax
    mov rax, 1
    mov rbx, rax
.L146:
    cmp rbx, 0
    je .L147
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_kasm_ext_names]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r12, 1
    add r13, 1
.L148:
    jmp .L146
.L147:
    jmp .L145
.L144:
.L145:
    add r14, 1
.L143:
    jmp .L141
.L142:
    mov rax, [rel __g_kasm_prn_new]
    mov [rel __g_kasm_ext_count], rax
    mov rax, r13
    mov [rel __g_kasm_ext_names_len], rax
    mov rax, 0
    mov [rel __g_kasm_prn_new], rax
    mov rax, 0
    mov r14, rax
.L149:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_extref_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L150
    lea rax, [rel __g_kasm_ext_map]
    push rax
    lea rax, [rel __g_kasm_extref_sym]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    je .L152
    lea rax, [rel __g_kasm_extref_sym]
    push rax
    mov rax, [rel __g_kasm_prn_new]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_extref_at]
    push rax
    mov rax, [rel __g_kasm_prn_new]
    push rax
    lea rax, [rel __g_kasm_extref_at]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, [rel __g_kasm_prn_new]
    add rax, 1
    mov [rel __g_kasm_prn_new], rax
    jmp .L153
.L152:
.L153:
    add r14, 1
.L151:
    jmp .L149
.L150:
    mov rax, [rel __g_kasm_prn_new]
    mov [rel __g_kasm_extref_count], rax
    mov rax, 0
    jmp .__ret_127
.__ret_127:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ks_find_extern:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L155:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_ext_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L156
    mov rcx, r14
    sub rsp, 32
    call ks_ext_name
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L158:
    cmp r12, r15
    jge .L159
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    mov rax, [rbp-8]
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L161
    mov rax, 0
    mov rbx, rax
    jmp .L159
    jmp .L162
.L161:
.L162:
    add r12, 1
.L160:
    jmp .L158
.L159:
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L165
    mov rax, r13
    add rax, r15
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L165
    mov rax, 1
    jmp .L166
.L165:
    mov rax, 0
.L166:
    test rax, rax
    jz .L163
    mov rax, r14
    jmp .__ret_154
    jmp .L164
.L163:
.L164:
    add r14, 1
.L157:
    jmp .L155
.L156:
    mov rax, 1
    neg rax
    jmp .__ret_154
.__ret_154:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_add_extref:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_kasm_extref_count]
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 512
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L168
    mov rax, 0
    jmp .__ret_167
    jmp .L169
.L168:
.L169:
    lea rax, [rel __g_kasm_extref_at]
    push rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ks_here
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_extref_sym]
    push rax
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, rbx
    add rax, 1
    mov [rel __g_kasm_extref_count], rax
    mov rax, 0
    jmp .__ret_167
.__ret_167:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_add_label:
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
    mov rdx, r14
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L171
    lea rax, [rel __g_kasm_lbl_pass]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ks_q
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_kasm_pass]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L175
    mov rax, [rel __g_kasm_lbl_is_equ]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L175
    mov rax, 1
    jmp .L176
.L175:
    mov rax, 0
.L176:
    test rax, rax
    jz .L173
    sub rsp, 32
    call ks_dup_label
    add rsp, 32
    jmp .__ret_170
    jmp .L174
.L173:
.L174:
    lea rax, [rel __g_kasm_lbl_pass]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_kasm_pass]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_addr]
    push rax
    mov rax, r13
    push rax
    sub rsp, 32
    call ks_here
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_section]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_cur_section]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, 0
    jmp .__ret_170
    jmp .L172
.L171:
.L172:
    mov rax, [rel __g_kasm_lbl_count]
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_KASM_LBL_MAX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L179
    mov rax, [rel __g_kasm_lbl_names_len]
    add rax, r14
    add rax, 2
    push rax
    mov rax, [rel __g_kasm_KASM_NAMES_MAX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L179
    mov rax, 0
    jmp .L180
.L179:
    mov rax, 1
.L180:
    test rax, rax
    jz .L177
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, 0
    jmp .__ret_170
    jmp .L178
.L177:
.L178:
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call ks_hash_of
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_kasm_lbl_chain]
    push rax
    mov rax, r13
    push rax
    lea rax, [rel __g_kasm_lbl_hash]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call ks_q
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_hash]
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_name_off]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_lbl_names_len]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_names]
    push rax
    mov rax, [rel __g_kasm_lbl_names_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
.L181:
    cmp rbx, r14
    jge .L182
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add rbx, 1
.L183:
    jmp .L181
.L182:
    mov rax, r12
    add rax, r14
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, [rel __g_kasm_lbl_names_len]
    add rax, r14
    add rax, 1
    mov [rel __g_kasm_lbl_names_len], rax
    lea rax, [rel __g_kasm_lbl_pass]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_kasm_pass]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_addr]
    push rax
    mov rax, r13
    push rax
    sub rsp, 32
    call ks_here
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_lbl_section]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_cur_section]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, r13
    add rax, 1
    mov [rel __g_kasm_lbl_count], rax
    mov rax, 0
    jmp .__ret_170
.__ret_170:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_hash_of:
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
.L185:
    cmp rbx, r13
    jge .L186
    mov rax, r12
    shl rax, 5
    sub rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    add rbx, 1
.L187:
    jmp .L185
.L186:
    mov rax, r12
    shr rax, 16
    mov rcx, rax
    mov rax, r12
    xor rax, rcx
    and rax, 0xFFFF
    jmp .__ret_184
.__ret_184:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_find_label:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    lea rax, [rel __g_kasm_lbl_hash]
    push rax
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    sub rsp, 32
    call ks_hash_of
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L189:
    cmp r15, 0
    je .L190
    mov rax, r15
    sub rax, 1
    mov r14, rax
    lea rax, [rel __g_kasm_lbl_names]
    push rax
    lea rax, [rel __g_kasm_lbl_name_off]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L192:
    mov rax, r12
    mov rcx, [rbp-16]
    cmp rax, rcx
    jge .L193
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    mov rax, [rbp-8]
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L195
    mov rax, 0
    mov rbx, rax
    jmp .L193
    jmp .L196
.L195:
.L196:
    add r12, 1
.L194:
    jmp .L192
.L193:
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L199
    mov rax, r13
    mov rcx, [rbp-16]
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L199
    mov rax, 1
    jmp .L200
.L199:
    mov rax, 0
.L200:
    test rax, rax
    jz .L197
    mov rax, r14
    jmp .__ret_188
    jmp .L198
.L197:
.L198:
    lea rax, [rel __g_kasm_lbl_chain]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov r15, rax
.L191:
    jmp .L189
.L190:
    mov rax, 1
    neg rax
    jmp .__ret_188
.__ret_188:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ks_add_fixup:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_kasm_fix_count]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_KASM_FIX_MAX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L202
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, 0
    jmp .__ret_201
    jmp .L203
.L202:
.L203:
    lea rax, [rel __g_kasm_fix_at]
    push rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ks_here
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_fix_label]
    push rax
    mov rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_fix_kind]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    and rax, 255
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_fix_addend]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_cur_addend]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, rbx
    add rax, 1
    mov [rel __g_kasm_fix_count], rax
    mov rax, 0
    jmp .__ret_201
.__ret_201:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_size_kw:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 98
    jne .L205
    mov rax, r12
    push rax
section .data
.str209: db 98,121,116,101,32,0
section .text
    lea rax, [rel .str209]
    push rax
    pop rdx
    pop rcx
    mov r8, 5
    sub rsp, 32
    call ks_memeq
    add rsp, 32
    cmp rax, 1
    jne .L207
    mov rax, 1
    mov [rel __g_kasm_op_size], rax
    mov rax, 5
    jmp .__ret_204
    jmp .L208
.L207:
.L208:
    mov rax, 0
    jmp .__ret_204
    jmp .L206
.L205:
.L206:
    cmp rbx, 113
    jne .L210
    mov rax, r12
    push rax
section .data
.str214: db 113,119,111,114,100,32,0
section .text
    lea rax, [rel .str214]
    push rax
    pop rdx
    pop rcx
    mov r8, 6
    sub rsp, 32
    call ks_memeq
    add rsp, 32
    cmp rax, 1
    jne .L212
    mov rax, 8
    mov [rel __g_kasm_op_size], rax
    mov rax, 6
    jmp .__ret_204
    jmp .L213
.L212:
.L213:
    mov rax, 0
    jmp .__ret_204
    jmp .L211
.L210:
.L211:
    cmp rbx, 100
    jne .L215
    mov rax, r12
    push rax
section .data
.str219: db 100,119,111,114,100,32,0
section .text
    lea rax, [rel .str219]
    push rax
    pop rdx
    pop rcx
    mov r8, 6
    sub rsp, 32
    call ks_memeq
    add rsp, 32
    cmp rax, 1
    jne .L217
    mov rax, 4
    mov [rel __g_kasm_op_size], rax
    mov rax, 6
    jmp .__ret_204
    jmp .L218
.L217:
.L218:
    mov rax, 0
    jmp .__ret_204
    jmp .L216
.L215:
.L216:
    cmp rbx, 119
    jne .L220
    mov rax, r12
    push rax
section .data
.str224: db 119,111,114,100,32,0
section .text
    lea rax, [rel .str224]
    push rax
    pop rdx
    pop rcx
    mov r8, 5
    sub rsp, 32
    call ks_memeq
    add rsp, 32
    cmp rax, 1
    jne .L222
    mov rax, 2
    mov [rel __g_kasm_op_size], rax
    mov rax, 5
    jmp .__ret_204
    jmp .L223
.L222:
.L223:
    jmp .L221
.L220:
.L221:
    mov rax, 0
    jmp .__ret_204
.__ret_204:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_has_op:
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
    call ks_b
    add rsp, 32
    mov rbx, rax
.L226:
    cmp rbx, 0
    je .L227
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L241
    mov rax, rbx
    mov rcx, 42
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L241
    mov rax, 0
    jmp .L242
.L241:
    mov rax, 1
.L242:
    test rax, rax
    jnz .L239
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L239
    mov rax, 0
    jmp .L240
.L239:
    mov rax, 1
.L240:
    test rax, rax
    jnz .L237
    mov rax, rbx
    mov rcx, 38
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L237
    mov rax, 0
    jmp .L238
.L237:
    mov rax, 1
.L238:
    test rax, rax
    jnz .L235
    mov rax, rbx
    mov rcx, 124
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L235
    mov rax, 0
    jmp .L236
.L235:
    mov rax, 1
.L236:
    test rax, rax
    jnz .L233
    mov rax, rbx
    mov rcx, 60
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L233
    mov rax, 0
    jmp .L234
.L233:
    mov rax, 1
.L234:
    test rax, rax
    jnz .L231
    mov rax, rbx
    mov rcx, 62
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L231
    mov rax, 0
    jmp .L232
.L231:
    mov rax, 1
.L232:
    test rax, rax
    jz .L229
    mov rax, 1
    jmp .__ret_225
    jmp .L230
.L229:
.L230:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L245
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L245
    mov rax, 1
    jmp .L246
.L245:
    mov rax, 0
.L246:
    test rax, rax
    jz .L243
    mov rax, 1
    jmp .__ret_225
    jmp .L244
.L243:
.L244:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L251
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L251
    mov rax, 1
    jmp .L252
.L251:
    mov rax, 0
.L252:
    test rax, rax
    jz .L249
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L249
    mov rax, 1
    jmp .L250
.L249:
    mov rax, 0
.L250:
    test rax, rax
    jz .L247
    mov rax, 1
    jmp .__ret_225
    jmp .L248
.L247:
.L248:
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L228:
    jmp .L226
.L227:
    mov rax, 0
    jmp .__ret_225
.__ret_225:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_po_imm:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_kasm_po_val], rax
    mov rax, 2
    jmp .__ret_253
.__ret_253:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_parse_operand:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov rbx, rcx
    mov rax, rbx
    mov r13, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_cur_addend], rax
    cmp r13, 0
    je .L255
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_size_kw
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    jmp .L256
.L255:
.L256:
    cmp r13, 0
    jne .L257
    mov rax, 0
    mov [rel __g_kasm_po_val], rax
    mov rax, 0
    jmp .__ret_254
    jmp .L258
.L257:
.L258:
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L259
    mov rax, 0
    mov [rel __g_kasm_po_val], rax
    mov rax, 0
    jmp .__ret_254
    jmp .L260
.L259:
.L260:
    cmp r14, 91
    jne .L261
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_mem
    add rsp, 32
    jmp .__ret_254
    jmp .L262
.L261:
.L262:
    mov rax, r14
    mov rcx, 126
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L265
    mov rax, r14
    mov rcx, 40
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L265
    mov rax, 0
    jmp .L266
.L265:
    mov rax, 1
.L266:
    test rax, rax
    jz .L263
    mov rcx, r13
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L264
.L263:
.L264:
    cmp r14, 39
    jne .L267
    mov rax, r13
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 39
    jne .L269
    mov rax, r13
    add rax, 3
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call ks_has_op
    add rsp, 32
    cmp rax, 1
    jne .L271
    mov rcx, r13
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L272
.L271:
.L272:
    jmp .L270
.L269:
.L270:
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r14, rax
.L273:
    mov rax, r14
    mov rcx, 39
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L276
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L276
    mov rax, 1
    jmp .L277
.L276:
    mov rax, 0
.L277:
    test rax, rax
    jz .L274
    cmp rbx, 0
    je .L278
    mov rax, r12
    push rax
    mov rax, r14
    imul rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    mov rcx, 256
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rbx, rax
    jmp .L279
.L278:
.L279:
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r14, rax
.L275:
    jmp .L273
.L274:
    mov rcx, r12
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L268
.L267:
.L268:
    mov rax, r14
    mov rbx, rax
    cmp r14, 45
    jne .L280
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    jmp .L281
.L280:
.L281:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L284
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L284
    mov rax, 1
    jmp .L285
.L284:
    mov rax, 0
.L285:
    test rax, rax
    jz .L282
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
    call ks_has_op
    add rsp, 32
    cmp rax, 1
    jne .L286
    mov rcx, r13
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L287
.L286:
.L287:
    mov rcx, r13
    sub rsp, 32
    call ks_parse_number
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L283
.L282:
.L283:
    mov rax, r13
    push rax
    mov rcx, 64
    sub rsp, 32
    call ks_reg_table
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_match_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L288
    mov rax, rbx
    mov [rel __g_kasm_po_val], rax
    mov rax, 1
    jmp .__ret_254
    jmp .L289
.L288:
.L289:
    mov rcx, r13
    sub rsp, 32
    call ks_xmm_num
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L290
    mov rax, rbx
    mov [rel __g_kasm_po_val], rax
    mov rax, 6
    jmp .__ret_254
    jmp .L291
.L290:
.L291:
    mov rax, r13
    push rax
    mov rcx, 8
    sub rsp, 32
    call ks_reg_table
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_match_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L292
    mov rax, rbx
    mov [rel __g_kasm_po_val], rax
    mov rax, 7
    jmp .__ret_254
    jmp .L293
.L292:
.L293:
    mov rax, r13
    push rax
    mov rcx, 32
    sub rsp, 32
    call ks_reg_table
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_match_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L294
    mov rax, rbx
    mov [rel __g_kasm_po_val], rax
    mov rax, 8
    jmp .__ret_254
    jmp .L295
.L294:
.L295:
    mov rax, r13
    push rax
    mov rcx, 16
    sub rsp, 32
    call ks_reg_table
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_match_reg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L296
    mov rax, rbx
    mov [rel __g_kasm_po_val], rax
    mov rax, 10
    jmp .__ret_254
    jmp .L297
.L296:
.L297:
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
    call ks_has_op
    add rsp, 32
    cmp rax, 1
    jne .L298
    mov rcx, r13
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L299
.L298:
.L299:
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_equ
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L300
    lea rax, [rel __g_kasm_equ_value]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_po_imm
    add rsp, 32
    jmp .__ret_254
    jmp .L301
.L300:
.L301:
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qualify_label
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_qual_len]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_po_val], rax
    mov rax, 4
    jmp .__ret_254
.__ret_254:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
ks_xmm_num:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L307
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 109
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L307
    mov rax, 0
    jmp .L308
.L307:
    mov rax, 1
.L308:
    test rax, rax
    jnz .L305
    mov rax, r13
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 109
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L305
    mov rax, 0
    jmp .L306
.L305:
    mov rax, 1
.L306:
    test rax, rax
    jz .L303
    mov rax, 1
    neg rax
    jmp .__ret_302
    jmp .L304
.L303:
.L304:
    mov rax, r13
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    sub rax, 48
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov r12, rax
    mov rcx, 9
    mov rdx, r12
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L309
    mov rax, 1
    neg rax
    jmp .__ret_302
    jmp .L310
.L309:
.L310:
    mov rax, r13
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L311
    mov rax, r12
    jmp .__ret_302
    jmp .L312
.L311:
.L312:
    mov rax, rbx
    sub rax, 48
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rbx, rax
    mov rcx, 9
    mov rdx, rbx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L315
    mov rax, r13
    add rax, 5
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L315
    mov rax, 0
    jmp .L316
.L315:
    mov rax, 1
.L316:
    test rax, rax
    jz .L313
    mov rax, 1
    neg rax
    jmp .__ret_302
    jmp .L314
.L313:
.L314:
    mov rax, r12
    mov rcx, 10
    imul rax, rcx
    add rax, rbx
    mov r12, rax
    cmp r12, 15
    jle .L317
    mov rax, 1
    neg rax
    jmp .__ret_302
    jmp .L318
.L317:
.L318:
    mov rax, r12
    jmp .__ret_302
.__ret_302:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_po_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r14, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    push rax
section .data
.str322: db 114,101,108,32,0
section .text
    lea rax, [rel .str322]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
    call ks_memeq
    add rsp, 32
    cmp rax, 1
    jne .L320
    add r14, 4
    mov rax, 0
    mov [rel __g_kasm_cur_addend], rax
    mov rcx, r14
    sub rsp, 32
    call ks_len_until_plus_or_bracket
    add rsp, 32
    mov r12, rax
    mov rax, r14
    add rax, r12
    mov rbx, rax
    mov rax, rbx
    mov [rel __g_kasm_po_r8], rax
.L323:
    mov rcx, rbx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 32
    jne .L324
    add rbx, 1
.L325:
    jmp .L323
.L324:
    mov rax, rbx
    mov [rel __g_kasm_po_r8], rax
    mov rcx, rbx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 45
    jne .L326
    mov rax, 0
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_cur_addend], rax
    jmp .L327
.L326:
    mov rcx, rbx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 43
    jne .L328
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_cur_addend], rax
    jmp .L329
.L328:
.L329:
.L327:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_qualify_label
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_qual_len]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_po_val], rax
    mov rax, 5
    jmp .__ret_319
    jmp .L321
.L320:
.L321:
    mov rax, r14
    push rax
    mov rcx, 64
    sub rsp, 32
    call ks_reg_table
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_match_reg_prefix
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L330
    mov rax, 0
    mov [rel __g_kasm_po_val], rax
    mov rax, 0
    jmp .__ret_319
    jmp .L331
.L330:
.L331:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_po_ecx]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 45
    jne .L332
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov [rel __g_kasm_po_val], rax
    cmp r13, 5
    jne .L334
    mov rax, 3
    jmp .__ret_319
    jmp .L335
.L334:
.L335:
    mov rax, r13
    mov [rel __g_kasm_po_r8], rax
    mov rax, 13
    jmp .__ret_319
    jmp .L333
.L332:
.L333:
    cmp rbx, 43
    je .L336
    cmp rbx, 93
    je .L338
    mov rax, 0
    mov [rel __g_kasm_po_val], rax
    mov rax, 0
    jmp .__ret_319
    jmp .L339
.L338:
.L339:
    mov rax, r13
    mov [rel __g_kasm_po_val], rax
    mov rax, 9
    jmp .__ret_319
    jmp .L337
.L336:
.L337:
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    sub rax, 1
    mov r14, rax
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 114
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L342
    mov rax, rbx
    mov rcx, 101
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L342
    mov rax, 0
    jmp .L343
.L342:
    mov rax, 1
.L343:
    test rax, rax
    jz .L340
    add r14, 1
    mov rax, r14
    push rax
    mov rcx, 64
    sub rsp, 32
    call ks_reg_table
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_match_reg_prefix
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L344
    mov rax, 0
    mov [rel __g_kasm_po_val], rax
    mov rax, 0
    jmp .__ret_319
    jmp .L345
.L344:
.L345:
    mov rax, rbx
    shl rax, 8
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L346:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L351
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L351
    mov rax, 1
    jmp .L352
.L351:
    mov rax, 0
.L352:
    test rax, rax
    jnz .L349
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L353
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L353
    mov rax, 1
    jmp .L354
.L353:
    mov rax, 0
.L354:
    test rax, rax
    jnz .L349
    mov rax, 0
    jmp .L350
.L349:
    mov rax, 1
.L350:
    test rax, rax
    jz .L347
    add r14, 1
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L348:
    jmp .L346
.L347:
    cmp rbx, 42
    jne .L355
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 50
    jne .L357
    or r12, 0x10000
    jmp .L358
.L357:
    cmp rbx, 52
    jne .L359
    or r12, 0x20000
    jmp .L360
.L359:
    cmp rbx, 56
    jne .L361
    or r12, 0x30000
    jmp .L362
.L361:
.L362:
.L360:
.L358:
    jmp .L356
.L355:
.L356:
    mov rax, 0
    mov [rel __g_kasm_sib_disp], rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L363:
    mov rax, rbx
    mov rcx, 42
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L368
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L370
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L370
    mov rax, 1
    jmp .L371
.L370:
    mov rax, 0
.L371:
    test rax, rax
    jnz .L368
    mov rax, 0
    jmp .L369
.L368:
    mov rax, 1
.L369:
    test rax, rax
    jnz .L366
    mov rax, rbx
    or rax, 32
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L372
    mov rax, rbx
    or rax, 32
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L372
    mov rax, 1
    jmp .L373
.L372:
    mov rax, 0
.L373:
    test rax, rax
    jnz .L366
    mov rax, 0
    jmp .L367
.L366:
    mov rax, 1
.L367:
    test rax, rax
    jz .L364
    add r14, 1
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L365:
    jmp .L363
.L364:
    mov rcx, r14
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 43
    jne .L374
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_sib_disp], rax
    jmp .L375
.L374:
    cmp rbx, 45
    jne .L376
    mov rax, 0
    push rax
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_sib_disp], rax
    jmp .L377
.L376:
.L377:
.L375:
    mov rax, r12
    mov [rel __g_kasm_po_val], rax
    mov rax, 12
    jmp .__ret_319
    jmp .L341
.L340:
.L341:
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov r12, rax
    cmp r13, 4
    jne .L378
    mov rcx, r12
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_po_val], rax
    mov rax, 11
    jmp .__ret_319
    jmp .L379
.L378:
.L379:
    mov rax, 0
    sub rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov [rel __g_kasm_po_val], rax
    cmp r13, 5
    jne .L380
    mov rax, 3
    jmp .__ret_319
    jmp .L381
.L380:
.L381:
    mov rax, r13
    mov [rel __g_kasm_po_r8], rax
    mov rax, 13
    jmp .__ret_319
.__ret_319:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
ks_reg_table:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 64
    jne .L383
section .data
.str385: db 114,97,120,0,0,114,99,120,0,0,114,100,120,0,0,114,98,120,0,0,114,115,112,0,0,114,98,112,0,0,114,115,105,0,0,114,100,105,0,0,114,56,0,0,0,114,57,0,0,0,114,49,48,0,0,114,49,49,0,0,114,49,50,0
    db 0,114,49,51,0,0,114,49,52,0,0,114,49,53,0
section .text
    lea rax, [rel .str385]
    jmp .__ret_382
    jmp .L384
.L383:
.L384:
    cmp rbx, 32
    jne .L386
section .data
.str388: db 101,97,120,0,0,101,99,120,0,0,101,100,120,0,0,101,98,120,0,0,101,115,112,0,0,101,98,112,0,0,101,115,105,0,0,101,100,105,0,0,114,56,100,0,0,114,57,100,0,0,114,49,48,100,0,114,49,49,100,0,114,49,50,100
    db 0,114,49,51,100,0,114,49,52,100,0,114,49,53,100,0
section .text
    lea rax, [rel .str388]
    jmp .__ret_382
    jmp .L387
.L386:
.L387:
    cmp rbx, 8
    jne .L389
section .data
.str391: db 97,108,0,0,0,99,108,0,0,0,100,108,0,0,0,98,108,0,0,0,115,112,108,0,0,98,112,108,0,0,115,105,108,0,0,100,105,108,0,0,114,56,98,0,0,114,57,98,0,0,114,49,48,98,0,114,49,49,98,0,114,49,50,98
    db 0,114,49,51,98,0,114,49,52,98,0,114,49,53,98,0
section .text
    lea rax, [rel .str391]
    jmp .__ret_382
    jmp .L390
.L389:
.L390:
    cmp rbx, 16
    jne .L392
section .data
.str394: db 97,120,0,0,0,99,120,0,0,0,100,120,0,0,0,98,120,0,0,0,115,112,0,0,0,98,112,0,0,0,115,105,0,0,0,100,105,0,0,0,114,56,119,0,0,114,57,119,0,0,114,49,48,119,0,114,49,49,119,0,114,49,50,119
    db 0,114,49,51,119,0,114,49,52,119,0,114,49,53,119,0
section .text
    lea rax, [rel .str394]
    jmp .__ret_382
    jmp .L393
.L392:
.L393:
section .data
.str395: db 120,109,109,48,0,120,109,109,49,0,120,109,109,50,0,120,109,109,51,0,120,109,109,52,0,120,109,109,53,0,120,109,109,54,0,120,109,109,55,0
section .text
    lea rax, [rel .str395]
    jmp .__ret_382
.__ret_382:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_match_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    mov r8, 16
    sub rsp, 32
    call ks_match_reg_n
    add rsp, 32
    jmp .__ret_396
.__ret_396:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_match_reg_n:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L398:
    mov rcx, r15
    mov rdx, [rbp-24]
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L399
    mov rax, r15
    mov rcx, 5
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-16]
    add rax, rcx
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov rbx, rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L401:
    cmp r12, 0
    je .L402
    mov rax, r12
    push rax
    mov rax, [rbp-8]
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L404
    mov rax, 0
    mov rbx, rax
    jmp .L402
    jmp .L405
.L404:
.L405:
    add r13, 1
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L403:
    jmp .L401
.L402:
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L408
    mov rax, [rbp-8]
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L408
    mov rax, 1
    jmp .L409
.L408:
    mov rax, 0
.L409:
    test rax, rax
    jz .L406
    mov rax, r15
    jmp .__ret_397
    jmp .L407
.L406:
.L407:
    add r15, 1
.L400:
    jmp .L398
.L399:
    mov rax, 1
    neg rax
    jmp .__ret_397
.__ret_397:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ks_match_reg_prefix:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L411:
    cmp r15, 16
    jge .L412
    mov rax, r15
    mov rcx, 5
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-16]
    add rax, rcx
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov rbx, rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L414:
    cmp r12, 0
    je .L415
    mov rax, r12
    push rax
    mov rax, [rbp-8]
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L417
    mov rax, 0
    mov rbx, rax
    jmp .L415
    jmp .L418
.L417:
.L418:
    add r13, 1
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L416:
    jmp .L414
.L415:
    cmp rbx, 1
    jne .L419
    mov rax, r13
    mov [rel __g_kasm_po_ecx], rax
    mov rax, r15
    jmp .__ret_410
    jmp .L420
.L419:
.L420:
    add r15, 1
.L413:
    jmp .L411
.L412:
    mov rax, 0
    mov [rel __g_kasm_po_ecx], rax
    mov rax, 1
    neg rax
    jmp .__ret_410
.__ret_410:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ks_parse_float:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    movups [rbp-136], xmm6
    movups [rbp-120], xmm7
    mov rbx, rcx
    mov rax, rbx
    mov r15, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-72], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    cvtsi2sd xmm0, rax
    movaps xmm7, xmm0
    mov rax, 0
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 45
    jne .L422
    mov rax, 1
    mov [rbp-24], rax
    add r15, 1
    jmp .L423
.L422:
.L423:
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L424:
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L427
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
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
    mov rax, r14
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, r12
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L426:
    jmp .L424
.L425:
    mov rax, r14
    cvtsi2sd xmm0, rax
    movaps xmm7, xmm0
    cmp r12, 46
    jne .L429
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L431:
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L434
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L434
    mov rax, 1
    jmp .L435
.L434:
    mov rax, 0
.L435:
    test rax, rax
    jz .L432
    mov rax, [rbp-56]
    cmp rax, 17
    jge .L436
    mov rax, r13
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, r12
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, [rbp-48]
    mov rcx, 10
    imul rax, rcx
    mov [rbp-48], rax
    mov rax, [rbp-56]
    add rax, 1
    mov [rbp-56], rax
    jmp .L437
.L436:
.L437:
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L433:
    jmp .L431
.L432:
    cmp r13, 0
    je .L438
    mov rax, r13
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L439
.L438:
.L439:
    jmp .L430
.L429:
.L430:
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rcx, 101
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L442
    mov rax, r12
    mov rcx, 69
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L442
    mov rax, 0
    jmp .L443
.L442:
    mov rax, 1
.L443:
    test rax, rax
    jz .L440
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 43
    jne .L444
    add r15, 1
    jmp .L445
.L444:
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 45
    jne .L446
    mov rax, 1
    mov [rbp-72], rax
    add r15, 1
    jmp .L447
.L446:
.L447:
.L445:
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L448:
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L451
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L451
    mov rax, 1
    jmp .L452
.L451:
    mov rax, 0
.L452:
    test rax, rax
    jz .L449
    mov rax, rbx
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, r12
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rbx, rax
    add r15, 1
    mov rcx, rbx
    mov rdx, 400
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 0
    jne .L453
    mov rax, 400
    mov rbx, rax
    jmp .L454
.L453:
.L454:
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
.L450:
    jmp .L448
.L449:
    mov rax, 10
    mov r14, rax
    mov rax, r14
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
.L455:
    cmp rbx, 0
    je .L456
    mov rax, [rbp-72]
    cmp rax, 0
    je .L458
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L459
.L458:
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
.L459:
    sub rbx, 1
.L457:
    jmp .L455
.L456:
    jmp .L441
.L440:
.L441:
    mov rax, [rbp-24]
    cmp rax, 0
    je .L460
    mov rax, 0
    mov r14, rax
    mov rax, r14
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L461
.L460:
.L461:
    movaps xmm0, xmm7
    movsd [rel __g_kasm_pf_val], xmm0
    lea rax, [rel __g_kasm_pf_val]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_421
.__ret_421:
    mov rbx, [rbp-176]
    mov r12, [rbp-168]
    mov r13, [rbp-160]
    mov r14, [rbp-152]
    mov r15, [rbp-144]
    movups xmm6, [rbp-136]
    movups xmm7, [rbp-120]
    mov rsp, rbp
    pop rbp
    ret
ks_parse_number:
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
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 45
    jne .L463
    mov rax, 1
    mov r13, rax
    add r14, 1
    jmp .L464
.L463:
.L464:
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L467
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L469
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 88
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L469
    mov rax, 0
    jmp .L470
.L469:
    mov rax, 1
.L470:
    test rax, rax
    jz .L467
    mov rax, 1
    jmp .L468
.L467:
    mov rax, 0
.L468:
    test rax, rax
    jz .L465
    add r14, 2
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L471:
    mov rax, 1
    cmp rax, 1
    jne .L472
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L476
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L476
    mov rax, 1
    jmp .L477
.L476:
    mov rax, 0
.L477:
    test rax, rax
    jz .L474
    sub rbx, 48
    jmp .L475
.L474:
    or rbx, 32
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L480
    mov rax, rbx
    mov rcx, 102
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L480
    mov rax, 0
    jmp .L481
.L480:
    mov rax, 1
.L481:
    test rax, rax
    jz .L478
    jmp .L472
    jmp .L479
.L478:
.L479:
    sub rbx, 87
.L475:
    mov rax, r12
    shl rax, 4
    add rax, rbx
    mov r12, rax
    add r14, 1
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L473:
    jmp .L471
.L472:
    jmp .L466
.L465:
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L482:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L485
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
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
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L484:
    jmp .L482
.L483:
.L466:
    cmp r13, 0
    je .L487
    mov rax, 0
    sub rax, r12
    mov r12, rax
    jmp .L488
.L487:
.L488:
    mov rax, r12
    jmp .__ret_462
.__ret_462:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ks_parse_expr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_ex_or
    add rsp, 32
    jmp .__ret_489
.__ret_489:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_or:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call ks_ex_and
    add rsp, 32
    mov rbx, rax
.L491:
    mov rax, 1
    cmp rax, 1
    jne .L492
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 124
    je .L494
    mov rax, rbx
    jmp .__ret_490
    jmp .L495
.L494:
.L495:
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ks_ex_and
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
.L493:
    jmp .L491
.L492:
    mov rax, rbx
    jmp .__ret_490
.__ret_490:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_and:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call ks_ex_shift
    add rsp, 32
    mov rbx, rax
.L497:
    mov rax, 1
    cmp rax, 1
    jne .L498
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 38
    je .L500
    mov rax, rbx
    jmp .__ret_496
    jmp .L501
.L500:
.L501:
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ks_ex_shift
    add rsp, 32
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
.L499:
    jmp .L497
.L498:
    mov rax, rbx
    jmp .__ret_496
.__ret_496:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    sub rsp, 32
    call ks_ex_addsub
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
.L503:
    mov rax, 1
    cmp rax, 1
    jne .L504
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 60
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L508
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 60
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L508
    mov rax, 1
    jmp .L509
.L508:
    mov rax, 0
.L509:
    test rax, rax
    jz .L506
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 2
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_ex_addsub
    add rsp, 32
    and rax, 63
    mov rbx, rax
    mov rax, r12
    mov rcx, rbx
    shl rax, cl
    mov r12, rax
    jmp .L507
.L506:
    mov rax, rbx
    mov rcx, 62
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L512
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 62
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L512
    mov rax, 1
    jmp .L513
.L512:
    mov rax, 0
.L513:
    test rax, rax
    jz .L510
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 2
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_ex_addsub
    add rsp, 32
    and rax, 63
    mov rbx, rax
    mov rax, r12
    mov rcx, rbx
    sar rax, cl
    mov r12, rax
    jmp .L511
.L510:
    mov rax, r12
    jmp .__ret_502
.L511:
.L507:
.L505:
    jmp .L503
.L504:
    mov rax, r12
    jmp .__ret_502
.__ret_502:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_skipws:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L515:
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L518
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L518
    mov rax, 0
    jmp .L519
.L518:
    mov rax, 1
.L519:
    test rax, rax
    jz .L516
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L517:
    jmp .L515
.L516:
    mov rax, 0
    jmp .__ret_514
.__ret_514:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_addsub:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    sub rsp, 32
    call ks_ex_muldiv
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L521:
    mov rax, 1
    cmp rax, 1
    jne .L522
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 43
    jne .L524
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ks_ex_muldiv
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L525
.L524:
    cmp rbx, 45
    jne .L526
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ks_ex_muldiv
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov r12, rax
    jmp .L527
.L526:
    mov rax, r12
    jmp .__ret_520
.L527:
.L525:
.L523:
    jmp .L521
.L522:
    mov rax, r12
    jmp .__ret_520
.__ret_520:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_muldiv:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    sub rsp, 32
    call ks_ex_primary
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
.L529:
    mov rax, 1
    cmp rax, 1
    jne .L530
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 42
    jne .L532
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ks_ex_primary
    add rsp, 32
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov r12, rax
    jmp .L533
.L532:
    cmp rbx, 47
    jne .L534
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_ex_primary
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L536
    mov rax, r12
    mov rcx, rbx
    cqo
    idiv rcx
    mov r12, rax
    jmp .L537
.L536:
.L537:
    jmp .L535
.L534:
    mov rax, r12
    jmp .__ret_528
.L535:
.L533:
.L531:
    jmp .L529
.L530:
    mov rax, r12
    jmp .__ret_528
.__ret_528:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_primary:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r15, rax
    cmp r15, 40
    jne .L539
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_ex_addsub
    add rsp, 32
    mov r14, rax
    sub rsp, 32
    call ks_ex_skipws
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 41
    jne .L541
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    jmp .L542
.L541:
.L542:
    mov rax, r14
    jmp .__ret_538
    jmp .L540
.L539:
.L540:
    cmp r15, 36
    jne .L543
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_here
    add rsp, 32
    jmp .__ret_538
    jmp .L544
.L543:
.L544:
    cmp r15, 39
    jne .L545
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r15, rax
.L547:
    mov rax, r15
    mov rcx, 39
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L552
    mov rax, r15
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L552
    mov rax, 1
    jmp .L553
.L552:
    mov rax, 0
.L553:
    test rax, rax
    jz .L550
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L550
    mov rax, 1
    jmp .L551
.L550:
    mov rax, 0
.L551:
    test rax, rax
    jz .L548
    cmp rbx, 4
    jge .L554
    mov rax, r14
    push rax
    mov rax, r15
    imul rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov r14, rax
    mov rax, r12
    mov rcx, 256
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    mov r12, rax
    jmp .L555
.L554:
.L555:
    add rbx, 1
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r15, rax
.L549:
    jmp .L547
.L548:
    mov rax, r13
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, r14
    jmp .__ret_538
    jmp .L546
.L545:
.L546:
    cmp r15, 45
    jne .L556
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, 0
    push rax
    sub rsp, 32
    call ks_ex_primary
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    jmp .__ret_538
    jmp .L557
.L556:
.L557:
    cmp r15, 126
    jne .L558
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    sub rsp, 32
    call ks_ex_primary
    add rsp, 32
    not rax
    jmp .__ret_538
    jmp .L559
.L558:
.L559:
    mov rax, r15
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L562
    mov rax, r15
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L562
    mov rax, 1
    jmp .L563
.L562:
    mov rax, 0
.L563:
    test rax, rax
    jz .L560
    sub rsp, 32
    call ks_ex_number
    add rsp, 32
    jmp .__ret_538
    jmp .L561
.L560:
.L561:
    sub rsp, 32
    call ks_ex_symbol
    add rsp, 32
    jmp .__ret_538
.__ret_538:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_number:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L567
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L569
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 88
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L569
    mov rax, 0
    jmp .L570
.L569:
    mov rax, 1
.L570:
    test rax, rax
    jz .L567
    mov rax, 1
    jmp .L568
.L567:
    mov rax, 0
.L568:
    test rax, rax
    jz .L565
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 2
    mov [rel __g_kasm_expr_ptr], rax
.L571:
    mov rax, 1
    cmp rax, 1
    jne .L572
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L576
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L576
    mov rax, 1
    jmp .L577
.L576:
    mov rax, 0
.L577:
    test rax, rax
    jz .L574
    sub rbx, 48
    jmp .L575
.L574:
    or rbx, 32
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L580
    mov rax, rbx
    mov rcx, 102
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L580
    mov rax, 0
    jmp .L581
.L580:
    mov rax, 1
.L581:
    test rax, rax
    jz .L578
    mov rax, r12
    jmp .__ret_564
    jmp .L579
.L578:
.L579:
    sub rbx, 87
.L575:
    mov rax, r12
    shl rax, 4
    add rax, rbx
    mov r12, rax
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
.L573:
    jmp .L571
.L572:
    jmp .L566
.L565:
.L566:
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L582:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L585
    mov rax, rbx
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
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, 1
    mov [rel __g_kasm_expr_ptr], rax
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L584:
    jmp .L582
.L583:
    mov rax, r12
    jmp .__ret_564
.__ret_564:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_ex_symbol:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rax, [rel __g_kasm_expr_ptr]
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L588:
    mov rax, r13
    mov rcx, 95
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L595
    mov rax, r13
    mov rcx, 46
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L595
    mov rax, 0
    jmp .L596
.L595:
    mov rax, 1
.L596:
    test rax, rax
    jnz .L593
    mov rax, r13
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L597
    mov rax, r13
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L597
    mov rax, 1
    jmp .L598
.L597:
    mov rax, 0
.L598:
    test rax, rax
    jnz .L593
    mov rax, 0
    jmp .L594
.L593:
    mov rax, 1
.L594:
    test rax, rax
    jnz .L591
    mov rax, r13
    or rax, 32
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L599
    mov rax, r13
    or rax, 32
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L599
    mov rax, 1
    jmp .L600
.L599:
    mov rax, 0
.L600:
    test rax, rax
    jnz .L591
    mov rax, 0
    jmp .L592
.L591:
    mov rax, 1
.L592:
    test rax, rax
    jz .L589
    add r14, 1
    mov rax, r15
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r13, rax
.L590:
    jmp .L588
.L589:
    mov rax, [rel __g_kasm_expr_ptr]
    add rax, r14
    mov [rel __g_kasm_expr_ptr], rax
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call ks_find_equ
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L601
    lea rax, [rel __g_kasm_equ_value]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_587
    jmp .L602
.L601:
.L602:
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call ks_qualify_label
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_qual_len]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L603
    mov rax, 0
    jmp .__ret_587
    jmp .L604
.L603:
.L604:
    lea rax, [rel __g_kasm_lbl_addr]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_kasm_lbl_section]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L605
    mov rax, [rel __g_kasm_kasm_org_set]
    cmp rax, 0
    jne .L607
    mov rax, r12
    jmp .__ret_587
    jmp .L608
.L607:
.L608:
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_p1_data_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    cmp rbx, 1
    je .L609
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_p1_data_base]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_kasm_p1_bss_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L610
.L609:
.L610:
    jmp .L606
.L605:
.L606:
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_kasm_org]
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_587
.__ret_587:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_find_equ:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L612:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_equ_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L613
    lea rax, [rel __g_kasm_equ_names]
    push rax
    lea rax, [rel __g_kasm_equ_name_off]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L615:
    cmp r12, r15
    je .L616
    mov rax, [rbp-8]
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L618
    mov rax, 0
    mov rbx, rax
    jmp .L616
    jmp .L619
.L618:
.L619:
    add r12, 1
.L617:
    jmp .L615
.L616:
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L622
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
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
    mov rax, r14
    jmp .__ret_611
    jmp .L621
.L620:
.L621:
    add r14, 1
.L614:
    jmp .L612
.L613:
    mov rax, 1
    neg rax
    jmp .__ret_611
.__ret_611:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_add_equ:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov r14, r8
    mov rcx, [rbp-8]
    mov rdx, r15
    sub rsp, 32
    call ks_find_equ
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L625
    lea rax, [rel __g_kasm_equ_value]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r14
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, 0
    jmp .__ret_624
    jmp .L626
.L625:
.L626:
    mov rax, [rel __g_kasm_equ_count]
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_KASM_EQU_MAX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L629
    mov rax, [rel __g_kasm_equ_names_len]
    add rax, r15
    add rax, 2
    push rax
    mov rax, [rel __g_kasm_KASM_EQU_NAMES]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L629
    mov rax, 0
    jmp .L630
.L629:
    mov rax, 1
.L630:
    test rax, rax
    jz .L627
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, 0
    jmp .__ret_624
    jmp .L628
.L627:
.L628:
    lea rax, [rel __g_kasm_equ_name_off]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_equ_names_len]
    push rax
    pop rcx
    sub rsp, 32
    call ks_u32
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qs
    add rsp, 32
    lea rax, [rel __g_kasm_equ_names]
    push rax
    mov rax, [rel __g_kasm_equ_names_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
.L631:
    cmp rbx, r15
    je .L632
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, [rbp-8]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add rbx, 1
.L633:
    jmp .L631
.L632:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, [rel __g_kasm_equ_names_len]
    add rax, rbx
    add rax, 1
    mov [rel __g_kasm_equ_names_len], rax
    lea rax, [rel __g_kasm_equ_value]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r14
    sub rsp, 32
    call ks_qs
    add rsp, 32
    mov rax, r13
    add rax, 1
    mov [rel __g_kasm_equ_count], rax
    mov rax, 0
    jmp .__ret_624
.__ret_624:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_strlen:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L635:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 0
    je .L636
    add rbx, 1
.L637:
    jmp .L635
.L636:
    mov rax, rbx
    jmp .__ret_634
.__ret_634:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_len_until_plus_or_bracket:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L639:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L648
    mov rax, rbx
    mov rcx, 93
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L648
    mov rax, 1
    jmp .L649
.L648:
    mov rax, 0
.L649:
    test rax, rax
    jz .L646
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L646
    mov rax, 1
    jmp .L647
.L646:
    mov rax, 0
.L647:
    test rax, rax
    jz .L644
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L644
    mov rax, 1
    jmp .L645
.L644:
    mov rax, 0
.L645:
    test rax, rax
    jz .L642
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L642
    mov rax, 1
    jmp .L643
.L642:
    mov rax, 0
.L643:
    test rax, rax
    jz .L640
    add r12, 1
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L641:
    jmp .L639
.L640:
    mov rax, r12
    jmp .__ret_638
.__ret_638:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_skip_blanks:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L651:
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L654
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L654
    mov rax, 0
    jmp .L655
.L654:
    mov rax, 1
.L655:
    test rax, rax
    jz .L652
    add r12, 1
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L653:
    jmp .L651
.L652:
    mov rax, r12
    jmp .__ret_650
.__ret_650:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_trim_trailing:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, r13
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L657:
    cmp r12, 0
    je .L658
    mov rax, r13
    add rax, r12
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L662
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L662
    mov rax, 1
    jmp .L663
.L662:
    mov rax, 0
.L663:
    test rax, rax
    jz .L660
    mov rax, 0
    jmp .__ret_656
    jmp .L661
.L660:
.L661:
    sub r12, 1
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
.L659:
    jmp .L657
.L658:
    mov rax, 0
    jmp .__ret_656
.__ret_656:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_copy_tok:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 1
    mov rbx, rax
.L665:
    cmp rbx, 0
    je .L666
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r13, 1
    add r12, 1
.L667:
    jmp .L665
.L666:
    mov rax, 0
    jmp .__ret_664
.__ret_664:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_is_data_dir:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str671: db 100,98,0
section .text
    lea rax, [rel .str671]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L669
    mov rax, 1
    jmp .__ret_668
    jmp .L670
.L669:
.L670:
    mov rax, rbx
    push rax
section .data
.str674: db 100,113,0
section .text
    lea rax, [rel .str674]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L672
    mov rax, 1
    jmp .__ret_668
    jmp .L673
.L672:
.L673:
    mov rax, rbx
    push rax
section .data
.str677: db 100,119,0
section .text
    lea rax, [rel .str677]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L675
    mov rax, 1
    jmp .__ret_668
    jmp .L676
.L675:
.L676:
    mov rax, rbx
    push rax
section .data
.str680: db 100,100,0
section .text
    lea rax, [rel .str680]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L678
    mov rax, 1
    jmp .__ret_668
    jmp .L679
.L678:
.L679:
    mov rax, rbx
    push rax
section .data
.str683: db 114,101,115,98,0
section .text
    lea rax, [rel .str683]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L681
    mov rax, 1
    jmp .__ret_668
    jmp .L682
.L681:
.L682:
    mov rax, rbx
    push rax
section .data
.str686: db 114,101,115,119,0
section .text
    lea rax, [rel .str686]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L684
    mov rax, 1
    jmp .__ret_668
    jmp .L685
.L684:
.L685:
    mov rax, rbx
    push rax
section .data
.str689: db 114,101,115,100,0
section .text
    lea rax, [rel .str689]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L687
    mov rax, 1
    jmp .__ret_668
    jmp .L688
.L687:
.L688:
    mov rax, rbx
    push rax
section .data
.str692: db 114,101,115,113,0
section .text
    lea rax, [rel .str692]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L690
    mov rax, 1
    jmp .__ret_668
    jmp .L691
.L690:
.L691:
    mov rax, rbx
    push rax
section .data
.str695: db 116,105,109,101,115,0
section .text
    lea rax, [rel .str695]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L693
    mov rax, 1
    jmp .__ret_668
    jmp .L694
.L693:
.L694:
    mov rax, rbx
    push rax
section .data
.str698: db 101,113,117,0
section .text
    lea rax, [rel .str698]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_dir_word
    add rsp, 32
    cmp rax, 1
    jne .L696
    mov rax, 1
    jmp .__ret_668
    jmp .L697
.L696:
.L697:
    mov rax, 0
    jmp .__ret_668
.__ret_668:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_dir_word:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rcx, r13
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r14
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_memeq
    add rsp, 32
    cmp rax, 0
    jne .L700
    mov rax, 0
    jmp .__ret_699
    jmp .L701
.L700:
.L701:
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L704
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L704
    mov rax, 0
    jmp .L705
.L704:
    mov rax, 1
.L705:
    test rax, rax
    jz .L702
    mov rax, 1
    jmp .__ret_699
    jmp .L703
.L702:
.L703:
    mov rax, 0
    jmp .__ret_699
.__ret_699:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_qualify_label:
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
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 46
    je .L707
    mov rax, r14
    mov [rel __g_kasm_qual_len], rax
    mov rax, r15
    jmp .__ret_706
    jmp .L708
.L707:
.L708:
    lea rax, [rel __g_kasm_cur_global]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L709:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L712
    mov rax, r13
    mov rcx, 60
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L712
    mov rax, 1
    jmp .L713
.L712:
    mov rax, 0
.L713:
    test rax, rax
    jz .L710
    lea rax, [rel __g_kasm_qual_buf]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r13, 1
    lea rax, [rel __g_kasm_cur_global]
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L711:
    jmp .L709
.L710:
.L714:
    mov rax, r12
    mov rcx, r14
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L717
    mov rax, r13
    mov rcx, 156
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L717
    mov rax, 1
    jmp .L718
.L717:
    mov rax, 0
.L718:
    test rax, rax
    jz .L715
    lea rax, [rel __g_kasm_qual_buf]
    add rax, r13
    push rax
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r13, 1
    add r12, 1
.L716:
    jmp .L714
.L715:
    lea rax, [rel __g_kasm_qual_buf]
    add rax, r13
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, r13
    mov [rel __g_kasm_qual_len], rax
    lea rax, [rel __g_kasm_qual_buf]
    jmp .__ret_706
.__ret_706:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_str_eq:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
.L720:
    mov rax, 1
    cmp rax, 1
    jne .L721
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L723
    mov rax, 0
    jmp .__ret_719
    jmp .L724
.L723:
.L724:
    cmp rbx, 0
    jne .L725
    mov rax, 1
    jmp .__ret_719
    jmp .L726
.L725:
.L726:
    add r13, 1
    add r12, 1
.L722:
    jmp .L720
.L721:
    mov rax, 0
    jmp .__ret_719
.__ret_719:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_is:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_str_eq
    add rsp, 32
    jmp .__ret_727
.__ret_727:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_copy_operand:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov r14, r8
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L729:
    cmp rbx, 0
    je .L730
    cmp r12, 0
    je .L732
    cmp rbx, r12
    jne .L734
    mov rax, 0
    mov r12, rax
    jmp .L735
.L734:
.L735:
    jmp .L733
.L732:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L738
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L738
    mov rax, 1
    jmp .L739
.L738:
    mov rax, 0
.L739:
    test rax, rax
    jz .L736
    mov rax, r13
    mov [rel __g_kasm_sl_n], rax
    mov rax, r15
    add rax, 1
    jmp .__ret_728
    jmp .L737
.L736:
.L737:
    cmp rbx, 59
    jne .L740
    jmp .L730
    jmp .L741
.L740:
.L741:
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L744
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L744
    mov rax, 0
    jmp .L745
.L744:
    mov rax, 1
.L745:
    test rax, rax
    jz .L742
    mov rax, rbx
    mov r12, rax
    jmp .L743
.L742:
.L743:
.L733:
    cmp r13, 510
    jl .L746
    jmp .L730
    jmp .L747
.L746:
.L747:
    mov rax, [rbp-16]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r13, 1
    add r15, 1
    mov rcx, r15
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L731:
    jmp .L729
.L730:
    mov rax, r13
    mov [rel __g_kasm_sl_n], rax
    mov rax, r15
    jmp .__ret_728
.__ret_728:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_split_line:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rbx, rcx
    mov rax, rbx
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L751
    mov rax, rbx
    mov rcx, 59
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L751
    mov rax, 0
    jmp .L752
.L751:
    mov rax, 1
.L752:
    test rax, rax
    jz .L749
    mov rax, 0
    jmp .__ret_748
    jmp .L750
.L749:
.L750:
.L753:
    mov rax, 1
    cmp rax, 1
    jne .L754
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L760
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L760
    mov rax, 0
    jmp .L761
.L760:
    mov rax, 1
.L761:
    test rax, rax
    jnz .L758
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L758
    mov rax, 0
    jmp .L759
.L758:
    mov rax, 1
.L759:
    test rax, rax
    jz .L756
    jmp .L754
    jmp .L757
.L756:
.L757:
    cmp rbx, 58
    jne .L762
    lea rax, [rel __g_kasm_tok_a]
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_split_label
    add rsp, 32
    jmp .__ret_748
    jmp .L763
.L762:
.L763:
    cmp r12, 62
    jl .L764
    jmp .L754
    jmp .L765
.L764:
.L765:
    lea rax, [rel __g_kasm_tok_a]
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r12, 1
    add r13, 1
.L755:
    jmp .L753
.L754:
    lea rax, [rel __g_kasm_tok_a]
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ks_is_data_dir
    add rsp, 32
    cmp rax, 1
    jne .L766
    mov rcx, rbx
    sub rsp, 32
    call ks_split_label
    add rsp, 32
    jmp .__ret_748
    jmp .L767
.L766:
.L767:
    mov rax, 0
    mov [rel __g_kasm_op_size], rax
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_size_kw
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
    call ks_copy_operand
    add rsp, 32
    mov r13, rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_trim_trailing
    add rsp, 32
    lea rax, [rel __g_kasm_tok_b]
    push rax
    mov rax, [rel __g_kasm_sl_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_trim_trailing
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call ks_copy_operand
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    mov rax, [rel __g_kasm_sl_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_trim_trailing
    add rsp, 32
    mov rax, 0
    jmp .__ret_748
.__ret_748:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_split_label:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L771
    mov rax, rbx
    mov rcx, 59
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L771
    mov rax, 0
    jmp .L772
.L771:
    mov rax, 1
.L772:
    test rax, rax
    jz .L769
    mov rax, 1
    jmp .__ret_768
    jmp .L770
.L769:
.L770:
.L773:
    cmp r12, 510
    jge .L774
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L776
    jmp .L774
    jmp .L777
.L776:
.L777:
    lea rax, [rel __g_kasm_lbl_rest]
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r12, 1
.L775:
    jmp .L773
.L774:
    lea rax, [rel __g_kasm_lbl_rest]
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L778:
    cmp r12, 510
    jge .L779
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L785
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L785
    mov rax, 0
    jmp .L786
.L785:
    mov rax, 1
.L786:
    test rax, rax
    jnz .L783
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L783
    mov rax, 0
    jmp .L784
.L783:
    mov rax, 1
.L784:
    test rax, rax
    jz .L781
    jmp .L779
    jmp .L782
.L781:
.L782:
    lea rax, [rel __g_kasm_tok_b]
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r12, 1
    add r13, 1
.L780:
    jmp .L778
.L779:
    lea rax, [rel __g_kasm_tok_b]
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call ks_copy_operand
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    mov rax, [rel __g_kasm_sl_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_trim_trailing
    add rsp, 32
    mov rax, 2
    jmp .__ret_768
.__ret_768:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_init:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_kasm_org], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_org_set], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_code_len], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_data_len], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_bss_len], rax
    mov rax, 0
    mov [rel __g_kasm_lbl_count], rax
.L788:
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_KASM_HASH_SIZE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L789
    lea rax, [rel __g_kasm_lbl_hash]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call ks_qs
    add rsp, 32
    add rbx, 1
.L790:
    jmp .L788
.L789:
    mov rax, 1
    mov [rel __g_kasm_lbl_names_len], rax
    lea rax, [rel __g_kasm_lbl_names]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    mov [rel __g_kasm_fix_count], rax
    mov rax, 0
    mov [rel __g_kasm_cur_section], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_error], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_line], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_err_line], rax
    mov rax, 0
    mov [rel __g_kasm_err_count], rax
    mov rax, 0
    mov [rel __g_kasm_equ_count], rax
    mov rax, 0
    mov [rel __g_kasm_equ_names_len], rax
    lea rax, [rel __g_kasm_cur_global]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    mov [rel __g_kasm_ext_count], rax
    mov rax, 1
    mov [rel __g_kasm_ext_names_len], rax
    lea rax, [rel __g_kasm_ext_names]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    mov [rel __g_kasm_extref_count], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_bss_len], rax
    mov rax, 0
    jmp .__ret_787
.__ret_787:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_build_image:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_kasm_code_len]
    mov r13, rax
    mov rax, [rel __g_kasm_data_base]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L792:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L793
    lea rax, [rel __g_kasm_kasm_code]
    add rax, r13
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r13, 1
.L794:
    jmp .L792
.L793:
.L795:
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_kasm_data_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L796
    lea rax, [rel __g_kasm_kasm_code]
    add rax, r13
    add rax, rbx
    push rax
    lea rax, [rel __g_kasm_kasm_data]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add rbx, 1
.L797:
    jmp .L795
.L796:
    mov rax, [rel __g_kasm_kasm_org_set]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L800
    mov rax, [rel __g_kasm_kasm_data_len]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L800
    mov rax, 1
    jmp .L801
.L800:
    mov rax, 0
.L801:
    test rax, rax
    jz .L798
    mov rax, [rel __g_kasm_kasm_code_len]
    jmp .__ret_791
    jmp .L799
.L798:
.L799:
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_kasm_data_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_791
.__ret_791:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_assemble:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov [rel __g_kasm_rp_src], rax
    mov rax, rbx
    mov [rel __g_kasm_rp_len], rax
    mov rax, 1
    mov [rel __g_kasm_kasm_pass], rax
    mov rax, 0
    mov [rel __g_kasm_bss_cursor], rax
    sub rsp, 32
    call ks_run_pass
    add rsp, 32
    mov rax, [rel __g_kasm_kasm_code_len]
    add rax, 15
    push rax
    mov rax, 16
    neg rax
    mov rcx, rax
    pop rax
    and rax, rcx
    mov [rel __g_kasm_p1_data_base], rax
    mov rax, [rel __g_kasm_p1_data_base]
    push rax
    mov rax, [rel __g_kasm_kasm_data_len]
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
    mov [rel __g_kasm_p1_bss_base], rax
    mov rax, 2
    mov [rel __g_kasm_kasm_pass], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_code_len], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_data_len], rax
    mov rax, 0
    mov [rel __g_kasm_bss_cursor], rax
    mov rax, 0
    mov [rel __g_kasm_cur_section], rax
    mov rax, 0
    mov [rel __g_kasm_fix_count], rax
    mov rax, 0
    mov [rel __g_kasm_extref_count], rax
    mov rax, 0
    mov [rel __g_kasm_kasm_bss_len], rax
    sub rsp, 32
    call ks_run_pass
    add rsp, 32
    mov rax, [rel __g_kasm_kasm_code_len]
    add rax, 15
    push rax
    mov rax, 16
    neg rax
    mov rcx, rax
    pop rax
    and rax, rcx
    mov [rel __g_kasm_data_base], rax
    mov rax, [rel __g_kasm_data_base]
    push rax
    mov rax, [rel __g_kasm_kasm_data_len]
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
    mov [rel __g_kasm_bss_base], rax
    sub rsp, 32
    call ks_apply_fixups
    add rsp, 32
    sub rsp, 32
    call ks_prune_externs
    add rsp, 32
    mov rax, [rel __g_kasm_kasm_error]
    cmp rax, 0
    je .L803
    mov rax, 0
    jmp .__ret_802
    jmp .L804
.L803:
.L804:
    mov rax, 1
    jmp .__ret_802
.__ret_802:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_run_pass:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, [rel __g_kasm_rp_src]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_kasm_line], rax
    mov rax, [rel __g_kasm_rp_len]
    mov [rel __g_kasm_rp_left], rax
.L806:
    mov rax, [rel __g_kasm_rp_left]
    cmp rax, 0
    je .L807
    mov rax, [rel __g_kasm_kasm_line]
    add rax, 1
    mov [rel __g_kasm_kasm_line], rax
    mov rax, 0
    mov rbx, rax
.L809:
    mov rax, [rel __g_kasm_rp_left]
    cmp rax, 0
    je .L810
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
    add r13, 1
    mov rax, [rel __g_kasm_rp_left]
    sub rax, 1
    mov [rel __g_kasm_rp_left], rax
    cmp r12, 10
    jne .L812
    jmp .L810
    jmp .L813
.L812:
.L813:
    mov rax, r12
    mov rcx, 13
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L816
    mov rax, rbx
    mov rcx, 510
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L816
    mov rax, 1
    jmp .L817
.L816:
    mov rax, 0
.L817:
    test rax, rax
    jz .L814
    lea rax, [rel __g_kasm_line_buf]
    add rax, rbx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add rbx, 1
    jmp .L815
.L814:
.L815:
.L811:
    jmp .L809
.L810:
    lea rax, [rel __g_kasm_line_buf]
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_line_buf]
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
    cmp r12, 37
    je .L818
    cmp r12, 91
    jne .L820
    mov rcx, rbx
    mov rdx, 32
    sub rsp, 32
    call ks_bs
    add rsp, 32
.L822:
    mov rcx, rbx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 0
    je .L823
    mov rcx, rbx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 93
    jne .L825
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    jmp .L823
    jmp .L826
.L825:
.L826:
    add rbx, 1
.L824:
    jmp .L822
.L823:
    jmp .L821
.L820:
.L821:
    lea rax, [rel __g_kasm_line_buf]
    push rax
    pop rcx
    sub rsp, 32
    call ks_split_line
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L827
    mov rcx, rbx
    sub rsp, 32
    call ks_line_label
    add rsp, 32
    jmp .L828
.L827:
    sub rsp, 32
    call ks_line_body
    add rsp, 32
.L828:
    jmp .L819
.L818:
.L819:
.L808:
    jmp .L806
.L807:
    mov rax, 0
    jmp .__ret_805
.__ret_805:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_line_body:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 0
    jne .L830
    mov rax, 0
    jmp .__ret_829
    jmp .L831
.L830:
.L831:
    sub rsp, 32
    call ks_directive
    add rsp, 32
    cmp rax, 0
    je .L832
    mov rax, 0
    jmp .__ret_829
    jmp .L833
.L832:
.L833:
    sub rsp, 32
    call ks_encode_line
    add rsp, 32
    jmp .__ret_829
.__ret_829:
    mov rsp, rbp
    pop rbp
    ret
ks_line_label:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_kasm_tok_a]
    push rax
    lea rax, [rel __g_kasm_last_label]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_copy_tok
    add rsp, 32
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 46
    je .L835
    lea rax, [rel __g_kasm_tok_a]
    push rax
    lea rax, [rel __g_kasm_cur_global]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_copy_tok
    add rsp, 32
    jmp .L836
.L835:
.L836:
    lea rax, [rel __g_kasm_tok_a]
    push rax
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rcx
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_qualify_label
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_qual_len]
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_lbl_is_equ], rax
    cmp r13, 2
    jne .L837
    lea rax, [rel __g_kasm_lbl_rest]
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_is_equ_word
    add rsp, 32
    mov [rel __g_kasm_lbl_is_equ], rax
    jmp .L838
.L837:
.L838:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_add_label
    add rsp, 32
    cmp r13, 2
    je .L839
    mov rax, 0
    jmp .__ret_834
    jmp .L840
.L839:
.L840:
    lea rax, [rel __g_kasm_lbl_rest]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is_data_dir
    add rsp, 32
    cmp rax, 0
    jne .L841
    lea rax, [rel __g_kasm_lbl_rest]
    push rax
    pop rcx
    sub rsp, 32
    call ks_split_line
    add rsp, 32
    sub rsp, 32
    call ks_line_body
    add rsp, 32
    jmp .__ret_834
    jmp .L842
.L841:
.L842:
    lea rax, [rel __g_kasm_tok_b]
    push rax
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_copy_tok
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_copy_tok
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    sub rsp, 32
    call ks_line_body
    add rsp, 32
    jmp .__ret_834
.__ret_834:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_is_equ_word:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    or rax, 32
    mov rcx, 101
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L848
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    or rax, 32
    mov rcx, 113
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L848
    mov rax, 0
    jmp .L849
.L848:
    mov rax, 1
.L849:
    test rax, rax
    jnz .L846
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    or rax, 32
    mov rcx, 117
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L846
    mov rax, 0
    jmp .L847
.L846:
    mov rax, 1
.L847:
    test rax, rax
    jz .L844
    mov rax, 0
    jmp .__ret_843
    jmp .L845
.L844:
.L845:
    mov rax, r12
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L852
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L852
    mov rax, 0
    jmp .L853
.L852:
    mov rax, 1
.L853:
    test rax, rax
    jz .L850
    mov rax, 1
    jmp .__ret_843
    jmp .L851
.L850:
.L851:
    mov rax, 0
    jmp .__ret_843
.__ret_843:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_directive:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str857: db 115,101,99,116,105,111,110,0
section .text
    lea rax, [rel .str857]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L855
    sub rsp, 32
    call ks_d_section
    add rsp, 32
    jmp .__ret_854
    jmp .L856
.L855:
.L856:
section .data
.str860: db 98,105,116,115,0
section .text
    lea rax, [rel .str860]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L858
    mov rax, 1
    jmp .__ret_854
    jmp .L859
.L858:
.L859:
section .data
.str863: db 103,108,111,98,97,108,0
section .text
    lea rax, [rel .str863]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L861
    mov rax, 1
    jmp .__ret_854
    jmp .L862
.L861:
.L862:
section .data
.str866: db 101,120,116,101,114,110,0
section .text
    lea rax, [rel .str866]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L864
    sub rsp, 32
    call ks_d_extern
    add rsp, 32
    jmp .__ret_854
    jmp .L865
.L864:
.L865:
section .data
.str869: db 100,101,102,97,117,108,116,0
section .text
    lea rax, [rel .str869]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L867
    mov rax, 1
    jmp .__ret_854
    jmp .L868
.L867:
.L868:
section .data
.str872: db 100,98,0
section .text
    lea rax, [rel .str872]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L870
    sub rsp, 32
    call ks_d_db
    add rsp, 32
    jmp .__ret_854
    jmp .L871
.L870:
.L871:
section .data
.str875: db 100,113,0
section .text
    lea rax, [rel .str875]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L873
    sub rsp, 32
    call ks_d_dq
    add rsp, 32
    jmp .__ret_854
    jmp .L874
.L873:
.L874:
section .data
.str878: db 114,101,115,98,0
section .text
    lea rax, [rel .str878]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L876
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_d_res
    add rsp, 32
    jmp .__ret_854
    jmp .L877
.L876:
.L877:
section .data
.str881: db 114,101,115,113,0
section .text
    lea rax, [rel .str881]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L879
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    shl rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call ks_d_res
    add rsp, 32
    jmp .__ret_854
    jmp .L880
.L879:
.L880:
section .data
.str884: db 114,101,115,119,0
section .text
    lea rax, [rel .str884]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L882
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    shl rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_d_res
    add rsp, 32
    jmp .__ret_854
    jmp .L883
.L882:
.L883:
section .data
.str887: db 114,101,115,100,0
section .text
    lea rax, [rel .str887]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L885
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    shl rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ks_d_res
    add rsp, 32
    jmp .__ret_854
    jmp .L886
.L885:
.L886:
section .data
.str890: db 100,119,0
section .text
    lea rax, [rel .str890]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L888
    mov rax, 2
    mov [rel __g_kasm_dl_size], rax
    sub rsp, 32
    call ks_d_list
    add rsp, 32
    jmp .__ret_854
    jmp .L889
.L888:
.L889:
section .data
.str893: db 100,100,0
section .text
    lea rax, [rel .str893]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L891
    mov rax, 4
    mov [rel __g_kasm_dl_size], rax
    sub rsp, 32
    call ks_d_list
    add rsp, 32
    jmp .__ret_854
    jmp .L892
.L891:
.L892:
section .data
.str896: db 101,113,117,0
section .text
    lea rax, [rel .str896]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L894
    lea rax, [rel __g_kasm_last_label]
    push rax
    lea rax, [rel __g_kasm_last_label]
    push rax
    pop rcx
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_add_equ
    add rsp, 32
    mov rax, 1
    jmp .__ret_854
    jmp .L895
.L894:
.L895:
section .data
.str899: db 116,105,109,101,115,0
section .text
    lea rax, [rel .str899]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L897
    sub rsp, 32
    call ks_d_times
    add rsp, 32
    jmp .__ret_854
    jmp .L898
.L897:
.L898:
section .data
.str902: db 111,114,103,0
section .text
    lea rax, [rel .str902]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L900
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov [rel __g_kasm_kasm_org], rax
    mov rax, 1
    mov [rel __g_kasm_kasm_org_set], rax
    mov rax, 1
    jmp .__ret_854
    jmp .L901
.L900:
.L901:
section .data
.str905: db 97,108,105,103,110,0
section .text
    lea rax, [rel .str905]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L903
    sub rsp, 32
    call ks_d_align
    add rsp, 32
    jmp .__ret_854
    jmp .L904
.L903:
.L904:
    mov rax, 0
    jmp .__ret_854
.__ret_854:
    mov rsp, rbp
    pop rbp
    ret
ks_d_section:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_kasm_tok_b]
    push rax
section .data
.str909: db 46,100,97,116,97,0
section .text
    lea rax, [rel .str909]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_str_eq
    add rsp, 32
    cmp rax, 1
    jne .L907
    mov rax, 1
    mov [rel __g_kasm_cur_section], rax
    jmp .L908
.L907:
    lea rax, [rel __g_kasm_tok_b]
    push rax
section .data
.str912: db 46,98,115,115,0
section .text
    lea rax, [rel .str912]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_str_eq
    add rsp, 32
    cmp rax, 1
    jne .L910
    mov rax, 2
    mov [rel __g_kasm_cur_section], rax
    jmp .L911
.L910:
    mov rax, 0
    mov [rel __g_kasm_cur_section], rax
.L911:
.L908:
    mov rax, 1
    jmp .__ret_906
.__ret_906:
    mov rsp, rbp
    pop rbp
    ret
ks_d_align:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jne .L914
    mov rax, 1
    jmp .__ret_913
    jmp .L915
.L914:
.L915:
.L916:
    mov rax, 1
    cmp rax, 1
    jne .L917
    mov rax, [rel __g_kasm_kasm_code_len]
    mov rbx, rax
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 1
    jne .L919
    mov rax, [rel __g_kasm_kasm_data_len]
    mov rbx, rax
    jmp .L920
.L919:
.L920:
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call ks_urem
    add rsp, 32
    cmp rax, 0
    jne .L921
    mov rax, 1
    jmp .__ret_913
    jmp .L922
.L921:
.L922:
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 1
    jne .L923
    mov rcx, 0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L924
.L923:
    mov rcx, 0x90
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L924:
.L918:
    jmp .L916
.L917:
    mov rax, 1
    jmp .__ret_913
.__ret_913:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_d_times:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_expr_ptr]
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rax, 1
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 100
    jne .L926
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 113
    jne .L928
    mov rax, 8
    mov r12, rax
    jmp .L929
.L928:
.L929:
    mov rax, r13
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    jmp .L927
.L926:
.L927:
    mov rcx, r13
    sub rsp, 32
    call ks_parse_number
    add rsp, 32
    mov rbx, rax
.L930:
    cmp r14, 0
    je .L931
    cmp r12, 8
    jne .L933
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_q
    add rsp, 32
    jmp .L934
.L933:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L934:
    sub r14, 1
.L932:
    jmp .L930
.L931:
    mov rax, 1
    jmp .__ret_925
.__ret_925:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_d_extern:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_kasm_pass]
    cmp rax, 1
    je .L936
    mov rax, 1
    jmp .__ret_935
    jmp .L937
.L936:
.L937:
    lea rax, [rel __g_kasm_tok_b]
    push rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_add_extern
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    mov r13, rax
.L938:
    mov rax, 1
    cmp rax, 1
    jne .L939
    mov rcx, r13
    sub rsp, 32
    call ks_skip_blanks
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L941
    mov rax, 1
    jmp .__ret_935
    jmp .L942
.L941:
.L942:
    cmp rbx, 44
    jne .L943
    add r13, 1
    jmp .L944
.L943:
    mov rax, r13
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L945:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L952
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L952
    mov rax, 1
    jmp .L953
.L952:
    mov rax, 0
.L953:
    test rax, rax
    jz .L950
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L950
    mov rax, 1
    jmp .L951
.L950:
    mov rax, 0
.L951:
    test rax, rax
    jz .L948
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L948
    mov rax, 1
    jmp .L949
.L948:
    mov rax, 0
.L949:
    test rax, rax
    jz .L946
    add r12, 1
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L947:
    jmp .L945
.L946:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_add_extern
    add rsp, 32
    mov rax, r12
    mov r13, rax
.L944:
.L940:
    jmp .L938
.L939:
    mov rax, 1
    jmp .__ret_935
.__ret_935:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_d_res:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_cur_section]
    cmp rax, 2
    jne .L955
    mov rcx, r12
    sub rsp, 32
    call ks_bss_round8
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_kasm_kasm_bss_len]
    add rax, rbx
    mov [rel __g_kasm_kasm_bss_len], rax
    mov rax, [rel __g_kasm_bss_cursor]
    add rax, rbx
    mov [rel __g_kasm_bss_cursor], rax
    mov rax, 1
    jmp .__ret_954
    jmp .L956
.L955:
.L956:
.L957:
    cmp r12, 0
    je .L958
    mov rcx, 0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    sub r12, 1
.L959:
    jmp .L957
.L958:
    mov rax, 1
    jmp .__ret_954
.__ret_954:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_d_db:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    lea rax, [rel __g_kasm_tok_b]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_db_phase], rax
    mov rax, 34
    mov [rel __g_kasm_db_quote], rax
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L963
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L963
    mov rax, 0
    jmp .L964
.L963:
    mov rax, 1
.L964:
    test rax, rax
    jz .L961
    mov rax, rbx
    mov [rel __g_kasm_db_quote], rax
    add r12, 1
.L965:
    mov rax, 1
    cmp rax, 1
    jne .L966
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L968
    mov rax, 1
    jmp .__ret_960
    jmp .L969
.L968:
.L969:
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_db_quote]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L970
    jmp .L966
    jmp .L971
.L970:
.L971:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    add r12, 1
.L967:
    jmp .L965
.L966:
    add r12, 1
    jmp .L962
.L961:
.L962:
.L972:
    mov rax, 1
    cmp rax, 1
    jne .L973
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L975
    mov rax, [rel __g_kasm_db_phase]
    cmp rax, 0
    je .L977
    mov rax, 1
    jmp .__ret_960
    jmp .L978
.L977:
.L978:
    mov rax, 1
    mov [rel __g_kasm_db_phase], rax
    lea rax, [rel __g_kasm_tok_c]
    mov r12, rax
    jmp .L976
.L975:
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L983
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L983
    mov rax, 0
    jmp .L984
.L983:
    mov rax, 1
.L984:
    test rax, rax
    jnz .L981
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L981
    mov rax, 0
    jmp .L982
.L981:
    mov rax, 1
.L982:
    test rax, rax
    jz .L979
    add r12, 1
    jmp .L980
.L979:
    mov rax, rbx
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L987
    mov rax, rbx
    mov rcx, 39
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L987
    mov rax, 0
    jmp .L988
.L987:
    mov rax, 1
.L988:
    test rax, rax
    jz .L985
    mov rax, rbx
    mov [rel __g_kasm_db_quote], rax
    add r12, 1
.L989:
    mov rax, 1
    cmp rax, 1
    jne .L990
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L994
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_db_quote]
    mov rcx, rax
    pop rax
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
    jmp .L990
    jmp .L993
.L992:
.L993:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    add r12, 1
.L991:
    jmp .L989
.L990:
    cmp rbx, 0
    jne .L996
    mov rax, [rel __g_kasm_db_phase]
    cmp rax, 0
    je .L998
    mov rax, 1
    jmp .__ret_960
    jmp .L999
.L998:
.L999:
    mov rax, 1
    mov [rel __g_kasm_db_phase], rax
    lea rax, [rel __g_kasm_tok_c]
    mov r12, rax
    jmp .L997
.L996:
    add r12, 1
.L997:
    jmp .L986
.L985:
    mov rax, [rel __g_kasm_kasm_org_set]
    cmp rax, 0
    je .L1000
    mov rcx, r12
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_expr_ptr]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1002
    mov rax, 1
    mov [rel __g_kasm_kasm_error], rax
    mov rax, [rel __g_kasm_db_phase]
    cmp rax, 0
    je .L1004
    mov rax, 1
    jmp .__ret_960
    jmp .L1005
.L1004:
.L1005:
    mov rax, 1
    mov [rel __g_kasm_db_phase], rax
    lea rax, [rel __g_kasm_tok_c]
    mov r12, rax
    jmp .L1003
.L1002:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_expr_ptr]
    mov r12, rax
.L1003:
    jmp .L1001
.L1000:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1008
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1008
    mov rax, 0
    jmp .L1009
.L1008:
    mov rax, 1
.L1009:
    test rax, rax
    jz .L1006
    mov rax, [rel __g_kasm_db_phase]
    cmp rax, 0
    je .L1010
    mov rax, 1
    jmp .__ret_960
    jmp .L1011
.L1010:
.L1011:
    mov rax, 1
    mov [rel __g_kasm_db_phase], rax
    lea rax, [rel __g_kasm_tok_c]
    mov r12, rax
    jmp .L1007
.L1006:
    mov rcx, r12
    sub rsp, 32
    call ks_parse_number
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L1012:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1019
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1019
    mov rax, 1
    jmp .L1020
.L1019:
    mov rax, 0
.L1020:
    test rax, rax
    jz .L1017
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1017
    mov rax, 1
    jmp .L1018
.L1017:
    mov rax, 0
.L1018:
    test rax, rax
    jz .L1015
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1015
    mov rax, 1
    jmp .L1016
.L1015:
    mov rax, 0
.L1016:
    test rax, rax
    jz .L1013
    add r12, 1
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L1014:
    jmp .L1012
.L1013:
.L1007:
.L1001:
.L986:
.L980:
.L976:
.L974:
    jmp .L972
.L973:
    mov rax, 1
    jmp .__ret_960
.__ret_960:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_d_dq:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    lea rax, [rel __g_kasm_tok_b]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1026
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1026
    mov rax, 0
    jmp .L1027
.L1026:
    mov rax, 1
.L1027:
    test rax, rax
    jnz .L1024
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1028
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L1028
    mov rax, 1
    jmp .L1029
.L1028:
    mov rax, 0
.L1029:
    test rax, rax
    jnz .L1024
    mov rax, 0
    jmp .L1025
.L1024:
    mov rax, 1
.L1025:
    test rax, rax
    jz .L1022
.L1030:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1033
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1033
    mov rax, 1
    jmp .L1034
.L1033:
    mov rax, 0
.L1034:
    test rax, rax
    jz .L1031
    cmp rbx, 46
    jne .L1035
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_float
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_q
    add rsp, 32
    mov rax, 1
    jmp .__ret_1021
    jmp .L1036
.L1035:
.L1036:
    add r12, 1
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L1032:
    jmp .L1030
.L1031:
    jmp .L1023
.L1022:
.L1023:
    mov rax, 8
    mov [rel __g_kasm_dl_size], rax
    sub rsp, 32
    call ks_d_list
    add rsp, 32
    jmp .__ret_1021
.__ret_1021:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_d_list:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    lea rax, [rel __g_kasm_tok_b]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_db_phase], rax
.L1038:
    mov rax, 1
    cmp rax, 1
    jne .L1039
    mov rcx, r12
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1041
    mov rax, [rel __g_kasm_db_phase]
    cmp rax, 0
    je .L1043
    mov rax, 1
    jmp .__ret_1037
    jmp .L1044
.L1043:
.L1044:
    mov rax, 1
    mov [rel __g_kasm_db_phase], rax
    lea rax, [rel __g_kasm_tok_c]
    mov r12, rax
    jmp .L1042
.L1041:
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1049
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1049
    mov rax, 0
    jmp .L1050
.L1049:
    mov rax, 1
.L1050:
    test rax, rax
    jnz .L1047
    mov rax, rbx
    mov rcx, 9
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
    add r12, 1
    jmp .L1046
.L1045:
    mov rax, [rel __g_kasm_kasm_org_set]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1053
    mov rcx, r12
    sub rsp, 32
    call ks_dl_is_label
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1053
    mov rax, 1
    jmp .L1054
.L1053:
    mov rax, 0
.L1054:
    test rax, rax
    jz .L1051
    mov rcx, r12
    sub rsp, 32
    call ks_dl_tok_len
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rel __g_kasm_cur_addend], rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_qualify_label
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_qual_len]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 6
    sub rsp, 32
    call ks_add_fixup
    add rsp, 32
    add r12, rbx
    mov rcx, 0
    sub rsp, 32
    call ks_dl_emit
    add rsp, 32
    jmp .L1052
.L1051:
    mov rcx, r12
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_kasm_expr_ptr]
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call ks_dl_emit
    add rsp, 32
.L1052:
.L1046:
.L1042:
.L1040:
    jmp .L1038
.L1039:
    mov rax, 1
    jmp .__ret_1037
.__ret_1037:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_dl_tok_len:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L1056:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1063
    mov rax, rbx
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1063
    mov rax, 1
    jmp .L1064
.L1063:
    mov rax, 0
.L1064:
    test rax, rax
    jz .L1061
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1061
    mov rax, 1
    jmp .L1062
.L1061:
    mov rax, 0
.L1062:
    test rax, rax
    jz .L1059
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1059
    mov rax, 1
    jmp .L1060
.L1059:
    mov rax, 0
.L1060:
    test rax, rax
    jz .L1057
    add r12, 1
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rbx, rax
.L1058:
    jmp .L1056
.L1057:
    mov rax, r12
    jmp .__ret_1055
.__ret_1055:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_dl_emit:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_kasm_dl_size]
    cmp rax, 2
    jne .L1066
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1065
    jmp .L1067
.L1066:
.L1067:
    mov rax, [rel __g_kasm_dl_size]
    cmp rax, 4
    jne .L1068
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1065
    jmp .L1069
.L1068:
.L1069:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_q
    add rsp, 32
    jmp .__ret_1065
.__ret_1065:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_dl_is_label:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, r13
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1073
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
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
    mov rax, 0
    jmp .__ret_1070
    jmp .L1072
.L1071:
.L1072:
    mov rcx, r13
    sub rsp, 32
    call ks_dl_tok_len
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call ks_find_equ
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1075
    mov rax, 0
    jmp .__ret_1070
    jmp .L1076
.L1075:
.L1076:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call ks_qualify_label
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_qual_len]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1077
    mov rax, 0
    jmp .__ret_1070
    jmp .L1078
.L1077:
.L1078:
    mov rax, 1
    jmp .__ret_1070
.__ret_1070:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_apply_fixups:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L1080:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_fix_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_ult
    add rsp, 32
    cmp rax, 1
    jne .L1081
    lea rax, [rel __g_kasm_fix_at]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov r13, rax
    lea rax, [rel __g_kasm_fix_label]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    je .L1083
    lea rax, [rel __g_kasm_fix_kind]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov [rel __g_kasm_cur_fix_kind], rax
    mov rax, [rel __g_kasm_cur_fix_kind]
    cmp rax, 6
    je .L1085
    lea rax, [rel __g_kasm_lbl_addr]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov r12, rax
    lea rax, [rel __g_kasm_lbl_section]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L1087
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_data_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L1088
.L1087:
    cmp rbx, 2
    jne .L1089
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_bss_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L1090
.L1089:
.L1090:
.L1088:
    mov rax, r12
    push rax
    lea rax, [rel __g_kasm_fix_addend]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ks_q
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    lea rax, [rel __g_kasm_kasm_code]
    add rax, r13
    push rax
    mov rax, r13
    add rax, 4
    mov rcx, rax
    mov rax, r12
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_put_d
    add rsp, 32
    jmp .L1086
.L1085:
.L1086:
    jmp .L1084
.L1083:
.L1084:
    add r14, 1
.L1082:
    jmp .L1080
.L1081:
    mov rax, 0
    jmp .__ret_1079
.__ret_1079:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ks_put_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, r12
    add rax, 1
    push rax
    mov rax, rbx
    shr rax, 8
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, r12
    add rax, 2
    push rax
    mov rax, rbx
    shr rax, 16
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, r12
    add rax, 3
    push rax
    mov rax, rbx
    shr rax, 24
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_bs
    add rsp, 32
    mov rax, 0
    jmp .__ret_1091
.__ret_1091:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_encode_line:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_kasm_rex8_force], rax
    mov rax, [rel __g_kasm_rp_left]
    mov [rel __g_kasm_en_r12], rax
    mov rax, [rel __g_kasm_rp_len]
    mov [rel __g_kasm_en_r14], rax
    lea rax, [rel __g_kasm_tok_a]
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 0
    jne .L1093
    mov rax, 0
    jmp .__ret_1092
    jmp .L1094
.L1093:
.L1094:
section .data
.str1097: db 109,111,118,0
section .text
    lea rax, [rel .str1097]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1095
    sub rsp, 32
    call ks_i_mov
    add rsp, 32
    jmp .__ret_1092
    jmp .L1096
.L1095:
.L1096:
section .data
.str1100: db 112,117,115,104,0
section .text
    lea rax, [rel .str1100]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1098
    sub rsp, 32
    call ks_i_push
    add rsp, 32
    jmp .__ret_1092
    jmp .L1099
.L1098:
.L1099:
section .data
.str1103: db 112,111,112,0
section .text
    lea rax, [rel .str1103]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1101
    sub rsp, 32
    call ks_i_pop
    add rsp, 32
    jmp .__ret_1092
    jmp .L1102
.L1101:
.L1102:
section .data
.str1106: db 97,100,100,0
section .text
    lea rax, [rel .str1106]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1104
    mov rcx, 0x01
    mov rdx, 0
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1105
.L1104:
.L1105:
section .data
.str1109: db 115,117,98,0
section .text
    lea rax, [rel .str1109]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1107
    mov rcx, 0x29
    mov rdx, 5
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1108
.L1107:
.L1108:
section .data
.str1112: db 105,109,117,108,0
section .text
    lea rax, [rel .str1112]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1110
    sub rsp, 32
    call ks_i_imul
    add rsp, 32
    jmp .__ret_1092
    jmp .L1111
.L1110:
.L1111:
section .data
.str1115: db 109,117,108,0
section .text
    lea rax, [rel .str1115]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1113
    mov rcx, 4
    sub rsp, 32
    call ks_unary_f7
    add rsp, 32
    jmp .__ret_1092
    jmp .L1114
.L1113:
.L1114:
section .data
.str1118: db 105,100,105,118,0
section .text
    lea rax, [rel .str1118]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1116
    mov rcx, 7
    sub rsp, 32
    call ks_unary_f7
    add rsp, 32
    jmp .__ret_1092
    jmp .L1117
.L1116:
.L1117:
section .data
.str1121: db 100,105,118,0
section .text
    lea rax, [rel .str1121]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1119
    mov rcx, 6
    sub rsp, 32
    call ks_unary_f7
    add rsp, 32
    jmp .__ret_1092
    jmp .L1120
.L1119:
.L1120:
section .data
.str1124: db 99,113,111,0
section .text
    lea rax, [rel .str1124]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1122
    mov rcx, 0x48
    mov rdx, 0x99
    sub rsp, 32
    call ks_two
    add rsp, 32
    jmp .__ret_1092
    jmp .L1123
.L1122:
.L1123:
section .data
.str1127: db 99,109,112,0
section .text
    lea rax, [rel .str1127]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1125
    mov rcx, 0x39
    mov rdx, 7
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1126
.L1125:
.L1126:
section .data
.str1130: db 116,101,115,116,0
section .text
    lea rax, [rel .str1130]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1128
    mov rcx, 0x85
    mov rdx, 0
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1129
.L1128:
.L1129:
section .data
.str1133: db 120,111,114,0
section .text
    lea rax, [rel .str1133]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1131
    mov rcx, 0x31
    mov rdx, 6
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1132
.L1131:
.L1132:
section .data
.str1136: db 110,101,103,0
section .text
    lea rax, [rel .str1136]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1134
    mov rcx, 3
    sub rsp, 32
    call ks_unary_f7
    add rsp, 32
    jmp .__ret_1092
    jmp .L1135
.L1134:
.L1135:
section .data
.str1139: db 105,110,99,0
section .text
    lea rax, [rel .str1139]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1137
    mov rcx, 0
    sub rsp, 32
    call ks_unary_ff
    add rsp, 32
    jmp .__ret_1092
    jmp .L1138
.L1137:
.L1138:
section .data
.str1142: db 100,101,99,0
section .text
    lea rax, [rel .str1142]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1140
    mov rcx, 1
    sub rsp, 32
    call ks_unary_ff
    add rsp, 32
    jmp .__ret_1092
    jmp .L1141
.L1140:
.L1141:
section .data
.str1145: db 108,101,97,0
section .text
    lea rax, [rel .str1145]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1143
    sub rsp, 32
    call ks_i_lea
    add rsp, 32
    jmp .__ret_1092
    jmp .L1144
.L1143:
.L1144:
section .data
.str1148: db 114,101,116,0
section .text
    lea rax, [rel .str1148]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1146
    mov rcx, 0xC3
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1147
.L1146:
.L1147:
section .data
.str1151: db 99,97,108,108,0
section .text
    lea rax, [rel .str1151]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1149
    sub rsp, 32
    call ks_i_call
    add rsp, 32
    jmp .__ret_1092
    jmp .L1150
.L1149:
.L1150:
section .data
.str1154: db 106,109,112,0
section .text
    lea rax, [rel .str1154]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1152
    mov rcx, 0xE9
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    sub rsp, 32
    call ks_rel32_target
    add rsp, 32
    jmp .__ret_1092
    jmp .L1153
.L1152:
.L1153:
section .data
.str1157: db 106,101,0
section .text
    lea rax, [rel .str1157]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1155
    mov rcx, 0x84
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1156
.L1155:
.L1156:
section .data
.str1160: db 106,122,0
section .text
    lea rax, [rel .str1160]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1158
    mov rcx, 0x84
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1159
.L1158:
.L1159:
section .data
.str1163: db 106,110,101,0
section .text
    lea rax, [rel .str1163]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1161
    mov rcx, 0x85
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1162
.L1161:
.L1162:
section .data
.str1166: db 106,110,122,0
section .text
    lea rax, [rel .str1166]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1164
    mov rcx, 0x85
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1165
.L1164:
.L1165:
section .data
.str1169: db 106,110,115,0
section .text
    lea rax, [rel .str1169]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1167
    mov rcx, 0x89
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1168
.L1167:
.L1168:
section .data
.str1172: db 106,98,101,0
section .text
    lea rax, [rel .str1172]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1170
    mov rcx, 0x86
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1171
.L1170:
.L1171:
section .data
.str1175: db 104,108,116,0
section .text
    lea rax, [rel .str1175]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1173
    mov rcx, 0xF4
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1174
.L1173:
.L1174:
section .data
.str1178: db 99,108,105,0
section .text
    lea rax, [rel .str1178]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1176
    mov rcx, 0xFA
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1177
.L1176:
.L1177:
section .data
.str1181: db 115,121,115,99,97,108,108,0
section .text
    lea rax, [rel .str1181]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1179
    mov rcx, 0x0F
    mov rdx, 0x05
    sub rsp, 32
    call ks_two
    add rsp, 32
    jmp .__ret_1092
    jmp .L1180
.L1179:
.L1180:
section .data
.str1184: db 105,114,101,116,113,0
section .text
    lea rax, [rel .str1184]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1182
    mov rcx, 0x48
    mov rdx, 0xCF
    sub rsp, 32
    call ks_two
    add rsp, 32
    jmp .__ret_1092
    jmp .L1183
.L1182:
.L1183:
section .data
.str1187: db 109,111,118,122,120,0
section .text
    lea rax, [rel .str1187]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1185
    sub rsp, 32
    call ks_i_movzx
    add rsp, 32
    jmp .__ret_1092
    jmp .L1186
.L1185:
.L1186:
section .data
.str1190: db 109,111,118,115,120,0
section .text
    lea rax, [rel .str1190]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1188
    sub rsp, 32
    call ks_i_movsx
    add rsp, 32
    jmp .__ret_1092
    jmp .L1189
.L1188:
.L1189:
section .data
.str1193: db 115,101,116,101,0
section .text
    lea rax, [rel .str1193]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1191
    mov rcx, 0x94
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1192
.L1191:
.L1192:
section .data
.str1196: db 115,101,116,110,101,0
section .text
    lea rax, [rel .str1196]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1194
    mov rcx, 0x95
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1195
.L1194:
.L1195:
section .data
.str1199: db 115,101,116,108,0
section .text
    lea rax, [rel .str1199]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1197
    mov rcx, 0x9C
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1198
.L1197:
.L1198:
section .data
.str1202: db 115,101,116,103,0
section .text
    lea rax, [rel .str1202]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1200
    mov rcx, 0x9F
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1201
.L1200:
.L1201:
section .data
.str1205: db 115,101,116,108,101,0
section .text
    lea rax, [rel .str1205]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1203
    mov rcx, 0x9E
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1204
.L1203:
.L1204:
section .data
.str1208: db 115,101,116,103,101,0
section .text
    lea rax, [rel .str1208]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1206
    mov rcx, 0x9D
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1207
.L1206:
.L1207:
section .data
.str1211: db 115,101,116,98,0
section .text
    lea rax, [rel .str1211]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1209
    mov rcx, 0x92
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1210
.L1209:
.L1210:
section .data
.str1214: db 115,101,116,97,101,0
section .text
    lea rax, [rel .str1214]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1212
    mov rcx, 0x93
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1213
.L1212:
.L1213:
section .data
.str1217: db 115,101,116,97,0
section .text
    lea rax, [rel .str1217]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1215
    mov rcx, 0x97
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1216
.L1215:
.L1216:
section .data
.str1220: db 115,101,116,98,101,0
section .text
    lea rax, [rel .str1220]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1218
    mov rcx, 0x96
    sub rsp, 32
    call ks_setcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1219
.L1218:
.L1219:
section .data
.str1223: db 105,110,0
section .text
    lea rax, [rel .str1223]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1221
    mov rcx, 0xEC
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1222
.L1221:
.L1222:
section .data
.str1226: db 111,117,116,0
section .text
    lea rax, [rel .str1226]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1224
    mov rcx, 0xEE
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1225
.L1224:
.L1225:
section .data
.str1229: db 97,100,100,112,115,0
section .text
    lea rax, [rel .str1229]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1227
    mov rcx, 0x58
    mov rdx, 0
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1228
.L1227:
.L1228:
section .data
.str1232: db 115,117,98,112,115,0
section .text
    lea rax, [rel .str1232]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1230
    mov rcx, 0x5C
    mov rdx, 0
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1231
.L1230:
.L1231:
section .data
.str1235: db 109,117,108,112,115,0
section .text
    lea rax, [rel .str1235]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1233
    mov rcx, 0x59
    mov rdx, 0
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1234
.L1233:
.L1234:
section .data
.str1238: db 100,105,118,112,115,0
section .text
    lea rax, [rel .str1238]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1236
    mov rcx, 0x5E
    mov rdx, 0
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1237
.L1236:
.L1237:
section .data
.str1241: db 97,100,100,112,100,0
section .text
    lea rax, [rel .str1241]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1239
    mov rcx, 0x58
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1240
.L1239:
.L1240:
section .data
.str1244: db 115,117,98,112,100,0
section .text
    lea rax, [rel .str1244]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1242
    mov rcx, 0x5C
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1243
.L1242:
.L1243:
section .data
.str1247: db 109,117,108,112,100,0
section .text
    lea rax, [rel .str1247]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1245
    mov rcx, 0x59
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1246
.L1245:
.L1246:
section .data
.str1250: db 100,105,118,112,100,0
section .text
    lea rax, [rel .str1250]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1248
    mov rcx, 0x5E
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1249
.L1248:
.L1249:
section .data
.str1253: db 109,111,118,97,112,115,0
section .text
    lea rax, [rel .str1253]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1251
    mov rcx, 0x28
    mov rdx, 0
    sub rsp, 32
    call ks_sse_mov
    add rsp, 32
    jmp .__ret_1092
    jmp .L1252
.L1251:
.L1252:
section .data
.str1256: db 109,111,118,117,112,115,0
section .text
    lea rax, [rel .str1256]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1254
    mov rcx, 0x10
    mov rdx, 0
    sub rsp, 32
    call ks_sse_mov
    add rsp, 32
    jmp .__ret_1092
    jmp .L1255
.L1254:
.L1255:
section .data
.str1259: db 109,111,118,97,112,100,0
section .text
    lea rax, [rel .str1259]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1257
    mov rcx, 0x28
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_mov
    add rsp, 32
    jmp .__ret_1092
    jmp .L1258
.L1257:
.L1258:
section .data
.str1262: db 109,111,118,117,112,100,0
section .text
    lea rax, [rel .str1262]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1260
    mov rcx, 0x10
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_mov
    add rsp, 32
    jmp .__ret_1092
    jmp .L1261
.L1260:
.L1261:
section .data
.str1265: db 115,113,114,116,112,115,0
section .text
    lea rax, [rel .str1265]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1263
    mov rcx, 0x51
    mov rdx, 0
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1264
.L1263:
.L1264:
section .data
.str1268: db 115,113,114,116,112,100,0
section .text
    lea rax, [rel .str1268]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1266
    mov rcx, 0x51
    mov rdx, 0x66
    sub rsp, 32
    call ks_sse_packed
    add rsp, 32
    jmp .__ret_1092
    jmp .L1267
.L1266:
.L1267:
section .data
.str1271: db 109,111,118,115,100,0
section .text
    lea rax, [rel .str1271]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1269
    mov rcx, 0xF2
    sub rsp, 32
    call ks_i_movsd
    add rsp, 32
    jmp .__ret_1092
    jmp .L1270
.L1269:
.L1270:
section .data
.str1274: db 109,111,118,115,115,0
section .text
    lea rax, [rel .str1274]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1272
    mov rcx, 0xF3
    sub rsp, 32
    call ks_i_movsd
    add rsp, 32
    jmp .__ret_1092
    jmp .L1273
.L1272:
.L1273:
section .data
.str1277: db 99,118,116,115,115,50,115,100,0
section .text
    lea rax, [rel .str1277]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1275
    mov rcx, 0x5A
    mov rdx, 0xF3
    sub rsp, 32
    call ks_sse_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1276
.L1275:
.L1276:
section .data
.str1280: db 99,118,116,115,100,50,115,115,0
section .text
    lea rax, [rel .str1280]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1278
    mov rcx, 0x5A
    mov rdx, 0xF2
    sub rsp, 32
    call ks_sse_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1279
.L1278:
.L1279:
section .data
.str1283: db 97,100,100,115,100,0
section .text
    lea rax, [rel .str1283]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1281
    mov rcx, 0x58
    mov rdx, 0xF2
    sub rsp, 32
    call ks_sse_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1282
.L1281:
.L1282:
section .data
.str1286: db 115,117,98,115,100,0
section .text
    lea rax, [rel .str1286]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1284
    mov rcx, 0x5C
    mov rdx, 0xF2
    sub rsp, 32
    call ks_sse_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1285
.L1284:
.L1285:
section .data
.str1289: db 109,117,108,115,100,0
section .text
    lea rax, [rel .str1289]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1287
    mov rcx, 0x59
    mov rdx, 0xF2
    sub rsp, 32
    call ks_sse_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1288
.L1287:
.L1288:
section .data
.str1292: db 100,105,118,115,100,0
section .text
    lea rax, [rel .str1292]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1290
    mov rcx, 0x5E
    mov rdx, 0xF2
    sub rsp, 32
    call ks_sse_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1291
.L1290:
.L1291:
section .data
.str1295: db 99,111,109,105,115,100,0
section .text
    lea rax, [rel .str1295]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1293
    mov rcx, 0x2F
    sub rsp, 32
    call ks_sse_cmp
    add rsp, 32
    jmp .__ret_1092
    jmp .L1294
.L1293:
.L1294:
section .data
.str1298: db 117,99,111,109,105,115,100,0
section .text
    lea rax, [rel .str1298]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1296
    mov rcx, 0x2E
    sub rsp, 32
    call ks_sse_cmp
    add rsp, 32
    jmp .__ret_1092
    jmp .L1297
.L1296:
.L1297:
section .data
.str1301: db 115,104,108,0
section .text
    lea rax, [rel .str1301]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1299
    mov rcx, 4
    sub rsp, 32
    call ks_shift
    add rsp, 32
    jmp .__ret_1092
    jmp .L1300
.L1299:
.L1300:
section .data
.str1304: db 115,104,114,0
section .text
    lea rax, [rel .str1304]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1302
    mov rcx, 5
    sub rsp, 32
    call ks_shift
    add rsp, 32
    jmp .__ret_1092
    jmp .L1303
.L1302:
.L1303:
section .data
.str1307: db 115,97,114,0
section .text
    lea rax, [rel .str1307]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1305
    mov rcx, 7
    sub rsp, 32
    call ks_shift
    add rsp, 32
    jmp .__ret_1092
    jmp .L1306
.L1305:
.L1306:
section .data
.str1310: db 114,111,108,0
section .text
    lea rax, [rel .str1310]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1308
    mov rcx, 0
    sub rsp, 32
    call ks_shift
    add rsp, 32
    jmp .__ret_1092
    jmp .L1309
.L1308:
.L1309:
section .data
.str1313: db 114,111,114,0
section .text
    lea rax, [rel .str1313]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1311
    mov rcx, 1
    sub rsp, 32
    call ks_shift
    add rsp, 32
    jmp .__ret_1092
    jmp .L1312
.L1311:
.L1312:
section .data
.str1316: db 99,108,102,108,117,115,104,0
section .text
    lea rax, [rel .str1316]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1314
    mov rcx, 0xAE
    mov rdx, 7
    sub rsp, 32
    call ks_cacheop
    add rsp, 32
    jmp .__ret_1092
    jmp .L1315
.L1314:
.L1315:
section .data
.str1319: db 112,114,101,102,101,116,99,104,116,48,0
section .text
    lea rax, [rel .str1319]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1317
    mov rcx, 0x18
    mov rdx, 1
    sub rsp, 32
    call ks_cacheop
    add rsp, 32
    jmp .__ret_1092
    jmp .L1318
.L1317:
.L1318:
section .data
.str1322: db 106,97,0
section .text
    lea rax, [rel .str1322]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1320
    mov rcx, 0x87
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1321
.L1320:
.L1321:
section .data
.str1325: db 106,97,101,0
section .text
    lea rax, [rel .str1325]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1323
    mov rcx, 0x83
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1324
.L1323:
.L1324:
section .data
.str1328: db 106,98,0
section .text
    lea rax, [rel .str1328]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1326
    mov rcx, 0x82
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1327
.L1326:
.L1327:
section .data
.str1331: db 106,103,0
section .text
    lea rax, [rel .str1331]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1329
    mov rcx, 0x8F
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1330
.L1329:
.L1330:
section .data
.str1334: db 106,103,101,0
section .text
    lea rax, [rel .str1334]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1332
    mov rcx, 0x8D
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1333
.L1332:
.L1333:
section .data
.str1337: db 106,108,0
section .text
    lea rax, [rel .str1337]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1335
    mov rcx, 0x8C
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1336
.L1335:
.L1336:
section .data
.str1340: db 106,108,101,0
section .text
    lea rax, [rel .str1340]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1338
    mov rcx, 0x8E
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1339
.L1338:
.L1339:
section .data
.str1343: db 106,115,0
section .text
    lea rax, [rel .str1343]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1341
    mov rcx, 0x88
    sub rsp, 32
    call ks_jcc
    add rsp, 32
    jmp .__ret_1092
    jmp .L1342
.L1341:
.L1342:
section .data
.str1346: db 97,110,100,0
section .text
    lea rax, [rel .str1346]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1344
    mov rcx, 0x21
    mov rdx, 4
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1345
.L1344:
.L1345:
section .data
.str1349: db 111,114,0
section .text
    lea rax, [rel .str1349]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1347
    mov rcx, 0x09
    mov rdx, 1
    sub rsp, 32
    call ks_arith
    add rsp, 32
    jmp .__ret_1092
    jmp .L1348
.L1347:
.L1348:
section .data
.str1352: db 110,111,116,0
section .text
    lea rax, [rel .str1352]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1350
    mov rcx, 2
    sub rsp, 32
    call ks_unary_f7
    add rsp, 32
    jmp .__ret_1092
    jmp .L1351
.L1350:
.L1351:
section .data
.str1355: db 114,101,112,0
section .text
    lea rax, [rel .str1355]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1353
    sub rsp, 32
    call ks_i_rep
    add rsp, 32
    jmp .__ret_1092
    jmp .L1354
.L1353:
.L1354:
section .data
.str1358: db 109,111,118,115,98,0
section .text
    lea rax, [rel .str1358]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1356
    mov rcx, 0xA4
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1357
.L1356:
.L1357:
section .data
.str1361: db 115,116,111,115,98,0
section .text
    lea rax, [rel .str1361]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1359
    mov rcx, 0xAA
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1092
    jmp .L1360
.L1359:
.L1360:
section .data
.str1364: db 99,118,116,115,105,50,115,100,0
section .text
    lea rax, [rel .str1364]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1362
    sub rsp, 32
    call ks_i_cvtsi
    add rsp, 32
    jmp .__ret_1092
    jmp .L1363
.L1362:
.L1363:
section .data
.str1367: db 99,118,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str1367]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1365
    mov rcx, 0x2D
    sub rsp, 32
    call ks_sse_to_int
    add rsp, 32
    jmp .__ret_1092
    jmp .L1366
.L1365:
.L1366:
section .data
.str1370: db 99,118,116,116,115,100,50,115,105,0
section .text
    lea rax, [rel .str1370]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1368
    mov rcx, 0x2C
    sub rsp, 32
    call ks_sse_to_int
    add rsp, 32
    jmp .__ret_1092
    jmp .L1369
.L1368:
.L1369:
section .data
.str1373: db 120,111,114,112,115,0
section .text
    lea rax, [rel .str1373]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1371
    sub rsp, 32
    call ks_i_xorps
    add rsp, 32
    jmp .__ret_1092
    jmp .L1372
.L1371:
.L1372:
section .data
.str1376: db 109,111,118,113,0
section .text
    lea rax, [rel .str1376]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1374
    sub rsp, 32
    call ks_i_movq
    add rsp, 32
    jmp .__ret_1092
    jmp .L1375
.L1374:
.L1375:
section .data
.str1379: db 120,99,104,103,0
section .text
    lea rax, [rel .str1379]
    push rax
    pop rcx
    sub rsp, 32
    call ks_is
    add rsp, 32
    cmp rax, 1
    jne .L1377
    sub rsp, 32
    call ks_i_xchg
    add rsp, 32
    jmp .__ret_1092
    jmp .L1378
.L1377:
.L1378:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1092
.__ret_1092:
    mov rsp, rbp
    pop rbp
    ret
ks_unsupported:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_pass]
    cmp rax, 2
    je .L1381
    mov rax, 0
    jmp .__ret_1380
    jmp .L1382
.L1381:
.L1382:
    mov rax, [rel __g_kasm_en_r12]
    push rax
    mov rax, [rel __g_kasm_en_r14]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call ks_err_record
    add rsp, 32
    jmp .__ret_1380
.__ret_1380:
    mov rsp, rbp
    pop rbp
    ret
ks_two:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1383
.__ret_1383:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_i_push:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov [rel __g_kasm_en_r12], rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    mov rcx, r12
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 5
    jne .L1385
    mov rcx, 0xFF
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 6
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1384
    jmp .L1386
.L1385:
.L1386:
    mov rcx, r12
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    je .L1387
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1384
    jmp .L1388
.L1387:
.L1388:
    cmp rbx, 8
    jl .L1389
    mov rcx, 0x41
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1390
.L1389:
.L1390:
    mov rax, rbx
    and rax, 7
    mov rcx, rax
    mov rax, 0x50
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1384
.__ret_1384:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_i_pop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov [rel __g_kasm_en_r12], rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    mov rcx, r12
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    je .L1392
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1391
    jmp .L1393
.L1392:
.L1393:
    cmp rbx, 8
    jl .L1394
    mov rcx, 0x41
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1395
.L1394:
.L1395:
    mov rax, rbx
    and rax, 7
    mov rcx, rax
    mov rax, 0x58
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1391
.__ret_1391:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_kasm_ar_kd: dq 0
section .text
section .data
__g_kasm_ar_d: dq 0
section .text
section .data
__g_kasm_ar_ks: dq 0
section .text
section .data
__g_kasm_ar_s: dq 0
section .text
ks_rev_op:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0x85
    jne .L1397
    mov rax, rbx
    jmp .__ret_1396
    jmp .L1398
.L1397:
.L1398:
    mov rax, rbx
    add rax, 2
    and rax, 255
    jmp .__ret_1396
.__ret_1396:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_arith:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_ar_kd], rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_dst_base], rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_ar_d], rax
    mov rax, [rel __g_kasm_ar_kd]
    mov [rel __g_kasm_en_r12], rax
    mov rax, [rel __g_kasm_cur_addend]
    mov [rel __g_kasm_dst_addend], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_ar_ks], rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_src_base], rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_ar_s], rax
    mov rax, [rel __g_kasm_ar_ks]
    mov [rel __g_kasm_en_r14], rax
    mov rax, [rel __g_kasm_ar_kd]
    mov rbx, rax
    cmp rbx, 12
    jne .L1400
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call ks_arith_sib_imm
    add rsp, 32
    jmp .__ret_1399
    jmp .L1401
.L1400:
.L1401:
    cmp rbx, 7
    jne .L1402
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call ks_arith_r8
    add rsp, 32
    jmp .__ret_1399
    jmp .L1403
.L1402:
.L1403:
    cmp rbx, 8
    jne .L1404
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call ks_arith_r32
    add rsp, 32
    jmp .__ret_1399
    jmp .L1405
.L1404:
.L1405:
    mov rax, rbx
    mov rcx, 5
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1410
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1410
    mov rax, 0
    jmp .L1411
.L1410:
    mov rax, 1
.L1411:
    test rax, rax
    jnz .L1408
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1408
    mov rax, 0
    jmp .L1409
.L1408:
    mov rax, 1
.L1409:
    test rax, rax
    jz .L1406
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call ks_arith_mem
    add rsp, 32
    jmp .__ret_1399
    jmp .L1407
.L1406:
.L1407:
    cmp rbx, 1
    je .L1412
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1399
    jmp .L1413
.L1412:
.L1413:
    mov rax, [rel __g_kasm_ar_ks]
    mov rbx, rax
    cmp rbx, 1
    jne .L1414
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1399
    jmp .L1415
.L1414:
.L1415:
    cmp rbx, 2
    jne .L1416
    cmp r13, 0x85
    jne .L1418
    mov rax, 1
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xF7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1399
    jmp .L1419
.L1418:
.L1419:
    mov rax, 1
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_arith_imm_tail
    add rsp, 32
    jmp .__ret_1399
    jmp .L1417
.L1416:
.L1417:
    cmp rbx, 5
    jne .L1420
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1399
    jmp .L1421
.L1420:
.L1421:
    cmp rbx, 9
    jne .L1422
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1399
    jmp .L1423
.L1422:
.L1423:
    cmp rbx, 13
    jne .L1424
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1399
    jmp .L1425
.L1424:
.L1425:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1399
.__ret_1399:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_arith_imm_tail:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_kasm_ar_s]
    cmp rax, 127
    jg .L1427
    mov rcx, 0x83
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1426
    jmp .L1428
.L1427:
.L1428:
    mov rcx, 0x81
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1426
.__ret_1426:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_arith_r32:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_kasm_ar_ks]
    mov rbx, rax
    cmp rbx, 8
    jne .L1430
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1429
    jmp .L1431
.L1430:
.L1431:
    cmp rbx, 2
    jne .L1432
    cmp r13, 0x85
    jne .L1434
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xF7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1429
    jmp .L1435
.L1434:
.L1435:
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_arith_imm_tail
    add rsp, 32
    jmp .__ret_1429
    jmp .L1433
.L1432:
.L1433:
    cmp rbx, 12
    jne .L1436
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1429
    jmp .L1437
.L1436:
.L1437:
    cmp rbx, 9
    jne .L1438
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1429
    jmp .L1439
.L1438:
.L1439:
    cmp rbx, 13
    jne .L1440
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1429
    jmp .L1441
.L1440:
.L1441:
    cmp rbx, 5
    jne .L1442
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_rev_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1429
    jmp .L1443
.L1442:
.L1443:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1429
.__ret_1429:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_arith_r8:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_kasm_ar_ks]
    mov r12, rax
    mov rax, r14
    add rax, 1
    and rax, 255
    mov rbx, rax
    mov rax, [rel __g_kasm_ar_d]
    cmp rax, 4
    jl .L1445
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1446
.L1445:
.L1446:
    cmp r12, 12
    jne .L1447
    mov rax, rbx
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1444
    jmp .L1448
.L1447:
.L1448:
    cmp r12, 9
    jne .L1449
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1444
    jmp .L1450
.L1449:
.L1450:
    cmp r12, 7
    jne .L1451
    mov rax, [rel __g_kasm_ar_s]
    cmp rax, 4
    jl .L1453
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1454
.L1453:
.L1454:
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rax, r14
    sub rax, 1
    and rax, 255
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1444
    jmp .L1452
.L1451:
.L1452:
    cmp r12, 5
    jne .L1455
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1444
    jmp .L1456
.L1455:
.L1456:
    cmp r12, 3
    jne .L1457
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1444
    jmp .L1458
.L1457:
.L1458:
    cmp r12, 13
    jne .L1459
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1444
    jmp .L1460
.L1459:
.L1460:
    cmp r12, 2
    je .L1461
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1444
    jmp .L1462
.L1461:
.L1462:
    mov rax, [rel __g_kasm_ar_d]
    cmp rax, 8
    jl .L1463
    mov rcx, 0x41
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1464
.L1463:
    mov rax, [rel __g_kasm_ar_d]
    cmp rax, 4
    jl .L1465
    mov rcx, 0x40
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1466
.L1465:
.L1466:
.L1464:
    cmp r14, 0x85
    jne .L1467
    mov rcx, 0xF6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1444
    jmp .L1468
.L1467:
.L1468:
    mov rcx, 0x80
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1444
.__ret_1444:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_arith_sib_imm:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 64
    mov rbx, rax
    mov rax, [rel __g_kasm_ar_ks]
    mov rcx, 2
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1472
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1472
    mov rax, 0
    jmp .L1473
.L1472:
    mov rax, 1
.L1473:
    test rax, rax
    jz .L1470
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1469
    jmp .L1471
.L1470:
.L1471:
    mov rax, [rel __g_kasm_ar_d]
    shr rax, 8
    and rax, 255
    and rax, 8
    cmp rax, 0
    je .L1474
    or rbx, 2
    jmp .L1475
.L1474:
.L1475:
    mov rax, [rel __g_kasm_ar_d]
    and rax, 255
    and rax, 8
    cmp rax, 0
    je .L1476
    or rbx, 1
    jmp .L1477
.L1476:
.L1477:
    cmp rbx, 64
    je .L1478
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1479
.L1478:
.L1479:
    cmp r13, 0x85
    jne .L1480
    mov rcx, 0xF6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 0
    mov r12, rax
    jmp .L1481
.L1480:
    mov rcx, 0x80
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1481:
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_sib_modrm
    add rsp, 32
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1469
.__ret_1469:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_arith_mem:
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
    mov rax, [rel __g_kasm_ar_ks]
    mov r13, rax
    mov rax, 1
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1485
    mov rax, r13
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1485
    mov rax, 0
    jmp .L1486
.L1485:
    mov rax, 1
.L1486:
    test rax, rax
    jz .L1483
    cmp r13, 8
    jne .L1487
    mov rax, 0
    mov r12, rax
    jmp .L1488
.L1487:
.L1488:
    mov rax, [rel __g_kasm_ar_d]
    mov rbx, rax
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 5
    jne .L1489
    mov rax, 0
    mov rbx, rax
    jmp .L1490
.L1489:
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 13
    jne .L1491
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    jmp .L1492
.L1491:
.L1492:
.L1490:
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 5
    jne .L1493
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1482
    jmp .L1494
.L1493:
.L1494:
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 13
    jne .L1495
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1482
    jmp .L1496
.L1495:
.L1496:
    mov rax, [rel __g_kasm_ar_s]
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1482
    jmp .L1484
.L1483:
.L1484:
    cmp r13, 2
    je .L1497
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1482
    jmp .L1498
.L1497:
.L1498:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1499
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1500
.L1499:
.L1500:
    mov rax, 1
    mov r12, rax
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1505
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1505
    mov rax, 0
    jmp .L1506
.L1505:
    mov rax, 1
.L1506:
    test rax, rax
    jnz .L1503
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1503
    mov rax, 0
    jmp .L1504
.L1503:
    mov rax, 1
.L1504:
    test rax, rax
    jz .L1501
    mov rax, 0
    mov r12, rax
    jmp .L1502
.L1501:
.L1502:
    mov rax, [rel __g_kasm_ar_d]
    mov rbx, rax
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 13
    jne .L1507
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    jmp .L1508
.L1507:
.L1508:
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 5
    jne .L1509
    mov rax, 0
    mov rbx, rax
    jmp .L1510
.L1509:
.L1510:
    mov rcx, r12
    mov rdx, 0
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    cmp r15, 0x85
    jne .L1511
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1513
    mov rcx, 0xF6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1514
.L1513:
    mov rcx, 0xF7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1514:
    jmp .L1512
.L1511:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1515
    mov rcx, 0x80
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1516
.L1515:
    mov rcx, 0x81
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1516:
.L1512:
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 5
    jne .L1517
    mov rax, [rel __g_kasm_dst_addend]
    mov [rel __g_kasm_cur_addend], rax
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1519
    mov rax, [rel __g_kasm_cur_addend]
    sub rax, 1
    mov [rel __g_kasm_cur_addend], rax
    jmp .L1520
.L1519:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1521
    mov rax, [rel __g_kasm_cur_addend]
    sub rax, 2
    mov [rel __g_kasm_cur_addend], rax
    jmp .L1522
.L1521:
    mov rax, [rel __g_kasm_cur_addend]
    sub rax, 4
    mov [rel __g_kasm_cur_addend], rax
.L1522:
.L1520:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .L1518
.L1517:
    mov rax, [rel __g_kasm_ar_kd]
    cmp rax, 13
    jne .L1523
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .L1524
.L1523:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_ar_d]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
.L1524:
.L1518:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1525
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1482
    jmp .L1526
.L1525:
.L1526:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1527
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1482
    jmp .L1528
.L1527:
.L1528:
    mov rax, [rel __g_kasm_ar_s]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1482
.__ret_1482:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_i_imul:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rbp-8], rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r15, rax
    lea rax, [rel __g_kasm_tok_c]
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    mov [rel __g_kasm_en_r12], rax
.L1530:
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1533
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1533
    mov rax, 1
    jmp .L1534
.L1533:
    mov rax, 0
.L1534:
    test rax, rax
    jz .L1531
    add r14, 1
.L1532:
    jmp .L1530
.L1531:
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 44
    jne .L1535
    mov rcx, r14
    mov rdx, 0
    sub rsp, 32
    call ks_bs
    add rsp, 32
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rcx, r14
    mov rdx, 44
    sub rsp, 32
    call ks_bs
    add rsp, 32
    add r14, 1
.L1537:
    mov rcx, r14
    sub rsp, 32
    call ks_b
    add rsp, 32
    cmp rax, 32
    jne .L1538
    add r14, 1
.L1539:
    jmp .L1537
.L1538:
    mov rcx, r14
    sub rsp, 32
    call ks_parse_expr
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    jmp .L1536
.L1535:
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    cmp r12, 2
    je .L1540
    mov rax, [rbp-8]
    cmp rax, 1
    jne .L1542
    mov rax, 1
    mov rbx, rax
    jmp .L1543
.L1542:
.L1543:
    mov rcx, rbx
    mov rdx, r15
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0xAF
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r15
    mov r8, r13
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1529
    jmp .L1541
.L1540:
.L1541:
    mov rax, r13
    mov r12, rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    mov rax, r15
    mov r13, rax
.L1536:
    mov rax, [rbp-8]
    cmp rax, 1
    jne .L1544
    mov rax, 1
    mov rbx, rax
    jmp .L1545
.L1544:
.L1545:
    mov rcx, rbx
    mov rdx, r15
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_sx8
    add rsp, 32
    cmp rax, r12
    jne .L1546
    mov rcx, 0x6B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r15
    mov r8, r13
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1529
    jmp .L1547
.L1546:
.L1547:
    mov rcx, 0x69
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r15
    mov r8, r13
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1529
.__ret_1529:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ks_sx8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    and rbx, 255
    cmp rbx, 128
    jl .L1549
    mov rax, rbx
    sub rax, 256
    jmp .__ret_1548
    jmp .L1550
.L1549:
.L1550:
    mov rax, rbx
    jmp .__ret_1548
.__ret_1548:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_unary_f7:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_dst_base], rax
    mov rax, r12
    mov [rel __g_kasm_en_r12], rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    cmp r12, 8
    jne .L1552
    mov rcx, 0
    mov rdx, 0
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    jmp .L1553
.L1552:
    cmp r12, 1
    jne .L1554
    mov rcx, 1
    mov rdx, 0
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    jmp .L1555
.L1554:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1551
.L1555:
.L1553:
    mov rcx, 0xF7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1551
.__ret_1551:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_unary_ff:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, 1
    mov rbx, rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_dst_base], rax
    mov rax, r13
    mov [rel __g_kasm_en_r12], rax
    mov rax, r13
    mov [rel __g_kasm_en_r14], rax
    mov rax, r13
    mov rcx, 5
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1559
    mov rax, r13
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1559
    mov rax, 0
    jmp .L1560
.L1559:
    mov rax, 1
.L1560:
    test rax, rax
    jz .L1557
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1561
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1562
.L1561:
.L1562:
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1567
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1567
    mov rax, 0
    jmp .L1568
.L1567:
    mov rax, 1
.L1568:
    test rax, rax
    jnz .L1565
    mov rax, [rel __g_kasm_op_size]
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1565
    mov rax, 0
    jmp .L1566
.L1565:
    mov rax, 1
.L1566:
    test rax, rax
    jz .L1563
    mov rax, 0
    mov rbx, rax
    jmp .L1564
.L1563:
.L1564:
    cmp r13, 5
    jne .L1569
    mov rcx, rbx
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    jmp .L1570
.L1569:
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
.L1570:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1571
    mov rcx, 0xFE
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1572
.L1571:
    mov rcx, 0xFF
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1572:
    cmp r13, 5
    jne .L1573
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1556
    jmp .L1574
.L1573:
.L1574:
    mov rax, r14
    push rax
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1556
    jmp .L1558
.L1557:
.L1558:
    cmp r13, 8
    jne .L1575
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xFF
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1556
    jmp .L1576
.L1575:
.L1576:
    cmp r13, 7
    jne .L1577
    cmp r12, 4
    jl .L1579
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1580
.L1579:
.L1580:
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xFE
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1556
    jmp .L1578
.L1577:
.L1578:
    cmp r13, 1
    je .L1581
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1556
    jmp .L1582
.L1581:
.L1582:
    mov rcx, 1
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xFF
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1556
.__ret_1556:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_i_lea:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_src_base], rax
    cmp r12, 5
    jne .L1584
    mov rcx, 1
    mov rdx, r13
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8D
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1583
    jmp .L1585
.L1584:
.L1585:
    cmp r12, 11
    jne .L1586
    mov rcx, 1
    mov rdx, r13
    mov r8, 4
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8D
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, 4
    push rax
    mov rax, 0
    sub rax, rbx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1583
    jmp .L1587
.L1586:
.L1587:
    cmp r12, 12
    jne .L1588
    mov rcx, 0x8D
    mov rdx, r13
    mov r8, rbx
    mov r9, 1
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1583
    jmp .L1589
.L1588:
.L1589:
    cmp r12, 9
    jne .L1590
    mov rcx, 1
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8D
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1583
    jmp .L1591
.L1590:
.L1591:
    cmp r12, 13
    jne .L1592
    mov rax, 1
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8D
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1583
    jmp .L1593
.L1592:
.L1593:
    cmp r12, 3
    je .L1594
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1583
    jmp .L1595
.L1594:
.L1595:
    mov rcx, 1
    mov rdx, r13
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8D
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1583
.__ret_1583:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_i_rep:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 0xF3
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    lea rax, [rel __g_kasm_tok_b]
    push rax
section .data
.str1599: db 109,111,118,115,98,0
section .text
    lea rax, [rel .str1599]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_str_eq
    add rsp, 32
    cmp rax, 1
    jne .L1597
    mov rcx, 0xA4
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1596
    jmp .L1598
.L1597:
.L1598:
    lea rax, [rel __g_kasm_tok_b]
    push rax
section .data
.str1602: db 115,116,111,115,98,0
section .text
    lea rax, [rel .str1602]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_str_eq
    add rsp, 32
    cmp rax, 1
    jne .L1600
    mov rcx, 0xAA
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1596
    jmp .L1601
.L1600:
.L1601:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1596
.__ret_1596:
    mov rsp, rbp
    pop rbp
    ret
ks_i_call:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    jne .L1604
    mov rcx, 0
    mov rdx, 0
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xFF
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, 2
    mov r8, rbx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1603
    jmp .L1605
.L1604:
.L1605:
    mov rcx, 0xE8
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    sub rsp, 32
    call ks_rel32_target
    add rsp, 32
    jmp .__ret_1603
.__ret_1603:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_jcc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    sub rsp, 32
    call ks_rel32_target
    add rsp, 32
    jmp .__ret_1606
.__ret_1606:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_rel32_target:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1610
    mov rax, r12
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1610
    mov rax, 1
    jmp .L1611
.L1610:
    mov rax, 0
.L1611:
    test rax, rax
    jz .L1608
    mov rcx, r12
    mov rdx, 0
    sub rsp, 32
    call ks_add_fixup
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1607
    jmp .L1609
.L1608:
.L1609:
    lea rax, [rel __g_kasm_tok_b]
    push rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_strlen
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_find_extern
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1612
    mov rcx, rbx
    sub rsp, 32
    call ks_add_extref
    add rsp, 32
    jmp .L1613
.L1612:
    sub rsp, 32
    call ks_unknown_label
    add rsp, 32
.L1613:
    mov rcx, 0
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1607
.__ret_1607:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_setcc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0xC0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1614
.__ret_1614:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_kasm_mz_kd: dq 0
section .text
section .data
__g_kasm_mz_d: dq 0
section .text
section .data
__g_kasm_mz_ks: dq 0
section .text
section .data
__g_kasm_mz_s: dq 0
section .text
ks_i_movsx:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov [rel __g_kasm_en_r14], rax
    cmp r12, 7
    je .L1616
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1615
    jmp .L1617
.L1616:
.L1617:
    mov rcx, 1
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0xBE
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1615
.__ret_1615:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_i_movzx:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_mz_kd], rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_mz_d], rax
    mov rax, [rel __g_kasm_mz_kd]
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_mz_ks], rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_src_base], rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_mz_s], rax
    mov rax, [rel __g_kasm_mz_ks]
    mov [rel __g_kasm_en_r14], rax
    mov rax, [rel __g_kasm_mz_ks]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 5
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1625
    mov rax, rbx
    mov rcx, 3
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1625
    mov rax, 0
    jmp .L1626
.L1625:
    mov rax, 1
.L1626:
    test rax, rax
    jnz .L1623
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1623
    mov rax, 0
    jmp .L1624
.L1623:
    mov rax, 1
.L1624:
    test rax, rax
    jnz .L1621
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1621
    mov rax, 0
    jmp .L1622
.L1621:
    mov rax, 1
.L1622:
    test rax, rax
    jz .L1619
    mov rcx, rbx
    sub rsp, 32
    call ks_movzx_mem
    add rsp, 32
    jmp .__ret_1618
    jmp .L1620
.L1619:
.L1620:
    cmp rbx, 12
    jne .L1627
    sub rsp, 32
    call ks_movzx_sib
    add rsp, 32
    jmp .__ret_1618
    jmp .L1628
.L1627:
.L1628:
    mov rax, rbx
    mov rcx, 7
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1631
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1631
    mov rax, 0
    jmp .L1632
.L1631:
    mov rax, 1
.L1632:
    test rax, rax
    jz .L1629
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0xB6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1618
    jmp .L1630
.L1629:
.L1630:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1618
.__ret_1618:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_movzx_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_mz_kd]
    cmp rax, 1
    jne .L1634
    mov rax, 1
    mov r12, rax
    jmp .L1635
.L1634:
.L1635:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 4
    jne .L1636
    sub rsp, 32
    call ks_mz32_load
    add rsp, 32
    jmp .__ret_1633
    jmp .L1637
.L1636:
.L1637:
    cmp r13, 5
    jne .L1638
    mov rax, 0
    mov rbx, rax
    jmp .L1639
.L1638:
    cmp r13, 3
    jne .L1640
    mov rax, 5
    mov rbx, rax
    jmp .L1641
.L1640:
    cmp r13, 9
    jne .L1642
    mov rax, [rel __g_kasm_mz_s]
    mov rbx, rax
    jmp .L1643
.L1642:
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
.L1643:
.L1641:
.L1639:
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_mz_d]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1644
    mov rcx, 0xB7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1645
.L1644:
    mov rcx, 0xB6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1645:
    cmp r13, 5
    jne .L1646
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1633
    jmp .L1647
.L1646:
.L1647:
    cmp r13, 3
    jne .L1648
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1633
    jmp .L1649
.L1648:
.L1649:
    cmp r13, 9
    jne .L1650
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1633
    jmp .L1651
.L1650:
.L1651:
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1633
.__ret_1633:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_movzx_sib:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_mz_kd]
    cmp rax, 1
    jne .L1653
    or rbx, 8
    jmp .L1654
.L1653:
.L1654:
    mov rax, [rel __g_kasm_mz_d]
    and rax, 8
    cmp rax, 0
    je .L1655
    or rbx, 4
    jmp .L1656
.L1655:
.L1656:
    mov rax, [rel __g_kasm_mz_s]
    shr rax, 8
    and rax, 8
    cmp rax, 0
    je .L1657
    or rbx, 2
    jmp .L1658
.L1657:
.L1658:
    mov rax, [rel __g_kasm_mz_s]
    and rax, 8
    cmp rax, 0
    je .L1659
    or rbx, 1
    jmp .L1660
.L1659:
.L1660:
    cmp rbx, 0
    je .L1661
    mov rax, rbx
    or rax, 64
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1662
.L1661:
.L1662:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 4
    jne .L1663
    sub rsp, 32
    call ks_mz32_load
    add rsp, 32
    jmp .__ret_1652
    jmp .L1664
.L1663:
.L1664:
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1665
    mov rcx, 0xB7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1666
.L1665:
    mov rcx, 0xB6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1666:
    mov rax, [rel __g_kasm_mz_d]
    push rax
    mov rax, [rel __g_kasm_mz_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_sib_modrm
    add rsp, 32
    jmp .__ret_1652
.__ret_1652:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_mz32_load:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_mz_ks]
    mov r13, rax
    mov rax, [rel __g_kasm_mz_d]
    mov r12, rax
    mov rax, [rel __g_kasm_mz_s]
    mov rbx, rax
    cmp r13, 3
    jne .L1668
    mov rcx, 0
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1667
    jmp .L1669
.L1668:
.L1669:
    cmp r13, 9
    jne .L1670
    mov rcx, 0
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1667
    jmp .L1671
.L1670:
.L1671:
    cmp r13, 13
    jne .L1672
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1667
    jmp .L1673
.L1672:
.L1673:
    cmp r13, 12
    jne .L1674
    mov rcx, 0x8B
    mov rdx, r12
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1667
    jmp .L1675
.L1674:
.L1675:
    cmp r13, 5
    jne .L1676
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1667
    jmp .L1677
.L1676:
.L1677:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1667
.__ret_1667:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_kasm_ss_d: dq 0
section .text
section .data
__g_kasm_ss_s: dq 0
section .text
ks_sse_ops:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_ss_d], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov [rel __g_kasm_ss_s], rax
    mov rax, 0
    jmp .__ret_1678
.__ret_1678:
    mov rsp, rbp
    pop rbp
    ret
ks_sse_packed:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    sub rsp, 32
    call ks_sse_ops
    add rsp, 32
    cmp rbx, 0
    je .L1680
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1681
.L1680:
.L1681:
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1679
.__ret_1679:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_sse_arith:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov [rel __g_kasm_sse_pfx], rax
    sub rsp, 32
    call ks_sse_ops
    add rsp, 32
    mov rax, [rel __g_kasm_sse_pfx]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1682
.__ret_1682:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_sse_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
    call ks_sse_ops
    add rsp, 32
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1683
.__ret_1683:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_i_xorps:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call ks_sse_ops
    add rsp, 32
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0x57
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1684
.__ret_1684:
    mov rsp, rbp
    pop rbp
    ret
ks_i_cvtsi:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call ks_sse_ops
    add rsp, 32
    mov rcx, 0xF2
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0x2A
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1685
.__ret_1685:
    mov rsp, rbp
    pop rbp
    ret
ks_sse_to_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
    call ks_sse_ops
    add rsp, 32
    mov rcx, 0xF2
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 1
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, 3
    push rax
    mov rax, [rel __g_kasm_ss_d]
    push rax
    mov rax, [rel __g_kasm_ss_s]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1686
.__ret_1686:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_i_movq:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r15, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0x6E
    mov rbx, rax
    mov rax, r15
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    cmp r15, 6
    je .L1688
    mov rax, 0x7E
    mov rbx, rax
    mov rax, r14
    mov r12, rax
    mov rax, r13
    mov r14, rax
    mov rax, r12
    mov r13, rax
    jmp .L1689
.L1688:
.L1689:
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 1
    mov rdx, r14
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, r14
    mov r8, r13
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1687
.__ret_1687:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_sse_mov:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r15, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, r13
    mov [rel __g_kasm_en_r14], rax
    cmp r15, 6
    jne .L1691
    mov rax, [rbp-16]
    cmp rax, 0
    je .L1693
    mov rcx, [rbp-16]
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1694
.L1693:
.L1694:
    mov rax, r13
    mov rcx, 6
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1697
    mov rax, r13
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1697
    mov rax, 0
    jmp .L1698
.L1697:
    mov rax, 1
.L1698:
    test rax, rax
    jz .L1695
    mov rax, r12
    mov rbx, rax
    jmp .L1696
.L1695:
.L1696:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, [rbp-8]
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r13, 6
    jne .L1699
    mov rcx, 3
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1690
    jmp .L1700
.L1699:
.L1700:
    cmp r13, 3
    jne .L1701
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1690
    jmp .L1702
.L1701:
.L1702:
    cmp r13, 9
    jne .L1703
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1690
    jmp .L1704
.L1703:
.L1704:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1690
    jmp .L1692
.L1691:
.L1692:
    mov rax, [rbp-8]
    add rax, 1
    and rax, 255
    mov [rbp-8], rax
    mov rax, [rbp-16]
    cmp rax, 0
    je .L1705
    mov rcx, [rbp-16]
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1706
.L1705:
.L1706:
    cmp r15, 9
    jne .L1707
    mov rax, r14
    mov rbx, rax
    jmp .L1708
.L1707:
.L1708:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, [rbp-8]
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r15, 3
    jne .L1709
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1690
    jmp .L1710
.L1709:
.L1710:
    cmp r15, 9
    jne .L1711
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1690
    jmp .L1712
.L1711:
.L1712:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1690
.__ret_1690:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ks_i_movsd:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    mov [rel __g_kasm_sse_pfx], rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r15, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, r15
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, r13
    mov [rel __g_kasm_en_r14], rax
    cmp r15, 6
    je .L1714
    mov rax, [rel __g_kasm_sse_pfx]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r15, 9
    jne .L1716
    mov rax, r14
    mov rbx, rax
    jmp .L1717
.L1716:
.L1717:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0x11
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r15, 3
    jne .L1718
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1713
    jmp .L1719
.L1718:
.L1719:
    cmp r15, 9
    jne .L1720
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1713
    jmp .L1721
.L1720:
.L1721:
    cmp r15, 5
    jne .L1722
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1713
    jmp .L1723
.L1722:
.L1723:
    cmp r15, 12
    jne .L1724
    mov rax, r14
    and rax, 0x0808
    cmp rax, 0
    je .L1726
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1713
    jmp .L1727
.L1726:
.L1727:
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
    call ks_emit_sib_modrm
    add rsp, 32
    jmp .__ret_1713
    jmp .L1725
.L1724:
.L1725:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1713
    jmp .L1715
.L1714:
.L1715:
    mov rax, [rel __g_kasm_sse_pfx]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r13
    mov rcx, 6
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1730
    mov rax, r13
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1730
    mov rax, 0
    jmp .L1731
.L1730:
    mov rax, 1
.L1731:
    test rax, rax
    jz .L1728
    mov rax, r12
    mov rbx, rax
    jmp .L1729
.L1728:
.L1729:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
    call ks_sse_rex
    add rsp, 32
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0x10
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r13, 6
    jne .L1732
    mov rcx, 3
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1713
    jmp .L1733
.L1732:
.L1733:
    cmp r13, 3
    jne .L1734
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1713
    jmp .L1735
.L1734:
.L1735:
    cmp r13, 9
    jne .L1736
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1713
    jmp .L1737
.L1736:
.L1737:
    cmp r13, 5
    jne .L1738
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1713
    jmp .L1739
.L1738:
.L1739:
    cmp r13, 12
    jne .L1740
    mov rax, r12
    and rax, 0x0808
    cmp rax, 0
    je .L1742
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1713
    jmp .L1743
.L1742:
.L1743:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ks_emit_sib_modrm
    add rsp, 32
    jmp .__ret_1713
    jmp .L1741
.L1740:
.L1741:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1713
.__ret_1713:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_cacheop:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    cmp r12, 9
    je .L1745
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1744
    jmp .L1746
.L1745:
.L1746:
    cmp rbx, 8
    jl .L1747
    mov rcx, 0x41
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1748
.L1747:
.L1748:
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1744
.__ret_1744:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r15, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
    mov rax, r15
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_po_val]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, r13
    mov [rel __g_kasm_en_r14], rax
    cmp r15, 7
    jne .L1750
    cmp r13, 2
    je .L1752
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1749
    jmp .L1753
.L1752:
.L1753:
    cmp r14, 8
    jl .L1754
    mov rcx, 0x41
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1755
.L1754:
    cmp r14, 4
    jl .L1756
    mov rcx, 0x40
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1757
.L1756:
.L1757:
.L1755:
    mov rcx, 0xC0
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, [rbp-8]
    mov r8, r14
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1749
    jmp .L1751
.L1750:
.L1751:
    cmp r15, 8
    jne .L1758
    mov rax, 0
    mov rbx, rax
    jmp .L1759
.L1758:
    cmp r15, 1
    je .L1760
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1749
    jmp .L1761
.L1760:
.L1761:
.L1759:
    cmp r13, 7
    jne .L1762
    cmp r12, 1
    je .L1764
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1749
    jmp .L1765
.L1764:
.L1765:
    mov rcx, rbx
    mov rdx, 0
    mov r8, r14
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xD3
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, [rbp-8]
    mov r8, r14
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1749
    jmp .L1763
.L1762:
.L1763:
    cmp r13, 2
    je .L1766
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1749
    jmp .L1767
.L1766:
.L1767:
    mov rcx, rbx
    mov rdx, 0
    mov r8, r14
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC1
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, [rbp-8]
    mov r8, r14
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1749
.__ret_1749:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_kasm_mv_kd: dq 0
section .text
section .data
__g_kasm_mv_vd: dq 0
section .text
section .data
__g_kasm_mv_ks: dq 0
section .text
section .data
__g_kasm_mv_vs: dq 0
section .text
ks_lo:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    jmp .__ret_1768
.__ret_1768:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_i_xchg:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_po_val]
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_kasm_po_val]
    mov r12, rax
    mov rax, rbx
    mov [rel __g_kasm_en_r14], rax
    mov rcx, r14
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 9
    je .L1770
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1769
    jmp .L1771
.L1770:
.L1771:
    mov rcx, rbx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 8
    jne .L1772
    mov rax, 0
    mov rbx, rax
    jmp .L1773
.L1772:
    mov rcx, rbx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    jne .L1774
    mov rax, 1
    mov rbx, rax
    jmp .L1775
.L1774:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1769
.L1775:
.L1773:
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x87
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1769
.__ret_1769:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ks_i_mov:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov [rel __g_kasm_mv_kd], rax
    mov rax, [rel __g_kasm_po_val]
    mov [rel __g_kasm_mv_vd], rax
    mov rax, [rel __g_kasm_cur_addend]
    mov [rel __g_kasm_dst_addend], rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_dst_base], rax
    mov rax, [rel __g_kasm_mv_kd]
    mov [rel __g_kasm_en_r12], rax
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_parse_operand
    add rsp, 32
    mov [rel __g_kasm_mv_ks], rax
    mov rax, [rel __g_kasm_po_val]
    mov [rel __g_kasm_mv_vs], rax
    mov rax, [rel __g_kasm_po_r8]
    mov [rel __g_kasm_src_base], rax
    mov rax, [rel __g_kasm_mv_ks]
    mov [rel __g_kasm_en_r14], rax
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    jne .L1777
    lea rax, [rel __g_kasm_tok_b]
    push rax
    pop rcx
    sub rsp, 32
    call ks_crnum
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    je .L1779
    mov rcx, rbx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, 0x22
    sub rsp, 32
    call ks_mov_cr
    add rsp, 32
    jmp .__ret_1776
    jmp .L1780
.L1779:
.L1780:
    jmp .L1778
.L1777:
.L1778:
    mov rax, [rel __g_kasm_mv_kd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    jne .L1781
    lea rax, [rel __g_kasm_tok_c]
    push rax
    pop rcx
    sub rsp, 32
    call ks_crnum
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rcx, 0xFFFFFFFF
    cmp rax, rcx
    je .L1783
    mov rcx, rbx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, 0x20
    sub rsp, 32
    call ks_mov_cr
    add rsp, 32
    jmp .__ret_1776
    jmp .L1784
.L1783:
.L1784:
    jmp .L1782
.L1781:
.L1782:
    mov rax, [rel __g_kasm_mv_kd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L1785
    sub rsp, 32
    call ks_mov_to_reg
    add rsp, 32
    jmp .__ret_1776
    jmp .L1786
.L1785:
.L1786:
    cmp rbx, 8
    jne .L1787
    sub rsp, 32
    call ks_mov_to_r32
    add rsp, 32
    jmp .__ret_1776
    jmp .L1788
.L1787:
.L1788:
    cmp rbx, 12
    jne .L1789
    sub rsp, 32
    call ks_mov_to_sib
    add rsp, 32
    jmp .__ret_1776
    jmp .L1790
.L1789:
.L1790:
    cmp rbx, 13
    jne .L1791
    sub rsp, 32
    call ks_mov_to_bd
    add rsp, 32
    jmp .__ret_1776
    jmp .L1792
.L1791:
.L1792:
    cmp rbx, 3
    jne .L1793
    sub rsp, 32
    call ks_mov_to_mem
    add rsp, 32
    jmp .__ret_1776
    jmp .L1794
.L1793:
.L1794:
    cmp rbx, 9
    jne .L1795
    sub rsp, 32
    call ks_mov_to_memreg
    add rsp, 32
    jmp .__ret_1776
    jmp .L1796
.L1795:
.L1796:
    cmp rbx, 5
    jne .L1797
    sub rsp, 32
    call ks_mov_to_rip
    add rsp, 32
    jmp .__ret_1776
    jmp .L1798
.L1797:
.L1798:
    cmp rbx, 11
    jne .L1799
    sub rsp, 32
    call ks_mov_to_rsp
    add rsp, 32
    jmp .__ret_1776
    jmp .L1800
.L1799:
.L1800:
    cmp rbx, 7
    jne .L1801
    sub rsp, 32
    call ks_mov_to_reg8
    add rsp, 32
    jmp .__ret_1776
    jmp .L1802
.L1801:
.L1802:
    cmp rbx, 10
    jne .L1803
    sub rsp, 32
    call ks_mov_to_reg16
    add rsp, 32
    jmp .__ret_1776
    jmp .L1804
.L1803:
.L1804:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1776
.__ret_1776:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_cr:
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
    mov rax, 0
    mov rbx, rax
    cmp r14, 8
    jl .L1806
    or rbx, 0x44
    jmp .L1807
.L1806:
.L1807:
    cmp r13, 8
    jl .L1808
    or rbx, 0x41
    jmp .L1809
.L1808:
.L1809:
    cmp rbx, 0
    je .L1810
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1811
.L1810:
.L1811:
    mov rcx, 0x0F
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r14
    and rax, 7
    shl rax, 3
    mov rcx, rax
    mov rax, 0xC0
    or rax, rcx
    push rax
    mov rax, r13
    and rax, 7
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1805
.__ret_1805:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_r32:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    cmp r13, 3
    jne .L1813
    mov rcx, 0
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1812
    jmp .L1814
.L1813:
.L1814:
    cmp r13, 2
    jne .L1815
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rax, r12
    and rax, 7
    mov rcx, rax
    mov rax, 0xB8
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1812
    jmp .L1816
.L1815:
.L1816:
    cmp r13, 8
    jne .L1817
    mov rcx, 0
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1812
    jmp .L1818
.L1817:
.L1818:
    cmp r13, 5
    jne .L1819
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1812
    jmp .L1820
.L1819:
.L1820:
    cmp r13, 9
    jne .L1821
    mov rcx, 0
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1812
    jmp .L1822
.L1821:
.L1822:
    cmp r13, 13
    jne .L1823
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1812
    jmp .L1824
.L1823:
.L1824:
    cmp r13, 12
    jne .L1825
    mov rcx, 0x8B
    mov rdx, r12
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1812
    jmp .L1826
.L1825:
.L1826:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1812
.__ret_1812:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_rsp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 1
    jne .L1828
    mov rcx, 1
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r12, 127
    jg .L1830
    mov rcx, 1
    mov rdx, rbx
    mov r8, 4
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, 0x24
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1827
    jmp .L1831
.L1830:
.L1831:
    mov rcx, 2
    mov rdx, rbx
    mov r8, 4
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, 0x24
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1827
    jmp .L1829
.L1828:
.L1829:
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    cmp rax, 2
    je .L1832
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1827
    jmp .L1833
.L1832:
.L1833:
    mov rcx, 1
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r12, 127
    jle .L1834
    mov rcx, 2
    mov rdx, 0
    mov r8, 4
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, 0x24
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .L1835
.L1834:
    mov rcx, 1
    mov rdx, 0
    mov r8, 4
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    mov rcx, 0x24
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
.L1835:
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1827
.__ret_1827:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_rip:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_kasm_dst_addend]
    mov [rel __g_kasm_cur_addend], rax
    cmp r14, 7
    jne .L1837
    cmp r12, 4
    jl .L1839
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1840
.L1839:
.L1840:
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x88
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1836
    jmp .L1838
.L1837:
.L1838:
    cmp r14, 8
    jne .L1841
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1836
    jmp .L1842
.L1841:
.L1842:
    cmp r14, 10
    jne .L1843
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1836
    jmp .L1844
.L1843:
.L1844:
    cmp r14, 2
    jne .L1845
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1847
    mov rcx, 0xC6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_dst_addend]
    sub rax, 1
    mov [rel __g_kasm_cur_addend], rax
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1836
    jmp .L1848
.L1847:
.L1848:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1849
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_dst_addend]
    sub rax, 2
    mov [rel __g_kasm_cur_addend], rax
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1836
    jmp .L1850
.L1849:
.L1850:
    mov rax, 1
    mov rbx, rax
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 4
    jne .L1851
    mov rax, 0
    mov rbx, rax
    jmp .L1852
.L1851:
.L1852:
    mov rcx, rbx
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_dst_addend]
    sub rax, 4
    mov [rel __g_kasm_cur_addend], rax
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1836
    jmp .L1846
.L1845:
.L1846:
    cmp r14, 1
    je .L1853
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1836
    jmp .L1854
.L1853:
.L1854:
    mov rcx, 1
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1836
.__ret_1836:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_bd:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r15, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_dst_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r15, 1
    jne .L1856
    mov rcx, 1
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1855
    jmp .L1857
.L1856:
.L1857:
    cmp r15, 8
    jne .L1858
    mov rcx, 0
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1855
    jmp .L1859
.L1858:
.L1859:
    cmp r15, 10
    jne .L1860
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1855
    jmp .L1861
.L1860:
.L1861:
    cmp r15, 2
    jne .L1862
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1864
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1855
    jmp .L1865
.L1864:
.L1865:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1866
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1855
    jmp .L1867
.L1866:
.L1867:
    mov rax, 1
    mov rbx, rax
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 4
    jne .L1868
    mov rax, 0
    mov rbx, rax
    jmp .L1869
.L1868:
.L1869:
    mov rcx, rbx
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1855
    jmp .L1863
.L1862:
.L1863:
    cmp r15, 7
    jne .L1870
    cmp r13, 4
    jl .L1872
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1873
.L1872:
.L1873:
    mov rcx, 0
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x88
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, r14
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1855
    jmp .L1871
.L1870:
.L1871:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1855
.__ret_1855:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_sib:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    cmp r13, 7
    jne .L1875
    cmp rbx, 4
    jl .L1877
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1878
.L1877:
.L1878:
    mov rcx, 0x88
    mov rdx, rbx
    mov r8, r12
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1874
    jmp .L1876
.L1875:
.L1876:
    cmp r13, 8
    jne .L1879
    mov rcx, 0x89
    mov rdx, rbx
    mov r8, r12
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1874
    jmp .L1880
.L1879:
.L1880:
    cmp r13, 10
    jne .L1881
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0x89
    mov rdx, rbx
    mov r8, r12
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1874
    jmp .L1882
.L1881:
.L1882:
    cmp r13, 2
    jne .L1883
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    je .L1885
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1874
    jmp .L1886
.L1885:
.L1886:
    mov rcx, 0xC6
    mov rdx, 0
    mov r8, r12
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1874
    jmp .L1884
.L1883:
.L1884:
    cmp r13, 1
    je .L1887
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1874
    jmp .L1888
.L1887:
.L1888:
    mov rcx, 0x89
    mov rdx, rbx
    mov r8, r12
    mov r9, 1
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1874
.__ret_1874:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_reg16:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    cmp r13, 2
    jne .L1890
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rax, r12
    and rax, 7
    mov rcx, rax
    mov rax, 0xB8
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1889
    jmp .L1891
.L1890:
.L1891:
    cmp r13, 10
    jne .L1892
    mov rcx, 0
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1889
    jmp .L1893
.L1892:
.L1893:
    cmp r13, 9
    jne .L1894
    mov rcx, 0
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1889
    jmp .L1895
.L1894:
.L1895:
    cmp r13, 5
    jne .L1896
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1889
    jmp .L1897
.L1896:
.L1897:
    cmp r13, 12
    jne .L1898
    mov rcx, 0x8B
    mov rdx, r12
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1889
    jmp .L1899
.L1898:
.L1899:
    cmp r13, 13
    jne .L1900
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1889
    jmp .L1901
.L1900:
.L1901:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1889
.__ret_1889:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_reg8:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    cmp r12, 4
    jl .L1903
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1904
.L1903:
.L1904:
    cmp r13, 7
    jne .L1905
    cmp rbx, 4
    jl .L1907
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1908
.L1907:
.L1908:
    mov rcx, 0
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x88
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1902
    jmp .L1906
.L1905:
.L1906:
    cmp r13, 2
    jne .L1909
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rax, r12
    and rax, 7
    mov rcx, rax
    mov rax, 0xB0
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1902
    jmp .L1910
.L1909:
.L1910:
    cmp r13, 9
    jne .L1911
    mov rcx, 0
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8A
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1902
    jmp .L1912
.L1911:
.L1912:
    cmp r13, 12
    jne .L1913
    mov rcx, 0x8A
    mov rdx, r12
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1902
    jmp .L1914
.L1913:
.L1914:
    cmp r13, 13
    jne .L1915
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8A
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1902
    jmp .L1916
.L1915:
.L1916:
    cmp r13, 5
    jne .L1917
    mov rcx, 0
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8A
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1902
    jmp .L1918
.L1917:
.L1918:
    cmp r13, 3
    jne .L1919
    mov rcx, 0
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8A
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1902
    jmp .L1920
.L1919:
.L1920:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1902
.__ret_1902:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov rbx, rax
    cmp r13, 12
    jne .L1922
    mov rcx, 0x8B
    mov rdx, r12
    mov r8, rbx
    mov r9, 1
    sub rsp, 32
    call ks_emit_sib_mem
    add rsp, 32
    jmp .__ret_1921
    jmp .L1923
.L1922:
.L1923:
    cmp r13, 2
    jne .L1924
    mov rax, [rel __g_kasm_mv_vs]
    shr rax, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1928
    mov rax, rbx
    mov rcx, 0x80000000
    and rax, rcx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1928
    mov rax, 0
    jmp .L1929
.L1928:
    mov rax, 1
.L1929:
    test rax, rax
    jz .L1926
    mov rcx, 1
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rax, r12
    and rax, 7
    mov rcx, rax
    mov rax, 0xB8
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_q
    add rsp, 32
    jmp .__ret_1921
    jmp .L1927
.L1926:
.L1927:
    mov rcx, 0
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rax, r12
    and rax, 7
    mov rcx, rax
    mov rax, 0xB8
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1921
    jmp .L1925
.L1924:
.L1925:
    cmp r13, 1
    jne .L1930
    mov rcx, 1
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 3
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call ks_emit_modrm
    add rsp, 32
    jmp .__ret_1921
    jmp .L1931
.L1930:
.L1931:
    cmp r13, 3
    jne .L1932
    mov rcx, 1
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1921
    jmp .L1933
.L1932:
.L1933:
    cmp r13, 5
    jne .L1934
    mov rcx, 1
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1921
    jmp .L1935
.L1934:
.L1935:
    cmp r13, 9
    jne .L1936
    mov rcx, 1
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1921
    jmp .L1937
.L1936:
.L1937:
    cmp r13, 13
    jne .L1938
    mov rax, 1
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_kasm_src_base]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1921
    jmp .L1939
.L1938:
.L1939:
    cmp r13, 11
    jne .L1940
    mov rcx, 1
    mov rdx, r12
    mov r8, 4
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8B
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, 4
    push rax
    mov rax, 0
    sub rax, rbx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ks_emit_mem_base_disp
    add rsp, 32
    jmp .__ret_1921
    jmp .L1941
.L1940:
.L1941:
    cmp r13, 4
    jne .L1942
    mov rcx, 1
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x8D
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_emit_rip
    add rsp, 32
    jmp .__ret_1921
    jmp .L1943
.L1942:
.L1943:
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1921
.__ret_1921:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_mem:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r14, 2
    jne .L1945
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1947
    mov rcx, 0xC6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1944
    jmp .L1948
.L1947:
.L1948:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1949
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1944
    jmp .L1950
.L1949:
.L1950:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 4
    jne .L1951
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1944
    jmp .L1952
.L1951:
.L1952:
    mov rax, [rel __g_kasm_mv_vs]
    shr rax, 31
    mov rbx, rax
    cmp rbx, 0
    je .L1953
    mov rax, rbx
    add rax, 1
    shr rax, 33
    cmp rax, 1
    je .L1955
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1944
    jmp .L1956
.L1955:
.L1956:
    jmp .L1954
.L1953:
.L1954:
    mov rcx, 1
    mov rdx, 0
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1944
    jmp .L1946
.L1945:
.L1946:
    mov rax, r14
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1959
    mov rax, r14
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1959
    mov rax, 0
    jmp .L1960
.L1959:
    mov rax, 1
.L1960:
    test rax, rax
    jz .L1957
    cmp r14, 10
    jne .L1961
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .L1962
.L1961:
.L1962:
    mov rcx, 0
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1944
    jmp .L1958
.L1957:
.L1958:
    cmp r14, 7
    jne .L1963
    mov rax, r12
    mov rcx, 4
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1967
    mov rax, r12
    mov rcx, 8
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1967
    mov rax, 1
    jmp .L1968
.L1967:
    mov rax, 0
.L1968:
    test rax, rax
    jz .L1965
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1966
.L1965:
.L1966:
    mov rcx, 0
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x88
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1944
    jmp .L1964
.L1963:
.L1964:
    cmp r14, 1
    je .L1969
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1944
    jmp .L1970
.L1969:
.L1970:
    mov rcx, 1
    mov rdx, r12
    mov r8, 5
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_rbp
    add rsp, 32
    jmp .__ret_1944
.__ret_1944:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_mov_to_memreg:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rax, [rel __g_kasm_mv_ks]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_kasm_mv_vd]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_kasm_mv_vs]
    push rax
    pop rcx
    sub rsp, 32
    call ks_lo
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r14, 2
    jne .L1972
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 1
    jne .L1974
    mov rcx, 0
    mov rdx, 0
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC6
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    jmp .__ret_1971
    jmp .L1975
.L1974:
.L1975:
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 2
    jne .L1976
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, 0
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_w
    add rsp, 32
    jmp .__ret_1971
    jmp .L1977
.L1976:
.L1977:
    mov rax, 1
    mov rbx, rax
    mov rax, [rel __g_kasm_op_size]
    cmp rax, 4
    jne .L1978
    mov rax, 0
    mov rbx, rax
    jmp .L1979
.L1978:
.L1979:
    mov rcx, rbx
    mov rdx, 0
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0xC7
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ks_emit_d
    add rsp, 32
    jmp .__ret_1971
    jmp .L1973
.L1972:
.L1973:
    cmp r14, 7
    jne .L1980
    cmp r12, 4
    jl .L1982
    mov rax, 1
    mov [rel __g_kasm_rex8_force], rax
    jmp .L1983
.L1982:
.L1983:
    mov rcx, 0
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x88
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1971
    jmp .L1981
.L1980:
.L1981:
    cmp r14, 8
    jne .L1984
    mov rcx, 0
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1971
    jmp .L1985
.L1984:
.L1985:
    cmp r14, 10
    jne .L1986
    mov rcx, 0x66
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, 0
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1971
    jmp .L1987
.L1986:
.L1987:
    cmp r14, 1
    je .L1988
    sub rsp, 32
    call ks_unsupported
    add rsp, 32
    jmp .__ret_1971
    jmp .L1989
.L1988:
.L1989:
    mov rcx, 1
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call ks_emit_rex
    add rsp, 32
    mov rcx, 0x89
    sub rsp, 32
    call ks_emit_b
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call ks_emit_mem_reg
    add rsp, 32
    jmp .__ret_1971
.__ret_1971:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ks_q:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_1990
.__ret_1990:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_qs:
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
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_1991
.__ret_1991:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_b:
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
    jmp .__ret_1992
.__ret_1992:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_bs:
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
    jmp .__ret_1993
.__ret_1993:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_u32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    jmp .__ret_1994
.__ret_1994:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ks_ult:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 1
    mov rbx, rax
    mov rax, rbx
    shl rax, 63
    mov rbx, rax
    mov rax, r13
    xor rax, rbx
    push rax
    mov rax, r12
    xor rax, rbx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1996
    mov rax, 1
    jmp .__ret_1995
    jmp .L1997
.L1996:
.L1997:
    mov rax, 0
    jmp .__ret_1995
.__ret_1995:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ks_urem:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    cmp rbx, 0
    jge .L1999
    mov rax, r12
    jmp .__ret_1998
    jmp .L2000
.L1999:
.L2000:
    mov rax, r12
    mov rcx, rbx
    cqo
    idiv rcx
    mov rax, rdx
    jmp .__ret_1998
.__ret_1998:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ks_memeq:
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
    mov rax, 0
    mov rbx, rax
.L2002:
    cmp rbx, r12
    jge .L2003
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ks_b
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L2005
    mov rax, 0
    jmp .__ret_2001
    jmp .L2006
.L2005:
.L2006:
    add rbx, 1
.L2004:
    jmp .L2002
.L2003:
    mov rax, 1
    jmp .__ret_2001
.__ret_2001:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ksk_code:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_kasm_kasm_code]
    jmp .__ret_2007
.__ret_2007:
    mov rsp, rbp
    pop rbp
    ret
ksk_data:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_kasm_kasm_data]
    jmp .__ret_2008
.__ret_2008:
    mov rsp, rbp
    pop rbp
    ret
ksk_code_size:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_code_len]
    jmp .__ret_2009
.__ret_2009:
    mov rsp, rbp
    pop rbp
    ret
ksk_data_size:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_data_len]
    jmp .__ret_2010
.__ret_2010:
    mov rsp, rbp
    pop rbp
    ret
ksk_bss_size:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_bss_len]
    jmp .__ret_2011
.__ret_2011:
    mov rsp, rbp
    pop rbp
    ret
ksk_error_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_err_count]
    jmp .__ret_2012
.__ret_2012:
    mov rsp, rbp
    pop rbp
    ret
ksk_error_dst:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_err_dst]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2013
.__ret_2013:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_error_src:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_err_src]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2014
.__ret_2014:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_error_line_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_err_lines]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2015
.__ret_2015:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_error_line:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_err_line]
    jmp .__ret_2016
.__ret_2016:
    mov rsp, rbp
    pop rbp
    ret
ksk_had_error:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_kasm_error]
    and rax, 255
    jmp .__ret_2017
.__ret_2017:
    mov rsp, rbp
    pop rbp
    ret
ksk_error_mnem:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_err_mnem]
    push rax
    mov rax, rbx
    shl rax, 6
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_2018
.__ret_2018:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_ext_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_ext_count]
    jmp .__ret_2019
.__ret_2019:
    mov rsp, rbp
    pop rbp
    ret
ksk_ext_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ks_ext_name
    add rsp, 32
    jmp .__ret_2020
.__ret_2020:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_extref_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_extref_count]
    jmp .__ret_2021
.__ret_2021:
    mov rsp, rbp
    pop rbp
    ret
ksk_extref_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_extref_at]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2022
.__ret_2022:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_extref_sym:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_extref_sym]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2023
.__ret_2023:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_label_addr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_lbl_addr]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2024
.__ret_2024:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_fixup_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_kasm_fix_count]
    jmp .__ret_2025
.__ret_2025:
    mov rsp, rbp
    pop rbp
    ret
ksk_fixup_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_fix_at]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2026
.__ret_2026:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_fixup_label:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_fix_label]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2027
.__ret_2027:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_fixup_addend:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_fix_addend]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2028
.__ret_2028:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_fixup_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_fix_kind]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2029
.__ret_2029:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ksk_label_section:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_kasm_lbl_section]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_q
    add rsp, 32
    jmp .__ret_2030
.__ret_2030:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
