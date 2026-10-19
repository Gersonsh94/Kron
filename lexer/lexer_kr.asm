; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_lexer_TOK_EOF: dq 0
section .text
section .data
__g_lexer_TOK_IDENTIFIER: dq 1
section .text
section .data
__g_lexer_TOK_INTEGER: dq 2
section .text
section .data
__g_lexer_TOK_FLOAT: dq 3
section .text
section .data
__g_lexer_TOK_STRING: dq 4
section .text
section .data
__g_lexer_TOK_HEX: dq 5
section .text
section .data
__g_lexer_TOK_LBRACE: dq 10
section .text
section .data
__g_lexer_TOK_RBRACE: dq 11
section .text
section .data
__g_lexer_TOK_LPAREN: dq 12
section .text
section .data
__g_lexer_TOK_RPAREN: dq 13
section .text
section .data
__g_lexer_TOK_LBRACKET: dq 14
section .text
section .data
__g_lexer_TOK_RBRACKET: dq 15
section .text
section .data
__g_lexer_TOK_SEMICOLON: dq 16
section .text
section .data
__g_lexer_TOK_COLON: dq 17
section .text
section .data
__g_lexer_TOK_COMMA: dq 18
section .text
section .data
__g_lexer_TOK_DOT: dq 19
section .text
section .data
__g_lexer_TOK_ASSIGN: dq 20
section .text
section .data
__g_lexer_TOK_ARROW: dq 21
section .text
section .data
__g_lexer_TOK_DOUBLE_COLON: dq 22
section .text
section .data
__g_lexer_TOK_PLUS: dq 30
section .text
section .data
__g_lexer_TOK_MINUS: dq 31
section .text
section .data
__g_lexer_TOK_STAR: dq 32
section .text
section .data
__g_lexer_TOK_SLASH: dq 33
section .text
section .data
__g_lexer_TOK_PERCENT: dq 34
section .text
section .data
__g_lexer_TOK_AMPERSAND: dq 35
section .text
section .data
__g_lexer_TOK_PIPE: dq 36
section .text
section .data
__g_lexer_TOK_CARET: dq 37
section .text
section .data
__g_lexer_TOK_TILDE: dq 38
section .text
section .data
__g_lexer_TOK_LSHIFT: dq 39
section .text
section .data
__g_lexer_TOK_RSHIFT: dq 40
section .text
section .data
__g_lexer_TOK_EQ: dq 41
section .text
section .data
__g_lexer_TOK_NEQ: dq 42
section .text
section .data
__g_lexer_TOK_LT: dq 43
section .text
section .data
__g_lexer_TOK_GT: dq 44
section .text
section .data
__g_lexer_TOK_LTE: dq 45
section .text
section .data
__g_lexer_TOK_GTE: dq 46
section .text
section .data
__g_lexer_TOK_AND: dq 47
section .text
section .data
__g_lexer_TOK_OR: dq 48
section .text
section .data
__g_lexer_TOK_NOT: dq 49
section .text
section .data
__g_lexer_TOK_URSHIFT: dq 50
section .text
section .data
__g_lexer_TOK_PLUS_ASSIGN: dq 51
section .text
section .data
__g_lexer_TOK_MINUS_ASSIGN: dq 52
section .text
section .data
__g_lexer_TOK_STAR_ASSIGN: dq 53
section .text
section .data
__g_lexer_TOK_SLASH_ASSIGN: dq 54
section .text
section .data
__g_lexer_TOK_XOR_ASSIGN: dq 55
section .text
section .data
__g_lexer_KW_VAR: dq 100
section .text
section .data
__g_lexer_KW_CONST: dq 101
section .text
section .data
__g_lexer_KW_FN: dq 102
section .text
section .data
__g_lexer_KW_RETURN: dq 103
section .text
section .data
__g_lexer_KW_IF: dq 104
section .text
section .data
__g_lexer_KW_ELSE: dq 105
section .text
section .data
__g_lexer_KW_LOOP: dq 106
section .text
section .data
__g_lexer_KW_IN: dq 107
section .text
section .data
__g_lexer_KW_WHILE: dq 108
section .text
section .data
__g_lexer_KW_BREAK: dq 109
section .text
section .data
__g_lexer_KW_CONTINUE: dq 110
section .text
section .data
__g_lexer_KW_PRINT: dq 111
section .text
section .data
__g_lexer_KW_RANGE: dq 112
section .text
section .data
__g_lexer_KW_TRUE: dq 113
section .text
section .data
__g_lexer_KW_FALSE: dq 114
section .text
section .data
__g_lexer_KW_NULL: dq 115
section .text
section .data
__g_lexer_KW_IMPORT: dq 116
section .text
section .data
__g_lexer_KW_FROM: dq 117
section .text
section .data
__g_lexer_KW_MODULE: dq 118
section .text
section .data
__g_lexer_KW_STRUCT: dq 119
section .text
section .data
__g_lexer_KW_ENUM: dq 120
section .text
section .data
__g_lexer_KW_NEW: dq 121
section .text
section .data
__g_lexer_KW_DELETE: dq 122
section .text
section .data
__g_lexer_KW_FOR: dq 123
section .text
section .data
__g_lexer_KW_PRINTC: dq 124
section .text
section .data
__g_lexer_KW_U8: dq 130
section .text
section .data
__g_lexer_KW_U16: dq 131
section .text
section .data
__g_lexer_KW_U32: dq 132
section .text
section .data
__g_lexer_KW_U64: dq 133
section .text
section .data
__g_lexer_KW_I8: dq 134
section .text
section .data
__g_lexer_KW_I16: dq 135
section .text
section .data
__g_lexer_KW_I32: dq 136
section .text
section .data
__g_lexer_KW_I64: dq 137
section .text
section .data
__g_lexer_KW_F32: dq 138
section .text
section .data
__g_lexer_KW_F64: dq 139
section .text
section .data
__g_lexer_KW_BOOL: dq 140
section .text
section .data
__g_lexer_KW_STR: dq 141
section .text
section .data
__g_lexer_KW_VOID: dq 142
section .text
section .data
__g_lexer_KW_BOOT_SEQUENCE: dq 200
section .text
section .data
__g_lexer_KW_MMU_CONFIGURATION: dq 201
section .text
section .data
__g_lexer_KW_SCHEDULER_DOMAIN: dq 202
section .text
section .data
__g_lexer_KW_SYSCALL_DISPATCH: dq 203
section .text
section .data
__g_lexer_KW_FILESYSTEM_VOLUME: dq 204
section .text
section .data
__g_lexer_KW_NETWORK_KERNEL: dq 205
section .text
section .data
__g_lexer_KW_HARDWARE_DRIVER: dq 206
section .text
section .data
__g_lexer_KW_INTERRUPT_SERVICE: dq 207
section .text
section .data
__g_lexer_KW_DMA_CHANNEL: dq 208
section .text
section .data
__g_lexer_KW_SECURITY_RING: dq 209
section .text
section .data
__g_lexer_KW_KRON3D_CONTEXT: dq 301
section .text
section .data
__g_lexer_KW_KRON_ISA: dq 500
section .text
section .data
__g_lexer_KW_EXECUTION_MODEL: dq 502
section .text
section .data
__g_lexer_KW_KERNEL_ARCHITECTURE: dq 503
section .text
section .data
__g_lexer_KW_SECURITY_MODEL: dq 504
section .text
section .data
__g_lexer_KW_KRON_HYPERVISOR: dq 505
section .text
section .data
__g_lexer_KW_DEPLOYMENT_MODEL: dq 506
section .text
section .data
__g_lexer_KW_HUMAN_MACHINE: dq 507
section .text
section .data
__g_lexer_KW_POWER_MANAGER: dq 508
section .text
section .data
__g_lexer_KW_PACKAGE_MANAGER: dq 509
section .text
section .data
__g_lexer_KW_GLOBAL_VISIBLE: dq 510
section .text
section .data
__g_lexer_KW_DOMAIN_ISOLATED: dq 511
section .text
section .data
__g_lexer_KW_INTER_CLUSTER_EXPORT: dq 513
section .text
section .data
__g_lexer_KW_OUTB: dq 520
section .text
section .data
__g_lexer_KW_INB: dq 521
section .text
section .data
__g_lexer_KW_POKE: dq 522
section .text
section .data
__g_lexer_KW_PEEK: dq 523
section .text
section .data
__g_lexer_KW_ASM: dq 524
section .text
section .data
__g_lexer_KW_POKE8: dq 525
section .text
section .data
__g_lexer_KW_POKE16: dq 526
section .text
section .data
__g_lexer_KW_POKE32: dq 527
section .text
section .data
__g_lexer_KW_PEEK8: dq 528
section .text
section .data
__g_lexer_KW_PEEK16: dq 529
section .text
section .data
__g_lexer_KW_PEEK32: dq 530
section .text
section .data
__g_lexer_KW_EXECUTABLE_LOADER: dq 531
section .text
section .data
__g_lexer_KW_PTR: dq 532
section .text
section .data
__g_lexer_KW_CALL: dq 533
section .text
section .data
__g_lexer_KW_TRUNC: dq 534
section .text
section .data
__g_lexer_KW_SAVEFILE: dq 535
section .text
section .data
__g_lexer_KW_READKEY: dq 536
section .text
section .data
__g_lexer_KW_BEEP: dq 537
section .text
section .data
__g_lexer_KW_READMOUSE: dq 538
section .text
section .data
__g_lexer_KW_MOUSEX: dq 539
section .text
section .data
__g_lexer_KW_MOUSEY: dq 540
section .text
section .data
__g_lexer_KW_ARENA_TOKEN: dq 541
section .text
section .data
__g_lexer_KW_ROTL: dq 542
section .text
section .data
__g_lexer_KW_ROTR: dq 543
section .text
section .data
__g_lexer_KW_INVCACHE: dq 544
section .text
section .data
__g_lexer_KW_PREFETCH0: dq 545
section .text
section .data
__g_lexer_KW_KRON_PROGRAM: dq 546
section .text
section .data
__g_lexer_KW_KRON_IMPORTS: dq 547
section .text
section .data
__g_lexer_KW_KRON_DEFINITIONS: dq 548
section .text
section .data
__g_lexer_KW_KRON_DOMAIN: dq 549
section .text
section .data
__g_lexer_KW_EPOCH: dq 550
section .text
section .data
__g_lexer_KW_ALIASED: dq 551
section .text
section .data
__g_lexer_KW_SWITCH: dq 552
section .text
section .data
__g_lexer_KW_CASE: dq 553
section .text
section .data
__g_lexer_KW_DEFAULT: dq 554
section .text
section .data
__g_lexer_KW_AS: dq 555
section .text
section .data
__g_lexer_KW_FAIL: dq 556
section .text
section .data
__g_lexer_KW_HINT: dq 557
section .text
section .data
__g_lexer_KW_FAILED: dq 558
section .text
section .data
__g_lexer_KW_PRINTFAIL: dq 559
section .text
section .data
__g_lexer_KW_SIZEOF: dq 560
section .text
section .data
__g_lexer_KW_VEC2_LOAD: dq 561
section .text
section .data
__g_lexer_KW_VEC2_STORE: dq 562
section .text
section .data
__g_lexer_KW_VEC2_ADD: dq 563
section .text
section .data
__g_lexer_KW_VEC2_SUB: dq 564
section .text
section .data
__g_lexer_KW_VEC2_MUL: dq 565
section .text
section .data
__g_lexer_KW_LOADFILE: dq 566
section .text
section .data
__g_lexer_KW_THREAD_START: dq 567
section .text
section .data
__g_lexer_KW_THREAD_WAIT: dq 568
section .text
section .data
__g_lexer_KW_LOCK_INIT: dq 569
section .text
section .data
__g_lexer_KW_LOCK_TAKE: dq 570
section .text
section .data
__g_lexer_KW_LOCK_GIVE: dq 571
section .text
section .data
__g_lexer_KW_CPU_COUNT: dq 572
section .text
section .data
__g_lexer_KW_TICKS: dq 573
section .text
section .data
__g_lexer_KW_TICKS_PER_SEC: dq 574
section .text
section .data
__g_lexer_KW_RAW: dq 575
section .text
section .data
__g_lexer_KW_SLICE: dq 576
section .text
section .data
__g_lexer_KW_THREAD_YIELD: dq 577
section .text
section .data
__g_lexer_KW_SHARED: dq 578
section .text
section .data
__g_lexer_KW_DLL_LOAD: dq 579
section .text
section .data
__g_lexer_KW_DLL_PROC: dq 580
section .text
section .data
__g_lexer_KW_ARG_COUNT: dq 581
section .text
section .data
__g_lexer_KW_ARG_GET: dq 582
section .text
section .data
__g_lexer_KW_TARGET_OS: dq 583
section .text
section .data
__g_lexer_KW_EXTERN: dq 584
section .text
section .data
__g_lexer_KLX_TOKEN_SIZE: dq 24
section .text
section .data
__g_lexer_KLX_KW_MAX: dq 192
section .text
section .data
__g_lexer_KLX_ERR_CHAR: dq 1
section .text
section .data
__g_lexer_KLX_ERR_TEXT: dq 2
section .text
section .data
__g_lexer_KLX_ERR_FULL: dq 3
section .text
section .data
__g_lexer_klx_src: dq 0
section .text
section .data
__g_lexer_klx_len: dq 0
section .text
section .data
__g_lexer_klx_pos: dq 0
section .text
section .data
__g_lexer_klx_line: dq 0
section .text
section .data
__g_lexer_klx_col: dq 0
section .text
section .data
__g_lexer_klx_tok_line: dq 0
section .text
section .data
__g_lexer_klx_tok_col: dq 0
section .text
section .data
__g_lexer_klx_buf: dq 0
section .text
section .data
__g_lexer_klx_cap: dq 0
section .text
section .data
__g_lexer_klx_count_ptr: dq 0
section .text
section .bss
__g_lexer_klx_kw_text: resq 192
section .text
section .bss
__g_lexer_klx_kw_len: resq 192
section .text
section .bss
__g_lexer_klx_kw_type: resq 192
section .text
section .data
__g_lexer_klx_kw_n: dq 0
section .text
section .data
__g_lexer_klx_err_kind: dq 0
section .text
section .bss
__g_lexer_klx_err_tok: resq 3
section .text
klx_kw:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0
    mov r12, rax
    mov rax, [rel __g_lexer_klx_kw_n]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_lexer_KLX_KW_MAX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L1
    mov rax, 0
    jmp .__ret_0
    jmp .L2
