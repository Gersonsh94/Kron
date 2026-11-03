; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_elf_writer_A_ANDROID: dq 8
section .text
section .data
__g_elf_writer_A_OUT_BIN_NAME: dq 10
section .text
section .data
__g_elf_writer_A_BIN_EXT_PTR: dq 12
section .text
section .data
__g_elf_writer_A_OUT_DYNAMIC: dq 29
section .text
section .data
__g_elf_writer_ew_hsize: dq 0
section .text
section .data
__g_elf_writer_ew_base: dq 0
section .text
ew_get_hsize:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_elf_writer_ew_hsize]
    jmp .__ret_0
.__ret_0:
    mov rsp, rbp
    pop rbp
    ret
ew_get_base:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_elf_writer_ew_base]
    jmp .__ret_1
.__ret_1:
    mov rsp, rbp
    pop rbp
    ret
ew_put_hb:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov [rel __g_elf_writer_ew_hsize], rax
    mov rax, rbx
    mov [rel __g_elf_writer_ew_base], rax
    mov rax, 0
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ew_flag:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
ew_out_dynamic:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_elf_writer_A_OUT_DYNAMIC]
    push rax
    pop rcx
    sub rsp, 32
    call ew_flag
    add rsp, 32
    jmp .__ret_4
.__ret_4:
    mov rsp, rbp
    pop rbp
    ret
ew_out_android:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_elf_writer_A_ANDROID]
    push rax
    pop rcx
    sub rsp, 32
    call ew_flag
    add rsp, 32
    jmp .__ret_5
.__ret_5:
    mov rsp, rbp
    pop rbp
    ret
ew_prepare_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, [rel __g_elf_writer_A_BIN_EXT_PTR]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    mov r12, rax
section .data
.str7: db 46,115,111,0
section .text
    lea rax, [rel .str7]
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    sub rsp, 32
    call mc_build_bin_name
    add rsp, 32
    mov rax, [rel __g_elf_writer_A_OUT_BIN_NAME]
    push rax
    pop rcx
    sub rsp, 32
    call mn_addr
    add rsp, 32
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
ew_addr_interp_x86:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str9: db 47,108,105,98,54,52,47,108,100,45,108,105,110,117,120,45,120,56,54,45,54,52,46,115,111,46,50,0
section .text
    lea rax, [rel .str9]
    jmp .__ret_8
.__ret_8:
    mov rsp, rbp
    pop rbp
    ret
ew_addr_interp_arm:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str11: db 47,108,105,98,47,108,100,45,108,105,110,117,120,45,97,97,114,99,104,54,52,46,115,111,46,49,0
section .text
    lea rax, [rel .str11]
    jmp .__ret_10
.__ret_10:
    mov rsp, rbp
    pop rbp
    ret
ew_addr_strtab:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str13: db 0,108,105,98,99,46,115,111,46,54,0,108,105,98,100,108,46,115,111,46,50,0,108,105,98,112,116,104,114,101,97,100,46,115,111,46,48,0,100,108,111,112,101,110,0,100,108,115,121,109,0,112,116,104,114,101,97,100,95,99,114,101,97,116
    db 101,0,112,116,104,114,101,97,100,95,100,101,116,97,99,104,0,101,120,105,116,0,0
section .text
    lea rax, [rel .str13]
    jmp .__ret_12
.__ret_12:
    mov rsp, rbp
    pop rbp
    ret
ew_addr_strtab_and:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str15: db 0,108,105,98,99,46,115,111,0,108,105,98,100,108,46,115,111,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,100,108,111,112,101,110,0,100,108,115,121,109,0,112,116,104,114,101,97,100,95,99,114,101,97,116
    db 101,0,112,116,104,114,101,97,100,95,100,101,116,97,99,104,0,101,120,105,116,0,0
section .text
    lea rax, [rel .str15]
    jmp .__ret_14
.__ret_14:
    mov rsp, rbp
    pop rbp
    ret
ew_len_strtab:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, 86
    jmp .__ret_16
.__ret_16:
    mov rsp, rbp
    pop rbp
    ret
ew_addr_got_names:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str18: db 95,95,103,111,116,95,100,108,111,112,101,110,0,95,95,103,111,116,95,100,108,115,121,109,0,95,95,103,111,116,95,112,116,99,0,95,95,103,111,116,95,112,116,100,0,95,95,103,111,116,95,101,120,105,116,0,0
section .text
    lea rax, [rel .str18]
    jmp .__ret_17
.__ret_17:
    mov rsp, rbp
    pop rbp
    ret
ew_addr_shnames:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str20: db 0,46,100,121,110,115,121,109,0,46,100,121,110,115,116,114,0,46,100,121,110,97,109,105,99,0,46,115,104,115,116,114,116,97,98,0,0
section .text
    lea rax, [rel .str20]
    jmp .__ret_19
.__ret_19:
    mov rsp, rbp
    pop rbp
    ret
ew_addr_start:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str22: db 95,115,116,97,114,116,0
section .text
    lea rax, [rel .str22]
    jmp .__ret_21
.__ret_21:
    mov rsp, rbp
    pop rbp
    ret
