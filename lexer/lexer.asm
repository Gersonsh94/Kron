; ==============================================================================
; KRON COMPILER - LEXER (TOKENIZER)
; Architecture: x86-64 NASM win64
; Tools: NASM + GoLink
; WINDOWS x64 CONVENTION:
;   rcx = 1st arg, rdx = 2nd arg, r8 = 3rd arg, r9 = 4th arg
; rax = return value
; shadow space = 32 bytes before every call
;   callee-saved: rbx, rsi, rdi, r12-r15, rbp
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"

section .data
    ; Keyword table - pairs (string_ptr, keyword_id)
    ; kept in order for an O(n) linear search - can be hashed later
    kw_var          db "var", 0
    kw_const        db "const", 0
    kw_fn           db "fn", 0
    kw_return       db "return", 0
    kw_if           db "if", 0
    kw_else         db "else", 0
    kw_switch       db "switch", 0
    kw_case         db "case", 0
    kw_default      db "default", 0
    kw_loop         db "loop", 0
    kw_in           db "in", 0
    kw_while        db "while", 0
    kw_raw          db "raw", 0
    kw_slice        db "slice", 0
    kw_for          db "for", 0
    kw_break        db "break", 0
    kw_continue     db "continue", 0
    kw_print        db "print", 0
    kw_printc       db "printc", 0
    kw_range        db "range", 0
    kw_true         db "true", 0
    kw_false        db "false", 0
    kw_null         db "null", 0
    kw_import       db "import", 0
    kw_from         db "from", 0
    kw_module       db "module", 0
    kw_struct       db "struct", 0
    kw_enum         db "enum", 0
    kw_new          db "new", 0
    kw_delete       db "delete", 0
    kw_u8           db "uint8", 0
    kw_u16          db "uint16", 0
    kw_u32          db "uint32", 0
    kw_u64          db "uint64", 0
    kw_i8           db "int8", 0
    kw_i16          db "int16", 0
    kw_i32          db "int32", 0
    kw_i64          db "int64", 0
    kw_a_i8         db "i8", 0
    kw_a_i16        db "i16", 0
    kw_a_i32        db "i32", 0
    kw_a_i64        db "i64", 0
    kw_a_u8         db "u8", 0
    kw_a_u16        db "u16", 0
    kw_a_u32        db "u32", 0
    kw_a_u64        db "u64", 0
    kw_a_f32        db "f32", 0
    kw_a_f64        db "f64", 0
    kw_a_bool       db "bool", 0
    kw_f32          db "real32", 0
    kw_f64          db "real64", 0
    kw_bool         db "hardware_bit", 0
    kw_str          db "utf8_stream", 0
    ; Canonical spellings. The long forms above stay as aliases so that no
    ; existing source breaks, but these are the names the grammar lists.
    kw_a_stream     db "stream", 0
    kw_as           db "as", 0
    kw_fail         db "fail", 0
    kw_hint         db "hint", 0
    kw_failed       db "failed", 0
    kw_printfail    db "print_fail", 0
    kw_sizeof       db "sizeof", 0
    kw_loadfile     db "loadfile", 0
    kw_thstart      db "thread_start", 0
    kw_thwait       db "thread_wait", 0
    kw_lkinit       db "lock_init", 0
    kw_lktake       db "lock_take", 0
    kw_lkgive       db "lock_give", 0
    kw_cpucount     db "cpu_count", 0
    kw_thyield      db "thread_yield", 0
    kw_shared       db "shared", 0
    kw_dllload      db "dll_load", 0
    kw_dllproc      db "dll_proc", 0
    kw_argcount     db "arg_count", 0
    kw_argget       db "arg_get", 0
    kw_targetos     db "target_os", 0
    kw_ticks        db "ticks", 0
    kw_tickrate     db "ticks_per_sec", 0
    kw_v2load       db "vec2_load", 0
    kw_v2store      db "vec2_store", 0
    kw_v2add        db "vec2_add", 0
    kw_v2sub        db "vec2_sub", 0
    kw_v2mul        db "vec2_mul", 0
    kw_a_void       db "void", 0
    ; --- OS/kernel level ---
    kw_boot_seq     db "boot", 0
    kw_mmu_cfg      db "mmu", 0
    kw_sched        db "scheduler", 0
    kw_syscall      db "syscalls", 0
    kw_fs_vol       db "filesystem", 0
    kw_net_kern     db "netkernel", 0
    kw_hw_drv       db "driver", 0
    kw_isr          db "isr", 0
    kw_dma          db "dma", 0
    kw_sec_ring     db "ring", 0
    ; --- Graphics/compute level ---
    kw_j3d          db "kron3d_context", 0
    ; --- Exotic level ---
    ; --- Ecosystem ---
    kw_jisa         db "kron_isa_dynamic", 0
    kw_exec_model   db "execution", 0
    kw_kern_arch    db "kernel", 0
    kw_sec_model    db "security", 0
    kw_hypervisor   db "kron_hypervisor", 0
    kw_deploy       db "deployment", 0
    kw_hmi          db "hmi", 0
    kw_power        db "power", 0
    kw_pkg_mgr      db "packages", 0
    kw_exec_loader  db "loader", 0

    kw_outb         db "outb", 0
    kw_inb          db "inb", 0
    kw_poke         db "poke", 0
    kw_peek         db "peek", 0
    kw_trunc        db "trunc", 0
    kw_savefile     db "savefile", 0
    kw_readkey      db "readkey", 0
    kw_beep         db "beep", 0
    kw_readmouse    db "readmouse", 0
    kw_mousex       db "mousex", 0
    kw_mousey       db "mousey", 0
    kw_asmblk       db "asm", 0
    kw_ptr          db "ptr", 0
    kw_arena_tok    db "ArenaAllocationToken", 0
    kw_rotl         db "rotl", 0
    kw_rotr         db "rotr", 0
    kw_invcache     db "invcache", 0
    kw_prefetch0    db "prefetch", 0
    ; rawHardwareType: raw register widths and untyped pointers.  These are
    ; the grammar spellings for storage of a given width; they map onto the
    ; existing unsigned widths rather than being distinct types.
    kw_reg8         db "register8", 0
    kw_reg16        db "register16", 0
    kw_reg32        db "register32", 0
    kw_reg64        db "register64", 0
    kw_physptr      db "physical_ptr", 0
    kw_virtptr      db "virtual_ptr", 0
    kw_jprogram     db "kron_program", 0
    kw_jimports     db "kron_imports", 0
    kw_jdefs        db "kron_definitions", 0
    kw_jdomain      db "kron_domain", 0
    kw_epoch        db "epoch", 0
    kw_aliased      db "aliased", 0
    kw_poke8        db "poke8", 0
    kw_poke16       db "poke16", 0
    kw_poke32       db "poke32", 0
    kw_peek8        db "peek8", 0
    kw_peek16       db "peek16", 0
    kw_peek32       db "peek32", 0

    kw_call         db "call", 0

    kw_vis_global   db "public", 0
    kw_vis_domain   db "private", 0
    kw_vis_cluster  db "export", 0

    ; Keyword table: [ptr, id, ptr, id, ...]
    keyword_table:
        dq kw_var,      KW_VAR
        dq kw_const,    KW_CONST
        dq kw_fn,       KW_FN
        dq kw_return,   KW_RETURN
        dq kw_if,       KW_IF
        dq kw_else,     KW_ELSE
        dq kw_switch,   KW_SWITCH
        dq kw_case,     KW_CASE
        dq kw_default,  KW_DEFAULT
        dq kw_loop,     KW_LOOP
        dq kw_in,       KW_IN
        dq kw_while,    KW_WHILE
        dq kw_for,      KW_FOR
        dq kw_break,    KW_BREAK
        dq kw_continue, KW_CONTINUE
        dq kw_raw,      KW_RAW
        dq kw_slice,    KW_SLICE
        dq kw_print,    KW_PRINT
        dq kw_printc,   KW_PRINTC
        dq kw_range,    KW_RANGE
        dq kw_true,     KW_TRUE
        dq kw_false,    KW_FALSE
        dq kw_null,     KW_NULL
        dq kw_import,   KW_IMPORT
        dq kw_from,     KW_FROM
        dq kw_module,   KW_MODULE
        dq kw_struct,   KW_STRUCT
        dq kw_enum,     KW_ENUM
        dq kw_new,      KW_NEW
        dq kw_delete,   KW_DELETE
        dq kw_u8,       KW_U8
        dq kw_u16,      KW_U16
        dq kw_u32,      KW_U32
        dq kw_u64,      KW_U64
        dq kw_i8,       KW_I8
        dq kw_i16,      KW_I16
        dq kw_i32,      KW_I32
        dq kw_i64,      KW_I64
        dq kw_a_i8, KW_I8
        dq kw_a_i16, KW_I16
        dq kw_a_i32, KW_I32
        dq kw_a_i64, KW_I64
        dq kw_a_u8, KW_U8
        dq kw_a_u16, KW_U16
        dq kw_a_u32, KW_U32
        dq kw_a_u64, KW_U64
        dq kw_a_f32, KW_F32
        dq kw_a_f64, KW_F64
        dq kw_a_bool, KW_BOOL
        dq kw_f32,      KW_F32
        dq kw_f64,      KW_F64
        dq kw_bool,     KW_BOOL
        dq kw_str,      KW_STR
        dq kw_a_stream, KW_STR
        dq kw_as,       KW_AS
        dq kw_fail,     KW_FAIL
        dq kw_hint,     KW_HINT
        dq kw_failed,   KW_FAILED
        dq kw_printfail, KW_PRINTFAIL
        dq kw_sizeof,   KW_SIZEOF
        dq kw_loadfile, KW_LOADFILE
        dq kw_thstart,  KW_THREAD_START
        dq kw_thwait,   KW_THREAD_WAIT
        dq kw_lkinit,   KW_LOCK_INIT
        dq kw_lktake,   KW_LOCK_TAKE
        dq kw_lkgive,   KW_LOCK_GIVE
        dq kw_cpucount, KW_CPU_COUNT
        dq kw_thyield,  KW_THREAD_YIELD
        dq kw_shared,   KW_SHARED
        dq kw_dllload,  KW_DLL_LOAD
        dq kw_dllproc,  KW_DLL_PROC
        dq kw_argcount, KW_ARG_COUNT
        dq kw_argget,   KW_ARG_GET
        dq kw_targetos, KW_TARGET_OS
        dq kw_ticks,    KW_TICKS
        dq kw_tickrate, KW_TICKS_PER_SEC
        dq kw_v2load,   KW_VEC2_LOAD
        dq kw_v2store,  KW_VEC2_STORE
        dq kw_v2add,    KW_VEC2_ADD
        dq kw_v2sub,    KW_VEC2_SUB
        dq kw_v2mul,    KW_VEC2_MUL
        dq kw_a_void,   KW_VOID
        dq kw_boot_seq, KW_BOOT_SEQUENCE
        dq kw_mmu_cfg,  KW_MMU_CONFIGURATION
        dq kw_sched,    KW_SCHEDULER_DOMAIN
        dq kw_syscall,  KW_SYSCALL_DISPATCH
        dq kw_fs_vol,   KW_FILESYSTEM_VOLUME
        dq kw_net_kern, KW_NETWORK_KERNEL
        dq kw_hw_drv,   KW_HARDWARE_DRIVER
        dq kw_isr,      KW_INTERRUPT_SERVICE
        dq kw_dma,      KW_DMA_CHANNEL
        dq kw_j3d,      KW_KRON3D_CONTEXT
        dq kw_jisa,     KW_KRON_ISA
        dq kw_exec_model, KW_EXECUTION_MODEL
        dq kw_kern_arch, KW_KERNEL_ARCHITECTURE
        dq kw_sec_model, KW_SECURITY_MODEL
        dq kw_hypervisor, KW_KRON_HYPERVISOR
        dq kw_deploy,   KW_DEPLOYMENT_MODEL
        dq kw_hmi,      KW_HUMAN_MACHINE
        dq kw_power,    KW_POWER_MANAGER
        dq kw_pkg_mgr,  KW_PACKAGE_MANAGER
        dq kw_exec_loader, KW_EXECUTABLE_LOADER
        dq kw_sec_ring, KW_SECURITY_RING
        dq kw_outb,     KW_OUTB
        dq kw_inb,      KW_INB
        dq kw_poke,     KW_POKE
        dq kw_peek,     KW_PEEK
        dq kw_trunc,    KW_TRUNC
        dq kw_savefile, KW_SAVEFILE
        dq kw_readkey,  KW_READKEY
        dq kw_beep,     KW_BEEP
        dq kw_readmouse,KW_READMOUSE
        dq kw_mousex,   KW_MOUSEX
        dq kw_mousey,   KW_MOUSEY
        dq kw_asmblk,   KW_ASM
        dq kw_ptr,      KW_PTR
        dq kw_arena_tok, KW_ARENA_TOKEN
        dq kw_rotl,     KW_ROTL
        dq kw_rotr,     KW_ROTR
        dq kw_invcache, KW_INVCACHE
        dq kw_prefetch0, KW_PREFETCH0
        dq kw_reg8,     KW_U8
        dq kw_reg16,    KW_U16
        dq kw_reg32,    KW_U32
        dq kw_reg64,    KW_U64
        dq kw_physptr,  KW_U64
        dq kw_virtptr,  KW_U64
        dq kw_jprogram, KW_KRON_PROGRAM
        dq kw_jimports, KW_KRON_IMPORTS
        dq kw_jdefs,    KW_KRON_DEFINITIONS
        dq kw_jdomain,  KW_KRON_DOMAIN
        dq kw_epoch,    KW_EPOCH
        dq kw_aliased,  KW_ALIASED
        dq kw_poke8,    KW_POKE8
        dq kw_poke16,   KW_POKE16
        dq kw_poke32,   KW_POKE32
        dq kw_peek8,    KW_PEEK8
        dq kw_peek16,   KW_PEEK16
        dq kw_peek32,   KW_PEEK32
        dq kw_vis_global,  KW_GLOBAL_VISIBLE
        dq kw_vis_domain,  KW_DOMAIN_ISOLATED
        dq kw_vis_cluster, KW_INTER_CLUSTER_EXPORT
        dq kw_call,     KW_CALL
        dq 0, 0     ; sentinel

    keyword_table_len equ ($ - keyword_table) / 16   ; 16 bytes per entry

