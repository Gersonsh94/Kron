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
extern TlsAlloc
extern TlsGetValue
extern TlsSetValue
extern SwitchToThread
extern LoadLibraryA
extern GetProcAddress
extern QueryPerformanceCounter
extern QueryPerformanceFrequency
extern GetCommandLineA
extern VirtualAlloc
section .bss
__clo_lock: resq 1
__clo_cur: resq 1
__clo_end: resq 1
__numbuf: resb 32
__nwritten: resq 1
__chbuf: resb 2
__keybuf: resb 2
__nread: resq 1
__mousebuf: resb 32
__mousex_v: resq 1
__mousey_v: resq 1
__fail_tls: resq 1
__fail_next: resq 1
__fail_cs: resb 64
__fail_pool: resq 3072
__locks: resb 2048
__sysinfo: resb 64
__tickbuf: resq 1
__argdone: resq 1
__argn: resq 1
__argtab: resq 64
__argbuf: resb 32800
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
    cmp rcx, 32
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
__bounds_msg: db 'index out of range', 0
__bounds_hint: db 'the index has to go from 0 to the array size minus one', 0
__emptystr: db 0
__nosys_msg: db 'syscall exists only on Linux', 0
__nosys_hint: db 'on Windows the system is reached through dll_load and dll_proc', 0
section .text
__main_exit:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 40
    mov rbx, rcx
    mov rcx, [rel __fail_tls]
    call TlsGetValue
    test rax, rax
    jz .me_go
    mov rax, [rax]
    test rax, rax
    jz .me_go
    call __print_fail
.me_go:
    mov rcx, rbx
    call ExitProcess
__print_fail:
    push rbp
    mov rbp, rsp
    push rbx
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    mov rcx, [rel __fail_tls]
    call TlsGetValue
    test rax, rax
    jz .pf_done
    mov rbx, rax
    mov rcx, [rbx+8]
    test rcx, rcx
    jz .pf_done
    lea rcx, [rel __pf_fail]
    call __print_str
    mov rcx, [rbx+8]
    call __print_str
    lea rcx, [rel __pf_nl]
    call __print_str
    mov rcx, [rbx+16]
    test rcx, rcx
    jz .pf_trace
    lea rcx, [rel __pf_hint]
    call __print_str
    mov rcx, [rbx+16]
    call __print_str
    lea rcx, [rel __pf_nl]
    call __print_str
.pf_trace:
    mov rcx, rbx
    call __trace_print
.pf_done:
    mov rbx, [rbp-8]
    mov rsp, rbp
    pop rbp
    ret
__rt_init:
    push rbp
    mov rbp, rsp
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    call TlsAlloc
    mov [rel __fail_tls], rax
    lea rcx, [rel __fail_cs]
    call InitializeCriticalSection
    push rbx
    sub rsp, 40
    mov rbx, 16
.ri_lk:
    mov rcx, rbx
    call __lock_addr
    mov rcx, rax
    call InitializeCriticalSection
    add rbx, 1
    cmp rbx, 32
    jb .ri_lk
    add rsp, 40
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
__fail_block:
    push rbp
    mov rbp, rsp
    push rbx
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    mov rcx, [rel __fail_tls]
    call TlsGetValue
    test rax, rax
    jnz .fb_out
    lea rcx, [rel __fail_cs]
    call EnterCriticalSection
    mov rbx, [rel __fail_next]
    cmp rbx, 255
    jae .fb_have
    mov rax, rbx
    add rax, 1
    mov [rel __fail_next], rax
.fb_have:
    imul rbx, rbx, 96
    lea rax, [rel __fail_pool]
    add rbx, rax
    lea rcx, [rel __fail_cs]
    call LeaveCriticalSection
    mov rcx, [rel __fail_tls]
    mov rdx, rbx
    call TlsSetValue
    mov rax, rbx
.fb_out:
    mov rbx, [rbp-8]
    mov rsp, rbp
    pop rbp
    ret
