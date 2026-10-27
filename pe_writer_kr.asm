; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_pe_writer_PW_FILE_ALIGN: dq 512
section .text
section .data
__g_pe_writer_PW_SECT_ALIGN: dq 4096
section .text
section .data
__g_pe_writer_PW_HDRS: dq 1024
section .text
section .data
__g_pe_writer_PW_THUNK: dq 6
section .text
section .data
__g_pe_writer_PW_TEXT_RVA: dq 4096
section .text
section .data
__g_pe_writer_PW_IDATA_OFF_MAX: dq 4096
section .text
section .data
__g_pe_writer_pw_buf: dq 0
section .text
section .data
__g_pe_writer_pw_code_ptr: dq 0
section .text
section .data
__g_pe_writer_pw_code_len: dq 0
section .text
section .data
__g_pe_writer_pw_data_ptr: dq 0
section .text
section .data
__g_pe_writer_pw_data_len: dq 0
section .text
section .data
__g_pe_writer_pw_bss_len: dq 0
section .text
section .data
__g_pe_writer_pw_ext_count: dq 0
section .text
section .data
__g_pe_writer_pw_xref_count: dq 0
section .text
section .data
__g_pe_writer_pw_thunks_off: dq 0
section .text
section .data
__g_pe_writer_pw_text_vsize: dq 0
section .text
section .data
__g_pe_writer_pw_text_raw: dq 0
section .text
section .data
__g_pe_writer_pw_text_foff: dq 0
section .text
section .data
__g_pe_writer_pw_bss_off_sec: dq 0
section .text
section .data
__g_pe_writer_pw_data_vsize: dq 0
section .text
section .data
__g_pe_writer_pw_data_raw: dq 0
section .text
section .data
__g_pe_writer_pw_data_foff: dq 0
section .text
section .data
__g_pe_writer_pw_idata_foff: dq 0
section .text
section .data
__g_pe_writer_pw_idata_size: dq 0
section .text
section .data
__g_pe_writer_pw_data_rva: dq 0
section .text
section .data
__g_pe_writer_pw_idata_rva: dq 0
section .text
section .data
__g_pe_writer_pw_idt_rva: dq 0
section .text
section .data
__g_pe_writer_pw_ilt_rva: dq 0
section .text
section .data
__g_pe_writer_pw_iat_rva: dq 0
section .text
section .data
__g_pe_writer_pw_names_intra: dq 0
section .text
section .data
__g_pe_writer_pw_entry_rva: dq 0
section .text
section .data
__g_pe_writer_pw_total: dq 0
section .text
section .data
__g_pe_writer_pw_base: dq 0
section .text
section .data
__g_pe_writer_pw_exp_n: dq 0
section .text
section .data
__g_pe_writer_pw_exp_dir: dq 0
section .text
section .data
__g_pe_writer_pw_exp_size: dq 0
section .text
section .data
__g_pe_writer_pw_rel_dir: dq 0
section .text
section .data
__g_pe_writer_pw_rel_size: dq 0
section .text
section .data
__g_pe_writer_pw_rel_page: dq 0
section .text
section .data
__g_pe_writer_pw_rel_block: dq 0
section .text
section .bss
__g_pe_writer_pw_hint: resq 4096
section .text
section .bss
__g_pe_writer_pw_exp_order: resq 4096
section .text
section .bss
__g_pe_writer_pw_name: resq 40
section .text
pw_b:
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
pw_sb:
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
pw_q:
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
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
pw_qs:
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
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
pw_neg1:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rcx, 4294967295
    cmp rax, rcx
    jne .L5
    mov rax, 1
    jmp .__ret_4
    jmp .L6
.L5:
.L6:
    mov rax, 0
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
pw_put8:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, [rel __g_pe_writer_pw_buf]
    add rax, rbx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r12
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, 0
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
pw_put16:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, [rel __g_pe_writer_pw_buf]
    add rax, rbx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r12
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, r12
    sar rax, 8
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, 0
    jmp .__ret_8
.__ret_8:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
pw_put32:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rax, [rel __g_pe_writer_pw_buf]
    add rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L10:
    cmp rbx, 4
    jge .L11
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    sar rax, cl
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add rbx, 1
.L12:
    jmp .L10
.L11:
    mov rax, 0
    jmp .__ret_9
