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
    sar rax, 1
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
fatan:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    movups [rbp-136], xmm6
    movups [rbp-120], xmm7
    movups [rbp-104], xmm8
    movups [rbp-88], xmm9
    movaps xmm6, xmm0
section .data
.flt111: dq 1.0
section .text
    movsd xmm0, [rel .flt111]
    movaps xmm9, xmm0
    movaps xmm0, xmm6
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt114: dq 0.0
section .text
    movsd xmm0, [rel .flt114]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L112
section .data
.flt115: dq 0.0
section .text
    movsd xmm0, [rel .flt115]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt116: dq 1.0
section .text
    movsd xmm0, [rel .flt116]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm9, xmm0
section .data
.flt117: dq 0.0
section .text
    movsd xmm0, [rel .flt117]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L113
.L112:
.L113:
section .data
.flt118: dq 1.0
section .text
    movsd xmm0, [rel .flt118]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt119: dq 1.0
section .text
    movsd xmm0, [rel .flt119]
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
section .data
.flt120: dq 1.0
section .text
    movsd xmm0, [rel .flt120]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt121: dq 1.0
section .text
    movsd xmm0, [rel .flt121]
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm8, xmm0
    movaps xmm0, xmm6
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    movaps xmm6, xmm0
    mov rax, 1
    mov rbx, rax
.L122:
    cmp rbx, 12
    jge .L123
section .data
.flt125: dq 0.0
section .text
    movsd xmm0, [rel .flt125]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    mov rax, 2
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cvtsi2sd xmm0, rax
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
.L124:
    add rbx, 1
    jmp .L122
.L123:
section .data
.flt126: dq 4.0
section .text
    movsd xmm0, [rel .flt126]
    movaps xmm1, xmm0
    movaps xmm0, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_110
.__ret_110:
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
.kft: dq ftan.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl13,223
    dq .kl14,224
.kfn: db "fatan", 0
section .text
fatan2:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    movups [rbp-32], xmm7
    movaps xmm7, xmm0
    movaps xmm6, xmm1
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt130: dq 0.0
section .text
    movsd xmm0, [rel .flt130]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L128
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl15:
    call fatan
    add rsp, 32
    jmp .__ret_127
    jmp .L129
.L128:
.L129:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt133: dq 0.0
section .text
    movsd xmm0, [rel .flt133]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L131
    movaps xmm0, xmm7
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
    setae al
    movzx rax, al
    test rax, rax
    jz .L134
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl16:
    call fatan
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt137: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt137]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_127
    jmp .L135
.L134:
.L135:
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl17:
    call fatan
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt138: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt138]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_127
    jmp .L132
.L131:
.L132:
    movaps xmm0, xmm7
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
    seta al
    movzx rax, al
    test rax, rax
    jz .L139
section .data
.flt142: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt142]
    jmp .__ret_127
    jmp .L140
.L139:
.L140:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt145: dq 0.0
section .text
    movsd xmm0, [rel .flt145]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L143
section .data
.flt146: dq 0.0
section .text
    movsd xmm0, [rel .flt146]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt147: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt147]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_127
    jmp .L144
.L143:
.L144:
section .data
.flt148: dq 0.0
section .text
    movsd xmm0, [rel .flt148]
    jmp .__ret_127
.__ret_127:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fatan.kft, .kfe, .kfn, __kron_file_0,3
    dq .kl15,238
    dq .kl16,242
    dq .kl17,244
.kfn: db "fatan2", 0
section .text
fasin:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt150: dq 0.0
section .text
    movsd xmm0, [rel .flt150]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt151: dq 1.0
section .text
    movsd xmm0, [rel .flt151]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt152: dq 1.0
section .text
    movsd xmm0, [rel .flt152]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl18:
    call fclamp
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt153: dq 1.0
section .text
    movsd xmm0, [rel .flt153]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
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
    call fsqrt
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fatan2
    add rsp, 32
    jmp .__ret_149
.__ret_149:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fatan2.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl18,257
    dq .kl19,258
.kfn: db "fasin", 0
section .text
facos:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt155: dq 0.0
section .text
    movsd xmm0, [rel .flt155]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt156: dq 1.0
section .text
    movsd xmm0, [rel .flt156]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt157: dq 1.0
section .text
    movsd xmm0, [rel .flt157]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl20:
    call fclamp
    add rsp, 32
    movaps xmm6, xmm0
section .data
.flt158: dq 1.0
section .text
    movsd xmm0, [rel .flt158]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl21:
    call fsqrt
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fatan2
    add rsp, 32
    jmp .__ret_154
.__ret_154:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fasin.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl20,262
    dq .kl21,263
.kfn: db "facos", 0
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
.flt160: dq 1.0
section .text
    movsd xmm0, [rel .flt160]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L161:
    cmp rbx, r12
    jge .L162
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
.L163:
    add rbx, 1
    jmp .L161
.L162:
    movaps xmm0, xmm6
    jmp .__ret_159
.__ret_159:
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
.flt165: dq 0.01745329251994329577
section .text
    movsd xmm0, [rel .flt165]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_164
.__ret_164:
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
.flt167: dq 57.29577951308232087680
section .text
    movsd xmm0, [rel .flt167]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_166
.__ret_166:
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
    jmp .__ret_168
.__ret_168:
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
    jmp .__ret_169
.__ret_169:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    movups xmm9, [rbp-96]
    movups xmm10, [rbp-80]
    movups xmm11, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
radians:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
section .data
.flt171: dq 0.017453292519943295
section .text
    movsd xmm0, [rel .flt171]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_170
.__ret_170:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
degrees:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
section .data
.flt173: dq 57.29577951308232
section .text
    movsd xmm0, [rel .flt173]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_172
.__ret_172:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
v2:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    movups [rbp-48], xmm7
    mov [rbp-8], r11
    movaps xmm7, xmm0
    movaps xmm6, xmm1
    mov qword [rbp-32], 0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-32], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-28], xmm0
    lea rax, [rbp-32]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rax, [rbp-8]
    jmp .__ret_174
.__ret_174:
    movups xmm6, [rbp-64]
    movups xmm7, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
v2_add:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-24], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl22:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_175
.__ret_175:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq facos.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl22,44
.kfn: db "v2_add", 0
section .text
v2_sub:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-24], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl23:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_176
.__ret_176:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_add.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl23,45
.kfn: db "v2_sub", 0
section .text
v2_scale:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl24:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_177
.__ret_177:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_sub.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl24,46
.kfn: db "v2_scale", 0
section .text
v2_dot:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov r11, [rcx + 0]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-16], r11
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-4]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_178
.__ret_178:
    mov rsp, rbp
    pop rbp
    ret
v2_len:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov r11, [rcx + 0]
    mov [rbp-8], r11
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-4]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-4]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
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
.kl25:
    call fsqrt
    add rsp, 32
    jmp .__ret_179
.__ret_179:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_scale.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl25,48
.kfn: db "v2_len", 0
section .text
v2_norm:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    lea rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
.kl26:
    call v2_len
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt183: dq 0.0
section .text
    movsd xmm0, [rel .flt183]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L181
section .data
.flt184: dq 0.0
section .text
    movsd xmm0, [rel .flt184]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt185: dq 0.0
section .text
    movsd xmm0, [rel .flt185]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl27:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_180
    jmp .L182
.L181:
.L182:
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl28:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_180
.__ret_180:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_len.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl26,50
    dq .kl27,51
    dq .kl28,52
.kfn: db "v2_norm", 0
section .text
v2_lerp:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-24], r11
    movaps xmm6, xmm2
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl29:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_186
.__ret_186:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_norm.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl29,54
.kfn: db "v2_lerp", 0
section .text
v3:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    movups [rbp-64], xmm8
    mov [rbp-8], r11
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    mov qword [rbp-48], 0
    mov qword [rbp-40], 0
    movaps xmm0, xmm8
    cvtsd2ss xmm0, xmm0
    movss [rbp-48], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-44], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-40], xmm0
    lea rax, [rbp-48]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_187
.__ret_187:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
v3_add:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl30:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_188
.__ret_188:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_lerp.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl30,58
.kfn: db "v3_add", 0
section .text
v3_sub:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl31:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_189
.__ret_189:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_add.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl31,59
.kfn: db "v3_sub", 0
section .text
v3_mul:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl32:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_190
.__ret_190:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_sub.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl32,60
.kfn: db "v3_mul", 0
section .text
v3_scale:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl33:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_191
.__ret_191:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_mul.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl33,61
.kfn: db "v3_scale", 0
section .text
v3_neg:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
section .data
.flt193: dq 0.0
section .text
    movsd xmm0, [rel .flt193]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt194: dq 0.0
section .text
    movsd xmm0, [rel .flt194]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt195: dq 0.0
section .text
    movsd xmm0, [rel .flt195]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
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
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_192
.__ret_192:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_scale.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl34,62
.kfn: db "v3_neg", 0
section .text
v3_dot:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rcx + 8]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-32], r11
    mov r11, [rdx + 8]
    mov [rbp-24], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_196
.__ret_196:
    mov rsp, rbp
    pop rbp
    ret
v3_cross:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl35:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_197
.__ret_197:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_neg.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl35,65
.kfn: db "v3_cross", 0
section .text
v3_len2:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rcx + 8]
    mov [rbp-8], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_198
.__ret_198:
    mov rsp, rbp
    pop rbp
    ret
v3_len:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rcx + 8]
    mov [rbp-8], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
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
.kl36:
    call fsqrt
    add rsp, 32
    jmp .__ret_199
.__ret_199:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_cross.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl36,68
.kfn: db "v3_len", 0
section .text
v3_dist:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rcx + 8]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-32], r11
    mov r11, [rdx + 8]
    mov [rbp-24], r11
    lea rax, [rbp-16]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl37:
    lea r11, [rbp-48]
    call v3_sub
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call v3_len
    add rsp, 32
    jmp .__ret_200
.__ret_200:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_len.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl37,69
.kfn: db "v3_dist", 0
section .text
v3_norm:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    lea rax, [rbp-24]
    push rax
    pop rcx
    sub rsp, 32
.kl38:
    call v3_len
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt204: dq 0.0
section .text
    movsd xmm0, [rel .flt204]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L202
section .data
.flt205: dq 0.0
section .text
    movsd xmm0, [rel .flt205]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt206: dq 0.0
section .text
    movsd xmm0, [rel .flt206]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt207: dq 0.0
section .text
    movsd xmm0, [rel .flt207]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl39:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_201
    jmp .L203
.L202:
.L203:
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl40:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_201
.__ret_201:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_dist.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl38,71
    dq .kl39,72
    dq .kl40,73
.kfn: db "v3_norm", 0
section .text
v3_lerp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movaps xmm6, xmm2
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl41:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_208
.__ret_208:
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_norm.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl41,76
.kfn: db "v3_lerp", 0
section .text
v3_min:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl42:
    call fmin
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fmin
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fmin
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_209
.__ret_209:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_lerp.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl42,78
.kfn: db "v3_min", 0
section .text
v3_max:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl43:
    call fmax
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fmax
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fmax
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_210
.__ret_210:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_min.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl43,79
.kfn: db "v3_max", 0
section .text
v3_reflect:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
section .data
.flt212: dq 2.0
section .text
    movsd xmm0, [rel .flt212]
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl44:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-56]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_sub
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_211
.__ret_211:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_max.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl44,81
.kfn: db "v3_reflect", 0
section .text
v4:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    movups [rbp-96], xmm8
    movups [rbp-80], xmm9
    mov [rbp-8], r11
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    movaps xmm0, xmm9
    cvtsd2ss xmm0, xmm0
    movss [rbp-56], xmm0
    movaps xmm0, xmm8
    cvtsd2ss xmm0, xmm0
    movss [rbp-52], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-48], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-44], xmm0
    lea rax, [rbp-56]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rax, [rbp-8]
    jmp .__ret_213
.__ret_213:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    movups xmm8, [rbp-96]
    movups xmm9, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
v4_from3:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
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
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_214
.__ret_214:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_reflect.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl45,85
.kfn: db "v4_from3", 0
section .text
v4_xyz:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl46:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_215
.__ret_215:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_from3.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl46,86
.kfn: db "v4_xyz", 0
section .text
v4_add:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
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
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_216
.__ret_216:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_xyz.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl47,87
.kfn: db "v4_add", 0
section .text
v4_sub:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
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
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_217
.__ret_217:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_add.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl48,88
.kfn: db "v4_sub", 0
section .text
v4_scale:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
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
.kl49:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_218
.__ret_218:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_sub.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl49,89
.kfn: db "v4_scale", 0
section .text
v4_dot:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rcx + 8]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-32], r11
    mov r11, [rdx + 8]
    mov [rbp-24], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-4]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_219
.__ret_219:
    mov rsp, rbp
    pop rbp
    ret
v4_lerp:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movaps xmm6, xmm2
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
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
.kl50:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_220
.__ret_220:
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_scale.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl50,92
.kfn: db "v4_lerp", 0
section .text
color4:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov [rbp-8], r11
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rbx, r9
    mov rax, r14
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt222: dq 255.0
section .text
    movsd xmm0, [rel .flt222]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r13
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt223: dq 255.0
section .text
    movsd xmm0, [rel .flt223]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r12
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt224: dq 255.0
section .text
    movsd xmm0, [rel .flt224]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt225: dq 255.0
section .text
    movsd xmm0, [rel .flt225]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
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
.kl51:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_221
.__ret_221:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_lerp.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl51,96
.kfn: db "color4", 0
section .text
m4_get:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    movups [rbp-128], xmm6
    mov r11, [rcx + 0]
    mov [rbp-64], r11
    mov r11, [rcx + 8]
    mov [rbp-56], r11
    mov r11, [rcx + 16]
    mov [rbp-48], r11
    mov r11, [rcx + 24]
    mov [rbp-40], r11
    mov r11, [rcx + 32]
    mov [rbp-32], r11
    mov r11, [rcx + 40]
    mov [rbp-24], r11
    mov r11, [rcx + 48]
    mov [rbp-16], r11
    mov r11, [rcx + 56]
    mov [rbp-8], r11
    mov r12, rdx
    mov rbx, r8
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    add rax, r12
    mov r12, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L229
    mov rax, r12
    mov rcx, 15
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L229
    mov rax, 0
    jmp .L230
.L229:
    mov rax, 1
.L230:
    test rax, rax
    jz .L227
section .data
.str231: db 110,111,32,115,117,99,104,32,101,108,101,109,101,110,116,32,111,102,32,97,32,52,120,52,32,109,97,116,114,105,120,0
section .text
    lea rax, [rel .str231]
    push rax
section .data
.str232: db 114,111,119,32,97,110,100,32,99,111,108,117,109,110,32,103,111,32,102,114,111,109,32,48,32,116,111,32,51,0
section .text
    lea rax, [rel .str232]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl52:
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_226
    jmp .L228
.L227:
.L228:
section .data
.flt233: dq 0.0
section .text
    movsd xmm0, [rel .flt233]
    movaps xmm6, xmm0
    lea rax, [rbp-64]
    mov rbx, rax
    lea rax, [rbp-112]
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    imul rax, rax, 4
    mov rcx, rax
    pop rax
    add rax, rcx
    mov eax, dword [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, 0
    cmp rax, 1
    jb .L234
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl53:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_226
.L234:
    mov rcx, rax
    lea rdx, [rbp-112]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    jmp .__ret_226
.__ret_226:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    movups xmm6, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq color4.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl52,104
    dq .kl53,111
.kfn: db "m4_get", 0
section .text
m4_set:
    push rbp
    mov rbp, rsp
    sub rsp, 256
    mov [rbp-224], rbx
    mov [rbp-216], r12
    movups [rbp-208], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    mov r12, rdx
    mov rbx, r8
    movaps xmm6, xmm3
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    add rax, r12
    mov r12, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L238
    mov rax, r12
    mov rcx, 15
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L238
    mov rax, 0
    jmp .L239
.L238:
    mov rax, 1
.L239:
    test rax, rax
    jz .L236
section .data
.str240: db 110,111,32,115,117,99,104,32,101,108,101,109,101,110,116,32,111,102,32,97,32,52,120,52,32,109,97,116,114,105,120,0
section .text
    lea rax, [rel .str240]
    push rax
section .data
.str241: db 114,111,119,32,97,110,100,32,99,111,108,117,109,110,32,103,111,32,102,114,111,109,32,48,32,116,111,32,51,0
section .text
    lea rax, [rel .str241]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl54:
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_235
    jmp .L237
.L236:
.L237:
    lea rax, [rbp-72]
    lea rdx, [rbp-168]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    lea rax, [rbp-168]
    mov rbx, rax
    mov rax, 0
    cmp rax, 1
    jb .L242
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl55:
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_235
.L242:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rbp-184]
    cvtsd2ss xmm0, xmm0
    movss [rdx+rcx*4], xmm0
    mov rax, rbx
    push rax
    mov rax, r12
    imul rax, rax, 4
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    lea rax, [rbp-184]
    mov eax, dword [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    lea rax, [rbp-168]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_235
.__ret_235:
    mov rbx, [rbp-224]
    mov r12, [rbp-216]
    movups xmm6, [rbp-208]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_get.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl54,119
    dq .kl55,125
.kfn: db "m4_set", 0
section .text
m4_identity:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-8], r11
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    mov qword [rbp-40], 0
    mov qword [rbp-32], 0
    mov qword [rbp-24], 0
    mov qword [rbp-16], 0
section .data
.flt244: dq 1.0
section .text
    movsd xmm0, [rel .flt244]
    cvtsd2ss xmm0, xmm0
    movss [rbp-72], xmm0
section .data
.flt245: dq 1.0
section .text
    movsd xmm0, [rel .flt245]
    cvtsd2ss xmm0, xmm0
    movss [rbp-52], xmm0
section .data
.flt246: dq 1.0
section .text
    movsd xmm0, [rel .flt246]
    cvtsd2ss xmm0, xmm0
    movss [rbp-32], xmm0
section .data
.flt247: dq 1.0
section .text
    movsd xmm0, [rel .flt247]
    cvtsd2ss xmm0, xmm0
    movss [rbp-12], xmm0
    lea rax, [rbp-72]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_243
.__ret_243:
    mov rsp, rbp
    pop rbp
    ret
m4_mul:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-136], r11
    mov r11, [rdx + 8]
    mov [rbp-128], r11
    mov r11, [rdx + 16]
    mov [rbp-120], r11
    mov r11, [rdx + 24]
    mov [rbp-112], r11
    mov r11, [rdx + 32]
    mov [rbp-104], r11
    mov r11, [rdx + 40]
    mov [rbp-96], r11
    mov r11, [rdx + 48]
    mov [rbp-88], r11
    mov r11, [rdx + 56]
    mov [rbp-80], r11
    mov qword [rbp-200], 0
    mov qword [rbp-192], 0
    mov qword [rbp-184], 0
    mov qword [rbp-176], 0
    mov qword [rbp-168], 0
    mov qword [rbp-160], 0
    mov qword [rbp-152], 0
    mov qword [rbp-144], 0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-136]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-132]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-128]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-124]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-200], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-136]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-132]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-128]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-124]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-196], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-136]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-132]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-128]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-124]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-192], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-136]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-132]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-128]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-124]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-188], xmm0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-120]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-116]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-112]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-108]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-184], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-120]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-116]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-112]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-108]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-180], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-120]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-116]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-112]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-108]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-176], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-120]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-116]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-112]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-108]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-172], xmm0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-168], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-164], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-160], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-156], xmm0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-152], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-148], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-144], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-140], xmm0
    lea rax, [rbp-200]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_248
