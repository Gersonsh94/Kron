default rel
bits 64
global main
extern ExitProcess
extern GetStdHandle
extern WriteFile
extern CreateFileA
extern CloseHandle
extern ReadFile
extern Beep
extern SetConsoleMode
extern ReadConsoleInputA
section .bss
__numbuf: resb 32
__nwritten: resq 1
__chbuf: resb 2
__keybuf: resb 2
__nread: resq 1
__mousebuf: resb 32
__mousex_v: resq 1
__mousey_v: resq 1
section .text
__outname: db 'out.bmp', 0
__save_file:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    sub rsp, 104
    mov rbx, rcx
    mov rsi, rdx
    mov rcx, r8
    mov edx, 0x40000000
    xor r8d, r8d
    xor r9d, r9d
    mov qword [rsp+32], 2
    mov qword [rsp+40], 0x80
    mov qword [rsp+48], 0
    call CreateFileA
    mov rdi, rax
    mov rcx, rdi
    mov rdx, rbx
    mov r8, rsi
    lea r9, [rel __nwritten]
    mov qword [rsp+32], 0
    call WriteFile
    mov rcx, rdi
    call CloseHandle
    add rsp, 104
    pop rdi
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__read_key:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 48
    mov rcx, -10
    call GetStdHandle
    mov rcx, rax
    lea rdx, [rel __keybuf]
    mov r8, 1
    lea r9, [rel __nread]
    mov qword [rsp+32], 0
    call ReadFile
    xor rax, rax
    mov al, [rel __keybuf]
    add rsp, 48
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__read_mouse:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    sub rsp, 40
    mov rcx, -10
    call GetStdHandle
    mov rbx, rax
    mov rcx, rbx
    mov edx, 0x0090
    call SetConsoleMode
__rm_loop:
    mov rcx, rbx
    lea rdx, [rel __mousebuf]
    mov r8, 1
    lea r9, [rel __nread]
    call ReadConsoleInputA
    movzx eax, word [rel __mousebuf]
    cmp eax, 2
    jne __rm_loop
    movzx eax, word [rel __mousebuf+4]
    mov [rel __mousex_v], rax
    movzx eax, word [rel __mousebuf+6]
    mov [rel __mousey_v], rax
    mov eax, [rel __mousebuf+8]
    add rsp, 40
    pop rdi
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__mousex_fn:
    mov rax, [rel __mousex_v]
    ret
__mousey_fn:
    mov rax, [rel __mousey_v]
    ret
__print_str:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    sub rsp, 48
    mov rbx, rcx
    xor rsi, rsi
__ps_len:
    cmp byte [rbx+rsi], 0
    je __ps_go
    inc rsi
    jmp __ps_len
__ps_go:
    test rsi, rsi
    jz __ps_end
    mov rcx, -11
    call GetStdHandle
    mov rcx, rax
    mov rdx, rbx
    mov r8, rsi
    lea r9, [rel __nwritten]
    mov qword [rsp+32], 0
    call WriteFile
__ps_end:
    add rsp, 48
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__print_int:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    sub rsp, 32
    mov rax, rcx
    xor r8, r8
    test rax, rax
    jns .pp
    neg rax
    mov r8, 1
.pp:
    lea rsi, [rel __numbuf+31]
    mov byte [rsi], 10
    dec rsi
    mov rbx, 10
.cv:
    xor rdx, rdx
    div rbx
    add dl, 48
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .cv
    test r8, r8
    jz .ns
    mov byte [rsi], 45
    dec rsi
.ns:
    inc rsi
    lea rax, [rel __numbuf+32]
    sub rax, rsi
    mov rbx, rax
    mov rcx, -11
    call GetStdHandle
    mov rcx, rax
    mov rdx, rsi
    mov r8, rbx
    lea r9, [rel __nwritten]
    sub rsp, 16
    mov qword [rsp+32], 0
    call WriteFile
    add rsp, 16
    add rsp, 32
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
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
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rel __chbuf], cl
    mov byte [rel __chbuf+1], 0
    lea rcx, [rel __chbuf]
    call __print_cstr
    add rsp, 48
    mov rsp, rbp
    pop rbp
    ret
__print_cstr:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    sub rsp, 48
    mov rsi, rcx
    xor rbx, rbx
.cl:
    cmp byte [rsi+rbx], 0
    je .cd
    inc rbx
    jmp .cl
