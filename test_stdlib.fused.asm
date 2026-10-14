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
mem_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, 0
    mov rbx, rax
.L1:
    cmp rbx, r12
    jge .L2
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
    jmp .L1
.L2:
    mov rax, r14
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mem_set:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, 0
    mov rbx, rax
.L4:
    cmp rbx, r12
    jge .L5
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
    jmp .L4
.L5:
    mov rax, r14
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mem_zero:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, 0
    mov r8, rbx
    sub rsp, 32
    call mem_set
    add rsp, 32
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mem_compare:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov r13, r8
    mov rax, 0
    mov r12, rax
.L8:
    cmp r12, r13
    jge .L9
    mov rax, r15
    add rax, r12
    movzx rax, byte [rax]
    push rax
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rbx, rax
    cmp rbx, 0
    je .L10
    mov rax, rbx
    jmp .__ret_7
    jmp .L11
.L10:
.L11:
    add r12, 1
    jmp .L8
.L9:
    mov rax, 0
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
mem_move:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    cmp r13, r12
    jge .L13
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call mem_copy
    add rsp, 32
    jmp .__ret_12
    jmp .L14
.L13:
.L14:
    mov rax, rbx
    mov rbx, rax
.L15:
    cmp rbx, 0
    jle .L16
    sub rbx, 1
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L15
.L16:
    mov rax, r13
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mem_find_byte:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, 0
    mov rbx, rax
.L18:
    cmp rbx, r12
    jge .L19
    mov rax, r14
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, r13
    jne .L20
    mov rax, r14
    add rax, rbx
    jmp .__ret_17
    jmp .L21
.L20:
.L21:
    add rbx, 1
    jmp .L18
.L19:
    mov rax, 0
    jmp .__ret_17
.__ret_17:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mem_swap:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov r13, r8
    mov rax, 0
    mov r12, rax
.L23:
    cmp r12, r13
    jge .L24
    mov rax, r15
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, r15
    add rax, r12
    push rax
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    add rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
    jmp .L23
.L24:
    mov rax, r15
    jmp .__ret_22
.__ret_22:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
str_length:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L26:
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, 0
    je .L27
    add rbx, 1
    jmp .L26
.L27:
    mov rax, rbx
    jmp .__ret_25
.__ret_25:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
str_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
.L29:
    cmp rbx, 0
    je .L30
    mov rax, r14
    add rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L29
.L30:
    mov rax, r14
    add rax, r12
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
str_concat:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call str_copy
    add rsp, 32
    mov rax, r13
    jmp .__ret_31
.__ret_31:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
str_compare:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov rax, 0
    mov r13, rax
.L33:
    mov rax, 1
    cmp rax, 1
    jne .L34
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r14
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
    cmp r12, rbx
    je .L35
    mov rax, r12
    sub rax, rbx
    jmp .__ret_32
    jmp .L36
.L35:
.L36:
    cmp r12, 0
    jne .L37
    mov rax, 0
    jmp .__ret_32
    jmp .L38
.L37:
.L38:
    add r13, 1
    jmp .L33
.L34:
    mov rax, 0
    jmp .__ret_32
.__ret_32:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
str_equals:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call str_compare
    add rsp, 32
    cmp rax, 0
    jne .L40
    mov rax, 1
    jmp .__ret_39
    jmp .L41
.L40:
.L41:
    mov rax, 0
    jmp .__ret_39
.__ret_39:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
str_find_byte:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, r14
    movzx rax, byte [rax]
    mov rbx, rax
.L43:
    cmp rbx, 0
    je .L44
    cmp rbx, r13
    jne .L45
    mov rax, r14
    add rax, r12
    jmp .__ret_42
    jmp .L46
.L45:
.L46:
    add r12, 1
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L43
.L44:
    mov rax, 0
    jmp .__ret_42
.__ret_42:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
str_starts_with:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
.L48:
    cmp rbx, 0
    je .L49
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    cmp rax, rbx
    je .L50
    mov rax, 0
    jmp .__ret_47
    jmp .L51
.L50:
.L51:
    add r12, 1
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L48
.L49:
    mov rax, 1
    jmp .__ret_47
.__ret_47:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
str_reverse:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rbx, rdx
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L53:
    cmp r13, r12
    jge .L54
    mov rax, r14
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, r14
    add rax, r13
    push rax
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    add rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    sub r12, 1
    jmp .L53
.L54:
    mov rax, r14
    jmp .__ret_52
.__ret_52:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
str_from_int:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rbx, rdx
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jge .L56
    mov rax, 1
    mov rbx, rax
    mov rax, 0
    sub rax, r12
    mov r12, rax
    jmp .L57
.L56:
.L57:
    cmp r12, 0
    jne .L58
    mov rax, r14
    push rax
    mov rax, 48
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    add rax, 1
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    jmp .__ret_55
    jmp .L59
