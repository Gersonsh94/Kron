%line 11+1 jpx.asm
[bits 64]
[default rel]

%line 39+1 jpx.asm
[section .bss]
 jpx_buf resb 2097152
 jpx_len resq 1
 jpx_kind resq 1
 jpx_ring resq 1
 jpx_caps resq 1
 jpx_strpool resb 4096
 jpx_strlen resq 1

[section .data]
 sec_name_code: db ".code", 0
 sec_name_data: db ".data", 0
 sec_name_bss: db ".bss", 0

[section .text]

[global jpx_init]
[global jpx_set_kind]
[global jpx_set_ring]
[global jpx_set_caps]
[global jpx_build]
[global jpx_get_image]
[global jpx_get_size]

[extern jasm_get_code]
[extern jasm_get_code_size]
[extern jasm_get_data]
[extern jasm_get_data_size]
[extern jasm_get_bss_size]


jpx_init:
 mov qword [rel jpx_len], 0
 mov qword [rel jpx_kind], 3
 mov qword [rel jpx_ring], 3
 mov qword [rel jpx_caps], 0
 mov qword [rel jpx_strlen], 1
 mov byte [rel jpx_strpool], 0
 ret

jpx_set_kind:
 mov [rel jpx_kind], rcx
 ret
jpx_set_ring:
 mov [rel jpx_ring], rcx
 ret
jpx_set_caps:
 mov [rel jpx_caps], rcx
 ret
jpx_get_image:
 lea rax, [rel jpx_buf]
 ret
jpx_get_size:
 mov rax, [rel jpx_len]
 ret




jpx_add_string:
 push rsi
 push rdi
 mov rsi, rcx
 mov rax, [rel jpx_strlen]
 lea rdi, [rel jpx_strpool]
 add rdi, rax
 push rax
.l:
 mov cl, [rsi]
 mov [rdi], cl
 test cl, cl
 jz .d
 inc rsi
 inc rdi
 jmp .l
.d:
 inc rdi
 lea rcx, [rel jpx_strpool]
 sub rdi, rcx
 mov [rel jpx_strlen], rdi
 pop rax
 pop rdi
 pop rsi
 ret







jpx_build:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 push r14
 push r15

 lea rbx, [rel jpx_buf]


 xor rcx, rcx
.clr:
 cmp rcx, 128
 jae .clr_done
 mov byte [rbx + rcx], 0
 inc rcx
 jmp .clr
.clr_done:


 lea rcx, [rel sec_name_code]
 call jpx_add_string
 mov r12, rax
 lea rcx, [rel sec_name_data]
 call jpx_add_string
 mov r13, rax
 lea rcx, [rel sec_name_bss]
 call jpx_add_string
 mov r14, rax



 mov rsi, 128
 mov rdi, rsi
 add rdi, 32 * 3
 mov r15, rdi
 add r15, [rel jpx_strlen]

 add r15, 15
 and r15, -16


 mov dword [rbx + 0x00], 0x2158504A
 mov word [rbx + 0x04], 1
 mov word [rbx + 0x06], 128
 mov word [rbx + 0x08], 1
 mov rax, [rel jpx_kind]
 mov word [rbx + 0x0A], ax
 mov rax, [rel jpx_ring]
 mov word [rbx + 0x0C], ax
 mov word [rbx + 0x0E], 0


 mov qword [rbx + 0x10], 0x1000
 mov qword [rbx + 0x18], 0x400000
 mov qword [rbx + 0x28], 0x100000
 mov qword [rbx + 0x30], 0

 mov dword [rbx + 0x38], 3
 mov dword [rbx + 0x3C], 128
 mov dword [rbx + 0x40], 0
 mov dword [rbx + 0x44], 0
 mov dword [rbx + 0x48], 0
 mov dword [rbx + 0x4C], 0
 mov eax, edi
 mov dword [rbx + 0x50], eax
 mov rax, [rel jpx_strlen]
 mov dword [rbx + 0x54], eax
 mov rax, [rel jpx_caps]
 mov qword [rbx + 0x68], rax


 lea rsi, [rel jpx_strpool]
 lea rdi, [rbx + 128 + 32 * 3]
 mov rcx, [rel jpx_strlen]
