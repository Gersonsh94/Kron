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
    jmp .__ret_121
.__ret_121:
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
    jge .L123
    mov rax, [rel __g_st_n]
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_x]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_n]
    add rax, 1
    mov [rel __g_st_n], rax
    jmp .L124
.L123:
.L124:
    mov rax, 0
    jmp .__ret_122
.__ret_122:
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
    jge .L126
    mov rax, [rel __g_st_ny]
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_ny]
    add rax, 1
    mov [rel __g_st_ny], rax
    jmp .L127
.L126:
.L127:
    mov rax, 0
    jmp .__ret_125
.__ret_125:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
st_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_st_n]
    jmp .__ret_128
.__ret_128:
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
    jmp .__ret_129
.__ret_129:
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
.L131:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L132
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
    jz .L133
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    jmp .L134
.L133:
.L134:
    add rbx, 1
    jmp .L131
.L132:
    movsd xmm0, xmm6
    jmp .__ret_130
.__ret_130:
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
.L136:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L137
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
    jz .L138
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    jmp .L139
.L138:
.L139:
    add rbx, 1
    jmp .L136
.L137:
    movsd xmm0, xmm6
    jmp .__ret_135
.__ret_135:
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
    jmp .__ret_140
.__ret_140:
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
.flt142: dq 0.0
section .text
    movsd xmm0, [rel .flt142]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L143:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L144
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
    jmp .L143
.L144:
    movsd xmm0, xmm6
    jmp .__ret_141
.__ret_141:
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
.flt146: dq 0.0
section .text
    movsd xmm0, [rel .flt146]
    movsd xmm6, xmm0
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    sub rsp, 32
    call st_sum
    add rsp, 32
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_145
.__ret_145:
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
.flt148: dq 0.0
section .text
    movsd xmm0, [rel .flt148]
    movsd xmm7, xmm0
section .data
.flt149: dq 0.0
section .text
    movsd xmm0, [rel .flt149]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L150:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L151
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
    jmp .L150
.L151:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_147
.__ret_147:
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
.flt153: dq 0.0
section .text
    movsd xmm0, [rel .flt153]
    movsd xmm7, xmm0
section .data
.flt154: dq 0.0
section .text
    movsd xmm0, [rel .flt154]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L155:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L156
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
    jmp .L155
.L156:
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
    jmp .__ret_152
.__ret_152:
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
    jmp .__ret_157
.__ret_157:
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
    jmp .__ret_158
.__ret_158:
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
.flt160: dq 0.0
section .text
    movsd xmm0, [rel .flt160]
    movsd xmm6, xmm0
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L161:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L162
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
    jmp .L161
.L162:
    mov rax, 1
    mov rbx, rax
.L163:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L164
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L165:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L167
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
    jz .L167
    mov rax, 1
    jmp .L168
.L167:
    mov rax, 0
.L168:
    test rax, rax
    jz .L166
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
    jmp .L165
.L166:
    mov rax, r12
    add rax, 1
    push rax
    movsd xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    add rbx, 1
    jmp .L163
.L164:
    mov rax, 0
    jmp .__ret_159
.__ret_159:
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
    jmp .__ret_169
.__ret_169:
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
.flt171: dq 0.0
section .text
    movsd xmm0, [rel .flt171]
    movsd xmm7, xmm0
section .data
.flt172: dq 0.0
section .text
    movsd xmm0, [rel .flt172]
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
    jne .L173
    mov rax, rbx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_170
    jmp .L174
.L173:
.L174:
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
.flt175: dq 2.0
section .text
    movsd xmm0, [rel .flt175]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_170
.__ret_170:
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
.flt177: dq 0.0
section .text
    movsd xmm0, [rel .flt177]
    movsd xmm7, xmm0
    mov rax, 0
    mov rbx, rax
section .data
.flt178: dq 0.0
section .text
    movsd xmm0, [rel .flt178]
    movsd xmm6, xmm0
section .data
.flt179: dq 0.0
section .text
    movsd xmm0, [rel .flt179]
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
.flt180: dq 100.0
section .text
    movsd xmm0, [rel .flt180]
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
    jl .L181
    mov rax, [rel __g_st_n]
    sub rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_176
    jmp .L182
.L181:
.L182:
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
    jmp .__ret_176
.__ret_176:
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
.flt184: dq 25.0
section .text
    movsd xmm0, [rel .flt184]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    jmp .__ret_183
.__ret_183:
    mov rsp, rbp
    pop rbp
    ret
st_q3:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt186: dq 75.0
section .text
    movsd xmm0, [rel .flt186]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    jmp .__ret_185
.__ret_185:
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
    jmp .__ret_187
.__ret_187:
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
.flt189: dq 0.0
section .text
    movsd xmm0, [rel .flt189]
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
.L190:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L191
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
    jz .L192
    add r12, 1
    jmp .L193
.L192:
    mov rax, 1
    mov r12, rax
.L193:
    cmp r12, r13
    jle .L194
    mov rax, r12
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movsd xmm6, xmm0
    jmp .L195
.L194:
.L195:
    add rbx, 1
    jmp .L190
.L191:
    movsd xmm0, xmm6
    jmp .__ret_188
.__ret_188:
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
.flt197: dq 0.0
section .text
    movsd xmm0, [rel .flt197]
    movsd xmm7, xmm0
section .data
.flt198: dq 0.0
section .text
    movsd xmm0, [rel .flt198]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L199:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_ny]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L200
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
    jmp .L199
.L200:
    mov rax, [rel __g_st_ny]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_196
