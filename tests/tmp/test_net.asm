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
__g_NET_AF_INET: dq 2
section .text
section .data
__g_NET_SOCK_STREAM: dq 1
section .text
section .data
__g_NET_IPPROTO_TCP: dq 6
section .text
section .data
__g_NET_SYS_CLOSE: dq 3
section .text
section .data
__g_NET_SYS_SOCKET: dq 41
section .text
section .data
__g_NET_SYS_CONNECT: dq 42
section .text
section .data
__g_NET_SYS_ACCEPT: dq 43
section .text
section .data
__g_NET_SYS_SENDTO: dq 44
section .text
section .data
__g_NET_SYS_RECVFROM: dq 45
section .text
section .data
__g_NET_SYS_BIND: dq 49
section .text
section .data
__g_NET_SYS_LISTEN: dq 50
section .text
section .data
__g_NET_SYS_SETSOCKOPT: dq 54
section .text
section .data
__g_NET_SOL_SOCKET: dq 1
section .text
section .data
__g_NET_SO_REUSEADDR: dq 2
section .text
section .data
__g_NET_MSG_NOSIGNAL: dq 16384
section .text
section .data
__g_net_ready: dq 0
section .text
section .bss
__g_net_wsa: resq 64
section .text
section .data
__g_p_startup: dq 0
section .text
section .data
__g_p_socket: dq 0
section .text
section .data
__g_p_bind: dq 0
section .text
section .data
__g_p_listen: dq 0
section .text
section .data
__g_p_accept: dq 0
section .text
section .data
__g_p_connect: dq 0
section .text
section .data
__g_p_send: dq 0
section .text
section .data
__g_p_recv: dq 0
section .text
section .data
__g_p_close: dq 0
section .text
net_int:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    shl rax, 32
    sar rax, 32
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
net_linux:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jge .L2
    mov rax, 1
    neg rax
    jmp .__ret_1
    jmp .L3
.L2:
.L3:
    mov rax, rbx
    jmp .__ret_1
.__ret_1:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
net_is_linux:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 1
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    jmp .__ret_4
.__ret_4:
    mov rsp, rbp
    pop rbp
    ret
net_addr:
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
    mov rbx, r9
    mov r12, r10
    mov rax, r15
    and rax, 255
    push rax
    mov rax, r14
    and rax, 255
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r13
    and rax, 255
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, rbx
    and rax, 255
    shl rax, 24
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    mov rax, r12
    sar rax, 8
    and rax, 255
    shl rax, 16
    mov rcx, rax
    mov rax, [rel __g_NET_AF_INET]
    or rax, rcx
    push rax
    mov rax, r12
    and rax, 255
    shl rax, 24
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, rbx
    shl rax, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
net_init:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_net_ready]
    cmp rax, 0
    je .L7
    mov rax, 1
    jmp .__ret_6
    jmp .L8
.L7:
.L8:
    sub rsp, 32
.kl0:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L9
    mov rax, 1
    mov [rel __g_net_ready], rax
    mov rax, 1
    jmp .__ret_6
    jmp .L10
.L9:
.L10:
section .data
.str11: db 119,115,50,95,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str11]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L12
section .data
.str14: db 99,97,110,110,111,116,32,108,111,97,100,32,119,115,50,95,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str14]
    push rax
section .data
.str15: db 110,101,116,119,111,114,107,105,110,103,32,110,101,101,100,115,32,87,105,110,100,111,119,115,32,115,111,99,107,101,116,115,0
section .text
    lea rax, [rel .str15]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1:
    lea r8, [rel .kx0]
    call __fail_raise
.kx0:
    add rsp, 32
    xor rax, rax
    jmp .__ret_6
    jmp .L13
.L12:
.L13:
    mov rax, rbx
    push rax
section .data
.str16: db 87,83,65,83,116,97,114,116,117,112,0
section .text
    lea rax, [rel .str16]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_startup], rax
    mov rax, rbx
    push rax
section .data
.str17: db 115,111,99,107,101,116,0
section .text
    lea rax, [rel .str17]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_socket], rax
    mov rax, rbx
    push rax
section .data
.str18: db 98,105,110,100,0
section .text
    lea rax, [rel .str18]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_bind], rax
    mov rax, rbx
    push rax
section .data
.str19: db 108,105,115,116,101,110,0
section .text
    lea rax, [rel .str19]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_listen], rax
    mov rax, rbx
    push rax
section .data
.str20: db 97,99,99,101,112,116,0
section .text
    lea rax, [rel .str20]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_accept], rax
    mov rax, rbx
    push rax
section .data
.str21: db 99,111,110,110,101,99,116,0
section .text
    lea rax, [rel .str21]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_connect], rax
    mov rax, rbx
    push rax
section .data
.str22: db 115,101,110,100,0
section .text
    lea rax, [rel .str22]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_send], rax
    mov rax, rbx
    push rax
section .data
.str23: db 114,101,99,118,0
section .text
    lea rax, [rel .str23]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_recv], rax
    mov rax, rbx
    push rax
