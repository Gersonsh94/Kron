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
section .bss
__g_buf: resq 3757
section .text
section .bss
__g_zb: resq 10000
section .text
cross:
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
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 1456
    lea rax, [rel __g_buf]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    push rax
    mov rax, 54
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    mov rax, 1
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
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
    mov rax, 0
    mov [rbp-24], rax
.L2:
    mov rax, [rbp-24]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L3
    mov rax, 0
    mov [rbp-32], rax
.L4:
    mov rax, [rbp-32]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L5
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, 300
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-32]
    push rax
    mov rax, 3
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-40], rax
    mov rax, [rbp-40]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 40
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-40]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 15
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-40]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-32]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
section .data
.flt6: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt6]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L4
.L5:
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L2
.L3:
    mov rax, 2
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    push rax
section .data
.flt7: dq 0.0
section .text
    movsd xmm0, [rel .flt7]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt8: dq 1.0
section .text
    movsd xmm0, [rel .flt8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    push rax
section .data
.flt9: dq 0.0
section .text
    movsd xmm0, [rel .flt9]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt10: dq 1.0
section .text
    movsd xmm0, [rel .flt10]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
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
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    push rax
section .data
.flt13: dq 1.0
section .text
    movsd xmm0, [rel .flt13]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
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
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
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
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt18: dq 1.0
section .text
    movsd xmm0, [rel .flt18]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt19: dq 1.0
section .text
    movsd xmm0, [rel .flt19]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
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
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt22: dq 0.0
section .text
    movsd xmm0, [rel .flt22]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt23: dq 1.0
section .text
    movsd xmm0, [rel .flt23]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt24: dq 1.0
section .text
    movsd xmm0, [rel .flt24]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    push rax
section .data
.flt25: dq 0.0
section .text
    movsd xmm0, [rel .flt25]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt26: dq 1.0
section .text
    movsd xmm0, [rel .flt26]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
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
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
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
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt31: dq 1.0
section .text
    movsd xmm0, [rel .flt31]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt32: dq 1.0
section .text
    movsd xmm0, [rel .flt32]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
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
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt35: dq 1.0
section .text
    movsd xmm0, [rel .flt35]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt37: dq 1.0
section .text
    movsd xmm0, [rel .flt37]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt38: dq 1.0
section .text
    movsd xmm0, [rel .flt38]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt39: dq 0.0
section .text
    movsd xmm0, [rel .flt39]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt40: dq 1.0
section .text
    movsd xmm0, [rel .flt40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt41: dq 1.0
section .text
    movsd xmm0, [rel .flt41]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt42: dq 1.0
section .text
    movsd xmm0, [rel .flt42]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
section .data
.flt43: dq 0.85
section .text
    movsd xmm0, [rel .flt43]
    movsd [rbp-240], xmm0
section .data
.flt44: dq 0.527
section .text
    movsd xmm0, [rel .flt44]
    movsd [rbp-248], xmm0
    mov rax, 0
    mov [rbp-256], rax
.L45:
    mov rax, [rbp-256]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L46
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-168]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-240]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-264], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-168]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-240]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-272], xmm0
    mov rax, [rbp-256]
    push rax
    movsd xmm0, [rbp-264]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
    movsd xmm0, [rbp-272]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-256], rax
    jmp .L45
.L46:
section .data
.flt47: dq 0.7
section .text
    movsd xmm0, [rel .flt47]
    movsd [rbp-280], xmm0
section .data
.flt48: dq 0.714
section .text
    movsd xmm0, [rel .flt48]
    movsd [rbp-288], xmm0
    mov rax, 0
    mov [rbp-256], rax
.L49:
    mov rax, [rbp-256]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L50
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-104]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-280]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-288]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-296], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-280]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-104]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-288]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-272], xmm0
    mov rax, [rbp-256]
    push rax
    movsd xmm0, [rbp-296]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
    movsd xmm0, [rbp-272]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-256], rax
    jmp .L49
.L50:
    mov rax, 0
    mov [rbp-256], rax
.L51:
    mov rax, [rbp-256]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L52
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt53: dq 4.0
section .text
    movsd xmm0, [rel .flt53]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-496], xmm0
    mov rax, [rbp-256]
    push rax
section .data
.flt54: dq 50.0
section .text
    movsd xmm0, [rel .flt54]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-104]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt55: dq 90.0