section .data
__g_elf_writer_el_img: dq 0
section .text
section .data
__g_elf_writer_el_dbase: dq 0
section .text
section .data
__g_elf_writer_el_bbase: dq 0
section .text
section .bss
__g_elf_writer_el_got: resq 5
section .text
section .bss
__g_elf_writer_el_pl: resq 7
section .text
section .data
__g_elf_writer_el_arm: dq 0
section .text
section .data
__g_elf_writer_el_code: dq 0
section .text
section .data
__g_elf_writer_el_doff: dq 0
section .text
section .data
__g_elf_writer_el_dlen: dq 0
section .text
section .data
__g_elf_writer_el_boff: dq 0
section .text
section .data
__g_elf_writer_el_blen: dq 0
section .text
section .data
__g_elf_writer_el_falign: dq 0
section .text
section .data
__g_elf_writer_el_F: dq 0
section .text
section .data
__g_elf_writer_el_V: dq 0
section .text
section .data
__g_elf_writer_el_exp: dq 0
section .text
section .data
__g_elf_writer_el_strsz: dq 0
section .text
section .data
__g_elf_writer_el_sym: dq 0
section .text
section .data
__g_elf_writer_el_hash: dq 0
section .text
section .data
__g_elf_writer_el_rela: dq 0
section .text
section .data
__g_elf_writer_el_nrel: dq 0
section .text
section .data
__g_elf_writer_el_end: dq 0
section .text
section .bss
__g_elf_writer_el_name: resq 40
section .text
section .data
__g_elf_writer_el_android: dq 0
section .text
section .data
__g_elf_writer_el_soname: dq 0
section .text
section .data
__g_elf_writer_el_soname_off: dq 0
section .text
section .data
__g_elf_writer_el_shoff: dq 0
section .text
section .data
__g_elf_writer_el_shend: dq 0
section .text
el_p8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    mov rax, 0
    jmp .__ret_23
.__ret_23:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_p16:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, 0
    jmp .__ret_24
.__ret_24:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_p32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, 0
    jmp .__ret_25
.__ret_25:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_p64:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_26
.__ret_26:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_g8:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_27
.__ret_27:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_g32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov eax, dword [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_28
.__ret_28:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_g64:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_29
.__ret_29:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_copy:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, 0
    mov rbx, rax
.L31:
    cmp rbx, r12
    jge .L32
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r13
    add rax, rbx
    movzx rax, byte [rax]
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L33:
    jmp .L31
.L32:
    mov rax, r14
    jmp .__ret_30
.__ret_30:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
el_zero:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
.L35:
    cmp rbx, r12
    jge .L36
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L37:
    jmp .L35
.L36:
    mov rax, r13
    jmp .__ret_34
.__ret_34:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
el_cstrlen:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L39:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call el_g8
    add rsp, 32
    cmp rax, 0
    je .L40
    add rbx, 1
.L41:
    jmp .L39
.L40:
    mov rax, rbx
    jmp .__ret_38
.__ret_38:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
el_neg1:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    mov rcx, 4294967295
    cmp rax, rcx
    jne .L43
    mov rax, 1
    jmp .__ret_42
    jmp .L44
.L43:
.L44:
    mov rax, 0
    jmp .__ret_42
.__ret_42:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
el_dyn:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rcx, r13
    mov rdx, r12
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 8
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 16
    jmp .__ret_45
.__ret_45:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
el_rel_add:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov r13, r8
    mov r12, r9
    mov rax, rbx
    push rax
    sub rsp, 32
    call el_rela_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rcx, rbx
    mov rdx, r14
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 16
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, [rel __g_elf_writer_el_nrel]
    add rax, 1
    mov [rel __g_elf_writer_el_nrel], rax
    mov rax, 0
    jmp .__ret_46
.__ret_46:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
el_rela_at:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_elf_writer_el_nrel]
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_elf_writer_el_rela]
    add rax, rcx
    jmp .__ret_47
.__ret_47:
    mov rsp, rbp
    pop rbp
    ret
el_elf_hash:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov r14, rdx
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L49:
    cmp r12, r14
    jge .L50
    mov rax, r13
    shl rax, 4
    push rax
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call el_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, r13
    mov rcx, 4294967295
    and rax, rcx
    mov r13, rax
    mov rax, r13
    sar rax, 28
    mov rbx, rax
    cmp rbx, 0
    je .L52
    mov rax, rbx
    shl rax, 4
    mov rcx, rax
    mov rax, r13
    xor rax, rcx
    mov r13, rax
    jmp .L53
.L52:
.L53:
    and r13, 268435455
    add r12, 1
.L51:
    jmp .L49
.L50:
    mov rax, r13
    jmp .__ret_48
.__ret_48:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
el_va:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call el_neg1
    add rsp, 32
    cmp rax, 1
    jne .L55
    mov rax, 0
    jmp .__ret_54
    jmp .L56
.L55:
.L56:
    mov rcx, rbx
    sub rsp, 32
    call ksk_label_section
    add rsp, 32
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call ksk_label_addr
    add rsp, 32
    mov rbx, rax
    cmp r12, 1
    jne .L57
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_dbase]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L58
.L57:
.L58:
    cmp r12, 2
    jne .L59
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_bbase]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L60
.L59:
.L60:
    mov rax, rbx
    push rax
    sub rsp, 32
    call ew_get_base
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    jmp .__ret_54
.__ret_54:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
el_fill_got_va:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call ew_addr_got_names
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L62:
    cmp r12, 5
    jge .L63
    mov rcx, r13
    sub rsp, 32
    call el_cstrlen
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_elf_writer_el_got]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rcx, r13
    mov rdx, rbx
    sub rsp, 32
    call el_va
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, rbx
    add rax, 1
    mov r13, rax
    add r12, 1
.L64:
    jmp .L62
.L63:
    mov rax, 0
    jmp .__ret_61
.__ret_61:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
el_fill_got_arm:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call ew_addr_got_names
    add rsp, 32
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L66:
    cmp r12, 5
    jge .L67
    mov rcx, r13
    sub rsp, 32
    call el_cstrlen
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_elf_writer_el_got]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rcx, r13
    sub rsp, 32
    call kc_label
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, rbx
    add rax, 1
    mov r13, rax
    add r12, 1
.L68:
    jmp .L66
