; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_main_out_A_INPUT: dq 0
section .text
section .data
__g_main_out_A_FLAG_S: dq 2
section .text
section .data
__g_main_out_A_FLAG_DEBUG: dq 4
section .text
section .data
__g_main_out_A_FLAG_WINDOW: dq 5
section .text
section .data
__g_main_out_A_FLAG_LIB: dq 6
section .text
section .data
__g_main_out_A_IOS: dq 9
section .text
section .data
__g_main_out_A_OUT_BIN_NAME: dq 10
section .text
section .data
__g_main_out_A_OUT_ASM_NAME: dq 11
section .text
section .data
__g_main_out_A_BIN_EXT_PTR: dq 12
section .text
section .data
__g_main_out_A_OUT_TARGET: dq 17
section .text
section .data
__g_main_out_A_SRC_BUFFER: dq 18
section .text
section .data
__g_main_out_A_SRC_SIZE: dq 19
section .text
section .data
__g_main_out_A_EXP_BUFFER: dq 20
section .text
section .data
__g_main_out_A_CODE_BUFFER: dq 25
section .text
section .data
__g_main_out_A_OUT_DYNAMIC: dq 29
section .text
section .data
__g_main_out_A_IMP_ERR: dq 30
section .text
section .data
__g_main_out_A_IMP_ERRNAME: dq 31
section .text
section .data
__g_main_out_A_LMAP_COUNT: dq 32
section .text
section .data
__g_main_out_T_PE: dq 0
section .text
section .data
__g_main_out_T_ELF: dq 1
section .text
section .data
__g_main_out_T_ARM64: dq 4
section .text
section .data
__g_main_out_T_WEB: dq 5
section .text
section .data
__g_main_out_T_MACOS: dq 6
section .text
section .data
__g_main_out_SRC_BUFFER_SIZE: dq 16777216
section .text
section .data
__g_main_out_CODE_BUFFER_SIZE: dq 16777216
section .text
section .bss
__g_main_out_mx_idbuf: resq 65
section .text
mx_g8:
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
mx_p8:
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
mx_p32:
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
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mx_p64:
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
mx_flag:
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
    call mx_g8
    add rsp, 32
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mx_say:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call print_string
    add rsp, 32
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mx_ext:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_main_out_A_BIN_EXT_PTR]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mx_p64
    add rsp, 32
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mx_basename:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rax, rbx
    mov r13, rax
    mov rax, rbx
    mov r12, rax
.L8:
    mov rax, 1
    test rax, rax
    jz .L9
    mov rcx, r13
    sub rsp, 32
    call mx_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L11
    mov rax, r12
    jmp .__ret_7
    jmp .L12
.L11:
.L12:
    add r13, 1
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L15
    mov rax, rbx
    mov rcx, 92
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
    mov rax, r13
    mov r12, rax
    jmp .L14
.L13:
.L14:
.L10:
    jmp .L8
.L9:
    mov rax, r12
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mx_main:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
section .data
.str18: db 61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,13,10,32,32,75,82,79,78,32,49,46,48,13,10,32,32,77,101,109,111,114,121,45,115
    db 97,102,101,44,32,116,104,114,101,97,100,45,115,97,102,101,32,110,97,116,105,118,101,32,99,111,100,101,13,10,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61,61
    db 61,61,61,61,61,61,13,10,0
section .text
    lea rax, [rel .str18]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    sub rsp, 32
    call md_start
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 2
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L19
    sub rsp, 32
    call mx_assemble
    add rsp, 32
    jmp .__ret_17
    jmp .L20
.L19:
.L20:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L21
    mov rax, rbx
    jmp .__ret_17
    jmp .L22
.L21:
.L22:
    sub rsp, 32
    call md_phases
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L23
    mov rax, rbx
    jmp .__ret_17
    jmp .L24
.L23:
.L24:
    sub rsp, 32
    call mx_output
    add rsp, 32
    jmp .__ret_17
