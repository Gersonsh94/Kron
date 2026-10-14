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
section .bss
__numbuf: resb 32
__nwritten: resq 1
__chbuf: resb 2
__keybuf: resb 2
__nread: resq 1
__mousebuf: resb 32
__mousex_v: resq 1
__mousey_v: resq 1
section .text
__outname: db 'out.bmp', 0
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
    sub rsp, 40
    xorps xmm1, xmm1
    comisd xmm1, xmm0
    jbe .fnoneg
    movsd [rsp], xmm0
    mov rcx, 45
    call __print_char
    movsd xmm0, [rsp]
    mov rax, 0x8000000000000000
    movq xmm2, rax
    xorps xmm0, xmm2
.fnoneg:
    mov rax, 1000000
    cvtsi2sd xmm1, rax
    mulsd xmm0, xmm1
    cvtsd2si rax, xmm0
    xor rdx, rdx
    mov rbx, 1000000
    div rbx
    push rdx
    mov rcx, rax
    call __print_uint
    mov rcx, 46
    call __print_char
    pop rcx
    mov r10, 6
    call __print_pad
    mov rcx, 10
    call __print_char
    add rsp, 40
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
__mod_0_anon:
    db "acquire_domain",0
    db "anon",0
section .text
section .data
__mod_1_anon:
    db "acquire_domain",0
    db "anon",0
section .text
section .bss
__g_buf: resq 32
section .text
section .bss
__g_buf2: resq 32
section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    lea rax, [rel __g_buf]
    mov [rbp-8], rax
    lea rax, [rel __g_buf2]
    mov [rbp-16], rax
    mov rax, [rbp-8]
    push rax
    mov rax, 65
    push rax
    mov rax, 5
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mem_set
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, 5
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-8]
    movzx rax, byte [rax]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    mov rax, 8
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mem_zero
    add rsp, 32
    mov rax, [rbp-8]
    movzx rax, byte [rax]
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-8]
    push rax
section .data
.str3: db 104,101,108,108,111,0
section .text
    lea rax, [rel .str3]
    push rax
    mov rax, 6
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mem_copy
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call str_print_line
    add rsp, 32
section .data
.str4: db 97,98,99,0
section .text
    lea rax, [rel .str4]
    push rax
section .data
.str5: db 97,98,99,0
section .text
    lea rax, [rel .str5]
    push rax
    mov rax, 3
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mem_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str6: db 97,98,100,0
section .text
    lea rax, [rel .str6]
    push rax
section .data
.str7: db 97,98,99,0
section .text
    lea rax, [rel .str7]
    push rax
    mov rax, 3
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mem_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str8: db 104,101,108,108,111,0
section .text
    lea rax, [rel .str8]
    mov [rbp-24], rax
    mov rax, [rbp-24]
    push rax
    mov rax, 108
    push rax
    mov rax, 5
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mem_find_byte
    add rsp, 32
    push rax
    mov rax, [rbp-24]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str9: db 74,117,112,105,116,101,114,0
section .text
    lea rax, [rel .str9]
    push rax
    pop rcx
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str10: db 97,98,99,0
section .text
    lea rax, [rel .str10]
    push rax
section .data
.str11: db 97,98,99,0
section .text
    lea rax, [rel .str11]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_compare
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str12: db 97,98,99,0
section .text
    lea rax, [rel .str12]
    push rax
section .data
.str13: db 97,98,100,0
section .text
    lea rax, [rel .str13]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_equals
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str14: db 74,117,112,105,116,101,114,0
section .text
    lea rax, [rel .str14]
    push rax
section .data
.str15: db 74,117,112,0
section .text
    lea rax, [rel .str15]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_starts_with
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str16: db 74,117,112,105,116,101,114,0
section .text
    lea rax, [rel .str16]
    push rax
section .data
.str17: db 120,121,122,0
section .text
    lea rax, [rel .str17]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_starts_with
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-8]
    push rax
section .data
.str18: db 72,101,108,108,111,44,32,0
section .text
    lea rax, [rel .str18]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_copy
    add rsp, 32
    mov rax, [rbp-8]
    push rax
section .data
.str19: db 119,111,114,108,100,0
section .text
    lea rax, [rel .str19]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_concat
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call str_print_line
    add rsp, 32
    mov rax, [rbp-8]
    push rax
    pop rcx
    sub rsp, 32
    call str_length
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str20: db 97,98,99,100,101,102,0
section .text
    lea rax, [rel .str20]
    mov [rbp-32], rax
    mov rax, [rbp-32]
    push rax
    mov rax, 100
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_find_byte
    add rsp, 32
    push rax
    mov rax, [rbp-32]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    mov rax, 12345
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_from_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
    call str_print_line
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    mov rax, 0
    push rax
    mov rax, 987
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_from_int
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
    call str_print_line
    add rsp, 32
section .data
.str21: db 52,51,50,49,0
section .text
    lea rax, [rel .str21]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str22: db 45,55,55,0
section .text
    lea rax, [rel .str22]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
section .data
.str23: db 49,50,97,98,0
section .text
    lea rax, [rel .str23]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    mov rax, 60000
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call str_from_int
    add rsp, 32
    mov rax, [rbp-16]
    push rax
    pop rcx
    sub rsp, 32
    call str_to_int
    add rsp, 32
    mov rcx, rax
    sub rsp, 32
    call __print_int
    add rsp, 32
    mov rax, 0
    jmp .__ret_2
.__ret_2:
    mov rsp, rbp
    pop rbp
    mov rcx, rax
    sub rsp, 32
    call ExitProcess
