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
section .data
__g_HP_LOCK: dq 16
section .text
section .data
__g_HP_TAG: dq 4611686018427387904
section .text
section .data
__g_HP_MAGIC: dq 5427057734453002571
section .text
section .data
__g_HP_LARGE: dq 5427057734453002572
section .text
section .data
__g_HP_FREED: dq 5427057734453002573
section .text
section .data
__g_HP_CHUNK: dq 1048576
section .text
section .data
__g_OB_TEXT: dq 1
section .text
section .data
__g_OB_LIST: dq 2
section .text
section .data
__g_OB_MAP: dq 3
section .text
section .data
__g_OB_FILE: dq 4
section .text
section .bss
__g_hp_free: resq 17
section .text
section .data
__g_hp_cur: dq 0
section .text
section .data
__g_hp_end: dq 0
section .text
section .data
__g_hp_valloc: dq 0
section .text
section .data
__g_hp_vfree: dq 0
section .text
section .data
__g_hp_err: dq 0
section .text
section .data
__g_hp_ignore: dq 0
section .text
section .data
__g_tv_p: dq 0
section .text
section .data
__g_tv_n: dq 0
section .text
section .data
__g_tv_empty: dq 0
section .text
section .data
__g_ob_ptr: dq 0
section .text
section .data
__g_ob_meta: dq 0
section .text
section .data
__g_ob_cap: dq 0
section .text
section .data
__g_ob_count: dq 0
section .text
section .data
__g_ob_freehead: dq 0
section .text
hp_os_alloc:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 1
    cmp rax, 2
    jne .L1
    mov rax, 9
    push rax
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    mov rax, 3
    push rax
    mov rax, 34
    push rax
    mov rax, 0
    sub rax, 1
    push rax
    mov rax, 0
    push rax
    pop r9
    pop r8
    pop r10
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl0:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L3
    mov rax, 0
    mov rbx, rax
    jmp .L4
.L3:
.L4:
    jmp .L2
.L1:
    mov rax, [rel __g_hp_valloc]
    cmp rax, 0
    jne .L5
section .data
.str7: db 107,101,114,110,101,108,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str7]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str8: db 86,105,114,116,117,97,108,65,108,108,111,99,0
section .text
    lea rax, [rel .str8]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_hp_valloc], rax
    mov rax, rbx
    push rax
section .data
.str9: db 86,105,114,116,117,97,108,70,114,101,101,0
section .text
    lea rax, [rel .str9]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_hp_vfree], rax
    jmp .L6
.L5:
.L6:
    mov rax, [rel __g_hp_valloc]
    push rax
    mov rax, 0
    push rax
    mov rax, r12
    push rax
    mov rax, 12288
    push rax
    mov rax, 4
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl1:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
.L2:
    mov rax, rbx
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,2
    dq .kl0,73
    dq .kl1,83
.kfn: db "hp_os_alloc", 0
section .text
hp_os_free:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, 1
    cmp rax, 2
    jne .L11
    mov rax, 11
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    pop rsi
    pop rdi
    pop rax
.kl2:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_hp_ignore], rax
    jmp .L12
.L11:
    mov rax, [rel __g_hp_vfree]
    push rax
    mov rax, r12
    push rax
    mov rax, 0
    push rax
    mov rax, 32768
    push rax
    pop r8
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl3:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_hp_ignore], rax
.L12:
    mov rax, 0
    jmp .__ret_10
.__ret_10:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_os_alloc.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl2,92
    dq .kl3,94
.kfn: db "hp_os_free", 0
section .text
hp_copy:
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
.L14:
    mov rax, rbx
    add rax, 8
    cmp rax, r12
    jg .L15
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add rbx, 8
.L16:
    jmp .L14
.L15:
.L17:
    cmp rbx, r12
    jge .L18
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
.L19:
    jmp .L17
.L18:
    mov rax, r14
    jmp .__ret_13
.__ret_13:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
hp_zero:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
.L21:
    mov rax, rbx
    add rax, 8
    cmp rax, r12
    jg .L22
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add rbx, 8
.L23:
    jmp .L21
.L22:
.L24:
    cmp rbx, r12
    jge .L25
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L26:
    jmp .L24
.L25:
    mov rax, r13
    jmp .__ret_20
.__ret_20:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
hp_class:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 16
    mov rbx, rax
.L28:
    cmp rbx, r13
    jge .L29
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rbx, rax
    add r12, 1
.L30:
    jmp .L28
.L29:
    mov rax, r12
    jmp .__ret_27
.__ret_27:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
hp_alloc:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov rbx, rcx
    cmp rbx, 0
    jge .L32
    mov rax, 1
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_31
    jmp .L33
.L32:
.L33:
    mov rax, rbx
    add rax, 16
    mov rbx, rax
    mov rax, 0
    mov r14, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_CHUNK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L34
    mov rax, rbx
    add rax, 4095
    mov rcx, 4096
    cqo
    idiv rcx
    mov rcx, 4096
    imul rax, rcx
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl4:
    call hp_os_alloc
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L36
    mov rax, 2
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_31
    jmp .L37
.L36:
.L37:
    mov rax, r14
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    push rax
    mov rax, [rel __g_HP_LARGE]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 16
    jmp .__ret_31
    jmp .L35
.L34:
.L35:
    mov rcx, rbx
    sub rsp, 32
.kl5:
    call hp_class
    add rsp, 32
    mov r13, rax
    mov rax, 16
    mov rcx, r13
    shl rax, cl
    mov r12, rax
    mov rax, r13
    cmp rax, 17
    jb .L38
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl6:
    lea r8, [rel .kx0]
    call __fail_raise
.kx0:
    add rsp, 32
    xor rax, rax
    jmp .__ret_31
.L38:
    mov rcx, rax
    lea rdx, [rel __g_hp_free]
    mov rax, [rdx+rcx*8]
    mov r14, rax
    cmp r14, 0
    je .L39
    mov rax, r13
    cmp rax, 17
    jb .L41
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl7:
    lea r8, [rel .kx1]
    call __fail_raise
.kx1:
    add rsp, 32
    xor rax, rax
    jmp .__ret_31
.L41:
    push rax
    mov rax, r14
    add rax, 16
    mov rax, [rax]
    pop rcx
    lea rdx, [rel __g_hp_free]
    mov [rdx+rcx*8], rax
    mov rax, r14
    add rax, 8
    push rax
    mov rax, [rel __g_HP_MAGIC]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 16
    push rax
    mov rax, r12
    sub rax, 16
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl8:
    call hp_zero
    add rsp, 32
    mov rax, r14
    add rax, 16
    jmp .__ret_31
    jmp .L40
.L39:
.L40:
    mov rax, [rel __g_hp_cur]
    add rax, r12
    push rax
    mov rax, [rel __g_hp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L42
    mov rax, [rel __g_HP_CHUNK]
    push rax
    pop rcx
    sub rsp, 32
.kl9:
    call hp_os_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L44
    mov rax, 2
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_31
    jmp .L45
.L44:
.L45:
    mov rax, rbx
    mov [rel __g_hp_cur], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_CHUNK]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_hp_end], rax
    jmp .L43
.L42:
.L43:
    mov rax, [rel __g_hp_cur]
    mov r14, rax
    mov rax, [rel __g_hp_cur]
    add rax, r12
    mov [rel __g_hp_cur], rax
    mov rax, r14
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    push rax
    mov rax, [rel __g_HP_MAGIC]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 16
    jmp .__ret_31
.__ret_31:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_os_free.kft, .kfe, .kfn, __kron_file_0,6
    dq .kl4,153
    dq .kl5,164
    dq .kl6,166
    dq .kl7,169
    dq .kl8,172
    dq .kl9,176
.kfn: db "hp_alloc", 0
section .text
hp_room:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    sub rax, 16
    mov rax, [rax]
    mov r12, rax
    mov rax, r13
    sub rax, 8
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_LARGE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L47
    mov rax, r12
    sub rax, 16
    jmp .__ret_46
    jmp .L48
.L47:
.L48:
    mov rax, 16
    mov rcx, r12
    shl rax, cl
    sub rax, 16
    jmp .__ret_46
.__ret_46:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
hp_release:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    cmp rbx, 0
    jne .L50
    mov rax, 0
    jmp .__ret_49
    jmp .L51
.L50:
.L51:
    mov rax, rbx
    sub rax, 16
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    mov rax, [rax]
    mov r12, rax
    mov rax, r13
    add rax, 8
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_LARGE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L52
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl10:
    call hp_os_free
    add rsp, 32
    mov rax, 0
    jmp .__ret_49
    jmp .L53
.L52:
.L53:
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_MAGIC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L54
    mov rax, 0
    jmp .__ret_49
    jmp .L55
.L54:
.L55:
    mov rax, r13
    add rax, 8
    push rax
    mov rax, [rel __g_HP_FREED]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 16
    push rax
    mov rax, r12
    cmp rax, 17
    jb .L56
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl11:
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_49
.L56:
    mov rcx, rax
    lea rdx, [rel __g_hp_free]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    cmp rax, 17
    jb .L57
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl12:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_49
.L57:
    push rax
    mov rax, r13
    pop rcx
    lea rdx, [rel __g_hp_free]
    mov [rdx+rcx*8], rax
    mov rax, 0
    jmp .__ret_49
.__ret_49:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_alloc.kft, .kfe, .kfn, __kron_file_0,3
    dq .kl10,219
    dq .kl11,227
    dq .kl12,228
.kfn: db "hp_release", 0
section .text
hp_grow:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    cmp r14, 0
    jne .L59
    mov rcx, r13
    sub rsp, 32
.kl13:
    call hp_alloc
    add rsp, 32
    jmp .__ret_58
    jmp .L60
.L59:
.L60:
    mov rcx, r14
    sub rsp, 32
.kl14:
    call hp_room
    add rsp, 32
    mov r12, rax
    cmp r13, r12
    jg .L61
    mov rax, r14
    jmp .__ret_58
    jmp .L62
.L61:
.L62:
    mov rax, r12
    mov rcx, 2
    imul rax, rcx
    mov rbx, rax
    cmp rbx, r13
    jge .L63
    mov rax, r13
    mov rbx, rax
    jmp .L64
.L63:
.L64:
    mov rcx, rbx
    sub rsp, 32
.kl15:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L65
    mov rax, 0
    jmp .__ret_58
    jmp .L66
.L65:
.L66:
    mov rcx, rbx
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
.kl16:
    call hp_copy
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl17:
    call hp_release
    add rsp, 32
    mov rax, rbx
    jmp .__ret_58
.__ret_58:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_release.kft, .kfe, .kfn, __kron_file_0,5
    dq .kl13,236
    dq .kl14,238
    dq .kl15,246
    dq .kl16,250
    dq .kl17,251
.kfn: db "hp_grow", 0
section .text
ob_new:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov r14, rax
    mov rax, [rel __g_ob_freehead]
    cmp rax, 0
    je .L68
    mov rax, [rel __g_ob_freehead]
    sub rax, 1
    mov r14, rax
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov [rel __g_ob_freehead], rax
    jmp .L69
.L68:
    mov rax, [rel __g_ob_count]
    push rax
    mov rax, [rel __g_ob_cap]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L70
    mov rax, [rel __g_ob_cap]
    mov rcx, 2
    imul rax, rcx
    mov r14, rax
    cmp r14, 1024
    jge .L72
    mov rax, 1024
    mov r14, rax
    jmp .L73
.L72:
.L73:
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl18:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L74
    mov rax, 0
    jmp .__ret_67
    jmp .L75
.L74:
.L75:
    mov rax, rbx
    mov [rel __g_ob_ptr], rax
    mov rax, [rel __g_ob_meta]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl19:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L76
    mov rax, 0
    jmp .__ret_67
    jmp .L77
.L76:
.L77:
    mov rax, rbx
    mov [rel __g_ob_meta], rax
    mov rax, r14
    mov [rel __g_ob_cap], rax
    jmp .L71
.L70:
.L71:
    mov rax, [rel __g_ob_count]
    mov r14, rax
    mov rax, [rel __g_ob_count]
    add rax, 1
    mov [rel __g_ob_count], rax
.L69:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_ob_meta]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, 8
    sar rax, cl
    mov rcx, 1073741823
    and rax, rcx
    mov rbx, rax
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_ob_meta]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 8
    shl rax, cl
    or rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_HP_TAG]
    push rax
    mov rax, rbx
    mov rcx, 32
    shl rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, r14
    jmp .__ret_67
.__ret_67:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_grow.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl18,268
    dq .kl19,273
.kfn: db "ob_new", 0
section .text
ob_is:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jge .L79
    mov rax, 0
    jmp .__ret_78
    jmp .L80
.L79:
.L80:
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_TAG]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    jne .L81
    mov rax, 0
    jmp .__ret_78
    jmp .L82
.L81:
.L82:
    mov rax, 1
    jmp .__ret_78
.__ret_78:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
ob_slot:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov rcx, rbx
    sub rsp, 32
.kl20:
    call ob_is
    add rsp, 32
    cmp rax, 0
    jne .L84
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_83
    jmp .L85
.L84:
.L85:
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov r13, rax
    mov rax, rbx
    mov rcx, 32
    sar rax, cl
    mov rcx, 1073741823
    and rax, rcx
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_ob_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L86
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_83
    jmp .L87
.L86:
.L87:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_ob_meta]
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 8
    sar rax, cl
    mov rcx, 1073741823
    and rax, rcx
    cmp rax, r12
    je .L88
    mov rax, 4
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_83
    jmp .L89
.L88:
.L89:
    mov rax, rbx
    and rax, 255
    cmp rax, r14
    je .L90
    mov rax, rbx
    and rax, 255
    cmp rax, 0
    jne .L92
    mov rax, 4
    mov [rel __g_hp_err], rax
    jmp .L93
.L92:
    mov rax, 3
    mov [rel __g_hp_err], rax
.L93:
    mov rax, 1
    neg rax
    jmp .__ret_83
    jmp .L91
.L90:
.L91:
    mov rax, r13
    jmp .__ret_83
.__ret_83:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ob_new.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl20,305
.kfn: db "ob_slot", 0
section .text
ob_get:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl21:
    call ob_slot
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jge .L95
    mov rax, 0
    jmp .__ret_94
    jmp .L96
.L95:
.L96:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_94
.__ret_94:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ob_slot.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl21,334
.kfn: db "ob_get", 0
section .text
ob_put:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_97
.__ret_97:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ob_drop:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    mov rax, [rel __g_ob_meta]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 8
    sar rax, cl
    add rax, 1
    mov rcx, 1073741823
    and rax, rcx
    mov rbx, rax
    mov rax, [rel __g_ob_meta]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 8
    shl rax, cl
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_ob_freehead]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    add rax, 1
    mov [rel __g_ob_freehead], rax
    mov rax, 0
    jmp .__ret_98
.__ret_98:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
tv_view:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    cmp r12, 0
    jne .L100
    lea rax, [rel __g_tv_empty]
    mov [rel __g_tv_p], rax
    mov rax, 0
    mov [rel __g_tv_n], rax
    mov rax, 1
    jmp .__ret_99
    jmp .L101
.L100:
.L101:
    mov rcx, r12
    sub rsp, 32
.kl22:
    call ob_is
    add rsp, 32
    test rax, rax
    jz .L102
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl23:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L104
    mov rax, 0
    jmp .__ret_99
    jmp .L105
.L104:
.L105:
    mov rax, rbx
    mov rax, [rax]
    mov [rel __g_tv_n], rax
    mov rax, rbx
    add rax, 8
    mov [rel __g_tv_p], rax
    mov rax, 1
    jmp .__ret_99
    jmp .L103
.L102:
.L103:
    cmp r12, 65536
    jge .L106
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_99
    jmp .L107
.L106:
.L107:
    mov rax, r12
    mov rcx, 140737488355328
    cmp rax, rcx
    jl .L108
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_99
    jmp .L109
.L108:
.L109:
    mov rax, 0
    mov rbx, rax
.L110:
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, 0
    je .L111
    add rbx, 1
.L112:
    jmp .L110
.L111:
    mov rax, r12
    mov [rel __g_tv_p], rax
    mov rax, rbx
    mov [rel __g_tv_n], rax
    mov rax, 1
    jmp .__ret_99
.__ret_99:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ob_get.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl22,374
    dq .kl23,375
.kfn: db "tv_view", 0
section .text
tv_compare:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
.kl24:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L114
    mov rax, 0
    jmp .__ret_113
    jmp .L115
.L114:
.L115:
    mov rax, [rel __g_tv_p]
    mov [rbp-24], rax
    mov rax, [rel __g_tv_n]
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
.kl25:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L116
    mov rax, 0
    jmp .__ret_113
    jmp .L117
