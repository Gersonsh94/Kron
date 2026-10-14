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
.L3:
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
.L5:
    cmp rbx, r12
    jge .L6
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], cl
.L7:
    add rbx, 1
    jmp .L5
.L6:
    mov rax, r14
    jmp .__ret_4
.__ret_4:
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
.kl0:
    call mem_set
    add rsp, 32
    jmp .__ret_8
.__ret_8:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,1
    dq .kl0,42
.kfn: db "mem_zero", 0
section .text
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
.L10:
    cmp r12, r13
    jge .L11
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
    je .L13
    mov rax, rbx
    jmp .__ret_9
    jmp .L14
.L13:
.L14:
.L12:
    add r12, 1
    jmp .L10
.L11:
    mov rax, 0
    jmp .__ret_9
.__ret_9:
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
    jge .L16
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl1:
    call mem_copy
    add rsp, 32
    jmp .__ret_15
    jmp .L17
.L16:
.L17:
    mov rax, rbx
    mov rbx, rax
.L18:
    cmp rbx, 0
    jle .L19
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
.L20:
    jmp .L18
.L19:
    mov rax, r13
    jmp .__ret_15
.__ret_15:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mem_zero.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl1,63
.kfn: db "mem_move", 0
section .text
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
.L22:
    cmp rbx, r12
    jge .L23
    mov rax, r14
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, r13
    jne .L25
    mov rax, r14
    add rax, rbx
    jmp .__ret_21
    jmp .L26
.L25:
.L26:
.L24:
    add rbx, 1
    jmp .L22
.L23:
    mov rax, 0
    jmp .__ret_21
.__ret_21:
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
.L28:
    cmp r12, r13
    jge .L29
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
.L30:
    add r12, 1
    jmp .L28
.L29:
    mov rax, r15
    jmp .__ret_27
.__ret_27:
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
.L32:
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, 0
    je .L33
    add rbx, 1
.L34:
    jmp .L32
.L33:
    mov rax, rbx
    jmp .__ret_31
.__ret_31:
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
.L36:
    cmp rbx, 0
    je .L37
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
.L38:
    jmp .L36
.L37:
    mov rax, r14
    add rax, r12
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    jmp .__ret_35
.__ret_35:
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
.kl2:
    call str_length
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl3:
    call str_copy
    add rsp, 32
    mov rax, r13
    jmp .__ret_39
.__ret_39:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mem_move.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl2,52
    dq .kl3,53
.kfn: db "str_concat", 0
section .text
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
.L41:
    mov rax, 1
    cmp rax, 1
    jne .L42
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r14
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
    cmp r12, rbx
    je .L44
    mov rax, r12
    sub rax, rbx
    jmp .__ret_40
    jmp .L45
.L44:
.L45:
    cmp r12, 0
    jne .L46
    mov rax, 0
    jmp .__ret_40
    jmp .L47
.L46:
.L47:
    add r13, 1
.L43:
    jmp .L41
.L42:
    mov rax, 0
    jmp .__ret_40
.__ret_40:
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
.kl4:
    call str_compare
    add rsp, 32
    cmp rax, 0
    jne .L49
    mov rax, 1
    jmp .__ret_48
    jmp .L50
.L49:
.L50:
    mov rax, 0
    jmp .__ret_48
.__ret_48:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_concat.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl4,79
.kfn: db "str_equals", 0
section .text
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
.L52:
    cmp rbx, 0
    je .L53
    cmp rbx, r13
    jne .L55
    mov rax, r14
    add rax, r12
    jmp .__ret_51
    jmp .L56
.L55:
.L56:
    add r12, 1
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L54:
    jmp .L52
.L53:
    mov rax, 0
    jmp .__ret_51
.__ret_51:
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
.L58:
    cmp rbx, 0
    je .L59
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    cmp rax, rbx
    je .L61
    mov rax, 0
    jmp .__ret_57
    jmp .L62
.L61:
.L62:
    add r12, 1
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L60:
    jmp .L58
.L59:
    mov rax, 1
    jmp .__ret_57
.__ret_57:
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
.L64:
    cmp r13, r12
    jge .L65
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
.L66:
    jmp .L64
.L65:
    mov rax, r14
    jmp .__ret_63
.__ret_63:
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
    jge .L68
    mov rax, 1
    mov rbx, rax
    mov rax, 0
    sub rax, r12
    mov r12, rax
    jmp .L69
.L68:
.L69:
    cmp r12, 0
    jne .L70
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
    jmp .__ret_67
    jmp .L71