.cpstr:
 test rcx, rcx
 jz .cpstr_done
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec rcx
 jmp .cpstr
.cpstr_done:


 lea rdi, [rbx + 128]
 mov eax, r12d
 mov dword [rdi + 0x00], eax
 mov dword [rdi + 0x04], 1
 mov qword [rdi + 0x08], 0x1000
 mov eax, r15d
 mov dword [rdi + 0x10], eax
 call jasm_get_code_size
 mov dword [rdi + 0x14], eax
 mov dword [rdi + 0x18], eax
 mov dword [rdi + 0x1C], 5
 mov r8d, eax


 lea rdi, [rbx + 128 + 32]
 mov eax, r13d
 mov dword [rdi + 0x00], eax
 mov dword [rdi + 0x04], 2
 mov eax, r8d
 add eax, 15
 and eax, -16
 mov r9d, eax
 add eax, 0x1000
 mov qword [rdi + 0x08], rax
 mov eax, r15d
 add eax, r9d
 mov dword [rdi + 0x10], eax
 call jasm_get_data_size
 mov dword [rdi + 0x14], eax
 mov dword [rdi + 0x18], eax
 mov dword [rdi + 0x1C], 3
 mov r10d, eax


 lea rdi, [rbx + 128 + 32 * 2]
 mov eax, r14d
 mov dword [rdi + 0x00], eax
 mov dword [rdi + 0x04], 3
 mov eax, r9d
 add eax, r10d
 add eax, 15
 and eax, -16
 add eax, 0x1000
 mov qword [rdi + 0x08], rax
 mov dword [rdi + 0x10], 0
 mov dword [rdi + 0x14], 0
 call jasm_get_bss_size
 mov dword [rdi + 0x18], eax
 mov dword [rdi + 0x1C], 3


 call jasm_get_code
 mov rsi, rax
 lea rdi, [rbx + r15]
 call jasm_get_code_size
 mov rcx, rax
.cpcode:
 test rcx, rcx
 jz .cpcode_done
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec rcx
 jmp .cpcode
.cpcode_done:


 lea rdi, [rbx + r15]
 add rdi, r9
 call jasm_get_data
 mov rsi, rax
 call jasm_get_data_size
 mov rcx, rax
.cpdata:
 test rcx, rcx
 jz .cpdata_done
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec rcx
 jmp .cpdata
.cpdata_done:


 mov rax, r15
 add rax, r9
 add rax, r10
 add rax, 15
 and rax, -16
 mov [rel jpx_len], rax


 call jpx_sign

 mov rax, [rel jpx_len]
 pop r15
 pop r14
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret







jpx_sign:
 push rbx
 push rsi
 push rdi
 push r12

 lea rbx, [rel jpx_buf]
 mov r12, [rel jpx_len]


 mov eax, r12d
 mov dword [rbx + 0x58], eax
 mov dword [rbx + 0x5C], 48


 mov rax, 0xCBF29CE484222325
 xor rcx, rcx
.hash:
 cmp rcx, r12
 jae .hash_done
 movzx edx, byte [rbx + rcx]
 xor rax, rdx
 mov rsi, 0x100000001B3
 imul rax, rsi
 inc rcx
 jmp .hash
.hash_done:
 mov rsi, rax

 lea rdi, [rbx + r12]
 mov dword [rdi + 0x00], 0x4749534A
 mov word [rdi + 0x04], 1
 mov word [rdi + 0x06], 0
 mov dword [rdi + 0x08], 8
 mov dword [rdi + 0x0C], 0
 mov [rdi + 0x10], r12
 mov [rdi + 0x18], rsi
 mov qword [rdi + 0x20], 0
 mov qword [rdi + 0x28], 0

 add r12, 48
 mov [rel jpx_len], r12

 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret
