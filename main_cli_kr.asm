; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_main_cli_A_INPUT: dq 0
section .text
section .data
__g_main_cli_A_OUTPUT: dq 1
section .text
section .data
__g_main_cli_A_FLAG_S: dq 2
section .text
section .data
__g_main_cli_A_FLAG_CHECK: dq 3
section .text
section .data
__g_main_cli_A_FLAG_DEBUG: dq 4
section .text
section .data
__g_main_cli_A_FLAG_WINDOW: dq 5
section .text
section .data
__g_main_cli_A_FLAG_LIB: dq 6
section .text
section .data
__g_main_cli_A_FLAG_MODULE: dq 7
section .text
section .data
__g_main_cli_A_ANDROID: dq 8
section .text
section .data
__g_main_cli_A_IOS: dq 9
section .text
section .data
__g_main_cli_A_BIN_NAME: dq 10
section .text
section .data
__g_main_cli_A_ASM_NAME: dq 11
section .text
section .data
__g_main_cli_A_BIN_EXT_PTR: dq 12
section .text
section .data
__g_main_cli_A_BIN_EXT: dq 13
section .text
section .data
__g_main_cli_A_ASM_EXT: dq 14
section .text
section .data
__g_main_cli_A_MOD_EXT: dq 15
section .text
section .data
__g_main_cli_A_MOD_TAG: dq 16
section .text
section .data
__g_main_cli_T_PE: dq 0
section .text
section .data
__g_main_cli_T_ELF: dq 1
section .text
section .data
__g_main_cli_T_KRN: dq 2
section .text
section .data
__g_main_cli_T_BARE: dq 3
section .text
section .data
__g_main_cli_T_ARM64: dq 4
section .text
section .data
__g_main_cli_T_WEB: dq 5
section .text
section .data
__g_main_cli_T_MACOS: dq 6
section .text
mc_g8:
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
mc_p8:
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
mc_g64:
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
mc_set:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mc_blank:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L7
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L7
    mov rax, 0
    jmp .L8
.L7:
    mov rax, 1
.L8:
    test rax, rax
    jz .L5
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
mc_end:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L14
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L14
    mov rax, 0
    jmp .L15
.L14:
    mov rax, 1
.L15:
    test rax, rax
    jnz .L12
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L12
    mov rax, 0
    jmp .L13
.L12:
    mov rax, 1
.L13:
    test rax, rax
    jz .L10
    mov rax, 1
    jmp .__ret_9
    jmp .L11
.L10:
.L11:
    mov rax, 0
    jmp .__ret_9
.__ret_9:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mc_starts:
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
.L17:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L18
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L20
    mov rax, 0
    jmp .__ret_16
    jmp .L21
.L20:
.L21:
    add rbx, 1
.L19:
    jmp .L17
.L18:
    mov rax, 1
    jmp .__ret_16
.__ret_16:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mc_word:
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
.L23:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L24
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L26
    mov rax, 0
    jmp .__ret_22
    jmp .L27
.L26:
.L27:
    add rbx, 1
.L25:
    jmp .L23
.L24:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_end
    add rsp, 32
    jmp .__ret_22
.__ret_22:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mc_scan_flag:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    sub rsp, 32
    call os_cmdline
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L29
    mov rax, 0
    jmp .__ret_28
    jmp .L30
.L29:
.L30:
section .data
.str31: db 45,45,100,117,109,112,0
section .text
    lea rax, [rel .str31]
    mov rbx, rax
    cmp r13, 1
    jne .L32
section .data
.str34: db 45,45,97,115,115,101,0
section .text
    lea rax, [rel .str34]
    mov rbx, rax
    jmp .L33
.L32:
    cmp r13, 2
    jne .L35
section .data
.str37: db 45,45,112,101,0
section .text
    lea rax, [rel .str37]
    mov rbx, rax
    jmp .L36
.L35:
    cmp r13, 3
    jne .L38
section .data
.str40: db 45,45,106,112,120,0
section .text
    lea rax, [rel .str40]
    mov rbx, rax
    jmp .L39
.L38:
.L39:
.L36:
.L33:
.L41:
    mov rcx, r12
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L42
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call mc_starts
    add rsp, 32
    cmp rax, 0
    je .L44
    cmp r13, 2
    je .L46
    mov rax, 1
    jmp .__ret_28
    jmp .L47
.L46:
.L47:
    mov rax, r12
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L50
    mov rax, r12
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L50
    mov rax, 0
    jmp .L51
.L50:
    mov rax, 1
.L51:
    test rax, rax
    jz .L48
    mov rax, 1
    jmp .__ret_28
    jmp .L49
