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
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt9: dq 0.0
section .text
    movsd xmm0, [rel .flt9]
    movaps xmm1, xmm0
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
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    jmp .__ret_6
    jmp .L8
.L7:
.L8:
    movaps xmm0, xmm6
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
    movaps xmm7, xmm0
    movaps xmm6, xmm1
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L12
    movaps xmm0, xmm7
    jmp .__ret_11
    jmp .L13
.L12:
.L13:
    movaps xmm0, xmm6
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
    movaps xmm7, xmm0
    movaps xmm6, xmm1
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L15
    movaps xmm0, xmm7
    jmp .__ret_14
    jmp .L16
.L15:
.L16:
    movaps xmm0, xmm6
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
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L18
    movaps xmm0, xmm7
    jmp .__ret_17
    jmp .L19
.L18:
.L19:
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L20
    movaps xmm0, xmm6
    jmp .__ret_17
    jmp .L21
.L20:
.L21:
    movaps xmm0, xmm8
    jmp .__ret_17
.__ret_17:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fsign:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt25: dq 0.0
section .text
    movsd xmm0, [rel .flt25]
    movaps xmm1, xmm0
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
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt29: dq 0.0
section .text
    movsd xmm0, [rel .flt29]
    movaps xmm1, xmm0
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
    movaps xmm1, xmm0
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
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    cvttsd2si rax, xmm0
    mov rbx, rax
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L34
section .data
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L35
.L34:
.L35:
    movaps xmm0, xmm6
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
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    cvttsd2si rax, xmm0
    mov rbx, rax
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L38
section .data
.flt40: dq 1.0
section .text
    movsd xmm0, [rel .flt40]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L39
.L38:
.L39:
    movaps xmm0, xmm6
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
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt44: dq 0.0
section .text
    movsd xmm0, [rel .flt44]
    movaps xmm1, xmm0
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
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl0:
    call ffloor
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_41
    jmp .L43
.L42:
.L43:
section .data
.flt47: dq 0.5
section .text
    movsd xmm0, [rel .flt47]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl1:
    call ffloor
    add rsp, 32
    jmp .__ret_41
.__ret_41:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,2
    dq .kl0,102
    dq .kl1,104
.kfn: db "fround", 0
section .text
fmod:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    movups [rbp-48], xmm9
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt51: dq 0.0
section .text
    movsd xmm0, [rel .flt51]
    movaps xmm1, xmm0
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
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    divsd xmm0, xmm1
    movaps xmm7, xmm0
section .data
.flt53: dq 0.0
section .text
    movsd xmm0, [rel .flt53]
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt56: dq 0.0
section .text
    movsd xmm0, [rel .flt56]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L54
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl2:
    call fceil
    add rsp, 32
    movaps xmm6, xmm0
    jmp .L55
.L54:
.L55:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt59: dq 0.0
section .text
    movsd xmm0, [rel .flt59]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L57
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl3:
    call ffloor
    add rsp, 32
    movaps xmm6, xmm0
    jmp .L58
.L57:
.L58:
    movaps xmm0, xmm6
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm9
    subsd xmm0, xmm1
    jmp .__ret_48
.__ret_48:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fround.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl2,115
    dq .kl3,118
.kfn: db "fmod", 0
section .text
fsqrt:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    movups [rbp-88], xmm6
    movups [rbp-72], xmm7
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt63: dq 0.0
section .text
    movsd xmm0, [rel .flt63]
    movaps xmm1, xmm0
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
    mov rax, 0
    cmp rax, 1
    jb .L65
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl4:
    lea r8, [rel .kx0]
    call __fail_raise
.kx0:
    add rsp, 32
    xor rax, rax
    jmp .__ret_60
.L65:
    push rax
    movaps xmm0, xmm7
    pop rcx
    lea rdx, [rbp-16]
    movsd [rdx+rcx*8], xmm0
    lea rax, [rbp-16]
    mov rax, [rax]
    mov rbx, rax
    lea rax, [rbp-16]
    push rax
    mov rax, rbx
    mov rcx, 1
    sar rax, cl
    mov rcx, 2305843009213693952
    add rax, rcx
    mov rcx, 2251799813685248
    sub rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    cmp rax, 1
    jb .L66
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl5:
    lea r8, [rel .kx1]
    call __fail_raise
.kx1:
    add rsp, 32
    xor rax, rax
    jmp .__ret_60
.L66:
    mov rcx, rax
    lea rdx, [rbp-16]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L67:
    cmp rbx, 6
    jge .L68
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt70: dq 0.5
section .text
    movsd xmm0, [rel .flt70]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
.L69:
    add rbx, 1
    jmp .L67
.L68:
    movaps xmm0, xmm6
    jmp .__ret_60
.__ret_60:
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fmod.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl4,136
    dq .kl5,141
.kfn: db "fsqrt", 0
section .text
flen2:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movaps xmm7, xmm0
    movaps xmm6, xmm1
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl6:
    call fsqrt
    add rsp, 32
    jmp .__ret_71
.__ret_71:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fsqrt.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl6,150
.kfn: db "flen2", 0
section .text
flen3:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm8
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl7:
    call fsqrt
    add rsp, 32
    jmp .__ret_72
