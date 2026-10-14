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
    movaps xmm6, xmm0
    mov rax, [rel __g_st_n]
    cmp rax, 1024
    jge .L123
    mov rax, [rel __g_st_n]
    cmp rax, 1024
    jb .L125
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl13:
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_122
.L125:
    push rax
    movaps xmm0, xmm6
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
.kfe:
section .data
.kft: dq ftan.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl13,32
.kfn: db "st_push", 0
section .text
st_push_y:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
    mov rax, [rel __g_st_ny]
    cmp rax, 1024
    jge .L127
    mov rax, [rel __g_st_ny]
    cmp rax, 1024
    jb .L129
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl14:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_126
.L129:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_y]
    movsd [rdx+rcx*8], xmm0
    mov rax, [rel __g_st_ny]
    add rax, 1
    mov [rel __g_st_ny], rax
    jmp .L128
.L127:
.L128:
    mov rax, 0
    jmp .__ret_126
.__ret_126:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_push.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl14,40
.kfn: db "st_push_y", 0
section .text
st_count:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_st_n]
    jmp .__ret_130
.__ret_130:
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
    cmp rax, 1024
    jb .L132
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl15:
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_131
.L132:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_131
.__ret_131:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_push_y.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl15,51
.kfn: db "st_get", 0
section .text
st_min:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
    mov rax, 0
    cmp rax, 1024
    jb .L134
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl16:
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L134:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L135:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L136
    mov rax, rbx
    cmp rax, 1024
    jb .L140
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl17:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L140:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
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
    jz .L138
    mov rax, rbx
    cmp rax, 1024
    jb .L141
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl18:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L141:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    jmp .L139
.L138:
.L139:
.L137:
    add rbx, 1
    jmp .L135
.L136:
    movaps xmm0, xmm6
    jmp .__ret_133
.__ret_133:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_get.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl16,57
    dq .kl17,59
    dq .kl18,60
.kfn: db "st_min", 0
section .text
st_max:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
    mov rax, 0
    cmp rax, 1024
    jb .L143
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl19:
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_142
.L143:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L144:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L145
    mov rax, rbx
    cmp rax, 1024
    jb .L149
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl20:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_142
.L149:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
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
    jz .L147
    mov rax, rbx
    cmp rax, 1024
    jb .L150
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl21:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_142
.L150:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    jmp .L148
.L147:
.L148:
.L146:
    add rbx, 1
    jmp .L144
.L145:
    movaps xmm0, xmm6
    jmp .__ret_142
.__ret_142:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_min.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl19,67
    dq .kl20,69
    dq .kl21,70
.kfn: db "st_max", 0
section .text
st_range:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
.kl22:
    call st_max
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call st_min
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_151
.__ret_151:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_max.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl22,77
.kfn: db "st_range", 0
section .text
st_sum:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    movups [rbp-40], xmm6
section .data
.flt153: dq 0.0
section .text
    movsd xmm0, [rel .flt153]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L154:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L155
    mov rax, rbx
    cmp rax, 1024
    jb .L157
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl23:
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_152
.L157:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
.L156:
    add rbx, 1
    jmp .L154
.L155:
    movaps xmm0, xmm6
    jmp .__ret_152
.__ret_152:
    mov rbx, [rbp-48]
    movups xmm6, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_range.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl23,85
.kfn: db "st_sum", 0
section .text
st_mean:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
section .data
.flt159: dq 0.0
section .text
    movsd xmm0, [rel .flt159]
    movaps xmm6, xmm0
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    sub rsp, 32
.kl24:
    call st_sum
    add rsp, 32
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_158
.__ret_158:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_sum.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl24,93
.kfn: db "st_mean", 0
section .text
st_var:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    movups [rbp-88], xmm6
    movups [rbp-72], xmm7
    movups [rbp-56], xmm8
    sub rsp, 32
.kl25:
    call st_mean
    add rsp, 32
    movaps xmm8, xmm0