section .text
    movsd xmm0, [rel .flt55]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-496]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-360]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
section .data
.flt56: dq 50.0
section .text
    movsd xmm0, [rel .flt56]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-256]
    mov rcx, rax
    lea rdx, [rbp-168]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt57: dq 90.0
section .text
    movsd xmm0, [rel .flt57]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-496]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-424]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
    movsd xmm0, [rbp-496]
    pop rcx
    lea rdx, [rbp-488]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-256]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-256], rax
    jmp .L51
.L52:
    mov rax, 3
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 0
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 1
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 2
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 3
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 4
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 5
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 6
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 7
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 8
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 9
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 10
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 11
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 4
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    mov [rbp-1080], rax
.L58:
    mov rax, [rbp-1080]
    push rax
    mov rax, 12
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L59
    mov rax, [rbp-1080]
    mov rcx, rax
    lea rdx, [rbp-592]
    mov rax, [rdx+rcx*8]
    mov [rbp-1088], rax
    mov rax, [rbp-1080]
    mov rcx, rax
    lea rdx, [rbp-688]
    mov rax, [rdx+rcx*8]
    mov [rbp-1096], rax
    mov rax, [rbp-1080]
    mov rcx, rax
    lea rdx, [rbp-784]
    mov rax, [rdx+rcx*8]
    mov [rbp-1104], rax
    mov rax, [rbp-1088]
    mov rcx, rax
    lea rdx, [rbp-360]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1112], xmm0
    mov rax, [rbp-1088]
    mov rcx, rax
    lea rdx, [rbp-424]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1120], xmm0
    mov rax, [rbp-1088]
    mov rcx, rax
    lea rdx, [rbp-488]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1128], xmm0
    mov rax, [rbp-1096]
    mov rcx, rax
    lea rdx, [rbp-360]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1136], xmm0
    mov rax, [rbp-1096]
    mov rcx, rax
    lea rdx, [rbp-424]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1144], xmm0
    mov rax, [rbp-1096]
    mov rcx, rax
    lea rdx, [rbp-488]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1152], xmm0
    mov rax, [rbp-1104]
    mov rcx, rax
    lea rdx, [rbp-360]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1160], xmm0
    mov rax, [rbp-1104]
    mov rcx, rax
    lea rdx, [rbp-424]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1168], xmm0
    mov rax, [rbp-1104]
    mov rcx, rax
    lea rdx, [rbp-488]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1176], xmm0
    movsd xmm0, [rbp-1136]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1112]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1184], xmm0
    movsd xmm0, [rbp-1144]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1120]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1192], xmm0
    movsd xmm0, [rbp-1160]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1136]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1200], xmm0
    movsd xmm0, [rbp-1168]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1144]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1208], xmm0
    movsd xmm0, [rbp-1112]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1160]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1216], xmm0
    movsd xmm0, [rbp-1120]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1168]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1224], xmm0
    movsd xmm0, [rbp-1160]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1112]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1232], xmm0
    movsd xmm0, [rbp-1168]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1120]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1240], xmm0
    movsd xmm0, [rbp-1184]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1192]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1232]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1240]
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
    call cross
    add rsp, 32
    movsd [rbp-1248], xmm0
    movsd xmm0, [rbp-1248]
    movsd [rbp-1256], xmm0
    movsd xmm0, [rbp-1256]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt62: dq 0.0
section .text
    movsd xmm0, [rel .flt62]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L60
section .data
.flt63: dq 0.0
section .text
    movsd xmm0, [rel .flt63]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1256]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-1256], xmm0
    jmp .L61
.L60:
.L61:
    movsd xmm0, [rbp-1256]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt66: dq 0.5
section .text
    movsd xmm0, [rel .flt66]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L64
    mov rax, 0
    mov [rbp-1264], rax
    mov rax, 99
    mov [rbp-1272], rax
    mov rax, 0
    mov [rbp-1280], rax
    mov rax, 99
    mov [rbp-1288], rax
    mov rax, [rbp-1280]
    mov [rbp-1296], rax
.L67:
    mov rax, [rbp-1296]
    push rax
    mov rax, [rbp-1288]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L68
    mov rax, [rbp-1264]
    mov [rbp-1304], rax
