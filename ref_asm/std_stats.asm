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
    jmp .__ret_0
.__ret_0:
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
    jz .L2
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
    jmp .L3
.L2:
.L3:
    mov rax, 0
    jmp .__ret_1
.__ret_1:
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
    jz .L5
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
    jmp .L6
.L5:
.L6:
    mov rax, 0
    jmp .__ret_4
.__ret_4:
    mov rsp, rbp
    pop rbp
    ret
st_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_st_n]
    jmp .__ret_7
.__ret_7:
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
    jmp .__ret_8
.__ret_8:
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
.L10:
    mov rax, [rbp-16]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L11
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
    jz .L12
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    jmp .L13
.L12:
.L13:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L10
.L11:
    movsd xmm0, [rbp-8]
    jmp .__ret_9
.__ret_9:
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
.L15:
    mov rax, [rbp-16]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L16
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
    jz .L17
    mov rax, [rbp-16]
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-8], xmm0
    jmp .L18
.L17:
.L18:
    mov rax, [rbp-16]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-16], rax
    jmp .L15
.L16:
    movsd xmm0, [rbp-8]
    jmp .__ret_14
.__ret_14:
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
    jmp .__ret_19
.__ret_19:
    mov rsp, rbp
    pop rbp
    ret
st_sum:
    push rbp
    mov rbp, rsp
    sub rsp, 48
section .data
.flt21: dq 0.0
section .text
    movsd xmm0, [rel .flt21]
    movsd [rbp-8], xmm0
    mov rax, 0
    mov [rbp-16], rax
.L22:
    mov rax, [rbp-16]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L23
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
    jmp .L22
.L23:
    movsd xmm0, [rbp-8]
    jmp .__ret_20
.__ret_20:
    mov rsp, rbp
    pop rbp
    ret
st_mean:
    push rbp
    mov rbp, rsp
    sub rsp, 48
section .data
.flt25: dq 0.0
section .text
    movsd xmm0, [rel .flt25]
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
    jmp .__ret_24
.__ret_24:
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
.flt27: dq 0.0
section .text
    movsd xmm0, [rel .flt27]
    movsd [rbp-16], xmm0
section .data
.flt28: dq 0.0
section .text
    movsd xmm0, [rel .flt28]
    movsd [rbp-24], xmm0
    mov rax, 0
    mov [rbp-32], rax
.L29:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L30
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
    jmp .L29
.L30:
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
    jmp .__ret_26
.__ret_26:
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
.flt32: dq 0.0
section .text
    movsd xmm0, [rel .flt32]
    movsd [rbp-16], xmm0
section .data
.flt33: dq 0.0
section .text
    movsd xmm0, [rel .flt33]
    movsd [rbp-24], xmm0
    mov rax, 0
    mov [rbp-32], rax
.L34:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L35
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
    jmp .L34
.L35:
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
    jmp .__ret_31
.__ret_31:
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
    cvtsi2sd xmm0, rax
    jmp .__ret_36
.__ret_36:
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
    cvtsi2sd xmm0, rax
    jmp .__ret_37
.__ret_37:
    mov rsp, rbp
    pop rbp
    ret
st_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 64
section .data
.flt39: dq 0.0
section .text
    movsd xmm0, [rel .flt39]
    movsd [rbp-8], xmm0
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
.L40:
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L41
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
    jmp .L40
.L41:
    mov rax, 1
    mov [rbp-24], rax
.L42:
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L43
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
.L44:
    mov rax, [rbp-16]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L46
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
    jz .L46
    mov rax, 1
    jmp .L47
.L46:
    mov rax, 0
.L47:
    test rax, rax
    jz .L45
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
    jmp .L44
.L45:
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
    jmp .L42
.L43:
    mov rax, 0
    jmp .__ret_38
.__ret_38:
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
    jmp .__ret_48
.__ret_48:
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
.flt50: dq 0.0
section .text
    movsd xmm0, [rel .flt50]
    movsd [rbp-16], xmm0
section .data
.flt51: dq 0.0
section .text
    movsd xmm0, [rel .flt51]
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
    jz .L52
    mov rax, [rbp-8]
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_49
    jmp .L53
.L52:
.L53:
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
.flt54: dq 2.0
section .text
    movsd xmm0, [rel .flt54]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_49
.__ret_49:
    mov rsp, rbp
    pop rbp
    ret
st_percentile:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movsd [rbp-8], xmm0
section .data
.flt56: dq 0.0
section .text
    movsd xmm0, [rel .flt56]
    movsd [rbp-16], xmm0
    mov rax, 0
    mov [rbp-24], rax
