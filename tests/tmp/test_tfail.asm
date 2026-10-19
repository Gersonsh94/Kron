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
    jg .L1
section .data
.str3: db 99,104,97,110,110,101,108,32,111,102,32,122,101,114,111,32,111,114,32,110,101,103,97,116,105,118,101,32,99,97,112,97,99,105,116,121,0
section .text
    lea rax, [rel .str3]
    push rax
section .data
.str4: db 97,115,107,32,102,111,114,32,97,116,32,108,101,97,115,116,32,111,110,101,32,115,108,111,116,0
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
    mov rax, [rel __g_ch_ready]
    cmp rax, 0
    jne .L5
    mov rax, 8
    mov rbx, rax
.L7:
    cmp rbx, 16
    jge .L8
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __lock_init
    add rsp, 32
    add rbx, 1
.L9:
    jmp .L7
.L8:
    mov rax, 1
    mov [rel __g_ch_ready], rax
    jmp .L6
.L5:
.L6:
    mov rax, [rel __g_ch_used]
    push rax
    mov rax, [rel __g_CH_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L10
section .data
.str12: db 110,111,32,102,114,101,101,32,99,104,97,110,110,101,108,115,32,108,101,102,116,0
section .text
    lea rax, [rel .str12]
    push rax
section .data
.str13: db 116,104,101,114,101,32,97,114,101,32,54,52,32,97,116,32,111,110,99,101,0
section .text
    lea rax, [rel .str13]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl1:
    lea r8, [rel .kx1]
    call __fail_raise
.kx1:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
    jmp .L11
.L10:
.L11:
    mov rax, [rel __g_ch_top]
    add rax, r12
    push rax
    mov rax, [rel __g_CH_POOL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L14
section .data
.str16: db 110,111,32,114,111,111,109,32,108,101,102,116,32,102,111,114,32,116,104,101,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str16]
    push rax
section .data
.str17: db 116,104,101,32,112,111,111,108,32,104,111,108,100,115,32,111,110,101,32,109,105,108,108,105,111,110,32,115,108,111,116,115,32,105,110,32,116,111,116,97,108,0
section .text
    lea rax, [rel .str17]
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
    jmp .L15
.L14:
.L15:
    mov rax, [rel __g_ch_used]
    mov rbx, rax
    mov rax, rbx
    cmp rax, 64
    jb .L18
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
.L18:
    push rax
    mov rax, [rel __g_ch_top]
    pop rcx
    lea rdx, [rel __g_ch_base]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L19
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
.L19:
    push rax
    mov rax, r12
    pop rcx
    lea rdx, [rel __g_ch_cap]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L20
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
.L20:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_head]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L21
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
.L21:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_tail]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L22
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl7:
    lea r8, [rel .kx7]
    call __fail_raise
.kx7:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L22:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_count]
    mov [rdx+rcx*8], rax
    mov rax, rbx
    cmp rax, 64
    jb .L23
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl8:
    lea r8, [rel .kx8]
    call __fail_raise
.kx8:
    add rsp, 32
    xor rax, rax
    jmp .__ret_0
.L23:
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
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq 0, .kfe, .kfn, __kron_file_0,9
    dq .kl0,63
    dq .kl1,74
    dq .kl2,77
    dq .kl3,80
    dq .kl4,81
    dq .kl5,82
    dq .kl6,83
    dq .kl7,84
    dq .kl8,85
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
    jge .L25
section .data
.str27: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str27]
    push rax
section .data
.str28: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str28]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl9:
    lea r8, [rel .kx9]
    call __fail_raise
.kx9:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
    jmp .L26
.L25:
.L26:
    mov rax, r14
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L29
section .data
.str31: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str31]
    push rax
section .data
.str32: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str32]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl10:
    lea r8, [rel .kx10]
    call __fail_raise
.kx10:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
    jmp .L30
.L29:
.L30:
.L33:
    cmp rbx, 0
    jne .L34
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r14
    cmp rax, 64
    jb .L38
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl11:
    lea r8, [rel .kx11]
    call __fail_raise