.L67:
    mov rax, 0
    jmp .__ret_65
.__ret_65:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
el_head_exe:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov r14, r8
    mov r13, r9
    mov r12, r10
    mov rbx, rax
    mov rcx, r15
    mov rdx, 0x00010102464C457F
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 8
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 16
    push rax
    pop rcx
    mov rdx, r14
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 24
    push rax
    pop rcx
    mov rdx, [rbp-16]
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 32
    push rax
    pop rcx
    mov rdx, 64
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 40
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 48
    push rax
    pop rcx
    mov rdx, 0x0038004000000000
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 56
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 64
    push rax
    pop rcx
    mov rdx, 0x0000000700000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 72
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 80
    push rax
    pop rcx
    mov rdx, 0x400000
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 88
    push rax
    pop rcx
    mov rdx, 0x400000
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 96
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 104
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 112
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 120
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, 0
    jmp .__ret_69
.__ret_69:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
el_write:
    push rbp
    mov rbp, rsp
    sub rsp, 208
    mov [rbp-176], rbx
    mov [rbp-168], r12
    mov [rbp-160], r13
    mov [rbp-152], r14
    mov [rbp-144], r15
    mov r15, rcx
    sub rsp, 32
    call ew_get_hsize
    add rsp, 32
    mov r14, rax
    sub rsp, 32
    call ew_get_base
    add rsp, 32
    mov [rbp-24], rax
    sub rsp, 32
    call ks_build_image
    add rsp, 32
    mov [rbp-32], rax
    mov rax, [rbp-32]
    mov [rel __g_elf_writer_el_img], rax
    mov rax, r15
    add rax, r14
    push rax
    sub rsp, 32
    call ksk_code
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, [rbp-32]
    sub rsp, 32
    call el_copy
    add rsp, 32
    sub rsp, 32
    call ksk_code_size
    add rsp, 32
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov r13, rax
    mov rax, r13
    push rax
    sub rsp, 32
    call ksk_data_size
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov [rbp-48], rax
    mov rax, r13
    mov [rel __g_elf_writer_el_dbase], rax
    mov rax, [rbp-48]
    mov [rel __g_elf_writer_el_bbase], rax
    sub rsp, 32
    call ksk_fixup_count
    add rsp, 32
    mov [rbp-56], rax
    mov rax, 0
    mov r12, rax
.L71:
    mov rax, r12
    mov rcx, [rbp-56]
    cmp rax, rcx
    jge .L72
    mov rcx, r12
    sub rsp, 32
    call ksk_fixup_kind
    add rsp, 32
    cmp rax, 6
    jne .L74
    mov rcx, r12
    sub rsp, 32
    call ksk_fixup_label
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call el_neg1
    add rsp, 32
    cmp rax, 0
    jne .L76
    mov rcx, rbx
    sub rsp, 32
    call ksk_label_section
    add rsp, 32
    mov [rbp-80], rax
    mov rcx, rbx
    sub rsp, 32
    call ksk_label_addr
    add rsp, 32
    mov rbx, rax
    mov rax, [rbp-80]
    cmp rax, 1
    jne .L78
    add rbx, r13
    jmp .L79
.L78:
.L79:
    mov rax, [rbp-80]
    cmp rax, 2
    jne .L80
    mov rax, rbx
    mov rcx, [rbp-48]
    add rax, rcx
    mov rbx, rax
    jmp .L81
.L80:
.L81:
    mov rax, rbx
    mov rcx, [rbp-24]
    add rax, rcx
    mov rbx, rax
    mov rax, r15
    add rax, r14
    add rax, r13
    push rax
    mov rcx, r12
    sub rsp, 32
    call ksk_fixup_at
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p64
    add rsp, 32
    jmp .L77
.L76:
.L77:
    jmp .L75
.L74:
.L75:
    add r12, 1
.L73:
    jmp .L71
.L72:
    mov rax, 0
    mov rbx, rax
    sub rsp, 32
    call ew_addr_start
    add rsp, 32
    push rax
    pop rcx
    mov rdx, 6
    sub rsp, 32
    call ks_find_label
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call el_neg1
    add rsp, 32
    cmp rax, 0
    jne .L82
    mov rcx, r12
    sub rsp, 32
    call ksk_label_addr
    add rsp, 32
    mov rbx, rax
    jmp .L83
.L82:
.L83:
    mov rax, rbx
    mov rcx, [rbp-24]
    add rax, rcx
    mov rbx, rax
    mov rax, [rbp-32]
    add rax, r14
    mov r12, rax
    sub rsp, 32
    call ksk_bss_size
    add rsp, 32
    mov rcx, [rbp-48]
    add rax, rcx
    add rax, r14
    mov r13, rax
    mov rcx, r15
    mov rdx, rbx
    mov r8, 0x00000001003E0002
    mov r9, r12
    mov r10, r13
    mov rax, 4096
    sub rsp, 32
    call el_head_exe
    add rsp, 32
    sub rsp, 32
    call ew_out_dynamic
    add rsp, 32
    cmp rax, 0
    je .L84
    sub rsp, 32
    call el_fill_got_va
    add rsp, 32
    mov rcx, r15
    mov rdx, 0
    sub rsp, 32
    call el_dynamic
    add rsp, 32
    jmp .L85
.L84:
.L85:
    mov rax, r12
    jmp .__ret_70
.__ret_70:
    mov rbx, [rbp-176]
    mov r12, [rbp-168]
    mov r13, [rbp-160]
    mov r14, [rbp-152]
    mov r15, [rbp-144]
    mov rsp, rbp
    pop rbp
    ret
