; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_macho_writer_MW_BASE: dq 4294967296
section .text
section .data
__g_macho_writer_MW_CODE: dq 16384
section .text
section .data
__g_macho_writer_MW_NSYM: dq 5
section .text
section .data
__g_macho_writer_mw_out: dq 0
section .text
section .data
__g_macho_writer_mw_n: dq 0
section .text
section .data
__g_macho_writer_mw_lc: dq 0
section .text
section .data
__g_macho_writer_mw_ncmds: dq 0
section .text
section .data
__g_macho_writer_mw_name: dq 0
section .text
section .data
__g_macho_writer_mw_dylib: dq 0
section .text
section .data
__g_macho_writer_mw_platform: dq 0
section .text
section .data
__g_macho_writer_mw_code_len: dq 0
section .text
section .data
__g_macho_writer_mw_data_len: dq 0
section .text
section .data
__g_macho_writer_mw_bss_len: dq 0
section .text
section .data
__g_macho_writer_mw_text_sz: dq 0
section .text
section .data
__g_macho_writer_mw_data_fsz: dq 0
section .text
section .data
__g_macho_writer_mw_data_vsz: dq 0
section .text
section .data
__g_macho_writer_mw_le_off: dq 0
section .text
section .data
__g_macho_writer_mw_rebase_off: dq 0
section .text
section .data
__g_macho_writer_mw_rebase_sz: dq 0
section .text
section .data
__g_macho_writer_mw_bind_off: dq 0
section .text
section .data
__g_macho_writer_mw_bind_sz: dq 0
section .text
section .data
__g_macho_writer_mw_export_off: dq 0
section .text
section .data
__g_macho_writer_mw_export_sz: dq 0
section .text
section .data
__g_macho_writer_mw_symoff: dq 0
section .text
section .data
__g_macho_writer_mw_stroff: dq 0
section .text
section .data
__g_macho_writer_mw_strsize: dq 0
section .text
section .data
__g_macho_writer_mw_sig_off: dq 0
section .text
section .data
__g_macho_writer_mw_sig_size: dq 0
section .text
section .data
__g_macho_writer_mw_entry: dq 0
section .text
section .bss
__g_macho_writer_mw_got: resq 5
section .text
section .data
__g_macho_writer_mw_base: dq 0
section .text
section .data
__g_macho_writer_mw_ndef: dq 0
section .text
section .bss
__g_macho_writer_mw_exp_addr: resq 4096
section .text
section .bss
__g_macho_writer_mw_lbl: resq 40
section .text
section .data
__g_macho_writer_mw_identlen: dq 0
section .text
section .data
__g_macho_writer_mw_ncode: dq 0
section .text
section .data
__g_macho_writer_mw_sp: dq 0
section .text
section .bss
__g_macho_writer_mw_h: resq 4
section .text
section .bss
__g_macho_writer_mw_w: resq 32
section .text
section .bss
__g_macho_writer_mw_blk: resq 16
section .text
section .bss
__g_macho_writer_mw_digest: resq 4
section .text
section .bss
__g_macho_writer_mw_k: resq 32
section .text
section .data
__g_macho_writer_mw_kready: dq 0
section .text
mw_p8:
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
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_p16:
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
    jmp .__ret_1
.__ret_1:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_p32:
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
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_p64:
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
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_g8:
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
    jmp .__ret_4
.__ret_4:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_g32:
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
    mov rcx, 4294967295
    and rax, rcx
    jmp .__ret_5
.__ret_5:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_g64:
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
    jmp .__ret_6
.__ret_6:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_copy:
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
.L8:
    cmp rbx, r12
    jge .L9
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
.L10:
    jmp .L8
.L9:
    mov rax, r14
    jmp .__ret_7
.__ret_7:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mw_fill:
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
.L12:
    cmp rbx, r13
    jge .L13
    mov rax, r14
    add rax, rbx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], cl
    add rbx, 1
.L14:
    jmp .L12
.L13:
    mov rax, r14
    jmp .__ret_11
.__ret_11:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mw_strlen:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L16:
    mov rax, r12
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    cmp rax, 0
    je .L17
    add rbx, 1
.L18:
    jmp .L16
.L17:
    mov rax, rbx
    jmp .__ret_15
.__ret_15:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_page:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    add rax, 16383
    mov rcx, 16384
    cqo
    idiv rcx
    mov rcx, 16384
    imul rax, rcx
    jmp .__ret_19
.__ret_19:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_b:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    add rax, 1
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, 0
    jmp .__ret_20
.__ret_20:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_w16:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    and rax, 65535
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p16
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    add rax, 2
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, 0
    jmp .__ret_21
.__ret_21:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    add rax, 4
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, 0
    jmp .__ret_22
.__ret_22:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_q:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mw_p64
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    add rax, 8
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, 0
    jmp .__ret_23
.__ret_23:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_uleb:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov rbx, rcx
    mov rax, rbx
    mov r12, rax
.L25:
    mov rax, 1
    cmp rax, 1
    jne .L26
    mov rax, r12
    and rax, 127
    mov rbx, rax
    mov rax, r12
    shr rax, 7
    mov r12, rax
    cmp r12, 0
    jne .L28
    mov rcx, rbx
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rax, 0
    jmp .__ret_24
    jmp .L29
.L28:
.L29:
    mov rax, rbx
    or rax, 128
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
.L27:
    jmp .L25
.L26:
    mov rax, 0
    jmp .__ret_24
.__ret_24:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
mw_str:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
.L31:
    mov rax, 1
    cmp rax, 1
    jne .L32
    mov rax, r13
    add rax, r12
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call mw_b
    add rsp, 32
    cmp rbx, 0
    jne .L34
    mov rax, 0
    jmp .__ret_30
    jmp .L35
.L34:
.L35:
    add r12, 1
.L33:
    jmp .L31
.L32:
    mov rax, 0
    jmp .__ret_30
.__ret_30:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mw_align8:
    push rbp
    mov rbp, rsp
    sub rsp, 32
.L37:
    mov rax, [rel __g_macho_writer_mw_n]
    and rax, 7
    cmp rax, 0
    je .L38
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
.L39:
    jmp .L37
