; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
ko_ult:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 1
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
    jge .L1
    mov rax, 1
    jmp .__ret_0
    jmp .L2
.L1:
.L2:
    mov rax, 0
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ko_mov:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L4
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_3
    jmp .L5
.L4:
.L5:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r13, rax
    cmp rbx, 0
    jne .L6
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_3
    jmp .L7
.L6:
.L7:
    cmp rbx, 7
    jne .L8
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 7
    je .L10
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_3
    jmp .L11
.L10:
.L11:
    mov rax, 0x4EA01C00
    push rax
    mov rax, r13
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
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
    jmp .__ret_3
    jmp .L9
.L8:
.L9:
    mov rax, rbx
    mov r12, rax
    cmp rbx, 3
    jl .L12
    cmp rbx, 5
    je .L14
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_3
    jmp .L15
.L14:
.L15:
    mov rcx, 31
    sub rsp, 32
    call ko_mov_sp
    add rsp, 32
    jmp .__ret_3
    jmp .L13
.L12:
.L13:
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L16
    sub rsp, 32
    call kc_clear_unres
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L18
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_3
    jmp .L19
.L18:
.L19:
    mov rcx, r13
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
    call kc_movimm
    add rsp, 32
    jmp .__ret_3
    jmp .L17
.L16:
.L17:
    cmp rbx, 5
    jne .L20
    mov rcx, r13
    sub rsp, 32
    call ko_mov_sp
    add rsp, 32
    jmp .__ret_3
    jmp .L21
.L20:
.L21:
    cmp rbx, r12
    je .L22
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_3
    jmp .L23
.L22:
.L23:
    mov rax, 0x2A000000
    push rax
    mov rcx, r12
    sub rsp, 32
    call kc_sf
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r13
    push rax
    mov rax, 31
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
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
ko_mov_sp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 5
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L27
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L27
    mov rax, 1
    jmp .L28
.L27:
    mov rax, 0
.L28:
    test rax, rax
    jz .L25
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_24
    jmp .L26
.L25:
.L26:
    mov rax, 0x91000000
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    and rax, 31
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r12
    and rax, 31
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_24
.__ret_24:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ko_movw:
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
    mov r15, rax
    mov rax, r15
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L32
    mov rax, r15
    mov rcx, 2
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L32
    mov rax, 1
    jmp .L33
.L32:
    mov rax, 0
.L33:
    test rax, rax
    jz .L30
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_29
    jmp .L31
.L30:
.L31:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r14, rax
    mov rax, rbx
    push rax
    mov rcx, r15
    sub rsp, 32
    call kc_sf
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L34
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_29
    jmp .L35
.L34:
.L35:
    mov rcx, 65535
    mov rdx, r12
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    je .L36
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_29
    jmp .L37
.L36:
.L37:
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call kc_nops
    add rsp, 32
    cmp rax, 3
    jl .L38
    mov rcx, 2
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_shiftop
    add rsp, 32
    cmp rax, 0
    je .L40
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_29
    jmp .L41
.L40:
.L41:
    sub rsp, 32
    call kc_shamt
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    and rax, 15
    cmp rax, 0
    je .L42
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_29
    jmp .L43
.L42:
.L43:
    mov rax, rbx
    shr rax, 4
    mov rbx, rax
    cmp r15, 2
    jne .L44
    cmp rbx, 1
    jle .L46
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_29
    jmp .L47
.L46:
.L47:
    jmp .L45
.L44:
    cmp rbx, 3
    jle .L48
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_29
    jmp .L49
.L48:
.L49:
.L45:
    jmp .L39
.L38:
.L39:
    mov rax, rbx
    shl rax, 21
    mov rcx, rax
    mov rax, r13
    or rax, rcx
    push rax
    mov rax, r12
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r14
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_29
.__ret_29:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
ko_addsub:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov [rbp-176], r15
    mov rbx, rcx
    mov rax, rbx
    mov r15, rax
    sub rsp, 32
    call kc_nops
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    mov rcx, 3
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L53
    mov rax, [rbp-24]
    mov rcx, 4
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L53
    mov rax, 0
    jmp .L54
.L53:
    mov rax, 1
.L54:
    test rax, rax
    jz .L51
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_50
    jmp .L52
.L51:
.L52:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L55
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_50
    jmp .L56
.L55:
.L56:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov [rbp-48], rax
    mov rax, [rbp-48]
    cmp rax, 0
    jne .L57
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_50
    jmp .L58