.__ret_248:
    mov rsp, rbp
    pop rbp
    ret
m4_mul_v4:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-88], r11
    mov r11, [rdx + 8]
    mov [rbp-80], r11
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-76]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
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
.kl56:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_249
.__ret_249:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_set.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl56,159
.kfn: db "m4_mul_v4", 0
section .text
m4_mul_point:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-88], r11
    mov r11, [rdx + 8]
    mov [rbp-80], r11
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-88]
    push rax
section .data
.flt251: dq 1.0
section .text
    movsd xmm0, [rel .flt251]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl57:
    lea r11, [rbp-120]
    call v4_from3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-104]
    call m4_mul_v4
    add rsp, 32
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt256: dq 0.0
section .text
    movsd xmm0, [rel .flt256]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setne al
    movzx rax, al
    test rax, rax
    jz .L254
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt257: dq 1.0
section .text
    movsd xmm0, [rel .flt257]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setne al
    movzx rax, al
    test rax, rax
    jz .L254
    mov rax, 1
    jmp .L255
.L254:
    mov rax, 0
.L255:
    test rax, rax
    jz .L252
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl58:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_250
    jmp .L253
.L252:
.L253:
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl59:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_250
.__ret_250:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_mul_v4.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl57,164
    dq .kl58,165
    dq .kl59,166
.kfn: db "m4_mul_point", 0
section .text
m4_mul_dir:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-88], r11
    mov r11, [rdx + 8]
    mov [rbp-80], r11
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-88]
    push rax
section .data
.flt259: dq 0.0
section .text
    movsd xmm0, [rel .flt259]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl60:
    lea r11, [rbp-120]
    call v4_from3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-104]
    call m4_mul_v4
    add rsp, 32
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl61:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_258
.__ret_258:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_mul_point.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl60,170
    dq .kl61,171
.kfn: db "m4_mul_dir", 0
section .text
m4_translate:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    movups [rbp-144], xmm6
    movups [rbp-128], xmm7
    movups [rbp-112], xmm8
    mov [rbp-8], r11
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    sub rsp, 32
.kl62:
    lea r11, [rbp-96]
    call m4_identity
    add rsp, 32
    movaps xmm0, xmm8
    cvtsd2ss xmm0, xmm0
    movss [rbp-48], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-44], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-40], xmm0
    lea rax, [rbp-96]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_260
.__ret_260:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_mul_dir.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl62,174
.kfn: db "m4_translate", 0
section .text
m4_translation:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl63:
    mov r11, [rbp-8]
    call m4_translate
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_261
.__ret_261:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_translate.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl63,178
.kfn: db "m4_translation", 0
section .text
m4_scale:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    movups [rbp-144], xmm6
    movups [rbp-128], xmm7
    movups [rbp-112], xmm8
    mov [rbp-8], r11
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
    mov qword [rbp-96], 0
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    mov qword [rbp-40], 0
    movaps xmm0, xmm8
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-76], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-56], xmm0
section .data
.flt263: dq 1.0
section .text
    movsd xmm0, [rel .flt263]
    cvtsd2ss xmm0, xmm0
    movss [rbp-36], xmm0
    lea rax, [rbp-96]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_262
.__ret_262:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
m4_rotate_x:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    mov [rbp-8], r11
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl64:
    call fcos
    add rsp, 32
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl65:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    sub rsp, 32
.kl66:
    lea r11, [rbp-96]
    call m4_identity
    add rsp, 32
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-76], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-72], xmm0
section .data
.flt265: dq 0.0
section .text
    movsd xmm0, [rel .flt265]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-60], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-56], xmm0
    lea rax, [rbp-96]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_264
.__ret_264:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_translation.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl64,185
    dq .kl65,186
    dq .kl66,187
.kfn: db "m4_rotate_x", 0
section .text
m4_rotate_y:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    mov [rbp-8], r11
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl67:
    call fcos
    add rsp, 32
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl68:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    sub rsp, 32
.kl69:
    lea r11, [rbp-96]
    call m4_identity
    add rsp, 32
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
section .data
.flt267: dq 0.0
section .text
    movsd xmm0, [rel .flt267]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-88], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-64], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-56], xmm0
    lea rax, [rbp-96]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_266
.__ret_266:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate_x.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl67,192
    dq .kl68,193
    dq .kl69,194
.kfn: db "m4_rotate_y", 0
section .text
m4_rotate_z:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    mov [rbp-8], r11
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl70:
    call fcos
    add rsp, 32
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl71:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    sub rsp, 32
.kl72:
    lea r11, [rbp-96]
    call m4_identity
    add rsp, 32
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-92], xmm0
section .data
.flt269: dq 0.0
section .text
    movsd xmm0, [rel .flt269]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-80], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-76], xmm0
    lea rax, [rbp-96]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_268
.__ret_268:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate_y.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl70,199
    dq .kl71,200
    dq .kl72,201
.kfn: db "m4_rotate_z", 0
section .text
m4_rotate:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    movups [rbp-64], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    lea rax, [rbp-24]
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl73:
    lea r11, [rbp-48]
    call q_axis_angle
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call q_to_m4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_270
.__ret_270:
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate_z.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl73,206
.kfn: db "m4_rotate", 0
section .text
m4_perspective:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    movups [rbp-176], xmm6
    movups [rbp-160], xmm7
    movups [rbp-144], xmm8
    movups [rbp-128], xmm9
    mov [rbp-8], r11
    movaps xmm6, xmm0
    movaps xmm9, xmm1
    movaps xmm8, xmm2
    movaps xmm7, xmm3
section .data
.flt272: dq 1.0
section .text
    movsd xmm0, [rel .flt272]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt273: dq 0.5
section .text
    movsd xmm0, [rel .flt273]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl74:
    call ftan
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    mov qword [rbp-112], 0
    mov qword [rbp-104], 0
    mov qword [rbp-96], 0
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
    mov qword [rbp-56], 0
    movaps xmm0, xmm6
    movaps xmm1, xmm9
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-112], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-92], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-72], xmm0
section .data
.flt274: dq 0.0
section .text
    movsd xmm0, [rel .flt274]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt275: dq 1.0
section .text
    movsd xmm0, [rel .flt275]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-68], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-56], xmm0
    lea rax, [rbp-112]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_271
.__ret_271:
    movups xmm6, [rbp-176]
    movups xmm7, [rbp-160]
    movups xmm8, [rbp-144]
    movups xmm9, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl74,211
.kfn: db "m4_perspective", 0
section .text
m4_ortho:
    push rbp
    mov rbp, rsp
    sub rsp, 256
    movups [rbp-224], xmm6
    movups [rbp-208], xmm7
    movups [rbp-192], xmm8
    movups [rbp-176], xmm9
    movups [rbp-160], xmm10
    movups [rbp-144], xmm11
    mov [rbp-8], r11
    movaps xmm11, xmm0
    movaps xmm10, xmm1
    movaps xmm9, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm6, xmm5
    mov qword [rbp-120], 0
    mov qword [rbp-112], 0
    mov qword [rbp-104], 0
    mov qword [rbp-96], 0
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
section .data
.flt277: dq 2.0
section .text
    movsd xmm0, [rel .flt277]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm10
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-120], xmm0
section .data
.flt278: dq 2.0
section .text
    movsd xmm0, [rel .flt278]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-100], xmm0
section .data
.flt279: dq 1.0
section .text
    movsd xmm0, [rel .flt279]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-80], xmm0
    movaps xmm0, xmm10
    movaps xmm1, xmm11
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm11
    movaps xmm1, xmm10
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-72], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm9
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-68], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    divsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-64], xmm0
section .data
.flt280: dq 1.0
section .text
    movsd xmm0, [rel .flt280]
    cvtsd2ss xmm0, xmm0
    movss [rbp-60], xmm0
    lea rax, [rbp-120]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_276
.__ret_276:
    movups xmm6, [rbp-224]
    movups xmm7, [rbp-208]
    movups xmm8, [rbp-192]
    movups xmm9, [rbp-176]
    movups xmm10, [rbp-160]
    movups xmm11, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
m4_look_at:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov r11, [r8 + 0]
    mov [rbp-56], r11
    mov r11, [r8 + 8]
    mov [rbp-48], r11
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl75:
    lea r11, [rbp-88]
    call v3_sub
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    lea r11, [rbp-72]
    call v3_norm
    add rsp, 32
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl76:
    lea r11, [rbp-120]
    call v3_cross
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    lea r11, [rbp-104]
    call v3_norm
    add rsp, 32
    lea rax, [rbp-104]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl77:
    lea r11, [rbp-136]
    call v3_cross
    add rsp, 32
    sub rsp, 32
.kl78:
    lea r11, [rbp-200]
    call m4_identity
    add rsp, 32
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-200], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-184], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-168], xmm0
    movss xmm0, [rbp-136]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-196], xmm0
    movss xmm0, [rbp-132]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-180], xmm0
    movss xmm0, [rbp-128]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-164], xmm0
section .data
.flt282: dq 0.0
section .text
    movsd xmm0, [rel .flt282]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-192], xmm0
section .data
.flt283: dq 0.0
section .text
    movsd xmm0, [rel .flt283]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-176], xmm0
section .data
.flt284: dq 0.0
section .text
    movsd xmm0, [rel .flt284]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-160], xmm0
section .data
.flt285: dq 0.0
section .text
    movsd xmm0, [rel .flt285]
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-104]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl79:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-152], xmm0
section .data
.flt286: dq 0.0
section .text
    movsd xmm0, [rel .flt286]
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-136]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl80:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-148], xmm0
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl81:
    call v3_dot
    add rsp, 32
    cvtsd2ss xmm0, xmm0
    movss [rbp-144], xmm0
    lea rax, [rbp-200]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_281
.__ret_281:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_perspective.kft, .kfe, .kfn, __kron_file_1,7
    dq .kl75,233
    dq .kl76,234
    dq .kl77,235
    dq .kl78,236
    dq .kl79,240
    dq .kl80,241
    dq .kl81,242
.kfn: db "m4_look_at", 0
section .text
m4_transpose:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    mov qword [rbp-136], 0
    mov qword [rbp-128], 0
    mov qword [rbp-120], 0
    mov qword [rbp-112], 0
    mov qword [rbp-104], 0
    mov qword [rbp-96], 0
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-136], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-132], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-128], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-124], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-120], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-116], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-112], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-108], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-104], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-100], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-92], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-88], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-84], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-80], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-76], xmm0
    lea rax, [rbp-136]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_287
.__ret_287:
    mov rsp, rbp
    pop rbp
    ret
m4_inverse:
    push rbp
    mov rbp, rsp
    sub rsp, 608
    movups [rbp-576], xmm6
    movups [rbp-560], xmm7
    movups [rbp-544], xmm8
    movups [rbp-528], xmm9
    movups [rbp-512], xmm10
    movups [rbp-496], xmm11
    movups [rbp-480], xmm12
    movups [rbp-464], xmm13
    movups [rbp-448], xmm14
    movups [rbp-432], xmm15
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-72], r11
    mov r11, [rcx + 8]
    mov [rbp-64], r11
    mov r11, [rcx + 16]
    mov [rbp-56], r11
    mov r11, [rcx + 24]
    mov [rbp-48], r11
    mov r11, [rcx + 32]
    mov [rbp-40], r11
    mov r11, [rcx + 40]
    mov [rbp-32], r11
    mov r11, [rcx + 48]
    mov [rbp-24], r11
    mov r11, [rcx + 56]
    mov [rbp-16], r11
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    movaps xmm15, xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    movaps xmm14, xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    movaps xmm13, xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    movaps xmm12, xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movsd [rbp-112], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    movsd [rbp-120], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    movsd [rbp-128], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    movsd [rbp-136], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movsd [rbp-144], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movsd [rbp-152], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm11, xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm10, xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm9, xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm8, xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm7, xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm6, xmm0
    movsd xmm0, [rbp-120]
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-120]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-208], xmm0
section .data
.flt289: dq 0.0
section .text
    movsd xmm0, [rel .flt289]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-216], xmm0
    movsd xmm0, [rbp-112]
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-224], xmm0
section .data
.flt290: dq 0.0
section .text
    movsd xmm0, [rel .flt290]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-232], xmm0
section .data
.flt291: dq 0.0
section .text
    movsd xmm0, [rel .flt291]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm14
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm14
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-240], xmm0
    movaps xmm0, xmm15
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-248], xmm0
section .data
.flt292: dq 0.0
section .text
    movsd xmm0, [rel .flt292]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-256], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-264], xmm0
    movaps xmm0, xmm14
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm14
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-120]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-120]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-272], xmm0
section .data
.flt293: dq 0.0
section .text
    movsd xmm0, [rel .flt293]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-280], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movsd [rbp-288], xmm0
section .data
.flt294: dq 0.0
section .text
    movsd xmm0, [rel .flt294]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movsd [rbp-296], xmm0
section .data
.flt295: dq 0.0
section .text
    movsd xmm0, [rel .flt295]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm14
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm14
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-120]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-120]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-152]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm9, xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm8, xmm0
section .data
.flt296: dq 0.0
section .text
    movsd xmm0, [rel .flt296]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-136]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm12
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-112]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-152]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm14
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-128]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rbp-144]
    movaps xmm1, xmm13
    mulsd xmm0, xmm1
    movsd xmm1, [rbp-120]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm15
    movsd xmm1, [rbp-208]
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm14
    movsd xmm1, [rbp-216]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm13
    movsd xmm1, [rbp-224]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm12
    movsd xmm1, [rbp-232]
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm10, xmm0
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt299: dq 0.0
section .text
    movsd xmm0, [rel .flt299]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L297
section .data
.str300: db 116,104,105,115,32,109,97,116,114,105,120,32,104,97,115,32,110,111,32,105,110,118,101,114,115,101,0
section .text
    lea rax, [rel .str300]
    push rax
section .data
.str301: db 97,32,115,99,97,108,101,32,111,102,32,122,101,114,111,32,102,108,97,116,116,101,110,115,32,105,116,0
section .text
    lea rax, [rel .str301]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl82:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_288
    jmp .L298
.L297:
.L298:
section .data
.flt302: dq 1.0
section .text
    movsd xmm0, [rel .flt302]
    movaps xmm1, xmm10
    divsd xmm0, xmm1
    movaps xmm10, xmm0
    mov qword [rbp-408], 0
    mov qword [rbp-400], 0
    mov qword [rbp-392], 0
    mov qword [rbp-384], 0
    mov qword [rbp-376], 0
    mov qword [rbp-368], 0
    mov qword [rbp-360], 0
    mov qword [rbp-352], 0
    movsd xmm0, [rbp-208]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-408], xmm0
    movsd xmm0, [rbp-240]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-404], xmm0
    movsd xmm0, [rbp-272]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-400], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-396], xmm0
    movsd xmm0, [rbp-216]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-392], xmm0
    movsd xmm0, [rbp-248]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-388], xmm0
    movsd xmm0, [rbp-280]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-384], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-380], xmm0
    movsd xmm0, [rbp-224]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-376], xmm0
    movsd xmm0, [rbp-256]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-372], xmm0
    movsd xmm0, [rbp-288]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-368], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-364], xmm0
    movsd xmm0, [rbp-232]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-360], xmm0
    movsd xmm0, [rbp-264]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-356], xmm0
    movsd xmm0, [rbp-296]
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-352], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm10
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-348], xmm0
    lea rax, [rbp-408]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_288
.__ret_288:
    movups xmm6, [rbp-576]
    movups xmm7, [rbp-560]
    movups xmm8, [rbp-544]
    movups xmm9, [rbp-528]
    movups xmm10, [rbp-512]
    movups xmm11, [rbp-496]
    movups xmm12, [rbp-480]
    movups xmm13, [rbp-464]
    movups xmm14, [rbp-448]
    movups xmm15, [rbp-432]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_look_at.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl82,303
.kfn: db "m4_inverse", 0
section .text
m4_trs:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov r11, [r8 + 0]
    mov [rbp-56], r11
    mov r11, [r8 + 8]
    mov [rbp-48], r11
    lea rax, [rbp-40]
    push rax
    pop rcx
    sub rsp, 32
.kl83:
    lea r11, [rbp-120]
    call q_to_m4
    add rsp, 32
    movss xmm0, [rbp-120]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-120], xmm0
    movss xmm0, [rbp-116]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-116], xmm0
    movss xmm0, [rbp-112]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-112], xmm0
    movss xmm0, [rbp-104]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-104], xmm0
    movss xmm0, [rbp-100]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-100], xmm0
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-88], xmm0
    movss xmm0, [rbp-84]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-84], xmm0
    movss xmm0, [rbp-80]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-80], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-72], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-68], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    cvtsd2ss xmm0, xmm0
    movss [rbp-64], xmm0
    lea rax, [rbp-120]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_303
.__ret_303:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_inverse.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl83,329
.kfn: db "m4_trs", 0
section .text
q_identity:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov qword [rbp-24], 0
    mov qword [rbp-16], 0
section .data
.flt305: dq 1.0
section .text
    movsd xmm0, [rel .flt305]
    cvtsd2ss xmm0, xmm0
    movss [rbp-12], xmm0
    lea rax, [rbp-24]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rax, [rbp-8]
    jmp .__ret_304
.__ret_304:
    mov rsp, rbp
    pop rbp
    ret
quat:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    movups [rbp-96], xmm8
    movups [rbp-80], xmm9
    mov [rbp-8], r11
    movaps xmm9, xmm0
    movaps xmm8, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    movaps xmm0, xmm9
    cvtsd2ss xmm0, xmm0
    movss [rbp-56], xmm0
    movaps xmm0, xmm8
    cvtsd2ss xmm0, xmm0
    movss [rbp-52], xmm0
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-48], xmm0
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-44], xmm0
    lea rax, [rbp-56]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rax, [rbp-8]
    jmp .__ret_306
.__ret_306:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    movups xmm8, [rbp-96]
    movups xmm9, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
q_axis_angle:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    movups [rbp-80], xmm7
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movaps xmm7, xmm1
    lea rax, [rbp-24]
    push rax
    pop rcx
    sub rsp, 32
.kl84:
    lea r11, [rbp-48]
    call v3_norm
    add rsp, 32
section .data
.flt308: dq 0.5
section .text
    movsd xmm0, [rel .flt308]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl85:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt309: dq 0.5
section .text
    movsd xmm0, [rel .flt309]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl86:
    call fcos
    add rsp, 32
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
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_307
.__ret_307:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_trs.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl84,341
    dq .kl85,342
    dq .kl86,343
.kfn: db "q_axis_angle", 0
section .text
q_euler:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    movups [rbp-192], xmm6
    movups [rbp-176], xmm7
    movups [rbp-160], xmm8
    mov [rbp-8], r11
    movaps xmm8, xmm0
    movaps xmm7, xmm1
    movaps xmm6, xmm2
section .data
.flt311: dq 1.0
section .text
    movsd xmm0, [rel .flt311]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt312: dq 0.0
section .text
    movsd xmm0, [rel .flt312]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt313: dq 0.0
