; ==============================================================================
; KRON COMPILER - SEMANTIC ANALYZER + SYMBOL TABLE
; File: semantic/semantic.asm
; Architecture: x86-64 NASM
; Hash table for the symbol table, scope stack, type checking
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"

; --- SCOPE FLAGS ---
%define SCOPE_GLOBAL        0
%define SCOPE_FUNCTION      1
%define SCOPE_BLOCK         2
%define SCOPE_HARDWARE      3

; --- SYMBOL FLAGS ---
%define SYM_FLAG_CONST      (1 << 0)
%define SYM_FLAG_FUNCTION   (1 << 1)
%define SYM_FLAG_PARAM      (1 << 2)
%define SYM_FLAG_HARDWARE   (1 << 3)
%define SYM_FLAG_DEFINED    (1 << 4)

; --- SCOPE STACK ---
%define MAX_SCOPE_DEPTH     256
%define SCOPE_ENTRY_SIZE    16
; Offset 0: scope_id    (4)
; Offset 4: scope_type  (4)
; Offset 8: sym_count   (4)
; Offset 12: parent_idx (4)

section .bss
    ; Symbol hash table: array of pointers to linked lists
    sym_table           resq SYMTAB_BUCKETS   ; SYMTAB_BUCKETS * 8 bytes
    sym_arena           resq 1      ; arena for symbol entries
    sym_arena_ptr       resq 1
    sym_arena_end       resq 1

    ; Scope stack
    scope_stack         resb (MAX_SCOPE_DEPTH * SCOPE_ENTRY_SIZE)
    scope_depth         resd 1      ; current depth
    scope_id_counter    resd 1      ; unique id per scope

    ; Analyser state
    sem_had_error       resb 1
    sem_error_line      resq 1
    sem_error_tok       resq 1      ; the offending token itself: the line
                                    ; alone threw away the name and column
    sem_error_kind      resq 1      ; 0=undeclared 1=dup arena 2=zero-size 3=overlap
    sem_error_msg       resb 512
    sem_raw_depth       resd 1      ; how many raw { } blocks enclose this point
    sem_current_fn_type resd 1      ; return type of the current function

section .text
    global jup_semantic_init
    global jup_semantic_run
    global jup_semantic_error_line
    global symtab_insert
    global symtab_lookup
    global symtab_push_scope
    global symtab_pop_scope

; ==============================================================================
; semantic_init(sym_arena_ptr, arena_size)
; ==============================================================================
jup_semantic_init:
    mov     [rel sym_arena], rdi
    mov     [rel sym_arena_ptr], rdi
    add     rdi, rsi
    mov     [rel sym_arena_end], rdi

    ; Clear the hash table
    lea     rdi, [rel sym_table]
    xor     esi, esi
    mov     edx, SYMTAB_BUCKETS * 8
    call    memset_fast

    ; Initialize the scope
    xor     eax, eax
    mov     [rel scope_depth], eax
    mov     [rel scope_id_counter], eax
    mov     byte [rel sem_had_error], 0
    mov     qword [rel sem_error_line], 0
    mov     qword [rel sem_error_kind], 0
    mov     dword [rel sem_raw_depth], 0

    ; Push global scope
    mov     rdi, SCOPE_GLOBAL
    call    symtab_push_scope

    xor     eax, eax
    ret

; ==============================================================================
; sem_analyze_args(rdi = AST_ARG chain): each value in it
sem_analyze_args:
    push    r12
    mov     r12, rdi
.saa_loop:
    test    r12, r12
    jz      .saa_out
    mov     rdi, [r12 + AST.left]
    test    rdi, rdi
    jz      .saa_next
    call    sem_analyze_node
.saa_next:
    mov     r12, [r12 + AST.right]
    jmp     .saa_loop
.saa_out:
    pop     r12
    ret

; symtab_push_scope(scope_type)
;   rdi = scope_type
; ==============================================================================
symtab_push_scope:
    mov     eax, [rel scope_depth]
    cmp     eax, MAX_SCOPE_DEPTH - 1
    jge     .overflow

    ; Increment the id counter
    inc     dword [rel scope_id_counter]
    mov     ecx, [rel scope_id_counter]

    ; Work out the pointer to the scope entry
    imul    eax, SCOPE_ENTRY_SIZE
    lea     rdx, [rel scope_stack]
    add     rdx, rax

    mov     [rdx + 0], ecx          ; scope_id
    mov     [rdx + 4], edi          ; scope_type
    mov     dword [rdx + 8], 0      ; sym_count
    mov     eax, [rel scope_depth]
    dec     eax
    cmp     eax, -1
    jl      .no_parent
    mov     [rdx + 12], eax
    jmp     .done
.no_parent:
    mov     dword [rdx + 12], -1

.done:
    inc     dword [rel scope_depth]
    xor     eax, eax
    ret

.overflow:
    mov     rax, -1
    ret

; ==============================================================================
; symtab_pop_scope()
; ==============================================================================
symtab_pop_scope:
    mov     eax, [rel scope_depth]
    test    eax, eax
    jz      .empty
    dec     dword [rel scope_depth]
    xor     eax, eax
    ret
.empty:
    mov     rax, -1
    ret

