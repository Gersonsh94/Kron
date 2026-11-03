; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_karm_mem_kq_tok: dq 0
section .text
kq_g8:
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
kq_range_word:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_1
.__ret_1:
    mov rsp, rbp
    pop rbp
    ret
kq_ldst:
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
    mov r14, r8
    mov [rbp-32], r9
    mov rcx, 1
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kq_g8
    add rsp, 32
    cmp rax, 91
    je .L3
    mov rcx, [rbp-8]
    mov rdx, r14
    mov r8, rbx
    sub rsp, 32
    call kq_literal
    add rsp, 32
    jmp .__ret_2
    jmp .L4
.L3:
.L4:
    mov rcx, rbx
    sub rsp, 32
    call kc_mem
    add rsp, 32
    cmp rax, 0
    jne .L5
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_2
    jmp .L6
.L5:
.L6:
    sub rsp, 32
    call kc_mbase
    add rsp, 32
    mov [rbp-48], rax
    sub rsp, 32
    call kc_nops
    add rsp, 32
    mov rbx, rax
    mov rax, [rbp-8]
    mov rcx, 0xFEFFFFFF
    and rax, rcx
    mov r13, rax
    mov rax, 0
    mov r12, rax
    cmp rbx, 3
    jne .L7
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    cmp rax, 0
    je .L9
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_2
    jmp .L10
.L9:
.L10:
    mov rcx, 2
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L11
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_2
    jmp .L12
.L11:
.L12:
    mov rax, rbx
    push rax
    mov rax, 256
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L15
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    setg al
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
    sub rsp, 32
    call kq_range_word
    add rsp, 32
    jmp .__ret_2
    jmp .L14
.L13:
.L14:
    mov rax, rbx
    and rax, 511
    shl rax, 12
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    or rax, 1024
    mov r12, rax
    jmp .L8
.L7:
    cmp rbx, 2
    je .L17
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_2
    jmp .L18
.L17:
.L18:
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    cmp rax, 2
    jne .L19
    mov rcx, r13
    mov rdx, r15
    mov r8, r14
    mov r9, [rbp-48]
    sub rsp, 32
    call kq_ldst_reg
    add rsp, 32
    jmp .__ret_2
    jmp .L20
.L19:
.L20:
    sub rsp, 32
    call kc_mimm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_mpre
    add rsp, 32
    cmp rax, 0
    je .L21
    mov rax, rbx
    push rax
    mov rax, 256
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L25
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    setg al
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
    sub rsp, 32
    call kq_range_word
    add rsp, 32
    jmp .__ret_2
    jmp .L24
.L23:
.L24:
    mov rax, rbx
    and rax, 511
    shl rax, 12
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    or rax, 3072
    mov r12, rax
    jmp .L22
.L21:
    mov rax, 0
    mov [rbp-96], rax
    mov rax, [rbp-32]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L29
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setge al
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
    mov rax, 1
    mov rcx, r15
    shl rax, cl
    sub rax, 1
    mov rcx, rax
    mov rax, rbx
    and rax, rcx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L33
    mov rax, rbx
    mov rcx, r15
    sar rax, cl
    mov rcx, 4095
    cmp rax, rcx
    setle al
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
    mov rax, rbx
    mov rcx, r15
    sar rax, cl
    shl rax, 10
    mov rcx, rax
    mov rax, [rbp-8]
    or rax, rcx
    mov r12, rax
    mov rax, 1
    mov [rbp-96], rax
    jmp .L32
.L31:
.L32:
    jmp .L28
.L27:
.L28:
    mov rax, [rbp-96]
    cmp rax, 0
    jne .L35
    mov rax, rbx
    push rax
    mov rax, 256
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L39
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L39
    mov rax, 0
    jmp .L40
.L39:
    mov rax, 1
.L40:
    test rax, rax
    jz .L37
    sub rsp, 32
    call kq_range_word
    add rsp, 32
    jmp .__ret_2
    jmp .L38
.L37:
.L38:
    mov rax, rbx
    and rax, 511
    shl rax, 12
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    mov r12, rax
    jmp .L36