.L48:
.L49:
    jmp .L45
.L44:
.L45:
    add r12, 1
.L43:
    jmp .L41
.L42:
    mov rax, 0
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mc_scan_target:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rbx, rax
    cmp rbx, 0
    jne .L53
    mov rax, [rel __g_main_cli_T_PE]
    jmp .__ret_52
    jmp .L54
.L53:
.L54:
.L55:
    mov rcx, rbx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L56
    mov rcx, rbx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L60
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L60
    mov rax, 1
    jmp .L61
.L60:
    mov rax, 0
.L61:
    test rax, rax
    jz .L58
    mov rax, rbx
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 98
    jne .L62
    mov rax, rbx
    add rax, 2
    push rax
section .data
.str66: db 98,97,114,101,0
section .text
    lea rax, [rel .str66]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_starts
    add rsp, 32
    cmp rax, 0
    je .L64
    mov rax, [rel __g_main_cli_T_BARE]
    jmp .__ret_52
    jmp .L65
.L64:
.L65:
    jmp .L63
.L62:
    mov rax, rbx
    add rax, 2
    push rax
section .data
.str69: db 116,97,114,103,101,116,61,0
section .text
    lea rax, [rel .str69]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_starts
    add rsp, 32
    cmp rax, 0
    je .L67
    mov rax, rbx
    add rax, 9
    push rax
    pop rcx
    sub rsp, 32
    call mc_target_name
    add rsp, 32
    jmp .__ret_52
    jmp .L68
.L67:
.L68:
.L63:
    jmp .L59
.L58:
.L59:
    add rbx, 1
.L57:
    jmp .L55
.L56:
    mov rax, [rel __g_main_cli_T_PE]
    jmp .__ret_52
.__ret_52:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mc_target_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str73: db 119,105,110,100,111,119,115,0
section .text
    lea rax, [rel .str73]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L71
    mov rax, [rel __g_main_cli_T_PE]
    jmp .__ret_70
    jmp .L72
.L71:
.L72:
    mov rax, rbx
    push rax
section .data
.str76: db 108,105,110,117,120,0
section .text
    lea rax, [rel .str76]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L74
    mov rax, [rel __g_main_cli_T_ELF]
    jmp .__ret_70
    jmp .L75
.L74:
.L75:
    mov rax, rbx
    push rax
section .data
.str79: db 108,105,110,117,120,45,97,114,109,54,52,0
section .text
    lea rax, [rel .str79]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L77
    mov rax, [rel __g_main_cli_T_ARM64]
    jmp .__ret_70
    jmp .L78
.L77:
.L78:
    mov rax, rbx
    push rax
section .data
.str82: db 107,114,110,0
section .text
    lea rax, [rel .str82]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L80
    mov rax, [rel __g_main_cli_T_KRN]
    jmp .__ret_70
    jmp .L81
.L80:
.L81:
    mov rax, rbx
    push rax
section .data
.str85: db 119,101,98,0
section .text
    lea rax, [rel .str85]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L83
    mov rax, [rel __g_main_cli_T_WEB]
    jmp .__ret_70
    jmp .L84
.L83:
.L84:
    mov rax, rbx
    push rax
section .data
.str88: db 109,97,99,111,115,0
section .text
    lea rax, [rel .str88]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L86
    mov rax, [rel __g_main_cli_T_MACOS]
    jmp .__ret_70
    jmp .L87
.L86:
.L87:
    mov rax, rbx
    push rax
section .data
.str91: db 97,110,100,114,111,105,100,0
section .text
    lea rax, [rel .str91]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L89
    mov rax, [rel __g_main_cli_A_ANDROID]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_T_ARM64]
    jmp .__ret_70
    jmp .L90
.L89:
.L90:
    mov rax, rbx
    push rax
section .data
.str94: db 105,111,115,0
section .text
    lea rax, [rel .str94]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L92
    mov rax, [rel __g_main_cli_A_IOS]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_T_MACOS]
    jmp .__ret_70
    jmp .L93
.L92:
.L93:
    mov rax, rbx
    push rax
section .data
.str97: db 98,97,114,101,0
section .text
    lea rax, [rel .str97]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L95
    mov rax, [rel __g_main_cli_T_BARE]
    jmp .__ret_70
    jmp .L96
.L95:
.L96:
    mov rax, 255
    jmp .__ret_70
.__ret_70:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mc_parse_command_line:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rbx, rcx
    mov rax, rbx
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 34
    jne .L99
    add r13, 1
.L101:
    mov rax, 1
    test rax, rax
    jz .L102
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L104
    mov rax, 0
    jmp .__ret_98
    jmp .L105
