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
__g_AR_MAX: dq 256
section .text
section .data
__g_AR_POOL: dq 8388608
section .text
section .bss
__g_ar_pool: resq 8388608
section .text
section .bss
__g_ar_base: resq 256
section .text
section .bss
__g_ar_cap: resq 256
section .text
section .bss
__g_ar_used: resq 256
section .text
section .bss
__g_ar_gen: resq 256
section .text
section .bss
__g_ar_live: resq 256
section .text
section .data
__g_ar_top: dq 0
section .text
arena_new:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    cmp r12, 0
    jg .L1
section .data
.str3: db 97,114,101,110,97,32,111,102,32,122,101,114,111,32,111,114,32,110,101,103,97,116,105,118,101,32,115,105,122,101,0
section .text
    lea rax, [rel .str3]
    push rax
section .data
.str4: db 97,115,107,32,102,111,114,32,97,116,32,108,101,97,115,116,32,111,110,101,32,119,111,114,100,0
section .text
    lea rax, [rel .str4]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl0:
    lea r8, [rel .kx0]
    call __fail_raise
.kx0:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
    jmp .L2
.L1:
.L2:
.L5:
    mov rax, rbx
    push rax
    mov rax, [rel __g_AR_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L6
    mov rax, rbx
    cmp rax, 256
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
    jmp .__ret_0
.L10:
    mov rcx, rax
    lea rdx, [rel __g_ar_live]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    jne .L8
    mov rax, [rel __g_ar_top]
    add rax, r12
    push rax
    mov rax, [rel __g_AR_POOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L11
section .data
.str13: db 110,111,32,114,111,111,109,32,108,101,102,116,32,102,111,114,32,116,104,101,32,97,114,101,110,97,0
section .text
    lea rax, [rel .str13]
    push rax
section .data
.str14: db 116,104,101,32,112,111,111,108,32,104,111,108,100,115,32,54,52,32,77,66,32,105,110,32,116,111,116,97,108,0
section .text
    lea rax, [rel .str14]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl2:
    lea r8, [rel .kx2]
    call __fail_raise
.kx2:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
    jmp .L12
.L11:
.L12:
    mov rax, rbx
    cmp rax, 256
    jb .L15
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl3:
    lea r8, [rel .kx3]
    call __fail_raise
.kx3:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L15:
    push rax
    mov rax, [rel __g_ar_top]
    pop rcx
    lea rdx, [rel __g_ar_base]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 256
    jb .L16
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl4:
    lea r8, [rel .kx4]
    call __fail_raise
.kx4:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L16:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rel __g_ar_cap]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 256
    jb .L17
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl5:
    lea r8, [rel .kx5]
    call __fail_raise
.kx5:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L17:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ar_used]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 256
    jb .L18
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl6:
    lea r8, [rel .kx6]
    call __fail_raise
.kx6:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L18:
    push rax
    mov rax, 1
    pop rcx
    lea rdx, [rel __g_ar_live]
    mov [rdx+rcx*8], rax
    mov rax, [rel __g_ar_top]
    add rax, r12
    mov [rel __g_ar_top], rax
    mov rax, rbx
    jmp .__ret_0
    jmp .L9
.L8:
.L9:
    add rbx, 1
.L7:
    jmp .L5
.L6:
section .data
.str19: db 110,111,32,102,114,101,101,32,97,114,101,110,97,115,32,108,101,102,116,0
section .text
    lea rax, [rel .str19]
    push rax
section .data
.str20: db 116,104,101,114,101,32,97,114,101,32,50,53,54,32,97,116,32,111,110,99,101,59,32,102,114,101,101,32,111,110,101,32,119,105,116,104,32,97,114,101,110,97,95,102,114,101,101,0
section .text
    lea rax, [rel .str20]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl7:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,8
    dq .kl0,50
    dq .kl1,53
    dq .kl2,55
    dq .kl3,57
    dq .kl4,58
    dq .kl5,59
    dq .kl6,60
    dq .kl7,66
.kfn: db "arena_new", 0
section .text
arena_free:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jge .L22
section .data
.str24: db 110,111,32,115,117,99,104,32,97,114,101,110,97,0
section .text
    lea rax, [rel .str24]
    push rax
section .data
.str25: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,97,114,101,110,97,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str25]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl8:
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_21
    jmp .L23
