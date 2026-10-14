%line 1+1 main.asm
[extern dbg_which]






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

%line 14+1 main.asm
[extern jup_lexer_init]
%line 14+0 main.asm
[extern jup_lexer_run]
%line 15+1 main.asm
[extern jup_parser_init]
%line 15+0 main.asm
[extern jup_parser_run]
%line 16+1 main.asm
[extern parser_get_error_token]
%line 16+0 main.asm
[extern parser_get_position]
%line 17+1 main.asm
[extern parser_get_error_line]
[extern token_name]
[extern jup_semantic_init]
%line 19+0 main.asm
[extern jup_semantic_run]
[extern jup_semantic_error_line]
%line 20+1 main.asm
[extern jup_codegen_init]
%line 20+0 main.asm
[extern jup_codegen_run]
[extern jup_codegen_set_target]
%line 21+1 main.asm
[extern jasm_init]
%line 21+0 main.asm
[extern jasm_assemble]
[extern jasm_get_code]
[extern jasm_get_code_size]
[extern jasm_had_error]
%line 22+1 main.asm
[extern jasm_get_error_line]
%line 22+0 main.asm
[extern jasm_get_error_count]
[extern jasm_get_error_line_at]
%line 23+1 main.asm
[extern jasm_get_error_dst]
%line 23+0 main.asm
[extern jasm_get_error_src]
%line 24+1 main.asm
[extern jasm_get_error_mnem]
[extern jasm_build_image]
[extern pw_write]
[extern jpx_init]
%line 27+0 main.asm
[extern jpx_build]
[extern jpx_get_image]
[extern jpx_get_size]
%line 28+1 main.asm
[extern jarm_selftest]
%line 28+0 main.asm
[extern jarm_get_code]
[extern jarm_get_size]
%line 29+1 main.asm
[extern jup_runtime_init]
[extern jup_linker_run]
[extern parser_get_ast_root]
[extern codegen_get_code]
%line 32+0 main.asm
[extern codegen_get_code_size]
%line 33+1 main.asm

[section .data]
 banner db "========================================", 13, 10
 db "  JUPITER COMPILER v1.0 - SOBERANO", 13, 10
 db "  100% ASM x86-64  Sin dependencias", 13, 10
 db "========================================", 13, 10, 0

 msg_read db "[1/6] Leyendo archivo...", 0
 msg_lex db "[2/6] Lexer...", 0
 msg_parse db "[3/6] Parser...", 0
 msg_sem db "[4/6] Semantico...", 0
 msg_code db "[5/6] Codegen...", 0
 msg_link db "[6/6] Enlazando...", 0
 msg_asm_mode db "Modo ensamblador (jasm)", 13, 10, 0
 s_pp_include db "include", 0
 s_pp_define db "define", 0
 s_pp_macro db "macro", 0
 s_pp_endmacro db "%endmacro", 0
 s_pp_equ db " equ ", 0
 s_pp_incdir db "include", 92, 0
 s_pp_dump db "preproc.asm", 0
 msg_asm_line db "  en la linea ", 0
 msg_mnem db "   ", 0
 msg_kind_d db "   dst=", 0
 msg_kind_s db " src=", 0
 msg_dst db "   dst=", 0
 msg_src db " src=", 0
 msg_arm_mode db "Codificador ARM64 (jarm)", 13, 10, 0
 dbg_1 db "  [1] leyendo archivo", 13, 10, 0
 dbg_2 db "  [2] jasm_init", 13, 10, 0
 dbg_3 db "  [3] jasm_assemble", 13, 10, 0
 dbg_4 db "  [4] escribiendo salida", 13, 10, 0
 msg_asm_ok db "Bytes generados: ", 0
 msg_asm_err db "ERROR: jasm fallo al ensamblar.", 13, 10, 0
 msg_ok db " OK", 13, 10, 0
 msg_done db 13, 10, "Compilacion exitosa!", 13, 10, 0
 msg_err_args db "ERROR: uso: jupiterc.exe archivo.jup [-o salida]", 13, 10, 0
 msg_err_read db "ERROR: No se puede leer archivo.", 13, 10, 0
 msg_err_lex db "ERROR: Lexer fallo.", 13, 10, 0
 msg_err_parse db "ERROR: Parser fallo. Token=", 0
 msg_err_pos db " Posicion=", 0
 msg_err_line db " Linea=", 0
 msg_err_found db "  (se encontro: ", 0
 msg_err_close db ")", 0
 msg_err_sem db "ERROR: Variable no declarada en linea ", 0
 msg_newline db 13, 10, 0
 msg_err_code db "ERROR: Codegen fallo.", 13, 10, 0
 msg_err_write db "ERROR: No se pudo escribir el .asm.", 13, 10, 0
 msg_wrote db "Generado: ", 0
 asm_ext db ".asm", 0
 bin_ext db ".jbin", 0
 jpx_ext db ".jpx", 0
 exe_ext db ".exe", 0
 arm_ext db ".arm", 0
 bin_ext_ptr dq 0

[section .bss]
 arg_input resb 512
 arg_output resb 512
 src_buffer resb (4 * 1024 * 1024)
 exp_buffer resb (4 * 1024 * 1024)
 inc_buffer resb (4 * 1024 * 1024)
 inc_buffer2 resb (4 * 1024 * 1024)
 pp_depth resq 1
 pp_out_end resq 1
 pp_dup resb 1
 pp_inc_buf resq 1
 inc_name resb 260
 pp_name resb 260
 pp_path resb 320
 mac_names resb 1024
 mac_names_len resq 1
 mac_name_off resd 32
 mac_nparams resb 32
 mac_body_off resd 32
 mac_body_len resd 32
 mac_bodies resb 16384
 mac_bodies_len resq 1
 mac_count resq 1
 pp_args resb 512
 pp_arg_off resd 8
 pp_arg_len resd 8
 pp_argc resq 1
 out_target resb 1
 out_bin_name resb 512
 src_size resq 1
 token_buffer resb (2 * 1024 * 1024)
 token_count resq 1
 ast_buffer resb (32 * 1024 * 1024)
 ast_count resq 1
 code_buffer resb (8 * 1024 * 1024)
 sym_buffer resb (4 * 1024 * 1024)
 code_size resq 1
 out_asm_name resb 512
 hStdOut resq 1

[section .text]
[global main]
[global print_string]

main:
 push rbp
 mov rbp, rsp


 sub rsp, 32
 mov rcx, -11
 call GetStdHandle
 add rsp, 32
 mov [rel hStdOut], rax


 lea rcx, [rel banner]
 call print_string



 sub rsp, 32
 call GetCommandLineA
 add rsp, 32
 mov rcx, rax
 push rax
 call parse_command_line
 test rax, rax
 pop rcx
 jz .error_args

 call scan_arm_flag
 test al, al
 jnz .arm_only


 call scan_assemble_flag
 test al, al
 jnz .assemble_only


 call scan_target
 mov [rel out_target], al
 mov dil, al
 call jup_codegen_set_target


 lea rcx, [rel msg_read]
 call print_string

 lea rcx, [rel arg_input]
 lea rdx, [rel src_buffer]
 mov r8, (4 * 1024 * 1024)
 call read_file

 mov [rel src_size], rax
 test rax, rax
 jz .error_read


 sub rsp, 32
 lea rcx, [rel src_buffer]
 mov rdx, [rel src_size]
 lea r8, [rel exp_buffer]
 call expand_imports
 add rsp, 32
 mov [rel src_size], rax

 lea rcx, [rel msg_ok]
 call print_string


 lea rcx, [rel msg_lex]
 call print_string

 sub rsp, 32
 lea rcx, [rel exp_buffer]
 mov rdx, [rel src_size]
 lea r8, [rel token_buffer]
 lea r9, [rel token_count]
 call jup_lexer_init
 add rsp, 32

 sub rsp, 32
 call jup_lexer_run
 add rsp, 32
 test rax, rax
 jz .error_lex

 lea rcx, [rel msg_ok]
 call print_string


 lea rcx, [rel msg_parse]
 call print_string


 lea rdi, [rel token_buffer]
 mov rsi, [rel token_count]
 lea rdx, [rel ast_buffer]
 mov rcx, (32 * 1024 * 1024)
 call jup_parser_init

 sub rsp, 32
 call jup_parser_run
 add rsp, 32
 test rax, rax
 jz .error_parse

 lea rcx, [rel msg_ok]
 call print_string


 lea rcx, [rel msg_sem]
 call print_string

 lea rcx, [rel sym_buffer]
 mov rdx, (4 * 1024 * 1024)
 mov rdi, rcx
 mov rsi, rdx
 sub rsp, 32
 call jup_semantic_init
 add rsp, 32
 call parser_get_ast_root
 mov rdi, rax
 sub rsp, 32
 call jup_semantic_run
 add rsp, 32
 test rax, rax
 jz .sem_ok

 lea rcx, [rel msg_newline]
 call print_string
 lea rcx, [rel msg_err_sem]
 call print_string
 call jup_semantic_error_line
 mov rcx, rax
 call print_u64
 lea rcx, [rel msg_newline]
 call print_string
 mov eax, 4
 pop rbp
 ret
.sem_ok:
 lea rcx, [rel msg_ok]
 call print_string


 lea rcx, [rel msg_code]
 call print_string

 lea rcx, [rel code_buffer]
 mov rdx, (8 * 1024 * 1024)
 sub rsp, 32
 mov rdi, rcx
 mov rsi, rdx
 call jup_codegen_init
 add rsp, 32

 call parser_get_ast_root
 mov rdi, rax
 sub rsp, 32
 call jup_codegen_run
 add rsp, 32
 test rax, rax
 jz .error_code

 lea rcx, [rel msg_ok]
 call print_string


 lea rcx, [rel msg_link]
 call print_string

 call build_asm_name

 call codegen_get_code
 mov r10, rax
 call codegen_get_code_size
 mov r11, rax

 lea rcx, [rel out_asm_name]
 mov rdx, r10
 mov r8, r11
 call write_file
 test rax, rax
 jz .error_write

 lea rcx, [rel msg_ok]
 call print_string

 lea rcx, [rel msg_wrote]
 call print_string
 lea rcx, [rel out_asm_name]
 call print_string
 lea rcx, [rel msg_newline]
 call print_string


 lea rcx, [rel msg_done]
 call print_string

 xor eax, eax
 pop rbp
 ret

.arm_only:
 lea rcx, [rel msg_arm_mode]
 call print_string
 sub rsp, 32
 call jarm_selftest
 add rsp, 32
 sub rsp, 32
 call jarm_get_code
 mov r10, rax
 call jarm_get_size
 mov r11, rax
 add rsp, 32
 lea rcx, [rel arm_ext]
 mov [rel bin_ext_ptr], rcx
 call build_bin_name
 lea rcx, [rel out_bin_name]
 mov rdx, r10
 mov r8, r11
 call write_file
 test rax, rax
 jz .error_write
 lea rcx, [rel msg_asm_ok]
 call print_string
 lea rcx, [rel out_bin_name]
 call print_string
 lea rcx, [rel msg_newline]
 call print_string
 xor eax, eax
 pop rbp
 ret

