%line 38+1 runtime\runtime.asm
[section .data]

 int_buf times 32 db 0
 float_buf times 64 db 0


 err_oom db "Jupiter Runtime: Out of memory", 10
 err_oom_len equ $ - err_oom
 err_null_deref db "Jupiter Runtime: Null dereference", 10
 err_null_len equ $ - err_null_deref
 err_div_zero db "Jupiter Runtime: Division by zero", 10
 err_div_len equ $ - err_div_zero
 err_index_oob db "Jupiter Runtime: Index out of bounds", 10
 err_index_len equ $ - err_index_oob
 err_type db "Jupiter Runtime: Type mismatch", 10
 err_type_len equ $ - err_type


 str_true db "true"
 str_true_len equ $ - str_true
 str_false db "false"
 str_false_len equ $ - str_false
 str_null db "null"
 str_null_len equ $ - str_null
 newline db 10
 space db 32

[section .bss]

 heap_base resq 1
 heap_ptr resq 1
 heap_end resq 1


 val_stack resq 1
 val_sp resq 1
 val_stack_end resq 1
 VAL_STACK_SIZE equ (64 * 1024)

[section .text]
[global jup_runtime_init]
[global __jupiter_runtime_init]
[global __jupiter_runtime_exit]
[global __jupiter_print_i64]
[global __jupiter_print_f64]
[global __jupiter_print_str]
[global __jupiter_print_bool]
[global __jupiter_print_newline]
[global __jupiter_alloc]
[global __jupiter_free]
[global __jupiter_memcpy]
[global __jupiter_memset]
[global __jupiter_strlen]
[global __jupiter_strcmp]
[global __jupiter_strcat]
[global __jupiter_panic]
[global __jupiter_div_check]
[global __jupiter_bounds_check]
[global __jupiter_read_i64]
[global __jupiter_read_str]
[global __jupiter_write_raw]
[global __jupiter_itoa]
[global __jupiter_ftoa]
[global __jupiter_atoi]
[global sys_write]
[global sys_read]
[global sys_exit]






jup_runtime_init:
__jupiter_runtime_init:

 mov rax, 9
 xor rdi, rdi
 mov rsi, (4 * 1024 * 1024)
 mov rdx, 0x1 | 0x2
 mov r10, 0x2 | 0x20
 mov r8, -1
 xor r9, r9
 syscall

 cmp rax, -1
 je .mmap_fail

 mov [rel heap_base], rax
 mov [rel heap_ptr], rax
 mov rcx, rax
 add rcx, (4 * 1024 * 1024)
 mov [rel heap_end], rcx


 mov rax, 9
 xor rdi, rdi
 mov rsi, VAL_STACK_SIZE
 mov rdx, 0x1 | 0x2
 mov r10, 0x2 | 0x20
 mov r8, -1
 xor r9, r9
 syscall

 cmp rax, -1
 je .mmap_fail

 mov [rel val_stack], rax
 mov [rel val_sp], rax
 add rax, VAL_STACK_SIZE
 mov [rel val_stack_end], rax

 xor eax, eax
 ret

.mmap_fail:
 mov rax, -1
 ret





__jupiter_runtime_exit:
 mov rax, 231
 syscall








__jupiter_alloc:

 add rdi, 15
 and rdi, ~15

 mov rax, [rel heap_ptr]
 mov rcx, rax
 add rcx, rdi


 cmp rcx, [rel heap_end]
 jg .try_grow

 mov [rel heap_ptr], rcx
 ret

.try_grow:


 xor eax, eax
 ret






__jupiter_free:
 ret





__jupiter_print_i64:
 push rbx
 push r12

 mov r12, rdi


 test r12, r12
 jns .positive

 push r12
 mov rdi, 1
 lea rsi, [rel space]
 mov rdx, 1
 mov rsi, '-'
 push rsi
 mov rsi, rsp
 mov rax, 1
 mov rdx, 1
 syscall
 pop rsi
 pop r12
 neg r12

