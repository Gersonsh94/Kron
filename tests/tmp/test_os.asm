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
section .data
__g_os_ready: dq 0
section .text
section .data
__g_os_getenvf: dq 0
section .text
section .data
__g_os_createf: dq 0
section .text
section .data
__g_os_waitf: dq 0
section .text
section .data
__g_os_codef: dq 0
section .text
section .data
__g_os_closef: dq 0
section .text
section .data
__g_os_pipef: dq 0
section .text
section .data
__g_os_infof: dq 0
section .text
section .data
__g_os_readf: dq 0
section .text
section .data
__g_os_stdf: dq 0
section .text
section .data
__g_os_exitf: dq 0
section .text
section .data
__g_os_cwdf: dq 0
section .text
section .data
__g_os_chdirf: dq 0
section .text
section .bss
__g_os_si: resq 13
section .text
section .bss
__g_os_pi: resq 3
section .text
section .bss
__g_os_sa: resq 3
section .text
section .bss
__g_os_word: resq 2
section .text
section .data
__g_os_ignore: dq 0
section .text
os_linux:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 1
    mov rcx, 2
    cmp rax, rcx
    sete al
    movzx rax, al
    jmp .__ret_929
.__ret_929:
    mov rsp, rbp
    pop rbp
    ret
os_load:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, [rel __g_os_ready]
    test rax, rax
    jz .L931
    mov rax, 1
    jmp .__ret_930
    jmp .L932
.L931:
.L932:
section .data
.str933: db 107,101,114,110,101,108,51,50,46,100,108,108,0
section .text
    lea rax, [rel .str933]
    mov rcx, rax
    sub rsp, 32
    call __dll_load
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
section .data
.str934: db 71,101,116,69,110,118,105,114,111,110,109,101,110,116,86,97,114,105,97,98,108,101,65,0
section .text
    lea rax, [rel .str934]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_getenvf], rax
    mov rax, rbx
    push rax
section .data
.str935: db 67,114,101,97,116,101,80,114,111,99,101,115,115,65,0
section .text
    lea rax, [rel .str935]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_createf], rax
    mov rax, rbx
    push rax
section .data
.str936: db 87,97,105,116,70,111,114,83,105,110,103,108,101,79,98,106,101,99,116,0
section .text
    lea rax, [rel .str936]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_waitf], rax
    mov rax, rbx
    push rax
section .data
.str937: db 71,101,116,69,120,105,116,67,111,100,101,80,114,111,99,101,115,115,0
section .text
    lea rax, [rel .str937]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_codef], rax
    mov rax, rbx
    push rax
section .data
.str938: db 67,108,111,115,101,72,97,110,100,108,101,0
section .text
    lea rax, [rel .str938]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_closef], rax
    mov rax, rbx
    push rax
section .data
.str939: db 67,114,101,97,116,101,80,105,112,101,0
section .text
    lea rax, [rel .str939]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_pipef], rax
    mov rax, rbx
    push rax
section .data
.str940: db 83,101,116,72,97,110,100,108,101,73,110,102,111,114,109,97,116,105,111,110,0
section .text
    lea rax, [rel .str940]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_infof], rax
    mov rax, rbx
    push rax
section .data
.str941: db 82,101,97,100,70,105,108,101,0
section .text
    lea rax, [rel .str941]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_readf], rax
    mov rax, rbx
    push rax
section .data
.str942: db 71,101,116,83,116,100,72,97,110,100,108,101,0
section .text
    lea rax, [rel .str942]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_stdf], rax
    mov rax, rbx
    push rax
section .data
.str943: db 69,120,105,116,80,114,111,99,101,115,115,0
section .text
    lea rax, [rel .str943]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_exitf], rax
    mov rax, rbx
    push rax
section .data
.str944: db 71,101,116,67,117,114,114,101,110,116,68,105,114,101,99,116,111,114,121,65,0
section .text
    lea rax, [rel .str944]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_cwdf], rax
    mov rax, rbx
    push rax
section .data
.str945: db 83,101,116,67,117,114,114,101,110,116,68,105,114,101,99,116,111,114,121,65,0
section .text
    lea rax, [rel .str945]
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __dll_proc
    add rsp, 32
    mov [rel __g_os_chdirf], rax
    mov rax, 1
    mov [rel __g_os_ready], rax
    mov rax, 1
    jmp .__ret_930
.__ret_930:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
os_environ:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov rax, 1
    neg rax
    mov r15, rax
    mov rax, 2
    push rax
section .data
.str947: db 47,112,114,111,99,47,115,101,108,102,47,101,110,118,105,114,111,110,0
section .text
    lea rax, [rel .str947]
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl314:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov r15, rax
    cmp r15, 0
    jge .L948
    mov rax, 0
    jmp .__ret_946
    jmp .L949
.L948:
.L949:
    mov rcx, 4096
    sub rsp, 32
.kl315:
    call tx_new
    add rsp, 32
    mov [rbp-16], rax
    mov rax, 0
    mov r14, rax
    mov rax, 1
    mov r13, rax
