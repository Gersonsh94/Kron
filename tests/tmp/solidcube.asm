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
extern GetModuleHandleA
extern QueryPerformanceCounter
extern QueryPerformanceFrequency
extern GetCommandLineA
extern VirtualAlloc
section .bss
__lib_state: resq 1
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
    mov rbx, rcx
    and rsp, -16
    sub rsp, 32
    mov rcx, [rel __fail_tls]
    call TlsGetValue
    test rax, rax
    jz .me_go
    mov rax, [rax]
    test rax, rax
    jz .me_go
    call __print_fail
.me_go:
    call __crt_flush
    mov rcx, rbx
    call ExitProcess
__crt_flush:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    mov rax, rsp
    sar rax, 4
    shl rax, 4
    mov rsp, rax
    sub rsp, 32
    lea rbx, [rel __crt_dlls]
.cf_lib:
    mov al, [rbx]
    test al, al
    jz .cf_out
    mov rcx, rbx
    call GetModuleHandleA
    test rax, rax
    jz .cf_next
    mov rcx, rax
    lea rdx, [rel __crt_flushall]
    call GetProcAddress
    test rax, rax
    jz .cf_next
    call rax
.cf_next:
    mov al, [rbx]
    inc rbx
    test al, al
    jnz .cf_next
    jmp .cf_lib
.cf_out:
    lea rsp, [rbp-16]
    pop rsi
    pop rbx
    pop rbp
    ret
section .data
__crt_dlls: db 'msvcrt.dll', 0, 'ucrtbase.dll', 0, 0
__crt_flushall: db '_flushall', 0
section .text
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
__xm_lib: db 'a system library could not be loaded', 0
__xh_lib: db 'check that it is installed: the names tried are the ones of its extern block', 0
__xm_fn: db 'the system library has no function of that name', 0
__xh_fn: db 'check the name, and that the installed version of the library has it', 0
section .text
__ccall:
    mov r9, [r11]
    test r9, r9
    jnz .cc_go
    push rbp
    mov rbp, rsp
    push rax
    push rdx
    push r10
    push r11
    mov rcx, r11
    call __ext_resolve
    mov r9, rax
    pop r11
    pop r10
    pop rdx
    pop rax
    pop rbp
    test r9, r9
    jz .cc_none
    mov [r11], r9
.cc_go:
    push rbp
    mov rbp, rsp
    push rbx
    push rsi
    push r12
    push r13
    sub rsp, 168
    and rsp, -16
    mov r12, r11
    mov r13, rax
    mov rbx, r13
    and rbx, 255
    xor esi, esi
.cc_arg:
    cmp rsi, rbx
    jae .cc_load
    mov rax, rbx
    sub rax, rsi
    dec rax
    mov rax, [r10+rax*8]
    mov rcx, rsi
    add rcx, 8
    mov rdx, 1
    shl rdx, cl
    test r13, rdx
    jz .cc_put
    mov rcx, rsi
    add rcx, 32
    mov rdx, 1
    shl rdx, cl
    test r13, rdx
    jz .cc_put
    movq xmm0, rax
    cvtsd2ss xmm0, xmm0
    movq rax, xmm0
.cc_put:
    mov [rsp+rsi*8], rax
    inc rsi
    jmp .cc_arg
.cc_load:
    mov rcx, [rsp]
    mov rdx, [rsp+8]
    mov r8, [rsp+16]
    mov r9, [rsp+24]
    movq xmm0, rcx
    movq xmm1, rdx
    movq xmm2, r8
    movq xmm3, r9
    mov r11, [r12]
    call r11
    mov rcx, r13
    shr rcx, 24
    and rcx, 255
    cmp rcx, 1
    jne .cc_r2
    shl rax, 32
    sar rax, 32
    jmp .cc_done
.cc_r2:
    cmp rcx, 2
    jne .cc_r3
    shl rax, 32
    shr rax, 32
    jmp .cc_done
.cc_r3:
    cmp rcx, 3
    jne .cc_r4
    and rax, 255
    jmp .cc_done
.cc_r4:
    cmp rcx, 4
    jne .cc_r5
    and rax, 65535
    jmp .cc_done