section .text
    movsd xmm0, [rel .flt313]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl87:
    lea r11, [rbp-64]
    call v3
    add rsp, 32
    push rax
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-48]
    call q_axis_angle
    add rsp, 32
section .data
.flt314: dq 0.0
section .text
    movsd xmm0, [rel .flt314]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt315: dq 1.0
section .text
    movsd xmm0, [rel .flt315]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt316: dq 0.0
section .text
    movsd xmm0, [rel .flt316]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl88:
    lea r11, [rbp-96]
    call v3
    add rsp, 32
    push rax
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-80]
    call q_axis_angle
    add rsp, 32
section .data
.flt317: dq 0.0
section .text
    movsd xmm0, [rel .flt317]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt318: dq 0.0
section .text
    movsd xmm0, [rel .flt318]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt319: dq 1.0
section .text
    movsd xmm0, [rel .flt319]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl89:
    lea r11, [rbp-128]
    call v3
    add rsp, 32
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-112]
    call q_axis_angle
    add rsp, 32
    lea rax, [rbp-80]
    push rax
    lea rax, [rbp-48]
    push rax
    lea rax, [rbp-112]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl90:
    lea r11, [rbp-144]
    call q_mul
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call q_mul
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_310
.__ret_310:
    movups xmm6, [rbp-192]
    movups xmm7, [rbp-176]
    movups xmm8, [rbp-160]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_axis_angle.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl87,348
    dq .kl88,349
    dq .kl89,350
    dq .kl90,351
.kfn: db "q_euler", 0
section .text
q_mul:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
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
.kl91:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_320
.__ret_320:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_euler.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl91,355
.kfn: db "q_mul", 0
section .text
q_dot:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov r11, [rcx + 0]
    mov [rbp-16], r11
    mov r11, [rcx + 8]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-32], r11
    mov r11, [rdx + 8]
    mov [rbp-24], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-4]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_321
.__ret_321:
    mov rsp, rbp
    pop rbp
    ret
q_conj:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
section .data
.flt323: dq 0.0
section .text
    movsd xmm0, [rel .flt323]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt324: dq 0.0
section .text
    movsd xmm0, [rel .flt324]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt325: dq 0.0
section .text
    movsd xmm0, [rel .flt325]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
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
.kl92:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_322
.__ret_322:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_mul.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl92,361
.kfn: db "q_conj", 0
section .text
q_norm:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    movups [rbp-48], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl93:
    call q_dot
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fsqrt
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt329: dq 0.0
section .text
    movsd xmm0, [rel .flt329]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L327
    sub rsp, 32
.kl94:
    mov r11, [rbp-8]
    call q_identity
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_326
    jmp .L328
.L327:
.L328:
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    divsd xmm0, xmm1
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
.kl95:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_326
.__ret_326:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_conj.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl93,363
    dq .kl94,364
    dq .kl95,365
.kfn: db "q_norm", 0
section .text
q_rotate:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl96:
    lea r11, [rbp-56]
    call v3
    add rsp, 32
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl97:
    lea r11, [rbp-88]
    call v3_cross
    add rsp, 32
    push rax
section .data
.flt331: dq 2.0
section .text
    movsd xmm0, [rel .flt331]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-72]
    call v3_scale
    add rsp, 32
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-72]
    push rax
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl98:
    lea r11, [rbp-120]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-104]
    call v3_add
    add rsp, 32
    push rax
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-136]
    call v3_cross
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_add
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_330
.__ret_330:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_norm.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl96,369
    dq .kl97,370
    dq .kl98,371
.kfn: db "q_rotate", 0
section .text
q_to_m4:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    movups [rbp-192], xmm6
    movups [rbp-176], xmm7
    movups [rbp-160], xmm8
    movups [rbp-144], xmm9
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm9, xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm8, xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm7, xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm6, xmm0
    mov qword [rbp-120], 0
    mov qword [rbp-112], 0
    mov qword [rbp-104], 0
    mov qword [rbp-96], 0
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
section .data
.flt333: dq 1.0
section .text
    movsd xmm0, [rel .flt333]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt334: dq 2.0
section .text
    movsd xmm0, [rel .flt334]
    sub rsp, 8
    movsd [rsp], xmm0
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-120], xmm0
section .data
.flt335: dq 2.0
section .text
    movsd xmm0, [rel .flt335]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-116], xmm0
section .data
.flt336: dq 2.0
section .text
    movsd xmm0, [rel .flt336]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-112], xmm0
section .data
.flt337: dq 2.0
section .text
    movsd xmm0, [rel .flt337]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-104], xmm0
section .data
.flt338: dq 1.0
section .text
    movsd xmm0, [rel .flt338]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt339: dq 2.0
section .text
    movsd xmm0, [rel .flt339]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm9
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
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-100], xmm0
section .data
.flt340: dq 2.0
section .text
    movsd xmm0, [rel .flt340]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
section .data
.flt341: dq 2.0
section .text
    movsd xmm0, [rel .flt341]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-88], xmm0
section .data
.flt342: dq 2.0
section .text
    movsd xmm0, [rel .flt342]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-84], xmm0
section .data
.flt343: dq 1.0
section .text
    movsd xmm0, [rel .flt343]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt344: dq 2.0
section .text
    movsd xmm0, [rel .flt344]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-80], xmm0
section .data
.flt345: dq 1.0
section .text
    movsd xmm0, [rel .flt345]
    cvtsd2ss xmm0, xmm0
    movss [rbp-60], xmm0
    lea rax, [rbp-120]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rcx, [rax+32]
    mov [rdx+32], rcx
    mov rcx, [rax+40]
    mov [rdx+40], rcx
    mov rcx, [rax+48]
    mov [rdx+48], rcx
    mov rcx, [rax+56]
    mov [rdx+56], rcx
    mov rax, [rbp-8]
    jmp .__ret_332
.__ret_332:
    movups xmm6, [rbp-192]
    movups xmm7, [rbp-176]
    movups xmm8, [rbp-160]
    movups xmm9, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
q_slerp:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    movups [rbp-192], xmm6
    movups [rbp-176], xmm7
    movups [rbp-160], xmm8
    movups [rbp-144], xmm9
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    movaps xmm9, xmm2
    lea rax, [rbp-40]
    lea rdx, [rbp-64]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl99:
    call q_dot
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt349: dq 0.0
section .text
    movsd xmm0, [rel .flt349]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L347
section .data
.flt350: dq 0.0
section .text
    movsd xmm0, [rel .flt350]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt351: dq 0.0
section .text
    movsd xmm0, [rel .flt351]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt352: dq 0.0
section .text
    movsd xmm0, [rel .flt352]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt353: dq 0.0
section .text
    movsd xmm0, [rel .flt353]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
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
.kl100:
    lea r11, [rbp-64]
    call quat
    add rsp, 32
section .data
.flt354: dq 0.0
section .text
    movsd xmm0, [rel .flt354]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L348
.L347:
.L348:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt357: dq 0.9995
section .text
    movsd xmm0, [rel .flt357]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L355
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
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
.kl101:
    lea r11, [rbp-88]
    call quat
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call q_norm
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_346
    jmp .L356
.L355:
.L356:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl102:
    call facos
    add rsp, 32
    movaps xmm8, xmm0
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl103:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
section .data
.flt358: dq 1.0
section .text
    movsd xmm0, [rel .flt358]
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl104:
    call fsin
    add rsp, 32
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl105:
    call fsin
    add rsp, 32
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
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
.kl106:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_346
.__ret_346:
    movups xmm6, [rbp-192]
    movups xmm7, [rbp-176]
    movups xmm8, [rbp-160]
    movups xmm9, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_rotate.kft, .kfe, .kfn, __kron_file_1,8
    dq .kl99,394
    dq .kl100,396
    dq .kl101,400
    dq .kl102,403
    dq .kl103,404
    dq .kl104,405
    dq .kl105,406
    dq .kl106,407
.kfn: db "q_slerp", 0
section .text
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
    jne .L360
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
.kl107:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L362
    mov rax, 0
    mov rbx, rax
    jmp .L363
.L362:
.L363:
    jmp .L361
.L360:
    mov rax, [rel __g_hp_valloc]
    cmp rax, 0
    jne .L364
section .data
.str366: db 107,101,114,110,101,108,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str366]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str367: db 86,105,114,116,117,97,108,65,108,108,111,99,0
section .text
    lea rax, [rel .str367]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_hp_valloc], rax
    mov rax, rbx
    push rax
section .data
.str368: db 86,105,114,116,117,97,108,70,114,101,101,0
section .text
    lea rax, [rel .str368]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_hp_vfree], rax
    jmp .L365
.L364:
.L365:
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
.kl108:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
.L361:
    mov rax, rbx
    jmp .__ret_359
.__ret_359:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_slerp.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl107,73
    dq .kl108,83
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
    jne .L370
    mov rax, 11
    push rax
    mov rax, r12
    push rax
    mov rax, rbx
    push rax
    pop rsi
    pop rdi
    pop rax
.kl109:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_hp_ignore], rax
    jmp .L371
.L370:
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
.kl110:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_hp_ignore], rax
.L371:
    mov rax, 0
    jmp .__ret_369
.__ret_369:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_os_alloc.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl109,92
    dq .kl110,94
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
.L373:
    mov rax, rbx
    add rax, 8
    cmp rax, r12
    jg .L374
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
.L375:
    jmp .L373
.L374:
.L376:
    cmp rbx, r12
    jge .L377
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
.L378:
    jmp .L376
.L377:
    mov rax, r14
    jmp .__ret_372
.__ret_372:
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
.L380:
    mov rax, rbx
    add rax, 8
    cmp rax, r12
    jg .L381
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add rbx, 8
.L382:
    jmp .L380
.L381:
.L383:
    cmp rbx, r12
    jge .L384
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L385:
    jmp .L383
.L384:
    mov rax, r13
    jmp .__ret_379
.__ret_379:
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
.L387:
    cmp rbx, r13
    jge .L388
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rbx, rax
    add r12, 1
.L389:
    jmp .L387
.L388:
    mov rax, r12
    jmp .__ret_386
.__ret_386:
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
    jge .L391
    mov rax, 1
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_390
    jmp .L392
.L391:
.L392:
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
    jle .L393
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
.kl111:
    call hp_os_alloc
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L395
    mov rax, 2
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_390
    jmp .L396
.L395:
.L396:
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
    jmp .__ret_390
    jmp .L394
.L393:
.L394:
    mov rcx, rbx
    sub rsp, 32
.kl112:
    call hp_class
    add rsp, 32
    mov r13, rax
    mov rax, 16
    mov rcx, r13
    shl rax, cl
    mov r12, rax
    mov rax, r13
    cmp rax, 17
    jb .L397
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl113:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_390
.L397:
    mov rcx, rax
    lea rdx, [rel __g_hp_free]
    mov rax, [rdx+rcx*8]
    mov r14, rax
    cmp r14, 0
    je .L398
    mov rax, r13
    cmp rax, 17
    jb .L400
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl114:
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_390
.L400:
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
.kl115:
    call hp_zero
    add rsp, 32
    mov rax, r14
    add rax, 16
    jmp .__ret_390
    jmp .L399
.L398:
.L399:
    mov rax, [rel __g_hp_cur]
    add rax, r12
    push rax
    mov rax, [rel __g_hp_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L401
    mov rax, [rel __g_HP_CHUNK]
    push rax
    pop rcx
    sub rsp, 32
.kl116:
    call hp_os_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L403
    mov rax, 2
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_390
    jmp .L404
.L403:
.L404:
    mov rax, rbx
    mov [rel __g_hp_cur], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_CHUNK]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_hp_end], rax
    jmp .L402
.L401:
.L402:
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
    jmp .__ret_390
.__ret_390:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_os_free.kft, .kfe, .kfn, __kron_file_2,6
    dq .kl111,153
    dq .kl112,164
    dq .kl113,166
    dq .kl114,169
    dq .kl115,172
    dq .kl116,176
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
    jne .L406
    mov rax, r12
    sub rax, 16
    jmp .__ret_405
    jmp .L407
.L406:
.L407:
    mov rax, 16
    mov rcx, r12
    shl rax, cl
    sub rax, 16
    jmp .__ret_405
.__ret_405:
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
    jne .L409
    mov rax, 0
    jmp .__ret_408
    jmp .L410
.L409:
.L410:
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
    jne .L411
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl117:
    call hp_os_free
    add rsp, 32
    mov rax, 0
    jmp .__ret_408
    jmp .L412
.L411:
.L412:
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_MAGIC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L413
    mov rax, 0
    jmp .__ret_408
    jmp .L414
.L413:
.L414:
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
    jb .L415
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl118:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_408
.L415:
    mov rcx, rax
    lea rdx, [rel __g_hp_free]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    cmp rax, 17
    jb .L416
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl119:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_408
.L416:
    push rax
    mov rax, r13
    pop rcx
    lea rdx, [rel __g_hp_free]
    mov [rdx+rcx*8], rax
    mov rax, 0
    jmp .__ret_408
.__ret_408:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_alloc.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl117,219
    dq .kl118,227
    dq .kl119,228
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
    jne .L418
    mov rcx, r13
    sub rsp, 32
.kl120:
    call hp_alloc
    add rsp, 32
    jmp .__ret_417
    jmp .L419
.L418:
.L419:
    mov rcx, r14
    sub rsp, 32
.kl121:
    call hp_room
    add rsp, 32
    mov r12, rax
    cmp r13, r12
    jg .L420
    mov rax, r14
    jmp .__ret_417
    jmp .L421
.L420:
.L421:
    mov rax, r12
    mov rcx, 2
    imul rax, rcx
    mov rbx, rax
    cmp rbx, r13
    jge .L422
    mov rax, r13
    mov rbx, rax
    jmp .L423
.L422:
.L423:
    mov rcx, rbx
    sub rsp, 32
.kl122:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L424
    mov rax, 0
    jmp .__ret_417
    jmp .L425
.L424:
.L425:
    mov rcx, rbx
    mov rdx, r14
    mov r8, r12
    sub rsp, 32
.kl123:
    call hp_copy
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl124:
    call hp_release
    add rsp, 32
    mov rax, rbx
    jmp .__ret_417
.__ret_417:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_release.kft, .kfe, .kfn, __kron_file_2,5
    dq .kl120,236
    dq .kl121,238
    dq .kl122,246
    dq .kl123,250
    dq .kl124,251
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
    je .L427
    mov rax, [rel __g_ob_freehead]
    sub rax, 1
    mov r14, rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
    add rax, rcx
    mov rax, [rax]
    mov [rel __g_ob_freehead], rax
    jmp .L428
.L427:
    mov rax, [rel __g_ob_count]
    push rax
    mov rax, [rel __g_ob_cap]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L429
    mov rax, [rel __g_ob_cap]
    mov rcx, 2
    imul rax, rcx
    mov r14, rax
    cmp r14, 1024
    jge .L431
    mov rax, 1024
    mov r14, rax
    jmp .L432
.L431:
.L432:
    mov rax, [rel __g_ob_ptr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl125:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L433
    mov rax, 0
    jmp .__ret_426
    jmp .L434
.L433:
.L434:
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
.kl126:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L435
    mov rax, 0
    jmp .__ret_426
    jmp .L436
.L435:
.L436:
    mov rax, rbx
    mov [rel __g_ob_meta], rax
    mov rax, r14
    mov [rel __g_ob_cap], rax
    jmp .L430
.L429:
.L430:
    mov rax, [rel __g_ob_count]
    mov r14, rax
    mov rax, [rel __g_ob_count]
    add rax, 1
    mov [rel __g_ob_count], rax
.L428:
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_meta]
    add rax, rcx
    mov rax, [rax]
    sar rax, 8
    mov rcx, 1073741823
    and rax, rcx
    mov rbx, rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_meta]
    add rax, rcx
    push rax
    mov rax, rbx
    shl rax, 8
    or rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    shl rax, 32
    mov rcx, rax
    mov rax, [rel __g_HP_TAG]
    or rax, rcx
    or rax, r14
    jmp .__ret_426
.__ret_426:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq hp_grow.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl125,268
    dq .kl126,273
.kfn: db "ob_new", 0
section .text
ob_is:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jge .L438
    mov rax, 0
    jmp .__ret_437
    jmp .L439
.L438:
.L439:
    mov rax, rbx
    push rax
    mov rax, [rel __g_HP_TAG]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    jne .L440
    mov rax, 0
    jmp .__ret_437
    jmp .L441
.L440:
.L441:
    mov rax, 1
    jmp .__ret_437
.__ret_437:
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
.kl127:
    call ob_is
    add rsp, 32
    cmp rax, 0
    jne .L443
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_442
    jmp .L444
.L443:
.L444:
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov r13, rax
    mov rax, rbx
    sar rax, 32
    mov rcx, 1073741823
    and rax, rcx
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_ob_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L445
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_442
    jmp .L446
.L445:
.L446:
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_meta]
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    sar rax, 8
    mov rcx, 1073741823
    and rax, rcx
    cmp rax, r12
    je .L447
    mov rax, 4
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_442
    jmp .L448
.L447:
.L448:
    mov rax, rbx
    and rax, 255
    cmp rax, r14
    je .L449
    mov rax, rbx
    and rax, 255
    cmp rax, 0
    jne .L451
    mov rax, 4
    mov [rel __g_hp_err], rax
    jmp .L452
.L451:
    mov rax, 3
    mov [rel __g_hp_err], rax
.L452:
    mov rax, 1
    neg rax
    jmp .__ret_442
    jmp .L450
.L449:
.L450:
    mov rax, r13
    jmp .__ret_442
.__ret_442:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ob_new.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl127,305
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
.kl128:
    call ob_slot
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jge .L454
    mov rax, 0
    jmp .__ret_453
    jmp .L455
.L454:
.L455:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_453
.__ret_453:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ob_slot.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl128,334
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
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_456
.__ret_456:
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
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_meta]
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    sar rax, 8
    add rax, 1
    mov rcx, 1073741823
    and rax, rcx
    mov rbx, rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_meta]
    add rax, rcx
    push rax
    mov rax, rbx
    shl rax, 8
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
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
    jmp .__ret_457
.__ret_457:
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
    jne .L459
    lea rax, [rel __g_tv_empty]
    mov [rel __g_tv_p], rax
    mov rax, 0
    mov [rel __g_tv_n], rax
    mov rax, 1
    jmp .__ret_458
    jmp .L460
.L459:
.L460:
    mov rcx, r12
    sub rsp, 32
.kl129:
    call ob_is
    add rsp, 32
    test rax, rax
    jz .L461
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl130:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L463
    mov rax, 0
    jmp .__ret_458
    jmp .L464
.L463:
.L464:
    mov rax, rbx
    mov rax, [rax]
    mov [rel __g_tv_n], rax
    mov rax, rbx
    add rax, 8
    mov [rel __g_tv_p], rax
    mov rax, 1
    jmp .__ret_458
    jmp .L462
.L461:
.L462:
    cmp r12, 65536
    jge .L465
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_458
    jmp .L466
.L465:
.L466:
    mov rax, r12
    mov rcx, 140737488355328
    cmp rax, rcx
    jl .L467
    mov rax, 3
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_458
    jmp .L468
.L467:
.L468:
    mov rax, 0
    mov rbx, rax
.L469:
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    cmp rax, 0
    je .L470
    add rbx, 1