.L58:
.L59:
.L60:
    cmp r12, 0
    jle .L61
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 48
    push rax
    mov rax, r12
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r12
    mov rcx, 10
    cqo
    idiv rcx
    mov r12, rax
    add r13, 1
    jmp .L60
.L61:
    cmp rbx, 1
    jne .L62
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 45
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    jmp .L63
.L62:
.L63:
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
    call str_reverse
    add rsp, 32
    mov rax, r13
    jmp .__ret_55
.__ret_55:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
str_to_int:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov rax, 0
    mov r14, rax
    mov rax, 1
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, r15
    movzx rax, byte [rax]
    cmp rax, 45
    jne .L65
    mov rax, 0
    sub rax, 1
    mov r13, rax
    mov rax, 1
    mov r14, rax
    jmp .L66
.L65:
.L66:
    mov rax, r15
    add rax, r14
    movzx rax, byte [rax]
    mov rbx, rax
.L67:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L69
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L69
    mov rax, 1
    jmp .L70
.L69:
    mov rax, 0
.L70:
    test rax, rax
    jz .L68
    mov rax, r12
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, rbx
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    add r14, 1
    mov rax, r15
    add rax, r14
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L67
.L68:
    mov rax, r12
    imul rax, r13
    jmp .__ret_64
.__ret_64:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
str_print_line:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
.L72:
    cmp rbx, 0
    je .L73
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
    add r12, 1
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L72
.L73:
    mov rax, 10
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
    mov rax, r12
    jmp .__ret_71
.__ret_71:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
section .bss
__g_buf: resq 32
section .text
section .bss
__g_buf2: resq 32
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    lea rax, [rel __g_buf]
    mov r13, rax
    lea rax, [rel __g_buf2]
    mov r12, rax
    mov rcx, r13
    mov rdx, 65
    mov r8, 5
    sub rsp, 32
    call mem_set
    add rsp, 32
    mov rax, r13
    add rax, 5
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rcx, r13
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, r13
    movzx rax, byte [rax]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
    call mem_zero
    add rsp, 32
    mov rax, r13
    movzx rax, byte [rax]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str75: db 104,101,108,108,111,0
section .text
    lea rax, [rel .str75]
    push rax
    pop rdx
    pop rcx
    mov r8, 6
    sub rsp, 32
    call mem_copy
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call str_print_line
    add rsp, 32
section .data
.str76: db 97,98,99,0
section .text
    lea rax, [rel .str76]
    push rax
section .data
.str77: db 97,98,99,0
section .text
    lea rax, [rel .str77]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
    call mem_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str78: db 97,98,100,0
section .text
    lea rax, [rel .str78]
    push rax
section .data
.str79: db 97,98,99,0
section .text
    lea rax, [rel .str79]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
    call mem_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str80: db 104,101,108,108,111,0
section .text
    lea rax, [rel .str80]
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 108
    mov r8, 5
    sub rsp, 32
    call mem_find_byte
    add rsp, 32
    sub rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str81: db 74,117,112,105,116,101,114,0
section .text
    lea rax, [rel .str81]
    push rax
    pop rcx
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str82: db 97,98,99,0
section .text
    lea rax, [rel .str82]
    push rax
section .data
.str83: db 97,98,99,0
section .text
    lea rax, [rel .str83]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str84: db 97,98,99,0
section .text
    lea rax, [rel .str84]
    push rax
section .data
.str85: db 97,98,100,0
section .text
    lea rax, [rel .str85]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_equals
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str86: db 74,117,112,105,116,101,114,0
section .text
    lea rax, [rel .str86]
    push rax
section .data
.str87: db 74,117,112,0
section .text
    lea rax, [rel .str87]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_starts_with
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str88: db 74,117,112,105,116,101,114,0
section .text
    lea rax, [rel .str88]
    push rax
section .data
.str89: db 120,121,122,0
section .text
    lea rax, [rel .str89]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_starts_with
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str90: db 72,101,108,108,111,44,32,0
section .text
    lea rax, [rel .str90]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_copy
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str91: db 119,111,114,108,100,0
section .text
    lea rax, [rel .str91]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_concat
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call str_print_line
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str92: db 97,98,99,100,101,102,0
section .text
    lea rax, [rel .str92]
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 100
    sub rsp, 32
    call str_find_byte
    add rsp, 32
    sub rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r12
    mov rdx, 12345
    sub rsp, 32
    call str_from_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call str_print_line
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, 0
    sub rax, 987
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_from_int
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call str_print_line
    add rsp, 32
section .data
.str93: db 52,51,50,49,0
section .text
    lea rax, [rel .str93]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str94: db 45,55,55,0
section .text
    lea rax, [rel .str94]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str95: db 49,50,97,98,0
section .text
    lea rax, [rel .str95]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r12
    mov rdx, 60000
    sub rsp, 32
    call str_from_int
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_74
.__ret_74:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