__fail_raise:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    mov rbx, rcx
    mov rsi, rdx
    mov rdi, r8
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    call __fail_block
    mov qword [rax + 0], 1
    mov [rax+8], rbx
    mov [rax+16], rsi
    mov rbx, rax
    mov r8, rdi
    mov r9, rbp
    call __fail_walk
    mov rbx, [rbp-8]
    mov rsi, [rbp-16]
    mov rdi, [rbp-24]
    mov r12, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
__clo_alloc:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    mov rbx, rcx
    add rbx, 15
    shr rbx, 4
    shl rbx, 4
    lea rdi, [rel __clo_lock]
.cla_spin:
    mov eax, 1
    xchg [rdi], eax
    test rax, rax
    jz .cla_have_lock
    jmp .cla_spin
.cla_have_lock:
    mov rax, [rel __clo_cur]
    mov rcx, rax
    add rcx, rbx
    mov rdx, [rel __clo_end]
    test rax, rax
    jz .cla_more
    cmp rcx, rdx
    jbe .cla_take
.cla_more:
    mov r12, 0x100000
    cmp rbx, r12
    jbe .cla_size
    mov r12, rbx
.cla_size:
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    xor ecx, ecx
    mov rdx, r12
    mov r8, 0x3000
    mov r9, 4
    call VirtualAlloc
    mov rsp, rbp
    sub rsp, 32
    test rax, rax
    jz .cla_out
    mov [rel __clo_cur], rax
    mov rcx, rax
    add rcx, r12
    mov [rel __clo_end], rcx
.cla_take:
    mov rcx, rax
    add rcx, rbx
    mov [rel __clo_cur], rcx
.cla_out:
    mov rbx, rax
    xor eax, eax
    xchg [rdi], eax
    mov rax, rbx
    mov rbx, [rbp-8]
    mov rsi, [rbp-16]
    mov rdi, [rbp-24]
    mov r12, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
__fail_take:
    push rbp
    mov rbp, rsp
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    mov rcx, [rel __fail_tls]
    call TlsGetValue
    test rax, rax
    jz .ft_out
    mov rcx, rax
    mov rax, [rcx]
    mov qword [rcx + 0], 0
.ft_out:
    mov rsp, rbp
    pop rbp
    ret
__dll_load:
    push rbp
    mov rbp, rsp
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    call LoadLibraryA
    mov rsp, rbp
    pop rbp
    ret
__dll_proc:
    push rbp
    mov rbp, rsp
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    call GetProcAddress
    mov rsp, rbp
    pop rbp
    ret
__beep:
    push rbp
    mov rbp, rsp
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    call Beep
    mov rsp, rbp
    pop rbp
    ret
__arg_parse:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    mov rax, [rel __argdone]
    test rax, rax
    jnz .ap_out
    mov qword [rel __argdone], 1
    call GetCommandLineA
    mov rsi, rax
    lea rdi, [rel __argbuf]
    xor rbx, rbx
    jmp .ap_skip
.ap_skip:
    mov al, [rsi]
    cmp al, 32
    je .ap_adv
    cmp al, 9
    je .ap_adv
    test al, al
    jz .ap_out
    jmp .ap_word
.ap_adv:
    inc rsi
    jmp .ap_skip
.ap_word:
    cmp rbx, 64
    jae .ap_noslot
    lea rax, [rel __argtab]
    mov [rax+rbx*8], rdi
    inc rbx
    mov [rel __argn], rbx
    jmp .ap_noslot
.ap_noslot:
    xor rdx, rdx
    jmp .ap_ch
.ap_ch:
    mov al, [rsi]
    test al, al
    jz .ap_end
    cmp al, 34
    je .ap_quote
    test rdx, rdx
    jnz .ap_copy
    cmp al, 32
    je .ap_end
    cmp al, 9
    je .ap_end
    jmp .ap_copy
.ap_quote:
    xor rdx, 1
    inc rsi
    jmp .ap_ch
.ap_copy:
    mov [rdi], al
    inc rdi
    inc rsi
    jmp .ap_ch
.ap_end:
    mov byte [rdi], 0
    inc rdi
    jmp .ap_skip
.ap_out:
    mov rbx, [rbp-8]
    mov rsi, [rbp-16]
    mov rdi, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
