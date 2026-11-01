; ==============================================================================
; KRON COMPILER - MACH-O WRITER: THE DOOR TO IT
;
; The Mach-O writer is written in Kron, in macho_writer.kr. kronc --module
; turns it into macho_writer_kr.asm, which kron_all.asm includes after this
; file; BUILD.bat and BOOTSTRAP.bat make it again with each compiler they
; build.
;
; main.asm calls macho_write and sets the three flags here (mo_dylib,
; mo_platform, mo_idname); macho_write hands the job to mw_write, and the
; writer reads the flags through the getters. Everything else it needs from
; karm and codegen it calls directly (codegen_export_name through the ELF
; writer's door, ew_export_name and ew_export_len).
;
; macho_write(rcx = output, rdx = the program's name, 0-terminated)
;   -> rax = length of the file, 0 when the image cannot be made
; It saves every register but rax and aligns the stack; the getters call
; nothing and keep every register.
; ==============================================================================

bits 64
default rel

global macho_write
global mo_dylib, mo_platform, mo_idname
global mo_get_dylib, mo_get_platform, mo_get_idname

extern mw_write

section .data
    mo_dylib      db 0               ; 1: a dylib (--lib), set by main
    mo_platform   dd 1               ; 1 macOS, 2 iOS
    mo_idname     dq 0               ; what follows @rpath/ in a dylib's name

section .text

macho_write:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call mw_write
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

; mo_get_dylib() -> rax = 1 for a dylib
mo_get_dylib:
    movzx eax, byte [rel mo_dylib]
    ret

; mo_get_platform() -> rax = 1 macOS, 2 iOS
mo_get_platform:
    mov  eax, dword [rel mo_platform]
    ret

; mo_get_idname() -> rax = the dylib's name after @rpath/
mo_get_idname:
    mov  rax, [rel mo_idname]
    ret