.positive:

 mov rdi, r12
 lea rsi, [rel int_buf]
 call __jupiter_itoa


 mov rdi, 1
 lea rsi, [rel int_buf]
 mov rdx, rax
 mov rax, 1
 syscall

 pop r12
 pop rbx
 ret






__jupiter_print_str:
 push rbx
 push r12

 mov rbx, rdi
 mov r12, rsi


 test r12, r12
 jnz .has_len
 mov rdi, rbx
 call __jupiter_strlen
 mov r12, rax

.has_len:
 mov rax, 1
 mov rdi, 1
 mov rsi, rbx
 mov rdx, r12
 syscall

 pop r12
 pop rbx
 ret





__jupiter_print_bool:
 test rdi, rdi
 jz .false

 mov rax, 1
 mov rdi, 1
 lea rsi, [rel str_true]
 mov rdx, str_true_len
 syscall
 ret

.false:
 mov rax, 1
 mov rdi, 1
 lea rsi, [rel str_false]
 mov rdx, str_false_len
 syscall
 ret





__jupiter_print_f64:
 push rbx

 lea rdi, [rel float_buf]
 call __jupiter_ftoa

 mov rax, 1
 mov rdi, 1
 lea rsi, [rel float_buf]
 mov rdx, rax
 syscall

 pop rbx
 ret




__jupiter_print_newline:
 mov rax, 1
 mov rdi, 1
 lea rsi, [rel newline]
 mov rdx, 1
 syscall
 ret







__jupiter_itoa:
 push rbx
 push r12
 push r13
 push r14

 mov r12, rdi
 mov r13, rsi


 test r12, r12
 jnz .nonzero

 mov byte [r13], '0'
 mov rax, 1
 pop r14
 pop r13
 pop r12
 pop rbx
 ret

.nonzero:

 lea r14, [r13 + 20]
 mov rbx, r14
 xor r8, r8

.digit_loop:
 test r12, r12
 jz .reverse

 xor rdx, rdx
 mov rax, r12
 mov rcx, 10
 div rcx

 add dl, '0'
 dec r14
 mov [r14], dl
 mov r12, rax
 inc r8
 jmp .digit_loop

.reverse:

 mov rdi, r13
 mov rsi, r14
 mov rcx, r8
 rep movsb

 mov rax, r8

 pop r14
 pop r13
 pop r12
 pop rbx
 ret








__jupiter_ftoa:
 push rbx
 push r12
 push r13

 mov r12, rdi


 cvttsd2si rbx, xmm0


 mov rdi, rbx
 mov rsi, r12
 call __jupiter_itoa
 mov r13, rax


 add r12, r13
 mov byte [r12], '.'
 inc r12
 inc r13


 cvtsi2sd xmm1, rbx
 subsd xmm0, xmm1


 mov rax, 1000000
 cvtsi2sd xmm2, rax
 mulsd xmm0, xmm2
 cvttsd2si rbx, xmm0


 mov rdi, rbx
 mov rsi, r12
 call __jupiter_itoa
 add r13, rax

 mov rax, r13

 pop r13
 pop r12
 pop rbx
 ret







__jupiter_atoi:
 xor eax, eax
 test rsi, rsi
 jz .done
.loop:
 movzx ecx, byte [rdi]
 cmp cl, '0'
 jl .done
 cmp cl, '9'
 jg .done
 imul rax, 10
 sub ecx, '0'
 add rax, rcx
 inc rdi
 dec rsi
 jnz .loop
.done:
 ret






__jupiter_strlen:
 xor eax, eax
.loop:
 cmp byte [rdi + rax], 0
 je .done
 inc rax
 jmp .loop
.done:
 ret







__jupiter_strcmp:
.loop:
 movzx eax, byte [rdi]
 movzx ecx, byte [rsi]
 cmp al, cl
 jne .diff
 test al, al
 jz .equal
 inc rdi
 inc rsi
 jmp .loop
