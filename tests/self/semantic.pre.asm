%line 8+1 semantic\semantic.asm
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

%line 35+1 semantic\semantic.asm
[section .bss]

 sym_table resq 4096
 sym_arena resq 1
 sym_arena_ptr resq 1
 sym_arena_end resq 1


 scope_stack resb (256 * 16)
 scope_depth resd 1
 scope_id_counter resd 1


 sem_had_error resb 1
 sem_error_line resq 1
 sem_error_msg resb 512
 sem_current_fn_type resd 1

[section .text]
[global jup_semantic_init]
[global jup_semantic_run]
[global jup_semantic_error_line]
[global symtab_insert]
[global symtab_lookup]
[global symtab_push_scope]
[global symtab_pop_scope]




jup_semantic_init:
 mov [rel sym_arena], rdi
 mov [rel sym_arena_ptr], rdi
 add rdi, rsi
 mov [rel sym_arena_end], rdi


 lea rdi, [rel sym_table]
 xor esi, esi
 mov edx, 4096 * 8
 call memset_fast


 xor eax, eax
 mov [rel scope_depth], eax
 mov [rel scope_id_counter], eax
 mov byte [rel sem_had_error], 0
 mov qword [rel sem_error_line], 0


 mov rdi, 0
 call symtab_push_scope

 xor eax, eax
 ret





symtab_push_scope:
 mov eax, [rel scope_depth]
 cmp eax, 256 - 1
 jge .overflow


 inc dword [rel scope_id_counter]
 mov ecx, [rel scope_id_counter]


 imul eax, 16
 lea rdx, [rel scope_stack]
 add rdx, rax

 mov [rdx + 0], ecx
 mov [rdx + 4], edi
 mov dword [rdx + 8], 0
 mov eax, [rel scope_depth]
 dec eax
 cmp eax, -1
 jl .no_parent
 mov [rdx + 12], eax
 jmp .done
.no_parent:
 mov dword [rdx + 12], -1

.done:
 inc dword [rel scope_depth]
 xor eax, eax
 ret

.overflow:
 mov rax, -1
 ret




symtab_pop_scope:
 mov eax, [rel scope_depth]
 test eax, eax
 jz .empty
 dec dword [rel scope_depth]
 xor eax, eax
 ret
.empty:
 mov rax, -1
 ret










symtab_insert:
 push r12
 push r13
 push r14
 push r15
 push rbx

 mov r12, rdi
 mov r13, rsi
 mov r14d, edx
 mov r15d, ecx
 mov rbx, r8


 mov rdi, r12
 mov rsi, r13
 call hash_fnv1a


 xor edx, edx
 mov ecx, 4096
 div ecx



 call sym_alloc_entry
 test rax, rax
 jz .error


 mov [rax + 0], r12
 mov dword [rax + 8], r13d
 mov [rax + 12], r14d
 mov eax, [rel scope_depth]
 dec eax
 push rax
 pop rcx

 imul eax, 16
 lea rcx, [rel scope_stack]
 add rcx, rax
 mov eax, [rcx]
 push rax

 call sym_alloc_entry_get_last
 pop rcx
 mov [rax + 16], ecx
 mov [rax + 20], r15d
 mov [rax + 24], rbx
 or dword [rax + 20], (1 << 4)


 lea rcx, [rel sym_table]
 imul rdx, 8
 add rcx, rdx
 mov r8, [rcx]
 mov [rax + 32], r8
 mov [rcx], rax


 push rax
 mov eax, [rel scope_depth]
 dec eax
 imul eax, 16
 lea rcx, [rel scope_stack]
 add rcx, rax
 inc dword [rcx + 8]
 pop rax

 pop rbx
 pop r15
 pop r14
 pop r13
 pop r12
 ret

.error:
 xor eax, eax
 pop rbx
 pop r15
 pop r14
 pop r13
 pop r12
 ret

sym_alloc_entry_get_last:
 mov rax, [rel sym_arena_ptr]
 sub rax, 64
 ret








symtab_lookup:
 push r12
 push r13
 push r14

 mov r12, rdi
 mov r13, rsi


 call hash_fnv1a

 xor edx, edx
 mov ecx, 4096
 div ecx



 lea rcx, [rel sym_table]
 imul rdx, 8
 add rcx, rdx
 mov r14, [rcx]