.L35:
.L36:
.L22:
.L8:
    mov rax, [rbp-48]
    and rax, 31
    shl rax, 5
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    push rax
    mov rax, r14
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
kq_ldst_reg:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov r15, r8
    mov r14, r9
    mov rax, rbx
    mov rcx, 0x00200800
    or rax, rcx
    mov r13, rax
    sub rsp, 32
    call kc_mext
    add rsp, 32
    mov r12, rax
    mov rax, 3
    mov rbx, rax
    cmp r12, 1
    jne .L42
    mov rax, 6
    mov rbx, rax
    jmp .L43
.L42:
    cmp r12, 2
    jne .L44
    mov rax, 2
    mov rbx, rax
    jmp .L45
.L44:
    cmp r12, 3
    jne .L46
    mov rax, 7
    mov rbx, rax
    jmp .L47
.L46:
.L47:
.L45:
.L43:
    mov rax, rbx
    shl rax, 13
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    mov r13, rax
    sub rsp, 32
    call kc_mamt
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L50
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L50
    mov rax, 1
    jmp .L51
.L50:
    mov rax, 0
.L51:
    test rax, rax
    jz .L48
    mov rax, rbx
    mov rcx, [rbp-16]
    cmp rax, rcx
    je .L52
    sub rsp, 32
    call kq_range_word
    add rsp, 32
    jmp .__ret_41
    jmp .L53
.L52:
.L53:
    or r13, 4096
    jmp .L49
.L48:
.L49:
    mov rax, r13
    push rax
    sub rsp, 32
    call kc_midx
    add rsp, 32
    and rax, 31
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r13, rax
    mov rax, r14
    and rax, 31
    shl rax, 5
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    push rax
    mov rax, r15
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_41
.__ret_41:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
kq_literal:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r14, rcx
    mov r13, rdx
    mov rbx, r8
    mov rax, r14
    mov rcx, 0x00400000
    and rax, rcx
    cmp rax, 0
    jne .L55
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_54
    jmp .L56
.L55:
.L56:
    sub rsp, 32
    call kc_clear_unres
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L57
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_54
    jmp .L58
.L57:
.L58:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_pc
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    and rax, 3
    cmp rax, 0
    jne .L59
    mov rax, r12
    sar rax, 2
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 262144
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L63
    mov rax, r12
    mov rcx, 262143
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L63
    mov rax, 1
    jmp .L64
.L63:
    mov rax, 0
.L64:
    test rax, rax
    jz .L61
    mov rax, 1
    mov rbx, rax
    jmp .L62
.L61:
.L62:
    jmp .L60
.L59:
.L60:
    cmp rbx, 0
    jne .L65
    sub rsp, 32
    call kc_pass
    add rsp, 32
    cmp rax, 2
    jne .L67
    mov rcx, 3
    sub rsp, 32
    call kc_err
    add rsp, 32
    jmp .L68
.L67:
.L68:
    mov rax, 0
    mov r12, rax
    jmp .L66
.L65:
.L66:
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    mov rcx, 0xF9400000
    cmp rax, rcx
    jne .L69
    mov rax, 0x58000000
    mov rbx, rax
    jmp .L70
.L69:
    mov rax, r14
    mov rcx, 0xB9400000
    cmp rax, rcx
    jne .L71
    mov rax, 0x18000000
    mov rbx, rax
    jmp .L72
.L71:
    mov rax, r14
    mov rcx, 0xFD400000
    cmp rax, rcx
    jne .L73
    mov rax, 0x5C000000
    mov rbx, rax
    jmp .L74
.L73:
    mov rax, r14
    mov rcx, 0xBD400000
    cmp rax, rcx
    jne .L75
    mov rax, 0x1C000000
    mov rbx, rax
    jmp .L76
.L75:
    mov rax, r14
    mov rcx, 0xB9800000
    cmp rax, rcx
    jne .L77
    mov rax, 0x98000000
    mov rbx, rax
    jmp .L78
.L77:
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_54
.L78:
.L76:
.L74:
.L72:
.L70:
    mov rax, r12
    and rax, 0x7FFFF
    shl rax, 5
    mov rcx, rax
    mov rax, rbx
    or rax, rcx
    or rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_54
.__ret_54:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
kq_ldstr:
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
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r14, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r14, 1
    jne .L80
    mov rax, 0xF9000000
    mov r12, rax
    mov rax, 3
    mov rbx, rax
    jmp .L81
.L80:
    cmp r14, 2
    jne .L82
    mov rax, 0xB9000000
    mov r12, rax
    mov rax, 2
    mov rbx, rax
    jmp .L83