.L22:
.L23:
    mov rax, rbx
    push rax
    mov rax, [rel __g_AR_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L26
section .data
.str28: db 110,111,32,115,117,99,104,32,97,114,101,110,97,0
section .text
    lea rax, [rel .str28]
    push rax
section .data
.str29: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,97,114,101,110,97,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str29]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl9:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_21
    jmp .L27
.L26:
.L27:
    mov rax, rbx
    cmp rax, 256
    jb .L30
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl10:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_21
.L30:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ar_used]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 256
    jb .L31
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl11:
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_21
.L31:
    push rax
    mov rax, rbx
    cmp rax, 256
    jb .L32
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_21
.L32:
    mov rcx, rax
    lea rdx, [rel __g_ar_gen]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ar_gen]
    mov [rdx+rcx*8], rax
    mov rax, 0
    jmp .__ret_21
.__ret_21:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq arena_new.kft, .kfe, .kfn, __kron_file_0,4
    dq .kl8,73
    dq .kl9,76
    dq .kl10,78
    dq .kl11,79
.kfn: db "arena_free", 0
section .text
arena_room:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    cmp rax, 256
    jb .L34
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl12:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_33
.L34:
    mov rcx, rax
    lea rdx, [rel __g_ar_cap]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, rbx
    cmp rax, 256
    jb .L35
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_33
.L35:
    mov rcx, rax
    lea rdx, [rel __g_ar_used]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    sub rax, rcx
    jmp .__ret_33
.__ret_33:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq arena_free.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl12,85
.kfn: db "arena_room", 0
section .text
arena_slice:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    cmp r14, 0
    jge .L37
section .data
.str39: db 110,111,32,115,117,99,104,32,97,114,101,110,97,0
section .text
    lea rax, [rel .str39]
    push rax
section .data
.str40: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,97,114,101,110,97,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str40]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl13:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
    jmp .L38
.L37:
.L38:
    mov rax, r14
    push rax
    mov rax, [rel __g_AR_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L41
section .data
.str43: db 110,111,32,115,117,99,104,32,97,114,101,110,97,0
section .text
    lea rax, [rel .str43]
    push rax
section .data
.str44: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,97,114,101,110,97,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str44]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl14:
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
    jmp .L42
.L41:
.L42:
    cmp r13, 0
    jge .L45
section .data
.str47: db 115,108,105,99,101,32,111,102,32,110,101,103,97,116,105,118,101,32,115,105,122,101,0
section .text
    lea rax, [rel .str47]
    push rax
section .data
.str48: db 116,104,101,32,115,105,122,101,32,104,97,115,32,116,111,32,98,101,32,48,32,111,114,32,109,111,114,101,0
section .text
    lea rax, [rel .str48]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl15:
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
    jmp .L46
.L45:
.L46:
    mov rax, r14
    cmp rax, 256
    jb .L51
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl16:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L51:
    mov rcx, rax
    lea rdx, [rel __g_ar_used]
    mov rax, [rdx+rcx*8]
    add rax, r13
    add rax, 1
    push rax
    mov rax, r14
    cmp rax, 256
    jb .L52
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L52:
    mov rcx, rax
    lea rdx, [rel __g_ar_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L49
section .data
.str53: db 100,111,101,115,32,110,111,116,32,102,105,116,32,105,110,32,116,104,101,32,97,114,101,110,97,0
section .text
    lea rax, [rel .str53]
    push rax
section .data
.str54: db 109,97,107,101,32,116,104,101,32,97,114,101,110,97,32,98,105,103,103,101,114,32,111,114,32,102,114,101,101,32,115,108,105,99,101,115,32,119,105,116,104,32,97,114,101,110,97,95,102,114,101,101,0
section .text
    lea rax, [rel .str54]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl17:
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
    jmp .L50
.L49:
.L50:
    mov rax, r14
    cmp rax, 256
    jb .L55
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl18:
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L55:
    mov rcx, rax
    lea rdx, [rel __g_ar_base]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 256
    jb .L56
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L56:
    mov rcx, rax
    lea rdx, [rel __g_ar_used]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    mov rax, r12
    cmp rax, 8388608
    jb .L57
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl19:
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L57:
    push rax
    mov rax, r13
    pop rcx
    lea rdx, [rel __g_ar_pool]
    mov [rdx+rcx*8], rax
    mov rax, 0
    mov rbx, rax
.L58:
    cmp rbx, r13
    jge .L59
    mov rax, r12
    add rax, 1
    add rax, rbx
    cmp rax, 8388608
    jb .L61
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl20:
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L61:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ar_pool]
    mov [rdx+rcx*8], rax
    add rbx, 1
