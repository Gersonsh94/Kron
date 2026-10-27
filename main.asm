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

extern jup_lexer_init, jup_lexer_run, lexer_error_kind, lexer_error_token
extern jup_parser_init, jup_parser_run
extern __g_parser_par_used_slice
extern __g_parser_par_used_text, __g_parser_par_used_list, __g_parser_par_used_map
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
extern cg_debug
extern cg_as_module, cg_mod_tag
extern codegen_uses_extern
extern xarm_translate, xarm_error_line, xarm_error_text, xarm_error_insn
extern xwasm_translate, xwasm_error_line, xwasm_error_text, xwasm_error_insn
extern xarm_set_os, karm_set_align, macho_write
extern mo_dylib, mo_platform, mo_idname
extern xarm_set_lib
extern kasm_init, kasm_assemble, kasm_get_code, kasm_get_code_size, kasm_had_error
extern kasm_get_error_line, kasm_get_error_count, kasm_get_error_line_at
extern kasm_get_error_dst, kasm_get_error_src
extern kasm_get_error_mnem
extern kasm_build_image
extern kasm_get_data_size, kasm_get_bss_size, kasm_get_fixup_count, kasm_get_fixup_kind
extern kasm_get_fixup_label, kasm_get_fixup_at, kasm_get_label_section, kasm_label_addr, kasm_find_label
extern pw_write, pw_gui, pw_dll, pw_dll_file
extern krn_init, krn_build, krn_get_image, krn_get_size
extern karm_init, karm_set_base, karm_assemble, karm_build_image, karm_get_code
extern karm_get_bss_size, karm_get_entry, karm_get_error_count, karm_get_error_line_at
extern karm_get_error_mnem, karm_get_error_text
extern karm_get_code_len, karm_get_data_len, karm_get_data_off, karm_set_align
extern karm_label, karm_reloc_count, karm_reloc_at
extern jup_codegen_set_lib, codegen_export_count, codegen_export_name
extern codegen_has_exports
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
    msg_duplabel db "  -- a label defined twice: two files of the build give the same name", 0
    msg_nolabel  db "  -- a label defined nowhere: a misspelt name, or an extern not declared", 0
    msg_ok       db " OK", 13, 10, 0
    msg_dumped   db "Expanded text written to: ", 0
    msg_nl       db 13, 10, 0
    dump_suffix  db ".expanded", 0
    msg_done     db 13, 10, "Compilation successful!", 13, 10, 0
    msg_err_args db "ERROR: usage: kronc.exe file.kr [-o output] [-S] [--check] [--debug]", 13, 10, 0
    msg_checked  db "Check passed: no errors.", 13, 10, 0
    msg_err_target db "ERROR: unknown target", 13, 10
                 db "  hint: use --target=windows, --target=linux, --target=linux-arm64, --target=web, --target=krn or --target=bare", 13, 10, 0
    msg_err_read db "ERROR: cannot read the file.", 13, 10, 0
    msg_err_long db "ERROR: the source file is longer than 16 MB.", 13, 10, 0
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
    msg_imp_lines db "the line map is full: more than 128 runs of lines from the imports, at '", 0
    msg_imp_size db "the program with its imports is longer than 16 MB, at '", 0
    msg_imp_pool db "a module is longer than 16 MB, or the modules are longer than 64 MB together, at '", 0
    msg_imp_hint1 db "  hint: the file has to be in the program's folder, with its .kr extension", 13, 10, 0
    msg_imp_hint2 db "  hint: check the chain of imports: each module imports only what it uses", 13, 10, 0
    msg_err_lex  db "ERROR: the program with its modules is too big for the lexer: more than 2796202 tokens.", 13, 10, 0
    d_lex_char   db "a character Kron does not use ", 0
    d_hint_lexchar db "  hint: outside a ", 34, "...", 34, " text and a // comment, Kron is written with letters, digits, _ and its operators", 13, 10, 0
    d_lex_text   db "a text with no closing quote", 0
    d_hint_lextext db "  hint: a text ends on its own ", 34, "; inside one, write \", 34, " for a quote and \\ for a backslash", 13, 10, 0
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
    msg_err_codebig db "ERROR: the generated code is larger than the compiler's buffers hold.", 13, 10
                  db "  hint: split the longest function, or the program, into smaller ones", 13, 10, 0
    msg_err_write db "ERROR: could not write the output file.", 13, 10
                  db "  hint: is the program still running, or the file open elsewhere?", 13, 10, 0
    msg_wrote     db "Written: ", 0
    asm_ext       db ".asm", 0
    mod_ext       db "_kr.asm", 0
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
    ; a program that calls the system's libraries (extern): what its ELF
    ; header area holds besides the headers -- the loader's name, and the
    ; five functions the loader fills in before _start runs
    ed_interp_x86 db "/lib64/ld-linux-x86-64.so.2", 0
    ed_interp_arm db "/lib/ld-linux-aarch64.so.1", 0
    ed_strtab     db 0, "libc.so.6", 0, "libdl.so.2", 0, "libpthread.so.0", 0
                  db "dlopen", 0, "dlsym", 0, "pthread_create", 0, "pthread_detach", 0, "exit", 0
    ed_strtab_len equ $ - ed_strtab
    ; the same for Android: libc.so and libdl.so, the five names where the
    ; others have them
    ed_strtab_and db 0, "libc.so", 0, "libdl.so", 0
                  db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                  db "dlopen", 0, "dlsym", 0, "pthread_create", 0, "pthread_detach", 0, "exit", 0
    so_shnames    db 0, ".dynsym", 0, ".dynstr", 0, ".dynamic", 0, ".shstrtab", 0
    ed_got_names  db "__got_dlopen", 0, "__got_dlsym", 0, "__got_ptc", 0, "__got_ptd", 0, "__got_exit", 0
    so_ext        db ".so", 0
    tg_android    db "android", 0
    mac_fw_ext    db ".framework"
    tg_ios        db "ios", 0
    msg_lib_only  db "ERROR: Android and iOS run Kron inside an app: build a library with --lib (see templates/)", 13, 10, 0
    dll_ext       db ".dll", 0
    dylib_ext     db ".dylib", 0
    msg_lib_target db "ERROR: --lib makes a library for windows, linux, linux-arm64 or macos", 13, 10, 0
    msg_module_target db "ERROR: --module writes x86-64 text for the compiler's own build: it goes with --target=windows only, and not with --lib or --debug", 13, 10, 0
    msg_debug_target db "ERROR: --debug builds for windows and linux (x86-64); build there to debug, then for the other systems", 13, 10, 0
    s_std_debug  db "std_debug.kr", 0

