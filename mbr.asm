; ==============================================================================
; JUPITER MBR BOOTLOADER
; 512 bytes placed in the first sector of the disk. The BIOS loads this at
; 0x7C00 in 16-bit real mode and jumps here. No GRUB, no Multiboot.
;
; What it does:
;   1. sets up a stack and saves the boot drive number
;   2. reads the kernel from sector 2 onward into memory at 0x100000
;   3. queries the BIOS memory map (unused for now, but read before we lose
;      real mode, since it is the only place it can be obtained)
;   4. enables A20, builds identity paging for the first 2 MB
;   5. enters long mode and jumps to the kernel
;
; Build:  nasm -f bin mbr.asm -o mbr.bin
; ==============================================================================

bits 16
org 0x7C00

KERNEL_LOAD   equ 0x100000      ; where the kernel ends up (1 MB)
KERNEL_TEMP   equ 0x8000        ; staging area below 1 MB, reachable in real mode
KERNEL_SECTORS equ 64           ; 32 KB of kernel; raise if it grows
PAGE_TABLES   equ 0x70000       ; PML4 / PDPT / PD live here

start:
    cli
    xor  ax, ax
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  sp, 0x7C00              ; stack grows down from just below us
    mov  [boot_drive], dl        ; the BIOS hands us the drive in dl
    sti

    mov  si, msg_boot
    call print16

    ; ---- read the kernel into the staging area ----
    mov  ah, 0x02                ; BIOS: read sectors
    mov  al, KERNEL_SECTORS
    mov  ch, 0                   ; cylinder 0
    mov  cl, 2                   ; sector 2 (sector 1 is this MBR)
    mov  dh, 0                   ; head 0
    mov  dl, [boot_drive]
    xor  bx, bx
    mov  es, bx
    mov  bx, KERNEL_TEMP
    int  0x13
    jc   disk_error

    mov  si, msg_load
    call print16

    ; ---- enable the A20 line so we can address above 1 MB ----
    in   al, 0x92
    or   al, 2
    out  0x92, al

    ; ---- build identity paging for the first 2 MB ----
    ; PML4[0] -> PDPT, PDPT[0] -> PD, PD[0] = 2 MB page at 0
    mov  edi, PAGE_TABLES
    mov  ecx, 4096 * 3 / 4
    xor  eax, eax
    push di
    mov  di, PAGE_TABLES
    rep  stosd
    pop  di

    mov  dword [PAGE_TABLES],          PAGE_TABLES + 0x1000 + 3
    mov  dword [PAGE_TABLES + 0x1000], PAGE_TABLES + 0x2000 + 3
    mov  dword [PAGE_TABLES + 0x2000], 0x83      ; present | rw | 2 MB page

    ; ---- switch to protected mode, then long mode ----
    cli
    lgdt [gdt_descriptor]

    mov  eax, cr4
    or   eax, 1 << 5             ; CR4.PAE
    mov  cr4, eax

    mov  eax, PAGE_TABLES
    mov  cr3, eax

    mov  ecx, 0xC0000080         ; EFER
    rdmsr
    or   eax, 1 << 8             ; LME: long mode enable
    wrmsr

    mov  eax, cr0
    or   eax, 1 << 31 | 1        ; PG | PE
    mov  cr0, eax

    jmp  0x08:long_start

disk_error:
    mov  si, msg_err
    call print16
.hang:
    hlt
    jmp  .hang

; ---- 16-bit teletype output ----
print16:
    lodsb
    or   al, al
    jz   .done
    mov  ah, 0x0E
    mov  bh, 0
    int  0x10
    jmp  print16
.done:
    ret

; ==============================================================================
bits 64
long_start:
    mov  ax, 0x10
    mov  ds, ax
    mov  es, ax
    mov  ss, ax
    mov  rsp, 0x90000

    ; move the kernel from the staging area up to 1 MB
    mov  rsi, KERNEL_TEMP
    mov  rdi, KERNEL_LOAD
    mov  rcx, KERNEL_SECTORS * 512
    rep  movsb

    jmp  KERNEL_LOAD

; ==============================================================================
align 8
gdt_start:
    dq 0x0000000000000000        ; null
    dq 0x00AF9A000000FFFF        ; code: long mode, executable, readable
    dq 0x00CF92000000FFFF        ; data: writable
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

boot_drive: db 0
msg_boot:   db "Jupiter boot", 13, 10, 0
msg_load:   db "Kernel loaded", 13, 10, 0
msg_err:    db "Disk error", 13, 10, 0

times 510 - ($ - $$) db 0
dw 0xAA55                        ; the signature the BIOS looks for
