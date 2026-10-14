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
m_e:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt122: dq 2.71828182845904523536
section .text
    movsd xmm0, [rel .flt122]
    jmp .__ret_121
.__ret_121:
    mov rsp, rbp
    pop rbp
    ret
m_ln2:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt124: dq 0.69314718055994530942
section .text
    movsd xmm0, [rel .flt124]
    jmp .__ret_123
.__ret_123:
    mov rsp, rbp
    pop rbp
    ret
m_log2e:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt126: dq 1.44269504088896340736
section .text
    movsd xmm0, [rel .flt126]
    jmp .__ret_125
.__ret_125:
    mov rsp, rbp
    pop rbp
    ret
m_inf:
    push rbp
    mov rbp, rsp
    sub rsp, 48
section .data
.flt128: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt128]
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_127
.__ret_127:
    mov rsp, rbp
    pop rbp
    ret
fexp:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt132: dq 709.0
section .text
    movsd xmm0, [rel .flt132]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L130
    sub rsp, 32
    call m_inf
    add rsp, 32
    jmp .__ret_129
    jmp .L131
.L130:
.L131:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt135: dq 0.0
section .text
    movsd xmm0, [rel .flt135]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt136: dq 745.0
section .text
    movsd xmm0, [rel .flt136]
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
    jz .L133
section .data
.flt137: dq 0.0
section .text
    movsd xmm0, [rel .flt137]
    jmp .__ret_129
    jmp .L134
.L133:
.L134:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call m_log2e
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fround
    add rsp, 32
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    cvttsd2si rax, xmm0
    mov [rbp-24], rax
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call m_ln2
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
section .data
.flt138: dq 1.0
section .text
    movsd xmm0, [rel .flt138]
    movsd [rbp-40], xmm0
section .data
.flt139: dq 1.0
section .text
    movsd xmm0, [rel .flt139]
    movsd [rbp-48], xmm0
section .data
.flt140: dq 0.0
section .text
    movsd xmm0, [rel .flt140]
    movsd [rbp-56], xmm0
    mov rax, 1
    mov [rbp-64], rax
.L141:
    mov rax, [rbp-64]
    push rax
    mov rax, 11
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L142
    mov rax, [rbp-64]
    cvtsi2sd xmm0, rax
    movsd [rbp-56], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-48], xmm0
    mov rax, [rbp-64]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-64], rax
    jmp .L141
.L142:
    mov rax, [rbp-24]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L143
    mov rax, 0
    mov [rbp-64], rax
.L145:
    mov rax, [rbp-64]
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L146
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt147: dq 2.0
section .text
    movsd xmm0, [rel .flt147]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-48], xmm0
    mov rax, [rbp-64]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-64], rax
    jmp .L145
.L146:
    jmp .L144
.L143:
    mov rax, 0
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rbp-72], rax
    mov rax, 0
    mov [rbp-64], rax
.L148:
    mov rax, [rbp-64]
    push rax
    mov rax, [rbp-72]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L149
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt150: dq 0.5
section .text
    movsd xmm0, [rel .flt150]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-48], xmm0
    mov rax, [rbp-64]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-64], rax
    jmp .L148
.L149:
.L144:
    movsd xmm0, [rbp-48]
    jmp .__ret_129
.__ret_129:
    mov rsp, rbp
    pop rbp
    ret
fln:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt154: dq 0.0
section .text
    movsd xmm0, [rel .flt154]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L152
section .data
.flt155: dq 0.0
section .text
    movsd xmm0, [rel .flt155]
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call m_inf
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_151
    jmp .L153
.L152:
.L153:
    movsd xmm0, [rbp-8]
    movsd [rbp-16], xmm0
    mov rax, 0
    mov [rbp-24], rax
.L156:
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt158: dq 1.41421356237309504880
section .text
    movsd xmm0, [rel .flt158]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L157
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt159: dq 0.5
section .text
    movsd xmm0, [rel .flt159]
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
    jmp .L156