__arg_count:
    push rbp
    mov rbp, rsp
    call __arg_parse
    mov rax, [rel __argn]
    mov rsp, rbp
    pop rbp
    ret
__arg_get:
    push rbp
    mov rbp, rsp
    push rbx
    mov rbx, rcx
    call __arg_parse
    mov rax, [rel __argn]
    cmp rbx, rax
    jae .wag_none
    lea rax, [rel __argtab]
    mov rax, [rax+rbx*8]
    jmp .wag_out
.wag_none:
    lea rax, [rel __emptystr]
    jmp .wag_out
.wag_out:
    mov rbx, [rbp-8]
    mov rsp, rbp
    pop rbp
    ret
__no_syscall:
    lea rcx, [rel __nosys_msg]
    lea rdx, [rel __nosys_hint]
    mov r8, [rsp]
    call __fail_raise
    mov rax, -1
    ret
__thread_yield:
    push rbp
    mov rbp, rsp
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    call SwitchToThread
    mov rsp, rbp
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
    sub rsp, 56
    ucomisd xmm0, xmm0
    jb .pf_nan
    xorps xmm1, xmm1
    comisd xmm1, xmm0
    jbe .pf_pos
    movsd [rbp-16], xmm0
    mov rcx, 45
    call __print_char
    movsd xmm0, [rbp-16]
    mov rax, 0x8000000000000000
    movq xmm2, rax
    xorps xmm0, xmm2
.pf_pos:
    mov rax, 0x42A05EF39B200000
    movq xmm1, rax
    comisd xmm0, xmm1
    jae .pf_big
    mov rax, 1000000
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvtsd2si rax, xmm0
    xor rdx, rdx
    mov rbx, 1000000
    div rbx
    mov [rbp-24], rdx
    jmp .pf_out
.pf_big:
    mov rax, 0x43E0000000000000
    movq xmm1, rax
    comisd xmm0, xmm1
    jae .pf_sci
    cvttsd2si rax, xmm0
    cvtsi2sd xmm1, rax
    subsd xmm0, xmm1
    mov rbx, rax
    mov rax, 1000000
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvtsd2si rax, xmm0
    cmp rax, 1000000
    jb .pf_bf
    sub rax, 1000000
    add rbx, 1
.pf_bf:
    mov [rbp-24], rax
    mov rax, rbx
.pf_out:
    mov rcx, rax
    call __print_uint
    mov rcx, 46
    call __print_char
    mov rcx, [rbp-24]
    mov r10, 6
    call __print_pad
    jmp .pf_nl
.pf_sci:
    mov rax, 0x7FF0000000000000
    movq xmm1, rax
    comisd xmm0, xmm1
    jae .pf_inf
    xor rbx, rbx
    mov rax, 10
    cvtsi2sd xmm1, rax
.pf_sl:
    comisd xmm0, xmm1
    jb .pf_sd
    divsd xmm0, xmm1
    add rbx, 1
    jmp .pf_sl
.pf_sd:
    mov [rbp-32], rbx
    mov rax, 1000000
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvtsd2si rax, xmm0
    cmp rax, 10000000
    jb .pf_sm
    mov rax, 1000000
    mov rbx, [rbp-32]
    add rbx, 1
    mov [rbp-32], rbx
.pf_sm:
    xor rdx, rdx
    mov rbx, 1000000
    div rbx
    mov [rbp-24], rdx
    mov rcx, rax
    call __print_uint
    mov rcx, 46
    call __print_char
    mov rcx, [rbp-24]
    mov r10, 6
    call __print_pad
    mov rcx, 101
    call __print_char
    mov rcx, 43
    call __print_char
    mov rcx, [rbp-32]
    call __print_uint
    jmp .pf_nl
.pf_inf:
    mov rcx, 105
    call __print_char
    mov rcx, 110
    call __print_char
    mov rcx, 102
    call __print_char
    jmp .pf_nl
.pf_nan:
    mov rcx, 110
    call __print_char
    mov rcx, 97
    call __print_char
    mov rcx, 110
    call __print_char
