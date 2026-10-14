; ==============================================================================
; KRON RUNTIME
; File: runtime/runtime.asm
; Architecture: x86-64 NASM - direct Linux syscalls
; No libc, no dependencies
; Includes: I/O, memory, strings, Kron types, math
; ==============================================================================

; --- SYSCALL NUMBERS (Linux x86-64) ---
%define SYS_READ        0
%define SYS_WRITE       1
%define SYS_OPEN        2
%define SYS_CLOSE       3
%define SYS_MMAP        9
%define SYS_MUNMAP      11
%define SYS_EXIT        60
%define SYS_EXIT_GROUP  231
%define SYS_BRTIME      228     ; clock_gettime
%define SYS_BRK         12

; --- FILE DESCRIPTORS ---
%define STDIN           0
%define STDOUT          1
%define STDERR          2

; --- MMAP FLAGS ---
%define PROT_READ       0x1
%define PROT_WRITE      0x2
%define PROT_EXEC       0x4
%define MAP_PRIVATE     0x2
%define MAP_ANONYMOUS   0x20
%define MAP_FAILED      -1

; --- KRON HEAP ---
%define HEAP_INITIAL_SIZE   (4 * 1024 * 1024)    ; 4 MB initial
%define HEAP_ALIGN          16

section .data
    ; Buffers for number conversion
    int_buf         times 32 db 0
    float_buf       times 64 db 0

    ; Runtime error messages
    err_oom         db "Kron Runtime: Out of memory", 10
    err_oom_len     equ $ - err_oom
    err_null_deref  db "Kron Runtime: Null dereference", 10
    err_null_len    equ $ - err_null_deref
    err_div_zero    db "Kron Runtime: Division by zero", 10
    err_div_len     equ $ - err_div_zero
    err_index_oob   db "Kron Runtime: Index out of bounds", 10
    err_index_len   equ $ - err_index_oob
    err_type        db "Kron Runtime: Type mismatch", 10
    err_type_len    equ $ - err_type

    ; true/false strings for print
    str_true        db "true"
    str_true_len    equ $ - str_true
    str_false       db "false"
    str_false_len   equ $ - str_false
    str_null        db "null"
    str_null_len    equ $ - str_null
    newline         db 10
    space           db 32

section .bss
    ; Runtime heap
    heap_base       resq 1
    heap_ptr        resq 1
    heap_end        resq 1

    ; Value stack for the stack VM
    val_stack       resq 1
    val_sp          resq 1
    val_stack_end   resq 1
    VAL_STACK_SIZE  equ (64 * 1024)   ; 64 KB

section .text
    global jup_runtime_init
    global __kron_runtime_init
    global __kron_runtime_exit
    global __kron_print_i64
    global __kron_print_f64
    global __kron_print_str
    global __kron_print_bool
    global __kron_print_newline
    global __kron_alloc
    global __kron_free
    global __kron_memcpy
    global __kron_memset
    global __kron_strlen
    global __kron_strcmp
    global __kron_strcat
    global __kron_panic
    global __kron_div_check
    global __kron_bounds_check
    global __kron_read_i64
    global __kron_read_str
    global __kron_write_raw
    global __kron_itoa
    global __kron_ftoa
    global __kron_atoi
    global sys_write
    global sys_read
    global sys_exit

; ==============================================================================
; jup_runtime_init() / __kron_runtime_init()
; Initialises the heap and the value stack
; Returns: rax = 0 OK, -1 on error
; ==============================================================================
jup_runtime_init:
__kron_runtime_init:
    ; Allocate the heap with mmap
    mov     rax, SYS_MMAP
    xor     rdi, rdi                ; addr = NULL (kernel chooses)
    mov     rsi, HEAP_INITIAL_SIZE
    mov     rdx, PROT_READ | PROT_WRITE
    mov     r10, MAP_PRIVATE | MAP_ANONYMOUS
    mov     r8, -1                  ; fd = -1 (anonymous)
    xor     r9, r9                  ; offset = 0
    syscall

    cmp     rax, -1
    je      .mmap_fail

    mov     [rel heap_base], rax
    mov     [rel heap_ptr], rax
    mov     rcx, rax
    add     rcx, HEAP_INITIAL_SIZE
    mov     [rel heap_end], rcx

    ; Allocate the value stack
    mov     rax, SYS_MMAP
    xor     rdi, rdi
    mov     rsi, VAL_STACK_SIZE
    mov     rdx, PROT_READ | PROT_WRITE
    mov     r10, MAP_PRIVATE | MAP_ANONYMOUS
    mov     r8, -1
    xor     r9, r9
    syscall

    cmp     rax, -1
    je      .mmap_fail

    mov     [rel val_stack], rax
    mov     [rel val_sp], rax
    add     rax, VAL_STACK_SIZE
    mov     [rel val_stack_end], rax

    xor     eax, eax
    ret