.L950:
    mov rax, r13
    test rax, rax
    jz .L953
    mov rax, [rbp-16]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L953
    mov rax, 1
    jmp .L954
.L953:
    mov rax, 0
.L954:
    test rax, rax
    jz .L951
    mov rax, [rbp-16]
    push rax
    mov rax, r14
    add rax, 4096
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl316:
    call tx_room
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L955
    mov rax, 0
    mov r13, rax
    jmp .L956
.L955:
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    push rax
    mov rax, r15
    push rax
    mov rax, r12
    add rax, 8
    add rax, r14
    push rax
    mov rax, 4096
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl317:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jg .L957
    mov rax, 0
    mov r13, rax
    jmp .L958
.L957:
    add r14, rbx
    mov rax, r12
    push rax
    mov rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
.L958:
.L956:
.L952:
    jmp .L950
.L951:
    mov rax, 3
    push rax
    mov rax, r15
    push rax
    pop rdi
    pop rax
.kl318:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    mov rax, [rbp-16]
    jmp .__ret_946
.__ret_946:
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
.kft: dq text_cstr.kft, .kfe, .kfn, __kron_file_3,5
    dq .kl314,79
    dq .kl315,83
    dq .kl316,87
    dq .kl317,92
    dq .kl318,101
.kfn: db "os_environ", 0
section .text
os_env:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov rbx, rcx
    mov rcx, rbx
    sub rsp, 32
.kl319:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L960
    mov rax, 0
    jmp .__ret_959
    jmp .L961
.L960:
.L961:
    mov rax, [rel __g_tv_p]
    mov [rbp-16], rax
    mov rax, [rel __g_tv_n]
    mov r15, rax
    sub rsp, 32
.kl320:
    call os_linux
    add rsp, 32
    test rax, rax
    jz .L962
    sub rsp, 32
.kl321:
    call os_environ
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    jne .L964
    mov rax, 0
    jmp .__ret_959
    jmp .L965
.L964:
.L965:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl322:
    call ob_get
    add rsp, 32
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, [rbp-40]
    mov rax, [rax]
    mov [rbp-48], rax
    mov rax, [rbp-40]
    add rax, 8
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-72], rax
.L966:
    mov rax, r13
    mov rcx, [rbp-48]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L969
    mov rax, [rbp-72]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L969
    mov rax, 1
    jmp .L970
.L969:
    mov rax, 0
.L970:
    test rax, rax
    jz .L967
    mov rax, 0
    mov r12, rax
.L971:
    mov rax, r13
    add rax, r12
    mov rcx, [rbp-48]
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L974
    mov rax, r14
    add rax, r13
    add rax, r12
    movzx rax, byte [rax]
    mov rcx, 0
    cmp rax, rcx
    setne al
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
    add r12, 1
.L973:
    jmp .L971
.L972:
    cmp r12, r15
    jle .L976
    mov rax, 1
    mov [rbp-88], rax
    mov rax, 0
    mov rbx, rax
.L978:
    cmp rbx, r15
    jge .L979
    mov rax, r14
    add rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    push rax
    mov rax, [rbp-16]
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L981
    mov rax, 0
    mov [rbp-88], rax
    mov rax, r15
    mov rbx, rax
    jmp .L982
.L981:
.L982:
    add rbx, 1
.L980:
    jmp .L978
.L979:
    mov rax, r14
    add rax, r13
    add rax, r15
    movzx rax, byte [rax]
    cmp rax, 61
    je .L983
    mov rax, 0
    mov [rbp-88], rax
    jmp .L984
.L983:
.L984:
    mov rax, [rbp-88]
    test rax, rax
    jz .L985
    mov rax, r14
    add rax, r13
    add rax, r15
    add rax, 1
    push rax
    mov rax, r12
    sub rax, r15
    sub rax, 1
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl323:
    call tx_from_bytes
    add rsp, 32
    mov [rbp-72], rax
    jmp .L986
.L985:
.L986:
    jmp .L977
.L976:
.L977:
    mov rax, r13
    add rax, r12
    add rax, 1
    mov r13, rax
.L968:
    jmp .L966
.L967:
    mov rcx, [rbp-32]
    sub rsp, 32
.kl324:
    call ob_drop
    add rsp, 32
    mov rcx, [rbp-40]
    sub rsp, 32
.kl325:
    call hp_release
    add rsp, 32
    mov rax, [rbp-72]
    jmp .__ret_959
    jmp .L963
.L962:
.L963:
    sub rsp, 32
.kl326:
    call os_load
    add rsp, 32
    mov rcx, 256
    sub rsp, 32
.kl327:
    call tx_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    jne .L987
    mov rax, 0
    jmp .__ret_959
    jmp .L988
.L987:
.L988:
    mov rax, 0
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl328:
    call ob_get
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_os_getenvf]
    push rax
    mov rax, [rbp-16]
    push rax
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, 256
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
.kl329:
    call r11
    add rsp, 32
    pop rsp
    mov r12, rax
    mov rax, r12
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    cmp r12, 0
    jne .L989
    mov rcx, r13
    sub rsp, 32
.kl330:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl331:
    call hp_release
    add rsp, 32
    mov rax, 0
    jmp .__ret_959
    jmp .L990
.L989:
.L990:
    cmp r12, 256
    jle .L991
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl332:
    call tx_room
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jne .L993
    mov rax, 0
    jmp .__ret_959
    jmp .L994
.L993:
.L994:
    mov rax, [rel __g_os_getenvf]
    push rax
    mov rax, [rbp-16]
    push rax
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, r12
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
.kl333:
    call r11
    add rsp, 32
    pop rsp
    mov r12, rax
    mov rax, r12
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    jmp .L992
.L991:
.L992:
    mov rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    add rax, 8
    add rax, r12
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, r13
    jmp .__ret_959
.__ret_959:
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
.kft: dq os_environ.kft, .kfe, .kfn, __kron_file_3,15
    dq .kl319,107
    dq .kl320,112
    dq .kl321,113
    dq .kl322,117
    dq .kl323,146
    dq .kl324,151
    dq .kl325,152
    dq .kl326,155
    dq .kl327,156
    dq .kl328,161
    dq .kl329,162
    dq .kl330,165
    dq .kl331,166
    dq .kl332,170
    dq .kl333,174
.kfn: db "os_env", 0
section .text
os_envp:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov rbx, rcx
    mov rax, rbx
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl334:
    call ob_get
    add rsp, 32
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, r15
    mov rax, [rax]
    mov r14, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r13, rax
.L996:
    cmp r13, r14
    jge .L997
    mov rax, r15
    add rax, 8
    add rax, r13
    movzx rax, byte [rax]
    cmp rax, 0
    jne .L999
    add rbx, 1
    jmp .L1000
.L999:
.L1000:
    add r13, 1
.L998:
    jmp .L996
.L997:
    mov rax, rbx
    add rax, 1
    mov rcx, 8
    imul rax, rcx
    push rax
    pop rcx
    sub rsp, 32
.kl335:
    call hp_alloc
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1001
    mov rax, 0
    jmp .__ret_995
    jmp .L1002
.L1001:
.L1002:
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-64], rax
    mov rax, 0
    mov r13, rax
.L1003:
    cmp r13, r14
    jge .L1004
    mov rax, r15
    add rax, 8
    add rax, r13
    movzx rax, byte [rax]
    cmp rax, 0
    jne .L1006
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    mov rax, r15
    add rax, 8
    mov rcx, [rbp-64]
    add rax, rcx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    add rbx, 1
    mov rax, r13
    add rax, 1
    mov [rbp-64], rax
    jmp .L1007
.L1006:
.L1007:
    add r13, 1
.L1005:
    jmp .L1003
.L1004:
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r12
    jmp .__ret_995
.__ret_995:
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
.kft: dq os_env.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl334,188
    dq .kl335,201
.kfn: db "os_envp", 0
section .text
os_exec:
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
    sub rsp, 32
.kl336:
    call tv_view
    add rsp, 32
    cmp rax, 0
    jne .L1009
    mov rax, 1
    neg rax
    jmp .__ret_1008
    jmp .L1010
.L1009:
.L1010:
    sub rsp, 32
.kl337:
    call os_linux
    add rsp, 32
    test rax, rax
    jz .L1011
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl338:
    call os_exec_linux
    add rsp, 32
    jmp .__ret_1008
    jmp .L1012
.L1011:
.L1012:
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl339:
    call os_exec_windows
    add rsp, 32
    jmp .__ret_1008
.__ret_1008:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_envp.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl336,225
    dq .kl337,228
    dq .kl338,229
    dq .kl339,231
.kfn: db "os_exec", 0
section .text
os_exec_linux:
    push rbp
    mov rbp, rsp
    sub rsp, 4320
    mov [rbp-4096], rbp
    mov [rbp-4288], rbx
    mov [rbp-4280], r12
    mov [rbp-4272], r13
    mov [rbp-4264], r14
    mov [rbp-4256], r15
    mov rbx, rcx
    mov [rbp-16], rdx
    mov [rbp-24], r8
    mov rcx, rbx
    sub rsp, 32
.kl340:
    call tx_copy
    add rsp, 32
    mov [rbp-32], rax
    sub rsp, 32
.kl341:
    call os_environ
    add rsp, 32
    mov r15, rax
    mov rax, [rbp-32]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1016
    mov rax, r15
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1016
    mov rax, 0
    jmp .L1017
.L1016:
    mov rax, 1
.L1017:
    test rax, rax
    jz .L1014
    mov rax, 12
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_1013
    jmp .L1015
.L1014:
.L1015:
    mov rcx, r15
    sub rsp, 32
.kl342:
    call os_envp
    add rsp, 32
    mov [rbp-48], rax
    mov rcx, 32
    sub rsp, 32
.kl343:
    call hp_alloc
    add rsp, 32
    mov r14, rax
    mov rax, [rbp-48]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1020
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1020
    mov rax, 0
    jmp .L1021
.L1020:
    mov rax, 1
.L1021:
    test rax, rax
    jz .L1018
    mov rax, 1
    neg rax
    jmp .__ret_1013
    jmp .L1019