.assemble_only:
 lea rcx, [rel msg_asm_mode]
 call print_string

 lea rcx, [rel arg_input]
 lea rdx, [rel src_buffer]
 mov r8, (4 * 1024 * 1024)
 call read_file
 mov [rel src_size], rax
 test rax, rax
 jz .error_read


 lea rcx, [rel src_buffer]
 mov rdx, [rel src_size]
 lea r8, [rel exp_buffer]
 call asm_preprocess
 mov [rel src_size], rax


 lea rcx, [rel s_pp_dump]
 lea rdx, [rel exp_buffer]
 mov r8, [rel src_size]
 call write_file

 sub rsp, 32
 call jasm_init
 add rsp, 32

 sub rsp, 32
 lea rcx, [rel exp_buffer]
 mov rdx, [rel src_size]
 call jasm_assemble
 add rsp, 32
 test rax, rax
 jz .error_asm


 call scan_pe_flag
 test al, al
 jnz .emit_pe


 call scan_jpx_flag
 test al, al
 jnz .emit_jpx

 sub rsp, 32
 call jasm_build_image
 mov r11, rax
 call jasm_get_code
 mov r10, rax
 add rsp, 32
 jmp .have_image

.emit_pe:
 sub rsp, 32
 lea rcx, [rel code_buffer]
 call pw_write
 mov r11, rax
 lea r10, [rel code_buffer]
 add rsp, 32
 lea rcx, [rel exe_ext]
 mov [rel bin_ext_ptr], rcx
 jmp .have_image

.emit_jpx:
 sub rsp, 32
 call jpx_init
 call jpx_build
 mov r11, rax
 call jpx_get_image
 mov r10, rax
 add rsp, 32
 lea rcx, [rel jpx_ext]
 mov [rel bin_ext_ptr], rcx

.have_image:
 call build_bin_name

 lea rcx, [rel out_bin_name]
 mov rdx, r10
 mov r8, r11
 call write_file
 test rax, rax
 jz .error_write

 lea rcx, [rel msg_asm_ok]
 call print_string
 lea rcx, [rel out_bin_name]
 call print_string
 lea rcx, [rel msg_newline]
 call print_string
 xor eax, eax
 pop rbp
 ret

.error_asm:
 lea rcx, [rel msg_asm_err]
 call print_string

 sub rsp, 32
 call jasm_get_error_count
 add rsp, 32
 mov r14, rax
 xor r15, r15
.ea_loop:
 cmp r15, r14
 jae .ea_done
 lea rcx, [rel msg_asm_line]
 call print_string
 mov rcx, r15
 sub rsp, 32
 call jasm_get_error_line_at
 add rsp, 32
 mov rcx, rax
 call print_u64



 lea rcx, [rel msg_mnem]
 call print_string
 mov rcx, r15
 sub rsp, 32
 call jasm_get_error_mnem
 add rsp, 32
 mov rcx, rax
 call print_string
 lea rcx, [rel msg_dst]
 call print_string
 mov rcx, r15
 sub rsp, 32
 call jasm_get_error_dst
 add rsp, 32
 mov rcx, rax
 call print_u64
 lea rcx, [rel msg_src]
 call print_string
 mov rcx, r15
 sub rsp, 32
 call jasm_get_error_src
 add rsp, 32
 mov rcx, rax
 call print_u64
 lea rcx, [rel msg_newline]
 call print_string
 inc r15
 jmp .ea_loop
.ea_done:
 mov eax, 1
 pop rbp
 ret

.error_args:
 lea rcx, [rel msg_err_args]
 call print_string
 mov eax, 1
 pop rbp
 ret

.error_read:
 lea rcx, [rel msg_err_read]
 call print_string
 mov eax, 2
 pop rbp
 ret

.error_lex:
 lea rcx, [rel msg_err_lex]
 call print_string
 mov eax, 3
 pop rbp
 ret

.error_parse:
 lea rcx, [rel msg_err_parse]
 call print_string
 call parser_get_error_token
 mov rcx, rax
 call print_u64
 lea rcx, [rel msg_err_pos]
 call print_string
 call parser_get_position
 mov rcx, rax
 call print_u64
 lea rcx, [rel msg_err_line]
 call print_string
 call parser_get_error_line
 mov rcx, rax
 call print_u64
 lea rcx, [rel msg_err_found]
 call print_string
 call parser_get_error_token
 mov rcx, rax
 mov rdi, rax
 sub rsp, 32
 call token_name
 add rsp, 32
 mov rcx, rax
 call print_string
 lea rcx, [rel msg_err_close]
 call print_string
 lea rcx, [rel msg_newline]
 call print_string
 mov eax, 4
 pop rbp
 ret

.error_code:
 lea rcx, [rel msg_err_code]
 call print_string
 movzx rcx, byte [rel dbg_which]
 call print_u64
 mov eax, 5
 pop rbp
 ret

.error_write:
 lea rcx, [rel msg_err_write]
 call print_string
 mov eax, 6
 pop rbp
 ret








scan_assemble_flag:
 push rsi
 sub rsp, 40
 call GetCommandLineA
 add rsp, 40
 mov rsi, rax
 test rsi, rsi
 jz .no
.l:
 mov al, [rsi]
 test al, al
 jz .no
 cmp al, '-'
 jne .nx
 cmp byte [rsi+1], '-'
 jne .nx
 cmp byte [rsi+2], 'a'
 jne .nx
 cmp byte [rsi+3], 's'
 jne .nx
 cmp byte [rsi+4], 's'
 jne .nx
 cmp byte [rsi+5], 'e'
 jne .nx
 mov al, 1
 pop rsi
 ret
.nx:
 inc rsi
 jmp .l
.no:
 xor al, al
 pop rsi
 ret




scan_arm_flag:
 push rsi
 sub rsp, 32
 call GetCommandLineA
 add rsp, 32
 mov rsi, rax
 test rsi, rsi
 jz .no
.l:
 mov al, [rsi]
 test al, al
 jz .no
 cmp al, '-'
 jne .nx
 cmp byte [rsi+1], '-'
 jne .nx
 cmp byte [rsi+2], 'a'
 jne .nx
 cmp byte [rsi+3], 'r'
 jne .nx
 cmp byte [rsi+4], 'm'
 jne .nx
 mov al, 1
 pop rsi
 ret