; ==============================================================================
; symtab_insert(name_ptr, name_len, type, flags, value)
;   rdi = name_ptr
;   rsi = name_len
;   rdx = type (JTYPE_*)
;   rcx = flags
;   r8  = value (u64)
; Returns: rax = pointer to the sym entry, 0 on error
; ==============================================================================
symtab_insert:
    push    r12
    push    r13
    push    r14
    push    r15
    push    rbx

    mov     r12, rdi        ; name_ptr
    mov     r13, rsi        ; name_len
    mov     r14d, edx       ; type
    mov     r15d, ecx       ; flags
    mov     rbx, r8         ; value

    ; Compute the hash
    mov     rdi, r12
    mov     rsi, r13
    call    hash_fnv1a

    ; bucket = hash % SYMTAB_BUCKETS
    xor     edx, edx
    mov     ecx, SYMTAB_BUCKETS
    div     ecx
    ; rdx = bucket index

    ; Allocate an entry
    call    sym_alloc_entry
    test    rax, rax
    jz      .error

    ; Fill in the entry
    mov     [rax + SYM.name_ptr], r12
    mov     dword [rax + SYM.name_len], r13d
    mov     [rax + SYM.type], r14d
    mov     eax, [rel scope_depth]
    dec     eax
    push    rax
    pop     rcx
    ; Save the scope_id of the current scope
    imul    eax, SCOPE_ENTRY_SIZE
    lea     rcx, [rel scope_stack]
    add     rcx, rax
    mov     eax, [rcx]
    push    rax
    ; Restore r12 for the entry
    call    sym_alloc_entry_get_last
    pop     rcx
    mov     [rax + SYM.scope], ecx
    mov     [rax + SYM.flags], r15d
    mov     [rax + SYM.value], rbx
    or      dword [rax + SYM.flags], SYM_FLAG_DEFINED

    ; Insert at the head of the bucket list
    lea     rcx, [rel sym_table]
    imul    rdx, 8
    add     rcx, rdx
    mov     r8, [rcx]           ; prev head
    mov     [rax + SYM.next], r8
    mov     [rcx], rax

    ; Increment sym_count of the current scope
    push    rax
    mov     eax, [rel scope_depth]
    dec     eax
    imul    eax, SCOPE_ENTRY_SIZE
    lea     rcx, [rel scope_stack]
    add     rcx, rax
    inc     dword [rcx + 8]
    pop     rax

    pop     rbx
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    ret

.error:
    xor     eax, eax
    pop     rbx
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    ret

sym_alloc_entry_get_last:
    mov     rax, [rel sym_arena_ptr]
    sub     rax, SYMTAB_ENTRY_SIZE
    ret

; ==============================================================================
; symtab_lookup(name_ptr, name_len)
;   rdi = name_ptr
;   rsi = name_len
; Returns: rax = pointer to the sym entry, 0 if not found
; Searches from the innermost scope outwards
; ==============================================================================
symtab_lookup:
    push    r12
    push    r13
    push    r14

    mov     r12, rdi
    mov     r13, rsi

    ; Compute the hash
    call    hash_fnv1a

    xor     edx, edx
    mov     ecx, SYMTAB_BUCKETS
    div     ecx
    ; rdx = bucket

    ; Search the bucket list
    lea     rcx, [rel sym_table]
    imul    rdx, 8
    add     rcx, rdx
    mov     r14, [rcx]      ; head of the list

.search_loop:
    test    r14, r14
    jz      .not_found

    ; Compare the name
    mov     eax, dword [r14 + SYM.name_len]
    cmp     eax, r13d
    jne     .next_entry

    push    rdi
    push    rsi
    push    rcx
    mov     rdi, [r14 + SYM.name_ptr]
    mov     rsi, r12
    mov     rcx, r13
    call    sem_memcmp_n
    pop     rcx
    pop     rsi
    pop     rdi

    test    eax, eax
    jnz     .next_entry

    ; Found
    mov     rax, r14
    pop     r14
    pop     r13
    pop     r12
    ret

.next_entry:
    mov     r14, [r14 + SYM.next]
    jmp     .search_loop

.not_found:
    xor     eax, eax
    pop     r14
    pop     r13
    pop     r12
    ret

; ==============================================================================
; ------------------------------------------------------------------
; sem_token_to_u64(rdi = token) -> rax = value
; Reads a literal token's text: 0x-prefixed hex, otherwise decimal.
; A null token or unreadable text yields 0.
; ------------------------------------------------------------------
sem_token_to_u64:
    xor     rax, rax
    test    rdi, rdi
    jz      .out
    mov     rsi, [rdi + TOKEN.value]
    mov     ecx, dword [rdi + TOKEN.length]
    test    ecx, ecx
    jz      .out
    cmp     ecx, 2
    jbe     .dec
    cmp     byte [rsi], '0'
    jne     .dec
    mov     dl, [rsi+1]
    or      dl, 0x20
    cmp     dl, 'x'
    jne     .dec
    add     rsi, 2
    sub     ecx, 2
.hex:
    movzx   edx, byte [rsi]
    cmp     dl, '0'
    jb      .out
    cmp     dl, '9'
    jbe     .hdig
    or      dl, 0x20
    cmp     dl, 'a'
    jb      .out
    cmp     dl, 'f'
    ja      .out
    sub     edx, 'a' - 10
    jmp     .hadd
.hdig:
    sub     edx, '0'
.hadd:
    shl     rax, 4
    add     rax, rdx
    inc     rsi
    dec     ecx
    jnz     .hex
    ret
.dec:
    movzx   edx, byte [rsi]
    cmp     dl, '0'
    jb      .out
    cmp     dl, '9'
    ja      .out
    sub     edx, '0'
    imul    rax, rax, 10
    add     rax, rdx
    inc     rsi
    dec     ecx
    jnz     .dec
.out:
    ret

; sym_alloc_entry() - allocate a symbol entry in the arena
; Returns: rax = ptr, 0 when out of memory
; ==============================================================================
sym_alloc_entry:
    mov     rax, [rel sym_arena_ptr]
    mov     rcx, rax
    add     rcx, SYMTAB_ENTRY_SIZE
    cmp     rcx, [rel sym_arena_end]
    jg      .oom

    ; Clear the entry
    push    rdi
    push    rsi
    push    rdx
    push    rcx
    mov     rdi, rax
    xor     esi, esi
    mov     edx, SYMTAB_ENTRY_SIZE
    call    memset_fast
    pop     rcx
    pop     rdx
    pop     rsi
    pop     rdi

    mov     rax, [rel sym_arena_ptr]
    mov     [rel sym_arena_ptr], rcx
    ret