.L57:
.L58:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 2
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L59
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov [rbp-72], rax
    mov rax, 0x80000000
    mov rbx, rax
    cmp r14, 2
    jne .L61
    mov rax, 0
    mov rbx, rax
    jmp .L62
.L61:
.L62:
    mov rax, r15
    and rax, 1
    shl rax, 30
    push rax
    mov rax, r15
    shr rax, 1
    shl rax, 29
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    mov r15, rax
    mov rax, r14
    mov rcx, 5
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L65
    mov rax, [rbp-48]
    mov rcx, 5
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L65
    mov rax, 0
    jmp .L66
.L65:
    mov rax, 1
.L66:
    test rax, rax
    jz .L63
    mov rax, 0x0B206000
    mov r14, rax
    cmp rbx, 0
    jne .L67
    mov rax, 0x0B204000
    mov r14, rax
    jmp .L68
.L67:
.L68:
    mov rax, r14
    or rax, r15
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r12
    mov r9, [rbp-72]
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_50
    jmp .L64
.L63:
.L64:
    mov rax, 0x0B000000
    or rax, r15
    mov r14, rax
    mov rax, [rbp-24]
    cmp rax, 4
    jl .L69
    mov rcx, 3
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_shiftop
    add rsp, 32
    mov r15, rax
    mov rcx, 2
    mov rdx, r15
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    je .L71
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_50
    jmp .L72
.L71:
.L72:
    sub rsp, 32
    call kc_shamt
    add rsp, 32
    mov rbx, rax
    mov rcx, 63
    mov rdx, rbx
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    je .L73
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_50
    jmp .L74
.L73:
.L74:
    mov rax, r15
    shl rax, 22
    mov rcx, rax
    mov rax, r14
    or rax, rcx
    push rax
    mov rax, rbx
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L70
.L69:
.L70:
    mov rcx, r14
    mov rdx, r13
    mov r8, r12
    mov r9, [rbp-72]
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_50
    jmp .L60
.L59:
.L60:
    sub rsp, 32
    call kc_clear_unres
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L75
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_50
    jmp .L76
.L75:
.L76:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    cmp rbx, 0
    jge .L77
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    xor r15, 1
    jmp .L78
.L77:
.L78:
    mov rax, 0
    mov [rbp-136], rax
    mov rcx, 4095
    mov rdx, rbx
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    je .L79
    mov rax, 1
    mov [rbp-144], rax
    mov rax, rbx
    and rax, 4095
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L83
    mov rax, 4095
    push rax
    mov rax, rbx
    shr rax, 12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ko_ult
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
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
    shr rax, 12
    mov rbx, rax
    mov rax, 1
    mov [rbp-136], rax
    mov rax, 0
    mov [rbp-144], rax
    jmp .L82
.L81:
.L82:
    mov rax, [rbp-144]
    cmp rax, 0
    je .L85
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    jmp .L86
.L85:
.L86:
    jmp .L80
.L79:
.L80:
    mov rax, r15
    and rax, 1
    shl rax, 30
    mov rcx, rax
    mov rax, 0x11000000
    or rax, rcx
    push rax
    mov rax, r15
    shr rax, 1
    shl rax, 29
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r15, rax
    cmp r14, 2
    je .L87
    mov rax, r15
    mov rcx, 0x80000000
    or rax, rcx
    mov r15, rax
    jmp .L88
.L87:
.L88:
    mov rax, [rbp-136]
    shl rax, 22
    mov rcx, rax
    mov rax, r15
    or rax, rcx
    push rax
    mov rax, rbx
    and rax, 4095
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r12
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_50
.__ret_50:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov r15, [rbp-176]
    mov rsp, rbp
    pop rbp
    ret
ko_cmpn:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
    call kc_shift_ops
    add rsp, 32
    mov rax, 0
    push rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_zr
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ko_addsub
    add rsp, 32
    jmp .__ret_89
.__ret_89:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ko_neg:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L91
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_90
    jmp .L92
.L91:
.L92:
    mov rcx, 1
    mov rdx, 2
    sub rsp, 32
    call kc_copyop
    add rsp, 32
    mov rax, 1
    push rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_zr
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call kc_set_nops
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call ko_addsub
    add rsp, 32
    jmp .__ret_90
.__ret_90:
    mov rsp, rbp
    pop rbp
    ret
ko_three:
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
    jne .L94
    mov rax, 0
    jmp .__ret_93
    jmp .L95
