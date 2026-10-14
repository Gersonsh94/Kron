%line 17+1 pe_writer.asm
[bits 64]
[default rel]

[extern jasm_get_code]
[extern jasm_get_code_size]
[extern jasm_get_data]
[extern jasm_get_data_size]
[extern jasm_get_bss_size]
[extern jasm_get_ext_count]
[extern jasm_get_ext_name]
[extern jasm_get_extref_count]
[extern jasm_get_extref_at]
[extern jasm_get_extref_sym]
[extern jasm_find_label]
[extern jasm_label_addr]
[extern jasm_get_fixup_count]
[extern jasm_get_fixup_at]
[extern jasm_get_fixup_label]
[extern jasm_get_fixup_addend]
[extern jasm_get_fixup_kind]
[extern jasm_get_label_section]

%line 46+1 pe_writer.asm

[section .bss]
 pw_buf resq 1
 pw_code_ptr resq 1
 pw_code_len resq 1
 pw_data_ptr resq 1
 pw_data_len resq 1
 pw_bss_len resq 1
 pw_ext_count resq 1
 pw_xref_count resq 1
 pw_thunks_off resq 1
 pw_text_vsize resq 1
 pw_text_raw resq 1
 pw_text_foff resq 1
 pw_bss_off_sec resq 1
 pw_data_vsize resq 1
 pw_data_raw resq 1
 pw_data_foff resq 1
 pw_idata_foff resq 1
 pw_idata_size resq 1
 pw_data_rva resq 1
 pw_idata_rva resq 1
 pw_idt_rva resq 1
 pw_ilt_rva resq 1
 pw_iat_rva resq 1
 pw_names_intra resq 1
 pw_hint_rva resq 128
 pw_entry_rva resq 1
 pw_total resq 1

[section .data]
 pw_dll_name db "kernel32.dll", 0
 pw_main_name db "main", 0

[section .text]
[global pw_write]

pw_put8:
 mov rax, [rel pw_buf]
 mov [rax + rcx], dl
 ret
pw_put16:
 mov rax, [rel pw_buf]
 mov [rax + rcx], dx
 ret
pw_put32:
 mov rax, [rel pw_buf]
 mov [rax + rcx], edx
 ret
pw_put64:
 mov rax, [rel pw_buf]
 mov [rax + rcx], rdx
 ret
pw_align:
 dec rcx
 add rax, rcx
 not rcx
 and rax, rcx
 ret

pw_write:
 push rbp
 mov rbp, rsp
 push rbx
 push r12
 push r13
 push r14
 push r15
 push rdi
 push rsi
 sub rsp, 40

 mov [rel pw_buf], rcx

 sub rsp,32
 call jasm_get_code
 add rsp,32
 mov [rel pw_code_ptr], rax
 sub rsp,32
 call jasm_get_code_size
 add rsp,32
 mov [rel pw_code_len], rax
 sub rsp,32
 call jasm_get_data
 add rsp,32
 mov [rel pw_data_ptr], rax
 sub rsp,32
 call jasm_get_data_size
 add rsp,32
 mov [rel pw_data_len], rax
 sub rsp,32
 call jasm_get_bss_size
 add rsp,32
 mov [rel pw_bss_len], rax
 sub rsp,32
 call jasm_get_ext_count
 add rsp,32
 mov [rel pw_ext_count], rax
 sub rsp,32
 call jasm_get_extref_count
 add rsp,32
 mov [rel pw_xref_count], rax


 lea rcx, [rel pw_main_name]
 mov rdx, 4
 sub rsp,32
 call jasm_find_label
 add rsp,32
 cmp eax, -1
 je .no_main
 sub rsp,32
 call jasm_label_addr
 add rsp,32
 add rax, 0x1000
 mov [rel pw_entry_rva], rax
 jmp .entry_set
.no_main:
 mov qword [rel pw_entry_rva], 0x1000
