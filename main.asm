extern dbg_which
; ==============================================================================
; KRON COMPILER - ENTRY POINT WINDOWS x64
; Architecture: x86-64 NASM win64
; File reading + every compilation phase
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"
%include "web_host.inc"

extern jup_lexer_init, jup_lexer_run
extern jup_parser_init, jup_parser_run
extern par_used_slice
extern par_used_text, par_used_list, par_used_map
extern cg_thread_error_tok, jup_semantic_set_error, cg_type_error
extern parser_get_error_token, parser_get_position
extern parser_get_error_line
extern parser_get_error_col, parser_get_error_len
extern parser_get_expected, parser_get_custom_msg
extern token_name
extern jup_semantic_init, jup_semantic_run, jup_semantic_error_line, jup_semantic_error_kind
extern jup_semantic_error_col, jup_semantic_error_len, jup_semantic_error_name

extern jup_semantic_suggestion
extern jup_codegen_init, jup_codegen_run, jup_codegen_set_target
extern xarm_translate, xarm_error_line, xarm_error_text, xarm_error_insn
extern xwasm_translate, xwasm_error_line, xwasm_error_text, xwasm_error_insn
extern xarm_set_os, karm_set_align, macho_write
extern kasm_init, kasm_assemble, kasm_get_code, kasm_get_code_size, kasm_had_error
extern kasm_get_error_line, kasm_get_error_count, kasm_get_error_line_at
extern kasm_get_error_dst, kasm_get_error_src
extern kasm_get_error_mnem
extern kasm_build_image
extern kasm_get_data_size, kasm_get_bss_size, kasm_get_fixup_count, kasm_get_fixup_kind
extern kasm_get_fixup_label, kasm_get_fixup_at, kasm_get_label_section, kasm_label_addr, kasm_find_label
extern pw_write, pw_gui
extern krn_init, krn_build, krn_get_image, krn_get_size
extern karm_init, karm_set_base, karm_assemble, karm_build_image, karm_get_code
extern karm_get_bss_size, karm_get_entry, karm_get_error_count, karm_get_error_line_at
extern karm_get_error_mnem, karm_get_error_text
extern jup_runtime_init
extern jup_linker_run
extern parser_get_ast_root
extern codegen_get_code, codegen_get_code_size

section .data
    banner       db "========================================", 13, 10
                 db "  KRON 1.0", 13, 10
                 db "  Memory-safe, thread-safe native code", 13, 10
                 db "========================================", 13, 10, 0
    
    msg_read     db "[1/6] Reading file...", 0
    msg_lex      db "[2/6] Lexer...", 0
    msg_parse    db "[3/6] Parser...", 0
    msg_sem      db "[4/6] Semantic...", 0
    msg_code     db "[5/6] Codegen...", 0
    msg_link     db "[6/6] Linking...", 0
    msg_asm_mode db "Assembler mode (kasm)", 13, 10, 0
    msg_asm_mode_arm db "Assembler mode (karm, ARM64)", 13, 10, 0
    s_pp_include  db "include", 0
    s_pp_define   db "define", 0
    s_pp_macro    db "macro", 0
    s_pp_endmacro db "%endmacro", 0
    s_pp_equ      db " equ ", 0
    s_pp_incdir   db "include", 92, 0     ; 92 = backslash
    s_pp_dump     db "preproc.asm", 0
    msg_asm_line db "  at line ", 0
    msg_mnem     db "   ", 0
    msg_kind_d   db "   dst=", 0
    msg_kind_s   db " src=", 0
    msg_dst      db "   dst=", 0
    msg_src      db " src=", 0
    msg_karm_err db "ERROR: karm failed to assemble.", 13, 10, 0
    msg_karm_sep db "  -- ", 0
    msg_xarm_err db "ERROR: the program could not be lowered to ARM64.", 13, 10, 0
    msg_macho_err db 13, 10, "ERROR: the macOS executable could not be made: the program keeps an", 13, 10
                  db "       address in a dq of its code, or the shim is missing.", 13, 10, 0
    msg_xarm_insn db "  instruction: ", 0
    msg_arm_start db "ERROR: no _start label", 13, 10
                 db "  hint: an ARM64 Linux program starts at _start", 13, 10, 0
    dbg_1        db "  [1] reading file", 13, 10, 0
    dbg_2        db "  [2] kasm_init", 13, 10, 0
    dbg_3        db "  [3] kasm_assemble", 13, 10, 0
    dbg_4        db "  [4] writing output", 13, 10, 0
    msg_asm_ok   db "Bytes written: ", 0
    msg_asm_err  db "ERROR: kasm failed to assemble.", 13, 10, 0
    msg_ok       db " OK", 13, 10, 0
    msg_dumped   db "Expanded text written to: ", 0
    msg_nl       db 13, 10, 0
    dump_suffix  db ".expanded", 0
    msg_done     db 13, 10, "Compilation successful!", 13, 10, 0
    msg_err_args db "ERROR: usage: kronc.exe file.kr [-o output] [-S] [--check]", 13, 10, 0
    msg_checked  db "Check passed: no errors.", 13, 10, 0
    msg_err_target db "ERROR: unknown target", 13, 10
                 db "  hint: use --target=windows, --target=linux, --target=linux-arm64, --target=web, --target=krn or --target=bare", 13, 10, 0
    msg_err_read db "ERROR: cannot read the file.", 13, 10, 0
    msg_imp_pre  db "ERROR: acquire_domain: ", 0
    msg_slice_imp db 13, 10, "ERROR: slice<...> uses std_arena.kr, which is not imported", 13, 10
                  db "  hint: add  acquire_domain ", 34, "std_arena.kr", 34, ";  to the header", 13, 10, 0
    s_std_arena  db "std_arena.kr", 0
    s_std_text   db "std_text.kr", 0
    s_std_list   db "std_list.kr", 0
    s_std_map    db "std_map.kr", 0
    msg_text_imp db 13, 10, "ERROR: the type text uses std_text.kr, which is not imported", 13, 10
                 db "  hint: add  acquire_domain ", 34, "std_text.kr", 34, ";  to the header", 13, 10, 0
    msg_list_imp db 13, 10, "ERROR: list<...> uses std_list.kr, which is not imported", 13, 10
                 db "  hint: add  acquire_domain ", 34, "std_list.kr", 34, ";  (or std_text.kr, which brings it) to the header", 13, 10, 0
    msg_map_imp  db 13, 10, "ERROR: map<...> uses std_map.kr, which is not imported", 13, 10
                 db "  hint: add  acquire_domain ", 34, "std_map.kr", 34, ";  to the header", 13, 10, 0
    msg_imp_open db "cannot find the module '", 0
    msg_imp_deep db "imports nest deeper than 8 levels, at '", 0
    msg_imp_many db "too many modules (more than 64, or more than 16 imports in one file), at '", 0
    msg_imp_post db "'", 13, 10, 0
    msg_imp_hint1 db "  hint: the file has to be in the program's folder, with its .kr extension", 13, 10, 0
    msg_imp_hint2 db "  hint: check the chain of imports: each module imports only what it uses", 13, 10, 0
    msg_err_lex  db "ERROR: lexer failed.", 13, 10, 0
    msg_err_parse db "ERROR: parser failed. Token=", 0
    msg_err_pos   db " Position=", 0
    msg_err_line  db " Line=", 0
    msg_err_found db "  (found: ", 0
    msg_err_close db ")", 0
    ; --- diagnostics: file:line:col, the source line, and a caret ---------
    d_colon      db ":", 0
    d_sp2        db "  ", 0
    d_unexpected db ": unexpected ", 0
    d_expected   db ": expected ", 0
    d_found      db ", found ", 0
    d_indent     db "    ", 0
    d_caret      db "^", 0
    d_sp1        db " ", 0
    d_nl         db 13, 10, 0
    d_colon2     db ": ", 0
    d_quote      db "'", 0
    d_sem_undecl db "undeclared name ", 0
    d_hint_pre   db "  hint: did you mean '", 0
    d_hint_suf   db "'?", 13, 10, 0
    d_sem_dup    db "duplicate arena name ", 0
    d_sem_zero   db "arena declared with zero size ", 0
    d_sem_ovl    db "arenas overlap ", 0
    d_sem_noarr  db "undeclared array ", 0
    d_sem_lval   db "cannot assign to this", 0
    d_sem_arrsz  db "array smaller than the parameter it is passed to ", 0
    d_sem_raw    db "only allowed inside raw: ", 0
    d_sem_aw     db "array element type differs from the parameter's ", 0
    d_sem_thread db "global used by code that runs in a thread ", 0
    d_error_pre  db "ERROR: ", 0
    d_hint_thread db "  hint: declare it 'shared var' and guard it with a lock, or pass the value through a channel", 13, 10, 0
    d_hint_raw   db "  hint: put it inside raw { ... }: memory by address (peek, poke, *p) and the system (dll_load, dll_proc, syscall) are reached only there", 13, 10, 0
    d_hint_arrsz db "  hint: the function indexes as far as its parameter declares; pass an array at least that big", 13, 10, 0
    d_hint_aw    db "  hint: elements are stored at their own width ([u8; N] one byte each), so the parameter must declare the same element type", 13, 10, 0
    d_note_exp   db "  note: line numbers refer to the source after "
                 db "acquire_domain expansion, so a line inside an imported "
                 db "module will not match your file.", 13, 10, 0
    msg_err_sem   db "ERROR: undeclared variable at line ", 0
    msg_err_arn_dup  db "ERROR: duplicate arena name at line ", 0
    msg_err_arn_zero db "ERROR: arena of size zero at line ", 0
    msg_err_arn_ovl  db "ERROR: arenas with overlapping regions at line ", 0
    msg_newline   db 13, 10, 0
    msg_err_code  db "ERROR: codegen failed.", 13, 10, 0
    msg_err_write db "ERROR: could not write the output file.", 13, 10
                  db "  hint: is the program still running, or the file open elsewhere?", 13, 10, 0
    msg_wrote     db "Written: ", 0
    asm_ext       db ".asm", 0
    bin_ext       db ".kbin", 0
    krn_ext       db ".krn", 0
    exe_ext       db ".exe", 0
    elf_ext       db 0                ; a Linux executable has no extension
    wasm_ext      db ".wasm", 0
    html_ext      db ".html", 0
    web_js_name   db "kron_web.js", 0
    msg_web_also  db 13, 10, "  with its page (.html) and kron_web.js beside it", 13, 10, 0
    web_page_a    db "<!doctype html>", 10, "<html>", 10, "<head>", 10, '<meta charset="utf-8">', 10
                  db '<meta name="viewport" content="width=device-width, initial-scale=1">', 10, "<title>", 0
    web_page_b    db "</title>", 10, "<style>", 10
                  db "body { margin: 0; background: #1e1e1e; color: #d4d4d4; font: 14px monospace; }", 10
                  db "canvas { display: none; outline: none; margin: 8px; }", 10
                  db "pre { margin: 8px; white-space: pre-wrap; }", 10
                  db "</style>", 10, "</head>", 10, "<body>", 10
                  db '<canvas id="kron"></canvas>', 10, '<pre id="out"></pre>', 10
                  db '<script src="kron_web.js"></script>', 10
                  db '<script>KronWeb.start({ wasm: "', 0
    web_page_c    db '", canvas: "#kron", console: "#out" });</script>', 10
                  db "</body>", 10, "</html>", 10, 0
    msg_xwasm_err db 13, 10, "ERROR: xwasm could not lower the generated code to WebAssembly", 13, 10, 0
    ew_start_name db "_start", 0
    bin_ext_ptr   dq 0

section .bss
    arg_input    resb 512
    arg_output   resb 512
    arg_flag_S   resb 1        ; -S: write the .asm instead of the .exe
    imp_pathbuf  resb 512      ; a module's name, next to the program
    ew_count     resq 1        ; elf_write: fixups to visit
    ew_lbl       resq 1        ; elf_write: the label of the current fixup
    ew_sec       resq 1        ; elf_write: its section
    ew_val       resq 1        ; elf_write: the address to store
    ew_img       resq 1        ; elf_write: length of the flat image
    arg_flag_check resb 1      ; --check: report errors, write nothing
    arg_flag_window resb 1     ; --window: a Windows program with no console
    src_buffer   resb SRC_BUFFER_SIZE
    dump_name    resb 512               ; '<input>.expanded'
    exp_buffer   resb SRC_BUFFER_SIZE   ; source after expanding imports
    inc_buffer   resb SRC_BUFFER_SIZE   ; one imported file at a time
    inc_buffer2  resb SRC_BUFFER_SIZE   ; the level below that one
    pp_depth     resq 1                 ; nesting level of %include
    pp_out_end   resq 1                 ; one past the last writable byte
    pp_dup       resb 1                 ; 1 when the macro was already known
    pp_inc_buf   resq 1                 ; buffer chosen for the current %include
    inc_name     resb 260
    ; --- import resolution ------------------------------------------------
    ; Before anything is spliced, every module the program needs is found by
    ; walking the imports depth first: the program's own, then each module's,
    ; and so on. The result is one list in dependency order -- every module
    ; after the ones it uses, each exactly once -- and the splice then pastes
    ; that list at the first acquire_domain of the program.
    ;
    ; The walk keeps an explicit stack of frames rather than recursing: each
    ; frame holds a file's name and the imports read from its header.
    imp_count    resd 1                 ; modules in the resolved list
    imp_i        resd 1                 ; next one to splice
    imp_emitted  resd 1                 ; list already spliced
    imp_err      resd 1                 ; 1 cannot open, 2 too deep, 3 too many
    imp_names    resb IMP_MAX * 256     ; the resolved list, in order
    imp_errname  resb 260
    dfs_depth    resd 1
    dfs_nkids    resd IMP_DEPTH
    dfs_ki       resd IMP_DEPTH
    dfs_name     resb IMP_DEPTH * 256
    dfs_kids     resb IMP_DEPTH * IMP_KIDS * 256
    pp_name      resb 260               ; filename from a %include
    ; --- line map -------------------------------------------------------
    ; expand_imports splices whole files into exp_buffer, so a line number
    ; from the parser refers to the EXPANDED text and not to any file the
    ; programmer wrote. The map records, for each run of expanded lines,
    ; which file it came from and which line it started at there.
    ;
    ; One entry per switch of file: two per import plus the first, so 128
    ; covers 63 imports. Imports are one level deep, so no nesting.
    LMAP_MAX     equ 128
    lmap_out     resq LMAP_MAX          ; first line in the expanded text
    lmap_file    resq LMAP_MAX          ; pointer to the file name
    lmap_src     resq LMAP_MAX          ; line it starts at in that file
    lmap_count   resq 1
    cg_hint_msg  resq 1                     ; hint of a codegen type error
    lmap_names   resb (LMAP_MAX * 260)  ; names copied: inc_name is reused
    lmap_names_n resq 1
    lmap_outline resq 1        ; line being written in the expanded text
    lmap_srcline resq 1        ; line being read in the main file
    lmap_hdrskip resq 1        ; lines of the importee's own module header
                               ; that the splice steps over
    pp_path      resb 320               ; the same name with a directory prefix
    mac_names    resb 1024              ; packed macro names
    mac_names_len resq 1
    mac_name_off resd 32
    mac_nparams  resb 32
    mac_body_off resd 32
    mac_body_len resd 32
    mac_bodies   resb 16384             ; macro bodies, verbatim
    mac_bodies_len resq 1
    mac_count    resq 1
    pp_args      resb 512               ; arguments of the call being expanded
    pp_arg_off   resd 8
    pp_arg_len   resd 8
    pp_argc      resq 1
    out_target   resb 1
    web_html_name resb 512
    web_js_path  resb 512
    web_page     resb 4096
    out_bin_name resb 512               ; filename taken from the directive
    src_size     resq 1
    token_buffer resb TOKEN_BUFFER_SIZE
    token_count  resq 1
    ast_buffer   resb AST_BUFFER_SIZE
    ast_count    resq 1
    code_buffer  resb CODE_BUFFER_SIZE
    sym_buffer   resb SYM_BUFFER_SIZE
    code_size    resq 1
    out_asm_name resb 512
    hStdOut      resq 1

section .text
global main
global print_string
global lmap_lookup

