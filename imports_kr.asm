; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_imports_IP_MAX: dq 64
section .text
section .data
__g_imports_IP_DEPTH: dq 8
section .text
section .data
__g_imports_IP_KIDS: dq 16
section .text
section .data
__g_imports_IP_NAME: dq 256
section .text
section .data
__g_imports_IP_LMAP: dq 128
section .text
section .bss
__g_imports_ip_names: resq 2048
section .text
section .data
__g_imports_ip_count: dq 0
section .text
section .data
__g_imports_ip_err: dq 0
section .text
section .bss
__g_imports_ip_errname: resq 32
section .text
section .bss
__g_imports_ip_dfs_name: resq 256
section .text
section .bss
__g_imports_ip_dfs_kids: resq 4096
section .text
section .bss
__g_imports_ip_nkids: resq 8
section .text
section .bss
__g_imports_ip_ki: resq 8
section .text
section .data
__g_imports_ip_debug: dq 0
section .text
section .bss
__g_imports_ip_dptr: resq 8
section .text
section .bss
__g_imports_ip_dlen: resq 8
section .text
section .bss
__g_imports_ip_mptr: resq 64
section .text
section .bss
__g_imports_ip_mlen: resq 64
section .text
section .data
__g_imports_lm_count: dq 0
section .text
section .bss
__g_imports_lm_out: resq 128
section .text
section .bss
__g_imports_lm_src: resq 128
section .text
section .bss
__g_imports_lm_file: resq 128
section .text
section .bss
__g_imports_lm_names: resq 4160
section .text
section .data
__g_imports_lm_names_n: dq 0
section .text
section .data
__g_imports_lm_outline: dq 0
section .text
section .data
__g_imports_lm_srcline: dq 0
section .text
section .data
__g_imports_lm_hdrskip: dq 0
section .text
section .data
__g_imports_ip_out: dq 0
section .text
section .data
__g_imports_ip_cap: dq 0
section .text
section .data
__g_imports_ip_outlen: dq 0
section .text
section .data
__g_imports_ip_prog: dq 0
section .text
ip_at:
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
ip_set:
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
ip_q:
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
ip_qs:
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
ip_streq:
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
.L5:
    mov rax, 1
    cmp rax, 1
    jne .L6
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    push rax
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L8
    mov rax, 0
    jmp .__ret_4
    jmp .L9
.L8:
.L9:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    cmp rax, 0
    jne .L10
    mov rax, 1
    jmp .__ret_4
    jmp .L11
.L10:
.L11:
    add rbx, 1
.L7:
    jmp .L5
.L6:
    mov rax, 0
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ip_strcpy:
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
.L13:
    mov rax, r12
    push rax
    mov rax, [rel __g_imports_IP_NAME]
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L14
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_set
    add rsp, 32
    cmp rbx, 0
    jne .L16
    mov rax, 0
    jmp .__ret_12
    jmp .L17
.L16:
.L17:
    add r12, 1
.L15:
    jmp .L13
.L14:
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ip_set
    add rsp, 32
    mov rax, 0
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ip_slot:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    push rax
    mov rax, [rel __g_imports_IP_NAME]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    jmp .__ret_18
.__ret_18:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ip_word:
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
.L20:
    cmp rbx, r12
    jge .L21
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L23
    mov rax, 0
    jmp .__ret_19
    jmp .L24
.L23:
.L24:
    add rbx, 1
.L22:
    jmp .L20
.L21:
    mov rax, 1
    jmp .__ret_19
.__ret_19:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ip_extract:
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
    mov [rbp-24], r8
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-64], rax
.L26:
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L27
.L29:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L32
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L34
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L34
    mov rax, 0
    jmp .L35
.L34:
    mov rax, 1
.L35:
    test rax, rax
    jz .L32
    mov rax, 1
    jmp .L33
.L32:
    mov rax, 0
.L33:
    test rax, rax
    jz .L30
    add r15, 1
    sub r14, 1
.L31:
    jmp .L29