.L1:
.L2:
.L3:
    mov rax, r14
    add rax, r12
    movzx rax, byte [rax]
    cmp rax, 0
    je .L4
    add r12, 1
.L5:
    jmp .L3
.L4:
    lea rax, [rel __g_lexer_klx_kw_text]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r14
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    lea rax, [rel __g_lexer_klx_kw_len]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    lea rax, [rel __g_lexer_klx_kw_type]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    add rax, 1
    mov [rel __g_lexer_klx_kw_n], rax
    mov rax, 1
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
klx_kw_fill:
    push rbp
    mov rbp, rsp
    sub rsp, 32
section .data
.str7: db 118,97,114,0
section .text
    lea rax, [rel .str7]
    push rax
    mov rax, [rel __g_lexer_KW_VAR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str8: db 99,111,110,115,116,0
section .text
    lea rax, [rel .str8]
    push rax
    mov rax, [rel __g_lexer_KW_CONST]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str9: db 102,110,0
section .text
    lea rax, [rel .str9]
    push rax
    mov rax, [rel __g_lexer_KW_FN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str10: db 114,101,116,117,114,110,0
section .text
    lea rax, [rel .str10]
    push rax
    mov rax, [rel __g_lexer_KW_RETURN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str11: db 105,102,0
section .text
    lea rax, [rel .str11]
    push rax
    mov rax, [rel __g_lexer_KW_IF]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str12: db 101,108,115,101,0
section .text
    lea rax, [rel .str12]
    push rax
    mov rax, [rel __g_lexer_KW_ELSE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str13: db 115,119,105,116,99,104,0
section .text
    lea rax, [rel .str13]
    push rax
    mov rax, [rel __g_lexer_KW_SWITCH]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str14: db 99,97,115,101,0
section .text
    lea rax, [rel .str14]
    push rax
    mov rax, [rel __g_lexer_KW_CASE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str15: db 100,101,102,97,117,108,116,0
section .text
    lea rax, [rel .str15]
    push rax
    mov rax, [rel __g_lexer_KW_DEFAULT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str16: db 108,111,111,112,0
section .text
    lea rax, [rel .str16]
    push rax
    mov rax, [rel __g_lexer_KW_LOOP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str17: db 105,110,0
section .text
    lea rax, [rel .str17]
    push rax
    mov rax, [rel __g_lexer_KW_IN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str18: db 119,104,105,108,101,0
section .text
    lea rax, [rel .str18]
    push rax
    mov rax, [rel __g_lexer_KW_WHILE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str19: db 102,111,114,0
section .text
    lea rax, [rel .str19]
    push rax
    mov rax, [rel __g_lexer_KW_FOR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str20: db 98,114,101,97,107,0
section .text
    lea rax, [rel .str20]
    push rax
    mov rax, [rel __g_lexer_KW_BREAK]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str21: db 99,111,110,116,105,110,117,101,0
section .text
    lea rax, [rel .str21]
    push rax
    mov rax, [rel __g_lexer_KW_CONTINUE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str22: db 114,97,119,0
section .text
    lea rax, [rel .str22]
    push rax
    mov rax, [rel __g_lexer_KW_RAW]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str23: db 115,108,105,99,101,0
section .text
    lea rax, [rel .str23]
    push rax
    mov rax, [rel __g_lexer_KW_SLICE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str24: db 112,114,105,110,116,0
section .text
    lea rax, [rel .str24]
    push rax
    mov rax, [rel __g_lexer_KW_PRINT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str25: db 112,114,105,110,116,99,0
section .text
    lea rax, [rel .str25]
    push rax
    mov rax, [rel __g_lexer_KW_PRINTC]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str26: db 114,97,110,103,101,0
section .text
    lea rax, [rel .str26]
    push rax
    mov rax, [rel __g_lexer_KW_RANGE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str27: db 116,114,117,101,0
section .text
    lea rax, [rel .str27]
    push rax
    mov rax, [rel __g_lexer_KW_TRUE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str28: db 102,97,108,115,101,0
section .text
    lea rax, [rel .str28]
    push rax
    mov rax, [rel __g_lexer_KW_FALSE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str29: db 110,117,108,108,0
section .text
    lea rax, [rel .str29]
    push rax
    mov rax, [rel __g_lexer_KW_NULL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str30: db 105,109,112,111,114,116,0
section .text
    lea rax, [rel .str30]
    push rax
    mov rax, [rel __g_lexer_KW_IMPORT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str31: db 102,114,111,109,0
section .text
    lea rax, [rel .str31]
    push rax
    mov rax, [rel __g_lexer_KW_FROM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str32: db 109,111,100,117,108,101,0
section .text
    lea rax, [rel .str32]
    push rax
    mov rax, [rel __g_lexer_KW_MODULE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str33: db 115,116,114,117,99,116,0
section .text
    lea rax, [rel .str33]
    push rax
    mov rax, [rel __g_lexer_KW_STRUCT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str34: db 101,110,117,109,0
section .text
    lea rax, [rel .str34]
    push rax
    mov rax, [rel __g_lexer_KW_ENUM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str35: db 110,101,119,0
section .text
    lea rax, [rel .str35]
    push rax
    mov rax, [rel __g_lexer_KW_NEW]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str36: db 100,101,108,101,116,101,0
section .text
    lea rax, [rel .str36]
    push rax
    mov rax, [rel __g_lexer_KW_DELETE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str37: db 117,105,110,116,56,0
section .text
    lea rax, [rel .str37]
    push rax
    mov rax, [rel __g_lexer_KW_U8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str38: db 117,105,110,116,49,54,0
section .text
    lea rax, [rel .str38]
    push rax
    mov rax, [rel __g_lexer_KW_U16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str39: db 117,105,110,116,51,50,0
section .text
    lea rax, [rel .str39]
    push rax
    mov rax, [rel __g_lexer_KW_U32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str40: db 117,105,110,116,54,52,0
section .text
    lea rax, [rel .str40]
    push rax
    mov rax, [rel __g_lexer_KW_U64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str41: db 105,110,116,56,0
section .text
    lea rax, [rel .str41]
    push rax
    mov rax, [rel __g_lexer_KW_I8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str42: db 105,110,116,49,54,0
section .text
    lea rax, [rel .str42]
    push rax
    mov rax, [rel __g_lexer_KW_I16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str43: db 105,110,116,51,50,0
section .text
    lea rax, [rel .str43]
    push rax
    mov rax, [rel __g_lexer_KW_I32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str44: db 105,110,116,54,52,0
section .text
    lea rax, [rel .str44]
    push rax
    mov rax, [rel __g_lexer_KW_I64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str45: db 105,56,0
section .text
    lea rax, [rel .str45]
    push rax
    mov rax, [rel __g_lexer_KW_I8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str46: db 105,49,54,0
section .text
    lea rax, [rel .str46]
    push rax
    mov rax, [rel __g_lexer_KW_I16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str47: db 105,51,50,0
section .text
    lea rax, [rel .str47]
    push rax
    mov rax, [rel __g_lexer_KW_I32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str48: db 105,54,52,0
section .text
    lea rax, [rel .str48]
    push rax
    mov rax, [rel __g_lexer_KW_I64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str49: db 117,56,0
section .text
    lea rax, [rel .str49]
    push rax
    mov rax, [rel __g_lexer_KW_U8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str50: db 117,49,54,0
section .text
    lea rax, [rel .str50]
    push rax
    mov rax, [rel __g_lexer_KW_U16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str51: db 117,51,50,0
section .text
    lea rax, [rel .str51]
    push rax
    mov rax, [rel __g_lexer_KW_U32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str52: db 117,54,52,0
section .text
    lea rax, [rel .str52]
    push rax
    mov rax, [rel __g_lexer_KW_U64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str53: db 102,51,50,0
section .text
    lea rax, [rel .str53]
    push rax
    mov rax, [rel __g_lexer_KW_F32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str54: db 102,54,52,0
section .text
    lea rax, [rel .str54]
    push rax
    mov rax, [rel __g_lexer_KW_F64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str55: db 98,111,111,108,0
section .text
    lea rax, [rel .str55]
    push rax
    mov rax, [rel __g_lexer_KW_BOOL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str56: db 114,101,97,108,51,50,0
section .text
    lea rax, [rel .str56]
    push rax
    mov rax, [rel __g_lexer_KW_F32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str57: db 114,101,97,108,54,52,0
section .text
    lea rax, [rel .str57]
    push rax
    mov rax, [rel __g_lexer_KW_F64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str58: db 104,97,114,100,119,97,114,101,95,98,105,116,0
section .text
    lea rax, [rel .str58]
    push rax
    mov rax, [rel __g_lexer_KW_BOOL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str59: db 117,116,102,56,95,115,116,114,101,97,109,0
section .text
    lea rax, [rel .str59]
    push rax
    mov rax, [rel __g_lexer_KW_STR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str60: db 115,116,114,101,97,109,0
section .text
    lea rax, [rel .str60]
    push rax
    mov rax, [rel __g_lexer_KW_STR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str61: db 97,115,0
section .text
    lea rax, [rel .str61]
    push rax
    mov rax, [rel __g_lexer_KW_AS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str62: db 102,97,105,108,0
section .text
    lea rax, [rel .str62]
    push rax
    mov rax, [rel __g_lexer_KW_FAIL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str63: db 104,105,110,116,0
section .text
    lea rax, [rel .str63]
    push rax
    mov rax, [rel __g_lexer_KW_HINT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str64: db 102,97,105,108,101,100,0
section .text
    lea rax, [rel .str64]
    push rax
    mov rax, [rel __g_lexer_KW_FAILED]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str65: db 112,114,105,110,116,95,102,97,105,108,0
section .text
    lea rax, [rel .str65]
    push rax
    mov rax, [rel __g_lexer_KW_PRINTFAIL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str66: db 115,105,122,101,111,102,0
section .text
    lea rax, [rel .str66]
    push rax
    mov rax, [rel __g_lexer_KW_SIZEOF]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str67: db 108,111,97,100,102,105,108,101,0
section .text
    lea rax, [rel .str67]
    push rax
    mov rax, [rel __g_lexer_KW_LOADFILE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str68: db 116,104,114,101,97,100,95,115,116,97,114,116,0
section .text
    lea rax, [rel .str68]
    push rax
    mov rax, [rel __g_lexer_KW_THREAD_START]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str69: db 116,104,114,101,97,100,95,119,97,105,116,0
section .text
    lea rax, [rel .str69]
    push rax
    mov rax, [rel __g_lexer_KW_THREAD_WAIT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str70: db 108,111,99,107,95,105,110,105,116,0
section .text
    lea rax, [rel .str70]
    push rax
    mov rax, [rel __g_lexer_KW_LOCK_INIT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str71: db 108,111,99,107,95,116,97,107,101,0
section .text
    lea rax, [rel .str71]
    push rax
    mov rax, [rel __g_lexer_KW_LOCK_TAKE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str72: db 108,111,99,107,95,103,105,118,101,0
section .text
    lea rax, [rel .str72]
    push rax
    mov rax, [rel __g_lexer_KW_LOCK_GIVE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str73: db 99,112,117,95,99,111,117,110,116,0
section .text
    lea rax, [rel .str73]
    push rax
    mov rax, [rel __g_lexer_KW_CPU_COUNT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str74: db 116,104,114,101,97,100,95,121,105,101,108,100,0
section .text
    lea rax, [rel .str74]
    push rax
    mov rax, [rel __g_lexer_KW_THREAD_YIELD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str75: db 115,104,97,114,101,100,0
section .text
    lea rax, [rel .str75]
    push rax
    mov rax, [rel __g_lexer_KW_SHARED]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str76: db 100,108,108,95,108,111,97,100,0
section .text
    lea rax, [rel .str76]
    push rax
    mov rax, [rel __g_lexer_KW_DLL_LOAD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str77: db 100,108,108,95,112,114,111,99,0
section .text
    lea rax, [rel .str77]
    push rax
    mov rax, [rel __g_lexer_KW_DLL_PROC]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str78: db 97,114,103,95,99,111,117,110,116,0
section .text
    lea rax, [rel .str78]
    push rax
    mov rax, [rel __g_lexer_KW_ARG_COUNT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str79: db 97,114,103,95,103,101,116,0
section .text
    lea rax, [rel .str79]
    push rax
    mov rax, [rel __g_lexer_KW_ARG_GET]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str80: db 116,97,114,103,101,116,95,111,115,0
section .text
    lea rax, [rel .str80]
    push rax
    mov rax, [rel __g_lexer_KW_TARGET_OS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str81: db 116,105,99,107,115,0
section .text
    lea rax, [rel .str81]
    push rax
    mov rax, [rel __g_lexer_KW_TICKS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str82: db 116,105,99,107,115,95,112,101,114,95,115,101,99,0
section .text
    lea rax, [rel .str82]
    push rax
    mov rax, [rel __g_lexer_KW_TICKS_PER_SEC]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str83: db 118,101,99,50,95,108,111,97,100,0
section .text
    lea rax, [rel .str83]
    push rax
    mov rax, [rel __g_lexer_KW_VEC2_LOAD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str84: db 118,101,99,50,95,115,116,111,114,101,0
section .text
    lea rax, [rel .str84]
    push rax
    mov rax, [rel __g_lexer_KW_VEC2_STORE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str85: db 118,101,99,50,95,97,100,100,0
section .text
    lea rax, [rel .str85]
    push rax
    mov rax, [rel __g_lexer_KW_VEC2_ADD]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str86: db 118,101,99,50,95,115,117,98,0
section .text
    lea rax, [rel .str86]
    push rax
    mov rax, [rel __g_lexer_KW_VEC2_SUB]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str87: db 118,101,99,50,95,109,117,108,0
section .text
    lea rax, [rel .str87]
    push rax
    mov rax, [rel __g_lexer_KW_VEC2_MUL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str88: db 118,111,105,100,0
section .text
    lea rax, [rel .str88]
    push rax
    mov rax, [rel __g_lexer_KW_VOID]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str89: db 98,111,111,116,0
section .text
    lea rax, [rel .str89]
    push rax
    mov rax, [rel __g_lexer_KW_BOOT_SEQUENCE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str90: db 109,109,117,0
section .text
    lea rax, [rel .str90]
    push rax
    mov rax, [rel __g_lexer_KW_MMU_CONFIGURATION]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str91: db 115,99,104,101,100,117,108,101,114,0
section .text
    lea rax, [rel .str91]
    push rax
    mov rax, [rel __g_lexer_KW_SCHEDULER_DOMAIN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str92: db 115,121,115,99,97,108,108,115,0
section .text
    lea rax, [rel .str92]
    push rax
    mov rax, [rel __g_lexer_KW_SYSCALL_DISPATCH]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str93: db 102,105,108,101,115,121,115,116,101,109,0
section .text
    lea rax, [rel .str93]
    push rax
    mov rax, [rel __g_lexer_KW_FILESYSTEM_VOLUME]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str94: db 110,101,116,107,101,114,110,101,108,0
section .text
    lea rax, [rel .str94]
    push rax
    mov rax, [rel __g_lexer_KW_NETWORK_KERNEL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str95: db 100,114,105,118,101,114,0
section .text
    lea rax, [rel .str95]
    push rax
    mov rax, [rel __g_lexer_KW_HARDWARE_DRIVER]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str96: db 105,115,114,0
section .text
    lea rax, [rel .str96]
    push rax
    mov rax, [rel __g_lexer_KW_INTERRUPT_SERVICE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str97: db 100,109,97,0
section .text
    lea rax, [rel .str97]
    push rax
    mov rax, [rel __g_lexer_KW_DMA_CHANNEL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str98: db 107,114,111,110,51,100,95,99,111,110,116,101,120,116,0
section .text
    lea rax, [rel .str98]
    push rax
    mov rax, [rel __g_lexer_KW_KRON3D_CONTEXT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str99: db 107,114,111,110,95,105,115,97,95,100,121,110,97,109,105,99,0
section .text
    lea rax, [rel .str99]
    push rax
    mov rax, [rel __g_lexer_KW_KRON_ISA]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str100: db 101,120,101,99,117,116,105,111,110,0
section .text
    lea rax, [rel .str100]
    push rax
    mov rax, [rel __g_lexer_KW_EXECUTION_MODEL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str101: db 107,101,114,110,101,108,0
section .text
    lea rax, [rel .str101]
    push rax
    mov rax, [rel __g_lexer_KW_KERNEL_ARCHITECTURE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str102: db 115,101,99,117,114,105,116,121,0
section .text
    lea rax, [rel .str102]
    push rax
    mov rax, [rel __g_lexer_KW_SECURITY_MODEL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str103: db 107,114,111,110,95,104,121,112,101,114,118,105,115,111,114,0
section .text
    lea rax, [rel .str103]
    push rax
    mov rax, [rel __g_lexer_KW_KRON_HYPERVISOR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str104: db 100,101,112,108,111,121,109,101,110,116,0
section .text
    lea rax, [rel .str104]
    push rax
    mov rax, [rel __g_lexer_KW_DEPLOYMENT_MODEL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str105: db 104,109,105,0
section .text
    lea rax, [rel .str105]
    push rax
    mov rax, [rel __g_lexer_KW_HUMAN_MACHINE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str106: db 112,111,119,101,114,0
section .text
    lea rax, [rel .str106]
    push rax
    mov rax, [rel __g_lexer_KW_POWER_MANAGER]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str107: db 112,97,99,107,97,103,101,115,0
section .text
    lea rax, [rel .str107]
    push rax
    mov rax, [rel __g_lexer_KW_PACKAGE_MANAGER]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str108: db 108,111,97,100,101,114,0
section .text
    lea rax, [rel .str108]
    push rax
    mov rax, [rel __g_lexer_KW_EXECUTABLE_LOADER]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str109: db 114,105,110,103,0
section .text
    lea rax, [rel .str109]
    push rax
    mov rax, [rel __g_lexer_KW_SECURITY_RING]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str110: db 111,117,116,98,0
section .text
    lea rax, [rel .str110]
    push rax
    mov rax, [rel __g_lexer_KW_OUTB]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str111: db 105,110,98,0
section .text
    lea rax, [rel .str111]
    push rax
    mov rax, [rel __g_lexer_KW_INB]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str112: db 112,111,107,101,0
section .text
    lea rax, [rel .str112]
    push rax
    mov rax, [rel __g_lexer_KW_POKE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str113: db 112,101,101,107,0
section .text
    lea rax, [rel .str113]
    push rax
    mov rax, [rel __g_lexer_KW_PEEK]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str114: db 116,114,117,110,99,0
section .text
    lea rax, [rel .str114]
    push rax
    mov rax, [rel __g_lexer_KW_TRUNC]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str115: db 115,97,118,101,102,105,108,101,0
section .text
    lea rax, [rel .str115]
    push rax
    mov rax, [rel __g_lexer_KW_SAVEFILE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str116: db 114,101,97,100,107,101,121,0
section .text
    lea rax, [rel .str116]
    push rax
    mov rax, [rel __g_lexer_KW_READKEY]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str117: db 98,101,101,112,0
section .text
    lea rax, [rel .str117]
    push rax
    mov rax, [rel __g_lexer_KW_BEEP]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str118: db 114,101,97,100,109,111,117,115,101,0
section .text
    lea rax, [rel .str118]
    push rax
    mov rax, [rel __g_lexer_KW_READMOUSE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str119: db 109,111,117,115,101,120,0
section .text
    lea rax, [rel .str119]
    push rax
    mov rax, [rel __g_lexer_KW_MOUSEX]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str120: db 109,111,117,115,101,121,0
section .text
    lea rax, [rel .str120]
    push rax
    mov rax, [rel __g_lexer_KW_MOUSEY]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str121: db 97,115,109,0
section .text
    lea rax, [rel .str121]
    push rax
    mov rax, [rel __g_lexer_KW_ASM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str122: db 112,116,114,0
section .text
    lea rax, [rel .str122]
    push rax
    mov rax, [rel __g_lexer_KW_PTR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str123: db 65,114,101,110,97,65,108,108,111,99,97,116,105,111,110,84,111,107,101,110,0
section .text
    lea rax, [rel .str123]
    push rax
    mov rax, [rel __g_lexer_KW_ARENA_TOKEN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str124: db 114,111,116,108,0
section .text
    lea rax, [rel .str124]
    push rax
    mov rax, [rel __g_lexer_KW_ROTL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str125: db 114,111,116,114,0
section .text
    lea rax, [rel .str125]
    push rax
    mov rax, [rel __g_lexer_KW_ROTR]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str126: db 105,110,118,99,97,99,104,101,0
section .text
    lea rax, [rel .str126]
    push rax
    mov rax, [rel __g_lexer_KW_INVCACHE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str127: db 112,114,101,102,101,116,99,104,0
section .text
    lea rax, [rel .str127]
    push rax
    mov rax, [rel __g_lexer_KW_PREFETCH0]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str128: db 114,101,103,105,115,116,101,114,56,0
section .text
    lea rax, [rel .str128]
    push rax
    mov rax, [rel __g_lexer_KW_U8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str129: db 114,101,103,105,115,116,101,114,49,54,0
section .text
    lea rax, [rel .str129]
    push rax
    mov rax, [rel __g_lexer_KW_U16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str130: db 114,101,103,105,115,116,101,114,51,50,0
section .text
    lea rax, [rel .str130]
    push rax
    mov rax, [rel __g_lexer_KW_U32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str131: db 114,101,103,105,115,116,101,114,54,52,0
section .text
    lea rax, [rel .str131]
    push rax
    mov rax, [rel __g_lexer_KW_U64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str132: db 112,104,121,115,105,99,97,108,95,112,116,114,0
section .text
    lea rax, [rel .str132]
    push rax
    mov rax, [rel __g_lexer_KW_U64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str133: db 118,105,114,116,117,97,108,95,112,116,114,0
section .text
    lea rax, [rel .str133]
    push rax
    mov rax, [rel __g_lexer_KW_U64]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str134: db 107,114,111,110,95,112,114,111,103,114,97,109,0
section .text
    lea rax, [rel .str134]
    push rax
    mov rax, [rel __g_lexer_KW_KRON_PROGRAM]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str135: db 107,114,111,110,95,105,109,112,111,114,116,115,0
section .text
    lea rax, [rel .str135]
    push rax
    mov rax, [rel __g_lexer_KW_KRON_IMPORTS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str136: db 107,114,111,110,95,100,101,102,105,110,105,116,105,111,110,115,0
section .text
    lea rax, [rel .str136]
    push rax
    mov rax, [rel __g_lexer_KW_KRON_DEFINITIONS]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str137: db 107,114,111,110,95,100,111,109,97,105,110,0
section .text
    lea rax, [rel .str137]
    push rax
    mov rax, [rel __g_lexer_KW_KRON_DOMAIN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str138: db 101,112,111,99,104,0
section .text
    lea rax, [rel .str138]
    push rax
    mov rax, [rel __g_lexer_KW_EPOCH]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str139: db 97,108,105,97,115,101,100,0
section .text
    lea rax, [rel .str139]
    push rax
    mov rax, [rel __g_lexer_KW_ALIASED]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str140: db 112,111,107,101,56,0
section .text
    lea rax, [rel .str140]
    push rax
    mov rax, [rel __g_lexer_KW_POKE8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str141: db 112,111,107,101,49,54,0
section .text
    lea rax, [rel .str141]
    push rax
    mov rax, [rel __g_lexer_KW_POKE16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str142: db 112,111,107,101,51,50,0
section .text
    lea rax, [rel .str142]
    push rax
    mov rax, [rel __g_lexer_KW_POKE32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str143: db 112,101,101,107,56,0
section .text
    lea rax, [rel .str143]
    push rax
    mov rax, [rel __g_lexer_KW_PEEK8]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str144: db 112,101,101,107,49,54,0
section .text
    lea rax, [rel .str144]
    push rax
    mov rax, [rel __g_lexer_KW_PEEK16]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str145: db 112,101,101,107,51,50,0
section .text
    lea rax, [rel .str145]
    push rax
    mov rax, [rel __g_lexer_KW_PEEK32]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str146: db 112,117,98,108,105,99,0
section .text
    lea rax, [rel .str146]
    push rax
    mov rax, [rel __g_lexer_KW_GLOBAL_VISIBLE]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str147: db 112,114,105,118,97,116,101,0
section .text
    lea rax, [rel .str147]
    push rax
    mov rax, [rel __g_lexer_KW_DOMAIN_ISOLATED]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str148: db 101,120,112,111,114,116,0
section .text
    lea rax, [rel .str148]
    push rax
    mov rax, [rel __g_lexer_KW_INTER_CLUSTER_EXPORT]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str149: db 99,97,108,108,0
section .text
    lea rax, [rel .str149]
    push rax
    mov rax, [rel __g_lexer_KW_CALL]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
section .data
.str150: db 101,120,116,101,114,110,0
section .text
    lea rax, [rel .str150]
    push rax
    mov rax, [rel __g_lexer_KW_EXTERN]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_kw
    add rsp, 32
    mov rax, [rel __g_lexer_klx_kw_n]
    jmp .__ret_6
.__ret_6:
    mov rsp, rbp
    pop rbp
    ret
klx_keyword:
    push rbp
    mov rbp, rsp
    sub rsp, 144
    mov [rbp-112], rbx
    mov [rbp-104], r12
    mov [rbp-96], r13
    mov [rbp-88], r14
    mov [rbp-80], r15
    mov [rbp-8], rcx
    mov [rbp-16], rdx
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    movzx rax, byte [rax]
    mov r12, rax
.L152:
    mov rax, r15
    push rax
    mov rax, [rel __g_lexer_klx_kw_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L153
    lea rax, [rel __g_lexer_klx_kw_len]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov rcx, [rbp-16]
    cmp rax, rcx
    jne .L155
    lea rax, [rel __g_lexer_klx_kw_text]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    mov r13, rax
    mov rax, r13
    movzx rax, byte [rax]
    cmp rax, r12
    jne .L157
    mov rax, 1
    mov rbx, rax
    mov rax, 1
    mov r14, rax
.L159:
    mov rax, r14
    mov rcx, [rbp-16]
    cmp rax, rcx
    jge .L160
    mov rax, r13
    add rax, r14
    movzx rax, byte [rax]
    push rax
    mov rax, [rbp-8]
    add rax, r14
    movzx rax, byte [rax]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L162
    mov rax, 0
    mov rbx, rax
    jmp .L160
    jmp .L163
.L162:
.L163:
    add r14, 1
.L161:
    jmp .L159
.L160:
    cmp rbx, 1
    jne .L164
    lea rax, [rel __g_lexer_klx_kw_type]
    push rax
    mov rax, r15
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    jmp .__ret_151
    jmp .L165
.L164:
.L165:
    jmp .L158
.L157:
.L158:
    jmp .L156
.L155:
.L156:
    add r15, 1
.L154:
    jmp .L152
.L153:
    mov rax, [rel __g_lexer_TOK_IDENTIFIER]
    jmp .__ret_151
.__ret_151:
    mov rbx, [rbp-112]
    mov r12, [rbp-104]
    mov r13, [rbp-96]
    mov r14, [rbp-88]
    mov r15, [rbp-80]
    mov rsp, rbp
    pop rbp
    ret
klx_keyword_name:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
.L167:
    mov rax, rbx
    push rax
    mov rax, [rel __g_lexer_klx_kw_n]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L168
    lea rax, [rel __g_lexer_klx_kw_type]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    cmp rax, r12
    jne .L170
    lea rax, [rel __g_lexer_klx_kw_text]
    push rax
    mov rax, rbx
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rax, [rax]
    jmp .__ret_166
    jmp .L171
.L170:
.L171:
    add rbx, 1
.L169:
    jmp .L167
.L168:
    mov rax, 0
    jmp .__ret_166
.__ret_166:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
klx_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rax, r12
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L173
    mov rax, [rel __g_lexer_klx_src]
    add rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    jmp .L174
.L173:
.L174:
    mov rax, rbx
    jmp .__ret_172
.__ret_172:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
klx_is_letter:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 95
    jne .L176
    mov rax, 1
    jmp .__ret_175
    jmp .L177
.L176:
.L177:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L180
    mov rax, rbx
    mov rcx, 122
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L180
    mov rax, 1
    jmp .L181
.L180:
    mov rax, 0
.L181:
    test rax, rax
    jz .L178
    mov rax, 1
    jmp .__ret_175
    jmp .L179
.L178:
.L179:
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L184
    mov rax, rbx
    mov rcx, 90
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L184
    mov rax, 1
    jmp .L185
.L184:
    mov rax, 0
.L185:
    test rax, rax
    jz .L182
    mov rax, 1
    jmp .__ret_175
    jmp .L183
.L182:
.L183:
    mov rax, 0
    jmp .__ret_175
.__ret_175:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
klx_is_digit:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L189
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L189
    mov rax, 1
    jmp .L190
.L189:
    mov rax, 0
.L190:
    test rax, rax
    jz .L187
    mov rax, 1
    jmp .__ret_186
    jmp .L188
.L187:
.L188:
    mov rax, 0
    jmp .__ret_186
.__ret_186:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
klx_is_hex:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L194
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L194
    mov rax, 1
    jmp .L195
.L194:
    mov rax, 0
.L195:
    test rax, rax
    jz .L192
    mov rax, 1
    jmp .__ret_191
    jmp .L193
.L192:
.L193:
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L198
    mov rax, rbx
    mov rcx, 102
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L198
    mov rax, 1
    jmp .L199
.L198:
    mov rax, 0
.L199:
    test rax, rax
    jz .L196
    mov rax, 1
    jmp .__ret_191
    jmp .L197
.L196:
.L197:
    mov rax, rbx
    mov rcx, 65
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L202
    mov rax, rbx
    mov rcx, 70
    cmp rax, rcx
    setle al
    movzx rax, al
    test rax, rax
    jz .L202
    mov rax, 1
    jmp .L203
.L202:
    mov rax, 0
.L203:
    test rax, rax
    jz .L200
    mov rax, 1
    jmp .__ret_191
    jmp .L201
.L200:
.L201:
    mov rax, 0
    jmp .__ret_191
.__ret_191:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
klx_skip:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
.L205:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L206
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 32
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L210
    mov rax, rbx
    mov rcx, 9
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L210
    mov rax, 0
    jmp .L211
.L210:
    mov rax, 1
.L211:
    test rax, rax
    jz .L208
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_col]
    add rax, 1
    mov [rel __g_lexer_klx_col], rax
    jmp .L209
.L208:
    cmp rbx, 13
    jne .L212
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    jmp .L213
.L212:
    cmp rbx, 10
    jne .L214
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_line]
    add rax, 1
    mov [rel __g_lexer_klx_line], rax
    mov rax, 1
    mov [rel __g_lexer_klx_col], rax
    jmp .L215
.L214:
    mov rax, rbx
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L218
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rcx, 47
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L218
    mov rax, 1
    jmp .L219
.L218:
    mov rax, 0
.L219:
    test rax, rax
    jz .L216
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
.L220:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L223
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rcx, 10
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L223
    mov rax, 1
    jmp .L224
.L223:
    mov rax, 0
.L224:
    test rax, rax
    jz .L221
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
.L222:
    jmp .L220
.L221:
    jmp .L217
.L216:
    mov rax, 0
    jmp .__ret_204
.L217:
.L215:
.L213:
.L209:
.L207:
    jmp .L205
.L206:
    mov rax, 0
    jmp .__ret_204
.__ret_204:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
klx_number:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L226:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L227
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov r12, rax
    mov rcx, r12
    sub rsp, 32
    call klx_is_digit
    add rsp, 32
    cmp rax, 1
    jne .L229
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_col]
    add rax, 1
    mov [rel __g_lexer_klx_col], rax
    jmp .L230
.L229:
    cmp r12, 46
    jne .L231
    mov rax, 1
    mov r13, rax
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    jmp .L232
.L231:
    mov rax, r12
    mov rcx, 101
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L235
    mov rax, r12
    mov rcx, 69
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L235
    mov rax, 0
    jmp .L236
.L235:
    mov rax, 1
.L236:
    test rax, rax
    jz .L233
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov rbx, rax
    mov rcx, rbx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov r12, rax
    mov rax, r12
    mov rcx, 43
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L239
    mov rax, r12
    mov rcx, 45
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L239
    mov rax, 0
    jmp .L240
.L239:
    mov rax, 1
.L240:
    test rax, rax
    jz .L237
    add rbx, 1
    mov rcx, rbx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov r12, rax
    jmp .L238
.L237:
.L238:
    mov rcx, r12
    sub rsp, 32
    call klx_is_digit
    add rsp, 32
    cmp rax, 0
    jne .L241
    jmp .L227
    jmp .L242
.L241:
.L242:
    mov rax, 1
    mov r13, rax
    mov rax, rbx
    mov [rel __g_lexer_klx_pos], rax
.L243:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call klx_is_digit
    add rsp, 32
    cmp rax, 1
    jne .L244
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
.L245:
    jmp .L243
.L244:
    jmp .L227
    jmp .L234
.L233:
    jmp .L227
.L234:
.L232:
.L230:
.L228:
    jmp .L226
.L227:
    cmp r13, 1
    jne .L246
    mov rax, [rel __g_lexer_TOK_FLOAT]
    jmp .__ret_225
    jmp .L247
.L246:
.L247:
    mov rax, [rel __g_lexer_TOK_INTEGER]
    jmp .__ret_225
.__ret_225:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
klx_punct:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rbx, rax
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_col]
    add rax, 1
    mov [rel __g_lexer_klx_col], rax
    cmp r12, 123
    jne .L249
    mov rax, [rel __g_lexer_TOK_LBRACE]
    jmp .__ret_248
    jmp .L250
.L249:
.L250:
    cmp r12, 125
    jne .L251
    mov rax, [rel __g_lexer_TOK_RBRACE]
    jmp .__ret_248
    jmp .L252
.L251:
.L252:
    cmp r12, 40
    jne .L253
    mov rax, [rel __g_lexer_TOK_LPAREN]
    jmp .__ret_248
    jmp .L254
.L253:
.L254:
    cmp r12, 41
    jne .L255
    mov rax, [rel __g_lexer_TOK_RPAREN]
    jmp .__ret_248
    jmp .L256
.L255:
.L256:
    cmp r12, 91
    jne .L257
    mov rax, [rel __g_lexer_TOK_LBRACKET]
    jmp .__ret_248
    jmp .L258
.L257:
.L258:
    cmp r12, 93
    jne .L259
    mov rax, [rel __g_lexer_TOK_RBRACKET]
    jmp .__ret_248
    jmp .L260
.L259:
.L260:
    cmp r12, 59
    jne .L261
    mov rax, [rel __g_lexer_TOK_SEMICOLON]
    jmp .__ret_248
    jmp .L262
.L261:
.L262:
    cmp r12, 44
    jne .L263
    mov rax, [rel __g_lexer_TOK_COMMA]
    jmp .__ret_248
    jmp .L264
.L263:
.L264:
    cmp r12, 46
    jne .L265
    mov rax, [rel __g_lexer_TOK_DOT]
    jmp .__ret_248
    jmp .L266
.L265:
.L266:
    cmp r12, 37
    jne .L267
    mov rax, [rel __g_lexer_TOK_PERCENT]
    jmp .__ret_248
    jmp .L268
.L267:
.L268:
    cmp r12, 126
    jne .L269
    mov rax, [rel __g_lexer_TOK_TILDE]
    jmp .__ret_248
    jmp .L270
.L269:
.L270:
    cmp r12, 43
    jne .L271
    cmp rbx, 61
    jne .L273
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_PLUS_ASSIGN]
    jmp .__ret_248
    jmp .L274
.L273:
.L274:
    mov rax, [rel __g_lexer_TOK_PLUS]
    jmp .__ret_248
    jmp .L272
.L271:
.L272:
    cmp r12, 45
    jne .L275
    cmp rbx, 61
    jne .L277
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_MINUS_ASSIGN]
    jmp .__ret_248
    jmp .L278
.L277:
.L278:
    cmp rbx, 62
    jne .L279
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_ARROW]
    jmp .__ret_248
    jmp .L280
.L279:
.L280:
    mov rax, [rel __g_lexer_TOK_MINUS]
    jmp .__ret_248
    jmp .L276
.L275:
.L276:
    cmp r12, 42
    jne .L281
    cmp rbx, 61
    jne .L283
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_STAR_ASSIGN]
    jmp .__ret_248
    jmp .L284
.L283:
.L284:
    mov rax, [rel __g_lexer_TOK_STAR]
    jmp .__ret_248
    jmp .L282
.L281:
.L282:
    cmp r12, 47
    jne .L285
    cmp rbx, 61
    jne .L287
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_SLASH_ASSIGN]
    jmp .__ret_248
    jmp .L288
.L287:
.L288:
    mov rax, [rel __g_lexer_TOK_SLASH]
    jmp .__ret_248
    jmp .L286
.L285:
.L286:
    cmp r12, 38
    jne .L289
    cmp rbx, 38
    jne .L291
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_AND]
    jmp .__ret_248
    jmp .L292
.L291:
.L292:
    mov rax, [rel __g_lexer_TOK_AMPERSAND]
    jmp .__ret_248
    jmp .L290
.L289:
.L290:
    cmp r12, 124
    jne .L293
    cmp rbx, 124
    jne .L295
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_OR]
    jmp .__ret_248
    jmp .L296
.L295:
.L296:
    mov rax, [rel __g_lexer_TOK_PIPE]
    jmp .__ret_248
    jmp .L294
.L293:
.L294:
    cmp r12, 94
    jne .L297
    cmp rbx, 61
    jne .L299
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_XOR_ASSIGN]
    jmp .__ret_248
    jmp .L300
.L299:
.L300:
    mov rax, [rel __g_lexer_TOK_CARET]
    jmp .__ret_248
    jmp .L298
.L297:
.L298:
    cmp r12, 33
    jne .L301
    cmp rbx, 61
    jne .L303
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_NEQ]
    jmp .__ret_248
    jmp .L304
.L303:
.L304:
    mov rax, [rel __g_lexer_TOK_NOT]
    jmp .__ret_248
    jmp .L302
.L301:
.L302:
    cmp r12, 61
    jne .L305
    cmp rbx, 61
    jne .L307
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_EQ]
    jmp .__ret_248
    jmp .L308
.L307:
.L308:
    mov rax, [rel __g_lexer_TOK_ASSIGN]
    jmp .__ret_248
    jmp .L306
.L305:
.L306:
    cmp r12, 60
    jne .L309
    cmp rbx, 61
    jne .L311
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_LTE]
    jmp .__ret_248
    jmp .L312
.L311:
.L312:
    cmp rbx, 60
    jne .L313
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_LSHIFT]
    jmp .__ret_248
    jmp .L314
.L313:
.L314:
    mov rax, [rel __g_lexer_TOK_LT]
    jmp .__ret_248
    jmp .L310
.L309:
.L310:
    cmp r12, 62
    jne .L315
    cmp rbx, 61
    jne .L317
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_GTE]
    jmp .__ret_248
    jmp .L318
.L317:
.L318:
    cmp rbx, 62
    jne .L319
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    cmp rax, 62
    jne .L321
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_URSHIFT]
    jmp .__ret_248
    jmp .L322
.L321:
.L322:
    mov rax, [rel __g_lexer_TOK_RSHIFT]
    jmp .__ret_248
    jmp .L320
.L319:
.L320:
    mov rax, [rel __g_lexer_TOK_GT]
    jmp .__ret_248
    jmp .L316
.L315:
.L316:
    cmp r12, 58
    jne .L323
    cmp rbx, 58
    jne .L325
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_DOUBLE_COLON]
    jmp .__ret_248
    jmp .L326
.L325:
.L326:
    mov rax, [rel __g_lexer_TOK_COLON]
    jmp .__ret_248
    jmp .L324
.L323:
.L324:
    mov rax, 1
    neg rax
    jmp .__ret_248
.__ret_248:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
klx_put:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, r13
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 8
    push rax
    mov rax, [rel __g_lexer_klx_src]
    add rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r13
    add rax, 16
    push rax
    mov rax, [rel __g_lexer_klx_pos]
    sub rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r13
    add rax, 20
    push rax
    mov rax, [rel __g_lexer_klx_tok_line]
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, r13
    add rax, 22
    push rax
    mov rax, [rel __g_lexer_klx_tok_col]
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, 0
    jmp .__ret_327
.__ret_327:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
klx_fail:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov rbx, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, rbx
    mov [rel __g_lexer_klx_err_kind], rax
    lea rax, [rel __g_lexer_klx_err_tok]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    add rax, 8
    push rax
    mov rax, [rel __g_lexer_klx_src]
    add rax, r13
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, rbx
    add rax, 16
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, rbx
    add rax, 20
    push rax
    mov rax, [rel __g_lexer_klx_tok_line]
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, rbx
    add rax, 22
    push rax
    mov rax, [rel __g_lexer_klx_tok_col]
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, 1
    neg rax
    jmp .__ret_328
.__ret_328:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
klx_next:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov r14, rcx
    sub rsp, 32
    call klx_skip
    add rsp, 32
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L330
    mov rax, r14
    push rax
    mov rax, [rel __g_lexer_TOK_EOF]
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 8
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, r14
    add rax, 16
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], ecx
    mov rax, r14
    add rax, 20
    push rax
    mov rax, [rel __g_lexer_klx_line]
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, r14
    add rax, 22
    push rax
    mov rax, [rel __g_lexer_klx_col]
    mov rcx, rax
    pop rdx
    mov [rdx], cx
    mov rax, 2
    jmp .__ret_329
    jmp .L331
.L330:
.L331:
    mov rax, [rel __g_lexer_klx_line]
    mov [rel __g_lexer_klx_tok_line], rax
    mov rax, [rel __g_lexer_klx_col]
    mov [rel __g_lexer_klx_tok_col], rax
    mov rax, [rel __g_lexer_klx_pos]
    mov r13, rax
    mov rcx, r13
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rcx, r12
    sub rsp, 32
    call klx_is_letter
    add rsp, 32
    cmp rax, 1
    jne .L332
.L334:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L337
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call klx_is_letter
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L339
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call klx_is_digit
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L339
    mov rax, 0
    jmp .L340
.L339:
    mov rax, 1
.L340:
    test rax, rax
    jz .L337
    mov rax, 1
    jmp .L338
.L337:
    mov rax, 0
.L338:
    test rax, rax
    jz .L335
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_col]
    add rax, 1
    mov [rel __g_lexer_klx_col], rax
.L336:
    jmp .L334
.L335:
    mov rax, [rel __g_lexer_klx_src]
    add rax, r13
    push rax
    mov rax, [rel __g_lexer_klx_pos]
    sub rax, r13
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call klx_keyword
    add rsp, 32
    mov rbx, rax
    jmp .L333
.L332:
    mov rcx, r12
    sub rsp, 32
    call klx_is_digit
    add rsp, 32
    cmp rax, 1
    jne .L341
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rbx, rax
    mov rax, r12
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L345
    mov rax, rbx
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L347
    mov rax, rbx
    mov rcx, 88
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L347
    mov rax, 0
    jmp .L348
.L347:
    mov rax, 1
.L348:
    test rax, rax
    jz .L345
    mov rax, 1
    jmp .L346
.L345:
    mov rax, 0
.L346:
    test rax, rax
    jz .L343
    mov rax, r13
    add rax, 2
    mov [rel __g_lexer_klx_pos], rax
.L349:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    push rax
    pop rcx
    sub rsp, 32
    call klx_is_hex
    add rsp, 32
    cmp rax, 1
    jne .L350
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
.L351:
    jmp .L349
.L350:
    mov rax, [rel __g_lexer_TOK_HEX]
    mov rbx, rax
    jmp .L344
.L343:
    sub rsp, 32
    call klx_number
    add rsp, 32
    mov rbx, rax
.L344:
    jmp .L342
.L341:
    cmp r12, 34
    jne .L352
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rbx, rax
.L354:
    cmp rbx, 34
    je .L355
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L357
    mov rax, [rel __g_lexer_KLX_ERR_TEXT]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, 1
    sub rsp, 32
    call klx_fail
    add rsp, 32
    jmp .__ret_329
    jmp .L358
.L357:
.L358:
    cmp rbx, 92
    jne .L359
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 2
    mov [rel __g_lexer_klx_pos], rax
    jmp .L360
.L359:
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
.L360:
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rcx
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rbx, rax
.L356:
    jmp .L354
.L355:
    mov rax, [rel __g_lexer_klx_pos]
    add rax, 1
    mov [rel __g_lexer_klx_pos], rax
    mov rax, [rel __g_lexer_TOK_STRING]
    mov rbx, rax
    jmp .L353
.L352:
    mov rcx, r12
    sub rsp, 32
    call klx_punct
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L361
    mov rax, 1
    mov rbx, rax
    mov rax, r12
    mov rcx, 192
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L365
    mov rax, r12
    mov rcx, 224
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L365
    mov rax, 1
    jmp .L366
.L365:
    mov rax, 0
.L366:
    test rax, rax
    jz .L363
    mov rax, 2
    mov rbx, rax
    jmp .L364
.L363:
.L364:
    mov rax, r12
    mov rcx, 224
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L369
    mov rax, r12
    mov rcx, 240
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L369
    mov rax, 1
    jmp .L370
.L369:
    mov rax, 0
.L370:
    test rax, rax
    jz .L367
    mov rax, 3
    mov rbx, rax
    jmp .L368
.L367:
.L368:
    mov rax, r12
    mov rcx, 240
    cmp rax, rcx
    setge al
    movzx rax, al
    test rax, rax
    jz .L373
    mov rax, r12
    mov rcx, 248
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jz .L373
    mov rax, 1
    jmp .L374
.L373:
    mov rax, 0
.L374:
    test rax, rax
    jz .L371
    mov rax, 4
    mov rbx, rax
    jmp .L372
.L371:
.L372:
    mov rax, r13
    add rax, rbx
    push rax
    mov rax, [rel __g_lexer_klx_len]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L375
    mov rax, [rel __g_lexer_klx_len]
    sub rax, r13
    mov rbx, rax
    jmp .L376
.L375:
.L376:
    mov rax, [rel __g_lexer_KLX_ERR_CHAR]
    push rax
    pop rcx
    mov rdx, r13
    mov r8, rbx
    sub rsp, 32
    call klx_fail
    add rsp, 32
    jmp .__ret_329
    jmp .L362
.L361:
.L362:
.L353:
.L342:
.L333:
    mov rcx, r14
    mov rdx, rbx
    mov r8, r13
    sub rsp, 32
    call klx_put
    add rsp, 32
    mov rax, 1
    jmp .__ret_329
.__ret_329:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
klx_init:
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
    mov r13, r8
    mov r12, r9
    mov rbx, r10
    mov rax, [rel __g_lexer_klx_kw_n]
    cmp rax, 0
    jne .L378
    sub rsp, 32
    call klx_kw_fill
    add rsp, 32
    jmp .L379
.L378:
.L379:
    mov rax, r15
    mov [rel __g_lexer_klx_src], rax
    mov rax, r14
    mov [rel __g_lexer_klx_len], rax
    mov rax, r13
    mov [rel __g_lexer_klx_buf], rax
    mov rax, r12
    mov [rel __g_lexer_klx_count_ptr], rax
    mov rax, rbx
    mov [rel __g_lexer_klx_cap], rax
    mov rax, 0
    mov [rel __g_lexer_klx_pos], rax
    mov rax, 0
    mov [rel __g_lexer_klx_err_kind], rax
    mov rcx, 0
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rcx, 0xEF
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L384
    mov rcx, 1
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rcx, 0xBB
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L384
    mov rax, 1
    jmp .L385
.L384:
    mov rax, 0
.L385:
    test rax, rax
    jz .L382
    mov rcx, 2
    sub rsp, 32
    call klx_at
    add rsp, 32
    mov rcx, 0xBF
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L382
    mov rax, 1
    jmp .L383
.L382:
    mov rax, 0
.L383:
    test rax, rax
    jz .L380
    mov rax, 3
    mov [rel __g_lexer_klx_pos], rax
    jmp .L381
.L380:
.L381:
    cmp r12, 0
    je .L386
    mov rax, r12
    push rax
    mov rax, 0
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L387
.L386:
.L387:
    mov rax, 1
    mov [rel __g_lexer_klx_line], rax
    mov rax, 1
    mov [rel __g_lexer_klx_col], rax
    mov rax, 1
    mov [rel __g_lexer_klx_tok_line], rax
    mov rax, 1
    mov [rel __g_lexer_klx_tok_col], rax
    mov rax, 1
    jmp .__ret_377
.__ret_377:
    mov rbx, [rbp-96]
    mov r12, [rbp-88]
    mov r13, [rbp-80]
    mov r14, [rbp-72]
    mov r15, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
klx_run:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L389:
    cmp rbx, 2
    je .L390
    mov rax, r12
    push rax
    mov rax, [rel __g_lexer_klx_cap]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L392
    mov rax, [rel __g_lexer_klx_line]
    mov [rel __g_lexer_klx_tok_line], rax
    mov rax, [rel __g_lexer_klx_col]
    mov [rel __g_lexer_klx_tok_col], rax
    mov rax, [rel __g_lexer_KLX_ERR_FULL]
    push rax
    mov rax, [rel __g_lexer_klx_pos]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    sub rsp, 32
    call klx_fail
    add rsp, 32
    jmp .__ret_388
    jmp .L393
.L392:
.L393:
    mov rax, r12
    push rax
    mov rax, [rel __g_lexer_KLX_TOKEN_SIZE]
    mov rcx, rax
    pop rax
    imul rax, rcx
    mov rcx, rax
    mov rax, [rel __g_lexer_klx_buf]
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call klx_next
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L394
    mov rax, 1
    neg rax
    jmp .__ret_388
    jmp .L395
.L394:
.L395:
    add r12, 1
.L391:
    jmp .L389
.L390:
    mov rax, [rel __g_lexer_klx_count_ptr]
    cmp rax, 0
    je .L396
    mov rax, [rel __g_lexer_klx_count_ptr]
    push rax
    mov rax, r12
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    jmp .L397
.L396:
.L397:
    mov rax, r12
    jmp .__ret_388
.__ret_388:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
klx_error_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_lexer_klx_err_kind]
    jmp .__ret_398
.__ret_398:
    mov rsp, rbp
    pop rbp
    ret
klx_error_token:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rax, 0
    mov rbx, rax
    lea rax, [rel __g_lexer_klx_err_tok]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_399
.__ret_399:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