.pf_nl:
    mov rcx, 10
    call __print_char
    add rsp, 56
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
__tp_at: db '  at ', 0
__tp_from: db '  called from ', 0
__tp_open: db ' (', 0
__tp_colon: db ':', 0
__tp_close: db ')', 0
section .text
__fail_walk:
    push rcx
    push rdx
    push rsi
    push rdi
    push r9
    push r10
    push r11
    push r12
    xor r10, r10
    xor r11, r11
    mov r12, 16
    lea rsi, [rel __kron_lo]
    lea rdi, [rel __kron_hi]
    test r8, r8
    jz .fw_step
    mov [rbx+32], r8
    mov r10, 1
.fw_step:
    cmp r10, 8
    jae .fw_done
    sub r12, 1
    jz .fw_done
    mov rax, [r9+8]
    cmp rax, r8
    je .fw_next
    cmp rax, rsi
    jb .fw_out
    cmp rax, rdi
    jae .fw_out
    mov rdx, r10
    shl rdx, 3
    add rdx, rbx
    mov [rdx+32], rax
    add r10, 1
    mov r11, 1
    jmp .fw_next
.fw_out:
    test r11, r11
    jnz .fw_done
    cmp r12, 13
    jb .fw_done
.fw_next:
    mov rax, [r9]
    cmp rax, r9
    jbe .fw_done
    mov rdx, rax
    sub rdx, r9
    cmp rdx, 0x100000
    jae .fw_done
    mov r9, rax
    jmp .fw_step
.fw_done:
    mov [rbx+24], r10
    pop r12
    pop r11
    pop r10
    pop r9
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    ret
__trace_print:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    mov rbx, rcx
    xor r12, r12
.tp_frame:
    mov rax, [rbx+24]
    cmp r12, rax
    jae .tp_done
    cmp r12, 8
    jae .tp_done
    mov rax, r12
    shl rax, 3
    add rax, rbx
    mov r13, [rax+32]
    sub r13, 1
    lea rax, [rel __kron_trace]
    mov rsi, [rax]
.tp_rec:
    test rsi, rsi
    jz .tp_next
    mov rax, [rsi+40]
    cmp r13, rax
    jb .tp_other
    mov rax, [rsi+8]
    cmp r13, rax
    jb .tp_found
.tp_other:
    mov rsi, [rsi]
    jmp .tp_rec
.tp_found:
    mov rcx, [rsi+32]
    mov rdi, rsi
    add rdi, 40
    xor r14, r14
.tp_ent:
    test rcx, rcx
    jz .tp_line
    mov rax, [rdi]
    cmp rax, r13
    ja .tp_line
    mov r14, [rdi+8]
    add rdi, 16
    sub rcx, 1
    jmp .tp_ent
.tp_line:
    lea rcx, [rel __tp_from]
    test r12, r12
    jnz .tp_word
    lea rcx, [rel __tp_at]
.tp_word:
    call __print_str
    mov rcx, [rsi+16]
    call __print_str
    lea rcx, [rel __tp_open]
    call __print_str
    mov rcx, [rsi+24]
    call __print_str
    lea rcx, [rel __tp_colon]
    call __print_str
    mov rcx, r14
    call __print_uint
    lea rcx, [rel __tp_close]
    call __print_str
    lea rcx, [rel __pf_nl]
    call __print_str
.tp_next:
    add r12, 1
    jmp .tp_frame
.tp_done:
    mov rsp, rbp
    sub rsp, 48
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    pop rbp
    ret
section .text
__kron_lo:
main:
    push rbp
    mov rbp, rsp
    sub rsp, 10736
    mov [rbp-10704], rbx
    mov [rbp-10696], r12
    mov [rbp-10688], r13
    mov [rbp-10680], r14
    mov [rbp-10672], r15
    movups [rbp-10664], xmm6
    movups [rbp-10648], xmm7
    movups [rbp-10632], xmm8
    movups [rbp-10616], xmm9
    movups [rbp-10600], xmm10
    movups [rbp-10584], xmm11
    movups [rbp-10568], xmm12
    movups [rbp-10552], xmm13
    movups [rbp-10536], xmm14
    movups [rbp-10520], xmm15
    sub rsp, 32
    call __rt_init
    add rsp, 32
    mov rax, 0
    cmp rax, 8
    jb .L1
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl0:
    lea r8, [rel .kx0]
    call __fail_raise