.__ret_72:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq flen2.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl7,155
.kfn: db "flen3", 0
section .text
fwrap_angle:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt74: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt74]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl8:
    call fmod
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt77: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt77]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L75
section .data
.flt78: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt78]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L76
.L75:
.L76:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt81: dq 0.0
section .text
    movsd xmm0, [rel .flt81]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt82: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt82]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L79
section .data
.flt83: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt83]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L80
.L79:
.L80:
    movaps xmm0, xmm6
    jmp .__ret_73
.__ret_73:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq flen3.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl8,162
.kfn: db "fwrap_angle", 0
section .text
fsin:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl9:
    call fwrap_angle
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm8, xmm0
    movaps xmm0, xmm6
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm6, xmm0
section .data
.flt85: dq 0.0
section .text
    movsd xmm0, [rel .flt85]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt86: dq 6.0
section .text
    movsd xmm0, [rel .flt86]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt87: dq 0.0
section .text
    movsd xmm0, [rel .flt87]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt88: dq 20.0
section .text
    movsd xmm0, [rel .flt88]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt89: dq 0.0
section .text
    movsd xmm0, [rel .flt89]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt90: dq 42.0
section .text
    movsd xmm0, [rel .flt90]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt91: dq 0.0
section .text
    movsd xmm0, [rel .flt91]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt92: dq 72.0
section .text
    movsd xmm0, [rel .flt92]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt93: dq 0.0
section .text
    movsd xmm0, [rel .flt93]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt94: dq 110.0
section .text
    movsd xmm0, [rel .flt94]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt95: dq 0.0
section .text
    movsd xmm0, [rel .flt95]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt96: dq 156.0
section .text
    movsd xmm0, [rel .flt96]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt97: dq 0.0
section .text
    movsd xmm0, [rel .flt97]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt98: dq 210.0
section .text
    movsd xmm0, [rel .flt98]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt99: dq 0.0
section .text
    movsd xmm0, [rel .flt99]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt100: dq 272.0
section .text
    movsd xmm0, [rel .flt100]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt101: dq 0.0
section .text
    movsd xmm0, [rel .flt101]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt102: dq 342.0
section .text
    movsd xmm0, [rel .flt102]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    jmp .__ret_84
.__ret_84:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fwrap_angle.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl9,175
.kfn: db "fsin", 0
section .text
fcos:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
section .data
.flt104: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt104]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl10:
    call fsin
    add rsp, 32
    jmp .__ret_103
.__ret_103:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fsin.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl10,202
.kfn: db "fcos", 0
section .text
ftan:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl11:
    call fcos
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt108: dq 0.0
section .text
    movsd xmm0, [rel .flt108]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L106
section .data
.flt109: dq 0.0
section .text
    movsd xmm0, [rel .flt109]
    jmp .__ret_105
    jmp .L107
.L106:
.L107:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl12:
    call fsin
    add rsp, 32
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_105
.__ret_105:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fcos.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl11,206
    dq .kl12,210
.kfn: db "ftan", 0
section .text
fpowi:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    movaps xmm7, xmm0
    mov r12, rdx
section .data
.flt111: dq 1.0
section .text
    movsd xmm0, [rel .flt111]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L112:
    cmp rbx, r12
    jge .L113
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
.L114:
    add rbx, 1
    jmp .L112
.L113:
    movaps xmm0, xmm6
    jmp .__ret_110
.__ret_110:
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
    movaps xmm6, xmm0
section .data
.flt116: dq 0.01745329251994329577
section .text
    movsd xmm0, [rel .flt116]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
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
    movaps xmm6, xmm0
section .data
.flt118: dq 57.29577951308232087680
section .text
    movsd xmm0, [rel .flt118]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
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
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    addsd xmm0, xmm1
    jmp .__ret_119
.__ret_119:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fdot3:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    movups [rbp-144], xmm6
    movups [rbp-128], xmm7
    movups [rbp-112], xmm8
    movups [rbp-96], xmm9
    movups [rbp-80], xmm10
    movups [rbp-64], xmm11
    movaps xmm11, xmm0
    movaps xmm10, xmm1
    movaps xmm9, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm6, xmm5
    movaps xmm0, xmm11
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm10
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_120
.__ret_120:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    movups xmm9, [rbp-96]
    movups xmm10, [rbp-80]
    movups xmm11, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
vec3_length:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm8
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl13:
    call fsqrt
    add rsp, 32
    jmp .__ret_121
.__ret_121:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ftan.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl13,20
.kfn: db "vec3_length", 0
section .text
vec3_length2:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm8
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_122
.__ret_122:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
vec3_distance:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    movups [rbp-176], xmm6
    movups [rbp-160], xmm7
    movups [rbp-144], xmm8
    movups [rbp-128], xmm9
    movups [rbp-112], xmm10
    movups [rbp-96], xmm11
    movaps xmm11, xmm0
    movaps xmm10, xmm1
    movaps xmm9, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm6, xmm5
    movaps xmm0, xmm8
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    movaps xmm8, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm10
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl14:
    call fsqrt
    add rsp, 32
    jmp .__ret_123
.__ret_123:
    movups xmm6, [rbp-176]
    movups xmm7, [rbp-160]
    movups xmm8, [rbp-144]
    movups xmm9, [rbp-128]
    movups xmm10, [rbp-112]
    movups xmm11, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq vec3_length.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl14,32