.oom:
    xor     eax, eax
    ret

; ==============================================================================
; hash_fnv1a(str_ptr, str_len)
;   rdi = str ptr
;   rsi = str len
; Returns: rax = u64 hash
; FNV-1a: very fast, good distribution
; ==============================================================================
hash_fnv1a:
    push    r8
    mov     rax, 0xcbf29ce484222325  ; FNV offset basis
    mov     r8,  0x100000001b3       ; FNV prime -- does NOT fit an imm32,
                                     ; so it must live in a register: imul
                                     ; r64,imm takes imm8/imm32 only, and
                                     ; every assembler guesses differently
                                     ; about what to do with the rest.
    mov     rcx, rsi                  ; counter
    test    rcx, rcx
    jz      .done

.loop:
    movzx   edx, byte [rdi]
    xor     rax, rdx
    imul    rax, r8
    inc     rdi
    dec     rcx
    jnz     .loop

.done:
    pop     r8
    ret

; ==============================================================================
; semantic_analyze(ast_root)
; rdi = pointer to the root node of the AST
; Returns: rax = 0 OK, -1 on error
; ==============================================================================
; sem_node_jtype(rdi = declaration node) -> eax = JTYPE_*
; The parser spreads type information across several fields; this derives
; a single JTYPE from them so the symbol table records a real type.
; sem_arr_value(r8 = element count, r12 = declaration node) -> r8 with the
; element width (bits 4-7 of AST.col) in its top byte, when it is an array.
; Keeps every other register.
sem_arr_value:
    test    r8, r8
    jz      .sav_out
    push    rax
    movzx   eax, word [r12 + AST.col]
    shr     eax, 4
    and     eax, 15
    shl     rax, 56
    or      r8, rax
    pop     rax
.sav_out:
    ret

sem_node_jtype:
    test    rdi, rdi
    jz      .t_i64
    movzx   eax, word [rdi + AST.col]
    and     eax, 1                  ; bit1 is the sign flag, not the float flag
    test    eax, eax
    jnz     .t_f64                  ; float flag set
    mov     eax, dword [rdi + AST.child_count]
    test    eax, eax
    jnz     .t_ptr                  ; pointer element width set
    mov     rax, [rdi + AST.left]
    test    rax, rax
    jnz     .t_struct               ; struct type name token present
.t_i64:
    mov     eax, JTYPE_I64
    ret
.t_f64:
    mov     eax, JTYPE_F64
    ret
.t_ptr:
    mov     eax, JTYPE_PTR
    ret
.t_struct:
    mov     eax, JTYPE_STRUCT
    ret

; ==============================================================================
; sem_edit_le1(rdi = a, rsi = alen, rdx = b, rcx = blen) -> eax = 1 when the
; two names are within ONE edit of each other: one letter changed, one added,
; one missing, or two adjacent swapped. Identical names return 0.
;
; Full edit distance needs a matrix. Distance one covers the typos people
; actually make, and when nothing is within one edit the compiler says
; nothing rather than guessing wrong.
; ==============================================================================
sem_edit_le1:
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    mov     r12, rdi                ; a
    mov     r13, rsi                ; alen
    mov     r14, rdx                ; b
    mov     r15, rcx                ; blen

    ; length difference of two or more: not a typo
    mov     rax, r13
    sub     rax, r15
    jns     .absdone
    neg     rax
.absdone:
    cmp     rax, 1
    ja      .no
    cmp     rax, 1
    je      .off_by_one

    ; --- same length: count the positions that differ -------------------
    xor     rbx, rbx                ; index
    xor     r8, r8                  ; mismatches
    mov     r9, -1                  ; first mismatch position
.same_loop:
    cmp     rbx, r13
    jae     .same_done
    mov     al, [r12 + rbx]
    cmp     al, [r14 + rbx]
    je      .same_next
    inc     r8
    cmp     r9, -1
    jne     .same_second
    mov     r9, rbx
    jmp     .same_next
.same_second:
    mov     r10, rbx                ; second mismatch position
.same_next:
    inc     rbx
    cmp     r8, 3
    jb      .same_loop
.same_done:
    test    r8, r8
    jz      .no                     ; identical: not a suggestion
    cmp     r8, 1
    je      .yes                    ; one letter changed
    cmp     r8, 2
    jne     .no
    ; two mismatches: a swap of adjacent letters still counts
    mov     rax, r10
    sub     rax, r9
    cmp     rax, 1
    jne     .no
    mov     al, [r12 + r9]
    cmp     al, [r14 + r10]
    jne     .no
    mov     al, [r12 + r10]
    cmp     al, [r14 + r9]
    jne     .no
    jmp     .yes

    ; --- lengths differ by one: one insertion or deletion ----------------
.off_by_one:
    ; r12/r13 = the longer, r14/r15 = the shorter
    cmp     r13, r15
    ja      .have_order
    ; swap through a scratch: kasm has no xchg. Emitting one would stop
    ; the kasm build dead, the way a 16-bit shift once did.
    mov     rax, r12
    mov     r12, r14
    mov     r14, rax
    mov     rax, r13
    mov     r13, r15
    mov     r15, rax
.have_order:
    xor     rbx, rbx                ; index into the longer
    xor     r8, r8                  ; index into the shorter
    xor     r9, r9                  ; skips used