.__ret_9:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
pw_put64:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rax, [rel __g_pe_writer_pw_buf]
    add rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L14:
    cmp rbx, 8
    jge .L15
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    sar rax, cl
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add rbx, 1
.L16:
    jmp .L14
.L15:
    mov rax, 0
    jmp .__ret_13
.__ret_13:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
pw_align:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    add rax, rbx
    sub rax, 1
    push rax
    mov rax, 0
    sub rax, rbx
    mov rcx, rax
    pop rax
    and rax, rcx
    jmp .__ret_17
.__ret_17:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
pw_zero:
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
.L19:
    cmp rbx, r12
    jge .L20
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add rbx, 1
.L21:
    jmp .L19
.L20:
    mov rax, 0
    jmp .__ret_18
.__ret_18:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
pw_cstrlen:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L23:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    cmp rax, 0
    je .L24
    add rbx, 1
.L25:
    jmp .L23
.L24:
    mov rax, rbx
    jmp .__ret_22
.__ret_22:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
pw_set_main:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 0
    push rax
    pop rcx
    mov rdx, 109
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    mov rdx, 97
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    mov rdx, 105
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 3
    push rax
    pop rcx
    mov rdx, 110
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 4
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, 0
    jmp .__ret_26
.__ret_26:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
pw_set_dllmain:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 0
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    mov rdx, 100
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 3
    push rax
    pop rcx
    mov rdx, 108
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 4
    push rax
    pop rcx
    mov rdx, 108
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 5
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 6
    push rax
    pop rcx
    mov rdx, 109
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 7
    push rax
    pop rcx
    mov rdx, 97
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    pop rcx
    mov rdx, 105
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 9
    push rax
    pop rcx
    mov rdx, 110
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 10
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, 0
    jmp .__ret_27
.__ret_27:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
pw_set_dllname:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 0
    push rax
    pop rcx
    mov rdx, 107
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    mov rdx, 101
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    mov rdx, 114
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 3
    push rax
    pop rcx
    mov rdx, 110
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 4
    push rax
    pop rcx
    mov rdx, 101
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 5
    push rax
    pop rcx
    mov rdx, 108
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 6
    push rax
    pop rcx
    mov rdx, 51
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 7
    push rax
    pop rcx
    mov rdx, 50
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    pop rcx
    mov rdx, 46
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 9
    push rax
    pop rcx
    mov rdx, 100
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 10
    push rax
    pop rcx
    mov rdx, 108
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 11
    push rax
    pop rcx
    mov rdx, 108
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, rbx
    add rax, 12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, 0
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
pw_name_cmp:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
    call pw_export_name
    add rsp, 32
    mov [rbp-24], rax
    mov rcx, r12
    sub rsp, 32
    call pw_export_len
    add rsp, 32
    mov [rbp-32], rax
    mov rcx, rbx
    sub rsp, 32
    call pw_export_name
    add rsp, 32
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
    call pw_export_len
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L30:
    mov rax, r13
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L31
    cmp r13, r14
    jl .L33
    mov rax, 1
    jmp .__ret_29
    jmp .L34
.L33:
.L34:
    mov rax, [rbp-24]
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    mov r12, rax
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    mov rbx, rax
    cmp r12, rbx
    jle .L35
    mov rax, 1
    jmp .__ret_29
    jmp .L36
.L35:
.L36:
    cmp r12, rbx
    jge .L37
    mov rax, 0
    jmp .__ret_29
    jmp .L38
.L37:
.L38:
    add r13, 1
.L32:
    jmp .L30
.L31:
    mov rax, 0
    jmp .__ret_29
.__ret_29:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
pw_rel_close:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rbx, rax
    mov rax, [rel __g_pe_writer_pw_rel_block]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L40
    mov rax, rbx
    jmp .__ret_39
    jmp .L41
.L40:
.L41:
    mov rax, rbx
    and rax, 2
    cmp rax, 0
    je .L42
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_put16
    add rsp, 32
    add rbx, 2
    jmp .L43
.L42:
.L43:
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    push rax
    mov rax, [rel __g_pe_writer_pw_rel_block]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 4
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_pe_writer_pw_rel_block]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, rbx
    jmp .__ret_39