.L30:
    cmp r14, 0
    jne .L36
    jmp .L27
    jmp .L37
.L36:
.L37:
    mov rax, r14
    mov rcx, 16
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L40
    mov rax, r15
    push rax
section .data
.str42: db 107,114,111,110,95,100,101,102,105,110,105,116,105,111,110,115,0
section .text
    lea rax, [rel .str42]
    push rax
    pop rdx
    pop rcx
    mov r8, 16
    sub rsp, 32
    call ip_word
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L40
    mov rax, 1
    jmp .L41
.L40:
    mov rax, 0
.L41:
    test rax, rax
    jz .L38
    jmp .L27
    jmp .L39
.L38:
.L39:
    mov rax, r14
    mov rcx, 14
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L45
    mov rax, r15
    push rax
section .data
.str47: db 97,99,113,117,105,114,101,95,100,111,109,97,105,110,0
section .text
    lea rax, [rel .str47]
    push rax
    pop rdx
    pop rcx
    mov r8, 14
    sub rsp, 32
    call ip_word
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L45
    mov rax, 1
    jmp .L46
.L45:
    mov rax, 0
.L46:
    test rax, rax
    jz .L43
    add r15, 14
    sub r14, 14
.L48:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L53
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L53
    mov rax, 1
    jmp .L54
.L53:
    mov rax, 0
.L54:
    test rax, rax
    jz .L51
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L51
    mov rax, 1
    jmp .L52
.L51:
    mov rax, 0
.L52:
    test rax, rax
    jz .L49
    add r15, 1
    sub r14, 1
.L50:
    jmp .L48
.L49:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L57
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L57
    mov rax, 1
    jmp .L58
.L57:
    mov rax, 0
.L58:
    test rax, rax
    jz .L55
    add r15, 1
    sub r14, 1
    mov rax, r13
    push rax
    mov rax, [rel __g_imports_IP_KIDS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L59
    mov rax, 3
    mov [rel __g_imports_ip_err], rax
    jmp .L27
    jmp .L60
.L59:
.L60:
    lea rax, [rel __g_imports_ip_dfs_kids]
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_imports_IP_KIDS]
    mov rcx, rax
    pop rax
    imul rax, rcx
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_slot
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov r12, rax
.L61:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L68
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L68
    mov rax, 1
    jmp .L69
.L68:
    mov rax, 0
.L69:
    test rax, rax
    jz .L66
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L66
    mov rax, 1
    jmp .L67
.L66:
    mov rax, 0
.L67:
    test rax, rax
    jz .L64
    mov rax, r12
    mov rcx, 255
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L64
    mov rax, 1
    jmp .L65
.L64:
    mov rax, 0
.L65:
    test rax, rax
    jz .L62
    mov rax, rbx
    add rax, r12
    push rax
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_set
    add rsp, 32
    add r12, 1
    add r15, 1
    sub r14, 1
.L63:
    jmp .L61
.L62:
    mov rax, rbx
    add rax, r12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ip_set
    add rsp, 32
    add r13, 1
    jmp .L56
.L55:
.L56:
    jmp .L44
.L43:
.L44:
.L70:
    cmp r14, 0
    jle .L71
    mov rcx, r15
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    add r15, 1
    sub r14, 1
    cmp rbx, 10
    jne .L73
    jmp .L71
    jmp .L74
.L73:
.L74:
.L72:
    jmp .L70
.L71:
.L28:
    jmp .L26
.L27:
    lea rax, [rel __g_imports_ip_ki]
    push rax
    pop rcx
    mov rdx, [rbp-24]
    mov r8, 0
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_ip_nkids]
    push rax
    pop rcx
    mov rdx, [rbp-24]
    mov r8, r13
    sub rsp, 32
    call ip_qs
    add rsp, 32
    mov rax, 0
    jmp .__ret_25
.__ret_25:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ip_frame_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    lea rax, [rel __g_imports_ip_dfs_name]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_slot
    add rsp, 32
    jmp .__ret_75
