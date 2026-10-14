%line 12+1 lexer\lexer.asm
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

%line 18+1 lexer\lexer.asm
[section .data]


 kw_var db "var", 0
 kw_const db "const", 0
 kw_fn db "fn", 0
 kw_return db "return", 0
 kw_if db "if", 0
 kw_else db "else", 0
 kw_loop db "loop", 0
 kw_in db "in", 0
 kw_while db "while", 0
 kw_for db "for", 0
 kw_break db "break", 0
 kw_continue db "continue", 0
 kw_print db "print", 0
 kw_printc db "printc", 0
 kw_range db "range", 0
 kw_true db "true", 0
 kw_false db "false", 0
 kw_null db "null", 0
 kw_import db "import", 0
 kw_from db "from", 0
 kw_module db "module", 0
 kw_struct db "struct", 0
 kw_enum db "enum", 0
 kw_new db "new", 0
 kw_delete db "delete", 0
 kw_u8 db "uint8", 0
 kw_u16 db "uint16", 0
 kw_u32 db "uint32", 0
 kw_u64 db "uint64", 0
 kw_i8 db "int8", 0
 kw_i16 db "int16", 0
 kw_i32 db "int32", 0
 kw_i64 db "int64", 0
 kw_a_i8 db "i8", 0
 kw_a_i16 db "i16", 0
 kw_a_i32 db "i32", 0
 kw_a_i64 db "i64", 0
 kw_a_u8 db "u8", 0
 kw_a_u16 db "u16", 0
 kw_a_u32 db "u32", 0
 kw_a_u64 db "u64", 0
 kw_a_f32 db "f32", 0
 kw_a_f64 db "f64", 0
 kw_a_bool db "bool", 0
 kw_f32 db "real32", 0
 kw_f64 db "real64", 0
 kw_bool db "hardware_bit", 0
 kw_str db "utf8_stream", 0
 kw_void db "hardware_void", 0

 kw_boot_seq db "boot_sequence", 0
 kw_mmu_cfg db "mmu_configuration", 0
 kw_sched db "scheduler_domain", 0
 kw_syscall db "syscall_table", 0
 kw_fs_vol db "filesystem_volume", 0
 kw_net_kern db "network_kernel", 0
 kw_hw_drv db "hardware_driver", 0
 kw_isr db "interrupt_service_routine", 0
 kw_dma db "dma_channel_controller", 0
 kw_sec_ring db "security_ring", 0

 kw_gpu_pipe db "gpu_shader_pipeline", 0
 kw_j3d db "jupiter3d_context", 0
 kw_physics db "physics_world_simulation", 0
 kw_quantum db "quantum_circuit", 0
 kw_ai_infer db "ai_inference_accelerator", 0
 kw_neural db "neural_network", 0
 kw_tensor db "tensor_accelerator", 0

 kw_dna db "dna_storage_volume", 0
 kw_photonic db "photonic_tensor_core", 0
 kw_orbital db "orbital_mesh_topology", 0
 kw_plasma db "plasma_confinement_reactor", 0
 kw_nano_swarm db "nano_swarm_mesh", 0
 kw_rel_time db "relativistic_time_anchor", 0
 kw_zero_trust db "zero_trust_quantum_fabric", 0
 kw_neuro db "neuromorphic_mesh", 0
 kw_wetware db "synthetic_wetware_mesh", 0

 kw_jisa db "jupiter_isa_dynamic", 0
 kw_living_comp db "living_compiler", 0
 kw_exec_model db "execution_model", 0
 kw_kern_arch db "kernel_architecture", 0
 kw_sec_model db "security_model", 0
 kw_hypervisor db "jupiter_hypervisor", 0
 kw_deploy db "deployment_model", 0
 kw_hmi db "human_machine_interface", 0
 kw_power db "power_manager", 0
 kw_pkg_mgr db "package_manager", 0
 kw_exec_loader db "executable_loader", 0

 kw_outb db "outb", 0
 kw_inb db "inb", 0
 kw_poke db "poke", 0
 kw_peek db "peek", 0
 kw_trunc db "trunc", 0
 kw_savefile db "savefile", 0
 kw_readkey db "readkey", 0
 kw_beep db "beep", 0
 kw_readmouse db "readmouse", 0
 kw_mousex db "mousex", 0
 kw_mousey db "mousey", 0
 kw_asmblk db "asm", 0
 kw_ptr db "ptr", 0
 kw_poke8 db "poke8", 0
 kw_poke16 db "poke16", 0
 kw_poke32 db "poke32", 0
 kw_peek8 db "peek8", 0
 kw_peek16 db "peek16", 0
 kw_peek32 db "peek32", 0

 kw_call db "call", 0

 kw_vis_global db "global_visible", 0
 kw_vis_domain db "domain_isolated", 0
 kw_vis_enclave db "enclave_hidden", 0
 kw_vis_cluster db "inter_cluster_export", 0


 keyword_table:
 dq kw_var, 100
 dq kw_const, 101
 dq kw_fn, 102
 dq kw_return, 103
 dq kw_if, 104
 dq kw_else, 105
 dq kw_loop, 106
 dq kw_in, 107
 dq kw_while, 108
 dq kw_for, 123
 dq kw_break, 109
 dq kw_continue, 110
 dq kw_print, 111
 dq kw_printc, 124
 dq kw_range, 112
 dq kw_true, 113
 dq kw_false, 114
 dq kw_null, 115
 dq kw_import, 116
 dq kw_from, 117
 dq kw_module, 118
 dq kw_struct, 119
 dq kw_enum, 120
 dq kw_new, 121
 dq kw_delete, 122
 dq kw_u8, 130
 dq kw_u16, 131
 dq kw_u32, 132
 dq kw_u64, 133
 dq kw_i8, 134
 dq kw_i16, 135
 dq kw_i32, 136
 dq kw_i64, 137
 dq kw_a_i8, 134
 dq kw_a_i16, 135
 dq kw_a_i32, 136
 dq kw_a_i64, 137
 dq kw_a_u8, 130
 dq kw_a_u16, 131
 dq kw_a_u32, 132
 dq kw_a_u64, 133
 dq kw_a_f32, 138
 dq kw_a_f64, 139
 dq kw_a_bool, 140
 dq kw_f32, 138
 dq kw_f64, 139
 dq kw_bool, 140
 dq kw_str, 141
 dq kw_void, 142
 dq kw_boot_seq, 200
 dq kw_mmu_cfg, 201
 dq kw_sched, 202
 dq kw_syscall, 203
 dq kw_fs_vol, 204
 dq kw_net_kern, 205
 dq kw_hw_drv, 206
 dq kw_isr, 207
 dq kw_dma, 208
 dq kw_gpu_pipe, 300
 dq kw_j3d, 301
 dq kw_physics, 302
 dq kw_quantum, 303
 dq kw_dna, 400
 dq kw_photonic, 401
 dq kw_orbital, 402
 dq kw_plasma, 403
 dq kw_nano_swarm, 404
 dq kw_rel_time, 405
 dq kw_zero_trust, 406
 dq kw_neuro, 407
 dq kw_wetware, 408
 dq kw_jisa, 500
 dq kw_living_comp, 501
 dq kw_exec_model, 502
 dq kw_kern_arch, 503
 dq kw_sec_model, 504
 dq kw_hypervisor, 505
 dq kw_deploy, 506
 dq kw_hmi, 507
 dq kw_power, 508
 dq kw_pkg_mgr, 509
 dq kw_exec_loader, 531
 dq kw_tensor, 306
 dq kw_neural, 305
 dq kw_ai_infer, 304
 dq kw_sec_ring, 209
 dq kw_outb, 520
 dq kw_inb, 521
 dq kw_poke, 522
 dq kw_peek, 523
 dq kw_trunc, 534
 dq kw_savefile, 535
 dq kw_readkey, 536
 dq kw_beep, 537
 dq kw_readmouse,538
 dq kw_mousex, 539
 dq kw_mousey, 540
 dq kw_asmblk, 524
 dq kw_ptr, 532
 dq kw_poke8, 525
 dq kw_poke16, 526
 dq kw_poke32, 527
 dq kw_peek8, 528
 dq kw_peek16, 529
 dq kw_peek32, 530
 dq kw_vis_global, 510
 dq kw_vis_domain, 511
 dq kw_vis_enclave, 512
 dq kw_vis_cluster, 513
 dq kw_call, 533
 dq 0, 0

 keyword_table_len equ ($ - keyword_table) / 16