section .data
.str24: db 99,108,111,115,101,115,111,99,107,101,116,0
section .text
    lea rax, [rel .str24]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_p_close], rax
    mov rax, [rel __g_p_startup]
    push rax
    mov rax, 514
    push rax
    lea rax, [rel __g_net_wsa]
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl2:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl3:
    call net_int
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L25
section .data
.str27: db 116,104,101,32,110,101,116,119,111,114,107,32,99,111,117,108,100,32,110,111,116,32,115,116,97,114,116,0
section .text
    lea rax, [rel .str27]
    push rax
section .data
.str28: db 87,83,65,83,116,97,114,116,117,112,32,114,101,102,117,115,101,100,58,32,99,104,101,99,107,32,116,104,97,116,32,110,101,116,119,111,114,107,105,110,103,32,105,115,32,97,118,97,105,108,97,98,108,101,0
section .text
    lea rax, [rel .str28]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl4:
    lea r8, [rel .kx1]
    call __fail_raise
.kx1:
    add rsp, 32
    xor rax, rax
    jmp .__ret_6
    jmp .L26
.L25:
.L26:
    mov rax, 1
    mov [rel __g_net_ready], rax
    mov rax, 1
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,5
    dq .kl0,99
    dq .kl1,107
    dq .kl2,119
    dq .kl3,121
    dq .kl4,123
.kfn: db "net_init", 0
section .text
net_sys_socket:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl5:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L30
    mov rax, [rel __g_NET_SYS_SOCKET]
    push rax
    mov rax, [rel __g_NET_AF_INET]
    push rax
    mov rax, [rel __g_NET_SOCK_STREAM]
    push rax
    mov rax, [rel __g_NET_IPPROTO_TCP]
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl6:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl7:
    call net_linux
    add rsp, 32
    jmp .__ret_29
    jmp .L31
.L30:
.L31:
    mov rax, [rel __g_p_socket]
    push rax
    mov rax, [rel __g_NET_AF_INET]
    push rax
    mov rax, [rel __g_NET_SOCK_STREAM]
    push rax
    mov rax, [rel __g_NET_IPPROTO_TCP]
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
.kl8:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_29
.__ret_29:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_init.kft, .kfe, .kfn, __kron_file_0,4
    dq .kl5,133
    dq .kl6,135
    dq .kl7,137
    dq .kl8,140
.kfn: db "net_sys_socket", 0
section .text
net_sys_bind:
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
    mov rax, 0
    cmp rax, 1
    jb .L33
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl9:
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_32
.L33:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rbp-32]
    mov [rdx+rcx*8], rax
    sub rsp, 32
.kl10:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L34
    mov rax, [rel __g_NET_SYS_SETSOCKOPT]
    push rax
    mov rax, r13
    push rax
    mov rax, [rel __g_NET_SOL_SOCKET]
    push rax
    mov rax, [rel __g_NET_SO_REUSEADDR]
    push rax
    lea rax, [rbp-32]
    push rax
    mov rax, 4
    push rax
    pop r8
    pop r10
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl11:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_NET_SYS_BIND]
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, 16
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl12:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl13:
    call net_linux
    add rsp, 32
    jmp .__ret_32
    jmp .L35
.L34:
.L35:
    mov rax, [rel __g_p_bind]
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, 16
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
.kl14:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl15:
    call net_int
    add rsp, 32
    jmp .__ret_32
.__ret_32:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_socket.kft, .kfe, .kfn, __kron_file_0,7
    dq .kl9,150
    dq .kl10,151
    dq .kl11,153
    dq .kl12,154
    dq .kl13,156
    dq .kl14,159
    dq .kl15,161
.kfn: db "net_sys_bind", 0
section .text
net_sys_listen:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl16:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L37
    mov rax, [rel __g_NET_SYS_LISTEN]
    push rax
    mov rax, r12
    push rax
    mov rax, 16
    push rax
    pop rsi
    pop rdi
    pop rax
.kl17:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl18:
    call net_linux
    add rsp, 32
    jmp .__ret_36
    jmp .L38
.L37:
.L38:
    mov rax, [rel __g_p_listen]
    push rax
    mov rax, r12
    push rax
    mov rax, 16
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl19:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl20:
    call net_int
    add rsp, 32
    jmp .__ret_36
.__ret_36:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_bind.kft, .kfe, .kfn, __kron_file_0,5
    dq .kl16,166
    dq .kl17,168
    dq .kl18,170
    dq .kl19,173
    dq .kl20,175
.kfn: db "net_sys_listen", 0
section .text
net_sys_accept:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl21:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L40
    mov rax, [rel __g_NET_SYS_ACCEPT]
    push rax
    mov rax, r12
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl22:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl23:
    call net_linux
    add rsp, 32
    jmp .__ret_39
    jmp .L41
.L40:
.L41:
    mov rax, [rel __g_p_accept]
    push rax
    mov rax, r12
    push rax
    mov rax, 0
    push rax
    mov rax, 0
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
.kl24:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_39
.__ret_39:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_listen.kft, .kfe, .kfn, __kron_file_0,4
    dq .kl21,180
    dq .kl22,182
    dq .kl23,184
    dq .kl24,187