.mmap_fail:
    mov     rax, -1
    ret

; ==============================================================================
; __kron_runtime_exit(code)
;   rdi = exit code
; ==============================================================================
__kron_runtime_exit:
    mov     rax, SYS_EXIT_GROUP
    syscall
    ; Does not return

; ==============================================================================
; __kron_alloc(size)
;   rdi = bytes to allocate (aligned to 16)
; Returns: rax = ptr, 0 when out of memory
; Simple bump allocator - fast, O(1)
; ==============================================================================
__kron_alloc:
    ; Align size to 16 bytes
    add     rdi, 15
    and     rdi, ~15

    mov     rax, [rel heap_ptr]
    mov     rcx, rax
    add     rcx, rdi

    ; Check there is room
    cmp     rcx, [rel heap_end]
    jg      .try_grow

    mov     [rel heap_ptr], rcx
    ret

.try_grow:
    ; Try to extend the heap with another mmap
    ; For now: out of memory
    xor     eax, eax
    ret

; ==============================================================================
; __kron_free(ptr)
; With a bump allocator, free is a no-op
; (The GC handles it periodically)
; ==============================================================================
__kron_free:
    ret

; ==============================================================================
; __kron_print_i64(value)
;   rdi = i64 value to print
; ==============================================================================
__kron_print_i64:
    push    rbx
    push    r12

    mov     r12, rdi

    ; If negative, print '-'
    test    r12, r12
    jns     .positive

    push    r12
    mov     rdi, STDOUT
    lea     rsi, [rel space]
    mov     rdx, 1
    mov     rsi, '-'
    push    rsi
    mov     rsi, rsp
    mov     rax, SYS_WRITE
    mov     rdx, 1
    syscall
    pop     rsi
    pop     r12
    neg     r12

.positive:
    ; Convert to a string
    mov     rdi, r12
    lea     rsi, [rel int_buf]
    call    __kron_itoa

    ; Print
    mov     rdi, STDOUT
    lea     rsi, [rel int_buf]
    mov     rdx, rax        ; length returned by itoa
    mov     rax, SYS_WRITE
    syscall

    pop     r12
    pop     rbx
    ret

; ==============================================================================
; __kron_print_str(ptr, len)
; rdi = pointer to the string
; rsi = length
; ==============================================================================
__kron_print_str:
    push    rbx
    push    r12

    mov     rbx, rdi
    mov     r12, rsi

    ; If len = 0, work it out with strlen
    test    r12, r12
    jnz     .has_len
    mov     rdi, rbx
    call    __kron_strlen
    mov     r12, rax

.has_len:
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, rbx
    mov     rdx, r12
    syscall

    pop     r12
    pop     rbx
    ret

; ==============================================================================
; __kron_print_bool(value)
;   rdi = 0 false, !=0 true
; ==============================================================================
__kron_print_bool:
    test    rdi, rdi
    jz      .false

    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    lea     rsi, [rel str_true]
    mov     rdx, str_true_len
    syscall
    ret

.false:
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    lea     rsi, [rel str_false]
    mov     rdx, str_false_len
    syscall
    ret

; ==============================================================================
; __kron_print_f64(xmm0 = value)
; Prints a double
; ==============================================================================
__kron_print_f64:
    push    rbx

    lea     rdi, [rel float_buf]
    call    __kron_ftoa

    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    lea     rsi, [rel float_buf]
    mov     rdx, rax
    syscall

    pop     rbx
    ret

; ==============================================================================
; __kron_print_newline()
; ==============================================================================
__kron_print_newline:
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    lea     rsi, [rel newline]
    mov     rdx, 1
    syscall
    ret

; ==============================================================================
; __kron_itoa(value, buf)
; rdi = u64 value
; rsi = output buffer
; Returns: rax = length of the string
; ==============================================================================
__kron_itoa:
    push    rbx
    push    r12
    push    r13
    push    r14

    mov     r12, rdi    ; value
    mov     r13, rsi    ; buf

    ; Special case: 0
    test    r12, r12
    jnz     .nonzero

    mov     byte [r13], '0'
    mov     rax, 1
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

.nonzero:
    ; Convert the digits in reverse order
    lea     r14, [r13 + 20]     ; point at the end of the temp buffer
    mov     rbx, r14            ; save the end
    xor     r8, r8              ; digit counter

.digit_loop:
    test    r12, r12
    jz      .reverse

    xor     rdx, rdx
    mov     rax, r12
    mov     rcx, 10
    div     rcx             ; rax = quotient, rdx = remainder

    add     dl, '0'
    dec     r14
    mov     [r14], dl
    mov     r12, rax
    inc     r8
    jmp     .digit_loop