.__ret_39:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
pw_dll_tables:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov [rbp-176], r15
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-80], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-120], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    sub rsp, 32
    call pw_export_count
    add rsp, 32
    mov r15, rax
    mov rax, r15
    mov [rel __g_pe_writer_pw_exp_n], rax
    mov rax, 0
    mov r14, rax
.L45:
    cmp r14, r15
    jge .L46
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r14
    sub rsp, 32
    call pw_qs
    add rsp, 32
    add r14, 1
.L47:
    jmp .L45
.L46:
    mov rax, 1
    mov r14, rax
.L48:
    cmp r14, r15
    jge .L49
    mov rax, r14
    mov r12, rax
.L51:
    cmp r12, 0
    jle .L52
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_q
    add rsp, 32
    push rax
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call pw_q
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_name_cmp
    add rsp, 32
    cmp rax, 0
    jne .L54
    jmp .L52
    jmp .L55
.L54:
.L55:
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_q
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call pw_q
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_qs
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call pw_qs
    add rsp, 32
    sub r12, 1
.L53:
    jmp .L51
.L52:
    add r14, 1
.L50:
    jmp .L48
.L49:
    mov rax, [rel __g_pe_writer_pw_idata_size]
    add rax, 7
    push rax
    mov rax, 0
    sub rax, 8
    mov rcx, rax
    pop rax
    and rax, rcx
    mov [rel __g_pe_writer_pw_exp_dir], rax
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_exp_dir]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 65536
    sub rsp, 32
    call pw_zero
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_exp_dir]
    add rax, 40
    mov r13, rax
    mov rax, r13
    mov [rbp-48], rax
    mov rax, r15
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov r13, rax
    mov rax, r13
    mov [rbp-56], rax
    mov rax, r15
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov r13, rax
    mov rax, r13
    mov [rbp-64], rax
    mov rax, r15
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov r13, rax
    mov rax, r13
    add rax, 3
    push rax
    mov rax, 0
    sub rax, 4
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r13, rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    push rax
    mov rax, [rel __g_pe_writer_pw_exp_dir]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    add rax, 16
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, rbx
    add rax, 20
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, rbx
    add rax, 24
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, rbx
    add rax, 28
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, [rbp-48]
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, rbx
    add rax, 32
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, [rbp-56]
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, rbx
    add rax, 36
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, [rbp-64]
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 0
    mov r14, rax
.L56:
    cmp r14, r15
    jge .L57
    lea rax, [rel __g_pe_writer_pw_exp_order]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call pw_q
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, [rbp-56]
    add rax, rcx
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call pw_export_len
    add rsp, 32
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call pw_export_name
    add rsp, 32
    mov [rbp-80], rax
    mov rax, 0
    mov rbx, rax
.L59:
    cmp rbx, r12
    jge .L60
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r13
    add rax, rbx
    push rax
    mov rax, [rbp-80]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add rbx, 1
.L61:
    jmp .L59
.L60:
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_sb
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 0
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call pw_sb
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 1
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call pw_sb
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 2
    push rax
    pop rcx
    mov rdx, 99
    sub rsp, 32
    call pw_sb
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 3
    push rax
    pop rcx
    mov rdx, 101
    sub rsp, 32
    call pw_sb
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 4
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L62:
    cmp rbx, r12
    jge .L63
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 5
    add rax, rbx
    push rax
    mov rax, [rbp-80]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add rbx, 1
.L64:
    jmp .L62
.L63:
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, 5
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call pw_sb
    add rsp, 32
    mov rax, r13
    add rax, r12
    add rax, 1
    mov r13, rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, [rbp-64]
    add rax, rcx
    push rax
    mov rax, r14
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call pw_put16
    add rsp, 32
    lea rax, [rel __g_pe_writer_pw_name]
    push rax
    mov rax, 5
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kasm_find_label
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call pw_neg1
    add rsp, 32
    cmp rax, 0
    jne .L65
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, [rbp-48]
    add rax, rcx
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call pw_label_addr
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    jmp .L66
.L65:
.L66:
    add r14, 1
.L58:
    jmp .L56
.L57:
    mov rax, [rel __g_pe_writer_pw_exp_dir]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 12
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L67:
    mov rax, 1
    cmp rax, 1
    jne .L68
    sub rsp, 32
    call pw_dll_file_addr
    add rsp, 32
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r13
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add r13, 1
    add rbx, 1
    cmp r12, 0
    jne .L70
    jmp .L68
    jmp .L71