[section .bss]

 lex_src resq 1
 lex_pos resq 1
 lex_len resq 1
 lex_line resw 1
 lex_col resw 1
 lex_tok_buf resq 1
 lex_tok_count resq 1
 lex_tok_count_ptr resq 1
 lex_tok_cap resq 1
 lex_error resb 256

[section .text]
[global jup_lexer_init]
[global jup_lexer_run]
[global lexer_next_token]
[global lexer_peek_token]
[global lexer_get_error]






jup_lexer_init:
 push rbp
 mov rbp, rsp
 mov [rel lex_src], rcx
 mov [rel lex_len], rdx
 mov [rel lex_tok_buf], r8
 mov [rel lex_tok_count_ptr], r9
 xor rax, rax
 mov [rel lex_pos], rax
 mov [rel lex_tok_count], rax
 mov qword [rel lex_tok_cap], ((2 * 1024 * 1024) / 24)
 test r9, r9
 jz .count_ready
 mov qword [r9], 0
.count_ready:
 mov word [rel lex_line], 1
 mov word [rel lex_col], 1
 mov rax, 1
 pop rbp
 ret






jup_lexer_run:
 push r12
 push r13
 push r14
 push r15
 push rbx

 xor r12, r12

.scan_loop:

 mov rbx, [rel lex_tok_cap]
 cmp r12, rbx
 jge .error



 mov [rel lex_tok_count], r12
 call lexer_next_token_internal
 cmp rax, -1
 je .error


 mov rbx, [rel lex_tok_buf]
 imul rcx, r12, 24
 add rbx, rcx
 mov rcx, [rbx + 0]
 cmp rcx, 0
 je .inc_and_done

 inc r12
 jmp .scan_loop

