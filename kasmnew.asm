; ==============================================================================
; kasmnew.asm -- forms kasm learned that it used to refuse outright.
;
; Run by RUNTESTS as an encoding test. No data section and no displacements:
; where two encodings are legal, kasm picks the longer one and the bytes shift,
; which would fail the comparison without anything being wrong.
;
; Each line below once reached kasm's .unsupported path. Each one was a trap:
; NASM took it, kasm refused, and the self-build died on a change that
; looked harmless.
; ==============================================================================
bits 64

section .text

; --- memory destination with a 32-bit register source -----------------------
; 'add [mem], rax' already worked; the 32-bit form did not, because the
; dispatch only accepted one operand kind.
    add  dword [rax], edx
    sub  dword [rbx], eax
    and  dword [rcx], esi
    or   dword [rdx], edi
    xor  dword [rsi], ebx
    cmp  dword [rdi], ecx

; --- the 64-bit forms, as a control ----------------------------------------
    add  qword [rax], rdx
    sub  qword [rbx], rax

; --- register to register, another control ---------------------------------
    add  rax, rdx
    imul rax, rdx
    imul eax, edx