.L157:
.L160:
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt162: dq 0.70710678118654752440
section .text
    movsd xmm0, [rel .flt162]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L161
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt163: dq 2.0
section .text
    movsd xmm0, [rel .flt163]
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
    sub rax, rcx
    mov [rbp-24], rax
    jmp .L160
.L161:
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt164: dq 1.0
section .text
    movsd xmm0, [rel .flt164]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt165: dq 1.0
section .text
    movsd xmm0, [rel .flt165]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-32]
    movsd [rbp-48], xmm0
    movsd xmm0, [rbp-32]
    movsd [rbp-56], xmm0
section .data
.flt166: dq 0.0
section .text
    movsd xmm0, [rel .flt166]
    movsd [rbp-64], xmm0
    mov rax, 1
    mov [rbp-72], rax
.L167:
    mov rax, [rbp-72]
    push rax
    mov rax, 9
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L168
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-48], xmm0
    mov rax, 2
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-72]
    cvtsi2sd xmm0, rax
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-64], xmm0
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-64]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-56], xmm0
    mov rax, [rbp-72]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-72], rax
    jmp .L167
.L168:
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt169: dq 2.0
section .text
    movsd xmm0, [rel .flt169]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-56], xmm0
    mov rax, [rbp-24]
    cvtsi2sd xmm0, rax
    movsd [rbp-80], xmm0
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-80]
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call m_ln2
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_151
.__ret_151:
    mov rsp, rbp
    pop rbp
    ret
flog10:
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
    call fln
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt171: dq 0.43429448190325182765
section .text
    movsd xmm0, [rel .flt171]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_170
.__ret_170:
    mov rsp, rbp
    pop rbp
    ret
flog2:
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
    call fln
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call m_log2e
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_172
.__ret_172:
    mov rsp, rbp
    pop rbp
    ret