.L60:
    jmp .L58
.L59:
    mov rax, r14
    cmp rax, 256
    jb .L62
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl21:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L62:
    push rax
    mov rax, r14
    cmp rax, 256
    jb .L63
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L63:
    mov rcx, rax
    lea rdx, [rel __g_ar_used]
    mov rax, [rdx+rcx*8]
    add rax, r13
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ar_used]
    mov [rdx+rcx*8], rax
    mov rax, r14
    shl rax, 32
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    mov rax, r14
    cmp rax, 256
    jb .L64
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl22:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_36
.L64:
    mov rcx, rax
    lea rdx, [rel __g_ar_gen]
    mov rax, [rdx+rcx*8]
    shl rax, 40
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_36
.__ret_36:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq arena_room.kft, .kfe, .kfn, __kron_file_0,10
    dq .kl13,93
    dq .kl14,96
    dq .kl15,99
    dq .kl16,101
    dq .kl17,102
    dq .kl18,104
    dq .kl19,105
    dq .kl20,108
    dq .kl21,111
    dq .kl22,112
.kfn: db "arena_slice", 0
section .text
slice_len:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, r12
    sar rax, 32
    and rax, 255
    mov rbx, rax
    mov rax, r12
    sar rax, 40
    push rax
    mov rax, rbx
    cmp rax, 256
    jb .L68
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl23:
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_65
.L68:
    mov rcx, rax
    lea rdx, [rel __g_ar_gen]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L66
section .data
.str69: db 115,108,105,99,101,32,111,102,32,97,110,32,97,114,101,110,97,32,97,108,114,101,97,100,121,32,102,114,101,101,100,0
section .text
    lea rax, [rel .str69]
    push rax
section .data
.str70: db 100,111,32,110,111,116,32,117,115,101,32,97,32,115,108,105,99,101,32,97,102,116,101,114,32,97,114,101,110,97,95,102,114,101,101,0
section .text
    lea rax, [rel .str70]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl24:
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_65
    jmp .L67
.L66:
.L67:
    mov rax, r12
    mov rcx, 4294967295
    and rax, rcx
    cmp rax, 8388608
    jb .L71
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl25:
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_65
.L71:
    mov rcx, rax
    lea rdx, [rel __g_ar_pool]
    mov rax, [rdx+rcx*8]
    jmp .__ret_65
.__ret_65:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq arena_slice.kft, .kfe, .kfn, __kron_file_0,3
    dq .kl23,124
    dq .kl24,125
    dq .kl25,127
.kfn: db "slice_len", 0
section .text
slice_get:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, r13
    sar rax, 32
    and rax, 255
    mov rbx, rax
    mov rax, r13
    sar rax, 40
    push rax
    mov rax, rbx
    cmp rax, 256
    jb .L75
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl26:
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_72
.L75:
    mov rcx, rax
    lea rdx, [rel __g_ar_gen]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L73
section .data
.str76: db 115,108,105,99,101,32,111,102,32,97,110,32,97,114,101,110,97,32,97,108,114,101,97,100,121,32,102,114,101,101,100,0
section .text
    lea rax, [rel .str76]
    push rax
section .data
.str77: db 100,111,32,110,111,116,32,117,115,101,32,97,32,115,108,105,99,101,32,97,102,116,101,114,32,97,114,101,110,97,95,102,114,101,101,0
section .text
    lea rax, [rel .str77]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl27:
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_72
    jmp .L74
.L73:
.L74:
    mov rax, r13
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    cmp r12, 0
    jge .L78
section .data
.str80: db 105,110,100,101,120,32,111,117,116,115,105,100,101,32,116,104,101,32,115,108,105,99,101,0
section .text
    lea rax, [rel .str80]
    push rax
section .data
.str81: db 116,104,101,32,105,110,100,101,120,32,104,97,115,32,116,111,32,103,111,32,102,114,111,109,32,48,32,116,111,32,115,108,105,99,101,95,108,101,110,32,109,105,110,117,115,32,111,110,101,0
section .text
    lea rax, [rel .str81]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl28:
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_72
    jmp .L79
