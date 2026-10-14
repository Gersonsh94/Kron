; ============================================================================
; test_scope.asm — do local labels belong to their enclosing routine?
;
; Two routines use the SAME local label names (.loop, .done). NASM scopes them
; to the preceding global label, so each jump stays inside its own routine.
; An assembler that treats them as global will make one of them jump into the
; other, and the printed numbers will be wrong.
;
;   nasm -f win64 -o ts.obj test_scope.asm
;   GoLink /fo ts_ref.exe /entry main /console ts.obj kernel32.dll
;   ts_ref.exe                     -> 5 then 28
;
;   kronc.exe test_scope.asm --assemble --pe
;   test_scope.exe                 -> must print the same
; ============================================================================

extern GetStdHandle
extern WriteFile
extern ExitProcess

section .bss
__numbuf: resb 32
__nwritten: resq 1

section .text

; ---- count_up(rcx = limit) -> rax = how many steps ----
; uses .loop and .done
count_up:
    push rbp
    mov rbp, rsp
    xor rax, rax
.loop:
    cmp rax, rcx
    jge .done
    inc rax
    jmp .loop
.done:
    mov rsp, rbp
    pop rbp
    ret

; ---- sum_to(rcx = limit) -> rax = 1+2+...+limit ----
; uses .loop and .done as well; with proper scoping these are different labels
sum_to:
    push rbp
    mov rbp, rsp
    push rbx
    xor rax, rax
    xor rbx, rbx
.loop:
    cmp rbx, rcx
    jge .done
    inc rbx
    add rax, rbx
    jmp .loop
.done:
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

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

    mov rcx, 5
    call count_up
    mov rcx, rax
    call __print_uint            ; expects 5

    mov rcx, 7
    call sum_to
    mov rcx, rax
    call __print_uint            ; expects 28

    xor rcx, rcx
    call ExitProcess
