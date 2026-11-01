; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_krn_writer_KW_MAGIC: dq 558781003
section .text
section .data
__g_krn_writer_KW_HDR_SIZE: dq 128
section .text
section .data
__g_krn_writer_KW_SECT_ENTRY: dq 32
section .text
section .data
__g_krn_writer_KW_ARCH_X86_64: dq 1
section .text
section .data
__g_krn_writer_KW_KIND_APPLICATION: dq 3
section .text
section .data
__g_krn_writer_KW_SEC_CODE: dq 1
section .text
section .data
__g_krn_writer_KW_SEC_DATA: dq 2
section .text
section .data
__g_krn_writer_KW_SEC_BSS: dq 3
section .text
section .data
__g_krn_writer_KW_JSIG_MAGIC: dq 1195987786
section .text
section .data
__g_krn_writer_KW_JSIG_ALG_DIGEST: dq 1
section .text
section .bss
__g_krn_writer_kw_buf: resq 262144
section .text
section .data
__g_krn_writer_kw_len: dq 0
section .text
section .data
__g_krn_writer_kw_kind: dq 0
section .text
section .data
__g_krn_writer_kw_ring: dq 0
section .text
section .data
__g_krn_writer_kw_caps: dq 0
section .text
section .bss
__g_krn_writer_kw_strpool: resq 512
section .text
section .data
__g_krn_writer_kw_strlen: dq 0
section .text
kw_p8:
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
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kw_p16:
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
    mov [rdx], cx
    mov rax, 0
    jmp .__ret_1
.__ret_1:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kw_p32:
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
kw_p64:
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
kw_g8:
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
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
kw_copy:
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
.L6:
    cmp rbx, r12
    jge .L7
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L8:
    jmp .L6
.L7:
    mov rax, r14
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kw_init:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_krn_writer_kw_len], rax
    mov rax, [rel __g_krn_writer_KW_KIND_APPLICATION]
    mov [rel __g_krn_writer_kw_kind], rax
    mov rax, 3
    mov [rel __g_krn_writer_kw_ring], rax
    mov rax, 0
    mov [rel __g_krn_writer_kw_caps], rax
    mov rax, 1
    mov [rel __g_krn_writer_kw_strlen], rax
    lea rax, [rel __g_krn_writer_kw_strpool]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p8
    add rsp, 32
    mov rax, 0
    jmp .__ret_9
.__ret_9:
    mov rsp, rbp
    pop rbp
    ret
kw_set_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_krn_writer_kw_kind], rax
    mov rax, 0
    jmp .__ret_10
.__ret_10:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kw_set_ring:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_krn_writer_kw_ring], rax
    mov rax, 0
    jmp .__ret_11
.__ret_11:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kw_set_caps:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_krn_writer_kw_caps], rax
    mov rax, 0
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
kw_get_image:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    lea rax, [rel __g_krn_writer_kw_buf]
    jmp .__ret_13
.__ret_13:
    mov rsp, rbp
    pop rbp
    ret
kw_get_size:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_krn_writer_kw_len]
    jmp .__ret_14
.__ret_14:
    mov rsp, rbp
    pop rbp
    ret
kw_add_string:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, [rel __g_krn_writer_kw_strlen]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L16:
    mov rax, 1
    cmp rax, 1
    jne .L17
    mov rax, r14
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call kw_g8
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_krn_writer_kw_strpool]
    add rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kw_p8
    add rsp, 32
    cmp rbx, 0
    jne .L19
    mov rax, r13
    add rax, r12
    add rax, 1
    mov [rel __g_krn_writer_kw_strlen], rax
    mov rax, r13
    jmp .__ret_15
    jmp .L20
.L19:
.L20:
    add r12, 1
.L18:
    jmp .L16
.L17:
    mov rax, r13
    jmp .__ret_15
.__ret_15:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
kw_build:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    lea rax, [rel __g_krn_writer_kw_buf]
    mov r15, rax
    mov rax, 0
    mov rbx, rax
.L22:
    mov rax, rbx
    push rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L23
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p8
    add rsp, 32
    add rbx, 1
.L24:
    jmp .L22
.L23:
section .data
.str25: db 46,99,111,100,101,0
section .text
    lea rax, [rel .str25]
    push rax
    pop rcx
    sub rsp, 32
    call kw_add_string
    add rsp, 32
    mov r12, rax
section .data
.str26: db 46,100,97,116,97,0
section .text
    lea rax, [rel .str26]
    push rax
    pop rcx
    sub rsp, 32
    call kw_add_string
    add rsp, 32
    mov [rbp-32], rax