.nx:
 inc rsi
 jmp .l
.no:
 xor al, al
 pop rsi
 ret




scan_pe_flag:
 push rsi
 sub rsp, 32
 call GetCommandLineA
 add rsp, 32
 mov rsi, rax
 test rsi, rsi
 jz .no
.l:
 mov al, [rsi]
 test al, al
 jz .no
 cmp al, '-'
 jne .nx
 cmp byte [rsi+1], '-'
 jne .nx
 cmp byte [rsi+2], 'p'
 jne .nx
 cmp byte [rsi+3], 'e'
 jne .nx

 mov al, [rsi+4]
 test al, al
 jz .yes
 cmp al, ' '
 jne .nx
.yes:
 mov al, 1
 pop rsi
 ret
.nx:
 inc rsi
 jmp .l
.no:
 xor al, al
 pop rsi
 ret




scan_jpx_flag:
 push rsi
 sub rsp, 32
 call GetCommandLineA
 add rsp, 32
 mov rsi, rax
 test rsi, rsi
 jz .no
.l:
 mov al, [rsi]
 test al, al
 jz .no
 cmp al, '-'
 jne .nx
 cmp byte [rsi+1], '-'
 jne .nx
 cmp byte [rsi+2], 'j'
 jne .nx
 cmp byte [rsi+3], 'p'
 jne .nx
 cmp byte [rsi+4], 'x'
 jne .nx
 mov al, 1
 pop rsi
 ret
.nx:
 inc rsi
 jmp .l
.no:
 xor al, al
 pop rsi
 ret




build_bin_name:
 push rbx
 push rsi
 push rdi
 lea rsi, [rel arg_input]
 lea rdi, [rel out_bin_name]
 xor rbx, rbx
.copy:
 mov al, [rsi + rbx]
 test al, al
 jz .find_dot
 mov [rdi + rbx], al
 inc rbx
 jmp .copy
.find_dot:
 mov rcx, rbx
.scan:
 test rcx, rcx
 jz .append
 dec rcx
 cmp byte [rdi + rcx], '.'
 je .trim
 cmp byte [rdi + rcx], '/'
 je .append
 cmp byte [rdi + rcx], 92
 je .append
 jmp .scan
.trim:
 mov rbx, rcx
.append:
 mov rsi, [rel bin_ext_ptr]
 test rsi, rsi
 jnz .have_ext
 lea rsi, [rel bin_ext]
.have_ext:
 xor rcx, rcx
.app_loop:
 mov al, [rsi + rcx]
 mov [rdi + rbx], al
 test al, al
 jz .done
 inc rbx
 inc rcx
 jmp .app_loop
.done:
 pop rdi
 pop rsi
 pop rbx
 ret


build_asm_name:
 push rbx
 push rsi
 push rdi
 lea rsi, [rel arg_input]
 lea rdi, [rel out_asm_name]
 xor rbx, rbx
.copy:
 mov al, [rsi + rbx]
 test al, al
 jz .find_dot
 mov [rdi + rbx], al
 inc rbx
 jmp .copy
.find_dot:

 mov rcx, rbx
.scan:
 test rcx, rcx
 jz .append
 dec rcx
 cmp byte [rdi + rcx], '.'
 je .trim
 cmp byte [rdi + rcx], '/'
 je .append
 cmp byte [rdi + rcx], '\'
 je .append
 jmp .scan
.trim:
 mov rbx, rcx
.append:

 lea rsi, [rel asm_ext]
 xor rcx, rcx
.app_loop:
 mov al, [rsi + rcx]
 mov [rdi + rbx], al
 test al, al
 jz .done
 inc rbx
 inc rcx
 jmp .app_loop
.done:
 pop rdi
 pop rsi
 pop rbx
 ret





write_file:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 mov r12, rcx
 mov r13, rdx
 mov rsi, r8


 sub rsp, 64
 mov rcx, r12
 mov rdx, 0x40000000
 xor r8, r8
 xor r9, r9
 mov qword [rsp + 32], 2
 mov qword [rsp + 40], 0
 mov qword [rsp + 48], 0
 call CreateFileA
 add rsp, 64
 cmp rax, -1
 je .werr
 mov rbx, rax


 sub rsp, 64
 mov rcx, rbx
 mov rdx, r13
 mov r8, rsi
 lea r9, [rsp + 48]
 mov qword [rsp + 48], 0
 mov qword [rsp + 32], 0
 call WriteFile
 add rsp, 64


 sub rsp, 32
 mov rcx, rbx
 call CloseHandle
 add rsp, 32

 mov rax, 1
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret
.werr:
 xor rax, rax
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret




print_string:
 push rbx
 push rsi
 push rdi
 mov rsi, rcx
 xor rcx, rcx

.loop:
 mov al, [rsi + rcx]
 test al, al
 jz .done
 inc rcx
 jmp .loop

.done:

 sub rsp, 64
 mov r8, rcx
 mov rcx, [rel hStdOut]
 mov rdx, rsi
 lea r9, [rsp + 48]
 mov qword [rsp + 32], 0
 call WriteFile
 add rsp, 64

 pop rdi
 pop rsi
 pop rbx
 ret









expand_imports:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 push r14
 push r15
 mov rbx, rcx
 mov rsi, rcx
 mov r12, rdx
 mov rdi, r8
 mov r15, r8

.scan:
 test r12, r12
 jz .done
 cmp r12, 14
 jb .copy
 cmp dword [rsi], 'acqu'
 jne .copy
 cmp dword [rsi+4], 'ire_'
 jne .copy
 cmp dword [rsi+8], 'doma'
 jne .copy
 cmp word [rsi+12], 'in'
 jne .copy

 cmp rsi, rbx
 je .at_bol
 mov al, [rsi-1]
 cmp al, 10
 je .at_bol
 cmp al, 13
 je .at_bol
 jmp .copy