.L70:
.L71:
.L72:
    cmp r12, 0
    jle .L73
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
.L74:
    jmp .L72
.L73:
    cmp rbx, 1
    jne .L75
    mov rax, r14
    add rax, r13
    push rax
    mov rax, 45
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    jmp .L76
.L75:
.L76:
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
.kl5:
    call str_reverse
    add rsp, 32
    mov rax, r13
    jmp .__ret_67
.__ret_67:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_equals.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl5,162
.kfn: db "str_from_int", 0
section .text
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
    jne .L78
    mov rax, 0
    sub rax, 1
    mov r13, rax
    mov rax, 1
    mov r14, rax
    jmp .L79
.L78:
.L79:
    mov rax, r15
    add rax, r14
    movzx rax, byte [rax]
    mov rbx, rax
.L80:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L83
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L83
    mov rax, 1
    jmp .L84
.L83:
    mov rax, 0
.L84:
    test rax, rax
    jz .L81
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
.L82:
    jmp .L80
.L81:
    mov rax, r12
    imul rax, r13
    jmp .__ret_77
.__ret_77:
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
.L86:
    cmp rbx, 0
    je .L87
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
.L88:
    jmp .L86
.L87:
    mov rax, 10
    mov rcx, rax
    sub rsp, 32
    call __print_char
    add rsp, 32
    mov rax, r12
    jmp .__ret_85
.__ret_85:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
char_is_space:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 32
    jne .L90
    mov rax, 1
    jmp .__ret_89
    jmp .L91
.L90:
.L91:
    cmp rbx, 9
    jne .L92
    mov rax, 1
    jmp .__ret_89
    jmp .L93
.L92:
.L93:
    cmp rbx, 10
    jne .L94
    mov rax, 1
    jmp .__ret_89
    jmp .L95
.L94:
.L95:
    cmp rbx, 13
    jne .L96
    mov rax, 1
    jmp .__ret_89
    jmp .L97
.L96:
.L97:
    mov rax, 0
    jmp .__ret_89
.__ret_89:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
char_is_digit:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L101
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L101
    mov rax, 1
    jmp .L102
.L101:
    mov rax, 0
.L102:
    test rax, rax
    jz .L99
    mov rax, 1
    jmp .__ret_98
    jmp .L100
.L99:
.L100:
    mov rax, 0
    jmp .__ret_98
.__ret_98:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
char_is_alpha:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L106
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L106
    mov rax, 1
    jmp .L107
.L106:
    mov rax, 0
.L107:
    test rax, rax
    jz .L104
    mov rax, 1
    jmp .__ret_103
    jmp .L105
.L104:
.L105:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L110
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L110
    mov rax, 1
    jmp .L111
.L110:
    mov rax, 0
.L111:
    test rax, rax
    jz .L108
    mov rax, 1
    jmp .__ret_103
    jmp .L109
.L108:
.L109:
    mov rax, 0
    jmp .__ret_103
.__ret_103:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
char_upper:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L115
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L115
    mov rax, 1
    jmp .L116
.L115:
    mov rax, 0
.L116:
    test rax, rax
    jz .L113
    mov rax, rbx
    sub rax, 32
    jmp .__ret_112
    jmp .L114
.L113:
.L114:
    mov rax, rbx
    jmp .__ret_112
.__ret_112:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
char_lower:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L120
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L120
    mov rax, 1
    jmp .L121
.L120:
    mov rax, 0
.L121:
    test rax, rax
    jz .L118
    mov rax, rbx
    add rax, 32
    jmp .__ret_117
    jmp .L119
.L118:
.L119:
    mov rax, rbx
    jmp .__ret_117
.__ret_117:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
str_ends_with:
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
    mov rcx, r15
    sub rsp, 32
.kl6:
    call str_length
    add rsp, 32
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
.kl7:
    call str_length
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, r13
    jle .L123
    mov rax, 0
    jmp .__ret_122
    jmp .L124
.L123:
.L124:
.L125:
    cmp rbx, r12
    jge .L126
    mov rax, r15
    add rax, r13
    sub rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, r14
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L128
    mov rax, 0
    jmp .__ret_122
    jmp .L129
.L128:
.L129:
    add rbx, 1
.L127:
    jmp .L125
.L126:
    mov rax, 1
    jmp .__ret_122
.__ret_122:
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
.kft: dq str_from_int.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl6,247
    dq .kl7,248