.L1018:
.L1019:
    mov rax, [rbp-32]
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl344:
    call ob_get
    add rsp, 32
    mov [rbp-64], rax
    mov rax, r14
    push rax
section .data
.str1022: db 115,104,0
section .text
    lea rax, [rel .str1022]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    push rax
section .data
.str1023: db 45,99,0
section .text
    lea rax, [rel .str1023]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 16
    push rax
    mov rax, [rbp-64]
    add rax, 8
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 24
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 1
    neg rax
    mov r13, rax
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rax, [rbp-16]
    test rax, rax
    jz .L1024
    mov rax, 0
    mov rbx, rax
    mov rax, 22
    push rax
    lea rax, [rbp-72]
    push rax
    pop rdi
    pop rax
.kl345:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jge .L1026
    mov rax, 12
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_1013
    jmp .L1027
.L1026:
.L1027:
    lea rax, [rbp-72]
    mov eax, dword [rax]
    mov r13, rax
    lea rax, [rbp-72]
    add rax, 4
    mov eax, dword [rax]
    mov rbx, rax
    jmp .L1025
.L1024:
.L1025:
    mov rax, 0
    mov r12, rax
    mov rax, 57
    push rax
    pop rax
.kl346:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov r12, rax
    cmp r12, 0
    jne .L1028
    mov rax, [rbp-16]
    test rax, rax
    jz .L1030
    mov rax, 33
    push rax
    mov rax, rbx
    push rax
    mov rax, 1
    push rax
    pop rsi
    pop rdi
    pop rax
.kl347:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    mov rax, 3
    push rax
    mov rax, r13
    push rax
    pop rdi
    pop rax
.kl348:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    mov rax, 3
    push rax
    mov rax, rbx
    push rax
    pop rdi
    pop rax
.kl349:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    jmp .L1031
.L1030:
.L1031:
    mov rax, 59
    push rax
section .data
.str1032: db 47,98,105,110,47,115,104,0
section .text
    lea rax, [rel .str1032]
    push rax
    mov rax, r14
    push rax
    mov rax, [rbp-48]
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl350:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    mov rax, 231
    push rax
    mov rax, 127
    push rax
    pop rdi
    pop rax
.kl351:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    jmp .L1029
.L1028:
.L1029:
    cmp r12, 0
    jge .L1033
    mov rax, 12
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_1013
    jmp .L1034
.L1033:
.L1034:
    mov rax, [rbp-16]
    test rax, rax
    jz .L1035
    mov rax, 3
    push rax
    mov rax, rbx
    push rax
    pop rdi
    pop rax
.kl352:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    mov rax, 1
    mov [rbp-4208], rax
.L1037:
    mov rax, [rbp-4208]
    test rax, rax
    jz .L1038
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    push rax
    mov rax, r13
    push rax
    lea rax, [rbp-4200]
    push rax
    mov rax, 4096
    push rax
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl353:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jg .L1040
    mov rax, 0
    mov [rbp-4208], rax
    jmp .L1041
.L1040:
    mov rax, [rbp-24]
    push rax
    lea rax, [rbp-4200]
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
.kl354:
    call tx_add_bytes
    add rsp, 32
.L1041:
.L1039:
    jmp .L1037
.L1038:
    mov rax, 3
    push rax
    mov rax, r13
    push rax
    pop rdi
    pop rax
.kl355:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    jmp .L1036
.L1035:
.L1036:
    mov rax, 61
    push rax
    mov rax, r12
    push rax
    lea rax, [rbp-4224]
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    pop r10
    pop rdx
    pop rsi
    pop rdi
    pop rax
.kl356:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    mov rax, 0
    mov rbx, rax
    lea rax, [rbp-4224]
    mov eax, dword [rax]
    sar rax, 8
    and rax, 255
    mov rbx, rax
    mov rcx, [rbp-32]
    sub rsp, 32
.kl357:
    call ob_drop
    add rsp, 32
    mov rcx, [rbp-64]
    sub rsp, 32
.kl358:
    call hp_release
    add rsp, 32
    mov rax, r15
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl359:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rcx, r15
    sub rsp, 32
.kl360:
    call ob_drop
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
.kl361:
    call hp_release
    add rsp, 32
    mov rcx, [rbp-48]
    sub rsp, 32
.kl362:
    call hp_release
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
.kl363:
    call hp_release
    add rsp, 32
    mov rax, rbx
    jmp .__ret_1013
.__ret_1013:
    mov rbx, [rbp-4288]
    mov r12, [rbp-4280]
    mov r13, [rbp-4272]
    mov r14, [rbp-4264]
    mov r15, [rbp-4256]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_exec.kft, .kfe, .kfn, __kron_file_3,24
    dq .kl340,235
    dq .kl341,236
    dq .kl342,241
    dq .kl343,242
    dq .kl344,246
    dq .kl345,258
    dq .kl346,269
    dq .kl347,274
    dq .kl348,275
    dq .kl349,276
    dq .kl350,278
    dq .kl351,279
    dq .kl352,287
    dq .kl353,292
    dq .kl354,296
    dq .kl355,299
    dq .kl356,302
    dq .kl357,305
    dq .kl358,306
    dq .kl359,307
    dq .kl360,308
    dq .kl361,309
    dq .kl362,310
    dq .kl363,311