.L94:
.L95:
    mov rax, rbx
    mov r14, rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r13, rax
    cmp r13, 2
    jne .L96
    mov rax, r14
    mov rcx, 0x7FFFFFFF
    and rax, rcx
    mov r14, rax
    jmp .L97
.L96:
    cmp r13, 1
    je .L98
    mov rax, 0
    jmp .__ret_93
    jmp .L99
.L98:
.L99:
.L97:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L100
    mov rax, 0
    jmp .__ret_93
    jmp .L101
.L100:
.L101:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    mov rcx, 2
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L102
    mov rax, 0
    jmp .__ret_93
    jmp .L103
.L102:
.L103:
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
    jmp .__ret_93
.__ret_93:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
ko_three_op:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
    call ko_three
    add rsp, 32
    cmp rax, 0
    jne .L105
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_104
    jmp .L106
.L105:
.L106:
    mov rax, 0
    jmp .__ret_104
.__ret_104:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ko_mfour:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 4
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L108
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_107
    jmp .L109
.L108:
.L109:
    mov rcx, 3
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 0
    jne .L110
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_107
    jmp .L111
.L110:
.L111:
    mov rax, rbx
    push rax
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    mov rcx, 3
    sub rsp, 32
    call kc_set_nops
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call ko_three_op
    add rsp, 32
    jmp .__ret_107
.__ret_107:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ko_vec3:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rcx, 3
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L113
    mov rax, 0
    jmp .__ret_112
    jmp .L114
.L113:
.L114:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L115
    mov rax, 0
    jmp .__ret_112
    jmp .L116
.L115:
.L116:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L117
    mov rax, 0
    jmp .__ret_112
    jmp .L118
.L117:
.L118:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov rbx, rax
    mov rcx, 2
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L119
    mov rax, 0
    jmp .__ret_112
    jmp .L120
.L119:
.L120:
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
    jmp .__ret_112
.__ret_112:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ko_logic:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 7
    jne .L122
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    mov rcx, 0xCA000000
    cmp rax, rcx
    jne .L124
    mov rax, 0x6E201C00
    mov rbx, rax
    jmp .L125
.L124:
    mov rax, r15
    mov rcx, 0x8A000000
    cmp rax, rcx
    jne .L126
    mov rax, 0x4E201C00
    mov rbx, rax
    jmp .L127
.L126:
    mov rax, r15
    mov rcx, 0xAA000000
    cmp rax, rcx
    jne .L128
    mov rax, 0x4EA01C00
    mov rbx, rax
    jmp .L129
.L128:
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
.L129:
.L127:
.L125:
    mov rcx, rbx
    mov rdx, 7
    sub rsp, 32
    call ko_vec3
    add rsp, 32
    cmp rax, 0
    jne .L130
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L131
.L130:
.L131:
    mov rax, 0
    jmp .__ret_121
    jmp .L123
.L122:
.L123:
    sub rsp, 32
    call kc_nops
    add rsp, 32
    mov r14, rax
    mov rax, r14
    mov rcx, 3
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L134
    mov rax, r14
    mov rcx, 4
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L134
    mov rax, 0
    jmp .L135
.L134:
    mov rax, 1
.L135:
    test rax, rax
    jz .L132
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L133
.L132:
.L133:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r13, rax
    cmp r13, 5
    jne .L136
    mov rax, 1
    mov r13, rax
    jmp .L137
.L136:
    mov rax, r13
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L140
    mov rax, r13
    mov rcx, 2
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L140
    mov rax, 1
    jmp .L141
.L140:
    mov rax, 0
.L141:
    test rax, rax
    jz .L138
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L139
.L138:
.L139:
.L137:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov [rbp-48], rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, r13
    je .L142
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L143
.L142:
.L143:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 2
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L144
    cmp rbx, r13
    je .L146
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L147
.L146:
.L147:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov [rbp-72], rax
    mov rax, r15
    mov rbx, rax
    cmp r13, 2
    jne .L148
    mov rax, rbx
    mov rcx, 0x7FFFFFFF
    and rax, rcx
    mov rbx, rax
    jmp .L149
.L148:
.L149:
    cmp r14, 4
    jl .L150
    mov rcx, 3
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_shiftop
    add rsp, 32
    mov r14, rax
    mov rax, r14
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L152
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L153
.L152:
.L153:
    sub rsp, 32
    call kc_shamt
    add rsp, 32
    mov r13, rax
    mov rcx, 63
    mov rdx, r13
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    je .L154
    sub rsp, 32
    call kc_range
    add rsp, 32
    jmp .__ret_121
    jmp .L155
