; ==============================================================================
; KRON KERNEL ENTRY (no Multiboot)
; The MBR bootloader has already entered long mode, set up identity paging for
; the first 2 MB and jumped here at 0x100000. There is nothing else underneath:
; no GRUB, no firmware services, no operating system.
;
; Build (BUILDOS.bat does it):
;   kronc.exe program.kr --bare          -> program.asm, copied to kernel_program.asm
;   kronc.exe kernel.asm --assemble      -> kernel.kbin
; ==============================================================================

bits 64
org 0x100000

_start:
    ; a short banner straight to VGA text memory, before anything else runs
    mov  rdi, 0xB8000
    mov  rsi, msg_kernel
.banner:
    mov  al, [rsi]
    test al, al
    jz   .banner_done
    mov  [rdi], al
    mov  byte [rdi + 1], 0x0A     ; bright green on black
    add  rdi, 2
    inc  rsi
    jmp  .banner
.banner_done:

    ; hand control to the compiled Kron program
    call kmain

.hang:
    cli
    hlt
    jmp  .hang

msg_kernel: db "Kron kernel: long mode reached", 0

; ------------------------------------------------------------------------------
; The compiled Kron program: kmain, __print_int, __print_str, VGA output.
; Produced by:  kronc.exe program.kr --bare
; ------------------------------------------------------------------------------
%include "kernel_program.asm"
