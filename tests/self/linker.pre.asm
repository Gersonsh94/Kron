%line 7+1 linker\linker.asm
[default rel]
[bits 64]

%line 8+1 include\win64_api.inc
[extern GetStdHandle]
[extern WriteFile]
[extern ReadFile]
[extern ExitProcess]
[extern CreateFileA]
[extern CloseHandle]
[extern GetFileSize]
[extern SetFilePointer]
[extern HeapAlloc]
[extern HeapFree]
[extern GetProcessHeap]
[extern GetCommandLineA]


%line 25+1 include\win64_api.inc


%line 34+1 include\win64_api.inc








%line 55+1 include\win64_api.inc





%line 65+1 include\win64_api.inc





%line 81+1 include\win64_api.inc





%line 97+1 include\win64_api.inc





%line 112+1 include\win64_api.inc




%line 119+1 include\win64_api.inc

%line 13+1 linker\linker.asm
[section .data]

 msg_link_start db "Jupiter Linker v1.0 iniciando...", 13, 10, 0
 msg_link_done db "Enlazado completado: ", 0
 msg_link_err db "Error de enlazado: ", 0
 msg_undef_sym db "Simbolo no definido: ", 0
 msg_dup_sym db "Simbolo duplicado: ", 0
 lnk_msg_newline db 13, 10, 0

 seg_text_name db ".text", 0
 seg_data_name db ".data", 0
 seg_bss_name db ".bss", 0

[section .bss]

 linker_state resb 256
 output_buf resb 16777216
 output_pos resq 1
 output_size resq 1
 global_symtab resb 131072
 global_symcount resq 1
 reloc_table resb 65536
 reloc_count resq 1
 seg_text_data resb 4194304
 seg_text_size resq 1
 seg_data_data resb 2097152
 seg_data_size resq 1
 seg_bss_size resq 1
 output_fd resq 1
 output_filename resb 512
 link_error_buf resb 512
 link_has_error resb 1

[section .text]

[global jup_linker_init]
[global jup_linker_run]
[global linker_get_error]

[extern jup_alloc]
[extern WriteFile]
[extern CreateFileA]
[extern CloseHandle]
[extern GetStdHandle]
[extern ExitProcess]




jup_linker_init:
 push rbp
 mov rbp, rsp
 sub rsp, 32


 xor rax, rax
 mov [rel link_has_error], al
 mov [rel output_pos], rax
 mov [rel global_symcount],rax
 mov [rel reloc_count], rax
 mov [rel seg_text_size], rax
 mov [rel seg_data_size], rax
 mov [rel seg_bss_size], rax


 lea rdi, [rel output_filename]
 mov rsi, rcx
 call strcpy_safe

 mov rax, 1
 add rsp, 32
 pop rbp
 ret




jup_linker_run:
 push rbp
 mov rbp, rsp
 sub rsp, 32
 push rbx
 push r12

 mov r12, rcx


 call linker_resolve_symbols
 test rax, rax
 jnz .error


 test r12, r12
 jz .emit_elf
 cmp r12, 1
 je .emit_pe
 jmp .emit_elf

.emit_elf:
 call emit_elf64_binary
 jmp .write

.emit_pe:
 call emit_pe32_binary

.write:
 test rax, rax
 jnz .error


 lea rcx, [rel output_filename]
 mov rdx, 0x40000000
 xor r8, r8
 xor r9, r9
 sub rsp, 24
 mov qword [rsp+32], 2
 mov qword [rsp+40], 0x80
 mov qword [rsp+48], 0
 call CreateFileA
 add rsp, 24

 cmp rax, -1
 je .file_error
 mov [rel output_fd], rax


 mov rcx, rax
 lea rdx, [rel output_buf]
 mov r8, [rel output_pos]
 xor r9, r9
 sub rsp, 40
 mov qword [rsp+32], 0
 call WriteFile
 add rsp, 40

 mov rcx, [rel output_fd]
 call CloseHandle

 xor rax, rax
 jmp .done

.file_error:
 mov rax, 2
 jmp .done

.error:
 mov byte [rel link_has_error], 1
 mov rax, 1

.done:
 pop r12
 pop rbx
 add rsp, 32
 pop rbp
 ret




linker_resolve_symbols:
 push rbp
 mov rbp, rsp
 push rbx
 push r12
 push r13

 mov r12, [rel reloc_count]
 xor rbx, rbx

.loop:
 cmp rbx, r12
 jge .done

 lea r13, [rel reloc_table]
 mov rax, rbx
 mov rcx, 24
 mul rcx
 add r13, rax


 lea rdi, [rel global_symtab]
 mov rsi, [rel global_symcount]
 lea rdx, [r13 + 8]
 call find_symbol

 test rax, rax
 jz .undefined

 mov rcx, [rax + 16]
 mov rdi, r13
 mov rsi, rcx
 call apply_reloc

 test rax, rax
 jnz .err

 inc rbx
 jmp .loop

.undefined:
 lea rdi, [rel link_error_buf]
 lea rsi, [rel msg_undef_sym]
 call strcpy_safe
 mov byte [rel link_has_error], 1
 mov rax, 7
 jmp .exit

.err:
 mov byte [rel link_has_error], 1
 mov rax, 8
 jmp .exit

.done:
 xor rax, rax
.exit:
 pop r13
 pop r12
 pop rbx
 pop rbp
 ret




apply_reloc:
 push rbp
 mov rbp, rsp
 push rbx
 push r12

 mov rbx, rdi
 mov r12, rsi

 movzx eax, byte [rbx + 16]

 cmp eax, 0
 je .abs64
 cmp eax, 1
 je .rel32
 cmp eax, 2
 je .abs32

 mov rax, 9
 jmp .exit

.abs64:
 mov rdi, [rbx + 0]
 mov [rdi], r12
 xor rax, rax
 jmp .exit

.rel32:
 mov rdi, [rbx + 0]
 mov rax, r12
 sub rax, rdi
 sub rax, 4
 mov [rdi], eax
 xor rax, rax
 jmp .exit

.abs32:
 mov rdi, [rbx + 0]
 mov eax, r12d
 mov [rdi], eax
 xor rax, rax

.exit:
 pop r12
 pop rbx
 pop rbp
 ret




emit_elf64_binary:
 push rbp
 mov rbp, rsp
 push rbx
 push r12
 push r13

 lea rbx, [rel output_buf]
 mov qword [rel output_pos], 0


 mov dword [rbx], 0x464C457F
 mov byte [rbx+4], 2
 mov byte [rbx+5], 1
 mov byte [rbx+6], 1
 mov byte [rbx+7], 0
 mov qword [rbx+8], 0

 mov word [rbx+16], 2
 mov word [rbx+18], 0x3E
 mov dword [rbx+20], 1
 mov qword [rbx+24], 0x401000
 mov qword [rbx+32], 64
 mov qword [rbx+40], 0
 mov dword [rbx+48], 0
 mov word [rbx+52], 64
 mov word [rbx+54], 56
 mov word [rbx+56], 2
 mov word [rbx+58], 64
 mov word [rbx+60], 0
 mov word [rbx+62], 0


 mov r12, 64 + 56*2
 mov r13, r12
 add r13, [rel seg_text_size]


 lea rdi, [rbx + 64]
 mov dword [rdi], 1
 mov dword [rdi+4], 5
 mov qword [rdi+8], r12
 mov rax, 0x400000
 add rax, r12
 mov qword [rdi+16], rax
 mov qword [rdi+24], rax
 mov rax, [rel seg_text_size]
 mov qword [rdi+32], rax
 mov qword [rdi+40], rax
 mov qword [rdi+48], 0x1000


 lea rdi, [rbx + 120]
 mov dword [rdi], 1
 mov dword [rdi+4], 6
 mov qword [rdi+8], r13
 mov rax, 0x600000
 add rax, r13
 mov qword [rdi+16], rax
 mov qword [rdi+24], rax
 mov rax, [rel seg_data_size]
 mov qword [rdi+32], rax
 mov qword [rdi+40], rax
 mov qword [rdi+48], 0x1000


 lea rdi, [rbx + r12]
 lea rsi, [rel seg_text_data]
 mov rcx, [rel seg_text_size]
 rep movsb


 lea rdi, [rbx + r13]
 lea rsi, [rel seg_data_data]
 mov rcx, [rel seg_data_size]
 rep movsb


 mov rax, r13
 add rax, [rel seg_data_size]
 mov [rel output_pos], rax

 xor rax, rax
 pop r13
 pop r12
 pop rbx
 pop rbp
 ret




