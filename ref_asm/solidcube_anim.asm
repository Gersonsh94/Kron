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
section .bss
__g_namebuf: resq 4
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
main:
    push rbp
    mov rbp, rsp
    sub rsp, 480
    lea rax, [rel __g_buf]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    push rax
    mov rax, 54
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    lea rax, [rel __g_namebuf]
    mov [rbp-24], rax
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
    push rax
section .data
.flt2: dq 0.0
section .text
    movsd xmm0, [rel .flt2]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3: dq 1.0
section .text
    movsd xmm0, [rel .flt3]
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
.flt4: dq 0.0
section .text
    movsd xmm0, [rel .flt4]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt5: dq 1.0
section .text
    movsd xmm0, [rel .flt5]
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
.flt6: dq 0.0
section .text
    movsd xmm0, [rel .flt6]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt7: dq 1.0
section .text
    movsd xmm0, [rel .flt7]
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
.flt8: dq 1.0
section .text
    movsd xmm0, [rel .flt8]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
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
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
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
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt13: dq 1.0
section .text
    movsd xmm0, [rel .flt13]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    push rax
section .data
.flt14: dq 1.0
section .text
    movsd xmm0, [rel .flt14]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
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
    mov rax, 3
    push rax
section .data
.flt17: dq 0.0
section .text
    movsd xmm0, [rel .flt17]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt18: dq 1.0
section .text
    movsd xmm0, [rel .flt18]
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
.flt19: dq 1.0
section .text
    movsd xmm0, [rel .flt19]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
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
    mov rax, 4
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
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
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
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    push rax
section .data
.flt26: dq 1.0
section .text
    movsd xmm0, [rel .flt26]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt27: dq 1.0
section .text
    movsd xmm0, [rel .flt27]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    push rax
section .data
.flt28: dq 0.0
section .text
    movsd xmm0, [rel .flt28]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt29: dq 1.0
section .text
    movsd xmm0, [rel .flt29]
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
.flt30: dq 1.0
section .text
    movsd xmm0, [rel .flt30]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt31: dq 1.0
section .text
    movsd xmm0, [rel .flt31]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt32: dq 1.0
section .text
    movsd xmm0, [rel .flt32]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    push rax
section .data
.flt33: dq 1.0
section .text
    movsd xmm0, [rel .flt33]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt34: dq 0.0
section .text
    movsd xmm0, [rel .flt34]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt35: dq 1.0
section .text
    movsd xmm0, [rel .flt35]
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
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    push rax
section .data
.flt37: dq 1.0
section .text
    movsd xmm0, [rel .flt37]
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
section .data
.flt38: dq 0.85
section .text
    movsd xmm0, [rel .flt38]
    movsd [rbp-32], xmm0
section .data
.flt39: dq 0.527
section .text
    movsd xmm0, [rel .flt39]
    movsd [rbp-40], xmm0
    mov rax, 0
    mov [rbp-48], rax
.L40:
    mov rax, [rbp-48]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L41
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
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
    subsd xmm0, xmm1
    movsd [rbp-56], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-40]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-64], xmm0
    mov rax, [rbp-48]
    push rax
    movsd xmm0, [rbp-56]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
    movsd xmm0, [rbp-64]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-48], rax
    jmp .L40
.L41:
section .data
.flt42: dq 0.951
section .text
    movsd xmm0, [rel .flt42]
    movsd [rbp-72], xmm0
section .data
.flt43: dq 0.309
section .text
    movsd xmm0, [rel .flt43]
    movsd [rbp-80], xmm0
    mov rax, 0
    mov [rbp-88], rax
.L44:
    mov rax, [rbp-88]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L45
    mov rax, 0
    mov [rbp-48], rax
.L46:
    mov rax, [rbp-48]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L47
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-72]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-80]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-96], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-72]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-80]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-64], xmm0
    mov rax, [rbp-48]
    push rax
    movsd xmm0, [rbp-96]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
    movsd xmm0, [rbp-64]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-48], rax
    jmp .L46
.L47:
    mov rax, 0
    mov [rbp-48], rax
