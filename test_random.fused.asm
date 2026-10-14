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
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm1, xmm6
    subsd xmm0, xmm1
    jmp .__ret_6
    jmp .L8
.L7:
.L8:
    movsd xmm0, xmm6
    jmp .__ret_6
.__ret_6:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fmin:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L12
    movsd xmm0, xmm7
    jmp .__ret_11
    jmp .L13
.L12:
.L13:
    movsd xmm0, xmm6
    jmp .__ret_11
.__ret_11:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fmax:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L15
    movsd xmm0, xmm7
    jmp .__ret_14
    jmp .L16
.L15:
.L16:
    movsd xmm0, xmm6
    jmp .__ret_14
.__ret_14:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fclamp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movsd xmm7, xmm0
    movsd [rbp-16], xmm1
    movsd xmm6, xmm2
    movsd xmm0, xmm7
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
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L20
    movsd xmm0, xmm6
    jmp .__ret_17
    jmp .L21
.L20:
.L21:
    movsd xmm0, xmm7
    jmp .__ret_17
.__ret_17:
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fsign:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ffloor:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
    movsd xmm7, xmm0
    movsd xmm0, xmm7
    cvttsd2si rax, xmm0
    mov rbx, rax
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L34
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    jmp .L35
.L34:
.L35:
    movsd xmm0, xmm6
    jmp .__ret_33
.__ret_33:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
fceil:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
    movsd xmm7, xmm0
    movsd xmm0, xmm7
    cvttsd2si rax, xmm0
    mov rbx, rax
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L38
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    jmp .L39
.L38:
.L39:
    movsd xmm0, xmm6
    jmp .__ret_37
.__ret_37:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
fround:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm1, xmm6
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
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fmod:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
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
    movsd xmm1, [rbp-16]
    divsd xmm0, xmm1
    movsd xmm7, xmm0
section .data
.flt53: dq 0.0
section .text
    movsd xmm0, [rel .flt53]
    movsd xmm6, xmm0
    movsd xmm0, xmm7
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
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fceil
    add rsp, 32
    movsd xmm6, xmm0
    jmp .L55
.L54:
.L55:
    movsd xmm0, xmm7
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
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call ffloor
    add rsp, 32
    movsd xmm6, xmm0
    jmp .L58
.L57:
.L58:
    movsd xmm0, [rbp-8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, [rbp-16]
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_48
.__ret_48:
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fsqrt:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
    movsd xmm7, xmm0
    movsd xmm0, xmm7
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
    movsd xmm0, xmm7
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    jmp .L66
.L65:
.L66:
    mov rax, 0
    mov rbx, rax
.L69:
    cmp rbx, 40
    jge .L70
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
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
    movsd xmm6, xmm0
    add rbx, 1
    jmp .L69
.L70:
    movsd xmm0, xmm6
    jmp .__ret_60
.__ret_60:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
flen2:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm7
    movsd xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
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
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
flen3:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movsd [rbp-8], xmm0
    movsd xmm7, xmm1
    movsd xmm6, xmm2
    movsd xmm0, [rbp-8]
    movsd xmm1, [rbp-8]
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm7
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
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
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fwrap_angle:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    jmp .L77
.L76:
.L77:
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    jmp .L81
.L80:
.L81:
    movsd xmm0, xmm6
    jmp .__ret_74
.__ret_74:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fsin:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fwrap_angle
    add rsp, 32
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, xmm6
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm6, xmm0
section .data
.flt86: dq 0.0
section .text
    movsd xmm0, [rel .flt86]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt88: dq 0.0
section .text
    movsd xmm0, [rel .flt88]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt90: dq 0.0
section .text
    movsd xmm0, [rel .flt90]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt92: dq 0.0
section .text
    movsd xmm0, [rel .flt92]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt94: dq 0.0
section .text
    movsd xmm0, [rel .flt94]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt96: dq 0.0
section .text
    movsd xmm0, [rel .flt96]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt98: dq 0.0
section .text
    movsd xmm0, [rel .flt98]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt100: dq 0.0
section .text
    movsd xmm0, [rel .flt100]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
section .data
.flt102: dq 0.0
section .text
    movsd xmm0, [rel .flt102]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-24]
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
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    jmp .__ret_85
.__ret_85:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
fcos:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ftan:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movsd xmm7, xmm0
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_106
.__ret_106:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fpowi:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movsd xmm7, xmm0
    mov r12, rdx
