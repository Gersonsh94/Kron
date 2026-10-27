; ==============================================================================
; KRON COMPILER - PE WRITER: THE DOOR TO IT
;
; The PE writer is written in Kron, in pe_writer.kr. kronc --module turns it
; into pe_writer_kr.asm, which kron_all.asm includes after this file; BUILD.bat
; and BOOTSTRAP.bat make it again with each compiler they build.
;
; The door has three jobs. main.asm calls pw_write, which hands the job to
; pe_write in Kron. main.asm sets three flags, which live here: pw_gui (--window),
; pw_dll (--lib) and pw_dll_file (the DLL's own name). And a few calls from
; Kron reach what is still in assembly: kasm_label_addr takes its index in rax,
; and codegen_export_name returns two values, of which Kron can read only one,
; so pw_export_name and pw_export_len each give one of them.
;
; Each function saves every register but rax, aligns the stack and calls the
; function it stands for.
; ==============================================================================

default rel
bits 64

section .data
    pw_gui      db 0                ; 1: GUI subsystem (main, for --window)
    pw_dll      db 0                ; 1: a DLL (main, for --lib)
    pw_dll_file dq 0                ; the DLL's own name, without its folder

section .text
    global pw_write
    global pw_gui, pw_dll, pw_dll_file

extern pe_write
extern kasm_label_addr
extern codegen_export_count
extern codegen_export_name

; pw_write(rcx = buffer of at least 2 MB) -> rax = total length
pw_write:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call pe_write
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

; pw_label_addr(rcx = label index) -> rax = the label's offset in its section
pw_label_addr:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    mov  rax, rcx
    call kasm_label_addr
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

; pw_export_count() -> rax = how many functions a library exports
pw_export_count:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call codegen_export_count
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

; pw_export_name(rcx = export number) -> rax = the name's address
pw_export_name:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call codegen_export_name
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

; pw_export_len(rcx = export number) -> rax = the name's length
pw_export_len:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call codegen_export_name
    mov  rax, rdx
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

; the flags and the DLL's name, as main set them
pw_flag_gui:
    movzx eax, byte [rel pw_gui]
    ret

pw_flag_dll:
    movzx eax, byte [rel pw_dll]
    ret

pw_dll_file_addr:
    mov  rax, [rel pw_dll_file]
    ret