emit_pe32_binary:
 push rbp
 mov rbp, rsp
 push rbx
 push r12
 push r13

 lea rbx, [rel output_buf]


 mov word [rbx], 0x5A4D
 mov dword [rbx+60], 0xB8


 lea rdi, [rbx + 0xB8]
 mov dword [rdi], 0x00004550


 mov word [rdi+4], 0x8664
 mov word [rdi+6], 2
 mov dword [rdi+8], 0
 mov dword [rdi+12], 0
 mov dword [rdi+16], 0
 mov word [rdi+20], 240
 mov word [rdi+22], 0x0022


 lea rdi, [rbx + 0xB8 + 24]
 mov word [rdi], 0x020B
 mov byte [rdi+2], 14
 mov byte [rdi+3], 0
 mov rax, [rel seg_text_size]
 mov dword [rdi+4], eax
 mov rax, [rel seg_data_size]
 mov dword [rdi+8], eax
 mov rax, [rel seg_bss_size]
 mov dword [rdi+12], eax
 mov dword [rdi+16], 0x1000
 mov dword [rdi+20], 0x1000
 mov qword [rdi+24], 0x140000000
 mov dword [rdi+32], 0x1000
 mov dword [rdi+36], 0x200
 mov word [rdi+40], 6
 mov word [rdi+42], 0
 mov word [rdi+48], 6
 mov word [rdi+50], 0
 mov dword [rdi+56], 0
 mov rax, [rel seg_text_size]
 add rax, [rel seg_data_size]
 add rax, [rel seg_bss_size]
 add rax, 0x3000
 mov dword [rdi+60], eax
 mov dword [rdi+64], 0x400
 mov dword [rdi+68], 0
 mov word [rdi+72], 3
 mov word [rdi+74], 0x8160


 lea rdi, [rbx + 0xB8 + 24 + 240]


 mov dword [rdi], 0x74786574
 mov dword [rdi+4], 0x00000000
 mov rax, [rel seg_text_size]
 mov dword [rdi+8], eax
 mov dword [rdi+12], 0x1000
 mov dword [rdi+16], eax
 mov dword [rdi+20], 0x400
 mov dword [rdi+24], 0
 mov dword [rdi+28], 0
 mov word [rdi+32], 0
 mov word [rdi+34], 0
 mov dword [rdi+36], 0x60000020


 lea rdi, [rbx + 0xB8 + 24 + 240 + 40]
 mov dword [rdi], 0x61746164
 mov dword [rdi+4], 0x00000000
 mov rax, [rel seg_data_size]
 mov dword [rdi+8], eax
 mov rax, [rel seg_text_size]
 add rax, 0x1000
 mov dword [rdi+12], eax
 mov rax, [rel seg_data_size]
 mov dword [rdi+16], eax
 mov rax, [rel seg_text_size]
 add rax, 0x400
 mov dword [rdi+20], eax
 mov dword [rdi+24], 0
 mov dword [rdi+28], 0
 mov word [rdi+32], 0
 mov word [rdi+34], 0
 mov dword [rdi+36], 0xC0000040


 lea rdi, [rbx + 0x400]
 lea rsi, [rel seg_text_data]
 mov rcx, [rel seg_text_size]
 rep movsb


 mov rax, [rel seg_text_size]
 add rax, 0x400
 lea rdi, [rbx + rax]
 lea rsi, [rel seg_data_data]
 mov rcx, [rel seg_data_size]
 rep movsb


 mov rax, [rel seg_text_size]
 add rax, [rel seg_data_size]
 add rax, 0x400
 mov [rel output_pos], rax

 xor rax, rax
 pop r13
 pop r12
 pop rbx
 pop rbp
 ret





find_symbol:

 push rbp
 mov rbp, rsp
 push rbx
 push r12
 push r13

 mov rbx, rdi
 mov r12, rsi
 mov r13, rdx
 xor rcx, rcx

.fs_loop:
 cmp rcx, r12
 jge .fs_not_found

 mov rax, rcx
 mov rdi, 32
 mul rdi
 add rax, rbx

 lea rdi, [rax + 0]
 mov rsi, r13
 call strcmp_asm
 test rax, rax
 jz .fs_found

 inc rcx
 jmp .fs_loop

.fs_found:
 mov rax, rcx
 mov rdi, 32
 mul rdi
 add rax, rbx
 jmp .fs_exit

.fs_not_found:
 xor rax, rax

.fs_exit:
 pop r13
 pop r12
 pop rbx
 pop rbp
 ret

add_global_symbol:
 push rbp
 mov rbp, rsp
 push rbx

 mov rbx, rdi
 mov rax, [rel global_symcount]
 mov rcx, 32
 mul rcx

 lea rdi, [rel global_symtab]
 add rdi, rax
 mov rsi, rbx
 mov rcx, 32
 rep movsb

 inc qword [rel global_symcount]
 xor rax, rax
 pop rbx
 pop rbp
 ret

linker_get_error:
 lea rax, [rel link_error_buf]
 ret




lnk_print_string:
 push rbp
 mov rbp, rsp
 push rbx
 sub rsp, 48

 mov rbx, rcx

 xor rdx, rdx
.ps_len:
 cmp byte [rbx + rdx], 0
 je .ps_write
 inc rdx
 jmp .ps_len
.ps_write:

 mov rcx, -11
 call GetStdHandle

 mov rcx, rax
 mov rdx, rbx

 mov r8, rdx
 xor r9, r9
 mov qword [rsp+32], 0
 call WriteFile

 add rsp, 48
 pop rbx
 pop rbp
 ret

strcpy_safe:
 push rbp
 mov rbp, rsp
.sc_loop:
 mov al, [rsi]
 mov [rdi], al
 test al, al
 jz .sc_done
 inc rsi
 inc rdi
 jmp .sc_loop
.sc_done:
 pop rbp
 ret

strcmp_asm:
 push rbp
 mov rbp, rsp
 push rbx
.sa_loop:
 mov al, [rdi]
 mov bl, [rsi]
 cmp al, bl
 jne .sa_neq
 test al, al
 jz .sa_eq
 inc rdi
 inc rsi
 jmp .sa_loop
.sa_eq:
 xor rax, rax
 jmp .sa_exit
.sa_neq:
 movsx rax, al
 movsx rbx, bl
 sub rax, rbx
.sa_exit:
 pop rbx
 pop rbp
 ret