.L70:
.L71:
.L69:
    jmp .L67
.L68:
    mov rax, r13
    push rax
    mov rax, [rel __g_pe_writer_pw_exp_dir]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_pe_writer_pw_exp_size], rax
    mov rax, 320
    push rax
    mov rax, [rel __g_pe_writer_pw_exp_dir]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 324
    push rax
    mov rax, [rel __g_pe_writer_pw_exp_size]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, r13
    add rax, 3
    push rax
    mov rax, 0
    sub rax, 4
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r13, rax
    mov rax, r13
    mov [rel __g_pe_writer_pw_rel_dir], rax
    mov rax, r13
    mov rbx, rax
    mov rax, 1
    neg rax
    mov [rel __g_pe_writer_pw_rel_page], rax
    mov rax, 1
    neg rax
    mov [rel __g_pe_writer_pw_rel_block], rax
    sub rsp, 32
    call kasm_get_fixup_count
    add rsp, 32
    mov [rbp-120], rax
    mov rax, 0
    mov r14, rax
.L72:
    mov rax, r14
    mov rcx, [rbp-120]
    cmp rax, rcx
    jge .L73
    mov rcx, r14
    sub rsp, 32
    call kasm_get_fixup_kind
    add rsp, 32
    cmp rax, 6
    jne .L75
    mov rcx, r14
    sub rsp, 32
    call kasm_get_fixup_label
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call pw_neg1
    add rsp, 32
    cmp rax, 0
    jne .L77
    mov rcx, r14
    sub rsp, 32
    call kasm_get_fixup_at
    add rsp, 32
    push rax
    mov rax, [rel __g_pe_writer_pw_data_rva]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r15, rax
    mov rax, 0
    sub rax, 4096
    mov rcx, rax
    mov rax, r15
    and rax, rcx
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_pe_writer_pw_rel_page]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L79
    mov rcx, r13
    sub rsp, 32
    call pw_rel_close
    add rsp, 32
    mov r13, rax
    mov rax, r12
    mov [rel __g_pe_writer_pw_rel_page], rax
    mov rax, r13
    mov [rel __g_pe_writer_pw_rel_block], rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    add rax, r13
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call pw_put32
    add rsp, 32
    add r13, 8
    jmp .L80
.L79:
.L80:
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    add rax, r13
    push rax
    mov rax, r15
    and rax, 4095
    or rax, 40960
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put16
    add rsp, 32
    add r13, 2
    jmp .L78
.L77:
.L78:
    jmp .L76
.L75:
.L76:
    add r14, 1
.L74:
    jmp .L72
.L73:
    mov rcx, r13
    sub rsp, 32
    call pw_rel_close
    add rsp, 32
    mov r13, rax
    mov rax, r13
    sub rax, rbx
    mov r12, rax
    mov rax, r12
    mov [rel __g_pe_writer_pw_rel_size], rax
    mov rax, 360
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 364
    mov rdx, r12
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, r13
    mov [rel __g_pe_writer_pw_idata_size], rax
    mov rax, 0
    jmp .__ret_44
.__ret_44:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov r15, [rbp-176]
    mov rsp, rbp
    pop rbp
    ret
pe_write:
    push rbp
    mov rbp, rsp
    sub rsp, 272
    mov [rbp-240], rbx
    mov [rbp-232], r12
    mov [rbp-224], r13
    mov [rbp-216], r14
    mov [rbp-208], r15
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
    mov r14, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-104], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-136], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    mov [rel __g_pe_writer_pw_buf], rax
    sub rsp, 32
    call kasm_get_code
    add rsp, 32
    mov [rel __g_pe_writer_pw_code_ptr], rax
    sub rsp, 32
    call kasm_get_code_size
    add rsp, 32
    mov [rel __g_pe_writer_pw_code_len], rax
    sub rsp, 32
    call kasm_get_data
    add rsp, 32
    mov [rel __g_pe_writer_pw_data_ptr], rax
    sub rsp, 32
    call kasm_get_data_size
    add rsp, 32
    mov [rel __g_pe_writer_pw_data_len], rax
    sub rsp, 32
    call kasm_get_bss_size
    add rsp, 32
    mov [rel __g_pe_writer_pw_bss_len], rax
    sub rsp, 32
    call kasm_get_ext_count
    add rsp, 32
    mov [rel __g_pe_writer_pw_ext_count], rax
    sub rsp, 32
    call kasm_get_extref_count
    add rsp, 32
    mov [rel __g_pe_writer_pw_xref_count], rax
    sub rsp, 32
    call pw_flag_dll
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call pw_flag_gui
    add rsp, 32
    mov r13, rax
    mov rax, 5368709120
    mov [rel __g_pe_writer_pw_base], rax
    lea rax, [rel __g_pe_writer_pw_name]
    mov r14, rax
    cmp rbx, 0
    je .L82
    mov rax, 6442450944
    mov [rel __g_pe_writer_pw_base], rax
    mov rcx, r14
    sub rsp, 32
    call pw_set_dllmain
    add rsp, 32
    mov rax, 10
    mov r12, rax
    jmp .L83