.L116:
.L117:
    mov rax, [rel __g_tv_p]
    mov [rbp-40], rax
    mov rax, [rel __g_tv_n]
    mov [rbp-48], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L118:
    cmp r14, r15
    jge .L119
    mov rax, r14
    mov rcx, [rbp-48]
    cmp rax, rcx
    jl .L121
    mov rax, 1
    mov r13, rax
    mov rax, r15
    mov r14, rax
    jmp .L122
.L121:
    mov rax, [rbp-24]
    add rax, r14
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, [rbp-40]
    add rax, r14
    movzx rax, byte [rax]
    mov rbx, rax
    cmp r12, rbx
    jge .L123
    mov rax, 1
    neg rax
    mov r13, rax
    mov rax, r15
    mov r14, rax
    jmp .L124
.L123:
    cmp r12, rbx
    jle .L125
    mov rax, 1
    mov r13, rax
    mov rax, r15
    mov r14, rax
    jmp .L126
.L125:
.L126:
.L124:
.L122:
    add r14, 1
.L120:
    jmp .L118
.L119:
    cmp r13, 0
    jne .L127
    mov rax, r15
    mov rcx, [rbp-48]
    cmp rax, rcx
    jge .L129
    mov rax, 1
    neg rax
    mov r13, rax
    jmp .L130
.L129:
.L130:
    jmp .L128
.L127:
.L128:
    mov rax, r13
    jmp .__ret_113
.__ret_113:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tv_view.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl24,406
    dq .kl25,411
.kfn: db "tv_compare", 0
section .text
hp_take_err:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_hp_err]
    mov rbx, rax
    mov rax, 0
    mov [rel __g_hp_err], rax
    mov rax, rbx
    jmp .__ret_131
.__ret_131:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
heap_fail:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 1
    jne .L133
section .data
.str135: db 110,101,103,97,116,105,118,101,32,115,105,122,101,0
section .text
    lea rax, [rel .str135]
    push rax
section .data
.str136: db 115,105,122,101,115,32,97,110,100,32,108,101,110,103,116,104,115,32,115,116,97,114,116,32,97,116,32,48,0
section .text
    lea rax, [rel .str136]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl26:
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L134
.L133:
    cmp rbx, 2
    jne .L137
section .data
.str139: db 111,117,116,32,111,102,32,109,101,109,111,114,121,0
section .text
    lea rax, [rel .str139]
    push rax
section .data
.str140: db 116,104,101,32,115,121,115,116,101,109,32,114,101,102,117,115,101,100,32,109,111,114,101,32,109,101,109,111,114,121,58,32,102,114,101,101,32,116,101,120,116,115,44,32,108,105,115,116,115,32,97,110,100,32,109,97,112,115,32,121,111,117,32,110
    db 111,32,108,111,110,103,101,114,32,110,101,101,100,0
section .text
    lea rax, [rel .str140]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl27:
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L138
.L137:
    cmp rbx, 3
    jne .L141
section .data
.str143: db 110,111,116,32,116,104,101,32,107,105,110,100,32,111,102,32,118,97,108,117,101,32,116,104,105,115,32,102,117,110,99,116,105,111,110,32,116,97,107,101,115,0
section .text
    lea rax, [rel .str143]
    push rax
section .data
.str144: db 112,97,115,115,32,97,32,116,101,120,116,44,32,108,105,115,116,32,111,114,32,109,97,112,32,109,97,100,101,32,98,121,32,116,104,105,115,32,108,105,98,114,97,114,121,44,32,111,114,32,97,32,115,116,114,105,110,103,32,108,105,116,101,114
    db 97,108,32,119,104,101,114,101,32,97,32,116,101,120,116,32,105,115,32,97,115,107,101,100,32,102,111,114,0
section .text
    lea rax, [rel .str144]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl28:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L142
.L141:
    cmp rbx, 4
    jne .L145
section .data
.str147: db 117,115,101,100,32,97,102,116,101,114,32,105,116,32,119,97,115,32,102,114,101,101,100,0
section .text
    lea rax, [rel .str147]
    push rax
section .data
.str148: db 97,32,116,101,120,116,44,32,108,105,115,116,44,32,109,97,112,32,111,114,32,102,105,108,101,32,105,115,32,103,111,110,101,32,97,102,116,101,114,32,116,101,120,116,95,102,114,101,101,44,32,108,105,115,116,95,102,114,101,101,44,32,109,97
    db 112,95,102,114,101,101,32,111,114,32,102,105,108,101,95,99,108,111,115,101,0
section .text
    lea rax, [rel .str148]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl29:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L146
.L145:
    cmp rbx, 5
    jne .L149
section .data
.str151: db 105,110,100,101,120,32,111,117,116,32,111,102,32,114,97,110,103,101,0
section .text
    lea rax, [rel .str151]
    push rax
section .data
.str152: db 116,104,101,32,105,110,100,101,120,32,104,97,115,32,116,111,32,103,111,32,102,114,111,109,32,48,32,116,111,32,116,104,101,32,108,101,110,103,116,104,32,109,105,110,117,115,32,111,110,101,0
section .text
    lea rax, [rel .str152]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl30:
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L150
.L149:
    cmp rbx, 6
    jne .L153
section .data
.str155: db 107,101,121,32,110,111,116,32,102,111,117,110,100,0
section .text
    lea rax, [rel .str155]
    push rax
section .data
.str156: db 99,104,101,99,107,32,119,105,116,104,32,109,97,112,95,104,97,115,32,102,105,114,115,116,44,32,111,114,32,117,115,101,32,109,97,112,95,103,101,116,95,111,114,0
section .text
    lea rax, [rel .str156]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl31:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L154
.L153:
    cmp rbx, 7
    jne .L157
section .data
.str159: db 110,111,116,32,97,32,110,117,109,98,101,114,0
section .text
    lea rax, [rel .str159]
    push rax
section .data
.str160: db 100,105,103,105,116,115,32,119,105,116,104,32,97,110,32,111,112,116,105,111,110,97,108,32,115,105,103,110,44,32,112,111,105,110,116,32,97,110,100,32,101,120,112,111,110,101,110,116,58,32,45,49,50,44,32,51,46,53,44,32,49,101,54,0
section .text
    lea rax, [rel .str160]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl32:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L158
.L157:
    cmp rbx, 8
    jne .L161
section .data
.str163: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,111,112,101,110,101,100,0
section .text
    lea rax, [rel .str163]
    push rax
section .data
.str164: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,44,32,97,110,100,32,116,104,97,116,32,116,104,101,32,102,105,108,101,32,101,120,105,115,116,115,32,97,110,100,32,99,97,110,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str164]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl33:
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L162
.L161:
    cmp rbx, 9
    jne .L165
section .data
.str167: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,119,114,105,116,116,101,110,0
section .text
    lea rax, [rel .str167]
    push rax
section .data
.str168: db 99,104,101,99,107,32,116,104,97,116,32,116,104,101,32,102,111,108,100,101,114,32,101,120,105,115,116,115,32,97,110,100,32,116,104,101,32,102,105,108,101,32,105,115,32,110,111,116,32,114,101,97,100,45,111,110,108,121,0
section .text
    lea rax, [rel .str168]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl34:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L166
.L165:
    cmp rbx, 10
    jne .L169
section .data
.str171: db 116,104,101,32,108,105,115,116,32,105,115,32,101,109,112,116,121,0
section .text
    lea rax, [rel .str171]
    push rax
section .data
.str172: db 99,104,101,99,107,32,108,105,115,116,95,108,101,110,32,102,105,114,115,116,0
section .text
    lea rax, [rel .str172]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl35:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L170
.L169:
    cmp rbx, 11
    jne .L173
section .data
.str175: db 116,104,101,32,102,111,108,100,101,114,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str175]
    push rax
section .data
.str176: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,32,97,110,100,32,116,104,97,116,32,105,116,32,105,115,32,97,32,102,111,108,100,101,114,0
section .text
    lea rax, [rel .str176]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl36:
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L174
.L173:
    cmp rbx, 12
    jne .L177
section .data
.str179: db 116,104,101,32,112,114,111,103,114,97,109,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,117,110,0
section .text
    lea rax, [rel .str179]
    push rax
section .data
.str180: db 99,104,101,99,107,32,105,116,115,32,110,97,109,101,32,97,110,100,32,116,104,97,116,32,105,116,32,105,115,32,111,110,32,116,104,101,32,80,65,84,72,0
section .text
    lea rax, [rel .str180]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl37:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L178
.L177:
    cmp rbx, 13
    jne .L181
section .data
.str183: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,100,101,108,101,116,101,100,32,111,114,32,114,101,110,97,109,101,100,0
section .text
    lea rax, [rel .str183]
    push rax
section .data
.str184: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,32,97,110,100,32,116,104,97,116,32,110,111,116,104,105,110,103,32,104,97,115,32,105,116,32,111,112,101,110,0
section .text
    lea rax, [rel .str184]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl38:
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L182
.L181:
    cmp rbx, 14
    jne .L185
section .data
.str187: db 116,104,101,32,102,111,108,100,101,114,32,99,111,117,108,100,32,110,111,116,32,98,101,32,109,97,100,101,0
section .text
    lea rax, [rel .str187]
    push rax
section .data
.str188: db 99,104,101,99,107,32,116,104,97,116,32,105,116,115,32,112,97,114,101,110,116,32,101,120,105,115,116,115,32,97,110,100,32,116,104,101,32,110,97,109,101,32,105,115,32,102,114,101,101,0
section .text
    lea rax, [rel .str188]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl39:
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L186
.L185:
    cmp rbx, 15
    jne .L189
section .data
.str191: db 110,111,116,32,115,101,116,0
section .text
    lea rax, [rel .str191]
    push rax
section .data
.str192: db 116,104,101,32,101,110,118,105,114,111,110,109,101,110,116,32,118,97,114,105,97,98,108,101,32,100,111,101,115,32,110,111,116,32,101,120,105,115,116,58,32,99,104,101,99,107,32,119,105,116,104,32,101,110,118,95,104,97,115,0
section .text
    lea rax, [rel .str192]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl40:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L190
.L189:
    cmp rbx, 16
    jne .L193
section .data
.str195: db 116,104,101,32,102,105,108,101,32,105,115,32,99,108,111,115,101,100,32,111,114,32,119,97,115,32,111,112,101,110,101,100,32,102,111,114,32,115,111,109,101,116,104,105,110,103,32,101,108,115,101,0
section .text
    lea rax, [rel .str195]
    push rax
section .data
.str196: db 111,112,101,110,32,105,116,32,119,105,116,104,32,34,114,34,32,116,111,32,114,101,97,100,44,32,34,119,34,32,111,114,32,34,97,34,32,116,111,32,119,114,105,116,101,44,32,34,114,119,34,32,102,111,114,32,98,111,116,104,0
section .text
    lea rax, [rel .str196]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl41:
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L194
.L193:
    cmp rbx, 17
    jne .L197
section .data
.str199: db 116,104,101,32,112,105,99,116,117,114,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str199]
    push rax
section .data
.str200: db 80,78,71,44,32,111,114,32,66,77,80,32,111,102,32,50,52,32,111,114,32,51,50,32,98,105,116,115,59,32,116,104,101,32,102,105,108,101,32,109,97,121,32,98,101,32,100,97,109,97,103,101,100,0
section .text
    lea rax, [rel .str200]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl42:
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_132
    jmp .L198
.L197:
.L198:
.L194:
.L190:
.L186:
.L182:
.L178:
.L174:
.L170:
.L166:
.L162:
.L158:
.L154:
.L150:
.L146:
.L142:
.L138:
.L134:
    mov rax, 0
    jmp .__ret_132
.__ret_132:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tv_compare.kft, .kfe, .kfn, __kron_file_0,17
    dq .kl26,457
    dq .kl27,458
    dq .kl28,459
    dq .kl29,460
    dq .kl30,461
    dq .kl31,462
    dq .kl32,463
    dq .kl33,464
    dq .kl34,465
    dq .kl35,466
    dq .kl36,467
    dq .kl37,468
    dq .kl38,469
    dq .kl39,470
    dq .kl40,471
    dq .kl41,472
    dq .kl42,473
.kfn: db "heap_fail", 0
section .text
section .data
__g_li_real: dq 0
section .text
li_new:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, 8
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl43:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L202
    mov rax, 0
    jmp .__ret_201
    jmp .L203
.L202:
.L203:
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl44:
    call ob_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L204
    mov rcx, r12
    sub rsp, 32
.kl45:
    call hp_release
    add rsp, 32
    jmp .L205
.L204:
.L205:
    mov rax, rbx
    jmp .__ret_201
.__ret_201:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq heap_fail.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl43,43
    dq .kl44,47
    dq .kl45,49
.kfn: db "li_new", 0
section .text
li_len:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl46:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L207
    mov rax, 0
    jmp .__ret_206
    jmp .L208
.L207:
.L208:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_206
.__ret_206:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_new.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl46,55
.kfn: db "li_len", 0
section .text
li_room:
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
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl47:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L210
    mov rax, 0
    jmp .__ret_209
    jmp .L211
.L210:
.L211:
    mov rcx, rbx
    sub rsp, 32
.kl48:
    call hp_room
    add rsp, 32
    push rax
    mov rax, 8
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L212
    mov rax, rbx
    jmp .__ret_209
    jmp .L213
.L212:
.L213:
    mov rax, rbx
    push rax
    mov rax, 8
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl49:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L214
    mov rax, 0
    jmp .__ret_209
    jmp .L215
.L214:
.L215:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl50:
    call ob_put
    add rsp, 32
    mov rax, rbx
    jmp .__ret_209
.__ret_209:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_len.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl47,66
    dq .kl48,70
    dq .kl49,73
    dq .kl50,77
.kfn: db "li_room", 0
section .text
li_add:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, r14
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl51:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L217
    mov rax, 0
    jmp .__ret_216
    jmp .L218
.L217:
.L218:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, r14
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl52:
    call li_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L219
    mov rax, 0
    jmp .__ret_216
    jmp .L220
.L219:
.L220:
    mov rax, r12
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    push rax
    mov rax, rbx
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    jmp .__ret_216
.__ret_216:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_room.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl51,82
    dq .kl52,88
.kfn: db "li_add", 0
section .text
li_at:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl53:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L222
    mov rax, 0
    jmp .__ret_221
    jmp .L223
.L222:
.L223:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp r13, 0
    jge .L224
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_221
    jmp .L225
.L224:
.L225:
    cmp r13, rbx
    jl .L226
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_221
    jmp .L227
.L226:
.L227:
    mov rax, r12
    add rax, 8
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_221
.__ret_221:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_add.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl53,101
.kfn: db "li_at", 0
section .text
li_get:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl54:
    call li_at
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L229
    mov rax, 0
    jmp .__ret_228
    jmp .L230
.L229:
.L230:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_228
.__ret_228:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_at.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl54,119
.kfn: db "li_get", 0
section .text
li_free:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl55:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L232
    mov rax, 0
    jmp .__ret_231
    jmp .L233
.L232:
.L233:
    mov rcx, r12
    sub rsp, 32
.kl56:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl57:
    call hp_release
    add rsp, 32
    mov rax, 0
    jmp .__ret_231
.__ret_231:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_get.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl55,129
    dq .kl56,133
    dq .kl57,134
.kfn: db "li_free", 0
section .text
li_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    mov [rbp-192], rbx
    mov [rbp-184], r12
    mov [rbp-176], r13
    mov [rbp-168], r14
    mov [rbp-160], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl58:
    call ob_get
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L235
    mov rax, 0
    jmp .__ret_234
    jmp .L236
.L235:
.L236:
    mov rax, 0
    mov r15, rax
    mov rax, [rbp-24]
    mov rax, [rax]
    mov r15, rax
    cmp r15, 2
    jge .L237
    mov rax, [rbp-8]
    jmp .__ret_234
    jmp .L238
.L237:
.L238:
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl59:
    call hp_alloc
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L239
    mov rax, 0
    jmp .__ret_234
    jmp .L240
.L239:
.L240:
    mov rax, [rbp-24]
    add rax, 8
    mov r14, rax
    mov rax, [rbp-40]
    mov [rbp-56], rax
    mov rax, 1
    mov [rbp-64], rax
.L241:
    mov rax, [rbp-64]
    cmp rax, r15
    jge .L242
    mov rax, 0
    mov rbx, rax
.L244:
    cmp rbx, r15
    jge .L245
    mov rax, rbx
    mov rcx, [rbp-64]
    add rax, rcx
    mov [rbp-80], rax
    mov rax, [rbp-80]
    cmp rax, r15
    jle .L247
    mov rax, r15
    mov [rbp-80], rax
    jmp .L248