.L78:
.L79:
    mov rax, r12
    push rax
    mov rax, rbx
    cmp rax, 8388608
    jb .L84
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl29:
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_72
.L84:
    mov rcx, rax
    lea rdx, [rel __g_ar_pool]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L82
section .data
.str85: db 105,110,100,101,120,32,111,117,116,115,105,100,101,32,116,104,101,32,115,108,105,99,101,0
section .text
    lea rax, [rel .str85]
    push rax
section .data
.str86: db 116,104,101,32,105,110,100,101,120,32,104,97,115,32,116,111,32,103,111,32,102,114,111,109,32,48,32,116,111,32,115,108,105,99,101,95,108,101,110,32,109,105,110,117,115,32,111,110,101,0
section .text
    lea rax, [rel .str86]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl30:
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_72
    jmp .L83
.L82:
.L83:
    mov rax, rbx
    add rax, 1
    add rax, r12
    cmp rax, 8388608
    jb .L87
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl31:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_72
.L87:
    mov rcx, rax
    lea rdx, [rel __g_ar_pool]
    mov rax, [rdx+rcx*8]
    jmp .__ret_72
.__ret_72:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq slice_len.kft, .kfe, .kfn, __kron_file_0,6
    dq .kl26,133
    dq .kl27,134
    dq .kl28,138
    dq .kl29,140
    dq .kl30,141
    dq .kl31,143
.kfn: db "slice_get", 0
section .text
slice_get_real:
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
.kl32:
    call slice_get
    add rsp, 32
    mov rbx, rax
section .data
.flt89: dq 0.0
section .text
    movsd xmm0, [rel .flt89]
    movsd [rbp-32], xmm0
    lea rax, [rbp-32]
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    movsd xmm0, [rbp-32]
    jmp .__ret_88
.__ret_88:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq slice_get.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl32,148
.kfn: db "slice_get_real", 0
section .text
slice_set_real:
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
    movaps xmm0, xmm6
    movsd [rbp-40], xmm0
    lea rax, [rbp-40]
    mov rax, [rax]
    mov rbx, rax
    mov rcx, r13
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
.kl33:
    call slice_set
    add rsp, 32
    movaps xmm0, xmm6
    jmp .__ret_90
.__ret_90:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    movups xmm6, [rbp-72]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq slice_get_real.kft, .kfe, .kfn, __kron_file_0,1
    dq .kl33,162
.kfn: db "slice_set_real", 0
section .text
slice_set:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, r14
    sar rax, 32
    and rax, 255
    mov rbx, rax
    mov rax, r14
    sar rax, 40
    push rax
    mov rax, rbx
    cmp rax, 256
    jb .L94
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl34:
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_91
.L94:
    mov rcx, rax
    lea rdx, [rel __g_ar_gen]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L92
section .data
.str95: db 115,108,105,99,101,32,111,102,32,97,110,32,97,114,101,110,97,32,97,108,114,101,97,100,121,32,102,114,101,101,100,0
section .text
    lea rax, [rel .str95]
    push rax
section .data
.str96: db 100,111,32,110,111,116,32,117,115,101,32,97,32,115,108,105,99,101,32,97,102,116,101,114,32,97,114,101,110,97,95,102,114,101,101,0
section .text
    lea rax, [rel .str96]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl35:
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_91
    jmp .L93
.L92:
.L93:
    mov rax, r14
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    cmp r13, 0
    jge .L97
section .data
.str99: db 105,110,100,101,120,32,111,117,116,115,105,100,101,32,116,104,101,32,115,108,105,99,101,0
section .text
    lea rax, [rel .str99]
    push rax
section .data
.str100: db 116,104,101,32,105,110,100,101,120,32,104,97,115,32,116,111,32,103,111,32,102,114,111,109,32,48,32,116,111,32,115,108,105,99,101,95,108,101,110,32,109,105,110,117,115,32,111,110,101,0
section .text
    lea rax, [rel .str100]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl36:
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_91
    jmp .L98
.L97:
.L98:
    mov rax, r13
    push rax
    mov rax, rbx
    cmp rax, 8388608
    jb .L103
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl37:
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_91
.L103:
    mov rcx, rax
    lea rdx, [rel __g_ar_pool]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L101