section .bss
    arg_input    resb 512
    arg_output   resb 512
    arg_flag_S   resb 1        ; -S: write the .asm instead of the .exe
    imp_pathbuf  resb 512      ; a module's name, next to the program
    ew_hsize     resq 1        ; bytes of headers before the image: 128, 1024 with externs
    ew_base      resq 1        ; where the image is in memory: 0x400000 + ew_hsize
    out_dynamic  resb 1        ; the program calls the system's libraries
    arg_flag_lib resb 1        ; --lib: a library (.dll .so .dylib), not a program
    out_android  resb 1        ; --target=android (out_target ARM64)
    out_ios      resb 1        ; --target=ios (out_target MACOS)
    mac_idbuf    resb 520      ; a framework dylib's install name
    arg_flag_check resb 1      ; --check: report errors, write nothing
    arg_flag_debug resb 1      ; --debug: a build the debugger can stop
    arg_flag_window resb 1     ; --window: a Windows program with no console
    arg_flag_module resb 1     ; --module: a part of the compiler, as text
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
    imp_err      resd 1                 ; 1 cannot open, 2 too deep, 3 too many
    imp_names    resb IMP_MAX * 256     ; the resolved list, in order
    imp_errname  resb 260
    ; --- the import pass's reading (imports.kr, through imp_read) -------------
    ; Each module's bytes go to a place of their own in imp_pool: the pass
    ; holds them all at once. 64 MB together, 4 MB for one file.
    imp_pool       resb IMP_POOL
    imp_pool_used  resq 1
    imp_src        resq 1               ; expand_imports' arguments, kept
    imp_len        resq 1               ; across the calls into Kron
    imp_out        resq 1
    imp_ret        resq 1
    imp_lmbytes    resq 1
    imp_nbytes     resq 1
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
    IMP_POOL     equ 67108864           ; 64 MB for the modules' bytes
    lmap_out     resq LMAP_MAX          ; first line in the expanded text
    lmap_file    resq LMAP_MAX          ; pointer to the file name
    lmap_src     resq LMAP_MAX          ; line it starts at in that file
    lmap_count   resq 1
    cg_hint_msg  resq 1                     ; hint of a codegen type error
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
global arg_input, src_buffer, lmap_out, lmap_file, lmap_count

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
    ; --lib: a library, for a system that loads them
    mov  dil, [rel arg_flag_lib]
    call jup_codegen_set_lib
    cmp  byte [rel arg_flag_lib], 0
    jne  .lib_check
    mov  al, [rel out_android]
    or   al, [rel out_ios]
    jz   .lib_ok
    lea  rcx, [rel msg_lib_only]
    call print_string
    mov  eax, 1
    pop  rbp
    ret
.lib_check:
    mov  al, [rel out_target]
    cmp  al, TARGET_PE
    je   .lib_ok
    cmp  al, TARGET_ELF
    je   .lib_ok
    cmp  al, TARGET_ARM64
    je   .lib_ok
    cmp  al, TARGET_MACOS
    je   .lib_ok
    lea  rcx, [rel msg_lib_target]
    call print_string
    mov  eax, 1
    pop  rbp
    ret
.lib_ok:
    ; --debug: the hooks are x86-64 code calling the debugger's module
    mov  al, [rel arg_flag_debug]
    mov  [rel cg_debug], al
    test al, al
    jz   .debug_ok
    mov  al, [rel out_target]
    cmp  al, TARGET_PE
    je   .debug_ok
    cmp  al, TARGET_ELF
    je   .debug_ok
    lea  rcx, [rel msg_debug_target]
    call print_string
    mov  eax, 1
    pop  rbp
    ret
.debug_ok:
    ; --module: a part of the compiler written in Kron. Its functions become
    ; x86-64 text that kron_all.asm includes, so the compiler is still built
    ; by kasm alone; nothing of a program goes with them.
    cmp  byte [rel arg_flag_module], 0
    je   .module_ok
    mov  al, [rel out_target]
    cmp  al, TARGET_PE
    jne  .module_bad
    mov  al, [rel arg_flag_lib]
    or   al, [rel arg_flag_debug]
    jnz  .module_bad
    mov  byte [rel arg_flag_S], 1
    mov  byte [rel cg_as_module], 1
    call module_tag
    jmp  .module_ok
.module_bad:
    lea  rcx, [rel msg_module_target]
    call print_string
    mov  eax, 1
    pop  rbp
    ret
.module_ok:

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
    cmp  rax, SRC_BUFFER_SIZE       ; read_file stops at the buffer: a file this long was cut
    jae  .error_long
    
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
    jle  .error_lex
    
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
    cmp  dword [rel __g_parser_par_used_slice], 0
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
    cmp  dword [rel __g_parser_par_used_text], 0
    je   .text_ok
    lea  rdi, [rel s_std_text]
    call imp_have
    test eax, eax
    jnz  .text_ok
    lea  rcx, [rel msg_text_imp]
    jmp  .error_type_imp
.text_ok:
    cmp  dword [rel __g_parser_par_used_list], 0
    je   .list_ok
    lea  rdi, [rel s_std_list]
    call imp_have
    test eax, eax
    jnz  .list_ok
    lea  rcx, [rel msg_list_imp]
    jmp  .error_type_imp
