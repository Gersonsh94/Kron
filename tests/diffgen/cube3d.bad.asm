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
section .data
__mod_0_anon:
    db "acquire_domain",0
    db "anon",0
section .text
section .data
__mod_1_anon:
    db "acquire_domain",0
    db "anon",0
section .text
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
    jmp .__ret_2
.__ret_2:
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
    jmp .__ret_3
.__ret_3:
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
.L5:
    mov rax, [rbp-16]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L6
    mov rax, 0
    mov [rbp-24], rax
.L7:
    mov rax, [rbp-24]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L8
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
.flt9: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt9]
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
    jmp .L7
.L8:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L5
.L6:
    mov rax, [rbp-8]
    jmp .__ret_4
.__ret_4:
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
.flt11: dq 0.0
section .text
    movsd xmm0, [rel .flt11]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt12: dq 1.0
section .text
    movsd xmm0, [rel .flt12]
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
.flt13: dq 0.0
section .text
    movsd xmm0, [rel .flt13]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt14: dq 1.0
section .text
    movsd xmm0, [rel .flt14]
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
.flt15: dq 0.0
section .text
    movsd xmm0, [rel .flt15]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt16: dq 1.0
section .text
    movsd xmm0, [rel .flt16]
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
.flt17: dq 1.0
section .text
    movsd xmm0, [rel .flt17]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt18: dq 0.0
section .text
    movsd xmm0, [rel .flt18]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt19: dq 1.0
section .text
    movsd xmm0, [rel .flt19]
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
.flt20: dq 0.0
section .text
    movsd xmm0, [rel .flt20]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt21: dq 1.0
section .text
    movsd xmm0, [rel .flt21]
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
.flt22: dq 1.0
section .text
    movsd xmm0, [rel .flt22]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt23: dq 1.0
section .text
    movsd xmm0, [rel .flt23]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt24: dq 0.0
section .text
    movsd xmm0, [rel .flt24]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt25: dq 1.0
section .text
    movsd xmm0, [rel .flt25]
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
.flt26: dq 0.0
section .text
    movsd xmm0, [rel .flt26]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt27: dq 1.0
section .text
    movsd xmm0, [rel .flt27]
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
.flt28: dq 1.0
section .text
    movsd xmm0, [rel .flt28]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt29: dq 0.0
section .text
    movsd xmm0, [rel .flt29]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt30: dq 1.0
section .text
    movsd xmm0, [rel .flt30]
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
.flt31: dq 0.0
section .text
    movsd xmm0, [rel .flt31]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt32: dq 1.0
section .text
    movsd xmm0, [rel .flt32]
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
.flt33: dq 0.0
section .text
    movsd xmm0, [rel .flt33]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt34: dq 1.0
section .text
    movsd xmm0, [rel .flt34]
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
.flt35: dq 1.0
section .text
    movsd xmm0, [rel .flt35]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt37: dq 0.0
section .text
    movsd xmm0, [rel .flt37]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt38: dq 1.0
section .text
    movsd xmm0, [rel .flt38]
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
.flt39: dq 1.0
section .text
    movsd xmm0, [rel .flt39]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt40: dq 1.0
section .text
    movsd xmm0, [rel .flt40]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt41: dq 1.0
section .text
    movsd xmm0, [rel .flt41]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt42: dq 1.0
section .text
    movsd xmm0, [rel .flt42]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt43: dq 0.0
section .text
    movsd xmm0, [rel .flt43]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt44: dq 1.0
section .text
    movsd xmm0, [rel .flt44]
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
.flt45: dq 1.0
section .text
    movsd xmm0, [rel .flt45]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt46: dq 1.0
section .text
    movsd xmm0, [rel .flt46]
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
    jmp .__ret_10
.__ret_10:
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
.L48:
    mov rax, [rbp-24]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L49
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
    cvtsi2sd xmm0, rax
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
    cvtsi2sd xmm0, rax
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
    jmp .L48
.L49:
    mov rax, 0
    mov [rbp-24], rax
.L50:
    mov rax, [rbp-24]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L51
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
    cvtsi2sd xmm0, rax
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
    cvtsi2sd xmm0, rax
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
    jmp .L50
