; ==============================================================================
; kasmdiff.asm -- ENCODER DIFFERENTIAL CORPUS
;
; Every distinct instruction form that semantic.asm uses, one per line, in
; source order.  This file is not meant to run: it exists so that kasm and
; NASM can assemble the SAME instructions and have their bytes compared.
;
;   kronc.exe kasmdiff.asm --assemble --pe
;   nasm.exe -f win64 -i include\ -o kasmdiff.obj kasmdiff.asm
;   GoLink.exe /fo kasmdiff_nasm.exe /entry main /console kasmdiff.obj kernel32.dll
;
; Then diff the .text of both.  Any difference is a kasm encoding bug, with one
; known-benign exception: for 'mov r64, imm' kasm picks the 10-byte movabs and
; NASM the 7-byte sign-extended imm32.  Both are correct.
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"

; --- semantic.asm's own defines, copied verbatim so the operands resolve ---
%define SCOPE_GLOBAL        0
%define SCOPE_FUNCTION      1
%define SCOPE_BLOCK         2
%define SCOPE_HARDWARE      3
%define SYM_FLAG_CONST      (1 << 0)
%define SYM_FLAG_FUNCTION   (1 << 1)
%define SYM_FLAG_PARAM      (1 << 2)
%define SYM_FLAG_HARDWARE   (1 << 3)
%define SYM_FLAG_DEFINED    (1 << 4)
%define MAX_SCOPE_DEPTH     256
%define SCOPE_ENTRY_SIZE    16

section .data
    sym_arena        dq 0
    sym_arena_ptr    dq 0
    sym_arena_end    dq 0
    sym_table        times SYMTAB_BUCKETS dq 0
    scope_stack      times (MAX_SCOPE_DEPTH * SCOPE_ENTRY_SIZE) db 0
    scope_depth      dd 0
    scope_id_counter dd 0
    sem_had_error    db 0
    sem_error_line   dq 0
    sem_error_kind   dq 0