.list_ok:
    cmp  dword [rel __g_parser_par_used_map], 0
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
    cmp  rax, 11
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
    cmp  rax, 11
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
    jle  .error_code                 ; 0 an error, negative an internal one
    ; extern functions: the executable is linked with the system's loader
    call codegen_uses_extern
    mov  [rel out_dynamic], al
    call ew_set_layout

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
    call codegen_has_exports
    mov  ecx, eax
    call xarm_set_lib
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
    cmp  byte [rel arg_flag_lib], 0
    jne  .arm_so
    sub  rsp, 32
    call karm_init
    mov  rcx, [rel ew_base]
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

.arm_so:
    ; a shared object for ARM64 Linux (and Android): the image 512 bytes in,
    ; .data on a 64 KB page of its own, so that code and data get segments
    ; of their own -- read and run, read and write
    sub  rsp, 32
    call karm_init
    mov  rcx, 512
    call karm_set_base
    mov  rcx, 0x10000
    call karm_set_align
    lea  rcx, [rel code_buffer]
    mov  rdx, [rel src_size]
    call karm_assemble
    add  rsp, 32
    test rax, rax
    jz   .error_karm
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call so_prepare
    mov  edx, 1
    call elf_write_so
    add  rsp, 32
    mov  r11, rax
    lea  r10, [rel code_buffer]
    lea  rcx, [rel so_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .direct_name

.mac_image:
    ; macOS: the code at 0x100004000, after the page of the header, and each
    ; section on a 16 KB page of its own; then the Mach-O file around it.
    ; A dylib starts at 0, dyld sliding it wherever it goes.
    mov  al, [rel arg_flag_lib]
    mov  [rel mo_dylib], al
    mov  dword [rel mo_platform], 1
    cmp  byte [rel out_ios], 0
    je   .mac_plat
    mov  dword [rel mo_platform], 2  ; PLATFORM_IOS
.mac_plat:
    sub  rsp, 32
    call karm_init
    mov  rcx, 0x100004000
    cmp  byte [rel arg_flag_lib], 0
    je   .mac_base_set
    mov  rcx, 0x4000
.mac_base_set:
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
    cmp  byte [rel arg_flag_lib], 0
    je   .mac_ext
    lea  rcx, [rel dylib_ext]
.mac_ext:
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
    ; a dylib's install name: @rpath/ and its file's name -- or, inside
    ; Name.framework/, "Name.framework/" before it, as Xcode embeds one
    mov  [rel mo_idname], rdx
    lea  rax, [rel out_bin_name]
    mov  rcx, rdx
    sub  rcx, rax
    cmp  rcx, 12
    jb   .mac_id_done
    lea  r8, [rdx - 1]               ; the separator before the name
    mov  r9, r8                      ; the folder: back to the one before
.mac_id_back:
    cmp  r9, rax
    je   .mac_id_dir
    mov  cl, [r9 - 1]
    cmp  cl, '/'
    je   .mac_id_dir
    cmp  cl, 92
    je   .mac_id_dir
    dec  r9
    jmp  .mac_id_back
.mac_id_dir:
    ; does the folder end in ".framework"?
    mov  rcx, r8
    sub  rcx, r9
    cmp  rcx, 10
    jb   .mac_id_done
    lea  rsi, [r8 - 10]
    lea  rdi, [rel mac_fw_ext]
    xor  ecx, ecx
.mac_id_cmp:
    cmp  ecx, 10
    jae  .mac_id_fw
    mov  al, [rsi + rcx]
    cmp  al, [rdi + rcx]
    jne  .mac_id_done
    inc  ecx
    jmp  .mac_id_cmp
.mac_id_fw:
    ; "Name.framework/name", with / for a Windows separator
    lea  rdi, [rel mac_idbuf]
    mov  [rel mo_idname], rdi
.mac_id_copy:
    mov  al, [r9]
    cmp  al, 92
    jne  .mac_id_put
    mov  al, '/'
.mac_id_put:
    mov  [rdi], al
    inc  r9
    inc  rdi
    test al, al
    jnz  .mac_id_copy
.mac_id_done:
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
    mov  al, [rel arg_flag_lib]
    mov  [rel pw_dll], al         ; --lib: a DLL, which needs its own name
    test al, al
    jz   .pe_named
    lea  rcx, [rel dll_ext]
    mov  [rel bin_ext_ptr], rcx
    call build_bin_name
    lea  rax, [rel out_bin_name]
    mov  rdx, rax
.pe_base:
    mov  cl, [rax]
    test cl, cl
    jz   .pe_based
    inc  rax
    cmp  cl, '/'
    je   .pe_sep
    cmp  cl, 92
    je   .pe_sep
    jmp  .pe_base
.pe_sep:
    mov  rdx, rax
    jmp  .pe_base
.pe_based:
    mov  [rel pw_dll_file], rdx
.pe_named:
    sub  rsp, 32
    lea  rcx, [rel code_buffer]
    call pw_write                 ; the PE goes into code_buffer, rax = length
    mov  r11, rax
    lea  r10, [rel code_buffer]
    add  rsp, 32
    lea  rcx, [rel exe_ext]
    cmp  byte [rel arg_flag_lib], 0
    je   .pe_ext
    lea  rcx, [rel dll_ext]
.pe_ext:
    mov  [rel bin_ext_ptr], rcx
    jmp  .direct_name
.direct_elf:
    ; Linux: the same image, in an ELF file with no extension
    cmp  byte [rel arg_flag_lib], 0
    je   .direct_elf_exe
    sub  rsp, 32
    call so_prepare
    lea  rcx, [rel code_buffer]
    xor  edx, edx
    call elf_write_so             ; a shared object: name.so
    mov  r11, rax
    lea  r10, [rel code_buffer]
    add  rsp, 32
    lea  rcx, [rel so_ext]
    mov  [rel bin_ext_ptr], rcx
    jmp  .direct_name
.direct_elf_exe:
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
    mov  byte [rel out_dynamic], 0
    call ew_set_layout
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
    mov  rcx, r15
    sub  rsp, 32
    call kasm_get_error_dst
    add  rsp, 32
    cmp  rax, 99
    jne  .ea_dup
    lea  rcx, [rel msg_nolabel]
    call print_string
    jmp  .ea_next
.ea_dup:
    cmp  rax, 98
    jne  .ea_kinds
    lea  rcx, [rel msg_duplabel]
    call print_string
    jmp  .ea_next
.ea_kinds:
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
.ea_next:
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
    
.error_long:
    lea  rcx, [rel msg_err_long]
    call print_string
    mov  eax, 2
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
    jmp  .ei_say
.ei_n3:
    cmp  eax, 3
    jne  .ei_n4
    lea  rcx, [rel msg_imp_many]
    jmp  .ei_say
.ei_n4:
    cmp  eax, 4
    jne  .ei_n5
    lea  rcx, [rel msg_imp_lines]
    jmp  .ei_say
.ei_n5:
    cmp  eax, 5
    jne  .ei_n6
    lea  rcx, [rel msg_imp_size]
    jmp  .ei_say
.ei_n6:
    cmp  eax, 6
    jne  .ei_say
    lea  rcx, [rel msg_imp_pool]
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
    ; where the lexer stopped, reported like the errors after it: the file,
    ; line and column, the line itself, and the characters marked
    call lexer_error_kind
    cmp  rax, 1
    je   .lex_char
    cmp  rax, 2
    je   .lex_text
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel msg_err_lex]
    call print_string
    mov  eax, 3
    pop  rbp
    ret
