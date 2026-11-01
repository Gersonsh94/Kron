; ==============================================================================
; KRON COMPILER - KRN WRITER: THE DOOR TO IT
;
; The KRN writer -- Kron's own executable container, KRN_FORMAT.md -- is
; written in Kron, in krn_writer.kr. kronc --module turns it into
; krn_writer_kr.asm, which kron_all.asm includes after this file; BUILD.bat and
; BOOTSTRAP.bat make it again with each compiler they build.
;
; main.asm calls these by their old names. Each keeps every register but rax,
; as the assembly did (main holds the file's length in r11 across
; krn_get_image), aligns the stack and calls the kw_ function it stands for.
; ==============================================================================

bits 64
default rel

section .text

global krn_init, krn_set_kind, krn_set_ring, krn_set_caps, krn_build, krn_get_image, krn_get_size
extern kw_init, kw_set_kind, kw_set_ring, kw_set_caps, kw_build, kw_get_image, kw_get_size

; krn_init(): a new file: an application, ring 3, no capabilities
krn_init:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_init
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; krn_set_kind(rcx = kind)
krn_set_kind:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_set_kind
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; krn_set_ring(rcx = ring)
krn_set_ring:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_set_ring
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; krn_set_caps(rcx = capabilities)
krn_set_caps:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_set_caps
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; krn_build() -> rax = the file's length
krn_build:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_build
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; krn_get_image() -> rax = the file
krn_get_image:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_get_image
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; krn_get_size() -> rax = its length
krn_get_size:
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
    sub  rsp, 40
    call kw_get_size
    add  rsp, 40
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rbp
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret
