; ==============================================================================
; kasmsimd.asm -- the packed SSE forms kasm just learned, checked against NASM.
;
;   nasm.exe -f bin -o s.bin kasmsimd.asm
;   kronc.exe kasmsimd.asm --assemble
;   cmd /c fc /b s.bin kasmsimd.kbin
;
; Only the opcode and ModRM bytes matter here. There is no data section, so
; nothing shifts and any difference is a real encoding bug.
;
; One mulps multiplies four floats at once. That is where the speed of a
; matrix multiply comes from, and none of it was reachable before.
; ==============================================================================
bits 64

section .text

; --- packed single precision: four floats -----------------------------------
    addps  xmm0, xmm1
    subps  xmm2, xmm3
    mulps  xmm4, xmm5
    divps  xmm6, xmm7
    sqrtps xmm0, xmm2

; --- packed double precision: two doubles -----------------------------------
    addpd  xmm0, xmm1
    subpd  xmm2, xmm3
    mulpd  xmm4, xmm5
    divpd  xmm6, xmm7
    sqrtpd xmm0, xmm2

; --- moving four floats at a time -------------------------------------------
    movups xmm0, [rax]
    movups [rax], xmm0
    movaps xmm1, [rcx]
    movaps [rcx], xmm1
    movupd xmm2, [rdx]
    movupd [rdx], xmm2
    movapd xmm3, [rbx]
    movapd [rbx], xmm3

; --- frame-relative, which is how a local array is reached ------------------
    movups xmm0, [rbp-16]
    movups [rbp-32], xmm0
    movaps xmm1, [rbp-48]
    movaps [rbp-64], xmm1

; --- control: scalar forms that already worked ------------------------------
    movsd  xmm0, [rbp-8]
    addsd  xmm0, xmm1
    mulsd  xmm2, xmm3