.lex_char:
    lea  rax, [rel d_hint_lexchar]
    mov  [rel cg_hint_msg], rax
    call lexer_error_token
    mov  rcx, rax
    mov  rdx, 10                     ; the character itself, then the hint
    call jup_semantic_set_error
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel d_lex_char]
    jmp  .sem_msg_go
.lex_text:
    lea  rax, [rel d_hint_lextext]
    mov  [rel cg_hint_msg], rax
    call lexer_error_token
    mov  rcx, rax
    mov  rdx, 11                     ; no name to show, a hint of its own
    call jup_semantic_set_error
    lea  rcx, [rel msg_newline]
    call print_string
    lea  rcx, [rel d_lex_text]
    jmp  .sem_msg_go
    
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
    cmp  byte [rel dbg_which], 1
    jne  .error_code_other
    lea  rcx, [rel msg_err_codebig]
    call print_string
    mov  eax, 5
    pop  rbp
    ret
.error_code_other:
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
; module_tag(): the module's name -- the input's file name without folder
; and extension, letters, digits and '_' kept, anything else made '_' --
; followed by '_', into cg_mod_tag. Its globals carry it: __g_lexer_pos.
module_tag:
    push rbx
    push rsi
    push rdi
    lea  rsi, [rel arg_input]
    mov  rdi, rsi
