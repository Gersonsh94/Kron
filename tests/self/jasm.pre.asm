%line 11+1 jasm.asm
[bits 64]
[default rel]

%line 16+1 jasm.asm
[extern GetStdHandle]
[extern WriteFile]

[section .bss]

 jasm_code resb 1048576
 jasm_code_len resq 1
 jasm_data resb 262144
 jasm_data_len resq 1
 jasm_bss_len resq 1


 lbl_names resb 524288
 lbl_names_len resq 1
 lbl_name_off resd 16384
 lbl_addr resq 16384
 lbl_section resb 16384
 lbl_count resq 1


 fix_at resd 65536
 fix_label resd 65536
 fix_addend resd 65536
 fix_kind resb 65536
 fix_count resq 1
 cur_fix_kind resq 1
 data_base resq 1
 bss_base resq 1
 bss_cursor resq 1

 ext_names resb 4096
 ext_names_len resq 1
 ext_name_off resd 128
 ext_count resq 1

 extref_at resd 512
 extref_sym resd 512
 extref_count resq 1


 ext_map resd 128
 ext_used resd 128
 prn_new resq 1


 line_buf resb 1024
 lbl_rest resb 512
 tok_a resb 64
 tok_b resb 512
 tok_c resb 512

 cur_section resb 1
 jasm_pass resb 1
 jasm_error resb 1
 op_size resb 1
 db_quote resb 1
 db_phase resb 1
 dst_base resq 1
 src_base resq 1
 rex8_force resb 1
 dl_size resb 1
 expr_ptr resq 1
 last_label resb 64
 cur_global resb 64
 qual_buf resb 160
 sib_disp resd 1



 equ_names resb 262144
 equ_names_len resq 1
 equ_name_off resd 8192
 equ_value resq 8192
 equ_count resq 1
 dst_addend resq 1

 jasm_line resq 1
 jasm_err_line resq 1
 err_lines resd 64
 err_dst resd 64
 err_src resd 64
 err_count resq 1
 err_mnem resb 1024

 cur_addend resq 1
 dbg_written resq 1
 dbg_buf resb 8

[section .data]


 reg64_names:
 db "rax",0,0, "rcx",0,0, "rdx",0,0, "rbx",0,0
 db "rsp",0,0, "rbp",0,0, "rsi",0,0, "rdi",0,0
 db "r8",0,0,0, "r9",0,0,0, "r10",0,0, "r11",0,0
 db "r12",0,0, "r13",0,0, "r14",0,0, "r15",0,0
 reg32_names:
 db "eax",0,0, "ecx",0,0, "edx",0,0, "ebx",0,0
 db "esp",0,0, "ebp",0,0, "esi",0,0, "edi",0,0
 db "r8d",0,0, "r9d",0,0, "r10d",0, "r11d",0
 db "r12d",0, "r13d",0, "r14d",0, "r15d",0
 reg8_names:
 db "al",0,0,0, "cl",0,0,0, "dl",0,0,0, "bl",0,0,0
 db "spl",0,0, "bpl",0,0, "sil",0,0, "dil",0,0
 db "r8b",0,0, "r9b",0,0, "r10b",0, "r11b",0
 db "r12b",0, "r13b",0, "r14b",0, "r15b",0
 reg16_names:
 db "ax",0,0,0, "cx",0,0,0, "dx",0,0,0, "bx",0,0,0
 db "sp",0,0,0, "bp",0,0,0, "si",0,0,0, "di",0,0,0
 db "r8w",0,0, "r9w",0,0, "r10w",0, "r11w",0
 db "r12w",0, "r13w",0, "r14w",0, "r15w",0
 xmm_names:
 db "xmm0",0, "xmm1",0, "xmm2",0, "xmm3",0
 db "xmm4",0, "xmm5",0, "xmm6",0, "xmm7",0

[section .text]

[global jasm_init]


jdbg:
 push rbx
 push rcx
 push rdx
 push r8
 push r9
 push r10
 push r11
 sub rsp, 56
 mov [rel dbg_buf], al
 mov rcx, -11
 call GetStdHandle
 mov rcx, rax
 lea rdx, [rel dbg_buf]
 mov r8, 1
 lea r9, [rel dbg_written]
 mov qword [rsp+32], 0
 call WriteFile
 add rsp, 56
 pop r11
 pop r10
 pop r9
 pop r8
 pop rdx
 pop rcx
 pop rbx
 ret

[global jasm_assemble]
[global jasm_build_image]
[global jasm_get_code]
[global jasm_get_code_size]
[global jasm_get_data]
[global jasm_get_data_size]
[global jasm_get_bss_size]
[global jasm_find_label]
[global jasm_had_error]
[global jasm_get_error_line]
[global jasm_get_error_count]
[global jasm_get_error_line_at]
[global jasm_get_error_dst]
[global jasm_get_error_src]
[global jasm_get_error_mnem]
[global jasm_get_ext_count]
[global jasm_get_ext_name]
[global jasm_get_extref_count]
[global jasm_get_extref_at]
[global jasm_get_extref_sym]
[global jasm_label_addr]
[global jasm_get_fixup_count]
[global jasm_get_fixup_at]
[global jasm_get_fixup_label]
[global jasm_get_fixup_addend]
[global jasm_get_fixup_kind]
[global jasm_get_label_section]




jasm_init:
 mov qword [rel jasm_code_len], 0
 mov qword [rel jasm_data_len], 0
 mov qword [rel jasm_bss_len], 0
 mov qword [rel lbl_count], 0
 mov qword [rel lbl_names_len], 1
 mov byte [rel lbl_names], 0
 mov qword [rel fix_count], 0
 mov byte [rel cur_section], 0
 mov byte [rel jasm_error], 0
 mov qword [rel jasm_line], 0
 mov qword [rel jasm_err_line], 0
 mov qword [rel err_count], 0
 mov qword [rel equ_count], 0
 mov qword [rel equ_names_len], 0
 mov byte [rel cur_global], 0
 mov qword [rel ext_count], 0
 mov qword [rel ext_names_len], 1
 mov byte [rel ext_names], 0
 mov qword [rel extref_count], 0
 mov qword [rel jasm_bss_len], 0
 ret




jasm_build_image:
 push rbx
 push rsi
 push rdi
 mov rax, [rel jasm_code_len]
 mov rbx, [rel data_base]

 lea rdi, [rel jasm_code]
 add rdi, rax
.pad:
 cmp rax, rbx
 jae .pad_done
 mov byte [rdi], 0
 inc rdi
 inc rax
 jmp .pad
.pad_done:

 lea rsi, [rel jasm_data]
 mov rcx, [rel jasm_data_len]
.copy:
 test rcx, rcx
 jz .copy_done
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec rcx
 jmp .copy
.copy_done:
 mov rax, rbx
 add rax, [rel jasm_data_len]
 pop rdi
 pop rsi
 pop rbx
 ret

jasm_get_code:
 lea rax, [rel jasm_code]
 ret
jasm_get_code_size:
 mov rax, [rel jasm_code_len]
 ret
jasm_get_data:
 lea rax, [rel jasm_data]
 ret
jasm_get_data_size:
 mov rax, [rel jasm_data_len]
 ret
jasm_get_bss_size:
 mov rax, [rel jasm_bss_len]
 ret
jasm_get_error_count:
 mov rax, [rel err_count]
 ret



jasm_get_error_dst:
 lea rax, [rel err_dst]
 mov eax, [rax + rcx*4]
 ret


jasm_get_error_src:
 lea rax, [rel err_src]
 mov eax, [rax + rcx*4]
 ret

jasm_get_error_line_at:
 lea rax, [rel err_lines]
 mov eax, [rax + rcx*4]
 ret

jasm_get_error_line:
 mov rax, [rel jasm_err_line]
 ret

jasm_had_error:
 movzx eax, byte [rel jasm_error]
 ret


jasm_get_error_mnem:
 lea rax, [rel err_mnem]
 shl rcx, 4
 add rax, rcx
 ret




record_err_mnem:
 push rbx
 push rsi
 push rdi
 lea rdi, [rel err_mnem]
 shl rcx, 4
 add rdi, rcx
 lea rsi, [rel tok_a]
 xor ebx, ebx
.rem_cp:
 cmp ebx, 15
 jae .rem_end
 mov al, [rsi]
 test al, al
 jz .rem_end
 mov [rdi], al
 inc rsi
 inc rdi
 inc ebx
 jmp .rem_cp
.rem_end:
 mov byte [rdi], 0
 pop rdi
 pop rsi
 pop rbx
 ret

jasm_get_ext_count:
 mov rax, [rel ext_count]
 ret

jasm_get_ext_name:
 lea rax, [rel ext_name_off]
 mov eax, [rax + rcx*4]
 lea rdx, [rel ext_names]
 add rax, rdx
 ret
jasm_get_extref_count:
 mov rax, [rel extref_count]
 ret

jasm_get_extref_at:
 lea rax, [rel extref_at]
 mov eax, [rax + rcx*4]
 ret

jasm_get_extref_sym:
 lea rax, [rel extref_sym]
 mov eax, [rax + rcx*4]
 ret








emit_b:
 push rcx
 push rdx
 push r8
 cmp byte [rel jasm_pass], 1
 je .count
 movzx ecx, byte [rel cur_section]
 cmp cl, 1
 je .to_data
 mov rcx, [rel jasm_code_len]
 lea r8, [rel jasm_code]
 mov [r8 + rcx], al
 inc qword [rel jasm_code_len]
 jmp .out
.to_data:
 mov rcx, [rel jasm_data_len]
 lea r8, [rel jasm_data]
 mov [r8 + rcx], al
 inc qword [rel jasm_data_len]
 jmp .out
.count:
 movzx ecx, byte [rel cur_section]
 cmp cl, 1
 je .count_data
 inc qword [rel jasm_code_len]
 jmp .out
.count_data:
 inc qword [rel jasm_data_len]
.out:
 pop r8
 pop rdx
 pop rcx
 ret


emit_w:
 push rax
 call emit_b
 pop rax
 shr eax, 8
 call emit_b
 ret


emit_d:
 push rax
 call emit_b
 pop rax
 push rax
 shr eax, 8
 call emit_b
 pop rax
 push rax
 shr eax, 16
 call emit_b
 pop rax
 shr eax, 24
 call emit_b
 ret


emit_q:
 push rax
 call emit_d
 pop rax
 shr rax, 32
 call emit_d
 ret






bss_round8:
 add rax, 7
 and rax, -8
 ret


here:
 movzx eax, byte [rel cur_section]
 cmp al, 1
 je .data
 cmp al, 2
 je .bss
 mov rax, [rel jasm_code_len]
 ret
.data:
 mov rax, [rel jasm_data_len]
 ret
.bss:
 mov rax, [rel bss_cursor]
 ret






emit_rex:
 push rbx
 xor ebx, ebx
 test dil, dil
 jz .no_w
 or bl, 0x08
.no_w:
 test sil, 0x08
 jz .no_r
 or bl, 0x04
.no_r:
 test dl, 0x08
 jz .no_b
 or bl, 0x01
.no_b:
 test bl, bl
 jnz .emit



 cmp byte [rel rex8_force], 0
 je .done
.emit:
 mov al, 0x40
 or al, bl
 call emit_b
.done:
 pop rbx
 ret


emit_modrm:
 mov al, dil
 shl al, 6
 mov cl, sil
 and cl, 0x07
 shl cl, 3
 or al, cl
 mov cl, dl
 and cl, 0x07
 or al, cl
 call emit_b
 ret




emit_rip:
 push rax
 mov dil, 0
 mov dl, 5
 call emit_modrm
 pop rax
 mov dil, 3
 call add_fixup
 xor eax, eax
 call emit_d
 ret






emit_sib_modrm:
 push rbx
 push rbp
 mov ebx, edx
 and ebx, 0xFF
 mov ebp, edx
 shr ebp, 8
 and ebp, 0xFF
 shr edx, 16
 and edx, 0x03
 push rdx


 cmp dword [rel sib_disp], 0
 jne .em_disp32
 mov rax, rbx
 and al, 0x07
 cmp al, 0x05
 je .em_disp8
 xor edi, edi
 jmp .em_modrm
.em_disp32:
 mov dil, 2
 jmp .em_modrm
.em_disp8:
 mov dil, 1
.em_modrm:
 push rdi
 mov dl, 4
 call emit_modrm
 pop rdi
 pop rdx
 mov al, dl
 shl al, 6
 mov cl, bpl
 and cl, 0x07
 shl cl, 3
 or al, cl
 mov cl, bl
 and cl, 0x07
 or al, cl
 call emit_b
 cmp dil, 2
 jne .em_maybe8
 mov eax, [rel sib_disp]
 call emit_d
 jmp .em_out
.em_maybe8:
 test dil, dil
 jz .em_out
 xor eax, eax
 call emit_b
.em_out:
 pop rbp
 pop rbx
 ret




emit_mem_base_disp:
 push rbx
 mov ebx, eax
 neg ebx
 mov al, dl
 and al, 0x07
 cmp al, 0x04
 je .embd_sib
 mov dil, 2
 call emit_modrm
 mov eax, ebx
 call emit_d
 pop rbx
 ret
.embd_sib:
 mov dil, 2
 call emit_modrm
 mov al, 0x24
 call emit_b
 mov eax, ebx
 call emit_d
 pop rbx
 ret




emit_sib_mem:


 push rbx
 push rbp
 push rdi
 push rax
 mov ebx, edx
 and ebx, 0xFF
 mov ebp, edx
 shr ebp, 8
 and ebp, 0xFF
 shr edx, 16
 and edx, 0x03
 push rdx

 mov al, 0x40
 test dil, 1
 jz .es_no_w
 or al, 0x08
.es_no_w:
 test sil, 0x08
 jz .es_no_r
 or al, 0x04
.es_no_r:
 test bpl, 0x08
 jz .es_no_x
 or al, 0x02
.es_no_x:
 test bl, 0x08
 jz .es_no_b
 or al, 0x01
.es_no_b:
 cmp al, 0x40
 jne .es_emit_rex



 cmp byte [rel rex8_force], 0
 je .es_skip_rex
.es_emit_rex:
 call emit_b
.es_skip_rex:
 pop rdx
 pop rax
 push rdx
 call emit_b

 cmp dword [rel sib_disp], 0
 jne .es_disp32
 mov rax, rbx
 and al, 0x07
 cmp al, 0x05
 je .es_disp8
 xor edi, edi
 jmp .es_modrm
.es_disp32:
 mov dil, 2
 jmp .es_modrm
.es_disp8:
 mov dil, 1
.es_modrm:
 push rdi
 mov dl, 4
 call emit_modrm
 pop rdi
 pop rdx

 mov al, dl
 shl al, 6
 mov cl, bpl
 and cl, 0x07
 shl cl, 3
 or al, cl
 mov cl, bl
 and cl, 0x07
 or al, cl
 call emit_b
 cmp dil, 2
 jne .es_maybe8
 mov eax, [rel sib_disp]
 call emit_d
 jmp .es_out
.es_maybe8:
 test dil, dil
 jz .es_out
 xor eax, eax
 call emit_b
.es_out:
 pop rdi
 pop rbp
 pop rbx
 ret





emit_mem_reg:
 mov al, dl
 and al, 0x07
 cmp al, 0x04
 je .need_sib
 cmp al, 0x05
 je .need_disp8
 xor edi, edi
 call emit_modrm
 ret
.need_sib:
 xor edi, edi
 call emit_modrm
 mov al, 0x24
 call emit_b
 ret
.need_disp8:
 mov dil, 1
 call emit_modrm
 xor eax, eax
 call emit_b
 ret



emit_mem_rbp:
 push rax
 cmp eax, 128
 ja .disp32
 mov dil, 1
 mov dl, 5
 call emit_modrm
 pop rax
 neg eax
 call emit_b
 ret
.disp32:
 mov dil, 2
 mov dl, 5
 call emit_modrm
 pop rax
 neg eax
 call emit_d
 ret






jasm_add_extern:
 push rbx
 push rsi
 push rdi
 push r12
 mov rsi, rcx
 mov r12, rdx



 call jasm_find_extern
 cmp eax, -1
 jne .done
 mov rbx, [rel ext_count]
 cmp rbx, 128
 jae .done
 mov rax, [rel ext_names_len]
 lea rdi, [rel ext_name_off]
 mov [rdi + rbx*4], eax
 lea rdi, [rel ext_names]
 add rdi, rax