.L82:
    cmp r14, 3
    jne .L84
    mov rax, 0xFD000000
    mov r12, rax
    mov rax, 3
    mov rbx, rax
    jmp .L85
.L84:
    cmp r14, 4
    jne .L86
    mov rax, 0xBD000000
    mov r12, rax
    mov rax, 2
    mov rbx, rax
    jmp .L87
.L86:
    cmp r14, 6
    jne .L88
    mov rax, 0x3D800000
    mov r12, rax
    mov rax, 4
    mov rbx, rax
    jmp .L89
.L88:
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_79
.L89:
.L87:
.L85:
.L83:
.L81:
    mov rax, [rbp-8]
    cmp rax, 0
    je .L90
    mov rax, r12
    mov rcx, 0x00400000
    or rax, rcx
    mov r12, rax
    jmp .L91
.L90:
.L91:
    mov rcx, r12
    mov rdx, rbx
    mov r8, r13
    mov r9, r15
    sub rsp, 32
    call kq_ldst
    add rsp, 32
    jmp .__ret_79
.__ret_79:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kq_ldsz:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 2
    je .L93
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_92
    jmp .L94
.L93:
.L94:
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, rbx
    sub rsp, 32
    call kq_ldst
    add rsp, 32
    jmp .__ret_92
.__ret_92:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_ldsx:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    cmp r12, 1
    jne .L96
    mov rcx, r14
    mov rdx, r13
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call kq_ldst
    add rsp, 32
    jmp .__ret_95
    jmp .L97
.L96:
.L97:
    cmp r12, 2
    je .L98
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_95
    jmp .L99
.L98:
.L99:
    mov rax, r14
    mov rcx, 0x00400000
    or rax, rcx
    push rax
    pop rcx
    mov rdx, r13
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call kq_ldst
    add rsp, 32
    jmp .__ret_95
.__ret_95:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kq_ldrsw:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 1
    je .L101
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_100
    jmp .L102
.L101:
.L102:
    mov rax, 0xB9800000
    push rax
    mov rax, 2
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 0
    sub rsp, 32
    call kq_ldst
    add rsp, 32
    jmp .__ret_100
.__ret_100:
    mov rsp, rbp
    pop rbp
    ret
kq_pair:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rbx, rcx
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 3
    mov r13, rax
    cmp r12, 2
    jne .L104
    mov rax, 0x29000000
    mov r14, rax
    mov rax, 2
    mov r13, rax
    jmp .L105
.L104:
    cmp r12, 1
    jne .L106
    mov rax, 0xA9000000
    mov r14, rax
    jmp .L107
.L106:
    cmp r12, 3
    jne .L108
    mov rax, 0x6D000000
    mov r14, rax
    jmp .L109
.L108:
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
.L109:
.L107:
.L105:
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r12
    je .L110
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
    jmp .L111
.L110:
.L111:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    cmp rbx, 0
    je .L112
    mov rax, r14
    mov rcx, 0x00400000
    or rax, rcx
    mov r14, rax
    jmp .L113
.L112:
.L113:
    mov rcx, 2
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_mem
    add rsp, 32
    cmp rax, 0
    jne .L114
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
    jmp .L115
.L114:
.L115:
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    cmp rax, 2
    jne .L116
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
    jmp .L117
.L116:
.L117:
    sub rsp, 32
    call kc_mimm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_nops
    add rsp, 32
    cmp rax, 4
    jne .L118
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    cmp rax, 0
    je .L120
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
    jmp .L121
.L120:
.L121:
    mov rcx, 3
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L122
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
    jmp .L123
.L122:
.L123:
    mov rax, r14
    mov rcx, 0xFE7FFFFF
    and rax, rcx
    mov rcx, 0x00800000
    or rax, rcx
    mov r14, rax
    jmp .L119
.L118:
    sub rsp, 32
    call kc_nops
    add rsp, 32
    cmp rax, 3
    je .L124
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_103
    jmp .L125
.L124:
.L125:
    sub rsp, 32
    call kc_mpre
    add rsp, 32
    cmp rax, 0
    je .L126
    mov rax, r14
    mov rcx, 0x01800000
    or rax, rcx
    mov r14, rax
    jmp .L127
.L126:
.L127:
.L119:
    mov rax, 1
    mov rcx, r13
    shl rax, cl
    sub rax, 1
    mov rcx, rax
    mov rax, rbx
    and rax, rcx
    cmp rax, 0
    je .L128
    sub rsp, 32
    call kq_range_word
    add rsp, 32
    jmp .__ret_103
    jmp .L129