.__ret_17:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ew_set_layout:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 128
    mov rbx, rax
    mov rax, [rel __g_main_out_A_OUT_DYNAMIC]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    cmp rax, 0
    je .L26
    mov rax, 1024
    mov rbx, rax
    jmp .L27
.L26:
.L27:
    mov rax, rbx
    push rax
    mov rax, rbx
    add rax, 4194304
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ew_put_hb
    add rsp, 32
    jmp .__ret_25
.__ret_25:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mx_copy:
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
.L29:
    cmp rbx, r12
    jge .L30
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mx_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_p8
    add rsp, 32
    add rbx, 1
.L31:
    jmp .L29
.L30:
    mov rax, 0
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
expand_imports:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    sub rsp, 32
    call mi_reset_pool
    add rsp, 32
    mov rax, [rel __g_main_out_A_FLAG_DEBUG]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call ip_debug_set
    add rsp, 32
    mov rax, [rel __g_main_out_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_main_out_SRC_BUFFER_SIZE]
    push rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ip_expand
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_main_out_A_IMP_ERR]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    sub rsp, 32
    call ip_err_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_p32
    add rsp, 32
    mov rax, [rel __g_main_out_A_IMP_ERRNAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ip_errname_addr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, 256
    sub rsp, 32
    call mx_copy
    add rsp, 32
    mov rax, rbx
    add rax, 256
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mx_p8
    add rsp, 32
    sub rsp, 32
    call ip_lm_count_get
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_main_out_A_LMAP_COUNT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mx_p64
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L33:
    cmp rbx, 3
    jge .L34
    mov rcx, rbx
    sub rsp, 32
    call mn_lmap
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call ip_lm_addr
    add rsp, 32
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_copy
    add rsp, 32
    add rbx, 1
.L35:
    jmp .L33
.L34:
    mov rax, r13
    jmp .__ret_32
.__ret_32:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
mx_wrote:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
section .data
.str37: db 32,79,75,13,10,0
section .text
    lea rax, [rel .str37]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str38: db 87,114,105,116,116,101,110,58,32,0
section .text
    lea rax, [rel .str38]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str39: db 13,10,67,111,109,112,105,108,97,116,105,111,110,32,115,117,99,99,101,115,115,102,117,108,33,13,10,0
section .text
    lea rax, [rel .str39]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 0
    jmp .__ret_36
.__ret_36:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mx_write_error:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str41: db 69,82,82,79,82,58,32,99,111,117,108,100,32,110,111,116,32,119,114,105,116,101,32,116,104,101,32,111,117,116,112,117,116,32,102,105,108,101,46,13,10,32,32,104,105,110,116,58,32,105,115,32,116,104,101,32,112,114,111,103,114,97,109,32
    db 115,116,105,108,108,32,114,117,110,110,105,110,103,44,32,111,114,32,116,104,101,32,102,105,108,101,32,111,112,101,110,32,101,108,115,101,119,104,101,114,101,63,13,10,0
section .text
    lea rax, [rel .str41]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 6
    jmp .__ret_40
.__ret_40:
    mov rsp, rbp
    pop rbp
    ret
mx_direct_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    sub rsp, 32
    call mc_build_bin_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_main_out_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
    call write_file
    add rsp, 32
    cmp rax, 0
    jne .L43
    sub rsp, 32
    call mx_write_error
    add rsp, 32
    jmp .__ret_42
    jmp .L44
.L43:
.L44:
    mov rax, rbx
    push rax
section .data
.str45: db 13,10,0
section .text
    lea rax, [rel .str45]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_wrote
    add rsp, 32
    jmp .__ret_42
.__ret_42:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mx_output:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
section .data
.str47: db 91,54,47,54,93,32,76,105,110,107,105,110,103,46,46,46,0
section .text
    lea rax, [rel .str47]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_TARGET]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_main_out_T_ARM64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L50
    mov rax, r12
    push rax
    mov rax, [rel __g_main_out_T_MACOS]
    mov rcx, rax
    pop rax
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
    mov rcx, r12
    sub rsp, 32
    call mx_arm_out
    add rsp, 32
    jmp .__ret_46
    jmp .L49
