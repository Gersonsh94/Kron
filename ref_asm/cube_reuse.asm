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
extern CreateThread
extern WaitForSingleObject
extern InitializeCriticalSection
extern EnterCriticalSection
extern LeaveCriticalSection
extern GetSystemInfo
extern QueryPerformanceCounter
extern QueryPerformanceFrequency
section .bss
__numbuf: resb 32
__nwritten: resq 1
__chbuf: resb 2
__keybuf: resb 2
__nread: resq 1
__mousebuf: resb 32
__mousex_v: resq 1
__mousey_v: resq 1
__fail_flag: resq 1
__fail_msg: resq 1
__fail_hint: resq 1
__locks: resb 1024
__sysinfo: resb 64
__tickbuf: resq 1
section .text
__outname: db 'out.bmp', 0
__thread_start:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov r9, rdx
    mov r8, rcx
    xor rcx, rcx
    xor rdx, rdx
    mov qword [rsp+32], 0
    mov qword [rsp+40], 0
    call CreateThread
    add rsp, 64
    pop rbp
    ret
__thread_wait:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rdx, 0xFFFFFFFF
    call WaitForSingleObject
    add rsp, 48
    pop rbp
    ret
__lock_addr:
    cmp rcx, 16
    jb .la_ok
    xor rcx, rcx
.la_ok:
    imul rcx, rcx, 64
    lea rax, [rel __locks]
    add rax, rcx
    ret
__lock_init:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    call __lock_addr
    mov rcx, rax
    call InitializeCriticalSection
    add rsp, 48
    pop rbp
    ret
__lock_take:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    call __lock_addr
    mov rcx, rax
    call EnterCriticalSection
    add rsp, 48
    pop rbp
    ret
__lock_give:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    call __lock_addr
    mov rcx, rax
    call LeaveCriticalSection
    add rsp, 48
    pop rbp
    ret
__ticks:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    lea rcx, [rel __tickbuf]
    call QueryPerformanceCounter
    mov rax, [rel __tickbuf]
    add rsp, 48
    pop rbp
    ret
__ticks_per_sec:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    lea rcx, [rel __tickbuf]
    call QueryPerformanceFrequency
    mov rax, [rel __tickbuf]
    add rsp, 48
    pop rbp
    ret
__cpu_count:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    lea rcx, [rel __sysinfo]
    call GetSystemInfo
    lea rax, [rel __sysinfo]
    mov eax, dword [rax+32]
    add rsp, 48
    pop rbp
    ret
__load_file:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    sub rsp, 104
    mov rbx, rdx
    mov rsi, r8
    mov edx, 0x80000000
    mov r8d, 1
    xor r9d, r9d
    mov qword [rsp+32], 3
    mov qword [rsp+40], 0x80
    mov qword [rsp+48], 0
    call CreateFileA
    cmp rax, -1
    je .lf_fail
    mov rdi, rax
    mov qword [rel __nread], 0
    mov rcx, rdi
    mov rdx, rbx
    mov r8, rsi
    lea r9, [rel __nread]
    mov qword [rsp+32], 0
    call ReadFile
    mov rcx, rdi
    call CloseHandle
    mov rax, [rel __nread]
    jmp .lf_out
.lf_fail:
    xor rax, rax
.lf_out:
    add rsp, 104
    pop rdi
    pop rsi
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
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
section .data
__pf_fail: db 'fail: ', 0
__pf_hint: db 'hint: ', 0
__pf_nl: db 13, 10, 0
section .text
__print_fail:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rcx, [rel __fail_msg]
    test rcx, rcx
    jz .pf_done
    lea rcx, [rel __pf_fail]
    call __print_str
    mov rcx, [rel __fail_msg]
    call __print_str
    lea rcx, [rel __pf_nl]
    call __print_str
    mov rcx, [rel __fail_hint]
    test rcx, rcx
    jz .pf_done
    lea rcx, [rel __pf_hint]
    call __print_str
    mov rcx, [rel __fail_hint]
    call __print_str
    lea rcx, [rel __pf_nl]
    call __print_str
.pf_done:
    add rsp, 32
    pop rbp
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
main:
    push rbp
    mov rbp, rsp
    sub rsp, 10528
    mov rax, 0
    push rax