.L128:
.L129:
    mov rax, rbx
    mov rcx, r13
    sar rax, cl
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 64
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L132
    mov rax, rbx
    mov rcx, 63
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L132
    mov rax, 0
    jmp .L133
.L132:
    mov rax, 1
.L133:
    test rax, rax
    jz .L130
    sub rsp, 32
    call kq_range_word
    add rsp, 32
    jmp .__ret_103
    jmp .L131
.L130:
.L131:
    mov rax, rbx
    and rax, 127
    shl rax, 15
    mov rcx, rax
    mov rax, r14
    or rax, rcx
    push rax
    mov rax, r12
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    sub rsp, 32
    call kc_mbase
    add rsp, 32
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r15
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_103
.__ret_103:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
kq_ldex:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L135
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_134
    jmp .L136
.L135:
.L136:
    mov rax, rbx
    mov r13, rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    cmp r12, 2
    jne .L137
    mov rax, r13
    mov rcx, 0xBFFFFFFF
    and rax, rcx
    mov r13, rax
    jmp .L138
.L137:
    cmp r12, 1
    je .L139
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_134
    jmp .L140
.L139:
.L140:
.L138:
    mov rcx, 1
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_mem
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L143
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L143
    mov rax, 0
    jmp .L144
.L143:
    mov rax, 1
.L144:
    test rax, rax
    jz .L141
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_134
    jmp .L142
.L141:
.L142:
    mov rax, r13
    push rax
    sub rsp, 32
    call kc_mbase
    add rsp, 32
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_134
.__ret_134:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_stex:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rcx, 3
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L146
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_145
    jmp .L147
.L146:
.L147:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 2
    je .L148
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_145
    jmp .L149
.L148:
.L149:
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    cmp r12, 2
    jne .L150
    mov rax, r13
    mov rcx, 0xBFFFFFFF
    and rax, rcx
    mov r13, rax
    jmp .L151
.L150:
    cmp r12, 1
    je .L152
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_145
    jmp .L153
.L152:
.L153:
.L151:
    mov rcx, 2
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_mem
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L156
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L156
    mov rax, 0
    jmp .L157
.L156:
    mov rax, 1
.L157:
    test rax, rax
    jz .L154
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_145
    jmp .L155
.L154:
.L155:
    mov rax, r13
    push rax
    sub rsp, 32
    call kc_mbase
    add rsp, 32
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_145
.__ret_145:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_target:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_clear_unres
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rel __g_karm_mem_kq_tok], rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L159
    mov rax, 0
    jmp .__ret_158
    jmp .L160
.L159:
.L160:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    mov rax, 1
    mov [rel __g_karm_mem_kq_tok], rax
    sub rsp, 32
    call kc_unres
    add rsp, 32
    cmp rax, 0
    je .L161
    mov rax, 0
    jmp .__ret_158
    jmp .L162
.L161:
.L162:
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_pc
    add rsp, 32
    mov rcx, rax
    pop rax
    sub rax, rcx
    jmp .__ret_158
.__ret_158:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_b26:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, 1
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L164
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_163
    jmp .L165
.L164:
.L165:
    mov rcx, 0
    sub rsp, 32
    call kq_target
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_mem_kq_tok]
    cmp rax, 0
    jne .L166
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_163
    jmp .L167
.L166:
.L167:
    mov rax, rbx
    sar rax, 2
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 33554432
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L170
    mov rax, rbx
    mov rcx, 33554431
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L170
    mov rax, 0
    jmp .L171
.L170:
    mov rax, 1
.L171:
    test rax, rax
    jz .L168
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_163
    jmp .L169
.L168:
.L169:
    mov rax, rbx
    and rax, 0x3FFFFFF
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_163
.__ret_163:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kq_b19:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    sar rax, 2
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 262144
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L175
    mov rax, rbx
    mov rcx, 262143
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L175
    mov rax, 0
    jmp .L176
.L175:
    mov rax, 1
.L176:
    test rax, rax
    jz .L173
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_172
    jmp .L174
