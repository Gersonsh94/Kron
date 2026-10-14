; xmm8 .. xmm15: every SSE form kasm knows, with the REX byte they need.
; Compared byte for byte against NASM by RUNTESTS (ENCLIST).
bits 64
default rel
section .text
    movsd xmm8, xmm0
    movsd xmm15, [rbp-24]
    movsd [rbp-16], xmm9
    addsd xmm10, xmm11
    mulsd xmm1, xmm12
    ucomisd xmm13, xmm2
    xorps xmm14, xmm14
    cvtsi2sd xmm8, rax
    cvttsd2si rax, xmm9
    movups [rbp-48], xmm8
    movups xmm15, [rbp-64]
    movss xmm8, [rcx]
    movsd xmm0, [r11]
    movsd [r9], xmm12
    subpd xmm8, xmm1
    cvtss2sd xmm9, xmm8
    movq xmm10, rax