section .data
.flt112: dq 1.0
section .text
    movsd xmm0, [rel .flt112]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L113:
    cmp rbx, r12
    jge .L114
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    add rbx, 1
    jmp .L113
.L114:
    movsd xmm0, xmm6
    jmp .__ret_111
.__ret_111:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
deg_to_rad:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
rad_to_deg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
flerp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movsd xmm7, xmm0
    movsd [rbp-16], xmm1
    movsd xmm6, xmm2
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm7
    subsd xmm0, xmm1
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_119
.__ret_119:
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fdot3:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd [rbp-32], xmm3
    movsd xmm7, xmm4
    movsd xmm6, xmm5
    movsd xmm0, [rbp-8]
    movsd xmm1, [rbp-32]
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm7
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_120
.__ret_120:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
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
    sub rsp, 64
    movups [rbp-32], xmm6
section .data
.flt128: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt128]
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_127
.__ret_127:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fexp:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    movsd xmm7, xmm0
    movsd xmm0, xmm7
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
    movsd xmm0, xmm7
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
    movsd xmm0, xmm7
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
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    cvttsd2si rax, xmm0
    mov rbx, rax
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    movsd xmm7, xmm0
section .data
.flt139: dq 1.0
section .text
    movsd xmm0, [rel .flt139]
    movsd xmm6, xmm0
section .data
.flt140: dq 0.0
section .text
    movsd xmm0, [rel .flt140]
    movsd [rbp-56], xmm0
    mov rax, 1
    mov r12, rax
.L141:
    cmp r12, 11
    jg .L142
    mov rax, r12
    cvtsi2sd xmm0, rax
    movsd [rbp-56], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-32]
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-56]
    divsd xmm0, xmm1
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
    addsd xmm0, xmm1
    movsd xmm6, xmm0
    add r12, 1
    jmp .L141
.L142:
    cmp rbx, 0
    jl .L143
    mov rax, 0
    mov r12, rax
.L145:
    cmp r12, rbx
    jge .L146
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    add r12, 1
    jmp .L145
.L146:
    jmp .L144
.L143:
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    mov rax, 0
    mov r12, rax
.L148:
    cmp r12, rbx
    jge .L149
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    add r12, 1
    jmp .L148
.L149:
.L144:
    movsd xmm0, xmm6
    jmp .__ret_129
.__ret_129:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
fln:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    movups [rbp-112], xmm6
    movups [rbp-96], xmm7
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
    movsd xmm6, xmm0
    mov rax, 0
    mov r12, rax
.L156:
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    add r12, 1
    jmp .L156
.L157:
.L160:
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    sub r12, 1
    jmp .L160
.L161:
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd [rbp-40], xmm0
    movsd xmm0, xmm6
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    movsd xmm6, xmm0
section .data
.flt166: dq 0.0
section .text
    movsd xmm0, [rel .flt166]
    movsd [rbp-64], xmm0
    mov rax, 1
    mov rbx, rax
.L167:
    cmp rbx, 9
    jg .L168
    movsd xmm0, xmm7
    movsd xmm1, [rbp-40]
    mulsd xmm0, xmm1
    movsd xmm7, xmm0
    mov rax, 2
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
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
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, [rbp-64]
    divsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm6, xmm0
    add rbx, 1
    jmp .L167
.L168:
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
    mov rax, r12
    cvtsi2sd xmm0, rax
    movsd xmm7, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
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
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    movups xmm6, [rbp-112]
    movups xmm7, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
flog10:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
flog2:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fpow:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm7
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
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
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
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
sigmoid:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm1, xmm6
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fexp
    add rsp, 32
    movsd xmm6, xmm0
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
    movsd xmm1, xmm6
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_178
    jmp .L180
.L179:
.L180:
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fexp
    add rsp, 32
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt185: dq 1.0
section .text
    movsd xmm0, [rel .flt185]
    movsd xmm1, xmm6
    addsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_178
.__ret_178:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sigmoid_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt187: dq 1.0
section .text
    movsd xmm0, [rel .flt187]
    movsd xmm1, xmm6
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    jmp .__ret_186
.__ret_186:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ftanh:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fexp
    add rsp, 32
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
tanh_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
section .data
.flt203: dq 1.0
section .text
    movsd xmm0, [rel .flt203]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_202