.reverse:
    ; Copy to the output buffer from r14 up to rbx
    mov     rdi, r13    ; destination
    mov     rsi, r14    ; source
    mov     rcx, r8     ; length
    rep     movsb

    mov     rax, r8     ; length

    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

; ==============================================================================
; __kron_ftoa(value_in_xmm0, buf)
;   xmm0 = double
;   rdi  = buffer
; Returns: rax = length
; Simplified implementation
; ==============================================================================
__kron_ftoa:
    push    rbx
    push    r12
    push    r13

    mov     r12, rdi    ; buf

    ; Extract the integer part
    cvttsd2si   rbx, xmm0

    ; Print the integer part
    mov     rdi, rbx
    mov     rsi, r12
    call    __kron_itoa
    mov     r13, rax    ; length of the integer part

    ; Add the decimal point
    add     r12, r13
    mov     byte [r12], '.'
    inc     r12
    inc     r13

    ; Take the decimal part (up to 6 digits)
    cvtsi2sd    xmm1, rbx
    subsd       xmm0, xmm1   ; fraction = original - integer

    ; Multiply by 1000000 and truncate
    mov     rax, 1000000
    cvtsi2sd    xmm2, rax
    mulsd       xmm0, xmm2
    cvttsd2si   rbx, xmm0

    ; Print 6 digits of the fraction
    mov     rdi, rbx
    mov     rsi, r12
    call    __kron_itoa
    add     r13, rax

    mov     rax, r13

    pop     r13
    pop     r12
    pop     rbx
    ret

; ==============================================================================
; __kron_atoi(str_ptr, str_len)
;   rdi = ptr
;   rsi = len
; Returns: rax = value
; ==============================================================================
__kron_atoi:
    xor     eax, eax
    test    rsi, rsi
    jz      .done
.loop:
    movzx   ecx, byte [rdi]
    cmp     cl, '0'
    jl      .done
    cmp     cl, '9'
    jg      .done
    imul    rax, 10
    sub     ecx, '0'
    add     rax, rcx
    inc     rdi
    dec     rsi
    jnz     .loop
.done:
    ret

; ==============================================================================
; __kron_strlen(str_ptr)
;   rdi = ptr (null-terminated)
; Returns: rax = length
; ==============================================================================
__kron_strlen:
    xor     eax, eax
.loop:
    cmp     byte [rdi + rax], 0
    je      .done
    inc     rax
    jmp     .loop
.done:
    ret

; ==============================================================================
; __kron_strcmp(a, b)
;   rdi = ptr a
;   rsi = ptr b
; Returns: rax = 0 if equal, <0 if a<b, >0 if a>b
; ==============================================================================
__kron_strcmp:
.loop:
    movzx   eax, byte [rdi]
    movzx   ecx, byte [rsi]
    cmp     al, cl
    jne     .diff
    test    al, al
    jz      .equal
    inc     rdi
    inc     rsi
    jmp     .loop
.equal:
    xor     eax, eax
    ret
.diff:
    sub     eax, ecx
    ret

; ==============================================================================
; __kron_memcpy(dst, src, n)
;   rdi = dst
;   rsi = src
;   rdx = n
; ==============================================================================
__kron_memcpy:
    push    rcx
    mov     rcx, rdx
    rep     movsb
    pop     rcx
    ret

; ==============================================================================
; __kron_memset(dst, val, n)
;   rdi = dst
;   rsi = val (byte)
;   rdx = n
; ==============================================================================
__kron_memset:
    push    rcx
    push    rax
    mov     rax, rsi
    mov     rcx, rdx
    rep     stosb
    pop     rax
    pop     rcx
    ret

; ==============================================================================
; __kron_strcat(dst, src) - concatenate strings
;   rdi = dst (preallocated with enough room)
;   rsi = src
; ==============================================================================
__kron_strcat:
    push    rdi
    ; go to the end of dst
    call    __kron_strlen
    add     rdi, rax
    ; copy src
    mov     rax, rsi
.copy:
    movzx   ecx, byte [rax]
    mov     [rdi], cl
    inc     rdi
    inc     rax
    test    cl, cl
    jnz     .copy
    pop     rdi
    ret

; ==============================================================================
; __kron_panic(msg_ptr, msg_len)
; Prints an error and ends the program
; ==============================================================================
__kron_panic:
    mov     rax, SYS_WRITE
    mov     rdx, rsi
    mov     rsi, rdi
    mov     rdi, STDERR
    syscall

    mov     rax, SYS_EXIT_GROUP
    mov     rdi, 1
    syscall

; ==============================================================================
; __kron_div_check(divisor)
;   rdi = divisor
; If it is 0, panic
; ==============================================================================
__kron_div_check:
    test    rdi, rdi
    jnz     .ok
    mov     rdi, STDERR
    lea     rsi, [rel err_div_zero]
    mov     rdx, err_div_len
    mov     rax, SYS_WRITE
    syscall
    mov     rax, SYS_EXIT_GROUP
    mov     rdi, 1
    syscall