.L38:
    mov rax, 0
    jmp .__ret_36
.__ret_36:
    mov rsp, rbp
    pop rbp
    ret
mw_sym_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L41
section .data
.str43: db 95,112,116,104,114,101,97,100,95,99,114,101,97,116,101,0
section .text
    lea rax, [rel .str43]
    jmp .__ret_40
    jmp .L42
.L41:
.L42:
    cmp rbx, 1
    jne .L44
section .data
.str46: db 95,112,116,104,114,101,97,100,95,100,101,116,97,99,104,0
section .text
    lea rax, [rel .str46]
    jmp .__ret_40
    jmp .L45
.L44:
.L45:
    cmp rbx, 2
    jne .L47
section .data
.str49: db 95,100,108,111,112,101,110,0
section .text
    lea rax, [rel .str49]
    jmp .__ret_40
    jmp .L48
.L47:
.L48:
    cmp rbx, 3
    jne .L50
section .data
.str52: db 95,100,108,115,121,109,0
section .text
    lea rax, [rel .str52]
    jmp .__ret_40
    jmp .L51
.L50:
.L51:
section .data
.str53: db 95,101,120,105,116,0
section .text
    lea rax, [rel .str53]
    jmp .__ret_40
.__ret_40:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_sym_label:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L55
section .data
.str57: db 95,95,109,97,99,95,103,111,116,95,99,114,101,97,116,101,0
section .text
    lea rax, [rel .str57]
    jmp .__ret_54
    jmp .L56
.L55:
.L56:
    cmp rbx, 1
    jne .L58
section .data
.str60: db 95,95,109,97,99,95,103,111,116,95,100,101,116,97,99,104,0
section .text
    lea rax, [rel .str60]
    jmp .__ret_54
    jmp .L59
.L58:
.L59:
    cmp rbx, 2
    jne .L61
section .data
.str63: db 95,95,103,111,116,95,100,108,111,112,101,110,0
section .text
    lea rax, [rel .str63]
    jmp .__ret_54
    jmp .L62
.L61:
.L62:
    cmp rbx, 3
    jne .L64
section .data
.str66: db 95,95,103,111,116,95,100,108,115,121,109,0
section .text
    lea rax, [rel .str66]
    jmp .__ret_54
    jmp .L65
.L64:
.L65:
section .data
.str67: db 95,95,103,111,116,95,101,120,105,116,0
section .text
    lea rax, [rel .str67]
    jmp .__ret_54
.__ret_54:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_write:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov [rel __g_macho_writer_mw_out], rax
    mov rax, rbx
    mov [rel __g_macho_writer_mw_name], rax
    sub rsp, 32
    call mo_get_dylib
    add rsp, 32
    mov [rel __g_macho_writer_mw_dylib], rax
    sub rsp, 32
    call mo_get_platform
    add rsp, 32
    mov [rel __g_macho_writer_mw_platform], rax
    mov rax, [rel __g_macho_writer_MW_BASE]
    mov [rel __g_macho_writer_mw_base], rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    je .L69
    mov rax, 0
    mov [rel __g_macho_writer_mw_base], rax
    jmp .L70
.L69:
.L70:
    sub rsp, 32
    call karm_reloc_text
    add rsp, 32
    cmp rax, 0
    je .L71
    mov rax, 0
    jmp .__ret_68
    jmp .L72
.L71:
.L72:
    sub rsp, 32
    call karm_build_image
    add rsp, 32
    sub rsp, 32
    call karm_get_code_len
    add rsp, 32
    mov [rel __g_macho_writer_mw_code_len], rax
    sub rsp, 32
    call karm_get_data_len
    add rsp, 32
    mov [rel __g_macho_writer_mw_data_len], rax
    sub rsp, 32
    call karm_get_bss_size
    add rsp, 32
    mov [rel __g_macho_writer_mw_bss_len], rax
    mov rax, [rel __g_macho_writer_mw_code_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_page
    add rsp, 32
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_text_sz], rax
    mov rax, [rel __g_macho_writer_mw_data_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_page
    add rsp, 32
    mov [rel __g_macho_writer_mw_data_fsz], rax
    mov rax, [rel __g_macho_writer_mw_bss_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_page
    add rsp, 32
    push rax
    mov rax, [rel __g_macho_writer_mw_data_fsz]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_data_vsz], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r14, rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    jne .L73
section .data
.str75: db 95,95,109,97,99,95,109,97,105,110,0
section .text
    lea rax, [rel .str75]
    push rax
    pop rcx
    sub rsp, 32
    call karm_label
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L76
    mov rax, 0
    jmp .__ret_68
    jmp .L77
.L76:
.L77:
    mov rax, rbx
    push rax
    mov rax, [rel __g_macho_writer_mw_base]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_macho_writer_mw_entry], rax
    mov rax, 1
    mov [rel __g_macho_writer_mw_ndef], rax
    jmp .L74
.L73:
    sub rsp, 32
    call codegen_export_count
    add rsp, 32
    mov [rel __g_macho_writer_mw_ndef], rax
    mov rax, 0
    mov r14, rax
.L78:
    mov rax, r14
    push rax
    mov rax, [rel __g_macho_writer_mw_ndef]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L79
    mov rcx, r14
    sub rsp, 32
    call ew_export_name
    add rsp, 32
    mov r12, rax
    mov rcx, r14
    sub rsp, 32
    call ew_export_len
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 0
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call mw_p8
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 1
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call mw_p8
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 2
    push rax
    pop rcx
    mov rdx, 99
    sub rsp, 32
    call mw_p8
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 3
    push rax
    pop rcx
    mov rdx, 101
    sub rsp, 32
    call mw_p8
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 4
    push rax
    pop rcx
    mov rdx, 95
    sub rsp, 32
    call mw_p8
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 5
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call mw_copy
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    add rax, 5
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mw_p8
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_lbl]
    push rax
    pop rcx
    sub rsp, 32
    call karm_label
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L81
    mov rax, 0
    jmp .__ret_68
    jmp .L82
.L81:
.L82:
    lea rax, [rel __g_macho_writer_mw_exp_addr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_macho_writer_mw_base]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p64
    add rsp, 32
    add r14, 1
.L80:
    jmp .L78