fpow:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt176: dq 0.0
section .text
    movsd xmm0, [rel .flt176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L174
section .data
.flt177: dq 0.0
section .text
    movsd xmm0, [rel .flt177]
    jmp .__ret_173
    jmp .L175
.L174:
.L175:
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fln
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fexp
    add rsp, 32
    jmp .__ret_173
.__ret_173:
    mov rsp, rbp
    pop rbp
    ret
sigmoid:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt181: dq 0.0
section .text
    movsd xmm0, [rel .flt181]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L179
section .data
.flt182: dq 0.0
section .text
    movsd xmm0, [rel .flt182]
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
    call fexp
    add rsp, 32
    movsd [rbp-16], xmm0
section .data
.flt183: dq 1.0
section .text
    movsd xmm0, [rel .flt183]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt184: dq 1.0
section .text
    movsd xmm0, [rel .flt184]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_178
    jmp .L180
.L179:
.L180:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fexp
    add rsp, 32
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt185: dq 1.0
section .text
    movsd xmm0, [rel .flt185]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_178
.__ret_178:
    mov rsp, rbp
    pop rbp
    ret
sigmoid_d:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt187: dq 1.0
section .text
    movsd xmm0, [rel .flt187]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_186
.__ret_186:
    mov rsp, rbp
    pop rbp
    ret
ftanh:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt191: dq 20.0
section .text
    movsd xmm0, [rel .flt191]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L189
section .data
.flt192: dq 1.0
section .text
    movsd xmm0, [rel .flt192]
    jmp .__ret_188
    jmp .L190
.L189:
.L190:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt195: dq 0.0
section .text
    movsd xmm0, [rel .flt195]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt196: dq 20.0
section .text
    movsd xmm0, [rel .flt196]
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
    jz .L193
section .data
.flt197: dq 0.0
section .text
    movsd xmm0, [rel .flt197]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt198: dq 1.0
section .text
    movsd xmm0, [rel .flt198]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_188
    jmp .L194
.L193:
.L194:
section .data
.flt199: dq 2.0
section .text
    movsd xmm0, [rel .flt199]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fexp
    add rsp, 32
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt200: dq 1.0
section .text
    movsd xmm0, [rel .flt200]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt201: dq 1.0
section .text
    movsd xmm0, [rel .flt201]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_188
.__ret_188:
    mov rsp, rbp
    pop rbp
    ret
tanh_d:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
section .data
.flt203: dq 1.0
section .text
    movsd xmm0, [rel .flt203]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_202
.__ret_202:
    mov rsp, rbp
    pop rbp
    ret
relu:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt207: dq 0.0
section .text
    movsd xmm0, [rel .flt207]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L205
    movsd xmm0, [rbp-8]
    jmp .__ret_204
    jmp .L206
.L205:
.L206:
section .data
.flt208: dq 0.0
section .text
    movsd xmm0, [rel .flt208]
    jmp .__ret_204
.__ret_204:
    mov rsp, rbp
    pop rbp
    ret
relu_d:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt212: dq 0.0
section .text
    movsd xmm0, [rel .flt212]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L210
section .data
.flt213: dq 1.0
section .text
    movsd xmm0, [rel .flt213]
    jmp .__ret_209
    jmp .L211
.L210:
.L211:
section .data
.flt214: dq 0.0
section .text
    movsd xmm0, [rel .flt214]
    jmp .__ret_209
.__ret_209:
    mov rsp, rbp
    pop rbp
    ret
cross_entropy:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt216: dq 0.0000000001
section .text
    movsd xmm0, [rel .flt216]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt217: dq 0.9999999999
section .text
    movsd xmm0, [rel .flt217]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fclamp
    add rsp, 32
    movsd [rbp-24], xmm0
section .data
.flt218: dq 0.0
section .text
    movsd xmm0, [rel .flt218]
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
    call fln
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt219: dq 1.0
section .text
    movsd xmm0, [rel .flt219]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt220: dq 1.0
section .text
    movsd xmm0, [rel .flt220]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fln
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_215
.__ret_215:
    mov rsp, rbp
    pop rbp
    ret
squared_error:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_221
.__ret_221:
    mov rsp, rbp
    pop rbp
    ret
section .bss
__g_st_x: resq 1024
section .text
section .bss
__g_st_y: resq 1024
section .text
section .data
__g_st_n: dq 0
section .text
section .data
__g_st_ny: dq 0
section .text
section .bss
__g_st_sorted: resq 1024
section .text
st_clear:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    mov [rel __g_st_n], rax
    mov rax, 0
    mov [rel __g_st_ny], rax
    mov rax, 0
    jmp .__ret_222
.__ret_222:
    mov rsp, rbp
    pop rbp
    ret
st_push:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 1024
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L224
    mov rax, [rel __g_st_n]
    push rax
    movsd xmm0, [rbp-8]
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_st_n], rax
    jmp .L225
.L224:
.L225:
    mov rax, 0
    jmp .__ret_223
.__ret_223:
    mov rsp, rbp
    pop rbp
    ret
st_push_y:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    mov rax, [rel __g_st_ny]
    push rax
    mov rax, 1024
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L227
    mov rax, [rel __g_st_ny]
    push rax
    movsd xmm0, [rbp-8]
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_ny]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_st_ny], rax
    jmp .L228
.L227:
.L228:
    mov rax, 0
    jmp .__ret_226
.__ret_226:
    mov rsp, rbp
    pop rbp
    ret
st_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_st_n]
    jmp .__ret_229
.__ret_229:
    mov rsp, rbp
    pop rbp
    ret
st_get:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_230
.__ret_230:
    mov rsp, rbp
    pop rbp
    ret
st_min:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    mov rax, 1
    mov [rbp-16], rax
.L232:
    mov rax, [rbp-16]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L233
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
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
    jz .L234
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    jmp .L235
.L234:
.L235:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L232
.L233:
    movsd xmm0, [rbp-8]
    jmp .__ret_231
.__ret_231:
    mov rsp, rbp
    pop rbp
    ret
st_max:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    mov rax, 1
    mov [rbp-16], rax