.cp:
 test r12, r12
 jz .cp_end
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec r12
 jmp .cp
.cp_end:
 mov byte [rdi], 0
 lea rax, [rel ext_names]
 sub rdi, rax
 inc rdi
 mov [rel ext_names_len], rdi
 inc rbx
 mov [rel ext_count], rbx
.done:
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret













jasm_prune_externs:
 push rbx
 push rsi
 push rdi
 push r12




 xor rbx, rbx
.clr:
 cmp rbx, 128
 jae .clr_done
 lea rdi, [rel ext_used]
 xor eax, eax
 mov [rdi + rbx*4], eax
 inc rbx
 jmp .clr
.clr_done:
 xor rbx, rbx
.mark:
 cmp rbx, [rel extref_count]
 jae .mark_done
 lea rdi, [rel extref_sym]
 mov eax, [rdi + rbx*4]
 mov rcx, rax
 mov eax, 1
 lea rdx, [rel ext_used]
 mov [rdx + rcx*4], eax
 inc rbx
 jmp .mark
.mark_done:


 mov qword [rel prn_new], 0
 xor rbx, rbx
.cls:
 cmp rbx, [rel ext_count]
 jae .compact
 mov rcx, rbx
 call jasm_get_ext_name
 mov r12, rax
 mov rcx, r12
 call str_len_local
 mov rdx, rax
 mov rcx, r12
 call jasm_find_label
 cmp eax, -1
 jne .cls_internal
 lea rdi, [rel ext_used]
 mov eax, [rdi + rbx*4]
 test eax, eax
 jz .cls_internal
 mov rax, [rel prn_new]
 lea rdi, [rel ext_map]
 mov [rdi + rbx*4], eax
 inc rax
 mov [rel prn_new], rax
 jmp .cls_next
.cls_internal:
 mov rax, -1
 lea rdi, [rel ext_map]
 mov [rdi + rbx*4], eax
.cls_next:
 inc rbx
 jmp .cls




.compact:
 mov qword [rel prn_new], 0
 mov eax, 1
 mov r12, rax
 xor rbx, rbx
.cmp_loop:
 cmp rbx, [rel ext_count]
 jae .cmp_done
 lea rdi, [rel ext_map]
 mov eax, [rdi + rbx*4]
 cmp eax, -1
 je .cmp_next
 mov rcx, rbx
 call jasm_get_ext_name
 mov rsi, rax
 lea rdi, [rel ext_names]
 add rdi, r12
 mov rcx, [rel prn_new]
 lea rdx, [rel ext_name_off]
 mov rax, r12
 mov [rdx + rcx*4], eax
 inc rcx
 mov [rel prn_new], rcx
.cmp_cp:
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 inc r12
 test al, al
 jnz .cmp_cp
.cmp_next:
 inc rbx
 jmp .cmp_loop
.cmp_done:
 mov rax, [rel prn_new]
 mov [rel ext_count], rax
 mov rax, r12
 mov [rel ext_names_len], rax


 mov qword [rel prn_new], 0
 xor rbx, rbx
.xr:
 cmp rbx, [rel extref_count]
 jae .xr_done
 lea rdi, [rel extref_sym]
 mov eax, [rdi + rbx*4]
 mov rcx, rax
 lea rax, [rel ext_map]
 mov eax, [rax + rcx*4]
 cmp eax, -1
 je .xr_next
 mov rcx, [rel prn_new]
 lea rdx, [rel extref_sym]
 mov [rdx + rcx*4], eax
 lea rdi, [rel extref_at]
 mov eax, [rdi + rbx*4]
 lea rdx, [rel extref_at]
 mov [rdx + rcx*4], eax
 inc rcx
 mov [rel prn_new], rcx
.xr_next:
 inc rbx
 jmp .xr
.xr_done:
 mov rax, [rel prn_new]
 mov [rel extref_count], rax

 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret


jasm_find_extern:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 mov r12, rcx
 mov r13, rdx
 xor rbx, rbx
.l:
 cmp rbx, [rel ext_count]
 jae .nf
 lea rdi, [rel ext_name_off]
 mov eax, [rdi + rbx*4]
 lea rdi, [rel ext_names]
 add rdi, rax
 mov rsi, r12
 mov rcx, r13
.cmp:
 test rcx, rcx
 jz .cmp_end
 mov al, [rdi]
 cmp al, [rsi]
 jne .next
 inc rdi
 inc rsi
 dec rcx
 jmp .cmp
.cmp_end:
 cmp byte [rdi], 0
 jne .next
 mov rax, rbx
 jmp .out
.next:
 inc rbx
 jmp .l
.nf:
 mov rax, -1
.out:
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret



jasm_add_extref:
 push rbx
 push rcx
 push rdx
 mov rbx, [rel extref_count]
 cmp rbx, 512
 jae .done
 push rax
 call here
 mov ecx, eax
 pop rax
 lea rdx, [rel extref_at]
 mov [rdx + rbx*4], ecx
 lea rdx, [rel extref_sym]
 mov [rdx + rbx*4], eax
 inc rbx
 mov [rel extref_count], rbx
.done:
 pop rdx
 pop rcx
 pop rbx
 ret


jasm_add_label:
 push rbx
 push rsi
 push rdi
 push r12
 mov rsi, rcx
 mov r12, rdx



 push rsi
 push r12
 mov rcx, rsi
 mov rdx, r12
 call jasm_find_label
 pop r12
 pop rsi
 cmp eax, -1
 je .fresh
 mov rbx, rax
 call here
 lea rdi, [rel lbl_addr]
 mov [rdi + rbx*8], rax
 movzx eax, byte [rel cur_section]
 lea rdi, [rel lbl_section]
 mov [rdi + rbx], al
 jmp .done
.fresh:
 mov rbx, [rel lbl_count]
 cmp rbx, 16384
 jae .lbl_full


 mov rax, [rel lbl_names_len]
 add rax, r12
 add rax, 2
 cmp rax, 524288
 jae .lbl_full

 mov rax, [rel lbl_names_len]
 lea rdi, [rel lbl_name_off]
 mov [rdi + rbx*4], eax
 lea rdi, [rel lbl_names]
 add rdi, rax
.cp:
 test r12, r12
 jz .cp_end
 mov al, [rsi]
 mov [rdi], al
 inc rsi
 inc rdi
 dec r12
 jmp .cp
.cp_end:
 mov byte [rdi], 0
 lea rax, [rel lbl_names]
 sub rdi, rax
 inc rdi
 mov [rel lbl_names_len], rdi

 call here
 lea rdi, [rel lbl_addr]
 mov [rdi + rbx*8], rax
 movzx eax, byte [rel cur_section]
 lea rdi, [rel lbl_section]
 mov [rdi + rbx], al
 inc rbx
 mov [rel lbl_count], rbx
 jmp .done
.lbl_full:


 mov byte [rel jasm_error], 1
.done:
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret


jasm_find_label:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 mov r12, rcx
 mov r13, rdx
 xor rbx, rbx
.l:
 cmp rbx, [rel lbl_count]
 jae .nf
 lea rdi, [rel lbl_name_off]
 mov eax, [rdi + rbx*4]
 lea rdi, [rel lbl_names]
 add rdi, rax

 mov rsi, r12
 mov rcx, r13
.cmp:
 test rcx, rcx
 jz .cmp_end
 mov al, [rdi]
 cmp al, [rsi]
 jne .next
 inc rdi
 inc rsi
 dec rcx
 jmp .cmp
.cmp_end:
 cmp byte [rdi], 0
 jne .next
 mov rax, rbx
 jmp .out
.next:
 inc rbx
 jmp .l
.nf:
 mov rax, -1
.out:
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret


jasm_label_addr:
 lea rcx, [rel lbl_addr]
 mov rax, [rcx + rax*8]
 ret



jasm_get_fixup_count:
 mov rax, [rel fix_count]
 ret
jasm_get_fixup_at:
 lea rax, [rel fix_at]
 mov eax, [rax + rcx*4]
 ret
jasm_get_fixup_label:
 lea rax, [rel fix_label]
 mov eax, [rax + rcx*4]
 ret
jasm_get_fixup_addend:
 lea rax, [rel fix_addend]
 mov eax, [rax + rcx*4]
 ret
jasm_get_fixup_kind:
 lea rax, [rel fix_kind]
 movzx eax, byte [rax + rcx]
 ret
jasm_get_label_section:
 lea rax, [rel lbl_section]
 movzx eax, byte [rax + rcx]
 ret






add_fixup:
 push rbx
 push rcx
 mov rbx, [rel fix_count]
 cmp rbx, 65536
 jae .done
 push rax
 call here
 mov ecx, eax
 pop rax
 push rdx
 lea rdx, [rel fix_at]
 mov [rdx + rbx*4], ecx
 lea rdx, [rel fix_label]
 mov [rdx + rbx*4], eax
 lea rdx, [rel fix_kind]
 mov [rdx + rbx], dil
 push rax
 mov eax, [rel cur_addend]
 lea rdx, [rel fix_addend]
 mov [rdx + rbx*4], eax
 pop rax
 pop rdx
 inc rbx
 mov [rel fix_count], rbx
.done:
 pop rcx
 pop rbx
 ret
















parse_operand:
 push rbx
 push rsi
 push rdi
 push r12



 mov qword [rel cur_addend], 0
 mov rsi, rcx


 test rsi, rsi
 jz .no_pfx



 cmp byte [rsi], 'b'
 jne .pfx_q
 cmp byte [rsi+1], 'y'
 jne .no_pfx
 cmp byte [rsi+2], 't'
 jne .no_pfx
 cmp byte [rsi+3], 'e'
 jne .no_pfx
 cmp byte [rsi+4], ' '
 jne .no_pfx
 mov byte [rel op_size], 1
 add rsi, 5
 jmp .no_pfx
.pfx_q:
 cmp byte [rsi], 'q'
 je .pfx_q8
 cmp byte [rsi], 'd'
 jne .pfx_w
 cmp byte [rsi+1], 'w'
 jne .no_pfx
 cmp byte [rsi+2], 'o'
 jne .no_pfx
 cmp byte [rsi+3], 'r'
 jne .no_pfx
 cmp byte [rsi+4], 'd'
 jne .no_pfx
 cmp byte [rsi+5], ' '
 jne .no_pfx
 mov byte [rel op_size], 4
 add rsi, 6
 jmp .no_pfx
.pfx_q8:
 cmp byte [rsi+1], 'w'
 jne .no_pfx
 cmp byte [rsi+2], 'o'
 jne .no_pfx
 cmp byte [rsi+3], 'r'
 jne .no_pfx
 cmp byte [rsi+4], 'd'
 jne .no_pfx
 cmp byte [rsi+5], ' '
 jne .no_pfx
 mov byte [rel op_size], 8
 add rsi, 6
 jmp .no_pfx
.pfx_w:
 cmp byte [rsi], 'w'
 jne .no_pfx
 cmp byte [rsi+1], 'o'
 jne .no_pfx
 cmp byte [rsi+2], 'r'
 jne .no_pfx
 cmp byte [rsi+3], 'd'
 jne .no_pfx
 cmp byte [rsi+4], ' '
 jne .no_pfx
 mov byte [rel op_size], 2
 add rsi, 5
.no_pfx:
 test rsi, rsi
 jz .none
 cmp byte [rsi], 0
 je .none


 cmp byte [rsi], '['
 je .mem


 cmp byte [rsi], '~'
 je .as_expr
 cmp byte [rsi], '('
 jne .not_paren
.as_expr:
 mov rcx, rsi
 call parse_expr
 mov rdx, rax
 mov eax, 2
 jmp .out
.not_paren:


 cmp byte [rsi], 0x27
 jne .not_char
 movzx edx, byte [rsi+1]
 mov eax, 2
 jmp .out
.not_char:


 mov al, [rsi]
 cmp al, '-'
 jne .not_neg
 movzx eax, byte [rsi+1]
 cmp al, '0'
 jb .try_reg
 cmp al, '9'
 ja .try_reg
 jmp .is_num
.not_neg:
 cmp al, '0'
 jb .try_reg
 cmp al, '9'
 ja .try_reg
.is_num:
 mov rcx, rsi
 call parse_number
 mov rdx, rax
 mov eax, 2
 jmp .out

.try_reg:

 mov rcx, rsi
 lea rdx, [rel reg64_names]
 call match_reg_table
 cmp eax, -1
 je .try_xmm
 mov edx, eax
 mov eax, 1
 jmp .out
.try_xmm:
 mov rcx, rsi
 lea rdx, [rel xmm_names]
 mov r8d, 8
 call match_reg_table_n
 cmp eax, -1
 je .try_r8
 mov edx, eax
 mov eax, 6
 jmp .out
.try_r8:
 mov rcx, rsi
 lea rdx, [rel reg8_names]
 call match_reg_table
 cmp eax, -1
 je .try_r32
 mov edx, eax
 mov eax, 7
 jmp .out
.try_r32:
 mov rcx, rsi
 lea rdx, [rel reg32_names]
 call match_reg_table
 cmp eax, -1
 je .try_r16
 mov edx, eax
 mov eax, 8
 jmp .out
.try_r16:
 mov rcx, rsi
 lea rdx, [rel reg16_names]
 call match_reg_table
 cmp eax, -1
 je .as_label
 mov edx, eax
 mov eax, 10
 jmp .out

.as_label:


 push rsi
 mov rcx, rsi
.al_scan:
 mov al, [rcx]
 test al, al
 jz .al_not_expr
 cmp al, '+'
 je .al_is_expr
 cmp al, '*'
 je .al_is_expr
 cmp al, '/'
 je .al_is_expr
 cmp al, '&'
 je .al_is_expr
 cmp al, '|'
 je .al_is_expr
 cmp al, '<'
 je .al_is_expr
 cmp al, '>'
 je .al_is_expr
 cmp al, ' '
 jne .al_next
 cmp byte [rcx+1], '-'
 je .al_is_expr
.al_next:
 inc rcx
 jmp .al_scan
.al_is_expr:
 pop rsi
 mov rcx, rsi
 call parse_expr
 mov rdx, rax
 mov eax, 2
 jmp .out
.al_not_expr:
 pop rsi

 push rsi
 mov rcx, rsi
 call str_len_local
 mov rdx, rax
 mov rcx, rsi
 call find_equ
 pop rsi
 cmp eax, -1
 je .as_label_real
 lea rdx, [rel equ_value]
 mov rdx, [rdx + rax*8]
 mov eax, 2
 jmp .out
.as_label_real:

 mov rcx, rsi
 call str_len_local
 mov rdx, rax
 mov rcx, rsi
 call qualify_label
 call jasm_find_label
 mov edx, eax
 mov eax, 4
 jmp .out

.mem:
 inc rsi

 cmp byte [rsi], 'r'
 jne .mem_reg
 cmp byte [rsi+1], 'e'
 jne .mem_reg
 cmp byte [rsi+2], 'l'
 jne .mem_reg
 cmp byte [rsi+3], ' '
 jne .mem_reg
 add rsi, 4

 mov qword [rel cur_addend], 0
 mov rcx, rsi
 call len_until_plus_or_bracket
 mov rdx, rax

 mov r8, rsi
 add r8, rax
 cmp byte [r8], '+'
 jne .rel_no_addend
 push rdx
 lea rcx, [r8+1]
 call parse_number
 mov [rel cur_addend], eax
 pop rdx
.rel_no_addend:

 mov rcx, rsi
 call qualify_label
 call jasm_find_label
 mov edx, eax
 mov eax, 5
 jmp .out

.mem_reg:

 mov rcx, rsi
 lea rdx, [rel reg64_names]
 call match_reg_prefix
 cmp eax, -1
 je .none
 mov r12d, eax
 add rsi, rcx


 call skip_blanks_rsi
 cmp byte [rsi], '-'
 je .mem_disp
 cmp byte [rsi], '+'
 je .mem_maybe_index
 mov edx, r12d
 mov eax, 9
 jmp .out
.mem_maybe_index:
 inc rsi
 call skip_blanks_rsi
 dec rsi
 mov al, [rsi+1]
 cmp al, 'r'
 je .mem_index
 cmp al, 'e'
 je .mem_index
 jmp .mem_disp_pos
