global dbg_which
extern print_string
; ==============================================================================
; KRON COMPILER - CODE GENERATOR (emits real x86-64 assembly, NASM/win64)
; Walks the AST and produces .asm text that NASM+GoLink, or kasm, turn into a native .exe.
; Imperative core: fn, var/const, arithmetic, comparison, if/while/loop,
; return, print, assignment, calls.
; Internal ABI: rdi = AST node. Does not call Windows.
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"

section .data
; ---- Preamble of the emitted program ----
hdr:
db "default rel", 10
db "bits 64", 10
db "global main", 10
db "extern ExitProcess", 10
db "extern GetStdHandle", 10
db "extern WriteFile", 10
db "extern CreateFileA", 10
db "extern CloseHandle", 10
db "extern ReadFile", 10
db "extern Beep", 10
db "extern SetConsoleMode", 10
db "extern ReadConsoleInputA", 10
db "extern CreateThread", 10
db "extern WaitForSingleObject", 10
db "extern InitializeCriticalSection", 10
db "extern EnterCriticalSection", 10
db "extern LeaveCriticalSection", 10
db "extern GetSystemInfo", 10
db "extern TlsAlloc", 10
db "extern TlsGetValue", 10
db "extern TlsSetValue", 10
db "extern SwitchToThread", 10
db "extern LoadLibraryA", 10
db "extern GetProcAddress", 10
db "extern QueryPerformanceCounter", 10
db "extern QueryPerformanceFrequency", 10
db "extern GetCommandLineA", 10
db "extern VirtualAlloc", 10
db "section .bss", 10
db "__clo_lock: resq 1", 10
db "__clo_cur: resq 1", 10
db "__clo_end: resq 1", 10
db "__numbuf: resb 32", 10
db "__nwritten: resq 1", 10
db "__chbuf: resb 2", 10
db "__keybuf: resb 2", 10
db "__nread: resq 1", 10
db "__mousebuf: resb 32", 10
db "__mousex_v: resq 1", 10
db "__mousey_v: resq 1", 10
; failure state. Only the hosted preamble carries it: the bare-metal ones
; have no console for print_fail to write to.
; The failure state is per thread: flag, cause, hint and the trace live in
; a block of 96 bytes that the thread gets the first time it fails (layout at
; __fail_walk). Its address is kept in a TLS slot, so a thread that never
; failed costs nothing.
db "__fail_tls: resq 1", 10
db "__fail_next: resq 1", 10
db "__fail_cs: resb 64", 10
db "__fail_pool: resq 3072", 10
; --- threads --------------------------------------------------------------
; Sixteen locks, numbered. A CRITICAL_SECTION is 40 bytes on x64; 64 is
; reserved for each so the next one starts on a cache line and two threads
; taking different locks do not fight over the same line.
db "__locks: resb 2048", 10
db "__sysinfo: resb 64", 10
db "__tickbuf: resq 1", 10
db "__argdone: resq 1", 10
db "__argn: resq 1", 10
db "__argtab: resq 64", 10
db "__argbuf: resb 32800", 10
db "section .text", 10
db "__outname: db 'out.bmp', 0", 10
; __load_file(rcx = name, rdx = buffer, r8 = capacity) -> rax = bytes read,
; or 0 when the file cannot be opened. The mirror of __save_file: GENERIC_READ
; and OPEN_EXISTING instead of GENERIC_WRITE and CREATE_ALWAYS, and ReadFile
; instead of WriteFile.
; ==========================================================================
; Threads.
;
; __thread_start(rcx = function address, rdx = argument) -> handle, or 0.
; The function receives the argument in rcx, which is what CreateThread
; passes to the thread routine. Its return value is discarded: a thread has
; nobody to return to.
; ==========================================================================
db "__thread_start:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 64", 10
db "    mov r9, rdx", 10               ; lpParameter
db "    mov r8, rcx", 10               ; lpStartAddress
db "    xor rcx, rcx", 10              ; lpThreadAttributes = NULL
db "    xor rdx, rdx", 10              ; dwStackSize = 0 (default)
db "    mov qword [rsp+32], 0", 10     ; dwCreationFlags = 0 (run at once)
db "    mov qword [rsp+40], 0", 10     ; lpThreadId = NULL
db "    call CreateThread", 10
db "    add rsp, 64", 10
db "    pop rbp", 10
db "    ret", 10

; __thread_wait(rcx = handle). Blocks until the thread ends. INFINITE is
; 0xFFFFFFFF.
db "__thread_wait:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    mov rdx, 0xFFFFFFFF", 10
db "    call WaitForSingleObject", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

; __lock_addr(rcx = lock number) -> its address. Out of range folds to zero
; rather than writing somewhere else: a wrong lock number is a bug, and
; silently sharing lock 0 is easier to notice than corrupting memory.
db "__lock_addr:", 10
db "    cmp rcx, 32", 10
db "    jb .la_ok", 10
db "    xor rcx, rcx", 10
db ".la_ok:", 10
db "    imul rcx, rcx, 64", 10
db "    lea rax, [rel __locks]", 10
db "    add rax, rcx", 10
db "    ret", 10

db "__lock_init:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    call __lock_addr", 10
db "    mov rcx, rax", 10
db "    call InitializeCriticalSection", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

db "__lock_take:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    call __lock_addr", 10
db "    mov rcx, rax", 10
db "    call EnterCriticalSection", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

db "__lock_give:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    call __lock_addr", 10
db "    mov rcx, rax", 10
db "    call LeaveCriticalSection", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

; __cpu_count() -> number of processors. SYSTEM_INFO keeps it at offset 32.
; __ticks() -> the high-resolution counter. QueryPerformanceCounter writes
; through a pointer rather than returning a value, so it needs somewhere to
; write; __tickbuf is that somewhere.
db "__ticks:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    lea rcx, [rel __tickbuf]", 10
db "    call QueryPerformanceCounter", 10
db "    mov rax, [rel __tickbuf]", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

; __ticks_per_sec() -> how many of those counts make a second. Fixed at boot,
; so one call is enough for a whole program.
db "__ticks_per_sec:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    lea rcx, [rel __tickbuf]", 10
db "    call QueryPerformanceFrequency", 10
db "    mov rax, [rel __tickbuf]", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

db "__cpu_count:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    lea rcx, [rel __sysinfo]", 10
db "    call GetSystemInfo", 10
db "    lea rax, [rel __sysinfo]", 10
db "    mov eax, dword [rax+32]", 10
db "    add rsp, 48", 10
db "    pop rbp", 10
db "    ret", 10

db "__load_file:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 104", 10
db "    mov rbx, rdx", 10             ; buffer
db "    mov rsi, r8", 10              ; capacity
db "    mov edx, 0x80000000", 10      ; GENERIC_READ
db "    mov r8d, 1", 10               ; FILE_SHARE_READ
db "    xor r9d, r9d", 10
db "    mov qword [rsp+32], 3", 10    ; OPEN_EXISTING
db "    mov qword [rsp+40], 0x80", 10
db "    mov qword [rsp+48], 0", 10
db "    call CreateFileA", 10
db "    cmp rax, -1", 10
db "    je .lf_fail", 10
db "    mov rdi, rax", 10
db "    mov qword [rel __nread], 0", 10
db "    mov rcx, rdi", 10
db "    mov rdx, rbx", 10
db "    mov r8, rsi", 10
db "    lea r9, [rel __nread]", 10
db "    mov qword [rsp+32], 0", 10
db "    call ReadFile", 10
db "    mov rcx, rdi", 10
db "    call CloseHandle", 10
db "    mov rax, [rel __nread]", 10
db "    jmp .lf_out", 10
db ".lf_fail:", 10
db "    xor rax, rax", 10
db ".lf_out:", 10
db "    add rsp, 104", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__save_file:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 104", 10
db "    mov rbx, rcx", 10
db "    mov rsi, rdx", 10
db "    mov rcx, r8", 10
db "    mov edx, 0x40000000", 10
db "    xor r8d, r8d", 10
db "    xor r9d, r9d", 10
db "    mov qword [rsp+32], 2", 10
db "    mov qword [rsp+40], 0x80", 10
db "    mov qword [rsp+48], 0", 10
db "    call CreateFileA", 10
db "    mov rdi, rax", 10
db "    mov rcx, rdi", 10
db "    mov rdx, rbx", 10
db "    mov r8, rsi", 10
db "    lea r9, [rel __nwritten]", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "    mov rcx, rdi", 10
db "    call CloseHandle", 10
db "    add rsp, 104", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
; ---- signed integer print routine + newline ----
db "__read_key:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 48", 10
db "    mov rcx, -10", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    lea rdx, [rel __keybuf]", 10
db "    mov r8, 1", 10
db "    lea r9, [rel __nread]", 10
db "    mov qword [rsp+32], 0", 10
db "    call ReadFile", 10
db "    xor rax, rax", 10
db "    mov al, [rel __keybuf]", 10
db "    add rsp, 48", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__read_mouse:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 40", 10
db "    mov rcx, -10", 10
db "    call GetStdHandle", 10
db "    mov rbx, rax", 10
db "    mov rcx, rbx", 10
db "    mov edx, 0x0090", 10
db "    call SetConsoleMode", 10
db "__rm_loop:", 10
db "    mov rcx, rbx", 10
db "    lea rdx, [rel __mousebuf]", 10
db "    mov r8, 1", 10
db "    lea r9, [rel __nread]", 10
db "    call ReadConsoleInputA", 10
db "    movzx eax, word [rel __mousebuf]", 10
db "    cmp eax, 2", 10
db "    jne __rm_loop", 10
db "    movzx eax, word [rel __mousebuf+4]", 10
db "    mov [rel __mousex_v], rax", 10
db "    movzx eax, word [rel __mousebuf+6]", 10
db "    mov [rel __mousey_v], rax", 10
db "    mov eax, [rel __mousebuf+8]", 10
db "    add rsp, 40", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__mousex_fn:", 10
db "    mov rax, [rel __mousex_v]", 10
db "    ret", 10
db "__mousey_fn:", 10
db "    mov rax, [rel __mousey_v]", 10
db "    ret", 10
; __print_fail: writes the recorded cause and, when there is one, the hint.
; Nothing here allocates or unwinds, so it is safe from anywhere.
db "section .data", 10
db "__pf_fail: db 'fail: ', 0", 10
db "__pf_hint: db 'hint: ', 0", 10
db "__pf_nl: db 13, 10, 0", 10
db "__bounds_msg: db 'index out of range', 0", 10
db "__bounds_hint: db 'the index has to go from 0 to the array size minus one', 0", 10
db "__emptystr: db 0", 10
db "__nosys_msg: db 'syscall exists only on Linux', 0", 10
db "__nosys_hint: db 'on Windows the system is reached through dll_load and dll_proc', 0", 10
db "section .text", 10
; __main_exit: how main ends. A failure nobody checked with failed() would
; otherwise vanish when the program exits -- an index out of range included --
; so it is printed on the way out. The exit code is left as main returned it.
db "__main_exit:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 40", 10
db "    mov rbx, rcx", 10
db "    mov rcx, [rel __fail_tls]", 10
db "    call TlsGetValue", 10
db "    test rax, rax", 10
db "    jz .me_go", 10
db "    mov rax, [rax]", 10
db "    test rax, rax", 10
db "    jz .me_go", 10
db "    call __print_fail", 10
db ".me_go:", 10
db "    mov rcx, rbx", 10
db "    call ExitProcess", 10
; __print_fail: prints the cause and hint of THIS thread's last failure.
; It may be called with the stack at any alignment, so it aligns it itself.
db "__print_fail:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    mov rcx, [rel __fail_tls]", 10
db "    call TlsGetValue", 10
db "    test rax, rax", 10
db "    jz .pf_done", 10
db "    mov rbx, rax", 10
db "    mov rcx, [rbx+8]", 10
db "    test rcx, rcx", 10
db "    jz .pf_done", 10
db "    lea rcx, [rel __pf_fail]", 10
db "    call __print_str", 10
db "    mov rcx, [rbx+8]", 10
db "    call __print_str", 10
db "    lea rcx, [rel __pf_nl]", 10
db "    call __print_str", 10
db "    mov rcx, [rbx+16]", 10
db "    test rcx, rcx", 10
db "    jz .pf_trace", 10
db "    lea rcx, [rel __pf_hint]", 10
db "    call __print_str", 10
db "    mov rcx, [rbx+16]", 10
db "    call __print_str", 10
db "    lea rcx, [rel __pf_nl]", 10
db "    call __print_str", 10
db ".pf_trace:", 10
db "    mov rcx, rbx", 10
db "    call __trace_print", 10
db ".pf_done:", 10
db "    mov rbx, [rbp-8]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __rt_init: called at the start of main, before any thread can exist.
; Reserves the TLS slot for the failure state and the lock that hands out
; failure blocks.
db "__rt_init:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    call TlsAlloc", 10
db "    mov [rel __fail_tls], rax", 10
db "    lea rcx, [rel __fail_cs]", 10
db "    call InitializeCriticalSection", 10
; locks 16 to 31 belong to the standard library, which may be first used
; from several threads at once: they are made ready here, before any thread
db "    push rbx", 10
db "    sub rsp, 40", 10
db "    mov rbx, 16", 10
db ".ri_lk:", 10
db "    mov rcx, rbx", 10
db "    call __lock_addr", 10
db "    mov rcx, rax", 10
db "    call InitializeCriticalSection", 10
db "    add rbx, 1", 10
db "    cmp rbx, 32", 10
db "    jb .ri_lk", 10
db "    add rsp, 40", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __fail_block -> rax = this thread's failure block, handed out on first use.
; Past 256 threads that ever failed, the rest share the last block.
db "__fail_block:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    mov rcx, [rel __fail_tls]", 10
db "    call TlsGetValue", 10
db "    test rax, rax", 10
db "    jnz .fb_out", 10
db "    lea rcx, [rel __fail_cs]", 10
db "    call EnterCriticalSection", 10
db "    mov rbx, [rel __fail_next]", 10
db "    cmp rbx, 255", 10
db "    jae .fb_have", 10
db "    mov rax, rbx", 10
db "    add rax, 1", 10
db "    mov [rel __fail_next], rax", 10
db ".fb_have:", 10
db "    imul rbx, rbx, 96", 10
db "    lea rax, [rel __fail_pool]", 10
db "    add rbx, rax", 10
db "    lea rcx, [rel __fail_cs]", 10
db "    call LeaveCriticalSection", 10
db "    mov rcx, [rel __fail_tls]", 10
db "    mov rdx, rbx", 10
db "    call TlsSetValue", 10
db "    mov rax, rbx", 10
db ".fb_out:", 10
db "    mov rbx, [rbp-8]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __fail_raise(rcx = cause, rdx = hint or 0, r8 = where it failed or 0):
; records a failure for this thread, with the trace. Callable at any stack
; alignment -- an index out of range fails in the middle of an expression,
; with values still pushed.
db "__fail_raise:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r12", 10
db "    mov rbx, rcx", 10
db "    mov rsi, rdx", 10
db "    mov rdi, r8", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    call __fail_block", 10
db "    mov qword [rax + 0], 1", 10
db "    mov [rax+8], rbx", 10
db "    mov [rax+16], rsi", 10
db "    mov rbx, rax", 10
db "    mov r8, rdi", 10
db "    mov r9, rbp", 10
db "    call __fail_walk", 10
db "    mov rbx, [rbp-8]", 10
db "    mov rsi, [rbp-16]", 10
db "    mov rdi, [rbp-24]", 10
db "    mov r12, [rbp-32]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __clo_alloc(rcx = bytes) -> rax = room for the record of a fn value, 0 when
; the system has none. Taken from 1 MB pieces and never given back: a fn
; value lives as long as the program. Callable at any stack alignment.
db "__clo_alloc:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r12", 10
db "    mov rbx, rcx", 10
db "    add rbx, 15", 10
db "    shr rbx, 4", 10
db "    shl rbx, 4", 10
db "    lea rdi, [rel __clo_lock]", 10
db ".cla_spin:", 10
db "    mov eax, 1", 10
db "    xchg [rdi], eax", 10
db "    test rax, rax", 10
db "    jz .cla_have_lock", 10
db "    jmp .cla_spin", 10
db ".cla_have_lock:", 10
db "    mov rax, [rel __clo_cur]", 10
db "    mov rcx, rax", 10
db "    add rcx, rbx", 10
db "    mov rdx, [rel __clo_end]", 10
db "    test rax, rax", 10
db "    jz .cla_more", 10
db "    cmp rcx, rdx", 10
db "    jbe .cla_take", 10
db ".cla_more:", 10
db "    mov r12, 0x100000", 10
db "    cmp rbx, r12", 10
db "    jbe .cla_size", 10
db "    mov r12, rbx", 10
db ".cla_size:", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    xor ecx, ecx", 10
db "    mov rdx, r12", 10
db "    mov r8, 0x3000", 10
db "    mov r9, 4", 10
db "    call VirtualAlloc", 10
db "    mov rsp, rbp", 10
db "    sub rsp, 32", 10
db "    test rax, rax", 10
db "    jz .cla_out", 10
db "    mov [rel __clo_cur], rax", 10
db "    mov rcx, rax", 10
db "    add rcx, r12", 10
db "    mov [rel __clo_end], rcx", 10
db ".cla_take:", 10
db "    mov rcx, rax", 10
db "    add rcx, rbx", 10
db "    mov [rel __clo_cur], rcx", 10
db ".cla_out:", 10
db "    mov rbx, rax", 10
db "    xor eax, eax", 10
db "    xchg [rdi], eax", 10
db "    mov rax, rbx", 10
db "    mov rbx, [rbp-8]", 10
db "    mov rsi, [rbp-16]", 10
db "    mov rdi, [rbp-24]", 10
db "    mov r12, [rbp-32]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
; __fail_take -> rax = this thread's failure flag, cleared on the way.
db "__fail_take:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    mov rcx, [rel __fail_tls]", 10
db "    call TlsGetValue", 10
db "    test rax, rax", 10
db "    jz .ft_out", 10
db "    mov rcx, rax", 10
db "    mov rax, [rcx]", 10
db "    mov qword [rcx + 0], 0", 10
db ".ft_out:", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __dll_load(rcx = NUL-ended name) -> library handle, 0 if it cannot be loaded.
; Callable at any stack alignment.
db "__dll_load:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    call LoadLibraryA", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __dll_proc(rcx = library, rdx = NUL-ended name) -> function address, or 0.
db "__dll_proc:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    call GetProcAddress", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __beep(rcx = frequency, rdx = duration): the Windows Beep, at any stack
; alignment. Generated code calls the runtime, never the system directly.
db "__beep:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    call Beep", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

; __thread_yield: gives the rest of this time slice to another thread, so a
; thread waiting on a channel does not keep a core busy.
; __arg_parse splits GetCommandLineA once into __argbuf, one NUL-terminated
; word per argument, with double quotes grouping. __arg_count and __arg_get
; read the result; outside the range __arg_get gives an empty string.
; __no_syscall is what syscall(...) becomes on Windows: a fail, not a crash.
db "__arg_parse:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    mov rax, [rel __argdone]", 10
db "    test rax, rax", 10
db "    jnz .ap_out", 10
db "    mov qword [rel __argdone], 1", 10
db "    call GetCommandLineA", 10
db "    mov rsi, rax", 10
db "    lea rdi, [rel __argbuf]", 10
db "    xor rbx, rbx", 10
db "    jmp .ap_skip", 10
db ".ap_skip:", 10
db "    mov al, [rsi]", 10
db "    cmp al, 32", 10
db "    je .ap_adv", 10
db "    cmp al, 9", 10
db "    je .ap_adv", 10
db "    test al, al", 10
db "    jz .ap_out", 10
db "    jmp .ap_word", 10
db ".ap_adv:", 10
db "    inc rsi", 10
db "    jmp .ap_skip", 10
db ".ap_word:", 10
db "    cmp rbx, 64", 10
db "    jae .ap_noslot", 10
db "    lea rax, [rel __argtab]", 10
db "    mov [rax+rbx*8], rdi", 10
db "    inc rbx", 10
db "    mov [rel __argn], rbx", 10
db "    jmp .ap_noslot", 10
db ".ap_noslot:", 10
db "    xor rdx, rdx", 10
db "    jmp .ap_ch", 10
db ".ap_ch:", 10
db "    mov al, [rsi]", 10
db "    test al, al", 10
db "    jz .ap_end", 10
db "    cmp al, 34", 10
db "    je .ap_quote", 10
db "    test rdx, rdx", 10
db "    jnz .ap_copy", 10
db "    cmp al, 32", 10
db "    je .ap_end", 10
db "    cmp al, 9", 10
db "    je .ap_end", 10
db "    jmp .ap_copy", 10
db ".ap_quote:", 10
db "    xor rdx, 1", 10
db "    inc rsi", 10
db "    jmp .ap_ch", 10
db ".ap_copy:", 10
db "    mov [rdi], al", 10
db "    inc rdi", 10
db "    inc rsi", 10
db "    jmp .ap_ch", 10
db ".ap_end:", 10
db "    mov byte [rdi], 0", 10
db "    inc rdi", 10
db "    jmp .ap_skip", 10
db ".ap_out:", 10
db "    mov rbx, [rbp-8]", 10
db "    mov rsi, [rbp-16]", 10
db "    mov rdi, [rbp-24]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__arg_count:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    call __arg_parse", 10
db "    mov rax, [rel __argn]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__arg_get:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    mov rbx, rcx", 10
db "    call __arg_parse", 10
db "    mov rax, [rel __argn]", 10
db "    cmp rbx, rax", 10
db "    jae .wag_none", 10
db "    lea rax, [rel __argtab]", 10
db "    mov rax, [rax+rbx*8]", 10
db "    jmp .wag_out", 10
db ".wag_none:", 10
db "    lea rax, [rel __emptystr]", 10
db "    jmp .wag_out", 10
db ".wag_out:", 10
db "    mov rbx, [rbp-8]", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__no_syscall:", 10
db "    lea rcx, [rel __nosys_msg]", 10
db "    lea rdx, [rel __nosys_hint]", 10
db "    mov r8, [rsp]", 10
db "    call __fail_raise", 10
db "    mov rax, -1", 10
db "    ret", 10
db "__thread_yield:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    call SwitchToThread", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_str:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 48", 10
db "    mov rbx, rcx", 10
db "    xor rsi, rsi", 10
db "__ps_len:", 10
db "    cmp byte [rbx+rsi], 0", 10
db "    je __ps_go", 10
db "    inc rsi", 10
db "    jmp __ps_len", 10
db "__ps_go:", 10
db "    test rsi, rsi", 10
db "    jz __ps_end", 10
db "    mov rcx, -11", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    mov rdx, rbx", 10
db "    mov r8, rsi", 10
db "    lea r9, [rel __nwritten]", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "__ps_end:", 10
db "    add rsp, 48", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_int:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 32", 10
db "    mov rax, rcx", 10
db "    xor r8, r8", 10
db "    test rax, rax", 10
db "    jns .pp", 10
db "    neg rax", 10
db "    mov r8, 1", 10
db ".pp:", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 10", 10
db "    dec rsi", 10
db "    mov rbx, 10", 10
db ".cv:", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec rsi", 10
db "    test rax, rax", 10
db "    jnz .cv", 10
db "    test r8, r8", 10
db "    jz .ns", 10
db "    mov byte [rsi], 45", 10
db "    dec rsi", 10
db ".ns:", 10
db "    inc rsi", 10
db "    lea rax, [rel __numbuf+32]", 10
db "    sub rax, rsi", 10
db "    mov rbx, rax", 10
db "    mov rcx, -11", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    mov rdx, rsi", 10
db "    mov r8, rbx", 10
db "    lea r9, [rel __nwritten]", 10
db "    sub rsp, 16", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "    add rsp, 16", 10
db "    add rsp, 32", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
; __print_float: six decimals; past 9e12 the whole part and the fraction are
; taken apart first (x * 1e6 overflowed above 9.2e12), past 2^63 it is written
; as d.dddddde+N; inf and nan by name.
db "__print_float:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 56", 10
db "    ucomisd xmm0, xmm0", 10
db "    jb .pf_nan", 10
db "    xorps xmm1, xmm1", 10
db "    comisd xmm1, xmm0", 10
db "    jbe .pf_pos", 10
db "    movsd [rbp-16], xmm0", 10
db "    mov rcx, 45", 10
db "    call __print_char", 10
db "    movsd xmm0, [rbp-16]", 10
db "    mov rax, 0x8000000000000000", 10
db "    movq xmm2, rax", 10
db "    xorps xmm0, xmm2", 10
db ".pf_pos:", 10
db "    mov rax, 0x42A05EF39B200000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_big", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    mov [rbp-24], rdx", 10
db "    jmp .pf_out", 10
db ".pf_big:", 10
db "    mov rax, 0x43E0000000000000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_sci", 10
db "    cvttsd2si rax, xmm0", 10
db "    cvtsi2sd xmm1, rax", 10
db "    subsd xmm0, xmm1", 10
db "    mov rbx, rax", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    cmp rax, 1000000", 10
db "    jb .pf_bf", 10
db "    sub rax, 1000000", 10
db "    add rbx, 1", 10
db ".pf_bf:", 10
db "    mov [rbp-24], rax", 10
db "    mov rax, rbx", 10
db ".pf_out:", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-24]", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    jmp .pf_nl", 10
db ".pf_sci:", 10
db "    mov rax, 0x7FF0000000000000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_inf", 10
db "    xor rbx, rbx", 10
db "    mov rax, 10", 10
db "    cvtsi2sd xmm1, rax", 10
db ".pf_sl:", 10
db "    comisd xmm0, xmm1", 10
db "    jb .pf_sd", 10
db "    divsd xmm0, xmm1", 10
db "    add rbx, 1", 10
db "    jmp .pf_sl", 10
db ".pf_sd:", 10
db "    mov [rbp-32], rbx", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    cmp rax, 10000000", 10
db "    jb .pf_sm", 10
db "    mov rax, 1000000", 10
db "    mov rbx, [rbp-32]", 10
db "    add rbx, 1", 10
db "    mov [rbp-32], rbx", 10
db ".pf_sm:", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    mov [rbp-24], rdx", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-24]", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    mov rcx, 101", 10
db "    call __print_char", 10
db "    mov rcx, 43", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-32]", 10
db "    call __print_uint", 10
db "    jmp .pf_nl", 10
db ".pf_inf:", 10
db "    mov rcx, 105", 10
db "    call __print_char", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db "    mov rcx, 102", 10
db "    call __print_char", 10
db "    jmp .pf_nl", 10
db ".pf_nan:", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db "    mov rcx, 97", 10
db "    call __print_char", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db ".pf_nl:", 10
db "    mov rcx, 10", 10
db "    call __print_char", 10
db "    add rsp, 56", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_uint:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".ul:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .ul", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_pad:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pl:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec r10", 10
db "    test r10, r10", 10
db "    jnz .pl", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_char:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    mov [rel __chbuf], cl", 10
db "    mov byte [rel __chbuf+1], 0", 10
db "    lea rcx, [rel __chbuf]", 10
db "    call __print_cstr", 10
db "    add rsp, 48", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_cstr:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 48", 10
db "    mov rsi, rcx", 10
db "    xor rbx, rbx", 10
db ".cl:", 10
db "    cmp byte [rsi+rbx], 0", 10
db "    je .cd", 10
db "    inc rbx", 10
db "    jmp .cl", 10
db ".cd:", 10
db "    mov rcx, -11", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    mov rdx, rsi", 10
db "    mov r8, rbx", 10
db "    lea r9, [rel __nwritten]", 10
db "    sub rsp, 16", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "    add rsp, 16", 10
db "    add rsp, 48", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
hdr_len equ $ - hdr

; ---- BARE-METAL preamble (freestanding: no externs, no operating system) ----
hdrbare:
db "bits 64", 10
db "global kmain", 10
db "section .bss", 10
db "__numbuf: resb 32", 10
db "__vgapos: resq 1", 10
db "__chbuf: resb 2", 10
db "section .text", 10
; A flat binary is entered at offset 0, so the very first thing emitted has to
; be a jump to the kernel entry point.  Without it the loader lands in the
; middle of __print_int, which is simply whatever routine happens to come
; first in the runtime.
db "    jmp kmain", 10
db "__print_int:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    mov rax, rcx", 10
db "    xor r8, r8", 10
db "    test rax, rax", 10
db "    jns .bpp", 10
db "    neg rax", 10
db "    mov r8, 1", 10
db ".bpp:", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    dec rsi", 10
db "    mov rbx, 10", 10
db ".bcv:", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec rsi", 10
db "    test rax, rax", 10
db "    jnz .bcv", 10
db "    test r8, r8", 10
db "    jz .bns", 10
db "    mov byte [rsi], 45", 10
db "    dec rsi", 10
db ".bns:", 10
db "    inc rsi", 10
db "    mov rcx, rsi", 10
db "    call __print_str", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_str:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    mov rsi, rcx", 10
db "    mov rdi, 0xB8000", 10
db "    add rdi, [rel __vgapos]", 10
db ".bsl:", 10
db "    mov al, [rsi]", 10
db "    test al, al", 10
db "    jz .bsd", 10
db "    cmp al, 10", 10
db "    jne .bsc", 10
db "    mov rax, [rel __vgapos]", 10
db "    add rax, 160", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 160", 10
db "    div rbx", 10
db "    imul rax, rbx", 10
db "    mov [rel __vgapos], rax", 10
db "    mov rdi, 0xB8000", 10
db "    add rdi, rax", 10
db "    inc rsi", 10
db "    jmp .bsl", 10
db ".bsc:", 10
db "    mov [rdi], al", 10
db "    mov byte [rdi+1], 0x0F", 10
db "    add rdi, 2", 10
db "    add qword [rel __vgapos], 2", 10
db "    inc rsi", 10
db "    jmp .bsl", 10
db ".bsd:", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
; __print_float: six decimals; past 9e12 the whole part and the fraction are
; taken apart first (x * 1e6 overflowed above 9.2e12), past 2^63 it is written
; as d.dddddde+N; inf and nan by name.
db "__print_float:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 56", 10
db "    ucomisd xmm0, xmm0", 10
db "    jb .pf_nan", 10
db "    xorps xmm1, xmm1", 10
db "    comisd xmm1, xmm0", 10
db "    jbe .pf_pos", 10
db "    movsd [rbp-16], xmm0", 10
db "    mov rcx, 45", 10
db "    call __print_char", 10
db "    movsd xmm0, [rbp-16]", 10
db "    mov rax, 0x8000000000000000", 10
db "    movq xmm2, rax", 10
db "    xorps xmm0, xmm2", 10
db ".pf_pos:", 10
db "    mov rax, 0x42A05EF39B200000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_big", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    mov [rbp-24], rdx", 10
db "    jmp .pf_out", 10
db ".pf_big:", 10
db "    mov rax, 0x43E0000000000000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_sci", 10
db "    cvttsd2si rax, xmm0", 10
db "    cvtsi2sd xmm1, rax", 10
db "    subsd xmm0, xmm1", 10
db "    mov rbx, rax", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    cmp rax, 1000000", 10
db "    jb .pf_bf", 10
db "    sub rax, 1000000", 10
db "    add rbx, 1", 10
db ".pf_bf:", 10
db "    mov [rbp-24], rax", 10
db "    mov rax, rbx", 10
db ".pf_out:", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-24]", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    jmp .pf_nl", 10
db ".pf_sci:", 10
db "    mov rax, 0x7FF0000000000000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_inf", 10
db "    xor rbx, rbx", 10
db "    mov rax, 10", 10
db "    cvtsi2sd xmm1, rax", 10
db ".pf_sl:", 10
db "    comisd xmm0, xmm1", 10
db "    jb .pf_sd", 10
db "    divsd xmm0, xmm1", 10
db "    add rbx, 1", 10
db "    jmp .pf_sl", 10
db ".pf_sd:", 10
db "    mov [rbp-32], rbx", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    cmp rax, 10000000", 10
db "    jb .pf_sm", 10
db "    mov rax, 1000000", 10
db "    mov rbx, [rbp-32]", 10
db "    add rbx, 1", 10
db "    mov [rbp-32], rbx", 10
db ".pf_sm:", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    mov [rbp-24], rdx", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-24]", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    mov rcx, 101", 10
db "    call __print_char", 10
db "    mov rcx, 43", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-32]", 10
db "    call __print_uint", 10
db "    jmp .pf_nl", 10
db ".pf_inf:", 10
db "    mov rcx, 105", 10
db "    call __print_char", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db "    mov rcx, 102", 10
db "    call __print_char", 10
db "    jmp .pf_nl", 10
db ".pf_nan:", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db "    mov rcx, 97", 10
db "    call __print_char", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db ".pf_nl:", 10
db "    mov rcx, 10", 10
db "    call __print_char", 10
db "    add rsp, 56", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_uint:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".ul:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .ul", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_pad:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pl:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec r10", 10
db "    test r10, r10", 10
db "    jnz .pl", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_char:", 10
db "    mov [rel __chbuf], cl", 10
db "    mov byte [rel __chbuf+1], 0", 10
db "    lea rcx, [rel __chbuf]", 10
db "    call __print_str", 10
db "    ret", 10
db "__print_cstr:", 10
db "    jmp __print_str", 10
db "__beep:", 10
db "    ret", 10
hdrbare_len equ $ - hdrbare

; ---- Linux preamble: the runtime, over Linux system calls, no libc ----
; The same routines as the Windows preamble, with the same conventions
; (arguments in rcx, rdx, r8; rbx, rsi, rdi and r12-r15 preserved), so the
; generated code is identical for both systems. _start calls main, so main
; runs with the stack aligned as on Windows. Threads and dll_load fail with
; a clear cause until they exist on Linux.
hdrelf:
db "default rel", 10
db "bits 64", 10
db "global _start", 10
db "section .bss", 10
db "__numbuf: resb 32", 10
db "__chbuf: resb 2", 10
db "__keybuf: resb 2", 10
db "__mousex_v: resq 1", 10
db "__mousey_v: resq 1", 10
db "__locks: resb 2048", 10
db "__tickbuf: resq 2", 10
db "__fail_main: resq 12", 10
db "__clo_lock: resq 1", 10
db "__clo_cur: resq 1", 10
db "__clo_end: resq 1", 10
db "__main_top: resq 1", 10
db "__main_span: resq 1", 10
db "__rlim: resq 2", 10
db "__argc: resq 1", 10
db "__argv: resq 1", 10
db "__cpubuf: resb 128", 10
db "section .data", 10
db "__pf_fail: db 'fail: ', 0", 10
db "__pf_hint: db 'hint: ', 0", 10
db "__pf_nl: db 10, 0", 10
db "__bounds_msg: db 'index out of range', 0", 10
db "__bounds_hint: db 'the index has to go from 0 to the array size minus one', 0", 10
db "__outname: db 'out.bmp', 0", 10
db "__th_msg: db 'cannot start a thread', 0", 10
db "__th_hint: db 'the system refused the stack or the thread: too many threads at once?', 0", 10
db "__emptystr: db 0", 10
db "__dll_msg: db 'dll_load and dll_proc exist only on Windows', 0", 10
db "__dll_hint: db 'on Linux, the system is reached through its system calls', 0", 10
db "__bel: db 7, 0", 10
db "section .text", 10
db "_start:", 10
db "    mov [rel __main_top], rsp", 10
; how far below the top the main thread's stack may reach: the stack limit
; (getrlimit), capped at 1 GB, 8 MB when it cannot be read. __fail_block
; tells main from a thread by it; a fixed 64 MB was wrong where a thread's
; stack is mapped close below the main one, as under QEMU.
db "    mov rax, 97", 10
db "    mov rdi, 3", 10
db "    lea rsi, [rel __rlim]", 10
db "    syscall", 10
db "    test rax, rax", 10
db "    jnz .ms_def", 10
db "    mov rax, [rel __rlim]", 10
db "    test rax, rax", 10
db "    jz .ms_def", 10
db "    cmp rax, 0x40000000", 10
db "    jbe .ms_set", 10
db "    mov rax, 0x40000000", 10
db "    jmp .ms_set", 10
db ".ms_def:", 10
db "    mov rax, 0x800000", 10
db ".ms_set:", 10
db "    mov [rel __main_span], rax", 10
db "    mov rax, [rsp]", 10
db "    mov [rel __argc], rax", 10
db "    mov rax, rsp", 10
db "    add rax, 8", 10
db "    mov [rel __argv], rax", 10
db "    call main", 10
db "    mov rcx, rax", 10
db "    call __main_exit", 10
db "__main_exit:", 10
db "    push rbx", 10
db "    mov rbx, rcx", 10
db "    mov rax, [rel __fail_main]", 10
db "    test rax, rax", 10
db "    jz .me_go", 10
db "    call __print_fail", 10
db ".me_go:", 10
db "    mov rdi, rbx", 10
db "    mov rax, 231", 10
db "    syscall", 10
db "__write_out:", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rcx", 10
db "    mov rsi, rcx", 10
db "    mov rax, 1", 10
db "    mov rdi, 1", 10
db "    syscall", 10
db "    pop rcx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    ret", 10
db "__print_cstr:", 10
db "    push rbx", 10
db "    push rdx", 10
db "    xor rbx, rbx", 10
db ".pc_len:", 10
db "    cmp byte [rcx+rbx], 0", 10
db "    je .pc_go", 10
db "    inc rbx", 10
db "    jmp .pc_len", 10
db ".pc_go:", 10
db "    test rbx, rbx", 10
db "    jz .pc_end", 10
db "    mov rdx, rbx", 10
db "    call __write_out", 10
db ".pc_end:", 10
db "    pop rdx", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_str:", 10
db "    jmp __print_cstr", 10
db "__print_char:", 10
db "    mov [rel __chbuf], cl", 10
db "    mov byte [rel __chbuf+1], 0", 10
db "    lea rcx, [rel __chbuf]", 10
db "    jmp __print_cstr", 10
db "__print_uint:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdx", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pu_loop:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .pu_loop", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    pop rdx", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_int:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdx", 10
db "    push r8", 10
db "    mov rax, rcx", 10
db "    xor r8, r8", 10
db "    test rax, rax", 10
db "    jns .pi_pos", 10
db "    neg rax", 10
db "    mov r8, 1", 10
db ".pi_pos:", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    dec rsi", 10
db "    mov byte [rsi], 10", 10
db "    mov rbx, 10", 10
db ".pi_loop:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .pi_loop", 10
db "    test r8, r8", 10
db "    jz .pi_go", 10
db "    dec rsi", 10
db "    mov byte [rsi], 45", 10
db ".pi_go:", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    pop r8", 10
db "    pop rdx", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_pad:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdx", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pp_loop:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec r10", 10
db "    test r10, r10", 10
db "    jnz .pp_loop", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    pop rdx", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
; __print_float: six decimals; past 9e12 the whole part and the fraction are
; taken apart first (x * 1e6 overflowed above 9.2e12), past 2^63 it is written
; as d.dddddde+N; inf and nan by name.
db "__print_float:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 56", 10
db "    ucomisd xmm0, xmm0", 10
db "    jb .pf_nan", 10
db "    xorps xmm1, xmm1", 10
db "    comisd xmm1, xmm0", 10
db "    jbe .pf_pos", 10
db "    movsd [rbp-16], xmm0", 10
db "    mov rcx, 45", 10
db "    call __print_char", 10
db "    movsd xmm0, [rbp-16]", 10
db "    mov rax, 0x8000000000000000", 10
db "    movq xmm2, rax", 10
db "    xorps xmm0, xmm2", 10
db ".pf_pos:", 10
db "    mov rax, 0x42A05EF39B200000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_big", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    mov [rbp-24], rdx", 10
db "    jmp .pf_out", 10
db ".pf_big:", 10
db "    mov rax, 0x43E0000000000000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_sci", 10
db "    cvttsd2si rax, xmm0", 10
db "    cvtsi2sd xmm1, rax", 10
db "    subsd xmm0, xmm1", 10
db "    mov rbx, rax", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    cmp rax, 1000000", 10
db "    jb .pf_bf", 10
db "    sub rax, 1000000", 10
db "    add rbx, 1", 10
db ".pf_bf:", 10
db "    mov [rbp-24], rax", 10
db "    mov rax, rbx", 10
db ".pf_out:", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-24]", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    jmp .pf_nl", 10
db ".pf_sci:", 10
db "    mov rax, 0x7FF0000000000000", 10
db "    movq xmm1, rax", 10
db "    comisd xmm0, xmm1", 10
db "    jae .pf_inf", 10
db "    xor rbx, rbx", 10
db "    mov rax, 10", 10
db "    cvtsi2sd xmm1, rax", 10
db ".pf_sl:", 10
db "    comisd xmm0, xmm1", 10
db "    jb .pf_sd", 10
db "    divsd xmm0, xmm1", 10
db "    add rbx, 1", 10
db "    jmp .pf_sl", 10
db ".pf_sd:", 10
db "    mov [rbp-32], rbx", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    cmp rax, 10000000", 10
db "    jb .pf_sm", 10
db "    mov rax, 1000000", 10
db "    mov rbx, [rbp-32]", 10
db "    add rbx, 1", 10
db "    mov [rbp-32], rbx", 10
db ".pf_sm:", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    mov [rbp-24], rdx", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-24]", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    mov rcx, 101", 10
db "    call __print_char", 10
db "    mov rcx, 43", 10
db "    call __print_char", 10
db "    mov rcx, [rbp-32]", 10
db "    call __print_uint", 10
db "    jmp .pf_nl", 10
db ".pf_inf:", 10
db "    mov rcx, 105", 10
db "    call __print_char", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db "    mov rcx, 102", 10
db "    call __print_char", 10
db "    jmp .pf_nl", 10
db ".pf_nan:", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db "    mov rcx, 97", 10
db "    call __print_char", 10
db "    mov rcx, 110", 10
db "    call __print_char", 10
db ".pf_nl:", 10
db "    mov rcx, 10", 10
db "    call __print_char", 10
db "    add rsp, 56", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_fail:", 10
db "    push rbx", 10
db "    call __fail_block", 10
db "    mov rbx, rax", 10
db "    mov rcx, [rbx+8]", 10
db "    test rcx, rcx", 10
db "    jz .pf_done", 10
db "    lea rcx, [rel __pf_fail]", 10
db "    call __print_cstr", 10
db "    mov rcx, [rbx+8]", 10
db "    call __print_cstr", 10
db "    lea rcx, [rel __pf_nl]", 10
db "    call __print_cstr", 10
db "    mov rcx, [rbx+16]", 10
db "    test rcx, rcx", 10
db "    jz .pf_trace", 10
db "    lea rcx, [rel __pf_hint]", 10
db "    call __print_cstr", 10
db "    mov rcx, [rbx+16]", 10
db "    call __print_cstr", 10
db "    lea rcx, [rel __pf_nl]", 10
db "    call __print_cstr", 10
db ".pf_trace:", 10
db "    mov rcx, rbx", 10
db "    call __trace_print", 10
db ".pf_done:", 10
db "    pop rbx", 10
db "    ret", 10
;
; Per-thread fail state on Linux. Every thread Kron starts runs on a 1 MB
; stack aligned to 1 MB, and its 96-byte fail block sits at the bottom of that
; stack: rsp with its low 20 bits cleared. The main thread is told apart by
; how far rsp is from where _start found it: within the stack limit _start
; read (__main_span), which no other mapping can share. No TLS register, no
; system call: as cheap as reading rsp.
db "__rt_init:", 10
db "    ret", 10
db "__fail_block:", 10
db "    mov rax, [rel __main_top]", 10
db "    sub rax, rsp", 10
db "    cmp rax, [rel __main_span]", 10
db "    jb .fbl_main", 10
db "    mov rax, rsp", 10
db "    shr rax, 20", 10
db "    shl rax, 20", 10
db "    ret", 10
db ".fbl_main:", 10
db "    lea rax, [rel __fail_main]", 10
db "    ret", 10
db "__fail_raise:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push r9", 10
db "    call __fail_block", 10
db "    mov qword [rax + 0], 1", 10
db "    mov [rax+8], rcx", 10
db "    mov [rax+16], rdx", 10
db "    mov rbx, rax", 10
db "    mov r9, rbp", 10
db "    call __fail_walk", 10
db "    pop r9", 10
db "    pop rbx", 10
db "    pop rbp", 10
db "    ret", 10
; __clo_alloc(rcx = bytes) -> rax: the record of a fn value, from 1 MB
; pieces mapped as needed and never unmapped
db "__clo_alloc:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rdx", 10
db "    push r8", 10
db "    push r9", 10
db "    push r10", 10
db "    push r11", 10
db "    push r12", 10
db "    mov rbx, rcx", 10
db "    add rbx, 15", 10
db "    shr rbx, 4", 10
db "    shl rbx, 4", 10
db "    lea r12, [rel __clo_lock]", 10
db ".cla_spin:", 10
db "    mov eax, 1", 10
db "    xchg [r12], eax", 10
db "    test rax, rax", 10
db "    jz .cla_have_lock", 10
db "    jmp .cla_spin", 10
db ".cla_have_lock:", 10
db "    mov rax, [rel __clo_cur]", 10
db "    mov rcx, rax", 10
db "    add rcx, rbx", 10
db "    mov rdx, [rel __clo_end]", 10
db "    test rax, rax", 10
db "    jz .cla_more", 10
db "    cmp rcx, rdx", 10
db "    jbe .cla_take", 10
db ".cla_more:", 10
db "    mov rsi, 0x100000", 10
db "    cmp rbx, rsi", 10
db "    jbe .cla_size", 10
db "    mov rsi, rbx", 10
db ".cla_size:", 10
db "    push rsi", 10
db "    mov rax, 9", 10
db "    xor rdi, rdi", 10
db "    mov rdx, 3", 10
db "    mov r10, 0x22", 10
db "    mov r8, -1", 10
db "    xor r9, r9", 10
db "    syscall", 10
db "    pop rsi", 10
db "    cmp rax, -4096", 10
db "    jbe .cla_mapped", 10
db "    xor eax, eax", 10
db "    jmp .cla_out", 10
db ".cla_mapped:", 10
db "    mov [rel __clo_cur], rax", 10
db "    mov rcx, rax", 10
db "    add rcx, rsi", 10
db "    mov [rel __clo_end], rcx", 10
db ".cla_take:", 10
db "    mov rcx, rax", 10
db "    add rcx, rbx", 10
db "    mov [rel __clo_cur], rcx", 10
db ".cla_out:", 10
db "    mov rbx, rax", 10
db "    xor eax, eax", 10
db "    xchg [r12], eax", 10
db "    mov rax, rbx", 10
db "    pop r12", 10
db "    pop r11", 10
db "    pop r10", 10
db "    pop r9", 10
db "    pop r8", 10
db "    pop rdx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__fail_take:", 10
db "    call __fail_block", 10
db "    mov rcx, rax", 10
db "    mov rax, [rcx]", 10
db "    mov qword [rcx + 0], 0", 10
db "    ret", 10
db "__lock_addr:", 10
db "    cmp rcx, 32", 10
db "    jb .la_ok", 10
db "    xor rcx, rcx", 10
db ".la_ok:", 10
db "    imul rcx, rcx, 64", 10
db "    lea rax, [rel __locks]", 10
db "    add rax, rcx", 10
db "    ret", 10
;
; Locks: a futex word per lock, 0 free, 1 taken, 2 taken with waiters. Only
; xchg is needed (atomic on memory without a prefix); a waiter sleeps in the
; kernel and the one who frees a lock with waiters wakes one of them.
;
; Threads: clone with a 1 MB stack aligned to 1 MB (2 MB are mapped to align
; it). The bottom of the stack holds the fail block (0..23), the thread id
; (24), which the kernel clears and wakes when the thread ends, and the
; mapping (32), released by thread_wait. A thread is waited for once.
db "__lock_init:", 10
db "    push rcx", 10
db "    call __lock_addr", 10
db "    mov dword [rax], 0", 10
db "    pop rcx", 10
db "    ret", 10
db "__lock_take:", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rdx", 10
db "    call __lock_addr", 10
db "    mov rdi, rax", 10
db "    mov eax, 1", 10
db "    xchg [rdi], eax", 10
db "    test rax, rax", 10
db "    jz .lt_out", 10
db "    jmp .lt_slow", 10
db ".lt_slow:", 10
db "    mov eax, 2", 10
db "    xchg [rdi], eax", 10
db "    test rax, rax", 10
db "    jz .lt_out", 10
db "    mov rsi, 128", 10
db "    mov rdx, 2", 10
db "    xor r10, r10", 10
db "    mov rax, 202", 10
db "    syscall", 10
db "    jmp .lt_slow", 10
db ".lt_out:", 10
db "    pop rdx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    ret", 10
db "__lock_give:", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rdx", 10
db "    call __lock_addr", 10
db "    mov rdi, rax", 10
db "    xor eax, eax", 10
db "    xchg [rdi], eax", 10
db "    cmp rax, 2", 10
db "    jne .lg_out", 10
db "    mov rsi, 129", 10
db "    mov rdx, 1", 10
db "    xor r10, r10", 10
db "    mov rax, 202", 10
db "    syscall", 10
db "    jmp .lg_out", 10
db ".lg_out:", 10
db "    pop rdx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    ret", 10
db "__thread_start:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r12", 10
db "    push r13", 10
db "    push r14", 10
db "    mov r12, rcx", 10
db "    mov r13, rdx", 10
db "    mov rax, 9", 10
db "    xor rdi, rdi", 10
db "    mov rsi, 0x200000", 10
db "    mov rdx, 3", 10
db "    mov r10, 0x22", 10
db "    mov r8, -1", 10
db "    xor r9, r9", 10
db "    syscall", 10
db "    cmp rax, -4096", 10
db "    ja .ts_fail", 10
db "    mov r14, rax", 10
db "    add rax, 0xFFFFF", 10
db "    shr rax, 20", 10
db "    shl rax, 20", 10
db "    mov rbx, rax", 10
db "    mov qword [rbx + 0], 0", 10
db "    mov qword [rbx + 8], 0", 10
db "    mov qword [rbx + 16], 0", 10
db "    mov qword [rbx + 24], 0", 10
db "    mov qword [rbx + 96], 0", 10
db "    mov [rbx+104], r14", 10
db "    mov rsi, rbx", 10
db "    add rsi, 0x100000", 10
db "    sub rsi, 16", 10
db "    mov [rsi], r12", 10
db "    mov [rsi+8], r13", 10
db "    mov rax, 56", 10
db "    mov rdi, 0x350F00", 10
db "    mov rdx, rbx", 10
db "    add rdx, 96", 10
db "    mov r10, rdx", 10
db "    xor r8, r8", 10
db "    syscall", 10
db "    test rax, rax", 10
db "    jz .ts_child", 10
db "    js .ts_unmap", 10
db "    mov rax, rbx", 10
db "    jmp .ts_out", 10
db ".ts_child:", 10
db "    pop rax", 10
db "    pop rcx", 10
db "    sub rsp, 32", 10
db "    call rax", 10
db "    mov rax, 60", 10
db "    xor rdi, rdi", 10
db "    syscall", 10
db "    jmp .ts_unmap", 10
db ".ts_unmap:", 10
db "    mov rdi, r14", 10
db "    mov rsi, 0x200000", 10
db "    mov rax, 11", 10
db "    syscall", 10
db "    jmp .ts_fail", 10
db ".ts_fail:", 10
db "    lea rcx, [rel __th_msg]", 10
db "    lea rdx, [rel __th_hint]", 10
db "    xor r8, r8", 10
db "    call __fail_raise", 10
db "    xor eax, eax", 10
db "    jmp .ts_out", 10
db ".ts_out:", 10
db "    pop r14", 10
db "    pop r13", 10
db "    pop r12", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__thread_wait:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rdx", 10
db "    mov rbx, rcx", 10
db "    test rbx, rbx", 10
db "    jz .tw_out", 10
db "    jmp .tw_loop", 10
db ".tw_loop:", 10
db "    mov eax, [rbx+96]", 10
db "    test rax, rax", 10
db "    jz .tw_done", 10
db "    mov rdi, rbx", 10
db "    add rdi, 96", 10
db "    xor rsi, rsi", 10
db "    mov rdx, rax", 10
db "    xor r10, r10", 10
db "    mov rax, 202", 10
db "    syscall", 10
db "    jmp .tw_loop", 10
db ".tw_done:", 10
db "    mov rdi, [rbx+104]", 10
db "    mov rsi, 0x200000", 10
db "    mov rax, 11", 10
db "    syscall", 10
db "    jmp .tw_out", 10
db ".tw_out:", 10
db "    xor eax, eax", 10
db "    pop rdx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__thread_yield:", 10
db "    push rcx", 10
db "    mov rax, 24", 10
db "    syscall", 10
db "    pop rcx", 10
db "    ret", 10
;
; cpu_count: the processors this program may run on (sched_getaffinity),
; counting the bits of the mask. Arguments: _start keeps argc and argv.
db "__cpu_count:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rdx", 10
db "    mov rax, 204", 10
db "    xor rdi, rdi", 10
db "    mov rsi, 128", 10
db "    lea rdx, [rel __cpubuf]", 10
db "    syscall", 10
db "    test rax, rax", 10
db "    jle .cc_one", 10
db "    mov rcx, rax", 10
db "    lea rsi, [rel __cpubuf]", 10
db "    xor rbx, rbx", 10
db "    jmp .cc_byte", 10
db ".cc_byte:", 10
db "    test rcx, rcx", 10
db "    jz .cc_done", 10
db "    movzx rdx, byte [rsi]", 10
db "    jmp .cc_bit", 10
db ".cc_bit:", 10
db "    test rdx, rdx", 10
db "    jz .cc_next", 10
db "    mov rax, rdx", 10
db "    and rax, 1", 10
db "    add rbx, rax", 10
db "    shr rdx, 1", 10
db "    jmp .cc_bit", 10
db ".cc_next:", 10
db "    inc rsi", 10
db "    dec rcx", 10
db "    jmp .cc_byte", 10
db ".cc_done:", 10
db "    mov rax, rbx", 10
db "    test rax, rax", 10
db "    jz .cc_one", 10
db "    jmp .cc_out", 10
db ".cc_one:", 10
db "    mov rax, 1", 10
db "    jmp .cc_out", 10
db ".cc_out:", 10
db "    pop rdx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__arg_count:", 10
db "    mov rax, [rel __argc]", 10
db "    ret", 10
db "__arg_get:", 10
db "    mov rax, [rel __argc]", 10
db "    cmp rcx, rax", 10
db "    jae .ag_none", 10
db "    mov rax, [rel __argv]", 10
db "    mov rax, [rax+rcx*8]", 10
db "    ret", 10
db ".ag_none:", 10
db "    lea rax, [rel __emptystr]", 10
db "    ret", 10
db "__ticks:", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rcx", 10
db "    mov rax, 228", 10
db "    mov rdi, 1", 10
db "    lea rsi, [rel __tickbuf]", 10
db "    syscall", 10
db "    mov rax, [rel __tickbuf]", 10
db "    mov rcx, 1000000000", 10
db "    imul rax, rcx", 10
db "    add rax, [rel __tickbuf+8]", 10
db "    pop rcx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    ret", 10
db "__ticks_per_sec:", 10
db "    mov rax, 1000000000", 10
db "    ret", 10
db "__load_file:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r12", 10
db "    mov rbx, rdx", 10
db "    mov r12, r8", 10
db "    mov rax, 2", 10
db "    mov rdi, rcx", 10
db "    xor rsi, rsi", 10
db "    xor rdx, rdx", 10
db "    syscall", 10
db "    test rax, rax", 10
db "    jl .lf_fail", 10
db "    mov rdi, rax", 10
db "    push rdi", 10
db "    mov rax, 0", 10
db "    mov rsi, rbx", 10
db "    mov rdx, r12", 10
db "    syscall", 10
db "    mov rbx, rax", 10
db "    pop rdi", 10
db "    mov rax, 3", 10
db "    syscall", 10
db "    mov rax, rbx", 10
db "    test rax, rax", 10
db "    jge .lf_out", 10
db ".lf_fail:", 10
db "    xor eax, eax", 10
db ".lf_out:", 10
db "    pop r12", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
; __save_file(rcx = buffer, rdx = length, r8 = name): the order of
; savefile(buffer, length, name) and of the Windows routine. The first Linux
; version read the name from rcx, so bmp, cube3d and the rest would have
; written their image to a file named after the buffer.
db "__save_file:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r12", 10
db "    mov rbx, rcx", 10
db "    mov r12, rdx", 10
db "    mov rax, 2", 10
db "    mov rdi, r8", 10
db "    mov rsi, 577", 10
db "    mov rdx, 420", 10
db "    syscall", 10
db "    test rax, rax", 10
db "    jl .sf_fail", 10
db "    mov rdi, rax", 10
db "    push rdi", 10
db "    mov rax, 1", 10
db "    mov rsi, rbx", 10
db "    mov rdx, r12", 10
db "    syscall", 10
db "    mov rbx, rax", 10
db "    pop rdi", 10
db "    mov rax, 3", 10
db "    syscall", 10
db "    mov rax, rbx", 10
db "    test rax, rax", 10
db "    jge .sf_out", 10
db ".sf_fail:", 10
db "    xor eax, eax", 10
db ".sf_out:", 10
db "    pop r12", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__read_key:", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push rdx", 10
db "    push rcx", 10
db "    mov byte [rel __keybuf], 0", 10
db "    mov rax, 0", 10
db "    mov rdi, 0", 10
db "    lea rsi, [rel __keybuf]", 10
db "    mov rdx, 1", 10
db "    syscall", 10
db "    lea rcx, [rel __keybuf]", 10
db "    xor eax, eax", 10
db "    mov al, [rcx]", 10
db "    pop rcx", 10
db "    pop rdx", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    ret", 10
db "__read_mouse:", 10
db "    xor eax, eax", 10
db "    ret", 10
db "__mousex_fn:", 10
db "    mov rax, [rel __mousex_v]", 10
db "    ret", 10
db "__mousey_fn:", 10
db "    mov rax, [rel __mousey_v]", 10
db "    ret", 10
db "__beep:", 10
db "    lea rcx, [rel __bel]", 10
db "    jmp __print_cstr", 10
db "__dll_load:", 10
db "    lea rcx, [rel __dll_msg]", 10
db "    lea rdx, [rel __dll_hint]", 10
db "    xor r8, r8", 10
db "    call __fail_raise", 10
db "    xor eax, eax", 10
db "    ret", 10
db "__dll_proc:", 10
db "    lea rcx, [rel __dll_msg]", 10
db "    lea rdx, [rel __dll_hint]", 10
db "    xor r8, r8", 10
db "    call __fail_raise", 10
db "    xor eax, eax", 10
db "    ret", 10
hdrelf_len equ $ - hdrelf

; ==============================================================================
; The failure trace, shared by the Windows and the Linux preambles.
;
; A failure block is 96 bytes:
;   +0 flag   +8 cause   +16 hint   +24 frames kept   +32 up to 8 addresses
; The first address is where the failure happened (r8 of __fail_raise), the
; rest are the return addresses of the functions that led there, read from
; the chain of saved rbp. The walk only keeps addresses inside the program's
; own functions (__kron_lo to __kron_hi) and stops at the first one outside
; once it has kept one: past main, past a thread's function, past a callback
; the system made, nothing is read. Turning addresses into names and lines
; waits for print_fail, so failing costs a few loads, not a search.
; ==============================================================================
hdrtrace:
db "section .data", 10
db "__tp_at: db '  at ', 0", 10
db "__tp_from: db '  called from ', 0", 10
db "__tp_open: db ' (', 0", 10
db "__tp_colon: db ':', 0", 10
db "__tp_close: db ')', 0", 10
db "section .text", 10
; __fail_walk(rbx = block, r8 = where or 0, r9 = frame of __fail_raise).
; Preserves every register except rax.
db "__fail_walk:", 10
db "    push rcx", 10
db "    push rdx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r9", 10
db "    push r10", 10
db "    push r11", 10
db "    push r12", 10
db "    xor r10, r10", 10
db "    xor r11, r11", 10
db "    mov r12, 16", 10
db "    lea rsi, [rel __kron_lo]", 10
db "    lea rdi, [rel __kron_hi]", 10
db "    test r8, r8", 10
db "    jz .fw_step", 10
db "    mov [rbx+32], r8", 10
db "    mov r10, 1", 10
db ".fw_step:", 10
db "    cmp r10, 8", 10
db "    jae .fw_done", 10
db "    sub r12, 1", 10
db "    jz .fw_done", 10
db "    mov rax, [r9+8]", 10
db "    cmp rax, r8", 10
db "    je .fw_next", 10
db "    cmp rax, rsi", 10
db "    jb .fw_out", 10
db "    cmp rax, rdi", 10
db "    jae .fw_out", 10
db "    mov rdx, r10", 10
db "    shl rdx, 3", 10
db "    add rdx, rbx", 10
db "    mov [rdx+32], rax", 10
db "    add r10, 1", 10
db "    mov r11, 1", 10
db "    jmp .fw_next", 10
db ".fw_out:", 10
db "    test r11, r11", 10
db "    jnz .fw_done", 10
db "    cmp r12, 13", 10
db "    jb .fw_done", 10
db ".fw_next:", 10
db "    mov rax, [r9]", 10
db "    cmp rax, r9", 10
db "    jbe .fw_done", 10
db "    mov rdx, rax", 10
db "    sub rdx, r9", 10
db "    cmp rdx, 0x100000", 10
db "    jae .fw_done", 10
db "    mov r9, rax", 10
db "    jmp .fw_step", 10
db ".fw_done:", 10
db "    mov [rbx+24], r10", 10
db "    pop r12", 10
db "    pop r11", 10
db "    pop r10", 10
db "    pop r9", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rdx", 10
db "    pop rcx", 10
db "    ret", 10
; __trace_print(rcx = block): one line per address kept,
;   at NAME (FILE:LINE)  then  called from NAME (FILE:LINE)
; An address is looked up one byte back: a return address can be the first
; byte of the next statement. Callable at any stack alignment.
db "__trace_print:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    push r12", 10
db "    push r13", 10
db "    push r14", 10
db "    mov rax, rsp", 10
db "    sar rax, 4", 10
db "    shl rax, 4", 10
db "    mov rsp, rax", 10
db "    sub rsp, 32", 10
db "    mov rbx, rcx", 10
db "    xor r12, r12", 10
db ".tp_frame:", 10
db "    mov rax, [rbx+24]", 10
db "    cmp r12, rax", 10
db "    jae .tp_done", 10
db "    cmp r12, 8", 10
db "    jae .tp_done", 10
db "    mov rax, r12", 10
db "    shl rax, 3", 10
db "    add rax, rbx", 10
db "    mov r13, [rax+32]", 10
db "    sub r13, 1", 10
db "    lea rax, [rel __kron_trace]", 10
db "    mov rsi, [rax]", 10
db ".tp_rec:", 10
db "    test rsi, rsi", 10
db "    jz .tp_next", 10
db "    mov rax, [rsi+40]", 10
db "    cmp r13, rax", 10
db "    jb .tp_other", 10
db "    mov rax, [rsi+8]", 10
db "    cmp r13, rax", 10
db "    jb .tp_found", 10
db ".tp_other:", 10
db "    mov rsi, [rsi]", 10
db "    jmp .tp_rec", 10
db ".tp_found:", 10
db "    mov rcx, [rsi+32]", 10
db "    mov rdi, rsi", 10
db "    add rdi, 40", 10
db "    xor r14, r14", 10
db ".tp_ent:", 10
db "    test rcx, rcx", 10
db "    jz .tp_line", 10
db "    mov rax, [rdi]", 10
db "    cmp rax, r13", 10
db "    ja .tp_line", 10
db "    mov r14, [rdi+8]", 10
db "    add rdi, 16", 10
db "    sub rcx, 1", 10
db "    jmp .tp_ent", 10
db ".tp_line:", 10
db "    lea rcx, [rel __tp_from]", 10
db "    test r12, r12", 10
db "    jnz .tp_word", 10
db "    lea rcx, [rel __tp_at]", 10
db ".tp_word:", 10
db "    call __print_str", 10
db "    mov rcx, [rsi+16]", 10
db "    call __print_str", 10
db "    lea rcx, [rel __tp_open]", 10
db "    call __print_str", 10
db "    mov rcx, [rsi+24]", 10
db "    call __print_str", 10
db "    lea rcx, [rel __tp_colon]", 10
db "    call __print_str", 10
db "    mov rcx, r14", 10
db "    call __print_uint", 10
db "    lea rcx, [rel __tp_close]", 10
db "    call __print_str", 10
db "    lea rcx, [rel __pf_nl]", 10
db "    call __print_str", 10
db ".tp_next:", 10
db "    add r12, 1", 10
db "    jmp .tp_frame", 10
db ".tp_done:", 10
db "    mov rsp, rbp", 10
db "    sub rsp, 48", 10
db "    pop r14", 10
db "    pop r13", 10
db "    pop r12", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    pop rbp", 10
db "    ret", 10
hdrtrace_len equ $ - hdrtrace


; ---- instruction fragments ----
s_pushrbp:   db "    push rbp", 10, 0
s_movrbp:    db "    mov rbp, rsp", 10, 0
s_subrsp:    db "    sub rsp, ", 0
s_movrsprbp: db "    mov rsp, rbp", 10, 0
s_poprbp:    db "    pop rbp", 10, 0
s_ret:       db "    ret", 10, 0
s_nl:        db 10, 0
s_colon_nl:  db ":", 10, 0
s_global_kw: db "global ", 0
s_colon:     db ":", 0
s_boot_pref: db "__boot_", 0
s_mov_ind:   db "    mov ", 0
s_comma_sp:  db ", ", 0
s_mov_rax:   db "    mov rax, ", 0
s_comma_rax: db ", rax", 10, 0
s_ret_ind:   db "    ret", 10, 0
s_mmu_pref:  db "__mmu_", 0
s_mmu_lv:    db "_levels", 0
s_isr_pref:  db "__isr_", 0
s_isrvec_pref: db "__isrvec_", 0
s_iretq:     db "    iretq", 10, 0
s_cfg_pref:  db "__cfg_", 0
s_cfg_k:     db "__cfgk", 0
s_cfg_v:     db "__cfgv", 0
s_cfg_keys:  db "_keys", 0
s_cfg_txts:  db "_texts", 0
s_cfg_nums:  db "_nums", 0
s_cfg_type:  db "_type", 0
s_sched_pref: db "__sched_", 0
s_sched_sw:  db "_switch", 0
s_sys_pref:  db "__sys_", 0
s_svc_pref:  db "__svc_", 0
s_sys_tbl:   db "_table", 0
s_sysretq:   db "    o64 sysret", 10, 0
s_ind4:      db "    ", 0
s_push_rax:  db "    push rax", 10, 0
s_outb_seq:  db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov al, cl", 10, "    out dx, al", 10, 0
s_inb_seq:   db "    mov rdx, rax", 10, "    xor rax, rax", 10, "    in al, dx", 10, 0
s_poke_seq:  db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], rcx", 10, 0
s_th_start:  db "    mov rdx, rax", 10, "    pop rcx", 10, "    sub rsp, 32", 10, "    call __thread_start", 10, "    add rsp, 32", 10, 0
s_th_wait:   db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __thread_wait", 10, "    add rsp, 32", 10, 0
s_lk_init:   db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __lock_init", 10, "    add rsp, 32", 10, 0
s_lk_take:   db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __lock_take", 10, "    add rsp, 32", 10, 0
s_lk_give:   db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __lock_give", 10, "    add rsp, 32", 10, 0
s_cpu_count: db "    sub rsp, 32", 10, "    call __cpu_count", 10, "    add rsp, 32", 10, 0
s_arg_count: db "    sub rsp, 32", 10, "    call __arg_count", 10, "    add rsp, 32", 10, 0
s_arg_get:   db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __arg_get", 10, "    add rsp, 32", 10, 0
s_no_syscall: db "    sub rsp, 32", 10, "    call __no_syscall", 10, "    add rsp, 32", 10, 0
s_target_win:   db "    mov rax, 1", 10, 0
s_target_linux: db "    mov rax, 2", 10, 0
s_target_krn:   db "    mov rax, 3", 10, 0
s_target_bare:  db "    mov rax, 4", 10, 0
s_ticks:     db "    sub rsp, 32", 10, "    call __ticks", 10, "    add rsp, 32", 10, 0
s_tickrate:  db "    sub rsp, 32", 10, "    call __ticks_per_sec", 10, "    add rsp, 32", 10, 0
s_load_seq:  db "    mov r8, rax", 10, "    pop rdx", 10, "    pop rcx", 10, "    sub rsp, 32", 10, "    call __load_file", 10, "    add rsp, 32", 10, 0
s_save_seq:  db "    mov rdx, rax", 10, "    pop rcx", 10, "    pop r8", 10, "    sub rsp, 32", 10, "    call __save_file", 10, "    add rsp, 32", 10, 0
s_readkey:   db "    sub rsp, 32", 10, "    call __read_key", 10, "    add rsp, 32", 10, 0
s_beep_seq:  db "    mov rdx, rax", 10, "    pop rcx", 10, "    sub rsp, 32", 10, "    call __beep", 10, "    add rsp, 32", 10, 0
s_readmouse: db "    sub rsp, 32", 10, "    call __read_mouse", 10, "    add rsp, 32", 10, 0
s_mousex:    db "    sub rsp, 32", 10, "    call __mousex_fn", 10, "    add rsp, 32", 10, 0
s_mousey:    db "    sub rsp, 32", 10, "    call __mousey_fn", 10, "    add rsp, 32", 10, 0
s_peek_seq:  db "    mov rax, [rax]", 10, 0
; read:  rax=index -> rax = [rbp - base + index*8]
s_idx_rcx:   db "    mov rcx, rax", 10, 0
s_idx_pop:   db "    pop rcx", 10, 0
s_lea_loc:   db "    lea rdx, [rbp-", 0
s_ld_loc:    db "    mov rdx, [rbp-", 0
s_lea_loc2:  db "]", 10, 0
s_lea_glbp:  db "    lea rdx, [rel __g_", 0
s_lea_glbs:  db "]", 10, 0
s_rd_i:      db "    mov rax, [rdx+rcx*8]", 10, 0
; arrays of narrower elements: one byte, two or four per element. A signed
; element is widened with a shift pair rather than movsx, which keeps to the
; instructions every assembler and translator here already knows.
s_rd_u1:     db "    movzx eax, byte [rdx+rcx]", 10, 0
s_rd_s1:     db "    movzx eax, byte [rdx+rcx]", 10, "    shl rax, 56", 10, "    sar rax, 56", 10, 0
s_rd_u2:     db "    movzx eax, word [rdx+rcx*2]", 10, 0
s_rd_s2:     db "    movzx eax, word [rdx+rcx*2]", 10, "    shl rax, 48", 10, "    sar rax, 48", 10, 0
s_rd_u4:     db "    mov eax, dword [rdx+rcx*4]", 10, 0
s_rd_s4:     db "    mov eax, dword [rdx+rcx*4]", 10, "    shl rax, 32", 10, "    sar rax, 32", 10, 0
s_wr_1:      db "    mov [rdx+rcx], al", 10, 0
s_wr_2:      db "    mov [rdx+rcx*2], ax", 10, 0
s_wr_4:      db "    mov [rdx+rcx*4], eax", 10, 0
s_rd_f4:     db "    movss xmm0, [rdx+rcx*4]", 10, "    cvtss2sd xmm0, xmm0", 10, 0
s_wr_f4:     db "    cvtsd2ss xmm0, xmm0", 10, "    movss [rdx+rcx*4], xmm0", 10, 0
s_cvt_d2s:   db "    cvtsd2ss xmm0, xmm0", 10, 0
s_cvt_s2d:   db "    cvtss2sd xmm0, xmm0", 10, 0
s_ld_ss_pre: db "    movss xmm0, [rbp-", 0
; a field of a struct global, reached through rdx (cg_member_global)
s_gld8:      db "    mov rax, [rdx]", 10, 0
s_gld4:      db "    mov eax, dword [rdx]", 10, 0
s_gld2:      db "    movzx eax, word [rdx]", 10, 0
s_gld1:      db "    movzx eax, byte [rdx]", 10, 0
s_gst8:      db "    mov [rdx], rax", 10, 0
s_gst4:      db "    mov [rdx], eax", 10, 0
s_gst2:      db "    mov [rdx], ax", 10, 0
s_gst1:      db "    mov [rdx], al", 10, 0
s_gldsd:     db "    movsd xmm0, [rdx]", 10, 0
s_gldss:     db "    movss xmm0, [rdx]", 10, "    cvtss2sd xmm0, xmm0", 10, 0
s_gstsd:     db "    movsd [rdx], xmm0", 10, 0
s_gstss:     db "    cvtsd2ss xmm0, xmm0", 10, "    movss [rdx], xmm0", 10, 0
s_sext1:     db "    shl rax, 56", 10, "    sar rax, 56", 10, 0
s_sext2:     db "    shl rax, 48", 10, "    sar rax, 48", 10, 0
s_sext4:     db "    shl rax, 32", 10, "    sar rax, 32", 10, 0
s_plus_n:    db "+", 0
s_st_ss_pre: db "    movss [rbp-", 0
s_addr_ldpre: db "    mov rax, [rbp-", 0
s_rd_f:      db "    movsd xmm0, [rdx+rcx*8]", 10, 0
s_wr_i:      db "    mov [rdx+rcx*8], rax", 10, 0
s_wr_f:      db "    movsd [rdx+rcx*8], xmm0", 10, 0
s_idx_pre:   db "    mov rcx, rax", 10, "    lea rdx, [rbp-", 0
s_idx_read:  db "]", 10, "    mov rax, [rdx+rcx*8]", 10, 0
s_idx_readf: db "]", 10, "    movsd xmm0, [rdx+rcx*8]", 10, 0
s_idx_wrf:   db "]", 10, "    movsd [rdx+rcx*8], xmm0", 10, 0
s_idx_wrf1:  db "    pop rcx", 10, "    lea rdx, [rbp-", 0
; write: stack=index, rax=value
s_idx_wr1:   db "    pop rcx", 10, "    lea rdx, [rbp-", 0
s_idx_wr2:   db "]", 10, "    mov [rdx+rcx*8], rax", 10, 0
s_addr_pre:  db "    lea rax, [rbp-", 0
s_addr_post: db "]", 10, 0
; '&name[i]': the base address plus the index scaled by the element width.
; The index is computed into rcx first, because working out the base is a
; single lea and would otherwise have to be redone.
s_addr_idx:  db "    push rax", 10, 0
s_addr_add:  db "    pop rcx", 10, "    add rax, rcx", 10, 0
s_addr_scale: db "    imul rax, rax, ", 0
; --- width-aware struct field access ---
s_ld1_pre:   db "    movzx rax, byte [rbp-", 0
s_ld2_pre:   db "    movzx rax, word [rbp-", 0
s_ld4_pre:   db "    mov eax, dword [rbp-", 0
s_ld8_pre:   db "    mov rax, [rbp-", 0
s_st1_suf:   db "], al", 10, 0
s_st2_suf:   db "], ax", 10, 0
s_st4_suf:   db "], eax", 10, 0
s_st8_suf:   db "], rax", 10, 0
s_imul_pre:  db "    imul rax, rax, ", 0
; --- floating point (SSE) ---
s_flt_lbl:   db ".flt", 0         ; LOCAL label: does not break NASM's .L chain
s_flt_dq:    db ": dq ", 0
s_point_zero: db ".0", 0
s_ld_flt:    db "    movsd xmm0, [rel .flt", 0
s_closebrk:  db "]", 10, 0
s_kt_kl:     db ".kl", 0
; --- text, list<T>, map<T> ---------------------------------------------------
; The library functions the built-in types turn into, as tokens: a call to
; one goes through the same path as a call written in the source.
tk_text: dq TOK_IDENT, nm_tk_text
    dd 4
    dw 0, 0
nm_tk_text: db "text"
tk_text_add: dq TOK_IDENT, nm_tk_text_add
    dd 8
    dw 0, 0
nm_tk_text_add: db "text_add"
tk_text_add_int: dq TOK_IDENT, nm_tk_text_add_int
    dd 12
    dw 0, 0
nm_tk_text_add_int: db "text_add_int"
tk_text_add_real: dq TOK_IDENT, nm_tk_text_add_real
    dd 13
    dw 0, 0
nm_tk_text_add_real: db "text_add_real"
tk_text_same: dq TOK_IDENT, nm_tk_text_same
    dd 9
    dw 0, 0
nm_tk_text_same: db "text_same"
tk_say: dq TOK_IDENT, nm_tk_say
    dd 3
    dw 0, 0
nm_tk_say: db "say"
tk_list_new: dq TOK_IDENT, nm_tk_list_new
    dd 8
    dw 0, 0
nm_tk_list_new: db "list_new"
tk_map_new: dq TOK_IDENT, nm_tk_map_new
    dd 7
    dw 0, 0
nm_tk_map_new: db "map_new"
tk_list_add: dq TOK_IDENT, nm_tk_list_add
    dd 8
    dw 0, 0
nm_tk_list_add: db "list_add"
tk_list_add_real: dq TOK_IDENT, nm_tk_list_add_real
    dd 13
    dw 0, 0
nm_tk_list_add_real: db "list_add_real"
tk_list_show: dq TOK_IDENT, nm_tk_list_show
    dd 9
    dw 0, 0
nm_tk_list_show: db "list_show"
tk_map_show: dq TOK_IDENT, nm_tk_map_show
    dd 8
    dw 0, 0
nm_tk_map_show: db "map_show"
s_rdx_rax:     db "    mov rdx, rax", 10, 0
tk_vec4_load: dq TOK_IDENT, nm_tk_vec4_load
    dd 9
    dw 0, 0
nm_tk_vec4_load: db "vec4_load"
tk_vec4_store: dq TOK_IDENT, nm_tk_vec4_store
    dd 10
    dw 0, 0
nm_tk_vec4_store: db "vec4_store"
tk_vec4_add: dq TOK_IDENT, nm_tk_vec4_add
    dd 8
    dw 0, 0
nm_tk_vec4_add: db "vec4_add"
tk_vec4_sub: dq TOK_IDENT, nm_tk_vec4_sub
    dd 8
    dw 0, 0
nm_tk_vec4_sub: db "vec4_sub"
tk_vec4_mul: dq TOK_IDENT, nm_tk_vec4_mul
    dd 8
    dw 0, 0
nm_tk_vec4_mul: db "vec4_mul"
tk_vec4_div: dq TOK_IDENT, nm_tk_vec4_div
    dd 8
    dw 0, 0
nm_tk_vec4_div: db "vec4_div"
tk_vec4_sum: dq TOK_IDENT, nm_tk_vec4_sum
    dd 8
    dw 0, 0
nm_tk_vec4_sum: db "vec4_sum"
tk_vec4_fill: dq TOK_IDENT, nm_tk_vec4_fill
    dd 9
    dw 0, 0
nm_tk_vec4_fill: db "vec4_fill"
tk_vec2_div: dq TOK_IDENT, nm_tk_vec2_div
    dd 8
    dw 0, 0
nm_tk_vec2_div: db "vec2_div"
in_toks:       dq tk_vec4_load, tk_vec4_store, tk_vec4_add, tk_vec4_sub
               dq tk_vec4_mul, tk_vec4_div, tk_vec4_sum, tk_vec4_fill, tk_vec2_div
in_ops:        dq 0, 0, s_v4_add, s_v4_sub, s_v4_mul, s_v4_div, 0, 0, s_v2_div
s_v4_load:     db "    movups xmm0, [rax]", 10, 0
s_v4_store1:   db "    movups [rax], xmm1", 10, 0
s_v4_spill:    db "    sub rsp, 16", 10, "    movups [rsp], xmm0", 10, 0
s_v4_fill:     db "    movups xmm1, [rsp]", 10, "    add rsp, 16", 10, 0
s_v4_add:      db "    addps xmm1, xmm0", 10, "    movaps xmm0, xmm1", 10, 0
s_v4_sub:      db "    subps xmm1, xmm0", 10, "    movaps xmm0, xmm1", 10, 0
s_v4_mul:      db "    mulps xmm1, xmm0", 10, "    movaps xmm0, xmm1", 10, 0
s_v4_div:      db "    divps xmm1, xmm0", 10, "    movaps xmm0, xmm1", 10, 0
s_v2_div:      db "    divpd xmm1, xmm0", 10, "    movaps xmm0, xmm1", 10, 0
s_v4_sum:      db "    sub rsp, 16", 10, "    movups [rsp], xmm0", 10, "    mov rax, rsp", 10
               db "    movss xmm0, [rax]", 10, "    cvtss2sd xmm0, xmm0", 10
               db "    add rax, 4", 10, "    movss xmm1, [rax]", 10, "    cvtss2sd xmm1, xmm1", 10, "    addsd xmm0, xmm1", 10
               db "    add rax, 4", 10, "    movss xmm1, [rax]", 10, "    cvtss2sd xmm1, xmm1", 10, "    addsd xmm0, xmm1", 10
               db "    add rax, 4", 10, "    movss xmm1, [rax]", 10, "    cvtss2sd xmm1, xmm1", 10, "    addsd xmm0, xmm1", 10
               db "    add rsp, 16", 10, 0
s_v4_fillx:    db "    cvtsd2ss xmm0, xmm0", 10, "    sub rsp, 16", 10, "    mov rax, rsp", 10
               db "    movss [rax], xmm0", 10, "    add rax, 4", 10, "    movss [rax], xmm0", 10
               db "    add rax, 4", 10, "    movss [rax], xmm0", 10, "    add rax, 4", 10, "    movss [rax], xmm0", 10
               db "    movups xmm0, [rsp]", 10, "    add rsp, 16", 10, 0
s_lea_fnrec:   db "    lea rax, [rel __fnrec_", 0
s_fnrec:       db "__fnrec_", 0
s_fnrec_dq:    db ": dq ", 0
s_sec_data_nl: db "section .data", 10, 0
s_sec_text_nl: db "section .text", 10, 0
s_r11_ld:      db "    mov r11, [rbp-", 0
s_r11_ldg:     db "    mov r11, [rel __g_", 0
s_r11_call:    db "    mov r11, [r11]", 10, "    call r11", 10, 0
s_rbr_nl:      db "]", 10, 0
s_clo_size:    db "    mov rcx, ", 0
s_clo_call:    db "    sub rsp, 32", 10, "    call __clo_alloc", 10, "    add rsp, 32", 10, 0
s_clo_code:    db "    lea rdx, [rel ", 0
s_clo_code2:   db "]", 10, "    mov [rax], rdx", 10, "    push rax", 10, 0
s_clo_put:     db "    pop rax", 10, "    pop rcx", 10, "    push rcx", 10, "    mov [rcx+", 0
s_clo_put2:    db "], rax", 10, 0
s_env_get:     db "    mov rax, [rax+", 0
s_err_nofn:    db "unknown function ", 0
s_err_lamfull: db "too many fn values, or one keeping too many names (16) ", 0
tk_env: dq TOK_IDENT, nm_tk_env
    dd 5
    dw 0, 0
nm_tk_env: db "__env"
s_bits_xmm0:   db "    push rax", 10, "    movsd xmm0, [rsp]", 10, "    add rsp, 8", 10, 0
s_push_rdx:    db "    push rdx", 10, 0
s_push_r8:     db "    push r8", 10, 0
s_push_r9:     db "    push r9", 10, 0
s_pop_rcx_keep: db "    pop rcx", 10, "    push rcx", 10, 0
s_pop_rcx:     db "    pop rcx", 10, 0
s_xor_rax1:    db "    xor rax, 1", 10, 0
s_xmm1_xmm0:   db "    movaps xmm1, xmm0", 10, 0
s_r8_six:      db "    mov r8, -1", 10, 0          ; as few decimals as needed
s_rdx_imm:     db "    mov rdx, ", 0
s_err_lshow:   db "printing a list needs std_text.kr, which is not imported ", 0
s_hint_lshow:  db "  hint: add  acquire_domain ", 34, "std_text.kr", 34, ";  to the header", 13, 10, 0
s_kt_lea:    db "    lea r8, [rel .kx", 0
s_kt_call:   db "]", 10, "    call __fail_raise", 10, ".kx", 0
s_kt_main:   db "main", 0
s_kt_kft:    db ".kft", 0
s_kt_head:   db ".kfe:", 10, "section .data", 10, ".kft: dq ", 0
s_kt_mid:    db ", .kfe, .kfn, __kron_file_", 0
s_kt_ent:    db "    dq .kl", 0
s_kt_name:   db ".kfn: db ", 34, 0
s_kt_name2:  db 34, ", 0", 10, "section .text", 10, 0
s_kt_lo:     db "section .text", 10, "__kron_lo:", 10, 0
s_kt_hi:     db "section .text", 10, "__kron_hi:", 10, "section .data", 10, "__kron_trace: dq ", 0
s_kt_file:   db "__kron_file_", 0
s_kt_db:     db ": db ", 0
s_kt_text:   db "section .text", 10, 0
s_str_lbl:   db ".str", 0        ; LOCAL label, like .flt
s_str_db:    db ": db ", 0
s_str_cont:  db 10, "    db ", 0
s_str_zero:  db "0", 10, 0       ; null terminator
s_comma:     db ",", 0
s_lea_str:   db "    lea rax, [rel .str", 0
s_fail_set:  db 0                ; the flag is set inside __fail_raise
s_st_failmsg:  db "    push rax", 10, 0          ; park the cause
s_st_failhint: db "    mov rdx, rax", 10, "    pop rcx", 10, "    sub rsp, 32", 10, 0
s_zero_rax:    db "    xor rax, rax", 10, 0
s_bnd_cmp:     db "    cmp rax, ", 0
s_bnd_fail:    db "    lea rcx, [rel __bounds_msg]", 10
               db "    lea rdx, [rel __bounds_hint]", 10
               db "    sub rsp, 32", 10, 0
s_bnd_fail2:   db "    add rsp, 32", 10
               db "    xor rax, rax", 10, 0
; --- SIMD: four floats at a time -------------------------------------------
; Two f64 at a time. Kron does all floating point in double precision,
; so the packed ops are the pd family: addps on a pair of doubles would
; read them as four floats and return rubbish.
; The value lives in xmm0. There is no push for an xmm register, so the left
; operand is parked in eight bytes of stack while the right one is computed.
s_v2_load:     db "    movupd xmm0, [rax]", 10, 0
s_v2_store1:   db "    movupd [rax], xmm1", 10, 0
s_v2_spill:    db "    sub rsp, 16", 10, "    movupd [rsp], xmm0", 10, 0
s_v2_fill:     db "    movupd xmm1, [rsp]", 10, "    add rsp, 16", 10, 0
s_v2_add:      db "    addpd xmm1, xmm0", 10, "    movupd xmm0, xmm1", 10, 0
s_v2_sub:      db "    subpd xmm1, xmm0", 10, "    movupd xmm0, xmm1", 10, 0
s_v2_mul:      db "    mulpd xmm1, xmm0", 10, "    movupd xmm0, xmm1", 10, 0
s_fail_nohnt: db "    xor rdx, rdx", 10, "    pop rcx", 10, "    sub rsp, 32", 10, 0
s_fail_after: db "    add rsp, 32", 10, 0
s_failed_rd: db "    sub rsp, 32", 10, "    call __fail_take", 10, "    add rsp, 32", 10, 0
s_rt_init:   db "    sub rsp, 32", 10, "    call __rt_init", 10, "    add rsp, 32", 10, 0
s_yield:     db "    sub rsp, 32", 10, "    call __thread_yield", 10, "    add rsp, 32", 10, 0
s_dll_load:  db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __dll_load", 10, "    add rsp, 32", 10, 0
s_dll_proc:  db "    mov rdx, rax", 10, "    pop rcx", 10, "    sub rsp, 32", 10, "    call __dll_proc", 10, "    add rsp, 32", 10, 0
s_pfail:     db "    sub rsp, 32", 10, "    call __print_fail", 10, "    add rsp, 32", 10, 0
s_prints:    db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __print_str", 10, "    add rsp, 32", 10, 0
s_ld_xmm_pre: db "    movsd xmm0, [rbp-", 0
s_st_xmm_pre: db "    movsd [rbp-", 0
s_st_xmm_suf: db "], xmm0", 10, 0
s_push_xmm:  db "    sub rsp, 8", 10, "    movsd [rsp], xmm0", 10, 0
s_pop_xmm1:  db "    movaps xmm1, xmm0", 10, "    movsd xmm0, [rsp]", 10, "    add rsp, 8", 10, 0
s_addsd:     db "    addsd xmm0, xmm1", 10, 0
s_subsd:     db "    subsd xmm0, xmm1", 10, 0
s_mulsd:     db "    mulsd xmm0, xmm1", 10, 0
s_divsd:     db "    divsd xmm0, xmm1", 10, 0
s_cvt_i2d:   db "    cvtsi2sd xmm0, rax", 10, 0
s_fneg:      db "    movaps xmm1, xmm0", 10, "    xorps xmm0, xmm0", 10, "    subsd xmm0, xmm1", 10, 0
s_cvt_d2i:   db "    cvttsd2si rax, xmm0", 10, 0
s_nar_u8:    db "    and rax, 255", 10, 0
s_nar_u16:   db "    and rax, 65535", 10, 0
s_nar_u32:   db "    mov eax, eax", 10, 0
s_nar_i8:    db "    shl rax, 56", 10, "    sar rax, 56", 10, 0
s_nar_i16:   db "    shl rax, 48", 10, "    sar rax, 48", 10, 0
s_nar_i32:   db "    shl rax, 32", 10, "    sar rax, 32", 10, 0
s_zero_xmm:  db "    xorps xmm0, xmm0", 10, 0
s_printf:    db "    call __print_float", 10, 0
; --- file-scope globals ---
s_glb_pre:   db "__g_", 0
s_glb_times: db ": times ", 0
s_glb_dq0:   db " dq 0", 10, 0
s_lea_glb:   db "    lea rax, [rel __g_", 0
s_lea_fn:    db "    lea rax, [rel ", 0
s_ldgf_pre:  db "    movsd xmm0, [rel __g_", 0
s_stgf_pre:  db "    movsd [rel __g_", 0
s_stgf_suf:  db "], xmm0", 10, 0
s_ldg_pre:   db "    mov rax, [rel __g_", 0
s_stg_pre:   db "    mov [rel __g_", 0
s_stg_suf:   db "], rax", 10, 0
; --- calling convention fragments ---
s_dbg_oom:  db "[DBG] OOM emit_bytes", 10, 0
s_dbg_full: db "[DBG] FULL cg_add_var", 10, 0
s_movmem_pre: db "    mov [rbp-", 0
s_movmemq_pre: db "    mov qword [rbp-", 0
s_movmem_mid: db "], ", 0
s_argreg0:   db "rcx", 0
s_argreg1:   db "rdx", 0
s_argreg2:   db "r8", 0
s_argreg3:   db "r9", 0
s_fmovmem:   db "    movsd [rbp-", 0
s_fmovmid:   db "], xmm", 0
s_fargreg0:  db "xmm0", 0
s_fargreg1:  db "xmm1", 0
s_fargreg2:  db "xmm2", 0
s_fargreg3:  db "xmm3", 0
s_fpush:     db "    sub rsp, 8", 10, "    movsd [rsp], xmm0", 10, 0
s_fpop_pre:  db "    movsd xmm", 0
s_fpop_suf:  db ", [rsp]", 10, "    add rsp, 8", 10, 0
s_poparg0:   db "    pop rcx", 10, 0
s_poparg1:   db "    pop rdx", 10, 0
s_poparg2:   db "    pop r8", 10, 0
s_poparg3:   db "    pop r9", 10, 0
s_poparg4:   db "    pop r10", 10, 0
s_poparg5:   db "    pop rax", 10, 0
s_argreg4:   db "r10", 0
s_argreg5:   db "rax", 0
s_ld_r11_pre: db "    mov r11, [", 0
s_plus_sp:    db " + ", 0
s_rbrack_nl:  db "]", 10, 0
s_r11:        db "r11", 0
s_lea_rax_pre: db "    lea rax, [rbp-", 0
s_ld_rax_pre:  db "    mov rax, [rbp-", 0

; --- built-in 'stream' struct: { ptr: u64, len: u64 } --------------------
; Registered straight into the struct tables at init, so a string is a pair
; and everything already built for structs -- two slots in the frame, field
; access, by-value passing -- works on it without a line of new machinery.
; The address field is called 'bytes', not 'ptr': 'ptr' is already a keyword
; of the language -- the one in ptr<T> -- so 'x.ptr' lexes as KW_PTR and the
; parser rejects it. 'bytes' also says what is actually there: bytes, not
; characters.
str_name_stream: db "stream", 0
str_name_bytes:  db "bytes", 0
str_name_len:    db "len", 0
tok_stream:      dq 0, str_name_stream, 6, 0
tok_sptr:        dq 0, str_name_bytes,  5, 0
tok_slen:        dq 0, str_name_len,    3, 0
s_lea_rax_suf: db "]", 10, 0
s_fargreg4:  db "xmm4", 0
s_fargreg5:  db "xmm5", 0
s_shadow_sub: db "    sub rsp, 32", 10, 0
; Arguments past the sixth travel on the stack. The callee's frame is
;   [rbp]      saved rbp
;   [rbp+8]    return address
;   [rbp+16]   32 bytes of shadow space
;   [rbp+48]   the seventh argument, then the eighth, and so on
s_addrsp_pre: db "    add rsp, ", 0
s_ld_stkarg:  db "    mov rax, [rbp+", 0
s_ld_stkarg2: db "]", 10, 0
s_shadow_add: db "    add rsp, 32", 10, 0
s_pop_r11:    db "    pop r11", 10, 0
s_call_r11:   db "    call r11", 10, 0
s_ci_align:   db "    mov rax, rsp", 10, "    and rsp, -16", 10, "    sub rsp, 8", 10, "    push rax", 10, 0
s_ci_unalign: db "    pop rsp", 10, 0
s_ci_ldr10:   db "    mov r10, [rax+", 0
s_ci_strsp:   db "    mov [rsp+", 0
s_ci_r10:     db "], r10", 10, 0
s_ci_ldrcx:   db "    mov rcx, [rax+", 0
s_ci_ldrdx:   db "    mov rdx, [rax+", 0
s_ci_ldr8:    db "    mov r8, [rax+", 0
s_ci_ldr9:    db "    mov r9, [rax+", 0
s_ci_ldr11:   db "    mov r11, [rax+", 0
s_poke8_seq:  db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], cl", 10, 0
s_poke16_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], cx", 10, 0
s_poke32_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], ecx", 10, 0
s_peek8_seq:  db "    movzx rax, byte [rax]", 10, 0
s_peek16_seq: db "    movzx rax, word [rax]", 10, 0
s_peek32_seq: db "    mov eax, dword [rax]", 10, 0
s_underscore: db "_", 0
s_isa_str:   db "__isa_s", 0
s_isa_pref:  db "__isa_", 0
s_isa_cnt:   db "_count", 0
s_isa_ops:   db "_opcodes", 0
s_isa_nms:   db "_names", 0
s_dq_ind:    db "    dq ", 0
s_dq_sp:     db " dq ", 0
s_movrax_imm: db "    mov rax, ", 0
s_imul_rax_pre: db "    imul rax, rax, ", 0
s_add_rax_pop:  db "    pop rcx", 10, "    add rax, rcx", 10, 0
s_pushrax:   db "    push rax", 10, 0
s_poprax:    db "    pop rax", 10, 0
s_movrcxrax: db "    mov rcx, rax", 10, 0
s_movraxmem: db "    mov rax, [rbp-", 0
s_closemem:  db "]", 10, 0
s_movmemrax: db "    mov [rbp-", 0
s_movmemrax2: db "], rax", 10, 0
s_add:       db "    add rax, rcx", 10, 0
s_sub:       db "    sub rax, rcx", 10, 0
s_imul:      db "    imul rax, rcx", 10, 0
s_idiv:      db "    cqo", 10, "    idiv rcx", 10, 0
s_udiv:      db "    xor rdx, rdx", 10, "    div rcx", 10, 0
s_umod:      db "    xor rdx, rdx", 10, "    div rcx", 10, "    mov rax, rdx", 10, 0
s_setb:      db "    setb al", 10, "    movzx rax, al", 10, 0
s_seta:      db "    seta al", 10, "    movzx rax, al", 10, 0
s_setbe:     db "    setbe al", 10, "    movzx rax, al", 10, 0
s_setae:     db "    setae al", 10, "    movzx rax, al", 10, 0
s_imod:      db "    cqo", 10, "    idiv rcx", 10, "    mov rax, rdx", 10, 0
s_shl:       db "    shl rax, cl", 10, 0
s_shr:       db "    sar rax, cl", 10, 0
s_ushr:      db "    shr rax, cl", 10, 0
s_xor:       db "    xor rax, rcx", 10, 0
s_band:      db "    and rax, rcx", 10, 0
s_bor:       db "    or rax, rcx", 10, 0
s_rotl:      db "    rol rax, cl", 10, 0
s_rotr:      db "    ror rax, cl", 10, 0
s_clflush:   db "    clflush [rax]", 10, 0
s_prefetch0: db "    prefetcht0 [rax]", 10, 0
s_neg:       db "    neg rax", 10, 0
s_bnot:      db "    not rax", 10, 0
s_lnot:      db "    test rax, rax", 10, "    sete al", 10, "    movzx rax, al", 10, 0
s_cmp:       db "    cmp rax, rcx", 10, 0
s_sete:      db "    sete al", 10, "    movzx rax, al", 10, 0
s_setne:     db "    setne al", 10, "    movzx rax, al", 10, 0
s_setl:      db "    setl al", 10, "    movzx rax, al", 10, 0
s_setg:      db "    setg al", 10, "    movzx rax, al", 10, 0
s_setle:     db "    setle al", 10, "    movzx rax, al", 10, 0
s_setge:     db "    setge al", 10, "    movzx rax, al", 10, 0
s_fcmp:      db "    ucomisd xmm0, xmm1", 10, 0
s_fseta:     db "    seta al", 10, "    movzx rax, al", 10, 0
s_fsetae:    db "    setae al", 10, "    movzx rax, al", 10, 0
s_fsetb:     db "    setb al", 10, "    movzx rax, al", 10, 0
s_fsetbe:    db "    setbe al", 10, "    movzx rax, al", 10, 0
s_fsete:     db "    sete al", 10, "    movzx rax, al", 10, 0
s_fsetne:    db "    setne al", 10, "    movzx rax, al", 10, 0
s_print:     db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __print_int", 10, "    add rsp, 32", 10, 0
s_printc:    db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __print_char", 10, "    add rsp, 32", 10, 0
s_trunc:     db "    cvttsd2si rax, xmm0", 10, 0
s_call:      db "    call ", 0
s_jmp:       db "    jmp ", 0
s_jz:        db "    test rax, rax", 10, "    jz ", 0
s_jnz:       db "    test rax, rax", 10, "    jnz ", 0
s_setnz01:   db "    test rax, rax", 10, "    setnz al", 10, "    movzx rax, al", 10, 0
s_mov_rax0:  db "    mov rax, 0", 10, 0
s_mov_rax1:  db "    mov rax, 1", 10, 0
s_label_L:   db ".L", 0        ; local to the enclosing function, so it does not reset NASM label scope
s_retmain:   db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __main_exit", 10, 0
s_retlbl:    db ".__ret_", 0
s_jmpret:    db "    jmp .__ret_", 0
; --- emitting TITAN modules as real data ---
s_sec_data:  db "section .data", 10, 0
s_sec_bss:   db "section .bss", 10, 0
s_glb_resq:  db ": resq ", 0
s_sec_text:  db "section .text", 10, 0
s_mod_pref:  db "__mod_", 0
s_mod_anon:  db "anon", 0
s_us:        db "_", 0
s_db_q:      db "    db ", 34, 0          ; '    db "'
s_q0_nl:     db 34, ",0", 10, 0           ; '",0'
s_zero:      db "0", 0
s_syscall:   db "    syscall", 10, 0
s_pop_rax:   db "    pop rax", 10, 0
s_pop_rdi:   db "    pop rdi", 10, 0
s_pop_rsi:   db "    pop rsi", 10, 0
s_pop_rdx:   db "    pop rdx", 10, 0
s_pop_r10:   db "    pop r10", 10, 0
s_pop_r8:    db "    pop r8", 10, 0
s_pop_r9:    db "    pop r9", 10, 0

KT_MAX_FILES equ 128
CG_POOL_NODES equ 16384
LQ_MAX       equ 1024
LQ_CAPS      equ 16
FNVAL_MARK   equ 0x464E56          ; AST.owner_type of a call through a value
KT_MAX_MARKS equ 65536
extern lmap_lookup

section .bss
    cg_out       resq 1
    cg_ptr       resq 1
    ; --- intermediate representation --------------------------------------
    ; While a function is being generated, output goes here instead of
    ; straight to cg_ptr, and is written out when the function ends. That is
    ; what makes whole-function analysis possible: register allocation has to
    ; see every use of a value before it can decide where the value lives.
    ;
    ; A record is 16 bytes:  +0 kind (dword)  +4 length (dword)  +8 offset
    ; into ir_text (qword). Today every record is IR_RAW -- text taken as is
    ; -- so the output is byte for byte what it was. Loads and stores of
    ; locals become structured records in the next step.
    ir_on        resd 1
    ; --- register allocation: analysis state (phase 2) ----------------------
    ; Rebuilt for every function. Candidates are locals reached only through
    ; IR_LDLOC and IR_STLOC; at most 64, so a set of them is one qword.
    ra_asm       resd 1          ; function contains inline asm
    ra_skip      resd 1          ; function cannot be allocated
    ra_ncand     resd 1
    ra_cand      resq RA_MAXCAND ; frame offset of each candidate
    ra_bits      resq 64         ; 1 << i, built once, no variable shifts
    ra_exmask    resq 1          ; candidates excluded: seen in raw text
    ra_gen       resd 1          ; bumps per function; stamps the label map
    ra_tblk      resd 1          ; trace: next block header to write
    ra_nframe    resd 1          ; IR_FRAME records seen: must be exactly one
    ra_nret      resd 1          ; IR_RETLBL records seen: must be exactly one
    ra_active    resd 1          ; the flush is applying an allocation
    ra_wt        resd RA_MAXCAND ; how often each candidate is touched
    ra_adj       resq RA_MAXCAND ; conflict graph: one qword of neighbours each
    ra_color     resd RA_MAXCAND ; register 0..4, or -1 = stays in memory
    ra_stk       resd RA_MAXCAND ; simplify order
    ra_used      resd 1          ; bit per register actually handed out
    ra_fused     resd 1          ; the same for xmm6..xmm15
    ra_imask     resq 1          ; candidates touched by integer records
    ra_fmask     resq 1          ; candidates touched by float records
    ra_frame     resq 1          ; original frame size
    ra_grow      resq 1          ; bytes added to it for the save area
    ra_nblk      resd 1
    ra_cur       resd 1          ; block being built, or -1
    ra_retblk    resd 1          ; block holding the return label, or -1
    ra_bstart    resd RA_MAXBLK
    ra_bend      resd RA_MAXBLK
    ra_succ1     resd RA_MAXBLK
    ra_succ2     resd RA_MAXBLK
    ra_use       resq RA_MAXBLK
    ra_def       resq RA_MAXBLK
    ra_in        resq RA_MAXBLK
    ra_out       resq RA_MAXBLK
    ra_lblblk    resd RA_MAXLBL  ; label id -> block, valid if the stamp matches
    ra_lblgen    resd RA_MAXLBL
    ir_count     resd 1
    ir_text_len  resq 1
    ir_recs      resb IR_MAX_RECS * 16
    ir_text      resb IR_TEXT_SIZE
    cg_end       resq 1
    cg_label     resd 1
    dbg_which    resb 1
    cg_had_error resb 1
    cg_pad_guard resb 64
    ; local variable table of the current function
    var_toks     resq CG_MAX_VARS      ; pointers to name tokens
    var_offs     resd CG_MAX_VARS      ; offset magnitude (8,16,...)
    cg_bare      resb 1
    cg_target    resb 1
    ; --- struct registry ---
    struct_toks    resq CG_MAX_STRUCTS ; struct name token per struct
    struct_first   resd CG_MAX_STRUCTS ; index of its first field in field_toks
    struct_nfield  resd CG_MAX_STRUCTS ; field count
    ; enums: members are compile-time integers, resolved wherever they are
    ; written as Name.Member
    enum_toks      resq CG_MAX_STRUCTS ; enum name token
    enum_first     resd CG_MAX_STRUCTS ; index of its first member
    enum_nmem      resd CG_MAX_STRUCTS ; member count
    enum_count     resd 1
    emem_toks      resq CG_MAX_FIELDS  ; flat list of member names
    emem_vals      resq CG_MAX_FIELDS  ; their values
    emem_count     resd 1
    struct_count   resd 1
    field_toks     resq CG_MAX_FIELDS  ; flat list of field name tokens
    field_sizes    resd CG_MAX_FIELDS  ; byte width of each field
    field_isfloat  resd CG_MAX_FIELDS  ; 1 when the field type is real32/real64
    field_unsigned resd CG_MAX_FIELDS  ; 1 when the field type is u8..u64
    field_vtag     resd CG_MAX_FIELDS  ; type tag: text, list<T>, map<T>
    field_offs     resd CG_MAX_FIELDS  ; byte offset of each field inside its struct
    field_struct   resd CG_MAX_FIELDS  ; struct id when the field IS a struct, else -1
    struct_bytes   resd CG_MAX_STRUCTS ; total packed size of each struct
    field_count    resd 1
    stream_struct_id resd 1   ; always 0; named for the reader
    last_strlit_len  resd 1   ; byte count of the last string literal emitted,
                              ; escapes already resolved. Read immediately
                              ; after the cg_emit that produced it.
    var_structs    resd CG_MAX_VARS    ; struct id per variable (-1 = none)
    var_elemsz     resd CG_MAX_VARS    ; pointer element width per variable (0 = not a pointer)
    var_isfloat    resd CG_MAX_VARS    ; 1 when the variable holds a double
    var_unsigned   resd CG_MAX_VARS    ; 1 when the variable's type is u8..u64
    var_isref      resd CG_MAX_VARS    ; 1 when the slot holds an ADDRESS, not the data
    var_arrlen     resd CG_MAX_VARS    ; element count, 0 when not an array
    var_stride     resd CG_MAX_VARS    ; elements per row of a 2-D array, 0 flat
    var_aw         resd CG_MAX_VARS    ; bytes per array element (1, 2, 4, 8), 0 = 8
    pending_aw     resd 1
    var_vtag       resd CG_MAX_VARS    ; type tag: bits 0-3 1 text, 2 list,
                                       ; 3 map; bits 4-7 the element
    pending_vtag   resd 1
    cur_lit_aw     resd 1              ; element width for cg_emit_array_lit
    pending_float  resd 1
    pending_unsigned resd 1
    pending_ref    resd 1
    pending_arrlen resd 1
    pending_stride resd 1
    pending_fstruct resd 1
    struct_rounds  resd 1
    v2_op          resq 1   ; which packed operation to emit; rbx would not
                            ; survive the recursive cg_emit in between
    extra_args     resd 1   ; arguments beyond the sixth in the call
                            ; being emitted
    ; results of walking a member chain, set by cg_member_resolve
    mem_off        resd 1      ; byte offset from the start of the variable
    mem_sid        resd 1      ; struct id reached so far, -1 when none
    mem_width      resd 1      ; width of the last field
    mem_isfloat    resd 1
    mem_unsigned   resd 1
    mem_vtag       resd 1
    binop_unsigned resd 1   ; set just before cg_emit_binop_op
    ; --- file-scope globals ---
    g_toks         resq CG_MAX_GLOBALS ; name token per global
    g_isfloat      resd CG_MAX_GLOBALS ; 1 when the global holds a double
    g_unsigned     resd CG_MAX_GLOBALS ; 1 when the global's type is u8..u64
    g_arrlen       resd CG_MAX_GLOBALS ; element count, 0 when not an array
    g_aw           resd CG_MAX_GLOBALS ; bytes per array element, 0 = 8
    g_vtag         resd CG_MAX_GLOBALS ; type tag, as var_vtag
    g_structs      resd CG_MAX_GLOBALS ; struct id of a struct global, -1 none
    loop_brk       resd CG_MAX_LOOPS   ; end label of each enclosing loop
    loop_cont      resd CG_MAX_LOOPS   ; continue label of each enclosing loop
    loop_depth     resd 1
    g_count        resd 1
    ; --- function names (pre-registered so &fn resolves regardless of order) ---
    fn_toks        resq CG_MAX_FUNCS   ; name token per function
    fn_nodes       resq CG_MAX_FUNCS   ; and its AST_FUNCTION
    fn_ret_float   resd CG_MAX_FUNCS   ; 1 when function returns float
    fn_ret_vtag    resd CG_MAX_FUNCS   ; type tag of what it returns
    fn_multi       resd CG_MAX_FUNCS   ; several results: count | reals << 4 |
                                       ; squeezed tags << 8 (parse_multi_type)
    cur_fn_multi   resd 1              ; the same, for the function being emitted
    cg_in_raw      resd 1              ; inside raw { }
    cg_root        resq 1              ; the program, for main's global values
    cg_err_tok     resq 1              ; a type error found while emitting:
    cg_err_msg     resq 1              ; where, what, and a hint (or 0)
    cg_err_hint    resq 1
    fn_ret_unsig   resd CG_MAX_FUNCS   ; 1 when the return type is u8..u64
    fn_count       resd 1
    ; --- the thread check: which functions can run in a thread, and whether
    ; any of them touches a global that is not declared 'shared' ---
    gs_toks        resq CG_MAX_GLOBALS ; every global, registered in the pre-pass
    gs_shared      resd CG_MAX_GLOBALS ; 1 when declared 'shared var'
    gs_count       resd 1
    cg_cur_fn      resd 1              ; index of the function being emitted
    fn_gtok        resq CG_MAX_FUNCS   ; first access to a non-shared global
    fn_root        resb CG_MAX_FUNCS   ; passed to thread_start as &fn
    fn_addr        resb CG_MAX_FUNCS   ; its address is taken somewhere
    fn_asval       resb CG_MAX_FUNCS   ; used as a value: needs its __fnrec_
    ; --- functions as values -------------------------------------------------
    cg_pool        resb AST_NODE_SIZE * CG_POOL_NODES   ; nodes made here
    cg_pool_n      resd 1
    lq_node        resq LQ_MAX         ; fn(...) {...} written as values, to be
    lq_ncap        resd LQ_MAX         ; emitted after the function they sit in:
    lq_cap         resq LQ_MAX * LQ_CAPS   ; the names each one keeps
    lq_cflag       resd LQ_MAX * LQ_CAPS   ; and their flags: real | tag << 8
    lq_n           resd 1
    lq_done        resd 1
    cg_lam_cur     resd 1              ; the one being emitted, -1 none
    lx_toks        resq 256            ; names a fn value declares itself
    lx_n           resd 1
    fn_indir       resb CG_MAX_FUNCS   ; it makes an indirect call
    fn_reach       resb CG_MAX_FUNCS   ; can run in a thread
    ce_from        resd CG_MAX_EDGES   ; call edges: caller
    ce_to          resd CG_MAX_EDGES   ;             callee
    ce_count       resd 1
    cg_dyn_thread  resb 1              ; thread_start with a computed function
    cg_thread_tok  resq 1              ; the offending access, 0 when none
    pending_elem   resd 1         ; width to attach to the next cg_add_var
    pending_struct resd 1         ; struct id to attach to the next cg_add_var
    var_count    resd 1
    cur_ret_float resd 1        ; 1 when the function being emitted returns real64
    cur_ret_id   resd 1
    ; --- failure traces ------------------------------------------------------
    ; Every statement whose line differs from the one before gets a local
    ; label .klN; at the end of the function a record in .data lists those
    ; labels with their lines, and the records are chained. When something
    ; fails the runtime keeps the return addresses, and print_fail turns them
    ; back into function names and lines through the records.
    kt_on        resd 1          ; 1 while a hosted function is being emitted
    kt_n         resd 1          ; next .klN
    kt_x         resd 1          ; next .kxN
    kt_first     resd 1          ; first .kl number of this function
    kt_cnt       resd 1          ; marks in this function
    kt_last      resd 1          ; expanded line of the last label
    kt_pend      resd 1          ; line of the statement being emitted
    kt_file      resq 1          ; file of this function, from the line map
    kt_prev      resq 1          ; last function with a record, 0 none
    kt_nfiles    resd 1
    kt_files     resq KT_MAX_FILES
    kt_lines     resd KT_MAX_MARKS

section .text
    global jup_codegen_init
    global jup_codegen_run
    global jup_codegen_set_target
    global codegen_get_code
    global codegen_get_code_size

; ==============================================================================
; jup_codegen_init(rdi=out_buf, rsi=out_cap)
; ==============================================================================
jup_codegen_init:
    mov  [rel cg_out], rdi
    mov  [rel cg_ptr], rdi
    mov  rax, rdi
    add  rax, rsi
    mov  [rel cg_end], rax
    xor  eax, eax
    mov  [rel cg_label], eax
    mov  [rel var_count], eax
    mov  [rel cur_ret_id], eax
    mov  byte [rel cg_had_error], 0
    mov  qword [rel cg_err_msg], 0
    mov  qword [rel cg_err_tok], 0
    mov  qword [rel cg_err_hint], 0
    ; struct id 0 is always 'stream'
    mov  dword [rel struct_count], 1
    mov  dword [rel field_count], 2
    lea  rax, [rel struct_toks]
    lea  rcx, [rel tok_stream]
    mov  [rax], rcx
    lea  rax, [rel struct_first]
    mov  dword [rax], 0
    lea  rax, [rel struct_bytes]
    mov  dword [rax], 16             ; cg_struct_size divides this by 8
    lea  rax, [rel struct_nfield]
    mov  dword [rax], 2              ; without this the field search never runs
    lea  rax, [rel field_toks]
    lea  rcx, [rel tok_sptr]
    mov  [rax], rcx
    lea  rcx, [rel tok_slen]
    mov  [rax + 8], rcx
    lea  rax, [rel field_sizes]
    mov  dword [rax], 8
    mov  dword [rax + 4], 8
    lea  rax, [rel field_offs]
    mov  dword [rax], 0
    mov  dword [rax + 4], 8
    lea  rax, [rel field_isfloat]
    mov  dword [rax], 0
    mov  dword [rax + 4], 0
    lea  rax, [rel field_struct]
    mov  dword [rax], -1
    mov  dword [rax + 4], -1
    lea  rax, [rel field_unsigned]
    mov  dword [rax], 1              ; stream.bytes and stream.len are u64
    mov  dword [rax + 4], 1
    mov  [rel stream_struct_id], dword 0
    ret

; ==============================================================================
; emit_bytes(rsi=ptr, rdx=len)  -- append with a bounds check
; ==============================================================================
emit_bytes:
    ; Inside a function the bytes are captured into the IR instead. Both
    ; paths leave rsi advanced by the length and rdx at zero, which is what
    ; every caller of the original relied on.
    cmp  dword [rel ir_on], 0
    jne  ir_capture
emit_direct:
    push rcx
    mov  rax, [rel cg_ptr]
    mov  rcx, rax
    add  rcx, rdx
    cmp  rcx, [rel cg_end]
    ja   .oom
.copy:
    test rdx, rdx
    jz   .done
    mov  cl, [rsi]
    mov  [rax], cl
    inc  rsi
    inc  rax
    dec  rdx
    jmp  .copy
.done:
    mov  [rel cg_ptr], rax
    pop  rcx
    ret
.oom:
    mov  byte [rel cg_had_error], 1
    mov  byte [rel dbg_which], 1
    pop  rcx
    ret

; ==============================================================================
; ir_capture(rsi = bytes, rdx = length) -- append to the current function's IR.
;
; Consecutive raw text is folded into one record, so a function that is all
; raw text is a single record and flushing it is one copy.
; ==============================================================================
ir_capture:
    push rcx
    push rbx
    push rdi
    mov  rax, [rel ir_text_len]
    mov  rcx, rax
    add  rcx, rdx
    cmp  rcx, IR_TEXT_SIZE
    ja   .ic_oom
    ; extend the last record if it is raw, otherwise open a new one
    mov  ecx, [rel ir_count]
    test ecx, ecx
    jz   .ic_new
    dec  ecx
    shl  rcx, 4
    lea  rdi, [rel ir_recs]
    add  rdi, rcx
    ; loaded into a register first: kasm is not trusted with arithmetic on a
    ; [base + disp] destination, and every form here has to assemble itself
    mov  ecx, [rdi]
    cmp  ecx, IR_RAW
    jne  .ic_new
    mov  ecx, [rdi + 4]
    add  ecx, edx
    mov  [rdi + 4], ecx
    jmp  .ic_copy
.ic_new:
    mov  ecx, [rel ir_count]
    cmp  ecx, IR_MAX_RECS
    jae  .ic_oom
    shl  rcx, 4
    lea  rdi, [rel ir_recs]
    add  rdi, rcx
    mov  dword [rdi], IR_RAW
    mov  [rdi + 4], edx
    mov  [rdi + 8], rax
    mov  ecx, [rel ir_count]
    inc  ecx
    mov  [rel ir_count], ecx
.ic_copy:
    lea  rbx, [rel ir_text]
    add  rbx, rax
.ic_loop:
    test rdx, rdx
    jz   .ic_done
    mov  cl, [rsi]
    mov  [rbx], cl
    inc  rsi
    inc  rbx
    inc  rax
    dec  rdx
    jmp  .ic_loop
.ic_done:
    mov  [rel ir_text_len], rax
    pop  rdi
    pop  rbx
    pop  rcx
    ret
.ic_oom:
    mov  byte [rel cg_had_error], 1
    mov  byte [rel dbg_which], 1
    pop  rdi
    pop  rbx
    pop  rcx
    ret

; ==============================================================================
; ir_add_rec(ecx = kind, rdi = operand) -- append a structured record.
; Preserves every register.
; ==============================================================================
ir_add_rec:
    push rax
    push rdx
    push rsi
    mov  eax, [rel ir_count]
    cmp  eax, IR_MAX_RECS
    jae  .ar_oom
    mov  edx, eax
    shl  rdx, 4
    lea  rsi, [rel ir_recs]
    add  rsi, rdx
    mov  [rsi], ecx
    mov  dword [rsi + 4], 0
    mov  [rsi + 8], rdi
    inc  eax
    mov  [rel ir_count], eax
    pop  rsi
    pop  rdx
    pop  rax
    ret
.ar_oom:
    mov  byte [rel cg_had_error], 1
    mov  byte [rel dbg_which], 1
    pop  rsi
    pop  rdx
    pop  rax
    ret

; ==============================================================================
; ir_ldloc(edi = frame offset) -- mov rax, [rbp-N]
; ir_stloc(edi = frame offset) -- mov [rbp-N], rax
;
; These two are what register allocation replaces: every read and write of a
; local goes through one of them, so an allocator that sees the records knows
; every use of every local. Outside a function -- which should not happen for
; a local, but costs nothing to guard -- they write the text directly.
; Both preserve every register.
; ==============================================================================
ir_ldloc:
    push rax
    mov  eax, IR_LDLOC
    call ir_ctl
    pop  rax
    ret

ir_stloc:
    push rax
    mov  eax, IR_STLOC
    call ir_ctl
    pop  rax
    ret

; ir_jcc(rdi = label, edx = condition CC_*) -- j<cc> .LN
; The condition rides in the record's length field, which structured records
; do not otherwise use. Preserves every register.
ir_jcc:
    push rax
    push rcx
    push rsi
    mov  eax, [rel ir_on]
    test eax, eax
    jz   .jc_direct
    mov  ecx, IR_JCC
    call ir_add_rec
    mov  eax, [rel ir_count]
    dec  eax
    mov  ecx, eax
    shl  rcx, 4
    lea  rsi, [rel ir_recs]
    add  rsi, rcx
    mov  [rsi + 4], edx
    jmp  .jc_out
.jc_direct:
    mov  ecx, IR_JCC
    call ir_emit_kind
.jc_out:
    pop  rsi
    pop  rcx
    pop  rax
    ret

; ir_stparam(rdi = frame offset, edx = argument register 0..5)
;   mov [rbp-N], rcx|rdx|r8|r9|r10|rax
; The register rides in the record's length field, as the condition of
; IR_JCC does. Preserves every register.
ir_stparam:
    push rax
    push rcx
    push rsi
    mov  eax, [rel ir_on]
    test eax, eax
    jz   .sp_direct
    mov  ecx, IR_STPARAM
    call ir_add_rec
    mov  eax, [rel ir_count]
    dec  eax
    mov  ecx, eax
    shl  rcx, 4
    lea  rsi, [rel ir_recs]
    add  rsi, rcx
    mov  [rsi + 4], edx
    jmp  .sp_out
.sp_direct:
    mov  ecx, IR_STPARAM
    call ir_emit_kind
.sp_out:
    pop  rsi
    pop  rcx
    pop  rax
    ret

; ir_withlen(eax = kind, rdi = operand, edx = length field) -- a structured
; record whose length field carries data, like IR_JCC's condition. Written
; straight out when not capturing. Preserves every register except rax.
ir_withlen:
    push rcx
    push rsi
    mov  ecx, eax
    mov  eax, [rel ir_on]
    test eax, eax
    jz   .wl_direct
    call ir_add_rec
    mov  eax, [rel ir_count]
    dec  eax
    mov  esi, eax
    shl  rsi, 4
    push rcx
    lea  rcx, [rel ir_recs]
    add  rsi, rcx
    pop  rcx
    mov  [rsi + 4], edx
    jmp  .wl_out
.wl_direct:
    call ir_emit_kind
.wl_out:
    pop  rsi
    pop  rcx
    ret

; ir_fldloc(edi = frame offset) -- movsd xmm0, [rbp-N]
; ir_fstloc(rdi = frame offset) -- movsd [rbp-N], xmm0
; The float counterparts of ir_ldloc and ir_stloc. Both preserve every
; register.
ir_fldloc:
    push rax
    mov  eax, IR_FLDLOC
    call ir_ctl
    pop  rax
    ret

ir_fstloc:
    push rax
    mov  eax, IR_FSTLOC
    call ir_ctl
    pop  rax
    ret

; ir_fldx1(edi = frame offset) -- movsd xmm1, [rbp-N]: a float read into the
; register a float operation takes its right operand from.
ir_fldx1:
    push rax
    mov  eax, IR_FLDX1
    call ir_ctl
    pop  rax
    ret

; ir_ldrcx(edi = frame offset) -- mov rcx, [rbp-N]. A read, like ir_ldloc,
; into the register a binary operation takes its right operand from.
ir_ldrcx:
    push rax
    mov  eax, IR_LDRCX
    call ir_ctl
    pop  rax
    ret

; ==============================================================================
; ir_ctl(eax = kind, rdi = operand) -- one structured record.
;
; Inside a function it is captured; outside, it is written straight away with
; the same text. The kind travels in eax and not ecx on purpose: the emit
; sequences this replaced left rcx untouched, and code after them relies on
; that. They did destroy rax, so nothing can be relying on it.
;
; Preserves every register except rax.
; ==============================================================================
ir_ctl:
    cmp  dword [rel ir_on], 0
    je   .ctl_direct
    push rcx
    mov  ecx, eax
    call ir_add_rec
    pop  rcx
    ret
.ctl_direct:
    push rcx
    mov  ecx, eax
    call ir_emit_kind
    pop  rcx
    ret

; ==============================================================================
; ir_emit_kind(ecx = kind, rdi = operand) -- the text of one structured record.
;
; The ONE place that knows what each kind looks like as assembly. The flush at
; the end of a function and the direct path both come through here, so the two
; cannot drift apart. Register allocation will change the LDLOC and STLOC
; cases and nothing else.
;
; Called only while ir_on is zero, so emit_cstr writes straight to the output.
; Preserves every register.
; ==============================================================================
ir_emit_kind:
    push rcx                         ; first, so [rsp] is still the operand
    push rax
    push rdx
    push rsi
    push rdi
    cmp  ecx, IR_FRAME
    je   .ek_frame
    cmp  ecx, IR_LDLOC
    je   .ek_ld
    cmp  ecx, IR_LDRCX
    je   .ek_ldrcx
    cmp  ecx, IR_STLOC
    je   .ek_st
    cmp  ecx, IR_LABEL
    je   .ek_lab
    cmp  ecx, IR_JMP
    je   .ek_jmp
    cmp  ecx, IR_JZ
    je   .ek_jz
    cmp  ecx, IR_JNZ
    je   .ek_jnz
    cmp  ecx, IR_RETLBL
    je   .ek_retlbl
    cmp  ecx, IR_JMPRET
    je   .ek_jmpret
    cmp  ecx, IR_JCC
    je   .ek_jcc
    cmp  ecx, IR_ALU
    je   .ek_alu
    cmp  ecx, IR_IMMRCX
    je   .ek_imm
    cmp  ecx, IR_STPARAM
    je   .ek_stparam
    cmp  ecx, IR_LDARG
    je   .ek_ldarg
    cmp  ecx, IR_IMMARG
    je   .ek_immarg
    cmp  ecx, IR_FLDLOC
    je   .ek_fld
    cmp  ecx, IR_FSTLOC
    je   .ek_fst
    cmp  ecx, IR_FSTPARAM
    je   .ek_fsp
    cmp  ecx, IR_FLDX1
    je   .ek_fx1
    jmp  .ek_out
.ek_ld:
    call ra_reg_of                   ; eax = register, or -1 = memory
    cmp  eax, -1
    je   .ek_ld_mem
    mov  ecx, eax
    mov  rsi, s_ra_ld                ; mov rax, REG
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_ld_mem:
    mov  rsi, s_movraxmem
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_closemem
    call emit_cstr
    jmp  .ek_out
.ek_ldrcx:
    call ra_reg_of
    cmp  eax, -1
    je   .ek_ldrcx_mem
    mov  ecx, eax
    mov  rsi, s_ra_ldrcx             ; mov rcx, REG
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_ldrcx_mem:
    mov  rsi, s_movrcxmem            ; mov rcx, [rbp-N]
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_closemem
    call emit_cstr
    jmp  .ek_out
.ek_st:
    call ra_reg_of
    cmp  eax, -1
    je   .ek_st_mem
    mov  ecx, eax
    mov  rsi, s_ra_st1               ; mov REG, rax
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_ra_st2
    call emit_cstr
    jmp  .ek_out
.ek_st_mem:
    mov  rsi, s_movmemrax
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_movmemrax2
    call emit_cstr
    jmp  .ek_out
.ek_lab:
    mov  rsi, s_label_L
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    jmp  .ek_out
.ek_jmp:
    mov  rsi, s_jmp
    jmp  .ek_tolabel
.ek_jz:
    mov  rsi, s_jz
    jmp  .ek_tolabel
.ek_jnz:
    mov  rsi, s_jnz
.ek_tolabel:
    call emit_cstr
    mov  rsi, s_label_L
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_fld:
    call ra_reg_of
    cmp  eax, -1
    je   .ek_fld_mem
    mov  ecx, eax
    mov  rsi, s_ra_fld               ; movsd xmm0, xmmK
    call emit_cstr
    call ra_emit_freg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_fld_mem:
    mov  rsi, s_ld_xmm_pre           ; movsd xmm0, [rbp-N]
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .ek_out
.ek_fx1:
    call ra_reg_of
    cmp  eax, -1
    je   .ek_fx1_mem
    mov  ecx, eax
    mov  rsi, s_ra_fx1               ; movsd xmm1, xmmK
    call emit_cstr
    call ra_emit_freg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_fx1_mem:
    mov  rsi, s_ra_fx1m              ; movsd xmm1, [rbp-N]
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .ek_out
.ek_fst:
    call ra_reg_of
    cmp  eax, -1
    je   .ek_fst_mem
    mov  ecx, eax
    mov  rsi, s_ra_fmov              ; movsd xmmK, xmm0
    call emit_cstr
    call ra_emit_freg
    mov  rsi, s_ra_fx0               ; not s_st_xmm_suf: that one opens with ']'
    call emit_cstr
    jmp  .ek_out
.ek_fst_mem:
    mov  rsi, s_st_xmm_pre           ; movsd [rbp-N], xmm0
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_st_xmm_suf
    call emit_cstr
    jmp  .ek_out
.ek_fsp:
    call ra_reg_of
    cmp  eax, -1
    je   .ek_fsp_mem
    mov  ecx, eax
    mov  rsi, s_ra_fmov              ; movsd xmmK, xmmN
    call emit_cstr
    call ra_emit_freg
    mov  rsi, s_ra_fxmm
    call emit_cstr
    mov  rdi, [rsp + 16]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_fsp_mem:
    mov  rsi, s_fmovmem              ; movsd [rbp-N], xmmN
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_fmovmid
    call emit_cstr
    mov  rdi, [rsp + 16]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_ldarg:
    ; mov <argument register>, REG | [rbp-N]
    mov  rsi, s_ra_st1
    call emit_cstr
    mov  rax, [rsp + 16]
    call ra_emit_argreg
    call ra_reg_of
    cmp  eax, -1
    je   .ek_la_mem
    mov  ecx, eax
    mov  rsi, s_alu_cm
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_la_mem:
    mov  rsi, s_ra_rs2
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_closemem
    call emit_cstr
    jmp  .ek_out
.ek_immarg:
    ; mov <argument register>, <constant>
    mov  rsi, s_ra_st1
    call emit_cstr
    mov  rax, [rsp + 16]
    call ra_emit_argreg
    mov  rsi, s_alu_cm
    call emit_cstr
    mov  rdi, [rsp]
    test rdi, rdi
    jz   .ek_ia0
    call emit_tok
    jmp  .ek_ia_nl
.ek_ia0:
    xor  rdi, rdi
    call emit_uint
.ek_ia_nl:
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_stparam:
    ; the argument register was in edx on entry: [rsp+16] in this frame
    call ra_reg_of
    cmp  eax, -1
    je   .ek_sp_mem
    mov  ecx, eax
    mov  rsi, s_ra_st1               ; mov REG, <argument register>
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_alu_cm
    call emit_cstr
    mov  rax, [rsp + 16]
    call ra_emit_argreg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_sp_mem:
    mov  rsi, s_movmem_pre           ; mov [rbp-N], <argument register>
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_movmem_mid
    call emit_cstr
    mov  rax, [rsp + 16]
    call ra_emit_argreg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_alu:
    mov  rsi, s_alu_ind              ; "    op rax, rcx"
    call emit_cstr
    mov  rcx, [rsp]
    call ra_emit_mnem
    mov  rsi, s_alu_rrcx
    call emit_cstr
    jmp  .ek_out
.ek_imm:
    mov  rsi, s_movrcx_imm           ; "    mov rcx, <constant>"
    call emit_cstr
    mov  rdi, [rsp]
    test rdi, rdi
    jz   .ek_imm0
    call emit_tok
    jmp  .ek_imm_nl
.ek_imm0:
    xor  rdi, rdi
    call emit_uint
.ek_imm_nl:
    mov  rsi, s_nl
    call emit_cstr
    jmp  .ek_out
.ek_jcc:
    ; the condition was in edx on entry: [rsp+16] in this frame. Read as a
    ; qword: kasm cannot load a 32-bit register with rsp as the base, and the
    ; upper half is zero anyway -- edx was written as a dword.
    mov  rax, [rsp + 16]
    lea  rsi, [rel s_jcc_tab]
    shl  rax, 3
    add  rsi, rax
    mov  rsi, [rsi]
    jmp  .ek_tolabel
.ek_retlbl:
    mov  rsi, s_retlbl
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    ; every way out of the function comes through this label, so this is the
    ; one place the saved registers are put back
    mov  eax, [rel ra_active]
    test eax, eax
    jz   .ek_out
    mov  edx, 1
    call ra_emit_saves
    jmp  .ek_out
.ek_frame:
    mov  rsi, s_subrsp
    call emit_cstr
    mov  rdi, [rsp]
    mov  eax, [rel ra_active]
    test eax, eax
    jz   .ek_fr_n
    mov  rax, [rel ra_grow]
    add  rdi, rax                    ; room for the registers it saves
.ek_fr_n:
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  eax, [rel ra_active]
    test eax, eax
    jz   .ek_out
    xor  edx, edx
    call ra_emit_saves
    jmp  .ek_out
.ek_jmpret:
    mov  rsi, s_jmpret
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
.ek_out:
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rax
    pop  rcx
    ret

; ==============================================================================
; REGISTER ALLOCATION -- phase 2: analysis
;
; ra_analyze runs when a function has been captured, before it is written. It
; works out, for every local that is a candidate for a register:
;
;   which locals are candidates   read and written only through IR_LDLOC and
;                                 IR_STLOC, never named in raw text -- a local
;                                 whose address is taken, or that a float or a
;                                 struct access touches, shows up as [rbp-N] in
;                                 the text and stays in memory
;   where the basic blocks are    split at labels, and after every jump
;   what is live at each block    use, def, and the in/out sets iterated to a
;                                 fixed point
;
; A function is skipped whole when it holds inline asm, has more blocks or
; labels than the tables allow, or jumps somewhere the map does not know.
;
; Nothing here changes the output. It only computes; phase 3 uses the result.
; Preserves every register.
; ==============================================================================
ra_analyze:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    mov  eax, [rel ra_gen]
    inc  eax
    mov  [rel ra_gen], eax
    mov  dword [rel ra_skip], 0
    mov  dword [rel ra_ncand], 0
    mov  qword [rel ra_exmask], 0
    mov  dword [rel ra_nblk], 0
    mov  dword [rel ra_retblk], -1
    mov  dword [rel ra_nframe], 0
    mov  dword [rel ra_nret], 0
    mov  dword [rel ra_used], 0
    mov  dword [rel ra_fused], 0
    mov  qword [rel ra_imask], 0
    mov  qword [rel ra_fmask], 0
    mov  qword [rel ra_grow], 0
    mov  eax, [rel ra_asm]
    test eax, eax
    jz   .a_bits
    mov  dword [rel ra_skip], 1
    jmp  .a_out

    ; --- bit table: 1 << i, by doubling -----------------------------------
.a_bits:
    lea  rsi, [rel ra_bits]
    mov  rax, 1
    xor  ecx, ecx
.a_bitl:
    cmp  ecx, 64
    jae  .a_cands
    mov  [rsi], rax
    add  rax, rax
    add  rsi, 8
    inc  ecx
    jmp  .a_bitl

    ; --- 1. candidates -----------------------------------------------------
.a_cands:
    xor  ebx, ebx
.c_loop:
    mov  eax, [rel ir_count]
    cmp  ebx, eax
    jae  .c_done
    mov  edi, ebx
    shl  rdi, 4
    lea  rax, [rel ir_recs]
    add  rdi, rax
    mov  ecx, [rdi]
    cmp  ecx, IR_FRAME
    jne  .c_nofr
    mov  eax, [rel ra_nframe]
    inc  eax
    mov  [rel ra_nframe], eax
    mov  rax, [rdi + 8]
    mov  [rel ra_frame], rax
    jmp  .c_next
.c_nofr:
    cmp  ecx, IR_RETLBL
    jne  .c_noret
    mov  eax, [rel ra_nret]
    inc  eax
    mov  [rel ra_nret], eax
    jmp  .c_next
.c_noret:
    cmp  ecx, IR_LDLOC
    je   .c_slot
    cmp  ecx, IR_LDRCX
    je   .c_slot
    cmp  ecx, IR_STPARAM
    je   .c_slot
    cmp  ecx, IR_LDARG
    je   .c_slot
    cmp  ecx, IR_FLDLOC
    je   .c_slot
    cmp  ecx, IR_FSTLOC
    je   .c_slot
    cmp  ecx, IR_FSTPARAM
    je   .c_slot
    cmp  ecx, IR_FLDX1
    je   .c_slot
    cmp  ecx, IR_STLOC
    jne  .c_next
.c_slot:
    mov  r8d, ecx                    ; the kind, for the class below
    mov  rdx, [rdi + 8]
    call ra_cand_index
    cmp  eax, -1
    jne  .c_mark
    mov  eax, [rel ra_ncand]
    cmp  eax, RA_MAXCAND
    jae  .c_next                     ; past 64: simply not a candidate
    mov  ecx, eax
    shl  rcx, 3
    lea  rsi, [rel ra_cand]
    add  rsi, rcx
    mov  [rsi], rdx
    mov  ecx, eax
    inc  ecx
    mov  [rel ra_ncand], ecx
.c_mark:
    ; which register file this local belongs to
    mov  ecx, eax
    shl  rcx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rcx
    mov  rax, [rsi]
    cmp  r8d, IR_FLDLOC
    je   .c_isf
    cmp  r8d, IR_FSTLOC
    je   .c_isf
    cmp  r8d, IR_FSTPARAM
    je   .c_isf
    cmp  r8d, IR_FLDX1
    je   .c_isf
    mov  rcx, [rel ra_imask]
    or   rcx, rax
    mov  [rel ra_imask], rcx
    jmp  .c_next
.c_isf:
    mov  rcx, [rel ra_fmask]
    or   rcx, rax
    mov  [rel ra_fmask], rcx
.c_next:
    inc  ebx
    jmp  .c_loop
.c_done:
    ; a local read as an integer somewhere and as a float elsewhere cannot live
    ; in one register file: it stays in memory
    mov  rax, [rel ra_imask]
    mov  rcx, [rel ra_fmask]
    and  rax, rcx
    mov  rcx, [rel ra_exmask]
    or   rcx, rax
    mov  [rel ra_exmask], rcx

    ; --- 2. exclusions: every 'rbp-N' in the raw text ----------------------
    lea  rsi, [rel ir_text]
    mov  r8, [rel ir_text_len]
    xor  r9, r9                      ; position
.x_loop:
    mov  rax, r8
    sub  rax, r9
    cmp  rax, 5
    jb   .x_done
    mov  rdi, rsi
    add  rdi, r9
    mov  al, [rdi]
    cmp  al, 'r'
    jne  .x_next
    mov  al, [rdi + 1]
    cmp  al, 'b'
    jne  .x_next
    mov  al, [rdi + 2]
    cmp  al, 'p'
    jne  .x_next
    mov  al, [rdi + 3]
    cmp  al, '-'
    jne  .x_next
    ; parse the digits that follow
    add  rdi, 4
    xor  edx, edx
    mov  r10, r9
    add  r10, 4
.x_dig:
    cmp  r10, r8
    jae  .x_have
    movzx eax, byte [rdi]
    cmp  eax, '0'
    jb   .x_have
    cmp  eax, '9'
    ja   .x_have
    sub  eax, '0'
    imul rdx, rdx, 10
    add  rdx, rax
    inc  rdi
    inc  r10
    jmp  .x_dig
.x_have:
    call ra_cand_index               ; rdx = offset
    cmp  eax, -1
    je   .x_next
    mov  ecx, eax
    shl  rcx, 3
    lea  rdi, [rel ra_bits]
    add  rdi, rcx
    mov  rax, [rdi]
    mov  rcx, [rel ra_exmask]
    or   rcx, rax
    mov  [rel ra_exmask], rcx
.x_next:
    inc  r9
    jmp  .x_loop
.x_done:

    ; --- 3. basic blocks ---------------------------------------------------
    mov  dword [rel ra_cur], -1
    xor  ebx, ebx
.b_loop:
    mov  eax, [rel ir_count]
    cmp  ebx, eax
    jae  .b_end
    mov  eax, [rel ra_cur]
    cmp  eax, -1
    jne  .b_have
    call ra_open_block               ; ebx = first record
    mov  eax, [rel ra_skip]
    test eax, eax
    jnz  .a_out
.b_have:
    mov  edi, ebx
    shl  rdi, 4
    lea  rax, [rel ir_recs]
    add  rdi, rax
    mov  ecx, [rdi]
    cmp  ecx, IR_LABEL
    je   .b_label
    cmp  ecx, IR_RETLBL
    je   .b_label
    cmp  ecx, IR_JMP
    je   .b_jump
    cmp  ecx, IR_JZ
    je   .b_jump
    cmp  ecx, IR_JNZ
    je   .b_jump
    cmp  ecx, IR_JCC
    je   .b_jump
    cmp  ecx, IR_JMPRET
    je   .b_jump
    jmp  .b_next
.b_label:
    ; a label starts a block, unless the current one is still empty
    mov  eax, [rel ra_cur]
    mov  edx, eax
    shl  rdx, 2
    lea  rsi, [rel ra_bstart]
    add  rsi, rdx
    mov  edx, [rsi]
    cmp  edx, ebx
    je   .b_mark
    call ra_close_block              ; ebx = end, exclusive
    call ra_open_block
    mov  eax, [rel ra_skip]
    test eax, eax
    jnz  .a_out
.b_mark:
    mov  eax, [rel ra_cur]
    cmp  ecx, IR_RETLBL
    jne  .b_lbl
    mov  [rel ra_retblk], eax
    jmp  .b_next
.b_lbl:
    mov  rdx, [rdi + 8]              ; label id
    cmp  rdx, RA_MAXLBL
    jb   .b_lbl_ok
    mov  dword [rel ra_skip], 1
    jmp  .a_out
.b_lbl_ok:
    shl  rdx, 2
    lea  rsi, [rel ra_lblblk]
    add  rsi, rdx
    mov  [rsi], eax
    lea  rsi, [rel ra_lblgen]
    add  rsi, rdx
    mov  eax, [rel ra_gen]
    mov  [rsi], eax
    jmp  .b_next
.b_jump:
    ; a jump ends its block
    inc  ebx
    call ra_close_block
    dec  ebx
    mov  dword [rel ra_cur], -1
.b_next:
    inc  ebx
    jmp  .b_loop
.b_end:
    mov  eax, [rel ra_cur]
    cmp  eax, -1
    je   .s_start
    call ra_close_block              ; ebx = ir_count

    ; --- 4. successors -----------------------------------------------------
.s_start:
    xor  r12d, r12d                  ; block
.s_loop:
    mov  eax, [rel ra_nblk]
    cmp  r12d, eax
    jae  .u_start
    mov  r13d, -1                    ; succ1
    mov  r11d, -1                    ; succ2
    ; fallthrough target, if there is a next block
    mov  r10d, r12d
    inc  r10d
    cmp  r10d, eax
    jb   .s_ft_ok
    mov  r10d, -1
.s_ft_ok:
    ; last record of the block
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_bend]
    add  rsi, rdx
    mov  ecx, [rsi]
    lea  rsi, [rel ra_bstart]
    add  rsi, rdx
    mov  eax, [rsi]
    cmp  ecx, eax
    jbe  .s_fall                     ; empty block
    dec  ecx
    mov  edi, ecx
    shl  rdi, 4
    lea  rax, [rel ir_recs]
    add  rdi, rax
    mov  ecx, [rdi]
    cmp  ecx, IR_JMP
    je   .s_jmp
    cmp  ecx, IR_JZ
    je   .s_jcc
    cmp  ecx, IR_JNZ
    je   .s_jcc
    cmp  ecx, IR_JCC
    je   .s_jcc
    cmp  ecx, IR_JMPRET
    je   .s_ret
.s_fall:
    mov  r13d, r10d
    jmp  .s_store
.s_ret:
    mov  r13d, [rel ra_retblk]
    jmp  .s_store
.s_jcc:
    mov  r11d, r10d
.s_jmp:
    mov  rdx, [rdi + 8]
    call ra_label_block              ; eax = block, or -1 and skip set
    mov  r13d, eax
    mov  eax, [rel ra_skip]
    test eax, eax
    jnz  .a_out
.s_store:
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_succ1]
    add  rsi, rdx
    mov  [rsi], r13d
    lea  rsi, [rel ra_succ2]
    add  rsi, rdx
    mov  [rsi], r11d
    inc  r12d
    jmp  .s_loop

    ; --- 5. use and def per block ------------------------------------------
.u_start:
    xor  r12d, r12d
.u_blk:
    mov  eax, [rel ra_nblk]
    cmp  r12d, eax
    jae  .l_start
    xor  r8, r8                      ; use
    xor  r9, r9                      ; def
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_bstart]
    add  rsi, rdx
    mov  ebx, [rsi]
    lea  rsi, [rel ra_bend]
    add  rsi, rdx
    mov  r13d, [rsi]
.u_rec:
    cmp  ebx, r13d
    jae  .u_save
    mov  edi, ebx
    shl  rdi, 4
    lea  rax, [rel ir_recs]
    add  rdi, rax
    mov  ecx, [rdi]
    cmp  ecx, IR_LDLOC
    je   .u_slot
    cmp  ecx, IR_LDRCX
    je   .u_slot
    cmp  ecx, IR_STPARAM
    je   .u_slot
    cmp  ecx, IR_LDARG
    je   .u_slot
    cmp  ecx, IR_FLDLOC
    je   .u_slot
    cmp  ecx, IR_FSTLOC
    je   .u_slot
    cmp  ecx, IR_FSTPARAM
    je   .u_slot
    cmp  ecx, IR_FLDX1
    je   .u_slot
    cmp  ecx, IR_STLOC
    jne  .u_nx
.u_slot:
    mov  rdx, [rdi + 8]
    call ra_cand_index
    cmp  eax, -1
    je   .u_nx
    mov  r10d, eax
    shl  r10, 3
    lea  rsi, [rel ra_bits]
    add  rsi, r10
    mov  rax, [rsi]                  ; the candidate's bit
    mov  rdx, [rel ra_exmask]
    test rdx, rax
    jnz  .u_nx                       ; excluded: stays in memory
    cmp  ecx, IR_STLOC
    je   .u_def
    cmp  ecx, IR_STPARAM
    je   .u_def
    cmp  ecx, IR_FSTLOC
    je   .u_def
    cmp  ecx, IR_FSTPARAM
    je   .u_def
    test r9, rax                     ; read: a use unless defined first
    jnz  .u_nx
    or   r8, rax
    jmp  .u_nx
.u_def:
    or   r9, rax
.u_nx:
    inc  ebx
    jmp  .u_rec
.u_save:
    mov  edx, r12d
    shl  rdx, 3
    lea  rsi, [rel ra_use]
    add  rsi, rdx
    mov  [rsi], r8
    lea  rsi, [rel ra_def]
    add  rsi, rdx
    mov  [rsi], r9
    lea  rsi, [rel ra_in]
    add  rsi, rdx
    mov  qword [rsi], 0
    lea  rsi, [rel ra_out]
    add  rsi, rdx
    mov  qword [rsi], 0
    inc  r12d
    jmp  .u_blk

    ; --- 6. liveness, backwards, until nothing changes ---------------------
.l_start:
    xor  r11d, r11d                  ; passes, a guard against a bug
.l_pass:
    inc  r11d
    cmp  r11d, 100000
    jb   .l_pass_ok
    mov  dword [rel ra_skip], 1
    jmp  .a_out
.l_pass_ok:
    xor  r10d, r10d                  ; changed
    mov  r12d, [rel ra_nblk]
.l_blk:
    test r12d, r12d
    jz   .l_check
    dec  r12d
    xor  r8, r8                      ; out
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_succ1]
    add  rsi, rdx
    mov  eax, [rsi]
    call ra_in_of                    ; rax = in[eax], or 0
    or   r8, rax
    lea  rsi, [rel ra_succ2]
    add  rsi, rdx
    mov  eax, [rsi]
    call ra_in_of
    or   r8, rax
    ; in = use | (out & ~def)
    mov  edx, r12d
    shl  rdx, 3
    lea  rsi, [rel ra_def]
    add  rsi, rdx
    mov  rax, [rsi]
    not  rax
    and  rax, r8
    lea  rsi, [rel ra_use]
    add  rsi, rdx
    mov  rcx, [rsi]
    or   rax, rcx                    ; rax = new in
    lea  rsi, [rel ra_out]
    add  rsi, rdx
    mov  rcx, [rsi]
    cmp  rcx, r8
    je   .l_out_same
    mov  [rsi], r8
    mov  r10d, 1
.l_out_same:
    lea  rsi, [rel ra_in]
    add  rsi, rdx
    mov  rcx, [rsi]
    cmp  rcx, rax
    je   .l_blk
    mov  [rsi], rax
    mov  r10d, 1
    jmp  .l_blk
.l_check:
    test r10d, r10d
    jnz  .l_pass
    ; the save and restore need exactly one frame and one way out
    mov  eax, [rel ra_nframe]
    cmp  eax, 1
    jne  .a_noalloc
    mov  eax, [rel ra_nret]
    cmp  eax, 1
    jne  .a_noalloc
    call ra_colorize
    jmp  .a_out
.a_noalloc:
    mov  dword [rel ra_skip], 1

.a_out:
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; ==============================================================================
; Trace. With RA_TRACE at zero both return at once and the output does not
; change. With it set, the analysis is written into the .asm as comments so it
; can be checked by hand against the source.
; ==============================================================================
ra_trace_head:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    mov  dword [rel ra_tblk], 0
    mov  eax, [rel ra_trace]
    test eax, eax
    jz   .th_out
    mov  eax, [rel ra_skip]
    test eax, eax
    jz   .th_cands
    mov  rsi, s_ra_skip
    call emit_cstr
    jmp  .th_out
.th_cands:
    xor  ebx, ebx
.th_loop:
    mov  eax, [rel ra_ncand]
    cmp  ebx, eax
    jae  .th_out
    mov  rsi, s_ra_c1
    call emit_cstr
    mov  edi, ebx
    call emit_uint
    mov  rsi, s_ra_c2
    call emit_cstr
    mov  ecx, ebx
    shl  rcx, 3
    lea  rsi, [rel ra_cand]
    add  rsi, rcx
    mov  rdi, [rsi]
    call emit_uint
    mov  rsi, s_ra_c3
    call emit_cstr
    mov  ecx, ebx
    shl  rcx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rcx
    mov  rax, [rsi]
    mov  rcx, [rel ra_exmask]
    test rcx, rax
    jz   .th_col
    mov  rsi, s_ra_x
    call emit_cstr
    jmp  .th_nl
.th_col:
    mov  rsi, s_ra_arrow
    call emit_cstr
    mov  ecx, ebx
    shl  rcx, 2
    lea  rsi, [rel ra_color]
    add  rsi, rcx
    mov  ecx, [rsi]
    cmp  ecx, -1
    jne  .th_reg
    mov  rsi, s_ra_mem
    call emit_cstr
    jmp  .th_nl
.th_reg:
    mov  rax, [rel ra_fmask]
    mov  rdx, rsi
    mov  esi, ebx
    shl  rsi, 3
    push rdi
    lea  rdi, [rel ra_bits]
    add  rdi, rsi
    mov  rsi, [rdi]
    pop  rdi
    test rax, rsi
    jz   .th_ireg
    call ra_emit_freg
    jmp  .th_nl
.th_ireg:
    call ra_emit_reg
.th_nl:
    mov  rsi, s_nl
    call emit_cstr
    inc  ebx
    jmp  .th_loop
.th_out:
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; ra_trace_blk(ebx = record index) -- header for every block starting here
ra_trace_blk:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    mov  eax, [rel ra_trace]
    test eax, eax
    jz   .tb_out
    mov  eax, [rel ra_skip]
    test eax, eax
    jnz  .tb_out
.tb_loop:
    mov  r8d, [rel ra_tblk]
    mov  eax, [rel ra_nblk]
    cmp  r8d, eax
    jae  .tb_out
    mov  edx, r8d
    shl  rdx, 2
    lea  rsi, [rel ra_bstart]
    add  rsi, rdx
    mov  eax, [rsi]
    cmp  eax, ebx
    jne  .tb_out
    ; rcx carries the offsets: emit_uint divides and destroys rdx and rax,
    ; but neither it nor emit_cstr touches rcx
    mov  rsi, s_ra_b1
    call emit_cstr
    mov  edi, r8d
    call emit_uint
    mov  ecx, r8d
    shl  rcx, 3
    mov  rsi, s_ra_in
    call emit_cstr
    lea  rsi, [rel ra_in]
    add  rsi, rcx
    mov  rdi, [rsi]
    call emit_uint
    mov  rsi, s_ra_out
    call emit_cstr
    lea  rsi, [rel ra_out]
    add  rsi, rcx
    mov  rdi, [rsi]
    call emit_uint
    mov  rsi, s_ra_use
    call emit_cstr
    lea  rsi, [rel ra_use]
    add  rsi, rcx
    mov  rdi, [rsi]
    call emit_uint
    mov  rsi, s_ra_def
    call emit_cstr
    lea  rsi, [rel ra_def]
    add  rsi, rcx
    mov  rdi, [rsi]
    call emit_uint
    mov  rsi, s_ra_s
    call emit_cstr
    mov  ecx, r8d
    shl  rcx, 2
    lea  rsi, [rel ra_succ1]
    add  rsi, rcx
    mov  eax, [rsi]
    call ra_trace_blkno
    mov  rsi, s_ra_cm
    call emit_cstr
    lea  rsi, [rel ra_succ2]
    add  rsi, rcx
    mov  eax, [rsi]
    call ra_trace_blkno
    mov  rsi, s_nl
    call emit_cstr
    inc  r8d
    mov  [rel ra_tblk], r8d
    jmp  .tb_loop
.tb_out:
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rax
    ret

; ra_trace_blkno(eax = block or -1) -- the number, or '-'
ra_trace_blkno:
    push rsi
    push rdi
    cmp  eax, -1
    jne  .tn_num
    mov  rsi, s_ra_none
    call emit_cstr
    jmp  .tn_out
.tn_num:
    mov  edi, eax
    call emit_uint
.tn_out:
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; REGISTER ALLOCATION -- phase 3: conflict graph and colouring
;
; Two candidates conflict when one is written while the other is still live:
; they cannot share a register. Each block is walked backwards from its out
; set; at a write, the variable conflicts with everything live right after it.
;
; Colouring is Chaitin's, with RA_REGS colours:
;   - take out any node with fewer than RA_REGS neighbours still in the graph
;   - when none is left, take out the one touched least often, optimistically
;   - put them back in reverse order, each with the first colour its already
;     coloured neighbours do not use; one that finds none stays in memory
;
; Colour n is register n of rbx, r12, r13, r14, r15. All five survive calls:
; Windows preserves them, the runtime saves the ones it touches, and every
; function this allocator touches saves the ones it uses.
; ==============================================================================
ra_colorize:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    ; --- clear the tables ---------------------------------------------------
    xor  ecx, ecx
.z_loop:
    cmp  ecx, RA_MAXCAND
    jae  .z_done
    mov  edx, ecx
    shl  rdx, 2
    lea  rsi, [rel ra_wt]
    add  rsi, rdx
    mov  dword [rsi], 0
    lea  rsi, [rel ra_color]
    add  rsi, rdx
    mov  dword [rsi], -1
    mov  edx, ecx
    shl  rdx, 3
    lea  rsi, [rel ra_adj]
    add  rsi, rdx
    mov  qword [rsi], 0
    inc  ecx
    jmp  .z_loop
.z_done:
    ; --- r15 = candidates that may take a register ------------------------
    xor  r15, r15
    xor  ecx, ecx
.am_loop:
    mov  eax, [rel ra_ncand]
    cmp  ecx, eax
    jae  .am_done
    mov  edx, ecx
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    or   r15, rax
    inc  ecx
    jmp  .am_loop
.am_done:
    mov  rax, [rel ra_exmask]
    not  rax
    and  r15, rax
    test r15, r15
    jz   .grow

    ; --- weights and conflicts, block by block, backwards -----------------
    xor  r12d, r12d
.bl_loop:
    mov  eax, [rel ra_nblk]
    cmp  r12d, eax
    jae  .simplify
    mov  edx, r12d
    shl  rdx, 3
    lea  rsi, [rel ra_out]
    add  rsi, rdx
    mov  r13, [rsi]
    and  r13, r15                    ; live, starting from the block's out
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_bstart]
    add  rsi, rdx
    mov  r14d, [rsi]
    lea  rsi, [rel ra_bend]
    add  rsi, rdx
    mov  ebx, [rsi]
.rec_loop:
    cmp  ebx, r14d
    jbe  .bl_next
    dec  ebx
    mov  edi, ebx
    shl  rdi, 4
    lea  rax, [rel ir_recs]
    add  rdi, rax
    mov  ecx, [rdi]
    cmp  ecx, IR_LDLOC
    je   .rec_slot
    cmp  ecx, IR_LDRCX
    je   .rec_slot
    cmp  ecx, IR_STPARAM
    je   .rec_slot
    cmp  ecx, IR_LDARG
    je   .rec_slot
    cmp  ecx, IR_FLDLOC
    je   .rec_slot
    cmp  ecx, IR_FSTLOC
    je   .rec_slot
    cmp  ecx, IR_FSTPARAM
    je   .rec_slot
    cmp  ecx, IR_FLDX1
    je   .rec_slot
    cmp  ecx, IR_STLOC
    jne  .rec_loop
.rec_slot:
    mov  rdx, [rdi + 8]
    call ra_cand_index
    cmp  eax, -1
    je   .rec_loop
    mov  r8d, eax
    mov  edx, eax
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  r9, [rsi]                   ; this candidate's bit
    test r9, r15
    jz   .rec_loop                   ; excluded
    mov  edx, r8d
    shl  rdx, 2
    lea  rsi, [rel ra_wt]
    add  rsi, rdx
    mov  eax, [rsi]
    inc  eax
    mov  [rsi], eax
    cmp  ecx, IR_STLOC
    je   .rec_def
    cmp  ecx, IR_STPARAM
    je   .rec_def
    cmp  ecx, IR_FSTLOC
    je   .rec_def
    cmp  ecx, IR_FSTPARAM
    je   .rec_def
    or   r13, r9                     ; a read makes it live
    jmp  .rec_loop
.rec_def:
    mov  r10, r9
    not  r10
    and  r10, r13                    ; everything live after this write
    mov  edx, r8d
    shl  rdx, 3
    lea  rsi, [rel ra_adj]
    add  rsi, rdx
    mov  rax, [rsi]
    or   rax, r10
    mov  [rsi], rax
    xor  r11d, r11d
.nb_loop:
    cmp  r11d, 64
    jae  .nb_done
    mov  edx, r11d
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    test r10, rax
    jz   .nb_next
    lea  rsi, [rel ra_adj]
    add  rsi, rdx
    mov  rax, [rsi]
    or   rax, r9
    mov  [rsi], rax
.nb_next:
    inc  r11d
    jmp  .nb_loop
.nb_done:
    mov  rax, r9
    not  rax
    and  r13, rax                    ; the write ends the previous value
    jmp  .rec_loop
.bl_next:
    inc  r12d
    jmp  .bl_loop

    ; --- colour each register file on its own -----------------------------
    ; Integers take rbx and r12-r15, floats xmm6-xmm15: separate files, so a
    ; conflict between an integer and a float costs nothing, and each class is
    ; coloured only against neighbours of its own kind.
.simplify:
    mov  rax, [rel ra_fmask]
    not  rax
    and  rax, r15
    mov  edx, RA_REGS
    call ra_color_class
    mov  [rel ra_used], ecx
    mov  rax, [rel ra_fmask]
    and  rax, r15
    mov  edx, RA_FREGS
    call ra_color_class
    mov  [rel ra_fused], ecx

    ; --- how much the frame grows: 8 per saved register, kept 16-aligned ---
.grow:
    ; 8 bytes per integer register saved, 16 per xmm -- Windows wants all 128
    ; bits of xmm6-xmm15 kept -- rounded up to keep the frame 16-aligned
    mov  eax, [rel ra_used]
    call ra_popcnt
    mov  edx, ecx
    shl  edx, 3
    mov  eax, [rel ra_fused]
    call ra_popcnt
    shl  ecx, 4
    add  edx, ecx
    add  edx, 15
    and  edx, -16
    mov  eax, edx
    mov  [rel ra_grow], rax

    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; ==============================================================================
; ra_color_class(rax = candidates of one class, edx = colours available)
;   -> ecx = bit per colour handed out
;
; Chaitin on one register file: take out any node with fewer than K
; neighbours left, the least touched when none has; then put them back in
; reverse order with the first colour no neighbour OF THIS CLASS holds.
; A node that finds none keeps colour -1 and stays in memory.
; Preserves every register except rcx.
; ==============================================================================
ra_color_class:
    push rax
    push rbx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    mov  r15, rax                    ; this class
    mov  ebx, edx                    ; K
    xor  edi, edi                    ; colours handed out
    mov  r13, r15                    ; still in the graph
    xor  r14d, r14d                  ; stack depth
.cs_loop:
    test r13, r13
    jz   .cs_sel
    xor  r12d, r12d
    mov  r10d, -1
    mov  r11d, 0x7fffffff
.cs_find:
    cmp  r12d, 64
    jae  .cs_fdone
    mov  edx, r12d
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    test r13, rax
    jz   .cs_next
    lea  rsi, [rel ra_adj]
    add  rsi, rdx
    mov  rax, [rsi]
    and  rax, r13
    call ra_popcnt
    cmp  ecx, ebx
    jb   .cs_push
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_wt]
    add  rsi, rdx
    mov  eax, [rsi]
    cmp  eax, r11d
    jae  .cs_next
    mov  r11d, eax
    mov  r10d, r12d
.cs_next:
    inc  r12d
    jmp  .cs_find
.cs_fdone:
    mov  r12d, r10d
.cs_push:
    mov  edx, r14d
    shl  rdx, 2
    lea  rsi, [rel ra_stk]
    add  rsi, rdx
    mov  [rsi], r12d
    inc  r14d
    mov  edx, r12d
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    not  rax
    and  r13, rax
    jmp  .cs_loop
.cs_sel:
    test r14d, r14d
    jz   .cs_done
    dec  r14d
    mov  edx, r14d
    shl  rdx, 2
    lea  rsi, [rel ra_stk]
    add  rsi, rdx
    mov  r12d, [rsi]
    mov  edx, r12d
    shl  rdx, 3
    lea  rsi, [rel ra_adj]
    add  rsi, rdx
    mov  r8, [rsi]
    and  r8, r15                     ; neighbours of this class only
    xor  r9, r9
    xor  r11d, r11d
.cs_fn:
    cmp  r11d, 64
    jae  .cs_fnd
    mov  edx, r11d
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    test r8, rax
    jz   .cs_fnn
    mov  edx, r11d
    shl  rdx, 2
    lea  rsi, [rel ra_color]
    add  rsi, rdx
    mov  eax, [rsi]
    cmp  eax, -1
    je   .cs_fnn
    mov  edx, eax
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    or   r9, rax
.cs_fnn:
    inc  r11d
    jmp  .cs_fn
.cs_fnd:
    xor  eax, eax
.cs_fc:
    cmp  eax, ebx
    jae  .cs_sel                     ; no colour free: stays in memory
    mov  edx, eax
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rcx, [rsi]
    test r9, rcx
    jz   .cs_take
    inc  eax
    jmp  .cs_fc
.cs_take:
    mov  edx, r12d
    shl  rdx, 2
    lea  rsi, [rel ra_color]
    add  rsi, rdx
    mov  [rsi], eax
    or   edi, ecx
    jmp  .cs_sel
.cs_done:
    mov  ecx, edi
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rbx
    pop  rax
    ret

; ra_popcnt(rax = set) -> ecx = how many bits, by clearing the lowest each turn
ra_popcnt:
    push rax
    push rdx
    xor  ecx, ecx
.pc_loop:
    test rax, rax
    jz   .pc_out
    mov  rdx, rax
    dec  rdx
    and  rax, rdx
    inc  ecx
    jmp  .pc_loop
.pc_out:
    pop  rdx
    pop  rax
    ret

; ra_reg_of(rdi = frame offset) -> eax = register, or -1 when the local stays
; in memory or no allocation is being applied
ra_reg_of:
    push rdx
    push rsi
    mov  eax, [rel ra_active]
    test eax, eax
    jz   .ro_mem
    mov  rdx, rdi
    call ra_cand_index
    cmp  eax, -1
    je   .ro_out
    mov  edx, eax
    shl  rdx, 2
    lea  rsi, [rel ra_color]
    add  rsi, rdx
    mov  eax, [rsi]
    jmp  .ro_out
.ro_mem:
    mov  eax, -1
.ro_out:
    pop  rsi
    pop  rdx
    ret

; ra_emit_argreg(eax = argument register 0..5) -- writes its name, in the
; order the prologue assigns them: rcx, rdx, r8, r9, r10, rax.
ra_emit_argreg:
    push rsi
    lea  rsi, [rel s_argreg0]
    cmp  eax, 1
    jne  .ag2
    lea  rsi, [rel s_argreg1]
.ag2:
    cmp  eax, 2
    jne  .ag3
    lea  rsi, [rel s_argreg2]
.ag3:
    cmp  eax, 3
    jne  .ag4
    lea  rsi, [rel s_argreg3]
.ag4:
    cmp  eax, 4
    jne  .ag5
    lea  rsi, [rel s_argreg4]
.ag5:
    cmp  eax, 5
    jne  .ag_go
    lea  rsi, [rel s_argreg5]
.ag_go:
    call emit_cstr
    pop  rsi
    ret

; ra_emit_freg(ecx = float colour 0..9) -- writes xmm6..xmm15. Preserves rcx.
ra_emit_freg:
    push rax
    push rdx
    push rsi
    push rdi
    mov  rsi, s_ra_xmm
    call emit_cstr
    mov  edi, ecx
    add  edi, 6
    call emit_uint
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rax
    ret

; ra_emit_reg(ecx = register 0..4) -- writes its name. Preserves rcx.
ra_emit_reg:
    push rsi
    mov  rsi, s_ra_reg0
    cmp  ecx, 1
    jne  .er2
    mov  rsi, s_ra_reg1
.er2:
    cmp  ecx, 2
    jne  .er3
    mov  rsi, s_ra_reg2
.er3:
    cmp  ecx, 3
    jne  .er4
    mov  rsi, s_ra_reg3
.er4:
    cmp  ecx, 4
    jne  .er_go
    mov  rsi, s_ra_reg4
.er_go:
    call emit_cstr
    pop  rsi
    ret

; ra_emit_saves(edx = 0 save, 1 restore) -- one mov per register in use.
;
; They live just above the shadow space of the grown frame: [rbp-(F'-32)],
; then 8 higher each. F' is at least slots*8 + 32 + 8*saved, so that range sits
; below every local and above the 32 bytes a callee may write. Relative to rbp,
; so restoring does not depend on where rsp happens to be.
ra_emit_saves:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    mov  r8d, edx
    mov  rbx, [rel ra_frame]
    mov  rax, [rel ra_grow]
    add  rbx, rax
    sub  rbx, 32
    xor  ecx, ecx
.sv_loop:
    cmp  ecx, RA_REGS
    jae  .sv_done
    mov  edx, ecx
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    mov  edx, [rel ra_used]
    test rdx, rax
    jz   .sv_next
    test r8d, r8d
    jnz  .sv_restore
    mov  rsi, s_ra_sv1               ; mov [rbp-N], REG
    call emit_cstr
    mov  rdi, rbx
    call emit_uint
    mov  rsi, s_ra_sv2
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .sv_adv
.sv_restore:
    mov  rsi, s_ra_st1               ; mov REG, [rbp-N]
    call emit_cstr
    call ra_emit_reg
    mov  rsi, s_ra_rs2
    call emit_cstr
    mov  rdi, rbx
    call emit_uint
    mov  rsi, s_closemem
    call emit_cstr
.sv_adv:
    sub  rbx, 8
.sv_next:
    inc  ecx
    jmp  .sv_loop
.sv_done:
    ; then the xmm registers, 16 bytes each, straight after the integers
    xor  ecx, ecx
.fv_loop:
    cmp  ecx, RA_FREGS
    jae  .fv_done
    mov  edx, ecx
    shl  rdx, 3
    lea  rsi, [rel ra_bits]
    add  rsi, rdx
    mov  rax, [rsi]
    mov  edx, [rel ra_fused]
    test rdx, rax
    jz   .fv_next
    ; rbx is where the integers stopped: the next free byte is [rbp-rbx], and
    ; a 16-byte slot starting there ends 16 higher. The area is exactly
    ; 8 * integers + 16 * xmm, rounded up, so the last slot ends at or below
    ; the first local and never on top of it.
    test r8d, r8d
    jnz  .fv_restore
    mov  rsi, s_ra_fsv1              ; movups [rbp-N], xmmK
    call emit_cstr
    mov  rdi, rbx
    call emit_uint
    mov  rsi, s_ra_sv2
    call emit_cstr
    call ra_emit_freg
    mov  rsi, s_nl
    call emit_cstr
    jmp  .fv_adv
.fv_restore:
    mov  rsi, s_ra_frs1              ; movups xmmK, [rbp-N]
    call emit_cstr
    call ra_emit_freg
    mov  rsi, s_ra_rs2
    call emit_cstr
    mov  rdi, rbx
    call emit_uint
    mov  rsi, s_closemem
    call emit_cstr
.fv_adv:
    sub  rbx, 16
.fv_next:
    inc  ecx
    jmp  .fv_loop
.fv_done:
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; ==============================================================================
; REGISTER ALLOCATION -- operating on the registers themselves
;
; ra_peep(ebx = record index) -> eax = how many records it folded, 0 for none.
;
; Runs in the flush, only while an allocation is applied. It looks for three
; exact runs of CONSECUTIVE records -- anything in between, a label, a narrowing
; of a u8, a call, and nothing matches, so the plain lowering stands:
;
;   LDLOC a  LDRCX b|IMMRCX k  ALU op  STLOC a    ->  op A, B|k       (4)
;   LDLOC a  LDRCX b|IMMRCX k  ALU cmp JCC        ->  cmp A, B|k      (3; the
;                                                     jump is written after)
;   LDRCX b|IMMRCX k  ALU op                      ->  op rax, B|k     (2)
;
; where A and B are the registers a and b were given. The first two leave rax
; without the result. That is safe: the parser builds an assignment only as a
; statement, never inside an expression, and a condition's value is consumed
; by its jump -- nothing after either reads rax before writing it.
;
; imul takes no immediate here, and only constants that surely fit a signed
; 32-bit immediate are folded; anything else keeps going through rcx.
; Preserves every register except rax.
; ==============================================================================
ra_peep:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    mov  r13d, [rel ir_count]
    mov  eax, ebx
    add  eax, 2
    cmp  eax, r13d
    ja   .pp_none                    ; need at least two records
    ; rsi, not r12, holds the record: as a base, r12 needs a SIB byte like
    ; rsp, and kasm cannot load a 32-bit register through one
    mov  esi, ebx
    shl  rsi, 4
    lea  rax, [rel ir_recs]
    add  rsi, rax                    ; rsi = record i
    mov  ecx, [rsi]
    cmp  ecx, IR_LDLOC
    je   .pp_ld
    cmp  ecx, IR_LDRCX
    je   .pp_areg
    cmp  ecx, IR_IMMRCX
    je   .pp_aimm
    jmp  .pp_none

    ; --- LDLOC a, source, ALU, then STLOC a or JCC ------------------------
.pp_ld:
    mov  eax, ebx
    add  eax, 4
    cmp  eax, r13d
    ja   .pp_none
    mov  rdi, [rsi + 8]
    call ra_reg_of
    cmp  eax, -1
    je   .pp_none
    mov  r9d, eax                    ; destination register
    call ra_peep_src                 ; record i+1 -> r10d, r11; eax = 1 if usable
    test eax, eax
    jz   .pp_none
    mov  ecx, [rsi + 32]
    cmp  ecx, IR_ALU
    jne  .pp_none
    mov  r8d, [rsi + 40]             ; the operation
    mov  ecx, [rsi + 48]
    cmp  ecx, IR_STLOC
    je   .pp_st
    cmp  ecx, IR_JCC
    jne  .pp_none
    cmp  r8d, ALU_CMP
    jne  .pp_none
    call ra_emit_alu
    mov  eax, 3
    jmp  .pp_out
.pp_st:
    mov  rax, [rsi + 56]
    mov  rdx, [rsi + 8]
    cmp  rax, rdx
    jne  .pp_none                    ; stored somewhere else: not in place
    cmp  r8d, ALU_CMP
    je   .pp_none
    cmp  r8d, ALU_IMUL
    jne  .pp_st_ok
    cmp  r10d, -1
    je   .pp_none                    ; imul with an immediate: not here
.pp_st_ok:
    call ra_emit_alu
    mov  eax, 4
    jmp  .pp_out

    ; --- source into rax's operation -------------------------------------
.pp_areg:
    mov  ecx, [rsi + 16]
    cmp  ecx, IR_ALU
    jne  .pp_none
    mov  r8d, [rsi + 24]
    mov  rdi, [rsi + 8]
    call ra_reg_of
    cmp  eax, -1
    je   .pp_none
    mov  r10d, eax
    mov  r9d, -1                     ; destination rax
    xor  r11, r11
    call ra_emit_alu
    mov  eax, 2
    jmp  .pp_out
.pp_aimm:
    mov  ecx, [rsi + 16]
    cmp  ecx, IR_ALU
    jne  .pp_none
    mov  r8d, [rsi + 24]
    cmp  r8d, ALU_IMUL
    je   .pp_none
    mov  r11, [rsi + 8]
    call ra_imm_ok
    test eax, eax
    jz   .pp_none
    mov  r10d, -1
    mov  r9d, -1
    call ra_emit_alu
    mov  eax, 2
    jmp  .pp_out

.pp_none:
    xor  eax, eax
.pp_out:
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; ra_peep_src(rsi = record i) -- reads record i+1 as the source operand.
;   LDRCX b with a register  -> r10d = its register, r11 = 0
;   IMMRCX k that fits       -> r10d = -1, r11 = the token
; eax = 1 when usable, 0 otherwise.
ra_peep_src:
    push rcx
    push rdi
    mov  ecx, [rsi + 16]
    cmp  ecx, IR_LDRCX
    je   .ps_reg
    cmp  ecx, IR_IMMRCX
    je   .ps_imm
    xor  eax, eax
    jmp  .ps_out
.ps_reg:
    mov  rdi, [rsi + 24]
    call ra_reg_of
    cmp  eax, -1
    je   .ps_no
    mov  r10d, eax
    xor  r11, r11
    mov  eax, 1
    jmp  .ps_out
.ps_imm:
    mov  r11, [rsi + 24]
    call ra_imm_ok
    test eax, eax
    jz   .ps_no
    mov  r10d, -1
    mov  eax, 1
    jmp  .ps_out
.ps_no:
    xor  eax, eax
.ps_out:
    pop  rdi
    pop  rcx
    ret

; ra_imm_ok(r11 = token, or 0 for literal zero) -> eax = 1 when the constant
; surely fits a signed 32-bit immediate. At most nine characters, starting with
; a digit, made only of digits, hex letters and the x of 0x: nine decimal digits
; stay below 2^31, and 0x plus seven hex digits below 2^28. Anything longer, or
; a character literal, is refused rather than risked.
ra_imm_ok:
    push rcx
    push rdx
    push rsi
    test r11, r11
    jz   .io_yes
    mov  rsi, [r11 + TOKEN.value]
    mov  ecx, dword [r11 + TOKEN.length]
    test ecx, ecx
    jz   .io_no
    cmp  ecx, 9
    ja   .io_no
    movzx eax, byte [rsi]
    cmp  eax, '0'
    jb   .io_no
    cmp  eax, '9'
    ja   .io_no
.io_loop:
    test ecx, ecx
    jz   .io_yes
    movzx eax, byte [rsi]
    cmp  eax, '0'
    jb   .io_no
    cmp  eax, '9'
    jbe  .io_next
    cmp  eax, 'x'
    je   .io_next
    cmp  eax, 'X'
    je   .io_next
    or   eax, 32                     ; fold A-F onto a-f
    cmp  eax, 'a'
    jb   .io_no
    cmp  eax, 'f'
    ja   .io_no
.io_next:
    inc  rsi
    dec  ecx
    jmp  .io_loop
.io_yes:
    mov  eax, 1
    jmp  .io_out
.io_no:
    xor  eax, eax
.io_out:
    pop  rsi
    pop  rdx
    pop  rcx
    ret

; ra_emit_mnem(ecx = ALU_*) -- the mnemonic. Preserves rcx.
ra_emit_mnem:
    push rax
    push rsi
    lea  rsi, [rel s_alu_tab]
    mov  eax, ecx
    shl  rax, 3
    add  rsi, rax
    mov  rsi, [rsi]
    call emit_cstr
    pop  rsi
    pop  rax
    ret

; ra_emit_alu(r8d = ALU_*, r9d = destination register or -1 for rax,
;             r10d = source register or -1 for the constant in r11)
; writes "    op DST, SRC". Preserves every register.
ra_emit_alu:
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    mov  rsi, s_alu_ind
    call emit_cstr
    mov  ecx, r8d
    call ra_emit_mnem
    mov  rsi, s_alu_sp
    call emit_cstr
    cmp  r9d, -1
    jne  .ea_dreg
    mov  rsi, s_alu_rax
    call emit_cstr
    jmp  .ea_src
.ea_dreg:
    mov  ecx, r9d
    call ra_emit_reg
.ea_src:
    mov  rsi, s_alu_cm
    call emit_cstr
    cmp  r10d, -1
    jne  .ea_sreg
    test r11, r11
    jz   .ea_zero
    mov  rdi, r11
    call emit_tok
    jmp  .ea_nl
.ea_zero:
    xor  rdi, rdi
    call emit_uint
    jmp  .ea_nl
.ea_sreg:
    mov  ecx, r10d
    call ra_emit_reg
.ea_nl:
    mov  rsi, s_nl
    call emit_cstr
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rax
    ret

; ra_cand_index(rdx = frame offset) -> eax = candidate index, or -1
ra_cand_index:
    push rcx
    push rsi
    xor  eax, eax
.ci_loop:
    mov  ecx, [rel ra_ncand]
    cmp  eax, ecx
    jae  .ci_none
    mov  ecx, eax
    shl  rcx, 3
    lea  rsi, [rel ra_cand]
    add  rsi, rcx
    mov  rcx, [rsi]
    cmp  rcx, rdx
    je   .ci_found
    inc  eax
    jmp  .ci_loop
.ci_none:
    mov  eax, -1
.ci_found:
    pop  rsi
    pop  rcx
    ret

; ra_open_block(ebx = first record) -- start a block; skip if the table is full
ra_open_block:
    push rax
    push rdx
    push rsi
    mov  eax, [rel ra_nblk]
    cmp  eax, RA_MAXBLK
    jb   .ob_ok
    mov  dword [rel ra_skip], 1
    jmp  .ob_out
.ob_ok:
    mov  edx, eax
    shl  rdx, 2
    lea  rsi, [rel ra_bstart]
    add  rsi, rdx
    mov  [rsi], ebx
    lea  rsi, [rel ra_bend]
    add  rsi, rdx
    mov  [rsi], ebx
    mov  [rel ra_cur], eax
    inc  eax
    mov  [rel ra_nblk], eax
.ob_out:
    pop  rsi
    pop  rdx
    pop  rax
    ret

; ra_close_block(ebx = end, exclusive) -- close the current block
ra_close_block:
    push rax
    push rdx
    push rsi
    mov  eax, [rel ra_cur]
    cmp  eax, -1
    je   .cb_out
    mov  edx, eax
    shl  rdx, 2
    lea  rsi, [rel ra_bend]
    add  rsi, rdx
    mov  [rsi], ebx
.cb_out:
    pop  rsi
    pop  rdx
    pop  rax
    ret

; ra_label_block(rdx = label id) -> eax = its block, or -1 with ra_skip set.
; The stamp says whether the entry belongs to this function; a jump to a label
; the function never defined is something the analysis cannot reason about.
ra_label_block:
    push rsi
    push rcx
    cmp  rdx, RA_MAXLBL
    jae  .lb_bad
    mov  rcx, rdx
    shl  rcx, 2
    lea  rsi, [rel ra_lblgen]
    add  rsi, rcx
    mov  eax, [rsi]
    cmp  eax, [rel ra_gen]
    jne  .lb_bad
    lea  rsi, [rel ra_lblblk]
    add  rsi, rcx
    mov  eax, [rsi]
    pop  rcx
    pop  rsi
    ret
.lb_bad:
    mov  dword [rel ra_skip], 1
    mov  eax, -1
    pop  rcx
    pop  rsi
    ret

; ra_in_of(eax = block, or -1) -> rax = its in set, or 0
ra_in_of:
    push rsi
    push rdx
    cmp  eax, -1
    je   .io_zero
    mov  edx, eax
    shl  rdx, 3
    lea  rsi, [rel ra_in]
    add  rsi, rdx
    mov  rax, [rsi]
    pop  rdx
    pop  rsi
    ret
.io_zero:
    xor  eax, eax
    pop  rdx
    pop  rsi
    ret

; ir_begin() -- start capturing a function. Preserves every register.
ir_begin:
    mov  dword [rel ra_asm], 0
    mov  dword [rel ir_count], 0
    mov  qword [rel ir_text_len], 0
    mov  dword [rel ir_on], 1
    ret

; ir_end() -- stop capturing and write the function out, record by record.
; Preserves every register: it runs at the exit of cg_function.
ir_end:
    mov  dword [rel ir_on], 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    call ra_analyze                  ; liveness, conflicts, colours
    ; the allocation applies to this flush only; ir_emit_kind is also used for
    ; code written straight out, where it must not
    mov  dword [rel ra_active], 0
    mov  eax, [rel ra_skip]
    test eax, eax
    jnz  .ie_noact
    mov  eax, [rel ra_enable]
    test eax, eax
    jz   .ie_noact
    mov  dword [rel ra_active], 1
.ie_noact:
    call ra_trace_head
    xor  ebx, ebx
.ie_loop:
    mov  eax, [rel ir_count]
    cmp  ebx, eax
    jae  .ie_done
    call ra_trace_blk                ; ebx = record about to be written
    mov  eax, [rel ra_active]
    test eax, eax
    jz   .ie_nopeep
    call ra_peep                     ; eax = records it folded into one
    test eax, eax
    jz   .ie_nopeep
    add  ebx, eax
    jmp  .ie_loop
.ie_nopeep:
    mov  ecx, ebx
    shl  rcx, 4
    lea  rdi, [rel ir_recs]
    add  rdi, rcx
    mov  ecx, [rdi]
    cmp  ecx, IR_RAW
    jne  .ie_struct
    mov  rsi, [rdi + 8]
    lea  rcx, [rel ir_text]
    add  rsi, rcx
    mov  edx, [rdi + 4]
    call emit_direct
    jmp  .ie_next
.ie_struct:
    push rdi
    mov  edx, [rdi + 4]          ; condition, for IR_JCC
    mov  rdi, [rdi + 8]
    call ir_emit_kind            ; ecx = kind, rdi = operand
    pop  rdi
.ie_next:
    inc  ebx
    jmp  .ie_loop
.ie_done:
    mov  dword [rel ra_active], 0
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; emit_cstr(rsi=ptr null-terminated)
emit_cstr:
    push rdx
    push rsi
    xor  rdx, rdx
.len:
    cmp  byte [rsi], 0
    je   .go
    inc  rsi
    inc  rdx
    jmp  .len
.go:
    pop  rsi
    call emit_bytes
    pop  rdx
    ret

; emit_tok(rdi=token ptr) -- emits the source text of the token
emit_tok:
    push rdx
    push rsi
    mov  rsi, [rdi + TOKEN.value]
    mov  edx, dword [rdi + TOKEN.length]
    call emit_bytes
    pop  rsi
    pop  rdx
    ret

; cg_emit_ftok(rdi = real literal token): as written, but 2e6 comes out as
; 2.0e6 -- NASM reads a real only with a point in it
cg_emit_ftok:
    push rbx
    push r12
    push r13
    mov  r12, [rdi + TOKEN.value]
    mov  r13d, dword [rdi + TOKEN.length]
    xor  ebx, ebx
.ft_find:
    cmp  ebx, r13d
    jae  .ft_plain
    cmp  byte [r12 + rbx], '.'
    je   .ft_plain
    cmp  byte [r12 + rbx], 'e'
    je   .ft_split
    cmp  byte [r12 + rbx], 'E'
    je   .ft_split
    inc  ebx
    jmp  .ft_find
.ft_split:
    mov  rsi, r12
    mov  edx, ebx
    call emit_bytes
    mov  rsi, s_point_zero
    call emit_cstr
    lea  rsi, [r12 + rbx]
    mov  edx, r13d
    sub  edx, ebx
    call emit_bytes
    jmp  .ft_out
.ft_plain:
    mov  rsi, r12
    mov  edx, r13d
    call emit_bytes
.ft_out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; emit_tok_raw: emits a string literal WITHOUT its quotes (asm blocks)
emit_tok_raw:
    push rdx
    push rsi
    mov  rsi, [rdi + TOKEN.value]
    mov  edx, dword [rdi + TOKEN.length]
    cmp  edx, 2
    jbe  .empty
    cmp  byte [rsi], '"'
    jne  .plain
    inc  rsi
    sub  edx, 2
.plain:
    call emit_bytes
.empty:
    pop  rsi
    pop  rdx
    ret

; emit_uint(rdi=unsigned value)
emit_uint:
    push rbx
    push rsi
    sub  rsp, 32
    mov  rax, rdi
    lea  rsi, [rsp+31]
    mov  byte [rsi], 0
    mov  rbx, 10
    test rax, rax
    jnz  .cv
    dec  rsi
    mov  byte [rsi], '0'
    jmp  .emit
.cv:
    dec  rsi
    xor  rdx, rdx
    div  rbx
    add  dl, '0'
    mov  [rsi], dl
    test rax, rax
    jnz  .cv
.emit:
    call emit_cstr
    add  rsp, 32
    pop  rsi
    pop  rbx
    ret

; new_label() -> rax = a new integer id
new_label:
    mov  eax, [rel cg_label]
    inc  dword [rel cg_label]
    ret

; ==============================================================================
; var table
; cg_add_var(rdi=token ptr) -> rax = offset magnitude
; ==============================================================================
; cg_add_var(rdi=token ptr, rsi=slot count) -> rax = base offset
; var_count counts VARIABLES (one entry per name); the offset accumulates slots.
cg_add_var:
    test rsi, rsi
    jnz  .have_n
    mov  rsi, 1
.have_n:
    ; If a variable with this name already exists, REUSE its slot so that
    ; re-declaring a name (e.g. 'i' in a second for-loop) maps every
    ; reference to a single, consistent stack offset.
    push rsi
    push rdi
    call cg_find_var_idx             ; eax = index or -1
    pop  rdi
    pop  rsi
    cmp  eax, -1
    je   .fresh
    ; reuse slot: refresh its type flags from the pending_* values,
    ; then clear pending and return the existing offset.
    mov  ecx, eax                    ; index
    lea  r9, [rel var_structs]
    mov  r11d, [rel pending_struct]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_struct], -1
    lea  r9, [rel var_elemsz]
    mov  r11d, [rel pending_elem]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_elem], 0
    lea  r9, [rel var_isfloat]
    mov  r11d, [rel pending_float]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_float], 0
    lea  r9, [rel var_unsigned]
    mov  r11d, [rel pending_unsigned]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_unsigned], 0
    lea  r9, [rel var_isref]
    mov  r11d, [rel pending_ref]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_ref], 0
    lea  r9, [rel var_arrlen]
    mov  r11d, [rel pending_arrlen]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_arrlen], 0
    lea  r9, [rel var_stride]
    mov  r11d, [rel pending_stride]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_stride], 0
    lea  r9, [rel var_aw]
    mov  r11d, [rel pending_aw]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_aw], 0
    lea  r9, [rel var_vtag]
    mov  r11d, [rel pending_vtag]
    mov  [r9 + rcx*4], r11d
    mov  dword [rel pending_vtag], 0
    lea  r9, [rel var_offs]
    mov  eax, [r9 + rcx*4]           ; existing offset
    ret
.fresh:
    mov  eax, [rel var_count]
    cmp  eax, CG_MAX_VARS
    jae  .full
    mov  ecx, eax
    ; previous offset (0 if this is the first variable)
    lea  r9, [rel var_offs]
    xor  edx, edx
    test ecx, ecx
    jz   .first
    mov  edx, [r9 + rcx*4 - 4]
.first:
    ; new offset = previous + n*8
    mov  r10d, esi
    shl  r10d, 3
    add  edx, r10d
    ; register token and offset at the SAME position
    lea  r8, [rel var_toks]
    mov  [r8 + rcx*8], rdi
    mov  [r9 + rcx*4], edx
    ; attach the pending struct id (if any) to this variable
    lea  r8, [rel var_structs]
    mov  r11d, [rel pending_struct]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_struct], -1
    lea  r8, [rel var_elemsz]
    mov  r11d, [rel pending_elem]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_elem], 0
    lea  r8, [rel var_isfloat]
    mov  r11d, [rel pending_float]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_float], 0
    lea  r8, [rel var_unsigned]
    mov  r11d, [rel pending_unsigned]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_unsigned], 0
    lea  r8, [rel var_isref]
    mov  r11d, [rel pending_ref]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_ref], 0
    lea  r8, [rel var_arrlen]
    mov  r11d, [rel pending_arrlen]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_arrlen], 0
    lea  r8, [rel var_stride]
    mov  r11d, [rel pending_stride]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_stride], 0
    lea  r8, [rel var_aw]
    mov  r11d, [rel pending_aw]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_aw], 0
    lea  r8, [rel var_vtag]
    mov  r11d, [rel pending_vtag]
    mov  [r8 + rcx*4], r11d
    mov  dword [rel pending_vtag], 0
    ; a single new entry
    inc  eax
    mov  [rel var_count], eax
    mov  eax, edx
    ret
.full:
    mov  byte [rel cg_had_error], 1
    mov  byte [rel dbg_which], 2
    xor  eax, eax
    ret

; cg_emit_idx_base(rdi = array name token)
; Emits 'lea rdx, [rbp-OFF]' for a local array, or
; 'lea rdx, [rel __g_NAME]' for a file-scope global array.
; ==============================================================================
; The loop stack: which labels 'break' and 'continue' mean right now.
;   cg_loop_push(edi = end label, esi = continue label)
;   cg_loop_pop()
;   cg_loop_brk()  -> eax = end label of the innermost loop, -1 outside any
;   cg_loop_cont() -> eax = its continue label, -1 outside any
; Loops nest as deep as CG_MAX_LOOPS; past that the extra levels are not
; recorded, and break and continue there fall back to the deepest one kept.
; ==============================================================================
cg_loop_push:
    push rax
    push rcx
    mov  eax, [rel loop_depth]
    cmp  eax, CG_MAX_LOOPS
    jae  .lp_full
    lea  rcx, [rel loop_brk]
    mov  [rcx + rax*4], edi
    lea  rcx, [rel loop_cont]
    mov  [rcx + rax*4], esi
.lp_full:
    inc  eax
    mov  [rel loop_depth], eax
    pop  rcx
    pop  rax
    ret

cg_loop_pop:
    push rax
    mov  eax, [rel loop_depth]
    test eax, eax
    jz   .lo_out
    dec  eax
    mov  [rel loop_depth], eax
.lo_out:
    pop  rax
    ret

cg_loop_brk:
    push rcx
    mov  eax, [rel loop_depth]
    test eax, eax
    jz   .lb_none
    dec  eax
    cmp  eax, CG_MAX_LOOPS
    jb   .lb_ok
    mov  eax, CG_MAX_LOOPS - 1
.lb_ok:
    lea  rcx, [rel loop_brk]
    mov  eax, [rcx + rax*4]
    jmp  .lb_out
.lb_none:
    mov  eax, -1
.lb_out:
    pop  rcx
    ret

cg_loop_cont:
    push rcx
    mov  eax, [rel loop_depth]
    test eax, eax
    jz   .lc_none
    dec  eax
    cmp  eax, CG_MAX_LOOPS
    jb   .lc_ok
    mov  eax, CG_MAX_LOOPS - 1
.lc_ok:
    lea  rcx, [rel loop_cont]
    mov  eax, [rcx + rax*4]
    jmp  .lc_out
.lc_none:
    mov  eax, -1
.lc_out:
    pop  rcx
    ret

; ==============================================================================
; cg_index_len(rdi = array name token) -> eax = its element count, 0 when it
; is not known: a local or global array declared with a size gives it; a
; parameter, a pointer or anything else gives 0 and goes unchecked.
; ==============================================================================
cg_index_len:
    push rbx
    push rcx
    mov  rbx, rdi
    call cg_find_var_idx
    cmp  eax, -1
    je   .il_global
    lea  rcx, [rel var_arrlen]
    mov  eax, [rcx + rax*4]
    jmp  .il_out
.il_global:
    mov  rdi, rbx
    call cg_find_global
    cmp  eax, -1
    je   .il_none
    lea  rcx, [rel g_arrlen]
    mov  eax, [rcx + rax*4]
    jmp  .il_out
.il_none:
    xor  eax, eax
.il_out:
    pop  rcx
    pop  rbx
    ret

; ==============================================================================
; cg_emit_bounds(edi = element count) -- with the index in rax:
;
;       cmp rax, COUNT
;       jb  .Lok
;       <record the cause and the hint, raise the flag, rax = 0>
;       jmp .__ret_N
;   .Lok:
;
; Exactly what a 'fail' statement does at that point: the function stops and
; returns 0, and the caller sees it with failed(). The comparison is unsigned,
; so a negative index counts as a huge one and is caught the same way. Sizes
; that do not fit a 32-bit immediate are left unchecked rather than risked.
; ==============================================================================
cg_emit_bounds:
    push rbx
    push r12
    mov  ebx, edi
    test ebx, ebx
    jl   .eb_out                     ; jl, not js: kasm is proven on jl, and
                                     ; after test the two mean the same
    mov  rsi, s_bnd_cmp
    call emit_cstr
    mov  edi, ebx
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    call new_label
    mov  r12d, eax
    mov  edi, r12d
    mov  edx, CC_B
    call ir_jcc
    mov  rsi, s_bnd_fail
    call emit_cstr
    call kt_failcall
    mov  rsi, s_bnd_fail2
    call emit_cstr
    mov  edi, [rel cur_ret_id]
    mov  eax, IR_JMPRET
    call ir_ctl
    mov  edi, r12d
    mov  eax, IR_LABEL
    call ir_ctl
.eb_out:
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_emit_index_value(rdi = AST_INDEX node) -> the flat element index in rax
;
; One subscript emits the index as written. Two subscripts on a 2-D array
; collapse to i * row_len + j, because the storage is flat, row by row.
; Used by the read path and by both assignment paths; having the read alone
; do the multiply meant every write landed on m[i].
; ==============================================================================
cg_emit_index_value:
    push r12
    push r13
    mov  r13, rdi
    mov  rdi, [r13 + AST.right]
    call cg_emit                  ; first index in rax
    mov  rdi, [r13 + AST.left]
    test rdi, rdi
    jz   .one
    mov  rdi, [r13 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .one
    lea  rcx, [rel var_stride]
    mov  ecx, [rcx + rax*4]
    test ecx, ecx
    jz   .one
    push rcx
    mov  rsi, s_imul_rax_pre
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_pushrax
    call emit_cstr
    mov  rdi, [r13 + AST.left]
    call cg_emit                  ; second index
    mov  rsi, s_add_rax_pop
    call emit_cstr
.one:
    ; Every read and every write of an element comes through here, so this is
    ; the one place the bounds are checked. An array whose size is not known
    ; -- a parameter, which arrives as a bare address -- is not checked yet.
    mov  rdi, [r13 + AST.data]
    call cg_index_len
    test eax, eax
    jz   .nochk
    mov  edi, eax
    call cg_emit_bounds
.nochk:
    pop  r13
    pop  r12
    ret

; ==============================================================================
; cg_emit_struct_lit(rdi = AST_STRUCT_LIT, esi = base offset of the target)
;
; Writes each field straight into the destination. A struct literal does not
; fit in a register, so there is no value to return: it is emitted where it
; lands.
;
; Fields not mentioned are left alone. The frame is not cleared, so a named
; literal that omits a field leaves whatever was there -- worth knowing until
; zero-initialisation exists.
; ==============================================================================
cg_emit_struct_lit:
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov  r12, rdi
    mov  r15d, esi                   ; base offset
    mov  rdi, [r12 + AST.data]       ; type name token
    call cg_find_struct
    cmp  eax, -1
    je   .sl_out
    mov  r14d, eax                   ; struct id
    mov  r13, [r12 + AST.right]      ; first initialiser
    xor  ebx, ebx                    ; positional counter
.sl_loop:
    test r13, r13
    jz   .sl_out
    ; which field is this?
    mov  rdi, [r13 + AST.data]
    test rdi, rdi
    jz   .sl_bypos
    mov  rsi, rdi
    mov  edi, r14d
    call cg_field_index
    cmp  eax, -1
    je   .sl_next
    jmp  .sl_have
.sl_bypos:
    mov  eax, ebx
.sl_have:
    ; absolute index into the flat field arrays
    push rax
    lea  rcx, [rel struct_first]
    mov  ecx, [rcx + r14*4]
    pop  rax
    add  eax, ecx
    lea  rcx, [rel field_offs]
    mov  edx, [rcx + rax*4]
    push rdx                         ; byte offset inside the struct
    lea  rcx, [rel field_isfloat]
    mov  ecx, [rcx + rax*4]
    push rcx
    ; value -> rax or xmm0
    mov  rdi, [r13 + AST.left]
    pop  rcx
    push rcx
    test ecx, ecx
    jz   .sl_int
    call cg_emit_float
    pop  rcx
    pop  rdx
    mov  esi, r15d
    sub  esi, edx                    ; effective offset
    push rsi
    mov  rsi, s_st_xmm_pre
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_st_xmm_suf
    call emit_cstr
    jmp  .sl_next
.sl_int:
    call cg_emit
    pop  rcx
    pop  rdx
    mov  esi, r15d
    sub  esi, edx
    push rsi
    ; Written as text on purpose, not as IR_STLOC. The slots of an array or a
    ; struct are read back through a base address plus an offset, so only the
    ; base ever appears in the code as [rbp-N]. Recorded as plain local stores,
    ; the other slots looked like ordinary variables to the register allocator,
    ; which put them in registers -- and the memory the reads go to was never
    ; written. As text, every slot shows up as [rbp-N] and stays in memory.
    mov  rsi, s_movmemrax
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_movmemrax2
    call emit_cstr
.sl_next:
    inc  ebx
    mov  r13, [r13 + AST.right]
    jmp  .sl_loop
.sl_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret


; ==============================================================================
; cg_emit_array_lit(rdi = AST_ARRAY_LIT, esi = base offset of the target,
;                   edx = 1 when the elements are doubles)
;
; Writes the elements straight into the slots, like a struct literal. Element
; k lands at base - k*8, which is the layout cg_emit_idx_base assumes.
;
; Elements past the declared length are dropped; a shorter list leaves the
; rest of the array as it was, since the frame is not cleared.
; ==============================================================================
cg_emit_array_lit:
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov  r12, rdi
    mov  r14d, esi                   ; base offset
    mov  r15d, edx                   ; float elements?
    mov  r13, [r12 + AST.right]
    xor  ebx, ebx                    ; element index
.al_loop:
    test r13, r13
    jz   .al_out
    mov  rdi, [r13 + AST.left]
    test r15d, r15d
    jz   .al_int
    call cg_emit_float
    mov  eax, ebx
    shl  eax, 3
    cmp  dword [rel cur_lit_aw], 4
    jne  .al_f8
    mov  eax, ebx
    shl  eax, 2                      ; [f32; N]: four bytes apart
.al_f8:
    mov  ecx, r14d
    sub  ecx, eax
    push rcx
    mov  rsi, s_st_xmm_pre
    cmp  dword [rel cur_lit_aw], 4
    jne  .al_fpre
    mov  rsi, s_cvt_d2s
    call emit_cstr
    mov  rsi, s_st_ss_pre
.al_fpre:
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_st_xmm_suf
    call emit_cstr
    jmp  .al_next
.al_int:
    call cg_emit
    mov  eax, [rel cur_lit_aw]
    cmp  eax, 1
    je   .al_narrow
    cmp  eax, 2
    je   .al_narrow
    cmp  eax, 4
    je   .al_narrow
    mov  eax, ebx
    shl  eax, 3
    mov  ecx, r14d
    sub  ecx, eax
    push rcx
    ; Written as text on purpose, not as IR_STLOC. The slots of an array or a
    ; struct are read back through a base address plus an offset, so only the
    ; base ever appears in the code as [rbp-N]. Recorded as plain local stores,
    ; the other slots looked like ordinary variables to the register allocator,
    ; which put them in registers -- and the memory the reads go to was never
    ; written. As text, every slot shows up as [rbp-N] and stays in memory.
    mov  rsi, s_movmemrax
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_movmemrax2
    call emit_cstr
.al_next:
    inc  ebx
    mov  r13, [r13 + AST.right]
    jmp  .al_loop
.al_narrow:
    ; element i of a packed array sits i * width bytes above the base
    mov  ecx, ebx
    imul ecx, eax
    mov  edx, r14d
    sub  edx, ecx
    push rax
    push rdx
    mov  rsi, s_movmem_pre
    call emit_cstr
    pop  rdi
    call emit_uint
    pop  rax
    mov  rsi, s_st1_suf
    cmp  eax, 1
    je   .al_nsuf
    mov  rsi, s_st2_suf
    cmp  eax, 2
    je   .al_nsuf
    mov  rsi, s_st4_suf
.al_nsuf:
    call emit_cstr
    jmp  .al_next
.al_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_arr_aw(rdi = array name token) -> eax = bytes per element: 1, 2, 4 or 8
; cg_arr_unsigned(rdi = array name token) -> eax = 1 when the elements are
;   unsigned (u8..u64), which decides zero or sign extension on a read
; Locals first, then globals; anything unknown is eight bytes, as before.
; ==============================================================================
cg_arr_aw:
    push rbx
    mov  rbx, rdi
    call cg_find_var_idx
    cmp  eax, -1
    je   .aw_glob
    lea  rcx, [rel var_aw]
    mov  eax, [rcx + rax*4]
    jmp  .aw_fix
.aw_glob:
    mov  rdi, rbx
    call cg_find_global
    cmp  eax, -1
    je   .aw_eight
    lea  rcx, [rel g_aw]
    mov  eax, [rcx + rax*4]
.aw_fix:
    cmp  eax, 1
    je   .aw_out
    cmp  eax, 2
    je   .aw_out
    cmp  eax, 4
    je   .aw_out
.aw_eight:
    mov  eax, 8
.aw_out:
    pop  rbx
    ret

cg_arr_unsigned:
    push rbx
    mov  rbx, rdi
    call cg_find_var_idx
    cmp  eax, -1
    je   .au_glob
    lea  rcx, [rel var_unsigned]
    mov  eax, [rcx + rax*4]
    jmp  .au_out
.au_glob:
    mov  rdi, rbx
    call cg_find_global
    cmp  eax, -1
    je   .au_no
    lea  rcx, [rel g_unsigned]
    mov  eax, [rcx + rax*4]
    jmp  .au_out
.au_no:
    xor  eax, eax
.au_out:
    pop  rbx
    ret

; cg_emit_elem_read(rdi = array name token): with the index in rcx and the
; base in rdx, load the element into rax at its own width
cg_emit_elem_read:
    push rbx
    push r12
    mov  r12, rdi
    call cg_arr_aw
    mov  ebx, eax
    mov  rdi, r12
    call cg_arr_unsigned
    mov  rsi, s_rd_i
    cmp  ebx, 8
    je   .er_go
    cmp  ebx, 4
    jne  .er_not4
    mov  rsi, s_rd_s4
    test eax, eax
    jz   .er_go
    mov  rsi, s_rd_u4
    jmp  .er_go
.er_not4:
    cmp  ebx, 2
    jne  .er_one
    mov  rsi, s_rd_s2
    test eax, eax
    jz   .er_go
    mov  rsi, s_rd_u2
    jmp  .er_go
.er_one:
    mov  rsi, s_rd_s1
    test eax, eax
    jz   .er_go
    mov  rsi, s_rd_u1
.er_go:
    call emit_cstr
    pop  r12
    pop  rbx
    ret

; cg_emit_elem_write(rdi = array name token): store rax at [rdx + rcx*width]
cg_emit_elem_write:
    call cg_arr_aw
    mov  rsi, s_wr_i
    cmp  eax, 8
    je   .ew_go
    mov  rsi, s_wr_4
    cmp  eax, 4
    je   .ew_go
    mov  rsi, s_wr_2
    cmp  eax, 2
    je   .ew_go
    mov  rsi, s_wr_1
.ew_go:
    call emit_cstr
    ret

cg_emit_idx_base:
    push r12
    mov  r12, rdi
    call cg_find_var_idx             ; eax = local index or -1
    cmp  eax, -1
    je   .glob
    ; An array PARAMETER holds the address the caller passed, so the base is
    ; loaded, not computed: 'mov rdx, [rbp-OFF]' rather than 'lea'.
    lea  rcx, [rel var_isref]
    mov  ecx, [rcx + rax*4]
    test ecx, ecx
    jnz  .byref
    ; local: lea rdx, [rbp-OFF]
    mov  rsi, s_lea_loc
    call emit_cstr
    mov  rdi, r12
    call cg_find_var
    mov  edi, eax
    call emit_uint
    mov  rsi, s_lea_loc2
    call emit_cstr
    jmp  .done
.byref:
    mov  rsi, s_ld_loc
    call emit_cstr
    mov  rdi, r12
    call cg_find_var
    mov  edi, eax
    call emit_uint
    mov  rsi, s_lea_loc2
    call emit_cstr
    jmp  .done
.glob:
    ; global: lea rdx, [rel __g_NAME]
    mov  rsi, s_lea_glbp
    call emit_cstr
    mov  rdi, r12
    call cg_emit_gtok
    mov  rsi, s_lea_glbs
    call emit_cstr
.done:
    pop  r12
    ret

; cg_find_var(rdi=token ptr) -> rax = offset magnitudee (0 if not found)
cg_find_var:
    push rbx
    push r12
    push r13
    push r14
    mov  r12, rdi
    mov  r13d, [rel var_count]
    ; search from the LAST declared variable backwards, so a re-declared
    ; name resolves to its most recent slot (lexical shadowing).
    mov  r14d, r13d
    dec  r14d
.loop:
    test r14d, r14d
    js   .notfound
    lea  rbx, [rel var_toks]
    mov  rbx, [rbx + r14*8]
    mov  rdi, r12
    mov  rsi, rbx
    call tok_equal
    test rax, rax
    jnz  .found
    dec  r14d
    jmp  .loop
.found:
    lea  r9, [rel var_offs]
    mov  eax, [r9 + r14*4]
    jmp  .ret
.notfound:
    xor  eax, eax
.ret:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; tok_equal(rdi=tokA, rsi=tokB) -> rax=1 if same text
tok_equal:
    push rbx
    mov  eax, dword [rdi + TOKEN.length]
    mov  ebx, dword [rsi + TOKEN.length]
    cmp  eax, ebx
    jne  .no
    mov  r8, [rdi + TOKEN.value]
    mov  r9, [rsi + TOKEN.value]
    xor  rcx, rcx
.cmp:
    cmp  ecx, eax
    jae  .yes
    mov  dl, [r8 + rcx]
    cmp  dl, [r9 + rcx]
    jne  .no
    inc  rcx
    jmp  .cmp
.yes:
    mov  rax, 1
    pop  rbx
    ret
.no:
    xor  rax, rax
    pop  rbx
    ret

; name_is_main(rdi=token ptr) -> rax=1 if the text == "main"
name_is_main:
    mov  eax, dword [rdi + TOKEN.length]
    cmp  eax, 4
    jne  .no
    mov  r8, [rdi + TOKEN.value]
    cmp  byte [r8+0], 'm'
    jne  .no
    cmp  byte [r8+1], 'a'
    jne  .no
    cmp  byte [r8+2], 'i'
    jne  .no
    cmp  byte [r8+3], 'n'
    jne  .no
    mov  rax, 1
    ret
.no:
    xor  rax, rax
    ret

jup_codegen_set_target:
    mov  [rel cg_target], dil
    ; the freestanding header is used for bare and for KRN system executables
    cmp  dil, TARGET_BARE
    je   .freestanding
    cmp  dil, TARGET_KRN
    je   .freestanding
    mov  byte [rel cg_bare], 0
    ret
.freestanding:
    mov  byte [rel cg_bare], 1
    ret

; ==============================================================================
; jup_codegen_run(rdi = ast_root) -> rax = 1 OK / 0 error
; ==============================================================================
jup_codegen_run:
    push r12
    mov  r12, rdi
    mov  [rel cg_root], rdi
    mov  dword [rel pending_struct], -1
    mov  dword [rel cg_pool_n], 0
    mov  dword [rel lq_n], 0
    mov  dword [rel lq_done], 0
    mov  dword [rel cg_lam_cur], -1
    mov  dword [rel cg_in_raw], 0
    ; pick the preamble that matches the output target
    mov  al, [rel cg_target]
    cmp  al, TARGET_ELF
    je   .elf_hdr
    cmp  byte [rel cg_bare], 0
    jne  .bare_hdr
    lea  rsi, [rel hdr]
    mov  rdx, hdr_len
    call emit_bytes
    lea  rsi, [rel hdrtrace]
    mov  rdx, hdrtrace_len
    call emit_bytes
    jmp  .hdr_done
.elf_hdr:
    lea  rsi, [rel hdrelf]
    mov  rdx, hdrelf_len
    call emit_bytes
    lea  rsi, [rel hdrtrace]
    mov  rdx, hdrtrace_len
    call emit_bytes
    jmp  .hdr_done
.bare_hdr:
    lea  rsi, [rel hdrbare]
    mov  rdx, hdrbare_len
    call emit_bytes
.hdr_done:
    ; --- pre-pass: record every function name so &fn resolves in any order ---
    mov  dword [rel fn_count], 0
    mov  dword [rel gs_count], 0
    mov  dword [rel ce_count], 0
    mov  dword [rel cg_cur_fn], -1
    mov  byte [rel cg_dyn_thread], 0
    mov  qword [rel cg_thread_tok], 0
    mov  rdi, r12
.prepass:
    test rdi, rdi
    jz   .prepass_done
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_PROGRAM
    jne  .prepass_done
    mov  rcx, [rdi + AST.left]
    test rcx, rcx
    jz   .pp_next
    mov  rax, [rcx + AST.node_type]
    ; Structs are registered in this pre-pass, before any code is emitted, so
    ; a struct may hold a field of a type declared further down the file. The
    ; walk below registers nothing now.
    cmp  rax, AST_STRUCT_DEF
    jne  .pp_notstruct
    push rdi
    mov  rdi, rcx
    call cg_register_struct_name
    pop  rdi
    jmp  .pp_next
.pp_notstruct:
    cmp  rax, AST_ENUM_DEF
    jne  .pp_notenum
    push rdi
    mov  rdi, rcx
    call cg_register_enum
    pop  rdi
    jmp  .pp_next
.pp_notenum:
    cmp  rax, AST_VAR_DECL
    jne  .pp_notvar
    ; every global, with its 'shared' mark, before any function is emitted:
    ; a function may use a global declared further down the file
    mov  eax, [rel gs_count]
    cmp  eax, CG_MAX_GLOBALS
    jae  .pp_next
    mov  rdx, [rcx + AST.data]
    lea  r8, [rel gs_toks]
    mov  [r8 + rax*8], rdx
    movzx edx, word [rcx + AST.col]
    shr  edx, 2
    and  edx, 1
    lea  r8, [rel gs_shared]
    mov  [r8 + rax*4], edx
    inc  eax
    mov  [rel gs_count], eax
    jmp  .pp_next
.pp_notvar:
    cmp  rax, AST_FUNCTION
    jne  .pp_next
    mov  rax, [rcx + AST.data]       ; name token
    test rax, rax
    jz   .pp_next
    mov  ecx, [rel fn_count]
    cmp  ecx, CG_MAX_FUNCS
    jae  .pp_next                    ; table full: skip, direct calls still work
    lea  rdx, [rel fn_toks]
    mov  [rdx + rcx*8], rax
    lea  rdx, [rel fn_nodes]
    mov  r11, [rdi + AST.left]
    mov  [rdx + rcx*8], r11
    ; record whether this function returns float (AST.col of the fn node)
    push rcx
    mov  rax, [rdi + AST.left]       ; fn node (AST_PROGRAM.left)
    movzx eax, word [rax + AST.col]
    mov  r11d, eax
    shr  r11d, 1
    and  r11d, 1                     ; bit1 = the return type is u8..u64
    lea  rdx, [rel fn_ret_unsig]
    mov  [rdx + rcx*4], r11d
    mov  r11d, eax
    shr  r11d, 8
    lea  rdx, [rel fn_ret_vtag]
    mov  [rdx + rcx*4], r11d         ; bits 8-15 = what it returns: text...
    mov  r11, [rdi + AST.left]
    mov  r11d, [r11 + AST.child_count]
    lea  rdx, [rel fn_multi]
    mov  [rdx + rcx*4], r11d         ; several results
    and  eax, 1                      ; bit0 = float
    lea  rdx, [rel fn_ret_float]
    mov  [rdx + rcx*4], eax
    pop  rcx
    inc  ecx
    mov  [rel fn_count], ecx
.pp_next:
    mov  rdi, [rdi + AST.right]
    jmp  .prepass
.prepass_done:
    ; every global, now that every struct name is known
    push rdi
    mov  rdi, r12
.gnote_loop:
    test rdi, rdi
    jz   .gnote_done
    cmp  qword [rdi + AST.node_type], AST_PROGRAM
    jne  .gnote_done
    mov  rcx, [rdi + AST.left]
    test rcx, rcx
    jz   .gnote_next
    mov  rax, [rcx + AST.node_type]
    cmp  rax, AST_VAR_DECL
    je   .gnote_one
    cmp  rax, AST_CONST_DECL
    jne  .gnote_next
.gnote_one:
    push rdi
    mov  rdi, rcx
    call cg_global_note
    pop  rdi
.gnote_next:
    mov  rdi, [rdi + AST.right]
    jmp  .gnote_loop
.gnote_done:
    pop  rdi
    ; Measure the fields. Sizing 'Box { min: Vec3; }' needs Vec3's size, and
    ; Vec3 may be measured later in the file, so one pass leaves the field
    ; eight bytes wide -- or zero -- and every offset after it collapses.
    ; The pass is repeated until the sizes stop moving; four rounds cover
    ; four levels of nesting, and each round starts from scratch so nothing
    ; is counted twice.
    mov  dword [rel struct_rounds], 4
.fpass_round:
    mov  dword [rel field_count], 2   ; fields 0 and 1 belong to 'stream'
    mov  rdi, r12
.fpass:
    test rdi, rdi
    jz   .fpass_done
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_PROGRAM
    jne  .fpass_done
    mov  rcx, [rdi + AST.left]
    test rcx, rcx
    jz   .fp_next
    mov  rax, [rcx + AST.node_type]
    cmp  rax, AST_STRUCT_DEF
    jne  .fp_next
    push rdi
    mov  rdi, rcx
    call cg_register_struct
    pop  rdi
.fp_next:
    mov  rdi, [rdi + AST.right]
    jmp  .fpass
.fpass_done:
    ; through a register: neither 'dec dword [rel X]' nor 'cmp dword [rel X], N'
    ; appears anywhere else in this compiler, and kasm's coverage of them is
    ; unproven.
    mov  eax, [rel struct_rounds]
    dec  eax
    mov  [rel struct_rounds], eax
    test eax, eax
    jg   .fpass_round
    ; walk the program: functions -> .text, TITAN modules -> real .data
    call kt_program_begin
    mov  rdi, r12
    call cg_walk_top
    call kt_program_end
    call cg_emit_fnrecs
    cmp  byte [rel cg_had_error], 0
    jne  .err
    ; code that can run in a thread may only touch 'shared' globals
    call cg_thread_check
    mov  [rel cg_thread_tok], rax
    test rax, rax
    jnz  .thread_err
    mov  rax, 1
    pop  r12
    ret
.thread_err:
    xor  eax, eax                    ; main reports it from cg_thread_error_tok
    pop  r12
    ret
.err:
    movzx eax, byte [rel dbg_which]
    neg  eax
    pop  r12
    ret

; ==============================================================================
; THE THREAD CHECK
; Code that can run in a thread may only touch globals declared 'shared var'.
; While emitting, codegen notes who calls whom, which functions start threads,
; whose address is taken, and each function's first access to a global that is
; not shared. After the last function, cg_thread_check works out which
; functions can run in a thread -- the ones passed to thread_start and all they
; call -- and returns the offending access, if any. An indirect call could go
; anywhere, so once reachable code makes one, every function whose address is
; taken counts as reachable too. All the note routines preserve every register.
; ==============================================================================

; cg_emit_gtok(rdi = name token of a global): notes the access, then emits the
; name exactly as emit_tok would.
cg_emit_gtok:
    call cg_note_global
    jmp  emit_tok

; cg_note_global(rdi = name token): the first access of the current function
; to a global that is not shared.
cg_note_global:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push r8
    push r9
    mov  eax, [rel cg_cur_fn]
    cmp  eax, 0
    jl   .ng_out
    cmp  eax, CG_MAX_FUNCS
    jae  .ng_out
    lea  rcx, [rel fn_gtok]
    mov  rdx, [rcx + rax*8]
    test rdx, rdx
    jnz  .ng_out
    xor  ebx, ebx
.ng_loop:
    cmp  ebx, [rel gs_count]
    jae  .ng_out
    lea  rcx, [rel gs_toks]
    mov  rsi, [rcx + rbx*8]
    push rdi
    call tok_equal
    pop  rdi
    test rax, rax
    jnz  .ng_found
    inc  ebx
    jmp  .ng_loop
.ng_found:
    lea  rcx, [rel gs_shared]
    mov  edx, [rcx + rbx*4]
    test edx, edx
    jnz  .ng_out
    mov  eax, [rel cg_cur_fn]
    lea  rcx, [rel fn_gtok]
    mov  [rcx + rax*8], rdi
.ng_out:
    pop  r9
    pop  r8
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; cg_note_call(rdi = callee name token): a call edge from the current function.
cg_note_call:
    push rax
    push rcx
    push rdx
    push r8
    push r9
    mov  eax, [rel cg_cur_fn]
    cmp  eax, 0
    jl   .nc_out
    push rax
    call cg_find_func
    mov  edx, eax                    ; callee
    pop  rax                         ; caller
    cmp  edx, 0
    jl   .nc_out
    mov  ecx, [rel ce_count]
    cmp  ecx, CG_MAX_EDGES
    jae  .nc_out
    lea  r8, [rel ce_from]
    mov  [r8 + rcx*4], eax
    lea  r8, [rel ce_to]
    mov  [r8 + rcx*4], edx
    inc  ecx
    mov  [rel ce_count], ecx
.nc_out:
    pop  r9
    pop  r8
    pop  rdx
    pop  rcx
    pop  rax
    ret

; cg_note_addr(eax = function index): its address is taken.
cg_note_addr:
    push rcx
    cmp  eax, 0
    jl   .na_out
    cmp  eax, CG_MAX_FUNCS
    jae  .na_out
    lea  rcx, [rel fn_addr]
    mov  byte [rcx + rax], 1
.na_out:
    pop  rcx
    ret

; cg_note_indirect: the current function makes an indirect call.
cg_note_indirect:
    push rax
    push rcx
    mov  eax, [rel cg_cur_fn]
    cmp  eax, 0
    jl   .ni_out
    lea  rcx, [rel fn_indir]
    mov  byte [rcx + rax], 1
.ni_out:
    pop  rcx
    pop  rax
    ret

; cg_note_thread(rdi = first argument of thread_start): &fn marks fn as the
; start of a thread; anything computed could be any function.
cg_note_thread:
    push rax
    push rcx
    push rdx
    push rdi
    push r8
    push r9
    test rdi, rdi
    jz   .nt_dyn
    cmp  qword [rdi + AST.node_type], AST_ADDR_OF
    jne  .nt_dyn
    mov  rdi, [rdi + AST.data]
    test rdi, rdi
    jz   .nt_dyn
    call cg_find_func
    cmp  eax, 0
    jl   .nt_dyn
    lea  rcx, [rel fn_root]
    mov  byte [rcx + rax], 1
    jmp  .nt_out
.nt_dyn:
    mov  byte [rel cg_dyn_thread], 1
.nt_out:
    pop  r9
    pop  r8
    pop  rdi
    pop  rdx
    pop  rcx
    pop  rax
    ret

; cg_thread_check() -> rax = token of a non-shared global touched by code that
; can run in a thread, 0 when there is none.
cg_thread_check:
    push rbx
    push r12
    push r13
    push r14
    mov  r12d, [rel fn_count]
    ; start: the functions passed to thread_start, and every address-taken
    ; one when a thread was started from a computed function
    xor  ebx, ebx
.tc_init:
    cmp  ebx, r12d
    jae  .tc_iter
    lea  rcx, [rel fn_root]
    movzx eax, byte [rcx + rbx]
    cmp  byte [rel cg_dyn_thread], 0
    je   .tc_init_set
    lea  rcx, [rel fn_addr]
    movzx edx, byte [rcx + rbx]
    or   eax, edx
.tc_init_set:
    lea  rcx, [rel fn_reach]
    mov  [rcx + rbx], al
    inc  ebx
    jmp  .tc_init
.tc_iter:
    xor  r13d, r13d                  ; changed
    ; an indirect call from reachable code: every address-taken function
    xor  ebx, ebx
.tc_ind:
    cmp  ebx, r12d
    jae  .tc_edges
    lea  rcx, [rel fn_reach]
    cmp  byte [rcx + rbx], 0
    je   .tc_ind_next
    lea  rcx, [rel fn_indir]
    cmp  byte [rcx + rbx], 0
    je   .tc_ind_next
    xor  r14d, r14d
.tc_ind_all:
    cmp  r14d, r12d
    jae  .tc_ind_next
    lea  rcx, [rel fn_addr]
    cmp  byte [rcx + r14], 0
    je   .tc_ind_skip
    lea  rcx, [rel fn_reach]
    cmp  byte [rcx + r14], 0
    jne  .tc_ind_skip
    mov  byte [rcx + r14], 1
    mov  r13d, 1
.tc_ind_skip:
    inc  r14d
    jmp  .tc_ind_all
.tc_ind_next:
    inc  ebx
    jmp  .tc_ind
.tc_edges:
    xor  ebx, ebx
.tc_edge:
    cmp  ebx, [rel ce_count]
    jae  .tc_edges_done
    lea  rcx, [rel ce_from]
    mov  eax, [rcx + rbx*4]
    lea  rcx, [rel ce_to]
    mov  edx, [rcx + rbx*4]
    lea  rcx, [rel fn_reach]
    cmp  byte [rcx + rax], 0
    je   .tc_edge_next
    cmp  byte [rcx + rdx], 0
    jne  .tc_edge_next
    mov  byte [rcx + rdx], 1
    mov  r13d, 1
.tc_edge_next:
    inc  ebx
    jmp  .tc_edge
.tc_edges_done:
    test r13d, r13d
    jnz  .tc_iter
    ; any reachable function with a non-shared global
    xor  ebx, ebx
.tc_find:
    cmp  ebx, r12d
    jae  .tc_none
    lea  rcx, [rel fn_reach]
    cmp  byte [rcx + rbx], 0
    je   .tc_find_next
    lea  rcx, [rel fn_gtok]
    mov  rax, [rcx + rbx*8]
    test rax, rax
    jnz  .tc_out
.tc_find_next:
    inc  ebx
    jmp  .tc_find
.tc_none:
    xor  eax, eax
.tc_out:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_thread_error_tok() -> rax = the offending access, 0 when there is none
    global cg_thread_error_tok
cg_thread_error_tok:
    mov  rax, [rel cg_thread_tok]
    ret

; cg_type_error() -> rax = message (0 when none), rdx = token or 0, r8 = hint
    global cg_type_error
cg_type_error:
    mov  rax, [rel cg_err_msg]
    mov  rdx, [rel cg_err_tok]
    mov  r8, [rel cg_err_hint]
    ret

; cg_walk_top(rdi=PROGRAM node list) -- emits every function
cg_walk_top:
    push r12
    mov  r12, rdi
.loop:
    test r12, r12
    jz   .done
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_PROGRAM
    jne  .done
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .next
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_FUNCTION
    je   .fn
    cmp  rax, AST_HARDWARE_BLOCK
    je   .mod
    cmp  rax, AST_STRUCT_DEF
    je   .structdef
    cmp  rax, AST_VAR_DECL
    je   .globaldecl
    cmp  rax, AST_CONST_DECL
    je   .globaldecl
    cmp  rax, AST_ISA_DEF
    je   .isa
    cmp  rax, AST_BOOT_DEF
    je   .boot
    cmp  rax, AST_MMU_DEF
    je   .mmu
    cmp  rax, AST_ISR_DEF
    je   .isr
    cmp  rax, AST_CFG_DEF
    je   .cfg
    cmp  rax, AST_SCHED_DEF
    je   .sched
    cmp  rax, AST_SYS_DEF
    je   .sys
    jmp  .next
.fn:
    call cg_function
    call cg_drain_lambdas
    jmp  .next
.structdef:
    jmp  .next                       ; already registered in the pre-pass
.globaldecl:
    call cg_global_decl
    jmp  .next
.isa:
    call cg_isa
    jmp  .next
.boot:
    call cg_boot
    jmp  .next
.mmu:
    call cg_mmu
    jmp  .next
.isr:
    call cg_isr_routine
    jmp  .next
.cfg:
    call cg_config
    jmp  .next
.sched:
    call cg_sched
    jmp  .next
.sys:
    call cg_sys
    jmp  .next
.mod:
    call cg_module
.next:
    mov  r12, [r12 + AST.right]
    jmp  .loop
.done:
    pop  r12
    ret

; ==============================================================================
; M01 - cg_isa(rdi = AST_ISA_DEF node)
; Emits the opcode table as real, exported data:
;   __isa_s<N>:            db "<opcode>",0
;   __isa_<ISA>_count:     dq <n>
;   __isa_<ISA>_opcodes:   dq <hex>...
;   __isa_<ISA>_names:     dq __isa_s<N>...
; Readable from the Kron runtime or from any external language.
; ==============================================================================
cg_isa:
    push r12
    push r13
    push r14
    mov  r12, rdi

    mov  rsi, s_sec_data
    call emit_cstr

    ; --- pass 1: name strings, giving each entry a unique label
    mov  r13, [r12 + AST.right]
.p1:
    test r13, r13
    jz   .p1_end
    call new_label
    mov  eax, eax
    mov  [r13 + AST.type_info], rax
    mov  rsi, s_isa_str
    call emit_cstr
    mov  edi, dword [r13 + AST.type_info]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  rsi, s_db_q
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call emit_tok
    mov  rsi, s_q0_nl
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .p1
.p1_end:

    ; --- count entries
    xor  r14d, r14d
    mov  r13, [r12 + AST.right]
.cnt:
    test r13, r13
    jz   .cnt_end
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .cnt
.cnt_end:

    ; --- __isa_<ISA>_count
    mov  rsi, s_global_kw
    call emit_cstr
    call .emit_base
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .emit_base
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_colon
    call emit_cstr
    mov  rsi, s_dq_sp
    call emit_cstr
    mov  edi, r14d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    ; --- __isa_<ISA>_opcodes
    mov  rsi, s_global_kw
    call emit_cstr
    call .emit_base
    mov  rsi, s_isa_ops
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .emit_base
    mov  rsi, s_isa_ops
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  r13, [r12 + AST.right]
.p2:
    test r13, r13
    jz   .p2_end
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rdi, [r13 + AST.left]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .p2
.p2_end:

    ; --- __isa_<ISA>_names
    mov  rsi, s_global_kw
    call emit_cstr
    call .emit_base
    mov  rsi, s_isa_nms
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .emit_base
    mov  rsi, s_isa_nms
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  r13, [r12 + AST.right]
.p3:
    test r13, r13
    jz   .p3_end
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rsi, s_isa_str
    call emit_cstr
    mov  edi, dword [r13 + AST.type_info]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .p3
.p3_end:

    pop  r14
    pop  r13
    pop  r12
    ret

; emits "__isa_<name>" (prefix + ISA name token)
.emit_base:
    mov  rsi, s_isa_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    ret

; ==============================================================================
; M02 - cg_boot(rdi = AST_BOOT_DEF node)
; Emits an exported EXECUTABLE routine applying the initial CPU state:
; global __boot_<name>
; __boot_<name>:
; mov rax, <hex>      ; for each 'register X set <hex>'
;       ...
;       ret
; ==============================================================================
; ==============================================================================
; cg_is_sysreg(rdi = token) -> eax = 1 when the name is a control or debug
; register: 'cr' or 'dr' followed by a single digit, three characters in all.
; Those cannot be written from an immediate, so cg_boot routes them via rax.
; ==============================================================================
cg_is_sysreg:
    push rsi
    xor  eax, eax
    test rdi, rdi
    jz   .no
    cmp  dword [rdi + TOKEN.length], 3
    jne  .no
    mov  rsi, [rdi + TOKEN.value]
    test rsi, rsi
    jz   .no
    mov  al, [rsi]
    or   al, 0x20                    ; fold case
    cmp  al, 'c'
    je   .second
    cmp  al, 'd'
    jne  .no
.second:
    mov  al, [rsi + 1]
    or   al, 0x20
    cmp  al, 'r'
    jne  .no
    mov  al, [rsi + 2]
    cmp  al, '0'
    jb   .no
    cmp  al, '9'
    ja   .no
    mov  eax, 1
    pop  rsi
    ret
.no:
    xor  eax, eax
    pop  rsi
    ret

cg_boot:
    push r12
    push r13
    mov  r12, rdi

    mov  rsi, s_sec_text
    call emit_cstr

    mov  rsi, s_global_kw
    call emit_cstr
    mov  rsi, s_boot_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr

    mov  rsi, s_boot_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_colon_nl
    call emit_cstr

    mov  r13, [r12 + AST.right]
.loop:
    test r13, r13
    jz   .done
    ; A control or debug register takes no immediate: 'mov cr4, 0x6A0' is not
    ; an x86 instruction.  The only encoding is 0F 22 /r, whose source must be
    ; a general register, so those writes go through rax.  General registers
    ; keep the direct form so their output is unchanged.
    mov  rdi, [r13 + AST.data]       ; register name
    call cg_is_sysreg
    test eax, eax
    jnz  .sysreg

    mov  rsi, s_mov_ind
    call emit_cstr
    mov  rdi, [r13 + AST.data]       ; register name
    call emit_tok
    mov  rsi, s_comma_sp
    call emit_cstr
    mov  rdi, [r13 + AST.left]       ; value
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    jmp  .next

.sysreg:
    mov  rsi, s_mov_rax
    call emit_cstr
    mov  rdi, [r13 + AST.left]       ; value
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_mov_ind
    call emit_cstr
    mov  rdi, [r13 + AST.data]       ; register name
    call emit_tok
    mov  rsi, s_comma_rax
    call emit_cstr

.next:
    mov  r13, [r13 + AST.right]
    jmp  .loop
.done:
    mov  rsi, s_ret_ind
    call emit_cstr
    pop  r13
    pop  r12
    ret

; ==============================================================================
; M03 - cg_mmu(rdi = AST_MMU_DEF node)
; Emits the paging hierarchy as an exported data table:
; __mmu_<name>_levels:  dq <level>, <entries>   (a pair per level)
;   __mmu_<name>_count:   dq <n>
; ==============================================================================
cg_mmu:
    push r12
    push r13
    push r14
    mov  r12, rdi

    mov  rsi, s_sec_data
    call emit_cstr

    xor  r14d, r14d
    mov  r13, [r12 + AST.right]
.cnt:
    test r13, r13
    jz   .cnt_end
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .cnt
.cnt_end:

    mov  rsi, s_global_kw
    call emit_cstr
    call .mbase
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .mbase
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_colon
    call emit_cstr
    mov  rsi, s_dq_sp
    call emit_cstr
    mov  edi, r14d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    mov  rsi, s_global_kw
    call emit_cstr
    call .mbase
    mov  rsi, s_mmu_lv
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .mbase
    mov  rsi, s_mmu_lv
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr

    mov  r13, [r12 + AST.right]
.p:
    test r13, r13
    jz   .p_end
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rdi, [r13 + AST.data]       ; level
    call emit_tok
    mov  rsi, s_comma_sp
    call emit_cstr
    mov  rdi, [r13 + AST.left]       ; entries
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .p
.p_end:
    pop  r14
    pop  r13
    pop  r12
    ret

.mbase:
    mov  rsi, s_mmu_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    ret

; ==============================================================================
; M04 - cg_isr_routine(rdi = AST_ISR_DEF node)
; Emits an EXECUTABLE interrupt handler:
; global __isr_<name>
; __isr_<name>:
;       push rbp / mov rbp,rsp / sub rsp,<frame>
;       <body compiled to real x86>
;       mov rsp,rbp / pop rbp / iretq
; Also exports __isrvec_<name> with the vector number.
; ==============================================================================
cg_isr_routine:
    push r12
    push r13
    push r14
    mov  r12, rdi

    ; vector as exported data (if declared)
    mov  rax, [r12 + AST.left]
    test rax, rax
    jz   .no_vec
    mov  rsi, s_sec_data
    call emit_cstr
    mov  rsi, s_global_kw
    call emit_cstr
    mov  rsi, s_isrvec_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_isrvec_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_colon
    call emit_cstr
    mov  rsi, s_dq_sp
    call emit_cstr
    mov  rdi, [r12 + AST.left]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
.no_vec:

    mov  rsi, s_sec_text
    call emit_cstr

    ; reset variable table and reserve return id
    xor  eax, eax
    mov  [rel var_count], eax
    call new_label
    mov  [rel cur_ret_id], eax
    mov  r14d, eax

    ; compute frame size
    mov  rdi, [r12 + AST.right]
    call cg_count_vars
    mov  ecx, eax
    shl  ecx, 3
    add  ecx, 32
    add  ecx, 15
    and  ecx, -16
    mov  r13d, ecx

    mov  rsi, s_global_kw
    call emit_cstr
    mov  rsi, s_isr_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr

    mov  rsi, s_isr_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_colon_nl
    call emit_cstr

    mov  rsi, s_pushrbp
    call emit_cstr
    mov  rsi, s_movrbp
    call emit_cstr
    mov  rsi, s_subrsp
    call emit_cstr
    mov  edi, r13d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    ; actual body
    mov  rdi, [r12 + AST.right]
    call cg_emit

    ; return label (in case the body uses 'return')
    mov  edi, r14d
    mov  eax, IR_RETLBL
    call ir_ctl

    mov  rsi, s_movrsprbp
    call emit_cstr
    mov  rsi, s_poprbp
    call emit_cstr
    mov  rsi, s_iretq
    call emit_cstr

    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; cg_config(rdi = AST_CFG_DEF node) -- generic for declarative modules
; Emits:
;   __cfg_<name>_count:  dq n
;   __cfg_<name>_keys:   dq ptr...   (property names)
; __cfg_<name>_texts:  dq ptr...   (value as text, always)
; __cfg_<name>_nums:   dq n...     (numeric value; 0 if it is not one)
; ==============================================================================
cg_config:
    push r12
    push r13
    push r14
    mov  r12, rdi

    mov  rsi, s_sec_data
    call emit_cstr

    ; key and value strings, with unique labels
    mov  r13, [r12 + AST.right]
.s1:
    test r13, r13
    jz   .s1_end
    cmp  qword [r13 + AST.type_info], CFG_HANDLER_MARK
    je   .s1_next
    call new_label
    mov  eax, eax
    mov  [r13 + AST.child_count], rax
    mov  rsi, s_cfg_k
    call emit_cstr
    mov  edi, dword [r13 + AST.child_count]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  rsi, s_db_q
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call emit_tok
    mov  rsi, s_q0_nl
    call emit_cstr

    mov  rsi, s_cfg_v
    call emit_cstr
    mov  edi, dword [r13 + AST.child_count]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  rsi, s_db_q
    call emit_cstr
    mov  rdi, [r13 + AST.left]
    call emit_tok
    mov  rsi, s_q0_nl
    call emit_cstr
.s1_next:
    mov  r13, [r13 + AST.right]
    jmp  .s1
.s1_end:

    xor  r14d, r14d
    mov  r13, [r12 + AST.right]
.cn:
    test r13, r13
    jz   .cn_end
    cmp  qword [r13 + AST.type_info], CFG_HANDLER_MARK
    je   .cn_next
    inc  r14d
.cn_next:
    mov  r13, [r13 + AST.right]
    jmp  .cn
.cn_end:

    ; _count
    mov  rsi, s_global_kw
    call emit_cstr
    call .cbase
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .cbase
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_colon
    call emit_cstr
    mov  rsi, s_dq_sp
    call emit_cstr
    mov  edi, r14d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    ; _keys
    mov  rsi, s_global_kw
    call emit_cstr
    call .cbase
    mov  rsi, s_cfg_keys
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .cbase
    mov  rsi, s_cfg_keys
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  r13, [r12 + AST.right]
.k:
    test r13, r13
    jz   .k_end
    cmp  qword [r13 + AST.type_info], CFG_HANDLER_MARK
    je   .k_next
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rsi, s_cfg_k
    call emit_cstr
    mov  edi, dword [r13 + AST.child_count]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
.k_next:
    mov  r13, [r13 + AST.right]
    jmp  .k
.k_end:

    ; _texts
    mov  rsi, s_global_kw
    call emit_cstr
    call .cbase
    mov  rsi, s_cfg_txts
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .cbase
    mov  rsi, s_cfg_txts
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  r13, [r12 + AST.right]
.t:
    test r13, r13
    jz   .t_end
    cmp  qword [r13 + AST.type_info], CFG_HANDLER_MARK
    je   .t_next
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rsi, s_cfg_v
    call emit_cstr
    mov  edi, dword [r13 + AST.child_count]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
.t_next:
    mov  r13, [r13 + AST.right]
    jmp  .t
.t_end:

    ; _nums  (the literal if the value was numeric, 0 otherwise)
    mov  rsi, s_global_kw
    call emit_cstr
    call .cbase
    mov  rsi, s_cfg_nums
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .cbase
    mov  rsi, s_cfg_nums
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  r13, [r12 + AST.right]
.n:
    test r13, r13
    jz   .n_end
    cmp  qword [r13 + AST.type_info], CFG_HANDLER_MARK
    je   .n_next
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rax, [r13 + AST.type_info]
    cmp  rax, TOK_HEX
    je   .n_lit
    cmp  rax, TOK_NUMBER
    je   .n_lit
    mov  rsi, s_zero
    call emit_cstr
    jmp  .n_nl
.n_lit:
    mov  rdi, [r13 + AST.left]
    call emit_tok
.n_nl:
    mov  rsi, s_nl
    call emit_cstr
.n_next:
    mov  r13, [r13 + AST.right]
    jmp  .n
.n_end:

    ; --- on_* handlers as exported executable routines ---
    mov  r13, [r12 + AST.right]
.h_loop:
    test r13, r13
    jz   .h_end
    cmp  qword [r13 + AST.type_info], CFG_HANDLER_MARK
    jne  .h_next
    mov  rsi, s_sec_text
    call emit_cstr

    xor  eax, eax
    mov  [rel var_count], eax
    call new_label
    mov  [rel cur_ret_id], eax
    push rax

    mov  rdi, [r13 + AST.left]
    call cg_count_vars
    mov  ecx, eax
    shl  ecx, 3
    add  ecx, 32
    add  ecx, 15
    and  ecx, -16
    push rcx

    mov  rsi, s_global_kw
    call emit_cstr
    call .hbase
    mov  rsi, s_nl
    call emit_cstr
    call .hbase
    mov  rsi, s_colon_nl
    call emit_cstr

    mov  rsi, s_pushrbp
    call emit_cstr
    mov  rsi, s_movrbp
    call emit_cstr
    mov  rsi, s_subrsp
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    mov  rdi, [r13 + AST.left]
    call cg_emit

    pop  rdi
    mov  eax, IR_RETLBL
    call ir_ctl
    mov  rsi, s_movrsprbp
    call emit_cstr
    mov  rsi, s_poprbp
    call emit_cstr
    mov  rsi, s_ret
    call emit_cstr
.h_next:
    mov  r13, [r13 + AST.right]
    jmp  .h_loop
.h_end:

    pop  r14
    pop  r13
    pop  r12
    ret

; emits "__cfg_<module>_<handler>"
.hbase:
    mov  rsi, s_cfg_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_underscore
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call emit_tok
    ret

.cbase:
    mov  rsi, s_cfg_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    ret

; ==============================================================================
; M08 - cg_sched(rdi = AST_SCHED_DEF node)
; Reuses cg_config for the parameters (same layout) and also emits the
; context switch routine as exported, executable x86 code:
; global __sched_<name>_switch
; ==============================================================================
cg_sched:
    push r12
    push r13
    push r14
    mov  r12, rdi

    ; parameters -> data tables (same layout as AST_CFG_DEF)
    mov  rdi, r12
    call cg_config

    ; context switch routine (if a block was declared)
    mov  rax, [r12 + AST.left]
    test rax, rax
    jz   .done

    mov  rsi, s_sec_text
    call emit_cstr

    xor  eax, eax
    mov  [rel var_count], eax
    call new_label
    mov  [rel cur_ret_id], eax
    mov  r14d, eax

    mov  rdi, [r12 + AST.left]
    call cg_count_vars
    mov  ecx, eax
    shl  ecx, 3
    add  ecx, 32
    add  ecx, 15
    and  ecx, -16
    mov  r13d, ecx

    mov  rsi, s_global_kw
    call emit_cstr
    call .sbase
    mov  rsi, s_sched_sw
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .sbase
    mov  rsi, s_sched_sw
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr

    mov  rsi, s_pushrbp
    call emit_cstr
    mov  rsi, s_movrbp
    call emit_cstr
    mov  rsi, s_subrsp
    call emit_cstr
    mov  edi, r13d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    mov  rdi, [r12 + AST.left]
    call cg_emit

    mov  edi, r14d
    mov  eax, IR_RETLBL
    call ir_ctl
    mov  rsi, s_movrsprbp
    call emit_cstr
    mov  rsi, s_poprbp
    call emit_cstr
    mov  rsi, s_ret
    call emit_cstr

.done:
    pop  r14
    pop  r13
    pop  r12
    ret

.sbase:
    mov  rsi, s_sched_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    ret

; ==============================================================================
; M09 - cg_sys(rdi = AST_SYS_DEF node)
; Emits the syscall dispatch table:
;   __sys_<name>_count:  dq n
; __sys_<name>_table:  dq __svc_<name>_0, __svc_<name>_1, ...
;   __svc_<name>_N:      real ISR handler (push/pop + iretq)
; The entry mechanism is chosen by the kernel author (int vector or syscall).
; ==============================================================================
cg_sys:
    push r12
    push r13
    push r14
    mov  r12, rdi

    ; count entries
    xor  r14d, r14d
    mov  r13, [r12 + AST.right]
.cnt:
    test r13, r13
    jz   .cnt_end
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .cnt
.cnt_end:

    mov  rsi, s_sec_data
    call emit_cstr

    ; __sys_<name>_count
    mov  rsi, s_global_kw
    call emit_cstr
    call .sysbase
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .sysbase
    mov  rsi, s_isa_cnt
    call emit_cstr
    mov  rsi, s_colon
    call emit_cstr
    mov  rsi, s_dq_sp
    call emit_cstr
    mov  edi, r14d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    ; __sys_<name>_table
    mov  rsi, s_global_kw
    call emit_cstr
    call .sysbase
    mov  rsi, s_sys_tbl
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    call .sysbase
    mov  rsi, s_sys_tbl
    call emit_cstr
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  r13, [r12 + AST.right]
.tbl:
    test r13, r13
    jz   .tbl_end
    mov  rsi, s_dq_ind
    call emit_cstr
    mov  rsi, s_svc_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_underscore
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .tbl
.tbl_end:

    ; handlers as ISRs
    mov  r13, [r12 + AST.right]
.hdl:
    test r13, r13
    jz   .hdl_end
    mov  rsi, s_sec_text
    call emit_cstr

    xor  eax, eax
    mov  [rel var_count], eax
    call new_label
    mov  [rel cur_ret_id], eax
    push rax

    mov  rdi, [r13 + AST.right]
    call cg_count_vars
    mov  ecx, eax
    shl  ecx, 3
    add  ecx, 32
    add  ecx, 15
    and  ecx, -16

    mov  rsi, s_svc_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_underscore
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call emit_tok
    mov  rsi, s_colon_nl
    call emit_cstr

    mov  rsi, s_pushrbp
    call emit_cstr
    mov  rsi, s_movrbp
    call emit_cstr
    mov  rsi, s_subrsp
    call emit_cstr
    mov  edi, ecx
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr

    mov  rdi, [r13 + AST.right]
    call cg_emit

    pop  rdi
    mov  eax, IR_RETLBL
    call ir_ctl
    mov  rsi, s_movrsprbp
    call emit_cstr
    mov  rsi, s_poprbp
    call emit_cstr
    cmp  qword [r12 + AST.type_info], 1
    je   .use_sysret
    mov  rsi, s_iretq
    call emit_cstr
    jmp  .hdl_next
.use_sysret:
    mov  rsi, s_sysretq
    call emit_cstr
.hdl_next:

    mov  r13, [r13 + AST.right]
    jmp  .hdl
.hdl_end:

    pop  r14
    pop  r13
    pop  r12
    ret

.sysbase:
    mov  rsi, s_sys_pref
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    ret

; ==============================================================================
; cg_module(rdi = AST_HARDWARE_BLOCK node)
; Emits a real data section with the identity of the TITAN module:
;   section .data
; __mod_<name>:  db "<module_type>",0 ; db "<name>",0
; The declarative configuration of the module becomes real bytes
; inside the .exe, readable by a runtime.
; ==============================================================================
cg_module:
    push r12
    mov  r12, rdi
    ; section .data
    mov  rsi, s_sec_data
    call emit_cstr
    ; label __mod_<id>_<name>:  (a unique id avoids collisions)
    mov  rsi, s_mod_pref
    call emit_cstr
    call new_label
    mov  edi, eax
    call emit_uint
    mov  rsi, s_us
    call emit_cstr
    mov  rdi, [r12 + AST.left]        ; name token (may be 0)
    test rdi, rdi
    jz   .anon
    call emit_tok
    jmp  .lbl_end
.anon:
    mov  rsi, s_mod_anon
    call emit_cstr
.lbl_end:
    mov  rsi, s_colon_nl
    call emit_cstr
    ; db "<module_type>",0
    mov  rsi, s_db_q
    call emit_cstr
    mov  rdi, [r12 + AST.data]        ; module type token
    call emit_tok
    mov  rsi, s_q0_nl
    call emit_cstr
    ; db "<name>",0
    mov  rsi, s_db_q
    call emit_cstr
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .anon2
    call emit_tok
    jmp  .name_end
.anon2:
    mov  rsi, s_mod_anon
    call emit_cstr
.name_end:
    mov  rsi, s_q0_nl
    call emit_cstr
    ; back to section .text
    mov  rsi, s_sec_text
    call emit_cstr
    pop  r12
    ret

; ==============================================================================
; cg_function(rdi = AST_FUNCTION node)
; ==============================================================================
; ==============================================================================
; cg_param_struct_id(rdi = AST_PARAM node) -> eax = struct id, or -1
; The parser leaves the parameter's type name token in AST.left. A builtin
; type arrives as a keyword and never lands there, so a token here always
; means "the type was written as an identifier" -- which is a struct if it
; is registered as one.
; ==============================================================================
; ==============================================================================
; cg_argreg_name(r14d = argument index) -> rsi = register name string
; ==============================================================================
cg_argreg_name:
    lea  rsi, [rel s_argreg0]
    cmp  r14d, 0
    je   .out
    lea  rsi, [rel s_argreg1]
    cmp  r14d, 1
    je   .out
    lea  rsi, [rel s_argreg2]
    cmp  r14d, 2
    je   .out
    lea  rsi, [rel s_argreg3]
    cmp  r14d, 3
    je   .out
    lea  rsi, [rel s_argreg4]
    cmp  r14d, 4
    je   .out
    lea  rsi, [rel s_argreg5]
.out:
    ret

cg_param_struct_id:
    test rdi, rdi
    jz   .none
    mov  rdi, [rdi + AST.left]
    test rdi, rdi
    jz   .none
    cmp  qword [rdi + TOKEN.type], KW_STR
    jne  .byname
    mov  eax, [rel stream_struct_id]
    ret
.byname:
    call cg_find_struct
    ret
.none:
    mov  eax, -1
    ret

; ==============================================================================
; cg_param_slots(rdi = parameter list head) -> eax = stack slots needed
; A struct parameter is passed by value: the caller hands over its address
; and the prologue copies the fields in, so the frame has to reserve room for
; the whole struct rather than the single slot every parameter used to get.
; ==============================================================================
cg_param_slots:
    push rbx
    push r12
    xor  ebx, ebx                    ; running total
    mov  r12, rdi
.loop:
    test r12, r12
    jz   .done
    mov  rdi, r12
    call cg_param_struct_id
    cmp  eax, -1
    je   .one
    call cg_struct_size              ; eax = slots
    test eax, eax
    jz   .one
    add  ebx, eax
    jmp  .next
.one:
    inc  ebx
.next:
    mov  r12, [r12 + AST.right]
    jmp  .loop
.done:
    mov  eax, ebx
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_arg_struct_id(rdi = argument expression) -> eax = struct id, or -1
; Only a bare identifier naming a struct variable qualifies. Anything else
; keeps the ordinary by-value evaluation.
; ==============================================================================
cg_arg_struct_id:
    push rbx
    test rdi, rdi
    jz   .none
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .none
    mov  rdi, [rdi + AST.data]
    test rdi, rdi
    jz   .none
    call cg_find_var_idx
    cmp  eax, -1
    je   .none
    ; An array parameter first: its slot already holds an address, pass it on.
    ; It also carries its declared size in var_arrlen, so testing the size
    ; first -- as this did -- took a parameter for a local array and passed the
    ; address OF THE SLOT: the function it was forwarded to read garbage.
    lea  rcx, [rel var_isref]
    mov  ecx, [rcx + rax*4]
    test ecx, ecx
    jnz  .isref
    ; a local array is passed by address too, so it counts here
    lea  rcx, [rel var_arrlen]
    mov  ecx, [rcx + rax*4]
    test ecx, ecx
    jnz  .isarr
    lea  rcx, [rel var_structs]
    mov  eax, [rcx + rax*4]
    pop  rbx
    ret
.isarr:
    mov  eax, 1
    pop  rbx
    ret
.isref:
    mov  eax, 2                       ; already an address: pass it along
    pop  rbx
    ret
.none:
    mov  eax, -1
    pop  rbx
    ret

cg_function:
    push r12
    push r13
    push r14
    call ir_begin                    ; everything this function emits is captured
    call kt_fn_begin
    mov  r12, rdi
    ; which function this is, for the thread check
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    mov  [rel cg_cur_fn], eax
    ; reset var table
    xor  eax, eax
    mov  [rel var_count], eax
    ; unique return id
    call new_label
    mov  [rel cur_ret_id], eax
    mov  r14d, eax               ; ret id
    ; does this function return real64? the parser records that in AST.col
    movzx eax, word [r12 + AST.col]
    and  eax, 1
    mov  [rel cur_ret_float], eax
    mov  eax, [r12 + AST.child_count]
    mov  [rel cur_fn_multi], eax

    ; count locals for the frame
    mov  rdi, [r12 + AST.right]
    call cg_count_vars           ; rax = local count
    ; a fn value also holds the names it keeps
    mov  ecx, [rel cg_lam_cur]
    cmp  ecx, -1
    je   .no_lamcaps
    lea  rdx, [rel lq_ncap]
    add  eax, [rdx + rcx*4]
.no_lamcaps:
    push rax
    ; count parameters (each one also needs a slot, and a struct parameter
    ; needs one per field because it is copied in by value)
    mov  rdi, [r12 + AST.left]
    call cg_param_slots
    pop  rcx
    add  eax, ecx
    ; frame = (count*8 + 32) aligned to 16
    mov  ecx, eax
    shl  ecx, 3
    add  ecx, 32
    add  ecx, 15
    and  ecx, -16
    mov  r13d, ecx               ; frame size

    ; --- export the symbol if it is marked global_visible / inter_cluster_export ---
    mov  rax, [r12 + AST.type_info]
    cmp  rax, VIS_EXPORTED
    jne  .no_export
    mov  rdi, [r12 + AST.data]
    call name_is_main
    test rax, rax
    jnz  .no_export              ; 'main' is already exported in the header
    mov  rsi, s_global_kw
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
.no_export:

    ; function label
    mov  rdi, [r12 + AST.data]   ; name token
    call name_is_main
    test rax, rax
    jz   .named
    ; main:
    ; on Linux too main is just main: the preamble's _start calls it
    cmp  byte [rel cg_bare], 0
    jne  .use_kmain
    mov  rsi, main_lbl
    call emit_cstr
    jmp  .lbl_ok
.use_start:
    mov  rsi, start_lbl
    call emit_cstr
    jmp  .lbl_ok
.use_kmain:
    mov  rsi, kmain_lbl
    call emit_cstr
.lbl_ok:
    jmp  .prologue
.named:
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_colon_nl
    call emit_cstr
.prologue:
    mov  rsi, s_pushrbp
    call emit_cstr
    mov  rsi, s_movrbp
    call emit_cstr
    mov  edi, r13d
    mov  eax, IR_FRAME               ; sub rsp, N -- the allocator may grow N
    call ir_ctl

    ; --- spill incoming register parameters into their stack slots ---
    ; Win64 / System V pass the first four integer arguments in rcx,rdx,r8,r9.
    push r13
    push r14
    mov  r13, [r12 + AST.left]       ; parameter list
    xor  r14d, r14d                  ; parameter index
.pspill:
    test r13, r13
    jz   .pspill_end
    movzx eax, word [r13 + AST.col]
    shr  eax, 8
    mov  [rel pending_vtag], eax     ; text, list<T>, map<T>
    cmp  r14d, 6
    jb   .pspill_reg
    ; Parameter seven onward arrived on the stack. The caller left them just
    ; past the shadow space, in declaration order.
    mov  rdi, [r13 + AST.data]
    mov  esi, 1
    call cg_add_var
    push rax                         ; slot offset
    mov  rsi, s_ld_stkarg
    call emit_cstr
    mov  eax, r14d
    sub  eax, 6
    shl  eax, 3
    add  eax, 48                     ; 8 return address + 8 saved rbp + 32 shadow
    mov  edi, eax
    call emit_uint
    mov  rsi, s_ld_stkarg2
    call emit_cstr
    pop  rdi
    call ir_stloc                    ; mov [rbp-N], rax, as a structured record
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .pspill
.pspill_reg:
    ; A struct parameter arrives as an address and is copied in by value, so
    ; the callee cannot write through it and every field access afterwards is
    ; an ordinary [rbp-off] against a normal struct local.
    ; An array parameter arrives as an address: one slot holding the pointer,
    ; marked as a reference so indexing loads the base instead of computing
    ; it. The float flag on the node describes the ELEMENT, which is exactly
    ; what cg_index_is_float needs, so it is passed through unchanged.
    mov  rax, [r13 + AST.type_info]
    test rax, rax
    jnz  .pspill_array
    mov  rdi, r13
    call cg_param_struct_id
    cmp  eax, -1
    jne  .pspill_struct
    ; is this parameter float? (AST.col = 1)
    movzx eax, word [r13 + AST.col]
    and  eax, 1
    push rax                         ; save float flag
    mov  rdi, [r13 + AST.data]
    mov  rsi, 1
    ; mark the variable's float flag so its slot loads/stores use xmm
    mov  rcx, [rsp]                  ; float flag
    mov  [rel pending_float], ecx
    ; carry the pointer element width across as well, or arithmetic on a
    ; pointer parameter walks single bytes instead of whole elements
    mov  ecx, [r13 + AST.child_count]
    mov  [rel pending_elem], ecx
    call cg_add_var                  ; rax = slot offset
    pop  rcx                         ; float flag back
    push rax                         ; slot offset
    push rcx                         ; float flag
    test rcx, rcx
    jnz  .pspill_float
    ; --- integer parameter: mov [rbp-off], rcx/rdx/r8/r9/r10/rax ---
    ; A structured record, not text. As text the slot showed up as [rbp-N]
    ; and every parameter was kept out of registers -- a function that works
    ; on its arguments, which is most of them, got nothing from allocation.
    ; Lowered to memory it is the same line as before; allocated, it becomes
    ; mov REG, rcx. The newline goes with it, so .pspill_wrote is skipped.
    mov  rdi, [rsp+8]                ; slot offset
    mov  edx, r14d                   ; which argument register
    call ir_stparam
    pop  rcx                         ; discard float flag
    pop  rax                         ; discard slot offset
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .pspill
.pspill_float:
    ; --- float parameter: movsd [rbp-off], xmmN, as a record ---
    ; Like the integer one: in memory it lowers to the same line; with a
    ; register, to movsd xmmK, xmmN.
    mov  rdi, [rsp+8]                ; slot offset
    mov  edx, r14d                   ; which xmm it arrived in
    mov  eax, IR_FSTPARAM
    call ir_withlen
    pop  rcx                         ; discard float flag
    pop  rax                         ; discard slot offset
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .pspill
.pspill_wrote:
    pop  rcx                         ; discard float flag
    pop  rax                         ; discard slot offset
    mov  rsi, s_nl
    call emit_cstr
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .pspill

.pspill_array:
    movzx eax, word [r13 + AST.col]
    mov  ecx, eax
    shr  ecx, 4
    and  ecx, 15
    mov  [rel pending_aw], ecx        ; bytes per element of the array passed
    mov  ecx, eax
    and  ecx, 1
    mov  [rel pending_float], ecx     ; float ELEMENT, for indexed access
    shr  eax, 1
    and  eax, 1
    mov  [rel pending_unsigned], eax
    mov  dword [rel pending_struct], -1
    mov  dword [rel pending_elem], 0
    mov  dword [rel pending_ref], 1   ; the slot holds an address
    mov  eax, [r13 + AST.type_info]
    mov  [rel pending_arrlen], eax
    mov  rdi, [r13 + AST.data]
    mov  esi, 1                       ; one slot: just the pointer
    call cg_add_var
    push rax                          ; slot offset
    mov  rsi, s_movmem_pre
    call emit_cstr
    mov  rdi, [rsp]
    call emit_uint
    mov  rsi, s_movmem_mid
    call emit_cstr
    call cg_argreg_name
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    pop  rax
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .pspill

.pspill_struct:
    ; eax = struct id.  Reserve one slot per field, register the variable
    ; with that struct id, then copy the fields across from the address the
    ; caller passed.
    push rbx
    mov  ebx, eax                    ; struct id
    mov  [rel pending_struct], eax
    mov  dword [rel pending_elem], 0
    mov  dword [rel pending_float], 0
    call cg_struct_size              ; eax = slot count
    test eax, eax
    jnz  .ps_have_n
    mov  eax, 1
.ps_have_n:
    mov  esi, eax                    ; slot count
    push rsi
    mov  rdi, [r13 + AST.data]
    call cg_add_var                  ; rax = base offset
    pop  rsi
    mov  ebx, eax                    ; base offset
    ; the source register is this parameter's own argument register, so no
    ; other incoming argument is disturbed; r11 is the only scratch and is
    ; never an argument register here
    xor  ecx, ecx                    ; field index
.ps_copy:
    cmp  ecx, esi
    jae  .ps_done
    push rsi
    push rcx
    ; mov r11, [<argreg> + i*8]
    mov  rsi, s_ld_r11_pre
    call emit_cstr
    call cg_argreg_name              ; rsi = register name for index r14d
    call emit_cstr
    mov  rsi, s_plus_sp
    call emit_cstr
    mov  edi, [rsp]                  ; field index
    shl  edi, 3
    call emit_uint
    mov  rsi, s_rbrack_nl
    call emit_cstr
    ; mov [rbp-(base - i*8)], r11
    mov  rsi, s_movmem_pre
    call emit_cstr
    mov  edi, [rsp]                  ; field index
    shl  edi, 3
    mov  eax, ebx
    sub  eax, edi
    mov  edi, eax
    call emit_uint
    mov  rsi, s_movmem_mid
    call emit_cstr
    mov  rsi, s_r11
    call emit_cstr
    mov  rsi, s_nl
    call emit_cstr
    pop  rcx
    pop  rsi
    inc  ecx
    jmp  .ps_copy
.ps_done:
    pop  rbx
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .pspill
.pspill_end:
    pop  r14
    pop  r13
    ; a fn value: the names it keeps, out of its record
    cmp  dword [rel cg_lam_cur], -1
    je   .no_lamcopy
    call cg_lam_prologue
.no_lamcopy:

    ; main on Windows starts the runtime before any thread can exist: the
    ; per-thread failure state needs its TLS slot.
    mov  rdi, [r12 + AST.data]
    call name_is_main
    test rax, rax
    jz   .no_rtinit
    mov  al, [rel cg_target]
    cmp  al, TARGET_ELF
    je   .no_rtinit
    cmp  byte [rel cg_bare], 0
    jne  .no_rtinit
    mov  rsi, s_rt_init
    call emit_cstr
.no_rtinit:
    ; main also gives the globals whose first value is not a plain number
    ; that value, before anything else runs
    mov  rdi, [r12 + AST.data]
    call name_is_main
    test rax, rax
    jz   .no_ginit
    call cg_emit_global_inits
.no_ginit:

    ; body
    mov  rdi, [r12 + AST.right]
    call cg_emit

    ; return label
    mov  edi, r14d
    mov  eax, IR_RETLBL
    call ir_ctl
    ; epilogue
    mov  rsi, s_movrsprbp
    call emit_cstr
    mov  rsi, s_poprbp
    call emit_cstr
    ; main -> ExitProcess ; others -> ret
    mov  rdi, [r12 + AST.data]
    call name_is_main
    test rax, rax
    jz   .plain_ret
    mov  al, [rel cg_target]
    cmp  al, TARGET_ELF
    je   .use_exitsys
    cmp  byte [rel cg_bare], 0
    jne  .use_halt
    mov  rsi, s_retmain
    call emit_cstr
    jmp  .done
.use_exitsys:
    mov  rsi, s_retexit
    call emit_cstr
    jmp  .done
.use_halt:
    mov  rsi, s_rethalt
    call emit_cstr
    jmp  .done
.plain_ret:
    mov  rsi, s_ret
    call emit_cstr
.done:
    call ir_end                      ; write the captured function out
    mov  rdi, r12
    call kt_fn_end
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; THE BUILT-IN TYPES: text, list<T>, map<T>
;
; All three are one i64 at run time, a handle of std_text, std_list or
; std_map. What the compiler adds is knowing which is which: print shows a
; text as its words and a list as [1, 2, 3], == compares two texts by their
; bytes, + joins texts, a text declared from "..." is a text of its own that
; text_add can grow, and a list<T> or map<T> declared without a value starts
; empty. l[i] and m[k] are turned into calls by the parser already.
;
; The type tag: bits 0-3 the kind (1 text, 2 list, 3 map, 4 an array of
; texts), bits 4-7 the element (0 integer or handle, 1 text, 2 real).
; ==============================================================================

; cg_expr_vtag(rdi = expression) -> eax = its type tag, 0 for a plain value.
; Preserves every other register.
cg_expr_vtag:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    push r12
    test rdi, rdi
    jz   .vt_no
    mov  r12, rdi
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    je   .vt_ident
    cmp  rax, AST_CALL
    je   .vt_call
    cmp  rax, AST_BINOP
    je   .vt_binop
    cmp  rax, AST_MEMBER
    je   .vt_member
    cmp  rax, AST_INDEX
    je   .vt_index
    cmp  rax, AST_LAMBDA
    je   .vt_lambda
    jmp  .vt_no
.vt_lambda:
    movzx eax, word [r12 + AST.col]
    call cg_fnval_tag
    jmp  .vt_out
.vt_ident:
    mov  rdi, [r12 + AST.data]
    call cg_vtag_of_name
    test eax, eax
    jnz  .vt_out
    ; a function's name: a function value
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    jne  .vt_no
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    jne  .vt_no
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    cmp  eax, -1
    je   .vt_no
    lea  rcx, [rel fn_ret_float]
    mov  edx, [rcx + rax*4]
    lea  rcx, [rel fn_ret_vtag]
    mov  eax, [rcx + rax*4]
    shl  eax, 8
    or   eax, edx
    call cg_fnval_tag
    jmp  .vt_out
.vt_index:
    ; an element of an array of texts
    mov  rdi, [r12 + AST.data]
    call cg_vtag_of_name
    mov  ecx, eax
    and  ecx, 15
    cmp  ecx, 4
    jne  .vt_no
    shr  eax, 4
    and  eax, 15
    jmp  .vt_out
.vt_call:
    ; a read the parser made from l[i] carries its element's tag
    movzx eax, word [r12 + AST.col]
    shr  eax, 8
    test eax, eax
    jnz  .vt_out
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .vt_no
    call cg_find_var_idx
    cmp  eax, -1
    jne  .vt_valcall
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    cmp  eax, -1
    jne  .vt_named
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    je   .vt_no
.vt_valcall:
    ; through a value: what fn(...) -> R says R is
    mov  rdi, [r12 + AST.data]
    call cg_vtag_of_name
    mov  ecx, eax
    and  ecx, 15
    cmp  ecx, 5
    jne  .vt_no
    shr  eax, 4
    and  eax, 15
    cmp  eax, 1
    jne  .vt_no
    jmp  .vt_out
.vt_named:
    lea  rcx, [rel fn_ret_vtag]
    mov  eax, [rcx + rax*4]
    jmp  .vt_out
.vt_binop:
    ; text + anything, or "..." + text, is a new text
    cmp  qword [r12 + AST.data], TOK_PLUS
    jne  .vt_no
    mov  rdi, r12
    call cg_is_concat
    test eax, eax
    jz   .vt_no
    mov  eax, 1
    jmp  .vt_out
.vt_member:
    mov  rdi, r12
    call cg_member_resolve
    mov  eax, [rel mem_vtag]
    jmp  .vt_out
.vt_no:
    xor  eax, eax
.vt_out:
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; cg_vtag_of_name(rdi = name token) -> eax = the tag of that local or global
cg_vtag_of_name:
    push rdi
    call cg_find_var_idx
    pop  rdi
    cmp  eax, -1
    je   .vn_glb
    lea  rcx, [rel var_vtag]
    mov  eax, [rcx + rax*4]
    ret
.vn_glb:
    call cg_find_global
    cmp  eax, -1
    je   .vn_no
    lea  rcx, [rel g_vtag]
    mov  eax, [rcx + rax*4]
    ret
.vn_no:
    xor  eax, eax
    ret

; cg_is_textish(rdi = expression) -> eax = 1 when it is a text or a "..."
cg_is_textish:
    test rdi, rdi
    jz   .tx_no
    cmp  qword [rdi + AST.node_type], AST_STRING_LIT
    je   .tx_yes
    call cg_expr_vtag
    cmp  eax, 1
    je   .tx_yes
.tx_no:
    xor  eax, eax
    ret
.tx_yes:
    mov  eax, 1
    ret

; cg_is_concat(rdi = '+' node) -> eax = 1 when it joins texts: the left side
; is a text or a "...". ("..." + n used to move the address n bytes on; the
; bytes of a literal are reached with text_at now, and + means joining.)
cg_is_concat:
    push r12
    mov  r12, rdi
    mov  rdi, [r12 + AST.left]
    call cg_expr_vtag
    cmp  eax, 1
    je   .cc_yes
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .cc_no
    cmp  qword [rdi + AST.node_type], AST_STRING_LIT
    je   .cc_lit
    jmp  .cc_no
.cc_lit:
    ; "..." + a value joins; inside raw { } it is address arithmetic
    cmp  dword [rel cg_in_raw], 0
    jne  .cc_no
    jmp  .cc_yes
.cc_no:
    xor  eax, eax
    pop  r12
    ret
.cc_yes:
    mov  eax, 1
    pop  r12
    ret

; cg_is_textcmp(rdi = '==' or '!=' node) -> eax = 1 when it compares texts:
; one side a text, the other a text or a "..."
cg_is_textcmp:
    push r12
    mov  r12, rdi
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_EQ
    je   .tc_op
    cmp  rax, TOK_NEQ
    jne  .tc_no
.tc_op:
    mov  rdi, [r12 + AST.left]
    call cg_expr_vtag
    cmp  eax, 1
    jne  .tc_right
    mov  rdi, [r12 + AST.right]
    call cg_is_textish
    test eax, eax
    jnz  .tc_yes
    jmp  .tc_no
.tc_right:
    mov  rdi, [r12 + AST.right]
    call cg_expr_vtag
    cmp  eax, 1
    jne  .tc_no
    mov  rdi, [r12 + AST.left]
    call cg_is_textish
    test eax, eax
    jnz  .tc_yes
.tc_no:
    xor  eax, eax
    pop  r12
    ret
.tc_yes:
    mov  eax, 1
    pop  r12
    ret

; cg_decl_vtag(rdi = AST_VAR_DECL) -> eax = the tag of the variable: the
; declared one, or for 'var x = value' with no type, the value's
cg_decl_vtag:
    movzx eax, word [rdi + AST.col]
    shr  eax, 8
    test eax, eax
    jnz  .dv_out
    movzx eax, word [rdi + AST.col]
    test eax, 8
    jnz  .dv_none                    ; a type was written: it says no tag
    cmp  qword [rdi + AST.type_info], 0
    jne  .dv_none
    mov  rdi, [rdi + AST.right]
    test rdi, rdi
    jz   .dv_none
    call cg_expr_vtag
    mov  ecx, eax
    and  ecx, 15
    cmp  ecx, 4
    je   .dv_none                    ; an array's tag belongs to the array
    ret
.dv_none:
    xor  eax, eax
.dv_out:
    ret

; cg_emit_global_inits(): at the start of main, every global whose value is
; not a number written out -- an expression, a "..." for a text -- gets it,
; in the order they are declared; a list<T> or map<T> with no value starts
; empty. Plain numbers are already in the data section.
cg_emit_global_inits:
    push rbx
    push r12
    push r13
    mov  rbx, [rel cg_root]
.gi_loop:
    test rbx, rbx
    jz   .gi_done
    cmp  qword [rbx + AST.node_type], AST_PROGRAM
    jne  .gi_done
    mov  r12, [rbx + AST.left]
    test r12, r12
    jz   .gi_next
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_VAR_DECL
    je   .gi_var
    cmp  rax, AST_CONST_DECL
    jne  .gi_next
.gi_var:
    cmp  qword [r12 + AST.type_info], 0
    jne  .gi_next                    ; an array
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .gi_scalar
    cmp  qword [rdi + TOKEN.type], KW_STR
    je   .gi_next                    ; a stream
    call cg_find_struct
    cmp  eax, -1
    jne  .gi_next                    ; a struct
.gi_scalar:
    mov  rdi, r12
    call cg_decl_vtag
    mov  r13d, eax
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .gi_novalue
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_INTEGER_LIT
    je   .gi_next
    cmp  rax, AST_FLOAT_LIT
    je   .gi_next
    cmp  rax, AST_BOOL_LIT
    je   .gi_next
    movzx eax, word [r12 + AST.col]
    test eax, 1
    jnz  .gi_float
    mov  esi, r13d
    call cg_emit_for
    jmp  .gi_store
.gi_float:
    call cg_emit_float
    mov  rsi, s_stgf_pre
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_stgf_suf
    call emit_cstr
    jmp  .gi_next
.gi_novalue:
    mov  eax, r13d
    and  eax, 15
    lea  rdi, [rel tk_list_new]
    cmp  eax, 2
    je   .gi_new
    lea  rdi, [rel tk_map_new]
    cmp  eax, 3
    jne  .gi_next
.gi_new:
    call cg_lib_call
.gi_store:
    mov  rsi, s_stg_pre
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_stg_suf
    call emit_cstr
.gi_next:
    mov  rbx, [rbx + AST.right]
    jmp  .gi_loop
.gi_done:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_lib_call(rdi = token of a library function): the call, arguments already
; in their registers. Preserves every register except rax.
cg_lib_call:
    push rdi
    push rsi
    call cg_note_call
    mov  rsi, s_shadow_sub
    call emit_cstr
    call kt_flush
    mov  rsi, s_call
    call emit_cstr
    mov  rdi, [rsp + 8]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_shadow_add
    call emit_cstr
    pop  rsi
    pop  rdi
    ret

; cg_emit_for(rdi = value, esi = tag of where it goes) -> the value in rax.
; A "..." going into a text becomes a new text; [a, b] going into a list<T>
; becomes a new list.
cg_emit_for:
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, esi
    test r12, r12
    jz   .ef_plain
    mov  eax, r13d
    and  eax, 15
    cmp  eax, 1
    je   .ef_text
    cmp  eax, 2
    je   .ef_list
    jmp  .ef_plain
.ef_text:
    cmp  qword [r12 + AST.node_type], AST_STRING_LIT
    jne  .ef_plain
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_movrcxrax
    call emit_cstr
    lea  rdi, [rel tk_text]
    call cg_lib_call
    jmp  .ef_out
.ef_list:
    cmp  qword [r12 + AST.node_type], AST_ARRAY_LIT
    jne  .ef_plain
    lea  rdi, [rel tk_list_new]
    call cg_lib_call
    mov  rsi, s_pushrax
    call emit_cstr
    push r14
    mov  r14, [r12 + AST.right]      ; the elements
.ef_elem:
    test r14, r14
    jz   .ef_elems_done
    mov  eax, r13d
    shr  eax, 4
    and  eax, 15
    cmp  eax, 2
    je   .ef_real
    mov  rdi, [r14 + AST.left]
    mov  esi, eax                    ; a text element from "..." is a text too
    call cg_emit_for
    mov  rsi, s_rdx_rax
    call emit_cstr
    mov  rsi, s_pop_rcx_keep
    call emit_cstr
    lea  rdi, [rel tk_list_add]
    call cg_lib_call
    jmp  .ef_next
.ef_real:
    mov  rdi, [r14 + AST.left]
    call cg_emit_float
    mov  rsi, s_xmm1_xmm0
    call emit_cstr
    mov  rsi, s_pop_rcx_keep
    call emit_cstr
    lea  rdi, [rel tk_list_add_real]
    call cg_lib_call
.ef_next:
    mov  r14, [r14 + AST.right]
    jmp  .ef_elem
.ef_elems_done:
    pop  r14
    mov  rsi, s_poprax
    call emit_cstr
    jmp  .ef_out
.ef_plain:
    mov  rdi, r12
    call cg_emit
.ef_out:
    pop  r13
    pop  r12
    ret

; cg_emit_textcmp(r12 = '==' / '!=' of two texts): text_same, turned around
; for !=. Result in rax.
cg_emit_textcmp:
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rsi, s_pushrax
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_rdx_rax
    call emit_cstr
    mov  rsi, s_pop_rcx
    call emit_cstr
    lea  rdi, [rel tk_text_same]
    call cg_lib_call
    cmp  qword [r12 + AST.data], TOK_NEQ
    jne  .tcm_out
    mov  rsi, s_xor_rax1
    call emit_cstr
.tcm_out:
    ret

; cg_emit_concat(r12 = '+' that joins texts): a new text with the left side,
; then the right side added -- text_add, text_add_int or text_add_real as
; the right side is a text, an integer or a real. Result in rax.
cg_emit_concat:
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rsi, s_movrcxrax
    call emit_cstr
    lea  rdi, [rel tk_text]
    call cg_lib_call
    mov  rsi, s_pushrax
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_is_textish
    test eax, eax
    jnz  .cat_text
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .cat_real
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_rdx_rax
    call emit_cstr
    mov  rsi, s_pop_rcx_keep
    call emit_cstr
    lea  rdi, [rel tk_text_add_int]
    call cg_lib_call
    jmp  .cat_done
.cat_text:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_rdx_rax
    call emit_cstr
    mov  rsi, s_pop_rcx_keep
    call emit_cstr
    lea  rdi, [rel tk_text_add]
    call cg_lib_call
    jmp  .cat_done
.cat_real:
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rsi, s_xmm1_xmm0
    call emit_cstr
    mov  rsi, s_pop_rcx_keep
    call emit_cstr
    mov  rsi, s_r8_six
    call emit_cstr
    lea  rdi, [rel tk_text_add_real]
    call cg_lib_call
.cat_done:
    mov  rsi, s_poprax
    call emit_cstr
    ret

; cg_emit_print_tagged(rdi = value, esi = its tag) -> eax = 1 when print was
; handled here: a text by say, a list by list_show, a map by map_show.
cg_emit_print_tagged:
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, esi
    mov  eax, r13d
    and  eax, 15
    cmp  eax, 1
    je   .pt_text
    cmp  eax, 2
    je   .pt_list
    cmp  eax, 3
    je   .pt_map
    xor  eax, eax
    jmp  .pt_out
.pt_text:
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_movrcxrax
    call emit_cstr
    lea  rdi, [rel tk_say]
    call cg_lib_call
    jmp  .pt_done
.pt_list:
    lea  rdi, [rel tk_list_show]
    call cg_find_func
    cmp  eax, -1
    jne  .pt_coll
    ; std_list alone has no way to write: the list printer is in std_text
    mov  qword [rel cg_err_tok], 0
    cmp  qword [r12 + AST.node_type], AST_IDENTIFIER
    jne  .pt_notok
    mov  rax, [r12 + AST.data]
    mov  [rel cg_err_tok], rax
.pt_notok:
    lea  rax, [rel s_err_lshow]
    mov  [rel cg_err_msg], rax
    lea  rax, [rel s_hint_lshow]
    mov  [rel cg_err_hint], rax
    mov  byte [rel cg_had_error], 1
    mov  eax, 1
    jmp  .pt_out
.pt_map:
.pt_coll:
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_movrcxrax
    call emit_cstr
    mov  rsi, s_rdx_imm
    call emit_cstr
    mov  edi, r13d
    shr  edi, 4
    and  edi, 15
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    lea  rdi, [rel tk_list_show]
    mov  eax, r13d
    and  eax, 15
    cmp  eax, 3
    jne  .pt_call
    lea  rdi, [rel tk_map_show]
.pt_call:
    call cg_lib_call
.pt_done:
    mov  eax, 1
.pt_out:
    pop  r13
    pop  r12
    ret

; ==============================================================================
; SEVERAL RESULTS
;
;   fn divide(a: i64, b: i64) -> (i64, i64) { return a / b, a % b; }
;   var q, r = divide(17, 5);
;
; The results leave in rax, rdx, r8 and r9; a real travels as its bits. When
; the first is a real it is also in xmm0, so a single use of the call --
; print(divide(...)) -- reads it like any real result.
; ==============================================================================

; cg_multi_float(eax = description, ecx = which) -> eax = 1 when that result
; is a real
cg_multi_float:
    add  ecx, 4
    shr  eax, cl
    and  eax, 1
    ret

; cg_multi_vtag(eax = description, ecx = which) -> eax = its type tag
cg_multi_vtag:
    shl  ecx, 2
    add  ecx, 8
    shr  eax, cl
    mov  ecx, eax
    and  ecx, 3                      ; kind
    shr  eax, 2
    and  eax, 3                      ; element
    shl  eax, 4
    or   eax, ecx
    ret

; cg_emit_return_multi(r12 = AST_RETURN with left = the values after the
; first): each value as the result it is declared, pushed in order, then
; popped into r9, r8, rdx, rax.
cg_emit_return_multi:
    push rbx
    push r13
    push r14
    xor  ebx, ebx                    ; which
    mov  r13, [r12 + AST.right]      ; the first value
    mov  r14, [r12 + AST.left]       ; the rest
.rm_loop:
    test r13, r13
    jz   .rm_pop
    cmp  ebx, 4
    jae  .rm_pop
    mov  eax, [rel cur_fn_multi]
    mov  ecx, ebx
    call cg_multi_float
    test eax, eax
    jnz  .rm_real
    mov  rdi, r13
    call cg_expr_is_float
    test eax, eax
    jnz  .rm_trunc
    mov  rdi, r13
    call cg_emit
    jmp  .rm_push
.rm_trunc:
    mov  rdi, r13
    call cg_emit_float
    mov  rsi, s_trunc
    call emit_cstr
.rm_push:
    mov  rsi, s_pushrax
    call emit_cstr
    jmp  .rm_next
.rm_real:
    mov  rdi, r13
    call cg_emit_float
    mov  rsi, s_push_xmm             ; the bits go on the stack as they are
    call emit_cstr
.rm_next:
    inc  ebx
    test r14, r14
    jz   .rm_last
    mov  r13, [r14 + AST.left]
    mov  r14, [r14 + AST.right]
    jmp  .rm_loop
.rm_last:
    xor  r13, r13
    jmp  .rm_loop
.rm_pop:
    cmp  ebx, 4
    jb   .rm_no4
    mov  rsi, s_pop_r9
    call emit_cstr
.rm_no4:
    cmp  ebx, 3
    jb   .rm_no3
    mov  rsi, s_pop_r8
    call emit_cstr
.rm_no3:
    cmp  ebx, 2
    jb   .rm_no2
    mov  rsi, s_pop_rdx
    call emit_cstr
.rm_no2:
    mov  rsi, s_poprax
    call emit_cstr
    ; a real first result is in xmm0 too
    mov  eax, [rel cur_fn_multi]
    xor  ecx, ecx
    call cg_multi_float
    test eax, eax
    jz   .rm_out
    mov  rsi, s_bits_xmm0
    call emit_cstr
.rm_out:
    pop  r14
    pop  r13
    pop  rbx
    ret

; cg_emit_multi(r12 = AST_MULTI): the call, its results parked on the stack,
; then taken off one by one into the targets. With 'var' (AST.data = 1) each
; target first gets the type of its result.
cg_emit_multi:
    push rbx
    push r13
    push r14
    push r15
    xor  r15d, r15d                  ; the description, 0 when unknown
    mov  rdi, [r12 + AST.right]
    mov  rdi, [rdi + AST.data]
    test rdi, rdi
    jz   .mu_have
    call cg_find_func
    cmp  eax, -1
    je   .mu_have
    lea  rcx, [rel fn_multi]
    mov  r15d, [rcx + rax*4]
.mu_have:
    mov  rdi, [r12 + AST.right]
    call cg_emit                     ; rax, rdx, r8, r9
    ; how many targets
    xor  ebx, ebx
    mov  r13, [r12 + AST.left]
.mu_count:
    test r13, r13
    jz   .mu_counted
    inc  ebx
    mov  r13, [r13 + AST.right]
    jmp  .mu_count
.mu_counted:
    cmp  ebx, 4
    jbe  .mu_push
    mov  ebx, 4
.mu_push:
    cmp  ebx, 4
    jb   .mu_p3
    mov  rsi, s_push_r9
    call emit_cstr
.mu_p3:
    cmp  ebx, 3
    jb   .mu_p2
    mov  rsi, s_push_r8
    call emit_cstr
.mu_p2:
    cmp  ebx, 2
    jb   .mu_p1
    mov  rsi, s_push_rdx
    call emit_cstr
.mu_p1:
    mov  rsi, s_pushrax
    call emit_cstr
    ; into the targets, first to last
    xor  r14d, r14d                  ; which
    mov  r13, [r12 + AST.left]
.mu_store:
    test r13, r13
    jz   .mu_done
    cmp  r14d, ebx
    jae  .mu_done
    mov  rsi, s_poprax
    call emit_cstr
    mov  rdi, [r13 + AST.left]
    test rdi, rdi
    jz   .mu_next                    ; '_'
    mov  rdi, [rdi + AST.data]       ; the name
    push rdi
    call cg_find_var_idx
    pop  rdi
    cmp  eax, -1
    je   .mu_global
    mov  r8d, eax                    ; its index
    cmp  qword [r12 + AST.data], 0
    je   .mu_typed
    ; declared here: the type of this result
    mov  eax, r15d
    mov  ecx, r14d
    call cg_multi_float
    lea  rcx, [rel var_isfloat]
    mov  [rcx + r8*4], eax
    mov  eax, r15d
    mov  ecx, r14d
    call cg_multi_vtag
    lea  rcx, [rel var_vtag]
    mov  [rcx + r8*4], eax
.mu_typed:
    lea  rcx, [rel var_offs]
    mov  edi, [rcx + r8*4]
    lea  rcx, [rel var_isfloat]
    mov  eax, [rcx + r8*4]
    test eax, eax
    jnz  .mu_real
    call ir_stloc                    ; mov [rbp-N], rax
    jmp  .mu_next
.mu_real:
    push rdi
    mov  rsi, s_bits_xmm0
    call emit_cstr
    pop  rdi
    call ir_fstloc                   ; movsd [rbp-N], xmm0
    jmp  .mu_next
.mu_global:
    push rdi
    mov  rsi, s_stg_pre
    call emit_cstr
    pop  rdi
    call cg_emit_gtok
    mov  rsi, s_stg_suf
    call emit_cstr
.mu_next:
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .mu_store
.mu_done:
    ; results nobody named were never pushed; nothing is left behind
    pop  r15
    pop  r14
    pop  r13
    pop  rbx
    ret

; ==============================================================================
; FUNCTIONS AS VALUES
;
;     var add = fn(a: i64, b: i64) -> i64 { return a + b + k; };
;     print(add(2, 3));
;     var g: fn(i64, i64) -> i64 = max;      // a function's name is a value too
;
; A function value is the address of a record: [code][the values it keeps].
; A named function has a fixed record, __fnrec_NAME: dq NAME. A fn written
; as a value gets one made when the expression runs (__clo_alloc), with the
; values of the variables around it that it uses -- kept by value, as they
; were at that moment. Calling through a value passes the record as a last,
; hidden argument: a named function never looks at it, a fn value reads what
; it keeps out of it at its start.
; ==============================================================================

; cg_node(edi = node type) -> rax = a zeroed node made here, 0 when out
cg_node:
    push rcx
    push rdx
    mov  eax, [rel cg_pool_n]
    cmp  eax, CG_POOL_NODES
    jae  .nd_full
    inc  dword [rel cg_pool_n]
    imul rax, AST_NODE_SIZE
    lea  rcx, [rel cg_pool]
    add  rax, rcx
    xor  edx, edx
    xor  ecx, ecx
.nd_clr:
    mov  [rax + rdx], rcx
    add  edx, 8
    cmp  edx, AST_NODE_SIZE
    jb   .nd_clr
    mov  [rax + AST.node_type], rdi
    pop  rdx
    pop  rcx
    ret
.nd_full:
    xor  eax, eax
    pop  rdx
    pop  rcx
    ret

; cg_fnval_tag(eax = flags of what a function returns, as AST.col) -> eax =
; the tag of a value of that function: 5, with 2 for a real result and 1 for
; a text one as the element
cg_fnval_tag:
    test eax, 1
    jnz  .ft_real
    shr  eax, 8
    cmp  eax, 1
    jne  .ft_plain
    mov  eax, 0x15
    ret
.ft_real:
    mov  eax, 0x25
    ret
.ft_plain:
    mov  eax, 5
    ret

; cg_param_vtag(rdi = AST_CALL, esi = which argument) -> eax = the type tag
; of that parameter of the function called, 0 when unknown
cg_param_vtag:
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, esi
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .pv_no
    call cg_find_func
    cmp  eax, -1
    je   .pv_no
    lea  rcx, [rel fn_nodes]
    mov  rcx, [rcx + rax*8]
    mov  rcx, [rcx + AST.left]       ; the parameters
.pv_walk:
    test rcx, rcx
    jz   .pv_no
    test r13d, r13d
    jz   .pv_have
    dec  r13d
    mov  rcx, [rcx + AST.right]
    jmp  .pv_walk
.pv_have:
    movzx eax, word [rcx + AST.col]
    shr  eax, 8
    pop  r13
    pop  r12
    ret
.pv_no:
    xor  eax, eax
    pop  r13
    pop  r12
    ret

; cg_call_kind(rdi = AST_CALL) -> eax = 0 a function, 1 through a variable
; holding a function value, 2 nothing by that name (reported as an error)
cg_call_kind:
    push r12
    mov  r12, rdi
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .ck_fn
    call cg_find_var_idx
    cmp  eax, -1
    jne  .ck_val
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    cmp  eax, -1
    jne  .ck_fn
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    jne  .ck_val
    mov  rdi, [r12 + AST.data]
    call cg_is_intrinsic
    test eax, eax
    jnz  .ck_fn
    ; no function, no variable: say so instead of jumping to address zero
    mov  rax, [r12 + AST.data]
    mov  [rel cg_err_tok], rax
    lea  rax, [rel s_err_nofn]
    mov  [rel cg_err_msg], rax
    mov  qword [rel cg_err_hint], 0
    mov  byte [rel cg_had_error], 1
    mov  eax, 2
    pop  r12
    ret
.ck_val:
    mov  eax, 1
    pop  r12
    ret
.ck_fn:
    xor  eax, eax
    pop  r12
    ret

; cg_call_ret_float(rdi = AST_CALL) -> eax = 1 when its result is a real:
; a function declared so, or a value whose fn type returns f64
cg_call_ret_float:
    push r12
    mov  r12, rdi
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .cr_no
    lea  rsi, [rel tk_vec4_sum]
    call tok_equal
    test eax, eax
    jnz  .cr_yes
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    jne  .cr_val
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    cmp  eax, -1
    je   .cr_gval
    lea  rcx, [rel fn_ret_float]
    mov  eax, [rcx + rax*4]
    pop  r12
    ret
.cr_gval:
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    je   .cr_no
.cr_val:
    mov  rdi, [r12 + AST.data]
    call cg_vtag_of_name
    mov  ecx, eax
    and  ecx, 15
    cmp  ecx, 5
    jne  .cr_no
    shr  eax, 4
    and  eax, 15
    cmp  eax, 2
    jne  .cr_no
    mov  eax, 1
    pop  r12
    ret
.cr_no:
    xor  eax, eax
    pop  r12
    ret
.cr_yes:
    mov  eax, 1
    pop  r12
    ret

; cg_fnval_args(rdi = AST_CALL through a value): the variable itself goes on
; the end of the arguments, and the call is marked
cg_fnval_args:
    push r12
    mov  r12, rdi
    cmp  qword [r12 + AST.owner_type], FNVAL_MARK
    je   .fa_out                     ; already done
    mov  qword [r12 + AST.owner_type], FNVAL_MARK
    mov  edi, AST_IDENTIFIER
    call cg_node
    test rax, rax
    jz   .fa_out
    mov  rcx, [r12 + AST.data]
    mov  [rax + AST.data], rcx
    push rax
    mov  edi, AST_ARG
    call cg_node
    pop  rcx
    test rax, rax
    jz   .fa_out
    mov  [rax + AST.left], rcx
    mov  rcx, [r12 + AST.right]
    test rcx, rcx
    jnz  .fa_tail
    mov  [r12 + AST.right], rax
    jmp  .fa_out
.fa_tail:
    cmp  qword [rcx + AST.right], 0
    je   .fa_link
    mov  rcx, [rcx + AST.right]
    jmp  .fa_tail
.fa_link:
    mov  [rcx + AST.right], rax
.fa_out:
    pop  r12
    ret

; cg_emit_fnval_target(rdi = name of the variable): r11 = the value, then
; call the code its record starts with. Nothing else is touched: the
; arguments are already in their registers.
cg_emit_fnval_target:
    push r12
    mov  r12, rdi
    call cg_find_var_idx
    cmp  eax, -1
    je   .ft_glb
    mov  rsi, s_r11_ld
    call emit_cstr
    mov  rdi, r12
    call cg_find_var
    mov  edi, eax
    call emit_uint
    jmp  .ft_close
.ft_glb:
    mov  rsi, s_r11_ldg
    call emit_cstr
    mov  rdi, r12
    call cg_emit_gtok
.ft_close:
    mov  rsi, s_rbr_nl
    call emit_cstr
    mov  rsi, s_r11_call
    call emit_cstr
    pop  r12
    ret

; cg_lam_excl(rdi = node): the names a fn value declares inside itself --
; they are its own, not kept from around it
cg_lam_excl:
    push r12
    mov  r12, rdi
    test r12, r12
    jz   .lx_out
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_VAR_DECL
    je   .lx_decl
    cmp  rax, AST_CONST_DECL
    je   .lx_decl
    cmp  rax, AST_MEMBER
    je   .lx_out
    cmp  rax, AST_ADDR_OF
    je   .lx_out
    cmp  rax, AST_INDEX
    je   .lx_idx
    cmp  rax, AST_LAMBDA
    je   .lx_out
    mov  rdi, [r12 + AST.left]
    call cg_lam_excl
    mov  rdi, [r12 + AST.right]
    call cg_lam_excl
    jmp  .lx_out
.lx_idx:
    mov  rdi, [r12 + AST.right]
    call cg_lam_excl
    jmp  .lx_out
.lx_decl:
    mov  rdi, [r12 + AST.data]
    call cg_lx_add
    mov  rdi, [r12 + AST.right]
    call cg_lam_excl
.lx_out:
    pop  r12
    ret

; cg_lx_add(rdi = name token)
cg_lx_add:
    mov  eax, [rel lx_n]
    cmp  eax, 256
    jae  .la_out
    lea  rcx, [rel lx_toks]
    mov  [rcx + rax*8], rdi
    inc  eax
    mov  [rel lx_n], eax
.la_out:
    ret

; cg_lx_has(rdi = name token) -> eax = 1 when the fn value declares it
cg_lx_has:
    push rbx
    push r12
    mov  r12, rdi
    xor  ebx, ebx
.lh_loop:
    cmp  ebx, [rel lx_n]
    jae  .lh_no
    lea  rax, [rel lx_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .lh_yes
    inc  ebx
    jmp  .lh_loop
.lh_no:
    xor  eax, eax
    jmp  .lh_out
.lh_yes:
    mov  eax, 1
.lh_out:
    pop  r12
    pop  rbx
    ret

; cg_cap_consider(rdi = name token, esi = queue entry): kept when it is a
; plain local of the function around (not an array or a struct), not one of
; the fn value's own, and not kept already
cg_cap_consider:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, esi
    test r12, r12
    jz   .cc2_out
    call cg_lx_has
    test eax, eax
    jnz  .cc2_out
    mov  rdi, r12
    call cg_find_var_idx
    cmp  eax, -1
    je   .cc2_out
    mov  ebx, eax
    lea  rcx, [rel var_arrlen]
    mov  eax, [rcx + rbx*4]
    test eax, eax
    jnz  .cc2_out
    lea  rcx, [rel var_structs]
    mov  eax, [rcx + rbx*4]
    cmp  eax, -1
    jne  .cc2_out
    ; kept already?
    mov  eax, r13d
    shl  eax, 4                      ; LQ_CAPS per entry
    lea  rcx, [rel lq_ncap]
    mov  edx, [rcx + r13*4]
    xor  r8d, r8d
.cc2_dup:
    cmp  r8d, edx
    jae  .cc2_new
    lea  rcx, [rel lq_cap]
    mov  r9d, eax
    add  r9d, r8d
    mov  rsi, [rcx + r9*8]
    mov  rdi, r12
    push rax
    push rdx
    push r8
    call tok_equal
    mov  r10d, eax
    pop  r8
    pop  rdx
    pop  rax
    test r10d, r10d
    jnz  .cc2_out
    inc  r8d
    jmp  .cc2_dup
.cc2_new:
    cmp  edx, LQ_CAPS
    jae  .cc2_full
    mov  r9d, eax
    add  r9d, edx
    lea  rcx, [rel lq_cap]
    mov  [rcx + r9*8], r12
    lea  rcx, [rel var_isfloat]
    mov  r10d, [rcx + rbx*4]
    lea  rcx, [rel var_vtag]
    mov  r11d, [rcx + rbx*4]
    shl  r11d, 8
    or   r10d, r11d
    lea  rcx, [rel lq_cflag]
    mov  [rcx + r9*4], r10d
    inc  edx
    lea  rcx, [rel lq_ncap]
    mov  [rcx + r13*4], edx
    jmp  .cc2_out
.cc2_full:
    mov  [rel cg_err_tok], r12
    lea  rax, [rel s_err_lamfull]
    mov  [rel cg_err_msg], rax
    mov  qword [rel cg_err_hint], 0
    mov  byte [rel cg_had_error], 1
.cc2_out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_cap_walk(rdi = node, esi = queue entry): every name the body uses
cg_cap_walk:
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, esi
    test r12, r12
    jz   .cw_out
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    je   .cw_name
    cmp  rax, AST_CALL
    je   .cw_call
    cmp  rax, AST_VAR_DECL
    je   .cw_decl
    cmp  rax, AST_CONST_DECL
    je   .cw_decl
    cmp  rax, AST_MEMBER
    je   .cw_out
    cmp  rax, AST_ADDR_OF
    je   .cw_out
    cmp  rax, AST_INDEX
    je   .cw_idx
    cmp  rax, AST_IF
    je   .cw_cond
    cmp  rax, AST_WHILE
    je   .cw_cond
    cmp  rax, AST_LAMBDA
    je   .cw_lambda
    jmp  .cw_kids
.cw_name:
    mov  rdi, [r12 + AST.data]
    mov  esi, r13d
    call cg_cap_consider
    jmp  .cw_out
.cw_call:
    mov  rdi, [r12 + AST.data]       ; a variable holding a function
    mov  esi, r13d
    call cg_cap_consider
    mov  rdi, [r12 + AST.right]
    mov  esi, r13d
    call cg_cap_walk
    jmp  .cw_out
.cw_decl:
    mov  rdi, [r12 + AST.right]
    mov  esi, r13d
    call cg_cap_walk
    jmp  .cw_out
.cw_idx:
    mov  rdi, [r12 + AST.right]
    mov  esi, r13d
    call cg_cap_walk
    jmp  .cw_out
.cw_cond:
    mov  rdi, [r12 + AST.data]
    mov  esi, r13d
    call cg_cap_walk
    jmp  .cw_kids
.cw_lambda:
    ; what an inner one keeps has to pass through this one
    mov  rdi, [r12 + AST.right]
    mov  esi, r13d
    call cg_cap_walk
    jmp  .cw_out
.cw_kids:
    mov  rdi, [r12 + AST.left]
    mov  esi, r13d
    call cg_cap_walk
    mov  rdi, [r12 + AST.right]
    mov  esi, r13d
    call cg_cap_walk
.cw_out:
    pop  r13
    pop  r12
    ret

; cg_emit_lambda(r12 = AST_LAMBDA): queue it, work out what it keeps, and
; make its record. Result: the record in rax.
cg_emit_lambda:
    push rbx
    push r13
    push r14
    mov  ebx, [rel lq_n]
    cmp  ebx, LQ_MAX
    jb   .el_room
    mov  rax, [r12 + AST.data]
    mov  [rel cg_err_tok], rax
    lea  rax, [rel s_err_lamfull]
    mov  [rel cg_err_msg], rax
    mov  byte [rel cg_had_error], 1
    jmp  .el_out
.el_room:
    inc  dword [rel lq_n]
    lea  rcx, [rel lq_node]
    mov  [rcx + rbx*8], r12
    lea  rcx, [rel lq_ncap]
    xor  edx, edx
    mov  [rcx + rbx*4], edx
    ; its own names: the parameters and what it declares
    mov  dword [rel lx_n], 0
    mov  r13, [r12 + AST.left]
.el_par:
    test r13, r13
    jz   .el_pdone
    mov  rdi, [r13 + AST.data]
    call cg_lx_add
    mov  r13, [r13 + AST.right]
    jmp  .el_par
.el_pdone:
    mov  rdi, [r12 + AST.right]
    call cg_lam_excl
    mov  rdi, [r12 + AST.right]
    mov  esi, ebx
    call cg_cap_walk
    ; the record: [code][kept values]
    lea  rcx, [rel lq_ncap]
    mov  r13d, [rcx + rbx*4]
    mov  rsi, s_clo_size
    call emit_cstr
    mov  edi, r13d
    shl  edi, 3
    add  edi, 8
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_clo_call
    call emit_cstr
    mov  rsi, s_clo_code
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_clo_code2
    call emit_cstr
    xor  r14d, r14d
.el_cap:
    cmp  r14d, r13d
    jae  .el_capped
    mov  edi, AST_IDENTIFIER
    call cg_node
    test rax, rax
    jz   .el_capped
    mov  ecx, ebx
    shl  ecx, 4                      ; LQ_CAPS per entry
    add  ecx, r14d
    lea  rdx, [rel lq_cap]
    mov  rdx, [rdx + rcx*8]
    mov  [rax + AST.data], rdx
    lea  rdx, [rel lq_cflag]
    mov  edx, [rdx + rcx*4]
    mov  rdi, rax
    test edx, 1
    jnz  .el_real
    call cg_emit
    mov  rsi, s_pushrax
    call emit_cstr
    jmp  .el_put
.el_real:
    call cg_emit_float
    mov  rsi, s_push_xmm             ; the bits, as they are
    call emit_cstr
.el_put:
    mov  rsi, s_clo_put
    call emit_cstr
    mov  edi, r14d
    shl  edi, 3
    add  edi, 8
    call emit_uint
    mov  rsi, s_clo_put2
    call emit_cstr
    inc  r14d
    jmp  .el_cap
.el_capped:
    mov  rsi, s_poprax
    call emit_cstr
.el_out:
    pop  r14
    pop  r13
    pop  rbx
    ret

; cg_drain_lambdas(): every fn value queued so far, emitted as a function of
; its own -- after the one it sits in, never inside it. One may queue more.
cg_drain_lambdas:
    push rbx
    push r12
.dl_loop:
    mov  ebx, [rel lq_done]
    cmp  ebx, [rel lq_n]
    jae  .dl_out
    inc  dword [rel lq_done]
    lea  rcx, [rel lq_node]
    mov  r12, [rcx + rbx*8]
    ; its hidden last parameter: the record
    mov  edi, AST_PARAM
    call cg_node
    test rax, rax
    jz   .dl_out
    lea  rcx, [rel tk_env]
    mov  [rax + AST.data], rcx
    mov  rcx, [r12 + AST.left]
    test rcx, rcx
    jnz  .dl_tail
    mov  [r12 + AST.left], rax
    jmp  .dl_fn
.dl_tail:
    cmp  qword [rcx + AST.right], 0
    je   .dl_link
    mov  rcx, [rcx + AST.right]
    jmp  .dl_tail
.dl_link:
    mov  [rcx + AST.right], rax
.dl_fn:
    mov  edi, AST_FUNCTION
    call cg_node
    test rax, rax
    jz   .dl_out
    mov  rcx, [r12 + AST.data]
    mov  [rax + AST.data], rcx
    mov  rcx, [r12 + AST.left]
    mov  [rax + AST.left], rcx
    mov  rcx, [r12 + AST.right]
    mov  [rax + AST.right], rcx
    movzx ecx, word [r12 + AST.col]
    mov  [rax + AST.col], cx
    mov  [rel cg_lam_cur], ebx
    mov  rdi, rax
    call cg_function
    mov  dword [rel cg_lam_cur], -1
    jmp  .dl_loop
.dl_out:
    pop  r12
    pop  rbx
    ret

; cg_lam_prologue(): at the start of a fn value, after its parameters: each
; kept name becomes a local, filled from the record
cg_lam_prologue:
    push rbx
    push r12
    push r13
    push r14
    mov  ebx, [rel cg_lam_cur]
    lea  rdi, [rel tk_env]
    call cg_find_var
    mov  r14d, eax                   ; the record's slot
    lea  rcx, [rel lq_ncap]
    mov  r13d, [rcx + rbx*4]
    xor  r12d, r12d
.lp_loop:
    cmp  r12d, r13d
    jae  .lp_out
    mov  ecx, ebx
    shl  ecx, 4                      ; LQ_CAPS per entry
    add  ecx, r12d
    lea  rdx, [rel lq_cflag]
    mov  eax, [rdx + rcx*4]
    mov  edx, eax
    and  edx, 1
    mov  [rel pending_float], edx
    shr  eax, 8
    mov  [rel pending_vtag], eax
    lea  rdx, [rel lq_cap]
    mov  rdi, [rdx + rcx*8]
    mov  esi, 1
    call cg_add_var                  ; rax = its slot
    push rax
    mov  edi, r14d
    call ir_ldloc                    ; rax = the record
    mov  rsi, s_env_get
    call emit_cstr
    mov  edi, r12d
    shl  edi, 3
    add  edi, 8
    call emit_uint
    mov  rsi, s_rbr_nl
    call emit_cstr
    pop  rdi
    mov  ecx, ebx
    shl  ecx, 4                      ; LQ_CAPS per entry
    add  ecx, r12d
    lea  rdx, [rel lq_cflag]
    mov  eax, [rdx + rcx*4]
    test eax, 1
    jnz  .lp_real
    call ir_stloc
    jmp  .lp_next
.lp_real:
    push rdi
    mov  rsi, s_bits_xmm0
    call emit_cstr
    pop  rdi
    call ir_fstloc
.lp_next:
    inc  r12d
    jmp  .lp_loop
.lp_out:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_emit_fnrecs(): the fixed record of every named function used as a value
cg_emit_fnrecs:
    push rbx
    xor  ebx, ebx
.fr_loop:
    cmp  ebx, [rel fn_count]
    jae  .fr_out
    lea  rax, [rel fn_asval]
    cmp  byte [rax + rbx], 0
    je   .fr_next
    mov  rsi, s_sec_data_nl
    call emit_cstr
    mov  rsi, s_fnrec
    call emit_cstr
    lea  rax, [rel fn_toks]
    mov  rdi, [rax + rbx*8]
    call emit_tok
    mov  rsi, s_fnrec_dq
    call emit_cstr
    lea  rax, [rel fn_toks]
    mov  rdi, [rax + rbx*8]
    call emit_tok
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_sec_text_nl
    call emit_cstr
.fr_next:
    inc  ebx
    jmp  .fr_loop
.fr_out:
    pop  rbx
    ret

; ==============================================================================
; FOUR REALS AT A TIME: vec4 of f32
;
;   vec4_load(&a[i])            four f32 from an [f32; N] (movups)
;   vec4_store(&a[i], v)        and back
;   vec4_add / sub / mul / div(v, w)   all four at once (addps ...)
;   vec4_fill(x)                x in all four
;   vec4_sum(v)                 the four added up, as an f64
;   vec2_div(v, w)              the f64 pair's missing division
;
; Written as calls; none of them is a function. The four floats live in
; xmm0 and only compose by nesting, like the vec2 family.
; ==============================================================================

; cg_intrinsic(r12 = AST_CALL) -> eax = 1 when it was one of the above and
; is emitted
cg_intrinsic:
    push rbx
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .in_no
    xor  ebx, ebx
.in_find:
    cmp  ebx, 9
    jae  .in_no
    lea  rax, [rel in_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, [r12 + AST.data]
    call tok_equal
    test eax, eax
    jnz  .in_have
    inc  ebx
    jmp  .in_find
.in_have:
    mov  rax, [r12 + AST.right]      ; first argument
    test rax, rax
    jz   .in_no
    cmp  ebx, 0
    je   .in_load
    cmp  ebx, 1
    je   .in_store
    cmp  ebx, 6
    je   .in_sum
    cmp  ebx, 7
    je   .in_fill
    ; two vectors: left in xmm0, parked, right in xmm0, op into xmm1
    lea  rax, [rel in_ops]
    mov  rax, [rax + rbx*8]
    push rax
    mov  rdi, [r12 + AST.right]
    mov  rdi, [rdi + AST.left]
    call cg_emit
    mov  rsi, s_v4_spill
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    mov  rdi, [rdi + AST.right]
    test rdi, rdi
    jz   .in_bad_pop
    mov  rdi, [rdi + AST.left]
    call cg_emit
    mov  rsi, s_v4_fill
    call emit_cstr
    pop  rsi
    call emit_cstr
    jmp  .in_yes
.in_bad_pop:
    pop  rax
    jmp  .in_no
.in_load:
    mov  rdi, [rax + AST.left]
    call cg_emit                     ; the address
    mov  rsi, s_v4_load
    call emit_cstr
    jmp  .in_yes
.in_store:
    mov  rdi, [rax + AST.right]
    test rdi, rdi
    jz   .in_no
    mov  rdi, [rdi + AST.left]
    call cg_emit                     ; the vector
    mov  rsi, s_v4_spill
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    mov  rdi, [rdi + AST.left]
    call cg_emit                     ; the address
    mov  rsi, s_v4_fill
    call emit_cstr
    mov  rsi, s_v4_store1
    call emit_cstr
    jmp  .in_yes
.in_sum:
    mov  rdi, [rax + AST.left]
    call cg_emit
    mov  rsi, s_v4_sum
    call emit_cstr
    jmp  .in_yes
.in_fill:
    mov  rdi, [rax + AST.left]
    call cg_emit_float
    mov  rsi, s_v4_fillx
    call emit_cstr
.in_yes:
    mov  eax, 1
    pop  rbx
    ret
.in_no:
    xor  eax, eax
    pop  rbx
    ret

; cg_is_intrinsic(rdi = name token) -> eax = 1 for one of the names above
cg_is_intrinsic:
    push rbx
    push r12
    mov  r12, rdi
    xor  ebx, ebx
.ii_loop:
    cmp  ebx, 9
    jae  .ii_no
    lea  rax, [rel in_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .ii_yes
    inc  ebx
    jmp  .ii_loop
.ii_no:
    xor  eax, eax
    jmp  .ii_out
.ii_yes:
    mov  eax, 1
.ii_out:
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; FAILURE TRACES
; ==============================================================================

; kt_fn_begin(): a function starts. Lines are marked only for the hosted
; targets, where print_fail exists. Preserves every register.
kt_fn_begin:
    push rax
    mov  dword [rel kt_on], 0
    cmp  byte [rel cg_bare], 0
    jne  .fb_out
    mov  dword [rel kt_on], 1
.fb_out:
    mov  dword [rel kt_cnt], 0
    mov  dword [rel kt_last], 0
    mov  dword [rel kt_pend], 0
    mov  qword [rel kt_file], 0
    mov  eax, [rel kt_n]
    mov  [rel kt_first], eax
    pop  rax
    ret

; kt_mark(rdi = statement node): the statement's line becomes the pending
; one. Nothing is written yet: only a statement that calls a function or can
; fail ever shows up in a trace, so the label waits for kt_flush, which the
; call and the failure sites run. Preserves every register.
kt_mark:
    cmp  dword [rel kt_on], 0
    je   .mk_ret
    test rdi, rdi
    jz   .mk_ret
    push rax
    movzx eax, word [rdi + AST.line]
    test eax, eax
    jz   .mk_none
    mov  [rel kt_pend], eax
.mk_none:
    pop  rax
.mk_ret:
    ret

; kt_flush(): a label for the pending line, when it is not the line labelled
; last. Preserves every register.
kt_flush:
    cmp  dword [rel kt_on], 0
    je   .mk_ret
    push rax
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    push r10
    push r11
    mov  eax, [rel kt_pend]
    test eax, eax
    jz   .mk_out
    cmp  eax, [rel kt_last]
    je   .mk_out
    mov  ecx, [rel kt_cnt]
    cmp  ecx, KT_MAX_MARKS
    jae  .mk_out
    mov  [rel kt_last], eax
    mov  ecx, eax
    call lmap_lookup                 ; rax = file, rdx = line in that file
    mov  ecx, [rel kt_cnt]
    test ecx, ecx
    jnz  .mk_havefile
    mov  [rel kt_file], rax
.mk_havefile:
    lea  rax, [rel kt_lines]
    mov  [rax + rcx*4], edx
    inc  ecx
    mov  [rel kt_cnt], ecx
    mov  rsi, s_kt_kl
    call emit_cstr
    mov  edi, [rel kt_n]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  eax, [rel kt_n]
    inc  eax
    mov  [rel kt_n], eax
.mk_out:
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rax
.mk_ret:
    ret

; kt_failcall(): the call to __fail_raise, with r8 = the address just after
; it, so the trace knows the line that failed. Preserves every register
; except rax.
kt_failcall:
    call kt_flush
    push rdi
    push rsi
    push rdx
    mov  rsi, s_kt_lea
    call emit_cstr
    mov  edi, [rel kt_x]
    call emit_uint
    mov  rsi, s_kt_call
    call emit_cstr
    mov  edi, [rel kt_x]
    call emit_uint
    mov  rsi, s_colon_nl
    call emit_cstr
    mov  eax, [rel kt_x]
    inc  eax
    mov  [rel kt_x], eax
    pop  rdx
    pop  rsi
    pop  rdi
    ret

; kt_fn_name(rdi = AST_FUNCTION): the function's label, as cg_function wrote
; it, without the colon.
kt_fn_name:
    push rdi
    push rsi
    mov  rdi, [rdi + AST.data]
    call name_is_main
    test rax, rax
    jz   .fn_tok
    mov  rsi, s_kt_main
    call emit_cstr
    jmp  .fn_out
.fn_tok:
    call emit_tok
.fn_out:
    pop  rsi
    pop  rdi
    ret

; kt_file_index(rax = file name) -> eax = its number in __kron_file_N
kt_file_index:
    push rcx
    push rdx
    xor  ecx, ecx
.fi_loop:
    cmp  ecx, [rel kt_nfiles]
    jae  .fi_new
    lea  rdx, [rel kt_files]
    mov  rdx, [rdx + rcx*8]
    cmp  rax, rdx
    je   .fi_have
    inc  ecx
    jmp  .fi_loop
.fi_new:
    cmp  ecx, KT_MAX_FILES
    jae  .fi_full
    lea  rdx, [rel kt_files]
    mov  [rdx + rcx*8], rax
    inc  ecx
    mov  [rel kt_nfiles], ecx
    dec  ecx
.fi_have:
    mov  eax, ecx
    pop  rdx
    pop  rcx
    ret
.fi_full:
    xor  eax, eax
    pop  rdx
    pop  rcx
    ret

; kt_fn_end(rdi = AST_FUNCTION): the function has been written out. Its end
; label and its record:
;   .kft: dq previous record, .kfe, .kfn, file name, count
;         dq .klN, line   (count times)
;   .kfn: db the name, 0
; A function with inline assembly gets none: its labels may sit under a
; scope of the assembly's own, where the record could not name them.
kt_fn_end:
    cmp  dword [rel kt_on], 0
    je   .fe_ret
    mov  dword [rel kt_on], 0
    cmp  dword [rel kt_cnt], 0
    je   .fe_ret
    cmp  dword [rel ra_asm], 0
    jne  .fe_ret
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r12
    mov  r12, rdi
    mov  rsi, s_kt_head
    call emit_cstr
    mov  rax, [rel kt_prev]
    test rax, rax
    jz   .fe_noprev
    mov  rdi, rax
    call kt_fn_name
    mov  rsi, s_kt_kft
    call emit_cstr
    jmp  .fe_link
.fe_noprev:
    mov  rsi, s_zero
    call emit_cstr
.fe_link:
    mov  rsi, s_kt_mid
    call emit_cstr
    mov  rax, [rel kt_file]
    call kt_file_index
    mov  edi, eax
    call emit_uint
    mov  rsi, s_comma
    call emit_cstr
    mov  edi, [rel kt_cnt]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    xor  ebx, ebx
.fe_ent:
    cmp  ebx, [rel kt_cnt]
    jae  .fe_name
    mov  rsi, s_kt_ent
    call emit_cstr
    mov  edi, [rel kt_first]
    add  edi, ebx
    call emit_uint
    mov  rsi, s_comma
    call emit_cstr
    lea  rax, [rel kt_lines]
    mov  edi, [rax + rbx*4]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    inc  ebx
    jmp  .fe_ent
.fe_name:
    mov  rsi, s_kt_name
    call emit_cstr
    mov  rdi, r12
    call kt_fn_name
    mov  rsi, s_kt_name2
    call emit_cstr
    mov  [rel kt_prev], r12
    pop  r12
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
.fe_ret:
    ret

; kt_program_begin(): before the first function, the low end of the code the
; trace can name.
kt_program_begin:
    mov  dword [rel kt_n], 0
    mov  dword [rel kt_x], 0
    mov  dword [rel kt_nfiles], 0
    mov  qword [rel kt_prev], 0
    mov  dword [rel kt_on], 0
    cmp  byte [rel cg_bare], 0
    jne  .pb_out
    push rsi
    mov  rsi, s_kt_lo
    call emit_cstr
    pop  rsi
.pb_out:
    ret

; kt_program_end(): after the last function, the high end, the head of the
; chain and the file names.
kt_program_end:
    cmp  byte [rel cg_bare], 0
    jne  .pe_ret
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    mov  rsi, s_kt_hi
    call emit_cstr
    mov  rax, [rel kt_prev]
    test rax, rax
    jz   .pe_none
    mov  rdi, rax
    call kt_fn_name
    mov  rsi, s_kt_kft
    call emit_cstr
    jmp  .pe_files
.pe_none:
    mov  rsi, s_zero
    call emit_cstr
.pe_files:
    mov  rsi, s_nl
    call emit_cstr
    xor  ebx, ebx
.pe_file:
    cmp  ebx, [rel kt_nfiles]
    jae  .pe_done
    mov  rsi, s_kt_file
    call emit_cstr
    mov  edi, ebx
    call emit_uint
    mov  rsi, s_kt_db
    call emit_cstr
    lea  rax, [rel kt_files]
    mov  rcx, [rax + rbx*8]
.pe_byte:
    movzx edi, byte [rcx]
    test edi, edi
    jz   .pe_zero
    push rcx
    call emit_uint
    mov  rsi, s_comma
    call emit_cstr
    pop  rcx
    inc  rcx
    jmp  .pe_byte
.pe_zero:
    mov  rsi, s_str_zero
    call emit_cstr
    inc  ebx
    jmp  .pe_file
.pe_done:
    mov  rsi, s_kt_text
    call emit_cstr
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
.pe_ret:
    ret

; cg_count_vars(rdi=node) -> rax = number of AST_VAR_DECL in the subtree
; ==============================================================================
; STRUCT REGISTRY
; ==============================================================================

; cg_register_struct(rdi = AST_STRUCT_DEF node)
; ==============================================================================
; cg_register_struct_name(rdi = AST_STRUCT_DEF) -- first sub-pass
;
; Only the name, so that every struct exists before any field width is
; computed. Otherwise 'struct Box { min: Vec3; }' declared above Vec3 gave
; the field a width of eight bytes without a word: registering all structs
; before emitting code is not enough, they also have to be named before any
; of them is measured.
; ==============================================================================
; ==============================================================================
; cg_register_enum(rdi = AST_ENUM_DEF)
; ==============================================================================
cg_register_enum:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    mov  eax, [rel enum_count]
    cmp  eax, CG_MAX_STRUCTS
    jae  .re_done
    mov  ebx, eax
    lea  rcx, [rel enum_toks]
    mov  rdx, [r12 + AST.data]
    mov  [rcx + rbx*8], rdx
    mov  ecx, [rel emem_count]
    lea  rdx, [rel enum_first]
    mov  [rdx + rbx*4], ecx
    mov  r13, [r12 + AST.right]
    xor  r8d, r8d
.re_loop:
    test r13, r13
    jz   .re_end
    mov  ecx, [rel emem_count]
    cmp  ecx, CG_MAX_FIELDS
    jae  .re_end
    lea  rdx, [rel emem_toks]
    mov  rax, [r13 + AST.data]
    mov  [rdx + rcx*8], rax
    lea  rdx, [rel emem_vals]
    mov  rax, [r13 + AST.type_info]
    mov  [rdx + rcx*8], rax
    inc  ecx
    mov  [rel emem_count], ecx
    inc  r8d
    mov  r13, [r13 + AST.right]
    jmp  .re_loop
.re_end:
    lea  rdx, [rel enum_nmem]
    mov  [rdx + rbx*4], r8d
    mov  eax, ebx
    inc  eax
    mov  [rel enum_count], eax
.re_done:
    pop  r13
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_enum_value(rdi = enum name token, rsi = member token)
;   -> eax = 1 when found, rdx = the value
; ==============================================================================
cg_enum_value:
    push rbx
    push r12
    push r13
    push r14
    mov  r12, rdi
    mov  r13, rsi
    xor  ebx, ebx
.ev_find:
    mov  eax, [rel enum_count]
    cmp  ebx, eax
    jae  .ev_no
    lea  rcx, [rel enum_toks]
    mov  rsi, [rcx + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .ev_have
    inc  ebx
    jmp  .ev_find
.ev_have:
    lea  rcx, [rel enum_first]
    mov  r14d, [rcx + rbx*4]
    lea  rcx, [rel enum_nmem]
    mov  ecx, [rcx + rbx*4]
    xor  ebx, ebx
.ev_mem:
    cmp  ebx, ecx
    jae  .ev_no
    push rcx
    mov  eax, r14d
    add  eax, ebx
    push rax
    lea  rcx, [rel emem_toks]
    mov  rsi, [rcx + rax*8]
    mov  rdi, r13
    call tok_equal
    pop  rcx                         ; absolute member index
    test eax, eax
    jnz  .ev_found
    pop  rcx
    inc  ebx
    jmp  .ev_mem
.ev_found:
    lea  rdx, [rel emem_vals]
    mov  rdx, [rdx + rcx*8]
    pop  rcx
    mov  eax, 1
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret
.ev_no:
    xor  eax, eax
    xor  edx, edx
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

cg_register_struct_name:
    push rbx
    mov  eax, [rel struct_count]
    cmp  eax, CG_MAX_STRUCTS
    jae  .rsn_done
    lea  rcx, [rel struct_toks]
    mov  rdx, [rdi + AST.data]
    mov  [rcx + rax*8], rdx
    inc  eax
    mov  [rel struct_count], eax
.rsn_done:
    pop  rbx
    ret

cg_register_struct:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    ; the name is already in the table: find our own id
    mov  rdi, [r12 + AST.data]
    call cg_find_struct
    cmp  eax, -1
    je   .done
    mov  ebx, eax                    ; struct id
    ; first field index
    mov  ecx, [rel field_count]
    lea  rdx, [rel struct_first]
    mov  [rdx + rbx*4], ecx
    ; walk the field list
    mov  r13, [r12 + AST.right]
    xor  r8d, r8d                    ; field counter
    xor  r9d, r9d                    ; running byte offset (packed layout)
.floop:
    test r13, r13
    jz   .fdone
    mov  ecx, [rel field_count]
    cmp  ecx, CG_MAX_FIELDS
    jae  .fdone
    lea  rdx, [rel field_toks]
    mov  rax, [r13 + AST.data]
    mov  [rdx + rcx*8], rax
    ; width from the declared type
    push rcx
    push r8
    push r9
    mov  eax, [r13 + AST.type_info]
    ; float field? (KW_F32/KW_F64)
    xor  r10d, r10d
    cmp  eax, KW_F32
    je   .is_ffield
    cmp  eax, KW_F64
    jne  .not_ffield
.is_ffield:
    mov  r10d, 1
.not_ffield:
    ; A field whose type names another struct takes that struct's whole size.
    ; cg_type_size answers 8 for an identifier, so a Vec3 inside another
    ; struct used to occupy eight bytes instead of twenty-four, silently.
    mov  dword [rel pending_fstruct], -1
    cmp  eax, TOK_IDENT
    jne  .plain_width
    mov  rdi, [r13 + AST.left]       ; the type token
    test rdi, rdi
    jz   .plain_width
    push rax
    call cg_find_struct
    cmp  eax, -1
    je   .plain_width_pop
    mov  [rel pending_fstruct], eax
    push rax
    call cg_struct_size              ; slots
    shl  eax, 3                      ; bytes
    mov  r11d, eax
    pop  rax
    pop  rcx                         ; discard the saved type
    mov  eax, r11d
    jmp  .got_width
.plain_width_pop:
    pop  rax
.plain_width:
    call cg_type_size                ; eax = bytes
.got_width:
    pop  r9
    pop  r8
    pop  rcx
    lea  rdx, [rel field_isfloat]
    mov  [rdx + rcx*4], r10d
    ; the sign travels with the field, so that a u64 member compares and
    ; divides unsigned like a u64 local does
    push rax
    mov  eax, [r13 + AST.type_info]
    xor  r11d, r11d
    cmp  eax, KW_U8
    je   .fld_uns
    cmp  eax, KW_U16
    je   .fld_uns
    cmp  eax, KW_U32
    je   .fld_uns
    cmp  eax, KW_U64
    jne  .fld_next
.fld_uns:
    mov  r11d, 1
.fld_next:
    lea  rdx, [rel field_unsigned]
    mov  [rdx + rcx*4], r11d
    movzx r11d, word [r13 + AST.col]
    shr  r11d, 8
    lea  rdx, [rel field_vtag]
    mov  [rdx + rcx*4], r11d
    pop  rax
    lea  rdx, [rel field_sizes]
    mov  [rdx + rcx*4], eax
    lea  rdx, [rel field_offs]
    mov  [rdx + rcx*4], r9d          ; packed: offset = running total
    push rax
    mov  eax, [rel pending_fstruct]
    lea  rdx, [rel field_struct]
    mov  [rdx + rcx*4], eax
    pop  rax
    add  r9d, eax
    inc  ecx
    mov  [rel field_count], ecx
    inc  r8d
    mov  r13, [r13 + AST.right]
    jmp  .floop
.fdone:
    lea  rdx, [rel struct_nfield]
    mov  [rdx + rbx*4], r8d
    lea  rdx, [rel struct_bytes]
    mov  [rdx + rbx*4], r9d          ; total packed size
    ; struct_count is owned by the naming sub-pass now; bumping it here would
    ; count every struct twice.
.done:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_find_struct(rdi = name token) -> eax = struct id, or -1
cg_find_struct:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    xor  ebx, ebx
    mov  r13d, [rel struct_count]
.l:
    cmp  ebx, r13d
    jae  .nf
    lea  rax, [rel struct_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .found
    inc  ebx
    jmp  .l
.found:
    mov  eax, ebx
    jmp  .out
.nf:
    mov  eax, -1
.out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_ptr_scale(r12 = AST_BINOP node)
; Pointer arithmetic: when the left operand is a variable declared as ptr<T>
; and the operator is + or -, the right operand counts ELEMENTS, so it must be
; multiplied by sizeof(T) before being added. Emits nothing for plain integers.
; ==============================================================================
; ==============================================================================
; cg_cond_jz(rdi = condition, rsi = label) -- jump to the label when the
; condition is false.
;
; A comparison of two integers compiles to cmp and ONE conditional jump, the
; inverse of the test. Going through the value -- cmp, setl, movzx, test, jz --
; built a 0 or 1 only to test it straight away: five instructions for what is
; two. Anything else, floats included, keeps the general path.
; ==============================================================================
cg_cond_jz:
    ; Nothing is held in a register across cg_emit: that routine keeps only
    ; r12, and a condition as complex as a struct field or a call can reach
    ; code that changes the rest. The label lives on the stack, as the old
    ; .if_stmt kept its own, and the jump's condition is worked out only after
    ; the operands have been emitted.
    push r12
    push rsi                         ; [rsp] = label
    mov  r12, rdi
    test r12, r12
    jz   .cj_gen
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_BINOP
    jne  .cj_gen
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_LT
    je   .cj_op
    cmp  rax, TOK_GT
    je   .cj_op
    cmp  rax, TOK_LTE
    je   .cj_op
    cmp  rax, TOK_GTE
    je   .cj_op
    cmp  rax, TOK_EQ
    je   .cj_op
    cmp  rax, TOK_NEQ
    je   .cj_op
    jmp  .cj_gen
.cj_op:
    mov  rdi, r12
    call cg_is_textcmp
    test eax, eax
    jnz  .cj_gen
    mov  rdi, [r12 + AST.left]
    call cg_expr_is_float
    test eax, eax
    jnz  .cj_gen
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .cj_gen
    ; operands: left in rax, right in rcx -- the same code .int_binop emits
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rdi, [r12 + AST.right]
    call cg_leaf_to_rcx
    test eax, eax
    jnz  .cj_cmp
    mov  rsi, s_pushrax
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_movrcxrax
    call emit_cstr
    mov  rsi, s_poprax
    call emit_cstr
.cj_cmp:
    mov  edi, ALU_CMP
    mov  eax, IR_ALU
    call ir_ctl
    ; the jump taken when the test FAILS, signed or unsigned
    mov  rdi, r12
    call cg_binop_is_unsigned
    mov  rcx, [r12 + AST.data]
    test eax, eax
    jnz  .cj_uns
    mov  edx, CC_GE
    cmp  rcx, TOK_LT
    je   .cj_jump
    mov  edx, CC_LE
    cmp  rcx, TOK_GT
    je   .cj_jump
    mov  edx, CC_G
    cmp  rcx, TOK_LTE
    je   .cj_jump
    mov  edx, CC_L
    cmp  rcx, TOK_GTE
    je   .cj_jump
    jmp  .cj_eq
.cj_uns:
    mov  edx, CC_AE
    cmp  rcx, TOK_LT
    je   .cj_jump
    mov  edx, CC_BE
    cmp  rcx, TOK_GT
    je   .cj_jump
    mov  edx, CC_A
    cmp  rcx, TOK_LTE
    je   .cj_jump
    mov  edx, CC_B
    cmp  rcx, TOK_GTE
    je   .cj_jump
.cj_eq:
    mov  edx, CC_NE
    cmp  rcx, TOK_EQ
    je   .cj_jump
    mov  edx, CC_E                   ; TOK_NEQ
.cj_jump:
    mov  rdi, [rsp]                  ; the label
    call ir_jcc
    jmp  .cj_out
.cj_gen:
    mov  rdi, r12
    call cg_emit
    mov  rdi, [rsp]
    mov  eax, IR_JZ
    call ir_ctl
.cj_out:
    pop  rsi
    pop  r12
    ret

; ==============================================================================
; cg_arg_is_leaf(rdi = argument expression) -> eax = 1 when the argument can
; skip the stack: an integer constant, or a local variable that is neither a
; struct nor an array (those are passed by address) nor a float (xmm).
; ==============================================================================
cg_arg_is_leaf:
    push r13
    mov  r13, rdi
    test r13, r13
    jz   .al_no
    mov  rdi, r13
    call cg_arg_struct_id
    cmp  eax, -1
    jne  .al_no
    mov  rdi, r13
    call cg_expr_is_float
    test eax, eax
    jnz  .al_no
    mov  rax, [r13 + AST.node_type]
    cmp  rax, AST_INTEGER_LIT
    je   .al_yes
    cmp  rax, AST_IDENTIFIER
    jne  .al_no
    mov  rdi, [r13 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .al_no
.al_yes:
    mov  eax, 1
    jmp  .al_out
.al_no:
    xor  eax, eax
.al_out:
    pop  r13
    ret

; cg_arg_leaf_here(rdi = argument list node, esi = its index) -> eax = 1 when
; this argument AND every register argument after it are leaves.
;
; Loading a leaf late -- after the pops -- moves its read past whatever the
; later arguments do. In f(x, g(&x)) the call to g changes x; read late, x
; would carry the new value where the source says the old one. If everything
; after it is a leaf too, nothing runs in between and the order is unchanged.
; Earlier arguments do not matter: they were evaluated before it either way,
; and the stack arguments past the sixth are evaluated before all of them.
cg_arg_leaf_here:
    push r13
    push r14
    mov  r13, rdi
    mov  r14d, esi
.lh_loop:
    test r13, r13
    jz   .lh_yes
    cmp  r14d, 6
    jae  .lh_yes
    mov  rdi, [r13 + AST.left]
    call cg_arg_is_leaf
    test eax, eax
    jz   .lh_no
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .lh_loop
.lh_yes:
    mov  eax, 1
    jmp  .lh_out
.lh_no:
    xor  eax, eax
.lh_out:
    pop  r14
    pop  r13
    ret

; cg_emit_leaf_arg(rdi = argument expression, edx = argument register 0..5)
; mov <argument register>, <constant | local>, as a structured record.
cg_emit_leaf_arg:
    push r13
    push rdx
    mov  r13, rdi
    mov  rax, [r13 + AST.node_type]
    cmp  rax, AST_INTEGER_LIT
    jne  .ea_var
    mov  rdi, [r13 + AST.data]       ; the token, or 0 for zero
    mov  eax, IR_IMMARG
    mov  edx, [rsp]
    call ir_withlen
    jmp  .ea_out
.ea_var:
    mov  rdi, [r13 + AST.data]
    call cg_find_var                 ; eax = frame offset
    mov  edi, eax
    mov  eax, IR_LDARG
    mov  edx, [rsp]
    call ir_withlen
.ea_out:
    pop  rdx
    pop  r13
    ret

; ==============================================================================
; cg_fleaf_to_xmm1(rdi = right operand) -> eax = 1 when it loaded a float local
; straight into xmm1, 0 when the general path must be used.
;
; Only a local double qualifies -- the same test cg_emit_float's .ident makes
; before loading one. Globals, constants, calls and conversions from an
; integer keep the general path.
; ==============================================================================
; cg_fleaf_is(rdi = expression) -> eax = 1 when it is a float local: what
; cg_fleaf_to_xmm1 would take, without emitting anything
cg_fleaf_is:
    push r13
    mov  r13, rdi
    test r13, r13
    jz   .fi_no
    mov  rax, [r13 + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .fi_no
    mov  rdi, [r13 + AST.data]
    call cg_expr_is_float_ident
    test eax, eax
    jz   .fi_no
    mov  rdi, [r13 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .fi_no
    mov  eax, 1
    pop  r13
    ret
.fi_no:
    xor  eax, eax
    pop  r13
    ret

cg_fleaf_to_xmm1:
    push r13
    mov  r13, rdi
    test r13, r13
    jz   .fx_no
    mov  rax, [r13 + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .fx_no
    mov  rdi, [r13 + AST.data]
    call cg_expr_is_float_ident
    test eax, eax
    jz   .fx_no
    mov  rdi, [r13 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .fx_no
    mov  rdi, [r13 + AST.data]
    call cg_find_var
    mov  edi, eax
    call ir_fldx1
    mov  eax, 1
    jmp  .fx_out
.fx_no:
    xor  eax, eax
.fx_out:
    pop  r13
    ret

; ==============================================================================
; cg_leaf_to_rcx(rdi = right operand, r12 = the binary node) -> eax = 1 when it
; emitted the operand straight into rcx, 0 when the general path must be used.
;
; Only two shapes qualify, and both are read with no side effect:
;   an integer constant     mov rcx, <token>
;   a local variable        mov rcx, [rbp-N]   (or its register, once allocated)
; Globals, calls, members and anything else keep the general path. So does any
; operation the pointer scaling would touch, since that multiplies the right
; operand where it sits.
; ==============================================================================
cg_leaf_to_rcx:
    push rbx
    push r13
    mov  r13, rdi
    test r13, r13
    jz   .lr_no
    call cg_ptr_would_scale
    test eax, eax
    jnz  .lr_no
    mov  rax, [r13 + AST.node_type]
    cmp  rax, AST_INTEGER_LIT
    je   .lr_lit
    cmp  rax, AST_IDENTIFIER
    jne  .lr_no
    mov  rdi, [r13 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .lr_no
    mov  rdi, [r13 + AST.data]
    call cg_find_var
    mov  edi, eax
    call ir_ldrcx
    mov  eax, 1
    jmp  .lr_out
.lr_lit:
    mov  rdi, [r13 + AST.data]       ; the token, or 0 for a literal zero
    mov  eax, IR_IMMRCX
    call ir_ctl
    mov  eax, 1
    jmp  .lr_out
.lr_no:
    xor  eax, eax
.lr_out:
    pop  r13
    pop  rbx
    ret

; cg_ptr_would_scale(r12 = binary node) -> eax = 1 when cg_ptr_scale would
; multiply the right operand. The same test, with nothing emitted.
; cg_ptr_would_scale(r12 = binary node) -> eax = 1 when cg_ptr_scale would
; multiply the right operand. The same test, with nothing emitted.
;
; Each exit sets its own answer. The result used to live in edx from the start,
; but cg_find_var_idx changes rdx, so on the path through it the routine
; returned whatever was left there -- nonzero -- and every '+' and '-' with a
; local on the left looked like pointer arithmetic. That turned the shortcut
; off for exactly the additions it was written for.
cg_ptr_would_scale:
    push rbx
    push rcx
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_PLUS
    je   .ws_op
    cmp  rax, TOK_MINUS
    jne  .ws_no
.ws_op:
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .ws_no
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .ws_no
    mov  rdi, [rdi + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .ws_no
    lea  rcx, [rel var_elemsz]
    mov  ebx, [rcx + rax*4]
    cmp  ebx, 1
    jbe  .ws_no
    mov  eax, 1
    jmp  .ws_out
.ws_no:
    xor  eax, eax
.ws_out:
    pop  rcx
    pop  rbx
    ret

cg_ptr_scale:
    push rbx
    ; only + and - scale
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_PLUS
    je   .op_ok
    cmp  rax, TOK_MINUS
    je   .op_ok
    jmp  .done
.op_ok:
    ; the left operand must be a plain identifier
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .done
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .done
    mov  rdi, [rdi + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .done
    lea  rcx, [rel var_elemsz]
    mov  ebx, [rcx + rax*4]
    cmp  ebx, 1
    jbe  .done                   ; width 0 or 1 needs no scaling
    ; rax currently holds the element count: multiply it
    mov  rsi, s_imul_pre
    call emit_cstr
    mov  edi, ebx
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
.done:
    pop  rbx
    ret

; ==============================================================================
; ==============================================================================
; ==============================================================================
; FILE-SCOPE GLOBALS
; A declaration outside any function becomes a labelled cell in .data, reachable
; from every function and persistent across calls.
;   __g_<name>: dq <literal or 0>
; ==============================================================================

; cg_global_decl(rdi = AST_VAR_DECL node at file scope)
; ==============================================================================
; cg_global_note(rdi = AST_VAR_DECL / AST_CONST_DECL at file scope)
; Records a global's name, sign, float flag, element count and width, and its
; struct type. Run for every global in the pre-pass, before any function is
; emitted: a function may use a global declared further down the file, and
; its accesses depend on all of these (a [u8; N] declared below used to be
; read eight bytes an element).
; ==============================================================================
cg_global_note:
    push rbx
    push r12
    mov  r12, rdi
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    jne  .gn_out                      ; already recorded
    mov  eax, [rel g_count]
    cmp  eax, CG_MAX_GLOBALS
    jae  .gn_out
    mov  ebx, eax
    lea  rcx, [rel g_toks]
    mov  rdx, [r12 + AST.data]
    mov  [rcx + rbx*8], rdx
    movzx edx, word [r12 + AST.col]
    mov  r11d, edx
    shr  r11d, 1
    and  r11d, 1
    lea  rcx, [rel g_unsigned]
    mov  [rcx + rbx*4], r11d
    and  edx, 1
    lea  rcx, [rel g_isfloat]
    mov  [rcx + rbx*4], edx
    mov  rdx, [r12 + AST.type_info]
    lea  rcx, [rel g_arrlen]
    mov  [rcx + rbx*4], edx
    movzx edx, word [r12 + AST.col]
    shr  edx, 4
    and  edx, 15
    lea  rcx, [rel g_aw]
    mov  [rcx + rbx*4], edx
    movzx edx, word [r12 + AST.col]
    shr  edx, 8
    lea  rcx, [rel g_vtag]
    mov  [rcx + rbx*4], edx
    lea  rcx, [rel g_structs]
    mov  edx, -1
    mov  [rcx + rbx*4], edx           ; through a register: kasm has no
                                      ; immediate store with an index
    inc  eax
    mov  [rel g_count], eax
    ; a struct-typed global (not an array of them): its fields are reached
    ; through the struct tables
    cmp  qword [r12 + AST.type_info], 0
    jne  .gn_out
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .gn_out
    cmp  qword [rdi + TOKEN.type], KW_STR
    jne  .gn_byname
    mov  eax, [rel stream_struct_id]
    jmp  .gn_sid
.gn_byname:
    call cg_find_struct
    cmp  eax, -1
    je   .gn_out
.gn_sid:
    lea  rcx, [rel g_structs]
    mov  [rcx + rbx*4], eax
.gn_out:
    pop  r12
    pop  rbx
    ret

cg_global_decl:
    push rbx
    push r12
    mov  r12, rdi
    call cg_global_note               ; normally done in the pre-pass already
.g_emit:
    ; Work out the extent first: arrays and structs are all-zero, so they
    ; belong in .bss (no bytes in the file) rather than .data.
    mov  rax, [r12 + AST.type_info]   ; array length
    test rax, rax
    jnz  .g_array
    mov  rdi, [r12 + AST.left]        ; struct type token
    test rdi, rdi
    jz   .scalar_head
    cmp  qword [rdi + TOKEN.type], KW_STR
    jne  .g_bystruct
    mov  eax, [rel stream_struct_id]  ; 'stream': the built-in pair
    jmp  .g_gotstruct
.g_bystruct:
    call cg_find_struct
    cmp  eax, -1
    je   .scalar_head
.g_gotstruct:
    call cg_struct_size               ; slots
    test eax, eax
    jz   .scalar_head
.g_array:
    ; packed elements: [u8; 4096] reserves 512 qwords, not 4096
    movzx ecx, word [r12 + AST.col]
    shr  ecx, 4
    and  ecx, 15
    test ecx, ecx
    jz   .aggregate
    cmp  ecx, 4
    ja   .aggregate
    imul rax, rcx
    add  rax, 7
    shr  rax, 3
.aggregate:
    push rax
    mov  rsi, s_sec_bss
    call emit_cstr
    mov  rsi, s_glb_pre
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_glb_resq
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_sec_text
    call emit_cstr
    jmp  .done
.scalar_head:
    mov  rsi, s_sec_data
    call emit_cstr
    mov  rsi, s_glb_pre
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
.scalar:
    mov  rsi, s_flt_dq                ; ": dq "
    call emit_cstr
    ; a literal initialiser is emitted verbatim; anything else starts at zero
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .zero
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_INTEGER_LIT
    je   .lit
    cmp  rax, AST_FLOAT_LIT
    je   .lit
    cmp  rax, AST_BOOL_LIT
    je   .lit
    jmp  .zero
.lit:
    mov  rdi, [rdi + AST.data]
    call cg_emit_ftok
    jmp  .nl
.zero:
    mov  rsi, s_zero
    call emit_cstr
.nl:
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_sec_text
    call emit_cstr
.done:
    pop  r12
    pop  rbx
    ret

; cg_find_global(rdi = name token) -> eax = global index, or -1
cg_find_global:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    xor  ebx, ebx
    mov  r13d, [rel g_count]
.l:
    cmp  ebx, r13d
    jae  .nf
    lea  rax, [rel g_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .found
    inc  ebx
    jmp  .l
.found:
    mov  eax, ebx
    jmp  .out
.nf:
    mov  eax, -1
.out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_find_func(rdi = name token) -> eax = function index, or -1
; Names live in fn_toks, filled by the pre-pass in jup_codegen_run, so a
; function can be taken by address before its definition appears in the file.
cg_find_func:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    xor  ebx, ebx
    mov  r13d, [rel fn_count]
.l:
    cmp  ebx, r13d
    jae  .nf
    lea  rax, [rel fn_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .found
    inc  ebx
    jmp  .l
.found:
    mov  eax, ebx
    jmp  .out
.nf:
    mov  eax, -1
.out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_global_is_float(rdi = name token) -> eax = 1 when that global is a double
cg_global_is_float:
    call cg_find_global
    cmp  eax, -1
    je   .no
    lea  rcx, [rel g_isfloat]
    mov  eax, [rcx + rax*4]
    ret
.no:
    xor  eax, eax
    ret

; ==============================================================================
; cg_expr_is_float(rdi = expression node) -> eax = 1 when the value is a double
; Decided statically before emitting, so the whole subtree uses one register set.
; ==============================================================================
; ==============================================================================
; cg_expr_is_unsigned(rdi = expression) -> eax = 1 when the value is unsigned
;
; The twin of cg_expr_is_float, for the sign. Without it every comparison
; emitted setl/setg, every division idiv and every '>>' sar, so u8..u64 were
; i64 under another name and any value above 2^63 came out wrong.
;
; Covers locals, globals, array elements, struct fields (through the same
; chain walk the offset uses) and function returns.
; ==============================================================================
cg_expr_is_unsigned:
    push rbx
    push r12
    test rdi, rdi
    jz   .u_no
    mov  r12, rdi
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_CAST
    je   .u_cast
    cmp  rax, AST_MEMBER
    je   .u_member
    cmp  rax, AST_CALL
    je   .u_call
    cmp  rax, AST_IDENTIFIER
    je   .u_ident
    cmp  rax, AST_INDEX
    je   .u_index
    cmp  rax, AST_BINOP
    je   .u_binop
    cmp  rax, AST_UNOP
    je   .u_unop
    jmp  .u_no
.u_member:
    ; the same walk the offset uses; it leaves the sign in mem_unsigned
    push r12
    mov  rdi, r12
    call cg_member_resolve
    pop  r12
    mov  eax, [rel mem_unsigned]
    test eax, eax
    jnz  .u_yes
    jmp  .u_no
.u_call:
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .u_no
    call cg_find_func
    cmp  eax, -1
    je   .u_no
    lea  rcx, [rel fn_ret_unsig]
    mov  eax, [rcx + rax*4]
    test eax, eax
    jnz  .u_yes
    jmp  .u_no
.u_cast:
    movzx eax, word [r12 + AST.col]
    shr  eax, 1
    and  eax, 1
    test eax, eax
    jnz  .u_yes
    jmp  .u_no
.u_index:
    ; an element carries the sign of the array it belongs to
    mov  r12, [r12 + AST.left]
    test r12, r12
    jz   .u_no
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .u_no
.u_ident:
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .u_glb
    lea  rcx, [rel var_unsigned]
    mov  eax, [rcx + rax*4]
    test eax, eax
    jz   .u_no
    jmp  .u_yes
.u_glb:
    mov  rdi, [r12 + AST.data]
    call cg_global_is_unsigned
    test eax, eax
    jnz  .u_yes
    jmp  .u_no
.u_binop:
    ; unsigned is contagious: mixing u64 with a literal keeps it unsigned
    mov  rdi, [r12 + AST.left]
    call cg_expr_is_unsigned
    test eax, eax
    jnz  .u_yes
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_unsigned
    test eax, eax
    jnz  .u_yes
    jmp  .u_no
.u_unop:
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_unsigned
    test eax, eax
    jnz  .u_yes
    jmp  .u_no
.u_yes:
    mov  eax, 1
    pop  r12
    pop  rbx
    ret
.u_no:
    xor  eax, eax
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_global_is_unsigned(rdi = name token) -> eax = 1 when that global is u8..u64
; ==============================================================================
cg_global_is_unsigned:
    call cg_find_global
    cmp  eax, -1
    je   .g_no
    lea  rcx, [rel g_unsigned]
    mov  eax, [rcx + rax*4]
    ret
.g_no:
    xor  eax, eax
    ret

cg_expr_is_float:
    push rbx
    push r12
    test rdi, rdi
    jz   .no
    mov  r12, rdi
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_CAST
    je   .castf
    cmp  rax, AST_FLOAT_LIT
    je   .yes
    cmp  rax, AST_MEMBER
    je   .member
    cmp  rax, AST_INDEX
    je   .indexf
    cmp  rax, AST_CALL
    je   .callf
    cmp  rax, AST_IDENTIFIER
    je   .ident
    cmp  rax, AST_BINOP
    je   .binop
    cmp  rax, AST_UNOP
    je   .unop
    jmp  .no
.ident:
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .glb
    lea  rcx, [rel var_isfloat]
    mov  eax, [rcx + rax*4]
    test eax, eax
    jz   .no
    jmp  .yes
.castf:
    ; a cast reports its TARGET type, which is the whole point of writing one
    movzx eax, word [r12 + AST.col]
    and  eax, 1
    test eax, eax
    jnz  .yes
    jmp  .no
.glb:
    mov  rdi, [r12 + AST.data]
    call cg_global_is_float
    test eax, eax
    jnz  .yes
    jmp  .no
.binop:
    cmp  qword [r12 + AST.data], TOK_PLUS
    jne  .binop_num
    mov  rdi, r12
    call cg_is_concat
    test eax, eax
    jnz  .no                         ; text + 2.5 is a text
.binop_num:
    mov  rdi, [r12 + AST.left]
    call cg_expr_is_float
    test eax, eax
    jnz  .yes
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .yes
    jmp  .no
.unop:
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .yes
    jmp  .no
.member:
    call cg_member_is_float          ; r12 = AST_MEMBER node
    test eax, eax
    jnz  .yes
    jmp  .no
.indexf:
    call cg_index_is_float           ; r12 = AST_INDEX node
    test eax, eax
    jnz  .yes
    jmp  .no
.callf:
    mov  rdi, r12
    call cg_call_ret_float
    test eax, eax
    jnz  .yes
    jmp  .no
.no:
    xor  eax, eax
    pop  r12
    pop  rbx
    ret
.yes:
    mov  eax, 1
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; cg_emit_float(rdi = expression node)
; Emits the expression leaving the result in xmm0. Integer subexpressions are
; converted with cvtsi2sd, so mixed arithmetic works.
; ==============================================================================
cg_emit_float:
    push r12
    test rdi, rdi
    jz   .zero
    mov  r12, rdi
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_CAST
    je   .cast_f
    cmp  rax, AST_FLOAT_LIT
    je   .lit
    cmp  rax, AST_IDENTIFIER
    je   .ident
    cmp  rax, AST_BINOP
    je   .binop
    cmp  rax, AST_MEMBER
    je   .member_f
    cmp  rax, AST_INDEX
    je   .index_f
    cmp  rax, AST_CALL
    je   .call_f
    cmp  rax, AST_UNOP
    je   .unop_f
    jmp  .as_int
.as_int:
    ; anything else: evaluate as an integer and convert
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_cvt_i2d
    call emit_cstr
    jmp  .out
.unop_f:
    ; -x of a real is computed as a real: 0 - x. It went down the integer
    ; path, which negated the bits of the double (or, for a literal, whatever
    ; rax held) and converted them: print(-1.5) printed -1.000000.
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_TILDE
    je   .as_int
    cmp  rax, TOK_NOT
    je   .as_int
    cmp  rax, KW_INVCACHE
    je   .as_int
    cmp  rax, KW_PREFETCH0
    je   .as_int
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jz   .as_int
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rsi, s_fneg
    call emit_cstr
    jmp  .out
.call_f:
    ; only a real64 function leaves its result in xmm0; an integer one
    ; answers in rax and needs converting before it can be used here
    mov  rdi, r12
    call cg_call_ret_float
    test eax, eax
    jz   .call_f_int
    ; a call to a float-returning function already leaves its result in xmm0
    mov  rdi, r12
    call cg_emit
    jmp  .out

.call_f_int:
    mov  rdi, r12
    call cg_emit                 ; integer result lands in rax
    mov  rsi, s_cvt_i2d
    call emit_cstr
    jmp  .out

.cast_f:
    ; The target is a double. From an integer operand, convert; from a
    ; double, the value is already in the right register set.
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .cast_f_pass
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_cvt_i2d
    call emit_cstr
    jmp  .out
.cast_f_pass:
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    jmp  .out

.lit:
    ; the literal text is emitted verbatim into .data; NASM builds the double
    call new_label
    push rax                     ; id for the load
    push rax                     ; id for the definition
    mov  rsi, s_sec_data
    call emit_cstr
    mov  rsi, s_flt_lbl
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_flt_dq
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_emit_ftok
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_sec_text
    call emit_cstr
    mov  rsi, s_ld_flt
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .out

.member_f:
    call cg_member_is_float          ; is this field really float?
    test eax, eax
    jz   .member_f_int
    call cg_member_global
    test eax, eax
    jz   .member_fl
    mov  rsi, s_gldsd
    cmp  dword [rel mem_width], 4
    jne  .member_fg
    mov  rsi, s_gldss                ; f32 field: four bytes, widened
.member_fg:
    call emit_cstr
    jmp  .out
.member_fl:
    call cg_member_offset            ; eax = offset, edx = width
    push rdx
    push rax
    mov  rsi, s_ld_xmm_pre
    cmp  edx, 4
    jne  .member_fpre
    mov  rsi, s_ld_ss_pre
.member_fpre:
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_addr_post
    call emit_cstr
    pop  rdx
    cmp  edx, 4
    jne  .out
    mov  rsi, s_cvt_s2d
    call emit_cstr
    jmp  .out
.member_f_int:
    ; integer field inside a struct: load as int and convert
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_cvt_i2d
    call emit_cstr
    jmp  .out
.index_f:
    call cg_index_is_float
    test eax, eax
    jz   .index_f_int
    ; index -> rcx ; base -> rdx ; movsd xmm0, [rdx+rcx*8]
    ; The fourth and last place the subscripts are turned into an offset:
    ; read, integer write, float write, and this one.
    mov  rdi, r12
    call cg_emit_index_value
    mov  rsi, s_idx_rcx
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_emit_idx_base
    mov  rdi, [r12 + AST.data]
    call cg_arr_aw
    mov  rsi, s_rd_f
    cmp  eax, 4
    jne  .index_f_go
    mov  rsi, s_rd_f4             ; [f32; N]: four bytes, widened to double
.index_f_go:
    call emit_cstr
    jmp  .out
.index_f_int:
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_cvt_i2d
    call emit_cstr
    jmp  .out

.ident:
    mov  rdi, [r12 + AST.data]
    call cg_expr_is_float_ident
    test eax, eax
    jz   .ident_int
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .ident_gfloat
    mov  rdi, [r12 + AST.data]
    call cg_find_var
    mov  edi, eax
    call ir_fldloc                   ; movsd xmm0, [rbp-N], as a record
    jmp  .out
.ident_gfloat:
    mov  rsi, s_ldgf_pre
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_emit_gtok
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .out
.ident_int:
    mov  rdi, r12
    call cg_emit
    mov  rsi, s_cvt_i2d
    call emit_cstr
    jmp  .out

.binop:
    ; left -> xmm0. When the right side is a float local it goes straight into
    ; xmm1: loading it cannot disturb xmm0, so parking xmm0 on the stack and
    ; fetching it back -- five instructions and two memory round trips -- was
    ; only there for the general case.
    ; And when the LEFT side is the float local and the right is not: the
    ; right first, moved to xmm1, then the local into xmm0. Reading a local
    ; has no side effect, so the order cannot be seen; the trip through the
    ; stack is gone from 'v = (v - k * x) * d'.
    mov  rdi, [r12 + AST.right]
    call cg_fleaf_is
    test eax, eax
    jnz  .bin_leftfirst
    mov  rdi, [r12 + AST.left]
    call cg_fleaf_is
    test eax, eax
    jz   .bin_leftfirst
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rsi, s_xmm1_xmm0
    call emit_cstr
    mov  rdi, [r12 + AST.left]
    call cg_emit_float
    jmp  .fop
.bin_leftfirst:
    mov  rdi, [r12 + AST.left]
    call cg_emit_float
    mov  rdi, [r12 + AST.right]
    call cg_fleaf_to_xmm1
    test eax, eax
    jnz  .fop
    mov  rsi, s_push_xmm
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rsi, s_pop_xmm1
    call emit_cstr
.fop:
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_PLUS
    je   .fadd
    cmp  rax, TOK_MINUS
    je   .fsub
    cmp  rax, TOK_STAR
    je   .fmul
    cmp  rax, TOK_SLASH
    je   .fdiv
    jmp  .out
.fadd:
    mov  rsi, s_addsd
    call emit_cstr
    jmp  .out
.fsub:
    mov  rsi, s_subsd
    call emit_cstr
    jmp  .out
.fmul:
    mov  rsi, s_mulsd
    call emit_cstr
    jmp  .out
.fdiv:
    mov  rsi, s_divsd
    call emit_cstr
    jmp  .out

.zero:
    mov  rsi, s_zero_xmm
    call emit_cstr
.out:
    pop  r12
    ret

; cg_expr_is_float_ident(rdi = name token) -> eax = 1 when that variable is a double
cg_expr_is_float_ident:
    push rdi
    call cg_find_var_idx
    pop  rdi
    cmp  eax, -1
    je   .glb
    lea  rcx, [rel var_isfloat]
    mov  eax, [rcx + rax*4]
    ret
.glb:
    call cg_global_is_float
    ret

; ==============================================================================
; cg_type_size(eax = declared type token type) -> eax = width in bytes
; Packed layout: the width is exactly what the type declares, so a struct
; mirrors the byte layout the hardware expects.
cg_type_size:
    cmp  eax, KW_U8
    je   .b1
    cmp  eax, KW_I8
    je   .b1
    cmp  eax, KW_BOOL
    je   .b1
    cmp  eax, KW_U16
    je   .b2
    cmp  eax, KW_I16
    je   .b2
    cmp  eax, KW_U32
    je   .b4
    cmp  eax, KW_I32
    je   .b4
    cmp  eax, KW_F32
    je   .b4
    mov  eax, 8                      ; u64/i64/f64/str/pointers default to 8
    ret
.b1:
    mov  eax, 1
    ret
.b2:
    mov  eax, 2
    ret
.b4:
    mov  eax, 4
    ret

; cg_struct_size(eax = struct id) -> eax = slots of 8 bytes needed
cg_struct_size:
    test eax, eax
    js   .zero
    lea  rcx, [rel struct_bytes]
    mov  eax, [rcx + rax*4]          ; packed size in bytes
    add  eax, 7
    shr  eax, 3                      ; round up to whole slots
    ret
.zero:
    xor  eax, eax
    ret

; cg_field_index(edi = struct id, rsi = field name token) -> eax = index, or -1
cg_field_index:
    push rbx
    push r12
    push r13
    push r14
    mov  r14, rsi
    mov  eax, edi
    test eax, eax
    js   .nf
    lea  rcx, [rel struct_first]
    mov  r12d, [rcx + rax*4]         ; first field index
    lea  rcx, [rel struct_nfield]
    mov  r13d, [rcx + rax*4]         ; field count
    xor  ebx, ebx
.l:
    cmp  ebx, r13d
    jae  .nf
    mov  ecx, r12d
    add  ecx, ebx
    lea  rax, [rel field_toks]
    mov  rsi, [rax + rcx*8]
    mov  rdi, r14
    call tok_equal
    test eax, eax
    jnz  .found
    inc  ebx
    jmp  .l
.found:
    mov  eax, ebx
    jmp  .out
.nf:
    mov  eax, -1
.out:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_find_var_idx(rdi = token) -> eax = variable index, or -1
cg_find_var_idx:
    push rbx
    push r12
    push r13
    mov  r12, rdi
    mov  r13d, [rel var_count]
    mov  ebx, r13d
    dec  ebx                         ; search backwards (shadowing)
.l:
    test ebx, ebx
    js   .nf
    lea  rax, [rel var_toks]
    mov  rsi, [rax + rbx*8]
    mov  rdi, r12
    call tok_equal
    test eax, eax
    jnz  .found
    dec  ebx
    jmp  .l
.found:
    mov  eax, ebx
    jmp  .out
.nf:
    mov  eax, -1
.out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_member_offset(r12 = AST_MEMBER node) -> eax = offset from rbp,
;                                            edx = field width in bytes (8 if unknown)
; ==============================================================================
; cg_member_resolve(rdi = AST_MEMBER node)
;
; Walks the chain inward first, so a.b.c resolves b before c and each field
; is looked up in the struct the previous one landed in. Leaves the running
; byte offset in mem_off, the struct reached in mem_sid, and the last field's
; width and floatness in mem_width and mem_isfloat.
; ==============================================================================
cg_member_resolve:
    push rbx
    push r12
    push r13
    mov  r13, rdi
    ; inner part of the chain first
    mov  rdi, [r13 + AST.right]
    test rdi, rdi
    jz   .from_var
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_MEMBER
    jne  .from_var
    call cg_member_resolve
    jmp  .have_base
.from_var:
    mov  dword [rel mem_off], 0
    mov  dword [rel mem_sid], -1
    mov  rdi, [r13 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .from_glob
    lea  rcx, [rel var_structs]
    mov  eax, [rcx + rax*4]
    mov  [rel mem_sid], eax
    jmp  .have_base
.from_glob:
    ; a struct global: its fields were reached as offset 0 of the frame,
    ; which overwrote the saved frame pointer
    mov  rdi, [r13 + AST.data]
    call cg_find_global
    cmp  eax, -1
    je   .have_base
    lea  rcx, [rel g_structs]
    mov  eax, [rcx + rax*4]
    mov  [rel mem_sid], eax
.have_base:
    mov  dword [rel mem_width], 8
    mov  dword [rel mem_isfloat], 0
    mov  dword [rel mem_unsigned], 0
    mov  dword [rel mem_vtag], 0
    mov  edi, [rel mem_sid]
    cmp  edi, -1
    je   .done
    mov  rsi, [r13 + AST.left]       ; this field's name
    call cg_field_index
    cmp  eax, -1
    je   .nofield
    mov  edi, [rel mem_sid]
    push rax
    lea  rcx, [rel struct_first]
    mov  ecx, [rcx + rdi*4]
    pop  rax
    add  eax, ecx                    ; absolute index into the flat arrays
    lea  rcx, [rel field_offs]
    mov  edx, [rcx + rax*4]
    ; accumulate through a register: kasm reaches a rip-relative destination
    ; only with an immediate source, so 'add [rel X], edx' has no encoding.
    mov  ebx, [rel mem_off]
    add  ebx, edx
    mov  [rel mem_off], ebx
    lea  rcx, [rel field_sizes]
    mov  edx, [rcx + rax*4]
    mov  [rel mem_width], edx
    lea  rcx, [rel field_isfloat]
    mov  edx, [rcx + rax*4]
    mov  [rel mem_isfloat], edx
    lea  rcx, [rel field_unsigned]
    mov  edx, [rcx + rax*4]
    mov  [rel mem_unsigned], edx
    lea  rcx, [rel field_vtag]
    mov  edx, [rcx + rax*4]
    mov  [rel mem_vtag], edx
    lea  rcx, [rel field_struct]
    mov  edx, [rcx + rax*4]
    mov  [rel mem_sid], edx          ; a nested struct, or -1
    jmp  .done
.nofield:
    mov  dword [rel mem_sid], -1
.done:
    pop  r13
    pop  r12
    pop  rbx
    ret

; cg_member_enum(r12 = AST_MEMBER) -> eax = 1 and rdx = value when the node
; is really Enum.Member rather than an access on a variable.
cg_member_enum:
    push rbx
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    jne  .me_no                      ; a real variable: an ordinary access
    mov  rdi, [r12 + AST.data]
    mov  rsi, [r12 + AST.left]
    call cg_enum_value
    pop  rbx
    ret
.me_no:
    xor  eax, eax
    pop  rbx
    ret

; ==============================================================================
; cg_member_global(r12 = AST_MEMBER) -> eax = 1 when the base variable is a
; global: 'lea rdx, [rel __g_NAME+OFF]' has then been emitted and the field
; is at [rdx]. eax = 0 for a local, nothing emitted. mem_width, mem_isfloat
; and mem_unsigned describe the field either way.
; ==============================================================================
cg_member_global:
    push rbx
    mov  rdi, r12
    call cg_member_resolve
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    jne  .mg_no
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    je   .mg_no
    mov  rsi, s_lea_glbp              ; lea rdx, [rel __g_
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_emit_gtok
    mov  ebx, [rel mem_off]
    test ebx, ebx
    jz   .mg_close
    mov  rsi, s_plus_n
    call emit_cstr
    mov  edi, ebx
    call emit_uint
.mg_close:
    mov  rsi, s_closebrk
    call emit_cstr
    mov  eax, 1
    pop  rbx
    ret
.mg_no:
    xor  eax, eax
    pop  rbx
    ret

; cg_member_sext(): a signed field narrower than eight bytes, just loaded
; zero-extended into rax, gets its sign (i8, i16, i32 fields read -1 as -1)
cg_member_sext:
    cmp  dword [rel mem_unsigned], 0
    jne  .ms_out
    cmp  dword [rel mem_isfloat], 0
    jne  .ms_out
    mov  eax, [rel mem_width]
    mov  rsi, s_sext1
    cmp  eax, 1
    je   .ms_go
    mov  rsi, s_sext2
    cmp  eax, 2
    je   .ms_go
    mov  rsi, s_sext4
    cmp  eax, 4
    jne  .ms_out
.ms_go:
    call emit_cstr
.ms_out:
    ret

cg_member_offset:
    push rbx
    push r13
    push r14
    mov  rdi, r12
    call cg_member_resolve
    mov  rdi, [r12 + AST.data]       ; base variable token
    call cg_find_var_idx
    cmp  eax, -1
    je   .zero
    lea  rcx, [rel var_offs]
    mov  r13d, [rcx + rax*4]         ; base offset
    mov  edx, [rel mem_off]
    sub  r13d, edx                   ; effective = base - accumulated offset
    mov  r14d, [rel mem_width]
    mov  eax, r13d
    jmp  .out
.zero:
    xor  eax, eax
    mov  r14d, 8
.out:
    mov  edx, r14d
    pop  r14
    pop  r13
    pop  rbx
    ret

; cg_index_is_float(r12 = AST_INDEX node) -> eax = 1 when the base array is float
cg_index_is_float:
    push rbx
    mov  rdi, [r12 + AST.data]       ; array variable token
    call cg_find_var_idx
    cmp  eax, -1
    je   .ixf_glob                   ; not local -> maybe a global array
    lea  rcx, [rel var_isfloat]
    mov  eax, [rcx + rax*4]
    test eax, eax
    jz   .ixf_no
    mov  eax, 1
    pop  rbx
    ret
.ixf_glob:
    mov  rdi, [r12 + AST.data]
    call cg_global_is_float
    test eax, eax
    jz   .ixf_no
    mov  eax, 1
    pop  rbx
    ret
.ixf_no:
    xor  eax, eax
    pop  rbx
    ret

; cg_member_is_float(r12 = AST_MEMBER node) -> eax = 1 when the field is real32/real64
cg_member_is_float:
    ; Same walk as the offset: it used to look the field up in the BASE
    ; variable's struct, so in a.b.c it asked whether 'c' was a field of a's
    ; type rather than of b's.
    push rbx
    push r13
    mov  rdi, r12
    call cg_member_resolve
    mov  eax, [rel mem_isfloat]
    test eax, eax
    jz   .mf_no
    mov  eax, 1
    pop  r13
    pop  rbx
    ret
.mf_no:
    xor  eax, eax
    pop  r13
    pop  rbx
    ret

; ==============================================================================
; cg_count_list(rdi = list head) -> eax = number of nodes linked by AST.right
cg_count_list:
    xor  eax, eax
.l:
    test rdi, rdi
    jz   .d
    inc  eax
    mov  rdi, [rdi + AST.right]
    jmp  .l
.d:
    ret

cg_count_vars:
    push r12
    push r13
    mov  r12, rdi
    xor  r13d, r13d
    test r12, r12
    jz   .done
    mov  rax, [r12 + AST.node_type]
    cmp  rax, AST_VAR_DECL
    je   .isvar
    cmp  rax, AST_CONST_DECL
    je   .isvar
    ; these nodes hold TOKENS in fields the generic walk would follow
    cmp  rax, AST_MEMBER
    je   .done
    cmp  rax, AST_ADDR_OF
    je   .done
    cmp  rax, AST_LAMBDA             ; a function of its own, with its own frame
    je   .done
    cmp  rax, AST_INDEX
    je   .idx_recurse
    jmp  .recurse

.idx_recurse:
    mov  rdi, [r12 + AST.right]      ; index expression only
    call cg_count_vars
    add  r13d, eax
    jmp  .done
.isvar:
    mov  rax, [r12 + AST.type_info]
    test rax, rax
    jnz  .isarr
    ; struct-typed variable: reserve slots for its packed byte size
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .isscalar
    call cg_find_struct
    cmp  eax, -1
    je   .isscalar
    call cg_struct_size
    test eax, eax
    jz   .isscalar
    add  r13d, eax
    jmp  .decl_recurse
.isscalar:
    inc  r13d
    jmp  .decl_recurse
.isarr:
    add  r13d, eax               ; the array takes N slots
    jmp  .decl_recurse

; Declarations keep a TYPE TOKEN in AST.left, not an AST node:
; only the initializer in AST.right may be walked.
.decl_recurse:
    mov  rdi, [r12 + AST.right]
    call cg_count_vars
    add  r13d, eax
    jmp  .done
.recurse:
    mov  rdi, [r12 + AST.left]
    call cg_count_vars
    add  r13d, eax
    mov  rdi, [r12 + AST.right]
    call cg_count_vars
    add  r13d, eax
    ; also the condition (data) of if/while, which carry an expr; counts no vars
.done:
    mov  eax, r13d
    pop  r13
    pop  r12
    ret

; ==============================================================================
; cg_emit(rdi = node)  -- generates code (the result of an expr stays in rax)
; ==============================================================================
cg_emit:
    test rdi, rdi
    jz   .ret0
    push r12
    mov  r12, rdi
    mov  rax, [r12 + AST.node_type]

    cmp  rax, AST_BLOCK
    je   .block
    cmp  rax, AST_VAR_DECL
    je   .vardecl
    cmp  rax, AST_CONST_DECL
    je   .vardecl
    cmp  rax, AST_ASSIGN
    je   .assign
    cmp  rax, AST_RETURN
    je   .ret_stmt
    cmp  rax, AST_MULTI
    je   .multi_stmt
    cmp  rax, AST_LAMBDA
    je   .lambda_expr
    cmp  rax, AST_PRINT
    je   .print_stmt
    cmp  rax, AST_PRINTC
    je   .printc_stmt
    cmp  rax, AST_OUTB
    je   .outb_stmt
    cmp  rax, AST_POKE
    je   .poke_stmt
    cmp  rax, AST_BEEP
    je   .beep_stmt
    cmp  rax, AST_SAVEFILE
    je   .savefile_stmt
    cmp  rax, AST_POKE8
    je   .poke8_stmt
    cmp  rax, AST_POKE16
    je   .poke16_stmt
    cmp  rax, AST_POKE32
    je   .poke32_stmt
    cmp  rax, AST_ASM
    je   .asm_stmt
    cmp  rax, AST_IF
    je   .if_stmt
    cmp  rax, AST_WHILE
    je   .while_stmt
    cmp  rax, AST_VEC2_LOAD
    je   .v2load_e
    cmp  rax, AST_VEC2_STORE
    je   .v2store_e
    cmp  rax, AST_VEC2_ADD
    je   .v2add_e
    cmp  rax, AST_VEC2_SUB
    je   .v2sub_e
    cmp  rax, AST_VEC2_MUL
    je   .v2mul_e
    cmp  rax, AST_THREAD_START
    je   .thstart_e
    cmp  rax, AST_CPU_COUNT
    je   .cpucount_e
    cmp  rax, AST_THREAD_YIELD
    je   .yield_e
    cmp  rax, AST_DLL_LOAD
    je   .dllload_e
    cmp  rax, AST_DLL_PROC
    je   .dllproc_e
    cmp  rax, AST_ARG_COUNT
    je   .argcount_e
    cmp  rax, AST_ARG_GET
    je   .argget_e
    cmp  rax, AST_TARGET_OS
    je   .targetos_e
    cmp  rax, AST_TICKS
    je   .ticks_e
    cmp  rax, AST_TICKS_PER_SEC
    je   .tickrate_e
    cmp  rax, AST_THREAD_WAIT
    je   .thwait_e
    cmp  rax, AST_LOCK_INIT
    je   .lkinit_e
    cmp  rax, AST_LOCK_TAKE
    je   .lktake_e
    cmp  rax, AST_LOCK_GIVE
    je   .lkgive_e
    cmp  rax, AST_LOADFILE
    je   .loadfile_e
    cmp  rax, AST_SIZEOF
    je   .sizeof_e
    cmp  rax, AST_FAIL
    je   .fail_st
    cmp  rax, AST_FAILED
    je   .failed_e
    cmp  rax, AST_PRINTFAIL
    je   .printfail_st
    cmp  rax, AST_CAST
    je   .cast
    cmp  rax, AST_BINOP
    je   .binop
    cmp  rax, AST_UNOP
    je   .unop
    cmp  rax, AST_CALL
    je   .call
    cmp  rax, AST_CALL_INDIRECT
    je   .call_indirect
    cmp  rax, AST_SYSCALL
    je   .syscall
    cmp  rax, AST_IDENTIFIER
    je   .ident
    cmp  rax, AST_INB
    je   .inb_expr
    cmp  rax, AST_INDEX
    je   .index_expr
    cmp  rax, AST_MEMBER
    je   .member_expr
    cmp  rax, AST_ADDR_OF
    je   .addr_expr
    cmp  rax, AST_DEREF
    je   .deref_expr
    cmp  rax, AST_PEEK
    je   .peek_expr
    cmp  rax, AST_READKEY
    je   .readkey_e
    cmp  rax, AST_STRING_LIT
    je   .strlit_e
    cmp  rax, AST_READMOUSE
    je   .readmouse_e
    cmp  rax, AST_MOUSEX
    je   .mousex_e
    cmp  rax, AST_MOUSEY
    je   .mousey_e
    cmp  rax, AST_TRUNC
    je   .trunc_expr
    cmp  rax, AST_PEEK8
    je   .peek8_expr
    cmp  rax, AST_PEEK16
    je   .peek16_expr
    cmp  rax, AST_PEEK32
    je   .peek32_expr
    cmp  rax, AST_INTEGER_LIT
    je   .intlit
    cmp  rax, AST_BOOL_LIT
    je   .boollit
    cmp  rax, AST_BREAK
    je   .break_st
    cmp  rax, AST_CONTINUE
    je   .continue_st
    ; nodes codegen does not support (float/string/hardware): skip
    jmp  .skip

.block:
    ; inside raw { } a "..." is an address: + moves it, it does not join
    cmp  qword [r12 + AST.type_info], BLOCK_RAW
    jne  .block_go
    inc  dword [rel cg_in_raw]
    mov  rdi, [r12 + AST.left]
    call kt_mark
    call cg_emit
    dec  dword [rel cg_in_raw]
    mov  rdi, [r12 + AST.right]
    call cg_emit
    jmp  .out
.block_go:
    mov  rdi, [r12 + AST.left]
    call kt_mark
    call cg_emit
    mov  rdi, [r12 + AST.right]
    call cg_emit
    jmp  .out

.vardecl:
    ; register variable, evaluate init, store into slot
    mov  rdi, r12
    call cg_decl_vtag
    mov  [rel pending_vtag], eax
    mov  dword [rel pending_struct], -1
    mov  ecx, dword [r12 + AST.child_count]
    mov  [rel pending_elem], ecx      ; pointer element width, 0 when not a pointer
    movzx ecx, word [r12 + AST.col]
    mov  r11d, ecx
    shr  r11d, 1
    and  r11d, 1
    mov  [rel pending_unsigned], r11d  ; bit1 = the type was u8..u64
    and  ecx, 1
    mov  [rel pending_float], ecx     ; 1 when the declared type is floating point
    mov  rsi, [r12 + AST.type_info]   ; array length, or 0 when scalar
    test rsi, rsi
    jnz  .vd_array
    ; struct-typed?  AST.left holds the type name token
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .vd_scalar
    ; 'stream' is the built-in pair {ptr, len}. It is matched by token TYPE,
    ; not by name, so the long spelling 'utf8_stream' resolves the same.
    cmp  qword [rdi + TOKEN.type], KW_STR
    jne  .vd_bynombre
    mov  eax, [rel stream_struct_id]
    jmp  .vd_gotstruct
.vd_bynombre:
    call cg_find_struct
    cmp  eax, -1
    je   .vd_scalar
.vd_gotstruct:
    mov  [rel pending_struct], eax
    call cg_struct_size
    test eax, eax
    jz   .vd_scalar
    mov  esi, eax                ; one slot per field
    jmp  .vd_sized
.vd_scalar:
    xor  esi, esi
    jmp  .vd_sized
.vd_array:
    ; elements narrower than eight bytes are packed: [u8; 100] takes 13 slots
    movzx eax, word [r12 + AST.col]
    shr  eax, 4
    and  eax, 15
    test eax, eax
    jz   .vd_sized
    cmp  eax, 4
    ja   .vd_sized
    imul rsi, rax                ; bytes
    add  rsi, 7
    shr  rsi, 3                  ; slots of eight
.vd_sized:
    movzx eax, word [r12 + AST.col]
    shr  eax, 4
    and  eax, 15
    mov  [rel pending_aw], eax   ; bytes per element, 0 when not an array
    ; Set immediately before the call that consumes it. Set any earlier and a
    ; module-level declaration -- which never reaches cg_add_var -- would
    ; leave it armed, and the next variable declared anywhere would be taken
    ; for an array and passed by address instead of by value.
    mov  rdi, [r12 + AST.type_info]
    mov  [rel pending_arrlen], edi
    mov  rdi, [r12 + AST.owner_type]  ; row stride, 0 when the array is flat
    mov  [rel pending_stride], edi
    mov  rdi, [r12 + AST.data]
    call cg_add_var              ; rax = offset
    push rax
    ; an array literal writes itself into the slots too -- unless the
    ; variable is a list<T>, which makes a list of it
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .vd_notlit
    movzx eax, word [r12 + AST.col]
    shr  eax, 8
    and  eax, 15
    cmp  eax, 2
    je   .vd_notarrlit
    cmp  qword [rdi + AST.node_type], AST_ARRAY_LIT
    jne  .vd_notarrlit
    mov  esi, [rsp]
    movzx edx, word [r12 + AST.col]
    mov  eax, edx
    shr  eax, 4
    and  eax, 15
    mov  [rel cur_lit_aw], eax       ; bytes per element, 0 = 8
    and  edx, 1                      ; float elements?
    call cg_emit_array_lit
    pop  rax
    jmp  .out
.vd_notarrlit:
    ; a struct literal writes itself into the slots; there is no value to
    ; store afterwards
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .vd_notlit
    cmp  qword [rdi + AST.node_type], AST_STRUCT_LIT
    jne  .vd_notlit
    mov  esi, [rsp]
    call cg_emit_struct_lit
    pop  rax
    jmp  .out
.vd_notlit:
    ; array declared without initializer: only reserve space
    cmp  qword [r12 + AST.right], 0
    je   .vardecl_noinit
    ; floating point initialiser -> store from xmm0
    movzx eax, word [r12 + AST.col]
    and  eax, 1
    test eax, eax
    jnz  .vardecl_float
    mov  rdi, r12
    call cg_decl_vtag
    mov  esi, eax
    mov  rdi, [r12 + AST.right]
    call cg_emit_for             ; result in rax; "..." into a text is a text
    pop  rcx                     ; offset
    ; mov [rbp-off], rax
    push rax
    mov  edi, ecx
    call ir_stloc                    ; mov [rbp-N], rax, as a structured record
    pop  rax
    ; A 'stream' initialised from a literal is a PAIR: the address just went
    ; into the first slot, the byte count goes into the second. Without this
    ; the length stayed zero and every string was empty.
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .out
    cmp  qword [rdi + TOKEN.type], KW_STR
    jne  .out
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .out
    cmp  qword [rdi + AST.node_type], AST_STRING_LIT
    jne  .out
    push rcx
    mov  rsi, s_movmemq_pre      ; an immediate needs the size spelled out
    call emit_cstr
    pop  rcx
    sub  ecx, 8                  ; second field: base - 8
    mov  edi, ecx
    call emit_uint
    mov  rsi, s_movmem_mid
    call emit_cstr
    mov  edi, [rel last_strlit_len]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .out
.vardecl_float:
    mov  rdi, [r12 + AST.right]
    call cg_emit_float           ; result in xmm0
    pop  rcx
    mov  rdi, rcx
    call ir_fstloc                   ; movsd [rbp-N], xmm0, as a record
    jmp  .out
.vardecl_noinit:
    ; a list<T> or map<T> declared without a value starts empty
    cmp  dword [rel ir_on], 0
    je   .vd_noinit_plain
    movzx eax, word [r12 + AST.col]
    shr  eax, 8
    and  eax, 15
    cmp  eax, 2
    je   .vd_newlist
    cmp  eax, 3
    je   .vd_newmap
.vd_noinit_plain:
    pop  rcx
    jmp  .out
.vd_newlist:
    lea  rdi, [rel tk_list_new]
    jmp  .vd_newcoll
.vd_newmap:
    lea  rdi, [rel tk_map_new]
.vd_newcoll:
    call cg_lib_call
    pop  rdi                     ; offset
    call ir_stloc                ; mov [rbp-N], rax
    jmp  .out

.assign:
    ; left = identifier, index or dereference; right = expr
    ; A struct literal on the right writes straight into the destination's
    ; slots, so it is handled before the ordinary value paths.
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .assign_notlit
    cmp  qword [rdi + AST.node_type], AST_STRUCT_LIT
    jne  .assign_notlit
    mov  rdi, [r12 + AST.left]
    cmp  qword [rdi + AST.node_type], AST_IDENTIFIER
    jne  .assign_notlit
    mov  rdi, [rdi + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .assign_notlit
    lea  rcx, [rel var_offs]
    mov  esi, [rcx + rax*4]
    mov  rdi, [r12 + AST.right]
    call cg_emit_struct_lit
    jmp  .out
.assign_notlit:
    mov  rdi, [r12 + AST.left]
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_INDEX
    je   .assign_idx
    cmp  rax, AST_DEREF
    je   .assign_deref
    cmp  rax, AST_MEMBER
    je   .assign_member
    ; destination declared as floating point?
    cmp  rax, AST_IDENTIFIER
    jne  .assign_int
    mov  rdi, [rdi + AST.data]
    call cg_expr_is_float_ident
    test eax, eax
    jnz  .assign_float
.assign_int:
    mov  rdi, [r12 + AST.left]
    call cg_expr_vtag
    mov  esi, eax
    mov  rdi, [r12 + AST.right]
    call cg_emit_for             ; value in rax; "..." into a text is a text
    ; get offset of the destination identifier
    mov  rdi, [r12 + AST.left]
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_IDENTIFIER
    jne  .out
    mov  rdi, [rdi + AST.data]
    push rdi
    call cg_find_var_idx
    pop  rdi
    cmp  eax, -1
    je   .assign_glb
    call cg_find_var
    mov  ecx, eax
    mov  edi, ecx
    call ir_stloc                    ; mov [rbp-N], rax, as a structured record
    jmp  .out
.assign_glb:
    push rdi
    mov  rsi, s_stg_pre
    call emit_cstr
    pop  rdi
    call cg_emit_gtok
    mov  rsi, s_stg_suf
    call emit_cstr
    jmp  .out

; --- x = value where x is a double ---
.assign_float:
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rdi, [r12 + AST.left]
    mov  rdi, [rdi + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .assign_gfloat
    mov  rdi, [r12 + AST.left]
    mov  rdi, [rdi + AST.data]
    call cg_find_var
    mov  rdi, rax
    call ir_fstloc                   ; movsd [rbp-N], xmm0, as a record
    jmp  .out

.assign_gfloat:
    ; a file-scope real64 lives at its own label, not in the frame
    mov  rsi, s_stgf_pre
    call emit_cstr
    mov  rdi, [r12 + AST.left]
    mov  rdi, [rdi + AST.data]
    call cg_emit_gtok
    mov  rsi, s_stgf_suf
    call emit_cstr
    jmp  .out

; --- p.field = value : write a struct field ---
.assign_member:
    push r13
    mov  r13, [r12 + AST.left]    ; AST_MEMBER node
    ; float field? store from xmm0 instead
    push r12
    mov  r12, r13
    call cg_member_is_float
    pop  r12
    test eax, eax
    jnz  .assign_member_float
    mov  rdi, [r12 + AST.right]   ; value
    call cg_emit
    push r12
    mov  r12, r13
    call cg_member_global
    pop  r12
    test eax, eax
    jz   .mw_local
    mov  eax, [rel mem_width]
    mov  rsi, s_gst8
    cmp  eax, 4
    jne  .mg_w2
    mov  rsi, s_gst4
.mg_w2:
    cmp  eax, 2
    jne  .mg_w1
    mov  rsi, s_gst2
.mg_w1:
    cmp  eax, 1
    jne  .mg_wgo
    mov  rsi, s_gst1
.mg_wgo:
    call emit_cstr
    pop  r13
    jmp  .out
.mw_local:
    push r12
    mov  r12, r13
    call cg_member_offset            ; eax = offset, edx = width
    pop  r12
    push rax
    push rdx
    mov  rsi, s_movmem_pre
    call emit_cstr
    pop  rdx
    pop  rdi
    push rdx
    call emit_uint
    pop  rdx
    cmp  edx, 1
    je   .mw1
    cmp  edx, 2
    je   .mw2
    cmp  edx, 4
    je   .mw4
    mov  rsi, s_st8_suf
    jmp  .mw_go
.mw1:
    mov  rsi, s_st1_suf
    jmp  .mw_go
.mw2:
    mov  rsi, s_st2_suf
    jmp  .mw_go
.mw4:
    mov  rsi, s_st4_suf
.mw_go:
    call emit_cstr
    pop  r13
    jmp  .out
.assign_member_float:
    ; evaluate the value as float -> xmm0, then store at the field's width
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    push r12
    mov  r12, r13
    call cg_member_global
    pop  r12
    test eax, eax
    jz   .amf_local
    mov  rsi, s_gstsd
    cmp  dword [rel mem_width], 4
    jne  .amf_ggo
    mov  rsi, s_gstss                ; f32 field: narrowed to four bytes
.amf_ggo:
    call emit_cstr
    pop  r13
    jmp  .out
.amf_local:
    push r12
    mov  r12, r13
    call cg_member_offset            ; eax = offset, edx = width
    pop  r12
    push rax
    mov  rsi, s_st_xmm_pre
    cmp  edx, 4
    jne  .amf_pre
    push rdx
    mov  rsi, s_cvt_d2s
    call emit_cstr
    pop  rdx
    mov  rsi, s_st_ss_pre
.amf_pre:
    call emit_cstr
    pop  rdi                         ; offset
    call emit_uint
    mov  rsi, s_st_xmm_suf
    call emit_cstr
    pop  r13
    jmp  .out

; --- *p = value : write through a pointer ---
.assign_deref:
    push r13
    mov  r13, [r12 + AST.left]    ; AST_DEREF node
    mov  rdi, [r13 + AST.right]   ; pointer expression
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]   ; value
    call cg_emit
    mov  rsi, s_poke_seq
    call emit_cstr
    pop  r13
    jmp  .out

; --- buf[i] = value : indexed write ---
.assign_idx:
    push r13
    mov  r13, [r12 + AST.left]    ; AST_INDEX node
    ; float array? store from xmm0 instead
    push r12
    mov  r12, r13
    call cg_index_is_float
    pop  r12
    test eax, eax
    jnz  .assign_idx_float
    mov  rdi, r13                 ; index (both subscripts when 2-D)
    call cg_emit_index_value
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]   ; value
    call cg_emit
    mov  rsi, s_idx_pop
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call cg_emit_idx_base
    mov  rdi, [r13 + AST.data]
    call cg_emit_elem_write       ; at the element's own width
    pop  r13
    jmp  .out
.assign_idx_float:
    ; index -> rax -> push
    mov  rdi, r13
    call cg_emit_index_value
    mov  rsi, s_push_rax
    call emit_cstr
    ; value -> xmm0
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    ; pop rcx ; base -> rdx ; movsd [rdx+rcx*8], xmm0
    mov  rsi, s_idx_pop
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call cg_emit_idx_base
    mov  rdi, [r13 + AST.data]
    call cg_arr_aw
    mov  rsi, s_wr_f
    cmp  eax, 4
    jne  .aif_go
    mov  rsi, s_wr_f4             ; [f32; N]: narrowed to four bytes
.aif_go:
    call emit_cstr
    pop  r13
    jmp  .out

.ret_stmt:
    cmp  qword [r12 + AST.left], 0
    je   .ret_single
    mov  eax, [rel cur_fn_multi]
    and  eax, 7
    cmp  eax, 2
    jb   .ret_single
    call cg_emit_return_multi
    jmp  .ret_jmp
.ret_single:
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .ret_jmp
    ; float return value goes in xmm0, integer in rax
    call cg_expr_is_float
    test eax, eax
    jz   .ret_int
    mov  rdi, [r12 + AST.right]
    call cg_emit_float           ; value in xmm0
    ; the maths happened in xmm0, but an i64 function returns rax
    mov  eax, [rel cur_ret_float]
    test eax, eax
    jnz  .ret_jmp
    mov  rsi, s_trunc
    call emit_cstr
    jmp  .ret_jmp
.ret_int:
    mov  rdi, [r12 + AST.right]
    call cg_emit                 ; value in rax
    ; the mirror of the case above: an integer expression returned
    ; from a real64 function has to reach the caller in xmm0
    mov  eax, [rel cur_ret_float]
    test eax, eax
    jz   .ret_jmp
    mov  rsi, s_cvt_i2d
    call emit_cstr
.ret_jmp:
    mov  edi, [rel cur_ret_id]
    mov  eax, IR_JMPRET
    call ir_ctl
    jmp  .out

.multi_stmt:
    call cg_emit_multi
    jmp  .out

.lambda_expr:
    call cg_emit_lambda
    jmp  .out

; --- peek8/16/32(address): exact-width read, zero-extended into rax ---
.peek8_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_peek8_seq
    call emit_cstr
    jmp  .out
.peek16_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_peek16_seq
    call emit_cstr
    jmp  .out
.peek32_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_peek32_seq
    call emit_cstr
    jmp  .out

; --- p.field : read a struct field at its declared width ---
.member_expr:
    ; Enum.Member is written like a field access but names no variable, so it
    ; is answered here with the constant instead of a load from the frame.
    call cg_member_enum
    test eax, eax
    jz   .member_load
    push rdx
    mov  rsi, s_movrax_imm
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .out
.member_load:
    call cg_member_global
    test eax, eax
    jz   .member_lload
    mov  eax, [rel mem_width]
    mov  rsi, s_gld8
    cmp  eax, 4
    jne  .mg_r2
    mov  rsi, s_gld4
.mg_r2:
    cmp  eax, 2
    jne  .mg_r1
    mov  rsi, s_gld2
.mg_r1:
    cmp  eax, 1
    jne  .mg_rgo
    mov  rsi, s_gld1
.mg_rgo:
    call emit_cstr
    call cg_member_sext
    jmp  .out
.member_lload:
    call cg_member_offset            ; eax = offset, edx = width
    push rax
    cmp  edx, 1
    je   .mr1
    cmp  edx, 2
    je   .mr2
    cmp  edx, 4
    je   .mr4
    mov  rsi, s_ld8_pre
    jmp  .mr_go
.mr1:
    mov  rsi, s_ld1_pre
    jmp  .mr_go
.mr2:
    mov  rsi, s_ld2_pre
    jmp  .mr_go
.mr4:
    mov  rsi, s_ld4_pre
.mr_go:
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_closemem
    call emit_cstr
    call cg_member_sext
    jmp  .out

; --- &x : rax = address of a local, a global, or a FUNCTION ---
.addr_expr:
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .addr_glb
    ; an array parameter's slot holds the address of the array, so its
    ; address is that value, not the slot's ('&v[i]' of a parameter used to
    ; point into the frame)
    mov  rsi, s_addr_pre
    lea  rcx, [rel var_isref]
    mov  ecx, [rcx + rax*4]
    test ecx, ecx
    jz   .addr_lea
    mov  rsi, s_addr_ldpre
.addr_lea:
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_find_var
    mov  edi, eax
    call emit_uint
    mov  rsi, s_addr_post
    call emit_cstr
.addr_index:
    ; an index? '&v[i]' is the base plus i * element width
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .out
    mov  rsi, s_addr_idx
    call emit_cstr                   ; park the base
    mov  rdi, [r12 + AST.right]
    call cg_emit                     ; index in rax
    ; scale it: a pointer's element width, else the array's
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .addr_byarr
    lea  rdx, [rel var_elemsz]
    mov  edx, [rdx + rax*4]
    mov  ecx, edx
    test edx, edx
    jnz  .addr_scaled
.addr_byarr:
    mov  rdi, [r12 + AST.data]
    call cg_arr_aw
    mov  ecx, eax
.addr_scaled:
    push rcx
    mov  rsi, s_addr_scale
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_addr_add
    call emit_cstr
    jmp  .out
.addr_glb:
    ; not a local: is it a function name? (fn_toks was filled by the pre-pass,
    ; so this works no matter where the function is defined in the file)
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    cmp  eax, -1
    jne  .addr_fn
    ; default: global variable (NASM resolves forward refs). '&g[i]' adds
    ; the index, scaled; it used to be dropped, so &g[5] was &g[0].
    mov  rsi, s_lea_glb
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_emit_gtok
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .addr_index
.addr_fn:
    ; eax = the function's index: its address is taken
    call cg_note_addr
    ; emit  lea rax, [rel <name>]   (functions are labelled by their bare name)
    mov  rsi, s_lea_fn
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .out

; --- *p : rax = pointed-to contents ---
.deref_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_peek_seq
    call emit_cstr
    jmp  .out

; --- buf[i] : indexed read ---
.index_expr:
    mov  rdi, r12
    call cg_emit_index_value      ; flat element index in rax
    mov  rsi, s_idx_rcx
    call emit_cstr
    mov  rdi, [r12 + AST.data]    ; array token
    call cg_emit_idx_base
    mov  rdi, [r12 + AST.data]
    call cg_emit_elem_read        ; at the element's own width
    jmp  .out

; --- inb(port) -> dx=port, in al,dx, result in rax ---
.inb_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_inb_seq
    call emit_cstr
    jmp  .out

; --- peek(address) -> rax = [address] ---
.peek_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_peek_seq
    call emit_cstr
    jmp  .out
.readkey_e:
    mov  rsi, s_readkey
    call emit_cstr
    jmp  .out
.strlit_e:
    ; String literal -> bytes in .data (NUL terminated); rax = its address.
    ; Escapes handled: \n \t \r \0 \\ \" ; others emit the escaped char.
    push r13
    push r14
    push rbx
    mov  dword [rel last_strlit_len], 0
    call new_label
    mov  ebx, eax                    ; label id
    mov  rsi, s_sec_data
    call emit_cstr
    mov  rsi, s_str_lbl
    call emit_cstr
    mov  edi, ebx
    call emit_uint
    mov  rsi, s_str_db
    call emit_cstr
    mov  rdi, [r12 + AST.data]       ; the string token
    test rdi, rdi
    jz   .s_end
    mov  r13, [rdi + TOKEN.value]    ; points at the opening quote
    mov  r14d, dword [rdi + TOKEN.length]
    inc  r13                         ; skip opening quote
    sub  r14, 2                      ; drop both quotes
    jns  .s_loop
    xor  r14d, r14d
.s_loop:
    test r14, r14
    jz   .s_end
    movzx eax, byte [r13]
    cmp  al, 92                      ; backslash?
    jne  .s_plain
    cmp  r14, 1
    je   .s_plain                    ; lone trailing backslash
    movzx ecx, byte [r13 + 1]
    mov  eax, ecx                    ; default: the escaped char itself
    cmp  cl, 110
    jne  .s_e1
    mov  eax, 10
    jmp  .s_esc
.s_e1:
    cmp  cl, 116
    jne  .s_e2
    mov  eax, 9
    jmp  .s_esc
.s_e2:
    cmp  cl, 114
    jne  .s_e3
    mov  eax, 13
    jmp  .s_esc
.s_e3:
    cmp  cl, 48
    jne  .s_esc
    xor  eax, eax
.s_esc:
    add  r13, 2
    sub  r14, 2
    jmp  .s_emit
.s_plain:
    inc  r13
    dec  r14
.s_emit:
    inc  dword [rel last_strlit_len]  ; one byte written, escapes resolved
    push r13
    push r14
    mov  edi, eax
    call emit_uint
    ; 64 bytes a line: a long literal on one line was cut by the assemblers'
    ; line buffers, silently (a 6000-byte font came out as zeros)
    mov  rsi, s_comma
    test dword [rel last_strlit_len], 63
    jnz  .s_sep
    mov  rsi, s_str_cont
    jmp  .s_sep
.s_sep:
    call emit_cstr
    pop  r14
    pop  r13
    jmp  .s_loop
.s_end:
    mov  rsi, s_str_zero
    call emit_cstr
    mov  rsi, s_sec_text
    call emit_cstr
    mov  rsi, s_lea_str
    call emit_cstr
    mov  edi, ebx
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    pop  rbx
    pop  r14
    pop  r13
    jmp  .out
.readmouse_e:
    mov  rsi, s_readmouse
    call emit_cstr
    jmp  .out
.mousex_e:
    mov  rsi, s_mousex
    call emit_cstr
    jmp  .out
.mousey_e:
    mov  rsi, s_mousey
    call emit_cstr
    jmp  .out
.trunc_expr:
    mov  rdi, [r12 + AST.right]
    call cg_emit_float           ; value in xmm0
    mov  rsi, s_trunc
    call emit_cstr
    jmp  .out

.printc_stmt:
    mov  rdi, [r12 + AST.right]
    call cg_emit                 ; char code in rax
    mov  rsi, s_printc
    call emit_cstr
    jmp  .out

.print_stmt:
    mov  rdi, [r12 + AST.right]
    test rdi, rdi
    jz   .print_int_path
    mov  rax, [rdi + AST.node_type]
    cmp  rax, AST_STRING_LIT
    je   .print_string
.print_int_path:
    mov  rdi, [r12 + AST.right]
    call cg_expr_vtag
    test eax, eax
    jz   .print_untagged
    mov  esi, eax
    mov  rdi, [r12 + AST.right]
    call cg_emit_print_tagged
    test eax, eax
    jnz  .out
.print_untagged:
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .print_float
    mov  rdi, [r12 + AST.right]
    call cg_emit                 ; value in rax
    mov  rsi, s_print
    call emit_cstr
    jmp  .out
.print_float:
    mov  rdi, [r12 + AST.right]
    call cg_emit_float           ; value in xmm0
    mov  rsi, s_printf
    call emit_cstr
    jmp  .out
.print_string:
    mov  rdi, [r12 + AST.right]
    call cg_emit                 ; string address in rax
    mov  rsi, s_prints
    call emit_cstr
    jmp  .out

; --- outb(port, value) -> dx=port, al=value, out dx,al ---
.outb_stmt:
    mov  rdi, [r12 + AST.left]   ; port
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]  ; value
    call cg_emit
    mov  rsi, s_outb_seq
    call emit_cstr
    jmp  .out

; --- poke(address, value) -> [addr] = value (raw memory write) ---
.beep_stmt:
    mov  rdi, [r12 + AST.left]   ; frequency
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]  ; duration ms
    call cg_emit
    mov  rsi, s_beep_seq
    call emit_cstr
    jmp  .out

.poke_stmt:
    mov  rdi, [r12 + AST.left]   ; address
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]  ; value
    call cg_emit
    mov  rsi, s_poke_seq
    call emit_cstr
    jmp  .out
.savefile_stmt:
    mov  rdi, [r12 + AST.data]   ; name pointer (3rd arg)
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.left]   ; buffer address
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]  ; length in bytes
    call cg_emit
    mov  rsi, s_save_seq
    call emit_cstr
    jmp  .out

; --- poke8/16/32(address, value): exact-width write ---
.poke8_stmt:
    mov  r13, s_poke8_seq
    jmp  .poke_sized
.poke16_stmt:
    mov  r13, s_poke16_seq
    jmp  .poke_sized
.poke32_stmt:
    mov  r13, s_poke32_seq
.poke_sized:
    push r13
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit
    pop  rsi
    call emit_cstr
    jmp  .out

; --- asm { "..." } -> emits the instructions verbatim ---
.asm_stmt:
    ; Inline assembly can touch any register and jump anywhere. The register
    ; allocator leaves a function that contains one exactly as it is.
    mov  dword [rel ra_asm], 1
    push r13
    mov  r13, [r12 + AST.right]
.asm_it:
    test r13, r13
    jz   .asm_end
    mov  rsi, s_ind4
    call emit_cstr
    mov  rdi, [r13 + AST.data]
    call emit_tok_raw
    mov  rsi, s_nl
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .asm_it
.asm_end:
    pop  r13
    jmp  .out

.if_stmt:
    ; data=cond, left=then, right=else
    mov  rdi, r12
    call kt_mark                 ; an 'else if' is not a statement of a block
    call new_label               ; else label
    push rax
    call new_label               ; end label
    push rax
    ; cond
    mov  rdi, [r12 + AST.data]
    mov  rsi, [rsp+8]            ; else label
    call cg_cond_jz              ; to Lelse when the condition is false
    ; then
    mov  rdi, [r12 + AST.left]
    call cg_emit
    ; jmp Lend
    mov  rdi, [rsp]             ; end label
    mov  eax, IR_JMP
    call ir_ctl
    ; Lelse:
    mov  rdi, [rsp+8]
    mov  eax, IR_LABEL
    call ir_ctl
    ; else body
    mov  rdi, [r12 + AST.right]
    call cg_emit
    ; Lend:
    mov  rdi, [rsp]
    mov  eax, IR_LABEL
    call ir_ctl
    add  rsp, 16
    jmp  .out

.while_stmt:
    ; data=cond, right=body, left=step of a 'for' (0 for a plain while).
    ; [rsp] continue, [rsp+8] end, [rsp+16] top -- on the stack, not in
    ; registers: cg_emit preserves only r12.
    call new_label               ; top label
    push rax
    call new_label               ; end label
    push rax
    call new_label               ; continue label: just before the step
    push rax
    mov  rdi, [rsp+8]
    mov  rsi, [rsp]
    call cg_loop_push            ; what break and continue mean inside
    ; Ltop:
    mov  rdi, [rsp+16]
    mov  eax, IR_LABEL
    call ir_ctl
    ; cond (if data==0 => endless loop, skip the test)
    mov  rax, [r12 + AST.data]
    test rax, rax
    jz   .while_body
    mov  rdi, [r12 + AST.data]
    mov  rsi, [rsp+8]
    call cg_cond_jz              ; out of the loop when the condition is false
.while_body:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    ; Lcont: continue lands here, so the step of a 'for' still runs
    mov  rdi, [rsp]
    mov  eax, IR_LABEL
    call ir_ctl
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .while_nostep
    call kt_mark
    call cg_emit
.while_nostep:
    ; jmp Ltop
    mov  rdi, [rsp+16]
    mov  eax, IR_JMP
    call ir_ctl
    ; Lend:
    mov  rdi, [rsp+8]
    mov  eax, IR_LABEL
    call ir_ctl
    call cg_loop_pop
    add  rsp, 24
    jmp  .out

.break_st:
    ; Parsed since the beginning and never emitted: AST_BREAK went straight
    ; to .skip, so every 'break' was silently ignored and the loop ran on.
    ; A break outside any loop still emits nothing.
    call cg_loop_brk
    cmp  eax, -1
    je   .out
    mov  edi, eax
    mov  eax, IR_JMP
    call ir_ctl
    jmp  .out
.continue_st:
    call cg_loop_cont
    cmp  eax, -1
    je   .out
    mov  edi, eax
    mov  eax, IR_JMP
    call ir_ctl
    jmp  .out

.v2load_e:
    ; the address is an ordinary integer expression
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_v2_load
    call emit_cstr
    jmp  .out
.v2store_e:
    ; The value is computed first and parked, because evaluating the address
    ; is an ordinary integer expression and would not disturb xmm0 -- but a
    ; nested call inside it would. Coming back it lands in xmm1, so the store
    ; reads from there.
    mov  rdi, [r12 + AST.right]
    call cg_emit                     ; value in xmm0
    mov  rsi, s_v2_spill
    call emit_cstr
    mov  rdi, [r12 + AST.left]
    call cg_emit                     ; address in rax
    mov  rsi, s_v2_fill
    call emit_cstr                   ; value back, in xmm1
    mov  rsi, s_v2_store1
    call emit_cstr
    jmp  .out
.v2add_e:
    mov  rax, s_v2_add
    mov  [rel v2_op], rax
    jmp  .v2_binop
.v2sub_e:
    mov  rax, s_v2_sub
    mov  [rel v2_op], rax
    jmp  .v2_binop
.v2mul_e:
    mov  rax, s_v2_mul
    mov  [rel v2_op], rax
    jmp  .v2_binop
.v2_binop:
    ; Take the operation off the global at once and keep it on the stack.
    ; Nested calls -- vec4_mul(vec4_add(a,b), c) -- reach this same code and
    ; would overwrite it before the outer one got to read it.
    mov  rax, [rel v2_op]
    push rax
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rsi, s_v2_spill
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit                     ; right operand in xmm0
    mov  rsi, s_v2_fill
    call emit_cstr                   ; left operand back in xmm1
    pop  rsi
    call emit_cstr
    jmp  .out

.cpucount_e:
    mov  rsi, s_cpu_count
    call emit_cstr
    jmp  .out

.argcount_e:
    mov  rsi, s_arg_count
    call emit_cstr
    jmp  .out
.argget_e:
    mov  rdi, [r12 + AST.right]      ; the index
    call cg_emit
    mov  rsi, s_arg_get
    call emit_cstr
    jmp  .out
.targetos_e:
    ; a constant: the runtime never has to ask
    mov  rsi, s_target_win
    mov  al, [rel cg_target]
    cmp  al, TARGET_ELF
    jne  .tos_notlinux
    mov  rsi, s_target_linux
    jmp  .tos_emit
.tos_notlinux:
    cmp  al, TARGET_KRN
    jne  .tos_notkrn
    mov  rsi, s_target_krn
    jmp  .tos_emit
.tos_notkrn:
    cmp  al, TARGET_BARE
    jne  .tos_emit
    mov  rsi, s_target_bare
    jmp  .tos_emit
.tos_emit:
    call emit_cstr
    jmp  .out

.yield_e:
    mov  rsi, s_yield
    call emit_cstr
    jmp  .out

.dllload_e:
    mov  rdi, [r12 + AST.right]      ; the name
    call cg_emit
    mov  rsi, s_dll_load
    call emit_cstr
    jmp  .out

.dllproc_e:
    mov  rdi, [r12 + AST.left]       ; the library, parked
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]      ; the name
    call cg_emit
    mov  rsi, s_dll_proc
    call emit_cstr
    jmp  .out

.ticks_e:
    mov  rsi, s_ticks
    call emit_cstr
    jmp  .out

.tickrate_e:
    mov  rsi, s_tickrate
    call emit_cstr
    jmp  .out

.thstart_e:
    ; thread_start(worker, x) with a function's bare name means &worker: the
    ; thread starts at the code, not at a function value's record
    mov  rdi, [r12 + AST.left]
    test rdi, rdi
    jz   .th_named
    cmp  qword [rdi + AST.node_type], AST_IDENTIFIER
    jne  .th_named
    mov  rdi, [rdi + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    jne  .th_named
    mov  rdi, [r12 + AST.left]
    mov  rdi, [rdi + AST.data]
    call cg_find_func
    cmp  eax, -1
    je   .th_named
    mov  rdi, [r12 + AST.left]
    mov  qword [rdi + AST.node_type], AST_ADDR_OF
.th_named:
    mov  rdi, [r12 + AST.left]
    call cg_note_thread              ; which function starts a thread
    ; the function address is parked while the argument is computed
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_th_start
    call emit_cstr
    jmp  .out

.thwait_e:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_th_wait
    call emit_cstr
    jmp  .out

.lkinit_e:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_lk_init
    call emit_cstr
    jmp  .out

.lktake_e:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_lk_take
    call emit_cstr
    jmp  .out

.lkgive_e:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rsi, s_lk_give
    call emit_cstr
    jmp  .out

.loadfile_e:
    ; name and buffer are parked while the capacity is computed, then the
    ; three land in rcx, rdx and r8 for the runtime routine
    mov  rdi, [r12 + AST.data]       ; name
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.left]       ; buffer
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  rdi, [r12 + AST.right]      ; capacity
    call cg_emit
    mov  rsi, s_load_seq
    call emit_cstr
    jmp  .out

.sizeof_e:
    ; Scalars go through cg_type_size; a struct name is looked up in the
    ; struct tables. An array type multiplies by its element count.
    mov  rdi, [r12 + AST.data]       ; the type token
    mov  rax, [rdi + TOKEN.type]
    cmp  rax, TOK_IDENT
    jne  .so_scalar
    call cg_find_struct
    cmp  eax, -1
    je   .so_eight
    call cg_struct_size              ; slots
    shl  eax, 3                      ; bytes
    jmp  .so_have
.so_scalar:
    call cg_type_size
    jmp  .so_have
.so_eight:
    mov  eax, 8
.so_have:
    mov  rcx, [r12 + AST.type_info]  ; element count, 0 when not an array
    test rcx, rcx
    jz   .so_emit
    mov  edx, dword [r12 + AST.child_count]   ; element width, 0 = as before
    test edx, edx
    jz   .so_mul
    mov  eax, edx
.so_mul:
    imul rax, rcx
.so_emit:
    push rax
    mov  rsi, s_movrax_imm
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .out

.fail_st:
    ; Record the cause and the hint, then return at once. There is no stack
    ; unwinding: the function simply leaves with zero and a flag set, which
    ; is the only thing that can be done safely inside an interrupt handler.
    ; The strings go through the ordinary string-literal path, which puts the
    ; bytes in .data and leaves the address in rax; it is then parked in the
    ; failure state.
    ; The parser already wrapped both strings in AST_STRING_LIT nodes, so the
    ; ordinary literal path emits the bytes and leaves the address in rax.
    mov  rdi, [r12 + AST.data]       ; message node
    call cg_emit
    mov  rsi, s_st_failmsg
    call emit_cstr
    mov  rdi, [r12 + AST.left]       ; hint node, 0 when absent
    test rdi, rdi
    jz   .fail_nohint
    call cg_emit
    mov  rsi, s_st_failhint
    call emit_cstr
    jmp  .fail_call
.fail_nohint:
    mov  rsi, s_fail_nohnt
    call emit_cstr
.fail_call:
    call kt_failcall
    mov  rsi, s_fail_after
    call emit_cstr
.fail_flag:
    mov  rsi, s_fail_set
    call emit_cstr
    mov  rsi, s_zero_rax
    call emit_cstr                   ; the function leaves with zero
    mov  edi, [rel cur_ret_id]
    mov  eax, IR_JMPRET
    call ir_ctl
    jmp  .out

.failed_e:
    mov  rsi, s_failed_rd
    call emit_cstr
    jmp  .out

.printfail_st:
    mov  rsi, s_pfail
    call emit_cstr
    jmp  .out

.cast:
    ; The target is an integer here: a float target was already routed to
    ; cg_emit_float by cg_expr_is_float. Two cases -- from a double, truncate
    ; toward zero; from an integer, narrow to the target width.
    ;
    ; The narrowing uses only and / mov / shl+sar. movzx and movsx are
    ; shorter, but kasm's coverage of them is unproven and a wrong encoding
    ; here would be silent.
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jz   .cast_from_int
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rsi, s_cvt_d2i
    call emit_cstr
    jmp  .cast_narrow
.cast_from_int:
    mov  rdi, [r12 + AST.right]
    call cg_emit
.cast_narrow:
    ; r12 survives the recursive cg_emit above (it pushes and pops it), so the
    ; width and the flags are read from the node here, not carried in a
    ; register that cg_emit is free to clobber.
    mov  rcx, [r12 + AST.type_info]  ; target width in bytes
    cmp  rcx, 8
    jae  .out                        ; 8 bytes, or unknown: nothing to do
    movzx eax, word [r12 + AST.col]
    shr  eax, 1
    and  eax, 1
    test eax, eax
    jnz  .cast_unsigned
    cmp  rcx, 1
    je   .cn_i8
    cmp  rcx, 2
    je   .cn_i16
    cmp  rcx, 4
    je   .cn_i32
    jmp  .out
.cn_i8:
    mov  rsi, s_nar_i8
    call emit_cstr
    jmp  .out
.cn_i16:
    mov  rsi, s_nar_i16
    call emit_cstr
    jmp  .out
.cn_i32:
    mov  rsi, s_nar_i32
    call emit_cstr
    jmp  .out
.cast_unsigned:
    cmp  rcx, 1
    je   .cn_u8
    cmp  rcx, 2
    je   .cn_u16
    cmp  rcx, 4
    je   .cn_u32
    jmp  .out
.cn_u8:
    mov  rsi, s_nar_u8
    call emit_cstr
    jmp  .out
.cn_u16:
    mov  rsi, s_nar_u16
    call emit_cstr
    jmp  .out
.cn_u32:
    mov  rsi, s_nar_u32
    call emit_cstr
    jmp  .out

.binop:
    ; --- texts: == and != compare the bytes, + joins ---
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_PLUS
    je   .bin_maycat
    cmp  rax, TOK_EQ
    je   .bin_maycmp
    cmp  rax, TOK_NEQ
    je   .bin_maycmp
    jmp  .bin_plain
.bin_maycat:
    mov  rdi, r12
    call cg_is_concat
    test eax, eax
    jz   .bin_plain
    call cg_emit_concat
    jmp  .out
.bin_maycmp:
    mov  rdi, r12
    call cg_is_textcmp
    test eax, eax
    jz   .bin_plain
    call cg_emit_textcmp
    jmp  .out
.bin_plain:
    ; --- short-circuit for && and || ---
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_AND
    je   .logical_and
    cmp  rax, TOK_OR
    je   .logical_or
    ; float comparison? if the operator is a comparison AND either operand
    ; is float, use SSE ucomisd instead of integer cmp.
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_EQ
    je   .maybe_fcmp
    cmp  rax, TOK_NEQ
    je   .maybe_fcmp
    cmp  rax, TOK_LT
    je   .maybe_fcmp
    cmp  rax, TOK_GT
    je   .maybe_fcmp
    cmp  rax, TOK_LTE
    je   .maybe_fcmp
    cmp  rax, TOK_GTE
    je   .maybe_fcmp
    jmp  .int_binop
.maybe_fcmp:
    mov  rdi, [r12 + AST.left]
    call cg_expr_is_float
    test eax, eax
    jnz  .fcompare
    mov  rdi, [r12 + AST.right]
    call cg_expr_is_float
    test eax, eax
    jnz  .fcompare
    jmp  .int_binop
.fcompare:
    ; left -> xmm0 ; push ; right -> xmm1 ; ucomisd ; setcc
    mov  rdi, [r12 + AST.left]
    call cg_emit_float
    mov  rsi, s_push_xmm
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit_float
    mov  rsi, s_pop_xmm1
    call emit_cstr
    ; now xmm0 = left, xmm1 = right
    mov  rsi, s_fcmp
    call emit_cstr
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_LT
    je   .fc_lt
    cmp  rax, TOK_GT
    je   .fc_gt
    cmp  rax, TOK_LTE
    je   .fc_le
    cmp  rax, TOK_GTE
    je   .fc_ge
    cmp  rax, TOK_EQ
    je   .fc_eq
    ; TOK_NEQ
    mov  rsi, s_fsetne
    call emit_cstr
    jmp  .out
.fc_lt:
    mov  rsi, s_fsetb
    call emit_cstr
    jmp  .out
.fc_gt:
    mov  rsi, s_fseta
    call emit_cstr
    jmp  .out
.fc_le:
    mov  rsi, s_fsetbe
    call emit_cstr
    jmp  .out
.fc_ge:
    mov  rsi, s_fsetae
    call emit_cstr
    jmp  .out
.fc_eq:
    mov  rsi, s_fsete
    call emit_cstr
    jmp  .out
.int_binop:
    ; left -> rax. When the right side is a constant or a local it is loaded
    ; straight into rcx: loading it cannot disturb rax, so the push and the pop
    ; that protect rax around a general expression are dead weight. That was
    ; five instructions out of seven in 's = s + i'.
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rdi, [r12 + AST.right]
    call cg_leaf_to_rcx
    test eax, eax
    jnz  .int_op
    ; general case: left -> push ; right -> rcx ; pop rax
    mov  rsi, s_pushrax
    call emit_cstr
    mov  rdi, [r12 + AST.right]
    call cg_emit
    ; pointer arithmetic: scale the offset by the element width
    call cg_ptr_scale
    mov  rsi, s_movrcxrax
    call emit_cstr
    mov  rsi, s_poprax
    call emit_cstr
.int_op:
    ; decide the sign BEFORE emitting: div/idiv, shr/sar and setb/setl all
    ; hang on it
    mov  rdi, r12
    call cg_binop_is_unsigned
    mov  [rel binop_unsigned], eax
    mov  rax, [r12 + AST.data]   ; operator (token type)
    call cg_emit_binop_op
    jmp  .out

.logical_and:
    call new_label
    push rax                     ; Lfalse
    call new_label
    push rax                     ; Lend
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rdi, [rsp+8]            ; Lfalse
    mov  eax, IR_JZ
    call ir_ctl
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rdi, [rsp+8]
    mov  eax, IR_JZ
    call ir_ctl
    mov  rsi, s_mov_rax1
    call emit_cstr
    mov  rdi, [rsp]             ; Lend
    mov  eax, IR_JMP
    call ir_ctl
    mov  rdi, [rsp+8]           ; Lfalse:
    mov  eax, IR_LABEL
    call ir_ctl
    mov  rsi, s_mov_rax0
    call emit_cstr
    mov  rdi, [rsp]            ; Lend:
    mov  eax, IR_LABEL
    call ir_ctl
    add  rsp, 16
    jmp  .out
.logical_or:
    call new_label
    push rax                     ; Ltrue
    call new_label
    push rax                     ; Lend
    mov  rdi, [r12 + AST.left]
    call cg_emit
    mov  rdi, [rsp+8]           ; Ltrue
    mov  eax, IR_JNZ
    call ir_ctl
    mov  rdi, [r12 + AST.right]
    call cg_emit
    mov  rdi, [rsp+8]
    mov  eax, IR_JNZ
    call ir_ctl
    mov  rsi, s_mov_rax0
    call emit_cstr
    mov  rdi, [rsp]            ; Lend
    mov  eax, IR_JMP
    call ir_ctl
    mov  rdi, [rsp+8]          ; Ltrue:
    mov  eax, IR_LABEL
    call ir_ctl
    mov  rsi, s_mov_rax1
    call emit_cstr
    mov  rdi, [rsp]           ; Lend:
    mov  eax, IR_LABEL
    call ir_ctl
    add  rsp, 16
    jmp  .out
.unop:
    mov  rdi, [r12 + AST.right]
    call cg_emit
    ; AST.data carries the operator token: '-' negates, '~' complements,
    ; '!' is the logical not.  Nodes built before AST.data was recorded
    ; hold 0, which keeps the old behaviour of negating.
    mov  rax, [r12 + AST.data]
    cmp  rax, TOK_TILDE
    je   .unop_bnot
    cmp  rax, TOK_NOT
    je   .unop_lnot
    cmp  rax, KW_INVCACHE
    je   .unop_clflush
    cmp  rax, KW_PREFETCH0
    je   .unop_pref0
    mov  rsi, s_neg
    call emit_cstr
    jmp  .out
.unop_bnot:
    mov  rsi, s_bnot
    call emit_cstr
    jmp  .out
.unop_lnot:
    mov  rsi, s_lnot
    call emit_cstr
    jmp  .out
; the cache ops leave rax untouched: the expression is the address itself
.unop_clflush:
    mov  rsi, s_clflush
    call emit_cstr
    jmp  .out
.unop_pref0:
    mov  rsi, s_prefetch0
    call emit_cstr
    jmp  .out

.syscall:
    ; syscall(num, arg1..arg6) -> real x86-64 syscall instruction
    ; Linux/x64 convention: rax=num, rdi,rsi,rdx,r10,r8,r9 = args 1..6
    ; Strategy: evaluate each arg (left to right) and push it; then pop
    ; into the target register in reverse order; finally syscall.
    ; r12 (the syscall node) is preserved across cg_emit.
    mov  r13, [r12 + AST.right]   ; first BLOCK node of the chain of args
.sys_eval:
    test r13, r13
    jz   .sys_pops
    mov  rdi, [r13 + AST.left]    ; expression of the arg
    push r13
    call cg_emit                  ; result in rax
    pop  r13
    mov  rsi, s_pushrax
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .sys_eval
.sys_pops:
    mov  r13, [r12 + AST.data]    ; number of args
    dec  r13                      ; index of the last one
.sys_pop_loop:
    test r13, r13
    js   .sys_do                  ; index < 0 -> done
    mov  rdi, r13
    call emit_syscall_pop
    dec  r13
    jmp  .sys_pop_loop
.sys_do:
    ; On Windows the instruction would crash the program: the kernel's
    ; numbers are private there. It becomes a fail with a cause instead.
    mov  rsi, s_syscall
    mov  al, [rel cg_target]
    cmp  al, TARGET_PE
    jne  .sys_emit
    call kt_flush
    mov  rsi, s_no_syscall
    jmp  .sys_emit
.sys_emit:
    call emit_cstr
    jmp  .out

.call:
    call cg_intrinsic                ; vec4_add(...) and the like: inline
    test eax, eax
    jnz  .out
    mov  rdi, r12
    call cg_call_kind                ; eax = 0 a function, 1 through a value
    cmp  eax, 2
    je   .out                        ; no such function: reported
    cmp  eax, 1
    jne  .call_direct
    call cg_note_indirect
    mov  rdi, r12
    call cg_fnval_args               ; the record goes along as a last argument
.call_direct:
    mov  rdi, [r12 + AST.data]
    call cg_note_call                ; caller -> callee, for the thread check
    ; --- evaluate arguments onto the stack, then load into the ABI registers.
    ; Integer args -> rcx/rdx/r8/r9 ; float args -> xmm0..xmm3 (by position).
    push r13
    push r14
    push r15
    ; Arguments seven and up are pushed FIRST and in reverse, so that the
    ; seventh ends up nearest the return address and the callee finds them in
    ; declaration order. The register arguments are pushed and popped above
    ; them, which balances out and leaves these untouched.
    mov  rdi, [r12 + AST.right]
    call cg_count_list
    mov  dword [rel extra_args], 0
    cmp  eax, 6
    jbe  .no_extras
    sub  eax, 6
    mov  [rel extra_args], eax
    mov  rdi, [r12 + AST.right]
    call cg_count_list
    mov  r15d, eax                   ; total count
.extra_loop:
    dec  r15d
    cmp  r15d, 6
    jb   .no_extras
    mov  r13, [r12 + AST.right]
    mov  ecx, r15d
.extra_walk:
    test ecx, ecx
    jz   .extra_have
    mov  r13, [r13 + AST.right]
    dec  ecx
    jmp  .extra_walk
.extra_have:
    mov  rdi, [r13 + AST.left]
    call cg_expr_is_float
    test eax, eax
    jnz  .extra_f
    mov  rdi, [r13 + AST.left]
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    jmp  .extra_loop
.extra_f:
    mov  rdi, [r13 + AST.left]
    call cg_emit_float
    mov  rsi, s_fpush                ; same sequence the register path uses
    call emit_cstr
    jmp  .extra_loop
.no_extras:
    mov  r13, [r12 + AST.right]      ; argument list
    xor  r14d, r14d                  ; arg index
.arg_push:
    test r13, r13
    jz   .arg_done
    cmp  r14d, 6
    jae  .arg_done
    ; A struct argument is passed by address; the callee's prologue copies it
    ; in. Without this the argument was evaluated as an ordinary integer
    ; expression, which loaded the first eight bytes of the struct -- the raw
    ; bits of its first field -- and passed those.
    mov  rdi, [r13 + AST.left]
    call cg_arg_struct_id
    cmp  eax, -1
    jne  .arg_push_struct
    mov  rdi, [r13 + AST.left]
    call cg_expr_is_float
    test eax, eax
    jnz  .arg_push_f
    ; a constant or a local goes straight into its register at the end,
    ; after every pop; nothing to evaluate or push for it here
    mov  rdi, r13
    mov  esi, r14d
    call cg_arg_leaf_here
    test eax, eax
    jnz  .arg_push_next
    mov  rdi, r12
    mov  esi, r14d
    call cg_param_vtag               ; [a, b] for a list<T> parameter is a list
    mov  esi, eax
    mov  rdi, [r13 + AST.left]
    call cg_emit_for                 ; int value in rax
    mov  rsi, s_push_rax
    call emit_cstr
    jmp  .arg_push_next
.arg_push_struct:
    mov  rdi, [r13 + AST.left]
    mov  rdi, [rdi + AST.data]       ; variable name token
    call cg_find_var_idx
    cmp  eax, -1
    je   .arg_push_next
    ; A slot that already holds an address -- an array parameter being handed
    ; on to another function -- is forwarded with mov, not lea. Taking its
    ; address instead would pass a pointer to the pointer.
    lea  rcx, [rel var_isref]
    mov  ecx, [rcx + rax*4]
    lea  rdx, [rel var_offs]
    mov  edi, [rdx + rax*4]
    push rdi
    test ecx, ecx
    jnz  .arg_push_fwd
    mov  rsi, s_lea_rax_pre
    call emit_cstr
    jmp  .arg_push_addr
.arg_push_fwd:
    mov  rsi, s_ld_rax_pre
    call emit_cstr
.arg_push_addr:
    pop  rdi
    call emit_uint
    mov  rsi, s_lea_rax_suf
    call emit_cstr
    mov  rsi, s_push_rax
    call emit_cstr
    jmp  .arg_push_next
.arg_push_f:
    mov  rdi, [r13 + AST.left]
    call cg_emit_float               ; float value in xmm0
    mov  rsi, s_fpush
    call emit_cstr
.arg_push_next:
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .arg_push
.arg_done:
    ; second pass over the arg list to know each arg's type while popping
    ; in reverse. Rebuild list pointer and collect flags into a small array.
    ; We pop in reverse order (last pushed = last arg).
.arg_pop:
    test r14d, r14d
    jz   .arg_ready
    dec  r14d
    ; find the r14-th arg node to test its type
    mov  r13, [r12 + AST.right]
    mov  ecx, r14d
.arg_walk:
    test ecx, ecx
    jz   .arg_walk_done
    mov  r13, [r13 + AST.right]
    dec  ecx
    jmp  .arg_walk
.arg_walk_done:
    mov  rdi, [r13 + AST.left]
    call cg_arg_struct_id
    cmp  eax, -1
    jne  .arg_pop_int                ; an address: goes in an integer register
    mov  rdi, [r13 + AST.left]
    call cg_expr_is_float
    test eax, eax
    jnz  .arg_pop_f
.arg_pop_int:
    ; a leaf was never pushed, so there is nothing to pop for it
    mov  rdi, r13
    mov  esi, r14d
    call cg_arg_leaf_here
    test eax, eax
    jnz  .arg_pop
    ; integer: pop into rcx/rdx/r8/r9
    lea  rsi, [rel s_poparg0]
    cmp  r14d, 0
    je   .ap_ok
    lea  rsi, [rel s_poparg1]
    cmp  r14d, 1
    je   .ap_ok
    lea  rsi, [rel s_poparg2]
    cmp  r14d, 2
    je   .ap_ok
    lea  rsi, [rel s_poparg3]
    cmp  r14d, 3
    je   .ap_ok
    lea  rsi, [rel s_poparg4]
    cmp  r14d, 4
    je   .ap_ok
    lea  rsi, [rel s_poparg5]
.ap_ok:
    call emit_cstr
    jmp  .arg_pop
.arg_pop_f:
    ; float: movsd xmm<idx>, [rsp] ; add rsp,8
    mov  rsi, s_fpop_pre
    call emit_cstr
    mov  edi, r14d
    call emit_uint
    mov  rsi, s_fpop_suf
    call emit_cstr
    jmp  .arg_pop
.arg_ready:
    ; Now the leaves, straight into their registers. Last, after every pop:
    ; their sources are an allocated register, a stack slot or a constant --
    ; never another argument register -- so loading them cannot overwrite a
    ; value still waiting, and neither a local nor a constant has a side
    ; effect whose order could matter.
    mov  r13, [r12 + AST.right]
    xor  r14d, r14d
.leaf_loop:
    test r13, r13
    jz   .leaf_done
    cmp  r14d, 6
    jae  .leaf_done
    mov  rdi, r13
    mov  esi, r14d
    call cg_arg_leaf_here
    test eax, eax
    jz   .leaf_next
    mov  rdi, [r13 + AST.left]
    mov  edx, r14d
    call cg_emit_leaf_arg
.leaf_next:
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .leaf_loop
.leaf_done:
    pop  r15
    pop  r14
    pop  r13
    mov  rsi, s_shadow_sub
    call emit_cstr
    call kt_flush
    cmp  qword [r12 + AST.owner_type], FNVAL_MARK
    jne  .call_named
    ; through a value: its record's first word is the code
    mov  rdi, [r12 + AST.data]
    call cg_emit_fnval_target
    jmp  .call_after
.call_named:
    mov  rsi, s_call
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .call_nl
    call emit_tok
.call_nl:
    mov  rsi, s_nl
    call emit_cstr
.call_after:
    mov  rsi, s_shadow_add
    call emit_cstr
    ; drop the stack arguments
    mov  eax, [rel extra_args]
    test eax, eax
    jz   .no_cleanup
    shl  eax, 3
    push rax
    mov  rsi, s_addrsp_pre
    call emit_cstr
    pop  rdi
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
.no_cleanup:
    jmp  .out

; --- call ptr(args) : indirect call through a function pointer ---
; AST.left = pointer expression, AST.right = argument list (AST_ARG chain,
; identical shape to .call above). The pointer is evaluated FIRST and
; pushed to the stack, so it survives argument evaluation even when an
; argument is itself a nested call that clobbers rax/r11.
.call_indirect:
    call cg_note_indirect            ; its target cannot be known
    push r13
    push r14
    mov  rdi, [r12 + AST.left]
    call cg_emit                     ; pointer value in rax
    mov  rsi, s_push_rax
    call emit_cstr                   ; stack: [ptr]
    ; more than four arguments: the Windows convention puts the fifth on at
    ; [rsp+32], above the shadow space (CreateWindowExA takes twelve)
    mov  r13, [r12 + AST.right]
    xor  r14d, r14d
.ci_count:
    test r13, r13
    jz   .ci_counted
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .ci_count
.ci_counted:
    cmp  r14d, 4
    ja   .ci_many
    mov  r13, [r12 + AST.right]      ; argument list
    xor  r14d, r14d
.ci_arg_push:
    test r13, r13
    jz   .ci_arg_done
    cmp  r14d, 4
    jae  .ci_arg_done
    mov  rdi, [r13 + AST.left]
    call cg_emit                     ; value in rax
    mov  rsi, s_push_rax
    call emit_cstr
    inc  r14d
    mov  r13, [r13 + AST.right]
    jmp  .ci_arg_push
.ci_arg_done:
.ci_arg_pop:
    test r14d, r14d
    jz   .ci_arg_ready
    dec  r14d
    lea  rsi, [rel s_poparg0]
    cmp  r14d, 0
    je   .ci_ap_ok
    lea  rsi, [rel s_poparg1]
    cmp  r14d, 1
    je   .ci_ap_ok
    lea  rsi, [rel s_poparg2]
    cmp  r14d, 2
    je   .ci_ap_ok
    lea  rsi, [rel s_poparg3]
.ci_ap_ok:
    call emit_cstr
    jmp  .ci_arg_pop
.ci_arg_ready:
    ; stack now holds just [ptr] on top; args are in rcx/rdx/r8/r9
    mov  rsi, s_pop_r11
    call emit_cstr                   ; r11 = pointer (volatile, not an arg reg)
    pop  r14
    pop  r13
    ; A system library wants rsp 16-aligned at the call, and this call may
    ; sit inside an expression with temporaries pushed: align it, keeping
    ; the old rsp on the stack (rax is no argument register)
    mov  rsi, s_ci_align
    call emit_cstr
    mov  rsi, s_shadow_sub
    call emit_cstr
    call kt_flush
    mov  rsi, s_call_r11
    call emit_cstr
    mov  rsi, s_shadow_add
    call emit_cstr
    mov  rsi, s_ci_unalign
    call emit_cstr
    jmp  .out

.ci_many:
    ; every argument is pushed, the first deepest, the pointer under them.
    ; rax keeps that place: argument i (1-based) is [rax + 8*(n-i)], the
    ; pointer [rax + 8*n]. rsp is then aligned to 16, with rax saved, and a
    ; frame of A = 32 + 8*(n-4) bytes, rounded up to 16, takes the fifth
    ; argument on at [rsp+32].
    push r15
    push rbx
    mov  ebx, r14d                   ; n
    mov  r13, [r12 + AST.right]
    jmp  .cim_push
.cim_push:
    test r13, r13
    jz   .cim_pushed
    mov  rdi, [r13 + AST.left]
    call cg_emit
    mov  rsi, s_push_rax
    call emit_cstr
    mov  r13, [r13 + AST.right]
    jmp  .cim_push
.cim_pushed:
    mov  rsi, s_ci_align
    call emit_cstr
    mov  r15d, ebx
    sub  r15d, 4
    shl  r15d, 3
    add  r15d, 47
    and  r15d, -16
    mov  rsi, s_subrsp
    call emit_cstr
    mov  edi, r15d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    ; the stack arguments: i = 5..n
    mov  r14d, 5
    jmp  .cim_stk
.cim_stk:
    cmp  r14d, ebx
    ja   .cim_regs
    mov  rsi, s_ci_ldr10
    call emit_cstr
    mov  eax, ebx
    sub  eax, r14d
    shl  eax, 3
    mov  edi, eax
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    mov  rsi, s_ci_strsp
    call emit_cstr
    mov  eax, r14d
    sub  eax, 5
    shl  eax, 3
    add  eax, 32
    mov  edi, eax
    call emit_uint
    mov  rsi, s_ci_r10
    call emit_cstr
    inc  r14d
    jmp  .cim_stk
.cim_regs:
    ; the first four
    xor  r14d, r14d
    jmp  .cim_reg
.cim_reg:
    cmp  r14d, 4
    jae  .cim_call
    lea  rsi, [rel s_ci_ldrcx]
    cmp  r14d, 0
    je   .cim_rn
    lea  rsi, [rel s_ci_ldrdx]
    cmp  r14d, 1
    je   .cim_rn
    lea  rsi, [rel s_ci_ldr8]
    cmp  r14d, 2
    je   .cim_rn
    lea  rsi, [rel s_ci_ldr9]
    jmp  .cim_rn
.cim_rn:
    call emit_cstr
    mov  eax, ebx
    sub  eax, r14d
    dec  eax                         ; n - i with i = r14 + 1
    shl  eax, 3
    mov  edi, eax
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    inc  r14d
    jmp  .cim_reg
.cim_call:
    mov  rsi, s_ci_ldr11
    call emit_cstr
    mov  eax, ebx
    shl  eax, 3
    mov  edi, eax
    call emit_uint
    mov  rsi, s_closebrk
    call emit_cstr
    call kt_flush
    mov  rsi, s_call_r11
    call emit_cstr
    mov  rsi, s_addrsp_pre
    call emit_cstr
    mov  edi, r15d
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    mov  rsi, s_ci_unalign
    call emit_cstr
    ; drop the arguments and the pointer
    mov  rsi, s_addrsp_pre
    call emit_cstr
    mov  eax, ebx
    shl  eax, 3
    add  eax, 8
    mov  edi, eax
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    pop  rbx
    pop  r15
    pop  r14
    pop  r13
    jmp  .out

.ident:
    mov  rdi, [r12 + AST.data]
    call cg_find_var_idx
    cmp  eax, -1
    je   .ident_glb
    mov  rdi, [r12 + AST.data]
    call cg_find_var
    mov  ecx, eax
    mov  edi, ecx
    call ir_ldloc                    ; mov rax, [rbp-N], as a structured record
    jmp  .out
.ident_glb:
    ; a function's name used as a value: the address of its record
    mov  rdi, [r12 + AST.data]
    call cg_find_global
    cmp  eax, -1
    jne  .ident_gvar
    mov  rdi, [r12 + AST.data]
    call cg_find_func
    cmp  eax, -1
    je   .ident_gvar
    call cg_note_addr
    lea  rcx, [rel fn_asval]
    mov  dl, 1
    mov  [rcx + rax], dl
    mov  rsi, s_lea_fnrec
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call emit_tok
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .out
.ident_gvar:
    mov  rsi, s_ldg_pre
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    call cg_emit_gtok
    mov  rsi, s_closebrk
    call emit_cstr
    jmp  .out

.boollit:
    ; the value is in type_info, since 'mov rax, true' is not an instruction
    mov  rsi, s_movrax_imm
    call emit_cstr
    mov  rdi, [r12 + AST.type_info]
    call emit_uint
    mov  rsi, s_nl
    call emit_cstr
    jmp  .out

.intlit:
    mov  rsi, s_movrax_imm
    call emit_cstr
    mov  rdi, [r12 + AST.data]
    test rdi, rdi
    jz   .intlit_zero
    call emit_tok
    jmp  .intlit_nl
.intlit_zero:
    xor  rdi, rdi
    call emit_uint
.intlit_nl:
    mov  rsi, s_nl
    call emit_cstr
    jmp  .out

.skip:
.out:
    pop  r12
.ret0:
    ret

; cg_emit_binop_op(rax = token type of the operator)
; ==============================================================================
; cg_binop_is_unsigned(rdi = AST_BINOP) -> eax = 1 when either side is unsigned
; ==============================================================================
cg_binop_is_unsigned:
    push rbx
    mov  rbx, rdi
    mov  rdi, [rbx + AST.left]
    call cg_expr_is_unsigned
    test eax, eax
    jnz  .b_yes
    mov  rdi, [rbx + AST.right]
    call cg_expr_is_unsigned
    test eax, eax
    jnz  .b_yes
    xor  eax, eax
    pop  rbx
    ret
.b_yes:
    mov  eax, 1
    pop  rbx
    ret

cg_emit_binop_op:
    cmp  rax, TOK_PLUS
    je   .add
    cmp  rax, TOK_MINUS
    je   .sub
    cmp  rax, TOK_STAR
    je   .mul
    cmp  rax, TOK_SLASH
    je   .div
    cmp  rax, TOK_PERCENT
    je   .mod
    cmp  rax, TOK_LSHIFT
    je   .shl
    cmp  rax, TOK_RSHIFT
    je   .shr
    cmp  rax, TOK_URSHIFT
    je   .ushr
    cmp  rax, TOK_CARET
    je   .bxor
    cmp  rax, TOK_AMPERSAND
    je   .band
    cmp  rax, TOK_PIPE
    je   .bor
    cmp  rax, KW_ROTL
    je   .rotl
    cmp  rax, KW_ROTR
    je   .rotr
    cmp  rax, TOK_EQ
    je   .eq
    cmp  rax, TOK_NEQ
    je   .neq
    cmp  rax, TOK_LT
    je   .lt
    cmp  rax, TOK_GT
    je   .gt
    cmp  rax, TOK_LTE
    je   .lte
    cmp  rax, TOK_GTE
    je   .gte
    ret
.add:
    mov  eax, ALU_ADD
    jmp  .alu
.sub:
    mov  eax, ALU_SUB
    jmp  .alu
.mul:
    mov  eax, ALU_IMUL
    jmp  .alu
.div:
    ; div for unsigned, idiv for signed. Emitting idiv for a u64 above 2^63
    ; gives the wrong quotient and can fault.
    cmp  dword [rel binop_unsigned], 0
    jne  .udiv
    mov  rsi, s_idiv
    jmp  emit_cstr
.udiv:
    mov  rsi, s_udiv
    jmp  emit_cstr
.mod:
    cmp  dword [rel binop_unsigned], 0
    jne  .umod
    mov  rsi, s_imod
    jmp  emit_cstr
.umod:
    mov  rsi, s_umod
    jmp  emit_cstr
.shl:
    mov  rsi, s_shl
    jmp  emit_cstr
.shr:
    ; '>>' on an unsigned value is a logical shift. sar drags the sign bit
    ; down, which wrecks every bit-field extraction from a page table entry.
    cmp  dword [rel binop_unsigned], 0
    jne  .shr_u
    mov  rsi, s_shr
    jmp  emit_cstr
.shr_u:
    mov  rsi, s_ushr
    jmp  emit_cstr
.ushr:
    mov  rsi, s_ushr
    jmp  emit_cstr
.bxor:
    mov  eax, ALU_XOR
    jmp  .alu
.band:
    mov  eax, ALU_AND
    jmp  .alu
.bor:
    mov  eax, ALU_OR
    jmp  .alu
.alu:
    ; A structured record, so the flush can see the operation next to the loads
    ; around it and fold them into one instruction on the allocated registers.
    ; Its plain lowering is exactly the text these used to write.
    push rdi
    mov  edi, eax
    mov  eax, IR_ALU
    call ir_ctl
    pop  rdi
    ret
.rotl:
    mov  rsi, s_rotl
    jmp  emit_cstr
.rotr:
    mov  rsi, s_rotr
    jmp  emit_cstr
.eq:
    mov  rsi, s_cmp
    call emit_cstr
    mov  rsi, s_sete
    jmp  emit_cstr
.neq:
    mov  rsi, s_cmp
    call emit_cstr
    mov  rsi, s_setne
    jmp  emit_cstr
.lt:
    mov  rsi, s_cmp
    call emit_cstr
    cmp  dword [rel binop_unsigned], 0
    jne  .lt_u
    mov  rsi, s_setl
    jmp  emit_cstr
.lt_u:
    mov  rsi, s_setb
    jmp  emit_cstr
.gt:
    mov  rsi, s_cmp
    call emit_cstr
    cmp  dword [rel binop_unsigned], 0
    jne  .gt_u
    mov  rsi, s_setg
    jmp  emit_cstr
.gt_u:
    mov  rsi, s_seta
    jmp  emit_cstr
.lte:
    mov  rsi, s_cmp
    call emit_cstr
    cmp  dword [rel binop_unsigned], 0
    jne  .lte_u
    mov  rsi, s_setle
    jmp  emit_cstr
.lte_u:
    mov  rsi, s_setbe
    jmp  emit_cstr
.gte:
    mov  rsi, s_cmp
    call emit_cstr
    cmp  dword [rel binop_unsigned], 0
    jne  .gte_u
    mov  rsi, s_setge
    jmp  emit_cstr
.gte_u:
    mov  rsi, s_setae
    jmp  emit_cstr

; emit_syscall_pop(rdi = arg index) -> emits "    pop <reg>\n"
; Maps index -> register of the x64 syscall convention.
emit_syscall_pop:
    cmp  rdi, 0
    je   .p0
    cmp  rdi, 1
    je   .p1
    cmp  rdi, 2
    je   .p2
    cmp  rdi, 3
    je   .p3
    cmp  rdi, 4
    je   .p4
    cmp  rdi, 5
    je   .p5
    cmp  rdi, 6
    je   .p6
    ret
.p0:
    mov  rsi, s_pop_rax
    jmp  emit_cstr
.p1:
    mov  rsi, s_pop_rdi
    jmp  emit_cstr
.p2:
    mov  rsi, s_pop_rsi
    jmp  emit_cstr
.p3:
    mov  rsi, s_pop_rdx
    jmp  emit_cstr
.p4:
    mov  rsi, s_pop_r10
    jmp  emit_cstr
.p5:
    mov  rsi, s_pop_r8
    jmp  emit_cstr
.p6:
    mov  rsi, s_pop_r9
    jmp  emit_cstr

codegen_get_code:
    mov  rax, [rel cg_out]
    ret

codegen_get_code_size:
    mov  rax, [rel cg_ptr]
    sub  rax, [rel cg_out]
    ret

section .data
; RA_TRACE in kron_types.inc: nonzero writes the analysis into the .asm as
; comments. Zero -- the default -- leaves the output byte for byte as before.
ra_trace:  dd RA_TRACE
; RA_ENABLE: nonzero applies the allocation. Zero keeps every local in memory
; while still running the analysis -- the output is then what it was before.
ra_enable: dd RA_ENABLE
s_ra_reg0: db "rbx", 0
s_ra_reg1: db "r12", 0
s_ra_reg2: db "r13", 0
s_ra_reg3: db "r14", 0
s_ra_reg4: db "r15", 0
s_ra_ld:   db "    mov rax, ", 0
s_ra_ldrcx: db "    mov rcx, ", 0
s_ra_fld:   db "    movaps xmm0, ", 0      ; whole register: no merge, no false wait
s_ra_fx1:   db "    movaps xmm1, ", 0
s_ra_fx1m:  db "    movsd xmm1, [rbp-", 0
s_ra_fmov:  db "    movaps ", 0
s_ra_fxmm:  db ", xmm", 0
s_ra_fx0:   db ", xmm0", 10, 0
s_ra_xmm:   db "xmm", 0
s_ra_fsv1:  db "    movups [rbp-", 0
s_ra_frs1:  db "    movups ", 0
s_alu_ind:  db "    ", 0
s_alu_sp:   db " ", 0
s_alu_rax:  db "rax", 0
s_alu_cm:   db ", ", 0
s_alu_rrcx: db " rax, rcx", 10, 0
s_alu_add:  db "add", 0
s_alu_sub:  db "sub", 0
s_alu_imul: db "imul", 0
s_alu_and:  db "and", 0
s_alu_or:   db "or", 0
s_alu_xor:  db "xor", 0
s_alu_cmp:  db "cmp", 0
; indexed by ALU_*: keep in the same order as the defines
s_alu_tab:  dq s_alu_add, s_alu_sub, s_alu_imul, s_alu_and
            dq s_alu_or, s_alu_xor, s_alu_cmp
s_jcc_e:   db "    je ", 0
s_jcc_ne:  db "    jne ", 0
s_jcc_l:   db "    jl ", 0
s_jcc_ge:  db "    jge ", 0
s_jcc_g:   db "    jg ", 0
s_jcc_le:  db "    jle ", 0
s_jcc_b:   db "    jb ", 0
s_jcc_ae:  db "    jae ", 0
s_jcc_a:   db "    ja ", 0
s_jcc_be:  db "    jbe ", 0
; indexed by CC_*: keep in the same order as the defines
s_jcc_tab: dq s_jcc_e, s_jcc_ne, s_jcc_l, s_jcc_ge, s_jcc_g
           dq s_jcc_le, s_jcc_b, s_jcc_ae, s_jcc_a, s_jcc_be
s_movrcxmem: db "    mov rcx, [rbp-", 0
s_movrcx_imm: db "    mov rcx, ", 0
s_ra_st1:  db "    mov ", 0
s_ra_st2:  db ", rax", 10, 0
s_ra_sv1:  db "    mov [rbp-", 0
s_ra_sv2:  db "], ", 0
s_ra_rs2:  db ", [rbp-", 0
s_ra_arrow: db "  -> ", 0
s_ra_mem:  db "memory", 0
s_ra_skip: db "    ; ra: not allocated", 10, 0
s_ra_c1:   db "    ; ra cand ", 0
s_ra_c2:   db " = [rbp-", 0
s_ra_c3:   db "]", 0
s_ra_x:    db "  excluded", 0
s_ra_b1:   db "    ; ra blk ", 0
s_ra_in:   db "  in=", 0
s_ra_out:  db "  out=", 0
s_ra_use:  db "  use=", 0
s_ra_def:  db "  def=", 0
s_ra_s:    db "  succ=", 0
s_ra_cm:   db ",", 0
s_ra_none: db "-", 0
main_lbl:  db "main:", 10, 0
kmain_lbl: db "kmain:", 10, 0
start_lbl: db "_start:", 10, 0
; Linux main ends through __main_exit, as on Windows: a failure nobody checked
; is printed there before exit_group. A bare exit syscall here skipped it.
s_retexit: db "    mov rcx, rax", 10, "    call __main_exit", 10, 0
s_rethalt: db "    cli", 10, "    hlt", 10, 0