.entry_set:


 mov rax, [rel pw_code_len]
 mov rcx, 16
 call pw_align
 mov [rel pw_thunks_off], rax
 mov rbx, [rel pw_ext_count]
 imul rbx, 6
 add rax, rbx
 mov [rel pw_text_vsize], rax
 mov rcx, 0x200
 call pw_align
 mov [rel pw_text_raw], rax
 mov qword [rel pw_text_foff], 0x400


 mov rax, [rel pw_data_len]
 mov rcx, 16
 call pw_align
 mov [rel pw_bss_off_sec], rax
 add rax, [rel pw_bss_len]
 mov [rel pw_data_vsize], rax
 mov rax, [rel pw_data_len]
 mov rcx, 0x200
 call pw_align
 mov [rel pw_data_raw], rax
 mov rax, [rel pw_text_foff]
 add rax, [rel pw_text_raw]
 mov [rel pw_data_foff], rax


 mov rax, [rel pw_data_foff]
 add rax, [rel pw_data_raw]
 mov [rel pw_idata_foff], rax




 mov rax, 0x1000
 add rax, [rel pw_text_vsize]
 mov rcx, 0x1000
 call pw_align
 mov [rel pw_data_rva], rax
 add rax, [rel pw_data_vsize]
 mov rcx, 0x1000
 call pw_align
 mov [rel pw_idata_rva], rax


 mov r12, [rel pw_ext_count]
 mov rax, [rel pw_idata_rva]
 mov [rel pw_idt_rva], rax
 mov rax, [rel pw_idata_rva]
 add rax, 40
 mov [rel pw_ilt_rva], rax
 mov rbx, r12
 inc rbx
 imul rbx, 8
 add rax, rbx
 mov [rel pw_iat_rva], rax
 add rax, rbx
 mov rcx, rax
 sub rcx, [rel pw_idata_rva]
 mov [rel pw_names_intra], rcx


 mov rdi, [rel pw_buf]
 xor eax, eax
 mov rcx, 0x400
 rep stosb


 xor rcx, rcx
 mov dx, 0x5A4D
 call pw_put16
 mov rcx, 0x3C
 mov edx, 0xB8
 call pw_put32

 mov rcx, 0xB8
 mov edx, 0x00004550
 call pw_put32

 mov rcx, 0xBC
 mov dx, 0x8664
 call pw_put16
 mov rcx, 0xBC+2
 mov dx, 3
 call pw_put16
 mov rcx, 0xBC+16
 mov dx, 240
 call pw_put16
 mov rcx, 0xBC+18
 mov dx, 0x0023
 call pw_put16


 mov rcx, 0xD0
 mov dx, 0x020B
 call pw_put16
 mov rcx, 0xD0+2
 mov dl, 14
 call pw_put8
 mov rcx, 0xD0+4
 mov edx, dword [rel pw_text_raw]
 call pw_put32
 mov rcx, 0xD0+16
 mov edx, dword [rel pw_entry_rva]
 call pw_put32
 mov rcx, 0xD0+20
 mov edx, 0x1000
 call pw_put32
 mov rcx, 0xD0+24
 mov rdx, 0x0000000140000000
 call pw_put64
 mov rcx, 0xD0+32
 mov edx, 0x1000
 call pw_put32
 mov rcx, 0xD0+36
 mov edx, 0x200
 call pw_put32
 mov rcx, 0xD0+40
 mov dx, 6
 call pw_put16
 mov rcx, 0xD0+48
 mov dx, 6
 call pw_put16
 mov rcx, 0xD0+60
 mov edx, 0x400
 call pw_put32
 mov rcx, 0xD0+68
 mov dx, 3
 call pw_put16
 mov rcx, 0xD0+70
 mov dx, 0
 call pw_put16
 mov rcx, 0xD0+72
 mov rdx, 0x100000
 call pw_put64
 mov rcx, 0xD0+80
 mov rdx, 0x10000
 call pw_put64
 mov rcx, 0xD0+88
 mov rdx, 0x100000
 call pw_put64
 mov rcx, 0xD0+96
 mov rdx, 0x1000
 call pw_put64
 mov rcx, 0xD0+108
 mov edx, 16
 call pw_put32


 mov rcx, 0xD0+112+8
 mov edx, dword [rel pw_idt_rva]
 call pw_put32
 mov rcx, 0xD0+112+8+4
 mov edx, 40
 call pw_put32

 mov rcx, 0xD0+112+96
 mov edx, dword [rel pw_iat_rva]
 call pw_put32
 mov rcx, 0xD0+112+96+4
 mov rax, [rel pw_ext_count]
 inc rax
 imul rax, 8
 mov edx, eax
 call pw_put32



 mov rcx, 0x1C0
 mov rdx, ".text"
 call pw_put64
 mov rcx, 0x1C0+8
 mov edx, dword [rel pw_text_vsize]
 call pw_put32
 mov rcx, 0x1C0+12
 mov edx, 0x1000
 call pw_put32
 mov rcx, 0x1C0+16
 mov edx, dword [rel pw_text_raw]
 call pw_put32
 mov rcx, 0x1C0+20
 mov edx, dword [rel pw_text_foff]
 call pw_put32
 mov rcx, 0x1C0+36
 mov edx, 0x60000020
 call pw_put32

 mov rcx, 0x1C0+40
 mov rdx, ".data"
 call pw_put64
 mov rcx, 0x1C0+40+8
 mov edx, dword [rel pw_data_vsize]
 call pw_put32
 mov rcx, 0x1C0+40+12
 mov edx, dword [rel pw_data_rva]
 call pw_put32
 mov rcx, 0x1C0+40+16
 mov edx, dword [rel pw_data_raw]
 call pw_put32


 mov rcx, 0x1C0+40+20
 mov rax, [rel pw_data_raw]
 test rax, rax
 jnz .data_has_raw
 xor edx, edx
 call pw_put32
 jmp .data_hdr_flags
