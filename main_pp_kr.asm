; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_main_pp_MP_SRC_SIZE: dq 16777216
section .text
section .data
__g_main_pp_MP_MAC_MAX: dq 32
section .text
section .data
__g_main_pp_MP_BODY_MAX: dq 16000
section .text
section .data
__g_main_pp_mp_in: dq 0
section .text
section .data
__g_main_pp_mp_end: dq 0
section .text
section .data
__g_main_pp_mp_out: dq 0
section .text
section .data
__g_main_pp_mp_out_end: dq 0
section .text
section .data
__g_main_pp_mp_depth: dq 0
section .text
section .bss
__g_main_pp_mp_name: resq 33
section .text
section .bss
__g_main_pp_mp_path: resq 41
section .text
section .data
__g_main_pp_mp_mac_count: dq 0
section .text
section .bss
__g_main_pp_mp_mac_names: resq 1024
section .text
section .data
__g_main_pp_mp_mac_names_len: dq 0
section .text
section .bss
__g_main_pp_mp_mac_name_off: resq 32
section .text
section .bss
__g_main_pp_mp_mac_body_off: resq 32
section .text
section .bss
__g_main_pp_mp_mac_body_len: resq 32
section .text
section .bss
__g_main_pp_mp_mac_bodies: resq 4096
section .text
section .data
__g_main_pp_mp_mac_bodies_len: dq 0
section .text
section .bss
__g_main_pp_mp_args: resq 1024
section .text
section .bss
__g_main_pp_mp_arg_off: resq 8
section .text
section .bss
__g_main_pp_mp_arg_len: resq 8
section .text
section .data
__g_main_pp_mp_argc: dq 0
section .text
mp_g8:
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
mp_p8:
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
mp_at:
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
mp_put:
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
mp_emit_range:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, rbx
    mov rbx, rax