.kfn: db "vec3_distance", 0
section .text
vec3_dot:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    movups [rbp-144], xmm6
    movups [rbp-128], xmm7
    movups [rbp-112], xmm8
    movups [rbp-96], xmm9
    movups [rbp-80], xmm10
    movups [rbp-64], xmm11
    movaps xmm11, xmm0
    movaps xmm10, xmm1
    movaps xmm9, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm6, xmm5
    movaps xmm0, xmm11
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm10
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_124
.__ret_124:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    movups xmm9, [rbp-96]
    movups xmm10, [rbp-80]
    movups xmm11, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
vec3_cross_x:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    movups [rbp-48], xmm9
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_125
.__ret_125:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
vec3_cross_y:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    movups [rbp-48], xmm9
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_126
.__ret_126:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
vec3_cross_z:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    movups [rbp-48], xmm9
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_127
.__ret_127:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
vec3_norm_x:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl15:
    call vec3_length
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt131: dq 0.0
section .text
    movsd xmm0, [rel .flt131]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L129
section .data
.flt132: dq 0.0
section .text
    movsd xmm0, [rel .flt132]
    jmp .__ret_128
    jmp .L130
.L129:
.L130:
    movaps xmm0, xmm8
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_128
.__ret_128:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq vec3_distance.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl15,61
.kfn: db "vec3_norm_x", 0
section .text
vec3_norm_y:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl16:
    call vec3_length
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt136: dq 0.0
section .text
    movsd xmm0, [rel .flt136]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L134
section .data
.flt137: dq 0.0
section .text
    movsd xmm0, [rel .flt137]
    jmp .__ret_133
    jmp .L135
.L134:
.L135:
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_133
.__ret_133:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq vec3_norm_x.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl16,69
.kfn: db "vec3_norm_y", 0
section .text
vec3_norm_z:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm6, xmm1
    movaps xmm7, xmm2
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl17:
    call vec3_length
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt141: dq 0.0
section .text
    movsd xmm0, [rel .flt141]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L139
section .data
.flt142: dq 0.0
section .text
    movsd xmm0, [rel .flt142]
    jmp .__ret_138
    jmp .L140
.L139:
.L140:
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_138
.__ret_138:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq vec3_norm_y.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl17,77
.kfn: db "vec3_norm_z", 0
section .text
rot_y_x:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl18:
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_143
.__ret_143:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq vec3_norm_z.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl18,94
.kfn: db "rot_y_x", 0
section .text
rot_y_z:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl19:
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_144
.__ret_144:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rot_y_x.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl19,98
.kfn: db "rot_y_z", 0
section .text
rot_x_y:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl20:
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_145
.__ret_145:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rot_y_z.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl20,103
.kfn: db "rot_x_y", 0
section .text
rot_x_z:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl21:
    call fsin
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_146
.__ret_146:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rot_x_y.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl21,107
.kfn: db "rot_x_z", 0
section .text
rot_z_x:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl22:
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsin
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_147
.__ret_147:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rot_x_z.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl22,112
.kfn: db "rot_z_x", 0
section .text
rot_z_y:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    movups [rbp-64], xmm7
    movups [rbp-48], xmm8
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl23:
    call fsin
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_148
.__ret_148:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rot_z_x.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl23,116
.kfn: db "rot_z_y", 0
section .text
proj_x:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    movups [rbp-96], xmm8
    movups [rbp-80], xmm9
    movups [rbp-64], xmm10
    movaps xmm10, xmm0
    movaps xmm9, xmm1
    movaps xmm6, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt152: dq 0.0
section .text
    movsd xmm0, [rel .flt152]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L150
    movaps xmm0, xmm7
    jmp .__ret_149
    jmp .L151
.L150:
.L151:
    movaps xmm0, xmm10
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    jmp .__ret_149
.__ret_149:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    movups xmm8, [rbp-96]
    movups xmm9, [rbp-80]
    movups xmm10, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
proj_y:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    movups [rbp-96], xmm8
    movups [rbp-80], xmm9
    movups [rbp-64], xmm10
    movaps xmm10, xmm0
    movaps xmm9, xmm1
    movaps xmm6, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt156: dq 0.0
section .text
    movsd xmm0, [rel .flt156]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L154
    movaps xmm0, xmm7
    jmp .__ret_153
    jmp .L155
.L154:
.L155:
    movaps xmm0, xmm10
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    subsd xmm0, xmm1
    jmp .__ret_153
.__ret_153:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    movups xmm8, [rbp-96]
    movups xmm9, [rbp-80]
    movups xmm10, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
proj_depth:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movaps xmm7, xmm0
    movaps xmm6, xmm1
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    addsd xmm0, xmm1
    jmp .__ret_157
.__ret_157:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
edge_cross:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    movups [rbp-48], xmm9
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_158
.__ret_158:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
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
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 0
    push rax
    mov rax, 66
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, 77
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, 30054
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 6
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 10
    push rax
    mov rax, 54
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 14
    push rax
    mov rax, 40
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 18
    push rax
    mov rax, 100
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 22
    push rax
    mov rax, 100
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 26
    push rax
    mov rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, rbx
    add rax, 28
    push rax
    mov rax, 24
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, rbx
    add rax, 30
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 34
    push rax
    mov rax, 30000
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 38
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 42
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 46
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 50
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 54
    jmp .__ret_159