section .bss
    ; Lexer state
    lex_src         resq 1      ; pointer to the source
    lex_pos         resq 1      ; current position
    lex_len         resq 1      ; length of the source
    lex_line        resw 1      ; current line
    lex_col         resw 1      ; current column
    lex_tok_line    resw 1      ; line and column where the CURRENT token starts
    lex_tok_col     resw 1
    lex_tok_buf       resq 1      ; token buffer (arena)
    lex_tok_count     resq 1      ; number of tokens produced
    lex_tok_count_ptr resq 1      ; output for main.asm
    lex_tok_cap       resq 1      ; buffer capacity in tokens
    lex_error       resb 256    ; error buffer

section .text
    global jup_lexer_init
    global jup_lexer_run
    global lexer_next_token
    global lexer_peek_token
    global lexer_get_error

; ==============================================================================
; jup_lexer_init(rcx=src_ptr, rdx=src_len, r8=token_buf, r9=token_count_ptr)
; Windows x64 convention
; Returns: rax = 1 OK
; ==============================================================================
jup_lexer_init:
    push rbp
    mov  rbp, rsp
    mov  [rel lex_src],           rcx
    mov  [rel lex_len],           rdx
    mov  [rel lex_tok_buf],       r8
    mov  [rel lex_tok_count_ptr], r9
    xor  rax, rax
    mov  [rel lex_pos],       rax
    mov  [rel lex_tok_count], rax
    ; Skip a UTF-8 byte order mark if the file starts with one.
    ;
    ; Every Windows editor writes EF BB BF at the head of a file, and without
    ; this the lexer met a byte it had no rule for, produced no tokens at
    ; all, and the parser reported 'end of file' at line 0 -- an error that
    ; says nothing about a file that is plainly not empty.
    cmp  rdx, 3
    jb   .no_bom
    mov  r10, rcx
    cmp  byte [r10], 0xEF
    jne  .no_bom
    cmp  byte [r10 + 1], 0xBB
    jne  .no_bom
    cmp  byte [r10 + 2], 0xBF
    jne  .no_bom
    mov  qword [rel lex_pos], 3