.cd:
    mov rcx, -11
    call GetStdHandle
    mov rcx, rax
    mov rdx, rsi
    mov r8, rbx
    lea r9, [rel __nwritten]
    sub rsp, 16
    mov qword [rsp+32], 0
    call WriteFile
    add rsp, 16
    add rsp, 48
    pop rdi
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
m_pi:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt1: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt1]
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    ret
m_tau:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt3: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt3]
    jmp .__ret_2
.__ret_2:
    mov rsp, rbp
    pop rbp
    ret
m_half_pi:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt5: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt5]
    jmp .__ret_4
.__ret_4:
    mov rsp, rbp
    pop rbp
    ret
fabs:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt9: dq 0.0
section .text
    movsd xmm0, [rel .flt9]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L7
section .data
.flt10: dq 0.0
section .text
    movsd xmm0, [rel .flt10]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_6
    jmp .L8
.L7:
.L8:
    movsd xmm0, [rbp-8]
    jmp .__ret_6
.__ret_6:
    mov rsp, rbp
    pop rbp
    ret
fmin:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L12
    movsd xmm0, [rbp-8]
    jmp .__ret_11
    jmp .L13
.L12:
.L13:
    movsd xmm0, [rbp-16]
    jmp .__ret_11
.__ret_11:
    mov rsp, rbp
    pop rbp
    ret
fmax:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L15
    movsd xmm0, [rbp-8]
    jmp .__ret_14
    jmp .L16
.L15:
.L16:
    movsd xmm0, [rbp-16]
    jmp .__ret_14
.__ret_14:
    mov rsp, rbp
    pop rbp
    ret
fclamp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L18
    movsd xmm0, [rbp-16]
    jmp .__ret_17
    jmp .L19
.L18:
.L19:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L20
    movsd xmm0, [rbp-24]
    jmp .__ret_17
    jmp .L21
.L20:
.L21:
    movsd xmm0, [rbp-8]
    jmp .__ret_17
.__ret_17:
    mov rsp, rbp
    pop rbp
    ret
fsign:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt25: dq 0.0
section .text
    movsd xmm0, [rel .flt25]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L23
section .data
.flt26: dq 1.0
section .text
    movsd xmm0, [rel .flt26]
    jmp .__ret_22
    jmp .L24
.L23:
.L24:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt29: dq 0.0
section .text
    movsd xmm0, [rel .flt29]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L27
section .data
.flt30: dq 0.0
section .text
    movsd xmm0, [rel .flt30]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt31: dq 1.0
section .text
    movsd xmm0, [rel .flt31]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_22
    jmp .L28
.L27:
.L28:
section .data
.flt32: dq 0.0
section .text
    movsd xmm0, [rel .flt32]
    jmp .__ret_22
.__ret_22:
    mov rsp, rbp
    pop rbp
    ret
ffloor:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    cvttsd2si rax, xmm0
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cvtsi2sd xmm0, rax
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L34
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-24], xmm0
    jmp .L35
.L34:
.L35:
    movsd xmm0, [rbp-24]
    jmp .__ret_33
.__ret_33:
    mov rsp, rbp
    pop rbp
    ret
fceil:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    cvttsd2si rax, xmm0
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cvtsi2sd xmm0, rax
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L38
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt40: dq 1.0
section .text
    movsd xmm0, [rel .flt40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-24], xmm0
    jmp .L39
.L38:
.L39:
    movsd xmm0, [rbp-24]
    jmp .__ret_37
.__ret_37:
    mov rsp, rbp
    pop rbp
    ret
fround:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt44: dq 0.0
section .text
    movsd xmm0, [rel .flt44]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L42
section .data
.flt45: dq 0.0
section .text
    movsd xmm0, [rel .flt45]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt46: dq 0.5
section .text
    movsd xmm0, [rel .flt46]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call ffloor
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_41
    jmp .L43
.L42:
.L43:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt47: dq 0.5
section .text
    movsd xmm0, [rel .flt47]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call ffloor
    add rsp, 32
    jmp .__ret_41
.__ret_41:
    mov rsp, rbp
    pop rbp
    ret
fmod:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt51: dq 0.0
section .text
    movsd xmm0, [rel .flt51]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L49
section .data
.flt52: dq 0.0
section .text
    movsd xmm0, [rel .flt52]
    jmp .__ret_48
    jmp .L50
