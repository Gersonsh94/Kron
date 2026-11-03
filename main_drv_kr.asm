; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_main_drv_A_INPUT: dq 0
section .text
section .data
__g_main_drv_A_FLAG_S: dq 2
section .text
section .data
__g_main_drv_A_FLAG_CHECK: dq 3
section .text
section .data
__g_main_drv_A_FLAG_DEBUG: dq 4
section .text
section .data
__g_main_drv_A_FLAG_LIB: dq 6
section .text
section .data
__g_main_drv_A_FLAG_MODULE: dq 7
section .text
section .data
__g_main_drv_A_ANDROID: dq 8
section .text
section .data
__g_main_drv_A_IOS: dq 9
section .text
section .data
__g_main_drv_A_MOD_TAG: dq 16
section .text
section .data
__g_main_drv_A_OUT_TARGET: dq 17
section .text
section .data
__g_main_drv_A_SRC_BUFFER: dq 18
section .text
section .data
__g_main_drv_A_SRC_SIZE: dq 19
section .text
section .data
__g_main_drv_A_EXP_BUFFER: dq 20
section .text
section .data
__g_main_drv_A_TOKEN_BUFFER: dq 21
section .text
section .data
__g_main_drv_A_TOKEN_COUNT: dq 22
section .text
section .data
__g_main_drv_A_AST_BUFFER: dq 23
section .text
section .data
__g_main_drv_A_SYM_BUFFER: dq 24
section .text
section .data
__g_main_drv_A_CODE_BUFFER: dq 25
section .text
section .data
__g_main_drv_A_CG_DEBUG: dq 26
section .text
section .data
__g_main_drv_A_CG_AS_MODULE: dq 27
section .text
section .data
__g_main_drv_A_DBG_WHICH: dq 28
section .text
section .data
__g_main_drv_A_OUT_DYNAMIC: dq 29
section .text
section .data
__g_main_drv_A_IMP_ERR: dq 30
section .text
section .data
__g_main_drv_A_IMP_ERRNAME: dq 31
section .text
section .data
__g_main_drv_A_LMAP_COUNT: dq 32
section .text
section .data
__g_main_drv_A_USED_SLICE: dq 33
section .text
section .data
__g_main_drv_A_USED_TEXT: dq 34
section .text
section .data
__g_main_drv_A_USED_LIST: dq 35
section .text
section .data
__g_main_drv_A_USED_MAP: dq 36
section .text
section .data
__g_main_drv_T_PE: dq 0
section .text
section .data
__g_main_drv_T_ELF: dq 1
section .text
section .data
__g_main_drv_T_ARM64: dq 4
section .text
section .data
__g_main_drv_T_WEB: dq 5
section .text
section .data
__g_main_drv_T_MACOS: dq 6
section .text
section .data
__g_main_drv_SRC_BUFFER_SIZE: dq 16777216
section .text
section .data
__g_main_drv_TOKEN_BUFFER_SIZE: dq 67108864
section .text
section .data
__g_main_drv_TOKEN_SIZE: dq 24
section .text
section .data
__g_main_drv_AST_BUFFER_SIZE: dq 268435456
section .text
section .data
__g_main_drv_SYM_BUFFER_SIZE: dq 4194304
section .text
section .data
__g_main_drv_CODE_BUFFER_SIZE: dq 16777216
section .text
section .data
__g_main_drv_md_hint: dq 0
section .text
section .bss
__g_main_drv_md_dump_name: resq 66
section .text
md_g8:
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
md_p8:
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
md_g32:
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
md_g64:
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
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
md_p64:
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
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
md_flag:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g8
    add rsp, 32
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
md_say:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call print_string
    add rsp, 32
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
md_start:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    sub rsp, 32
    call os_cmdline
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call mc_parse_command_line
    add rsp, 32
    cmp rax, 0
    jne .L8
section .data
.str10: db 69,82,82,79,82,58,32,117,115,97,103,101,58,32,107,114,111,110,99,46,101,120,101,32,102,105,108,101,46,107,114,32,91,45,111,32,111,117,116,112,117,116,93,32,91,45,83,93,32,91,45,45,99,104,101,99,107,93,32,91,45,45,100,101
    db 98,117,103,93,13,10,0
section .text
    lea rax, [rel .str10]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_7
    jmp .L9
.L8:
.L9:
    mov rcx, rbx
    sub rsp, 32
    call mc_scan_target
    add rsp, 32
    mov r13, rax
    cmp r13, 255
    jne .L11
section .data
.str13: db 69,82,82,79,82,58,32,117,110,107,110,111,119,110,32,116,97,114,103,101,116,13,10,32,32,104,105,110,116,58,32,117,115,101,32,45,45,116,97,114,103,101,116,61,119,105,110,100,111,119,115,44,32,45,45,116,97,114,103,101,116,61,108,105
    db 110,117,120,44,32,45,45,116,97,114,103,101,116,61,108,105,110,117,120,45,97,114,109,54,52,44,32,45,45,116,97,114,103,101,116,61,119,101,98,44,32,45,45,116,97,114,103,101,116,61,107,114,110,32,111,114,32,45,45,116,97,114,103,101
    db 116,61,98,97,114,101,13,10,0
section .text
    lea rax, [rel .str13]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_7
    jmp .L12
.L11:
.L12:
    mov rax, [rel __g_main_drv_A_OUT_TARGET]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call md_p8
    add rsp, 32
    mov rax, r13
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_WEB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L18
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_MACOS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L18
    mov rax, 0
    jmp .L19
