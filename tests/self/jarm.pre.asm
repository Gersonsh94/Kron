%line 17+1 jarm.asm
[bits 64]
[default rel]

%line 22+1 jarm.asm
[section .bss]
 arm_code resb 1048576
 arm_len resq 1

[section .text]

[global jarm_selftest]
[global jarm_init]
[global jarm_get_code]
[global jarm_get_size]
[global jarm_emit_word]

[global jarm_mov_imm]
[global jarm_mov_reg]
[global jarm_add_reg]
[global jarm_sub_reg]
[global jarm_mul_reg]
[global jarm_cmp_reg]
[global jarm_ldr_frame]
[global jarm_str_frame]
[global jarm_push_pair]
[global jarm_pop_pair]
[global jarm_prologue]
[global jarm_epilogue]
[global jarm_ret]
[global jarm_branch]
[global jarm_branch_cond]
[global jarm_call]
[global jarm_svc]
[global jarm_add_sp]
[global jarm_sub_sp]




















jarm_selftest:
 call jarm_init
 call jarm_prologue
 mov ecx, 32
 call jarm_sub_sp
 mov ecx, 0
 mov edx, 10
 call jarm_mov_imm
 mov ecx, 0
 mov edx, 8
 call jarm_str_frame
 mov ecx, 0
 mov edx, 32
 call jarm_mov_imm
 mov ecx, 1
 mov edx, 0
 call jarm_mov_reg
 mov ecx, 0
 mov edx, 8
 call jarm_ldr_frame
 mov ecx, 0
 mov edx, 0
 mov r8d, 1
 call jarm_add_reg
 mov ecx, 0
 mov edx, 1
 call jarm_cmp_reg
 call jarm_epilogue
 call jarm_ret
 mov rax, [rel arm_len]
 ret


jarm_init:
 mov qword [rel arm_len], 0
 ret

jarm_get_code:
 lea rax, [rel arm_code]
 ret

jarm_get_size:
 mov rax, [rel arm_len]
 ret





jarm_emit_word:
 push rbx
 push rdx
 mov rbx, [rel arm_len]
 lea rdx, [rel arm_code]
 mov [rdx + rbx], ecx
 add rbx, 4
 mov [rel arm_len], rbx
 pop rdx
 pop rbx
 ret





jarm_mov_imm:
 push rbx
 mov ebx, 0xD2800000
 and edx, 0xFFFF
 shl edx, 5
 or ebx, edx
 and ecx, 0x1F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret





jarm_mov_reg:
 push rbx
 mov ebx, 0xAA0003E0
 and edx, 0x1F
 shl edx, 16
 or ebx, edx
 and ecx, 0x1F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret








jarm_add_reg:
 push rbx
 mov ebx, 0x8B000000
 jmp jarm_arith_common
jarm_sub_reg:
 push rbx
 mov ebx, 0xCB000000
 jmp jarm_arith_common
jarm_mul_reg:
 push rbx
 mov ebx, 0x9B007C00
jarm_arith_common:
 mov eax, r8d
 and eax, 0x1F
 shl eax, 16
 or ebx, eax
 mov eax, edx
 and eax, 0x1F
 shl eax, 5
 or ebx, eax
 and ecx, 0x1F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret





jarm_cmp_reg:
 push rbx
 mov ebx, 0xEB00001F
 and edx, 0x1F
 shl edx, 16
 or ebx, edx
 and ecx, 0x1F
 shl ecx, 5
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret








jarm_ldr_frame:
 push rbx
 mov ebx, 0xF94003A0
 jmp jarm_frame_common
jarm_str_frame:
 push rbx
 mov ebx, 0xF90003A0
jarm_frame_common:
 shr edx, 3
 and edx, 0xFFF
 shl edx, 10
 or ebx, edx
 and ebx, 0xFFFFFFE0
 and ecx, 0x1F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret







jarm_push_pair:
 push rbx
 mov ebx, 0xA9BF03E0
 and edx, 0x1F
 shl edx, 10
 or ebx, edx
 and ecx, 0x1F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret



jarm_pop_pair:
 push rbx
 mov ebx, 0xA8C103E0
 and edx, 0x1F
 shl edx, 10
 or ebx, edx
 and ecx, 0x1F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret





jarm_sub_sp:
 push rbx
 mov ebx, 0xD10003FF
 jmp jarm_sp_common
jarm_add_sp:
 push rbx
 mov ebx, 0x910003FF
jarm_sp_common:
 and ecx, 0xFFF
 shl ecx, 10
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret






jarm_prologue:
 push rbx
 mov ecx, 29
 mov edx, 30
 call jarm_push_pair
 mov ecx, 0x910003FD
 call jarm_emit_word
 pop rbx
 ret

jarm_epilogue:
 push rbx
 mov ecx, 0x910003BF
 call jarm_emit_word
 mov ecx, 29
 mov edx, 30
 call jarm_pop_pair
 pop rbx
 ret


jarm_ret:
 mov ecx, 0xD65F03C0
 call jarm_emit_word
 ret


jarm_svc:
 mov ecx, 0xD4000001
 call jarm_emit_word
 ret









jarm_branch:
 push rbx
 mov ebx, 0x14000000
 and ecx, 0x03FFFFFF
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret

jarm_call:
 push rbx
 mov ebx, 0x94000000
 and ecx, 0x03FFFFFF
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret



jarm_branch_cond:
 push rbx
 mov ebx, 0x54000000
 and edx, 0x7FFFF
 shl edx, 5
 or ebx, edx
 and ecx, 0x0F
 or ebx, ecx
 mov ecx, ebx
 call jarm_emit_word
 pop rbx
 ret
