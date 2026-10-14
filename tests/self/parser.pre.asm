%line 9+1 parser\parser.asm
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

%line 15+1 parser\parser.asm
[section .data]
 par_error_msg db "Parser: estructura invalida", 0
 tn_eof db "fin de archivo", 0
 tn_ident db "identificador", 0
 tn_int db "numero entero", 0
 tn_float db "numero decimal", 0
 tn_string db "cadena de texto", 0
 tn_lbrace db "'{'", 0
 tn_rbrace db "'}'", 0
 tn_lparen db "'('", 0
 tn_rparen db "')'", 0
 tn_lbrack db "'['", 0
 tn_rbrack db "']'", 0
 tn_semi db "';'", 0
 tn_colon db "':'", 0
 tn_comma db "','", 0
 tn_assign db "'='", 0
 tn_arrow db "'->'", 0
 tn_kw db "palabra clave", 0
 tn_op db "operador", 0
 tn_unknown db "token", 0

[section .bss]
 par_tokens resq 1
 par_token_count resq 1
 par_pos resq 1
 par_last_array_len resq 1
 par_cfg_depth resq 1
 par_last_ptr_elem resq 1
 par_last_is_float resq 1
 pending_ret_float resw 1
 par_ast_buf resq 1
 par_arena_ptr resq 1
 par_arena_end resq 1
 par_ast_root resq 1

[section .text]
[global jup_parser_init]
[global jup_parser_run]
[global parser_get_error]
[global parser_get_error_token]
[global parser_get_error_line]
[global token_name]
[global parser_get_position]
[global parser_get_ast_root]




jup_parser_init:
 mov [rel par_tokens], rdi
 mov [rel par_token_count], rsi
 mov [rel par_ast_buf], rdx
 mov [rel par_arena_ptr], rdx
 add rcx, rdx
 mov [rel par_arena_end], rcx
 xor rax, rax
 mov [rel par_pos], rax
 mov [rel par_ast_root], rax
 mov rax, 1
 ret





ast_alloc:
 mov rax, [rel par_arena_ptr]
 lea rcx, [rax + 48]
 cmp rcx, [rel par_arena_end]
 ja .oom
 mov [rel par_arena_ptr], rcx
 mov qword [rax + 0], 0
 mov qword [rax + 8], 0
 mov qword [rax + 16], 0
 mov qword [rax + 24], 0
 mov qword [rax + 32], 0
 mov qword [rax + 40], 0
 mov [rax + 0], rdi
 ret
.oom:
 xor rax, rax
 ret




par_current_token:
 mov rax, [rel par_pos]
 mov rcx, [rel par_token_count]
 cmp rax, rcx
 jl .valid
 lea rax, [rel eof_token]
 ret
.valid:
 mov rcx, [rel par_tokens]
 imul rax, 24
 add rax, rcx
 ret

eof_token:
 dq 0
 dq 0
 dd 0
 dw 0
 dw 0


par_cur_type:
 call par_current_token
 mov rax, [rax + 0]
 ret

par_advance:
 mov rax, [rel par_pos]
 inc rax
 mov [rel par_pos], rax
 ret




jup_parser_run:
 push r12
 push r13
 push r14
 xor rax, rax
 mov [rel par_pos], rax

 mov rdi, 1000
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [rel par_ast_root], rax

.loop:
 call par_cur_type
 cmp rax, 0
 je .done
 call parse_top_level
 test rax, rax
 jz .err
 mov r14, rax
 cmp qword [r13 + 8], 0
 jne .newnode
 mov [r13 + 8], r14
 jmp .loop
.newnode:
 mov rdi, 1000
 call ast_alloc
 test rax, rax
 jz .err
 mov [r13 + 16], rax
 mov r13, rax
 mov [r13 + 8], r14
 jmp .loop

.done:
 mov rax, 1
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r14
 pop r13
 pop r12
 ret




parse_top_level:
 call par_cur_type
 cmp rax, 102
 je .fn
 cmp rax, 100
 je .global_var
 cmp rax, 101
 je .global_var
 cmp rax, 119
 je .struct_def
 cmp rax, 500
 je .isa
 cmp rax, 200
 je .boot
 cmp rax, 201
 je .mmu
 cmp rax, 207
 je .isr
 cmp rax, 208
 je .cfg
 cmp rax, 206
 je .cfg
 cmp rax, 503
 je .cfg
 cmp rax, 504
 je .cfg
 cmp rax, 204
 je .cfg
 cmp rax, 205
 je .cfg
 cmp rax, 508
 je .cfg
 cmp rax, 505
 je .cfg
 cmp rax, 509
 je .cfg
 cmp rax, 531
 je .cfg
 cmp rax, 501
 je .cfg
 cmp rax, 507
 je .cfg

 cmp rax, 306
 je .cfg
 cmp rax, 305
 je .cfg
 cmp rax, 304
 je .cfg
 cmp rax, 300
 je .cfg
 cmp rax, 301
 je .cfg
 cmp rax, 302
 je .cfg

 cmp rax, 303
 je .cfg
 cmp rax, 400
 je .cfg
 cmp rax, 401
 je .cfg
 cmp rax, 402
 je .cfg
 cmp rax, 403
 je .cfg
 cmp rax, 404
 je .cfg
 cmp rax, 405
 je .cfg
 cmp rax, 406
 je .cfg
 cmp rax, 407
 je .cfg
 cmp rax, 408
 je .cfg

 cmp rax, 502
 je .cfg
 cmp rax, 506
 je .cfg
 cmp rax, 209
 je .cfg
 cmp rax, 202
 je .sched
 cmp rax, 203
 je .sys


 push r12
 push r13
 call par_current_token
 mov r12, rax
 call par_advance

 call par_cur_type
 cmp rax, 1
 jne .no_name
 call par_current_token
 mov r13, rax
 call par_advance
 jmp .rest
.no_name:
 xor r13, r13
.rest:
 call parse_generic_decl
 test rax, rax
 jz .err_mod
 mov rdi, 1024
 call ast_alloc
 test rax, rax
 jz .err_mod
 mov [rax + 24], r12
 mov [rax + 8], r13
 pop r13
 pop r12
 ret
.err_mod:
 pop r13
 pop r12
 xor rax, rax
 ret
.fn:
 call parse_function_ast
 ret
.global_var:

 call parse_statement_ast
 ret
.struct_def:
 call parse_struct_ast
 ret
.isa:
 call parse_isa_ast
 ret
.boot:
 call parse_boot_ast
 ret
.mmu:
 call parse_mmu_ast
 ret
.isr:
 call parse_isr_ast
 ret
.cfg:
 call parse_config_ast
 ret
.sched:
 call parse_sched_ast
 ret
.sys:
 call parse_sys_ast
 ret
.err:
 xor rax, rax
 ret










parse_sys_ast:
 push r12
 push r13
 push r14
 push r15
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1040
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 xor r14, r14