section .data
.flt161: dq 0.0
section .text
    movsd xmm0, [rel .flt161]
    movaps xmm7, xmm0
section .data
.flt162: dq 0.0
section .text
    movsd xmm0, [rel .flt162]
    movaps xmm6, xmm0
    mov rax, 0
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
    cmp rax, 1024
    jb .L166
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl26:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_160
.L166:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
.L165:
    add rbx, 1
    jmp .L163
.L164:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_160
.__ret_160:
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
    movups xmm8, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_mean.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl25,99
    dq .kl26,103
.kfn: db "st_var", 0
section .text
st_var_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    movups [rbp-88], xmm6
    movups [rbp-72], xmm7
    movups [rbp-56], xmm8
    sub rsp, 32
.kl27:
    call st_mean
    add rsp, 32
    movaps xmm8, xmm0
section .data
.flt168: dq 0.0
section .text
    movsd xmm0, [rel .flt168]
    movaps xmm7, xmm0
section .data
.flt169: dq 0.0
section .text
    movsd xmm0, [rel .flt169]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L170:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L171
    mov rax, rbx
    cmp rax, 1024
    jb .L173
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl28:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_167
.L173:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
.L172:
    add rbx, 1
    jmp .L170
.L171:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_167
.__ret_167:
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
    movups xmm8, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_var.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl27,111
    dq .kl28,115
.kfn: db "st_var_sample", 0
section .text
st_stddev:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
.kl29:
    call st_var
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_174
.__ret_174:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_var_sample.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl29,123
.kfn: db "st_stddev", 0
section .text
st_stddev_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
.kl30:
    call st_var_sample
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    jmp .__ret_175
.__ret_175:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_stddev.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl30,127
.kfn: db "st_stddev_sample", 0
section .text
st_sort:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
section .data
.flt177: dq 0.0
section .text
    movsd xmm0, [rel .flt177]
    movaps xmm6, xmm0
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L178:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L179
    mov rax, rbx
    cmp rax, 1024
    jb .L181
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl31:
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L181:
    push rax
    mov rax, rbx
    cmp rax, 1024
    jb .L182
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L182:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
.L180:
    add rbx, 1
    jmp .L178
.L179:
    mov rax, 1
    mov rbx, rax
.L183:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L184
    mov rax, rbx
    cmp rax, 1024
    jb .L186
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl32:
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L186:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L187:
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L190
    mov rax, r12
    cmp rax, 1024
    jb .L192
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl33:
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L192:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
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
    jz .L190
    mov rax, 1
    jmp .L191
.L190:
    mov rax, 0
.L191:
    test rax, rax
    jz .L188
    mov rax, r12
    add rax, 1
    cmp rax, 1024
    jb .L193
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl34:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L193:
    push rax
    mov rax, r12
    cmp rax, 1024
    jb .L194
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L194:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
    sub r12, 1
.L189:
    jmp .L187
.L188:
    mov rax, r12
    add rax, 1
    cmp rax, 1024
    jb .L195
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl35:
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_176
.L195:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_st_sorted]
    movsd [rdx+rcx*8], xmm0
.L185:
    add rbx, 1
    jmp .L183
.L184:
    mov rax, 0
    jmp .__ret_176
.__ret_176:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_stddev_sample.kft, .kfe, .kfn, __kron_file_1,5
    dq .kl31,138
    dq .kl32,141
    dq .kl33,143
    dq .kl34,144
    dq .kl35,147
.kfn: db "st_sort", 0
section .text
st_sorted_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    cmp rax, 1024
    jb .L197
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl36:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_196
.L197:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_196
.__ret_196:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_sort.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl36,153
.kfn: db "st_sorted_at", 0
section .text
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
.flt199: dq 0.0
section .text
    movsd xmm0, [rel .flt199]
    movaps xmm7, xmm0
section .data
.flt200: dq 0.0
section .text
    movsd xmm0, [rel .flt200]
    movaps xmm6, xmm0
    sub rsp, 32