.L79:
.L74:
    mov rax, 0
    mov r12, rax
.L83:
    mov rax, r12
    push rax
    mov rax, [rel __g_macho_writer_MW_NSYM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L84
    mov rcx, r12
    sub rsp, 32
    call mw_sym_label
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call karm_label
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L86
    mov rax, 0
    jmp .__ret_68
    jmp .L87
.L86:
.L87:
    lea rax, [rel __g_macho_writer_mw_got]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_macho_writer_mw_base]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p64
    add rsp, 32
    add r12, 1
.L85:
    jmp .L83
.L84:
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call mw_fill
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    sub rsp, 32
    call karm_get_code
    add rsp, 32
    push rax
    mov rax, [rel __g_macho_writer_mw_code_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_copy
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_code_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_code_len]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call mw_fill
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    sub rsp, 32
    call karm_get_code
    add rsp, 32
    push rax
    mov rax, [rel __g_macho_writer_mw_code_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_page
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_data_len]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_copy
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_data_len]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_data_fsz]
    push rax
    mov rax, [rel __g_macho_writer_mw_data_len]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call mw_fill
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    mov rax, [rel __g_macho_writer_mw_data_fsz]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_le_off], rax
    mov rax, [rel __g_macho_writer_mw_le_off]
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov [rel __g_macho_writer_mw_rebase_off], rax
    sub rsp, 32
    call karm_reloc_count
    add rsp, 32
    mov r13, rax
    cmp r13, 0
    je .L88
    mov rcx, 17
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L90:
    cmp r12, r13
    jge .L91
    mov rcx, r12
    sub rsp, 32
    call karm_reloc_at
    add rsp, 32
    mov rbx, rax
    mov rax, 34
    push rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mw_uleb
    add rsp, 32
    mov rcx, 81
    sub rsp, 32
    call mw_b
    add rsp, 32
    add r12, 1
.L92:
    jmp .L90
.L91:
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    jmp .L89
.L88:
.L89:
    sub rsp, 32
    call mw_align8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    push rax
    mov rax, [rel __g_macho_writer_mw_rebase_off]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_macho_writer_mw_rebase_sz], rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov [rel __g_macho_writer_mw_bind_off], rax
    mov rcx, 17
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 81
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rax, 0
    mov r12, rax
.L93:
    mov rax, r12
    push rax
    mov rax, [rel __g_macho_writer_MW_NSYM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L94
    mov rcx, 64
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, r12
    sub rsp, 32
    call mw_sym_name
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_str
    add rsp, 32
    mov rax, 114
    push rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_got]
    push rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g64
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_uleb
    add rsp, 32
    mov rcx, 144
    sub rsp, 32
    call mw_b
    add rsp, 32
    add r12, 1
.L95:
    jmp .L93
.L94:
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    sub rsp, 32
    call mw_align8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    push rax
    mov rax, [rel __g_macho_writer_mw_bind_off]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_macho_writer_mw_bind_sz], rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov [rel __g_macho_writer_mw_export_off], rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    je .L96
    sub rsp, 32
    call mw_trie
    add rsp, 32
    jmp .L97
.L96:
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_b
    add rsp, 32
section .data
.str98: db 95,95,109,104,95,101,120,101,99,117,116,101,95,104,101,97,100,101,114,0
section .text
    lea rax, [rel .str98]
    push rax
    pop rcx
    sub rsp, 32
    call mw_str
    add rsp, 32
    mov rcx, 23
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
.L97:
    sub rsp, 32
    call mw_align8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    push rax
    mov rax, [rel __g_macho_writer_mw_export_off]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_macho_writer_mw_export_sz], rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov [rel __g_macho_writer_mw_symoff], rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    je .L99
    mov rax, 2
    mov rbx, rax
    mov rax, 0
    mov r14, rax
.L101:
    mov rax, r14
    push rax
    mov rax, [rel __g_macho_writer_mw_ndef]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L102
    mov rcx, rbx
    sub rsp, 32
    call mw_d
    add rsp, 32
    mov rcx, 15
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_w16
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_exp_addr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g64
    add rsp, 32
    push rax
    mov rax, [rel __g_macho_writer_mw_base]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_q
    add rsp, 32
    mov rax, rbx
    push rax
    mov rcx, r14
    sub rsp, 32
    call ew_export_len
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 2
    mov rbx, rax
    add r14, 1
.L103:
    jmp .L101
.L102:
    jmp .L100
.L99:
    mov rcx, 2
    sub rsp, 32
    call mw_d
    add rsp, 32
    mov rcx, 15
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 16
    sub rsp, 32
    call mw_w16
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    pop rcx
    sub rsp, 32
    call mw_q
    add rsp, 32
    mov rax, 22
    mov rbx, rax
.L100:
    mov rax, 0
    mov r12, rax