.L18:
    mov rax, 1
.L19:
    test rax, rax
    jnz .L16
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_ARM64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L16
    mov rax, 0
    jmp .L17
.L16:
    mov rax, 1
.L17:
    test rax, rax
    jz .L14
    mov rax, [rel __g_main_drv_T_ELF]
    mov rbx, rax
    jmp .L15
.L14:
.L15:
    mov rcx, rbx
    sub rsp, 32
    call cgk_set_target
    add rsp, 32
    mov rax, [rel __g_main_drv_A_FLAG_LIB]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call cgk_set_lib
    add rsp, 32
    cmp r12, 0
    jne .L20
    mov rax, [rel __g_main_drv_A_ANDROID]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L24
    mov rax, [rel __g_main_drv_A_IOS]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
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
section .data
.str26: db 69,82,82,79,82,58,32,65,110,100,114,111,105,100,32,97,110,100,32,105,79,83,32,114,117,110,32,75,114,111,110,32,105,110,115,105,100,101,32,97,110,32,97,112,112,58,32,98,117,105,108,100,32,97,32,108,105,98,114,97,114,121,32,119
    db 105,116,104,32,45,45,108,105,98,32,40,115,101,101,32,116,101,109,112,108,97,116,101,115,47,41,13,10,0
section .text
    lea rax, [rel .str26]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_7
    jmp .L23
.L22:
.L23:
    jmp .L21
.L20:
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_PE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L33
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_ELF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L33
    mov rax, 1
    jmp .L34
.L33:
    mov rax, 0
.L34:
    test rax, rax
    jz .L31
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_ARM64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L31
    mov rax, 1
    jmp .L32
.L31:
    mov rax, 0
.L32:
    test rax, rax
    jz .L29
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_MACOS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L29
    mov rax, 1
    jmp .L30
.L29:
    mov rax, 0
.L30:
    test rax, rax
    jz .L27
section .data
.str35: db 69,82,82,79,82,58,32,45,45,108,105,98,32,109,97,107,101,115,32,97,32,108,105,98,114,97,114,121,32,102,111,114,32,119,105,110,100,111,119,115,44,32,108,105,110,117,120,44,32,108,105,110,117,120,45,97,114,109,54,52,32,111,114,32
    db 109,97,99,111,115,13,10,0
section .text
    lea rax, [rel .str35]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_7
    jmp .L28
.L27:
.L28:
.L21:
    mov rax, [rel __g_main_drv_A_FLAG_DEBUG]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_main_drv_A_CG_DEBUG]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call md_p8
    add rsp, 32
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L40
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_PE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
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
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_ELF]
    mov rcx, rax
    pop rax
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
    jz .L36
section .data
.str42: db 69,82,82,79,82,58,32,45,45,100,101,98,117,103,32,98,117,105,108,100,115,32,102,111,114,32,119,105,110,100,111,119,115,32,97,110,100,32,108,105,110,117,120,32,40,120,56,54,45,54,52,41,59,32,98,117,105,108,100,32,116,104,101,114
    db 101,32,116,111,32,100,101,98,117,103,44,32,116,104,101,110,32,102,111,114,32,116,104,101,32,111,116,104,101,114,32,115,121,115,116,101,109,115,13,10,0
section .text
    lea rax, [rel .str42]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_7
    jmp .L37