.kl37:
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
    jne .L201
    mov rax, rbx
    cmp rax, 1024
    jb .L203
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl38:
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_198
.L203:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_198
    jmp .L202
.L201:
.L202:
    mov rax, rbx
    sub rax, 1
    cmp rax, 1024
    jb .L204
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl39:
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_198
.L204:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm7, xmm0
    mov rax, rbx
    cmp rax, 1024
    jb .L205
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl40:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_198
.L205:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt206: dq 2.0
section .text
    movsd xmm0, [rel .flt206]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    jmp .__ret_198
.__ret_198:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_sorted_at.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl37,160
    dq .kl38,163
    dq .kl39,165
    dq .kl40,166
.kfn: db "st_median", 0
section .text
st_percentile:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    movups [rbp-104], xmm6
    movups [rbp-88], xmm7
    movups [rbp-72], xmm8
    movaps xmm8, xmm0
section .data
.flt208: dq 0.0
section .text
    movsd xmm0, [rel .flt208]
    movaps xmm7, xmm0
    mov rax, 0
    mov rbx, rax
section .data
.flt209: dq 0.0
section .text
    movsd xmm0, [rel .flt209]
    movaps xmm6, xmm0
section .data
.flt210: dq 0.0
section .text
    movsd xmm0, [rel .flt210]
    movaps xmm6, xmm0
    sub rsp, 32
.kl41:
    call st_sort
    add rsp, 32
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt211: dq 100.0
section .text
    movsd xmm0, [rel .flt211]
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    divsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl42:
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
    jl .L212
    mov rax, [rel __g_st_n]
    sub rax, 1
    cmp rax, 1024
    jb .L214
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl43:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_207
.L214:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_207
    jmp .L213
.L212:
.L213:
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 1024
    jb .L215
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl44:
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_207
.L215:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    add rax, 1
    cmp rax, 1024
    jb .L216
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_207
.L216:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 1024
    jb .L217
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_207
.L217:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_207
.__ret_207:
    mov rbx, [rbp-112]
    movups xmm6, [rbp-104]
    movups xmm7, [rbp-88]
    movups xmm8, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_median.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl41,177
    dq .kl42,180
    dq .kl43,182
    dq .kl44,186
.kfn: db "st_percentile", 0
section .text
st_q1:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt219: dq 25.0
section .text
    movsd xmm0, [rel .flt219]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl45:
    call st_percentile
    add rsp, 32
    jmp .__ret_218
.__ret_218:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_percentile.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl45,190
.kfn: db "st_q1", 0
section .text
st_q3:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt221: dq 75.0
section .text
    movsd xmm0, [rel .flt221]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl46:
    call st_percentile
    add rsp, 32
    jmp .__ret_220
.__ret_220:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_q1.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl46,194
.kfn: db "st_q3", 0
section .text
st_iqr:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
.kl47:
    call st_q3
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call st_q1
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_222
.__ret_222:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_q3.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl47,198
.kfn: db "st_iqr", 0
section .text
st_mode:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    movups [rbp-56], xmm6
section .data
.flt224: dq 0.0
section .text
    movsd xmm0, [rel .flt224]
    movaps xmm6, xmm0
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov r12, rax
    sub rsp, 32
.kl48:
    call st_sort
    add rsp, 32
    mov rax, 0
    cmp rax, 1024
    jb .L225
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl49:
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_223
.L225:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L226:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L227
    mov rax, rbx
    cmp rax, 1024
    jb .L231
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl50:
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_223
.L231:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    sub rax, 1
    cmp rax, 1024
    jb .L232
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_223
.L232:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L229
    add r12, 1
    jmp .L230
.L229:
    mov rax, 1
    mov r12, rax
.L230:
    cmp r12, r13
    jle .L233
    mov rax, r12
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    cmp rax, 1024
    jb .L235
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl51:
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_223
.L235:
    mov rcx, rax
    lea rdx, [rel __g_st_sorted]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    jmp .L234
.L233:
.L234:
.L228:
    add rbx, 1
    jmp .L226
.L227:
    movaps xmm0, xmm6
    jmp .__ret_223
.__ret_223:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    movups xmm6, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_iqr.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl48,207
    dq .kl49,208
    dq .kl50,210
    dq .kl51,217
.kfn: db "st_mode", 0
section .text
st_mean_y:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    movups [rbp-72], xmm6
    movups [rbp-56], xmm7
section .data
.flt237: dq 0.0
section .text
    movsd xmm0, [rel .flt237]
    movaps xmm7, xmm0
section .data
.flt238: dq 0.0
section .text
    movsd xmm0, [rel .flt238]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L239:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_ny]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L240
    mov rax, rbx
    cmp rax, 1024
    jb .L242
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl52:
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_236
.L242:
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
.L241:
    add rbx, 1
    jmp .L239
.L240:
    mov rax, [rel __g_st_ny]
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_236
.__ret_236:
    mov rbx, [rbp-80]
    movups xmm6, [rbp-72]
    movups xmm7, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_mode.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl52,229
.kfn: db "st_mean_y", 0
section .text
st_covar:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    movups [rbp-120], xmm6
    movups [rbp-104], xmm7
    movups [rbp-88], xmm8
    movups [rbp-72], xmm9
    sub rsp, 32
.kl53:
    call st_mean
    add rsp, 32
    movaps xmm9, xmm0
    sub rsp, 32
.kl54:
    call st_mean_y
    add rsp, 32
    movaps xmm8, xmm0
section .data
.flt244: dq 0.0
section .text
    movsd xmm0, [rel .flt244]
    movaps xmm7, xmm0
section .data
.flt245: dq 0.0
section .text
    movsd xmm0, [rel .flt245]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L246:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L247
    mov rax, rbx
    cmp rax, 1024
    jb .L249
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl55:
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_243
.L249:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 1024
    jb .L250
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_243
.L250:
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
.L248:
    add rbx, 1
    jmp .L246
.L247:
    mov rax, [rel __g_st_n]
    cvtsi2sd xmm0, rax
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_243
.__ret_243:
    mov rbx, [rbp-128]
    movups xmm6, [rbp-120]
    movups xmm7, [rbp-104]
    movups xmm8, [rbp-88]
    movups xmm9, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_mean_y.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl53,236
    dq .kl54,237
    dq .kl55,241
.kfn: db "st_covar", 0
section .text
st_corr:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    mov [rbp-192], rbx
    movups [rbp-184], xmm6
    movups [rbp-168], xmm7
    movups [rbp-152], xmm8
    movups [rbp-136], xmm9
    movups [rbp-120], xmm10
    movups [rbp-104], xmm11
    movups [rbp-88], xmm12
    sub rsp, 32
.kl56:
    call st_mean
    add rsp, 32
    movaps xmm12, xmm0
    sub rsp, 32
.kl57:
    call st_mean_y
    add rsp, 32
    movaps xmm11, xmm0
section .data
.flt252: dq 0.0
section .text
    movsd xmm0, [rel .flt252]
    movaps xmm10, xmm0
section .data
.flt253: dq 0.0
section .text
    movsd xmm0, [rel .flt253]
    movaps xmm9, xmm0
section .data
.flt254: dq 0.0
section .text
    movsd xmm0, [rel .flt254]
    movaps xmm8, xmm0
section .data
.flt255: dq 0.0
section .text
    movsd xmm0, [rel .flt255]
    movaps xmm7, xmm0
section .data
.flt256: dq 0.0
section .text
    movsd xmm0, [rel .flt256]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L257:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L258
    mov rax, rbx
    cmp rax, 1024
    jb .L260
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl58:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_251
.L260:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    mov rax, rbx
    cmp rax, 1024
    jb .L261
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl59:
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_251
.L261:
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm10
    addsd xmm0, xmm1
    movaps xmm10, xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm9
    addsd xmm0, xmm1
    movaps xmm9, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    addsd xmm0, xmm1
    movaps xmm8, xmm0