.body:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .skip
 call par_current_token
 mov rsi, [rax + 8]
 mov edx, dword [rax + 16]


 cmp edx, 7
 jne .try_par
 cmp dword [rsi], 'serv'
 jne .try_par
 cmp dword [rsi+3], 'vice'
 jne .try_par
 call par_advance
 call par_cur_type
 cmp rax, 5
 je .svc_num
 cmp rax, 2
 je .svc_num
 jmp .err
.svc_num:
 mov rdi, 1041
 call ast_alloc
 test rax, rax
 jz .err
 mov r15, rax
 call par_current_token
 mov [r15 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov [r15 + 8], rax
 call par_advance

 call par_cur_type
 cmp rax, 1
 jne .err
 call par_advance

 call parse_block_ast
 test rax, rax
 jz .err
 mov [r15 + 16], rax
 test r14, r14
 jnz .schain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .body
.schain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .body

.try_par:

 cmp edx, 9
 jne .try_rest
 cmp dword [rsi], 'mech'
 jne .try_rest
 cmp dword [rsi+5], 'nism'
 jne .try_rest
 call par_advance
 call par_cur_type
 cmp rax, 20
 jne .body
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .body
 call par_current_token
 mov rsi, [rax + 8]
 mov edx, dword [rax + 16]
 cmp edx, 12
 jne .mech_done
 cmp dword [rsi], 'sysc'
 jne .mech_done
 cmp dword [rsi+4], 'all_'
 jne .mech_done
 cmp dword [rsi+8], 'fast'
 jne .mech_done
 mov qword [r13 + 40], 1
.mech_done:
 call par_advance
 jmp .body

.try_rest:

 call par_cur_type
 cmp rax, 10
 je .skipblk
 call par_advance
 jmp .body
.skip:
 call par_cur_type
 cmp rax, 10
 je .skipblk
 call par_advance
 jmp .body
.skipblk:
 call parse_generic_block
 test rax, rax
 jz .err
 jmp .body

.close:
 call par_advance
 mov rax, r13
 pop r15
 ret
.err:
 xor rax, rax
 pop r15
 ret









parse_sched_ast:
 push r12
 push r13
 push r14
 push r15
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
.pre:
 call par_cur_type
 cmp rax, 10
 je .open
 cmp rax, 0
 je .err
 call par_advance
 jmp .pre
.open:
 call par_advance
 mov rdi, 1039
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 xor r14, r14

.body:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .skip

 mov rdi, 1038
 call ast_alloc
 test rax, rax
 jz .err
 mov r15, rax
 call par_current_token
 mov [r15 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 20
 jne .maybe_block
 call par_advance
 call par_cur_type
 cmp rax, 5
 je .sval
 cmp rax, 2
 je .sval
 cmp rax, 1
 je .sval
 cmp rax, 4
 je .sval
 cmp rax, 113
 je .sval
 cmp rax, 114
 je .sval
 jmp .err
.sval:
 mov [r15 + 40], rax
 call par_current_token
 mov [r15 + 8], rax
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 test r14, r14
 jnz .schain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .body
.schain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .body

.maybe_block:

 call par_cur_type
 cmp rax, 10
 jne .body
 cmp qword [r13 + 8], 0
 jne .skipblk
 call parse_block_ast
 test rax, rax
 jz .err
 mov [r13 + 8], rax
 jmp .body

.skip:
 call par_cur_type
 cmp rax, 10
 je .skipblk
 cmp rax, 12
 je .skippar
 call par_advance
 jmp .body
.skipblk:
 call parse_generic_block
 test rax, rax
 jz .err
 jmp .body
.skippar:
 call consume_balanced_parens
 test rax, rax
 jz .err
 jmp .body

.close:
 call par_advance
 mov rax, r13
 pop r15
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r15
 pop r14
 pop r13
 pop r12
 ret







parse_config_ast:
 push r12
 push r13
 push r14
 push r15
 call par_current_token
 mov r15, rax
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1037
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 mov [r13 + 8], r15
 xor r14, r14
 mov qword [rel par_cfg_depth], 0

.body:
 call par_cur_type
 cmp rax, 11
 je .maybe_close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .skip


 mov rdi, 1038
 call ast_alloc
 test rax, rax
 jz .err
 mov r15, rax
 call par_current_token
 mov [r15 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 20
 jne .not_pair
 call par_advance
 call par_cur_type
 cmp rax, 5
 je .cval
 cmp rax, 2
 je .cval
 cmp rax, 1
 je .cval
 cmp rax, 4
 je .cval
 cmp rax, 113
 je .cval
 cmp rax, 114
 je .cval
 jmp .err
.cval:
 mov [r15 + 40], rax
 call par_current_token
 mov [r15 + 8], rax
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 test r14, r14
 jnz .cchain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .body
.cchain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .body

.not_pair:


 call par_cur_type
 cmp rax, 12
 je .h_params
 mov rdi, [r15 + 24]
 mov rsi, [rdi + 8]
 mov edx, dword [rdi + 16]
 cmp edx, 3
 jb .np_data
 cmp byte [rsi], 'o'
 jne .np_data
 cmp byte [rsi+1], 'n'
 jne .np_data
 cmp byte [rsi+2], '_'
 jne .np_data
 jmp .h_block
.h_params:
 call consume_balanced_parens
 test rax, rax
 jz .err
.h_block:
 call par_cur_type
 cmp rax, 10
 jne .body
 call parse_block_ast
 test rax, rax
 jz .err
 mov [r15 + 8], rax
 mov qword [r15 + 40], 0xFFFF
 test r14, r14
 jnz .h_chain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .body
.h_chain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .body

.np_data:

 call par_cur_type
 cmp rax, 10
 je .enter_block
 cmp rax, 12
 je .skippar
 jmp .body

.skip:
 call par_cur_type
 cmp rax, 10
 je .enter_block
 cmp rax, 12
 je .skippar
 call par_advance
 jmp .body
.enter_block:
 call par_advance
 inc qword [rel par_cfg_depth]
 jmp .body
.maybe_close:
 cmp qword [rel par_cfg_depth], 0
 je .close
 dec qword [rel par_cfg_depth]
 call par_advance
 jmp .body
.skippar:
 call consume_balanced_parens
 test rax, rax
 jz .err
 jmp .body

.close:
 call par_advance
 mov rax, r13
 pop r15
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r15
 pop r14
 pop r13
 pop r12
 ret






parse_isr_ast:
 push r12
 push r13
 push r14
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 xor r13, r13

.pre:
 call par_cur_type
 cmp rax, 10
 je .body
 cmp rax, 0
 je .err
 cmp rax, 5
 je .vec
 cmp rax, 2
 je .vec
 call par_advance
 jmp .pre
.vec:
 call par_current_token
 mov r13, rax
 call par_advance
 jmp .pre

.body:
 call parse_block_ast
 test rax, rax
 jz .err
 mov r14, rax
 mov rdi, 1036
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 24], r12
 mov [rax + 8], r13
 mov [rax + 16], r14
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r14
 pop r13
 pop r12
 ret





parse_mmu_ast:
 push r12
 push r13
 push r14
 push r15
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1034
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 xor r14, r14

.body:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .skip

 call par_current_token
 mov rsi, [rax + 8]
 mov edx, dword [rax + 16]
 cmp edx, 20
 jne .skip
 cmp dword [rsi], 'page'
 jne .skip
 cmp dword [rsi+4], '_tab'
 jne .skip
 cmp dword [rsi+8], 'le_h'
 jne .skip
 cmp dword [rsi+12], 'iera'
 jne .skip
 cmp dword [rsi+16], 'rchy'
 jne .skip
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance

.lvls:
 call par_cur_type
 cmp rax, 11
 je .lvls_end
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 2
 je .lv_ok
 cmp rax, 5
 je .lv_ok
 jmp .err
.lv_ok:
 mov rdi, 1035
 call ast_alloc
 test rax, rax
 jz .err
 mov r15, rax
 call par_current_token
 mov [r15 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 2
 je .en_ok
 cmp rax, 5
 je .en_ok
 jmp .err
.en_ok:
 call par_current_token
 mov [r15 + 8], rax
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 test r14, r14
 jnz .mchain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .lvls
.mchain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .lvls

.lvls_end:
 call par_advance
 jmp .body

.skip:
 call par_cur_type
 cmp rax, 10
 je .skipblk
 cmp rax, 12
 je .skippar
 call par_advance
 jmp .body
.skipblk:
 call parse_generic_block
 test rax, rax
 jz .err
 jmp .body
.skippar:
 call consume_balanced_parens
 test rax, rax
 jz .err
 jmp .body

.close:
 call par_advance
 mov rax, r13
 pop r15
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r15
 pop r14
 pop r13
 pop r12
 ret





parse_boot_ast:
 push r12
 push r13
 push r14
 push r15
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1032
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 xor r14, r14

.body:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .skip

 call par_current_token
 mov rsi, [rax + 8]
 mov edx, dword [rax + 16]
 cmp edx, 14
 jne .skip
 cmp dword [rsi], 'cpu_'
 jne .skip
 cmp dword [rsi+4], 'stat'
 jne .skip
 cmp dword [rsi+8], 'e_in'
 jne .skip
 cmp word [rsi+12], 'it'
 jne .skip
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance

.regs:
 call par_cur_type
 cmp rax, 11
 je .regs_end
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .err

 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 mov rdi, 1033
 call ast_alloc
 test rax, rax
 jz .err
 mov r15, rax
 call par_current_token
 mov [r15 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 5
 je .bval
 cmp rax, 2
 je .bval
 jmp .err
.bval:
 call par_current_token
 mov [r15 + 8], rax
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 test r14, r14
 jnz .bchain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .regs
.bchain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .regs

.regs_end:
 call par_advance
 jmp .body

.skip:
 call par_cur_type
 cmp rax, 10
 je .skipblk
 cmp rax, 12
 je .skippar
 call par_advance
 jmp .body
.skipblk:
 call parse_generic_block
 test rax, rax
 jz .err
 jmp .body
.skippar:
 call consume_balanced_parens
 test rax, rax
 jz .err
 jmp .body

.close:
 call par_advance
 mov rax, r13
 pop r15
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r15
 pop r14
 pop r13
 pop r12
 ret






parse_struct_ast:
 push r12
 push r13
 push r14
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1020
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 xor r14, r14
.fields:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .err
 mov rdi, 1058
 call ast_alloc
 test rax, rax
 jz .err
 push rax
 call par_current_token
 pop rdi
 mov [rdi + 24], rax
 test r14, r14
 jnz .chain
 mov [r13 + 16], rdi
 mov r14, rdi
 jmp .after
.chain:
 mov [r14 + 16], rdi
 mov r14, rdi
.after:
 call par_advance
 call par_cur_type
 cmp rax, 17
 jne .semi
 call par_advance

 call par_cur_type
 mov [r14 + 40], rax
 call parse_type
 test rax, rax
 jz .err
.semi:
 call par_cur_type
 cmp rax, 16
 jne .fields
 call par_advance
 jmp .fields
.close:
 call par_advance
 mov rax, r13
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r14
 pop r13
 pop r12
 ret






parse_param_list:
 push r12
 push r13
 call par_advance
 xor r12, r12
 xor r13, r13
.loop:
 call par_cur_type
 cmp rax, 13
 je .done
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .err
 mov rdi, 1056
 call ast_alloc
 test rax, rax
 jz .err
 push rax
 call par_current_token
 pop rdi
 mov [rdi + 24], rax

 test r13, r13
 jnz .chain
 mov r12, rdi
 mov r13, rdi
 jmp .after
.chain:
 mov [r13 + 16], rdi
 mov r13, rdi
.after:
 call par_advance
 call par_cur_type
 cmp rax, 17
 jne .sep
 call par_advance
 mov qword [rel par_last_is_float], 0
 call parse_type
 test rax, rax
 jz .err


 mov cx, word [rel par_last_is_float]
 mov [r13 + 38], cx
.sep:
 call par_cur_type
 cmp rax, 18
 jne .loop
 call par_advance
 jmp .loop
.done:
 call par_advance
 mov rax, r12
 pop r13
 pop r12
 ret
.err:
 mov rax, -1
 pop r13
 pop r12
 ret






parse_arg_list:
 push r12
 push r13
 push r14
 call par_advance
 xor r12, r12
 xor r13, r13
.loop:
 call par_cur_type
 cmp rax, 13
 je .done
 cmp rax, 0
 je .err
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r14, rax
 mov rdi, 1057
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 8], r14
 test r13, r13
 jnz .chain
 mov r12, rax
 mov r13, rax
 jmp .sep
.chain:
 mov [r13 + 16], rax
 mov r13, rax
.sep:
 call par_cur_type
 cmp rax, 18
 jne .loop
 call par_advance
 jmp .loop
.done:
 call par_advance
 mov rax, r12
 pop r14
 pop r13
 pop r12
 ret
.err:
 mov rax, -1
 pop r14
 pop r13
 pop r12
 ret






parse_isa_ast:
 push r12
 push r13
 push r14
 push r15
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1030
 call ast_alloc
 test rax, rax
 jz .err
 mov r13, rax
 mov [r13 + 24], r12
 xor r14, r14

.body:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .skip

 call par_current_token
 mov rsi, [rax + 8]
 mov edx, dword [rax + 16]
 cmp edx, 10
 jne .skip
 cmp dword [rsi], 'opco'
 jne .skip
 cmp dword [rsi+4], 'de_s'
 jne .skip
 cmp word [rsi+8], 'et'
 jne .skip
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance

.ops:
 call par_cur_type
 cmp rax, 11
 je .ops_end
 cmp rax, 0
 je .err
 cmp rax, 1
 jne .err
 mov rdi, 1031
 call ast_alloc
 test rax, rax
 jz .err
 mov r15, rax
 call par_current_token
 mov [r15 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 20
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 5
 je .val
 cmp rax, 2
 je .val
 jmp .err
.val:
 call par_current_token
 mov [r15 + 8], rax
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 test r14, r14
 jnz .chain
 mov [r13 + 16], r15
 mov r14, r15
 jmp .ops
.chain:
 mov [r14 + 16], r15
 mov r14, r15
 jmp .ops

.ops_end:
 call par_advance
 jmp .body

.skip:
 call par_cur_type
 cmp rax, 10
 je .skipblk
 call par_advance
 jmp .body
.skipblk:
 call parse_generic_block
 test rax, rax
 jz .err
 jmp .body

.close:
 call par_advance
 mov rax, r13
 pop r15
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r15
 pop r14
 pop r13
 pop r12
 ret





parse_function_ast:
 push r12
 push r13
 push r14
 push r15
 call par_advance


 xor r14, r14
 call par_cur_type
 cmp rax, 510
 je .vis_export
 cmp rax, 513
 je .vis_export
 cmp rax, 511
 je .vis_private
 cmp rax, 512
 je .vis_private
 jmp .get_name
.vis_export:
 mov r14, 1
 call par_advance
 jmp .get_name
.vis_private:
 call par_advance
.get_name:

 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance

 call par_cur_type
 cmp rax, 12
 jne .err
 call parse_param_list
 cmp rax, -1
 je .err
 mov r15, rax

 call par_cur_type
 cmp rax, 21
 je .rettype
 cmp rax, 17
 je .rettype
 jmp .body
.rettype:
 call par_advance
 mov qword [rel par_last_is_float], 0
 call parse_type
 test rax, rax
 jz .err
 mov cx, word [rel par_last_is_float]
 mov [rel pending_ret_float], cx
.body:
 call par_cur_type
 cmp rax, 10
 jne .err
 call parse_block_ast
 test rax, rax
 jz .err
 mov r13, rax
 mov rdi, 1001
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 24], r12
 mov [rax + 16], r13
 mov [rax + 8], r15
 mov [rax + 40], r14
 mov cx, word [rel pending_ret_float]
 mov [rax + 38], cx
 mov word [rel pending_ret_float], 0
 pop r15
 pop r14
 pop r13
 pop r12
 ret
.err:
 xor rax, rax
 pop r15
 pop r14
 pop r13
 pop r12
 ret






parse_statement_no_semi:
 push r12
 push r13
 call parse_expression_ast
 test rax, rax
 jz .nserr
 mov r12, rax
 call par_cur_type
 cmp rax, 20
 jne .nsdone
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .nserr
 mov r13, rax
 mov rdi, 1005
 call ast_alloc
 test rax, rax
 jz .nserr
 mov [rax + 8], r12
 mov [rax + 16], r13
 pop r13
 pop r12
 ret
.nsdone:
 mov rax, r12
 pop r13
 pop r12
 ret
.nserr:
 xor rax, rax
 pop r13
 pop r12
 ret

parse_block_ast:
 push r12
 push r13
 call par_advance
 mov rdi, 1002
 call ast_alloc
 test rax, rax
 jz .err
 mov r12, rax
 mov r13, rax
.loop:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .err
 call parse_statement_ast
 test rax, rax
 jz .err
 cmp qword [r13 + 8], 0
 jne .newnode
 mov [r13 + 8], rax
 jmp .loop
.newnode:
 push rax
 mov rdi, 1002
 call ast_alloc
 test rax, rax
 jz .err2
 pop rcx
 mov [rax + 8], rcx
 mov [r13 + 16], rax
 mov r13, rax
 jmp .loop
.err2:
 pop rcx
.err:
 xor rax, rax
 pop r13
 pop r12
 ret
.close:
 call par_advance
 mov rax, r12
 pop r13
 pop r12
 ret




parse_statement_ast:
 push r12
 push r13
 push r14
 push r15
 call par_cur_type

 cmp rax, 100
 je .var
 cmp rax, 520
 je .outbst
 cmp rax, 522
 je .pokest
 cmp rax, 537
 je .beepst
 cmp rax, 535
 je .savefilest
 cmp rax, 525
 je .poke8st
 cmp rax, 526
 je .poke16st
 cmp rax, 527
 je .poke32st
 cmp rax, 524
 je .asmst
 cmp rax, 101
 je .var
 cmp rax, 104
 je .ifst
 cmp rax, 108
 je .whilest
 cmp rax, 123
 je .forst
 cmp rax, 106
 je .loopst
 cmp rax, 103
 je .retst
 cmp rax, 111
 je .printst
 cmp rax, 124
 je .printcst
 cmp rax, 109
 je .breakst
 cmp rax, 110
 je .continuest
 cmp rax, 10
 je .nested
 cmp rax, 1
 je .check_syscall
 cmp rax, 32
 je .exprst
 jmp .err

.check_syscall:

 call par_current_token
 mov rsi, [rax + 8]
 mov edx, dword [rax + 16]
 cmp edx, 7
 jne .exprst
 cmp dword [rsi], 'sysc'
 jne .exprst
 cmp word [rsi+4], 'al'
 jne .exprst

 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .err
 call par_advance

 mov rdi, 29
 call ast_alloc
 test rax, rax
 jz .err
 mov r12, rax
 xor r13, r13
.sysargs:
 call par_cur_type
 cmp rax, 13
 je .syscall_end
 call parse_expression_ast
 test rax, rax
 jz .err

 push rax
 mov rdi, 1002
 call ast_alloc
 test rax, rax
 jz .err_pop_sys
 pop rcx
 mov [rax + 8], rcx

 test r13, r13
 jnz .link
 mov [r12 + 16], rax
 mov r13, rax
 jmp .argcount
.link:
 mov [r13 + 16], rax
 mov r13, rax
.argcount:
 inc qword [r12 + 24]
 call par_cur_type
 cmp rax, 18
 jne .syscall_end
 call par_advance
 jmp .sysargs
.err_pop_sys:
 pop rcx
 jmp .err
.syscall_end:
 call par_cur_type
 cmp rax, 13
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rax, r12
 pop r13
 pop r12
 ret


.var:
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 mov r12, rax
 call par_advance
 mov qword [rel par_last_array_len], 0
 mov qword [rel par_last_ptr_elem], 0
 mov qword [rel par_last_is_float], 0
 call par_cur_type
 cmp rax, 17
 jne .var_assign
 call par_advance

 xor r15, r15
 call par_cur_type
 cmp rax, 138
 je .mark_float
 cmp rax, 139
 je .mark_float
 cmp rax, 1
 jne .no_typetok
 call par_current_token
 mov r15, rax
 jmp .no_typetok
.mark_float:
 mov qword [rel par_last_is_float], 1
.no_typetok:
 call parse_type
 test rax, rax
 jz .err

 call par_cur_type
 cmp rax, 16
 jne .var_assign
 call par_advance
 mov r14, [rel par_last_array_len]
 mov rdi, 1003
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 24], r12
 mov qword [rax + 16], 0
 mov [rax + 8], r15
 mov [rax + 40], r14
 mov ecx, dword [rel par_last_ptr_elem]
 mov [rax + 32], ecx
 mov cx, word [rel par_last_is_float]
 mov [rax + 38], cx
 jmp .ret_ok
.var_assign:
 call par_cur_type
 cmp rax, 20
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1003
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 24], r12
 mov ecx, dword [rel par_last_ptr_elem]
 mov [rax + 32], ecx
 mov cx, word [rel par_last_is_float]
 mov [rax + 38], cx
 mov [rax + 16], r13
 jmp .ret_ok


.ifst:
 call par_advance
 call parse_opt_paren_expr_ast
 test rax, rax
 jz .err
 mov r12, rax
 call par_cur_type
 cmp rax, 10
 jne .err
 call parse_block_ast
 test rax, rax
 jz .err
 mov r13, rax

 call par_cur_type
 cmp rax, 105
 jne .if_noelse
 call par_advance
 call par_cur_type
 cmp rax, 104
 je .else_if
 cmp rax, 10
 jne .err
 call parse_block_ast
 test rax, rax
 jz .err
 jmp .if_build
.else_if:
 call parse_statement_ast
 test rax, rax
 jz .err
 jmp .if_build
.if_noelse:
 xor rax, rax
.if_build:
 push rax
 mov rdi, 1010
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 24], r12
 mov [rax + 8], r13
 mov [rax + 16], rcx
 jmp .ret_ok