.L104:
    mov rax, r12
    push rax
    mov rax, [rel __g_macho_writer_MW_NSYM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L105
    mov rcx, rbx
    sub rsp, 32
    call mw_d
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 256
    sub rsp, 32
    call mw_w16
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_q
    add rsp, 32
    mov rax, rbx
    push rax
    mov rcx, r12
    sub rsp, 32
    call mw_sym_name
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_strlen
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, 1
    mov rbx, rax
    add r12, 1
.L106:
    jmp .L104
.L105:
    mov rax, [rel __g_macho_writer_mw_n]
    mov [rel __g_macho_writer_mw_stroff], rax
    mov rcx, 32
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    je .L107
    mov rax, 0
    mov r14, rax
.L109:
    mov rax, r14
    push rax
    mov rax, [rel __g_macho_writer_mw_ndef]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L110
    mov rcx, 95
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call ew_export_name
    add rsp, 32
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call ew_export_len
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L112:
    cmp rbx, r12
    jge .L113
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
    add rbx, 1
.L114:
    jmp .L112
.L113:
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    add r14, 1
.L111:
    jmp .L109
.L110:
    jmp .L108
.L107:
section .data
.str115: db 95,95,109,104,95,101,120,101,99,117,116,101,95,104,101,97,100,101,114,0
section .text
    lea rax, [rel .str115]
    push rax
    pop rcx
    sub rsp, 32
    call mw_str
    add rsp, 32
.L108:
    mov rax, 0
    mov r12, rax
.L116:
    mov rax, r12
    push rax
    mov rax, [rel __g_macho_writer_MW_NSYM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L117
    mov rcx, r12
    sub rsp, 32
    call mw_sym_name
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_str
    add rsp, 32
    add r12, 1
.L118:
    jmp .L116
.L117:
    sub rsp, 32
    call mw_align8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    push rax
    mov rax, [rel __g_macho_writer_mw_stroff]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov [rel __g_macho_writer_mw_strsize], rax
    mov rax, [rel __g_macho_writer_mw_n]
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov rbx, rax
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov rcx, rax
    pop rax
    sub rax, rcx
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call mw_fill
    add rsp, 32
    mov rax, rbx
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, [rel __g_macho_writer_mw_n]
    mov [rel __g_macho_writer_mw_sig_off], rax
    mov rax, [rel __g_macho_writer_mw_n]
    add rax, 4095
    mov rcx, 4096
    cqo
    idiv rcx
    mov [rel __g_macho_writer_mw_ncode], rax
    mov rax, [rel __g_macho_writer_mw_name]
    push rax
    pop rcx
    sub rsp, 32
    call mw_strlen
    add rsp, 32
    add rax, 1
    add rax, 15
    mov rcx, 16
    cqo
    idiv rcx
    mov rcx, 16
    imul rax, rcx
    mov [rel __g_macho_writer_mw_identlen], rax
    mov rax, [rel __g_macho_writer_mw_ncode]
    mov rcx, 32
    imul rax, rcx
    add rax, 112
    push rax
    mov rax, [rel __g_macho_writer_mw_identlen]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_sig_size], rax
    sub rsp, 32
    call mw_commands
    add rsp, 32
    sub rsp, 32
    call mw_signature
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_n]
    jmp .__ret_68
.__ret_68:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov rsp, rbp
    pop rbp
    ret
mw_lc_d:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_lc]
    push rax
    mov rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_lc]
    add rax, 4
    mov [rel __g_macho_writer_mw_lc], rax
    mov rax, 0
    jmp .__ret_119
.__ret_119:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_lc_q:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_lc]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mw_p64
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_lc]
    add rax, 8
    mov [rel __g_macho_writer_mw_lc], rax
    mov rax, 0
    jmp .__ret_120
.__ret_120:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_lc_str:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov rbx, rcx
    mov r14, rdx
    mov rax, 0
    mov r13, rax
    mov rax, rbx
    mov r12, rax
.L122:
    cmp r13, r14
    jge .L123
    mov rcx, r12
    sub rsp, 32
    call mw_g8
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_macho_writer_mw_lc]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    cmp rbx, 0
    je .L125
    add r12, 1
    jmp .L126
.L125:
.L126:
    add r13, 1
.L124:
    jmp .L122
.L123:
    mov rax, [rel __g_macho_writer_mw_lc]
    add rax, r14
    mov [rel __g_macho_writer_mw_lc], rax
    mov rax, 0
    jmp .__ret_121
.__ret_121:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
mw_lc_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rcx, rbx
    mov rdx, 16
    sub rsp, 32
    call mw_lc_str
    add rsp, 32
    jmp .__ret_127
.__ret_127:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_cmd:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, [rel __g_macho_writer_mw_ncmds]
    add rax, 1
    mov [rel __g_macho_writer_mw_ncmds], rax
    mov rcx, r12
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, 0
    jmp .__ret_128
.__ret_128:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_commands:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 32
    mov [rel __g_macho_writer_mw_lc], rax
    mov rax, 0
    mov [rel __g_macho_writer_mw_ncmds], rax
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    jne .L130
    mov rcx, 25
    mov rdx, 72
    sub rsp, 32
    call mw_cmd
    add rsp, 32
section .data
.str132: db 95,95,80,65,71,69,90,69,82,79,0
section .text
    lea rax, [rel .str132]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    jmp .L131
.L130:
.L131:
    mov rcx, 25
    mov rdx, 152
    sub rsp, 32
    call mw_cmd
    add rsp, 32
section .data
.str133: db 95,95,84,69,88,84,0
section .text
    lea rax, [rel .str133]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 5
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 5
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
section .data
.str134: db 95,95,116,101,120,116,0
section .text
    lea rax, [rel .str134]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
section .data
.str135: db 95,95,84,69,88,84,0
section .text
    lea rax, [rel .str135]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_code_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_MW_CODE]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2147484672
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 25
    mov rdx, 232
    sub rsp, 32
    call mw_cmd
    add rsp, 32
section .data
.str136: db 95,95,68,65,84,65,0
section .text
    lea rax, [rel .str136]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_data_vsz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_data_fsz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 3
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
section .data
.str137: db 95,95,100,97,116,97,0
section .text
    lea rax, [rel .str137]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
section .data
.str138: db 95,95,68,65,84,65,0
section .text
    lea rax, [rel .str138]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_data_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
section .data
.str139: db 95,95,98,115,115,0
section .text
    lea rax, [rel .str139]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
section .data
.str140: db 95,95,68,65,84,65,0
section .text
    lea rax, [rel .str140]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_data_fsz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_bss_len]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 4
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 25
    mov rdx, 72
    sub rsp, 32
    call mw_cmd
    add rsp, 32
section .data
.str141: db 95,95,76,73,78,75,69,68,73,84,0
section .text
    lea rax, [rel .str141]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_name
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_base]
    push rax
    mov rax, [rel __g_macho_writer_mw_text_sz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_data_vsz]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sig_off]
    push rax
    mov rax, [rel __g_macho_writer_mw_sig_size]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_le_off]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call mw_page
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_le_off]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2147483682
    mov rdx, 48
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_rebase_off]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_rebase_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_bind_off]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_bind_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_export_off]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_export_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2
    mov rdx, 24
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_symoff]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_ndef]
    push rax
    mov rax, [rel __g_macho_writer_MW_NSYM]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_stroff]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_strsize]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 11
    mov rdx, 80
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_ndef]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_ndef]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_MW_NSYM]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, 0
    mov rbx, rax
