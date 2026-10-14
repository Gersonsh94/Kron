%line 1+1 codegen\codegen.asm
[global dbg_which]
[extern print_string]








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

%line 17+1 codegen\codegen.asm
[section .data]

hdr:
db "default rel", 10
db "bits 64", 10
db "global main", 10
db "extern ExitProcess", 10
db "extern GetStdHandle", 10
db "extern WriteFile", 10
db "extern CreateFileA", 10
db "extern CloseHandle", 10
db "extern ReadFile", 10
db "extern Beep", 10
db "extern SetConsoleMode", 10
db "extern ReadConsoleInputA", 10
db "section .bss", 10
db "__numbuf: resb 32", 10
db "__nwritten: resq 1", 10
db "__chbuf: resb 2", 10
db "__keybuf: resb 2", 10
db "__nread: resq 1", 10
db "__mousebuf: resb 32", 10
db "__mousex_v: resq 1", 10
db "__mousey_v: resq 1", 10
db "section .text", 10
db "__outname: db 'out.bmp', 0", 10
db "__save_file:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 104", 10
db "    mov rbx, rcx", 10
db "    mov rsi, rdx", 10
db "    mov rcx, r8", 10
db "    mov edx, 0x40000000", 10
db "    xor r8d, r8d", 10
db "    xor r9d, r9d", 10
db "    mov qword [rsp+32], 2", 10
db "    mov qword [rsp+40], 0x80", 10
db "    mov qword [rsp+48], 0", 10
db "    call CreateFileA", 10
db "    mov rdi, rax", 10
db "    mov rcx, rdi", 10
db "    mov rdx, rbx", 10
db "    mov r8, rsi", 10
db "    lea r9, [rel __nwritten]", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "    mov rcx, rdi", 10
db "    call CloseHandle", 10
db "    add rsp, 104", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10

db "__read_key:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 48", 10
db "    mov rcx, -10", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    lea rdx, [rel __keybuf]", 10
db "    mov r8, 1", 10
db "    lea r9, [rel __nread]", 10
db "    mov qword [rsp+32], 0", 10
db "    call ReadFile", 10
db "    xor rax, rax", 10
db "    mov al, [rel __keybuf]", 10
db "    add rsp, 48", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__read_mouse:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 40", 10
db "    mov rcx, -10", 10
db "    call GetStdHandle", 10
db "    mov rbx, rax", 10
db "    mov rcx, rbx", 10
db "    mov edx, 0x0090", 10
db "    call SetConsoleMode", 10
db "__rm_loop:", 10
db "    mov rcx, rbx", 10
db "    lea rdx, [rel __mousebuf]", 10
db "    mov r8, 1", 10
db "    lea r9, [rel __nread]", 10
db "    call ReadConsoleInputA", 10
db "    movzx eax, word [rel __mousebuf]", 10
db "    cmp eax, 2", 10
db "    jne __rm_loop", 10
db "    movzx eax, word [rel __mousebuf+4]", 10
db "    mov [rel __mousex_v], rax", 10
db "    movzx eax, word [rel __mousebuf+6]", 10
db "    mov [rel __mousey_v], rax", 10
db "    mov eax, [rel __mousebuf+8]", 10
db "    add rsp, 40", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__mousex_fn:", 10
db "    mov rax, [rel __mousex_v]", 10
db "    ret", 10
db "__mousey_fn:", 10
db "    mov rax, [rel __mousey_v]", 10
db "    ret", 10
db "__print_str:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 48", 10
db "    mov rbx, rcx", 10
db "    xor rsi, rsi", 10
db "__ps_len:", 10
db "    cmp byte [rbx+rsi], 0", 10
db "    je __ps_go", 10
db "    inc rsi", 10
db "    jmp __ps_len", 10
db "__ps_go:", 10
db "    test rsi, rsi", 10
db "    jz __ps_end", 10
db "    mov rcx, -11", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    mov rdx, rbx", 10
db "    mov r8, rsi", 10
db "    lea r9, [rel __nwritten]", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "__ps_end:", 10
db "    add rsp, 48", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_int:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 32", 10
db "    mov rax, rcx", 10
db "    xor r8, r8", 10
db "    test rax, rax", 10
db "    jns .pp", 10
db "    neg rax", 10
db "    mov r8, 1", 10
db ".pp:", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 10", 10
db "    dec rsi", 10
db "    mov rbx, 10", 10
db ".cv:", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec rsi", 10
db "    test rax, rax", 10
db "    jnz .cv", 10
db "    test r8, r8", 10
db "    jz .ns", 10
db "    mov byte [rsi], 45", 10
db "    dec rsi", 10
db ".ns:", 10
db "    inc rsi", 10
db "    lea rax, [rel __numbuf+32]", 10
db "    sub rax, rsi", 10
db "    mov rbx, rax", 10
db "    mov rcx, -11", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    mov rdx, rsi", 10
db "    mov r8, rbx", 10
db "    lea r9, [rel __nwritten]", 10
db "    sub rsp, 16", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "    add rsp, 16", 10
db "    add rsp, 32", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_float:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 40", 10
db "    xorps xmm1, xmm1", 10
db "    comisd xmm1, xmm0", 10
db "    jbe .fnoneg", 10
db "    movsd [rsp], xmm0", 10
db "    mov rcx, 45", 10
db "    call __print_char", 10
db "    movsd xmm0, [rsp]", 10
db "    mov rax, 0x8000000000000000", 10
db "    movq xmm2, rax", 10
db "    xorps xmm0, xmm2", 10
db ".fnoneg:", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    push rdx", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    pop rcx", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    mov rcx, 10", 10
db "    call __print_char", 10
db "    add rsp, 40", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_uint:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".ul:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .ul", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_pad:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pl:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec r10", 10
db "    test r10, r10", 10
db "    jnz .pl", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_char:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    sub rsp, 48", 10
db "    mov [rel __chbuf], cl", 10
db "    mov byte [rel __chbuf+1], 0", 10
db "    lea rcx, [rel __chbuf]", 10
db "    call __print_cstr", 10
db "    add rsp, 48", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_cstr:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    sub rsp, 48", 10
db "    mov rsi, rcx", 10
db "    xor rbx, rbx", 10
db ".cl:", 10
db "    cmp byte [rsi+rbx], 0", 10
db "    je .cd", 10
db "    inc rbx", 10
db "    jmp .cl", 10
db ".cd:", 10
db "    mov rcx, -11", 10
db "    call GetStdHandle", 10
db "    mov rcx, rax", 10
db "    mov rdx, rsi", 10
db "    mov r8, rbx", 10
db "    lea r9, [rel __nwritten]", 10
db "    sub rsp, 16", 10
db "    mov qword [rsp+32], 0", 10
db "    call WriteFile", 10
db "    add rsp, 16", 10
db "    add rsp, 48", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
hdr_len equ $ - hdr


hdrbare:
db "bits 64", 10
db "global kmain", 10
db "section .bss", 10
db "__numbuf: resb 32", 10
db "__vgapos: resq 1", 10
db "__chbuf: resb 2", 10
db "section .text", 10
db "__print_int:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    mov rax, rcx", 10
db "    xor r8, r8", 10
db "    test rax, rax", 10
db "    jns .bpp", 10
db "    neg rax", 10
db "    mov r8, 1", 10
db ".bpp:", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    dec rsi", 10
db "    mov rbx, 10", 10
db ".bcv:", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec rsi", 10
db "    test rax, rax", 10
db "    jnz .bcv", 10
db "    test r8, r8", 10
db "    jz .bns", 10
db "    mov byte [rsi], 45", 10
db "    dec rsi", 10
db ".bns:", 10
db "    inc rsi", 10
db "    mov rcx, rsi", 10
db "    call __print_str", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_str:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    push rdi", 10
db "    mov rsi, rcx", 10
db "    mov rdi, 0xB8000", 10
db "    add rdi, [rel __vgapos]", 10
db ".bsl:", 10
db "    mov al, [rsi]", 10
db "    test al, al", 10
db "    jz .bsd", 10
db "    cmp al, 10", 10
db "    jne .bsc", 10
db "    mov rax, [rel __vgapos]", 10
db "    add rax, 160", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 160", 10
db "    div rbx", 10
db "    imul rax, rbx", 10
db "    mov [rel __vgapos], rax", 10
db "    mov rdi, 0xB8000", 10
db "    add rdi, rax", 10
db "    inc rsi", 10
db "    jmp .bsl", 10
db ".bsc:", 10
db "    mov [rdi], al", 10
db "    mov byte [rdi+1], 0x0F", 10
db "    add rdi, 2", 10
db "    add qword [rel __vgapos], 2", 10
db "    inc rsi", 10
db "    jmp .bsl", 10
db ".bsd:", 10
db "    pop rdi", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_float:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    sub rsp, 40", 10
db "    xorps xmm1, xmm1", 10
db "    comisd xmm1, xmm0", 10
db "    jbe .fnoneg", 10
db "    movsd [rsp], xmm0", 10
db "    mov rcx, 45", 10
db "    call __print_char", 10
db "    movsd xmm0, [rsp]", 10
db "    mov rax, 0x8000000000000000", 10
db "    movq xmm2, rax", 10
db "    xorps xmm0, xmm2", 10
db ".fnoneg:", 10
db "    mov rax, 1000000", 10
db "    cvtsi2sd xmm1, rax", 10
db "    mulsd xmm0, xmm1", 10
db "    cvtsd2si rax, xmm0", 10
db "    xor rdx, rdx", 10
db "    mov rbx, 1000000", 10
db "    div rbx", 10
db "    push rdx", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 46", 10
db "    call __print_char", 10
db "    pop rcx", 10
db "    mov r10, 6", 10
db "    call __print_pad", 10
db "    mov rcx, 10", 10
db "    call __print_char", 10
db "    add rsp, 40", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_uint:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".ul:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .ul", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_pad:", 10
db "    push rbp", 10
db "    mov rbp, rsp", 10
db "    push rbx", 10
db "    push rsi", 10
db "    sub rsp, 40", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pl:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec r10", 10
db "    test r10, r10", 10
db "    jnz .pl", 10
db "    mov rcx, rsi", 10
db "    call __print_cstr", 10
db "    add rsp, 40", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    mov rsp, rbp", 10
db "    pop rbp", 10
db "    ret", 10
db "__print_char:", 10
db "    mov [rel __chbuf], cl", 10
db "    mov byte [rel __chbuf+1], 0", 10
db "    lea rcx, [rel __chbuf]", 10
db "    call __print_str", 10
db "    ret", 10
db "__print_cstr:", 10
db "    jmp __print_str", 10
hdrbare_len equ $ - hdrbare


hdrelf:
db "bits 64", 10
db "global _start", 10
db "section .bss", 10
db "__numbuf: resb 32", 10
db "__chbuf: resb 2", 10
db "section .text", 10
db "__print_str:", 10
db "    mov rdi, rcx", 10
db "    jmp __print_cstr", 10
db "__print_cstr:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    mov rsi, rdi", 10
db "    xor rbx, rbx", 10
db ".cl:", 10
db "    cmp byte [rsi+rbx], 0", 10
db "    je .cd", 10
db "    inc rbx", 10
db "    jmp .cl", 10
db ".cd:", 10
db "    mov rax, 1", 10
db "    mov rdi, 1", 10
db "    mov rdx, rbx", 10
db "    syscall", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_char:", 10
db "    mov [rel __chbuf], cl", 10
db "    mov byte [rel __chbuf+1], 0", 10
db "    lea rdi, [rel __chbuf]", 10
db "    call __print_cstr", 10
db "    ret", 10
db "__print_uint:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".ul:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    test rax, rax", 10
db "    jnz .ul", 10
db "    mov rdi, rsi", 10
db "    call __print_cstr", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_pad:", 10
db "    push rbx", 10
db "    push rsi", 10
db "    mov rax, rcx", 10
db "    lea rsi, [rel __numbuf+31]", 10
db "    mov byte [rsi], 0", 10
db "    mov rbx, 10", 10
db ".pl:", 10
db "    dec rsi", 10
db "    xor rdx, rdx", 10
db "    div rbx", 10
db "    add dl, 48", 10
db "    mov [rsi], dl", 10
db "    dec r10", 10
db "    test r10, r10", 10
db "    jnz .pl", 10
db "    mov rdi, rsi", 10
db "    call __print_cstr", 10
db "    pop rsi", 10
db "    pop rbx", 10
db "    ret", 10
db "__print_int:", 10
db "    push rbx", 10
db "    mov rax, rcx", 10
db "    test rax, rax", 10
db "    jns .ip", 10
db "    push rax", 10
db "    mov rcx, 45", 10
db "    call __print_char", 10
db "    pop rax", 10
db "    neg rax", 10
db ".ip:", 10
db "    mov rcx, rax", 10
db "    call __print_uint", 10
db "    mov rcx, 10", 10
db "    call __print_char", 10
db "    pop rbx", 10
db "    ret", 10
hdrelf_len equ $ - hdrelf