.kfn: db "os_exec_linux", 0
section .text
os_exec_windows:
    push rbp
    mov rbp, rsp
    sub rsp, 4304
    mov [rbp-4096], rbp
    mov [rbp-4272], rbx
    mov [rbp-4264], r12
    mov [rbp-4256], r13
    mov [rbp-4248], r14
    mov [rbp-4240], r15
    mov rbx, rcx
    mov r15, rdx
    mov [rbp-24], r8
    sub rsp, 32
.kl364:
    call os_load
    add rsp, 32
    mov rcx, 64
    sub rsp, 32
.kl365:
    call tx_new
    add rsp, 32
    mov r14, rax
    cmp r14, 0
    jne .L1043
    mov rax, 1
    neg rax
    jmp .__ret_1042
    jmp .L1044
.L1043:
.L1044:
    mov rax, r14
    push rax
section .data
.str1045: db 99,109,100,46,101,120,101,32,47,99,32,0
section .text
    lea rax, [rel .str1045]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl366:
    call tx_add
    add rsp, 32
    mov rcx, r14
    mov rdx, rbx
    sub rsp, 32
.kl367:
    call tx_add
    add rsp, 32
    mov rax, r14
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl368:
    call ob_get
    add rsp, 32
    mov [rbp-40], rax
    lea rax, [rel __g_os_si]
    push rax
    pop rcx
    mov rdx, 104
    sub rsp, 32
.kl369:
    call hp_zero
    add rsp, 32
    lea rax, [rel __g_os_pi]
    push rax
    pop rcx
    mov rdx, 24
    sub rsp, 32
.kl370:
    call hp_zero
    add rsp, 32
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov [rbp-64], rax
    lea rax, [rel __g_os_si]
    push rax
    mov rax, 104
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r15
    test rax, rax
    jz .L1046
    lea rax, [rel __g_os_sa]
    push rax
    pop rcx
    mov rdx, 24
    sub rsp, 32
.kl371:
    call hp_zero
    add rsp, 32
    lea rax, [rel __g_os_sa]
    push rax
    mov rax, 24
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    lea rax, [rel __g_os_sa]
    add rax, 16
    push rax
    mov rax, 1
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, [rel __g_os_pipef]
    push rax
    lea rax, [rel __g_os_word]
    push rax
    lea rax, [rel __g_os_word]
    add rax, 8
    push rax
    lea rax, [rel __g_os_sa]
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
.kl372:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    cmp rax, 0
    je .L1048
    lea rax, [rel __g_os_word]
    mov rax, [rax]
    mov r13, rax
    lea rax, [rel __g_os_word]
    add rax, 8
    mov rax, [rax]
    mov r12, rax
    mov rax, [rel __g_os_infof]
    push rax
    mov rax, r13
    push rax
    mov rax, 1
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
.kl373:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    lea rax, [rel __g_os_si]
    add rax, 60
    push rax
    mov rax, 256
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    lea rax, [rel __g_os_si]
    add rax, 80
    push rax
    mov rax, [rel __g_os_stdf]
    push rax
    mov rax, 0
    sub rax, 10
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl374:
    call r11
    add rsp, 32
    pop rsp
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    lea rax, [rel __g_os_si]
    add rax, 88
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    lea rax, [rel __g_os_si]
    add rax, 96
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 1
    mov [rbp-64], rax
    jmp .L1049
.L1048:
.L1049:
    jmp .L1047
.L1046:
.L1047:
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_os_createf]
    push rax
    mov rax, 0
    push rax
    mov rax, [rbp-40]
    add rax, 8
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    mov rax, [rbp-64]
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    mov rax, 0
    push rax
    lea rax, [rel __g_os_si]
    push rax
    lea rax, [rel __g_os_pi]
    push rax
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 80
    mov r10, [rax+40]
    mov [rsp+32], r10
    mov r10, [rax+32]
    mov [rsp+40], r10
    mov r10, [rax+24]
    mov [rsp+48], r10
    mov r10, [rax+16]
    mov [rsp+56], r10
    mov r10, [rax+8]
    mov [rsp+64], r10
    mov r10, [rax+0]
    mov [rsp+72], r10
    mov rcx, [rax+72]
    mov rdx, [rax+64]
    mov r8, [rax+56]
    mov r9, [rax+48]
    mov r11, [rax+80]
.kl375:
    call r11
    add rsp, 80
    pop rsp
    add rsp, 88
    mov rbx, rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    mov rax, r15
    test rax, rax
    jz .L1050
    cmp r12, 0
    je .L1052
    mov rax, [rel __g_os_closef]
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
.kl376:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    jmp .L1053
.L1052:
.L1053:
    jmp .L1051
.L1050:
.L1051:
    mov rcx, r14
    sub rsp, 32
.kl377:
    call ob_drop
    add rsp, 32
    mov rcx, [rbp-40]
    sub rsp, 32