.no_bom:
    mov  qword [rel lex_tok_cap], (TOKEN_BUFFER_SIZE / TOKEN_SIZE)
    test r9, r9
    jz   .count_ready
    mov  qword [r9], 0
.count_ready:
    mov  word [rel lex_line], 1
    mov  word [rel lex_col],  1
    mov  word [rel lex_tok_col],  1
    mov  word [rel lex_tok_line], 1
    mov  rax, 1
    pop  rbp
    ret

; ==============================================================================
; jup_lexer_run()
; Tokenizes the whole source at once - fast batch mode
; Returns: rax = 1 OK, 0 on error
; ==============================================================================
jup_lexer_run:
    push    r12
    push    r13
    push    r14
    push    r15
    push    rbx

    xor     r12, r12        ; token counter

.scan_loop:
    ; Always keep a final entry for TOK_EOF.
    mov     rbx, [rel lex_tok_cap]
    cmp     r12, rbx
    jge     .error

    ; lexer_next_token_internal works out the target from lex_tok_count.
    ; Keep it in step with the local counter before each token.
    mov     [rel lex_tok_count], r12
    call    lexer_next_token_internal
    cmp     rax, -1
    je      .error

    ; Check the token just written.
    mov     rbx, [rel lex_tok_buf]
    imul    rcx, r12, TOKEN_SIZE
    add     rbx, rcx
    mov     rcx, [rbx + TOKEN.type]
    cmp     rcx, TOK_EOF
    je      .inc_and_done

    inc     r12
    jmp     .scan_loop

