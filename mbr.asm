; ==============================================================================
; KRON MBR BOOTLOADER
; 512 bytes placed in the first sector of the disk. The BIOS loads this at
; 0x7C00 in 16-bit real mode and jumps here. No GRUB, no Multiboot.
;
; What it does:
;   1. sets up a stack and saves the boot drive number
;   2. reads the kernel (sectors 2 on) into memory at 0x8000
;   3. enables A20, builds identity paging for the first 2 MB
;   4. enters long mode, copies the kernel to 0x100000 and jumps there
;
; Build:  kronc.exe mbr.asm --assemble      (kasm: mbr.kbin, 512 bytes)
;
; kasm writes 64-bit code. Real mode comes before it, so the 16-bit part is
; written as the bytes of each instruction, with the instruction beside
; them; addresses and jump distances come from the labels (counted from
; 'org'), so the code can still be changed without counting bytes.
; ==============================================================================

bits 16
org 0x7C00

KERNEL_LOAD    equ 0x100000     ; where the kernel ends up (1 MB)
KERNEL_TEMP    equ 0x8000       ; staging area below 1 MB, reachable in real mode
KERNEL_SECTORS equ 64           ; 32 KB of kernel (kernel.asm pads to this)
KERNEL_BYTES   equ 32768        ; KERNEL_SECTORS * 512
PAGE_TABLES    equ 0x1000       ; PML4, PDPT and PD: 0x1000 to 0x3FFF, free
                                ; memory a 16-bit address reaches

start:
    db 0xFA                     ; cli
    db 0x31, 0xC0               ; xor ax, ax
    db 0x8E, 0xD8               ; mov ds, ax
    db 0x8E, 0xC0               ; mov es, ax
    db 0x8E, 0xD0               ; mov ss, ax
    db 0xBC                     ; mov sp, 0x7C00   the stack grows down below us
    dw 0x7C00
    db 0x88, 0x16               ; mov [boot_drive], dl   the BIOS gives the drive
    dw boot_drive
    db 0xFB                     ; sti

    db 0xBE                     ; mov si, msg_boot
    dw msg_boot
    db 0xE8                     ; call print16
    dw print16 - after_call1
after_call1:

    ; ---- read the kernel: BIOS int 13h, function 2 ----
    db 0xB4, 0x02               ; mov ah, 2        read sectors
    db 0xB0, KERNEL_SECTORS     ; mov al, KERNEL_SECTORS
    db 0xB5, 0x00               ; mov ch, 0        cylinder 0
    db 0xB1, 0x02               ; mov cl, 2        sector 2 (sector 1 is this MBR)
    db 0xB6, 0x00               ; mov dh, 0        head 0
    db 0x8A, 0x16               ; mov dl, [boot_drive]
    dw boot_drive
    db 0x31, 0xDB               ; xor bx, bx
    db 0x8E, 0xC3               ; mov es, bx
    db 0xBB                     ; mov bx, KERNEL_TEMP
    dw KERNEL_TEMP
    db 0xCD, 0x13               ; int 0x13
    db 0x72                     ; jc disk_error
    db disk_error - after_jc
after_jc:

    db 0xBE                     ; mov si, msg_load
    dw msg_load
    db 0xE8                     ; call print16
    dw print16 - after_call2
