; ==============================================================================
; kasmchar.asm -- multi-character literals, the bug that broke module imports.
;
; Run by RUNTESTS as an encoding test: assembled with NASM and with kasm, the
; opcode bytes must match.
;
; Every operand here uses a form where only ONE encoding is possible: no
; displacement, or a register. Where a choice exists -- an 8-bit versus a
; 32-bit displacement -- kasm legitimately picks the longer one and the bytes
; shift, which would make this test fail for no good reason.
;
; kasm used to read a single character out of a quoted literal, so
; 'cmp dword [r14], "jupi"' compared against 0x6a. The header check in the
; import expander could never match, imports stopped being expanded, and the
; fixpoint still reported success because all three generations were wrong in
; the same way.
; ==============================================================================
bits 64

section .text

; --- four characters, packed little-endian ---------------------------------
    cmp  dword [r14], 'jupi'
    cmp  dword [rsi], 'jupi'
    cmp  dword [rax], 'ter_'
    cmp  dword [rbx], 'defi'

; --- two characters and one ------------------------------------------------
    cmp  word  [rsi], 'on'
    cmp  byte  [rsi], 's'
    cmp  byte  [r14], 'x'

; --- into a register, the other place literals appear ----------------------
    mov  eax, 'acqu'
    mov  ecx, 'ire_'
    mov  edx, 'doma'
; 'cmp eax, imm' is left out: NASM uses the short accumulator form 3D and
; kasm the general 81 /7. Both are correct and they differ in length, so
; comparing bytes there measures a preference, not an error.
    cmp  ecx, 'jupi'
    cmp  edx, 'on'