.whilest:
 call par_advance
 call parse_opt_paren_expr_ast
 test rax, rax
 jz .err
 mov r12, rax
 call par_cur_type
 cmp rax, 10
 jne .err
 call parse_block_ast
 test rax, rax
 jz .err
 mov r13, rax
 mov rdi, 1011
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 24], r12
 mov [rax + 16], r13
 jmp .ret_ok


.loopst:
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call parse_block_ast
 test rax, rax
 jz .err
 mov r13, rax
 mov rdi, 1011
 call ast_alloc
 test rax, rax
 jz .err
 mov qword [rax + 24], 0
 mov [rax + 16], r13
 jmp .ret_ok


.forst:
 call par_advance
 call parse_statement_ast
 test rax, rax
 jz .err
 mov r12, rax
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 call parse_statement_no_semi
 test rax, rax
 jz .err
 mov r14, rax
 call par_cur_type
 cmp rax, 10
 jne .err
 call parse_block_ast
 test rax, rax
 jz .err
 mov r15, rax
 mov rcx, r15
.for_tail:
 cmp qword [rcx + 16], 0
 je .for_tail_done
 mov rcx, [rcx + 16]
 jmp .for_tail
.for_tail_done:
 cmp qword [rcx + 8], 0
 jne .for_append_node
 mov [rcx + 8], r14
 jmp .for_body_ready