.cc_r5:
    cmp rcx, 5
    jne .cc_r6
    shl rax, 48
    sar rax, 48
    jmp .cc_done
.cc_r6:
    cmp rcx, 6
    jne .cc_r9
    shl rax, 56
    sar rax, 56
    jmp .cc_done
.cc_r9:
    cmp rcx, 9
    jne .cc_done
    cvtss2sd xmm0, xmm0
.cc_done:
    lea rsp, [rbp-32]
    pop r13
    pop r12
    pop rsi
    pop rbx
    pop rbp
    ret
.cc_none:
    xor eax, eax
    xorps xmm0, xmm0
    ret
__ext_resolve:
    push rbx
    push rsi
    sub rsp, 40
    mov rbx, rcx
    mov rsi, [rbx+16]
.xr_lib:
    mov al, [rsi]
    test al, al
    jz .xr_nolib
    mov rcx, rsi
    call __dll_load
    test rax, rax
    jnz .xr_sym
.xr_skip:
    mov al, [rsi]
    inc rsi
    test al, al
    jnz .xr_skip
    jmp .xr_lib
.xr_sym:
    mov rcx, rax
    mov rdx, [rbx+8]
    call __dll_proc
    test rax, rax
    jnz .xr_out
    lea rcx, [rel __xm_fn]
    lea rdx, [rel __xh_fn]
    jmp .xr_fail
.xr_nolib:
    lea rcx, [rel __xm_lib]
    lea rdx, [rel __xh_lib]
.xr_fail:
    xor r8, r8
    call __fail_raise
    xor eax, eax
.xr_out:
    add rsp, 40
    pop rsi
    pop rbx
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
section .bss
__g_buf: resq 3757
section .text
section .bss
__g_zb: resq 10000
section .text
cross:
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
    jmp .__ret_0
.__ret_0:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 1664
    mov [rbp-1632], rbx
    mov [rbp-1624], r12
    mov [rbp-1616], r13
    mov [rbp-1608], r14
    mov [rbp-1600], r15
    movups [rbp-1592], xmm6
    movups [rbp-1576], xmm7
    movups [rbp-1560], xmm8
    movups [rbp-1544], xmm9
    movups [rbp-1528], xmm10
    movups [rbp-1512], xmm11
    movups [rbp-1496], xmm12
    movups [rbp-1480], xmm13
    movups [rbp-1464], xmm14
    movups [rbp-1448], xmm15
    sub rsp, 32
    call __rt_init
    add rsp, 32
    lea rax, [rel __g_buf]
    mov r15, rax
    mov rax, r15
    add rax, 54
    mov [rbp-16], rax
    mov rax, r15
    add rax, 0
    push rax
    mov rax, 66
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r15
    add rax, 1
    push rax
    mov rax, 77
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r15
    add rax, 2
    push rax
    mov rax, 30054
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 6
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 10
    push rax
    mov rax, 54
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 14
    push rax
    mov rax, 40
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 18
    push rax
    mov rax, 100
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 22
    push rax
    mov rax, 100
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 26
    push rax
    mov rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, r15
    add rax, 28
    push rax
    mov rax, 24
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, r15
    add rax, 30
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 34
    push rax
    mov rax, 30000
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 38
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 42
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 46
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    add rax, 50
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, 0
    mov r13, rax
.L2:
    cmp r13, 100
    jge .L3
    mov rax, 0
    mov r12, rax
.L5:
    cmp r12, 100
    jge .L6
    mov rax, r13
    mov rcx, 300
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-16]
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    add rax, 0
    push rax
    mov rax, 40
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, 15
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, 12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r13
    mov rcx, 100
    imul rax, rcx
    add rax, r12
    cmp rax, 10000
    jb .L8
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl0:
    lea r8, [rel .kx0]
    call __fail_raise
.kx0:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L8:
    push rax
section .data
.flt9: dq 1000000000.0
section .text
    movsd xmm0, [rel .flt9]
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
.L7:
    add r12, 1
    jmp .L5
.L6:
.L4:
    add r13, 1
    jmp .L2
.L3:
    mov rax, 0
    cmp rax, 8
    jb .L10
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl1:
    lea r8, [rel .kx1]
    call __fail_raise