.__ret_75:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ip_on_stack:
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
.L77:
    cmp rbx, r12
    jg .L78
    mov rcx, rbx
    sub rsp, 32
    call ip_frame_name
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_streq
    add rsp, 32
    cmp rax, 1
    jne .L80
    mov rax, 1
    jmp .__ret_76
    jmp .L81
.L80:
.L81:
    add rbx, 1
.L79:
    jmp .L77
.L78:
    mov rax, 0
    jmp .__ret_76
.__ret_76:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ip_listed:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L83:
    mov rax, rbx
    push rax
    mov rax, [rel __g_imports_ip_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L84
    lea rax, [rel __g_imports_ip_names]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_slot
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call ip_streq
    add rsp, 32
    cmp rax, 1
    jne .L86
    mov rax, 1
    jmp .__ret_82
    jmp .L87
.L86:
.L87:
    add rbx, 1
.L85:
    jmp .L83
.L84:
    mov rax, 0
    jmp .__ret_82
.__ret_82:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ip_resolve:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov r14, r8
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rel __g_imports_ip_count], rax
    mov rax, 0
    mov [rel __g_imports_ip_err], rax
    mov rcx, 0
    sub rsp, 32
    call ip_frame_name
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rcx, [rbp-16]
    mov rdx, r14
    mov r8, 0
    sub rsp, 32
    call ip_extract
    add rsp, 32
    mov rax, [rel __g_imports_ip_err]
    cmp rax, 0
    je .L89
    lea rax, [rel __g_imports_ip_errname]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_88
    jmp .L90
.L89:
.L90:
    mov rax, [rel __g_imports_ip_debug]
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L93
    lea rax, [rel __g_imports_ip_nkids]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ip_q
    add rsp, 32
    push rax
    mov rax, [rel __g_imports_IP_KIDS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L93
    mov rax, 1
    jmp .L94
.L93:
    mov rax, 0
.L94:
    test rax, rax
    jz .L91
    lea rax, [rel __g_imports_ip_dfs_kids]
    push rax
    lea rax, [rel __g_imports_ip_nkids]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ip_q
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_slot
    add rsp, 32
    push rax
section .data
.str95: db 115,116,100,95,100,101,98,117,103,46,107,114,0
section .text
    lea rax, [rel .str95]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    lea rax, [rel __g_imports_ip_nkids]
    push rax
    mov rax, 0
    push rax
    lea rax, [rel __g_imports_ip_nkids]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ip_q
    add rsp, 32
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_qs
    add rsp, 32
    jmp .L92
.L91:
.L92:
    mov rax, 0
    mov r13, rax
    lea rax, [rel __g_imports_ip_ki]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
    call ip_qs
    add rsp, 32
.L96:
    mov rax, 1
    cmp rax, 1
    jne .L97
    lea rax, [rel __g_imports_ip_ki]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    push rax
    lea rax, [rel __g_imports_ip_nkids]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L99
    lea rax, [rel __g_imports_ip_ki]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_imports_ip_ki]
    push rax
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_ip_dfs_kids]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_imports_IP_KIDS]
    mov rcx, rax
    pop rax
    imul rax, rcx
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_slot
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ip_listed
    add rsp, 32
    cmp rax, 1
    jne .L101
    jmp .L98
    jmp .L102
.L101:
.L102:
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
    call ip_on_stack
    add rsp, 32
    cmp rax, 1
    jne .L103
    jmp .L98
    jmp .L104
.L103:
.L104:
    mov rax, r13
    add rax, 1
    push rax
    mov rax, [rel __g_imports_IP_DEPTH]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L105
    mov rax, 2
    mov [rel __g_imports_ip_err], rax
    lea rax, [rel __g_imports_ip_errname]
    push rax
    mov rcx, r13
    sub rsp, 32
    call ip_frame_name
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_88
    jmp .L106
.L105:
.L106:
    add r13, 1
    mov rcx, r13
    sub rsp, 32
    call ip_frame_name
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 0
    mov [rbp-56], rax
    mov rax, rbx
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call imp_read
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L107
    mov rax, 6
    mov [rel __g_imports_ip_err], rax
    lea rax, [rel __g_imports_ip_errname]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_88
    jmp .L108
.L107:
.L108:
    cmp r12, 0
    jne .L109
    mov rax, 1
    mov [rel __g_imports_ip_err], rax
    lea rax, [rel __g_imports_ip_errname]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_88
    jmp .L110
.L109:
.L110:
    lea rax, [rel __g_imports_ip_dptr]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_ip_dlen]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, [rbp-56]
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_ip_ki]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, 0
    sub rsp, 32
    call ip_qs
    add rsp, 32
    mov rcx, r12
    mov rdx, [rbp-56]
    mov r8, r13
    sub rsp, 32
    call ip_extract
    add rsp, 32
    mov rax, [rel __g_imports_ip_err]
    cmp rax, 0
    je .L111
    lea rax, [rel __g_imports_ip_errname]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_88
    jmp .L112
.L111:
.L112:
    jmp .L100
.L99:
    cmp r13, 0
    jne .L113
    mov rax, 0
    jmp .__ret_88
    jmp .L114
.L113:
.L114:
    mov rax, [rel __g_imports_ip_count]
    push rax
    mov rax, [rel __g_imports_IP_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L115
    mov rax, 3
    mov [rel __g_imports_ip_err], rax
    lea rax, [rel __g_imports_ip_errname]
    push rax
    mov rcx, r13
    sub rsp, 32
    call ip_frame_name
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 1
    neg rax
    jmp .__ret_88
    jmp .L116
.L115:
.L116:
    lea rax, [rel __g_imports_ip_names]
    push rax
    mov rax, [rel __g_imports_ip_count]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_slot
    add rsp, 32
    push rax
    mov rcx, r13
    sub rsp, 32
    call ip_frame_name
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    lea rax, [rel __g_imports_ip_mptr]
    push rax
    mov rax, [rel __g_imports_ip_count]
    push rax
    lea rax, [rel __g_imports_ip_dptr]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_ip_mlen]
    push rax
    mov rax, [rel __g_imports_ip_count]
    push rax
    lea rax, [rel __g_imports_ip_dlen]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_qs
    add rsp, 32
    mov rax, [rel __g_imports_ip_count]
    add rax, 1
    mov [rel __g_imports_ip_count], rax
    sub r13, 1
.L100:
.L98:
    jmp .L96
.L97:
    mov rax, 0
    jmp .__ret_88
.__ret_88:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
lm_file_of:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L118:
    mov rax, r13
    push rax
    mov rax, [rel __g_imports_lm_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L119
    lea rax, [rel __g_imports_lm_file]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call ip_streq
    add rsp, 32
    cmp rax, 1
    jne .L121
    lea rax, [rel __g_imports_lm_file]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call ip_q
    add rsp, 32
    jmp .__ret_117
    jmp .L122
.L121:
.L122:
    add r13, 1
.L120:
    jmp .L118
.L119:
    lea rax, [rel __g_imports_lm_names]
    push rax
    mov rax, [rel __g_imports_lm_names_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
.L123:
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L126
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L126
    mov rax, 1
    jmp .L127
.L126:
    mov rax, 0
.L127:
    test rax, rax
    jz .L124
    mov rax, r12
    add rax, rbx
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_set
    add rsp, 32
    add rbx, 1
.L125:
    jmp .L123
.L124:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call ip_set
    add rsp, 32
    mov rax, rbx
    add rax, 1
    mov rcx, rax
    mov rax, [rel __g_imports_lm_names_n]
    add rax, rcx
    mov [rel __g_imports_lm_names_n], rax
    mov rax, r12
    jmp .__ret_117
.__ret_117:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
lm_add:
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
    mov rax, [rel __g_imports_lm_count]
    push rax
    mov rax, [rel __g_imports_IP_LMAP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L129
    mov rax, 4
    mov [rel __g_imports_ip_err], rax
    lea rax, [rel __g_imports_ip_errname]
    push rax
    mov rax, [rel __g_imports_ip_prog]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 0
    jmp .__ret_128
    jmp .L130
.L129:
.L130:
    mov rcx, r13
    sub rsp, 32
    call lm_file_of
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_imports_lm_out]
    push rax
    mov rax, [rel __g_imports_lm_count]
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_lm_src]
    push rax
    mov rax, [rel __g_imports_lm_count]
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
    call ip_qs
    add rsp, 32
    lea rax, [rel __g_imports_lm_file]
    push rax
    mov rax, [rel __g_imports_lm_count]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call ip_qs
    add rsp, 32
    mov rax, [rel __g_imports_lm_count]
    add rax, 1
    mov [rel __g_imports_lm_count], rax
    mov rax, 0
    jmp .__ret_128
.__ret_128:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ip_put:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_imports_ip_outlen]
    push rax
    mov rax, [rel __g_imports_ip_cap]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L132
    mov rax, 5
    mov [rel __g_imports_ip_err], rax
    lea rax, [rel __g_imports_ip_errname]
    push rax
    mov rax, [rel __g_imports_ip_prog]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_strcpy
    add rsp, 32
    mov rax, 0
    jmp .__ret_131
    jmp .L133