.L237:
    mov rax, [rbp-16]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L238
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
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
    jz .L239
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    jmp .L240
.L239:
.L240:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L237
.L238:
    movsd xmm0, [rbp-8]
    jmp .__ret_236
.__ret_236:
    mov rsp, rbp
    pop rbp
    ret
st_range:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_max
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call st_min
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_241
.__ret_241:
    mov rsp, rbp
    pop rbp
    ret
st_sum:
    push rbp
    mov rbp, rsp
    sub rsp, 48
section .data
.flt243: dq 0.0
section .text
    movsd xmm0, [rel .flt243]
    movsd [rbp-8], xmm0
    mov rax, 0
    mov [rbp-16], rax
.L244:
    mov rax, [rbp-16]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L245
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-8], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L244
.L245:
    movsd xmm0, [rbp-8]
    jmp .__ret_242
.__ret_242:
    mov rsp, rbp
    pop rbp
    ret
st_mean:
    push rbp
    mov rbp, rsp
    sub rsp, 48
section .data
.flt247: dq 0.0
section .text
    movsd xmm0, [rel .flt247]
    movsd [rbp-8], xmm0
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd [rbp-8], xmm0
    sub rsp, 32
    call st_sum
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_246
.__ret_246:
    mov rsp, rbp
    pop rbp
    ret
st_var:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
section .data
.flt249: dq 0.0
section .text
    movsd xmm0, [rel .flt249]
    movsd [rbp-16], xmm0
section .data
.flt250: dq 0.0
section .text
    movsd xmm0, [rel .flt250]
    movsd [rbp-24], xmm0
    mov rax, 0
    mov [rbp-32], rax
.L251:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L252
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-16]
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
    movsd [rbp-16], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L251
.L252:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_248
.__ret_248:
    mov rsp, rbp
    pop rbp
    ret
st_var_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
section .data
.flt254: dq 0.0
section .text
    movsd xmm0, [rel .flt254]
    movsd [rbp-16], xmm0
section .data
.flt255: dq 0.0
section .text
    movsd xmm0, [rel .flt255]
    movsd [rbp-24], xmm0
    mov rax, 0
    mov [rbp-32], rax
.L256:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L257
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-16]
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
    movsd [rbp-16], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L256
.L257:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_253
.__ret_253:
    mov rsp, rbp
    pop rbp
    ret
st_stddev:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_var
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_258
.__ret_258:
    mov rsp, rbp
    pop rbp
    ret
st_stddev_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_var_sample
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_259
.__ret_259:
    mov rsp, rbp
    pop rbp
    ret
st_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 64
section .data
.flt261: dq 0.0
section .text
    movsd xmm0, [rel .flt261]
    movsd [rbp-8], xmm0
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
.L262:
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L263
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L262
.L263:
    mov rax, 1
    mov [rbp-24], rax
.L264:
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L265
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rbp-16], rax
.L266:
    mov rax, [rbp-16]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L268
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
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
    jz .L268
    mov rax, 1
    jmp .L269
.L268:
    mov rax, 0
.L269:
    test rax, rax
    jz .L267
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rbp-16], rax
    jmp .L266
.L267:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    movsd xmm0, [rbp-8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L264
.L265:
    mov rax, 0
    jmp .__ret_260
.__ret_260:
    mov rsp, rbp
    pop rbp
    ret
st_sorted_at:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_270
.__ret_270:
    mov rsp, rbp
    pop rbp
    ret
st_median:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov rax, 0
    mov [rbp-8], rax
section .data
.flt272: dq 0.0
section .text
    movsd xmm0, [rel .flt272]
    movsd [rbp-16], xmm0
section .data
.flt273: dq 0.0
section .text
    movsd xmm0, [rel .flt273]
    movsd [rbp-24], xmm0
    sub rsp, 32
    call st_sort
    add rsp, 32
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov [rbp-8], rax
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov rax, rdx
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L274
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_271
    jmp .L275
.L274:
.L275:
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-16], xmm0
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt276: dq 2.0
section .text
    movsd xmm0, [rel .flt276]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_271