.mt_find:
    mov  al, [rsi]
    test al, al
    jz   .mt_start
    inc  rsi
    cmp  al, '/'
    je   .mt_sep
    cmp  al, '\'
    jne  .mt_find
.mt_sep:
    mov  rdi, rsi
    jmp  .mt_find
.mt_start:
    lea  rsi, [rel cg_mod_tag]
    xor  ebx, ebx
.mt_copy:
    cmp  ebx, 63
    jae  .mt_end
    mov  al, [rdi + rbx]
    test al, al
    jz   .mt_end
    cmp  al, '.'
    je   .mt_end
    cmp  al, '_'
    je   .mt_keep
    cmp  al, '0'
    jb   .mt_other
    cmp  al, '9'
    jbe  .mt_keep
    cmp  al, 'A'
    jb   .mt_other
    cmp  al, 'Z'
    jbe  .mt_keep
    cmp  al, 'a'
    jb   .mt_other
    cmp  al, 'z'
    jbe  .mt_keep
.mt_other:
    mov  al, '_'
.mt_keep:
    mov  [rsi + rbx], al
    inc  ebx
    jmp  .mt_copy
.mt_end:
    lea  rdi, [rsi + rbx]
    mov  byte [rdi], '_'
    mov  byte [rdi + 1], 0
    pop  rdi
    pop  rsi
    pop  rbx
    ret

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
    ; append ".asm" -- "_kr.asm" for a module, so that lexer.kr does not
    ; overwrite the lexer.asm beside it
    lea  rsi, [rel asm_ext]
    cmp  byte [rel arg_flag_module], 0
    je   .app_go
    lea  rsi, [rel mod_ext]
.app_go:
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
; ew_set_layout(): the header area and the base of the image, from
; out_dynamic -- 128 bytes and 0x400080 for a program that reaches the system
; by its calls alone, 1 KB and 0x400400 for one linked with its libraries
ew_set_layout:
    mov  rax, 128
    cmp  byte [rel out_dynamic], 0
    je   .sl_set
    mov  rax, 1024
.sl_set:
    mov  [rel ew_hsize], rax
    add  rax, 0x400000
    mov  [rel ew_base], rax
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

; ==============================================================================
; imp_read(rcx = module name, rdx = address of a qword for the length)
;   -> rax = where the module's bytes are, 0 when there is no such file,
;      -1 when the file is longer than the room left (IMP_POOL bytes in all,
;      at most SRC_BUFFER_SIZE for one file)
;
; The module is looked for next to the program first, then as written, as
; %include does. Each file takes its own place in imp_pool, so the bytes of
; one module stay where they are while the next is read. The import pass
; (imports.kr, in Kron) calls this to read a file; the pass is in Kron, and
; only this reading is here. Keeps every register but rax.
; ==============================================================================
imp_read:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    mov  r12, rdx                   ; where the length goes
    mov  r13, rcx                   ; the name
    mov  rbx, [rel imp_pool_used]   ; the first free byte of the pool
    mov  r14, IMP_POOL
    sub  r14, rbx                   ; bytes left
    jz   .ir_full
    cmp  r14, SRC_BUFFER_SIZE
    jbe  .ir_room
    mov  r14, SRC_BUFFER_SIZE       ; one file at most this long