.L247:
.L248:
    mov rax, rbx
    push rax
    mov rax, [rbp-64]
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-88], rax
    mov rax, [rbp-88]
    cmp rax, r15
    jle .L249
    mov rax, r15
    mov [rbp-88], rax
    jmp .L250
.L249:
.L250:
    mov rax, rbx
    mov r13, rax
    mov rax, [rbp-80]
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
.L251:
    mov rax, rbx
    mov rcx, [rbp-88]
    cmp rax, rcx
    jge .L252
    mov rax, 0
    mov [rbp-120], rax
    mov rax, r13
    mov rcx, [rbp-80]
    cmp rax, rcx
    jl .L254
    mov rax, 1
    mov [rbp-120], rax
    jmp .L255
.L254:
    mov rax, r12
    mov rcx, [rbp-88]
    cmp rax, rcx
    jge .L256
    mov rax, 0
    mov [rbp-128], rax
    mov rax, 0
    mov [rbp-136], rax
    mov rax, r14
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov [rbp-128], rax
    mov rax, r14
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov [rbp-136], rax
    mov rcx, [rbp-136]
    mov rdx, [rbp-128]
    mov r8, [rbp-16]
    sub rsp, 32
.kl60:
    call li_less
    add rsp, 32
    test rax, rax
    jz .L258
    mov rax, 1
    mov [rbp-120], rax
    jmp .L259
.L258:
.L259:
    jmp .L257
.L256:
.L257:
.L255:
    mov rax, [rbp-120]
    test rax, rax
    jz .L260
    mov rax, [rbp-56]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L261
.L260:
    mov rax, [rbp-56]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
.L261:
    mov rax, [rbp-120]
    test rax, rax
    jz .L262
    add r12, 1
    jmp .L263
.L262:
    add r13, 1
.L263:
    add rbx, 1
.L253:
    jmp .L251
.L252:
    mov rax, [rbp-88]
    mov rbx, rax
.L246:
    jmp .L244
.L245:
    mov rax, r14
    mov rbx, rax
    mov rax, [rbp-56]
    mov r14, rax
    mov rax, rbx
    mov [rbp-56], rax
    mov rax, [rbp-64]
    mov rcx, 2
    imul rax, rcx
    mov [rbp-64], rax
.L243:
    jmp .L241
.L242:
    mov rax, r14
    push rax
    mov rax, [rbp-24]
    add rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L264
    mov rax, [rbp-24]
    add rax, 8
    push rax
    mov rax, r14
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl61:
    call hp_copy
    add rsp, 32
    jmp .L265
.L264:
.L265:
    mov rcx, [rbp-40]
    sub rsp, 32
.kl62:
    call hp_release
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_234
.__ret_234:
    mov rbx, [rbp-192]
    mov r12, [rbp-184]
    mov r13, [rbp-176]
    mov r14, [rbp-168]
    mov r15, [rbp-160]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_free.kft, .kfe, .kfn, __kron_file_1,5
    dq .kl58,141
    dq .kl59,150
    dq .kl60,182
    dq .kl61,208
    dq .kl62,210
.kfn: db "li_sort", 0
section .text
li_less:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    cmp rbx, 0
    jne .L267
    cmp r13, r12
    jge .L269
    mov rax, 1
    jmp .__ret_266
    jmp .L270
.L269:
.L270:
    mov rax, 0
    jmp .__ret_266
    jmp .L268
.L267:
.L268:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl63:
    call tv_compare
    add rsp, 32
    cmp rax, 0
    jge .L271
    mov rax, 1
    jmp .__ret_266
    jmp .L272
.L271:
.L272:
    mov rax, 0
    jmp .__ret_266
.__ret_266:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_sort.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl63,221
.kfn: db "li_less", 0
section .text
list_end:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    sub rsp, 32
.kl64:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L274
    mov rcx, rbx
    sub rsp, 32
.kl65:
    call heap_fail
    add rsp, 32
    jmp .__ret_273
    jmp .L275
.L274:
.L275:
    mov rax, r12
    jmp .__ret_273
.__ret_273:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_less.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl64,230
    dq .kl65,233
.kfn: db "list_end", 0
section .text
list_new:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
.kl66:
    call li_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_276
.__ret_276:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_end.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl66,240
.kfn: db "list_new", 0
section .text
list_free:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl67:
    call li_free
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_277
.__ret_277:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_new.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl67,245
.kfn: db "list_free", 0
section .text
list_len:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl68:
    call li_len
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_278
.__ret_278:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_free.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl68,250
.kfn: db "list_len", 0
section .text
list_add:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl69:
    call li_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_279
.__ret_279:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_len.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl69,255
.kfn: db "list_add", 0
section .text
list_get:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl70:
    call li_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_280
.__ret_280:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl70,260
.kfn: db "list_get", 0
section .text
list_set:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rbx, rdx
    mov r12, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl71:
    call li_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L282
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L283
.L282:
.L283:
    mov rcx, r12
    sub rsp, 32
.kl72:
    call list_end
    add rsp, 32
    jmp .__ret_281
.__ret_281:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl71,265
    dq .kl72,269
.kfn: db "list_set", 0
section .text
list_last:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl73:
    call li_len
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L285
    cmp r12, 0
    jne .L287
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L288
.L287:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl74:
    call li_get
    add rsp, 32
    mov rbx, rax
.L288:
    jmp .L286
.L285:
.L286:
    mov rcx, rbx
    sub rsp, 32
.kl75:
    call list_end
    add rsp, 32
    jmp .__ret_284
.__ret_284:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_set.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl73,274
    dq .kl74,280
    dq .kl75,283
.kfn: db "list_last", 0
section .text
list_pop:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl76:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L290
    cmp r13, 0
    jne .L292
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L293
.L292:
    mov rax, rbx
    push rax
    mov rax, r13
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl77:
    call li_get
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl78:
    call ob_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r13
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
.L293:
    jmp .L291
.L290:
.L291:
    mov rcx, r12
    sub rsp, 32
.kl79:
    call list_end
    add rsp, 32
    jmp .__ret_289
.__ret_289:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_last.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl76,288
    dq .kl77,294
    dq .kl78,295
    dq .kl79,299
.kfn: db "list_pop", 0
section .text
list_insert:
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
    mov [rbp-24], r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
.kl80:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L295
    cmp r14, 0
    jge .L297
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L298
.L297:
    cmp r14, r13
    jle .L299
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L300
.L299:
    mov rax, r15
    push rax
    mov rax, r13
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl81:
    call li_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L301
    mov rax, r13
    mov rbx, rax
.L303:
    cmp rbx, r14
    jle .L304
    mov rax, r12
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    add rax, 8
    push rax
    mov rax, rbx
    sub rax, 1
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    sub rbx, 1
.L305:
    jmp .L303
.L304:
    mov rax, r12
    add rax, 8
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    push rax
    mov rax, r13
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L302
.L301:
.L302:
.L300:
.L298:
    jmp .L296
.L295:
.L296:
    mov rcx, r15
    sub rsp, 32
.kl82:
    call list_end
    add rsp, 32
    jmp .__ret_294
.__ret_294:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_pop.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl80,304
    dq .kl81,311
    dq .kl82,325
.kfn: db "list_insert", 0
section .text
list_remove:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl83:
    call li_get
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L307
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl84:
    call ob_get
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, r13
    mov rax, [rax]
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
.L309:
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L310
    mov rax, r13
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    add rax, 8
    push rax
    mov rax, rbx
    add rax, 1
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add rbx, 1
.L311:
    jmp .L309
.L310:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L308
.L307:
.L308:
    mov rcx, r14
    sub rsp, 32
.kl85:
    call list_end
    add rsp, 32
    jmp .__ret_306
.__ret_306:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_insert.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl83,330
    dq .kl84,332
    dq .kl85,344
.kfn: db "list_remove", 0
section .text
list_clear:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl86:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L313
    mov rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L314
.L313:
.L314:
    mov rcx, r12
    sub rsp, 32
.kl87:
    call list_end
    add rsp, 32
    jmp .__ret_312
.__ret_312:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_remove.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl86,349
    dq .kl87,353
.kfn: db "list_clear", 0
section .text
list_find:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rbx, rcx
    mov r15, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl88:
    call ob_get
    add rsp, 32
    mov r14, rax
    mov rax, 1
    neg rax
    mov r13, rax
    cmp r14, 0
    je .L316
    mov rax, r14
    mov rax, [rax]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L318:
    cmp rbx, r12
    jge .L319
    mov rax, r14
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    cmp rax, r15
    jne .L321
    mov rax, rbx
    mov r13, rax
    mov rax, r12
    mov rbx, rax
    jmp .L322
.L321:
.L322:
    add rbx, 1
.L320:
    jmp .L318
.L319:
    jmp .L317
.L316:
.L317:
    mov rcx, r13
    sub rsp, 32
.kl89:
    call list_end
    add rsp, 32
    jmp .__ret_315
.__ret_315:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_clear.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl88,358
    dq .kl89,373
.kfn: db "list_find", 0
section .text
list_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl90:
    call li_sort
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_323
.__ret_323:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_find.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl90,378
.kfn: db "list_sort", 0
section .text
list_reverse:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl91:
    call ob_get
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    je .L325
    mov rax, r14
    mov rax, [rax]
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L327:
    cmp r13, r12
    jge .L328
    mov rax, r14
    add rax, 8
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, r14
    add rax, 8
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    add rax, 8
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add r13, 1
    sub r12, 1
.L329:
    jmp .L327
.L328:
    jmp .L326
.L325:
.L326:
    mov rcx, r15
    sub rsp, 32
.kl92:
    call list_end
    add rsp, 32
    jmp .__ret_324
.__ret_324:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_sort.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl91,383
    dq .kl92,398
.kfn: db "list_reverse", 0
section .text
list_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl93:
    call li_len
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L331
    mov rcx, r14
    sub rsp, 32
.kl94:
    call li_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    je .L333
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl95:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl96:
    call ob_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, 8
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl97:
    call hp_copy
    add rsp, 32
    jmp .L334
.L333:
.L334:
    jmp .L332
.L331:
.L332:
    mov rcx, r13
    sub rsp, 32
.kl98:
    call list_end
    add rsp, 32
    jmp .__ret_330
.__ret_330:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_reverse.kft, .kfe, .kfn, __kron_file_1,6
    dq .kl93,403
    dq .kl94,406
    dq .kl95,408
    dq .kl96,409
    dq .kl97,410
    dq .kl98,413
.kfn: db "list_copy", 0
section .text
list_add_real:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
    mov r12, rcx
    movaps xmm6, xmm1
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    movaps xmm0, xmm6
    movsd [rel __g_li_real], xmm0
    lea rax, [rel __g_li_real]
    mov rax, [rax]
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl99:
    call li_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_335
.__ret_335:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_copy.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl99,423
.kfn: db "list_add_real", 0
section .text
list_get_real:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl100:
    call li_get
    add rsp, 32
    mov rbx, rax
section .data
.flt337: dq 0.0
section .text
    movsd xmm0, [rel .flt337]
    movaps xmm6, xmm0
    lea rax, [rel __g_li_real]
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    movsd xmm0, [rel __g_li_real]
    movaps xmm6, xmm0
    sub rsp, 32
.kl101:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L338
    mov rcx, rbx
    sub rsp, 32
.kl102:
    call heap_fail
    add rsp, 32
section .data
.flt340: dq 0.0
section .text
    movsd xmm0, [rel .flt340]
    jmp .__ret_336
    jmp .L339
.L338:
.L339:
    movaps xmm0, xmm6
    jmp .__ret_336
.__ret_336:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add_real.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl100,428
    dq .kl101,434
    dq .kl102,437
.kfn: db "list_get_real", 0
section .text
list_set_real:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    mov r12, rcx
    mov rbx, rdx
    movaps xmm6, xmm2
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl103:
    call li_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L342
    movaps xmm0, xmm6
    movsd [rel __g_li_real], xmm0
    mov rax, rbx
    push rax
    lea rax, [rel __g_li_real]
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L343
.L342:
.L343:
    sub rsp, 32
.kl104:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L344
    mov rcx, rbx
    sub rsp, 32
.kl105:
    call heap_fail
    add rsp, 32
section .data
.flt346: dq 0.0
section .text
    movsd xmm0, [rel .flt346]
    jmp .__ret_341
    jmp .L345
.L344:
.L345:
    movaps xmm0, xmm6
    jmp .__ret_341
.__ret_341:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get_real.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl103,445
    dq .kl104,452
    dq .kl105,455
.kfn: db "list_set_real", 0
section .text
section .data
__g_tx_wout: dq 0
section .text
section .data
__g_tx_hout: dq 0
section .text
section .data
__g_tx_ready: dq 0
section .text
section .bss
__g_tx_num: resq 8
section .text
section .data
__g_tx_ignore: dq 0
section .text
tx_new:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, 8
    add rax, rbx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
.kl106:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L348
    mov rax, 0
    jmp .__ret_347
    jmp .L349
.L348:
.L349:
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl107:
    call ob_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L350
    mov rcx, r12
    sub rsp, 32
.kl108:
    call hp_release
    add rsp, 32
    jmp .L351
.L350:
.L351:
    mov rax, rbx
    jmp .__ret_347
.__ret_347:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_set_real.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl106,69
    dq .kl107,73
    dq .kl108,75
.kfn: db "tx_new", 0
section .text
tx_room:
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
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl109:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L353
    mov rax, 0
    jmp .__ret_352
    jmp .L354
.L353:
.L354:
    mov rcx, rbx
    sub rsp, 32
.kl110:
    call hp_room
    add rsp, 32
    push rax
    mov rax, 8
    add rax, r12
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L355
    mov rax, rbx
    jmp .__ret_352
    jmp .L356
.L355:
.L356:
    mov rax, rbx
    push rax
    mov rax, 8
    add rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl111:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L357
    mov rax, 0
    jmp .__ret_352
    jmp .L358
.L357:
.L358:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl112:
    call ob_put
    add rsp, 32
    mov rax, rbx
    jmp .__ret_352
.__ret_352:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_new.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl109,82
    dq .kl110,86
    dq .kl111,89
    dq .kl112,93
.kfn: db "tx_room", 0
section .text
tx_add_bytes:
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
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl113:
    call ob_get
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L360
    mov rax, 0
    jmp .__ret_359
    jmp .L361
.L360:
.L361:
    mov rax, 0
    mov r12, rax
    mov rax, r13
    mov rax, [rax]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r15, r13
    jl .L362
    mov rax, r15
    push rax
    mov rax, r13
    add rax, 8
    add rax, r12
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L364
    mov rax, r15
    sub rax, r13
    mov rbx, rax
    jmp .L365
.L364:
.L365:
    jmp .L363
.L362:
.L363:
    mov rax, [rbp-8]
    push rax
    mov rax, r12
    add rax, r14
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl114:
    call tx_room
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L366
    mov rax, 0
    jmp .__ret_359
    jmp .L367
.L366:
.L367:
    mov rax, r15
    mov r15, rax
    cmp rbx, 0
    je .L368
    mov rax, r13
    add rax, rbx
    mov r15, rax
    jmp .L369
.L368:
.L369:
    mov rax, r13
    add rax, 8
    add rax, r12
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r14
    sub rsp, 32
.kl115:
    call hp_copy
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, r12
    add rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 8
    add rax, r12
    add rax, r14
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-8]
    jmp .__ret_359
.__ret_359:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_room.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl113,99
    dq .kl114,111
    dq .kl115,119
.kfn: db "tx_add_bytes", 0
section .text
tx_add:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, rbx
    sub rsp, 32
.kl116:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L371
    mov rax, 0
    jmp .__ret_370
    jmp .L372
.L371:
.L372:
    mov rax, r12
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_tv_n]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl117:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_370
.__ret_370:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_bytes.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl116,128
    dq .kl117,131
.kfn: db "tx_add", 0
section .text
tx_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, r13
    sub rsp, 32
.kl118:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L374
    mov rax, 0
    jmp .__ret_373
    jmp .L375
.L374:
.L375:
    mov rax, [rel __g_tv_n]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
.kl119:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L376
    mov rax, 0
    jmp .__ret_373
    jmp .L377
.L376:
.L377:
    mov rcx, r13
    sub rsp, 32
.kl120:
    call tv_view
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
.kl121:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_373
.__ret_373:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl118,135
    dq .kl119,139
    dq .kl120,143
    dq .kl121,144
.kfn: db "tx_copy", 0
section .text
tx_from_bytes:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rcx, r12
    sub rsp, 32