.L48:
    mov rax, [rbp-48]
    push rax
    mov rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L49
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt50: dq 4.0
section .text
    movsd xmm0, [rel .flt50]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-104], xmm0
    mov rax, [rbp-48]
    push rax
section .data
.flt51: dq 50.0
section .text
    movsd xmm0, [rel .flt51]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt52: dq 90.0
section .text
    movsd xmm0, [rel .flt52]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-104]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_sx]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
section .data
.flt53: dq 50.0
section .text
    movsd xmm0, [rel .flt53]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-48]
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt54: dq 90.0
section .text
    movsd xmm0, [rel .flt54]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-104]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_sy]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
    movsd xmm0, [rbp-104]
    pop rcx
    lea rdx, [rel __g_sz]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-48]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-48], rax
    jmp .L48
.L49:
    mov rax, 0
    mov [rbp-112], rax
.L55:
    mov rax, [rbp-112]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L56
    mov rax, 0
    mov [rbp-120], rax
.L57:
    mov rax, [rbp-120]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L58
    mov rax, [rbp-16]
    push rax
    mov rax, [rbp-112]
    push rax
    mov rax, 300
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-120]
    push rax
    mov rax, 3
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-128], rax
    mov rax, [rbp-128]
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
    mov rax, [rbp-128]
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
    mov rax, [rbp-128]
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
    mov rax, [rbp-112]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-120]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
section .data
.flt59: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt59]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-120]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-120], rax
    jmp .L57
.L58:
    mov rax, [rbp-112]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-112], rax
    jmp .L55
.L56:
    mov rax, 0
    mov [rbp-136], rax
.L60:
    mov rax, [rbp-136]
    push rax
    mov rax, 12
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L61
    mov rax, [rbp-136]
    mov rcx, rax
    lea rdx, [rel __g_t0]
    mov rax, [rdx+rcx*8]
    mov [rbp-144], rax
    mov rax, [rbp-136]
    mov rcx, rax
    lea rdx, [rel __g_t1]
    mov rax, [rdx+rcx*8]
    mov [rbp-152], rax
    mov rax, [rbp-136]
    mov rcx, rax
    lea rdx, [rel __g_t2]
    mov rax, [rdx+rcx*8]
    mov [rbp-160], rax
    mov rax, [rbp-144]
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-168], xmm0
    mov rax, [rbp-144]
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-176], xmm0
    mov rax, [rbp-144]
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-184], xmm0
    mov rax, [rbp-152]
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-192], xmm0
    mov rax, [rbp-152]
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-200], xmm0
    mov rax, [rbp-152]
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-208], xmm0
    mov rax, [rbp-160]
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-216], xmm0
    mov rax, [rbp-160]
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-224], xmm0
    mov rax, [rbp-160]
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-232], xmm0
    movsd xmm0, [rbp-192]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-168]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-240], xmm0
    movsd xmm0, [rbp-200]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-248], xmm0
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-192]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-256], xmm0
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-200]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-264], xmm0
    movsd xmm0, [rbp-168]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-216]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-272], xmm0
    movsd xmm0, [rbp-176]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-224]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-280], xmm0
    movsd xmm0, [rbp-216]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-168]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-288], xmm0
    movsd xmm0, [rbp-224]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-176]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-296], xmm0
    movsd xmm0, [rbp-240]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-248]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-288]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-296]
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
    movsd [rbp-304], xmm0
    movsd xmm0, [rbp-304]
    movsd [rbp-312], xmm0
    movsd xmm0, [rbp-312]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt64: dq 0.0
section .text
    movsd xmm0, [rel .flt64]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L62
section .data
.flt65: dq 0.0
section .text
    movsd xmm0, [rel .flt65]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-312]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-312], xmm0
    jmp .L63
.L62:
.L63:
    movsd xmm0, [rbp-312]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt68: dq 0.5
section .text
    movsd xmm0, [rel .flt68]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L66
    mov rax, 0
    mov [rbp-320], rax
.L69:
    mov rax, [rbp-320]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L70
    mov rax, 0
    mov [rbp-328], rax