main:
    push rbp
    mov  rbp, rsp
    
    ; Get stdout
    sub  rsp, 32
    mov  rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    add  rsp, 32
    mov  [rel hStdOut], rax
    
    ; Banner
    lea  rcx, [rel banner]
    call print_string
    
    ; GoLink enters directly with no CRT: there is no argc/argv.
    ; Get and parse Windows' real command line.
    sub  rsp, 32
    call GetCommandLineA
    add  rsp, 32
    mov  rcx, rax
    push rax
    call parse_command_line
    test rax, rax
    pop  rcx
    jz   .error_args
    ; pick the output target from the command line (rcx = the line). It
    ; comes first because --assemble needs it too: ARM64 goes to karm.
    call scan_target
    cmp  al, 255
    je   .error_target
    mov  [rel out_target], al
    ; ARM64 generates the Linux program, which xarm then lowers to ARM64;
    ; the web generates it too, and xwasm lowers it to WebAssembly
    mov  dil, al
    cmp  dil, TARGET_WEB
    je   .cg_linux
    cmp  dil, TARGET_MACOS
    je   .cg_linux
    cmp  dil, TARGET_ARM64
    jne  .cg_target
.cg_linux:
    mov  dil, TARGET_ELF
    jmp  .cg_target
.cg_target:
    call jup_codegen_set_target

    ; --assemble : run only the assembler over an existing .asm file
    call scan_assemble_flag
    test al, al
    jnz  .assemble_only


    ; [PHASE 1] Read the file
    lea  rcx, [rel msg_read]
    call print_string
    
    lea  rcx, [rel arg_input]
    lea  rdx, [rel src_buffer]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    
    mov  [rel src_size], rax
    test rax, rax
    jz   .error_read
    
    ; expand  acquire_domain "file.jup";  directives into exp_buffer
    sub  rsp, 32
    lea  rcx, [rel src_buffer]
    mov  rdx, [rel src_size]
    lea  r8,  [rel exp_buffer]
    call expand_imports          ; -> rax = expanded length, or -1
    add  rsp, 32
    cmp  rax, -1
    je   .error_import
    mov  [rel src_size], rax

    ; --dump: write the expanded text out before anything else touches it
    call scan_dump_flag
    test al, al
    jz   .no_dump
    ; build '<input>.expanded'
    lea  rdi, [rel dump_name]
    lea  rsi, [rel arg_input]
.dcp:
    mov  al, [rsi]
    test al, al
    jz   .dcp_end
    mov  [rdi], al
    inc  rsi
    inc  rdi
    jmp  .dcp
.dcp_end:
    lea  rsi, [rel dump_suffix]
.dsf:
    mov  al, [rsi]
    mov  [rdi], al
    test al, al
    jz   .dsf_end
    inc  rsi
    inc  rdi
    jmp  .dsf
.dsf_end:
    push r12
    sub  rsp, 32
    lea  rcx, [rel dump_name]
    lea  rdx, [rel exp_buffer]
    mov  r8, [rel src_size]
    call write_file
    add  rsp, 32
    pop  r12
    lea  rcx, [rel msg_dumped]
    call print_string
    lea  rcx, [rel dump_name]
    call print_string
    lea  rcx, [rel msg_nl]
    call print_string
.no_dump:

    lea  rcx, [rel msg_ok]
    call print_string
    
    ; [PHASE 2] LEXER
    lea  rcx, [rel msg_lex]
    call print_string
    
    sub  rsp, 32
    lea  rcx, [rel exp_buffer]
    mov  rdx, [rel src_size]
    lea  r8,  [rel token_buffer]
    lea  r9,  [rel token_count]
    call jup_lexer_init
    add  rsp, 32
    
    sub  rsp, 32
    call jup_lexer_run
    add  rsp, 32
    test rax, rax
    jz   .error_lex
    
    lea  rcx, [rel msg_ok]
    call print_string
    
    ; [PHASE 3] PARSER
    lea  rcx, [rel msg_parse]
    call print_string

    ; The parser's own internal ABI: rdi, rsi, rdx, rcx.
    lea  rdi, [rel token_buffer]
    mov  rsi, [rel token_count]
    lea  rdx, [rel ast_buffer]
    mov  rcx, AST_BUFFER_SIZE
    call jup_parser_init
    
    sub  rsp, 32
    call jup_parser_run
    add  rsp, 32
    test rax, rax
    jz   .error_parse

    ; v[i] on a slice became a call to slice_get / slice_set, which live in
    ; std_arena.kr. Without that import kasm would not notice the missing
    ; function -- it does not check undefined symbols -- so say it here.
    cmp  dword [rel par_used_slice], 0
    je   .slice_ok
    xor  ebx, ebx
.slice_imp:
    cmp  ebx, [rel imp_count]
    jae  .error_slice
    mov  eax, ebx
    shl  rax, 8
    lea  rsi, [rel imp_names]
    add  rsi, rax
    lea  rdi, [rel s_std_arena]
    call imp_streq
    test eax, eax
    jnz  .slice_ok
    inc  ebx
    jmp  .slice_imp
.slice_ok:
    ; the built-in types text, list<T> and map<T> are handles of the library
    cmp  dword [rel par_used_text], 0
    je   .text_ok
    lea  rdi, [rel s_std_text]
    call imp_have
    test eax, eax
    jnz  .text_ok
    lea  rcx, [rel msg_text_imp]
    jmp  .error_type_imp
.text_ok:
    cmp  dword [rel par_used_list], 0
    je   .list_ok
    lea  rdi, [rel s_std_list]
    call imp_have
    test eax, eax
    jnz  .list_ok
    lea  rcx, [rel msg_list_imp]
    jmp  .error_type_imp
.list_ok:
    cmp  dword [rel par_used_map], 0
    je   .map_ok
    lea  rdi, [rel s_std_map]
    call imp_have
    test eax, eax
    jnz  .map_ok
    lea  rcx, [rel msg_map_imp]
    jmp  .error_type_imp
.map_ok:
    
    lea  rcx, [rel msg_ok]
    call print_string

    ; [PHASE 4] SEMANTIC ANALYSIS (type checking)
    lea  rcx, [rel msg_sem]
    call print_string
    ; init with a dedicated arena buffer (rdi=buffer, rsi=size)
    lea  rcx, [rel sym_buffer]
    mov  rdx, SYM_BUFFER_SIZE
    mov  rdi, rcx
    mov  rsi, rdx
    sub  rsp, 32
    call jup_semantic_init
    add  rsp, 32
    call parser_get_ast_root
    mov  rdi, rax
    sub  rsp, 32
    call jup_semantic_run
    add  rsp, 32
    test rax, rax
    jz   .sem_ok
    ; semantic error: report the line and abort
    lea  rcx, [rel msg_newline]
    call print_string
    call jup_semantic_error_kind
    cmp  rax, 1
    je   .sem_msg_dup
    cmp  rax, 2
    je   .sem_msg_zero
    cmp  rax, 3
    je   .sem_msg_ovl
    cmp  rax, 4
    je   .sem_msg_noarr
    cmp  rax, 5
    je   .sem_msg_lval
    cmp  rax, 6
    je   .sem_msg_arrsz
    cmp  rax, 7
    je   .sem_msg_raw
    cmp  rax, 9
    je   .sem_msg_aw
    lea  rcx, [rel d_sem_undecl]
    jmp  .sem_msg_go
.sem_msg_dup:
    lea  rcx, [rel d_sem_dup]
    jmp  .sem_msg_go
.sem_msg_zero:
    lea  rcx, [rel d_sem_zero]
    jmp  .sem_msg_go
.sem_msg_ovl:
    lea  rcx, [rel d_sem_ovl]
    jmp  .sem_msg_go
.sem_msg_noarr:
    lea  rcx, [rel d_sem_noarr]
    jmp  .sem_msg_go
.sem_msg_lval:
    lea  rcx, [rel d_sem_lval]
    jmp  .sem_msg_go
.sem_msg_arrsz:
    lea  rcx, [rel d_sem_arrsz]
    jmp  .sem_msg_go
.sem_msg_raw:
    lea  rcx, [rel d_sem_raw]
    jmp  .sem_msg_go
.sem_msg_aw:
    lea  rcx, [rel d_sem_aw]
.sem_msg_go:
    ; file:line:col: <what went wrong> 'name'
    ;     <the source line>
    ;     ^^^^
    push rcx                         ; the message, printed after the position
    call jup_semantic_error_line
    mov  rcx, rax
    call lmap_lookup
    push rdx
    mov  rcx, rax
    call print_string
    lea  rcx, [rel d_colon]
    call print_string
    pop  rcx
    call print_u64
    lea  rcx, [rel d_colon]
    call print_string
    call jup_semantic_error_col
    mov  rcx, rax
    call print_u64
    lea  rcx, [rel d_colon2]
    call print_string
    pop  rcx
    call print_string
    ; the offending name, straight out of the source. Skipped for kind 5,
    ; where what is wrong is the shape of the target, not a name.
    call jup_semantic_error_kind
    cmp  rax, 5
    je   .sem_noname
    call jup_semantic_error_name
    test rax, rax
    jz   .sem_noname
    test rdx, rdx
    jz   .sem_noname
    push rax
    push rdx
    lea  rcx, [rel d_quote]
    call print_string
    pop  r8
    pop  rdx
    sub  rsp, 64
    mov  rcx, [rel hStdOut]
    lea  r9, [rsp + 48]
    mov  qword [rsp + 32], 0
    call WriteFile
    add  rsp, 64
    lea  rcx, [rel d_quote]
    call print_string
.sem_noname:
    lea  rcx, [rel d_nl]
    call print_string
    call jup_semantic_error_line
    push rax
    call jup_semantic_error_col
    push rax
    call jup_semantic_error_len
    mov  r8, rax
    pop  rdx
    pop  rcx
    call print_error_line
    ; kind 6 has a fixed hint of its own; the closest-name one does not apply
    call jup_semantic_error_kind
    lea  rcx, [rel d_hint_arrsz]
    cmp  rax, 6
    je   .sem_fixed_hint
    lea  rcx, [rel d_hint_raw]
    cmp  rax, 7
    je   .sem_fixed_hint
    lea  rcx, [rel d_hint_aw]
    cmp  rax, 9
    je   .sem_fixed_hint
    mov  rcx, [rel cg_hint_msg]
    cmp  rax, 10
    je   .sem_hint10
    lea  rcx, [rel d_hint_thread]
    cmp  rax, 8
    jne  .sem_suggest
.sem_hint10:
    test rcx, rcx
    jz   .sem_nohint
.sem_fixed_hint:
    call print_string
    jmp  .sem_nohint
.sem_suggest:
    ; hint: the closest declared name, when one is within a single edit
    call jup_semantic_suggestion
    test rax, rax
    jz   .sem_nohint
    test rdx, rdx
    jz   .sem_nohint
    push rax
    push rdx
    lea  rcx, [rel d_hint_pre]
    call print_string
    pop  r8
    pop  rdx
    sub  rsp, 64
    mov  rcx, [rel hStdOut]
    lea  r9, [rsp + 48]
    mov  qword [rsp + 32], 0
    call WriteFile
    add  rsp, 64
    lea  rcx, [rel d_hint_suf]
    call print_string
.sem_nohint:
    mov  eax, 4
    pop  rbp
    ret
.sem_ok:
    lea  rcx, [rel msg_ok]
    call print_string

    ; [PHASE 5] CODEGEN -> real x86-64 assembly
    lea  rcx, [rel msg_code]
    call print_string

    lea  rcx, [rel code_buffer]
    mov  rdx, CODE_BUFFER_SIZE
    sub  rsp, 32
    mov  rdi, rcx                 ; internal ABI: rdi=buf, rsi=cap
    mov  rsi, rdx
    call jup_codegen_init
    add  rsp, 32

    call parser_get_ast_root
    mov  rdi, rax                 ; internal ABI: rdi = ast root
    sub  rsp, 32
    call jup_codegen_run
    add  rsp, 32
    test rax, rax
    jz   .error_code

    lea  rcx, [rel msg_ok]
    call print_string

    ; --check: everything has been checked, the thread rule included;
    ; nothing is written
    cmp  byte [rel arg_flag_check], 0
    je   .not_check
    lea  rcx, [rel msg_checked]
    call print_string
    xor  eax, eax
    pop  rbp
    ret
.not_check:

    ; [PHASE 6] Write the output
    lea  rcx, [rel msg_link]
    call print_string

    ; A Windows executable goes straight from the generated assembly to the
    ; .exe, in memory, as a C compiler does: no .asm is left behind. -S asks
    ; for the .asm instead; ELF and bare metal have no kasm path yet and
    ; always get the .asm.
    cmp  byte [rel out_target], TARGET_ARM64
    je   .arm_out
    cmp  byte [rel out_target], TARGET_MACOS
    je   .arm_out
    cmp  byte [rel out_target], TARGET_WEB
    je   .web_out
    cmp  byte [rel arg_flag_S], 0
    jne  .write_asm
    cmp  byte [rel out_target], TARGET_PE
    je   .direct_exe
    cmp  byte [rel out_target], TARGET_ELF
    je   .direct_exe
    jmp  .write_asm
.write_asm:
    call build_asm_name           ; builds out_asm_name from arg_input

    call codegen_get_code
    mov  r10, rax                 ; code pointer
    call codegen_get_code_size
    mov  r11, rax                 ; length

    lea  rcx, [rel out_asm_name]
    mov  rdx, r10
    mov  r8,  r11
    call write_file
    test rax, rax
    jz   .error_write

    lea  rcx, [rel msg_ok]
    call print_string

    lea  rcx, [rel msg_wrote]
    call print_string
    lea  rcx, [rel out_asm_name]
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string

    ; Final message
    lea  rcx, [rel msg_done]
    call print_string
    
    xor  eax, eax
    pop  rbp
    ret
    
.arm_out:
    ; ARM64: the generated text -> preprocessor -> xarm -> karm -> ELF.
    ; With -S the ARM64 text is what gets written.
    call codegen_get_code_size
    mov  [rel src_size], rax
    call codegen_get_code
    mov  rcx, rax
    mov  rdx, [rel src_size]
    lea  r8,  [rel exp_buffer]
    call asm_preprocess
    mov  [rel src_size], rax
    ; macOS runs the same program, with the shim that answers its Linux
    ; calls from XNU
    xor  ecx, ecx
    cmp  byte [rel out_target], TARGET_MACOS
    jne  .arm_os
    mov  ecx, 1
.arm_os:
    sub  rsp, 32
    call xarm_set_os
    add  rsp, 32
    sub  rsp, 32
    lea  rcx, [rel exp_buffer]
    mov  rdx, [rel src_size]
    lea  r8,  [rel code_buffer]
    mov  r9,  CODE_BUFFER_SIZE
    call xarm_translate
    add  rsp, 32
    cmp  rax, -1
    je   .error_xarm
    mov  [rel src_size], rax
    cmp  byte [rel arg_flag_S], 0
    je   .arm_image
    call build_asm_name
    lea  rcx, [rel out_asm_name]
    lea  rdx, [rel code_buffer]
    mov  r8,  [rel src_size]
    call write_file
    test rax, rax
    jz   .error_write
    lea  rcx, [rel msg_ok]
    call print_string
    lea  rcx, [rel msg_wrote]
    call print_string
    lea  rcx, [rel out_asm_name]
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel msg_done]
    call print_string
    xor  eax, eax
    pop  rbp
    ret