s_pushrbp: db "    push rbp", 10, 0
s_movrbp: db "    mov rbp, rsp", 10, 0
s_subrsp: db "    sub rsp, ", 0
s_movrsprbp: db "    mov rsp, rbp", 10, 0
s_poprbp: db "    pop rbp", 10, 0
s_ret: db "    ret", 10, 0
s_nl: db 10, 0
s_colon_nl: db ":", 10, 0
s_global_kw: db "global ", 0
s_colon: db ":", 0
s_boot_pref: db "__boot_", 0
s_mov_ind: db "    mov ", 0
s_comma_sp: db ", ", 0
s_ret_ind: db "    ret", 10, 0
s_mmu_pref: db "__mmu_", 0
s_mmu_lv: db "_levels", 0
s_isr_pref: db "__isr_", 0
s_isrvec_pref: db "__isrvec_", 0
s_iretq: db "    iretq", 10, 0
s_cfg_pref: db "__cfg_", 0
s_cfg_k: db "__cfgk", 0
s_cfg_v: db "__cfgv", 0
s_cfg_keys: db "_keys", 0
s_cfg_txts: db "_texts", 0
s_cfg_nums: db "_nums", 0
s_cfg_type: db "_type", 0
s_sched_pref: db "__sched_", 0
s_sched_sw: db "_switch", 0
s_sys_pref: db "__sys_", 0
s_svc_pref: db "__svc_", 0
s_sys_tbl: db "_table", 0
s_sysretq: db "    o64 sysret", 10, 0
s_ind4: db "    ", 0
s_push_rax: db "    push rax", 10, 0
s_outb_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov al, cl", 10, "    out dx, al", 10, 0
s_inb_seq: db "    mov rdx, rax", 10, "    xor rax, rax", 10, "    in al, dx", 10, 0
s_poke_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], rcx", 10, 0
s_save_seq: db "    mov rdx, rax", 10, "    pop rcx", 10, "    pop r8", 10, "    sub rsp, 32", 10, "    call __save_file", 10, "    add rsp, 32", 10, 0
s_readkey: db "    sub rsp, 32", 10, "    call __read_key", 10, "    add rsp, 32", 10, 0
s_beep_seq: db "    mov rdx, rax", 10, "    pop rcx", 10, "    sub rsp, 32", 10, "    call Beep", 10, "    add rsp, 32", 10, 0
s_readmouse: db "    sub rsp, 32", 10, "    call __read_mouse", 10, "    add rsp, 32", 10, 0
s_mousex: db "    sub rsp, 32", 10, "    call __mousex_fn", 10, "    add rsp, 32", 10, 0
s_mousey: db "    sub rsp, 32", 10, "    call __mousey_fn", 10, "    add rsp, 32", 10, 0
s_peek_seq: db "    mov rax, [rax]", 10, 0

s_idx_rcx: db "    mov rcx, rax", 10, 0
s_idx_pop: db "    pop rcx", 10, 0
s_lea_loc: db "    lea rdx, [rbp-", 0
s_lea_loc2: db "]", 10, 0
s_lea_glbp: db "    lea rdx, [rel __g_", 0
s_lea_glbs: db "]", 10, 0
s_rd_i: db "    mov rax, [rdx+rcx*8]", 10, 0
s_rd_f: db "    movsd xmm0, [rdx+rcx*8]", 10, 0
s_wr_i: db "    mov [rdx+rcx*8], rax", 10, 0
s_wr_f: db "    movsd [rdx+rcx*8], xmm0", 10, 0
s_idx_pre: db "    mov rcx, rax", 10, "    lea rdx, [rbp-", 0
s_idx_read: db "]", 10, "    mov rax, [rdx+rcx*8]", 10, 0
s_idx_readf: db "]", 10, "    movsd xmm0, [rdx+rcx*8]", 10, 0
s_idx_wrf: db "]", 10, "    movsd [rdx+rcx*8], xmm0", 10, 0
s_idx_wrf1: db "    pop rcx", 10, "    lea rdx, [rbp-", 0

s_idx_wr1: db "    pop rcx", 10, "    lea rdx, [rbp-", 0
s_idx_wr2: db "]", 10, "    mov [rdx+rcx*8], rax", 10, 0
s_addr_pre: db "    lea rax, [rbp-", 0
s_addr_post: db "]", 10, 0

s_ld1_pre: db "    movzx rax, byte [rbp-", 0
s_ld2_pre: db "    movzx rax, word [rbp-", 0
s_ld4_pre: db "    mov eax, dword [rbp-", 0
s_ld8_pre: db "    mov rax, [rbp-", 0
s_st1_suf: db "], al", 10, 0
s_st2_suf: db "], ax", 10, 0
s_st4_suf: db "], eax", 10, 0
s_st8_suf: db "], rax", 10, 0
s_imul_pre: db "    imul rax, rax, ", 0

s_flt_lbl: db ".flt", 0
s_flt_dq: db ": dq ", 0
s_ld_flt: db "    movsd xmm0, [rel .flt", 0
s_closebrk: db "]", 10, 0
s_str_lbl: db ".str", 0
s_str_db: db ": db ", 0
s_str_zero: db "0", 10, 0
s_comma: db ",", 0
s_lea_str: db "    lea rax, [rel .str", 0
s_prints: db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __print_str", 10, "    add rsp, 32", 10, 0
s_ld_xmm_pre: db "    movsd xmm0, [rbp-", 0
s_st_xmm_pre: db "    movsd [rbp-", 0
s_st_xmm_suf: db "], xmm0", 10, 0
s_push_xmm: db "    sub rsp, 8", 10, "    movsd [rsp], xmm0", 10, 0
s_pop_xmm1: db "    movsd xmm1, xmm0", 10, "    movsd xmm0, [rsp]", 10, "    add rsp, 8", 10, 0
s_addsd: db "    addsd xmm0, xmm1", 10, 0
s_subsd: db "    subsd xmm0, xmm1", 10, 0
s_mulsd: db "    mulsd xmm0, xmm1", 10, 0
s_divsd: db "    divsd xmm0, xmm1", 10, 0
s_cvt_i2d: db "    cvtsi2sd xmm0, rax", 10, 0
s_zero_xmm: db "    xorps xmm0, xmm0", 10, 0
s_printf: db "    call __print_float", 10, 0

s_glb_pre: db "__g_", 0
s_glb_times: db ": times ", 0
s_glb_dq0: db " dq 0", 10, 0
s_lea_glb: db "    lea rax, [rel __g_", 0
s_lea_fn: db "    lea rax, [rel ", 0
s_ldg_pre: db "    mov rax, [rel __g_", 0
s_stg_pre: db "    mov [rel __g_", 0
s_stg_suf: db "], rax", 10, 0

s_dbg_oom: db "[DBG] OOM emit_bytes", 10, 0
s_dbg_full: db "[DBG] FULL cg_add_var", 10, 0
s_movmem_pre: db "    mov [rbp-", 0
s_movmem_mid: db "], ", 0
s_argreg0: db "rcx", 0
s_argreg1: db "rdx", 0
s_argreg2: db "r8", 0
s_argreg3: db "r9", 0
s_fmovmem: db "    movsd [rbp-", 0
s_fmovmid: db "], xmm", 0
s_fargreg0: db "xmm0", 0
s_fargreg1: db "xmm1", 0
s_fargreg2: db "xmm2", 0
s_fargreg3: db "xmm3", 0
s_fpush: db "    sub rsp, 8", 10, "    movsd [rsp], xmm0", 10, 0
s_fpop_pre: db "    movsd xmm", 0
s_fpop_suf: db ", [rsp]", 10, "    add rsp, 8", 10, 0
s_poparg0: db "    pop rcx", 10, 0
s_poparg1: db "    pop rdx", 10, 0
s_poparg2: db "    pop r8", 10, 0
s_poparg3: db "    pop r9", 10, 0
s_poparg4: db "    pop r10", 10, 0
s_poparg5: db "    pop rax", 10, 0
s_argreg4: db "r10", 0
s_argreg5: db "rax", 0
s_fargreg4: db "xmm4", 0
s_fargreg5: db "xmm5", 0
s_shadow_sub: db "    sub rsp, 32", 10, 0
s_shadow_add: db "    add rsp, 32", 10, 0
s_pop_r11: db "    pop r11", 10, 0
s_call_r11: db "    call r11", 10, 0
s_poke8_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], cl", 10, 0
s_poke16_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], cx", 10, 0
s_poke32_seq: db "    mov rcx, rax", 10, "    pop rdx", 10, "    mov [rdx], ecx", 10, 0
s_peek8_seq: db "    movzx rax, byte [rax]", 10, 0
s_peek16_seq: db "    movzx rax, word [rax]", 10, 0
s_peek32_seq: db "    mov eax, dword [rax]", 10, 0
s_underscore: db "_", 0
s_isa_str: db "__isa_s", 0
s_isa_pref: db "__isa_", 0
s_isa_cnt: db "_count", 0
s_isa_ops: db "_opcodes", 0
s_isa_nms: db "_names", 0
s_dq_ind: db "    dq ", 0
s_dq_sp: db " dq ", 0
s_movrax_imm: db "    mov rax, ", 0
s_pushrax: db "    push rax", 10, 0
s_poprax: db "    pop rax", 10, 0
s_movrcxrax: db "    mov rcx, rax", 10, 0
s_movraxmem: db "    mov rax, [rbp-", 0
s_closemem: db "]", 10, 0
s_movmemrax: db "    mov [rbp-", 0
s_movmemrax2: db "], rax", 10, 0
s_add: db "    add rax, rcx", 10, 0
s_sub: db "    sub rax, rcx", 10, 0
s_imul: db "    imul rax, rcx", 10, 0
s_idiv: db "    cqo", 10, "    idiv rcx", 10, 0
s_imod: db "    cqo", 10, "    idiv rcx", 10, "    mov rax, rdx", 10, 0
s_shl: db "    shl rax, cl", 10, 0
s_shr: db "    sar rax, cl", 10, 0
s_neg: db "    neg rax", 10, 0
s_cmp: db "    cmp rax, rcx", 10, 0
s_sete: db "    sete al", 10, "    movzx rax, al", 10, 0
s_setne: db "    setne al", 10, "    movzx rax, al", 10, 0
s_setl: db "    setl al", 10, "    movzx rax, al", 10, 0
s_setg: db "    setg al", 10, "    movzx rax, al", 10, 0
s_setle: db "    setle al", 10, "    movzx rax, al", 10, 0
s_setge: db "    setge al", 10, "    movzx rax, al", 10, 0
s_fcmp: db "    ucomisd xmm0, xmm1", 10, 0
s_fseta: db "    seta al", 10, "    movzx rax, al", 10, 0
s_fsetae: db "    setae al", 10, "    movzx rax, al", 10, 0
s_fsetb: db "    setb al", 10, "    movzx rax, al", 10, 0
s_fsetbe: db "    setbe al", 10, "    movzx rax, al", 10, 0
s_fsete: db "    sete al", 10, "    movzx rax, al", 10, 0
s_fsetne: db "    setne al", 10, "    movzx rax, al", 10, 0
s_print: db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __print_int", 10, "    add rsp, 32", 10, 0
s_printc: db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call __print_char", 10, "    add rsp, 32", 10, 0
s_trunc: db "    cvttsd2si rax, xmm0", 10, 0
s_call: db "    call ", 0
s_jmp: db "    jmp ", 0
s_jz: db "    test rax, rax", 10, "    jz ", 0
s_jnz: db "    test rax, rax", 10, "    jnz ", 0
s_setnz01: db "    test rax, rax", 10, "    setnz al", 10, "    movzx rax, al", 10, 0
s_mov_rax0: db "    mov rax, 0", 10, 0
s_mov_rax1: db "    mov rax, 1", 10, 0
s_label_L: db ".L", 0
s_retmain: db "    mov rcx, rax", 10, "    sub rsp, 32", 10, "    call ExitProcess", 10, 0
s_retlbl: db ".__ret_", 0
s_jmpret: db "    jmp .__ret_", 0