.kx1:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L10:
    push rax
section .data
.flt11: dq 0.0
section .text
    movsd xmm0, [rel .flt11]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt12: dq 1.0
section .text
    movsd xmm0, [rel .flt12]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 8
    jb .L13
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L13:
    push rax
section .data
.flt14: dq 0.0
section .text
    movsd xmm0, [rel .flt14]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt15: dq 1.0
section .text
    movsd xmm0, [rel .flt15]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 8
    jb .L16
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L16:
    push rax
section .data
.flt17: dq 0.0
section .text
    movsd xmm0, [rel .flt17]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt18: dq 1.0
section .text
    movsd xmm0, [rel .flt18]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L19
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl2:
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L19:
    push rax
section .data
.flt20: dq 1.0
section .text
    movsd xmm0, [rel .flt20]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L21
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L21:
    push rax
section .data
.flt22: dq 0.0
section .text
    movsd xmm0, [rel .flt22]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt23: dq 1.0
section .text
    movsd xmm0, [rel .flt23]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 8
    jb .L24
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L24:
    push rax
section .data
.flt25: dq 0.0
section .text
    movsd xmm0, [rel .flt25]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt26: dq 1.0
section .text
    movsd xmm0, [rel .flt26]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L27
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl3:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L27:
    push rax
section .data
.flt28: dq 1.0
section .text
    movsd xmm0, [rel .flt28]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L29
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L29:
    push rax
section .data
.flt30: dq 1.0
section .text
    movsd xmm0, [rel .flt30]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 2
    cmp rax, 8
    jb .L31
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L31:
    push rax
section .data
.flt32: dq 0.0
section .text
    movsd xmm0, [rel .flt32]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt33: dq 1.0
section .text
    movsd xmm0, [rel .flt33]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L34
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl4:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L34:
    push rax
section .data
.flt35: dq 0.0
section .text
    movsd xmm0, [rel .flt35]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt36: dq 1.0
section .text
    movsd xmm0, [rel .flt36]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L37
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L37:
    push rax
section .data
.flt38: dq 1.0
section .text
    movsd xmm0, [rel .flt38]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 3
    cmp rax, 8
    jb .L39
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L39:
    push rax
section .data
.flt40: dq 0.0
section .text
    movsd xmm0, [rel .flt40]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt41: dq 1.0
section .text
    movsd xmm0, [rel .flt41]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L42
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl5:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L42:
    push rax
section .data
.flt43: dq 0.0
section .text
    movsd xmm0, [rel .flt43]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt44: dq 1.0
section .text
    movsd xmm0, [rel .flt44]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L45
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L45:
    push rax
section .data
.flt46: dq 0.0
section .text
    movsd xmm0, [rel .flt46]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt47: dq 1.0
section .text
    movsd xmm0, [rel .flt47]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 4
    cmp rax, 8
    jb .L48
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L48:
    push rax
section .data
.flt49: dq 1.0
section .text
    movsd xmm0, [rel .flt49]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L50
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl6:
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L50:
    push rax
section .data
.flt51: dq 1.0
section .text
    movsd xmm0, [rel .flt51]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L52
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L52:
    push rax
section .data
.flt53: dq 0.0
section .text
    movsd xmm0, [rel .flt53]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt54: dq 1.0
section .text
    movsd xmm0, [rel .flt54]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 5
    cmp rax, 8
    jb .L55
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L55:
    push rax
section .data
.flt56: dq 1.0
section .text
    movsd xmm0, [rel .flt56]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L57
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl7:
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L57:
    push rax
section .data
.flt58: dq 1.0
section .text
    movsd xmm0, [rel .flt58]
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L59
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L59:
    push rax
section .data
.flt60: dq 1.0
section .text
    movsd xmm0, [rel .flt60]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 6
    cmp rax, 8
    jb .L61
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L61:
    push rax
section .data
.flt62: dq 1.0
section .text
    movsd xmm0, [rel .flt62]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L63
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl8:
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L63:
    push rax
section .data
.flt64: dq 0.0
section .text
    movsd xmm0, [rel .flt64]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt65: dq 1.0