.mem_index:
 inc rsi
 mov rcx, rsi
 lea rdx, [rel reg64_names]
 call match_reg_prefix
 cmp eax, -1
 je .none
 mov edx, r12d
 mov ecx, eax
 shl ecx, 8
 or edx, ecx




.mem_skip_reg:
 mov al, [rsi]
 cmp al, 'a'
 jb .mem_skip_digit
 cmp al, 'z'
 jbe .mem_skip_adv
.mem_skip_digit:
 cmp al, '0'
 jb .mem_scale
 cmp al, '9'
 ja .mem_scale
.mem_skip_adv:
 inc rsi
 jmp .mem_skip_reg
.mem_scale:
 mov al, [rsi]
 cmp al, '*'
 jne .mem_scale_done
 mov al, [rsi+1]
 cmp al, '2'
 je .msc_2
 cmp al, '4'
 je .msc_4
 cmp al, '8'
 je .msc_8
 jmp .mem_scale_done
.msc_2:
 or edx, 0x010000
 jmp .mem_scale_done
.msc_4:
 or edx, 0x020000
 jmp .mem_scale_done
.msc_8:
 or edx, 0x030000
.mem_scale_done:

 mov dword [rel sib_disp], 0
 push rdx
.msd_skipreg:
 mov al, [rsi]
 cmp al, '*'
 je .msd_adv
 cmp al, '0'
 jb .msd_chkalpha
 cmp al, '9'
 jbe .msd_adv
.msd_chkalpha:
 or al, 0x20
 cmp al, 'a'
 jb .msd_after
 cmp al, 'z'
 ja .msd_after
.msd_adv:
 inc rsi
 jmp .msd_skipreg
.msd_after:
 call skip_blanks_rsi
 mov al, [rsi]
 cmp al, '+'
 je .msd_plus
 cmp al, '-'
 je .msd_minus
 jmp .msd_out
.msd_plus:
 inc rsi
 call skip_blanks_rsi
 mov rcx, rsi
 push r12
 call parse_expr
 pop r12
 mov [rel sib_disp], eax
 jmp .msd_out
.msd_minus:
 inc rsi
 call skip_blanks_rsi
 mov rcx, rsi
 push r12
 call parse_expr
 pop r12
 neg eax
 mov [rel sib_disp], eax
.msd_out:
 pop rdx
 mov eax, 12
 jmp .out
.mem_disp:
 inc rsi
 call skip_blanks_rsi
 mov rcx, rsi
 push r12
 call parse_expr
 pop r12
 mov edx, eax
 cmp r12d, 5
 jne .mem_disp_other
 mov eax, 3
 jmp .out
.mem_disp_other:
 mov r8d, r12d
 mov eax, 13
 jmp .out
.mem_disp_pos:
 cmp r12d, 4
 jne .mem_disp_pos_generic
 inc rsi
 call skip_blanks_rsi
 mov rcx, rsi
 push r12
 call parse_expr
 pop r12
 mov edx, eax
 mov eax, 11
 jmp .out
.mem_disp_pos_generic:
 inc rsi
 call skip_blanks_rsi
 mov rcx, rsi
 push r12
 call parse_expr
 pop r12
 neg eax
 mov edx, eax
 cmp r12d, 5
 jne .mem_dpos_other
 mov eax, 3
 jmp .out
.mem_dpos_other:
 mov r8d, r12d
 mov eax, 13
 jmp .out

.none:
 xor eax, eax
 xor edx, edx
.out:
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret



match_reg_table:
 push r8
 mov r8d, 16
 call match_reg_table_n
 pop r8
 ret


match_reg_table_n:
 push rbx
 push rsi
 push rdi
 xor ebx, ebx
.l:
 cmp ebx, r8d
 jae .nf
 mov rdi, rdx
 mov eax, ebx
 imul eax, eax, 5
 add rdi, rax
.cmp_start:
 mov rsi, rcx
.cmp:
 mov al, [rdi]
 test al, al
 jz .end_of_name
 cmp al, [rsi]
 jne .next
 inc rdi
 inc rsi
 jmp .cmp
.end_of_name:
 cmp byte [rsi], 0
 jne .next
 mov eax, ebx
 jmp .out
.next:
 inc ebx
 jmp .l
.nf:
 mov eax, -1
.out:
 pop rdi
 pop rsi
 pop rbx
 ret


match_reg_prefix:
 push rbx
 push rsi
 push rdi
 push r9
 mov r9, rcx
 xor ebx, ebx
.l:
 cmp ebx, 16
 jae .nf
 mov rdi, rdx
 mov eax, ebx
 imul eax, eax, 5
 add rdi, rax
 mov rsi, r9
 xor ecx, ecx
.cmp:
 mov al, [rdi]
 test al, al
 jz .matched
 cmp al, [rsi]
 jne .next
 inc rdi
 inc rsi
 inc ecx
 jmp .cmp
.matched:
 mov eax, ebx
 jmp .out
.next:
 inc ebx
 jmp .l
.nf:
 mov eax, -1
 xor ecx, ecx
.out:
 pop r9
 pop rdi
 pop rsi
 pop rbx
 ret






parse_float:
 push rbx
 push rsi
 push rdi
 push rcx
 mov rsi, rcx
 xor edi, edi
 cmp byte [rsi], '-'
 jne .pf_int
 mov edi, 1
 inc rsi
.pf_int:
 xor rax, rax
.pf_il:
 movzx ebx, byte [rsi]
 cmp bl, '0'
 jb .pf_idone
 cmp bl, '9'
 ja .pf_idone
 imul rax, rax, 10
 sub rbx, 48
 add rax, rbx
 inc rsi
 jmp .pf_il
.pf_idone:
 cvtsi2sd xmm0, rax
 cmp byte [rsi], '.'
 jne .pf_sign
 inc rsi
 xor rax, rax
 mov rcx, 1
 xor edx, edx
.pf_fl:
 movzx ebx, byte [rsi]
 cmp bl, '0'
 jb .pf_fdone
 cmp bl, '9'
 ja .pf_fdone
 cmp edx, 17
 jae .pf_fskip
 imul rax, rax, 10
 sub rbx, 48
 add rax, rbx
 imul rcx, rcx, 10
 inc edx
.pf_fskip:
 inc rsi
 jmp .pf_fl
.pf_fdone:
 test rax, rax
 jz .pf_sign
 cvtsi2sd xmm1, rax
 cvtsi2sd xmm2, rcx
 divsd xmm1, xmm2
 addsd xmm0, xmm1
.pf_sign:
 test edi, edi
 jz .pf_out
 xorps xmm1, xmm1
 subsd xmm1, xmm0
 movsd xmm0, xmm1
.pf_out:
 pop rcx
 pop rdi
 pop rsi
 pop rbx
 ret











parse_expr:
 mov [rel expr_ptr], rcx
 call ex_or
 ret

ex_or:
 push rbx
 call ex_and
 mov rbx, rax
.l:
 call ex_skipws
 mov rcx, [rel expr_ptr]
 cmp byte [rcx], '|'
 jne .out
 inc qword [rel expr_ptr]
 call ex_and
 or rbx, rax
 jmp .l
.out:
 mov rax, rbx
 pop rbx
 ret

ex_and:
 push rbx
 call ex_shift
 mov rbx, rax
.l:
 call ex_skipws
 mov rcx, [rel expr_ptr]
 cmp byte [rcx], '&'
 jne .out
 inc qword [rel expr_ptr]
 call ex_shift
 and rbx, rax
 jmp .l
.out:
 mov rax, rbx
 pop rbx
 ret

ex_shift:
 push rbx
 call ex_addsub
 mov rbx, rax
.l:
 call ex_skipws
 mov rcx, [rel expr_ptr]
 mov al, [rcx]
 cmp al, '<'
 je .maybe_shl
 cmp al, '>'
 je .maybe_shr
 jmp .out
.maybe_shl:
 cmp byte [rcx+1], '<'
 jne .out
 add qword [rel expr_ptr], 2
 call ex_addsub
 mov rcx, rax
 shl rbx, cl
 jmp .l
.maybe_shr:
 cmp byte [rcx+1], '>'
 jne .out
 add qword [rel expr_ptr], 2
 call ex_addsub
 mov rcx, rax
 sar rbx, cl
 jmp .l
.out:
 mov rax, rbx
 pop rbx
 ret

ex_skipws:
 push rcx
.l:
 mov rcx, [rel expr_ptr]
 mov al, [rcx]
 cmp al, ' '
 je .adv
 cmp al, 9
 jne .out
.adv:
 inc qword [rel expr_ptr]
 jmp .l
.out:
 pop rcx
 ret

ex_addsub:
 push rbx
 call ex_muldiv
 mov rbx, rax
.l:
 call ex_skipws
 mov rcx, [rel expr_ptr]
 mov al, [rcx]
 cmp al, '+'
 je .plus
 cmp al, '-'
 je .minus
 mov rax, rbx
 pop rbx
 ret
.plus:
 inc qword [rel expr_ptr]
 call ex_muldiv
 add rbx, rax
 jmp .l
.minus:
 inc qword [rel expr_ptr]
 call ex_muldiv
 sub rbx, rax
 jmp .l

ex_muldiv:
 push rbx
 call ex_primary
 mov rbx, rax
.l:
 call ex_skipws
 mov rcx, [rel expr_ptr]
 mov al, [rcx]
 cmp al, '*'
 je .mul
 cmp al, '/'
 je .div
 mov rax, rbx
 pop rbx
 ret
.mul:
 inc qword [rel expr_ptr]
 call ex_primary
 imul rbx, rax
 jmp .l
.div:
 inc qword [rel expr_ptr]
 call ex_primary
 test rax, rax
 jz .l
 push rax
 mov rax, rbx
 cqo
 pop rcx
 idiv rcx
 mov rbx, rax
 jmp .l

ex_primary:
 call ex_skipws
 mov rcx, [rel expr_ptr]
 mov al, [rcx]
 cmp al, '('
 je .paren
 cmp al, '$'
 je .here_sym
 cmp al, 0x27
 je .charlit
 cmp al, '-'
 je .negate
 cmp al, '~'
 je .bitnot
 cmp al, '0'
 jb .symbol
 cmp al, '9'
 ja .symbol
 jmp ex_number
.paren:
 inc qword [rel expr_ptr]
 call ex_addsub
 push rax
 call ex_skipws
 mov rcx, [rel expr_ptr]
 cmp byte [rcx], ')'
 jne .no_close
 inc qword [rel expr_ptr]
.no_close:
 pop rax
 ret
.here_sym:
 inc qword [rel expr_ptr]
 call here
 ret
.negate:
 inc qword [rel expr_ptr]
 call ex_primary
 neg rax
 ret
.bitnot:
 inc qword [rel expr_ptr]
 call ex_primary
 not rax
 ret
.charlit:
 mov rcx, [rel expr_ptr]
 movzx eax, byte [rcx+1]
 add qword [rel expr_ptr], 3
 ret
.symbol:
 jmp ex_symbol


ex_number:
 push rbx
 mov rcx, [rel expr_ptr]
 cmp byte [rcx], '0'
 jne .dec
 mov al, [rcx+1]
 cmp al, 'x'
 je .hex
 cmp al, 'X'
 je .hex
.dec:
 xor rax, rax
.dl:
 mov rcx, [rel expr_ptr]
 movzx ebx, byte [rcx]
 cmp bl, '0'
 jb .out
 cmp bl, '9'
 ja .out
 imul rax, rax, 10
 sub rbx, 48
 add rax, rbx
 inc qword [rel expr_ptr]
 jmp .dl
.hex:
 add qword [rel expr_ptr], 2
 xor rax, rax
.hl:
 mov rcx, [rel expr_ptr]
 movzx ebx, byte [rcx]
 cmp bl, '0'
 jb .out
 cmp bl, '9'
 jbe .hdig
 or bl, 0x20
 cmp bl, 'a'
 jb .out
 cmp bl, 'f'
 ja .out
 sub rbx, 87
 jmp .hadd
.hdig:
 sub rbx, 48
.hadd:
 shl rax, 4
 add rax, rbx
 inc qword [rel expr_ptr]
 jmp .hl
.out:
 pop rbx
 ret


ex_symbol:
 push rbx
 push rsi
 mov rsi, [rel expr_ptr]
 xor rbx, rbx
.scan:
 movzx eax, byte [rsi + rbx]
 cmp al, '_'
 je .take
 cmp al, '.'
 je .take
 cmp al, '0'
 jb .scan_done
 cmp al, '9'
 jbe .take
 or al, 0x20
 cmp al, 'a'
 jb .scan_done
 cmp al, 'z'
 ja .scan_done
.take:
 inc rbx
 jmp .scan
.scan_done:
 add [rel expr_ptr], rbx
 mov rcx, rsi
 mov rdx, rbx
 call find_equ
 cmp eax, -1
 je .try_label
 lea rdx, [rel equ_value]
 mov rax, [rdx + rax*8]
 pop rsi
 pop rbx
 ret
.try_label:
 mov rcx, rsi
 mov rdx, rbx
 call qualify_label
 call jasm_find_label
 cmp eax, -1
 je .unknown
 call jasm_label_addr
 pop rsi
 pop rbx
 ret
.unknown:
 xor rax, rax
 pop rsi
 pop rbx
 ret


find_equ:
 push rbx
 push rsi
 push rdi
 push r12
 mov rsi, rcx
 mov r12, rdx
 xor rbx, rbx
.l:
 cmp rbx, [rel equ_count]
 jae .no
 lea rdi, [rel equ_name_off]
 mov eax, [rdi + rbx*4]
 lea rdi, [rel equ_names]
 add rdi, rax
 xor rcx, rcx
.cmp:
 cmp rcx, r12
 je .end_of_name
 mov al, [rsi + rcx]
 cmp al, [rdi + rcx]
 jne .next
 inc rcx
 jmp .cmp
.end_of_name:
 cmp byte [rdi + rcx], 0
 jne .next
 mov rax, rbx
 jmp .out
.next:
 inc rbx
 jmp .l
.no:
 mov rax, -1
.out:
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret


add_equ:
 push rbx
 push rsi
 push rdi



 push rcx
 push rdx
 push r8
 call find_equ
 pop r8
 pop rdx
 pop rcx
 cmp eax, -1
 je .fresh
 lea rdx, [rel equ_value]
 mov [rdx + rax*8], r8
 jmp .out
.fresh:
 mov rbx, [rel equ_count]
 cmp rbx, 8192
 jae .equ_full
 mov rax, [rel equ_names_len]
 add rax, rdx
 add rax, 2
 cmp rax, 262144
 jae .equ_full
 mov rax, [rel equ_names_len]
 lea rdi, [rel equ_name_off]
 mov [rdi + rbx*4], eax
 lea rdi, [rel equ_names]
 add rdi, rax
 mov rsi, rcx
 xor rcx, rcx
.cp:
 cmp rcx, rdx
 je .cp_done
 mov al, [rsi + rcx]
 mov [rdi + rcx], al
 inc rcx
 jmp .cp
.cp_done:
 mov byte [rdi + rcx], 0
 inc rcx
 add [rel equ_names_len], rcx
 lea rdi, [rel equ_value]
 mov [rdi + rbx*8], r8
 inc rbx
 mov [rel equ_count], rbx
 jmp .out
.equ_full:



 mov byte [rel jasm_error], 1
.out:
 pop rdi
 pop rsi
 pop rbx
 ret

parse_number:
 push rbx
 push rsi
 push r12
 mov rsi, rcx
 xor r12d, r12d
 cmp byte [rsi], '-'
 jne .nosign
 mov r12d, 1
 inc rsi
.nosign:
 xor rax, rax
 cmp byte [rsi], '0'
 jne .dec
 cmp byte [rsi+1], 'x'
 je .hex
 cmp byte [rsi+1], 'X'
 je .hex
.dec:
 xor rax, rax
.dl:
 movzx ebx, byte [rsi]
 cmp bl, '0'
 jb .done
 cmp bl, '9'
 ja .done
 sub bl, '0'
 imul rax, rax, 10
 add rax, rbx
 inc rsi
 jmp .dl
.hex:
 add rsi, 2
 xor rax, rax