.L154:
.L155:
    mov rax, r14
    shl rax, 22
    mov rcx, rax
    mov rax, rbx
    or rax, rcx
    push rax
    mov rax, r13
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    jmp .L151
.L150:
.L151:
    mov rcx, rbx
    mov rdx, [rbp-48]
    mov r8, r12
    mov r9, [rbp-72]
    sub rsp, 32
    call kc_rrr
    add rsp, 32
    jmp .__ret_121
    jmp .L145
.L144:
.L145:
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L156
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L157
.L156:
.L157:
    sub rsp, 32
    call kc_clear_unres
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov r15, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L158
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_121
    jmp .L159
.L158:
.L159:
    sub rsp, 32
    call kc_undef_check
    add rsp, 32
    mov rax, 64
    mov rbx, rax
    mov rax, [rbp-16]
    mov r14, rax
    cmp r13, 2
    jne .L160
    mov rax, 32
    mov rbx, rax
    mov rax, r14
    mov rcx, 0x7FFFFFFF
    and rax, rcx
    mov r14, rax
    jmp .L161
.L160:
.L161:
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
    call ko_bitmask
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L162
    mov rcx, 7
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_121
    jmp .L163
.L162:
.L163:
    mov rax, rbx
    shl rax, 10
    mov rcx, rax
    mov rax, r14
    or rax, rcx
    push rax
    mov rax, r12
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, [rbp-48]
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_121
.__ret_121:
    mov rbx, [rbp-176]
    mov r12, [rbp-168]
    mov r13, [rbp-160]
    mov r14, [rbp-152]
    mov r15, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
ko_bitmask:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov rax, rbx
    mov r15, rax
    mov rax, [rbp-16]
    cmp rax, 32
    jne .L165
    mov rax, r15
    mov rcx, 0xFFFFFFFF
    and rax, rcx
    mov r15, rax
    mov rax, r15
    shl rax, 32
    mov rcx, rax
    mov rax, r15
    or rax, rcx
    mov r15, rax
    jmp .L166
.L165:
.L166:
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L169
    mov rax, r15
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L169
    mov rax, 0
    jmp .L170
.L169:
    mov rax, 1
.L170:
    test rax, rax
    jz .L167
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L168
.L167:
.L168:
    mov rax, 2
    mov r14, rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov r13, rax
.L171:
    mov rax, 1
    test rax, rax
    jz .L172
    mov rax, r14
    mov rcx, 64
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L176
    mov rax, r14
    mov rcx, [rbp-16]
    cmp rax, rcx
    setg al
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
    neg rax
    jmp .__ret_164
    jmp .L175
.L174:
.L175:
    mov rax, 1
    neg rax
    mov [rbp-40], rax
    cmp r14, 64
    je .L178
    mov rax, 1
    mov rcx, r14
    shl rax, cl
    sub rax, 1
    mov [rbp-40], rax
    jmp .L179
.L178:
.L179:
    mov rax, r15
    mov rcx, [rbp-40]
    and rax, rcx
    mov r13, rax
    mov rax, r13
    mov r12, rax
    mov rax, r14
    mov rbx, rax
.L180:
    cmp rbx, 64
    jge .L181
    mov rax, r12
    mov rcx, rbx
    shl rax, cl
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    mov r12, rax
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rbx, rax
.L182:
    jmp .L180
.L181:
    cmp r12, r15
    jne .L183
    jmp .L172
    jmp .L184
.L183:
.L184:
    mov rax, r14
    mov rcx, 2
    imul rax, rcx
    mov r14, rax
.L173:
    jmp .L171
.L172:
    mov rax, 0
    mov r12, rax
    mov rax, r13
    mov rbx, rax
.L185:
    cmp rbx, 0
    je .L186
    mov rax, rbx
    and rax, 1
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    mov r12, rax
    mov rax, rbx
    shr rax, 1
    mov rbx, rax
.L187:
    jmp .L185
.L186:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L190
    mov rax, r12
    mov rcx, r14
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L190
    mov rax, 0
    jmp .L191
.L190:
    mov rax, 1
.L191:
    test rax, rax
    jz .L188
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L189
.L188:
.L189:
    mov rax, 1
    mov rcx, r12
    shl rax, cl
    sub rax, 1
    mov [rbp-88], rax
    mov rax, 0
    mov rbx, rax