section .data
.flt1: dq 0.0
section .text
    movsd xmm0, [rel .flt1]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2: dq 1.0
section .text
    movsd xmm0, [rel .flt2]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
section .data
.flt3: dq 0.0
section .text
    movsd xmm0, [rel .flt3]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt4: dq 1.0
section .text
    movsd xmm0, [rel .flt4]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
section .data
.flt5: dq 0.0
section .text
    movsd xmm0, [rel .flt5]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt6: dq 1.0
section .text
    movsd xmm0, [rel .flt6]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt7: dq 1.0
section .text
    movsd xmm0, [rel .flt7]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt8: dq 0.0
section .text
    movsd xmm0, [rel .flt8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt9: dq 1.0
section .text
    movsd xmm0, [rel .flt9]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt10: dq 0.0
section .text
    movsd xmm0, [rel .flt10]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt11: dq 1.0
section .text
    movsd xmm0, [rel .flt11]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt12: dq 1.0
section .text
    movsd xmm0, [rel .flt12]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt13: dq 1.0
section .text
    movsd xmm0, [rel .flt13]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt14: dq 0.0
section .text
    movsd xmm0, [rel .flt14]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt15: dq 1.0
section .text
    movsd xmm0, [rel .flt15]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt16: dq 0.0
section .text
    movsd xmm0, [rel .flt16]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt17: dq 1.0
section .text
    movsd xmm0, [rel .flt17]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt18: dq 1.0
section .text
    movsd xmm0, [rel .flt18]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt19: dq 0.0
section .text
    movsd xmm0, [rel .flt19]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt20: dq 1.0
section .text
    movsd xmm0, [rel .flt20]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt21: dq 0.0
section .text
    movsd xmm0, [rel .flt21]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt22: dq 1.0
section .text
    movsd xmm0, [rel .flt22]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt23: dq 0.0
section .text
    movsd xmm0, [rel .flt23]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt24: dq 1.0
section .text
    movsd xmm0, [rel .flt24]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt25: dq 1.0
section .text
    movsd xmm0, [rel .flt25]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt26: dq 1.0
section .text
    movsd xmm0, [rel .flt26]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt27: dq 0.0
section .text
    movsd xmm0, [rel .flt27]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt28: dq 1.0
section .text
    movsd xmm0, [rel .flt28]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt29: dq 1.0
section .text
    movsd xmm0, [rel .flt29]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt30: dq 1.0
section .text
    movsd xmm0, [rel .flt30]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt31: dq 1.0
section .text
    movsd xmm0, [rel .flt31]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt32: dq 1.0
section .text
    movsd xmm0, [rel .flt32]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
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
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt35: dq 1.0
section .text
    movsd xmm0, [rel .flt35]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
section .data
.flt37: dq 0.94
section .text
    movsd xmm0, [rel .flt37]
    movsd [rbp-10248], xmm0
section .data
.flt38: dq 0.342
section .text
    movsd xmm0, [rel .flt38]
    movsd [rbp-10256], xmm0
    mov rax, 0
    mov [rbp-10264], rax
.L39:
    mov rax, [rbp-10264]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L40
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10256]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-10272], xmm0
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10256]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-10280], xmm0
    mov rax, [rbp-10264]
    push rax
    movsd xmm0, [rbp-10272]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-10264]
    push rax
    movsd xmm0, [rbp-10280]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-10264]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10264], rax
    jmp .L39
.L40:
section .data
.flt41: dq 0.981
section .text
    movsd xmm0, [rel .flt41]
    movsd [rbp-10288], xmm0
section .data
.flt42: dq 0.195
section .text
    movsd xmm0, [rel .flt42]
    movsd [rbp-10296], xmm0
    mov rax, 0
    mov [rbp-10304], rax
.L43:
    mov rax, [rbp-10304]
    push rax
    mov rax, 6
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L44
    mov rax, 0
    mov [rbp-10264], rax
.L45:
    mov rax, [rbp-10264]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L46
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10288]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10296]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-10312], xmm0
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10288]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-10264]
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10296]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-10280], xmm0
    mov rax, [rbp-10264]
    push rax
    movsd xmm0, [rbp-10312]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-10264]
    push rax
    movsd xmm0, [rbp-10280]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-10264]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10264], rax
    jmp .L45
.L46:
    mov rax, 0
    mov [rbp-10320], rax