.__ret_271:
    mov rsp, rbp
    pop rbp
    ret
st_percentile:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
section .data
.flt278: dq 0.0
section .text
    movsd xmm0, [rel .flt278]
    movsd [rbp-16], xmm0
    mov rax, 0
    mov [rbp-24], rax
section .data
.flt279: dq 0.0
section .text
    movsd xmm0, [rel .flt279]
    movsd [rbp-32], xmm0
section .data
.flt280: dq 0.0
section .text
    movsd xmm0, [rel .flt280]
    movsd [rbp-40], xmm0
    sub rsp, 32
    call st_sort
    add rsp, 32
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cvtsi2sd xmm0, rax
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt281: dq 100.0
section .text
    movsd xmm0, [rel .flt281]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call ffloor
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L282
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_277
    jmp .L283
.L282:
.L283:
    mov rax, [rbp-24]
    cvtsi2sd xmm0, rax
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-32], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_277
.__ret_277:
    mov rsp, rbp
    pop rbp
    ret
st_q1:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt285: dq 25.0
section .text
    movsd xmm0, [rel .flt285]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    jmp .__ret_284
.__ret_284:
    mov rsp, rbp
    pop rbp
    ret
st_q3:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt287: dq 75.0
section .text
    movsd xmm0, [rel .flt287]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    jmp .__ret_286
.__ret_286:
    mov rsp, rbp
    pop rbp
    ret
st_iqr:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_q3
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call st_q1
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_288
.__ret_288:
    mov rsp, rbp
    pop rbp
    ret
st_mode:
    push rbp
    mov rbp, rsp
    sub rsp, 64
section .data
.flt290: dq 0.0
section .text
    movsd xmm0, [rel .flt290]
    movsd [rbp-8], xmm0
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 1
    mov [rbp-24], rax
    sub rsp, 32
    call st_sort
    add rsp, 32
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    mov rax, 1
    mov [rbp-32], rax
.L291:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L292
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L293
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L294
.L293:
    mov rax, 1
    mov [rbp-24], rax
.L294:
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L295
    mov rax, [rbp-24]
    mov [rbp-16], rax
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    jmp .L296
.L295:
.L296:
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L291
.L292:
    movsd xmm0, [rbp-8]
    jmp .__ret_289
.__ret_289:
    mov rsp, rbp
    pop rbp
    ret
st_mean_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
section .data
.flt298: dq 0.0
section .text
    movsd xmm0, [rel .flt298]
    movsd [rbp-8], xmm0
section .data
.flt299: dq 0.0
section .text
    movsd xmm0, [rel .flt299]
    movsd [rbp-16], xmm0
    mov rax, 0
    mov [rbp-24], rax
.L300:
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_ny]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L301
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-24]
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-8], xmm0
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L300
.L301:
    mov rax, [rel __g_st_ny]
    cvtsi2sd xmm0, rax
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_297
.__ret_297:
    mov rsp, rbp
    pop rbp
    ret
st_covar:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
    sub rsp, 32
    call st_mean_y
    add rsp, 32
    movsd [rbp-16], xmm0
section .data
.flt303: dq 0.0
section .text
    movsd xmm0, [rel .flt303]
    movsd [rbp-24], xmm0
section .data
.flt304: dq 0.0
section .text
    movsd xmm0, [rel .flt304]
    movsd [rbp-32], xmm0
    mov rax, 0
    mov [rbp-40], rax
.L305:
    mov rax, [rbp-40]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L306
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-40]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-40]
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-24], xmm0
    mov rax, [rbp-40]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-40], rax
    jmp .L305
.L306:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_302
.__ret_302:
    mov rsp, rbp
    pop rbp
    ret
st_corr:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
    sub rsp, 32
    call st_mean_y
    add rsp, 32
    movsd [rbp-16], xmm0
section .data
.flt308: dq 0.0
section .text
    movsd xmm0, [rel .flt308]
    movsd [rbp-24], xmm0