.__ret_159:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
put_pixel:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov r14, r8
    mov r13, r9
    mov r12, r10
    mov rbx, rax
    mov rax, [rbp-8]
    push rax
    mov rax, 99
    sub rax, r14
    mov rcx, 300
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r15
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rax, r14
    add rax, 0
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    add rax, 1
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    add rax, 2
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    jmp .__ret_160
.__ret_160:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
clear_scene:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
.L162:
    cmp r12, 100
    jge .L163
    mov rax, 0
    mov rbx, rax
.L165:
    cmp rbx, 100
    jge .L166
    mov rcx, r13
    mov rdx, rbx
    mov r8, r12
    mov r9, 12
    mov r10, 15
    mov rax, 40
    sub rsp, 32
.kl24:
    call put_pixel
    add rsp, 32
    mov rax, r12
    mov rcx, 100
    imul rax, rcx
    add rax, rbx
    cmp rax, 10000
    jb .L168
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl25:
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_161
.L168:
    push rax
section .data
.flt169: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt169]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
.L167:
    add rbx, 1
    jmp .L165
.L166:
.L164:
    add r12, 1
    jmp .L162
.L163:
    mov rax, r13
    jmp .__ret_161
.__ret_161:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rot_z_y.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl24,77
    dq .kl25,78
.kfn: db "clear_scene", 0
section .text
build_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 0
    cmp rax, 8
    jb .L171
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl26:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L171:
    push rax
section .data
.flt172: dq 0.0
section .text
    movsd xmm0, [rel .flt172]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt173: dq 1.0
section .text
    movsd xmm0, [rel .flt173]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 8
    jb .L174
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L174:
    push rax
section .data
.flt175: dq 0.0
section .text
    movsd xmm0, [rel .flt175]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt176: dq 1.0
section .text
    movsd xmm0, [rel .flt176]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 8
    jb .L177
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L177:
    push rax
section .data
.flt178: dq 0.0
section .text
    movsd xmm0, [rel .flt178]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt179: dq 1.0
section .text
    movsd xmm0, [rel .flt179]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L180
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl27:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L180:
    push rax
section .data
.flt181: dq 1.0
section .text
    movsd xmm0, [rel .flt181]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L182
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L182:
    push rax
section .data
.flt183: dq 0.0
section .text
    movsd xmm0, [rel .flt183]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt184: dq 1.0
section .text
    movsd xmm0, [rel .flt184]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L185
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L185:
    push rax
section .data
.flt186: dq 0.0
section .text
    movsd xmm0, [rel .flt186]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt187: dq 1.0
section .text
    movsd xmm0, [rel .flt187]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L188
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl28:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L188:
    push rax
section .data
.flt189: dq 1.0
section .text
    movsd xmm0, [rel .flt189]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L190
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L190:
    push rax
section .data
.flt191: dq 1.0
section .text
    movsd xmm0, [rel .flt191]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L192
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L192:
    push rax
section .data
.flt193: dq 0.0
section .text
    movsd xmm0, [rel .flt193]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt194: dq 1.0
section .text
    movsd xmm0, [rel .flt194]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L195
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl29:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L195:
    push rax
section .data
.flt196: dq 0.0
section .text
    movsd xmm0, [rel .flt196]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt197: dq 1.0
section .text
    movsd xmm0, [rel .flt197]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L198
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L198:
    push rax
section .data
.flt199: dq 1.0
section .text
    movsd xmm0, [rel .flt199]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L200
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L200:
    push rax
section .data
.flt201: dq 0.0
section .text
    movsd xmm0, [rel .flt201]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt202: dq 1.0
section .text
    movsd xmm0, [rel .flt202]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L203
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl30:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L203:
    push rax
section .data
.flt204: dq 0.0
section .text
    movsd xmm0, [rel .flt204]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt205: dq 1.0
section .text
    movsd xmm0, [rel .flt205]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L206
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L206:
    push rax
section .data
.flt207: dq 0.0
section .text
    movsd xmm0, [rel .flt207]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt208: dq 1.0
section .text
    movsd xmm0, [rel .flt208]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L209
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L209:
    push rax
section .data
.flt210: dq 1.0
section .text
    movsd xmm0, [rel .flt210]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L211
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl31:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L211:
    push rax
section .data
.flt212: dq 1.0
section .text
    movsd xmm0, [rel .flt212]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L213
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L213:
    push rax
section .data
.flt214: dq 0.0
section .text
    movsd xmm0, [rel .flt214]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt215: dq 1.0
section .text
    movsd xmm0, [rel .flt215]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L216
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L216:
    push rax
section .data
.flt217: dq 1.0
section .text
    movsd xmm0, [rel .flt217]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L218
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl32:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L218:
    push rax
section .data
.flt219: dq 1.0
section .text
    movsd xmm0, [rel .flt219]
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L220
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L220:
    push rax
section .data
.flt221: dq 1.0
section .text
    movsd xmm0, [rel .flt221]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L222
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L222:
    push rax
section .data
.flt223: dq 1.0
section .text
    movsd xmm0, [rel .flt223]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L224
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl33:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L224:
    push rax
section .data
.flt225: dq 0.0
section .text
    movsd xmm0, [rel .flt225]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt226: dq 1.0
