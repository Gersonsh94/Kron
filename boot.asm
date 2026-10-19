; ==============================================================================
; KRON KERNEL - bare-metal boot stub (Multiboot1 -> 64-bit long mode)
; Written by hand once. It does not change from program to program.
; Boots in QEMU with:  qemu-system-x86_64 -kernel kernel.bin
;
; Flow: GRUB/QEMU loads it in 32-bit protected mode -> PAE paging with the
; first 2 MB identity-mapped -> long mode on -> jump to 64-bit code
; -> call kmain (the 'main' of your Kron program) -> hlt.
;
; Assemble:  kronc.exe boot.asm --assemble      (kasm: boot.kbin)
; boot.asm includes "kernel_program.asm" (the output of: kronc program.kr --bare)
;
; kasm writes 64-bit code. The 32-bit part runs before long mode is on, so
; it is written as the bytes of each instruction, the instruction beside
; them; the addresses inside come from the labels, counted from 'org'.
; ==============================================================================

bits 32
org 0x100000

; ---- Multiboot1 header (a.out kludge for a flat binary) ----
MB_MAGIC   equ 0x1BADB002
MB_FLAGS   equ 0x00010000            ; bit16 = use the address fields (a.out)
MB_CHECK   equ 0xE4514FFE            ; -(MB_MAGIC + MB_FLAGS), as 32 bits

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
    db 0xFA                          ; cli
    db 0xBC                          ; mov esp, stack_top
    dd stack_top

    ; clear the three page tables
    db 0xBF                          ; mov edi, pml4
    dd pml4
    db 0x31, 0xC0                    ; xor eax, eax
    db 0xB9                          ; mov ecx, (4096 * 3) / 4
    dd 3072
    db 0xF3, 0xAB                    ; rep stosd

    ; PML4[0] -> PDPT
    db 0xB8                          ; mov eax, pdpt
    dd pdpt
    db 0x83, 0xC8, 0x03              ; or eax, 3          present | rw
    db 0xA3                          ; mov [pml4], eax
    dd pml4

    ; PDPT[0] -> PD
    db 0xB8                          ; mov eax, pd
    dd pd
    db 0x83, 0xC8, 0x03              ; or eax, 3
    db 0xA3                          ; mov [pdpt], eax
    dd pdpt

    ; PD[0] = a 2 MB page at 0
    db 0xC7, 0x05                    ; mov dword [pd], 0x83   present | rw | 2 MB
    dd pd
    dd 0x83

    db 0xB8                          ; mov eax, pml4
    dd pml4
    db 0x0F, 0x22, 0xD8              ; mov cr3, eax

    db 0x0F, 0x20, 0xE0              ; mov eax, cr4
    db 0x83, 0xC8, 0x20              ; or eax, 1 << 5     CR4.PAE
    db 0x0F, 0x22, 0xE0              ; mov cr4, eax

    db 0xB9                          ; mov ecx, 0xC0000080   EFER
    dd 0xC0000080
    db 0x0F, 0x32                    ; rdmsr
    db 0x0D                          ; or eax, 1 << 8     LME
    dd 0x100
    db 0x0F, 0x30                    ; wrmsr

    db 0x0F, 0x20, 0xC0              ; mov eax, cr0
    db 0x0D                          ; or eax, (1 << 31) | 1   PG | PE
    dd 0x80000001
    db 0x0F, 0x22, 0xC0              ; mov cr0, eax

    db 0x0F, 0x01, 0x15              ; lgdt [gdt64_pointer]
    dd gdt64_pointer
    db 0xEA                          ; jmp 0x08:long_mode
    dd long_mode
    dw 0x08

; ==============================================================================
; 64-bit code
; ==============================================================================
bits 64
long_mode:
    db 0x66, 0xB8, 0x10, 0x00        ; mov ax, 0x10
    db 0x8E, 0xD8                    ; mov ds, ax
    db 0x8E, 0xC0                    ; mov es, ax
    db 0x8E, 0xD0                    ; mov ss, ax
    db 0x8E, 0xE0                    ; mov fs, ax
    db 0x8E, 0xE8                    ; mov gs, ax
    lea  rsp, [rel stack_top]

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
    dq 0x00209A0000000000            ; 64-bit code (L=1, present, exec/read)
    dq 0x0000920000000000            ; data (present, read/write)
gdt64_pointer:
    dw gdt64_pointer - gdt64 - 1
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