el_write_arm:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    mov [rbp-96], rbx
    mov [rbp-88], r12
    mov [rbp-80], r13
    mov [rbp-72], r14
    mov [rbp-64], r15
    mov r14, rcx
    sub rsp, 32
    call ew_get_hsize
    add rsp, 32
    mov r15, rax
    sub rsp, 32
    call kc_build_image
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov [rel __g_elf_writer_el_img], rax
    mov rax, r14
    add rax, r15
    push rax
    sub rsp, 32
    call kc_get_code
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    mov r8, rbx
    sub rsp, 32
    call el_copy
    add rsp, 32
    sub rsp, 32
    call kc_get_entry
    add rsp, 32
    mov r13, rax
    mov rax, rbx
    add rax, r15
    mov r12, rax
    sub rsp, 32
    call kc_get_bss_size
    add rsp, 32
    push rax
    mov rax, rbx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, r15
    mov rbx, rax
    mov rcx, r14
    mov rdx, r13
    mov r8, 0x0000000100B70002
    mov r9, r12
    mov r10, rbx
    mov rax, 65536
    sub rsp, 32
    call el_head_exe
    add rsp, 32
    sub rsp, 32
    call ew_out_dynamic
    add rsp, 32
    cmp rax, 0
    je .L87
    sub rsp, 32
    call el_fill_got_arm
    add rsp, 32
    mov rcx, r14
    mov rdx, 1
    sub rsp, 32
    call el_dynamic
    add rsp, 32
    jmp .L88
.L87:
.L88:
    mov rax, r12
    jmp .__ret_86
.__ret_86:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
el_dynamic:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r13, rcx
    mov r14, rdx
    mov rax, 0
    mov r15, rax
.L90:
    cmp r15, 7
    jge .L91
    lea rax, [rel __g_elf_writer_el_pl]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    add rax, 64
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call el_g64
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    add r15, 1
.L92:
    jmp .L90
.L91:
    mov rax, 8
    mov r15, rax
.L93:
    cmp r15, 128
    jge .L94
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    add r15, 1
.L95:
    jmp .L93
.L94:
    mov rax, r13
    add rax, 56
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 64
    push rax
    pop rcx
    mov rdx, 0x0000000400000006
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 72
    push rax
    pop rcx
    mov rdx, 64
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 80
    push rax
    pop rcx
    mov rdx, 0x400040
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 88
    push rax
    pop rcx
    mov rdx, 0x400040
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 96
    push rax
    pop rcx
    mov rdx, 224
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 104
    push rax
    pop rcx
    mov rdx, 224
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 112
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 120
    push rax
    pop rcx
    mov rdx, 0x0000000400000003
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 128
    push rax
    pop rcx
    mov rdx, 288
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 136
    push rax
    pop rcx
    mov rdx, 0x400120
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 144
    push rax
    pop rcx
    mov rdx, 0x400120
    sub rsp, 32
    call el_p64
    add rsp, 32
    sub rsp, 32
    call ew_addr_interp_x86
    add rsp, 32
    mov r15, rax
    cmp r14, 0
    je .L96
    sub rsp, 32
    call ew_addr_interp_arm
    add rsp, 32
    mov r15, rax
    jmp .L97
.L96:
.L97:
    mov rax, 0
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L98:
    cmp rbx, 0
    je .L99
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call el_g8
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, 288
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p8
    add rsp, 32
    add r12, 1
.L100:
    jmp .L98
.L99:
    mov rax, r13
    add rax, 152
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 160
    push rax
    pop rcx
    mov rdx, r12
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 168
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, 0
    mov r15, rax
.L101:
    cmp r15, 7
    jge .L102
    mov rax, r13
    add rax, 176
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    lea rax, [rel __g_elf_writer_el_pl]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call el_g64
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    add r15, 1
.L103:
    jmp .L101
.L102:
    mov rax, r13
    add rax, 232
    push rax
    pop rcx
    mov rdx, 0x0000000600000002
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 240
    push rax
    pop rcx
    mov rdx, 752
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 248
    push rax
    pop rcx
    mov rdx, 0x4002F0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 256
    push rax
    pop rcx
    mov rdx, 0x4002F0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 264
    push rax
    pop rcx
    mov rdx, 192
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 272
    push rax
    pop rcx
    mov rdx, 192
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 280
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 320
    push rax
    sub rsp, 32
    call ew_addr_strtab
    add rsp, 32
    push rax
    sub rsp, 32
    call ew_len_strtab
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_copy
    add rsp, 32
    mov rax, r13
    add rax, 472
    push rax
    pop rcx
    mov rdx, 0x1200000026
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 496
    push rax
    pop rcx
    mov rdx, 0x120000002D
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 520
    push rax
    pop rcx
    mov rdx, 0x1200000033
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 544
    push rax
    pop rcx
    mov rdx, 0x1200000042
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 568
    push rax
    pop rcx
    mov rdx, 0x1200000051
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 592
    push rax
    pop rcx
    mov rdx, 0x0000000600000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, 6
    mov r12, rax
    cmp r14, 0
    je .L104
    mov rax, 1025
    mov r12, rax
    jmp .L105
.L104:
.L105:
    mov rax, 0
    mov r15, rax
.L106:
    cmp r15, 5
    jge .L107
    mov rax, r13
    add rax, 632
    push rax
    mov rax, r15
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
    lea rax, [rel __g_elf_writer_el_got]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call el_g64
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, r15
    add rax, 1
    shl rax, 32
    or rax, r12
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    add r15, 1
.L108:
    jmp .L106