.__ret_202:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
relu:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
relu_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
cross_entropy:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
section .data
.flt218: dq 0.0
section .text
    movsd xmm0, [rel .flt218]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    movsd xmm1, xmm7
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt220: dq 1.0
section .text
    movsd xmm0, [rel .flt220]
    movsd xmm1, xmm6
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
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
squared_error:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    subsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_221
.__ret_221:
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
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
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    mov rax, [rel __g_st_n]
    cmp rax, 1024
    jge .L224
    mov rax, [rel __g_st_n]
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_n]
    add rax, 1
    mov [rel __g_st_n], rax
    jmp .L225
.L224:
.L225:
    mov rax, 0
    jmp .__ret_223
.__ret_223:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
st_push_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    mov rax, [rel __g_st_ny]
    cmp rax, 1024
    jge .L227
    mov rax, [rel __g_st_ny]
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_ny]
    add rax, 1
    mov [rel __g_st_ny], rax
    jmp .L228
.L227:
.L228:
    mov rax, 0
    jmp .__ret_226
.__ret_226:
    movups xmm6, [rbp-32]
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
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_230
.__ret_230:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
st_min:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L232:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L233
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L234
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    jmp .L235
.L234:
.L235:
    add rbx, 1
    jmp .L232
.L233:
    movsd xmm0, xmm6
    jmp .__ret_231
.__ret_231:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
st_max:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L237:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L238
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L239
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    jmp .L240
.L239:
.L240:
    add rbx, 1
    jmp .L237
.L238:
    movsd xmm0, xmm6
    jmp .__ret_236
.__ret_236:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
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
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
section .data
.flt243: dq 0.0
section .text
    movsd xmm0, [rel .flt243]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L244:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L245
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm6, xmm0
    add rbx, 1
    jmp .L244
.L245:
    movsd xmm0, xmm6
    jmp .__ret_242
.__ret_242:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
st_mean:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
section .data
.flt247: dq 0.0
section .text
    movsd xmm0, [rel .flt247]
    movsd xmm6, xmm0
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    sub rsp, 32
    call st_sum
    add rsp, 32
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_246
.__ret_246:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
st_var:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
section .data
.flt249: dq 0.0
section .text
    movsd xmm0, [rel .flt249]
    movsd xmm7, xmm0
section .data
.flt250: dq 0.0
section .text
    movsd xmm0, [rel .flt250]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L251:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L252
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-8]
    subsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm7, xmm0
    add rbx, 1
    jmp .L251
.L252:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_248
.__ret_248:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
st_var_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
    sub rsp, 32
    call st_mean
    add rsp, 32
    movsd [rbp-8], xmm0
section .data
.flt254: dq 0.0
section .text
    movsd xmm0, [rel .flt254]
    movsd xmm7, xmm0
section .data
.flt255: dq 0.0
section .text
    movsd xmm0, [rel .flt255]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L256:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L257
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-8]
    subsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm7, xmm0
    add rbx, 1
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
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_253
.__ret_253:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
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
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
section .data
.flt261: dq 0.0
section .text
    movsd xmm0, [rel .flt261]
    movsd xmm6, xmm0
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L262:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L263
    mov rax, rbx
    push rax
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    add rbx, 1
    jmp .L262
.L263:
    mov rax, 1
    mov rbx, rax
.L264:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L265
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L266:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L268
    mov rax, r12
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    mov rax, r12
    add rax, 1
    push rax
    mov rax, r12
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    sub r12, 1
    jmp .L266
.L267:
    mov rax, r12
    add rax, 1
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    add rbx, 1
    jmp .L264
.L265:
    mov rax, 0
    jmp .__ret_260
.__ret_260:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
st_sorted_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_270
.__ret_270:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
st_median:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
    mov rax, 0
    mov rbx, rax
section .data
.flt272: dq 0.0
section .text
    movsd xmm0, [rel .flt272]
    movsd xmm7, xmm0
section .data
.flt273: dq 0.0
section .text
    movsd xmm0, [rel .flt273]
    movsd xmm6, xmm0
    sub rsp, 32
    call st_sort
    add rsp, 32
    mov rax, [rel __g_st_n]
    mov rcx, 2
    cqo
    idiv rcx
    mov rbx, rax
    mov rax, [rel __g_st_n]
    mov rcx, 2
    cqo
    idiv rcx
    mov rax, rdx
    cmp rax, 1
    jne .L274
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_271
    jmp .L275
