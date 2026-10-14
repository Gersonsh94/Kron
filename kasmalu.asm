; ==============================================================================
; kasmalu.asm -- instructions the register allocator writes into programs.
;
; Run by RUNTESTS as an encoding test. Once locals live in rbx and r12-r15,
; the flush folds loads, the operation and the store into one instruction:
; 's = s + i' becomes 'add r12, rbx'. kasm has to assemble those when a
; program is built with kc.bat, so they are checked here against NASM.
;
; Constants are all above 127 on purpose: a small one has an 8-bit and a
; 32-bit encoding, both legal, and the two assemblers may pick differently.
; ==============================================================================
bits 64

section .text

; --- register to register, among the five and rax --------------------------
    add  r12, rbx
    sub  r13, r14
    and  r15, r12
    or   rbx, r13
    xor  r14, r15
    cmp  rbx, r13
    imul r12, rbx
    imul r15, r14
    add  rax, rbx
    add  rax, r12
    cmp  rax, r15

; --- register and a 32-bit immediate -----------------------------------------
    add  rbx, 1000000
    sub  r12, 1000000
    and  r13, 1000000
    or   r14, 1000000
    xor  r15, 1000000
    cmp  rbx, 1000000
    cmp  r12, 1000000
; 'add rax, imm' is left out: NASM uses the short accumulator form 05 id and
; kasm the general 81 /0. Both are correct and they differ in length -- the
; same trap as 'cmp eax, imm' in kasmchar.

; --- moves between rax, rcx and the five --------------------------------------
    mov  rax, rbx
    mov  rax, r12
    mov  rcx, r13
    mov  rcx, rbx
    mov  r14, rax
    mov  rbx, rax

; --- parameters: from the argument register to the one allocated ------------
    mov  rbx, rcx
    mov  r12, rdx
    mov  r13, r8
    mov  r14, r9
    mov  r15, r10
    mov  r12, rax

; --- calls: from the allocated register to the argument register -----------
    mov  rcx, rbx
    mov  rdx, r12
    mov  r8, r13
    mov  r9, r14
    mov  r10, r15
    mov  rax, r13