.data_has_raw:
 mov edx, dword [rel pw_data_foff]
 call pw_put32
.data_hdr_flags:
 mov rcx, 0x1C0+40+36
 mov edx, 0xC0000040
 call pw_put32

 mov rcx, 0x1C0+80
 mov rdx, ".idata"
 call pw_put64
 mov rcx, 0x1C0+80+12
 mov edx, dword [rel pw_idata_rva]
 call pw_put32
 mov rcx, 0x1C0+80+20
 mov edx, dword [rel pw_idata_foff]
 call pw_put32
 mov rcx, 0x1C0+80+36
 mov edx, 0x40000040
 call pw_put32


 mov rdi, [rel pw_buf]
 add rdi, [rel pw_text_foff]
 mov rsi, [rel pw_code_ptr]
 mov rcx, [rel pw_code_len]
 rep movsb


 mov rcx, [rel pw_data_len]
 test rcx, rcx
 jz .no_data
 mov rdi, [rel pw_buf]
 add rdi, [rel pw_data_foff]
 mov rsi, [rel pw_data_ptr]
 rep movsb
.no_data:


 xor r13, r13
.thunk_loop:
 cmp r13, [rel pw_ext_count]
 jae .thunks_done
 mov rax, r13
 imul rax, 6
 add rax, [rel pw_thunks_off]
 add rax, [rel pw_text_foff]
 mov r14, rax
 mov rcx, r14
 mov dl, 0xFF
 call pw_put8
 lea rcx, [r14+1]
 mov dl, 0x25
 call pw_put8

 mov rax, [rel pw_iat_rva]
 mov rbx, r13
 imul rbx, 8
 add rax, rbx
 mov rbx, 0x1000
 add rbx, [rel pw_thunks_off]
 mov r8, r13
 imul r8, 6
 add rbx, r8
 add rbx, 6
 sub rax, rbx
 lea rcx, [r14+2]
 mov edx, eax
 call pw_put32
 inc r13
 jmp .thunk_loop
.thunks_done:


 xor r13, r13
.patch_loop:
 cmp r13, [rel pw_xref_count]
 jae .patch_done
 mov rcx, r13
 sub rsp,32
 call jasm_get_extref_at
 add rsp,32
 mov r14, rax
 mov rcx, r13
 sub rsp,32
 call jasm_get_extref_sym
 add rsp,32
 mov r15, rax
 mov rax, 0x1000
 add rax, [rel pw_thunks_off]
 mov rbx, r15
 imul rbx, 6
 add rax, rbx
 mov rbx, 0x1000
 add rbx, r14
 add rbx, 4
 sub rax, rbx
 mov rcx, [rel pw_text_foff]
 add rcx, r14
 mov edx, eax
 call pw_put32
 inc r13
 jmp .patch_loop
.patch_done:



 sub rsp,32
 call jasm_get_fixup_count
 add rsp,32
 mov r12, rax
 xor r13, r13
.fix_loop:
 cmp r13, r12
 jae .fix_done

 mov rcx, r13
 sub rsp,32
 call jasm_get_fixup_kind
 add rsp,32
 cmp eax, 6
 je .fix_abs64
 cmp eax, 3
 jne .fix_next

 mov rcx, r13
 sub rsp,32
 call jasm_get_fixup_label
 add rsp,32
 mov r15, rax
 cmp r15d, -1
 je .fix_next

 mov rcx, r15
 sub rsp,32
 call jasm_get_label_section
 add rsp,32
 mov r10, rax
 cmp r10, 1
 jb .fix_next

 mov rax, r15
 sub rsp,32
 call jasm_label_addr
 add rsp,32
 mov r11, rax


 mov r8, [rel pw_data_rva]
 cmp r10, 2
 jne .fix_isdata
 add r8, [rel pw_bss_off_sec]
.fix_isdata:
 add r8, r11

 mov rcx, r13
 sub rsp,32
 call jasm_get_fixup_addend
 add rsp,32
 add r8, rax

 mov rcx, r13
 sub rsp,32
 call jasm_get_fixup_at
 add rsp,32
 mov r14, rax

 mov rbx, 0x1000
 add rbx, r14
 add rbx, 4
 mov rax, r8
 sub rax, rbx

 mov rcx, [rel pw_text_foff]
 add rcx, r14
 mov edx, eax
 call pw_put32
 jmp .fix_next