.L259:
    add rbx, 1
    jmp .L257
.L258:
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl60:
    call fsqrt
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm10
    divsd xmm0, xmm1
    jmp .__ret_251
.__ret_251:
    mov rbx, [rbp-192]
    movups xmm6, [rbp-184]
    movups xmm7, [rbp-168]
    movups xmm8, [rbp-152]
    movups xmm9, [rbp-136]
    movups xmm10, [rbp-120]
    movups xmm11, [rbp-104]
    movups xmm12, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_covar.kft, .kfe, .kfn, __kron_file_1,5
    dq .kl56,248
    dq .kl57,249
    dq .kl58,256
    dq .kl59,257
    dq .kl60,262
.kfn: db "st_corr", 0
section .text
linreg_slope:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    movups [rbp-136], xmm6
    movups [rbp-120], xmm7
    movups [rbp-104], xmm8
    movups [rbp-88], xmm9
    movups [rbp-72], xmm10
    sub rsp, 32
.kl61:
    call st_mean
    add rsp, 32
    movaps xmm10, xmm0
    sub rsp, 32
.kl62:
    call st_mean_y
    add rsp, 32
    movaps xmm9, xmm0
section .data
.flt263: dq 0.0
section .text
    movsd xmm0, [rel .flt263]
    movaps xmm8, xmm0
section .data
.flt264: dq 0.0
section .text
    movsd xmm0, [rel .flt264]
    movaps xmm7, xmm0