.kfn: db "net_sys_accept", 0
section .text
net_sys_connect:
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
    sub rsp, 32
.kl25:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L43
    mov rax, [rel __g_NET_SYS_CONNECT]
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, 16
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl26:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl27:
    call net_linux
    add rsp, 32
    jmp .__ret_42
    jmp .L44
.L43:
.L44:
    mov rax, [rel __g_p_connect]
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, 16
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
.kl28:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl29:
    call net_int
    add rsp, 32
    jmp .__ret_42
.__ret_42:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_accept.kft, .kfe, .kfn, __kron_file_0,5
    dq .kl25,194
    dq .kl26,196
    dq .kl27,198
    dq .kl28,201
    dq .kl29,203
.kfn: db "net_sys_connect", 0
section .text
net_sys_send:
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
    sub rsp, 32
.kl30:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L46
    mov rax, [rel __g_NET_SYS_SENDTO]
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, [rel __g_NET_MSG_NOSIGNAL]
    push rax
    mov rax, 0
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
.kl31:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl32:
    call net_linux
    add rsp, 32
    jmp .__ret_45
    jmp .L47
.L46:
.L47:
    mov rax, [rel __g_p_send]
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
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
.kl33:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl34:
    call net_int
    add rsp, 32
    jmp .__ret_45
.__ret_45:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_connect.kft, .kfe, .kfn, __kron_file_0,5
    dq .kl30,208
    dq .kl31,210
    dq .kl32,212
    dq .kl33,215
    dq .kl34,217
.kfn: db "net_sys_send", 0
section .text
net_sys_recv:
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
    sub rsp, 32
.kl35:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L49
    mov rax, [rel __g_NET_SYS_RECVFROM]
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rax, 0
    push rax
    mov rax, 0
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
.kl36:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl37:
    call net_linux
    add rsp, 32
    jmp .__ret_48
    jmp .L50
.L49:
.L50:
    mov rax, [rel __g_p_recv]
    push rax
    mov rax, r14
    push rax
    mov rax, r13
    push rax
    mov rax, r12
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
.kl38:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl39:
    call net_int
    add rsp, 32
    jmp .__ret_48
.__ret_48:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_send.kft, .kfe, .kfn, __kron_file_0,5
    dq .kl35,222
    dq .kl36,224
    dq .kl37,226
    dq .kl38,229
    dq .kl39,231
.kfn: db "net_sys_recv", 0
section .text
net_sys_close:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl40:
    call net_is_linux
    add rsp, 32
    test rax, rax
    jz .L52
    mov rax, [rel __g_NET_SYS_CLOSE]
    push rax
    mov rax, r12
    push rax
    pop rdi
    pop rax
.kl41:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl42:
    call net_linux
    add rsp, 32
    jmp .__ret_51
    jmp .L53
.L52:
.L53:
    mov rax, [rel __g_p_close]
    push rax
    mov rax, r12
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl43:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl44:
    call net_int
    add rsp, 32
    jmp .__ret_51
.__ret_51:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_sys_recv.kft, .kfe, .kfn, __kron_file_0,5
    dq .kl40,236
    dq .kl41,238
    dq .kl42,240
    dq .kl43,243
    dq .kl44,245
.kfn: db "net_sys_close", 0
section .text
net_listen_on:
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
    mov r15, r8
    mov r14, r9
    mov r13, r10
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl45:
    call net_init
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L55
section .data
.str57: db 116,104,101,32,110,101,116,119,111,114,107,32,99,111,117,108,100,32,110,111,116,32,115,116,97,114,116,0
section .text
    lea rax, [rel .str57]
    push rax
section .data
.str58: db 87,83,65,83,116,97,114,116,117,112,32,114,101,102,117,115,101,100,58,32,99,104,101,99,107,32,116,104,97,116,32,110,101,116,119,111,114,107,105,110,103,32,105,115,32,97,118,97,105,108,97,98,108,101,0
section .text
    lea rax, [rel .str58]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl46:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_54
    jmp .L56
.L55:
.L56:
    mov rax, 0
    cmp rax, 2
    jb .L59
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl47:
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_54
.L59:
    push rax
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    mov r8, r15
    mov r9, r14
    mov r10, r13
    sub rsp, 32
    call net_addr
    add rsp, 32
    pop rcx
    lea rdx, [rbp-72]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 2
    jb .L60
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl48:
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_54
.L60:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-72]
    mov [rdx+rcx*8], rax
    sub rsp, 32
.kl49:
    call net_sys_socket
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L61
section .data
.str63: db 110,111,32,115,111,99,107,101,116,32,97,118,97,105,108,97,98,108,101,0
section .text
    lea rax, [rel .str63]
    push rax
section .data
.str64: db 116,104,101,32,115,121,115,116,101,109,32,114,97,110,32,111,117,116,32,111,102,32,115,111,99,107,101,116,115,0
section .text
    lea rax, [rel .str64]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl50:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_54
    jmp .L62