.L471:
    jmp .L469
.L470:
    mov rax, r12
    mov [rel __g_tv_p], rax
    mov rax, rbx
    mov [rel __g_tv_n], rax
    mov rax, 1
    jmp .__ret_458
.__ret_458:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ob_get.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl129,374
    dq .kl130,375
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
.kl131:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L473
    mov rax, 0
    jmp .__ret_472
    jmp .L474
.L473:
.L474:
    mov rax, [rel __g_tv_p]
    mov [rbp-24], rax
    mov rax, [rel __g_tv_n]
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
.kl132:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L475
    mov rax, 0
    jmp .__ret_472
    jmp .L476
.L475:
.L476:
    mov rax, [rel __g_tv_p]
    mov [rbp-40], rax
    mov rax, [rel __g_tv_n]
    mov [rbp-48], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L477:
    cmp r14, r15
    jge .L478
    mov rax, r14
    mov rcx, [rbp-48]
    cmp rax, rcx
    jl .L480
    mov rax, 1
    mov r13, rax
    mov rax, r15
    mov r14, rax
    jmp .L481
.L480:
    mov rax, [rbp-24]
    add rax, r14
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, [rbp-40]
    add rax, r14
    movzx rax, byte [rax]
    mov rbx, rax
    cmp r12, rbx
    jge .L482
    mov rax, 1
    neg rax
    mov r13, rax
    mov rax, r15
    mov r14, rax
    jmp .L483
.L482:
    cmp r12, rbx
    jle .L484
    mov rax, 1
    mov r13, rax
    mov rax, r15
    mov r14, rax
    jmp .L485
.L484:
.L485:
.L483:
.L481:
    add r14, 1
.L479:
    jmp .L477
.L478:
    cmp r13, 0
    jne .L486
    mov rax, r15
    mov rcx, [rbp-48]
    cmp rax, rcx
    jge .L488
    mov rax, 1
    neg rax
    mov r13, rax
    jmp .L489
.L488:
.L489:
    jmp .L487
.L486:
.L487:
    mov rax, r13
    jmp .__ret_472
.__ret_472:
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
.kft: dq tv_view.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl131,406
    dq .kl132,411
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
    jmp .__ret_490
.__ret_490:
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
    jne .L492
section .data
.str494: db 110,101,103,97,116,105,118,101,32,115,105,122,101,0
section .text
    lea rax, [rel .str494]
    push rax
section .data
.str495: db 115,105,122,101,115,32,97,110,100,32,108,101,110,103,116,104,115,32,115,116,97,114,116,32,97,116,32,48,0
section .text
    lea rax, [rel .str495]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl133:
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L493
.L492:
    cmp rbx, 2
    jne .L496
section .data
.str498: db 111,117,116,32,111,102,32,109,101,109,111,114,121,0
section .text
    lea rax, [rel .str498]
    push rax
section .data
.str499: db 116,104,101,32,115,121,115,116,101,109,32,114,101,102,117,115,101,100,32,109,111,114,101,32,109,101,109,111,114,121,58,32,102,114,101,101,32,116,101,120,116,115,44,32,108,105,115,116,115,32,97,110,100,32,109,97,112,115,32,121,111,117,32,110
    db 111,32,108,111,110,103,101,114,32,110,101,101,100,0
section .text
    lea rax, [rel .str499]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl134:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L497
.L496:
    cmp rbx, 3
    jne .L500
section .data
.str502: db 110,111,116,32,116,104,101,32,107,105,110,100,32,111,102,32,118,97,108,117,101,32,116,104,105,115,32,102,117,110,99,116,105,111,110,32,116,97,107,101,115,0
section .text
    lea rax, [rel .str502]
    push rax
section .data
.str503: db 112,97,115,115,32,97,32,116,101,120,116,44,32,108,105,115,116,32,111,114,32,109,97,112,32,109,97,100,101,32,98,121,32,116,104,105,115,32,108,105,98,114,97,114,121,44,32,111,114,32,97,32,115,116,114,105,110,103,32,108,105,116,101,114
    db 97,108,32,119,104,101,114,101,32,97,32,116,101,120,116,32,105,115,32,97,115,107,101,100,32,102,111,114,0
section .text
    lea rax, [rel .str503]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl135:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L501
.L500:
    cmp rbx, 4
    jne .L504
section .data
.str506: db 117,115,101,100,32,97,102,116,101,114,32,105,116,32,119,97,115,32,102,114,101,101,100,0
section .text
    lea rax, [rel .str506]
    push rax
section .data
.str507: db 97,32,116,101,120,116,44,32,108,105,115,116,44,32,109,97,112,32,111,114,32,102,105,108,101,32,105,115,32,103,111,110,101,32,97,102,116,101,114,32,116,101,120,116,95,102,114,101,101,44,32,108,105,115,116,95,102,114,101,101,44,32,109,97
    db 112,95,102,114,101,101,32,111,114,32,102,105,108,101,95,99,108,111,115,101,0
section .text
    lea rax, [rel .str507]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl136:
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L505
.L504:
    cmp rbx, 5
    jne .L508
section .data
.str510: db 105,110,100,101,120,32,111,117,116,32,111,102,32,114,97,110,103,101,0
section .text
    lea rax, [rel .str510]
    push rax
section .data
.str511: db 116,104,101,32,105,110,100,101,120,32,104,97,115,32,116,111,32,103,111,32,102,114,111,109,32,48,32,116,111,32,116,104,101,32,108,101,110,103,116,104,32,109,105,110,117,115,32,111,110,101,0
section .text
    lea rax, [rel .str511]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl137:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L509
.L508:
    cmp rbx, 6
    jne .L512
section .data
.str514: db 107,101,121,32,110,111,116,32,102,111,117,110,100,0
section .text
    lea rax, [rel .str514]
    push rax
section .data
.str515: db 99,104,101,99,107,32,119,105,116,104,32,109,97,112,95,104,97,115,32,102,105,114,115,116,44,32,111,114,32,117,115,101,32,109,97,112,95,103,101,116,95,111,114,0
section .text
    lea rax, [rel .str515]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl138:
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L513
.L512:
    cmp rbx, 7
    jne .L516
section .data
.str518: db 110,111,116,32,97,32,110,117,109,98,101,114,0
section .text
    lea rax, [rel .str518]
    push rax
section .data
.str519: db 100,105,103,105,116,115,32,119,105,116,104,32,97,110,32,111,112,116,105,111,110,97,108,32,115,105,103,110,44,32,112,111,105,110,116,32,97,110,100,32,101,120,112,111,110,101,110,116,58,32,45,49,50,44,32,51,46,53,44,32,49,101,54,0
section .text
    lea rax, [rel .str519]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl139:
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L517
.L516:
    cmp rbx, 8
    jne .L520
section .data
.str522: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,111,112,101,110,101,100,0
section .text
    lea rax, [rel .str522]
    push rax
section .data
.str523: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,44,32,97,110,100,32,116,104,97,116,32,116,104,101,32,102,105,108,101,32,101,120,105,115,116,115,32,97,110,100,32,99,97,110,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str523]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl140:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L521
.L520:
    cmp rbx, 9
    jne .L524
section .data
.str526: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,119,114,105,116,116,101,110,0
section .text
    lea rax, [rel .str526]
    push rax
section .data
.str527: db 99,104,101,99,107,32,116,104,97,116,32,116,104,101,32,102,111,108,100,101,114,32,101,120,105,115,116,115,32,97,110,100,32,116,104,101,32,102,105,108,101,32,105,115,32,110,111,116,32,114,101,97,100,45,111,110,108,121,0
section .text
    lea rax, [rel .str527]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl141:
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L525
.L524:
    cmp rbx, 10
    jne .L528
section .data
.str530: db 116,104,101,32,108,105,115,116,32,105,115,32,101,109,112,116,121,0
section .text
    lea rax, [rel .str530]
    push rax
section .data
.str531: db 99,104,101,99,107,32,108,105,115,116,95,108,101,110,32,102,105,114,115,116,0
section .text
    lea rax, [rel .str531]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl142:
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L529
.L528:
    cmp rbx, 11
    jne .L532
section .data
.str534: db 116,104,101,32,102,111,108,100,101,114,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str534]
    push rax
section .data
.str535: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,32,97,110,100,32,116,104,97,116,32,105,116,32,105,115,32,97,32,102,111,108,100,101,114,0
section .text
    lea rax, [rel .str535]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl143:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L533
.L532:
    cmp rbx, 12
    jne .L536
section .data
.str538: db 116,104,101,32,112,114,111,103,114,97,109,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,117,110,0
section .text
    lea rax, [rel .str538]
    push rax
section .data
.str539: db 99,104,101,99,107,32,105,116,115,32,110,97,109,101,32,97,110,100,32,116,104,97,116,32,105,116,32,105,115,32,111,110,32,116,104,101,32,80,65,84,72,0
section .text
    lea rax, [rel .str539]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl144:
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L537
.L536:
    cmp rbx, 13
    jne .L540
section .data
.str542: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,100,101,108,101,116,101,100,32,111,114,32,114,101,110,97,109,101,100,0
section .text
    lea rax, [rel .str542]
    push rax
section .data
.str543: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,32,97,110,100,32,116,104,97,116,32,110,111,116,104,105,110,103,32,104,97,115,32,105,116,32,111,112,101,110,0
section .text
    lea rax, [rel .str543]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl145:
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L541
.L540:
    cmp rbx, 14
    jne .L544
section .data
.str546: db 116,104,101,32,102,111,108,100,101,114,32,99,111,117,108,100,32,110,111,116,32,98,101,32,109,97,100,101,0
section .text
    lea rax, [rel .str546]
    push rax
section .data
.str547: db 99,104,101,99,107,32,116,104,97,116,32,105,116,115,32,112,97,114,101,110,116,32,101,120,105,115,116,115,32,97,110,100,32,116,104,101,32,110,97,109,101,32,105,115,32,102,114,101,101,0
section .text
    lea rax, [rel .str547]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl146:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L545
.L544:
    cmp rbx, 15
    jne .L548
section .data
.str550: db 110,111,116,32,115,101,116,0
section .text
    lea rax, [rel .str550]
    push rax
section .data
.str551: db 116,104,101,32,101,110,118,105,114,111,110,109,101,110,116,32,118,97,114,105,97,98,108,101,32,100,111,101,115,32,110,111,116,32,101,120,105,115,116,58,32,99,104,101,99,107,32,119,105,116,104,32,101,110,118,95,104,97,115,0
section .text
    lea rax, [rel .str551]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl147:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L549
.L548:
    cmp rbx, 16
    jne .L552
section .data
.str554: db 116,104,101,32,102,105,108,101,32,105,115,32,99,108,111,115,101,100,32,111,114,32,119,97,115,32,111,112,101,110,101,100,32,102,111,114,32,115,111,109,101,116,104,105,110,103,32,101,108,115,101,0
section .text
    lea rax, [rel .str554]
    push rax
section .data
.str555: db 111,112,101,110,32,105,116,32,119,105,116,104,32,34,114,34,32,116,111,32,114,101,97,100,44,32,34,119,34,32,111,114,32,34,97,34,32,116,111,32,119,114,105,116,101,44,32,34,114,119,34,32,102,111,114,32,98,111,116,104,0
section .text
    lea rax, [rel .str555]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl148:
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L553
.L552:
    cmp rbx, 17
    jne .L556
section .data
.str558: db 116,104,101,32,112,105,99,116,117,114,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str558]
    push rax
section .data
.str559: db 80,78,71,44,32,98,97,115,101,108,105,110,101,32,74,80,69,71,32,40,110,111,116,32,112,114,111,103,114,101,115,115,105,118,101,41,44,32,111,114,32,66,77,80,32,111,102,32,50,52,32,111,114,32,51,50,32,98,105,116,115,59,32,116
    db 104,101,32,102,105,108,101,32,109,97,121,32,98,101,32,100,97,109,97,103,101,100,0
section .text
    lea rax, [rel .str559]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl149:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_491
    jmp .L557
.L556:
.L557:
.L553:
.L549:
.L545:
.L541:
.L537:
.L533:
.L529:
.L525:
.L521:
.L517:
.L513:
.L509:
.L505:
.L501:
.L497:
.L493:
    mov rax, 0
    jmp .__ret_491
.__ret_491:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tv_compare.kft, .kfe, .kfn, __kron_file_2,17
    dq .kl133,457
    dq .kl134,458
    dq .kl135,459
    dq .kl136,460
    dq .kl137,461
    dq .kl138,462
    dq .kl139,463
    dq .kl140,464
    dq .kl141,465
    dq .kl142,466
    dq .kl143,467
    dq .kl144,468
    dq .kl145,469
    dq .kl146,470
    dq .kl147,471
    dq .kl148,472
    dq .kl149,473
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
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl150:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L561
    mov rax, 0
    jmp .__ret_560
    jmp .L562
.L561:
.L562:
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl151:
    call ob_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L563
    mov rcx, r12
    sub rsp, 32
.kl152:
    call hp_release
    add rsp, 32
    jmp .L564
.L563:
.L564:
    mov rax, rbx
    jmp .__ret_560
.__ret_560:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq heap_fail.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl150,48
    dq .kl151,52
    dq .kl152,54
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
.kl153:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L566
    mov rax, 0
    jmp .__ret_565
    jmp .L567
.L566:
.L567:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_565
.__ret_565:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_new.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl153,60
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
.kl154:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L569
    mov rax, 0
    jmp .__ret_568
    jmp .L570
.L569:
.L570:
    mov rcx, rbx
    sub rsp, 32
.kl155:
    call hp_room
    add rsp, 32
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L571
    mov rax, rbx
    jmp .__ret_568
    jmp .L572
.L571:
.L572:
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl156:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L573
    mov rax, 0
    jmp .__ret_568
    jmp .L574
.L573:
.L574:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl157:
    call ob_put
    add rsp, 32
    mov rax, rbx
    jmp .__ret_568
.__ret_568:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_len.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl154,71
    dq .kl155,75
    dq .kl156,78
    dq .kl157,82
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
.kl158:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L576
    mov rax, 0
    jmp .__ret_575
    jmp .L577
.L576:
.L577:
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
.kl159:
    call li_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L578
    mov rax, 0
    jmp .__ret_575
    jmp .L579
.L578:
.L579:
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
    jmp .__ret_575
.__ret_575:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_room.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl158,87
    dq .kl159,93
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
.kl160:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L581
    mov rax, 0
    jmp .__ret_580
    jmp .L582
.L581:
.L582:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp r13, 0
    jge .L583
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_580
    jmp .L584
.L583:
.L584:
    cmp r13, rbx
    jl .L585
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_580
    jmp .L586
.L585:
.L586:
    mov rax, r12
    add rax, 8
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_580
.__ret_580:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_add.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl160,106
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
.kl161:
    call li_at
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L588
    mov rax, 0
    jmp .__ret_587
    jmp .L589
.L588:
.L589:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_587
.__ret_587:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_at.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl161,124
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
.kl162:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L591
    mov rax, 0
    jmp .__ret_590
    jmp .L592
.L591:
.L592:
    mov rcx, r12
    sub rsp, 32
.kl163:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl164:
    call hp_release
    add rsp, 32
    mov rax, 0
    jmp .__ret_590
.__ret_590:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_get.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl162,134
    dq .kl163,138
    dq .kl164,139
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
.kl165:
    call ob_get
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    cmp rax, 0
    jne .L594
    mov rax, 0
    jmp .__ret_593
    jmp .L595
.L594:
.L595:
    mov rax, 0
    mov r15, rax
    mov rax, [rbp-24]
    mov rax, [rax]
    mov r15, rax
    cmp r15, 2
    jge .L596
    mov rax, [rbp-8]
    jmp .__ret_593
    jmp .L597
.L596:
.L597:
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl166:
    call hp_alloc
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L598
    mov rax, 0
    jmp .__ret_593
    jmp .L599
.L598:
.L599:
    mov rax, [rbp-24]
    add rax, 8
    mov r14, rax
    mov rax, [rbp-40]
    mov [rbp-56], rax
    mov rax, 1
    mov [rbp-64], rax
.L600:
    mov rax, [rbp-64]
    cmp rax, r15
    jge .L601
    mov rax, 0
    mov rbx, rax
.L603:
    cmp rbx, r15
    jge .L604
    mov rax, rbx
    mov rcx, [rbp-64]
    add rax, rcx
    mov [rbp-80], rax
    mov rax, [rbp-80]
    cmp rax, r15
    jle .L606
    mov rax, r15
    mov [rbp-80], rax
    jmp .L607
.L606:
.L607:
    mov rax, [rbp-64]
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, rbx
    add rax, rcx
    mov [rbp-88], rax
    mov rax, [rbp-88]
    cmp rax, r15
    jle .L608
    mov rax, r15
    mov [rbp-88], rax
    jmp .L609
.L608:
.L609:
    mov rax, rbx
    mov r13, rax
    mov rax, [rbp-80]
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
.L610:
    mov rax, rbx
    mov rcx, [rbp-88]
    cmp rax, rcx
    jge .L611
    mov rax, 0
    mov [rbp-120], rax
    mov rax, r13
    mov rcx, [rbp-80]
    cmp rax, rcx
    jl .L613
    mov rax, 1
    mov [rbp-120], rax
    jmp .L614
.L613:
    mov rax, r12
    mov rcx, [rbp-88]
    cmp rax, rcx
    jge .L615
    mov rax, 0
    mov [rbp-128], rax
    mov rax, 0
    mov [rbp-136], rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    mov rax, [rax]
    mov [rbp-128], rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    mov rax, [rax]
    mov [rbp-136], rax
    mov rcx, [rbp-136]
    mov rdx, [rbp-128]
    mov r8, [rbp-16]
    sub rsp, 32
.kl167:
    call li_less
    add rsp, 32
    test rax, rax
    jz .L617
    mov rax, 1
    mov [rbp-120], rax
    jmp .L618
.L617:
.L618:
    jmp .L616
.L615:
.L616:
.L614:
    mov rax, [rbp-120]
    test rax, rax
    jz .L619
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-56]
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L620
.L619:
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-56]
    add rax, rcx
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
.L620:
    mov rax, [rbp-120]
    test rax, rax
    jz .L621
    add r12, 1
    jmp .L622
.L621:
    add r13, 1
.L622:
    add rbx, 1
.L612:
    jmp .L610
.L611:
    mov rax, [rbp-88]
    mov rbx, rax
.L605:
    jmp .L603
.L604:
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
.L602:
    jmp .L600
.L601:
    mov rax, r14
    push rax
    mov rax, [rbp-24]
    add rax, 8
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L623
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
.kl168:
    call hp_copy
    add rsp, 32
    jmp .L624
.L623:
.L624:
    mov rcx, [rbp-40]
    sub rsp, 32
.kl169:
    call hp_release
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_593
.__ret_593:
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
.kft: dq li_free.kft, .kfe, .kfn, __kron_file_3,5
    dq .kl165,146
    dq .kl166,155
    dq .kl167,187
    dq .kl168,213
    dq .kl169,215
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
    jne .L626
    cmp r13, r12
    jge .L628
    mov rax, 1
    jmp .__ret_625
    jmp .L629
.L628:
.L629:
    mov rax, 0
    jmp .__ret_625
    jmp .L627
.L626:
.L627:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl170:
    call tv_compare
    add rsp, 32
    cmp rax, 0
    jge .L630
    mov rax, 1
    jmp .__ret_625
    jmp .L631
.L630:
.L631:
    mov rax, 0
    jmp .__ret_625
.__ret_625:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_sort.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl170,226
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
.kl171:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L633
    mov rcx, rbx
    sub rsp, 32
.kl172:
    call heap_fail
    add rsp, 32
    jmp .__ret_632
    jmp .L634
.L633:
.L634:
    mov rax, r12
    jmp .__ret_632
.__ret_632:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_less.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl171,235
    dq .kl172,238
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
.kl173:
    call li_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_635
.__ret_635:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_end.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl173,245
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
.kl174:
    call li_free
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_636
.__ret_636:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_new.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl174,250
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
.kl175:
    call li_len
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_637
.__ret_637:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_free.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl175,255
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
.kl176:
    call li_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_638
.__ret_638:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_len.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl176,260
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
.kl177:
    call li_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_639
.__ret_639:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl177,265
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
.kl178:
    call li_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L641
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L642
.L641:
.L642:
    mov rcx, r12
    sub rsp, 32
.kl179:
    call list_end
    add rsp, 32
    jmp .__ret_640
.__ret_640:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl178,270
    dq .kl179,274
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
.kl180:
    call li_len
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L644
    cmp r12, 0
    jne .L646
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L647
.L646:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl181:
    call li_get
    add rsp, 32
    mov rbx, rax
.L647:
    jmp .L645
.L644:
.L645:
    mov rcx, rbx
    sub rsp, 32
.kl182:
    call list_end
    add rsp, 32
    jmp .__ret_643
.__ret_643:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_set.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl180,279
    dq .kl181,285
    dq .kl182,288
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
.kl183:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L649
    cmp r13, 0
    jne .L651
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L652
.L651:
    mov rax, rbx
    push rax
    mov rax, r13
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl184:
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
.kl185:
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
.L652:
    jmp .L650
.L649:
.L650:
    mov rcx, r12
    sub rsp, 32
.kl186:
    call list_end
    add rsp, 32
    jmp .__ret_648
.__ret_648:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_last.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl183,293
    dq .kl184,299
    dq .kl185,300
    dq .kl186,304
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
.kl187:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L654
    cmp r14, 0
    jge .L656
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L657
.L656:
    cmp r14, r13
    jle .L658
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L659
.L658:
    mov rax, r15
    push rax
    mov rax, r13
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl188:
    call li_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L660
    mov rax, r13
    mov rbx, rax
.L662:
    cmp rbx, r14
    jle .L663
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
.L664:
    jmp .L662
.L663:
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
    jmp .L661
.L660:
.L661:
.L659:
.L657:
    jmp .L655
.L654:
.L655:
    mov rcx, r15
    sub rsp, 32
.kl189:
    call list_end
    add rsp, 32
    jmp .__ret_653
.__ret_653:
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
.kft: dq list_pop.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl187,309
    dq .kl188,316
    dq .kl189,330
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
.kl190:
    call li_get
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L666
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl191:
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
.L668:
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L669
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
.L670:
    jmp .L668
.L669:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L667
.L666:
.L667:
    mov rcx, r14
    sub rsp, 32
.kl192:
    call list_end
    add rsp, 32
    jmp .__ret_665
.__ret_665:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_insert.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl190,335
    dq .kl191,337
    dq .kl192,349
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
.kl193:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L672
    mov rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L673
.L672:
.L673:
    mov rcx, r12
    sub rsp, 32
.kl194:
    call list_end
    add rsp, 32
    jmp .__ret_671
.__ret_671:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_remove.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl193,354
    dq .kl194,358
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
.kl195:
    call ob_get
    add rsp, 32
    mov r14, rax
    mov rax, 1
    neg rax
    mov r13, rax
    cmp r14, 0
    je .L675
    mov rax, r14
    mov rax, [rax]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L677:
    cmp rbx, r12
    jge .L678
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
    jne .L680
    mov rax, rbx
    mov r13, rax
    mov rax, r12
    mov rbx, rax
    jmp .L681
.L680:
.L681:
    add rbx, 1
.L679:
    jmp .L677
.L678:
    jmp .L676
.L675:
.L676:
    mov rcx, r13
    sub rsp, 32
.kl196:
    call list_end
    add rsp, 32
    jmp .__ret_674
.__ret_674:
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
.kft: dq list_clear.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl195,363
    dq .kl196,378
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
.kl197:
    call li_sort
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_682
.__ret_682:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_find.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl197,383
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
.kl198:
    call ob_get
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    je .L684
    mov rax, r14
    mov rax, [rax]
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L686:
    cmp r13, r12
    jge .L687
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
.L688:
    jmp .L686
.L687:
    jmp .L685
.L684:
.L685:
    mov rcx, r15
    sub rsp, 32
.kl199:
    call list_end
    add rsp, 32
    jmp .__ret_683
.__ret_683:
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
.kft: dq list_sort.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl198,388
    dq .kl199,403
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
.kl200:
    call li_len
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L690
    mov rcx, r14
    sub rsp, 32
.kl201:
    call li_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    je .L692
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl202:
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
.kl203:
    call ob_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r12
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl204:
    call hp_copy
    add rsp, 32
    jmp .L693
.L692:
.L693:
    jmp .L691
.L690:
.L691:
    mov rcx, r13
    sub rsp, 32
.kl205:
    call list_end
    add rsp, 32
    jmp .__ret_689
.__ret_689:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_reverse.kft, .kfe, .kfn, __kron_file_3,6
    dq .kl200,408
    dq .kl201,411
    dq .kl202,413
    dq .kl203,414
    dq .kl204,415
    dq .kl205,418
.kfn: db "list_copy", 0
section .text
list_sget:
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
.kl206:
    call list_get
    add rsp, 32
    jmp .__ret_694
.__ret_694:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_copy.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl206,428
.kfn: db "list_sget", 0
section .text
list_sset:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl207:
    call list_set
    add rsp, 32
    jmp .__ret_695
.__ret_695:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_sget.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl207,432
.kfn: db "list_sset", 0
section .text
li_at_n:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov r13, r8
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl208:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L697
    mov rax, 0
    jmp .__ret_696
    jmp .L698
.L697:
.L698:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp r14, 0
    jge .L699
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_696
    jmp .L700
.L699:
.L700:
    mov rax, r14
    push rax
    mov rax, rbx
    mov rcx, r13
    cqo
    idiv rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L701
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_696
    jmp .L702
.L701:
.L702:
    mov rax, r12
    add rax, 8
    push rax
    mov rax, r14
    imul rax, r13
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_696
.__ret_696:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_sset.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl208,438
.kfn: db "li_at_n", 0
section .text
list_len_n:
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
    sub rsp, 32
.kl209:
    call li_len
    add rsp, 32
    mov rcx, rbx
    cqo
    idiv rcx
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_703
.__ret_703:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_at_n.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl209,457
.kfn: db "list_len_n", 0
section .text
list_add_n:
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
    mov rcx, r15
    sub rsp, 32
.kl210:
    call li_len
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L705
    mov rax, r15
    push rax
    mov rax, r12
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl211:
    call li_room
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L707
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, r12
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
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl212:
    call hp_copy
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, r12
    add rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L708
.L707:
.L708:
    jmp .L706
.L705:
.L706:
    mov rcx, r15
    sub rsp, 32
.kl213:
    call list_end
    add rsp, 32
    jmp .__ret_704
.__ret_704:
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
.kft: dq list_len_n.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl210,462
    dq .kl211,464
    dq .kl212,466
    dq .kl213,470
.kfn: db "list_add_n", 0
section .text
list_get_n:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rbx, rdx
    mov r13, r8
    mov r12, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r14
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
.kl214:
    call li_at_n
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L710
    mov rax, r13
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl215:
    call hp_copy
    add rsp, 32
    jmp .L711
.L710:
.L711:
    mov rcx, r13
    sub rsp, 32
.kl216:
    call list_end
    add rsp, 32
    jmp .__ret_709
.__ret_709:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add_n.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl214,475
    dq .kl215,477
    dq .kl216,479
.kfn: db "list_get_n", 0
section .text
list_set_n:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov rbx, rdx
    mov r13, r8
    mov r12, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r14
    mov rdx, rbx
    mov r8, r12
    sub rsp, 32
.kl217:
    call li_at_n
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L713
    mov rax, rbx
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl218:
    call hp_copy
    add rsp, 32
    jmp .L714
.L713:
.L714:
    mov rcx, r14
    sub rsp, 32
.kl219:
    call list_end
    add rsp, 32
    jmp .__ret_712
.__ret_712:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get_n.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl217,484
    dq .kl218,486
    dq .kl219,488
.kfn: db "list_set_n", 0
section .text
list_insert_n:
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
    mov [rbp-24], r8
    mov r14, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, [rbp-8]
    sub rsp, 32
.kl220:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L716
    cmp r15, 0
    jge .L718
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L719
.L718:
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, r14
    cqo
    idiv rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L720
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L721
.L720:
    mov rax, [rbp-8]
    push rax
    mov rax, r13
    add rax, r14
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl221:
    call li_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L722
    mov rax, r13
    sub rax, 1
    mov rbx, rax
.L724:
    mov rax, rbx
    push rax
    mov rax, r15
    imul rax, r14
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L725
    mov rax, r12
    add rax, 8
    push rax
    mov rax, rbx
    add rax, r14
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
.L726:
    jmp .L724
.L725:
    mov rax, r12
    add rax, 8
    push rax
    mov rax, r15
    imul rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl222:
    call hp_copy
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, r13
    add rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L723
.L722:
.L723:
.L721:
.L719:
    jmp .L717
.L716:
.L717:
    mov rcx, [rbp-8]
    sub rsp, 32
.kl223:
    call list_end
    add rsp, 32
    jmp .__ret_715
.__ret_715:
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
.kft: dq list_set_n.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl220,493
    dq .kl221,500
    dq .kl222,509
    dq .kl223,514
.kfn: db "list_insert_n", 0
section .text
list_remove_n:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r13, rcx
    mov rbx, rdx
    mov r15, r8
    mov r14, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r13
    mov rdx, rbx
    mov r8, r14
    sub rsp, 32
.kl224:
    call li_at_n
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L728
    mov rax, r15
    push rax
    mov rax, r12
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl225:
    call hp_copy
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl226:
    call ob_get
    add rsp, 32
    mov r13, rax
    mov rax, r13
    mov rax, [rax]
    mov r12, rax
    mov rax, rbx
    imul rax, r14
    mov rbx, rax
.L730:
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, r14
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L731
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
    add rax, r14
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
.L732:
    jmp .L730
.L731:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L729
.L728:
.L729:
    mov rcx, r15
    sub rsp, 32
.kl227:
    call list_end
    add rsp, 32
    jmp .__ret_727
.__ret_727:
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
.kft: dq list_insert_n.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl224,519
    dq .kl225,521
    dq .kl226,522
    dq .kl227,533
.kfn: db "list_remove_n", 0
section .text
list_last_n:
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
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl228:
    call li_len
    add rsp, 32
    mov rcx, r12
    cqo
    idiv rcx
    mov rbx, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L734
    cmp rbx, 0
    jne .L736
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L737
.L736:
    mov rax, r13
    push rax
    mov rax, r14
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
.kl229:
    call li_at_n
    add rsp, 32
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call hp_copy
    add rsp, 32
.L737:
    jmp .L735
.L734:
.L735:
    mov rcx, r13
    sub rsp, 32
.kl230:
    call list_end
    add rsp, 32
    jmp .__ret_733
.__ret_733:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_remove_n.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl228,538
    dq .kl229,543
    dq .kl230,546
.kfn: db "list_last_n", 0
section .text
list_pop_n:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov r13, r8
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl231:
    call li_len
    add rsp, 32
    mov rcx, r13
    cqo
    idiv rcx
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L739
    cmp r12, 0
    jne .L741
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L742
.L741:
    mov rax, r14
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r13
    sub rsp, 32
.kl232:
    call li_at_n
    add rsp, 32
    push rax
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call hp_copy
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl233:
    call ob_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, 1
    imul rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
.L742:
    jmp .L740
.L739:
.L740:
    mov rcx, r14
    sub rsp, 32
.kl234:
    call list_end
    add rsp, 32
    jmp .__ret_738
.__ret_738:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_last_n.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl231,551
    dq .kl232,556
    dq .kl233,557
    dq .kl234,561
.kfn: db "list_pop_n", 0
section .text
list_reverse_n:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl235:
    call ob_get
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    je .L744
    mov rax, r14
    mov rax, [rax]
    mov rcx, r15
    cqo
    idiv rcx
    mov rbx, rax
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L746:
    cmp r13, r12
    jge .L747
    mov rax, 0
    mov rbx, rax
.L749:
    cmp rbx, r15
    jge .L750
    mov rax, r14
    add rax, 8
    push rax
    mov rax, r13
    imul rax, r15
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-64], rax
    mov rax, r14
    add rax, 8
    push rax
    mov rax, r12
    imul rax, r15
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-72], rax
    mov rax, [rbp-64]
    mov rax, [rax]
    mov [rbp-80], rax
    mov rax, [rbp-64]
    push rax
    mov rax, [rbp-72]
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rbp-72]
    push rax
    mov rax, [rbp-80]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add rbx, 1
.L751:
    jmp .L749
.L750:
    add r13, 1
    sub r12, 1
.L748:
    jmp .L746
.L747:
    jmp .L745
.L744:
.L745:
    mov rcx, [rbp-8]
    sub rsp, 32
.kl236:
    call list_end
    add rsp, 32
    jmp .__ret_743
.__ret_743:
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
.kft: dq list_pop_n.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl235,566
    dq .kl236,587
.kfn: db "list_reverse_n", 0
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
.kl237:
    call li_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_752
.__ret_752:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_reverse_n.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl237,597
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
.kl238:
    call li_get
    add rsp, 32
    mov rbx, rax
section .data
.flt754: dq 0.0
section .text
    movsd xmm0, [rel .flt754]
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
.kl239:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L755
    mov rcx, rbx
    sub rsp, 32
.kl240:
    call heap_fail
    add rsp, 32
section .data
.flt757: dq 0.0
section .text
    movsd xmm0, [rel .flt757]
    jmp .__ret_753
    jmp .L756
.L755:
.L756:
    movaps xmm0, xmm6
    jmp .__ret_753
.__ret_753:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add_real.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl238,602
    dq .kl239,608
    dq .kl240,611
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
.kl241:
    call li_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L759
    movaps xmm0, xmm6
    movsd [rel __g_li_real], xmm0
    mov rax, rbx
    push rax
    lea rax, [rel __g_li_real]
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L760
.L759:
.L760:
    sub rsp, 32
.kl242:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L761
    mov rcx, rbx
    sub rsp, 32
.kl243:
    call heap_fail
    add rsp, 32
section .data
.flt763: dq 0.0
section .text
    movsd xmm0, [rel .flt763]
    jmp .__ret_758
    jmp .L762
.L761:
.L762:
    movaps xmm0, xmm6
    jmp .__ret_758
.__ret_758:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get_real.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl241,619
    dq .kl242,626
    dq .kl243,629
.kfn: db "list_set_real", 0
section .text
aabb:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl244:
    lea r11, [rbp-88]
    call v3_min
    add rsp, 32
    push rax
    lea rax, [rbp-72]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl245:
    lea r11, [rbp-104]
    call v3_max
    add rsp, 32
    push rax
    lea rax, [rbp-56]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-72]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rax, [rbp-8]
    jmp .__ret_764
.__ret_764:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_set_real.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl244,45
    dq .kl245,46
.kfn: db "aabb", 0
section .text
aabb_at:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl246:
    lea r11, [rbp-56]
    call v3_sub
    add rsp, 32
    push rax
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-72]
    call v3_add
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call aabb
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_765
.__ret_765:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl246,51
.kfn: db "aabb_at", 0
section .text
aabb_center:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-40], r11
    mov r11, [rcx + 8]
    mov [rbp-32], r11
    mov r11, [rcx + 16]
    mov [rbp-24], r11
    mov r11, [rcx + 24]
    mov [rbp-16], r11
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl247:
    lea r11, [rbp-56]
    call v3_add
    add rsp, 32
    push rax
section .data
.flt767: dq 0.5
section .text
    movsd xmm0, [rel .flt767]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_scale
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_766
.__ret_766:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb_at.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl247,55
.kfn: db "aabb_center", 0
section .text
aabb_overlap:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rcx + 24]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-64], r11
    mov r11, [rdx + 8]
    mov [rbp-56], r11
    mov r11, [rdx + 16]
    mov [rbp-48], r11
    mov r11, [rdx + 24]
    mov [rbp-40], r11
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L771
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L771
    mov rax, 0
    jmp .L772
.L771:
    mov rax, 1
.L772:
    test rax, rax
    jz .L769
    mov rax, 0
    jmp .__ret_768
    jmp .L770
.L769:
.L770:
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L775
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L775
    mov rax, 0
    jmp .L776
.L775:
    mov rax, 1
.L776:
    test rax, rax
    jz .L773
    mov rax, 0
    jmp .__ret_768
    jmp .L774
.L773:
.L774:
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L779
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L779
    mov rax, 0
    jmp .L780
.L779:
    mov rax, 1
.L780:
    test rax, rax
    jz .L777
    mov rax, 0
    jmp .__ret_768
    jmp .L778
.L777:
.L778:
    mov rax, 1
    jmp .__ret_768
.__ret_768:
    mov rsp, rbp
    pop rbp
    ret
aabb_contains:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rcx + 24]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-48], r11
    mov r11, [rdx + 8]
    mov [rbp-40], r11
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L784
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L784
    mov rax, 0
    jmp .L785
.L784:
    mov rax, 1
.L785:
    test rax, rax
    jz .L782
    mov rax, 0
    jmp .__ret_781
    jmp .L783
.L782:
.L783:
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L788
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L788
    mov rax, 0
    jmp .L789
.L788:
    mov rax, 1
.L789:
    test rax, rax
    jz .L786
    mov rax, 0
    jmp .__ret_781
    jmp .L787
.L786:
.L787:
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L792
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L792
    mov rax, 0
    jmp .L793
.L792:
    mov rax, 1
.L793:
    test rax, rax
    jz .L790
    mov rax, 0
    jmp .__ret_781
    jmp .L791
.L790:
.L791:
    mov rax, 1
    jmp .__ret_781
.__ret_781:
    mov rsp, rbp
    pop rbp
    ret
aabb_union:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-40], r11
    mov r11, [rcx + 8]
    mov [rbp-32], r11
    mov r11, [rcx + 16]
    mov [rbp-24], r11
    mov r11, [rcx + 24]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-72], r11
    mov r11, [rdx + 8]
    mov [rbp-64], r11
    mov r11, [rdx + 16]
    mov [rbp-56], r11
    mov r11, [rdx + 24]
    mov [rbp-48], r11
    mov qword [rbp-104], 0
    mov qword [rbp-96], 0
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl248:
    lea r11, [rbp-120]
    call v3_min
    add rsp, 32
    push rax
    lea rax, [rbp-104]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl249:
    lea r11, [rbp-136]
    call v3_max
    add rsp, 32
    push rax
    lea rax, [rbp-88]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-104]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rax, [rbp-8]
    jmp .__ret_794