.L107:
    mov rax, r13
    add rax, 752
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 1
    mov r8, 11
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 1
    mov r8, 22
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 4
    mov r8, 0x400250
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 5
    mov r8, 0x400140
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 6
    mov r8, 0x4001C0
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 10
    push rax
    sub rsp, 32
    call ew_len_strtab
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 11
    mov r8, 24
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 7
    mov r8, 0x400278
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 8
    mov r8, 120
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 9
    mov r8, 24
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_89
.__ret_89:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
el_sections:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, [rel __g_elf_writer_el_F]
    push rax
    mov rax, [rel __g_elf_writer_el_end]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    sub rsp, 32
    call ew_addr_shnames
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 36
    sub rsp, 32
    call el_copy
    add rsp, 32
    mov rax, r12
    add rax, 36
    add rax, 7
    mov rcx, 8
    cqo
    idiv rcx
    mov rcx, 8
    imul rax, rcx
    mov r12, rax
    mov rax, r12
    mov [rel __g_elf_writer_el_shoff], rax
    mov rax, r13
    add rax, r12
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 320
    sub rsp, 32
    call el_zero
    add rsp, 32
    mov rax, rbx
    add rax, 64
    push rax
    pop rcx
    mov rdx, 0x0000000B00000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 72
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 80
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    mov rax, [rel __g_elf_writer_el_sym]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 88
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    push rax
    mov rax, [rel __g_elf_writer_el_sym]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 96
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    add rax, 6
    mov rcx, 24
    imul rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 104
    push rax
    pop rcx
    mov rdx, 0x0000000100000002
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 112
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 120
    push rax
    pop rcx
    mov rdx, 24
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 128
    push rax
    pop rcx
    mov rdx, 0x0000000300000009
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 136
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 144
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    add rax, 224
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 152
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    add rax, 224
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 160
    push rax
    mov rax, [rel __g_elf_writer_el_strsz]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 176
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 192
    push rax
    pop rcx
    mov rdx, 0x0000000600000011
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 200
    push rax
    pop rcx
    mov rdx, 3
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 208
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 216
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 224
    push rax
    pop rcx
    mov rdx, 224
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 232
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 240
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 248
    push rax
    pop rcx
    mov rdx, 16
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 256
    push rax
    pop rcx
    mov rdx, 0x000000030000001A
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 280
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    push rax
    mov rax, [rel __g_elf_writer_el_end]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 288
    push rax
    pop rcx
    mov rdx, 36
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 304
    push rax
    pop rcx
    mov rdx, 1
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 320
    mov [rel __g_elf_writer_el_shend], rax
    mov rax, r13
    add rax, 40
    push rax
    mov rax, [rel __g_elf_writer_el_shoff]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r13
    add rax, 58
    push rax
    pop rcx
    mov rdx, 0x00050040
    sub rsp, 32
    call el_p32
    add rsp, 32
    mov rax, r13
    add rax, 62
    push rax
    pop rcx
    mov rdx, 4
    sub rsp, 32
    call el_p16
    add rsp, 32
    mov rax, 0
    jmp .__ret_109
.__ret_109:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
el_write_so:
    push rbp
    mov rbp, rsp
    sub rsp, 400
    mov [rbp-368], rbx
    mov [rbp-360], r12
    mov [rbp-352], r13
    mov [rbp-344], r14
    mov [rbp-336], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov rax, [rbp-16]
    mov [rel __g_elf_writer_el_arm], rax
    mov rcx, 512
    mov rdx, 512
    sub rsp, 32
    call ew_put_hb
    add rsp, 32
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L111
    sub rsp, 32
    call ks_build_image
    add rsp, 32
    mov [rel __g_elf_writer_el_img], rax
    sub rsp, 32
    call ksk_code_size
    add rsp, 32
    mov [rel __g_elf_writer_el_code], rax
    mov rax, [rel __g_elf_writer_el_code]
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov [rel __g_elf_writer_el_doff], rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov [rel __g_elf_writer_el_dbase], rax
    sub rsp, 32
    call ksk_data_size
    add rsp, 32
    mov [rel __g_elf_writer_el_dlen], rax
    mov rax, [rel __g_elf_writer_el_dlen]
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov [rel __g_elf_writer_el_boff], rax
    mov rax, [rel __g_elf_writer_el_boff]
    mov [rel __g_elf_writer_el_bbase], rax
    sub rsp, 32
    call ksk_bss_size
    add rsp, 32
    mov [rel __g_elf_writer_el_blen], rax
    sub rsp, 32
    call ksk_code
    add rsp, 32
    mov rbx, rax
    mov rax, 4096
    mov [rel __g_elf_writer_el_falign], rax
    jmp .L112
.L111:
    sub rsp, 32
    call kc_build_image
    add rsp, 32
    mov [rel __g_elf_writer_el_img], rax
    sub rsp, 32
    call kc_get_code_len
    add rsp, 32
    mov [rel __g_elf_writer_el_code], rax
    sub rsp, 32
    call kc_get_data_off
    add rsp, 32
    mov [rel __g_elf_writer_el_doff], rax
    sub rsp, 32
    call kc_get_data_len
    add rsp, 32
    mov [rel __g_elf_writer_el_dlen], rax
    mov rax, [rel __g_elf_writer_el_dlen]
    add rax, 65535
    mov rcx, 65536
    cqo
    idiv rcx
    mov rcx, 65536
    imul rax, rcx
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_elf_writer_el_boff], rax
    sub rsp, 32
    call kc_get_bss_size
    add rsp, 32
    mov [rel __g_elf_writer_el_blen], rax
    sub rsp, 32
    call kc_get_code
    add rsp, 32
    mov rbx, rax
    mov rax, 65536
    mov [rel __g_elf_writer_el_falign], rax