.L274:
.L275:
    mov rax, rbx
    sub rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm7, xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
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
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
st_percentile:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    movups [rbp-88], xmm6
    movups [rbp-72], xmm7
    movsd [rbp-8], xmm0
section .data
.flt278: dq 0.0
section .text
    movsd xmm0, [rel .flt278]
    movsd xmm7, xmm0
    mov rax, 0
    mov rbx, rax
section .data
.flt279: dq 0.0
section .text
    movsd xmm0, [rel .flt279]
    movsd xmm6, xmm0
section .data
.flt280: dq 0.0
section .text
    movsd xmm0, [rel .flt280]
    movsd xmm6, xmm0
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
    movsd xmm6, xmm0
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
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm7, xmm0
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call ffloor
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L282
    mov rax, [rel __g_st_n]
    sub rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_277
    jmp .L283
.L282:
.L283:
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    subsd xmm0, xmm1
    movsd xmm6, xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    add rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
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
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
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
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    movups [rbp-56], xmm6
section .data
.flt290: dq 0.0
section .text
    movsd xmm0, [rel .flt290]
    movsd xmm6, xmm0
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov r12, rax
    sub rsp, 32
    call st_sort
    add rsp, 32
    mov rax, 0
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L291:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L292
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    sub rax, 1
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
    add r12, 1
    jmp .L294
.L293:
    mov rax, 1
    mov r12, rax
.L294:
    cmp r12, r13
    jle .L295
    mov rax, r12
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    jmp .L296
.L295:
.L296:
    add rbx, 1
    jmp .L291
.L292:
    movsd xmm0, xmm6
    jmp .__ret_289
.__ret_289:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    movups xmm6, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
st_mean_y:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
section .data
.flt298: dq 0.0
section .text
    movsd xmm0, [rel .flt298]
    movsd xmm7, xmm0
section .data
.flt299: dq 0.0
section .text
    movsd xmm0, [rel .flt299]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L300:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_ny]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L301
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm7, xmm0
    add rbx, 1
    jmp .L300
.L301:
    mov rax, [rel __g_st_ny]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_297
.__ret_297:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
st_covar:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    movups [rbp-88], xmm6
    movups [rbp-72], xmm7
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
    movsd xmm7, xmm0
section .data
.flt304: dq 0.0
section .text
    movsd xmm0, [rel .flt304]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L305:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L306
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-8]
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-16]
    subsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm7, xmm0
    add rbx, 1
    jmp .L305
.L306:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_302
.__ret_302:
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
st_corr:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    movups [rbp-104], xmm6
    movups [rbp-88], xmm7
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
    movsd xmm7, xmm0
section .data
.flt312: dq 0.0
section .text
    movsd xmm0, [rel .flt312]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L313:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L314
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-8]
    subsd xmm0, xmm1
    movsd xmm7, xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-16]
    subsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-24], xmm0
    movsd xmm0, [rbp-32]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm7
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-32], xmm0
    movsd xmm0, [rbp-40]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-40], xmm0
    add rbx, 1
    jmp .L313
.L314:
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, [rbp-40]
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
    mov rbx, [rbp-112]
    movups xmm6, [rbp-104]
    movups xmm7, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
linreg_slope:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    movups [rbp-88], xmm6
    movups [rbp-72], xmm7
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
    movsd xmm7, xmm0
section .data
.flt318: dq 0.0
section .text
    movsd xmm0, [rel .flt318]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L319:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L320
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-8]
    subsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm1, [rbp-16]
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
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd xmm7, xmm0
    add rbx, 1
    jmp .L319
.L320:
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm7
    divsd xmm0, xmm1
    jmp .__ret_315
.__ret_315:
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
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
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_322
.__ret_322:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
linreg_r2:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    sub rsp, 32
    call st_corr
    add rsp, 32
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_323
.__ret_323:
    movups xmm6, [rbp-32]
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
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_rnd_state], rax
    mov rax, [rel __g_rnd_state]
    cmp rax, 0
    jge .L326
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
    mov rbx, [rbp-32]
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
    mov rcx, 1013904223
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
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    sub rsp, 32
    call rnd_next
    add rsp, 32
    cvtsi2sd xmm0, rax
    movsd xmm7, xmm0
    sub rsp, 32
    call rnd_modulus
    add rsp, 32
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_329
.__ret_329:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
rnd_range:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movsd xmm7, xmm0
    movsd xmm6, xmm1
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
    movsd xmm1, xmm7
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
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
rnd_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jg .L332
    mov rax, 0
    jmp .__ret_331
    jmp .L333