.hl:
 movzx ebx, byte [rsi]
 cmp bl, '0'
 jb .done
 cmp bl, '9'
 jbe .hdig
 or bl, 0x20
 cmp bl, 'a'
 jb .done
 cmp bl, 'f'
 ja .done
 sub bl, 'a' - 10
 jmp .hadd
.hdig:
 sub bl, '0'
.hadd:
 shl rax, 4
 add rax, rbx
 inc rsi
 jmp .hl
.done:
 test r12d, r12d
 jz .nonegate
 neg rax
.nonegate:
 pop r12
 pop rsi
 pop rbx
 ret


str_len_local:
 xor rax, rax
.l:
 cmp byte [rcx + rax], 0
 je .d
 inc rax
 jmp .l
.d:
 ret


len_until_bracket:
 xor rax, rax
.l:
 movzx edx, byte [rcx + rax]
 test dl, dl
 jz .d
 cmp dl, ']'
 je .d
 inc rax
 jmp .l
.d:
 ret


len_until_plus_or_bracket:
 xor rax, rax
.l:
 movzx edx, byte [rcx + rax]
 test dl, dl
 jz .d
 cmp dl, ']'
 je .d
 cmp dl, '+'
 je .d
 inc rax
 jmp .l
.d:
 ret







split_line:
 push rbx
 push rsi
 push rdi
 mov rsi, rcx
 mov byte [rel tok_a], 0
 mov byte [rel tok_b], 0
 mov byte [rel tok_c], 0


.skip:
 mov al, [rsi]
 cmp al, ' '
 je .adv
 cmp al, 9
 je .adv
 jmp .have
.adv:
 inc rsi
 jmp .skip
.have:
 test al, al
 jz .empty
 cmp al, ';'
 je .empty


 lea rdi, [rel tok_a]
 xor ebx, ebx
.w1:
 mov al, [rsi]
 test al, al
 jz .w1_end
 cmp al, ' '
 je .w1_end
 cmp al, 9
 je .w1_end
 cmp al, ':'
 je .is_label
 cmp ebx, 62
 jae .w1_end
 mov [rdi + rbx], al
 inc ebx
 inc rsi
 jmp .w1
.w1_end:
 mov byte [rdi + rbx], 0


 push rsi
 call skip_blanks_rsi
 mov rcx, rsi
 call is_data_dir
 test al, al
 jz .w1_not_label
 add rsp, 8
 jmp .is_label_body
.w1_not_label:
 pop rsi

 mov byte [rel op_size], 0
 call skip_blanks_rsi
 cmp byte [rsi], 'b'
 jne .not_byte
 cmp byte [rsi+1], 'y'
 jne .not_byte
 cmp byte [rsi+2], 't'
 jne .not_byte
 cmp byte [rsi+3], 'e'
 jne .not_byte
 cmp byte [rsi+4], ' '
 jne .not_byte
 mov byte [rel op_size], 1
 add rsi, 5
 jmp .size_done
.not_byte:
 cmp byte [rsi], 'q'
 jne .not_qword
 cmp byte [rsi+1], 'w'
 jne .not_qword
 cmp byte [rsi+2], 'o'
 jne .not_qword
 cmp byte [rsi+3], 'r'
 jne .not_qword
 cmp byte [rsi+4], 'd'
 jne .not_qword
 cmp byte [rsi+5], ' '
 jne .not_qword
 mov byte [rel op_size], 8
 add rsi, 6
 jmp .size_done
.not_qword:
 cmp byte [rsi], 'd'
 jne .not_dword
 cmp byte [rsi+1], 'w'
 jne .not_dword
 cmp byte [rsi+2], 'o'
 jne .not_dword
 cmp byte [rsi+3], 'r'
 jne .not_dword
 cmp byte [rsi+4], 'd'
 jne .not_dword
 cmp byte [rsi+5], ' '
 jne .not_dword
 mov byte [rel op_size], 4
 add rsi, 6
 jmp .size_done
.not_dword:
 cmp byte [rsi], 'w'
 jne .size_done
 cmp byte [rsi+1], 'o'
 jne .size_done
 cmp byte [rsi+2], 'r'
 jne .size_done
 cmp byte [rsi+3], 'd'
 jne .size_done
 cmp byte [rsi+4], ' '
 jne .size_done
 mov byte [rel op_size], 2
 add rsi, 5
.size_done:
 call skip_blanks_rsi
 lea rdi, [rel tok_b]
 xor ebx, ebx
 xor edx, edx
.w2:
 mov al, [rsi]
 test al, al
 jz .w2_end
 test dl, dl
 jnz .w2_inq
 cmp al, ','
 je .w2_comma
 cmp al, ';'
 je .w2_end
 cmp al, 0x27
 je .w2_open
 cmp al, 0x22
 je .w2_open
 jmp .w2_store
.w2_open:
 mov dl, al
 jmp .w2_store
.w2_inq:
 cmp al, dl
 jne .w2_store
 xor edx, edx
.w2_store:
 cmp ebx, 510
 jae .w2_end
 mov [rdi + rbx], al
 inc ebx
 inc rsi
 jmp .w2
.w2_comma:
 inc rsi
.w2_end:

 call trim_tok_b
 mov byte [rdi + rbx], 0
 call trim_tok_b


 call skip_blanks_rsi
 lea rdi, [rel tok_c]
 xor ebx, ebx
 xor edx, edx
.w3:
 mov al, [rsi]
 test al, al
 jz .w3_end
 test dl, dl
 jnz .w3_inq



 cmp al, ';'
 je .w3_end
 cmp al, 0x27
 je .w3_open
 cmp al, 0x22
 je .w3_open
 jmp .w3_store
.w3_open:
 mov dl, al
 jmp .w3_store
.w3_inq:
 cmp al, dl
 jne .w3_store
 xor edx, edx
.w3_store:
 cmp ebx, 510
 jae .w3_end
 mov [rdi + rbx], al
 inc ebx
 inc rsi
 jmp .w3
.w3_end:
 mov byte [rdi + rbx], 0
 call trim_tok_c
 xor al, al
 jmp .out

.is_label:
 mov byte [rdi + rbx], 0

 inc rsi
.is_label_body:
 call skip_blanks_rsi
 cmp byte [rsi], 0
 je .label_only
 cmp byte [rsi], ';'
 je .label_only



 push rsi
 lea rdi, [rel lbl_rest]
 xor ebx, ebx
.lr_save:
 mov al, [rsi]
 test al, al
 jz .lr_save_end
 cmp ebx, 510
 jae .lr_save_end
 mov [rdi + rbx], al
 inc ebx
 inc rsi
 jmp .lr_save
.lr_save_end:
 mov byte [rdi + rbx], 0
 pop rsi

 lea rdi, [rel tok_b]
 xor ebx, ebx
.lw1:
 mov al, [rsi]
 test al, al
 jz .lw1_end
 cmp al, ' '
 je .lw1_end
 cmp al, 9
 je .lw1_end
 cmp ebx, 510
 jae .lw1_end
 mov [rdi + rbx], al
 inc ebx
 inc rsi
 jmp .lw1
.lw1_end:
 mov byte [rdi + rbx], 0
 call skip_blanks_rsi
 lea rdi, [rel tok_c]
 xor ebx, ebx
 xor edx, edx
.lw2:
 mov al, [rsi]
 test al, al
 jz .lw2_end
 test dl, dl
 jnz .lw2_inq



 cmp al, ';'
 je .lw2_end
 cmp al, 0x27
 je .lw2_open
 cmp al, 0x22
 je .lw2_open
 jmp .lw2_store
.lw2_open:
 mov dl, al
 jmp .lw2_store
.lw2_inq:
 cmp al, dl
 jne .lw2_store
 xor edx, edx
.lw2_store:
 cmp ebx, 510
 jae .lw2_end
 mov [rdi + rbx], al
 inc ebx
 inc rsi
 jmp .lw2
.lw2_end:
 mov byte [rdi + rbx], 0
 call trim_tok_c
 mov al, 2
 jmp .out
.label_only:
 mov al, 1
 jmp .out
.empty:
 xor al, al
.out:
 pop rdi
 pop rsi
 pop rbx
 ret

skip_blanks_rsi:
.l:
 mov al, [rsi]
 cmp al, ' '
 je .a
 cmp al, 9
 je .a
 ret
.a:
 inc rsi
 jmp .l

trim_tok_b:
 push rax
 push rcx
 lea rcx, [rel tok_b]
 call trim_trailing
 pop rcx
 pop rax
 ret
trim_tok_c:
 push rax
 push rcx
 lea rcx, [rel tok_c]
 call trim_trailing
 pop rcx
 pop rax
 ret
trim_trailing:
 push rsi
 mov rsi, rcx
 call str_len_local
 mov rcx, rsi
.l:
 test rax, rax
 jz .d
 movzx edx, byte [rcx + rax - 1]
 cmp dl, ' '
 je .cut
 cmp dl, 9
 je .cut
 jmp .d
.cut:
 dec rax
 mov byte [rcx + rax], 0
 jmp .l
.d:
 pop rsi
 ret


copy_tok:
 push rsi
 push rdi
 mov rsi, rcx
 mov rdi, rdx
.l:
 mov al, [rsi]
 mov [rdi], al
 test al, al
 jz .d
 inc rsi
 inc rdi
 jmp .l
.d:
 pop rdi
 pop rsi
 ret



is_data_dir:
 push rsi
 push rdi
 push rbx
 mov rsi, rcx
 lea rbx, [rel dd_table]
.dd_next:
 mov rdi, [rbx]
 test rdi, rdi
 jz .dd_no
 mov rcx, rsi
 mov rdx, rdi
.dd_cmp:
 mov al, [rdx]
 test al, al
 jz .dd_endname
 cmp al, [rcx]
 jne .dd_advance
 inc rcx
 inc rdx
 jmp .dd_cmp
.dd_endname:
 mov al, [rcx]
 cmp al, ' '
 je .dd_yes
 cmp al, 9
 je .dd_yes
.dd_advance:
 add rbx, 8
 jmp .dd_next
.dd_yes:
 mov al, 1
 pop rbx
 pop rdi
 pop rsi
 ret
.dd_no:
 xor al, al
 pop rbx
 pop rdi
 pop rsi
 ret





qualify_label:
 cmp byte [rcx], '.'
 je .ql_build
 ret
.ql_build:
 push rsi
 push rdi
 push rbx
 mov rsi, rcx
 mov rbx, rdx
 lea rdi, [rel qual_buf]
 xor rcx, rcx
 lea rdx, [rel cur_global]
.ql_cg:
 mov al, [rdx + rcx]
 test al, al
 jz .ql_cg_done
 cmp rcx, 60
 jae .ql_cg_done
 mov [rdi + rcx], al
 inc rcx
 jmp .ql_cg
.ql_cg_done:
 xor rdx, rdx
.ql_loc:
 cmp rdx, rbx
 je .ql_out
 cmp rcx, 156
 jae .ql_out
 mov al, [rsi + rdx]
 mov [rdi + rcx], al
 inc rcx
 inc rdx
 jmp .ql_loc
.ql_out:
 mov byte [rdi + rcx], 0
 mov rdx, rcx
 lea rcx, [rel qual_buf]
 pop rbx
 pop rdi
 pop rsi
 ret


str_eq:
 push rsi
 push rdi
 mov rsi, rcx
 mov rdi, rdx
.l:
 mov al, [rsi]
 cmp al, [rdi]
 jne .no
 test al, al
 jz .yes
 inc rsi
 inc rdi
 jmp .l
.no:
 xor al, al
 pop rdi
 pop rsi
 ret
.yes:
 mov al, 1
 pop rdi
 pop rsi
 ret





%line 2916+1 jasm.asm

[section .data]
 m_mov: db "mov",0
 m_push: db "push",0
 m_pop: db "pop",0
 m_add: db "add",0
 m_sub: db "sub",0
 m_imul: db "imul",0
 m_mul: db "mul",0
 m_idiv: db "idiv",0
 m_div: db "div",0
 m_cqo: db "cqo",0
 m_cmp: db "cmp",0
 m_test: db "test",0
 m_xor: db "xor",0
 m_neg: db "neg",0
 m_inc: db "inc",0
 m_dec: db "dec",0
 m_lea: db "lea",0
 m_ret: db "ret",0
 m_call: db "call",0
 m_jmp: db "jmp",0
 m_je: db "je",0
 m_jz: db "jz",0
 m_jne: db "jne",0
 m_jnz: db "jnz",0
 m_jns: db "jns",0
 m_jbe: db "jbe",0
 m_hlt: db "hlt",0
 m_cli: db "cli",0
 m_syscl: db "syscall",0
 m_iretq: db "iretq",0
 m_movzx: db "movzx",0
 m_movsx: db "movsx",0
 m_sete: db "sete",0
 m_setne: db "setne",0
 m_setl: db "setl",0
 m_setg: db "setg",0
 m_setle: db "setle",0
 m_setge: db "setge",0
 m_setb: db "setb",0
 m_setae: db "setae",0
 m_seta: db "seta",0
 m_setbe: db "setbe",0
 m_in: db "in",0
 m_out: db "out",0
 m_movsd: db "movsd",0
 m_addsd: db "addsd",0
 m_subsd: db "subsd",0
 m_mulsd: db "mulsd",0
 m_divsd: db "divsd",0
 m_comisd:db "comisd",0
 m_ucomisd:db "ucomisd",0
 m_shl: db "shl",0
 m_shr: db "shr",0
 m_sar: db "sar",0
 m_ja: db "ja",0
 m_jae: db "jae",0
 m_jb: db "jb",0
 m_jg: db "jg",0
 m_jge: db "jge",0
 m_jl: db "jl",0
 m_jle: db "jle",0
 m_js2: db "js",0
 m_and: db "and",0
 m_or: db "or",0
 m_not: db "not",0
 m_rep: db "rep",0
 m_movsb: db "movsb",0
 m_stosb: db "stosb",0
 m_cvtsi: db "cvtsi2sd",0
 m_cvtsd: db "cvtsd2si",0
 m_cvttsd:db "cvttsd2si",0
 m_xorps: db "xorps",0
 m_movq: db "movq",0

[section .text]


encode_line:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 push r14
 push r15

 mov byte [rel rex8_force], 0
 cmp byte [rel tok_a], 0
 je .done