section .text
    movsd xmm0, [rel .flt65]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L66
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L66:
    push rax
section .data
.flt67: dq 1.0
section .text
    movsd xmm0, [rel .flt67]
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, 7
    cmp rax, 8
    jb .L68
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L68:
    push rax
section .data
.flt69: dq 1.0
section .text
    movsd xmm0, [rel .flt69]
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
section .data
.flt70: dq 0.85
section .text
    movsd xmm0, [rel .flt70]
    movaps xmm8, xmm0
section .data
.flt71: dq 0.527
section .text
    movsd xmm0, [rel .flt71]
    movaps xmm7, xmm0
    mov rax, 0
    mov rbx, rax
.L72:
    cmp rbx, 8
    jge .L73
    mov rax, rbx
    cmp rax, 8
    jb .L75
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl9:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L75:
    mov rcx, rax
    lea rdx, [rbp-168]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L76
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L76:
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L77
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl10:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L77:
    mov rcx, rax
    lea rdx, [rbp-168]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L78
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L78:
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm9, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L79
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl11:
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L79:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rbp-168]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L80
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl12:
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L80:
    push rax
    movaps xmm0, xmm9
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
.L74:
    add rbx, 1
    jmp .L72
.L73:
section .data
.flt81: dq 0.7
section .text
    movsd xmm0, [rel .flt81]
    movaps xmm8, xmm0
section .data
.flt82: dq 0.714
section .text
    movsd xmm0, [rel .flt82]
    movaps xmm7, xmm0
    mov rax, 0
    mov rbx, rax
.L83:
    cmp rbx, 8
    jge .L84
    mov rax, rbx
    cmp rax, 8
    jb .L86
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl13:
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L86:
    mov rcx, rax
    lea rdx, [rbp-104]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L87
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L87:
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L88
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl14:
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L88:
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L89
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L89:
    mov rcx, rax
    lea rdx, [rbp-104]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm9, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L90
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl15:
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L90:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rbp-104]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L91
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl16:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L91:
    push rax
    movaps xmm0, xmm9
    pop rcx
    lea rdx, [rbp-232]
    movsd [rdx+rcx*8], xmm0
.L85:
    add rbx, 1
    jmp .L83
.L84:
    mov rax, 0
    mov rbx, rax
.L92:
    cmp rbx, 8
    jge .L93
    mov rax, rbx
    cmp rax, 8
    jb .L95
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl17:
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L95:
    mov rcx, rax
    lea rdx, [rbp-232]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt96: dq 4.0
section .text
    movsd xmm0, [rel .flt96]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L97
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl18:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L97:
    push rax
section .data
.flt98: dq 50.0
section .text
    movsd xmm0, [rel .flt98]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L99
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L99:
    mov rcx, rax
    lea rdx, [rbp-104]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt100: dq 90.0
section .text
    movsd xmm0, [rel .flt100]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-360]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L101
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl19:
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L101:
    push rax
section .data
.flt102: dq 50.0
section .text
    movsd xmm0, [rel .flt102]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L103
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L103:
    mov rcx, rax
    lea rdx, [rbp-168]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt104: dq 90.0
section .text
    movsd xmm0, [rel .flt104]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-424]
    movsd [rdx+rcx*8], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L105
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl20:
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L105:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rbp-488]
    movsd [rdx+rcx*8], xmm0
.L94:
    add rbx, 1
    jmp .L92
.L93:
    mov rax, 0
    cmp rax, 12
    jb .L106
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl21:
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L106:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L107
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L107:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L108
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L108:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L109
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L109:
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L110
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L110:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 12
    jb .L111
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L111:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L112
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl22:
    lea r8, [rel .kx49]
    call __fail_raise
.kx49:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L112:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L113
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx50]
    call __fail_raise
.kx50:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L113:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L114
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx51]
    call __fail_raise
.kx51:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L114:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L115
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx52]
    call __fail_raise
.kx52:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L115:
    push rax
    mov rax, 230
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L116
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx53]
    call __fail_raise
.kx53:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L116:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 12
    jb .L117
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx54]
    call __fail_raise
.kx54:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L117:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L118
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl23:
    lea r8, [rel .kx55]
    call __fail_raise