section .text
global main
main:
    mov     [rel sym_arena], rdi                   ; 1
    mov     [rel sym_arena_ptr], rdi               ; 2
    add     rdi, rsi                               ; 3
    mov     [rel sym_arena_end], rdi               ; 4
    lea     rdi, [rel sym_table]                   ; 5
    xor     esi, esi                               ; 6
    mov     edx, SYMTAB_BUCKETS * 8                ; 7
    call .tgt                                      ; 8
    xor     eax, eax                               ; 9
    mov     [rel scope_depth], eax                 ; 10
    mov     [rel scope_id_counter], eax            ; 11
    mov     byte [rel sem_had_error], 0            ; 12
    mov     qword [rel sem_error_line], 0          ; 13
    mov     qword [rel sem_error_kind], 0          ; 14
    mov     rdi, SCOPE_GLOBAL                      ; 15
    ret                                            ; 16
    mov     eax, [rel scope_depth]                 ; 17
    cmp     eax, MAX_SCOPE_DEPTH - 1               ; 18
    jge .tgt                                       ; 19
    inc     dword [rel scope_id_counter]           ; 20
    mov     ecx, [rel scope_id_counter]            ; 21
    imul    eax, SCOPE_ENTRY_SIZE                  ; 22
    lea     rdx, [rel scope_stack]                 ; 23
    add     rdx, rax                               ; 24
    mov     [rdx + 0], ecx                         ; 25
    mov     [rdx + 4], edi                         ; 26
    mov     dword [rdx + 8], 0                     ; 27
    dec     eax                                    ; 28
    cmp     eax, -1                                ; 29
    jl .tgt                                        ; 30
    mov     [rdx + 12], eax                        ; 31
    jmp .tgt                                       ; 32
    mov     dword [rdx + 12], -1                   ; 33
    inc     dword [rel scope_depth]                ; 34
    mov     rax, -1                                ; 35
    test    eax, eax                               ; 36
    jz .tgt                                        ; 37
    dec     dword [rel scope_depth]                ; 38
    push    r12                                    ; 39
    push    r13                                    ; 40
    push    r14                                    ; 41
    push    r15                                    ; 42
    push    rbx                                    ; 43
    mov     r12, rdi                               ; 44
    mov     r13, rsi                               ; 45
    mov     r14d, edx                              ; 46
    mov     r15d, ecx                              ; 47
    mov     rbx, r8                                ; 48
    mov     rdi, r12                               ; 49
    mov     rsi, r13                               ; 50
    xor     edx, edx                               ; 51
    mov     ecx, SYMTAB_BUCKETS                    ; 52
    div     ecx                                    ; 53
    test    rax, rax                               ; 54
    mov     [rax + SYM.name_ptr], r12              ; 55
    mov     dword [rax + SYM.name_len], r13d       ; 56
    mov     [rax + SYM.type], r14d                 ; 57
    push    rax                                    ; 58
    pop     rcx                                    ; 59
    lea     rcx, [rel scope_stack]                 ; 60
    add     rcx, rax                               ; 61
    mov     eax, [rcx]                             ; 62
    mov     [rax + SYM.scope], ecx                 ; 63
    mov     [rax + SYM.flags], r15d                ; 64
    mov     [rax + SYM.value], rbx                 ; 65
    or      dword [rax + SYM.flags], SYM_FLAG_DEFINED ; 66
    lea     rcx, [rel sym_table]                   ; 67
    imul    rdx, 8                                 ; 68
    add     rcx, rdx                               ; 69
    mov     r8, [rcx]                              ; 70
    mov     [rax + SYM.next], r8                   ; 71
    mov     [rcx], rax                             ; 72
    inc     dword [rcx + 8]                        ; 73
    pop     rax                                    ; 74
    pop     rbx                                    ; 75
    pop     r15                                    ; 76
    pop     r14                                    ; 77
    pop     r13                                    ; 78
    pop     r12                                    ; 79
    mov     rax, [rel sym_arena_ptr]               ; 80
    sub     rax, SYMTAB_ENTRY_SIZE                 ; 81
    mov     r14, [rcx]                             ; 82
    test    r14, r14                               ; 83
    mov     eax, dword [r14 + SYM.name_len]        ; 84
    cmp     eax, r13d                              ; 85
    jne .tgt                                       ; 86
    push    rdi                                    ; 87
    push    rsi                                    ; 88
    push    rcx                                    ; 89
    mov     rdi, [r14 + SYM.name_ptr]              ; 90
    mov     rsi, r12                               ; 91
    mov     rcx, r13                               ; 92
    pop     rsi                                    ; 93
    pop     rdi                                    ; 94
    jnz .tgt                                       ; 95
    mov     rax, r14                               ; 96
    mov     r14, [r14 + SYM.next]                  ; 97
    xor     rax, rax                               ; 98
    test    rdi, rdi                               ; 99
    mov     rsi, [rdi + TOKEN.value]               ; 100
    mov     ecx, dword [rdi + TOKEN.length]        ; 101
    test    ecx, ecx                               ; 102
    cmp     ecx, 2                                 ; 103
    jbe .tgt                                       ; 104
    cmp     byte [rsi], '0'                        ; 105
    mov     dl, [rsi+1]                            ; 106
    or      dl, 0x20                               ; 107
    cmp     dl, 'x'                                ; 108
    add     rsi, 2                                 ; 109
    sub     ecx, 2                                 ; 110
    movzx   edx, byte [rsi]                        ; 111
    cmp     dl, '0'                                ; 112
    jb .tgt                                        ; 113
    cmp     dl, '9'                                ; 114
    cmp     dl, 'a'                                ; 115
    cmp     dl, 'f'                                ; 116
    ja .tgt                                        ; 117
    sub     edx, 'a' - 10                          ; 118
    sub     edx, '0'                               ; 119
    shl     rax, 4                                 ; 120
    add     rax, rdx                               ; 121
    inc     rsi                                    ; 122
    dec     ecx                                    ; 123
    imul    rax, rax, 10                           ; 124
    mov     rcx, rax                               ; 125
    add     rcx, SYMTAB_ENTRY_SIZE                 ; 126
    cmp     rcx, [rel sym_arena_end]               ; 127
    jg .tgt                                        ; 128
    push    rdx                                    ; 129
    mov     rdi, rax                               ; 130
    mov     edx, SYMTAB_ENTRY_SIZE                 ; 131
    pop     rdx                                    ; 132
    mov     [rel sym_arena_ptr], rcx               ; 133
    push    r8                                     ; 134
    mov     rax, 0xcbf29ce484222325                ; 135
    mov     r8,  0x100000001b3                     ; 136
    mov     rcx, rsi                               ; 137
    test    rcx, rcx                               ; 138
    movzx   edx, byte [rdi]                        ; 139
    xor     rax, rdx                               ; 140
    imul    rax, r8                                ; 141
    inc     rdi                                    ; 142
    dec     rcx                                    ; 143
    pop     r8                                     ; 144
    movzx   eax, word [rdi + AST.col]              ; 145
    mov     eax, dword [rdi + AST.child_count]     ; 146
    mov     rax, [rdi + AST.left]                  ; 147
    mov     eax, JTYPE_I64                         ; 148
    mov     eax, JTYPE_F64                         ; 149
    mov     eax, JTYPE_PTR                         ; 150
    mov     eax, JTYPE_STRUCT                      ; 151
    mov     rax, [rel sem_error_line]              ; 152
    mov     rax, [rel sem_error_kind]              ; 153
    test    r12, r12                               ; 154
    cmp     byte [rel sem_had_error], 0            ; 155
    mov     rbx, [r12 + AST.node_type]             ; 156
    cmp     rbx, AST_PROGRAM                       ; 157
    je .tgt                                        ; 158
    cmp     rbx, AST_FUNCTION                      ; 159
    cmp     rbx, AST_VAR_DECL                      ; 160
    cmp     rbx, AST_CONST_DECL                    ; 161
    cmp     rbx, AST_BLOCK                         ; 162
    cmp     rbx, AST_ASSIGN                        ; 163
    cmp     rbx, AST_BINOP                         ; 164
    cmp     rbx, AST_UNOP                          ; 165
    cmp     rbx, AST_CALL                          ; 166
    cmp     rbx, AST_RETURN                        ; 167
    cmp     rbx, AST_PRINT                         ; 168
    cmp     rbx, AST_PRINTC                        ; 169
    cmp     rbx, AST_OUTB                          ; 170
    cmp     rbx, AST_POKE                          ; 171
    cmp     rbx, AST_POKE8                         ; 172
    cmp     rbx, AST_POKE16                        ; 173
    cmp     rbx, AST_POKE32                        ; 174
    cmp     rbx, AST_BEEP                          ; 175
    cmp     rbx, AST_SAVEFILE                      ; 176
    cmp     rbx, AST_IF                            ; 177
    cmp     rbx, AST_WHILE                         ; 178
    cmp     rbx, AST_LOOP_IN                       ; 179
    cmp     rbx, AST_INDEX                         ; 180
    cmp     rbx, AST_MEMBER                        ; 181
    cmp     rbx, AST_IDENTIFIER                    ; 182
    cmp     rbx, AST_PARAM                         ; 183
    cmp     rbx, AST_IMPORT                        ; 184
    cmp     rbx, AST_HARDWARE_BLOCK                ; 185
    cmp     rbx, AST_MMU_DEF                       ; 186
    mov     r13, [r12 + AST.left]                  ; 187
    test    r13, r13                               ; 188
    mov     rdi, [r13 + AST.type_info]             ; 189
    mov     rdi, [r13 + AST.data]                  ; 190
    movzx   rax, word [rdi + TOKEN.line]           ; 191
    mov     [rel sem_error_line], rax              ; 192
    mov     qword [rel sem_error_kind], 2          ; 193
    mov     byte [rel sem_had_error], 1            ; 194
    mov     r14, [r13 + AST.right]                 ; 195
    mov     rdi, [r13 + AST.left]                  ; 196
    mov     r8, rax                                ; 197
    add     rax, r8                                ; 198
    mov     r9, rax                                ; 199
    mov     rdi, [r14 + AST.left]                  ; 200
    mov     r10, rax                               ; 201
    mov     rdi, [r14 + AST.type_info]             ; 202
    add     rax, r10                               ; 203
    mov     r11, rax                               ; 204
    cmp     r8, r11                                ; 205
    jae .tgt                                       ; 206
    cmp     r10, r9                                ; 207
    mov     rdi, [r14 + AST.data]                  ; 208
    mov     qword [rel sem_error_kind], 3          ; 209
    mov     rax, [r13 + AST.data]                  ; 210
    mov     rbx, [r14 + AST.data]                  ; 211
    mov     ecx, dword [rax + TOKEN.length]        ; 212
    cmp     ecx, dword [rbx + TOKEN.length]        ; 213
    mov     rdi, [rax + TOKEN.value]               ; 214
    mov     rsi, [rbx + TOKEN.value]               ; 215
    mov     qword [rel sem_error_kind], 1          ; 216
    mov     r14, [r14 + AST.right]                 ; 217
    mov     r13, [r13 + AST.right]                 ; 218
    mov     rdi, [r12 + AST.left]                  ; 219
    mov     rdi, [r12 + AST.right]                 ; 220
    mov     rdi, [r12 + AST.data]                  ; 221
    mov     edx, dword [rdi + TOKEN.length]        ; 222
    mov     rcx, rdx                               ; 223
    mov     r12, rsi                               ; 224
    mov     r13, rcx                               ; 225
    mov     rdx, JTYPE_FN                          ; 226
    mov     rcx, SYM_FLAG_FUNCTION                 ; 227
    mov     r8, 0                                  ; 228
    mov     rdi, SCOPE_FUNCTION                    ; 229
    mov     r9d, eax                               ; 230
    mov     rdi, rsi                               ; 231
    mov     rsi, rdx                               ; 232
    mov     edx, r9d                               ; 233
    mov     rcx, 0                                 ; 234
    mov     edx, JTYPE_I64                         ; 235
    mov     rcx, SYM_FLAG_CONST                    ; 236
    mov     rdi, SCOPE_BLOCK                       ; 237
    mov     rdi, SCOPE_HARDWARE                    ; 238
    mov     rax, [rdi + AST.node_type]             ; 239
    cmp     rax, AST_IDENTIFIER                    ; 240
    cmp     rax, AST_INDEX                         ; 241
    cmp     rax, AST_MEMBER                        ; 242
    cmp     rax, AST_UNOP                          ; 243
    test    rdx, rdx                               ; 244
    mov     rax, 0                                 ; 245
    rep     stosb                                  ; 246
    movzx   r8d, byte [rsi]                        ; 247
    cmp     dl, r8b                                ; 248
    mov     eax, 1                                 ; 249

.tgt:
    ret