.L49:
.L50:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-24], xmm0
section .data
.flt53: dq 0.0
section .text
    movsd xmm0, [rel .flt53]
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt56: dq 0.0
section .text
    movsd xmm0, [rel .flt56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L54
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fceil
    add rsp, 32
    movsd [rbp-32], xmm0
    jmp .L55
.L54:
.L55:
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt59: dq 0.0
section .text
    movsd xmm0, [rel .flt59]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L57
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call ffloor
    add rsp, 32
    movsd [rbp-32], xmm0
    jmp .L58
.L57:
.L58:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_48
.__ret_48:
    mov rsp, rbp
    pop rbp
    ret
fsqrt:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt63: dq 0.0
section .text
    movsd xmm0, [rel .flt63]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L61
section .data
.flt64: dq 0.0
section .text
    movsd xmm0, [rel .flt64]
    jmp .__ret_60
    jmp .L62
.L61:
.L62:
    movsd xmm0, [rbp-8]
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt67: dq 1.0
section .text
    movsd xmm0, [rel .flt67]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L65
section .data
.flt68: dq 1.0
section .text
    movsd xmm0, [rel .flt68]
    movsd [rbp-16], xmm0
    jmp .L66
.L65:
.L66:
    mov rax, 0
    mov [rbp-24], rax
.L69:
    mov rax, [rbp-24]
    push rax
    mov rax, 40
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L70
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt71: dq 0.5
section .text
    movsd xmm0, [rel .flt71]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-16], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L69
.L70:
    movsd xmm0, [rbp-16]
    jmp .__ret_60
.__ret_60:
    mov rsp, rbp
    pop rbp
    ret
flen2:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_72
.__ret_72:
    mov rsp, rbp
    pop rbp
    ret
flen3:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_73
.__ret_73:
    mov rsp, rbp
    pop rbp
    ret
fwrap_angle:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt75: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt75]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fmod
    add rsp, 32
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt78: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt78]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L76
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt79: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt79]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-16], xmm0
    jmp .L77
.L76:
.L77:
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt82: dq 0.0
section .text
    movsd xmm0, [rel .flt82]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt83: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt83]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L80
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt84: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt84]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-16], xmm0
    jmp .L81
.L80:
.L81:
    movsd xmm0, [rbp-16]
    jmp .__ret_74
.__ret_74:
    mov rsp, rbp
    pop rbp
    ret
fsin:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fwrap_angle
    add rsp, 32
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-16]
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-16]
    movsd [rbp-40], xmm0
section .data
.flt86: dq 0.0
section .text
    movsd xmm0, [rel .flt86]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt87: dq 6.0
section .text
    movsd xmm0, [rel .flt87]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt88: dq 0.0
section .text
    movsd xmm0, [rel .flt88]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt89: dq 20.0
section .text
    movsd xmm0, [rel .flt89]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt90: dq 0.0
section .text
    movsd xmm0, [rel .flt90]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt91: dq 42.0
section .text
    movsd xmm0, [rel .flt91]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt92: dq 0.0
section .text
    movsd xmm0, [rel .flt92]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt93: dq 72.0
section .text
    movsd xmm0, [rel .flt93]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt94: dq 0.0
section .text
    movsd xmm0, [rel .flt94]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt95: dq 110.0
section .text
    movsd xmm0, [rel .flt95]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt96: dq 0.0
section .text
    movsd xmm0, [rel .flt96]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt97: dq 156.0
section .text
    movsd xmm0, [rel .flt97]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt98: dq 0.0
section .text
    movsd xmm0, [rel .flt98]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt99: dq 210.0
section .text
    movsd xmm0, [rel .flt99]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt100: dq 0.0
section .text
    movsd xmm0, [rel .flt100]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt101: dq 272.0
section .text
    movsd xmm0, [rel .flt101]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
section .data
.flt102: dq 0.0
section .text
    movsd xmm0, [rel .flt102]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt103: dq 342.0
section .text
    movsd xmm0, [rel .flt103]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-40]
    jmp .__ret_85
.__ret_85:
    mov rsp, rbp
    pop rbp
    ret
fcos:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt105: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt105]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    jmp .__ret_104
.__ret_104:
    mov rsp, rbp
    pop rbp
    ret
ftan:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt109: dq 0.0
section .text
    movsd xmm0, [rel .flt109]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L107
section .data
.flt110: dq 0.0
section .text
    movsd xmm0, [rel .flt110]
    jmp .__ret_106
    jmp .L108
.L107:
.L108:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_106
.__ret_106:
    mov rsp, rbp
    pop rbp
    ret
fpowi:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    mov [rbp-16], rdx
section .data
.flt112: dq 1.0
section .text
    movsd xmm0, [rel .flt112]
    movsd [rbp-24], xmm0
    mov rax, 0
    mov [rbp-32], rax
.L113:
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L114
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-24], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L113
.L114:
    movsd xmm0, [rbp-24]
    jmp .__ret_111
.__ret_111:
    mov rsp, rbp
    pop rbp
    ret
deg_to_rad:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt116: dq 0.01745329251994329577
section .text
    movsd xmm0, [rel .flt116]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_115
.__ret_115:
    mov rsp, rbp
    pop rbp
    ret
rad_to_deg:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt118: dq 57.29577951308232087680
section .text
    movsd xmm0, [rel .flt118]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_117
.__ret_117:
    mov rsp, rbp
    pop rbp
    ret
flerp:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_119
.__ret_119:
    mov rsp, rbp
    pop rbp
    ret
fdot3:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd [rbp-40], xmm4
    movsd [rbp-48], xmm5
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_120
.__ret_120:
    mov rsp, rbp
    pop rbp
    ret
vec3_length:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_121
.__ret_121:
    mov rsp, rbp
    pop rbp
    ret
vec3_length2:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_122
.__ret_122:
    mov rsp, rbp
    pop rbp
    ret
vec3_distance:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd [rbp-40], xmm4
    movsd [rbp-48], xmm5
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-56], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-64], xmm0
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-72], xmm0
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-64]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-64]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-72]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-72]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_123
.__ret_123:
    mov rsp, rbp
    pop rbp
    ret
vec3_dot:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd [rbp-40], xmm4
    movsd [rbp-48], xmm5
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_124
.__ret_124:
    mov rsp, rbp
    pop rbp
    ret
vec3_cross_x:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_125
.__ret_125:
    mov rsp, rbp
    pop rbp
    ret
vec3_cross_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_126
.__ret_126:
    mov rsp, rbp
    pop rbp
    ret
vec3_cross_z:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_127
.__ret_127:
    mov rsp, rbp
    pop rbp
    ret
vec3_norm_x:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call vec3_length
    add rsp, 32
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt131: dq 0.0
section .text
    movsd xmm0, [rel .flt131]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L129
section .data
.flt132: dq 0.0
section .text
    movsd xmm0, [rel .flt132]
    jmp .__ret_128
    jmp .L130
.L129:
.L130:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_128
.__ret_128:
    mov rsp, rbp
    pop rbp
    ret
vec3_norm_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call vec3_length
    add rsp, 32
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt136: dq 0.0
section .text
    movsd xmm0, [rel .flt136]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L134
section .data
.flt137: dq 0.0
section .text
    movsd xmm0, [rel .flt137]
    jmp .__ret_133
    jmp .L135
.L134:
.L135:
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_133
.__ret_133:
    mov rsp, rbp
    pop rbp
    ret
vec3_norm_z:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call vec3_length
    add rsp, 32
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt141: dq 0.0
section .text
    movsd xmm0, [rel .flt141]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L139
section .data
.flt142: dq 0.0
section .text
    movsd xmm0, [rel .flt142]
    jmp .__ret_138
    jmp .L140
.L139:
.L140:
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_138
.__ret_138:
    mov rsp, rbp
    pop rbp
    ret
rot_y_x:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_143
.__ret_143:
    mov rsp, rbp
    pop rbp
    ret
rot_y_z:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_144
.__ret_144:
    mov rsp, rbp
    pop rbp
    ret
rot_x_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_145
.__ret_145:
    mov rsp, rbp
    pop rbp
    ret
rot_x_z:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_146
.__ret_146:
    mov rsp, rbp
    pop rbp
    ret
rot_z_x:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_147
.__ret_147:
    mov rsp, rbp
    pop rbp
    ret
rot_z_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_148
.__ret_148:
    mov rsp, rbp
    pop rbp
    ret
proj_x:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd [rbp-40], xmm4
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-48], xmm0
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt152: dq 0.0
section .text
    movsd xmm0, [rel .flt152]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L150
    movsd xmm0, [rbp-40]
    jmp .__ret_149
    jmp .L151
.L150:
.L151:
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_149
.__ret_149:
    mov rsp, rbp
    pop rbp
    ret
proj_y:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd [rbp-40], xmm4
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-48], xmm0
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt156: dq 0.0
section .text
    movsd xmm0, [rel .flt156]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L154
    movsd xmm0, [rbp-40]
    jmp .__ret_153
    jmp .L155
.L154:
.L155:
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_153
.__ret_153:
    mov rsp, rbp
    pop rbp
    ret
proj_depth:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_157
.__ret_157:
    mov rsp, rbp
    pop rbp
    ret
edge_cross:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_158
.__ret_158:
    mov rsp, rbp
    pop rbp
    ret
section .bss
__g_buf: resq 3757
section .text
section .bss
__g_zb: resq 10000
section .text
section .bss
__g_vx: resq 8
section .text
section .bss
__g_vy: resq 8
section .text
section .bss
__g_vz: resq 8
section .text
section .bss
__g_sx: resq 8
section .text
section .bss
__g_sy: resq 8
section .text
section .bss
__g_sz: resq 8
section .text
section .bss
__g_t0: resq 12
section .text
section .bss
__g_t1: resq 12
section .text
section .bss
__g_t2: resq 12
section .text
section .bss
__g_tr: resq 12
section .text
section .bss
__g_tg: resq 12
section .text
section .bss
__g_tb: resq 12
section .text
write_bmp_header:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 66
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 77
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-8]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 30054
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 6
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 10
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 54
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 14
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 40
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 18
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 100
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 22
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 100
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 26
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, [rbp-8]
    push rax
    mov rax, 28
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 24
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, [rbp-8]
    push rax
    mov rax, 30
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 34
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 30000
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 38
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 42
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 46
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 50
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rbp-8]
    push rax
    mov rax, 54
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_159
.__ret_159:
    mov rsp, rbp
    pop rbp
    ret
put_pixel:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov [rbp-32], r9
    mov [rbp-40], r10
    mov [rbp-48], rax
    mov rax, [rbp-8]
    push rax
    mov rax, 99
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, 300
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-16]
    push rax
    mov rax, 3
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-56], rax
    mov rax, [rbp-56]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-48]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-56]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-40]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-56]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-32]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-56]
    jmp .__ret_160
.__ret_160:
    mov rsp, rbp
    pop rbp
    ret
clear_scene:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rcx
    mov rax, 0
    mov [rbp-16], rax
.L162:
    mov rax, [rbp-16]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L163
    mov rax, 0
    mov [rbp-24], rax
.L164:
    mov rax, [rbp-24]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L165
    mov rax, [rbp-8]
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-16]
    push rax
    mov rax, 12
    push rax
    mov rax, 15
    push rax
    mov rax, 40
    push rax
    pop rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call put_pixel
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
section .data
.flt166: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt166]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L164
.L165:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L162
.L163:
    mov rax, [rbp-8]
    jmp .__ret_161
.__ret_161:
    mov rsp, rbp
    pop rbp
    ret
build_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    push rax
section .data
.flt168: dq 0.0
section .text
    movsd xmm0, [rel .flt168]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt169: dq 1.0
section .text
    movsd xmm0, [rel .flt169]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
section .data
.flt170: dq 0.0
section .text
    movsd xmm0, [rel .flt170]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt171: dq 1.0
section .text
    movsd xmm0, [rel .flt171]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
section .data
.flt172: dq 0.0
section .text
    movsd xmm0, [rel .flt172]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt173: dq 1.0
section .text
    movsd xmm0, [rel .flt173]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt174: dq 1.0
section .text
    movsd xmm0, [rel .flt174]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt175: dq 0.0
section .text
    movsd xmm0, [rel .flt175]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt176: dq 1.0