.L82:
    mov rcx, r14
    sub rsp, 32
    call pw_set_main
    add rsp, 32
    mov rax, 4
    mov r12, rax
.L83:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call kasm_find_label
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call pw_neg1
    add rsp, 32
    cmp rax, 0
    je .L84
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    mov [rel __g_pe_writer_pw_entry_rva], rax
    jmp .L85
.L84:
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    mov rcx, r12
    sub rsp, 32
    call pw_label_addr
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_pe_writer_pw_entry_rva], rax
.L85:
    mov rax, [rel __g_pe_writer_pw_code_len]
    push rax
    pop rcx
    mov rdx, 16
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov [rel __g_pe_writer_pw_thunks_off], rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    push rax
    mov rax, [rel __g_pe_writer_PW_THUNK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_pe_writer_pw_thunks_off]
    add rax, rcx
    mov [rel __g_pe_writer_pw_text_vsize], rax
    mov rax, [rel __g_pe_writer_pw_text_vsize]
    push rax
    mov rax, [rel __g_pe_writer_PW_FILE_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov [rel __g_pe_writer_pw_text_raw], rax
    mov rax, [rel __g_pe_writer_PW_HDRS]
    mov [rel __g_pe_writer_pw_text_foff], rax
    mov rax, [rel __g_pe_writer_pw_data_len]
    push rax
    pop rcx
    mov rdx, 16
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov [rel __g_pe_writer_pw_bss_off_sec], rax
    mov rax, [rel __g_pe_writer_pw_bss_off_sec]
    push rax
    mov rax, [rel __g_pe_writer_pw_bss_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_pe_writer_pw_data_vsize], rax
    mov rax, [rel __g_pe_writer_pw_data_len]
    push rax
    mov rax, [rel __g_pe_writer_PW_FILE_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov [rel __g_pe_writer_pw_data_raw], rax
    mov rax, [rel __g_pe_writer_pw_text_foff]
    push rax
    mov rax, [rel __g_pe_writer_pw_text_raw]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_pe_writer_pw_data_foff], rax
    mov rax, [rel __g_pe_writer_pw_data_foff]
    push rax
    mov rax, [rel __g_pe_writer_pw_data_raw]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_pe_writer_pw_idata_foff], rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    mov rax, [rel __g_pe_writer_pw_text_vsize]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_PW_SECT_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov [rel __g_pe_writer_pw_data_rva], rax
    mov rax, [rel __g_pe_writer_pw_data_rva]
    push rax
    mov rax, [rel __g_pe_writer_pw_data_vsize]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_PW_SECT_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov [rel __g_pe_writer_pw_idata_rva], rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov [rel __g_pe_writer_pw_idt_rva], rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    add rax, 40
    mov [rel __g_pe_writer_pw_ilt_rva], rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    add rax, 1
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_pe_writer_pw_ilt_rva]
    add rax, rcx
    mov [rel __g_pe_writer_pw_iat_rva], rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    add rax, 1
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_pe_writer_pw_iat_rva]
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_pe_writer_pw_names_intra], rax
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_PW_HDRS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_zero
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_PW_HDRS]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    push rax
    mov rax, [rel __g_pe_writer_PW_HDRS]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_zero
    add rsp, 32
    mov rcx, 0
    mov rdx, 23117
    sub rsp, 32
    call pw_put16
    add rsp, 32
    mov rcx, 60
    mov rdx, 184
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 184
    mov rdx, 17744
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 188
    mov rdx, 34404
    sub rsp, 32
    call pw_put16
    add rsp, 32
    mov rcx, 190
    mov rdx, 3
    sub rsp, 32
    call pw_put16
    add rsp, 32
    mov rcx, 204
    mov rdx, 240
    sub rsp, 32
    call pw_put16
    add rsp, 32
    cmp rbx, 0
    jne .L86
    mov rcx, 206
    mov rdx, 35
    sub rsp, 32
    call pw_put16
    add rsp, 32
    jmp .L87