.L173:
.L174:
    mov rax, rbx
    and rax, 0x7FFFF
    shl rax, 5
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_172
.__ret_172:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kq_bcond:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    sub rsp, 32
    call kc_mnem
    add rsp, 32
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call kc_cond
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L178
    mov rcx, 1
    sub rsp, 32
    call kc_err2
    add rsp, 32
    jmp .__ret_177
    jmp .L179
.L178:
.L179:
    mov rcx, 0
    sub rsp, 32
    call kq_target
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_mem_kq_tok]
    cmp rax, 0
    jne .L180
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_177
    jmp .L181
.L180:
.L181:
    mov rax, 0x54000000
    or rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kq_b19
    add rsp, 32
    jmp .__ret_177
.__ret_177:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kq_cb:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L183
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_182
    jmp .L184
.L183:
.L184:
    mov rax, rbx
    mov r12, rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L185
    mov rax, r12
    mov rcx, 0x80000000
    or rax, rcx
    mov r12, rax
    jmp .L186
.L185:
    cmp rbx, 2
    je .L187
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_182
    jmp .L188
.L187:
.L188:
.L186:
    mov rax, r12
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kq_target
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_mem_kq_tok]
    cmp rax, 0
    jne .L189
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_182
    jmp .L190
.L189:
.L190:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call kq_b19
    add rsp, 32
    jmp .__ret_182
.__ret_182:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kq_breg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 1
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L192
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_191
    jmp .L193
.L192:
.L193:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 1
    je .L194
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_191
    jmp .L195
.L194:
.L195:
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_191
.__ret_191:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kq_ret:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call kc_nops
    add rsp, 32
    cmp rax, 0
    je .L197
    mov rcx, 0xD65F0000
    sub rsp, 32
    call kq_breg
    add rsp, 32
    jmp .__ret_196
    jmp .L198
.L197:
.L198:
    mov rcx, 0xD65F03C0
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_196
.__ret_196:
    mov rsp, rbp
    pop rbp
    ret
kq_adr_enc:
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
    and rax, 3
    shl rax, 29
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    push rax
    mov rax, r12
    sar rax, 2
    and rax, 0x7FFFF
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_199
.__ret_199:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_adr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L201
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_200
    jmp .L202
.L201:
.L202:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 1
    je .L203
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_200
    jmp .L204
.L203:
.L204:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kq_target
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_karm_mem_kq_tok]
    cmp rax, 0
    jne .L205
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_200
    jmp .L206
.L205:
.L206:
    mov rax, rbx
    push rax
    mov rax, 1048576
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L209
    mov rax, rbx
    mov rcx, 1048575
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L209
    mov rax, 0
    jmp .L210
.L209:
    mov rax, 1
.L210:
    test rax, rax
    jz .L207
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    jmp .L208
.L207:
.L208:
    mov rcx, 0x10000000
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call kq_adr_enc
    add rsp, 32
    jmp .__ret_200
.__ret_200:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kq_adrp_word:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, 1
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_clear_unres
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call kc_eval
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L212
    mov rax, 0
    jmp .__ret_211
    jmp .L213
.L212:
.L213:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    mov rax, r12
    shr rax, 12
    push rax
    sub rsp, 32
    call kc_pc
    add rsp, 32
    shr rax, 12
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rbx, rax
    sub rsp, 32
    call kc_unres
    add rsp, 32
    cmp rax, 0
    je .L214
    mov rax, 0
    mov rbx, rax
    jmp .L215
.L214:
.L215:
    mov rcx, 0x90000000
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call kq_adr_enc
    add rsp, 32
    mov rax, r12
    jmp .__ret_211
.__ret_211:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_adrp:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L217
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_216
    jmp .L218
.L217:
.L218:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 1
    je .L219
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_216
    jmp .L220
.L219:
.L220:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kq_adrp_word
    add rsp, 32
    mov rax, 0
    jmp .__ret_216
.__ret_216:
    mov rsp, rbp
    pop rbp
    ret
kq_adrl:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L222
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_221
    jmp .L223
.L222:
.L223:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 1
    je .L224
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_221
    jmp .L225
.L224:
.L225:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call kq_adrp_word
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    and rax, 4095
    shl rax, 10
    mov rcx, rax
    mov rax, 0x91000000
    or rax, rcx
    push rax
    mov rax, r12
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_221
.__ret_221:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kq_svc:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 0
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L227
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_226
    jmp .L228
.L227:
.L228:
    mov rax, rbx
    and rax, 65535
    shl rax, 5
    mov rcx, rax
    mov rax, 0xD4000001
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_226
.__ret_226:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kq_fmov:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L230
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_229
    jmp .L231