%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_mov]
 call str_eq
 test al, al
 jnz .i_mov
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_push]
 call str_eq
 test al, al
 jnz .i_push
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_pop]
 call str_eq
 test al, al
 jnz .i_pop
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_add]
 call str_eq
 test al, al
 jnz .i_add
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_sub]
 call str_eq
 test al, al
 jnz .i_sub
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_imul]
 call str_eq
 test al, al
 jnz .i_imul
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_mul]
 call str_eq
 test al, al
 jnz .i_mul
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_idiv]
 call str_eq
 test al, al
 jnz .i_idiv
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_div]
 call str_eq
 test al, al
 jnz .i_div
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_cqo]
 call str_eq
 test al, al
 jnz .i_cqo
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_cmp]
 call str_eq
 test al, al
 jnz .i_cmp
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_test]
 call str_eq
 test al, al
 jnz .i_test
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_xor]
 call str_eq
 test al, al
 jnz .i_xor
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_neg]
 call str_eq
 test al, al
 jnz .i_neg
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_inc]
 call str_eq
 test al, al
 jnz .i_inc
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_dec]
 call str_eq
 test al, al
 jnz .i_dec
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_lea]
 call str_eq
 test al, al
 jnz .i_lea
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_ret]
 call str_eq
 test al, al
 jnz .i_ret
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_call]
 call str_eq
 test al, al
 jnz .i_call
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jmp]
 call str_eq
 test al, al
 jnz .i_jmp
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_je]
 call str_eq
 test al, al
 jnz .i_je
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jz]
 call str_eq
 test al, al
 jnz .i_je
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jne]
 call str_eq
 test al, al
 jnz .i_jne
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jnz]
 call str_eq
 test al, al
 jnz .i_jne
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jns]
 call str_eq
 test al, al
 jnz .i_jns
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jbe]
 call str_eq
 test al, al
 jnz .i_jbe
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_hlt]
 call str_eq
 test al, al
 jnz .i_hlt
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_cli]
 call str_eq
 test al, al
 jnz .i_cli
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_syscl]
 call str_eq
 test al, al
 jnz .i_syscall
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_iretq]
 call str_eq
 test al, al
 jnz .i_iretq
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_movzx]
 call str_eq
 test al, al
 jnz .i_movzx
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_movsx]
 call str_eq
 test al, al
 jnz .i_movsx
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_sete]
 call str_eq
 test al, al
 jnz .i_sete
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setne]
 call str_eq
 test al, al
 jnz .i_setne
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setl]
 call str_eq
 test al, al
 jnz .i_setl
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setg]
 call str_eq
 test al, al
 jnz .i_setg
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setle]
 call str_eq
 test al, al
 jnz .i_setle
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setge]
 call str_eq
 test al, al
 jnz .i_setge
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setb]
 call str_eq
 test al, al
 jnz .i_setb
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setae]
 call str_eq
 test al, al
 jnz .i_setae
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_seta]
 call str_eq
 test al, al
 jnz .i_seta
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_setbe]
 call str_eq
 test al, al
 jnz .i_setbe
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_in]
 call str_eq
 test al, al
 jnz .i_in
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_out]
 call str_eq
 test al, al
 jnz .i_out
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_movsd]
 call str_eq
 test al, al
 jnz .i_movsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_addsd]
 call str_eq
 test al, al
 jnz .i_addsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_subsd]
 call str_eq
 test al, al
 jnz .i_subsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_mulsd]
 call str_eq
 test al, al
 jnz .i_mulsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_divsd]
 call str_eq
 test al, al
 jnz .i_divsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_comisd]
 call str_eq
 test al, al
 jnz .i_comisd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_ucomisd]
 call str_eq
 test al, al
 jnz .i_ucomisd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_shl]
 call str_eq
 test al, al
 jnz .i_shl
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_shr]
 call str_eq
 test al, al
 jnz .i_shr
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_sar]
 call str_eq
 test al, al
 jnz .i_sar
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_ja]
 call str_eq
 test al, al
 jnz .i_ja
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jae]
 call str_eq
 test al, al
 jnz .i_jae
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jb]
 call str_eq
 test al, al
 jnz .i_jb
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jg]
 call str_eq
 test al, al
 jnz .i_jg
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jge]
 call str_eq
 test al, al
 jnz .i_jge
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jl]
 call str_eq
 test al, al
 jnz .i_jl
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_jle]
 call str_eq
 test al, al
 jnz .i_jle
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_js2]
 call str_eq
 test al, al
 jnz .i_js2
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_and]
 call str_eq
 test al, al
 jnz .i_and
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_or]
 call str_eq
 test al, al
 jnz .i_or
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_not]
 call str_eq
 test al, al
 jnz .i_not
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_rep]
 call str_eq
 test al, al
 jnz .i_rep
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_movsb]
 call str_eq
 test al, al
 jnz .i_movsb
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_stosb]
 call str_eq
 test al, al
 jnz .i_stosb
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_cvtsi]
 call str_eq
 test al, al
 jnz .i_cvtsi
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_cvtsd]
 call str_eq
 test al, al
 jnz .i_cvtsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_cvttsd]
 call str_eq
 test al, al
 jnz .i_cvttsd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_xorps]
 call str_eq
 test al, al
 jnz .i_xorps
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel m_movq]
 call str_eq
 test al, al
 jnz .i_movq
%line 3081+1 jasm.asm

 cmp byte [rel jasm_pass], 2
 jne .done
 mov byte [rel jasm_error], 1
 mov rax, [rel jasm_line]
 cmp qword [rel jasm_err_line], 0
 jne .rec_more
 mov [rel jasm_err_line], rax
.rec_more:
 mov rcx, [rel err_count]
 cmp rcx, 64
 jae .done
 lea rdx, [rel err_lines]
 mov [rdx + rcx*4], eax
 lea rdx, [rel err_dst]
 mov [rdx + rcx*4], r12d
 lea rdx, [rel err_src]
 mov [rdx + rcx*4], r14d
 push rcx
 call record_err_mnem
 pop rcx
 inc rcx
 mov [rel err_count], rcx
 jmp .done


.i_mov:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r13, rdx



 mov rax, [rel cur_addend]
 mov [rel dst_addend], rax
 mov [rel dst_base], r8
 lea rcx, [rel tok_c]
 call parse_operand
 mov r14d, eax
 mov r15, rdx
 mov [rel src_base], r8

 cmp r12d, 1
 je .mov_to_reg
 cmp r12d, 8
 je .mov_to_r32
 cmp r12d, 12
 je .mov_to_sib
 cmp r12d, 13
 je .mov_to_bd
 cmp r12d, 3
 je .mov_to_mem
 cmp r12d, 9
 je .mov_to_memreg
 cmp r12d, 5
 je .mov_to_rip
 cmp r12d, 11
 je .mov_to_rsp
 cmp r12d, 7
 je .mov_to_reg8
 cmp r12d, 10
 je .mov_to_reg16


 jmp .unsupported
.mov_to_r32:

 cmp r14d, 2
 je .m32_imm
 cmp r14d, 8
 je .m32_rr
 cmp r14d, 5
 je .m32_rip
 cmp r14d, 9
 je .m32_mem
 cmp r14d, 13
 je .m32_bd
 cmp r14d, 12
 je .m32_sib
 jmp .unsupported
.m32_sib:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 mov al, 0x8B
 call emit_sib_mem
 jmp .done
.m32_bd:



 xor edi, edi
 mov esi, r13d
 mov edx, [rel src_base]
 push r8
 call emit_rex
 mov al, 0x8B
 call emit_b
 pop r8
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.m32_mem:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.m32_imm:
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xB8
 mov cl, r13b
 and cl, 0x07
 or al, cl
 call emit_b
 mov eax, r15d
 call emit_d
 jmp .done
.m32_rr:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x89
 call emit_b
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 jmp .done
.m32_rip:
 xor edi, edi
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done

.mov_to_rsp:
 cmp r14d, 2
 jne .unsupported
 mov dil, 1
 xor esi, esi
 xor edx, edx
 call emit_rex
 mov al, 0xC7
 call emit_b
 mov r8d, r13d
 cmp r8d, 127
 ja .rsp_disp32
 mov dil, 1
 xor esi, esi
 mov dl, 4
 call emit_modrm
 mov al, 0x24
 call emit_b
 mov al, r8b
 call emit_b
 jmp .rsp_imm
.rsp_disp32:
 mov dil, 2
 xor esi, esi
 mov dl, 4
 call emit_modrm
 mov al, 0x24
 call emit_b
 mov eax, r8d
 call emit_d
.rsp_imm:
 mov eax, r15d
 call emit_d
 jmp .done
.mov_to_rip:
 cmp r14d, 7
 je .mov_to_rip8
 cmp r14d, 8
 je .mov_to_rip32
 cmp r14d, 10
 je .mov_to_rip16
 cmp r14d, 2
 je .mov_to_rip_imm
 cmp r14d, 1
 jne .unsupported
 mov dil, 1
 mov esi, r15d
 mov edx, 0
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov eax, r13d
 call emit_rip
 jmp .done
.mov_to_rip16:
 mov al, 0x66
 call emit_b
 xor edi, edi
 mov esi, r15d
 mov edx, 0
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov eax, r13d
 call emit_rip
 jmp .done
.mov_to_rip32:

 xor edi, edi
 mov esi, r15d
 mov edx, 0
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov eax, r13d
 call emit_rip
 jmp .done
.mov_to_rip_imm:


 cmp byte [rel op_size], 1
 je .mtri_byte
 cmp byte [rel op_size], 2
 je .mtri_word
 xor edi, edi
 cmp byte [rel op_size], 4
 je .mtri_nw
 mov dil, 1
.mtri_nw:
 xor esi, esi
 mov edx, 0
 call emit_rex
 mov al, 0xC7
 call emit_b
 xor esi, esi



 mov rax, [rel dst_addend]
 mov [rel cur_addend], rax
 sub qword [rel cur_addend], 4
 mov eax, r13d
 call emit_rip
 mov eax, r15d
 call emit_d
 jmp .done
.mtri_word:


 mov al, 0x66
 call emit_b
 xor edi, edi
 xor esi, esi
 mov edx, 0
 call emit_rex
 mov al, 0xC7
 call emit_b
 xor esi, esi
 mov rax, [rel dst_addend]
 mov [rel cur_addend], rax
 sub qword [rel cur_addend], 2
 mov eax, r13d
 call emit_rip
 mov eax, r15d
 call emit_w
 jmp .done

.mtri_byte:
 mov al, 0xC6
 call emit_b
 xor esi, esi
 mov rax, [rel dst_addend]
 mov [rel cur_addend], rax
 sub qword [rel cur_addend], 1
 mov eax, r13d
 call emit_rip
 mov eax, r15d
 call emit_b
 jmp .done
.mov_to_rip8:




 cmp r15d, 4
 jb .mrip8_go
 mov byte [rel rex8_force], 1
.mrip8_go:
 xor edi, edi
 mov esi, r15d
 mov edx, 0
 call emit_rex
 mov al, 0x88
 call emit_b
 mov esi, r15d
 mov eax, r13d
 call emit_rip
 jmp .done

.mov_to_bd:

 cmp r14d, 1
 je .mbd_r64
 cmp r14d, 8
 je .mbd_r32
 cmp r14d, 10
 je .mbd_r16
 cmp r14d, 2
 je .mbd_imm
 cmp r14d, 7
 je .mbd_r8
 jmp .unsupported
.mbd_r8:

 cmp r15d, 4
 jb .mbd8_go
 mov byte [rel rex8_force], 1
.mbd8_go:
 xor edi, edi
 mov esi, r15d
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0x88
 call emit_b
 mov esi, r15d
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 jmp .done
.mbd_r32:

 xor edi, edi
 mov esi, r15d
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 jmp .done
.mbd_r16:

 mov al, 0x66
 call emit_b
 xor edi, edi
 mov esi, r15d
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 jmp .done
.mbd_r64:
 mov dil, 1
 mov esi, r15d
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 jmp .done
.mbd_imm8:

 xor edi, edi
 xor esi, esi
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0xC6
 call emit_b
 xor esi, esi
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 mov eax, r15d
 call emit_b
 jmp .done
.mbd_imm16:

 mov al, 0x66
 call emit_b
 xor edi, edi
 xor esi, esi
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0xC7
 call emit_b
 xor esi, esi
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 mov eax, r15d
 call emit_w
 jmp .done

.mbd_imm:

 cmp byte [rel op_size], 1
 je .mbd_imm8
 cmp byte [rel op_size], 2
 je .mbd_imm16
 xor edi, edi
 cmp byte [rel op_size], 4
 je .mbd_norexw
 mov dil, 1
.mbd_norexw:
 xor esi, esi
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0xC7
 call emit_b
 xor esi, esi
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 mov eax, r15d
 call emit_d
 jmp .done
.mov_to_sib:


 cmp r14d, 7
 je .msib_r8
 cmp r14d, 8
 je .msib_r32
 cmp r14d, 10
 je .msib_r16
 cmp r14d, 2
 je .msib_imm
 cmp r14d, 1
 jne .unsupported
 mov dil, 1
 mov esi, r15d
 mov edx, r13d
 mov al, 0x89
 call emit_sib_mem
 jmp .done
.msib_r32:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 mov al, 0x89
 call emit_sib_mem
 jmp .done
.msib_r16:
 mov al, 0x66
 call emit_b
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 mov al, 0x89
 call emit_sib_mem
 jmp .done
.msib_r8:

 cmp r15d, 4
 jb .msib8_go
 mov byte [rel rex8_force], 1
.msib8_go:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 mov al, 0x88
 call emit_sib_mem
 jmp .done
.msib_imm:
 cmp byte [rel op_size], 1
 jne .unsupported
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 mov al, 0xC6
 call emit_sib_mem
 mov eax, r15d
 call emit_b
 jmp .done
.mov_from_sib:

 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 mov al, 0x8B
 call emit_sib_mem
 jmp .done




.mov_to_reg16:
 mov al, 0x66
 call emit_b
 cmp r14d, 2
 je .mr16_imm
 cmp r14d, 10
 je .mr16_r16
 cmp r14d, 9
 je .mr16_mem
 cmp r14d, 5
 je .mr16_rip
 cmp r14d, 12
 je .mr16_sib
 cmp r14d, 13
 je .mr16_bd
 jmp .unsupported
.mr16_imm:

 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xB8
 mov cl, r13b
 and cl, 0x07
 or al, cl
 call emit_b
 mov eax, r15d
 call emit_w
 jmp .done
.mr16_r16:

 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x89
 call emit_b
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 jmp .done
.mr16_mem:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.mr16_rip:

 xor edi, edi
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.mr16_sib:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 mov al, 0x8B
 call emit_sib_mem
 jmp .done
.mr16_bd:

 xor edi, edi
 mov esi, r13d
 mov edx, [rel src_base]
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done





.mov_to_reg8:


 cmp r13d, 4
 jb .mr8_dispatch
 mov byte [rel rex8_force], 1
.mr8_dispatch:
 cmp r14d, 7
 je .mr8_r8
 cmp r14d, 2
 je .mr8_imm
 cmp r14d, 9
 je .mr8_mem
 cmp r14d, 12
 je .mr8_sib
 cmp r14d, 13
 je .mr8_bd
 cmp r14d, 5
 je .mr8_rip
 cmp r14d, 3
 je .mr8_rbp
 jmp .unsupported
.mr8_r8:

 cmp r15d, 4
 jb .mr8_r8_go
 mov byte [rel rex8_force], 1
.mr8_r8_go:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x88
 call emit_b
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 jmp .done
.mr8_imm:

 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xB0
 mov cl, r13b
 and cl, 0x07
 or al, cl
 call emit_b
 mov eax, r15d
 call emit_b
 jmp .done
.mr8_mem:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x8A
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.mr8_sib:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 mov al, 0x8A
 call emit_sib_mem
 jmp .done
.mr8_bd:

 xor edi, edi
 mov esi, r13d
 mov edx, [rel src_base]
 call emit_rex
 mov al, 0x8A
 call emit_b
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.mr8_rip:

 xor edi, edi
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x8A
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.mr8_rbp:

 xor edi, edi
 mov esi, r13d
 mov edx, 5
 call emit_rex
 mov al, 0x8A
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_mem_rbp
 jmp .done


.mov_to_reg:
 cmp r14d, 12
 je .mov_from_sib
 cmp r14d, 2
 je .mov_r_imm
 cmp r14d, 1
 je .mov_r_r
 cmp r14d, 3
 je .mov_r_mem
 cmp r14d, 5
 je .mov_r_rip
 cmp r14d, 9
 je .mov_r_memreg
 cmp r14d, 13
 je .mov_r_bd
 cmp r14d, 11
 je .mov_r_rsp
 cmp r14d, 4
 je .mov_r_label



 jmp .unsupported
.mov_r_label:





 mov dil, 1
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x8D
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done

.mov_r_memreg:

 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.mov_r_bd:

 mov dil, 1
 mov esi, r13d
 mov edx, [rel src_base]
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.mov_r_rsp:

 mov dil, 1
 mov esi, r13d
 mov edx, 4
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov edx, 4
 mov eax, r15d
 neg eax
 call emit_mem_base_disp
 jmp .done

.mov_r_rip:

 mov dil, 1
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.mov_r_imm:



 mov rax, r15
 shr rax, 32
 test rax, rax
 jnz .mov_imm64
 test r15d, r15d
 js .mov_imm64

 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xB8
 mov cl, r13b
 and cl, 0x07
 or al, cl
 call emit_b
 mov eax, r15d
 call emit_d
 jmp .done
.mov_imm64:
 mov dil, 1
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xB8
 mov cl, r13b
 and cl, 0x07
 or al, cl
 call emit_b
 mov rax, r15
 call emit_q
 jmp .done
.mov_r_r:

 mov dil, 1
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x89
 call emit_b
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 jmp .done
.mov_r_mem:

 mov dil, 1
 mov esi, r13d
 mov edx, 5
 call emit_rex
 mov al, 0x8B
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_mem_rbp
 jmp .done

.mov_to_mem:

 cmp r14d, 1
 jne .unsupported
 mov dil, 1
 mov esi, r15d
 mov edx, 5
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov eax, r13d
 call emit_mem_rbp
 jmp .done