section .data
.str27: db 46,98,115,115,0
section .text
    lea rax, [rel .str27]
    push rax
    pop rcx
    sub rsp, 32
    call kw_add_string
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rel __g_krn_writer_KW_SECT_ENTRY]
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_krn_writer_kw_strlen]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov r14, rax
    mov rax, r15
    add rax, 0
    push rax
    mov rax, [rel __g_krn_writer_KW_MAGIC]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 4
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, r15
    add rax, 6
    push rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, r15
    add rax, 8
    push rax
    mov rax, [rel __g_krn_writer_KW_ARCH_X86_64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, r15
    add rax, 10
    push rax
    mov rax, [rel __g_krn_writer_kw_kind]
    and rax, 65535
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, r15
    add rax, 12
    push rax
    mov rax, [rel __g_krn_writer_kw_ring]
    and rax, 65535
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, r15
    add rax, 14
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, r15
    add rax, 16
    push rax
    pop rcx
    mov rdx, 4096
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r15
    add rax, 24
    push rax
    pop rcx
    mov rdx, 4194304
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r15
    add rax, 40
    push rax
    pop rcx
    mov rdx, 1048576
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r15
    add rax, 48
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r15
    add rax, 56
    push rax
    pop rcx
    mov rdx, 3
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 60
    push rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 64
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 68
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 72
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 76
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 80
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 84
    push rax
    mov rax, [rel __g_krn_writer_kw_strlen]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, 104
    push rax
    mov rax, [rel __g_krn_writer_kw_caps]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r15
    add rax, rbx
    push rax
    lea rax, [rel __g_krn_writer_kw_strpool]
    push rax
    mov rax, [rel __g_krn_writer_kw_strlen]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_copy
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    sub rsp, 32
    call kasm_get_code_size
    add rsp, 32
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    mov rax, r13
    add rax, 0
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 4
    push rax
    mov rax, [rel __g_krn_writer_KW_SEC_CODE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 8
    push rax
    pop rcx
    mov rdx, 4096
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r13
    add rax, 16
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 20
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 24
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 28
    push rax
    pop rcx
    mov rdx, 5
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_krn_writer_KW_SECT_ENTRY]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, rbx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    mov rax, r13
    add rax, 0
    push rax
    pop rcx
    mov rdx, [rbp-32]
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 4
    push rax
    mov rax, [rel __g_krn_writer_KW_SEC_DATA]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 8
    push rax
    mov rax, r12
    add rax, 4096
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r13
    add rax, 16
    push rax
    mov rax, r14
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    sub rsp, 32
    call kasm_get_data_size
    add rsp, 32
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    mov rax, r13
    add rax, 20
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 24
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 28
    push rax
    pop rcx
    mov rdx, 3
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_krn_writer_KW_HDR_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_krn_writer_KW_SECT_ENTRY]
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, r13
    add rax, 0
    push rax
    pop rcx
    mov rdx, [rbp-40]
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 4
    push rax
    mov rax, [rel __g_krn_writer_KW_SEC_BSS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 8
    push rax
    mov rax, r12
    add rax, rbx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    add rax, 4096
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r13
    add rax, 16
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 20
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 24
    push rax
    sub rsp, 32
    call kasm_get_bss_size
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r13
    add rax, 28
    push rax
    pop rcx
    mov rdx, 3
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r15
    add rax, r14
    push rax
    sub rsp, 32
    call kasm_get_code
    add rsp, 32
    push rax
    sub rsp, 32
    call kasm_get_code_size
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_copy
    add rsp, 32
    mov rax, r15
    add rax, r14
    add rax, r12
    push rax
    sub rsp, 32
    call kasm_get_data
    add rsp, 32
    push rax
    sub rsp, 32
    call kasm_get_data_size
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_copy
    add rsp, 32
    mov rax, r14
    add rax, r12
    add rax, rbx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov [rel __g_krn_writer_kw_len], rax
    sub rsp, 32
    call kw_sign
    add rsp, 32
    mov rax, [rel __g_krn_writer_kw_len]
    jmp .__ret_21
.__ret_21:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
kw_sign:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    lea rax, [rel __g_krn_writer_kw_buf]
    mov r14, rax
    mov rax, [rel __g_krn_writer_kw_len]
    mov r13, rax
    mov rax, r14
    add rax, 88
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, r14
    add rax, 92
    push rax
    pop rcx
    mov rdx, 48
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, 3750763034362895579
    neg rax
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L29:
    cmp rbx, r13
    jge .L30
    mov rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call kw_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rcx, 1099511628211
    imul rax, rcx
    mov r12, rax
    add rbx, 1
.L31:
    jmp .L29
.L30:
    mov rax, r14
    add rax, r13
    mov rbx, rax
    mov rax, rbx
    add rax, 0
    push rax
    mov rax, [rel __g_krn_writer_KW_JSIG_MAGIC]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 4
    push rax
    mov rax, [rel __g_krn_writer_KW_JSIG_ALG_DIGEST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, rbx
    add rax, 6
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p16
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 12
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 16
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, rbx
    add rax, 24
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, rbx
    add rax, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, rbx
    add rax, 40
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call kw_p64
    add rsp, 32
    mov rax, r13
    add rax, 48
    mov [rel __g_krn_writer_kw_len], rax
    mov rax, 0
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
