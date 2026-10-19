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
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
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
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ob_ptr]
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
.str200: db 80,78,71,44,32,98,97,115,101,108,105,110,101,32,74,80,69,71,32,40,110,111,116,32,112,114,111,103,114,101,115,115,105,118,101,41,44,32,111,114,32,66,77,80,32,111,102,32,50,52,32,111,114,32,51,50,32,98,105,116,115,59,32,116
    db 104,101,32,102,105,108,101,32,109,97,121,32,98,101,32,100,97,109,97,103,101,100,0
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
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 8
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
    dq .kl43,48
    dq .kl44,52
    dq .kl45,54
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
    dq .kl46,60
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
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, 8
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
    dq .kl47,71
    dq .kl48,75
    dq .kl49,78
    dq .kl50,82
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
    dq .kl51,87
    dq .kl52,93
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
    dq .kl53,106
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
    dq .kl54,124
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
    dq .kl55,134
    dq .kl56,138
    dq .kl57,139
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
    mov rax, [rbp-64]
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, rbx
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
    jmp .L261
.L260:
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
    dq .kl58,146
    dq .kl59,155
    dq .kl60,187
    dq .kl61,213
    dq .kl62,215
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
    dq .kl63,226
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
    dq .kl64,235
    dq .kl65,238
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
    dq .kl66,245
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
    dq .kl67,250
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
    dq .kl68,255
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
    dq .kl69,260
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
    dq .kl70,265
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
    dq .kl71,270
    dq .kl72,274
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
    dq .kl73,279
    dq .kl74,285
    dq .kl75,288
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
    dq .kl76,293
    dq .kl77,299
    dq .kl78,300
    dq .kl79,304
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
    dq .kl80,309
    dq .kl81,316
    dq .kl82,330
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
    dq .kl83,335
    dq .kl84,337
    dq .kl85,349
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
    dq .kl86,354
    dq .kl87,358
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
    dq .kl88,363
    dq .kl89,378
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
    dq .kl90,383
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
    dq .kl91,388
    dq .kl92,403
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
    dq .kl93,408
    dq .kl94,411
    dq .kl95,413
    dq .kl96,414
    dq .kl97,415
    dq .kl98,418
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
.kl99:
    call list_get
    add rsp, 32
    jmp .__ret_335
.__ret_335:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_copy.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl99,428
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
.kl100:
    call list_set
    add rsp, 32
    jmp .__ret_336
.__ret_336:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_sget.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl100,432
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
.kl101:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L338
    mov rax, 0
    jmp .__ret_337
    jmp .L339
.L338:
.L339:
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp r14, 0
    jge .L340
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_337
    jmp .L341
.L340:
.L341:
    mov rax, r14
    push rax
    mov rax, rbx
    mov rcx, r13
    cqo
    idiv rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L342
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_337
    jmp .L343
.L342:
.L343:
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
    jmp .__ret_337
.__ret_337:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_sset.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl101,438
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
.kl102:
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
    jmp .__ret_344
.__ret_344:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq li_at_n.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl102,457
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
.kl103:
    call li_len
    add rsp, 32
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L346
    mov rax, r15
    push rax
    mov rax, r12
    add rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl104:
    call li_room
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L348
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
.kl105:
    call hp_copy
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, r12
    add rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L349
.L348:
.L349:
    jmp .L347
.L346:
.L347:
    mov rcx, r15
    sub rsp, 32
.kl106:
    call list_end
    add rsp, 32
    jmp .__ret_345
.__ret_345:
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
.kft: dq list_len_n.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl103,462
    dq .kl104,464
    dq .kl105,466
    dq .kl106,470
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
.kl107:
    call li_at_n
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L351
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
.kl108:
    call hp_copy
    add rsp, 32
    jmp .L352
.L351:
.L352:
    mov rcx, r13
    sub rsp, 32
.kl109:
    call list_end
    add rsp, 32
    jmp .__ret_350
.__ret_350:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add_n.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl107,475
    dq .kl108,477
    dq .kl109,479
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
.kl110:
    call li_at_n
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L354
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
.kl111:
    call hp_copy
    add rsp, 32
    jmp .L355
.L354:
.L355:
    mov rcx, r14
    sub rsp, 32
.kl112:
    call list_end
    add rsp, 32
    jmp .__ret_353
.__ret_353:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get_n.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl110,484
    dq .kl111,486
    dq .kl112,488
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
.kl113:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L357
    cmp r15, 0
    jge .L359
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L360
.L359:
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, r14
    cqo
    idiv rcx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L361
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L362
.L361:
    mov rax, [rbp-8]
    push rax
    mov rax, r13
    add rax, r14
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl114:
    call li_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L363
    mov rax, r13
    sub rax, 1
    mov rbx, rax
.L365:
    mov rax, rbx
    push rax
    mov rax, r15
    imul rax, r14
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L366
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
.L367:
    jmp .L365
.L366:
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
.kl115:
    call hp_copy
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, r13
    add rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L364
.L363:
.L364:
.L362:
.L360:
    jmp .L358
.L357:
.L358:
    mov rcx, [rbp-8]
    sub rsp, 32
.kl116:
    call list_end
    add rsp, 32
    jmp .__ret_356
.__ret_356:
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
.kft: dq list_set_n.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl113,493
    dq .kl114,500
    dq .kl115,509
    dq .kl116,514
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
.kl117:
    call li_at_n
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L369
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
.kl118:
    call hp_copy
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl119:
    call ob_get
    add rsp, 32
    mov r13, rax
    mov rax, r13
    mov rax, [rax]
    mov r12, rax
    mov rax, rbx
    imul rax, r14
    mov rbx, rax
.L371:
    mov rax, rbx
    push rax
    mov rax, r12
    sub rax, r14
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L372
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
.L373:
    jmp .L371
.L372:
    mov rax, r13
    push rax
    mov rax, r12
    sub rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L370
.L369:
.L370:
    mov rcx, r15
    sub rsp, 32
.kl120:
    call list_end
    add rsp, 32
    jmp .__ret_368
.__ret_368:
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
.kft: dq list_insert_n.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl117,519
    dq .kl118,521
    dq .kl119,522
    dq .kl120,533
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
.kl121:
    call li_len
    add rsp, 32
    mov rcx, r12
    cqo
    idiv rcx
    mov rbx, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L375
    cmp rbx, 0
    jne .L377
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L378
.L377:
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
.kl122:
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
.L378:
    jmp .L376
.L375:
.L376:
    mov rcx, r13
    sub rsp, 32
.kl123:
    call list_end
    add rsp, 32
    jmp .__ret_374
.__ret_374:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_remove_n.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl121,538
    dq .kl122,543
    dq .kl123,546
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
.kl124:
    call li_len
    add rsp, 32
    mov rcx, r13
    cqo
    idiv rcx
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L380
    cmp r12, 0
    jne .L382
    mov rax, 10
    mov [rel __g_hp_err], rax
    jmp .L383
.L382:
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
.kl125:
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
.kl126:
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
.L383:
    jmp .L381
.L380:
.L381:
    mov rcx, r14
    sub rsp, 32
.kl127:
    call list_end
    add rsp, 32
    jmp .__ret_379
.__ret_379:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_last_n.kft, .kfe, .kfn, __kron_file_1,4
    dq .kl124,551
    dq .kl125,556
    dq .kl126,557
    dq .kl127,561
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
.kl128:
    call ob_get
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    je .L385
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
.L387:
    cmp r13, r12
    jge .L388
    mov rax, 0
    mov rbx, rax
.L390:
    cmp rbx, r15
    jge .L391
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
.L392:
    jmp .L390
.L391:
    add r13, 1
    sub r12, 1
.L389:
    jmp .L387
.L388:
    jmp .L386
.L385:
.L386:
    mov rcx, [rbp-8]
    sub rsp, 32
.kl129:
    call list_end
    add rsp, 32
    jmp .__ret_384
.__ret_384:
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
.kft: dq list_pop_n.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl128,566
    dq .kl129,587
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
.kl130:
    call li_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_end
    add rsp, 32
    jmp .__ret_393
.__ret_393:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_reverse_n.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl130,597
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
.kl131:
    call li_get
    add rsp, 32
    mov rbx, rax
section .data
.flt395: dq 0.0
section .text
    movsd xmm0, [rel .flt395]
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
.kl132:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L396
    mov rcx, rbx
    sub rsp, 32
.kl133:
    call heap_fail
    add rsp, 32
section .data
.flt398: dq 0.0
section .text
    movsd xmm0, [rel .flt398]
    jmp .__ret_394
    jmp .L397
.L396:
.L397:
    movaps xmm0, xmm6
    jmp .__ret_394
.__ret_394:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_add_real.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl131,602
    dq .kl132,608
    dq .kl133,611
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
.kl134:
    call li_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L400
    movaps xmm0, xmm6
    movsd [rel __g_li_real], xmm0
    mov rax, rbx
    push rax
    lea rax, [rel __g_li_real]
    mov rax, [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L401
.L400:
.L401:
    sub rsp, 32
.kl135:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L402
    mov rcx, rbx
    sub rsp, 32
.kl136:
    call heap_fail
    add rsp, 32
section .data
.flt404: dq 0.0
section .text
    movsd xmm0, [rel .flt404]
    jmp .__ret_399
    jmp .L403
.L402:
.L403:
    movaps xmm0, xmm6
    jmp .__ret_399
.__ret_399:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_get_real.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl134,619
    dq .kl135,626
    dq .kl136,629
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
.kl137:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L406
    mov rax, 0
    jmp .__ret_405
    jmp .L407
.L406:
.L407:
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl138:
    call ob_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L408
    mov rcx, r12
    sub rsp, 32
.kl139:
    call hp_release
    add rsp, 32
    jmp .L409
.L408:
.L409:
    mov rax, rbx
    jmp .__ret_405
.__ret_405:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_set_real.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl137,69
    dq .kl138,73
    dq .kl139,75
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
.kl140:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L411
    mov rax, 0
    jmp .__ret_410
    jmp .L412
.L411:
.L412:
    mov rcx, rbx
    sub rsp, 32
.kl141:
    call hp_room
    add rsp, 32
    push rax
    mov rax, 8
    add rax, r12
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L413
    mov rax, rbx
    jmp .__ret_410
    jmp .L414
.L413:
.L414:
    mov rax, rbx
    push rax
    mov rax, 8
    add rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl142:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L415
    mov rax, 0
    jmp .__ret_410
    jmp .L416
.L415:
.L416:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl143:
    call ob_put
    add rsp, 32
    mov rax, rbx
    jmp .__ret_410
.__ret_410:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_new.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl140,82
    dq .kl141,86
    dq .kl142,89
    dq .kl143,93
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
.kl144:
    call ob_get
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L418
    mov rax, 0
    jmp .__ret_417
    jmp .L419
.L418:
.L419:
    mov rax, 0
    mov r12, rax
    mov rax, r13
    mov rax, [rax]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r15, r13
    jl .L420
    mov rax, r15
    push rax
    mov rax, r13
    add rax, 8
    add rax, r12
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L422
    mov rax, r15
    sub rax, r13
    mov rbx, rax
    jmp .L423
.L422:
.L423:
    jmp .L421
.L420:
.L421:
    mov rax, [rbp-8]
    push rax
    mov rax, r12
    add rax, r14
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl145:
    call tx_room
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L424
    mov rax, 0
    jmp .__ret_417
    jmp .L425
.L424:
.L425:
    mov rax, r15
    mov r15, rax
    cmp rbx, 0
    je .L426
    mov rax, r13
    add rax, rbx
    mov r15, rax
    jmp .L427
.L426:
.L427:
    mov rax, r13
    add rax, 8
    add rax, r12
    push rax
    pop rcx
    mov rdx, r15
    mov r8, r14
    sub rsp, 32
.kl146:
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
    jmp .__ret_417
.__ret_417:
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
    dq .kl144,99
    dq .kl145,111
    dq .kl146,119
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
.kl147:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L429
    mov rax, 0
    jmp .__ret_428
    jmp .L430
.L429:
.L430:
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
.kl148:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_428
.__ret_428:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_bytes.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl147,128
    dq .kl148,131
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
.kl149:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L432
    mov rax, 0
    jmp .__ret_431
    jmp .L433
.L432:
.L433:
    mov rax, [rel __g_tv_n]
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
.kl150:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L434
    mov rax, 0
    jmp .__ret_431
    jmp .L435
.L434:
.L435:
    mov rcx, r13
    sub rsp, 32
.kl151:
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
.kl152:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_431
.__ret_431:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl149,135
    dq .kl150,139
    dq .kl151,143
    dq .kl152,144
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
.kl153:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L437
    mov rax, 0
    jmp .__ret_436
    jmp .L438
.L437:
.L438:
    mov rcx, rbx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
.kl154:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_436
.__ret_436:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_copy.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl153,148
    dq .kl154,152
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
    jge .L440
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov rbx, rax
    jmp .L441
.L440:
    cmp r12, 2048
    jge .L442
    mov rax, rbx
    push rax
    mov rax, r12
    sar rax, 6
    mov rcx, rax
    mov rax, 192
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 2
    mov rbx, rax
    jmp .L443
.L442:
    cmp r12, 65536
    jge .L444
    mov rax, rbx
    push rax
    mov rax, r12
    sar rax, 12
    mov rcx, rax
    mov rax, 224
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, r12
    sar rax, 6
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 3
    mov rbx, rax
    jmp .L445
.L444:
    mov rax, rbx
    push rax
    mov rax, r12
    sar rax, 18
    mov rcx, rax
    mov rax, 240
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, r12
    sar rax, 12
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 2
    push rax
    mov rax, r12
    sar rax, 6
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, rbx
    add rax, 3
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 4
    mov rbx, rax
.L445:
.L443:
.L441:
    mov rax, r13
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl155:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_439
.__ret_439:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_from_bytes.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl155,181
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
    jge .L447
    mov rax, 1
    mov r14, rax
    jmp .L448
.L447:
.L448:
    cmp r15, 0
    jne .L449
    mov rax, r12
    add rax, 31
    push rax
    mov rax, 48
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov r13, rax
    jmp .L450
.L449:
.L450:
.L451:
    cmp r15, 0
    je .L452
    mov rax, r15
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rbx, rax
    cmp rbx, 0
    jge .L454
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L455
.L454:
.L455:
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
.L453:
    jmp .L451
.L452:
    mov rax, r14
    test rax, rax
    jz .L456
    mov rax, r12
    add rax, 31
    sub rax, r13
    push rax
    mov rax, 45
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
    jmp .L457
.L456:
.L457:
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
.kl156:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_446
.__ret_446:
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
    dq .kl156,212
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
    jge .L459
    mov rax, 0
    mov r14, rax
    jmp .L460
.L459:
.L460:
    cmp r14, 15
    jle .L461
    mov rax, 15
    mov r14, rax
    jmp .L462
.L461:
.L462:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl157:
    call tx_is_nan
    add rsp, 32
    test rax, rax
    jz .L463
    mov rax, r15
    push rax
section .data
.str465: db 110,97,110,0
section .text
    lea rax, [rel .str465]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
.kl158:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_458
    jmp .L464
.L463:
.L464:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt468: dq 0.0
section .text
    movsd xmm0, [rel .flt468]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L466
    mov rax, r15
    push rax
section .data
.str471: db 45,0
section .text
    lea rax, [rel .str471]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl159:
    call tx_add_bytes
    add rsp, 32
    cmp rax, 0
    jne .L469
    mov rax, 0
    jmp .__ret_458
    jmp .L470
.L469:
.L470:
section .data
.flt472: dq 0.0
section .text
    movsd xmm0, [rel .flt472]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L467
.L466:
.L467:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt475: dq 9000000000000000000.0
section .text
    movsd xmm0, [rel .flt475]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L473
    mov rax, 0
    mov rbx, rax
.L476:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt479: dq 10.0
section .text
    movsd xmm0, [rel .flt479]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L477
section .data
.flt480: dq 10.0
section .text
    movsd xmm0, [rel .flt480]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    add rbx, 1
    cmp rbx, 400
    jle .L481
    mov rax, r15
    push rax
section .data
.str483: db 105,110,102,0
section .text
    lea rax, [rel .str483]
    push rax
    pop rdx
    pop rcx
    mov r8, 3
    sub rsp, 32
.kl160:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_458
    jmp .L482
.L481:
.L482:
.L478:
    jmp .L476
.L477:
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
.kl161:
    call tx_add_real
    add rsp, 32
    mov rax, r15
    push rax
section .data
.str484: db 101,43,0
section .text
    lea rax, [rel .str484]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl162:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl163:
    call tx_add_int
    add rsp, 32
    jmp .__ret_458
    jmp .L474
.L473:
.L474:
section .data
.flt485: dq 1.0
section .text
    movsd xmm0, [rel .flt485]
    movaps xmm7, xmm0
    mov rax, 0
    mov rbx, rax
.L486:
    cmp rbx, r14
    jge .L487
section .data
.flt489: dq 10.0
section .text
    movsd xmm0, [rel .flt489]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
    add rbx, 1
.L488:
    jmp .L486
.L487:
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
.flt490: dq 0.5
section .text
    movsd xmm0, [rel .flt490]
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
    jl .L491
    add r12, 1
    sub r13, rbx
    jmp .L492
.L491:
.L492:
    mov rcx, r15
    mov rdx, r12
    sub rsp, 32
.kl164:
    call tx_add_int
    add rsp, 32
    cmp rax, 0
    jne .L493
    mov rax, 0
    jmp .__ret_458
    jmp .L494
.L493:
.L494:
    cmp r14, 0
    jne .L495
    mov rax, r15
    jmp .__ret_458
    jmp .L496
.L495:
.L496:
    mov rax, r15
    push rax
section .data
.str497: db 46,0
section .text
    lea rax, [rel .str497]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl165:
    call tx_add_bytes
    add rsp, 32
    mov rax, 1
    mov r12, rax
    mov rax, r13
    mov rbx, rax
.L498:
    cmp rbx, 10
    jl .L499
    mov rax, rbx
    mov rcx, 10
    cqo
    idiv rcx
    mov rbx, rax
    add r12, 1
.L500:
    jmp .L498
.L499:
.L501:
    cmp r12, r14
    jge .L502
    mov rax, r15
    push rax
section .data
.str504: db 48,0
section .text
    lea rax, [rel .str504]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl166:
    call tx_add_bytes
    add rsp, 32
    add r12, 1
.L503:
    jmp .L501
.L502:
    mov rcx, r15
    mov rdx, r13
    sub rsp, 32
.kl167:
    call tx_add_int
    add rsp, 32
    jmp .__ret_458
.__ret_458:
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
    dq .kl157,224
    dq .kl158,225
    dq .kl159,228
    dq .kl160,240
    dq .kl161,243
    dq .kl162,244
    dq .kl163,245
    dq .kl164,261
    dq .kl165,267
    dq .kl166,276
    dq .kl167,279
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
    je .L506
    mov rax, 0
    jmp .__ret_505
    jmp .L507
.L506:
.L507:
    mov rax, rbx
    mov rcx, 4503599627370495
    and rax, rcx
    cmp rax, 0
    jne .L508
    mov rax, 0
    jmp .__ret_505
    jmp .L509
.L508:
.L509:
    mov rax, 1
    jmp .__ret_505
.__ret_505:
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
.kl168:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L511
    mov rax, 1
    neg rax
    jmp .__ret_510
    jmp .L512
.L511:
.L512:
    mov rax, [rel __g_tv_p]
    mov [rbp-32], rax
    mov rax, [rel __g_tv_n]
    mov r15, rax
    mov rcx, r12
    sub rsp, 32
.kl169:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L513
    mov rax, 1
    neg rax
    jmp .__ret_510
    jmp .L514
.L513:
.L514:
    mov rax, [rel __g_tv_p]
    mov [rbp-48], rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, rbx
    mov r13, rax
    cmp r13, 0
    jge .L515
    mov rax, 0
    mov r13, rax
    jmp .L516
.L515:
.L516:
    mov rax, 1
    neg rax
    mov r12, rax
.L517:
    mov rax, r13
    add rax, r14
    cmp rax, r15
    jg .L518
    mov rax, 0
    mov rbx, rax
.L520:
    cmp rbx, r14
    jge .L521
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
    je .L523
    mov rax, r14
    add rax, 1
    mov rbx, rax
    jmp .L524
.L523:
    add rbx, 1
.L524:
.L522:
    jmp .L520
.L521:
    cmp rbx, r14
    jne .L525
    mov rax, r13
    mov r12, rax
    mov rax, r15
    mov r13, rax
    jmp .L526
.L525:
.L526:
    add r13, 1
.L519:
    jmp .L517
.L518:
    mov rax, r12
    jmp .__ret_510
.__ret_510:
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
    dq .kl168,300
    dq .kl169,305
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
.kl170:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L528
    mov rax, 0
    jmp .__ret_527
    jmp .L529
.L528:
.L529:
    mov rax, [rel __g_tv_n]
    mov rbx, rax
    mov rax, r12
    mov r13, rax
    cmp r13, 0
    jge .L530
    mov rax, 0
    mov r13, rax
    jmp .L531
.L530:
.L531:
    cmp r13, rbx
    jle .L532
    mov rax, rbx
    mov r13, rax
    jmp .L533
.L532:
.L533:
    mov rax, r13
    add rax, r15
    mov r12, rax
    cmp r15, 0
    jge .L534
    mov rax, r13
    mov r12, rax
    jmp .L535
.L534:
.L535:
    cmp r12, rbx
    jle .L536
    mov rax, rbx
    mov r12, rax
    jmp .L537
.L536:
.L537:
    mov rax, r12
    sub rax, r13
    push rax
    pop rcx
    sub rsp, 32
.kl171:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L538
    mov rax, 0
    jmp .__ret_527
    jmp .L539
.L538:
.L539:
    mov rcx, r14
    sub rsp, 32
.kl172:
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
.kl173:
    call tx_add_bytes
    add rsp, 32
    jmp .__ret_527
.__ret_527:
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
    dq .kl170,336
    dq .kl171,354
    dq .kl172,358
    dq .kl173,359
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
.kl174:
    call li_new
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L541
    mov rax, 0
    jmp .__ret_540
    jmp .L542
.L541:
.L542:
    mov rcx, [rbp-16]
    sub rsp, 32
.kl175:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L543
    mov rax, 0
    jmp .__ret_540
    jmp .L544
.L543:
.L544:
    mov rax, [rel __g_tv_n]
    mov [rbp-32], rax
    mov rcx, r15
    sub rsp, 32
.kl176:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L545
    mov rax, 0
    jmp .__ret_540
    jmp .L546
.L545:
.L546:
    mov rax, [rel __g_tv_n]
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L547
.L549:
    cmp r12, r13
    jge .L550
    mov rax, r14
    push rax
    mov rcx, r15
    mov rdx, r12
    mov r8, 1
    sub rsp, 32
.kl177:
    call tx_part
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    add r12, 1
.L551:
    jmp .L549
.L550:
    mov rax, r14
    jmp .__ret_540
    jmp .L548
.L547:
.L548:
.L552:
    cmp r12, r13
    jg .L553
    mov rcx, r15
    mov rdx, [rbp-16]
    mov r8, r12
    sub rsp, 32
.kl178:
    call tx_find
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L555
    mov rax, r13
    mov rbx, rax
    jmp .L556
.L555:
.L556:
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
.kl179:
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
    jne .L557
    mov rax, r13
    add rax, 1
    mov r12, rax
    jmp .L558
.L557:
.L558:
.L554:
    jmp .L552
.L553:
    mov rax, r14
    jmp .__ret_540
.__ret_540:
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
    dq .kl174,364
    dq .kl175,368
    dq .kl176,372
    dq .kl177,380
    dq .kl178,386
    dq .kl179,390
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
.kl180:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L560
    mov rax, 0
    jmp .__ret_559
    jmp .L561
.L560:
.L561:
    mov rax, [rel __g_tv_p]
    mov r15, rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, 1
    cmp rax, 2
    jne .L562
    mov rax, 0
    mov r12, rax
.L564:
    cmp r12, r14
    jge .L565
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
.kl181:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jg .L567
    mov rax, r14
    mov r12, rax
    jmp .L568
.L567:
    add r12, rbx
.L568:
.L566:
    jmp .L564
.L565:
    jmp .L563
.L562:
    mov rax, [rel __g_tx_ready]
    cmp rax, 0
    jne .L569
section .data
.str571: db 107,101,114,110,101,108,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str571]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
section .data
.str572: db 71,101,116,83,116,100,72,97,110,100,108,101,0
section .text
    lea rax, [rel .str572]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov r12, rax
    mov rax, r13
    push rax
section .data
.str573: db 83,101,116,67,111,110,115,111,108,101,79,117,116,112,117,116,67,80,0
section .text
    lea rax, [rel .str573]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    push rax
section .data
.str574: db 87,114,105,116,101,70,105,108,101,0
section .text
    lea rax, [rel .str574]
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
.kl182:
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
.kl183:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_tx_ignore], rax
    mov rax, 1
    mov [rel __g_tx_ready], rax
    jmp .L570
.L569:
.L570:
    cmp r14, 0
    jle .L575
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
.kl184:
    call r11
    add rsp, 48
    pop rsp
    add rsp, 48
    mov [rel __g_tx_ignore], rax
    jmp .L576
.L575:
.L576:
.L563:
    mov rax, 1
    jmp .__ret_559
.__ret_559:
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
    dq .kl180,401
    dq .kl181,410
    dq .kl182,423
    dq .kl183,424
    dq .kl184,428
.kfn: db "tx_out", 0
section .text
tx_byte_upper:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 97
    jl .L578
    cmp rbx, 122
    jg .L580
    mov rax, rbx
    sub rax, 32
    jmp .__ret_577
    jmp .L581
.L580:
.L581:
    jmp .L579
.L578:
.L579:
    mov rax, rbx
    jmp .__ret_577
.__ret_577:
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
    jl .L583
    cmp rbx, 90
    jg .L585
    mov rax, rbx
    add rax, 32
    jmp .__ret_582
    jmp .L586
.L585:
.L586:
    jmp .L584
.L583:
.L584:
    mov rax, rbx
    jmp .__ret_582
.__ret_582:
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
.kl185:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L588
    mov rax, 0
    jmp .__ret_587
    jmp .L589
.L588:
.L589:
    mov rax, [rel __g_tv_n]
    mov rbx, rax
    mov rax, 0
    mov r15, rax
    mov rax, rbx
    mov r14, rax
    mov rax, [rbp-16]
    cmp rax, 3
    jne .L590
    mov rax, [rel __g_tv_p]
    mov r12, rax
.L592:
    cmp r15, r14
    jge .L593
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
    jnz .L601
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L601
    mov rax, 0
    jmp .L602
.L601:
    mov rax, 1
.L602:
    test rax, rax
    jnz .L599
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L599
    mov rax, 0
    jmp .L600
.L599:
    mov rax, 1
.L600:
    test rax, rax
    jnz .L597
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L597
    mov rax, 0
    jmp .L598
.L597:
    mov rax, 1
.L598:
    test rax, rax
    jz .L595
    add r15, 1
    jmp .L596
.L595:
    jmp .L593
.L596:
.L594:
    jmp .L592
.L593:
.L603:
    cmp r14, r15
    jle .L604
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
    jnz .L612
    mov rax, rbx
    mov rcx, 9
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
    jnz .L610
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L610
    mov rax, 0
    jmp .L611
.L610:
    mov rax, 1
.L611:
    test rax, rax
    jnz .L608
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L608
    mov rax, 0
    jmp .L609
.L608:
    mov rax, 1
.L609:
    test rax, rax
    jz .L606
    sub r14, 1
    jmp .L607
.L606:
    jmp .L604
.L607:
.L605:
    jmp .L603
.L604:
    jmp .L591
.L590:
.L591:
    mov rax, r14
    sub rax, r15
    push rax
    pop rcx
    sub rsp, 32
.kl186:
    call tx_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L614
    mov rax, 0
    jmp .__ret_587
    jmp .L615
.L614:
.L615:
    mov rcx, [rbp-8]
    sub rsp, 32
.kl187:
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
.kl188:
    call tx_add_bytes
    add rsp, 32
    mov rax, [rbp-16]
    cmp rax, 3
    jne .L616
    mov rax, r13
    jmp .__ret_587
    jmp .L617
.L616:
.L617:
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl189:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L618:
    mov rax, rbx
    push rax
    mov rax, r14
    sub rax, r15
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L619
    mov rax, r12
    add rax, 8
    add rax, rbx
    movzx rax, byte [rax]
    mov [rbp-96], rax
    mov rax, [rbp-16]
    cmp rax, 1
    jne .L621
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rcx, [rbp-96]
    sub rsp, 32
.kl190:
    call tx_byte_upper
    add rsp, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    jmp .L622
.L621:
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rcx, [rbp-96]
    sub rsp, 32
.kl191:
    call tx_byte_lower
    add rsp, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cl
.L622:
    add rbx, 1
.L620:
    jmp .L618
.L619:
    mov rax, r13
    jmp .__ret_587
.__ret_587:
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
    dq .kl185,455
    dq .kl186,482
    dq .kl187,486
    dq .kl188,487
    dq .kl189,491
    dq .kl190,497
    dq .kl191,499
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
.flt624: dq 0.0
section .text
    movsd xmm0, [rel .flt624]
    movsd [rel __g_tx_real], xmm0
    mov rcx, r12
    sub rsp, 32
.kl192:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L625
    mov rax, 0
    jmp .__ret_623
    jmp .L626
.L625:
.L626:
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
.flt627: dq 0.0
section .text
    movsd xmm0, [rel .flt627]
    movaps xmm7, xmm0
    mov rax, 0
    mov [rbp-72], rax
    mov rax, 0
    mov r12, rax
.L628:
    cmp r13, r14
    jge .L629
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
    jnz .L633
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L633
    mov rax, 0
    jmp .L634
.L633:
    mov rax, 1
.L634:
    test rax, rax
    jz .L631
    add r13, 1
    jmp .L632
.L631:
    jmp .L629
.L632:
.L630:
    jmp .L628
.L629:
    cmp r13, r14
    jge .L635
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    cmp r12, 45
    jne .L637
    mov rax, 1
    mov [rbp-48], rax
    add r13, 1
    jmp .L638
.L637:
    cmp r12, 43
    jne .L639
    add r13, 1
    jmp .L640
.L639:
.L640:
.L638:
    jmp .L636
.L635:
.L636:
.L641:
    cmp r13, r14
    jge .L642
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
    jz .L646
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L646
    mov rax, 1
    jmp .L647
.L646:
    mov rax, 0
.L647:
    test rax, rax
    jz .L644
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
.flt648: dq 10.0
section .text
    movsd xmm0, [rel .flt648]
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
    jmp .L645
.L644:
    jmp .L642
.L645:
.L643:
    jmp .L641
.L642:
    mov rax, rbx
    test rax, rax
    jz .L649
    cmp r13, r14
    jge .L651
    mov rax, r15
    add rax, r13
    movzx rax, byte [rax]
    cmp rax, 46
    jne .L653
    add r13, 1
section .data
.flt655: dq 0.1
section .text
    movsd xmm0, [rel .flt655]
    movaps xmm6, xmm0
.L656:
    cmp r13, r14
    jge .L657
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
    jz .L661
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L661
    mov rax, 1
    jmp .L662
.L661:
    mov rax, 0
.L662:
    test rax, rax
    jz .L659
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
.flt663: dq 10.0
section .text
    movsd xmm0, [rel .flt663]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    divsd xmm0, xmm1
    movaps xmm6, xmm0
    mov rax, [rbp-72]
    add rax, 1
    mov [rbp-72], rax
    add r13, 1
    jmp .L660
.L659:
    jmp .L657
.L660:
.L658:
    jmp .L656
.L657:
    jmp .L654
.L653:
.L654:
    jmp .L652
.L651:
.L652:
    mov rax, [rbp-72]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L666
    mov rax, r13
    mov rcx, r14
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L666
    mov rax, 1
    jmp .L667
.L666:
    mov rax, 0
.L667:
    test rax, rax
    jz .L664
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
    jnz .L670
    mov rax, r12
    mov rcx, 69
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L670
    mov rax, 0
    jmp .L671
.L670:
    mov rax, 1
.L671:
    test rax, rax
    jz .L668
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
    jge .L672
    mov rax, r15
    add rax, rbx
    movzx rax, byte [rax]
    mov r12, rax
    cmp r12, 45
    jne .L674
    mov rax, 1
    mov [rbp-104], rax
    add rbx, 1
    jmp .L675
.L674:
    cmp r12, 43
    jne .L676
    add rbx, 1
    jmp .L677
.L676:
.L677:
.L675:
    jmp .L673
.L672:
.L673:
.L678:
    cmp rbx, r14
    jge .L679
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
    jz .L683
    mov rax, r12
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L683
    mov rax, 1
    jmp .L684
.L683:
    mov rax, 0
.L684:
    test rax, rax
    jz .L681
    mov rax, [rbp-112]
    cmp rax, 10000
    jge .L685
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
    jmp .L686
.L685:
.L686:
    mov rax, [rbp-120]
    add rax, 1
    mov [rbp-120], rax
    add rbx, 1
    jmp .L682
.L681:
    jmp .L679
.L682:
.L680:
    jmp .L678
.L679:
    mov rax, [rbp-120]
    cmp rax, 0
    jle .L687
    mov rax, rbx
    mov r13, rax
.L689:
    mov rax, [rbp-112]
    cmp rax, 0
    jle .L690
    mov rax, [rbp-104]
    test rax, rax
    jz .L692
section .data
.flt694: dq 10.0
section .text
    movsd xmm0, [rel .flt694]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    divsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L693
.L692:
section .data
.flt695: dq 10.0
section .text
    movsd xmm0, [rel .flt695]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    movaps xmm7, xmm0
.L693:
    mov rax, [rbp-112]
    sub rax, 1
    mov [rbp-112], rax
.L691:
    jmp .L689
.L690:
    jmp .L688
.L687:
.L688:
    jmp .L669
.L668:
.L669:
    jmp .L665
.L664:
.L665:
    jmp .L650
.L649:
.L650:
.L696:
    cmp r13, r14
    jge .L697
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
    jnz .L705
    mov rax, r12
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L705
    mov rax, 0
    jmp .L706
.L705:
    mov rax, 1
.L706:
    test rax, rax
    jnz .L703
    mov rax, r12
    mov rcx, 10
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L703
    mov rax, 0
    jmp .L704
.L703:
    mov rax, 1
.L704:
    test rax, rax
    jnz .L701
    mov rax, r12
    mov rcx, 13
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L701
    mov rax, 0
    jmp .L702
.L701:
    mov rax, 1
.L702:
    test rax, rax
    jz .L699
    add r13, 1
    jmp .L700
.L699:
    jmp .L697
.L700:
.L698:
    jmp .L696
.L697:
    mov rax, [rbp-72]
    cmp rax, 0
    jle .L707
    cmp r13, r14
    jne .L709
    mov rax, 1
    mov [rel __g_tx_ok], rax
    jmp .L710
.L709:
.L710:
    jmp .L708
.L707:
.L708:
    mov rax, [rbp-48]
    test rax, rax
    jz .L711
    mov rax, 0
    mov rcx, [rbp-56]
    sub rax, rcx
    mov [rbp-56], rax
section .data
.flt713: dq 0.0
section .text
    movsd xmm0, [rel .flt713]
    movaps xmm1, xmm7
    subsd xmm0, xmm1
    movaps xmm7, xmm0
    jmp .L712
.L711:
.L712:
    movaps xmm0, xmm7
    movsd [rel __g_tx_real], xmm0
    mov rax, [rbp-56]
    jmp .__ret_623
.__ret_623:
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
    dq .kl192,514
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
.kl193:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L715
    mov rcx, rbx
    sub rsp, 32
.kl194:
    call heap_fail
    add rsp, 32
    jmp .__ret_714
    jmp .L716
.L715:
.L716:
    mov rax, r12
    jmp .__ret_714
.__ret_714:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_parse.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl193,639
    dq .kl194,642
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
.kl195:
    call tx_copy
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_717
.__ret_717:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_end.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl195,649
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
.kl196:
    call tx_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_718
.__ret_718:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl196,654
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
.kl197:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L720
    mov rcx, r12
    sub rsp, 32
.kl198:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl199:
    call hp_release
    add rsp, 32
    jmp .L721
.L720:
.L721:
    mov rcx, 0
    sub rsp, 32
.kl200:
    call text_end
    add rsp, 32
    jmp .__ret_719
.__ret_719:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_new.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl197,659
    dq .kl198,661
    dq .kl199,662
    dq .kl200,664
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
.kl201:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L723
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl202:
    call tx_add_int
    add rsp, 32
    jmp .L724
.L723:
.L724:
    mov rcx, rbx
    sub rsp, 32
.kl203:
    call text_end
    add rsp, 32
    jmp .__ret_722
.__ret_722:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_free.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl201,669
    dq .kl202,671
    dq .kl203,673
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
.kl204:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L726
    cmp r12, 0
    jge .L728
    mov rax, rbx
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl205:
    call tx_add_real_short
    add rsp, 32
    jmp .L729
.L728:
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
.kl206:
    call tx_add_real
    add rsp, 32
.L729:
    jmp .L727
.L726:
.L727:
    mov rcx, rbx
    sub rsp, 32
.kl207:
    call text_end
    add rsp, 32
    jmp .__ret_725
.__ret_725:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_from_int.kft, .kfe, .kfn, __kron_file_2,4
    dq .kl204,678
    dq .kl205,681
    dq .kl206,683
    dq .kl207,686
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
.kl208:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L731
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl209:
    call tx_add_char
    add rsp, 32
    jmp .L732
.L731:
.L732:
    mov rcx, rbx
    sub rsp, 32
.kl210:
    call text_end
    add rsp, 32
    jmp .__ret_730
.__ret_730:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_from_real.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl208,691
    dq .kl209,693
    dq .kl210,695
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
    jge .L734
    mov rax, 1
    mov [rel __g_hp_err], rax
    jmp .L735
.L734:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl211:
    call tx_from_bytes
    add rsp, 32
    mov rbx, rax
.L735:
    mov rcx, rbx
    sub rsp, 32
.kl212:
    call text_end
    add rsp, 32
    jmp .__ret_733
.__ret_733:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_char.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl211,704
    dq .kl212,706
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
.kl213:
    call tx_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_736
.__ret_736:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_from_bytes.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl213,711
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
.kl214:
    call tx_add_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_737
.__ret_737:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl214,716
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
    jge .L739
    mov rax, r12
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl215:
    call tx_add_real_short
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_738
    jmp .L740
.L739:
.L740:
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
.kl216:
    call tx_add_real
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_738
.__ret_738:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add_int.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl215,722
    dq .kl216,724
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
.kl217:
    call tx_add_char
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_741
.__ret_741:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add_real.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl217,729
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
.kl218:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L743
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
    jmp .L744
.L743:
.L744:
    mov rcx, r12
    sub rsp, 32
.kl219:
    call text_end
    add rsp, 32
    jmp .__ret_742
.__ret_742:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_add_char.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl218,734
    dq .kl219,741
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
.kl220:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L746
    mov rax, [rel __g_tv_n]
    mov rbx, rax
    jmp .L747
.L746:
.L747:
    mov rcx, rbx
    sub rsp, 32
.kl221:
    call text_end
    add rsp, 32
    jmp .__ret_745
.__ret_745:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_clear.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl220,747
    dq .kl221,750
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
.kl222:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L749
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L753
    mov rax, r12
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L753
    mov rax, 0
    jmp .L754
.L753:
    mov rax, 1
.L754:
    test rax, rax
    jz .L751
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L752
.L751:
    mov rax, [rel __g_tv_p]
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
.L752:
    jmp .L750
.L749:
.L750:
    mov rcx, rbx
    sub rsp, 32
.kl223:
    call text_end
    add rsp, 32
    jmp .__ret_748
.__ret_748:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_len.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl222,756
    dq .kl223,763
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
.kl224:
    call ob_get
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    je .L756
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
    jnz .L760
    mov rax, r14
    mov rcx, rbx
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L760
    mov rax, 0
    jmp .L761
.L760:
    mov rax, 1
.L761:
    test rax, rax
    jz .L758
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L759
.L758:
    mov rax, r12
    add rax, 8
    add rax, r14
    push rax
    mov rax, r13
    and rax, 255
    mov rcx, rax
    pop rdx
    mov [rdx], cl
.L759:
    jmp .L757
.L756:
.L757:
    mov rcx, r15
    sub rsp, 32
.kl225:
    call text_end
    add rsp, 32
    jmp .__ret_755
.__ret_755:
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
    dq .kl224,768
    dq .kl225,778
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
.kl226:
    call tv_compare
    add rsp, 32
    cmp rax, 0
    jne .L763
    mov rax, 1
    mov rbx, rax
    jmp .L764
.L763:
.L764:
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    je .L765
    mov rax, 0
    mov rbx, rax
    jmp .L766
.L765:
.L766:
    mov rcx, rbx
    sub rsp, 32
.kl227:
    call text_end
    add rsp, 32
    jmp .__ret_762
.__ret_762:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_set_at.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl226,784
    dq .kl227,790
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
.kl228:
    call tv_compare
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_767
.__ret_767:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_same.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl228,795
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
.kl229:
    call tx_find
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_768
.__ret_768:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_compare.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl229,800
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
.kl230:
    call tx_find
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
.kft: dq text_find.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl230,805
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
.kl231:
    call tx_find
    add rsp, 32
    cmp rax, 0
    jl .L771
    mov rax, 1
    mov rbx, rax
    jmp .L772
.L771:
.L772:
    mov rcx, rbx
    sub rsp, 32
.kl232:
    call text_end
    add rsp, 32
    jmp .__ret_770
.__ret_770:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_find_after.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl231,811
    dq .kl232,814
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
.kl233:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L774
    mov rax, [rel __g_tv_n]
    mov r12, rax
    jmp .L775
.L774:
.L775:
    cmp r12, 0
    jle .L776
    mov rcx, r15
    mov rdx, r14
    mov r8, 0
    sub rsp, 32
.kl234:
    call tx_find
    add rsp, 32
    mov rbx, rax
.L778:
    cmp rbx, 0
    jl .L779
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
.kl235:
    call tx_find
    add rsp, 32
    mov rbx, rax
.L780:
    jmp .L778
.L779:
    jmp .L777
.L776:
.L777:
    mov rcx, r13
    sub rsp, 32
.kl236:
    call text_end
    add rsp, 32
    jmp .__ret_773
.__ret_773:
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
    dq .kl233,821
    dq .kl234,825
    dq .kl235,828
    dq .kl236,831
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
.kl237:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L782
    mov rax, [rel __g_tv_n]
    mov r13, rax
    mov rax, [rel __g_tv_p]
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
.kl238:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L784
    mov rax, r13
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jg .L786
    mov rax, 1
    mov r14, rax
    mov rax, 0
    mov rbx, rax
.L788:
    cmp rbx, r13
    jge .L789
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
    je .L791
    mov rax, 0
    mov r14, rax
    mov rax, r13
    mov rbx, rax
    jmp .L792
.L791:
.L792:
    add rbx, 1
.L790:
    jmp .L788
.L789:
    jmp .L787
.L786:
.L787:
    jmp .L785
.L784:
.L785:
    jmp .L783
.L782:
.L783:
    mov rcx, r14
    sub rsp, 32
.kl239:
    call text_end
    add rsp, 32
    jmp .__ret_781
.__ret_781:
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
    dq .kl237,837
    dq .kl238,840
    dq .kl239,856
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
.kl240:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L794
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rax, [rel __g_tv_p]
    mov r13, rax
    mov rcx, r12
    sub rsp, 32
.kl241:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L796
    mov rax, r14
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jg .L798
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
.L800:
    cmp rbx, r14
    jge .L801
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
    je .L803
    mov rax, 0
    mov r15, rax
    mov rax, r14
    mov rbx, rax
    jmp .L804
.L803:
.L804:
    add rbx, 1
.L802:
    jmp .L800
.L801:
    jmp .L799
.L798:
.L799:
    jmp .L797
.L796:
.L797:
    jmp .L795
.L794:
.L795:
    mov rcx, r15
    sub rsp, 32
.kl242:
    call text_end
    add rsp, 32
    jmp .__ret_793
.__ret_793:
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
    dq .kl240,862
    dq .kl241,865
    dq .kl242,882
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
.kl243:
    call tx_parse
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L806
    mov rax, [rel __g_tx_ok]
    cmp rax, 0
    jne .L808
    mov rax, 7
    mov [rel __g_hp_err], rax
    mov rax, 0
    mov rbx, rax
    jmp .L809
.L808:
.L809:
    jmp .L807
.L806:
.L807:
    mov rcx, rbx
    sub rsp, 32
.kl244:
    call text_end
    add rsp, 32
    jmp .__ret_805
.__ret_805:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_ends.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl243,887
    dq .kl244,894
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
.kl245:
    call tx_parse
    add rsp, 32
    movsd xmm0, [rel __g_tx_real]
    movaps xmm6, xmm0
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L811
    mov rax, [rel __g_tx_ok]
    cmp rax, 0
    jne .L813
    mov rax, 7
    mov [rel __g_hp_err], rax
section .data
.flt815: dq 0.0
section .text
    movsd xmm0, [rel .flt815]
    movaps xmm6, xmm0
    jmp .L814
.L813:
.L814:
    jmp .L812
.L811:
.L812:
    sub rsp, 32
.kl246:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L816
    mov rcx, rbx
    sub rsp, 32
.kl247:
    call heap_fail
    add rsp, 32
section .data
.flt818: dq 0.0
section .text
    movsd xmm0, [rel .flt818]
    jmp .__ret_810
    jmp .L817
.L816:
.L817:
    movaps xmm0, xmm6
    jmp .__ret_810
.__ret_810:
    mov rbx, [rbp-64]
    movups xmm6, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_to_int.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl245,899
    dq .kl246,907
    dq .kl247,910
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
.kl248:
    call tx_parse
    add rsp, 32
    mov rax, [rel __g_tx_ok]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl249:
    call text_end
    add rsp, 32
    jmp .__ret_819
.__ret_819:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_to_real.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl248,918
    dq .kl249,920
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
.kl250:
    call tx_parse
    add rsp, 32
    mov rax, [rel __g_tx_ok]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl251:
    call text_end
    add rsp, 32
    jmp .__ret_820
.__ret_820:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_is_int.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl250,925
    dq .kl251,927
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
.kl252:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L822
    mov rax, 0
    mov rbx, rax
.L824:
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L825
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
.L826:
    jmp .L824
.L825:
    jmp .L823
.L822:
.L823:
    mov rcx, r12
    sub rsp, 32
.kl253:
    call text_end
    add rsp, 32
    jmp .__ret_821
.__ret_821:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_is_real.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl252,934
    dq .kl253,943
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
.kl254:
    call tx_part
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_827
.__ret_827:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_hash.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl254,948
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
.kl255:
    call tx_map
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_828
.__ret_828:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_part.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl255,953
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
.kl256:
    call tx_map
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
.kft: dq text_upper.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl256,958
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
.kl257:
    call tx_map
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
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
.kft: dq text_lower.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl257,963
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
.kl258:
    call tx_new
    add rsp, 32
    mov r14, rax
    mov rax, 0
    mov [rbp-40], rax
    cmp r14, 0
    je .L832
    mov rcx, [rbp-16]
    sub rsp, 32
.kl259:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L834
    mov rax, [rel __g_tv_n]
    mov [rbp-40], rax
    jmp .L835
.L834:
.L835:
    jmp .L833
.L832:
.L833:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L838
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L838
    mov rax, 1
    jmp .L839
.L838:
    mov rax, 0
.L839:
    test rax, rax
    jz .L836
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L840
    mov rcx, r14
    mov rdx, r15
    sub rsp, 32
.kl260:
    call tx_add
    add rsp, 32
    jmp .L841
.L840:
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
.kl261:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L842
    mov rax, [rel __g_tv_n]
    mov r12, rax
    jmp .L843
.L842:
.L843:
.L844:
    mov rax, r13
    mov rcx, r12
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L847
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L847
    mov rax, 1
    jmp .L848
.L847:
    mov rax, 0
.L848:
    test rax, rax
    jz .L845
    mov rcx, r15
    mov rdx, [rbp-16]
    mov r8, r13
    sub rsp, 32
.kl262:
    call tx_find
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L849
    mov rcx, r15
    sub rsp, 32
.kl263:
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
.kl264:
    call tx_add_bytes
    add rsp, 32
    mov rax, r12
    add rax, 1
    mov r13, rax
    jmp .L850
.L849:
    mov rcx, r15
    sub rsp, 32
.kl265:
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
.kl266:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r14
    mov rdx, [rbp-24]
    sub rsp, 32
.kl267:
    call tx_add
    add rsp, 32
    mov rax, rbx
    mov rcx, [rbp-40]
    add rax, rcx
    mov r13, rax
.L850:
.L846:
    jmp .L844
.L845:
.L841:
    jmp .L837
.L836:
.L837:
    mov rcx, r14
    sub rsp, 32
.kl268:
    call text_end
    add rsp, 32
    jmp .__ret_831
.__ret_831:
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
    dq .kl258,968
    dq .kl259,971
    dq .kl260,977
    dq .kl261,981
    dq .kl262,985
    dq .kl263,987
    dq .kl264,988
    dq .kl265,991
    dq .kl266,992
    dq .kl267,993
    dq .kl268,999
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
.kl269:
    call tx_new
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L852:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L857
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L857
    mov rax, 1
    jmp .L858
.L857:
    mov rax, 0
.L858:
    test rax, rax
    jz .L855
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L855
    mov rax, 1
    jmp .L856
.L855:
    mov rax, 0
.L856:
    test rax, rax
    jz .L853
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
.kl270:
    call tx_add
    add rsp, 32
    add rbx, 1
.L854:
    jmp .L852
.L853:
    mov rcx, r12
    sub rsp, 32
.kl271:
    call text_end
    add rsp, 32
    jmp .__ret_851
.__ret_851:
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
    dq .kl269,1004
    dq .kl270,1007
    dq .kl271,1010
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
.kl272:
    call tx_split
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_859
.__ret_859:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_repeat.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl272,1015
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
.str861: db 10,0
section .text
    lea rax, [rel .str861]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl273:
    call tx_split
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    je .L862
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_LIST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl274:
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
.L864:
    cmp r13, r14
    jge .L865
    mov rcx, r15
    mov rdx, r13
    sub rsp, 32
.kl275:
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
.kl276:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp rbx, 0
    jle .L867
    mov rax, r12
    add rax, 8
    add rax, rbx
    sub rax, 1
    movzx rax, byte [rax]
    cmp rax, 13
    jne .L869
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
    jmp .L870
.L869:
.L870:
    jmp .L868
.L867:
.L868:
    add r13, 1
.L866:
    jmp .L864
.L865:
    cmp r14, 0
    jle .L871
    mov rax, r15
    push rax
    mov rax, r14
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl277:
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
.kl278:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp rbx, 0
    jne .L873
    mov rcx, r13
    sub rsp, 32
.kl279:
    call ob_drop
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl280:
    call hp_release
    add rsp, 32
    mov rax, [rbp-24]
    push rax
    mov rax, r14
    sub rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L874
.L873:
.L874:
    jmp .L872
.L871:
.L872:
    jmp .L863
.L862:
.L863:
    mov rcx, r15
    sub rsp, 32
.kl281:
    call text_end
    add rsp, 32
    jmp .__ret_860
.__ret_860:
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
    dq .kl273,1020
    dq .kl274,1023
    dq .kl275,1028
    dq .kl276,1029
    dq .kl277,1042
    dq .kl278,1043
    dq .kl279,1047
    dq .kl280,1048
    dq .kl281,1053
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
.kl282:
    call li_len
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L876
    mov rcx, 16
    sub rsp, 32
.kl283:
    call tx_new
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L878:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L883
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L883
    mov rax, 1
    jmp .L884
.L883:
    mov rax, 0
.L884:
    test rax, rax
    jz .L881
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L881
    mov rax, 1
    jmp .L882
.L881:
    mov rax, 0
.L882:
    test rax, rax
    jz .L879
    cmp rbx, 0
    jle .L885
    mov rcx, r12
    mov rdx, r14
    sub rsp, 32
.kl284:
    call tx_add
    add rsp, 32
    jmp .L886
.L885:
.L886:
    mov rax, r12
    push rax
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl285:
    call li_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call tx_add
    add rsp, 32
    add rbx, 1
.L880:
    jmp .L878
.L879:
    jmp .L877
.L876:
.L877:
    mov rcx, r12
    sub rsp, 32
.kl286:
    call text_end
    add rsp, 32
    jmp .__ret_875
.__ret_875:
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
    dq .kl282,1058
    dq .kl283,1061
    dq .kl284,1065
    dq .kl285,1067
    dq .kl286,1071
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
.kl287:
    call li_sort
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_887
.__ret_887:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_join.kft, .kfe, .kfn, __kron_file_2,1
    dq .kl287,1076
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
.kl288:
    call tx_out
    add rsp, 32
section .data
.str889: db 10,0
section .text
    lea rax, [rel .str889]
    push rax
    pop rcx
    sub rsp, 32
.kl289:
    call tx_out
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl290:
    call text_end
    add rsp, 32
    jmp .__ret_888
.__ret_888:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_sort.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl288,1081
    dq .kl289,1082
    dq .kl290,1083
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
.kl291:
    call tx_add_real
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl292:
    call ob_get
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L891
    mov rax, 0
    jmp .__ret_890
    jmp .L892
.L891:
.L892:
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
.L893:
    cmp rbx, r13
    jge .L894
    mov rax, 0
    mov [rbp-56], rax
    mov rax, r14
    add rax, 8
    add rax, rbx
    movzx rax, byte [rax]
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 46
    jne .L896
    mov rax, rbx
    mov r12, rax
    jmp .L897
.L896:
.L897:
    add rbx, 1
.L895:
    jmp .L893
.L894:
    cmp r12, 0
    jge .L898
    mov rax, r15
    jmp .__ret_890
    jmp .L899
.L898:
.L899:
.L900:
    mov rax, r13
    push rax
    mov rax, r12
    add rax, 2
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L901
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    add rax, 8
    add rax, r13
    sub rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    cmp rbx, 48
    je .L903
    jmp .L901
    jmp .L904
.L903:
.L904:
    sub r13, 1
.L902:
    jmp .L900
.L901:
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
    jmp .__ret_890
.__ret_890:
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
    dq .kl291,1093
    dq .kl292,1094
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
.kl293:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L906
    mov rcx, r12
    sub rsp, 32
.kl294:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl295:
    call hp_release
    add rsp, 32
    jmp .L907
.L906:
.L907:
    mov rax, 0
    jmp .__ret_905
.__ret_905:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq tx_add_real_short.kft, .kfe, .kfn, __kron_file_2,3
    dq .kl293,1130
    dq .kl294,1132
    dq .kl295,1133
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
    jne .L909
    mov rax, r13
    push rax
section .data
.str911: db 34,0
section .text
    lea rax, [rel .str911]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl296:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl297:
    call tx_add
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str912: db 34,0
section .text
    lea rax, [rel .str912]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl298:
    call tx_add_bytes
    add rsp, 32
    mov rax, r13
    jmp .__ret_908
    jmp .L910
.L909:
.L910:
    cmp rbx, 2
    jne .L913
section .data
.flt915: dq 0.0
section .text
    movsd xmm0, [rel .flt915]
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
.kl299:
    call tx_add_real_short
    add rsp, 32
    jmp .__ret_908
    jmp .L914
.L913:
.L914:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl300:
    call tx_add_int
    add rsp, 32
    jmp .__ret_908
.__ret_908:
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
    dq .kl296,1140
    dq .kl297,1141
    dq .kl298,1142
    dq .kl299,1151
    dq .kl300,1153
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
.kl301:
    call tx_new
    add rsp, 32
    mov r13, rax
    mov rcx, r15
    sub rsp, 32
.kl302:
    call li_len
    add rsp, 32
    mov r12, rax
    mov rax, r13
    push rax
section .data
.str917: db 91,0
section .text
    lea rax, [rel .str917]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl303:
    call tx_add_bytes
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L918:
    cmp rbx, r12
    jge .L919
    cmp rbx, 0
    jle .L921
    mov rax, r13
    push rax
section .data
.str923: db 44,32,0
section .text
    lea rax, [rel .str923]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl304:
    call tx_add_bytes
    add rsp, 32
    jmp .L922
.L921:
.L922:
    mov rax, r13
    push rax
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl305:
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
.L920:
    jmp .L918
.L919:
    mov rax, r13
    push rax
section .data
.str924: db 93,10,0
section .text
    lea rax, [rel .str924]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl306:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl307:
    call tx_out
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl308:
    call tx_drop
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl309:
    call text_end
    add rsp, 32
    jmp .__ret_916
.__ret_916:
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
    dq .kl301,1158
    dq .kl302,1159
    dq .kl303,1160
    dq .kl304,1164
    dq .kl305,1166
    dq .kl306,1169
    dq .kl307,1170
    dq .kl308,1171
    dq .kl309,1172
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
.kl310:
    call tx_out
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl311:
    call text_end
    add rsp, 32
    jmp .__ret_925
.__ret_925:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq list_show.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl310,1177
    dq .kl311,1178
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
.kl312:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L927
    mov rax, [rel __g_tv_p]
    mov rbx, rax
    jmp .L928
.L927:
.L928:
    mov rcx, rbx
    sub rsp, 32
.kl313:
    call text_end
    add rsp, 32
    jmp .__ret_926
.__ret_926:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_print.kft, .kfe, .kfn, __kron_file_2,2
    dq .kl312,1184
    dq .kl313,1187
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
.L930:
    cmp rbx, r13
    jge .L931
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
.L932:
    jmp .L930
.L931:
    mov rax, r12
    jmp .__ret_929
.__ret_929:
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
.kl314:
    call hp_alloc
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L934
    mov rax, 0
    jmp .__ret_933
    jmp .L935
.L934:
.L935:
    mov rax, 8
    mov rcx, 3
    imul rax, rcx
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl315:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    mov rax, 16
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl316:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L938
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L938
    mov rax, 0
    jmp .L939
.L938:
    mov rax, 1
.L939:
    test rax, rax
    jz .L936
    mov rax, 0
    jmp .__ret_933
    jmp .L937
.L936:
.L937:
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
.kl317:
    call ob_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_933
.__ret_933:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_cstr.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl314,55
    dq .kl315,59
    dq .kl316,60
    dq .kl317,70
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
.L941:
    mov rax, r14
    test rax, rax
    jz .L942
    mov rax, [rbp-72]
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-56]
    add rax, rcx
    mov rax, [rax]
    mov r13, rax
    cmp r13, 0
    jne .L944
    mov rax, 0
    mov r14, rax
    jmp .L945
.L944:
    cmp r13, 0
    jle .L946
    mov rax, r13
    sub rax, 1
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-48]
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    add rax, 16
    mov rax, [rax]
    mov rcx, [rbp-32]
    cmp rax, rcx
    jne .L948
    mov rax, rbx
    mov rax, [rax]
    mov r12, rax
    cmp r12, 0
    je .L950
    mov rax, r12
    mov rax, [rax]
    cmp rax, r15
    jne .L952
    mov rax, 0
    mov rbx, rax
.L954:
    cmp rbx, r15
    jge .L955
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
    je .L957
    mov rax, r15
    add rax, 1
    mov rbx, rax
    jmp .L958
.L957:
    add rbx, 1
.L958:
.L956:
    jmp .L954
.L955:
    cmp rbx, r15
    jne .L959
    mov rax, r13
    sub rax, 1
    mov [rbp-40], rax
    mov rax, 0
    mov r14, rax
    jmp .L960
.L959:
.L960:
    jmp .L953
.L952:
.L953:
    jmp .L951
.L950:
.L951:
    jmp .L949
.L948:
.L949:
    jmp .L947
.L946:
.L947:
.L945:
    mov rax, [rbp-72]
    add rax, 1
    mov rcx, [rbp-64]
    and rax, rcx
    mov [rbp-72], rax
.L943:
    jmp .L941
.L942:
    mov rax, [rbp-40]
    jmp .__ret_940
.__ret_940:
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
.kl318:
    call hp_alloc
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L962
    mov rax, 0
    jmp .__ret_961
    jmp .L963
.L962:
.L963:
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
.L964:
    mov rax, r12
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L965
    mov rax, r12
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-32]
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    mov rax, [rax]
    cmp rax, 0
    je .L967
    cmp r13, r12
    je .L969
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-32]
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
    jmp .L970
.L969:
.L970:
    mov rax, r13
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-32]
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
.L971:
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    mov rax, [rax]
    cmp rax, 0
    je .L972
    mov rax, rbx
    add rax, 1
    push rax
    mov rax, [rbp-16]
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
.L973:
    jmp .L971
.L972:
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    push rax
    mov rax, r13
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add r13, 1
    jmp .L968
.L967:
.L968:
    add r12, 1
.L966:
    jmp .L964
.L965:
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
.kl319:
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
    jmp .__ret_961
.__ret_961:
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
    dq .kl318,117
    dq .kl319,145
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
.kl320:
    call ob_get
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jne .L975
    mov rax, 0
    jmp .__ret_974
    jmp .L976
.L975:
.L976:
    mov rcx, [rbp-16]
    sub rsp, 32
.kl321:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L977
    mov rax, 0
    jmp .__ret_974
    jmp .L978
.L977:
.L978:
    mov rax, [rel __g_tv_p]
    mov rbx, rax
    mov rax, [rel __g_tv_n]
    mov r14, rax
    mov rcx, rbx
    mov rdx, r14
    sub rsp, 32
.kl322:
    call mp_hash
    add rsp, 32
    mov [rbp-56], rax
    mov rcx, r15
    mov rdx, rbx
    mov r8, r14
    mov r9, [rbp-56]
    sub rsp, 32
.kl323:
    call mp_find
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jl .L979
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
    jmp .__ret_974
    jmp .L980
.L979:
.L980:
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
    jle .L981
    mov rax, r15
    push rax
    mov rax, r12
    mov rcx, 2
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl324:
    call mp_rebuild
    add rsp, 32
    cmp rax, 0
    jne .L983
    mov rax, 0
    jmp .__ret_974
    jmp .L984
.L983:
.L984:
    mov rax, r15
    add rax, 8
    mov rax, [rax]
    mov r13, rax
    mov rax, r15
    add rax, 24
    mov rax, [rax]
    mov r12, rax
    jmp .L982
.L981:
.L982:
    mov rax, r13
    add rax, 1
    cmp rax, rbx
    jle .L985
    mov rcx, r15
    sub rsp, 32
.kl325:
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
    jne .L987
    mov rax, 0
    jmp .__ret_974
    jmp .L988
.L987:
.L988:
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
    jmp .L986
.L985:
.L986:
    mov rax, 8
    add rax, r14
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
.kl326:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L989
    mov rax, 0
    jmp .__ret_974
    jmp .L990
.L989:
.L990:
    mov rcx, [rbp-16]
    sub rsp, 32
.kl327:
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
.kl328:
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
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    mov rax, [rbp-56]
    and rax, rcx
    mov r14, rax
.L991:
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, rbx
    add rax, rcx
    mov rax, [rax]
    cmp rax, 0
    jle .L992
    mov rax, r14
    add rax, 1
    push rax
    mov rax, r12
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov r14, rax
.L993:
    jmp .L991
.L992:
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, rbx
    add rax, rcx
    push rax
    mov rax, r13
    add rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rbp-24]
    jmp .__ret_974
.__ret_974:
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
    dq .kl320,153
    dq .kl321,157
    dq .kl322,162
    dq .kl323,163
    dq .kl324,178
    dq .kl325,187
    dq .kl326,197
    dq .kl327,201
    dq .kl328,202
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
    jmp .__ret_994
.__ret_994:
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
.kl329:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L996
    mov rax, 2
    neg rax
    jmp .__ret_995
    jmp .L997
.L996:
.L997:
    mov rcx, r12
    sub rsp, 32
.kl330:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L998
    mov rax, 2
    neg rax
    jmp .__ret_995
    jmp .L999
.L998:
.L999:
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
.kl331:
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
    jmp .__ret_995
.__ret_995:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_set.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl329,229
    dq .kl330,233
    dq .kl331,236
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
.kl332:
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
    jmp .__ret_1000
.__ret_1000:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_lookup.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl332,240
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
.kl333:
    call mp_lookup
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jge .L1002
    mov rax, 0
    jmp .__ret_1001
    jmp .L1003
.L1002:
.L1003:
    mov rax, r12
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl334:
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
.kl335:
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
.L1004:
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov rax, [rax]
    push rax
    mov rax, r14
    add rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1005
    mov rax, rbx
    add rax, 1
    and rax, r12
    mov rbx, rax
.L1006:
    jmp .L1004
.L1005:
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 1
    jmp .__ret_1001
.__ret_1001:
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
    dq .kl333,247
    dq .kl334,251
    dq .kl335,255
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
    jge .L1008
    mov rax, 1
    mov [rbp-40], rax
    jmp .L1009
.L1008:
.L1009:
    lea rax, [rbp-72]
    mov r12, rax
    cmp r14, 0
    jne .L1010
    mov rax, r12
    push rax
    mov rax, 48
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov r13, rax
    jmp .L1011
.L1010:
.L1011:
.L1012:
    cmp r14, 0
    je .L1013
    mov rax, r14
    mov rcx, 10
    cqo
    idiv rcx
    mov rax, rdx
    mov rbx, rax
    cmp rbx, 0
    jge .L1015
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L1016
.L1015:
.L1016:
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
.L1014:
    jmp .L1012
.L1013:
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-40]
    test rax, rax
    jz .L1017
    mov rax, r15
    push rax
    mov rax, 45
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 1
    mov rbx, rax
    jmp .L1018
.L1017:
.L1018:
    mov rax, 0
    mov r14, rax
.L1019:
    cmp r14, r13
    jge .L1020
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
.L1021:
    jmp .L1019
.L1020:
    mov rax, r15
    add rax, rbx
    add rax, r13
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    lea rax, [rel __g_mp_key]
    jmp .__ret_1007
.__ret_1007:
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
.kl336:
    call mp_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1022
.__ret_1022:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_remove.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl336,313
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
.kl337:
    call mp_set
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1023
.__ret_1023:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_new.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl337,318
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
.kl338:
    call mp_lookup
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jl .L1025
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl339:
    call mp_value
    add rsp, 32
    mov rbx, rax
    jmp .L1026
.L1025:
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1027
    mov rax, 6
    mov [rel __g_hp_err], rax
    jmp .L1028
.L1027:
.L1028:
.L1026:
    mov rcx, rbx
    sub rsp, 32
.kl340:
    call text_end
    add rsp, 32
    jmp .__ret_1024
.__ret_1024:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_set.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl338,323
    dq .kl339,326
    dq .kl340,330
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
.kl341:
    call mp_lookup
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    mov rbx, rax
    cmp r12, 0
    jl .L1030
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl342:
    call mp_value
    add rsp, 32
    mov rbx, rax
    jmp .L1031
.L1030:
.L1031:
    mov rcx, rbx
    sub rsp, 32
.kl343:
    call text_end
    add rsp, 32
    jmp .__ret_1029
.__ret_1029:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_get.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl341,335
    dq .kl342,338
    dq .kl343,340
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
.kl344:
    call mp_lookup
    add rsp, 32
    cmp rax, 0
    jl .L1033
    mov rax, 1
    mov rbx, rax
    jmp .L1034
.L1033:
.L1034:
    mov rcx, rbx
    sub rsp, 32
.kl345:
    call text_end
    add rsp, 32
    jmp .__ret_1032
.__ret_1032:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_get_or.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl344,346
    dq .kl345,349
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
.kl346:
    call mp_remove
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1035
.__ret_1035:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_has.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl346,354
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
.kl347:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L1037
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    jmp .L1038
.L1037:
.L1038:
    mov rcx, rbx
    sub rsp, 32
.kl348:
    call text_end
    add rsp, 32
    jmp .__ret_1036
.__ret_1036:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_remove.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl347,359
    dq .kl348,364
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
.kl349:
    call ob_get
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jne .L1040
    mov rax, 0
    jmp .__ret_1039
    jmp .L1041
.L1040:
.L1041:
    mov rcx, 8
    sub rsp, 32
.kl350:
    call li_new
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L1042
    mov rax, 0
    jmp .__ret_1039
    jmp .L1043
.L1042:
.L1043:
    mov rax, 0
    mov [rbp-40], rax
    mov rax, r15
    add rax, 8
    mov rax, [rax]
    mov [rbp-40], rax
    mov rax, 0
    mov r13, rax
.L1044:
    mov rax, r13
    mov rcx, [rbp-40]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1047
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1047
    mov rax, 1
    jmp .L1048
.L1047:
    mov rax, 0
.L1048:
    test rax, rax
    jz .L1045
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
    je .L1049
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L1051
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
.kl351:
    call tx_from_bytes
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    jmp .L1052
.L1051:
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
.kl352:
    call li_add
    add rsp, 32
.L1052:
    jmp .L1050
.L1049:
.L1050:
    add r13, 1
    mov rax, [rbp-8]
    push rax
    mov rax, [rel __g_OB_MAP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl353:
    call ob_get
    add rsp, 32
    mov r15, rax
.L1046:
    jmp .L1044
.L1045:
    mov rax, r14
    jmp .__ret_1039
.__ret_1039:
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
    dq .kl349,369
    dq .kl350,373
    dq .kl351,392
    dq .kl352,394
    dq .kl353,398
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
.kl354:
    call mp_list
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1053
.__ret_1053:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_list.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl354,405
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
.kl355:
    call mp_list
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1054
.__ret_1054:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_keys.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl355,410
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
.L1056:
    cmp rbx, r12
    jge .L1057
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
.kl356:
    call hp_release
    add rsp, 32
    add rbx, 1
.L1058:
    jmp .L1056
.L1057:
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
.kl357:
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
    jmp .__ret_1055
.__ret_1055:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_values.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl356,418
    dq .kl357,421
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
.kl358:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1060
    mov rcx, rbx
    sub rsp, 32
.kl359:
    call mp_clear
    add rsp, 32
    jmp .L1061
.L1060:
.L1061:
    mov rcx, r12
    sub rsp, 32
.kl360:
    call text_end
    add rsp, 32
    jmp .__ret_1059
.__ret_1059:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq mp_clear.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl358,430
    dq .kl359,432
    dq .kl360,434
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
.kl361:
    call ob_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1063
    mov rcx, rbx
    sub rsp, 32
.kl362:
    call mp_clear
    add rsp, 32
    mov rax, rbx
    add rax, 32
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl363:
    call hp_release
    add rsp, 32
    mov rax, rbx
    add rax, 40
    mov rax, [rax]
    push rax
    pop rcx
    sub rsp, 32
.kl364:
    call hp_release
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl365:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl366:
    call hp_release
    add rsp, 32
    jmp .L1064
.L1063:
.L1064:
    mov rcx, 0
    sub rsp, 32
.kl367:
    call text_end
    add rsp, 32
    jmp .__ret_1062
.__ret_1062:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_clear.kft, .kfe, .kfn, __kron_file_3,7
    dq .kl361,439
    dq .kl362,441
    dq .kl363,443
    dq .kl364,444
    dq .kl365,446
    dq .kl366,447
    dq .kl367,449
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
.kl368:
    call mp_set
    add rsp, 32
    sub rsp, 32
.kl369:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L1066
    mov rcx, rbx
    sub rsp, 32
.kl370:
    call heap_fail
    add rsp, 32
section .data
.flt1068: dq 0.0
section .text
    movsd xmm0, [rel .flt1068]
    jmp .__ret_1065
    jmp .L1067
.L1066:
.L1067:
    movaps xmm0, xmm6
    jmp .__ret_1065
.__ret_1065:
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
    dq .kl368,459
    dq .kl369,460
    dq .kl370,463
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
.kl371:
    call mp_lookup
    add rsp, 32
    mov rbx, rax
section .data
.flt1070: dq 0.0
section .text
    movsd xmm0, [rel .flt1070]
    movaps xmm6, xmm0
    cmp rbx, 0
    jl .L1071
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl372:
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
    jmp .L1072
.L1071:
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1073
    mov rax, 6
    mov [rel __g_hp_err], rax
    jmp .L1074
.L1073:
.L1074:
.L1072:
    sub rsp, 32
.kl373:
    call hp_take_err
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    je .L1075
    mov rcx, rbx
    sub rsp, 32
.kl374:
    call heap_fail
    add rsp, 32
section .data
.flt1077: dq 0.0
section .text
    movsd xmm0, [rel .flt1077]
    jmp .__ret_1069
    jmp .L1076
.L1075:
.L1076:
    movaps xmm0, xmm6
    jmp .__ret_1069
.__ret_1069:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_set_real.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl371,471
    dq .kl372,474
    dq .kl373,482
    dq .kl374,485
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
.kl375:
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
    jmp .__ret_1078
.__ret_1078:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_get_real.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl375,493
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
.kl376:
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
    jl .L1080
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl377:
    call mp_value
    add rsp, 32
    mov rbx, rax
    jmp .L1081
.L1080:
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1082
    mov rax, 6
    mov [rel __g_hp_err], rax
    jmp .L1083
.L1082:
.L1083:
.L1081:
    mov rcx, rbx
    sub rsp, 32
.kl378:
    call text_end
    add rsp, 32
    jmp .__ret_1079
.__ret_1079:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_iset.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl376,498
    dq .kl377,501
    dq .kl378,505
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
.kl379:
    call mp_ikey
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mp_lookup
    add rsp, 32
    cmp rax, 0
    jl .L1085
    mov rax, 1
    mov rbx, rax
    jmp .L1086
.L1085:
.L1086:
    mov rcx, rbx
    sub rsp, 32
.kl380:
    call text_end
    add rsp, 32
    jmp .__ret_1084
.__ret_1084:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_iget.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl379,511
    dq .kl380,514
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
.kl381:
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
    jmp .__ret_1087
.__ret_1087:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_ihas.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl381,519
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
.kl382:
    call mp_list
    add rsp, 32
    mov r14, rax
    mov rcx, 64
    sub rsp, 32
.kl383:
    call tx_new
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
section .data
.str1089: db 123,0
section .text
    lea rax, [rel .str1089]
    push rax
    pop rdx
    pop rcx
    mov r8, 1
    sub rsp, 32
.kl384:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl385:
    call li_len
    add rsp, 32
    mov [rbp-40], rax
    mov rax, 0
    mov r12, rax
.L1090:
    mov rax, r12
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L1091
    cmp r12, 0
    jle .L1093
    mov rax, r13
    push rax
section .data
.str1095: db 44,32,0
section .text
    lea rax, [rel .str1095]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl386:
    call tx_add_bytes
    add rsp, 32
    jmp .L1094
.L1093:
.L1094:
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
.kl387:
    call li_get
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, rbx
    mov r8, 1
    sub rsp, 32
.kl388:
    call tx_show_value
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str1096: db 58,32,0
section .text
    lea rax, [rel .str1096]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl389:
    call tx_add_bytes
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, r15
    push rax
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl390:
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
.L1092:
    jmp .L1090
.L1091:
    mov rax, r13
    push rax
section .data
.str1097: db 125,10,0
section .text
    lea rax, [rel .str1097]
    push rax
    pop rdx
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl391:
    call tx_add_bytes
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl392:
    call tx_out
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1098:
    mov rax, r12
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L1099
    mov rcx, r14
    mov rdx, r12
    sub rsp, 32
.kl393:
    call li_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call tx_drop
    add rsp, 32
    add r12, 1
.L1100:
    jmp .L1098
.L1099:
    mov rcx, r14
    sub rsp, 32
.kl394:
    call li_free
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl395:
    call tx_drop
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
.kl396:
    call text_end
    add rsp, 32
    jmp .__ret_1088
.__ret_1088:
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
    dq .kl382,526
    dq .kl383,527
    dq .kl384,528
    dq .kl385,529
    dq .kl386,533
    dq .kl387,535
    dq .kl388,536
    dq .kl389,537
    dq .kl390,538
    dq .kl391,541
    dq .kl392,542
    dq .kl393,545
    dq .kl394,548
    dq .kl395,549
    dq .kl396,550
.kfn: db "map_show", 0
section .text
section .data
__g_JSON_NULL: dq 1
section .text
section .data
__g_JSON_BOOL: dq 2
section .text
section .data
__g_JSON_NUMBER: dq 3
section .text
section .data
__g_JSON_STRING: dq 4
section .text
section .data
__g_JSON_ARRAY: dq 5
section .text
section .data
__g_JSON_OBJECT: dq 6
section .text
section .data
__g_js_kind: dq 0
section .text
section .data
__g_js_num: dq 0
section .text
section .data
__g_js_str: dq 0
section .text
section .data
__g_js_items: dq 0
section .text
section .data
__g_js_keys: dq 0
section .text
section .data
__g_js_src: dq 0
section .text
section .data
__g_js_p: dq 0
section .text
section .data
__g_js_n: dq 0
section .text
section .data
__g_js_bad: dq 0
section .text
js_new:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_js_kind]
    cmp rax, 0
    jne .L1102
    sub rsp, 32
.kl397:
    call list_new
    add rsp, 32
    mov [rel __g_js_kind], rax
    sub rsp, 32
.kl398:
    call list_new
    add rsp, 32
    mov [rel __g_js_num], rax
    sub rsp, 32
.kl399:
    call list_new
    add rsp, 32
    mov [rel __g_js_str], rax
    sub rsp, 32
.kl400:
    call list_new
    add rsp, 32
    mov [rel __g_js_items], rax
    sub rsp, 32
.kl401:
    call list_new
    add rsp, 32
    mov [rel __g_js_keys], rax
    jmp .L1103
.L1102:
.L1103:
    mov rax, [rel __g_js_kind]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl402:
    call list_add
    add rsp, 32
    mov rax, [rel __g_js_num]
    push rax
section .data
.flt1104: dq 0.0
section .text
    movsd xmm0, [rel .flt1104]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl403:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_js_str]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
.kl404:
    call list_add
    add rsp, 32
    mov rax, [rel __g_js_items]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
.kl405:
    call list_add
    add rsp, 32
    mov rax, [rel __g_js_keys]
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
.kl406:
    call list_add
    add rsp, 32
    mov rax, [rel __g_js_kind]
    push rax
    pop rcx
    sub rsp, 32
.kl407:
    call list_len
    add rsp, 32
    jmp .__ret_1101
.__ret_1101:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq map_show.kft, .kfe, .kfn, __kron_file_4,11
    dq .kl397,51
    dq .kl398,52
    dq .kl399,53
    dq .kl400,54
    dq .kl401,55
    dq .kl402,57
    dq .kl403,58
    dq .kl404,59
    dq .kl405,60
    dq .kl406,61
    dq .kl407,62
.kfn: db "js_new", 0
section .text
js_c:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_js_p]
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1106
    mov rax, 0
    jmp .__ret_1105
    jmp .L1107
.L1106:
.L1107:
    mov rax, [rel __g_js_src]
    push rax
    mov rax, [rel __g_js_p]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl408:
    call text_at
    add rsp, 32
    jmp .__ret_1105
.__ret_1105:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq js_new.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl408,67
.kfn: db "js_c", 0
section .text
js_ws:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
.L1109:
    mov rax, [rel __g_js_p]
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1110
    mov rax, [rel __g_js_src]
    push rax
    mov rax, [rel __g_js_p]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl409:
    call text_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1118
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1118
    mov rax, 1
    jmp .L1119
.L1118:
    mov rax, 0
.L1119:
    test rax, rax
    jz .L1116
    mov rax, rbx
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1116
    mov rax, 1
    jmp .L1117
.L1116:
    mov rax, 0
.L1117:
    test rax, rax
    jz .L1114
    mov rax, rbx
    mov rcx, 13
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1114
    mov rax, 1
    jmp .L1115
.L1114:
    mov rax, 0
.L1115:
    test rax, rax
    jz .L1112
    mov rax, 0
    jmp .__ret_1108
    jmp .L1113
.L1112:
.L1113:
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
.L1111:
    jmp .L1109
.L1110:
    mov rax, 0
    jmp .__ret_1108
.__ret_1108:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq js_c.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl409,72
.kfn: db "js_ws", 0
section .text
js_word:
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
    mov rcx, r13
    sub rsp, 32
.kl410:
    call text_len
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_js_p]
    add rax, rbx
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1123
    mov rax, [rel __g_js_src]
    push rax
    mov rax, [rel __g_js_p]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl411:
    call text_part
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call text_same
    add rsp, 32
    test rax, rax
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1123
    mov rax, 0
    jmp .L1124
.L1123:
    mov rax, 1
.L1124:
    test rax, rax
    jz .L1121
    mov rax, 1
    mov [rel __g_js_bad], rax
    mov rax, 0
    jmp .__ret_1120
    jmp .L1122
.L1121:
.L1122:
    mov rax, [rel __g_js_p]
    add rax, rbx
    mov [rel __g_js_p], rax
    mov rcx, r12
    sub rsp, 32
.kl412:
    call js_new
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_js_num]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl413:
    call list_set_real
    add rsp, 32
    mov rax, rbx
    jmp .__ret_1120
.__ret_1120:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    movups xmm6, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq js_ws.kft, .kfe, .kfn, __kron_file_4,4
    dq .kl410,80
    dq .kl411,81
    dq .kl412,86
    dq .kl413,87
.kfn: db "js_word", 0
section .text
js_hex:
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
    jz .L1128
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L1128
    mov rax, 1
    jmp .L1129
.L1128:
    mov rax, 0
.L1129:
    test rax, rax
    jz .L1126
    mov rax, rbx
    sub rax, 48
    jmp .__ret_1125
    jmp .L1127
.L1126:
.L1127:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1132
    mov rax, rbx
    mov rcx, 102
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L1132
    mov rax, 1
    jmp .L1133
.L1132:
    mov rax, 0
.L1133:
    test rax, rax
    jz .L1130
    mov rax, rbx
    sub rax, 87
    jmp .__ret_1125
    jmp .L1131
.L1130:
.L1131:
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1136
    mov rax, rbx
    mov rcx, 70
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L1136
    mov rax, 1
    jmp .L1137
.L1136:
    mov rax, 0
.L1137:
    test rax, rax
    jz .L1134
    mov rax, rbx
    sub rax, 55
    jmp .__ret_1125
    jmp .L1135
.L1134:
.L1135:
    mov rax, 1
    mov [rel __g_js_bad], rax
    mov rax, 0
    jmp .__ret_1125
.__ret_1125:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
js_string:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    sub rsp, 32
.kl414:
    call text_new
    add rsp, 32
    mov r13, rax
.L1139:
    mov rax, [rel __g_js_p]
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1140
    mov rax, [rel __g_js_src]
    push rax
    mov rax, [rel __g_js_p]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl415:
    call text_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 34
    jne .L1142
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, r13
    jmp .__ret_1138
    jmp .L1143
.L1142:
.L1143:
    cmp rbx, 92
    jne .L1144
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    sub rsp, 32
.kl416:
    call js_c
    add rsp, 32
    mov rbx, rax
    cmp rbx, 110
    jne .L1146
    mov rcx, r13
    mov rdx, 10
    sub rsp, 32
.kl417:
    call text_add_char
    add rsp, 32
    jmp .L1147
.L1146:
    cmp rbx, 116
    jne .L1148
    mov rcx, r13
    mov rdx, 9
    sub rsp, 32
.kl418:
    call text_add_char
    add rsp, 32
    jmp .L1149
.L1148:
    cmp rbx, 114
    jne .L1150
    mov rcx, r13
    mov rdx, 13
    sub rsp, 32
.kl419:
    call text_add_char
    add rsp, 32
    jmp .L1151
.L1150:
    cmp rbx, 98
    jne .L1152
    mov rcx, r13
    mov rdx, 8
    sub rsp, 32
.kl420:
    call text_add_char
    add rsp, 32
    jmp .L1153
.L1152:
    cmp rbx, 102
    jne .L1154
    mov rcx, r13
    mov rdx, 12
    sub rsp, 32
.kl421:
    call text_add_char
    add rsp, 32
    jmp .L1155
.L1154:
    cmp rbx, 117
    jne .L1156
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L1158:
    cmp rbx, 4
    jg .L1159
    mov rax, [rel __g_js_p]
    add rax, rbx
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1161
    mov rax, r12
    mov rcx, 16
    imul rax, rcx
    push rax
    mov rax, [rel __g_js_src]
    push rax
    mov rax, [rel __g_js_p]
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl422:
    call text_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call js_hex
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    jmp .L1162
.L1161:
.L1162:
    add rbx, 1
.L1160:
    jmp .L1158
.L1159:
    mov rax, [rel __g_js_p]
    add rax, 4
    mov [rel __g_js_p], rax
    cmp r12, 128
    jge .L1163
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl423:
    call text_add_char
    add rsp, 32
    jmp .L1164
.L1163:
    cmp r12, 2048
    jge .L1165
    mov rax, r13
    push rax
    mov rax, r12
    sar rax, 6
    mov rcx, rax
    mov rax, 192
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl424:
    call text_add_char
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl425:
    call text_add_char
    add rsp, 32
    jmp .L1166
.L1165:
    mov rax, r13
    push rax
    mov rax, r12
    sar rax, 12
    mov rcx, rax
    mov rax, 224
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl426:
    call text_add_char
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, r12
    sar rax, 6
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl427:
    call text_add_char
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, r12
    and rax, 63
    mov rcx, rax
    mov rax, 128
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl428:
    call text_add_char
    add rsp, 32
.L1166:
.L1164:
    jmp .L1157
.L1156:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl429:
    call text_add_char
    add rsp, 32
.L1157:
.L1155:
.L1153:
.L1151:
.L1149:
.L1147:
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    jmp .L1145
.L1144:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl430:
    call text_add_char
    add rsp, 32
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
.L1145:
.L1141:
    jmp .L1139
.L1140:
    mov rax, 1
    mov [rel __g_js_bad], rax
    mov rax, r13
    jmp .__ret_1138
.__ret_1138:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq js_word.kft, .kfe, .kfn, __kron_file_4,17
    dq .kl414,102
    dq .kl415,104
    dq .kl416,111
    dq .kl417,112
    dq .kl418,113
    dq .kl419,114
    dq .kl420,115
    dq .kl421,116
    dq .kl422,121
    dq .kl423,127
    dq .kl424,129
    dq .kl425,130
    dq .kl426,132
    dq .kl427,133
    dq .kl428,134
    dq .kl429,137
    dq .kl430,141
.kfn: db "js_string", 0
section .text
js_value:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    sub rsp, 32
.kl431:
    call js_ws
    add rsp, 32
    mov rax, [rel __g_js_bad]
    cmp rax, 1
    jne .L1168
    mov rax, 0
    jmp .__ret_1167
    jmp .L1169
.L1168:
.L1169:
    sub rsp, 32
.kl432:
    call js_c
    add rsp, 32
    mov rbx, rax
    cmp rbx, 123
    jne .L1170
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, [rel __g_JSON_OBJECT]
    push rax
    pop rcx
    sub rsp, 32
.kl433:
    call js_new
    add rsp, 32
    mov r15, rax
    sub rsp, 32
.kl434:
    call list_new
    add rsp, 32
    mov r14, rax
    sub rsp, 32
.kl435:
    call list_new
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_js_items]
    push rax
    mov rax, r15
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl436:
    call list_set
    add rsp, 32
    mov rax, [rel __g_js_keys]
    push rax
    mov rax, r15
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r13
    sub rsp, 32
.kl437:
    call list_set
    add rsp, 32
    sub rsp, 32
.kl438:
    call js_ws
    add rsp, 32
    sub rsp, 32
.kl439:
    call js_c
    add rsp, 32
    cmp rax, 125
    jne .L1172
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, r15
    jmp .__ret_1167
    jmp .L1173
.L1172:
.L1173:
.L1174:
    mov rax, [rel __g_js_bad]
    cmp rax, 0
    jne .L1175
    sub rsp, 32
.kl440:
    call js_ws
    add rsp, 32
    sub rsp, 32
.kl441:
    call js_c
    add rsp, 32
    cmp rax, 34
    je .L1177
    mov rax, 1
    mov [rel __g_js_bad], rax
    mov rax, 0
    jmp .__ret_1167
    jmp .L1178
.L1177:
.L1178:
    sub rsp, 32
.kl442:
    call js_string
    add rsp, 32
    mov r12, rax
    sub rsp, 32
.kl443:
    call js_ws
    add rsp, 32
    sub rsp, 32
.kl444:
    call js_c
    add rsp, 32
    cmp rax, 58
    je .L1179
    mov rax, 1
    mov [rel __g_js_bad], rax
    mov rax, 0
    jmp .__ret_1167
    jmp .L1180
.L1179:
.L1180:
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    sub rsp, 32
.kl445:
    call js_value
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl446:
    call list_add
    add rsp, 32
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
.kl447:
    call list_add
    add rsp, 32
    sub rsp, 32
.kl448:
    call js_ws
    add rsp, 32
    sub rsp, 32
.kl449:
    call js_c
    add rsp, 32
    cmp rax, 44
    jne .L1181
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    jmp .L1182
.L1181:
    sub rsp, 32
.kl450:
    call js_c
    add rsp, 32
    cmp rax, 125
    jne .L1183
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, r15
    jmp .__ret_1167
    jmp .L1184
.L1183:
    mov rax, 1
    mov [rel __g_js_bad], rax
.L1184:
.L1182:
.L1176:
    jmp .L1174
.L1175:
    mov rax, 0
    jmp .__ret_1167
    jmp .L1171
.L1170:
.L1171:
    cmp rbx, 91
    jne .L1185
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, [rel __g_JSON_ARRAY]
    push rax
    pop rcx
    sub rsp, 32
.kl451:
    call js_new
    add rsp, 32
    mov r12, rax
    sub rsp, 32
.kl452:
    call list_new
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_js_items]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl453:
    call list_set
    add rsp, 32
    sub rsp, 32
.kl454:
    call js_ws
    add rsp, 32
    sub rsp, 32
.kl455:
    call js_c
    add rsp, 32
    cmp rax, 93
    jne .L1187
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, r12
    jmp .__ret_1167
    jmp .L1188
.L1187:
.L1188:
.L1189:
    mov rax, [rel __g_js_bad]
    cmp rax, 0
    jne .L1190
    mov rax, rbx
    push rax
    sub rsp, 32
.kl456:
    call js_value
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    sub rsp, 32
.kl457:
    call js_ws
    add rsp, 32
    sub rsp, 32
.kl458:
    call js_c
    add rsp, 32
    cmp rax, 44
    jne .L1192
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    jmp .L1193
.L1192:
    sub rsp, 32
.kl459:
    call js_c
    add rsp, 32
    cmp rax, 93
    jne .L1194
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    mov rax, r12
    jmp .__ret_1167
    jmp .L1195
.L1194:
    mov rax, 1
    mov [rel __g_js_bad], rax
.L1195:
.L1193:
.L1191:
    jmp .L1189
.L1190:
    mov rax, 0
    jmp .__ret_1167
    jmp .L1186
.L1185:
.L1186:
    cmp rbx, 34
    jne .L1196
    mov rax, [rel __g_JSON_STRING]
    push rax
    pop rcx
    sub rsp, 32
.kl460:
    call js_new
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_js_str]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    sub rsp, 32
.kl461:
    call js_string
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call list_set
    add rsp, 32
    mov rax, rbx
    jmp .__ret_1167
    jmp .L1197
.L1196:
.L1197:
    cmp rbx, 116
    jne .L1198
section .data
.str1200: db 116,114,117,101,0
section .text
    lea rax, [rel .str1200]
    push rax
    mov rax, [rel __g_JSON_BOOL]
    push rax
section .data
.flt1201: dq 1.0
section .text
    movsd xmm0, [rel .flt1201]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl462:
    call js_word
    add rsp, 32
    jmp .__ret_1167
    jmp .L1199
.L1198:
.L1199:
    cmp rbx, 102
    jne .L1202
section .data
.str1204: db 102,97,108,115,101,0
section .text
    lea rax, [rel .str1204]
    push rax
    mov rax, [rel __g_JSON_BOOL]
    push rax
section .data
.flt1205: dq 0.0
section .text
    movsd xmm0, [rel .flt1205]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl463:
    call js_word
    add rsp, 32
    jmp .__ret_1167
    jmp .L1203
.L1202:
.L1203:
    cmp rbx, 110
    jne .L1206
section .data
.str1208: db 110,117,108,108,0
section .text
    lea rax, [rel .str1208]
    push rax
    mov rax, [rel __g_JSON_NULL]
    push rax
section .data
.flt1209: dq 0.0
section .text
    movsd xmm0, [rel .flt1209]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl464:
    call js_word
    add rsp, 32
    jmp .__ret_1167
    jmp .L1207
.L1206:
.L1207:
    mov rax, [rel __g_js_p]
    mov r12, rax
.L1210:
    mov rax, [rel __g_js_p]
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L1211
    mov rax, [rel __g_js_src]
    push rax
    mov rax, [rel __g_js_p]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl465:
    call text_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1225
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L1225
    mov rax, 1
    jmp .L1226
.L1225:
    mov rax, 0
.L1226:
    test rax, rax
    jnz .L1223
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1223
    mov rax, 0
    jmp .L1224
.L1223:
    mov rax, 1
.L1224:
    test rax, rax
    jnz .L1221
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1221
    mov rax, 0
    jmp .L1222
.L1221:
    mov rax, 1
.L1222:
    test rax, rax
    jnz .L1219
    mov rax, rbx
    mov rcx, 46
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1219
    mov rax, 0
    jmp .L1220
.L1219:
    mov rax, 1
.L1220:
    test rax, rax
    jnz .L1217
    mov rax, rbx
    mov rcx, 101
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1217
    mov rax, 0
    jmp .L1218
.L1217:
    mov rax, 1
.L1218:
    test rax, rax
    jnz .L1215
    mov rax, rbx
    mov rcx, 69
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1215
    mov rax, 0
    jmp .L1216
.L1215:
    mov rax, 1
.L1216:
    test rax, rax
    jz .L1213
    mov rax, [rel __g_js_p]
    add rax, 1
    mov [rel __g_js_p], rax
    jmp .L1214
.L1213:
    mov rcx, r12
    sub rsp, 32
.kl466:
    call js_number
    add rsp, 32
    jmp .__ret_1167
.L1214:
.L1212:
    jmp .L1210
.L1211:
    mov rcx, r12
    sub rsp, 32
.kl467:
    call js_number
    add rsp, 32
    jmp .__ret_1167
.__ret_1167:
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
.kft: dq js_string.kft, .kfe, .kfn, __kron_file_4,37
    dq .kl431,150
    dq .kl432,152
    dq .kl433,155
    dq .kl434,156
    dq .kl435,157
    dq .kl436,158
    dq .kl437,159
    dq .kl438,160
    dq .kl439,161
    dq .kl440,166
    dq .kl441,167
    dq .kl442,171
    dq .kl443,172
    dq .kl444,173
    dq .kl445,178
    dq .kl446,179
    dq .kl447,180
    dq .kl448,181
    dq .kl449,182
    dq .kl450,190
    dq .kl451,195
    dq .kl452,196
    dq .kl453,197
    dq .kl454,198
    dq .kl455,199
    dq .kl456,204
    dq .kl457,205
    dq .kl458,206
    dq .kl459,214
    dq .kl460,218
    dq .kl461,219
    dq .kl462,222
    dq .kl463,223
    dq .kl464,224
    dq .kl465,228
    dq .kl466,232
    dq .kl467,235
.kfn: db "js_value", 0
section .text
js_number:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_js_p]
    cmp rax, r12
    jne .L1228
    mov rax, 1
    mov [rel __g_js_bad], rax
    mov rax, 0
    jmp .__ret_1227
    jmp .L1229
.L1228:
.L1229:
    mov rax, [rel __g_JSON_NUMBER]
    push rax
    pop rcx
    sub rsp, 32
.kl468:
    call js_new
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_js_num]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    mov rax, [rel __g_js_src]
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_js_p]
    sub rax, r12
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl469:
    call text_part
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_to_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
    call list_set_real
    add rsp, 32
    mov rax, rbx
    jmp .__ret_1227
.__ret_1227:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq js_value.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl468,243
    dq .kl469,244
.kfn: db "js_number", 0
section .text
json_parse:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov [rel __g_js_src], rax
    mov rax, 0
    mov [rel __g_js_p], rax
    mov rcx, rbx
    sub rsp, 32
.kl470:
    call text_len
    add rsp, 32
    mov [rel __g_js_n], rax
    mov rax, 0
    mov [rel __g_js_bad], rax
    sub rsp, 32
.kl471:
    call js_value
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
.kl472:
    call js_ws
    add rsp, 32
    mov rax, [rel __g_js_bad]
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1233
    mov rax, [rel __g_js_p]
    push rax
    mov rax, [rel __g_js_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1233
    mov rax, 0
    jmp .L1234
.L1233:
    mov rax, 1
.L1234:
    test rax, rax
    jz .L1231
section .data
.str1235: db 116,104,105,115,32,105,115,32,110,111,116,32,74,83,79,78,0
section .text
    lea rax, [rel .str1235]
    push rax
section .data
.str1236: db 99,104,101,99,107,32,116,104,101,32,116,101,120,116,32,110,101,97,114,32,119,104,101,114,101,32,105,116,32,115,116,111,112,115,32,98,101,105,110,103,32,74,83,79,78,0
section .text
    lea rax, [rel .str1236]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl473:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1230
    jmp .L1232
.L1231:
.L1232:
    mov rax, rbx
    jmp .__ret_1230
.__ret_1230:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq js_number.kft, .kfe, .kfn, __kron_file_4,4
    dq .kl470,251
    dq .kl471,253
    dq .kl472,254
    dq .kl473,256
.kfn: db "json_parse", 0
section .text
json_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L1242
    mov rax, [rel __g_js_kind]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1242
    mov rax, 0
    jmp .L1243
.L1242:
    mov rax, 1
.L1243:
    test rax, rax
    jnz .L1240
    mov rax, rbx
    push rax
    mov rax, [rel __g_js_kind]
    push rax
    pop rcx
    sub rsp, 32
.kl474:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1240
    mov rax, 0
    jmp .L1241
.L1240:
    mov rax, 1
.L1241:
    test rax, rax
    jz .L1238
    mov rax, 0
    jmp .__ret_1237
    jmp .L1239
.L1238:
.L1239:
    mov rax, [rel __g_js_kind]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl475:
    call list_get
    add rsp, 32
    jmp .__ret_1237
.__ret_1237:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_parse.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl474,262
    dq .kl475,263
.kfn: db "json_kind", 0
section .text
json_len:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rcx, r12
    sub rsp, 32
.kl476:
    call json_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_JSON_ARRAY]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1247
    mov rax, rbx
    push rax
    mov rax, [rel __g_JSON_OBJECT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1247
    mov rax, 1
    jmp .L1248
.L1247:
    mov rax, 0
.L1248:
    test rax, rax
    jz .L1245
    mov rax, 0
    jmp .__ret_1244
    jmp .L1246
.L1245:
.L1246:
    mov rax, [rel __g_js_items]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl477:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_len
    add rsp, 32
    jmp .__ret_1244
.__ret_1244:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_kind.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl476,267
    dq .kl477,269
.kfn: db "json_len", 0
section .text
json_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1252
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
.kl478:
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L1252
    mov rax, 0
    jmp .L1253
.L1252:
    mov rax, 1
.L1253:
    test rax, rax
    jz .L1250
    mov rax, 0
    jmp .__ret_1249
    jmp .L1251
.L1250:
.L1251:
    mov rax, [rel __g_js_items]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl479:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call list_get
    add rsp, 32
    jmp .__ret_1249
.__ret_1249:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_len.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl478,273
    dq .kl479,274
.kfn: db "json_at", 0
section .text
json_key:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
.kl480:
    call json_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_JSON_OBJECT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L1259
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1259
    mov rax, 0
    jmp .L1260
.L1259:
    mov rax, 1
.L1260:
    test rax, rax
    jnz .L1257
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L1257
    mov rax, 0
    jmp .L1258
.L1257:
    mov rax, 1
.L1258:
    test rax, rax
    jz .L1255
    sub rsp, 32
    call text_new
    add rsp, 32
    jmp .__ret_1254
    jmp .L1256
.L1255:
.L1256:
    mov rax, [rel __g_js_keys]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl481:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call list_get
    add rsp, 32
    jmp .__ret_1254
.__ret_1254:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_at.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl480,278
    dq .kl481,279
.kfn: db "json_key", 0
section .text
json_get:
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
.kl482:
    call json_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_JSON_OBJECT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1262
    mov rax, 0
    jmp .__ret_1261
    jmp .L1263
.L1262:
.L1263:
    mov rax, [rel __g_js_keys]
    push rax
    mov rax, r15
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl483:
    call list_get
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
.kl484:
    call list_len
    add rsp, 32
    mov rbx, rax
.L1264:
    cmp r12, rbx
    jge .L1265
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl485:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call text_same
    add rsp, 32
    test rax, rax
    jz .L1267
    mov rax, [rel __g_js_items]
    push rax
    mov rax, r15
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl486:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call list_get
    add rsp, 32
    jmp .__ret_1261
    jmp .L1268
.L1267:
.L1268:
    add r12, 1
.L1266:
    jmp .L1264
.L1265:
    mov rax, 0
    jmp .__ret_1261
.__ret_1261:
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
.kft: dq json_key.kft, .kfe, .kfn, __kron_file_4,5
    dq .kl482,283
    dq .kl483,284
    dq .kl484,286
    dq .kl485,288
    dq .kl486,289
.kfn: db "json_get", 0
section .text
json_has:
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
.kl487:
    call json_get
    add rsp, 32
    cmp rax, 0
    je .L1270
    mov rax, 1
    jmp .__ret_1269
    jmp .L1271
.L1270:
.L1271:
    mov rax, 0
    jmp .__ret_1269
.__ret_1269:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_get.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl487,297
.kfn: db "json_has", 0
section .text
json_num_or:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    movups [rbp-48], xmm6
    mov r12, rcx
    movaps xmm6, xmm1
    mov rcx, r12
    sub rsp, 32
.kl488:
    call json_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_JSON_NUMBER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1275
    mov rax, rbx
    push rax
    mov rax, [rel __g_JSON_BOOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1275
    mov rax, 1
    jmp .L1276
.L1275:
    mov rax, 0
.L1276:
    test rax, rax
    jz .L1273
    movaps xmm0, xmm6
    jmp .__ret_1272
    jmp .L1274
.L1273:
.L1274:
    mov rax, [rel __g_js_num]
    push rax
    mov rax, r12
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl489:
    call list_get_real
    add rsp, 32
    jmp .__ret_1272
.__ret_1272:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_has.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl488,302
    dq .kl489,304
.kfn: db "json_num_or", 0
section .text
json_num:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.flt1278: dq 0.0
section .text
    movsd xmm0, [rel .flt1278]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl490:
    call json_num_or
    add rsp, 32
    jmp .__ret_1277
.__ret_1277:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_num_or.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl490,307
.kfn: db "json_num", 0
section .text
json_int_or:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rcx, r13
    sub rsp, 32
.kl491:
    call json_kind
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_JSON_NUMBER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1282
    mov rax, rbx
    push rax
    mov rax, [rel __g_JSON_BOOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1282
    mov rax, 1
    jmp .L1283
.L1282:
    mov rax, 0
.L1283:
    test rax, rax
    jz .L1280
    mov rax, r12
    jmp .__ret_1279
    jmp .L1281
.L1280:
.L1281:
    mov rax, [rel __g_js_num]
    push rax
    mov rax, r13
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl492:
    call list_get_real
    add rsp, 32
    cvttsd2si rax, xmm0
    jmp .__ret_1279
.__ret_1279:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_num.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl491,309
    dq .kl492,311
.kfn: db "json_int_or", 0
section .text
json_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl493:
    call json_int_or
    add rsp, 32
    jmp .__ret_1284
.__ret_1284:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_int_or.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl493,313
.kfn: db "json_int", 0
section .text
json_bool:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl494:
    call json_int_or
    add rsp, 32
    jmp .__ret_1285
.__ret_1285:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_int.kft, .kfe, .kfn, __kron_file_4,1
    dq .kl494,314
.kfn: db "json_bool", 0
section .text
json_text:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl495:
    call json_kind
    add rsp, 32
    push rax
    mov rax, [rel __g_JSON_STRING]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1287
    sub rsp, 32
    call text_new
    add rsp, 32
    jmp .__ret_1286
    jmp .L1288
.L1287:
.L1288:
    mov rax, [rel __g_js_str]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl496:
    call list_get
    add rsp, 32
    jmp .__ret_1286
.__ret_1286:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_bool.kft, .kfe, .kfn, __kron_file_4,2
    dq .kl495,317
    dq .kl496,318
.kfn: db "json_text", 0
section .text
section .data
__g_FL_READ: dq 1
section .text
section .data
__g_FL_WRITE: dq 2
section .text
section .data
__g_FL_APPEND: dq 4
section .text
section .data
__g_fl_ready: dq 0
section .text
section .data
__g_fl_create: dq 0
section .text
section .data
__g_fl_readf: dq 0
section .text
section .data
__g_fl_writef: dq 0
section .text
section .data
__g_fl_closef: dq 0
section .text
section .data
__g_fl_seekf: dq 0
section .text
section .data
__g_fl_sizef: dq 0
section .text
section .data
__g_fl_deletef: dq 0
section .text
section .data
__g_fl_movef: dq 0
section .text
section .data
__g_fl_mkdirf: dq 0
section .text
section .data
__g_fl_rmdirf: dq 0
section .text
section .data
__g_fl_attrf: dq 0
section .text
section .data
__g_fl_findfirst: dq 0
section .text
section .data
__g_fl_findnext: dq 0
section .text
section .data
__g_fl_findclose: dq 0
section .text
section .bss
__g_fl_word: resq 2
section .text
section .bss
__g_fl_find: resq 48
section .text
section .data
__g_fl_ignore: dq 0
section .text
fl_linux:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 1
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    jmp .__ret_1289
.__ret_1289:
    mov rsp, rbp
    pop rbp
    ret
fl_load:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_fl_ready]
    test rax, rax
    jz .L1291
    mov rax, 1
    jmp .__ret_1290
    jmp .L1292
.L1291:
.L1292:
section .data
.str1293: db 107,101,114,110,101,108,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str1293]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str1294: db 67,114,101,97,116,101,70,105,108,101,65,0
section .text
    lea rax, [rel .str1294]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_create], rax
    mov rax, rbx
    push rax
section .data
.str1295: db 82,101,97,100,70,105,108,101,0
section .text
    lea rax, [rel .str1295]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_readf], rax
    mov rax, rbx
    push rax
section .data
.str1296: db 87,114,105,116,101,70,105,108,101,0
section .text
    lea rax, [rel .str1296]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_writef], rax
    mov rax, rbx
    push rax
section .data
.str1297: db 67,108,111,115,101,72,97,110,100,108,101,0
section .text
    lea rax, [rel .str1297]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_closef], rax
    mov rax, rbx
    push rax
section .data
.str1298: db 83,101,116,70,105,108,101,80,111,105,110,116,101,114,69,120,0
section .text
    lea rax, [rel .str1298]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_seekf], rax
    mov rax, rbx
    push rax
section .data
.str1299: db 71,101,116,70,105,108,101,83,105,122,101,69,120,0
section .text
    lea rax, [rel .str1299]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_sizef], rax
    mov rax, rbx
    push rax
section .data
.str1300: db 68,101,108,101,116,101,70,105,108,101,65,0
section .text
    lea rax, [rel .str1300]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_deletef], rax
    mov rax, rbx
    push rax
section .data
.str1301: db 77,111,118,101,70,105,108,101,69,120,65,0
section .text
    lea rax, [rel .str1301]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_movef], rax
    mov rax, rbx
    push rax
section .data
.str1302: db 67,114,101,97,116,101,68,105,114,101,99,116,111,114,121,65,0
section .text
    lea rax, [rel .str1302]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_mkdirf], rax
    mov rax, rbx
    push rax
section .data
.str1303: db 82,101,109,111,118,101,68,105,114,101,99,116,111,114,121,65,0
section .text
    lea rax, [rel .str1303]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_rmdirf], rax
    mov rax, rbx
    push rax
section .data
.str1304: db 71,101,116,70,105,108,101,65,116,116,114,105,98,117,116,101,115,65,0
section .text
    lea rax, [rel .str1304]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_attrf], rax
    mov rax, rbx
    push rax
section .data
.str1305: db 70,105,110,100,70,105,114,115,116,70,105,108,101,65,0
section .text
    lea rax, [rel .str1305]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_findfirst], rax
    mov rax, rbx
    push rax
section .data
.str1306: db 70,105,110,100,78,101,120,116,70,105,108,101,65,0
section .text
    lea rax, [rel .str1306]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_findnext], rax
    mov rax, rbx
    push rax
section .data
.str1307: db 70,105,110,100,67,108,111,115,101,0
section .text
    lea rax, [rel .str1307]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_fl_findclose], rax
    mov rax, 1
    mov [rel __g_fl_ready], rax
    mov rax, 1
    jmp .__ret_1290
.__ret_1290:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fl_low:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    jmp .__ret_1308
.__ret_1308:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
fl_os_open:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 1
    neg rax
    mov rbx, rax
    sub rsp, 32
.kl497:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1310
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_FL_WRITE]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    je .L1312
    mov rax, 66
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_FL_READ]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    jne .L1314
    mov rax, 65
    mov rbx, rax
    jmp .L1315
.L1314:
.L1315:
    mov rax, r13
    and rax, 8
    cmp rax, 0
    je .L1316
    or rbx, 512
    jmp .L1317
.L1316:
.L1317:
    jmp .L1313
.L1312:
.L1313:
    mov rax, 2
    push rax
    mov rax, r14
    push rax
    mov rax, rbx
    push rax
    mov rax, 420
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl498:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L1318
    mov rax, 1
    neg rax
    mov rbx, rax
    jmp .L1319
.L1318:
.L1319:
    jmp .L1311
.L1310:
    sub rsp, 32
.kl499:
    call fl_load
    add rsp, 32
    mov rax, 2147483648
    mov r12, rax
    mov rax, 3
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_FL_WRITE]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    je .L1320
    mov rax, 1073741824
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_FL_READ]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    je .L1322
    mov rax, 3221225472
    mov r12, rax
    jmp .L1323
.L1322:
.L1323:
    mov rax, 4
    mov rbx, rax
    mov rax, r13
    and rax, 8
    cmp rax, 0
    je .L1324
    mov rax, 2
    mov rbx, rax
    jmp .L1325
.L1324:
.L1325:
    jmp .L1321
.L1320:
.L1321:
    mov rax, [rel __g_fl_create]
    push rax
    mov rax, r14
    push rax
    mov rax, r12
    push rax
    mov rax, 7
    push rax
    mov rax, 0
    push rax
    mov rax, rbx
    push rax
    mov rax, 128
    push rax
    mov rax, 0
    push rax
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 64
    mov r10, [rax+16]
    mov [rsp+32], r10
    mov r10, [rax+8]
    mov [rsp+40], r10
    mov r10, [rax+0]
    mov [rsp+48], r10
    mov rcx, [rax+48]
    mov rdx, [rax+40]
    mov r8, [rax+32]
    mov r9, [rax+24]
    mov r11, [rax+56]
.kl500:
    call r11
    add rsp, 64
    pop rsp
    add rsp, 64
    mov rbx, rax
.L1311:
    mov rax, rbx
    jmp .__ret_1309
.__ret_1309:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq json_text.kft, .kfe, .kfn, __kron_file_5,4
    dq .kl497,107
    dq .kl498,118
    dq .kl499,123
    dq .kl500,136
.kfn: db "fl_os_open", 0
section .text
fl_os_close:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
.kl501:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1327
    mov rax, 3
    push rax
    mov rax, rbx
    push rax
    pop rdi
    pop rax
.kl502:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_fl_ignore], rax
    jmp .L1328
.L1327:
    mov rax, [rel __g_fl_closef]
    push rax
    mov rax, rbx
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl503:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_fl_ignore], rax
.L1328:
    mov rax, 0
    jmp .__ret_1326
.__ret_1326:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_os_open.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl501,144
    dq .kl502,145
    dq .kl503,147
.kfn: db "fl_os_close", 0
section .text
fl_os_read:
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
    mov r13, r9
    mov rax, 1
    neg rax
    mov r12, rax
    sub rsp, 32
.kl504:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1330
    cmp r14, 0
    jl .L1332
    mov rax, 17
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r13
    push rax
    mov rax, r14
    push rax
    pop r10
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl505:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov r12, rax
    jmp .L1333
.L1332:
    mov rax, 0
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r13
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl506:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov r12, rax
.L1333:
    cmp r12, 0
    jge .L1334
    mov rax, 1
    neg rax
    mov r12, rax
    jmp .L1335
.L1334:
.L1335:
    jmp .L1331
.L1330:
    mov rax, 1
    mov rbx, rax
    cmp r14, 0
    jl .L1336
    mov rax, [rel __g_fl_seekf]
    push rax
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    mov rax, 0
    push rax
    mov rax, 0
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
.kl507:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
    jmp .L1337
.L1336:
.L1337:
    cmp rbx, 0
    je .L1338
    lea rax, [rel __g_fl_word]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_fl_readf]
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r13
    push rax
    lea rax, [rel __g_fl_word]
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
.kl508:
    call r11
    add rsp, 48
    pop rsp
    add rsp, 48
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1340
    lea rax, [rel __g_fl_word]
    mov eax, dword [rax]
    mov r12, rax
    jmp .L1341
.L1340:
.L1341:
    jmp .L1339
.L1338:
.L1339:
.L1331:
    mov rax, r12
    jmp .__ret_1329
.__ret_1329:
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
.kft: dq fl_os_close.kft, .kfe, .kfn, __kron_file_5,5
    dq .kl504,157
    dq .kl505,159
    dq .kl506,161
    dq .kl507,169
    dq .kl508,173
.kfn: db "fl_os_read", 0
section .text
fl_os_write:
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
    mov r13, r9
    mov rax, 1
    neg rax
    mov r12, rax
    sub rsp, 32
.kl509:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1343
    cmp r14, 0
    jl .L1345
    mov rax, 18
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r13
    push rax
    mov rax, r14
    push rax
    pop r10
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl510:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov r12, rax
    jmp .L1346
.L1345:
    mov rax, 8
    push rax
    mov rax, r15
    push rax
    mov rax, 0
    push rax
    mov rax, 2
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl511:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_fl_ignore], rax
    mov rax, 1
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r13
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl512:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov r12, rax
.L1346:
    cmp r12, 0
    jge .L1347
    mov rax, 1
    neg rax
    mov r12, rax
    jmp .L1348
.L1347:
.L1348:
    jmp .L1344
.L1343:
    mov rax, 0
    mov rbx, rax
    cmp r14, 0
    jl .L1349
    mov rax, [rel __g_fl_seekf]
    push rax
    mov rax, r15
    push rax
    mov rax, r14
    push rax
    mov rax, 0
    push rax
    mov rax, 0
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
.kl513:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
    jmp .L1350
.L1349:
    mov rax, [rel __g_fl_seekf]
    push rax
    mov rax, r15
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    mov rax, 2
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
.kl514:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
.L1350:
    cmp rbx, 0
    je .L1351
    lea rax, [rel __g_fl_word]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_fl_writef]
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-24]
    push rax
    mov rax, r13
    push rax
    lea rax, [rel __g_fl_word]
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
.kl515:
    call r11
    add rsp, 48
    pop rsp
    add rsp, 48
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1353
    lea rax, [rel __g_fl_word]
    mov eax, dword [rax]
    mov r12, rax
    jmp .L1354
.L1353:
.L1354:
    jmp .L1352
.L1351:
.L1352:
.L1344:
    mov rax, r12
    jmp .__ret_1342
.__ret_1342:
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
.kft: dq fl_os_read.kft, .kfe, .kfn, __kron_file_5,7
    dq .kl509,187
    dq .kl510,189
    dq .kl511,191
    dq .kl512,192
    dq .kl513,200
    dq .kl514,202
    dq .kl515,206
.kfn: db "fl_os_write", 0
section .text
fl_os_size:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 1
    neg rax
    mov rbx, rax
    sub rsp, 32
.kl516:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1356
    mov rax, 8
    push rax
    mov rax, r12
    push rax
    mov rax, 0
    push rax
    mov rax, 2
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl517:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L1358
    mov rax, 1
    neg rax
    mov rbx, rax
    jmp .L1359
.L1358:
.L1359:
    jmp .L1357
.L1356:
    mov rax, [rel __g_fl_sizef]
    push rax
    mov rax, r12
    push rax
    lea rax, [rel __g_fl_word]
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl518:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    cmp rax, 0
    je .L1360
    lea rax, [rel __g_fl_word]
    mov rax, [rax]
    mov rbx, rax
    jmp .L1361
.L1360:
.L1361:
.L1357:
    mov rax, rbx
    jmp .__ret_1355
.__ret_1355:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_os_write.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl516,219
    dq .kl517,220
    dq .kl518,225
.kfn: db "fl_os_size", 0
section .text
fl_write_all:
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
    mov rax, 0
    mov r13, rax
.L1363:
    cmp r13, r14
    jge .L1364
    mov rax, r15
    mov r12, rax
    cmp r15, 0
    jl .L1366
    mov rax, r15
    add rax, r13
    mov r12, rax
    jmp .L1367
.L1366:
.L1367:
    mov rax, r14
    sub rax, r13
    mov rbx, rax
    mov rax, rbx
    mov rcx, 1073741824
    cmp rax, rcx
    jle .L1368
    mov rax, 1073741824
    mov rbx, rax
    jmp .L1369
.L1368:
.L1369:
    mov rax, [rbp-8]
    push rax
    mov rax, r12
    push rax
    mov rax, [rbp-24]
    add rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, rbx
    sub rsp, 32
.kl519:
    call fl_os_write
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jg .L1370
    mov rax, 1
    neg rax
    jmp .__ret_1362
    jmp .L1371
.L1370:
.L1371:
    add r13, rbx
.L1365:
    jmp .L1363
.L1364:
    mov rax, r13
    jmp .__ret_1362
.__ret_1362:
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
.kft: dq fl_os_size.kft, .kfe, .kfn, __kron_file_5,1
    dq .kl519,245
.kfn: db "fl_write_all", 0
section .text
fl_read_all:
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
.kl520:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L1373
    mov rax, 0
    jmp .__ret_1372
    jmp .L1374
.L1373:
.L1374:
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl521:
    call fl_os_open
    add rsp, 32
    mov r15, rax
    mov rax, r15
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1375
    mov rax, 8
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1372
    jmp .L1376
.L1375:
.L1376:
    mov rcx, r15
    sub rsp, 32
.kl522:
    call fl_os_size
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jge .L1377
    mov rax, 0
    mov r14, rax
    jmp .L1378
.L1377:
.L1378:
    mov rcx, r14
    sub rsp, 32
.kl523:
    call tx_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1379
    mov rcx, r15
    sub rsp, 32
.kl524:
    call fl_os_close
    add rsp, 32
    mov rax, 0
    jmp .__ret_1372
    jmp .L1380
.L1379:
.L1380:
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl525:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 1
    mov [rbp-56], rax
.L1381:
    mov rax, [rbp-56]
    test rax, rax
    jz .L1382
    cmp rbx, r14
    jl .L1384
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 65536
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl526:
    call tx_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1386
    mov rcx, r15
    sub rsp, 32
.kl527:
    call fl_os_close
    add rsp, 32
    mov rax, 0
    jmp .__ret_1372
    jmp .L1387
.L1386:
.L1387:
    mov rax, rbx
    add rax, 65536
    mov r14, rax
    jmp .L1385
.L1384:
.L1385:
    mov rax, r15
    push rax
    mov rax, rbx
    push rax
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rax, r14
    sub rax, rbx
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl528:
    call fl_os_read
    add rsp, 32
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jg .L1388
    mov rax, 0
    mov [rbp-56], rax
    jmp .L1389
.L1388:
    mov rax, rbx
    mov rcx, [rbp-64]
    add rax, rcx
    mov rbx, rax
.L1389:
.L1383:
    jmp .L1381
.L1382:
    mov rcx, r15
    sub rsp, 32
.kl529:
    call fl_os_close
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r13
    jmp .__ret_1372
.__ret_1372:
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
.kft: dq fl_write_all.kft, .kfe, .kfn, __kron_file_5,10
    dq .kl520,256
    dq .kl521,259
    dq .kl522,264
    dq .kl523,268
    dq .kl524,270
    dq .kl525,273
    dq .kl526,279
    dq .kl527,281
    dq .kl528,286
    dq .kl529,293
.kfn: db "fl_read_all", 0
section .text
fl_put:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov r12, rcx
    mov r13, rdx
    mov rbx, r8
    mov rcx, r12
    sub rsp, 32
.kl530:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L1391
    mov rax, 0
    jmp .__ret_1390
    jmp .L1392
.L1391:
.L1392:
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_FL_WRITE]
    or rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl531:
    call fl_os_open
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1393
    mov rax, 9
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1390
    jmp .L1394
.L1393:
.L1394:
    mov rcx, r13
    sub rsp, 32
.kl532:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L1395
    mov rcx, r12
    sub rsp, 32
.kl533:
    call fl_os_close
    add rsp, 32
    mov rax, 0
    jmp .__ret_1390
    jmp .L1396
.L1395:
.L1396:
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_tv_n]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl534:
    call fl_write_all
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
.kl535:
    call fl_os_close
    add rsp, 32
    cmp rbx, 0
    jge .L1397
    mov rax, 9
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1390
    jmp .L1398
.L1397:
.L1398:
    mov rax, rbx
    jmp .__ret_1390
.__ret_1390:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_read_all.kft, .kfe, .kfn, __kron_file_5,6
    dq .kl530,303
    dq .kl531,306
    dq .kl532,311
    dq .kl533,312
    dq .kl534,315
    dq .kl535,316
.kfn: db "fl_put", 0
section .text
fl_obj:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_FILE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl536:
    call ob_get
    add rsp, 32
    jmp .__ret_1399
.__ret_1399:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_put.kft, .kfe, .kfn, __kron_file_5,1
    dq .kl536,326
.kfn: db "fl_obj", 0
section .text
fl_field:
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
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_1400
.__ret_1400:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fl_set:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    jmp .__ret_1401
.__ret_1401:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
fl_fd:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rcx, rbx
    sub rsp, 32
.kl537:
    call fl_obj
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1403
    mov rax, 1
    neg rax
    jmp .__ret_1402
    jmp .L1404
.L1403:
.L1404:
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl538:
    call fl_field
    add rsp, 32
    and rax, r12
    cmp rax, 0
    jne .L1405
    mov rax, 16
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_1402
    jmp .L1406
.L1405:
.L1406:
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl539:
    call fl_field
    add rsp, 32
    jmp .__ret_1402
.__ret_1402:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_obj.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl537,342
    dq .kl538,346
    dq .kl539,350
.kfn: db "fl_fd", 0
section .text
file_read_all:
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
.kl540:
    call fl_read_all
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1407
.__ret_1407:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_fd.kft, .kfe, .kfn, __kron_file_5,1
    dq .kl540,357
.kfn: db "file_read_all", 0
section .text
file_lines:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl541:
    call file_read_all
    add rsp, 32
    mov r12, rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L1409
section .data
.str1411: db 116,104,101,32,102,105,108,101,32,99,111,117,108,100,32,110,111,116,32,98,101,32,111,112,101,110,101,100,0
section .text
    lea rax, [rel .str1411]
    push rax
section .data
.str1412: db 99,104,101,99,107,32,116,104,101,32,112,97,116,104,44,32,97,110,100,32,116,104,97,116,32,116,104,101,32,102,105,108,101,32,101,120,105,115,116,115,32,97,110,100,32,99,97,110,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str1412]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl542:
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1408
    jmp .L1410
.L1409:
.L1410:
    mov rcx, r12
    sub rsp, 32
.kl543:
    call text_lines
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
.kl544:
    call text_free
    add rsp, 32
    mov rax, rbx
    jmp .__ret_1408
.__ret_1408:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_read_all.kft, .kfe, .kfn, __kron_file_5,4
    dq .kl541,361
    dq .kl542,363
    dq .kl543,365
    dq .kl544,366
.kfn: db "file_lines", 0
section .text
file_write_all:
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
    mov r8, 8
    sub rsp, 32
.kl545:
    call fl_put
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1413
.__ret_1413:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_lines.kft, .kfe, .kfn, __kron_file_5,1
    dq .kl545,372
.kfn: db "file_write_all", 0
section .text
file_append:
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
    mov rax, rbx
    push rax
    mov rax, [rel __g_FL_APPEND]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl546:
    call fl_put
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1414
.__ret_1414:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_write_all.kft, .kfe, .kfn, __kron_file_5,1
    dq .kl546,377
.kfn: db "file_append", 0
section .text
file_open:
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
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    push rax
section .data
.str1418: db 114,0
section .text
    lea rax, [rel .str1418]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl547:
    call text_same_u
    add rsp, 32
    test rax, rax
    jz .L1416
    mov rax, [rel __g_FL_READ]
    mov r14, rax
    jmp .L1417
.L1416:
    mov rax, rbx
    push rax
section .data
.str1421: db 119,0
section .text
    lea rax, [rel .str1421]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl548:
    call text_same_u
    add rsp, 32
    test rax, rax
    jz .L1419
    mov rax, [rel __g_FL_WRITE]
    or rax, 8
    mov r14, rax
    jmp .L1420
.L1419:
    mov rax, rbx
    push rax
section .data
.str1424: db 97,0
section .text
    lea rax, [rel .str1424]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_same_u
    add rsp, 32
    test rax, rax
    jz .L1422
    mov rax, [rel __g_FL_WRITE]
    push rax
    mov rax, [rel __g_FL_APPEND]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L1423
.L1422:
    mov rax, rbx
    push rax
section .data
.str1427: db 114,119,0
section .text
    lea rax, [rel .str1427]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_same_u
    add rsp, 32
    test rax, rax
    jz .L1425
    mov rax, [rel __g_FL_READ]
    push rax
    mov rax, [rel __g_FL_WRITE]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r14, rax
    jmp .L1426
.L1425:
    mov rax, 16
    mov [rel __g_hp_err], rax
.L1426:
.L1423:
.L1420:
.L1417:
    mov rax, [rel __g_hp_err]
    cmp rax, 0
    jne .L1428
    mov rcx, r12
    sub rsp, 32
.kl549:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1430
    mov rax, [rel __g_tv_p]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
.kl550:
    call fl_os_open
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1432
    mov rax, 8
    mov [rel __g_hp_err], rax
    mov rax, r14
    push rax
    mov rax, [rel __g_FL_WRITE]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    je .L1434
    mov rax, 9
    mov [rel __g_hp_err], rax
    jmp .L1435
.L1434:
.L1435:
    jmp .L1433
.L1432:
    mov rcx, 32
    sub rsp, 32
.kl551:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1436
    mov rcx, rbx
    mov rdx, 0
    mov r8, r12
    sub rsp, 32
.kl552:
    call fl_set
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    mov r8, r14
    sub rsp, 32
.kl553:
    call fl_set
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_FL_APPEND]
    mov rcx, rax
    pop rax
    and rax, rcx
    cmp rax, 0
    je .L1438
    mov rax, rbx
    push rax
    mov rax, 2
    push rax
    mov rcx, r12
    sub rsp, 32
.kl554:
    call fl_os_size
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call fl_set
    add rsp, 32
    jmp .L1439
.L1438:
.L1439:
    mov rax, [rel __g_OB_FILE]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl555:
    call ob_new
    add rsp, 32
    mov r13, rax
    jmp .L1437
.L1436:
.L1437:
.L1433:
    jmp .L1431
.L1430:
.L1431:
    jmp .L1429
.L1428:
.L1429:
    mov rcx, r13
    sub rsp, 32
.kl556:
    call text_end
    add rsp, 32
    jmp .__ret_1415
.__ret_1415:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_append.kft, .kfe, .kfn, __kron_file_5,10
    dq .kl547,384
    dq .kl548,395
    dq .kl549,396
    dq .kl550,397
    dq .kl551,404
    dq .kl552,406
    dq .kl553,407
    dq .kl554,409
    dq .kl555,411
    dq .kl556,416
.kfn: db "file_open", 0
section .text
text_same_u:
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
.kl557:
    call tv_compare
    add rsp, 32
    cmp rax, 0
    jne .L1441
    mov rax, 1
    jmp .__ret_1440
    jmp .L1442
.L1441:
.L1442:
    mov rax, 0
    jmp .__ret_1440
.__ret_1440:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_open.kft, .kfe, .kfn, __kron_file_5,1
    dq .kl557,420
.kfn: db "text_same_u", 0
section .text
file_close:
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
    mov rcx, r12
    sub rsp, 32
.kl558:
    call fl_obj
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1444
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl559:
    call fl_field
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call fl_os_close
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl560:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl561:
    call hp_release
    add rsp, 32
    jmp .L1445
.L1444:
.L1445:
    mov rcx, 0
    sub rsp, 32
.kl562:
    call text_end
    add rsp, 32
    jmp .__ret_1443
.__ret_1443:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq text_same_u.kft, .kfe, .kfn, __kron_file_5,5
    dq .kl558,428
    dq .kl559,430
    dq .kl560,431
    dq .kl561,432
    dq .kl562,434
.kfn: db "file_close", 0
section .text
file_read:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r13, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r15, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl563:
    call fl_fd
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1447
    mov rcx, r13
    sub rsp, 32
.kl564:
    call fl_obj
    add rsp, 32
    mov r14, rax
    mov rax, r12
    mov r13, rax
    cmp r13, 0
    jge .L1449
    mov rax, 0
    mov r13, rax
    jmp .L1450
.L1449:
.L1450:
    mov rcx, r13
    sub rsp, 32
.kl565:
    call tx_new
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    je .L1451
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl566:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, rbx
    push rax
    mov rcx, r14
    mov rdx, 2
    sub rsp, 32
.kl567:
    call fl_field
    add rsp, 32
    push rax
    mov rax, r12
    add rax, 8
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, r13
    sub rsp, 32
    call fl_os_read
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L1453
    mov rax, 8
    mov [rel __g_hp_err], rax
    mov rax, 0
    mov rbx, rax
    jmp .L1454
.L1453:
.L1454:
    cmp rbx, r13
    jge .L1455
    mov rcx, r14
    mov rdx, 3
    mov r8, 1
    sub rsp, 32
.kl568:
    call fl_set
    add rsp, 32
    jmp .L1456
.L1455:
.L1456:
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    add rax, 8
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r14
    push rax
    mov rax, 2
    push rax
    mov rcx, r14
    mov rdx, 2
    sub rsp, 32
.kl569:
    call fl_field
    add rsp, 32
    add rax, rbx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call fl_set
    add rsp, 32
    jmp .L1452
.L1451:
.L1452:
    jmp .L1448
.L1447:
.L1448:
    mov rcx, r15
    sub rsp, 32
.kl570:
    call text_end
    add rsp, 32
    jmp .__ret_1446
.__ret_1446:
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
.kft: dq file_close.kft, .kfe, .kfn, __kron_file_5,8
    dq .kl563,440
    dq .kl564,442
    dq .kl565,447
    dq .kl566,449
    dq .kl567,450
    dq .kl568,456
    dq .kl569,462
    dq .kl570,465
.kfn: db "file_read", 0
section .text
file_read_line:
    push rbp
    mov rbp, rsp
    sub rsp, 688
    mov [rbp-656], rbx
    mov [rbp-648], r12
    mov [rbp-640], r13
    mov [rbp-632], r14
    mov [rbp-624], r15
    mov rbx, rcx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r15, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl571:
    call fl_fd
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1458
    mov rcx, rbx
    sub rsp, 32
.kl572:
    call fl_obj
    add rsp, 32
    mov r14, rax
    mov rcx, 80
    sub rsp, 32
.kl573:
    call tx_new
    add rsp, 32
    mov r15, rax
    mov rax, 1
    mov [rbp-552], rax
.L1460:
    mov rax, [rbp-552]
    test rax, rax
    jz .L1463
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1463
    mov rax, 1
    jmp .L1464
.L1463:
    mov rax, 0
.L1464:
    test rax, rax
    jz .L1461
    mov rcx, r14
    mov rdx, 2
    sub rsp, 32
.kl574:
    call fl_field
    add rsp, 32
    mov [rbp-560], rax
    mov rax, [rbp-24]
    push rax
    mov rax, [rbp-560]
    push rax
    lea rax, [rbp-544]
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 512
    sub rsp, 32
.kl575:
    call fl_os_read
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jg .L1465
    mov rcx, r14
    mov rdx, 3
    mov r8, 1
    sub rsp, 32
.kl576:
    call fl_set
    add rsp, 32
    mov rax, 0
    mov [rbp-552], rax
    jmp .L1466
.L1465:
    mov rax, 0
    mov r12, rax
    mov rax, r13
    mov rbx, rax
    lea rax, [rbp-544]
    mov [rbp-592], rax
.L1467:
    cmp r12, r13
    jge .L1468
    mov rax, [rbp-592]
    add rax, r12
    movzx rax, byte [rax]
    cmp rax, 10
    jne .L1470
    mov rax, r12
    mov rbx, rax
    mov rax, r13
    mov r12, rax
    jmp .L1471
.L1470:
.L1471:
    add r12, 1
.L1469:
    jmp .L1467
.L1468:
    mov rax, r15
    push rax
    lea rax, [rbp-544]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl577:
    call tx_add_bytes
    add rsp, 32
    cmp rbx, r13
    jge .L1472
    mov rax, r14
    push rax
    mov rax, 2
    push rax
    mov rax, [rbp-560]
    add rax, rbx
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl578:
    call fl_set
    add rsp, 32
    mov rax, 0
    mov [rbp-552], rax
    jmp .L1473
.L1472:
    mov rax, r14
    push rax
    mov rax, 2
    push rax
    mov rax, [rbp-560]
    add rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl579:
    call fl_set
    add rsp, 32
.L1473:
.L1466:
.L1462:
    jmp .L1460
.L1461:
    cmp r15, 0
    je .L1474
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl580:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    cmp rbx, 0
    jle .L1476
    mov rax, r12
    add rax, 8
    add rax, rbx
    sub rax, 1
    movzx rax, byte [rax]
    cmp rax, 13
    jne .L1478
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
    jmp .L1479
.L1478:
.L1479:
    jmp .L1477
.L1476:
.L1477:
    jmp .L1475
.L1474:
.L1475:
    jmp .L1459
.L1458:
.L1459:
    mov rcx, r15
    sub rsp, 32
.kl581:
    call text_end
    add rsp, 32
    jmp .__ret_1457
.__ret_1457:
    mov rbx, [rbp-656]
    mov r12, [rbp-648]
    mov r13, [rbp-640]
    mov r14, [rbp-632]
    mov r15, [rbp-624]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_read.kft, .kfe, .kfn, __kron_file_5,11
    dq .kl571,471
    dq .kl572,473
    dq .kl573,474
    dq .kl574,478
    dq .kl575,479
    dq .kl576,481
    dq .kl577,496
    dq .kl578,498
    dq .kl579,501
    dq .kl580,507
    dq .kl581,519
.kfn: db "file_read_line", 0
section .text
file_write:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_FL_WRITE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl582:
    call fl_fd
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1481
    mov rcx, rbx
    sub rsp, 32
.kl583:
    call fl_obj
    add rsp, 32
    mov rbx, rax
    mov rcx, r14
    sub rsp, 32
.kl584:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1483
    mov rax, r12
    push rax
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
.kl585:
    call fl_field
    add rsp, 32
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_tv_n]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call fl_write_all
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jge .L1485
    mov rax, 9
    mov [rel __g_hp_err], rax
    mov rax, 0
    mov r13, rax
    jmp .L1486
.L1485:
    mov rax, rbx
    push rax
    mov rax, 2
    push rax
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
.kl586:
    call fl_field
    add rsp, 32
    add rax, r13
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call fl_set
    add rsp, 32
.L1486:
    jmp .L1484
.L1483:
.L1484:
    jmp .L1482
.L1481:
.L1482:
    mov rcx, r13
    sub rsp, 32
.kl587:
    call text_end
    add rsp, 32
    jmp .__ret_1480
.__ret_1480:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_read_line.kft, .kfe, .kfn, __kron_file_5,6
    dq .kl582,525
    dq .kl583,527
    dq .kl584,528
    dq .kl585,529
    dq .kl586,534
    dq .kl587,538
.kfn: db "file_write", 0
section .text
file_read_at:
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
    mov r14, r8
    mov r13, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl588:
    call fl_fd
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1488
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1492
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1492
    mov rax, 0
    jmp .L1493
.L1492:
    mov rax, 1
.L1493:
    test rax, rax
    jz .L1490
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L1491
.L1490:
    mov rcx, rbx
    mov rdx, r15
    mov r8, r14
    mov r9, r13
    sub rsp, 32
.kl589:
    call fl_os_read
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jge .L1494
    mov rax, 8
    mov [rel __g_hp_err], rax
    mov rax, 0
    mov r12, rax
    jmp .L1495
.L1494:
.L1495:
.L1491:
    jmp .L1489
.L1488:
.L1489:
    mov rcx, r12
    sub rsp, 32
.kl590:
    call text_end
    add rsp, 32
    jmp .__ret_1487
.__ret_1487:
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
.kft: dq file_write.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl588,544
    dq .kl589,549
    dq .kl590,556
.kfn: db "file_read_at", 0
section .text
file_write_at:
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
    mov r14, r8
    mov r13, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_FL_WRITE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl591:
    call fl_fd
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1497
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1501
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L1501
    mov rax, 0
    jmp .L1502
.L1501:
    mov rax, 1
.L1502:
    test rax, rax
    jz .L1499
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L1500
.L1499:
    mov rcx, rbx
    mov rdx, r15
    mov r8, r14
    mov r9, r13
    sub rsp, 32
.kl592:
    call fl_write_all
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jge .L1503
    mov rax, 9
    mov [rel __g_hp_err], rax
    mov rax, 0
    mov r12, rax
    jmp .L1504
.L1503:
.L1504:
.L1500:
    jmp .L1498
.L1497:
.L1498:
    mov rcx, r12
    sub rsp, 32
.kl593:
    call text_end
    add rsp, 32
    jmp .__ret_1496
.__ret_1496:
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
.kft: dq file_read_at.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl591,562
    dq .kl592,567
    dq .kl593,574
.kfn: db "file_write_at", 0
section .text
file_seek:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov r12, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl594:
    call fl_obj
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1506
    cmp r12, 0
    jge .L1508
    mov rax, 5
    mov [rel __g_hp_err], rax
    jmp .L1509
.L1508:
    mov rcx, rbx
    mov rdx, 2
    mov r8, r12
    sub rsp, 32
.kl595:
    call fl_set
    add rsp, 32
    mov rcx, rbx
    mov rdx, 3
    mov r8, 0
    sub rsp, 32
.kl596:
    call fl_set
    add rsp, 32
.L1509:
    jmp .L1507
.L1506:
.L1507:
    mov rcx, r12
    sub rsp, 32
.kl597:
    call text_end
    add rsp, 32
    jmp .__ret_1505
.__ret_1505:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_write_at.kft, .kfe, .kfn, __kron_file_5,4
    dq .kl594,579
    dq .kl595,584
    dq .kl596,585
    dq .kl597,588
.kfn: db "file_seek", 0
section .text
file_pos:
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
    mov rcx, rbx
    sub rsp, 32
.kl598:
    call fl_obj
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L1511
    mov rcx, r12
    mov rdx, 2
    sub rsp, 32
.kl599:
    call fl_field
    add rsp, 32
    mov rbx, rax
    jmp .L1512
.L1511:
.L1512:
    mov rcx, rbx
    sub rsp, 32
.kl600:
    call text_end
    add rsp, 32
    jmp .__ret_1510
.__ret_1510:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_seek.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl598,593
    dq .kl599,596
    dq .kl600,598
.kfn: db "file_pos", 0
section .text
file_size:
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
    mov rcx, rbx
    sub rsp, 32
.kl601:
    call fl_obj
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L1514
    mov rcx, r12
    mov rdx, 0
    sub rsp, 32
.kl602:
    call fl_field
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call fl_os_size
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L1516
    mov rax, 0
    mov rbx, rax
    jmp .L1517
.L1516:
.L1517:
    jmp .L1515
.L1514:
.L1515:
    mov rcx, rbx
    sub rsp, 32
.kl603:
    call text_end
    add rsp, 32
    jmp .__ret_1513
.__ret_1513:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_pos.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl601,603
    dq .kl602,606
    dq .kl603,611
.kfn: db "file_size", 0
section .text
file_at_end:
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
.kl604:
    call fl_obj
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    cmp r13, 0
    je .L1519
    mov rcx, r13
    mov rdx, 3
    sub rsp, 32
.kl605:
    call fl_field
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1521
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
.kl606:
    call fl_field
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call fl_os_size
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    mov rdx, 2
    sub rsp, 32
.kl607:
    call fl_field
    add rsp, 32
    cmp rax, rbx
    jl .L1523
    mov rax, 1
    mov r12, rax
    jmp .L1524
.L1523:
.L1524:
    jmp .L1522
.L1521:
.L1522:
    jmp .L1520
.L1519:
.L1520:
    mov rcx, r12
    sub rsp, 32
.kl608:
    call text_end
    add rsp, 32
    jmp .__ret_1518
.__ret_1518:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_size.kft, .kfe, .kfn, __kron_file_5,5
    dq .kl604,616
    dq .kl605,619
    dq .kl606,621
    dq .kl607,622
    dq .kl608,627
.kfn: db "file_at_end", 0
section .text
file_exists:
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
    mov rax, 0
    mov r12, rax
    mov rcx, r13
    sub rsp, 32
.kl609:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1526
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl610:
    call fl_os_open
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L1528
    mov rcx, rbx
    sub rsp, 32
.kl611:
    call fl_os_close
    add rsp, 32
    mov rax, 1
    mov r12, rax
    sub rsp, 32
.kl612:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1530
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
.kl613:
    call fl_list
    add rsp, 32
    test rax, rax
    jz .L1532
    mov rax, 0
    mov r12, rax
    jmp .L1533
.L1532:
.L1533:
    mov rax, 0
    mov [rel __g_hp_err], rax
    jmp .L1531
.L1530:
.L1531:
    jmp .L1529
.L1528:
.L1529:
    jmp .L1527
.L1526:
.L1527:
    mov rcx, r12
    sub rsp, 32
.kl614:
    call text_end
    add rsp, 32
    jmp .__ret_1525
.__ret_1525:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_at_end.kft, .kfe, .kfn, __kron_file_5,6
    dq .kl609,633
    dq .kl610,634
    dq .kl611,636
    dq .kl612,639
    dq .kl613,640
    dq .kl614,647
.kfn: db "file_exists", 0
section .text
file_length:
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
    mov rax, 0
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
.kl615:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1535
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl616:
    call fl_os_open
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1537
    mov rax, 8
    mov [rel __g_hp_err], rax
    jmp .L1538
.L1537:
    mov rcx, rbx
    sub rsp, 32
.kl617:
    call fl_os_size
    add rsp, 32
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
.kl618:
    call fl_os_close
    add rsp, 32
.L1538:
    jmp .L1536
.L1535:
.L1536:
    mov rcx, r12
    sub rsp, 32
.kl619:
    call text_end
    add rsp, 32
    jmp .__ret_1534
.__ret_1534:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_exists.kft, .kfe, .kfn, __kron_file_5,5
    dq .kl615,653
    dq .kl616,654
    dq .kl617,658
    dq .kl618,659
    dq .kl619,662
.kfn: db "file_length", 0
section .text
file_delete:
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
.kl620:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1540
    sub rsp, 32
.kl621:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1542
    mov rax, 87
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rdi
    pop rax
.kl622:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    cmp rax, 0
    jne .L1544
    mov rax, 1
    mov rbx, rax
    jmp .L1545
.L1544:
.L1545:
    jmp .L1543
.L1542:
    sub rsp, 32
.kl623:
    call fl_load
    add rsp, 32
    mov rax, [rel __g_fl_deletef]
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl624:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
.L1543:
    cmp rbx, 0
    jne .L1546
    mov rax, 13
    mov [rel __g_hp_err], rax
    jmp .L1547
.L1546:
.L1547:
    jmp .L1541
.L1540:
.L1541:
    mov rcx, rbx
    sub rsp, 32
.kl625:
    call text_end
    add rsp, 32
    jmp .__ret_1539
.__ret_1539:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_length.kft, .kfe, .kfn, __kron_file_5,6
    dq .kl620,668
    dq .kl621,670
    dq .kl622,671
    dq .kl623,675
    dq .kl624,676
    dq .kl625,683
.kfn: db "file_delete", 0
section .text
file_rename:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, 0
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
.kl626:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1549
    mov rax, [rel __g_tv_p]
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
.kl627:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1551
    sub rsp, 32
.kl628:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1553
    mov rax, 82
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rsi
    pop rdi
    pop rax
.kl629:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    cmp rax, 0
    jne .L1555
    mov rax, 1
    mov r12, rax
    jmp .L1556
.L1555:
.L1556:
    jmp .L1554
.L1553:
    sub rsp, 32
.kl630:
    call fl_load
    add rsp, 32
    mov rax, [rel __g_fl_movef]
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, 1
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
.kl631:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov r12, rax
.L1554:
    cmp r12, 0
    jne .L1557
    mov rax, 13
    mov [rel __g_hp_err], rax
    jmp .L1558
.L1557:
.L1558:
    jmp .L1552
.L1551:
.L1552:
    jmp .L1550
.L1549:
.L1550:
    mov rcx, r12
    sub rsp, 32
.kl632:
    call text_end
    add rsp, 32
    jmp .__ret_1548
.__ret_1548:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_delete.kft, .kfe, .kfn, __kron_file_5,7
    dq .kl626,689
    dq .kl627,691
    dq .kl628,693
    dq .kl629,694
    dq .kl630,698
    dq .kl631,699
    dq .kl632,707
.kfn: db "file_rename", 0
section .text
dir_make:
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
.kl633:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1560
    sub rsp, 32
.kl634:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1562
    mov rax, 83
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, 493
    push rax
    pop rsi
    pop rdi
    pop rax
.kl635:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    cmp rax, 0
    jne .L1564
    mov rax, 1
    mov rbx, rax
    jmp .L1565
.L1564:
.L1565:
    jmp .L1563
.L1562:
    sub rsp, 32
.kl636:
    call fl_load
    add rsp, 32
    mov rax, [rel __g_fl_mkdirf]
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, 0
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl637:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
.L1563:
    cmp rbx, 0
    jne .L1566
    mov rax, 14
    mov [rel __g_hp_err], rax
    jmp .L1567
.L1566:
.L1567:
    jmp .L1561
.L1560:
.L1561:
    mov rcx, rbx
    sub rsp, 32
.kl638:
    call text_end
    add rsp, 32
    jmp .__ret_1559
.__ret_1559:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq file_rename.kft, .kfe, .kfn, __kron_file_5,6
    dq .kl633,713
    dq .kl634,715
    dq .kl635,716
    dq .kl636,720
    dq .kl637,721
    dq .kl638,728
.kfn: db "dir_make", 0
section .text
dir_remove:
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
.kl639:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1569
    sub rsp, 32
.kl640:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1571
    mov rax, 84
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rdi
    pop rax
.kl641:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    cmp rax, 0
    jne .L1573
    mov rax, 1
    mov rbx, rax
    jmp .L1574
.L1573:
.L1574:
    jmp .L1572
.L1571:
    sub rsp, 32
.kl642:
    call fl_load
    add rsp, 32
    mov rax, [rel __g_fl_rmdirf]
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl643:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov rbx, rax
.L1572:
    cmp rbx, 0
    jne .L1575
    mov rax, 13
    mov [rel __g_hp_err], rax
    jmp .L1576
.L1575:
.L1576:
    jmp .L1570
.L1569:
.L1570:
    mov rcx, rbx
    sub rsp, 32
.kl644:
    call text_end
    add rsp, 32
    jmp .__ret_1568
.__ret_1568:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq dir_make.kft, .kfe, .kfn, __kron_file_5,6
    dq .kl639,734
    dq .kl640,736
    dq .kl641,737
    dq .kl642,741
    dq .kl643,742
    dq .kl644,749
.kfn: db "dir_remove", 0
section .text
fl_list:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    mov [rbp-192], rbx
    mov [rbp-184], r12
    mov [rbp-176], r13
    mov [rbp-168], r14
    mov [rbp-160], r15
    mov rbx, rcx
    mov r15, rdx
    mov rcx, rbx
    sub rsp, 32
.kl645:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L1578
    mov rax, 0
    jmp .__ret_1577
    jmp .L1579
.L1578:
.L1579:
    mov rax, 0
    mov r14, rax
    cmp r15, 0
    jne .L1580
    mov rcx, 16
    sub rsp, 32
.kl646:
    call li_new
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L1582
    mov rax, 0
    jmp .__ret_1577
    jmp .L1583
.L1582:
.L1583:
    jmp .L1581
.L1580:
.L1581:
    mov rax, 0
    mov r13, rax
    sub rsp, 32
.kl647:
    call fl_linux
    add rsp, 32
    test rax, rax
    jz .L1584
    mov rax, [rel __g_tv_p]
    push rax
    mov rax, [rel __g_FL_READ]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl648:
    call fl_os_open
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1586
    mov rax, 11
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1577
    jmp .L1587
.L1586:
.L1587:
    mov rcx, 32768
    sub rsp, 32
.kl649:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1588
    mov rcx, [rbp-40]
    sub rsp, 32
.kl650:
    call fl_os_close
    add rsp, 32
    mov rax, 0
    jmp .__ret_1577
    jmp .L1589
.L1588:
.L1589:
    mov rax, 1
    mov [rbp-56], rax
.L1590:
    mov rax, [rbp-56]
    test rax, rax
    jz .L1591
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 217
    push rax
    mov rax, [rbp-40]
    push rax
    mov rax, r12
    push rax
    mov rax, 32768
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl651:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jge .L1593
    mov rax, 0
    mov [rbp-56], rax
    jmp .L1594
.L1593:
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L1595
    mov rax, 1
    mov r13, rax
    mov rax, 0
    mov [rbp-56], rax
    jmp .L1596
.L1595:
    mov rax, 1
    mov r13, rax
    mov rax, 0
    mov rbx, rax
.L1597:
    mov rax, rbx
    mov rcx, [rbp-64]
    cmp rax, rcx
    jge .L1598
    mov rax, 0
    mov [rbp-80], rax
    mov rax, r12
    add rax, rbx
    add rax, 19
    mov [rbp-88], rax
    mov rax, r12
    add rax, rbx
    add rax, 16
    movzx rax, word [rax]
    mov [rbp-80], rax
    cmp r15, 0
    jne .L1600
    mov rcx, [rbp-88]
    sub rsp, 32
.kl652:
    call tx_skip_dots
    add rsp, 32
    cmp rax, 0
    jne .L1602
    mov rax, r14
    push rax
    mov rcx, [rbp-88]
    sub rsp, 32
.kl653:
    call tx_copy
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    jmp .L1603
.L1602:
.L1603:
    jmp .L1601
.L1600:
.L1601:
    mov rax, rbx
    mov rcx, [rbp-80]
    add rax, rcx
    mov rbx, rax
.L1599:
    jmp .L1597
.L1598:
    mov rax, r15
    test rax, rax
    jz .L1604
    mov rax, 0
    mov [rbp-56], rax
    jmp .L1605
.L1604:
.L1605:
.L1596:
.L1594:
.L1592:
    jmp .L1590
.L1591:
    mov rcx, r12
    sub rsp, 32
.kl654:
    call hp_release
    add rsp, 32
    mov rcx, [rbp-40]
    sub rsp, 32
.kl655:
    call fl_os_close
    add rsp, 32
    jmp .L1585
.L1584:
    sub rsp, 32
.kl656:
    call fl_load
    add rsp, 32
    mov rax, [rel __g_tv_n]
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
.kl657:
    call tx_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L1606
    mov rax, 0
    jmp .__ret_1577
    jmp .L1607
.L1606:
.L1607:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl658:
    call tx_add
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl659:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov [rbp-112], rax
    mov rax, r12
    mov rax, [rax]
    mov [rbp-112], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-112]
    cmp rax, 0
    jle .L1608
    mov rax, r12
    add rax, 8
    mov rcx, [rbp-112]
    add rax, rcx
    sub rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L1609
.L1608:
.L1609:
    mov rax, rbx
    mov rcx, 92
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1612
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1612
    mov rax, 1
    jmp .L1613
.L1612:
    mov rax, 0
.L1613:
    test rax, rax
    jz .L1610
    mov rax, r13
    push rax
section .data
.str1614: db 92,0
section .text
    lea rax, [rel .str1614]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl660:
    call tx_add
    add rsp, 32
    jmp .L1611
.L1610:
.L1611:
    mov rax, r13
    push rax
section .data
.str1615: db 42,0
section .text
    lea rax, [rel .str1615]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl661:
    call tx_add
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl662:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rax, [rel __g_fl_findfirst]
    push rax
    mov rax, r12
    add rax, 8
    push rax
    lea rax, [rel __g_fl_find]
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl663:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
.kl664:
    call ob_drop
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl665:
    call hp_release
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L1616
    mov rax, 11
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1577
    jmp .L1617
.L1616:
.L1617:
    mov rax, 1
    mov r13, rax
    mov rax, 1
    mov r12, rax
.L1618:
    mov rax, r12
    test rax, rax
    jz .L1621
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1621
    mov rax, 1
    jmp .L1622
.L1621:
    mov rax, 0
.L1622:
    test rax, rax
    jz .L1619
    mov rax, 0
    mov r12, rax
    lea rax, [rel __g_fl_find]
    add rax, 44
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
.kl666:
    call tx_skip_dots
    add rsp, 32
    cmp rax, 0
    jne .L1623
    mov rax, r14
    push rax
    mov rcx, r12
    sub rsp, 32
.kl667:
    call tx_copy
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    jmp .L1624
.L1623:
.L1624:
    mov rax, [rel __g_fl_findnext]
    push rax
    mov rax, rbx
    push rax
    lea rax, [rel __g_fl_find]
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl668:
    call r11
    add rsp, 32
    pop rsp
    push rax
    pop rcx
    sub rsp, 32
    call fl_low
    add rsp, 32
    mov r12, rax
.L1620:
    jmp .L1618
.L1619:
    mov rax, [rel __g_fl_findclose]
    push rax
    mov rax, rbx
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl669:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_fl_ignore], rax
.L1585:
    mov rax, r15
    test rax, rax
    jz .L1625
    mov rax, r13
    jmp .__ret_1577
    jmp .L1626
.L1625:
.L1626:
    cmp r13, 0
    jne .L1627
    mov rax, 11
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1577
    jmp .L1628
.L1627:
.L1628:
    mov rax, r14
    jmp .__ret_1577
.__ret_1577:
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
.kft: dq dir_remove.kft, .kfe, .kfn, __kron_file_5,25
    dq .kl645,755
    dq .kl646,760
    dq .kl647,766
    dq .kl648,767
    dq .kl649,772
    dq .kl650,774
    dq .kl651,780
    dq .kl652,794
    dq .kl653,795
    dq .kl654,805
    dq .kl655,806
    dq .kl656,808
    dq .kl657,810
    dq .kl658,814
    dq .kl659,815
    dq .kl660,823
    dq .kl661,825
    dq .kl662,826
    dq .kl663,828
    dq .kl664,829
    dq .kl665,830
    dq .kl666,840
    dq .kl667,841
    dq .kl668,843
    dq .kl669,845
.kfn: db "fl_list", 0
section .text
tx_skip_dots:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    movzx rax, byte [rax]
    mov r13, rax
    cmp r13, 0
    je .L1630
    mov rax, r14
    add rax, 1
    movzx rax, byte [rax]
    mov r12, rax
    cmp r12, 0
    je .L1632
    mov rax, r14
    add rax, 2
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L1633
.L1632:
.L1633:
    jmp .L1631
.L1630:
.L1631:
    cmp r13, 46
    jne .L1634
    cmp r12, 0
    jne .L1636
    mov rax, 1
    jmp .__ret_1629
    jmp .L1637
.L1636:
.L1637:
    cmp r12, 46
    jne .L1638
    cmp rbx, 0
    jne .L1640
    mov rax, 1
    jmp .__ret_1629
    jmp .L1641
.L1640:
.L1641:
    jmp .L1639
.L1638:
.L1639:
    jmp .L1635
.L1634:
.L1635:
    mov rax, 0
    jmp .__ret_1629
.__ret_1629:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
dir_list:
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
.kl670:
    call fl_list
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1643
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl671:
    call li_sort
    add rsp, 32
    jmp .L1644
.L1643:
.L1644:
    mov rcx, rbx
    sub rsp, 32
.kl672:
    call text_end
    add rsp, 32
    jmp .__ret_1642
.__ret_1642:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fl_list.kft, .kfe, .kfn, __kron_file_5,3
    dq .kl670,886
    dq .kl671,888
    dq .kl672,890
.kfn: db "dir_list", 0
section .text
dir_exists:
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
.kl673:
    call fl_list
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rel __g_hp_err], rax
    mov rcx, rbx
    sub rsp, 32
.kl674:
    call text_end
    add rsp, 32
    jmp .__ret_1645
.__ret_1645:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq dir_list.kft, .kfe, .kfn, __kron_file_5,2
    dq .kl673,895
    dq .kl674,897
.kfn: db "dir_exists", 0
section .text
m_pi:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt1647: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt1647]
    jmp .__ret_1646
.__ret_1646:
    mov rsp, rbp
    pop rbp
    ret
m_tau:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt1649: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt1649]
    jmp .__ret_1648
.__ret_1648:
    mov rsp, rbp
    pop rbp
    ret
m_half_pi:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.flt1651: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt1651]
    jmp .__ret_1650
.__ret_1650:
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
.flt1655: dq 0.0
section .text
    movsd xmm0, [rel .flt1655]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1653
section .data
.flt1656: dq 0.0
section .text
    movsd xmm0, [rel .flt1656]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    jmp .__ret_1652
    jmp .L1654
.L1653:
.L1654:
    movaps xmm0, xmm6
    jmp .__ret_1652
.__ret_1652:
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
    jz .L1658
    movaps xmm0, xmm7
    jmp .__ret_1657
    jmp .L1659
.L1658:
.L1659:
    movaps xmm0, xmm6
    jmp .__ret_1657
.__ret_1657:
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
    jz .L1661
    movaps xmm0, xmm7
    jmp .__ret_1660
    jmp .L1662
.L1661:
.L1662:
    movaps xmm0, xmm6
    jmp .__ret_1660
.__ret_1660:
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
    jz .L1664
    movaps xmm0, xmm7
    jmp .__ret_1663
    jmp .L1665
.L1664:
.L1665:
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
    jz .L1666
    movaps xmm0, xmm6
    jmp .__ret_1663
    jmp .L1667
.L1666:
.L1667:
    movaps xmm0, xmm8
    jmp .__ret_1663
.__ret_1663:
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
.flt1671: dq 0.0
section .text
    movsd xmm0, [rel .flt1671]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L1669
section .data
.flt1672: dq 1.0
section .text
    movsd xmm0, [rel .flt1672]
    jmp .__ret_1668
    jmp .L1670
.L1669:
.L1670:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1675: dq 0.0
section .text
    movsd xmm0, [rel .flt1675]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1673
section .data
.flt1676: dq 0.0
section .text
    movsd xmm0, [rel .flt1676]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1677: dq 1.0
section .text
    movsd xmm0, [rel .flt1677]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_1668
    jmp .L1674
.L1673:
.L1674:
section .data
.flt1678: dq 0.0
section .text
    movsd xmm0, [rel .flt1678]
    jmp .__ret_1668
.__ret_1668:
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
    jz .L1680
section .data
.flt1682: dq 1.0
section .text
    movsd xmm0, [rel .flt1682]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L1681
.L1680:
.L1681:
    movaps xmm0, xmm6
    jmp .__ret_1679
.__ret_1679:
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
    jz .L1684
section .data
.flt1686: dq 1.0
section .text
    movsd xmm0, [rel .flt1686]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L1685
.L1684:
.L1685:
    movaps xmm0, xmm6
    jmp .__ret_1683
.__ret_1683:
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
.flt1690: dq 0.0
section .text
    movsd xmm0, [rel .flt1690]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1688
section .data
.flt1691: dq 0.0
section .text
    movsd xmm0, [rel .flt1691]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1692: dq 0.5
section .text
    movsd xmm0, [rel .flt1692]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl675:
    call ffloor
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_1687
    jmp .L1689
.L1688:
.L1689:
section .data
.flt1693: dq 0.5
section .text
    movsd xmm0, [rel .flt1693]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl676:
    call ffloor
    add rsp, 32
    jmp .__ret_1687
.__ret_1687:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq dir_exists.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl675,102
    dq .kl676,104
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
.flt1697: dq 0.0
section .text
    movsd xmm0, [rel .flt1697]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L1695
section .data
.flt1698: dq 0.0
section .text
    movsd xmm0, [rel .flt1698]
    jmp .__ret_1694
    jmp .L1696
.L1695:
.L1696:
    movaps xmm0, xmm9
    movaps xmm1, xmm8
    divsd xmm0, xmm1
    movaps xmm7, xmm0
section .data
.flt1699: dq 0.0
section .text
    movsd xmm0, [rel .flt1699]
    movaps xmm6, xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1702: dq 0.0
section .text
    movsd xmm0, [rel .flt1702]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1700
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl677:
    call fceil
    add rsp, 32
    movaps xmm6, xmm0
    jmp .L1701
.L1700:
.L1701:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1705: dq 0.0
section .text
    movsd xmm0, [rel .flt1705]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L1703
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl678:
    call ffloor
    add rsp, 32
    movaps xmm6, xmm0
    jmp .L1704
.L1703:
.L1704:
    movaps xmm0, xmm6
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm9
    subsd xmm0, xmm1
    jmp .__ret_1694
.__ret_1694:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    movups xmm9, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fround.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl677,115
    dq .kl678,118
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
.flt1709: dq 0.0
section .text
    movsd xmm0, [rel .flt1709]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setbe al
    movzx rax, al
    test rax, rax
    jz .L1707
section .data
.flt1710: dq 0.0
section .text
    movsd xmm0, [rel .flt1710]
    jmp .__ret_1706
    jmp .L1708
.L1707:
.L1708:
    mov rax, 0
    cmp rax, 1
    jb .L1711
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl679:
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1706
.L1711:
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
    jb .L1712
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl680:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1706
.L1712:
    mov rcx, rax
    lea rdx, [rbp-16]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L1713:
    cmp rbx, 6
    jge .L1714
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1716: dq 0.5
section .text
    movsd xmm0, [rel .flt1716]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
.L1715:
    add rbx, 1
    jmp .L1713
.L1714:
    movaps xmm0, xmm6
    jmp .__ret_1706
.__ret_1706:
    mov rbx, [rbp-96]
    movups xmm6, [rbp-88]
    movups xmm7, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fmod.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl679,136
    dq .kl680,141
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
.kl681:
    call fsqrt
    add rsp, 32
    jmp .__ret_1717
.__ret_1717:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fsqrt.kft, .kfe, .kfn, __kron_file_6,1
    dq .kl681,150
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
.kl682:
    call fsqrt
    add rsp, 32
    jmp .__ret_1718
.__ret_1718:
    movups xmm6, [rbp-80]
    movups xmm7, [rbp-64]
    movups xmm8, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq flen2.kft, .kfe, .kfn, __kron_file_6,1
    dq .kl682,155
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
.flt1720: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt1720]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl683:
    call fmod
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1723: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt1723]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L1721
section .data
.flt1724: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt1724]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L1722
.L1721:
.L1722:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1727: dq 0.0
section .text
    movsd xmm0, [rel .flt1727]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1728: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt1728]
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
    jz .L1725
section .data
.flt1729: dq 6.28318530717958647692
section .text
    movsd xmm0, [rel .flt1729]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L1726
.L1725:
.L1726:
    movaps xmm0, xmm6
    jmp .__ret_1719
.__ret_1719:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq flen3.kft, .kfe, .kfn, __kron_file_6,1
    dq .kl683,162
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
.kl684:
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
.flt1731: dq 0.0
section .text
    movsd xmm0, [rel .flt1731]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1732: dq 6.0
section .text
    movsd xmm0, [rel .flt1732]
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
.flt1733: dq 0.0
section .text
    movsd xmm0, [rel .flt1733]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1734: dq 20.0
section .text
    movsd xmm0, [rel .flt1734]
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
.flt1735: dq 0.0
section .text
    movsd xmm0, [rel .flt1735]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1736: dq 42.0
section .text
    movsd xmm0, [rel .flt1736]
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
.flt1737: dq 0.0
section .text
    movsd xmm0, [rel .flt1737]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1738: dq 72.0
section .text
    movsd xmm0, [rel .flt1738]
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
.flt1739: dq 0.0
section .text
    movsd xmm0, [rel .flt1739]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1740: dq 110.0
section .text
    movsd xmm0, [rel .flt1740]
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
.flt1741: dq 0.0
section .text
    movsd xmm0, [rel .flt1741]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1742: dq 156.0
section .text
    movsd xmm0, [rel .flt1742]
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
.flt1743: dq 0.0
section .text
    movsd xmm0, [rel .flt1743]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1744: dq 210.0
section .text
    movsd xmm0, [rel .flt1744]
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
.flt1745: dq 0.0
section .text
    movsd xmm0, [rel .flt1745]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1746: dq 272.0
section .text
    movsd xmm0, [rel .flt1746]
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
.flt1747: dq 0.0
section .text
    movsd xmm0, [rel .flt1747]
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1748: dq 342.0
section .text
    movsd xmm0, [rel .flt1748]
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
    jmp .__ret_1730
.__ret_1730:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    movups xmm8, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fwrap_angle.kft, .kfe, .kfn, __kron_file_6,1
    dq .kl684,175
.kfn: db "fsin", 0
section .text
fcos:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
section .data
.flt1750: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt1750]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl685:
    call fsin
    add rsp, 32
    jmp .__ret_1749
.__ret_1749:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fsin.kft, .kfe, .kfn, __kron_file_6,1
    dq .kl685,202
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
.kl686:
    call fcos
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1754: dq 0.0
section .text
    movsd xmm0, [rel .flt1754]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L1752
section .data
.flt1755: dq 0.0
section .text
    movsd xmm0, [rel .flt1755]
    jmp .__ret_1751
    jmp .L1753
.L1752:
.L1753:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl687:
    call fsin
    add rsp, 32
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    jmp .__ret_1751
.__ret_1751:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fcos.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl686,206
    dq .kl687,210
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
.flt1757: dq 1.0
section .text
    movsd xmm0, [rel .flt1757]
    movaps xmm9, xmm0
    movaps xmm0, xmm6
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1760: dq 0.0
section .text
    movsd xmm0, [rel .flt1760]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1758
section .data
.flt1761: dq 0.0
section .text
    movsd xmm0, [rel .flt1761]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1762: dq 1.0
section .text
    movsd xmm0, [rel .flt1762]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm9, xmm0
section .data
.flt1763: dq 0.0
section .text
    movsd xmm0, [rel .flt1763]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L1759
.L1758:
.L1759:
section .data
.flt1764: dq 1.0
section .text
    movsd xmm0, [rel .flt1764]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1765: dq 1.0
section .text
    movsd xmm0, [rel .flt1765]
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
.kl688:
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
.flt1766: dq 1.0
section .text
    movsd xmm0, [rel .flt1766]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1767: dq 1.0
section .text
    movsd xmm0, [rel .flt1767]
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
.kl689:
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
.L1768:
    cmp rbx, 12
    jge .L1769
section .data
.flt1771: dq 0.0
section .text
    movsd xmm0, [rel .flt1771]
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
.L1770:
    add rbx, 1
    jmp .L1768
.L1769:
section .data
.flt1772: dq 4.0
section .text
    movsd xmm0, [rel .flt1772]
    movaps xmm1, xmm0
    movaps xmm0, xmm9
    mulsd xmm0, xmm1
    movaps xmm1, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_1756
.__ret_1756:
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
.kft: dq ftan.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl688,223
    dq .kl689,224
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
.flt1776: dq 0.0
section .text
    movsd xmm0, [rel .flt1776]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L1774
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl690:
    call fatan
    add rsp, 32
    jmp .__ret_1773
    jmp .L1775
.L1774:
.L1775:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1779: dq 0.0
section .text
    movsd xmm0, [rel .flt1779]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1777
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1782: dq 0.0
section .text
    movsd xmm0, [rel .flt1782]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setae al
    movzx rax, al
    test rax, rax
    jz .L1780
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl691:
    call fatan
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1783: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt1783]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_1773
    jmp .L1781
.L1780:
.L1781:
    movaps xmm0, xmm7
    movaps xmm1, xmm6
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl692:
    call fatan
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1784: dq 3.14159265358979323846
section .text
    movsd xmm0, [rel .flt1784]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_1773
    jmp .L1778
.L1777:
.L1778:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1787: dq 0.0
section .text
    movsd xmm0, [rel .flt1787]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L1785
section .data
.flt1788: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt1788]
    jmp .__ret_1773
    jmp .L1786
.L1785:
.L1786:
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1791: dq 0.0
section .text
    movsd xmm0, [rel .flt1791]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L1789
section .data
.flt1792: dq 0.0
section .text
    movsd xmm0, [rel .flt1792]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1793: dq 1.57079632679489661923
section .text
    movsd xmm0, [rel .flt1793]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    jmp .__ret_1773
    jmp .L1790
.L1789:
.L1790:
section .data
.flt1794: dq 0.0
section .text
    movsd xmm0, [rel .flt1794]
    jmp .__ret_1773
.__ret_1773:
    movups xmm6, [rbp-48]
    movups xmm7, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fatan.kft, .kfe, .kfn, __kron_file_6,3
    dq .kl690,238
    dq .kl691,242
    dq .kl692,244
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
.flt1796: dq 0.0
section .text
    movsd xmm0, [rel .flt1796]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1797: dq 1.0
section .text
    movsd xmm0, [rel .flt1797]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1798: dq 1.0
section .text
    movsd xmm0, [rel .flt1798]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl693:
    call fclamp
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1799: dq 1.0
section .text
    movsd xmm0, [rel .flt1799]
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
.kl694:
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
    jmp .__ret_1795
.__ret_1795:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fatan2.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl693,257
    dq .kl694,258
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
.flt1801: dq 0.0
section .text
    movsd xmm0, [rel .flt1801]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1802: dq 1.0
section .text
    movsd xmm0, [rel .flt1802]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt1803: dq 1.0
section .text
    movsd xmm0, [rel .flt1803]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl695:
    call fclamp
    add rsp, 32
    movaps xmm6, xmm0
section .data
.flt1804: dq 1.0
section .text
    movsd xmm0, [rel .flt1804]
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
.kl696:
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
    jmp .__ret_1800
.__ret_1800:
    movups xmm6, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq fasin.kft, .kfe, .kfn, __kron_file_6,2
    dq .kl695,262
    dq .kl696,263
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
.flt1806: dq 1.0
section .text
    movsd xmm0, [rel .flt1806]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L1807:
    cmp rbx, r12
    jge .L1808
    movaps xmm0, xmm6
    movaps xmm1, xmm7
    mulsd xmm0, xmm1
    movaps xmm6, xmm0
.L1809:
    add rbx, 1
    jmp .L1807
.L1808:
    movaps xmm0, xmm6
    jmp .__ret_1805
.__ret_1805:
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
.flt1811: dq 0.01745329251994329577
section .text
    movsd xmm0, [rel .flt1811]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_1810
.__ret_1810:
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
.flt1813: dq 57.29577951308232087680
section .text
    movsd xmm0, [rel .flt1813]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_1812
.__ret_1812:
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
    jmp .__ret_1814
.__ret_1814:
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
    jmp .__ret_1815
.__ret_1815:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    movups xmm9, [rbp-96]
    movups xmm10, [rbp-80]
    movups xmm11, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_OB_IMAGE: dq 5
section .text
section .data
__g_im_src: dq 0
section .text
section .data
__g_im_src_n: dq 0
section .text
section .data
__g_im_pos: dq 0
section .text
section .data
__g_im_bit: dq 0
section .text
section .data
__g_im_nbit: dq 0
section .text
section .data
__g_im_out: dq 0
section .text
section .data
__g_im_out_n: dq 0
section .text
section .data
__g_im_out_cap: dq 0
section .text
section .data
__g_im_bad: dq 0
section .text
section .bss
__g_im_lcount: resq 16
section .text
section .bss
__g_im_lsym: resq 320
section .text
section .bss
__g_im_dcount: resq 16
section .text
section .bss
__g_im_dsym: resq 32
section .text
section .bss
__g_im_lens: resq 320
section .text
section .bss
__g_im_lbase: resq 29
section .text
section .bss
__g_im_lextra: resq 29
section .text
section .bss
__g_im_dbase: resq 30
section .text
section .bss
__g_im_dextra: resq 30
section .text
section .data
__g_im_tables: dq 0
section .text
section .bss
__g_im_pal: resq 256
section .text
section .data
__g_im_key: dq 0
section .text
im_new:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rbx, rdx
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L1823
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L1823
    mov rax, 0
    jmp .L1824
.L1823:
    mov rax, 1
.L1824:
    test rax, rax
    jnz .L1821
    mov rax, r13
    mov rcx, 32768
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1821
    mov rax, 0
    jmp .L1822
.L1821:
    mov rax, 1
.L1822:
    test rax, rax
    jnz .L1819
    mov rax, rbx
    mov rcx, 32768
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1819
    mov rax, 0
    jmp .L1820
.L1819:
    mov rax, 1
.L1820:
    test rax, rax
    jz .L1817
    mov rax, 1
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_1816
    jmp .L1818
.L1817:
.L1818:
    mov rax, r13
    imul rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, 16
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl697:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1825
    mov rax, 0
    jmp .__ret_1816
    jmp .L1826
.L1825:
.L1826:
    mov rax, r12
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_OB_IMAGE]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl698:
    call ob_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1827
    mov rcx, r12
    sub rsp, 32
.kl699:
    call hp_release
    add rsp, 32
    jmp .L1828
.L1827:
.L1828:
    mov rax, rbx
    jmp .__ret_1816
.__ret_1816:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq facos.kft, .kfe, .kfn, __kron_file_7,3
    dq .kl697,64
    dq .kl698,72
    dq .kl699,74
.kfn: db "im_new", 0
section .text
im_block:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_IMAGE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl700:
    call ob_get
    add rsp, 32
    jmp .__ret_1829
.__ret_1829:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_new.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl700,80
.kfn: db "im_block", 0
section .text
im_tables_once:
    push rbp
    mov rbp, rsp
    sub rsp, 1008
    mov [rbp-976], rbx
    mov rax, [rel __g_im_tables]
    test rax, rax
    jz .L1831
    mov rax, 1
    jmp .__ret_1830
    jmp .L1832
.L1831:
.L1832:
    mov rax, 3
    mov [rbp-232], rax
    mov rax, 4
    mov [rbp-224], rax
    mov rax, 5
    mov [rbp-216], rax
    mov rax, 6
    mov [rbp-208], rax
    mov rax, 7
    mov [rbp-200], rax
    mov rax, 8
    mov [rbp-192], rax
    mov rax, 9
    mov [rbp-184], rax
    mov rax, 10
    mov [rbp-176], rax
    mov rax, 11
    mov [rbp-168], rax
    mov rax, 13
    mov [rbp-160], rax
    mov rax, 15
    mov [rbp-152], rax
    mov rax, 17
    mov [rbp-144], rax
    mov rax, 19
    mov [rbp-136], rax
    mov rax, 23
    mov [rbp-128], rax
    mov rax, 27
    mov [rbp-120], rax
    mov rax, 31
    mov [rbp-112], rax
    mov rax, 35
    mov [rbp-104], rax
    mov rax, 43
    mov [rbp-96], rax
    mov rax, 51
    mov [rbp-88], rax
    mov rax, 59
    mov [rbp-80], rax
    mov rax, 67
    mov [rbp-72], rax
    mov rax, 83
    mov [rbp-64], rax
    mov rax, 99
    mov [rbp-56], rax
    mov rax, 115
    mov [rbp-48], rax
    mov rax, 131
    mov [rbp-40], rax
    mov rax, 163
    mov [rbp-32], rax
    mov rax, 195
    mov [rbp-24], rax
    mov rax, 227
    mov [rbp-16], rax
    mov rax, 258
    mov [rbp-8], rax
    mov rax, 0
    mov [rbp-464], rax
    mov rax, 0
    mov [rbp-456], rax
    mov rax, 0
    mov [rbp-448], rax
    mov rax, 0
    mov [rbp-440], rax
    mov rax, 0
    mov [rbp-432], rax
    mov rax, 0
    mov [rbp-424], rax
    mov rax, 0
    mov [rbp-416], rax
    mov rax, 0
    mov [rbp-408], rax
    mov rax, 1
    mov [rbp-400], rax
    mov rax, 1
    mov [rbp-392], rax
    mov rax, 1
    mov [rbp-384], rax
    mov rax, 1
    mov [rbp-376], rax
    mov rax, 2
    mov [rbp-368], rax
    mov rax, 2
    mov [rbp-360], rax
    mov rax, 2
    mov [rbp-352], rax
    mov rax, 2
    mov [rbp-344], rax
    mov rax, 3
    mov [rbp-336], rax
    mov rax, 3
    mov [rbp-328], rax
    mov rax, 3
    mov [rbp-320], rax
    mov rax, 3
    mov [rbp-312], rax
    mov rax, 4
    mov [rbp-304], rax
    mov rax, 4
    mov [rbp-296], rax
    mov rax, 4
    mov [rbp-288], rax
    mov rax, 4
    mov [rbp-280], rax
    mov rax, 5
    mov [rbp-272], rax
    mov rax, 5
    mov [rbp-264], rax
    mov rax, 5
    mov [rbp-256], rax
    mov rax, 5
    mov [rbp-248], rax
    mov rax, 0
    mov [rbp-240], rax
    mov rax, 1
    mov [rbp-704], rax
    mov rax, 2
    mov [rbp-696], rax
    mov rax, 3
    mov [rbp-688], rax
    mov rax, 4
    mov [rbp-680], rax
    mov rax, 5
    mov [rbp-672], rax
    mov rax, 7
    mov [rbp-664], rax
    mov rax, 9
    mov [rbp-656], rax
    mov rax, 13
    mov [rbp-648], rax
    mov rax, 17
    mov [rbp-640], rax
    mov rax, 25
    mov [rbp-632], rax
    mov rax, 33
    mov [rbp-624], rax
    mov rax, 49
    mov [rbp-616], rax
    mov rax, 65
    mov [rbp-608], rax
    mov rax, 97
    mov [rbp-600], rax
    mov rax, 129
    mov [rbp-592], rax
    mov rax, 193
    mov [rbp-584], rax
    mov rax, 257
    mov [rbp-576], rax
    mov rax, 385
    mov [rbp-568], rax
    mov rax, 513
    mov [rbp-560], rax
    mov rax, 769
    mov [rbp-552], rax
    mov rax, 1025
    mov [rbp-544], rax
    mov rax, 1537
    mov [rbp-536], rax
    mov rax, 2049
    mov [rbp-528], rax
    mov rax, 3073
    mov [rbp-520], rax
    mov rax, 4097
    mov [rbp-512], rax
    mov rax, 6145
    mov [rbp-504], rax
    mov rax, 8193
    mov [rbp-496], rax
    mov rax, 12289
    mov [rbp-488], rax
    mov rax, 16385
    mov [rbp-480], rax
    mov rax, 24577
    mov [rbp-472], rax
    mov rax, 0
    mov [rbp-944], rax
    mov rax, 0
    mov [rbp-936], rax
    mov rax, 0
    mov [rbp-928], rax
    mov rax, 0
    mov [rbp-920], rax
    mov rax, 1
    mov [rbp-912], rax
    mov rax, 1
    mov [rbp-904], rax
    mov rax, 2
    mov [rbp-896], rax
    mov rax, 2
    mov [rbp-888], rax
    mov rax, 3
    mov [rbp-880], rax
    mov rax, 3
    mov [rbp-872], rax
    mov rax, 4
    mov [rbp-864], rax
    mov rax, 4
    mov [rbp-856], rax
    mov rax, 5
    mov [rbp-848], rax
    mov rax, 5
    mov [rbp-840], rax
    mov rax, 6
    mov [rbp-832], rax
    mov rax, 6
    mov [rbp-824], rax
    mov rax, 7
    mov [rbp-816], rax
    mov rax, 7
    mov [rbp-808], rax
    mov rax, 8
    mov [rbp-800], rax
    mov rax, 8
    mov [rbp-792], rax
    mov rax, 9
    mov [rbp-784], rax
    mov rax, 9
    mov [rbp-776], rax
    mov rax, 10
    mov [rbp-768], rax
    mov rax, 10
    mov [rbp-760], rax
    mov rax, 11
    mov [rbp-752], rax
    mov rax, 11
    mov [rbp-744], rax
    mov rax, 12
    mov [rbp-736], rax
    mov rax, 12
    mov [rbp-728], rax
    mov rax, 13
    mov [rbp-720], rax
    mov rax, 13
    mov [rbp-712], rax
    mov rax, 0
    mov rbx, rax
.L1833:
    cmp rbx, 29
    jge .L1834
    mov rax, rbx
    cmp rax, 29
    jb .L1836
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl701:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1836:
    push rax
    mov rax, rbx
    cmp rax, 29
    jb .L1837
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1837:
    mov rcx, rax
    lea rdx, [rbp-232]
    mov rax, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_im_lbase]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 29
    jb .L1838
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl702:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1838:
    push rax
    mov rax, rbx
    cmp rax, 29
    jb .L1839
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1839:
    mov rcx, rax
    lea rdx, [rbp-464]
    mov rax, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_im_lextra]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L1835:
    jmp .L1833
.L1834:
    mov rax, 0
    mov rbx, rax
.L1840:
    cmp rbx, 30
    jge .L1841
    mov rax, rbx
    cmp rax, 30
    jb .L1843
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl703:
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1843:
    push rax
    mov rax, rbx
    cmp rax, 30
    jb .L1844
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1844:
    mov rcx, rax
    lea rdx, [rbp-704]
    mov rax, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_im_dbase]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 30
    jb .L1845
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl704:
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1845:
    push rax
    mov rax, rbx
    cmp rax, 30
    jb .L1846
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1830
.L1846:
    mov rcx, rax
    lea rdx, [rbp-944]
    mov rax, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_im_dextra]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L1842:
    jmp .L1840
.L1841:
    mov rax, 1
    mov [rel __g_im_tables], rax
    mov rax, 1
    jmp .__ret_1830
.__ret_1830:
    mov rbx, [rbp-976]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_block.kft, .kfe, .kfn, __kron_file_7,4
    dq .kl701,95
    dq .kl702,96
    dq .kl703,101
    dq .kl704,102
.kfn: db "im_tables_once", 0
section .text
im_bits:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
.L1848:
    mov rax, [rel __g_im_nbit]
    cmp rax, r12
    jge .L1849
    mov rax, [rel __g_im_pos]
    push rax
    mov rax, [rel __g_im_src_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1851
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1847
    jmp .L1852
.L1851:
.L1852:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_im_src]
    push rax
    mov rax, [rel __g_im_pos]
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, [rel __g_im_pos]
    add rax, 1
    mov [rel __g_im_pos], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_im_nbit]
    mov rcx, rax
    pop rax
    shl rax, cl
    mov rcx, rax
    mov rax, [rel __g_im_bit]
    or rax, rcx
    mov [rel __g_im_bit], rax
    mov rax, [rel __g_im_nbit]
    add rax, 8
    mov [rel __g_im_nbit], rax
.L1850:
    jmp .L1848
.L1849:
    mov rax, 1
    mov rcx, r12
    shl rax, cl
    sub rax, 1
    mov rcx, rax
    mov rax, [rel __g_im_bit]
    and rax, rcx
    mov rbx, rax
    mov rax, [rel __g_im_bit]
    mov rcx, r12
    sar rax, cl
    mov [rel __g_im_bit], rax
    mov rax, [rel __g_im_nbit]
    sub rax, r12
    mov [rel __g_im_nbit], rax
    mov rax, rbx
    jmp .__ret_1847
.__ret_1847:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
im_put:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_im_out_n]
    push rax
    mov rax, [rel __g_im_out_cap]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1854
    mov rax, [rel __g_im_out_cap]
    mov rcx, 2
    imul rax, rcx
    mov r12, rax
    cmp r12, 65536
    jge .L1856
    mov rax, 65536
    mov r12, rax
    jmp .L1857
.L1856:
.L1857:
    mov rax, [rel __g_im_out]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl705:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L1858
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1853
    jmp .L1859
.L1858:
.L1859:
    mov rax, rbx
    mov [rel __g_im_out], rax
    mov rax, r12
    mov [rel __g_im_out_cap], rax
    jmp .L1855
.L1854:
.L1855:
    mov rax, [rel __g_im_out]
    push rax
    mov rax, [rel __g_im_out_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rel __g_im_out_n]
    add rax, 1
    mov [rel __g_im_out_n], rax
    mov rax, 1
    jmp .__ret_1853
.__ret_1853:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_tables_once.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl705,134
.kfn: db "im_put", 0
section .text
im_build:
    push rbp
    mov rbp, rsp
    sub rsp, 240
    mov [rbp-208], rbx
    mov [rbp-200], r12
    mov [rbp-192], r13
    mov [rbp-184], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
.L1861:
    cmp r12, 16
    jge .L1862
    cmp r14, 0
    jne .L1864
    mov rax, r12
    cmp rax, 16
    jb .L1866
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl706:
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1866:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_im_lcount]
    mov [rdx+rcx*8], rax
    jmp .L1865
.L1864:
    mov rax, r12
    cmp rax, 16
    jb .L1867
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl707:
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1867:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_im_dcount]
    mov [rdx+rcx*8], rax
.L1865:
    add r12, 1
.L1863:
    jmp .L1861
.L1862:
    mov rax, 0
    mov r12, rax
.L1868:
    cmp r12, r13
    jge .L1869
    mov rax, r12
    cmp rax, 320
    jb .L1871
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl708:
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1871:
    mov rcx, rax
    lea rdx, [rel __g_im_lens]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    cmp r14, 0
    jne .L1872
    mov rax, rbx
    cmp rax, 16
    jb .L1874
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl709:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1874:
    push rax
    mov rax, rbx
    cmp rax, 16
    jb .L1875
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1875:
    mov rcx, rax
    lea rdx, [rel __g_im_lcount]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_im_lcount]
    mov [rdx+rcx*8], rax
    jmp .L1873
.L1872:
    mov rax, rbx
    cmp rax, 16
    jb .L1876
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl710:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1876:
    push rax
    mov rax, rbx
    cmp rax, 16
    jb .L1877
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1877:
    mov rcx, rax
    lea rdx, [rel __g_im_dcount]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_im_dcount]
    mov [rdx+rcx*8], rax
.L1873:
    add r12, 1
.L1870:
    jmp .L1868
.L1869:
    mov rax, 1
    cmp rax, 16
    jb .L1878
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl711:
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1878:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-144]
    mov [rdx+rcx*8], rax
    mov rax, 1
    mov r12, rax
.L1879:
    cmp r12, 15
    jge .L1880
    cmp r14, 0
    jne .L1882
    mov rax, r12
    add rax, 1
    cmp rax, 16
    jb .L1884
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl712:
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1884:
    push rax
    mov rax, r12
    cmp rax, 16
    jb .L1885
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1885:
    mov rcx, rax
    lea rdx, [rbp-144]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r12
    cmp rax, 16
    jb .L1886
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1886:
    mov rcx, rax
    lea rdx, [rel __g_im_lcount]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    pop rcx
    lea rdx, [rbp-144]
    mov [rdx+rcx*8], rax
    jmp .L1883
.L1882:
    mov rax, r12
    add rax, 1
    cmp rax, 16
    jb .L1887
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl713:
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1887:
    push rax
    mov rax, r12
    cmp rax, 16
    jb .L1888
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1888:
    mov rcx, rax
    lea rdx, [rbp-144]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r12
    cmp rax, 16
    jb .L1889
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1889:
    mov rcx, rax
    lea rdx, [rel __g_im_dcount]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    pop rcx
    lea rdx, [rbp-144]
    mov [rdx+rcx*8], rax
.L1883:
    add r12, 1
.L1881:
    jmp .L1879
.L1880:
    mov rax, 0
    mov r12, rax
.L1890:
    cmp r12, r13
    jge .L1891
    mov rax, r12
    cmp rax, 320
    jb .L1893
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl714:
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1893:
    mov rcx, rax
    lea rdx, [rel __g_im_lens]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    cmp rbx, 0
    je .L1894
    cmp r14, 0
    jne .L1896
    mov rax, rbx
    cmp rax, 16
    jb .L1898
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl715:
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1898:
    mov rcx, rax
    lea rdx, [rbp-144]
    mov rax, [rdx+rcx*8]
    cmp rax, 320
    jb .L1899
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx49]
    call __fail_raise
.kx49:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1899:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rel __g_im_lsym]
    mov [rdx+rcx*8], rax
    jmp .L1897
.L1896:
    mov rax, rbx
    cmp rax, 16
    jb .L1900
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl716:
    lea r8, [rel .kx50]
    call __fail_raise
.kx50:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1900:
    mov rcx, rax
    lea rdx, [rbp-144]
    mov rax, [rdx+rcx*8]
    cmp rax, 32
    jb .L1901
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx51]
    call __fail_raise
.kx51:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1901:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rel __g_im_dsym]
    mov [rdx+rcx*8], rax
.L1897:
    mov rax, rbx
    cmp rax, 16
    jb .L1902
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl717:
    lea r8, [rel .kx52]
    call __fail_raise
.kx52:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1902:
    push rax
    mov rax, rbx
    cmp rax, 16
    jb .L1903
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx53]
    call __fail_raise
.kx53:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1860
.L1903:
    mov rcx, rax
    lea rdx, [rbp-144]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rbp-144]
    mov [rdx+rcx*8], rax
    jmp .L1895
.L1894:
.L1895:
    add r12, 1
.L1892:
    jmp .L1890
.L1891:
    mov rax, 1
    jmp .__ret_1860
.__ret_1860:
    mov rbx, [rbp-208]
    mov r12, [rbp-200]
    mov r13, [rbp-192]
    mov r14, [rbp-184]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_put.kft, .kfe, .kfn, __kron_file_7,12
    dq .kl706,154
    dq .kl707,156
    dq .kl708,162
    dq .kl709,164
    dq .kl710,166
    dq .kl711,170
    dq .kl712,174
    dq .kl713,176
    dq .kl714,182
    dq .kl715,185
    dq .kl716,187
    dq .kl717,189
.kfn: db "im_build", 0
section .text
im_decode:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov [rbp-8], rcx
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov r12, rax
.L1905:
    cmp r12, 16
    jge .L1906
    mov rax, r15
    push rax
    mov rcx, 1
    sub rsp, 32
.kl718:
    call im_bits
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r15, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L1908
    mov rax, r12
    cmp rax, 16
    jb .L1910
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl719:
    lea r8, [rel .kx54]
    call __fail_raise
.kx54:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1904
.L1910:
    mov rcx, rax
    lea rdx, [rel __g_im_lcount]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    jmp .L1909
.L1908:
    mov rax, r12
    cmp rax, 16
    jb .L1911
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl720:
    lea r8, [rel .kx55]
    call __fail_raise
.kx55:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1904
.L1911:
    mov rcx, rax
    lea rdx, [rel __g_im_dcount]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
.L1909:
    mov rax, r15
    sub rax, rbx
    cmp rax, r14
    jge .L1912
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L1914
    mov rax, r15
    sub rax, r14
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    cmp rax, 320
    jb .L1916
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl721:
    lea r8, [rel .kx56]
    call __fail_raise
.kx56:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1904
.L1916:
    mov rcx, rax
    lea rdx, [rel __g_im_lsym]
    mov rax, [rdx+rcx*8]
    jmp .__ret_1904
    jmp .L1915
.L1914:
.L1915:
    mov rax, r15
    sub rax, r14
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    cmp rax, 32
    jb .L1917
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl722:
    lea r8, [rel .kx57]
    call __fail_raise
.kx57:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1904
.L1917:
    mov rcx, rax
    lea rdx, [rel __g_im_dsym]
    mov rax, [rdx+rcx*8]
    jmp .__ret_1904
    jmp .L1913
.L1912:
.L1913:
    add r13, rbx
    add r14, rbx
    mov rax, r14
    shl rax, 1
    mov r14, rax
    mov rax, r15
    shl rax, 1
    mov r15, rax
    add r12, 1
    mov rax, [rel __g_im_bad]
    test rax, rax
    jz .L1918
    mov rax, 0
    jmp .__ret_1904
    jmp .L1919
.L1918:
.L1919:
.L1907:
    jmp .L1905
.L1906:
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1904
.__ret_1904:
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
.kft: dq im_build.kft, .kfe, .kfn, __kron_file_7,5
    dq .kl718,202
    dq .kl719,205
    dq .kl720,207
    dq .kl721,211
    dq .kl722,213
.kfn: db "im_decode", 0
section .text
im_codes:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rax, 0
    mov rbx, rax
.L1921:
    mov rax, [rel __g_im_bad]
    cmp rax, 0
    jne .L1922
    mov rcx, 0
    sub rsp, 32
.kl723:
    call im_decode
    add rsp, 32
    mov rbx, rax
    cmp rbx, 256
    jge .L1924
    mov rcx, rbx
    sub rsp, 32
.kl724:
    call im_put
    add rsp, 32
    jmp .L1925
.L1924:
    cmp rbx, 256
    jne .L1926
    mov rax, 1
    jmp .__ret_1920
    jmp .L1927
.L1926:
    sub rbx, 257
    cmp rbx, 29
    jl .L1928
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1920
    jmp .L1929
.L1928:
.L1929:
    mov rax, rbx
    cmp rax, 29
    jb .L1930
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl725:
    lea r8, [rel .kx58]
    call __fail_raise
.kx58:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1920
.L1930:
    mov rcx, rax
    lea rdx, [rel __g_im_lbase]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, rbx
    cmp rax, 29
    jb .L1931
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx59]
    call __fail_raise
.kx59:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1920
.L1931:
    mov rcx, rax
    lea rdx, [rel __g_im_lextra]
    mov rax, [rdx+rcx*8]
    push rax
    pop rcx
    sub rsp, 32
    call im_bits
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rcx, 1
    sub rsp, 32
.kl726:
    call im_decode
    add rsp, 32
    mov rbx, rax
    cmp rbx, 30
    jl .L1932
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1920
    jmp .L1933
.L1932:
.L1933:
    mov rax, rbx
    cmp rax, 30
    jb .L1934
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl727:
    lea r8, [rel .kx60]
    call __fail_raise
.kx60:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1920
.L1934:
    mov rcx, rax
    lea rdx, [rel __g_im_dbase]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, rbx
    cmp rax, 30
    jb .L1935
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx61]
    call __fail_raise
.kx61:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1920
.L1935:
    mov rcx, rax
    lea rdx, [rel __g_im_dextra]
    mov rax, [rdx+rcx*8]
    push rax
    pop rcx
    sub rsp, 32
    call im_bits
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_im_out_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L1936
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1920
    jmp .L1937
.L1936:
.L1937:
    mov rax, 0
    mov r12, rax
.L1938:
    cmp r12, r14
    jge .L1939
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_im_out]
    push rax
    mov rax, [rel __g_im_out_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl728:
    call im_put
    add rsp, 32
    add r12, 1
.L1940:
    jmp .L1938
.L1939:
.L1927:
.L1925:
.L1923:
    jmp .L1921
.L1922:
    mov rax, 0
    jmp .__ret_1920
.__ret_1920:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_decode.kft, .kfe, .kfn, __kron_file_7,6
    dq .kl723,231
    dq .kl724,233
    dq .kl725,242
    dq .kl726,243
    dq .kl727,248
    dq .kl728,257
.kfn: db "im_codes", 0
section .text
im_fixed:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, 0
    mov r12, rax
.L1942:
    cmp r12, 288
    jge .L1943
    mov rax, 8
    mov rbx, rax
    mov rax, r12
    mov rcx, 144
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1947
    mov rax, r12
    mov rcx, 256
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1947
    mov rax, 1
    jmp .L1948
.L1947:
    mov rax, 0
.L1948:
    test rax, rax
    jz .L1945
    mov rax, 9
    mov rbx, rax
    jmp .L1946
.L1945:
    mov rax, r12
    mov rcx, 256
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L1951
    mov rax, r12
    mov rcx, 280
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1951
    mov rax, 1
    jmp .L1952
.L1951:
    mov rax, 0
.L1952:
    test rax, rax
    jz .L1949
    mov rax, 7
    mov rbx, rax
    jmp .L1950
.L1949:
.L1950:
.L1946:
    mov rax, r12
    cmp rax, 320
    jb .L1953
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl729:
    lea r8, [rel .kx62]
    call __fail_raise
.kx62:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1941
.L1953:
    push rax
    mov rax, rbx
    pop rcx
    lea rdx, [rel __g_im_lens]
    mov [rdx+rcx*8], rax
    add r12, 1
.L1944:
    jmp .L1942
.L1943:
    mov rcx, 0
    mov rdx, 288
    sub rsp, 32
.kl730:
    call im_build
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L1954:
    cmp r12, 30
    jge .L1955
    mov rax, r12
    cmp rax, 320
    jb .L1957
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl731:
    lea r8, [rel .kx63]
    call __fail_raise
.kx63:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1941
.L1957:
    push rax
    mov rax, 5
    pop rcx
    lea rdx, [rel __g_im_lens]
    mov [rdx+rcx*8], rax
    add r12, 1
.L1956:
    jmp .L1954
.L1955:
    mov rcx, 1
    mov rdx, 30
    sub rsp, 32
.kl732:
    call im_build
    add rsp, 32
    sub rsp, 32
.kl733:
    call im_codes
    add rsp, 32
    jmp .__ret_1941
.__ret_1941:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_codes.kft, .kfe, .kfn, __kron_file_7,5
    dq .kl729,274
    dq .kl730,277
    dq .kl731,280
    dq .kl732,283
    dq .kl733,284
.kfn: db "im_fixed", 0
section .text
im_dynamic:
    push rbp
    mov rbp, rsp
    sub rsp, 2864
    mov [rbp-2832], rbx
    mov [rbp-2824], r12
    mov [rbp-2816], r13
    mov [rbp-2808], r14
    mov [rbp-2800], r15
    mov rcx, 5
    sub rsp, 32
.kl734:
    call im_bits
    add rsp, 32
    add rax, 257
    mov r15, rax
    mov rcx, 5
    sub rsp, 32
.kl735:
    call im_bits
    add rsp, 32
    add rax, 1
    mov r14, rax
    mov rcx, 4
    sub rsp, 32
.kl736:
    call im_bits
    add rsp, 32
    add rax, 4
    mov r12, rax
    mov rax, r15
    mov rcx, 286
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1961
    mov rax, r14
    mov rcx, 30
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L1961
    mov rax, 0
    jmp .L1962
.L1961:
    mov rax, 1
.L1962:
    test rax, rax
    jz .L1959
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1958
    jmp .L1960
.L1959:
.L1960:
    mov rax, 16
    mov [rbp-176], rax
    mov rax, 17
    mov [rbp-168], rax
    mov rax, 18
    mov [rbp-160], rax
    mov rax, 0
    mov [rbp-152], rax
    mov rax, 8
    mov [rbp-144], rax
    mov rax, 7
    mov [rbp-136], rax
    mov rax, 9
    mov [rbp-128], rax
    mov rax, 6
    mov [rbp-120], rax
    mov rax, 10
    mov [rbp-112], rax
    mov rax, 5
    mov [rbp-104], rax
    mov rax, 11
    mov [rbp-96], rax
    mov rax, 4
    mov [rbp-88], rax
    mov rax, 12
    mov [rbp-80], rax
    mov rax, 3
    mov [rbp-72], rax
    mov rax, 13
    mov [rbp-64], rax
    mov rax, 2
    mov [rbp-56], rax
    mov rax, 14
    mov [rbp-48], rax
    mov rax, 1
    mov [rbp-40], rax
    mov rax, 15
    mov [rbp-32], rax
    mov rax, 0
    mov rbx, rax
.L1963:
    cmp rbx, 19
    jge .L1964
    mov rax, rbx
    cmp rax, 19
    jb .L1966
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl737:
    lea r8, [rel .kx64]
    call __fail_raise
.kx64:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1966:
    mov rcx, rax
    lea rdx, [rbp-176]
    mov rax, [rdx+rcx*8]
    cmp rax, 320
    jb .L1967
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx65]
    call __fail_raise
.kx65:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1967:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_im_lens]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L1965:
    jmp .L1963
.L1964:
    mov rax, 0
    mov rbx, rax
.L1968:
    cmp rbx, r12
    jge .L1969
    mov rax, rbx
    cmp rax, 19
    jb .L1971
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl738:
    lea r8, [rel .kx66]
    call __fail_raise
.kx66:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1971:
    mov rcx, rax
    lea rdx, [rbp-176]
    mov rax, [rdx+rcx*8]
    cmp rax, 320
    jb .L1972
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx67]
    call __fail_raise
.kx67:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1972:
    push rax
    mov rcx, 3
    sub rsp, 32
    call im_bits
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_im_lens]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L1970:
    jmp .L1968
.L1969:
    mov rcx, 0
    mov rdx, 19
    sub rsp, 32
.kl739:
    call im_build
    add rsp, 32
    mov rax, 0
    mov r13, rax
.L1973:
    mov rax, r15
    add rax, r14
    mov rcx, rax
    mov rax, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1976
    mov rax, [rel __g_im_bad]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1976
    mov rax, 1
    jmp .L1977
.L1976:
    mov rax, 0
.L1977:
    test rax, rax
    jz .L1974
    mov rcx, 0
    sub rsp, 32
.kl740:
    call im_decode
    add rsp, 32
    mov r12, rax
    cmp r12, 16
    jge .L1978
    mov rax, r13
    cmp rax, 320
    jb .L1980
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl741:
    lea r8, [rel .kx68]
    call __fail_raise
.kx68:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1980:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rbp-2744]
    mov [rdx+rcx*8], rax
    add r13, 1
    jmp .L1979
.L1978:
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-2776], rax
    cmp r12, 16
    jne .L1981
    cmp r13, 0
    jne .L1983
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1958
    jmp .L1984
.L1983:
.L1984:
    mov rax, r13
    sub rax, 1
    cmp rax, 320
    jb .L1985
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl742:
    lea r8, [rel .kx69]
    call __fail_raise
.kx69:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1985:
    mov rcx, rax
    lea rdx, [rbp-2744]
    mov rax, [rdx+rcx*8]
    mov [rbp-2776], rax
    mov rax, 3
    push rax
    mov rcx, 2
    sub rsp, 32
.kl743:
    call im_bits
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L1982
.L1981:
    cmp r12, 17
    jne .L1986
    mov rax, 3
    push rax
    mov rcx, 3
    sub rsp, 32
.kl744:
    call im_bits
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L1987
.L1986:
    mov rax, 11
    push rax
    mov rcx, 7
    sub rsp, 32
.kl745:
    call im_bits
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
.L1987:
.L1982:
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, r15
    add rax, r14
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L1988
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_1958
    jmp .L1989
.L1988:
.L1989:
.L1990:
    cmp rbx, 0
    jle .L1991
    mov rax, r13
    cmp rax, 320
    jb .L1993
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl746:
    lea r8, [rel .kx70]
    call __fail_raise
.kx70:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1993:
    push rax
    mov rax, [rbp-2776]
    pop rcx
    lea rdx, [rbp-2744]
    mov [rdx+rcx*8], rax
    add r13, 1
    sub rbx, 1
.L1992:
    jmp .L1990
.L1991:
.L1979:
.L1975:
    jmp .L1973
.L1974:
    mov rax, [rel __g_im_bad]
    test rax, rax
    jz .L1994
    mov rax, 0
    jmp .__ret_1958
    jmp .L1995
.L1994:
.L1995:
    mov rax, 0
    mov rbx, rax
.L1996:
    cmp rbx, r15
    jge .L1997
    mov rax, rbx
    cmp rax, 320
    jb .L1999
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl747:
    lea r8, [rel .kx71]
    call __fail_raise
.kx71:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L1999:
    push rax
    mov rax, rbx
    cmp rax, 320
    jb .L2000
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx72]
    call __fail_raise
.kx72:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L2000:
    mov rcx, rax
    lea rdx, [rbp-2744]
    mov rax, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_im_lens]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L1998:
    jmp .L1996
.L1997:
    mov rcx, 0
    mov rdx, r15
    sub rsp, 32
.kl748:
    call im_build
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L2001:
    cmp rbx, r14
    jge .L2002
    mov rax, rbx
    cmp rax, 320
    jb .L2004
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl749:
    lea r8, [rel .kx73]
    call __fail_raise
.kx73:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L2004:
    push rax
    mov rax, r15
    add rax, rbx
    cmp rax, 320
    jb .L2005
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx74]
    call __fail_raise
.kx74:
    add rsp, 32
    xor rax, rax
    jmp .__ret_1958
.L2005:
    mov rcx, rax
    lea rdx, [rbp-2744]
    mov rax, [rdx+rcx*8]
    pop rcx
    lea rdx, [rel __g_im_lens]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2003:
    jmp .L2001
.L2002:
    mov rcx, 1
    mov rdx, r14
    sub rsp, 32
.kl750:
    call im_build
    add rsp, 32
    sub rsp, 32
.kl751:
    call im_codes
    add rsp, 32
    jmp .__ret_1958
.__ret_1958:
    mov rbx, [rbp-2832]
    mov r12, [rbp-2824]
    mov r13, [rbp-2816]
    mov r14, [rbp-2808]
    mov r15, [rbp-2800]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_fixed.kft, .kfe, .kfn, __kron_file_7,18
    dq .kl734,288
    dq .kl735,289
    dq .kl736,290
    dq .kl737,298
    dq .kl738,303
    dq .kl739,306
    dq .kl740,311
    dq .kl741,313
    dq .kl742,323
    dq .kl743,324
    dq .kl744,326
    dq .kl745,328
    dq .kl746,335
    dq .kl747,346
    dq .kl748,349
    dq .kl749,352
    dq .kl750,355
    dq .kl751,356
.kfn: db "im_dynamic", 0
section .text
im_inflate:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r12, rcx
    mov rbx, rdx
    sub rsp, 32
.kl752:
    call im_tables_once
    add rsp, 32
    mov rax, r12
    add rax, 2
    mov [rel __g_im_src], rax
    mov rax, rbx
    sub rax, 2
    mov [rel __g_im_src_n], rax
    mov rax, 0
    mov [rel __g_im_pos], rax
    mov rax, 0
    mov [rel __g_im_bit], rax
    mov rax, 0
    mov [rel __g_im_nbit], rax
    mov rax, 0
    mov [rel __g_im_bad], rax
    mov rax, 0
    mov r14, rax
.L2007:
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2010
    mov rax, [rel __g_im_bad]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2010
    mov rax, 1
    jmp .L2011
.L2010:
    mov rax, 0
.L2011:
    test rax, rax
    jz .L2008
    mov rcx, 1
    sub rsp, 32
.kl753:
    call im_bits
    add rsp, 32
    mov r14, rax
    mov rcx, 2
    sub rsp, 32
.kl754:
    call im_bits
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2012
    mov rax, 0
    mov [rel __g_im_bit], rax
    mov rax, 0
    mov [rel __g_im_nbit], rax
    mov rax, [rel __g_im_pos]
    add rax, 4
    push rax
    mov rax, [rel __g_im_src_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L2014
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_2006
    jmp .L2015
.L2014:
.L2015:
    mov rax, 0
    mov r13, rax
    mov rax, [rel __g_im_src]
    push rax
    mov rax, [rel __g_im_pos]
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, word [rax]
    mov r13, rax
    mov rax, [rel __g_im_pos]
    add rax, 4
    mov [rel __g_im_pos], rax
    mov rax, [rel __g_im_pos]
    add rax, r13
    push rax
    mov rax, [rel __g_im_src_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L2016
    mov rax, 1
    mov [rel __g_im_bad], rax
    mov rax, 0
    jmp .__ret_2006
    jmp .L2017
.L2016:
.L2017:
    mov rax, 0
    mov r12, rax
.L2018:
    cmp r12, r13
    jge .L2019
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_im_src]
    push rax
    mov rax, [rel __g_im_pos]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl755:
    call im_put
    add rsp, 32
    add r12, 1
.L2020:
    jmp .L2018
.L2019:
    mov rax, [rel __g_im_pos]
    add rax, r13
    mov [rel __g_im_pos], rax
    jmp .L2013
.L2012:
    cmp rbx, 1
    jne .L2021
    sub rsp, 32
.kl756:
    call im_fixed
    add rsp, 32
    jmp .L2022
.L2021:
    cmp rbx, 2
    jne .L2023
    sub rsp, 32
.kl757:
    call im_dynamic
    add rsp, 32
    jmp .L2024
.L2023:
    mov rax, 1
    mov [rel __g_im_bad], rax
.L2024:
.L2022:
.L2013:
.L2009:
    jmp .L2007
.L2008:
    mov rax, [rel __g_im_bad]
    test rax, rax
    jz .L2025
    mov rax, 0
    jmp .__ret_2006
    jmp .L2026
.L2025:
.L2026:
    mov rax, 1
    jmp .__ret_2006
.__ret_2006:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_dynamic.kft, .kfe, .kfn, __kron_file_7,6
    dq .kl752,361
    dq .kl753,370
    dq .kl754,371
    dq .kl755,390
    dq .kl756,395
    dq .kl757,397
.kfn: db "im_inflate", 0
section .text
im_be32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    movzx rax, byte [rax]
    shl rax, 24
    push rax
    mov rax, r12
    add rax, 1
    movzx rax, byte [rax]
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r12
    add rax, 2
    movzx rax, byte [rax]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r12
    add rax, 3
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_2027
.__ret_2027:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
im_paeth:
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
    add rax, r15
    sub rax, r14
    mov rbx, rax
    mov rax, rbx
    mov rcx, [rbp-8]
    sub rax, rcx
    mov r13, rax
    cmp r13, 0
    jge .L2029
    mov rax, 0
    sub rax, r13
    mov r13, rax
    jmp .L2030
.L2029:
.L2030:
    mov rax, rbx
    sub rax, r15
    mov r12, rax
    cmp r12, 0
    jge .L2031
    mov rax, 0
    sub rax, r12
    mov r12, rax
    jmp .L2032
.L2031:
.L2032:
    mov rax, rbx
    sub rax, r14
    mov rbx, rax
    cmp rbx, 0
    jge .L2033
    mov rax, 0
    sub rax, rbx
    mov rbx, rax
    jmp .L2034
.L2033:
.L2034:
    mov rax, r13
    mov rcx, r12
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2037
    mov rax, r13
    mov rcx, rbx
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2037
    mov rax, 1
    jmp .L2038
.L2037:
    mov rax, 0
.L2038:
    test rax, rax
    jz .L2035
    mov rax, [rbp-8]
    jmp .__ret_2028
    jmp .L2036
.L2035:
.L2036:
    cmp r12, rbx
    jg .L2039
    mov rax, r15
    jmp .__ret_2028
    jmp .L2040
.L2039:
.L2040:
    mov rax, r14
    jmp .__ret_2028
.__ret_2028:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
im_unfilter:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov [rbp-32], r9
    mov rax, 0
    mov r15, rax
.L2042:
    mov rax, r15
    mov rcx, [rbp-16]
    cmp rax, rcx
    jge .L2043
    mov rax, [rbp-24]
    add rax, 1
    mov rcx, rax
    mov rax, r15
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-8]
    add rax, rcx
    mov rbx, rax
    mov rax, [rbp-24]
    add rax, 1
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov r12, rax
    mov rax, 0
    mov r14, rax
    mov rax, rbx
    movzx rax, byte [rax]
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    add rax, 1
    mov [rbp-80], rax
    mov rax, r12
    add rax, 1
    mov [rbp-88], rax
.L2045:
    mov rax, r13
    mov rcx, [rbp-24]
    cmp rax, rcx
    jge .L2046
    mov rax, 0
    mov [rbp-96], rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-112], rax
    mov rax, r13
    mov rcx, [rbp-32]
    cmp rax, rcx
    jl .L2048
    mov rax, [rbp-80]
    add rax, r13
    mov rcx, [rbp-32]
    sub rax, rcx
    movzx rax, byte [rax]
    mov [rbp-96], rax
    jmp .L2049
.L2048:
.L2049:
    cmp r15, 0
    jle .L2050
    mov rax, [rbp-88]
    add rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r13
    mov rcx, [rbp-32]
    cmp rax, rcx
    jl .L2052
    mov rax, [rbp-88]
    add rax, r13
    mov rcx, [rbp-32]
    sub rax, rcx
    movzx rax, byte [rax]
    mov [rbp-112], rax
    jmp .L2053
.L2052:
.L2053:
    jmp .L2051
.L2050:
.L2051:
    mov rax, [rbp-80]
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
    cmp r14, 1
    jne .L2054
    mov rax, rbx
    mov rcx, [rbp-96]
    add rax, rcx
    mov rbx, rax
    jmp .L2055
.L2054:
    cmp r14, 2
    jne .L2056
    add rbx, r12
    jmp .L2057
.L2056:
    cmp r14, 3
    jne .L2058
    mov rax, [rbp-96]
    add rax, r12
    mov rcx, 2
    cqo
    idiv rcx
    mov rcx, rax
    mov rax, rbx
    add rax, rcx
    mov rbx, rax
    jmp .L2059
.L2058:
    cmp r14, 4
    jne .L2060
    mov rax, rbx
    push rax
    mov rcx, [rbp-96]
    mov rdx, r12
    mov r8, [rbp-112]
    sub rsp, 32
.kl758:
    call im_paeth
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L2061
.L2060:
.L2061:
.L2059:
.L2057:
.L2055:
    mov rax, [rbp-80]
    add rax, r13
    push rax
    mov rax, rbx
    and rax, 255
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r13, 1
.L2047:
    jmp .L2045
.L2046:
    add r15, 1
.L2044:
    jmp .L2042
.L2043:
    mov rax, 1
    jmp .__ret_2041
.__ret_2041:
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
.kft: dq im_inflate.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl758,469
.kfn: db "im_unfilter", 0
section .text
im_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov r14, rcx
    mov r12, rdx
    mov r13, r8
    mov rax, 0
    mov rbx, rax
    cmp r13, 8
    jne .L2063
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L2064
.L2063:
    cmp r13, 16
    jne .L2065
    mov rax, r12
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L2066
.L2065:
    mov rax, r12
    imul rax, r13
    mov rbx, rax
    mov rax, rbx
    mov rcx, 8
    cqo
    idiv rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, 8
    sub rax, r13
    push rax
    mov rax, rbx
    mov rcx, 8
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rbx, rax
    mov rax, r12
    mov rcx, rbx
    sar rax, cl
    push rax
    mov rax, 1
    mov rcx, r13
    shl rax, cl
    sub rax, 1
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rbx, rax
.L2066:
.L2064:
    mov rax, rbx
    jmp .__ret_2062
.__ret_2062:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
im_scale:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    cmp rbx, 1
    jne .L2068
    mov rax, r12
    mov rcx, 255
    imul rax, rcx
    jmp .__ret_2067
    jmp .L2069
.L2068:
.L2069:
    cmp rbx, 2
    jne .L2070
    mov rax, r12
    mov rcx, 85
    imul rax, rcx
    jmp .__ret_2067
    jmp .L2071
.L2070:
.L2071:
    cmp rbx, 4
    jne .L2072
    mov rax, r12
    mov rcx, 17
    imul rax, rcx
    jmp .__ret_2067
    jmp .L2073
.L2072:
.L2073:
    mov rax, r12
    jmp .__ret_2067
.__ret_2067:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
im_line:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    mov [rbp-192], rbx
    mov [rbp-184], r12
    mov [rbp-176], r13
    mov [rbp-168], r14
    mov [rbp-160], r15
    mov [rbp-8], rcx
    mov r15, rdx
    mov [rbp-24], r8
    mov [rbp-32], r9
    mov [rbp-40], r10
    mov [rbp-48], rax
    mov rax, [rbp+48]
    mov [rbp-56], rax
    mov rax, [rbp+56]
    mov r14, rax
    mov rax, 0
    mov [rbp-72], rax
    mov rax, [rbp-8]
    mov rax, [rax]
    mov [rbp-72], rax
    mov rax, 0
    mov r13, rax
.L2075:
    mov rax, r13
    mov rcx, [rbp-24]
    cmp rax, rcx
    jge .L2076
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-96], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 255
    mov [rbp-112], rax
    mov rax, [rbp-56]
    cmp rax, 0
    jne .L2078
    mov rcx, r15
    mov rdx, r13
    mov r8, r14
    sub rsp, 32
.kl759:
    call im_sample
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r14
    sub rsp, 32
.kl760:
    call im_scale
    add rsp, 32
    mov r12, rax
    cmp r14, 16
    jne .L2080
    mov rax, r13
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    movzx rax, byte [rax]
    shl rax, 8
    push rax
    mov rax, r13
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    add rax, 1
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    jmp .L2081
.L2080:
.L2081:
    mov rax, rbx
    push rax
    mov rax, [rel __g_im_key]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2082
    mov rax, 0
    mov [rbp-112], rax
    jmp .L2083
.L2082:
.L2083:
    mov rax, r12
    mov [rbp-96], rax
    mov rax, r12
    mov rbx, rax
    jmp .L2079
.L2078:
    mov rax, [rbp-56]
    cmp rax, 2
    jne .L2084
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 3
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl761:
    call im_sample
    add rsp, 32
    mov r12, rax
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 3
    imul rax, rcx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl762:
    call im_sample
    add rsp, 32
    mov [rbp-96], rax
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 3
    imul rax, rcx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl763:
    call im_sample
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_im_key]
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2088
    mov rax, r14
    mov rcx, 8
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2088
    mov rax, 1
    jmp .L2089
.L2088:
    mov rax, 0
.L2089:
    test rax, rax
    jz .L2086
    mov rax, r12
    shl rax, 16
    push rax
    mov rax, [rbp-96]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    push rax
    mov rax, [rel __g_im_key]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L2090
    mov rax, 0
    mov [rbp-112], rax
    jmp .L2091
.L2090:
.L2091:
    jmp .L2087
.L2086:
.L2087:
    jmp .L2085
.L2084:
    mov rax, [rbp-56]
    cmp rax, 3
    jne .L2092
    mov rcx, r15
    mov rdx, r13
    mov r8, r14
    sub rsp, 32
.kl764:
    call im_sample
    add rsp, 32
    and rax, 255
    cmp rax, 256
    jb .L2094
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx75]
    call __fail_raise
.kx75:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2074
.L2094:
    mov rcx, rax
    lea rdx, [rel __g_im_pal]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    mov rax, rbx
    sar rax, 24
    and rax, 255
    mov [rbp-112], rax
    mov rax, rbx
    sar rax, 16
    and rax, 255
    mov r12, rax
    mov rax, rbx
    sar rax, 8
    and rax, 255
    mov [rbp-96], rax
    mov rax, rbx
    and rax, 255
    mov rbx, rax
    jmp .L2093
.L2092:
    mov rax, [rbp-56]
    cmp rax, 4
    jne .L2095
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 2
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl765:
    call im_sample
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov [rbp-96], rax
    mov rax, r12
    mov rbx, rax
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 2
    imul rax, rcx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl766:
    call im_sample
    add rsp, 32
    mov [rbp-112], rax
    jmp .L2096
.L2095:
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl767:
    call im_sample
    add rsp, 32
    mov r12, rax
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl768:
    call im_sample
    add rsp, 32
    mov [rbp-96], rax
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl769:
    call im_sample
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    push rax
    mov rax, r13
    mov rcx, 4
    imul rax, rcx
    add rax, 3
    push rax
    pop rdx
    pop rcx
    mov r8, r14
    sub rsp, 32
.kl770:
    call im_sample
    add rsp, 32
    mov [rbp-112], rax
.L2096:
.L2093:
.L2085:
.L2079:
    mov rax, r13
    mov rcx, [rbp-48]
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-40]
    add rax, rcx
    mov [rbp-136], rax
    mov rax, [rbp-8]
    add rax, 16
    push rax
    mov rax, [rbp-32]
    mov rcx, [rbp-72]
    imul rax, rcx
    mov rcx, [rbp-136]
    add rax, rcx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-112]
    shl rax, 24
    push rax
    mov rax, r12
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, [rbp-96]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    add r13, 1
.L2077:
    jmp .L2075
.L2076:
    mov rax, 1
    jmp .__ret_2074
.__ret_2074:
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
.kft: dq im_unfilter.kft, .kfe, .kfn, __kron_file_7,12
    dq .kl759,516
    dq .kl760,517
    dq .kl761,527
    dq .kl762,528
    dq .kl763,529
    dq .kl764,536
    dq .kl765,542
    dq .kl766,545
    dq .kl767,547
    dq .kl768,548
    dq .kl769,549
    dq .kl770,550
.kfn: db "im_line", 0
section .text
im_png:
    push rbp
    mov rbp, rsp
    sub rsp, 576
    mov [rbp-544], rbx
    mov [rbp-536], r12
    mov [rbp-528], r13
    mov [rbp-520], r14
    mov [rbp-512], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, 8
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov [rbp-80], rax
    mov rax, 1
    neg rax
    mov [rel __g_im_key], rax
    mov rax, 0
    mov rbx, rax
.L2098:
    cmp rbx, 256
    jge .L2099
    mov rax, rbx
    cmp rax, 256
    jb .L2101
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl771:
    lea r8, [rel .kx76]
    call __fail_raise
.kx76:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2101:
    push rax
    mov rax, 0xFF000000
    pop rcx
    lea rdx, [rel __g_im_pal]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2100:
    jmp .L2098
.L2099:
    mov rax, 0
    mov [rbp-96], rax
.L2102:
    mov rax, [rbp-24]
    add rax, 8
    mov rcx, [rbp-16]
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2105
    mov rax, [rbp-96]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2105
    mov rax, 1
    jmp .L2106
.L2105:
    mov rax, 0
.L2106:
    test rax, rax
    jz .L2103
    mov rax, [rbp-8]
    mov rcx, [rbp-24]
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl772:
    call im_be32
    add rsp, 32
    mov r13, rax
    mov rax, [rbp-8]
    mov rcx, [rbp-24]
    add rax, rcx
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
.kl773:
    call im_be32
    add rsp, 32
    mov rbx, rax
    mov rax, [rbp-8]
    mov rcx, [rbp-24]
    add rax, rcx
    add rax, 8
    mov r12, rax
    mov rax, [rbp-24]
    add rax, 12
    add rax, r13
    mov rcx, [rbp-16]
    cmp rax, rcx
    jle .L2107
    mov rax, 1
    mov [rbp-96], rax
    jmp .L2108
.L2107:
    mov rax, rbx
    mov rcx, 0x49484452
    cmp rax, rcx
    jne .L2109
    mov rcx, r12
    sub rsp, 32
.kl774:
    call im_be32
    add rsp, 32
    mov [rbp-32], rax
    mov rax, r12
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
.kl775:
    call im_be32
    add rsp, 32
    mov [rbp-40], rax
    mov rax, r12
    add rax, 8
    movzx rax, byte [rax]
    mov [rbp-48], rax
    mov rax, r12
    add rax, 9
    movzx rax, byte [rax]
    mov r15, rax
    mov rax, r12
    add rax, 12
    movzx rax, byte [rax]
    mov [rbp-64], rax
    jmp .L2110
.L2109:
    mov rax, rbx
    mov rcx, 0x504C5445
    cmp rax, rcx
    jne .L2111
    mov rax, 0
    mov rbx, rax
.L2113:
    mov rax, r13
    mov rcx, 3
    cqo
    idiv rcx
    mov rcx, rax
    mov rax, rbx
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2116
    mov rax, rbx
    mov rcx, 256
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2116
    mov rax, 1
    jmp .L2117
.L2116:
    mov rax, 0
.L2117:
    test rax, rax
    jz .L2114
    mov rax, 0
    mov [rbp-136], rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    movzx rax, byte [rax]
    shl rax, 16
    push rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    add rax, 1
    movzx rax, byte [rax]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    add rax, 2
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov [rbp-136], rax
    mov rax, rbx
    cmp rax, 256
    jb .L2118
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl776:
    lea r8, [rel .kx77]
    call __fail_raise
.kx77:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2118:
    push rax
    mov rax, 0xFF000000
    mov rcx, [rbp-136]
    or rax, rcx
    pop rcx
    lea rdx, [rel __g_im_pal]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2115:
    jmp .L2113
.L2114:
    jmp .L2112
.L2111:
    mov rax, rbx
    mov rcx, 0x74524E53
    cmp rax, rcx
    jne .L2119
    cmp r15, 3
    jne .L2121
    mov rax, 0
    mov rbx, rax
.L2123:
    mov rax, rbx
    mov rcx, r13
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2126
    mov rax, rbx
    mov rcx, 256
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2126
    mov rax, 1
    jmp .L2127
.L2126:
    mov rax, 0
.L2127:
    test rax, rax
    jz .L2124
    mov rax, 0
    mov [rbp-152], rax
    mov rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    mov [rbp-152], rax
    mov rax, rbx
    cmp rax, 256
    jb .L2128
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl777:
    lea r8, [rel .kx78]
    call __fail_raise
.kx78:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2128:
    push rax
    mov rax, rbx
    cmp rax, 256
    jb .L2129
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx79]
    call __fail_raise
.kx79:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2129:
    mov rcx, rax
    lea rdx, [rel __g_im_pal]
    mov rax, [rdx+rcx*8]
    and rax, 0xFFFFFF
    push rax
    mov rax, [rbp-152]
    shl rax, 24
    mov rcx, rax
    pop rax
    or rax, rcx
    pop rcx
    lea rdx, [rel __g_im_pal]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2125:
    jmp .L2123
.L2124:
    jmp .L2122
.L2121:
    cmp r15, 0
    jne .L2130
    mov rax, r12
    movzx rax, byte [rax]
    shl rax, 8
    push rax
    mov rax, r12
    add rax, 1
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov [rel __g_im_key], rax
    mov rax, [rbp-48]
    cmp rax, 16
    jge .L2132
    mov rax, 1
    mov rcx, [rbp-48]
    shl rax, cl
    sub rax, 1
    mov rcx, rax
    mov rax, [rel __g_im_key]
    and rax, rcx
    mov [rel __g_im_key], rax
    jmp .L2133
.L2132:
.L2133:
    jmp .L2131
.L2130:
    cmp r15, 2
    jne .L2134
    mov rax, r12
    add rax, 1
    movzx rax, byte [rax]
    shl rax, 16
    push rax
    mov rax, r12
    add rax, 3
    movzx rax, byte [rax]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r12
    add rax, 5
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov [rel __g_im_key], rax
    jmp .L2135
.L2134:
.L2135:
.L2131:
.L2122:
    jmp .L2120
.L2119:
    mov rax, rbx
    mov rcx, 0x49444154
    cmp rax, rcx
    jne .L2136
    mov rax, r14
    push rax
    mov rax, [rbp-80]
    add rax, r13
    add rax, 16
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl778:
    call hp_grow
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2138
    mov rcx, r14
    sub rsp, 32
.kl779:
    call hp_release
    add rsp, 32
    mov rax, 0
    jmp .__ret_2097
    jmp .L2139
.L2138:
.L2139:
    mov rax, rbx
    mov r14, rax
    mov rax, r14
    mov rcx, [rbp-80]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r12
    mov r8, r13
    sub rsp, 32
.kl780:
    call hp_copy
    add rsp, 32
    mov rax, [rbp-80]
    add rax, r13
    mov [rbp-80], rax
    jmp .L2137
.L2136:
    mov rax, rbx
    mov rcx, 0x49454E44
    cmp rax, rcx
    jne .L2140
    mov rax, 1
    mov [rbp-96], rax
    jmp .L2141
.L2140:
.L2141:
.L2137:
.L2120:
.L2112:
.L2110:
.L2108:
    mov rax, [rbp-24]
    add rax, 12
    add rax, r13
    mov [rbp-24], rax
.L2104:
    jmp .L2102
.L2103:
    mov rax, [rbp-32]
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L2146
    mov rax, [rbp-40]
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L2146
    mov rax, 0
    jmp .L2147
.L2146:
    mov rax, 1
.L2147:
    test rax, rax
    jnz .L2144
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2144
    mov rax, 0
    jmp .L2145
.L2144:
    mov rax, 1
.L2145:
    test rax, rax
    jz .L2142
    mov rcx, r14
    sub rsp, 32
.kl781:
    call hp_release
    add rsp, 32
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2097
    jmp .L2143
.L2142:
.L2143:
    mov rax, 1
    mov rbx, rax
    cmp r15, 2
    jne .L2148
    mov rax, 3
    mov rbx, rax
    jmp .L2149
.L2148:
.L2149:
    cmp r15, 4
    jne .L2150
    mov rax, 2
    mov rbx, rax
    jmp .L2151
.L2150:
.L2151:
    cmp r15, 6
    jne .L2152
    mov rax, 4
    mov rbx, rax
    jmp .L2153
.L2152:
.L2153:
    mov rax, rbx
    mov rcx, [rbp-48]
    imul rax, rcx
    mov [rbp-176], rax
    mov rax, [rbp-176]
    mov rcx, 8
    cqo
    idiv rcx
    mov [rbp-184], rax
    mov rax, [rbp-184]
    cmp rax, 1
    jge .L2154
    mov rax, 1
    mov [rbp-184], rax
    jmp .L2155
.L2154:
.L2155:
    mov rax, 0
    mov [rel __g_im_out], rax
    mov rax, 0
    mov [rel __g_im_out_n], rax
    mov rax, 0
    mov [rel __g_im_out_cap], rax
    mov rcx, r14
    mov rdx, [rbp-80]
    sub rsp, 32
.kl782:
    call im_inflate
    add rsp, 32
    mov rbx, rax
    mov rcx, r14
    sub rsp, 32
.kl783:
    call hp_release
    add rsp, 32
    cmp rbx, 0
    jne .L2156
    mov rax, [rel __g_im_out]
    push rax
    pop rcx
    sub rsp, 32
.kl784:
    call hp_release
    add rsp, 32
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2097
    jmp .L2157
.L2156:
.L2157:
    mov rcx, [rbp-32]
    mov rdx, [rbp-40]
    sub rsp, 32
.kl785:
    call im_new
    add rsp, 32
    mov [rbp-200], rax
    mov rax, [rbp-200]
    cmp rax, 0
    jne .L2158
    mov rax, [rel __g_im_out]
    push rax
    pop rcx
    sub rsp, 32
.kl786:
    call hp_release
    add rsp, 32
    mov rax, 0
    jmp .__ret_2097
    jmp .L2159
.L2158:
.L2159:
    mov rcx, [rbp-200]
    sub rsp, 32
.kl787:
    call im_block
    add rsp, 32
    mov [rbp-208], rax
    mov rax, 0
    mov [rbp-264], rax
    mov rax, 4
    mov [rbp-256], rax
    mov rax, 0
    mov [rbp-248], rax
    mov rax, 2
    mov [rbp-240], rax
    mov rax, 0
    mov [rbp-232], rax
    mov rax, 1
    mov [rbp-224], rax
    mov rax, 0
    mov [rbp-216], rax
    mov rax, 0
    mov [rbp-320], rax
    mov rax, 0
    mov [rbp-312], rax
    mov rax, 4
    mov [rbp-304], rax
    mov rax, 0
    mov [rbp-296], rax
    mov rax, 2
    mov [rbp-288], rax
    mov rax, 0
    mov [rbp-280], rax
    mov rax, 1
    mov [rbp-272], rax
    mov rax, 8
    mov [rbp-376], rax
    mov rax, 8
    mov [rbp-368], rax
    mov rax, 4
    mov [rbp-360], rax
    mov rax, 4
    mov [rbp-352], rax
    mov rax, 2
    mov [rbp-344], rax
    mov rax, 2
    mov [rbp-336], rax
    mov rax, 1
    mov [rbp-328], rax
    mov rax, 8
    mov [rbp-432], rax
    mov rax, 8
    mov [rbp-424], rax
    mov rax, 8
    mov [rbp-416], rax
    mov rax, 4
    mov [rbp-408], rax
    mov rax, 4
    mov [rbp-400], rax
    mov rax, 2
    mov [rbp-392], rax
    mov rax, 2
    mov [rbp-384], rax
    mov rax, 7
    mov [rbp-440], rax
    mov rax, [rbp-64]
    cmp rax, 0
    jne .L2160
    mov rax, 1
    mov [rbp-440], rax
    mov rax, 0
    cmp rax, 7
    jb .L2162
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl788:
    lea r8, [rel .kx80]
    call __fail_raise
.kx80:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2162:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-264]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 7
    jb .L2163
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl789:
    lea r8, [rel .kx81]
    call __fail_raise
.kx81:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2163:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-320]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 7
    jb .L2164
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl790:
    lea r8, [rel .kx82]
    call __fail_raise
.kx82:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2164:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-376]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 7
    jb .L2165
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl791:
    lea r8, [rel .kx83]
    call __fail_raise
.kx83:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2165:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-432]
    mov [rdx+rcx*8], rax
    jmp .L2161
.L2160:
.L2161:
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L2166:
    mov rax, r13
    mov rcx, [rbp-440]
    cmp rax, rcx
    jge .L2167
    mov rax, [rbp-32]
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2169
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl792:
    lea r8, [rel .kx84]
    call __fail_raise
.kx84:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2169:
    mov rcx, rax
    lea rdx, [rbp-264]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2170
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx85]
    call __fail_raise
.kx85:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2170:
    mov rcx, rax
    lea rdx, [rbp-376]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, 1
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2171
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx86]
    call __fail_raise
.kx86:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2171:
    mov rcx, rax
    lea rdx, [rbp-376]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov [rbp-464], rax
    mov rax, [rbp-40]
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2172
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl793:
    lea r8, [rel .kx87]
    call __fail_raise
.kx87:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2172:
    mov rcx, rax
    lea rdx, [rbp-320]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2173
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx88]
    call __fail_raise
.kx88:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2173:
    mov rcx, rax
    lea rdx, [rbp-432]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, 1
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2174
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx89]
    call __fail_raise
.kx89:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2174:
    mov rcx, rax
    lea rdx, [rbp-432]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov r12, rax
    mov rax, [rbp-464]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L2177
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L2177
    mov rax, 1
    jmp .L2178
.L2177:
    mov rax, 0
.L2178:
    test rax, rax
    jz .L2175
    mov rax, [rbp-464]
    mov rcx, [rbp-176]
    imul rax, rcx
    add rax, 7
    mov rcx, 8
    cqo
    idiv rcx
    mov [rbp-480], rax
    mov rax, [rbp-480]
    add rax, 1
    mov rcx, rax
    mov rax, r12
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    push rax
    mov rax, [rel __g_im_out_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L2179
    mov rax, [rel __g_im_out]
    push rax
    pop rcx
    sub rsp, 32
.kl794:
    call hp_release
    add rsp, 32
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, [rbp-200]
    jmp .__ret_2097
    jmp .L2180
.L2179:
.L2180:
    mov rax, [rel __g_im_out]
    add rax, r14
    push rax
    pop rcx
    mov rdx, r12
    mov r8, [rbp-480]
    mov r9, [rbp-184]
    sub rsp, 32
.kl795:
    call im_unfilter
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L2181:
    cmp rbx, r12
    jge .L2182
    mov rax, [rbp-48]
    push rax
    mov rax, r15
    push rax
    mov rax, [rbp-208]
    push rax
    mov rax, [rel __g_im_out]
    add rax, r14
    push rax
    mov rax, [rbp-480]
    add rax, 1
    mov rcx, rax
    mov rax, rbx
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 1
    push rax
    mov rax, [rbp-464]
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2184
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl796:
    lea r8, [rel .kx90]
    call __fail_raise
.kx90:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2184:
    mov rcx, rax
    lea rdx, [rbp-320]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, rbx
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2185
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx91]
    call __fail_raise
.kx91:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2185:
    mov rcx, rax
    lea rdx, [rbp-432]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2186
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx92]
    call __fail_raise
.kx92:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2186:
    mov rcx, rax
    lea rdx, [rbp-264]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r13
    cmp rax, 7
    jb .L2187
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx93]
    call __fail_raise
.kx93:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2097
.L2187:
    mov rcx, rax
    lea rdx, [rbp-376]
    mov rax, [rdx+rcx*8]
    push rax
    pop rax
    pop r10
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call im_line
    add rsp, 32
    add rsp, 16
    add rbx, 1
.L2183:
    jmp .L2181
.L2182:
    mov rax, [rbp-480]
    add rax, 1
    mov rcx, rax
    mov rax, r12
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    mov r14, rax
    jmp .L2176
.L2175:
.L2176:
    add r13, 1
.L2168:
    jmp .L2166
.L2167:
    mov rax, [rel __g_im_out]
    push rax
    pop rcx
    sub rsp, 32
.kl797:
    call hp_release
    add rsp, 32
    mov rax, 0
    mov [rel __g_im_out], rax
    mov rax, [rbp-200]
    jmp .__ret_2097
.__ret_2097:
    mov rbx, [rbp-544]
    mov r12, [rbp-536]
    mov r13, [rbp-528]
    mov r14, [rbp-520]
    mov r15, [rbp-512]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_line.kft, .kfe, .kfn, __kron_file_7,27
    dq .kl771,571
    dq .kl772,576
    dq .kl773,577
    dq .kl774,582
    dq .kl775,583
    dq .kl776,594
    dq .kl777,603
    dq .kl778,615
    dq .kl779,617
    dq .kl780,621
    dq .kl781,629
    dq .kl782,643
    dq .kl783,644
    dq .kl784,646
    dq .kl785,650
    dq .kl786,652
    dq .kl787,655
    dq .kl788,664
    dq .kl789,665
    dq .kl790,666
    dq .kl791,667
    dq .kl792,672
    dq .kl793,673
    dq .kl794,677
    dq .kl795,681
    dq .kl796,684
    dq .kl797,691
.kfn: db "im_png", 0
section .text
im_le:
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
    sub rax, 1
    mov rbx, rax
.L2189:
    cmp rbx, 0
    jl .L2190
    mov rax, r12
    shl rax, 8
    push rax
    mov rax, r14
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r12, rax
    sub rbx, 1
.L2191:
    jmp .L2189
.L2190:
    cmp r13, 4
    jne .L2192
    mov rax, r12
    shl rax, 32
    sar rax, 32
    mov r12, rax
    jmp .L2193
.L2192:
.L2193:
    mov rax, r12
    jmp .__ret_2188
.__ret_2188:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
im_bmp:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov r15, rcx
    mov rbx, rdx
    cmp rbx, 54
    jge .L2195
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2194
    jmp .L2196
.L2195:
.L2196:
    mov rax, r15
    add rax, 10
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
.kl798:
    call im_le
    add rsp, 32
    mov [rbp-24], rax
    mov rax, r15
    add rax, 18
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
.kl799:
    call im_le
    add rsp, 32
    mov [rbp-32], rax
    mov rax, r15
    add rax, 22
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
.kl800:
    call im_le
    add rsp, 32
    mov r14, rax
    mov rax, r15
    add rax, 28
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
.kl801:
    call im_le
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov [rbp-56], rax
    cmp r14, 0
    jge .L2197
    mov rax, 0
    sub rax, r14
    mov r14, rax
    mov rax, 1
    mov [rbp-56], rax
    jmp .L2198
.L2197:
.L2198:
    mov rax, r13
    mov rcx, 24
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2201
    mov rax, r13
    mov rcx, 32
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2201
    mov rax, 1
    jmp .L2202
.L2201:
    mov rax, 0
.L2202:
    test rax, rax
    jz .L2199
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2194
    jmp .L2200
.L2199:
.L2200:
    mov rax, [rbp-32]
    imul rax, r13
    mov rcx, 8
    cqo
    idiv rcx
    add rax, 3
    mov rcx, 4
    cqo
    idiv rcx
    mov rcx, 4
    imul rax, rcx
    mov [rbp-64], rax
    mov rax, [rbp-64]
    imul rax, r14
    mov rcx, rax
    mov rax, [rbp-24]
    add rax, rcx
    cmp rax, rbx
    jle .L2203
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2194
    jmp .L2204
.L2203:
.L2204:
    mov rcx, [rbp-32]
    mov rdx, r14
    sub rsp, 32
.kl802:
    call im_new
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    cmp rax, 0
    jne .L2205
    mov rax, 0
    jmp .__ret_2194
    jmp .L2206
.L2205:
.L2206:
    mov rcx, [rbp-72]
    sub rsp, 32
.kl803:
    call im_block
    add rsp, 32
    mov [rbp-80], rax
    mov rax, 0
    mov r12, rax
.L2207:
    cmp r12, r14
    jge .L2208
    mov rax, r14
    sub rax, 1
    sub rax, r12
    mov rbx, rax
    mov rax, [rbp-56]
    test rax, rax
    jz .L2210
    mov rax, r12
    mov rbx, rax
    jmp .L2211
.L2210:
.L2211:
    mov rax, r15
    mov rcx, [rbp-24]
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, [rbp-64]
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-104], rax
    mov rax, 0
    mov rbx, rax
.L2212:
    mov rax, rbx
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L2213
    mov rax, r13
    mov rcx, 8
    cqo
    idiv rcx
    mov rcx, rax
    mov rax, rbx
    imul rax, rcx
    mov rcx, rax
    mov rax, [rbp-104]
    add rax, rcx
    mov [rbp-120], rax
    mov rax, [rbp-120]
    add rax, 2
    movzx rax, byte [rax]
    shl rax, 16
    push rax
    mov rax, [rbp-120]
    add rax, 1
    movzx rax, byte [rax]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, [rbp-120]
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov [rbp-128], rax
    mov rax, [rbp-80]
    add rax, 16
    push rax
    mov rax, r12
    mov rcx, [rbp-32]
    imul rax, rcx
    add rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0xFF000000
    mov rcx, [rbp-128]
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    add rbx, 1
.L2214:
    jmp .L2212
.L2213:
    add r12, 1
.L2209:
    jmp .L2207
.L2208:
    mov rax, [rbp-72]
    jmp .__ret_2194
.__ret_2194:
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
.kft: dq im_png.kft, .kfe, .kfn, __kron_file_7,6
    dq .kl798,718
    dq .kl799,719
    dq .kl800,720
    dq .kl801,721
    dq .kl802,736
    dq .kl803,740
.kfn: db "im_bmp", 0
section .text
section .bss
__g_jq: resq 256
section .text
section .bss
__g_jh_count: resq 136
section .text
section .bss
__g_jh_val: resq 2048
section .text
section .bss
__g_jh_max: resq 144
section .text
section .bss
__g_jh_ptr: resq 144
section .text
section .bss
__g_jh_min: resq 144
section .text
section .bss
__g_jc_id: resq 4
section .text
section .bss
__g_jc_h: resq 4
section .text
section .bss
__g_jc_v: resq 4
section .text
section .bss
__g_jc_tq: resq 4
section .text
section .bss
__g_jc_td: resq 4
section .text
section .bss
__g_jc_ta: resq 4
section .text
section .bss
__g_jc_pred: resq 4
section .text
section .bss
__g_jc_plane: resq 4
section .text
section .bss
__g_jc_pw: resq 4
section .text
section .data
__g_jn: dq 0
section .text
section .data
__g_jpos: dq 0
section .text
section .data
__g_jend: dq 0
section .text
section .data
__g_jbits: dq 0
section .text
section .data
__g_jnbits: dq 0
section .text
section .data
__g_jbad: dq 0
section .text
section .bss
__g_jzz: resq 64
section .text
section .bss
__g_jcs: resq 64
section .text
section .bss
__g_jblk: resq 64
section .text
section .bss
__g_jtmp: resq 64
section .text
section .data
__g_jready: dq 0
section .text
jp_tables:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    movups [rbp-80], xmm6
    mov rax, [rel __g_jready]
    cmp rax, 1
    jne .L2216
    mov rax, 0
    jmp .__ret_2215
    jmp .L2217
.L2216:
.L2217:
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L2218:
    cmp r14, 64
    jge .L2219
    mov rax, r14
    cmp rax, 64
    jb .L2221
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl804:
    lea r8, [rel .kx94]
    call __fail_raise
.kx94:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2215
.L2221:
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    add rax, r13
    pop rcx
    lea rdx, [rel __g_jzz]
    mov [rdx+rcx*8], rax
    cmp rbx, 1
    jne .L2222
    cmp r13, 7
    jne .L2224
    add r12, 1
    mov rax, 0
    mov rbx, rax
    jmp .L2225
.L2224:
    cmp r12, 0
    jne .L2226
    add r13, 1
    mov rax, 0
    mov rbx, rax
    jmp .L2227
.L2226:
    add r13, 1
    sub r12, 1
.L2227:
.L2225:
    jmp .L2223
.L2222:
    cmp r12, 7
    jne .L2228
    add r13, 1
    mov rax, 1
    mov rbx, rax
    jmp .L2229
.L2228:
    cmp r13, 0
    jne .L2230
    add r12, 1
    mov rax, 1
    mov rbx, rax
    jmp .L2231
.L2230:
    sub r13, 1
    add r12, 1
.L2231:
.L2229:
.L2223:
    add r14, 1
.L2220:
    jmp .L2218
.L2219:
    mov rax, 0
    mov r12, rax
.L2232:
    cmp r12, 8
    jge .L2233
    mov rax, 0
    mov rbx, rax
.L2235:
    cmp rbx, 8
    jge .L2236
section .data
.flt2238: dq 1.0
section .text
    movsd xmm0, [rel .flt2238]
    movaps xmm6, xmm0
    cmp rbx, 0
    jne .L2239
section .data
.flt2241: dq 0.7071067811865476
section .text
    movsd xmm0, [rel .flt2241]
    movaps xmm6, xmm0
    jmp .L2240
.L2239:
.L2240:
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    cmp rax, 64
    jb .L2242
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl805:
    lea r8, [rel .kx95]
    call __fail_raise
.kx95:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2215
.L2242:
    push rax
    mov rax, 2
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r12
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
section .data
.flt2243: dq 3.141592653589793
section .text
    movsd xmm0, [rel .flt2243]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2244: dq 16.0
section .text
    movsd xmm0, [rel .flt2244]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    divsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
    call fcos
    add rsp, 32
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2245: dq 0.5
section .text
    movsd xmm0, [rel .flt2245]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    pop rcx
    lea rdx, [rel __g_jcs]
    movsd [rdx+rcx*8], xmm0
    add rbx, 1
.L2237:
    jmp .L2235
.L2236:
    add r12, 1
.L2234:
    jmp .L2232
.L2233:
    mov rax, 1
    mov [rel __g_jready], rax
    mov rax, 0
    jmp .__ret_2215
.__ret_2215:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    movups xmm6, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_bmp.kft, .kfe, .kfn, __kron_file_7,2
    dq .kl804,801
    dq .kl805,819
.kfn: db "jp_tables", 0
section .text
jp_byte:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_jpos]
    push rax
    mov rax, [rel __g_jend]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2247
    mov rax, 1
    mov [rel __g_jbad], rax
    mov rax, 0
    jmp .__ret_2246
    jmp .L2248
.L2247:
.L2248:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_jpos]
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, [rel __g_jpos]
    add rax, 1
    mov [rel __g_jpos], rax
    mov rax, rbx
    jmp .__ret_2246
.__ret_2246:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
jp_bit:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_jnbits]
    cmp rax, 0
    jne .L2250
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_jpos]
    push rax
    mov rax, [rel __g_jend]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2252
    mov rax, [rel __g_jpos]
    movzx rax, byte [rax]
    mov r12, rax
    cmp r12, 255
    jne .L2254
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_jpos]
    add rax, 1
    push rax
    mov rax, [rel __g_jend]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2256
    mov rax, [rel __g_jpos]
    add rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L2257
.L2256:
.L2257:
    cmp rbx, 0
    jne .L2258
    mov rax, [rel __g_jpos]
    add rax, 2
    mov [rel __g_jpos], rax
    jmp .L2259
.L2258:
    mov rax, 0
    mov r12, rax
.L2259:
    jmp .L2255
.L2254:
    mov rax, [rel __g_jpos]
    add rax, 1
    mov [rel __g_jpos], rax
.L2255:
    jmp .L2253
.L2252:
.L2253:
    mov rax, r12
    mov [rel __g_jbits], rax
    mov rax, 8
    mov [rel __g_jnbits], rax
    jmp .L2251
.L2250:
.L2251:
    mov rax, [rel __g_jnbits]
    sub rax, 1
    mov [rel __g_jnbits], rax
    mov rax, [rel __g_jbits]
    push rax
    mov rax, [rel __g_jnbits]
    mov rcx, rax
    pop rax
    sar rax, cl
    and rax, 1
    jmp .__ret_2249
.__ret_2249:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
jp_receive:
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
.L2261:
    cmp rbx, r13
    jge .L2262
    mov rax, r12
    shl rax, 1
    push rax
    sub rsp, 32
.kl806:
    call jp_bit
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r12, rax
    add rbx, 1
.L2263:
    jmp .L2261
.L2262:
    mov rax, r12
    jmp .__ret_2260
.__ret_2260:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq jp_tables.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl806,869
.kfn: db "jp_receive", 0
section .text
jp_extend:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    cmp rbx, 0
    jne .L2265
    mov rax, 0
    jmp .__ret_2264
    jmp .L2266
.L2265:
.L2266:
    mov rax, r12
    push rax
    mov rax, rbx
    sub rax, 1
    mov rcx, rax
    mov rax, 1
    shl rax, cl
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2267
    mov rax, 1
    mov rcx, rbx
    shl rax, cl
    mov rcx, rax
    mov rax, r12
    sub rax, rcx
    add rax, 1
    jmp .__ret_2264
    jmp .L2268
.L2267:
.L2268:
    mov rax, r12
    jmp .__ret_2264
.__ret_2264:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
jp_decode:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    sub rsp, 32
.kl807:
    call jp_bit
    add rsp, 32
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L2270:
    cmp rbx, 16
    jg .L2271
    mov rax, r12
    push rax
    mov rax, r13
    mov rcx, 18
    imul rax, rcx
    add rax, rbx
    cmp rax, 144
    jb .L2275
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl808:
    lea r8, [rel .kx96]
    call __fail_raise
.kx96:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2269
.L2275:
    mov rcx, rax
    lea rdx, [rel __g_jh_max]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jg .L2273
    mov rax, r13
    mov rcx, 256
    imul rax, rcx
    push rax
    mov rax, r13
    mov rcx, 18
    imul rax, rcx
    add rax, rbx
    cmp rax, 144
    jb .L2276
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl809:
    lea r8, [rel .kx97]
    call __fail_raise
.kx97:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2269
.L2276:
    mov rcx, rax
    lea rdx, [rel __g_jh_ptr]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r12
    push rax
    mov rax, r13
    mov rcx, 18
    imul rax, rcx
    add rax, rbx
    cmp rax, 144
    jb .L2277
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx98]
    call __fail_raise
.kx98:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2269
.L2277:
    mov rcx, rax
    lea rdx, [rel __g_jh_min]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    sub rax, rcx
    cmp rax, 2048
    jb .L2278
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx99]
    call __fail_raise
.kx99:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2269
.L2278:
    mov rcx, rax
    lea rdx, [rel __g_jh_val]
    mov rax, [rdx+rcx*8]
    jmp .__ret_2269
    jmp .L2274
.L2273:
.L2274:
    mov rax, r12
    shl rax, 1
    push rax
    sub rsp, 32
.kl810:
    call jp_bit
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov r12, rax
    add rbx, 1
.L2272:
    jmp .L2270
.L2271:
    mov rax, 1
    mov [rel __g_jbad], rax
    mov rax, 0
    jmp .__ret_2269
.__ret_2269:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq jp_receive.kft, .kfe, .kfn, __kron_file_7,4
    dq .kl807,884
    dq .kl808,887
    dq .kl809,888
    dq .kl810,890
.kfn: db "jp_decode", 0
section .text
jp_build:
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
    mov rax, 0
    mov r13, rax
    mov rax, 1
    mov r12, rax
.L2280:
    cmp r12, 16
    jg .L2281
    mov rax, r15
    mov rcx, 17
    imul rax, rcx
    add rax, r12
    cmp rax, 136
    jb .L2283
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl811:
    lea r8, [rel .kx100]
    call __fail_raise
.kx100:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2279
.L2283:
    mov rcx, rax
    lea rdx, [rel __g_jh_count]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    mov rax, r15
    mov rcx, 18
    imul rax, rcx
    add rax, r12
    cmp rax, 144
    jb .L2284
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl812:
    lea r8, [rel .kx101]
    call __fail_raise
.kx101:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2279
.L2284:
    push rax
    mov rax, r13
    pop rcx
    lea rdx, [rel __g_jh_ptr]
    mov [rdx+rcx*8], rax
    mov rax, r15
    mov rcx, 18
    imul rax, rcx
    add rax, r12
    cmp rax, 144
    jb .L2285
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl813:
    lea r8, [rel .kx102]
    call __fail_raise
.kx102:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2279
.L2285:
    push rax
    mov rax, r14
    pop rcx
    lea rdx, [rel __g_jh_min]
    mov [rdx+rcx*8], rax
    add r14, rbx
    add r13, rbx
    cmp rbx, 0
    jle .L2286
    mov rax, r15
    mov rcx, 18
    imul rax, rcx
    add rax, r12
    cmp rax, 144
    jb .L2288
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl814:
    lea r8, [rel .kx103]
    call __fail_raise
.kx103:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2279
.L2288:
    push rax
    mov rax, r14
    sub rax, 1
    pop rcx
    lea rdx, [rel __g_jh_max]
    mov [rdx+rcx*8], rax
    jmp .L2287
.L2286:
    mov rax, r15
    mov rcx, 18
    imul rax, rcx
    add rax, r12
    cmp rax, 144
    jb .L2289
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl815:
    lea r8, [rel .kx104]
    call __fail_raise
.kx104:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2279
.L2289:
    push rax
    mov rax, 1
    neg rax
    pop rcx
    lea rdx, [rel __g_jh_max]
    mov [rdx+rcx*8], rax
.L2287:
    mov rax, r14
    shl rax, 1
    mov r14, rax
    add r12, 1
.L2282:
    jmp .L2280
.L2281:
    mov rax, 0
    jmp .__ret_2279
.__ret_2279:
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
.kft: dq jp_decode.kft, .kfe, .kfn, __kron_file_7,5
    dq .kl811,903
    dq .kl812,904
    dq .kl813,905
    dq .kl814,909
    dq .kl815,911
.kfn: db "jp_build", 0
section .text
jp_block:
    push rbp
    mov rbp, rsp
    sub rsp, 272
    mov [rbp-240], rbx
    mov [rbp-232], r12
    mov [rbp-224], r13
    mov [rbp-216], r14
    mov [rbp-208], r15
    movups [rbp-200], xmm6
    mov r14, rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov rax, 0
    mov r15, rax
.L2291:
    cmp r15, 64
    jge .L2292
    mov rax, r15
    cmp rax, 64
    jb .L2294
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl816:
    lea r8, [rel .kx105]
    call __fail_raise
.kx105:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2294:
    push rax
section .data
.flt2295: dq 0.0
section .text
    movsd xmm0, [rel .flt2295]
    pop rcx
    lea rdx, [rel __g_jblk]
    movsd [rdx+rcx*8], xmm0
    add r15, 1
.L2293:
    jmp .L2291
.L2292:
    mov rax, r14
    cmp rax, 4
    jb .L2296
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl817:
    lea r8, [rel .kx106]
    call __fail_raise
.kx106:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2296:
    mov rcx, rax
    lea rdx, [rel __g_jc_tq]
    mov rax, [rdx+rcx*8]
    mov rcx, 64
    imul rax, rcx
    mov r13, rax
    mov rax, r14
    cmp rax, 4
    jb .L2297
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl818:
    lea r8, [rel .kx107]
    call __fail_raise
.kx107:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2297:
    mov rcx, rax
    lea rdx, [rel __g_jc_td]
    mov rax, [rdx+rcx*8]
    push rax
    pop rcx
    sub rsp, 32
    call jp_decode
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl819:
    call jp_receive
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call jp_extend
    add rsp, 32
    mov rbx, rax
    mov rax, r14
    cmp rax, 4
    jb .L2298
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl820:
    lea r8, [rel .kx108]
    call __fail_raise
.kx108:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2298:
    push rax
    mov rax, r14
    cmp rax, 4
    jb .L2299
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx109]
    call __fail_raise
.kx109:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2299:
    mov rcx, rax
    lea rdx, [rel __g_jc_pred]
    mov rax, [rdx+rcx*8]
    add rax, rbx
    pop rcx
    lea rdx, [rel __g_jc_pred]
    mov [rdx+rcx*8], rax
    mov rax, 0
    cmp rax, 64
    jb .L2300
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl821:
    lea r8, [rel .kx110]
    call __fail_raise
.kx110:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2300:
    push rax
    mov rax, r14
    cmp rax, 4
    jb .L2301
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx111]
    call __fail_raise
.kx111:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2301:
    mov rcx, rax
    lea rdx, [rel __g_jc_pred]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r13
    cmp rax, 256
    jb .L2302
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx112]
    call __fail_raise
.kx112:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2302:
    mov rcx, rax
    lea rdx, [rel __g_jq]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    cvtsi2sd xmm0, rax
    pop rcx
    lea rdx, [rel __g_jblk]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    mov r15, rax
.L2303:
    mov rax, r15
    mov rcx, 64
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2306
    mov rax, [rel __g_jbad]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2306
    mov rax, 1
    jmp .L2307
.L2306:
    mov rax, 0
.L2307:
    test rax, rax
    jz .L2304
    mov rax, 4
    push rax
    mov rax, r14
    cmp rax, 4
    jb .L2308
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl822:
    lea r8, [rel .kx113]
    call __fail_raise
.kx113:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2308:
    mov rcx, rax
    lea rdx, [rel __g_jc_ta]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call jp_decode
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    sar rax, 4
    mov r12, rax
    mov rax, rbx
    and rax, 15
    mov rbx, rax
    cmp rbx, 0
    jne .L2309
    cmp r12, 15
    je .L2311
    mov rax, 64
    mov r15, rax
    jmp .L2312
.L2311:
    add r15, 16
.L2312:
    jmp .L2310
.L2309:
    add r15, r12
    cmp r15, 64
    jge .L2313
    mov rax, r15
    cmp rax, 64
    jb .L2315
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl823:
    lea r8, [rel .kx114]
    call __fail_raise
.kx114:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2315:
    mov rcx, rax
    lea rdx, [rel __g_jzz]
    mov rax, [rdx+rcx*8]
    cmp rax, 64
    jb .L2316
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx115]
    call __fail_raise
.kx115:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2316:
    push rax
    mov rcx, rbx
    sub rsp, 32
    call jp_receive
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call jp_extend
    add rsp, 32
    push rax
    mov rax, r13
    add rax, r15
    cmp rax, 256
    jb .L2317
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx116]
    call __fail_raise
.kx116:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2317:
    mov rcx, rax
    lea rdx, [rel __g_jq]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    cvtsi2sd xmm0, rax
    pop rcx
    lea rdx, [rel __g_jblk]
    movsd [rdx+rcx*8], xmm0
    jmp .L2314
.L2313:
.L2314:
    add r15, 1
.L2310:
.L2305:
    jmp .L2303
.L2304:
    mov rax, 0
    mov r13, rax
.L2318:
    cmp r13, 8
    jge .L2319
    mov rax, 0
    mov r12, rax
.L2321:
    cmp r12, 8
    jge .L2322
section .data
.flt2324: dq 0.0
section .text
    movsd xmm0, [rel .flt2324]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L2325:
    cmp rbx, 8
    jge .L2326
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    cmp rax, 64
    jb .L2328
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl824:
    lea r8, [rel .kx117]
    call __fail_raise
.kx117:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2328:
    mov rcx, rax
    lea rdx, [rel __g_jcs]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    cmp rax, 64
    jb .L2329
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx118]
    call __fail_raise
.kx118:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2329:
    mov rcx, rax
    lea rdx, [rel __g_jblk]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    add rbx, 1
.L2327:
    jmp .L2325
.L2326:
    mov rax, r13
    mov rcx, 8
    imul rax, rcx
    add rax, r12
    cmp rax, 64
    jb .L2330
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl825:
    lea r8, [rel .kx119]
    call __fail_raise
.kx119:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2330:
    push rax
    movaps xmm0, xmm6
    pop rcx
    lea rdx, [rel __g_jtmp]
    movsd [rdx+rcx*8], xmm0
    add r12, 1
.L2323:
    jmp .L2321
.L2322:
    add r13, 1
.L2320:
    jmp .L2318
.L2319:
    mov rax, r14
    cmp rax, 4
    jb .L2331
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl826:
    lea r8, [rel .kx120]
    call __fail_raise
.kx120:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2331:
    mov rcx, rax
    lea rdx, [rel __g_jc_plane]
    mov rax, [rdx+rcx*8]
    mov r15, rax
    mov rax, r14
    cmp rax, 4
    jb .L2332
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl827:
    lea r8, [rel .kx121]
    call __fail_raise
.kx121:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2332:
    mov rcx, rax
    lea rdx, [rel __g_jc_pw]
    mov rax, [rdx+rcx*8]
    mov r14, rax
    mov rax, 0
    mov r13, rax
.L2333:
    cmp r13, 8
    jge .L2334
    mov rax, 0
    mov r12, rax
.L2336:
    cmp r12, 8
    jge .L2337
section .data
.flt2339: dq 0.0
section .text
    movsd xmm0, [rel .flt2339]
    movaps xmm6, xmm0
    mov rax, 0
    mov rbx, rax
.L2340:
    cmp rbx, 8
    jge .L2341
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    cmp rax, 64
    jb .L2343
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl828:
    lea r8, [rel .kx122]
    call __fail_raise
.kx122:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2343:
    mov rcx, rax
    lea rdx, [rel __g_jcs]
    movsd xmm0, [rdx+rcx*8]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, r13
    cmp rax, 64
    jb .L2344
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx123]
    call __fail_raise
.kx123:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2290
.L2344:
    mov rcx, rax
    lea rdx, [rel __g_jtmp]
    movsd xmm0, [rdx+rcx*8]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    movaps xmm6, xmm0
    add rbx, 1
.L2342:
    jmp .L2340
.L2341:
section .data
.flt2345: dq 128.5
section .text
    movsd xmm0, [rel .flt2345]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    addsd xmm0, xmm1
    cvttsd2si rax, xmm0
    mov rbx, rax
    cmp rbx, 0
    jge .L2346
    mov rax, 0
    mov rbx, rax
    jmp .L2347
.L2346:
.L2347:
    cmp rbx, 255
    jle .L2348
    mov rax, 255
    mov rbx, rax
    jmp .L2349
.L2348:
.L2349:
    mov rax, [rbp-24]
    add rax, r12
    imul rax, r14
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    mov rcx, [rbp-16]
    add rax, rcx
    add rax, r13
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r12, 1
.L2338:
    jmp .L2336
.L2337:
    add r13, 1
.L2335:
    jmp .L2333
.L2334:
    mov rax, 0
    jmp .__ret_2290
.__ret_2290:
    mov rbx, [rbp-240]
    mov r12, [rbp-232]
    mov r13, [rbp-224]
    mov r14, [rbp-216]
    mov r15, [rbp-208]
    movups xmm6, [rbp-200]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq jp_build.kft, .kfe, .kfn, __kron_file_7,13
    dq .kl816,923
    dq .kl817,926
    dq .kl818,927
    dq .kl819,928
    dq .kl820,929
    dq .kl821,930
    dq .kl822,933
    dq .kl823,945
    dq .kl824,958
    dq .kl825,961
    dq .kl826,966
    dq .kl827,967
    dq .kl828,975
.kfn: db "jp_block", 0
section .text
jp_be16:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    movzx rax, byte [rax]
    shl rax, 8
    push rax
    mov rax, r12
    add rax, 1
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_2350
.__ret_2350:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
im_jpeg:
    push rbp
    mov rbp, rsp
    sub rsp, 256
    mov [rbp-224], rbx
    mov [rbp-216], r12
    mov [rbp-208], r13
    mov [rbp-200], r14
    mov [rbp-192], r15
    mov r15, rcx
    mov [rbp-16], rdx
    sub rsp, 32
.kl829:
    call jp_tables
    add rsp, 32
    mov rax, 0
    mov [rel __g_jbad], rax
    mov rax, 0
    mov [rel __g_jn], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 2
    mov r14, rax
    mov rax, 0
    mov rbx, rax
.L2352:
    mov rax, r14
    add rax, 4
    mov rcx, [rbp-16]
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2355
    mov rax, [rel __g_jbad]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2355
    mov rax, 1
    jmp .L2356
.L2355:
    mov rax, 0
.L2356:
    test rax, rax
    jz .L2353
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r15
    add rax, r14
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r15
    add rax, r14
    add rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    cmp r12, 255
    je .L2357
    add r14, 1
    jmp .L2358
.L2357:
    mov rax, rbx
    mov rcx, 216
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2365
    mov rax, rbx
    mov rcx, 208
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2367
    mov rax, rbx
    mov rcx, 215
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2367
    mov rax, 1
    jmp .L2368
.L2367:
    mov rax, 0
.L2368:
    test rax, rax
    jnz .L2365
    mov rax, 0
    jmp .L2366
.L2365:
    mov rax, 1
.L2366:
    test rax, rax
    jnz .L2363
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2363
    mov rax, 0
    jmp .L2364
.L2363:
    mov rax, 1
.L2364:
    test rax, rax
    jnz .L2361
    mov rax, rbx
    mov rcx, 255
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2361
    mov rax, 0
    jmp .L2362
.L2361:
    mov rax, 1
.L2362:
    test rax, rax
    jz .L2359
    add r14, 2
    jmp .L2360
.L2359:
    cmp rbx, 217
    jne .L2369
    mov rax, [rbp-16]
    mov r14, rax
    jmp .L2370
.L2369:
    mov rax, r15
    add rax, r14
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
.kl830:
    call jp_be16
    add rsp, 32
    mov [rbp-80], rax
    mov rax, r15
    add rax, r14
    add rax, 4
    mov r13, rax
    cmp rbx, 219
    jne .L2371
    mov rax, 0
    mov r12, rax
.L2373:
    mov rax, r12
    push rax
    mov rax, [rbp-80]
    sub rax, 2
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2374
    mov rax, 0
    mov [rbp-104], rax
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov [rbp-104], rax
    mov rax, [rbp-104]
    and rax, 3
    mov [rbp-112], rax
    mov rax, 0
    mov rbx, rax
.L2376:
    cmp rbx, 64
    jge .L2377
    mov rax, [rbp-104]
    sar rax, 4
    cmp rax, 0
    jne .L2379
    mov rax, [rbp-112]
    mov rcx, 64
    imul rax, rcx
    add rax, rbx
    cmp rax, 256
    jb .L2381
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl831:
    lea r8, [rel .kx124]
    call __fail_raise
.kx124:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2381:
    push rax
    mov rax, r13
    add rax, r12
    add rax, 1
    add rax, rbx
    movzx rax, byte [rax]
    pop rcx
    lea rdx, [rel __g_jq]
    mov [rdx+rcx*8], rax
    jmp .L2380
.L2379:
    mov rax, [rbp-112]
    mov rcx, 64
    imul rax, rcx
    add rax, rbx
    cmp rax, 256
    jb .L2382
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl832:
    lea r8, [rel .kx125]
    call __fail_raise
.kx125:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2382:
    push rax
    mov rax, r13
    add rax, r12
    add rax, 1
    push rax
    mov rax, rbx
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call jp_be16
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_jq]
    mov [rdx+rcx*8], rax
.L2380:
    add rbx, 1
.L2378:
    jmp .L2376
.L2377:
    mov rax, [rbp-104]
    sar rax, 4
    cmp rax, 0
    jne .L2383
    add r12, 65
    jmp .L2384
.L2383:
    add r12, 129
.L2384:
.L2375:
    jmp .L2373
.L2374:
    jmp .L2372
.L2371:
    mov rax, rbx
    mov rcx, 192
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2387
    mov rax, rbx
    mov rcx, 193
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2387
    mov rax, 0
    jmp .L2388
.L2387:
    mov rax, 1
.L2388:
    test rax, rax
    jz .L2385
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
.kl833:
    call jp_be16
    add rsp, 32
    mov [rbp-32], rax
    mov rax, r13
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
.kl834:
    call jp_be16
    add rsp, 32
    mov [rbp-24], rax
    mov rax, r13
    add rax, 5
    movzx rax, byte [rax]
    mov [rel __g_jn], rax
    mov rax, [rel __g_jn]
    mov rcx, 1
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2395
    mov rax, [rel __g_jn]
    mov rcx, 3
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2395
    mov rax, 1
    jmp .L2396
.L2395:
    mov rax, 0
.L2396:
    test rax, rax
    jnz .L2393
    mov rax, [rbp-24]
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L2393
    mov rax, 0
    jmp .L2394
.L2393:
    mov rax, 1
.L2394:
    test rax, rax
    jnz .L2391
    mov rax, [rbp-32]
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L2391
    mov rax, 0
    jmp .L2392
.L2391:
    mov rax, 1
.L2392:
    test rax, rax
    jz .L2389
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2351
    jmp .L2390
.L2389:
.L2390:
    mov rax, 0
    mov rbx, rax
.L2397:
    mov rax, rbx
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2398
    mov rax, rbx
    cmp rax, 4
    jb .L2400
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl835:
    lea r8, [rel .kx126]
    call __fail_raise
.kx126:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2400:
    push rax
    mov rax, r13
    add rax, 6
    push rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    pop rcx
    lea rdx, [rel __g_jc_id]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2401
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl836:
    lea r8, [rel .kx127]
    call __fail_raise
.kx127:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2401:
    push rax
    mov rax, r13
    add rax, 7
    push rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    sar rax, 4
    pop rcx
    lea rdx, [rel __g_jc_h]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2402
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl837:
    lea r8, [rel .kx128]
    call __fail_raise
.kx128:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2402:
    push rax
    mov rax, r13
    add rax, 7
    push rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    and rax, 15
    pop rcx
    lea rdx, [rel __g_jc_v]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2403
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl838:
    lea r8, [rel .kx129]
    call __fail_raise
.kx129:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2403:
    push rax
    mov rax, r13
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, 3
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    and rax, 3
    pop rcx
    lea rdx, [rel __g_jc_tq]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2399:
    jmp .L2397
.L2398:
    jmp .L2386
.L2385:
    mov rax, rbx
    mov rcx, 194
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2408
    mov rax, rbx
    mov rcx, 195
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2408
    mov rax, 0
    jmp .L2409
.L2408:
    mov rax, 1
.L2409:
    test rax, rax
    jnz .L2406
    mov rax, rbx
    mov rcx, 197
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2414
    mov rax, rbx
    mov rcx, 207
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2414
    mov rax, 1
    jmp .L2415
.L2414:
    mov rax, 0
.L2415:
    test rax, rax
    jz .L2412
    mov rax, rbx
    mov rcx, 200
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2412
    mov rax, 1
    jmp .L2413
.L2412:
    mov rax, 0
.L2413:
    test rax, rax
    jz .L2410
    mov rax, rbx
    mov rcx, 204
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L2410
    mov rax, 1
    jmp .L2411
.L2410:
    mov rax, 0
.L2411:
    test rax, rax
    jnz .L2406
    mov rax, 0
    jmp .L2407
.L2406:
    mov rax, 1
.L2407:
    test rax, rax
    jz .L2404
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2351
    jmp .L2405
.L2404:
    cmp rbx, 196
    jne .L2416
    mov rax, 0
    mov r12, rax
.L2418:
    mov rax, r12
    push rax
    mov rax, [rbp-80]
    sub rax, 2
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2419
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    sar rax, 4
    mov rcx, 4
    imul rax, rcx
    push rax
    mov rax, rbx
    and rax, 3
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-152], rax
    mov rax, 0
    mov [rbp-160], rax
    mov rax, 1
    mov rbx, rax
.L2421:
    cmp rbx, 16
    jg .L2422
    mov rax, [rbp-152]
    mov rcx, 17
    imul rax, rcx
    add rax, rbx
    cmp rax, 136
    jb .L2424
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl839:
    lea r8, [rel .kx130]
    call __fail_raise
.kx130:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2424:
    push rax
    mov rax, r13
    add rax, r12
    add rax, rbx
    movzx rax, byte [rax]
    pop rcx
    lea rdx, [rel __g_jh_count]
    mov [rdx+rcx*8], rax
    mov rax, [rbp-160]
    push rax
    mov rax, [rbp-152]
    mov rcx, 17
    imul rax, rcx
    add rax, rbx
    cmp rax, 136
    jb .L2425
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl840:
    lea r8, [rel .kx131]
    call __fail_raise
.kx131:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2425:
    mov rcx, rax
    lea rdx, [rel __g_jh_count]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-160], rax
    add rbx, 1
.L2423:
    jmp .L2421
.L2422:
    mov rax, 0
    mov rbx, rax
.L2426:
    mov rax, rbx
    mov rcx, [rbp-160]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2429
    mov rax, rbx
    mov rcx, 256
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2429
    mov rax, 1
    jmp .L2430
.L2429:
    mov rax, 0
.L2430:
    test rax, rax
    jz .L2427
    mov rax, [rbp-152]
    mov rcx, 256
    imul rax, rcx
    add rax, rbx
    cmp rax, 2048
    jb .L2431
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl841:
    lea r8, [rel .kx132]
    call __fail_raise
.kx132:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2351
.L2431:
    push rax
    mov rax, r13
    add rax, r12
    add rax, 17
    add rax, rbx
    movzx rax, byte [rax]
    pop rcx
    lea rdx, [rel __g_jh_val]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2428:
    jmp .L2426
.L2427:
    mov rcx, [rbp-152]
    sub rsp, 32
.kl842:
    call jp_build
    add rsp, 32
    mov rax, r12
    add rax, 17
    mov rcx, [rbp-160]
    add rax, rcx
    mov r12, rax
.L2420:
    jmp .L2418
.L2419:
    jmp .L2417
.L2416:
    cmp rbx, 221
    jne .L2432
    mov rcx, r13
    sub rsp, 32
.kl843:
    call jp_be16
    add rsp, 32
    mov [rbp-40], rax
    jmp .L2433
.L2432:
    cmp rbx, 218
    jne .L2434
    mov rcx, r15
    mov rdx, [rbp-16]
    mov r8, r13
    mov r9, [rbp-24]
    mov r10, [rbp-32]
    mov rax, [rbp-40]
    sub rsp, 32
.kl844:
    call jp_scan
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_2351
    jmp .L2435
.L2434:
.L2435:
.L2433:
.L2417:
.L2405:
.L2386:
.L2372:
    mov rax, r14
    add rax, 2
    mov rcx, [rbp-80]
    add rax, rcx
    mov r14, rax
.L2370:
.L2360:
.L2358:
.L2354:
    jmp .L2352
.L2353:
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2351
.__ret_2351:
    mov rbx, [rbp-224]
    mov r12, [rbp-216]
    mov r13, [rbp-208]
    mov r14, [rbp-200]
    mov r15, [rbp-192]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq jp_block.kft, .kfe, .kfn, __kron_file_7,16
    dq .kl829,996
    dq .kl830,1018
    dq .kl831,1030
    dq .kl832,1032
    dq .kl833,1040
    dq .kl834,1041
    dq .kl835,1051
    dq .kl836,1052
    dq .kl837,1053
    dq .kl838,1054
    dq .kl839,1070
    dq .kl840,1071
    dq .kl841,1076
    dq .kl842,1079
    dq .kl843,1083
    dq .kl844,1085
.kfn: db "im_jpeg", 0
section .text
jp_scan:
    push rbp
    mov rbp, rsp
    sub rsp, 352
    mov [rbp-320], rbx
    mov [rbp-312], r12
    mov [rbp-304], r13
    mov [rbp-296], r14
    mov [rbp-288], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov r13, r8
    mov [rbp-32], r9
    mov [rbp-40], r10
    mov [rbp-48], rax
    mov rax, 0
    mov r12, rax
    mov rax, r13
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L2439
    mov rax, [rbp-32]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2439
    mov rax, 0
    jmp .L2440
.L2439:
    mov rax, 1
.L2440:
    test rax, rax
    jz .L2437
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2436
    jmp .L2438
.L2437:
.L2438:
    mov rax, 0
    mov r14, rax
.L2441:
    cmp r14, r12
    jge .L2442
    mov rax, 0
    mov [rbp-72], rax
    mov rax, 0
    mov r15, rax
    mov rax, r13
    add rax, 1
    push rax
    mov rax, r14
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    mov [rbp-72], rax
    mov rax, r13
    add rax, 2
    push rax
    mov rax, r14
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    movzx rax, byte [rax]
    mov r15, rax
    mov rax, 0
    mov rbx, rax
.L2444:
    mov rax, rbx
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2445
    mov rax, rbx
    cmp rax, 4
    jb .L2449
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl845:
    lea r8, [rel .kx133]
    call __fail_raise
.kx133:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2449:
    mov rcx, rax
    lea rdx, [rel __g_jc_id]
    mov rax, [rdx+rcx*8]
    mov rcx, [rbp-72]
    cmp rax, rcx
    jne .L2447
    mov rax, rbx
    cmp rax, 4
    jb .L2450
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl846:
    lea r8, [rel .kx134]
    call __fail_raise
.kx134:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2450:
    push rax
    mov rax, r15
    sar rax, 4
    pop rcx
    lea rdx, [rel __g_jc_td]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2451
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl847:
    lea r8, [rel .kx135]
    call __fail_raise
.kx135:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2451:
    push rax
    mov rax, r15
    and rax, 15
    pop rcx
    lea rdx, [rel __g_jc_ta]
    mov [rdx+rcx*8], rax
    jmp .L2448
.L2447:
.L2448:
    add rbx, 1
.L2446:
    jmp .L2444
.L2445:
    add r14, 1
.L2443:
    jmp .L2441
.L2442:
    mov rax, 1
    mov r15, rax
    mov rax, 1
    mov r14, rax
    mov rax, 0
    mov rbx, rax
.L2452:
    mov rax, rbx
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2453
    mov rax, [rel __g_jn]
    cmp rax, 1
    jne .L2455
    mov rax, rbx
    cmp rax, 4
    jb .L2457
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl848:
    lea r8, [rel .kx136]
    call __fail_raise
.kx136:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2457:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_jc_h]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2458
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx137]
    call __fail_raise
.kx137:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2458:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_jc_v]
    mov [rdx+rcx*8], rax
    jmp .L2456
.L2455:
.L2456:
    mov rax, rbx
    cmp rax, 4
    jb .L2461
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl849:
    lea r8, [rel .kx138]
    call __fail_raise
.kx138:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2461:
    mov rcx, rax
    lea rdx, [rel __g_jc_h]
    mov rax, [rdx+rcx*8]
    cmp rax, r15
    jle .L2459
    mov rax, rbx
    cmp rax, 4
    jb .L2462
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx139]
    call __fail_raise
.kx139:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2462:
    mov rcx, rax
    lea rdx, [rel __g_jc_h]
    mov rax, [rdx+rcx*8]
    mov r15, rax
    jmp .L2460
.L2459:
.L2460:
    mov rax, rbx
    cmp rax, 4
    jb .L2465
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl850:
    lea r8, [rel .kx140]
    call __fail_raise
.kx140:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2465:
    mov rcx, rax
    lea rdx, [rel __g_jc_v]
    mov rax, [rdx+rcx*8]
    cmp rax, r14
    jle .L2463
    mov rax, rbx
    cmp rax, 4
    jb .L2466
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx141]
    call __fail_raise
.kx141:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2466:
    mov rcx, rax
    lea rdx, [rel __g_jc_v]
    mov rax, [rdx+rcx*8]
    mov r14, rax
    jmp .L2464
.L2463:
.L2464:
    add rbx, 1
.L2454:
    jmp .L2452
.L2453:
    mov rax, 8
    imul rax, r15
    mov rcx, rax
    mov rax, [rbp-32]
    add rax, rcx
    sub rax, 1
    push rax
    mov rax, 8
    imul rax, r15
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov [rbp-120], rax
    mov rax, 8
    imul rax, r14
    mov rcx, rax
    mov rax, [rbp-40]
    add rax, rcx
    sub rax, 1
    push rax
    mov rax, 8
    imul rax, r14
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov [rbp-128], rax
    mov rax, 0
    mov rbx, rax
.L2467:
    mov rax, rbx
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2468
    mov rax, rbx
    cmp rax, 4
    jb .L2470
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl851:
    lea r8, [rel .kx142]
    call __fail_raise
.kx142:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2470:
    push rax
    mov rax, [rbp-120]
    push rax
    mov rax, rbx
    cmp rax, 4
    jb .L2471
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx143]
    call __fail_raise
.kx143:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2471:
    mov rcx, rax
    lea rdx, [rel __g_jc_h]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, 8
    imul rax, rcx
    pop rcx
    lea rdx, [rel __g_jc_pw]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2472
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl852:
    lea r8, [rel .kx144]
    call __fail_raise
.kx144:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2472:
    push rax
    mov rax, rbx
    cmp rax, 4
    jb .L2473
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx145]
    call __fail_raise
.kx145:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2473:
    mov rcx, rax
    lea rdx, [rel __g_jc_pw]
    mov rax, [rdx+rcx*8]
    mov rcx, [rbp-128]
    imul rax, rcx
    push rax
    mov rax, rbx
    cmp rax, 4
    jb .L2474
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx146]
    call __fail_raise
.kx146:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2474:
    mov rcx, rax
    lea rdx, [rel __g_jc_v]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, 8
    imul rax, rcx
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call hp_alloc
    add rsp, 32
    pop rcx
    lea rdx, [rel __g_jc_plane]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2475
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl853:
    lea r8, [rel .kx147]
    call __fail_raise
.kx147:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2475:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_jc_pred]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 4
    jb .L2478
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl854:
    lea r8, [rel .kx148]
    call __fail_raise
.kx148:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2478:
    mov rcx, rax
    lea rdx, [rel __g_jc_plane]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    jne .L2476
    mov rax, 0
    jmp .__ret_2436
    jmp .L2477
.L2476:
.L2477:
    add rbx, 1
.L2469:
    jmp .L2467
.L2468:
    mov rax, r13
    add rax, 1
    push rax
    mov rax, r12
    mov rcx, 2
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 3
    mov [rel __g_jpos], rax
    mov rax, [rbp-8]
    mov rcx, [rbp-16]
    add rax, rcx
    mov [rel __g_jend], rax
    mov rax, 0
    mov [rel __g_jnbits], rax
    mov rax, 0
    mov [rbp-136], rax
    mov rax, 0
    mov [rbp-144], rax
.L2479:
    mov rax, [rbp-144]
    mov rcx, [rbp-128]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2482
    mov rax, [rel __g_jbad]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2482
    mov rax, 1
    jmp .L2483
.L2482:
    mov rax, 0
.L2483:
    test rax, rax
    jz .L2480
    mov rax, 0
    mov [rbp-152], rax
.L2484:
    mov rax, [rbp-152]
    mov rcx, [rbp-120]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2487
    mov rax, [rel __g_jbad]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2487
    mov rax, 1
    jmp .L2488
.L2487:
    mov rax, 0
.L2488:
    test rax, rax
    jz .L2485
    mov rax, [rbp-48]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L2493
    mov rax, [rbp-136]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L2493
    mov rax, 1
    jmp .L2494
.L2493:
    mov rax, 0
.L2494:
    test rax, rax
    jz .L2491
    mov rax, [rbp-136]
    mov rcx, [rbp-48]
    cqo
    idiv rcx
    mov rax, rdx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2491
    mov rax, 1
    jmp .L2492
.L2491:
    mov rax, 0
.L2492:
    test rax, rax
    jz .L2489
    mov rax, 0
    mov [rel __g_jnbits], rax
.L2495:
    mov rax, [rel __g_jpos]
    add rax, 1
    push rax
    mov rax, [rel __g_jend]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2498
    mov rax, [rel __g_jpos]
    push rax
    pop rcx
    sub rsp, 32
.kl855:
    call jp_peek
    add rsp, 32
    mov rcx, 255
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2502
    mov rax, [rel __g_jpos]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call jp_peek
    add rsp, 32
    mov rcx, 208
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2502
    mov rax, 1
    jmp .L2503
.L2502:
    mov rax, 0
.L2503:
    test rax, rax
    jz .L2500
    mov rax, [rel __g_jpos]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call jp_peek
    add rsp, 32
    mov rcx, 215
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2500
    mov rax, 1
    jmp .L2501
.L2500:
    mov rax, 0
.L2501:
    test rax, rax
    sete al
    movzx rax, al
    test rax, rax
    jz .L2498
    mov rax, 1
    jmp .L2499
.L2498:
    mov rax, 0
.L2499:
    test rax, rax
    jz .L2496
    mov rax, [rel __g_jpos]
    add rax, 1
    mov [rel __g_jpos], rax
.L2497:
    jmp .L2495
.L2496:
    mov rax, [rel __g_jpos]
    add rax, 2
    mov [rel __g_jpos], rax
    mov rax, 0
    mov rbx, rax
.L2504:
    mov rax, rbx
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2505
    mov rax, rbx
    cmp rax, 4
    jb .L2507
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl856:
    lea r8, [rel .kx149]
    call __fail_raise
.kx149:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2507:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_jc_pred]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L2506:
    jmp .L2504
.L2505:
    jmp .L2490
.L2489:
.L2490:
    mov rax, 0
    mov r12, rax
.L2508:
    mov rax, r12
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2509
    mov rax, 0
    mov r13, rax
.L2511:
    mov rax, r13
    push rax
    mov rax, r12
    cmp rax, 4
    jb .L2514
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl857:
    lea r8, [rel .kx150]
    call __fail_raise
.kx150:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2514:
    mov rcx, rax
    lea rdx, [rel __g_jc_v]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2512
    mov rax, 0
    mov rbx, rax
.L2515:
    mov rax, rbx
    push rax
    mov rax, r12
    cmp rax, 4
    jb .L2518
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl858:
    lea r8, [rel .kx151]
    call __fail_raise
.kx151:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2518:
    mov rcx, rax
    lea rdx, [rel __g_jc_h]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2516
    mov rax, r12
    push rax
    mov rax, [rbp-152]
    push rax
    mov rax, r12
    cmp rax, 4
    jb .L2519
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl859:
    lea r8, [rel .kx152]
    call __fail_raise
.kx152:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2519:
    mov rcx, rax
    lea rdx, [rel __g_jc_h]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    push rax
    mov rax, [rbp-144]
    push rax
    mov rax, r12
    cmp rax, 4
    jb .L2520
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx153]
    call __fail_raise
.kx153:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2520:
    mov rcx, rax
    lea rdx, [rel __g_jc_v]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    add rax, r13
    mov rcx, 8
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call jp_block
    add rsp, 32
    add rbx, 1
.L2517:
    jmp .L2515
.L2516:
    add r13, 1
.L2513:
    jmp .L2511
.L2512:
    add r12, 1
.L2510:
    jmp .L2508
.L2509:
    mov rax, [rbp-136]
    add rax, 1
    mov [rbp-136], rax
    mov rax, [rbp-152]
    add rax, 1
    mov [rbp-152], rax
.L2486:
    jmp .L2484
.L2485:
    mov rax, [rbp-144]
    add rax, 1
    mov [rbp-144], rax
.L2481:
    jmp .L2479
.L2480:
    mov rcx, [rbp-32]
    mov rdx, [rbp-40]
    sub rsp, 32
.kl860:
    call im_new
    add rsp, 32
    mov [rbp-192], rax
    mov rax, [rbp-192]
    cmp rax, 0
    je .L2521
    mov rcx, [rbp-192]
    sub rsp, 32
.kl861:
    call im_block
    add rsp, 32
    mov [rbp-200], rax
    mov rax, 0
    mov r13, rax
.L2523:
    mov rax, r13
    mov rcx, [rbp-40]
    cmp rax, rcx
    jge .L2524
    mov rax, 0
    mov r12, rax
.L2526:
    mov rax, r12
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L2527
    mov rcx, 0
    mov rdx, r12
    mov r8, r13
    mov r9, r15
    mov r10, r14
    sub rsp, 32
.kl862:
    call jp_sample
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rbp-232], rax
    mov rax, [rel __g_jn]
    cmp rax, 1
    jne .L2529
    mov rax, rbx
    shl rax, 16
    push rax
    mov rax, rbx
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    mov [rbp-232], rax
    jmp .L2530
.L2529:
    mov rcx, 1
    mov rdx, r12
    mov r8, r13
    mov r9, r15
    mov r10, r14
    sub rsp, 32
.kl863:
    call jp_sample
    add rsp, 32
    sub rax, 128
    mov [rbp-240], rax
    mov rcx, 2
    mov rdx, r12
    mov r8, r13
    mov r9, r15
    mov r10, r14
    sub rsp, 32
.kl864:
    call jp_sample
    add rsp, 32
    sub rax, 128
    mov [rbp-248], rax
    mov rax, 91881
    mov rcx, [rbp-248]
    imul rax, rcx
    add rax, 32768
    sar rax, 16
    mov rcx, rax
    mov rax, rbx
    add rax, rcx
    mov [rbp-256], rax
    mov rax, 22554
    mov rcx, [rbp-240]
    imul rax, rcx
    push rax
    mov rax, 46802
    mov rcx, [rbp-248]
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, 32768
    sar rax, 16
    mov rcx, rax
    mov rax, rbx
    sub rax, rcx
    mov [rbp-264], rax
    mov rax, 116130
    mov rcx, [rbp-240]
    imul rax, rcx
    add rax, 32768
    sar rax, 16
    mov rcx, rax
    mov rax, rbx
    add rax, rcx
    mov rbx, rax
    mov rax, [rbp-256]
    cmp rax, 0
    jge .L2531
    mov rax, 0
    mov [rbp-256], rax
    jmp .L2532
.L2531:
.L2532:
    mov rax, [rbp-256]
    cmp rax, 255
    jle .L2533
    mov rax, 255
    mov [rbp-256], rax
    jmp .L2534
.L2533:
.L2534:
    mov rax, [rbp-264]
    cmp rax, 0
    jge .L2535
    mov rax, 0
    mov [rbp-264], rax
    jmp .L2536
.L2535:
.L2536:
    mov rax, [rbp-264]
    cmp rax, 255
    jle .L2537
    mov rax, 255
    mov [rbp-264], rax
    jmp .L2538
.L2537:
.L2538:
    cmp rbx, 0
    jge .L2539
    mov rax, 0
    mov rbx, rax
    jmp .L2540
.L2539:
.L2540:
    cmp rbx, 255
    jle .L2541
    mov rax, 255
    mov rbx, rax
    jmp .L2542
.L2541:
.L2542:
    mov rax, [rbp-256]
    shl rax, 16
    push rax
    mov rax, [rbp-264]
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    or rax, rbx
    mov [rbp-232], rax
.L2530:
    mov rax, [rbp-200]
    add rax, 16
    push rax
    mov rax, r13
    mov rcx, [rbp-32]
    imul rax, rcx
    add rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0xFF000000
    mov rcx, [rbp-232]
    or rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    add r12, 1
.L2528:
    jmp .L2526
.L2527:
    add r13, 1
.L2525:
    jmp .L2523
.L2524:
    jmp .L2522
.L2521:
.L2522:
    mov rax, 0
    mov rbx, rax
.L2543:
    mov rax, rbx
    push rax
    mov rax, [rel __g_jn]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2544
    mov rax, rbx
    cmp rax, 4
    jb .L2546
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl865:
    lea r8, [rel .kx154]
    call __fail_raise
.kx154:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2436
.L2546:
    mov rcx, rax
    lea rdx, [rel __g_jc_plane]
    mov rax, [rdx+rcx*8]
    push rax
    pop rcx
    sub rsp, 32
    call hp_release
    add rsp, 32
    add rbx, 1
.L2545:
    jmp .L2543
.L2544:
    mov rax, [rbp-192]
    jmp .__ret_2436
.__ret_2436:
    mov rbx, [rbp-320]
    mov r12, [rbp-312]
    mov r13, [rbp-304]
    mov r14, [rbp-296]
    mov r15, [rbp-288]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_jpeg.kft, .kfe, .kfn, __kron_file_7,21
    dq .kl845,1113
    dq .kl846,1114
    dq .kl847,1115
    dq .kl848,1125
    dq .kl849,1126
    dq .kl850,1127
    dq .kl851,1134
    dq .kl852,1135
    dq .kl853,1136
    dq .kl854,1137
    dq .kl855,1151
    dq .kl856,1157
    dq .kl857,1164
    dq .kl858,1166
    dq .kl859,1167
    dq .kl860,1179
    dq .kl861,1181
    dq .kl862,1186
    dq .kl863,1191
    dq .kl864,1192
    dq .kl865,1210
.kfn: db "jp_scan", 0
section .text
jp_peek:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_2547
.__ret_2547:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
jp_sample:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov r14, rcx
    mov r13, rdx
    mov r15, r8
    mov r12, r9
    mov rbx, r10
    mov rax, r13
    push rax
    mov rax, r14
    cmp rax, 4
    jb .L2549
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl866:
    lea r8, [rel .kx155]
    call __fail_raise
.kx155:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2548
.L2549:
    mov rcx, rax
    lea rdx, [rel __g_jc_h]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, r12
    cqo
    idiv rcx
    mov r13, rax
    mov rax, r15
    push rax
    mov rax, r14
    cmp rax, 4
    jb .L2550
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl867:
    lea r8, [rel .kx156]
    call __fail_raise
.kx156:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2548
.L2550:
    mov rcx, rax
    lea rdx, [rel __g_jc_v]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rbx
    cqo
    idiv rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r14
    cmp rax, 4
    jb .L2551
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl868:
    lea r8, [rel .kx157]
    call __fail_raise
.kx157:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2548
.L2551:
    mov rcx, rax
    lea rdx, [rel __g_jc_plane]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r12
    push rax
    mov rax, r14
    cmp rax, 4
    jb .L2552
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx158]
    call __fail_raise
.kx158:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2548
.L2552:
    mov rcx, rax
    lea rdx, [rel __g_jc_pw]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r13
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_2548
.__ret_2548:
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
.kft: dq jp_scan.kft, .kfe, .kfn, __kron_file_7,3
    dq .kl866,1223
    dq .kl867,1224
    dq .kl868,1226
.kfn: db "jp_sample", 0
section .text
im_decode_any:
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
    mov rax, 0
    mov rbx, rax
    cmp r13, 2
    jge .L2554
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2553
    jmp .L2555
.L2554:
.L2555:
    mov rax, r14
    movzx rax, byte [rax]
    mov r12, rax
    mov rax, r14
    add rax, 1
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, r13
    mov rcx, 8
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2560
    mov rax, r12
    mov rcx, 137
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2560
    mov rax, 1
    jmp .L2561
.L2560:
    mov rax, 0
.L2561:
    test rax, rax
    jz .L2558
    mov rax, rbx
    mov rcx, 80
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2558
    mov rax, 1
    jmp .L2559
.L2558:
    mov rax, 0
.L2559:
    test rax, rax
    jz .L2556
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
.kl869:
    call im_png
    add rsp, 32
    jmp .__ret_2553
    jmp .L2557
.L2556:
.L2557:
    mov rax, r12
    mov rcx, 66
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2564
    mov rax, rbx
    mov rcx, 77
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2564
    mov rax, 1
    jmp .L2565
.L2564:
    mov rax, 0
.L2565:
    test rax, rax
    jz .L2562
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
.kl870:
    call im_bmp
    add rsp, 32
    jmp .__ret_2553
    jmp .L2563
.L2562:
.L2563:
    mov rax, r13
    mov rcx, 4
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2570
    mov rax, r12
    mov rcx, 255
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2570
    mov rax, 1
    jmp .L2571
.L2570:
    mov rax, 0
.L2571:
    test rax, rax
    jz .L2568
    mov rax, rbx
    mov rcx, 216
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2568
    mov rax, 1
    jmp .L2569
.L2568:
    mov rax, 0
.L2569:
    test rax, rax
    jz .L2566
    mov rcx, r14
    mov rdx, r13
    sub rsp, 32
.kl871:
    call im_jpeg
    add rsp, 32
    jmp .__ret_2553
    jmp .L2567
.L2566:
.L2567:
    mov rax, 17
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2553
.__ret_2553:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq jp_sample.kft, .kfe, .kfn, __kron_file_7,3
    dq .kl869,1245
    dq .kl870,1248
    dq .kl871,1251
.kfn: db "im_decode_any", 0
section .text
image_load:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
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
.kl872:
    call fl_read_all
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    je .L2573
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl873:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, r12
    add rax, 8
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl874:
    call im_decode_any
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
.kl875:
    call ob_drop
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl876:
    call hp_release
    add rsp, 32
    jmp .L2574
.L2573:
.L2574:
    mov rcx, rbx
    sub rsp, 32
.kl877:
    call text_end
    add rsp, 32
    jmp .__ret_2572
.__ret_2572:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_decode_any.kft, .kfe, .kfn, __kron_file_7,6
    dq .kl872,1260
    dq .kl873,1262
    dq .kl874,1265
    dq .kl875,1266
    dq .kl876,1267
    dq .kl877,1269
.kfn: db "image_load", 0
section .text
image_from_bytes:
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
.kl878:
    call im_decode_any
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_2575
.__ret_2575:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_load.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl878,1275
.kfn: db "image_from_bytes", 0
section .text
image_new:
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
.kl879:
    call im_new
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_2576
.__ret_2576:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_from_bytes.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl879,1280
.kfn: db "image_new", 0
section .text
image_free:
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
    mov rcx, r12
    sub rsp, 32
.kl880:
    call im_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L2578
    mov rcx, r12
    sub rsp, 32
.kl881:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl882:
    call hp_release
    add rsp, 32
    jmp .L2579
.L2578:
.L2579:
    mov rcx, 0
    sub rsp, 32
.kl883:
    call text_end
    add rsp, 32
    jmp .__ret_2577
.__ret_2577:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_new.kft, .kfe, .kfn, __kron_file_7,4
    dq .kl880,1285
    dq .kl881,1287
    dq .kl882,1288
    dq .kl883,1290
.kfn: db "image_free", 0
section .text
image_width:
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
    mov rcx, rbx
    sub rsp, 32
.kl884:
    call im_block
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L2581
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    jmp .L2582
.L2581:
.L2582:
    mov rcx, rbx
    sub rsp, 32
.kl885:
    call text_end
    add rsp, 32
    jmp .__ret_2580
.__ret_2580:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_free.kft, .kfe, .kfn, __kron_file_7,2
    dq .kl884,1295
    dq .kl885,1300
.kfn: db "image_width", 0
section .text
image_height:
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
    mov rcx, rbx
    sub rsp, 32
.kl886:
    call im_block
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L2584
    mov rax, r12
    add rax, 8
    mov rax, [rax]
    mov rbx, rax
    jmp .L2585
.L2584:
.L2585:
    mov rcx, rbx
    sub rsp, 32
.kl887:
    call text_end
    add rsp, 32
    jmp .__ret_2583
.__ret_2583:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_width.kft, .kfe, .kfn, __kron_file_7,2
    dq .kl886,1305
    dq .kl887,1310
.kfn: db "image_height", 0
section .text
im_at:
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
    mov r14, r8
    mov rcx, rbx
    sub rsp, 32
.kl888:
    call im_block
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L2587
    mov rax, 0
    jmp .__ret_2586
    jmp .L2588
.L2587:
.L2588:
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
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L2595
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L2595
    mov rax, 0
    jmp .L2596
.L2595:
    mov rax, 1
.L2596:
    test rax, rax
    jnz .L2593
    mov rax, r15
    mov rcx, r12
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L2593
    mov rax, 0
    jmp .L2594
.L2593:
    mov rax, 1
.L2594:
    test rax, rax
    jnz .L2591
    mov rax, r14
    mov rcx, rbx
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L2591
    mov rax, 0
    jmp .L2592
.L2591:
    mov rax, 1
.L2592:
    test rax, rax
    jz .L2589
    mov rax, 5
    mov [rel __g_hp_err], rax
    mov rax, 0
    jmp .__ret_2586
    jmp .L2590
.L2589:
.L2590:
    mov rax, r13
    add rax, 16
    push rax
    mov rax, r14
    imul rax, r12
    add rax, r15
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_2586
.__ret_2586:
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
.kft: dq image_height.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl888,1315
.kfn: db "im_at", 0
section .text
image_get:
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
    mov r8, rbx
    sub rsp, 32
.kl889:
    call im_at
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    je .L2598
    mov rax, r12
    mov eax, dword [rax]
    mov rbx, rax
    jmp .L2599
.L2598:
.L2599:
    mov rcx, rbx
    sub rsp, 32
.kl890:
    call text_end
    add rsp, 32
    jmp .__ret_2597
.__ret_2597:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_at.kft, .kfe, .kfn, __kron_file_7,2
    dq .kl889,1334
    dq .kl890,1339
.kfn: db "image_get", 0
section .text
image_set:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov rbx, r8
    mov r12, r9
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, r14
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
.kl891:
    call im_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L2601
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    jmp .L2602
.L2601:
.L2602:
    mov rcx, r12
    sub rsp, 32
.kl892:
    call text_end
    add rsp, 32
    jmp .__ret_2600
.__ret_2600:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_get.kft, .kfe, .kfn, __kron_file_7,2
    dq .kl891,1344
    dq .kl892,1348
.kfn: db "image_set", 0
section .text
im_pixels:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl893:
    call im_block
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L2604
    mov rax, 0
    jmp .__ret_2603
    jmp .L2605
.L2604:
.L2605:
    mov rax, rbx
    jmp .__ret_2603
.__ret_2603:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_set.kft, .kfe, .kfn, __kron_file_7,1
    dq .kl893,1353
.kfn: db "im_pixels", 0
section .text
image_save_bmp:
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
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl894:
    call im_block
    add rsp, 32
    mov [rbp-24], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-24]
    cmp rax, 0
    je .L2607
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, [rbp-24]
    mov rax, [rax]
    mov r15, rax
    mov rax, [rbp-24]
    add rax, 8
    mov rax, [rax]
    mov r14, rax
    mov rax, r15
    imul rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, 54
    add rax, rcx
    mov [rbp-56], rax
    mov rcx, [rbp-56]
    sub rsp, 32
.kl895:
    call tx_new
    add rsp, 32
    mov [rbp-64], rax
    mov rax, [rbp-64]
    cmp rax, 0
    je .L2609
    mov rax, [rbp-64]
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl896:
    call ob_get
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    add rax, 8
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, 66
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r13
    add rax, 1
    push rax
    mov rax, 77
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r13
    add rax, 2
    push rax
    mov rax, [rbp-56]
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 6
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 10
    push rax
    mov rax, 54
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 14
    push rax
    mov rax, 40
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 18
    push rax
    mov rax, r15
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 22
    push rax
    mov rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 26
    push rax
    mov rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, r13
    add rax, 28
    push rax
    mov rax, 32
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, r13
    add rax, 30
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 34
    push rax
    mov rax, r15
    imul rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 38
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 42
    push rax
    mov rax, 2835
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 46
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 50
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, 0
    mov r12, rax
.L2611:
    cmp r12, r14
    jge .L2612
    mov rax, 0
    mov rbx, rax
.L2614:
    cmp rbx, r15
    jge .L2615
    mov rax, [rbp-24]
    add rax, 16
    push rax
    mov rax, r14
    sub rax, 1
    sub rax, r12
    imul rax, r15
    add rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov eax, dword [rax]
    mov [rbp-104], rax
    mov rax, r13
    add rax, 54
    push rax
    mov rax, r12
    imul rax, r15
    add rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rbp-104]
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    add rbx, 1
.L2616:
    jmp .L2614
.L2615:
    add r12, 1
.L2613:
    jmp .L2611
.L2612:
    mov rax, [rbp-72]
    push rax
    mov rax, [rbp-56]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rcx, [rbp-16]
    mov rdx, [rbp-64]
    mov r8, 8
    sub rsp, 32
.kl897:
    call fl_put
    add rsp, 32
    mov rbx, rax
    mov rcx, [rbp-64]
    sub rsp, 32
.kl898:
    call ob_drop
    add rsp, 32
    mov rcx, [rbp-72]
    sub rsp, 32
.kl899:
    call hp_release
    add rsp, 32
    jmp .L2610
.L2609:
.L2610:
    jmp .L2608
.L2607:
.L2608:
    mov rcx, rbx
    sub rsp, 32
.kl900:
    call text_end
    add rsp, 32
    jmp .__ret_2606
.__ret_2606:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq im_pixels.kft, .kfe, .kfn, __kron_file_7,7
    dq .kl894,1362
    dq .kl895,1372
    dq .kl896,1374
    dq .kl897,1405
    dq .kl898,1406
    dq .kl899,1407
    dq .kl900,1410
.kfn: db "image_save_bmp", 0
section .text
radians:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    movups [rbp-32], xmm6
    movaps xmm6, xmm0
section .data
.flt2618: dq 0.017453292519943295
section .text
    movsd xmm0, [rel .flt2618]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_2617
.__ret_2617:
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
.flt2620: dq 57.29577951308232
section .text
    movsd xmm0, [rel .flt2620]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    jmp .__ret_2619
.__ret_2619:
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
    jmp .__ret_2621
.__ret_2621:
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
.kl901:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2622
.__ret_2622:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq image_save_bmp.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl901,44
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
.kl902:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2623
.__ret_2623:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_add.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl902,45
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
.kl903:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2624
.__ret_2624:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_sub.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl903,46
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
    jmp .__ret_2625
.__ret_2625:
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
.kl904:
    call fsqrt
    add rsp, 32
    jmp .__ret_2626
.__ret_2626:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_scale.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl904,48
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
.kl905:
    call v2_len
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2630: dq 0.0
section .text
    movsd xmm0, [rel .flt2630]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2628
section .data
.flt2631: dq 0.0
section .text
    movsd xmm0, [rel .flt2631]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2632: dq 0.0
section .text
    movsd xmm0, [rel .flt2632]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl906:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2627
    jmp .L2629
.L2628:
.L2629:
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
.kl907:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2627
.__ret_2627:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_len.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl905,50
    dq .kl906,51
    dq .kl907,52
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
.kl908:
    mov r11, [rbp-8]
    call v2
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2633
.__ret_2633:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_norm.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl908,54
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
    jmp .__ret_2634
.__ret_2634:
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
.kl909:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2635
.__ret_2635:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v2_lerp.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl909,58
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
.kl910:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2636
.__ret_2636:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_add.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl910,59
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
.kl911:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2637
.__ret_2637:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_sub.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl911,60
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
.kl912:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2638
.__ret_2638:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_mul.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl912,61
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
.flt2640: dq 0.0
section .text
    movsd xmm0, [rel .flt2640]
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
.flt2641: dq 0.0
section .text
    movsd xmm0, [rel .flt2641]
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
.flt2642: dq 0.0
section .text
    movsd xmm0, [rel .flt2642]
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
.kl913:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2639
.__ret_2639:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_scale.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl913,62
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
    jmp .__ret_2643
.__ret_2643:
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
.kl914:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2644
.__ret_2644:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_neg.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl914,65
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
    jmp .__ret_2645
.__ret_2645:
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
.kl915:
    call fsqrt
    add rsp, 32
    jmp .__ret_2646
.__ret_2646:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_cross.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl915,68
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
.kl916:
    lea r11, [rbp-48]
    call v3_sub
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call v3_len
    add rsp, 32
    jmp .__ret_2647
.__ret_2647:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_len.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl916,69
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
.kl917:
    call v3_len
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2651: dq 0.0
section .text
    movsd xmm0, [rel .flt2651]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2649
section .data
.flt2652: dq 0.0
section .text
    movsd xmm0, [rel .flt2652]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2653: dq 0.0
section .text
    movsd xmm0, [rel .flt2653]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2654: dq 0.0
section .text
    movsd xmm0, [rel .flt2654]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl918:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2648
    jmp .L2650
.L2649:
.L2650:
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
.kl919:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2648
.__ret_2648:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_dist.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl917,71
    dq .kl918,72
    dq .kl919,73
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
.kl920:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2655
.__ret_2655:
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_norm.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl920,76
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
.kl921:
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
    jmp .__ret_2656
.__ret_2656:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_lerp.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl921,78
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
.kl922:
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
    jmp .__ret_2657
.__ret_2657:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_min.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl922,79
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
.flt2659: dq 2.0
section .text
    movsd xmm0, [rel .flt2659]
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-24]
    push rax
    lea rax, [rbp-40]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl923:
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
    jmp .__ret_2658
.__ret_2658:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_max.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl923,81
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
    jmp .__ret_2660
.__ret_2660:
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
.kl924:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2661
.__ret_2661:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v3_reflect.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl924,85
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
.kl925:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2662
.__ret_2662:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_from3.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl925,86
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
.kl926:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2663
.__ret_2663:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_xyz.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl926,87
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
.kl927:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2664
.__ret_2664:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_add.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl927,88
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
.kl928:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2665
.__ret_2665:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_sub.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl928,89
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
    jmp .__ret_2666
.__ret_2666:
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
.kl929:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2667
.__ret_2667:
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_scale.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl929,92
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
.flt2669: dq 255.0
section .text
    movsd xmm0, [rel .flt2669]
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
.flt2670: dq 255.0
section .text
    movsd xmm0, [rel .flt2670]
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
.flt2671: dq 255.0
section .text
    movsd xmm0, [rel .flt2671]
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
.flt2672: dq 255.0
section .text
    movsd xmm0, [rel .flt2672]
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
.kl930:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2668
.__ret_2668:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq v4_lerp.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl930,96
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
    jnz .L2676
    mov rax, r12
    mov rcx, 15
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L2676
    mov rax, 0
    jmp .L2677
.L2676:
    mov rax, 1
.L2677:
    test rax, rax
    jz .L2674
section .data
.str2678: db 110,111,32,115,117,99,104,32,101,108,101,109,101,110,116,32,111,102,32,97,32,52,120,52,32,109,97,116,114,105,120,0
section .text
    lea rax, [rel .str2678]
    push rax
section .data
.str2679: db 114,111,119,32,97,110,100,32,99,111,108,117,109,110,32,103,111,32,102,114,111,109,32,48,32,116,111,32,51,0
section .text
    lea rax, [rel .str2679]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl931:
    lea r8, [rel .kx159]
    call __fail_raise
.kx159:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2673
    jmp .L2675
.L2674:
.L2675:
section .data
.flt2680: dq 0.0
section .text
    movsd xmm0, [rel .flt2680]
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
    jb .L2681
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl932:
    lea r8, [rel .kx160]
    call __fail_raise
.kx160:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2673
.L2681:
    mov rcx, rax
    lea rdx, [rbp-112]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    jmp .__ret_2673
.__ret_2673:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    movups xmm6, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq color4.kft, .kfe, .kfn, __kron_file_8,2
    dq .kl931,104
    dq .kl932,111
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
    jnz .L2685
    mov rax, r12
    mov rcx, 15
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L2685
    mov rax, 0
    jmp .L2686
.L2685:
    mov rax, 1
.L2686:
    test rax, rax
    jz .L2683
section .data
.str2687: db 110,111,32,115,117,99,104,32,101,108,101,109,101,110,116,32,111,102,32,97,32,52,120,52,32,109,97,116,114,105,120,0
section .text
    lea rax, [rel .str2687]
    push rax
section .data
.str2688: db 114,111,119,32,97,110,100,32,99,111,108,117,109,110,32,103,111,32,102,114,111,109,32,48,32,116,111,32,51,0
section .text
    lea rax, [rel .str2688]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl933:
    lea r8, [rel .kx161]
    call __fail_raise
.kx161:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2682
    jmp .L2684
.L2683:
.L2684:
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
    jb .L2689
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl934:
    lea r8, [rel .kx162]
    call __fail_raise
.kx162:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2682
.L2689:
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
    jmp .__ret_2682
.__ret_2682:
    mov rbx, [rbp-224]
    mov r12, [rbp-216]
    movups xmm6, [rbp-208]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_get.kft, .kfe, .kfn, __kron_file_8,2
    dq .kl933,119
    dq .kl934,125
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
.flt2691: dq 1.0
section .text
    movsd xmm0, [rel .flt2691]
    cvtsd2ss xmm0, xmm0
    movss [rbp-72], xmm0
section .data
.flt2692: dq 1.0
section .text
    movsd xmm0, [rel .flt2692]
    cvtsd2ss xmm0, xmm0
    movss [rbp-52], xmm0
section .data
.flt2693: dq 1.0
section .text
    movsd xmm0, [rel .flt2693]
    cvtsd2ss xmm0, xmm0
    movss [rbp-32], xmm0
section .data
.flt2694: dq 1.0
section .text
    movsd xmm0, [rel .flt2694]
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
    jmp .__ret_2690
.__ret_2690:
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
    jmp .__ret_2695
.__ret_2695:
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
.kl935:
    mov r11, [rbp-8]
    call v4
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2696
.__ret_2696:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_set.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl935,159
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
.flt2698: dq 1.0
section .text
    movsd xmm0, [rel .flt2698]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl936:
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
.flt2703: dq 0.0
section .text
    movsd xmm0, [rel .flt2703]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setne al
    movzx rax, al
    test rax, rax
    jz .L2701
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2704: dq 1.0
section .text
    movsd xmm0, [rel .flt2704]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setne al
    movzx rax, al
    test rax, rax
    jz .L2701
    mov rax, 1
    jmp .L2702
.L2701:
    mov rax, 0
.L2702:
    test rax, rax
    jz .L2699
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
.kl937:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2697
    jmp .L2700
.L2699:
.L2700:
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
.kl938:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2697
.__ret_2697:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_mul_v4.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl936,164
    dq .kl937,165
    dq .kl938,166
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
.flt2706: dq 0.0
section .text
    movsd xmm0, [rel .flt2706]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl939:
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
.kl940:
    mov r11, [rbp-8]
    call v3
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2705
.__ret_2705:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_mul_point.kft, .kfe, .kfn, __kron_file_8,2
    dq .kl939,170
    dq .kl940,171
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
.kl941:
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
    jmp .__ret_2707
.__ret_2707:
    movups xmm6, [rbp-144]
    movups xmm7, [rbp-128]
    movups xmm8, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_mul_dir.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl941,174
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
.kl942:
    mov r11, [rbp-8]
    call m4_translate
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2708
.__ret_2708:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_translate.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl942,178
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
.flt2710: dq 1.0
section .text
    movsd xmm0, [rel .flt2710]
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
    jmp .__ret_2709
.__ret_2709:
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
.kl943:
    call fcos
    add rsp, 32
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl944:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    sub rsp, 32
.kl945:
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
.flt2712: dq 0.0
section .text
    movsd xmm0, [rel .flt2712]
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
    jmp .__ret_2711
.__ret_2711:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_translation.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl943,185
    dq .kl944,186
    dq .kl945,187
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
.kl946:
    call fcos
    add rsp, 32
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl947:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    sub rsp, 32
.kl948:
    lea r11, [rbp-96]
    call m4_identity
    add rsp, 32
    movaps xmm0, xmm7
    cvtsd2ss xmm0, xmm0
    movss [rbp-96], xmm0
section .data
.flt2714: dq 0.0
section .text
    movsd xmm0, [rel .flt2714]
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
    jmp .__ret_2713
.__ret_2713:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate_x.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl946,192
    dq .kl947,193
    dq .kl948,194
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
.kl949:
    call fcos
    add rsp, 32
    movaps xmm7, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl950:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
    sub rsp, 32
.kl951:
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
.flt2716: dq 0.0
section .text
    movsd xmm0, [rel .flt2716]
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
    jmp .__ret_2715
.__ret_2715:
    movups xmm6, [rbp-128]
    movups xmm7, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate_y.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl949,199
    dq .kl950,200
    dq .kl951,201
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
.kl952:
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
    jmp .__ret_2717
.__ret_2717:
    movups xmm6, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate_z.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl952,206
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
.flt2719: dq 1.0
section .text
    movsd xmm0, [rel .flt2719]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2720: dq 0.5
section .text
    movsd xmm0, [rel .flt2720]
    movaps xmm1, xmm0
    movaps xmm0, xmm6
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl953:
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
.flt2721: dq 0.0
section .text
    movsd xmm0, [rel .flt2721]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2722: dq 1.0
section .text
    movsd xmm0, [rel .flt2722]
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
    jmp .__ret_2718
.__ret_2718:
    movups xmm6, [rbp-176]
    movups xmm7, [rbp-160]
    movups xmm8, [rbp-144]
    movups xmm9, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_rotate.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl953,211
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
.flt2724: dq 2.0
section .text
    movsd xmm0, [rel .flt2724]
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
.flt2725: dq 2.0
section .text
    movsd xmm0, [rel .flt2725]
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
.flt2726: dq 1.0
section .text
    movsd xmm0, [rel .flt2726]
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
.flt2727: dq 1.0
section .text
    movsd xmm0, [rel .flt2727]
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
    jmp .__ret_2723
.__ret_2723:
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
.kl954:
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
.kl955:
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
.kl956:
    lea r11, [rbp-136]
    call v3_cross
    add rsp, 32
    sub rsp, 32
.kl957:
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
.flt2729: dq 0.0
section .text
    movsd xmm0, [rel .flt2729]
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
.flt2730: dq 0.0
section .text
    movsd xmm0, [rel .flt2730]
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
.flt2731: dq 0.0
section .text
    movsd xmm0, [rel .flt2731]
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
.flt2732: dq 0.0
section .text
    movsd xmm0, [rel .flt2732]
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-104]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl958:
    call v3_dot
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    cvtsd2ss xmm0, xmm0
    movss [rbp-152], xmm0
section .data
.flt2733: dq 0.0
section .text
    movsd xmm0, [rel .flt2733]
    sub rsp, 8
    movsd [rsp], xmm0
    lea rax, [rbp-136]
    push rax
    lea rax, [rbp-24]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl959:
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
.kl960:
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
    jmp .__ret_2728
.__ret_2728:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_perspective.kft, .kfe, .kfn, __kron_file_8,7
    dq .kl954,233
    dq .kl955,234
    dq .kl956,235
    dq .kl957,236
    dq .kl958,240
    dq .kl959,241
    dq .kl960,242
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
    jmp .__ret_2734
.__ret_2734:
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
.flt2736: dq 0.0
section .text
    movsd xmm0, [rel .flt2736]
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
.flt2737: dq 0.0
section .text
    movsd xmm0, [rel .flt2737]
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
.flt2738: dq 0.0
section .text
    movsd xmm0, [rel .flt2738]
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
.flt2739: dq 0.0
section .text
    movsd xmm0, [rel .flt2739]
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
.flt2740: dq 0.0
section .text
    movsd xmm0, [rel .flt2740]
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
.flt2741: dq 0.0
section .text
    movsd xmm0, [rel .flt2741]
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
.flt2742: dq 0.0
section .text
    movsd xmm0, [rel .flt2742]
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
.flt2743: dq 0.0
section .text
    movsd xmm0, [rel .flt2743]
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
.flt2746: dq 0.0
section .text
    movsd xmm0, [rel .flt2746]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2744
section .data
.str2747: db 116,104,105,115,32,109,97,116,114,105,120,32,104,97,115,32,110,111,32,105,110,118,101,114,115,101,0
section .text
    lea rax, [rel .str2747]
    push rax
section .data
.str2748: db 97,32,115,99,97,108,101,32,111,102,32,122,101,114,111,32,102,108,97,116,116,101,110,115,32,105,116,0
section .text
    lea rax, [rel .str2748]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl961:
    lea r8, [rel .kx163]
    call __fail_raise
.kx163:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2735
    jmp .L2745
.L2744:
.L2745:
section .data
.flt2749: dq 1.0
section .text
    movsd xmm0, [rel .flt2749]
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
    jmp .__ret_2735
.__ret_2735:
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
.kft: dq m4_look_at.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl961,303
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
.kl962:
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
    jmp .__ret_2750
.__ret_2750:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_inverse.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl962,329
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
.flt2752: dq 1.0
section .text
    movsd xmm0, [rel .flt2752]
    cvtsd2ss xmm0, xmm0
    movss [rbp-12], xmm0
    lea rax, [rbp-24]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov rcx, [rax+8]
    mov [rdx+8], rcx
    mov rax, [rbp-8]
    jmp .__ret_2751
.__ret_2751:
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
    jmp .__ret_2753
.__ret_2753:
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
.kl963:
    lea r11, [rbp-48]
    call v3_norm
    add rsp, 32
section .data
.flt2755: dq 0.5
section .text
    movsd xmm0, [rel .flt2755]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl964:
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
.flt2756: dq 0.5
section .text
    movsd xmm0, [rel .flt2756]
    movaps xmm1, xmm0
    movaps xmm0, xmm7
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl965:
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
    jmp .__ret_2754
.__ret_2754:
    movups xmm6, [rbp-96]
    movups xmm7, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq m4_trs.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl963,341
    dq .kl964,342
    dq .kl965,343
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
.flt2758: dq 1.0
section .text
    movsd xmm0, [rel .flt2758]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2759: dq 0.0
section .text
    movsd xmm0, [rel .flt2759]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2760: dq 0.0
section .text
    movsd xmm0, [rel .flt2760]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl966:
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
.flt2761: dq 0.0
section .text
    movsd xmm0, [rel .flt2761]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2762: dq 1.0
section .text
    movsd xmm0, [rel .flt2762]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2763: dq 0.0
section .text
    movsd xmm0, [rel .flt2763]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl967:
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
.flt2764: dq 0.0
section .text
    movsd xmm0, [rel .flt2764]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2765: dq 0.0
section .text
    movsd xmm0, [rel .flt2765]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2766: dq 1.0
section .text
    movsd xmm0, [rel .flt2766]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl968:
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
.kl969:
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
    jmp .__ret_2757
.__ret_2757:
    movups xmm6, [rbp-192]
    movups xmm7, [rbp-176]
    movups xmm8, [rbp-160]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_axis_angle.kft, .kfe, .kfn, __kron_file_8,4
    dq .kl966,348
    dq .kl967,349
    dq .kl968,350
    dq .kl969,351
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
.kl970:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2767
.__ret_2767:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_euler.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl970,355
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
    jmp .__ret_2768
.__ret_2768:
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
.flt2770: dq 0.0
section .text
    movsd xmm0, [rel .flt2770]
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
.flt2771: dq 0.0
section .text
    movsd xmm0, [rel .flt2771]
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
.flt2772: dq 0.0
section .text
    movsd xmm0, [rel .flt2772]
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
.kl971:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2769
.__ret_2769:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_mul.kft, .kfe, .kfn, __kron_file_8,1
    dq .kl971,361
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
.kl972:
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
.flt2776: dq 0.0
section .text
    movsd xmm0, [rel .flt2776]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2774
    sub rsp, 32
.kl973:
    mov r11, [rbp-8]
    call q_identity
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2773
    jmp .L2775
.L2774:
.L2775:
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
.kl974:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2773
.__ret_2773:
    movups xmm6, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_conj.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl972,363
    dq .kl973,364
    dq .kl974,365
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
.kl975:
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
.kl976:
    lea r11, [rbp-88]
    call v3_cross
    add rsp, 32
    push rax
section .data
.flt2778: dq 2.0
section .text
    movsd xmm0, [rel .flt2778]
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
.kl977:
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
    jmp .__ret_2777
.__ret_2777:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_norm.kft, .kfe, .kfn, __kron_file_8,3
    dq .kl975,369
    dq .kl976,370
    dq .kl977,371
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
.flt2780: dq 1.0
section .text
    movsd xmm0, [rel .flt2780]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2781: dq 2.0
section .text
    movsd xmm0, [rel .flt2781]
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
.flt2782: dq 2.0
section .text
    movsd xmm0, [rel .flt2782]
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
.flt2783: dq 2.0
section .text
    movsd xmm0, [rel .flt2783]
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
.flt2784: dq 2.0
section .text
    movsd xmm0, [rel .flt2784]
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
.flt2785: dq 1.0
section .text
    movsd xmm0, [rel .flt2785]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2786: dq 2.0
section .text
    movsd xmm0, [rel .flt2786]
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
.flt2787: dq 2.0
section .text
    movsd xmm0, [rel .flt2787]
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
.flt2788: dq 2.0
section .text
    movsd xmm0, [rel .flt2788]
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
.flt2789: dq 2.0
section .text
    movsd xmm0, [rel .flt2789]
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
.flt2790: dq 1.0
section .text
    movsd xmm0, [rel .flt2790]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2791: dq 2.0
section .text
    movsd xmm0, [rel .flt2791]
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
.flt2792: dq 1.0
section .text
    movsd xmm0, [rel .flt2792]
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
    jmp .__ret_2779
.__ret_2779:
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
.kl978:
    call q_dot
    add rsp, 32
    movaps xmm6, xmm0
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2796: dq 0.0
section .text
    movsd xmm0, [rel .flt2796]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L2794
section .data
.flt2797: dq 0.0
section .text
    movsd xmm0, [rel .flt2797]
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
.flt2798: dq 0.0
section .text
    movsd xmm0, [rel .flt2798]
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
.flt2799: dq 0.0
section .text
    movsd xmm0, [rel .flt2799]
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
.flt2800: dq 0.0
section .text
    movsd xmm0, [rel .flt2800]
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
.kl979:
    lea r11, [rbp-64]
    call quat
    add rsp, 32
section .data
.flt2801: dq 0.0
section .text
    movsd xmm0, [rel .flt2801]
    movaps xmm1, xmm6
    subsd xmm0, xmm1
    movaps xmm6, xmm0
    jmp .L2795
.L2794:
.L2795:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2804: dq 0.9995
section .text
    movsd xmm0, [rel .flt2804]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    seta al
    movzx rax, al
    test rax, rax
    jz .L2802
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
.kl980:
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
    jmp .__ret_2793
    jmp .L2803
.L2802:
.L2803:
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl981:
    call facos
    add rsp, 32
    movaps xmm8, xmm0
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl982:
    call fsin
    add rsp, 32
    movaps xmm6, xmm0
section .data
.flt2805: dq 1.0
section .text
    movsd xmm0, [rel .flt2805]
    movaps xmm1, xmm9
    subsd xmm0, xmm1
    movaps xmm1, xmm8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl983:
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
.kl984:
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
.kl985:
    mov r11, [rbp-8]
    call quat
    add rsp, 32
    mov rax, [rbp-8]
    jmp .__ret_2793
.__ret_2793:
    movups xmm6, [rbp-192]
    movups xmm7, [rbp-176]
    movups xmm8, [rbp-160]
    movups xmm9, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_rotate.kft, .kfe, .kfn, __kron_file_8,8
    dq .kl978,394
    dq .kl979,396
    dq .kl980,400
    dq .kl981,403
    dq .kl982,404
    dq .kl983,405
    dq .kl984,406
    dq .kl985,407
.kfn: db "q_slerp", 0
section .text
section .data
__g_md_verts: dq 0
section .text
section .data
__g_md_idx: dq 0
section .text
section .data
__g_md_tex: dq 0
section .text
section .data
__g_md_min: dq 0
section .text
section .data
__g_md_max: dq 0
section .text
section .data
__g_mv: dq 0
section .text
section .data
__g_mi: dq 0
section .text
section .data
__g_mtex: dq 0
section .text
md_init:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_md_verts]
    cmp rax, 0
    jne .L2807
    sub rsp, 32
.kl986:
    call list_new
    add rsp, 32
    mov [rel __g_md_verts], rax
    sub rsp, 32
.kl987:
    call list_new
    add rsp, 32
    mov [rel __g_md_idx], rax
    sub rsp, 32
.kl988:
    call list_new
    add rsp, 32
    mov [rel __g_md_tex], rax
    sub rsp, 32
.kl989:
    call list_new
    add rsp, 32
    mov [rel __g_md_min], rax
    sub rsp, 32
.kl990:
    call list_new
    add rsp, 32
    mov [rel __g_md_max], rax
    jmp .L2808
.L2807:
.L2808:
    sub rsp, 32
.kl991:
    call list_new
    add rsp, 32
    mov [rel __g_mv], rax
    sub rsp, 32
.kl992:
    call list_new
    add rsp, 32
    mov [rel __g_mi], rax
    mov rax, 0
    mov [rel __g_mtex], rax
    mov rax, 0
    jmp .__ret_2806
.__ret_2806:
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq q_slerp.kft, .kfe, .kfn, __kron_file_9,7
    dq .kl986,49
    dq .kl987,50
    dq .kl988,51
    dq .kl989,52
    dq .kl990,53
    dq .kl991,55
    dq .kl992,56
.kfn: db "md_init", 0
section .text
md_finish:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
section .data
.flt2810: dq 1.0e30
section .text
    movsd xmm0, [rel .flt2810]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2811: dq 1.0e30
section .text
    movsd xmm0, [rel .flt2811]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2812: dq 1.0e30
section .text
    movsd xmm0, [rel .flt2812]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl993:
    lea r11, [rbp-16]
    call v3
    add rsp, 32
section .data
.flt2813: dq 0.0
section .text
    movsd xmm0, [rel .flt2813]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2814: dq 1.0e30
section .text
    movsd xmm0, [rel .flt2814]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2815: dq 0.0
section .text
    movsd xmm0, [rel .flt2815]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2816: dq 1.0e30
section .text
    movsd xmm0, [rel .flt2816]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2817: dq 0.0
section .text
    movsd xmm0, [rel .flt2817]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2818: dq 1.0e30
section .text
    movsd xmm0, [rel .flt2818]
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
.kl994:
    lea r11, [rbp-32]
    call v3
    add rsp, 32
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    sub rsp, 32
.kl995:
    call list_len
    add rsp, 32
    mov rbx, rax
.L2819:
    cmp r12, rbx
    jge .L2820
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl996:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
    push rax
    mov rax, r12
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
    lea r11, [rbp-64]
    call v3
    add rsp, 32
    lea rax, [rbp-16]
    push rax
    lea rax, [rbp-64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl997:
    lea r11, [rbp-16]
    call v3_min
    add rsp, 32
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl998:
    lea r11, [rbp-32]
    call v3_max
    add rsp, 32
    add r12, 8
.L2821:
    jmp .L2819
.L2820:
    mov rax, [rel __g_md_verts]
    push rax
    mov rax, [rel __g_mv]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl999:
    call list_add
    add rsp, 32
    mov rax, [rel __g_md_idx]
    push rax
    mov rax, [rel __g_mi]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1000:
    call list_add
    add rsp, 32
    mov rax, [rel __g_md_tex]
    push rax
    mov rax, [rel __g_mtex]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1001:
    call list_add
    add rsp, 32
    mov rax, [rel __g_md_min]
    push rax
    lea rax, [rbp-16]
    push rax
    mov rax, 2
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1002:
    call list_add_n
    add rsp, 32
    mov rax, [rel __g_md_max]
    push rax
    lea rax, [rbp-32]
    push rax
    mov rax, 2
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1003:
    call list_add_n
    add rsp, 32
    mov rax, [rel __g_md_verts]
    push rax
    pop rcx
    sub rsp, 32
.kl1004:
    call list_len
    add rsp, 32
    jmp .__ret_2809
.__ret_2809:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_init.kft, .kfe, .kfn, __kron_file_9,12
    dq .kl993,62
    dq .kl994,63
    dq .kl995,65
    dq .kl996,67
    dq .kl997,68
    dq .kl998,69
    dq .kl999,72
    dq .kl1000,73
    dq .kl1001,74
    dq .kl1002,75
    dq .kl1003,76
    dq .kl1004,77
.kfn: db "md_finish", 0
section .text
md_check:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_md_verts]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2827
    mov rax, rbx
    mov rcx, 1
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L2827
    mov rax, 0
    jmp .L2828
.L2827:
    mov rax, 1
.L2828:
    test rax, rax
    jnz .L2825
    mov rax, rbx
    push rax
    mov rax, [rel __g_md_verts]
    push rax
    pop rcx
    sub rsp, 32
.kl1005:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L2825
    mov rax, 0
    jmp .L2826
.L2825:
    mov rax, 1
.L2826:
    test rax, rax
    jz .L2823
section .data
.str2829: db 110,111,32,115,117,99,104,32,109,111,100,101,108,0
section .text
    lea rax, [rel .str2829]
    push rax
section .data
.str2830: db 117,115,101,32,119,104,97,116,32,109,111,100,101,108,95,108,111,97,100,32,103,97,118,101,0
section .text
    lea rax, [rel .str2830]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1006:
    lea r8, [rel .kx164]
    call __fail_raise
.kx164:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2822
    jmp .L2824
.L2823:
.L2824:
    mov rax, rbx
    jmp .__ret_2822
.__ret_2822:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_finish.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1005,81
    dq .kl1006,82
.kfn: db "md_check", 0
section .text
model_vertices:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1007:
    call md_check
    add rsp, 32
    cmp rax, 0
    jne .L2832
    sub rsp, 32
    call list_new
    add rsp, 32
    jmp .__ret_2831
    jmp .L2833
.L2832:
.L2833:
    mov rax, [rel __g_md_verts]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1008:
    call list_get
    add rsp, 32
    jmp .__ret_2831
.__ret_2831:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_check.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1007,88
    dq .kl1008,89
.kfn: db "model_vertices", 0
section .text
model_indices:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1009:
    call md_check
    add rsp, 32
    cmp rax, 0
    jne .L2835
    sub rsp, 32
    call list_new
    add rsp, 32
    jmp .__ret_2834
    jmp .L2836
.L2835:
.L2836:
    mov rax, [rel __g_md_idx]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1010:
    call list_get
    add rsp, 32
    jmp .__ret_2834
.__ret_2834:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_vertices.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1009,92
    dq .kl1010,93
.kfn: db "model_indices", 0
section .text
model_texture:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1011:
    call md_check
    add rsp, 32
    cmp rax, 0
    jne .L2838
    mov rax, 0
    jmp .__ret_2837
    jmp .L2839
.L2838:
.L2839:
    mov rax, [rel __g_md_tex]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1012:
    call list_get
    add rsp, 32
    jmp .__ret_2837
.__ret_2837:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_indices.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1011,96
    dq .kl1012,97
.kfn: db "model_texture", 0
section .text
model_corners:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1013:
    call model_vertices
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_len
    add rsp, 32
    mov rcx, 8
    cqo
    idiv rcx
    jmp .__ret_2840
.__ret_2840:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_texture.kft, .kfe, .kfn, __kron_file_9,1
    dq .kl1013,99
.kfn: db "model_corners", 0
section .text
model_triangles:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1014:
    call model_indices
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_len
    add rsp, 32
    mov rcx, 3
    cqo
    idiv rcx
    jmp .__ret_2841
.__ret_2841:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_corners.kft, .kfe, .kfn, __kron_file_9,1
    dq .kl1014,100
.kfn: db "model_triangles", 0
section .text
model_bounds_min:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-8], r11
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1015:
    call md_check
    add rsp, 32
    cmp rax, 0
    jne .L2843
section .data
.flt2845: dq 0.0
section .text
    movsd xmm0, [rel .flt2845]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2846: dq 0.0
section .text
    movsd xmm0, [rel .flt2846]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2847: dq 0.0
section .text
    movsd xmm0, [rel .flt2847]
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
    jmp .__ret_2842
    jmp .L2844
.L2843:
.L2844:
    mov rax, [rel __g_md_min]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    lea rax, [rbp-48]
    push rax
    mov rax, 2
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1016:
    call list_get_n
    add rsp, 32
    lea rdx, [rbp-32]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-32]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_2842
.__ret_2842:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_triangles.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1015,102
    dq .kl1016,103
.kfn: db "model_bounds_min", 0
section .text
model_bounds_max:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-8], r11
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1017:
    call md_check
    add rsp, 32
    cmp rax, 0
    jne .L2849
section .data
.flt2851: dq 0.0
section .text
    movsd xmm0, [rel .flt2851]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2852: dq 0.0
section .text
    movsd xmm0, [rel .flt2852]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2853: dq 0.0
section .text
    movsd xmm0, [rel .flt2853]
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
    jmp .__ret_2848
    jmp .L2850
.L2849:
.L2850:
    mov rax, [rel __g_md_max]
    push rax
    mov rax, rbx
    sub rax, 1
    push rax
    lea rax, [rbp-48]
    push rax
    mov rax, 2
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1018:
    call list_get_n
    add rsp, 32
    lea rdx, [rbp-32]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    lea rax, [rbp-32]
    mov rdx, [rbp-8]
    mov rcx, [rax+0]
    mov [rdx+0], rcx
    mov ecx, dword [rax+8]
    mov [rdx+8], ecx
    mov rax, [rbp-8]
    jmp .__ret_2848
.__ret_2848:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_bounds_min.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1017,107
    dq .kl1018,108
.kfn: db "model_bounds_max", 0
section .text
model_positions:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1019:
    call model_vertices
    add rsp, 32
    mov r13, rax
    sub rsp, 32
.kl1020:
    call list_new
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L2855:
    mov rax, rbx
    push rax
    mov rcx, r13
    sub rsp, 32
.kl1021:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2856
    mov rax, r12
    push rax
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl1022:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1023:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, rbx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1024:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    add rbx, 8
.L2857:
    jmp .L2855
.L2856:
    mov rax, r12
    jmp .__ret_2854
.__ret_2854:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_bounds_max.kft, .kfe, .kfn, __kron_file_9,6
    dq .kl1019,112
    dq .kl1020,113
    dq .kl1021,115
    dq .kl1022,116
    dq .kl1023,117
    dq .kl1024,118
.kfn: db "model_positions", 0
section .text
md_corner:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    movups [rbp-160], xmm6
    movups [rbp-144], xmm7
    movups [rbp-128], xmm8
    movups [rbp-112], xmm9
    movups [rbp-96], xmm10
    movups [rbp-80], xmm11
    movaps xmm11, xmm0
    movaps xmm10, xmm1
    movaps xmm9, xmm2
    movaps xmm8, xmm3
    movaps xmm7, xmm4
    movaps xmm6, xmm5
    mov rax, [rbp+48]
    mov [rbp-56], rax
    mov rax, [rbp+56]
    mov [rbp-64], rax
    mov rax, [rel __g_mv]
    push rax
    movaps xmm0, xmm11
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1025:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1026:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movaps xmm0, xmm9
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1027:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1028:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1029:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movaps xmm0, xmm6
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1030:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movsd xmm0, [rbp-56]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1031:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    movsd xmm0, [rbp-64]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
.kl1032:
    call list_add_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    sub rsp, 32
.kl1033:
    call list_len
    add rsp, 32
    mov rcx, 8
    cqo
    idiv rcx
    sub rax, 1
    jmp .__ret_2858
.__ret_2858:
    movups xmm6, [rbp-160]
    movups xmm7, [rbp-144]
    movups xmm8, [rbp-128]
    movups xmm9, [rbp-112]
    movups xmm10, [rbp-96]
    movups xmm11, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_positions.kft, .kfe, .kfn, __kron_file_9,9
    dq .kl1025,125
    dq .kl1026,126
    dq .kl1027,127
    dq .kl1028,128
    dq .kl1029,129
    dq .kl1030,130
    dq .kl1031,131
    dq .kl1032,132
    dq .kl1033,133
.kfn: db "md_corner", 0
section .text
md_dir:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rcx, r13
    sub rsp, 32
.kl1034:
    call text_len
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    sub rax, 1
    mov r12, rax
.L2860:
    cmp r12, 0
    jl .L2861
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl1035:
    call text_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2865
    mov rax, rbx
    mov rcx, 92
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L2865
    mov rax, 0
    jmp .L2866
.L2865:
    mov rax, 1
.L2866:
    test rax, rax
    jz .L2863
    mov rax, r13
    push rax
    mov rax, 0
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1036:
    call text_part
    add rsp, 32
    jmp .__ret_2859
    jmp .L2864
.L2863:
.L2864:
    sub r12, 1
.L2862:
    jmp .L2860
.L2861:
    sub rsp, 32
.kl1037:
    call text_new
    add rsp, 32
    jmp .__ret_2859
.__ret_2859:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_corner.kft, .kfe, .kfn, __kron_file_9,4
    dq .kl1034,138
    dq .kl1035,141
    dq .kl1036,143
    dq .kl1037,147
.kfn: db "md_dir", 0
section .text
md_ends:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    sub rsp, 32
.kl1038:
    call text_lower
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call text_ends
    add rsp, 32
    jmp .__ret_2867
.__ret_2867:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_dir.kft, .kfe, .kfn, __kron_file_9,1
    dq .kl1038,151
.kfn: db "md_ends", 0
section .text
model_load:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str2871: db 46,111,98,106,0
section .text
    lea rax, [rel .str2871]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1039:
    call md_ends
    add rsp, 32
    test rax, rax
    jz .L2869
    mov rcx, rbx
    sub rsp, 32
    call md_obj
    add rsp, 32
    jmp .__ret_2868
    jmp .L2870
.L2869:
.L2870:
    mov rax, rbx
    push rax
section .data
.str2876: db 46,103,108,116,102,0
section .text
    lea rax, [rel .str2876]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1040:
    call md_ends
    add rsp, 32
    test rax, rax
    jnz .L2874
    mov rax, rbx
    push rax
section .data
.str2877: db 46,103,108,98,0
section .text
    lea rax, [rel .str2877]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call md_ends
    add rsp, 32
    test rax, rax
    jnz .L2874
    mov rax, 0
    jmp .L2875
.L2874:
    mov rax, 1
.L2875:
    test rax, rax
    jz .L2872
    mov rcx, rbx
    sub rsp, 32
    call md_gltf
    add rsp, 32
    jmp .__ret_2868
    jmp .L2873
.L2872:
.L2873:
section .data
.str2878: db 97,32,109,111,100,101,108,32,105,115,32,114,101,97,100,32,102,114,111,109,32,46,111,98,106,44,32,46,103,108,116,102,32,111,114,32,46,103,108,98,0
section .text
    lea rax, [rel .str2878]
    push rax
section .data
.str2879: db 99,111,110,118,101,114,116,32,105,116,32,119,105,116,104,32,97,32,51,68,32,112,114,111,103,114,97,109,32,40,66,108,101,110,100,101,114,32,101,120,112,111,114,116,115,32,97,108,108,32,116,104,114,101,101,41,0
section .text
    lea rax, [rel .str2879]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1041:
    lea r8, [rel .kx165]
    call __fail_raise
.kx165:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2868
.__ret_2868:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_ends.kft, .kfe, .kfn, __kron_file_9,3
    dq .kl1039,155
    dq .kl1040,156
    dq .kl1041,157
.kfn: db "model_load", 0
section .text
md_num:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
.kl1042:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2881
section .data
.flt2883: dq 0.0
section .text
    movsd xmm0, [rel .flt2883]
    jmp .__ret_2880
    jmp .L2882
.L2881:
.L2882:
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl1043:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_to_real
    add rsp, 32
    jmp .__ret_2880
.__ret_2880:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq model_load.kft, .kfe, .kfn, __kron_file_9,2
    dq .kl1042,162
    dq .kl1043,163
.kfn: db "md_num", 0
section .text
md_ref:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rbx, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, rbx
    push rax
section .data
.str2885: db 47,0
section .text
    lea rax, [rel .str2885]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1044:
    call text_split
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl1045:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L2886
    mov rax, 1
    neg rax
    jmp .__ret_2884
    jmp .L2887
.L2886:
.L2887:
    mov rcx, rbx
    mov rdx, r13
    sub rsp, 32
.kl1046:
    call list_get
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1047:
    call text_len
    add rsp, 32
    cmp rax, 0
    jne .L2888
    mov rax, 1
    neg rax
    jmp .__ret_2884
    jmp .L2889
.L2888:
.L2889:
    mov rcx, rbx
    sub rsp, 32
.kl1048:
    call text_to_int
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L2890
    mov rax, r12
    add rax, rbx
    jmp .__ret_2884
    jmp .L2891
.L2890:
.L2891:
    mov rax, rbx
    sub rax, 1
    jmp .__ret_2884
.__ret_2884:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_num.kft, .kfe, .kfn, __kron_file_9,5
    dq .kl1044,169
    dq .kl1045,170
    dq .kl1046,171
    dq .kl1047,172
    dq .kl1048,173
.kfn: db "md_ref", 0
section .text
md_obj:
    push rbp
    mov rbp, rsp
    sub rsp, 368
    mov [rbp-336], rbx
    mov [rbp-328], r12
    mov [rbp-320], r13
    mov [rbp-312], r14
    mov [rbp-304], r15
    movups [rbp-296], xmm6
    movups [rbp-280], xmm7
    movups [rbp-264], xmm8
    movups [rbp-248], xmm9
    movups [rbp-232], xmm10
    mov [rbp-8], rcx
    mov rcx, [rbp-8]
    sub rsp, 32
.kl1049:
    call file_exists
    add rsp, 32
    test rax, rax
    sete al
    movzx rax, al
    test rax, rax
    jz .L2893
section .data
.str2895: db 99,97,110,110,111,116,32,114,101,97,100,32,116,104,101,32,109,111,100,101,108,32,102,105,108,101,0
section .text
    lea rax, [rel .str2895]
    push rax
section .data
.str2896: db 99,104,101,99,107,32,116,104,101,32,110,97,109,101,0
section .text
    lea rax, [rel .str2896]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1050:
    lea r8, [rel .kx166]
    call __fail_raise
.kx166:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2892
    jmp .L2894
.L2893:
.L2894:
    sub rsp, 32
.kl1051:
    call md_init
    add rsp, 32
    mov rcx, [rbp-8]
    sub rsp, 32
.kl1052:
    call file_lines
    add rsp, 32
    mov [rbp-16], rax
    sub rsp, 32
.kl1053:
    call list_new
    add rsp, 32
    mov r15, rax
    sub rsp, 32
.kl1054:
    call list_new
    add rsp, 32
    mov [rbp-32], rax
    sub rsp, 32
.kl1055:
    call list_new
    add rsp, 32
    mov r14, rax
    sub rsp, 32
.kl1056:
    call map_new
    add rsp, 32
    mov [rbp-48], rax
    sub rsp, 32
.kl1057:
    call text_new
    add rsp, 32
    mov [rbp-56], rax
    mov rax, 0
    mov [rbp-64], rax
    mov rcx, [rbp-16]
    sub rsp, 32
.kl1058:
    call list_len
    add rsp, 32
    mov [rbp-72], rax
.L2897:
    mov rax, [rbp-64]
    mov rcx, [rbp-72]
    cmp rax, rcx
    jge .L2898
    mov rcx, [rbp-16]
    mov rdx, [rbp-64]
    sub rsp, 32
.kl1059:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_trim
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str2900: db 32,0
section .text
    lea rax, [rel .str2900]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1060:
    call text_split
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
.kl1061:
    call list_new
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L2901:
    mov rax, r12
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl1062:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2902
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
.kl1063:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_len
    add rsp, 32
    cmp rax, 0
    jle .L2904
    mov rax, r13
    push rax
    mov rcx, rbx
    mov rdx, r12
    sub rsp, 32
    call list_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    jmp .L2905
.L2904:
.L2905:
    add r12, 1
.L2903:
    jmp .L2901
.L2902:
    mov rcx, r13
    sub rsp, 32
.kl1064:
    call list_len
    add rsp, 32
    cmp rax, 0
    jle .L2906
    mov rcx, r13
    mov rdx, 0
    sub rsp, 32
.kl1065:
    call list_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str2910: db 118,0
section .text
    lea rax, [rel .str2910]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1066:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L2908
    mov rax, r15
    push rax
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
.kl1067:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, r15
    push rax
    mov rcx, r13
    mov rdx, 2
    sub rsp, 32
.kl1068:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, r15
    push rax
    mov rcx, r13
    mov rdx, 3
    sub rsp, 32
.kl1069:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    jmp .L2909
.L2908:
    mov rax, rbx
    push rax
section .data
.str2913: db 118,116,0
section .text
    lea rax, [rel .str2913]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1070:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L2911
    mov rax, [rbp-32]
    push rax
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
.kl1071:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, [rbp-32]
    push rax
section .data
.flt2914: dq 1.0
section .text
    movsd xmm0, [rel .flt2914]
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, r13
    mov rdx, 2
    sub rsp, 32
.kl1072:
    call md_num
    add rsp, 32
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    jmp .L2912
.L2911:
    mov rax, rbx
    push rax
section .data
.str2917: db 118,110,0
section .text
    lea rax, [rel .str2917]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1073:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L2915
    mov rax, r14
    push rax
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
.kl1074:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, r14
    push rax
    mov rcx, r13
    mov rdx, 2
    sub rsp, 32
.kl1075:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    mov rax, r14
    push rax
    mov rcx, r13
    mov rdx, 3
    sub rsp, 32
.kl1076:
    call md_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    sub rsp, 32
    call list_add_real
    add rsp, 32
    jmp .L2916
.L2915:
    mov rax, rbx
    push rax
section .data
.str2922: db 102,0
section .text
    lea rax, [rel .str2922]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1077:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L2920
    mov rcx, r13
    sub rsp, 32
    call list_len
    add rsp, 32
    mov rcx, 4
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2920
    mov rax, 1
    jmp .L2921
.L2920:
    mov rax, 0
.L2921:
    test rax, rax
    jz .L2918
    sub rsp, 32
.kl1078:
    call list_new
    add rsp, 32
    mov [rbp-120], rax
    mov rax, 1
    mov r12, rax
.L2923:
    mov rax, r12
    push rax
    mov rcx, r13
    sub rsp, 32
.kl1079:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2924
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl1080:
    call list_get
    add rsp, 32
    mov rbx, rax
    mov rcx, [rbp-48]
    mov rdx, rbx
    sub rsp, 32
.kl1081:
    call map_has
    add rsp, 32
    test rax, rax
    jz .L2926
    mov rax, [rbp-120]
    push rax
    mov rcx, [rbp-48]
    mov rdx, rbx
    sub rsp, 32
.kl1082:
    call map_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    jmp .L2927
.L2926:
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
    mov rcx, r15
    sub rsp, 32
.kl1083:
    call list_len
    add rsp, 32
    mov rcx, 3
    cqo
    idiv rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call md_ref
    add rsp, 32
    mov [rbp-136], rax
    mov rax, rbx
    push rax
    mov rax, 1
    push rax
    mov rcx, [rbp-32]
    sub rsp, 32
.kl1084:
    call list_len
    add rsp, 32
    mov rcx, 2
    cqo
    idiv rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call md_ref
    add rsp, 32
    mov [rbp-144], rax
    mov rax, rbx
    push rax
    mov rax, 2
    push rax
    mov rcx, r14
    sub rsp, 32
.kl1085:
    call list_len
    add rsp, 32
    mov rcx, 3
    cqo
    idiv rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call md_ref
    add rsp, 32
    mov [rbp-152], rax
    mov rax, [rbp-136]
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L2930
    mov rax, [rbp-136]
    mov rcx, 3
    imul rax, rcx
    add rax, 2
    push rax
    mov rcx, r15
    sub rsp, 32
.kl1086:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L2930
    mov rax, 0
    jmp .L2931
.L2930:
    mov rax, 1
.L2931:
    test rax, rax
    jz .L2928
section .data
.str2932: db 116,104,101,32,109,111,100,101,108,32,114,101,102,101,114,115,32,116,111,32,97,32,99,111,114,110,101,114,32,105,116,32,100,111,101,115,32,110,111,116,32,104,97,118,101,0
section .text
    lea rax, [rel .str2932]
    push rax
section .data
.str2933: db 116,104,101,32,102,105,108,101,32,109,97,121,32,98,101,32,100,97,109,97,103,101,100,0
section .text
    lea rax, [rel .str2933]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1087:
    lea r8, [rel .kx167]
    call __fail_raise
.kx167:
    add rsp, 32
    xor rax, rax
    jmp .__ret_2892
    jmp .L2929
.L2928:
.L2929:
section .data
.flt2934: dq 0.0
section .text
    movsd xmm0, [rel .flt2934]
    movaps xmm10, xmm0
section .data
.flt2935: dq 0.0
section .text
    movsd xmm0, [rel .flt2935]
    movaps xmm9, xmm0
    mov rax, [rbp-144]
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2938
    mov rax, [rbp-144]
    mov rcx, 2
    imul rax, rcx
    add rax, 1
    push rax
    mov rcx, [rbp-32]
    sub rsp, 32
.kl1088:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2938
    mov rax, 1
    jmp .L2939
.L2938:
    mov rax, 0
.L2939:
    test rax, rax
    jz .L2936
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-144]
    mov rcx, 2
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1089:
    call list_get_real
    add rsp, 32
    movaps xmm10, xmm0
    mov rax, [rbp-32]
    push rax
    mov rax, [rbp-144]
    mov rcx, 2
    imul rax, rcx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1090:
    call list_get_real
    add rsp, 32
    movaps xmm9, xmm0
    jmp .L2937
.L2936:
.L2937:
section .data
.flt2940: dq 0.0
section .text
    movsd xmm0, [rel .flt2940]
    movaps xmm8, xmm0
section .data
.flt2941: dq 0.0
section .text
    movsd xmm0, [rel .flt2941]
    movaps xmm7, xmm0
section .data
.flt2942: dq 0.0
section .text
    movsd xmm0, [rel .flt2942]
    movaps xmm6, xmm0
    mov rax, [rbp-152]
    mov rcx, 0
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2945
    mov rax, [rbp-152]
    mov rcx, 3
    imul rax, rcx
    add rax, 2
    push rax
    mov rcx, r14
    sub rsp, 32
.kl1091:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L2945
    mov rax, 1
    jmp .L2946
.L2945:
    mov rax, 0
.L2946:
    test rax, rax
    jz .L2943
    mov rax, r14
    push rax
    mov rax, [rbp-152]
    mov rcx, 3
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1092:
    call list_get_real
    add rsp, 32
    movaps xmm8, xmm0
    mov rax, r14
    push rax
    mov rax, [rbp-152]
    mov rcx, 3
    imul rax, rcx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1093:
    call list_get_real
    add rsp, 32
    movaps xmm7, xmm0
    mov rax, r14
    push rax
    mov rax, [rbp-152]
    mov rcx, 3
    imul rax, rcx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1094:
    call list_get_real
    add rsp, 32
    movaps xmm6, xmm0
    jmp .L2944
.L2943:
.L2944:
    movaps xmm0, xmm9
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm10
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r15
    push rax
    mov rax, [rbp-136]
    mov rcx, 3
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1095:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r15
    push rax
    mov rax, [rbp-136]
    mov rcx, 3
    imul rax, rcx
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, r15
    push rax
    mov rax, [rbp-136]
    mov rcx, 3
    imul rax, rcx
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm8
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm7
    sub rsp, 8
    movsd [rsp], xmm0
    movaps xmm0, xmm6
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
    call md_corner
    add rsp, 32
    mov [rbp-200], rax
    mov rcx, [rbp-48]
    mov rdx, rbx
    mov r8, [rbp-200]
    sub rsp, 32
.kl1096:
    call map_set
    add rsp, 32
    mov rcx, [rbp-120]
    mov rdx, [rbp-200]
    sub rsp, 32
.kl1097:
    call list_add
    add rsp, 32
.L2927:
    add r12, 1
.L2925:
    jmp .L2923
.L2924:
    mov rax, 1
    mov r12, rax
.L2947:
    mov rax, r12
    add rax, 1
    push rax
    mov rcx, [rbp-120]
    sub rsp, 32
.kl1098:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2948
    mov rax, [rel __g_mi]
    push rax
    mov rcx, [rbp-120]
    mov rdx, 0
    sub rsp, 32
.kl1099:
    call list_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    mov rax, [rel __g_mi]
    push rax
    mov rcx, [rbp-120]
    mov rdx, r12
    sub rsp, 32
.kl1100:
    call list_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    mov rax, [rel __g_mi]
    push rax
    mov rax, [rbp-120]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1101:
    call list_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    add r12, 1
.L2949:
    jmp .L2947
.L2948:
    jmp .L2919
.L2918:
    mov rax, rbx
    push rax
section .data
.str2956: db 109,116,108,108,105,98,0
section .text
    lea rax, [rel .str2956]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1102:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L2954
    mov rcx, r13
    sub rsp, 32
    call list_len
    add rsp, 32
    mov rcx, 2
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2954
    mov rax, 1
    jmp .L2955
.L2954:
    mov rax, 0
.L2955:
    test rax, rax
    jz .L2952
    mov rcx, [rbp-56]
    sub rsp, 32
    call text_len
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L2952
    mov rax, 1
    jmp .L2953
.L2952:
    mov rax, 0
.L2953:
    test rax, rax
    jz .L2950
    mov rcx, [rbp-8]
    sub rsp, 32
.kl1103:
    call md_dir
    add rsp, 32
    push rax
    mov rcx, r13
    mov rdx, 1
    sub rsp, 32
    call list_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_mtl_texture
    add rsp, 32
    mov [rbp-56], rax
    jmp .L2951
.L2950:
.L2951:
.L2919:
.L2916:
.L2912:
.L2909:
    jmp .L2907
.L2906:
.L2907:
    mov rax, [rbp-64]
    add rax, 1
    mov [rbp-64], rax
.L2899:
    jmp .L2897
.L2898:
    sub rsp, 32
.kl1104:
    call md_flat_normals
    add rsp, 32
    mov rcx, [rbp-56]
    sub rsp, 32
.kl1105:
    call text_len
    add rsp, 32
    cmp rax, 0
    jle .L2957
    mov rcx, [rbp-8]
    sub rsp, 32
.kl1106:
    call md_dir
    add rsp, 32
    push rax
    pop rcx
    mov rdx, [rbp-56]
    sub rsp, 32
    call text_add
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call image_load
    add rsp, 32
    mov [rel __g_mtex], rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L2959
    mov rax, 0
    mov [rel __g_mtex], rax
    jmp .L2960
.L2959:
.L2960:
    jmp .L2958
.L2957:
.L2958:
    sub rsp, 32
.kl1107:
    call md_finish
    add rsp, 32
    jmp .__ret_2892
.__ret_2892:
    mov rbx, [rbp-336]
    mov r12, [rbp-328]
    mov r13, [rbp-320]
    mov r14, [rbp-312]
    mov r15, [rbp-304]
    movups xmm6, [rbp-296]
    movups xmm7, [rbp-280]
    movups xmm8, [rbp-264]
    movups xmm9, [rbp-248]
    movups xmm10, [rbp-232]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_ref.kft, .kfe, .kfn, __kron_file_9,59
    dq .kl1049,179
    dq .kl1050,180
    dq .kl1051,182
    dq .kl1052,183
    dq .kl1053,184
    dq .kl1054,185
    dq .kl1055,186
    dq .kl1056,187
    dq .kl1057,188
    dq .kl1058,190
    dq .kl1059,192
    dq .kl1060,193
    dq .kl1061,195
    dq .kl1062,197
    dq .kl1063,198
    dq .kl1064,201
    dq .kl1065,202
    dq .kl1066,203
    dq .kl1067,204
    dq .kl1068,205
    dq .kl1069,206
    dq .kl1070,260
    dq .kl1071,208
    dq .kl1072,209
    dq .kl1073,260
    dq .kl1074,211
    dq .kl1075,212
    dq .kl1076,213
    dq .kl1077,260
    dq .kl1078,215
    dq .kl1079,217
    dq .kl1080,218
    dq .kl1081,219
    dq .kl1082,220
    dq .kl1083,222
    dq .kl1084,223
    dq .kl1085,224
    dq .kl1086,225
    dq .kl1087,226
    dq .kl1088,230
    dq .kl1089,231
    dq .kl1090,232
    dq .kl1091,237
    dq .kl1092,238
    dq .kl1093,239
    dq .kl1094,240
    dq .kl1095,242
    dq .kl1096,244
    dq .kl1097,245
    dq .kl1098,251
    dq .kl1099,252
    dq .kl1100,253
    dq .kl1101,254
    dq .kl1102,260
    dq .kl1103,258
    dq .kl1104,263
    dq .kl1105,264
    dq .kl1106,265
    dq .kl1107,268
.kfn: db "md_obj", 0
section .text
md_mtl_texture:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl1108:
    call file_exists
    add rsp, 32
    test rax, rax
    sete al
    movzx rax, al
    test rax, rax
    jz .L2962
    sub rsp, 32
    call text_new
    add rsp, 32
    jmp .__ret_2961
    jmp .L2963
.L2962:
.L2963:
    mov rcx, rbx
    sub rsp, 32
.kl1109:
    call file_lines
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L2964:
    mov rax, r12
    push rax
    mov rcx, r13
    sub rsp, 32
.kl1110:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2965
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl1111:
    call list_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_trim
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str2969: db 109,97,112,95,75,100,32,0
section .text
    lea rax, [rel .str2969]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1112:
    call text_starts
    add rsp, 32
    test rax, rax
    jz .L2967
    mov rax, rbx
    push rax
    mov rax, 7
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl1113:
    call text_len
    add rsp, 32
    sub rax, 7
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call text_part
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_trim
    add rsp, 32
    jmp .__ret_2961
    jmp .L2968
.L2967:
.L2968:
    add r12, 1
.L2966:
    jmp .L2964
.L2965:
    sub rsp, 32
.kl1114:
    call text_new
    add rsp, 32
    jmp .__ret_2961
.__ret_2961:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_obj.kft, .kfe, .kfn, __kron_file_9,7
    dq .kl1108,273
    dq .kl1109,274
    dq .kl1110,276
    dq .kl1111,277
    dq .kl1112,278
    dq .kl1113,279
    dq .kl1114,283
.kfn: db "md_mtl_texture", 0
section .text
md_flat_normals:
    push rbp
    mov rbp, rsp
    sub rsp, 224
    mov [rbp-192], rbx
    mov [rbp-184], r12
    mov [rbp-176], r13
    mov [rbp-168], r14
    mov rax, 0
    mov r13, rax
.L2971:
    mov rax, r13
    add rax, 2
    push rax
    mov rax, [rel __g_mi]
    push rax
    pop rcx
    sub rsp, 32
.kl1115:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L2972
    mov rax, [rel __g_mi]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
.kl1116:
    call list_get
    add rsp, 32
    mov rcx, 8
    imul rax, rcx
    mov r14, rax
    mov rax, [rel __g_mi]
    push rax
    mov rax, r13
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1117:
    call list_get
    add rsp, 32
    mov rcx, 8
    imul rax, rcx
    mov r12, rax
    mov rax, [rel __g_mi]
    push rax
    mov rax, r13
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1118:
    call list_get
    add rsp, 32
    mov rcx, 8
    imul rax, rcx
    mov rbx, rax
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
.kl1119:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
    push rax
    mov rax, r14
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
    push rax
    mov rax, r14
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
    lea r11, [rbp-48]
    call v3
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl1120:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
    push rax
    mov rax, r12
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
    lea r11, [rbp-64]
    call v3
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl1121:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rax, [rel __g_mv]
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
    mov rax, [rel __g_mv]
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
    lea r11, [rbp-80]
    call v3
    add rsp, 32
    lea rax, [rbp-64]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1122:
    lea r11, [rbp-128]
    call v3_sub
    add rsp, 32
    push rax
    lea rax, [rbp-80]
    push rax
    lea rax, [rbp-48]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-144]
    call v3_sub
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-112]
    call v3_cross
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    lea r11, [rbp-96]
    call v3_norm
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L2974:
    cmp r12, 3
    jge .L2975
    mov rax, [rel __g_mi]
    push rax
    mov rax, r13
    add rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1123:
    call list_get
    add rsp, 32
    mov rcx, 8
    imul rax, rcx
    mov rbx, rax
    mov rax, [rel __g_mv]
    push rax
    mov rax, rbx
    add rax, 3
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1124:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2983: dq 0.0
section .text
    movsd xmm0, [rel .flt2983]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2981
    mov rax, [rel __g_mv]
    push rax
    mov rax, rbx
    add rax, 4
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2984: dq 0.0
section .text
    movsd xmm0, [rel .flt2984]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2981
    mov rax, 1
    jmp .L2982
.L2981:
    mov rax, 0
.L2982:
    test rax, rax
    jz .L2979
    mov rax, [rel __g_mv]
    push rax
    mov rax, rbx
    add rax, 5
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt2985: dq 0.0
section .text
    movsd xmm0, [rel .flt2985]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    sete al
    movzx rax, al
    test rax, rax
    jz .L2979
    mov rax, 1
    jmp .L2980
.L2979:
    mov rax, 0
.L2980:
    test rax, rax
    jz .L2977
    mov rax, [rel __g_mv]
    push rax
    mov rax, rbx
    add rax, 3
    push rax
    movss xmm0, [rbp-96]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1125:
    call list_set_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    mov rax, rbx
    add rax, 4
    push rax
    movss xmm0, [rbp-92]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1126:
    call list_set_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    mov rax, rbx
    add rax, 5
    push rax
    movss xmm0, [rbp-88]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1127:
    call list_set_real
    add rsp, 32
    jmp .L2978
.L2977:
.L2978:
    add r12, 1
.L2976:
    jmp .L2974
.L2975:
    add r13, 3
.L2973:
    jmp .L2971
.L2972:
    mov rax, 0
    jmp .__ret_2970
.__ret_2970:
    mov rbx, [rbp-192]
    mov r12, [rbp-184]
    mov r13, [rbp-176]
    mov r14, [rbp-168]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_mtl_texture.kft, .kfe, .kfn, __kron_file_9,13
    dq .kl1115,289
    dq .kl1116,290
    dq .kl1117,291
    dq .kl1118,292
    dq .kl1119,293
    dq .kl1120,294
    dq .kl1121,295
    dq .kl1122,296
    dq .kl1123,299
    dq .kl1124,300
    dq .kl1125,301
    dq .kl1126,302
    dq .kl1127,303
.kfn: db "md_flat_normals", 0
section .text
section .data
__g_gl_doc: dq 0
section .text
section .data
__g_gl_bufs: dq 0
section .text
section .data
__g_gl_blen: dq 0
section .text
section .data
__g_gl_dir: dq 0
section .text
section .data
__g_gl_last_len: dq 0
section .text
md_read_bytes:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str2987: db 114,0
section .text
    lea rax, [rel .str2987]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1128:
    call file_open
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L2988
    mov rax, 0
    jmp .__ret_2986
    jmp .L2989
.L2988:
.L2989:
    mov rcx, r13
    sub rsp, 32
.kl1129:
    call file_size
    add rsp, 32
    mov r12, rax
    mov rax, r12
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
.kl1130:
    call hp_alloc
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L2990
    mov rcx, r13
    mov rdx, 0
    mov r8, rbx
    mov r9, r12
    sub rsp, 32
.kl1131:
    call file_read_at
    add rsp, 32
    jmp .L2991
.L2990:
.L2991:
    mov rcx, r13
    sub rsp, 32
.kl1132:
    call file_close
    add rsp, 32
    mov rax, r12
    mov [rel __g_gl_last_len], rax
    mov rax, rbx
    jmp .__ret_2986
.__ret_2986:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_flat_normals.kft, .kfe, .kfn, __kron_file_9,5
    dq .kl1128,320
    dq .kl1129,322
    dq .kl1130,323
    dq .kl1131,325
    dq .kl1132,327
.kfn: db "md_read_bytes", 0
section .text
md_b64:
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
    jz .L2995
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2995
    mov rax, 1
    jmp .L2996
.L2995:
    mov rax, 0
.L2996:
    test rax, rax
    jz .L2993
    mov rax, rbx
    sub rax, 65
    jmp .__ret_2992
    jmp .L2994
.L2993:
.L2994:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L2999
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L2999
    mov rax, 1
    jmp .L3000
.L2999:
    mov rax, 0
.L3000:
    test rax, rax
    jz .L2997
    mov rax, rbx
    sub rax, 71
    jmp .__ret_2992
    jmp .L2998
.L2997:
.L2998:
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L3003
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L3003
    mov rax, 1
    jmp .L3004
.L3003:
    mov rax, 0
.L3004:
    test rax, rax
    jz .L3001
    mov rax, rbx
    add rax, 4
    jmp .__ret_2992
    jmp .L3002
.L3001:
.L3002:
    mov rax, rbx
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3007
    mov rax, rbx
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3007
    mov rax, 0
    jmp .L3008
.L3007:
    mov rax, 1
.L3008:
    test rax, rax
    jz .L3005
    mov rax, 62
    jmp .__ret_2992
    jmp .L3006
.L3005:
.L3006:
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3011
    mov rax, rbx
    mov rcx, 95
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3011
    mov rax, 0
    jmp .L3012
.L3011:
    mov rax, 1
.L3012:
    test rax, rax
    jz .L3009
    mov rax, 63
    jmp .__ret_2992
    jmp .L3010
.L3009:
.L3010:
    mov rax, 1
    neg rax
    jmp .__ret_2992
.__ret_2992:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
md_data_uri:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov rax, r15
    push rax
section .data
.str3014: db 44,0
section .text
    lea rax, [rel .str3014]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1133:
    call text_find
    add rsp, 32
    mov rbx, rax
    mov rcx, r15
    sub rsp, 32
.kl1134:
    call text_len
    add rsp, 32
    mov [rbp-24], rax
    mov rax, [rbp-24]
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
.kl1135:
    call hp_alloc
    add rsp, 32
    mov [rbp-32], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, rbx
    add rax, 1
    mov rbx, rax
.L3015:
    mov rax, rbx
    mov rcx, [rbp-24]
    cmp rax, rcx
    jge .L3016
    mov rcx, r15
    mov rdx, rbx
    sub rsp, 32
.kl1136:
    call text_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_b64
    add rsp, 32
    mov [rbp-72], rax
    mov rax, [rbp-72]
    cmp rax, 0
    jl .L3018
    mov rax, r13
    shl rax, 6
    mov rcx, [rbp-72]
    or rax, rcx
    mov r13, rax
    add r12, 6
    cmp r12, 8
    jl .L3020
    sub r12, 8
    mov rax, [rbp-32]
    add rax, r14
    push rax
    mov rax, r13
    mov rcx, r12
    sar rax, cl
    and rax, 255
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add r14, 1
    jmp .L3021
.L3020:
.L3021:
    jmp .L3019
.L3018:
.L3019:
    add rbx, 1
.L3017:
    jmp .L3015
.L3016:
    mov rax, r14
    mov [rel __g_gl_last_len], rax
    mov rax, [rbp-32]
    jmp .__ret_3013
.__ret_3013:
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
.kft: dq md_read_bytes.kft, .kfe, .kfn, __kron_file_9,4
    dq .kl1133,343
    dq .kl1134,344
    dq .kl1135,345
    dq .kl1136,351
.kfn: db "md_data_uri", 0
section .text
md_uri_bytes:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
section .data
.str3025: db 100,97,116,97,58,0
section .text
    lea rax, [rel .str3025]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1137:
    call text_starts
    add rsp, 32
    test rax, rax
    jz .L3023
    mov rcx, rbx
    sub rsp, 32
    call md_data_uri
    add rsp, 32
    jmp .__ret_3022
    jmp .L3024
.L3023:
.L3024:
    sub rsp, 32
.kl1138:
    call text_new
    add rsp, 32
    push rax
    mov rax, [rel __g_gl_dir]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call text_add
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov [rel __g_gl_last_len], rax
    mov rcx, rbx
    sub rsp, 32
.kl1139:
    call file_exists
    add rsp, 32
    test rax, rax
    sete al
    movzx rax, al
    test rax, rax
    jz .L3026
    mov rax, 0
    jmp .__ret_3022
    jmp .L3027
.L3026:
.L3027:
    mov rcx, rbx
    sub rsp, 32
.kl1140:
    call md_read_bytes
    add rsp, 32
    jmp .__ret_3022
.__ret_3022:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_data_uri.kft, .kfe, .kfn, __kron_file_9,4
    dq .kl1137,368
    dq .kl1138,369
    dq .kl1139,371
    dq .kl1140,372
.kfn: db "md_uri_bytes", 0
section .text
gl_u32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov eax, dword [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_3028
.__ret_3028:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
md_gltf:
    push rbp
    mov rbp, rsp
    sub rsp, 368
    mov [rbp-336], rbx
    mov [rbp-328], r12
    mov [rbp-320], r13
    mov [rbp-312], r14
    mov [rbp-304], r15
    mov rbx, rcx
    sub rsp, 32
.kl1141:
    call md_init
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl1142:
    call md_dir
    add rsp, 32
    mov [rel __g_gl_dir], rax
    sub rsp, 32
.kl1143:
    call list_new
    add rsp, 32
    mov [rel __g_gl_bufs], rax
    sub rsp, 32
.kl1144:
    call list_new
    add rsp, 32
    mov [rel __g_gl_blen], rax
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    sub rsp, 32
.kl1145:
    call text_new
    add rsp, 32
    mov r15, rax
    mov rcx, rbx
    sub rsp, 32
.kl1146:
    call file_exists
    add rsp, 32
    test rax, rax
    sete al
    movzx rax, al
    test rax, rax
    jz .L3030
section .data
.str3032: db 99,97,110,110,111,116,32,114,101,97,100,32,116,104,101,32,109,111,100,101,108,32,102,105,108,101,0
section .text
    lea rax, [rel .str3032]
    push rax
section .data
.str3033: db 99,104,101,99,107,32,116,104,101,32,110,97,109,101,0
section .text
    lea rax, [rel .str3033]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1147:
    lea r8, [rel .kx168]
    call __fail_raise
.kx168:
    add rsp, 32
    xor rax, rax
    jmp .__ret_3029
    jmp .L3031
.L3030:
.L3031:
    mov rax, rbx
    push rax
section .data
.str3036: db 46,103,108,98,0
section .text
    lea rax, [rel .str3036]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1148:
    call md_ends
    add rsp, 32
    test rax, rax
    jz .L3034
    mov rcx, rbx
    sub rsp, 32
.kl1149:
    call md_read_bytes
    add rsp, 32
    mov r14, rax
    mov rax, [rel __g_gl_last_len]
    mov [rbp-48], rax
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3041
    mov rax, [rbp-48]
    mov rcx, 20
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L3041
    mov rax, 0
    jmp .L3042
.L3041:
    mov rax, 1
.L3042:
    test rax, rax
    jnz .L3039
    mov rcx, r14
    sub rsp, 32
.kl1150:
    call gl_u32
    add rsp, 32
    mov rcx, 1179937895
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L3039
    mov rax, 0
    jmp .L3040
.L3039:
    mov rax, 1
.L3040:
    test rax, rax
    jz .L3037
section .data
.str3043: db 116,104,105,115,32,105,115,32,110,111,32,46,103,108,98,32,102,105,108,101,0
section .text
    lea rax, [rel .str3043]
    push rax
section .data
.str3044: db 97,32,98,105,110,97,114,121,32,103,108,84,70,32,50,46,48,0
section .text
    lea rax, [rel .str3044]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1151:
    lea r8, [rel .kx169]
    call __fail_raise
.kx169:
    add rsp, 32
    xor rax, rax
    jmp .__ret_3029
    jmp .L3038
.L3037:
.L3038:
    mov rax, 12
    mov r13, rax
.L3045:
    mov rax, r13
    add rax, 8
    mov rcx, [rbp-48]
    cmp rax, rcx
    jg .L3046
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
.kl1152:
    call gl_u32
    add rsp, 32
    mov r12, rax
    mov rax, r14
    add rax, r13
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
.kl1153:
    call gl_u32
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 1313821514
    cmp rax, rcx
    jne .L3048
    mov rax, r14
    add rax, r13
    add rax, 8
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
.kl1154:
    call text_from_bytes
    add rsp, 32
    mov r15, rax
    jmp .L3049
.L3048:
    cmp rbx, 5130562
    jne .L3050
    mov rax, r14
    add rax, r13
    add rax, 8
    mov [rbp-16], rax
    mov rax, r12
    mov [rbp-24], rax
    jmp .L3051
.L3050:
.L3051:
.L3049:
    mov rax, r13
    add rax, 8
    add rax, r12
    mov r13, rax
.L3047:
    jmp .L3045
.L3046:
    jmp .L3035
.L3034:
    mov rcx, rbx
    sub rsp, 32
.kl1155:
    call file_read_all
    add rsp, 32
    mov r15, rax
.L3035:
    mov rcx, r15
    sub rsp, 32
.kl1156:
    call json_parse
    add rsp, 32
    mov [rel __g_gl_doc], rax
    mov rax, [rel __g_gl_doc]
    cmp rax, 0
    jne .L3052
section .data
.str3054: db 116,104,101,32,103,108,84,70,39,115,32,74,83,79,78,32,99,111,117,108,100,32,110,111,116,32,98,101,32,114,101,97,100,0
section .text
    lea rax, [rel .str3054]
    push rax
section .data
.str3055: db 116,104,101,32,102,105,108,101,32,109,97,121,32,98,101,32,100,97,109,97,103,101,100,0
section .text
    lea rax, [rel .str3055]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1157:
    lea r8, [rel .kx170]
    call __fail_raise
.kx170:
    add rsp, 32
    xor rax, rax
    jmp .__ret_3029
    jmp .L3053
.L3052:
.L3053:
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3056: db 98,117,102,102,101,114,115,0
section .text
    lea rax, [rel .str3056]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1158:
    call json_get
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L3057:
    mov rax, r12
    push rax
    mov rcx, r13
    sub rsp, 32
.kl1159:
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3058
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl1160:
    call json_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3060: db 117,114,105,0
section .text
    lea rax, [rel .str3060]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1161:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_text
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1162:
    call text_len
    add rsp, 32
    cmp rax, 0
    jne .L3061
    mov rax, [rel __g_gl_bufs]
    push rax
    pop rcx
    mov rdx, [rbp-16]
    sub rsp, 32
.kl1163:
    call list_add
    add rsp, 32
    mov rax, [rel __g_gl_blen]
    push rax
    pop rcx
    mov rdx, [rbp-24]
    sub rsp, 32
.kl1164:
    call list_add
    add rsp, 32
    jmp .L3062
.L3061:
    mov rax, [rel __g_gl_bufs]
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl1165:
    call md_uri_bytes
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    mov rax, [rel __g_gl_blen]
    push rax
    mov rax, [rel __g_gl_last_len]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1166:
    call list_add
    add rsp, 32
.L3062:
    add r12, 1
.L3059:
    jmp .L3057
.L3058:
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3063: db 115,99,101,110,101,115,0
section .text
    lea rax, [rel .str3063]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1167:
    call json_get
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3064: db 115,99,101,110,101,0
section .text
    lea rax, [rel .str3064]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1168:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call json_int_or
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L3065
    mov rax, rbx
    push rax
section .data
.str3067: db 110,111,100,101,115,0
section .text
    lea rax, [rel .str3067]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1169:
    call json_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L3068:
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
.kl1170:
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3069
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl1171:
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    sub rsp, 32
    lea r11, [rbp-200]
    call m4_identity
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call gl_node
    add rsp, 32
    add rbx, 1
.L3070:
    jmp .L3068
.L3069:
    jmp .L3066
.L3065:
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3071: db 109,101,115,104,101,115,0
section .text
    lea rax, [rel .str3071]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1172:
    call json_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L3072:
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
.kl1173:
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3073
    mov rax, rbx
    push rax
    sub rsp, 32
.kl1174:
    lea r11, [rbp-280]
    call m4_identity
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call gl_mesh
    add rsp, 32
    add rbx, 1
.L3074:
    jmp .L3072
.L3073:
.L3066:
    sub rsp, 32
.kl1175:
    call md_finish
    add rsp, 32
    jmp .__ret_3029
.__ret_3029:
    mov rbx, [rbp-336]
    mov r12, [rbp-328]
    mov r13, [rbp-320]
    mov r14, [rbp-312]
    mov r15, [rbp-304]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_uri_bytes.kft, .kfe, .kfn, __kron_file_9,35
    dq .kl1141,382
    dq .kl1142,383
    dq .kl1143,384
    dq .kl1144,385
    dq .kl1145,388
    dq .kl1146,389
    dq .kl1147,390
    dq .kl1148,392
    dq .kl1149,393
    dq .kl1150,395
    dq .kl1151,396
    dq .kl1152,400
    dq .kl1153,401
    dq .kl1154,403
    dq .kl1155,411
    dq .kl1156,413
    dq .kl1157,415
    dq .kl1158,418
    dq .kl1159,420
    dq .kl1160,421
    dq .kl1161,422
    dq .kl1162,423
    dq .kl1163,424
    dq .kl1164,425
    dq .kl1165,427
    dq .kl1166,428
    dq .kl1167,433
    dq .kl1168,434
    dq .kl1169,436
    dq .kl1170,438
    dq .kl1171,439
    dq .kl1172,444
    dq .kl1173,446
    dq .kl1174,447
    dq .kl1175,451
.kfn: db "md_gltf", 0
section .text
gl_node:
    push rbp
    mov rbp, rsp
    sub rsp, 384
    mov [rbp-352], rbx
    mov [rbp-344], r12
    mov [rbp-336], r13
    mov [rbp-328], r14
    mov rbx, rcx
    mov r11, [rdx + 0]
    mov [rbp-72], r11
    mov r11, [rdx + 8]
    mov [rbp-64], r11
    mov r11, [rdx + 16]
    mov [rbp-56], r11
    mov r11, [rdx + 24]
    mov [rbp-48], r11
    mov r11, [rdx + 32]
    mov [rbp-40], r11
    mov r11, [rdx + 40]
    mov [rbp-32], r11
    mov r11, [rdx + 48]
    mov [rbp-24], r11
    mov r11, [rdx + 56]
    mov [rbp-16], r11
    mov r13, r8
    cmp r13, 64
    jle .L3076
    mov rax, 0
    jmp .__ret_3075
    jmp .L3077
.L3076:
.L3077:
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3078: db 110,111,100,101,115,0
section .text
    lea rax, [rel .str3078]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1176:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L3079
    mov rax, 0
    jmp .__ret_3075
    jmp .L3080
.L3079:
.L3080:
    sub rsp, 32
.kl1177:
    lea r11, [rbp-152]
    call m4_identity
    add rsp, 32
    mov rax, r12
    push rax
section .data
.str3081: db 109,97,116,114,105,120,0
section .text
    lea rax, [rel .str3081]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1178:
    call json_get
    add rsp, 32
    mov r14, rax
    mov rcx, r14
    sub rsp, 32
.kl1179:
    call json_len
    add rsp, 32
    cmp rax, 16
    jne .L3082
    mov rax, 0
    mov rbx, rax
.L3084:
    cmp rbx, 16
    jge .L3085
    lea rax, [rbp-152]
    push rax
    mov rax, rbx
    mov rcx, 4
    cqo
    idiv rcx
    mov rax, rdx
    push rax
    mov rax, rbx
    mov rcx, 4
    cqo
    idiv rcx
    push rax
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
.kl1180:
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm3, [rsp]
    add rsp, 8
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-152]
    call m4_set
    add rsp, 32
    add rbx, 1
.L3086:
    jmp .L3084
.L3085:
    jmp .L3083
.L3082:
section .data
.flt3087: dq 0.0
section .text
    movsd xmm0, [rel .flt3087]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3088: dq 0.0
section .text
    movsd xmm0, [rel .flt3088]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3089: dq 0.0
section .text
    movsd xmm0, [rel .flt3089]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl1181:
    lea r11, [rbp-184]
    call v3
    add rsp, 32
    sub rsp, 32
.kl1182:
    lea r11, [rbp-200]
    call q_identity
    add rsp, 32
section .data
.flt3090: dq 1.0
section .text
    movsd xmm0, [rel .flt3090]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3091: dq 1.0
section .text
    movsd xmm0, [rel .flt3091]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3092: dq 1.0
section .text
    movsd xmm0, [rel .flt3092]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    movsd xmm1, [rsp]
    add rsp, 8
    movsd xmm0, [rsp]
    add rsp, 8
    sub rsp, 32
.kl1183:
    lea r11, [rbp-216]
    call v3
    add rsp, 32
    mov rax, r12
    push rax
section .data
.str3093: db 116,114,97,110,115,108,97,116,105,111,110,0
section .text
    lea rax, [rel .str3093]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1184:
    call json_get
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1185:
    call json_len
    add rsp, 32
    cmp rax, 3
    jne .L3094
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
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
    lea r11, [rbp-184]
    call v3
    add rsp, 32
    jmp .L3095
.L3094:
.L3095:
    mov rax, r12
    push rax
section .data
.str3096: db 114,111,116,97,116,105,111,110,0
section .text
    lea rax, [rel .str3096]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1186:
    call json_get
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1187:
    call json_len
    add rsp, 32
    cmp rax, 4
    jne .L3097
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 3
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
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
    lea r11, [rbp-200]
    call quat
    add rsp, 32
    jmp .L3098
.L3097:
.L3098:
    mov rax, r12
    push rax
section .data
.str3099: db 115,99,97,108,101,0
section .text
    lea rax, [rel .str3099]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1188:
    call json_get
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1189:
    call json_len
    add rsp, 32
    cmp rax, 3
    jne .L3100
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_num
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
    lea r11, [rbp-216]
    call v3
    add rsp, 32
    jmp .L3101
.L3100:
.L3101:
    lea rax, [rbp-184]
    push rax
    lea rax, [rbp-200]
    push rax
    lea rax, [rbp-216]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1190:
    lea r11, [rbp-152]
    call m4_trs
    add rsp, 32
.L3083:
    lea rax, [rbp-72]
    push rax
    lea rax, [rbp-152]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1191:
    lea r11, [rbp-304]
    call m4_mul
    add rsp, 32
    mov rax, r12
    push rax
section .data
.str3104: db 109,101,115,104,0
section .text
    lea rax, [rel .str3104]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1192:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3102
    mov rax, r12
    push rax
section .data
.str3105: db 109,101,115,104,0
section .text
    lea rax, [rel .str3105]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1193:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    lea rax, [rbp-304]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call gl_mesh
    add rsp, 32
    jmp .L3103
.L3102:
.L3103:
    mov rax, r12
    push rax
section .data
.str3106: db 99,104,105,108,100,114,101,110,0
section .text
    lea rax, [rel .str3106]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1194:
    call json_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L3107:
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
.kl1195:
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3108
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl1196:
    call json_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    lea rax, [rbp-304]
    push rax
    mov rax, r13
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call gl_node
    add rsp, 32
    add rbx, 1
.L3109:
    jmp .L3107
.L3108:
    mov rax, 1
    jmp .__ret_3075
.__ret_3075:
    mov rbx, [rbp-352]
    mov r12, [rbp-344]
    mov r13, [rbp-336]
    mov r14, [rbp-328]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq md_gltf.kft, .kfe, .kfn, __kron_file_9,21
    dq .kl1176,456
    dq .kl1177,458
    dq .kl1178,459
    dq .kl1179,460
    dq .kl1180,463
    dq .kl1181,467
    dq .kl1182,468
    dq .kl1183,469
    dq .kl1184,470
    dq .kl1185,471
    dq .kl1186,472
    dq .kl1187,473
    dq .kl1188,474
    dq .kl1189,475
    dq .kl1190,476
    dq .kl1191,478
    dq .kl1192,479
    dq .kl1193,480
    dq .kl1194,482
    dq .kl1195,484
    dq .kl1196,485
.kfn: db "gl_node", 0
section .text
section .data
__g_ga_addr: dq 0
section .text
section .data
__g_ga_stride: dq 0
section .text
section .data
__g_ga_ctype: dq 0
section .text
section .data
__g_ga_count: dq 0
section .text
gl_accessor:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rbx, rcx
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3111: db 97,99,99,101,115,115,111,114,115,0
section .text
    lea rax, [rel .str3111]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1197:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jne .L3112
    mov rax, 0
    jmp .__ret_3110
    jmp .L3113
.L3112:
.L3113:
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3114: db 98,117,102,102,101,114,86,105,101,119,115,0
section .text
    lea rax, [rel .str3114]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1198:
    call json_get
    add rsp, 32
    push rax
    mov rax, r15
    push rax
section .data
.str3115: db 98,117,102,102,101,114,86,105,101,119,0
section .text
    lea rax, [rel .str3115]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L3116
    mov rax, 0
    jmp .__ret_3110
    jmp .L3117
.L3116:
.L3117:
    mov rax, r14
    push rax
section .data
.str3118: db 98,117,102,102,101,114,0
section .text
    lea rax, [rel .str3118]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1199:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    mov r13, rax
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L3121
    mov rax, r13
    push rax
    mov rax, [rel __g_gl_bufs]
    push rax
    pop rcx
    sub rsp, 32
.kl1200:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L3121
    mov rax, 0
    jmp .L3122
.L3121:
    mov rax, 1
.L3122:
    test rax, rax
    jz .L3119
    mov rax, 0
    jmp .__ret_3110
    jmp .L3120
.L3119:
.L3120:
    mov rax, [rel __g_gl_bufs]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
.kl1201:
    call list_get
    add rsp, 32
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L3123
    mov rax, 0
    jmp .__ret_3110
    jmp .L3124
.L3123:
.L3124:
    mov rax, r15
    push rax
section .data
.str3125: db 99,111,109,112,111,110,101,110,116,84,121,112,101,0
section .text
    lea rax, [rel .str3125]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1202:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    mov [rel __g_ga_ctype], rax
    mov rax, r15
    push rax
section .data
.str3126: db 99,111,117,110,116,0
section .text
    lea rax, [rel .str3126]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1203:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    mov [rel __g_ga_count], rax
    mov rax, 1
    mov r12, rax
    mov rax, r15
    push rax
section .data
.str3127: db 116,121,112,101,0
section .text
    lea rax, [rel .str3127]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1204:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_text
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3130: db 86,69,67,50,0
section .text
    lea rax, [rel .str3130]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1205:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L3128
    mov rax, 2
    mov r12, rax
    jmp .L3129
.L3128:
.L3129:
    mov rax, rbx
    push rax
section .data
.str3133: db 86,69,67,51,0
section .text
    lea rax, [rel .str3133]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1206:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L3131
    mov rax, 3
    mov r12, rax
    jmp .L3132
.L3131:
.L3132:
    mov rax, rbx
    push rax
section .data
.str3136: db 86,69,67,52,0
section .text
    lea rax, [rel .str3136]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1207:
    call text_same
    add rsp, 32
    test rax, rax
    jz .L3134
    mov rax, 4
    mov r12, rax
    jmp .L3135
.L3134:
.L3135:
    mov rax, 4
    mov rbx, rax
    mov rax, [rel __g_ga_ctype]
    mov rcx, 5121
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3139
    mov rax, [rel __g_ga_ctype]
    mov rcx, 5120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3139
    mov rax, 0
    jmp .L3140
.L3139:
    mov rax, 1
.L3140:
    test rax, rax
    jz .L3137
    mov rax, 1
    mov rbx, rax
    jmp .L3138
.L3137:
.L3138:
    mov rax, [rel __g_ga_ctype]
    mov rcx, 5123
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3143
    mov rax, [rel __g_ga_ctype]
    mov rcx, 5122
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3143
    mov rax, 0
    jmp .L3144
.L3143:
    mov rax, 1
.L3144:
    test rax, rax
    jz .L3141
    mov rax, 2
    mov rbx, rax
    jmp .L3142
.L3141:
.L3142:
    mov rax, r14
    push rax
section .data
.str3145: db 98,121,116,101,83,116,114,105,100,101,0
section .text
    lea rax, [rel .str3145]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1208:
    call json_get
    add rsp, 32
    push rax
    mov rax, r12
    imul rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_int_or
    add rsp, 32
    mov [rel __g_ga_stride], rax
    mov rax, [rbp-40]
    push rax
    mov rax, r14
    push rax
section .data
.str3146: db 98,121,116,101,79,102,102,115,101,116,0
section .text
    lea rax, [rel .str3146]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1209:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call json_int_or
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r15
    push rax
section .data
.str3147: db 98,121,116,101,79,102,102,115,101,116,0
section .text
    lea rax, [rel .str3147]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call json_int_or
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_ga_addr], rax
    mov rax, [rel __g_ga_addr]
    mov rcx, [rbp-40]
    sub rax, rcx
    push rax
    mov rax, [rel __g_ga_count]
    sub rax, 1
    mov rcx, rax
    mov rax, [rel __g_ga_stride]
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    imul rax, rbx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, [rel __g_ga_count]
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L3150
    mov rax, rbx
    push rax
    mov rax, [rel __g_gl_blen]
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
.kl1210:
    call list_get
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L3150
    mov rax, 1
    jmp .L3151
.L3150:
    mov rax, 0
.L3151:
    test rax, rax
    jz .L3148
    mov rax, 0
    jmp .__ret_3110
    jmp .L3149
.L3148:
.L3149:
    mov rax, 1
    jmp .__ret_3110
.__ret_3110:
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
.kft: dq gl_node.kft, .kfe, .kfn, __kron_file_9,14
    dq .kl1197,498
    dq .kl1198,500
    dq .kl1199,502
    dq .kl1200,503
    dq .kl1201,504
    dq .kl1202,506
    dq .kl1203,507
    dq .kl1204,509
    dq .kl1205,510
    dq .kl1206,511
    dq .kl1207,512
    dq .kl1208,516
    dq .kl1209,517
    dq .kl1210,520
.kfn: db "gl_accessor", 0
section .text
ga_float:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    lea rax, [rbp-24]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_ga_stride]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ga_addr]
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov eax, dword [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, 0
    cmp rax, 1
    jb .L3153
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl1211:
    lea r8, [rel .kx171]
    call __fail_raise
.kx171:
    add rsp, 32
    xor rax, rax
    jmp .__ret_3152
.L3153:
    mov rcx, rax
    lea rdx, [rbp-24]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    jmp .__ret_3152
.__ret_3152:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq gl_accessor.kft, .kfe, .kfn, __kron_file_9,1
    dq .kl1211,527
.kfn: db "ga_float", 0
section .text
ga_int:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_ga_stride]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_ga_addr]
    add rax, rcx
    mov rbx, rax
    mov rax, [rel __g_ga_ctype]
    cmp rax, 5121
    jne .L3155
    mov rax, rbx
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L3156
.L3155:
    mov rax, [rel __g_ga_ctype]
    cmp rax, 5123
    jne .L3157
    mov rax, rbx
    movzx rax, word [rax]
    mov rbx, rax
    jmp .L3158
.L3157:
    mov rax, rbx
    mov eax, dword [rax]
    mov rbx, rax
.L3158:
.L3156:
    mov rax, rbx
    jmp .__ret_3154
.__ret_3154:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
gl_mesh:
    push rbp
    mov rbp, rsp
    sub rsp, 336
    mov [rbp-304], rbx
    mov [rbp-296], r12
    mov [rbp-288], r13
    mov [rbp-280], r14
    mov [rbp-272], r15
    mov rbx, rcx
    mov r11, [rdx + 0]
    mov [rbp-72], r11
    mov r11, [rdx + 8]
    mov [rbp-64], r11
    mov r11, [rdx + 16]
    mov [rbp-56], r11
    mov r11, [rdx + 24]
    mov [rbp-48], r11
    mov r11, [rdx + 32]
    mov [rbp-40], r11
    mov r11, [rdx + 40]
    mov [rbp-32], r11
    mov r11, [rdx + 48]
    mov [rbp-24], r11
    mov r11, [rdx + 56]
    mov [rbp-16], r11
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3160: db 109,101,115,104,101,115,0
section .text
    lea rax, [rel .str3160]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1212:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3161: db 112,114,105,109,105,116,105,118,101,115,0
section .text
    lea rax, [rel .str3161]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1213:
    call json_get
    add rsp, 32
    mov [rbp-88], rax
    mov rax, 0
    mov [rbp-96], rax
.L3162:
    mov rax, [rbp-96]
    push rax
    mov rcx, [rbp-88]
    sub rsp, 32
.kl1214:
    call json_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3163
    mov rcx, [rbp-88]
    mov rdx, [rbp-96]
    sub rsp, 32
.kl1215:
    call json_at
    add rsp, 32
    mov r15, rax
    mov rax, r15
    push rax
section .data
.str3165: db 109,111,100,101,0
section .text
    lea rax, [rel .str3165]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1216:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
    call json_int_or
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    push rax
section .data
.str3166: db 97,116,116,114,105,98,117,116,101,115,0
section .text
    lea rax, [rel .str3166]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1217:
    call json_get
    add rsp, 32
    mov r14, rax
    mov rax, rbx
    mov rcx, 4
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L3169
    mov rax, r14
    push rax
section .data
.str3171: db 80,79,83,73,84,73,79,78,0
section .text
    lea rax, [rel .str3171]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1218:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3169
    mov rax, 1
    jmp .L3170
.L3169:
    mov rax, 0
.L3170:
    test rax, rax
    jz .L3167
    mov rax, [rel __g_mv]
    push rax
    pop rcx
    sub rsp, 32
.kl1219:
    call list_len
    add rsp, 32
    mov rcx, 8
    cqo
    idiv rcx
    mov r13, rax
    mov rax, r14
    push rax
section .data
.str3172: db 80,79,83,73,84,73,79,78,0
section .text
    lea rax, [rel .str3172]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1220:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call gl_accessor
    add rsp, 32
    mov rax, [rel __g_ga_count]
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L3173:
    cmp rbx, r12
    jge .L3174
    lea rax, [rbp-72]
    push rax
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl1221:
    call ga_float
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call ga_float
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call ga_float
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
    lea r11, [rbp-176]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-160]
    call m4_mul_point
    add rsp, 32
section .data
.flt3176: dq 0.0
section .text
    movsd xmm0, [rel .flt3176]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3177: dq 0.0
section .text
    movsd xmm0, [rel .flt3177]
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-160]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-156]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-152]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3178: dq 0.0
section .text
    movsd xmm0, [rel .flt3178]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3179: dq 0.0
section .text
    movsd xmm0, [rel .flt3179]
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3180: dq 0.0
section .text
    movsd xmm0, [rel .flt3180]
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
.kl1222:
    call md_corner
    add rsp, 32
    add rsp, 16
    add rbx, 1
.L3175:
    jmp .L3173
.L3174:
    mov rax, r14
    push rax
section .data
.str3185: db 78,79,82,77,65,76,0
section .text
    lea rax, [rel .str3185]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1223:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3183
    mov rax, r14
    push rax
section .data
.str3186: db 78,79,82,77,65,76,0
section .text
    lea rax, [rel .str3186]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call gl_accessor
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L3183
    mov rax, 1
    jmp .L3184
.L3183:
    mov rax, 0
.L3184:
    test rax, rax
    jz .L3181
    mov rax, 0
    mov rbx, rax
.L3187:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L3190
    mov rax, rbx
    push rax
    mov rax, [rel __g_ga_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L3190
    mov rax, 1
    jmp .L3191
.L3190:
    mov rax, 0
.L3191:
    test rax, rax
    jz .L3188
    lea rax, [rbp-72]
    push rax
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl1224:
    call ga_float
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
    call ga_float
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call ga_float
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
    lea r11, [rbp-224]
    call v3
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    lea r11, [rbp-208]
    call m4_mul_dir
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    lea r11, [rbp-192]
    call v3_norm
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    mov rax, r13
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, 3
    push rax
    movss xmm0, [rbp-192]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1225:
    call list_set_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    mov rax, r13
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, 4
    push rax
    movss xmm0, [rbp-188]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1226:
    call list_set_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    mov rax, r13
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, 5
    push rax
    movss xmm0, [rbp-184]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl1227:
    call list_set_real
    add rsp, 32
    add rbx, 1
.L3189:
    jmp .L3187
.L3188:
    jmp .L3182
.L3181:
.L3182:
    mov rax, r14
    push rax
section .data
.str3198: db 84,69,88,67,79,79,82,68,95,48,0
section .text
    lea rax, [rel .str3198]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1228:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3196
    mov rax, r14
    push rax
section .data
.str3199: db 84,69,88,67,79,79,82,68,95,48,0
section .text
    lea rax, [rel .str3199]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call gl_accessor
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L3196
    mov rax, 1
    jmp .L3197
.L3196:
    mov rax, 0
.L3197:
    test rax, rax
    jz .L3194
    mov rax, [rel __g_ga_ctype]
    mov rcx, 5126
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L3194
    mov rax, 1
    jmp .L3195
.L3194:
    mov rax, 0
.L3195:
    test rax, rax
    jz .L3192
    mov rax, 0
    mov rbx, rax
.L3200:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L3203
    mov rax, rbx
    push rax
    mov rax, [rel __g_ga_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L3203
    mov rax, 1
    jmp .L3204
.L3203:
    mov rax, 0
.L3204:
    test rax, rax
    jz .L3201
    mov rax, [rel __g_mv]
    push rax
    mov rax, r13
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, 6
    push rax
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl1229:
    call ga_float
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
    call list_set_real
    add rsp, 32
    mov rax, [rel __g_mv]
    push rax
    mov rax, r13
    add rax, rbx
    mov rcx, 8
    imul rax, rcx
    add rax, 7
    push rax
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl1230:
    call ga_float
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
    call list_set_real
    add rsp, 32
    add rbx, 1
.L3202:
    jmp .L3200
.L3201:
    jmp .L3193
.L3192:
.L3193:
    mov rax, [rel __g_mi]
    push rax
    pop rcx
    sub rsp, 32
.kl1231:
    call list_len
    add rsp, 32
    mov r14, rax
    mov rax, r15
    push rax
section .data
.str3209: db 105,110,100,105,99,101,115,0
section .text
    lea rax, [rel .str3209]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1232:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3207
    mov rax, r15
    push rax
section .data
.str3210: db 105,110,100,105,99,101,115,0
section .text
    lea rax, [rel .str3210]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call gl_accessor
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L3207
    mov rax, 1
    jmp .L3208
.L3207:
    mov rax, 0
.L3208:
    test rax, rax
    jz .L3205
    mov rax, 0
    mov rbx, rax
.L3211:
    mov rax, rbx
    push rax
    mov rax, [rel __g_ga_count]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3212
    mov rax, [rel __g_mi]
    push rax
    mov rax, r13
    push rax
    mov rcx, rbx
    sub rsp, 32
.kl1233:
    call ga_int
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call list_add
    add rsp, 32
    add rbx, 1
.L3213:
    jmp .L3211
.L3212:
    jmp .L3206
.L3205:
    mov rax, 0
    mov rbx, rax
.L3214:
    cmp rbx, r12
    jge .L3215
    mov rax, [rel __g_mi]
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1234:
    call list_add
    add rsp, 32
    add rbx, 1
.L3216:
    jmp .L3214
.L3215:
.L3206:
    lea rax, [rbp-72]
    push rax
    pop rcx
    sub rsp, 32
.kl1235:
    call gl_det3
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt3219: dq 0.0
section .text
    movsd xmm0, [rel .flt3219]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    ucomisd xmm0, xmm1
    setb al
    movzx rax, al
    test rax, rax
    jz .L3217
    mov rax, r14
    mov r12, rax
.L3220:
    mov rax, r12
    add rax, 2
    push rax
    mov rax, [rel __g_mi]
    push rax
    pop rcx
    sub rsp, 32
.kl1236:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3221
    mov rax, [rel __g_mi]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1237:
    call list_get
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_mi]
    push rax
    mov rax, r12
    add rax, 1
    push rax
    mov rax, [rel __g_mi]
    push rax
    mov rax, r12
    add rax, 2
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1238:
    call list_get
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call list_set
    add rsp, 32
    mov rax, [rel __g_mi]
    push rax
    mov rax, r12
    add rax, 2
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl1239:
    call list_set
    add rsp, 32
    add r12, 3
.L3222:
    jmp .L3220
.L3221:
    jmp .L3218
.L3217:
.L3218:
    mov rax, [rel __g_mtex]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L3225
    mov rax, r15
    push rax
section .data
.str3227: db 109,97,116,101,114,105,97,108,0
section .text
    lea rax, [rel .str3227]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1240:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3225
    mov rax, 1
    jmp .L3226
.L3225:
    mov rax, 0
.L3226:
    test rax, rax
    jz .L3223
    mov rax, r15
    push rax
section .data
.str3228: db 109,97,116,101,114,105,97,108,0
section .text
    lea rax, [rel .str3228]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1241:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call gl_material_texture
    add rsp, 32
    jmp .L3224
.L3223:
.L3224:
    jmp .L3168
.L3167:
.L3168:
    mov rax, [rbp-96]
    add rax, 1
    mov [rbp-96], rax
.L3164:
    jmp .L3162
.L3163:
    sub rsp, 32
.kl1242:
    call md_flat_normals
    add rsp, 32
    mov rax, 1
    jmp .__ret_3159
.__ret_3159:
    mov rbx, [rbp-304]
    mov r12, [rbp-296]
    mov r13, [rbp-288]
    mov r14, [rbp-280]
    mov r15, [rbp-272]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq ga_float.kft, .kfe, .kfn, __kron_file_9,31
    dq .kl1212,542
    dq .kl1213,543
    dq .kl1214,545
    dq .kl1215,546
    dq .kl1216,547
    dq .kl1217,548
    dq .kl1218,549
    dq .kl1219,550
    dq .kl1220,551
    dq .kl1221,555
    dq .kl1222,556
    dq .kl1223,559
    dq .kl1224,562
    dq .kl1225,563
    dq .kl1226,564
    dq .kl1227,565
    dq .kl1228,569
    dq .kl1229,572
    dq .kl1230,573
    dq .kl1231,577
    dq .kl1232,578
    dq .kl1233,581
    dq .kl1234,587
    dq .kl1235,592
    dq .kl1236,594
    dq .kl1237,595
    dq .kl1238,596
    dq .kl1239,597
    dq .kl1240,601
    dq .kl1241,602
    dq .kl1242,607
.kfn: db "gl_mesh", 0
section .text
gl_det3:
    push rbp
    mov rbp, rsp
    sub rsp, 96
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
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
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
    movss xmm0, [rbp-60]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-24]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-28]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
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
    movss xmm0, [rbp-32]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-60]
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
    movss xmm0, [rbp-44]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    subsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    jmp .__ret_3229
.__ret_3229:
    mov rsp, rbp
    pop rbp
    ret
gl_material_texture:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov rbx, rcx
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3231: db 109,97,116,101,114,105,97,108,115,0
section .text
    lea rax, [rel .str3231]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1243:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3232: db 112,98,114,77,101,116,97,108,108,105,99,82,111,117,103,104,110,101,115,115,0
section .text
    lea rax, [rel .str3232]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1244:
    call json_get
    add rsp, 32
    push rax
section .data
.str3233: db 98,97,115,101,67,111,108,111,114,84,101,120,116,117,114,101,0
section .text
    lea rax, [rel .str3233]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
section .data
.str3234: db 105,110,100,101,120,0
section .text
    lea rax, [rel .str3234]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L3235
    mov rax, 0
    jmp .__ret_3230
    jmp .L3236
.L3235:
.L3236:
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3237: db 116,101,120,116,117,114,101,115,0
section .text
    lea rax, [rel .str3237]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1245:
    call json_get
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3238: db 105,109,97,103,101,115,0
section .text
    lea rax, [rel .str3238]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1246:
    call json_get
    add rsp, 32
    push rax
    mov rax, rbx
    push rax
section .data
.str3239: db 115,111,117,114,99,101,0
section .text
    lea rax, [rel .str3239]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L3240
    mov rax, 0
    jmp .__ret_3230
    jmp .L3241
.L3240:
.L3241:
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    push rax
section .data
.str3244: db 98,117,102,102,101,114,86,105,101,119,0
section .text
    lea rax, [rel .str3244]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1247:
    call json_has
    add rsp, 32
    test rax, rax
    jz .L3242
    mov rax, [rel __g_gl_doc]
    push rax
section .data
.str3245: db 98,117,102,102,101,114,86,105,101,119,115,0
section .text
    lea rax, [rel .str3245]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1248:
    call json_get
    add rsp, 32
    push rax
    mov rax, r12
    push rax
section .data
.str3246: db 98,117,102,102,101,114,86,105,101,119,0
section .text
    lea rax, [rel .str3246]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_at
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
section .data
.str3247: db 98,117,102,102,101,114,0
section .text
    lea rax, [rel .str3247]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1249:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L3250
    mov rax, rbx
    push rax
    mov rax, [rel __g_gl_bufs]
    push rax
    pop rcx
    sub rsp, 32
.kl1250:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jnz .L3250
    mov rax, 0
    jmp .L3251
.L3250:
    mov rax, 1
.L3251:
    test rax, rax
    jz .L3248
    mov rax, 0
    jmp .__ret_3230
    jmp .L3249
.L3248:
.L3249:
    mov rax, [rel __g_gl_bufs]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl1251:
    call list_get
    add rsp, 32
    push rax
    mov rax, r12
    push rax
section .data
.str3252: db 98,121,116,101,79,102,102,115,101,116,0
section .text
    lea rax, [rel .str3252]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call json_get
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call json_int_or
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, r12
    push rax
section .data
.str3253: db 98,121,116,101,76,101,110,103,116,104,0
section .text
    lea rax, [rel .str3253]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1252:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_int
    add rsp, 32
    mov rbx, rax
    jmp .L3243
.L3242:
    mov rax, r12
    push rax
section .data
.str3254: db 117,114,105,0
section .text
    lea rax, [rel .str3254]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1253:
    call json_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call json_text
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call md_uri_bytes
    add rsp, 32
    mov r13, rax
    mov rax, [rel __g_gl_last_len]
    mov rbx, rax
.L3243:
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L3257
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jnz .L3257
    mov rax, 0
    jmp .L3258
.L3257:
    mov rax, 1
.L3258:
    test rax, rax
    jz .L3255
    mov rax, 0
    jmp .__ret_3230
    jmp .L3256
.L3255:
.L3256:
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
.kl1254:
    call image_from_bytes
    add rsp, 32
    mov [rel __g_mtex], rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L3259
    mov rax, 0
    mov [rel __g_mtex], rax
    jmp .L3260
.L3259:
.L3260:
    mov rax, 1
    jmp .__ret_3230
.__ret_3230:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq gl_mesh.kft, .kfe, .kfn, __kron_file_9,12
    dq .kl1243,616
    dq .kl1244,617
    dq .kl1245,619
    dq .kl1246,620
    dq .kl1247,624
    dq .kl1248,625
    dq .kl1249,626
    dq .kl1250,627
    dq .kl1251,628
    dq .kl1252,629
    dq .kl1253,631
    dq .kl1254,635
.kfn: db "gl_material_texture", 0
section .text
line:
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
.kl1255:
    call model_vertices
    add rsp, 32
    mov r13, rax
    sub rsp, 32
.kl1256:
    call text_new
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L3262:
    cmp rbx, 8
    jge .L3263
    mov rax, r12
    push rax
    mov rax, r13
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    add rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1257:
    call list_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
    call text_add_real
    add rsp, 32
    cmp rbx, 7
    jge .L3265
    mov rax, r12
    push rax
section .data
.str3267: db 32,0
section .text
    lea rax, [rel .str3267]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1258:
    call text_add
    add rsp, 32
    jmp .L3266
.L3265:
.L3266:
    add rbx, 1
.L3264:
    jmp .L3262
.L3263:
    mov rcx, r12
    sub rsp, 32
.kl1259:
    call say
    add rsp, 32
    mov rax, 0
    jmp .__ret_3261
.__ret_3261:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq gl_material_texture.kft, .kfe, .kfn, __kron_file_10,5
    dq .kl1255,10
    dq .kl1256,11
    dq .kl1257,14
    dq .kl1258,15
    dq .kl1259,18
.kfn: db "line", 0
section .text
summary:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov r14, rcx
    sub rsp, 32
.kl1260:
    call text_new
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
section .data
.str3269: db 99,111,114,110,101,114,115,32,0
section .text
    lea rax, [rel .str3269]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1261:
    call text_add
    add rsp, 32
    mov rax, r13
    push rax
    mov rcx, r14
    sub rsp, 32
.kl1262:
    call model_corners
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add_int
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str3270: db 32,116,114,105,97,110,103,108,101,115,32,0
section .text
    lea rax, [rel .str3270]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1263:
    call text_add
    add rsp, 32
    mov rax, r13
    push rax
    mov rcx, r14
    sub rsp, 32
.kl1264:
    call model_triangles
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add_int
    add rsp, 32
    mov rax, r13
    push rax
section .data
.str3271: db 58,0
section .text
    lea rax, [rel .str3271]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1265:
    call text_add
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl1266:
    call model_indices
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L3272:
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
.kl1267:
    call list_len
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3273
    mov rax, r13
    push rax
section .data
.str3275: db 32,0
section .text
    lea rax, [rel .str3275]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1268:
    call text_add
    add rsp, 32
    mov rax, r13
    push rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
.kl1269:
    call list_get
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add_int
    add rsp, 32
    add rbx, 1
.L3274:
    jmp .L3272
.L3273:
    mov rcx, r13
    sub rsp, 32
.kl1270:
    call say
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L3276:
    mov rax, rbx
    push rax
    mov rcx, r14
    sub rsp, 32
.kl1271:
    call model_corners
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L3277
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
.kl1272:
    call line
    add rsp, 32
    add rbx, 1
.L3278:
    jmp .L3276
.L3277:
    mov rcx, r14
    sub rsp, 32
.kl1273:
    lea r11, [rbp-56]
    call model_bounds_min
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl1274:
    lea r11, [rbp-72]
    call model_bounds_max
    add rsp, 32
    sub rsp, 32
.kl1275:
    call text_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3279: db 98,111,120,32,0
section .text
    lea rax, [rel .str3279]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1276:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
    movss xmm0, [rbp-56]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl1277:
    call text_add_real
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3280: db 32,0
section .text
    lea rax, [rel .str3280]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
    movss xmm0, [rbp-52]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
    call text_add_real
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3281: db 32,0
section .text
    lea rax, [rel .str3281]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
    movss xmm0, [rbp-48]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
    call text_add_real
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3282: db 32,116,111,32,0
section .text
    lea rax, [rel .str3282]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1278:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
    movss xmm0, [rbp-72]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
.kl1279:
    call text_add_real
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3283: db 32,0
section .text
    lea rax, [rel .str3283]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
    movss xmm0, [rbp-68]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
    call text_add_real
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3284: db 32,0
section .text
    lea rax, [rel .str3284]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
    movss xmm0, [rbp-64]
    cvtss2sd xmm0, xmm0
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm1, [rsp]
    add rsp, 8
    pop rcx
    mov r8, 2
    sub rsp, 32
    call text_add_real
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl1280:
    call say
    add rsp, 32
    mov rax, 0
    jmp .__ret_3268
.__ret_3268:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq line.kft, .kfe, .kfn, __kron_file_10,21
    dq .kl1260,23
    dq .kl1261,24
    dq .kl1262,25
    dq .kl1263,26
    dq .kl1264,27
    dq .kl1265,28
    dq .kl1266,29
    dq .kl1267,31
    dq .kl1268,32
    dq .kl1269,33
    dq .kl1270,36
    dq .kl1271,38
    dq .kl1272,39
    dq .kl1273,42
    dq .kl1274,43
    dq .kl1275,44
    dq .kl1276,45
    dq .kl1277,46
    dq .kl1278,47
    dq .kl1279,48
    dq .kl1280,49
.kfn: db "summary", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    sub rsp, 32
    call __rt_init
    add rsp, 32
    sub rsp, 32
    call list_new
    add rsp, 32
    mov [rel __g_md_min], rax
    sub rsp, 32
    call list_new
    add rsp, 32
    mov [rel __g_md_max], rax
    sub rsp, 32
.kl1281:
    call text_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3286: db 35,32,97,32,116,101,115,116,10,118,32,48,32,48,32,48,10,118,32,50,32,48,32,48,10,118,32,50,32,50,32,48,10,118,32,48,32,50,32,48,10,118,32,48,32,48,32,51,10,0
section .text
    lea rax, [rel .str3286]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1282:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3287: db 118,116,32,48,32,48,10,118,116,32,49,32,48,10,118,116,32,49,32,49,10,118,116,32,48,32,49,10,118,110,32,48,32,48,32,49,10,0
section .text
    lea rax, [rel .str3287]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1283:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3288: db 102,32,49,47,49,47,49,32,50,47,50,47,49,32,51,47,51,47,49,32,52,47,52,47,49,10,102,32,49,32,50,32,53,10,102,32,45,53,47,49,47,49,32,45,52,47,50,47,49,32,45,51,47,51,47,49,10,0
section .text
    lea rax, [rel .str3288]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1284:
    call text_add
    add rsp, 32
section .data
.str3289: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,111,98,106,0
section .text
    lea rax, [rel .str3289]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl1285:
    call file_write_all
    add rsp, 32
section .data
.str3290: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,111,98,106,0
section .text
    lea rax, [rel .str3290]
    push rax
    pop rcx
    sub rsp, 32
.kl1286:
    call model_load
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1287:
    call summary
    add rsp, 32
    sub rsp, 32
.kl1288:
    call text_new
    add rsp, 32
    push rax
section .data
.str3291: db 112,111,115,105,116,105,111,110,115,32,0
section .text
    lea rax, [rel .str3291]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call model_positions
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_len
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call say
    add rsp, 32
    sub rsp, 32
.kl1289:
    call text_new
    add rsp, 32
    push rax
section .data
.str3292: db 116,101,120,116,117,114,101,32,0
section .text
    lea rax, [rel .str3292]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add
    add rsp, 32
    push rax
    mov rcx, rbx
    sub rsp, 32
    call model_texture
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call text_add_int
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call say
    add rsp, 32
section .data
.str3293: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,111,98,106,0
section .text
    lea rax, [rel .str3293]
    push rax
    pop rcx
    sub rsp, 32
.kl1290:
    call file_delete
    add rsp, 32
    sub rsp, 32
.kl1291:
    call text_new
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str3294: db 123,34,97,115,115,101,116,34,58,123,34,118,101,114,115,105,111,110,34,58,34,50,46,48,34,125,44,34,115,99,101,110,101,34,58,48,44,34,115,99,101,110,101,115,34,58,91,123,34,110,111,100,101,115,34,58,91,48,44,49,93,125,93,44
    db 0
section .text
    lea rax, [rel .str3294]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1292:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3295: db 34,110,111,100,101,115,34,58,91,123,34,109,101,115,104,34,58,48,44,34,114,111,116,97,116,105,111,110,34,58,91,48,44,48,44,48,46,55,48,55,49,48,54,55,56,44,48,46,55,48,55,49,48,54,55,56,93,44,34,116,114,97,110,115
    db 108,97,116,105,111,110,34,58,91,53,44,48,44,48,93,125,44,0
section .text
    lea rax, [rel .str3295]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1293:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3296: db 123,34,109,101,115,104,34,58,48,44,34,115,99,97,108,101,34,58,91,45,49,44,49,44,49,93,125,93,44,0
section .text
    lea rax, [rel .str3296]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1294:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3297: db 34,109,101,115,104,101,115,34,58,91,123,34,112,114,105,109,105,116,105,118,101,115,34,58,91,123,34,97,116,116,114,105,98,117,116,101,115,34,58,123,34,80,79,83,73,84,73,79,78,34,58,48,44,34,84,69,88,67,79,79,82,68,95,48
    db 34,58,49,125,44,34,105,110,100,105,99,101,115,34,58,50,125,93,125,93,44,0
section .text
    lea rax, [rel .str3297]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1295:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3298: db 34,98,117,102,102,101,114,115,34,58,91,123,34,98,121,116,101,76,101,110,103,116,104,34,58,56,56,44,34,117,114,105,34,58,34,100,97,116,97,58,97,112,112,108,105,99,97,116,105,111,110,47,111,99,116,101,116,45,115,116,114,101,97,109
    db 59,98,97,115,101,54,52,44,0
section .text
    lea rax, [rel .str3298]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1296:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3299: db 65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,65,67,65,80,119,65,65,65,65,65,65,65,65,65,65,65,65,67,65,80,119,65,65,103,68,56,65,65,65,65,65,65,65,65,65,65,65,65,65,103,68,56,65,65,65,65,65
    db 65,65,65,65,65,65,65,65,65,65,65,65,65,73,65,47,65,65,65,65,65,65,65,65,103,68,56,65,65,73,65,47,65,65,65,65,65,65,65,65,103,68,56,65,65,81,73,65,65,103,77,65,65,65,61,61,34,125,93,44,0
section .text
    lea rax, [rel .str3299]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1297:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3300: db 34,98,117,102,102,101,114,86,105,101,119,115,34,58,91,123,34,98,117,102,102,101,114,34,58,48,44,34,98,121,116,101,79,102,102,115,101,116,34,58,48,44,34,98,121,116,101,76,101,110,103,116,104,34,58,52,56,125,44,123,34,98,117,102
    db 102,101,114,34,58,48,44,34,98,121,116,101,79,102,102,115,101,116,34,58,52,56,44,34,98,121,116,101,76,101,110,103,116,104,34,58,51,50,125,44,0
section .text
    lea rax, [rel .str3300]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1298:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3301: db 123,34,98,117,102,102,101,114,34,58,48,44,34,98,121,116,101,79,102,102,115,101,116,34,58,56,48,44,34,98,121,116,101,76,101,110,103,116,104,34,58,54,125,93,44,0
section .text
    lea rax, [rel .str3301]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1299:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3302: db 34,97,99,99,101,115,115,111,114,115,34,58,91,123,34,98,117,102,102,101,114,86,105,101,119,34,58,48,44,34,99,111,109,112,111,110,101,110,116,84,121,112,101,34,58,53,49,50,54,44,34,99,111,117,110,116,34,58,52,44,34,116,121,112
    db 101,34,58,34,86,69,67,51,34,125,44,0
section .text
    lea rax, [rel .str3302]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1300:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3303: db 123,34,98,117,102,102,101,114,86,105,101,119,34,58,49,44,34,99,111,109,112,111,110,101,110,116,84,121,112,101,34,58,53,49,50,54,44,34,99,111,117,110,116,34,58,52,44,34,116,121,112,101,34,58,34,86,69,67,50,34,125,44,0
section .text
    lea rax, [rel .str3303]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1301:
    call text_add
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str3304: db 123,34,98,117,102,102,101,114,86,105,101,119,34,58,50,44,34,99,111,109,112,111,110,101,110,116,84,121,112,101,34,58,53,49,50,49,44,34,99,111,117,110,116,34,58,54,44,34,116,121,112,101,34,58,34,83,67,65,76,65,82,34,125,93
    db 125,0
section .text
    lea rax, [rel .str3304]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl1302:
    call text_add
    add rsp, 32
section .data
.str3305: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,103,108,116,102,0
section .text
    lea rax, [rel .str3305]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl1303:
    call file_write_all
    add rsp, 32
section .data
.str3306: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,103,108,116,102,0
section .text
    lea rax, [rel .str3306]
    push rax
    pop rcx
    sub rsp, 32
.kl1304:
    call model_load
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl1305:
    call summary
    add rsp, 32
section .data
.str3307: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,103,108,116,102,0
section .text
    lea rax, [rel .str3307]
    push rax
    pop rcx
    sub rsp, 32
.kl1306:
    call file_delete
    add rsp, 32
section .data
.str3308: db 107,114,111,110,95,116,101,115,116,95,109,111,100,101,108,46,116,120,116,0
section .text
    lea rax, [rel .str3308]
    push rax
    pop rcx
    sub rsp, 32
.kl1307:
    call model_load
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L3309
section .data
.str3311: db 110,111,116,32,97,32,109,111,100,101,108,58,32,114,101,102,117,115,101,100,0
section .text
    lea rax, [rel .str3311]
    push rax
    pop rcx
    sub rsp, 32
.kl1308:
    call say
    add rsp, 32
    jmp .L3310
.L3309:
.L3310:
    mov rax, 0
    jmp .__ret_3285
.__ret_3285:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq summary.kft, .kfe, .kfn, __kron_file_10,28
    dq .kl1281,55
    dq .kl1282,56
    dq .kl1283,57
    dq .kl1284,58
    dq .kl1285,59
    dq .kl1286,60
    dq .kl1287,61
    dq .kl1288,62
    dq .kl1289,63
    dq .kl1290,64
    dq .kl1291,68
    dq .kl1292,69
    dq .kl1293,70
    dq .kl1294,71
    dq .kl1295,72
    dq .kl1296,73
    dq .kl1297,74
    dq .kl1298,75
    dq .kl1299,76
    dq .kl1300,77
    dq .kl1301,78
    dq .kl1302,79
    dq .kl1303,80
    dq .kl1304,81
    dq .kl1305,82
    dq .kl1306,83
    dq .kl1307,86
    dq .kl1308,87
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
__kron_file_4: db 115,116,100,95,106,115,111,110,46,107,114,0
__kron_file_5: db 115,116,100,95,102,105,108,101,46,107,114,0
__kron_file_6: db 115,116,100,95,109,97,116,104,46,107,114,0
__kron_file_7: db 115,116,100,95,105,109,97,103,101,46,107,114,0
__kron_file_8: db 115,116,100,95,109,97,116,104,51,100,46,107,114,0
__kron_file_9: db 115,116,100,95,109,111,100,101,108,46,107,114,0
__kron_file_10: db 116,101,115,116,95,109,111,100,101,108,46,107,114,0
section .text
