; ==============================================================================
; JUPITER KERNEL ENTRY (no Multiboot)
; The MBR bootloader has already entered long mode, set up identity paging for
; the first 2 MB and jumped here at 0x100000. There is nothing else underneath:
; no GRUB, no firmware services, no operating system.
;
; Build:
;   jupiterc.exe program.jup --bare      -> program.asm
;   nasm -f bin kernel.asm -o kernel.bin
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

    ; hand control to the compiled Jupiter program
    call kmain

.hang:
    cli
    hlt
    jmp  .hang

msg_kernel: db "Jupiter kernel: long mode reached", 0

; ------------------------------------------------------------------------------
; The compiled Jupiter program: kmain, __print_int, __print_str, VGA output.
; Produced by:  jupiterc.exe program.jup --bare
; ------------------------------------------------------------------------------
%include "kernel_program.asm"