section .data
.flt57: dq 0.0
section .text
    movsd xmm0, [rel .flt57]
    movsd [rbp-32], xmm0
section .data
.flt58: dq 0.0
section .text
    movsd xmm0, [rel .flt58]
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
.flt59: dq 100.0
section .text
    movsd xmm0, [rel .flt59]
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
    jz .L60
    mov rax, [rel __g_st_n]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_55
    jmp .L61
.L60:
.L61:
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
    jmp .__ret_55
.__ret_55:
    mov rsp, rbp
    pop rbp
    ret
st_q1:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt63: dq 25.0
section .text
    movsd xmm0, [rel .flt63]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    jmp .__ret_62
.__ret_62:
    mov rsp, rbp
    pop rbp
    ret
st_q3:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt65: dq 75.0
section .text
    movsd xmm0, [rel .flt65]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call st_percentile
    add rsp, 32
    jmp .__ret_64
.__ret_64:
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
    jmp .__ret_66
.__ret_66:
    mov rsp, rbp
    pop rbp
    ret
st_mode:
    push rbp
    mov rbp, rsp
    sub rsp, 64
section .data
.flt68: dq 0.0
section .text
    movsd xmm0, [rel .flt68]
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
.L69:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L70
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
    jz .L71
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-24], rax
    jmp .L72
.L71:
    mov rax, 1
    mov [rbp-24], rax
.L72:
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L73
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
    jmp .L74
.L73:
.L74:
    mov rax, [rbp-32]
    push rax
    mov rax, 1
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-32], rax
    jmp .L69
.L70:
    movsd xmm0, [rbp-8]
    jmp .__ret_67
.__ret_67:
    mov rsp, rbp
    pop rbp
    ret
st_mean_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
section .data
.flt76: dq 0.0
section .text
    movsd xmm0, [rel .flt76]
    movsd [rbp-8], xmm0
section .data
.flt77: dq 0.0
section .text
    movsd xmm0, [rel .flt77]
    movsd [rbp-16], xmm0
    mov rax, 0
    mov [rbp-24], rax
.L78:
    mov rax, [rbp-24]
    push rax
    mov rax, [rel __g_st_ny]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L79
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
    jmp .L78
.L79:
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
    jmp .__ret_75
.__ret_75:
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
.flt81: dq 0.0
section .text
    movsd xmm0, [rel .flt81]
    movsd [rbp-24], xmm0
section .data
.flt82: dq 0.0
section .text
    movsd xmm0, [rel .flt82]
    movsd [rbp-32], xmm0
    mov rax, 0
    mov [rbp-40], rax
.L83:
    mov rax, [rbp-40]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L84
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
    jmp .L83
.L84:
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
    jmp .__ret_80
.__ret_80:
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
.flt86: dq 0.0
section .text
    movsd xmm0, [rel .flt86]
    movsd [rbp-24], xmm0
section .data
.flt87: dq 0.0
section .text
    movsd xmm0, [rel .flt87]
    movsd [rbp-32], xmm0
section .data
.flt88: dq 0.0
section .text
    movsd xmm0, [rel .flt88]
    movsd [rbp-40], xmm0
section .data
.flt89: dq 0.0
section .text
    movsd xmm0, [rel .flt89]
    movsd [rbp-48], xmm0
section .data
.flt90: dq 0.0
section .text
    movsd xmm0, [rel .flt90]
    movsd [rbp-56], xmm0
    mov rax, 0
    mov [rbp-64], rax
.L91:
    mov rax, [rbp-64]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L92
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
    jmp .L91
.L92:
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
    cvtsi2sd xmm0, rax
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_85
.__ret_85:
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
.flt94: dq 0.0
section .text
    movsd xmm0, [rel .flt94]
    movsd [rbp-24], xmm0
section .data
.flt95: dq 0.0
section .text
    movsd xmm0, [rel .flt95]
    movsd [rbp-32], xmm0
section .data
.flt96: dq 0.0
section .text
    movsd xmm0, [rel .flt96]
    movsd [rbp-40], xmm0
    mov rax, 0
    mov [rbp-48], rax
.L97:
    mov rax, [rbp-48]
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L98
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
    jmp .L97
.L98:
    movsd xmm0, [rbp-24]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-32]
    movsd xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_93
.__ret_93:
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
    jmp .__ret_99
.__ret_99:
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
    jmp .__ret_100
.__ret_100:
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
    jmp .__ret_101
.__ret_101:
    mov rsp, rbp
    pop rbp
    ret