.for_append_node:
 push rcx
 mov rdi, 1002
 call ast_alloc
 test rax, rax
 jz .err_pop_for
 pop rcx
 mov [rax + 8], r14
 mov [rcx + 16], rax
 jmp .for_body_ready
.err_pop_for:
 pop rcx
 jmp .err
.for_body_ready:
 mov rdi, 1011
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 24], r13
 mov [rax + 16], r15
 mov r13, rax
 mov rdi, 1002
 call ast_alloc
 test rax, rax
 jz .err
 push rax
 mov [rax + 8], r12
 mov rdi, 1002
 call ast_alloc
 test rax, rax
 jz .err_pop_for2
 mov [rax + 8], r13
 pop rcx
 mov [rcx + 16], rax
 mov rax, rcx
 jmp .ret_ok
.err_pop_for2:
 pop rcx
 jmp .err


.retst:
 call par_advance
 call par_cur_type
 cmp rax, 16
 je .ret_void
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1009
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 16], r13
 jmp .ret_ok
.ret_void:
 call par_advance
 mov rdi, 1009
 call ast_alloc
 test rax, rax
 jz .err
 jmp .ret_ok


.printst:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 13
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1025
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 16], r13
 jmp .ret_ok

.printcst:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 13
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1061
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 16], r13
 jmp .ret_ok