.kx0:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L1:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 8
    jb .L4
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx1]
    call __fail_raise
.kx1:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L4:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 8
    jb .L7
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L7:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L10
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl1:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L10:
    push rax
section .data
.flt11: dq 1.0
section .text
    movsd xmm0, [rel .flt11]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L12
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L12:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L15
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L15:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L18
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl2:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L18:
    push rax
section .data
.flt19: dq 1.0
section .text
    movsd xmm0, [rel .flt19]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L20
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L20:
    push rax
section .data
.flt21: dq 1.0
section .text
    movsd xmm0, [rel .flt21]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L22
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L22:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L25
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl3:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L25:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L28
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L28:
    push rax
section .data
.flt29: dq 1.0
section .text
    movsd xmm0, [rel .flt29]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L30
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L30:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L33
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl4:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L33:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L36
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L36:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L39
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L39:
    push rax
section .data
.flt40: dq 1.0
section .text
    movsd xmm0, [rel .flt40]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L41
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl5:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L41:
    push rax
section .data
.flt42: dq 1.0
section .text
    movsd xmm0, [rel .flt42]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L43
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L43:
    push rax
section .data
.flt44: dq 0.0
section .text
    movsd xmm0, [rel .flt44]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt45: dq 1.0
section .text
    movsd xmm0, [rel .flt45]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L46
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L46:
    push rax
section .data
.flt47: dq 1.0
section .text
    movsd xmm0, [rel .flt47]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L48
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl6:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L48:
    push rax
section .data
.flt49: dq 1.0
section .text
    movsd xmm0, [rel .flt49]
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L50
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L50:
    push rax
section .data
.flt51: dq 1.0
section .text
    movsd xmm0, [rel .flt51]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L52
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L52:
    push rax
section .data
.flt53: dq 1.0
section .text
    movsd xmm0, [rel .flt53]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L54
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl7:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L54:
    push rax
section .data
.flt55: dq 0.0
section .text
    movsd xmm0, [rel .flt55]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt56: dq 1.0
section .text
    movsd xmm0, [rel .flt56]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L57
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L57:
    push rax
section .data
.flt58: dq 1.0
section .text
    movsd xmm0, [rel .flt58]
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L59
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L59:
    push rax
section .data
.flt60: dq 1.0
section .text
    movsd xmm0, [rel .flt60]
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 12
    jb .L61
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl8:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L61:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L62
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L62:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L63
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl9:
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L63:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L64
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L64:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L65
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl10:
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L65:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L66
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L66:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L67
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl11:
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L67:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L68
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L68:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L69
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl12:
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L69:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L70
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L70:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L71
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl13:
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L71:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L72
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L72:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L73
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl14:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L73:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L74
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L74:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L75
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl15:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L75:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L76
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L76:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L77
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl16:
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L77:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L78
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L78:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L79
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl17:
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L79:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L80
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L80:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L81
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl18:
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L81:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L82
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L82:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L83
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl19:
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L83:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-10144]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L84
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L84:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-10240]
    mov [rdx+rcx*8], rax
section .data
.flt85: dq 0.94
section .text
    movsd xmm0, [rel .flt85]
    movaps xmm9, xmm0
section .data
.flt86: dq 0.342
section .text
    movsd xmm0, [rel .flt86]
    movaps xmm8, xmm0
    mov rax, 0
    mov rbx, rax
.L87:
    cmp rbx, 8
    jge .L88
    mov rax, rbx
    cmp rax, 8
    jb .L90
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl20:
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L90:
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L91
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx49]
    call __fail_raise
.kx49:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L91:
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L92
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl21:
    lea r8, [rel .kx50]
    call __fail_raise
.kx50:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L92:
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L93
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx51]
    call __fail_raise
.kx51:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L93:
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L94
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl22:
    lea r8, [rel .kx52]
    call __fail_raise
.kx52:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L94:
    push rax
    movaps xmm0, xmm7
    pop rcx
    lea rdx, [rbp-9984]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L95
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl23:
    lea r8, [rel .kx53]
    call __fail_raise