.kl122:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L379
    mov rax, 0
    jmp .__ret_378
    jmp .L380
.L379:
.L380:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
.kl123:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_378
.__ret_378:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_copy.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl122,148
    dq .kl123,152
.kfn: db "tx_from_bytes", 0
section .text
tx_add_char:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
    lea rax, [rbp-24]
    mov rbx, rax
    cmp r12, 128
    jge .L382
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov rbx, rax
    jmp .L383
.L382:
    cmp r12, 2048
    jge .L384
    mov rax, rbx
    push rax
    mov rax, 192
    push rax
    mov rax, r12
    mov rcx, 6
    sar rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, 128
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 2
    mov rbx, rax
    jmp .L385
.L384:
    cmp r12, 65536
    jge .L386
    mov rax, rbx
    push rax
    mov rax, 224
    push rax
    mov rax, r12
    mov rcx, 12
    sar rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, 128
    push rax
    mov rax, r12
    mov rcx, 6
    sar rax, cl
    and rax, 63
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, 128
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 3
    mov rbx, rax
    jmp .L387
.L386:
    mov rax, rbx
    push rax
    mov rax, 240
    push rax
    mov rax, r12
    mov rcx, 18
    sar rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, 128
    push rax
    mov rax, r12
    mov rcx, 12
    sar rax, cl
    and rax, 63
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, 128
    push rax
    mov rax, r12
    mov rcx, 6
    sar rax, cl
    and rax, 63
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 3
    push rax
    mov rax, 128
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 4
    mov rbx, rax
.L387:
.L385:
.L383:
    mov rax, r13
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl124:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_381
.__ret_381:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_from_bytes.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl124,181
.kfn: db "tx_add_char", 0
section .text
tx_add_int:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov rbx, rdx
    mov rax, rbx
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    lea rax, [rel __g_tx_num]
    mov r12, rax
    cmp r15, 0
    jge .L389
    mov rax, 1
    mov r14, rax
    jmp .L390
.L389:
.L390:
    cmp r15, 0
    jne .L391
    mov rax, r12
    add rax, 31
    push rax
    mov rax, 48
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov r13, rax
    jmp .L392
.L391:
.L392:
.L393:
    cmp r15, 0
    je .L394
    mov rax, r15
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rbx, rax
    cmp rbx, 0
    jge .L396
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L397
.L396:
.L397:
    mov rax, r12
    add rax, 31
    sub rax, r13
    push rax
    mov rax, 48
    add rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    mov rax, r15
    mov rcx, 10
    cqo
    idiv rcx
    mov r15, rax
.L395:
    jmp .L393
.L394:
    mov rax, r14
    test rax, rax
    jz .L398
    mov rax, r12
    add rax, 31
    sub rax, r13
    push rax
    mov rax, 45
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    jmp .L399
.L398:
.L399:
    mov rax, [rbp-8]
    push rax
    lea rax, [rel __g_tx_num]
    add rax, 32
    sub rax, r13
    push rax
    pop rdx
    pop rcx
    mov r8, r13
    sub rsp, 32
.kl125:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_388
.__ret_388:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_char.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl125,212
.kfn: db "tx_add_int", 0
section .text
tx_add_real:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    mov [rbp-192], rbx
    mov [rbp-184], r12
    mov [rbp-176], r13
    mov [rbp-168], r14
    mov [rbp-160], r15
    movups [rbp-152], xmm6
    movups [rbp-136], xmm7
    mov r15, rcx
    movaps xmm6, xmm1
    mov rbx, r8
    movaps xmm0, xmm6
    movaps xmm6, xmm0
    mov rax, rbx
    mov r14, rax
    cmp r14, 0
    jge .L401
    mov rax, 0
    mov r14, rax
    jmp .L402
.L401:
.L402:
    cmp r14, 15
    jle .L403
    mov rax, 15
    mov r14, rax
    jmp .L404
.L403:
.L404:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl126:
    call tx_is_nan
    add rsp, 32
    test rax, rax
    jz .L405
    mov rax, r15
    push rax
section .data
.str407: db 110,97,110,0
section .text
    lea rax, [rel .str407]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
.kl127:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_400
    jmp .L406
.L405:
.L406:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt410: dq 0.0
section .text
    movsd xmm0, [rel .flt410]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L408
    mov rax, r15
    push rax
section .data
.str413: db 45,0
section .text
    lea rax, [rel .str413]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl128:
    call tx_add_bytes
    add rsp, 32
    cmp rax, 0
    jne .L411
    mov rax, 0
    jmp .__ret_400
    jmp .L412
.L411:
.L412:
section .data
.flt414: dq 0.0
section .text
    movsd xmm0, [rel .flt414]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L409
.L408:
.L409:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt417: dq 9000000000000000000.0
section .text
    movsd xmm0, [rel .flt417]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L415
    mov rax, 0
    mov rbx, rax
.L418:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt421: dq 10.0
section .text
    movsd xmm0, [rel .flt421]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L419
section .data
.flt422: dq 10.0
section .text
    movsd xmm0, [rel .flt422]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    add rbx, 1
    cmp rbx, 400
    jle .L423
    mov rax, r15
    push rax
section .data
.str425: db 105,110,102,0
section .text
    lea rax, [rel .str425]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
.kl129:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_400
    jmp .L424
.L423:
.L424:
.L420:
    jmp .L418
.L419:
    mov rax, r15
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl130:
    call tx_add_real
    add rsp, 32
    mov rax, r15
    push rax
section .data
.str426: db 101,43,0
section .text
    lea rax, [rel .str426]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl131:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl132:
    call tx_add_int
    add rsp, 32
    jmp .__ret_400
    jmp .L416
.L415:
.L416:
section .data
.flt427: dq 1.0
section .text
    movsd xmm0, [rel .flt427]
    movaps xmm7, xmm0
    mov rax, 0
    mov rbx, rax
.L428:
    cmp rbx, r14
    jge .L429
section .data
.flt431: dq 10.0
section .text
    movsd xmm0, [rel .flt431]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
    add rbx, 1
.L430:
    jmp .L428
.L429:
    movaps xmm0, xmm6
    cvttsd2si rax, xmm0
    mov r12, rax
    mov rax, r12
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    subsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt432: dq 0.5
section .text
    movsd xmm0, [rel .flt432]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    cvttsd2si rax, xmm0
    mov r13, rax
    movaps xmm0, xmm7
    cvttsd2si rax, xmm0
    mov rbx, rax
    cmp r13, rbx
    jl .L433
    add r12, 1
    sub r13, rbx
    jmp .L434
.L433:
.L434:
    mov rcx, r15
    mov rdx, r12
    sub rsp, 32
.kl133:
    call tx_add_int
    add rsp, 32
    cmp rax, 0
    jne .L435
    mov rax, 0
    jmp .__ret_400
    jmp .L436
.L435:
.L436:
    cmp r14, 0
    jne .L437
    mov rax, r15
    jmp .__ret_400
    jmp .L438
.L437:
.L438:
    mov rax, r15
    push rax
section .data
.str439: db 46,0
section .text
    lea rax, [rel .str439]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl134:
    call tx_add_bytes
    add rsp, 32
    mov rax, 1
    mov r12, rax
    mov rax, r13
    mov rbx, rax
.L440:
    cmp rbx, 10
    jl .L441
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rbx, rax
    add r12, 1
.L442:
    jmp .L440
.L441:
.L443:
    cmp r12, r14
    jge .L444
    mov rax, r15
    push rax
section .data
.str446: db 48,0
section .text
    lea rax, [rel .str446]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl135:
    call tx_add_bytes
    add rsp, 32
    add r12, 1
.L445:
    jmp .L443
.L444:
    mov rcx, r15
    mov rdx, r13
    sub rsp, 32
.kl136:
    call tx_add_int
    add rsp, 32
    jmp .__ret_400
.__ret_400:
    mov rbx, [rbp-192]
    mov r12, [rbp-184]
    mov r13, [rbp-176]
    mov r14, [rbp-168]
    mov r15, [rbp-160]
    movups xmm6, [rbp-152]
    movups xmm7, [rbp-136]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_int.kft, .kfe, .kfn, __kron_file_2,11
    dq .kl126,224
    dq .kl127,225
    dq .kl128,228
    dq .kl129,240
    dq .kl130,243
    dq .kl131,244
    dq .kl132,245
    dq .kl133,261
    dq .kl134,267
    dq .kl135,276
    dq .kl136,279
.kfn: db "tx_add_real", 0
section .text
tx_is_nan:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
    movaps xmm0, xmm6
    movsd [rel __g_li_real], xmm0
    lea rax, [rel __g_li_real]
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 9218868437227405312
    and rax, rcx
    mov rcx, 9218868437227405312
    cmp rax, rcx
    je .L448
    mov rax, 0
    jmp .__ret_447
    jmp .L449
.L448:
.L449:
    mov rax, rbx
    mov rcx, 4503599627370495
    and rax, rcx
    cmp rax, 0
    jne .L450
    mov rax, 0
    jmp .__ret_447
    jmp .L451
.L450:
.L451:
    mov rax, 1
    jmp .__ret_447
.__ret_447:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
tx_find:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rcx, r13
    sub rsp, 32
.kl137:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L453
    mov rax, 1
    neg rax
    jmp .__ret_452
    jmp .L454
.L453:
.L454:
    mov rax, [rel __g_tv_p]
    mov [rbp-32], rax
    mov rax, [rel __g_tv_n]
    mov r15, rax
    mov rcx, r12
    sub rsp, 32
.kl138:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L455
    mov rax, 1
    neg rax
    jmp .__ret_452
    jmp .L456
.L455:
.L456:
    mov rax, [rel __g_tv_p]
    mov [rbp-48], rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, rbx
    mov r13, rax
    cmp r13, 0
    jge .L457
    mov rax, 0
    mov r13, rax
    jmp .L458
.L457:
.L458:
    mov rax, 1
    neg rax
    mov r12, rax
.L459:
    mov rax, r13
    add rax, r14
    cmp rax, r15
    jg .L460
    mov rax, 0
    mov rbx, rax
.L462:
    cmp rbx, r14
    jge .L463
    mov rax, [rbp-32]
    add rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, [rbp-48]
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L465
    mov rax, r14
    add rax, 1
    mov rbx, rax
    jmp .L466
.L465:
    add rbx, 1
.L466:
.L464:
    jmp .L462
.L463:
    cmp rbx, r14
    jne .L467
    mov rax, r13
    mov r12, rax
    mov rax, r15
    mov r13, rax
    jmp .L468
.L467:
.L468:
    add r13, 1
.L461:
    jmp .L459
.L460:
    mov rax, r12
    jmp .__ret_452
.__ret_452:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_real.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl137,300
    dq .kl138,305
.kfn: db "tx_find", 0
section .text
tx_part:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r14, rcx
    mov r12, rdx
    mov r15, r8
    mov rcx, r14
    sub rsp, 32
.kl139:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L470
    mov rax, 0
    jmp .__ret_469
    jmp .L471
.L470:
.L471:
    mov rax, [rel __g_tv_n]
    mov rbx, rax
    mov rax, r12
    mov r13, rax
    cmp r13, 0
    jge .L472
    mov rax, 0
    mov r13, rax
    jmp .L473
.L472:
.L473:
    cmp r13, rbx
    jle .L474
    mov rax, rbx
    mov r13, rax
    jmp .L475
.L474:
.L475:
    mov rax, r13
    add rax, r15
    mov r12, rax
    cmp r15, 0
    jge .L476
    mov rax, r13
    mov r12, rax
    jmp .L477
.L476:
.L477:
    cmp r12, rbx
    jle .L478
    mov rax, rbx
    mov r12, rax
    jmp .L479
.L478:
.L479:
    mov rax, r12
    sub rax, r13
    push rax
    pop rcx
    sub rsp, 32
.kl140:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L480
    mov rax, 0
    jmp .__ret_469
    jmp .L481
.L480:
.L481:
    mov rcx, r14
    sub rsp, 32
.kl141:
    call tv_view
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_p]
    add rax, r13
    push rax
    mov rax, r12
    sub rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl142:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_469
.__ret_469:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_find.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl139,336
    dq .kl140,354
    dq .kl141,358
    dq .kl142,359
.kfn: db "tx_part", 0
section .text
tx_split:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov rcx, 8
    sub rsp, 32
.kl143:
    call li_new
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L483
    mov rax, 0
    jmp .__ret_482
    jmp .L484
.L483:
.L484:
    mov rcx, [rbp-16]
    sub rsp, 32
.kl144:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L485
    mov rax, 0
    jmp .__ret_482
    jmp .L486
.L485:
.L486:
    mov rax, [rel __g_tv_n]
    mov [rbp-32], rax
    mov rcx, r15
    sub rsp, 32
.kl145:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L487
    mov rax, 0
    jmp .__ret_482
    jmp .L488
.L487:
.L488:
    mov rax, [rel __g_tv_n]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L489
.L491:
    cmp r12, r13
    jge .L492
    mov rax, r14
    push rax
    mov rcx, r15
    mov rdx, r12
    mov r8, 1
    sub rsp, 32
.kl146:
    call tx_part
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    add r12, 1
.L493:
    jmp .L491
.L492:
    mov rax, r14
    jmp .__ret_482
    jmp .L490
.L489:
.L490:
.L494:
    cmp r12, r13
    jg .L495
    mov rcx, r15
    mov rdx, [rbp-16]
    mov r8, r12
    sub rsp, 32
.kl147:
    call tx_find
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L497
    mov rax, r13
    mov rbx, rax
    jmp .L498
.L497:
.L498:
    mov rax, r14
    push rax
    mov rax, r15
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    sub rax, r12
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl148:
    call tx_part
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    mov rax, rbx
    mov rcx, [rbp-32]
    add rax, rcx
    mov r12, rax
    cmp rbx, r13
    jne .L499
    mov rax, r13
    add rax, 1
    mov r12, rax
    jmp .L500
.L499:
.L500:
.L496:
    jmp .L494
.L495:
    mov rax, r14
    jmp .__ret_482
.__ret_482:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_part.kft, .kfe, .kfn, __kron_file_2,6
    dq .kl143,364
    dq .kl144,368
    dq .kl145,372
    dq .kl146,380
    dq .kl147,386
    dq .kl148,390
.kfn: db "tx_split", 0
section .text
tx_out:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl149:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L502
    mov rax, 0
    jmp .__ret_501
    jmp .L503
.L502:
.L503:
    mov rax, [rel __g_tv_p]
    mov r15, rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, 1
    cmp rax, 2
    jne .L504
    mov rax, 0
    mov r12, rax
.L506:
    cmp r12, r14
    jge .L507
    mov rax, 1
    push rax
    mov rax, 1
    push rax
    mov rax, r15
    add rax, r12
    push rax
    mov rax, r14
    sub rax, r12
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl150:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jg .L509
    mov rax, r14
    mov r12, rax
    jmp .L510
.L509:
    add r12, rbx
.L510:
.L508:
    jmp .L506
.L507:
    jmp .L505
.L504:
    mov rax, [rel __g_tx_ready]
    cmp rax, 0
    jne .L511
section .data
.str513: db 107,101,114,110,101,108,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str513]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
section .data
.str514: db 71,101,116,83,116,100,72,97,110,100,108,101,0
section .text
    lea rax, [rel .str514]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov r12, rax
    mov rax, r13
    push rax
section .data
.str515: db 83,101,116,67,111,110,115,111,108,101,79,117,116,112,117,116,67,80,0
section .text
    lea rax, [rel .str515]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    push rax
section .data
.str516: db 87,114,105,116,101,70,105,108,101,0
section .text
    lea rax, [rel .str516]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_tx_wout], rax
    mov rax, r12
    push rax
    mov rax, 0
    sub rax, 11
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl151:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_tx_hout], rax
    mov rax, rbx
    push rax
    mov rax, 65001
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl152:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_tx_ignore], rax
    mov rax, 1
    mov [rel __g_tx_ready], rax
    jmp .L512
.L511:
.L512:
    cmp r14, 0
    jle .L517
    mov rax, [rel __g_tx_wout]
    push rax
    mov rax, [rel __g_tx_hout]
    push rax
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    lea rax, [rel __g_tx_num]
    push rax
    mov rax, 0
    push rax
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 48
    mov r10, [rax+0]
    mov [rsp+32], r10
    mov rcx, [rax+32]
    mov rdx, [rax+24]
    mov r8, [rax+16]
    mov r9, [rax+8]
    mov r11, [rax+40]
.kl153:
    call r11
    add rsp, 48
    pop rsp
    add rsp, 48
    mov [rel __g_tx_ignore], rax
    jmp .L518