.L61:
.L62:
    mov rax, r12
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl51:
    call net_sys_bind
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L65
    mov rcx, r12
    sub rsp, 32
.kl52:
    call net_sys_close
    add rsp, 32
    mov rbx, rax
section .data
.str67: db 99,97,110,110,111,116,32,98,105,110,100,32,116,104,101,32,112,111,114,116,0
section .text
    lea rax, [rel .str67]
    push rax
section .data
.str68: db 97,110,111,116,104,101,114,32,112,114,111,103,114,97,109,32,109,97,121,32,98,101,32,117,115,105,110,103,32,105,116,58,32,99,104,111,111,115,101,32,97,110,111,116,104,101,114,32,112,111,114,116,0
section .text
    lea rax, [rel .str68]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl53:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_54
    jmp .L66
.L65:
.L66:
    mov rcx, r12
    sub rsp, 32
.kl54:
    call net_sys_listen
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L69
    mov rcx, r12
    sub rsp, 32
.kl55:
    call net_sys_close
    add rsp, 32
    mov rbx, rax
section .data
.str71: db 99,97,110,110,111,116,32,108,105,115,116,101,110,32,111,110,32,116,104,101,32,112,111,114,116,0
section .text
    lea rax, [rel .str71]
    push rax
section .data
.str72: db 99,104,101,99,107,32,116,104,101,32,112,111,114,116,32,97,110,100,32,116,104,101,32,97,100,100,114,101,115,115,0
section .text
    lea rax, [rel .str72]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl56:
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_54
    jmp .L70
.L69:
.L70:
    mov rax, r12
    jmp .__ret_54
.__ret_54:
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
.kft: dq net_sys_close.kft, .kfe, .kfn, __kron_file_0,12
    dq .kl45,255
    dq .kl46,257
    dq .kl47,259
    dq .kl48,260
    dq .kl49,261
    dq .kl50,263
    dq .kl51,265
    dq .kl52,267
    dq .kl53,268
    dq .kl54,270
    dq .kl55,272
    dq .kl56,273
.kfn: db "net_listen_on", 0
section .text
net_listen:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, 0
    mov rdx, 0
    mov r8, 0
    mov r9, 0
    mov r10, rbx
    sub rsp, 32
.kl57:
    call net_listen_on
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L74
section .data
.str76: db 99,97,110,110,111,116,32,108,105,115,116,101,110,32,111,110,32,116,104,101,32,112,111,114,116,0
section .text
    lea rax, [rel .str76]
    push rax
section .data
.str77: db 97,110,111,116,104,101,114,32,112,114,111,103,114,97,109,32,109,97,121,32,98,101,32,117,115,105,110,103,32,105,116,58,32,99,104,111,111,115,101,32,97,110,111,116,104,101,114,32,112,111,114,116,0
section .text
    lea rax, [rel .str77]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl58:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_73
    jmp .L75
.L74:
.L75:
    mov rax, rbx
    jmp .__ret_73
.__ret_73:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_listen_on.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl57,280
    dq .kl58,282
.kfn: db "net_listen", 0
section .text
net_accept:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl59:
    call net_sys_accept
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L79
section .data
.str81: db 97,99,99,101,112,116,32,102,97,105,108,101,100,0
section .text
    lea rax, [rel .str81]
    push rax
section .data
.str82: db 116,104,101,32,108,105,115,116,101,110,105,110,103,32,115,111,99,107,101,116,32,109,97,121,32,98,101,32,99,108,111,115,101,100,0
section .text
    lea rax, [rel .str82]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl60:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_78
    jmp .L80
.L79:
.L80:
    mov rax, rbx
    jmp .__ret_78
.__ret_78:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_listen.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl59,289
    dq .kl60,291
.kfn: db "net_accept", 0
section .text
net_connect:
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
    mov r15, r8
    mov r14, r9
    mov r13, r10
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl61:
    call net_init
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    test rax, rax
    jz .L84
section .data
.str86: db 116,104,101,32,110,101,116,119,111,114,107,32,99,111,117,108,100,32,110,111,116,32,115,116,97,114,116,0
section .text
    lea rax, [rel .str86]
    push rax
section .data
.str87: db 87,83,65,83,116,97,114,116,117,112,32,114,101,102,117,115,101,100,58,32,99,104,101,99,107,32,116,104,97,116,32,110,101,116,119,111,114,107,105,110,103,32,105,115,32,97,118,97,105,108,97,98,108,101,0
section .text
    lea rax, [rel .str87]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl62:
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_83
    jmp .L85
.L84:
.L85:
    mov rax, 0
    cmp rax, 2
    jb .L88
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl63:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_83
.L88:
    push rax
    mov rcx, [rbp-8]
    mov rdx, [rbp-16]
    mov r8, r15
    mov r9, r14
    mov r10, r13
    sub rsp, 32
    call net_addr
    add rsp, 32
    pop rcx
    lea rdx, [rbp-72]
    mov [rdx+rcx*8], rax
    mov rax, 1
    cmp rax, 2
    jb .L89
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl64:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_83
.L89:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rbp-72]
    mov [rdx+rcx*8], rax
    sub rsp, 32