.kx53:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L95:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
.L89:
    add rbx, 1
    jmp .L87
.L88:
section .data
.flt96: dq 0.981
section .text
    movsd xmm0, [rel .flt96]
    movaps xmm15, xmm0
section .data
.flt97: dq 0.195
section .text
    movsd xmm0, [rel .flt97]
    movaps xmm14, xmm0
    mov rax, 0
    mov r13, rax
.L98:
    cmp r13, 6
    jge .L99
    mov rax, 0
    mov rbx, rax
.L101:
    cmp rbx, 8
    jge .L102
    mov rax, rbx
    cmp rax, 8
    jb .L104
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl24:
    lea r8, [rel .kx54]
    call __fail_raise
.kx54:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L104:
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm15
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L105
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx55]
    call __fail_raise
.kx55:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L105:
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm7, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L106
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl25:
    lea r8, [rel .kx56]
    call __fail_raise
.kx56:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L106:
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm15
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L107
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx57]
    call __fail_raise
.kx57:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L107:
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L108
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl26:
    lea r8, [rel .kx58]
    call __fail_raise
.kx58:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L108:
    push rax
    movaps xmm0, xmm7
    pop rcx
    lea rdx, [rbp-9920]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L109
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl27:
    lea r8, [rel .kx59]
    call __fail_raise
.kx59:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L109:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rbp-10048]
    movsd [rdx+rcx*8], xmm0
.L103:
    add rbx, 1
    jmp .L101
.L102:
    mov rax, 0
    mov rbx, rax
.L110:
    cmp rbx, 1232
    jge .L111
    mov rax, rbx
    cmp rax, 1232
    jb .L113
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl28:
    lea r8, [rel .kx60]
    call __fail_raise
.kx60:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L113:
    push rax
    mov rax, 32
    pop rcx
    lea rdx, [rbp-9856]
    mov [rdx+rcx*8], rax
.L112:
    add rbx, 1
    jmp .L110
.L111:
    mov rax, 0
    mov r15, rax
.L114:
    cmp r15, 12
    jge .L115
    mov rax, r15
    cmp rax, 12
    jb .L117
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl29:
    lea r8, [rel .kx61]
    call __fail_raise
.kx61:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L117:
    mov rcx, rax
    lea rdx, [rbp-10144]
    mov rax, [rdx+rcx*8]
    mov r12, rax
    mov rax, r15
    cmp rax, 12
    jb .L118
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl30:
    lea r8, [rel .kx62]
    call __fail_raise
.kx62:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L118:
    mov rcx, rax
    lea rdx, [rbp-10240]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    mov rax, r12
    cmp rax, 8
    jb .L119
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl31:
    lea r8, [rel .kx63]
    call __fail_raise
.kx63:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L119:
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm13, xmm0
    mov rax, r12
    cmp rax, 8
    jb .L120
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl32:
    lea r8, [rel .kx64]
    call __fail_raise
.kx64:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L120:
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm12, xmm0
    mov rax, r12
    cmp rax, 8
    jb .L121
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl33:
    lea r8, [rel .kx65]
    call __fail_raise
.kx65:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L121:
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm11, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L122
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl34:
    lea r8, [rel .kx66]
    call __fail_raise
.kx66:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L122:
    mov rcx, rax
    lea rdx, [rbp-9920]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-10392], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L123
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl35:
    lea r8, [rel .kx67]
    call __fail_raise
.kx67:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L123:
    mov rcx, rax
    lea rdx, [rbp-9984]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm10, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L124
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl36:
    lea r8, [rel .kx68]
    call __fail_raise
.kx68:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L124:
    mov rcx, rax
    lea rdx, [rbp-10048]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm9, xmm0
    mov rax, 0
    mov r14, rax
.L125:
    cmp r14, 40
    jge .L126
    mov rax, r14
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt128: dq 39.0
section .text
    movsd xmm0, [rel .flt128]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    movsd xmm0, [rbp-10392]
    movaps xmm1, xmm13
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm13
    addsd xmm0, xmm1
    movaps xmm8, xmm0
    movaps xmm0, xmm10
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm12
    addsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm11
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt129: dq 4.0
section .text
    movsd xmm0, [rel .flt129]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt130: dq 28.0
