; ==============================================================================
; KRON COMPILER - ELF WRITER: THE DOOR TO IT
;
; The ELF writer is written in Kron, in elf_writer.kr. kronc --module turns it
; into elf_writer_kr.asm, which kron_all.asm includes after this file; BUILD.bat
; and BOOTSTRAP.bat make it again with each compiler they build.
;
; The door has four jobs. main.asm calls elf_write, elf_write_arm,
; elf_write_so and so_prepare, and each of them hands the job to Kron. The
; rest are the few things Kron reads from what is still in assembly: the
; labels kasm and karm built (kasm_label_addr takes its index in rax, and
; codegen_export_name returns two values, of which Kron reads one per
; function), the flags main sets (out_dynamic, out_android, the output's
; name), the header sizes main keeps, and the static tables the file
; holds: the loader's names, the section names.
;
; Each function saves every register but rax, aligns the stack and calls the
; function it stands for. The getters call nothing and keep every register.
; ==============================================================================

default rel
bits 64

section .text
    global elf_write, elf_write_arm, elf_write_so, so_prepare
    global ew_label_addr, ew_export_name, ew_export_len
    global ew_get_hsize, ew_get_base, ew_put_hb
    global ew_out_dynamic, ew_out_android, ew_prepare_name
    global ew_addr_interp_x86, ew_addr_interp_arm, ew_addr_strtab
    global ew_addr_strtab_and, ew_addr_got_names, ew_addr_shnames
    global ew_addr_start, ew_len_strtab

extern el_write, el_write_arm, el_write_so, el_prepare
extern kasm_label_addr
extern codegen_export_name
extern build_bin_name

; elf_write(rcx = output buffer) -> rax = length of the Linux executable
elf_write:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call el_write
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

; elf_write_arm(rcx = output) -> rax = file length
elf_write_arm:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call el_write_arm
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

; elf_write_so(rcx = the file, edx = 0 x86-64, 1 ARM64) -> rax = its length
elf_write_so:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    call el_write_so
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

; so_prepare(): before elf_write_so. Keeps rcx: main passes the file in it.
so_prepare:
    push rcx
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call el_prepare
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    pop  rcx
    ret

; ew_label_addr(rcx = label index) -> rax = the label's offset in its section
ew_label_addr:
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

; ew_export_name(rcx = i) -> rax = the name of export i
ew_export_name:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    mov  ecx, ecx
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

; ew_export_len(rcx = i) -> rax = the length of export i's name
ew_export_len:
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    push rbp
    sub  rsp, 40
    mov  ecx, ecx
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

; ew_get_hsize() -> rax = bytes of headers before the image
ew_get_hsize:
    mov  rax, [rel ew_hsize]
    ret

; ew_get_base() -> rax = where the image is in memory
ew_get_base:
    mov  rax, [rel ew_base]
    ret

; ew_put_hb(rcx = headers, rdx = base): set both, as elf_write_so does
ew_put_hb:
    mov  [rel ew_hsize], rcx
    mov  [rel ew_base], rdx
    xor  eax, eax
    ret

; ew_out_dynamic() -> rax = 1 when the program calls the system's libraries
ew_out_dynamic:
    movzx eax, byte [rel out_dynamic]
    ret

; ew_out_android() -> rax = 1 for --target=android
ew_out_android:
    movzx eax, byte [rel out_android]
    ret

; ew_prepare_name() -> rax = the output's name, with .so for a library: what
; so_prepare made of it before the writer was in Kron
ew_prepare_name:
    push rcx
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    lea  rcx, [rel so_ext]
    mov  [rel bin_ext_ptr], rcx
    call build_bin_name
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rdi
    pop  rsi
    pop  rbx
    pop  rcx
    lea  rax, [rel out_bin_name]
    ret

; the static tables of the file, by address
ew_addr_interp_x86:
    lea  rax, [rel ed_interp_x86]
    ret

ew_addr_interp_arm:
    lea  rax, [rel ed_interp_arm]
    ret

ew_addr_strtab:
    lea  rax, [rel ed_strtab]
    ret

ew_addr_strtab_and:
    lea  rax, [rel ed_strtab_and]
    ret

ew_addr_got_names:
    lea  rax, [rel ed_got_names]
    ret

ew_addr_shnames:
    lea  rax, [rel so_shnames]
    ret

ew_addr_start:
    lea  rax, [rel ew_start_name]
    ret

ew_len_strtab:
    mov  rax, ed_strtab_len
    ret
