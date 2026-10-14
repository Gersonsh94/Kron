; ==============================================================================
; kasmrex.asm -- byte comparison for memory operands whose BASE is an extended
; register (r8..r15). Those need a REX.B prefix; the low registers do not.
;
;   nasm.exe -f bin -o r.bin kasmrex.asm
;   kronc.exe kasmrex.asm --assemble
;   cmd /c fc /b r.bin kasmrex.kbin
;
; This is the gap my shape comparison could not see: it folded every register
; into one symbol, so 'cmp byte [rbx], N' made 'cmp byte [r14], N' look like a
; form already in use. It is not: one carries a prefix and the other does not.
; ==============================================================================
bits 64

section .text

; --- byte compare against an immediate, low base then extended base ---------
    cmp  byte [rbx], 10
    cmp  byte [rsi], 10
    cmp  byte [r14], 10
    cmp  byte [r12], 10
    cmp  byte [r9], 10

; --- byte load, same pairing ------------------------------------------------
    mov  al, [rbx]
    mov  al, [r14]
    movzx eax, byte [rbx]
    movzx eax, byte [r14]

; --- qword through an extended base ----------------------------------------
    mov  rax, [r14]
    mov  [r14], rax
; 'inc qword [r14]' is left out: kasm refuses it outright, which is a seventh
; gap but a loud one -- it stops rather than emitting the wrong bytes.