.inc_and_done:
    inc     r12             ; include the EOF token

.done:
    mov     [rel lex_tok_count], r12
    mov     rax, [rel lex_tok_count_ptr]
    test    rax, rax
    jz      .count_stored
    mov     [rax], r12
.count_stored:
    mov     rax, r12
    jmp     .ret

.error:
    mov     rax, -1

.ret:
    pop     rbx
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    ret

; ==============================================================================
; lexer_next_token_internal - internal use
; Writes the next token to lex_tok_buf[lex_tok_count]
; Returns: rax = 0 OK, -1 on error
; ==============================================================================
lexer_next_token_internal:
    push    r12
    push    r13
    push    r14
    push    rbx

    ; Work out where to write the token
    mov     rax, [rel lex_tok_count]
    imul    rax, TOKEN_SIZE
    mov     r12, [rel lex_tok_buf]
    add     r12, rax        ; r12 = pointer to the target token

.skip_whitespace:
    mov     rax, [rel lex_pos]
    mov     rbx, [rel lex_len]
    cmp     rax, rbx
    jge     .emit_eof

    mov     r13, [rel lex_src]
    movzx   r14d, byte [r13 + rax]   ; r14 = current character

    ; Skip spaces, tabs, CR
    cmp     r14b, ' '
    je      .advance_ws
    cmp     r14b, 9          ; tab
    je      .advance_ws
    cmp     r14b, 13         ; CR
    je      .advance_cr

    ; New line
    cmp     r14b, 10         ; LF
    je      .newline

    ; Comment // 
    cmp     r14b, '/'
    je      .check_comment

    jmp     .dispatch_char

.advance_ws:
    inc     qword [rel lex_pos]
    inc     word [rel lex_col]
    jmp     .skip_whitespace

.advance_cr:
    inc     qword [rel lex_pos]
    jmp     .skip_whitespace

.newline:
    inc     qword [rel lex_pos]
    inc     word [rel lex_line]
    mov     word [rel lex_col], 1
    jmp     .skip_whitespace

.check_comment:
    ; Check for // (line comment)
    mov     rax, [rel lex_pos]
    inc     rax
    mov     rbx, [rel lex_len]
    cmp     rax, rbx
    jge     .dispatch_char

    movzx   ebx, byte [r13 + rax]
    cmp     bl, '/'
    jne     .dispatch_char

    ; It is a comment - consume up to the end of the line