.ir_room:
    mov  rcx, r13
    call imp_fullpath               ; first next to the program
    mov  rcx, rax
    lea  rdx, [rel imp_pool]
    add  rdx, rbx
    mov  r8, r14
    call read_file
    test rax, rax
    jnz  .ir_got
    mov  rcx, r13                   ; then as written
    lea  rdx, [rel imp_pool]
    add  rdx, rbx
    mov  r8, r14
    call read_file
    test rax, rax
    jz   .ir_none
.ir_got:
    cmp  rax, r14
    jae  .ir_full                   ; as long as the room: it may be cut short
    mov  [r12], rax
    lea  rcx, [rax + 15]            ; the next file starts on a 16-byte boundary
    and  rcx, -16
    add  rcx, rbx
    mov  [rel imp_pool_used], rcx
    lea  rax, [rel imp_pool]
    add  rax, rbx
    jmp  .ir_out
.ir_none:
    xor  eax, eax
    jmp  .ir_out
.ir_full:
    mov  rax, -1
.ir_out:
    add  rsp, 40
    pop  rbp
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; expand_imports(rcx = source, rdx = length, r8 = output buffer)
;   -> rax = length of the expanded text, or -1 with imp_err and imp_errname
;
; The import pass is in Kron: ip_expand, in imports.kr, resolves the imports
; in dependency order, splices them in where the first acquire_domain is, and
; keeps the line map and the error. This is its door: it sets the --debug
; switch, runs the pass, and copies the results to where the rest of main
; reads them (imp_err, imp_errname, lmap_count, lmap_out, lmap_file, lmap_src).
; The Kron functions are called with the stack aligned and every value the
; door still needs kept in memory, since they may use any register.
; ==============================================================================
expand_imports:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    mov  [rel imp_src], rcx
    mov  [rel imp_len], rdx
    mov  [rel imp_out], r8
    mov  qword [rel imp_pool_used], 0
    movzx rcx, byte [rel arg_flag_debug]
    call ip_debug_set
    lea  rcx, [rel arg_input]       ; the program's name, for the map
    mov  rdx, [rel imp_src]
    mov  r8,  [rel imp_len]
    mov  r9,  [rel imp_out]
    mov  r10, SRC_BUFFER_SIZE
    call ip_expand
    mov  [rel imp_ret], rax
    call ip_err_get
    mov  [rel imp_err], eax
    call ip_errname_addr
    lea  rcx, [rel imp_errname]
    mov  rdx, rax
    mov  r8, 256
    call copy_bytes
    call ip_lm_count_get
    mov  [rel lmap_count], rax
    shl  rax, 3                     ; the tables are qwords
    mov  [rel imp_lmbytes], rax
    mov  rcx, 0
    call ip_lm_addr                 ; output lines
    lea  rcx, [rel lmap_out]
    mov  rdx, rax
    mov  r8, [rel imp_lmbytes]
    call copy_bytes
    mov  rcx, 1
    call ip_lm_addr                 ; file names
    lea  rcx, [rel lmap_file]
    mov  rdx, rax
    mov  r8, [rel imp_lmbytes]
    call copy_bytes
    mov  rcx, 2
    call ip_lm_addr                 ; lines of the files
    lea  rcx, [rel lmap_src]
    mov  rdx, rax
    mov  r8, [rel imp_lmbytes]
    call copy_bytes
    ; the resolved list, which the checks for std_text, std_list and the
    ; other library modules read (imp_have, the slice check)
    call ip_count_get
    mov  [rel imp_count], eax
    shl  rax, 8
    mov  [rel imp_nbytes], rax
    call ip_names_addr
    lea  rcx, [rel imp_names]
    mov  rdx, rax
    mov  r8, [rel imp_nbytes]
    call copy_bytes
    mov  rax, [rel imp_ret]
    add  rsp, 40
    pop  rbp
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
    ; android: ARM64 Linux with Android's C library; ios: macOS's program
    ; for an iPhone. Both are libraries (--lib) an app loads.
    lea  rdi, [rel tg_android]
    call st_word
    test eax, eax
    jz   .t_not_android
    mov  byte [rel out_android], 1
    mov  bl, TARGET_ARM64
    jmp  .out