.L104:
.L105:
    add r13, 1
    cmp rbx, 34
    jne .L106
    jmp .L102
    jmp .L107
.L106:
.L107:
.L103:
    jmp .L101
.L102:
    jmp .L100
.L99:
.L108:
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_blank
    add rsp, 32
    cmp rax, 0
    jne .L109
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    jne .L111
    mov rax, 0
    jmp .__ret_98
    jmp .L112
.L111:
.L112:
    add r13, 1
.L110:
    jmp .L108
.L109:
.L100:
.L113:
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_blank
    add rsp, 32
    cmp rax, 0
    je .L114
    add r13, 1
.L115:
    jmp .L113
.L114:
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    jne .L116
    mov rax, 0
    jmp .__ret_98
    jmp .L117
.L116:
.L117:
    mov rax, [rel __g_main_cli_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 34
    jne .L118
    add r13, 1
.L120:
    mov rax, rbx
    mov rcx, 511
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L125
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L125
    mov rax, 1
    jmp .L126
.L125:
    mov rax, 0
.L126:
    test rax, rax
    jz .L123
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L123
    mov rax, 1
    jmp .L124
.L123:
    mov rax, 0
.L124:
    test rax, rax
    jz .L121
    mov rax, r12
    add rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    add rbx, 1
    add r13, 1
.L122:
    jmp .L120
.L121:
    mov rax, rbx
    mov rcx, 511
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L129
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L129
    mov rax, 1
    jmp .L130
.L129:
    mov rax, 0
.L130:
    test rax, rax
    jz .L127
    add r13, 1
    jmp .L128
.L127:
.L128:
    jmp .L119
.L118:
.L131:
    mov rax, rbx
    mov rcx, 511
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L134
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_end
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L134
    mov rax, 1
    jmp .L135
.L134:
    mov rax, 0
.L135:
    test rax, rax
    jz .L132
    mov rax, r12
    add rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    add rbx, 1
    add r13, 1
.L133:
    jmp .L131
.L132:
.L119:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_p8
    add rsp, 32
    cmp rbx, 0
    jne .L136
    mov rax, 0
    jmp .__ret_98
    jmp .L137
.L136:
.L137:
    mov rax, [rel __g_main_cli_A_OUTPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_p8
    add rsp, 32
    mov rax, [rel __g_main_cli_A_FLAG_S]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_A_FLAG_CHECK]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_A_FLAG_DEBUG]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_A_FLAG_WINDOW]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_A_FLAG_LIB]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, [rel __g_main_cli_A_FLAG_MODULE]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_set
    add rsp, 32
.L138:
    mov rax, 1
    test rax, rax
    jz .L139
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call mc_blank
    add rsp, 32
    cmp rax, 0
    je .L141
    add r13, 1
    jmp .L142
.L141:
    cmp rbx, 0
    jne .L143
    mov rax, 1
    jmp .__ret_98
    jmp .L144
.L143:
    cmp rbx, 45
    jne .L145
    mov rax, r13
    push rax
section .data
.str149: db 45,83,0
section .text
    lea rax, [rel .str149]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L147
    mov rax, [rel __g_main_cli_A_FLAG_S]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    add r13, 2
    jmp .L140
    jmp .L148
.L147:
.L148:
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 45
    jne .L150
    mov rcx, r13
    sub rsp, 32
    call mc_long_option
    add rsp, 32
    mov r13, rax
    jmp .L151
.L150:
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 111
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L154
    mov rax, r13
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_blank
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L154
    mov rax, 1
    jmp .L155
.L154:
    mov rax, 0
.L155:
    test rax, rax
    jz .L152
    mov rax, r13
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call mc_output
    add rsp, 32
    mov rax, 1
    jmp .__ret_98
    jmp .L153
.L152:
.L153:
.L151:
    jmp .L146
.L145:
.L146:
    mov rcx, r13
    sub rsp, 32
    call mc_skip_token
    add rsp, 32
    mov r13, rax
.L144:
.L142:
.L140:
    jmp .L138
.L139:
    mov rax, 1
    jmp .__ret_98
.__ret_98:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
mc_long_option:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, r12
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 119
    jne .L157
    mov rax, r12
    add rax, 2
    push rax
section .data
.str161: db 119,105,110,100,111,119,0
section .text
    lea rax, [rel .str161]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_starts
    add rsp, 32
    cmp rax, 0
    je .L159
    mov rax, [rel __g_main_cli_A_FLAG_WINDOW]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, r12
    add rax, 8
    jmp .__ret_156
    jmp .L160
.L159:
.L160:
    jmp .L158