.off_loop:
    cmp     r8, r15
    jae     .off_tail
    mov     al, [r12 + rbx]
    cmp     al, [r14 + r8]
    je      .off_both
    inc     r9
    cmp     r9, 1
    ja      .no
    inc     rbx                     ; skip one in the longer
    jmp     .off_loop
.off_both:
    inc     rbx
    inc     r8
    jmp     .off_loop
.off_tail:
    jmp     .yes

.yes:
    mov     eax, 1
    jmp     .out
.no:
    xor     eax, eax
.out:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

; ==============================================================================
; sem_suggest(rdi = name, rsi = len) -> rax = pointer to the closest declared
; name, rdx = its length. rax = 0 when nothing is within one edit.
;
; Walks every bucket of the symbol table. That is 4096 heads plus their
; chains, which only ever happens on the error path.
; ==============================================================================
sem_suggest:
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15
    mov     r12, rdi                ; the misspelled name
    mov     r13, rsi                ; its length
    xor     r14, r14                ; best match so far
    xor     r15, r15                ; bucket index
.bucket_loop:
    cmp     r15, SYMTAB_BUCKETS
    jae     .sug_done
    lea     rcx, [rel sym_table]
    mov     rbx, [rcx + r15*8]
.chain_loop:
    test    rbx, rbx
    jz      .next_bucket
    mov     rdi, r12
    mov     rsi, r13
    mov     rdx, [rbx + SYM.name_ptr]
    mov     ecx, dword [rbx + SYM.name_len]
    call    sem_edit_le1
    test    eax, eax
    jz      .next_entry2
    mov     r14, rbx                ; first match wins; good enough
    jmp     .sug_done
.next_entry2:
    mov     rbx, [rbx + SYM.next]
    jmp     .chain_loop
.next_bucket:
    inc     r15
    jmp     .bucket_loop
.sug_done:
    test    r14, r14
    jz      .sug_none
    mov     rax, [r14 + SYM.name_ptr]
    mov     edx, dword [r14 + SYM.name_len]
    jmp     .sug_out
.sug_none:
    xor     eax, eax
    xor     edx, edx
.sug_out:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

; jup_semantic_suggestion() -> rax = pointer, rdx = length of the nearest
; declared name to the one that failed, or 0 when there is nothing close.
    global jup_semantic_suggestion
jup_semantic_suggestion:
    mov     rax, [rel sem_error_tok]
    test    rax, rax
    jz      .none
    push    rax
    mov     rdi, [rax + TOKEN.value]
    mov     rax, [rsp]
    mov     esi, dword [rax + TOKEN.length]
    call    sem_suggest
    add     rsp, 8
    ret
.none:
    xor     eax, eax
    xor     edx, edx
    ret

jup_semantic_error_line:
    mov     rax, [rel sem_error_line]
    ret

    global jup_semantic_error_col