section .text
    movsd xmm0, [rel .flt226]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L227
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L227:
    push rax
section .data
.flt228: dq 1.0
section .text
    movsd xmm0, [rel .flt228]
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L229
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L229:
    push rax
section .data
.flt230: dq 1.0
section .text
    movsd xmm0, [rel .flt230]
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 12
    jb .L231
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl34:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L231:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L232
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L232:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L233
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L233:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L234
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L234:
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L235
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L235:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L236
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L236:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L237
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl35:
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L237:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L238
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L238:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L239
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L239:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L240
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L240:
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L241
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L241:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L242
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L242:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L243
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl36:
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L243:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L244
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L244:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L245
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L245:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L246
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L246:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L247
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L247:
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L248
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L248:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L249
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl37:
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L249:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L250
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L250:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L251
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L251:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L252
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L252:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L253
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx49]
    call __fail_raise
.kx49:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L253:
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L254
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx50]
    call __fail_raise
.kx50:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L254:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L255
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl38:
    lea r8, [rel .kx51]
    call __fail_raise
.kx51:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L255:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L256
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx52]
    call __fail_raise
.kx52:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L256:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L257
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx53]
    call __fail_raise
.kx53:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L257:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L258
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx54]
    call __fail_raise
.kx54:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L258:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L259
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx55]
    call __fail_raise
.kx55:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L259:
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L260
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx56]
    call __fail_raise
.kx56:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L260:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L261
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl39:
    lea r8, [rel .kx57]
    call __fail_raise
.kx57:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L261:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L262
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx58]
    call __fail_raise
.kx58:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L262:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L263
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx59]
    call __fail_raise
.kx59:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L263:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L264
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx60]
    call __fail_raise
.kx60:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L264:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L265
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx61]
    call __fail_raise
.kx61:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L265:
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L266
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx62]
    call __fail_raise
.kx62:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L266:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L267
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl40:
    lea r8, [rel .kx63]
    call __fail_raise
.kx63:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L267:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L268
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx64]
    call __fail_raise
.kx64:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L268:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L269
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx65]
    call __fail_raise
.kx65:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L269:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L270
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx66]
    call __fail_raise
.kx66:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L270:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L271
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx67]
    call __fail_raise
.kx67:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L271:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L272
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx68]
    call __fail_raise
.kx68:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L272:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L273
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl41:
    lea r8, [rel .kx69]
    call __fail_raise
.kx69:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L273:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L274
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx70]
    call __fail_raise
.kx70:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L274:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L275
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx71]
    call __fail_raise
.kx71:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L275:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L276
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx72]
    call __fail_raise
.kx72:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L276:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L277
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx73]
    call __fail_raise
.kx73:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L277:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L278
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx74]
    call __fail_raise
.kx74:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L278:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L279
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl42:
    lea r8, [rel .kx75]
    call __fail_raise
.kx75:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L279:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L280
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx76]
    call __fail_raise
.kx76:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L280:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L281
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx77]
    call __fail_raise
.kx77:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L281:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L282
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx78]
    call __fail_raise
.kx78:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L282:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L283
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx79]
    call __fail_raise
.kx79:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L283:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L284
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx80]
    call __fail_raise
.kx80:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L284:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L285
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl43:
    lea r8, [rel .kx81]
    call __fail_raise
.kx81:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L285:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L286
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx82]
    call __fail_raise
.kx82:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L286:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L287
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx83]
    call __fail_raise
.kx83:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L287:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L288
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx84]
    call __fail_raise
.kx84:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L288:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L289
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx85]
    call __fail_raise
.kx85:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L289:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L290
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx86]
    call __fail_raise
.kx86:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L290:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L291
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl44:
    lea r8, [rel .kx87]
    call __fail_raise
.kx87:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L291:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L292
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx88]
    call __fail_raise
.kx88:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L292:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L293
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx89]
    call __fail_raise
.kx89:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L293:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L294
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx90]
    call __fail_raise
.kx90:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L294:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L295
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx91]
    call __fail_raise
.kx91:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L295:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L296
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx92]
    call __fail_raise
.kx92:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L296:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L297
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl45:
    lea r8, [rel .kx93]
    call __fail_raise
.kx93:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L297:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rel __g_t0]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L298
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx94]
    call __fail_raise
.kx94:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L298:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_t1]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L299
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx95]
    call __fail_raise
.kx95:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L299:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_t2]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L300
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx96]
    call __fail_raise
.kx96:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L300:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rel __g_tr]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L301
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx97]
    call __fail_raise
.kx97:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L301:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tg]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L302
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx98]
    call __fail_raise
.kx98:
    add rsp, 32
    xor rax, rax
    jmp .__ret_170
.L302:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rel __g_tb]
    mov [rdx+rcx*8], rax
    mov rax, 0
    jmp .__ret_170
.__ret_170:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq clear_scene.kft, .kfe, .kfn, __kron_file_2,20
    dq .kl26,85
    dq .kl27,86
    dq .kl28,87
    dq .kl29,88
    dq .kl30,89
    dq .kl31,90
    dq .kl32,91
    dq .kl33,92
    dq .kl34,94
    dq .kl35,95
    dq .kl36,96
    dq .kl37,97
    dq .kl38,98
    dq .kl39,99
    dq .kl40,100
    dq .kl41,101
    dq .kl42,102
    dq .kl43,103
    dq .kl44,104
    dq .kl45,105