.L86:
    mov rcx, 206
    mov rdx, 8226
    sub rsp, 32
    call pw_put16
    add rsp, 32
.L87:
    mov rcx, 208
    mov rdx, 523
    sub rsp, 32
    call pw_put16
    add rsp, 32
    mov rcx, 210
    mov rdx, 14
    sub rsp, 32
    call pw_put8
    add rsp, 32
    mov rax, 212
    push rax
    mov rax, [rel __g_pe_writer_pw_text_raw]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 224
    push rax
    mov rax, [rel __g_pe_writer_pw_entry_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 228
    push rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 232
    push rax
    mov rax, [rel __g_pe_writer_pw_base]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rax, 240
    push rax
    mov rax, [rel __g_pe_writer_PW_SECT_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 244
    push rax
    mov rax, [rel __g_pe_writer_PW_FILE_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 248
    mov rdx, 6
    sub rsp, 32
    call pw_put16
    add rsp, 32
    mov rcx, 256
    mov rdx, 6
    sub rsp, 32
    call pw_put16
    add rsp, 32
    mov rax, 268
    push rax
    mov rax, [rel __g_pe_writer_PW_HDRS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    cmp r13, 0
    je .L88
    mov rcx, 276
    mov rdx, 2
    sub rsp, 32
    call pw_put16
    add rsp, 32
    jmp .L89
.L88:
    mov rcx, 276
    mov rdx, 3
    sub rsp, 32
    call pw_put16
    add rsp, 32
.L89:
    cmp rbx, 0
    jne .L90
    mov rcx, 278
    mov rdx, 0
    sub rsp, 32
    call pw_put16
    add rsp, 32
    jmp .L91
.L90:
    mov rcx, 278
    mov rdx, 96
    sub rsp, 32
    call pw_put16
    add rsp, 32
.L91:
    mov rcx, 280
    mov rdx, 8388608
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rcx, 288
    mov rdx, 65536
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rcx, 296
    mov rdx, 1048576
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rcx, 304
    mov rdx, 4096
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rcx, 316
    mov rdx, 16
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 328
    push rax
    mov rax, [rel __g_pe_writer_pw_idt_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 332
    mov rdx, 40
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 416
    push rax
    mov rax, [rel __g_pe_writer_pw_iat_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 420
    push rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    add rax, 1
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 448
    mov rdx, 500236121134
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rax, 456
    push rax
    mov rax, [rel __g_pe_writer_pw_text_vsize]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 460
    push rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 464
    push rax
    mov rax, [rel __g_pe_writer_pw_text_raw]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 468
    push rax
    mov rax, [rel __g_pe_writer_pw_text_foff]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 484
    mov rdx, 1610612768
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 488
    mov rdx, 418564367406
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rax, 496
    push rax
    mov rax, [rel __g_pe_writer_pw_data_vsize]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 500
    push rax
    mov rax, [rel __g_pe_writer_pw_data_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 504
    push rax
    mov rax, [rel __g_pe_writer_pw_data_raw]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_data_raw]
    cmp rax, 0
    jne .L92
    mov rcx, 508
    mov rdx, 0
    sub rsp, 32
    call pw_put32
    add rsp, 32
    jmp .L93
.L92:
    mov rax, 508
    push rax
    mov rax, [rel __g_pe_writer_pw_data_foff]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
.L93:
    mov rcx, 524
    mov rdx, 3221225536
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 528
    mov rdx, 107152478071086
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rax, 540
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 548
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rcx, 564
    mov rdx, 1073741888
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 0
    mov r14, rax
.L94:
    mov rax, r14
    push rax
    mov rax, [rel __g_pe_writer_pw_code_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L95
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_text_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r14
    push rax
    mov rax, [rel __g_pe_writer_pw_code_ptr]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add r14, 1
.L96:
    jmp .L94
.L95:
    mov rax, 0
    mov r14, rax
.L97:
    mov rax, r14
    push rax
    mov rax, [rel __g_pe_writer_pw_data_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L98
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_data_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r14
    push rax
    mov rax, [rel __g_pe_writer_pw_data_ptr]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add r14, 1
.L99:
    jmp .L97
.L98:
    mov rax, 0
    mov r15, rax
.L100:
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L101
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_PW_THUNK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_pe_writer_pw_thunks_off]
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_text_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rcx, r13
    mov rdx, 255
    sub rsp, 32
    call pw_put8
    add rsp, 32
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    mov rdx, 37
    sub rsp, 32
    call pw_put8
    add rsp, 32
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_pe_writer_pw_iat_rva]
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    mov rax, [rel __g_pe_writer_pw_thunks_off]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_PW_THUNK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 6
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov r14, rax
    mov rax, r13
    add rax, 2
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call pw_put32
    add rsp, 32
    add r15, 1
.L102:
    jmp .L100
.L101:
    mov rax, 0
    mov r15, rax
.L103:
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_pw_xref_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L104
    mov rcx, r15
    sub rsp, 32
    call kasm_get_extref_at
    add rsp, 32
    mov r13, rax
    mov rcx, r15
    sub rsp, 32
    call kasm_get_extref_sym
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    push rax
    mov rax, [rel __g_pe_writer_pw_thunks_off]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_pe_writer_PW_THUNK]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    add rax, r13
    add rax, 4
    mov rcx, rax
    mov rax, r14
    sub rax, rcx
    mov r14, rax
    mov rax, [rel __g_pe_writer_pw_text_foff]
    add rax, r13
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call pw_put32
    add rsp, 32
    add r15, 1
.L105:
    jmp .L103
.L104:
    sub rsp, 32
    call kasm_get_fixup_count
    add rsp, 32
    mov [rbp-136], rax
    mov rax, 0
    mov r15, rax
.L106:
    mov rax, r15
    mov rcx, [rbp-136]
    cmp rax, rcx
    jge .L107
    mov rcx, r15
    sub rsp, 32
    call kasm_get_fixup_kind
    add rsp, 32
    mov r12, rax
    cmp r12, 6
    jne .L109
    mov rcx, r15
    sub rsp, 32
    call kasm_get_fixup_label
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call pw_neg1
    add rsp, 32
    cmp rax, 0
    jne .L111
    mov rcx, r12
    sub rsp, 32
    call kasm_get_label_section
    add rsp, 32
    mov r13, rax
    mov rcx, r12
    sub rsp, 32
    call pw_label_addr
    add rsp, 32
    mov r12, rax
    cmp r13, 0
    jne .L113
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    mov r14, rax
    jmp .L114
.L113:
    mov rax, [rel __g_pe_writer_pw_data_rva]
    mov r14, rax
    cmp r13, 2
    jne .L115
    mov rax, r14
    push rax
    mov rax, [rel __g_pe_writer_pw_bss_off_sec]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    jmp .L116
.L115:
.L116:
.L114:
    mov rax, r14
    add rax, r12
    push rax
    mov rax, [rel __g_pe_writer_pw_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rcx, r15
    sub rsp, 32
    call kasm_get_fixup_at
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_pe_writer_pw_data_foff]
    add rax, r12
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call pw_put64
    add rsp, 32
    jmp .L112
.L111:
.L112:
    jmp .L110
.L109:
    cmp r12, 3
    jne .L117
    mov rcx, r15
    sub rsp, 32
    call kasm_get_fixup_label
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call pw_neg1
    add rsp, 32
    cmp rax, 0
    jne .L119
    mov rcx, r12
    sub rsp, 32
    call kasm_get_label_section
    add rsp, 32
    mov r13, rax
    cmp r13, 1
    jl .L121
    mov rcx, r12
    sub rsp, 32
    call pw_label_addr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_pe_writer_pw_data_rva]
    mov r14, rax
    cmp r13, 2
    jne .L123
    mov rax, r14
    push rax
    mov rax, [rel __g_pe_writer_pw_bss_off_sec]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    jmp .L124
.L123:
.L124:
    mov rax, r14
    add rax, r12
    push rax
    mov rcx, r15
    sub rsp, 32
    call kasm_get_fixup_addend
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rcx, r15
    sub rsp, 32
    call kasm_get_fixup_at
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_pe_writer_PW_TEXT_RVA]
    add rax, r12
    add rax, 4
    mov rcx, rax
    mov rax, r14
    sub rax, rcx
    mov r14, rax
    mov rax, [rel __g_pe_writer_pw_text_foff]
    add rax, r12
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call pw_put32
    add rsp, 32
    jmp .L122
.L121:
.L122:
    jmp .L120
.L119:
.L120:
    jmp .L118
.L117:
.L118:
.L110:
    add r15, 1
.L108:
    jmp .L106
.L107:
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 2048
    sub rsp, 32
    call pw_zero
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    push rax
    mov rax, [rel __g_pe_writer_pw_ilt_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    add rax, 16
    push rax
    mov rax, [rel __g_pe_writer_pw_iat_rva]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_names_intra]
    mov r13, rax
    mov rax, 0
    mov r15, rax
.L125:
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L126
    lea rax, [rel __g_pe_writer_pw_hint]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    add rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_qs
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call kasm_get_ext_name
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call pw_cstrlen
    add rsp, 32
    mov [rbp-104], rax
    mov rax, 0
    mov r14, rax
.L128:
    mov rax, r14
    mov rcx, [rbp-104]
    cmp rax, rcx
    jg .L129
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r13
    add rax, 2
    add rax, r14
    push rax
    mov rax, r12
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add r14, 1
.L130:
    jmp .L128
.L129:
    mov rax, r13
    add rax, 2
    mov rcx, [rbp-104]
    add rax, rcx
    add rax, 1
    mov r13, rax
    mov rax, r13
    and rax, 1
    cmp rax, 0
    je .L131
    add r13, 1
    jmp .L132
.L131:
.L132:
    add r15, 1
.L127:
    jmp .L125
.L126:
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    add rax, r13
    mov r12, rax
    lea rax, [rel __g_pe_writer_pw_name]
    push rax
    pop rcx
    sub rsp, 32
    call pw_set_dllname
    add rsp, 32
    mov rax, 0
    mov r14, rax
.L133:
    cmp r14, 13
    jge .L134
    mov rax, [rel __g_pe_writer_pw_buf]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r13
    add rax, r14
    push rax
    lea rax, [rel __g_pe_writer_pw_name]
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call pw_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_sb
    add rsp, 32
    add r14, 1
.L135:
    jmp .L133
.L134:
    mov rax, r13
    add rax, 12
    add rax, 1
    mov r13, rax
    mov rax, r13
    mov [rel __g_pe_writer_pw_idata_size], rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    add rax, 12
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 0
    mov r15, rax
.L136:
    mov rax, r15
    push rax
    mov rax, [rel __g_pe_writer_pw_ext_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L137
    mov rax, [rel __g_pe_writer_pw_ilt_rva]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    lea rax, [rel __g_pe_writer_pw_hint]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call pw_q
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put64
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_iat_rva]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    lea rax, [rel __g_pe_writer_pw_hint]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call pw_q
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put64
    add rsp, 32
    add r15, 1
.L138:
    jmp .L136
.L137:
    cmp rbx, 0
    je .L139
    sub rsp, 32
    call pw_dll_tables
    add rsp, 32
    jmp .L140
.L139:
.L140:
    mov rax, 536
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_size]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 544
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_size]
    push rax
    mov rax, [rel __g_pe_writer_PW_FILE_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, 264
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_rva]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_size]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_pe_writer_PW_SECT_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    push rax
    mov rax, [rel __g_pe_writer_PW_SECT_ALIGN]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_put32
    add rsp, 32
    mov rax, [rel __g_pe_writer_pw_idata_foff]
    push rax
    mov rax, [rel __g_pe_writer_pw_idata_size]
    push rax
    mov rax, [rel __g_pe_writer_PW_FILE_ALIGN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call pw_align
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_pe_writer_pw_total], rax
    mov rax, [rel __g_pe_writer_pw_total]
    jmp .__ret_81
.__ret_81:
    mov rbx, [rbp-240]
    mov r12, [rbp-232]
    mov r13, [rbp-224]
    mov r14, [rbp-216]
    mov r15, [rbp-208]
    mov rsp, rbp
    pop rbp
    ret