.inc_and_done:
 inc r12

.done:
 mov [rel lex_tok_count], r12
 mov rax, [rel lex_tok_count_ptr]
 test rax, rax
 jz .count_stored
 mov [rax], r12
.count_stored:
 mov rax, r12
 jmp .ret

.error:
 mov rax, -1

.ret:
 pop rbx
 pop r15
 pop r14
 pop r13
 pop r12
 ret






lexer_next_token_internal:
 push r12
 push r13
 push r14
 push rbx


 mov rax, [rel lex_tok_count]
 imul rax, 24
 mov r12, [rel lex_tok_buf]
 add r12, rax

.skip_whitespace:
 mov rax, [rel lex_pos]
 mov rbx, [rel lex_len]
 cmp rax, rbx
 jge .emit_eof

 mov r13, [rel lex_src]
 movzx r14d, byte [r13 + rax]


 cmp r14b, ' '
 je .advance_ws
 cmp r14b, 9
 je .advance_ws
 cmp r14b, 13
 je .advance_cr


 cmp r14b, 10
 je .newline


 cmp r14b, '/'
 je .check_comment

 jmp .dispatch_char

.advance_ws:
 inc qword [rel lex_pos]
 inc word [rel lex_col]
 jmp .skip_whitespace

.advance_cr:
 inc qword [rel lex_pos]
 jmp .skip_whitespace

.newline:
 inc qword [rel lex_pos]
 inc word [rel lex_line]
 mov word [rel lex_col], 1
 jmp .skip_whitespace

.check_comment:

 mov rax, [rel lex_pos]
 inc rax
 mov rbx, [rel lex_len]
 cmp rax, rbx
 jge .dispatch_char

 movzx ebx, byte [r13 + rax]
 cmp bl, '/'
 jne .dispatch_char


.comment_loop:
 inc qword [rel lex_pos]
 mov rax, [rel lex_pos]
 mov rbx, [rel lex_len]
 cmp rax, rbx
 jge .skip_whitespace

 movzx ebx, byte [r13 + rax]
 cmp bl, 10
 je .skip_whitespace
 jmp .comment_loop

.dispatch_char:

 mov rax, [rel lex_pos]
 mov [r12 + 8], r13
 mov r14d, [rel lex_line]


 movzx r14d, byte [r13 + rax]
 cmp r14b, '_'
 je .scan_ident
 cmp r14b, 'a'
 jl .not_lower
 cmp r14b, 'z'
 jle .scan_ident