.kl378:
    call hp_release
    add rsp, 32
    cmp rbx, 0
    jne .L1054
    cmp r13, 0
    je .L1056
    mov rax, [rel __g_os_closef]
    push rax
    mov rax, r13
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl379:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    jmp .L1057
.L1056:
.L1057:
    mov rax, 12
    mov [rel __g_hp_err], rax
    mov rax, 1
    neg rax
    jmp .__ret_1042
    jmp .L1055
.L1054:
.L1055:
    mov rax, r15
    test rax, rax
    jz .L1058
    mov rax, 1
    mov r14, rax
.L1060:
    mov rax, r14
    test rax, rax
    jz .L1061
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r12, rax
    lea rax, [rel __g_os_word]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_os_readf]
    push rax
    mov rax, r13
    push rax
    lea rax, [rbp-4176]
    push rax
    mov rax, 4096
    push rax
    lea rax, [rel __g_os_word]
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
.kl380:
    call r11
    add rsp, 48
    pop rsp
    add rsp, 48
    mov rbx, rax
    lea rax, [rel __g_os_word]
    mov eax, dword [rax]
    mov r12, rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1065
    mov rax, r12
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L1065
    mov rax, 0
    jmp .L1066
.L1065:
    mov rax, 1
.L1066:
    test rax, rax
    jz .L1063
    mov rax, 0
    mov r14, rax
    jmp .L1064
.L1063:
    mov rax, [rbp-24]
    push rax
    lea rax, [rbp-4176]
    push rax
    pop rdx
    pop rcx
    mov r8, r12
    sub rsp, 32
.kl381:
    call tx_add_bytes
    add rsp, 32
.L1064:
.L1062:
    jmp .L1060
.L1061:
    mov rax, [rel __g_os_closef]
    push rax
    mov rax, r13
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl382:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    jmp .L1059
.L1058:
.L1059:
    mov rax, 0
    mov r12, rax
    lea rax, [rel __g_os_pi]
    mov rax, [rax]
    mov rbx, rax
    mov rax, [rel __g_os_waitf]
    push rax
    mov rax, rbx
    push rax
    mov rax, 4294967295
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl383:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    lea rax, [rel __g_os_word]
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, [rel __g_os_codef]
    push rax
    mov rax, rbx
    push rax
    lea rax, [rel __g_os_word]
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl384:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    lea rax, [rel __g_os_word]
    mov eax, dword [rax]
    mov r12, rax
    mov rax, [rel __g_os_closef]
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
.kl385:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    mov rax, [rel __g_os_closef]
    push rax
    lea rax, [rel __g_os_pi]
    add rax, 8
    mov rax, [rax]
    push rax
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl386:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
    mov rax, r12
    jmp .__ret_1042
.__ret_1042:
    mov rbx, [rbp-4272]
    mov r12, [rbp-4264]
    mov r13, [rbp-4256]
    mov r14, [rbp-4248]
    mov r15, [rbp-4240]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_exec_linux.kft, .kfe, .kfn, __kron_file_3,23
    dq .kl364,316
    dq .kl365,317
    dq .kl366,321
    dq .kl367,322
    dq .kl368,323
    dq .kl369,324
    dq .kl370,325
    dq .kl371,332
    dq .kl372,335
    dq .kl373,339
    dq .kl374,341
    dq .kl375,350
    dq .kl376,356
    dq .kl377,360
    dq .kl378,361
    dq .kl379,365
    dq .kl380,379
    dq .kl381,385
    dq .kl382,388
    dq .kl383,393
    dq .kl384,395
    dq .kl385,397
    dq .kl386,398
.kfn: db "os_exec_windows", 0
section .text
os_args:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
.kl387:
    call li_new
    add rsp, 32
    mov r13, rax
    sub rsp, 32
    call __arg_count
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L1068:
    mov rax, rbx
    mov rcx, r12
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L1073
    mov rax, r13
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L1073
    mov rax, 1
    jmp .L1074
.L1073:
    mov rax, 0
.L1074:
    test rax, rax
    jz .L1071
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
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
    mov rax, r13
    push rax
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __arg_get
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
.kl388:
    call tx_copy
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call li_add
    add rsp, 32
    add rbx, 1
.L1070:
    jmp .L1068
.L1069:
    mov rcx, r13
    sub rsp, 32
.kl389:
    call text_end
    add rsp, 32
    jmp .__ret_1067
.__ret_1067:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_exec_windows.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl387,407
    dq .kl388,411
    dq .kl389,414
.kfn: db "os_args", 0
section .text
os_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
.kl390:
    call os_linux
    add rsp, 32
    test rax, rax
    jz .L1076
    mov rax, 0
    mov rbx, rax
    mov rax, 1100
    push rax
    pop rax
.kl391:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 1
    jne .L1078
section .data
.str1080: db 109,97,99,111,115,0
section .text
    lea rax, [rel .str1080]
    push rax
    pop rcx
    sub rsp, 32
.kl392:
    call text
    add rsp, 32
    jmp .__ret_1075
    jmp .L1079