.mov_to_memreg:
 cmp r14d, 2
 je .mov_to_memreg_imm
 cmp r14d, 7
 je .mov_to_memreg8
 cmp r14d, 8
 je .mov_to_memreg32
 cmp r14d, 10
 je .mov_to_memreg16

 cmp r14d, 1
 jne .unsupported
 mov dil, 1
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov edx, r13d
 call emit_mem_reg
 jmp .done
.mov_to_memreg16:

 mov al, 0x66
 call emit_b
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov edx, r13d
 call emit_mem_reg
 jmp .done
.mov_to_memreg32:

 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x89
 call emit_b
 mov esi, r15d
 mov edx, r13d
 call emit_mem_reg
 jmp .done
.mov_to_memreg_imm:



 cmp byte [rel op_size], 1
 je .mtmi_byte
 cmp byte [rel op_size], 2
 je .mtmi_word
 xor edi, edi
 cmp byte [rel op_size], 4
 je .mtmi_norexw
 mov dil, 1
.mtmi_norexw:
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xC7
 call emit_b
 xor esi, esi
 mov edx, r13d
 call emit_mem_reg
 mov eax, r15d
 call emit_d
 jmp .done
.mtmi_word:


 mov al, 0x66
 call emit_b
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xC7
 call emit_b
 xor esi, esi
 mov edx, r13d
 call emit_mem_reg
 mov eax, r15d
 call emit_w
 jmp .done

.mtmi_byte:
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xC6
 call emit_b
 xor esi, esi
 mov edx, r13d
 call emit_mem_reg
 mov eax, r15d
 call emit_b
 jmp .done
.mov_to_memreg8:


 cmp r15d, 4
 jb .mmr8_go
 mov byte [rel rex8_force], 1
.mmr8_go:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 call emit_rex
 mov al, 0x88
 call emit_b
 mov esi, r15d
 mov edx, r13d
 call emit_mem_reg
 jmp .done


.i_push:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r14d, eax
 cmp eax, 1
 jne .unsupported
 cmp edx, 8
 jb .push_lo
 mov al, 0x41
 call emit_b
.push_lo:
 mov al, 0x50
 mov cl, dl
 and cl, 0x07
 or al, cl
 call emit_b
 jmp .done
.i_pop:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r14d, eax
 cmp eax, 1
 jne .unsupported
 cmp edx, 8
 jb .pop_lo
 mov al, 0x41
 call emit_b
.pop_lo:
 mov al, 0x58
 mov cl, dl
 and cl, 0x07
 or al, cl
 call emit_b
 jmp .done


.i_add:
 mov bl, 0x01
 mov r8b, 0
 jmp .arith
.i_sub:
 mov bl, 0x29
 mov r8b, 5
 jmp .arith
.i_cmp:
 mov bl, 0x39
 mov r8b, 7
 jmp .arith
.i_and:
 mov bl, 0x21
 mov r8b, 4
 jmp .arith
.i_or:
 mov bl, 0x09
 mov r8b, 1
 jmp .arith
.i_not:
 mov bl, 2
 jmp .unary_f7
.i_xor:
 mov bl, 0x31
 mov r8b, 6
 jmp .arith
.i_test:
 mov bl, 0x85
 mov r8b, 0
 jmp .arith

.arith:
 push r8
 lea rcx, [rel tok_b]
 call parse_operand
 mov [rel dst_base], r8
 mov r12d, eax
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov [rel src_base], r8
 mov r14d, eax
 mov r15d, edx
 pop r8
 cmp r12d, 12
 je .arith_sib_imm
 cmp r12d, 7
 je .arith_r8
 cmp r12d, 8
 je .arith_r32
 cmp r12d, 5
 je .arith_mem_imm
 cmp r12d, 9
 je .arith_mem_imm
 cmp r12d, 13
 je .arith_mem_imm
 cmp r12d, 1
 jne .unsupported
 cmp r14d, 1
 je .arith_rr
 cmp r14d, 2
 je .arith_ri
 cmp r14d, 5
 je .arith_r_rip
 cmp r14d, 9
 je .arith_r_mem
 cmp r14d, 13
 je .arith_r_bd
 jmp .unsupported
.arith_mem_imm:



 cmp r14d, 1
 je .arith_mem_reg
 cmp r14d, 2
 jne .unsupported
 push r8
 push r12

 cmp byte [rel op_size], 2
 jne .ami_nopfx
 mov al, 0x66
 call emit_b
.ami_nopfx:
 xor edi, edi
 cmp byte [rel op_size], 1
 je .ami_norexw
 cmp byte [rel op_size], 2
 je .ami_norexw
 cmp byte [rel op_size], 4
 je .ami_norexw
 mov dil, 1
 jmp .ami_norexw

.arith_mem_reg:

 push r8
 mov dil, 1
 mov esi, r15d
 mov edx, r13d
 cmp r12d, 5
 jne .amr_chk_bd
 mov edx, 0
 jmp .amr_rex
.amr_chk_bd:
 cmp r12d, 13
 jne .amr_rex
 mov edx, [rel dst_base]
.amr_rex:
 call emit_rex
 mov al, bl
 call emit_b
 pop r8
 mov esi, r15d
 cmp r12d, 5
 je .amr_rip
 cmp r12d, 13
 je .amr_bd
 mov edx, r13d
 call emit_mem_reg
 jmp .done
.amr_rip:
 mov eax, r13d
 call emit_rip
 jmp .done
.amr_bd:
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 jmp .done
.ami_norexw:
 xor esi, esi
 mov edx, r13d
 cmp r12d, 13
 jne .ami_rex



 mov edx, [rel dst_base]
.ami_rex:
 cmp r12d, 5
 jne .ami_do_rex
 mov edx, 0
.ami_do_rex:
 call emit_rex
 mov al, 0x81
 cmp byte [rel op_size], 1
 jne .ami_op
 mov al, 0x80
.ami_op:
 call emit_b
 pop r12
 pop r8
 movzx esi, r8b
 cmp r12d, 5
 je .ami_rip
 cmp r12d, 13
 je .ami_bd
 mov edx, r13d
 call emit_mem_reg
 jmp .ami_imm
.ami_rip:
 mov eax, r13d
 call emit_rip
 jmp .ami_imm
.ami_bd:
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
.ami_imm:
 mov eax, r15d
 cmp byte [rel op_size], 1
 je .ami_imm8
 cmp byte [rel op_size], 2
 je .ami_imm16
 call emit_d
 jmp .done
.ami_imm16:
 call emit_w
 jmp .done

.ami_imm8:
 call emit_b
 jmp .done
.arith_rev_op:



 mov al, bl
 cmp al, 0x85
 je .arith_rev_done
 add al, 2
.arith_rev_done:
 ret
.arith_r_rip:
 mov dil, 1
 mov esi, r13d
 mov edx, 0
 call emit_rex
 call .arith_rev_op
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.arith_r_mem:
 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 call .arith_rev_op
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.arith_r_bd:
 mov dil, 1
 mov esi, r13d
 mov edx, [rel src_base]
 push r8
 call emit_rex
 call .arith_rev_op
 call emit_b
 pop r8
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.arith_r32:

 cmp r14d, 8
 je .ar32_rr
 cmp r14d, 2
 je .ar32_ri
 cmp r14d, 12
 je .ar32_sib
 cmp r14d, 9
 je .ar32_mem
 cmp r14d, 13
 je .ar32_bd
 cmp r14d, 5
 je .ar32_rip
 jmp .unsupported
.ar32_sib:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 call .arith_rev_op
 call emit_sib_mem
 jmp .done
.ar32_mem:
 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 call .arith_rev_op
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.ar32_bd:
 xor edi, edi
 mov esi, r13d
 mov edx, [rel src_base]
 push r8
 call emit_rex
 call .arith_rev_op
 call emit_b
 pop r8
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.ar32_rip:
 xor edi, edi
 mov esi, r13d
 mov edx, 0
 call emit_rex
 call .arith_rev_op
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.ar32_rr:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 push r8
 call emit_rex
 mov al, bl
 call emit_b
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 pop r8
 jmp .done
.ar32_test:

 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xF7
 call emit_b
 mov dil, 3
 xor esi, esi
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_d
 jmp .done

.ar32_ri:
 cmp bl, 0x85
 je .ar32_test
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 push r8
 call emit_rex
 cmp r15d, 127
 ja .ar32_i32
 mov al, 0x83
 call emit_b
 pop r8
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_b
 jmp .done
.ar32_i32:
 mov al, 0x81
 call emit_b
 pop r8
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_d
 jmp .done

.arith_r8_rip:

 xor edi, edi
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, bl
 inc al
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.arith_r8_rbp:

 xor edi, edi
 mov esi, r13d
 mov edx, 5
 call emit_rex
 mov al, bl
 inc al
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_mem_rbp
 jmp .done
.arith_r8_bd:

 xor edi, edi
 mov esi, r13d
 mov edx, [rel src_base]
 push r8
 call emit_rex
 mov al, bl
 inc al
 call emit_b
 pop r8
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.arith_r8_mem:

 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, bl
 inc al
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.arith_r8_sib:


 xor edi, edi
 mov esi, r13d
 mov edx, r15d
 mov al, bl
 inc al
 call emit_sib_mem
 jmp .done
.arith_r8_rr:





 cmp r13d, 4
 jb .ar8rr_chk_src
 mov byte [rel rex8_force], 1
.ar8rr_chk_src:
 cmp r15d, 4
 jb .ar8rr_go
 mov byte [rel rex8_force], 1
.ar8rr_go:
 xor edi, edi
 mov esi, r15d
 mov edx, r13d
 push r8
 call emit_rex
 mov al, bl
 dec al
 call emit_b
 pop r8
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 jmp .done
.arith_r8:





 cmp r13d, 4
 jb .arith_r8_dispatch
 mov byte [rel rex8_force], 1
.arith_r8_dispatch:
 cmp r14d, 12
 je .arith_r8_sib
 cmp r14d, 9
 je .arith_r8_mem
 cmp r14d, 7
 je .arith_r8_rr
 cmp r14d, 5
 je .arith_r8_rip
 cmp r14d, 3
 je .arith_r8_rbp
 cmp r14d, 13
 je .arith_r8_bd
 cmp r14d, 2
 jne .unsupported
 cmp bl, 0x85
 je .r8i_test
 mov eax, r13d
 cmp eax, 8
 jae .r8i_rexb
 cmp eax, 4
 jb .r8i_op
 mov al, 0x40
 call emit_b
 jmp .r8i_op
.r8i_test:

 mov eax, r13d
 cmp eax, 8
 jae .r8t_rexb
 cmp eax, 4
 jb .r8t_op
 mov al, 0x40
 call emit_b
 jmp .r8t_op
.r8t_rexb:
 mov al, 0x41
 call emit_b
.r8t_op:
 mov al, 0xF6
 call emit_b
 mov dil, 3
 xor esi, esi
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_b
 jmp .done
.r8i_rexb:
 mov al, 0x41
 call emit_b
.r8i_op:
 mov al, 0x80
 call emit_b
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_b
 jmp .done
.arith_sib_imm:
 cmp r14d, 2
 jne .unsupported
 cmp byte [rel op_size], 1
 jne .unsupported
 push rbx
 push rbp
 mov ebx, r13d
 and ebx, 0xFF
 mov ebp, r13d
 shr ebp, 8
 and ebp, 0xFF
 mov al, 0x40
 test bpl, 0x08
 jz .sib_no_x
 or al, 0x02
.sib_no_x:
 test bl, 0x08
 jz .sib_no_b
 or al, 0x01
.sib_no_b:
 cmp al, 0x40
 je .sib_no_rex
 call emit_b
.sib_no_rex:
 mov al, 0x80
 call emit_b
 mov dil, 0
 mov sil, r8b
 mov dl, 4
 call emit_modrm
 mov eax, ebp
 and eax, 0x07
 shl eax, 3
 mov ecx, ebx
 and ecx, 0x07
 or eax, ecx
 call emit_b
 mov eax, r15d
 call emit_b
 pop rbp
 pop rbx
 jmp .done
.arith_rr:
 mov dil, 1
 mov esi, r15d
 mov edx, r13d
 push r8
 call emit_rex
 mov al, bl
 call emit_b
 mov dil, 3
 mov esi, r15d
 mov edx, r13d
 call emit_modrm
 pop r8
 jmp .done
.ari_test:

 mov dil, 1
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xF7
 call emit_b
 mov dil, 3
 xor esi, esi
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_d
 jmp .done

.arith_ri:



 cmp bl, 0x85
 je .ari_test
 mov dil, 1
 xor esi, esi
 mov edx, r13d
 push r8
 call emit_rex

 cmp r15d, 127
 ja .ari_32
 mov al, 0x83
 call emit_b
 pop r8
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_b
 jmp .done
.ari_32:
 mov al, 0x81
 call emit_b
 pop r8
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_d
 jmp .done


.i_imul:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r13d, edx


 lea rsi, [rel tok_c]
.imul_scan:
 mov al, [rsi]
 test al, al
 jz .imul_two
 cmp al, ','
 je .imul_three
 inc rsi
 jmp .imul_scan
.imul_three:
 mov byte [rsi], 0
 push rsi
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 pop rsi
 mov byte [rsi], ','
 inc rsi
.imul_skip_sp:
 cmp byte [rsi], ' '
 jne .imul_imm
 inc rsi
 jmp .imul_skip_sp
.imul_imm:
 mov rcx, rsi
 push r13
 push r15
 call parse_expr
 pop r15
 pop r13
 mov r14, rax
.imul_emit:



 xor edi, edi
 cmp r12d, 1
 jne .ie_norexw
 mov dil, 1
.ie_norexw:
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov rax, r14
 movsx rcx, al
 cmp rcx, r14
 jne .imul_i32
 mov al, 0x6B
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 mov rax, r14
 call emit_b
 jmp .done
.imul_i32:
 mov al, 0x69
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 mov rax, r14
 call emit_d
 jmp .done
.imul_two:
 lea rcx, [rel tok_c]
 call parse_operand
 mov r14d, eax
 mov r15d, edx
 cmp r14d, 2
 jne .imul_two_reg



 mov rax, r15
 mov r14, rax
 mov rax, r13
 mov r15, rax
 jmp .imul_emit
.imul_two_reg:
 xor edi, edi
 cmp r12d, 1
 jne .itr_norexw
 mov dil, 1
.itr_norexw:
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0xAF
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_mul:
 mov bl, 4
 jmp .unary_f7
.i_idiv:
 mov bl, 7
 jmp .unary_f7
.i_div:
 mov bl, 6
 jmp .unary_f7
.i_neg:
 mov bl, 3
 jmp .unary_f7
.unary_f7:
 lea rcx, [rel tok_b]
 call parse_operand
 mov [rel dst_base], r8
 mov r12d, eax
 mov r14d, eax
 cmp eax, 8
 je .unary_f7_r32
 cmp eax, 1
 jne .unsupported
 mov r13d, edx
 mov dil, 1
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xF7
 call emit_b
 mov dil, 3
 movzx esi, bl
 mov edx, r13d
 call emit_modrm
 jmp .done

.unary_f7_r32:

 mov r13d, edx
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xF7
 call emit_b
 mov dil, 3
 movzx esi, bl
 mov edx, r13d
 call emit_modrm
 jmp .done


.i_inc:
 mov bl, 0
 jmp .unary_ff
.i_dec:
 mov bl, 1
.unary_ff:
 lea rcx, [rel tok_b]
 call parse_operand
 mov [rel dst_base], r8
 mov r12d, eax
 mov r14d, eax
 cmp eax, 5
 je .unary_ff_rip
 cmp eax, 8
 je .unary_ff_r32
 cmp eax, 7
 je .unary_ff_r8
 cmp eax, 13
 je .unary_ff_bd
 cmp eax, 1
 jne .unsupported
 mov r13d, edx
 mov dil, 1
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xFF
 call emit_b
 mov dil, 3
 movzx esi, bl
 mov edx, r13d
 call emit_modrm
 jmp .done

.unary_ff_r32:

 mov r13d, edx
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xFF
 call emit_b
 mov dil, 3
 movzx esi, bl
 mov edx, r13d
 call emit_modrm
 jmp .done