.not_lower:
 cmp r14b, 'A'
 jl .not_upper
 cmp r14b, 'Z'
 jle .scan_ident
.not_upper:


 cmp r14b, '0'
 je .check_hex
 jl .not_digit
 cmp r14b, '9'
 jle .scan_number
.not_digit:


 cmp r14b, '"'
 je .scan_string


 cmp r14b, '0'
 je .check_hex


 jmp .scan_punct


.scan_ident:
 mov r13, [rel lex_src]
 mov rax, [rel lex_pos]
 mov rbx, rax


 add r13, rax

.ident_loop:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .ident_done

 mov r14, [rel lex_src]
 movzx r14d, byte [r14 + rax]


 cmp r14b, '_'
 je .ident_next
 cmp r14b, 'a'
 jl .ident_not_lower
 cmp r14b, 'z'
 jle .ident_next
.ident_not_lower:
 cmp r14b, 'A'
 jl .ident_not_upper
 cmp r14b, 'Z'
 jle .ident_next
.ident_not_upper:
 cmp r14b, '0'
 jl .ident_done
 cmp r14b, '9'
 jle .ident_next
 jmp .ident_done

.ident_next:
 inc qword [rel lex_pos]
 inc word [rel lex_col]
 jmp .ident_loop

.ident_done:

 mov rax, [rel lex_pos]
 sub rax, rbx
 mov dword [r12 + 16], eax


 mov rcx, [rel lex_src]
 add rcx, rbx
 mov [r12 + 8], rcx


 push rbx
 push r12
 mov rdi, rcx
 mov rsi, rax
 call lookup_keyword
 pop r12
 pop rbx

 cmp rax, -1
 je .is_identifier


 mov [r12 + 0], rax
 jmp .token_done

.is_identifier:
 mov qword [r12 + 0], 1
 jmp .token_done


.scan_number:
 mov r13, [rel lex_src]
 mov rax, [rel lex_pos]
 mov rbx, rax
 xor r14, r14

.number_loop:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .number_done

 mov r15, [rel lex_src]
 movzx r15d, byte [r15 + rax]

 cmp r15b, '0'
 jl .number_check_dot
 cmp r15b, '9'
 jle .number_next

.number_check_dot:
 cmp r15b, '.'
 jne .number_done

 mov r14, 1
 inc qword [rel lex_pos]
 jmp .number_loop

.number_next:
 inc qword [rel lex_pos]
 inc word [rel lex_col]
 jmp .number_loop

.number_done:
 mov rax, [rel lex_pos]
 sub rax, rbx
 mov dword [r12 + 16], eax

 mov rcx, [rel lex_src]
 add rcx, rbx
 mov [r12 + 8], rcx

 cmp r14, 1
 je .number_float
 mov qword [r12 + 0], 2
 jmp .token_done

.number_float:
 mov qword [r12 + 0], 3
 jmp .token_done


.check_hex:
 mov rax, [rel lex_pos]
 inc rax
 mov rbx, [rel lex_len]
 cmp rax, rbx
 jge .scan_number

 mov r13, [rel lex_src]
 movzx r14d, byte [r13 + rax]
 cmp r14b, 'x'
 je .scan_hex_literal
 cmp r14b, 'X'
 jne .scan_number

.scan_hex_literal:
 mov rbx, [rel lex_pos]
 inc qword [rel lex_pos]
 inc qword [rel lex_pos]

.hex_loop:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .hex_done

 mov r13, [rel lex_src]
 movzx r14d, byte [r13 + rax]


 cmp r14b, '0'
 jl .hex_done
 cmp r14b, '9'
 jle .hex_next
 cmp r14b, 'a'
 jl .hex_check_upper
 cmp r14b, 'f'
 jle .hex_next
.hex_check_upper:
 cmp r14b, 'A'
 jl .hex_done
 cmp r14b, 'F'
 jg .hex_done

.hex_next:
 inc qword [rel lex_pos]
 jmp .hex_loop

.hex_done:
 mov rax, [rel lex_pos]
 sub rax, rbx
 mov dword [r12 + 16], eax
 mov rcx, [rel lex_src]
 add rcx, rbx
 mov [r12 + 8], rcx
 mov qword [r12 + 0], 5
 jmp .token_done