.outbst:
 mov r14, 1042
 jmp .two_args
.pokest:
 mov r14, 1044
 jmp .two_args
.beepst:
 mov r14, 1065
 jmp .two_args
.savefilest:
 mov r14, 1063
 jmp .three_args
.poke8st:
 mov r14, 1050
 jmp .two_args
.poke16st:
 mov r14, 1051
 jmp .two_args
.poke32st:
 mov r14, 1052
.two_args:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r12, rax
 call par_cur_type
 cmp rax, 18
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 13
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, r14
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 8], r12
 mov [rax + 16], r13
 jmp .ret_ok

.three_args:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r12, rax
 call par_cur_type
 cmp rax, 18
 jne .err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 18
 jne .err
 call par_advance
 push r12
 push r13
 call parse_expression_ast
 test rax, rax
 jz .err3pop
 mov r15, rax
 pop r13
 pop r12
 call par_cur_type
 cmp rax, 13
 jne .err
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, r14
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 8], r12
 mov [rax + 16], r13
 mov [rax + 24], r15
 jmp .ret_ok
.err3pop:
 pop r13
 pop r12
 jmp .err


.asmst:
 call par_advance
 call par_cur_type
 cmp rax, 10
 jne .err
 call par_advance
 mov rdi, 1046
 call ast_alloc
 test rax, rax
 jz .err
 mov r12, rax
 xor r13, r13
.asm_loop:
 call par_cur_type
 cmp rax, 11
 je .asm_end
 cmp rax, 0
 je .err
 cmp rax, 4
 jne .err
 mov rdi, 1018
 call ast_alloc
 test rax, rax
 jz .err
 mov r14, rax
 call par_current_token
 mov [r14 + 24], rax
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .asm_chain
 call par_advance
.asm_chain:
 test r13, r13
 jnz .asm_link
 mov [r12 + 16], r14
 mov r13, r14
 jmp .asm_loop
.asm_link:
 mov [r13 + 16], r14
 mov r13, r14
 jmp .asm_loop
.asm_end:
 call par_advance
 mov rax, r12
 jmp .ret_ok


.breakst:
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1013
 call ast_alloc
 jmp .ret_ok


.continuest:
 call par_advance
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1014
 call ast_alloc
 jmp .ret_ok


.nested:
 call parse_block_ast
 jmp .ret_ok


.exprst:
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r12, rax
 call par_cur_type
 cmp rax, 20
 jne .expr_semi
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 mov r13, rax
 call par_cur_type
 cmp rax, 16
 jne .err
 call par_advance
 mov rdi, 1005
 call ast_alloc
 test rax, rax
 jz .err
 mov [rax + 8], r12
 mov [rax + 16], r13
 jmp .ret_ok
.expr_semi:
 cmp rax, 16
 jne .err
 call par_advance
 mov rax, r12
 jmp .ret_ok

.err_pop:
 pop rcx
.err:
 xor rax, rax
.ret_ok:
 pop r15
 pop r14
 pop r13
 pop r12
 ret




parse_opt_paren_expr_ast:
 call par_cur_type
 cmp rax, 12
 je .paren
 jmp parse_expression_ast
.paren:
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .err
 push rax
 call par_cur_type
 cmp rax, 13
 jne .err_pop
 call par_advance
 pop rax
 ret
.err_pop:
 pop rax
.err:
 xor rax, rax
 ret