.L36:
.L37:
    mov rax, [rel __g_main_drv_A_FLAG_MODULE]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    cmp rax, 0
    je .L43
    mov rax, r13
    push rax
    mov rax, [rel __g_main_drv_T_PE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L49
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L49
    mov rax, 0
    jmp .L50
.L49:
    mov rax, 1
.L50:
    test rax, rax
    jnz .L47
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L47
    mov rax, 0
    jmp .L48
.L47:
    mov rax, 1
.L48:
    test rax, rax
    jz .L45
section .data
.str51: db 69,82,82,79,82,58,32,45,45,109,111,100,117,108,101,32,119,114,105,116,101,115,32,120,56,54,45,54,52,32,116,101,120,116,32,102,111,114,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,111,119,110,32,98,117,105,108,100,58
    db 32,105,116,32,103,111,101,115,32,119,105,116,104,32,45,45,116,97,114,103,101,116,61,119,105,110,100,111,119,115,32,111,110,108,121,44,32,97,110,100,32,110,111,116,32,119,105,116,104,32,45,45,108,105,98,32,111,114,32,45,45,100,101,98
    db 117,103,13,10,0
section .text
    lea rax, [rel .str51]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_7
    jmp .L46
.L45:
.L46:
    mov rax, [rel __g_main_drv_A_FLAG_S]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call md_p8
    add rsp, 32
    mov rax, [rel __g_main_drv_A_CG_AS_MODULE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call md_p8
    add rsp, 32
    sub rsp, 32
    call mc_module_tag
    add rsp, 32
    jmp .L44
.L43:
.L44:
    mov rcx, 1
    sub rsp, 32
    call mc_scan_flag
    add rsp, 32
    cmp rax, 0
    je .L52
    mov rax, 2
    neg rax
    jmp .__ret_7
    jmp .L53
.L52:
.L53:
    mov rax, 1
    neg rax
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
md_phases:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
section .data
.str55: db 91,49,47,54,93,32,82,101,97,100,105,110,103,32,102,105,108,101,46,46,46,0
section .text
    lea rax, [rel .str55]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_SRC_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_main_drv_A_EXP_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_main_drv_A_SRC_SIZE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_main_drv_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, r14
    push rax
    mov rax, [rel __g_main_drv_SRC_BUFFER_SIZE]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call read_file
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call md_p64
    add rsp, 32
    cmp rbx, 0
    jne .L56
section .data
.str58: db 69,82,82,79,82,58,32,99,97,110,110,111,116,32,114,101,97,100,32,116,104,101,32,102,105,108,101,46,13,10,0
section .text
    lea rax, [rel .str58]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_54
    jmp .L57
.L56:
.L57:
    mov rax, rbx
    push rax
    mov rax, [rel __g_main_drv_SRC_BUFFER_SIZE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L59
section .data
.str61: db 69,82,82,79,82,58,32,116,104,101,32,115,111,117,114,99,101,32,102,105,108,101,32,105,115,32,108,111,110,103,101,114,32,116,104,97,110,32,49,54,32,77,66,46,13,10,0
section .text
    lea rax, [rel .str61]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_54
    jmp .L60
.L59:
.L60:
    mov rcx, r14
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call expand_imports
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L62
    sub rsp, 32
    call md_import_error
    add rsp, 32
    jmp .__ret_54
    jmp .L63
.L62:
.L63:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call md_p64
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mc_scan_flag
    add rsp, 32
    cmp rax, 0
    je .L64
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call md_dump
    add rsp, 32
    jmp .L65
.L64:
.L65:
section .data
.str66: db 32,79,75,13,10,0
section .text
    lea rax, [rel .str66]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str67: db 91,50,47,54,93,32,76,101,120,101,114,46,46,46,0
section .text
    lea rax, [rel .str67]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_main_drv_A_TOKEN_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_A_TOKEN_COUNT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_TOKEN_BUFFER_SIZE]
    push rax
    mov rax, [rel __g_main_drv_TOKEN_SIZE]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_init
    add rsp, 32
    sub rsp, 32
    call klx_run
    add rsp, 32
    cmp rax, 0
    jg .L68
    sub rsp, 32
    call md_lex_error
    add rsp, 32
    jmp .__ret_54
    jmp .L69
.L68:
.L69:
section .data
.str70: db 32,79,75,13,10,0
section .text
    lea rax, [rel .str70]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str71: db 91,51,47,54,93,32,80,97,114,115,101,114,46,46,46,0
section .text
    lea rax, [rel .str71]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, r14
    push rax
    mov rcx, 0
    sub rsp, 32
    call mn_lmap
    add rsp, 32
    push rax
    mov rcx, 1
    sub rsp, 32
    call mn_lmap
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_A_LMAP_COUNT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_env
    add rsp, 32
    mov rax, [rel __g_main_drv_A_TOKEN_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_A_TOKEN_COUNT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g64
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_A_AST_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_AST_BUFFER_SIZE]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call prs_init
    add rsp, 32
    sub rsp, 32
    call prs_run
    add rsp, 32
    cmp rax, 0
    jne .L72
    sub rsp, 32
    call md_parse_error
    add rsp, 32
    jmp .__ret_54
    jmp .L73
.L72:
.L73:
    mov rax, [rel __g_main_drv_A_USED_SLICE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g32
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L76
section .data
.str78: db 115,116,100,95,97,114,101,110,97,46,107,114,0
section .text
    lea rax, [rel .str78]
    push rax
    pop rcx
    sub rsp, 32
    call mi_imp_have
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L76
    mov rax, 1
    jmp .L77
.L76:
    mov rax, 0
.L77:
    test rax, rax
    jz .L74
section .data
.str79: db 13,10,69,82,82,79,82,58,32,115,108,105,99,101,60,46,46,46,62,32,117,115,101,115,32,115,116,100,95,97,114,101,110,97,46,107,114,44,32,119,104,105,99,104,32,105,115,32,110,111,116,32,105,109,112,111,114,116,101,100,13,10,32,32
    db 104,105,110,116,58,32,97,100,100,32,32,97,99,113,117,105,114,101,95,100,111,109,97,105,110,32,34,115,116,100,95,97,114,101,110,97,46,107,114,34,59,32,32,116,111,32,116,104,101,32,104,101,97,100,101,114,13,10,0
section .text
    lea rax, [rel .str79]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_54
    jmp .L75
.L74:
.L75:
    mov rax, [rel __g_main_drv_A_USED_TEXT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g32
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L82
section .data
.str84: db 115,116,100,95,116,101,120,116,46,107,114,0
section .text
    lea rax, [rel .str84]
    push rax
    pop rcx
    sub rsp, 32
    call mi_imp_have
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L82
    mov rax, 1
    jmp .L83
.L82:
    mov rax, 0
.L83:
    test rax, rax
    jz .L80
section .data
.str85: db 13,10,69,82,82,79,82,58,32,116,104,101,32,116,121,112,101,32,116,101,120,116,32,117,115,101,115,32,115,116,100,95,116,101,120,116,46,107,114,44,32,119,104,105,99,104,32,105,115,32,110,111,116,32,105,109,112,111,114,116,101,100,13,10
    db 32,32,104,105,110,116,58,32,97,100,100,32,32,97,99,113,117,105,114,101,95,100,111,109,97,105,110,32,34,115,116,100,95,116,101,120,116,46,107,114,34,59,32,32,116,111,32,116,104,101,32,104,101,97,100,101,114,13,10,0
section .text
    lea rax, [rel .str85]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_54
    jmp .L81
.L80:
.L81:
    mov rax, [rel __g_main_drv_A_USED_LIST]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g32
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L88
section .data
.str90: db 115,116,100,95,108,105,115,116,46,107,114,0
section .text
    lea rax, [rel .str90]
    push rax
    pop rcx
    sub rsp, 32
    call mi_imp_have
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L88
    mov rax, 1
    jmp .L89
.L88:
    mov rax, 0
.L89:
    test rax, rax
    jz .L86
section .data
.str91: db 13,10,69,82,82,79,82,58,32,108,105,115,116,60,46,46,46,62,32,117,115,101,115,32,115,116,100,95,108,105,115,116,46,107,114,44,32,119,104,105,99,104,32,105,115,32,110,111,116,32,105,109,112,111,114,116,101,100,13,10,32,32,104,105
    db 110,116,58,32,97,100,100,32,32,97,99,113,117,105,114,101,95,100,111,109,97,105,110,32,34,115,116,100,95,108,105,115,116,46,107,114,34,59,32,32,40,111,114,32,115,116,100,95,116,101,120,116,46,107,114,44,32,119,104,105,99,104,32,98
    db 114,105,110,103,115,32,105,116,41,32,116,111,32,116,104,101,32,104,101,97,100,101,114,13,10,0
section .text
    lea rax, [rel .str91]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_54
    jmp .L87
.L86:
.L87:
    mov rax, [rel __g_main_drv_A_USED_MAP]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g32
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L94
section .data
.str96: db 115,116,100,95,109,97,112,46,107,114,0
section .text
    lea rax, [rel .str96]
    push rax
    pop rcx
    sub rsp, 32
    call mi_imp_have
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L94
    mov rax, 1
    jmp .L95
.L94:
    mov rax, 0
.L95:
    test rax, rax
    jz .L92
section .data
.str97: db 13,10,69,82,82,79,82,58,32,109,97,112,60,46,46,46,62,32,117,115,101,115,32,115,116,100,95,109,97,112,46,107,114,44,32,119,104,105,99,104,32,105,115,32,110,111,116,32,105,109,112,111,114,116,101,100,13,10,32,32,104,105,110,116
    db 58,32,97,100,100,32,32,97,99,113,117,105,114,101,95,100,111,109,97,105,110,32,34,115,116,100,95,109,97,112,46,107,114,34,59,32,32,116,111,32,116,104,101,32,104,101,97,100,101,114,13,10,0
section .text
    lea rax, [rel .str97]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_54
    jmp .L93
.L92:
.L93:
section .data
.str98: db 32,79,75,13,10,0
section .text
    lea rax, [rel .str98]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str99: db 91,52,47,54,93,32,83,101,109,97,110,116,105,99,46,46,46,0
section .text
    lea rax, [rel .str99]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_SYM_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_SYM_BUFFER_SIZE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_init
    add rsp, 32
    sub rsp, 32
    call prs_ast_root
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call sem_run
    add rsp, 32
    cmp rax, 0
    je .L100
section .data
.str102: db 13,10,0
section .text
    lea rax, [rel .str102]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    sub rsp, 32
    call sem_kind
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_sem_message
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_sem_report
    add rsp, 32
    jmp .__ret_54
    jmp .L101
.L100:
.L101:
section .data
.str103: db 32,79,75,13,10,0
section .text
    lea rax, [rel .str103]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str104: db 91,53,47,54,93,32,67,111,100,101,103,101,110,46,46,46,0
section .text
    lea rax, [rel .str104]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_CODE_BUFFER_SIZE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call cgk_init
    add rsp, 32
    sub rsp, 32
    call prs_ast_root
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_codegen_run
    add rsp, 32
    cmp rax, 0
    jg .L105
    sub rsp, 32
    call md_code_error
    add rsp, 32
    jmp .__ret_54
    jmp .L106
.L105:
.L106:
    mov rax, [rel __g_main_drv_A_OUT_DYNAMIC]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    sub rsp, 32
    call cgk_uses_extern
    add rsp, 32
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_p8
    add rsp, 32
    sub rsp, 32
    call ew_set_layout
    add rsp, 32
section .data
.str107: db 32,79,75,13,10,0
section .text
    lea rax, [rel .str107]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_FLAG_CHECK]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    cmp rax, 0
    je .L108
section .data
.str110: db 67,104,101,99,107,32,112,97,115,115,101,100,58,32,110,111,32,101,114,114,111,114,115,46,13,10,0
section .text
    lea rax, [rel .str110]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 0
    jmp .__ret_54
    jmp .L109
.L108:
.L109:
    mov rax, 1
    neg rax
    jmp .__ret_54
.__ret_54:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
md_codegen_run:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rax, [rel __g_main_drv_A_CG_DEBUG]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    push rax
    mov rax, [rel __g_main_drv_A_CG_AS_MODULE]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call cgk_flags
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_main_drv_A_MOD_TAG]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L112:
    cmp rbx, 72
    jge .L113
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call md_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_p8
    add rsp, 32
    add rbx, 1
.L114:
    jmp .L112
.L113:
    mov rcx, r14
    sub rsp, 32
    call cgk_run
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_main_drv_A_DBG_WHICH]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    sub rsp, 32
    call cgk_dbg_which
    add rsp, 32
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_p8
    add rsp, 32
    mov rax, rbx
    jmp .__ret_111
.__ret_111:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
md_dump:
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
    lea rax, [rel __g_main_drv_md_dump_name]
    mov r15, rax
    mov rax, [rel __g_main_drv_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov r14, rax
.L116:
    mov rax, rbx
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call md_g8
    add rsp, 32
    cmp rax, 0
    je .L117
    mov rax, r15
    add rax, r14
    push rax
    mov rax, rbx
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call md_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_p8
    add rsp, 32
    add r14, 1
.L118:
    jmp .L116
.L117:
section .data
.str119: db 46,101,120,112,97,110,100,101,100,0
section .text
    lea rax, [rel .str119]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L120:
    mov rax, 1
    test rax, rax
    jz .L121
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call md_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    add rax, r14
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call md_p8
    add rsp, 32
    cmp rbx, 0
    jne .L123
    jmp .L121
    jmp .L124
.L123:
.L124:
    add r12, 1
.L122:
    jmp .L120
.L121:
    mov rcx, r15
    mov rdx, [rbp-8]
    mov r8, [rbp-16]
    sub rsp, 32
    call write_file
    add rsp, 32
section .data
.str125: db 69,120,112,97,110,100,101,100,32,116,101,120,116,32,119,114,105,116,116,101,110,32,116,111,58,32,0
section .text
    lea rax, [rel .str125]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str126: db 13,10,0
section .text
    lea rax, [rel .str126]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .__ret_115
.__ret_115:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
md_import_error:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
section .data
.str128: db 69,82,82,79,82,58,32,97,99,113,117,105,114,101,95,100,111,109,97,105,110,58,32,0
section .text
    lea rax, [rel .str128]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_IMP_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_g32
    add rsp, 32
    mov r12, rax
section .data
.str129: db 99,97,110,110,111,116,32,102,105,110,100,32,116,104,101,32,109,111,100,117,108,101,32,39,0
section .text
    lea rax, [rel .str129]
    mov rbx, rax
    cmp r12, 2
    jne .L130
section .data
.str132: db 105,109,112,111,114,116,115,32,110,101,115,116,32,100,101,101,112,101,114,32,116,104,97,110,32,56,32,108,101,118,101,108,115,44,32,97,116,32,39,0
section .text
    lea rax, [rel .str132]
    mov rbx, rax
    jmp .L131
.L130:
    cmp r12, 3
    jne .L133
section .data
.str135: db 116,111,111,32,109,97,110,121,32,109,111,100,117,108,101,115,32,40,109,111,114,101,32,116,104,97,110,32,54,52,44,32,111,114,32,109,111,114,101,32,116,104,97,110,32,49,54,32,105,109,112,111,114,116,115,32,105,110,32,111,110,101,32,102
    db 105,108,101,41,44,32,97,116,32,39,0
section .text
    lea rax, [rel .str135]
    mov rbx, rax
    jmp .L134
.L133:
    cmp r12, 4
    jne .L136
section .data
.str138: db 116,104,101,32,108,105,110,101,32,109,97,112,32,105,115,32,102,117,108,108,58,32,109,111,114,101,32,116,104,97,110,32,49,50,56,32,114,117,110,115,32,111,102,32,108,105,110,101,115,32,102,114,111,109,32,116,104,101,32,105,109,112,111,114
    db 116,115,44,32,97,116,32,39,0
section .text
    lea rax, [rel .str138]
    mov rbx, rax
    jmp .L137
.L136:
    cmp r12, 5
    jne .L139
section .data
.str141: db 116,104,101,32,112,114,111,103,114,97,109,32,119,105,116,104,32,105,116,115,32,105,109,112,111,114,116,115,32,105,115,32,108,111,110,103,101,114,32,116,104,97,110,32,49,54,32,77,66,44,32,97,116,32,39,0
section .text
    lea rax, [rel .str141]
    mov rbx, rax
    jmp .L140
.L139:
    cmp r12, 6
    jne .L142
section .data
.str144: db 97,32,109,111,100,117,108,101,32,105,115,32,108,111,110,103,101,114,32,116,104,97,110,32,49,54,32,77,66,44,32,111,114,32,116,104,101,32,109,111,100,117,108,101,115,32,97,114,101,32,108,111,110,103,101,114,32,116,104,97,110,32,54,52
    db 32,77,66,32,116,111,103,101,116,104,101,114,44,32,97,116,32,39,0
section .text
    lea rax, [rel .str144]
    mov rbx, rax
    jmp .L143
.L142:
.L143:
.L140:
.L137:
.L134:
.L131:
    mov rcx, rbx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_A_IMP_ERRNAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str145: db 39,13,10,0
section .text
    lea rax, [rel .str145]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    cmp r12, 1
    jne .L146
section .data
.str148: db 32,32,104,105,110,116,58,32,116,104,101,32,102,105,108,101,32,104,97,115,32,116,111,32,98,101,32,105,110,32,116,104,101,32,112,114,111,103,114,97,109,39,115,32,102,111,108,100,101,114,44,32,119,105,116,104,32,105,116,115,32,46,107,114
    db 32,101,120,116,101,110,115,105,111,110,13,10,0
section .text
    lea rax, [rel .str148]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L147
.L146:
section .data
.str149: db 32,32,104,105,110,116,58,32,99,104,101,99,107,32,116,104,101,32,99,104,97,105,110,32,111,102,32,105,109,112,111,114,116,115,58,32,101,97,99,104,32,109,111,100,117,108,101,32,105,109,112,111,114,116,115,32,111,110,108,121,32,119,104,97
    db 116,32,105,116,32,117,115,101,115,13,10,0
section .text
    lea rax, [rel .str149]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
.L147:
    mov rax, 2
    jmp .__ret_127
.__ret_127:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
md_lex_error:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call klx_error_kind
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L151
section .data
.str153: db 32,32,104,105,110,116,58,32,111,117,116,115,105,100,101,32,97,32,34,46,46,46,34,32,116,101,120,116,32,97,110,100,32,97,32,47,47,32,99,111,109,109,101,110,116,44,32,75,114,111,110,32,105,115,32,119,114,105,116,116,101,110,32,119
    db 105,116,104,32,108,101,116,116,101,114,115,44,32,100,105,103,105,116,115,44,32,95,32,97,110,100,32,105,116,115,32,111,112,101,114,97,116,111,114,115,13,10,0
section .text
    lea rax, [rel .str153]
    mov [rel __g_main_drv_md_hint], rax
    sub rsp, 32
    call klx_error_token
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 10
    sub rsp, 32
    call sem_set_error
    add rsp, 32
section .data
.str154: db 13,10,0
section .text
    lea rax, [rel .str154]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str155: db 97,32,99,104,97,114,97,99,116,101,114,32,75,114,111,110,32,100,111,101,115,32,110,111,116,32,117,115,101,32,0
section .text
    lea rax, [rel .str155]
    push rax
    pop rcx
    sub rsp, 32
    call md_sem_report
    add rsp, 32
    jmp .__ret_150
    jmp .L152
.L151:
.L152:
    cmp rbx, 2
    jne .L156
section .data
.str158: db 32,32,104,105,110,116,58,32,97,32,116,101,120,116,32,101,110,100,115,32,111,110,32,105,116,115,32,111,119,110,32,34,59,32,105,110,115,105,100,101,32,111,110,101,44,32,119,114,105,116,101,32,92,34,32,102,111,114,32,97,32,113,117,111
    db 116,101,32,97,110,100,32,92,92,32,102,111,114,32,97,32,98,97,99,107,115,108,97,115,104,13,10,0
section .text
    lea rax, [rel .str158]
    mov [rel __g_main_drv_md_hint], rax
    sub rsp, 32
    call klx_error_token
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 11
    sub rsp, 32
    call sem_set_error
    add rsp, 32
section .data
.str159: db 13,10,0
section .text
    lea rax, [rel .str159]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str160: db 97,32,116,101,120,116,32,119,105,116,104,32,110,111,32,99,108,111,115,105,110,103,32,113,117,111,116,101,0
section .text
    lea rax, [rel .str160]
    push rax
    pop rcx
    sub rsp, 32
    call md_sem_report
    add rsp, 32
    jmp .__ret_150
    jmp .L157
.L156:
.L157:
section .data
.str161: db 13,10,0
section .text
    lea rax, [rel .str161]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str162: db 69,82,82,79,82,58,32,116,104,101,32,112,114,111,103,114,97,109,32,119,105,116,104,32,105,116,115,32,109,111,100,117,108,101,115,32,105,115,32,116,111,111,32,98,105,103,32,102,111,114,32,116,104,101,32,108,101,120,101,114,58,32,109,111
    db 114,101,32,116,104,97,110,32,50,55,57,54,50,48,50,32,116,111,107,101,110,115,46,13,10,0
section .text
    lea rax, [rel .str162]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 3
    jmp .__ret_150
.__ret_150:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
md_parse_error:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call prs_error_line
    add rsp, 32
    push rax
    sub rsp, 32
    call prs_error_col
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_position
    add rsp, 32
    sub rsp, 32
    call prs_custom_msg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L164
section .data
.str166: db 58,32,0
section .text
    lea rax, [rel .str166]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str167: db 13,10,0
section .text
    lea rax, [rel .str167]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L165
.L164:
    sub rsp, 32
    call prs_expected
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L168
section .data
.str170: db 58,32,101,120,112,101,99,116,101,100,32,0
section .text
    lea rax, [rel .str170]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call prs_token_name
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str171: db 44,32,102,111,117,110,100,32,0
section .text
    lea rax, [rel .str171]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L169
.L168:
section .data
.str172: db 58,32,117,110,101,120,112,101,99,116,101,100,32,0
section .text
    lea rax, [rel .str172]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
.L169:
    sub rsp, 32
    call prs_error_token
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call prs_token_name
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str173: db 13,10,0
section .text
    lea rax, [rel .str173]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
.L165:
    sub rsp, 32
    call prs_error_line
    add rsp, 32
    push rax
    sub rsp, 32
    call prs_error_col
    add rsp, 32
    push rax
    sub rsp, 32
    call prs_error_len
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mi_print_error_line
    add rsp, 32
    mov rax, 4
    jmp .__ret_163
.__ret_163:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
md_position:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rcx, rbx
    sub rsp, 32
    call mi_lmap_lookup
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    sub rsp, 32
    call mi_lmap_line
    add rsp, 32
    mov rbx, rax
section .data
.str175: db 58,0
section .text
    lea rax, [rel .str175]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
section .data
.str176: db 58,0
section .text
    lea rax, [rel .str176]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
    jmp .__ret_174
.__ret_174:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
md_sem_message:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 1
    jne .L178
section .data
.str180: db 100,117,112,108,105,99,97,116,101,32,97,114,101,110,97,32,110,97,109,101,32,0
section .text
    lea rax, [rel .str180]
    jmp .__ret_177
    jmp .L179
.L178:
.L179:
    cmp rbx, 2
    jne .L181
section .data
.str183: db 97,114,101,110,97,32,100,101,99,108,97,114,101,100,32,119,105,116,104,32,122,101,114,111,32,115,105,122,101,32,0
section .text
    lea rax, [rel .str183]
    jmp .__ret_177
    jmp .L182
.L181:
.L182:
    cmp rbx, 3
    jne .L184
section .data
.str186: db 97,114,101,110,97,115,32,111,118,101,114,108,97,112,32,0
section .text
    lea rax, [rel .str186]
    jmp .__ret_177
    jmp .L185
.L184:
.L185:
    cmp rbx, 4
    jne .L187
section .data
.str189: db 117,110,100,101,99,108,97,114,101,100,32,97,114,114,97,121,32,0
section .text
    lea rax, [rel .str189]
    jmp .__ret_177
    jmp .L188
.L187:
.L188:
    cmp rbx, 5
    jne .L190
section .data
.str192: db 99,97,110,110,111,116,32,97,115,115,105,103,110,32,116,111,32,116,104,105,115,0
section .text
    lea rax, [rel .str192]
    jmp .__ret_177
    jmp .L191
.L190:
.L191:
    cmp rbx, 6
    jne .L193
section .data
.str195: db 97,114,114,97,121,32,115,109,97,108,108,101,114,32,116,104,97,110,32,116,104,101,32,112,97,114,97,109,101,116,101,114,32,105,116,32,105,115,32,112,97,115,115,101,100,32,116,111,32,0
section .text
    lea rax, [rel .str195]
    jmp .__ret_177
    jmp .L194
.L193:
.L194:
    cmp rbx, 7
    jne .L196
section .data
.str198: db 111,110,108,121,32,97,108,108,111,119,101,100,32,105,110,115,105,100,101,32,114,97,119,58,32,0
section .text
    lea rax, [rel .str198]
    jmp .__ret_177
    jmp .L197
.L196:
.L197:
    cmp rbx, 9
    jne .L199
section .data
.str201: db 97,114,114,97,121,32,101,108,101,109,101,110,116,32,116,121,112,101,32,100,105,102,102,101,114,115,32,102,114,111,109,32,116,104,101,32,112,97,114,97,109,101,116,101,114,39,115,32,0
section .text
    lea rax, [rel .str201]
    jmp .__ret_177
    jmp .L200
.L199:
.L200:
section .data
.str202: db 117,110,100,101,99,108,97,114,101,100,32,110,97,109,101,32,0
section .text
    lea rax, [rel .str202]
    jmp .__ret_177
.__ret_177:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
md_sem_report:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov rbx, rcx
    sub rsp, 32
    call sem_line
    add rsp, 32
    push rax
    sub rsp, 32
    call sem_col
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_position
    add rsp, 32
section .data
.str204: db 58,32,0
section .text
    lea rax, [rel .str204]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call md_say
    add rsp, 32
    sub rsp, 32
    call sem_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 5
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L207
    mov rax, rbx
    mov rcx, 11
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L207
    mov rax, 1
    jmp .L208
.L207:
    mov rax, 0
.L208:
    test rax, rax
    jz .L205
    sub rsp, 32
    call sem_len
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call sem_name
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L211
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L211
    mov rax, 1
    jmp .L212
.L211:
    mov rax, 0
.L212:
    test rax, rax
    jz .L209
section .data
.str213: db 39,0
section .text
    lea rax, [rel .str213]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call print_bytes
    add rsp, 32
section .data
.str214: db 39,0
section .text
    lea rax, [rel .str214]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L210
.L209:
.L210:
    jmp .L206
.L205:
.L206:
section .data
.str215: db 13,10,0
section .text
    lea rax, [rel .str215]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    sub rsp, 32
    call sem_line
    add rsp, 32
    push rax
    sub rsp, 32
    call sem_col
    add rsp, 32
    push rax
    sub rsp, 32
    call sem_len
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mi_print_error_line
    add rsp, 32
    sub rsp, 32
    call sem_kind
    add rsp, 32
    mov rbx, rax
    cmp rbx, 6
    jne .L216
section .data
.str218: db 32,32,104,105,110,116,58,32,116,104,101,32,102,117,110,99,116,105,111,110,32,105,110,100,101,120,101,115,32,97,115,32,102,97,114,32,97,115,32,105,116,115,32,112,97,114,97,109,101,116,101,114,32,100,101,99,108,97,114,101,115,59,32,112
    db 97,115,115,32,97,110,32,97,114,114,97,121,32,97,116,32,108,101,97,115,116,32,116,104,97,116,32,98,105,103,13,10,0
section .text
    lea rax, [rel .str218]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L217
.L216:
    cmp rbx, 7
    jne .L219
section .data
.str221: db 32,32,104,105,110,116,58,32,112,117,116,32,105,116,32,105,110,115,105,100,101,32,114,97,119,32,123,32,46,46,46,32,125,58,32,109,101,109,111,114,121,32,98,121,32,97,100,100,114,101,115,115,32,40,112,101,101,107,44,32,112,111,107,101
    db 44,32,42,112,41,32,97,110,100,32,116,104,101,32,115,121,115,116,101,109,32,40,100,108,108,95,108,111,97,100,44,32,100,108,108,95,112,114,111,99,44,32,115,121,115,99,97,108,108,41,32,97,114,101,32,114,101,97,99,104,101,100,32,111
    db 110,108,121,32,116,104,101,114,101,13,10,0
section .text
    lea rax, [rel .str221]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L220
.L219:
    cmp rbx, 9
    jne .L222
section .data
.str224: db 32,32,104,105,110,116,58,32,101,108,101,109,101,110,116,115,32,97,114,101,32,115,116,111,114,101,100,32,97,116,32,116,104,101,105,114,32,111,119,110,32,119,105,100,116,104,32,40,91,117,56,59,32,78,93,32,111,110,101,32,98,121,116,101
    db 32,101,97,99,104,41,44,32,115,111,32,116,104,101,32,112,97,114,97,109,101,116,101,114,32,109,117,115,116,32,100,101,99,108,97,114,101,32,116,104,101,32,115,97,109,101,32,101,108,101,109,101,110,116,32,116,121,112,101,13,10,0
section .text
    lea rax, [rel .str224]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L223
.L222:
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L227
    mov rax, rbx
    mov rcx, 11
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L227
    mov rax, 0
    jmp .L228
.L227:
    mov rax, 1
.L228:
    test rax, rax
    jz .L225
    mov rax, [rel __g_main_drv_md_hint]
    cmp rax, 0
    je .L229
    mov rax, [rel __g_main_drv_md_hint]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L230
.L229:
.L230:
    jmp .L226
.L225:
    cmp rbx, 8
    jne .L231
section .data
.str233: db 32,32,104,105,110,116,58,32,100,101,99,108,97,114,101,32,105,116,32,39,115,104,97,114,101,100,32,118,97,114,39,32,97,110,100,32,103,117,97,114,100,32,105,116,32,119,105,116,104,32,97,32,108,111,99,107,44,32,111,114,32,112,97,115
    db 115,32,116,104,101,32,118,97,108,117,101,32,116,104,114,111,117,103,104,32,97,32,99,104,97,110,110,101,108,13,10,0
section .text
    lea rax, [rel .str233]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L232
.L231:
    sub rsp, 32
    call sem_suggest_name
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call sem_suggest_len
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L236
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L236
    mov rax, 1
    jmp .L237
.L236:
    mov rax, 0
.L237:
    test rax, rax
    jz .L234
section .data
.str238: db 32,32,104,105,110,116,58,32,100,105,100,32,121,111,117,32,109,101,97,110,32,39,0
section .text
    lea rax, [rel .str238]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call print_bytes
    add rsp, 32
section .data
.str239: db 39,63,13,10,0
section .text
    lea rax, [rel .str239]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L235
.L234:
.L235:
.L232:
.L226:
.L223:
.L220:
.L217:
    mov rax, 4
    jmp .__ret_203
.__ret_203:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
md_code_error:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    sub rsp, 32
    call cgk_err_tok
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call cgk_err_hint
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call cgk_err_msg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L241
    mov rax, r12
    mov [rel __g_main_drv_md_hint], rax
    cmp r13, 0
    je .L243
    mov rcx, r13
    mov rdx, 10
    sub rsp, 32
    call sem_set_error
    add rsp, 32
section .data
.str245: db 13,10,0
section .text
    lea rax, [rel .str245]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call md_sem_report
    add rsp, 32
    jmp .__ret_240
    jmp .L244
.L243:
.L244:
section .data
.str246: db 13,10,0
section .text
    lea rax, [rel .str246]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str247: db 69,82,82,79,82,58,32,0
section .text
    lea rax, [rel .str247]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str248: db 13,10,0
section .text
    lea rax, [rel .str248]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, [rel __g_main_drv_md_hint]
    cmp rax, 0
    je .L249
    mov rax, [rel __g_main_drv_md_hint]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    jmp .L250
.L249:
.L250:
    mov rax, 5
    jmp .__ret_240
    jmp .L242
.L241:
.L242:
    sub rsp, 32
    call cgk_thread_tok
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L251
    mov rcx, rbx
    mov rdx, 8
    sub rsp, 32
    call sem_set_error
    add rsp, 32
section .data
.str253: db 13,10,0
section .text
    lea rax, [rel .str253]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
section .data
.str254: db 103,108,111,98,97,108,32,117,115,101,100,32,98,121,32,99,111,100,101,32,116,104,97,116,32,114,117,110,115,32,105,110,32,97,32,116,104,114,101,97,100,32,0
section .text
    lea rax, [rel .str254]
    push rax
    pop rcx
    sub rsp, 32
    call md_sem_report
    add rsp, 32
    jmp .__ret_240
    jmp .L252
.L251:
.L252:
    mov rax, [rel __g_main_drv_A_DBG_WHICH]
    push rax
    pop rcx
    sub rsp, 32
    call md_flag
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L255
section .data
.str257: db 69,82,82,79,82,58,32,116,104,101,32,103,101,110,101,114,97,116,101,100,32,99,111,100,101,32,105,115,32,108,97,114,103,101,114,32,116,104,97,110,32,116,104,101,32,99,111,109,112,105,108,101,114,39,115,32,98,117,102,102,101,114,115,32
    db 104,111,108,100,46,13,10,32,32,104,105,110,116,58,32,115,112,108,105,116,32,116,104,101,32,108,111,110,103,101,115,116,32,102,117,110,99,116,105,111,110,44,32,111,114,32,116,104,101,32,112,114,111,103,114,97,109,44,32,105,110,116,111,32
    db 115,109,97,108,108,101,114,32,111,110,101,115,13,10,0
section .text
    lea rax, [rel .str257]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rax, 5
    jmp .__ret_240
    jmp .L256
.L255:
.L256:
section .data
.str258: db 69,82,82,79,82,58,32,99,111,100,101,103,101,110,32,102,97,105,108,101,100,46,13,10,0
section .text
    lea rax, [rel .str258]
    push rax
    pop rcx
    sub rsp, 32
    call md_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
    mov rax, 5
    jmp .__ret_240
.__ret_240:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
