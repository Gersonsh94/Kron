; ARM64 NEGATIVE TEST: karm must refuse this file and say why, line by line.
; Every line below has one mistake: an undefined symbol, a missing operand,
; an unknown instruction, an immediate out of range, a value that is not an
; ARM64 bit mask, a branch to nowhere, a label defined twice, an unknown
; section.
section .text
_start:
    mov  x0, nowhere
    add  x0, x1
    frobnicate x1
    add  x0, x1, #5000
    and  x0, x1, #5
    b.eq missing
_start:
    nop
section .rodata