.L192:
    mov rax, 1
    test rax, rax
    jz .L193
    cmp rbx, r14
    jl .L195
    mov rax, 1
    neg rax
    jmp .__ret_164
    jmp .L196
.L195:
.L196:
    mov rax, [rbp-88]
    mov rcx, rbx
    shr rax, cl
    mov [rbp-104], rax
    mov rax, 0
    mov r15, rax
    mov rax, r14
    sub rax, rbx
    cmp rax, 64
    jge .L197
    mov rax, r14
    sub rax, rbx
    mov rcx, rax
    mov rax, [rbp-88]
    shl rax, cl
    mov r15, rax
    jmp .L198
.L197:
.L198:
    mov rax, [rbp-104]
    or rax, r15
    mov rcx, [rbp-40]
    and rax, rcx
    cmp rax, r13
    jne .L199
    jmp .L193
    jmp .L200
.L199:
.L200:
    add rbx, 1
.L194:
    jmp .L192
.L193:
    mov rax, r14
    mov rcx, 2
    imul rax, rcx
    sub rax, 1
    not rax
    and rax, 63
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r15, rax
    mov rax, 0
    mov r13, rax
    cmp r14, 64
    jne .L201
    mov rax, 1
    mov r13, rax
    mov rax, r12
    sub rax, 1
    mov r15, rax
    jmp .L202
.L201:
.L202:
    mov rax, r13
    shl rax, 12
    push rax
    mov rax, rbx
    shl rax, 6
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r15
    jmp .__ret_164
.__ret_164:
    mov rbx, [rbp-176]
    mov r12, [rbp-168]
    mov r13, [rbp-160]
    mov r14, [rbp-152]
    mov r15, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
ko_tst:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call kc_shift_ops
    add rsp, 32
    mov rax, 0
    push rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_zr
    add rsp, 32
    mov rcx, 0xEA000000
    mov rdx, 0xF2000000
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_203
.__ret_203:
    mov rsp, rbp
    pop rbp
    ret
ko_mvn:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call kc_nops
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 2
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L207
    mov rax, rbx
    mov rcx, 3
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L207
    mov rax, 0
    jmp .L208
.L207:
    mov rax, 1
.L208:
    test rax, rax
    jz .L205
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_204
    jmp .L206
.L205:
.L206:
    cmp rbx, 3
    jne .L209
    mov rcx, 2
    mov rdx, 3
    sub rsp, 32
    call kc_copyop
    add rsp, 32
    jmp .L210
.L209:
.L210:
    mov rcx, 1
    mov rdx, 2
    sub rsp, 32
    call kc_copyop
    add rsp, 32
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call kc_set_nops
    add rsp, 32
    mov rax, 1
    push rax
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kc_zr
    add rsp, 32
    mov rcx, 0xAA200000
    mov rdx, 0
    sub rsp, 32
    call ko_logic
    add rsp, 32
    jmp .__ret_204
.__ret_204:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ko_shift:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov rcx, 3
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L212
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_211
    jmp .L213
.L212:
.L213:
    mov rcx, 2
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 0
    je .L214
    mov rax, r15
    shl rax, 10
    mov rcx, rax
    mov rax, 0x9AC02000
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ko_three_op
    add rsp, 32
    jmp .__ret_211
    jmp .L215
.L214:
.L215:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L218
    mov rax, rbx
    mov rcx, 2
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L218
    mov rax, 1
    jmp .L219
.L218:
    mov rax, 0
.L219:
    test rax, rax
    jz .L216
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_211
    jmp .L217
.L216:
.L217:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov [rbp-24], rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, rbx
    je .L220
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_211
    jmp .L221
.L220:
.L221:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov [rbp-32], rax
    mov rcx, 2
    sub rsp, 32
    call kc_imm
    add rsp, 32
    mov r14, rax
    sub rsp, 32
    call kc_evok
    add rsp, 32
    cmp rax, 0
    jne .L222
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_211
    jmp .L223
.L222:
.L223:
    mov rax, 63
    mov r13, rax
    mov rax, 0xD3400000
    mov r12, rax
    mov rax, 0x93400000
    mov [rbp-64], rax
    mov rax, 0x93C00000
    mov [rbp-72], rax
    cmp rbx, 2
    jne .L224
    mov rax, 31
    mov r13, rax
    mov rax, 0x53000000
    mov r12, rax
    mov rax, 0x13000000
    mov [rbp-64], rax
    mov rax, 0x13800000
    mov [rbp-72], rax
    jmp .L225