.kfn: db "str_ends_with", 0
section .text
str_index_of:
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
.L131:
    mov rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, 0
    je .L132
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl8:
    call str_starts_with
    add rsp, 32
    cmp rax, 1
    jne .L134
    mov rax, rbx
    jmp .__ret_130
    jmp .L135
.L134:
.L135:
    add rbx, 1
.L133:
    jmp .L131
.L132:
    mov rax, r12
    movzx rax, byte [rax]
    cmp rax, 0
    jne .L136
    mov rax, 0
    jmp .__ret_130
    jmp .L137
.L136:
.L137:
    mov rax, 0
    sub rax, 1
    jmp .__ret_130
.__ret_130:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_ends_with.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl8,265
.kfn: db "str_index_of", 0
section .text
str_find:
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
.kl9:
    call str_index_of
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L139
    mov rax, 0
    jmp .__ret_138
    jmp .L140
.L139:
.L140:
    mov rax, r12
    add rax, rbx
    jmp .__ret_138
.__ret_138:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_index_of.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl9,275
.kfn: db "str_find", 0
section .text
str_contains:
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
.kl10:
    call str_index_of
    add rsp, 32
    cmp rax, 0
    jge .L142
    mov rax, 0
    jmp .__ret_141
    jmp .L143
.L142:
.L143:
    mov rax, 1
    jmp .__ret_141
.__ret_141:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_find.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl10,282
.kfn: db "str_contains", 0
section .text
str_count:
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
    mov rcx, r14
    sub rsp, 32
.kl11:
    call str_length
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jne .L145
    mov rax, 0
    jmp .__ret_144
    jmp .L146
.L145:
.L146:
.L147:
    mov rax, r15
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, 0
    je .L148
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
.kl12:
    call str_starts_with
    add rsp, 32
    cmp rax, 1
    jne .L150
    add r12, 1
    add rbx, r13
    jmp .L151
.L150:
    add rbx, 1
.L151:
.L149:
    jmp .L147
.L148:
    mov rax, r12
    jmp .__ret_144
.__ret_144:
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
.kft: dq str_contains.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl11,290
    dq .kl12,295
.kfn: db "str_count", 0
section .text
str_find_last_byte:
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
    mov rax, 0
    mov r12, rax
    mov rax, r15
    movzx rax, byte [rax]
    mov rbx, rax
.L153:
    cmp rbx, 0
    je .L154
    cmp rbx, r14
    jne .L156
    mov rax, r15
    add rax, r13
    mov r12, rax
    jmp .L157
.L156:
.L157:
    add r13, 1
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
.L155:
    jmp .L153
.L154:
    mov rax, r12
    jmp .__ret_152