.scan_string:
 mov rbx, [rel lex_pos]
 inc qword [rel lex_pos]

.str_loop:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .str_error

 mov r13, [rel lex_src]
 movzx r14d, byte [r13 + rax]

 cmp r14b, '"'
 je .str_done


 cmp r14b, '\'
 je .str_escape

 inc qword [rel lex_pos]
 jmp .str_loop

.str_escape:
 inc qword [rel lex_pos]
 inc qword [rel lex_pos]
 jmp .str_loop

.str_done:
 inc qword [rel lex_pos]
 mov rax, [rel lex_pos]
 sub rax, rbx
 mov dword [r12 + 16], eax
 mov rcx, [rel lex_src]
 add rcx, rbx
 mov [r12 + 8], rcx
 mov qword [r12 + 0], 4
 jmp .token_done

.str_error:
 mov rax, -1
 jmp .ret_error


.scan_punct:
 mov r13, [rel lex_src]
 mov rax, [rel lex_pos]
 movzx r14d, byte [r13 + rax]


 lea rcx, [r13 + rax]
 mov [r12 + 8], rcx
 mov dword [r12 + 16], 1

 inc qword [rel lex_pos]
 inc word [rel lex_col]

 cmp r14b, '{'
 je .punct_lbrace
 cmp r14b, '}'
 je .punct_rbrace
 cmp r14b, '('
 je .punct_lparen
 cmp r14b, ')'
 je .punct_rparen
 cmp r14b, '['
 je .punct_lbracket
 cmp r14b, ']'
 je .punct_rbracket
 cmp r14b, ';'
 je .punct_semi
 cmp r14b, ','
 je .punct_comma
 cmp r14b, '.'
 je .punct_dot
 cmp r14b, '+'
 je .punct_plus
 cmp r14b, '-'
 je .punct_minus
 cmp r14b, '*'
 je .punct_star
 cmp r14b, '/'
 je .punct_slash
 cmp r14b, '%'
 je .punct_percent
 cmp r14b, '&'
 je .punct_amp
 cmp r14b, '|'
 je .punct_pipe
 cmp r14b, '^'
 je .punct_caret
 cmp r14b, '~'
 je .punct_tilde
 cmp r14b, '!'
 je .check_neq
 cmp r14b, '='
 je .check_eq
 cmp r14b, '<'
 je .check_lt
 cmp r14b, '>'
 je .check_gt
 cmp r14b, ':'
 je .check_colon


 xor eax, eax
 jmp .token_done_ok

.punct_lbrace:
 mov qword [r12 + 0], 10
 jmp .token_done
.punct_rbrace:
 mov qword [r12 + 0], 11
 jmp .token_done
.punct_lparen:
 mov qword [r12 + 0], 12
 jmp .token_done
.punct_rparen:
 mov qword [r12 + 0], 13
 jmp .token_done
.punct_lbracket:
 mov qword [r12 + 0], 14
 jmp .token_done
.punct_rbracket:
 mov qword [r12 + 0], 15
 jmp .token_done
.punct_semi:
 mov qword [r12 + 0], 16
 jmp .token_done
.punct_comma:
 mov qword [r12 + 0], 18
 jmp .token_done
.punct_dot:
 mov qword [r12 + 0], 19
 jmp .token_done
.punct_plus:
 mov qword [r12 + 0], 30
 jmp .token_done
.punct_star:
 mov qword [r12 + 0], 32
 jmp .token_done
.punct_slash:
 mov qword [r12 + 0], 33
 jmp .token_done
.punct_percent:
 mov qword [r12 + 0], 34
 jmp .token_done
.punct_amp:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_amp
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '&'
 jne .just_amp
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 47
 jmp .token_done
.just_amp:
 mov qword [r12 + 0], 35
 jmp .token_done
.punct_pipe:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_pipe
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '|'
 jne .just_pipe
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 48
 jmp .token_done
.just_pipe:
 mov qword [r12 + 0], 36
 jmp .token_done
.punct_caret:
 mov qword [r12 + 0], 37
 jmp .token_done
.punct_tilde:
 mov qword [r12 + 0], 38
 jmp .token_done