.L517:
.L518:
.L505:
    mov rax, 1
    jmp .__ret_501
.__ret_501:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_split.kft, .kfe, .kfn, __kron_file_2,5
    dq .kl149,401
    dq .kl150,410
    dq .kl151,423
    dq .kl152,424
    dq .kl153,428
.kfn: db "tx_out", 0
section .text
tx_byte_upper:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 97
    jl .L520
    cmp rbx, 122
    jg .L522
    mov rax, rbx
    sub rax, 32
    jmp .__ret_519
    jmp .L523
.L522:
.L523:
    jmp .L521
.L520:
.L521:
    mov rax, rbx
    jmp .__ret_519
.__ret_519:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
tx_byte_lower:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 65
    jl .L525
    cmp rbx, 90
    jg .L527
    mov rax, rbx
    add rax, 32
    jmp .__ret_524
    jmp .L528
.L527:
.L528:
    jmp .L526
.L525:
.L526:
    mov rax, rbx
    jmp .__ret_524
.__ret_524:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
tx_map:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rcx, [rbp-8]
    sub rsp, 32
.kl154:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L530
    mov rax, 0
    jmp .__ret_529
    jmp .L531
.L530:
.L531:
    mov rax, [rel __g_tv_n]
    mov rbx, rax
    mov rax, 0
    mov r15, rax
    mov rax, rbx
    mov r14, rax
    mov rax, [rbp-16]
    cmp rax, 3
    jne .L532
    mov rax, [rel __g_tv_p]
    mov r12, rax
.L534:
    cmp r15, r14
    jge .L535
    mov rax, r12
    add rax, r15
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L543
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L543
    mov rax, 0
    jmp .L544
.L543:
    mov rax, 1
.L544:
    test rax, rax
    jnz .L541
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L541
    mov rax, 0
    jmp .L542
.L541:
    mov rax, 1
.L542:
    test rax, rax
    jnz .L539
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L539
    mov rax, 0
    jmp .L540
.L539:
    mov rax, 1
.L540:
    test rax, rax
    jz .L537
    add r15, 1
    jmp .L538
.L537:
    jmp .L535
.L538:
.L536:
    jmp .L534
.L535:
.L545:
    cmp r14, r15
    jle .L546
    mov rax, r12
    add rax, r14
    sub rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L554
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L554
    mov rax, 0
    jmp .L555
.L554:
    mov rax, 1
.L555:
    test rax, rax
    jnz .L552
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L552
    mov rax, 0
    jmp .L553
.L552:
    mov rax, 1
.L553:
    test rax, rax
    jnz .L550
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L550
    mov rax, 0
    jmp .L551
.L550:
    mov rax, 1
.L551:
    test rax, rax
    jz .L548
    sub r14, 1
    jmp .L549
.L548:
    jmp .L546
.L549:
.L547:
    jmp .L545
.L546:
    jmp .L533
.L532:
.L533:
    mov rax, r14
    sub rax, r15
    push rax
    pop rcx
    sub rsp, 32
.kl155:
    call tx_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L556
    mov rax, 0
    jmp .__ret_529
    jmp .L557
.L556:
.L557:
    mov rcx, [rbp-8]
    sub rsp, 32
.kl156:
    call tv_view
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_tv_p]
    add rax, r15
    push rax
    mov rax, r14
    sub rax, r15
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl157:
    call tx_add_bytes
    add rsp, 32
    mov rax, [rbp-16]
    cmp rax, 3
    jne .L558
    mov rax, r13
    jmp .__ret_529
    jmp .L559
.L558:
.L559:
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl158:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L560:
    mov rax, rbx
    push rax
    mov rax, r14
    sub rax, r15
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L561
    mov rax, r12
    add rax, 8
    add rax, rbx
    movzx rax, byte [rax]
    mov [rbp-96], rax
    mov rax, [rbp-16]
    cmp rax, 1
    jne .L563
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rcx, [rbp-96]
    sub rsp, 32
.kl159:
    call tx_byte_upper
    add rsp, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L564
.L563:
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rcx, [rbp-96]
    sub rsp, 32
.kl160:
    call tx_byte_lower
    add rsp, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cl
.L564:
    add rbx, 1
.L562:
    jmp .L560
.L561:
    mov rax, r13
    jmp .__ret_529
.__ret_529:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_out.kft, .kfe, .kfn, __kron_file_2,7
    dq .kl154,455
    dq .kl155,482
    dq .kl156,486
    dq .kl157,487
    dq .kl158,491
    dq .kl159,497
    dq .kl160,499
.kfn: db "tx_map", 0
section .text
section .data
__g_tx_ok: dq 0
section .text
section .data
__g_tx_real: dq 0
section .text
tx_parse:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov [rbp-176], r15
    movups [rbp-168], xmm6
    movups [rbp-152], xmm7
    mov r12, rcx
    mov rbx, rdx
    mov rax, 0
    mov [rel __g_tx_ok], rax
section .data
.flt566: dq 0.0
section .text
    movsd xmm0, [rel .flt566]
    movsd [rel __g_tx_real], xmm0
    mov rcx, r12
    sub rsp, 32
.kl161:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L567
    mov rax, 0
    jmp .__ret_565
    jmp .L568
.L567:
.L568:
    mov rax, [rel __g_tv_p]
    mov r15, rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
section .data
.flt569: dq 0.0
section .text
    movsd xmm0, [rel .flt569]
    movaps xmm7, xmm0
    mov rax, 0
    mov [rbp-72], rax
    mov rax, 0
    mov r12, rax
.L570:
    cmp r13, r14
    jge .L571
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L575
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L575
    mov rax, 0
    jmp .L576
.L575:
    mov rax, 1
.L576:
    test rax, rax
    jz .L573
    add r13, 1
    jmp .L574
.L573:
    jmp .L571
.L574:
.L572:
    jmp .L570
.L571:
    cmp r13, r14
    jge .L577
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    cmp r12, 45
    jne .L579
    mov rax, 1
    mov [rbp-48], rax
    add r13, 1
    jmp .L580
.L579:
    cmp r12, 43
    jne .L581
    add r13, 1
    jmp .L582
.L581:
.L582:
.L580:
    jmp .L578
.L577:
.L578:
.L583:
    cmp r13, r14
    jge .L584
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L588
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L588
    mov rax, 1
    jmp .L589
.L588:
    mov rax, 0
.L589:
    test rax, rax
    jz .L586
    mov rax, [rbp-56]
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, r12
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-56], rax
section .data
.flt590: dq 10.0
section .text
    movsd xmm0, [rel .flt590]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r12
    sub rax, 48
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm7, xmm0
    mov rax, [rbp-72]
    add rax, 1
    mov [rbp-72], rax
    add r13, 1
    jmp .L587
.L586:
    jmp .L584
.L587:
.L585:
    jmp .L583
.L584:
    mov rax, rbx
    test rax, rax
    jz .L591
    cmp r13, r14
    jge .L593
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    cmp rax, 46
    jne .L595
    add r13, 1
section .data
.flt597: dq 0.1
section .text
    movsd xmm0, [rel .flt597]
    movaps xmm6, xmm0
.L598:
    cmp r13, r14
    jge .L599
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L603
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L603
    mov rax, 1
    jmp .L604
.L603:
    mov rax, 0
.L604:
    test rax, rax
    jz .L601
    mov rax, r12
    sub rax, 48
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
section .data
.flt605: dq 10.0
section .text
    movsd xmm0, [rel .flt605]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, [rbp-72]
    add rax, 1
    mov [rbp-72], rax
    add r13, 1
    jmp .L602
.L601:
    jmp .L599
.L602:
.L600:
    jmp .L598
.L599:
    jmp .L596
.L595:
.L596:
    jmp .L594
.L593:
.L594:
    mov rax, [rbp-72]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L608
    mov rax, r13
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L608
    mov rax, 1
    jmp .L609
.L608:
    mov rax, 0
.L609:
    test rax, rax
    jz .L606
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    mov rcx, 101
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L612
    mov rax, r12
    mov rcx, 69
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L612
    mov rax, 0
    jmp .L613
.L612:
    mov rax, 1
.L613:
    test rax, rax
    jz .L610
    mov rax, r13
    add rax, 1
    mov rbx, rax
    mov rax, 0
    mov [rbp-104], rax
    mov rax, 0
    mov [rbp-112], rax
    mov rax, 0
    mov [rbp-120], rax
    cmp rbx, r14
    jge .L614
    mov rax, r15
    add rax, rbx
    movzx rax, byte [rax]
    mov r12, rax
    cmp r12, 45
    jne .L616
    mov rax, 1
    mov [rbp-104], rax
    add rbx, 1
    jmp .L617
.L616:
    cmp r12, 43
    jne .L618
    add rbx, 1
    jmp .L619
.L618:
.L619:
.L617:
    jmp .L615
.L614:
.L615:
.L620:
    cmp rbx, r14
    jge .L621
    mov rax, r15
    add rax, rbx
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L625
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L625
    mov rax, 1
    jmp .L626
.L625:
    mov rax, 0
.L626:
    test rax, rax
    jz .L623
    mov rax, [rbp-112]
    cmp rax, 10000
    jge .L627
    mov rax, [rbp-112]
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, r12
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-112], rax
    jmp .L628
.L627:
.L628:
    mov rax, [rbp-120]
    add rax, 1
    mov [rbp-120], rax
    add rbx, 1
    jmp .L624
.L623:
    jmp .L621
.L624:
.L622:
    jmp .L620
.L621:
    mov rax, [rbp-120]
    cmp rax, 0
    jle .L629
    mov rax, rbx
    mov r13, rax
.L631:
    mov rax, [rbp-112]
    cmp rax, 0
    jle .L632
    mov rax, [rbp-104]
    test rax, rax
    jz .L634
section .data
.flt636: dq 10.0
section .text
    movsd xmm0, [rel .flt636]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    divsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L635
.L634:
section .data
.flt637: dq 10.0
section .text
    movsd xmm0, [rel .flt637]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
.L635:
    mov rax, [rbp-112]
    sub rax, 1
    mov [rbp-112], rax
.L633:
    jmp .L631
.L632:
    jmp .L630
.L629:
.L630:
    jmp .L611
.L610:
.L611:
    jmp .L607
.L606:
.L607:
    jmp .L592
.L591:
.L592:
.L638:
    cmp r13, r14
    jge .L639
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L647
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L647
    mov rax, 0
    jmp .L648
.L647:
    mov rax, 1
.L648:
    test rax, rax
    jnz .L645
    mov rax, r12
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L645
    mov rax, 0
    jmp .L646
.L645:
    mov rax, 1
.L646:
    test rax, rax
    jnz .L643
    mov rax, r12
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L643
    mov rax, 0
    jmp .L644
.L643:
    mov rax, 1
.L644:
    test rax, rax
    jz .L641
    add r13, 1
    jmp .L642
.L641:
    jmp .L639
.L642:
.L640:
    jmp .L638
.L639:
    mov rax, [rbp-72]
    cmp rax, 0
    jle .L649
    cmp r13, r14
    jne .L651
    mov rax, 1
    mov [rel __g_tx_ok], rax
    jmp .L652
.L651:
.L652:
    jmp .L650
.L649:
.L650:
    mov rax, [rbp-48]
    test rax, rax
    jz .L653
    mov rax, 0
    mov rcx, [rbp-56]
    sub rax, rcx
    mov [rbp-56], rax
section .data
.flt655: dq 0.0
section .text
    movsd xmm0, [rel .flt655]
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L654
.L653:
.L654:
    movaps xmm0, xmm7
    movsd [rel __g_tx_real], xmm0
    mov rax, [rbp-56]
    jmp .__ret_565
.__ret_565:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov r15, [rbp-176]
    movups xmm6, [rbp-168]
    movups xmm7, [rbp-152]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_map.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl161,514
.kfn: db "tx_parse", 0
section .text
text_end:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    sub rsp, 32
.kl162:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L657
    mov rcx, rbx
    sub rsp, 32
.kl163:
    call heap_fail
    add rsp, 32
    jmp .__ret_656
    jmp .L658
.L657:
.L658:
    mov rax, r12
    jmp .__ret_656
.__ret_656:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_parse.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl162,639
    dq .kl163,642
.kfn: db "text_end", 0
section .text
text:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl164:
    call tx_copy
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_659
.__ret_659:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_end.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl164,649
.kfn: db "text", 0
section .text
text_new:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 15
    sub rsp, 32
.kl165:
    call tx_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_660
.__ret_660:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl165,654
.kfn: db "text_new", 0
section .text
text_free:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl166:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L662
    mov rcx, r12
    sub rsp, 32
.kl167:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl168:
    call hp_release
    add rsp, 32
    jmp .L663
.L662:
.L663:
    mov rcx, 0
    sub rsp, 32
.kl169:
    call text_end
    add rsp, 32
    jmp .__ret_661
.__ret_661:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_new.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl166,659
    dq .kl167,661
    dq .kl168,662
    dq .kl169,664
.kfn: db "text_free", 0
section .text
text_from_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 20
    sub rsp, 32
.kl170:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L665
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl171:
    call tx_add_int
    add rsp, 32
    jmp .L666
.L665:
.L666:
    mov rcx, rbx
    sub rsp, 32
.kl172:
    call text_end
    add rsp, 32
    jmp .__ret_664
.__ret_664:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_free.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl170,669
    dq .kl171,671
    dq .kl172,673
.kfn: db "text_from_int", 0
section .text
text_from_real:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
    movaps xmm6, xmm0
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 24
    sub rsp, 32
.kl173:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L668
    cmp r12, 0
    jge .L670
    mov rax, rbx
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl174:
    call tx_add_real_short
    add rsp, 32
    jmp .L671
.L670:
    mov rax, rbx
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, r12
    sub rsp, 32
.kl175:
    call tx_add_real
    add rsp, 32
.L671:
    jmp .L669
.L668:
.L669:
    mov rcx, rbx
    sub rsp, 32
.kl176:
    call text_end
    add rsp, 32
    jmp .__ret_667
.__ret_667:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_from_int.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl173,678
    dq .kl174,681
    dq .kl175,683
    dq .kl176,686
.kfn: db "text_from_real", 0
section .text
text_char:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
.kl177:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L673
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl178:
    call tx_add_char
    add rsp, 32
    jmp .L674
.L673:
.L674:
    mov rcx, rbx
    sub rsp, 32
.kl179:
    call text_end
    add rsp, 32
    jmp .__ret_672
.__ret_672:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_from_real.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl177,691
    dq .kl178,693
    dq .kl179,695
.kfn: db "text_char", 0
section .text
text_from_bytes:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jge .L676
    mov rax, 1
    mov [rel __g_hp_err], rax
    jmp .L677
.L676:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl180:
    call tx_from_bytes
    add rsp, 32
    mov rbx, rax
.L677:
    mov rcx, rbx
    sub rsp, 32
.kl181:
    call text_end
    add rsp, 32
    jmp .__ret_675
.__ret_675:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_char.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl180,704
    dq .kl181,706
.kfn: db "text_from_bytes", 0
section .text
text_add:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl182:
    call tx_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_678
.__ret_678:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_from_bytes.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl182,711
.kfn: db "text_add", 0
section .text
text_add_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl183:
    call tx_add_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_679
.__ret_679:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl183,716
.kfn: db "text_add_int", 0
section .text
text_add_real:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
    mov r12, rcx
    movaps xmm6, xmm1
    mov rbx, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    cmp rbx, 0
    jge .L681
    mov rax, r12
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl184:
    call tx_add_real_short
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_680
    jmp .L682
.L681:
.L682:
    mov rax, r12
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl185:
    call tx_add_real
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_680
.__ret_680:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add_int.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl184,722
    dq .kl185,724
.kfn: db "text_add_real", 0
section .text
text_add_char:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl186:
    call tx_add_char
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_683
.__ret_683:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add_real.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl186,729
.kfn: db "text_add_char", 0
section .text
text_clear:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl187:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L685
    mov rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L686
.L685:
.L686:
    mov rcx, r12
    sub rsp, 32
.kl188:
    call text_end
    add rsp, 32
    jmp .__ret_684
.__ret_684:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add_char.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl187,734
    dq .kl188,741
.kfn: db "text_clear", 0
section .text
text_len:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
.kl189:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L688
    mov rax, [rel __g_tv_n]
    mov rbx, rax
    jmp .L689
.L688:
.L689:
    mov rcx, rbx
    sub rsp, 32
.kl190:
    call text_end
    add rsp, 32
    jmp .__ret_687
.__ret_687:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_clear.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl189,747
    dq .kl190,750