.kfn: db "build_cube", 0
section .text
pose_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    movups [rbp-136], xmm6
    movups [rbp-120], xmm7
    movups [rbp-104], xmm8
    movups [rbp-88], xmm9
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    mov rax, 0
    mov rbx, rax
.L304:
    cmp rbx, 8
    jge .L305
    mov rax, rbx
    cmp rax, 8
    jb .L307
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl46:
    lea r8, [rel .kx99]
    call __fail_raise
.kx99:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L307:
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L308
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx100]
    call __fail_raise
.kx100:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L308:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
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
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L309
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl47:
    lea r8, [rel .kx101]
    call __fail_raise
.kx101:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L309:
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L310
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx102]
    call __fail_raise
.kx102:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L310:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
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
    movaps xmm7, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L311
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl48:
    lea r8, [rel .kx103]
    call __fail_raise
.kx103:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L311:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_vy]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L312
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl49:
    lea r8, [rel .kx104]
    call __fail_raise
.kx104:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L312:
    push rax
    movaps xmm0, xmm7
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
.L306:
    add rbx, 1
    jmp .L304
.L305:
    mov rax, 0
    mov rbx, rax
.L313:
    cmp rbx, 8
    jge .L314
    mov rax, rbx
    cmp rax, 8
    jb .L316
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl50:
    lea r8, [rel .kx105]
    call __fail_raise
.kx105:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L316:
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L317
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx106]
    call __fail_raise
.kx106:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L317:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
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
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L318
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl51:
    lea r8, [rel .kx107]
    call __fail_raise
.kx107:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L318:
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L319
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx108]
    call __fail_raise
.kx108:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L319:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
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
    movaps xmm7, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L320
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl52:
    lea r8, [rel .kx109]
    call __fail_raise
.kx109:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L320:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_vx]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L321
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl53:
    lea r8, [rel .kx110]
    call __fail_raise
.kx110:
    add rsp, 32
    xor rax, rax
    jmp .__ret_303
.L321:
    push rax
    movaps xmm0, xmm7
    pop rcx
    lea rdx, [rel __g_vz]
    movsd [rdx+rcx*8], xmm0
.L315:
    add rbx, 1
    jmp .L313
.L314:
    mov rax, 0
    jmp .__ret_303
.__ret_303:
    mov rbx, [rbp-144]
    movups xmm6, [rbp-136]
    movups xmm7, [rbp-120]
    movups xmm8, [rbp-104]
    movups xmm9, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq build_cube.kft, .kfe, .kfn, __kron_file_2,8
    dq .kl46,112
    dq .kl47,113
    dq .kl48,114
    dq .kl49,115
    dq .kl50,118
    dq .kl51,119
    dq .kl52,120
    dq .kl53,121
.kfn: db "pose_cube", 0
section .text
project_cube:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
.L323:
    cmp rbx, 8
    jge .L324
    mov rax, rbx
    cmp rax, 8
    jb .L326
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl54:
    lea r8, [rel .kx111]
    call __fail_raise
.kx111:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L326:
    push rax
    mov rax, rbx
    cmp rax, 8
    jb .L327
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx112]
    call __fail_raise
.kx112:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L327:
    mov rcx, rax
    lea rdx, [rel __g_vx]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L328
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx113]
    call __fail_raise
.kx113:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L328:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt329: dq 4.0
section .text
    movsd xmm0, [rel .flt329]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt330: dq 90.0
section .text
    movsd xmm0, [rel .flt330]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt331: dq 50.0
section .text
    movsd xmm0, [rel .flt331]
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
    pop rcx
    lea rdx, [rel __g_sx]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L332
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl55:
    lea r8, [rel .kx114]
    call __fail_raise
.kx114:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L332:
    push rax
    mov rax, rbx
    cmp rax, 8
    jb .L333
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx115]
    call __fail_raise
.kx115:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L333:
    mov rcx, rax
    lea rdx, [rel __g_vy]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L334
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx116]
    call __fail_raise
.kx116:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L334:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt335: dq 4.0
section .text
    movsd xmm0, [rel .flt335]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt336: dq 90.0
section .text
    movsd xmm0, [rel .flt336]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt337: dq 50.0
section .text
    movsd xmm0, [rel .flt337]
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
    pop rcx
    lea rdx, [rel __g_sy]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L338
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl56:
    lea r8, [rel .kx117]
    call __fail_raise
.kx117:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L338:
    push rax
    mov rax, rbx
    cmp rax, 8
    jb .L339
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx118]
    call __fail_raise
.kx118:
    add rsp, 32
    xor rax, rax
    jmp .__ret_322
.L339:
    mov rcx, rax
    lea rdx, [rel __g_vz]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt340: dq 4.0
section .text
    movsd xmm0, [rel .flt340]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call proj_depth
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_sz]
    movsd [rdx+rcx*8], xmm0
.L325:
    add rbx, 1
    jmp .L323
.L324:
    mov rax, 0
    jmp .__ret_322
.__ret_322:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq pose_cube.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl54,129
    dq .kl55,130
    dq .kl56,131
