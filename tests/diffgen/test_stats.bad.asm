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
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt3: dq 2.0
section .text
    movsd xmm0, [rel .flt3]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt4: dq 4.0
section .text
    movsd xmm0, [rel .flt4]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt5: dq 4.0
section .text
    movsd xmm0, [rel .flt5]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt6: dq 4.0
section .text
    movsd xmm0, [rel .flt6]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt7: dq 5.0
section .text
    movsd xmm0, [rel .flt7]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt8: dq 5.0
section .text
    movsd xmm0, [rel .flt8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt9: dq 7.0
section .text
    movsd xmm0, [rel .flt9]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt10: dq 9.0
section .text
    movsd xmm0, [rel .flt10]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    sub rsp, 32
    call st_count
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_sum
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_mean
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_min
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_max
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_range
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_var
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_stddev
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_median
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_mode
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt11: dq 1.0
section .text
    movsd xmm0, [rel .flt11]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt12: dq 2.0
section .text
    movsd xmm0, [rel .flt12]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt13: dq 3.0
section .text
    movsd xmm0, [rel .flt13]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt14: dq 4.0
section .text
    movsd xmm0, [rel .flt14]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt15: dq 5.0
section .text
    movsd xmm0, [rel .flt15]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    sub rsp, 32
    call st_median
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.flt16: dq 0.0
section .text
    movsd xmm0, [rel .flt16]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.flt17: dq 50.0
section .text
    movsd xmm0, [rel .flt17]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.flt18: dq 100.0
section .text
    movsd xmm0, [rel .flt18]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_q1
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_q3
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_iqr
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_var
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_var_sample
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt19: dq 1.0
section .text
    movsd xmm0, [rel .flt19]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt20: dq 2.0
section .text
    movsd xmm0, [rel .flt20]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt21: dq 3.0
section .text
    movsd xmm0, [rel .flt21]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt22: dq 4.0
section .text
    movsd xmm0, [rel .flt22]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt23: dq 5.0
section .text
    movsd xmm0, [rel .flt23]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt24: dq 3.0
section .text
    movsd xmm0, [rel .flt24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt25: dq 5.0
section .text
    movsd xmm0, [rel .flt25]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt26: dq 7.0
section .text
    movsd xmm0, [rel .flt26]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt27: dq 9.0
section .text
    movsd xmm0, [rel .flt27]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt28: dq 11.0
section .text
    movsd xmm0, [rel .flt28]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.flt29: dq 10.0
section .text
    movsd xmm0, [rel .flt29]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call linreg_predict
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_corr
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call linreg_r2
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt30: dq 1.0
section .text
    movsd xmm0, [rel .flt30]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt31: dq 2.0
section .text
    movsd xmm0, [rel .flt31]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt32: dq 3.0
section .text
    movsd xmm0, [rel .flt32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt33: dq 4.0
section .text
    movsd xmm0, [rel .flt33]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt34: dq 2.0
section .text
    movsd xmm0, [rel .flt34]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt35: dq 4.0
section .text
    movsd xmm0, [rel .flt35]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt36: dq 5.0
section .text
    movsd xmm0, [rel .flt36]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt37: dq 8.0
section .text
    movsd xmm0, [rel .flt37]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call st_covar
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_2
.__ret_2:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