.kx11:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L38:
    mov rcx, rax
    lea rdx, [rel __g_ch_closed]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    je .L36
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
section .data
.str39: db 115,101,110,100,32,111,110,32,97,32,99,108,111,115,101,100,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str39]
    push rax
section .data
.str40: db 99,108,111,115,101,32,97,32,99,104,97,110,110,101,108,32,111,110,108,121,32,119,104,101,110,32,101,118,101,114,121,32,115,101,110,100,101,114,32,105,115,32,100,111,110,101,0
section .text
    lea rax, [rel .str40]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl12:
    lea r8, [rel .kx12]
    call __fail_raise
.kx12:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
    jmp .L37
.L36:
.L37:
    mov rax, r14
    cmp rax, 64
    jb .L43
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl13:
    lea r8, [rel .kx13]
    call __fail_raise
.kx13:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L43:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L44
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx14]
    call __fail_raise
.kx14:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L44:
    mov rcx, rax
    lea rdx, [rel __g_ch_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L41
    mov rax, r14
    cmp rax, 64
    jb .L45
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl14:
    lea r8, [rel .kx15]
    call __fail_raise
.kx15:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L45:
    mov rcx, rax
    lea rdx, [rel __g_ch_base]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L46
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx16]
    call __fail_raise
.kx16:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L46:
    mov rcx, rax
    lea rdx, [rel __g_ch_tail]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    cmp rax, 1048576
    jb .L47
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx17]
    call __fail_raise
.kx17:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L47:
    push rax
    mov rax, r13
    pop rcx
    lea rdx, [rel __g_ch_pool]
    mov [rdx+rcx*8], rax
    mov rax, r14
    cmp rax, 64
    jb .L48
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl15:
    lea r8, [rel .kx18]
    call __fail_raise
.kx18:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L48:
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L49
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx19]
    call __fail_raise
.kx19:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L49:
    mov rcx, rax
    lea rdx, [rel __g_ch_tail]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ch_tail]
    mov [rdx+rcx*8], rax
    mov rax, r14
    cmp rax, 64
    jb .L52
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl16:
    lea r8, [rel .kx20]
    call __fail_raise
.kx20:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L52:
    mov rcx, rax
    lea rdx, [rel __g_ch_tail]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L53
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx21]
    call __fail_raise
.kx21:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L53:
    mov rcx, rax
    lea rdx, [rel __g_ch_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L50
    mov rax, r14
    cmp rax, 64
    jb .L54
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl17:
    lea r8, [rel .kx22]
    call __fail_raise
.kx22:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L54:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_tail]
    mov [rdx+rcx*8], rax
    jmp .L51
.L50:
.L51:
    mov rax, r14
    cmp rax, 64
    jb .L55
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl18:
    lea r8, [rel .kx23]
    call __fail_raise
.kx23:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L55:
    push rax
    mov rax, r14
    cmp rax, 64
    jb .L56
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx24]
    call __fail_raise
.kx24:
    add rsp, 32
    xor rax, rax
    jmp .__ret_24
.L56:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ch_count]
    mov [rdx+rcx*8], rax
    mov rax, 1
    mov rbx, rax
    jmp .L42
.L41:
.L42:
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 0
    jne .L57
    sub rsp, 32
    call __thread_yield
    add rsp, 32
    jmp .L58
.L57:
.L58:
.L35:
    jmp .L33
.L34:
    mov rax, 1
    jmp .__ret_24
.__ret_24:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_new.kft, .kfe, .kfn, __kron_file_0,10
    dq .kl9,96
    dq .kl10,99
    dq .kl11,103
    dq .kl12,105
    dq .kl13,107
    dq .kl14,108
    dq .kl15,109
    dq .kl16,110
    dq .kl17,111
    dq .kl18,113
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
    jge .L60
section .data
.str62: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str62]
    push rax
section .data
.str63: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str63]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl19:
    lea r8, [rel .kx25]
    call __fail_raise
.kx25:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
    jmp .L61
.L60:
.L61:
    mov rax, r13
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L64
section .data
.str66: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str66]
    push rax