.L112:
    mov rcx, r15
    mov rdx, 512
    sub rsp, 32
    call el_zero
    add rsp, 32
    mov rax, r15
    add rax, 512
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_img]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_copy
    add rsp, 32
    mov rax, [rel __g_elf_writer_el_img]
    add rax, 512
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, 1
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov [rel __g_elf_writer_el_F], rax
    mov rax, r15
    add rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    sub rax, rbx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_zero
    add rsp, 32
    mov rax, [rel __g_elf_writer_el_boff]
    push rax
    mov rax, [rel __g_elf_writer_el_blen]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 512
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    mov rcx, rax
    pop rax
    add rax, rcx
    sub rax, 1
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov [rel __g_elf_writer_el_V], rax
    sub rsp, 32
    call cgk_export_count
    add rsp, 32
    mov [rel __g_elf_writer_el_exp], rax
    sub rsp, 32
    call ew_len_strtab
    add rsp, 32
    mov rbx, rax
    mov rax, 0
    mov r14, rax
.L113:
    mov rax, r14
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L114
    mov rax, rbx
    push rax
    mov rcx, r14
    sub rsp, 32
    call cgk_export_nlen
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 1
    mov rbx, rax
    add r14, 1
.L115:
    jmp .L113
.L114:
    mov rax, rbx
    mov [rel __g_elf_writer_el_soname_off], rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_soname]
    push rax
    pop rcx
    sub rsp, 32
    call el_cstrlen
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 1
    mov rbx, rax
    mov rax, rbx
    mov [rel __g_elf_writer_el_strsz], rax
    mov rax, rbx
    add rax, 224
    add rax, 7
    mov rcx, 8
    cqo
    idiv rcx
    mov rcx, 8
    imul rax, rcx
    mov [rel __g_elf_writer_el_sym], rax
    mov rax, [rel __g_elf_writer_el_exp]
    add rax, 6
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_elf_writer_el_sym]
    add rax, rcx
    mov [rel __g_elf_writer_el_hash], rax
    mov rax, [rel __g_elf_writer_el_exp]
    mov rbx, rax
    cmp rbx, 0
    jne .L116
    mov rax, 1
    mov rbx, rax
    jmp .L117
.L116:
.L117:
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 6
    add rax, 2
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_elf_writer_el_hash]
    add rax, rcx
    add rax, 7
    mov rcx, 8
    cqo
    idiv rcx
    mov rcx, 8
    imul rax, rcx
    mov [rel __g_elf_writer_el_rela], rax
    mov rax, r15
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r13, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_rela]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_zero
    add rsp, 32
    sub rsp, 32
    call ew_addr_strtab
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_elf_writer_el_android]
    cmp rax, 0
    je .L118
    sub rsp, 32
    call ew_addr_strtab_and
    add rsp, 32
    mov rbx, rax
    jmp .L119
.L118:
.L119:
    mov rax, r13
    add rax, 224
    push rax
    mov rax, rbx
    push rax
    sub rsp, 32
    call ew_len_strtab
    add rsp, 32
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_copy
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_sym]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    add rax, 24
    push rax
    pop rcx
    mov rdx, 0x1200000026
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 48
    push rax
    pop rcx
    mov rdx, 0x120000002D
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 72
    push rax
    pop rcx
    mov rdx, 0x1200000033
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 96
    push rax
    pop rcx
    mov rdx, 0x1200000042
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, rbx
    add rax, 120
    push rax
    pop rcx
    mov rdx, 0x1200000051
    sub rsp, 32
    call el_p64
    add rsp, 32
    sub rsp, 32
    call ew_len_strtab
    add rsp, 32
    mov [rbp-88], rax
    mov rax, 0
    mov r14, rax
.L120:
    mov rax, r14
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L121
    mov rcx, r14
    sub rsp, 32
    call cgk_export_name
    add rsp, 32
    mov [rbp-96], rax
    mov rcx, r14
    sub rsp, 32
    call cgk_export_nlen
    add rsp, 32
    mov r12, rax
    mov rax, r13
    add rax, 224
    mov rcx, [rbp-88]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, [rbp-96]
    mov r8, r12
    sub rsp, 32
    call el_copy
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L123:
    cmp rbx, r12
    jge .L124
    cmp rbx, 300
    jl .L126
    jmp .L124
    jmp .L127
.L126:
.L127:
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 5
    add rax, rbx
    push rax
    mov rax, [rbp-96]
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call el_g8
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p8
    add rsp, 32
    add rbx, 1
.L125:
    jmp .L123
.L124:
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 0
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call el_p8
    add rsp, 32
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 1
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call el_p8
    add rsp, 32
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 2
    push rax
    pop rcx
    mov rdx, 99
    sub rsp, 32
    call el_p8
    add rsp, 32
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 3
    push rax
    pop rcx
    mov rdx, 101
    sub rsp, 32
    call el_p8
    add rsp, 32
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 4
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call el_p8
    add rsp, 32
    lea rax, [rel __g_elf_writer_el_name]
    add rax, 5
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p8
    add rsp, 32
    mov rax, rbx
    add rax, 5
    mov [rbp-120], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_elf_writer_el_arm]
    cmp rax, 0
    jne .L128
    lea rax, [rel __g_elf_writer_el_name]
    push rax
    pop rcx
    mov rdx, [rbp-120]
    sub rsp, 32
    call el_va
    add rsp, 32
    mov rbx, rax
    jmp .L129
.L128:
    lea rax, [rel __g_elf_writer_el_name]
    push rax
    pop rcx
    sub rsp, 32
    call kc_label
    add rsp, 32
    mov rbx, rax