.at_bol:
 add rsi, 14
 sub r12, 14
.sp:
 test r12, r12
 jz .done
 mov al, [rsi]
 cmp al, ' '
 je .sp_adv
 cmp al, 9
 je .sp_adv
 jmp .quote
.sp_adv:
 inc rsi
 dec r12
 jmp .sp
.quote:
 cmp al, 34
 jne .copy
 inc rsi
 dec r12
 lea r13, [rel inc_name]
 xor r14, r14
.name:
 test r12, r12
 jz .done
 mov al, [rsi]
 cmp al, 34
 je .name_end
 cmp r14, 255
 jae .name_end
 mov [r13 + r14], al
 inc r14
 inc rsi
 dec r12
 jmp .name
.name_end:
 mov byte [r13 + r14], 0
 inc rsi
 dec r12
.tail:
 test r12, r12
 jz .load
 mov al, [rsi]
 inc rsi
 dec r12
 cmp al, 10
 jne .tail

.load:

 push rbx
 push rsi
 push rdi
 push r12
 sub rsp, 32
 lea rcx, [rel inc_name]
 lea rdx, [rel inc_buffer]
 mov r8, (4 * 1024 * 1024)
 call read_file
 add rsp, 32
 pop r12
 pop rdi
 pop rsi
 pop rbx
 test rax, rax
 jz .scan
 mov r13, rax
 lea r14, [rel inc_buffer]
.emit:
 test r13, r13
 jz .emit_end
 mov al, [r14]
 mov [rdi], al
 inc r14
 inc rdi
 dec r13
 jmp .emit
.emit_end:
 mov byte [rdi], 10
 inc rdi
 jmp .scan

.copy:
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec r12
 jmp .scan

.done:
 mov byte [rdi], 0
 mov rax, rdi
 sub rax, r15
 pop r15
 pop r14
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret




copy_bytes:
 push rsi
 push rdi
 mov rdi, rcx
 mov rsi, rdx
.l:
 test r8, r8
 jz .d
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec r8
 jmp .l
.d:
 mov byte [rdi], 0
 pop rdi
 pop rsi
 ret















asm_preprocess:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 push r14
 push r15
 mov rsi, rcx
 mov r12, rcx
 add r12, rdx
 mov rdi, r8
 mov r15, r8
 mov rax, r8
 add rax, (4 * 1024 * 1024)
 sub rax, 64
 mov [rel pp_out_end], rax
 mov qword [rel mac_count], 0
 mov qword [rel mac_names_len], 0
 mov qword [rel mac_bodies_len], 0
 mov qword [rel pp_depth], 0
 call pp_range
 mov rax, rdi
 sub rax, r15
 pop r15
 pop r14
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret


pp_range:
.line:
 cmp rsi, r12
 jae .out
 mov r13, rsi
.find_eol:
 cmp rsi, r12
 jae .have_line
 mov al, [rsi]
 cmp al, 10
 je .have_line
 inc rsi
 jmp .find_eol
.have_line:
 mov r14, rsi
 cmp rsi, r12
 jae .no_nl
 inc rsi
.no_nl:
 call pp_one_line
 jmp .line
.out:
 ret


pp_one_line:
 push rsi
 push r12
 mov rbx, r13
.skip_ws:
 cmp rbx, r14
 jae .copy_verbatim
 mov al, [rbx]
 cmp al, ' '
 je .ws_adv
 cmp al, 9
 jne .check
.ws_adv:
 inc rbx
 jmp .skip_ws
.check:
 cmp al, '%'
 je .directive
 call pp_try_macro
 test al, al
 jnz .done
.copy_verbatim:
 mov rcx, r13
 mov rdx, r14
 call pp_emit_range
 call pp_emit_nl
.done:
 pop r12
 pop rsi
 ret

.directive:

 lea rcx, [rbx+1]
 lea rdx, [rel s_pp_include]
 call pp_starts_with
 test al, al
 jnz .do_include
 lea rcx, [rbx+1]
 lea rdx, [rel s_pp_define]
 call pp_starts_with
 test al, al
 jnz .do_define
 lea rcx, [rbx+1]
 lea rdx, [rel s_pp_macro]
 call pp_starts_with
 test al, al
 jnz .do_macro
 jmp .done

.do_include:

 add rbx, 8
.inc_findq:
 cmp rbx, r14
 jae .done
 cmp byte [rbx], '"'
 je .inc_gotq
 inc rbx
 jmp .inc_findq
.inc_gotq:
 inc rbx
 lea rdx, [rel pp_name]
 xor rcx, rcx
.inc_copy:
 cmp rbx, r14
 jae .inc_named
 mov al, [rbx]
 cmp al, '"'
 je .inc_named
 cmp rcx, 255
 jae .inc_named
 mov [rdx + rcx], al
 inc rcx
 inc rbx
 jmp .inc_copy
.inc_named:
 mov byte [rdx + rcx], 0


 lea r8, [rel pp_path]
 lea r9, [rel s_pp_incdir]
 xor rcx, rcx
.inc_pfx:
 mov al, [r9 + rcx]
 test al, al
 jz .inc_pfx_done
 mov [r8 + rcx], al
 inc rcx
 jmp .inc_pfx
.inc_pfx_done:
 lea r9, [rel pp_name]
 xor rdx, rdx
.inc_join:
 mov al, [r9 + rdx]
 mov [r8 + rcx], al
 test al, al
 jz .inc_joined
 inc rcx
 inc rdx
 jmp .inc_join
.inc_joined:


 push rsi
 push rdi
 push rbx
 push r12
 push r13
 push r14




 lea rdx, [rel inc_buffer]
 cmp qword [rel pp_depth], 0
 je .inc_buf_ok
 lea rdx, [rel inc_buffer2]