.L132:
.L133:
    mov rax, [rel __g_imports_ip_out]
    push rax
    mov rax, [rel __g_imports_ip_outlen]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ip_set
    add rsp, 32
    mov rax, [rel __g_imports_ip_outlen]
    add rax, 1
    mov [rel __g_imports_ip_outlen], rax
    mov rax, 1
    jmp .__ret_131
.__ret_131:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ip_emit_modules:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
.L135:
    mov rax, r15
    push rax
    mov rax, [rel __g_imports_ip_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L136
    lea rax, [rel __g_imports_ip_mptr]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call ip_q
    add rsp, 32
    mov [rbp-16], rax
    lea rax, [rel __g_imports_ip_mlen]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call ip_q
    add rsp, 32
    mov r14, rax
    mov rax, [rbp-16]
    mov r13, rax
    mov rax, r14
    mov r12, rax
    mov rax, 0
    mov [rel __g_imports_lm_hdrskip], rax
    mov rax, 0
    mov rbx, rax
.L138:
    cmp r12, 16
    jl .L139
    mov rax, r13
    push rax
section .data
.str143: db 107,114,111,110,95,100,101,102,105,110,105,116,105,111,110,115,0
section .text
    lea rax, [rel .str143]
    push rax
    pop rdx
    pop rcx
    mov r8, 16
    sub rsp, 32
    call ip_word
    add rsp, 32
    cmp rax, 1
    jne .L141
    mov rax, 1
    mov rbx, rax
    add r13, 16
    sub r12, 16
    jmp .L139
    jmp .L142
.L141:
.L142:
    mov rcx, r13
    sub rsp, 32
    call ip_at
    add rsp, 32
    cmp rax, 10
    jne .L144
    mov rax, [rel __g_imports_lm_hdrskip]
    add rax, 1
    mov [rel __g_imports_lm_hdrskip], rax
    jmp .L145
.L144:
.L145:
    add r13, 1
    sub r12, 1
.L140:
    jmp .L138
.L139:
    cmp rbx, 0
    jne .L146
    mov rax, [rbp-16]
    mov r13, rax
    mov rax, r14
    mov r12, rax
    jmp .L147
.L146:
.L147:
    mov rax, [rel __g_imports_lm_outline]
    push rax
    lea rax, [rel __g_imports_ip_names]
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call ip_slot
    add rsp, 32
    push rax
    mov rax, [rel __g_imports_lm_hdrskip]
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call lm_add
    add rsp, 32
.L148:
    cmp r12, 0
    jle .L149
    mov rcx, r13
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ip_put
    add rsp, 32
    cmp rax, 0
    jne .L151
    mov rax, 1
    neg rax
    jmp .__ret_134
    jmp .L152
.L151:
.L152:
    cmp rbx, 10
    jne .L153
    mov rax, [rel __g_imports_lm_outline]
    add rax, 1
    mov [rel __g_imports_lm_outline], rax
    jmp .L154
.L153:
.L154:
    add r13, 1
    sub r12, 1
.L150:
    jmp .L148
.L149:
    mov rcx, 10
    sub rsp, 32
    call ip_put
    add rsp, 32
    cmp rax, 0
    jne .L155
    mov rax, 1
    neg rax
    jmp .__ret_134
    jmp .L156
.L155:
.L156:
    mov rax, [rel __g_imports_lm_outline]
    add rax, 1
    mov [rel __g_imports_lm_outline], rax
    add r15, 1
.L137:
    jmp .L135
.L136:
    mov rax, 0
    jmp .__ret_134
.__ret_134:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ip_bol:
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
    cmp r12, 0
    jne .L158
    mov rax, 1
    jmp .__ret_157
    jmp .L159
.L158:
.L159:
    mov rax, r13
    add rax, r12
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L162
    mov rax, rbx
    mov rcx, 13
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
    jz .L160
    mov rax, 1
    jmp .__ret_157
    jmp .L161
.L160:
.L161:
    mov rax, 0
    jmp .__ret_157
.__ret_157:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ip_expand:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov r14, rdx
    mov r13, r8
    mov [rbp-32], r9
    mov [rbp-40], r10
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 1
    mov [rbp-72], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-32]
    mov [rel __g_imports_ip_out], rax
    mov rax, [rbp-40]
    mov [rel __g_imports_ip_cap], rax
    mov rax, 0
    mov [rel __g_imports_ip_outlen], rax
    mov rax, r15
    mov [rel __g_imports_ip_prog], rax
    mov rax, 0
    mov [rel __g_imports_ip_err], rax
    mov rax, 0
    mov [rel __g_imports_lm_count], rax
    mov rax, 0
    mov [rel __g_imports_lm_names_n], rax
    mov rax, 1
    mov [rel __g_imports_lm_outline], rax
    mov rax, 1
    mov [rel __g_imports_lm_srcline], rax
    mov rax, 0
    mov [rel __g_imports_lm_hdrskip], rax
    mov rcx, 1
    mov rdx, r15
    mov r8, 1
    sub rsp, 32
    call lm_add
    add rsp, 32
    mov rcx, r15
    mov rdx, r14
    mov r8, r13
    sub rsp, 32
    call ip_resolve
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L165
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L166
.L165:
.L166:
.L167:
    cmp r12, r13
    jge .L168
    mov rax, r13
    sub rax, r12
    mov rcx, 14
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L174
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
    call ip_bol
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L174
    mov rax, 1
    jmp .L175