section .data
.flt309: dq 0.0
section .text
    movsd xmm0, [rel .flt309]
    movsd [rbp-32], xmm0
section .data
.flt310: dq 0.0
section .text
    movsd xmm0, [rel .flt310]
    movsd [rbp-40], xmm0
section .data
.flt311: dq 0.0
section .text
    movsd xmm0, [rel .flt311]
    movsd [rbp-48], xmm0
section .data
.flt312: dq 0.0
section .text
    movsd xmm0, [rel .flt312]
    movsd [rbp-56], xmm0
    mov rax, 0
    mov [rbp-64], rax
.L313:
    mov rax, [rbp-64]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L314
    mov rax, [rbp-64]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-48], xmm0
    mov rax, [rbp-64]
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-56], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
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
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
    mov rax, [rbp-64]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-64], rax
    jmp .L313
.L314:
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_307
.__ret_307:
    mov rsp, rbp
    pop rbp
    ret
linreg_slope:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
    sub rsp, 32
    call st_mean_y
    add rsp, 32
    movsd [rbp-16], xmm0
section .data
.flt316: dq 0.0
section .text
    movsd xmm0, [rel .flt316]
    movsd [rbp-24], xmm0
section .data
.flt317: dq 0.0
section .text
    movsd xmm0, [rel .flt317]
    movsd [rbp-32], xmm0
section .data
.flt318: dq 0.0
section .text
    movsd xmm0, [rel .flt318]
    movsd [rbp-40], xmm0
    mov rax, 0
    mov [rbp-48], rax
.L319:
    mov rax, [rbp-48]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L320
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
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
    movsd [rbp-32], xmm0
    mov rax, [rbp-48]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-48], rax
    jmp .L319
.L320:
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_315
.__ret_315:
    mov rsp, rbp
    pop rbp
    ret
linreg_intercept:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_mean_y
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_321
.__ret_321:
    mov rsp, rbp
    pop rbp
    ret
linreg_predict:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_322
.__ret_322:
    mov rsp, rbp
    pop rbp
    ret
linreg_r2:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call st_corr
    add rsp, 32
    movsd [rbp-8], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_323
.__ret_323:
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_rnd_state: dq 0
section .text
section .data
__g_rnd_have_spare: dq 0
section .text
section .data
__g_rnd_spare: dq 0
section .text
rnd_modulus:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 4294967296
    jmp .__ret_324
.__ret_324:
    mov rsp, rbp
    pop rbp
    ret
rnd_seed:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    mov [rel __g_rnd_state], rax
    mov rax, [rel __g_rnd_state]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L326
    mov rax, 0
    push rax
    mov rax, [rel __g_rnd_state]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_rnd_state], rax
    jmp .L327
.L326:
.L327:
    mov rax, [rel __g_rnd_state]
    push rax
    sub rsp, 32
    call rnd_modulus
    add rsp, 32
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov rax, rdx
    mov [rel __g_rnd_state], rax
    mov rax, 0
    mov [rel __g_rnd_have_spare], rax
    mov rax, 0
    jmp .__ret_325
.__ret_325:
    mov rsp, rbp
    pop rbp
    ret
rnd_next:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 1664525
    push rax
    mov rax, [rel __g_rnd_state]
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, 1013904223
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    sub rsp, 32
    call rnd_modulus
    add rsp, 32
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov rax, rdx
    mov [rel __g_rnd_state], rax
    mov rax, [rel __g_rnd_state]
    jmp .__ret_328
.__ret_328:
    mov rsp, rbp
    pop rbp
    ret
rnd_uniform:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    sub rsp, 32
    call rnd_next
    add rsp, 32
    cvtsi2sd xmm0, rax
    movsd [rbp-8], xmm0
    sub rsp, 32
    call rnd_modulus
    add rsp, 32
    cvtsi2sd xmm0, rax
    movsd [rbp-16], xmm0
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_329
.__ret_329:
    mov rsp, rbp
    pop rbp
    ret