.equal:
 xor eax, eax
 ret
.diff:
 sub eax, ecx
 ret







__jupiter_memcpy:
 push rcx
 mov rcx, rdx
 rep movsb
 pop rcx
 ret







__jupiter_memset:
 push rcx
 push rax
 mov rax, rsi
 mov rcx, rdx
 rep stosb
 pop rax
 pop rcx
 ret






__jupiter_strcat:
 push rdi

 call __jupiter_strlen
 add rdi, rax

 mov rax, rsi
.copy:
 movzx ecx, byte [rax]
 mov [rdi], cl
 inc rdi
 inc rax
 test cl, cl
 jnz .copy
 pop rdi
 ret





__jupiter_panic:
 mov rax, 1
 mov rdx, rsi
 mov rsi, rdi
 mov rdi, 2
 syscall

 mov rax, 231
 mov rdi, 1
 syscall






__jupiter_div_check:
 test rdi, rdi
 jnz .ok
 mov rdi, 2
 lea rsi, [rel err_div_zero]
 mov rdx, err_div_len
 mov rax, 1
 syscall
 mov rax, 231
 mov rdi, 1
 syscall
.ok:
 ret






__jupiter_bounds_check:
 cmp rdi, rsi
 jl .ok
 mov rax, 1
 mov rdi, 2
 lea rsi, [rel err_index_oob]
 mov rdx, err_index_len
 syscall
 mov rax, 231
 mov rdi, 1
 syscall
.ok:
 ret





__jupiter_read_i64:
 push rbx
 sub rsp, 32


 mov rax, 0
 mov rdi, 0
 mov rsi, rsp
 mov rdx, 21
 syscall


 mov rdi, rsp
 mov rsi, rax
 call __jupiter_atoi

 add rsp, 32
 pop rbx
 ret







__jupiter_read_str:
 push rbx
 push r12

 mov rbx, rdi
 mov r12, rsi

 mov rax, 0
 mov rdi, 0
 mov rsi, rbx
 mov rdx, r12
 syscall


 test rax, rax
 jz .done
 lea rcx, [rbx + rax - 1]
 cmp byte [rcx], 10
 jne .done
 dec rax
 mov byte [rcx], 0

.done:
 pop r12
 pop rbx
 ret






__jupiter_write_raw:
 mov rdx, rsi
 mov rsi, rdi
 mov rdi, 1
 mov rax, 1
 syscall
 ret




sys_write:
 mov rax, 1
 syscall
 ret




sys_read:
 mov rax, 0
 syscall
 ret




sys_exit:
 mov rax, 231
 syscall








[global __jupiter_hw_quantum_init]
[global __jupiter_hw_quantum_gate]
[global __jupiter_hw_dma_transfer]
[global __jupiter_hw_interrupt_register]
[global __jupiter_hw_gpu_submit]
[global __jupiter_hw_physics_tick]
[global __jupiter_hw_orbital_route]
[global __jupiter_hw_plasma_ignite]
[global __jupiter_hw_neuromorphic_fire]


__jupiter_hw_quantum_init:


 mov rax, 1
 ret


__jupiter_hw_quantum_gate:

 xor eax, eax
 ret


__jupiter_hw_dma_transfer:



 push rbx
 mov rbx, rdx
 call __jupiter_memcpy
 mov rax, rbx
 pop rbx
 ret


__jupiter_hw_interrupt_register:


 xor eax, eax
 ret


__jupiter_hw_gpu_submit:

 xor eax, eax
 ret


__jupiter_hw_physics_tick:

 xor eax, eax
 ret


__jupiter_hw_orbital_route:

 xor eax, eax
 ret


__jupiter_hw_plasma_ignite:

 mov rax, 1
 ret


__jupiter_hw_neuromorphic_fire:

 xor eax, eax
 ret