.L332:
.L333:
    sub rsp, 32
    call rnd_next
    add rsp, 32
    mov rcx, rbx
    cqo
    idiv rcx
    mov rax, rdx
    jmp .__ret_331
.__ret_331:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
rnd_int_range:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    cmp rbx, r12
    jg .L335
    mov rax, r12
    jmp .__ret_334
    jmp .L336
.L335:
.L336:
    mov rax, r12
    push rax
    mov rax, rbx
    sub rax, r12
    add rax, 1
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
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
rnd_bool:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movsd xmm6, xmm0
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
rnd_normal:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movsd [rbp-8], xmm0
    movsd [rbp-16], xmm1
    mov rax, [rel __g_rnd_have_spare]
    cmp rax, 1
    jne .L341
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
    movsd xmm6, xmm0
    sub rsp, 32
    call rnd_uniform
    add rsp, 32
    movsd [rbp-32], xmm0
    movsd xmm0, xmm6
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
    movsd xmm6, xmm0
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
    movsd xmm0, xmm6
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
    movsd xmm7, xmm0
    sub rsp, 32
    call m_tau
    add rsp, 32
    movsd xmm1, [rbp-32]
    mulsd xmm0, xmm1
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    movsd xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
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
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    mov r12, rcx
    movsd xmm7, xmm1
    movsd xmm6, xmm2
    mov rax, 0
    mov [rel __g_st_n], rax
    mov rax, 0
    mov rbx, rax
.L353:
    cmp rbx, r12
    jge .L354
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    add rbx, 1
    jmp .L353
.L354:
    mov rax, 0
    jmp .__ret_352
.__ret_352:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
rnd_fill_y:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    mov r12, rcx
    movsd xmm7, xmm1
    movsd xmm6, xmm2
    mov rax, 0
    mov [rel __g_st_ny], rax
    mov rax, 0
    mov rbx, rax
.L356:
    cmp rbx, r12
    jge .L357
    movsd xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm6
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
    add rbx, 1
    jmp .L356
.L357:
    mov rax, 0
    jmp .__ret_355
.__ret_355:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
rnd_fill_linear:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    mov r12, rcx
    movsd [rbp-16], xmm1
    movsd [rbp-24], xmm2
    movsd xmm7, xmm3
section .data
.flt359: dq 0.0
section .text
    movsd xmm0, [rel .flt359]
    movsd xmm6, xmm0
    mov rax, r12
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    sub rsp, 32
    call st_clear
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L360:
    cmp rbx, r12
    jge .L361
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
    movsd xmm0, [rbp-16]
    movsd xmm1, xmm6
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-24]
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt362: dq 0.0
section .text
    movsd xmm0, [rel .flt362]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, xmm7
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
    add rbx, 1
    jmp .L360
.L361:
    mov rax, 0
    jmp .__ret_358
.__ret_358:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
rnd_shuffle:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
    mov rax, 0
    mov r12, rax
section .data
.flt364: dq 0.0
section .text
    movsd xmm0, [rel .flt364]
    movsd xmm6, xmm0
section .data
.flt365: dq 0.0
section .text
    movsd xmm0, [rel .flt365]
    movsd xmm6, xmm0
    mov rax, [rel __g_st_n]
    sub rax, 1
    mov rbx, rax
.L366:
    cmp rbx, 0
    jle .L367
    mov rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, r12
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, r12
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    sub rbx, 1
    jmp .L366
.L367:
    mov rax, 0
    jmp .__ret_363
.__ret_363:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rcx, 42
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
    mov rcx, 42
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
    mov rcx, 42
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    mov rcx, 100
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, 100
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, 100
    sub rsp, 32
    call rnd_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, 42
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
    mov rcx, 7
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L373:
    cmp rbx, 1000
    jge .L374
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
    add rbx, 1
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
    mov rcx, 7
    sub rsp, 32
    call rnd_seed
    add rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L375:
    cmp rbx, 1000
    jge .L376
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
    add rbx, 1
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
    mov rcx, 123
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
    mov rcx, 99
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
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