.L142:
    cmp rbx, 12
    jge .L143
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    add rbx, 1
.L144:
    jmp .L142
.L143:
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    jne .L145
    mov rcx, 14
    mov rdx, 32
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rcx, 12
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
section .data
.str147: db 47,117,115,114,47,108,105,98,47,100,121,108,100,0
section .text
    lea rax, [rel .str147]
    push rax
    pop rcx
    mov rdx, 20
    sub rsp, 32
    call mw_lc_str
    add rsp, 32
    jmp .L146
.L145:
    sub rsp, 32
    call mw_id_dylib
    add rsp, 32
.L146:
    mov rcx, 27
    mov rdx, 24
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_MW_CODE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g64
    add rsp, 32
    push rax
    mov rax, [rel __g_macho_writer_mw_code_len]
    mov rcx, rax
    pop rax
    xor rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_data_len]
    shl rax, 20
    push rax
    mov rax, [rel __g_macho_writer_mw_bss_len]
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rcx, 4611686018427387904
    or rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 50
    mov rdx, 24
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_platform]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, 720896
    mov rbx, rax
    mov rax, [rel __g_macho_writer_mw_platform]
    cmp rax, 2
    jne .L148
    mov rax, 917504
    mov rbx, rax
    jmp .L149
.L148:
.L149:
    mov rcx, rbx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, rbx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    jne .L150
    mov rcx, 2147483688
    mov rdx, 24
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_entry]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_lc_q
    add rsp, 32
    jmp .L151
.L150:
.L151:
    mov rcx, 12
    mov rdx, 56
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rcx, 24
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 86441984
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 65536
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
section .data
.str152: db 47,117,115,114,47,108,105,98,47,108,105,98,83,121,115,116,101,109,46,66,46,100,121,108,105,98,0
section .text
    lea rax, [rel .str152]
    push rax
    pop rcx
    mov rdx, 32
    sub rsp, 32
    call mw_lc_str
    add rsp, 32
    mov rcx, 29
    mov rdx, 16
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sig_off]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sig_size]
    push rax
    pop rcx
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    pop rcx
    mov rdx, 4277009103
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 4
    push rax
    pop rcx
    mov rdx, 16777228
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 8
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 12
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 16
    push rax
    mov rax, [rel __g_macho_writer_mw_ncmds]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 20
    push rax
    mov rax, [rel __g_macho_writer_mw_lc]
    push rax
    mov rax, [rel __g_macho_writer_mw_out]
    mov rcx, rax
    pop rax
    sub rax, rcx
    sub rax, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 24
    push rax
    pop rcx
    mov rdx, 2097285
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_dylib]
    cmp rax, 0
    je .L153
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 12
    push rax
    pop rcx
    mov rdx, 6
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 24
    push rax
    pop rcx
    mov rdx, 1048709
    sub rsp, 32
    call mw_p32
    add rsp, 32
    jmp .L154
.L153:
.L154:
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, 28
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, 0
    jmp .__ret_129
.__ret_129:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mw_id_dylib:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    sub rsp, 32
    call mo_get_idname
    add rsp, 32
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call mw_strlen
    add rsp, 32
    mov r12, rax
    mov rax, r12
    add rax, 8
    add rax, 24
    add rax, 7
    mov rcx, 8
    cqo
    idiv rcx
    mov rcx, 8
    imul rax, rcx
    mov rbx, rax
    mov rcx, 13
    mov rdx, rbx
    sub rsp, 32
    call mw_cmd
    add rsp, 32
    mov rcx, 24
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 2
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 65536
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rcx, 65536
    sub rsp, 32
    call mw_lc_d
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_lc]
    push rax
    mov rax, rbx
    sub rax, 24
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call mw_fill
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_lc]
    push rax
section .data
.str156: db 64,114,112,97,116,104,47,0
section .text
    lea rax, [rel .str156]
    push rax
    pop rdx
    pop rcx
    mov r8, 7
    sub rsp, 32
    call mw_copy
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_lc]
    add rax, 7
    push rax
    pop rcx
    mov rdx, r13
    mov r8, r12
    sub rsp, 32
    call mw_copy
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_lc]
    add rax, rbx
    sub rax, 24
    mov [rel __g_macho_writer_mw_lc], rax
    mov rax, 0
    jmp .__ret_155
.__ret_155:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
mw_trie:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_ndef]
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rax, 0
    mov r14, rax
.L158:
    mov rax, r14
    push rax
    mov rax, [rel __g_macho_writer_mw_ndef]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L159
    mov rcx, 95
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, r14
    sub rsp, 32
    call ew_export_name
    add rsp, 32
    mov r13, rax
    mov rcx, r14
    sub rsp, 32
    call ew_export_len
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L161:
    cmp rbx, r12
    jge .L162
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
    add rbx, 1
.L163:
    jmp .L161
.L162:
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    lea rax, [rel __g_macho_writer_mw_exp_addr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g64
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_macho_writer_mw_exp_addr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_macho_writer_mw_n]
    shl rax, 32
    mov rcx, rax
    mov rax, rbx
    or rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p64
    add rsp, 32
    mov rcx, 128
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 128
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    add r14, 1
.L160:
    jmp .L158
.L159:
    mov rax, 0
    mov r14, rax