.comment_loop:
    inc     qword [rel lex_pos]
    mov     rax, [rel lex_pos]
    mov     rbx, [rel lex_len]
    cmp     rax, rbx
    jge     .skip_whitespace

    movzx   ebx, byte [r13 + rax]
    cmp     bl, 10           ; LF
    je      .skip_whitespace
    jmp     .comment_loop

.dispatch_char:
    ; Capture where the token STARTS. .token_done used to read lex_col after
    ; the characters had been consumed, so every diagnostic pointed one past
    ; the token instead of at it.
    movzx   eax, word [rel lex_line]
    mov     word [rel lex_tok_line], ax
    movzx   eax, word [rel lex_col]
    mov     word [rel lex_tok_col], ax
    ; Save the position where the token starts
    mov     rax, [rel lex_pos]
    mov     [r12 + TOKEN.value], r13   ; base of the source
    mov     r14d, [rel lex_line]       ; reused as temporary storage

    ; Identifier or keyword: a letter or _
    movzx   r14d, byte [r13 + rax]
    cmp     r14b, '_'
    je      .scan_ident
    cmp     r14b, 'a'
    jl      .not_lower
    cmp     r14b, 'z'
    jle     .scan_ident
.not_lower:
    cmp     r14b, 'A'
    jl      .not_upper
    cmp     r14b, 'Z'
    jle     .scan_ident
.not_upper:

    ; Number: digit  (a leading '0' can open 0x... )
    cmp     r14b, '0'
    je      .check_hex
    jl      .not_digit
    cmp     r14b, '9'
    jle     .scan_number
.not_digit:

    ; String: "
    cmp     r14b, '"'
    je      .scan_string

    ; Hex in context: 0x
    cmp     r14b, '0'
    je      .check_hex

    ; Punctuation and operators
    jmp     .scan_punct

; --- SCAN IDENTIFIER / KEYWORD ---
.scan_ident:
    mov     r13, [rel lex_src]
    mov     rax, [rel lex_pos]
    mov     rbx, rax        ; rbx = start

    ; Work out the start pointer
    add     r13, rax

.ident_loop:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .ident_done

    mov     r14, [rel lex_src]
    movzx   r14d, byte [r14 + rax]

    ; a-z, A-Z, 0-9, _
    cmp     r14b, '_'
    je      .ident_next
    cmp     r14b, 'a'
    jl      .ident_not_lower
    cmp     r14b, 'z'
    jle     .ident_next
.ident_not_lower:
    cmp     r14b, 'A'
    jl      .ident_not_upper
    cmp     r14b, 'Z'
    jle     .ident_next
.ident_not_upper:
    cmp     r14b, '0'
    jl      .ident_done
    cmp     r14b, '9'
    jle     .ident_next
    jmp     .ident_done

.ident_next:
    inc     qword [rel lex_pos]
    inc     word [rel lex_col]
    jmp     .ident_loop

.ident_done:
    ; Work out the length
    mov     rax, [rel lex_pos]
    sub     rax, rbx
    mov     dword [r12 + TOKEN.length], eax

    ; Save the pointer to the start of the identifier
    mov     rcx, [rel lex_src]
    add     rcx, rbx
    mov     [r12 + TOKEN.value], rcx

    ; Look it up in the keyword table
    push    rbx
    push    r12
    mov     rdi, rcx        ; pointer to the text
    mov     rsi, rax        ; length
    call    lookup_keyword
    pop     r12
    pop     rbx

    cmp     rax, -1
    je      .is_identifier

    ; It is a keyword
    mov     [r12 + TOKEN.type], rax
    jmp     .token_done

.is_identifier:
    mov     qword [r12 + TOKEN.type], TOK_IDENTIFIER
    jmp     .token_done

; --- SCAN NUMBER ---
.scan_number:
    mov     r13, [rel lex_src]
    mov     rax, [rel lex_pos]
    mov     rbx, rax        ; rbx = start
    xor     r14, r14        ; r14 = 0 = integer, 1 = float

.number_loop:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .number_done

    mov     r15, [rel lex_src]
    movzx   r15d, byte [r15 + rax]

    cmp     r15b, '0'
    jl      .number_check_dot
    cmp     r15b, '9'
    jle     .number_next

.number_check_dot:
    cmp     r15b, 'e'
    je      .number_exp
    cmp     r15b, 'E'
    je      .number_exp
    cmp     r15b, '.'
    jne     .number_done
    ; It is a dot - check whether it is a float
    mov     r14, 1          ; it is a float
    inc     qword [rel lex_pos]
    jmp     .number_loop

.number_next:
    inc     qword [rel lex_pos]
    inc     word [rel lex_col]
    jmp     .number_loop

; 1.5e300, 2e-6: an exponent makes a real. Only when digits follow (after an
; optional sign), so that a name glued to a number is not swallowed.
.number_exp:
    mov     rcx, [rel lex_len]
    mov     rdx, rax
    inc     rdx                      ; past the e
    cmp     rdx, rcx
    jge     .number_done
    mov     r15, [rel lex_src]
    movzx   r8d, byte [r15 + rdx]
    cmp     r8b, '+'
    je      .number_exp_sign
    cmp     r8b, '-'
    jne     .number_exp_digit
.number_exp_sign:
    inc     rdx
    cmp     rdx, rcx
    jge     .number_done
    movzx   r8d, byte [r15 + rdx]