.kl65:
    call net_sys_socket
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L90
section .data
.str92: db 110,111,32,115,111,99,107,101,116,32,97,118,97,105,108,97,98,108,101,0
section .text
    lea rax, [rel .str92]
    push rax
section .data
.str93: db 116,104,101,32,115,121,115,116,101,109,32,114,97,110,32,111,117,116,32,111,102,32,115,111,99,107,101,116,115,0
section .text
    lea rax, [rel .str93]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl66:
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_83
    jmp .L91
.L90:
.L91:
    mov rax, r12
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl67:
    call net_sys_connect
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L94
    mov rcx, r12
    sub rsp, 32
.kl68:
    call net_sys_close
    add rsp, 32
    mov rbx, rax
section .data
.str96: db 99,97,110,110,111,116,32,99,111,110,110,101,99,116,0
section .text
    lea rax, [rel .str96]
    push rax
section .data
.str97: db 99,104,101,99,107,32,116,104,101,32,97,100,100,114,101,115,115,32,97,110,100,32,116,104,101,32,112,111,114,116,44,32,97,110,100,32,116,104,97,116,32,116,104,101,32,115,101,114,118,101,114,32,105,115,32,108,105,115,116,101,110,105,110,103
    db 0
section .text
    lea rax, [rel .str97]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl69:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_83
    jmp .L95
.L94:
.L95:
    mov rax, r12
    jmp .__ret_83
.__ret_83:
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
.kft: dq net_accept.kft, .kfe, .kfn, __kron_file_0,9
    dq .kl61,301
    dq .kl62,303
    dq .kl63,305
    dq .kl64,306
    dq .kl65,307
    dq .kl66,309
    dq .kl67,311
    dq .kl68,313
    dq .kl69,314
.kfn: db "net_connect", 0
section .text
net_send:
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
.kl70:
    call net_sys_send
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L99
section .data
.str101: db 115,101,110,100,32,102,97,105,108,101,100,0
section .text
    lea rax, [rel .str101]
    push rax
section .data
.str102: db 116,104,101,32,99,111,110,110,101,99,116,105,111,110,32,109,97,121,32,98,101,32,99,108,111,115,101,100,0
section .text
    lea rax, [rel .str102]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl71:
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_98
    jmp .L100
.L99:
.L100:
    mov rax, rbx
    jmp .__ret_98
.__ret_98:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_connect.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl70,321
    dq .kl71,323
.kfn: db "net_send", 0
section .text
net_recv:
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
.kl72:
    call net_sys_recv
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L104
section .data
.str106: db 114,101,99,101,105,118,101,32,102,97,105,108,101,100,0
section .text
    lea rax, [rel .str106]
    push rax
section .data
.str107: db 116,104,101,32,99,111,110,110,101,99,116,105,111,110,32,109,97,121,32,98,101,32,99,108,111,115,101,100,0
section .text
    lea rax, [rel .str107]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl73:
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_103
    jmp .L105
.L104:
.L105:
    mov rax, rbx
    jmp .__ret_103
.__ret_103:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_send.kft, .kfe, .kfn, __kron_file_0,2
    dq .kl72,331
    dq .kl73,333
.kfn: db "net_recv", 0
section .text
net_close:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl74:
    call net_sys_close
    add rsp, 32
    jmp .__ret_108
.__ret_108:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_recv.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl74,340
.kfn: db "net_close", 0
section .text
section .data
__g_CH_MAX: dq 64
section .text
section .data
__g_CH_POOL: dq 1048576
section .text
section .bss
__g_ch_pool: resq 1048576
section .text
section .bss
__g_ch_base: resq 64
section .text
section .bss
__g_ch_cap: resq 64
section .text
section .bss
__g_ch_head: resq 64
section .text
section .bss
__g_ch_tail: resq 64
section .text
section .bss
__g_ch_count: resq 64
section .text
section .bss
__g_ch_closed: resq 64
section .text
section .data
__g_ch_used: dq 0
section .text
section .data
__g_ch_top: dq 0
section .text
section .data
__g_ch_ready: dq 0
section .text
chan_new:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jg .L110
section .data
.str112: db 99,104,97,110,110,101,108,32,111,102,32,122,101,114,111,32,111,114,32,110,101,103,97,116,105,118,101,32,99,97,112,97,99,105,116,121,0
section .text
    lea rax, [rel .str112]
    push rax
section .data
.str113: db 97,115,107,32,102,111,114,32,97,116,32,108,101,97,115,116,32,111,110,101,32,115,108,111,116,0
section .text
    lea rax, [rel .str113]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl75:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
    jmp .L111
.L110:
.L111:
    mov rax, [rel __g_ch_ready]
    cmp rax, 0
    jne .L114
    mov rax, 8
    mov rbx, rax
.L116:
    cmp rbx, 16
    jge .L117
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __lock_init
    add rsp, 32
    add rbx, 1