after_call2:

    ; ---- A20 on (fast A20, port 0x92) ----
    db 0xE4, 0x92               ; in al, 0x92
    db 0x0C, 0x02               ; or al, 2
    db 0xE6, 0x92               ; out 0x92, al

    ; ---- identity paging for the first 2 MB ----
    db 0xBF                     ; mov di, PAGE_TABLES
    dw PAGE_TABLES
    db 0xB9                     ; mov cx, 4096 * 3 / 4
    dw 3072
    db 0x66, 0x31, 0xC0         ; xor eax, eax
    db 0xF3, 0x66, 0xAB         ; rep stosd        es:di, es = 0
    db 0x66, 0xC7, 0x06         ; mov dword [PAGE_TABLES], PDPT | present | rw
    dw PAGE_TABLES
    dd PAGE_TABLES + 0x1003
    db 0x66, 0xC7, 0x06         ; mov dword [PAGE_TABLES + 0x1000], PD | present | rw
    dw PAGE_TABLES + 0x1000
    dd PAGE_TABLES + 0x2003
    db 0x66, 0xC7, 0x06         ; mov dword [PAGE_TABLES + 0x2000], 0x83
    dw PAGE_TABLES + 0x2000     ;   present | rw | a 2 MB page at 0
    dd 0x83

    ; ---- long mode ----
    db 0xFA                     ; cli
    db 0x0F, 0x01, 0x16         ; lgdt [gdt_descriptor]
    dw gdt_descriptor
    db 0x0F, 0x20, 0xE0         ; mov eax, cr4
    db 0x66, 0x83, 0xC8, 0x20   ; or eax, 1 << 5   CR4.PAE
    db 0x0F, 0x22, 0xE0         ; mov cr4, eax
    db 0x66, 0xB8               ; mov eax, PAGE_TABLES
    dd PAGE_TABLES
    db 0x0F, 0x22, 0xD8         ; mov cr3, eax
    db 0x66, 0xB9               ; mov ecx, 0xC0000080   EFER
    dd 0xC0000080
    db 0x0F, 0x32               ; rdmsr
    db 0x66, 0x0D               ; or eax, 1 << 8   LME: long mode enable
    dd 0x100
    db 0x0F, 0x30               ; wrmsr
    db 0x0F, 0x20, 0xC0         ; mov eax, cr0
    db 0x66, 0x0D               ; or eax, (1 << 31) | 1   PG | PE
    dd 0x80000001
    db 0x0F, 0x22, 0xC0         ; mov cr0, eax
    db 0xEA                     ; jmp 0x08:long_start
    dw long_start
    dw 0x08

disk_error:
    db 0xBE                     ; mov si, msg_err
    dw msg_err
    db 0xE8                     ; call print16
    dw print16 - after_call3
after_call3:
hang:
    db 0xF4                     ; hlt
    db 0xEB                     ; jmp hang
    db hang - after_hang
after_hang:

; print16: the text at si, through the BIOS (int 10h, teletype)
print16:
    db 0xAC                     ; lodsb
    db 0x08, 0xC0               ; or al, al
    db 0x74                     ; jz print16_done
    db print16_done - after_jz
after_jz:
    db 0xB4, 0x0E               ; mov ah, 0x0E
    db 0xB7, 0x00               ; mov bh, 0
    db 0xCD, 0x10               ; int 0x10
    db 0xEB                     ; jmp print16
    db print16 - after_jmp
after_jmp:
print16_done:
    db 0xC3                     ; ret

; ==============================================================================
; 64-bit: copy the kernel to 1 MB and run it
; ==============================================================================
bits 64
long_start:
    db 0x66, 0xB8, 0x10, 0x00   ; mov ax, 0x10
    db 0x8E, 0xD8               ; mov ds, ax
    db 0x8E, 0xC0               ; mov es, ax
    db 0x8E, 0xD0               ; mov ss, ax
    mov  rsp, 0x90000
    mov  rsi, KERNEL_TEMP
    mov  rdi, KERNEL_LOAD
    mov  rcx, KERNEL_BYTES
    rep  movsb
    db 0xE9                     ; jmp KERNEL_LOAD
    dd KERNEL_LOAD - after_jmp64
after_jmp64:

align 8
gdt_start:
    dq 0x0000000000000000       ; null
    dq 0x00AF9A000000FFFF       ; code: long mode, executable, readable
    dq 0x00CF92000000FFFF       ; data: writable
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

boot_drive: db 0
msg_boot:   db "Kron boot", 13, 10, 0
msg_load:   db "Kernel loaded", 13, 10, 0
msg_err:    db "Disk error", 13, 10, 0

pad_from:
    times 510 - (pad_from - start) db 0
    dw 0xAA55                   ; the signature the BIOS looks for