.search_loop:
 test r14, r14
 jz .not_found


 mov eax, dword [r14 + 8]
 cmp eax, r13d
 jne .next_entry

 push rdi
 push rsi
 push rcx
 mov rdi, [r14 + 0]
 mov rsi, r12
 mov rcx, r13
 call sem_memcmp_n
 pop rcx
 pop rsi
 pop rdi

 test eax, eax
 jnz .next_entry


 mov rax, r14
 pop r14
 pop r13
 pop r12
 ret

.next_entry:
 mov r14, [r14 + 32]
 jmp .search_loop

.not_found:
 xor eax, eax
 pop r14
 pop r13
 pop r12
 ret





sym_alloc_entry:
 mov rax, [rel sym_arena_ptr]
 mov rcx, rax
 add rcx, 64
 cmp rcx, [rel sym_arena_end]
 jg .oom


 push rdi
 push rsi
 push rdx
 push rcx
 mov rdi, rax
 xor esi, esi
 mov edx, 64
 call memset_fast
 pop rcx
 pop rdx
 pop rsi
 pop rdi

 mov rax, [rel sym_arena_ptr]
 mov [rel sym_arena_ptr], rcx
 ret

.oom:
 xor eax, eax
 ret








hash_fnv1a:
 mov rax, 0xcbf29ce484222325
 mov rcx, rsi
 test rcx, rcx
 jz .done

.loop:
 movzx edx, byte [rdi]
 xor rax, rdx
 imul rax, 0x100000001b3
 inc rdi
 dec rcx
 jnz .loop

.done:
 ret









sem_node_jtype:
 test rdi, rdi
 jz .t_i64
 movzx eax, word [rdi + 38]
 test eax, eax
 jnz .t_f64
 mov eax, dword [rdi + 32]
 test eax, eax
 jnz .t_ptr
 mov rax, [rdi + 8]
 test rax, rax
 jnz .t_struct
.t_i64:
 mov eax, 9
 ret
.t_f64:
 mov eax, 11
 ret
.t_ptr:
 mov eax, 16
 ret
.t_struct:
 mov eax, 13
 ret

jup_semantic_error_line:
 mov rax, [rel sem_error_line]
 ret

jup_semantic_run:
 push r12
 mov r12, rdi

 test r12, r12
 jz .error


 call sem_analyze_node

 cmp byte [rel sem_had_error], 0
 jne .error

 xor eax, eax
 pop r12
 ret

.error:
 mov rax, -1
 pop r12
 ret





sem_analyze_node:
 push r12
 push rbx

 mov r12, rdi
 test r12, r12
 jz .done

 mov rbx, [r12 + 0]

 cmp rbx, 1000
 je .program

 cmp rbx, 1001
 je .function

 cmp rbx, 1003
 je .var_decl

 cmp rbx, 1004
 je .const_decl

 cmp rbx, 1002
 je .block

 cmp rbx, 1005
 je .assign

 cmp rbx, 1006
 je .binop

 cmp rbx, 1007
 je .unop

 cmp rbx, 1008
 je .call

 cmp rbx, 1009
 je .ret_stmt


 cmp rbx, 1025
 je .stmt_right
 cmp rbx, 1061
 je .stmt_right
 cmp rbx, 1042
 je .stmt_lr
 cmp rbx, 1044
 je .stmt_lr
 cmp rbx, 1050
 je .stmt_lr
 cmp rbx, 1051
 je .stmt_lr
 cmp rbx, 1052
 je .stmt_lr
 cmp rbx, 1065
 je .stmt_lr
 cmp rbx, 1063
 je .stmt_save

 cmp rbx, 1010
 je .if_stmt

 cmp rbx, 1011
 je .while_stmt

 cmp rbx, 1012
 je .loop_stmt

 cmp rbx, 1047
 je .index_node
 cmp rbx, 1059
 je .member_node

 cmp rbx, 1015
 je .identifier

 cmp rbx, 1056
 je .param

 cmp rbx, 1022
 je .done

 cmp rbx, 1024
 je .hardware


 jmp .done

.program:

 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.function:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done

 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]
 mov rcx, rdx

 push r12
 mov r12, rsi
 mov r13, rcx
 mov rdi, r12
 mov rsi, r13
 mov rdx, 15
 mov rcx, (1 << 1)
 mov r8, 0
 call symtab_insert
 pop r12


 mov rdi, 1
 call symtab_push_scope


 mov rdi, [r12 + 8]
 call sem_analyze_node


 mov rdi, [r12 + 16]
 call sem_analyze_node

 call symtab_pop_scope
 jmp .done