section .text
    movsd xmm0, [rel .flt130]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt131: dq 30.0
section .text
    movsd xmm0, [rel .flt131]
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvttsd2si rax, xmm0
    mov r12, rax
section .data
.flt132: dq 11.0
section .text
    movsd xmm0, [rel .flt132]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt133: dq 15.0
section .text
    movsd xmm0, [rel .flt133]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvttsd2si rax, xmm0
    mov rbx, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L140
    mov rax, r12
    mov rcx, 56
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L140
    mov rax, 1
    jmp .L141
.L140:
    mov rax, 0
.L141:
    test rax, rax
    jz .L138
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L138
    mov rax, 1
    jmp .L139
.L138:
    mov rax, 0
.L139:
    test rax, rax
    jz .L136
    mov rax, rbx
    mov rcx, 22
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L136
    mov rax, 1
    jmp .L137
.L136:
    mov rax, 0
.L137:
    test rax, rax
    jz .L134
    mov rax, rbx
    mov rcx, 56
    imul rax, rcx
    add rax, r12
    cmp rax, 1232
    jb .L142
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl37:
    lea r8, [rel .kx69]
    call __fail_raise
.kx69:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L142:
    push rax
    mov rax, 35
    pop rcx
    lea rdx, [rbp-9856]
    mov [rdx+rcx*8], rax
    jmp .L135
.L134:
.L135:
.L127:
    add r14, 1
    jmp .L125
.L126:
.L116:
    add r15, 1
    jmp .L114
.L115:
    mov rax, 0
    mov r12, rax
.L143:
    cmp r12, 22
    jge .L144
    mov rax, 0
    mov rbx, rax
.L146:
    cmp rbx, 56
    jge .L147
    mov rax, r12
    mov rcx, 56
    imul rax, rcx
    add rax, rbx
    cmp rax, 1232
    jb .L149
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl38:
    lea r8, [rel .kx70]
    call __fail_raise
.kx70:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L149:
    mov rcx, rax
    lea rdx, [rbp-9856]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
.L148:
    add rbx, 1
    jmp .L146
.L147:
    mov rax, 10
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
.L145:
    add r12, 1
    jmp .L143
.L144:
    mov rax, 10
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
.L100:
    add r13, 1
    jmp .L98
.L99:
    mov rax, 0
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-10704]
    mov r12, [rbp-10696]
    mov r13, [rbp-10688]
    mov r14, [rbp-10680]
    mov r15, [rbp-10672]
    movups xmm6, [rbp-10664]
    movups xmm7, [rbp-10648]
    movups xmm8, [rbp-10632]
    movups xmm9, [rbp-10616]
    movups xmm10, [rbp-10600]
    movups xmm11, [rbp-10584]
    movups xmm12, [rbp-10568]
    movups xmm13, [rbp-10552]
    movups xmm14, [rbp-10536]
    movups xmm15, [rbp-10520]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,39
    dq .kl0,20
    dq .kl1,21
    dq .kl2,22
    dq .kl3,23
    dq .kl4,24
    dq .kl5,25
    dq .kl6,26
    dq .kl7,27
    dq .kl8,32
    dq .kl9,33
    dq .kl10,34
    dq .kl11,35
    dq .kl12,36
    dq .kl13,37
    dq .kl14,38
    dq .kl15,39
    dq .kl16,40
    dq .kl17,41
    dq .kl18,42
    dq .kl19,43
    dq .kl20,49
    dq .kl21,50
    dq .kl22,51
    dq .kl23,52
    dq .kl24,64
    dq .kl25,65
    dq .kl26,66
    dq .kl27,67
    dq .kl28,72
    dq .kl29,77
    dq .kl30,78
    dq .kl31,79
    dq .kl32,80
    dq .kl33,81
    dq .kl34,82
    dq .kl35,83
    dq .kl36,84
    dq .kl37,98
    dq .kl38,106
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 99,117,98,101,46,107,114,0
section .text