s_sec_data: db "section .data", 10, 0
s_sec_bss: db "section .bss", 10, 0
s_glb_resq: db ": resq ", 0
s_sec_text: db "section .text", 10, 0
s_mod_pref: db "__mod_", 0
s_mod_anon: db "anon", 0
s_us: db "_", 0
s_db_q: db "    db ", 34, 0
s_q0_nl: db 34, ",0", 10, 0
s_zero: db "0", 0
s_syscall: db "    syscall", 10, 0
s_pop_rax: db "    pop rax", 10, 0
s_pop_rdi: db "    pop rdi", 10, 0
s_pop_rsi: db "    pop rsi", 10, 0
s_pop_rdx: db "    pop rdx", 10, 0
s_pop_r10: db "    pop r10", 10, 0
s_pop_r8: db "    pop r8", 10, 0
s_pop_r9: db "    pop r9", 10, 0

[section .bss]
 cg_out resq 1
 cg_ptr resq 1
 cg_end resq 1
 cg_label resd 1
 dbg_which resb 1
 cg_had_error resb 1
 cg_pad_guard resb 64

 var_toks resq 1024
 var_offs resd 1024
 cg_bare resb 1
 cg_target resb 1

 struct_toks resq 256
 struct_first resd 256
 struct_nfield resd 256
 struct_count resd 1
 field_toks resq 4096
 field_sizes resd 4096
 field_isfloat resd 4096
 field_offs resd 4096
 struct_bytes resd 256
 field_count resd 1
 var_structs resd 1024
 var_elemsz resd 1024
 var_isfloat resd 1024
 pending_float resd 1

 g_toks resq 512
 g_isfloat resd 512
 g_count resd 1

 fn_toks resq 512
 fn_ret_float resd 512
 fn_count resd 1
 pending_elem resd 1
 pending_struct resd 1
 var_count resd 1
 cur_ret_id resd 1

[section .text]
[global jup_codegen_init]
[global jup_codegen_run]
[global jup_codegen_set_target]
[global codegen_get_code]
[global codegen_get_code_size]




jup_codegen_init:
 mov [rel cg_out], rdi
 mov [rel cg_ptr], rdi
 mov rax, rdi
 add rax, rsi
 mov [rel cg_end], rax
 xor eax, eax
 mov [rel cg_label], eax
 mov [rel var_count], eax
 mov [rel cur_ret_id], eax
 mov byte [rel cg_had_error], 0
 ret




emit_bytes:
 push rcx
 mov rax, [rel cg_ptr]
 mov rcx, rax
 add rcx, rdx
 cmp rcx, [rel cg_end]
 ja .oom
.copy:
 test rdx, rdx
 jz .done
 mov cl, [rsi]
 mov [rax], cl
 inc rsi
 inc rax
 dec rdx
 jmp .copy
.done:
 mov [rel cg_ptr], rax
 pop rcx
 ret
.oom:
 mov byte [rel cg_had_error], 1
 mov byte [rel dbg_which], 1
 pop rcx
 ret


emit_cstr:
 push rdx
 push rsi
 xor rdx, rdx
.len:
 cmp byte [rsi], 0
 je .go
 inc rsi
 inc rdx
 jmp .len
.go:
 pop rsi
 call emit_bytes
 pop rdx
 ret


emit_tok:
 push rdx
 push rsi
 mov rsi, [rdi + 8]
 mov edx, dword [rdi + 16]
 call emit_bytes
 pop rsi
 pop rdx
 ret


emit_tok_raw:
 push rdx
 push rsi
 mov rsi, [rdi + 8]
 mov edx, dword [rdi + 16]
 cmp edx, 2
 jbe .empty
 cmp byte [rsi], '"'
 jne .plain
 inc rsi
 sub edx, 2
.plain:
 call emit_bytes
.empty:
 pop rsi
 pop rdx
 ret


emit_uint:
 push rbx
 push rsi
 sub rsp, 32
 mov rax, rdi
 lea rsi, [rsp+31]
 mov byte [rsi], 0
 mov rbx, 10
 test rax, rax
 jnz .cv
 dec rsi
 mov byte [rsi], '0'
 jmp .emit
.cv:
 dec rsi
 xor rdx, rdx
 div rbx
 add dl, '0'
 mov [rsi], dl
 test rax, rax
 jnz .cv
.emit:
 call emit_cstr
 add rsp, 32
 pop rsi
 pop rbx
 ret


new_label:
 mov eax, [rel cg_label]
 inc dword [rel cg_label]
 ret







cg_add_var:
 test rsi, rsi
 jnz .have_n
 mov rsi, 1
.have_n:



 push rsi
 push rdi
 call cg_find_var_idx
 pop rdi
 pop rsi
 cmp eax, -1
 je .fresh


 mov ecx, eax
 lea r9, [rel var_structs]
 mov r11d, [rel pending_struct]
 mov [r9 + rcx*4], r11d
 mov dword [rel pending_struct], -1
 lea r9, [rel var_elemsz]
 mov r11d, [rel pending_elem]
 mov [r9 + rcx*4], r11d
 mov dword [rel pending_elem], 0
 lea r9, [rel var_isfloat]
 mov r11d, [rel pending_float]
 mov [r9 + rcx*4], r11d
 mov dword [rel pending_float], 0
 lea r9, [rel var_offs]
 mov eax, [r9 + rcx*4]
 ret
.fresh:
 mov eax, [rel var_count]
 cmp eax, 1024
 jae .full
 mov ecx, eax

 lea r9, [rel var_offs]
 xor edx, edx
 test ecx, ecx
 jz .first
 mov edx, [r9 + rcx*4 - 4]
.first:

 mov r10d, esi
 shl r10d, 3
 add edx, r10d

 lea r8, [rel var_toks]
 mov [r8 + rcx*8], rdi
 mov [r9 + rcx*4], edx

 lea r8, [rel var_structs]
 mov r11d, [rel pending_struct]
 mov [r8 + rcx*4], r11d
 mov dword [rel pending_struct], -1
 lea r8, [rel var_elemsz]
 mov r11d, [rel pending_elem]
 mov [r8 + rcx*4], r11d
 mov dword [rel pending_elem], 0
 lea r8, [rel var_isfloat]
 mov r11d, [rel pending_float]
 mov [r8 + rcx*4], r11d
 mov dword [rel pending_float], 0

 inc eax
 mov [rel var_count], eax
 mov eax, edx
 ret
.full:
 mov byte [rel cg_had_error], 1
 mov byte [rel dbg_which], 2
 xor eax, eax
 ret




cg_emit_idx_base:
 push r12
 mov r12, rdi
 call cg_find_var_idx
 cmp eax, -1
 je .glob

 mov rsi, s_lea_loc
 call emit_cstr
 mov rdi, r12
 call cg_find_var
 mov edi, eax
 call emit_uint
 mov rsi, s_lea_loc2
 call emit_cstr
 jmp .done
.glob:

 mov rsi, s_lea_glbp
 call emit_cstr
 mov rdi, r12
 call emit_tok
 mov rsi, s_lea_glbs
 call emit_cstr
.done:
 pop r12
 ret


cg_find_var:
 push rbx
 push r12
 push r13
 push r14
 mov r12, rdi
 mov r13d, [rel var_count]


 mov r14d, r13d
 dec r14d
.loop:
 test r14d, r14d
 js .notfound
 lea rbx, [rel var_toks]
 mov rbx, [rbx + r14*8]
 mov rdi, r12
 mov rsi, rbx
 call tok_equal
 test rax, rax
 jnz .found
 dec r14d
 jmp .loop
.found:
 lea r9, [rel var_offs]
 mov eax, [r9 + r14*4]
 jmp .ret
.notfound:
 xor eax, eax
.ret:
 pop r14
 pop r13
 pop r12
 pop rbx
 ret


tok_equal:
 push rbx
 mov eax, dword [rdi + 16]
 mov ebx, dword [rsi + 16]
 cmp eax, ebx
 jne .no
 mov r8, [rdi + 8]
 mov r9, [rsi + 8]
 xor rcx, rcx
.cmp:
 cmp ecx, eax
 jae .yes
 mov dl, [r8 + rcx]
 cmp dl, [r9 + rcx]
 jne .no
 inc rcx
 jmp .cmp
.yes:
 mov rax, 1
 pop rbx
 ret
.no:
 xor rax, rax
 pop rbx
 ret


name_is_main:
 mov eax, dword [rdi + 16]
 cmp eax, 4
 jne .no
 mov r8, [rdi + 8]
 cmp byte [r8+0], 'm'
 jne .no
 cmp byte [r8+1], 'a'
 jne .no
 cmp byte [r8+2], 'i'
 jne .no
 cmp byte [r8+3], 'n'
 jne .no
 mov rax, 1
 ret
.no:
 xor rax, rax
 ret

jup_codegen_set_target:
 mov [rel cg_target], dil

 cmp dil, 3
 je .freestanding
 cmp dil, 2
 je .freestanding
 mov byte [rel cg_bare], 0
 ret
.freestanding:
 mov byte [rel cg_bare], 1
 ret




jup_codegen_run:
 push r12
 mov r12, rdi
 mov dword [rel pending_struct], -1

 mov al, [rel cg_target]
 cmp al, 1
 je .elf_hdr
 cmp byte [rel cg_bare], 0
 jne .bare_hdr
 lea rsi, [rel hdr]
 mov rdx, hdr_len
 call emit_bytes
 jmp .hdr_done
.elf_hdr:
 lea rsi, [rel hdrelf]
 mov rdx, hdrelf_len
 call emit_bytes
 jmp .hdr_done
.bare_hdr:
 lea rsi, [rel hdrbare]
 mov rdx, hdrbare_len
 call emit_bytes
.hdr_done:

 mov dword [rel fn_count], 0
 mov rdi, r12
.prepass:
 test rdi, rdi
 jz .prepass_done
 mov rax, [rdi + 0]
 cmp rax, 1000
 jne .prepass_done
 mov rcx, [rdi + 8]
 test rcx, rcx
 jz .pp_next
 mov rax, [rcx + 0]
 cmp rax, 1001
 jne .pp_next
 mov rax, [rcx + 24]
 test rax, rax
 jz .pp_next
 mov ecx, [rel fn_count]
 cmp ecx, 512
 jae .pp_next
 lea rdx, [rel fn_toks]
 mov [rdx + rcx*8], rax

 push rcx
 mov rax, [rdi + 8]
 movzx eax, word [rax + 38]
 lea rdx, [rel fn_ret_float]
 mov [rdx + rcx*4], eax
 pop rcx
 inc ecx
 mov [rel fn_count], ecx
.pp_next:
 mov rdi, [rdi + 16]
 jmp .prepass
.prepass_done:

 mov rdi, r12
 call cg_walk_top
 cmp byte [rel cg_had_error], 0
 jne .err
 mov rax, 1
 pop r12
 ret
.err:
 movzx eax, byte [rel dbg_which]
 neg eax
 pop r12
 ret


cg_walk_top:
 push r12
 mov r12, rdi
.loop:
 test r12, r12
 jz .done
 mov rax, [r12 + 0]
 cmp rax, 1000
 jne .done
 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .next
 mov rax, [rdi + 0]
 cmp rax, 1001
 je .fn
 cmp rax, 1024
 je .mod
 cmp rax, 1020
 je .structdef
 cmp rax, 1003
 je .globaldecl
 cmp rax, 1004
 je .globaldecl
 cmp rax, 1030
 je .isa
 cmp rax, 1032
 je .boot
 cmp rax, 1034
 je .mmu
 cmp rax, 1036
 je .isr
 cmp rax, 1037
 je .cfg
 cmp rax, 1039
 je .sched
 cmp rax, 1040
 je .sys
 jmp .next
.fn:
 call cg_function
 jmp .next
.structdef:
 call cg_register_struct
 jmp .next
.globaldecl:
 call cg_global_decl
 jmp .next
.isa:
 call cg_isa
 jmp .next
.boot:
 call cg_boot
 jmp .next
.mmu:
 call cg_mmu
 jmp .next
.isr:
 call cg_isr_routine
 jmp .next