.L164:
    mov rax, r14
    push rax
    mov rax, [rel __g_macho_writer_mw_ndef]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L165
    mov rax, [rel __g_macho_writer_mw_n]
    push rax
    mov rax, [rel __g_macho_writer_mw_export_off]
    mov rcx, rax
    pop rax
    sub rax, rcx
    mov r15, rax
    lea rax, [rel __g_macho_writer_mw_exp_addr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g64
    add rsp, 32
    mov r12, rax
    mov rax, r12
    shr rax, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 4294967295
    and rax, rcx
    mov r13, rax
    lea rax, [rel __g_macho_writer_mw_exp_addr]
    push rax
    mov rax, r14
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    mov rdx, r13
    sub rsp, 32
    call mw_p64
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, rbx
    push rax
    mov rax, r15
    and rax, 127
    or rax, 128
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, rbx
    add rax, 1
    push rax
    mov rax, r15
    shr rax, 7
    and rax, 127
    or rax, 128
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, rbx
    add rax, 2
    push rax
    mov rax, r15
    shr rax, 14
    and rax, 127
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, 0
    mov r12, rax
    mov rax, r13
    mov rbx, rax
    mov rax, 1
    mov r12, rax
    mov rax, rbx
    shr rax, 7
    mov rbx, rax
.L167:
    cmp rbx, 0
    je .L168
    add r12, 1
    mov rax, rbx
    shr rax, 7
    mov rbx, rax
.L169:
    jmp .L167
.L168:
    mov rax, r12
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    mov rcx, r13
    sub rsp, 32
    call mw_uleb
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_b
    add rsp, 32
    add r14, 1
.L166:
    jmp .L164
.L165:
    mov rax, 0
    jmp .__ret_157
.__ret_157:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
mw_be32:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, [rel __g_macho_writer_mw_sp]
    push rax
    mov rax, rbx
    shr rax, 24
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 1
    push rax
    mov rax, rbx
    shr rax, 16
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 2
    push rax
    mov rax, rbx
    shr rax, 8
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 3
    push rax
    mov rax, rbx
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 4
    mov [rel __g_macho_writer_mw_sp], rax
    mov rax, 0
    jmp .__ret_170
.__ret_170:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_signature:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov rax, [rel __g_macho_writer_mw_out]
    push rax
    mov rax, [rel __g_macho_writer_mw_sig_off]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_sp], rax
    mov rcx, 4208856256
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sig_size]
    push rax
    pop rcx
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 24
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 4208856066
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sig_size]
    sub rax, 24
    push rax
    pop rcx
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 132096
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 131074
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_identlen]
    add rax, 88
    push rax
    pop rcx
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 88
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_ncode]
    push rax
    pop rcx
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sig_off]
    push rax
    pop rcx
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    push rax
    pop rcx
    mov rdx, 32
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 1
    push rax
    pop rcx
    mov rdx, 2
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 2
    push rax
    pop rcx
    mov rdx, 0
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 3
    push rax
    pop rcx
    mov rdx, 12
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 4
    mov [rel __g_macho_writer_mw_sp], rax
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_text_sz]
    push rax
    pop rcx
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 0
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rcx, 1
    sub rsp, 32
    call mw_be32
    add rsp, 32
    mov rax, 0
    mov r13, rax
    mov rax, [rel __g_macho_writer_mw_name]
    mov r12, rax
.L172:
    mov rax, r13
    push rax
    mov rax, [rel __g_macho_writer_mw_identlen]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L173
    mov rcx, r12
    sub rsp, 32
    call mw_g8
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, r13
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    cmp rbx, 0
    je .L175
    add r12, 1
    jmp .L176
.L175:
.L176:
    add r13, 1
.L174:
    jmp .L172
.L173:
    mov rax, [rel __g_macho_writer_mw_sp]
    push rax
    mov rax, [rel __g_macho_writer_mw_identlen]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_sp], rax
    mov rax, 0
    mov r12, rax
.L177:
    mov rax, r12
    push rax
    mov rax, [rel __g_macho_writer_mw_ncode]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L178
    mov rax, r12
    mov rcx, 4096
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_macho_writer_mw_sig_off]
    sub rax, rcx
    mov rbx, rax
    cmp rbx, 4096
    jle .L180
    mov rax, 4096
    mov rbx, rax
    jmp .L181
.L180:
.L181:
    mov rax, r12
    mov rcx, 4096
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_macho_writer_mw_out]
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mw_sha256
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    push rax
    lea rax, [rel __g_macho_writer_mw_digest]
    push rax
    pop rdx
    pop rcx
    mov r8, 32
    sub rsp, 32
    call mw_copy
    add rsp, 32
    mov rax, [rel __g_macho_writer_mw_sp]
    add rax, 32
    mov [rel __g_macho_writer_mw_sp], rax
    add r12, 1
.L179:
    jmp .L177
.L178:
    mov rax, [rel __g_macho_writer_mw_sig_off]
    push rax
    mov rax, [rel __g_macho_writer_mw_sig_size]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_macho_writer_mw_n], rax
    mov rax, 0
    jmp .__ret_171