.kfn: db "project_cube", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 496
    mov [rbp-464], rbx
    mov [rbp-456], r12
    mov [rbp-448], r13
    mov [rbp-440], r14
    mov [rbp-432], r15
    movups [rbp-424], xmm6
    movups [rbp-408], xmm7
    movups [rbp-392], xmm8
    movups [rbp-376], xmm9
    movups [rbp-360], xmm10
    movups [rbp-344], xmm11
    movups [rbp-328], xmm12
    movups [rbp-312], xmm13
    movups [rbp-296], xmm14
    movups [rbp-280], xmm15
    sub rsp, 32
    call __rt_init
    add rsp, 32
    lea rax, [rel __g_buf]
    mov [rbp-8], rax
    mov rcx, [rbp-8]
    sub rsp, 32
.kl57:
    call write_bmp_header
    add rsp, 32
    mov r15, rax
    sub rsp, 32
.kl58:
    call build_cube
    add rsp, 32
section .data
.flt342: dq 0.55
section .text
    movsd xmm0, [rel .flt342]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt343: dq 0.8
section .text
    movsd xmm0, [rel .flt343]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl59:
    call pose_cube
    add rsp, 32
    sub rsp, 32
.kl60:
    call project_cube
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
.kl61:
    call clear_scene
    add rsp, 32
    mov rax, 0
    mov r14, rax
.L344:
    cmp r14, 12
    jge .L345
    mov rax, r14
    cmp rax, 12
    jb .L347
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl62:
    lea r8, [rel .kx119]
    call __fail_raise
.kx119:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L347:
    mov rcx, rax
    lea rdx, [rel __g_t0]
    mov rax, [rdx+rcx*8]
    mov r13, rax
    mov rax, r14
    cmp rax, 12
    jb .L348
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl63:
    lea r8, [rel .kx120]
    call __fail_raise
.kx120:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L348:
    mov rcx, rax
    lea rdx, [rel __g_t1]
    mov rax, [rdx+rcx*8]
    mov r12, rax
    mov rax, r14
    cmp rax, 12
    jb .L349
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl64:
    lea r8, [rel .kx121]
    call __fail_raise
.kx121:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L349:
    mov rcx, rax
    lea rdx, [rel __g_t2]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    mov rax, r13
    cmp rax, 8
    jb .L350
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl65:
    lea r8, [rel .kx122]
    call __fail_raise
.kx122:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L350:
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm15, xmm0
    mov rax, r13
    cmp rax, 8
    jb .L351
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl66:
    lea r8, [rel .kx123]
    call __fail_raise
.kx123:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L351:
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm14, xmm0
    mov rax, r13
    cmp rax, 8
    jb .L352
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl67:
    lea r8, [rel .kx124]
    call __fail_raise
.kx124:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L352:
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-72], xmm0
    mov rax, r12
    cmp rax, 8
    jb .L353
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl68:
    lea r8, [rel .kx125]
    call __fail_raise
.kx125:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L353:
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-80], xmm0
    mov rax, r12
    cmp rax, 8
    jb .L354
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl69:
    lea r8, [rel .kx126]
    call __fail_raise
.kx126:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L354:
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm13, xmm0
    mov rax, r12
    cmp rax, 8
    jb .L355
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl70:
    lea r8, [rel .kx127]
    call __fail_raise
.kx127:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L355:
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-96], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L356
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl71:
    lea r8, [rel .kx128]
    call __fail_raise
.kx128:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L356:
    mov rcx, rax
    lea rdx, [rel __g_sx]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm12, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L357
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl72:
    lea r8, [rel .kx129]
    call __fail_raise
.kx129:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L357:
    mov rcx, rax
    lea rdx, [rel __g_sy]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm11, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L358
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl73:
    lea r8, [rel .kx130]
    call __fail_raise
.kx130:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L358:
    mov rcx, rax
    lea rdx, [rel __g_sz]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-120], xmm0
    movsd xmm0, [rbp-80]
    movaps xmm1, xmm15
    subsd xmm0, xmm1
    movsd [rbp-128], xmm0
    movaps xmm0, xmm13
    movaps xmm1, xmm14
    subsd xmm0, xmm1
    movsd [rbp-136], xmm0
    movaps xmm0, xmm12
    movsd xmm1, [rbp-80]
    subsd xmm0, xmm1
    movsd [rbp-144], xmm0
    movaps xmm0, xmm11
    movaps xmm1, xmm13
    subsd xmm0, xmm1
    movsd [rbp-152], xmm0
    movaps xmm0, xmm15
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    movsd [rbp-160], xmm0
    movaps xmm0, xmm14
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    movsd [rbp-168], xmm0
    movsd xmm0, [rbp-128]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-136]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm12
    movaps xmm1, xmm15
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm11
    movaps xmm1, xmm14
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
.kl74:
    call edge_cross
    add rsp, 32
    movaps xmm10, xmm0
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl75:
    call fabs
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt361: dq 0.5
section .text
    movsd xmm0, [rel .flt361]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L359
    mov rax, 0
    mov r13, rax
.L362:
    cmp r13, 100
    jge .L363
    mov rax, 0
    mov r12, rax