.L51:
    mov rax, 0
    jmp .__ret_47
.__ret_47:
    mov rsp, rbp
    pop rbp
    ret
project_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, 0
    mov [rbp-8], rax
.L53:
    mov rax, [rbp-8]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L54
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
.flt55: dq 4.0
section .text
    movsd xmm0, [rel .flt55]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt56: dq 90.0
section .text
    movsd xmm0, [rel .flt56]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt57: dq 50.0
section .text
    movsd xmm0, [rel .flt57]
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
    cvtsi2sd xmm0, rax
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
.flt58: dq 4.0
section .text
    movsd xmm0, [rel .flt58]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt59: dq 90.0
section .text
    movsd xmm0, [rel .flt59]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt60: dq 50.0
section .text
    movsd xmm0, [rel .flt60]
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
    cvtsi2sd xmm0, rax
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
.flt61: dq 4.0
section .text
    movsd xmm0, [rel .flt61]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call proj_depth
    add rsp, 32
    cvtsi2sd xmm0, rax
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
    jmp .L53
.L54:
    mov rax, 0
    jmp .__ret_52
.__ret_52:
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
.flt63: dq 0.55
section .text
    movsd xmm0, [rel .flt63]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt64: dq 0.8
section .text
    movsd xmm0, [rel .flt64]
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
.L65:
    mov rax, [rbp-24]
    push rax
    mov rax, 12
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L66
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
    cvtsi2sd xmm0, rax
    movsd [rbp-176], xmm0
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fabs
    add rsp, 32
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt69: dq 0.5
section .text
    movsd xmm0, [rel .flt69]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L67
    mov rax, 0
    mov [rbp-184], rax
.L70:
    mov rax, [rbp-184]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L71
    mov rax, 0
    mov [rbp-192], rax
.L72:
    mov rax, [rbp-192]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L73
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
    cvtsi2sd xmm0, rax
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
    cvtsi2sd xmm0, rax
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
    cvtsi2sd xmm0, rax
    movsd [rbp-232], xmm0
    mov rax, 0
    mov [rbp-240], rax
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt76: dq 0.0
section .text
    movsd xmm0, [rel .flt76]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L74
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt83: dq 0.0
section .text
    movsd xmm0, [rel .flt83]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L81
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt84: dq 0.0
section .text
    movsd xmm0, [rel .flt84]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
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
    movsd xmm0, [rbp-232]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt85: dq 0.0
section .text
    movsd xmm0, [rel .flt85]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L79
    mov rax, 1
    jmp .L80
.L79:
    mov rax, 0
.L80:
    test rax, rax
    jz .L77
    mov rax, 1
    mov [rbp-240], rax
    jmp .L78
.L77:
.L78:
    jmp .L75
.L74:
.L75:
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt88: dq 0.0
section .text
    movsd xmm0, [rel .flt88]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L86
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt95: dq 0.0
section .text
    movsd xmm0, [rel .flt95]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L93
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt96: dq 0.0
section .text
    movsd xmm0, [rel .flt96]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L93
    mov rax, 1
    jmp .L94
.L93:
    mov rax, 0
.L94:
    test rax, rax
    jz .L91
    movsd xmm0, [rbp-232]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt97: dq 0.0
section .text
    movsd xmm0, [rel .flt97]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L91
    mov rax, 1
    jmp .L92
.L91:
    mov rax, 0
.L92:
    test rax, rax
    jz .L89
    mov rax, 1
    mov [rbp-240], rax
    jmp .L90
.L89:
.L90:
    jmp .L87
.L86:
.L87:
    mov rax, [rbp-240]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L98
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
    jz .L100
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
    jmp .L101
.L100:
.L101:
    jmp .L99
.L98:
.L99:
    mov rax, [rbp-192]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-192], rax
    jmp .L72
.L73:
    mov rax, [rbp-184]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-184], rax
    jmp .L70
.L71:
    jmp .L68
.L67:
.L68:
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L65
.L66:
section .data
.str102: db 99,117,98,101,46,98,109,112,0
section .text
    lea rax, [rel .str102]
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
    jmp .__ret_62
.__ret_62:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
