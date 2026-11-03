; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_main_io_MI_SRC_SIZE: dq 16777216
section .text
section .data
__g_main_io_MI_POOL: dq 67108864
section .text
section .bss
__g_main_io_mi_pool: resq 8388608
section .text
section .data
__g_main_io_mi_pool_used: dq 0
section .text
section .bss
__g_main_io_mi_pathbuf: resq 64
section .text
section .data
__g_main_io_mi_line_out: dq 0
section .text
section .bss
__g_main_io_mi_digits: resq 4
section .text
mi_g8:
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
mi_p8:
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
mi_at:
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
mi_streq:
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
.L4:
    mov rax, 1
    test rax, rax
    jz .L5
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L7
    mov rax, 0
    jmp .__ret_3
    jmp .L8
.L7:
.L8:
    cmp rbx, 0
    jne .L9
    mov rax, 1
    jmp .__ret_3
    jmp .L10
.L9:
.L10:
    add r12, 1
.L6:
    jmp .L4
.L5:
    mov rax, 0
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mi_reset_pool:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_main_io_mi_pool_used], rax
    mov rax, 0
    jmp .__ret_11
.__ret_11:
    mov rsp, rbp
    pop rbp
    ret
mi_fullpath:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov rcx, r15
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L17
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L17
    mov rax, 0
    jmp .L18
.L17:
    mov rax, 1
.L18:
    test rax, rax
    jnz .L15
    mov rax, r15
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rcx, 58
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L15
    mov rax, 0
    jmp .L16
.L15:
    mov rax, 1
.L16:
    test rax, rax
    jz .L13
    mov rax, r15
    jmp .__ret_12
    jmp .L14
.L13:
.L14:
    sub rsp, 32
    call mn_arg_input
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov rbx, rax
.L19:
    mov rax, r12
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    cmp rax, 0
    je .L20
    mov rax, r12
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov r13, rax
    add r14, 1
    mov rax, r13
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L24
    mov rax, r13
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L24
    mov rax, 0
    jmp .L25
.L24:
    mov rax, 1
.L25:
    test rax, rax
    jz .L22
    mov rax, r14
    mov rbx, rax
    jmp .L23
.L22:
.L23:
.L21:
    jmp .L19
.L20:
    cmp rbx, 0
    jne .L26
    mov rax, r15
    jmp .__ret_12
    jmp .L27
.L26:
.L27:
    lea rax, [rel __g_main_io_mi_pathbuf]
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L28:
    cmp r13, rbx
    jge .L29
    mov rax, r14
    add rax, r13
    push rax
    mov rax, r12
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mi_p8
    add rsp, 32
    add r13, 1
.L30:
    jmp .L28
.L29:
    mov rax, 0
    mov r12, rax
.L31:
    mov rax, 1
    test rax, rax
    jz .L32
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mi_p8
    add rsp, 32
    cmp rbx, 0
    jne .L34
    mov rax, r14
    jmp .__ret_12
    jmp .L35
.L34:
.L35:
    add r12, 1
    add r13, 1
    cmp r13, 510
    jl .L36
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mi_p8
    add rsp, 32
    mov rax, r14
    jmp .__ret_12
    jmp .L37
.L36:
.L37:
.L33:
    jmp .L31
.L32:
    mov rax, r14
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
imp_read:
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
    mov rax, [rel __g_main_io_mi_pool_used]
    mov r14, rax
    mov rax, [rel __g_main_io_MI_POOL]
    sub rax, r14
    mov r13, rax
    cmp r13, 0
    jne .L39
    mov rax, 1
    neg rax
    jmp .__ret_38
    jmp .L40
.L39:
.L40:
    mov rax, r13
    push rax
    mov rax, [rel __g_main_io_MI_SRC_SIZE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L41
    mov rax, [rel __g_main_io_MI_SRC_SIZE]
    mov r13, rax
    jmp .L42
.L41:
.L42:
    lea rax, [rel __g_main_io_mi_pool]
    add rax, r14
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
    call mi_fullpath
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call read_file
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L43
    mov rcx, r15
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
    call read_file
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L45
    mov rax, 0
    jmp .__ret_38
    jmp .L46
.L45:
.L46:
    jmp .L44
.L43:
.L44:
    cmp rbx, r13
    jl .L47
    mov rax, 1
    neg rax
    jmp .__ret_38
    jmp .L48
.L47:
.L48:
    mov rax, [rbp-16]
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    push rax
    mov rax, rbx
    add rax, 15
    push rax
    mov rax, 16
    neg rax
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_main_io_mi_pool_used], rax
    mov rax, r12
    jmp .__ret_38
.__ret_38:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
mi_imp_have:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    sub rsp, 32
    call ip_count_get
    add rsp, 32
    mov rcx, 4294967295
    and rax, rcx
    mov r13, rax
    sub rsp, 32
    call ip_names_addr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L50:
    cmp rbx, r13
    jge .L51
    mov rax, rbx
    mov rcx, 256
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call mi_streq
    add rsp, 32
    cmp rax, 0
    je .L53
    mov rax, 1
    jmp .__ret_49
    jmp .L54
.L53:
.L54:
    add rbx, 1
.L52:
    jmp .L50