.__ret_152:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
str_equals_nocase:
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
.L159:
    mov rax, 1
    cmp rax, 1
    jne .L160
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl13:
    call char_lower
    add rsp, 32
    mov r12, rax
    mov rax, r14
    add rax, r13
    movzx rax, byte [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl14:
    call char_lower
    add rsp, 32
    mov rbx, rax
    cmp r12, rbx
    je .L162
    mov rax, 0
    jmp .__ret_158
    jmp .L163
.L162:
.L163:
    cmp r12, 0
    jne .L164
    mov rax, 1
    jmp .__ret_158
    jmp .L165
.L164:
.L165:
    add r13, 1
.L161:
    jmp .L159
.L160:
    mov rax, 0
    jmp .__ret_158
.__ret_158:
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
.kft: dq str_count.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl13,326
    dq .kl14,327
.kfn: db "str_equals_nocase", 0
section .text
str_slice:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r15, rcx
    mov r14, rdx
    mov rbx, r8
    mov [rbp-32], r9
    mov rcx, r14
    sub rsp, 32
.kl15:
    call str_length
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
    cmp rbx, 0
    jge .L167
    mov rax, 0
    mov rbx, rax
    jmp .L168
.L167:
.L168:
.L169:
    mov rax, r12
    mov rcx, [rbp-32]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L172
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L172
    mov rax, 1
    jmp .L173
.L172:
    mov rax, 0
.L173:
    test rax, rax
    jz .L170
    mov rax, r15
    add rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
    add rbx, 1
.L171:
    jmp .L169
.L170:
    mov rax, r15
    add rax, r12
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r12
    jmp .__ret_166
.__ret_166:
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
.kft: dq str_equals_nocase.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl15,343
.kfn: db "str_slice", 0
section .text
str_split_count:
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
    mov rax, 1
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, r15
    movzx rax, byte [rax]
    mov rbx, rax
.L175:
    cmp rbx, 0
    je .L176
    cmp rbx, r14
    jne .L178
    add r13, 1
    jmp .L179
.L178:
.L179:
    add r12, 1
    mov rax, r15
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L177:
    jmp .L175
.L176:
    mov rax, r13
    jmp .__ret_174
.__ret_174:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
str_split_get:
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
    mov [rbp-24], r8
    mov [rbp-32], r9
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, [rbp-16]
    movzx rax, byte [rax]
    mov r12, rax
.L181:
    mov rax, 1
    cmp rax, 1
    jne .L182
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, [rbp-24]
    cmp rax, rcx
    jne .L184
    mov rax, 1
    mov rbx, rax
    jmp .L185
.L184:
.L185:
    cmp r12, 0
    jne .L186
    mov rax, 1
    mov rbx, rax
    jmp .L187
.L186:
.L187:
    cmp rbx, 1
    jne .L188
    mov rax, r15
    mov rcx, [rbp-32]
    cmp rax, rcx
    jne .L190
    mov rax, [rbp-8]
    add rax, r13
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r13
    jmp .__ret_180
    jmp .L191
.L190:
.L191:
    cmp r12, 0
    jne .L192
    mov rax, [rbp-8]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 0
    sub rax, 1
    jmp .__ret_180
    jmp .L193
.L192:
.L193:
    add r15, 1
    jmp .L189
.L188:
    mov rax, r15
    mov rcx, [rbp-32]
    cmp rax, rcx
    jne .L194
    mov rax, [rbp-8]
    add rax, r13
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    jmp .L195
.L194:
.L195:
.L189:
    add r14, 1
    mov rax, [rbp-16]
    add rax, r14
    movzx rax, byte [rax]
    mov r12, rax
.L183:
    jmp .L181
.L182:
    mov rax, 0
    sub rax, 1
    jmp .__ret_180
.__ret_180:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
str_trim:
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
    mov rcx, r13
    sub rsp, 32
.kl16:
    call str_length
    add rsp, 32
    mov rbx, rax
.L197:
    cmp r12, rbx
    jge .L198
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl17:
    call char_is_space
    add rsp, 32
    cmp rax, 0
    jne .L200
    jmp .L198
    jmp .L201
.L200:
.L201:
    add r12, 1
.L199:
    jmp .L197
.L198:
.L202:
    cmp rbx, r12
    jle .L203
    mov rax, r13
    add rax, rbx
    sub rax, 1
    movzx rax, byte [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl18:
    call char_is_space
    add rsp, 32
    cmp rax, 0
    jne .L205
    jmp .L203
    jmp .L206
.L205:
.L206:
    sub rbx, 1
.L204:
    jmp .L202
.L203:
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    sub rax, r12
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl19:
    call str_slice
    add rsp, 32
    jmp .__ret_196
.__ret_196:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_slice.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl16,417
    dq .kl17,421
    dq .kl18,425
    dq .kl19,428
.kfn: db "str_trim", 0
section .text
str_upper:
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
.L208:
    cmp rbx, 0
    je .L209
    mov rax, r13
    add rax, r12
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl20:
    call char_upper
    add rsp, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L210:
    jmp .L208
.L209:
    mov rax, r13
    jmp .__ret_207
.__ret_207:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_trim.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl20,438
.kfn: db "str_upper", 0
section .text
str_lower:
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
.L212:
    cmp rbx, 0
    je .L213
    mov rax, r13
    add rax, r12
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl21:
    call char_lower
    add rsp, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L214:
    jmp .L212
.L213:
    mov rax, r13
    jmp .__ret_211
.__ret_211:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq str_upper.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl21,452
.kfn: db "str_lower", 0
section .text
str_replace_byte:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov r14, r8
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, r15
    movzx rax, byte [rax]
    mov rbx, rax
.L216:
    cmp rbx, 0
    je .L217
    mov rax, rbx
    mov rcx, [rbp-16]
    cmp rax, rcx
    jne .L219
    mov rax, r15
    add rax, r13
    push rax
    mov rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
    jmp .L220
.L219:
.L220:
    add r13, 1
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
.L218:
    jmp .L216
.L217:
    mov rax, r12
    jmp .__ret_215
.__ret_215:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
str_fill:
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
.L222:
    cmp rbx, r12
    jge .L223
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L224:
    jmp .L222
.L223:
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    jmp .__ret_221
.__ret_221:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
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
    sub rsp, 32
    call __rt_init
    add rsp, 32
    lea rax, [rel __g_buf]
    mov r13, rax
    lea rax, [rel __g_buf2]
    mov r12, rax
    mov rcx, r13
    mov rdx, 65
    mov r8, 5
    sub rsp, 32
.kl22:
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
.kl23:
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
.kl24:
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
.str226: db 104,101,108,108,111,0
section .text
    lea rax, [rel .str226]
    push rax
    pop rdx
    pop rcx
    mov r8, 6
    sub rsp, 32
.kl25:
    call mem_copy
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl26:
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl27:
    call str_print_line
    add rsp, 32
section .data
.str227: db 97,98,99,0
section .text
    lea rax, [rel .str227]
    push rax
section .data
.str228: db 97,98,99,0
section .text
    lea rax, [rel .str228]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
.kl28:
    call mem_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str229: db 97,98,100,0
section .text
    lea rax, [rel .str229]
    push rax
section .data
.str230: db 97,98,99,0
section .text
    lea rax, [rel .str230]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
.kl29:
    call mem_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str231: db 104,101,108,108,111,0
section .text
    lea rax, [rel .str231]
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 108
    mov r8, 5
    sub rsp, 32
.kl30:
    call mem_find_byte
    add rsp, 32
    sub rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str232: db 83,99,105,101,110,99,101,0
section .text
    lea rax, [rel .str232]
    push rax
    pop rcx
    sub rsp, 32
.kl31:
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str233: db 97,98,99,0
section .text
    lea rax, [rel .str233]
    push rax
section .data
.str234: db 97,98,99,0
section .text
    lea rax, [rel .str234]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl32:
    call str_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str235: db 97,98,99,0
section .text
    lea rax, [rel .str235]
    push rax
section .data
.str236: db 97,98,100,0
section .text
    lea rax, [rel .str236]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl33:
    call str_equals
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str237: db 83,99,105,101,110,99,101,0
section .text
    lea rax, [rel .str237]
    push rax
section .data
.str238: db 83,99,105,0
section .text
    lea rax, [rel .str238]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl34:
    call str_starts_with
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str239: db 83,99,105,101,110,99,101,0
section .text
    lea rax, [rel .str239]
    push rax
section .data
.str240: db 120,121,122,0
section .text
    lea rax, [rel .str240]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl35:
    call str_starts_with
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str241: db 72,101,108,108,111,44,32,0
section .text
    lea rax, [rel .str241]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl36:
    call str_copy
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str242: db 119,111,114,108,100,0
section .text
    lea rax, [rel .str242]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl37:
    call str_concat
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl38:
    call str_print_line
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl39:
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str243: db 97,98,99,100,101,102,0
section .text
    lea rax, [rel .str243]
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 100
    sub rsp, 32
.kl40:
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
.kl41:
    call str_from_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl42:
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
.kl43:
    call str_from_int
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl44:
    call str_print_line
    add rsp, 32
section .data
.str244: db 52,51,50,49,0
section .text
    lea rax, [rel .str244]
    push rax
    pop rcx
    sub rsp, 32
.kl45:
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str245: db 45,55,55,0
section .text
    lea rax, [rel .str245]
    push rax
    pop rcx
    sub rsp, 32
.kl46:
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str246: db 49,50,97,98,0
section .text
    lea rax, [rel .str246]
    push rax
    pop rcx
    sub rsp, 32
.kl47:
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, r12
    mov rdx, 60000
    sub rsp, 32
.kl48:
    call str_from_int
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl49:
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_225
.__ret_225:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq str_lower.kft, .kfe, .kfn, __kron_file_2,28
    dq .kl22,20
    dq .kl23,22
    dq .kl24,25
    dq .kl25,28
    dq .kl26,29
    dq .kl27,30
    dq .kl28,32
    dq .kl29,33
    dq .kl30,36
    dq .kl31,39
    dq .kl32,40
    dq .kl33,41
    dq .kl34,42
    dq .kl35,43
    dq .kl36,45
    dq .kl37,46
    dq .kl38,47
    dq .kl39,48
    dq .kl40,51
    dq .kl41,54
    dq .kl42,55
    dq .kl43,56
    dq .kl44,57
    dq .kl45,59
    dq .kl46,60
    dq .kl47,61
    dq .kl48,64
    dq .kl49,65
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,109,101,109,46,107,114,0
__kron_file_1: db 115,116,100,95,115,116,114,46,107,114,0
__kron_file_2: db 116,101,115,116,95,115,116,100,108,105,98,46,107,114,0
section .text