.punct_minus:

 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_minus
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '>'
 jne .just_minus
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 21
 jmp .token_done
.just_minus:
 mov qword [r12 + 0], 31
 jmp .token_done

.check_eq:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_assign
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '='
 jne .just_assign
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 41
 jmp .token_done
.just_assign:
 mov qword [r12 + 0], 20
 jmp .token_done

.check_neq:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_not
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '='
 jne .just_not
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 42
 jmp .token_done
.just_not:
 mov qword [r12 + 0], 49
 jmp .token_done

.check_lt:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_lt
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '='
 je .lte
 cmp bl, '<'
 je .lshift
 jmp .just_lt
.lte:
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 45
 jmp .token_done
.lshift:
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 39
 jmp .token_done
.just_lt:
 mov qword [r12 + 0], 43
 jmp .token_done

.check_gt:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_gt
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, '='
 je .gte
 cmp bl, '>'
 je .rshift
 jmp .just_gt
.gte:
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 46
 jmp .token_done
.rshift:
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 40
 jmp .token_done
.just_gt:
 mov qword [r12 + 0], 44
 jmp .token_done

.check_colon:
 mov rax, [rel lex_pos]
 mov rcx, [rel lex_len]
 cmp rax, rcx
 jge .just_colon
 mov r13, [rel lex_src]
 movzx ebx, byte [r13 + rax]
 cmp bl, ':'
 jne .just_colon
 inc qword [rel lex_pos]
 mov dword [r12 + 16], 2
 mov qword [r12 + 0], 22
 jmp .token_done
.just_colon:
 mov qword [r12 + 0], 17
 jmp .token_done

.token_done:

 movzx eax, word [rel lex_line]
 mov word [r12 + 20], ax
 movzx eax, word [rel lex_col]
 mov word [r12 + 22], ax
 inc qword [rel lex_tok_count]

.token_done_ok:
 xor eax, eax
 jmp .ret_ok

.emit_eof:
 mov qword [r12 + 0], 0
 mov qword [r12 + 8], 0
 mov dword [r12 + 16], 0
 movzx eax, word [rel lex_line]
 mov word [r12 + 20], ax
 movzx eax, word [rel lex_col]
 mov word [r12 + 22], ax
 xor eax, eax
 jmp .ret_ok

.ret_error:
 pop rbx
 pop r14
 pop r13
 pop r12
 mov rax, -1
 ret

.ret_ok:
 pop rbx
 pop r14
 pop r13
 pop r12
 xor eax, eax
 ret







lookup_keyword:
 push rbx
 push r12
 push r13
 push r14
 push r15

 mov r12, rdi
 mov r13, rsi
 lea r14, [rel keyword_table]

.kw_loop:
 mov rbx, [r14]
 test rbx, rbx
 jz .not_found


 xor r15, r15
.strlen_loop:
 movzx eax, byte [rbx + r15]
 test al, al
 jz .strlen_done
 inc r15
 jmp .strlen_loop
.strlen_done:


 cmp r15, r13
 jne .next_kw


 push rdi
 push rsi
 push rcx
 mov rdi, r12
 mov rsi, rbx
 mov rcx, r13
 call lex_memcmp_n
 pop rcx
 pop rsi
 pop rdi

 test eax, eax
 jnz .next_kw


 mov rax, [r14 + 8]
 jmp .found

.next_kw:
 add r14, 16
 jmp .kw_loop

.not_found:
 mov rax, -1
.found:
 pop r15
 pop r14
 pop r13
 pop r12
 pop rbx
 ret








lex_memcmp_n:
 xor eax, eax
 test rcx, rcx
 jz .done
.loop:
 movzx edx, byte [rdi]
 movzx r8d, byte [rsi]
 cmp dl, r8b
 jne .different
 inc rdi
 inc rsi
 dec rcx
 jnz .loop
 xor eax, eax
 ret
.different:
 mov eax, 1
.done:
 ret





lexer_get_token_count:
 mov rax, [rel lex_tok_count]
 ret






lexer_get_token:
 imul rdi, 24
 mov rax, [rel lex_tok_buf]
 add rax, rdi
 ret





lexer_next_token:
 ret

lexer_peek_token:
 ret

lexer_get_error:
 lea rax, [rel lex_error]
 ret