.arm_image:
    cmp  byte [rel out_target], TARGET_MACOS
    je   .mac_image
    sub  rsp, 32
    call karm_init
    mov  rcx, 0x400080
    call karm_set_base
    lea  rcx, [rel code_buffer]
    mov  rdx, [rel src_size]
    call karm_assemble
    add  rsp, 32
    test rax, rax
    jz   .error_karm
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call elf_write_arm
    add  rsp, 32
    mov  r11, rax
    lea  r10, [rel code_buffer]
    lea  rcx, [rel elf_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .direct_name

.mac_image:
    ; macOS: the code at 0x100004000, after the page of the header, and each
    ; section on a 16 KB page of its own; then the Mach-O file around it
    sub  rsp, 32
    call karm_init
    mov  rcx, 0x100004000
    call karm_set_base
    mov  rcx, 0x4000
    call karm_set_align
    lea  rcx, [rel code_buffer]
    mov  rdx, [rel src_size]
    call karm_assemble
    add  rsp, 32
    test rax, rax
    jz   .error_karm
    lea  rcx, [rel elf_ext]
    mov  [rel bin_ext_ptr], rcx
    call build_bin_name
    ; the name in the signature: the file's, without its folder
    lea  rdx, [rel out_bin_name]
    mov  rax, rdx
.mac_base:
    mov  cl, [rax]
    test cl, cl
    jz   .mac_named
    inc  rax
    cmp  cl, '/'
    je   .mac_sep
    cmp  cl, 92
    je   .mac_sep
    jmp  .mac_base
.mac_sep:
    mov  rdx, rax
    jmp  .mac_base
.mac_named:
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call macho_write
    add  rsp, 32
    test rax, rax
    jz   .error_macho
    mov  r11, rax
    lea  r10, [rel code_buffer]
    jmp  .direct_name

.error_macho:
    lea  rcx, [rel msg_macho_err]
    call print_string
    mov  eax, 1
    pop  rbp
    ret

.web_out:
    ; the web: the generated text -> preprocessor -> xwasm -> NAME.wasm, with
    ; NAME.html to open it and kron_web.js, the host, next to it. -S writes
    ; the x86 text xwasm reads.
    cmp  byte [rel arg_flag_S], 0
    jne  .write_asm
    call codegen_get_code_size
    mov  [rel src_size], rax
    call codegen_get_code
    mov  rcx, rax
    mov  rdx, [rel src_size]
    lea  r8,  [rel exp_buffer]
    call asm_preprocess
    mov  [rel src_size], rax
    sub  rsp, 32
    lea  rcx, [rel exp_buffer]
    mov  rdx, [rel src_size]
    lea  r8,  [rel code_buffer]
    mov  r9,  CODE_BUFFER_SIZE
    call xwasm_translate
    add  rsp, 32
    cmp  rax, -1
    je   .error_xwasm
    mov  r11, rax
    lea  r10, [rel code_buffer]
    lea  rcx, [rel wasm_ext]
    mov  [rel bin_ext_ptr], rcx
    push r10
    push r11
    call build_bin_name
    pop  r11
    pop  r10
    lea  rcx, [rel out_bin_name]
    mov  rdx, r10
    mov  r8,  r11
    call write_file
    test rax, rax
    jz   .error_write
    call web_write_host
    test rax, rax
    jz   .error_write
    lea  rcx, [rel msg_ok]
    call print_string
    lea  rcx, [rel msg_wrote]
    call print_string
    lea  rcx, [rel out_bin_name]
    call print_string
    lea  rcx, [rel msg_web_also]
    call print_string
    lea  rcx, [rel msg_done]
    call print_string
    xor  eax, eax
    pop  rbp
    ret

.error_xwasm:
    lea  rcx, [rel msg_xwasm_err]
    call print_string
    lea  rcx, [rel msg_asm_line]
    call print_string
    sub  rsp, 32
    call xwasm_error_line
    add  rsp, 32
    mov  rcx, rax
    call print_u64
    lea  rcx, [rel msg_karm_sep]
    call print_string
    sub  rsp, 32
    call xwasm_error_text
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel msg_xarm_insn]
    call print_string
    sub  rsp, 32
    call xwasm_error_insn
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    mov  eax, 1
    pop  rbp
    ret

.error_xarm:
    ; the line of the generated text, what was wrong and the instruction
    lea  rcx, [rel msg_xarm_err]
    call print_string
    lea  rcx, [rel msg_asm_line]
    call print_string
    sub  rsp, 32
    call xarm_error_line
    add  rsp, 32
    mov  rcx, rax
    call print_u64
    lea  rcx, [rel msg_karm_sep]
    call print_string
    sub  rsp, 32
    call xarm_error_text
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel msg_xarm_insn]
    call print_string
    sub  rsp, 32
    call xarm_error_insn
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    mov  eax, 1
    pop  rbp
    ret

.direct_exe:
    ; the generated text -> preprocessor -> kasm -> pe_writer -> .exe
    call codegen_get_code_size
    mov  [rel src_size], rax
    call codegen_get_code
    mov  rcx, rax
    mov  rdx, [rel src_size]
    lea  r8,  [rel exp_buffer]
    call asm_preprocess
    mov  [rel src_size], rax
    sub  rsp, 32
    call kasm_init
    add  rsp, 32
    sub  rsp, 32
    lea  rcx, [rel exp_buffer]
    mov  rdx, [rel src_size]
    call kasm_assemble
    add  rsp, 32
    test rax, rax
    jz   .error_asm
    cmp  byte [rel out_target], TARGET_ELF
    je   .direct_elf
    mov  al, [rel arg_flag_window]
    mov  [rel pw_gui], al         ; --window: the GUI subsystem, no console
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call pw_write                 ; the PE goes into code_buffer, rax = length
    mov  r11, rax
    lea  r10, [rel code_buffer]
    add  rsp, 32
    lea  rcx, [rel exe_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .direct_name
.direct_elf:
    ; Linux: the same image, in an ELF file with no extension
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call elf_write                ; the ELF goes into code_buffer, rax = length
    mov  r11, rax
    lea  r10, [rel code_buffer]
    add  rsp, 32
    lea  rcx, [rel elf_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .direct_name
.direct_name:
    call build_bin_name
    lea  rcx, [rel out_bin_name]
    mov  rdx, r10
    mov  r8,  r11
    call write_file
    test rax, rax
    jz   .error_write
    lea  rcx, [rel msg_ok]
    call print_string
    lea  rcx, [rel msg_wrote]
    call print_string
    lea  rcx, [rel out_bin_name]
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel msg_done]
    call print_string
    xor  eax, eax
    pop  rbp
    ret

.assemble_only:
    lea  rcx, [rel msg_asm_mode]
    cmp  byte [rel out_target], TARGET_ARM64
    jne  .asm_mode_msg
    lea  rcx, [rel msg_asm_mode_arm]
    jmp  .asm_mode_msg
.asm_mode_msg:
    call print_string

    lea  rcx, [rel arg_input]
    lea  rdx, [rel src_buffer]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    mov  [rel src_size], rax
    test rax, rax
    jz   .error_read

    ; expand %include, %define and %macro before assembling
    lea  rcx, [rel src_buffer]
    mov  rdx, [rel src_size]
    lea  r8,  [rel exp_buffer]
    call asm_preprocess
    mov  [rel src_size], rax
    ; with -S, leave the expanded source on disk too: when something goes
    ; wrong it is far quicker to read it than to reason about the expansion
    cmp  byte [rel arg_flag_S], 0
    je   .no_pp_dump
    lea  rcx, [rel s_pp_dump]
    lea  rdx, [rel exp_buffer]
    mov  r8, [rel src_size]
    call write_file
    jmp  .no_pp_dump
.no_pp_dump:
    cmp  byte [rel out_target], TARGET_ARM64
    je   .assemble_arm

    sub  rsp, 32
    call kasm_init
    add  rsp, 32

    sub  rsp, 32
    lea  rcx, [rel exp_buffer]
    mov  rdx, [rel src_size]
    call kasm_assemble
    add  rsp, 32
    test rax, rax
    jz   .error_asm

    ; --pe wraps the assembled bytes in a PE32+ executable, written by pe_writer
    call scan_pe_flag
    test al, al
    jnz  .emit_pe

    ; --krn wraps the assembled bytes in the Kron container
    call scan_krn_flag
    test al, al
    jnz  .emit_krn

    sub  rsp, 32
    call kasm_build_image
    mov  r11, rax                 ; total image length
    call kasm_get_code
    mov  r10, rax
    add  rsp, 32
    jmp  .have_image

.emit_pe:
    sub  rsp, 32
    lea  rcx, [rel code_buffer]   ; scratch buffer for the PE (not used with --assemble)
    call pw_write                 ; writes the PE into code_buffer, rax = length
    mov  r11, rax
    lea  r10, [rel code_buffer]
    add  rsp, 32
    lea  rcx, [rel exe_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .have_image

.emit_krn:
    sub  rsp, 32
    call krn_init
    call krn_build
    mov  r11, rax
    call krn_get_image
    mov  r10, rax
    add  rsp, 32
    lea  rcx, [rel krn_ext]
    mov  [rel bin_ext_ptr], rcx

.have_image:
    call build_bin_name

    lea  rcx, [rel out_bin_name]
    mov  rdx, r10
    mov  r8,  r11
    call write_file
    test rax, rax
    jz   .error_write

    lea  rcx, [rel msg_asm_ok]
    call print_string
    lea  rcx, [rel out_bin_name]
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    xor  eax, eax
    pop  rbp
    ret

.assemble_arm:
    ; ARM64: karm instead of kasm, and an AArch64 ELF around the image. The
    ; image sits at 0x400080, after the 0x80 bytes of headers, as on x86-64.
    sub  rsp, 32
    call karm_init
    mov  rcx, 0x400080
    call karm_set_base
    lea  rcx, [rel exp_buffer]
    mov  rdx, [rel src_size]
    call karm_assemble
    add  rsp, 32
    test rax, rax
    jz   .error_karm
    sub  rsp, 32
    call karm_get_entry
    add  rsp, 32
    test rax, rax
    jz   .error_arm_start
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call elf_write_arm
    add  rsp, 32
    mov  r11, rax
    lea  r10, [rel code_buffer]
    lea  rcx, [rel elf_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .have_image

.error_karm:
    ; every line karm refused, with what was wrong
    lea  rcx, [rel msg_karm_err]
    call print_string
    sub  rsp, 32
    call karm_get_error_count
    add  rsp, 32
    mov  r14, rax
    xor  r15, r15
    jmp  .ek_loop
.ek_loop:
    cmp  r15, r14
    jae  .ek_done
    lea  rcx, [rel msg_asm_line]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call karm_get_error_line_at
    add  rsp, 32
    mov  rcx, rax
    call print_u64
    lea  rcx, [rel msg_mnem]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call karm_get_error_mnem
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_karm_sep]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call karm_get_error_text
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_newline]
    call print_string
    inc  r15
    jmp  .ek_loop
.ek_done:
    mov  eax, 1
    pop  rbp
    ret

.error_arm_start:
    lea  rcx, [rel msg_arm_start]
    call print_string
    mov  eax, 1
    pop  rbp
    ret

.error_asm:
    lea  rcx, [rel msg_asm_err]
    call print_string
    ; list every line kasm could not assemble, not just the first
    sub  rsp, 32
    call kasm_get_error_count
    add  rsp, 32
    mov  r14, rax
    xor  r15, r15
.ea_loop:
    cmp  r15, r14
    jae  .ea_done
    lea  rcx, [rel msg_asm_line]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call kasm_get_error_line_at
    add  rsp, 32
    mov  rcx, rax
    call print_u64
    ; operand kinds, so a misclassified operand is visible immediately
    ; the mnemonic, because the line number counts lines of kasm's own
    ; preprocessed text and does not match the file nasm -E writes
    lea  rcx, [rel msg_mnem]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call kasm_get_error_mnem
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel msg_dst]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call kasm_get_error_dst
    add  rsp, 32
    mov  rcx, rax
    call print_u64
    lea  rcx, [rel msg_src]
    call print_string
    mov  rcx, r15
    sub  rsp, 32
    call kasm_get_error_src
    add  rsp, 32
    mov  rcx, rax
    call print_u64
    lea  rcx, [rel msg_newline]
    call print_string
    inc  r15
    jmp  .ea_loop
.ea_done:
    mov  eax, 1
    pop  rbp
    ret

.error_args:
    lea  rcx, [rel msg_err_args]
    call print_string
    mov  eax, 1
    pop  rbp
    ret
    
.error_read:
    lea  rcx, [rel msg_err_read]
    call print_string
    mov  eax, 2
    pop  rbp
    ret

.error_slice:
    lea  rcx, [rel msg_slice_imp]
.error_type_imp:
    call print_string
    mov  eax, 2
    pop  rbp
    ret

.error_import:
    ; an import that cannot be resolved stops the compile here, by name. It
    ; used to be skipped without a word, and the program then failed further
    ; on with an error that pointed nowhere near the cause.
    lea  rcx, [rel msg_imp_pre]
    call print_string
    mov  eax, [rel imp_err]
    lea  rcx, [rel msg_imp_open]
    cmp  eax, 2
    jne  .ei_n3
    lea  rcx, [rel msg_imp_deep]
.ei_n3:
    cmp  eax, 3
    jne  .ei_say
    lea  rcx, [rel msg_imp_many]
.ei_say:
    call print_string
    lea  rcx, [rel imp_errname]
    call print_string
    lea  rcx, [rel msg_imp_post]
    call print_string
    mov  eax, [rel imp_err]
    lea  rcx, [rel msg_imp_hint1]
    cmp  eax, 1
    je   .ei_hint
    lea  rcx, [rel msg_imp_hint2]
.ei_hint:
    call print_string
    mov  eax, 2
    pop  rbp
    ret
    
.error_target:
    lea  rcx, [rel msg_err_target]
    call print_string
    mov  eax, 1
    pop  rbp
    ret

.error_lex:
    lea  rcx, [rel msg_err_lex]
    call print_string
    mov  eax, 3
    pop  rbp
    ret
    
.error_parse:
    ; file:line:col: unexpected <token>
    ;     <the source line>
    ;     ^^^^
    call parser_get_error_line
    mov  rcx, rax
    call lmap_lookup             ; rax = real file, rdx = real line
    push rdx
    mov  rcx, rax
    call print_string
    lea  rcx, [rel d_colon]
    call print_string
    pop  rcx
    call print_u64
    lea  rcx, [rel d_colon]
    call print_string
    call parser_get_error_col
    mov  rcx, rax
    call print_u64
    ; a message of its own takes precedence over "expected X, found Y"
    call parser_get_custom_msg
    test rax, rax
    jz   .diag_generic
    push rax
    lea  rcx, [rel d_colon2]
    call print_string
    pop  rcx
    call print_string
    lea  rcx, [rel d_nl]
    call print_string
    jmp  .diag_caret
.diag_generic:
    ; "expected <what>, found <what>" when the parser knows what it wanted
    call parser_get_expected
    test rax, rax
    jz   .diag_nowant
    push rax
    lea  rcx, [rel d_expected]
    call print_string
    pop  rdi
    sub  rsp, 32
    call token_name
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel d_found]
    call print_string
    jmp  .diag_what
.diag_nowant:
    lea  rcx, [rel d_unexpected]
    call print_string
.diag_what:
    call parser_get_error_token
    mov  rdi, rax
    sub  rsp, 32
    call token_name
    add  rsp, 32
    mov  rcx, rax
    call print_string
    lea  rcx, [rel d_nl]
    call print_string
.diag_caret:
    call parser_get_error_line
    push rax
    call parser_get_error_col
    push rax
    call parser_get_error_len
    mov  r8, rax
    pop  rdx
    pop  rcx
    call print_error_line
    mov  eax, 4
    pop  rbp
    ret

.error_code:
    ; a type error codegen found (print of a list without std_text...):
    ; with its position when it has one, and its hint
    call cg_type_error
    test rax, rax
    jz   .error_code_thr
    mov  [rel cg_hint_msg], r8
    test rdx, rdx
    jz   .error_code_nopos
    push rax
    mov  rcx, rdx
    mov  rdx, 10
    call jup_semantic_set_error
    lea  rcx, [rel msg_newline]
    call print_string
    pop  rcx
    jmp  .sem_msg_go
.error_code_nopos:
    push rax
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel d_error_pre]
    call print_string
    pop  rcx
    call print_string
    lea  rcx, [rel d_nl]
    call print_string
    mov  rcx, [rel cg_hint_msg]
    test rcx, rcx
    jz   .error_code_nohint
    call print_string
.error_code_nohint:
    mov  eax, 5
    pop  rbp
    ret
.error_code_thr:
    ; the thread check: a non-shared global in code that runs in a thread.
    ; Reported like a semantic error, with its position and source line.
    call cg_thread_error_tok
    test rax, rax
    jz   .error_code_plain
    mov  rcx, rax
    mov  rdx, 8
    call jup_semantic_set_error
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel d_sem_thread]
    jmp  .sem_msg_go
.error_code_plain:
    lea  rcx, [rel msg_err_code]
    call print_string
    movzx rcx, byte [rel dbg_which]
    call print_u64
    mov  eax, 5
    pop  rbp
    ret

.error_write:
    lea  rcx, [rel msg_err_write]
    call print_string
    mov  eax, 6
    pop  rbp
    ret