section .data
.str67: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str67]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl20:
    lea r8, [rel .kx26]
    call __fail_raise
.kx26:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
    jmp .L65
.L64:
.L65:
.L68:
    cmp rbx, 2
    jne .L69
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r13
    cmp rax, 64
    jb .L73
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl21:
    lea r8, [rel .kx27]
    call __fail_raise
.kx27:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L73:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    jle .L71
    mov rax, 0
    cmp rax, 1
    jb .L74
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl22:
    lea r8, [rel .kx28]
    call __fail_raise
.kx28:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L74:
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L75
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx29]
    call __fail_raise
.kx29:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L75:
    mov rcx, rax
    lea rdx, [rel __g_ch_base]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L76
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx30]
    call __fail_raise
.kx30:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L76:
    mov rcx, rax
    lea rdx, [rel __g_ch_head]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    cmp rax, 1048576
    jb .L77
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx31]
    call __fail_raise
.kx31:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L77:
    mov rcx, rax
    lea rdx, [rel __g_ch_pool]
    mov rax, [rdx+rcx*8]
    pop rcx
    mov rdx, [rbp-16]
    mov [rdx+rcx*8], rax
    mov rax, r13
    cmp rax, 64
    jb .L78
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl23:
    lea r8, [rel .kx32]
    call __fail_raise
.kx32:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L78:
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L79
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx33]
    call __fail_raise
.kx33:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L79:
    mov rcx, rax
    lea rdx, [rel __g_ch_head]
    mov rax, [rdx+rcx*8]
    add rax, 1
    pop rcx
    lea rdx, [rel __g_ch_head]
    mov [rdx+rcx*8], rax
    mov rax, r13
    cmp rax, 64
    jb .L82
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl24:
    lea r8, [rel .kx34]
    call __fail_raise
.kx34:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L82:
    mov rcx, rax
    lea rdx, [rel __g_ch_head]
    mov rax, [rdx+rcx*8]
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L83
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx35]
    call __fail_raise
.kx35:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L83:
    mov rcx, rax
    lea rdx, [rel __g_ch_cap]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L80
    mov rax, r13
    cmp rax, 64
    jb .L84
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl25:
    lea r8, [rel .kx36]
    call __fail_raise
.kx36:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L84:
    push rax
    mov rax, 0
    pop rcx
    lea rdx, [rel __g_ch_head]
    mov [rdx+rcx*8], rax
    jmp .L81
.L80:
.L81:
    mov rax, r13
    cmp rax, 64
    jb .L85
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl26:
    lea r8, [rel .kx37]
    call __fail_raise
.kx37:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L85:
    push rax
    mov rax, r13
    cmp rax, 64
    jb .L86
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
    lea r8, [rel .kx38]
    call __fail_raise
.kx38:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L86:
    mov rcx, rax
    lea rdx, [rel __g_ch_count]
    mov rax, [rdx+rcx*8]
    sub rax, 1
    pop rcx
    lea rdx, [rel __g_ch_count]
    mov [rdx+rcx*8], rax
    mov rax, 1
    mov rbx, rax
    jmp .L72
.L71:
    mov rax, r13
    cmp rax, 64
    jb .L89
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl27:
    lea r8, [rel .kx39]
    call __fail_raise
.kx39:
    add rsp, 32
    xor rax, rax
    jmp .__ret_59
.L89:
    mov rcx, rax
    lea rdx, [rel __g_ch_closed]
    mov rax, [rdx+rcx*8]
    cmp rax, 0
    je .L87
    mov rax, 0
    mov rbx, rax
    jmp .L88
.L87:
.L88:
.L72:
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_give
    add rsp, 32
    cmp rbx, 2
    jne .L90
    sub rsp, 32
    call __thread_yield
    add rsp, 32
    jmp .L91
.L90:
.L91:
.L70:
    jmp .L68
.L69:
    mov rax, rbx
    jmp .__ret_59
.__ret_59:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_send.kft, .kfe, .kfn, __kron_file_0,9
    dq .kl19,130
    dq .kl20,133
    dq .kl21,137
    dq .kl22,138
    dq .kl23,139
    dq .kl24,140
    dq .kl25,141
    dq .kl26,143
    dq .kl27,146
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
    jge .L93