.L118:
    jmp .L116
.L117:
    mov rax, 1
    mov [rel __g_ch_ready], rax
    jmp .L115
.L114:
.L115:
    mov rax, [rel __g_ch_used]
    push rax
    mov rax, [rel __g_CH_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L119
section .data
.str121: db 110,111,32,102,114,101,101,32,99,104,97,110,110,101,108,115,32,108,101,102,116,0
section .text
    lea rax, [rel .str121]
    push rax
section .data
.str122: db 116,104,101,114,101,32,97,114,101,32,54,52,32,97,116,32,111,110,99,101,0
section .text
    lea rax, [rel .str122]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl76:
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
    jmp .L120
.L119:
.L120:
    mov rax, [rel __g_ch_top]
    add rax, r12
    push rax
    mov rax, [rel __g_CH_POOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L123
section .data
.str125: db 110,111,32,114,111,111,109,32,108,101,102,116,32,102,111,114,32,116,104,101,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str125]
    push rax
section .data
.str126: db 116,104,101,32,112,111,111,108,32,104,111,108,100,115,32,111,110,101,32,109,105,108,108,105,111,110,32,115,108,111,116,115,32,105,110,32,116,111,116,97,108,0
section .text
    lea rax, [rel .str126]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl77:
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
    jmp .L124
.L123:
.L124:
    mov rax, [rel __g_ch_used]
    mov rbx, rax
    mov rax, rbx
    cmp rax, 64
    jb .L127
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl78:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
.L127:
    push rax
    mov rax, [rel __g_ch_top]
    pop rcx
    lea rdx, [rel __g_ch_base]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L128
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl79:
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
.L128:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rel __g_ch_cap]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L129
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl80:
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
.L129:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_head]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L130
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl81:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
.L130:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_tail]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L131
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl82:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
.L131:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_count]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L132
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl83:
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_109
.L132:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_closed]
    mov [rdx+rcx*8], rax
    mov rax, [rel __g_ch_top]
    add rax, r12
    mov [rel __g_ch_top], rax
    mov rax, [rel __g_ch_used]
    add rax, 1
    mov [rel __g_ch_used], rax
    mov rax, rbx
    jmp .__ret_109
.__ret_109:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq net_close.kft, .kfe, .kfn, __kron_file_1,9
    dq .kl75,63
    dq .kl76,74
    dq .kl77,77
    dq .kl78,80
    dq .kl79,81
    dq .kl80,82
    dq .kl81,83
    dq .kl82,84
    dq .kl83,85
.kfn: db "chan_new", 0
section .text
chan_send:
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
    and rax, 7
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r14, 0
    jge .L134
section .data
.str136: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str136]
    push rax
section .data
.str137: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str137]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl84:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
    jmp .L135
.L134:
.L135:
    mov rax, r14
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L138
section .data
.str140: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str140]
    push rax
section .data
.str141: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str141]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl85:
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
    jmp .L139
.L138:
.L139:
.L142:
    cmp rbx, 0
    jne .L143
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r14
    cmp rax, 64
    jb .L147
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl86:
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L147:
    mov rcx, rax
    lea rdx, [rel __g_ch_closed]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    je .L145
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
section .data
.str148: db 115,101,110,100,32,111,110,32,97,32,99,108,111,115,101,100,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str148]
    push rax
section .data
.str149: db 99,108,111,115,101,32,97,32,99,104,97,110,110,101,108,32,111,110,108,121,32,119,104,101,110,32,101,118,101,114,121,32,115,101,110,100,101,114,32,105,115,32,100,111,110,101,0
section .text
    lea rax, [rel .str149]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl87:
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
    jmp .L146
.L145:
.L146:
    mov rax, r14
    cmp rax, 64
    jb .L152
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl88:
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L152:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L153
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L153:
    mov rcx, rax
    lea rdx, [rel __g_ch_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L150
    mov rax, r14
    cmp rax, 64
    jb .L154
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl89:
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L154:
    mov rcx, rax
    lea rdx, [rel __g_ch_base]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L155
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L155:
    mov rcx, rax
    lea rdx, [rel __g_ch_tail]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    cmp rax, 1048576
    jb .L156
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L156:
    push rax
    mov rax, r13
    pop rcx
    lea rdx, [rel __g_ch_pool]
    mov [rdx+rcx*8], rax
    mov rax, r14
    cmp rax, 64
    jb .L157
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl90:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L157:
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L158
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L158:
    mov rcx, rax
    lea rdx, [rel __g_ch_tail]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ch_tail]
    mov [rdx+rcx*8], rax
    mov rax, r14
    cmp rax, 64
    jb .L161
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl91:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L161:
    mov rcx, rax
    lea rdx, [rel __g_ch_tail]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L162
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L162:
    mov rcx, rax
    lea rdx, [rel __g_ch_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L159
    mov rax, r14
    cmp rax, 64
    jb .L163
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl92:
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L163:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_tail]
    mov [rdx+rcx*8], rax
    jmp .L160