; ==============================================================================
; build_asm_name() - Builds out_asm_name = arg_input with the .asm extension
;   If arg_input ends in .kr, replace it; otherwise, append .asm
; ==============================================================================
; ==============================================================================
; scan_assemble_flag(no args) -> al = 1 when --assemble appears on the line
; ==============================================================================
; ==============================================================================
; scan_dump_flag() -> al = 1 when --dump was given.
;
; Writes the text that comes out of expand_imports to <name>.expanded, so it
; can be read. Without it, every fault in the expander had to be guessed at
; from the .asm it eventually produced -- which cost an afternoon of wrong
; diagnoses, each one a full rebuild.
; ==============================================================================
scan_dump_flag:
    ; 8 for the return address plus 8 for the push leaves rsp aligned; the
    ; 32 bytes of shadow space keep it that way. The original scanner used
    ; 40 here, which works where it is called but leaves rsp off by eight
    ; anywhere else -- and GetCommandLineA is a Windows call that expects
    ; 16-byte alignment.
    push rsi
    sub  rsp, 32
    call GetCommandLineA
    add  rsp, 32
    mov  rsi, rax
    test rsi, rsi
    jz   .dno
.dl:
    mov  al, [rsi]
    test al, al
    jz   .dno
    cmp  al, '-'
    jne  .dnx
    cmp  byte [rsi+1], '-'
    jne  .dnx
    cmp  byte [rsi+2], 'd'
    jne  .dnx
    cmp  byte [rsi+3], 'u'
    jne  .dnx
    cmp  byte [rsi+4], 'm'
    jne  .dnx
    cmp  byte [rsi+5], 'p'
    jne  .dnx
    mov  al, 1
    pop  rsi
    ret
.dnx:
    inc  rsi
    jmp  .dl
.dno:
    xor  al, al
    pop  rsi
    ret

scan_assemble_flag:
    push rsi
    sub  rsp, 40
    call GetCommandLineA
    add  rsp, 40
    mov  rsi, rax
    test rsi, rsi
    jz   .no
.l:
    mov  al, [rsi]
    test al, al
    jz   .no
    cmp  al, '-'
    jne  .nx
    cmp  byte [rsi+1], '-'
    jne  .nx
    cmp  byte [rsi+2], 'a'
    jne  .nx
    cmp  byte [rsi+3], 's'
    jne  .nx
    cmp  byte [rsi+4], 's'
    jne  .nx
    cmp  byte [rsi+5], 'e'
    jne  .nx
    mov  al, 1
    pop  rsi
    ret
.nx:
    inc  rsi
    jmp  .l
.no:
    xor  al, al
    pop  rsi
    ret

; ==============================================================================
; ==============================================================================
; scan_pe_flag() -> al = 1 when --pe appears on the command line
; ==============================================================================
scan_pe_flag:
    push rsi
    sub  rsp, 32
    call GetCommandLineA
    add  rsp, 32
    mov  rsi, rax
    test rsi, rsi
    jz   .no
.l:
    mov  al, [rsi]
    test al, al
    jz   .no
    cmp  al, '-'
    jne  .nx
    cmp  byte [rsi+1], '-'
    jne  .nx
    cmp  byte [rsi+2], 'p'
    jne  .nx
    cmp  byte [rsi+3], 'e'
    jne  .nx
    ; make sure it ends here (--pe, not --peXXX): next char is a space or nul
    mov  al, [rsi+4]
    test al, al
    jz   .yes
    cmp  al, ' '
    jne  .nx
.yes:
    mov  al, 1
    pop  rsi
    ret
.nx:
    inc  rsi
    jmp  .l
.no:
    xor  al, al
    pop  rsi
    ret

; ==============================================================================
; scan_krn_flag() -> al = 1 when --krn appears on the command line
; ==============================================================================
scan_krn_flag:
    push rsi
    sub  rsp, 32
    call GetCommandLineA
    add  rsp, 32
    mov  rsi, rax
    test rsi, rsi
    jz   .no
.l:
    mov  al, [rsi]
    test al, al
    jz   .no
    cmp  al, '-'
    jne  .nx
    cmp  byte [rsi+1], '-'
    jne  .nx
    cmp  byte [rsi+2], 'j'
    jne  .nx
    cmp  byte [rsi+3], 'p'
    jne  .nx
    cmp  byte [rsi+4], 'x'
    jne  .nx
    mov  al, 1
    pop  rsi
    ret
.nx:
    inc  rsi
    jmp  .l
.no:
    xor  al, al
    pop  rsi
    ret

; ==============================================================================
; build_bin_name() : arg_input with its extension replaced by .kbin
; ==============================================================================
build_bin_name:
    push rbx
    push rsi
    push rdi
    ; given -o, that path is the name, as it is
    lea  rsi, [rel arg_output]
    lea  rdi, [rel out_bin_name]
    xor  rbx, rbx
    cmp  byte [rsi], 0
    je   .from_input
    jmp  .copy_o
.copy_o:
    mov  al, [rsi + rbx]
    mov  [rdi + rbx], al
    test al, al
    jz   .bn_done
    inc  rbx
    cmp  rbx, 511
    jb   .copy_o
    mov  byte [rdi + rbx], 0
    jmp  .bn_done
.bn_done:
    pop  rdi
    pop  rsi
    pop  rbx
    ret
.from_input:
    lea  rsi, [rel arg_input]
.copy:
    mov  al, [rsi + rbx]
    test al, al
    jz   .find_dot
    mov  [rdi + rbx], al
    inc  rbx
    jmp  .copy
.find_dot:
    mov  rcx, rbx
.scan:
    test rcx, rcx
    jz   .append
    dec  rcx
    cmp  byte [rdi + rcx], '.'
    je   .trim
    cmp  byte [rdi + rcx], '/'
    je   .append
    cmp  byte [rdi + rcx], 92
    je   .append
    jmp  .scan
.trim:
    mov  rbx, rcx
.append:
    mov  rsi, [rel bin_ext_ptr]
    test rsi, rsi
    jnz  .have_ext
    lea  rsi, [rel bin_ext]
.have_ext:
    xor  rcx, rcx
.app_loop:
    mov  al, [rsi + rcx]
    mov  [rdi + rbx], al
    test al, al
    jz   .done
    inc  rbx
    inc  rcx
    jmp  .app_loop
.done:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
build_asm_name:
    push rbx
    push rsi
    push rdi
    ; given -o, that path is the name, as it is
    lea  rsi, [rel arg_output]
    lea  rdi, [rel out_asm_name]
    xor  rbx, rbx
    cmp  byte [rsi], 0
    je   .from_input
    jmp  .copy_o
.copy_o:
    mov  al, [rsi + rbx]
    mov  [rdi + rbx], al
    test al, al
    jz   .done
    inc  rbx
    cmp  rbx, 511
    jb   .copy_o
    mov  byte [rdi + rbx], 0
    jmp  .done
.from_input:
    lea  rsi, [rel arg_input]
.copy:
    mov  al, [rsi + rbx]
    test al, al
    jz   .find_dot
    mov  [rdi + rbx], al
    inc  rbx
    jmp  .copy
.find_dot:
    ; find the last '.' to cut the extension
    mov  rcx, rbx
.scan:
    test rcx, rcx
    jz   .append               ; no dot: append .asm at the end
    dec  rcx
    cmp  byte [rdi + rcx], '.'
    je   .trim
    cmp  byte [rdi + rcx], '/'
    je   .append
    cmp  byte [rdi + rcx], '\'
    je   .append
    jmp  .scan
.trim:
    mov  rbx, rcx              ; cut at the dot
.append:
    ; append ".asm"
    lea  rsi, [rel asm_ext]
    xor  rcx, rcx
.app_loop:
    mov  al, [rsi + rcx]
    mov  [rdi + rbx], al
    test al, al
    jz   .done
    inc  rbx
    inc  rcx
    jmp  .app_loop
.done:
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; web_write_host() : beside NAME.wasm (out_bin_name), NAME.html, the page that
; opens it, and kron_web.js, the host. Returns rax = 1 OK, 0 on error.
; ==============================================================================
web_write_host:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    sub  rsp, 8
    ; r12 = where the name begins (after the last separator), r13 = the dot
    lea  rsi, [rel out_bin_name]
    xor  rcx, rcx
    xor  r12, r12
    mov  r13, -1
.wh_scan:
    mov  al, [rsi + rcx]
    test al, al
    jz   .wh_scanned
    cmp  al, '/'
    je   .wh_sep
    cmp  al, 92
    je   .wh_sep
    cmp  al, '.'
    jne  .wh_next
    mov  r13, rcx
    jmp  .wh_next
.wh_sep:
    lea  r12, [rcx + 1]
    mov  r13, -1
.wh_next:
    inc  rcx
    jmp  .wh_scan
.wh_scanned:
    mov  r14, rcx                 ; length
    cmp  r13, -1
    jne  .wh_dot
    mov  r13, r14
.wh_dot:
    ; NAME.html
    lea  rdi, [rel web_html_name]
    lea  rsi, [rel out_bin_name]
    mov  rcx, r13
    call wh_catn
    lea  rsi, [rel html_ext]
    call wh_cat
    mov  byte [rdi], 0
    ; DIR/kron_web.js
    lea  rdi, [rel web_js_path]
    lea  rsi, [rel out_bin_name]
    mov  rcx, r12
    call wh_catn
    lea  rsi, [rel web_js_name]
    call wh_cat
    mov  byte [rdi], 0
    ; the page
    lea  rdi, [rel web_page]
    lea  rsi, [rel web_page_a]
    call wh_cat
    lea  rsi, [rel out_bin_name]
    add  rsi, r12
    mov  rcx, r13
    sub  rcx, r12
    call wh_catn
    lea  rsi, [rel web_page_b]
    call wh_cat
    lea  rsi, [rel out_bin_name]
    add  rsi, r12
    mov  rcx, r14
    sub  rcx, r12
    call wh_catn
    lea  rsi, [rel web_page_c]
    call wh_cat
    lea  rax, [rel web_page]
    mov  r8, rdi
    sub  r8, rax
    lea  rcx, [rel web_html_name]
    lea  rdx, [rel web_page]
    call write_file
    test rax, rax
    jz   .wh_out
    lea  rcx, [rel web_js_path]
    lea  rdx, [rel web_host_js]
    mov  r8, [rel web_host_js_size]
    call write_file
.wh_out:
    add  rsp, 8
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; wh_cat: the text at rsi (to its 0) at rdi; rdi moves past it
wh_cat:
    mov  al, [rsi]
    test al, al
    jz   .done
    mov  [rdi], al
    inc  rsi
    inc  rdi
    jmp  wh_cat
.done:
    ret

; wh_catn: rcx bytes from rsi at rdi; rdi moves past them
wh_catn:
    test rcx, rcx
    jz   .done
.l:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jnz  .l
.done:
    ret

; ==============================================================================
; write_file(rcx = filename, rdx = buffer, r8 = length)
; Returns: rax = 1 OK, 0 on error
; ==============================================================================
write_file:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rcx              ; filename
    mov  r13, rdx              ; buffer
    mov  rsi, r8              ; length (kept across calls)

    ; CreateFileA(name, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, 0)
    sub  rsp, 64
    mov  rcx, r12
    mov  rdx, GENERIC_WRITE
    xor  r8, r8
    xor  r9, r9
    mov  qword [rsp + 32], CREATE_ALWAYS
    mov  qword [rsp + 40], 0
    mov  qword [rsp + 48], 0
    call CreateFileA
    add  rsp, 64
    cmp  rax, -1
    je   .werr
    mov  rbx, rax             ; hFile

    ; WriteFile(hFile, buffer, length, &written, NULL)
    sub  rsp, 64
    mov  rcx, rbx
    mov  rdx, r13
    mov  r8,  rsi            ; length, kept
    lea  r9,  [rsp + 48]
    mov  qword [rsp + 48], 0
    mov  qword [rsp + 32], 0
    call WriteFile
    add  rsp, 64

    ; CloseHandle(hFile)
    sub  rsp, 32
    mov  rcx, rbx
    call CloseHandle
    add  rsp, 32

    mov  rax, 1
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret
.werr:
    xor  rax, rax
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; print_string(rcx = ptr to a null-terminated string)
; ==============================================================================
; ==============================================================================
; print_error_line()
;
; Prints the offending source line and a caret under the token:
;
;         a = true;
;         ^^^^
;
; Reads exp_buffer, which is what the parser actually saw -- the text after
; acquire_domain expansion -- so the line number matches what the parser
; reported. Both the line and the column come from the token itself; they
; were there all along and no diagnostic printed them.
; ==============================================================================
print_error_line:
    ; rcx = line (1-based), rdx = column (1-based), r8 = token length
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14

    mov  r12, rcx                    ; target line
    test r12, r12
    jz   .done
    mov  r13, rdx                    ; column
    mov  r14, r8                     ; token length
    test r14, r14
    jnz  .have_len
    mov  r14, 1
.have_len:

    ; walk exp_buffer to the start of line r12
    lea  rsi, [rel exp_buffer]
    mov  rbx, 1                      ; current line
.scan:
    cmp  rbx, r12
    jae  .at_line
    mov  al, [rsi]
    test al, al
    jz   .done                       ; ran off the end
    inc  rsi
    cmp  al, 10
    jne  .scan
    inc  rbx
    jmp  .scan

.at_line:
    ; No indent of our own: the source line brings its own leading spaces,
    ; and adding four more would push the caret out of alignment with it.
    mov  rdi, rsi                    ; start of the line
    xor  rbx, rbx                    ; length
.len_loop:
    mov  al, [rdi + rbx]
    test al, al
    jz   .len_done
    cmp  al, 10
    je   .len_done
    cmp  al, 13
    je   .len_done
    inc  rbx
    cmp  rbx, 400
    jb   .len_loop
.len_done:
    test rbx, rbx
    jz   .after_line
    sub  rsp, 64
    mov  rcx, [rel hStdOut]
    mov  rdx, rdi
    mov  r8, rbx
    lea  r9, [rsp + 48]
    mov  qword [rsp + 32], 0
    call WriteFile
    add  rsp, 64
.after_line:
    lea  rcx, [rel d_nl]
    call print_string

    ; col-1 spaces, then one caret per byte of the token
    mov  rbx, r13
    test rbx, rbx
    jz   .carets
    dec  rbx
.pad:
    test rbx, rbx
    jz   .carets
    lea  rcx, [rel d_sp1]
    call print_string
    dec  rbx
    jmp  .pad
.carets:
    mov  rbx, r14
    cmp  rbx, 200
    jbe  .cloop
    mov  rbx, 200
.cloop:
    test rbx, rbx
    jz   .cdone
    lea  rcx, [rel d_caret]
    call print_string
    dec  rbx
    jmp  .cloop
.cdone:
    lea  rcx, [rel d_nl]
    call print_string

.done:
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

print_string:
    push rbx
    push rsi
    push rdi
    mov  rsi, rcx
    xor  rcx, rcx
    
.loop:
    mov  al, [rsi + rcx]
    test al, al
    jz   .done
    inc  rcx
    jmp  .loop
    
.done:
    ; WriteFile(hStdOut, buffer, len, &written, NULL)
    sub  rsp, 64
    mov  r8, rcx            ; length in r8
    mov  rcx, [rel hStdOut]
    mov  rdx, rsi           ; string in rdx
    lea  r9, [rsp + 48]     ; &bytes_written
    mov  qword [rsp + 32], 0 ; lpOverlapped = NULL
    call WriteFile
    add  rsp, 64
    
    pop rdi
    pop rsi
    pop rbx
    ret

; ==============================================================================
; expand_imports(rcx = source, rdx = length, r8 = output buffer)
;   -> rax = length of the expanded text
;
; Replaces every  acquire_domain "file.jup";  directive with that file's text.
; One level deep: imports inside an imported file are left as-is, which keeps
; the pass finite without needing cycle detection.
; ==============================================================================
; ==============================================================================
; lmap_add(rcx = first expanded line, rdx = file name, r8 = line in that file)
; The name is copied, because inc_name is reused by the next import.
; ==============================================================================
lmap_add:
    push rbx
    push rsi
    push rdi
    push r9
    mov  rbx, [rel lmap_count]
    cmp  rbx, LMAP_MAX
    jae  .full
    lea  r9, [rel lmap_out]
    mov  [r9 + rbx*8], rcx
    lea  r9, [rel lmap_src]
    mov  [r9 + rbx*8], r8
    ; copy the name into lmap_names
    mov  r9, [rel lmap_names_n]
    lea  rdi, [rel lmap_names]
    add  rdi, r9
    push rdi
    mov  rsi, rdx
    xor  rcx, rcx
.cp:
    mov  al, [rsi + rcx]
    mov  [rdi + rcx], al
    test al, al
    jz   .cp_done
    inc  rcx
    cmp  rcx, 255
    jb   .cp
