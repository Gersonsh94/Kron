; ==============================================================================
; KRON COMPILER - ENTRY POINT WINDOWS x64
;
; The driver is written in Kron: main_cli.kr (the command line), main_drv.kr
; (the phases and their errors), main_out.kr (the outputs and --assemble),
; main_io.kr and main_pp.kr. What stays here is what they stand on: main's
; entry (the console's handle, then mx_main), the buffers and flags they
; reach through mn_addr, the host's script beside a .wasm (web_host.inc)
; and the calls into Windows (read_file, write_file, print_string,
; print_bytes, os_cmdline). Every other part of the compiler is Kron, and
; calls the others directly: there are no doors left.
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"
%include "web_host.inc"

extern __g_parser_par_used_slice
extern __g_parser_par_used_text, __g_parser_par_used_list, __g_parser_par_used_map

global write_file, read_file, pp_buffer, print_string, print_bytes
global mn_arg_input, mn_exp_buffer, mn_lmap_count, mn_lmap, mn_addr, os_cmdline
extern mx_main
global ww_host_js, ww_host_js_size

section .data
    asm_ext       db ".asm", 0
    mod_ext       db "_kr.asm", 0
    bin_ext       db ".kbin", 0
    bin_ext_ptr   dq 0

section .bss
    arg_input    resb 512
    arg_output   resb 512
    arg_flag_S   resb 1        ; -S: write the .asm instead of the .exe
    out_dynamic  resb 1        ; the program calls the system's libraries
    arg_flag_lib resb 1        ; --lib: a library (.dll .so .dylib), not a program
    out_android  resb 1        ; --target=android (out_target ARM64)
    out_ios      resb 1        ; --target=ios (out_target MACOS)
    arg_flag_check resb 1      ; --check: report errors, write nothing
    arg_flag_debug resb 1      ; --debug: a build the debugger can stop
    arg_flag_window resb 1     ; --window: a Windows program with no console
    arg_flag_module resb 1     ; --module: a part of the compiler, as text
    src_buffer   resb SRC_BUFFER_SIZE
    exp_buffer   resb SRC_BUFFER_SIZE   ; source after expanding imports
    inc_buffer   resb SRC_BUFFER_SIZE   ; one imported file at a time
    inc_buffer2  resb SRC_BUFFER_SIZE   ; the level below that one
    ; --- the import pass's results (main_out.kr's expand_imports) ---------
    imp_err      resd 1                 ; 1 cannot open, 2 too deep, 3 too many
    imp_errname  resb 260
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
    out_target   resb 1
    out_bin_name resb 512               ; filename taken from the directive
    src_size     resq 1
    token_buffer resb TOKEN_BUFFER_SIZE
    token_count  resq 1
    ast_buffer   resb AST_BUFFER_SIZE
    code_buffer  resb CODE_BUFFER_SIZE
    sym_buffer   resb SYM_BUFFER_SIZE
    out_asm_name resb 512
    hStdOut      resq 1
    ; the code generator's switches, which main_cli.kr and main_drv.kr set
    ; and read (mn_addr) and md_codegen_run hands over
    dbg_which    resb 1        ; why the output failed: 1 full, 2 locals
    cg_debug     resb 1        ; --debug: hooks before statements, records
    cg_as_module resb 1        ; --module: the functions alone, no program
    cg_mod_tag   resb 72       ; '<name>_': what a module's data labels carry

section .text

; a call into Kron from main: the registers main keeps saved, the
; stack aligned (main's own frame leaves it at 16)
%macro MD_CALL 1
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call %1
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
%endmacro

global main
global print_string
global arg_input, src_buffer, lmap_out, lmap_file, lmap_count

main:
    push rbp
    mov  rbp, rsp

    ; the console's handle, for print_string
    sub  rsp, 32
    mov  rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    add  rsp, 32
    mov  [rel hStdOut], rax

    ; everything else is main_out.kr's mx_main: the banner, the command
    ; line, the phases and the output. It answers the exit code; every
    ; register main's caller keeps is saved across it.
    MD_CALL mx_main
    pop  rbp
    ret

; ==============================================================================
; The host's script web_writer.kr writes beside a .wasm (include/web_host.inc)
; ==============================================================================
ww_host_js:
    lea  rax, [rel web_host_js]
    ret
ww_host_js_size:
    mov  rax, [rel web_host_js_size]
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

mn_arg_input:
    lea  rax, [rel arg_input]
    ret
mn_exp_buffer:
    lea  rax, [rel exp_buffer]
    ret
mn_lmap_count:
    mov  rax, [rel lmap_count]
    ret
; mn_lmap(rcx = 0 output lines, 1 file names, 2 lines of the files)
mn_lmap:
    lea  rax, [rel lmap_out]
    cmp  rcx, 1
    jne  .l2
    lea  rax, [rel lmap_file]
.l2:
    cmp  rcx, 2
    jne  .l3
    lea  rax, [rel lmap_src]
.l3:
    ret

; print_bytes(rcx = text, rdx = length)
print_bytes:
    push rbx
    push rsi
    push rdi
    sub  rsp, 64
    mov  r8, rdx
    mov  rdx, rcx
    mov  rcx, [rel hStdOut]
    lea  r9, [rsp + 48]
    mov  qword [rsp + 32], 0
    call WriteFile
    add  rsp, 64
    pop  rdi
    pop  rsi
    pop  rbx
    ret

; print_string(rcx = a zero-terminated text): to the console
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
; pp_buffer(rcx = 0 or 1) -> rax = the buffer the preprocessor (main_pp.kr)
; reads an included file into (1 for one included from an included file)
; ==============================================================================
pp_buffer:
    lea  rax, [rel inc_buffer]
    test rcx, rcx
    jz   .o
    lea  rax, [rel inc_buffer2]
.o:
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
; scan_target(rcx = command line) -> al = TARGET_* constant (255: no such
; target); parse_command_line(rcx = GetCommandLineA()) -> rax = 1 when there
; is an input. Their doors; main_cli.kr has them.
; ==============================================================================
os_cmdline:
    push rbx
    sub  rsp, 32
    call GetCommandLineA
    add  rsp, 32
    pop  rbx
    ret

; mn_addr(rcx = which) -> rax = the address of a buffer or flag main_cli.kr
; reads or writes (its A_ constants, in that order)
mn_addr:
    lea  rax, [rel mn_addr_table]
    mov  rax, [rax + rcx*8]
    ret

section .data
mn_addr_table:
    dq arg_input, arg_output, arg_flag_S, arg_flag_check, arg_flag_debug
    dq arg_flag_window, arg_flag_lib, arg_flag_module, out_android, out_ios
    dq out_bin_name, out_asm_name, bin_ext_ptr, bin_ext, asm_ext, mod_ext
    dq cg_mod_tag, out_target, src_buffer, src_size, exp_buffer
    dq token_buffer, token_count, ast_buffer, sym_buffer, code_buffer
    dq cg_debug, cg_as_module, dbg_which, out_dynamic, imp_err, imp_errname
    dq lmap_count, __g_parser_par_used_slice, __g_parser_par_used_text
    dq __g_parser_par_used_list, __g_parser_par_used_map
section .text
