; db lists: decimal, hex, characters and text in any order, with spaces
; or tabs between them. Compared byte for byte against NASM by RUNTESTS
; (ENCLIST); in .text, where both put them right after the code. A hex
; value used to end the list at its 'x': 'db 0x51, 0x52' gave one byte,
; and every label after it moved.
bits 64
default rel
section .text
    lea  rax, [rel tail]
    ret
    one   db 0x51, 0x52, 0x53, 0x59, 0x57, 0x55, 0x54, 0x5A, 0x58, 0x56
    two   db 81, 0x52,	0x7F ,0xff
    three db "ab", 0x0D, 0x0A, 'c', 0
    four  db 0xA, 10, 0x10, 0x0
    tail  db 1