.kfn: db "text_len", 0
section .text
text_at:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
.kl191:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L691
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L695
    mov rax, r12
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L695
    mov rax, 0
    jmp .L696
.L695:
    mov rax, 1
.L696:
    test rax, rax
    jz .L693
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L694
.L693:
    mov rax, [rel __g_tv_p]
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L694:
    jmp .L692
.L691:
.L692:
    mov rcx, rbx
    sub rsp, 32
.kl192:
    call text_end
    add rsp, 32
    jmp .__ret_690
.__ret_690:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_len.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl191,756
    dq .kl192,763
.kfn: db "text_at", 0
section .text
text_set_at:
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
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl193:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L698
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L702
    mov rax, r14
    mov rcx, rbx
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L702
    mov rax, 0
    jmp .L703
.L702:
    mov rax, 1
.L703:
    test rax, rax
    jz .L700
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L701
.L700:
    mov rax, r12
    add rax, 8
    add rax, r14
    push rax
    mov rax, r13
    and rax, 255
    mov rcx, rax
    pop rdx
    mov [rdx], cl
.L701:
    jmp .L699
.L698:
.L699:
    mov rcx, r15
    sub rsp, 32
.kl194:
    call text_end
    add rsp, 32
    jmp .__ret_697
.__ret_697:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_at.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl193,768
    dq .kl194,778
.kfn: db "text_set_at", 0
section .text
text_same:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl195:
    call tv_compare
    add rsp, 32
    cmp rax, 0
    jne .L705
    mov rax, 1
    mov rbx, rax
    jmp .L706
.L705:
.L706:
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    je .L707
    mov rax, 0
    mov rbx, rax
    jmp .L708
.L707:
.L708:
    mov rcx, rbx
    sub rsp, 32
.kl196:
    call text_end
    add rsp, 32
    jmp .__ret_704
.__ret_704:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_set_at.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl195,784
    dq .kl196,790
.kfn: db "text_same", 0
section .text
text_compare:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl197:
    call tv_compare
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_709
.__ret_709:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_same.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl197,795
.kfn: db "text_compare", 0
section .text
text_find:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
.kl198:
    call tx_find
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_710
.__ret_710:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_compare.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl198,800
.kfn: db "text_find", 0
section .text
text_find_after:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl199:
    call tx_find
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_711
.__ret_711:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_find.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl199,805
.kfn: db "text_find_after", 0
section .text
text_contains:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    mov rdx, r12
    mov r8, 0
    sub rsp, 32
.kl200:
    call tx_find
    add rsp, 32
    cmp rax, 0
    jl .L713
    mov rax, 1
    mov rbx, rax
    jmp .L714
.L713:
.L714:
    mov rcx, rbx
    sub rsp, 32
.kl201:
    call text_end
    add rsp, 32
    jmp .__ret_712
.__ret_712:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_find_after.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl200,811
    dq .kl201,814
.kfn: db "text_contains", 0
section .text
text_count:
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
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
.kl202:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L716
    mov rax, [rel __g_tv_n]
    mov r12, rax
    jmp .L717
.L716:
.L717:
    cmp r12, 0
    jle .L718
    mov rcx, r15
    mov rdx, r14
    mov r8, 0
    sub rsp, 32
.kl203:
    call tx_find
    add rsp, 32
    mov rbx, rax
.L720:
    cmp rbx, 0
    jl .L721
    add r13, 1
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    mov rax, rbx
    add rax, r12
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl204:
    call tx_find
    add rsp, 32
    mov rbx, rax
.L722:
    jmp .L720
.L721:
    jmp .L719
.L718:
.L719:
    mov rcx, r13
    sub rsp, 32
.kl205:
    call text_end
    add rsp, 32
    jmp .__ret_715
.__ret_715:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_contains.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl202,821
    dq .kl203,825
    dq .kl204,828
    dq .kl205,831
.kfn: db "text_count", 0
section .text
text_starts:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r14, rax
    mov rcx, rbx
    sub rsp, 32
.kl206:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L724
    mov rax, [rel __g_tv_n]
    mov r13, rax
    mov rax, [rel __g_tv_p]
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
.kl207:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L726
    mov rax, r13
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jg .L728
    mov rax, 1
    mov r14, rax
    mov rax, 0
    mov rbx, rax
.L730:
    cmp rbx, r13
    jge .L731
    mov rax, [rel __g_tv_p]
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L733
    mov rax, 0
    mov r14, rax
    mov rax, r13
    mov rbx, rax
    jmp .L734
.L733:
.L734:
    add rbx, 1
.L732:
    jmp .L730
.L731:
    jmp .L729
.L728:
.L729:
    jmp .L727
.L726:
.L727:
    jmp .L725
.L724:
.L725:
    mov rcx, r14
    sub rsp, 32
.kl208:
    call text_end
    add rsp, 32
    jmp .__ret_723
.__ret_723:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_count.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl206,837
    dq .kl207,840
    dq .kl208,856
.kfn: db "text_starts", 0
section .text
text_ends:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
.kl209:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L736
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, [rel __g_tv_p]
    mov r13, rax
    mov rcx, r12
    sub rsp, 32
.kl210:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L738
    mov rax, r14
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jg .L740
    mov rax, 1
    mov r15, rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, r14
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L742:
    cmp rbx, r14
    jge .L743
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L745
    mov rax, 0
    mov r15, rax
    mov rax, r14
    mov rbx, rax
    jmp .L746
.L745:
.L746:
    add rbx, 1
.L744:
    jmp .L742
.L743:
    jmp .L741
.L740:
.L741:
    jmp .L739
.L738:
.L739:
    jmp .L737
.L736:
.L737:
    mov rcx, r15
    sub rsp, 32
.kl211:
    call text_end
    add rsp, 32
    jmp .__ret_735
.__ret_735:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_starts.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl209,862
    dq .kl210,865
    dq .kl211,882
.kfn: db "text_ends", 0
section .text
text_to_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl212:
    call tx_parse
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L748
    mov rax, [rel __g_tx_ok]
    cmp rax, 0
    jne .L750
    mov rax, 7
    mov [rel __g_hp_err], rax
    mov rax, 0
    mov rbx, rax
    jmp .L751
.L750:
.L751:
    jmp .L749
.L748:
.L749:
    mov rcx, rbx
    sub rsp, 32
.kl213:
    call text_end
    add rsp, 32
    jmp .__ret_747
.__ret_747:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_ends.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl212,887
    dq .kl213,894
.kfn: db "text_to_int", 0
section .text
text_to_real:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    movups [rbp-56], xmm6
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl214:
    call tx_parse
    add rsp, 32
    movsd xmm0, [rel __g_tx_real]
    movaps xmm6, xmm0
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L753
    mov rax, [rel __g_tx_ok]
    cmp rax, 0
    jne .L755
    mov rax, 7
    mov [rel __g_hp_err], rax
section .data
.flt757: dq 0.0
section .text
    movsd xmm0, [rel .flt757]
    movaps xmm6, xmm0
    jmp .L756
.L755:
.L756:
    jmp .L754
.L753:
.L754:
    sub rsp, 32
.kl215:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L758
    mov rcx, rbx
    sub rsp, 32
.kl216:
    call heap_fail
    add rsp, 32
section .data
.flt760: dq 0.0
section .text
    movsd xmm0, [rel .flt760]
    jmp .__ret_752
    jmp .L759
.L758:
.L759:
    movaps xmm0, xmm6
    jmp .__ret_752
.__ret_752:
    mov rbx, [rbp-64]
    movups xmm6, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_to_int.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl214,899
    dq .kl215,907
    dq .kl216,910
.kfn: db "text_to_real", 0
section .text
text_is_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl217:
    call tx_parse
    add rsp, 32
    mov rax, [rel __g_tx_ok]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl218:
    call text_end
    add rsp, 32
    jmp .__ret_761
.__ret_761:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_to_real.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl217,918
    dq .kl218,920
.kfn: db "text_is_int", 0
section .text
text_is_real:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl219:
    call tx_parse
    add rsp, 32
    mov rax, [rel __g_tx_ok]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl220:
    call text_end
    add rsp, 32
    jmp .__ret_762
.__ret_762:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_is_int.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl219,925
    dq .kl220,927
.kfn: db "text_is_real", 0
section .text
text_hash:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 3750763034362895579
    neg rax
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
.kl221:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L764
    mov rax, 0
    mov rbx, rax
.L766:
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L767
    mov rax, r12
    push rax
    mov rax, [rel __g_tv_p]
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rcx, 1099511628211
    imul rax, rcx
    mov r12, rax
    add rbx, 1
.L768:
    jmp .L766
.L767:
    jmp .L765
.L764:
.L765:
    mov rcx, r12
    sub rsp, 32
.kl222:
    call text_end
    add rsp, 32
    jmp .__ret_763
.__ret_763:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_is_real.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl221,934
    dq .kl222,943
.kfn: db "text_hash", 0
section .text
text_part:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl223:
    call tx_part
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_769
.__ret_769:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_hash.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl223,948
.kfn: db "text_part", 0
section .text
text_upper:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl224:
    call tx_map
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_770
.__ret_770:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_part.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl224,953
.kfn: db "text_upper", 0
section .text
text_lower:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
.kl225:
    call tx_map
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_771
.__ret_771:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_upper.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl225,958
.kfn: db "text_lower", 0
section .text
text_trim:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 3
    sub rsp, 32
.kl226:
    call tx_map
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_772
.__ret_772:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_lower.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl226,963
.kfn: db "text_trim", 0
section .text
text_replace:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
.kl227:
    call tx_new
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov [rbp-40], rax
    cmp r14, 0
    je .L774
    mov rcx, [rbp-16]
    sub rsp, 32
.kl228:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L776
    mov rax, [rel __g_tv_n]
    mov [rbp-40], rax
    jmp .L777
.L776:
.L777:
    jmp .L775
.L774:
.L775:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L780
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L780
    mov rax, 1
    jmp .L781
.L780:
    mov rax, 0
.L781:
    test rax, rax
    jz .L778
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L782
    mov rcx, r14
    mov rdx, r15
    sub rsp, 32
.kl229:
    call tx_add
    add rsp, 32
    jmp .L783
.L782:
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
.kl230:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L784
    mov rax, [rel __g_tv_n]
    mov r12, rax
    jmp .L785
.L784:
.L785:
.L786:
    mov rax, r13
    mov rcx, r12
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L789
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L789
    mov rax, 1
    jmp .L790
.L789:
    mov rax, 0
.L790:
    test rax, rax
    jz .L787
    mov rcx, r15
    mov rdx, [rbp-16]
    mov r8, r13
    sub rsp, 32
.kl231:
    call tx_find
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L791
    mov rcx, r15
    sub rsp, 32
.kl232:
    call tv_view
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_tv_p]
    add rax, r13
    push rax
    mov rax, r12
    sub rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl233:
    call tx_add_bytes
    add rsp, 32
    mov rax, r12
    add rax, 1
    mov r13, rax
    jmp .L792
.L791:
    mov rcx, r15
    sub rsp, 32
.kl234:
    call tv_view
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_tv_p]
    add rax, r13
    push rax
    mov rax, rbx
    sub rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl235:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r14
    mov rdx, [rbp-24]
    sub rsp, 32
.kl236:
    call tx_add
    add rsp, 32
    mov rax, rbx
    mov rcx, [rbp-40]
    add rax, rcx
    mov r13, rax
.L792:
.L788:
    jmp .L786
.L787:
.L783:
    jmp .L779
.L778:
.L779:
    mov rcx, r14
    sub rsp, 32
.kl237:
    call text_end
    add rsp, 32
    jmp .__ret_773
.__ret_773:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_trim.kft, .kfe, .kfn, __kron_file_2,11
    dq .kl227,968
    dq .kl228,971
    dq .kl229,977
    dq .kl230,981
    dq .kl231,985
    dq .kl232,987
    dq .kl233,988
    dq .kl234,991
    dq .kl235,992
    dq .kl236,993
    dq .kl237,999
.kfn: db "text_replace", 0
section .text
text_repeat:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
.kl238:
    call tx_new
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L794:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L799
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L799
    mov rax, 1
    jmp .L800
.L799:
    mov rax, 0
.L800:
    test rax, rax
    jz .L797
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L797
    mov rax, 1
    jmp .L798
.L797:
    mov rax, 0
.L798:
    test rax, rax
    jz .L795
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
.kl239:
    call tx_add
    add rsp, 32
    add rbx, 1
.L796:
    jmp .L794
.L795:
    mov rcx, r12
    sub rsp, 32
.kl240:
    call text_end
    add rsp, 32
    jmp .__ret_793
.__ret_793:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_replace.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl238,1004
    dq .kl239,1007
    dq .kl240,1010
.kfn: db "text_repeat", 0
section .text
text_split:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl241:
    call tx_split
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_801
.__ret_801:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_repeat.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl241,1015
.kfn: db "text_split", 0
section .text
text_lines:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str803: db 10,0
section .text
    lea rax, [rel .str803]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl242:
    call tx_split
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    je .L804
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl243:
    call ob_get
    add rsp, 32
    mov [rbp-24], rax
    mov rax, 0
    mov r14, rax
    mov rax, [rbp-24]
    mov rax, [rax]
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L806:
    cmp r13, r14
    jge .L807
    mov rcx, r15
    mov rdx, r13
    sub rsp, 32
.kl244:
    call li_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl245:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp rbx, 0
    jle .L809
    mov rax, r12
    add rax, 8
    add rax, rbx
    sub rax, 1
    movzx rax, byte [rax]
    cmp rax, 13
    jne .L811
    mov rax, r12
    push rax
    mov rax, rbx
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    add rax, 8
    add rax, rbx
    sub rax, 1
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L812
.L811:
.L812:
    jmp .L810
.L809:
.L810:
    add r13, 1
.L808:
    jmp .L806
.L807:
    cmp r14, 0
    jle .L813
    mov rax, r15
    push rax
    mov rax, r14
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl246:
    call li_get
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl247:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp rbx, 0
    jne .L815
    mov rcx, r13
    sub rsp, 32
.kl248:
    call ob_drop
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl249:
    call hp_release
    add rsp, 32
    mov rax, [rbp-24]
    push rax
    mov rax, r14
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L816
.L815:
.L816:
    jmp .L814
.L813:
.L814:
    jmp .L805
.L804:
.L805:
    mov rcx, r15
    sub rsp, 32
.kl250:
    call text_end
    add rsp, 32
    jmp .__ret_802
.__ret_802:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_split.kft, .kfe, .kfn, __kron_file_2,9
    dq .kl242,1020
    dq .kl243,1023
    dq .kl244,1028
    dq .kl245,1029
    dq .kl246,1042
    dq .kl247,1043
    dq .kl248,1047
    dq .kl249,1048
    dq .kl250,1053
.kfn: db "text_lines", 0
section .text
text_join:
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
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
.kl251:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L818
    mov rcx, 16
    sub rsp, 32
.kl252:
    call tx_new
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L820:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L825
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L825
    mov rax, 1
    jmp .L826
.L825:
    mov rax, 0
.L826:
    test rax, rax
    jz .L823
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L823
    mov rax, 1
    jmp .L824
.L823:
    mov rax, 0
.L824:
    test rax, rax
    jz .L821
    cmp rbx, 0
    jle .L827
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
.kl253:
    call tx_add
    add rsp, 32
    jmp .L828
.L827:
.L828:
    mov rax, r12
    push rax
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl254:
    call li_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tx_add
    add rsp, 32
    add rbx, 1
.L822:
    jmp .L820
.L821:
    jmp .L819
.L818:
.L819:
    mov rcx, r12
    sub rsp, 32
.kl255:
    call text_end
    add rsp, 32
    jmp .__ret_817
.__ret_817:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_lines.kft, .kfe, .kfn, __kron_file_2,5
    dq .kl251,1058
    dq .kl252,1061
    dq .kl253,1065
    dq .kl254,1067
    dq .kl255,1071
.kfn: db "text_join", 0
section .text
text_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl256:
    call li_sort
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_829
.__ret_829:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_join.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl256,1076
.kfn: db "text_sort", 0
section .text
say:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl257:
    call tx_out
    add rsp, 32
section .data
.str831: db 10,0
section .text
    lea rax, [rel .str831]
    push rax
    pop rcx
    sub rsp, 32
.kl258:
    call tx_out
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl259:
    call text_end
    add rsp, 32
    jmp .__ret_830
.__ret_830:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_sort.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl257,1081
    dq .kl258,1082
    dq .kl259,1083
.kfn: db "say", 0
section .text
tx_add_real_short:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    movups [rbp-88], xmm6
    mov r15, rcx
    movaps xmm6, xmm1
    mov rax, r15
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 6
    sub rsp, 32