.ok:
    ret

; ==============================================================================
; __kron_bounds_check(index, length)
;   rdi = index
;   rsi = length
; ==============================================================================
__kron_bounds_check:
    cmp     rdi, rsi
    jl      .ok
    mov     rax, SYS_WRITE
    mov     rdi, STDERR
    lea     rsi, [rel err_index_oob]
    mov     rdx, err_index_len
    syscall
    mov     rax, SYS_EXIT_GROUP
    mov     rdi, 1
    syscall
.ok:
    ret

; ==============================================================================
; __kron_read_i64() - read an integer from stdin
; Returns: rax = value read
; ==============================================================================
__kron_read_i64:
    push    rbx
    sub     rsp, 32

    ; Read up to 21 bytes
    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rsi, rsp
    mov     rdx, 21
    syscall

    ; Convert to an integer
    mov     rdi, rsp
    mov     rsi, rax
    call    __kron_atoi

    add     rsp, 32
    pop     rbx
    ret

; ==============================================================================
; __kron_read_str(buf, max_len)
; rdi = target buffer
; rsi = max length
; Returns: rax = bytes read
; ==============================================================================
__kron_read_str:
    push    rbx
    push    r12

    mov     rbx, rdi
    mov     r12, rsi

    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rsi, rbx
    mov     rdx, r12
    syscall

    ; Remove the newline if there is one
    test    rax, rax
    jz      .done
    lea     rcx, [rbx + rax - 1]
    cmp     byte [rcx], 10
    jne     .done
    dec     rax
    mov     byte [rcx], 0

.done:
    pop     r12
    pop     rbx
    ret

; ==============================================================================
; __kron_write_raw(buf, len) - write straight to stdout
;   rdi = buffer
; rsi = length
; ==============================================================================
__kron_write_raw:
    mov     rdx, rsi
    mov     rsi, rdi
    mov     rdi, STDOUT
    mov     rax, SYS_WRITE
    syscall
    ret

; ==============================================================================
; sys_write(fd, buf, len) - direct write syscall
; ==============================================================================
sys_write:
    mov     rax, SYS_WRITE
    syscall
    ret

; ==============================================================================
; sys_read(fd, buf, len)
; ==============================================================================
sys_read:
    mov     rax, SYS_READ
    syscall
    ret

; ==============================================================================
; sys_exit(code)
; ==============================================================================
sys_exit:
    mov     rax, SYS_EXIT_GROUP
    syscall

; ==============================================================================
; HARDWARE RUNTIME STUBS
; Stub functions for the Kron hardware blocks
; On real hardware these call the kernel's drivers
; In simulation: they print what they would do
; ==============================================================================

    global __kron_hw_quantum_init
    global __kron_hw_quantum_gate
    global __kron_hw_dma_transfer
    global __kron_hw_interrupt_register
    global __kron_hw_gpu_submit
    global __kron_hw_physics_tick
    global __kron_hw_orbital_route
    global __kron_hw_plasma_ignite
    global __kron_hw_neuromorphic_fire

; Quantum circuit init
__kron_hw_quantum_init:
    ; rdi = number of qubits
    ; Stub: return handle 1
    mov     rax, 1
    ret

; Quantum gate application
__kron_hw_quantum_gate:
    ; rdi = gate_type, rsi = qubit_target
    xor     eax, eax
    ret

; DMA transfer
__kron_hw_dma_transfer:
    ; rdi = src_addr, rsi = dst_addr, rdx = size
    ; On real hardware: program the DMA controller
    ; Stub: memcpy
    push    rbx
    mov     rbx, rdx
    call    __kron_memcpy
    mov     rax, rbx
    pop     rbx
    ret

; Interrupt register
__kron_hw_interrupt_register:
    ; rdi = vector_id, rsi = handler_ptr
    ; Stub: record it in a table
    xor     eax, eax
    ret

; GPU command submit
__kron_hw_gpu_submit:
    ; rdi = command_list_ptr, rsi = priority
    xor     eax, eax
    ret

; Physics world tick
__kron_hw_physics_tick:
    ; rdi = world_ptr, rsi = delta_time (f64 bits)
    xor     eax, eax
    ret

; Orbital routing
__kron_hw_orbital_route:
    ; rdi = packet_ptr, rsi = target_norad
    xor     eax, eax
    ret

; Plasma ignition
__kron_hw_plasma_ignite:
    ; rdi = reactor_handle
    mov     rax, 1  ; success
    ret

; Neuromorphic axon fire
__kron_hw_neuromorphic_fire:
    ; rdi = axon_id, rsi = intensity (f64 bits)
    xor     eax, eax
    ret