.cfg:
 call cg_config
 jmp .next
.sched:
 call cg_sched
 jmp .next
.sys:
 call cg_sys
 jmp .next
.mod:
 call cg_module
.next:
 mov r12, [r12 + 16]
 jmp .loop
.done:
 pop r12
 ret










cg_isa:
 push r12
 push r13
 push r14
 mov r12, rdi

 mov rsi, s_sec_data
 call emit_cstr


 mov r13, [r12 + 16]
.p1:
 test r13, r13
 jz .p1_end
 call new_label
 mov eax, eax
 mov [r13 + 40], rax
 mov rsi, s_isa_str
 call emit_cstr
 mov edi, dword [r13 + 40]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_db_q
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 mov rsi, s_q0_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .p1
.p1_end:


 xor r14d, r14d
 mov r13, [r12 + 16]
.cnt:
 test r13, r13
 jz .cnt_end
 inc r14d
 mov r13, [r13 + 16]
 jmp .cnt
.cnt_end:


 mov rsi, s_global_kw
 call emit_cstr
 call .emit_base
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .emit_base
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_colon
 call emit_cstr
 mov rsi, s_dq_sp
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr


 mov rsi, s_global_kw
 call emit_cstr
 call .emit_base
 mov rsi, s_isa_ops
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .emit_base
 mov rsi, s_isa_ops
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr
 mov r13, [r12 + 16]
.p2:
 test r13, r13
 jz .p2_end
 mov rsi, s_dq_ind
 call emit_cstr
 mov rdi, [r13 + 8]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .p2
.p2_end:


 mov rsi, s_global_kw
 call emit_cstr
 call .emit_base
 mov rsi, s_isa_nms
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .emit_base
 mov rsi, s_isa_nms
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr
 mov r13, [r12 + 16]
.p3:
 test r13, r13
 jz .p3_end
 mov rsi, s_dq_ind
 call emit_cstr
 mov rsi, s_isa_str
 call emit_cstr
 mov edi, dword [r13 + 40]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .p3
.p3_end:

 pop r14
 pop r13
 pop r12
 ret


.emit_base:
 mov rsi, s_isa_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 ret










cg_boot:
 push r12
 push r13
 mov r12, rdi

 mov rsi, s_sec_text
 call emit_cstr

 mov rsi, s_global_kw
 call emit_cstr
 mov rsi, s_boot_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr

 mov rsi, s_boot_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_colon_nl
 call emit_cstr

 mov r13, [r12 + 16]
.loop:
 test r13, r13
 jz .done
 mov rsi, s_mov_ind
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 mov rsi, s_comma_sp
 call emit_cstr
 mov rdi, [r13 + 8]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .loop
.done:
 mov rsi, s_ret_ind
 call emit_cstr
 pop r13
 pop r12
 ret







cg_mmu:
 push r12
 push r13
 push r14
 mov r12, rdi

 mov rsi, s_sec_data
 call emit_cstr

 xor r14d, r14d
 mov r13, [r12 + 16]
.cnt:
 test r13, r13
 jz .cnt_end
 inc r14d
 mov r13, [r13 + 16]
 jmp .cnt
.cnt_end:

 mov rsi, s_global_kw
 call emit_cstr
 call .mbase
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .mbase
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_colon
 call emit_cstr
 mov rsi, s_dq_sp
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rsi, s_global_kw
 call emit_cstr
 call .mbase
 mov rsi, s_mmu_lv
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .mbase
 mov rsi, s_mmu_lv
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr

 mov r13, [r12 + 16]
.p:
 test r13, r13
 jz .p_end
 mov rsi, s_dq_ind
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 mov rsi, s_comma_sp
 call emit_cstr
 mov rdi, [r13 + 8]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .p
.p_end:
 pop r14
 pop r13
 pop r12
 ret

.mbase:
 mov rsi, s_mmu_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 ret











cg_isr_routine:
 push r12
 push r13
 push r14
 mov r12, rdi


 mov rax, [r12 + 8]
 test rax, rax
 jz .no_vec
 mov rsi, s_sec_data
 call emit_cstr
 mov rsi, s_global_kw
 call emit_cstr
 mov rsi, s_isrvec_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_isrvec_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_colon
 call emit_cstr
 mov rsi, s_dq_sp
 call emit_cstr
 mov rdi, [r12 + 8]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
.no_vec:

 mov rsi, s_sec_text
 call emit_cstr


 xor eax, eax
 mov [rel var_count], eax
 call new_label
 mov [rel cur_ret_id], eax
 mov r14d, eax


 mov rdi, [r12 + 16]
 call cg_count_vars
 mov ecx, eax
 shl ecx, 3
 add ecx, 32
 add ecx, 15
 and ecx, -16
 mov r13d, ecx

 mov rsi, s_global_kw
 call emit_cstr
 mov rsi, s_isr_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr

 mov rsi, s_isr_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_pushrbp
 call emit_cstr
 mov rsi, s_movrbp
 call emit_cstr
 mov rsi, s_subrsp
 call emit_cstr
 mov edi, r13d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr


 mov rdi, [r12 + 16]
 call cg_emit


 mov rsi, s_retlbl
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_movrsprbp
 call emit_cstr
 mov rsi, s_poprbp
 call emit_cstr
 mov rsi, s_iretq
 call emit_cstr

 pop r14
 pop r13
 pop r12
 ret









cg_config:
 push r12
 push r13
 push r14
 mov r12, rdi

 mov rsi, s_sec_data
 call emit_cstr


 mov r13, [r12 + 16]
.s1:
 test r13, r13
 jz .s1_end
 cmp qword [r13 + 40], 0xFFFF
 je .s1_next
 call new_label
 mov eax, eax
 mov [r13 + 32], rax
 mov rsi, s_cfg_k
 call emit_cstr
 mov edi, dword [r13 + 32]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_db_q
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 mov rsi, s_q0_nl
 call emit_cstr

 mov rsi, s_cfg_v
 call emit_cstr
 mov edi, dword [r13 + 32]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_db_q
 call emit_cstr
 mov rdi, [r13 + 8]
 call emit_tok
 mov rsi, s_q0_nl
 call emit_cstr
.s1_next:
 mov r13, [r13 + 16]
 jmp .s1
.s1_end:

 xor r14d, r14d
 mov r13, [r12 + 16]
.cn:
 test r13, r13
 jz .cn_end
 cmp qword [r13 + 40], 0xFFFF
 je .cn_next
 inc r14d
.cn_next:
 mov r13, [r13 + 16]
 jmp .cn
.cn_end:


 mov rsi, s_global_kw
 call emit_cstr
 call .cbase
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .cbase
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_colon
 call emit_cstr
 mov rsi, s_dq_sp
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr


 mov rsi, s_global_kw
 call emit_cstr
 call .cbase
 mov rsi, s_cfg_keys
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .cbase
 mov rsi, s_cfg_keys
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr
 mov r13, [r12 + 16]
.k:
 test r13, r13
 jz .k_end
 cmp qword [r13 + 40], 0xFFFF
 je .k_next
 mov rsi, s_dq_ind
 call emit_cstr
 mov rsi, s_cfg_k
 call emit_cstr
 mov edi, dword [r13 + 32]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
.k_next:
 mov r13, [r13 + 16]
 jmp .k
.k_end:


 mov rsi, s_global_kw
 call emit_cstr
 call .cbase
 mov rsi, s_cfg_txts
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .cbase
 mov rsi, s_cfg_txts
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr
 mov r13, [r12 + 16]
.t:
 test r13, r13
 jz .t_end
 cmp qword [r13 + 40], 0xFFFF
 je .t_next
 mov rsi, s_dq_ind
 call emit_cstr
 mov rsi, s_cfg_v
 call emit_cstr
 mov edi, dword [r13 + 32]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
.t_next:
 mov r13, [r13 + 16]
 jmp .t
.t_end:


 mov rsi, s_global_kw
 call emit_cstr
 call .cbase
 mov rsi, s_cfg_nums
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .cbase
 mov rsi, s_cfg_nums
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr
 mov r13, [r12 + 16]
.n:
 test r13, r13
 jz .n_end
 cmp qword [r13 + 40], 0xFFFF
 je .n_next
 mov rsi, s_dq_ind
 call emit_cstr
 mov rax, [r13 + 40]
 cmp rax, 5
 je .n_lit
 cmp rax, 2
 je .n_lit
 mov rsi, s_zero
 call emit_cstr
 jmp .n_nl
.n_lit:
 mov rdi, [r13 + 8]
 call emit_tok
.n_nl:
 mov rsi, s_nl
 call emit_cstr
.n_next:
 mov r13, [r13 + 16]
 jmp .n
.n_end:


 mov r13, [r12 + 16]
.h_loop:
 test r13, r13
 jz .h_end
 cmp qword [r13 + 40], 0xFFFF
 jne .h_next
 mov rsi, s_sec_text
 call emit_cstr

 xor eax, eax
 mov [rel var_count], eax
 call new_label
 mov [rel cur_ret_id], eax
 push rax

 mov rdi, [r13 + 8]
 call cg_count_vars
 mov ecx, eax
 shl ecx, 3
 add ecx, 32
 add ecx, 15
 and ecx, -16
 push rcx

 mov rsi, s_global_kw
 call emit_cstr
 call .hbase
 mov rsi, s_nl
 call emit_cstr
 call .hbase
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_pushrbp
 call emit_cstr
 mov rsi, s_movrbp
 call emit_cstr
 mov rsi, s_subrsp
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rdi, [r13 + 8]
 call cg_emit

 mov rsi, s_retlbl
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_movrsprbp
 call emit_cstr
 mov rsi, s_poprbp
 call emit_cstr
 mov rsi, s_ret
 call emit_cstr
.h_next:
 mov r13, [r13 + 16]
 jmp .h_loop
.h_end:

 pop r14
 pop r13
 pop r12
 ret


.hbase:
 mov rsi, s_cfg_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_underscore
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 ret

.cbase:
 mov rsi, s_cfg_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 ret







cg_sched:
 push r12
 push r13
 push r14
 mov r12, rdi


 mov rdi, r12
 call cg_config


 mov rax, [r12 + 8]
 test rax, rax
 jz .done

 mov rsi, s_sec_text
 call emit_cstr

 xor eax, eax
 mov [rel var_count], eax
 call new_label
 mov [rel cur_ret_id], eax
 mov r14d, eax

 mov rdi, [r12 + 8]
 call cg_count_vars
 mov ecx, eax
 shl ecx, 3
 add ecx, 32
 add ecx, 15
 and ecx, -16
 mov r13d, ecx

 mov rsi, s_global_kw
 call emit_cstr
 call .sbase
 mov rsi, s_sched_sw
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .sbase
 mov rsi, s_sched_sw
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_pushrbp
 call emit_cstr
 mov rsi, s_movrbp
 call emit_cstr
 mov rsi, s_subrsp
 call emit_cstr
 mov edi, r13d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rdi, [r12 + 8]
 call cg_emit

 mov rsi, s_retlbl
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_movrsprbp
 call emit_cstr
 mov rsi, s_poprbp
 call emit_cstr
 mov rsi, s_ret
 call emit_cstr

.done:
 pop r14
 pop r13
 pop r12
 ret

.sbase:
 mov rsi, s_sched_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 ret









cg_sys:
 push r12
 push r13
 push r14
 mov r12, rdi


 xor r14d, r14d
 mov r13, [r12 + 16]
.cnt:
 test r13, r13
 jz .cnt_end
 inc r14d
 mov r13, [r13 + 16]
 jmp .cnt
.cnt_end:

 mov rsi, s_sec_data
 call emit_cstr


 mov rsi, s_global_kw
 call emit_cstr
 call .sysbase
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .sysbase
 mov rsi, s_isa_cnt
 call emit_cstr
 mov rsi, s_colon
 call emit_cstr
 mov rsi, s_dq_sp
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr


 mov rsi, s_global_kw
 call emit_cstr
 call .sysbase
 mov rsi, s_sys_tbl
 call emit_cstr
 mov rsi, s_nl
 call emit_cstr
 call .sysbase
 mov rsi, s_sys_tbl
 call emit_cstr
 mov rsi, s_colon_nl
 call emit_cstr
 mov r13, [r12 + 16]
.tbl:
 test r13, r13
 jz .tbl_end
 mov rsi, s_dq_ind
 call emit_cstr
 mov rsi, s_svc_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_underscore
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .tbl
.tbl_end:


 mov r13, [r12 + 16]