.unary_ff_r8:

 mov r13d, edx
 cmp r13d, 4
 jb .uff8_go
 mov byte [rel rex8_force], 1
.uff8_go:
 xor edi, edi
 xor esi, esi
 mov edx, r13d
 call emit_rex
 mov al, 0xFE
 call emit_b
 mov dil, 3
 movzx esi, bl
 mov edx, r13d
 call emit_modrm
 jmp .done
.unary_ff_bd:

 mov r13d, edx
 cmp byte [rel op_size], 2
 jne .uffb_nopfx
 mov al, 0x66
 call emit_b
.uffb_nopfx:
 xor edi, edi
 cmp byte [rel op_size], 1
 je .uffb_go
 cmp byte [rel op_size], 2
 je .uffb_go
 cmp byte [rel op_size], 4
 je .uffb_go
 mov dil, 1
.uffb_go:
 xor esi, esi
 mov edx, [rel dst_base]
 call emit_rex
 mov al, 0xFF
 cmp byte [rel op_size], 1
 jne .uffb_op
 mov al, 0xFE
.uffb_op:
 call emit_b
 movzx esi, bl
 mov edx, [rel dst_base]
 mov eax, r13d
 call emit_mem_base_disp
 jmp .done

.unary_ff_rip:



 mov r13d, edx
 cmp byte [rel op_size], 2
 jne .uffr_nopfx
 mov al, 0x66
 call emit_b
.uffr_nopfx:
 xor edi, edi
 cmp byte [rel op_size], 1
 je .uffr_go
 cmp byte [rel op_size], 2
 je .uffr_go
 cmp byte [rel op_size], 4
 je .uffr_go
 mov dil, 1
.uffr_go:
 xor esi, esi
 xor edx, edx
 call emit_rex
 mov al, 0xFF
 cmp byte [rel op_size], 1
 jne .uffr_op
 mov al, 0xFE
.uffr_op:
 call emit_b
 movzx esi, bl
 mov eax, r13d
 call emit_rip
 jmp .done


.i_lea:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r14d, eax
 mov r15d, edx
 mov [rel src_base], r8
 cmp r14d, 5
 je .lea_rip
 cmp r14d, 11
 je .lea_rsp
 cmp r14d, 12
 je .lea_sib
 cmp r14d, 9
 je .lea_memreg
 cmp r14d, 13
 je .lea_bd
 cmp r14d, 3

 jne .unsupported
 mov dil, 1
 mov esi, r13d
 mov edx, 5
 call emit_rex
 mov al, 0x8D
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_mem_rbp
 jmp .done
.lea_sib:

 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 mov al, 0x8D
 call emit_sib_mem
 jmp .done
.lea_memreg:

 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x8D
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done

.lea_rsp:


 mov dil, 1
 mov esi, r13d
 mov edx, 4
 call emit_rex
 mov al, 0x8D
 call emit_b
 mov esi, r13d
 mov edx, 4
 mov eax, r15d
 neg eax
 call emit_mem_base_disp
 jmp .done
.lea_bd:

 mov dil, 1
 mov esi, r13d
 mov edx, [rel src_base]
 call emit_rex
 mov al, 0x8D
 call emit_b
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done
.lea_rip:
 mov dil, 1
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x8D
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done


.i_ret:
 mov al, 0xC3
 call emit_b
 jmp .done
.i_rep:


 mov al, 0xF3
 call emit_b
 lea rcx, [rel tok_b]
 lea rdx, [rel m_movsb]
 call str_eq
 test al, al
 jnz .i_movsb
 lea rcx, [rel tok_b]
 lea rdx, [rel m_stosb]
 call str_eq
 test al, al
 jnz .i_stosb
 jmp .unsupported
.i_movsb:
 mov al, 0xA4
 call emit_b
 jmp .done
.i_stosb:
 mov al, 0xAA
 call emit_b
 jmp .done
.i_hlt:
 mov al, 0xF4
 call emit_b
 jmp .done
.i_cli:
 mov al, 0xFA
 call emit_b
 jmp .done
.i_syscall:
 mov al, 0x0F
 call emit_b
 mov al, 0x05
 call emit_b
 jmp .done
.i_cqo:
 mov al, 0x48
 call emit_b
 mov al, 0x99
 call emit_b
 jmp .done
.i_iretq:
 mov al, 0x48
 call emit_b
 mov al, 0xCF
 call emit_b
 jmp .done

.i_call:
 lea rcx, [rel tok_b]
 call parse_operand
 cmp eax, 1
 jne .i_call_direct
 push rdx
 xor edi, edi
 xor esi, esi
 call emit_rex
 mov al, 0xFF
 call emit_b
 pop rdx
 mov dil, 3
 mov sil, 2
 call emit_modrm
 jmp .done
.i_call_direct:
 mov al, 0xE8
 call emit_b
 jmp .rel32_target
.i_jmp:
 mov al, 0xE9
 call emit_b
 jmp .rel32_target
.i_ja:
 mov bl, 0x87
 jmp .jcc
.i_jae:
 mov bl, 0x83
 jmp .jcc
.i_jb:
 mov bl, 0x82
 jmp .jcc
.i_jg:
 mov bl, 0x8F
 jmp .jcc
.i_jge:
 mov bl, 0x8D
 jmp .jcc
.i_jl:
 mov bl, 0x8C
 jmp .jcc
.i_jle:
 mov bl, 0x8E
 jmp .jcc
.i_js2:
 mov bl, 0x88
 jmp .jcc
.i_je:
 mov bl, 0x84
 jmp .jcc
.i_jne:
 mov bl, 0x85
 jmp .jcc
.i_jns:
 mov bl, 0x89
 jmp .jcc
.i_jbe:
 mov bl, 0x86
.jcc:
 mov al, 0x0F
 call emit_b
 mov al, bl
 call emit_b
.rel32_target:
 lea rcx, [rel tok_b]
 call parse_operand
 cmp eax, 4
 jne .rel_zero
 cmp edx, -1
 je .rel_zero

 push rdx
 mov eax, edx
 xor edi, edi
 call add_fixup
 pop rdx
 xor eax, eax
 call emit_d
 jmp .done
.rel_zero:

 lea rcx, [rel tok_b]
 push rcx
 call str_len_local
 mov rdx, rax
 pop rcx
 call jasm_find_extern
 cmp eax, -1
 je .rel_unknown
 call jasm_add_extref
.rel_unknown:
 xor eax, eax
 call emit_d
 jmp .done


.i_sete:
 mov bl, 0x94
 jmp .setcc
.i_setne:
 mov bl, 0x95
 jmp .setcc
.i_setl:
 mov bl, 0x9C
 jmp .setcc
.i_setg:
 mov bl, 0x9F
 jmp .setcc
.i_setle:
 mov bl, 0x9E
 jmp .setcc
.i_setb:
 mov bl, 0x92
 jmp .setcc
.i_setae:
 mov bl, 0x93
 jmp .setcc
.i_seta:
 mov bl, 0x97
 jmp .setcc
.i_setbe:
 mov bl, 0x96
 jmp .setcc
.i_setge:
 mov bl, 0x9D
.setcc:
 mov al, 0x0F
 call emit_b
 mov al, bl
 call emit_b
 mov al, 0xC0
 call emit_b
 jmp .done


.movzx_mem:



 xor edi, edi
 cmp r12d, 1
 jne .mzm_norexw
 mov dil, 1
.mzm_norexw:




 cmp byte [rel op_size], 4
 je .mz32_load
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0xB6
 cmp byte [rel op_size], 2
 jne .mzm_op
 mov al, 0xB7
.mzm_op:
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.mz32_load:


 cmp r14d, 9
 je .m32_mem
 cmp r14d, 13
 je .m32_bd
 cmp r14d, 12
 je .m32_sib
 cmp r14d, 5
 je .m32_rip
 jmp .unsupported

.movzx_sib:



 xor eax, eax
 cmp r12d, 1
 jne .mzs_now
 or al, 0x08
.mzs_now:
 mov ecx, r13d
 and ecx, 8
 cmp ecx, 0
 je .mzs_nor
 or al, 0x04
.mzs_nor:
 mov ecx, r15d
 shr ecx, 8
 and ecx, 8
 cmp ecx, 0
 je .mzs_nox
 or al, 0x02
.mzs_nox:
 mov ecx, r15d
 and ecx, 8
 cmp ecx, 0
 je .mzs_nob
 or al, 0x01
.mzs_nob:
 cmp al, 0
 je .mzs_esc
 or al, 0x40
 call emit_b
.mzs_esc:
 cmp byte [rel op_size], 4
 je .mz32_load
 mov al, 0x0F
 call emit_b
 mov al, 0xB6
 cmp byte [rel op_size], 2
 jne .mzs_op
 mov al, 0xB7
.mzs_op:
 call emit_b
 mov esi, r13d
 mov edx, r15d
 call emit_sib_modrm
 jmp .done
.movzx_bd:

 xor edi, edi
 cmp r12d, 1
 jne .mzb_norexw
 mov dil, 1
.mzb_norexw:




 cmp byte [rel op_size], 4
 je .mz32_load
 mov esi, r13d
 mov edx, [rel src_base]
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0xB6
 cmp byte [rel op_size], 2
 jne .mzb_op
 mov al, 0xB7
.mzb_op:
 call emit_b
 mov esi, r13d
 mov edx, [rel src_base]
 mov eax, r15d
 call emit_mem_base_disp
 jmp .done

.movzx_rip:


 xor edi, edi
 cmp r12d, 1
 jne .mzr_norexw
 mov dil, 1
.mzr_norexw:




 cmp byte [rel op_size], 4
 je .mz32_load
 mov esi, r13d
 mov edx, 0
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0xB6
 cmp byte [rel op_size], 2
 jne .mzr_op
 mov al, 0xB7
.mzr_op:
 call emit_b
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done

.i_movsx:

 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r14d, eax
 mov r15d, edx
 cmp r14d, 7
 jne .unsupported
 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0xBE
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done
.i_movzx:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov [rel src_base], r8
 mov r14d, eax
 mov r15d, edx
 cmp r14d, 5
 je .movzx_rip
 cmp r14d, 9
 je .movzx_mem
 cmp r14d, 12
 je .movzx_sib
 cmp r14d, 13
 je .movzx_bd
 cmp r14d, 7
 je .movzx_rr
 cmp r14d, 10
 je .movzx_rr


 jmp .unsupported
.movzx_rr:
 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0xB6
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done



.i_addsd:
 mov bl, 0x58
 jmp .sse_arith
.i_subsd:
 mov bl, 0x5C
 jmp .sse_arith
.i_mulsd:
 mov bl, 0x59
 jmp .sse_arith
.i_divsd:
 mov bl, 0x5E
 jmp .sse_arith
.sse_arith:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0xF2
 call emit_b
 mov al, 0x0F
 call emit_b
 mov al, bl
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_shl:
 mov r8b, 4
 jmp .shift
.i_sar:
 mov r8b, 7
 jmp .shift
.i_shr:
 mov r8b, 5
.shift:

 push r8
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r14d, eax
 mov r15d, edx
 pop r8
 xor r9d, r9d
 cmp r12d, 7
 je .shift_r8
 cmp r12d, 8
 jne .shift_chk64
 mov r9d, 1
 jmp .shift_src
.shift_chk64:
 cmp r12d, 1
 jne .unsupported
.shift_src:
 cmp r14d, 7
 je .shift_cl
 cmp r14d, 2
 je .shift_imm
 jmp .unsupported
.shift_r8:

 cmp r14d, 2
 jne .unsupported
 mov eax, r13d
 cmp eax, 8
 jae .sh8_rexb
 cmp eax, 4
 jb .sh8_op
 mov al, 0x40
 call emit_b
 jmp .sh8_op
.sh8_rexb:
 mov al, 0x41
 call emit_b
.sh8_op:
 mov al, 0xC0
 call emit_b
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_b
 jmp .done
.shift_cl:
 cmp r15d, 1
 jne .unsupported
 mov dil, 1
 test r9d, r9d
 jz .sh_wcl
 xor edi, edi
.sh_wcl:
 xor esi, esi
 mov edx, r13d
 push r8
 call emit_rex
 mov al, 0xD3
 call emit_b
 pop r8
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 jmp .done
.shift_imm:
 mov dil, 1
 test r9d, r9d
 jz .sh_wim
 xor edi, edi
.sh_wim:
 xor esi, esi
 mov edx, r13d
 push r8
 call emit_rex
 mov al, 0xC1
 call emit_b
 pop r8
 mov dil, 3
 movzx esi, r8b
 mov edx, r13d
 call emit_modrm
 mov eax, r15d
 call emit_b
 jmp .done

.i_ucomisd:

 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0x66
 call emit_b
 mov al, 0x0F
 call emit_b
 mov al, 0x2E
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done

.i_comisd:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0x66
 call emit_b
 mov al, 0x0F
 call emit_b
 mov al, 0x2F
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_xorps:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0x0F
 call emit_b
 mov al, 0x57
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_cvtsi:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0xF2
 call emit_b
 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0x2A
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_cvtsd:
 mov bl, 0x2D
 jmp .sse_to_int

.i_cvttsd:
 mov bl, 0x2C
.sse_to_int:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0xF2
 call emit_b
 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 push rbx
 call emit_rex
 pop rbx
 mov al, 0x0F
 call emit_b
 mov al, bl
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_movq:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r15d, edx
 mov al, 0x66
 call emit_b
 mov dil, 1
 mov esi, r13d
 mov edx, r15d
 call emit_rex
 mov al, 0x0F
 call emit_b
 mov al, 0x6E
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_movsd:
 lea rcx, [rel tok_b]
 call parse_operand
 mov r12d, eax
 mov r13d, edx
 lea rcx, [rel tok_c]
 call parse_operand
 mov r14d, eax
 mov r15d, edx

 cmp r12d, 6
 je .movsd_load

 mov al, 0xF2
 call emit_b
 mov al, 0x0F
 call emit_b
 mov al, 0x11
 call emit_b
 cmp r12d, 3
 je .movsd_st_rbp
 cmp r12d, 9
 je .movsd_st_reg
 cmp r12d, 5
 je .movsd_st_rip
 cmp r12d, 12
 je .movsd_st_sib
 jmp .unsupported
.movsd_st_sib:
 mov eax, r13d
 and eax, 0x0808
 jnz .unsupported
 mov esi, r15d
 mov edx, r13d
 call emit_sib_modrm
 jmp .done
.movsd_st_rip:
 mov esi, r15d
 mov eax, r13d
 call emit_rip
 jmp .done
.movsd_st_rbp:
 mov esi, r15d
 mov eax, r13d
 call emit_mem_rbp
 jmp .done
.movsd_st_reg:
 mov esi, r15d
 mov edx, r13d
 call emit_mem_reg
 jmp .done

.movsd_load:
 mov al, 0xF2
 call emit_b
 cmp r14d, 6
 je .movsd_xx
 mov al, 0x0F
 call emit_b
 mov al, 0x10
 call emit_b
 cmp r14d, 3
 je .movsd_ld_rbp
 cmp r14d, 9
 je .movsd_ld_reg
 cmp r14d, 5
 je .movsd_ld_rip
 cmp r14d, 12
 je .movsd_ld_sib
 jmp .unsupported
.movsd_ld_sib:
 mov eax, r15d
 and eax, 0x0808
 jnz .unsupported
 mov esi, r13d
 mov edx, r15d
 call emit_sib_modrm
 jmp .done
.movsd_ld_rip:
 mov esi, r13d
 mov eax, r15d
 call emit_rip
 jmp .done
.movsd_ld_rbp:
 mov esi, r13d
 mov eax, r15d
 call emit_mem_rbp
 jmp .done
.movsd_ld_reg:
 mov esi, r13d
 mov edx, r15d
 call emit_mem_reg
 jmp .done
.movsd_xx:

 mov al, 0x0F
 call emit_b
 mov al, 0x10
 call emit_b
 mov dil, 3
 mov esi, r13d
 mov edx, r15d
 call emit_modrm
 jmp .done


.i_in:
 mov al, 0xEC
 call emit_b
 jmp .done
.i_out:
 mov al, 0xEE
 call emit_b
 jmp .done

.unsupported:



 cmp byte [rel jasm_pass], 2
 jne .done
 mov byte [rel jasm_error], 1
 mov rax, [rel jasm_line]
 cmp qword [rel jasm_err_line], 0
 jne .rec_more2
 mov [rel jasm_err_line], rax