.cp_done:
    mov  byte [rdi + rcx], 0
    inc  rcx
    add  [rel lmap_names_n], rcx
    pop  rdi
    lea  r9, [rel lmap_file]
    mov  [r9 + rbx*8], rdi
    inc  rbx
    mov  [rel lmap_count], rbx
.full:
    pop  r9
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; lmap_lookup(rcx = expanded line) -> rax = file name, rdx = line in that file
; Falls back to the input file and the line as given when the map is empty.
; ==============================================================================
lmap_lookup:
    push rbx
    push r8
    push r9
    mov  r9, [rel lmap_count]
    test r9, r9
    jz   .none
    xor  rbx, rbx
    xor  r8, r8                  ; best index
.find:
    cmp  rbx, r9
    jae  .found
    lea  rax, [rel lmap_out]
    mov  rax, [rax + rbx*8]
    cmp  rax, rcx
    ja   .found
    mov  r8, rbx
    inc  rbx
    jmp  .find
.found:
    lea  rax, [rel lmap_out]
    mov  rax, [rax + r8*8]
    mov  rdx, rcx
    sub  rdx, rax                ; offset within the run
    lea  rax, [rel lmap_src]
    ; load then add: kasm's arithmetic path takes a scaled-index memory
    ; operand as the DESTINATION only, never as the source, and an
    ; 'add rdx, [rax + r8*8]' stops the kasm build dead.
    mov  rbx, [rax + r8*8]
    add  rdx, rbx
    lea  rax, [rel lmap_file]
    mov  rax, [rax + r8*8]
    pop  r9
    pop  r8
    pop  rbx
    ret
.none:
    lea  rax, [rel arg_input]
    mov  rdx, rcx
    pop  r9
    pop  r8
    pop  rbx
    ret

; ==============================================================================
; imp_have(rdi = module name) -> eax = 1 when the program imports it, itself
; or through another module.
; ==============================================================================
imp_have:
    push rbx
    push rsi
    xor  ebx, ebx
.ih_loop:
    cmp  ebx, [rel imp_count]
    jae  .ih_no
    mov  eax, ebx
    shl  rax, 8
    lea  rsi, [rel imp_names]
    add  rsi, rax
    call imp_streq
    test eax, eax
    jnz  .ih_out
    inc  ebx
    jmp  .ih_loop
.ih_no:
    xor  eax, eax
.ih_out:
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; imp_streq(rsi, rdi) -> eax = 1 when the two zero-terminated names match.
; ==============================================================================
imp_streq:
    push rsi
    push rdi
    push rcx
.se_loop:
    mov  al, [rsi]
    mov  cl, [rdi]
    cmp  al, cl
    jne  .se_no
    test al, al
    jz   .se_yes
    inc  rsi
    inc  rdi
    jmp  .se_loop
.se_yes:
    mov  eax, 1
    jmp  .se_out
.se_no:
    xor  eax, eax
.se_out:
    pop  rcx
    pop  rdi
    pop  rsi
    ret

; imp_strcpy(rdi = destination, rsi = source) -- at most 255 characters and
; the terminator. Preserves every register.
imp_strcpy:
    push rax
    push rcx
    push rsi
    push rdi
    xor  ecx, ecx
.sc_loop:
    cmp  ecx, 255
    jae  .sc_end
    mov  al, [rsi]
    test al, al
    jz   .sc_end
    mov  [rdi], al
    inc  rsi
    inc  rdi
    inc  ecx
    jmp  .sc_loop
.sc_end:
    mov  byte [rdi], 0
    pop  rdi
    pop  rsi
    pop  rcx
    pop  rax
    ret

; ==============================================================================
; imp_extract(rcx = text, rdx = length, r8d = frame) -- read the imports a
; file declares and keep them as that frame's children.
;
; Only the header counts: the scan stops at 'kron_definitions'. A directive
; has to start a line, after optional blanks, exactly as the splice below
; requires. More than IMP_KIDS imports in one file are an error.
; ==============================================================================
imp_extract:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r9
    push r10
    push r11
    mov  rsi, rcx                    ; cursor
    mov  r9, rdx                     ; remaining
    xor  r10d, r10d                  ; children found
.ix_line:
    ; skip blanks at the start of the line
    test r9, r9
    jz   .ix_done
    mov  al, [rsi]
    cmp  al, ' '
    je   .ix_blank
    cmp  al, 9
    je   .ix_blank
    jmp  .ix_word
.ix_blank:
    inc  rsi
    dec  r9
    jmp  .ix_line
.ix_word:
    ; the header ends here
    cmp  r9, 16
    jb   .ix_acq
    cmp  dword [rsi],    'kron'
    jne  .ix_acq
    cmp  dword [rsi+4],  '_def'
    jne  .ix_acq
    cmp  dword [rsi+8],  'init'
    jne  .ix_acq
    cmp  dword [rsi+12], 'ions'
    je   .ix_done
.ix_acq:
    cmp  r9, 14
    jb   .ix_skip
    cmp  dword [rsi],    'acqu'
    jne  .ix_skip
    cmp  dword [rsi+4],  'ire_'
    jne  .ix_skip
    cmp  dword [rsi+8],  'doma'
    jne  .ix_skip
    cmp  word  [rsi+12], 'in'
    jne  .ix_skip
    add  rsi, 14
    sub  r9, 14
.ix_sp:
    test r9, r9
    jz   .ix_done
    mov  al, [rsi]
    cmp  al, 34
    je   .ix_open
    cmp  al, 10
    je   .ix_skip
    inc  rsi
    dec  r9
    jmp  .ix_sp
.ix_open:
    inc  rsi
    dec  r9
    cmp  r10d, IMP_KIDS
    jae  .ix_toomany
    ; destination: dfs_kids[frame][child]
    mov  eax, r8d
    imul eax, eax, IMP_KIDS
    add  eax, r10d
    shl  rax, 8
    lea  rdi, [rel dfs_kids]
    add  rdi, rax
    xor  ecx, ecx
.ix_name:
    test r9, r9
    jz   .ix_named
    mov  al, [rsi]
    cmp  al, 34
    je   .ix_named
    cmp  al, 10
    je   .ix_named
    cmp  ecx, 255
    jae  .ix_named
    mov  [rdi], al
    inc  rdi
    inc  rsi
    dec  r9
    inc  ecx
    jmp  .ix_name
.ix_named:
    mov  byte [rdi], 0
    inc  r10d
.ix_skip:
    ; to the start of the next line
    test r9, r9
    jz   .ix_done
    mov  al, [rsi]
    inc  rsi
    dec  r9
    cmp  al, 10
    jne  .ix_skip
    jmp  .ix_line
.ix_toomany:
    mov  dword [rel imp_err], 3
.ix_done:
    mov  eax, r8d
    shl  rax, 2
    lea  rdi, [rel dfs_nkids]
    add  rdi, rax
    mov  [rdi], r10d
    lea  rdi, [rel dfs_ki]
    add  rdi, rax
    mov  dword [rdi], 0
    pop  r11
    pop  r10
    pop  r9
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; ==============================================================================
; imp_resolve(rcx = program text, rdx = length) -> eax = 0, or -1 with
; imp_err and imp_errname saying what went wrong.
;
; Depth-first over the imports. A module is added to the list after all of
; its own imports, so the list comes out in dependency order. One already in
; the list is not visited again -- two modules may share a third -- and one
; already on the stack is a cycle, cut the same way.
; ==============================================================================
imp_resolve:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r12
    push r13
    push r14
    push r15
    mov  dword [rel imp_count], 0
    mov  dword [rel imp_err], 0
    mov  dword [rel dfs_depth], 0
    ; frame 0 is the program itself: its name is never added to the list
    lea  rdi, [rel dfs_name]
    lea  rsi, [rel arg_input]
    call imp_strcpy
    xor  r8d, r8d
    call imp_extract
    mov  eax, [rel imp_err]
    test eax, eax
    jnz  .ir_fail_self
.ir_loop:
    mov  r12d, [rel dfs_depth]
    mov  eax, r12d
    shl  rax, 2
    lea  rsi, [rel dfs_ki]
    add  rsi, rax
    mov  ecx, [rsi]
    lea  rdi, [rel dfs_nkids]
    add  rdi, rax
    mov  edx, [rdi]
    cmp  ecx, edx
    jae  .ir_pop
    inc  ecx
    mov  [rsi], ecx
    dec  ecx
    ; r13 = the child's name
    mov  eax, r12d
    imul eax, eax, IMP_KIDS
    add  eax, ecx
    shl  rax, 8
    lea  r13, [rel dfs_kids]
    add  r13, rax
    ; already in the list?
    xor  r14d, r14d
.ir_done_scan:
    cmp  r14d, [rel imp_count]
    jae  .ir_not_done
    mov  eax, r14d
    shl  rax, 8
    lea  rdi, [rel imp_names]
    add  rdi, rax
    mov  rsi, r13
    call imp_streq
    test eax, eax
    jnz  .ir_loop
    inc  r14d
    jmp  .ir_done_scan
.ir_not_done:
    ; on the stack right now? then it is a cycle: cut it
    mov  r14d, 1
.ir_stack_scan:
    cmp  r14d, r12d
    ja   .ir_push
    mov  eax, r14d
    shl  rax, 8
    lea  rdi, [rel dfs_name]
    add  rdi, rax
    mov  rsi, r13
    call imp_streq
    test eax, eax
    jnz  .ir_loop
    inc  r14d
    jmp  .ir_stack_scan
.ir_push:
    mov  eax, r12d
    inc  eax
    cmp  eax, IMP_DEPTH
    jb   .ir_depth_ok
    mov  dword [rel imp_err], 2
    jmp  .ir_fail
.ir_depth_ok:
    mov  r12d, eax
    mov  [rel dfs_depth], r12d
    mov  eax, r12d
    shl  rax, 8
    lea  rdi, [rel dfs_name]
    add  rdi, rax
    mov  rsi, r13
    call imp_strcpy
    ; read the module and take its imports as this frame's children
    mov  r15, rdi                    ; the name, kept for the error message
    ; read_file destroys r13, r14 and r15 -- the same trap that once cut
    ; imports short -- so the depth and the name ride on the stack across it.
    ; Two pushes plus 40 bytes keep rsp 16-aligned at the call.
    push r12
    push r15
    sub  rsp, 40
    ; first next to the program, then as written -- as %include does
    mov  rcx, r15
    call imp_fullpath
    mov  rcx, rax
    lea  rdx, [rel inc_buffer]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    test rax, rax
    jnz  .ir_got
    mov  rcx, [rsp + 40]             ; the name, from the stack: r15 is gone
    lea  rdx, [rel inc_buffer]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    jmp  .ir_got
.ir_got:
    add  rsp, 40
    pop  r15
    pop  r12
    test rax, rax
    jnz  .ir_read_ok
    mov  dword [rel imp_err], 1
    jmp  .ir_fail
.ir_read_ok:
    lea  rcx, [rel inc_buffer]
    mov  rdx, rax
    mov  r8d, r12d
    call imp_extract
    mov  eax, [rel imp_err]
    test eax, eax
    jnz  .ir_fail
    jmp  .ir_loop
.ir_pop:
    ; every child done: the frame's own file goes on the list
    test r12d, r12d
    jz   .ir_ok                      ; frame 0 is the program itself
    mov  eax, [rel imp_count]
    cmp  eax, IMP_MAX
    jb   .ir_room
    mov  dword [rel imp_err], 3
    mov  eax, r12d
    shl  rax, 8
    lea  r15, [rel dfs_name]
    add  r15, rax
    jmp  .ir_fail
.ir_room:
    shl  rax, 8
    lea  rdi, [rel imp_names]
    add  rdi, rax
    mov  eax, r12d
    shl  rax, 8
    lea  rsi, [rel dfs_name]
    add  rsi, rax
    call imp_strcpy
    mov  eax, [rel imp_count]
    inc  eax
    mov  [rel imp_count], eax
    dec  r12d
    mov  [rel dfs_depth], r12d
    jmp  .ir_loop
.ir_ok:
    xor  eax, eax
    jmp  .ir_out
.ir_fail_self:
    lea  r15, [rel arg_input]
.ir_fail:
    ; keep the name that failed for the diagnostic
    lea  rdi, [rel imp_errname]
    mov  rsi, r15
    call imp_strcpy
    mov  eax, -1
.ir_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; ==============================================================================
; elf_write(rcx = output buffer) -> rax = length of the Linux executable.
; kasm has assembled the program into a flat image: the code, the data at the
; next 16-byte boundary, the .bss right after -- the layout every [rel label]
; was resolved against. The file is a 64-bit ELF with one loadable segment:
; the whole file mapped read-write-execute at 0x400000, the image at file
; offset 0x80, and the .bss after it in memory. Only the absolute addresses
; ('dq label', fixup kind 6) are left to fill: kasm cannot know the base.
; Linux needs no import table: the runtime reaches the system with syscall.
; ==============================================================================
; elf_write_arm(rcx = output) -> rax = file length. karm's image after the
; 0x80 bytes of headers, as elf_write does for x86-64: the AArch64 machine
; number (183), the entry from _start, and a 64 KB segment alignment, since
; some ARM64 kernels use 64 KB pages. karm resolves every address itself.
elf_write_arm:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rcx
    sub  rsp, 32
    call karm_build_image
    add  rsp, 32
    mov  r13, rax                    ; image length
    sub  rsp, 32
    call karm_get_code
    add  rsp, 32
    mov  rsi, rax
    mov  rdi, r12
    add  rdi, 128
    mov  rcx, r13
    jmp  .ewa_copy
.ewa_copy:
    test rcx, rcx
    jz   .ewa_copied
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .ewa_copy
.ewa_copied:
    sub  rsp, 32
    call karm_get_entry
    add  rsp, 32
    mov  rbx, rax
    mov  rdi, r12
    mov  rax, 0x00010102464C457F     ; 7F 'E' 'L' 'F', 64-bit, little-endian, v1
    mov  [rdi], rax
    xor  eax, eax
    mov  [rdi + 8], rax
    mov  rax, 0x0000000100B70002     ; executable, AArch64, version 1
    mov  [rdi + 16], rax
    mov  [rdi + 24], rbx             ; entry
    mov  rax, 64
    mov  [rdi + 32], rax
    xor  eax, eax
    mov  [rdi + 40], rax
    mov  rax, 0x0038004000000000
    mov  [rdi + 48], rax
    mov  rax, 1
    mov  [rdi + 56], rax
    mov  rax, 0x0000000700000001     ; PT_LOAD, read-write-execute
    mov  [rdi + 64], rax
    xor  eax, eax
    mov  [rdi + 72], rax
    mov  rax, 0x400000
    mov  [rdi + 80], rax
    mov  [rdi + 88], rax
    mov  rax, r13
    add  rax, 128
    mov  [rdi + 96], rax             ; bytes in the file
    mov  rbx, rax
    sub  rsp, 32
    call karm_get_bss_size
    add  rsp, 32
    mov  rcx, r13
    add  rcx, 15
    and  rcx, -16                    ; .bss starts 16-aligned after .data
    add  rax, rcx
    add  rax, 128
    mov  [rdi + 104], rax            ; bytes in memory: up to the end of .bss
    mov  rax, 0x10000
    mov  [rdi + 112], rax
    xor  eax, eax
    mov  [rdi + 120], rax
    mov  rax, rbx
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

elf_write:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    mov  r12, rcx                    ; the output
    call kasm_build_image
    mov  [rel ew_img], rax
    ; the image goes after the 0x80 bytes of headers
    call kasm_get_code
    mov  rsi, rax
    mov  rdi, r12
    add  rdi, 128
    mov  rcx, [rel ew_img]
    jmp  .ew_copy
.ew_copy:
    test rcx, rcx
    jz   .ew_copied
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .ew_copy
.ew_copied:
    ; where kasm put .data and .bss inside the image
    call kasm_get_code_size
    add  rax, 15
    shr  rax, 4
    shl  rax, 4
    mov  r14, rax                    ; data base
    call kasm_get_data_size
    mov  r15, r14
    add  r15, rax
    add  r15, 15
    and  r15, -16                    ; bss base, aligned as kasm resolves it
    ; fill every 'dq label' with its final address
    call kasm_get_fixup_count
    mov  [rel ew_count], rax
    xor  ebx, ebx
    jmp  .ew_fix