.hdl:
 test r13, r13
 jz .hdl_end
 mov rsi, s_sec_text
 call emit_cstr

 xor eax, eax
 mov [rel var_count], eax
 call new_label
 mov [rel cur_ret_id], eax
 push rax

 mov rdi, [r13 + 16]
 call cg_count_vars
 mov ecx, eax
 shl ecx, 3
 add ecx, 32
 add ecx, 15
 and ecx, -16

 mov rsi, s_svc_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_underscore
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_pushrbp
 call emit_cstr
 mov rsi, s_movrbp
 call emit_cstr
 mov rsi, s_subrsp
 call emit_cstr
 mov edi, ecx
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rdi, [r13 + 16]
 call cg_emit

 mov rsi, s_retlbl
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_movrsprbp
 call emit_cstr
 mov rsi, s_poprbp
 call emit_cstr
 cmp qword [r12 + 40], 1
 je .use_sysret
 mov rsi, s_iretq
 call emit_cstr
 jmp .hdl_next
.use_sysret:
 mov rsi, s_sysretq
 call emit_cstr
.hdl_next:

 mov r13, [r13 + 16]
 jmp .hdl
.hdl_end:

 pop r14
 pop r13
 pop r12
 ret

.sysbase:
 mov rsi, s_sys_pref
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 ret









cg_module:
 push r12
 mov r12, rdi

 mov rsi, s_sec_data
 call emit_cstr

 mov rsi, s_mod_pref
 call emit_cstr
 call new_label
 mov edi, eax
 call emit_uint
 mov rsi, s_us
 call emit_cstr
 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .anon
 call emit_tok
 jmp .lbl_end
.anon:
 mov rsi, s_mod_anon
 call emit_cstr
.lbl_end:
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_db_q
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_q0_nl
 call emit_cstr

 mov rsi, s_db_q
 call emit_cstr
 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .anon2
 call emit_tok
 jmp .name_end
.anon2:
 mov rsi, s_mod_anon
 call emit_cstr
.name_end:
 mov rsi, s_q0_nl
 call emit_cstr

 mov rsi, s_sec_text
 call emit_cstr
 pop r12
 ret




cg_function:
 push r12
 push r13
 push r14
 mov r12, rdi

 xor eax, eax
 mov [rel var_count], eax

 call new_label
 mov [rel cur_ret_id], eax
 mov r14d, eax


 mov rdi, [r12 + 16]
 call cg_count_vars
 push rax

 mov rdi, [r12 + 8]
 call cg_count_list
 pop rcx
 add eax, ecx

 mov ecx, eax
 shl ecx, 3
 add ecx, 32
 add ecx, 15
 and ecx, -16
 mov r13d, ecx


 mov rax, [r12 + 40]
 cmp rax, 1
 jne .no_export
 mov rdi, [r12 + 24]
 call name_is_main
 test rax, rax
 jnz .no_export
 mov rsi, s_global_kw
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
.no_export:


 mov rdi, [r12 + 24]
 call name_is_main
 test rax, rax
 jz .named

 mov al, [rel cg_target]
 cmp al, 1
 je .use_start
 cmp byte [rel cg_bare], 0
 jne .use_kmain
 mov rsi, main_lbl
 call emit_cstr
 jmp .lbl_ok
.use_start:
 mov rsi, start_lbl
 call emit_cstr
 jmp .lbl_ok
.use_kmain:
 mov rsi, kmain_lbl
 call emit_cstr
.lbl_ok:
 jmp .prologue
.named:
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_colon_nl
 call emit_cstr
.prologue:
 mov rsi, s_pushrbp
 call emit_cstr
 mov rsi, s_movrbp
 call emit_cstr
 mov rsi, s_subrsp
 call emit_cstr
 mov edi, r13d
 call emit_uint
 mov rsi, s_nl
 call emit_cstr



 push r13
 push r14
 mov r13, [r12 + 8]
 xor r14d, r14d
.pspill:
 test r13, r13
 jz .pspill_end
 cmp r14d, 6
 jae .pspill_end

 movzx eax, word [r13 + 38]
 push rax
 mov rdi, [r13 + 24]
 mov rsi, 1

 mov rcx, [rsp]
 mov [rel pending_float], ecx
 call cg_add_var
 pop rcx
 push rax
 push rcx
 test rcx, rcx
 jnz .pspill_float

 mov rsi, s_movmem_pre
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_movmem_mid
 call emit_cstr
 lea rsi, [rel s_argreg0]
 cmp r14d, 0
 je .pr_ok
 lea rsi, [rel s_argreg1]
 cmp r14d, 1
 je .pr_ok
 lea rsi, [rel s_argreg2]
 cmp r14d, 2
 je .pr_ok
 lea rsi, [rel s_argreg3]
 cmp r14d, 3
 je .pr_ok
 lea rsi, [rel s_argreg4]
 cmp r14d, 4
 je .pr_ok
 lea rsi, [rel s_argreg5]
.pr_ok:
 call emit_cstr
 jmp .pspill_wrote
.pspill_float:

 mov rsi, s_fmovmem
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_fmovmid
 call emit_cstr

 mov edi, r14d
 call emit_uint
.pspill_wrote:
 pop rcx
 pop rax
 mov rsi, s_nl
 call emit_cstr
 inc r14d
 mov r13, [r13 + 16]
 jmp .pspill
.pspill_end:
 pop r14
 pop r13



 mov rdi, [r12 + 16]
 call cg_emit


 mov rsi, s_retlbl
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr

 mov rsi, s_movrsprbp
 call emit_cstr
 mov rsi, s_poprbp
 call emit_cstr

 mov rdi, [r12 + 24]
 call name_is_main
 test rax, rax
 jz .plain_ret
 mov al, [rel cg_target]
 cmp al, 1
 je .use_exitsys
 cmp byte [rel cg_bare], 0
 jne .use_halt
 mov rsi, s_retmain
 call emit_cstr
 jmp .done
.use_exitsys:
 mov rsi, s_retexit
 call emit_cstr
 jmp .done
.use_halt:
 mov rsi, s_rethalt
 call emit_cstr
 jmp .done
.plain_ret:
 mov rsi, s_ret
 call emit_cstr
.done:
 pop r14
 pop r13
 pop r12
 ret







cg_register_struct:
 push rbx
 push r12
 push r13
 mov r12, rdi
 mov eax, [rel struct_count]
 cmp eax, 256
 jae .done
 mov ebx, eax
 lea rcx, [rel struct_toks]
 mov rdx, [r12 + 24]
 mov [rcx + rbx*8], rdx

 mov ecx, [rel field_count]
 lea rdx, [rel struct_first]
 mov [rdx + rbx*4], ecx

 mov r13, [r12 + 16]
 xor r8d, r8d
 xor r9d, r9d
.floop:
 test r13, r13
 jz .fdone
 mov ecx, [rel field_count]
 cmp ecx, 4096
 jae .fdone
 lea rdx, [rel field_toks]
 mov rax, [r13 + 24]
 mov [rdx + rcx*8], rax

 push rcx
 push r8
 push r9
 mov eax, [r13 + 40]

 xor r10d, r10d
 cmp eax, 138
 je .is_ffield
 cmp eax, 139
 jne .not_ffield
.is_ffield:
 mov r10d, 1
.not_ffield:
 call cg_type_size
 pop r9
 pop r8
 pop rcx
 lea rdx, [rel field_isfloat]
 mov [rdx + rcx*4], r10d
 lea rdx, [rel field_sizes]
 mov [rdx + rcx*4], eax
 lea rdx, [rel field_offs]
 mov [rdx + rcx*4], r9d
 add r9d, eax
 inc ecx
 mov [rel field_count], ecx
 inc r8d
 mov r13, [r13 + 16]
 jmp .floop
.fdone:
 lea rdx, [rel struct_nfield]
 mov [rdx + rbx*4], r8d
 lea rdx, [rel struct_bytes]
 mov [rdx + rbx*4], r9d
 mov eax, ebx
 inc eax
 mov [rel struct_count], eax
.done:
 pop r13
 pop r12
 pop rbx
 ret


cg_find_struct:
 push rbx
 push r12
 push r13
 mov r12, rdi
 xor ebx, ebx
 mov r13d, [rel struct_count]
.l:
 cmp ebx, r13d
 jae .nf
 lea rax, [rel struct_toks]
 mov rsi, [rax + rbx*8]
 mov rdi, r12
 call tok_equal
 test eax, eax
 jnz .found
 inc ebx
 jmp .l
.found:
 mov eax, ebx
 jmp .out
.nf:
 mov eax, -1
.out:
 pop r13
 pop r12
 pop rbx
 ret







cg_ptr_scale:
 push rbx

 mov rax, [r12 + 24]
 cmp rax, 30
 je .op_ok
 cmp rax, 31
 je .op_ok
 jmp .done