.L1078:
.L1079:
    cmp rbx, 2
    jne .L1081
section .data
.str1083: db 119,101,98,0
section .text
    lea rax, [rel .str1083]
    push rax
    pop rcx
    sub rsp, 32
.kl393:
    call text
    add rsp, 32
    jmp .__ret_1075
    jmp .L1082
.L1081:
.L1082:
section .data
.str1084: db 108,105,110,117,120,0
section .text
    lea rax, [rel .str1084]
    push rax
    pop rcx
    sub rsp, 32
.kl394:
    call text
    add rsp, 32
    jmp .__ret_1075
    jmp .L1077
.L1076:
.L1077:
section .data
.str1085: db 119,105,110,100,111,119,115,0
section .text
    lea rax, [rel .str1085]
    push rax
    pop rcx
    sub rsp, 32
.kl395:
    call text
    add rsp, 32
    jmp .__ret_1075
.__ret_1075:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_args.kft, .kfe, .kfn, __kron_file_3,6
    dq .kl390,421
    dq .kl391,423
    dq .kl392,425
    dq .kl393,428
    dq .kl394,430
    dq .kl395,432
.kfn: db "os_name", 0
section .text
env_get:
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
.kl396:
    call os_env
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1089
    mov rax, [rel __g_hp_err]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L1089
    mov rax, 1
    jmp .L1090
.L1089:
    mov rax, 0
.L1090:
    test rax, rax
    jz .L1087
    mov rax, 15
    mov [rel __g_hp_err], rax
    jmp .L1088
.L1087:
.L1088:
    mov rcx, rbx
    sub rsp, 32
.kl397:
    call text_end
    add rsp, 32
    jmp .__ret_1086
.__ret_1086:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_name.kft, .kfe, .kfn, __kron_file_3,2
    dq .kl396,437
    dq .kl397,441
.kfn: db "env_get", 0
section .text
env_has:
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
.kl398:
    call os_env
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    cmp r13, 0
    je .L1092
    mov rax, 1
    mov r12, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl399:
    call ob_get
    add rsp, 32
    mov rbx, rax
    mov rcx, r13
    sub rsp, 32
.kl400:
    call ob_drop
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
.kl401:
    call hp_release
    add rsp, 32
    jmp .L1093
.L1092:
.L1093:
    mov rcx, r12
    sub rsp, 32
.kl402:
    call text_end
    add rsp, 32
    jmp .__ret_1091
.__ret_1091:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq env_get.kft, .kfe, .kfn, __kron_file_3,5
    dq .kl398,446
    dq .kl399,450
    dq .kl400,451
    dq .kl401,452
    dq .kl402,454
.kfn: db "env_has", 0
section .text
os_run:
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
    mov r8, 0
    sub rsp, 32
.kl403:
    call os_exec
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_end
    add rsp, 32
    jmp .__ret_1094
.__ret_1094:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq env_has.kft, .kfe, .kfn, __kron_file_3,1
    dq .kl403,459
.kfn: db "os_run", 0
section .text
os_run_output:
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
    mov rcx, 256
    sub rsp, 32
.kl404:
    call tx_new
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    je .L1096
    mov rcx, r12
    mov rdx, 1
    mov r8, rbx
    sub rsp, 32
.kl405:
    call os_exec
    add rsp, 32
    jmp .L1097
.L1096:
.L1097:
    mov rcx, rbx
    sub rsp, 32
.kl406:
    call text_end
    add rsp, 32
    jmp .__ret_1095
.__ret_1095:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_run.kft, .kfe, .kfn, __kron_file_3,3
    dq .kl404,464
    dq .kl405,466
    dq .kl406,468
.kfn: db "os_run_output", 0
section .text
os_cwd:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, [rel __g_HP_LOCK]
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rcx, 1024
    sub rsp, 32
