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
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call __rt_init
    add rsp, 32
section .data
.flt122: dq 0.0
section .text
    movsd xmm0, [rel .flt122]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt123: dq 3.5
section .text
    movsd xmm0, [rel .flt123]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl13:
    call fabs
    add rsp, 32
    call __print_float
section .data
.flt124: dq 2.0
section .text
    movsd xmm0, [rel .flt124]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt125: dq 7.0
section .text
    movsd xmm0, [rel .flt125]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl14:
    call fmin
    add rsp, 32
    call __print_float
section .data
.flt126: dq 2.0
section .text
    movsd xmm0, [rel .flt126]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt127: dq 7.0
section .text
    movsd xmm0, [rel .flt127]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl15:
    call fmax
    add rsp, 32
    call __print_float
section .data
.flt128: dq 9.0
section .text
    movsd xmm0, [rel .flt128]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt129: dq 0.0
section .text
    movsd xmm0, [rel .flt129]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt130: dq 5.0
section .text
    movsd xmm0, [rel .flt130]
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
    call fclamp
    add rsp, 32
    call __print_float
section .data
.flt131: dq 0.0
section .text
    movsd xmm0, [rel .flt131]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt132: dq 2.0
section .text
    movsd xmm0, [rel .flt132]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl17:
    call fsign
    add rsp, 32
    call __print_float
section .data
.flt133: dq 3.7
section .text
    movsd xmm0, [rel .flt133]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl18:
    call ffloor
    add rsp, 32
    call __print_float
section .data
.flt134: dq 0.0
section .text
    movsd xmm0, [rel .flt134]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt135: dq 3.2
section .text
    movsd xmm0, [rel .flt135]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl19:
    call ffloor
    add rsp, 32
    call __print_float
section .data
.flt136: dq 3.2
section .text
    movsd xmm0, [rel .flt136]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl20:
    call fceil
    add rsp, 32
    call __print_float
section .data
.flt137: dq 2.5
section .text
    movsd xmm0, [rel .flt137]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl21:
    call fround
    add rsp, 32
    call __print_float
section .data
.flt138: dq 7.0
section .text
    movsd xmm0, [rel .flt138]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt139: dq 3.0
section .text
    movsd xmm0, [rel .flt139]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl22:
    call fmod
    add rsp, 32
    call __print_float
section .data
.flt140: dq 16.0
section .text
    movsd xmm0, [rel .flt140]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl23:
    call fsqrt
    add rsp, 32
    call __print_float
section .data
.flt141: dq 2.0
section .text
    movsd xmm0, [rel .flt141]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl24:
    call fsqrt
    add rsp, 32
    call __print_float
section .data
.flt142: dq 3.0
section .text
    movsd xmm0, [rel .flt142]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt143: dq 4.0
section .text
    movsd xmm0, [rel .flt143]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl25:
    call flen2
    add rsp, 32
    call __print_float
section .data
.flt144: dq 1.0
section .text
    movsd xmm0, [rel .flt144]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt145: dq 2.0
section .text
    movsd xmm0, [rel .flt145]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt146: dq 2.0
section .text
    movsd xmm0, [rel .flt146]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl26:
    call flen3
    add rsp, 32
    call __print_float
section .data
.flt147: dq 0.0
section .text
    movsd xmm0, [rel .flt147]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl27:
    call fsin
    add rsp, 32
    call __print_float
section .data
.flt148: dq 1.57079632679
section .text
    movsd xmm0, [rel .flt148]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl28:
    call fsin
    add rsp, 32
    call __print_float
section .data
.flt149: dq 0.0
section .text
    movsd xmm0, [rel .flt149]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl29:
    call fcos
    add rsp, 32
    call __print_float
section .data
.flt150: dq 3.14159265359
section .text
    movsd xmm0, [rel .flt150]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl30:
    call fcos
    add rsp, 32
    call __print_float
section .data
.flt151: dq 2.0
section .text
    movsd xmm0, [rel .flt151]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mov rdx, 10
    sub rsp, 32
.kl31:
    call fpowi
    add rsp, 32
    call __print_float
section .data
.flt152: dq 180.0
section .text
    movsd xmm0, [rel .flt152]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl32:
    call deg_to_rad
    add rsp, 32
    call __print_float
section .data
.flt153: dq 3.14159265359
section .text
    movsd xmm0, [rel .flt153]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl33:
    call rad_to_deg
    add rsp, 32
    call __print_float
section .data
.flt154: dq 10.0
section .text
    movsd xmm0, [rel .flt154]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt155: dq 20.0
section .text
    movsd xmm0, [rel .flt155]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt156: dq 0.25
section .text
    movsd xmm0, [rel .flt156]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl34:
    call flerp
    add rsp, 32
    call __print_float
section .data
.flt157: dq 1.0
section .text
    movsd xmm0, [rel .flt157]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt158: dq 2.0
section .text
    movsd xmm0, [rel .flt158]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt159: dq 3.0
section .text
    movsd xmm0, [rel .flt159]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt160: dq 4.0
section .text
    movsd xmm0, [rel .flt160]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt161: dq 5.0
section .text
    movsd xmm0, [rel .flt161]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt162: dq 6.0
section .text
    movsd xmm0, [rel .flt162]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm5, [rsp]
    add rsp, 8
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
.kl35:
    call fdot3
    add rsp, 32
    call __print_float
    mov rax, 0
    jmp .__ret_121
.__ret_121:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq ftan.kft, .kfe, .kfn, __kron_file_1,23
    dq .kl13,13
    dq .kl14,14
    dq .kl15,15
    dq .kl16,16
    dq .kl17,17
    dq .kl18,20
    dq .kl19,21
    dq .kl20,22
    dq .kl21,23
    dq .kl22,24
    dq .kl23,27
    dq .kl24,28
    dq .kl25,29
    dq .kl26,30
    dq .kl27,33
    dq .kl28,34
    dq .kl29,35
    dq .kl30,36
    dq .kl31,39
    dq .kl32,40
    dq .kl33,41
    dq .kl34,44
    dq .kl35,45
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,109,97,116,104,46,107,114,0
__kron_file_1: db 116,101,115,116,95,109,97,116,104,46,107,114,0
section .text