.inc_buf_ok:
 mov [rel pp_inc_buf], rdx
 lea rcx, [rel pp_path]
 mov r8, (4 * 1024 * 1024)
 call read_file
 test rax, rax
 jnz .inc_read_ok
 lea rcx, [rel pp_name]
 mov rdx, [rel pp_inc_buf]
 mov r8, (4 * 1024 * 1024)
 call read_file
.inc_read_ok:
 pop r14
 pop r13
 pop r12
 pop rbx
 pop rdi
 pop rsi
 test rax, rax
 jz .done
.inc_have:
 push rsi
 push r12
 push r13
 push r14
 mov rsi, [rel pp_inc_buf]
 mov r12, rsi
 add r12, rax
 inc qword [rel pp_depth]
 call pp_range
 dec qword [rel pp_depth]
 pop r14
 pop r13
 pop r12
 pop rsi
 jmp .done

.do_define:

 add rbx, 7
 call pp_skip_blanks_rbx
 mov rcx, rbx
.def_name:
 cmp rbx, r14
 jae .def_emit
 mov al, [rbx]
 cmp al, ' '
 je .def_emit
 cmp al, 9
 je .def_emit
 inc rbx
 jmp .def_name
.def_emit:
 mov rdx, rbx
 call pp_emit_range
 lea rcx, [rel s_pp_equ]
 call pp_emit_cstr
 call pp_skip_blanks_rbx
 mov rcx, rbx
 mov rdx, r14
 call pp_emit_range
 call pp_emit_nl
 jmp .done

.do_macro:

 add rbx, 6
 call pp_skip_blanks_rbx
 call pp_record_macro


 pop r12
 add rsp, 8
 ret




pp_emit_range:
.l:
 cmp rcx, rdx
 jae .out
 cmp rdi, [rel pp_out_end]
 jae .out
 mov al, [rcx]
 mov [rdi], al
 inc rdi
 inc rcx
 jmp .l
.out:
 ret


pp_emit_cstr:
.l:
 mov al, [rcx]
 test al, al
 jz .out
 cmp rdi, [rel pp_out_end]
 jae .out
 mov [rdi], al
 inc rdi
 inc rcx
 jmp .l
.out:
 ret

pp_emit_nl:
 cmp rdi, [rel pp_out_end]
 jae .out
 mov byte [rdi], 10
 inc rdi
.out:
 ret


pp_skip_blanks_rbx:
.l:
 cmp rbx, r14
 jae .out
 mov al, [rbx]
 cmp al, ' '
 je .adv
 cmp al, 9
 jne .out
.adv:
 inc rbx
 jmp .l
.out:
 ret


pp_starts_with:
.l:
 mov al, [rdx]
 test al, al
 jz .yes
 cmp al, [rcx]
 jne .no
 inc rcx
 inc rdx
 jmp .l
.no:
 xor al, al
 ret
.yes:
 mov al, 1
 ret



pp_record_macro:
 push rcx
 push rdx
 push r8
 push r9


 mov byte [rel pp_dup], 0
 push rbx
 call pp_macro_known
 pop rbx
 test al, al
 jz .not_dup
 mov byte [rel pp_dup], 1
 jmp .skip_body
.not_dup:
 mov r8, [rel mac_count]
 cmp r8, 32
 jae .skip_body

 mov rax, [rel mac_names_len]
 lea rdx, [rel mac_name_off]
 mov [rdx + r8*4], eax
 lea rdx, [rel mac_names]
 add rdx, rax
 xor rcx, rcx
.nm:
 cmp rbx, r14
 jae .nm_done
 mov al, [rbx]
 cmp al, ' '
 je .nm_done
 cmp al, 9
 je .nm_done
 cmp al, 13
 je .nm_done
 mov [rdx + rcx], al
 inc rcx
 inc rbx
 jmp .nm
.nm_done:
 mov byte [rdx + rcx], 0
 inc rcx
 add [rel mac_names_len], rcx

 call pp_skip_blanks_rbx
 xor rax, rax
.np:
 cmp rbx, r14
 jae .np_done
 movzx ecx, byte [rbx]
 cmp cl, '0'
 jb .np_done
 cmp cl, '9'
 ja .np_done
 imul rax, rax, 10
 sub rcx, 48
 add rax, rcx
 inc rbx
 jmp .np
.np_done:
 lea rdx, [rel mac_nparams]
 mov [rdx + r8], al

 mov rax, [rel mac_bodies_len]
 lea rdx, [rel mac_body_off]
 mov [rdx + r8*4], eax
.skip_body:

 xor r9, r9
.bl:
 cmp rsi, r12
 jae .bl_done
 mov r13, rsi
.bl_eol:
 cmp rsi, r12
 jae .bl_have
 mov al, [rsi]
 cmp al, 10
 je .bl_have
 inc rsi
 jmp .bl_eol
.bl_have:
 mov r14, rsi
 cmp rsi, r12
 jae .bl_nonl
 inc rsi
.bl_nonl:

 mov rcx, r13
.bl_ws:
 cmp rcx, r14
 jae .bl_copy
 mov al, [rcx]
 cmp al, ' '
 je .bl_wsa
 cmp al, 9
 jne .bl_chk
.bl_wsa:
 inc rcx
 jmp .bl_ws
.bl_chk:
 lea rdx, [rel s_pp_endmacro]
 call pp_starts_with
 test al, al
 jnz .bl_done
.bl_copy:
 mov rax, [rel mac_bodies_len]
 add rax, r9
 lea rdx, [rel mac_bodies]
 add rdx, rax
 mov rcx, r13
.bl_cp:
 cmp rcx, r14
 jae .bl_cp_nl
 cmp r9, 16000
 jae .bl_cp_nl
 mov al, [rcx]
 mov [rdx], al
 inc rdx
 inc rcx
 inc r9
 jmp .bl_cp
.bl_cp_nl:
 mov byte [rdx], 10
 inc r9
 jmp .bl