.__ret_171:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
mw_k_init:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    lea rax, [rel __g_macho_writer_mw_k]
    mov rbx, rax
    mov rax, rbx
    add rax, 0
    push rax
    pop rcx
    mov rdx, 1116352408
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 4
    push rax
    pop rcx
    mov rdx, 1899447441
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 8
    push rax
    pop rcx
    mov rdx, 3049323471
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 12
    push rax
    pop rcx
    mov rdx, 3921009573
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 16
    push rax
    pop rcx
    mov rdx, 961987163
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 20
    push rax
    pop rcx
    mov rdx, 1508970993
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 24
    push rax
    pop rcx
    mov rdx, 2453635748
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 28
    push rax
    pop rcx
    mov rdx, 2870763221
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 32
    push rax
    pop rcx
    mov rdx, 3624381080
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 36
    push rax
    pop rcx
    mov rdx, 310598401
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 40
    push rax
    pop rcx
    mov rdx, 607225278
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 44
    push rax
    pop rcx
    mov rdx, 1426881987
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 48
    push rax
    pop rcx
    mov rdx, 1925078388
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 52
    push rax
    pop rcx
    mov rdx, 2162078206
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 56
    push rax
    pop rcx
    mov rdx, 2614888103
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 60
    push rax
    pop rcx
    mov rdx, 3248222580
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 64
    push rax
    pop rcx
    mov rdx, 3835390401
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 68
    push rax
    pop rcx
    mov rdx, 4022224774
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 72
    push rax
    pop rcx
    mov rdx, 264347078
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 76
    push rax
    pop rcx
    mov rdx, 604807628
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 80
    push rax
    pop rcx
    mov rdx, 770255983
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 84
    push rax
    pop rcx
    mov rdx, 1249150122
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 88
    push rax
    pop rcx
    mov rdx, 1555081692
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 92
    push rax
    pop rcx
    mov rdx, 1996064986
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 96
    push rax
    pop rcx
    mov rdx, 2554220882
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 100
    push rax
    pop rcx
    mov rdx, 2821834349
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 104
    push rax
    pop rcx
    mov rdx, 2952996808
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 108
    push rax
    pop rcx
    mov rdx, 3210313671
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 112
    push rax
    pop rcx
    mov rdx, 3336571891
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 116
    push rax
    pop rcx
    mov rdx, 3584528711
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 120
    push rax
    pop rcx
    mov rdx, 113926993
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 124
    push rax
    pop rcx
    mov rdx, 338241895
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 128
    push rax
    pop rcx
    mov rdx, 666307205
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 132
    push rax
    pop rcx
    mov rdx, 773529912
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 136
    push rax
    pop rcx
    mov rdx, 1294757372
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 140
    push rax
    pop rcx
    mov rdx, 1396182291
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 144
    push rax
    pop rcx
    mov rdx, 1695183700
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 148
    push rax
    pop rcx
    mov rdx, 1986661051
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 152
    push rax
    pop rcx
    mov rdx, 2177026350
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 156
    push rax
    pop rcx
    mov rdx, 2456956037
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 160
    push rax
    pop rcx
    mov rdx, 2730485921
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 164
    push rax
    pop rcx
    mov rdx, 2820302411
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 168
    push rax
    pop rcx
    mov rdx, 3259730800
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 172
    push rax
    pop rcx
    mov rdx, 3345764771
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 176
    push rax
    pop rcx
    mov rdx, 3516065817
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 180
    push rax
    pop rcx
    mov rdx, 3600352804
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 184
    push rax
    pop rcx
    mov rdx, 4094571909
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 188
    push rax
    pop rcx
    mov rdx, 275423344
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 192
    push rax
    pop rcx
    mov rdx, 430227734
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 196
    push rax
    pop rcx
    mov rdx, 506948616
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 200
    push rax
    pop rcx
    mov rdx, 659060556
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 204
    push rax
    pop rcx
    mov rdx, 883997877
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 208
    push rax
    pop rcx
    mov rdx, 958139571
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 212
    push rax
    pop rcx
    mov rdx, 1322822218
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 216
    push rax
    pop rcx
    mov rdx, 1537002063
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 220
    push rax
    pop rcx
    mov rdx, 1747873779
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 224
    push rax
    pop rcx
    mov rdx, 1955562222
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 228
    push rax
    pop rcx
    mov rdx, 2024104815
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 232
    push rax
    pop rcx
    mov rdx, 2227730452
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 236
    push rax
    pop rcx
    mov rdx, 2361852424
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 240
    push rax
    pop rcx
    mov rdx, 2428436474
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 244
    push rax
    pop rcx
    mov rdx, 2756734187
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 248
    push rax
    pop rcx
    mov rdx, 3204031479
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    add rax, 252
    push rax
    pop rcx
    mov rdx, 3329325298
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, 1
    mov [rel __g_macho_writer_mw_kready], rax
    mov rax, 0
    jmp .__ret_182
.__ret_182:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
mw_ror:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rax, r12
    mov rcx, rbx
    shr rax, cl
    push rax
    mov rax, 32
    sub rax, rbx
    mov rcx, rax
    mov rax, r12
    shl rax, cl
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    jmp .__ret_183
.__ret_183:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
mw_sha_block:
    push rbp
    mov rbp, rsp
    sub rsp, 272
    mov [rbp-240], rbx
    mov [rbp-232], r12
    mov [rbp-224], r13
    mov [rbp-216], r14
    mov [rbp-208], r15
    mov r12, rcx
    lea rax, [rel __g_macho_writer_mw_w]
    mov r15, rax
    mov rax, 0
    mov r14, rax
.L185:
    cmp r14, 16
    jge .L186
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    shl rax, 24
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    shl rax, 16
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    add rax, 2
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    shl rax, 8
    mov rcx, rax
    pop rax
    or rax, rcx
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r12
    add rax, rcx
    add rax, 3
    push rax
    pop rcx
    sub rsp, 32
    call mw_g8
    add rsp, 32
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rbx, rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    add r14, 1
.L187:
    jmp .L185
.L186:
.L188:
    cmp r14, 64
    jge .L189
    mov rax, r14
    sub rax, 15
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 7
    sub rsp, 32
    call mw_ror
    add rsp, 32
    push rax
    mov rcx, rbx
    mov rdx, 18
    sub rsp, 32
    call mw_ror
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    push rax
    mov rax, rbx
    shr rax, 3
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov r12, rax
    mov rax, r14
    sub rax, 2
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 17
    sub rsp, 32
    call mw_ror
    add rsp, 32
    push rax
    mov rcx, rbx
    mov rdx, 19
    sub rsp, 32
    call mw_ror
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    push rax
    mov rax, rbx
    shr rax, 10
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rbx, rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    mov rax, r14
    sub rax, 16
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    add rax, r12
    push rax
    mov rax, r14
    sub rax, 7
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    add rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    add r14, 1
.L190:
    jmp .L188
.L189:
    lea rax, [rel __g_macho_writer_mw_h]
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov r12, rax
    mov rax, r13
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov [rbp-88], rax
    mov rax, r13
    add rax, 8
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov [rbp-96], rax
    mov rax, r13
    add rax, 12
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov [rbp-104], rax
    mov rax, r13
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rbx, rax
    mov rax, r13
    add rax, 20
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov [rbp-120], rax
    mov rax, r13
    add rax, 24
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov [rbp-128], rax
    mov rax, r13
    add rax, 28
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov [rbp-136], rax
    mov rax, 0
    mov r14, rax