.kx55:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L118:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L119
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx56]
    call __fail_raise
.kx56:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L119:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L120
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx57]
    call __fail_raise
.kx57:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L120:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L121
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx58]
    call __fail_raise
.kx58:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L121:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L122
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx59]
    call __fail_raise
.kx59:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L122:
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 2
    cmp rax, 12
    jb .L123
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx60]
    call __fail_raise
.kx60:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L123:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L124
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl24:
    lea r8, [rel .kx61]
    call __fail_raise
.kx61:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L124:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L125
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx62]
    call __fail_raise
.kx62:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L125:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L126
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx63]
    call __fail_raise
.kx63:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L126:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L127
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx64]
    call __fail_raise
.kx64:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L127:
    push rax
    mov rax, 60
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L128
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx65]
    call __fail_raise
.kx65:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L128:
    push rax
    mov rax, 200
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 3
    cmp rax, 12
    jb .L129
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx66]
    call __fail_raise
.kx66:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L129:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L130
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl25:
    lea r8, [rel .kx67]
    call __fail_raise
.kx67:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L130:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L131
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx68]
    call __fail_raise
.kx68:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L131:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L132
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx69]
    call __fail_raise
.kx69:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L132:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L133
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx70]
    call __fail_raise
.kx70:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L133:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L134
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx71]
    call __fail_raise
.kx71:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L134:
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 4
    cmp rax, 12
    jb .L135
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx72]
    call __fail_raise
.kx72:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L135:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L136
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl26:
    lea r8, [rel .kx73]
    call __fail_raise
.kx73:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L136:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L137
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx74]
    call __fail_raise
.kx74:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L137:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L138
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx75]
    call __fail_raise
.kx75:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L138:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L139
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx76]
    call __fail_raise
.kx76:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L139:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L140
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx77]
    call __fail_raise
.kx77:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L140:
    push rax
    mov rax, 110
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 5
    cmp rax, 12
    jb .L141
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx78]
    call __fail_raise
.kx78:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L141:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L142
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl27:
    lea r8, [rel .kx79]
    call __fail_raise
.kx79:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L142:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L143
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx80]
    call __fail_raise
.kx80:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L143:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L144
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx81]
    call __fail_raise
.kx81:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L144:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L145
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx82]
    call __fail_raise
.kx82:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L145:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L146
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx83]
    call __fail_raise
.kx83:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L146:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 6
    cmp rax, 12
    jb .L147
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx84]
    call __fail_raise
.kx84:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L147:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L148
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl28:
    lea r8, [rel .kx85]
    call __fail_raise
.kx85:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L148:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L149
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx86]
    call __fail_raise
.kx86:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L149:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L150
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx87]
    call __fail_raise
.kx87:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L150:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L151
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx88]
    call __fail_raise
.kx88:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L151:
    push rax
    mov rax, 240
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L152
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx89]
    call __fail_raise
.kx89:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L152:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 7
    cmp rax, 12
    jb .L153
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx90]
    call __fail_raise
.kx90:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L153:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L154
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl29:
    lea r8, [rel .kx91]
    call __fail_raise
.kx91:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L154:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L155
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx92]
    call __fail_raise
.kx92:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L155:
    push rax
    mov rax, 2
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L156
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx93]
    call __fail_raise
.kx93:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L156:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L157
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx94]
    call __fail_raise
.kx94:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L157:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L158
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx95]
    call __fail_raise
.kx95:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L158:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 8
    cmp rax, 12
    jb .L159
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx96]
    call __fail_raise
.kx96:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L159:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L160
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl30:
    lea r8, [rel .kx97]
    call __fail_raise
.kx97:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L160:
    push rax
    mov rax, 3
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L161
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx98]
    call __fail_raise
.kx98:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L161:
    push rax
    mov rax, 6
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L162
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx99]
    call __fail_raise
.kx99:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L162:
    push rax
    mov rax, 7
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L163
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx100]
    call __fail_raise
.kx100:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L163:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L164
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx101]
    call __fail_raise
.kx101:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L164:
    push rax
    mov rax, 80
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 9
    cmp rax, 12
    jb .L165
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx102]
    call __fail_raise