.bl_done:
 cmp byte [rel pp_dup], 0
 jne .out
 mov r8, [rel mac_count]
 cmp r8, 32
 jae .out
 lea rdx, [rel mac_body_len]
 mov [rdx + r8*4], r9d
 add [rel mac_bodies_len], r9
 inc r8
 mov [rel mac_count], r8
.out:
 pop r9
 pop r8
 pop rdx
 pop rcx
 ret





pp_macro_known:
 push rcx
 push rdx
 push rsi
 push r8
 push r9
 push r10
 mov r10, rbx
 xor r9, r9
.len:
 mov al, [r10 + r9]
 cmp al, ' '
 je .len_done
 cmp al, 9
 je .len_done
 cmp al, 13
 je .len_done
 cmp al, 10
 je .len_done
 test al, al
 jz .len_done
 inc r9
 jmp .len
.len_done:
 xor r8, r8
.find:
 cmp r8, [rel mac_count]
 jae .no
 lea rdx, [rel mac_name_off]
 mov eax, [rdx + r8*4]
 lea rsi, [rel mac_names]
 add rsi, rax
 xor rcx, rcx
.cmp:
 cmp rcx, r9
 je .cmp_end
 mov al, [r10 + rcx]
 cmp al, [rsi + rcx]
 jne .next
 inc rcx
 jmp .cmp
.cmp_end:
 cmp byte [rsi + rcx], 0
 je .yes
.next:
 inc r8
 jmp .find
.yes:
 mov al, 1
 jmp .out
.no:
 xor al, al
.out:
 pop r10
 pop r9
 pop r8
 pop rsi
 pop rdx
 pop rcx
 ret

pp_try_macro:
 push rbx
 push rcx
 push rdx
 push rsi
 push r8
 push r9
 push r10
 push r11

 mov r10, rbx
.tok:
 cmp rbx, r14
 jae .tok_done
 mov al, [rbx]
 cmp al, ' '
 je .tok_done
 cmp al, 9
 je .tok_done
 cmp al, 13
 je .tok_done
 inc rbx
 jmp .tok
.tok_done:
 mov r11, rbx
 sub r11, r10

 xor r8, r8
.find:
 cmp r8, [rel mac_count]
 jae .no
 lea rdx, [rel mac_name_off]
 mov eax, [rdx + r8*4]
 lea rsi, [rel mac_names]
 add rsi, rax
 xor rcx, rcx
.cmp:
 cmp rcx, r11
 je .cmp_end
 mov al, [r10 + rcx]
 cmp al, [rsi + rcx]
 jne .next
 inc rcx
 jmp .cmp
.cmp_end:
 cmp byte [rsi + rcx], 0
 je .found
.next:
 inc r8
 jmp .find
.no:
 xor al, al
 jmp .out

.found:

 mov qword [rel pp_argc], 0
 call pp_skip_blanks_rbx
.arg:
 cmp rbx, r14
 jae .args_done
 mov rcx, [rel pp_argc]
 cmp rcx, 8
 jae .args_done
 mov rsi, rbx
.arg_scan:
 cmp rbx, r14
 jae .arg_end
 mov al, [rbx]
 cmp al, ','
 je .arg_end
 cmp al, 13
 je .arg_end
 inc rbx
 jmp .arg_scan
.arg_end:

 mov rdx, rbx
.arg_trim:
 cmp rdx, rsi
 jbe .arg_store
 mov al, [rdx-1]
 cmp al, ' '
 je .arg_trim_adv
 cmp al, 9
 jne .arg_store
.arg_trim_adv:
 dec rdx
 jmp .arg_trim
.arg_store:

 mov r9, rcx
 mov rax, 0
 test r9, r9
 jz .arg_at0
 lea rcx, [rel pp_arg_off]
 mov eax, [rcx + r9*4 - 4]
 lea rcx, [rel pp_arg_len]
 add eax, [rcx + r9*4 - 4]
.arg_at0:
 lea rcx, [rel pp_arg_off]
 mov [rcx + r9*4], eax
 lea rcx, [rel pp_args]
 add rcx, rax
 xor r11, r11
.arg_cp:
 cmp rsi, rdx
 jae .arg_cp_done
 mov al, [rsi]
 mov [rcx + r11], al
 inc r11
 inc rsi
 jmp .arg_cp
.arg_cp_done:
 lea rcx, [rel pp_arg_len]
 mov [rcx + r9*4], r11d
 inc r9
 mov [rel pp_argc], r9
 cmp rbx, r14
 jae .args_done
 inc rbx
 call pp_skip_blanks_rbx
 jmp .arg
.args_done:

 lea rdx, [rel mac_body_off]
 mov eax, [rdx + r8*4]
 lea rsi, [rel mac_bodies]
 add rsi, rax
 lea rdx, [rel mac_body_len]
 mov r11d, [rdx + r8*4]
 xor rcx, rcx
.body:
 cmp rcx, r11
 jae .body_done
 mov al, [rsi + rcx]
 cmp al, '%'
 jne .body_plain
 inc rcx
 cmp rcx, r11
 jae .body_done
 movzx eax, byte [rsi + rcx]
 sub rax, 49
 cmp rax, 8
 jae .body_plain2
 cmp rax, [rel pp_argc]
 jae .body_skiparg
 push rcx
 push rsi
 mov r9, rax
 lea rdx, [rel pp_arg_off]
 mov eax, [rdx + r9*4]
 lea rcx, [rel pp_args]
 add rcx, rax
 lea rdx, [rel pp_arg_len]
 mov eax, [rdx + r9*4]
 mov rdx, rcx
 add rdx, rax
 call pp_emit_range
 pop rsi
 pop rcx
.body_skiparg:
 inc rcx
 jmp .body
.body_plain2:
 mov al, '%'
 mov [rdi], al
 inc rdi
 mov al, [rsi + rcx]
