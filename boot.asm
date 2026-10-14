; ==============================================================================
; KRON KERNEL - bare-metal boot stub (Multiboot1 -> 64-bit long mode)
; Written by hand once. It does not change from program to program.
; Boots in QEMU with:  qemu-system-x86_64 -kernel kernel.bin
;
; Flow: GRUB/QEMU loads it in 32-bit protected mode -> PAE paging with the
; first 2 MB identity-mapped -> long mode on -> jump to 64-bit code
; -> call kmain (the 'main' of your Kron program) -> hlt.
;
; Assemble:  nasm -f bin boot.asm -o kernel.bin
; boot.asm includes "kernel_program.asm" (the output of: kronc program.kr --bare)
; ==============================================================================

bits 32
org 0x100000

; ---- Multiboot1 header (a.out kludge for a flat binary) ----
MB_MAGIC   equ 0x1BADB002
MB_FLAGS   equ 0x00010000            ; bit16 = use the address fields (a.out)
MB_CHECK   equ -(MB_MAGIC + MB_FLAGS)

align 4
mb_header:
    dd MB_MAGIC
    dd MB_FLAGS
    dd MB_CHECK
    dd mb_header                     ; header_addr
    dd 0x100000                      ; load_addr
    dd 0                             ; load_end_addr (0 = load the whole file)
    dd 0                             ; bss_end_addr  (0 = no bss)
    dd _start                        ; entry_addr

; ==============================================================================
; 32-bit entry (Multiboot state)
; ==============================================================================
_start:
    cli
    mov  esp, stack_top

    ; --- Clear the page tables (PML4, PDPT, PD) ---
    mov  edi, pml4
    xor  eax, eax
    mov  ecx, (4096*3)/4
    rep  stosd

    ; --- Link the tables: the first 2 MB identity-mapped with one 2 MB page ---
    mov  eax, pdpt
    or   eax, 0x3                     ; present | rw
    mov  [pml4], eax

    mov  eax, pd
    or   eax, 0x3
    mov  [pdpt], eax

    mov  dword [pd], 0x83             ; present | rw | page-size(2MB), base 0

    ; --- Load CR3 with the PML4 ---
    mov  eax, pml4
    mov  cr3, eax

    ; --- Enable PAE (CR4.PAE = bit 5) ---
    mov  eax, cr4
    or   eax, 1 << 5
    mov  cr4, eax

    ; --- Enable long mode (EFER.LME = bit 8) ---
    mov  ecx, 0xC0000080
    rdmsr
    or   eax, 1 << 8
    wrmsr

    ; --- Enable paging + protection (CR0.PG | CR0.PE) ---
    mov  eax, cr0
    or   eax, (1 << 31) | (1 << 0)
    mov  cr0, eax

    ; --- Load the 64-bit GDT and jump to the long mode code segment ---
    lgdt [gdt64.pointer]
    jmp  0x08:long_mode

; ==============================================================================
; 64-bit code
; ==============================================================================
bits 64
long_mode:
    mov  ax, 0x10
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  fs, ax
    mov  gs, ax
    mov  rsp, stack_top

    call kmain                       ; <- your Kron program (fn main)

.hang:
    hlt
    jmp  .hang

; ==============================================================================
; 64-bit GDT
; ==============================================================================
align 8
gdt64:
    dq 0x0000000000000000            ; null
.code:
    dq 0x00209A0000000000            ; 64-bit code (L=1, present, exec/read)
.data:
    dq 0x0000920000000000            ; data (present, read/write)
.pointer:
    dw .pointer - gdt64 - 1
    dq gdt64

; ==============================================================================
; Page tables and stack (inside the binary, loaded into RAM)
; ==============================================================================
align 4096
pml4:         times 4096 db 0
pdpt:         times 4096 db 0
pd:           times 4096 db 0
stack_bottom: times 16384 db 0
stack_top:

; ==============================================================================
; The compiled Kron program (kmain, VGA __print_int, etc.)
; ==============================================================================
bits 64
%include "kernel_program.asm"