.L191:
    cmp r14, 64
    jge .L192
    mov rcx, rbx
    mov rdx, 6
    sub rsp, 32
    call mw_ror
    add rsp, 32
    push rax
    mov rcx, rbx
    mov rdx, 11
    sub rsp, 32
    call mw_ror
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    push rax
    mov rcx, rbx
    mov rdx, 25
    sub rsp, 32
    call mw_ror
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov [rbp-144], rax
    mov rax, rbx
    mov rcx, [rbp-120]
    and rax, rcx
    push rax
    mov rax, rbx
    mov rcx, 4294967295
    xor rax, rcx
    mov rcx, [rbp-128]
    and rax, rcx
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov [rbp-152], rax
    mov rax, [rbp-136]
    mov rcx, [rbp-144]
    add rax, rcx
    mov rcx, [rbp-152]
    add rax, rcx
    push rax
    lea rax, [rel __g_macho_writer_mw_k]
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r15
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    mov [rbp-160], rax
    mov rcx, r12
    mov rdx, 2
    sub rsp, 32
    call mw_ror
    add rsp, 32
    push rax
    mov rcx, r12
    mov rdx, 13
    sub rsp, 32
    call mw_ror
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    push rax
    mov rcx, r12
    mov rdx, 22
    sub rsp, 32
    call mw_ror
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov [rbp-168], rax
    mov rax, r12
    mov rcx, [rbp-88]
    and rax, rcx
    push rax
    mov rax, r12
    mov rcx, [rbp-96]
    and rax, rcx
    mov rcx, rax
    pop rax
    xor rax, rcx
    push rax
    mov rax, [rbp-88]
    mov rcx, [rbp-96]
    and rax, rcx
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov [rbp-176], rax
    mov rax, [rbp-168]
    mov rcx, [rbp-176]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    mov [rbp-184], rax
    mov rax, [rbp-128]
    mov [rbp-136], rax
    mov rax, [rbp-120]
    mov [rbp-128], rax
    mov rax, rbx
    mov [rbp-120], rax
    mov rax, [rbp-104]
    mov rcx, [rbp-160]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    mov rbx, rax
    mov rax, [rbp-96]
    mov [rbp-104], rax
    mov rax, [rbp-88]
    mov [rbp-96], rax
    mov rax, r12
    mov [rbp-88], rax
    mov rax, [rbp-160]
    mov rcx, [rbp-184]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    mov r12, rax
    add r14, 1
.L193:
    jmp .L191
.L192:
    mov rax, r13
    push rax
    mov rcx, r13
    sub rsp, 32
    call mw_g32
    add rsp, 32
    add rax, r12
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 4
    push rax
    mov rax, r13
    add rax, 4
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, [rbp-88]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 8
    push rax
    mov rax, r13
    add rax, 8
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, [rbp-96]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 12
    push rax
    mov rax, r13
    add rax, 12
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, [rbp-104]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 16
    push rax
    mov rax, r13
    add rax, 16
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    add rax, rbx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 20
    push rax
    mov rax, r13
    add rax, 20
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, [rbp-120]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 24
    push rax
    mov rax, r13
    add rax, 24
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, [rbp-128]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r13
    add rax, 28
    push rax
    mov rax, r13
    add rax, 28
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rcx, [rbp-136]
    add rax, rcx
    mov rcx, 4294967295
    and rax, rcx
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, 0
    jmp .__ret_184
.__ret_184:
    mov rbx, [rbp-240]
    mov r12, [rbp-232]
    mov r13, [rbp-224]
    mov r14, [rbp-216]
    mov r15, [rbp-208]
    mov rsp, rbp
    pop rbp
    ret
mw_sha256:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov rbx, rcx
    mov r12, rdx
    mov rax, [rel __g_macho_writer_mw_kready]
    cmp rax, 0
    jne .L195
    sub rsp, 32
    call mw_k_init
    add rsp, 32
    jmp .L196
.L195:
.L196:
    lea rax, [rel __g_macho_writer_mw_h]
    mov r14, rax
    mov rcx, r14
    mov rdx, 1779033703
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 4
    push rax
    pop rcx
    mov rdx, 3144134277
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 8
    push rax
    pop rcx
    mov rdx, 1013904242
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 12
    push rax
    pop rcx
    mov rdx, 2773480762
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 16
    push rax
    pop rcx
    mov rdx, 1359893119
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 20
    push rax
    pop rcx
    mov rdx, 2600822924
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 24
    push rax
    pop rcx
    mov rdx, 528734635
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, r14
    add rax, 28
    push rax
    pop rcx
    mov rdx, 1541459225
    sub rsp, 32
    call mw_p32
    add rsp, 32
    mov rax, rbx
    mov r13, rax
    mov rax, r12
    mov rbx, rax
.L197:
    cmp rbx, 64
    jl .L198
    mov rcx, r13
    sub rsp, 32
    call mw_sha_block
    add rsp, 32
    add r13, 64
    sub rbx, 64
.L199:
    jmp .L197
.L198:
    lea rax, [rel __g_macho_writer_mw_blk]
    mov r15, rax
    mov rcx, r15
    mov rdx, 128
    mov r8, 0
    sub rsp, 32
    call mw_fill
    add rsp, 32
    mov rcx, r15
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call mw_copy
    add rsp, 32
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    mov rdx, 128
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, 64
    mov r13, rax
    cmp rbx, 56
    jl .L200
    mov rax, 128
    mov r13, rax
    jmp .L201
.L200:
.L201:
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L202:
    cmp rbx, 8
    jge .L203
    mov rax, r15
    add rax, r13
    sub rax, 1
    sub rax, rbx
    push rax
    mov rax, r12
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, r12
    shr rax, 8
    mov r12, rax
    add rbx, 1
.L204:
    jmp .L202
.L203:
    mov rcx, r15
    sub rsp, 32
    call mw_sha_block
    add rsp, 32
    cmp r13, 128
    jne .L205
    mov rax, r15
    add rax, 64
    push rax
    pop rcx
    sub rsp, 32
    call mw_sha_block
    add rsp, 32
    jmp .L206
.L205:
.L206:
    lea rax, [rel __g_macho_writer_mw_digest]
    mov r13, rax
    mov rax, 0
    mov r12, rax
.L207:
    cmp r12, 8
    jge .L208
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r14
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call mw_g32
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    push rax
    mov rax, rbx
    shr rax, 24
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    add rax, 1
    push rax
    mov rax, rbx
    shr rax, 16
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    add rax, 2
    push rax
    mov rax, rbx
    shr rax, 8
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    mov rax, r12
    mov rcx, 4
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    add rax, 3
    push rax
    mov rax, rbx
    and rax, 255
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call mw_p8
    add rsp, 32
    add r12, 1
.L209:
    jmp .L207
.L208:
    mov rax, 0
    jmp .__ret_194
.__ret_194:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