.L47:
    mov rax, [rbp-10320]
    push rax
    mov rax, 1232
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L48
    mov rax, [rbp-10320]
    push rax
    mov rax, 32
    pop rcx
    lea rdx, [rbp-9856]
    mov [rdx+rcx*8], rax
    mov rax, [rbp-10320]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10320], rax
    jmp .L47
.L48:
    mov rax, 0
    mov [rbp-10328], rax
.L49:
    mov rax, [rbp-10328]
    push rax
    mov rax, 12
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L50
    mov rax, [rbp-10328]
    mov rcx, rax
    lea rdx, [rbp-10144]
    mov rax, [rdx+rcx*8]
    mov [rbp-10336], rax
    mov rax, [rbp-10328]
    mov rcx, rax
    lea rdx, [rbp-10240]
    mov rax, [rdx+rcx*8]
    mov [rbp-10344], rax
    mov rax, [rbp-10336]
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10352], xmm0
    mov rax, [rbp-10336]
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10360], xmm0
    mov rax, [rbp-10336]
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10368], xmm0
    mov rax, [rbp-10344]
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10376], xmm0
    mov rax, [rbp-10344]
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10384], xmm0
    mov rax, [rbp-10344]
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10392], xmm0
    mov rax, 0
    mov [rbp-10400], rax
.L51:
    mov rax, [rbp-10400]
    push rax
    mov rax, 40
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L52
    mov rax, [rbp-10400]
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt53: dq 39.0
section .text
    movsd xmm0, [rel .flt53]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-10408], xmm0
    movsd xmm0, [rbp-10352]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10376]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10352]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10408]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-10416], xmm0
    movsd xmm0, [rbp-10360]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10384]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10360]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10408]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-10424], xmm0
    movsd xmm0, [rbp-10368]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10392]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10368]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10408]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-10432], xmm0
    movsd xmm0, [rbp-10432]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt54: dq 4.0
section .text
    movsd xmm0, [rel .flt54]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-10440], xmm0
section .data
.flt55: dq 28.0
section .text
    movsd xmm0, [rel .flt55]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10416]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt56: dq 30.0
section .text
    movsd xmm0, [rel .flt56]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10440]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvttsd2si rax, xmm0
    mov [rbp-10448], rax
section .data
.flt57: dq 11.0
section .text
    movsd xmm0, [rel .flt57]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10424]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt58: dq 15.0
section .text
    movsd xmm0, [rel .flt58]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-10440]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvttsd2si rax, xmm0
    mov [rbp-10456], rax
    mov rax, [rbp-10448]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L65
    mov rax, [rbp-10448]
    push rax
    mov rax, 56
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L65
    mov rax, 1
    jmp .L66
.L65:
    mov rax, 0
.L66:
    test rax, rax
    jz .L63
    mov rax, [rbp-10456]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
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
    mov rax, [rbp-10456]
    push rax
    mov rax, 22
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L61
    mov rax, 1
    jmp .L62
.L61:
    mov rax, 0
.L62:
    test rax, rax
    jz .L59
    mov rax, [rbp-10456]
    push rax
    mov rax, 56
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-10448]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 35
    pop rcx
    lea rdx, [rbp-9856]
    mov [rdx+rcx*8], rax
    jmp .L60
.L59:
.L60:
    mov rax, [rbp-10400]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10400], rax
    jmp .L51
.L52:
    mov rax, [rbp-10328]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10328], rax
    jmp .L49
.L50:
    mov rax, 0
    mov [rbp-10464], rax
.L67:
    mov rax, [rbp-10464]
    push rax
    mov rax, 22
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L68
    mov rax, 0
    mov [rbp-10472], rax
.L69:
    mov rax, [rbp-10472]
    push rax
    mov rax, 56
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L70
    mov rax, [rbp-10464]
    push rax
    mov rax, 56
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-10472]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rcx, rax
    lea rdx, [rbp-9856]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
    mov rax, [rbp-10472]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10472], rax
    jmp .L69
.L70:
    mov rax, 10
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
    mov rax, [rbp-10464]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10464], rax
    jmp .L67
.L68:
    mov rax, 10
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
    mov rax, [rbp-10304]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-10304], rax
    jmp .L43
.L44:
    mov rax, 0
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