.L69:
    mov rax, [rbp-1304]
    push rax
    mov rax, [rbp-1272]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L70
    mov rax, [rbp-1304]
    cvtsi2sd xmm0, rax
    movsd [rbp-1312], xmm0
    mov rax, [rbp-1296]
    cvtsi2sd xmm0, rax
    movsd [rbp-1320], xmm0
    movsd xmm0, [rbp-1184]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1192]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1312]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1112]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1320]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1120]
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
    call cross
    add rsp, 32
    movsd [rbp-1328], xmm0
    movsd xmm0, [rbp-1200]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1208]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1312]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1136]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1320]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1144]
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
    call cross
    add rsp, 32
    movsd [rbp-1336], xmm0
    movsd xmm0, [rbp-1216]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1224]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1312]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1160]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1320]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1168]
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
    call cross
    add rsp, 32
    movsd [rbp-1344], xmm0
    mov rax, 0
    mov [rbp-1352], rax
    movsd xmm0, [rbp-1248]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt73: dq 0.0
section .text
    movsd xmm0, [rel .flt73]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L71
    movsd xmm0, [rbp-1328]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt80: dq 0.0
section .text
    movsd xmm0, [rel .flt80]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L78
    movsd xmm0, [rbp-1336]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt81: dq 0.0
section .text
    movsd xmm0, [rel .flt81]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L78
    mov rax, 1
    jmp .L79
.L78:
    mov rax, 0
.L79:
    test rax, rax
    jz .L76
    movsd xmm0, [rbp-1344]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt82: dq 0.0
section .text
    movsd xmm0, [rel .flt82]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L76
    mov rax, 1
    jmp .L77
.L76:
    mov rax, 0
.L77:
    test rax, rax
    jz .L74
    mov rax, 1
    mov [rbp-1352], rax
    jmp .L75
.L74:
.L75:
    jmp .L72
.L71:
.L72:
    movsd xmm0, [rbp-1248]
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
    setb al
    movzx rax, al
    test rax, rax
    jz .L83
    movsd xmm0, [rbp-1328]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt92: dq 0.0
section .text
    movsd xmm0, [rel .flt92]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L90
    movsd xmm0, [rbp-1336]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt93: dq 0.0
section .text
    movsd xmm0, [rel .flt93]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L90
    mov rax, 1
    jmp .L91
.L90:
    mov rax, 0
.L91:
    test rax, rax
    jz .L88
    movsd xmm0, [rbp-1344]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt94: dq 0.0
section .text
    movsd xmm0, [rel .flt94]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L88
    mov rax, 1
    jmp .L89
.L88:
    mov rax, 0
.L89:
    test rax, rax
    jz .L86
    mov rax, 1
    mov [rbp-1352], rax
    jmp .L87
.L86:
.L87:
    jmp .L84
.L83:
.L84:
    mov rax, [rbp-1352]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L95
    movsd xmm0, [rbp-1328]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-1360], xmm0
    movsd xmm0, [rbp-1336]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-1368], xmm0
    movsd xmm0, [rbp-1344]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1248]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-1376], xmm0
    movsd xmm0, [rbp-1360]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1128]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1368]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1152]
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
    movsd xmm0, [rbp-1376]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-1384], xmm0
    mov rax, [rbp-1296]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-1304]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-1392], rax
    movsd xmm0, [rbp-1384]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-1392]
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
    jz .L97
    mov rax, [rbp-1392]
    push rax
    movsd xmm0, [rbp-1384]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, 99
    push rax
    mov rax, [rbp-1296]
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
    mov rax, [rbp-1304]
    push rax
    mov rax, 3
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-1400], rax
    mov rax, [rbp-1400]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-1080]
    mov rcx, rax
    lea rdx, [rbp-1072]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-1400]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-1080]
    mov rcx, rax
    lea rdx, [rbp-976]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-1400]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-1080]
    mov rcx, rax
    lea rdx, [rbp-880]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L98
.L97:
.L98:
    jmp .L96
.L95:
.L96:
    mov rax, [rbp-1304]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-1304], rax
    jmp .L69
.L70:
    mov rax, [rbp-1296]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-1296], rax
    jmp .L67
.L68:
    jmp .L65
.L64:
.L65:
    mov rax, [rbp-1080]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-1080], rax
    jmp .L58
.L59:
    mov rax, 5
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str99: db 111,117,116,46,98,109,112,0
section .text
    lea rax, [rel .str99]
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
    jmp .__ret_1
.__ret_1:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
