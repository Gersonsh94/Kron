; ============================================================================
; test_kasmfix.asm - three kasm encodings that were silently wrong
;
;   cmp/test byte [base + index +- N], imm   the N and the scale were dropped,
;                                            and test came out as add
;   mov [rel label + N], reg                 the +N was dropped
;   [rel label + N] with blanks or N*8       read as label + first digit
;   test dword [rel label], imm              encoded as add: it wrote to memory
;
; Each check prints 1 when the instruction did what it says. Built by kasm
; alone and run, like test_scope.
;
;   kronc.exe test_kasmfix.asm --assemble --pe
;   test_kasmfix.exe            -> 1 ten times
; ============================================================================

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .data
bytes:  db 10, 20, 30, 40, 50, 60, 70, 80
table:  dq 0, 0, 0, 0

section .bss
__numbuf: resb 32
__nwritten: resq 1

section .text

; ---- printing ----
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
    mov rcx, 10
    call __print_char
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
    mov [rel __numbuf], cl
    mov byte [rel __numbuf+1], 0
    lea rcx, [rel __numbuf]
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

main:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    push rbx
    push rsi

    ; cmp byte [base + index - 1], imm: bytes[3 - 1] is 30
    lea  rsi, [rel bytes]
    mov  rbx, 3
    xor  ecx, ecx
    cmp  byte [rsi + rbx - 1], 30
    jne  .c1
    mov  ecx, 1
.c1:
    call __print_uint

    ; with a plus: bytes[3 + 2] is 60
    xor  ecx, ecx
    cmp  byte [rsi + rbx + 2], 60
    jne  .c2
    mov  ecx, 1
.c2:
    call __print_uint

    ; with a scale: bytes[2*2] is 50
    mov  rbx, 2
    xor  ecx, ecx
    cmp  byte [rsi + rbx*2], 50
    jne  .c3
    mov  ecx, 1
.c3:
    call __print_uint

    ; test must not write: bytes[1] stays 20
    mov  rbx, 2
    test byte [rsi + rbx - 1], 4
    xor  ecx, ecx
    cmp  byte [rsi + 1], 20
    jne  .c4
    mov  ecx, 1
.c4:
    call __print_uint

    ; and test answers: 20 has bit 2 set
    xor  ecx, ecx
    test byte [rsi + rbx - 1], 4
    jz   .c5
    mov  ecx, 1
.c5:
    call __print_uint

    ; mov [rel label + N], reg writes at +N
    mov  rax, 77
    mov  [rel table + 16], rax
    lea  rsi, [rel table]
    xor  ecx, ecx
    cmp  qword [rsi + 16], 77
    jne  .c6
    mov  ecx, 1
.c6:
    call __print_uint

    ; blanks and a product in the addend: table + 3*8
    mov  rax, 99
    mov  qword [rel table + 3*8], rax
    xor  ecx, ecx
    cmp  qword [rsi + 24], 99
    jne  .c7
    mov  ecx, 1
.c7:
    call __print_uint

    ; and reading it back the same way
    xor  ecx, ecx
    mov  rax, [rel table + 3*8]
    cmp  rax, 99
    jne  .c8
    mov  ecx, 1
.c8:
    call __print_uint

    ; test dword [rel label], imm reads only: table+8 must stay 0
    mov  qword [rel table + 8], 0
    test dword [rel table + 8], 63
    xor  ecx, ecx
    cmp  qword [rel table + 8], 0
    jne  .c9
    mov  ecx, 1
.c9:
    call __print_uint

    ; and it answers: bit 1 of 6 is set
    mov  qword [rel table + 8], 6
    xor  ecx, ecx
    test dword [rel table + 8], 2
    jz   .c10
    mov  ecx, 1
.c10:
    call __print_uint

    pop  rsi
    pop  rbx
    xor  rcx, rcx
    call ExitProcess