.L230:
.L231:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r15, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r14, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    mov rcx, 3
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L234
    mov rax, r13
    mov rcx, 3
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L234
    mov rax, 1
    jmp .L235
.L234:
    mov rax, 0
.L235:
    test rax, rax
    jz .L232
    mov rax, 0x1E604000
    mov rbx, rax
    jmp .L233
.L232:
    mov rax, r15
    mov rcx, 3
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L238
    mov rax, r13
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L238
    mov rax, 1
    jmp .L239
.L238:
    mov rax, 0
.L239:
    test rax, rax
    jz .L236
    mov rax, 0x9E670000
    mov rbx, rax
    jmp .L237
.L236:
    mov rax, r15
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L242
    mov rax, r13
    mov rcx, 3
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
    mov rax, 0x9E660000
    mov rbx, rax
    jmp .L241
.L240:
    mov rax, r15
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L246
    mov rax, r13
    mov rcx, 4
    cmp rax, rcx
    sete al
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
    mov rax, 0x1E204000
    mov rbx, rax
    jmp .L245
.L244:
    mov rax, r15
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L250
    mov rax, r13
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L250
    mov rax, 1
    jmp .L251
.L250:
    mov rax, 0
.L251:
    test rax, rax
    jz .L248
    mov rax, 0x1E270000
    mov rbx, rax
    jmp .L249
.L248:
    mov rax, r15
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L254
    mov rax, r13
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L254
    mov rax, 1
    jmp .L255
.L254:
    mov rax, 0
.L255:
    test rax, rax
    jz .L252
    mov rax, 0x1E260000
    mov rbx, rax
    jmp .L253
.L252:
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_229
.L253:
.L249:
.L245:
.L241:
.L237:
.L233:
    mov rcx, rbx
    mov rdx, r14
    mov r8, r12
    mov r9, 0
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_229
.__ret_229:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
kq_fop3:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rcx, 3
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L257
    mov rax, 0
    jmp .__ret_256
    jmp .L258
.L257:
.L258:
    mov rax, rbx
    mov r14, rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r13, rax
    cmp r13, 4
    jne .L259
    mov rax, r14
    mov rcx, 0xFFBFFFFF
    and rax, rcx
    mov r14, rax
    jmp .L260
.L259:
    cmp r13, 3
    je .L261
    mov rax, 0
    jmp .__ret_256
    jmp .L262
.L261:
.L262:
.L260:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L263
    mov rax, 0
    jmp .__ret_256
    jmp .L264
.L263:
.L264:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    mov rcx, 2
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L265
    mov rax, 0
    jmp .__ret_256
    jmp .L266
.L265:
.L266:
    mov rax, r14
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    mov rax, 1
    jmp .__ret_256
.__ret_256:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
kq_f3:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 9
    jne .L268
    mov rax, r13
    mov rcx, 0xFFBFFFFF
    and rax, rcx
    push rax
    pop rcx
    mov rdx, 9
    sub rsp, 32
    call ko_vec3
    add rsp, 32
    mov rbx, rax
    jmp .L269
.L268:
    cmp r12, 8
    jne .L270
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call ko_vec3
    add rsp, 32
    mov rbx, rax
    jmp .L271
.L270:
    mov rcx, r14
    sub rsp, 32
    call kq_fop3
    add rsp, 32
    mov rbx, rax
.L271:
.L269:
    cmp rbx, 0
    jne .L272
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_267
    jmp .L273
.L272:
.L273:
    mov rax, 0
    jmp .__ret_267
.__ret_267:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kq_f2:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L275
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_274
    jmp .L276
.L275:
.L276:
    mov rax, rbx
    mov r13, rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    cmp r12, 4
    jne .L277
    mov rax, r13
    mov rcx, 0xFFBFFFFF
    and rax, rcx
    mov r13, rax
    jmp .L278
.L277:
    cmp r12, 3
    je .L279
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_274
    jmp .L280
.L279:
.L280:
.L278:
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r12
    je .L281
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_274
    jmp .L282
.L281:
.L282:
    mov rax, r13
    push rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 0
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_274
.__ret_274:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
kq_fcmp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L284
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_283
    jmp .L285