.ew_fix:
    cmp  rbx, [rel ew_count]
    jae  .ew_fixed
    mov  rcx, rbx
    call kasm_get_fixup_kind
    cmp  eax, 6
    jne  .ew_next
    mov  rcx, rbx
    call kasm_get_fixup_label
    cmp  eax, -1
    je   .ew_next
    mov  [rel ew_lbl], rax
    mov  rcx, rax
    call kasm_get_label_section
    mov  [rel ew_sec], rax
    mov  rax, [rel ew_lbl]
    call kasm_label_addr             ; offset inside its section
    cmp  qword [rel ew_sec], 1
    jne  .ew_notdata
    add  rax, r14
    jmp  .ew_based
.ew_notdata:
    cmp  qword [rel ew_sec], 2
    jne  .ew_based
    add  rax, r15
    jmp  .ew_based
.ew_based:
    add  rax, 0x400080               ; base of the image in memory
    mov  [rel ew_val], rax
    mov  rcx, rbx
    call kasm_get_fixup_at           ; offset of the slot inside .data
    mov  rdi, r12
    add  rdi, 128
    add  rdi, r14
    add  rdi, rax
    mov  rax, [rel ew_val]
    mov  [rdi], rax
    jmp  .ew_next
.ew_next:
    inc  rbx
    jmp  .ew_fix
.ew_fixed:
    ; the entry point: _start, from the preamble
    lea  rcx, [rel ew_start_name]
    mov  rdx, 6
    call kasm_find_label
    cmp  eax, -1
    je   .ew_noentry
    call kasm_label_addr
    jmp  .ew_entry
.ew_noentry:
    xor  eax, eax
    jmp  .ew_entry
.ew_entry:
    add  rax, 0x400080
    mov  r13, rax                    ; entry address
    ; ELF header, 64 bytes, then one program header, 56 bytes
    mov  rdi, r12
    mov  rax, 0x00010102464C457F     ; 7F 'E' 'L' 'F', 64-bit, little-endian, v1
    mov  [rdi], rax
    xor  eax, eax
    mov  [rdi + 8], rax
    mov  rax, 0x00000001003E0002     ; executable, x86-64, version 1
    mov  [rdi + 16], rax
    mov  [rdi + 24], r13             ; entry
    mov  rax, 64
    mov  [rdi + 32], rax             ; program headers right after
    xor  eax, eax
    mov  [rdi + 40], rax             ; no section headers
    mov  rax, 0x0038004000000000     ; flags 0, header 64 bytes, ph entry 56
    mov  [rdi + 48], rax
    mov  rax, 1
    mov  [rdi + 56], rax             ; one program header
    mov  rax, 0x0000000700000001     ; PT_LOAD, read-write-execute
    mov  [rdi + 64], rax
    xor  eax, eax
    mov  [rdi + 72], rax             ; from file offset 0
    mov  rax, 0x400000
    mov  [rdi + 80], rax             ; virtual address
    mov  [rdi + 88], rax             ; physical address
    mov  rax, [rel ew_img]
    add  rax, 128
    mov  [rdi + 96], rax             ; bytes in the file
    mov  rbx, rax
    call kasm_get_bss_size
    add  rax, r15
    add  rax, 128
    mov  [rdi + 104], rax            ; bytes in memory: up to the end of .bss
    mov  rax, 0x1000
    mov  [rdi + 112], rax
    xor  eax, eax
    mov  [rdi + 120], rax
    mov  rax, rbx                    ; the file's length
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; imp_fullpath(rcx = module name) -> rax = where to look for it first: the
; folder of the program, then the name. A module is looked for next to the
; program, not in the folder kronc happens to run from. An absolute name, or a
; program given with no folder, comes back unchanged. Preserves every register
; but rax.
imp_fullpath:
    push rbx
    push rdx
    push rsi
    push rdi
    push r8
    mov  rsi, rcx
    mov  al, [rsi]
    cmp  al, '\'
    je   .fp_same
    cmp  al, '/'
    je   .fp_same
    cmp  byte [rsi+1], ':'
    je   .fp_same
    jmp  .fp_dir
.fp_dir:
    ; the program's folder: everything up to its last \ or /
    lea  rdx, [rel arg_input]
    xor  ebx, ebx
    xor  r8, r8
    jmp  .fp_scan
.fp_scan:
    mov  al, [rdx + rbx]
    test al, al
    jz   .fp_scanned
    inc  rbx
    cmp  al, '\'
    je   .fp_mark
    cmp  al, '/'
    je   .fp_mark
    jmp  .fp_scan
.fp_mark:
    mov  r8, rbx
    jmp  .fp_scan
.fp_scanned:
    test r8, r8
    jz   .fp_same
    lea  rdi, [rel imp_pathbuf]
    xor  ebx, ebx
    jmp  .fp_cdir
.fp_cdir:
    cmp  rbx, r8
    jae  .fp_cname
    mov  al, [rdx + rbx]
    mov  [rdi + rbx], al
    inc  rbx
    jmp  .fp_cdir
.fp_cname:
    ; then the name, 510 bytes at most in all
    mov  al, [rsi]
    mov  [rdi + rbx], al
    test al, al
    jz   .fp_full
    inc  rsi
    inc  rbx
    cmp  rbx, 510
    jb   .fp_cname
    xor  eax, eax
    mov  [rdi + rbx], al
    jmp  .fp_full
.fp_full:
    lea  rax, [rel imp_pathbuf]
    jmp  .fp_out
.fp_same:
    mov  rax, rcx
    jmp  .fp_out
.fp_out:
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rbx
    ret

expand_imports:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    mov  rbx, rcx                ; source start (for the line test)
    mov  rsi, rcx                ; read cursor
    mov  r12, rdx                ; bytes remaining
    mov  rdi, r8                 ; write cursor
    mov  r15, r8                 ; output start
    mov  qword [rel lmap_count], 0
    mov  qword [rel lmap_names_n], 0
    mov  qword [rel lmap_outline], 1
    mov  qword [rel lmap_srcline], 1
    ; the text starts in the main file, line 1
    mov  rcx, 1
    lea  rdx, [rel arg_input]
    mov  r8, 1
    call lmap_add

    ; work out every module the program needs, in order, before splicing
    mov  rcx, rbx
    mov  rdx, r12
    call imp_resolve
    cmp  eax, -1
    je   .imp_fail
    mov  dword [rel imp_emitted], 0

.scan:
    test r12, r12
    jz   .done
    cmp  r12, 14
    jb   .copy
    cmp  dword [rsi],    'acqu'
    jne  .copy
    cmp  dword [rsi+4],  'ire_'
    jne  .copy
    cmp  dword [rsi+8],  'doma'
    jne  .copy
    cmp  word  [rsi+12], 'in'
    jne  .copy
    ; the directive must start a line
    cmp  rsi, rbx
    je   .at_bol
    mov  al, [rsi-1]
    cmp  al, 10
    je   .at_bol
    cmp  al, 13
    je   .at_bol
    jmp  .copy
.at_bol:
    add  rsi, 14
    sub  r12, 14
.sp:
    test r12, r12
    jz   .done
    mov  al, [rsi]
    cmp  al, ' '
    je   .sp_adv
    cmp  al, 9
    je   .sp_adv
    jmp  .quote
.sp_adv:
    inc  rsi
    dec  r12
    jmp  .sp
.quote:
    cmp  al, 34                  ; opening quote
    jne  .copy
    inc  rsi
    dec  r12
    lea  r13, [rel inc_name]
    xor  r14, r14
.name:
    test r12, r12
    jz   .done
    mov  al, [rsi]
    cmp  al, 34
    je   .name_end
    cmp  r14, 255
    jae  .name_end
    mov  [r13 + r14], al
    inc  r14
    inc  rsi
    dec  r12
    jmp  .name
.name_end:
    mov  byte [r13 + r14], 0
    inc  rsi
    dec  r12
.tail:
    test r12, r12
    jz   .load
    mov  al, [rsi]
    inc  rsi
    dec  r12
    cmp  al, 10
    jne  .tail
    inc  qword [rel lmap_srcline]   ; the directive line itself is consumed

.load:
    ; The whole resolved list goes in at the program's first directive, in
    ; dependency order. Any later directive of the program is already inside
    ; it: the line was consumed above and nothing more is written for it.
    mov  eax, [rel imp_emitted]
    test eax, eax
    jnz  .scan
    mov  dword [rel imp_emitted], 1
    mov  dword [rel imp_i], 0
.mod_next:
    mov  eax, [rel imp_i]
    cmp  eax, [rel imp_count]
    jae  .mods_done
    shl  rax, 8
    push rsi
    push rdi
    lea  rsi, [rel imp_names]
    add  rsi, rax
    lea  rdi, [rel inc_name]
    call imp_strcpy
    pop  rdi
    pop  rsi
    mov  eax, [rel imp_i]
    inc  eax
    mov  [rel imp_i], eax
    ; read_file clobbers r13, r14 and r15 as well, and r15 holds the start of
    ; the output buffer -- .done subtracts it to get the final length. With a
    ; single import this went unnoticed because .emit reassigns r13 and r14
    ; right away and nothing read r15 until the end. With a second import the
    ; damage from the first was already done: the length came out wrong and
    ; the text was truncated, taking main with it.
    ;
    ; 8 pushes keep rsp 16-byte aligned; 32 bytes of shadow space keep it so.
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 32
    ; first next to the program, then as written -- as %include does
    lea  rcx, [rel inc_name]
    call imp_fullpath
    mov  rcx, rax
    lea  rdx, [rel inc_buffer]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    test rax, rax
    jnz  .sp_got
    lea  rcx, [rel inc_name]
    lea  rdx, [rel inc_buffer]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    jmp  .sp_got
.sp_got:
    add  rsp, 32
    pop  rbp
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    test rax, rax
    jz   .mod_next               ; resolution already read it: cannot happen
    mov  r13, rax                ; length
    lea  r14, [rel inc_buffer]
    ; An imported file carries its own module header.  Inlining it verbatim
    ; would drop 'kron_program ... kron_definitions' into the middle of
    ; the expanded text, so skip past the importee's 'kron_definitions'.
    push r14
    push r13
    mov  qword [rel lmap_hdrskip], 0
.hdr_find:
    ; 'kron_definitions' is sixteen characters, four whole words. The old
    ; name needed nineteen and a trailing word and byte; this is cleaner and,
    ; more to the point, it is what the files now say. Leaving the old
    ; comparisons here after the rename silently stopped every import from
    ; expanding -- the compiler kept producing an .asm and NASM rejected it.
    cmp  r13, 16
    jb   .hdr_none
    cmp  dword [r14],      'kron'
    jne  .hdr_next
    cmp  dword [r14+4],    '_def'
    jne  .hdr_next
    cmp  dword [r14+8],    'init'
    jne  .hdr_next
    cmp  dword [r14+12],   'ions'
    jne  .hdr_next
    add  r14, 16
    sub  r13, 16
    add  rsp, 16                 ; discard the saved start
    jmp  .emit_first
.hdr_next:
    ; count the newlines stepped over: the imported text does not start at
    ; the file's line 1 but at the line after 'kron_definitions', and
    ; reporting line 1 there put every diagnostic three lines early.
    cmp  byte [r14], 10
    jne  .hdr_nonl
    inc  qword [rel lmap_hdrskip]
.hdr_nonl:
    inc  r14
    dec  r13
    jmp  .hdr_find
.hdr_none:
    pop  r13                     ; no header: emit the file whole
    pop  r14
.emit_first:
    ; a run of lines from the imported file starts here. Its own line 1 is
    ; the one after its module header, which the skip above already passed.
    push rcx
    push rdx
    push r8
    mov  rcx, [rel lmap_outline]
    lea  rdx, [rel inc_name]
    mov  r8, [rel lmap_hdrskip]
    inc  r8                      ; first line actually spliced
    call lmap_add
    pop  r8
    pop  rdx
    pop  rcx
.emit:
    test r13, r13
    jz   .emit_end
    mov  al, [r14]
    mov  [rdi], al
    cmp  al, 10
    jne  .emit_nonl
    inc  qword [rel lmap_outline]
.emit_nonl:
    inc  r14
    inc  rdi
    dec  r13
    jmp  .emit
.emit_end:
    mov  byte [rdi], 10
    inc  rdi
    inc  qword [rel lmap_outline]
    jmp  .mod_next
.mods_done:
    ; back in the main file, at the line after the directive
    push rcx
    push rdx
    push r8
    mov  rcx, [rel lmap_outline]
    lea  rdx, [rel arg_input]
    mov  r8, [rel lmap_srcline]
    call lmap_add
    pop  r8
    pop  rdx
    pop  rcx
    jmp  .scan

.copy:
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  r12
    cmp  al, 10
    jne  .scan
    inc  qword [rel lmap_outline]
    inc  qword [rel lmap_srcline]
    jmp  .scan

.imp_fail:
    mov  rax, -1                     ; the caller reports imp_err / imp_errname
    jmp  .ei_out
.done:
    mov  byte [rdi], 0
    mov  rax, rdi
    sub  rax, r15
.ei_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; copy_bytes(rcx = dst, rdx = src, r8 = count)
; ==============================================================================
copy_bytes:
    push rsi
    push rdi
    mov  rdi, rcx
    mov  rsi, rdx
.l:
    test r8, r8
    jz   .d
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  r8
    jmp  .l
.d:
    mov  byte [rdi], 0
    pop  rdi
    pop  rsi
    ret

; ==============================================================================
; ==============================================================================
; asm_preprocess(rcx = src, rdx = length, r8 = out) -> rax = bytes written
;
; Expands the three preprocessor forms the compiler's own sources use:
;   %include "file"      the file's text is spliced in (no nesting occurs)
;   %define NAME value   rewritten as  NAME equ value, which kasm already
;                        understands through its expression evaluator
;   %macro NAME n ... %endmacro   collected, then expanded at each call with
;                        %1..%n replaced by the arguments
;
; Any other %-line is dropped, which also covers the %line markers nasm -E
; leaves behind.
; ==============================================================================
asm_preprocess:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    mov  rsi, rcx
    mov  r12, rcx
    add  r12, rdx                ; end of input
    mov  rdi, r8
    mov  r15, r8                 ; remember the start, to measure at the end
    mov  rax, r8
    add  rax, SRC_BUFFER_SIZE
    sub  rax, 64                 ; leave a margin
    mov  [rel pp_out_end], rax
    mov  qword [rel mac_count], 0
    mov  qword [rel mac_names_len], 0
    mov  qword [rel mac_bodies_len], 0
    mov  qword [rel pp_depth], 0
    call pp_range
    mov  rax, rdi
    sub  rax, r15
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; pp_range: process input [rsi, r12) appending to rdi. Both cursors advance.
pp_range:
.line:
    cmp  rsi, r12
    jae  .out
    mov  r13, rsi                ; start of this line
.find_eol:
    cmp  rsi, r12
    jae  .have_line
    mov  al, [rsi]
    cmp  al, 10
    je   .have_line
    inc  rsi
    jmp  .find_eol
.have_line:
    mov  r14, rsi                ; end of line, before the newline
    cmp  rsi, r12
    jae  .no_nl
    inc  rsi                     ; step over the newline
.no_nl:
    call pp_one_line
    jmp  .line
.out:
    ret

; pp_one_line: the line lives in [r13, r14); rdi is the output cursor.
pp_one_line:
    push rsi
    push r12
    mov  rbx, r13
.skip_ws:
    cmp  rbx, r14
    jae  .copy_verbatim
    mov  al, [rbx]
    cmp  al, ' '
    je   .ws_adv
    cmp  al, 9
    jne  .check
.ws_adv:
    inc  rbx
    jmp  .skip_ws
.check:
    cmp  al, '%'
    je   .directive
    call pp_try_macro            ; al = 1 when the line was a macro call
    test al, al
    jnz  .done
.copy_verbatim:
    mov  rcx, r13
    mov  rdx, r14
    call pp_emit_range
    call pp_emit_nl
.done:
    pop  r12
    pop  rsi
    ret

.directive:
    ; rbx points at '%'
    lea  rcx, [rbx+1]
    lea  rdx, [rel s_pp_include]
    call pp_starts_with
    test al, al
    jnz  .do_include
    lea  rcx, [rbx+1]
    lea  rdx, [rel s_pp_define]
    call pp_starts_with
    test al, al
    jnz  .do_define
    lea  rcx, [rbx+1]
    lea  rdx, [rel s_pp_macro]
    call pp_starts_with
    test al, al
    jnz  .do_macro
    jmp  .done                   ; %line and anything else: drop

