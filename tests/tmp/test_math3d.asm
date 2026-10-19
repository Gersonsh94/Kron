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
pm:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
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
    mov rax, 0
    mov rbx, rax
.L360:
    cmp rbx, 4
    jge .L361
    lea rax, [rbp-64]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
.kl107:
    call m4_get
    add rsp, 32
    call __print_float
    lea rax, [rbp-64]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 1
    sub rsp, 32
    call m4_get
    add rsp, 32
    call __print_float
    lea rax, [rbp-64]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 2
    sub rsp, 32
    call m4_get
    add rsp, 32
    call __print_float
    lea rax, [rbp-64]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 3
    sub rsp, 32
    call m4_get
    add rsp, 32
    call __print_float
    add rbx, 1
.L362:
    jmp .L360
.L361:
.__ret_359:
    mov rbx, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_slerp.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl107,9
.kfn: db "pm", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 912
    sub rsp, 32
    call __rt_init
    add rsp, 32
section .data
.flt364: dq 1.0
section .text
    movsd xmm0, [rel .flt364]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl108:
    call fatan
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt365: dq 4.0
section .text
    movsd xmm0, [rel .flt365]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    call __print_float
section .data
.flt366: dq 0.5
section .text
    movsd xmm0, [rel .flt366]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl109:
    call facos
    add rsp, 32
    call __print_float
section .data
.flt367: dq 1.0
section .text
    movsd xmm0, [rel .flt367]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl110:
    call fasin
    add rsp, 32
    call __print_float
section .data
.flt368: dq 1.0
section .text
    movsd xmm0, [rel .flt368]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt369: dq 1.0
section .text
    movsd xmm0, [rel .flt369]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl111:
    call fatan2
    add rsp, 32
    call __print_float
section .data
.flt370: dq 1.0
section .text
    movsd xmm0, [rel .flt370]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt371: dq 2.0
section .text
    movsd xmm0, [rel .flt371]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt372: dq 3.0
section .text
    movsd xmm0, [rel .flt372]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl112:
    lea r11, [rbp-128]
    call m4_translate
    add rsp, 32
    push rax
section .data
.flt373: dq 90.0
section .text
    movsd xmm0, [rel .flt373]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call radians
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-192]
    call m4_rotate_y
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-64]
    call m4_mul
    add rsp, 32
    lea rax, [rbp-64]
    push rax
section .data
.flt374: dq 1.0
section .text
    movsd xmm0, [rel .flt374]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt375: dq 0.0
section .text
    movsd xmm0, [rel .flt375]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt376: dq 0.0
section .text
    movsd xmm0, [rel .flt376]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl113:
    lea r11, [rbp-224]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-208]
    call m4_mul_point
    add rsp, 32
    movss xmm0, [rbp-208]
    cvtss2sd xmm0, xmm0
    call __print_float
    movss xmm0, [rbp-204]
    cvtss2sd xmm0, xmm0
    call __print_float
    movss xmm0, [rbp-200]
    cvtss2sd xmm0, xmm0
    call __print_float
    lea rax, [rbp-64]
    push rax
    pop rcx
    sub rsp, 32
.kl114:
    lea r11, [rbp-288]
    call m4_inverse
    add rsp, 32
    lea rax, [rbp-64]
    push rax
    lea rax, [rbp-288]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl115:
    lea r11, [rbp-352]
    call m4_mul
    add rsp, 32
    lea rax, [rbp-352]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 0
    sub rsp, 32
.kl116:
    call m4_get
    add rsp, 32
    call __print_float
    lea rax, [rbp-352]
    push rax
    pop rcx
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call m4_get
    add rsp, 32
    call __print_float
    lea rax, [rbp-352]
    push rax
    pop rcx
    mov rdx, 0
    mov r8, 3
    sub rsp, 32
    call m4_get
    add rsp, 32
    call __print_float
section .data
.flt377: dq 0.0
section .text
    movsd xmm0, [rel .flt377]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt378: dq 1.0
section .text
    movsd xmm0, [rel .flt378]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt379: dq 0.0
section .text
    movsd xmm0, [rel .flt379]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl117:
    lea r11, [rbp-384]
    call v3
    add rsp, 32
    push rax
section .data
.flt380: dq 90.0
section .text
    movsd xmm0, [rel .flt380]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call radians
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    lea r11, [rbp-368]
    call q_axis_angle
    add rsp, 32
    lea rax, [rbp-368]
    push rax
section .data
.flt381: dq 1.0
section .text
    movsd xmm0, [rel .flt381]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt382: dq 0.0
section .text
    movsd xmm0, [rel .flt382]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt383: dq 0.0
section .text
    movsd xmm0, [rel .flt383]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl118:
    lea r11, [rbp-416]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-400]
    call q_rotate
    add rsp, 32
    movss xmm0, [rbp-400]
    cvtss2sd xmm0, xmm0
    call __print_float
    movss xmm0, [rbp-392]
    cvtss2sd xmm0, xmm0
    call __print_float
    sub rsp, 32
.kl119:
    lea r11, [rbp-448]
    call q_identity
    add rsp, 32
    push rax
    lea rax, [rbp-368]
    push rax