.L48:
.L49:
    mov rax, [rel __g_main_out_A_FLAG_S]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_main_out_T_WEB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L54
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L54
    mov rax, 1
    jmp .L55
.L54:
    mov rax, 0
.L55:
    test rax, rax
    jz .L52
    sub rsp, 32
    call mx_web_out
    add rsp, 32
    jmp .__ret_46
    jmp .L53
.L52:
.L53:
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L58
    mov rax, r12
    push rax
    mov rax, [rel __g_main_out_T_PE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L60
    mov rax, r12
    push rax
    mov rax, [rel __g_main_out_T_ELF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L60
    mov rax, 0
    jmp .L61
.L60:
    mov rax, 1
.L61:
    test rax, rax
    jz .L58
    mov rax, 1
    jmp .L59
.L58:
    mov rax, 0
.L59:
    test rax, rax
    jz .L56
    mov rcx, r12
    sub rsp, 32
    call mx_direct_exe
    add rsp, 32
    jmp .__ret_46
    jmp .L57
.L56:
.L57:
    sub rsp, 32
    call mx_write_asm
    add rsp, 32
    jmp .__ret_46
.__ret_46:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mx_write_asm:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call mc_build_asm_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_ASM_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call cgk_code
    add rsp, 32
    push rax
    sub rsp, 32
    call cgk_code_size
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call write_file
    add rsp, 32
    cmp rax, 0
    jne .L63
    sub rsp, 32
    call mx_write_error
    add rsp, 32
    jmp .__ret_62
    jmp .L64
.L63:
.L64:
    mov rax, rbx
    push rax
section .data
.str65: db 13,10,0
section .text
    lea rax, [rel .str65]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_wrote
    add rsp, 32
    jmp .__ret_62
.__ret_62:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mx_expand_code:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call cgk_code_size
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call cgk_code
    add rsp, 32
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_main_out_A_EXP_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_preprocess
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_main_out_A_SRC_SIZE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mx_p64
    add rsp, 32
    mov rax, rbx
    jmp .__ret_66
.__ret_66:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mx_lower_error:
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
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str68: db 32,32,97,116,32,108,105,110,101,32,0
section .text
    lea rax, [rel .str68]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
section .data
.str69: db 32,32,45,45,32,0
section .text
    lea rax, [rel .str69]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str70: db 13,10,0
section .text
    lea rax, [rel .str70]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str71: db 32,32,105,110,115,116,114,117,99,116,105,111,110,58,32,0
section .text
    lea rax, [rel .str71]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str72: db 13,10,0
section .text
    lea rax, [rel .str72]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_67
.__ret_67:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mx_arm_out:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov r13, rcx
    sub rsp, 32
    call mx_expand_code
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_main_out_T_MACOS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L74
    mov rax, 1
    mov rbx, rax
    jmp .L75
.L74:
.L75:
    mov rcx, rbx
    sub rsp, 32
    call xarm_set_os
    add rsp, 32
    sub rsp, 32
    call cgk_has_exports
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call xarm_set_lib
    add rsp, 32
    mov rax, [rel __g_main_out_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_main_out_A_EXP_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_main_out_CODE_BUFFER_SIZE]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xl_translate
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L76
section .data
.str78: db 69,82,82,79,82,58,32,116,104,101,32,112,114,111,103,114,97,109,32,99,111,117,108,100,32,110,111,116,32,98,101,32,108,111,119,101,114,101,100,32,116,111,32,65,82,77,54,52,46,13,10,0
section .text
    lea rax, [rel .str78]
    push rax
    sub rsp, 32
    call xarm_error_line
    add rsp, 32
    push rax
    sub rsp, 32
    call xarm_error_text
    add rsp, 32
    push rax
    sub rsp, 32
    call xarm_error_insn
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_lower_error
    add rsp, 32
    jmp .__ret_73
    jmp .L77
.L76:
.L77:
    mov rax, [rel __g_main_out_A_SRC_SIZE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mx_p64
    add rsp, 32
    mov rax, [rel __g_main_out_A_FLAG_S]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    cmp rax, 0
    je .L79
    sub rsp, 32
    call mc_build_asm_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_ASM_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call write_file
    add rsp, 32
    cmp rax, 0
    jne .L81
    sub rsp, 32
    call mx_write_error
    add rsp, 32
    jmp .__ret_73
    jmp .L82
.L81:
.L82:
    mov rax, rbx
    push rax
section .data
.str83: db 13,10,0
section .text
    lea rax, [rel .str83]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_wrote
    add rsp, 32
    jmp .__ret_73
    jmp .L80
.L79:
.L80:
    cmp rbx, 0
    je .L84
    mov rcx, r12
    sub rsp, 32
    call mx_mac_image
    add rsp, 32
    jmp .__ret_73
    jmp .L85
.L84:
.L85:
    sub rsp, 32
    call kc_init
    add rsp, 32
    mov rax, [rel __g_main_out_A_FLAG_LIB]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    cmp rax, 0
    je .L86
    mov rcx, 512
    sub rsp, 32
    call kc_set_base
    add rsp, 32
    mov rcx, 65536
    sub rsp, 32
    call kc_set_align
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call kc_assemble
    add rsp, 32
    cmp rax, 0
    jne .L88
    sub rsp, 32
    call mx_karm_error
    add rsp, 32
    jmp .__ret_73
    jmp .L89
.L88:
.L89:
    sub rsp, 32
    call el_prepare
    add rsp, 32
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
    call el_write_so
    add rsp, 32
    mov rbx, rax
section .data
.str90: db 46,115,111,0
section .text
    lea rax, [rel .str90]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mx_direct_name
    add rsp, 32
    jmp .__ret_73
    jmp .L87
.L86:
.L87:
    sub rsp, 32
    call ew_get_base
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_set_base
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call kc_assemble
    add rsp, 32
    cmp rax, 0
    jne .L91
    sub rsp, 32
    call mx_karm_error
    add rsp, 32
    jmp .__ret_73
    jmp .L92
.L91:
.L92:
    mov rcx, r13
    sub rsp, 32
    call el_write_arm
    add rsp, 32
    mov rbx, rax
section .data
.str93: db 0
section .text
    lea rax, [rel .str93]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mx_direct_name
    add rsp, 32
    jmp .__ret_73
.__ret_73:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
mx_mac_image:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rbx, rcx
    mov rax, [rel __g_main_out_A_FLAG_LIB]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    mov r15, rax
    mov rax, 1
    mov r14, rax
    mov rax, [rel __g_main_out_A_IOS]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    cmp rax, 0
    je .L95
    mov rax, 2
    mov r14, rax
    jmp .L96
.L95:
.L96:
    sub rsp, 32
    call kc_init
    add rsp, 32
    cmp r15, 0
    je .L97
    mov rcx, 16384
    sub rsp, 32
    call kc_set_base
    add rsp, 32
    jmp .L98
.L97:
    mov rcx, 0x100004000
    sub rsp, 32
    call kc_set_base
    add rsp, 32
.L98:
    mov rcx, 16384
    sub rsp, 32
    call kc_set_align
    add rsp, 32
    mov rax, [rel __g_main_out_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call kc_assemble
    add rsp, 32
    cmp rax, 0
    jne .L99
    sub rsp, 32
    call mx_karm_error
    add rsp, 32
    jmp .__ret_94
    jmp .L100
.L99:
.L100:
    cmp r15, 0
    je .L101
section .data
.str103: db 46,100,121,108,105,98,0
section .text
    lea rax, [rel .str103]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    jmp .L102
.L101:
section .data
.str104: db 0
section .text
    lea rax, [rel .str104]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
.L102:
    sub rsp, 32
    call mc_build_bin_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call mx_basename
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call mx_mac_idname
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_set_flags
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call mw_write
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L105
section .data
.str107: db 13,10,69,82,82,79,82,58,32,116,104,101,32,109,97,99,79,83,32,101,120,101,99,117,116,97,98,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,109,97,100,101,58,32,116,104,101,32,112,114,111,103,114,97,109,32,107,101,101
    db 112,115,32,97,110,13,10,32,32,32,32,32,32,32,97,100,100,114,101,115,115,32,105,110,32,97,32,100,113,32,111,102,32,105,116,115,32,99,111,100,101,44,32,111,114,32,116,104,101,32,115,104,105,109,32,105,115,32,109,105,115,115,105,110
    db 103,46,13,10,0
section .text
    lea rax, [rel .str107]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_94
    jmp .L106
.L105:
.L106:
    mov rcx, rbx
    sub rsp, 32
    call mx_direct_name
    add rsp, 32
    jmp .__ret_94
.__ret_94:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
mx_mac_idname:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r12, rcx
    mov r15, rdx
    mov rax, r15
    sub rax, r12
    cmp rax, 12
    jge .L109
    mov rax, r15
    jmp .__ret_108
    jmp .L110
.L109:
.L110:
    mov rax, r15
    sub rax, 1
    mov r13, rax
    mov rax, r13
    mov r14, rax
.L111:
    cmp r14, r12
    je .L112
    mov rax, r14
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mx_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L116
    mov rax, rbx
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L116
    mov rax, 0
    jmp .L117
.L116:
    mov rax, 1
.L117:
    test rax, rax
    jz .L114
    jmp .L112
    jmp .L115
.L114:
.L115:
    sub r14, 1
.L113:
    jmp .L111
.L112:
    mov rax, r13
    sub rax, r14
    cmp rax, 10
    jge .L118
    mov rax, r15
    jmp .__ret_108
    jmp .L119
.L118:
.L119:
section .data
.str120: db 46,102,114,97,109,101,119,111,114,107,0
section .text
    lea rax, [rel .str120]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L121:
    cmp rbx, 10
    jge .L122
    mov rax, r13
    sub rax, 10
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mx_g8
    add rsp, 32
    push rax
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mx_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L124
    mov rax, r15
    jmp .__ret_108
    jmp .L125
.L124:
.L125:
    add rbx, 1
.L123:
    jmp .L121
.L122:
    lea rax, [rel __g_main_out_mx_idbuf]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L126:
    mov rax, 1
    test rax, rax
    jz .L127
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mx_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 92
    jne .L129
    mov rax, 47
    mov rbx, rax
    jmp .L130
.L129:
.L130:
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mx_p8
    add rsp, 32
    cmp rbx, 0
    jne .L131
    mov rax, r13
    jmp .__ret_108
    jmp .L132
.L131:
.L132:
    add r12, 1
.L128:
    jmp .L126
.L127:
    mov rax, r13
    jmp .__ret_108
.__ret_108:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
mx_web_out:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call mx_expand_code
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_main_out_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_main_out_A_EXP_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, rbx
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_main_out_CODE_BUFFER_SIZE]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call xv_translate
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L134
section .data
.str136: db 13,10,69,82,82,79,82,58,32,120,119,97,115,109,32,99,111,117,108,100,32,110,111,116,32,108,111,119,101,114,32,116,104,101,32,103,101,110,101,114,97,116,101,100,32,99,111,100,101,32,116,111,32,87,101,98,65,115,115,101,109,98,108,121
    db 13,10,0
section .text
    lea rax, [rel .str136]
    push rax
    sub rsp, 32
    call xarm_error_line
    add rsp, 32
    push rax
    sub rsp, 32
    call xarm_error_text
    add rsp, 32
    push rax
    sub rsp, 32
    call xarm_error_insn
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_lower_error
    add rsp, 32
    jmp .__ret_133
    jmp .L135
.L134:
.L135:
section .data
.str137: db 46,119,97,115,109,0
section .text
    lea rax, [rel .str137]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    sub rsp, 32
    call mc_build_bin_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call write_file
    add rsp, 32
    cmp rax, 0
    jne .L138
    sub rsp, 32
    call mx_write_error
    add rsp, 32
    jmp .__ret_133
    jmp .L139
.L138:
.L139:
    sub rsp, 32
    call ww_write_host
    add rsp, 32
    cmp rax, 0
    jne .L140
    sub rsp, 32
    call mx_write_error
    add rsp, 32
    jmp .__ret_133
    jmp .L141
.L140:
.L141:
    mov rax, rbx
    push rax
section .data
.str142: db 13,10,32,32,119,105,116,104,32,105,116,115,32,112,97,103,101,32,40,46,104,116,109,108,41,32,97,110,100,32,107,114,111,110,95,119,101,98,46,106,115,32,98,101,115,105,100,101,32,105,116,13,10,0
section .text
    lea rax, [rel .str142]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mx_wrote
    add rsp, 32
    jmp .__ret_133
.__ret_133:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mx_direct_exe:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r14, rcx
    sub rsp, 32
    call mx_expand_code
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call ks_init
    add rsp, 32
    mov rax, [rel __g_main_out_A_EXP_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call ks_assemble
    add rsp, 32
    cmp rax, 0
    jne .L144
    sub rsp, 32
    call mx_kasm_error
    add rsp, 32
    jmp .__ret_143
    jmp .L145
.L144:
.L145:
    mov rax, [rel __g_main_out_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_main_out_A_FLAG_LIB]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    mov r12, rax
    mov rax, r14
    push rax
    mov rax, [rel __g_main_out_T_ELF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L146
    cmp r12, 0
    je .L148
    sub rsp, 32
    call el_prepare
    add rsp, 32
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
    call el_write_so
    add rsp, 32
    mov rbx, rax
section .data
.str150: db 46,115,111,0
section .text
    lea rax, [rel .str150]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mx_direct_name
    add rsp, 32
    jmp .__ret_143
    jmp .L149
.L148:
.L149:
    mov rcx, r13
    sub rsp, 32
    call el_write
    add rsp, 32
    mov rbx, rax
section .data
.str151: db 0
section .text
    lea rax, [rel .str151]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mx_direct_name
    add rsp, 32
    jmp .__ret_143
    jmp .L147
.L146:
.L147:
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L152
section .data
.str154: db 46,100,108,108,0
section .text
    lea rax, [rel .str154]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    sub rsp, 32
    call mc_build_bin_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mx_basename
    add rsp, 32
    mov rbx, rax
    jmp .L153
.L152:
.L153:
    mov rax, [rel __g_main_out_A_FLAG_WINDOW]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call pw_set_flags
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call pe_write
    add rsp, 32
    mov rbx, rax
    cmp r12, 0
    je .L155
section .data
.str157: db 46,100,108,108,0
section .text
    lea rax, [rel .str157]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    jmp .L156
.L155:
section .data
.str158: db 46,101,120,101,0
section .text
    lea rax, [rel .str158]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
.L156:
    mov rcx, rbx
    sub rsp, 32
    call mx_direct_name
    add rsp, 32
    jmp .__ret_143
.__ret_143:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
mx_karm_error:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
section .data
.str160: db 69,82,82,79,82,58,32,107,97,114,109,32,102,97,105,108,101,100,32,116,111,32,97,115,115,101,109,98,108,101,46,13,10,0
section .text
    lea rax, [rel .str160]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    sub rsp, 32
    call kc_get_error_count
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L161:
    cmp rbx, r12
    jge .L162
section .data
.str164: db 32,32,97,116,32,108,105,110,101,32,0
section .text
    lea rax, [rel .str164]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_get_error_line_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
section .data
.str165: db 32,32,32,0
section .text
    lea rax, [rel .str165]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_get_error_mnem
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str166: db 32,32,45,45,32,0
section .text
    lea rax, [rel .str166]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_get_error_text
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str167: db 13,10,0
section .text
    lea rax, [rel .str167]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    add rbx, 1
.L163:
    jmp .L161
.L162:
    mov rax, 1
    jmp .__ret_159
.__ret_159:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mx_kasm_error:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
section .data
.str169: db 69,82,82,79,82,58,32,107,97,115,109,32,102,97,105,108,101,100,32,116,111,32,97,115,115,101,109,98,108,101,46,13,10,0
section .text
    lea rax, [rel .str169]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    sub rsp, 32
    call ksk_error_count
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L170:
    cmp r12, r13
    jge .L171
section .data
.str173: db 32,32,97,116,32,108,105,110,101,32,0
section .text
    lea rax, [rel .str173]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ksk_error_line_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
section .data
.str174: db 32,32,32,0
section .text
    lea rax, [rel .str174]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ksk_error_mnem
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ksk_error_dst
    add rsp, 32
    mov rbx, rax
    cmp rbx, 99
    jne .L175
section .data
.str177: db 32,32,45,45,32,97,32,108,97,98,101,108,32,100,101,102,105,110,101,100,32,110,111,119,104,101,114,101,58,32,97,32,109,105,115,115,112,101,108,116,32,110,97,109,101,44,32,111,114,32,97,110,32,101,120,116,101,114,110,32,110,111,116,32
    db 100,101,99,108,97,114,101,100,0
section .text
    lea rax, [rel .str177]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    jmp .L176
.L175:
    cmp rbx, 98
    jne .L178
section .data
.str180: db 32,32,45,45,32,97,32,108,97,98,101,108,32,100,101,102,105,110,101,100,32,116,119,105,99,101,58,32,116,119,111,32,102,105,108,101,115,32,111,102,32,116,104,101,32,98,117,105,108,100,32,103,105,118,101,32,116,104,101,32,115,97,109,101
    db 32,110,97,109,101,0
section .text
    lea rax, [rel .str180]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    jmp .L179
.L178:
section .data
.str181: db 32,32,32,100,115,116,61,0
section .text
    lea rax, [rel .str181]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
section .data
.str182: db 32,115,114,99,61,0
section .text
    lea rax, [rel .str182]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call ksk_error_src
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mi_print_u64
    add rsp, 32
.L179:
.L176:
section .data
.str183: db 13,10,0
section .text
    lea rax, [rel .str183]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    add r12, 1
.L172:
    jmp .L170
.L171:
    mov rax, 1
    jmp .__ret_168
.__ret_168:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mx_assemble:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rax, [rel __g_main_out_A_OUT_TARGET]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    mov [rbp-8], rax
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_main_out_T_ARM64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L185
section .data
.str187: db 65,115,115,101,109,98,108,101,114,32,109,111,100,101,32,40,107,97,114,109,44,32,65,82,77,54,52,41,13,10,0
section .text
    lea rax, [rel .str187]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    jmp .L186
.L185:
section .data
.str188: db 65,115,115,101,109,98,108,101,114,32,109,111,100,101,32,40,107,97,115,109,41,13,10,0
section .text
    lea rax, [rel .str188]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
.L186:
    mov rax, [rel __g_main_out_A_SRC_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_main_out_A_INPUT]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_main_out_SRC_BUFFER_SIZE]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call read_file
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_main_out_A_SRC_SIZE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mx_p64
    add rsp, 32
    cmp rbx, 0
    jne .L189
section .data
.str191: db 69,82,82,79,82,58,32,99,97,110,110,111,116,32,114,101,97,100,32,116,104,101,32,102,105,108,101,46,13,10,0
section .text
    lea rax, [rel .str191]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 2
    jmp .__ret_184
    jmp .L190
.L189:
.L190:
    mov rax, [rel __g_main_out_A_EXP_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r15, rax
    mov rcx, r12
    mov rdx, rbx
    mov r8, r15
    sub rsp, 32
    call mp_preprocess
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_main_out_A_SRC_SIZE]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call mx_p64
    add rsp, 32
    mov rax, [rel __g_main_out_A_FLAG_S]
    push rax
    pop rcx
    sub rsp, 32
    call mx_flag
    add rsp, 32
    cmp rax, 0
    je .L192
section .data
.str194: db 112,114,101,112,114,111,99,46,97,115,109,0
section .text
    lea rax, [rel .str194]
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r14
    sub rsp, 32
    call write_file
    add rsp, 32
    jmp .L193
.L192:
.L193:
    mov rax, [rel __g_main_out_A_CODE_BUFFER]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rax, r13
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_main_out_T_ARM64]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L195
    mov rax, [rel __g_main_out_A_OUT_DYNAMIC]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mx_p8
    add rsp, 32
    sub rsp, 32
    call ew_set_layout
    add rsp, 32
    sub rsp, 32
    call kc_init
    add rsp, 32
    mov rcx, 0x400080
    sub rsp, 32
    call kc_set_base
    add rsp, 32
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call kc_assemble
    add rsp, 32
    cmp rax, 0
    jne .L197
    sub rsp, 32
    call mx_karm_error
    add rsp, 32
    jmp .__ret_184
    jmp .L198
.L197:
.L198:
    sub rsp, 32
    call kc_get_entry
    add rsp, 32
    cmp rax, 0
    jne .L199
section .data
.str201: db 69,82,82,79,82,58,32,110,111,32,95,115,116,97,114,116,32,108,97,98,101,108,13,10,32,32,104,105,110,116,58,32,97,110,32,65,82,77,54,52,32,76,105,110,117,120,32,112,114,111,103,114,97,109,32,115,116,97,114,116,115,32,97,116
    db 32,95,115,116,97,114,116,13,10,0
section .text
    lea rax, [rel .str201]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 1
    jmp .__ret_184
    jmp .L200
.L199:
.L200:
    mov rcx, r13
    sub rsp, 32
    call el_write_arm
    add rsp, 32
    mov rbx, rax
section .data
.str202: db 0
section .text
    lea rax, [rel .str202]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    jmp .L196
.L195:
    sub rsp, 32
    call ks_init
    add rsp, 32
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call ks_assemble
    add rsp, 32
    cmp rax, 0
    jne .L203
    sub rsp, 32
    call mx_kasm_error
    add rsp, 32
    jmp .__ret_184
    jmp .L204
.L203:
.L204:
    mov rcx, 2
    sub rsp, 32
    call mc_scan_flag
    add rsp, 32
    cmp rax, 0
    je .L205
    mov rcx, r13
    sub rsp, 32
    call pe_write
    add rsp, 32
    mov rbx, rax
section .data
.str207: db 46,101,120,101,0
section .text
    lea rax, [rel .str207]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    jmp .L206
.L205:
    mov rcx, 3
    sub rsp, 32
    call mc_scan_flag
    add rsp, 32
    cmp rax, 0
    je .L208
    sub rsp, 32
    call kw_init
    add rsp, 32
    sub rsp, 32
    call kw_build
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kw_get_image
    add rsp, 32
    mov r12, rax
section .data
.str210: db 46,107,114,110,0
section .text
    lea rax, [rel .str210]
    push rax
    pop rcx
    sub rsp, 32
    call mx_ext
    add rsp, 32
    jmp .L209
.L208:
    sub rsp, 32
    call ks_build_image
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call ksk_code
    add rsp, 32
    mov r12, rax
.L209:
.L206:
.L196:
    sub rsp, 32
    call mc_build_bin_name
    add rsp, 32
    mov rax, [rel __g_main_out_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call write_file
    add rsp, 32
    cmp rax, 0
    jne .L211
    sub rsp, 32
    call mx_write_error
    add rsp, 32
    jmp .__ret_184
    jmp .L212
.L211:
.L212:
section .data
.str213: db 66,121,116,101,115,32,119,114,105,116,116,101,110,58,32,0
section .text
    lea rax, [rel .str213]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call mx_say
    add rsp, 32
section .data
.str214: db 13,10,0
section .text
    lea rax, [rel .str214]
    push rax
    pop rcx
    sub rsp, 32
    call mx_say
    add rsp, 32
    mov rax, 0
    jmp .__ret_184
.__ret_184:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