.kx102:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L165:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L166
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl31:
    lea r8, [rel .kx103]
    call __fail_raise
.kx103:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L166:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L167
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx104]
    call __fail_raise
.kx104:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L167:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L168
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx105]
    call __fail_raise
.kx105:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L168:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L169
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx106]
    call __fail_raise
.kx106:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L169:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L170
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx107]
    call __fail_raise
.kx107:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L170:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 10
    cmp rax, 12
    jb .L171
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx108]
    call __fail_raise
.kx108:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L171:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L172
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl32:
    lea r8, [rel .kx109]
    call __fail_raise
.kx109:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L172:
    push rax
    mov rax, 4
    pop rcx
    lea rdx, [rbp-592]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L173
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx110]
    call __fail_raise
.kx110:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L173:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-688]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L174
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx111]
    call __fail_raise
.kx111:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L174:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-784]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L175
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx112]
    call __fail_raise
.kx112:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L175:
    push rax
    mov rax, 70
    pop rcx
    lea rdx, [rbp-880]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L176
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx113]
    call __fail_raise
.kx113:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L176:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-976]
    mov [rdx+rcx*8], rax
    mov rax, 11
    cmp rax, 12
    jb .L177
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx114]
    call __fail_raise
.kx114:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L177:
    push rax
    mov rax, 210
    pop rcx
    lea rdx, [rbp-1072]
    mov [rdx+rcx*8], rax
    mov rax, 0
    mov r14, rax
.L178:
    cmp r14, 12
    jge .L179
    mov rax, r14
    cmp rax, 12
    jb .L181
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl33:
    lea r8, [rel .kx115]
    call __fail_raise
.kx115:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L181:
    mov rcx, rax
    lea rdx, [rbp-592]
    mov rax, [rdx+rcx*8]
    mov r13, rax
    mov rax, r14
    cmp rax, 12
    jb .L182
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl34:
    lea r8, [rel .kx116]
    call __fail_raise
.kx116:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L182:
    mov rcx, rax
    lea rdx, [rbp-688]
    mov rax, [rdx+rcx*8]
    mov r12, rax
    mov rax, r14
    cmp rax, 12
    jb .L183
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl35:
    lea r8, [rel .kx117]
    call __fail_raise
.kx117:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L183:
    mov rcx, rax
    lea rdx, [rbp-784]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    mov rax, r13
    cmp rax, 8
    jb .L184
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl36:
    lea r8, [rel .kx118]
    call __fail_raise
.kx118:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L184:
    mov rcx, rax
    lea rdx, [rbp-360]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm15, xmm0
    mov rax, r13
    cmp rax, 8
    jb .L185
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl37:
    lea r8, [rel .kx119]
    call __fail_raise
.kx119:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L185:
    mov rcx, rax
    lea rdx, [rbp-424]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm14, xmm0
    mov rax, r13
    cmp rax, 8
    jb .L186
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl38:
    lea r8, [rel .kx120]
    call __fail_raise
.kx120:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L186:
    mov rcx, rax
    lea rdx, [rbp-488]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1128], xmm0
    mov rax, r12
    cmp rax, 8
    jb .L187
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl39:
    lea r8, [rel .kx121]
    call __fail_raise
.kx121:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L187:
    mov rcx, rax
    lea rdx, [rbp-360]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1136], xmm0
    mov rax, r12
    cmp rax, 8
    jb .L188
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl40:
    lea r8, [rel .kx122]
    call __fail_raise
.kx122:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L188:
    mov rcx, rax
    lea rdx, [rbp-424]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm13, xmm0
    mov rax, r12
    cmp rax, 8
    jb .L189
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl41:
    lea r8, [rel .kx123]
    call __fail_raise
.kx123:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L189:
    mov rcx, rax
    lea rdx, [rbp-488]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1152], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L190
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl42:
    lea r8, [rel .kx124]
    call __fail_raise
.kx124:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L190:
    mov rcx, rax
    lea rdx, [rbp-360]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm12, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L191
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl43:
    lea r8, [rel .kx125]
    call __fail_raise
.kx125:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L191:
    mov rcx, rax
    lea rdx, [rbp-424]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm11, xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L192
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl44:
    lea r8, [rel .kx126]
    call __fail_raise