.kl407:
    call tx_new
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    je .L1099
    mov rax, r13
    push rax
    mov rax, [rel __g_OB_TEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl408:
    call ob_get
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
.kl409:
    call os_linux
    add rsp, 32
    test rax, rax
    jz .L1101
    mov rax, 79
    push rax
    mov rax, r12
    add rax, 8
    push rax
    mov rax, 1024
    push rax
    pop rsi
    pop rdi
    pop rax
.kl410:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov rbx, rax
    cmp rbx, 0
    jle .L1103
    sub rbx, 1
    jmp .L1104
.L1103:
    mov rax, 0
    mov rbx, rax
.L1104:
    jmp .L1102
.L1101:
    sub rsp, 32
.kl411:
    call os_load
    add rsp, 32
    mov rax, [rel __g_os_cwdf]
    push rax
    mov rax, 1024
    push rax
    mov rax, r12
    add rax, 8
    push rax
    pop rdx
    pop rcx
    pop r11
    mov rax, rsp
    and rsp, -16
    sub rsp, 8
    push rax
    sub rsp, 32
.kl412:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    cmp rbx, 1024
    jle .L1105
    mov rax, 0
    mov rbx, rax
    jmp .L1106
.L1105:
.L1106:
.L1102:
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
    jmp .L1100
.L1099:
.L1100:
    mov rcx, r13
    sub rsp, 32
.kl413:
    call text_end
    add rsp, 32
    jmp .__ret_1098
.__ret_1098:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_run_output.kft, .kfe, .kfn, __kron_file_3,7
    dq .kl407,473
    dq .kl408,475
    dq .kl409,478
    dq .kl410,479
    dq .kl411,486
    dq .kl412,487
    dq .kl413,497
.kfn: db "os_cwd", 0
section .text
os_chdir:
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
.kl414:
    call tv_view
    add rsp, 32
    test rax, rax
    jz .L1108
    sub rsp, 32
.kl415:
    call os_linux
    add rsp, 32
    test rax, rax
    jz .L1110
    mov rax, 80
    push rax
    mov rax, [rel __g_tv_p]
    push rax
    pop rdi
    pop rax
.kl416:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    cmp rax, 0
    jne .L1112
    mov rax, 1
    mov rbx, rax
    jmp .L1113
.L1112:
.L1113:
    jmp .L1111
.L1110:
    sub rsp, 32
.kl417:
    call os_load
    add rsp, 32
    mov rax, [rel __g_os_chdirf]
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
.kl418:
    call r11
    add rsp, 32
    pop rsp
    mov rbx, rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
.L1111:
    cmp rbx, 0
    jne .L1114
    mov rax, 11
    mov [rel __g_hp_err], rax
    jmp .L1115
.L1114:
.L1115:
    jmp .L1109
.L1108:
.L1109:
    mov rcx, rbx
    sub rsp, 32
.kl419:
    call text_end
    add rsp, 32
    jmp .__ret_1107
.__ret_1107:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_cwd.kft, .kfe, .kfn, __kron_file_3,6
    dq .kl414,503
    dq .kl415,505
    dq .kl416,506
    dq .kl417,510
    dq .kl418,511
    dq .kl419,519
.kfn: db "os_chdir", 0
section .text
os_exit:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    sub rsp, 32
.kl420:
    call os_linux
    add rsp, 32
    test rax, rax
    jz .L1117
    mov rax, 231
    push rax
    mov rax, rbx
    push rax
    pop rdi
    pop rax
.kl421:
    sub rsp, 32
    call __no_syscall
    add rsp, 32
    mov [rel __g_os_ignore], rax
    jmp .L1118
.L1117:
    sub rsp, 32
.kl422:
    call os_load
    add rsp, 32
    mov rax, [rel __g_os_exitf]
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
.kl423:
    call r11
    add rsp, 32
    pop rsp
    mov [rel __g_os_ignore], rax
.L1118:
    mov rax, 0
    jmp .__ret_1116
.__ret_1116:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq os_chdir.kft, .kfe, .kfn, __kron_file_3,4
    dq .kl420,524
    dq .kl421,525
    dq .kl422,527
    dq .kl423,528
.kfn: db "os_exit", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    sub rsp, 32
    call __rt_init
    add rsp, 32
section .data
.str1120: db 80,65,84,72,0
section .text
    lea rax, [rel .str1120]
    push rax
    pop rcx
    sub rsp, 32
.kl424:
    call env_has
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str1121: db 75,82,79,78,95,83,85,82,69,76,89,95,78,79,84,95,83,69,84,0
section .text
    lea rax, [rel .str1121]
    push rax
    pop rcx
    sub rsp, 32
.kl425:
    call env_has
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str1122: db 75,82,79,78,95,83,85,82,69,76,89,95,78,79,84,95,83,69,84,0
section .text
    lea rax, [rel .str1122]
    push rax
    pop rcx
    sub rsp, 32
.kl426:
    call env_get
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str1123: db 101,120,105,116,32,51,0
section .text
    lea rax, [rel .str1123]
    push rax
    pop rcx
    sub rsp, 32
.kl427:
    call os_run
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str1124: db 101,99,104,111,32,104,101,108,108,111,32,102,114,111,109,32,116,104,101,32,115,104,101,108,108,0
section .text
    lea rax, [rel .str1124]
    push rax
    pop rcx
    sub rsp, 32
.kl428:
    call os_run_output
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
.kl429:
    call text_trim
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call say
    add rsp, 32
    sub rsp, 32
.kl430:
    call os_args
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call list_len
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
.kl431:
    call os_cwd
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call text_len
    add rsp, 32
    mov rcx, 0
    cmp rax, rcx
    setg al
    movzx rax, al
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_1119
.__ret_1119:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq os_exit.kft, .kfe, .kfn, __kron_file_4,8
    dq .kl424,11
    dq .kl425,12
    dq .kl426,13
    dq .kl427,15
    dq .kl428,16
    dq .kl429,17
    dq .kl430,18
    dq .kl431,19
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,104,101,97,112,46,107,114,0
__kron_file_1: db 115,116,100,95,108,105,115,116,46,107,114,0
__kron_file_2: db 115,116,100,95,116,101,120,116,46,107,114,0
__kron_file_3: db 115,116,100,95,111,115,46,107,114,0
__kron_file_4: db 116,101,115,116,95,111,115,46,107,114,0
section .text