.L365:
    cmp r12, 100
    jge .L366
    mov rax, r12
    cvtsi2sd xmm0, rax
    movaps xmm9, xmm0
    mov rax, r13
    cvtsi2sd xmm0, rax
    movaps xmm8, xmm0
    movsd xmm0, [rbp-128]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-136]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm15
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm14
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
.kl76:
    call edge_cross
    add rsp, 32
    movaps xmm7, xmm0
    movsd xmm0, [rbp-144]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-80]
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm13
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
.kl77:
    call edge_cross
    add rsp, 32
    movaps xmm6, xmm0
    movsd xmm0, [rbp-160]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-168]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm11
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
.kl78:
    call edge_cross
    add rsp, 32
    movaps xmm8, xmm0
    mov rax, 0
    mov rbx, rax
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt370: dq 0.0
section .text
    movsd xmm0, [rel .flt370]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L368
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt377: dq 0.0
section .text
    movsd xmm0, [rel .flt377]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L375
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt378: dq 0.0
section .text
    movsd xmm0, [rel .flt378]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L375
    mov rax, 1
    jmp .L376
.L375:
    mov rax, 0
.L376:
    test rax, rax
    jz .L373
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt379: dq 0.0
section .text
    movsd xmm0, [rel .flt379]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L373
    mov rax, 1
    jmp .L374
.L373:
    mov rax, 0
.L374:
    test rax, rax
    jz .L371
    mov rax, 1
    mov rbx, rax
    jmp .L372
.L371:
.L372:
    jmp .L369
.L368:
.L369:
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt382: dq 0.0
section .text
    movsd xmm0, [rel .flt382]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L380
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt389: dq 0.0
section .text
    movsd xmm0, [rel .flt389]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L387
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt390: dq 0.0
section .text
    movsd xmm0, [rel .flt390]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L387
    mov rax, 1
    jmp .L388
.L387:
    mov rax, 0
.L388:
    test rax, rax
    jz .L385
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt391: dq 0.0
section .text
    movsd xmm0, [rel .flt391]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L385
    mov rax, 1
    jmp .L386
.L385:
    mov rax, 0
.L386:
    test rax, rax
    jz .L383
    mov rax, 1
    mov rbx, rax
    jmp .L384
.L383:
.L384:
    jmp .L381
.L380:
.L381:
    cmp rbx, 1
    jne .L392
    movaps xmm0, xmm7
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movsd xmm1, [rbp-72]
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movsd xmm1, [rbp-96]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, r13
    mov rcx, 100
    imul rax, rcx
    add rax, r12
    mov rbx, rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 10000
    jb .L396
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl79:
    lea r8, [rel .kx131]
    call __fail_raise
.kx131:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L396:
    mov rcx, rax
    lea rdx, [rel __g_zb]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L394
    mov rax, rbx
    cmp rax, 10000
    jb .L397
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl80:
    lea r8, [rel .kx132]
    call __fail_raise
.kx132:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L397:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, r15
    push rax
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, r14
    cmp rax, 12
    jb .L398
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl81:
    lea r8, [rel .kx133]
    call __fail_raise
.kx133:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L398:
    mov rcx, rax
    lea rdx, [rel __g_tr]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 12
    jb .L399
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx134]
    call __fail_raise
.kx134:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L399:
    mov rcx, rax
    lea rdx, [rel __g_tg]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 12
    jb .L400
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx135]
    call __fail_raise
.kx135:
    add rsp, 32
    xor rax, rax
    jmp .__ret_341
.L400:
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
    jmp .L395
.L394:
.L395:
    jmp .L393
.L392:
.L393:
.L367:
    add r12, 1
    jmp .L365
.L366:
.L364:
    add r13, 1
    jmp .L362
.L363:
    jmp .L360
.L359:
.L360:
.L346:
    add r14, 1
    jmp .L344
.L345:
section .data
.str401: db 99,117,98,101,46,98,109,112,0
section .text
    lea rax, [rel .str401]
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
    jmp .__ret_341
.__ret_341:
    mov rbx, [rbp-464]
    mov r12, [rbp-456]
    mov r13, [rbp-448]
    mov r14, [rbp-440]
    mov r15, [rbp-432]
    movups xmm6, [rbp-424]
    movups xmm7, [rbp-408]
    movups xmm8, [rbp-392]
    movups xmm9, [rbp-376]
    movups xmm10, [rbp-360]
    movups xmm11, [rbp-344]
    movups xmm12, [rbp-328]
    movups xmm13, [rbp-312]
    movups xmm14, [rbp-296]
    movups xmm15, [rbp-280]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq project_cube.kft, .kfe, .kfn, __kron_file_2,25
    dq .kl57,140
    dq .kl58,142
    dq .kl59,143
    dq .kl60,144
    dq .kl61,145
    dq .kl62,148
    dq .kl63,149
    dq .kl64,150
    dq .kl65,152
    dq .kl66,153
    dq .kl67,154
    dq .kl68,155
    dq .kl69,156
    dq .kl70,157
    dq .kl71,158
    dq .kl72,159
    dq .kl73,160
    dq .kl74,168
    dq .kl75,170
    dq .kl76,175
    dq .kl77,176
    dq .kl78,177
    dq .kl79,192
    dq .kl80,193
    dq .kl81,194
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,109,97,116,104,46,107,114,0
__kron_file_1: db 115,116,100,95,118,101,99,51,46,107,114,0
__kron_file_2: db 99,117,98,101,51,100,46,107,114,0
section .text