section .data
.str95: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str95]
    push rax
section .data
.str96: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str96]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl28:
    lea r8, [rel .kx40]
    call __fail_raise
.kx40:
    add rsp, 32
    xor rax, rax
    jmp .__ret_92
    jmp .L94
.L93:
.L94:
    mov rax, r12
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L97
section .data
.str99: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str99]
    push rax
section .data
.str100: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str100]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl29:
    lea r8, [rel .kx41]
    call __fail_raise
.kx41:
    add rsp, 32
    xor rax, rax
    jmp .__ret_92
    jmp .L98
.L97:
.L98:
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r12
    cmp rax, 64
    jb .L101
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl30:
    lea r8, [rel .kx42]
    call __fail_raise
.kx42:
    add rsp, 32
    xor rax, rax
    jmp .__ret_92
.L101:
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
    jmp .__ret_92
.__ret_92:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_recv.kft, .kfe, .kfn, __kron_file_0,3
    dq .kl28,162
    dq .kl29,165
    dq .kl30,168
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
    jge .L103
section .data
.str105: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str105]
    push rax
section .data
.str106: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str106]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl31:
    lea r8, [rel .kx43]
    call __fail_raise
.kx43:
    add rsp, 32
    xor rax, rax
    jmp .__ret_102
    jmp .L104
.L103:
.L104:
    mov rax, r13
    push rax
    mov rax, [rel __g_ch_used]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L107
section .data
.str109: db 110,111,32,115,117,99,104,32,99,104,97,110,110,101,108,0
section .text
    lea rax, [rel .str109]
    push rax
section .data
.str110: db 117,115,101,32,116,104,101,32,110,117,109,98,101,114,32,99,104,97,110,95,110,101,119,32,114,101,116,117,114,110,101,100,0
section .text
    lea rax, [rel .str110]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl32:
    lea r8, [rel .kx44]
    call __fail_raise
.kx44:
    add rsp, 32
    xor rax, rax
    jmp .__ret_102
    jmp .L108
.L107:
.L108:
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __lock_take
    add rsp, 32
    mov rax, r13
    cmp rax, 64
    jb .L111
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl33:
    lea r8, [rel .kx45]
    call __fail_raise
.kx45:
    add rsp, 32
    xor rax, rax
    jmp .__ret_102
.L111:
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
    jmp .__ret_102
.__ret_102:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_close.kft, .kfe, .kfn, __kron_file_0,3
    dq .kl31,178
    dq .kl32,181
    dq .kl33,184
.kfn: db "chan_len", 0
section .text
always_fails:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jl .L113
section .data
.str115: db 111,110,32,112,117,114,112,111,115,101,0
section .text
    lea rax, [rel .str115]
    push rax
section .data
.str116: db 116,104,105,115,32,102,97,105,108,117,114,101,32,98,101,108,111,110,103,115,32,116,111,32,116,104,101,32,116,104,114,101,97,100,32,116,104,97,116,32,114,97,105,115,101,100,32,105,116,0
section .text
    lea rax, [rel .str116]
    mov rdx, rax
    pop rcx
    sub rsp, 32
.kl34:
    lea r8, [rel .kx46]
    call __fail_raise
.kx46:
    add rsp, 32
    xor rax, rax
    jmp .__ret_112
    jmp .L114
.L113:
.L114:
    mov rax, 1
    jmp .__ret_112
.__ret_112:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq chan_len.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl34,29
.kfn: db "always_fails", 0
section .text
never_fails:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 1
    jmp .__ret_117
.__ret_117:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
failer:
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
.L119:
    cmp rbx, 200000
    jge .L120
    mov rcx, rbx
    sub rsp, 32
.kl35:
    call always_fails
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    cmp rax, 0
    jne .L122
    add r12, 1
    jmp .L123
.L122:
.L123:
    add rbx, 1
.L121:
    jmp .L119
.L120:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl36:
    call chan_send
    add rsp, 32
    mov rax, 0
    jmp .__ret_118