parse_type:
 mov qword [rel par_last_is_float], 0
 call par_cur_type
 cmp rax, 14
 je .arr_type
 cmp rax, 532
 je .ptr_type
 cmp rax, 1
 je .ok
 cmp rax, 130
 je .ok
 cmp rax, 131
 je .ok
 cmp rax, 132
 je .ok
 cmp rax, 133
 je .ok
 cmp rax, 134
 je .ok
 cmp rax, 135
 je .ok
 cmp rax, 136
 je .ok
 cmp rax, 137
 je .ok
 cmp rax, 138
 je .ok
 cmp rax, 139
 je .ok
 cmp rax, 140
 je .ok
 cmp rax, 141
 je .ok
 cmp rax, 142
 je .ok
 xor rax, rax
 ret
.ok:

 call par_cur_type
 cmp rax, 138
 je .ok_float
 cmp rax, 139
 je .ok_float
 call par_advance
 mov rax, 1
 ret
.ok_float:
 mov qword [rel par_last_is_float], 1
 call par_advance
 mov rax, 1
 ret


.ptr_type:
 mov qword [rel par_last_ptr_elem], 0
 call par_advance
 call par_cur_type
 cmp rax, 43
 jne .ptr_err
 call par_advance

 call par_cur_type
 call par_type_width
 test rax, rax
 jz .ptr_err
 mov [rel par_last_ptr_elem], rax
 call parse_type
 test rax, rax
 jz .ptr_err
 call par_cur_type
 cmp rax, 44
 jne .ptr_err
 call par_advance
 mov rax, 1
 ret
.ptr_err:
 mov qword [rel par_last_ptr_elem], 0
 xor rax, rax
 ret


.arr_type:
 mov qword [rel par_last_array_len], 0
 call par_advance


 call par_cur_type
 cmp rax, 138
 je .arr_mark_float
 cmp rax, 139
 jne .arr_no_float
.arr_mark_float:
 mov qword [rel par_last_is_float], 1
.arr_no_float:
 call parse_type
 test rax, rax
 jz .arr_err
 call par_cur_type
 cmp rax, 16
 jne .arr_err
 call par_advance
 call par_cur_type
 cmp rax, 2
 je .arr_len
 cmp rax, 5
 je .arr_len
 jmp .arr_err
.arr_len:
 call par_current_token
 push rax
 mov rdi, rax
 call tok_to_uint
 mov [rel par_last_array_len], rax
 pop rax
 call par_advance
 call par_cur_type
 cmp rax, 15
 jne .arr_err
 call par_advance
 mov rax, 1
 ret
.arr_err:
 mov qword [rel par_last_array_len], 0
 xor rax, rax
 ret


tok_to_uint:
 push rbx
 push rsi
 push rcx
 mov rsi, [rdi + 8]
 mov ecx, dword [rdi + 16]
 xor rax, rax
 test ecx, ecx
 jz .tu_done
 cmp ecx, 2
 jbe .tu_dec
 cmp byte [rsi], '0'
 jne .tu_dec
 mov bl, [rsi+1]
 cmp bl, 'x'
 je .tu_hex
 cmp bl, 'X'
 je .tu_hex
.tu_dec:
 xor rax, rax
.tu_dl:
 test ecx, ecx
 jz .tu_done
 movzx rbx, byte [rsi]
 cmp bl, '0'
 jb .tu_done
 cmp bl, '9'
 ja .tu_done
 sub bl, '0'
 imul rax, rax, 10
 add rax, rbx
 inc rsi
 dec ecx
 jmp .tu_dl
.tu_hex:
 add rsi, 2
 sub ecx, 2
 xor rax, rax
.tu_hl:
 test ecx, ecx
 jz .tu_done
 movzx rbx, byte [rsi]
 cmp bl, '0'
 jb .tu_done
 cmp bl, '9'
 ja .tu_haf
 sub bl, '0'
 jmp .tu_hadd
.tu_haf:
 or bl, 0x20
 cmp bl, 'a'
 jb .tu_done
 cmp bl, 'f'
 ja .tu_done
 sub bl, 'a' - 10
.tu_hadd:
 shl rax, 4
 add rax, rbx
 inc rsi
 dec ecx
 jmp .tu_hl
.tu_done:
 pop rcx
 pop rsi
 pop rbx
 ret





par_type_width:
 cmp rax, 130
 je .w1
 cmp rax, 134
 je .w1
 cmp rax, 140
 je .w1
 cmp rax, 131
 je .w2
 cmp rax, 135
 je .w2
 cmp rax, 132
 je .w4
 cmp rax, 136
 je .w4
 cmp rax, 138
 je .w4
 cmp rax, 133
 je .w8
 cmp rax, 137
 je .w8
 cmp rax, 139
 je .w8
 cmp rax, 1
 je .w8
 xor rax, rax
 ret
.w1:
 mov rax, 1
 ret
.w2:
 mov rax, 2
 ret
.w4:
 mov rax, 4
 ret
.w8:
 mov rax, 8
 ret



parse_expression_ast:
 jmp parse_logical_ast

parse_logical_ast:
 push r12
 push r13
 call parse_comparison_ast
 test rax, rax
 jz .err
 mov r12, rax
.loop:
 call par_cur_type
 mov r13, rax
 cmp r13, 47
 je .op
 cmp r13, 48
 je .op
 mov rax, r12
 pop r13
 pop r12
 ret
.op:
 call par_advance
 call parse_comparison_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1006
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 8], r12
 mov [rax + 16], rcx
 mov [rax + 24], r13
 mov r12, rax
 jmp .loop
.err_pop:
 pop rcx
.err:
 xor rax, rax
 pop r13
 pop r12
 ret

parse_comparison_ast:
 push r12
 push r13
 call parse_shift_ast
 test rax, rax
 jz .err
 mov r12, rax
.loop:
 call par_cur_type
 mov r13, rax
 cmp r13, 41
 je .op
 cmp r13, 42
 je .op
 cmp r13, 43
 je .op
 cmp r13, 44
 je .op
 cmp r13, 45
 je .op
 cmp r13, 46
 je .op
 mov rax, r12
 pop r13
 pop r12
 ret
.op:
 call par_advance
 call parse_shift_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1006
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 8], r12
 mov [rax + 16], rcx
 mov [rax + 24], r13
 mov r12, rax
 jmp .loop
.err_pop:
 pop rcx
.err:
 xor rax, rax
 pop r13
 pop r12
 ret

parse_shift_ast:
 push r12
 push r13
 call parse_additive_ast
 test rax, rax
 jz .err
 mov r12, rax
.loop:
 call par_cur_type
 mov r13, rax
 cmp r13, 39
 je .op
 cmp r13, 40
 je .op
 mov rax, r12
 pop r13
 pop r12
 ret
.op:
 call par_advance
 call parse_additive_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1006
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 8], r12
 mov [rax + 16], rcx
 mov [rax + 24], r13
 mov r12, rax
 jmp .loop
.err_pop:
 pop rcx
.err:
 xor rax, rax
 pop r13
 pop r12
 ret

parse_additive_ast:
 push r12
 push r13
 call parse_multiplicative_ast
 test rax, rax
 jz .err
 mov r12, rax
.loop:
 call par_cur_type
 mov r13, rax
 cmp r13, 30
 je .op
 cmp r13, 31
 je .op
 mov rax, r12
 pop r13
 pop r12
 ret