section .data
.str104: db 105,110,100,101,120,32,111,117,116,115,105,100,101,32,116,104,101,32,115,108,105,99,101,0
section .text
    lea rax, [rel .str104]
    push rax
section .data
.str105: db 116,104,101,32,105,110,100,101,120,32,104,97,115,32,116,111,32,103,111,32,102,114,111,109,32,48,32,116,111,32,115,108,105,99,101,95,108,101,110,32,109,105,110,117,115,32,111,110,101,0
section .text
    lea rax, [rel .str105]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl38:
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_91
    jmp .L102
.L101:
.L102:
    mov rax, rbx
    add rax, 1
    add rax, r13
    cmp rax, 8388608
    jb .L106
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl39:
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_91
.L106:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rel __g_ar_pool]
    mov [rdx+rcx*8], rax
    mov rax, r12
    jmp .__ret_91
.__ret_91:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq slice_set_real.kft, .kfe, .kfn, __kron_file_0,6
    dq .kl34,169
    dq .kl35,170
    dq .kl36,174
    dq .kl37,176
    dq .kl38,177
    dq .kl39,179
.kfn: db "slice_set", 0
section .text
dot:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, [rbp-8]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    sub rsp, 16
    movups [rsp], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    movups xmm1, [rsp]
    add rsp, 16
    mulps xmm1, xmm0
    movaps xmm0, xmm1
    sub rsp, 16
    movups [rsp], xmm0
    mov rax, [rbp-8]
    push rax
    mov rax, 4
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    sub rsp, 16
    movups [rsp], xmm0
    mov rax, [rbp-16]
    push rax
    mov rax, 4
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    movups xmm1, [rsp]
    add rsp, 16
    mulps xmm1, xmm0
    movaps xmm0, xmm1
    movups xmm1, [rsp]
    add rsp, 16
    addps xmm1, xmm0
    movaps xmm0, xmm1
    sub rsp, 16
    movups [rsp], xmm0
    mov rax, rsp
    movss xmm0, [rax]
    cvtss2sd xmm0, xmm0
    add rax, 4
    movss xmm1, [rax]
    cvtss2sd xmm1, xmm1
    addsd xmm0, xmm1
    add rax, 4
    movss xmm1, [rax]
    cvtss2sd xmm1, xmm1
    addsd xmm0, xmm1
    add rax, 4
    movss xmm1, [rax]
    cvtss2sd xmm1, xmm1
    addsd xmm0, xmm1
    add rsp, 16
    jmp .__ret_107
.__ret_107:
    mov rsp, rbp
    pop rbp
    ret
main:
    push rbp
    mov rbp, rsp
    sub rsp, 304
    mov [rbp-272], rbx
    sub rsp, 32
    call __rt_init
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L109:
    cmp rbx, 8
    jge .L110
    mov rax, rbx
    cmp rax, 8
    jb .L112
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl40:
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L112:
    push rax
    mov rax, rbx
    cvtsi2sd xmm0, rax
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt113: dq 1.0
section .text
    movsd xmm0, [rel .flt113]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    pop rcx
    lea rdx, [rbp-32]
    cvtsd2ss xmm0, xmm0
    movss [rdx+rcx*4], xmm0
    mov rax, rbx
    cmp rax, 8
    jb .L114
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl41:
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L114:
    push rax
section .data
.flt115: dq 2.0
section .text
    movsd xmm0, [rel .flt115]
    pop rcx
    lea rdx, [rbp-64]
    cvtsd2ss xmm0, xmm0
    movss [rdx+rcx*4], xmm0
    add rbx, 1
.L111:
    jmp .L109
.L110:
    lea rax, [rbp-32]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    sub rsp, 16
    movups [rsp], xmm0
    lea rax, [rbp-64]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    movups xmm1, [rsp]
    add rsp, 16
    addps xmm1, xmm0
    movaps xmm0, xmm1
    sub rsp, 16
    movups [rsp], xmm0
    lea rax, [rbp-96]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm1, [rsp]
    add rsp, 16
    movups [rax], xmm1
    lea rax, [rbp-32]
    push rax
    mov rax, 4
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    sub rsp, 16
    movups [rsp], xmm0