.L159:
.L160:
    mov rax, r14
    cmp rax, 64
    jb .L164
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl93:
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L164:
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L165
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_133
.L165:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ch_count]
    mov [rdx+rcx*8], rax
    mov rax, 1
    mov rbx, rax
    jmp .L151
.L150:
.L151:
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    jne .L166
    sub rsp, 32
    call __thread_yield
    add rsp, 32
    jmp .L167
.L166:
.L167:
.L144:
    jmp .L142
.L143:
    mov rax, 1
    jmp .__ret_133
.__ret_133:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_new.kft, .kfe, .kfn, __kron_file_1,10
    dq .kl84,96
    dq .kl85,99
    dq .kl86,103
    dq .kl87,105
    dq .kl88,107
    dq .kl89,108
    dq .kl90,109
    dq .kl91,110
    dq .kl92,111
    dq .kl93,113
.kfn: db "chan_send", 0
section .text
chan_recv:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov [rbp-16], rdx
    mov rax, r13
    and rax, 7
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    mov r12, rax
    mov rax, 2
    mov rbx, rax
    cmp r13, 0
    jge .L169
section .data
.str171: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str171]
    push rax
section .data
.str172: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str172]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl94:
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
    jmp .L170
.L169:
.L170:
    mov rax, r13
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L173
section .data
.str175: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str175]
    push rax
section .data
.str176: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str176]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl95:
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
    jmp .L174
.L173:
.L174:
.L177:
    cmp rbx, 2
    jne .L178
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r13
    cmp rax, 64
    jb .L182
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl96:
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L182:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    jle .L180
    mov rax, 0
    cmp rax, 1
    jb .L183
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl97:
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L183:
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L184
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L184:
    mov rcx, rax
    lea rdx, [rel __g_ch_base]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L185
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L185:
    mov rcx, rax
    lea rdx, [rel __g_ch_head]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    cmp rax, 1048576
    jb .L186
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx49]
    call __fail_raise
.kx49:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L186:
    mov rcx, rax
    lea rdx, [rel __g_ch_pool]
    mov rax, [rdx+rcx*8]
    pop rcx
    mov rdx, [rbp-16]
    mov [rdx+rcx*8], rax
    mov rax, r13
    cmp rax, 64
    jb .L187
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl98:
    lea r8, [rel .kx50]
    call __fail_raise
.kx50:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L187:
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L188
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx51]
    call __fail_raise
.kx51:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L188:
    mov rcx, rax
    lea rdx, [rel __g_ch_head]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ch_head]
    mov [rdx+rcx*8], rax
    mov rax, r13
    cmp rax, 64
    jb .L191
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl99:
    lea r8, [rel .kx52]
    call __fail_raise
.kx52:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L191:
    mov rcx, rax
    lea rdx, [rel __g_ch_head]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L192
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx53]
    call __fail_raise
.kx53:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L192:
    mov rcx, rax
    lea rdx, [rel __g_ch_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L189
    mov rax, r13
    cmp rax, 64
    jb .L193
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl100:
    lea r8, [rel .kx54]
    call __fail_raise
.kx54:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L193:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_head]
    mov [rdx+rcx*8], rax
    jmp .L190
.L189:
.L190:
    mov rax, r13
    cmp rax, 64
    jb .L194
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl101:
    lea r8, [rel .kx55]
    call __fail_raise
.kx55:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L194:
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L195
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx56]
    call __fail_raise
.kx56:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L195:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    sub rax, 1
    pop rcx
    lea rdx, [rel __g_ch_count]
    mov [rdx+rcx*8], rax
    mov rax, 1
    mov rbx, rax
    jmp .L181
.L180:
    mov rax, r13
    cmp rax, 64
    jb .L198
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl102:
    lea r8, [rel .kx57]
    call __fail_raise
.kx57:
    add rsp, 32
    xor rax, rax
    jmp .__ret_168
.L198:
    mov rcx, rax
    lea rdx, [rel __g_ch_closed]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    je .L196
    mov rax, 0
    mov rbx, rax
    jmp .L197
.L196:
.L197:
.L181:
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 2
    jne .L199
    sub rsp, 32
    call __thread_yield
    add rsp, 32
    jmp .L200
.L199:
.L200:
.L179:
    jmp .L177
.L178:
    mov rax, rbx
    jmp .__ret_168
.__ret_168:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_send.kft, .kfe, .kfn, __kron_file_1,9
    dq .kl94,130
    dq .kl95,133
    dq .kl96,137
    dq .kl97,138
    dq .kl98,139
    dq .kl99,140
    dq .kl100,141
    dq .kl101,143
    dq .kl102,146
.kfn: db "chan_recv", 0
section .text
chan_close:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, r12
    and rax, 7
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    mov rbx, rax
    cmp r12, 0
    jge .L202
section .data
.str204: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str204]
    push rax
section .data
.str205: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str205]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl103:
    lea r8, [rel .kx58]
    call __fail_raise
.kx58:
    add rsp, 32
    xor rax, rax
    jmp .__ret_201
    jmp .L203