.L129:
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_sym]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    add rax, 6
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-136], rax
    mov rax, [rbp-136]
    add rax, 8
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, [rbp-136]
    push rax
    mov rax, 0x0001001200000000
    mov rcx, [rbp-88]
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rcx, [rbp-96]
    mov rdx, r12
    sub rsp, 32
    call el_elf_hash
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    mov rcx, rax
    pop rax
    cqo
    idiv rcx
    mov rax, rdx
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_hash]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-160], rax
    mov rax, [rbp-160]
    add rax, 8
    push rax
    mov rax, rbx
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, [rbp-160]
    add rax, 8
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    add rax, r14
    add rax, 6
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rbp-176], rax
    mov rax, [rbp-176]
    push rax
    mov rcx, rbx
    sub rsp, 32
    call el_g32
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p32
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, r14
    add rax, 6
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p32
    add rsp, 32
    mov rax, [rbp-88]
    add rax, r12
    add rax, 1
    mov [rbp-88], rax
    add r14, 1
.L122:
    jmp .L120
.L121:
    mov rax, [rel __g_elf_writer_el_soname]
    mov r14, rax
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_soname_off]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 224
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L130:
    cmp rbx, 0
    je .L131
    mov rcx, r14
    sub rsp, 32
    call el_g8
    add rsp, 32
    mov rbx, rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call el_p8
    add rsp, 32
    add r14, 1
    add r12, 1
.L132:
    jmp .L130
.L131:
    mov rax, [rel __g_elf_writer_el_exp]
    mov rbx, rax
    cmp rbx, 0
    jne .L133
    mov rax, 1
    mov rbx, rax
    jmp .L134
.L133:
.L134:
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_hash]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p32
    add rsp, 32
    mov rax, r13
    push rax
    mov rax, [rel __g_elf_writer_el_hash]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 4
    push rax
    mov rax, [rel __g_elf_writer_el_exp]
    add rax, 6
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p32
    add rsp, 32
    mov rax, 0
    mov [rel __g_elf_writer_el_nrel], rax
    sub rsp, 32
    call ew_addr_got_names
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov r14, rax
.L135:
    cmp r14, 5
    jge .L136
    mov rcx, r12
    sub rsp, 32
    call el_cstrlen
    add rsp, 32
    mov [rbp-224], rax
    mov rax, 0
    mov [rbp-232], rax
    mov rax, [rel __g_elf_writer_el_arm]
    cmp rax, 0
    jne .L138
    mov rcx, r12
    mov rdx, [rbp-224]
    sub rsp, 32
    call el_va
    add rsp, 32
    mov [rbp-232], rax
    jmp .L139
.L138:
    mov rcx, r12
    sub rsp, 32
    call kc_label
    add rsp, 32
    mov [rbp-232], rax
.L139:
    mov rax, r14
    add rax, 1
    shl rax, 32
    mov rbx, rax
    mov rax, [rel __g_elf_writer_el_arm]
    cmp rax, 0
    jne .L140
    or rbx, 6
    jmp .L141
.L140:
    or rbx, 1025
.L141:
    mov rcx, r13
    mov rdx, [rbp-232]
    mov r8, rbx
    mov r9, 0
    sub rsp, 32
    call el_rel_add
    add rsp, 32
    mov rax, r12
    mov rcx, [rbp-224]
    add rax, rcx
    add rax, 1
    mov r12, rax
    add r14, 1
.L137:
    jmp .L135
.L136:
    mov rax, [rel __g_elf_writer_el_arm]
    cmp rax, 0
    jne .L142
    sub rsp, 32
    call ksk_fixup_count
    add rsp, 32
    mov [rbp-248], rax
    mov rax, 0
    mov r14, rax
.L144:
    mov rax, r14
    mov rcx, [rbp-248]
    cmp rax, rcx
    jge .L145
    mov rcx, r14
    sub rsp, 32
    call ksk_fixup_kind
    add rsp, 32
    cmp rax, 6
    jne .L147
    mov rcx, r14
    sub rsp, 32
    call ksk_fixup_label
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call el_neg1
    add rsp, 32
    cmp rax, 0
    jne .L149
    mov rcx, rbx
    sub rsp, 32
    call ksk_label_section
    add rsp, 32
    mov r12, rax
    mov rcx, rbx
    sub rsp, 32
    call ksk_label_addr
    add rsp, 32
    mov rbx, rax
    cmp r12, 1
    jne .L151
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L152
.L151:
.L152:
    cmp r12, 2
    jne .L153
    mov rax, rbx
    push rax
    mov rax, [rel __g_elf_writer_el_boff]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    jmp .L154
.L153:
.L154:
    add rbx, 512
    mov rcx, r14
    sub rsp, 32
    call ksk_fixup_at
    add rsp, 32
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 512
    mov r12, rax
    mov rax, r15
    add rax, r12
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rcx, r13
    mov rdx, r12
    mov r8, 8
    mov r9, rbx
    sub rsp, 32
    call el_rel_add
    add rsp, 32
    jmp .L150
.L149:
.L150:
    jmp .L148
.L147:
.L148:
    add r14, 1
.L146:
    jmp .L144
.L145:
    jmp .L143
.L142:
    sub rsp, 32
    call kc_reloc_count
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov r14, rax
.L155:
    cmp r14, r12
    jge .L156
    mov rcx, r14
    sub rsp, 32
    call kc_reloc_at
    add rsp, 32
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 512
    mov rbx, rax
    mov rax, r13
    push rax
    mov rax, rbx
    push rax
    mov rax, 1027
    push rax
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call el_g64
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_rel_add
    add rsp, 32
    add r14, 1
.L157:
    jmp .L155