.fix_abs64:



 mov rcx, r13
 sub rsp,32
 call jasm_get_fixup_label
 add rsp,32
 mov r15, rax
 cmp r15d, -1
 je .fix_next
 mov rcx, r15
 sub rsp,32
 call jasm_get_label_section
 add rsp,32
 mov r10, rax
 mov rax, r15
 sub rsp,32
 call jasm_label_addr
 add rsp,32
 mov r11, rax
 cmp r10, 0
 jne .fa_data
 mov r8, 0x1000
 jmp .fa_have
.fa_data:
 mov r8, [rel pw_data_rva]
 cmp r10, 2
 jne .fa_have
 add r8, [rel pw_bss_off_sec]
.fa_have:
 add r8, r11
 mov rax, 0x0000000140000000
 add r8, rax
 mov rcx, r13
 sub rsp,32
 call jasm_get_fixup_at
 add rsp,32
 mov rcx, [rel pw_data_foff]
 add rcx, rax
 mov rdx, r8
 call pw_put64
 jmp .fix_next

.fix_next:
 inc r13
 jmp .fix_loop
.fix_done:


 mov r12, [rel pw_idata_foff]
 mov r13, [rel pw_idata_rva]
 mov rdi, [rel pw_buf]
 add rdi, r12
 xor eax, eax
 mov rcx, 2048
 rep stosb

 mov rcx, r12
 mov edx, dword [rel pw_ilt_rva]
 call pw_put32
 lea rcx, [r12+16]
 mov edx, dword [rel pw_iat_rva]
 call pw_put32

 mov r14, [rel pw_names_intra]
 xor r15, r15
.name_loop:
 cmp r15, [rel pw_ext_count]
 jae .names_done
 mov rax, r13
 add rax, r14
 lea rbx, [rel pw_hint_rva]
 mov [rbx + r15*8], rax
 mov rcx, r15
 sub rsp,32
 call jasm_get_ext_name
 add rsp,32
 mov rsi, rax
 mov rdi, [rel pw_buf]
 add rdi, r12
 add rdi, r14
 add rdi, 2
 xor r8, r8
.copy_name:
 mov al, [rsi + r8]
 mov [rdi + r8], al
 test al, al
 jz .name_done1
 inc r8
 jmp .copy_name
.name_done1:
 add r14, 2
 add r14, r8
 inc r14
 test r14, 1
 jz .name_even
 inc r14
.name_even:
 inc r15
 jmp .name_loop
.names_done:

 mov rax, r13
 add rax, r14
 mov r8, rax
 mov rdi, [rel pw_buf]
 add rdi, r12
 add rdi, r14
 lea rsi, [rel pw_dll_name]
 xor r9, r9
.copy_dll:
 mov al, [rsi + r9]
 mov [rdi + r9], al
 test al, al
 jz .dll_done
 inc r9
 jmp .copy_dll
.dll_done:
 add r14, r9
 inc r14
 mov [rel pw_idata_size], r14
 lea rcx, [r12+12]
 mov edx, r8d
 call pw_put32

 xor r15, r15
.tab_loop:
 cmp r15, [rel pw_ext_count]
 jae .tab_done
 lea rbx, [rel pw_hint_rva]
 mov r9, [rbx + r15*8]
 mov r10, r15
 imul r10, 8
 mov rcx, [rel pw_ilt_rva]
 sub rcx, r13
 add rcx, r12
 add rcx, r10
 mov rdx, r9
 call pw_put64
 mov rcx, [rel pw_iat_rva]
 sub rcx, r13
 add rcx, r12
 add rcx, r10
 mov rdx, r9
 call pw_put64
 inc r15
 jmp .tab_loop
.tab_done:


 mov rcx, 0x1C0+80+8
 mov edx, dword [rel pw_idata_size]
 call pw_put32
 mov rax, [rel pw_idata_size]
 mov rcx, 0x200
 call pw_align
 mov rcx, 0x1C0+80+16
 mov edx, eax
 call pw_put32


 mov rax, [rel pw_idata_rva]
 add rax, [rel pw_idata_size]
 mov rcx, 0x1000
 call pw_align
 add rax, 0x1000
 mov rcx, 0xD0+56
 mov edx, eax
 call pw_put32


 mov rax, [rel pw_idata_size]
 mov rcx, 0x200
 call pw_align
 add rax, [rel pw_idata_foff]
 mov [rel pw_total], rax

 mov rax, [rel pw_total]
 add rsp, 40
 pop rsi
 pop rdi
 pop r15
 pop r14
 pop r13
 pop r12
 pop rbx
 pop rbp
 ret