.op_ok:

 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .done
 mov rax, [rdi + 0]
 cmp rax, 1015
 jne .done
 mov rdi, [rdi + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .done
 lea rcx, [rel var_elemsz]
 mov ebx, [rcx + rax*4]
 cmp ebx, 1
 jbe .done

 mov rsi, s_imul_pre
 call emit_cstr
 mov edi, ebx
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
.done:
 pop rbx
 ret











cg_global_decl:
 push rbx
 push r12
 mov r12, rdi
 mov eax, [rel g_count]
 cmp eax, 512
 jae .done
 mov ebx, eax
 lea rcx, [rel g_toks]
 mov rdx, [r12 + 24]
 mov [rcx + rbx*8], rdx
 movzx edx, word [r12 + 38]
 lea rcx, [rel g_isfloat]
 mov [rcx + rbx*4], edx
 inc eax
 mov [rel g_count], eax



 mov rax, [r12 + 40]
 test rax, rax
 jnz .aggregate
 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .scalar_head
 call cg_find_struct
 cmp eax, -1
 je .scalar_head
 call cg_struct_size
 test eax, eax
 jz .scalar_head
.aggregate:
 push rax
 mov rsi, s_sec_bss
 call emit_cstr
 mov rsi, s_glb_pre
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_glb_resq
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_sec_text
 call emit_cstr
 jmp .done
.scalar_head:
 mov rsi, s_sec_data
 call emit_cstr
 mov rsi, s_glb_pre
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
.scalar:
 mov rsi, s_flt_dq
 call emit_cstr

 mov rdi, [r12 + 16]
 test rdi, rdi
 jz .zero
 mov rax, [rdi + 0]
 cmp rax, 1016
 je .lit
 cmp rax, 1017
 je .lit
 cmp rax, 1019
 je .lit
 jmp .zero
.lit:
 mov rdi, [rdi + 24]
 call emit_tok
 jmp .nl
.zero:
 mov rsi, s_zero
 call emit_cstr
.nl:
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_sec_text
 call emit_cstr
.done:
 pop r12
 pop rbx
 ret


cg_find_global:
 push rbx
 push r12
 push r13
 mov r12, rdi
 xor ebx, ebx
 mov r13d, [rel g_count]
.l:
 cmp ebx, r13d
 jae .nf
 lea rax, [rel g_toks]
 mov rsi, [rax + rbx*8]
 mov rdi, r12
 call tok_equal
 test eax, eax
 jnz .found
 inc ebx
 jmp .l
.found:
 mov eax, ebx
 jmp .out
.nf:
 mov eax, -1
.out:
 pop r13
 pop r12
 pop rbx
 ret




cg_find_func:
 push rbx
 push r12
 push r13
 mov r12, rdi
 xor ebx, ebx
 mov r13d, [rel fn_count]
.l:
 cmp ebx, r13d
 jae .nf
 lea rax, [rel fn_toks]
 mov rsi, [rax + rbx*8]
 mov rdi, r12
 call tok_equal
 test eax, eax
 jnz .found
 inc ebx
 jmp .l
.found:
 mov eax, ebx
 jmp .out
.nf:
 mov eax, -1
.out:
 pop r13
 pop r12
 pop rbx
 ret


cg_global_is_float:
 call cg_find_global
 cmp eax, -1
 je .no
 lea rcx, [rel g_isfloat]
 mov eax, [rcx + rax*4]
 ret
.no:
 xor eax, eax
 ret





cg_expr_is_float:
 push rbx
 push r12
 test rdi, rdi
 jz .no
 mov r12, rdi
 mov rax, [r12 + 0]
 cmp rax, 1017
 je .yes
 cmp rax, 1059
 je .member
 cmp rax, 1047
 je .indexf
 cmp rax, 1008
 je .callf
 cmp rax, 1015
 je .ident
 cmp rax, 1006
 je .binop
 cmp rax, 1007
 je .unop
 jmp .no
.ident:
 mov rdi, [r12 + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .glb
 lea rcx, [rel var_isfloat]
 mov eax, [rcx + rax*4]
 test eax, eax
 jz .no
 jmp .yes
.glb:
 mov rdi, [r12 + 24]
 call cg_global_is_float
 test eax, eax
 jnz .yes
 jmp .no
.binop:
 mov rdi, [r12 + 8]
 call cg_expr_is_float
 test eax, eax
 jnz .yes
 mov rdi, [r12 + 16]
 call cg_expr_is_float
 test eax, eax
 jnz .yes
 jmp .no
.unop:
 mov rdi, [r12 + 16]
 call cg_expr_is_float
 test eax, eax
 jnz .yes
 jmp .no
.member:
 call cg_member_is_float
 test eax, eax
 jnz .yes
 jmp .no
.indexf:
 call cg_index_is_float
 test eax, eax
 jnz .yes
 jmp .no
.callf:
 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .no
 call cg_find_func
 cmp eax, -1
 je .no
 lea rcx, [rel fn_ret_float]
 mov eax, [rcx + rax*4]
 test eax, eax
 jnz .yes
 jmp .no
.no:
 xor eax, eax
 pop r12
 pop rbx
 ret
.yes:
 mov eax, 1
 pop r12
 pop rbx
 ret






cg_emit_float:
 push r12
 test rdi, rdi
 jz .zero
 mov r12, rdi
 mov rax, [r12 + 0]
 cmp rax, 1017
 je .lit
 cmp rax, 1015
 je .ident
 cmp rax, 1006
 je .binop
 cmp rax, 1059
 je .member_f
 cmp rax, 1047
 je .index_f
 cmp rax, 1008
 je .call_f

 mov rdi, r12
 call cg_emit
 mov rsi, s_cvt_i2d
 call emit_cstr
 jmp .out
.call_f:

 mov rdi, r12
 call cg_emit
 jmp .out

.lit:

 call new_label
 push rax
 push rax
 mov rsi, s_sec_data
 call emit_cstr
 mov rsi, s_flt_lbl
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_flt_dq
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_sec_text
 call emit_cstr
 mov rsi, s_ld_flt
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_closebrk
 call emit_cstr
 jmp .out

.member_f:
 call cg_member_is_float
 test eax, eax
 jz .member_f_int
 call cg_member_offset
 push rax
 mov rsi, s_ld_xmm_pre
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_addr_post
 call emit_cstr
 jmp .out
.member_f_int:

 mov rdi, r12
 call cg_emit
 mov rsi, s_cvt_i2d
 call emit_cstr
 jmp .out
.index_f:
 call cg_index_is_float
 test eax, eax
 jz .index_f_int

 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_idx_rcx
 call emit_cstr
 mov rdi, [r12 + 24]
 call cg_emit_idx_base
 mov rsi, s_rd_f
 call emit_cstr
 jmp .out
.index_f_int:
 mov rdi, r12
 call cg_emit
 mov rsi, s_cvt_i2d
 call emit_cstr
 jmp .out

.ident:
 mov rdi, [r12 + 24]
 call cg_expr_is_float_ident
 test eax, eax
 jz .ident_int
 mov rdi, [r12 + 24]
 call cg_find_var
 push rax
 mov rsi, s_ld_xmm_pre
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_closebrk
 call emit_cstr
 jmp .out
.ident_int:
 mov rdi, r12
 call cg_emit
 mov rsi, s_cvt_i2d
 call emit_cstr
 jmp .out

.binop:
 mov rdi, [r12 + 8]
 call cg_emit_float
 mov rsi, s_push_xmm
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit_float
 mov rsi, s_pop_xmm1
 call emit_cstr
 mov rax, [r12 + 24]
 cmp rax, 30
 je .fadd
 cmp rax, 31
 je .fsub
 cmp rax, 32
 je .fmul
 cmp rax, 33
 je .fdiv
 jmp .out
.fadd:
 mov rsi, s_addsd
 call emit_cstr
 jmp .out
.fsub:
 mov rsi, s_subsd
 call emit_cstr
 jmp .out
.fmul:
 mov rsi, s_mulsd
 call emit_cstr
 jmp .out
.fdiv:
 mov rsi, s_divsd
 call emit_cstr
 jmp .out

.zero:
 mov rsi, s_zero_xmm
 call emit_cstr
.out:
 pop r12
 ret


cg_expr_is_float_ident:
 push rdi
 call cg_find_var_idx
 pop rdi
 cmp eax, -1
 je .glb
 lea rcx, [rel var_isfloat]
 mov eax, [rcx + rax*4]
 ret
.glb:
 call cg_global_is_float
 ret





cg_type_size:
 cmp eax, 130
 je .b1
 cmp eax, 134
 je .b1
 cmp eax, 140
 je .b1
 cmp eax, 131
 je .b2
 cmp eax, 135
 je .b2
 cmp eax, 132
 je .b4
 cmp eax, 136
 je .b4
 cmp eax, 138
 je .b4
 mov eax, 8
 ret
.b1:
 mov eax, 1
 ret
.b2:
 mov eax, 2
 ret
.b4:
 mov eax, 4
 ret


cg_struct_size:
 test eax, eax
 js .zero
 lea rcx, [rel struct_bytes]
 mov eax, [rcx + rax*4]
 add eax, 7
 shr eax, 3
 ret
.zero:
 xor eax, eax
 ret


cg_field_index:
 push rbx
 push r12
 push r13
 push r14
 mov r14, rsi
 mov eax, edi
 test eax, eax
 js .nf
 lea rcx, [rel struct_first]
 mov r12d, [rcx + rax*4]
 lea rcx, [rel struct_nfield]
 mov r13d, [rcx + rax*4]
 xor ebx, ebx
.l:
 cmp ebx, r13d
 jae .nf
 mov ecx, r12d
 add ecx, ebx
 lea rax, [rel field_toks]
 mov rsi, [rax + rcx*8]
 mov rdi, r14
 call tok_equal
 test eax, eax
 jnz .found
 inc ebx
 jmp .l
.found:
 mov eax, ebx
 jmp .out
.nf:
 mov eax, -1
.out:
 pop r14
 pop r13
 pop r12
 pop rbx
 ret


cg_find_var_idx:
 push rbx
 push r12
 push r13
 mov r12, rdi
 mov r13d, [rel var_count]
 mov ebx, r13d
 dec ebx
.l:
 test ebx, ebx
 js .nf
 lea rax, [rel var_toks]
 mov rsi, [rax + rbx*8]
 mov rdi, r12
 call tok_equal
 test eax, eax
 jnz .found
 dec ebx
 jmp .l
.found:
 mov eax, ebx
 jmp .out
.nf:
 mov eax, -1
.out:
 pop r13
 pop r12
 pop rbx
 ret



cg_member_offset:
 push rbx
 push r13
 push r14
 mov r14d, 8
 mov rdi, [r12 + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .zero
 mov ebx, eax
 lea rcx, [rel var_offs]
 mov r13d, [rcx + rbx*4]
 lea rcx, [rel var_structs]
 mov edi, [rcx + rbx*4]
 cmp edi, -1
 je .plain
 push rdi
 mov rsi, [r12 + 8]
 call cg_field_index
 pop rdi
 cmp eax, -1
 je .plain

 push rax
 lea rcx, [rel struct_first]
 mov ecx, [rcx + rdi*4]
 pop rax
 add eax, ecx
 lea rcx, [rel field_offs]
 mov esi, [rcx + rax*4]
 lea rcx, [rel field_sizes]
 mov r14d, [rcx + rax*4]
 sub r13d, esi
.plain:
 mov eax, r13d
 jmp .out
.zero:
 xor eax, eax
.out:
 mov edx, r14d
 pop r14
 pop r13
 pop rbx
 ret


cg_index_is_float:
 push rbx
 mov rdi, [r12 + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .ixf_glob
 lea rcx, [rel var_isfloat]
 mov eax, [rcx + rax*4]
 test eax, eax
 jz .ixf_no
 mov eax, 1
 pop rbx
 ret
.ixf_glob:
 mov rdi, [r12 + 24]
 call cg_global_is_float
 test eax, eax
 jz .ixf_no
 mov eax, 1
 pop rbx
 ret
.ixf_no:
 xor eax, eax
 pop rbx
 ret


cg_member_is_float:
 push rbx
 push r13
 mov rdi, [r12 + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .mf_no
 mov ebx, eax
 lea rcx, [rel var_structs]
 mov edi, [rcx + rbx*4]
 cmp edi, -1
 je .mf_no
 push rdi
 mov rsi, [r12 + 8]
 call cg_field_index
 pop rdi
 cmp eax, -1
 je .mf_no
 lea rcx, [rel struct_first]
 mov ecx, [rcx + rdi*4]
 add eax, ecx
 lea rcx, [rel field_isfloat]
 mov eax, [rcx + rax*4]
 test eax, eax
 jz .mf_no
 mov eax, 1
 pop r13
 pop rbx
 ret
.mf_no:
 xor eax, eax
 pop r13
 pop rbx
 ret



cg_count_list:
 xor eax, eax
.l:
 test rdi, rdi
 jz .d
 inc eax
 mov rdi, [rdi + 16]
 jmp .l
.d:
 ret

cg_count_vars:
 push r12
 push r13
 mov r12, rdi
 xor r13d, r13d
 test r12, r12
 jz .done
 mov rax, [r12 + 0]
 cmp rax, 1003
 je .isvar
 cmp rax, 1004
 je .isvar

 cmp rax, 1059
 je .done
 cmp rax, 1048
 je .done
 cmp rax, 1047
 je .idx_recurse
 jmp .recurse

.idx_recurse:
 mov rdi, [r12 + 16]
 call cg_count_vars
 add r13d, eax
 jmp .done
.isvar:
 mov rax, [r12 + 40]
 test rax, rax
 jnz .isarr

 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .isscalar
 call cg_find_struct
 cmp eax, -1
 je .isscalar
 call cg_struct_size
 test eax, eax
 jz .isscalar
 add r13d, eax
 jmp .decl_recurse
.isscalar:
 inc r13d
 jmp .decl_recurse
.isarr:
 add r13d, eax
 jmp .decl_recurse



.decl_recurse:
 mov rdi, [r12 + 16]
 call cg_count_vars
 add r13d, eax
 jmp .done
.recurse:
 mov rdi, [r12 + 8]
 call cg_count_vars
 add r13d, eax
 mov rdi, [r12 + 16]
 call cg_count_vars
 add r13d, eax

.done:
 mov eax, r13d
 pop r13
 pop r12
 ret




cg_emit:
 test rdi, rdi
 jz .ret0
 push r12
 mov r12, rdi
 mov rax, [r12 + 0]

 cmp rax, 1002
 je .block
 cmp rax, 1003
 je .vardecl
 cmp rax, 1004
 je .vardecl
 cmp rax, 1005
 je .assign
 cmp rax, 1009
 je .ret_stmt
 cmp rax, 1025
 je .print_stmt
 cmp rax, 1061
 je .printc_stmt
 cmp rax, 1042
 je .outb_stmt
 cmp rax, 1044
 je .poke_stmt
 cmp rax, 1065
 je .beep_stmt
 cmp rax, 1063
 je .savefile_stmt
 cmp rax, 1050
 je .poke8_stmt
 cmp rax, 1051
 je .poke16_stmt
 cmp rax, 1052
 je .poke32_stmt
 cmp rax, 1046
 je .asm_stmt
 cmp rax, 1010
 je .if_stmt
 cmp rax, 1011
 je .while_stmt
 cmp rax, 1006
 je .binop
 cmp rax, 1007
 je .unop
 cmp rax, 1008
 je .call
 cmp rax, 1060
 je .call_indirect
 cmp rax, 29
 je .syscall
 cmp rax, 1015
 je .ident
 cmp rax, 1043
 je .inb_expr
 cmp rax, 1047
 je .index_expr
 cmp rax, 1059
 je .member_expr
 cmp rax, 1048
 je .addr_expr
 cmp rax, 1049
 je .deref_expr
 cmp rax, 1045
 je .peek_expr
 cmp rax, 1064
 je .readkey_e
 cmp rax, 1018
 je .strlit_e
 cmp rax, 1066
 je .readmouse_e
 cmp rax, 1067
 je .mousex_e
 cmp rax, 1068
 je .mousey_e
 cmp rax, 1062
 je .trunc_expr
 cmp rax, 1053
 je .peek8_expr
 cmp rax, 1054
 je .peek16_expr
 cmp rax, 1055
 je .peek32_expr
 cmp rax, 1016
 je .intlit
 cmp rax, 1019
 je .intlit
 cmp rax, 1013
 je .skip
 cmp rax, 1014
 je .skip

 jmp .skip

.block:
 mov rdi, [r12 + 8]
 call cg_emit
 mov rdi, [r12 + 16]
 call cg_emit
 jmp .out

.vardecl:

 mov dword [rel pending_struct], -1
 mov ecx, dword [r12 + 32]
 mov [rel pending_elem], ecx
 movzx ecx, word [r12 + 38]
 mov [rel pending_float], ecx
 mov rsi, [r12 + 40]
 test rsi, rsi
 jnz .vd_sized

 mov rdi, [r12 + 8]
 test rdi, rdi
 jz .vd_scalar
 call cg_find_struct
 cmp eax, -1
 je .vd_scalar
 mov [rel pending_struct], eax
 call cg_struct_size
 test eax, eax
 jz .vd_scalar
 mov esi, eax
 jmp .vd_sized
.vd_scalar:
 xor esi, esi
.vd_sized:
 mov rdi, [r12 + 24]
 call cg_add_var
 push rax

 cmp qword [r12 + 16], 0
 je .vardecl_noinit

 movzx eax, word [r12 + 38]
 test eax, eax
 jnz .vardecl_float
 mov rdi, [r12 + 16]
 call cg_emit
 pop rcx

 push rax
 mov rsi, s_movmemrax
 call emit_cstr
 mov edi, ecx
 call emit_uint
 mov rsi, s_movmemrax2
 call emit_cstr
 pop rax
 jmp .out
.vardecl_float:
 mov rdi, [r12 + 16]
 call cg_emit_float
 pop rcx
 push rcx
 mov rsi, s_st_xmm_pre
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_st_xmm_suf
 call emit_cstr
 jmp .out
.vardecl_noinit:
 pop rcx
 jmp .out

.assign:

 mov rdi, [r12 + 8]
 mov rax, [rdi + 0]
 cmp rax, 1047
 je .assign_idx
 cmp rax, 1049
 je .assign_deref
 cmp rax, 1059
 je .assign_member

 cmp rax, 1015
 jne .assign_int
 mov rdi, [rdi + 24]
 call cg_expr_is_float_ident
 test eax, eax
 jnz .assign_float
.assign_int:
 mov rdi, [r12 + 16]
 call cg_emit

 mov rdi, [r12 + 8]
 mov rax, [rdi + 0]
 cmp rax, 1015
 jne .out
 mov rdi, [rdi + 24]
 push rdi
 call cg_find_var_idx
 pop rdi
 cmp eax, -1
 je .assign_glb
 call cg_find_var
 mov ecx, eax
 mov rsi, s_movmemrax
 call emit_cstr
 mov edi, ecx
 call emit_uint
 mov rsi, s_movmemrax2
 call emit_cstr
 jmp .out
.assign_glb:
 push rdi
 mov rsi, s_stg_pre
 call emit_cstr
 pop rdi
 call emit_tok
 mov rsi, s_stg_suf
 call emit_cstr
 jmp .out


.assign_float:
 mov rdi, [r12 + 16]
 call cg_emit_float
 mov rdi, [r12 + 8]
 mov rdi, [rdi + 24]
 call cg_find_var
 push rax
 mov rsi, s_st_xmm_pre
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_st_xmm_suf
 call emit_cstr
 jmp .out


.assign_member:
 push r13
 mov r13, [r12 + 8]

 push r12
 mov r12, r13
 call cg_member_is_float
 pop r12
 test eax, eax
 jnz .assign_member_float
 mov rdi, [r12 + 16]
 call cg_emit
 push r12
 mov r12, r13
 call cg_member_offset
 pop r12
 push rax
 push rdx
 mov rsi, s_movmem_pre
 call emit_cstr
 pop rdx
 pop rdi
 push rdx
 call emit_uint
 pop rdx
 cmp edx, 1
 je .mw1
 cmp edx, 2
 je .mw2
 cmp edx, 4
 je .mw4
 mov rsi, s_st8_suf
 jmp .mw_go
.mw1:
 mov rsi, s_st1_suf
 jmp .mw_go
.mw2:
 mov rsi, s_st2_suf
 jmp .mw_go
.mw4:
 mov rsi, s_st4_suf
.mw_go:
 call emit_cstr
 pop r13
 jmp .out
.assign_member_float:

 push r12
 mov r12, r13
 call cg_member_offset
 pop r12
 push rax

 mov rdi, [r12 + 16]
 call cg_emit_float

 mov rsi, s_st_xmm_pre
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_st_xmm_suf
 call emit_cstr
 pop r13
 jmp .out


.assign_deref:
 push r13
 mov r13, [r12 + 8]
 mov rdi, [r13 + 16]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_poke_seq
 call emit_cstr
 pop r13
 jmp .out


.assign_idx:
 push r13
 mov r13, [r12 + 8]

 push r12
 mov r12, r13
 call cg_index_is_float
 pop r12
 test eax, eax
 jnz .assign_idx_float
 mov rdi, [r13 + 16]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_idx_pop
 call emit_cstr
 mov rdi, [r13 + 24]
 call cg_emit_idx_base
 mov rsi, s_wr_i
 call emit_cstr
 pop r13
 jmp .out
.assign_idx_float:

 mov rdi, [r13 + 16]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr

 mov rdi, [r12 + 16]
 call cg_emit_float

 mov rsi, s_idx_pop
 call emit_cstr
 mov rdi, [r13 + 24]
 call cg_emit_idx_base
 mov rsi, s_wr_f
 call emit_cstr
 pop r13
 jmp .out

.ret_stmt:
 mov rdi, [r12 + 16]
 test rdi, rdi
 jz .ret_jmp

 call cg_expr_is_float
 test eax, eax
 jz .ret_int
 mov rdi, [r12 + 16]
 call cg_emit_float
 jmp .ret_jmp
.ret_int:
 mov rdi, [r12 + 16]
 call cg_emit
.ret_jmp:
 mov rsi, s_jmpret
 call emit_cstr
 mov edi, [rel cur_ret_id]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 jmp .out


.peek8_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_peek8_seq
 call emit_cstr
 jmp .out
.peek16_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_peek16_seq
 call emit_cstr
 jmp .out
.peek32_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_peek32_seq
 call emit_cstr
 jmp .out


.member_expr:
 call cg_member_offset
 push rax
 cmp edx, 1
 je .mr1
 cmp edx, 2
 je .mr2
 cmp edx, 4
 je .mr4
 mov rsi, s_ld8_pre
 jmp .mr_go
.mr1:
 mov rsi, s_ld1_pre
 jmp .mr_go
.mr2:
 mov rsi, s_ld2_pre
 jmp .mr_go
.mr4:
 mov rsi, s_ld4_pre
.mr_go:
 call emit_cstr
 pop rdi
 call emit_uint
 mov rsi, s_closemem
 call emit_cstr
 jmp .out


.addr_expr:
 mov rdi, [r12 + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .addr_glb
 mov rsi, s_addr_pre
 call emit_cstr
 mov rdi, [r12 + 24]
 call cg_find_var
 mov edi, eax
 call emit_uint
 mov rsi, s_addr_post
 call emit_cstr
 jmp .out
.addr_glb:


 mov rdi, [r12 + 24]
 call cg_find_func
 cmp eax, -1
 jne .addr_fn

 mov rsi, s_lea_glb
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_closebrk
 call emit_cstr
 jmp .out
.addr_fn:

 mov rsi, s_lea_fn
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_closebrk
 call emit_cstr
 jmp .out


.deref_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_peek_seq
 call emit_cstr
 jmp .out


.index_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_idx_rcx
 call emit_cstr
 mov rdi, [r12 + 24]
 call cg_emit_idx_base
 mov rsi, s_rd_i
 call emit_cstr
 jmp .out


.inb_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_inb_seq
 call emit_cstr
 jmp .out


.peek_expr:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_peek_seq
 call emit_cstr
 jmp .out
.readkey_e:
 mov rsi, s_readkey
 call emit_cstr
 jmp .out
.strlit_e:


 push r13
 push r14
 push rbx
 call new_label
 mov ebx, eax
 mov rsi, s_sec_data
 call emit_cstr
 mov rsi, s_str_lbl
 call emit_cstr
 mov edi, ebx
 call emit_uint
 mov rsi, s_str_db
 call emit_cstr
 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .s_end
 mov r13, [rdi + 8]
 mov r14d, dword [rdi + 16]
 inc r13
 sub r14, 2
 jns .s_loop
 xor r14d, r14d
.s_loop:
 test r14, r14
 jz .s_end
 movzx eax, byte [r13]
 cmp al, 92
 jne .s_plain
 cmp r14, 1
 je .s_plain
 movzx ecx, byte [r13 + 1]
 mov eax, ecx
 cmp cl, 110
 jne .s_e1
 mov eax, 10
 jmp .s_esc
.s_e1:
 cmp cl, 116
 jne .s_e2
 mov eax, 9
 jmp .s_esc
.s_e2:
 cmp cl, 114
 jne .s_e3
 mov eax, 13
 jmp .s_esc
.s_e3:
 cmp cl, 48
 jne .s_esc
 xor eax, eax
.s_esc:
 add r13, 2
 sub r14, 2
 jmp .s_emit
.s_plain:
 inc r13
 dec r14
.s_emit:
 push r13
 push r14
 mov edi, eax
 call emit_uint
 mov rsi, s_comma
 call emit_cstr
 pop r14
 pop r13
 jmp .s_loop
.s_end:
 mov rsi, s_str_zero
 call emit_cstr
 mov rsi, s_sec_text
 call emit_cstr
 mov rsi, s_lea_str
 call emit_cstr
 mov edi, ebx
 call emit_uint
 mov rsi, s_closebrk
 call emit_cstr
 pop rbx
 pop r14
 pop r13
 jmp .out
.readmouse_e:
 mov rsi, s_readmouse
 call emit_cstr
 jmp .out
.mousex_e:
 mov rsi, s_mousex
 call emit_cstr
 jmp .out
.mousey_e:
 mov rsi, s_mousey
 call emit_cstr
 jmp .out
.trunc_expr:
 mov rdi, [r12 + 16]
 call cg_emit_float
 mov rsi, s_trunc
 call emit_cstr
 jmp .out

.printc_stmt:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_printc
 call emit_cstr
 jmp .out

.print_stmt:
 mov rdi, [r12 + 16]
 test rdi, rdi
 jz .print_int_path
 mov rax, [rdi + 0]
 cmp rax, 1018
 je .print_string
.print_int_path:
 mov rdi, [r12 + 16]
 call cg_expr_is_float
 test eax, eax
 jnz .print_float
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_print
 call emit_cstr
 jmp .out
.print_float:
 mov rdi, [r12 + 16]
 call cg_emit_float
 mov rsi, s_printf
 call emit_cstr
 jmp .out
.print_string:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_prints
 call emit_cstr
 jmp .out


.outb_stmt:
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_outb_seq
 call emit_cstr
 jmp .out


.beep_stmt:
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_beep_seq
 call emit_cstr
 jmp .out

.poke_stmt:
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_poke_seq
 call emit_cstr
 jmp .out
.savefile_stmt:
 mov rdi, [r12 + 24]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_save_seq
 call emit_cstr
 jmp .out


.poke8_stmt:
 mov r13, s_poke8_seq
 jmp .poke_sized
.poke16_stmt:
 mov r13, s_poke16_seq
 jmp .poke_sized
.poke32_stmt:
 mov r13, s_poke32_seq
.poke_sized:
 push r13
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 pop rsi
 call emit_cstr
 jmp .out


.asm_stmt:
 push r13
 mov r13, [r12 + 16]
.asm_it:
 test r13, r13
 jz .asm_fin
 mov rsi, s_ind4
 call emit_cstr
 mov rdi, [r13 + 24]
 call emit_tok_raw
 mov rsi, s_nl
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .asm_it
.asm_fin:
 pop r13
 jmp .out

.if_stmt:

 call new_label
 push rax
 call new_label
 push rax

 mov rdi, [r12 + 24]
 call cg_emit

 mov rsi, s_jz
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rdi, [r12 + 8]
 call cg_emit

 mov rsi, s_jmp
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr

 mov rdi, [r12 + 16]
 call cg_emit

 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 add rsp, 16
 jmp .out

.while_stmt:

 call new_label
 push rax
 call new_label
 push rax

 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr

 mov rax, [r12 + 24]
 test rax, rax
 jz .while_body
 mov rdi, [r12 + 24]
 call cg_emit
 mov rsi, s_jz
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
.while_body:
 mov rdi, [r12 + 16]
 call cg_emit

 mov rsi, s_jmp
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr

 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 add rsp, 16
 jmp .out

.binop:

 mov rax, [r12 + 24]
 cmp rax, 47
 je .logical_and
 cmp rax, 48
 je .logical_or


 mov rax, [r12 + 24]
 cmp rax, 41
 je .maybe_fcmp
 cmp rax, 42
 je .maybe_fcmp
 cmp rax, 43
 je .maybe_fcmp
 cmp rax, 44
 je .maybe_fcmp
 cmp rax, 45
 je .maybe_fcmp
 cmp rax, 46
 je .maybe_fcmp
 jmp .int_binop
.maybe_fcmp:
 mov rdi, [r12 + 8]
 call cg_expr_is_float
 test eax, eax
 jnz .fcompare
 mov rdi, [r12 + 16]
 call cg_expr_is_float
 test eax, eax
 jnz .fcompare
 jmp .int_binop
.fcompare:

 mov rdi, [r12 + 8]
 call cg_emit_float
 mov rsi, s_push_xmm
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit_float
 mov rsi, s_pop_xmm1
 call emit_cstr

 mov rsi, s_fcmp
 call emit_cstr
 mov rax, [r12 + 24]
 cmp rax, 43
 je .fc_lt
 cmp rax, 44
 je .fc_gt
 cmp rax, 45
 je .fc_le
 cmp rax, 46
 je .fc_ge
 cmp rax, 41
 je .fc_eq

 mov rsi, s_fsetne
 call emit_cstr
 jmp .out
.fc_lt:
 mov rsi, s_fsetb
 call emit_cstr
 jmp .out
.fc_gt:
 mov rsi, s_fseta
 call emit_cstr
 jmp .out
.fc_le:
 mov rsi, s_fsetbe
 call emit_cstr
 jmp .out
.fc_ge:
 mov rsi, s_fsetae
 call emit_cstr
 jmp .out
.fc_eq:
 mov rsi, s_fsete
 call emit_cstr
 jmp .out
.int_binop:

 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_pushrax
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit

 call cg_ptr_scale
 mov rsi, s_movrcxrax
 call emit_cstr
 mov rsi, s_poprax
 call emit_cstr
 mov rax, [r12 + 24]
 call cg_emit_binop_op
 jmp .out

.logical_and:
 call new_label
 push rax
 call new_label
 push rax
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_jz
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_jz
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_mov_rax1
 call emit_cstr
 mov rsi, s_jmp
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_mov_rax0
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 add rsp, 16
 jmp .out
.logical_or:
 call new_label
 push rax
 call new_label
 push rax
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_jnz
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_jnz
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_mov_rax0
 call emit_cstr
 mov rsi, s_jmp
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp+8]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 mov rsi, s_mov_rax1
 call emit_cstr
 mov rsi, s_label_L
 call emit_cstr
 mov rdi, [rsp]
 call emit_uint
 mov rsi, s_colon_nl
 call emit_cstr
 add rsp, 16
 jmp .out
.unop:
 mov rdi, [r12 + 16]
 call cg_emit
 mov rsi, s_neg
 call emit_cstr
 jmp .out

.syscall:





 mov r13, [r12 + 16]
.sys_eval:
 test r13, r13
 jz .sys_pops
 mov rdi, [r13 + 8]
 push r13
 call cg_emit
 pop r13
 mov rsi, s_pushrax
 call emit_cstr
 mov r13, [r13 + 16]
 jmp .sys_eval
.sys_pops:
 mov r13, [r12 + 24]
 dec r13
.sys_pop_loop:
 test r13, r13
 js .sys_do
 mov rdi, r13
 call emit_syscall_pop
 dec r13
 jmp .sys_pop_loop
.sys_do:
 mov rsi, s_syscall
 call emit_cstr
 jmp .out

.call:


 push r13
 push r14
 mov r13, [r12 + 16]
 xor r14d, r14d
.arg_push:
 test r13, r13
 jz .arg_done
 cmp r14d, 6
 jae .arg_done
 mov rdi, [r13 + 8]
 call cg_expr_is_float
 test eax, eax
 jnz .arg_push_f
 mov rdi, [r13 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 jmp .arg_push_next
.arg_push_f:
 mov rdi, [r13 + 8]
 call cg_emit_float
 mov rsi, s_fpush
 call emit_cstr
.arg_push_next:
 inc r14d
 mov r13, [r13 + 16]
 jmp .arg_push
.arg_done:



.arg_pop:
 test r14d, r14d
 jz .arg_ready
 dec r14d

 mov r13, [r12 + 16]
 mov ecx, r14d
.arg_walk:
 test ecx, ecx
 jz .arg_walk_done
 mov r13, [r13 + 16]
 dec ecx
 jmp .arg_walk
.arg_walk_done:
 mov rdi, [r13 + 8]
 call cg_expr_is_float
 test eax, eax
 jnz .arg_pop_f

 lea rsi, [rel s_poparg0]
 cmp r14d, 0
 je .ap_ok
 lea rsi, [rel s_poparg1]
 cmp r14d, 1
 je .ap_ok
 lea rsi, [rel s_poparg2]
 cmp r14d, 2
 je .ap_ok
 lea rsi, [rel s_poparg3]
 cmp r14d, 3
 je .ap_ok
 lea rsi, [rel s_poparg4]
 cmp r14d, 4
 je .ap_ok
 lea rsi, [rel s_poparg5]
.ap_ok:
 call emit_cstr
 jmp .arg_pop
.arg_pop_f:

 mov rsi, s_fpop_pre
 call emit_cstr
 mov edi, r14d
 call emit_uint
 mov rsi, s_fpop_suf
 call emit_cstr
 jmp .arg_pop
.arg_ready:
 pop r14
 pop r13
 mov rsi, s_shadow_sub
 call emit_cstr
 mov rsi, s_call
 call emit_cstr
 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .call_nl
 call emit_tok
.call_nl:
 mov rsi, s_nl
 call emit_cstr
 mov rsi, s_shadow_add
 call emit_cstr
 jmp .out






.call_indirect:
 push r13
 push r14
 mov rdi, [r12 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 mov r13, [r12 + 16]
 xor r14d, r14d
.ci_arg_push:
 test r13, r13
 jz .ci_arg_done
 cmp r14d, 4
 jae .ci_arg_done
 mov rdi, [r13 + 8]
 call cg_emit
 mov rsi, s_push_rax
 call emit_cstr
 inc r14d
 mov r13, [r13 + 16]
 jmp .ci_arg_push
.ci_arg_done:
.ci_arg_pop:
 test r14d, r14d
 jz .ci_arg_ready
 dec r14d
 lea rsi, [rel s_poparg0]
 cmp r14d, 0
 je .ci_ap_ok
 lea rsi, [rel s_poparg1]
 cmp r14d, 1
 je .ci_ap_ok
 lea rsi, [rel s_poparg2]
 cmp r14d, 2
 je .ci_ap_ok
 lea rsi, [rel s_poparg3]
.ci_ap_ok:
 call emit_cstr
 jmp .ci_arg_pop
.ci_arg_ready:

 mov rsi, s_pop_r11
 call emit_cstr
 pop r14
 pop r13
 mov rsi, s_shadow_sub
 call emit_cstr
 mov rsi, s_call_r11
 call emit_cstr
 mov rsi, s_shadow_add
 call emit_cstr
 jmp .out

.ident:
 mov rdi, [r12 + 24]
 call cg_find_var_idx
 cmp eax, -1
 je .ident_glb
 mov rdi, [r12 + 24]
 call cg_find_var
 mov ecx, eax
 mov rsi, s_movraxmem
 call emit_cstr
 mov edi, ecx
 call emit_uint
 mov rsi, s_closemem
 call emit_cstr
 jmp .out
.ident_glb:
 mov rsi, s_ldg_pre
 call emit_cstr
 mov rdi, [r12 + 24]
 call emit_tok
 mov rsi, s_closebrk
 call emit_cstr
 jmp .out

.intlit:
 mov rsi, s_movrax_imm
 call emit_cstr
 mov rdi, [r12 + 24]
 test rdi, rdi
 jz .intlit_zero
 call emit_tok
 jmp .intlit_nl
.intlit_zero:
 xor rdi, rdi
 call emit_uint
.intlit_nl:
 mov rsi, s_nl
 call emit_cstr
 jmp .out

.skip:
.out:
 pop r12
.ret0:
 ret


cg_emit_binop_op:
 cmp rax, 30
 je .add
 cmp rax, 31
 je .sub
 cmp rax, 32
 je .mul
 cmp rax, 33
 je .div
 cmp rax, 34
 je .mod
 cmp rax, 39
 je .shl
 cmp rax, 40
 je .shr
 cmp rax, 41
 je .eq
 cmp rax, 42
 je .neq
 cmp rax, 43
 je .lt
 cmp rax, 44
 je .gt
 cmp rax, 45
 je .lte
 cmp rax, 46
 je .gte
 ret
.add:
 mov rsi, s_add
 jmp emit_cstr
.sub:
 mov rsi, s_sub
 jmp emit_cstr
.mul:
 mov rsi, s_imul
 jmp emit_cstr
.div:
 mov rsi, s_idiv
 jmp emit_cstr
.mod:
 mov rsi, s_imod
 jmp emit_cstr
.shl:
 mov rsi, s_shl
 jmp emit_cstr
.shr:
 mov rsi, s_shr
 jmp emit_cstr
.eq:
 mov rsi, s_cmp
 call emit_cstr
 mov rsi, s_sete
 jmp emit_cstr
.neq:
 mov rsi, s_cmp
 call emit_cstr
 mov rsi, s_setne
 jmp emit_cstr
.lt:
 mov rsi, s_cmp
 call emit_cstr
 mov rsi, s_setl
 jmp emit_cstr
.gt:
 mov rsi, s_cmp
 call emit_cstr
 mov rsi, s_setg
 jmp emit_cstr
.lte:
 mov rsi, s_cmp
 call emit_cstr
 mov rsi, s_setle
 jmp emit_cstr
.gte:
 mov rsi, s_cmp
 call emit_cstr
 mov rsi, s_setge
 jmp emit_cstr



emit_syscall_pop:
 cmp rdi, 0
 je .p0
 cmp rdi, 1
 je .p1
 cmp rdi, 2
 je .p2
 cmp rdi, 3
 je .p3
 cmp rdi, 4
 je .p4
 cmp rdi, 5
 je .p5
 cmp rdi, 6
 je .p6
 ret
.p0:
 mov rsi, s_pop_rax
 jmp emit_cstr
.p1:
 mov rsi, s_pop_rdi
 jmp emit_cstr
.p2:
 mov rsi, s_pop_rsi
 jmp emit_cstr
.p3:
 mov rsi, s_pop_rdx
 jmp emit_cstr
.p4:
 mov rsi, s_pop_r10
 jmp emit_cstr
.p5:
 mov rsi, s_pop_r8
 jmp emit_cstr
.p6:
 mov rsi, s_pop_r9
 jmp emit_cstr

codegen_get_code:
 mov rax, [rel cg_out]
 ret

codegen_get_code_size:
 mov rax, [rel cg_ptr]
 sub rax, [rel cg_out]
 ret

[section .data]
main_lbl: db "main:", 10, 0
kmain_lbl: db "kmain:", 10, 0
start_lbl: db "_start:", 10, 0
s_retexit: db "    mov rdi, rax", 10, "    mov rax, 60", 10, "    syscall", 10, 0
s_rethalt: db "    cli", 10, "    hlt", 10, 0