.__ret_794:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb_center.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl248,74
    dq .kl249,75
.kfn: db "aabb_union", 0
section .text
aabb_move:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-40], r11
    mov r11, [rcx + 8]
    mov [rbp-32], r11
    mov r11, [rcx + 16]
    mov [rbp-24], r11
    mov r11, [rcx + 24]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-56], r11
    mov r11, [rdx + 8]
    mov [rbp-48], r11
    mov qword [rbp-88], 0
    mov qword [rbp-80], 0
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl250:
    lea r11, [rbp-104]
    call v3_add
    add rsp, 32
    push rax
    lea rax, [rbp-88]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl251:
    lea r11, [rbp-120]
    call v3_add
    add rsp, 32
    push rax
    lea rax, [rbp-72]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-88]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rax, [rbp-8]
    jmp .__ret_795
.__ret_795:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb_union.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl250,81
    dq .kl251,82
.kfn: db "aabb_move", 0
section .text
aabb_push:
    push rbp
    mov rbp, rsp
    sub rsp, 288
    movups [rbp-256], xmm6
    movups [rbp-240], xmm7
    movups [rbp-224], xmm8
    movups [rbp-208], xmm9
    movups [rbp-192], xmm10
    movups [rbp-176], xmm11
    movups [rbp-160], xmm12
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-40], r11
    mov r11, [rcx + 8]
    mov [rbp-32], r11
    mov r11, [rcx + 16]
    mov [rbp-24], r11
    mov r11, [rcx + 24]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-72], r11
    mov r11, [rdx + 8]
    mov [rbp-64], r11
    mov r11, [rdx + 16]
    mov [rbp-56], r11
    mov r11, [rdx + 24]
    mov [rbp-48], r11
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl252:
    call aabb_overlap
    add rsp, 32
    cmp rax, 0
    jne .L797
section .data
.flt799: dq 0.0
section .text
    movsd xmm0, [rel .flt799]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt800: dq 0.0
section .text
    movsd xmm0, [rel .flt800]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt801: dq 0.0
section .text
    movsd xmm0, [rel .flt801]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_796
    jmp .L798
.L797:
.L798:
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm12, xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm11, xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm10, xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm9, xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm8, xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm12
    movaps xmm6, xmm0
    movaps xmm0, xmm12
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt802: dq 0.0
section .text
    movsd xmm0, [rel .flt802]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt803: dq 0.0
section .text
    movsd xmm0, [rel .flt803]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl253:
    lea r11, [rbp-144]
    call v3
    add rsp, 32
    movaps xmm0, xmm11
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
    jz .L804
    movaps xmm0, xmm11
    movaps xmm6, xmm0
section .data
.flt806: dq 0.0
section .text
    movsd xmm0, [rel .flt806]
    movaps xmm1, xmm11
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt807: dq 0.0
section .text
    movsd xmm0, [rel .flt807]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt808: dq 0.0
section .text
    movsd xmm0, [rel .flt808]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl254:
    lea r11, [rbp-144]
    call v3
    add rsp, 32
    jmp .L805
.L804:
.L805:
    movaps xmm0, xmm10
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
    jz .L809
    movaps xmm0, xmm10
    movaps xmm6, xmm0
section .data
.flt811: dq 0.0
section .text
    movsd xmm0, [rel .flt811]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt812: dq 0.0
section .text
    movsd xmm0, [rel .flt812]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl255:
    lea r11, [rbp-144]
    call v3
    add rsp, 32
    jmp .L810
.L809:
.L810:
    movaps xmm0, xmm9
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
    jz .L813
    movaps xmm0, xmm9
    movaps xmm6, xmm0
section .data
.flt815: dq 0.0
section .text
    movsd xmm0, [rel .flt815]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt816: dq 0.0
section .text
    movsd xmm0, [rel .flt816]
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt817: dq 0.0
section .text
    movsd xmm0, [rel .flt817]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl256:
    lea r11, [rbp-144]
    call v3
    add rsp, 32
    jmp .L814
.L813:
.L814:
    movaps xmm0, xmm8
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
    jz .L818
    movaps xmm0, xmm8
    movaps xmm6, xmm0
section .data
.flt820: dq 0.0
section .text
    movsd xmm0, [rel .flt820]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt821: dq 0.0
section .text
    movsd xmm0, [rel .flt821]
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
.kl257:
    lea r11, [rbp-144]
    call v3
    add rsp, 32
    jmp .L819
.L818:
.L819:
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
    jz .L822
    movaps xmm0, xmm7
    movaps xmm6, xmm0
section .data
.flt824: dq 0.0
section .text
    movsd xmm0, [rel .flt824]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt825: dq 0.0
section .text
    movsd xmm0, [rel .flt825]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt826: dq 0.0
section .text
    movsd xmm0, [rel .flt826]
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl258:
    lea r11, [rbp-144]
    call v3
    add rsp, 32
    jmp .L823
.L822:
.L823:
    lea rax, [rbp-144]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_796
.__ret_796:
    movups xmm6, [rbp-256]
    movups xmm7, [rbp-240]
    movups xmm8, [rbp-224]
    movups xmm9, [rbp-208]
    movups xmm10, [rbp-192]
    movups xmm11, [rbp-176]
    movups xmm12, [rbp-160]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb_move.kft, .kfe, .kfn, __kron_file_4,7
    dq .kl252,89
    dq .kl253,97
    dq .kl254,98
    dq .kl255,99
    dq .kl256,100
    dq .kl257,101
    dq .kl258,102
.kfn: db "aabb_push", 0
section .text
aabb_closest:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-40], r11
    mov r11, [rcx + 8]
    mov [rbp-32], r11
    mov r11, [rcx + 16]
    mov [rbp-24], r11
    mov r11, [rcx + 24]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-56], r11
    mov r11, [rdx + 8]
    mov [rbp-48], r11
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl259:
    call fclamp
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-36]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-20]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fclamp
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fclamp
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_827
.__ret_827:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb_push.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl259,108
.kfn: db "aabb_closest", 0
section .text
sphere:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    mov qword [rbp-40], 0
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-56]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    movaps xmm0, xmm6
    cvtsd2ss xmm0, xmm0
    movss [rbp-40], xmm0
    lea rax, [rbp-56]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov ecx, dword [rax+16]
    mov [rdx+16], ecx
    mov rax, [rbp-8]
    jmp .__ret_828
.__ret_828:
    movups xmm6, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
sphere_overlap:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rcx + 16]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-48], r11
    mov r11, [rdx + 8]
    mov [rbp-40], r11
    mov r11, [rdx + 16]
    mov [rbp-32], r11
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl260:
    lea r11, [rbp-72]
    call v3_sub
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call v3_len2
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L830
    mov rax, 1
    jmp .__ret_829
    jmp .L831
.L830:
.L831:
    mov rax, 0
    jmp .__ret_829
.__ret_829:
    movups xmm6, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq aabb_closest.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl260,121
.kfn: db "sphere_overlap", 0
section .text
sphere_aabb_overlap:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rcx + 16]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-56], r11
    mov r11, [rdx + 8]
    mov [rbp-48], r11
    mov r11, [rdx + 16]
    mov [rbp-40], r11
    mov r11, [rdx + 24]
    mov [rbp-32], r11
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl261:
    lea r11, [rbp-72]
    call aabb_closest
    add rsp, 32
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl262:
    lea r11, [rbp-88]
    call v3_sub
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call v3_len2
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L833
    mov rax, 1
    jmp .__ret_832
    jmp .L834
.L833:
.L834:
    mov rax, 0
    jmp .__ret_832
.__ret_832:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq sphere_overlap.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl261,126
    dq .kl262,127
.kfn: db "sphere_aabb_overlap", 0
section .text
sphere_push:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    movups [rbp-128], xmm6
    movups [rbp-112], xmm7
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-56], r11
    mov r11, [rdx + 8]
    mov [rbp-48], r11
    mov r11, [rdx + 16]
    mov [rbp-40], r11
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl263:
    lea r11, [rbp-72]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-72]
    push rax
    pop rcx
    sub rsp, 32
.kl264:
    call v3_len
    add rsp, 32
    movaps xmm7, xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt838: dq 0.0
section .text
    movsd xmm0, [rel .flt838]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L836
section .data
.flt839: dq 0.0
section .text
    movsd xmm0, [rel .flt839]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt840: dq 0.0
section .text
    movsd xmm0, [rel .flt840]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt841: dq 0.0
section .text
    movsd xmm0, [rel .flt841]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl265:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_835
    jmp .L837
.L836:
.L837:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt844: dq 0.0
section .text
    movsd xmm0, [rel .flt844]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L842
section .data
.flt845: dq 0.0
section .text
    movsd xmm0, [rel .flt845]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt846: dq 0.0
section .text
    movsd xmm0, [rel .flt846]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl266:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_835
    jmp .L843
.L842:
.L843:
    lea rax, [rbp-72]
    push rax
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl267:
    mov r11, [rbp-8]
    call v3_scale
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_835
.__ret_835:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq sphere_aabb_overlap.kft, .kfe, .kfn, __kron_file_4,5
    dq .kl263,133
    dq .kl264,134
    dq .kl265,136
    dq .kl266,137
    dq .kl267,138
.kfn: db "sphere_push", 0
section .text
sphere_aabb_push:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    movups [rbp-176], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-64], r11
    mov r11, [rdx + 8]
    mov [rbp-56], r11
    mov r11, [rdx + 16]
    mov [rbp-48], r11
    mov r11, [rdx + 24]
    mov [rbp-40], r11
    lea rax, [rbp-64]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl268:
    lea r11, [rbp-80]
    call aabb_closest
    add rsp, 32
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-80]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl269:
    lea r11, [rbp-96]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-96]
    push rax
    pop rcx
    sub rsp, 32
.kl270:
    call v3_len
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt850: dq 0.0
section .text
    movsd xmm0, [rel .flt850]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L848
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L851
section .data
.flt853: dq 0.0
section .text
    movsd xmm0, [rel .flt853]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt854: dq 0.0
section .text
    movsd xmm0, [rel .flt854]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt855: dq 0.0
section .text
    movsd xmm0, [rel .flt855]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl271:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_847
    jmp .L852
.L851:
.L852:
    lea rax, [rbp-96]
    push rax
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl272:
    mov r11, [rbp-8]
    call v3_scale
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_847
    jmp .L849
.L848:
.L849:
    lea rax, [rbp-32]
    push rax
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl273:
    lea r11, [rbp-152]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-136]
    call aabb_at
    add rsp, 32
    lea rax, [rbp-136]
    push rax
    lea rax, [rbp-64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl274:
    mov r11, [rbp-8]
    call aabb_push
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_847
.__ret_847:
    movups xmm6, [rbp-176]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq sphere_push.kft, .kfe, .kfn, __kron_file_4,7
    dq .kl268,143
    dq .kl269,144
    dq .kl270,145
    dq .kl271,147
    dq .kl272,148
    dq .kl273,151
    dq .kl274,152
.kfn: db "sphere_aabb_push", 0
section .text
ray:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov qword [rbp-72], 0
    mov qword [rbp-64], 0
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-72]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-40]
    push rax
    pop rcx
    sub rsp, 32
.kl275:
    lea r11, [rbp-88]
    call v3_norm
    add rsp, 32
    push rax
    lea rax, [rbp-56]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-72]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    mov rax, [rbp-8]
    jmp .__ret_856
.__ret_856:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq sphere_aabb_push.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl275,159
.kfn: db "ray", 0
section .text
ray_at:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    movups [rbp-80], xmm6
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-40], r11
    mov r11, [rcx + 8]
    mov [rbp-32], r11
    mov r11, [rcx + 16]
    mov [rbp-24], r11
    mov r11, [rcx + 24]
    mov [rbp-16], r11
    movaps xmm6, xmm1
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-24]
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl276:
    lea r11, [rbp-64]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_add
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_857
.__ret_857:
    movups xmm6, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ray.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl276,164
.kfn: db "ray_at", 0
section .text
rb_slab:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    movups [rbp-144], xmm6
    movups [rbp-128], xmm7
    movups [rbp-112], xmm8
    movups [rbp-96], xmm9
    movups [rbp-80], xmm10
    movaps xmm10, xmm0
    movaps xmm9, xmm1
    movaps xmm7, xmm2
    movaps xmm6, xmm3
    mov [rbp-40], r10
    movaps xmm0, xmm9
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt861: dq 0.0
section .text
    movsd xmm0, [rel .flt861]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L859
    movaps xmm0, xmm10
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
    jnz .L864
    movaps xmm0, xmm10
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
    jnz .L864
    mov rax, 0
    jmp .L865
.L864:
    mov rax, 1
.L865:
    test rax, rax
    jz .L862
    mov rax, 0
    jmp .__ret_858
    jmp .L863
.L862:
.L863:
    mov rax, 1
    jmp .__ret_858
    jmp .L860
.L859:
.L860:
    movaps xmm0, xmm7
    movaps xmm1, xmm10
    subsd xmm0, xmm1
    movaps xmm1, xmm9
    divsd xmm0, xmm1
    movaps xmm8, xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm10
    subsd xmm0, xmm1
    movaps xmm1, xmm9
    divsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm8
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
    jz .L866
    movaps xmm0, xmm8
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    movaps xmm8, xmm0
    movaps xmm0, xmm6
    movaps xmm7, xmm0
    jmp .L867
.L866:
.L867:
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 0
    cmp rax, 2
    jb .L870
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl277:
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_858
.L870:
    mov rcx, rax
    mov rdx, [rbp-40]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L868
    mov rax, 0
    cmp rax, 2
    jb .L871
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_858
.L871:
    push rax
    movaps xmm0, xmm8
    pop rcx
    mov rdx, [rbp-40]
    movsd [rdx+rcx*8], xmm0
    jmp .L869
.L868:
.L869:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cmp rax, 2
    jb .L874
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl278:
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_858
.L874:
    mov rcx, rax
    mov rdx, [rbp-40]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L872
    mov rax, 1
    cmp rax, 2
    jb .L875
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_858
.L875:
    push rax
    movaps xmm0, xmm7
    pop rcx
    mov rdx, [rbp-40]
    movsd [rdx+rcx*8], xmm0
    jmp .L873
.L872:
.L873:
    mov rax, 0
    cmp rax, 2
    jb .L878
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl279:
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_858
.L878:
    mov rcx, rax
    mov rdx, [rbp-40]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, 1
    cmp rax, 2
    jb .L879
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_858
.L879:
    mov rcx, rax
    mov rdx, [rbp-40]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L876
    mov rax, 0
    jmp .__ret_858
    jmp .L877
.L876:
.L877:
    mov rax, 1
    jmp .__ret_858
.__ret_858:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    movups xmm9, [rbp-96]
    movups xmm10, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ray_at.kft, .kfe, .kfn, __kron_file_4,3
    dq .kl277,180
    dq .kl278,181
    dq .kl279,182
.kfn: db "rb_slab", 0
section .text
ray_aabb:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rcx + 24]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-64], r11
    mov r11, [rdx + 8]
    mov [rbp-56], r11
    mov r11, [rdx + 16]
    mov [rbp-48], r11
    mov r11, [rdx + 24]
    mov [rbp-40], r11
    mov rax, 0
    cmp rax, 2
    jb .L881
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl280:
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_880
.L881:
    push rax
section .data
.flt882: dq 0.0
section .text
    movsd xmm0, [rel .flt882]
    pop rcx
    lea rdx, [rbp-80]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 2
    jb .L883
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl281:
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_880
.L883:
    push rax
section .data
.flt884: dq 1.0e30
section .text
    movsd xmm0, [rel .flt884]
    pop rcx
    lea rdx, [rbp-80]
    movsd [rdx+rcx*8], xmm0
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-16]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-80]
    push rax
    pop r10
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl282:
    call rb_slab
    add rsp, 32
    cmp rax, 0
    jne .L885
section .data
.flt887: dq 0.0
section .text
    movsd xmm0, [rel .flt887]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt888: dq 1.0
section .text
    movsd xmm0, [rel .flt888]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_880
    jmp .L886
.L885:
.L886:
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-12]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-80]
    push rax
    pop r10
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl283:
    call rb_slab
    add rsp, 32
    cmp rax, 0
    jne .L889
section .data
.flt891: dq 0.0
section .text
    movsd xmm0, [rel .flt891]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt892: dq 1.0
section .text
    movsd xmm0, [rel .flt892]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_880
    jmp .L890
.L889:
.L890:
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-80]
    push rax
    pop r10
    movsd xmm3, [rsp]
    add rsp, 8
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl284:
    call rb_slab
    add rsp, 32
    cmp rax, 0
    jne .L893
section .data
.flt895: dq 0.0
section .text
    movsd xmm0, [rel .flt895]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt896: dq 1.0
section .text
    movsd xmm0, [rel .flt896]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_880
    jmp .L894
.L893:
.L894:
    mov rax, 0
    cmp rax, 2
    jb .L897
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl285:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_880
.L897:
    mov rcx, rax
    lea rdx, [rbp-80]
    movsd xmm0, [rdx+rcx*8]
    jmp .__ret_880
.__ret_880:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq rb_slab.kft, .kfe, .kfn, __kron_file_4,6
    dq .kl280,189
    dq .kl281,190
    dq .kl282,191
    dq .kl283,192
    dq .kl284,193
    dq .kl285,194
.kfn: db "ray_aabb", 0
section .text
ray_sphere:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    movups [rbp-144], xmm6
    movups [rbp-128], xmm7
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rcx + 24]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-56], r11
    mov r11, [rdx + 8]
    mov [rbp-48], r11
    mov r11, [rdx + 16]
    mov [rbp-40], r11
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl286:
    lea r11, [rbp-72]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl287:
    call v3_dot
    add rsp, 32
    movaps xmm7, xmm0
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl288:
    call v3_dot
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt903: dq 0.0
section .text
    movsd xmm0, [rel .flt903]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L901
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt904: dq 0.0
section .text
    movsd xmm0, [rel .flt904]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L901
    mov rax, 1
    jmp .L902
.L901:
    mov rax, 0
.L902:
    test rax, rax
    jz .L899
section .data
.flt905: dq 0.0
section .text
    movsd xmm0, [rel .flt905]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt906: dq 1.0
section .text
    movsd xmm0, [rel .flt906]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_898
    jmp .L900
.L899:
.L900:
    movaps xmm0, xmm7
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt909: dq 0.0
section .text
    movsd xmm0, [rel .flt909]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L907
section .data
.flt910: dq 0.0
section .text
    movsd xmm0, [rel .flt910]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt911: dq 1.0
section .text
    movsd xmm0, [rel .flt911]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_898
    jmp .L908
.L907:
.L908:
section .data
.flt912: dq 0.0
section .text
    movsd xmm0, [rel .flt912]
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl289:
    call fsqrt
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt915: dq 0.0
section .text
    movsd xmm0, [rel .flt915]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L913
section .data
.flt916: dq 0.0
section .text
    movsd xmm0, [rel .flt916]
    movaps xmm6, xmm0
    jmp .L914
.L913:
.L914:
    movaps xmm0, xmm6
    jmp .__ret_898
.__ret_898:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ray_aabb.kft, .kfe, .kfn, __kron_file_4,4
    dq .kl286,198
    dq .kl287,199
    dq .kl288,200
    dq .kl289,204