.number_exp_digit:
    cmp     r8b, '0'
    jl      .number_done
    cmp     r8b, '9'
    jg      .number_done
    mov     r14, 1                   ; a real
    mov     [rel lex_pos], rdx       ; on the first digit of the exponent
.number_exp_loop:
    mov     rax, [rel lex_pos]
    cmp     rax, rcx
    jge     .number_done
    movzx   r8d, byte [r15 + rax]
    cmp     r8b, '0'
    jl      .number_done
    cmp     r8b, '9'
    jg      .number_done
    inc     qword [rel lex_pos]
    jmp     .number_exp_loop

.number_done:
    mov     rax, [rel lex_pos]
    sub     rax, rbx
    mov     dword [r12 + TOKEN.length], eax

    mov     rcx, [rel lex_src]
    add     rcx, rbx
    mov     [r12 + TOKEN.value], rcx

    cmp     r14, 1
    je      .number_float
    mov     qword [r12 + TOKEN.type], TOK_INTEGER
    jmp     .token_done

.number_float:
    mov     qword [r12 + TOKEN.type], TOK_FLOAT
    jmp     .token_done

; --- CHECK HEX: 0x... ---
.check_hex:
    mov     rax, [rel lex_pos]
    inc     rax
    mov     rbx, [rel lex_len]
    cmp     rax, rbx
    jge     .scan_number

    mov     r13, [rel lex_src]
    movzx   r14d, byte [r13 + rax]
    cmp     r14b, 'x'
    je      .scan_hex_literal
    cmp     r14b, 'X'
    jne     .scan_number

.scan_hex_literal:
    mov     rbx, [rel lex_pos]     ; start
    inc     qword [rel lex_pos]    ; consume '0'
    inc     qword [rel lex_pos]    ; consume 'x'

.hex_loop:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .hex_done

    mov     r13, [rel lex_src]
    movzx   r14d, byte [r13 + rax]

    ; 0-9, a-f, A-F
    cmp     r14b, '0'
    jl      .hex_done
    cmp     r14b, '9'
    jle     .hex_next
    cmp     r14b, 'a'
    jl      .hex_check_upper
    cmp     r14b, 'f'
    jle     .hex_next
.hex_check_upper:
    cmp     r14b, 'A'
    jl      .hex_done
    cmp     r14b, 'F'
    jg      .hex_done

.hex_next:
    inc     qword [rel lex_pos]
    jmp     .hex_loop

.hex_done:
    mov     rax, [rel lex_pos]
    sub     rax, rbx
    mov     dword [r12 + TOKEN.length], eax
    mov     rcx, [rel lex_src]
    add     rcx, rbx
    mov     [r12 + TOKEN.value], rcx
    mov     qword [r12 + TOKEN.type], TOK_HEX
    jmp     .token_done

; --- SCAN STRING ---
.scan_string:
    mov     rbx, [rel lex_pos]
    inc     qword [rel lex_pos]    ; consume "

.str_loop:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .str_error

    mov     r13, [rel lex_src]
    movzx   r14d, byte [r13 + rax]

    cmp     r14b, '"'
    je      .str_done

    ; Escape sequences
    cmp     r14b, '\'
    je      .str_escape

    inc     qword [rel lex_pos]
    jmp     .str_loop

.str_escape:
    inc     qword [rel lex_pos]    ; consume '\'
    inc     qword [rel lex_pos]    ; consume the escaped char
    jmp     .str_loop

.str_done:
    inc     qword [rel lex_pos]    ; consume "
    mov     rax, [rel lex_pos]
    sub     rax, rbx
    mov     dword [r12 + TOKEN.length], eax
    mov     rcx, [rel lex_src]
    add     rcx, rbx
    mov     [r12 + TOKEN.value], rcx
    mov     qword [r12 + TOKEN.type], TOK_STRING
    jmp     .token_done

.str_error:
    mov     rax, -1
    jmp     .ret_error

; --- SCAN PUNCTUATION / OPERATORS ---
.scan_punct:
    mov     r13, [rel lex_src]
    mov     rax, [rel lex_pos]
    movzx   r14d, byte [r13 + rax]

    ; Save the value
    lea     rcx, [r13 + rax]
    mov     [r12 + TOKEN.value], rcx
    mov     dword [r12 + TOKEN.length], 1

    inc     qword [rel lex_pos]
    inc     word [rel lex_col]

    cmp     r14b, '{'
    je      .punct_lbrace
    cmp     r14b, '}'
    je      .punct_rbrace
    cmp     r14b, '('
    je      .punct_lparen
    cmp     r14b, ')'
    je      .punct_rparen
    cmp     r14b, '['
    je      .punct_lbracket
    cmp     r14b, ']'
    je      .punct_rbracket
    cmp     r14b, ';'
    je      .punct_semi
    cmp     r14b, ','
    je      .punct_comma
    cmp     r14b, '.'
    je      .punct_dot
    cmp     r14b, '+'
    je      .punct_plus
    cmp     r14b, '-'
    je      .punct_minus
    cmp     r14b, '*'
    je      .punct_star
    cmp     r14b, '/'
    je      .punct_slash
    cmp     r14b, '%'
    je      .punct_percent
    cmp     r14b, '&'
    je      .punct_amp
    cmp     r14b, '|'
    je      .punct_pipe
    cmp     r14b, '^'
    je      .punct_caret
    cmp     r14b, '~'
    je      .punct_tilde
    cmp     r14b, '!'
    je      .check_neq
    cmp     r14b, '='
    je      .check_eq
    cmp     r14b, '<'
    je      .check_lt
    cmp     r14b, '>'
    je      .check_gt
    cmp     r14b, ':'
    je      .check_colon

    ; Unknown character - skip
    xor     eax, eax
    jmp     .token_done_ok