.param:

 test r12, r12
 jz .done
 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .param_next
 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]
 push r12
 push rsi
 push rdx
 mov rdi, r12
 call sem_node_jtype
 mov r9d, eax
 pop rdx
 pop rsi
 mov rdi, rsi
 mov rsi, rdx
 mov edx, r9d
 mov rcx, 0
 mov r8, 0
 call symtab_insert
 pop r12
.param_next:
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.var_decl:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done

 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]

 push r12
 push rsi
 push rdx
 mov rdi, r12
 call sem_node_jtype
 mov r9d, eax
 pop rdx
 pop rsi
 mov rdi, rsi
 mov rsi, rdx
 mov edx, r9d
 mov rcx, 0
 mov r8, 0
 call symtab_insert
 pop r12


 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.const_decl:
 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done

 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]

 push r12
 mov rdi, rsi
 mov rsi, rdx
 mov edx, 9
 mov rcx, (1 << 0)
 mov r8, 0
 call symtab_insert
 pop r12

 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.block:
 mov rdi, 2
 call symtab_push_scope

 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node

 call symtab_pop_scope
 jmp .done

.assign:
 mov rdi, [r12 + 8]
 call sem_analyze_node

 mov rdi, [r12 + 8]
 call sem_check_lvalue

 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.binop:
.unop:
 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.call:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done

 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]

 push r12
 mov rdi, rsi
 mov rsi, rdx
 call symtab_lookup
 pop r12

 test rax, rax
 jnz .call_found



.call_found:

 mov rdi, [r12 + 8]
 call sem_analyze_node
 jmp .done

.ret_stmt:
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.stmt_right:

 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.stmt_lr:

 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.stmt_save:

 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 mov rdi, [r12 + 24]
 call sem_analyze_node
 jmp .done

.if_stmt:
 mov rdi, [r12 + 24]
 call sem_analyze_node
 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.while_stmt:
 mov rdi, [r12 + 24]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.loop_stmt:
 mov rdi, 2
 call symtab_push_scope


 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .loop_body

 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]
 push r12
 mov rdi, rsi
 mov rsi, rdx
 mov edx, 9
 mov rcx, 0
 mov r8, 0
 call symtab_insert
 pop r12

.loop_body:
 mov rdi, [r12 + 8]
 call sem_analyze_node
 mov rdi, [r12 + 16]
 call sem_analyze_node
 call symtab_pop_scope
 jmp .done

.index_node:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .idx_index
 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]
 push r12
 mov rdi, rsi
 mov rsi, rdx
 call symtab_lookup
 pop r12
 test rax, rax
 jnz .idx_index

 mov rdi, [r12 + 24]
 movzx rax, word [rdi + 20]
 mov [rel sem_error_line], rax
 mov byte [rel sem_had_error], 1
.idx_index:
 mov rdi, [r12 + 16]
 call sem_analyze_node
 jmp .done

.member_node:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done
 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]
 push r12
 mov rdi, rsi
 mov rsi, rdx
 call symtab_lookup
 pop r12

 jmp .done

.identifier:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done

 mov rsi, [rdi + 8]
 movzx rdx, dword [rdi + 16]

 push r12
 mov rdi, rsi
 mov rsi, rdx
 call symtab_lookup
 pop r12

 test rax, rax
 jnz .done

 mov rdi, [r12 + 24]
 movzx rax, word [rdi + 20]
 mov [rel sem_error_line], rax
 mov byte [rel sem_had_error], 1
 jmp .done

.hardware:

 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .done



 mov rdi, 3
 call symtab_push_scope
 mov rdi, [r12 + 16]
 call sem_analyze_node
 call symtab_pop_scope
 jmp .done

.done:
 pop rbx
 pop r12
 ret





sem_check_lvalue:
 test rdi, rdi
 jz .ok

 mov rax, [rdi + 0]
 cmp rax, 1015
 je .ok
 cmp rax, 1047
 je .ok
 cmp rax, 1059
 je .ok
 cmp rax, 1007
 je .ok


 mov byte [rel sem_had_error], 1

.ok:
 ret




memset_fast:
 push rdi
 push rcx
 push rax

 test rdx, rdx
 jz .done

 mov rax, 0
 mov rcx, rdx
 rep stosb

.done:
 pop rax
 pop rcx
 pop rdi
 ret




sem_memcmp_n:
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