.kfn: db "ray_sphere", 0
section .text
plane:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov qword [rbp-64], 0
    mov qword [rbp-56], 0
    mov qword [rbp-48], 0
    lea rax, [rbp-24]
    push rax
    pop rcx
    sub rsp, 32
.kl290:
    lea r11, [rbp-80]
    call v3_norm
    add rsp, 32
    push rax
    lea rax, [rbp-64]
    mov rdx, rax
    pop rax
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-64]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl291:
    call v3_dot
    add rsp, 32
    cvtsd2ss xmm0, xmm0
    movss [rbp-48], xmm0
    lea rax, [rbp-64]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov ecx, dword [rax+16]
    mov [rdx+16], ecx
    mov rax, [rbp-8]
    jmp .__ret_917
.__ret_917:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ray_sphere.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl290,211
    dq .kl291,212
.kfn: db "plane", 0
section .text
plane_distance:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rcx + 16]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl292:
    call v3_dot
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-8]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_918
.__ret_918:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq plane.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl292,218
.kfn: db "plane_distance", 0
section .text
ray_plane:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    movups [rbp-96], xmm6
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rcx + 24]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-56], r11
    mov r11, [rdx + 8]
    mov [rbp-48], r11
    mov r11, [rdx + 16]
    mov [rbp-40], r11
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl293:
    call v3_dot
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl294:
    call fabs
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt922: dq 0.000001
section .text
    movsd xmm0, [rel .flt922]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L920
section .data
.flt923: dq 0.0
section .text
    movsd xmm0, [rel .flt923]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt924: dq 1.0
section .text
    movsd xmm0, [rel .flt924]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_919
    jmp .L921
.L920:
.L921:
    movss xmm0, [rbp-40]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl295:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt927: dq 0.0
section .text
    movsd xmm0, [rel .flt927]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L925
section .data
.flt928: dq 0.0
section .text
    movsd xmm0, [rel .flt928]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt929: dq 1.0
section .text
    movsd xmm0, [rel .flt929]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_919
    jmp .L926
.L925:
.L926:
    movaps xmm0, xmm6
    jmp .__ret_919
.__ret_919:
    movups xmm6, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq plane_distance.kft, .kfe, .kfn, __kron_file_4,3
    dq .kl293,222
    dq .kl294,223
    dq .kl295,224
.kfn: db "ray_plane", 0
section .text
ray_triangle:
    push rbp
    mov rbp, rsp
    sub rsp, 288
    movups [rbp-256], xmm6
    movups [rbp-240], xmm7
    movups [rbp-224], xmm8
    mov r11, [rcx + 0]
    mov [rbp-32], r11
    mov r11, [rcx + 8]
    mov [rbp-24], r11
    mov r11, [rcx + 16]
    mov [rbp-16], r11
    mov r11, [rcx + 24]
    mov [rbp-8], r11
    mov r11, [rdx + 0]
    mov [rbp-48], r11
    mov r11, [rdx + 8]
    mov [rbp-40], r11
    mov r11, [r8 + 0]
    mov [rbp-64], r11
    mov r11, [r8 + 8]
    mov [rbp-56], r11
    mov r11, [r9 + 0]
    mov [rbp-80], r11
    mov r11, [r9 + 8]
    mov [rbp-72], r11
    lea rax, [rbp-64]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl296:
    lea r11, [rbp-96]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-80]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl297:
    lea r11, [rbp-112]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-16]
    push rax
    lea rax, [rbp-112]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl298:
    lea r11, [rbp-128]
    call v3_cross
    add rsp, 32
    lea rax, [rbp-96]
    push rax
    lea rax, [rbp-128]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl299:
    call v3_dot
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl300:
    call fabs
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt933: dq 0.0000001
section .text
    movsd xmm0, [rel .flt933]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L931
section .data
.flt934: dq 0.0
section .text
    movsd xmm0, [rel .flt934]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt935: dq 1.0
section .text
    movsd xmm0, [rel .flt935]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_930
    jmp .L932
.L931:
.L932:
section .data
.flt936: dq 1.0
section .text
    movsd xmm0, [rel .flt936]
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm8, xmm0
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl301:
    lea r11, [rbp-160]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-160]
    push rax
    lea rax, [rbp-128]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl302:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt941: dq 0.0
section .text
    movsd xmm0, [rel .flt941]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L939
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt942: dq 1.0
section .text
    movsd xmm0, [rel .flt942]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L939
    mov rax, 0
    jmp .L940
.L939:
    mov rax, 1
.L940:
    test rax, rax
    jz .L937
section .data
.flt943: dq 0.0
section .text
    movsd xmm0, [rel .flt943]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt944: dq 1.0
section .text
    movsd xmm0, [rel .flt944]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_930
    jmp .L938
.L937:
.L938:
    lea rax, [rbp-160]
    push rax
    lea rax, [rbp-96]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl303:
    lea r11, [rbp-184]
    call v3_cross
    add rsp, 32
    lea rax, [rbp-16]
    push rax
    lea rax, [rbp-184]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl304:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt949: dq 0.0
section .text
    movsd xmm0, [rel .flt949]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L947
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt950: dq 1.0
section .text
    movsd xmm0, [rel .flt950]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jnz .L947
    mov rax, 0
    jmp .L948
.L947:
    mov rax, 1
.L948:
    test rax, rax
    jz .L945
section .data
.flt951: dq 0.0
section .text
    movsd xmm0, [rel .flt951]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt952: dq 1.0
section .text
    movsd xmm0, [rel .flt952]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_930
    jmp .L946
.L945:
.L946:
    lea rax, [rbp-112]
    push rax
    lea rax, [rbp-184]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl305:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt955: dq 0.0
section .text
    movsd xmm0, [rel .flt955]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L953
section .data
.flt956: dq 0.0
section .text
    movsd xmm0, [rel .flt956]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt957: dq 1.0
section .text
    movsd xmm0, [rel .flt957]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_930
    jmp .L954
.L953:
.L954:
    movaps xmm0, xmm6
    jmp .__ret_930
.__ret_930:
    movups xmm6, [rbp-256]
    movups xmm7, [rbp-240]
    movups xmm8, [rbp-224]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ray_plane.kft, .kfe, .kfn, __kron_file_4,10
    dq .kl296,231
    dq .kl297,232
    dq .kl298,233
    dq .kl299,234
    dq .kl300,235
    dq .kl301,237
    dq .kl302,238
    dq .kl303,240
    dq .kl304,241
    dq .kl305,243
.kfn: db "ray_triangle", 0
section .text
triangle_closest:
    push rbp
    mov rbp, rsp
    sub rsp, 496
    movups [rbp-464], xmm6
    movups [rbp-448], xmm7
    movups [rbp-432], xmm8
    movups [rbp-416], xmm9
    movups [rbp-400], xmm10
    movups [rbp-384], xmm11
    movups [rbp-368], xmm12
    mov [rbp-8], r11
    mov r11, [rcx + 0]
    mov [rbp-24], r11
    mov r11, [rcx + 8]
    mov [rbp-16], r11
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov r11, [r8 + 0]
    mov [rbp-56], r11
    mov r11, [r8 + 8]
    mov [rbp-48], r11
    mov r11, [r9 + 0]
    mov [rbp-72], r11
    mov r11, [r9 + 8]
    mov [rbp-64], r11
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl306:
    lea r11, [rbp-88]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl307:
    lea r11, [rbp-104]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl308:
    lea r11, [rbp-120]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-88]
    push rax
    lea rax, [rbp-120]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl309:
    call v3_dot
    add rsp, 32
    movaps xmm7, xmm0
    lea rax, [rbp-104]
    push rax
    lea rax, [rbp-120]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl310:
    call v3_dot
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt963: dq 0.0
section .text
    movsd xmm0, [rel .flt963]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L961
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt964: dq 0.0
section .text
    movsd xmm0, [rel .flt964]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L961
    mov rax, 1
    jmp .L962
.L961:
    mov rax, 0
.L962:
    test rax, rax
    jz .L959
    lea rax, [rbp-40]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_958
    jmp .L960
.L959:
.L960:
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl311:
    lea r11, [rbp-152]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-88]
    push rax
    lea rax, [rbp-152]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl312:
    call v3_dot
    add rsp, 32
    movaps xmm12, xmm0
    lea rax, [rbp-104]
    push rax
    lea rax, [rbp-152]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl313:
    call v3_dot
    add rsp, 32
    movaps xmm11, xmm0
    movaps xmm0, xmm12
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt969: dq 0.0
section .text
    movsd xmm0, [rel .flt969]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L967
    movaps xmm0, xmm11
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm12
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L967
    mov rax, 1
    jmp .L968
.L967:
    mov rax, 0
.L968:
    test rax, rax
    jz .L965
    lea rax, [rbp-56]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_958
    jmp .L966
.L965:
.L966:
    movaps xmm0, xmm7
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm12
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm10, xmm0
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt976: dq 0.0
section .text
    movsd xmm0, [rel .flt976]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L974
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt977: dq 0.0
section .text
    movsd xmm0, [rel .flt977]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L974
    mov rax, 1
    jmp .L975
.L974:
    mov rax, 0
.L975:
    test rax, rax
    jz .L972
    movaps xmm0, xmm12
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt978: dq 0.0
section .text
    movsd xmm0, [rel .flt978]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L972
    mov rax, 1
    jmp .L973
.L972:
    mov rax, 0
.L973:
    test rax, rax
    jz .L970
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-88]
    push rax
    movaps xmm0, xmm7
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl314:
    lea r11, [rbp-192]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_add
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_958
    jmp .L971
.L970:
.L971:
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl315:
    lea r11, [rbp-208]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-88]
    push rax
    lea rax, [rbp-208]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl316:
    call v3_dot
    add rsp, 32
    movaps xmm9, xmm0
    lea rax, [rbp-104]
    push rax
    lea rax, [rbp-208]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl317:
    call v3_dot
    add rsp, 32
    movaps xmm8, xmm0
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt983: dq 0.0
section .text
    movsd xmm0, [rel .flt983]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L981
    movaps xmm0, xmm9
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L981
    mov rax, 1
    jmp .L982
.L981:
    mov rax, 0
.L982:
    test rax, rax
    jz .L979
    lea rax, [rbp-72]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_958
    jmp .L980
.L979:
.L980:
    movaps xmm0, xmm9
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt990: dq 0.0
section .text
    movsd xmm0, [rel .flt990]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L988
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt991: dq 0.0
section .text
    movsd xmm0, [rel .flt991]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L988
    mov rax, 1
    jmp .L989
.L988:
    mov rax, 0
.L989:
    test rax, rax
    jz .L986
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt992: dq 0.0
section .text
    movsd xmm0, [rel .flt992]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L986
    mov rax, 1
    jmp .L987
.L986:
    mov rax, 0
.L987:
    test rax, rax
    jz .L984
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-104]
    push rax
    movaps xmm0, xmm6
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl318:
    lea r11, [rbp-248]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_add
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_958
    jmp .L985
.L984:
.L985:
    movaps xmm0, xmm12
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm11
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt999: dq 0.0
section .text
    movsd xmm0, [rel .flt999]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L997
    movaps xmm0, xmm11
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1000: dq 0.0
section .text
    movsd xmm0, [rel .flt1000]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L997
    mov rax, 1
    jmp .L998
.L997:
    mov rax, 0
.L998:
    test rax, rax
    jz .L995
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1001: dq 0.0
section .text
    movsd xmm0, [rel .flt1001]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L995
    mov rax, 1
    jmp .L996
.L995:
    mov rax, 0
.L996:
    test rax, rax
    jz .L993
    lea rax, [rbp-56]
    push rax
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-56]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl319:
    lea r11, [rbp-288]
    call v3_sub
    add rsp, 32
    push rax
    movaps xmm0, xmm11
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm11
    movaps xmm1, xmm12
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-272]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_add
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_958
    jmp .L994
.L993:
.L994:
section .data
.flt1002: dq 1.0
section .text
    movsd xmm0, [rel .flt1002]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    addsd xmm0, xmm1
    movaps xmm1, xmm10
    addsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-88]
    push rax
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl320:
    lea r11, [rbp-328]
    call v3_scale
    add rsp, 32
    push rax
    lea rax, [rbp-104]
    push rax
    movaps xmm0, xmm10
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-344]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-312]
    call v3_add
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    mov r11, [rbp-8]
    call v3_add
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_958
.__ret_958:
    movups xmm6, [rbp-464]
    movups xmm7, [rbp-448]
    movups xmm8, [rbp-432]
    movups xmm9, [rbp-416]
    movups xmm10, [rbp-400]
    movups xmm11, [rbp-384]
    movups xmm12, [rbp-368]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ray_triangle.kft, .kfe, .kfn, __kron_file_4,15
    dq .kl306,251
    dq .kl307,252
    dq .kl308,253
    dq .kl309,254
    dq .kl310,255
    dq .kl311,257
    dq .kl312,258
    dq .kl313,259
    dq .kl314,263
    dq .kl315,265
    dq .kl316,266
    dq .kl317,267
    dq .kl318,271
    dq .kl319,275
    dq .kl320,278
.kfn: db "triangle_closest", 0
section .text
section .data
__g_cm_pos: dq 0
section .text
section .data
__g_cm_idx: dq 0
section .text
section .data
__g_cm_box: dq 0
section .text
cmesh_new:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_cm_pos]
    cmp rax, 0
    jne .L1004
    sub rsp, 32
.kl321:
    call list_new
    add rsp, 32
    mov [rel __g_cm_pos], rax
    sub rsp, 32
.kl322:
    call list_new
    add rsp, 32
    mov [rel __g_cm_idx], rax
    sub rsp, 32
.kl323:
    call list_new
    add rsp, 32
    mov [rel __g_cm_box], rax
    jmp .L1005
.L1004:
.L1005:
    mov rcx, r12
    sub rsp, 32
.kl324:
    call list_len
    add rsp, 32
    mov rcx, 3
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1008
    mov rcx, r13
    sub rsp, 32
    call list_len
    add rsp, 32
    mov rcx, 3
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1008
    mov rax, 0
    jmp .L1009
.L1008:
    mov rax, 1
.L1009:
    test rax, rax
    jz .L1006
section .data
.str1010: db 97,32,99,111,108,108,105,115,105,111,110,32,109,101,115,104,32,105,115,32,120,32,121,32,122,32,112,111,115,105,116,105,111,110,115,32,97,110,100,32,116,104,114,101,101,32,105,110,100,105,99,101,115,32,97,32,116,114,105,97,110,103,108,101
    db 0
section .text
    lea rax, [rel .str1010]
    push rax
section .data
.str1011: db 99,104,101,99,107,32,116,104,101,32,108,105,115,116,115,0
section .text
    lea rax, [rel .str1011]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl325:
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1003
    jmp .L1007
.L1006:
.L1007:
section .data
.flt1012: dq 1.0e30
section .text
    movsd xmm0, [rel .flt1012]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1013: dq 1.0e30
section .text
    movsd xmm0, [rel .flt1013]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1014: dq 1.0e30
section .text
    movsd xmm0, [rel .flt1014]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl326:
    lea r11, [rbp-32]
    call v3
    add rsp, 32
section .data
.flt1015: dq 0.0
section .text
    movsd xmm0, [rel .flt1015]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1016: dq 1.0e30
section .text
    movsd xmm0, [rel .flt1016]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1017: dq 0.0
section .text
    movsd xmm0, [rel .flt1017]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1018: dq 1.0e30
section .text
    movsd xmm0, [rel .flt1018]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1019: dq 0.0
section .text
    movsd xmm0, [rel .flt1019]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1020: dq 1.0e30
section .text
    movsd xmm0, [rel .flt1020]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl327:
    lea r11, [rbp-48]
    call v3
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L1021:
    mov rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
.kl328:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1022
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl329:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-72]
    call v3
    add rsp, 32
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl330:
    lea r11, [rbp-32]
    call v3_min
    add rsp, 32
    lea rax, [rbp-48]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl331:
    lea r11, [rbp-48]
    call v3_max
    add rsp, 32
    add rbx, 3
.L1023:
    jmp .L1021
.L1022:
    mov rax, [rel __g_cm_pos]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
.kl332:
    call list_add
    add rsp, 32
    mov rax, [rel __g_cm_idx]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl333:
    call list_add
    add rsp, 32
    mov rax, [rel __g_cm_box]
    push rax
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl334:
    lea r11, [rbp-104]
    call aabb
    add rsp, 32
    push rax
    mov rax, 4
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add_n
    add rsp, 32
    mov rax, [rel __g_cm_pos]
    push rax
    pop rcx
    sub rsp, 32
.kl335:
    call list_len
    add rsp, 32
    jmp .__ret_1003
.__ret_1003:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq triangle_closest.kft, .kfe, .kfn, __kron_file_4,15
    dq .kl321,288
    dq .kl322,289
    dq .kl323,290
    dq .kl324,292
    dq .kl325,293
    dq .kl326,295
    dq .kl327,296
    dq .kl328,298
    dq .kl329,299
    dq .kl330,300
    dq .kl331,301
    dq .kl332,304
    dq .kl333,305
    dq .kl334,306
    dq .kl335,307
.kfn: db "cmesh_new", 0
section .text
cm_corner:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-8], r11
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl336:
    call list_get
    add rsp, 32
    mov rcx, 3
    imul rax, rcx
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl337:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_1024
.__ret_1024:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq cmesh_new.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl336,311
    dq .kl337,312
.kfn: db "cm_corner", 0
section .text
cmesh_ray:
    push rbp
    mov rbp, rsp
    sub rsp, 304
    mov [rbp-272], rbx
    mov [rbp-264], r12
    mov [rbp-256], r13
    mov [rbp-248], r14
    movups [rbp-240], xmm6
    movups [rbp-224], xmm7
    mov rbx, rcx
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov r11, [rdx + 16]
    mov [rbp-24], r11
    mov r11, [rdx + 24]
    mov [rbp-16], r11
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1030
    mov rax, [rel __g_cm_pos]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1030
    mov rax, 0
    jmp .L1031
.L1030:
    mov rax, 1
.L1031:
    test rax, rax
    jnz .L1028
    mov rax, rbx
    push rax
    mov rax, [rel __g_cm_pos]
    push rax
    pop rcx
    sub rsp, 32
.kl338:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1028
    mov rax, 0
    jmp .L1029
.L1028:
    mov rax, 1
.L1029:
    test rax, rax
    jz .L1026
section .data
.str1032: db 110,111,32,115,117,99,104,32,99,111,108,108,105,115,105,111,110,32,109,101,115,104,0
section .text
    lea rax, [rel .str1032]
    push rax
section .data
.str1033: db 117,115,101,32,119,104,97,116,32,99,109,101,115,104,95,110,101,119,32,103,97,118,101,0
section .text
    lea rax, [rel .str1033]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl339:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1025
    jmp .L1027
.L1026:
.L1027:
    mov rax, [rel __g_cm_box]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    lea rax, [rbp-104]
    push rax
    mov rax, 4
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl340:
    call list_get_n
    add rsp, 32
    lea rdx, [rbp-72]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl341:
    call ray_aabb
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1036: dq 0.0
section .text
    movsd xmm0, [rel .flt1036]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1034