.L71:
    mov rax, [rbp-328]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L72
    mov rax, [rbp-328]
    cvtsi2sd xmm0, rax
    movsd [rbp-336], xmm0
    mov rax, [rbp-320]
    cvtsi2sd xmm0, rax
    movsd [rbp-344], xmm0
    movsd xmm0, [rbp-240]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-248]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-336]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-168]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-344]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-176]
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
    movsd [rbp-352], xmm0
    movsd xmm0, [rbp-256]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-264]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-336]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-192]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-344]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-200]
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
    movsd [rbp-360], xmm0
    movsd xmm0, [rbp-272]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-280]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-336]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-216]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-344]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-224]
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
    movsd [rbp-368], xmm0
    mov rax, 0
    mov [rbp-376], rax
    movsd xmm0, [rbp-304]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt75: dq 0.0
section .text
    movsd xmm0, [rel .flt75]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L73
    movsd xmm0, [rbp-352]
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
    jz .L80
    movsd xmm0, [rbp-360]
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
    jz .L80
    mov rax, 1
    jmp .L81
.L80:
    mov rax, 0
.L81:
    test rax, rax
    jz .L78
    movsd xmm0, [rbp-368]
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
    jz .L78
    mov rax, 1
    jmp .L79
.L78:
    mov rax, 0
.L79:
    test rax, rax
    jz .L76
    mov rax, 1
    mov [rbp-376], rax
    jmp .L77
.L76:
.L77:
    jmp .L74
.L73:
.L74:
    movsd xmm0, [rbp-304]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt87: dq 0.0
section .text
    movsd xmm0, [rel .flt87]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L85
    movsd xmm0, [rbp-352]
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
    jz .L92
    movsd xmm0, [rbp-360]
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
    jz .L92
    mov rax, 1
    jmp .L93
.L92:
    mov rax, 0
.L93:
    test rax, rax
    jz .L90
    movsd xmm0, [rbp-368]
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
    jz .L90
    mov rax, 1
    jmp .L91
.L90:
    mov rax, 0
.L91:
    test rax, rax
    jz .L88
    mov rax, 1
    mov [rbp-376], rax
    jmp .L89
.L88:
.L89:
    jmp .L86
.L85:
.L86:
    mov rax, [rbp-376]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L97
    movsd xmm0, [rbp-352]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-304]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-384], xmm0
    movsd xmm0, [rbp-360]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-304]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-392], xmm0
    movsd xmm0, [rbp-368]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-304]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movsd [rbp-400], xmm0
    movsd xmm0, [rbp-384]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-184]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-392]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-208]
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
    movsd xmm0, [rbp-400]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-232]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-408], xmm0
    mov rax, [rbp-320]
    push rax
    mov rax, 100
    mov rcx, rax
    pop rax
    imul rax, rcx
    push rax
    mov rax, [rbp-328]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-416], rax
    movsd xmm0, [rbp-408]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rbp-416]
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
    jz .L99
    mov rax, [rbp-416]
    push rax
    movsd xmm0, [rbp-408]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, 99
    push rax
    mov rax, [rbp-320]
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
    mov rax, [rbp-328]
    push rax
    mov rax, 3
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-424], rax
    mov rax, [rbp-424]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-136]
    mov rcx, rax
    lea rdx, [rel __g_tb]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-424]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-136]
    mov rcx, rax
    lea rdx, [rel __g_tg]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-424]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-136]
    mov rcx, rax
    lea rdx, [rel __g_tr]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L100
.L99:
.L100:
    jmp .L98
.L97:
.L98:
    mov rax, [rbp-328]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-328], rax
    jmp .L71
.L72:
    mov rax, [rbp-320]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-320], rax
    jmp .L69
.L70:
    jmp .L67
.L66:
.L67:
    mov rax, [rbp-136]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-136], rax
    jmp .L60
.L61:
    mov rax, [rbp-24]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 102
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 48
    push rax
    mov rax, [rbp-88]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 2
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 46
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 3
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 98
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 4
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 109
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 5
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 112
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
    push rax
    mov rax, 6
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-24]
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
    mov rax, [rbp-88]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-88]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-88], rax
    jmp .L44
.L45:
    mov rax, 0
    jmp .__ret_1
.__ret_1:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