.do_include:
    ; %include "name"  -> read the file and process its lines here
    add  rbx, 8                  ; past '%include'
.inc_findq:
    cmp  rbx, r14
    jae  .done
    cmp  byte [rbx], '"'
    je   .inc_gotq
    inc  rbx
    jmp  .inc_findq
.inc_gotq:
    inc  rbx
    lea  rdx, [rel pp_name]
    xor  rcx, rcx
.inc_copy:
    cmp  rbx, r14
    jae  .inc_named
    mov  al, [rbx]
    cmp  al, '"'
    je   .inc_named
    cmp  rcx, 255
    jae  .inc_named
    mov  [rdx + rcx], al
    inc  rcx
    inc  rbx
    jmp  .inc_copy
.inc_named:
    mov  byte [rdx + rcx], 0
    ; Build 'include\NAME' using scratch registers only: rdi is the output
    ; cursor and rsi the input cursor, so neither may be touched here.
    lea  r8,  [rel pp_path]
    lea  r9,  [rel s_pp_incdir]
    xor  rcx, rcx
.inc_pfx:
    mov  al, [r9 + rcx]
    test al, al
    jz   .inc_pfx_done
    mov  [r8 + rcx], al
    inc  rcx
    jmp  .inc_pfx
.inc_pfx_done:
    lea  r9,  [rel pp_name]
    xor  rdx, rdx
.inc_join:
    mov  al, [r9 + rdx]
    mov  [r8 + rcx], al
    test al, al
    jz   .inc_joined
    inc  rcx
    inc  rdx
    jmp  .inc_join
.inc_joined:
    ; read_file goes through the Windows API, which clobbers freely; keep
    ; every cursor of ours across it
    push rsi
    push rdi
    push rbx
    push r12
    push r13
    push r14
    push r15
    push rbp                     ; paired with r15 to keep rsp 16-byte aligned
    ; r15 holds the start of the output buffer and the caller subtracts it to
    ; get the expanded length. It was left unsaved because one more push flips
    ; the alignment read_file needs -- but the fix is to push two, not to leave
    ; a register exposed. With a single import nothing read r15 before it was
    ; reassigned; with a second the damage from the first was already done and
    ; the text came out truncated, taking main with it.
    ; a file included from an included file needs its own buffer
    ; Keep the chosen buffer in memory rather than on the stack: read_file
    ; reaches the Windows API, which requires 16-byte stack alignment, and an
    ; extra push flips it.
    lea  rdx, [rel inc_buffer]
    cmp  qword [rel pp_depth], 0
    je   .inc_buf_ok
    lea  rdx, [rel inc_buffer2]
.inc_buf_ok:
    mov  [rel pp_inc_buf], rdx
    lea  rcx, [rel pp_path]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
    test rax, rax
    jnz  .inc_read_ok
    lea  rcx, [rel pp_name]      ; retry without the directory
    mov  rdx, [rel pp_inc_buf]
    mov  r8, SRC_BUFFER_SIZE
    call read_file
.inc_read_ok:
    pop  rbp
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    pop  rdi
    pop  rsi
    test rax, rax
    jz   .done                   ; not found: silently skip
.inc_have:
    push rsi
    push r12
    push r13
    push r14
    mov  rsi, [rel pp_inc_buf]   ; the buffer chosen above
    mov  r12, rsi
    add  r12, rax
    inc  qword [rel pp_depth]
    call pp_range
    dec  qword [rel pp_depth]
    pop  r14
    pop  r13
    pop  r12
    pop  rsi
    jmp  .done

.do_define:
    ; %define NAME value   ->   NAME equ value
    add  rbx, 7                  ; past '%define'
    call pp_skip_blanks_rbx
    mov  rcx, rbx
.def_name:
    cmp  rbx, r14
    jae  .def_emit
    mov  al, [rbx]
    cmp  al, ' '
    je   .def_emit
    cmp  al, 9
    je   .def_emit
    inc  rbx
    jmp  .def_name
.def_emit:
    mov  rdx, rbx                ; [rcx, rdx) is the name
    call pp_emit_range
    lea  rcx, [rel s_pp_equ]
    call pp_emit_cstr
    call pp_skip_blanks_rbx
    mov  rcx, rbx
    mov  rdx, r14
    call pp_emit_range
    call pp_emit_nl
    jmp  .done

.do_macro:
    ; %macro NAME n ... %endmacro
    add  rbx, 6
    call pp_skip_blanks_rbx
    call pp_record_macro
    ; the body has been consumed, so keep the advanced rsi instead of the
    ; copy saved on entry -- otherwise the body would be seen again as code
    pop  r12
    add  rsp, 8
    ret

; ---- preprocessor helpers -----------------------------------------------

; pp_emit_range(rcx = start, rdx = end): append [start, end) to rdi
pp_emit_range:
.l:
    cmp  rcx, rdx
    jae  .out
    cmp  rdi, [rel pp_out_end]
    jae  .out                    ; refuse to run past the buffer
    mov  al, [rcx]
    mov  [rdi], al
    inc  rdi
    inc  rcx
    jmp  .l
.out:
    ret

; pp_emit_cstr(rcx = zero-terminated text): append it to rdi
pp_emit_cstr:
.l:
    mov  al, [rcx]
    test al, al
    jz   .out
    cmp  rdi, [rel pp_out_end]
    jae  .out
    mov  [rdi], al
    inc  rdi
    inc  rcx
    jmp  .l
.out:
    ret

pp_emit_nl:
    cmp  rdi, [rel pp_out_end]
    jae  .out
    mov  byte [rdi], 10
    inc  rdi
.out:
    ret

; pp_skip_blanks_rbx: advance rbx past spaces and tabs, stopping at r14
pp_skip_blanks_rbx:
.l:
    cmp  rbx, r14
    jae  .out
    mov  al, [rbx]
    cmp  al, ' '
    je   .adv
    cmp  al, 9
    jne  .out
.adv:
    inc  rbx
    jmp  .l
.out:
    ret

; pp_starts_with(rcx = text, rdx = prefix) -> al = 1 when text begins with it
pp_starts_with:
.l:
    mov  al, [rdx]
    test al, al
    jz   .yes
    cmp  al, [rcx]
    jne  .no
    inc  rcx
    inc  rdx
    jmp  .l
.no:
    xor  al, al
    ret
.yes:
    mov  al, 1
    ret

; pp_record_macro: rbx points at the macro name; the body runs to %endmacro.
; Consumes input through rsi, which pp_range then continues from.
pp_record_macro:
    push rcx
    push rdx
    push r8
    push r9
    ; Every module includes the same headers, so the same macro arrives once
    ; per module. Record it the first time and let the repeats skip the body.
    mov  byte [rel pp_dup], 0
    push rbx
    call pp_macro_known
    pop  rbx
    test al, al
    jz   .not_dup
    mov  byte [rel pp_dup], 1
    jmp  .skip_body
.not_dup:
    mov  r8, [rel mac_count]
    cmp  r8, 32
    jae  .skip_body
    ; store the name
    mov  rax, [rel mac_names_len]
    lea  rdx, [rel mac_name_off]
    mov  [rdx + r8*4], eax
    lea  rdx, [rel mac_names]
    add  rdx, rax
    xor  rcx, rcx
.nm:
    cmp  rbx, r14
    jae  .nm_done
    mov  al, [rbx]
    cmp  al, ' '
    je   .nm_done
    cmp  al, 9
    je   .nm_done
    cmp  al, 13
    je   .nm_done
    mov  [rdx + rcx], al
    inc  rcx
    inc  rbx
    jmp  .nm
.nm_done:
    mov  byte [rdx + rcx], 0
    inc  rcx
    add  [rel mac_names_len], rcx
    ; parameter count
    call pp_skip_blanks_rbx
    xor  rax, rax
.np:
    cmp  rbx, r14
    jae  .np_done
    movzx ecx, byte [rbx]
    cmp  cl, '0'
    jb   .np_done
    cmp  cl, '9'
    ja   .np_done
    imul rax, rax, 10
    sub  rcx, 48
    add  rax, rcx
    inc  rbx
    jmp  .np
.np_done:
    lea  rdx, [rel mac_nparams]
    mov  [rdx + r8], al
    ; body start
    mov  rax, [rel mac_bodies_len]
    lea  rdx, [rel mac_body_off]
    mov  [rdx + r8*4], eax
.skip_body:
    ; copy lines until %endmacro
    xor  r9, r9                  ; bytes copied
.bl:
    cmp  rsi, r12
    jae  .bl_done
    mov  r13, rsi
.bl_eol:
    cmp  rsi, r12
    jae  .bl_have
    mov  al, [rsi]
    cmp  al, 10
    je   .bl_have
    inc  rsi
    jmp  .bl_eol
.bl_have:
    mov  r14, rsi
    cmp  rsi, r12
    jae  .bl_nonl
    inc  rsi
.bl_nonl:
    ; is it %endmacro?
    mov  rcx, r13
.bl_ws:
    cmp  rcx, r14
    jae  .bl_copy
    mov  al, [rcx]
    cmp  al, ' '
    je   .bl_wsa
    cmp  al, 9
    jne  .bl_chk
.bl_wsa:
    inc  rcx
    jmp  .bl_ws
.bl_chk:
    lea  rdx, [rel s_pp_endmacro]
    call pp_starts_with
    test al, al
    jnz  .bl_done
.bl_copy:
    mov  rax, [rel mac_bodies_len]
    add  rax, r9
    lea  rdx, [rel mac_bodies]
    add  rdx, rax
    mov  rcx, r13
.bl_cp:
    cmp  rcx, r14
    jae  .bl_cp_nl
    cmp  r9, 16000
    jae  .bl_cp_nl
    mov  al, [rcx]
    mov  [rdx], al
    inc  rdx
    inc  rcx
    inc  r9
    jmp  .bl_cp
.bl_cp_nl:
    mov  byte [rdx], 10
    inc  r9
    jmp  .bl
.bl_done:
    cmp  byte [rel pp_dup], 0
    jne  .out                    ; a repeat: body consumed, nothing recorded
    mov  r8, [rel mac_count]
    cmp  r8, 32
    jae  .out
    lea  rdx, [rel mac_body_len]
    mov  [rdx + r8*4], r9d
    add  [rel mac_bodies_len], r9
    inc  r8
    mov  [rel mac_count], r8
.out:
    pop  r9
    pop  r8
    pop  rdx
    pop  rcx
    ret

; pp_try_macro: rbx points at the first token of the line, which runs to r14.
; If it names a macro, expand the body with %1..%n replaced by the arguments
; and return al = 1. Otherwise al = 0 and nothing is emitted.
; pp_macro_known: rbx points at a macro name -> al = 1 when already recorded
pp_macro_known:
    push rcx
    push rdx
    push rsi
    push r8
    push r9
    push r10
    mov  r10, rbx
    xor  r9, r9
.len:
    mov  al, [r10 + r9]
    cmp  al, ' '
    je   .len_done
    cmp  al, 9
    je   .len_done
    cmp  al, 13
    je   .len_done
    cmp  al, 10
    je   .len_done
    test al, al
    jz   .len_done
    inc  r9
    jmp  .len
.len_done:
    xor  r8, r8
.find:
    cmp  r8, [rel mac_count]
    jae  .no
    lea  rdx, [rel mac_name_off]
    mov  eax, [rdx + r8*4]
    lea  rsi, [rel mac_names]
    add  rsi, rax
    xor  rcx, rcx
.cmp:
    cmp  rcx, r9
    je   .cmp_end
    mov  al, [r10 + rcx]
    cmp  al, [rsi + rcx]
    jne  .next
    inc  rcx
    jmp  .cmp
.cmp_end:
    cmp  byte [rsi + rcx], 0
    je   .yes
.next:
    inc  r8
    jmp  .find
.yes:
    mov  al, 1
    jmp  .out
.no:
    xor  al, al
.out:
    pop  r10
    pop  r9
    pop  r8
    pop  rsi
    pop  rdx
    pop  rcx
    ret

pp_try_macro:
    push rbx
    push rcx
    push rdx
    push rsi
    push r8
    push r9
    push r10
    push r11
    ; measure the first token
    mov  r10, rbx                ; token start
.tok:
    cmp  rbx, r14
    jae  .tok_done
    mov  al, [rbx]
    cmp  al, ' '
    je   .tok_done
    cmp  al, 9
    je   .tok_done
    cmp  al, 13
    je   .tok_done
    inc  rbx
    jmp  .tok
.tok_done:
    mov  r11, rbx
    sub  r11, r10                ; token length
    ; look it up
    xor  r8, r8
.find:
    cmp  r8, [rel mac_count]
    jae  .no
    lea  rdx, [rel mac_name_off]
    mov  eax, [rdx + r8*4]
    lea  rsi, [rel mac_names]
    add  rsi, rax
    xor  rcx, rcx
.cmp:
    cmp  rcx, r11
    je   .cmp_end
    mov  al, [r10 + rcx]
    cmp  al, [rsi + rcx]
    jne  .next
    inc  rcx
    jmp  .cmp
.cmp_end:
    cmp  byte [rsi + rcx], 0
    je   .found
.next:
    inc  r8
    jmp  .find
.no:
    xor  al, al
    jmp  .out

.found:
    ; split the rest of the line into comma-separated arguments
    mov  qword [rel pp_argc], 0
    call pp_skip_blanks_rbx
.arg:
    cmp  rbx, r14
    jae  .args_done
    mov  rcx, [rel pp_argc]
    cmp  rcx, 8
    jae  .args_done
    mov  rsi, rbx                ; argument start
.arg_scan:
    cmp  rbx, r14
    jae  .arg_end
    mov  al, [rbx]
    cmp  al, ','
    je   .arg_end
    cmp  al, 13
    je   .arg_end
    inc  rbx
    jmp  .arg_scan
.arg_end:
    ; trim trailing blanks
    mov  rdx, rbx
.arg_trim:
    cmp  rdx, rsi
    jbe  .arg_store
    mov  al, [rdx-1]
    cmp  al, ' '
    je   .arg_trim_adv
    cmp  al, 9
    jne  .arg_store
.arg_trim_adv:
    dec  rdx
    jmp  .arg_trim
.arg_store:
    ; copy into pp_args
    mov  r9, rcx                 ; index
    mov  rax, 0
    test r9, r9
    jz   .arg_at0
    lea  rcx, [rel pp_arg_off]
    mov  eax, [rcx + r9*4 - 4]
    lea  rcx, [rel pp_arg_len]
    add  eax, [rcx + r9*4 - 4]
.arg_at0:
    lea  rcx, [rel pp_arg_off]
    mov  [rcx + r9*4], eax
    lea  rcx, [rel pp_args]
    add  rcx, rax
    xor  r11, r11
.arg_cp:
    cmp  rsi, rdx
    jae  .arg_cp_done
    mov  al, [rsi]
    mov  [rcx + r11], al
    inc  r11
    inc  rsi
    jmp  .arg_cp
.arg_cp_done:
    lea  rcx, [rel pp_arg_len]
    mov  [rcx + r9*4], r11d
    inc  r9
    mov  [rel pp_argc], r9
    cmp  rbx, r14
    jae  .args_done
    inc  rbx                     ; step over the comma
    call pp_skip_blanks_rbx
    jmp  .arg
.args_done:
    ; emit the body, substituting %1..%9
    lea  rdx, [rel mac_body_off]
    mov  eax, [rdx + r8*4]
    lea  rsi, [rel mac_bodies]
    add  rsi, rax
    lea  rdx, [rel mac_body_len]
    mov  r11d, [rdx + r8*4]
    xor  rcx, rcx
.body:
    cmp  rcx, r11
    jae  .body_done
    mov  al, [rsi + rcx]
    cmp  al, '%'
    jne  .body_plain
    inc  rcx
    cmp  rcx, r11
    jae  .body_done
    movzx eax, byte [rsi + rcx]
    sub  rax, 49                 ; '1' -> index 0
    cmp  rax, 8
    jae  .body_plain2
    cmp  rax, [rel pp_argc]
    jae  .body_skiparg
    push rcx
    push rsi
    mov  r9, rax
    lea  rdx, [rel pp_arg_off]
    mov  eax, [rdx + r9*4]
    lea  rcx, [rel pp_args]
    add  rcx, rax
    lea  rdx, [rel pp_arg_len]
    mov  eax, [rdx + r9*4]
    mov  rdx, rcx
    add  rdx, rax
    call pp_emit_range
    pop  rsi
    pop  rcx