.body_plain:
 cmp rdi, [rel pp_out_end]
 jae .body_done
 mov [rdi], al
 inc rdi
 inc rcx
 jmp .body
.body_done:
 mov al, 1
.out:
 pop r11
 pop r10
 pop r9
 pop r8
 pop rsi
 pop rdx
 pop rcx
 pop rbx
 ret




read_file:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 mov r12, rcx
 mov r13, rdx
 mov rsi, r8


 sub rsp, 64
 mov rcx, r12
 mov rdx, 0x80000000
 mov r8, 1
 xor r9, r9
 mov qword [rsp + 32], 3
 mov qword [rsp + 40], 0
 mov qword [rsp + 48], 0
 call CreateFileA
 add rsp, 64

 cmp rax, -1
 je .read_error

 mov rbx, rax


 sub rsp, 64
 mov rcx, rbx
 mov rdx, r13
 mov r8, rsi
 lea r9, [rsp + 48]
 mov qword [rsp + 48], 0
 mov qword [rsp + 32], 0
 call ReadFile
 mov rdi, [rsp + 48]
 add rsp, 64


 sub rsp, 32
 mov rcx, rbx
 call CloseHandle
 add rsp, 32

 mov rax, rdi
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret

.read_error:
 xor eax, eax
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret




print_u64:
 push rbx
 push rsi
 push rdi
 sub rsp, 32
 lea rsi, [rsp + 31]
 mov byte [rsi], 0
 mov rax, rcx
 mov rbx, 10
 test rax, rax
 jnz .convert
 dec rsi
 mov byte [rsi], '0'
 jmp .emit
.convert:
 xor rdx, rdx
 div rbx
 add dl, '0'
 dec rsi
 mov [rsi], dl
 test rax, rax
 jnz .convert
.emit:
 mov rcx, rsi
 call print_string
 add rsp, 32
 pop rdi
 pop rsi
 pop rbx
 ret






scan_target:
 push rsi
 push rbx
 mov rsi, rcx
 mov bl, 0
 test rsi, rsi
 jz .out
.scan:
 mov al, [rsi]
 test al, al
 jz .out
 cmp al, '-'
 jne .next
 cmp byte [rsi+1], '-'
 jne .next

 cmp byte [rsi+2], 'b'
 jne .try_target
 cmp byte [rsi+3], 'a'
 jne .next
 cmp byte [rsi+4], 'r'
 jne .next
 cmp byte [rsi+5], 'e'
 jne .next
 mov bl, 3
 jmp .out
.try_target:

 cmp byte [rsi+2], 't'
 jne .next
 cmp byte [rsi+3], 'a'
 jne .next
 cmp byte [rsi+4], 'r'
 jne .next
 cmp byte [rsi+5], 'g'
 jne .next
 cmp byte [rsi+6], 'e'
 jne .next
 cmp byte [rsi+7], 't'
 jne .next
 cmp byte [rsi+8], '='
 jne .next
 add rsi, 9
 mov al, [rsi]
 cmp al, 'p'
 je .t_pe
 cmp al, 'e'
 je .t_elf
 cmp al, 'j'
 je .t_jpx
 cmp al, 'b'
 je .t_bare
 jmp .out
.t_pe:
 mov bl, 0
 jmp .out
.t_elf:
 mov bl, 1
 jmp .out
.t_jpx:
 mov bl, 2
 jmp .out
.t_bare:
 mov bl, 3
 jmp .out
.next:
 inc rsi
 jmp .scan
.out:
 mov al, bl
 pop rbx
 pop rsi
 ret






parse_command_line:
 push rbx
 push rsi
 push rdi
 mov rsi, rcx


 cmp byte [rsi], '"'
 jne .skip_exe_plain
 inc rsi
.skip_exe_quoted:
 mov al, [rsi]
 test al, al
 jz .no_input
 inc rsi
 cmp al, '"'
 jne .skip_exe_quoted
 jmp .skip_spaces

.skip_exe_plain:
 mov al, [rsi]
 test al, al
 jz .no_input
 cmp al, ' '
 je .skip_spaces
 cmp al, 9
 je .skip_spaces
 inc rsi
 jmp .skip_exe_plain

.skip_spaces:
 mov al, [rsi]
 cmp al, ' '
 je .space_advance
 cmp al, 9
 jne .input_start
.space_advance:
 inc rsi
 jmp .skip_spaces

.input_start:
 test al, al
 jz .no_input
 lea rdi, [rel arg_input]
 xor rbx, rbx
 cmp al, '"'
 jne .copy_plain
 inc rsi

.copy_quoted:
 cmp rbx, 511
 jae .finish_input
 mov al, [rsi]
 test al, al
 jz .finish_input
 cmp al, '"'
 je .finish_input_advance
 mov [rdi + rbx], al
 inc rbx
 inc rsi
 jmp .copy_quoted

.copy_plain:
 cmp rbx, 511
 jae .finish_input
 mov al, [rsi]
 test al, al
 jz .finish_input
 cmp al, ' '
 je .finish_input
 cmp al, 9
 je .finish_input
 mov [rdi + rbx], al
 inc rbx
 inc rsi
 jmp .copy_plain

.finish_input_advance:
 inc rsi
.finish_input:
 mov byte [rdi + rbx], 0
 test rbx, rbx
 jz .no_input


 lea rdi, [rel arg_output]
 mov byte [rdi], 0
 mov eax, 1
 pop rdi
 pop rsi
 pop rbx
 ret

.no_input:
 xor eax, eax
 pop rdi
 pop rsi
 pop rbx
 ret




strcpy_n:
 xor rax, rax
.loop:
 cmp rax, rsi
 jge .done
 mov r9b, [rdx + rax]
 mov [rcx + rax], r9b
 test r9b, r9b
 jz .done
 inc rax
 jmp .loop
.done:
 ret