.op:
 call par_advance
 call parse_multiplicative_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1006
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 8], r12
 mov [rax + 16], rcx
 mov [rax + 24], r13
 mov r12, rax
 jmp .loop
.err_pop:
 pop rcx
.err:
 xor rax, rax
 pop r13
 pop r12
 ret

parse_multiplicative_ast:
 push r12
 push r13
 call parse_unary_ast
 test rax, rax
 jz .err
 mov r12, rax
.loop:
 call par_cur_type
 mov r13, rax
 cmp r13, 32
 je .op
 cmp r13, 33
 je .op
 cmp r13, 34
 je .op
 mov rax, r12
 pop r13
 pop r12
 ret
.op:
 call par_advance
 call parse_unary_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1006
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 8], r12
 mov [rax + 16], rcx
 mov [rax + 24], r13
 mov r12, rax
 jmp .loop
.err_pop:
 pop rcx
.err:
 xor rax, rax
 pop r13
 pop r12
 ret

parse_unary_ast:
 call par_cur_type
 cmp rax, 31
 je .un
 cmp rax, 49
 je .un
 cmp rax, 35
 je .addr_of
 cmp rax, 32
 je .deref
 cmp rax, 533
 je .call_indirect
 jmp parse_postfix_ast


.addr_of:
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 push rax
 call par_advance
 mov rdi, 1048
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 24], rcx
 ret


.deref:
 call par_advance
 call parse_unary_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1049
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 16], rcx
 ret






.call_indirect:
 push r12
 call par_advance
 call parse_primary_ast
 test rax, rax
 jz .ci_err
 mov r12, rax
 call par_cur_type
 cmp rax, 12
 jne .ci_err
 call parse_arg_list
 cmp rax, -1
 je .ci_err
 push rax
 mov rdi, 1060
 call ast_alloc
 test rax, rax
 jz .ci_err_pop
 pop rcx
 mov [rax + 16], rcx
 mov [rax + 8], r12
 pop r12
 ret
.ci_err_pop:
 pop rcx
.ci_err:
 pop r12
 xor rax, rax
 ret

.un:
 call par_advance
 call parse_unary_ast
 test rax, rax
 jz .err
 push rax
 mov rdi, 1007
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 16], rcx
 ret
.err_pop:
 pop rcx
.err:
 xor rax, rax
 ret


parse_postfix_ast:
 push r12
 call parse_primary_ast
 test rax, rax
 jz .err
 mov r12, rax
.loop:
 call par_cur_type
 cmp rax, 12
 je .call
 cmp rax, 14
 je .index
 cmp rax, 19
 je .member
 mov rax, r12
 pop r12
 ret
.call:
 call parse_arg_list
 cmp rax, -1
 je .err
 push rax
 mov rdi, 1008
 call ast_alloc
 test rax, rax
 jz .err_pop
 pop rcx
 mov [rax + 16], rcx

 mov rcx, [r12 + 24]
 mov [rax + 24], rcx
 mov r12, rax
 jmp .loop
.err_pop:
 pop rcx
 jmp .err
.index:
 call consume_balanced_brackets
 test rax, rax
 jz .err
 jmp .loop
.member:
 call par_advance
 call par_cur_type
 cmp rax, 1
 jne .err
 call par_current_token
 push rax
 call par_advance
 mov rdi, 1059
 call ast_alloc
 test rax, rax
 jz .mem_err
 pop rcx
 mov [rax + 8], rcx
 mov rcx, [r12 + 24]
 mov [rax + 24], rcx
 mov r12, rax
 jmp .loop
.mem_err:
 pop rcx
 jmp .err
.err:
 xor rax, rax
 pop r12
 ret

parse_primary_ast:
 call par_cur_type
 cmp rax, 536
 je .readkey_expr
 cmp rax, 538
 je .readmouse_expr
 cmp rax, 539
 je .mousex_expr
 cmp rax, 540
 je .mousey_expr
 cmp rax, 521
 je .inb_expr
 cmp rax, 523
 je .peek_expr
 cmp rax, 534
 je .trunc_expr
 cmp rax, 528
 je .peek8_expr
 cmp rax, 529
 je .peek16_expr
 cmp rax, 530
 je .peek32_expr
 cmp rax, 2
 je .int_lit
 cmp rax, 2
 je .int_lit
 cmp rax, 5
 je .int_lit
 cmp rax, 3
 je .float_lit
 cmp rax, 4
 je .str_lit
 cmp rax, 6
 je .bool_lit
 cmp rax, 1
 je .ident
 cmp rax, 12
 je .paren
 cmp rax, 14
 je .array
 xor rax, rax
 ret


.readmouse_expr:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .perr
 call par_advance
 call par_cur_type
 cmp rax, 13
 jne .perr
 call par_advance
 mov rdi, 1066
 call ast_alloc
 test rax, rax
 jz .perr
 ret
.mousex_expr:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .perr
 call par_advance
 call par_cur_type
 cmp rax, 13
 jne .perr
 call par_advance
 mov rdi, 1067
 call ast_alloc
 test rax, rax
 jz .perr
 ret
.mousey_expr:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .perr
 call par_advance
 call par_cur_type
 cmp rax, 13
 jne .perr
 call par_advance
 mov rdi, 1068
 call ast_alloc
 test rax, rax
 jz .perr
 ret
.readkey_expr:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .perr
 call par_advance
 call par_cur_type
 cmp rax, 13
 jne .perr
 call par_advance
 mov rdi, 1064
 call ast_alloc
 test rax, rax
 jz .perr
 ret
.inb_expr:
 push r12
 mov r12, 1043
 jmp .one_arg
.peek_expr:
 push r12
 mov r12, 1045
 jmp .one_arg
.trunc_expr:
 push r12
 mov r12, 1062
 jmp .one_arg
.peek8_expr:
 push r12
 mov r12, 1053
 jmp .one_arg
.peek16_expr:
 push r12
 mov r12, 1054
 jmp .one_arg
.peek32_expr:
 push r12
 mov r12, 1055
.one_arg:
 call par_advance
 call par_cur_type
 cmp rax, 12
 jne .one_err
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .one_err
 push rax
 call par_cur_type
 cmp rax, 13
 jne .one_err_pop
 call par_advance
 mov rdi, r12
 call ast_alloc
 test rax, rax
 jz .one_err_pop
 pop rdx
 mov [rax + 16], rdx
 pop r12
 ret
.one_err_pop:
 pop rdx
.one_err:
 xor rax, rax
 pop r12
 ret

.int_lit:
 call par_current_token
 mov rdx, rax
 call par_advance
 push rdx
 mov rdi, 1016
 call ast_alloc
 test rax, rax
 jz .oom1
 pop rdx
 mov [rax + 24], rdx
 ret
.oom1:
 pop rdx
 xor rax, rax
 ret

.float_lit:
 call par_current_token
 mov rdx, rax
 call par_advance
 push rdx
 mov rdi, 1017
 call ast_alloc
 test rax, rax
 jz .oom2
 pop rdx
 mov [rax + 24], rdx
 ret