.kx126:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L192:
    mov rcx, rax
    lea rdx, [rbp-488]
    movsd xmm0, [rdx+rcx*8]
    movsd [rbp-1176], xmm0
    movsd xmm0, [rbp-1136]
    movaps xmm1, xmm15
    subsd xmm0, xmm1
    movsd [rbp-1184], xmm0
    movaps xmm0, xmm13
    movaps xmm1, xmm14
    subsd xmm0, xmm1
    movsd [rbp-1192], xmm0
    movaps xmm0, xmm12
    movsd xmm1, [rbp-1136]
    subsd xmm0, xmm1
    movsd [rbp-1200], xmm0
    movaps xmm0, xmm11
    movaps xmm1, xmm13
    subsd xmm0, xmm1
    movsd [rbp-1208], xmm0
    movaps xmm0, xmm15
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    movsd [rbp-1216], xmm0
    movaps xmm0, xmm14
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    movsd [rbp-1224], xmm0
    movaps xmm0, xmm12
    movaps xmm1, xmm15
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm11
    movaps xmm1, xmm14
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movsd xmm0, [rbp-1184]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1192]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
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
.kl45:
    call cross
    add rsp, 32
    movaps xmm10, xmm0
    movaps xmm0, xmm10
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt195: dq 0.0
section .text
    movsd xmm0, [rel .flt195]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L193
section .data
.flt196: dq 0.0
section .text
    movsd xmm0, [rel .flt196]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L194
.L193:
.L194:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt199: dq 0.5
section .text
    movsd xmm0, [rel .flt199]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L197
    mov rax, 0
    mov [rbp-1264], rax
    mov rax, 99
    mov [rbp-1272], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 99
    mov [rbp-1288], rax
    mov rax, rbx
    mov r13, rax
.L200:
    mov rax, r13
    mov rcx, [rbp-1288]
    cmp rax, rcx
    jg .L201
    mov rax, [rbp-1264]
    mov r12, rax
.L203:
    mov rax, r12
    mov rcx, [rbp-1272]
    cmp rax, rcx
    jg .L204
    mov rax, r12
    cvtsi2sd xmm0, rax
    movaps xmm9, xmm0
    mov rax, r13
    cvtsi2sd xmm0, rax
    movaps xmm8, xmm0
    movsd xmm0, [rbp-1184]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1192]
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
.kl46:
    call cross
    add rsp, 32
    movaps xmm7, xmm0
    movsd xmm0, [rbp-1200]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1208]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-1136]
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
.kl47:
    call cross
    add rsp, 32
    movaps xmm6, xmm0
    movsd xmm0, [rbp-1216]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-1224]
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
.kl48:
    call cross
    add rsp, 32
    movaps xmm8, xmm0
    mov rax, 0
    mov rbx, rax
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt208: dq 0.0
section .text
    movsd xmm0, [rel .flt208]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L206
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt215: dq 0.0
section .text
    movsd xmm0, [rel .flt215]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L213
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt216: dq 0.0
section .text
    movsd xmm0, [rel .flt216]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L213
    mov rax, 1
    jmp .L214
.L213:
    mov rax, 0
.L214:
    test rax, rax
    jz .L211
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt217: dq 0.0
section .text
    movsd xmm0, [rel .flt217]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L211
    mov rax, 1
    jmp .L212
.L211:
    mov rax, 0
.L212:
    test rax, rax
    jz .L209
    mov rax, 1
    mov rbx, rax
    jmp .L210
.L209:
.L210:
    jmp .L207
.L206:
.L207:
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt220: dq 0.0
section .text
    movsd xmm0, [rel .flt220]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L218
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt227: dq 0.0
section .text
    movsd xmm0, [rel .flt227]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L225
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt228: dq 0.0
section .text
    movsd xmm0, [rel .flt228]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L225
    mov rax, 1
    jmp .L226
.L225:
    mov rax, 0
.L226:
    test rax, rax
    jz .L223
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt229: dq 0.0
section .text
    movsd xmm0, [rel .flt229]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L223
    mov rax, 1
    jmp .L224