.kl260:
    call tx_add_real
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl261:
    call ob_get
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L833
    mov rax, 0
    jmp .__ret_832
    jmp .L834
.L833:
.L834:
    mov rax, 0
    mov r13, rax
    mov rax, r14
    mov rax, [rax]
    mov r13, rax
    mov rax, 1
    neg rax
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L835:
    cmp rbx, r13
    jge .L836
    mov rax, 0
    mov [rbp-56], rax
    mov rax, r14
    add rax, 8
    add rax, rbx
    movzx rax, byte [rax]
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 46
    jne .L838
    mov rax, rbx
    mov r12, rax
    jmp .L839
.L838:
.L839:
    add rbx, 1
.L837:
    jmp .L835
.L836:
    cmp r12, 0
    jge .L840
    mov rax, r15
    jmp .__ret_832
    jmp .L841
.L840:
.L841:
.L842:
    mov rax, r13
    push rax
    mov rax, r12
    add rax, 2
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L843
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    add rax, 8
    add rax, r13
    sub rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    cmp rbx, 48
    je .L845
    jmp .L843
    jmp .L846
.L845:
.L846:
    sub r13, 1
.L844:
    jmp .L842
.L843:
    mov rax, r14
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    add rax, r13
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r15
    jmp .__ret_832
.__ret_832:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    movups xmm6, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq say.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl260,1093
    dq .kl261,1094
.kfn: db "tx_add_real_short", 0
section .text
tx_drop:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl262:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L848
    mov rcx, r12
    sub rsp, 32
.kl263:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl264:
    call hp_release
    add rsp, 32
    jmp .L849
.L848:
.L849:
    mov rax, 0
    jmp .__ret_847
.__ret_847:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_real_short.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl262,1130
    dq .kl263,1132
    dq .kl264,1133
.kfn: db "tx_drop", 0
section .text
tx_show_value:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    movups [rbp-56], xmm6
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    cmp rbx, 1
    jne .L851
    mov rax, r13
    push rax
section .data
.str853: db 34,0
section .text
    lea rax, [rel .str853]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl265:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl266:
    call tx_add
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str854: db 34,0
section .text
    lea rax, [rel .str854]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl267:
    call tx_add_bytes
    add rsp, 32
    mov rax, r13
    jmp .__ret_850
    jmp .L852
.L851:
.L852:
    cmp rbx, 2
    jne .L855
section .data
.flt857: dq 0.0
section .text
    movsd xmm0, [rel .flt857]
    movaps xmm6, xmm0
    lea rax, [rel __g_li_real]
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    movsd xmm0, [rel __g_li_real]
    movaps xmm6, xmm0
    mov rax, r13
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl268:
    call tx_add_real_short
    add rsp, 32
    jmp .__ret_850
    jmp .L856
.L855:
.L856:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl269:
    call tx_add_int
    add rsp, 32
    jmp .__ret_850
.__ret_850:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    movups xmm6, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_drop.kft, .kfe, .kfn, __kron_file_2,5
    dq .kl265,1140
    dq .kl266,1141
    dq .kl267,1142
    dq .kl268,1151
    dq .kl269,1153
.kfn: db "tx_show_value", 0
section .text
list_show:
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
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 64
    sub rsp, 32
.kl270:
    call tx_new
    add rsp, 32
    mov r13, rax
    mov rcx, r15
    sub rsp, 32
.kl271:
    call li_len
    add rsp, 32
    mov r12, rax
    mov rax, r13
    push rax
section .data
.str859: db 91,0
section .text
    lea rax, [rel .str859]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl272:
    call tx_add_bytes
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L860:
    cmp rbx, r12
    jge .L861
    cmp rbx, 0
    jle .L863
    mov rax, r13
    push rax
section .data
.str865: db 44,32,0
section .text
    lea rax, [rel .str865]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl273:
    call tx_add_bytes
    add rsp, 32
    jmp .L864
.L863:
.L864:
    mov rax, r13
    push rax
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl274:
    call li_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
    call tx_show_value
    add rsp, 32
    add rbx, 1
.L862:
    jmp .L860
.L861:
    mov rax, r13
    push rax
section .data
.str866: db 93,10,0
section .text
    lea rax, [rel .str866]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl275:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl276:
    call tx_out
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl277:
    call tx_drop
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl278:
    call text_end
    add rsp, 32
    jmp .__ret_858
.__ret_858:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_show_value.kft, .kfe, .kfn, __kron_file_2,9
    dq .kl270,1158
    dq .kl271,1159
    dq .kl272,1160
    dq .kl273,1164
    dq .kl274,1166
    dq .kl275,1169
    dq .kl276,1170
    dq .kl277,1171
    dq .kl278,1172
.kfn: db "list_show", 0
section .text
text_print:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl279:
    call tx_out
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl280:
    call text_end
    add rsp, 32
    jmp .__ret_867
.__ret_867:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_show.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl279,1177
    dq .kl280,1178
.kfn: db "text_print", 0
section .text
text_cstr:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
.kl281:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L869
    mov rax, [rel __g_tv_p]
    mov rbx, rax
    jmp .L870
.L869:
.L870:
    mov rcx, rbx
    sub rsp, 32
.kl282:
    call text_end
    add rsp, 32
    jmp .__ret_868
.__ret_868:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_print.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl281,1184
    dq .kl282,1187
.kfn: db "text_cstr", 0
section .text
section .bss
__g_mp_key: resq 4
section .text
mp_hash:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 3750763034362895579
    neg rax
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L872:
    cmp rbx, r13
    jge .L873
    mov rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rcx, 1099511628211
    imul rax, rcx
    mov r12, rax
    add rbx, 1
.L874:
    jmp .L872
.L873:
    mov rax, r12
    jmp .__ret_871
.__ret_871:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mp_new:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rcx, 48
    sub rsp, 32
.kl283:
    call hp_alloc
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L876
    mov rax, 0
    jmp .__ret_875
    jmp .L877
.L876:
.L877:
    mov rax, 8
    mov rcx, 3
    imul rax, rcx
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl284:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    mov rax, 16
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl285:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L880
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L880
    mov rax, 0
    jmp .L881
.L880:
    mov rax, 1
.L881:
    test rax, rax
    jz .L878
    mov rax, 0
    jmp .__ret_875
    jmp .L879
.L878:
.L879:
    mov rax, r13
    add rax, 16
    push rax
    mov rax, 8
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 24
    push rax
    mov rax, 16
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 32
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 40
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
.kl286:
    call ob_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_875
.__ret_875:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_cstr.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl283,55
    dq .kl284,59
    dq .kl285,60
    dq .kl286,70
.kfn: db "mp_new", 0
section .text
mp_find:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov [rbp-128], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov r15, r8
    mov [rbp-32], r9
    mov rax, 1
    neg rax
    mov [rbp-40], rax
    mov rax, rbx
    add rax, 32
    mov rax, [rax]
    mov [rbp-48], rax
    mov rax, rbx
    add rax, 40
    mov rax, [rax]
    mov [rbp-56], rax
    mov rax, rbx
    add rax, 24
    mov rax, [rax]
    sub rax, 1
    mov [rbp-64], rax
    mov rax, [rbp-32]
    mov rcx, [rbp-64]
    and rax, rcx
    mov [rbp-72], rax
    mov rax, 1
    mov r14, rax
.L883:
    mov rax, r14
    test rax, rax
    jz .L884
    mov rax, [rbp-56]
    push rax
    mov rax, [rbp-72]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov r13, rax
    cmp r13, 0
    jne .L886
    mov rax, 0
    mov r14, rax
    jmp .L887
.L886:
    cmp r13, 0
    jle .L888
    mov rax, [rbp-48]
    push rax
    mov rax, r13
    sub rax, 1
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    add rax, 16
    mov rax, [rax]
    mov rcx, [rbp-32]
    cmp rax, rcx
    jne .L890
    mov rax, rbx
    mov rax, [rax]
    mov r12, rax
    cmp r12, 0
    je .L892
    mov rax, r12
    mov rax, [rax]
    cmp rax, r15
    jne .L894
    mov rax, 0
    mov rbx, rax
.L896:
    cmp rbx, r15
    jge .L897
    mov rax, r12
    add rax, 8
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, [rbp-16]
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L899
    mov rax, r15
    add rax, 1
    mov rbx, rax
    jmp .L900
.L899:
    add rbx, 1
.L900:
.L898:
    jmp .L896
.L897:
    cmp rbx, r15
    jne .L901
    mov rax, r13
    sub rax, 1
    mov [rbp-40], rax
    mov rax, 0
    mov r14, rax
    jmp .L902
.L901:
.L902:
    jmp .L895
.L894:
.L895:
    jmp .L893
.L892:
.L893:
    jmp .L891
.L890:
.L891:
    jmp .L889
.L888:
.L889:
.L887:
    mov rax, [rbp-72]
    add rax, 1
    mov rcx, [rbp-64]
    and rax, rcx
    mov [rbp-72], rax
.L885:
    jmp .L883
.L884:
    mov rax, [rbp-40]
    jmp .__ret_882
.__ret_882:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
mp_rebuild:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov rax, [rbp-16]
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl287:
    call hp_alloc
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L904
    mov rax, 0
    jmp .__ret_903
    jmp .L905
.L904:
.L905:
    mov rax, r15
    add rax, 32
    mov rax, [rax]
    mov [rbp-32], rax
    mov rax, r15
    add rax, 8
    mov rax, [rax]
    mov [rbp-40], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L906:
    mov rax, r12
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L907
    mov rax, [rbp-32]
    push rax
    mov rax, r12
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    mov rax, [rax]
    cmp rax, 0
    je .L909
    cmp r13, r12
    je .L911
    mov rax, [rbp-32]
    push rax
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-72], rax
    mov rax, [rbp-72]
    push rax
    mov rax, rbx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rbp-72]
    add rax, 8
    push rax
    mov rax, rbx
    add rax, 8
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rbp-72]
    add rax, 16
    push rax
    mov rax, rbx
    add rax, 16
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L912
.L911:
.L912:
    mov rax, [rbp-32]
    push rax
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 16
    mov rax, [rax]
    push rax
    mov rax, [rbp-16]
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
.L913:
    mov rax, r14
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    cmp rax, 0
    je .L914
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, [rbp-16]
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
.L915:
    jmp .L913
.L914:
    mov rax, r14
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add r13, 1
    jmp .L910
.L909:
.L910:
    add r12, 1
.L908:
    jmp .L906
.L907:
    mov rax, r15
    add rax, 8
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 40
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl288:
    call hp_release
    add rsp, 32
    mov rax, r15
    add rax, 40
    push rax
    mov rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 24
    push rax
    mov rax, [rbp-16]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    jmp .__ret_903
.__ret_903:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_new.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl287,117
    dq .kl288,145
.kfn: db "mp_rebuild", 0
section .text
mp_set:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl289:
    call ob_get
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jne .L917
    mov rax, 0
    jmp .__ret_916
    jmp .L918
.L917:
.L918:
    mov rcx, [rbp-16]
    sub rsp, 32
.kl290:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L919
    mov rax, 0
    jmp .__ret_916
    jmp .L920
.L919:
.L920:
    mov rax, [rel __g_tv_p]
    mov rbx, rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rcx, rbx
    mov rdx, r14
    sub rsp, 32
.kl291:
    call mp_hash
    add rsp, 32
    mov [rbp-56], rax
    mov rcx, r15
    mov rdx, rbx
    mov r8, r14
    mov r9, [rbp-56]
    sub rsp, 32
.kl292:
    call mp_find
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jl .L921
    mov rax, r15
    add rax, 32
    mov rax, [rax]
    push rax
    mov rax, rbx
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 8
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rbp-24]
    jmp .__ret_916
    jmp .L922
.L921:
.L922:
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    mov rax, r15
    add rax, 8
    mov rax, [rax]
    mov r13, rax
    mov rax, r15
    add rax, 16
    mov rax, [rax]
    mov rbx, rax
    mov rax, r15
    add rax, 24
    mov rax, [rax]
    mov r12, rax
    mov rax, r13
    add rax, 1
    mov rcx, 4
    imul rax, rcx
    push rax
    mov rax, r12
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L923
    mov rax, r15
    push rax
    mov rax, r12
    mov rcx, 2
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl293:
    call mp_rebuild
    add rsp, 32
    cmp rax, 0
    jne .L925
    mov rax, 0
    jmp .__ret_916
    jmp .L926
.L925:
.L926:
    mov rax, r15
    add rax, 8
    mov rax, [rax]
    mov r13, rax
    mov rax, r15
    add rax, 24
    mov rax, [rax]
    mov r12, rax
    jmp .L924
.L923:
.L924:
    mov rax, r13
    add rax, 1
    cmp rax, rbx
    jle .L927
    mov rcx, r15
    sub rsp, 32
.kl294:
    call peek_ents
    add rsp, 32
    push rax
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rcx, 24
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call hp_grow
    add rsp, 32
    mov [rbp-96], rax
    mov rax, [rbp-96]
    cmp rax, 0
    jne .L929
    mov rax, 0
    jmp .__ret_916
    jmp .L930
.L929:
.L930:
    mov rax, r15
    add rax, 32
    push rax
    mov rax, [rbp-96]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 16
    push rax
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L928
.L927:
.L928:
    mov rax, 8
    add rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
.kl295:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L931
    mov rax, 0
    jmp .__ret_916
    jmp .L932
.L931:
.L932:
    mov rcx, [rbp-16]
    sub rsp, 32
.kl296:
    call tv_view
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl297:
    call hp_copy
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 32
    mov rax, [rax]
    push rax
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rax, r14
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 16
    push rax
    mov rax, [rbp-56]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 8
    push rax
    mov rax, r13
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    push rax
    mov rax, r15
    mov rax, [rax]
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 40
    mov rax, [rax]
    mov rbx, rax
    mov rax, [rbp-56]
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r14, rax
.L933:
    mov rax, rbx
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    cmp rax, 0
    jle .L934
    mov rax, r14
    add rax, 1
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r14, rax
.L935:
    jmp .L933
.L934:
    mov rax, rbx
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rbp-24]
    jmp .__ret_916
.__ret_916:
    mov rbx, [rbp-176]
    mov r12, [rbp-168]
    mov r13, [rbp-160]
    mov r14, [rbp-152]
    mov r15, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_rebuild.kft, .kfe, .kfn, __kron_file_3,9
    dq .kl289,153
    dq .kl290,157
    dq .kl291,162
    dq .kl292,163
    dq .kl293,178
    dq .kl294,187
    dq .kl295,197
    dq .kl296,201
    dq .kl297,202
.kfn: db "mp_set", 0
section .text
peek_ents:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    add rax, 32
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_936
.__ret_936:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mp_lookup:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl298:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L938
    mov rax, 2
    neg rax
    jmp .__ret_937
    jmp .L939
.L938:
.L939:
    mov rcx, r12
    sub rsp, 32
.kl299:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L940
    mov rax, 2
    neg rax
    jmp .__ret_937
    jmp .L941
.L940:
.L941:
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_tv_n]
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_tv_n]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl300:
    call mp_hash
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_find
    add rsp, 32
    jmp .__ret_937
.__ret_937:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_set.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl298,229
    dq .kl299,233
    dq .kl300,236
.kfn: db "mp_lookup", 0
section .text
mp_value:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl301:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    add rax, 32
    mov rax, [rax]
    push rax
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 8
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_942
.__ret_942:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_lookup.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl301,240
.kfn: db "mp_value", 0
section .text
mp_remove:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl302:
    call mp_lookup
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jge .L944
    mov rax, 0
    jmp .__ret_943
    jmp .L945
.L944:
.L945:
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl303:
    call ob_get
    add rsp, 32
    mov r15, rax
    mov rax, r15
    add rax, 32
    mov rax, [rax]
    push rax
    mov rax, r14
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    mov rax, r12
    add rax, 16
    mov rax, [rax]
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl304:
    call hp_release
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    push rax
    mov rax, r15
    mov rax, [rax]
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r15
    add rax, 40
    mov rax, [rax]
    mov r13, rax
    mov rax, r15
    add rax, 24
    mov rax, [rax]
    sub rax, 1
    mov r12, rax
    mov rax, rbx
    and rax, r12
    mov rbx, rax
.L946:
    mov rax, r13
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    push rax
    mov rax, r14
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L947
    mov rax, rbx
    add rax, 1
    and rax, r12
    mov rbx, rax
.L948:
    jmp .L946
.L947:
    mov rax, r13
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 1
    jmp .__ret_943
.__ret_943:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_value.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl302,247
    dq .kl303,251
    dq .kl304,255