section .text
    movsd xmm0, [rel .flt176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt177: dq 0.0
section .text
    movsd xmm0, [rel .flt177]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt178: dq 1.0
section .text
    movsd xmm0, [rel .flt178]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt179: dq 1.0
section .text
    movsd xmm0, [rel .flt179]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt180: dq 1.0
section .text
    movsd xmm0, [rel .flt180]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt181: dq 0.0
section .text
    movsd xmm0, [rel .flt181]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt182: dq 1.0
section .text
    movsd xmm0, [rel .flt182]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt183: dq 0.0
section .text
    movsd xmm0, [rel .flt183]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt184: dq 1.0
section .text
    movsd xmm0, [rel .flt184]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt185: dq 1.0
section .text
    movsd xmm0, [rel .flt185]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt186: dq 0.0
section .text
    movsd xmm0, [rel .flt186]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt187: dq 1.0
section .text
    movsd xmm0, [rel .flt187]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt188: dq 0.0
section .text
    movsd xmm0, [rel .flt188]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt189: dq 1.0
section .text
    movsd xmm0, [rel .flt189]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt190: dq 0.0
section .text
    movsd xmm0, [rel .flt190]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt191: dq 1.0
section .text
    movsd xmm0, [rel .flt191]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt192: dq 1.0
section .text
    movsd xmm0, [rel .flt192]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt193: dq 1.0
section .text
    movsd xmm0, [rel .flt193]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt194: dq 0.0
section .text
    movsd xmm0, [rel .flt194]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt195: dq 1.0
section .text
    movsd xmm0, [rel .flt195]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt196: dq 1.0
section .text
    movsd xmm0, [rel .flt196]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt197: dq 1.0
section .text
    movsd xmm0, [rel .flt197]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt198: dq 1.0
section .text
    movsd xmm0, [rel .flt198]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt199: dq 1.0
section .text
    movsd xmm0, [rel .flt199]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt200: dq 0.0
section .text
    movsd xmm0, [rel .flt200]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt201: dq 1.0
section .text
    movsd xmm0, [rel .flt201]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt202: dq 1.0
section .text
    movsd xmm0, [rel .flt202]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt203: dq 1.0
section .text
    movsd xmm0, [rel .flt203]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 0
    jmp .__ret_167
.__ret_167:
    mov rsp, rbp
    pop rbp
    ret
pose_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    mov rax, 0
    mov [rbp-24], rax
.L205:
    mov rax, [rbp-24]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L206
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rot_x_y
    add rsp, 32
    movsd [rbp-32], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rot_x_z
    add rsp, 32
    movsd [rbp-40], xmm0
    mov rax, [rbp-24]
    push rax
    movsd xmm0, [rbp-32]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    movsd xmm0, [rbp-40]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L205
.L206:
    mov rax, 0
    mov [rbp-24], rax
.L207:
    mov rax, [rbp-24]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L208
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rot_y_x
    add rsp, 32
    movsd [rbp-48], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rot_y_z
    add rsp, 32
    movsd [rbp-40], xmm0
    mov rax, [rbp-24]
    push rax
    movsd xmm0, [rbp-48]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    movsd xmm0, [rbp-40]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L207
.L208:
    mov rax, 0
    jmp .__ret_204
.__ret_204:
    mov rsp, rbp
    pop rbp
    ret
project_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov [rbp-8], rax
.L210:
    mov rax, [rbp-8]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L211
    mov rax, [rbp-8]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt212: dq 4.0
section .text
    movsd xmm0, [rel .flt212]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt213: dq 90.0
section .text
    movsd xmm0, [rel .flt213]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt214: dq 50.0
section .text
    movsd xmm0, [rel .flt214]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm4, [rsp]
    add rsp, 8
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call proj_x
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_sx]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-8]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt215: dq 4.0
section .text
    movsd xmm0, [rel .flt215]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt216: dq 90.0
section .text
    movsd xmm0, [rel .flt216]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt217: dq 50.0
section .text
    movsd xmm0, [rel .flt217]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm4, [rsp]
    add rsp, 8
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call proj_y
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_sy]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-8]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt218: dq 4.0
section .text
    movsd xmm0, [rel .flt218]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call proj_depth
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_sz]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-8], rax
    jmp .L210
.L211:
    mov rax, 0
    jmp .__ret_209
.__ret_209:
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 288
    lea rax, [rel __g_buf]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call write_bmp_header
    add rsp, 32
    mov [rbp-16], rax
    sub rsp, 32
    call build_cube
    add rsp, 32
section .data
.flt220: dq 0.55
section .text
    movsd xmm0, [rel .flt220]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt221: dq 0.8
section .text
    movsd xmm0, [rel .flt221]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call pose_cube
    add rsp, 32
    sub rsp, 32
    call project_cube
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
    call clear_scene
    add rsp, 32
    mov rax, 0
    mov [rbp-24], rax
