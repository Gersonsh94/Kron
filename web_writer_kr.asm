; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
ww_g8:
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
ww_p8:
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
ww_cat:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
.L3:
    mov rcx, rbx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    cmp rax, 0
    je .L4
    mov rax, r12
    push rax
    mov rcx, rbx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_p8
    add rsp, 32
    add r12, 1
    add rbx, 1
.L5:
    jmp .L3
.L4:
    mov rax, r12
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ww_catn:
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
.L7:
    cmp rbx, r12
    jge .L8
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_p8
    add rsp, 32
    add rbx, 1
.L9:
    jmp .L7
.L8:
    mov rax, r14
    add rax, r12
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ww_write_host:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    sub rsp, 32
    call ww_out_bin_name
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, 1
    neg rax
    mov r13, rax
.L11:
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    cmp rax, 0
    je .L12
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L16
    mov rax, rbx
    mov rcx, 92
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
    mov rax, r12
    add rax, 1
    mov r14, rax
    mov rax, 1
    neg rax
    mov r13, rax
    jmp .L15
.L14:
    cmp rbx, 46
    jne .L18
    mov rax, r12
    mov r13, rax
    jmp .L19
.L18:
.L19:
.L15:
    add r12, 1
.L13:
    jmp .L11
.L12:
    mov rax, r12
    mov [rbp-48], rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L20
    mov rax, [rbp-48]
    mov r13, rax
    jmp .L21
.L20:
.L21:
    sub rsp, 32
    call ww_html_name
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r13
    sub rsp, 32
    call ww_catn
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ww_html_ext
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_cat
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    mov rdx, 0
    sub rsp, 32
    call ww_p8
    add rsp, 32
    sub rsp, 32
    call ww_js_path
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r14
    sub rsp, 32
    call ww_catn
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ww_js_name
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_cat
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    mov rdx, 0
    sub rsp, 32
    call ww_p8
    add rsp, 32
    sub rsp, 32
    call ww_page
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ww_page_a
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_cat
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, r15
    add rax, r14
    push rax
    mov rax, r13
    sub rax, r14
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_catn
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ww_page_b
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_cat
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, r15
    add rax, r14
    push rax
    mov rax, [rbp-48]
    sub rax, r14
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_catn
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    sub rsp, 32
    call ww_page_c
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ww_cat
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call ww_html_name
    add rsp, 32
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, rbx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call write_file
    add rsp, 32
    cmp rax, 0
    jne .L22
    mov rax, 0
    jmp .__ret_10
    jmp .L23
.L22:
.L23:
    sub rsp, 32
    call ww_js_path
    add rsp, 32
    push rax
    sub rsp, 32
    call ww_host_js
    add rsp, 32
    push rax
    sub rsp, 32
    call ww_host_js_size
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call write_file
    add rsp, 32
    jmp .__ret_10
.__ret_10:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