.punct_lbrace:
    mov qword [r12 + TOKEN.type], TOK_LBRACE
    jmp .token_done
.punct_rbrace:
    mov qword [r12 + TOKEN.type], TOK_RBRACE
    jmp .token_done
.punct_lparen:
    mov qword [r12 + TOKEN.type], TOK_LPAREN
    jmp .token_done
.punct_rparen:
    mov qword [r12 + TOKEN.type], TOK_RPAREN
    jmp .token_done
.punct_lbracket:
    mov qword [r12 + TOKEN.type], TOK_LBRACKET
    jmp .token_done
.punct_rbracket:
    mov qword [r12 + TOKEN.type], TOK_RBRACKET
    jmp .token_done
.punct_semi:
    mov qword [r12 + TOKEN.type], TOK_SEMICOLON
    jmp .token_done
.punct_comma:
    mov qword [r12 + TOKEN.type], TOK_COMMA
    jmp .token_done
.punct_dot:
    mov qword [r12 + TOKEN.type], TOK_DOT
    jmp .token_done
.punct_plus:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_plus
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .just_plus
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_PLUS_ASSIGN
    jmp     .token_done
.just_plus:
    mov qword [r12 + TOKEN.type], TOK_PLUS
    jmp .token_done
.punct_star:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_star
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .just_star
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_STAR_ASSIGN
    jmp     .token_done
.just_star:
    mov qword [r12 + TOKEN.type], TOK_STAR
    jmp .token_done
.punct_slash:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_slash
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .just_slash
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_SLASH_ASSIGN
    jmp     .token_done
.just_slash:
    mov qword [r12 + TOKEN.type], TOK_SLASH
    jmp .token_done
.punct_percent:
    mov qword [r12 + TOKEN.type], TOK_PERCENT
    jmp .token_done
.punct_amp:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_amp
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '&'
    jne     .just_amp
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_AND
    jmp     .token_done
.just_amp:
    mov qword [r12 + TOKEN.type], TOK_AMPERSAND
    jmp .token_done
.punct_pipe:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_pipe
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '|'
    jne     .just_pipe
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_OR
    jmp     .token_done
.just_pipe:
    mov qword [r12 + TOKEN.type], TOK_PIPE
    jmp .token_done
.punct_caret:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_caret
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .just_caret
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_XOR_ASSIGN
    jmp     .token_done
.just_caret:
    mov qword [r12 + TOKEN.type], TOK_CARET
    jmp .token_done
.punct_tilde:
    mov qword [r12 + TOKEN.type], TOK_TILDE
    jmp .token_done

.punct_minus:
    ; Check for ->
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_minus
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .minus_arrow
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_MINUS_ASSIGN
    jmp     .token_done
.minus_arrow:
    cmp     bl, '>'
    jne     .just_minus
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_ARROW
    jmp     .token_done
.just_minus:
    mov     qword [r12 + TOKEN.type], TOK_MINUS
    jmp     .token_done

.check_eq:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_assign
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .just_assign
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_EQ
    jmp     .token_done
.just_assign:
    mov     qword [r12 + TOKEN.type], TOK_ASSIGN
    jmp     .token_done

.check_neq:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_not
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    jne     .just_not
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_NEQ
    jmp     .token_done
.just_not:
    mov     qword [r12 + TOKEN.type], TOK_NOT
    jmp     .token_done

.check_lt:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_lt
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    je      .lte
    cmp     bl, '<'
    je      .lshift
    jmp     .just_lt
.lte:
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_LTE
    jmp     .token_done
.lshift:
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_LSHIFT
    jmp     .token_done
.just_lt:
    mov     qword [r12 + TOKEN.type], TOK_LT
    jmp     .token_done

.check_gt:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_gt
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '='
    je      .gte
    cmp     bl, '>'
    je      .rshift
    jmp     .just_gt
.gte:
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_GTE
    jmp     .token_done
.rshift:
    inc     qword [rel lex_pos]
    ; a third '>' makes it the logical shift '>>>'
    mov     rax, [rel lex_pos]
    cmp     rax, [rel lex_len]
    jge     .rshift2
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, '>'
    jne     .rshift2
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 3
    mov     qword [r12 + TOKEN.type], TOK_URSHIFT
    jmp     .token_done
.rshift2:
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_RSHIFT
    jmp     .token_done
.just_gt:
    mov     qword [r12 + TOKEN.type], TOK_GT
    jmp     .token_done