.kfn: db "mp_remove", 0
section .text
mp_ikey:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov [rbp-128], r15
    mov rbx, rcx
    lea rax, [rel __g_mp_key]
    mov r15, rax
    mov rax, rbx
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-40], rax
    cmp r14, 0
    jge .L950
    mov rax, 1
    mov [rbp-40], rax
    jmp .L951
.L950:
.L951:
    lea rax, [rbp-72]
    mov r12, rax
    cmp r14, 0
    jne .L952
    mov rax, r12
    push rax
    mov rax, 48
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov r13, rax
    jmp .L953
.L952:
.L953:
.L954:
    cmp r14, 0
    je .L955
    mov rax, r14
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rbx, rax
    cmp rbx, 0
    jge .L957
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L958
.L957:
.L958:
    mov rax, r12
    add rax, r13
    push rax
    mov rax, 48
    add rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    mov rax, r14
    mov rcx, 10
    cqo
    idiv rcx
    mov r14, rax
.L956:
    jmp .L954
.L955:
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-40]
    test rax, rax
    jz .L959
    mov rax, r15
    push rax
    mov rax, 45
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov rbx, rax
    jmp .L960
.L959:
.L960:
    mov rax, 0
    mov r14, rax
.L961:
    cmp r14, r13
    jge .L962
    mov rax, r15
    add rax, rbx
    add rax, r14
    push rax
    mov rax, r12
    add rax, r13
    sub rax, 1
    sub rax, r14
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r14, 1
.L963:
    jmp .L961
.L962:
    mov rax, r15
    add rax, rbx
    add rax, r13
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    lea rax, [rel __g_mp_key]
    jmp .__ret_949
.__ret_949:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
map_new:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    sub rsp, 32
.kl305:
    call mp_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_964
.__ret_964:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_remove.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl305,313
.kfn: db "map_new", 0
section .text
map_set:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl306:
    call mp_set
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_965
.__ret_965:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_new.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl306,318
.kfn: db "map_set", 0
section .text
map_get:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl307:
    call mp_lookup
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jl .L967
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl308:
    call mp_value
    add rsp, 32
    mov rbx, rax
    jmp .L968
.L967:
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L969
    mov rax, 6
    mov [rel __g_hp_err], rax
    jmp .L970
.L969:
.L970:
.L968:
    mov rcx, rbx
    sub rsp, 32
.kl309:
    call text_end
    add rsp, 32
    jmp .__ret_966
.__ret_966:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_set.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl307,323
    dq .kl308,326
    dq .kl309,330
.kfn: db "map_get", 0
section .text
map_get_or:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl310:
    call mp_lookup
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
    cmp r12, 0
    jl .L972
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl311:
    call mp_value
    add rsp, 32
    mov rbx, rax
    jmp .L973
.L972:
.L973:
    mov rcx, rbx
    sub rsp, 32
.kl312:
    call text_end
    add rsp, 32
    jmp .__ret_971
.__ret_971:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_get.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl310,335
    dq .kl311,338
    dq .kl312,340
.kfn: db "map_get_or", 0
section .text
map_has:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl313:
    call mp_lookup
    add rsp, 32
    cmp rax, 0
    jl .L975
    mov rax, 1
    mov rbx, rax
    jmp .L976
.L975:
.L976:
    mov rcx, rbx
    sub rsp, 32
.kl314:
    call text_end
    add rsp, 32
    jmp .__ret_974
.__ret_974:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_get_or.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl313,346
    dq .kl314,349
.kfn: db "map_has", 0
section .text
map_remove:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl315:
    call mp_remove
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_977
.__ret_977:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_has.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl315,354
.kfn: db "map_remove", 0
section .text
map_len:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl316:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L979
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    jmp .L980
.L979:
.L980:
    mov rcx, rbx
    sub rsp, 32
.kl317:
    call text_end
    add rsp, 32
    jmp .__ret_978
.__ret_978:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_remove.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl316,359
    dq .kl317,364
.kfn: db "map_len", 0
section .text
mp_list:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl318:
    call ob_get
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jne .L982
    mov rax, 0
    jmp .__ret_981
    jmp .L983
.L982:
.L983:
    mov rcx, 8
    sub rsp, 32
.kl319:
    call li_new
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L984
    mov rax, 0
    jmp .__ret_981
    jmp .L985
.L984:
.L985:
    mov rax, 0
    mov [rbp-40], rax
    mov rax, r15
    add rax, 8
    mov rax, [rax]
    mov [rbp-40], rax
    mov rax, 0
    mov r13, rax
.L986:
    mov rax, r13
    mov rcx, [rbp-40]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L989
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L989
    mov rax, 1
    jmp .L990
.L989:
    mov rax, 0
.L990:
    test rax, rax
    jz .L987
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    add rax, 32
    mov rax, [rax]
    push rax
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    mov rax, [rax]
    mov r12, rax
    mov rax, rbx
    add rax, 8
    mov rax, [rax]
    mov rbx, rax
    cmp r12, 0
    je .L991
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L993
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, r14
    push rax
    mov rax, r12
    add rax, 8
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl320:
    call tx_from_bytes
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    jmp .L994
.L993:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
.kl321:
    call li_add
    add rsp, 32
.L994:
    jmp .L992
.L991:
.L992:
    add r13, 1
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl322:
    call ob_get
    add rsp, 32
    mov r15, rax
.L988:
    jmp .L986
.L987:
    mov rax, r14
    jmp .__ret_981
.__ret_981:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_len.kft, .kfe, .kfn, __kron_file_3,5
    dq .kl318,369
    dq .kl319,373
    dq .kl320,392
    dq .kl321,394
    dq .kl322,398
.kfn: db "mp_list", 0
section .text
map_keys:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl323:
    call mp_list
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_995
.__ret_995:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_list.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl323,405
.kfn: db "map_keys", 0
section .text
map_values:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl324:
    call mp_list
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_996
.__ret_996:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_keys.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl324,410
.kfn: db "map_values", 0
section .text
mp_clear:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, r13
    add rax, 8
    mov rax, [rax]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L998:
    cmp rbx, r12
    jge .L999
    mov rax, r13
    add rax, 32
    mov rax, [rax]
    push rax
    mov rax, rbx
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl325:
    call hp_release
    add rsp, 32
    add rbx, 1
.L1000:
    jmp .L998
.L999:
    mov rax, r13
    add rax, 40
    mov rax, [rax]
    push rax
    mov rax, r13
    add rax, 24
    mov rax, [rax]
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl326:
    call hp_zero
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 8
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_997
.__ret_997:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_values.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl325,418
    dq .kl326,421
.kfn: db "mp_clear", 0
section .text
map_clear:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl327:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1002
    mov rcx, rbx
    sub rsp, 32
.kl328:
    call mp_clear
    add rsp, 32
    jmp .L1003
.L1002:
.L1003:
    mov rcx, r12
    sub rsp, 32
.kl329:
    call text_end
    add rsp, 32
    jmp .__ret_1001
.__ret_1001:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_clear.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl327,430
    dq .kl328,432
    dq .kl329,434
.kfn: db "map_clear", 0
section .text
map_free:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl330:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1005
    mov rcx, rbx
    sub rsp, 32
.kl331:
    call mp_clear
    add rsp, 32
    mov rax, rbx
    add rax, 32
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl332:
    call hp_release
    add rsp, 32
    mov rax, rbx
    add rax, 40
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl333:
    call hp_release
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl334:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl335:
    call hp_release
    add rsp, 32
    jmp .L1006
.L1005:
.L1006:
    mov rcx, 0
    sub rsp, 32
.kl336:
    call text_end
    add rsp, 32
    jmp .__ret_1004
.__ret_1004:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_clear.kft, .kfe, .kfn, __kron_file_3,7
    dq .kl330,439
    dq .kl331,441
    dq .kl332,443
    dq .kl333,444
    dq .kl334,446
    dq .kl335,447
    dq .kl336,449
.kfn: db "map_free", 0
section .text
map_set_real:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    movups [rbp-72], xmm6
    mov r13, rcx
    mov r12, rdx
    movaps xmm6, xmm2
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    movaps xmm0, xmm6
    movsd [rel __g_li_real], xmm0
    lea rax, [rel __g_li_real]
    mov rax, [rax]
    mov rbx, rax
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl337:
    call mp_set
    add rsp, 32
    sub rsp, 32
.kl338:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L1008
    mov rcx, rbx
    sub rsp, 32
.kl339:
    call heap_fail
    add rsp, 32
section .data
.flt1010: dq 0.0
section .text
    movsd xmm0, [rel .flt1010]
    jmp .__ret_1007
    jmp .L1009
.L1008:
.L1009:
    movaps xmm0, xmm6
    jmp .__ret_1007
.__ret_1007:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    movups xmm6, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_free.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl337,459
    dq .kl338,460
    dq .kl339,463
.kfn: db "map_set_real", 0
section .text
map_get_real:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    movups [rbp-64], xmm6
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl340:
    call mp_lookup
    add rsp, 32
    mov rbx, rax
section .data
.flt1012: dq 0.0
section .text
    movsd xmm0, [rel .flt1012]
    movaps xmm6, xmm0
    cmp rbx, 0
    jl .L1013
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl341:
    call mp_value
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_li_real]
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    movsd xmm0, [rel __g_li_real]
    movaps xmm6, xmm0
    jmp .L1014
.L1013:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1015
    mov rax, 6
    mov [rel __g_hp_err], rax
    jmp .L1016
.L1015:
.L1016:
.L1014:
    sub rsp, 32
.kl342:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L1017
    mov rcx, rbx
    sub rsp, 32
.kl343:
    call heap_fail
    add rsp, 32
section .data
.flt1019: dq 0.0
section .text
    movsd xmm0, [rel .flt1019]
    jmp .__ret_1011
    jmp .L1018
.L1017:
.L1018:
    movaps xmm0, xmm6
    jmp .__ret_1011
.__ret_1011:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_set_real.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl340,471
    dq .kl341,474
    dq .kl342,482
    dq .kl343,485
.kfn: db "map_get_real", 0
section .text
map_iset:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r13
    push rax
    mov rcx, r12
    sub rsp, 32
.kl344:
    call mp_ikey
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call mp_set
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1020
.__ret_1020:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_get_real.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl344,493
.kfn: db "map_iset", 0
section .text
map_iget:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r13
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl345:
    call mp_ikey
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_lookup
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jl .L1022
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl346:
    call mp_value
    add rsp, 32
    mov rbx, rax
    jmp .L1023
.L1022:
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1024
    mov rax, 6
    mov [rel __g_hp_err], rax
    jmp .L1025
.L1024:
.L1025:
.L1023:
    mov rcx, rbx
    sub rsp, 32
.kl347:
    call text_end
    add rsp, 32
    jmp .__ret_1021
.__ret_1021:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_iset.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl345,498
    dq .kl346,501
    dq .kl347,505
.kfn: db "map_iget", 0
section .text
map_ihas:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    push rax
    mov rcx, r12
    sub rsp, 32
.kl348:
    call mp_ikey
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_lookup
    add rsp, 32
    cmp rax, 0
    jl .L1027
    mov rax, 1
    mov rbx, rax
    jmp .L1028
.L1027:
.L1028:
    mov rcx, rbx
    sub rsp, 32
.kl349:
    call text_end
    add rsp, 32
    jmp .__ret_1026
.__ret_1026:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_iget.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl348,511
    dq .kl349,514
.kfn: db "map_ihas", 0
section .text
map_iremove:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl350:
    call mp_ikey
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_remove
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1029
.__ret_1029:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_ihas.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl350,519
.kfn: db "map_iremove", 0
section .text
map_show:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r15
    mov rdx, 0
    sub rsp, 32
.kl351:
    call mp_list
    add rsp, 32
    mov r14, rax
    mov rcx, 64
    sub rsp, 32
.kl352:
    call tx_new
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
section .data
.str1031: db 123,0
section .text
    lea rax, [rel .str1031]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl353:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl354:
    call li_len
    add rsp, 32
    mov [rbp-40], rax
    mov rax, 0
    mov r12, rax
.L1032:
    mov rax, r12
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L1033
    cmp r12, 0
    jle .L1035
    mov rax, r13
    push rax
section .data
.str1037: db 44,32,0
section .text
    lea rax, [rel .str1037]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl355:
    call tx_add_bytes
    add rsp, 32
    jmp .L1036
.L1035:
.L1036:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
.kl356:
    call li_get
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    mov r8, 1
    sub rsp, 32
.kl357:
    call tx_show_value
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str1038: db 58,32,0
section .text
    lea rax, [rel .str1038]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl358:
    call tx_add_bytes
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, r15
    push rax
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl359:
    call mp_lookup
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_value
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, [rbp-16]
    sub rsp, 32
    call tx_show_value
    add rsp, 32
    add r12, 1
.L1034:
    jmp .L1032
.L1033:
    mov rax, r13
    push rax
section .data
.str1039: db 125,10,0
section .text
    lea rax, [rel .str1039]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl360:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl361:
    call tx_out
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1040:
    mov rax, r12
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L1041
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
.kl362:
    call li_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call tx_drop
    add rsp, 32
    add r12, 1
.L1042:
    jmp .L1040
.L1041:
    mov rcx, r14
    sub rsp, 32
.kl363:
    call li_free
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl364:
    call tx_drop
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl365:
    call text_end
    add rsp, 32
    jmp .__ret_1030
.__ret_1030:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_iremove.kft, .kfe, .kfn, __kron_file_3,15
    dq .kl351,526
    dq .kl352,527
    dq .kl353,528
    dq .kl354,529
    dq .kl355,533
    dq .kl356,535
    dq .kl357,536
    dq .kl358,537
    dq .kl359,538
    dq .kl360,541
    dq .kl361,542
    dq .kl362,545
    dq .kl363,548
    dq .kl364,549
    dq .kl365,550
.kfn: db "map_show", 0
section .text
section .data
__g_all: dq 0
section .text
section .data
__g_seen: dq 0
section .text
worker:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
.L1044:
    cmp r12, 1000
    jge .L1045
section .data
.str1047: db 119,0
section .text
    lea rax, [rel .str1047]
    push rax
    pop rcx
    sub rsp, 32
.kl366:
    call text
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
.kl367:
    call text_add_int
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str1048: db 45,0
section .text
    lea rax, [rel .str1048]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl368:
    call text_add
    add rsp, 32
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl369:
    call text_add_int
    add rsp, 32
    mov rax, [rel __g_all]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl370:
    call list_add
    add rsp, 32
    mov rax, [rel __g_seen]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
.kl371:
    call map_set
    add rsp, 32
    add r12, 1
.L1046:
    jmp .L1044
.L1045:
    mov rax, 0
    jmp .__ret_1043
.__ret_1043:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_show.kft, .kfe, .kfn, __kron_file_4,6
    dq .kl366,21
    dq .kl367,22
    dq .kl368,23
    dq .kl369,24
    dq .kl370,25
    dq .kl371,26
.kfn: db "worker", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    sub rsp, 32
    call __rt_init
    add rsp, 32
    sub rsp, 32
.kl372:
    call list_new
    add rsp, 32
    mov [rel __g_all], rax
    sub rsp, 32
.kl373:
    call map_new
    add rsp, 32
    mov [rel __g_seen], rax
    lea rax, [rel worker]
    push rax
    mov rax, 1
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov r14, rax
    lea rax, [rel worker]
    push rax
    mov rax, 2
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov r13, rax
    lea rax, [rel worker]
    push rax
    mov rax, 3
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov r12, rax
    lea rax, [rel worker]
    push rax
    mov rax, 4
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, r13
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, [rel __g_all]
    push rax
    pop rcx
    sub rsp, 32
.kl374:
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rel __g_seen]
    push rax
    pop rcx
    sub rsp, 32
.kl375:
    call map_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rel __g_seen]
    push rax
section .data
.str1050: db 119,51,45,57,57,57,0
section .text
    lea rax, [rel .str1050]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl376:
    call map_has
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_1049
.__ret_1049:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq worker.kft, .kfe, .kfn, __kron_file_4,5
    dq .kl372,33
    dq .kl373,34
    dq .kl374,43
    dq .kl375,44
    dq .kl376,45
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,104,101,97,112,46,107,114,0
__kron_file_1: db 115,116,100,95,108,105,115,116,46,107,114,0
__kron_file_2: db 115,116,100,95,116,101,120,116,46,107,114,0
__kron_file_3: db 115,116,100,95,109,97,112,46,107,114,0
__kron_file_4: db 116,101,115,116,95,108,105,98,116,104,114,101,97,100,115,46,107,114,0
section .text
