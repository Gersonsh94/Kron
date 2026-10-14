; ==============================================================================
; kasmxmm.asm -- instructions the register allocator writes for floats.
;
; Run by RUNTESTS as an encoding test. Float locals now live in xmm6-xmm15,
; which Windows requires kept whole across calls, so a function that uses them
; saves all 128 bits with movups in its prologue and restores them at its
; return label. kasm has to assemble those when a program is built with kc.bat.
;
; Only xmm6 and xmm7: kasm does not know xmm8-xmm15 yet (it reads them as
; labels), and the allocator is held to RA_FREGS = 2 until it does. When kasm
; learns the REX prefix for SSE, the other eight go back in here.
;
; Displacements are all above 127 on purpose: a small one has an 8-bit and a
; 32-bit encoding, both legal, and the two assemblers may pick differently.
; Register-to-register movsd is left out for the same reason -- it has a load
; form and a store form -- and is checked by PETESTS running the programs.
; ==============================================================================
bits 64

section .text

; --- saving xmm6-xmm15 in the frame --------------------------------------------
    movups [rbp-200], xmm6
    movups [rbp-216], xmm7

; --- and restoring them ---------------------------------------------------------
    movups xmm6, [rbp-200]
    movups xmm7, [rbp-216]