.__ret_118:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq always_fails.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl35,42
    dq .kl36,48
.kfn: db "failer", 0
section .text
clean:
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
.L125:
    cmp rbx, 200000
    jge .L126
    mov rcx, rbx
    sub rsp, 32
.kl37:
    call never_fails
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    cmp rax, 0
    je .L128
    add r12, 1
    jmp .L129
.L128:
.L129:
    add rbx, 1
.L127:
    jmp .L125
.L126:
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
.kl38:
    call chan_send
    add rsp, 32
    mov rax, 0
    jmp .__ret_124
.__ret_124:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq failer.kft, .kfe, .kfn, __kron_file_1,2
    dq .kl37,56
    dq .kl38,62
.kfn: db "clean", 0
section .text
look_once:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    push rax
    sub rsp, 32
    call __fail_take
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl39:
    call chan_send
    add rsp, 32
    mov rax, 0
    jmp .__ret_130
.__ret_130:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
.kfe:
section .data
.kft: dq clean.kft, .kfe, .kfn, __kron_file_1,1
    dq .kl39,67
.kfn: db "look_once", 0
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    sub rsp, 32
    call __rt_init
    add rsp, 32
    mov rcx, 8
    sub rsp, 32
.kl40:
    call chan_new
    add rsp, 32
    mov r15, rax
    lea rax, [rel failer]
    push rax
    mov rax, r15
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov [rbp-24], rax
    lea rax, [rel clean]
    push rax
    mov rax, r15
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov [rbp-32], rax
    lea rax, [rel failer]
    push rax
    mov rax, r15
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov r14, rax
    lea rax, [rel clean]
    push rax
    mov rax, r15
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L132:
    cmp rbx, 4
    jge .L133
    mov rax, r15
    push rax
    lea rax, [rbp-8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl41:
    call chan_recv
    add rsp, 32
    mov rax, r12
    push rax
    mov rax, 0
    cmp rax, 1
    jb .L135
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl42:
    lea r8, [rel .kx47]
    call __fail_raise
.kx47:
    add rsp, 32
    xor rax, rax
    jmp .__ret_131
.L135:
    mov rcx, rax
    lea rdx, [rbp-8]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    add rbx, 1
.L134:
    jmp .L132
.L133:
    mov rax, [rbp-24]
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, [rbp-32]
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, r14
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, r13
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, r12
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
.kl43:
    call always_fails
    add rsp, 32
    lea rax, [rel look_once]
    push rax
    mov rax, r15
    mov rdx, rax
    pop rcx
    sub rsp, 32
    call __thread_start
    add rsp, 32
    mov rbx, rax
    mov rax, r15
    push rax
    lea rax, [rbp-8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
.kl44:
    call chan_recv
    add rsp, 32
    mov rax, rbx
    mov rcx, rax
    sub rsp, 32
    call __thread_wait
    add rsp, 32
    mov rax, 0
    cmp rax, 1
    jb .L136
    lea rcx, [rel __bounds_msg]
    lea rdx, [rel __bounds_hint]
    sub rsp, 32
.kl45:
    lea r8, [rel .kx48]
    call __fail_raise
.kx48:
    add rsp, 32
    xor rax, rax
    jmp .__ret_131
.L136:
    mov rcx, rax
    lea rdx, [rbp-8]
    mov rax, [rdx+rcx*8]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call __fail_take
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    sub rsp, 32
    call __thread_yield
    add rsp, 32
    mov rax, 9
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_131
.__ret_131:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call __main_exit
.kfe:
section .data
.kft: dq look_once.kft, .kfe, .kfn, __kron_file_1,6
    dq .kl40,73
    dq .kl41,81
    dq .kl42,82
    dq .kl43,91
    dq .kl44,93
    dq .kl45,95
.kfn: db "main", 0
section .text
section .text
__kron_hi:
section .data
__kron_trace: dq main.kft
__kron_file_0: db 115,116,100,95,99,104,97,110,46,107,114,0
__kron_file_1: db 116,101,115,116,95,116,102,97,105,108,46,107,114,0
section .text
