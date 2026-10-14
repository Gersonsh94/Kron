; ARM64 TEST: hello for Linux on ARM64, assembled by kronc (karm).
;   kronc arm_hello.s --assemble --target=linux-arm64
; Expected output: one line, "Hello from Kron on ARM64", and exit code 0.
section .text
global _start
_start:
    mov  x0, #1                 ; stdout
    adrl x1, msg
    mov  x2, #MSGLEN
    mov  x8, #64                ; write
    svc  #0
    mov  x0, #0
    mov  x8, #93                ; exit
    svc  #0

section .data
msg: db "Hello from Kron on ARM64", 10
MSGLEN equ 25