.L157:
    cmp rbx, 108
    jne .L162
    mov rax, r12
    add rax, 2
    push rax
section .data
.str166: db 108,105,98,0
section .text
    lea rax, [rel .str166]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L164
    mov rax, [rel __g_main_cli_A_FLAG_LIB]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, r12
    add rax, 5
    jmp .__ret_156
    jmp .L165
.L164:
.L165:
    jmp .L163
.L162:
    cmp rbx, 100
    jne .L167
    mov rax, r12
    add rax, 2
    push rax
section .data
.str171: db 100,101,98,117,103,0
section .text
    lea rax, [rel .str171]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_starts
    add rsp, 32
    cmp rax, 0
    je .L169
    mov rax, [rel __g_main_cli_A_FLAG_DEBUG]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, r12
    add rax, 7
    jmp .__ret_156
    jmp .L170
.L169:
.L170:
    jmp .L168
.L167:
    cmp rbx, 109
    jne .L172
    mov rax, r12
    add rax, 2
    push rax
section .data
.str176: db 109,111,100,117,108,101,0
section .text
    lea rax, [rel .str176]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_word
    add rsp, 32
    cmp rax, 0
    je .L174
    mov rax, [rel __g_main_cli_A_FLAG_MODULE]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, r12
    add rax, 8
    jmp .__ret_156
    jmp .L175
.L174:
.L175:
    jmp .L173
.L172:
    cmp rbx, 99
    jne .L177
    mov rax, r12
    add rax, 2
    push rax
section .data
.str181: db 99,104,101,99,107,0
section .text
    lea rax, [rel .str181]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_starts
    add rsp, 32
    cmp rax, 0
    je .L179
    mov rax, [rel __g_main_cli_A_FLAG_CHECK]
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call mc_set
    add rsp, 32
    mov rax, r12
    add rax, 7
    jmp .__ret_156
    jmp .L180
.L179:
.L180:
    jmp .L178
.L177:
.L178:
.L173:
.L168:
.L163:
.L158:
    mov rax, r12
    jmp .__ret_156
.__ret_156:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mc_skip_token:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, rbx
    mov r12, rax
.L183:
    mov rax, 1
    test rax, rax
    jz .L184
    mov rcx, r12
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L188
    mov rcx, rbx
    sub rsp, 32
    call mc_blank
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
    mov rax, r12
    jmp .__ret_182
    jmp .L187
.L186:
.L187:
    cmp rbx, 34
    jne .L190
    add r12, 1
.L192:
    mov rax, 1
    test rax, rax
    jz .L193
    mov rcx, r12
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L195
    mov rax, r12
    jmp .__ret_182
    jmp .L196
.L195:
.L196:
    add r12, 1
    cmp rbx, 34
    jne .L197
    jmp .L193
    jmp .L198
.L197:
.L198:
.L194:
    jmp .L192
.L193:
    jmp .L191
.L190:
    add r12, 1
.L191:
.L185:
    jmp .L183
.L184:
    mov rax, r12
    jmp .__ret_182
.__ret_182:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mc_output:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rax, rbx
    mov r13, rax
.L200:
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_blank
    add rsp, 32
    cmp rax, 0
    je .L201
    add r13, 1
.L202:
    jmp .L200