section .data
.flt1037: dq 0.0
section .text
    movsd xmm0, [rel .flt1037]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1038: dq 1.0
section .text
    movsd xmm0, [rel .flt1038]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_1025
    jmp .L1035
.L1034:
.L1035:
    mov rax, [rel __g_cm_pos]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl342:
    call list_get
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_cm_idx]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl343:
    call list_get
    add rsp, 32
    mov r13, rax
section .data
.flt1039: dq 0.0
section .text
    movsd xmm0, [rel .flt1039]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1040: dq 1.0
section .text
    movsd xmm0, [rel .flt1040]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
.kl344:
    call list_len
    add rsp, 32
    mov rbx, rax
.L1041:
    cmp r12, rbx
    jge .L1042
    lea rax, [rbp-40]
    push rax
    mov rcx, r14
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
.kl345:
    lea r11, [rbp-168]
    call cm_corner
    add rsp, 32
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-184]
    call cm_corner
    add rsp, 32
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    add rax, 2
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-200]
    call cm_corner
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ray_triangle
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1048: dq 0.0
section .text
    movsd xmm0, [rel .flt1048]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L1046
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1051: dq 0.0
section .text
    movsd xmm0, [rel .flt1051]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jnz .L1049
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
    jnz .L1049
    mov rax, 0
    jmp .L1050
.L1049:
    mov rax, 1
.L1050:
    test rax, rax
    jz .L1046
    mov rax, 1
    jmp .L1047
.L1046:
    mov rax, 0
.L1047:
    test rax, rax
    jz .L1044
    movaps xmm0, xmm6
    movaps xmm7, xmm0
    jmp .L1045
.L1044:
.L1045:
    add r12, 3
.L1043:
    jmp .L1041
.L1042:
    movaps xmm0, xmm7
    jmp .__ret_1025
.__ret_1025:
    mov rbx, [rbp-272]
    mov r12, [rbp-264]
    mov r13, [rbp-256]
    mov r14, [rbp-248]
    movups xmm6, [rbp-240]
    movups xmm7, [rbp-224]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq cm_corner.kft, .kfe, .kfn, __kron_file_4,8
    dq .kl338,316
    dq .kl339,317
    dq .kl340,319
    dq .kl341,320
    dq .kl342,321
    dq .kl343,322
    dq .kl344,325
    dq .kl345,327
.kfn: db "cmesh_ray", 0
section .text
cmesh_sphere_push:
    push rbp
    mov rbp, rsp
    sub rsp, 336
    mov [rbp-304], rbx
    mov [rbp-296], r12
    mov [rbp-288], r13
    mov [rbp-280], r14
    movups [rbp-272], xmm6
    mov [rbp-8], r11
    mov rbx, rcx
    mov r11, [rdx + 0]
    mov [rbp-40], r11
    mov r11, [rdx + 8]
    mov [rbp-32], r11
    mov r11, [rdx + 16]
    mov [rbp-24], r11
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1057
    mov rax, [rel __g_cm_pos]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1057
    mov rax, 0
    jmp .L1058
.L1057:
    mov rax, 1
.L1058:
    test rax, rax
    jnz .L1055
    mov rax, rbx
    push rax
    mov rax, [rel __g_cm_pos]
    push rax
    pop rcx
    sub rsp, 32
.kl346:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1055
    mov rax, 0
    jmp .L1056
.L1055:
    mov rax, 1
.L1056:
    test rax, rax
    jz .L1053
section .data
.str1059: db 110,111,32,115,117,99,104,32,99,111,108,108,105,115,105,111,110,32,109,101,115,104,0
section .text
    lea rax, [rel .str1059]
    push rax
section .data
.str1060: db 117,115,101,32,119,104,97,116,32,99,109,101,115,104,95,110,101,119,32,103,97,118,101,0
section .text
    lea rax, [rel .str1060]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl347:
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1052
    jmp .L1054
.L1053:
.L1054:
    mov rax, [rel __g_cm_box]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    lea rax, [rbp-104]
    push rax
    mov rax, 4
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl348:
    call list_get_n
    add rsp, 32
    lea rdx, [rbp-72]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rcx, [rax+16]
    mov [rdx+16], rcx
    mov rcx, [rax+24]
    mov [rdx+24], rcx
    lea rax, [rbp-40]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl349:
    call sphere_aabb_overlap
    add rsp, 32
    cmp rax, 0
    jne .L1061
section .data
.flt1063: dq 0.0
section .text
    movsd xmm0, [rel .flt1063]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1064: dq 0.0
section .text
    movsd xmm0, [rel .flt1064]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1065: dq 0.0
section .text
    movsd xmm0, [rel .flt1065]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_1052
    jmp .L1062
.L1061:
.L1062:
    mov rax, [rel __g_cm_pos]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl350:
    call list_get
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_cm_idx]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl351:
    call list_get
    add rsp, 32
    mov r13, rax
    lea rax, [rbp-40]
    lea rdx, [rbp-136]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
.kl352:
    call list_len
    add rsp, 32
    mov rbx, rax
.L1066:
    cmp r12, rbx
    jge .L1067
    lea rax, [rbp-136]
    push rax
    mov rcx, r14
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
.kl353:
    lea r11, [rbp-184]
    call cm_corner
    add rsp, 32
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-200]
    call cm_corner
    add rsp, 32
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    add rax, 2
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-216]
    call cm_corner
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-168]
    call triangle_closest
    add rsp, 32
    lea rax, [rbp-136]
    push rax
    lea rax, [rbp-168]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl354:
    lea r11, [rbp-232]
    call v3_sub
    add rsp, 32
    lea rax, [rbp-232]
    push rax
    pop rcx
    sub rsp, 32
.kl355:
    call v3_len
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1071
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1073: dq 0.0
section .text
    movsd xmm0, [rel .flt1073]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L1071
    mov rax, 1
    jmp .L1072
.L1071:
    mov rax, 0
.L1072:
    test rax, rax
    jz .L1069
    lea rax, [rbp-136]
    push rax
    lea rax, [rbp-232]
    push rax
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl356:
    lea r11, [rbp-256]
    call v3_scale
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-136]
    call v3_add
    add rsp, 32
    jmp .L1070
.L1069:
.L1070:
    add r12, 3
.L1068:
    jmp .L1066
.L1067:
    lea rax, [rbp-136]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl357:
    mov r11, [rbp-8]
    call v3_sub
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_1052
.__ret_1052:
    mov rbx, [rbp-304]
    mov r12, [rbp-296]
    mov r13, [rbp-288]
    mov r14, [rbp-280]
    movups xmm6, [rbp-272]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq cmesh_ray.kft, .kfe, .kfn, __kron_file_4,12
    dq .kl346,338
    dq .kl347,339
    dq .kl348,341
    dq .kl349,342
    dq .kl350,343
    dq .kl351,344
    dq .kl352,347
    dq .kl353,349
    dq .kl354,350
    dq .kl355,351
    dq .kl356,353
    dq .kl357,357
.kfn: db "cmesh_sphere_push", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 816
    mov [rbp-784], rbx
    mov [rbp-776], r12
    sub rsp, 32
    call __rt_init
    add rsp, 32
    sub rsp, 32
    call list_new
    add rsp, 32
    mov [rel __g_cm_box], rax
section .data
.flt1075: dq 1.0
section .text
    movsd xmm0, [rel .flt1075]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1076: dq 0.0
section .text
    movsd xmm0, [rel .flt1076]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1077: dq 1.0
section .text
    movsd xmm0, [rel .flt1077]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl358:
    lea r11, [rbp-48]
    call v3
    add rsp, 32
    push rax
section .data
.flt1078: dq 1.0
section .text
    movsd xmm0, [rel .flt1078]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1079: dq 2.0
section .text
    movsd xmm0, [rel .flt1079]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1080: dq 1.0
section .text
    movsd xmm0, [rel .flt1080]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-64]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-32]
    call aabb
    add rsp, 32
section .data
.flt1081: dq 1.3
section .text
    movsd xmm0, [rel .flt1081]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1082: dq 1.0
section .text
    movsd xmm0, [rel .flt1082]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1083: dq 0.0
section .text
    movsd xmm0, [rel .flt1083]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl359:
    lea r11, [rbp-104]
    call v3
    add rsp, 32
    push rax
section .data
.flt1084: dq 0.5
section .text
    movsd xmm0, [rel .flt1084]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-88]
    call sphere
    add rsp, 32
    lea rax, [rbp-88]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl360:
    call sphere_aabb_overlap
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    lea rax, [rbp-88]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl361:
    lea r11, [rbp-120]
    call sphere_aabb_push
    add rsp, 32
    movss xmm0, [rbp-120]
    cvtss2sd xmm0, xmm0
    call __print_float
    movss xmm0, [rbp-116]
    cvtss2sd xmm0, xmm0
    call __print_float
section .data
.flt1085: dq 5.0
section .text
    movsd xmm0, [rel .flt1085]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1086: dq 1.0
section .text
    movsd xmm0, [rel .flt1086]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1087: dq 0.0
section .text
    movsd xmm0, [rel .flt1087]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl362:
    lea r11, [rbp-168]
    call v3
    add rsp, 32
    push rax
section .data
.flt1088: dq 1.0
section .text
    movsd xmm0, [rel .flt1088]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1089: dq 0.0
section .text
    movsd xmm0, [rel .flt1089]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1090: dq 0.0
section .text
    movsd xmm0, [rel .flt1090]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-184]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-152]
    call ray
    add rsp, 32
    lea rax, [rbp-152]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl363:
    call ray_aabb
    add rsp, 32
    call __print_float
    lea rax, [rbp-152]
    push rax
section .data
.flt1091: dq 0.0
section .text
    movsd xmm0, [rel .flt1091]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1092: dq 1.0
section .text
    movsd xmm0, [rel .flt1092]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1093: dq 0.0
section .text
    movsd xmm0, [rel .flt1093]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl364:
    lea r11, [rbp-224]
    call v3
    add rsp, 32
    push rax
section .data
.flt1094: dq 1.0
section .text
    movsd xmm0, [rel .flt1094]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-208]
    call sphere
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ray_sphere
    add rsp, 32
    call __print_float
section .data
.flt1095: dq 0.0
section .text
    movsd xmm0, [rel .flt1095]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1096: dq 5.0
section .text
    movsd xmm0, [rel .flt1096]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1097: dq 0.0
section .text
    movsd xmm0, [rel .flt1097]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl365:
    lea r11, [rbp-272]
    call v3
    add rsp, 32
    push rax
section .data
.flt1098: dq 0.0
section .text
    movsd xmm0, [rel .flt1098]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1099: dq 1.0
section .text
    movsd xmm0, [rel .flt1099]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1100: dq 0.0
section .text
    movsd xmm0, [rel .flt1100]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-288]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-256]
    call ray
    add rsp, 32
    push rax
section .data
.flt1101: dq 0.0
section .text
    movsd xmm0, [rel .flt1101]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1102: dq 1.0
section .text
    movsd xmm0, [rel .flt1102]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1103: dq 0.0
section .text
    movsd xmm0, [rel .flt1103]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-328]
    call v3
    add rsp, 32
    push rax
section .data
.flt1104: dq 0.0
section .text
    movsd xmm0, [rel .flt1104]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1105: dq 0.0
section .text
    movsd xmm0, [rel .flt1105]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1106: dq 0.0
section .text
    movsd xmm0, [rel .flt1106]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-344]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-312]
    call plane
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call ray_plane
    add rsp, 32
    call __print_float
section .data
.flt1107: dq 0.2
section .text
    movsd xmm0, [rel .flt1107]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1108: dq 0.2
section .text
    movsd xmm0, [rel .flt1108]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1109: dq 5.0
section .text
    movsd xmm0, [rel .flt1109]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl366:
    lea r11, [rbp-392]
    call v3
    add rsp, 32
    push rax
section .data
.flt1110: dq 0.0
section .text
    movsd xmm0, [rel .flt1110]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1111: dq 0.0
section .text
    movsd xmm0, [rel .flt1111]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1112: dq 1.0
section .text
    movsd xmm0, [rel .flt1112]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-408]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-376]
    call ray
    add rsp, 32
    push rax
section .data
.flt1113: dq 0.0
section .text
    movsd xmm0, [rel .flt1113]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1114: dq 0.0
section .text
    movsd xmm0, [rel .flt1114]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1115: dq 0.0
section .text
    movsd xmm0, [rel .flt1115]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-424]
    call v3
    add rsp, 32
    push rax
section .data
.flt1116: dq 1.0
section .text
    movsd xmm0, [rel .flt1116]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1117: dq 0.0
section .text
    movsd xmm0, [rel .flt1117]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1118: dq 0.0
section .text
    movsd xmm0, [rel .flt1118]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-440]
    call v3
    add rsp, 32
    push rax
section .data
.flt1119: dq 0.0
section .text
    movsd xmm0, [rel .flt1119]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1120: dq 1.0
section .text
    movsd xmm0, [rel .flt1120]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1121: dq 0.0
section .text
    movsd xmm0, [rel .flt1121]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-456]
    call v3
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call ray_triangle
    add rsp, 32
    call __print_float
section .data
.flt1122: dq 0.5
section .text
    movsd xmm0, [rel .flt1122]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1123: dq 0.0
section .text
    movsd xmm0, [rel .flt1123]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1124: dq 0.0
section .text
    movsd xmm0, [rel .flt1124]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl367:
    lea r11, [rbp-504]
    call v3
    add rsp, 32
    push rax
section .data
.flt1125: dq 1.5
section .text
    movsd xmm0, [rel .flt1125]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1126: dq 1.0
section .text
    movsd xmm0, [rel .flt1126]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1127: dq 1.0
section .text
    movsd xmm0, [rel .flt1127]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-520]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-488]
    call aabb
    add rsp, 32
    lea rax, [rbp-488]
    push rax
    lea rax, [rbp-32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl368:
    lea r11, [rbp-536]
    call aabb_push
    add rsp, 32
    movss xmm0, [rbp-536]
    cvtss2sd xmm0, xmm0
    call __print_float
    sub rsp, 32
.kl369:
    call list_new
    add rsp, 32
    push rax
section .data
.flt1128: dq 10.0
section .text
    movsd xmm0, [rel .flt1128]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1129: dq 0.0
section .text
    movsd xmm0, [rel .flt1129]
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1130: dq 10.0
section .text
    movsd xmm0, [rel .flt1130]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1131: dq 10.0
section .text
    movsd xmm0, [rel .flt1131]
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1132: dq 0.0
section .text
    movsd xmm0, [rel .flt1132]
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1133: dq 10.0
section .text
    movsd xmm0, [rel .flt1133]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1134: dq 0.0
section .text
    movsd xmm0, [rel .flt1134]
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1135: dq 0.0
section .text
    movsd xmm0, [rel .flt1135]
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
section .data
.flt1136: dq 10.0
section .text
    movsd xmm0, [rel .flt1136]
    movaps xmm1, xmm0
    pop rcx
    push rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    pop rax
    mov r12, rax
    sub rsp, 32
.kl370:
    call list_new
    add rsp, 32
    push rax
    mov rax, 0
    mov rdx, rax
    pop rcx
    push rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    mov rax, 1
    mov rdx, rax
    pop rcx
    push rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    mov rax, 2
    mov rdx, rax
    pop rcx
    push rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    pop rax
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl371:
    call cmesh_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.flt1137: dq 0.0
section .text
    movsd xmm0, [rel .flt1137]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1138: dq 3.0
section .text
    movsd xmm0, [rel .flt1138]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1139: dq 0.0
section .text
    movsd xmm0, [rel .flt1139]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl372:
    lea r11, [rbp-608]
    call v3
    add rsp, 32
    push rax
section .data
.flt1140: dq 0.0
section .text
    movsd xmm0, [rel .flt1140]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1141: dq 1.0
section .text
    movsd xmm0, [rel .flt1141]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1142: dq 0.0
section .text
    movsd xmm0, [rel .flt1142]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-624]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-592]
    call ray
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call cmesh_ray
    add rsp, 32
    call __print_float
    mov rax, rbx
    push rax
section .data
.flt1143: dq 0.0
section .text
    movsd xmm0, [rel .flt1143]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1144: dq 0.3
section .text
    movsd xmm0, [rel .flt1144]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1145: dq 0.0
section .text
    movsd xmm0, [rel .flt1145]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl373:
    lea r11, [rbp-680]
    call v3
    add rsp, 32
    push rax
section .data
.flt1146: dq 0.5
section .text
    movsd xmm0, [rel .flt1146]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-664]
    call sphere
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-640]
    call cmesh_sphere_push
    add rsp, 32
    movss xmm0, [rbp-636]
    cvtss2sd xmm0, xmm0
    call __print_float
section .data
.flt1147: dq 5.0
section .text
    movsd xmm0, [rel .flt1147]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1148: dq 5.0
section .text
    movsd xmm0, [rel .flt1148]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1149: dq 5.0
section .text
    movsd xmm0, [rel .flt1149]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl374:
    lea r11, [rbp-712]
    call v3
    add rsp, 32
    push rax
section .data
.flt1150: dq 0.0
section .text
    movsd xmm0, [rel .flt1150]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1151: dq 0.0
section .text
    movsd xmm0, [rel .flt1151]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1152: dq 0.0
section .text
    movsd xmm0, [rel .flt1152]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-728]
    call v3
    add rsp, 32
    push rax
section .data
.flt1153: dq 1.0
section .text
    movsd xmm0, [rel .flt1153]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1154: dq 0.0
section .text
    movsd xmm0, [rel .flt1154]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1155: dq 0.0
section .text
    movsd xmm0, [rel .flt1155]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-744]
    call v3
    add rsp, 32
    push rax
section .data
.flt1156: dq 0.0
section .text
    movsd xmm0, [rel .flt1156]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1157: dq 1.0
section .text
    movsd xmm0, [rel .flt1157]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1158: dq 0.0
section .text
    movsd xmm0, [rel .flt1158]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-760]
    call v3
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-696]
    call triangle_closest
    add rsp, 32
    movss xmm0, [rbp-696]
    cvtss2sd xmm0, xmm0
    call __print_float
    movss xmm0, [rbp-692]
    cvtss2sd xmm0, xmm0
    call __print_float
    mov rax, 0
    jmp .__ret_1074
.__ret_1074:
    mov rbx, [rbp-784]
    mov r12, [rbp-776]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq cmesh_sphere_push.kft, .kfe, .kfn, __kron_file_5,17
    dq .kl358,7
    dq .kl359,8
    dq .kl360,9
    dq .kl361,10
    dq .kl362,12
    dq .kl363,13
    dq .kl364,14
    dq .kl365,15
    dq .kl366,16
    dq .kl367,17
    dq .kl368,18
    dq .kl369,20
    dq .kl370,21
    dq .kl371,22
    dq .kl372,23
    dq .kl373,24
    dq .kl374,26
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,109,97,116,104,46,107,114,0
__kron_file_1: db 115,116,100,95,109,97,116,104,51,100,46,107,114,0
__kron_file_2: db 115,116,100,95,104,101,97,112,46,107,114,0
__kron_file_3: db 115,116,100,95,108,105,115,116,46,107,114,0
__kron_file_4: db 115,116,100,95,99,111,108,108,105,100,101,46,107,114,0
__kron_file_5: db 116,101,115,116,95,99,111,108,108,105,100,101,46,107,114,0
section .text