.check_colon:
    mov     rax, [rel lex_pos]
    mov     rcx, [rel lex_len]
    cmp     rax, rcx
    jge     .just_colon
    mov     r13, [rel lex_src]
    movzx   ebx, byte [r13 + rax]
    cmp     bl, ':'
    jne     .just_colon
    inc     qword [rel lex_pos]
    mov     dword [r12 + TOKEN.length], 2
    mov     qword [r12 + TOKEN.type], TOK_DOUBLE_COLON
    jmp     .token_done
.just_colon:
    mov     qword [r12 + TOKEN.type], TOK_COLON
    jmp     .token_done

.token_done:
    ; line/col of the token's FIRST character, captured at .dispatch_char
    movzx   eax, word [rel lex_tok_line]
    mov     word [r12 + TOKEN.line], ax
    movzx   eax, word [rel lex_tok_col]
    mov     word [r12 + TOKEN.col], ax
    inc     qword [rel lex_tok_count]

.token_done_ok:
    xor     eax, eax        ; ERR_OK
    jmp     .ret_ok

.emit_eof:
    mov     qword [r12 + TOKEN.type], TOK_EOF
    mov     qword [r12 + TOKEN.value], 0
    mov     dword [r12 + TOKEN.length], 0
    movzx   eax, word [rel lex_line]
    mov     word [r12 + TOKEN.line], ax
    movzx   eax, word [rel lex_col]
    mov     word [r12 + TOKEN.col], ax
    xor     eax, eax
    jmp     .ret_ok

.ret_error:
    pop     rbx
    pop     r14
    pop     r13
    pop     r12
    mov     rax, -1
    ret

.ret_ok:
    pop     rbx
    pop     r14
    pop     r13
    pop     r12
    xor     eax, eax
    ret

; ==============================================================================
; lookup_keyword(str_ptr, str_len)
; rdi = pointer to the string
; rsi = length
; Returns: rax = keyword_id, or -1 if it is not a keyword
; ==============================================================================
lookup_keyword:
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    mov     r12, rdi        ; r12 = str_ptr
    mov     r13, rsi        ; r13 = str_len
    lea     r14, [rel keyword_table]

.kw_loop:
    mov     rbx, [r14]      ; pointer to the keyword string
    test    rbx, rbx
    jz      .not_found      ; sentinel

    ; Work out the length of the keyword
    xor     r15, r15
.strlen_loop:
    movzx   eax, byte [rbx + r15]
    test    al, al
    jz      .strlen_done
    inc     r15
    jmp     .strlen_loop
.strlen_done:

    ; Compare lengths
    cmp     r15, r13
    jne     .next_kw

    ; Compare strings
    push    rdi
    push    rsi
    push    rcx
    mov     rdi, r12        ; str of the source
    mov     rsi, rbx        ; str of the keyword
    mov     rcx, r13        ; length
    call    lex_memcmp_n
    pop     rcx
    pop     rsi
    pop     rdi

    test    eax, eax
    jnz     .next_kw

    ; Match found
    mov     rax, [r14 + 8]  ; keyword id
    jmp     .found

.next_kw:
    add     r14, 16         ; next entry (8 + 8)
    jmp     .kw_loop

.not_found:
    mov     rax, -1
.found:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

; ==============================================================================
; lex_memcmp_n(a, b, n) - compare n bytes
;   rdi = ptr a
;   rsi = ptr b
;   rcx = n
; Returns: rax = 0 if equal, !=0 if different
; ==============================================================================
lex_memcmp_n:
    xor     eax, eax
    test    rcx, rcx
    jz      .done
.loop:
    movzx   edx, byte [rdi]
    movzx   r8d, byte [rsi]
    cmp     dl, r8b
    jne     .different
    inc     rdi
    inc     rsi
    dec     rcx
    jnz     .loop
    xor     eax, eax
    ret
.different:
    mov     eax, 1
.done:
    ret

; ==============================================================================
; lexer_keyword_name(rdi = token type) -> rax = the keyword's text (NUL-ended),
; or 0 when that type is not a keyword. For error messages: "expected
; 'kron_program'" says far more than "expected a keyword".
    global lexer_keyword_name
lexer_keyword_name:
    push rcx
    push rdx
    lea  rcx, [rel keyword_table]
.kn_loop:
    mov  rax, [rcx]
    test rax, rax
    jz   .kn_none
    mov  rdx, [rcx + 8]
    cmp  rdx, rdi
    je   .kn_out
    add  rcx, 16
    jmp  .kn_loop
.kn_none:
    xor  eax, eax
.kn_out:
    pop  rdx
    pop  rcx
    ret

; lexer_get_token_count() - returns the number of tokens
; Returns: rax = count
; ==============================================================================
lexer_get_token_count:
    mov     rax, [rel lex_tok_count]
    ret

; ==============================================================================
; lexer_get_token(index) - returns a pointer to the token
;   rdi = index
; Returns: rax = pointer to the token
; ==============================================================================
lexer_get_token:
    imul    rdi, TOKEN_SIZE
    mov     rax, [rel lex_tok_buf]
    add     rax, rdi
    ret

; ==============================================================================
; lexer_next_token / lexer_peek_token - cursor interface for the parser
; The parser keeps its own cursor over the token array
; ==============================================================================
lexer_next_token:
    ret

lexer_peek_token:
    ret

lexer_get_error:
    lea     rax, [rel lex_error]
    ret