.L202:
.L203:
    mov rax, r12
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L206
section .data
.str208: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str208]
    push rax
section .data
.str209: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str209]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl104:
    lea r8, [rel .kx59]
    call __fail_raise
.kx59:
    add rsp, 32
    xor rax, rax
    jmp .__ret_201
    jmp .L207
.L206:
.L207:
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    cmp rax, 64
    jb .L210
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl105:
    lea r8, [rel .kx60]
    call __fail_raise
.kx60:
    add rsp, 32
    xor rax, rax
    jmp .__ret_201
.L210:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_ch_closed]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    mov rax, 0
    jmp .__ret_201
.__ret_201:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_recv.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl103,162
    dq .kl104,165
    dq .kl105,168
.kfn: db "chan_close", 0
section .text
chan_len:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, r13
    and rax, 7
    mov rcx, rax
    mov rax, 8
    add rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    cmp r13, 0
    jge .L212
section .data
.str214: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str214]
    push rax
section .data
.str215: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str215]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl106:
    lea r8, [rel .kx61]
    call __fail_raise
.kx61:
    add rsp, 32
    xor rax, rax
    jmp .__ret_211
    jmp .L213
.L212:
.L213:
    mov rax, r13
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L216
section .data
.str218: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str218]
    push rax
section .data
.str219: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str219]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl107:
    lea r8, [rel .kx62]
    call __fail_raise
.kx62:
    add rsp, 32
    xor rax, rax
    jmp .__ret_211
    jmp .L217
.L216:
.L217:
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r13
    cmp rax, 64
    jb .L220
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl108:
    lea r8, [rel .kx63]
    call __fail_raise
.kx63:
    add rsp, 32
    xor rax, rax
    jmp .__ret_211
.L220:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    mov rbx, rax
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    mov rax, rbx
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
.kft: dq chan_close.kft, .kfe, .kfn, __kron_file_1,3
    dq .kl106,178
    dq .kl107,181
    dq .kl108,184
.kfn: db "chan_len", 0
section .text
section .data
__g_result_chan: dq 0
section .text
server:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl109:
    call net_accept
    add rsp, 32
    mov r12, rax
    mov rax, r12
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    mov r8, 64
    sub rsp, 32
.kl110:
    call net_recv
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    push rax
section .data
.str222: db 112,111,110,103,0
section .text
    lea rax, [rel .str222]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
.kl111:
    call net_send
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl112:
    call net_close
    add rsp, 32
    mov rax, [rel __g_result_chan]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
.kl113:
    call chan_send
    add rsp, 32
    mov rax, 0
    jmp .__ret_221
.__ret_221:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_len.kft, .kfe, .kfn, __kron_file_2,5
    dq .kl109,30
    dq .kl110,31
    dq .kl111,32
    dq .kl112,33
    dq .kl113,34
.kfn: db "server", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    sub rsp, 32
    call __rt_init
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
.kl114:
    call chan_new
    add rsp, 32
    mov [rel __g_result_chan], rax
    mov rcx, 127
    mov rdx, 0
    mov r8, 0
    mov r9, 1
    mov r10, 47123
    sub rsp, 32
.kl115:
    call net_listen_on
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    lea rax, [rel server]
    push rax
    mov rax, r13
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov r12, rax
    mov rcx, 127
    mov rdx, 0
    mov r8, 0
    mov r9, 1
    mov r10, 47123
    sub rsp, 32
.kl116:
    call net_connect
    add rsp, 32
    mov rbx, rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, rbx
    push rax
section .data
.str224: db 112,105,110,103,0
section .text
    lea rax, [rel .str224]
    push rax
    pop rdx
    pop rcx
    mov r8, 4
    sub rsp, 32
.kl117:
    call net_send
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, rbx
    push rax
    lea rax, [rbp-64]
    push rax
    pop rdx
    pop rcx
    mov r8, 64
    sub rsp, 32
.kl118:
    call net_recv
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    lea rax, [rbp-64]
    movzx rax, byte [rax]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rel __g_result_chan]
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl119:
    call chan_recv
    add rsp, 32
    mov rax, 0
    cmp rax, 1
    jb .L225
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl120:
    lea r8, [rel .kx64]
    call __fail_raise
.kx64:
    add rsp, 32
    xor rax, rax
    jmp .__ret_223
.L225:
    mov rcx, rax
    lea rdx, [rbp-72]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl121:
    call net_close
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
.kl122:
    call net_close
    add rsp, 32
    mov rax, 9
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_223
.__ret_223:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq server.kft, .kfe, .kfn, __kron_file_2,9
    dq .kl114,41
    dq .kl115,42
    dq .kl116,45
    dq .kl117,47
    dq .kl118,48
    dq .kl119,52
    dq .kl120,53
    dq .kl121,55
    dq .kl122,56
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,110,101,116,46,107,114,0
__kron_file_1: db 115,116,100,95,99,104,97,110,46,107,114,0
__kron_file_2: db 116,101,115,116,95,110,101,116,46,107,114,0
section .text