.L5:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L8
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    mov rax, [rel __g_main_pp_mp_out_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L8
    mov rax, 1
    jmp .L9
.L8:
    mov rax, 0
.L9:
    test rax, rax
    jz .L6
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    add rax, 1
    mov [rel __g_main_pp_mp_out], rax
    add rbx, 1
.L7:
    jmp .L5
.L6:
    mov rax, 0
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mp_emit_cstr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rbx, rax
.L11:
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L14
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    mov rax, [rel __g_main_pp_mp_out_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L14
    mov rax, 1
    jmp .L15
.L14:
    mov rax, 0
.L15:
    test rax, rax
    jz .L12
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    add rax, 1
    mov [rel __g_main_pp_mp_out], rax
    add rbx, 1
.L13:
    jmp .L11
.L12:
    mov rax, 0
    jmp .__ret_10
.__ret_10:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mp_emit_nl:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    mov rax, [rel __g_main_pp_mp_out_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L17
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    pop rcx
    mov rdx, 10
    sub rsp, 32
    call mp_p8
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    add rax, 1
    mov [rel __g_main_pp_mp_out], rax
    jmp .L18
.L17:
.L18:
    mov rax, 0
    jmp .__ret_16
.__ret_16:
    mov rsp, rbp
    pop rbp
    ret
mp_skip:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, rbx
    mov rbx, rax
.L20:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L23
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L25
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L25
    mov rax, 0
    jmp .L26
.L25:
    mov rax, 1
.L26:
    test rax, rax
    jz .L23
    mov rax, 1
    jmp .L24
.L23:
    mov rax, 0
.L24:
    test rax, rax
    jz .L21
    add rbx, 1
.L22:
    jmp .L20
.L21:
    mov rax, rbx
    jmp .__ret_19
.__ret_19:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mp_starts:
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
.L28:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    cmp rax, 0
    je .L29
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L31
    mov rax, 0
    jmp .__ret_27
    jmp .L32
.L31:
.L32:
    add rbx, 1
.L30:
    jmp .L28
.L29:
    mov rax, 1
    jmp .__ret_27
.__ret_27:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mp_preprocess:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, rbx
    mov [rel __g_main_pp_mp_out], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_main_pp_MP_SRC_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, 64
    mov [rel __g_main_pp_mp_out_end], rax
    mov rax, 0
    mov [rel __g_main_pp_mp_mac_count], rax
    mov rax, 0
    mov [rel __g_main_pp_mp_mac_names_len], rax
    mov rax, 0
    mov [rel __g_main_pp_mp_mac_bodies_len], rax
    mov rax, 0
    mov [rel __g_main_pp_mp_depth], rax
    mov rax, r13
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_range
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    sub rax, rbx
    jmp .__ret_33
.__ret_33:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mp_range:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov [rel __g_main_pp_mp_in], rax
    mov rax, rbx
    mov [rel __g_main_pp_mp_end], rax
.L35:
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L36
    mov rax, [rel __g_main_pp_mp_in]
    mov r12, rax
.L38:
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L41
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L41
    mov rax, 1
    jmp .L42
.L41:
    mov rax, 0
.L42:
    test rax, rax
    jz .L39
    mov rax, [rel __g_main_pp_mp_in]
    add rax, 1
    mov [rel __g_main_pp_mp_in], rax
.L40:
    jmp .L38
.L39:
    mov rax, [rel __g_main_pp_mp_in]
    mov rbx, rax
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L43
    mov rax, [rel __g_main_pp_mp_in]
    add rax, 1
    mov [rel __g_main_pp_mp_in], rax
    jmp .L44
.L43:
.L44:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call mp_line
    add rsp, 32
.L37:
    jmp .L35
.L36:
    mov rax, 0
    jmp .__ret_34
.__ret_34:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mp_line:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call mp_skip
    add rsp, 32
    mov rbx, rax
    cmp rbx, r12
    jge .L46
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    cmp rax, 37
    jne .L48
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call mp_directive
    add rsp, 32
    jmp .__ret_45
    jmp .L49
.L48:
.L49:
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call mp_try_macro
    add rsp, 32
    cmp rax, 0
    je .L50
    mov rax, 0
    jmp .__ret_45
    jmp .L51
.L50:
.L51:
    jmp .L47
.L46:
.L47:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call mp_emit_range
    add rsp, 32
    sub rsp, 32
    call mp_emit_nl
    add rsp, 32
    jmp .__ret_45
.__ret_45:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mp_directive:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rax, rbx
    add rax, 1
    push rax
section .data
.str55: db 105,110,99,108,117,100,101,0
section .text
    lea rax, [rel .str55]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_starts
    add rsp, 32
    cmp rax, 0
    je .L53
    mov rax, rbx
    add rax, 8
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mp_include
    add rsp, 32
    jmp .__ret_52
    jmp .L54
.L53:
.L54:
    mov rax, rbx
    add rax, 1
    push rax
section .data
.str58: db 100,101,102,105,110,101,0
section .text
    lea rax, [rel .str58]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_starts
    add rsp, 32
    cmp rax, 0
    je .L56
    mov rax, rbx
    add rax, 7
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mp_skip
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rbx, rax
.L59:
    mov rax, r12
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L64
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    setne al
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
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L62
    mov rax, 1
    jmp .L63
.L62:
    mov rax, 0
.L63:
    test rax, rax
    jz .L60
    add r12, 1
.L61:
    jmp .L59
.L60:
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call mp_emit_range
    add rsp, 32
section .data
.str66: db 32,101,113,117,32,0
section .text
    lea rax, [rel .str66]
    push rax
    pop rcx
    sub rsp, 32
    call mp_emit_cstr
    add rsp, 32
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call mp_skip
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mp_emit_range
    add rsp, 32
    sub rsp, 32
    call mp_emit_nl
    add rsp, 32
    jmp .__ret_52
    jmp .L57
.L56:
.L57:
    mov rax, rbx
    add rax, 1
    push rax
section .data
.str69: db 109,97,99,114,111,0
section .text
    lea rax, [rel .str69]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_starts
    add rsp, 32
    cmp rax, 0
    je .L67
    mov rax, rbx
    add rax, 6
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mp_skip
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mp_record_macro
    add rsp, 32
    jmp .__ret_52
    jmp .L68
.L67:
.L68:
    mov rax, 0
    jmp .__ret_52
.__ret_52:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mp_include:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov [rbp-128], r15
    mov rbx, rcx
    mov r13, rdx
    mov rax, rbx
    mov r12, rax
.L71:
    mov rax, r12
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L74
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L74
    mov rax, 1
    jmp .L75
.L74:
    mov rax, 0
.L75:
    test rax, rax
    jz .L72
    add r12, 1
.L73:
    jmp .L71
.L72:
    cmp r12, r13
    jl .L76
    mov rax, 0
    jmp .__ret_70
    jmp .L77
.L76:
.L77:
    add r12, 1
    lea rax, [rel __g_main_pp_mp_name]
    mov r15, rax
    mov rax, 0
    mov rbx, rax
.L78:
    mov rax, r12
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L83
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 34
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L83
    mov rax, 1
    jmp .L84
.L83:
    mov rax, 0
.L84:
    test rax, rax
    jz .L81
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L81
    mov rax, 1
    jmp .L82
.L81:
    mov rax, 0
.L82:
    test rax, rax
    jz .L79
    mov rax, r15
    add rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    add rbx, 1
    add r12, 1
.L80:
    jmp .L78
.L79:
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mp_p8
    add rsp, 32
    lea rax, [rel __g_main_pp_mp_path]
    mov r13, rax
section .data
.str85: db 105,110,99,108,117,100,101,92,0
section .text
    lea rax, [rel .str85]
    mov rbx, rax
    mov rax, 0
    mov r14, rax
.L86:
    mov rax, rbx
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    cmp rax, 0
    je .L87
    mov rax, r13
    add rax, r14
    push rax
    mov rax, rbx
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    add r14, 1
.L88:
    jmp .L86
.L87:
    mov rax, 0
    mov r12, rax
.L89:
    mov rax, 1
    test rax, rax
    jz .L90
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, r14
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    cmp rbx, 0
    jne .L92
    jmp .L90
    jmp .L93
.L92:
.L93:
    add r14, 1
    add r12, 1
.L91:
    jmp .L89
.L90:
    mov rcx, 0
    sub rsp, 32
    call pp_buffer
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_main_pp_mp_depth]
    cmp rax, 0
    je .L94
    mov rcx, 1
    sub rsp, 32
    call pp_buffer
    add rsp, 32
    mov r14, rax
    jmp .L95
.L94:
.L95:
    mov rax, r13
    push rax
    mov rax, r14
    push rax
    mov rax, [rel __g_main_pp_MP_SRC_SIZE]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call read_file
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L96
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    mov rax, [rel __g_main_pp_MP_SRC_SIZE]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call read_file
    add rsp, 32
    mov r13, rax
    jmp .L97
.L96:
.L97:
    cmp r13, 0
    jne .L98
    mov rax, 0
    jmp .__ret_70
    jmp .L99
.L98:
.L99:
    mov rax, [rel __g_main_pp_mp_in]
    mov r12, rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rbx, rax
    mov rax, [rel __g_main_pp_mp_depth]
    add rax, 1
    mov [rel __g_main_pp_mp_depth], rax
    mov rax, r14
    push rax
    mov rax, r14
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_range
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_depth]
    sub rax, 1
    mov [rel __g_main_pp_mp_depth], rax
    mov rax, r12
    mov [rel __g_main_pp_mp_in], rax
    mov rax, rbx
    mov [rel __g_main_pp_mp_end], rax
    mov rax, 0
    jmp .__ret_70
.__ret_70:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
mp_macro_known:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
.L101:
    mov rax, 1
    test rax, rax
    jz .L102
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L112
    mov rax, rbx
    mov rcx, 9
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
    jnz .L110
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L110
    mov rax, 0
    jmp .L111
.L110:
    mov rax, 1
.L111:
    test rax, rax
    jnz .L108
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L108
    mov rax, 0
    jmp .L109
.L108:
    mov rax, 1
.L109:
    test rax, rax
    jnz .L106
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L106
    mov rax, 0
    jmp .L107
.L106:
    mov rax, 1
.L107:
    test rax, rax
    jz .L104
    jmp .L102
    jmp .L105
.L104:
.L105:
    add r12, 1
.L103:
    jmp .L101
.L102:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call mp_find
    add rsp, 32
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L114
    mov rax, 0
    jmp .__ret_100
    jmp .L115
.L114:
.L115:
    mov rax, 1
    jmp .__ret_100
.__ret_100:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mp_find:
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
.L117:
    mov rax, r13
    push rax
    mov rax, [rel __g_main_pp_mp_mac_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L118
    lea rax, [rel __g_main_pp_mp_mac_names]
    push rax
    lea rax, [rel __g_main_pp_mp_mac_name_off]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mp_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L120:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L123
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
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
    add rbx, 1
.L122:
    jmp .L120
.L121:
    mov rax, rbx
    mov rcx, r14
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L127
    mov rax, r12
    add rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L127
    mov rax, 1
    jmp .L128
.L127:
    mov rax, 0
.L128:
    test rax, rax
    jz .L125
    mov rax, r13
    jmp .__ret_116
    jmp .L126
.L125:
.L126:
    add r13, 1
.L119:
    jmp .L117
.L118:
    mov rax, 1
    neg rax
    jmp .__ret_116
.__ret_116:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
mp_record_macro:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov [rbp-128], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov rax, 0
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
    call mp_macro_known
    add rsp, 32
    cmp rax, 0
    je .L130
    mov rax, 1
    mov r15, rax
    jmp .L131
.L130:
.L131:
    mov rax, [rel __g_main_pp_mp_mac_count]
    mov r14, rax
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L134
    mov rax, r14
    push rax
    mov rax, [rel __g_main_pp_MP_MAC_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
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
    lea rax, [rel __g_main_pp_mp_mac_name_off]
    push rax
    mov rax, r14
    push rax
    mov rax, [rel __g_main_pp_mp_mac_names_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_put
    add rsp, 32
    lea rax, [rel __g_main_pp_mp_mac_names]
    push rax
    mov rax, [rel __g_main_pp_mp_mac_names_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L136:
    mov rax, r12
    mov rcx, [rbp-16]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L143
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L143
    mov rax, 1
    jmp .L144
.L143:
    mov rax, 0
.L144:
    test rax, rax
    jz .L141
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L141
    mov rax, 1
    jmp .L142
.L141:
    mov rax, 0
.L142:
    test rax, rax
    jz .L139
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 13
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L139
    mov rax, 1
    jmp .L140
.L139:
    mov rax, 0
.L140:
    test rax, rax
    jz .L137
    mov rax, r13
    add rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    add rbx, 1
    add r12, 1
.L138:
    jmp .L136
.L137:
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mp_p8
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_mac_names_len]
    add rax, rbx
    add rax, 1
    mov [rel __g_main_pp_mp_mac_names_len], rax
    lea rax, [rel __g_main_pp_mp_mac_body_off]
    push rax
    mov rax, r14
    push rax
    mov rax, [rel __g_main_pp_mp_mac_bodies_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_put
    add rsp, 32
    jmp .L133
.L132:
.L133:
    lea rax, [rel __g_main_pp_mp_mac_bodies]
    push rax
    mov rax, [rel __g_main_pp_mp_mac_bodies_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-64], rax
    mov rax, 0
    mov r13, rax
.L145:
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L146
    mov rax, [rel __g_main_pp_mp_in]
    mov [rbp-80], rax
.L148:
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L151
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L151
    mov rax, 1
    jmp .L152
.L151:
    mov rax, 0
.L152:
    test rax, rax
    jz .L149
    mov rax, [rel __g_main_pp_mp_in]
    add rax, 1
    mov [rel __g_main_pp_mp_in], rax
.L150:
    jmp .L148
.L149:
    mov rax, [rel __g_main_pp_mp_in]
    mov r12, rax
    mov rax, [rel __g_main_pp_mp_in]
    push rax
    mov rax, [rel __g_main_pp_mp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L153
    mov rax, [rel __g_main_pp_mp_in]
    add rax, 1
    mov [rel __g_main_pp_mp_in], rax
    jmp .L154
.L153:
.L154:
    mov rax, [rbp-80]
    mov rbx, rax
.L155:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L158
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L160
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L160
    mov rax, 0
    jmp .L161
.L160:
    mov rax, 1
.L161:
    test rax, rax
    jz .L158
    mov rax, 1
    jmp .L159
.L158:
    mov rax, 0
.L159:
    test rax, rax
    jz .L156
    add rbx, 1
.L157:
    jmp .L155
.L156:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L164
    mov rax, rbx
    push rax
section .data
.str166: db 37,101,110,100,109,97,99,114,111,0
section .text
    lea rax, [rel .str166]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_starts
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L164
    mov rax, 1
    jmp .L165
.L164:
    mov rax, 0
.L165:
    test rax, rax
    jz .L162
    jmp .L146
    jmp .L163
.L162:
.L163:
    mov rax, [rbp-80]
    mov rbx, rax
.L167:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L170
    mov rax, r13
    push rax
    mov rax, [rel __g_main_pp_MP_BODY_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L170
    mov rax, 1
    jmp .L171
.L170:
    mov rax, 0
.L171:
    test rax, rax
    jz .L168
    mov rax, [rbp-64]
    add rax, r13
    push rax
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    add r13, 1
    add rbx, 1
.L169:
    jmp .L167
.L168:
    mov rax, [rbp-64]
    add rax, r13
    push rax
    pop rcx
    mov rdx, 10
    sub rsp, 32
    call mp_p8
    add rsp, 32
    add r13, 1
.L147:
    jmp .L145
.L146:
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L174
    mov rax, r14
    push rax
    mov rax, [rel __g_main_pp_MP_MAC_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L174
    mov rax, 0
    jmp .L175
.L174:
    mov rax, 1
.L175:
    test rax, rax
    jz .L172
    mov rax, 0
    jmp .__ret_129
    jmp .L173
.L172:
.L173:
    lea rax, [rel __g_main_pp_mp_mac_body_len]
    push rax
    pop rcx
    mov rdx, r14
    mov r8, r13
    sub rsp, 32
    call mp_put
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_mac_bodies_len]
    add rax, r13
    mov [rel __g_main_pp_mp_mac_bodies_len], rax
    mov rax, r14
    add rax, 1
    mov [rel __g_main_pp_mp_mac_count], rax
    mov rax, 0
    jmp .__ret_129
.__ret_129:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
mp_try_macro:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov r12, rcx
    mov r15, rdx
    mov rax, r12
    mov rbx, rax
.L177:
    mov rax, rbx
    mov rcx, r15
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L184
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L184
    mov rax, 1
    jmp .L185
.L184:
    mov rax, 0
.L185:
    test rax, rax
    jz .L182
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L182
    mov rax, 1
    jmp .L183
.L182:
    mov rax, 0
.L183:
    test rax, rax
    jz .L180
    mov rcx, rbx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 13
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L180
    mov rax, 1
    jmp .L181
.L180:
    mov rax, 0
.L181:
    test rax, rax
    jz .L178
    add rbx, 1
.L179:
    jmp .L177
.L178:
    mov rax, r12
    push rax
    mov rax, rbx
    sub rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_find
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L186
    mov rax, 0
    jmp .__ret_176
    jmp .L187
.L186:
.L187:
    mov rax, 0
    mov [rel __g_main_pp_mp_argc], rax
    mov rcx, rbx
    mov rdx, r15
    sub rsp, 32
    call mp_skip
    add rsp, 32
    mov r14, rax
.L188:
    mov rax, r14
    mov rcx, r15
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L191
    mov rax, [rel __g_main_pp_mp_argc]
    mov rcx, 8
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L191
    mov rax, 1
    jmp .L192
.L191:
    mov rax, 0
.L192:
    test rax, rax
    jz .L189
    mov rax, r14
    mov [rbp-48], rax
.L193:
    mov rax, r14
    mov rcx, r15
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L198
    mov rcx, r14
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 44
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L198
    mov rax, 1
    jmp .L199
.L198:
    mov rax, 0
.L199:
    test rax, rax
    jz .L196
    mov rcx, r14
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 13
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L196
    mov rax, 1
    jmp .L197
.L196:
    mov rax, 0
.L197:
    test rax, rax
    jz .L194
    add r14, 1
.L195:
    jmp .L193
.L194:
    mov rax, r14
    mov r13, rax
.L200:
    mov rax, r13
    mov rcx, [rbp-48]
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L203
    mov rax, r13
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L205
    mov rax, r13
    sub rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L205
    mov rax, 0
    jmp .L206
.L205:
    mov rax, 1
.L206:
    test rax, rax
    jz .L203
    mov rax, 1
    jmp .L204
.L203:
    mov rax, 0
.L204:
    test rax, rax
    jz .L201
    sub r13, 1
.L202:
    jmp .L200
.L201:
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_main_pp_mp_argc]
    cmp rax, 0
    jle .L207
    lea rax, [rel __g_main_pp_mp_arg_off]
    push rax
    mov rax, [rel __g_main_pp_mp_argc]
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_at
    add rsp, 32
    push rax
    lea rax, [rel __g_main_pp_mp_arg_len]
    push rax
    mov rax, [rel __g_main_pp_mp_argc]
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L208
.L207:
.L208:
    lea rax, [rel __g_main_pp_mp_arg_off]
    push rax
    mov rax, [rel __g_main_pp_mp_argc]
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
    call mp_put
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L209:
    mov rax, [rbp-48]
    add rax, rbx
    cmp rax, r13
    jge .L210
    lea rax, [rel __g_main_pp_mp_args]
    add rax, r12
    add rax, rbx
    push rax
    mov rax, [rbp-48]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    add rbx, 1
.L211:
    jmp .L209
.L210:
    lea rax, [rel __g_main_pp_mp_arg_len]
    push rax
    mov rax, [rel __g_main_pp_mp_argc]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call mp_put
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_argc]
    add rax, 1
    mov [rel __g_main_pp_mp_argc], rax
    cmp r14, r15
    jl .L212
    jmp .L189
    jmp .L213
.L212:
.L213:
    mov rax, r14
    add rax, 1
    push rax
    pop rcx
    mov rdx, r15
    sub rsp, 32
    call mp_skip
    add rsp, 32
    mov r14, rax
.L190:
    jmp .L188
.L189:
    lea rax, [rel __g_main_pp_mp_mac_bodies]
    push rax
    lea rax, [rel __g_main_pp_mp_mac_body_off]
    push rax
    pop rcx
    mov rdx, [rbp-32]
    sub rsp, 32
    call mp_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    lea rax, [rel __g_main_pp_mp_mac_body_len]
    push rax
    pop rcx
    mov rdx, [rbp-32]
    sub rsp, 32
    call mp_at
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r13, rax
.L214:
    cmp r13, r15
    jge .L215
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 37
    jne .L217
    add r13, 1
    cmp r13, r15
    jl .L219
    mov rax, 1
    jmp .__ret_176
    jmp .L220
.L219:
.L220:
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    sub rax, 49
    mov r12, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L223
    mov rax, r12
    mov rcx, 8
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L223
    mov rax, 1
    jmp .L224
.L223:
    mov rax, 0
.L224:
    test rax, rax
    jz .L221
    mov rax, r12
    push rax
    mov rax, [rel __g_main_pp_mp_argc]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L225
    lea rax, [rel __g_main_pp_mp_args]
    push rax
    lea rax, [rel __g_main_pp_mp_arg_off]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mp_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, rbx
    push rax
    lea rax, [rel __g_main_pp_mp_arg_len]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call mp_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_emit_range
    add rsp, 32
    jmp .L226
.L225:
.L226:
    add r13, 1
    jmp .L216
    jmp .L222
.L221:
.L222:
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    pop rcx
    mov rdx, 37
    sub rsp, 32
    call mp_p8
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    add rax, 1
    mov [rel __g_main_pp_mp_out], rax
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call mp_g8
    add rsp, 32
    mov rbx, rax
    jmp .L218
.L217:
.L218:
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    mov rax, [rel __g_main_pp_mp_out_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L227
    mov rax, 1
    jmp .__ret_176
    jmp .L228
.L227:
.L228:
    mov rax, [rel __g_main_pp_mp_out]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mp_p8
    add rsp, 32
    mov rax, [rel __g_main_pp_mp_out]
    add rax, 1
    mov [rel __g_main_pp_mp_out], rax
    add r13, 1
.L216:
    jmp .L214
.L215:
    mov rax, 1
    jmp .__ret_176
.__ret_176:
    mov rbx, [rbp-176]
    mov r12, [rbp-168]
    mov r13, [rbp-160]
    mov r14, [rbp-152]
    mov r15, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