rnd_range:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
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
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_330
.__ret_330:
    mov rsp, rbp
    pop rbp
    ret
rnd_int:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L332
    mov rax, 0
    jmp .__ret_331
    jmp .L333
.L332:
.L333:
    sub rsp, 32
    call rnd_next
    add rsp, 32
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov rax, rdx
    jmp .__ret_331
.__ret_331:
    mov rsp, rbp
    pop rbp
    ret
rnd_int_range:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L335
    mov rax, [rbp-8]
    jmp .__ret_334
    jmp .L336
.L335:
.L336:
    mov rax, [rbp-8]
    push rax
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_334
.__ret_334:
    mov rsp, rbp
    pop rbp
    ret
rnd_bool:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    movsd [rbp-8], xmm0
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
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
    jz .L338
    mov rax, 1
    jmp .__ret_337
    jmp .L339
.L338:
.L339:
    mov rax, 0
    jmp .__ret_337
.__ret_337:
    mov rsp, rbp
    pop rbp
    ret
rnd_normal:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    mov rax, [rel __g_rnd_have_spare]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L341
    mov rax, 0
    mov [rel __g_rnd_have_spare], rax
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rel __g_rnd_spare]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_340
    jmp .L342
.L341:
.L342:
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    movsd [rbp-24], xmm0
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt345: dq 0.0000000001
section .text
    movsd xmm0, [rel .flt345]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L343
section .data
.flt346: dq 0.0000000001
section .text
    movsd xmm0, [rel .flt346]
    movsd [rbp-24], xmm0
    jmp .L344
.L343:
.L344:
section .data
.flt347: dq 0.0
section .text
    movsd xmm0, [rel .flt347]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt348: dq 2.0
section .text
    movsd xmm0, [rel .flt348]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fln
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    movsd [rbp-40], xmm0
    sub rsp, 32
    call m_tau
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd [rbp-48], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
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
    movsd [rel __g_rnd_spare], xmm0
    mov rax, 1
    mov [rel __g_rnd_have_spare], rax
    movsd xmm0, [rbp-8]
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
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-48]
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
    jmp .__ret_340
.__ret_340:
    mov rsp, rbp
    pop rbp
    ret
rnd_gauss:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt350: dq 0.0
section .text
    movsd xmm0, [rel .flt350]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt351: dq 1.0
section .text
    movsd xmm0, [rel .flt351]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rnd_normal
    add rsp, 32
    jmp .__ret_349
.__ret_349:
    mov rsp, rbp
    pop rbp
    ret
rnd_fill_x:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rcx
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    mov rax, 0
    mov [rel __g_st_n], rax
    mov rax, 0
    mov [rbp-32], rax
.L353:
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L354
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rnd_range
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L353
.L354:
    mov rax, 0
    jmp .__ret_352
.__ret_352:
    mov rsp, rbp
    pop rbp
    ret
rnd_fill_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rcx
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    mov rax, 0
    mov [rel __g_st_ny], rax
    mov rax, 0
    mov [rbp-32], rax
.L356:
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L357
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rnd_range
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L356
.L357:
    mov rax, 0
    jmp .__ret_355
.__ret_355:
    mov rsp, rbp
    pop rbp
    ret
rnd_fill_linear:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-8], rcx
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
section .data
.flt359: dq 0.0
section .text
    movsd xmm0, [rel .flt359]
    movsd [rbp-40], xmm0
    mov rax, [rbp-8]
    cvtsi2sd xmm0, rax
    movsd [rbp-48], xmm0
    sub rsp, 32
    call st_clear
    add rsp, 32
    mov rax, 0
    mov [rbp-56], rax
.L360:
    mov rax, [rbp-56]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L361
    mov rax, [rbp-56]
    cvtsi2sd xmm0, rax
    movsd [rbp-40], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    movsd xmm0, [rbp-16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt362: dq 0.0
section .text
    movsd xmm0, [rel .flt362]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rnd_normal
    add rsp, 32
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
    mov rax, [rbp-56]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-56], rax
    jmp .L360