.L51:
    mov rax, 0
    jmp .__ret_49
.__ret_49:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mi_lmap_lookup:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    sub rsp, 32
    call mn_lmap_count
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L56
    mov rax, r15
    mov [rel __g_main_io_mi_line_out], rax
    sub rsp, 32
    call mn_arg_input
    add rsp, 32
    jmp .__ret_55
    jmp .L57
.L56:
.L57:
    mov rcx, 0
    sub rsp, 32
    call mn_lmap
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L58:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L61
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call mi_at
    add rsp, 32
    mov rcx, r15
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L61
    mov rax, 1
    jmp .L62
.L61:
    mov rax, 0
.L62:
    test rax, rax
    jz .L59
    mov rax, rbx
    mov r12, rax
    add rbx, 1
.L60:
    jmp .L58
.L59:
    mov rax, r15
    push rax
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call mi_at
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rcx, 2
    sub rsp, 32
    call mn_lmap
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mi_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_main_io_mi_line_out], rax
    mov rcx, 1
    sub rsp, 32
    call mn_lmap
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mi_at
    add rsp, 32
    jmp .__ret_55
.__ret_55:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
mi_lmap_line:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_main_io_mi_line_out]
    jmp .__ret_63
.__ret_63:
    mov rsp, rbp
    pop rbp
    ret
mi_print_error_line:
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
    mov rbx, r8
    cmp r15, 0
    jne .L65
    mov rax, 0
    jmp .__ret_64
    jmp .L66
.L65:
.L66:
    mov rax, rbx
    mov r14, rax
    cmp r14, 0
    jne .L67
    mov rax, 1
    mov r14, rax
    jmp .L68
.L67:
.L68:
    sub rsp, 32
    call mn_exp_buffer
    add rsp, 32
    mov r13, rax
    mov rax, 1
    mov r12, rax
.L69:
    cmp r12, r15
    jge .L70
    mov rcx, r13
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L72
    mov rax, 0
    jmp .__ret_64
    jmp .L73
.L72:
.L73:
    add r13, 1
    cmp rbx, 10
    jne .L74
    add r12, 1
    jmp .L75
.L74:
.L75:
.L71:
    jmp .L69
.L70:
    mov rax, 0
    mov r12, rax
.L76:
    mov rax, 1
    test rax, rax
    jz .L77
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mi_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L83
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L83
    mov rax, 0
    jmp .L84
.L83:
    mov rax, 1
.L84:
    test rax, rax
    jnz .L81
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L81
    mov rax, 0
    jmp .L82
.L81:
    mov rax, 1
.L82:
    test rax, rax
    jz .L79
    jmp .L77
    jmp .L80
.L79:
.L80:
    add r12, 1
    cmp r12, 400
    jl .L85
    jmp .L77
    jmp .L86
.L85:
.L86:
.L78:
    jmp .L76
.L77:
    cmp r12, 0
    jle .L87
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call print_bytes
    add rsp, 32
    jmp .L88
.L87:
.L88:
section .data
.str89: db 13,10,0
section .text
    lea rax, [rel .str89]
    push rax
    pop rcx
    sub rsp, 32
    call print_string
    add rsp, 32
    mov rax, [rbp-16]
    sub rax, 1
    mov rbx, rax
.L90:
    cmp rbx, 0
    jle .L91
section .data
.str93: db 32,0
section .text
    lea rax, [rel .str93]
    push rax
    pop rcx
    sub rsp, 32
    call print_string
    add rsp, 32
    sub rbx, 1
.L92:
    jmp .L90
.L91:
    cmp r14, 200
    jle .L94
    mov rax, 200
    mov r14, rax
    jmp .L95
.L94:
.L95:
.L96:
    cmp r14, 0
    jle .L97
section .data
.str99: db 94,0
section .text
    lea rax, [rel .str99]
    push rax
    pop rcx
    sub rsp, 32
    call print_string
    add rsp, 32
    sub r14, 1
.L98:
    jmp .L96
.L97:
section .data
.str100: db 13,10,0
section .text
    lea rax, [rel .str100]
    push rax
    pop rcx
    sub rsp, 32
    call print_string
    add rsp, 32
    mov rax, 0
    jmp .__ret_64
.__ret_64:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
mi_print_u64:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    lea rax, [rel __g_main_io_mi_digits]
    mov r14, rax
    mov rax, 31
    mov r13, rax
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mi_p8
    add rsp, 32
    mov rax, rbx
    mov rbx, rax
    cmp rbx, 0
    jne .L102
    sub r13, 1
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, 48
    sub rsp, 32
    call mi_p8
    add rsp, 32
    jmp .L103
.L102:
.L103:
.L104:
    cmp rbx, 0
    je .L105
    mov rax, rbx
    shr rax, 1
    mov rcx, 5
    cqo
    idiv rcx
    mov r12, rax
    mov rax, r12
    mov rcx, 10
    imul rax, rcx
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov rbx, rax
    sub r13, 1
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 48
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mi_p8
    add rsp, 32
    mov rax, r12
    mov rbx, rax
.L106:
    jmp .L104
.L105:
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call print_string
    add rsp, 32
    jmp .__ret_101
.__ret_101:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