.L174:
    mov rax, 0
.L175:
    test rax, rax
    jz .L172
    mov rax, r14
    add rax, r12
    push rax
section .data
.str176: db 97,99,113,117,105,114,101,95,100,111,109,97,105,110,0
section .text
    lea rax, [rel .str176]
    push rax
    pop rdx
    pop rcx
    mov r8, 14
    sub rsp, 32
    call ip_word
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L172
    mov rax, 1
    jmp .L173
.L172:
    mov rax, 0
.L173:
    test rax, rax
    jz .L170
    add r12, 14
.L177:
    mov rax, r12
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L180
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L182
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L182
    mov rax, 0
    jmp .L183
.L182:
    mov rax, 1
.L183:
    test rax, rax
    jz .L180
    mov rax, 1
    jmp .L181
.L180:
    mov rax, 0
.L181:
    test rax, rax
    jz .L178
    add r12, 1
.L179:
    jmp .L177
.L178:
    cmp r12, r13
    jl .L184
    mov rax, [rel __g_imports_ip_outlen]
    jmp .__ret_164
    jmp .L185
.L184:
.L185:
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    cmp rax, 34
    je .L186
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ip_put
    add rsp, 32
    cmp rax, 0
    jne .L188
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L189
.L188:
.L189:
    add r12, 1
    cmp rbx, 10
    jne .L190
    mov rax, [rel __g_imports_lm_outline]
    add rax, 1
    mov [rel __g_imports_lm_outline], rax
    mov rax, [rel __g_imports_lm_srcline]
    add rax, 1
    mov [rel __g_imports_lm_srcline], rax
    jmp .L191
