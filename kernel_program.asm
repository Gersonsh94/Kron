bits 64
global kmain
section .bss
__numbuf: resb 32
__vgapos: resq 1
__chbuf: resb 2
section .text
__print_int:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    mov rax, rcx
    xor r8, r8
    test rax, rax
    jns .bpp
    neg rax
    mov r8, 1
.bpp:
    lea rsi, [rel __numbuf+31]
    mov byte [rsi], 0
    dec rsi
    mov rbx, 10
.bcv:
    xor rdx, rdx
    div rbx
    add dl, 48
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .bcv
    test r8, r8
    jz .bns
    mov byte [rsi], 45
    dec rsi
.bns:
    inc rsi
    mov rcx, rsi
    call __print_str
    pop rdi
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__print_str:
    push rbx
    push rsi
    push rdi
    mov rsi, rcx
    mov rdi, 0xB8000
    add rdi, [rel __vgapos]
.bsl:
    mov al, [rsi]
    test al, al
    jz .bsd
    cmp al, 10
    jne .bsc
    mov rax, [rel __vgapos]
    add rax, 160
    xor rdx, rdx
    mov rbx, 160
    div rbx
    imul rax, rbx
    mov [rel __vgapos], rax
    mov rdi, 0xB8000
    add rdi, rax
    inc rsi
    jmp .bsl
.bsc:
    mov [rdi], al
    mov byte [rdi+1], 0x0F
    add rdi, 2
    add qword [rel __vgapos], 2
    inc rsi
    jmp .bsl
.bsd:
    pop rdi
    pop rsi
    pop rbx
    ret
__print_float:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 40
    xorps xmm1, xmm1
    comisd xmm1, xmm0
    jbe .fnoneg
    movsd [rsp], xmm0
    mov rcx, 45
    call __print_char
    movsd xmm0, [rsp]
    mov rax, 0x8000000000000000
    movq xmm2, rax
    xorps xmm0, xmm2
.fnoneg:
    mov rax, 1000000
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvtsd2si rax, xmm0
    xor rdx, rdx
    mov rbx, 1000000
    div rbx
    push rdx
    mov rcx, rax
    call __print_uint
    mov rcx, 46
    call __print_char
    pop rcx
    mov r10, 6
    call __print_pad
    mov rcx, 10
    call __print_char
    add rsp, 40
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__print_uint:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    sub rsp, 40
    mov rax, rcx
    lea rsi, [rel __numbuf+31]
    mov byte [rsi], 0
    mov rbx, 10
.ul:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, 48
    mov [rsi], dl
    test rax, rax
    jnz .ul
    mov rcx, rsi
    call __print_cstr
    add rsp, 40
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__print_pad:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    sub rsp, 40
    mov rax, rcx
    lea rsi, [rel __numbuf+31]
    mov byte [rsi], 0
    mov rbx, 10
.pl:
    dec rsi
    xor rdx, rdx
    div rbx
    add dl, 48
    mov [rsi], dl
    dec r10
    test r10, r10
    jnz .pl
    mov rcx, rsi
    call __print_cstr
    add rsp, 40
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__print_char:
    mov [rel __chbuf], cl
    mov byte [rel __chbuf+1], 0
    lea rcx, [rel __chbuf]
    call __print_str
    ret
__print_cstr:
    jmp __print_str
kmain:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov [rbp-8], rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 1234
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
.L1:
    mov rax, [rbp-8]
    push rax
    mov rax, 5
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-8], rax
    jmp .L1
.L2:
    mov rax, [rbp-16]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    cli
    hlt