.rec_more2:
 mov rcx, [rel err_count]
 cmp rcx, 64
 jae .done
 lea rdx, [rel err_lines]
 mov [rdx + rcx*4], eax
 lea rdx, [rel err_dst]
 mov [rdx + rcx*4], r12d
 lea rdx, [rel err_src]
 mov [rdx + rcx*4], r14d
 push rcx
 call record_err_mnem
 pop rcx
 inc rcx
 mov [rel err_count], rcx
 jmp .done

.done:
 pop r15
 pop r14
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret





[section .data]
 d_section: db "section",0
 d_bits: db "bits",0
 d_global: db "global",0
 d_extern: db "extern",0
 d_default: db "default",0
 d_db: db "db",0
 d_dq: db "dq",0
 d_times: db "times",0
 d_equ: db "equ",0
 dd_table: dq d_db, d_dq, d_dw, d_dd, d_resb, d_resw, d_resd, d_resq, d_times, d_equ, 0
 d_resb: db "resb",0
 d_resq: db "resq",0
 d_resw: db "resw",0
 d_resd: db "resd",0
 d_dw: db "dw",0
 d_dd: db "dd",0
 s_dot_text: db ".text",0
 s_dot_data: db ".data",0
 s_dot_bss: db ".bss",0

[section .text]
handle_directive:
 push rbx
 push rsi
 push rdi
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_section]
 call str_eq
 test al, al
 jnz .sec
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_bits]
 call str_eq
 test al, al
 jnz .ignore
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_global]
 call str_eq
 test al, al
 jnz .ignore
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_extern]
 call str_eq
 test al, al
 jnz .decl_extern
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_default]
 call str_eq
 test al, al
 jnz .ignore
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_db]
 call str_eq
 test al, al
 jnz .data_db
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_dq]
 call str_eq
 test al, al
 jnz .data_dq
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_resb]
 call str_eq
 test al, al
 jnz .res_b
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_resq]
 call str_eq
 test al, al
 jnz .res_q
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_resw]
 call str_eq
 test al, al
 jnz .res_w
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_resd]
 call str_eq
 test al, al
 jnz .res_d
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_dw]
 call str_eq
 test al, al
 jnz .data_dw
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_dd]
 call str_eq
 test al, al
 jnz .data_dd
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_equ]
 call str_eq
 test al, al
 jnz .decl_equ
%line 2910+1 jasm.asm
 lea rcx, [rel tok_a]
 lea rdx, [rel d_times]
 call str_eq
 test al, al
 jnz .data_times
%line 6017+1 jasm.asm
 xor al, al
 pop rdi
 pop rsi
 pop rbx
 ret

.sec:
 lea rcx, [rel tok_b]
 lea rdx, [rel s_dot_data]
 call str_eq
 test al, al
 jnz .to_data
 lea rcx, [rel tok_b]
 lea rdx, [rel s_dot_bss]
 call str_eq
 test al, al
 jnz .to_bss
 mov byte [rel cur_section], 0
 jmp .yes
.to_data:
 mov byte [rel cur_section], 1
 jmp .yes
.to_bss:
 mov byte [rel cur_section], 2
 jmp .yes

.data_times:

 push r12
 push r13
 lea rcx, [rel tok_b]
 call parse_number
 mov r12, rax

 lea rsi, [rel tok_b]
.dt_skipnum:
 mov al, [rsi]
 cmp al, '0'
 jb .dt_afternum
 cmp al, '9'
 ja .dt_afternum
 inc rsi
 jmp .dt_skipnum
.dt_afternum:
 call skip_blanks_rsi
 mov r13b, 1
 cmp byte [rsi], 'd'
 jne .dt_emit_setup
 cmp byte [rsi+1], 'q'
 jne .dt_skipdir
 mov r13b, 8
.dt_skipdir:
 add rsi, 2
 call skip_blanks_rsi
.dt_emit_setup:
 mov rcx, rsi
 call parse_number
 mov rsi, rax
.dt_loop:
 test r12, r12
 jz .dt_done
 mov rax, rsi
 cmp r13b, 8
 je .dt_q
 call emit_b
 jmp .dt_next
.dt_q:
 call emit_q
.dt_next:
 dec r12
 jmp .dt_loop
.dt_done:
 pop r13
 pop r12
 jmp .yes
.decl_equ:


 lea rcx, [rel tok_b]
 call parse_expr
 mov r8, rax
 lea rcx, [rel last_label]
 call str_len_local
 mov rdx, rax
 lea rcx, [rel last_label]
 call add_equ
 jmp .yes
.decl_extern:
 cmp byte [rel jasm_pass], 1
 jne .yes
 lea rcx, [rel tok_b]
 push rcx
 call str_len_local
 mov rdx, rax
 pop rcx
 call jasm_add_extern
 jmp .yes

.res_b:
 lea rcx, [rel tok_b]
 call parse_expr
 call bss_round8
 add [rel jasm_bss_len], rax
 add [rel bss_cursor], rax
 jmp .yes
.res_w:
 lea rcx, [rel tok_b]
 call parse_expr
 shl rax, 1
 call bss_round8
 add [rel jasm_bss_len], rax
 add [rel bss_cursor], rax
 jmp .yes
.res_d:
 lea rcx, [rel tok_b]
 call parse_expr
 shl rax, 2
 call bss_round8
 add [rel jasm_bss_len], rax
 add [rel bss_cursor], rax
 jmp .yes
.res_q:
 lea rcx, [rel tok_b]
 call parse_expr
 shl rax, 3
 call bss_round8
 add [rel jasm_bss_len], rax
 add [rel bss_cursor], rax
 jmp .yes

.data_db:




 mov byte [rel db_phase], 0
 lea rcx, [rel tok_b]



 mov byte [rel db_quote], '"'
 cmp byte [rcx], '"'
 je .db_str
 cmp byte [rcx], 0x27
 jne .db_tail
 mov byte [rel db_quote], 0x27
.db_str:
 inc rcx
.db_loop:
 mov al, [rcx]
 test al, al
 jz .yes
 cmp al, [rel db_quote]
 je .db_after
 push rcx
 call emit_b
 pop rcx
 inc rcx
 jmp .db_loop
.db_after:

 inc rcx
.db_tail:
 mov al, [rcx]
 test al, al
 jz .db_next_buf
 cmp al, ','
 je .db_tail_adv
 cmp al, ' '
 je .db_tail_adv




 cmp al, '"'
 je .db_tail_dq
 cmp al, 0x27
 je .db_tail_sq
 cmp al, '0'
 jb .db_next_buf
 cmp al, '9'
 ja .db_next_buf
 push rcx
 call parse_number
 call emit_b
 pop rcx
.db_skip_num:
 mov al, [rcx]
 cmp al, '0'
 jb .db_tail
 cmp al, '9'
 ja .db_tail
 inc rcx
 jmp .db_skip_num
.db_tail_dq:
 mov byte [rel db_quote], '"'
 jmp .db_tail_str
.db_tail_sq:
 mov byte [rel db_quote], 0x27
.db_tail_str:
 inc rcx
.db_ts_loop:
 mov al, [rcx]
 test al, al
 jz .db_next_buf
 cmp al, [rel db_quote]
 je .db_ts_end
 push rcx
 call emit_b
 pop rcx
 inc rcx
 jmp .db_ts_loop
.db_ts_end:
 inc rcx
 jmp .db_tail

.db_next_buf:
 cmp byte [rel db_phase], 0
 jne .yes
 mov byte [rel db_phase], 1
 lea rcx, [rel tok_c]
 jmp .db_tail
.db_tail_adv:
 inc rcx
 jmp .db_tail

.data_dw:
 mov byte [rel dl_size], 2
 jmp .data_list
.data_dd:
 mov byte [rel dl_size], 4
 jmp .data_list
.data_dq:

 lea rsi, [rel tok_b]
.dq_scan:
 mov al, [rsi]
 test al, al
 jz .dq_int
 cmp al, '.'
 je .dq_float
 inc rsi
 jmp .dq_scan
.dq_int:
 mov byte [rel dl_size], 8







.data_list:
 mov byte [rel db_phase], 0
 lea rcx, [rel tok_b]
.dl_scan:
 mov al, [rcx]
 test al, al
 jz .dl_next_buf
 cmp al, ','
 je .dl_adv
 cmp al, ' '
 je .dl_adv
 cmp al, 9
 je .dl_adv
 call dl_is_label
 test al, al
 jnz .dl_label
 call parse_expr
 mov rcx, [rel expr_ptr]
 push rcx
 call dl_emit
 pop rcx
 jmp .dl_scan
.dl_label:
 push rcx
 call dl_tok_len
 mov rdx, rax
 pop rcx
 push rcx
 push rdx
 call jasm_find_label
 mov qword [rel cur_addend], 0
 mov dil, 6
 call add_fixup
 pop rdx
 pop rcx
 add rcx, rdx
 push rcx
 xor eax, eax
 call dl_emit
 pop rcx
 jmp .dl_scan
.dl_adv:
 inc rcx
 jmp .dl_scan
.dl_next_buf:
 cmp byte [rel db_phase], 0
 jne .yes
 mov byte [rel db_phase], 1
 lea rcx, [rel tok_c]
 jmp .dl_scan
.dq_float:
 lea rcx, [rel tok_b]
 call parse_float
 sub rsp, 16
 movsd [rsp], xmm0
 mov rax, [rsp]
 add rsp, 16
 call emit_q
 jmp .yes

.ignore:
.yes:
 mov al, 1
 pop rdi
 pop rsi
 pop rbx
 ret





jasm_assemble:
 push rbx
 push rsi
 push rdi
 push r12
 push r13
 push r14
 mov r13, rcx
 mov r14, rdx

 mov byte [rel jasm_pass], 1
 mov qword [rel bss_cursor], 0
 call run_pass
 mov byte [rel jasm_pass], 2
 mov qword [rel jasm_code_len], 0
 mov qword [rel jasm_data_len], 0
 mov qword [rel bss_cursor], 0
 mov byte [rel cur_section], 0
 mov qword [rel fix_count], 0




 mov qword [rel extref_count], 0

 mov qword [rel jasm_bss_len], 0
 call run_pass

 mov rax, [rel jasm_code_len]
 add rax, 15
 and rax, -16
 mov [rel data_base], rax

 add rax, [rel jasm_data_len]
 mov [rel bss_base], rax
 call apply_fixups
 call jasm_prune_externs

 movzx eax, byte [rel jasm_error]
 test eax, eax
 jnz .err
 mov rax, 1
 jmp .out
.err:
 xor rax, rax
.out:
 pop r14
 pop r13
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret


run_pass:
 mov qword [rel jasm_line], 0
 push rbx
 push rsi
 push rdi
 push r12
 mov rsi, r13
 mov r12, r14

.next_line:
 test r12, r12
 jz .done
 inc qword [rel jasm_line]

 lea rdi, [rel line_buf]
 xor ebx, ebx
.copy:
 test r12, r12
 jz .line_ready
 mov al, [rsi]
 inc rsi
 dec r12
 cmp al, 10
 je .line_ready
 cmp al, 13
 je .copy
 cmp ebx, 510
 jae .copy
 mov [rdi + rbx], al
 inc ebx
 jmp .copy
.line_ready:
 mov byte [rdi + rbx], 0



 lea rcx, [rel line_buf]
.lr_skip_ws:
 mov al, [rcx]
 cmp al, ' '
 je .lr_ws_adv
 cmp al, 9
 jne .lr_check
.lr_ws_adv:
 inc rcx
 jmp .lr_skip_ws
.lr_check:
 cmp al, '%'
 je .next_line


 cmp al, '['
 jne .lr_go
 mov byte [rcx], ' '
 mov rdx, rcx
.lr_find_close:
 mov al, [rdx]
 test al, al
 jz .lr_go
 cmp al, ']'
 jne .lr_close_adv
 mov byte [rdx], 0
 jmp .lr_go
.lr_close_adv:
 inc rdx
 jmp .lr_find_close
.lr_go:

 lea rcx, [rel line_buf]
 call split_line
 test al, al
 jnz .label_def

.after_label:
 cmp byte [rel tok_a], 0
 je .next_line
 call handle_directive
 test al, al
 jnz .next_line
 call encode_line
 jmp .next_line

.label_def:
 push rax



 lea rcx, [rel tok_a]
 lea rdx, [rel last_label]
 call copy_tok


 cmp byte [rel tok_a], '.'
 je .lbl_keep_scope
 lea rcx, [rel tok_a]
 lea rdx, [rel cur_global]
 call copy_tok
.lbl_keep_scope:
 lea rcx, [rel tok_a]
 push rcx
 call str_len_local
 mov rdx, rax
 pop rcx
 call qualify_label
 call jasm_add_label
.lbl_after:
 pop rax
 cmp al, 2
 jne .next_line





 lea rcx, [rel lbl_rest]
 call is_data_dir
 test al, al
 jnz .lbl_shift
 lea rcx, [rel lbl_rest]
 call split_line
 jmp .after_label
.lbl_shift:
 lea rcx, [rel tok_b]
 lea rdx, [rel tok_a]
 call copy_tok
 lea rcx, [rel tok_c]
 lea rdx, [rel tok_b]
 call copy_tok
 mov byte [rel tok_c], 0
 jmp .after_label

.done:
 pop r12
 pop rdi
 pop rsi
 pop rbx
 ret









dl_tok_len:
 push rdx
 xor rax, rax
.dtl:
 mov dl, [rcx + rax]
 test dl, dl
 jz .dtl_out
 cmp dl, ','
 je .dtl_out
 cmp dl, ' '
 je .dtl_out
 cmp dl, 9
 je .dtl_out
 inc rax
 jmp .dtl
.dtl_out:
 pop rdx
 ret


dl_emit:
 cmp byte [rel dl_size], 2
 je .de_w
 cmp byte [rel dl_size], 4
 je .de_d
 call emit_q
 ret
.de_w:
 call emit_w
 ret
.de_d:
 call emit_d
 ret




dl_is_label:
 push rbx
 push rcx
 push rdx
 mov al, [rcx]
 cmp al, '0'
 jb .dil_alpha
 cmp al, '9'
 jbe .dil_no
.dil_alpha:
 call dl_tok_len
 mov rdx, rax




 push rcx
 push rdx
 call find_equ
 pop rdx
 pop rcx
 cmp eax, -1
 jne .dil_no
 call jasm_find_label
 cmp eax, -1
 je .dil_no
 mov al, 1
 jmp .dil_out
.dil_no:
 xor al, al
.dil_out:
 pop rdx
 pop rcx
 pop rbx
 ret

apply_fixups:
 push rbx
 push rsi
 push rdi
 xor rbx, rbx
.l:
 cmp rbx, [rel fix_count]
 jae .done
 lea rdi, [rel fix_at]
 mov esi, [rdi + rbx*4]
 lea rdi, [rel fix_label]
 mov eax, [rdi + rbx*4]
 cmp eax, -1
 je .next
 push rsi
 push rax
 lea rdi, [rel fix_kind]
 movzx edi, byte [rdi + rbx]
 mov [rel cur_fix_kind], edi
 cmp edi, 6
 je .skip_abs
 pop rax
 push rax
 call jasm_label_addr
 mov r8, rax
 pop rax

 push rax
 lea rdi, [rel lbl_section]
 movzx edi, byte [rdi + rax]
 cmp edi, 1
 je .add_data_base
 cmp edi, 2
 je .add_bss_base
 jmp .no_data_base
.add_data_base:
 mov rax, [rel data_base]
 add r8, rax
 jmp .no_data_base
.add_bss_base:
 mov rax, [rel bss_base]
 add r8, rax
.no_data_base:

 push rax
 lea rax, [rel fix_addend]
 mov eax, [rax + rbx*4]
 add r8, rax
 pop rax
 pop rax
 mov rax, r8
 pop rsi

 mov ecx, esi
 add ecx, 4
 sub eax, ecx

 lea rdi, [rel jasm_code]
 mov [rdi + rsi], eax
 jmp .next
.skip_abs:
 pop rax
 pop rsi
.next:
 inc rbx
 jmp .l
.done:
 pop rdi
 pop rsi
 pop rbx
 ret