.L224:
.L225:
    mov rcx, r13
    mov rdx, r14
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    je .L226
    mov rcx, 3
    sub rsp, 32
    call kc_err2
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_211
    jmp .L227
.L226:
.L227:
    mov rax, 0
    mov rbx, rax
    cmp r15, 0
    jne .L228
    mov rax, r13
    add rax, 1
    sub rax, r14
    and rax, r13
    shl rax, 16
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    push rax
    mov rax, r13
    sub rax, r14
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    jmp .L229
.L228:
    cmp r15, 1
    jne .L230
    mov rax, r14
    shl rax, 16
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    push rax
    mov rax, r13
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    jmp .L231
.L230:
    cmp r15, 2
    jne .L232
    mov rax, r14
    shl rax, 16
    mov rcx, rax
    mov rax, [rbp-64]
    or rax, rcx
    push rax
    mov rax, r13
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    jmp .L233
.L232:
    mov rax, [rbp-32]
    shl rax, 16
    mov rcx, rax
    mov rax, [rbp-72]
    or rax, rcx
    push rax
    mov rax, r14
    shl rax, 10
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
.L233:
.L231:
.L229:
    mov rax, [rbp-32]
    shl rax, 5
    mov rcx, rax
    mov rax, rbx
    or rax, rcx
    mov rcx, [rbp-24]
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_211
.__ret_211:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
ko_cset:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L235
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_234
    jmp .L236
.L235:
.L236:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r13, rax
    mov rax, r13
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L239
    mov rax, r13
    mov rcx, 2
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L239
    mov rax, 1
    jmp .L240
.L239:
    mov rax, 0
.L240:
    test rax, rax
    jz .L237
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_234
    jmp .L238
.L237:
.L238:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rcx, 1
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_cond
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 14
    sub rsp, 32
    call ko_ult
    add rsp, 32
    cmp rax, 0
    jne .L241
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_234
    jmp .L242
.L241:
.L242:
    mov rax, 0x1A9F07E0
    push rax
    mov rcx, r13
    sub rsp, 32
    call kc_sf
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, rbx
    xor rax, 1
    shl rax, 12
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_234
.__ret_234:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
ko_csx:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, 4
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L244
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_243
    jmp .L245
.L244:
.L245:
    mov rcx, 3
    sub rsp, 32
    call kc_op
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call kc_cond
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L246
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_243
    jmp .L247
.L246:
.L247:
    mov rcx, 3
    sub rsp, 32
    call kc_set_nops
    add rsp, 32
    mov rax, rbx
    shl rax, 12
    mov rcx, rax
    mov rax, r12
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call ko_three_op
    add rsp, 32
    jmp .__ret_243
.__ret_243:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ko_ext:
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
    mov rcx, 2
    sub rsp, 32
    call kc_need
    add rsp, 32
    cmp rax, 0
    jne .L249
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_248
    jmp .L250
.L249:
.L250:
    mov rcx, 0
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    mov r14, rax
    mov rax, r14
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L253
    mov rax, r14
    mov rcx, 2
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L253
    mov rax, 1
    jmp .L254
.L253:
    mov rax, 0
.L254:
    test rax, rax
    jz .L251
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_248
    jmp .L252
.L251:
.L252:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r13, rax
    mov rcx, 1
    sub rsp, 32
    call kc_opreg
    add rsp, 32
    cmp rax, 2
    je .L255
    sub rsp, 32
    call kc_bad
    add rsp, 32
    jmp .__ret_248
    jmp .L256
.L255:
.L256:
    sub rsp, 32
    call kc_rnum
    add rsp, 32
    mov r12, rax
    mov rax, 0x53000000
    mov rbx, rax
    cmp r15, 0
    je .L257
    mov rax, 0x13000000
    mov rbx, rax
    cmp r14, 1
    jne .L259
    mov rax, 0x93400000
    mov rbx, rax
    jmp .L260
.L259:
.L260:
    jmp .L258
.L257:
.L258:
    mov rax, [rbp-8]
    shl rax, 10
    mov rcx, rax
    mov rax, rbx
    or rax, rcx
    push rax
    mov rax, r12
    shl rax, 5
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call kc_emit32
    add rsp, 32
    jmp .__ret_248
.__ret_248:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