.L284:
.L285:
    mov rax, 0x1E602000
    mov r14, rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r13, rax
    cmp r13, 4
    jne .L286
    mov rax, r14
    mov rcx, 0xFFBFFFFF
    and rax, rcx
    mov r14, rax
    jmp .L287
.L286:
    cmp r13, 3
    je .L288
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_283
    jmp .L289
.L288:
.L289:
.L287:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L290
    mov rax, r14
    or rax, 8
    push rax
    pop rcx
    mov rdx, 0
    mov r8, r12
    mov r9, 0
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_283
    jmp .L291
.L290:
.L291:
    cmp rbx, r13
    je .L292
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_283
    jmp .L293
.L292:
.L293:
    mov rax, r14
    push rax
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_283
.__ret_283:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kq_cvt:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L295
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_294
    jmp .L296
.L295:
.L296:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r15, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov [rbp-32], rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r14, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r13, rax
    mov rax, r14
    mov r12, rax
    mov rax, r15
    mov rbx, rax
    mov rax, [rbp-16]
    cmp rax, 0
    je .L297
    mov rax, r15
    mov r12, rax
    mov rax, r14
    mov rbx, rax
    jmp .L298
.L297:
.L298:
    mov rax, [rbp-8]
    mov r14, rax
    cmp r12, 3
    jne .L299
    mov rax, r14
    mov rcx, 0x00400000
    or rax, rcx
    mov r14, rax
    jmp .L300
.L299:
    cmp r12, 4
    je .L301
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_294
    jmp .L302
.L301:
.L302:
.L300:
    cmp rbx, 1
    jne .L303
    mov rax, r14
    mov rcx, 0x80000000
    or rax, rcx
    mov r14, rax
    jmp .L304
.L303:
    cmp rbx, 2
    je .L305
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_294
    jmp .L306
.L305:
.L306:
.L304:
    mov rcx, r14
    mov rdx, [rbp-32]
    mov r8, r13
    mov r9, 0
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_294
.__ret_294:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
kq_fcvt:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L308
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_307
    jmp .L309
.L308:
.L309:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r14, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    cmp r14, 3
    jne .L310
    cmp r12, 4
    je .L312
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_307
    jmp .L313
.L312:
.L313:
    mov rcx, 0x1E22C000
    mov rdx, r13
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_307
    jmp .L311
.L310:
.L311:
    mov rax, r14
    mov rcx, 4
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L316
    mov rax, r12
    mov rcx, 3
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L316
    mov rax, 0
    jmp .L317
.L316:
    mov rax, 1
.L317:
    test rax, rax
    jz .L314
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_307
    jmp .L315
.L314:
.L315:
    mov rcx, 0x1E624000
    mov rdx, r13
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call kc_rrr
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
kq_prfm:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L319
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_318
    jmp .L320
.L319:
.L320:
    mov rcx, 0
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
section .data
.str323: db 112,108,100,108,49,107,101,101,112,0
section .text
    lea rax, [rel .str323]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    jne .L321
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_318
    jmp .L322
.L321:
.L322:
    mov rcx, 1
    sub rsp, 32
    call kc_op
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call kq_g8
    add rsp, 32
    cmp rax, 91
    je .L324
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_318
    jmp .L325
.L324:
.L325:
    mov rcx, rbx
    sub rsp, 32
    call kc_mem
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L328
    sub rsp, 32
    call kc_mkind
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L328
    mov rax, 0
    jmp .L329
.L328:
    mov rax, 1
.L329:
    test rax, rax
    jz .L326
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_318
    jmp .L327
.L326:
.L327:
    sub rsp, 32
    call kc_mimm
    add rsp, 32
    cmp rax, 0
    je .L330
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_318
    jmp .L331
.L330:
.L331:
    mov rax, 0xF9800000
    push rax
    sub rsp, 32
    call kc_mbase
    add rsp, 32
    and rax, 31
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_318
.__ret_318:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kq_dc:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L333
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_332
    jmp .L334
.L333:
.L334:
    mov rcx, 0
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
section .data
.str337: db 99,105,118,97,99,0
section .text
    lea rax, [rel .str337]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_streq
    add rsp, 32
    cmp rax, 0
    jne .L335
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_332
    jmp .L336
.L335:
.L336:
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 1
    je .L338
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_332
    jmp .L339
.L338:
.L339:
    mov rax, 0xD50B7E20
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_332
.__ret_332:
    mov rsp, rbp
    pop rbp
    ret