section .data
.flt116: dq 4.0
section .text
    movsd xmm0, [rel .flt116]
    cvtsd2ss xmm0, xmm0
    sub rsp, 16
    mov rax, rsp
    movss [rax], xmm0
    add rax, 4
    movss [rax], xmm0
    add rax, 4
    movss [rax], xmm0
    add rax, 4
    movss [rax], xmm0
    movups xmm0, [rsp]
    add rsp, 16
    movups xmm1, [rsp]
    add rsp, 16
    divps xmm1, xmm0
    movaps xmm0, xmm1
    sub rsp, 16
    movups [rsp], xmm0
    lea rax, [rbp-96]
    push rax
    mov rax, 4
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm1, [rsp]
    add rsp, 16
    movups [rax], xmm1
    mov rax, 0
    cmp rax, 8
    jb .L117
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl42:
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L117:
    mov rcx, rax
    lea rdx, [rbp-96]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    call __print_float
    mov rax, 3
    cmp rax, 8
    jb .L118
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl43:
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L118:
    mov rcx, rax
    lea rdx, [rbp-96]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    call __print_float
    mov rax, 4
    cmp rax, 8
    jb .L119
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl44:
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L119:
    mov rcx, rax
    lea rdx, [rbp-96]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    call __print_float
    mov rax, 7
    cmp rax, 8
    jb .L120
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl45:
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L120:
    mov rcx, rax
    lea rdx, [rbp-96]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    call __print_float
    lea rax, [rbp-32]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    sub rsp, 16
    movups [rsp], xmm0
    mov rax, rsp
    movss xmm0, [rax]
    cvtss2sd xmm0, xmm0
    add rax, 4
    movss xmm1, [rax]
    cvtss2sd xmm1, xmm1
    addsd xmm0, xmm1
    add rax, 4
    movss xmm1, [rax]
    cvtss2sd xmm1, xmm1
    addsd xmm0, xmm1
    add rax, 4
    movss xmm1, [rax]
    cvtss2sd xmm1, xmm1
    addsd xmm0, xmm1
    add rsp, 16
    call __print_float
    lea rax, [rbp-32]
    push rax
    lea rax, [rbp-64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl46:
    call dot
    add rsp, 32
    call __print_float
section .data
.flt121: dq 1.5
section .text
    movsd xmm0, [rel .flt121]
    cvtsd2ss xmm0, xmm0
    sub rsp, 16
    mov rax, rsp
    movss [rax], xmm0
    add rax, 4
    movss [rax], xmm0
    add rax, 4
    movss [rax], xmm0
    add rax, 4
    movss [rax], xmm0
    movups xmm0, [rsp]
    add rsp, 16
    sub rsp, 16
    movups [rsp], xmm0
    lea rax, [rbp-64]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm0, [rax]
    movups xmm1, [rsp]
    add rsp, 16
    subps xmm1, xmm0
    movaps xmm0, xmm1
    sub rsp, 16
    movups [rsp], xmm0
    lea rax, [rbp-96]
    push rax
    mov rax, 0
    imul rax, rax, 4
    pop rcx
    add rax, rcx
    movups xmm1, [rsp]
    add rsp, 16
    movups [rax], xmm1
    mov rax, 2
    cmp rax, 8
    jb .L122
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl47:
    lea r8, [rel .kx49]
    call __fail_raise
.kx49:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L122:
    mov rcx, rax
    lea rdx, [rbp-96]
    movss xmm0, [rdx+rcx*4]
    cvtss2sd xmm0, xmm0
    call __print_float
    mov rax, 0
    cmp rax, 2
    jb .L123
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl48:
    lea r8, [rel .kx50]
    call __fail_raise
.kx50:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L123:
    push rax
section .data
.flt124: dq 9.0
section .text
    movsd xmm0, [rel .flt124]
    pop rcx
    lea rdx, [rbp-120]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 2
    jb .L125
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl49:
    lea r8, [rel .kx51]
    call __fail_raise
.kx51:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L125:
    push rax
section .data
.flt126: dq 1.0
section .text
    movsd xmm0, [rel .flt126]
    pop rcx
    lea rdx, [rbp-120]
    movsd [rdx+rcx*8], xmm0
    mov rax, 0
    cmp rax, 2
    jb .L127
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl50:
    lea r8, [rel .kx52]
    call __fail_raise
.kx52:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L127:
    push rax
section .data
.flt128: dq 3.0
section .text
    movsd xmm0, [rel .flt128]
    pop rcx
    lea rdx, [rbp-136]
    movsd [rdx+rcx*8], xmm0
    mov rax, 1
    cmp rax, 2
    jb .L129
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl51:
    lea r8, [rel .kx53]
    call __fail_raise
.kx53:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L129:
    push rax
section .data
.flt130: dq 4.0
section .text
    movsd xmm0, [rel .flt130]
    pop rcx
    lea rdx, [rbp-136]
    movsd [rdx+rcx*8], xmm0
    lea rax, [rbp-120]
    push rax
    mov rax, 0
    imul rax, rax, 8
    pop rcx
    add rax, rcx
    movupd xmm0, [rax]
    sub rsp, 16
    movups [rsp], xmm0
    lea rax, [rbp-136]
    push rax
    mov rax, 0
    imul rax, rax, 8
    pop rcx
    add rax, rcx
    movupd xmm0, [rax]
    movups xmm1, [rsp]
    add rsp, 16
    divpd xmm1, xmm0
    movaps xmm0, xmm1
    sub rsp, 16
    movupd [rsp], xmm0
    lea rax, [rbp-120]
    push rax
    mov rax, 0
    imul rax, rax, 8
    pop rcx
    add rax, rcx
    movupd xmm1, [rsp]
    add rsp, 16
    movupd [rax], xmm1
    mov rax, 0
    cmp rax, 2
    jb .L131
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl52:
    lea r8, [rel .kx54]
    call __fail_raise
.kx54:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L131:
    mov rcx, rax
    lea rdx, [rbp-120]
    movsd xmm0, [rdx+rcx*8]
    call __print_float
    mov rax, 1
    cmp rax, 2
    jb .L132
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl53:
    lea r8, [rel .kx55]
    call __fail_raise
.kx55:
    add rsp, 32
    xor rax, rax
    jmp .__ret_108
.L132:
    mov rcx, rax
    lea rdx, [rbp-120]
    movsd xmm0, [rdx+rcx*8]
    call __print_float
    mov rcx, 64
    sub rsp, 32
.kl54:
    call arena_new
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 4
    sub rsp, 32
.kl55:
    call arena_slice
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
section .data
.flt133: dq 1.5
section .text
    movsd xmm0, [rel .flt133]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl56:
    call slice_set_real
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, 3
    push rax
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
.kl57:
    call slice_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt134: dq 2.0
section .text
    movsd xmm0, [rel .flt134]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    mulsd xmm0, xmm1
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
    call slice_set_real
    add rsp, 32
    mov rcx, rbx
    mov rdx, 3
    sub rsp, 32
.kl58:
    call slice_get_real
    add rsp, 32
    call __print_float
    mov rcx, rbx
    mov rdx, 1
    sub rsp, 32
.kl59:
    call slice_get_real
    add rsp, 32
    sub rsp, 8
    movsd [rsp], xmm0
section .data
.flt135: dq 0.25
section .text
    movsd xmm0, [rel .flt135]
    movaps xmm1, xmm0
    movsd xmm0, [rsp]
    add rsp, 8
    addsd xmm0, xmm1
    call __print_float
    mov rax, rbx
    push rax
    mov rax, 9
    push rax
section .data
.flt136: dq 1.0
section .text
    movsd xmm0, [rel .flt136]
    sub rsp, 8
    movsd [rsp], xmm0
    movsd xmm2, [rsp]
    add rsp, 8
    pop rdx
    pop rcx
    sub rsp, 32
.kl60:
    call slice_set_real
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_108
.__ret_108:
    mov rbx, [rbp-272]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq slice_set.kft, .kfe, .kfn, __kron_file_1,21
    dq .kl40,29
    dq .kl41,30
    dq .kl42,35
    dq .kl43,36
    dq .kl44,37
    dq .kl45,38
    dq .kl46,40
    dq .kl47,42
    dq .kl48,46
    dq .kl49,47
    dq .kl50,48
    dq .kl51,49
    dq .kl52,51
    dq .kl53,52
    dq .kl54,54
    dq .kl55,55
    dq .kl56,56
    dq .kl57,57
    dq .kl58,58
    dq .kl59,59
    dq .kl60,60
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,97,114,101,110,97,46,107,114,0
__kron_file_1: db 116,101,115,116,95,115,105,109,100,52,46,107,114,0
section .text
