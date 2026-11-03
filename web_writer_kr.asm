; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_web_writer_A_OUT_BIN_NAME: dq 10
section .text
section .bss
__g_web_writer_ww_html: resq 64
section .text
section .bss
__g_web_writer_ww_js: resq 64
section .text
section .bss
__g_web_writer_ww_pg: resq 512
section .text
ww_page_a:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str1: db 60,33,100,111,99,116,121,112,101,32,104,116,109,108,62,10,60,104,116,109,108,62,10,60,104,101,97,100,62,10,60,109,101,116,97,32,99,104,97,114,115,101,116,61,34,117,116,102,45,56,34,62,10,60,109,101,116,97,32,110,97,109,101,61
    db 34,118,105,101,119,112,111,114,116,34,32,99,111,110,116,101,110,116,61,34,119,105,100,116,104,61,100,101,118,105,99,101,45,119,105,100,116,104,44,32,105,110,105,116,105,97,108,45,115,99,97,108,101,61,49,34,62,10,60,116,105,116,108,101
    db 62,0
section .text
    lea rax, [rel .str1]
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    ret
ww_page_b:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str3: db 60,47,116,105,116,108,101,62,10,60,115,116,121,108,101,62,10,98,111,100,121,32,123,32,109,97,114,103,105,110,58,32,48,59,32,98,97,99,107,103,114,111,117,110,100,58,32,35,49,101,49,101,49,101,59,32,99,111,108,111,114,58,32,35
    db 100,52,100,52,100,52,59,32,102,111,110,116,58,32,49,52,112,120,32,109,111,110,111,115,112,97,99,101,59,32,125,10,99,97,110,118,97,115,32,123,32,100,105,115,112,108,97,121,58,32,110,111,110,101,59,32,111,117,116,108,105,110,101,58
    db 32,110,111,110,101,59,32,109,97,114,103,105,110,58,32,56,112,120,59,32,125,10,112,114,101,32,123,32,109,97,114,103,105,110,58,32,56,112,120,59,32,119,104,105,116,101,45,115,112,97,99,101,58,32,112,114,101,45,119,114,97,112,59,32
    db 125,10,60,47,115,116,121,108,101,62,10,60,47,104,101,97,100,62,10,60,98,111,100,121,62,10,60,99,97,110,118,97,115,32,105,100,61,34,107,114,111,110,34,62,60,47,99,97,110,118,97,115,62,10,60,112,114,101,32,105,100,61,34,111
    db 117,116,34,62,60,47,112,114,101,62,10,60,115,99,114,105,112,116,32,115,114,99,61,34,107,114,111,110,95,119,101,98,46,106,115,34,62,60,47,115,99,114,105,112,116,62,10,60,115,99,114,105,112,116,62,75,114,111,110,87,101,98,46,115
    db 116,97,114,116,40,123,32,119,97,115,109,58,32,34,0
section .text
    lea rax, [rel .str3]
    jmp .__ret_2
.__ret_2:
    mov rsp, rbp
    pop rbp
    ret
ww_page_c:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str5: db 34,44,32,99,97,110,118,97,115,58,32,34,35,107,114,111,110,34,44,32,99,111,110,115,111,108,101,58,32,34,35,111,117,116,34,32,125,41,59,60,47,115,99,114,105,112,116,62,10,60,47,98,111,100,121,62,10,60,47,104,116,109,108,62
    db 10,0
section .text
    lea rax, [rel .str5]
    jmp .__ret_4
.__ret_4:
    mov rsp, rbp
    pop rbp
    ret
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
    jmp .__ret_6
.__ret_6:
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
    jmp .__ret_7
.__ret_7:
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
.L9:
    mov rcx, rbx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    cmp rax, 0
    je .L10
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
.L11:
    jmp .L9
.L10:
    mov rax, r12
    jmp .__ret_8
.__ret_8:
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
.L13:
    cmp rbx, r12
    jge .L14
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
.L15:
    jmp .L13
.L14:
    mov rax, r14
    add rax, r12
    jmp .__ret_12
.__ret_12:
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
    mov rax, [rel __g_web_writer_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, 1
    neg rax
    mov r13, rax
.L17:
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call ww_g8
    add rsp, 32
    cmp rax, 0
    je .L18
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
    jnz .L22
    mov rax, rbx
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L22
    mov rax, 0
    jmp .L23
.L22:
    mov rax, 1
.L23:
    test rax, rax
    jz .L20
    mov rax, r12
    add rax, 1
    mov r14, rax
    mov rax, 1
    neg rax
    mov r13, rax
    jmp .L21
.L20:
    cmp rbx, 46
    jne .L24
    mov rax, r12
    mov r13, rax
    jmp .L25
.L24:
.L25:
.L21:
    add r12, 1
.L19:
    jmp .L17
.L18:
    mov rax, r12
    mov [rbp-48], rax
    mov rax, r13
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L26
    mov rax, [rbp-48]
    mov r13, rax
    jmp .L27
.L26:
.L27:
    lea rax, [rel __g_web_writer_ww_html]
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
section .data
.str28: db 46,104,116,109,108,0
section .text
    lea rax, [rel .str28]
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
    lea rax, [rel __g_web_writer_ww_js]
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
section .data
.str29: db 107,114,111,110,95,119,101,98,46,106,115,0
section .text
    lea rax, [rel .str29]
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
    lea rax, [rel __g_web_writer_ww_pg]
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
    lea rax, [rel __g_web_writer_ww_html]
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
    jne .L30
    mov rax, 0
    jmp .__ret_16
    jmp .L31
.L30:
.L31:
    lea rax, [rel __g_web_writer_ww_js]
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
    jmp .__ret_16
.__ret_16:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