section .data
.flt265: dq 0.0
section .text
    movsd xmm0, [rel .flt265]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L266:
    mov rax, rbx
    push rax
    mov rax, [rel __g_st_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L267
    mov rax, rbx
    cmp rax, 1024
    jb .L269
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl63:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_262
.L269:
    mov rcx, rax
    lea rdx, [rel __g_st_x]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm10
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 1024
    jb .L270
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl64:
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_262
.L270:
    mov rcx, rax
    lea rdx, [rel __g_st_y]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm8
    addsd xmm0, xmm1
    movaps xmm8, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    addsd xmm0, xmm1
    movaps xmm7, xmm0
.L268:
    add rbx, 1
    jmp .L266
.L267:
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    divsd xmm0, xmm1
    jmp .__ret_262
.__ret_262:
    mov rbx, [rbp-144]
    movups xmm6, [rbp-136]
    movups xmm7, [rbp-120]
    movups xmm8, [rbp-104]
    movups xmm9, [rbp-88]
    movups xmm10, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq st_corr.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl61,269
    dq .kl62,270
    dq .kl63,275
    dq .kl64,276
.kfn: db "linreg_slope", 0
section .text
linreg_intercept:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
.kl65:
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_271
.__ret_271:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq linreg_slope.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl65,283
.kfn: db "linreg_intercept", 0
section .text
linreg_predict:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
    sub rsp, 32
.kl66:
    call linreg_intercept
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    sub rsp, 32
    call linreg_slope
    add rsp, 32
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_272
.__ret_272:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq linreg_intercept.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl66,287
.kfn: db "linreg_predict", 0
section .text
linreg_r2:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    sub rsp, 32
.kl67:
    call st_corr
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_273
.__ret_273:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq linreg_predict.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl67,294
.kfn: db "linreg_r2", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    sub rsp, 32
    call __rt_init
    add rsp, 32
    sub rsp, 32
.kl68:
    call st_clear
    add rsp, 32
section .data
.flt275: dq 2.0
section .text
    movsd xmm0, [rel .flt275]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl69:
    call st_push
    add rsp, 32
section .data
.flt276: dq 4.0
section .text
    movsd xmm0, [rel .flt276]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl70:
    call st_push
    add rsp, 32
section .data
.flt277: dq 4.0
section .text
    movsd xmm0, [rel .flt277]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl71:
    call st_push
    add rsp, 32
section .data
.flt278: dq 4.0
section .text
    movsd xmm0, [rel .flt278]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl72:
    call st_push
    add rsp, 32
section .data
.flt279: dq 5.0
section .text
    movsd xmm0, [rel .flt279]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl73:
    call st_push
    add rsp, 32
section .data
.flt280: dq 5.0
section .text
    movsd xmm0, [rel .flt280]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl74:
    call st_push
    add rsp, 32
section .data
.flt281: dq 7.0
section .text
    movsd xmm0, [rel .flt281]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl75:
    call st_push
    add rsp, 32
section .data
.flt282: dq 9.0
section .text
    movsd xmm0, [rel .flt282]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl76:
    call st_push
    add rsp, 32
    sub rsp, 32
.kl77:
    call st_count
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
.kl78:
    call st_sum
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl79:
    call st_mean
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl80:
    call st_min
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl81:
    call st_max
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl82:
    call st_range
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl83:
    call st_var
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl84:
    call st_stddev
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl85:
    call st_median
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl86:
    call st_mode
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl87:
    call st_clear
    add rsp, 32
section .data
.flt283: dq 1.0
section .text
    movsd xmm0, [rel .flt283]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl88:
    call st_push
    add rsp, 32
section .data
.flt284: dq 2.0
section .text
    movsd xmm0, [rel .flt284]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl89:
    call st_push
    add rsp, 32
section .data
.flt285: dq 3.0
section .text
    movsd xmm0, [rel .flt285]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl90:
    call st_push
    add rsp, 32
section .data
.flt286: dq 4.0
section .text
    movsd xmm0, [rel .flt286]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl91:
    call st_push
    add rsp, 32
section .data
.flt287: dq 5.0
section .text
    movsd xmm0, [rel .flt287]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl92:
    call st_push
    add rsp, 32
    sub rsp, 32
.kl93:
    call st_median
    add rsp, 32
    call __print_float
section .data
.flt288: dq 0.0
section .text
    movsd xmm0, [rel .flt288]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl94:
    call st_percentile
    add rsp, 32
    call __print_float
section .data
.flt289: dq 50.0
section .text
    movsd xmm0, [rel .flt289]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl95:
    call st_percentile
    add rsp, 32
    call __print_float
section .data
.flt290: dq 100.0
section .text
    movsd xmm0, [rel .flt290]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl96:
    call st_percentile
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl97:
    call st_q1
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl98:
    call st_q3
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl99:
    call st_iqr
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl100:
    call st_var
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl101:
    call st_var_sample
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl102:
    call st_clear
    add rsp, 32
section .data
.flt291: dq 1.0
section .text
    movsd xmm0, [rel .flt291]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl103:
    call st_push
    add rsp, 32
section .data
.flt292: dq 2.0
section .text
    movsd xmm0, [rel .flt292]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl104:
    call st_push
    add rsp, 32
section .data
.flt293: dq 3.0
section .text
    movsd xmm0, [rel .flt293]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl105:
    call st_push
    add rsp, 32
section .data
.flt294: dq 4.0
section .text
    movsd xmm0, [rel .flt294]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl106:
    call st_push
    add rsp, 32
section .data
.flt295: dq 5.0
section .text
    movsd xmm0, [rel .flt295]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl107:
    call st_push
    add rsp, 32
section .data
.flt296: dq 3.0
section .text
    movsd xmm0, [rel .flt296]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl108:
    call st_push_y
    add rsp, 32
section .data
.flt297: dq 5.0
section .text
    movsd xmm0, [rel .flt297]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl109:
    call st_push_y
    add rsp, 32
section .data
.flt298: dq 7.0
section .text
    movsd xmm0, [rel .flt298]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl110:
    call st_push_y
    add rsp, 32
section .data
.flt299: dq 9.0
section .text
    movsd xmm0, [rel .flt299]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl111:
    call st_push_y
    add rsp, 32
section .data
.flt300: dq 11.0
section .text
    movsd xmm0, [rel .flt300]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl112:
    call st_push_y
    add rsp, 32
    sub rsp, 32
.kl113:
    call linreg_slope
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl114:
    call linreg_intercept
    add rsp, 32
    call __print_float
section .data
.flt301: dq 10.0
section .text
    movsd xmm0, [rel .flt301]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl115:
    call linreg_predict
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl116:
    call st_corr
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl117:
    call linreg_r2
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl118:
    call st_clear
    add rsp, 32
section .data
.flt302: dq 1.0
section .text
    movsd xmm0, [rel .flt302]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl119:
    call st_push
    add rsp, 32
section .data
.flt303: dq 2.0
section .text
    movsd xmm0, [rel .flt303]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl120:
    call st_push
    add rsp, 32
section .data
.flt304: dq 3.0
section .text
    movsd xmm0, [rel .flt304]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl121:
    call st_push
    add rsp, 32
section .data
.flt305: dq 4.0
section .text
    movsd xmm0, [rel .flt305]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl122:
    call st_push
    add rsp, 32
section .data
.flt306: dq 2.0
section .text
    movsd xmm0, [rel .flt306]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl123:
    call st_push_y
    add rsp, 32
section .data
.flt307: dq 4.0
section .text
    movsd xmm0, [rel .flt307]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl124:
    call st_push_y
    add rsp, 32
section .data
.flt308: dq 5.0
section .text
    movsd xmm0, [rel .flt308]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl125:
    call st_push_y
    add rsp, 32
section .data
.flt309: dq 8.0
section .text
    movsd xmm0, [rel .flt309]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl126:
    call st_push_y
    add rsp, 32
    sub rsp, 32
.kl127:
    call linreg_slope
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl128:
    call linreg_intercept
    add rsp, 32
    call __print_float
    sub rsp, 32
.kl129:
    call st_covar
    add rsp, 32
    call __print_float
    mov rax, 0
    jmp .__ret_274
.__ret_274:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq linreg_r2.kft, .kfe, .kfn, __kron_file_2,62
    dq .kl68,14
    dq .kl69,15
    dq .kl70,16
    dq .kl71,17
    dq .kl72,18
    dq .kl73,19
    dq .kl74,20
    dq .kl75,21
    dq .kl76,22
    dq .kl77,24
    dq .kl78,25
    dq .kl79,26
    dq .kl80,27
    dq .kl81,28
    dq .kl82,29
    dq .kl83,30
    dq .kl84,31
    dq .kl85,34
    dq .kl86,35
    dq .kl87,38
    dq .kl88,39
    dq .kl89,40
    dq .kl90,41
    dq .kl91,42
    dq .kl92,43
    dq .kl93,45
    dq .kl94,46
    dq .kl95,47
    dq .kl96,48
    dq .kl97,49
    dq .kl98,50
    dq .kl99,51
    dq .kl100,54
    dq .kl101,55
    dq .kl102,58
    dq .kl103,59
    dq .kl104,60
    dq .kl105,61
    dq .kl106,62
    dq .kl107,63
    dq .kl108,64
    dq .kl109,65
    dq .kl110,66
    dq .kl111,67
    dq .kl112,68
    dq .kl113,70
    dq .kl114,71
    dq .kl115,72
    dq .kl116,73
    dq .kl117,74
    dq .kl118,78
    dq .kl119,79
    dq .kl120,80
    dq .kl121,81
    dq .kl122,82
    dq .kl123,83
    dq .kl124,84
    dq .kl125,85
    dq .kl126,86
    dq .kl127,88
    dq .kl128,89
    dq .kl129,90
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,109,97,116,104,46,107,114,0
__kron_file_1: db 115,116,100,95,115,116,97,116,115,46,107,114,0
__kron_file_2: db 116,101,115,116,95,115,116,97,116,115,46,107,114,0
section .text