.L361:
    mov rax, 0
    jmp .__ret_358
.__ret_358:
    mov rsp, rbp
    pop rbp
    ret
rnd_shuffle:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov rax, 0
    mov [rbp-8], rax
section .data
.flt364: dq 0.0
section .text
    movsd xmm0, [rel .flt364]
    movsd [rbp-16], xmm0
section .data
.flt365: dq 0.0
section .text
    movsd xmm0, [rel .flt365]
    movsd [rbp-24], xmm0
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rbp-32], rax
.L366:
    mov rax, [rbp-32]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L367
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov [rbp-8], rax
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-16], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-8]
    push rax
    movsd xmm0, [rbp-16]
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-32]
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-24], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-8]
    push rax
    movsd xmm0, [rbp-24]
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rbp-32], rax
    jmp .L366
.L367:
    mov rax, 0
    jmp .__ret_363
.__ret_363:
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 42
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call rnd_next
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call rnd_next
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call rnd_next
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 42
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    call __print_float
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    call __print_float
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    call __print_float
    mov rax, 42
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    mov rax, 100
    push rax
    pop rcx
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 100
    push rax
    pop rcx
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 100
    push rax
    pop rcx
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 42
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
section .data
.flt369: dq 10.0
section .text
    movsd xmm0, [rel .flt369]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt370: dq 20.0
section .text
    movsd xmm0, [rel .flt370]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rnd_range
    add rsp, 32
    call __print_float
section .data
.flt371: dq 10.0
section .text
    movsd xmm0, [rel .flt371]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt372: dq 20.0
section .text
    movsd xmm0, [rel .flt372]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call rnd_range
    add rsp, 32
    call __print_float
    mov rax, 7
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
    mov rax, 0
    mov [rbp-8], rax
.L373:
    mov rax, [rbp-8]
    push rax
    mov rax, 1000
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L374
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-8], rax
    jmp .L373
.L374:
    sub rsp, 32
    call st_mean
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_stddev
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_min
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_max
    add rsp, 32
    call __print_float
    mov rax, 7
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
    mov rax, 0
    mov [rbp-8], rax
.L375:
    mov rax, [rbp-8]
    push rax
    mov rax, 1000
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L376
    sub rsp, 32
    call rnd_gauss
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-8], rax
    jmp .L375
.L376:
    sub rsp, 32
    call st_mean
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_stddev
    add rsp, 32
    call __print_float
    mov rax, 123
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    mov rax, 200
    push rax
section .data
.flt377: dq 2.0
section .text
    movsd xmm0, [rel .flt377]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt378: dq 5.0
section .text
    movsd xmm0, [rel .flt378]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt379: dq 0.5
section .text
    movsd xmm0, [rel .flt379]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call rnd_fill_linear
    add rsp, 32
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    call __print_float
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    call __print_float
    sub rsp, 32
    call linreg_r2
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt380: dq 1.0
section .text
    movsd xmm0, [rel .flt380]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt381: dq 10.0
section .text
    movsd xmm0, [rel .flt381]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt382: dq 2.0
section .text
    movsd xmm0, [rel .flt382]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt383: dq 20.0
section .text
    movsd xmm0, [rel .flt383]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt384: dq 3.0
section .text
    movsd xmm0, [rel .flt384]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt385: dq 30.0
section .text
    movsd xmm0, [rel .flt385]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt386: dq 4.0
section .text
    movsd xmm0, [rel .flt386]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt387: dq 40.0
section .text
    movsd xmm0, [rel .flt387]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
    mov rax, 99
    push rax
    pop rcx
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call rnd_shuffle
    add rsp, 32
    sub rsp, 32
    call st_sum
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_count
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    call __print_float
    mov rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    call __print_float
    mov rax, 2
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 2
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    call __print_float
    mov rax, 3
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 3
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    call __print_float
    mov rax, 0
    jmp .__ret_368
.__ret_368:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