.L190:
.L191:
    jmp .L169
    jmp .L187
.L186:
.L187:
    add r12, 1
    mov rax, 0
    mov rbx, rax
.L192:
    mov rax, 1
    cmp rax, 1
    jne .L193
    cmp r12, r13
    jl .L195
    mov rax, [rel __g_imports_ip_outlen]
    jmp .__ret_164
    jmp .L196
.L195:
.L196:
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L199
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L199
    mov rax, 0
    jmp .L200
.L199:
    mov rax, 1
.L200:
    test rax, rax
    jz .L197
    jmp .L193
    jmp .L198
.L197:
.L198:
    add r12, 1
    add rbx, 1
.L194:
    jmp .L192
.L193:
    add r12, 1
.L201:
    cmp r12, r13
    jge .L202
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    add r12, 1
    cmp rbx, 10
    jne .L204
    mov rax, [rel __g_imports_lm_srcline]
    add rax, 1
    mov [rel __g_imports_lm_srcline], rax
    jmp .L202
    jmp .L205
.L204:
.L205:
.L203:
    jmp .L201
.L202:
    mov rax, [rbp-72]
    cmp rax, 1
    jne .L206
    mov rax, 0
    mov [rbp-72], rax
    sub rsp, 32
    call ip_emit_modules
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L208
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L209
.L208:
.L209:
    jmp .L207
.L206:
.L207:
    mov rax, [rel __g_imports_lm_outline]
    push rax
    mov rax, r15
    push rax
    mov rax, [rel __g_imports_lm_srcline]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call lm_add
    add rsp, 32
    jmp .L169
    jmp .L171
.L170:
.L171:
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ip_at
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call ip_put
    add rsp, 32
    cmp rax, 0
    jne .L210
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L211
.L210:
.L211:
    add r12, 1
    cmp rbx, 10
    jne .L212
    mov rax, [rel __g_imports_lm_outline]
    add rax, 1
    mov [rel __g_imports_lm_outline], rax
    mov rax, [rel __g_imports_lm_srcline]
    add rax, 1
    mov [rel __g_imports_lm_srcline], rax
    jmp .L213
.L212:
.L213:
.L169:
    jmp .L167
.L168:
    mov rax, [rel __g_imports_ip_outlen]
    jmp .__ret_164
.__ret_164:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
ip_debug_set:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_imports_ip_debug], rax
    mov rax, 0
    jmp .__ret_214
.__ret_214:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ip_err_get:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_imports_ip_err]
    jmp .__ret_215
.__ret_215:
    mov rsp, rbp
    pop rbp
    ret
ip_errname_addr:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_imports_ip_errname]
    jmp .__ret_216
.__ret_216:
    mov rsp, rbp
    pop rbp
    ret
ip_lm_count_get:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_imports_lm_count]
    jmp .__ret_217
.__ret_217:
    mov rsp, rbp
    pop rbp
    ret
ip_lm_addr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L219
    lea rax, [rel __g_imports_lm_out]
    jmp .__ret_218
    jmp .L220
.L219:
.L220:
    cmp rbx, 1
    jne .L221
    lea rax, [rel __g_imports_lm_file]
    jmp .__ret_218
    jmp .L222
.L221:
.L222:
    lea rax, [rel __g_imports_lm_src]
    jmp .__ret_218
.__ret_218:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ip_count_get:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_imports_ip_count]
    jmp .__ret_223
.__ret_223:
    mov rsp, rbp
    pop rbp
    ret
ip_names_addr:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_imports_ip_names]
    jmp .__ret_224
.__ret_224:
    mov rsp, rbp
    pop rbp
    ret