.oom2:
 pop rdx
 xor rax, rax
 ret

.str_lit:
 call par_current_token
 mov rdx, rax
 call par_advance
 push rdx
 mov rdi, 1018
 call ast_alloc
 test rax, rax
 jz .oom3
 pop rdx
 mov [rax + 24], rdx
 ret
.oom3:
 pop rdx
 xor rax, rax
 ret

.bool_lit:
 call par_advance
 mov rdi, 1019
 call ast_alloc
 ret

.ident:
 call par_current_token
 mov rdx, rax
 call par_advance
 push rdx

 call par_cur_type
 cmp rax, 14
 je .idx
 mov rdi, 1015
 call ast_alloc
 test rax, rax
 jz .oom4
 pop rdx
 mov [rax + 24], rdx
 ret
.idx:
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .oom4
 push rax
 call par_cur_type
 cmp rax, 15
 jne .idx_err
 call par_advance
 mov rdi, 1047
 call ast_alloc
 test rax, rax
 jz .idx_err
 pop rdx
 mov [rax + 16], rdx
 pop rdx
 mov [rax + 24], rdx
 ret
.idx_err:
 pop rdx
 pop rdx
 xor rax, rax
 ret
.oom4:
 pop rdx
 xor rax, rax
 ret

.paren:
 call par_advance
 call parse_expression_ast
 test rax, rax
 jz .perr
 push rax
 call par_cur_type
 cmp rax, 13
 jne .perr_pop
 call par_advance
 pop rax
 ret
.perr_pop:
 pop rax
.perr:
 xor rax, rax
 ret

.array:
 call consume_balanced_brackets
 test rax, rax
 jz .aerr
 mov rdi, 1016
 call ast_alloc
 ret
.aerr:
 xor rax, rax
 ret




parse_generic_decl:
 call par_cur_type
 cmp rax, 0
 je .error
 cmp rax, 11
 je .error
 cmp rax, 10
 je .block
 cmp rax, 16
 je .semi
 cmp rax, 12
 je .parens
 cmp rax, 14
 je .brackets
 call par_advance
 jmp parse_generic_decl
.parens:
 call consume_balanced_parens
 test rax, rax
 jz .error
 jmp parse_generic_decl
.brackets:
 call consume_balanced_brackets
 test rax, rax
 jz .error
 jmp parse_generic_decl
.block:
 call parse_generic_block
 ret
.semi:
 call par_advance
 mov rax, 1
 ret
.error:
 xor rax, rax
 ret

parse_generic_block:
 call par_advance
.loop:
 call par_cur_type
 cmp rax, 11
 je .close
 cmp rax, 0
 je .error
 cmp rax, 10
 je .nested
 cmp rax, 12
 je .parens
 cmp rax, 14
 je .brackets
 call par_advance
 jmp .loop
.nested:
 call parse_generic_block
 test rax, rax
 jz .error
 jmp .loop
.parens:
 call consume_balanced_parens
 test rax, rax
 jz .error
 jmp .loop
.brackets:
 call consume_balanced_brackets
 test rax, rax
 jz .error
 jmp .loop
.close:
 call par_advance
 mov rax, 1
 ret
.error:
 xor rax, rax
 ret

consume_balanced_parens:
 call par_advance
.loop:
 call par_cur_type
 cmp rax, 13
 je .close
 cmp rax, 0
 je .error
 cmp rax, 12
 je .np
 cmp rax, 14
 je .nb
 cmp rax, 10
 je .nbr
 call par_advance
 jmp .loop
.np:
 call consume_balanced_parens
 test rax, rax
 jz .error
 jmp .loop
.nb:
 call consume_balanced_brackets
 test rax, rax
 jz .error
 jmp .loop
.nbr:
 call parse_generic_block
 test rax, rax
 jz .error
 jmp .loop
.close:
 call par_advance
 mov rax, 1
 ret
.error:
 xor rax, rax
 ret

consume_balanced_brackets:
 call par_advance
.loop:
 call par_cur_type
 cmp rax, 15
 je .close
 cmp rax, 0
 je .error
 cmp rax, 14
 je .nb
 cmp rax, 12
 je .np
 cmp rax, 10
 je .nbr
 call par_advance
 jmp .loop
.nb:
 call consume_balanced_brackets
 test rax, rax
 jz .error
 jmp .loop
.np:
 call consume_balanced_parens
 test rax, rax
 jz .error
 jmp .loop
.nbr:
 call parse_generic_block
 test rax, rax
 jz .error
 jmp .loop
.close:
 call par_advance
 mov rax, 1
 ret
.error:
 xor rax, rax
 ret




parser_get_error:
 lea rax, [rel par_error_msg]
 ret

parser_get_error_token:
 call par_current_token
 mov rax, [rax + 0]
 ret

parser_get_position:
 mov rax, [rel par_pos]
 ret


parser_get_error_line:
 call par_current_token
 movzx rax, word [rax + 20]
 ret


token_name:
 cmp rdi, 0
 je .n_eof
 cmp rdi, 1
 je .n_ident
 cmp rdi, 2
 je .n_int
 cmp rdi, 3
 je .n_float
 cmp rdi, 4
 je .n_string
 cmp rdi, 10
 je .n_lbrace
 cmp rdi, 11
 je .n_rbrace
 cmp rdi, 12
 je .n_lparen
 cmp rdi, 13
 je .n_rparen
 cmp rdi, 14
 je .n_lbrack
 cmp rdi, 15
 je .n_rbrack
 cmp rdi, 16
 je .n_semi
 cmp rdi, 17
 je .n_colon
 cmp rdi, 18
 je .n_comma
 cmp rdi, 20
 je .n_assign
 cmp rdi, 21
 je .n_arrow

 cmp rdi, 100
 jae .n_kw
 cmp rdi, 30
 jae .n_op
 lea rax, [rel tn_unknown]
 ret
.n_eof: lea rax, [rel tn_eof]
 ret
.n_ident: lea rax, [rel tn_ident]
 ret
.n_int: lea rax, [rel tn_int]
 ret
.n_float: lea rax, [rel tn_float]
 ret
.n_string: lea rax, [rel tn_string]
 ret
.n_lbrace: lea rax, [rel tn_lbrace]
 ret
.n_rbrace: lea rax, [rel tn_rbrace]
 ret
.n_lparen: lea rax, [rel tn_lparen]
 ret
.n_rparen: lea rax, [rel tn_rparen]
 ret
.n_lbrack: lea rax, [rel tn_lbrack]
 ret
.n_rbrack: lea rax, [rel tn_rbrack]
 ret
.n_semi: lea rax, [rel tn_semi]
 ret
.n_colon: lea rax, [rel tn_colon]
 ret
.n_comma: lea rax, [rel tn_comma]
 ret
.n_assign: lea rax, [rel tn_assign]
 ret
.n_arrow: lea rax, [rel tn_arrow]
 ret
.n_kw: lea rax, [rel tn_kw]
 ret
.n_op: lea rax, [rel tn_op]
 ret

parser_get_ast_root:
 mov rax, [rel par_ast_root]
 ret