.__ret_196:
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
.flt202: dq 0.0
section .text
    movsd xmm0, [rel .flt202]
    movsd xmm7, xmm0
section .data
.flt203: dq 0.0
section .text
    movsd xmm0, [rel .flt203]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L204:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L205
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
    jmp .L204
.L205:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movsd xmm6, xmm0
    movsd xmm0, xmm7
    movsd xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_201
.__ret_201:
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
.flt207: dq 0.0
section .text
    movsd xmm0, [rel .flt207]
    movsd [rbp-24], xmm0
section .data
.flt208: dq 0.0
section .text
    movsd xmm0, [rel .flt208]
    movsd [rbp-32], xmm0
section .data
.flt209: dq 0.0
section .text
    movsd xmm0, [rel .flt209]
    movsd [rbp-40], xmm0
section .data
.flt210: dq 0.0
section .text
    movsd xmm0, [rel .flt210]
    movsd xmm7, xmm0
section .data
.flt211: dq 0.0
section .text
    movsd xmm0, [rel .flt211]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L212:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L213
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
    jmp .L212
.L213:
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
    jmp .__ret_206
.__ret_206:
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
.flt215: dq 0.0
section .text
    movsd xmm0, [rel .flt215]
    movsd [rbp-24], xmm0
section .data
.flt216: dq 0.0
section .text
    movsd xmm0, [rel .flt216]
    movsd xmm7, xmm0
section .data
.flt217: dq 0.0
section .text
    movsd xmm0, [rel .flt217]
    movsd xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L218:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L219
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
    jmp .L218
.L219:
    movsd xmm0, [rbp-24]
    movsd xmm1, xmm7
    divsd xmm0, xmm1
    jmp .__ret_214
.__ret_214:
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
    jmp .__ret_220
.__ret_220:
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
    jmp .__ret_221
.__ret_221:
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
    jmp .__ret_222
.__ret_222:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt224: dq 2.0
section .text
    movsd xmm0, [rel .flt224]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt225: dq 4.0
section .text
    movsd xmm0, [rel .flt225]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt226: dq 4.0
section .text
    movsd xmm0, [rel .flt226]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt227: dq 4.0
section .text
    movsd xmm0, [rel .flt227]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt228: dq 5.0
section .text
    movsd xmm0, [rel .flt228]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt229: dq 5.0
section .text
    movsd xmm0, [rel .flt229]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt230: dq 7.0
section .text
    movsd xmm0, [rel .flt230]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt231: dq 9.0
section .text
    movsd xmm0, [rel .flt231]
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
    call __print_float
    sub rsp, 32
    call st_mean
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
    sub rsp, 32
    call st_range
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_var
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_stddev
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_median
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_mode
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt232: dq 1.0
section .text
    movsd xmm0, [rel .flt232]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt233: dq 2.0
section .text
    movsd xmm0, [rel .flt233]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt234: dq 3.0
section .text
    movsd xmm0, [rel .flt234]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt235: dq 4.0
section .text
    movsd xmm0, [rel .flt235]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt236: dq 5.0
section .text
    movsd xmm0, [rel .flt236]
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
    call __print_float
section .data
.flt237: dq 0.0
section .text
    movsd xmm0, [rel .flt237]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    call __print_float
section .data
.flt238: dq 50.0
section .text
    movsd xmm0, [rel .flt238]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    call __print_float
section .data
.flt239: dq 100.0
section .text
    movsd xmm0, [rel .flt239]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_q1
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_q3
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_iqr
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_var
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_var_sample
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_clear
    add rsp, 32
section .data
.flt240: dq 1.0
section .text
    movsd xmm0, [rel .flt240]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt241: dq 2.0
section .text
    movsd xmm0, [rel .flt241]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt242: dq 3.0
section .text
    movsd xmm0, [rel .flt242]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt243: dq 4.0
section .text
    movsd xmm0, [rel .flt243]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt244: dq 5.0
section .text
    movsd xmm0, [rel .flt244]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt245: dq 3.0
section .text
    movsd xmm0, [rel .flt245]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt246: dq 5.0
section .text
    movsd xmm0, [rel .flt246]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt247: dq 7.0
section .text
    movsd xmm0, [rel .flt247]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt248: dq 9.0
section .text
    movsd xmm0, [rel .flt248]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt249: dq 11.0
section .text
    movsd xmm0, [rel .flt249]
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
    call __print_float
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    call __print_float
section .data
.flt250: dq 10.0
section .text
    movsd xmm0, [rel .flt250]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call linreg_predict
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_corr
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
.flt251: dq 1.0
section .text
    movsd xmm0, [rel .flt251]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt252: dq 2.0
section .text
    movsd xmm0, [rel .flt252]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt253: dq 3.0
section .text
    movsd xmm0, [rel .flt253]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt254: dq 4.0
section .text
    movsd xmm0, [rel .flt254]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push
    add rsp, 32
section .data
.flt255: dq 2.0
section .text
    movsd xmm0, [rel .flt255]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt256: dq 4.0
section .text
    movsd xmm0, [rel .flt256]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt257: dq 5.0
section .text
    movsd xmm0, [rel .flt257]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_push_y
    add rsp, 32
section .data
.flt258: dq 8.0
section .text
    movsd xmm0, [rel .flt258]
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
    call __print_float
    sub rsp, 32
    call linreg_intercept
    add rsp, 32
    call __print_float
    sub rsp, 32
    call st_covar
    add rsp, 32
    call __print_float
    mov rax, 0
    jmp .__ret_223
.__ret_223:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