section .data
.flt384: dq 0.5
section .text
    movsd xmm0, [rel .flt384]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-432]
    call q_slerp
    add rsp, 32
    lea rax, [rbp-432]
    push rax
section .data
.flt385: dq 1.0
section .text
    movsd xmm0, [rel .flt385]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt386: dq 0.0
section .text
    movsd xmm0, [rel .flt386]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt387: dq 0.0
section .text
    movsd xmm0, [rel .flt387]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl120:
    lea r11, [rbp-480]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-464]
    call q_rotate
    add rsp, 32
    movss xmm0, [rbp-464]
    cvtss2sd xmm0, xmm0
    call __print_float
    movss xmm0, [rbp-456]
    cvtss2sd xmm0, xmm0
    call __print_float
section .data
.flt388: dq 90.0
section .text
    movsd xmm0, [rel .flt388]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl121:
    call radians
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt389: dq 1.0
section .text
    movsd xmm0, [rel .flt389]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt390: dq 1.0
section .text
    movsd xmm0, [rel .flt390]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt391: dq 10.0
section .text
    movsd xmm0, [rel .flt391]
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
    lea r11, [rbp-544]
    call m4_perspective
    add rsp, 32
    lea rax, [rbp-544]
    push rax
section .data
.flt392: dq 0.0
section .text
    movsd xmm0, [rel .flt392]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt393: dq 0.0
section .text
    movsd xmm0, [rel .flt393]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt394: dq 1.0
section .text
    movsd xmm0, [rel .flt394]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt395: dq 1.0
section .text
    movsd xmm0, [rel .flt395]
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
.kl122:
    lea r11, [rbp-576]
    call v4
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-560]
    call m4_mul_v4
    add rsp, 32
    movss xmm0, [rbp-552]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-548]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    call __print_float
    lea rax, [rbp-544]
    push rax
section .data
.flt396: dq 0.0
section .text
    movsd xmm0, [rel .flt396]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt397: dq 0.0
section .text
    movsd xmm0, [rel .flt397]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt398: dq 10.0
section .text
    movsd xmm0, [rel .flt398]
    movaps xmm1, xmm0
    xorps xmm0, xmm0
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt399: dq 1.0
section .text
    movsd xmm0, [rel .flt399]
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
.kl123:
    lea r11, [rbp-608]
    call v4
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-592]
    call m4_mul_v4
    add rsp, 32
    movss xmm0, [rbp-584]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-580]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    call __print_float
section .data
.flt400: dq 0.0
section .text
    movsd xmm0, [rel .flt400]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt401: dq 0.0
section .text
    movsd xmm0, [rel .flt401]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt402: dq 5.0
section .text
    movsd xmm0, [rel .flt402]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl124:
    lea r11, [rbp-688]
    call v3
    add rsp, 32
    push rax
section .data
.flt403: dq 0.0
section .text
    movsd xmm0, [rel .flt403]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt404: dq 0.0
section .text
    movsd xmm0, [rel .flt404]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt405: dq 0.0
section .text
    movsd xmm0, [rel .flt405]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-704]
    call v3
    add rsp, 32
    push rax
section .data
.flt406: dq 0.0
section .text
    movsd xmm0, [rel .flt406]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt407: dq 1.0
section .text
    movsd xmm0, [rel .flt407]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt408: dq 0.0
section .text
    movsd xmm0, [rel .flt408]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    lea r11, [rbp-720]
    call v3
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-672]
    call m4_look_at
    add rsp, 32
    lea rax, [rbp-672]
    push rax
section .data
.flt409: dq 0.0
section .text
    movsd xmm0, [rel .flt409]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt410: dq 0.0
section .text
    movsd xmm0, [rel .flt410]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt411: dq 0.0
section .text
    movsd xmm0, [rel .flt411]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl125:
    lea r11, [rbp-752]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-736]
    call m4_mul_point
    add rsp, 32
    movss xmm0, [rbp-728]
    cvtss2sd xmm0, xmm0
    call __print_float
    sub rsp, 32
.kl126:
    lea r11, [rbp-880]
    call m4_identity
    add rsp, 32
    push rax
    mov rax, 2
    push rax
    mov rax, 3
    push rax
section .data
.flt412: dq 7.0
section .text
    movsd xmm0, [rel .flt412]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-816]
    call m4_set
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call pm
    add rsp, 32
.__ret_363:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq pm.kft, .kfe, .kfn, __kron_file_2,19
    dq .kl108,14
    dq .kl109,15
    dq .kl110,16
    dq .kl111,17
    dq .kl112,18
    dq .kl113,19
    dq .kl114,21
    dq .kl115,22
    dq .kl116,23
    dq .kl117,24
    dq .kl118,25
    dq .kl119,27
    dq .kl120,28
    dq .kl121,30
    dq .kl122,31
    dq .kl123,33
    dq .kl124,35
    dq .kl125,36
    dq .kl126,38
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,109,97,116,104,46,107,114,0
__kron_file_1: db 115,116,100,95,109,97,116,104,51,100,46,107,114,0
__kron_file_2: db 116,101,115,116,95,109,97,116,104,51,100,46,107,114,0
section .text