.body_skiparg:
    inc  rcx
    jmp  .body
.body_plain2:
    mov  al, '%'
    mov  [rdi], al
    inc  rdi
    mov  al, [rsi + rcx]
.body_plain:
    cmp  rdi, [rel pp_out_end]
    jae  .body_done
    mov  [rdi], al
    inc  rdi
    inc  rcx
    jmp  .body
.body_done:
    mov  al, 1
.out:
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; read_file(rcx = filename, rdx = buffer, r8 = max_size)
; Returns: rax = bytes read, 0 on error
; ==============================================================================
read_file:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    mov  r12, rcx           ; filename
    mov  r13, rdx           ; buffer
    mov  rsi, r8            ; max_size (kept across calls)
    
    ; CreateFileA(filename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, 0)
    sub  rsp, 64
    mov  rcx, r12
    mov  rdx, GENERIC_READ
    mov  r8, FILE_SHARE_READ
    xor  r9, r9
    mov  qword [rsp + 32], OPEN_EXISTING  ; 5th arg
    mov  qword [rsp + 40], 0              ; 6th arg
    mov  qword [rsp + 48], 0              ; 7th arg
    call CreateFileA
    add  rsp, 64
    
    cmp  rax, -1
    je   .read_error
    
    mov  rbx, rax           ; hFile in rbx
    
    ; ReadFile(hFile, buffer, max_size, &bytes_read, NULL)
    sub  rsp, 64
    mov  rcx, rbx
    mov  rdx, r13           ; buffer
    mov  r8, rsi            ; max_size, kept
    lea  r9, [rsp + 48]     ; &bytes_read
    mov  qword [rsp + 48], 0
    mov  qword [rsp + 32], 0 ; lpOverlapped = NULL
    call ReadFile
    mov  rdi, [rsp + 48]    ; bytes read
    add  rsp, 64
    
    ; CloseHandle(hFile)
    sub  rsp, 32
    mov  rcx, rbx
    call CloseHandle
    add  rsp, 32
    
    mov  rax, rdi           ; return bytes read
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    ret
    
.read_error:
    xor  eax, eax
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    ret

; ==============================================================================
; print_u64(rcx = unsigned integer)
; ==============================================================================
print_u64:
    push rbx
    push rsi
    push rdi
    sub  rsp, 32
    lea  rsi, [rsp + 31]
    mov  byte [rsi], 0
    mov  rax, rcx
    mov  rbx, 10
    test rax, rax
    jnz  .convert
    dec  rsi
    mov  byte [rsi], '0'
    jmp  .emit
.convert:
    xor  rdx, rdx
    div  rbx
    add  dl, '0'
    dec  rsi
    mov  [rsi], dl
    test rax, rax
    jnz  .convert
.emit:
    mov  rcx, rsi
    call print_string
    add  rsp, 32
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; scan_target(rcx = command line) -> al = TARGET_* constant
;   --target=windows | linux | linux-arm64 | macos | web | krn | bare
;   (default: windows)
;   --bare is kept as a shorthand for --target=bare
; ==============================================================================
scan_target:
    push rsi
    push rbx
    mov  rsi, rcx
    mov  bl, TARGET_PE               ; default
    test rsi, rsi
    jz   .out
.scan:
    mov  al, [rsi]
    test al, al
    jz   .out
    cmp  al, '-'
    jne  .next
    cmp  byte [rsi+1], '-'
    jne  .next
    ; --bare
    cmp  byte [rsi+2], 'b'
    jne  .try_target
    cmp  byte [rsi+3], 'a'
    jne  .next
    cmp  byte [rsi+4], 'r'
    jne  .next
    cmp  byte [rsi+5], 'e'
    jne  .next
    mov  bl, TARGET_BARE
    jmp  .out
.try_target:
    ; --target=
    cmp  byte [rsi+2], 't'
    jne  .next
    cmp  byte [rsi+3], 'a'
    jne  .next
    cmp  byte [rsi+4], 'r'
    jne  .next
    cmp  byte [rsi+5], 'g'
    jne  .next
    cmp  byte [rsi+6], 'e'
    jne  .next
    cmp  byte [rsi+7], 't'
    jne  .next
    cmp  byte [rsi+8], '='
    jne  .next
    add  rsi, 9
    ; the whole name, letter by letter: windows, linux, krn or bare.
    ; Anything else is an error, never a silent Windows build.
    jmp  .t_try_windows
.t_try_windows:
    cmp  byte [rsi+0], 'w'
    jne  .t_not_windows
    cmp  byte [rsi+1], 'i'
    jne  .t_not_windows
    cmp  byte [rsi+2], 'n'
    jne  .t_not_windows
    cmp  byte [rsi+3], 'd'
    jne  .t_not_windows
    cmp  byte [rsi+4], 'o'
    jne  .t_not_windows
    cmp  byte [rsi+5], 'w'
    jne  .t_not_windows
    cmp  byte [rsi+6], 's'
    jne  .t_not_windows
    cmp  byte [rsi+7], ' '
    je   .t_windows
    cmp  byte [rsi+7], 9
    je   .t_windows
    cmp  byte [rsi+7], 0
    je   .t_windows
    jmp  .t_not_windows
.t_not_windows:
    cmp  byte [rsi+0], 'l'
    jne  .t_not_linux
    cmp  byte [rsi+1], 'i'
    jne  .t_not_linux
    cmp  byte [rsi+2], 'n'
    jne  .t_not_linux
    cmp  byte [rsi+3], 'u'
    jne  .t_not_linux
    cmp  byte [rsi+4], 'x'
    jne  .t_not_linux
    cmp  byte [rsi+5], ' '
    je   .t_linux
    cmp  byte [rsi+5], 9
    je   .t_linux
    cmp  byte [rsi+5], 0
    je   .t_linux
    ; linux-arm64
    cmp  byte [rsi+5], '-'
    jne  .t_not_linux
    cmp  byte [rsi+6], 'a'
    jne  .t_not_linux
    cmp  byte [rsi+7], 'r'
    jne  .t_not_linux
    cmp  byte [rsi+8], 'm'
    jne  .t_not_linux
    cmp  byte [rsi+9], '6'
    jne  .t_not_linux
    cmp  byte [rsi+10], '4'
    jne  .t_not_linux
    cmp  byte [rsi+11], ' '
    je   .t_arm64
    cmp  byte [rsi+11], 9
    je   .t_arm64
    cmp  byte [rsi+11], 0
    je   .t_arm64
    jmp  .t_not_linux
.t_not_linux:
    cmp  byte [rsi+0], 'k'
    jne  .t_not_krn
    cmp  byte [rsi+1], 'r'
    jne  .t_not_krn
    cmp  byte [rsi+2], 'n'
    jne  .t_not_krn
    cmp  byte [rsi+3], ' '
    je   .t_krn
    cmp  byte [rsi+3], 9
    je   .t_krn
    cmp  byte [rsi+3], 0
    je   .t_krn
    jmp  .t_not_krn
.t_not_krn:
    cmp  byte [rsi+0], 'w'
    jne  .t_not_web
    cmp  byte [rsi+1], 'e'
    jne  .t_not_web
    cmp  byte [rsi+2], 'b'
    jne  .t_not_web
    cmp  byte [rsi+3], ' '
    je   .t_web
    cmp  byte [rsi+3], 9
    je   .t_web
    cmp  byte [rsi+3], 0
    je   .t_web
    jmp  .t_not_web
.t_web:
    mov  bl, TARGET_WEB
    jmp  .out
.t_not_web:
    cmp  byte [rsi+0], 'm'
    jne  .t_not_mac
    cmp  byte [rsi+1], 'a'
    jne  .t_not_mac
    cmp  byte [rsi+2], 'c'
    jne  .t_not_mac
    cmp  byte [rsi+3], 'o'
    jne  .t_not_mac
    cmp  byte [rsi+4], 's'
    jne  .t_not_mac
    cmp  byte [rsi+5], ' '
    je   .t_mac
    cmp  byte [rsi+5], 9
    je   .t_mac
    cmp  byte [rsi+5], 0
    je   .t_mac
    jmp  .t_not_mac
.t_mac:
    mov  bl, TARGET_MACOS
    jmp  .out
.t_not_mac:
    cmp  byte [rsi+0], 'b'
    jne  .t_not_bare
    cmp  byte [rsi+1], 'a'
    jne  .t_not_bare
    cmp  byte [rsi+2], 'r'
    jne  .t_not_bare
    cmp  byte [rsi+3], 'e'
    jne  .t_not_bare
    cmp  byte [rsi+4], ' '
    je   .t_bare
    cmp  byte [rsi+4], 9
    je   .t_bare
    cmp  byte [rsi+4], 0
    je   .t_bare
    jmp  .t_not_bare
.t_not_bare:
    mov  bl, 255                     ; unknown target
    jmp  .out
.t_windows:
    mov  bl, TARGET_PE
    jmp  .out
.t_linux:
    mov  bl, TARGET_ELF
    jmp  .out
.t_arm64:
    mov  bl, TARGET_ARM64
    jmp  .out
.t_krn:
    mov  bl, TARGET_KRN
    jmp  .out
.t_bare:
    mov  bl, TARGET_BARE
    jmp  .out
.next:
    inc  rsi
    jmp  .scan
.out:
    mov  al, bl
    pop  rbx
    pop  rsi
    ret

; ==============================================================================
; parse_command_line(rcx = GetCommandLineA())
; Takes the first argument (source file) and optionally -o output.
; Handles quoted paths. Returns rax=1 if there is an input, 0 if not.
; ==============================================================================
parse_command_line:
    push rbx
    push rsi
    push rdi
    mov  rsi, rcx

    ; Skip the name of kronc.exe itself.
    cmp  byte [rsi], '"'
    jne  .skip_exe_plain
    inc  rsi
.skip_exe_quoted:
    mov  al, [rsi]
    test al, al
    jz   .no_input
    inc  rsi
    cmp  al, '"'
    jne  .skip_exe_quoted
    jmp  .skip_spaces

.skip_exe_plain:
    mov  al, [rsi]
    test al, al
    jz   .no_input
    cmp  al, ' '
    je   .skip_spaces
    cmp  al, 9
    je   .skip_spaces
    inc  rsi
    jmp  .skip_exe_plain

.skip_spaces:
    mov  al, [rsi]
    cmp  al, ' '
    je   .space_advance
    cmp  al, 9
    jne  .input_start
.space_advance:
    inc  rsi
    jmp  .skip_spaces

.input_start:
    test al, al
    jz   .no_input
    lea  rdi, [rel arg_input]
    xor  rbx, rbx
    cmp  al, '"'
    jne  .copy_plain
    inc  rsi

.copy_quoted:
    cmp  rbx, 511
    jae  .finish_input
    mov  al, [rsi]
    test al, al
    jz   .finish_input
    cmp  al, '"'
    je   .finish_input_advance
    mov  [rdi + rbx], al
    inc  rbx
    inc  rsi
    jmp  .copy_quoted

.copy_plain:
    cmp  rbx, 511
    jae  .finish_input
    mov  al, [rsi]
    test al, al
    jz   .finish_input
    cmp  al, ' '
    je   .finish_input
    cmp  al, 9
    je   .finish_input
    mov  [rdi + rbx], al
    inc  rbx
    inc  rsi
    jmp  .copy_plain

.finish_input_advance:
    inc  rsi
.finish_input:
    mov  byte [rdi + rbx], 0
    test rbx, rbx
    jz   .no_input

    ; -o <path>: where the .asm goes, instead of next to the source. The rest
    ; of the command line is read token by token, so a '-o' inside a path or a
    ; quoted name is never taken for the option.
    lea  rdi, [rel arg_output]
    mov  byte [rdi], 0
    mov  byte [rel arg_flag_S], 0
    mov  byte [rel arg_flag_check], 0
    mov  byte [rel arg_flag_window], 0
    jmp  .o_scan
.o_scan:
    mov  al, [rsi]
    cmp  al, ' '
    je   .o_blank
    cmp  al, 9
    je   .o_blank
    test al, al
    jz   .o_done
    cmp  al, '-'
    jne  .o_skiptok
    ; -S: write the generated assembly instead of the executable
    cmp  byte [rsi+1], 'S'
    jne  .o_notS
    cmp  byte [rsi+2], ' '
    je   .o_isS
    cmp  byte [rsi+2], 9
    je   .o_isS
    cmp  byte [rsi+2], 0
    jne  .o_skiptok
    jmp  .o_isS
.o_isS:
    mov  byte [rel arg_flag_S], 1
    add  rsi, 2
    jmp  .o_scan
.o_notS:
    ; --check: check everything, write nothing
    cmp  byte [rsi+1], '-'
    jne  .o_notcheck
    cmp  byte [rsi+2], 'w'
    je   .o_window
    cmp  byte [rsi+2], 'c'
    jne  .o_skiptok
    cmp  byte [rsi+3], 'h'
    jne  .o_skiptok
    cmp  byte [rsi+4], 'e'
    jne  .o_skiptok
    cmp  byte [rsi+5], 'c'
    jne  .o_skiptok
    cmp  byte [rsi+6], 'k'
    jne  .o_skiptok
    mov  byte [rel arg_flag_check], 1
    add  rsi, 7
    jmp  .o_skiptok
.o_window:
    ; --window: Windows opens no console for the program (std_window)
    cmp  byte [rsi+3], 'i'
    jne  .o_skiptok
    cmp  byte [rsi+4], 'n'
    jne  .o_skiptok
    cmp  byte [rsi+5], 'd'
    jne  .o_skiptok
    cmp  byte [rsi+6], 'o'
    jne  .o_skiptok
    cmp  byte [rsi+7], 'w'
    jne  .o_skiptok
    mov  byte [rel arg_flag_window], 1
    add  rsi, 8
    jmp  .o_skiptok
.o_notcheck:
    cmp  byte [rsi+1], 'o'
    jne  .o_skiptok
    cmp  byte [rsi+2], ' '
    je   .o_found
    cmp  byte [rsi+2], 9
    je   .o_found
    jmp  .o_skiptok
.o_blank:
    inc  rsi
    jmp  .o_scan
.o_skiptok:
    ; to the next blank, stepping over quoted parts whole
    mov  al, [rsi]
    test al, al
    jz   .o_done
    cmp  al, '"'
    je   .o_skipq
    cmp  al, ' '
    je   .o_scan
    cmp  al, 9
    je   .o_scan
    inc  rsi
    jmp  .o_skiptok
.o_skipq:
    inc  rsi
    jmp  .o_sq
.o_sq:
    mov  al, [rsi]
    test al, al
    jz   .o_done
    inc  rsi
    cmp  al, '"'
    jne  .o_sq
    jmp  .o_skiptok
.o_found:
    add  rsi, 3
    jmp  .o_pre
.o_pre:
    mov  al, [rsi]
    cmp  al, ' '
    je   .o_pre_next
    cmp  al, 9
    jne  .o_path
    jmp  .o_pre_next
.o_pre_next:
    inc  rsi
    jmp  .o_pre
.o_path:
    xor  ebx, ebx
    cmp  al, '"'
    jne  .o_plain
    inc  rsi
    jmp  .o_quoted
.o_quoted:
    cmp  rbx, 511
    jae  .o_end
    mov  al, [rsi]
    test al, al
    jz   .o_end
    cmp  al, '"'
    je   .o_end
    mov  [rdi + rbx], al
    inc  rbx
    inc  rsi
    jmp  .o_quoted
.o_plain:
    cmp  rbx, 511
    jae  .o_end
    mov  al, [rsi]
    test al, al
    jz   .o_end
    cmp  al, ' '
    je   .o_end
    cmp  al, 9
    je   .o_end
    mov  [rdi + rbx], al
    inc  rbx
    inc  rsi
    jmp  .o_plain
.o_end:
    mov  byte [rdi + rbx], 0
    jmp  .o_done
.o_done:
    mov  eax, 1
    pop  rdi
    pop  rsi
    pop  rbx
    ret

.no_input:
    xor  eax, eax
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; strcpy_n(rcx = dst, rdx = src, rsi = max_len)
; ==============================================================================
strcpy_n:
    xor  rax, rax
.loop:
    cmp  rax, rsi
    jge  .done
    mov  r9b, [rdx + rax]   ; use r9b so rdx is not destroyed
    mov  [rcx + rax], r9b
    test r9b, r9b
    jz   .done
    inc  rax
    jmp  .loop
.done:
    ret