.L222:
    mov rax, [rbp-24]
    push rax
    mov rax, 12
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L223
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_t0]
    mov rax, [rdx+rcx*8]
    mov [rbp-32], rax
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_t1]
    mov rax, [rdx+rcx*8]
    mov [rbp-40], rax
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_t2]
    mov rax, [rdx+rcx*8]
    mov [rbp-48], rax
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-56], xmm0
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-64], xmm0
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-72], xmm0
    mov rax, [rbp-40]
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-80], xmm0
    mov rax, [rbp-40]
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-88], xmm0
    mov rax, [rbp-40]
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-96], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-104], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-112], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-120], xmm0
    movsd xmm0, [rbp-80]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-128], xmm0
    movsd xmm0, [rbp-88]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-64]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-136], xmm0
    movsd xmm0, [rbp-104]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-80]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-144], xmm0
    movsd xmm0, [rbp-112]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-88]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-152], xmm0
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-104]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-160], xmm0
    movsd xmm0, [rbp-64]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-168], xmm0
    movsd xmm0, [rbp-128]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-136]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-104]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-64]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call edge_cross
    add rsp, 32
    movsd [rbp-176], xmm0
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fabs
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt226: dq 0.5
section .text
    movsd xmm0, [rel .flt226]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L224
    mov rax, 0
    mov [rbp-184], rax
.L227:
    mov rax, [rbp-184]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L228
    mov rax, 0
    mov [rbp-192], rax
.L229:
    mov rax, [rbp-192]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L230
    mov rax, [rbp-192]
    cvtsi2sd xmm0, rax
    movsd [rbp-200], xmm0
    mov rax, [rbp-184]
    cvtsi2sd xmm0, rax
    movsd [rbp-208], xmm0
    movsd xmm0, [rbp-128]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-136]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-200]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-208]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-64]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call edge_cross
    add rsp, 32
    movsd [rbp-216], xmm0
    movsd xmm0, [rbp-144]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-200]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-80]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-208]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-88]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call edge_cross
    add rsp, 32
    movsd [rbp-224], xmm0
    movsd xmm0, [rbp-160]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-168]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-200]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-104]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-208]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call edge_cross
    add rsp, 32
    movsd [rbp-232], xmm0
    mov rax, 0
    mov [rbp-240], rax
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt233: dq 0.0
section .text
    movsd xmm0, [rel .flt233]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L231
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt240: dq 0.0
section .text
    movsd xmm0, [rel .flt240]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L238
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt241: dq 0.0
section .text
    movsd xmm0, [rel .flt241]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
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
    movsd xmm0, [rbp-232]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt242: dq 0.0
section .text
    movsd xmm0, [rel .flt242]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
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
    mov rax, 1
    mov [rbp-240], rax
    jmp .L235
.L234:
.L235:
    jmp .L232
.L231:
.L232:
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt245: dq 0.0
section .text
    movsd xmm0, [rel .flt245]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L243
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt252: dq 0.0
section .text
    movsd xmm0, [rel .flt252]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L250
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt253: dq 0.0
section .text
    movsd xmm0, [rel .flt253]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
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
    movsd xmm0, [rbp-232]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt254: dq 0.0
section .text
    movsd xmm0, [rel .flt254]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L248
    mov rax, 1
    jmp .L249
.L248:
    mov rax, 0
.L249:
    test rax, rax
    jz .L246
    mov rax, 1
    mov [rbp-240], rax
    jmp .L247
.L246:
.L247:
    jmp .L244
.L243:
.L244:
    mov rax, [rbp-240]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L255
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-72]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-96]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-232]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-120]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-248], xmm0
    mov rax, [rbp-184]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-192]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-256], rax
    movsd xmm0, [rbp-248]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rel __g_zb]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L257
    mov rax, [rbp-256]
    push rax
    movsd xmm0, [rbp-248]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-192]
    push rax
    mov rax, [rbp-184]
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_tr]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_tg]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_tb]
    mov rax, [rdx+rcx*8]
    push rax
    pop rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call put_pixel
    add rsp, 32
    jmp .L258
.L257:
.L258:
    jmp .L256
.L255:
.L256:
    mov rax, [rbp-192]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-192], rax
    jmp .L229
.L230:
    mov rax, [rbp-184]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-184], rax
    jmp .L227
.L228:
    jmp .L225
.L224:
.L225:
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L222
.L223:
section .data
.str259: db 99,117,98,101,46,98,109,112,0
section .text
    lea rax, [rel .str259]
    push rax
    mov rax, [rbp-8]
    push rax
    mov rax, 30054
    mov rdx, rax
    pop rcx
    pop r8
    sub rsp, 32
    call __save_file
    add rsp, 32
    mov rax, 30054
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_219
.__ret_219:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