.L223:
    mov rax, 0
.L224:
    test rax, rax
    jz .L221
    mov rax, 1
    mov rbx, rax
    jmp .L222
.L221:
.L222:
    jmp .L219
.L218:
.L219:
    cmp rbx, 1
    jne .L230
    movaps xmm0, xmm7
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movaps xmm9, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-1128]
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movsd xmm1, [rbp-1152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movsd xmm1, [rbp-1176]
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
    jb .L234
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl49:
    lea r8, [rel .kx127]
    call __fail_raise
.kx127:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L234:
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
    jz .L232
    mov rax, rbx
    cmp rax, 10000
    jb .L235
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl50:
    lea r8, [rel .kx128]
    call __fail_raise
.kx128:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L235:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_zb]
    movsd [rdx+rcx*8], xmm0
    mov rax, 99
    sub rax, r13
    mov rcx, 300
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-16]
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    add rax, 0
    push rax
    mov rax, r14
    cmp rax, 12
    jb .L236
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl51:
    lea r8, [rel .kx129]
    call __fail_raise
.kx129:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L236:
    mov rcx, rax
    lea rdx, [rbp-1072]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, r14
    cmp rax, 12
    jb .L237
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl52:
    lea r8, [rel .kx130]
    call __fail_raise
.kx130:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L237:
    mov rcx, rax
    lea rdx, [rbp-976]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, r14
    cmp rax, 12
    jb .L238
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl53:
    lea r8, [rel .kx131]
    call __fail_raise
.kx131:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1
.L238:
    mov rcx, rax
    lea rdx, [rbp-880]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L233
.L232:
.L233:
    jmp .L231
.L230:
.L231:
.L205:
    add r12, 1
    jmp .L203
.L204:
.L202:
    add r13, 1
    jmp .L200
.L201:
    jmp .L198
.L197:
.L198:
.L180:
    add r14, 1
    jmp .L178
.L179:
section .data
.str239: db 111,117,116,46,98,109,112,0
section .text
    lea rax, [rel .str239]
    push rax
    mov rax, r15
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
    jmp .__ret_1
.__ret_1:
    mov rbx, [rbp-1632]
    mov r12, [rbp-1624]
    mov r13, [rbp-1616]
    mov r14, [rbp-1608]
    mov r15, [rbp-1600]
    movups xmm6, [rbp-1592]
    movups xmm7, [rbp-1576]
    movups xmm8, [rbp-1560]
    movups xmm9, [rbp-1544]
    movups xmm10, [rbp-1528]
    movups xmm11, [rbp-1512]
    movups xmm12, [rbp-1496]
    movups xmm13, [rbp-1480]
    movups xmm14, [rbp-1464]
    movups xmm15, [rbp-1448]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,54
    dq .kl0,53
    dq .kl1,61
    dq .kl2,62
    dq .kl3,63
    dq .kl4,64
    dq .kl5,65
    dq .kl6,66
    dq .kl7,67
    dq .kl8,68
    dq .kl9,74
    dq .kl10,75
    dq .kl11,76
    dq .kl12,77
    dq .kl13,82
    dq .kl14,83
    dq .kl15,84
    dq .kl16,85
    dq .kl17,93
    dq .kl18,94
    dq .kl19,95
    dq .kl20,96
    dq .kl21,108
    dq .kl22,109
    dq .kl23,111
    dq .kl24,112
    dq .kl25,114
    dq .kl26,115
    dq .kl27,117
    dq .kl28,118
    dq .kl29,120
    dq .kl30,121
    dq .kl31,123
    dq .kl32,124
    dq .kl33,128
    dq .kl34,129
    dq .kl35,130
    dq .kl36,132
    dq .kl37,133
    dq .kl38,134
    dq .kl39,135
    dq .kl40,136
    dq .kl41,137
    dq .kl42,138
    dq .kl43,139
    dq .kl44,140
    dq .kl45,152
    dq .kl46,170
    dq .kl47,171
    dq .kl48,172
    dq .kl49,190
    dq .kl50,191
    dq .kl51,193
    dq .kl52,194
    dq .kl53,195
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,111,108,105,100,99,117,98,101,46,107,114,0
section .text