; ==============================================================================
; sem_raw_check(r12 = a peek or poke node) -- outside every raw { } block it is
; an error (kind 7), reported at the keyword. The first phase only warned;
; since every program, the library and Ganimedes keep their memory access
; inside raw, it is refused. Reports the first error only. Preserves every
; register.
; ==============================================================================
sem_raw_check:
    push    rax
    push    rdx
    mov     eax, [rel sem_raw_depth]
    test    eax, eax
    jnz     .rc_out
    cmp     byte [rel sem_had_error], 0
    jne     .rc_out
    mov     rdx, [r12 + AST.data]       ; the keyword token
    test    rdx, rdx
    jz      .rc_out
    mov     [rel sem_error_tok], rdx
    movzx   rax, word [rdx + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 7
    mov     byte [rel sem_had_error], 1
.rc_out:
    pop     rdx
    pop     rax
    ret

; jup_semantic_set_error(rcx = token, rdx = kind): an error found after the
; semantic pass (kind 8, from codegen's thread check) is reported through the
; same state, so main prints it like any other: position, name, source line.
    global jup_semantic_set_error
jup_semantic_set_error:
    mov     [rel sem_error_tok], rcx
    movzx   rax, word [rcx + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     [rel sem_error_kind], rdx
    mov     byte [rel sem_had_error], 1
    ret

jup_semantic_error_col:
    mov     rax, [rel sem_error_tok]
    test    rax, rax
    jz      .zero
    movzx   rax, word [rax + TOKEN.col]
    ret
.zero:
    xor     eax, eax
    ret

    global jup_semantic_error_len
jup_semantic_error_len:
    mov     rax, [rel sem_error_tok]
    test    rax, rax
    jz      .zero
    mov     eax, dword [rax + TOKEN.length]
    ret
.zero:
    xor     eax, eax
    ret

; jup_semantic_error_name() -> rax = pointer to the offending name, rdx = length.
; Not NUL-terminated: it points straight into the source.
    global jup_semantic_error_name
jup_semantic_error_name:
    mov     rax, [rel sem_error_tok]
    test    rax, rax
    jz      .zero
    mov     rdx, rax
    mov     eax, dword [rdx + TOKEN.length]
    mov     rcx, rax
    mov     rax, [rdx + TOKEN.value]
    mov     rdx, rcx
    ret
.zero:
    xor     eax, eax
    xor     edx, edx
    ret

    global jup_semantic_error_kind
jup_semantic_error_kind:
    mov     rax, [rel sem_error_kind]
    ret

jup_semantic_run:
    push    r12
    mov     r12, rdi

    test    r12, r12
    jz      .error

    ; Analyse the program
    call    sem_analyze_node

    cmp     byte [rel sem_had_error], 0
    jne     .error

    xor     eax, eax
    pop     r12
    ret

.error:
    mov     rax, -1
    pop     r12
    ret

; ==============================================================================
; sem_analyze_node(node_ptr)
; rdi = pointer to the AST node
; ==============================================================================
sem_analyze_node:
    push    r12
    push    rbx

    mov     r12, rdi
    test    r12, r12
    jz      .done

    mov     rbx, [r12 + AST.node_type]

    cmp     rbx, AST_PROGRAM
    je      .program

    cmp     rbx, AST_FUNCTION
    je      .function

    cmp     rbx, AST_VAR_DECL
    je      .var_decl

    cmp     rbx, AST_CONST_DECL
    je      .const_decl

    cmp     rbx, AST_BLOCK
    je      .block

    cmp     rbx, AST_ASSIGN
    je      .assign

    cmp     rbx, AST_BINOP
    je      .binop

    cmp     rbx, AST_UNOP
    je      .unop

    cmp     rbx, AST_CALL
    je      .call

    cmp     rbx, AST_RETURN
    je      .ret_stmt

    cmp     rbx, AST_MULTI
    je      .multi

    cmp     rbx, AST_LAMBDA
    je      .lambda

    ; builtin statements: analyze their argument expressions
    cmp     rbx, AST_PRINT
    je      .stmt_right
    cmp     rbx, AST_PRINTC
    je      .stmt_right
    cmp     rbx, AST_OUTB
    je      .stmt_lr
    cmp     rbx, AST_POKE
    je      .poke_chk
    cmp     rbx, AST_POKE8
    je      .poke_chk
    cmp     rbx, AST_POKE16
    je      .poke_chk
    cmp     rbx, AST_POKE32
    je      .poke_chk
    cmp     rbx, AST_PEEK
    je      .peek_chk
    cmp     rbx, AST_PEEK8
    je      .peek_chk
    cmp     rbx, AST_PEEK16
    je      .peek_chk
    cmp     rbx, AST_PEEK32
    je      .peek_chk
    cmp     rbx, AST_BEEP
    je      .stmt_lr
    ; expressions that hold another expression in AST.right: a peek inside
    ; one of them has to be seen too, or raw could be sidestepped
    cmp     rbx, AST_CAST
    je      .stmt_right
    cmp     rbx, AST_TRUNC
    je      .stmt_right
    cmp     rbx, AST_INB
    je      .stmt_right
    cmp     rbx, AST_DEREF
    je      .deref_chk
    cmp     rbx, AST_DLL_LOAD
    je      .dllload_chk
    cmp     rbx, AST_DLL_PROC
    je      .dllproc_chk
    cmp     rbx, AST_SYSCALL
    je      .syscall_chk
    cmp     rbx, AST_ARG_GET
    je      .stmt_right
    cmp     rbx, AST_CALL_INDIRECT
    je      .call_ind
    cmp     rbx, AST_SAVEFILE
    je      .stmt_save

    cmp     rbx, AST_IF
    je      .if_stmt

    cmp     rbx, AST_WHILE
    je      .while_stmt

    cmp     rbx, AST_LOOP_IN
    je      .loop_stmt

    cmp     rbx, AST_INDEX
    je      .index_node
    cmp     rbx, AST_MEMBER
    je      .member_node

    cmp     rbx, AST_IDENTIFIER
    je      .identifier

    cmp     rbx, AST_PARAM
    je      .param

    cmp     rbx, AST_IMPORT
    je      .done   ; imports are handled in the link phase

    cmp     rbx, AST_HARDWARE_BLOCK
    je      .hardware

    cmp     rbx, AST_MMU_DEF
    je      .mmu_def

    ; Literals: OK
    jmp     .done

; --- M03: validate the heap_arena_definition chain hanging off AST.left.
; Two arenas may not share a name (the emitted symbol would collide) and a
; zero-sized arena can never satisfy an allocation, and two regions may not
; overlap: [base, base+size) of one must not intersect the other's. ---
.mmu_def:
    mov     r13, [r12 + AST.left]       ; first arena entry
.arn_out:
    test    r13, r13
    jz      .done
    ; -- size_bytes must not be zero --
    mov     rdi, [r13 + AST.type_info]
    test    rdi, rdi
    jz      .arn_dup
    mov     rsi, [rdi + TOKEN.value]
    mov     ecx, dword [rdi + TOKEN.length]
    test    ecx, ecx
    jz      .arn_dup
.arn_zloop:
    cmp     byte [rsi], '0'
    jne     .arn_dup                    ; a non-zero digit: size is fine
    inc     rsi
    dec     ecx
    jnz     .arn_zloop
    ; every character was '0'
    mov     rdi, [r13 + AST.data]
    movzx   rax, word [rdi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 2
    mov     byte [rel sem_had_error], 1
.arn_dup:
    ; -- name must be unique among the following entries --
    mov     r14, [r13 + AST.right]
.arn_in:
    test    r14, r14
    jz      .arn_next
    ; -- regions must not overlap: a.base < b.end AND b.base < a.end --
    push    r12
    push    r13
    push    r14
    mov     rdi, [r13 + AST.left]        ; a.base token
    call    sem_token_to_u64
    mov     r8, rax
    mov     rdi, [r13 + AST.type_info]   ; a.size token
    call    sem_token_to_u64
    add     rax, r8
    jb      .arn_ovl_out
    mov     r9, rax                      ; a.end
    mov     rdi, [r14 + AST.left]        ; b.base token
    call    sem_token_to_u64
    mov     r10, rax
    mov     rdi, [r14 + AST.type_info]   ; b.size token
    call    sem_token_to_u64
    add     rax, r10
    jb      .arn_ovl_out
    mov     r11, rax                     ; b.end
    cmp     r8, r11
    jae     .arn_ovl_out
    cmp     r10, r9
    jae     .arn_ovl_out
    pop     r14
    pop     r13
    pop     r12
    mov     rdi, [r14 + AST.data]
    movzx   rax, word [rdi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 3
    mov     byte [rel sem_had_error], 1
    jmp     .arn_in_next
.arn_ovl_out:
    pop     r14
    pop     r13
    pop     r12
    ; -- name must be unique --
    mov     rax, [r13 + AST.data]
    mov     rbx, [r14 + AST.data]
    mov     ecx, dword [rax + TOKEN.length]
    cmp     ecx, dword [rbx + TOKEN.length]
    jne     .arn_in_next
    push    r12
    push    r13
    push    r14
    mov     rdi, [rax + TOKEN.value]
    mov     rsi, [rbx + TOKEN.value]
    mov     ecx, dword [rax + TOKEN.length]
    call    sem_memcmp_n
    pop     r14
    pop     r13
    pop     r12
    test    eax, eax
    jnz     .arn_in_next
    ; duplicate arena name
    mov     rdi, [r14 + AST.data]
    movzx   rax, word [rdi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 1
    mov     byte [rel sem_had_error], 1
.arn_in_next:
    mov     r14, [r14 + AST.right]
    jmp     .arn_in
.arn_next:
    mov     r13, [r13 + AST.right]
    jmp     .arn_out


.program:
    ; Analyse every child
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.function:
    ; Register the function in the symbol table
    mov     rdi, [r12 + AST.data]   ; name token
    test    rdi, rdi
    jz      .done

    mov     rsi, [rdi + TOKEN.value]    ; pointer to the name
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx
    mov     rcx, rdx
    ; rsi = name_ptr, rcx = name_len
    mov     r10, r12                ; the function node, kept as its value
    push    r12
    mov     r12, rsi
    mov     r13, rcx
    mov     rdi, r12
    mov     rsi, r13
    mov     rdx, JTYPE_FN
    mov     rcx, SYM_FLAG_FUNCTION
    mov     r8, r10                 ; so a call can reach the parameters
    call    symtab_insert
    pop     r12

    ; Push a new scope for the function
    mov     rdi, SCOPE_FUNCTION
    call    symtab_push_scope

    ; Analyse the parameters
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node

    ; Analyse the body
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node

    call    symtab_pop_scope
    jmp     .done

.param:
    ; register each parameter in the current (function) scope
    test    r12, r12
    jz      .done
    mov     rdi, [r12 + AST.data]       ; name token
    test    rdi, rdi
    jz      .param_next
    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx
    push    r12
    push    rsi
    push    rdx
    mov     rdi, r12
    call    sem_node_jtype          ; param type from its AST.col float flag
    mov     r9d, eax
    pop     rdx
    pop     rsi
    mov     rdi, rsi
    mov     rsi, rdx
    mov     edx, r9d
    mov     rcx, 0
    mov     r8, [r12 + AST.type_info]   ; element count, 0 when not an array
    call    sem_arr_value               ; with the element width on top
    call    symtab_insert
    pop     r12
.param_next:
    mov     rdi, [r12 + AST.right]      ; next param
    call    sem_analyze_node
    jmp     .done

.var_decl:
    ; Register the variable
    mov     rdi, [r12 + AST.data]
    test    rdi, rdi
    jz      .done

    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx

    push    r12
    push    rsi
    push    rdx
    mov     rdi, r12
    call    sem_node_jtype          ; eax = real type of this declaration
    mov     r9d, eax
    pop     rdx
    pop     rsi
    mov     rdi, rsi
    mov     rsi, rdx
    mov     edx, r9d                ; type
    mov     rcx, 0
    mov     r8, [r12 + AST.type_info]   ; element count, 0 when not an array
    call    sem_arr_value               ; with the element width on top
    call    symtab_insert
    pop     r12

    ; Analyse the initialiser
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.const_decl:
    mov     rdi, [r12 + AST.data]
    test    rdi, rdi
    jz      .done

    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx

    push    r12
    mov     rdi, rsi
    mov     rsi, rdx
    mov     edx, JTYPE_I64
    mov     rcx, SYM_FLAG_CONST
    mov     r8, 0
    call    symtab_insert
    pop     r12

    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.block:
    ; raw { } is a block carrying BLOCK_RAW: inside it, peek and poke are
    ; allowed without a warning
    mov     rax, [r12 + AST.type_info]
    cmp     rax, BLOCK_RAW
    jne     .block_go
    mov     eax, [rel sem_raw_depth]
    inc     eax
    mov     [rel sem_raw_depth], eax
.block_go:
    mov     rdi, SCOPE_BLOCK
    call    symtab_push_scope

    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node

    call    symtab_pop_scope
    mov     rax, [r12 + AST.type_info]
    cmp     rax, BLOCK_RAW
    jne     .done
    mov     eax, [rel sem_raw_depth]
    dec     eax
    mov     [rel sem_raw_depth], eax
    jmp     .done

.poke_chk:
    call    sem_raw_check
    jmp     .stmt_lr
.peek_chk:
    call    sem_raw_check
    jmp     .done
.dllload_chk:
    ; reaching into a system library is as delicate as memory by address:
    ; dll_load and dll_proc belong inside raw { } too
    call    sem_raw_check
    jmp     .stmt_right
.dllproc_chk:
    call    sem_raw_check
    jmp     .stmt_lr
.syscall_chk:
    ; a system call reaches the kernel directly: inside raw { } only, like
    ; dll_load. The keyword token is in type_info (data counts arguments).
    mov     eax, [rel sem_raw_depth]
    test    eax, eax
    jnz     .sys_args
    cmp     byte [rel sem_had_error], 0
    jne     .sys_args
    mov     rdx, [r12 + AST.type_info]
    test    rdx, rdx
    jz      .sys_args
    mov     [rel sem_error_tok], rdx
    movzx   rax, word [rdx + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 7
    mov     byte [rel sem_had_error], 1
    jmp     .sys_args
.sys_args:
    ; every argument is an expression: a peek inside one must be seen too
    mov     r13, [r12 + AST.right]
    jmp     .sys_next
.sys_next:
    test    r13, r13
    jz      .done
    push    r13
    mov     rdi, [r13 + AST.left]
    call    sem_analyze_node
    pop     r13
    mov     r13, [r13 + AST.right]
    jmp     .sys_next
.deref_chk:
    ; *p reads memory by address, like peek: it needs raw { } too. Pointer
    ; arithmetic does not -- p + 1 only computes a number, it touches nothing.
    call    sem_raw_check
    jmp     .stmt_right

.assign:
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    ; Check the left side is a valid lvalue
    mov     rdi, [r12 + AST.left]
    call    sem_check_lvalue

    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.binop:
.unop:
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.call:
    ; Check the function exists
    mov     rdi, [r12 + AST.data]
    test    rdi, rdi
    jz      .done

    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx

    push    r12
    mov     rdi, rsi
    mov     rsi, rdx
    call    symtab_lookup
    pop     r12

    test    rax, rax
    jnz     .call_found
    ; Function not defined - could be a builtin or a forward reference
    ; Allowed for now (checked at link time)

.call_found:
    ; -- an array passed where the function expects a bigger one ---------------
    ; Inside the function, every index is checked against the size its
    ; parameter DECLARES. That is only safe if the array really is that big,
    ; so a smaller one is refused here, at compile time, at no run-time cost.
    ; rax is the callee's symbol, or 0 for one not found (a builtin).
    test    rax, rax
    jz      .call_args
    ; a variable holding a function: no parameters to compare against
    test    dword [rax + SYM.flags], SYM_FLAG_FUNCTION
    jz      .call_args
    mov     rcx, [rax + SYM.value]      ; the function's node
    test    rcx, rcx
    jz      .call_args
    push    r12
    push    r13
    push    r14
    mov     r13, [rcx + AST.left]       ; first parameter
    mov     r14, [r12 + AST.right]      ; first argument
.ca_loop:
    test    r13, r13
    jz      .ca_done
    test    r14, r14
    jz      .ca_done
    mov     rdx, [r13 + AST.type_info]  ; what the parameter declares
    test    rdx, rdx
    jz      .ca_next                    ; not an array parameter
    mov     rdi, [r14 + AST.left]       ; the argument
    test    rdi, rdi
    jz      .ca_next
    cmp     qword [rdi + AST.node_type], AST_IDENTIFIER
    jne     .ca_next
    push    rdx
    push    rdi
    mov     rdi, [rdi + AST.data]
    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]
    mov     rdi, rsi
    mov     rsi, rdx
    call    symtab_lookup
    pop     rdi
    pop     rdx
    test    rax, rax
    jz      .ca_next
    mov     rcx, [rax + SYM.value]      ; the argument's size
    test    rcx, rcx
    jz      .ca_next                    ; not an array: nothing to compare
    ; the top byte is the element width (sem_arr_value). An array of u8
    ; read through an i64 parameter would be read eight bytes at a time.
    mov     r8, rcx
    shr     r8, 56
    mov     r9, 0x00FFFFFFFFFFFFFF
    and     rcx, r9
    movzx   r9d, word [r13 + AST.col]
    shr     r9d, 4
    and     r9d, 15
    test    r8d, r8d
    jnz     .ca_aw
    mov     r8d, 8
.ca_aw:
    test    r9d, r9d
    jnz     .ca_pw
    mov     r9d, 8
.ca_pw:
    cmp     r8d, r9d
    jne     .ca_width
    cmp     rcx, rdx
    jae     .ca_next
    cmp     byte [rel sem_had_error], 0
    jne     .ca_done                    ; report the first error only
    mov     rsi, [rdi + AST.data]
    mov     [rel sem_error_tok], rsi
    movzx   rax, word [rsi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 6
    mov     byte [rel sem_had_error], 1
    jmp     .ca_done
.ca_width:
    cmp     byte [rel sem_had_error], 0
    jne     .ca_done
    mov     rsi, [rdi + AST.data]
    mov     [rel sem_error_tok], rsi
    movzx   rax, word [rsi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 9
    mov     byte [rel sem_had_error], 1
    jmp     .ca_done
.ca_next:
    mov     r13, [r13 + AST.right]
    mov     r14, [r14 + AST.right]
    jmp     .ca_loop
.ca_done:
    pop     r14
    pop     r13
    pop     r12
.call_args:
    ; The arguments. They are a list of AST_ARG nodes in AST.right -- this used
    ; to look in AST.left, which is always empty, so no argument of any call
    ; was ever analyzed. The cursor rides on the stack: the recursion keeps
    ; only r12 and rbx.
    mov     rax, [r12 + AST.right]
.cargs_loop:
    test    rax, rax
    jz      .done
    push    rax
    mov     rdi, [rax + AST.left]
    call    sem_analyze_node
    pop     rax
    mov     rax, [rax + AST.right]
    jmp     .cargs_loop

.call_ind:
    ; call <pointer>(args): the pointer expression, then the same argument list
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    jmp     .call_args

.ret_stmt:
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    ; return a, b: the values after the first
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_args
    jmp     .done

.lambda:
    ; a function written as a value: its parameters and body in a scope of
    ; their own, with the names around it still in sight (it keeps them)
    mov     rdi, SCOPE_BLOCK
    call    symtab_push_scope
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    call    symtab_pop_scope
    jmp     .done

.multi:
    ; a, b = f(): the call, then every target that is a name
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_args
    jmp     .done

.stmt_right:
    ; one-argument builtin: analyze AST.right
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.stmt_lr:
    ; two-argument builtin: analyze AST.left and AST.right
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.stmt_save:
    ; savefile(buffer, len, name): analyze all three
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.data]
    call    sem_analyze_node
    jmp     .done

.if_stmt:
    mov     rdi, [r12 + AST.data]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    jmp     .done

.while_stmt:
    mov     rdi, [r12 + AST.data]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    ; the step of a 'for', kept apart from the body; 0 for a plain while
    mov     rdi, [r12 + AST.left]
    test    rdi, rdi
    jz      .done
    call    sem_analyze_node
    jmp     .done

.loop_stmt:
    mov     rdi, SCOPE_BLOCK
    call    symtab_push_scope

    ; Register the loop variable
    mov     rdi, [r12 + AST.data]
    test    rdi, rdi
    jz      .loop_body

    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx
    push    r12
    mov     rdi, rsi
    mov     rsi, rdx
    mov     edx, JTYPE_I64
    mov     rcx, 0
    mov     r8, 0
    call    symtab_insert
    pop     r12

.loop_body:
    mov     rdi, [r12 + AST.left]
    call    sem_analyze_node
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    call    symtab_pop_scope
    jmp     .done

.index_node:
    ; array[index]: verify the array name is declared, then analyze index
    mov     rdi, [r12 + AST.data]       ; array name token
    test    rdi, rdi
    jz      .idx_index
    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx
    push    r12
    mov     rdi, rsi
    mov     rsi, rdx
    call    symtab_lookup
    pop     r12
    test    rax, rax
    jnz     .idx_index
    ; the array itself is not declared: a different mistake from a plain
    ; undeclared variable, and it used to share that message
    mov     rdi, [r12 + AST.data]
    mov     [rel sem_error_tok], rdi
    movzx   rax, word [rdi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     qword [rel sem_error_kind], 4
    mov     byte [rel sem_had_error], 1
.idx_index:
    mov     rdi, [r12 + AST.right]      ; index expression
    call    sem_analyze_node
    jmp     .done

.member_node:
    ; struct.field: verify the struct var is declared
    mov     rdi, [r12 + AST.data]
    test    rdi, rdi
    jz      .done
    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx
    push    r12
    mov     rdi, rsi
    mov     rsi, rdx
    call    symtab_lookup
    pop     r12
    ; permissive on members for now (struct field resolution in codegen)
    jmp     .done

.identifier:
    ; Verify the identifier is a declared variable/param.
    mov     rdi, [r12 + AST.data]
    test    rdi, rdi
    jz      .done

    mov     rsi, [rdi + TOKEN.value]
    mov     edx, dword [rdi + TOKEN.length]   ; zero-extends into rdx

    push    r12
    mov     rdi, rsi
    mov     rsi, rdx
    call    symtab_lookup
    pop     r12

    test    rax, rax
    jnz     .done                   ; found -> ok
    ; not found: undeclared variable. Record the error and its line.
    mov     rdi, [r12 + AST.data]
    mov     [rel sem_error_tok], rdi
    movzx   rax, word [rdi + TOKEN.line]
    mov     [rel sem_error_line], rax
    mov     byte [rel sem_had_error], 1
    jmp     .done

.hardware:
    ; For hardware blocks only check that the name is unique
    mov     rdi, [r12 + AST.data]   ; keyword token
    test    rdi, rdi
    jz      .done

    ; Register the hardware block with special flags
    ; (simplified - the name may be the block type)
    mov     rdi, SCOPE_HARDWARE
    call    symtab_push_scope
    mov     rdi, [r12 + AST.right]
    call    sem_analyze_node
    call    symtab_pop_scope
    jmp     .done

.done:
    pop     rbx
    pop     r12
    ret

; ==============================================================================
; sem_check_lvalue(node_ptr)
; Checks that a node can be assigned to (lvalue)
; ==============================================================================
sem_check_lvalue:
    test    rdi, rdi
    jz      .ok

    mov     rax, [rdi + AST.node_type]
    cmp     rax, AST_IDENTIFIER
    je      .ok
    cmp     rax, AST_INDEX
    je      .ok
    cmp     rax, AST_MEMBER
    je      .ok
    cmp     rax, AST_UNOP
    je      .ok                     ; *ptr = ... (deref)

    ; Not something that can be assigned to. This recorded no token and no
    ; line at all, so the diagnostic pointed wherever the previous error had
    ; been -- or at line zero -- and called it an undeclared name.
    mov     qword [rel sem_error_kind], 5
    mov     rax, [rdi + AST.data]
    test    rax, rax
    jz      .no_tok
    mov     [rel sem_error_tok], rax
    movzx   rcx, word [rax + TOKEN.line]
    mov     [rel sem_error_line], rcx
.no_tok:
    mov     byte [rel sem_had_error], 1

.ok:
    ret

; ==============================================================================
; memset_fast(dst, val, count) - optimised with rep stosd
; ==============================================================================
memset_fast:
    push    rdi
    push    rcx
    push    rax

    test    rdx, rdx
    jz      .done

    mov     rax, 0
    mov     rcx, rdx
    rep     stosb

.done:
    pop     rax
    pop     rcx
    pop     rdi
    ret

; ==============================================================================
; sem_memcmp_n(a, b, n) - reused from the lexer
; ==============================================================================
sem_memcmp_n:
    xor     eax, eax
    test    rcx, rcx
    jz      .done
.loop:
    movzx   edx, byte [rdi]
    movzx   r8d, byte [rsi]
    cmp     dl, r8b
    jne     .different
    inc     rdi
    inc     rsi
    dec     rcx
    jnz     .loop
    xor     eax, eax
    ret
.different:
    mov     eax, 1
.done:
    ret