.t_not_android:
    lea  rdi, [rel tg_ios]
    call st_word
    test eax, eax
    jz   .t_not_ios
    mov  byte [rel out_ios], 1
    mov  bl, TARGET_MACOS
    jmp  .out
.t_not_ios:
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

; st_word(rsi = text, rdi = a word) -> eax = 1 when the text is that word,
; then a blank or its end
st_word:
    push rcx
    xor  ecx, ecx
.sw_l:
    mov  al, [rdi + rcx]
    test al, al
    jz   .sw_end
    cmp  al, [rsi + rcx]
    jne  .sw_no
    inc  ecx
    jmp  .sw_l
.sw_end:
    mov  al, [rsi + rcx]
    cmp  al, ' '
    je   .sw_yes
    cmp  al, 9
    je   .sw_yes
    test al, al
    jz   .sw_yes
.sw_no:
    xor  eax, eax
    pop  rcx
    ret
.sw_yes:
    mov  eax, 1
    pop  rcx
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
    mov  byte [rel arg_flag_debug], 0
    mov  byte [rel arg_flag_window], 0
    mov  byte [rel arg_flag_lib], 0
    mov  byte [rel arg_flag_module], 0
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
    cmp  byte [rsi+2], 'l'
    je   .o_lib
    cmp  byte [rsi+2], 'd'
    je   .o_debug
    cmp  byte [rsi+2], 'm'
    je   .o_module
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
.o_debug:
    ; --debug: a build the debugger can stop (std_debug.kr)
    cmp  byte [rsi+3], 'e'
    jne  .o_skiptok
    cmp  byte [rsi+4], 'b'
    jne  .o_skiptok
    cmp  byte [rsi+5], 'u'
    jne  .o_skiptok
    cmp  byte [rsi+6], 'g'
    jne  .o_skiptok
    mov  byte [rel arg_flag_debug], 1
    add  rsi, 7
    jmp  .o_skiptok
.o_module:
    ; --module: the functions of a part of the compiler, as assembly text
    cmp  byte [rsi+3], 'o'
    jne  .o_skiptok
    cmp  byte [rsi+4], 'd'
    jne  .o_skiptok
    cmp  byte [rsi+5], 'u'
    jne  .o_skiptok
    cmp  byte [rsi+6], 'l'
    jne  .o_skiptok
    cmp  byte [rsi+7], 'e'
    jne  .o_skiptok
    mov  al, [rsi+8]
    cmp  al, ' '
    je   .o_module_yes
    cmp  al, 9
    je   .o_module_yes
    test al, al
    jnz  .o_skiptok
.o_module_yes:
    mov  byte [rel arg_flag_module], 1
    add  rsi, 8
    jmp  .o_skiptok
.o_lib:
    ; --lib: a library C and the rest can load, not a program
    cmp  byte [rsi+3], 'i'
    jne  .o_skiptok
    cmp  byte [rsi+4], 'b'
    jne  .o_skiptok
    mov  al, [rsi+5]
    cmp  al, ' '
    je   .o_lib_yes
    cmp  al, 9
    je   .o_lib_yes
    test al, al
    jnz  .o_skiptok
.o_lib_yes:
    mov  byte [rel arg_flag_lib], 1
    add  rsi, 5
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



