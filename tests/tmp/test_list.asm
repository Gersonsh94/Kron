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
main:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    sub rsp, 32
    call __rt_init
    add rsp, 32
    sub rsp, 32
.kl106:
    call list_new
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L348:
    cmp r12, 20
    jge .L349
    mov rax, r13
    push rax
    mov rax, r12
    mov rcx, 7
    imul rax, rcx
    mov rcx, 13
    cqo
    idiv rcx
    mov rax, rdx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl107:
    call list_add
    add rsp, 32
    add r12, 1
.L350:
    jmp .L348
.L349:
    mov rcx, r13
    sub rsp, 32
.kl108:
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl109:
    call list_sort
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L351:
    cmp r12, 5
    jge .L352
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl110:
    call list_get
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    add r12, 1
.L353:
    jmp .L351
.L352:
    mov rcx, r13
    sub rsp, 32
.kl111:
    call list_last
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    mov rdx, 99
    sub rsp, 32
.kl112:
    call list_get
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    mov rdx, 0
    mov r8, 100
    sub rsp, 32
.kl113:
    call list_insert
    add rsp, 32
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
.kl114:
    call list_get
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
.kl115:
    call list_remove
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    mov rdx, 12
    sub rsp, 32
.kl116:
    call list_find
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    mov rdx, 55
    sub rsp, 32
.kl117:
    call list_find
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl118:
    call list_pop
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl119:
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl120:
    call list_reverse
    add rsp, 32
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
.kl121:
    call list_get
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl122:
    call list_copy
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
.kl123:
    call list_clear
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl124:
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl125:
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl126:
    call list_pop
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
.kl127:
    call list_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.flt354: dq 2.5
section .text
    movsd xmm0, [rel .flt354]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl128:
    call list_add_real
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.flt355: dq 0.125
section .text
    movsd xmm0, [rel .flt355]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl129:
    call list_add_real
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl130:
    call list_get_real
    add rsp, 32
    call __print_float
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
section .data
.flt356: dq 9.75
section .text
    movsd xmm0, [rel .flt356]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl131:
    call list_set_real
    add rsp, 32
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl132:
    call list_get_real
    add rsp, 32
    call __print_float
    mov rcx, r13
    sub rsp, 32
.kl133:
    call list_free
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl134:
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
.kl135:
    call list_new
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov r12, rax
.L357:
    cmp r12, 100000
    jge .L358
    mov rax, rbx
    push rax
    mov rax, 100000
    sub rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl136:
    call list_add
    add rsp, 32
    add r12, 1
.L359:
    jmp .L357
.L358:
    mov rcx, rbx
    sub rsp, 32
.kl137:
    call list_sort
    add rsp, 32
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl138:
    call list_get
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, rbx
    mov rdx, 99999
    sub rsp, 32
.kl139:
    call list_get
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_347
.__ret_347:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq list_set_real.kft, .kfe, .kfn, __kron_file_2,34
    dq .kl106,10
    dq .kl107,13
    dq .kl108,16
    dq .kl109,17
    dq .kl110,20
    dq .kl111,23
    dq .kl112,24
    dq .kl113,26
    dq .kl114,27
    dq .kl115,28
    dq .kl116,29
    dq .kl117,30
    dq .kl118,31
    dq .kl119,32
    dq .kl120,33
    dq .kl121,34
    dq .kl122,35
    dq .kl123,36
    dq .kl124,37
    dq .kl125,38
    dq .kl126,39
    dq .kl127,41
    dq .kl128,42
    dq .kl129,43
    dq .kl130,44
    dq .kl131,45
    dq .kl132,46
    dq .kl133,47
    dq .kl134,48
    dq .kl135,51
    dq .kl136,54
    dq .kl137,57
    dq .kl138,58
    dq .kl139,59
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,104,101,97,112,46,107,114,0
__kron_file_1: db 115,116,100,95,108,105,115,116,46,107,114,0
__kron_file_2: db 116,101,115,116,95,108,105,115,116,46,107,114,0
section .text