.L201:
    mov rax, [rel __g_main_cli_A_OUTPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 34
    jne .L203
    add r13, 1
.L205:
    mov rax, rbx
    mov rcx, 511
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L210
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L210
    mov rax, 1
    jmp .L211
.L210:
    mov rax, 0
.L211:
    test rax, rax
    jz .L208
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L208
    mov rax, 1
    jmp .L209
.L208:
    mov rax, 0
.L209:
    test rax, rax
    jz .L206
    mov rax, r12
    add rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    add rbx, 1
    add r13, 1
.L207:
    jmp .L205
.L206:
    jmp .L204
.L203:
.L212:
    mov rax, rbx
    mov rcx, 511
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L215
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_end
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L215
    mov rax, 1
    jmp .L216
.L215:
    mov rax, 0
.L216:
    test rax, rax
    jz .L213
    mov rax, r12
    add rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    add rbx, 1
    add r13, 1
.L214:
    jmp .L212
.L213:
.L204:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_199
.__ret_199:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mc_name:
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
    mov rax, [rel __g_main_cli_A_OUTPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov r13, rax
    mov rcx, r12
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L218
.L220:
    mov rax, 1
    test rax, rax
    jz .L221
    mov rax, r12
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    cmp rbx, 0
    jne .L223
    mov rax, 0
    jmp .__ret_217
    jmp .L224
.L223:
.L224:
    add r13, 1
    cmp r13, 511
    jl .L225
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_217
    jmp .L226
.L225:
.L226:
.L222:
    jmp .L220
.L221:
    jmp .L219
.L218:
.L219:
    mov rax, [rel __g_main_cli_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
.L227:
    mov rax, rbx
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L228
    mov rax, r15
    add rax, r13
    push rax
    mov rax, rbx
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    add r13, 1
.L229:
    jmp .L227
.L228:
    mov rax, r13
    mov r12, rax
.L230:
    cmp r12, 0
    jle .L231
    sub r12, 1
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 46
    jne .L233
    mov rax, r12
    mov r13, rax
    jmp .L231
    jmp .L234
.L233:
.L234:
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L237
    mov rax, rbx
    mov rcx, 92
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
    jz .L235
    jmp .L231
    jmp .L236
.L235:
.L236:
.L232:
    jmp .L230
.L231:
    mov rax, 0
    mov r12, rax
.L239:
    mov rax, 1
    test rax, rax
    jz .L240
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mc_p8
    add rsp, 32
    cmp rbx, 0
    jne .L242
    mov rax, 0
    jmp .__ret_217
    jmp .L243
.L242:
.L243:
    add r13, 1
    add r12, 1
.L241:
    jmp .L239
.L240:
    mov rax, 0
    jmp .__ret_217
.__ret_217:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
mc_build_bin_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_main_cli_A_BIN_EXT_PTR]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_g64
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L245
    mov rax, [rel __g_main_cli_A_BIN_EXT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    jmp .L246
.L245:
.L246:
    mov rax, [rel __g_main_cli_A_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mc_name
    add rsp, 32
    jmp .__ret_244
.__ret_244:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mc_build_asm_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_main_cli_A_ASM_EXT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_main_cli_A_FLAG_MODULE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L248
    mov rax, [rel __g_main_cli_A_MOD_EXT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    jmp .L249
.L248:
.L249:
    mov rax, [rel __g_main_cli_A_ASM_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mc_name
    add rsp, 32
    jmp .__ret_247
.__ret_247:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mc_module_tag:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rax, [rel __g_main_cli_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov r15, rax
    mov rax, rbx
    mov r12, rax
.L251:
    mov rcx, r12
    sub rsp, 32
    call mc_g8
    add rsp, 32
    cmp rax, 0
    je .L252
    mov rcx, r12
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov rbx, rax
    add r12, 1
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L256
    mov rax, rbx
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L256
    mov rax, 0
    jmp .L257
.L256:
    mov rax, 1
.L257:
    test rax, rax
    jz .L254
    mov rax, r12
    mov r15, rax
    jmp .L255
.L254:
.L255:
.L253:
    jmp .L251
.L252:
    mov rax, [rel __g_main_cli_A_MOD_TAG]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L258:
    cmp r13, 63
    jge .L259
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mc_g8
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L263
    mov rax, r12
    mov rcx, 46
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L263
    mov rax, 0
    jmp .L264
.L263:
    mov rax, 1
.L264:
    test rax, rax
    jz .L261
    jmp .L259
    jmp .L262
.L261:
.L262:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, 95
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L271
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L273
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L273
    mov rax, 1
    jmp .L274
.L273:
    mov rax, 0
.L274:
    test rax, rax
    jnz .L271
    mov rax, 0
    jmp .L272
.L271:
    mov rax, 1
.L272:
    test rax, rax
    jnz .L269
    mov rax, r12
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L275
    mov rax, r12
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L275
    mov rax, 1
    jmp .L276
.L275:
    mov rax, 0
.L276:
    test rax, rax
    jnz .L269
    mov rax, 0
    jmp .L270
.L269:
    mov rax, 1
.L270:
    test rax, rax
    jnz .L267
    mov rax, r12
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L277
    mov rax, r12
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L277
    mov rax, 1
    jmp .L278
.L277:
    mov rax, 0
.L278:
    test rax, rax
    jnz .L267
    mov rax, 0
    jmp .L268
.L267:
    mov rax, 1
.L268:
    test rax, rax
    jz .L265
    mov rax, 1
    mov rbx, rax
    jmp .L266
.L265:
.L266:
    cmp rbx, 0
    jne .L279
    mov rax, 95
    mov r12, rax
    jmp .L280
.L279:
.L280:
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mc_p8
    add rsp, 32
    add r13, 1
.L260:
    jmp .L258
.L259:
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call mc_p8
    add rsp, 32
    mov rax, r14
    add rax, r13
    add rax, 1
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mc_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_250
.__ret_250:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