.L156:
.L143:
    mov rax, [rel __g_elf_writer_el_nrel]
    mov rcx, 24
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_elf_writer_el_rela]
    add rax, rcx
    mov [rel __g_elf_writer_el_end], rax
    mov rax, r13
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 1
    mov r8, 1
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_elf_writer_el_android]
    cmp rax, 0
    jne .L158
    mov rcx, rbx
    mov rdx, 1
    mov r8, 11
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    jmp .L159
.L158:
    mov rcx, rbx
    mov rdx, 1
    mov r8, 9
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
.L159:
    mov rax, [rel __g_elf_writer_el_android]
    cmp rax, 0
    jne .L160
    mov rcx, rbx
    mov rdx, 1
    mov r8, 22
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    jmp .L161
.L160:
.L161:
    mov rax, rbx
    push rax
    mov rax, 14
    push rax
    mov rax, [rel __g_elf_writer_el_soname_off]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 4
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    mov rax, [rel __g_elf_writer_el_hash]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 5
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    add rax, 224
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 6
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    mov rax, [rel __g_elf_writer_el_sym]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 10
    push rax
    mov rax, [rel __g_elf_writer_el_strsz]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 11
    mov r8, 24
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 7
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    mov rax, [rel __g_elf_writer_el_rela]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 8
    push rax
    mov rax, [rel __g_elf_writer_el_nrel]
    mov rcx, 24
    imul rax, rcx
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 9
    mov r8, 24
    sub rsp, 32
    call el_dyn
    add rsp, 32
    mov rbx, rax
    mov rcx, r15
    mov rdx, 0x00010102464C457F
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 8
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L162
    mov rax, r15
    add rax, 16
    push rax
    pop rcx
    mov rdx, 0x00000001003E0003
    sub rsp, 32
    call el_p64
    add rsp, 32
    jmp .L163
.L162:
    mov rax, r15
    add rax, 16
    push rax
    pop rcx
    mov rdx, 0x0000000100B70003
    sub rsp, 32
    call el_p64
    add rsp, 32
.L163:
    mov rax, r15
    add rax, 24
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 32
    push rax
    pop rcx
    mov rdx, 64
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 40
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 48
    push rax
    pop rcx
    mov rdx, 0x0038004000000000
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 64
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-16]
    cmp rax, 0
    jne .L164
    mov rcx, r12
    mov rdx, 0x0000000700000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 8
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 16
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 24
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 32
    push rax
    mov rax, [rel __g_elf_writer_el_img]
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 40
    push rax
    mov rax, [rel __g_elf_writer_el_boff]
    push rax
    mov rax, [rel __g_elf_writer_el_blen]
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 48
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    add r12, 56
    mov rax, 3
    mov rbx, rax
    jmp .L165
.L164:
    mov rcx, r12
    mov rdx, 0x0000000500000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 8
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 16
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 24
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 32
    push rax
    mov rax, [rel __g_elf_writer_el_code]
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 40
    push rax
    mov rax, [rel __g_elf_writer_el_code]
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 48
    push rax
    pop rcx
    mov rdx, 65536
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 56
    push rax
    pop rcx
    mov rdx, 0x0000000600000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 64
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 72
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 80
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    add rax, 512
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 88
    push rax
    mov rax, [rel __g_elf_writer_el_dlen]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 96
    push rax
    mov rax, [rel __g_elf_writer_el_boff]
    push rax
    mov rax, [rel __g_elf_writer_el_doff]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_elf_writer_el_blen]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 104
    push rax
    pop rcx
    mov rdx, 65536
    sub rsp, 32
    call el_p64
    add rsp, 32
    add r12, 112
    mov rax, 4
    mov rbx, rax
.L165:
    mov rcx, r12
    mov rdx, 0x0000000600000001
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 8
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 16
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 24
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 32
    push rax
    mov rax, [rel __g_elf_writer_el_end]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 40
    push rax
    mov rax, [rel __g_elf_writer_el_end]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 48
    push rax
    mov rax, [rel __g_elf_writer_el_falign]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 56
    push rax
    pop rcx
    mov rdx, 0x0000000600000002
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 64
    push rax
    mov rax, [rel __g_elf_writer_el_F]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 72
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 80
    push rax
    mov rax, [rel __g_elf_writer_el_V]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 88
    push rax
    pop rcx
    mov rdx, 224
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 96
    push rax
    pop rcx
    mov rdx, 224
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r12
    add rax, 104
    push rax
    pop rcx
    mov rdx, 8
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rax, r15
    add rax, 56
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call el_p64
    add rsp, 32
    mov rcx, r15
    sub rsp, 32
    call el_sections
    add rsp, 32
    mov rax, [rel __g_elf_writer_el_shend]
    jmp .__ret_110
.__ret_110:
    mov rbx, [rbp-368]
    mov r12, [rbp-360]
    mov r13, [rbp-352]
    mov r14, [rbp-344]
    mov r15, [rbp-336]
    mov rsp, rbp
    pop rbp
    ret
el_prepare:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call ew_prepare_name
    add rsp, 32
    mov r13, rax
    mov rax, r13
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L167:
    cmp rbx, 0
    je .L168
    mov rcx, r13
    sub rsp, 32
    call el_g8
    add rsp, 32
    mov rbx, rax
    cmp rbx, 47
    jne .L170
    mov rax, r13
    add rax, 1
    mov r12, rax
    jmp .L171
.L170:
.L171:
    cmp rbx, 92
    jne .L172
    mov rax, r13
    add rax, 1
    mov r12, rax
    jmp .L173
.L172:
.L173:
    cmp rbx, 0
    je .L174
    add r13, 1
    jmp .L175
.L174:
.L175:
.L169:
    jmp .L167
.L168:
    mov rax, r12
    mov [rel __g_elf_writer_el_soname], rax
    sub rsp, 32
    call ew_out_android
    add rsp, 32
    mov [rel __g_elf_writer_el_android], rax
    mov rax, 0
    jmp .__ret_166
.__ret_166:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
