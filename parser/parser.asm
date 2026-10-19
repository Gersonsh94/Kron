; ==============================================================================
; KRON COMPILER - PARSER (AST-BUILDING)
; Architecture: x86-64 NASM win64
; Builds a real AST for the imperative core (fn, var, expr, control),
; and structurally validates the 22 TITAN modules as HARDWARE_BLOCK.
; Internal ABI: own conventions (not Win64), internal calls only.
; ==============================================================================

default rel
bits 64

%include "kron_types.inc"
%include "win64_api.inc"

section .data
; The two functions a slice access turns into. Tokens built here, not read from
; the source: codegen and the semantic pass only need their text.
tok_slice_get:  dq TOK_IDENT
                dq nm_slice_get
                dd 9
                dw 0, 0
tok_slice_set:  dq TOK_IDENT
                dq nm_slice_set
                dd 9
                dw 0, 0
nm_slice_get:   db "slice_get"
nm_slice_set:   db "slice_set"
; list<T> and map<T>: l[i] and m[k] become calls into std_list and std_map,
; the real versions when T is f64. Indexed by the collection kind: 0 slice,
; 1 list, 2 list of reals, 3 map, 4 map of reals.
tok_slicer_get: dq TOK_IDENT, nm_slicer_get
                dd 14
                dw 0, 0
tok_slicer_set: dq TOK_IDENT, nm_slicer_set
                dd 14
                dw 0, 0
nm_slicer_get:  db "slice_get_real"
nm_slicer_set:  db "slice_set_real"
tok_list_get:   dq TOK_IDENT, nm_list_get
                dd 8
                dw 0, 0
tok_list_set:   dq TOK_IDENT, nm_list_set
                dd 8
                dw 0, 0
tok_listr_get:  dq TOK_IDENT, nm_listr_get
                dd 13
                dw 0, 0
tok_listr_set:  dq TOK_IDENT, nm_listr_set
                dd 13
                dw 0, 0
tok_map_get:    dq TOK_IDENT, nm_map_get
                dd 7
                dw 0, 0
tok_map_set:    dq TOK_IDENT, nm_map_set
                dd 7
                dw 0, 0
tok_mapr_get:   dq TOK_IDENT, nm_mapr_get
                dd 12
                dw 0, 0
tok_mapr_set:   dq TOK_IDENT, nm_mapr_set
                dd 12
                dw 0, 0
nm_list_get:    db "list_get"
nm_list_set:    db "list_set"
nm_listr_get:   db "list_get_real"
nm_listr_set:   db "list_set_real"
nm_map_get:     db "map_get"
nm_map_set:     db "map_set"
nm_mapr_get:    db "map_get_real"
nm_mapr_set:    db "map_set_real"
; kind 6: a list<S> with S a name -- a struct, copied in and out whole by
; codegen, or an enum and the like, kept as integers
tok_lists_get:  dq TOK_IDENT, nm_lists_get
                dd 9
                dw 0, 0
tok_lists_set:  dq TOK_IDENT, nm_lists_set
                dd 9
                dw 0, 0
nm_lists_get:   db "list_sget"
nm_lists_set:   db "list_sset"
coll_get_toks:  dq tok_slice_get, tok_list_get, tok_listr_get, tok_map_get, tok_mapr_get, tok_slicer_get, tok_lists_get
coll_set_toks:  dq tok_slice_set, tok_list_set, tok_listr_set, tok_map_set, tok_mapr_set, tok_slicer_set, tok_lists_set
tok_list_len:   dq TOK_IDENT, nm_list_len
                dd 8
                dw 0, 0
nm_list_len:    db "list_len"
tok_one:        dq TOK_NUMBER, nm_one
                dd 1
                dw 0, 0
nm_one:         db "1"
tok_zero:       dq TOK_NUMBER, nm_zero
                dd 1
                dw 0, 0
nm_zero:        db "0"
nm_ty_text:     db "text"
nm_ty_list:     db "list"
nm_ty_map:      db "map"
    par_error_msg  db "Parser: invalid structure", 0
    tn_eof     db "end of file", 0
    tn_ident   db "an identifier", 0
    tn_int     db "an integer", 0
    tn_float   db "a decimal number", 0
    tn_string  db "a string", 0
    tn_lbrace  db "'{'", 0
    tn_rbrace  db "'}'", 0
    tn_lparen  db "'('", 0
    tn_rparen  db "')'", 0
    tn_lbrack  db "'['", 0
    tn_rbrack  db "']'", 0
    tn_semi    db "';'", 0
    tn_colon   db "':'", 0
    tn_comma   db "','", 0
    tn_assign  db "'='", 0
    tn_arrow   db "'->'", 0
    tn_kw      db "a keyword", 0
    tn_expr    db "an expression", 0
    tn_op      db "an operator", 0
    tn_unknown db "a token", 0
    msg_too_many_params db "a function takes at most 16 parameters", 0
    msg_ext_dots db "... comes last in the parameters of an extern fn, and only there", 0
    msg_ext_body db "an extern fn has no body: its code is in the library -- end it with ;", 0
    msg_for_in   db "for x in l: l has to be a list<T> declared before", 0
    msg_multi_call db "a, b = ... takes the results of a function call", 0
    msg_not_decl db "a declaration goes here -- fn, var, const, shared var, struct, enum: is there a } too many above?", 0
    msg_field_call db "a function kept in a field is called through a variable: var f = s.field; f(...)", 0
    msg_multi_global db "var a, b = f() is for inside a function", 0

section .bss
    par_tokens      resq 1
    par_token_count resq 1
    par_pos         resq 1
    par_last_array_len resq 1
    par_last_row_len   resq 1   ; elements per row of a 2-D array, 0 when flat
    par_last_arr_elem  resq 1   ; bytes per element of the array type just
                                ; parsed (1, 2, 4, 8), 0 when not an array
    par_cfg_depth   resq 1
    par_last_ptr_elem resq 1
    par_last_ptr_tok resq 1      ; ptr<S>: the name token of S, else 0
    par_fn_rettok  resq 1        ; fn f() -> S: the name token of S, else 0
    ; Every variable or parameter declared ptr<S> with S a name: the token
    ; of its name, and of S. Codegen looks a declaration up by its token to
    ; let p.x reach the field of the struct p points to.
    par_ps_decl    resq 8192
    par_ps_type    resq 8192
    par_ps_n       resd 1
    par_last_is_float resq 1
    par_last_is_unsigned resq 1
    par_custom_msg  resq 1      ; message for an error that is not a token
                                ; mismatch; 0 when the usual one applies
    par_thread_node resq 1      ; which of the four is being parsed
    par_no_slit     resq 1      ; nonzero while a struct literal would be
                                ; ambiguous with the '{' of a block
    par_expected    resq 1      ; token the parser was looking for when it
    par_stmt_kw  resq 1                ; keyword token of the statement being parsed
    par_last_is_slice resq 1           ; the type just parsed was slice<T>
    tn_kwbuf     resb 64               ; 'keyword', quoted, for error messages
    par_slice_toks resq 64             ; names declared slice<T> in this function
    par_slice_kind resd 64             ; collection kind of each, see coll_get_toks;
                                       ; bits 8-15: the type tag of an element
    par_slice_n  resd 1
    par_gcoll_toks resq 256            ; the same for globals: list<T> and map<T>
    par_gcoll_kind resd 256
    par_slice_stok resq 64             ; list<S>: the token of S, by entry
    par_gcoll_stok resq 256
    par_coll_stok  resq 1              ; S of the next entry made / last found
    par_fi_stok    resq 1              ; for x in l, l a list<S>: S
    par_last_coll_stok resq 1          ; list<S> just parsed: S, else 0
    ; Every declaration of a list<S>: its name token and S. Codegen looks a
    ; list up here to copy structs in and out of it.
    par_ls_decl    resq 8192
    par_ls_type    resq 8192
    par_ls_n       resd 1
    par_gcoll_n  resd 1
    par_in_fn    resd 1                ; 1 while a function is being parsed
    par_decl_typed resd 1              ; the declaration being parsed named a type
    par_multi    resd 1                ; results of the function being parsed
    par_extern_mode resd 1             ; 1 while the parameters of an extern fn are read
    par_variadic resd 1                ; the extern fn just read ends in ...
    par_lam_n    resd 1                ; functions written as values
    par_lam_toks resb 24 * 4096        ; their names, __lambda_N
    par_lam_names resb 16 * 4096
    mt_first_float resq 1
    mt_first_uns resq 1
    par_for_n    resd 1                ; hidden counters made for 'for x in l'
    par_for_toks resb 24 * 4096        ; their tokens
    par_for_names resb 16 * 4096       ; and names: __for_N
    par_fnvt_toks resq 2048            ; functions that return a text, list<T>
    par_fnvt_tags resd 2048            ; or map<T>, and the tag, for
    par_fnvt_n   resd 1                ; 'var x = f()' to take it over
    par_last_vtag resq 1               ; type tag of the type just parsed:
                                       ; bits 0-3 1 text, 2 list, 3 map;
                                       ; bits 4-7 the element: 0 integer,
                                       ; 1 text, 2 real
    par_used_slice resd 1              ; some v[i] was turned into a slice call
    par_used_text resd 1               ; the type text appeared
    par_used_list resd 1               ; list<T> appeared
    par_used_map resd 1                ; map<T> appeared
                                ; gave up; 0 when nothing specific
    pending_ret_float resw 1
    par_ast_buf     resq 1
    par_arena_ptr   resq 1
    par_arena_end   resq 1
    par_arn_tail    resq 1           ; tail of the heap_arena_definition chain
    par_mmu_tail    resq 1           ; tail of the other mmu sub-block chain
    par_pool_tail   resq 1           ; tail of the pool directive chain
    par_pool_node   resq 1           ; AST_POOL_DIR being built
    par_pool_kind   resq 1           ; which directive it is
    par_boot_tail   resq 1           ; tail of the mmu_table_init chain
    par_hdr_phase   resq 1           ; 1 while inside the imports block
    par_ast_root    resq 1

section .text
    global jup_parser_init
    global jup_parser_run
    global par_used_slice
    global par_ps_decl
    global par_ps_type
    global par_ps_n
    global par_ls_decl
    global par_ls_type
    global par_ls_n
    global par_used_text
    global par_used_list
    global par_used_map
    global parser_get_error
    global parser_get_error_token
    global parser_get_error_line
    global parser_get_error_col
    global parser_get_expected
    global parser_get_error_len
    global token_name
extern lexer_keyword_name
extern arg_input, src_buffer, lmap_out, lmap_file, lmap_count
    global parser_get_position
    global parser_get_ast_root

; ==============================================================================
; jup_parser_init(rdi=tokens, rsi=token_count, rdx=ast_buf, rcx=ast_size)
; ==============================================================================
jup_parser_init:
    mov  [rel par_tokens],      rdi
    mov  [rel par_token_count], rsi
    mov  [rel par_ast_buf],     rdx
    mov  [rel par_arena_ptr],   rdx
    add  rcx, rdx
    mov  [rel par_arena_end],   rcx
    xor  rax, rax
    mov  [rel par_pos],         rax
    mov  [rel par_ast_root],    rax
    mov  rax, 1
    ret

; ==============================================================================
; ast_alloc(rdi = node_type) -> rax = pointer to the node (or 0 when out of memory)
; Clears the 56 bytes and sets node_type. Only clobbers rax, rcx.
; ==============================================================================
ast_alloc:
    mov  rax, [rel par_arena_ptr]
    lea  rcx, [rax + AST_NODE_SIZE]
    cmp  rcx, [rel par_arena_end]
    ja   .oom
    mov  [rel par_arena_ptr], rcx
    mov  qword [rax + 0], 0
    mov  qword [rax + 8], 0
    mov  qword [rax + 16], 0
    mov  qword [rax + 24], 0
    mov  qword [rax + 32], 0
    mov  qword [rax + 40], 0
    mov  qword [rax + 48], 0
    mov  [rax + AST.node_type], rdi
    ; the line of the token being read: what a failure trace names
    mov  rcx, [rel par_pos]
    cmp  rcx, [rel par_token_count]
    jge  .no_line
    imul rcx, TOKEN_SIZE
    add  rcx, [rel par_tokens]
    movzx ecx, word [rcx + TOKEN.line]
    mov  [rax + AST.line], cx
.no_line:
    ret
.oom:
    xor  rax, rax
    ret

; ==============================================================================
; Slices. The parser remembers which names in the current function were
; declared slice<T>, and turns v[i] into slice_get(v, i) and v[i] = x into
; slice_set(v, i, x). The semantic pass and codegen then see plain calls.
; ==============================================================================

; par_slice_add(rdi = name token). Past 64 in one function the rest are not
; remembered, and their v[i] fall back to an ordinary index.
par_slice_add:
    push rsi
    mov  qword [rel par_coll_stok], 0
    xor  esi, esi                    ; kind 0: a slice
    cmp  qword [rel par_last_is_slice], 2
    jne  .ps_int
    mov  esi, 5                      ; kind 5: a slice of reals
.ps_int:
    call par_coll_add
    pop  rsi
    ret

; par_coll_add(rdi = name token, esi = kind | element tag << 8): a name whose
; v[i] becomes a call. Inside a function it is a local; outside, a global.
par_coll_add:
    push rax
    push rcx
    cmp  dword [rel par_in_fn], 0
    je   .ca_global
    mov  eax, [rel par_slice_n]
    cmp  eax, 64
    jae  .sa_out
    lea  rcx, [rel par_slice_toks]
    mov  [rcx + rax*8], rdi
    lea  rcx, [rel par_slice_kind]
    mov  [rcx + rax*4], esi
    lea  rcx, [rel par_slice_stok]
    push rdx
    mov  rdx, [rel par_coll_stok]
    mov  [rcx + rax*8], rdx
    pop  rdx
    inc  eax
    mov  [rel par_slice_n], eax
    jmp  .sa_out
.ca_global:
    mov  eax, [rel par_gcoll_n]
    cmp  eax, 256
    jae  .sa_out
    lea  rcx, [rel par_gcoll_toks]
    mov  [rcx + rax*8], rdi
    lea  rcx, [rel par_gcoll_kind]
    mov  [rcx + rax*4], esi
    lea  rcx, [rel par_gcoll_stok]
    push rdx
    mov  rdx, [rel par_coll_stok]
    mov  [rcx + rax*8], rdx
    pop  rdx
    inc  eax
    mov  [rel par_gcoll_n], eax
.sa_out:
    pop  rcx
    pop  rax
    ret

; par_coll_of_vtag(): after a declaration, a list<T> or map<T> name is
; remembered like a slice. rdi = name token. Preserves every register.
par_coll_of_vtag:
    push rax
    push rsi
    mov  rax, [rel par_last_vtag]
    mov  esi, eax
    and  esi, 15
    cmp  esi, 2
    je   .cv_list
    cmp  esi, 3
    je   .cv_map
    jmp  .cv_out
.cv_list:
    mov  esi, 1
    jmp  .cv_elem
.cv_map:
    mov  esi, 3
.cv_elem:
    ; element: 2 real picks the _real calls, 1 text tags the read
    mov  qword [rel par_coll_stok], 0
    shr  eax, 4
    and  eax, 15
    cmp  eax, 2
    jne  .cv_notreal
    inc  esi
    jmp  .cv_add
.cv_notreal:
    ; 3: a list<S> with S a name
    cmp  eax, 3
    jne  .cv_notnamed
    cmp  esi, 1
    jne  .cv_mapnamed
    mov  esi, 6
    mov  rax, [rel par_last_coll_stok]
    mov  [rel par_coll_stok], rax
    push rcx
    push rdx
    mov  ecx, [rel par_ls_n]
    cmp  ecx, 8192
    jae  .cv_lsfull
    lea  rdx, [rel par_ls_decl]
    mov  [rdx + rcx*8], rdi
    lea  rdx, [rel par_ls_type]
    mov  [rdx + rcx*8], rax
    inc  ecx
    mov  [rel par_ls_n], ecx
.cv_lsfull:
    pop  rdx
    pop  rcx
    jmp  .cv_add
.cv_mapnamed:
    xor  eax, eax                    ; a map<S>: integers, as before
.cv_notnamed:
    shl  eax, 8
    or   esi, eax
.cv_add:
    call par_coll_add
.cv_out:
    pop  rsi
    pop  rax
    ret

; ==============================================================================
; parse_for_in() -> rax = the statement, or 0. At 'x' of  for x in l { BODY }
; with l a list<T>. It becomes
;     { var __for_N = 0;
;       while __for_N < list_len(l) {  var x = l[__for_N];  BODY  }
;       step: __for_N = __for_N + 1 }
; so continue moves on to the next element, as in a counted for.
; ==============================================================================
parse_for_in:
    push r12
    push r13
    push r14
    push r15
    push rbx
    call par_current_token
    mov  r12, rax                    ; x
    call par_advance                 ; x
    call par_advance                 ; in
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .fi_err
    call par_current_token
    mov  r13, rax                    ; l
    mov  rdi, rax
    call par_is_slice
    mov  ebx, eax                    ; what l[i] turns into
    mov  ecx, eax
    and  ecx, 255
    cmp  ecx, 7                      ; 1 + kind 6: a list<S>
    je   .fi_islist
    cmp  ecx, 2                      ; 1 + kind: a list or a list of reals
    jb   .fi_notlist
    cmp  ecx, 3
    ja   .fi_notlist
.fi_islist:
    mov  rax, [rel par_coll_stok]
    mov  [rel par_fi_stok], rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .fi_err
    ; the hidden counter: a token of its own, __for_N
    mov  eax, [rel par_for_n]
    cmp  eax, 4096
    jae  .fi_err
    inc  dword [rel par_for_n]
    mov  ecx, eax
    shl  ecx, 4
    lea  rdi, [rel par_for_names]
    add  rdi, rcx                    ; the name
    mov  dword [rdi], '__fo'
    mov  byte [rdi + 4], 'r'
    mov  byte [rdi + 5], '_'
    ; the number, four digits
    mov  edx, eax
    mov  r8d, 4
    lea  r9, [rdi + 9]
.fi_dig:
    mov  eax, edx
    xor  edx, edx
    mov  ecx, 10
    div  ecx
    add  dl, '0'
    mov  [r9], dl
    dec  r9
    mov  edx, eax
    dec  r8d
    jnz  .fi_dig
    mov  r14, rdi                    ; name bytes
    mov  eax, [rel par_for_n]
    dec  eax
    imul eax, TOKEN_SIZE
    lea  r15, [rel par_for_toks]
    add  r15, rax                    ; the token
    mov  qword [r15 + TOKEN.type], TOK_IDENT
    mov  [r15 + TOKEN.value], r14
    mov  dword [r15 + TOKEN.length], 10
    mov  rax, [r12 + TOKEN.line]
    mov  [r15 + TOKEN.line], ax
    mov  word [r15 + TOKEN.col], 0
    ; the body, with x declared at its top
    call parse_block_ast
    test rax, rax
    jz   .fi_err
    push rax                         ; [rsp] = body
    ; x = l[__for_N], through the same call l[i] becomes
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.data], r15
    push rax
    mov  rdi, AST_INDEX
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  rdi, rax
    mov  esi, ebx
    call par_slice_get_call
    test rax, rax
    jz   .fi_err1
    push rax                         ; the read
    mov  rdi, AST_VAR_DECL
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.data], r12
    mov  [rax + AST.right], rcx
    ; a list<S>: x is declared an S
    mov  ecx, ebx
    and  ecx, 255
    cmp  ecx, 7
    jne  .fi_notnamed
    mov  rcx, [rel par_fi_stok]
    mov  [rax + AST.left], rcx
.fi_notnamed:
    ; x's flags: a real for a list<f64>, the element's tag otherwise
    mov  edx, ebx
    and  edx, 0xFF00                 ; tag << 8
    or   edx, 8                      ; typed: the tag is all it is
    mov  ecx, ebx
    and  ecx, 255
    cmp  ecx, 3                      ; 1 + kind 2: a list of reals
    jne  .fi_notreal
    or   edx, 1
.fi_notreal:
    mov  [rax + AST.col], dx
    push rax
    mov  rdi, AST_BLOCK
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.left], rcx
    pop  rcx                         ; body
    mov  [rax + AST.right], rcx      ; declaration, then the body
    mov  r14, rax                    ; the loop's block
    ; condition: __for_N < list_len(l)
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.data], r13
    push rax
    mov  rdi, AST_ARG
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.left], rcx
    push rax
    mov  rdi, AST_CALL
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.right], rcx
    lea  rcx, [rel tok_list_len]
    mov  [rax + AST.data], rcx
    push rax
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.data], r15
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    pop  rcx                         ; __for_N
    pop  rdx                         ; list_len(l)
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.left], rcx
    mov  [rax + AST.right], rdx
    mov  qword [rax + AST.data], TOK_LT
    push rax                         ; condition
    ; step: __for_N = __for_N + 1
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.data], r15
    push rax
    mov  rdi, AST_INTEGER_LIT
    call ast_alloc
    test rax, rax
    jz   .fi_err2
    lea  rcx, [rel tok_one]
    mov  [rax + AST.data], rcx
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    pop  rdx                         ; 1
    pop  rcx                         ; __for_N
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.left], rcx
    mov  [rax + AST.right], rdx
    mov  qword [rax + AST.data], TOK_PLUS
    push rax
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    test rax, rax
    jz   .fi_err2
    mov  [rax + AST.data], r15
    push rax
    mov  rdi, AST_ASSIGN
    call ast_alloc
    pop  rcx                         ; target
    pop  rdx                         ; value
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.left], rcx
    mov  [rax + AST.right], rdx
    push rax                         ; step
    mov  rdi, AST_WHILE
    call ast_alloc
    pop  rcx                         ; step
    pop  rdx                         ; condition
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.left], rcx
    mov  [rax + AST.data], rdx
    mov  [rax + AST.right], r14
    push rax                         ; the loop
    ; var __for_N = 0, then the loop
    mov  rdi, AST_INTEGER_LIT
    call ast_alloc
    test rax, rax
    jz   .fi_err1
    lea  rcx, [rel tok_zero]
    mov  [rax + AST.data], rcx
    push rax
    mov  rdi, AST_VAR_DECL
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .fi_err1
    mov  [rax + AST.data], r15
    mov  [rax + AST.right], rcx
    mov  word [rax + AST.col], 8
    push rax
    mov  rdi, AST_BLOCK
    call ast_alloc
    pop  rcx                         ; the counter
    pop  rdx                         ; the loop
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.left], rcx
    push rax
    push rdx
    mov  rdi, AST_BLOCK
    call ast_alloc
    pop  rdx
    pop  rcx
    test rax, rax
    jz   .fi_err
    mov  [rax + AST.left], rdx
    mov  [rcx + AST.right], rax
    mov  rax, rcx
    jmp  .fi_out
.fi_notlist:
    lea  rax, [rel msg_for_in]
    mov  [rel par_custom_msg], rax
    jmp  .fi_err
.fi_err2:
    pop  rcx
.fi_err1:
    pop  rcx
.fi_err:
    xor  eax, eax
.fi_out:
    pop  rbx
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_multi_type() -> rax = 1/0. At '(' of  -> (T1, T2, ...)  up to four.
; par_multi = count | floats << 4 | tags << 8: bit 4+i says result i is a
; real; bits 8+4i..11+4i its type tag squeezed into four bits (kind 0-3,
; element 0-2 << 2). The first type stays as the one just parsed, so a
; single use of the call sees an ordinary result.
; ==============================================================================
parse_multi_type:
    push rbx
    push r12
    push r13
    call par_advance                 ; '('
    xor  ebx, ebx                    ; count
    xor  r12d, r12d                  ; the packed description
.mt_loop:
    cmp  ebx, 4
    jae  .mt_err
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    call parse_type
    test rax, rax
    jz   .mt_err
    test ebx, ebx
    jnz  .mt_not_first
    ; the first: its flags are what a single use reads
    mov  rax, [rel par_last_is_float]
    push rax
    mov  rax, [rel par_last_is_unsigned]
    push rax
    mov  rax, [rel par_last_vtag]
    mov  r13, rax
    pop  rax
    mov  [rel mt_first_uns], rax
    pop  rax
    mov  [rel mt_first_float], rax
.mt_not_first:
    cmp  qword [rel par_last_is_float], 0
    je   .mt_tag
    mov  eax, 16
    mov  ecx, ebx
    shl  eax, cl
    or   r12d, eax
.mt_tag:
    mov  rax, [rel par_last_vtag]
    mov  ecx, eax
    and  ecx, 3                      ; kind 1..3
    shr  eax, 4
    and  eax, 3                      ; element 0..2
    shl  eax, 2
    or   eax, ecx
    mov  ecx, ebx
    shl  ecx, 2
    add  ecx, 8
    shl  eax, cl
    or   r12d, eax
    inc  ebx
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .mt_close
    call par_advance
    jmp  .mt_loop
.mt_close:
    cmp  rax, TOK_RPAREN
    jne  .mt_err
    call par_advance
    or   r12d, ebx
    cmp  ebx, 1
    jbe  .mt_one
    mov  [rel par_multi], r12d
.mt_one:
    mov  rax, [rel mt_first_float]
    mov  [rel par_last_is_float], rax
    mov  rax, [rel mt_first_uns]
    mov  [rel par_last_is_unsigned], rax
    mov  [rel par_last_vtag], r13
    mov  eax, 1
    jmp  .mt_out
.mt_err:
    xor  eax, eax
.mt_out:
    pop  r13
    pop  r12
    pop  rbx
    ret

; ==============================================================================
; parse_multi_assign(rdi = first name token, esi = 1 for 'var') -> rax = the
; statement, or 0. At the ',' after the first name of  a, b = f();
; The targets are names, '_' for a result nobody wants. With 'var' each name
; is declared first, and the whole comes back as a BLOCK_SPLICE chain:
;   var a; var b; AST_MULTI(a, b <- f())
; ==============================================================================
parse_multi_assign:
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov  r15d, esi                   ; declare?
    xor  r12, r12                    ; targets: head
    xor  r13, r13                    ;          tail
    xor  r14, r14                    ; declarations: head of the splice chain
    xor  rbx, rbx                    ;               its tail
    jmp  .ma_name
.ma_next:
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .ma_err
    call par_current_token
    mov  rdi, rax
    call par_advance
.ma_name:
    ; rdi = this name. '_' keeps no value.
    push rdi
    mov  rdi, AST_ARG
    call ast_alloc
    pop  rdi
    test rax, rax
    jz   .ma_err
    test r13, r13
    jz   .ma_head
    mov  [r13 + AST.right], rax
    jmp  .ma_linked
.ma_head:
    mov  r12, rax
.ma_linked:
    mov  r13, rax
    cmp  dword [rdi + TOKEN.length], 1
    jne  .ma_real
    mov  rcx, [rdi + TOKEN.value]
    cmp  byte [rcx], '_'
    je   .ma_after
.ma_real:
    push rdi
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    pop  rdi
    test rax, rax
    jz   .ma_err
    mov  [rax + AST.data], rdi
    mov  [r13 + AST.left], rax
    test r15d, r15d
    jz   .ma_after
    ; var NAME; -- typed by codegen from the function's results
    push rdi
    mov  rdi, AST_VAR_DECL
    call ast_alloc
    pop  rdi
    test rax, rax
    jz   .ma_err
    mov  [rax + AST.data], rdi
    call .ma_chain
.ma_after:
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .ma_eq
    call par_advance
    jmp  .ma_next
.ma_eq:
    mov  qword [rel par_expected], TOK_ASSIGN
    cmp  rax, TOK_ASSIGN
    jne  .ma_err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .ma_err
    cmp  qword [rax + AST.node_type], AST_CALL
    jne  .ma_notcall
    push rax
    call par_cur_type
    pop  rcx
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .ma_err
    push rcx
    call par_advance
    mov  rdi, AST_MULTI
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .ma_err
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r15
    test r15d, r15d
    jz   .ma_out                     ; a, b = f(): one statement
    cmp  dword [rel par_in_fn], 0
    je   .ma_global
    call .ma_chain
    mov  rax, r14
    mov  qword [rax + AST.type_info], BLOCK_SPLICE
    jmp  .ma_out
.ma_global:
    lea  rax, [rel msg_multi_global]
    mov  [rel par_custom_msg], rax
    jmp  .ma_err
.ma_notcall:
    lea  rax, [rel msg_multi_call]
    mov  [rel par_custom_msg], rax
.ma_err:
    xor  eax, eax
.ma_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret
; rax = a statement for the splice chain (r14 head, rbx tail)
.ma_chain:
    push rax
    mov  rdi, AST_BLOCK
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .mc_out
    mov  [rax + AST.left], rcx
    test rbx, rbx
    jz   .mc_head
    mov  [rbx + AST.right], rax
    mov  rbx, rax
    ret
.mc_head:
    mov  r14, rax
    mov  rbx, rax
.mc_out:
    ret

; ==============================================================================
; parse_lambda_ast() -> rax = AST_LAMBDA, or 0. At 'fn' in an expression:
;     fn(x: i64, y: i64) -> i64 { return x + y + k; }
; A function written where a value goes. It keeps the values of the
; variables around it that it uses (k), as they are when the fn is made.
; ==============================================================================
parse_lambda_ast:
    push r12
    push r13
    push r14
    push r15
    ; the declaration this sits in reads the type just parsed after the
    ; value: the fn's own types must not leak into it
    mov  rax, [rel par_last_is_float]
    push rax
    mov  rax, [rel par_last_is_unsigned]
    push rax
    mov  rax, [rel par_last_vtag]
    push rax
    mov  rax, [rel par_last_array_len]
    push rax
    mov  rax, [rel par_last_ptr_elem]
    push rax
    mov  rax, [rel par_last_arr_elem]
    push rax
    mov  rax, [rel par_last_row_len]
    push rax
    mov  rax, [rel par_last_is_slice]
    push rax
    mov  eax, [rel par_decl_typed]
    push rax
    call .la_parse
    pop  rcx
    mov  [rel par_decl_typed], ecx
    pop  rcx
    mov  [rel par_last_is_slice], rcx
    pop  rcx
    mov  [rel par_last_row_len], rcx
    pop  rcx
    mov  [rel par_last_arr_elem], rcx
    pop  rcx
    mov  [rel par_last_ptr_elem], rcx
    pop  rcx
    mov  [rel par_last_array_len], rcx
    pop  rcx
    mov  [rel par_last_vtag], rcx
    pop  rcx
    mov  [rel par_last_is_unsigned], rcx
    pop  rcx
    mov  [rel par_last_is_float], rcx
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.la_parse:
    call par_advance                 ; 'fn'
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .la_err
    call parse_param_list
    cmp  rax, -1
    je   .la_err
    mov  r15, rax                    ; the parameters
    xor  r14d, r14d                  ; what it returns: flags as a function's
    call par_cur_type
    cmp  rax, TOK_ARROW
    jne  .la_body
    call par_advance
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    call parse_type
    test rax, rax
    jz   .la_err
    movzx ecx, word [rel par_last_is_float]
    and  ecx, 1
    movzx edx, word [rel par_last_is_unsigned]
    and  edx, 1
    shl  edx, 1
    or   ecx, edx
    mov  edx, ecx
    call par_vtag_col
    or   ecx, edx
    mov  r14d, ecx
.la_body:
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .la_err
    call parse_block_ast
    test rax, rax
    jz   .la_err
    mov  r13, rax
    ; its name, __lambda_N, a token of its own
    mov  eax, [rel par_lam_n]
    cmp  eax, 4096
    jae  .la_err
    inc  dword [rel par_lam_n]
    mov  ecx, eax
    shl  ecx, 4
    lea  rdi, [rel par_lam_names]
    add  rdi, rcx
    mov  dword [rdi], '__la'
    mov  dword [rdi + 4], 'mbda'
    mov  byte [rdi + 8], '_'
    mov  edx, eax
    mov  r8d, 4
    lea  r9, [rdi + 12]
.la_dig:
    mov  eax, edx
    xor  edx, edx
    mov  ecx, 10
    div  ecx
    add  dl, '0'
    mov  [r9], dl
    dec  r9
    mov  edx, eax
    dec  r8d
    jnz  .la_dig
    mov  r12, rdi
    mov  eax, [rel par_lam_n]
    dec  eax
    imul eax, TOKEN_SIZE
    lea  rcx, [rel par_lam_toks]
    add  rcx, rax
    mov  qword [rcx + TOKEN.type], TOK_IDENT
    mov  [rcx + TOKEN.value], r12
    mov  dword [rcx + TOKEN.length], 13
    mov  word [rcx + TOKEN.line], 0
    mov  word [rcx + TOKEN.col], 0
    push rcx
    mov  rdi, AST_LAMBDA
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .la_err
    mov  [rax + AST.data], rcx
    mov  [rax + AST.left], r15
    mov  [rax + AST.right], r13
    mov  [rax + AST.col], r14w
    ret
.la_err:
    xor  eax, eax
    ret

; par_infer_vtag(rdi = initial value of an untyped declaration): when it is
; a call to a function declared earlier with a text, list<T> or map<T>
; result, or an element read of a list<text>, that becomes the type just
; parsed. Preserves every register.
par_infer_vtag:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push r8
    push r9
    cmp  qword [rdi + AST.node_type], AST_CALL
    jne  .iv_out
    movzx eax, word [rdi + AST.col]
    shr  eax, 8
    test eax, eax
    jnz  .iv_set
    mov  rdi, [rdi + AST.data]
    test rdi, rdi
    jz   .iv_out
    xor  ebx, ebx
.iv_loop:
    cmp  ebx, [rel par_fnvt_n]
    jae  .iv_out
    lea  rcx, [rel par_fnvt_toks]
    mov  rsi, [rcx + rbx*8]
    mov  ecx, dword [rsi + TOKEN.length]
    cmp  ecx, dword [rdi + TOKEN.length]
    jne  .iv_next
    mov  r8, [rsi + TOKEN.value]
    mov  r9, [rdi + TOKEN.value]
.iv_cmp:
    test ecx, ecx
    jz   .iv_found
    mov  al, [r8]
    cmp  al, [r9]
    jne  .iv_next
    inc  r8
    inc  r9
    dec  ecx
    jmp  .iv_cmp
.iv_next:
    inc  ebx
    jmp  .iv_loop
.iv_found:
    lea  rcx, [rel par_fnvt_tags]
    mov  eax, [rcx + rbx*4]
.iv_set:
    mov  [rel par_last_vtag], rax
.iv_out:
    pop  r9
    pop  r8
    pop  rdi
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    pop  rax
    ret

; par_vtag_col() -> ecx = the type tag of the type just parsed, in the place
; it goes in AST.col (bits 8-15). Preserves every other register.
par_vtag_col:
    mov  rcx, [rel par_last_vtag]
    and  ecx, 255
    shl  ecx, 8
    ret

; par_is_slice(rdi = name token) -> eax = 0 when v[i] on that name is an
; ordinary index, else 1 + its kind | element tag << 8. A local hides a global.
par_is_slice:
    push rbx
    push rcx
    push rdx
    push rsi
    push r8
    push r9
    push r10
    push r11
    push r12
    lea  r10, [rel par_slice_toks]
    lea  r11, [rel par_slice_kind]
    mov  edx, [rel par_slice_n]
    xor  ebx, ebx
    jmp  .is_loop
.is_globals:
    lea  r10, [rel par_gcoll_toks]
    lea  r11, [rel par_gcoll_kind]
    mov  edx, [rel par_gcoll_n]
    xor  ebx, ebx
    mov  r12, 1
    jmp  .is_loop2
.is_loop:
    xor  r12, r12                    ; 0 while the locals are searched
.is_loop2:
    cmp  ebx, edx
    jae  .is_end
    mov  rsi, [r10 + rbx*8]
    mov  ecx, dword [rsi + TOKEN.length]
    cmp  ecx, dword [rdi + TOKEN.length]
    jne  .is_next
    mov  r8, [rsi + TOKEN.value]
    mov  r9, [rdi + TOKEN.value]
.is_cmp:
    test ecx, ecx
    jz   .is_yes
    mov  al, [r8]
    cmp  al, [r9]
    jne  .is_next
    inc  r8
    inc  r9
    dec  ecx
    jmp  .is_cmp
.is_next:
    inc  ebx
    jmp  .is_loop2
.is_end:
    test r12, r12
    jz   .is_globals
    jmp  .is_no
.is_yes:
    lea  rax, [rel par_slice_stok]
    test r12, r12
    jz   .is_stok
    lea  rax, [rel par_gcoll_stok]
.is_stok:
    mov  rax, [rax + rbx*8]
    mov  [rel par_coll_stok], rax
    mov  eax, [r11 + rbx*4]
    mov  ecx, eax
    and  ecx, 255
    inc  ecx
    and  eax, 0xFF00
    or   eax, ecx
    jmp  .is_out
.is_no:
    xor  eax, eax
.is_out:
    pop  r12
    pop  r11
    pop  r10
    pop  r9
    pop  r8
    pop  rsi
    pop  rdx
    pop  rcx
    pop  rbx
    ret

; par_slice_get_call(rdi = the AST_INDEX of v[i], esi = what par_is_slice
; said) -> rax = the call slice_get(v, i), list_get(v, i)... marked with
; SLICE_GET_MARK + kind so an assignment can spot it and pick the setter.
par_slice_get_call:
    push r12
    push r13
    push r14
    mov  r14d, esi
    mov  r12, rdi
    mov  rdi, AST_ARG                ; second argument: the index
    call ast_alloc
    test rax, rax
    jz   .sg_fail
    mov  rcx, [r12 + AST.right]
    mov  [rax + AST.left], rcx
    mov  r13, rax
    mov  rdi, AST_IDENTIFIER         ; first argument: the slice itself
    call ast_alloc
    test rax, rax
    jz   .sg_fail
    mov  rcx, [r12 + AST.data]
    mov  [rax + AST.data], rcx
    push rax
    mov  rdi, AST_ARG
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .sg_fail
    mov  [rax + AST.left], rcx
    mov  [rax + AST.right], r13
    mov  r13, rax
    mov  rdi, AST_CALL
    call ast_alloc
    test rax, rax
    jz   .sg_fail
    mov  ecx, r14d
    and  ecx, 255
    dec  ecx                         ; the kind
    lea  rdx, [rel coll_get_toks]
    mov  rdx, [rdx + rcx*8]
    mov  [rax + AST.data], rdx
    mov  [rax + AST.right], r13
    mov  rdx, SLICE_GET_MARK
    add  rdx, rcx
    mov  [rax + AST.owner_type], rdx
    ; the element's type tag rides in AST.col: a list<text> read prints as text
    mov  edx, r14d
    and  edx, 0xFF00
    mov  [rax + AST.col], dx
    test ecx, ecx
    jz   .sg_slice
    cmp  ecx, 5
    jne  .sg_out
.sg_slice:
    mov  dword [rel par_used_slice], 1
    jmp  .sg_out
.sg_fail:
    xor  eax, eax
.sg_out:
    pop  r14
    pop  r13
    pop  r12
    ret

; par_make_assign(rdi = target, rsi = value) -> rax = the statement.
; An ordinary target gives AST_ASSIGN. A slice element -- a call carrying
; SLICE_GET_MARK -- gives a NEW call slice_set(v, i, value): the read node is
; left alone, because a compound assignment reuses it on the right-hand side.
par_make_assign:
    push r12
    push r13
    mov  r12, rdi
    mov  r13, rsi
    cmp  qword [r12 + AST.node_type], AST_CALL
    jne  .ma_plain
    mov  rax, [r12 + AST.owner_type]
    sub  rax, SLICE_GET_MARK
    cmp  rax, 6
    ja   .ma_plain                   ; unsigned: below the mark wraps high
    mov  rdi, AST_ARG                ; third argument: the value
    call ast_alloc
    test rax, rax
    jz   .ma_fail
    mov  [rax + AST.left], r13
    push rax
    mov  rdi, AST_ARG                ; second: the index, from the read
    call ast_alloc
    test rax, rax
    jz   .ma_fail_pop
    mov  rcx, [r12 + AST.right]
    mov  rcx, [rcx + AST.right]
    mov  rcx, [rcx + AST.left]
    mov  [rax + AST.left], rcx
    pop  rcx
    mov  [rax + AST.right], rcx
    push rax
    mov  rdi, AST_ARG                ; first: the slice, from the read
    call ast_alloc
    test rax, rax
    jz   .ma_fail_pop
    mov  rcx, [r12 + AST.right]
    mov  rcx, [rcx + AST.left]
    mov  [rax + AST.left], rcx
    pop  rcx
    mov  [rax + AST.right], rcx
    push rax
    mov  rdi, AST_CALL
    call ast_alloc
    test rax, rax
    jz   .ma_fail_pop
    pop  rcx
    mov  [rax + AST.right], rcx
    mov  rcx, [r12 + AST.owner_type]
    sub  rcx, SLICE_GET_MARK
    lea  rdx, [rel coll_set_toks]
    mov  rcx, [rdx + rcx*8]
    mov  [rax + AST.data], rcx
    jmp  .ma_out
.ma_plain:
    mov  rdi, AST_ASSIGN
    call ast_alloc
    test rax, rax
    jz   .ma_out
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], r13
    jmp  .ma_out
.ma_fail_pop:
    pop  rcx
.ma_fail:
    xor  eax, eax
.ma_out:
    pop  r13
    pop  r12
    ret

; ==============================================================================
; par_current_token() -> rax = pointer to the current token (or eof_token)
; ==============================================================================
par_current_token:
    mov  rax, [rel par_pos]
    mov  rcx, [rel par_token_count]
    cmp  rax, rcx
    jl   .valid
    lea  rax, [rel eof_token]
    ret
.valid:
    mov  rcx, [rel par_tokens]
    imul rax, TOKEN_SIZE
    add  rax, rcx
    ret

eof_token:
    dq   TOK_EOF
    dq   0
    dd   0
    dw   0
    dw   0

; par_cur_type() -> rax = type of the current token
par_cur_type:
    call par_current_token
    mov  rax, [rax + TOKEN.type]
    ret

; par_peek_next_type() -> rax = type of the token AFTER the current one, or
; TOK_EOF at the end. One token of lookahead is all that is needed to tell
; 'Vec3{x: 1.0}' from 'Vec3{expr, ...}'.
; par_is_field_name(rax = token type) -> ZF clear when the token can name a
; struct field.
;
; After a '.' there is nothing a word could be except a field name, so every
; keyword is allowed there. Otherwise 'x.ptr', 'x.data', 'x.size' and 126
; other perfectly reasonable field names are rejected, while 'x.len' happens
; to work -- a trap with no way to see it coming.
;
; Punctuation and operators occupy 0..55; everything from 100 up is a word.
par_is_field_name:
    push rcx
    mov  rcx, rax
    xor  rax, rax                    ; assume not usable
    cmp  rcx, TOK_IDENT
    je   .yes
    cmp  rcx, 100
    jb   .out
.yes:
    mov  rax, 1
.out:
    test rax, rax                    ; caller reads ZF: set means no
    pop  rcx
    ret

par_peek_next_type:
    mov  rax, [rel par_pos]
    inc  rax
    mov  rcx, [rel par_token_count]
    cmp  rax, rcx
    jl   .pk_valid
    mov  rax, TOK_EOF
    ret
.pk_valid:
    mov  rcx, [rel par_tokens]
    imul rax, TOKEN_SIZE
    add  rax, rcx
    mov  rax, [rax + TOKEN.type]
    ret

par_advance:
    mov  rax, [rel par_pos]
    inc  rax
    mov  [rel par_pos], rax
    ret

; ==============================================================================
; jup_parser_run() -> rax = 1 OK, 0 error.  Builds PROGRAM in par_ast_root.
; ==============================================================================
jup_parser_run:
    push r12
    push r13
    push r14
    xor  rax, rax
    mov  [rel par_pos], rax

    ; generics and module names first: a pass over the tokens (ng_run)
    mov  rdi, [rel par_tokens]
    mov  rsi, [rel par_token_count]
    call ng_run
    test rax, rax
    jnz  .ng_ok
    ; the error is about a token that may be one of the pass's own copies:
    ; it is put first, where the error report looks
    mov  rsi, [rel ng_err_tok]
    test rsi, rsi
    jz   .ng_msg
    mov  rdi, [rel par_tokens]
    mov  rcx, [rsi]
    mov  [rdi], rcx
    mov  rcx, [rsi + 8]
    mov  [rdi + 8], rcx
    mov  rcx, [rsi + 16]
    mov  [rdi + 16], rcx
.ng_msg:
    mov  rax, [rel ng_err_msg]
    mov  [rel par_custom_msg], rax
    jmp  .err
.ng_ok:
    mov  [rel par_token_count], rax

    mov  rdi, AST_PROGRAM
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax                ; current PROGRAM node
    mov  [rel par_ast_root], rax

    ; --- module header (section 01 of the grammar) ---
    ;   kron_program
    ;   kron_domain path::to::module [epoch N] ;
    ; kron_imports      <acquire_domain ... already expanded by main>
    ;   kron_definitions
    call par_cur_type
    mov  qword [rel par_expected], KW_KRON_PROGRAM
    cmp  rax, KW_KRON_PROGRAM
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], KW_KRON_DOMAIN
    cmp  rax, KW_KRON_DOMAIN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
.hdr_path:
    call par_cur_type
    cmp  rax, TOK_DOUBLE_COLON
    jne  .hdr_epoch
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    jmp  .hdr_path
.hdr_epoch:
    call par_cur_type
    cmp  rax, KW_EPOCH
    jne  .hdr_semi
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_NUMBER
    cmp  rax, TOK_NUMBER
    jne  .err
    call par_advance
.hdr_semi:
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], KW_KRON_IMPORTS
    cmp  rax, KW_KRON_IMPORTS
    jne  .err
    call par_advance
    ; The import preprocessor splices each imported file's body in place of
    ; its acquire_domain line, so declarations can appear between
    ; 'kron_imports' and 'kron_definitions'.  Parse them normally and
    ; treat 'kron_definitions' as the end of the imports block.
    mov  qword [rel par_hdr_phase], 1

.loop:
    call par_cur_type
    cmp  rax, TOK_EOF
    je   .at_eof
    cmp  qword [rel par_hdr_phase], 0
    je   .loop_parse
    cmp  rax, KW_KRON_DEFINITIONS
    jne  .loop_parse
    call par_advance
    mov  qword [rel par_hdr_phase], 0
    jmp  .loop
.loop_parse:
    call parse_top_level         ; -> rax = decl node (or 0)
    test rax, rax
    jz   .err
    mov  r14, rax                ; decl node
    cmp  qword [r13 + AST.left], 0
    jne  .newnode
    mov  [r13 + AST.left], r14
    jmp  .loop
.newnode:
    mov  rdi, AST_PROGRAM
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [r13 + AST.right], rax
    mov  r13, rax
    mov  [r13 + AST.left], r14
    jmp  .loop

.at_eof:
    ; 'kron_definitions' is mandatory; reaching EOF still inside the
    ; imports block means the header was never closed.
    cmp  qword [rel par_hdr_phase], 0
    jne  .err
.done:
    mov  rax, 1
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_top_level() -> rax = node (or 0)
; ==============================================================================
parse_top_level:
    call par_cur_type
    cmp  rax, TOK_KW_FN
    je   .fn
    cmp  rax, TOK_KW_VAR
    je   .global_var
    cmp  rax, TOK_KW_CONST
    je   .global_var
    cmp  rax, KW_SHARED
    je   .shared_var
    cmp  rax, KW_STRUCT
    je   .struct_def
    cmp  rax, KW_ENUM
    je   .enum_def
    cmp  rax, KW_KRON_ISA
    je   .isa
    cmp  rax, KW_BOOT_SEQUENCE
    je   .boot
    cmp  rax, KW_MMU_CONFIGURATION
    je   .mmu
    cmp  rax, KW_INTERRUPT_SERVICE
    je   .isr
    cmp  rax, KW_DMA_CHANNEL
    je   .cfg
    cmp  rax, KW_HARDWARE_DRIVER
    je   .cfg
    cmp  rax, KW_KERNEL_ARCHITECTURE
    je   .cfg
    cmp  rax, KW_SECURITY_MODEL
    je   .cfg
    cmp  rax, KW_FILESYSTEM_VOLUME
    je   .cfg
    cmp  rax, KW_NETWORK_KERNEL
    je   .cfg
    cmp  rax, KW_POWER_MANAGER
    je   .cfg
    cmp  rax, KW_KRON_HYPERVISOR
    je   .cfg
    cmp  rax, KW_PACKAGE_MANAGER
    je   .cfg
    cmp  rax, KW_EXECUTABLE_LOADER
    je   .cfg
    cmp  rax, KW_HUMAN_MACHINE
    je   .cfg
    cmp  rax, KW_KRON3D_CONTEXT
    je   .cfg
    ; --- structural models ---
    cmp  rax, KW_EXECUTION_MODEL
    je   .cfg
    cmp  rax, KW_DEPLOYMENT_MODEL
    je   .cfg
    cmp  rax, KW_SECURITY_RING
    je   .cfg
    cmp  rax, KW_SCHEDULER_DOMAIN
    je   .sched
    cmp  rax, KW_SYSCALL_DISPATCH
    je   .sys
    cmp  rax, KW_EXTERN
    je   .extern
    ; Generic TITAN module declaration: only a module keyword starts one.
    ; Anything else here -- a name, a statement, a stray '}' -- is code
    ; outside a function; taken as a module it swallowed every function
    ; after it, and the error came later as an 'unknown function'.
    cmp  rax, 200
    jb   .not_decl
    cmp  rax, 532
    jae  .not_decl
    ; Capture the module type keyword and the instance name.
    push r12
    push r13
    call par_current_token
    mov  r12, rax                ; module type token (keyword)
    call par_advance
    ; If the next token is an IDENT, it is the instance name.
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .no_name
    call par_current_token
    mov  r13, rax                ; name token
    call par_advance
    jmp  .rest
.no_name:
    xor  r13, r13
.rest:
    call parse_generic_decl      ; -> 1/0 (consumes the rest of the module)
    test rax, rax
    jz   .err_mod
    mov  rdi, AST_HARDWARE_BLOCK
    call ast_alloc
    test rax, rax
    jz   .err_mod
    mov  [rax + AST.data], r12   ; module type
    mov  [rax + AST.left], r13   ; instance name (or 0)
    pop  r13
    pop  r12
    ret
.err_mod:
    pop  r13
    pop  r12
    xor  rax, rax
    ret
.not_decl:
    lea  rax, [rel msg_not_decl]
    mov  [rel par_custom_msg], rax
    xor  eax, eax
    ret
.fn:
    call parse_function_ast
    ret
.global_var:
    ; a declaration at file scope becomes a global; reuse the statement parser
    call par_cur_type
    cmp  rax, TOK_KW_CONST
    je   .global_const
    call parse_statement_ast
    ret
.global_const:
    ; A constant cannot be written, so threads may read it: it carries the
    ; 'shared' mark (bit 2) for the thread check. Without it, a function
    ; running in a thread could not even use a named constant.
    call parse_statement_ast
    test rax, rax
    jz   .gc_out
    movzx ecx, word [rax + AST.col]
    mov  edx, 4
    or   ecx, edx
    mov  [rax + AST.col], cx
    jmp  .gc_out
.gc_out:
    ret
.shared_var:
    ; 'shared var x: T;' -- a global that code running in a thread may touch.
    ; Everything else stays out of reach of threads (the check is in codegen).
    ; Bit 2 of AST.col marks it; bits 0 and 1 are float and unsigned.
    call par_advance                 ; consume 'shared'
    call par_cur_type
    mov  qword [rel par_expected], TOK_KW_VAR
    cmp  rax, TOK_KW_VAR
    jne  .shared_err
    call parse_statement_ast
    test rax, rax
    jz   .shared_out
    movzx ecx, word [rax + AST.col]
    mov  edx, 4
    or   ecx, edx
    mov  [rax + AST.col], cx
.shared_out:
    ret
.shared_err:
    xor  eax, eax
    ret
.struct_def:
    call parse_struct_ast
    ret
.enum_def:
    call parse_enum_ast
    ret
.isa:
    call parse_isa_ast
    ret
.boot:
    call parse_boot_ast
    ret
.mmu:
    call parse_mmu_ast
    ret
.isr:
    call parse_isr_ast
    ret
.cfg:
    call parse_config_ast
    ret
.sched:
    call parse_sched_ast
    ret
.sys:
    call parse_sys_ast
    ret
.extern:
    call parse_extern_ast
    ret
.err:
    xor  rax, rax
    ret

; ==============================================================================
; M09 - parse_sys_ast() -> rax = AST_SYS_DEF node (or 0)
;   sovereign_dispatch_table IDENT '{'
;       dispatch_vector = HEX ;
;       param_register = IDENT ; ...
;       service N name handler { block }
;       on_invalid_service { block }
;   '}'
; ==============================================================================
parse_sys_ast:
    push r12
    push r13
    push r14
    push r15
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_SYS_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    xor  r14, r14

.body:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_IDENT
    jne  .skip
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]

    ; "service" (7) -> dispatch entry
    cmp  edx, 7
    jne  .try_par
    cmp  dword [rsi], 'serv'
    jne  .try_par
    cmp  dword [rsi+3], 'vice'
    jne  .try_par
    call par_advance
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .svc_num
    cmp  rax, TOK_NUMBER
    je   .svc_num
    jmp  .err
.svc_num:
    mov  rdi, AST_SYS_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax      ; service number
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  [r15 + AST.left], rax      ; service name
    call par_advance
    ; consume 'handler'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    ; handler block
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  [r15 + AST.right], rax
    test r14, r14
    jnz  .schain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .body
.schain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .body

.try_par:
    ; "mechanism = syscall_fast|int_vector" -> record the return mode
    cmp  edx, 9
    jne  .try_rest
    cmp  dword [rsi], 'mech'
    jne  .try_rest
    cmp  dword [rsi+5], 'nism'
    jne  .try_rest
    call par_advance
    call par_cur_type
    cmp  rax, TOK_ASSIGN
    jne  .body
    call par_advance
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .body
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 12
    jne  .mech_done
    cmp  dword [rsi], 'sysc'
    jne  .mech_done
    cmp  dword [rsi+4], 'all_'
    jne  .mech_done
    cmp  dword [rsi+8], 'fast'
    jne  .mech_done
    mov  qword [r13 + AST.type_info], 1   ; 1 = SYSCALL/SYSRET
.mech_done:
    call par_advance
    jmp  .body

.try_rest:
    ; rest: "param_register = X ;" or blocks -> consume
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .skipblk
    call par_advance
    jmp  .body
.skip:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .skipblk
    call par_advance
    jmp  .body
.skipblk:
    call parse_generic_block
    test rax, rax
    jz   .err
    jmp  .body

.close:
    call par_advance
    mov  rax, r13
    pop  r15; pop r14; pop r13; pop r12
    ret
.err:
    xor  rax, rax
    pop  r15; pop r14; pop r13; pop r12
    ret

; ==============================================================================
; M08 - parse_sched_ast() -> rax = AST_SCHED_DEF node (or 0)
;   scheduler_domain IDENT [policy X] '{'
; ( key = value ; )*
; task_switching { statements }       <- compiled to real code
;   '}'
; Same layout as AST_CFG_DEF (data=name, right=list) + left=block.
; ==============================================================================
parse_sched_ast:
    push r12
    push r13
    push r14
    push r15
    call par_advance                 ; consume 'scheduler_domain'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax
    call par_advance
.pre:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .open
    cmp  rax, TOK_EOF
    je   .err
    call par_advance                 ; 'policy', policy value, etc.
    jmp  .pre
.open:
    call par_advance
    mov  rdi, AST_SCHED_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    xor  r14, r14

.body:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_IDENT
    jne  .skip

    mov  rdi, AST_CFG_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax
    call par_advance
    call par_cur_type
    cmp  rax, TOK_ASSIGN
    jne  .maybe_block
    call par_advance
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .sval
    cmp  rax, TOK_NUMBER
    je   .sval
    cmp  rax, TOK_IDENT
    je   .sval
    cmp  rax, TOK_STRING
    je   .sval
    cmp  rax, KW_TRUE
    je   .sval
    cmp  rax, KW_FALSE
    je   .sval
    jmp  .err
.sval:
    mov  [r15 + AST.type_info], rax
    call par_current_token
    mov  [r15 + AST.left], rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    test r14, r14
    jnz  .schain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .body
.schain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .body

.maybe_block:
    ; the identifier opens a block: if there is no routine yet, capture it as code
    call par_cur_type
    cmp  rax, TOK_LBRACE
    jne  .body
    cmp  qword [r13 + AST.left], 0
    jne  .skipblk
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  [r13 + AST.left], rax
    jmp  .body

.skip:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .skipblk
    cmp  rax, TOK_LPAREN
    je   .skippar
    call par_advance
    jmp  .body
.skipblk:
    call parse_generic_block
    test rax, rax
    jz   .err
    jmp  .body
.skippar:
    call consume_balanced_parens
    test rax, rax
    jz   .err
    jmp  .body

.close:
    call par_advance
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_config_ast() -> rax = AST_CFG_DEF node (or 0)
; GENERIC capture for declarative modules:
;   <keyword> IDENT '{' ( IDENT '=' <value> ';' | nested_block )* '}'
; Nested blocks are entered and their pairs captured too. Reused by many modules.
; ==============================================================================
parse_config_ast:
    push r12
    push r13
    push r14
    push r15
    call par_current_token
    mov  r15, rax                    ; module type token
    call par_advance                 ; consume the module keyword
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_CFG_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    mov  [r13 + AST.left], r15       ; module type
    xor  r14, r14
    mov  qword [rel par_cfg_depth], 0

.body:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .maybe_close
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_IDENT
    jne  .skip

    ; possible "key = value ;" -> create tentative node
    mov  rdi, AST_CFG_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax       ; key
    call par_advance
    call par_cur_type
    cmp  rax, TOK_ASSIGN
    jne  .not_pair                   ; it was not a pair: carry on as block/skip
    call par_advance
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .cval
    cmp  rax, TOK_NUMBER
    je   .cval
    cmp  rax, TOK_IDENT
    je   .cval
    cmp  rax, TOK_STRING
    je   .cval
    cmp  rax, KW_TRUE
    je   .cval
    cmp  rax, KW_FALSE
    je   .cval
    jmp  .err
.cval:
    mov  [r15 + AST.type_info], rax  ; value type
    call par_current_token
    mov  [r15 + AST.left], rax       ; value
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    test r14, r14
    jnz  .cchain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .body
.cchain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .body

.not_pair:
    ; A block is CODE when its name starts with "on_" or when it carries a
    ; parameter list:  name(...) { }  ; otherwise it is a nested DATA block.
    call par_cur_type
    cmp  rax, TOK_LPAREN
    je   .h_params
    mov  rdi, [r15 + AST.data]
    mov  rsi, [rdi + TOKEN.value]
    mov  edx, dword [rdi + TOKEN.length]
    cmp  edx, 3
    jb   .np_data
    cmp  byte [rsi], 'o'
    jne  .np_data
    cmp  byte [rsi+1], 'n'
    jne  .np_data
    cmp  byte [rsi+2], '_'
    jne  .np_data
    jmp  .h_block
.h_params:
    call consume_balanced_parens
    test rax, rax
    jz   .err
.h_block:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    jne  .body
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  [r15 + AST.left], rax            ; handler body
    mov  qword [r15 + AST.type_info], CFG_HANDLER_MARK
    test r14, r14
    jnz  .h_chain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .body
.h_chain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .body

.np_data:
    ; the identifier opens a nested data block: ENTER and keep capturing
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .enter_block
    cmp  rax, TOK_LPAREN
    je   .skippar
    jmp  .body

.skip:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .enter_block
    cmp  rax, TOK_LPAREN
    je   .skippar
    call par_advance
    jmp  .body
.enter_block:
    call par_advance
    inc  qword [rel par_cfg_depth]
    jmp  .body
.maybe_close:
    cmp  qword [rel par_cfg_depth], 0
    je   .close
    dec  qword [rel par_cfg_depth]
    call par_advance
    jmp  .body
.skippar:
    call consume_balanced_parens
    test rax, rax
    jz   .err
    jmp  .body

.close:
    call par_advance
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; M04 - parse_isr_ast() -> rax = AST_ISR_DEF node (or 0)
;   interrupt_service_routine IDENT [vector_id HEX] [ring_context] '{' stmts '}'
; The body is captured as a real AST_BLOCK and compiled to x86 code.
; ==============================================================================
parse_isr_ast:
    push r12
    push r13
    push r14
    call par_advance                 ; consume 'interrupt_service_routine'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax                    ; ISR name
    call par_advance
    xor  r13, r13                    ; vector token (optional)

.pre:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .body
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_HEX
    je   .vec
    cmp  rax, TOK_NUMBER
    je   .vec
    call par_advance                 ; 'vector_id', ring context, etc.
    jmp  .pre
.vec:
    call par_current_token
    mov  r13, rax
    call par_advance
    jmp  .pre

.body:
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  r14, rax
    mov  rdi, AST_ISR_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r12
    mov  [rax + AST.left], r13
    mov  [rax + AST.right], r14
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; M03 - parse_mmu_ast() -> rax = AST_MMU_DEF node (or 0)
;   mmu_configuration IDENT '{' ... page_table_hierarchy { level N entries M ; } ... '}'
; ==============================================================================
; ------------------------------------------------------------------
; mmu_entry_push -- append the AST_MMU_ENTRY in r15 to the chain that
; hangs off AST.type_info of the enclosing AST_MMU_DEF in r13.
; Clobbers rcx only; r13 and r15 are left untouched.
; ------------------------------------------------------------------
; ------------------------------------------------------------------
; pool_dir_push -- append par_pool_node to the directive chain hanging
; off AST.left of the AST_MMU_ENTRY in r15.  r13 (the mmu node) and r14
; (the page-level tail) must not be touched, so the chain state lives in
; memory rather than in registers.
; ------------------------------------------------------------------
pool_dir_push:
    mov  rax, [rel par_pool_node]
    mov  qword [rax + AST.right], 0
    mov  rcx, [rel par_pool_tail]
    test rcx, rcx
    jnz  .link
    mov  [r15 + AST.left], rax
    mov  [rel par_pool_tail], rax
    ret
.link:
    mov  [rcx + AST.right], rax
    mov  [rel par_pool_tail], rax
    ret

mmu_entry_push:
    mov  qword [r15 + AST.right], 0
    mov  rcx, [rel par_mmu_tail]
    test rcx, rcx
    jnz  .link
    mov  [r13 + AST.type_info], r15
    mov  [rel par_mmu_tail], r15
    ret
.link:
    mov  [rcx + AST.right], r15
    mov  [rel par_mmu_tail], r15
    ret

parse_mmu_ast:
    push r12
    push r13
    push r14
    push r15
    call par_advance                 ; consume 'mmu_configuration'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_MMU_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    xor  r14, r14
    mov  qword [rel par_mmu_tail], 0

.body:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_IDENT
    jne  .skip
    ; identify "page_table_hierarchy" (20 chars)
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 20
    jne  .chk_arena
    cmp  dword [rsi], 'page'
    jne  .chk_arena
    cmp  dword [rsi+4], '_tab'
    jne  .chk_arena
    cmp  dword [rsi+8], 'le_h'
    jne  .chk_arena
    cmp  dword [rsi+12], 'iera'
    jne  .chk_arena
    cmp  dword [rsi+16], 'rchy'
    jne  .chk_arena
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance

.lvls:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .lvls_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance                 ; consume 'level'
    call par_cur_type
    cmp  rax, TOK_NUMBER
    je   .lv_ok
    cmp  rax, TOK_HEX
    je   .lv_ok
    jmp  .err
.lv_ok:
    mov  rdi, AST_MMU_LEVEL
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax       ; level number
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance                 ; consume 'entries'
    call par_cur_type
    cmp  rax, TOK_NUMBER
    je   .en_ok
    cmp  rax, TOK_HEX
    je   .en_ok
    jmp  .err
.en_ok:
    call par_current_token
    mov  [r15 + AST.left], rax       ; entry count
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    test r14, r14
    jnz  .mchain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .lvls
.mchain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .lvls

.lvls_end:
    call par_advance
    jmp  .body


; --- heap_arena_definition { arena N base_address H size_bytes S growth_policy P ; ... } ---
.chk_arena:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 21
    jne  .chk_cache
    cmp  dword [rsi], 'heap'
    jne  .chk_cache
    cmp  dword [rsi+4], '_are'
    jne  .chk_cache
    cmp  dword [rsi+8], 'na_d'
    jne  .chk_cache
    cmp  dword [rsi+12], 'efin'
    jne  .chk_cache
    cmp  dword [rsi+16], 'itio'
    jne  .chk_cache
    cmp  byte  [rsi+20], 'n'
    jne  .chk_cache
    call par_advance                 ; consume 'heap_arena_definition'
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  qword [rel par_arn_tail], 0
.arn_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .arn_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance                 ; consume 'arena'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_ARENA_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax       ; arena name
    call par_advance
    call par_cur_type                ; 'base_address'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .arn_base
    cmp  rax, TOK_NUMBER
    je   .arn_base
    jmp  .err
.arn_base:
    call par_current_token
    mov  [r15 + AST.left], rax       ; base address literal
    call par_advance
    call par_cur_type                ; 'size_bytes'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_NUMBER
    je   .arn_size
    cmp  rax, TOK_HEX
    je   .arn_size
    jmp  .err
.arn_size:
    call par_current_token
    mov  [r15 + AST.type_info], rax  ; size in bytes
    call par_advance
    call par_cur_type                ; 'growth_policy'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  edx, dword [rax + TOKEN.length]
    ; the four policy names have distinct lengths, so the length decides
    mov  ecx, ARENA_GROWTH_FIXED     ; fixed_static (12)
    cmp  edx, 12
    je   .arn_pol
    mov  ecx, ARENA_GROWTH_LINEAR    ; linear_page_stride (18)
    cmp  edx, 18
    je   .arn_pol
    mov  ecx, ARENA_GROWTH_DOUBLING  ; doubling_exponential (20)
    cmp  edx, 20
    je   .arn_pol
    mov  ecx, ARENA_GROWTH_LAZY      ; lazy_on_demand_commit (21)
    cmp  edx, 21
    je   .arn_pol
    jmp  .err
.arn_pol:
    mov  dword [r15 + AST.child_count], ecx
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rcx, [rel par_arn_tail]
    test rcx, rcx
    jnz  .arn_chain
    mov  [r13 + AST.left], r15       ; head of the arena chain
    mov  [rel par_arn_tail], r15
    jmp  .arn_loop
.arn_chain:
    mov  [rcx + AST.right], r15
    mov  [rel par_arn_tail], r15
    jmp  .arn_loop
.arn_end:
    call par_advance                 ; consume '}'
    jmp  .body


; --- cache_policy { range H policy write_back|write_through ; ... } ---
.chk_cache:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 12
    jne  .chk_numa
    cmp  dword [rsi], 'cach'
    jne  .chk_numa
    cmp  dword [rsi+4], 'e_po'
    jne  .chk_numa
    cmp  dword [rsi+8], 'licy'
    jne  .chk_numa
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
.cch_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .cch_end
    cmp  rax, TOK_EOF
    je   .err
    ; 'range' is already a keyword elsewhere in the language, so accept both
    ; the keyword and a plain identifier here.
    cmp  rax, KW_RANGE
    je   .cch_kw
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
.cch_kw:
    call par_advance                 ; consume 'range'
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .cch_val
    mov  qword [rel par_expected], TOK_NUMBER
    cmp  rax, TOK_NUMBER
    jne  .err
.cch_val:
    mov  rdi, AST_MMU_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    mov  dword [r15 + AST.child_count], MMU_ENTRY_CACHE
    call par_current_token
    mov  [r15 + AST.data], rax       ; range
    call par_advance
    call par_cur_type                ; 'policy'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  edx, dword [rax + TOKEN.length]
    ; write_back is 10 chars, write_through 13 -- the length decides
    mov  ecx, CACHE_WRITE_BACK
    cmp  edx, 10
    je   .cch_pol
    mov  ecx, CACHE_WRITE_THROUGH
    cmp  edx, 13
    jne  .err
.cch_pol:
    mov  [r15 + AST.left], rcx
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    call mmu_entry_push
    jmp  .cch_loop
.cch_end:
    call par_advance
    jmp  .body

; --- numa_node_affinity { node N cpu_mask H local_bandwidth_gbps N ; ... } ---
.chk_numa:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 18
    jne  .chk_gc
    cmp  dword [rsi], 'numa'
    jne  .chk_gc
    cmp  dword [rsi+4], '_nod'
    jne  .chk_gc
    cmp  dword [rsi+8], 'e_af'
    jne  .chk_gc
    cmp  dword [rsi+12], 'fini'
    jne  .chk_gc
    cmp  word  [rsi+16], 'ty'
    jne  .chk_gc
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
.numa_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .numa_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance                 ; consume 'node'
    call par_cur_type
    mov  qword [rel par_expected], TOK_NUMBER
    cmp  rax, TOK_NUMBER
    jne  .err
    mov  rdi, AST_MMU_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    mov  dword [r15 + AST.child_count], MMU_ENTRY_NUMA
    call par_current_token
    mov  [r15 + AST.data], rax       ; node number
    call par_advance
    call par_cur_type                ; 'cpu_mask'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .numa_mask
    mov  qword [rel par_expected], TOK_NUMBER
    cmp  rax, TOK_NUMBER
    jne  .err
.numa_mask:
    call par_current_token
    mov  [r15 + AST.left], rax       ; cpu mask
    call par_advance
    call par_cur_type                ; 'local_bandwidth_gbps'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_NUMBER
    cmp  rax, TOK_NUMBER
    jne  .err
    call par_current_token
    mov  [r15 + AST.type_info], rax  ; bandwidth
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    call mmu_entry_push
    jmp  .numa_loop
.numa_end:
    call par_advance
    jmp  .body

; --- garbage_collection_policy = POLICY ; ---
.chk_gc:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 25
    jne  .chk_pgf
    cmp  dword [rsi], 'garb'
    jne  .chk_pgf
    cmp  dword [rsi+4], 'age_'
    jne  .chk_pgf
    cmp  dword [rsi+8], 'coll'
    jne  .chk_pgf
    cmp  dword [rsi+12], 'ecti'
    jne  .chk_pgf
    cmp  dword [rsi+16], 'on_p'
    jne  .chk_pgf
    cmp  dword [rsi+20], 'olic'
    jne  .chk_pgf
    cmp  byte  [rsi+24], 'y'
    jne  .chk_pgf
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_ASSIGN
    cmp  rax, TOK_ASSIGN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  edx, dword [rax + TOKEN.length]
    ; manual_only 11, reference_counted 17, mark_sweep_deferred 19,
    ; generational_incremental 24 -- all four lengths differ
    mov  ecx, GC_MANUAL_ONLY
    cmp  edx, 11
    je   .gc_ok
    mov  ecx, GC_REF_COUNTED
    cmp  edx, 17
    je   .gc_ok
    mov  ecx, GC_MARK_SWEEP
    cmp  edx, 19
    je   .gc_ok
    mov  ecx, GC_GENERATIONAL
    cmp  edx, 24
    jne  .err
.gc_ok:
    mov  rdi, AST_MMU_ENTRY
    push rcx
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .err
    mov  r15, rax
    mov  dword [r15 + AST.child_count], MMU_ENTRY_GC
    mov  [r15 + AST.data], rcx
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    call mmu_entry_push
    jmp  .body


; --- on_page_fault ( error_code IDENT ) block ---
.chk_pgf:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 13
    jne  .chk_oom
    cmp  dword [rsi], 'on_p'
    jne  .chk_oom
    cmp  dword [rsi+4], 'age_'
    jne  .chk_oom
    cmp  dword [rsi+8], 'faul'
    jne  .chk_oom
    cmp  byte  [rsi+12], 't'
    jne  .chk_oom
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call par_cur_type                ; 'error_code'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type                ; the parameter name
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_MMU_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    mov  dword [r15 + AST.child_count], MMU_ENTRY_PGFAULT
    call par_current_token
    mov  [r15 + AST.data], rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  [r15 + AST.left], rax       ; handler body
    call mmu_entry_push
    jmp  .body

; --- on_out_of_memory_pressure block ---
.chk_oom:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 25
    jne  .chk_pool
    cmp  dword [rsi], 'on_o'
    jne  .chk_pool
    cmp  dword [rsi+4], 'ut_o'
    jne  .chk_pool
    cmp  dword [rsi+8], 'f_me'
    jne  .chk_pool
    cmp  dword [rsi+12], 'mory'
    jne  .chk_pool
    cmp  dword [rsi+16], '_pre'
    jne  .chk_pool
    cmp  dword [rsi+20], 'ssur'
    jne  .chk_pool
    cmp  byte  [rsi+24], 'e'
    jne  .chk_pool
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    mov  rdi, AST_MMU_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    mov  dword [r15 + AST.child_count], MMU_ENTRY_OOM
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  [r15 + AST.left], rax
    call mmu_entry_push
    jmp  .body


; --- dynamic_allocation_pool IDENT { allocator_class = X ; ... } ---
.chk_pool:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 23
    jne  .skip
    cmp  dword [rsi], 'dyna'
    jne  .skip
    cmp  dword [rsi+4], 'mic_'
    jne  .skip
    cmp  dword [rsi+8], 'allo'
    jne  .skip
    cmp  dword [rsi+12], 'cati'
    jne  .skip
    cmp  dword [rsi+16], 'on_p'
    jne  .skip
    cmp  word  [rsi+20], 'oo'
    jne  .skip
    cmp  byte  [rsi+22], 'l'
    jne  .skip
    call par_advance
    call par_cur_type                ; pool name
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_MMU_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    mov  dword [r15 + AST.child_count], MMU_ENTRY_POOL
    call par_current_token
    mov  [r15 + AST.data], rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  qword [rel par_pool_tail], 0
.pool_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .pool_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    ; the five directives all differ in length: 15, 32, 36, 21, 23
    cmp  edx, 15
    je   .pd_class
    cmp  edx, 32
    je   .pd_simple
    cmp  edx, 36
    je   .pd_simple
    cmp  edx, 21
    je   .pd_onalloc
    cmp  edx, 23
    je   .pd_onfree
    jmp  .err

; allocator_class = CLASS ;
.pd_class:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_ASSIGN
    cmp  rax, TOK_ASSIGN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  edx, dword [rax + TOKEN.length]
    mov  ecx, ALLOC_SLAB
    cmp  edx, 16
    je   .pd_cls_ok
    mov  ecx, ALLOC_BUMP
    cmp  edx, 17
    je   .pd_cls_ok
    mov  ecx, ALLOC_BUDDY
    cmp  edx, 19
    je   .pd_cls_ok
    mov  ecx, ALLOC_FREELIST
    cmp  edx, 20
    je   .pd_cls_ok
    mov  ecx, ALLOC_PREDICTIVE
    cmp  edx, 28
    jne  .err
.pd_cls_ok:
    push rcx
    mov  rdi, AST_POOL_DIR
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .err
    mov  [rel par_pool_node], rax
    mov  dword [rax + AST.child_count], POOL_DIR_CLASS
    mov  [rax + AST.data], rcx
    call par_advance
    jmp  .pd_semi

; fragmentation_compaction_trigger = F ;   /   minimum_allocation_granularity_bytes = N ;
.pd_simple:
    mov  qword [rel par_pool_kind], POOL_DIR_COMPACT
    cmp  edx, 32
    je   .pd_simple_go
    mov  qword [rel par_pool_kind], POOL_DIR_GRAN
.pd_simple_go:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_ASSIGN
    cmp  rax, TOK_ASSIGN
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_NUMBER
    je   .pd_simple_val
    cmp  rax, TOK_FLOAT
    je   .pd_simple_val
    mov  qword [rel par_expected], TOK_HEX
    cmp  rax, TOK_HEX
    jne  .err
.pd_simple_val:
    mov  rdi, AST_POOL_DIR
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rel par_pool_node], rax
    mov  rcx, [rel par_pool_kind]
    mov  dword [rax + AST.child_count], ecx
    push rax
    call par_current_token
    mov  rcx, rax
    pop  rax
    mov  [rax + AST.data], rcx
    call par_advance
    jmp  .pd_semi

; on_allocation_request ( size_bytes IDENT ) block
.pd_onalloc:
    mov  qword [rel par_pool_kind], POOL_DIR_ONALLOC
    jmp  .pd_handler
; on_deallocation_request ( pointer_handle IDENT ) block
.pd_onfree:
    mov  qword [rel par_pool_kind], POOL_DIR_ONFREE
.pd_handler:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call par_cur_type                ; 'size_bytes' / 'pointer_handle'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type                ; parameter name
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_POOL_DIR
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rel par_pool_node], rax
    mov  rcx, [rel par_pool_kind]
    mov  dword [rax + AST.child_count], ecx
    push rax
    call par_current_token
    mov  rcx, rax
    pop  rax
    mov  [rax + AST.data], rcx
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  rcx, [rel par_pool_node]
    mov  [rcx + AST.left], rax
    call pool_dir_push
    jmp  .pool_loop

.pd_semi:
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    call pool_dir_push
    jmp  .pool_loop
.pool_end:
    call par_advance                 ; consume '}'
    call mmu_entry_push
    jmp  .body

.skip:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .skipblk
    cmp  rax, TOK_LPAREN
    je   .skippar
    call par_advance
    jmp  .body
.skipblk:
    call parse_generic_block
    test rax, rax
    jz   .err
    jmp  .body
.skippar:
    call consume_balanced_parens
    test rax, rax
    jz   .err
    jmp  .body

.close:
    call par_advance
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; M02 - parse_boot_ast() -> rax = AST_BOOT_DEF node (or 0)
;   boot_sequence IDENT '{' ... cpu_state_init { register IDENT set HEX ; ... } ... '}'
; ==============================================================================
parse_boot_ast:
    push r12
    push r13
    push r14
    push r15
    call par_advance                 ; consume 'boot_sequence'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_BOOT_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    xor  r14, r14

.body:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_IDENT
    jne  .skip
    ; identify "cpu_state_init" (14 chars)
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 14
    jne  .chk_mmuinit
    cmp  dword [rsi], 'cpu_'
    jne  .chk_mmuinit
    cmp  dword [rsi+4], 'stat'
    jne  .chk_mmuinit
    cmp  dword [rsi+8], 'e_in'
    jne  .chk_mmuinit
    cmp  word [rsi+12], 'it'
    jne  .chk_mmuinit
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance

.regs:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .regs_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    ; 'register' IDENT 'set' HEX ';'
    call par_advance                 ; consume 'register'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_BOOT_REG
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax       ; register name
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance                 ; consume 'set'
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .bval
    cmp  rax, TOK_NUMBER
    je   .bval
    jmp  .err
.bval:
    call par_current_token
    mov  [r15 + AST.left], rax       ; value
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    test r14, r14
    jnz  .bchain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .regs
.bchain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .regs

.regs_end:
    call par_advance
    jmp  .body


; --- mmu_table_init { entry H flags F ; ... } ---
.chk_mmuinit:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 14
    jne  .chk_elf
    cmp  dword [rsi], 'mmu_'
    jne  .chk_elf
    cmp  dword [rsi+4], 'tabl'
    jne  .chk_elf
    cmp  dword [rsi+8], 'e_in'
    jne  .chk_elf
    cmp  word  [rsi+12], 'it'
    jne  .chk_elf
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  qword [rel par_boot_tail], 0
.mti_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .mti_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance                 ; consume 'entry'
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .mti_addr
    mov  qword [rel par_expected], TOK_NUMBER
    cmp  rax, TOK_NUMBER
    jne  .err
.mti_addr:
    mov  rdi, AST_BOOT_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax
    call par_current_token
    mov  [r15 + AST.data], rax       ; physical address
    call par_advance
    call par_cur_type                ; 'flags'
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  edx, dword [rax + TOKEN.length]
    ; cache_bypass 12, read_only_user 14, execute_disable 15,
    ; read_write_kernel 17 -- the four lengths differ
    mov  ecx, PGFLAG_CACHE_BYPASS
    cmp  edx, 12
    je   .mti_flag
    mov  ecx, PGFLAG_RO_USER
    cmp  edx, 14
    je   .mti_flag
    mov  ecx, PGFLAG_EXEC_DIS
    cmp  edx, 15
    je   .mti_flag
    mov  ecx, PGFLAG_RW_KERNEL
    cmp  edx, 17
    jne  .err
.mti_flag:
    mov  [r15 + AST.left], rcx
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  qword [r15 + AST.right], 0
    mov  rcx, [rel par_boot_tail]
    test rcx, rcx
    jnz  .mti_chain
    mov  [r13 + AST.left], r15       ; head of the table chain
    mov  [rel par_boot_tail], r15
    jmp  .mti_loop
.mti_chain:
    mov  [rcx + AST.right], r15
    mov  [rel par_boot_tail], r15
    jmp  .mti_loop
.mti_end:
    call par_advance
    jmp  .body

; --- load_kernel_elf ( "path" ) ; ---
.chk_elf:
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 15
    jne  .skip
    cmp  dword [rsi], 'load'
    jne  .skip
    cmp  dword [rsi+4], '_ker'
    jne  .skip
    cmp  dword [rsi+8], 'nel_'
    jne  .skip
    cmp  word  [rsi+12], 'el'
    jne  .skip
    cmp  byte  [rsi+14], 'f'
    jne  .skip
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_STRING
    cmp  rax, TOK_STRING
    jne  .err
    call par_current_token
    mov  [r13 + AST.type_info], rax  ; kernel image path
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    jmp  .body

.skip:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .skipblk
    cmp  rax, TOK_LPAREN
    je   .skippar
    call par_advance
    jmp  .body
.skipblk:
    call parse_generic_block
    test rax, rax
    jz   .err
    jmp  .body
.skippar:
    call consume_balanced_parens
    test rax, rax
    jz   .err
    jmp  .body

.close:
    call par_advance
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_struct_ast() -> rax = AST_STRUCT_DEF node (or 0)
;   struct IDENT '{' ( IDENT ':' type ';' )* '}'
;   Node: data = struct name token, right = field list (AST_FIELD, data = name)
; ==============================================================================
; ==============================================================================
; parse_struct_lit_ast(rdi = type name token) -> rax = AST_STRUCT_LIT
;
;   Vec3{1.0, 2.0, 3.0}          positional, in declaration order
;   Vec3{x: 1.0, z: 3.0}         by name, the rest left at zero
;
; The two forms may not be mixed: allowing it reads badly and hides
; mistakes, so the first initialiser decides which form the whole literal
; uses and a stray ':' after that is an error.
; ==============================================================================
parse_struct_lit_ast:
    push r12
    push r13
    push r14
    push r15
    mov  r12, rdi                    ; type name token
    mov  rdi, AST_STRUCT_LIT
    call ast_alloc
    test rax, rax
    jz   .sl_err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    call par_advance                 ; consume '{'
    xor  r14, r14                    ; tail of the initialiser list
    xor  r15, r15                    ; 0 = undecided, 1 = named, 2 = positional
.sl_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .sl_close
    cmp  rax, TOK_EOF
    je   .sl_err
    mov  rdi, AST_FINIT
    call ast_alloc
    test rax, rax
    jz   .sl_err
    push rax
    ; a named initialiser is IDENT ':' -- look one token ahead
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .sl_positional
    call par_peek_next_type
    cmp  rax, TOK_COLON
    jne  .sl_positional
    ; named
    cmp  r15, 2
    je   .sl_err_pop                 ; started positional, cannot switch
    mov  r15, 1
    call par_current_token
    mov  rdi, [rsp]
    mov  [rdi + AST.data], rax       ; field name
    call par_advance                 ; consume name
    call par_advance                 ; consume ':'
    jmp  .sl_value
.sl_positional:
    cmp  r15, 1
    je   .sl_err_pop                 ; started named, cannot switch
    mov  r15, 2
.sl_value:
    call parse_expression_ast
    test rax, rax
    jz   .sl_err_pop
    mov  rdi, [rsp]
    mov  [rdi + AST.left], rax       ; the value
    pop  rdi
    test r14, r14
    jnz  .sl_chain
    mov  [r13 + AST.right], rdi
    jmp  .sl_after
.sl_chain:
    mov  [r14 + AST.right], rdi
.sl_after:
    mov  r14, rdi
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .sl_loop
    call par_advance
    jmp  .sl_loop
.sl_close:
    call par_advance                 ; consume '}'
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.sl_err_pop:
    pop  rdi
.sl_err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_enum_ast() -> rax = AST_ENUM_DEF
;
;   enum Color { Red, Green, Blue }
;   enum Flag  { Off = 0, On = 1, Both = 3 }
;
; Members number from zero unless given a value, and an explicit value moves
; the counter, so the ones after it follow on.
;
; Node: data = enum name token, right = chain of AST_FIELD whose data is the
; member name and whose type_info is its value. The member list reuses
; AST_FIELD because the shape is identical and nothing reads it as a struct
; field: only cg_register_enum walks it.
; ==============================================================================
parse_enum_ast:
    push r12
    push r13
    push r14
    push r15
    call par_advance                 ; consume 'enum'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .en_err
    call par_current_token
    mov  r12, rax                    ; enum name
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .en_err
    call par_advance
    mov  rdi, AST_ENUM_DEF
    call ast_alloc
    test rax, rax
    jz   .en_err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    xor  r14, r14                    ; tail
    xor  r15, r15                    ; next value
.en_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .en_close
    cmp  rax, TOK_EOF
    je   .en_err
    mov  qword [rel par_expected], TOK_IDENT
    call par_is_field_name
    jz   .en_err
    mov  rdi, AST_FIELD
    call ast_alloc
    test rax, rax
    jz   .en_err
    push rax
    call par_current_token
    mov  rdi, [rsp]
    mov  [rdi + AST.data], rax       ; member name
    call par_advance
    ; an explicit value?
    call par_cur_type
    cmp  rax, TOK_ASSIGN
    jne  .en_implicit
    call par_advance
    call par_cur_type
    cmp  rax, TOK_NUMBER
    je   .en_num
    cmp  rax, TOK_HEX
    jne  .en_err_pop
.en_num:
    call par_current_token
    mov  rdi, rax
    call tok_to_uint
    mov  r15, rax
    call par_advance
.en_implicit:
    pop  rdi
    mov  [rdi + AST.type_info], r15
    inc  r15
    test r14, r14
    jnz  .en_chain
    mov  [r13 + AST.right], rdi
    jmp  .en_after
.en_chain:
    mov  [r14 + AST.right], rdi
.en_after:
    mov  r14, rdi
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .en_loop
    call par_advance
    jmp  .en_loop
.en_close:
    call par_advance                 ; consume '}'
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.en_err_pop:
    pop  rdi
.en_err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

parse_struct_ast:
    push r12
    push r13
    push r14
    call par_advance                 ; consume 'struct'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax                    ; struct name
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_STRUCT_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  [r13 + AST.data], r12
    xor  r14, r14                    ; field list tail
.fields:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    call par_is_field_name
    jz   .err
    mov  rdi, AST_FIELD
    call ast_alloc
    test rax, rax
    jz   .err
    push rax
    call par_current_token
    pop  rdi
    mov  [rdi + AST.data], rax       ; field name
    test r14, r14
    jnz  .chain
    mov  [r13 + AST.right], rdi
    mov  r14, rdi
    jmp  .after
.chain:
    mov  [r14 + AST.right], rdi
    mov  r14, rdi
.after:
    call par_advance                 ; consume field name
    call par_cur_type
    cmp  rax, TOK_COLON
    jne  .semi
    call par_advance
    ; remember the declared type: its token type gives the field width, and
    ; the token itself is needed when the type is another struct
    call par_cur_type
    mov  [r14 + AST.type_info], rax
    push rax
    call par_current_token
    mov  [r14 + AST.left], rax       ; free on a field node; the type token
    pop  rax
    call parse_type
    test rax, rax
    jz   .err
    call par_vtag_col
    mov  [r14 + AST.col], cx         ; bits 8-15: text, list, map
.semi:
    call par_cur_type
    cmp  rax, TOK_SEMICOLON
    jne  .fields
    call par_advance
    jmp  .fields
.close:
    call par_advance                 ; consume '}'
    mov  rax, r13
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_param_list() -> rax = parameter list head (0 if empty, -1 on error)
;   '(' ( IDENT ( ':' type )? ( ',' … )* )? ')'
;   Each node: AST_PARAM, data = name token, right = next
; ==============================================================================
parse_param_list:
    push r12
    push r13
    push r15
    call par_advance                 ; consume '('
    xor  r12, r12                    ; head
    xor  r13, r13                    ; tail
    xor  r15, r15                    ; parameter count
.loop:
    call par_cur_type
    cmp  rax, TOK_RPAREN
    je   .done
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_DOT
    jne  .not_dots
    ; '...': the rest are variadic, in an extern fn only
    lea  rax, [rel msg_ext_dots]
    mov  [rel par_custom_msg], rax
    cmp  dword [rel par_extern_mode], 0
    je   .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_DOT
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_DOT
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .err
    mov  qword [rel par_custom_msg], 0
    mov  dword [rel par_variadic], 1
    jmp  .done
.not_dots:
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    ; Six is the whole argument-register set; past that they travel on the
    ; stack. The cap is arbitrary but finite, so that a runaway list is
    ; reported rather than eating the frame.
    inc  r15
    cmp  r15, 16
    jbe  .count_ok
    lea  rax, [rel msg_too_many_params]
    mov  [rel par_custom_msg], rax
    jmp  .err
.count_ok:
    mov  rdi, AST_PARAM
    call ast_alloc
    test rax, rax
    jz   .err
    push rax
    call par_current_token
    pop  rdi
    mov  [rdi + AST.data], rax
    ; chain
    test r13, r13
    jnz  .chain
    mov  r12, rdi
    mov  r13, rdi
    jmp  .after
.chain:
    mov  [r13 + AST.right], rdi
    mov  r13, rdi
.after:
    call par_advance                 ; consume the name
    call par_cur_type
    cmp  rax, TOK_COLON
    jne  .sep
    call par_advance
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    ; Remember the type token in AST.left of the param node, the same way a
    ; local declaration does. An IDENT here names a struct; the builtin types
    ; arrive as keywords. Throwing it away is why 'fn dot(a: Vec3, b: Vec3)'
    ; compiled and then read the first field for every 'a.y': codegen had no
    ; way to learn that the parameter had a struct type at all.
    call par_cur_type
    cmp  rax, KW_STR
    je   .take_ptype
    cmp  rax, TOK_IDENT
    jne  .no_ptype
.take_ptype:
    call par_current_token
    mov  [r13 + AST.left], rax
.no_ptype:
    ; the type keyword, for an extern fn: how wide the argument is
    call par_cur_type
    mov  [r13 + AST.owner_type], rax
    call parse_type
    test rax, rax
    jz   .err
    mov  rdi, [r13 + AST.data]
    call par_note_pstruct            ; a parameter p: ptr<S>
    ; AST.col of the param node (r13, the most recently chained one) carries
    ; the same two flags as a declaration: bit0 float, bit1 unsigned. This
    ; site still used the old single-bit form, so a u64 parameter was signed.
    movzx ecx, word [rel par_last_is_float]
    and  ecx, 1
    movzx edx, word [rel par_last_is_unsigned]
    and  edx, 1
    shl  edx, 1
    or   ecx, edx
    mov  edx, dword [rel par_last_arr_elem]
    and  edx, 15
    shl  edx, 4
    or   ecx, edx                       ; bits 4-7: the array element width
    mov  edx, ecx
    call par_vtag_col
    or   ecx, edx                       ; bits 8-15: text, list, map
    mov  [r13 + AST.col], cx
    mov  rdi, [r13 + AST.data]
    call par_coll_of_vtag
    ; An array parameter is passed by address: the length goes in type_info
    ; so codegen knows to spill a pointer rather than a value, and the float
    ; flag above then describes the ELEMENT, which is what indexing needs.
    mov  rcx, [rel par_last_array_len]
    mov  [r13 + AST.type_info], rcx
    ; A pointer parameter needs its element width recorded too. Local
    ; declarations already store this; parameters did not, so 'p + 1' inside
    ; the function stepped a single byte instead of a whole element.
    mov  ecx, dword [rel par_last_ptr_elem]
    mov  [r13 + AST.child_count], ecx
    cmp  qword [rel par_last_is_slice], 0
    je   .sep
    mov  rdi, [r13 + AST.data]       ; a slice parameter: remember its name
    call par_slice_add
.sep:
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .loop
    call par_advance
    jmp  .loop
.done:
    call par_advance                 ; consume ')'
    mov  rax, r12
    pop  r15
    pop  r13
    pop  r12
    ret
.err:
    mov  rax, -1
    pop  r15
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_arg_list() -> rax = argument list head (0 if empty, -1 on error)
;   '(' ( expr ( ',' expr )* )? ')'
;   Each node: AST_ARG, left = expression, right = next
; ==============================================================================
parse_arg_list:
    push r12
    push r13
    push r14
    call par_advance                 ; consume '('
    xor  r12, r12
    xor  r13, r13
.loop:
    call par_cur_type
    cmp  rax, TOK_RPAREN
    je   .done
    cmp  rax, TOK_EOF
    je   .err
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r14, rax
    mov  rdi, AST_ARG
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.left], r14
    test r13, r13
    jnz  .chain
    mov  r12, rax
    mov  r13, rax
    jmp  .sep
.chain:
    mov  [r13 + AST.right], rax
    mov  r13, rax
.sep:
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .loop
    call par_advance
    jmp  .loop
.done:
    call par_advance                 ; consume ')'
    mov  rax, r12
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    mov  rax, -1
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; M01 - parse_isa_ast() -> rax = AST_ISA_DEF node (or 0)
;   kron_isa_dynamic IDENT '{' ... opcode_set { IDENT = HEX ; ... } ... '}'
; Sections other than opcode_set are consumed without capturing them (v1).
; ==============================================================================
parse_isa_ast:
    push r12
    push r13
    push r14
    push r15
    call par_advance                 ; consume 'kron_isa_dynamic'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax                    ; name token of the ISA
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_ISA_DEF
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r13, rax                    ; ISA node
    mov  [r13 + AST.data], r12
    xor  r14, r14                    ; tail of entry list

.body:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    cmp  rax, TOK_IDENT
    jne  .skip
    ; identify the "opcode_set" section by text
    call par_current_token
    mov  rsi, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 10
    jne  .skip
    cmp  dword [rsi], 'opco'
    jne  .skip
    cmp  dword [rsi+4], 'de_s'
    jne  .skip
    cmp  word [rsi+8], 'et'
    jne  .skip
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance

.ops:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .ops_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_ISA_ENTRY
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r15, rax                    ; entry node
    call par_current_token
    mov  [r15 + AST.data], rax       ; opcode name
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_ASSIGN
    cmp  rax, TOK_ASSIGN
    jne  .err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_HEX
    je   .val
    cmp  rax, TOK_NUMBER
    je   .val
    jmp  .err
.val:
    call par_current_token
    mov  [r15 + AST.left], rax       ; opcode value
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    test r14, r14
    jnz  .chain
    mov  [r13 + AST.right], r15
    mov  r14, r15
    jmp  .ops
.chain:
    mov  [r14 + AST.right], r15
    mov  r14, r15
    jmp  .ops

.ops_end:
    call par_advance                 ; consume '}' of opcode_set
    jmp  .body

.skip:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    je   .skipblk
    call par_advance
    jmp  .body
.skipblk:
    call parse_generic_block
    test rax, rax
    jz   .err
    jmp  .body

.close:
    call par_advance                 ; consume final '}'
    mov  rax, r13
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_extern_ast() -> rax = the first AST_EXTERN of the block (or 0)
;   extern STRING (',' STRING)* '{'
;       ( fn IDENT '(' params [',' '...'] ')' [ '->' type ] ';' )*
;   '}'
; The strings name the library on each system, tried in order until one
; loads: "libm.so.6", "libm.dylib", "msvcrt.dll". Every function of the
; block keeps the list.
; ==============================================================================
parse_extern_ast:
    push r12
    push r13
    push r14
    push r15
    push rbx
    call par_advance                 ; consume 'extern'
    xor  r12, r12                    ; the names of the libraries
    xor  r13, r13                    ; their last
.lib:
    call par_cur_type
    mov  qword [rel par_expected], TOK_STRING
    cmp  rax, TOK_STRING
    jne  .err
    mov  rdi, AST_ARG
    call ast_alloc
    test rax, rax
    jz   .err
    mov  rbx, rax
    call par_current_token
    mov  [rbx + AST.data], rax
    test r13, r13
    jnz  .lib_chain
    mov  r12, rbx
    jmp  .lib_tail
.lib_chain:
    mov  [r13 + AST.right], rbx
.lib_tail:
    mov  r13, rbx
    call par_advance
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .open
    call par_advance
    jmp  .lib
.open:
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    xor  r14, r14                    ; the first function
    xor  r15, r15                    ; the last
.fn:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    mov  qword [rel par_expected], TOK_KW_FN
    cmp  rax, TOK_KW_FN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    mov  rdi, AST_EXTERN
    call ast_alloc
    test rax, rax
    jz   .err
    mov  rbx, rax
    call par_current_token
    mov  [rbx + AST.data], rax
    mov  [rbx + AST.owner_type], r12
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    mov  dword [rel par_extern_mode], 1
    mov  dword [rel par_variadic], 0
    call parse_param_list
    mov  dword [rel par_extern_mode], 0
    cmp  rax, -1
    je   .err
    mov  [rbx + AST.left], rax
    mov  eax, [rel par_variadic]
    mov  [rbx + AST.col], ax
    mov  dword [rbx + AST.child_count], 0
    call par_cur_type
    cmp  rax, TOK_ARROW
    je   .result
    cmp  rax, TOK_COLON
    jne  .semi
.result:
    call par_advance
    call par_cur_type
    mov  ecx, 1
    cmp  rax, KW_I32
    je   .kind
    mov  ecx, 2
    cmp  rax, KW_U32
    je   .kind
    mov  ecx, 3
    cmp  rax, KW_U8
    je   .kind
    cmp  rax, KW_BOOL
    je   .kind
    mov  ecx, 4
    cmp  rax, KW_U16
    je   .kind
    mov  ecx, 5
    cmp  rax, KW_I16
    je   .kind
    mov  ecx, 6
    cmp  rax, KW_I8
    je   .kind
    mov  ecx, 8
    cmp  rax, KW_F64
    je   .kind
    mov  ecx, 9
    cmp  rax, KW_F32
    je   .kind
    xor  ecx, ecx
.kind:
    mov  [rbx + AST.child_count], ecx
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    call parse_type
    test rax, rax
    jz   .err
.semi:
    call par_cur_type
    cmp  rax, TOK_LBRACE
    jne  .semi_tok
    lea  rax, [rel msg_ext_body]
    mov  [rel par_custom_msg], rax
    jmp  .err
.semi_tok:
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    test r15, r15
    jnz  .fn_chain
    mov  r14, rbx
    jmp  .fn_tail
.fn_chain:
    mov  [r15 + AST.right], rbx
.fn_tail:
    mov  r15, rbx
    jmp  .fn
.close:
    call par_advance                 ; consume '}'
    test r14, r14
    jnz  .have
    ; an empty block still gives a node: data 0, nothing to declare
    mov  rdi, AST_EXTERN
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r14, rax
.have:
    mov  rax, r14
    pop  rbx
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    mov  dword [rel par_extern_mode], 0
    xor  rax, rax
    pop  rbx
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_function_ast() -> rax = AST_FUNCTION node (or 0)
;   fn IDENT '(' params ')' [ ('->'|':') type ] '{' stmts '}'
; ==============================================================================
parse_function_ast:
    mov  qword [rel par_fn_rettok], 0
    mov  dword [rel par_slice_n], 0  ; slice names are per function
    mov  dword [rel par_in_fn], 1
    push r12
    push r13
    push r14
    push r15
    call par_advance                 ; consume 'fn'

    ; --- optional visibility modifier ---
    xor  r14, r14                    ; VIS_DEFAULT
    call par_cur_type
    cmp  rax, KW_GLOBAL_VISIBLE
    je   .vis_export
    cmp  rax, KW_INTER_CLUSTER_EXPORT
    je   .vis_export
    cmp  rax, KW_DOMAIN_ISOLATED
    je   .vis_private
    jmp  .get_name
.vis_export:
    mov  r14, VIS_EXPORTED
    call par_advance
    jmp  .get_name
.vis_private:
    call par_advance
.get_name:

    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax                    ; function name token
    call par_advance
    ; '('
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call parse_param_list            ; -> rax = parameter list (may be 0)
    cmp  rax, -1
    je   .err
    mov  r15, rax                    ; parameter list
    ; optional return type
    call par_cur_type
    cmp  rax, TOK_ARROW
    je   .rettype
    cmp  rax, TOK_COLON
    je   .rettype
    jmp  .body
.rettype:
    call par_advance
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    mov  dword [rel par_multi], 0
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .ret_single
    call parse_multi_type            ; (T1, T2...): par_multi, and the first
    test rax, rax                    ; type left as the one just parsed
    jz   .err
    jmp  .ret_have
.ret_single:
    ; fn f() -> S with S a name: the token, for a function that returns a
    ; struct (codegen passes it where to write the result)
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .ret_noname
    call par_current_token
    mov  [rel par_fn_rettok], rax
.ret_noname:
    ; the type keyword, in type_info above the visibility: a library's
    ; export hands C an f32 as one
    call par_cur_type
    shl  rax, 16
    or   r14, rax
    call parse_type
    test rax, rax
    jz   .err
.ret_have:
    ; both bits, the same packing a declaration uses: bit0 float, bit1
    ; unsigned. Only the float bit was kept, so a function returning u64
    ; compared and divided signed.
    movzx ecx, word [rel par_last_is_float]
    and  ecx, 1
    movzx edx, word [rel par_last_is_unsigned]
    and  edx, 1
    shl  edx, 1
    or   ecx, edx
    mov  edx, ecx
    call par_vtag_col
    or   ecx, edx
    mov  [rel pending_ret_float], cx
    ; remembered by name, for declarations that take the type from a call
    mov  rax, [rel par_last_vtag]
    test eax, eax
    jz   .body
    mov  ecx, [rel par_fnvt_n]
    cmp  ecx, 2048
    jae  .body
    lea  rdx, [rel par_fnvt_toks]
    mov  [rdx + rcx*8], r12
    lea  rdx, [rel par_fnvt_tags]
    mov  [rdx + rcx*4], eax
    inc  ecx
    mov  [rel par_fnvt_n], ecx
.body:
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast             ; -> rax = BLOCK node
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  rdi, AST_FUNCTION
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r12
    mov  [rax + AST.right], r13
    mov  [rax + AST.left], r15       ; parameter list
    mov  [rax + AST.type_info], r14
    mov  cx, word [rel pending_ret_float]
    mov  [rax + AST.col], cx         ; 1 = returns float; bits 8-15 type tag
    mov  word [rel pending_ret_float], 0
    mov  ecx, [rel par_multi]
    mov  [rax + AST.child_count], ecx  ; several results: see parse_multi_type
    mov  dword [rel par_multi], 0
    mov  rcx, [rel par_fn_rettok]
    mov  [rax + AST.owner_type], rcx   ; the struct it returns, by name
    mov  qword [rel par_fn_rettok], 0
    mov  dword [rel par_in_fn], 0
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_block_ast() -> rax = BLOCK node (linked list left=stmt, right=next)
; Assumes the current token is '{'. Consumes up to and including '}'.
; ==============================================================================
; parse_statement_no_semi() -> node (assignment or expr), without consuming ';'
parse_statement_no_semi:
    push r12
    push r13
    call parse_expression_ast
    test rax, rax
    jz   .nserr
    mov  r12, rax
    call par_cur_type
    cmp  rax, TOK_ASSIGN
    jne  .nsdone
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .nserr
    mov  r13, rax
    mov  rdi, r12
    mov  rsi, r13
    call par_make_assign             ; or slice_set(...) for a slice element
    test rax, rax
    jz   .nserr
    pop  r13
    pop  r12
    ret
.nsdone:
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.nserr:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_block_ast:
    push r12
    push r13
    call par_advance                 ; consume '{'
    mov  rdi, AST_BLOCK
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r12, rax                    ; head
    mov  r13, rax                    ; current
.loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .err
    call par_current_token
    movzx eax, word [rax + TOKEN.line]
    push rax                         ; the line the statement starts on
    call parse_statement_ast         ; -> rax = stmt node
    pop  rcx
    test rax, rax
    jz   .err
    mov  [rax + AST.line], cx
    ; a statement the parser turned into several: its chain goes in as is
    cmp  qword [rax + AST.node_type], AST_BLOCK
    jne  .one_stmt
    cmp  qword [rax + AST.type_info], BLOCK_SPLICE
    je   .splice
.one_stmt:
    cmp  qword [r13 + AST.left], 0
    jne  .newnode
    mov  [r13 + AST.left], rax
    jmp  .loop
.splice:
    mov  qword [rax + AST.type_info], 0
    cmp  qword [r13 + AST.left], 0
    jne  .splice_link
    ; the block is still empty: the chain's first link takes its place
    mov  rcx, [rax + AST.left]
    mov  [r13 + AST.left], rcx
    mov  rcx, [rax + AST.right]
    mov  [r13 + AST.right], rcx
    jmp  .splice_tail
.splice_link:
    mov  [r13 + AST.right], rax
    mov  r13, rax
.splice_tail:
    ; on to the last link
    cmp  qword [r13 + AST.right], 0
    je   .loop
    mov  r13, [r13 + AST.right]
    jmp  .splice_tail
.newnode:
    push rax                         ; stmt node
    mov  rdi, AST_BLOCK
    call ast_alloc
    test rax, rax
    jz   .err2
    pop  rcx                         ; stmt node
    mov  [rax + AST.left], rcx
    mov  [r13 + AST.right], rax
    mov  r13, rax
    jmp  .loop
.err2:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret
.close:
    call par_advance                 ; consume '}'
    mov  rax, r12
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_statement_ast() -> rax = stmt node (or 0)
; ==============================================================================
parse_statement_ast:
    push r12
    push r13
    push r14
    push r15
    call par_cur_type

    cmp  rax, TOK_KW_VAR
    je   .var
    cmp  rax, KW_OUTB
    je   .outbst
    cmp  rax, KW_POKE
    je   .pokest
    cmp  rax, KW_BEEP
    je   .beepst
    cmp  rax, KW_SAVEFILE
    je   .savefilest
    cmp  rax, KW_POKE8
    je   .poke8st
    cmp  rax, KW_POKE16
    je   .poke16st
    cmp  rax, KW_POKE32
    je   .poke32st
    cmp  rax, KW_ASM
    je   .asmst
    cmp  rax, TOK_KW_CONST
    je   .var
    cmp  rax, TOK_KW_IF
    je   .ifst
    cmp  rax, KW_SWITCH
    je   .switchst
    cmp  rax, TOK_KW_WHILE
    je   .whilest
    cmp  rax, KW_FOR
    je   .forst
    cmp  rax, KW_RAW
    je   .rawst
    cmp  rax, TOK_KW_LOOP
    je   .loopst
    cmp  rax, TOK_KW_RETURN
    je   .retst
    cmp  rax, TOK_KW_PRINT
    je   .printst
    cmp  rax, TOK_KW_PRINTC
    je   .printcst
    cmp  rax, KW_FAIL
    je   .failst
    cmp  rax, KW_VEC2_STORE
    je   .v2storest
    cmp  rax, KW_THREAD_WAIT
    je   .thwaitst
    cmp  rax, KW_THREAD_YIELD
    je   .exprst                 ; thread_yield(); an expression used as a statement
    cmp  rax, KW_LOCK_INIT
    je   .lkinitst
    cmp  rax, KW_LOCK_TAKE
    je   .lktakest
    cmp  rax, KW_LOCK_GIVE
    je   .lkgivest
    cmp  rax, KW_PRINTFAIL
    je   .printfailst
    cmp  rax, TOK_KW_BREAK
    je   .breakst
    cmp  rax, TOK_KW_CONTINUE
    je   .continuest
    cmp  rax, TOK_LBRACE
    je   .nested
    cmp  rax, TOK_IDENT
    je   .check_multi
    cmp  rax, TOK_STAR
    je   .exprst
    jmp  .err
.check_multi:
    ; a, b = f(): an identifier followed by a comma
    mov  rax, [rel par_pos]
    inc  rax
    cmp  rax, [rel par_token_count]
    jge  .check_syscall
    imul rax, TOKEN_SIZE
    add  rax, [rel par_tokens]
    cmp  qword [rax + TOKEN.type], TOK_COMMA
    jne  .check_syscall
    call par_current_token
    mov  rdi, rax
    call par_advance
    xor  esi, esi
    call parse_multi_assign
    test rax, rax
    jz   .err
    jmp  .ret_ok

.check_syscall:
    ; syscall(...) used to be parsed here, as a statement only, and its result
    ; was thrown away. It is an expression now (parse_syscall_expr), so an
    ; identifier simply starts an expression statement.
    jmp  .exprst

; --- var/const ---
.var:
    call par_advance                 ; consume var/const
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r12, rax                    ; name token
    call par_advance
    ; var a, b = f(): several names take the results of one call
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .var_one
    mov  rdi, r12
    mov  esi, 1
    call parse_multi_assign
    test rax, rax
    jz   .err
    jmp  .ret_ok
.var_one:
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_ptr_elem], 0
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    mov  qword [rel par_last_arr_elem], 0
    mov  qword [rel par_last_row_len], 0
    mov  qword [rel par_last_vtag], 0
    mov  dword [rel par_decl_typed], 0
    call par_cur_type
    cmp  rax, TOK_COLON
    jne  .var_assign
    call par_advance
    ; remember the type token: an IDENT here may name a struct
    xor  r15, r15
    call par_cur_type
    cmp  rax, KW_F32
    je   .mark_float
    cmp  rax, KW_F64
    je   .mark_float
    cmp  rax, KW_STR
    je   .take_typetok               ; 'stream' resolves to a built-in struct
    cmp  rax, TOK_IDENT
    jne  .no_typetok
.take_typetok:
    call par_current_token
    mov  r15, rax
    jmp  .no_typetok
.mark_float:
    mov  qword [rel par_last_is_float], 1
.no_typetok:
    call parse_type
    test rax, rax
    jz   .err
    mov  rdi, r12
    call par_note_pstruct            ; var p: ptr<S>
    mov  dword [rel par_decl_typed], 1
    ; any typed declaration may omit the initializer
    call par_cur_type
    cmp  rax, TOK_SEMICOLON
    jne  .var_assign
    call par_advance
    mov  r14, [rel par_last_array_len]
    mov  rdi, AST_VAR_DECL
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r12
    mov  qword [rax + AST.right], 0
    mov  [rax + AST.left], r15          ; type name token (struct), 0 otherwise
    mov  [rax + AST.type_info], r14     ; array length, 0 otherwise
    mov  rcx, [rel par_last_row_len]
    mov  [rax + AST.owner_type], rcx    ; free here; the row stride of a 2-D array
    mov  ecx, dword [rel par_last_ptr_elem]
    mov  [rax + AST.child_count], ecx   ; pointer element width
    cmp  qword [rel par_last_is_slice], 0
    je   .decl_noslice1
    mov  rdi, r12                       ; a slice variable: remember its name
    call par_slice_add
.decl_noslice1:
    ; AST.col carries two flags now: bit 0 float, bit 1 unsigned.
    ; Packed in 32-bit registers on purpose: kasm's shift encoder accepts
    ; 8, 32 and 64-bit registers and refuses 16-bit ones, so 'shl dx, 1'
    ; assembles under NASM and stops the kasm build dead.
    movzx ecx, word [rel par_last_is_float]
    and  ecx, 1
    movzx edx, word [rel par_last_is_unsigned]
    and  edx, 1
    shl  edx, 1
    or   ecx, edx
    mov  edx, dword [rel par_last_arr_elem]
    and  edx, 15
    shl  edx, 4
    or   ecx, edx
    mov  edx, ecx
    call par_vtag_col
    or   ecx, edx
    mov  edx, [rel par_decl_typed]
    shl  edx, 3
    or   ecx, edx                       ; bit 3: a type was written
    mov  [rax + AST.col], cx            ; bit0 float, bit1 unsigned, bits 4-7
                                        ; the array element width, bits 8-15
                                        ; text, list, map
    mov  rdi, r12
    call par_coll_of_vtag
    jmp  .ret_ok
.var_assign:
    call par_cur_type
    mov  qword [rel par_expected], TOK_ASSIGN
    cmp  rax, TOK_ASSIGN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax                    ; init expr
    ; 'var x = f()' with f returning a text, list<T> or map<T>: x is one too
    cmp  dword [rel par_decl_typed], 0
    jne  .va_typed
    mov  rdi, r13
    call par_infer_vtag
.va_typed:
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_VAR_DECL
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r12
    mov  ecx, dword [rel par_last_ptr_elem]
    mov  [rax + AST.child_count], ecx   ; pointer element width
    cmp  qword [rel par_last_is_slice], 0
    je   .decl_noslice2
    mov  rdi, r12
    call par_slice_add
.decl_noslice2:
    ; AST.col carries two flags now: bit 0 float, bit 1 unsigned.
    ; Packed in 32-bit registers on purpose: kasm's shift encoder accepts
    ; 8, 32 and 64-bit registers and refuses 16-bit ones, so 'shl dx, 1'
    ; assembles under NASM and stops the kasm build dead.
    movzx ecx, word [rel par_last_is_float]
    and  ecx, 1
    movzx edx, word [rel par_last_is_unsigned]
    and  edx, 1
    shl  edx, 1
    or   ecx, edx
    mov  edx, dword [rel par_last_arr_elem]
    and  edx, 15
    shl  edx, 4
    or   ecx, edx
    mov  edx, ecx
    call par_vtag_col
    or   ecx, edx
    mov  edx, [rel par_decl_typed]
    shl  edx, 3
    or   ecx, edx                       ; bit 3: a type was written
    mov  [rax + AST.col], cx            ; bit0 float, bit1 unsigned, bits 4-7
                                        ; the array element width, bits 8-15
                                        ; text, list, map
    mov  rdi, r12
    call par_coll_of_vtag
    ; The declaration WITH an initialiser never recorded the type token, so
    ; 'var v: Vec3 = ...' and 'var s: stream = ...' came out as scalars with
    ; a single slot while 'var v: Vec3;' worked. Same field, same meaning as
    ; the branch above.
    mov  [rax + AST.left], r15
    mov  rcx, [rel par_last_array_len]
    mov  [rax + AST.type_info], rcx
    mov  rcx, [rel par_last_row_len]
    mov  [rax + AST.owner_type], rcx  ; free on a declaration; the row stride
    mov  [rax + AST.right], r13
    jmp  .ret_ok

; --- if ---
.ifst:
    call par_advance
    call parse_opt_paren_expr_ast
    test rax, rax
    jz   .err
    mov  r12, rax                    ; condition
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  r13, rax                    ; then
    ; optional else
    call par_cur_type
    cmp  rax, TOK_KW_ELSE
    jne  .if_noelse
    call par_advance
    call par_cur_type
    cmp  rax, TOK_KW_IF
    je   .else_if
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast             ; else block
    test rax, rax
    jz   .err
    jmp  .if_build
.else_if:
    call parse_statement_ast         ; chained if
    test rax, rax
    jz   .err
    jmp  .if_build
.if_noelse:
    xor  rax, rax                    ; no else
.if_build:
    push rax                         ; else branch (or 0)
    mov  rdi, AST_IF
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx                         ; else branch
    mov  [rax + AST.data], r12       ; condition
    mov  [rax + AST.left], r13       ; then
    mov  [rax + AST.right], rcx      ; else
    jmp  .ret_ok

; --- switch ---
; The grammar takes an IDENTIFIER as the subject, not an expression, so it can
; be evaluated once per case without side effects.  That lets a switch be built
; as a chain of AST_IF nodes -- 'switch x { case a: A case b: B default: D }'
; becomes 'if x==a A else if x==b B else D' -- reusing the tested if codegen.
; Each case is a closed block, so there is no fall-through and no 'break'.
; .sw_e1 / .sw_e2 unwind the exact number of pushes live at each failure point;
; leaving anything on the stack would corrupt the r12-r15 restore in .ret_ok.
.switchst:
    call par_advance                 ; consume 'switch'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    mov  r15, rax                    ; subject token, reused by every case
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    xor  r12, r12                    ; chain head
    xor  r14, r14                    ; chain tail (its AST.right is the open slot)
.sw_loop:
    call par_cur_type
    cmp  rax, KW_CASE
    je   .sw_case
    cmp  rax, KW_DEFAULT
    je   .sw_default
    cmp  rax, TOK_RBRACE
    je   .sw_end
    jmp  .err
.sw_case:
    call par_advance                 ; consume 'case'
    mov  rdi, AST_IDENTIFIER         ; fresh subject node; codegen only reads it
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r15
    push rax                         ; [1] subject
    call parse_expression_ast        ; the case value
    test rax, rax
    jz   .sw_e1
    push rax                         ; [2] value
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .sw_e2
    pop  rcx                         ; value
    pop  rdx                         ; subject
    mov  [rax + AST.left], rdx
    mov  [rax + AST.right], rcx
    mov  qword [rax + AST.data], TOK_EQ
    push rax                         ; [1] condition  x == value
    call par_cur_type
    cmp  rax, TOK_COLON
    jne  .sw_e1
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LBRACE
    jne  .sw_e1
    call parse_block_ast
    test rax, rax
    jz   .sw_e1
    push rax                         ; [2] body
    mov  rdi, AST_IF
    call ast_alloc
    test rax, rax
    jz   .sw_e2
    pop  rcx                         ; body
    pop  rdx                         ; condition
    mov  [rax + AST.data], rdx
    mov  [rax + AST.left], rcx
    mov  qword [rax + AST.right], 0
    test r14, r14
    jnz  .sw_link
    mov  r12, rax                    ; first case becomes the head
    mov  r14, rax
    jmp  .sw_loop
.sw_link:
    mov  [r14 + AST.right], rax      ; hang off the previous else slot
    mov  r14, rax
    jmp  .sw_loop
.sw_e2:
    pop  rcx
.sw_e1:
    pop  rcx
    jmp  .err
.sw_default:
    call par_advance                 ; consume 'default'
    call par_cur_type
    mov  qword [rel par_expected], TOK_COLON
    cmp  rax, TOK_COLON
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    test r14, r14
    jz   .err                        ; 'default' with no preceding case
    mov  [r14 + AST.right], rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RBRACE
    cmp  rax, TOK_RBRACE
    jne  .err
.sw_end:
    call par_advance                 ; consume '}'
    test r12, r12
    jz   .err                        ; a switch needs at least one case
    mov  rax, r12
    jmp  .ret_ok

; --- while ---
.whilest:
    call par_advance
    call parse_opt_paren_expr_ast
    test rax, rax
    jz   .err
    mov  r12, rax                    ; condition
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  r13, rax                    ; body
    mov  rdi, AST_WHILE
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r12
    mov  [rax + AST.right], r13
    jmp  .ret_ok

; --- loop { } (endless loop) => WHILE with a null condition (true) ---
.loopst:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  r13, rax
    mov  rdi, AST_WHILE
    call ast_alloc
    test rax, rax
    jz   .err
    mov  qword [rax + AST.data], 0   ; no condition => true
    mov  [rax + AST.right], r13
    jmp  .ret_ok

; --- raw { BODY } ---
; An ordinary block with a mark, not a node of its own: every pass that walks
; the tree -- the frame size, the allocator, the code generator -- already
; knows blocks, and only the semantic pass looks at the mark. The 'raw' token
; rides in AST.data for positions.
; Every path to .err leaves the stack as it found it: .err pops a fixed set.
.rawst:
    call par_current_token
    push rax                         ; the 'raw' token
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .raw_err
    call parse_block_ast
    test rax, rax
    jz   .raw_err
    push rax                         ; the statements inside
    mov  rdi, AST_BLOCK
    call ast_alloc
    test rax, rax
    jz   .raw_err2
    pop  rcx
    mov  [rax + AST.left], rcx
    pop  rcx
    mov  [rax + AST.data], rcx
    mov  qword [rax + AST.type_info], BLOCK_RAW
    jmp  .ret_ok
.raw_err2:
    pop  rcx
.raw_err:
    pop  rcx
    jmp  .err
; --- for INIT; COND; STEP { BODY }  (desugared into block + while) ---
.forst:
    call par_advance
    ; 'for x in l' over a list<T>
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .for_classic
    mov  rax, [rel par_pos]
    inc  rax
    cmp  rax, [rel par_token_count]
    jge  .for_classic
    imul rax, TOKEN_SIZE
    add  rax, [rel par_tokens]
    cmp  qword [rax + TOKEN.type], KW_IN
    jne  .for_classic
    call parse_for_in
    test rax, rax
    jz   .err
    jmp  .ret_ok
.for_classic:
    call parse_statement_ast
    test rax, rax
    jz   .err
    mov  r12, rax
    inc  qword [rel par_no_slit]     ; condition and step reach the '{' too
    call parse_expression_ast
    mov  rcx, rax
    dec  qword [rel par_no_slit]
    mov  rax, rcx
    test rax, rax
    jz   .err
    mov  r13, rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    inc  qword [rel par_no_slit]
    call parse_statement_no_semi
    mov  rcx, rax
    dec  qword [rel par_no_slit]
    mov  rax, rcx
    test rax, rax
    jz   .err
    mov  r14, rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call parse_block_ast
    test rax, rax
    jz   .err
    mov  r15, rax
.for_body_ready:
    ; The step goes in the while's own left field, not glued to the end of
    ; the body. Glued on, the code generator could not tell it from the last
    ; statement, and 'continue' -- which must run the step before looping --
    ; would have skipped it and never left the loop.
    mov  rdi, AST_WHILE
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.data], r13
    mov  [rax + AST.right], r15
    mov  [rax + AST.left], r14
    mov  r13, rax
    mov  rdi, AST_BLOCK
    call ast_alloc
    test rax, rax
    jz   .err
    push rax
    mov  [rax + AST.left], r12
    mov  rdi, AST_BLOCK
    call ast_alloc
    test rax, rax
    jz   .err_pop_for2
    mov  [rax + AST.left], r13
    pop  rcx
    mov  [rcx + AST.right], rax
    mov  rax, rcx
    jmp  .ret_ok
.err_pop_for2:
    pop  rcx
    jmp  .err

; --- return ---
.retst:
    call par_advance
    call par_cur_type
    cmp  rax, TOK_SEMICOLON
    je   .ret_void
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax
    ; return a, b, c: the values after the first, an AST_ARG chain in left
    xor  r14, r14                    ; head
    xor  r15, r15                    ; tail
.ret_more:
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .ret_end
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_ARG
    call ast_alloc
    pop  rcx
    test rax, rax
    jz   .err
    mov  [rax + AST.left], rcx
    test r15, r15
    jz   .ret_first
    mov  [r15 + AST.right], rax
    mov  r15, rax
    jmp  .ret_more
.ret_first:
    mov  r14, rax
    mov  r15, rax
    jmp  .ret_more
.ret_end:
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_RETURN
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.right], r13
    mov  [rax + AST.left], r14
    jmp  .ret_ok
.ret_void:
    call par_advance
    mov  rdi, AST_RETURN
    call ast_alloc
    test rax, rax
    jz   .err
    jmp  .ret_ok

; --- print(expr); ---
.printst:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_PRINT
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.right], r13
    jmp  .ret_ok

.thwaitst:
    ; thread_wait(handle); -- block until that thread finishes
    mov  rcx, AST_THREAD_WAIT
    mov  [rel par_thread_node], rcx
    jmp  .thread_one
.lkinitst:
    ; lock_init(n); -- prepare lock number n. Locks are numbered because
    ; there are no opaque types to hold one.
    mov  rcx, AST_LOCK_INIT
    mov  [rel par_thread_node], rcx
    jmp  .thread_one
.lktakest:
    mov  rcx, AST_LOCK_TAKE
    mov  [rel par_thread_node], rcx
    jmp  .thread_one
.lkgivest:
    mov  rcx, AST_LOCK_GIVE
    mov  [rel par_thread_node], rcx
.thread_one:
    ; the four share a shape: one argument in parentheses, then a semicolon
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .th1_err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .th1_err
    call par_advance
    mov  rdi, [rel par_thread_node]
    call ast_alloc
    test rax, rax
    jz   .th1_err
    pop  rcx
    mov  [rax + AST.right], rcx
    jmp  .ret_ok
.th1_err:
    pop  rcx
    jmp  .err

.v2storest:
    ; vec2_store(addr, value); -- four floats out of an xmm register
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .v2s_e1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .v2s_e1
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .v2s_e2
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .v2s_e2
    call par_advance
    mov  rdi, AST_VEC2_STORE
    call ast_alloc
    test rax, rax
    jz   .v2s_e2
    pop  rcx
    mov  [rax + AST.right], rcx      ; the value
    pop  rcx
    mov  [rax + AST.left], rcx       ; the address
    jmp  .ret_ok
.v2s_e2:
    pop  rcx
.v2s_e1:
    pop  rcx
    jmp  .err

.failst:
    ; fail "cause";   or   fail "cause" hint "what to do";
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_STRING
    cmp  rax, TOK_STRING
    jne  .err
    ; wrap the cause in a string-literal node: codegen then emits its bytes
    ; through the path that already handles escapes
    call par_current_token
    push rax
    mov  rdi, AST_STRING_LIT
    call ast_alloc
    test rax, rax
    jz   .fail_oom
    pop  rcx
    mov  [rax + AST.data], rcx
    push rax
    call par_advance
    mov  rdi, AST_FAIL
    call ast_alloc
    test rax, rax
    jz   .fail_oom
    pop  rcx
    mov  [rax + AST.data], rcx       ; the cause, as a node
    push rax
    call par_cur_type
    cmp  rax, KW_HINT
    jne  .fail_nohint
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_STRING
    cmp  rax, TOK_STRING
    jne  .fail_oom
    call par_current_token
    push rax
    mov  rdi, AST_STRING_LIT
    call ast_alloc
    test rax, rax
    jz   .fail_oom
    pop  rcx
    mov  [rax + AST.data], rcx
    mov  rcx, [rsp]
    mov  [rcx + AST.left], rax       ; what to do about it, as a node
    call par_advance
.fail_nohint:
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .fail_oom
    call par_advance
    pop  rax
    jmp  .ret_ok                     ; restores the four saved registers
.fail_oom:
    pop  rcx
    jmp  .err

.printfailst:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_PRINTFAIL
    call ast_alloc
    jmp  .ret_ok

.printcst:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_PRINTC
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.right], r13
    jmp  .ret_ok

; --- outb(port, value);  and  poke(address, value);  (two arguments) ---
.outbst:
    mov  r14, AST_OUTB
    jmp  .two_args
.pokest:
    mov  r14, AST_POKE
    jmp  .two_args
.beepst:
    mov  r14, AST_BEEP
    jmp  .two_args
.savefilest:
    mov  r14, AST_SAVEFILE
    jmp  .three_args
.poke8st:
    mov  r14, AST_POKE8
    jmp  .two_args
.poke16st:
    mov  r14, AST_POKE16
    jmp  .two_args
.poke32st:
    mov  r14, AST_POKE32
.two_args:
    ; the keyword token, for the position of a warning about it. Kept in a
    ; variable, not pushed: .err pops a fixed set and a push here would unbalance
    ; every error path below. poke cannot nest inside its own arguments.
    call par_current_token
    mov  [rel par_stmt_kw], rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r12, rax                    ; first argument
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax                    ; second argument
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, r14
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], r13
    mov  rcx, [rel par_stmt_kw]
    mov  [rax + AST.data], rcx
    jmp  .ret_ok

.three_args:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r12, rax                    ; arg 1 (buffer)
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .err
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax                    ; arg 2 (length)
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .err
    call par_advance
    push r12
    push r13
    call parse_expression_ast
    test rax, rax
    jz   .err3pop
    mov  r15, rax                    ; arg 3 (name ptr)
    pop  r13
    pop  r12
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .err
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, r14
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], r13
    mov  [rax + AST.data], r15       ; third arg (name)
    jmp  .ret_ok
.err3pop:
    pop  r13
    pop  r12
    jmp  .err

; --- asm { "instruction"; "instruction"; } : raw assembly escape ---
.asmst:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LBRACE
    cmp  rax, TOK_LBRACE
    jne  .err
    call par_advance
    mov  rdi, AST_ASM
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r12, rax
    xor  r13, r13
.asm_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .asm_end
    cmp  rax, TOK_EOF
    je   .err
    mov  qword [rel par_expected], TOK_STRING
    cmp  rax, TOK_STRING
    jne  .err
    mov  rdi, AST_STRING_LIT
    call ast_alloc
    test rax, rax
    jz   .err
    mov  r14, rax
    call par_current_token
    mov  [r14 + AST.data], rax
    call par_advance
    call par_cur_type
    cmp  rax, TOK_SEMICOLON
    jne  .asm_chain
    call par_advance
.asm_chain:
    test r13, r13
    jnz  .asm_link
    mov  [r12 + AST.right], r14
    mov  r13, r14
    jmp  .asm_loop
.asm_link:
    mov  [r13 + AST.right], r14
    mov  r13, r14
    jmp  .asm_loop
.asm_end:
    call par_advance
    mov  rax, r12
    jmp  .ret_ok

; --- break; ---
.breakst:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_BREAK
    call ast_alloc
    jmp  .ret_ok

; --- continue; ---
.continuest:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, AST_CONTINUE
    call ast_alloc
    jmp  .ret_ok

; --- nested block ---
.nested:
    call parse_block_ast
    jmp  .ret_ok

; --- expression statement / assignment ---
.exprst:
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r12, rax                    ; lhs / expr
    call par_cur_type
    cmp  rax, TOK_ASSIGN
    je   .plain_assign
    ; Compound assignment: 'x += e' is built as 'x = x + e', reusing the
    ; destination node on both sides.  r14 holds the arithmetic token.
    mov  r14, TOK_PLUS
    cmp  rax, TOK_PLUS_ASSIGN
    je   .compound
    mov  r14, TOK_MINUS
    cmp  rax, TOK_MINUS_ASSIGN
    je   .compound
    mov  r14, TOK_STAR
    cmp  rax, TOK_STAR_ASSIGN
    je   .compound
    mov  r14, TOK_SLASH
    cmp  rax, TOK_SLASH_ASSIGN
    je   .compound
    mov  r14, TOK_CARET
    cmp  rax, TOK_XOR_ASSIGN
    je   .compound
    jmp  .expr_semi
.compound:
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r14
    mov  r13, rax
    jmp  .assign_tail
.plain_assign:
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err
    mov  r13, rax                    ; rhs
.assign_tail:
    call par_cur_type
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rdi, r12
    mov  rsi, r13
    call par_make_assign             ; or slice_set(...) for a slice element
    test rax, rax
    jz   .err
    jmp  .ret_ok
.expr_semi:
    mov  qword [rel par_expected], TOK_SEMICOLON
    cmp  rax, TOK_SEMICOLON
    jne  .err
    call par_advance
    mov  rax, r12                    ; the expression itself is the statement
    jmp  .ret_ok

.err_pop:
    pop  rcx
.err:
    xor  rax, rax
.ret_ok:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_opt_paren_expr_ast() -> rax = expr node (or 0)
; ==============================================================================
parse_opt_paren_expr_ast:
    ; There is no special case for a leading '(' any more. It used to swallow
    ; the parenthesis and demand the closing one straight after, so a
    ; condition that merely STARTED with a group -- 'if (a & 12) == 12' --
    ; could not continue past the ')'. The ordinary expression parser already
    ; treats '(' as grouping in a primary, and re-enables struct literals
    ; inside, so letting it do the work fixes the shape and drops a branch.
    ;
    ; A bare condition runs right up to the '{' of the block, so a struct
    ; literal cannot be told apart from it out here.
    inc  qword [rel par_no_slit]
    call parse_expression_ast
    mov  rcx, rax
    dec  qword [rel par_no_slit]
    mov  rax, rcx
    ret

; par_builtin_type(rdi = name token) -> eax = 1 'text', 2 'list', 3 'map',
; 0 for any other name. Preserves every other register.
par_builtin_type:
    push rcx
    push rsi
    mov  ecx, dword [rdi + TOKEN.length]
    mov  rsi, [rdi + TOKEN.value]
    cmp  ecx, 4
    je   .bt4
    cmp  ecx, 3
    jne  .bt_no
    cmp  word [rsi], 'ma'
    jne  .bt_no
    cmp  byte [rsi+2], 'p'
    jne  .bt_no
    mov  eax, 3
    jmp  .bt_out
.bt4:
    cmp  dword [rsi], 'text'
    je   .bt_text
    cmp  dword [rsi], 'list'
    jne  .bt_no
    mov  eax, 2
    jmp  .bt_out
.bt_text:
    mov  eax, 1
    jmp  .bt_out
.bt_no:
    xor  eax, eax
.bt_out:
    pop  rsi
    pop  rcx
    ret

; par_note_pstruct(rdi = the name token of a declaration just typed): when
; the type was ptr<S> with S a name, the pair goes in par_ps_*.
; Preserves every register but rax.
par_note_pstruct:
    mov  rax, [rel par_last_ptr_tok]
    test rax, rax
    jz   .np_out
    test rdi, rdi
    jz   .np_out
    push rcx
    push rdx
    mov  ecx, [rel par_ps_n]
    cmp  ecx, 8192
    jae  .np_full
    lea  rdx, [rel par_ps_decl]
    mov  [rdx + rcx*8], rdi
    lea  rdx, [rel par_ps_type]
    mov  [rdx + rcx*8], rax
    inc  ecx
    mov  [rel par_ps_n], ecx
.np_full:
    pop  rdx
    pop  rcx
.np_out:
    ret

; ==============================================================================
; parse_type() -> rax = 1/0 (consumes type tokens; builds no node)
; ==============================================================================
parse_type:
    mov  qword [rel par_last_ptr_tok], 0
    mov  qword [rel par_last_coll_stok], 0
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    ; Reset the array length too. Only the '[' branch used to clear it, so a
    ; scalar type parsed after an array declaration inherited that length --
    ; harmless while nobody read it on a parameter, fatal once they did.
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_is_slice], 0
    mov  qword [rel par_last_arr_elem], 0
    mov  qword [rel par_last_vtag], 0
    call par_cur_type
    cmp  rax, TOK_LBRACKET
    je   .arr_type
    cmp  rax, KW_PTR
    je   .ptr_type
    cmp  rax, KW_SLICE
    je   .slice_type
    cmp  rax, KW_ARENA_TOKEN
    je   .arena_tok_type
    cmp  rax, TOK_KW_FN
    je   .fn_type
    cmp  rax, TOK_IDENT
    je   .ident_type
    cmp  rax, KW_U8
    je   .ok
    cmp  rax, KW_U16
    je   .ok
    cmp  rax, KW_U32
    je   .ok
    cmp  rax, KW_U64
    je   .ok
    cmp  rax, KW_I8
    je   .ok
    cmp  rax, KW_I16
    je   .ok
    cmp  rax, KW_I32
    je   .ok
    cmp  rax, KW_I64
    je   .ok
    cmp  rax, KW_F32
    je   .ok
    cmp  rax, KW_F64
    je   .ok
    cmp  rax, KW_BOOL
    je   .ok
    cmp  rax, KW_STR
    je   .ok
    cmp  rax, KW_VOID
    je   .ok
    xor  rax, rax
    ret
.ok:
    ; Before consuming, record whether this scalar type is float or unsigned.
    ; Nothing recorded the sign until now: u8..u64 were i64 under another
    ; name, so every comparison emitted setl/setg, every division idiv and
    ; every '>>' sar. An address above 2^63 compared as negative.
    call par_cur_type
    cmp  rax, KW_F32
    je   .ok_float
    cmp  rax, KW_F64
    je   .ok_float
    cmp  rax, KW_U8
    je   .ok_unsigned
    cmp  rax, KW_U16
    je   .ok_unsigned
    cmp  rax, KW_U32
    je   .ok_unsigned
    cmp  rax, KW_U64
    je   .ok_unsigned
    call par_advance
    mov  rax, 1
    ret
.ok_float:
    mov  qword [rel par_last_is_float], 1
    call par_advance
    mov  rax, 1
    ret
.ok_unsigned:
    mov  qword [rel par_last_is_unsigned], 1
    call par_advance
    mov  rax, 1
    ret

; --- text, list<T>, map<T>: built into the language, values held as one i64
; (a handle of std_text, std_list, std_map). Any other name is a struct.
.ident_type:
    call par_current_token
    mov  rdi, rax
    call par_builtin_type            ; eax = 1 text, 2 list, 3 map, 0 neither
    test eax, eax
    jz   .ok
    cmp  eax, 1
    jne  .coll_type
    mov  qword [rel par_last_vtag], 1
    mov  dword [rel par_used_text], 1
    jmp  .ok
.coll_type:
    push rax                         ; 2 list, 3 map
    call par_advance                 ; consume 'list' / 'map'
    call par_cur_type
    cmp  rax, TOK_LT
    jne  .coll_err
    call par_advance
    ; list<S> with S a name that is no built-in type: kept (tag 3)
    xor  eax, eax
    push rax
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .coll_elem
    call par_current_token
    mov  rdi, rax
    push rax
    call par_builtin_type
    pop  rcx
    test eax, eax
    jnz  .coll_elem
    mov  [rsp], rcx
.coll_elem:
    call parse_type                  ; the element type
    test rax, rax
    jz   .coll_err_pop
    ; the element's tag: 2 real, 1 text, 0 an integer or a handle, 3 a name
    pop  rax
    mov  [rel par_last_coll_stok], rax
    xor  ecx, ecx
    test rax, rax
    jz   .coll_unnamed
    mov  ecx, 3
    jmp  .coll_tag
.coll_unnamed:
    cmp  qword [rel par_last_is_float], 0
    je   .coll_nf
    mov  ecx, 2
    jmp  .coll_tag
.coll_nf:
    mov  rax, [rel par_last_vtag]
    cmp  rax, 1
    jne  .coll_tag
    mov  ecx, 1
.coll_tag:
    push rcx
    call par_cur_type
    pop  rcx
    cmp  rax, TOK_GT
    jne  .coll_err
    call par_advance
    pop  rax
    shl  ecx, 4
    or   eax, ecx
    mov  [rel par_last_vtag], rax
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_ptr_elem], 0
    mov  qword [rel par_last_arr_elem], 0
    and  eax, 15
    cmp  eax, 2
    jne  .coll_map
    mov  dword [rel par_used_list], 1
    mov  rax, 1
    ret
.coll_map:
    mov  dword [rel par_used_map], 1
    mov  rax, 1
    ret
.coll_err_pop:
    pop  rax
.coll_err:
    pop  rax
    mov  qword [rel par_last_vtag], 0
    xor  rax, rax
    ret

; --- fn(T1, T2) -> R: a function value. The tag is 5, with what it returns
; as the element: 2 a real, 1 a text, 0 anything else.
.fn_type:
    call par_advance                 ; 'fn'
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .fnt_err
    call par_advance
.fnt_param:
    call par_cur_type
    cmp  rax, TOK_RPAREN
    je   .fnt_close
    call parse_type
    test rax, rax
    jz   .fnt_err
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .fnt_param
    call par_advance
    jmp  .fnt_param
.fnt_close:
    call par_advance
    xor  ecx, ecx                    ; what it returns: nothing said, an integer
    call par_cur_type
    cmp  rax, TOK_ARROW
    jne  .fnt_done
    call par_advance
    mov  qword [rel par_last_is_float], 0
    call parse_type
    test rax, rax
    jz   .fnt_err
    xor  ecx, ecx
    cmp  qword [rel par_last_is_float], 0
    je   .fnt_nf
    mov  ecx, 2
    jmp  .fnt_done
.fnt_nf:
    cmp  qword [rel par_last_vtag], 1
    jne  .fnt_done
    mov  ecx, 1
.fnt_done:
    shl  ecx, 4
    or   ecx, 5
    mov  [rel par_last_vtag], rcx
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_ptr_elem], 0
    mov  qword [rel par_last_arr_elem], 0
    mov  rax, 1
    ret
.fnt_err:
    mov  qword [rel par_last_vtag], 0
    xor  rax, rax
    ret

; --- ptr<T> : pointer type. Leaves sizeof(T) in par_last_ptr_elem ---
.ptr_type:
    mov  qword [rel par_last_ptr_elem], 0
    call par_advance                 ; consume 'ptr'
    call par_cur_type
    cmp  rax, TOK_LT
    jne  .ptr_err
    call par_advance
    ; ptr<S> with S a name: kept, so a declaration can list it (p.x then
    ; reaches a field of the S it points to). The inner parse_type clears
    ; it, so it is set again once that returns.
    xor  eax, eax
    push rax
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .ptr_noname
    call par_current_token
    mov  [rsp], rax
.ptr_noname:
    ; width of the pointed-to type
    call par_cur_type
    call par_type_width              ; -> rax = bytes (0 if not a known type)
    test rax, rax
    jz   .ptr_err_pop
    mov  [rel par_last_ptr_elem], rax
    call parse_type                  ; consume the element type
    test rax, rax
    jz   .ptr_err_pop
    pop  rax
    mov  [rel par_last_ptr_tok], rax
    ; the pointer itself is an address, whatever it points to: ptr<f32>
    ; is no real, ptr<u8> no unsigned byte
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    call par_cur_type
    cmp  rax, TOK_GT
    jne  .ptr_err
    call par_advance
    mov  rax, 1
    ret
.ptr_err_pop:
    pop  rax
.ptr_err:
    mov  qword [rel par_last_ptr_elem], 0
    mov  qword [rel par_last_ptr_tok], 0
    xor  rax, rax
    ret

; --- slice<T> : a run of an arena (std_arena.kr). The variable holds one i64;
; v[i] and v[i] = x are turned into slice_get / slice_set calls, which check
; the index and that the arena was not freed. Integers only: a float slice
; would hand back its bits as an integer.
.slice_type:
    call par_advance                 ; consume 'slice'
    call par_cur_type
    cmp  rax, TOK_LT
    jne  .slice_err
    call par_advance
    call parse_type                  ; the element type
    test rax, rax
    jz   .slice_err
    ; slice<f64>: the handle is an integer; its elements are reals
    mov  rcx, [rel par_last_is_float]
    push rcx
    mov  qword [rel par_last_is_float], 0
    call par_cur_type
    pop  rcx
    cmp  rax, TOK_GT
    jne  .slice_err
    push rcx
    call par_advance
    pop  rcx
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_ptr_elem], 0
    mov  qword [rel par_last_vtag], 0
    mov  qword [rel par_last_is_slice], 1
    test rcx, rcx
    jz   .slice_ok
    mov  qword [rel par_last_is_slice], 2
.slice_ok:
    mov  rax, 1
    ret
.slice_err:
    xor  rax, rax
    ret

; --- ArenaAllocationToken<IDENTIFIER> : handle into a named arena (M03).
; The grammar takes an IDENTIFIER between the angle brackets -- the name of an
; arena declared in a heap_arena_definition -- not a type. Compare the sibling
; productions: KronTensor takes a rawHardwareType, this one does not.
; The handle is a machine word with no element type, so par_last_ptr_elem stays
; zero and no pointer-arithmetic scaling is applied to it.
.arena_tok_type:
    mov  qword [rel par_last_ptr_elem], 0
    call par_advance                 ; consume 'ArenaAllocationToken'
    call par_cur_type
    cmp  rax, TOK_LT
    jne  .arena_tok_err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_IDENT              ; the arena name
    jne  .arena_tok_err
    call par_advance
    call par_cur_type
    cmp  rax, TOK_GT
    jne  .arena_tok_err
    call par_advance
    mov  qword [rel par_last_is_float], 0   ; the handle is never a float
    mov  rax, 1
    ret
.arena_tok_err:
    mov  qword [rel par_last_ptr_elem], 0
    xor  rax, rax
    ret

; --- [type; N] : array type. Leaves N in par_last_array_len ---
.arr_type:
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_row_len], 0
    call par_advance                 ; consume '['
    ; float element type? mark the variable as float so indexed
    ; reads/writes use the xmm path in the codegen
    call par_cur_type
    cmp  rax, KW_F32
    je   .arr_mark_float
    cmp  rax, KW_F64
    jne  .arr_no_float
.arr_mark_float:
    mov  qword [rel par_last_is_float], 1
.arr_no_float:
    ; The element's width: [u8; N] keeps one byte per element, [f32; N] four.
    ; A nested '[' leaves the width the inner array records; a struct name
    ; counts as eight, as before.
    call par_cur_type
    cmp  rax, TOK_LBRACKET
    je   .arr_w_inner
    call par_type_width              ; rax = 1, 2, 4, 8, or 0 when unknown
    jmp  .arr_w_have
.arr_w_inner:
    xor  eax, eax
.arr_w_have:
    push rax
    call parse_type                  ; element type
    pop  rcx
    test rax, rax
    jz   .arr_err
    ; [text; N]: an array whose elements print as texts
    mov  rax, [rel par_last_vtag]
    cmp  rax, 1
    jne  .arr_novt
    mov  qword [rel par_last_vtag], 0x14
    jmp  .arr_vt_done
.arr_novt:
    mov  qword [rel par_last_vtag], 0
.arr_vt_done:
    test rcx, rcx
    jz   .arr_w_kept
    mov  [rel par_last_arr_elem], rcx
.arr_w_kept:
    ; If the element was itself an array, parse_type left ITS length behind.
    ; A 2-D array is stored flat, row by row, so the total is the product and
    ; the inner length is the row stride.
    ; through a register: kasm's push takes a 64-bit register and nothing
    ; else, so 'push qword [rel X]' would stop the kasm build.
    mov  rcx, [rel par_last_array_len]
    push rcx
    call par_cur_type
    cmp  rax, TOK_SEMICOLON
    jne  .arr_err_pop
    call par_advance
    call par_cur_type
    cmp  rax, TOK_NUMBER
    je   .arr_len
    cmp  rax, TOK_HEX
    je   .arr_len
    jmp  .arr_err_pop
.arr_len:
    call par_current_token
    push rax
    mov  rdi, rax
    call tok_to_uint
    pop  rcx                         ; the number token, discarded
    pop  rcx                         ; inner length, 0 when the element is scalar
    test rcx, rcx
    jz   .arr_flat
    mov  [rel par_last_row_len], rcx
    imul rax, rcx                    ; total elements = rows * columns
.arr_flat:
    mov  [rel par_last_array_len], rax
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RBRACKET
    jne  .arr_err
    call par_advance
    mov  rax, 1
    ret
.arr_err_pop:
    pop  rcx
.arr_err:
    mov  qword [rel par_last_array_len], 0
    mov  qword [rel par_last_row_len], 0
    xor  rax, rax
    ret

; tok_to_uint(rdi = token) -> rax = integer value (decimal or 0x hex)
tok_to_uint:
    push rbx
    push rsi
    push rcx
    mov  rsi, [rdi + TOKEN.value]
    mov  ecx, dword [rdi + TOKEN.length]
    xor  rax, rax
    test ecx, ecx
    jz   .tu_done
    cmp  ecx, 2
    jbe  .tu_dec
    cmp  byte [rsi], '0'
    jne  .tu_dec
    mov  bl, [rsi+1]
    cmp  bl, 'x'
    je   .tu_hex
    cmp  bl, 'X'
    je   .tu_hex
.tu_dec:
    xor  rax, rax
.tu_dl:
    test ecx, ecx
    jz   .tu_done
    movzx rbx, byte [rsi]
    cmp  bl, '0'
    jb   .tu_done
    cmp  bl, '9'
    ja   .tu_done
    sub  bl, '0'
    imul rax, rax, 10
    add  rax, rbx
    inc  rsi
    dec  ecx
    jmp  .tu_dl
.tu_hex:
    add  rsi, 2
    sub  ecx, 2
    xor  rax, rax
.tu_hl:
    test ecx, ecx
    jz   .tu_done
    movzx rbx, byte [rsi]
    cmp  bl, '0'
    jb   .tu_done
    cmp  bl, '9'
    ja   .tu_haf
    sub  bl, '0'
    jmp  .tu_hadd
.tu_haf:
    or   bl, 0x20
    cmp  bl, 'a'
    jb   .tu_done
    cmp  bl, 'f'
    ja   .tu_done
    sub  bl, 'a' - 10
.tu_hadd:
    shl  rax, 4
    add  rax, rbx
    inc  rsi
    dec  ecx
    jmp  .tu_hl
.tu_done:
    pop  rcx
    pop  rsi
    pop  rbx
    ret

; ==============================================================================
; EXPRESSIONS (build AST_BINOP / AST_UNOP / literals)
; parse_expression_ast -> comparison -> additive -> multiplicative -> unary -> postfix -> primary
; par_type_width(rax = type token type) -> rax = width in bytes, 0 if unknown
par_type_width:
    cmp  rax, KW_U8
    je   .w1
    cmp  rax, KW_I8
    je   .w1
    cmp  rax, KW_BOOL
    je   .w1
    cmp  rax, KW_U16
    je   .w2
    cmp  rax, KW_I16
    je   .w2
    cmp  rax, KW_U32
    je   .w4
    cmp  rax, KW_I32
    je   .w4
    cmp  rax, KW_F32
    je   .w4
    cmp  rax, KW_U64
    je   .w8
    cmp  rax, KW_I64
    je   .w8
    cmp  rax, KW_F64
    je   .w8
    cmp  rax, TOK_IDENT
    je   .w8
    xor  rax, rax
    ret
.w1:
    mov  rax, 1
    ret
.w2:
    mov  rax, 2
    ret
.w4:
    mov  rax, 4
    ret
.w8:
    mov  rax, 8
    ret


; ==============================================================================
parse_expression_ast:
    jmp  parse_logical_ast

; ==============================================================================
; Bitwise levels. C precedence, loosest first: || && | ^ & == != < > << >> + -
;
; These three were missing entirely. TOK_PIPE was emitted by the lexer and
; read by nobody, so a language meant for kernels had no bit masks: a page
; table entry could not be assembled from its flags.
;
; Binary '&' does not clash with address-of. '&x' is prefix and parsed in
; parse_unary_ast; this level only looks for '&' once a left operand is in
; hand.
; ==============================================================================
parse_bitor_ast:
    push r12
    push r13
    call parse_bitxor_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_PIPE
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_bitxor_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_bitxor_ast:
    push r12
    push r13
    call parse_bitand_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_CARET
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_bitand_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_bitand_ast:
    push r12
    push r13
    call parse_comparison_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_AMPERSAND
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_bitor_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_logical_ast:
    push r12
    push r13
    call parse_bitor_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_AND
    je   .op
    cmp  r13, TOK_OR
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_comparison_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_comparison_ast:
    push r12
    push r13
    call parse_shift_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_EQ
    je   .op
    cmp  r13, TOK_NEQ
    je   .op
    cmp  r13, TOK_LT
    je   .op
    cmp  r13, TOK_GT
    je   .op
    cmp  r13, TOK_LTE
    je   .op
    cmp  r13, TOK_GTE
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_shift_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_shift_ast:
    push r12
    push r13
    call parse_additive_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_LSHIFT
    je   .op
    cmp  r13, TOK_RSHIFT
    je   .op
    cmp  r13, TOK_URSHIFT
    je   .op
    cmp  r13, KW_ROTL
    je   .op
    cmp  r13, KW_ROTR
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_additive_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_additive_ast:
    push r12
    push r13
    call parse_multiplicative_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_PLUS
    je   .op
    cmp  r13, TOK_MINUS
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_multiplicative_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

; ==============================================================================
; parse_cast_ast() -> rax = node
;   unaryExpression ( 'as' type )*
;
; Sits between the unary level and the multiplicative one, so that
;     -x as f64      is  (-x) as f64
;     a + b as f64   is  a + (b as f64)
;
; The node records the TARGET type, not the source: col carries the same two
; flags as a declaration (bit0 float, bit1 unsigned) and type_info the width
; in bytes. Codegen needs both to pick between cvtsi2sd, cvttsd2si and a
; plain narrowing.
; ==============================================================================
parse_cast_ast:
    push r12
    push r13
    push r14
    call parse_unary_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    cmp  rax, KW_AS
    jne  .done
    call par_advance
    ; width of the target type, taken before parse_type consumes it
    call par_cur_type
    call par_type_width
    mov  r14, rax                    ; 0 when the type has no scalar width
    mov  qword [rel par_last_is_float], 0
    mov  qword [rel par_last_is_unsigned], 0
    call parse_type
    test rax, rax
    jz   .err
    mov  rdi, AST_CAST
    call ast_alloc
    test rax, rax
    jz   .err
    mov  [rax + AST.right], r12
    mov  [rax + AST.type_info], r14
    movzx ecx, word [rel par_last_is_float]
    and  ecx, 1
    movzx edx, word [rel par_last_is_unsigned]
    and  edx, 1
    shl  edx, 1
    or   ecx, edx
    mov  [rax + AST.col], cx
    mov  r12, rax
    jmp  .loop
.done:
    mov  rax, r12
    pop  r14
    pop  r13
    pop  r12
    ret
.err:
    xor  rax, rax
    pop  r14
    pop  r13
    pop  r12
    ret

parse_multiplicative_ast:
    push r12
    push r13
    call parse_cast_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    mov  r13, rax
    cmp  r13, TOK_STAR
    je   .op
    cmp  r13, TOK_SLASH
    je   .op
    cmp  r13, TOK_PERCENT
    je   .op
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.op:
    call par_advance
    call parse_cast_ast
    test rax, rax
    jz   .err
    push rax
    mov  rdi, AST_BINOP
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.left], r12
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], r13
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    pop  r13
    pop  r12
    ret

parse_unary_ast:
    call par_cur_type
    cmp  rax, TOK_MINUS
    je   .un
    cmp  rax, TOK_NOT
    je   .un
    cmp  rax, TOK_TILDE
    je   .un
    cmp  rax, KW_INVCACHE
    je   .un
    cmp  rax, KW_PREFETCH0
    je   .un
    cmp  rax, TOK_AMPERSAND
    je   .addr_of
    cmp  rax, TOK_STAR
    je   .deref
    cmp  rax, TOK_CALL
    je   .call_indirect
    jmp  parse_postfix_ast

; --- &name : address of a variable ---
.addr_of:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    cmp  rax, TOK_IDENT
    jne  .err
    call par_current_token
    push rax
    call par_advance
    ; '&name[i]' -- the address of one element, which is what a SIMD load
    ; needs. Without it '&' stopped at the name and the '[' was a syntax
    ; error.
    call par_cur_type
    cmp  rax, TOK_LBRACKET
    jne  .ao_plain
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .err_pop
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RBRACKET
    cmp  rax, TOK_RBRACKET
    jne  .ao_err2
    call par_advance
    mov  rdi, AST_ADDR_OF
    call ast_alloc
    test rax, rax
    jz   .ao_err2
    pop  rcx
    mov  [rax + AST.right], rcx      ; the index
    pop  rcx
    mov  [rax + AST.data], rcx       ; the array name
    ret
.ao_err2:
    pop  rcx
    jmp  .err_pop
.ao_plain:
    mov  rdi, AST_ADDR_OF
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.data], rcx
    ret

; --- *expr : read the pointed-to memory ---
; The '*' token goes in AST.data: *p reads memory by address, so it belongs
; inside raw { }, and an error has to be able to point at it.
.deref:
    call par_current_token
    push rax                         ; the '*' token
    call par_advance
    call parse_unary_ast
    test rax, rax
    jz   .deref_err
    push rax
    mov  rdi, AST_DEREF
    call ast_alloc
    test rax, rax
    jz   .deref_err2
    pop  rcx
    mov  [rax + AST.right], rcx
    pop  rcx
    mov  [rax + AST.data], rcx
    ret
.deref_err2:
    pop  rcx
.deref_err:
    pop  rcx
    jmp  .err

; --- call expr(args) : indirect call through a function pointer ---
; expr is parsed as a primary only (identifier, or name[idx] which
; parse_primary_ast's .ident/.idx already builds as one AST_INDEX node),
; deliberately NOT parse_postfix_ast, so a following '(' here is always
; the indirect-call's argument list and never mistaken for a direct call.
.call_indirect:
    push r12
    call par_advance                 ; consume 'call'
    call parse_primary_ast           ; -> pointer expression node
    test rax, rax
    jz   .ci_err
    mov  r12, rax
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .ci_err
    call parse_arg_list              ; consumes '(' ... ')' itself
    cmp  rax, -1
    je   .ci_err
    push rax
    mov  rdi, AST_CALL_INDIRECT
    call ast_alloc
    test rax, rax
    jz   .ci_err_pop
    pop  rcx
    mov  [rax + AST.right], rcx      ; argument list
    mov  [rax + AST.left],  r12      ; pointer expression
    pop  r12
    ret
.ci_err_pop:
    pop  rcx
.ci_err:
    pop  r12
    xor  rax, rax
    ret

.un:
    ; Record WHICH operator this was.  '-', '!' and '~' all land here and the
    ; node carried no discriminator, so the codegen negated all of them alike
    ; -- '!x' came out as 'neg x'.  The token type goes in AST.data.
    call par_cur_type
    push rax
    call par_advance
    call parse_unary_ast
    test rax, rax
    jz   .err_pop
    push rax
    mov  rdi, AST_UNOP
    call ast_alloc
    test rax, rax
    jz   .err_pop2
    pop  rcx
    pop  rdx
    mov  [rax + AST.right], rcx
    mov  [rax + AST.data], rdx     ; TOK_MINUS / TOK_NOT / TOK_TILDE
    ret
.err_pop2:
    pop  rcx
.err_pop:
    pop  rcx
.err:
    xor  rax, rax
    ret

; postfix: primary ( '(' args ')' | '[' idx ']' | '.' IDENT )*
parse_postfix_ast:
    push r12
    call parse_primary_ast
    test rax, rax
    jz   .err
    mov  r12, rax
.loop:
    call par_cur_type
    cmp  rax, TOK_LPAREN
    je   .call
    cmp  rax, TOK_LBRACKET
    je   .index
    cmp  rax, TOK_DOT
    je   .member
    mov  rax, r12
    pop  r12
    ret
.call:
    ; s.field(...): the call would go to s itself; refused, with the way
    ; that works, rather than compiled into a jump to the wrong address
    cmp  qword [r12 + AST.node_type], AST_MEMBER
    jne  .call_args
    lea  rax, [rel msg_field_call]
    mov  [rel par_custom_msg], rax
    jmp  .err
.call_args:
    call parse_arg_list              ; -> rax = argument list
    cmp  rax, -1
    je   .err
    push rax
    mov  rdi, AST_CALL
    call ast_alloc
    test rax, rax
    jz   .err_pop
    pop  rcx
    mov  [rax + AST.right], rcx      ; argument list
    ; inherit the base identifier token
    mov  rcx, [r12 + AST.data]
    mov  [rax + AST.data], rcx
    mov  r12, rax
    jmp  .loop
.err_pop:
    pop  rcx
    jmp  .err
.index:
    call consume_balanced_brackets
    test rax, rax
    jz   .err
    jmp  .loop
.member:
    call par_advance                 ; consume '.'
    call par_cur_type
    mov  qword [rel par_expected], TOK_IDENT
    call par_is_field_name
    jz   .err
    call par_current_token
    push rax                         ; field name token
    call par_advance
    mov  rdi, AST_MEMBER
    call ast_alloc
    test rax, rax
    jz   .mem_err
    pop  rcx
    mov  [rax + AST.left], rcx       ; field name token
    mov  rcx, [r12 + AST.data]
    mov  [rax + AST.data], rcx       ; base variable token, carried along
    ; Link to the node this one reads FROM. Without it a chain like m.v.x
    ; built two nodes that both named 'm' and the middle field was lost, so
    ; m.v.x compiled to m.x without a word.
    mov  rcx, [r12 + AST.node_type]
    cmp  rcx, AST_MEMBER
    jne  .mem_first
    mov  [rax + AST.right], r12
.mem_first:
    mov  r12, rax
    jmp  .loop
.mem_err:
    pop  rcx
    jmp  .err
.err:
    xor  rax, rax
    pop  r12
    ret

parse_primary_ast:
    ; syscall(...) is an expression now: its result is rax
    call par_is_syscall
    test rax, rax
    jnz  parse_syscall_expr
    call par_cur_type
    cmp  rax, TOK_KW_FN
    je   parse_lambda_ast
    cmp  rax, KW_ARG_COUNT
    je   .argcount_expr
    cmp  rax, KW_TARGET_OS
    je   .targetos_expr
    cmp  rax, KW_ARG_GET
    je   .argget_expr
    cmp  rax, KW_FAILED
    je   .failed_expr
    cmp  rax, KW_SIZEOF
    je   .sizeof_expr
    cmp  rax, KW_LOADFILE
    je   .loadfile_expr
    cmp  rax, KW_THREAD_START
    je   .thstart_expr
    cmp  rax, KW_CPU_COUNT
    je   .cpucount_expr
    cmp  rax, KW_THREAD_YIELD
    je   .yield_expr
    cmp  rax, KW_DLL_LOAD
    je   .dllload_expr
    cmp  rax, KW_DLL_PROC
    je   .dllproc_expr
    cmp  rax, KW_TICKS
    je   .ticks_expr
    cmp  rax, KW_TICKS_PER_SEC
    je   .tickrate_expr
    cmp  rax, KW_VEC2_LOAD
    je   .v2load_expr
    cmp  rax, KW_VEC2_ADD
    je   .v2add_expr
    cmp  rax, KW_VEC2_SUB
    je   .v2sub_expr
    cmp  rax, KW_VEC2_MUL
    je   .v2mul_expr
    cmp  rax, TOK_LBRACKET
    je   .arraylit_expr
    cmp  rax, KW_READKEY
    je   .readkey_expr
    cmp  rax, KW_READMOUSE
    je   .readmouse_expr
    cmp  rax, KW_MOUSEX
    je   .mousex_expr
    cmp  rax, KW_MOUSEY
    je   .mousey_expr
    cmp  rax, KW_INB
    je   .inb_expr
    cmp  rax, KW_PEEK
    je   .peek_expr
    cmp  rax, KW_TRUNC
    je   .trunc_expr
    cmp  rax, KW_PEEK8
    je   .peek8_expr
    cmp  rax, KW_PEEK16
    je   .peek16_expr
    cmp  rax, KW_PEEK32
    je   .peek32_expr
    cmp  rax, TOK_NUMBER
    je   .int_lit
    cmp  rax, TOK_INTEGER
    je   .int_lit
    cmp  rax, TOK_HEX
    je   .int_lit
    cmp  rax, TOK_FLOAT
    je   .float_lit
    cmp  rax, TOK_STRING
    je   .str_lit
    cmp  rax, TOK_BOOLEAN
    je   .bool_lit
    ; 'true' and 'false' reach the lexer as KW_TRUE and KW_FALSE, never as
    ; TOK_BOOLEAN, so the branch above was dead and neither word could appear
    ; in an expression at all: 'a = true;' did not parse.
    cmp  rax, KW_TRUE
    je   .true_lit
    cmp  rax, KW_FALSE
    je   .false_lit
    cmp  rax, TOK_IDENT
    je   .ident
    cmp  rax, TOK_LPAREN
    je   .paren
    ; nothing here can start an expression: say so, rather than leaving the
    ; caller's last expectation (often the '=' already read) in the message
    mov  qword [rel par_expected], TOK_EXPECT_EXPR
    xor  rax, rax
    ret

; --- inb(port) and peek(address) : read hardware, return a value ---
.readmouse_expr:
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, AST_READMOUSE
    call ast_alloc
    test rax, rax
    jz   .perr
    ret
.mousex_expr:
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, AST_MOUSEX
    call ast_alloc
    test rax, rax
    jz   .perr
    ret
.mousey_expr:
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, AST_MOUSEY
    call ast_alloc
    test rax, rax
    jz   .perr
    ret
.v2load_expr:
    ; vec2_load(addr) -> four floats in an xmm register.
    ; The node type travels on the stack: parse_primary_ast preserves no
    ; registers, and r15 carries the declared type token all the way down
    ; from parse_var_decl.
    mov  rcx, AST_VEC2_LOAD
    push rcx                         ; kasm's push takes a register, not an immediate
    jmp  .v2_one
.v2add_expr:
    mov  rcx, AST_VEC2_ADD
    push rcx                         ; kasm's push takes a register, not an immediate
    jmp  .v2_two
.v2sub_expr:
    mov  rcx, AST_VEC2_SUB
    push rcx                         ; kasm's push takes a register, not an immediate
    jmp  .v2_two
.v2mul_expr:
    mov  rcx, AST_VEC2_MUL
    push rcx                         ; kasm's push takes a register, not an immediate
    jmp  .v2_two

.v2_one:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .v2_drop1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .v2_drop1
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .v2_err1
    call par_advance
    pop  rdx                         ; the operand
    pop  rdi                         ; the node type
    push rdx
    call ast_alloc
    test rax, rax
    jz   .v2_err1a
    pop  rcx
    mov  [rax + AST.right], rcx
    ret
.v2_err1a:
    pop  rcx
    jmp  .perr
.v2_err1:
    pop  rcx                         ; operand
.v2_drop1:
    pop  rcx                         ; node type
    jmp  .perr

.v2_two:
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .v2_drop1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .v2_drop1
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .v2_err1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .v2_err1
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .v2_err2
    call par_advance
    pop  rdx                         ; second operand
    pop  r8                          ; first operand
    pop  rdi                         ; node type
    push r8
    push rdx
    call ast_alloc
    test rax, rax
    jz   .v2_err2a
    pop  rcx
    mov  [rax + AST.right], rcx      ; second operand
    pop  rcx
    mov  [rax + AST.left], rcx       ; first operand
    ret
.v2_err2a:
    pop  rcx
    pop  rcx
    jmp  .perr
.v2_err2:
    pop  rcx                         ; second operand
    pop  rcx                         ; first operand
    pop  rcx                         ; node type
    jmp  .perr

.ticks_expr:
    ; ticks() and ticks_per_sec(): the two halves of a stopwatch. Both take
    ; no arguments, so they share the shape of cpu_count.
    mov  rcx, AST_TICKS
    mov  [rel par_thread_node], rcx
    jmp  .noarg_expr
.tickrate_expr:
    mov  rcx, AST_TICKS_PER_SEC
    mov  [rel par_thread_node], rcx
    jmp  .noarg_expr
.noarg_expr:
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, [rel par_thread_node]
    call ast_alloc
    ret

.argcount_expr:
    ; arg_count() -> how many command-line arguments, the program's own path
    ; included: a program run with no arguments sees 1.
    mov  rcx, AST_ARG_COUNT
    mov  [rel par_thread_node], rcx
    jmp  .noarg_expr
.targetos_expr:
    ; target_os() -> 1 Windows, 2 Linux, 3 krn, 4 bare. A constant the
    ; compiler fills in, so a library can pick its system path at run time
    ; without two copies of the source.
    mov  rcx, AST_TARGET_OS
    mov  [rel par_thread_node], rcx
    jmp  .noarg_expr
.argget_expr:
    ; arg_get(i) -> the address of argument i, a NUL-terminated string, as
    ; std_str expects. Outside the range it is an empty string, never garbage.
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .perr
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .ag_e1
    call par_advance
    mov  rdi, AST_ARG_GET
    call ast_alloc
    test rax, rax
    jz   .ag_e1
    pop  rcx
    mov  [rax + AST.right], rcx
    ret
.ag_e1:
    pop  rcx
    jmp  .perr

.cpucount_expr:
    ; cpu_count() -> how many cores the machine has, so a program can decide
    ; how many threads to start instead of guessing.
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, AST_CPU_COUNT
    call ast_alloc
    ret

.dllload_expr:
    ; dll_load("x.dll") -> a library handle, 0 if it cannot be loaded. Only
    ; inside raw: the keyword token goes in AST.data so the error can point at it.
    call par_current_token
    push rax                         ; keyword token
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .dl_e1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .dl_e1
    push rax                         ; name
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .dl_e2
    call par_advance
    mov  rdi, AST_DLL_LOAD
    call ast_alloc
    test rax, rax
    jz   .dl_e2
    pop  rcx
    mov  [rax + AST.right], rcx      ; name
    pop  rcx
    mov  [rax + AST.data], rcx       ; keyword
    ret
.dl_e2:
    pop  rcx
.dl_e1:
    pop  rcx
    jmp  .perr

.dllproc_expr:
    ; dll_proc(lib, "name") -> the function's address, 0 if not found. Only
    ; inside raw. Called through 'call ptr(args)', with the Windows convention.
    call par_current_token
    push rax                         ; keyword token
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .dp_e1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .dp_e1
    push rax                         ; library
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .dp_e2
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .dp_e2
    push rax                         ; name
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .dp_e3
    call par_advance
    mov  rdi, AST_DLL_PROC
    call ast_alloc
    test rax, rax
    jz   .dp_e3
    pop  rcx
    mov  [rax + AST.right], rcx      ; name
    pop  rcx
    mov  [rax + AST.left], rcx       ; library
    pop  rcx
    mov  [rax + AST.data], rcx       ; keyword
    ret
.dp_e3:
    pop  rcx
.dp_e2:
    pop  rcx
.dp_e1:
    pop  rcx
    jmp  .perr

.yield_expr:
    ; thread_yield() -> gives the rest of the time slice to another thread.
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, AST_THREAD_YIELD
    call ast_alloc
    ret

.thstart_expr:
    ; thread_start(&fn, arg) -> a handle, or 0 when the thread cannot start.
    ; The function takes one argument and its return value is discarded: a
    ; thread has nobody to return to.
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .perr
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .th_e1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .th_e1
    push rax
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .th_e2
    call par_advance
    mov  rdi, AST_THREAD_START
    call ast_alloc
    test rax, rax
    jz   .th_e2
    pop  rcx
    mov  [rax + AST.right], rcx      ; the argument
    pop  rcx
    mov  [rax + AST.left], rcx       ; the function address
    ret
.th_e2:
    pop  rcx
.th_e1:
    pop  rcx
    jmp  .perr

.loadfile_expr:
    ; loadfile(name, buffer, capacity) -> bytes read. An expression, not a
    ; statement: savefile has nothing to report, this does.
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .perr
    push rax                         ; name
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .lf_e1
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .lf_e1
    push rax                         ; buffer
    call par_cur_type
    mov  qword [rel par_expected], TOK_COMMA
    cmp  rax, TOK_COMMA
    jne  .lf_e2
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .lf_e2
    push rax                         ; capacity
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .lf_e3
    call par_advance
    mov  rdi, AST_LOADFILE
    call ast_alloc
    test rax, rax
    jz   .lf_e3
    pop  rcx
    mov  [rax + AST.right], rcx      ; capacity
    pop  rcx
    mov  [rax + AST.left], rcx       ; buffer
    pop  rcx
    mov  [rax + AST.data], rcx       ; name
    ret
.lf_e3:
    pop  rcx
.lf_e2:
    pop  rcx
.lf_e1:
    pop  rcx
    jmp  .perr

.sizeof_expr:
    ; sizeof(T). The type token is kept whole: codegen resolves scalars with
    ; cg_type_size and a struct name through the struct tables, so the two
    ; cases stay in one place.
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_current_token
    push rax
    call parse_type
    test rax, rax
    jz   .size_err
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .size_err
    call par_advance
    mov  rdi, AST_SIZEOF
    call ast_alloc
    test rax, rax
    jz   .size_err
    pop  rcx
    mov  [rax + AST.data], rcx
    ; an array type carries its own count and element width:
    ; sizeof([i64; 8]) is 64, sizeof([u8; 8]) is 8
    push rax
    mov  rcx, [rel par_last_array_len]
    mov  rax, [rsp]
    mov  [rax + AST.type_info], rcx
    mov  ecx, dword [rel par_last_arr_elem]
    mov  [rax + AST.child_count], ecx
    pop  rax
    ret
.size_err:
    pop  rcx
    jmp  .perr

.arraylit_expr:
    ; [1, 2, 3] -- the elements hang off the node as an AST_ARG chain, the
    ; same shape a call's arguments use.
    call par_advance                 ; consume '['
    mov  rdi, AST_ARRAY_LIT
    call ast_alloc
    test rax, rax
    jz   .perr
    push rax
    xor  rcx, rcx                    ; tail
    push rcx
.al_loop:
    call par_cur_type
    cmp  rax, TOK_RBRACKET
    je   .al_close
    cmp  rax, TOK_EOF
    je   .al_err
    call parse_expression_ast
    test rax, rax
    jz   .al_err
    push rax
    mov  rdi, AST_ARG
    call ast_alloc
    test rax, rax
    jz   .al_err2
    pop  rcx
    mov  [rax + AST.left], rcx       ; the element
    mov  rcx, [rsp]                  ; current tail
    test rcx, rcx
    jnz  .al_chain
    mov  rdx, [rsp + 8]              ; the ARRAY_LIT node
    mov  [rdx + AST.right], rax
    jmp  .al_after
.al_chain:
    mov  [rcx + AST.right], rax
.al_after:
    mov  [rsp], rax                  ; new tail
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .al_loop
    call par_advance
    jmp  .al_loop
.al_close:
    call par_advance                 ; consume ']'
    pop  rcx
    pop  rax
    ret
.al_err2:
    pop  rcx
.al_err:
    pop  rcx
    pop  rcx
    jmp  .perr

.failed_expr:
    ; failed() -> 1 when the last call left a failure behind, and clears it,
    ; so a failure is reported once and cannot be read twice by accident
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance
    mov  rdi, AST_FAILED
    call ast_alloc
    ret

.readkey_expr:
    call par_advance                 ; consume 'readkey'
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .perr
    call par_advance                 ; consume '('
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr
    call par_advance                 ; consume ')'
    mov  rdi, AST_READKEY
    call ast_alloc
    test rax, rax
    jz   .perr
    ret
.inb_expr:
    push r12
    mov  r12, AST_INB
    jmp  .one_arg
.peek_expr:
    push r12
    mov  r12, AST_PEEK
    jmp  .one_arg
.trunc_expr:
    push r12
    mov  r12, AST_TRUNC
    jmp  .one_arg
.peek8_expr:
    push r12
    mov  r12, AST_PEEK8
    jmp  .one_arg
.peek16_expr:
    push r12
    mov  r12, AST_PEEK16
    jmp  .one_arg
.peek32_expr:
    push r12
    mov  r12, AST_PEEK32
.one_arg:
    ; the keyword token goes on the stack: peek can nest inside its own
    ; argument, so a single variable would be overwritten
    call par_current_token
    push rax
    call par_advance
    call par_cur_type
    cmp  rax, TOK_LPAREN
    jne  .one_err_tok
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .one_err_tok
    push rax
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .one_err_pop
    call par_advance
    mov  rdi, r12
    call ast_alloc
    test rax, rax
    jz   .one_err_pop
    pop  rdx
    mov  [rax + AST.right], rdx
    pop  rdx
    mov  [rax + AST.data], rdx       ; the keyword token
    pop  r12
    ret
.one_err_pop:
    pop  rdx
.one_err_tok:
    pop  rdx
.one_err:
    xor  rax, rax
    pop  r12
    ret

.int_lit:
    call par_current_token
    mov  rdx, rax                    ; token ptr
    call par_advance
    push rdx
    mov  rdi, AST_INTEGER_LIT
    call ast_alloc
    test rax, rax
    jz   .oom1
    pop  rdx
    mov  [rax + AST.data], rdx
    ret
.oom1:
    pop  rdx
    xor  rax, rax
    ret

.float_lit:
    call par_current_token
    mov  rdx, rax
    call par_advance
    push rdx
    mov  rdi, AST_FLOAT_LIT
    call ast_alloc
    test rax, rax
    jz   .oom2
    pop  rdx
    mov  [rax + AST.data], rdx
    ret
.oom2:
    pop  rdx
    xor  rax, rax
    ret

.str_lit:
    call par_current_token
    mov  rdx, rax
    call par_advance
    push rdx
    mov  rdi, AST_STRING_LIT
    call ast_alloc
    test rax, rax
    jz   .oom3
    pop  rdx
    mov  [rax + AST.data], rdx
    ret
.oom3:
    pop  rdx
    xor  rax, rax
    ret

.bool_lit:
    call par_advance
    mov  rdi, AST_BOOL_LIT
    call ast_alloc
    ret

; The value goes in type_info, not in a token: codegen emits the SOURCE TEXT
; of the data token, and 'mov rax, true' is not an instruction.
.true_lit:
    call par_advance
    mov  rdi, AST_BOOL_LIT
    call ast_alloc
    test rax, rax
    jz   .oom_bool
    mov  qword [rax + AST.type_info], 1
    ret
.false_lit:
    call par_advance
    mov  rdi, AST_BOOL_LIT
    call ast_alloc
    test rax, rax
    jz   .oom_bool
    mov  qword [rax + AST.type_info], 0
    ret
.oom_bool:
    xor  rax, rax
    ret

.ident:
    call par_current_token
    mov  rdx, rax
    call par_advance
    ; struct literal:  Name { ... }
    ; The type name in front is what keeps this apart from a block: a block
    ; is never preceded by an identifier in expression position.
    push rdx
    ; 'if flag {' is an identifier followed by '{' too, so the literal is off
    ; in condition position. Rust draws the same line for the same reason.
    cmp  qword [rel par_no_slit], 0
    jne  .not_slit
    call par_cur_type
    cmp  rax, TOK_LBRACE
    jne  .not_slit
    pop  rdx
    mov  rdi, rdx
    call parse_struct_lit_ast
    ret
.not_slit:
    pop  rdx
    push rdx
    ; array indexing:  name [ expr ]
    call par_cur_type
    cmp  rax, TOK_LBRACKET
    je   .idx
    mov  rdi, AST_IDENTIFIER
    call ast_alloc
    test rax, rax
    jz   .oom4
    pop  rdx
    mov  [rax + AST.data], rdx
    ret
.idx:
    call par_advance                 ; consume '['
    call parse_expression_ast
    test rax, rax
    jz   .oom4
    push rax
    call par_cur_type
    cmp  rax, TOK_RBRACKET
    jne  .idx_err
    call par_advance
    mov  rdi, AST_INDEX
    call ast_alloc
    test rax, rax
    jz   .idx_err
    pop  rdx                         ; index expression
    mov  [rax + AST.right], rdx
    pop  rdx                         ; array token
    mov  [rax + AST.data], rdx
    ; a slice: v[i] is slice_get(v, i)
    push rax
    mov  rdi, rdx
    call par_is_slice
    mov  ecx, eax
    pop  rax
    test ecx, ecx
    jz   .idx_notslice
    mov  rdi, rax
    mov  esi, ecx
    call par_slice_get_call
    ret
.idx_notslice:
    ; a second subscript: m[i][j]. The array is stored flat, row by row, so
    ; codegen turns the pair into i * row_len + j.
    push rax
    call par_cur_type
    cmp  rax, TOK_LBRACKET
    jne  .idx_one
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .idx_err2
    push rax
    call par_cur_type
    cmp  rax, TOK_RBRACKET
    jne  .idx_err3
    call par_advance
    pop  rdx                         ; second index
    pop  rax                         ; the AST_INDEX node
    mov  [rax + AST.left], rdx
    ret
.idx_one:
    pop  rax
    ret
.idx_err3:
    pop  rdx
.idx_err2:
    pop  rdx
    xor  rax, rax
    ret
.idx_err:
    pop  rdx
    pop  rdx
    xor  rax, rax
    ret
.oom4:
    pop  rdx
    xor  rax, rax
    ret

.paren:
    call par_advance
    call parse_expression_ast
    test rax, rax
    jz   .perr
    push rax
    call par_cur_type
    cmp  rax, TOK_RPAREN
    jne  .perr_pop
    call par_advance
    pop  rax
    ret
.perr_pop:
    pop  rax
.perr:
    xor  rax, rax
    ret

; par_is_syscall() -> rax = 1 when the current token is the identifier syscall
par_is_syscall:
    call par_cur_type
    cmp  rax, TOK_IDENT
    jne  .is_no
    call par_current_token
    mov  rcx, [rax + TOKEN.value]
    mov  edx, dword [rax + TOKEN.length]
    cmp  edx, 7
    jne  .is_no
    cmp  dword [rcx], 'sysc'
    jne  .is_no
    cmp  word [rcx+4], 'al'
    jne  .is_no
    cmp  byte [rcx+6], 'l'
    jne  .is_no
    mov  eax, 1
    ret
.is_no:
    xor  eax, eax
    ret

; parse_syscall_expr() -> rax = AST_SYSCALL node, 0 on error
;   syscall(num, a1, ..., a6): the number and up to six arguments, in the
;   Linux order rax, rdi, rsi, rdx, r10, r8, r9. right = chain of AST_BLOCK
;   (left = argument, right = next), data = how many, type_info = the
;   keyword token for the raw error. type_info, because the generic walks
;   follow left and right, and a token there would be read as a node.
parse_syscall_expr:
    push r12
    push r13
    call par_current_token
    push rax
    call par_advance
    call par_cur_type
    mov  qword [rel par_expected], TOK_LPAREN
    cmp  rax, TOK_LPAREN
    jne  .se_err_tok
    call par_advance
    mov  rdi, AST_SYSCALL
    call ast_alloc
    test rax, rax
    jz   .se_err_tok
    mov  r12, rax
    pop  rcx
    mov  [r12 + AST.type_info], rcx
    xor  r13, r13
    jmp  .se_args
.se_args:
    call par_cur_type
    cmp  rax, TOK_RPAREN
    je   .se_end
    call parse_expression_ast
    test rax, rax
    jz   .se_fail
    push rax
    mov  rdi, AST_BLOCK
    call ast_alloc
    test rax, rax
    jz   .se_fail_pop
    pop  rcx
    mov  [rax + AST.left], rcx
    test r13, r13
    jnz  .se_link
    mov  [r12 + AST.right], rax
    mov  r13, rax
    jmp  .se_count
.se_link:
    mov  [r13 + AST.right], rax
    mov  r13, rax
    jmp  .se_count
.se_count:
    inc  qword [r12 + AST.data]
    call par_cur_type
    cmp  rax, TOK_COMMA
    jne  .se_end
    call par_advance
    jmp  .se_args
.se_fail_pop:
    pop  rcx
    jmp  .se_fail
.se_end:
    call par_cur_type
    mov  qword [rel par_expected], TOK_RPAREN
    cmp  rax, TOK_RPAREN
    jne  .se_fail
    call par_advance
    ; the number and six arguments are all the registers there are
    mov  rax, [r12 + AST.data]
    cmp  rax, 7
    ja   .se_fail
    test rax, rax
    jz   .se_fail
    mov  rax, r12
    pop  r13
    pop  r12
    ret
.se_err_tok:
    pop  rcx
    jmp  .se_fail
.se_fail:
    xor  eax, eax
    pop  r13
    pop  r12
    ret

; ==============================================================================
; GENERIC STRUCTURAL PARSING (22 TITAN modules) -> rax = 1/0
; ==============================================================================
parse_generic_decl:
    call par_cur_type
    cmp  rax, TOK_EOF
    je   .error
    cmp  rax, TOK_RBRACE
    je   .error
    cmp  rax, TOK_LBRACE
    je   .block
    cmp  rax, TOK_SEMICOLON
    je   .semi
    cmp  rax, TOK_LPAREN
    je   .parens
    cmp  rax, TOK_LBRACKET
    je   .brackets
    call par_advance
    jmp  parse_generic_decl
.parens:
    call consume_balanced_parens
    test rax, rax
    jz   .error
    jmp  parse_generic_decl
.brackets:
    call consume_balanced_brackets
    test rax, rax
    jz   .error
    jmp  parse_generic_decl
.block:
    call parse_generic_block
    ret
.semi:
    call par_advance
    mov  rax, 1
    ret
.error:
    xor  rax, rax
    ret

parse_generic_block:
    call par_advance                 ; consume '{'
.loop:
    call par_cur_type
    cmp  rax, TOK_RBRACE
    je   .close
    cmp  rax, TOK_EOF
    je   .error
    cmp  rax, TOK_LBRACE
    je   .nested
    cmp  rax, TOK_LPAREN
    je   .parens
    cmp  rax, TOK_LBRACKET
    je   .brackets
    call par_advance
    jmp  .loop
.nested:
    call parse_generic_block
    test rax, rax
    jz   .error
    jmp  .loop
.parens:
    call consume_balanced_parens
    test rax, rax
    jz   .error
    jmp  .loop
.brackets:
    call consume_balanced_brackets
    test rax, rax
    jz   .error
    jmp  .loop
.close:
    call par_advance
    mov  rax, 1
    ret
.error:
    xor  rax, rax
    ret

consume_balanced_parens:
    call par_advance                 ; consume '('
.loop:
    call par_cur_type
    cmp  rax, TOK_RPAREN
    je   .close
    cmp  rax, TOK_EOF
    je   .error
    cmp  rax, TOK_LPAREN
    je   .np
    cmp  rax, TOK_LBRACKET
    je   .nb
    cmp  rax, TOK_LBRACE
    je   .nbr
    call par_advance
    jmp  .loop
.np:
    call consume_balanced_parens
    test rax, rax
    jz   .error
    jmp  .loop
.nb:
    call consume_balanced_brackets
    test rax, rax
    jz   .error
    jmp  .loop
.nbr:
    call parse_generic_block
    test rax, rax
    jz   .error
    jmp  .loop
.close:
    call par_advance
    mov  rax, 1
    ret
.error:
    xor  rax, rax
    ret

consume_balanced_brackets:
    call par_advance                 ; consume '['
.loop:
    call par_cur_type
    cmp  rax, TOK_RBRACKET
    je   .close
    cmp  rax, TOK_EOF
    je   .error
    cmp  rax, TOK_LBRACKET
    je   .nb
    cmp  rax, TOK_LPAREN
    je   .np
    cmp  rax, TOK_LBRACE
    je   .nbr
    call par_advance
    jmp  .loop
.nb:
    call consume_balanced_brackets
    test rax, rax
    jz   .error
    jmp  .loop
.np:
    call consume_balanced_parens
    test rax, rax
    jz   .error
    jmp  .loop
.nbr:
    call parse_generic_block
    test rax, rax
    jz   .error
    jmp  .loop
.close:
    call par_advance
    mov  rax, 1
    ret
.error:
    xor  rax, rax
    ret

; ==============================================================================
; Diagnostics / accessors
; ==============================================================================
parser_get_error:
    lea  rax, [rel par_error_msg]
    ret

parser_get_error_token:
    call par_current_token
    mov  rax, [rax + TOKEN.type]
    ret

parser_get_position:
    mov  rax, [rel par_pos]
    ret

; parser_get_error_line() -> rax = source line of the current (error) token
parser_get_error_line:
    call par_current_token
    movzx rax, word [rax + TOKEN.line]
    ret

; parser_get_error_col() -> rax = source column of the current (error) token.
; The column was in the token all along and no diagnostic ever printed it.
; parser_get_expected() -> rax = the token type the parser wanted, or 0.
; Set immediately before each check, so 'unexpected X' can say what it was
; looking for instead of leaving the reader to guess.
parser_get_expected:
    mov  rax, [rel par_expected]
    ret

; parser_get_custom_msg() -> rax = a message for an error that is not a token
; mismatch, or 0. Lets the parser say something specific instead of being
; forced into 'expected X, found Y'.
    global parser_get_custom_msg
parser_get_custom_msg:
    mov  rax, [rel par_custom_msg]
    ret

parser_get_error_col:
    call par_current_token
    movzx rax, word [rax + TOKEN.col]
    ret

; parser_get_error_len() -> rax = length in bytes of the offending token,
; so the caret can underline the whole thing rather than one character.
parser_get_error_len:
    call par_current_token
    mov  eax, dword [rax + TOKEN.length]
    ret

; token_name(rdi = token type) -> rax = pointer to a human-readable name
token_name:
    cmp  rdi, 0
    je   .n_eof
    cmp  rdi, 1
    je   .n_ident
    cmp  rdi, 2
    je   .n_int
    cmp  rdi, 3
    je   .n_float
    cmp  rdi, 4
    je   .n_string
    cmp  rdi, 10
    je   .n_lbrace
    cmp  rdi, 11
    je   .n_rbrace
    cmp  rdi, 12
    je   .n_lparen
    cmp  rdi, 13
    je   .n_rparen
    cmp  rdi, 14
    je   .n_lbrack
    cmp  rdi, 15
    je   .n_rbrack
    cmp  rdi, 16
    je   .n_semi
    cmp  rdi, 17
    je   .n_colon
    cmp  rdi, 18
    je   .n_comma
    cmp  rdi, 20
    je   .n_assign
    cmp  rdi, 21
    je   .n_arrow
    cmp  rdi, TOK_EXPECT_EXPR
    je   .n_expr
    ; 30..49 = operators ; 100+ = keywords
    cmp  rdi, 100
    jae  .n_kw
    cmp  rdi, 30
    jae  .n_op
    lea  rax, [rel tn_unknown]
    ret
.n_eof:    lea rax, [rel tn_eof]
    ret
.n_ident:  lea rax, [rel tn_ident]
    ret
.n_int:    lea rax, [rel tn_int]
    ret
.n_float:  lea rax, [rel tn_float]
    ret
.n_string: lea rax, [rel tn_string]
    ret
.n_lbrace: lea rax, [rel tn_lbrace]
    ret
.n_rbrace: lea rax, [rel tn_rbrace]
    ret
.n_lparen: lea rax, [rel tn_lparen]
    ret
.n_rparen: lea rax, [rel tn_rparen]
    ret
.n_lbrack: lea rax, [rel tn_lbrack]
    ret
.n_rbrack: lea rax, [rel tn_rbrack]
    ret
.n_semi:   lea rax, [rel tn_semi]
    ret
.n_colon:  lea rax, [rel tn_colon]
    ret
.n_comma:  lea rax, [rel tn_comma]
    ret
.n_assign: lea rax, [rel tn_assign]
    ret
.n_arrow:  lea rax, [rel tn_arrow]
    ret
.n_kw:
    ; the keyword's own text, in quotes: 'kron_program', not "a keyword".
    ; Bytes are stored only as 'mov [rdi], al', the form kasm already handles.
    push rdi
    call lexer_keyword_name
    pop  rdi
    test rax, rax
    jz   .n_kw_generic
    push rsi
    push rdi
    push rcx
    mov  rsi, rax
    lea  rdi, [rel tn_kwbuf]
    mov  al, 39
    mov  [rdi], al
    inc  rdi
    mov  ecx, 60
.n_kw_copy:
    mov  al, [rsi]
    test al, al
    jz   .n_kw_end
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  ecx
    jnz  .n_kw_copy
.n_kw_end:
    mov  al, 39
    mov  [rdi], al
    inc  rdi
    xor  eax, eax
    mov  [rdi], al
    pop  rcx
    pop  rdi
    pop  rsi
    lea  rax, [rel tn_kwbuf]
    ret
.n_kw_generic:
    lea  rax, [rel tn_kw]
    ret
.n_expr:   lea rax, [rel tn_expr]
    ret
.n_op:     lea rax, [rel tn_op]
    ret

parser_get_ast_root:
    mov  rax, [rel par_ast_root]
    ret

; ==============================================================================
; GENERICS AND MODULE NAMES -- one pass over the tokens, before parsing
;
; Generics.  A function or struct written with type parameters
;     fn biggest<T>(a: T, b: T) -> T { ... }
;     struct Pair<A, B> { first: A; second: B; }
; is a template: it produces no code itself. Each use with types,
; biggest<f64>(x, y) or Pair<i64, text>, names a copy made for those types --
; biggest__f64, Pair__i64__text -- written where the template stood, with
; every T replaced by the type given. A copy may use other templates; their
; copies are made the same way, until nothing new is asked for.
;
; Module names.  module.name reaches a declaration of one module: the file
; name without .kr (std_math.fsqrt), or the name given in the program's
; header with  acquire_domain "file.kr" as name;  When two modules define
; a function of the same name, each keeps its own: its calls inside its
; module go to it, and from anywhere else it is written module.name.
;
; ng_run works on the token array the lexer filled and leaves the result in
; the same array. Tokens it makes point their text into ng_text.
; ==============================================================================

NG_MAXDECL  equ 16384
NG_MAXMOD   equ 72
NG_MAXT     equ 512
NG_MAXI     equ 4096
NG_MAXTOK   equ 349500              ; TOKEN_BUFFER_SIZE / TOKEN_SIZE, rounded down
NG_ARGTOK   equ 65536
NG_TEXT     equ 1048576

section .data
ng_gt_text:     db ">"
ng_msg_notypes: db "a generic function is called with its types: name<T>(...)", 0
ng_msg_nargs:   db "this generic is used with a different number of types than it declares", 0
ng_msg_ambig:   db "two modules define a function of this name: write which, module.name", 0
ng_msg_full:    db "too many generic copies or tokens (more than the compiler's tables hold)", 0
ng_msg_bad:     db "a generic is used with types, but its <...> is never closed", 0
ng_acq:         db "acquire_domain"

section .bss
    ng_tok       resq 1             ; the token array
    ng_cnt       resq 1             ; and its count, EOF included
    ng_err_tok   resq 1             ; the token an error is about
    ng_err_msg   resq 1
    ; --- modules ---
    ng_mod_name  resq NG_MAXMOD     ; the file's name without .kr
    ng_mod_len   resd NG_MAXMOD
    ng_mod_alias resq NG_MAXMOD     ; the program's name for it, or 0
    ng_mod_alen  resd NG_MAXMOD
    ng_nmod      resd 1
    ng_tokmod    resb NG_MAXTOK     ; which module each token is from
    ng_tokflag   resd NG_MAXTOK     ; template t starts here: t + 1
    ; --- declarations at the top of a module ---
    ng_d_tok     resq NG_MAXDECL    ; the name token
    ng_d_mod     resd NG_MAXDECL
    ng_d_kind    resb NG_MAXDECL    ; 1 fn, 2 other, 3 a template
    ng_d_dup     resb NG_MAXDECL    ; a fn another module defines too
    ng_nd        resd 1
    ng_anydup    resd 1
    ; --- templates ---
    ng_t_name    resq NG_MAXT       ; the name token
    ng_t_start   resd NG_MAXT       ; index of 'fn' / 'struct'
    ng_t_lt      resd NG_MAXT       ; index of its '<'
    ng_t_body    resd NG_MAXT       ; index just past its '>'
    ng_t_end     resd NG_MAXT       ; index past its closing '}'
    ng_t_np      resd NG_MAXT
    ng_t_par     resq NG_MAXT * 8   ; parameter name tokens
    ng_t_mod     resd NG_MAXT
    ng_t_isfn    resb NG_MAXT
    ng_nt        resd 1
    ; --- copies (instantiations) ---
    ng_i_t       resd NG_MAXI
    ng_i_name    resq NG_MAXI       ; mangled name, in ng_text
    ng_i_nlen    resd NG_MAXI
    ng_i_argb    resd NG_MAXI * 8   ; each type: first token in ng_args
    ng_i_argn    resd NG_MAXI * 8   ; and how many
    ng_i_bodyb   resd NG_MAXI       ; its tokens in ng_itok
    ng_i_bodyn   resd NG_MAXI
    ng_ni        resd 1
    ; --- token stores ---
    ng_args      resb TOKEN_SIZE * NG_ARGTOK
    ng_nargs     resd 1
    ng_itok      resb TOKEN_SIZE * NG_MAXTOK
    ng_nitok     resd 1
    ng_sub       resb TOKEN_SIZE * NG_MAXTOK
    ng_nsub      resd 1
    ng_out       resb TOKEN_SIZE * NG_MAXTOK
    ng_nout      resd 1
    ng_text      resb NG_TEXT
    ng_ntext     resd 1
    ; --- the rewrite in progress ---
    ng_src       resq 1             ; tokens being read
    ng_srcn      resd 1
    ng_main      resd 1             ; 1 the program's own tokens
    ng_round     resd 1             ; 2 when copies are written out
    ng_ctxmod    resd 1             ; module of a copy being made
    ng_dst       resq 1             ; where tokens go
    ng_dstn      resq 1             ; address of its count (dword)
    ng_mbuf      resb 512           ; a name being built
    ng_ab        resd 16            ; where each type of a use starts in ng_args
    ng_use_at    resd 1             ; index of the name a use starts at

section .text

; ng_tp(eax = index, rsi = array) -> rax = address of that token
; (inline everywhere as imul; kept for reading)

; ng_teq(rdi = token, rsi = token) -> eax = 1 when their texts are the same
ng_teq:
    mov  ecx, [rdi + TOKEN.length]
    cmp  ecx, [rsi + TOKEN.length]
    jne  .te_no
    mov  rdx, [rdi + TOKEN.value]
    mov  r8, [rsi + TOKEN.value]
    jmp  ng_memeq
.te_no:
    xor  eax, eax
    ret

; ng_teqs(rdi = token, rsi = text, edx = length) -> eax
ng_teqs:
    mov  ecx, [rdi + TOKEN.length]
    cmp  ecx, edx
    jne  .ts_no
    mov  rdx, [rdi + TOKEN.value]
    mov  r8, rsi
    jmp  ng_memeq
.ts_no:
    xor  eax, eax
    ret

; ng_memeq(rdx, r8 = texts, ecx = length) -> eax
ng_memeq:
    test ecx, ecx
    jz   .me_yes
.me_l:
    mov  al, [rdx]
    cmp  al, [r8]
    jne  .me_no
    inc  rdx
    inc  r8
    dec  ecx
    jnz  .me_l
.me_yes:
    mov  eax, 1
    ret
.me_no:
    xor  eax, eax
    ret

; ng_err(rdi = token, rsi = message): the first error wins
ng_err:
    cmp  qword [rel ng_err_msg], 0
    jne  .er_out
    mov  [rel ng_err_tok], rdi
    mov  [rel ng_err_msg], rsi
.er_out:
    ret

; ng_basename(rsi = a path, NUL-ended) -> rsi = start of its name, ecx =
; its length without the extension
ng_basename:
    mov  rdx, rsi                    ; start
    mov  r8, rsi
.bn_l:
    mov  al, [r8]
    test al, al
    jz   .bn_end
    cmp  al, '/'
    je   .bn_sep
    cmp  al, 92
    je   .bn_sep
    inc  r8
    jmp  .bn_l
.bn_sep:
    inc  r8
    mov  rdx, r8
    jmp  .bn_l
.bn_end:
    ; r8 = the NUL; the last '.' after the start ends the name
    mov  r9, r8
.bn_dot:
    cmp  r9, rdx
    jbe  .bn_nodot
    dec  r9
    cmp  byte [r9], '.'
    jne  .bn_dot
    mov  r8, r9
.bn_nodot:
    mov  rsi, rdx
    mov  rcx, r8
    sub  rcx, rdx
    ret

; ng_mod_of(rsi = a path) -> eax = its module index (added when new)
ng_mod_of:
    push rbx
    push r12
    push r13
    call ng_basename
    mov  r12, rsi
    mov  r13d, ecx
    xor  ebx, ebx
.mo_l:
    cmp  ebx, [rel ng_nmod]
    jae  .mo_new
    lea  rax, [rel ng_mod_len]
    mov  r11d, [rax + rbx*4]
    cmp  r11d, r13d
    jne  .mo_next
    lea  rax, [rel ng_mod_name]
    mov  rdx, [rax + rbx*8]
    mov  r8, r12
    mov  ecx, r13d
    call ng_memeq
    test eax, eax
    jnz  .mo_have
.mo_next:
    inc  ebx
    jmp  .mo_l
.mo_new:
    cmp  ebx, NG_MAXMOD
    jae  .mo_full
    lea  rax, [rel ng_mod_name]
    mov  [rax + rbx*8], r12
    lea  rax, [rel ng_mod_len]
    mov  [rax + rbx*4], r13d
    lea  rax, [rel ng_mod_alias]
    mov  r11, 0
    mov  [rax + rbx*8], r11
    inc  dword [rel ng_nmod]
.mo_have:
    mov  eax, ebx
    pop  r13
    pop  r12
    pop  rbx
    ret
.mo_full:
    xor  eax, eax
    pop  r13
    pop  r12
    pop  rbx
    ret

; ng_modules(): every token's module, from the line map main.asm keeps
ng_modules:
    push rbx
    push r12
    push r13
    push r14
    mov  dword [rel ng_nmod], 0
    lea  rsi, [rel arg_input]
    call ng_mod_of                   ; module 0: the program
    mov  r12, [rel lmap_count]
    xor  ebx, ebx                    ; token
    xor  r13d, r13d                  ; current run
    xor  r14d, r14d                  ; its module
    test r12, r12
    jz   .md_tokens
    lea  rax, [rel lmap_file]
    mov  rsi, [rax]
    call ng_mod_of
    mov  r14d, eax
.md_tokens:
    cmp  rbx, [rel ng_cnt]
    jae  .md_alias
    cmp  ebx, NG_MAXTOK
    jae  .md_alias
    test r12, r12
    jz   .md_put
    ; the last run that starts at or before this token's line
    imul rax, rbx, TOKEN_SIZE
    add  rax, [rel ng_tok]
    movzx ecx, word [rax + TOKEN.line]
.md_run:
    lea  rdx, [r13 + 1]
    cmp  rdx, r12
    jae  .md_put
    lea  rax, [rel lmap_out]
    mov  rax, [rax + rdx*8]
    cmp  rax, rcx
    ja   .md_put
    mov  r13, rdx
    push rcx
    lea  rax, [rel lmap_file]
    mov  rsi, [rax + r13*8]
    call ng_mod_of
    pop  rcx
    mov  r14d, eax
    jmp  .md_run
.md_put:
    lea  rax, [rel ng_tokmod]
    mov  ecx, r14d
    mov  [rax + rbx], cl
    lea  rax, [rel ng_tokflag]
    mov  r11d, 0
    mov  [rax + rbx*4], r11d
    inc  rbx
    jmp  .md_tokens
.md_alias:
    ; acquire_domain "file.kr" as name;  in the program's own text
    lea  r12, [rel src_buffer]
.al_find:
    mov  al, [r12]
    test al, al
    jz   .al_done
    cmp  al, 'a'
    jne  .al_next
    mov  rdx, r12
    lea  r8, [rel ng_acq]
    mov  ecx, 14
    call ng_memeq
    test eax, eax
    jz   .al_next
    add  r12, 14
.al_q:
    mov  al, [r12]
    cmp  al, ' '
    je   .al_qs
    cmp  al, 9
    je   .al_qs
    cmp  al, 34
    jne  .al_find
    inc  r12
    mov  r13, r12                    ; the file name
.al_qe:
    mov  al, [r12]
    test al, al
    jz   .al_done
    cmp  al, 10
    je   .al_find
    cmp  al, 34
    je   .al_qend
    inc  r12
    jmp  .al_qe
.al_qs:
    inc  r12
    jmp  .al_q
.al_qend:
    mov  r14, r12                    ; the closing quote
    inc  r12
.al_sp1:
    mov  al, [r12]
    cmp  al, ' '
    je   .al_sp1n
    cmp  al, 9
    je   .al_sp1n
    jmp  .al_as
.al_sp1n:
    inc  r12
    jmp  .al_sp1
.al_as:
    cmp  byte [r12], 'a'
    jne  .al_find
    cmp  byte [r12 + 1], 's'
    jne  .al_find
    mov  al, [r12 + 2]
    cmp  al, ' '
    je   .al_as2
    cmp  al, 9
    jne  .al_find
.al_as2:
    add  r12, 3
.al_sp2:
    mov  al, [r12]
    cmp  al, ' '
    je   .al_sp2n
    cmp  al, 9
    je   .al_sp2n
    jmp  .al_name
.al_sp2n:
    inc  r12
    jmp  .al_sp2
.al_name:
    mov  rbx, r12                    ; the alias
.al_nl:
    mov  al, [r12]
    cmp  al, '_'
    je   .al_nc
    cmp  al, '0'
    jb   .al_nend
    cmp  al, '9'
    jbe  .al_nc
    cmp  al, 'A'
    jb   .al_nend
    cmp  al, 'Z'
    jbe  .al_nc
    cmp  al, 'a'
    jb   .al_nend
    cmp  al, 'z'
    ja   .al_nend
.al_nc:
    inc  r12
    jmp  .al_nl
.al_nend:
    cmp  r12, rbx
    je   .al_find
    ; the module of that file: its base name, compared like ng_mod_of does
    mov  byte [r14], 0               ; end the name for a moment
    mov  rsi, r13
    push r14
    call ng_basename
    pop  r14
    mov  byte [r14], 34
    mov  r8, rsi                     ; name
    mov  r9d, ecx
    xor  r10d, r10d
.al_mod:
    cmp  r10d, [rel ng_nmod]
    jae  .al_find
    lea  rax, [rel ng_mod_len]
    mov  r11d, [rax + r10*4]
    cmp  r11d, r9d
    jne  .al_modn
    lea  rax, [rel ng_mod_name]
    mov  rdx, [rax + r10*8]
    push r8
    push r9
    mov  ecx, r9d
    call ng_memeq
    pop  r9
    pop  r8
    test eax, eax
    jz   .al_modn
    lea  rax, [rel ng_mod_alias]
    mov  [rax + r10*8], rbx
    mov  rax, r12
    sub  rax, rbx
    lea  rcx, [rel ng_mod_alen]
    mov  [rcx + r10*4], eax
    jmp  .al_find
.al_modn:
    inc  r10d
    jmp  .al_mod
.al_next:
    inc  r12
    jmp  .al_find
.al_done:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; ng_close(ebx = index of a token at or before a '{') -> eax = index past
; the matching '}', or the count when there is none
ng_close:
    mov  rsi, [rel ng_tok]
    mov  ecx, ebx
    xor  edx, edx                    ; depth
.cl_l:
    cmp  rcx, [rel ng_cnt]
    jae  .cl_end
    imul rax, rcx, TOKEN_SIZE
    mov  rax, [rsi + rax + TOKEN.type]
    cmp  rax, TOK_LBRACE
    jne  .cl_nolb
    inc  edx
    jmp  .cl_next
.cl_nolb:
    cmp  rax, TOK_RBRACE
    jne  .cl_next
    dec  edx
    jnz  .cl_next
    lea  rax, [rcx + 1]
    ret
.cl_next:
    inc  ecx
    jmp  .cl_l
.cl_end:
    mov  rax, [rel ng_cnt]
    ret

; ng_ttype(ecx = index) -> rax = the type of that token of ng_tok (EOF past
; the end)
ng_ttype:
    cmp  rcx, [rel ng_cnt]
    jae  .tt_eof
    imul rax, rcx, TOKEN_SIZE
    add  rax, [rel ng_tok]
    mov  rax, [rax + TOKEN.type]
    ret
.tt_eof:
    xor  eax, eax
    ret

; ng_add_decl(rdi = name token, esi = module, dl = kind)
ng_add_decl:
    mov  eax, [rel ng_nd]
    cmp  eax, NG_MAXDECL
    jae  .ad_out
    lea  rcx, [rel ng_d_tok]
    mov  [rcx + rax*8], rdi
    lea  rcx, [rel ng_d_mod]
    mov  [rcx + rax*4], esi
    lea  rcx, [rel ng_d_kind]
    mov  [rcx + rax], dl
    lea  rcx, [rel ng_d_dup]
    mov  byte [rcx + rax], 0
    inc  eax
    mov  [rel ng_nd], eax
.ad_out:
    ret

; ng_decls(): the declarations at depth 0 of each module, and the templates
ng_decls:
    push rbx
    push r12
    push r13
    push r14
    push r15
    mov  dword [rel ng_nd], 0
    mov  dword [rel ng_nt], 0
    mov  dword [rel ng_anydup], 0
    xor  ebx, ebx                    ; index
    xor  r12d, r12d                  ; depth
.dc_l:
    cmp  rbx, [rel ng_cnt]
    jae  .dc_dups
    mov  ecx, ebx
    call ng_ttype
    cmp  rax, TOK_LBRACE
    jne  .dc_nolb
    inc  r12d
    jmp  .dc_next
.dc_nolb:
    cmp  rax, TOK_RBRACE
    jne  .dc_norb
    dec  r12d
    jmp  .dc_next
.dc_norb:
    test r12d, r12d
    jnz  .dc_next
    cmp  rax, TOK_KW_FN
    je   .dc_fn
    cmp  rax, KW_STRUCT
    je   .dc_struct
    cmp  rax, KW_ENUM
    je   .dc_other
    cmp  rax, TOK_KW_VAR
    je   .dc_other
    cmp  rax, TOK_KW_CONST
    je   .dc_other
    jmp  .dc_next
.dc_fn:
    mov  r15d, 1                     ; a function
    jmp  .dc_named
.dc_struct:
    mov  r15d, 2
.dc_named:
    ; the name: the next IDENT, past one keyword (fn global_visible name)
    lea  r13, [rbx + 1]
    mov  ecx, r13d
    call ng_ttype
    cmp  rax, TOK_IDENT
    je   .dc_have
    cmp  rax, 100
    jb   .dc_next
    inc  r13d
    mov  ecx, r13d
    call ng_ttype
    cmp  rax, TOK_IDENT
    jne  .dc_next
.dc_have:
    lea  rcx, [r13 + 1]
    call ng_ttype
    cmp  rax, TOK_LT
    je   .dc_template
    imul rdi, r13, TOKEN_SIZE
    add  rdi, [rel ng_tok]
    lea  rax, [rel ng_tokmod]
    movzx esi, byte [rax + rbx]
    mov  edx, r15d
    call ng_add_decl
    jmp  .dc_next
.dc_other:
    lea  r13, [rbx + 1]
    mov  ecx, r13d
    call ng_ttype
    cmp  rax, TOK_IDENT
    jne  .dc_next
    imul rdi, r13, TOKEN_SIZE
    add  rdi, [rel ng_tok]
    lea  rax, [rel ng_tokmod]
    movzx esi, byte [rax + rbx]
    mov  edx, 2
    call ng_add_decl
    jmp  .dc_next
.dc_template:
    ; fn NAME < P, Q > ...  /  struct NAME < P > { ... }
    mov  r14d, [rel ng_nt]
    cmp  r14d, NG_MAXT
    jae  .dc_next
    lea  rax, [rel ng_t_start]
    mov  [rax + r14*4], ebx
    lea  rax, [rel ng_t_isfn]
    xor  ecx, ecx
    cmp  r15d, 1
    jne  .dc_notfn
    mov  ecx, 1
.dc_notfn:
    mov  [rax + r14], cl
    imul rdi, r13, TOKEN_SIZE
    add  rdi, [rel ng_tok]
    lea  rax, [rel ng_t_name]
    mov  [rax + r14*8], rdi
    lea  rax, [rel ng_tokmod]
    movzx esi, byte [rax + rbx]
    lea  rax, [rel ng_t_mod]
    mov  [rax + r14*4], esi
    mov  edx, 3
    call ng_add_decl                 ; module.name reaches a template too
    lea  rax, [r13 + 1]
    lea  rcx, [rel ng_t_lt]
    mov  [rcx + r14*4], eax
    ; the parameters: IDENT (, IDENT)* >
    xor  r15d, r15d
    lea  r13, [r13 + 2]
.dc_par:
    mov  ecx, r13d
    call ng_ttype
    cmp  rax, TOK_IDENT
    jne  .dc_pend
    cmp  r15d, 8
    jae  .dc_pend
    imul rdi, r13, TOKEN_SIZE
    add  rdi, [rel ng_tok]
    mov  eax, r14d
    shl  eax, 3
    add  eax, r15d
    lea  rcx, [rel ng_t_par]
    mov  [rcx + rax*8], rdi
    inc  r15d
    inc  r13d
    mov  ecx, r13d
    call ng_ttype
    cmp  rax, TOK_COMMA
    jne  .dc_pend
    inc  r13d
    jmp  .dc_par
.dc_pend:
    mov  ecx, r13d
    call ng_ttype
    cmp  rax, TOK_GT
    jne  .dc_next                    ; not a template after all
    inc  r13d
    lea  rax, [rel ng_t_np]
    mov  [rax + r14*4], r15d
    lea  rax, [rel ng_t_body]
    mov  [rax + r14*4], r13d
    push rbx
    mov  ebx, r13d
    call ng_close
    pop  rbx
    lea  rcx, [rel ng_t_end]
    mov  [rcx + r14*4], eax
    lea  rcx, [rel ng_tokflag]
    lea  rdx, [r14 + 1]
    mov  [rcx + rbx*4], edx
    inc  dword [rel ng_nt]
    ; on past the template: its braces are not counted
    mov  ebx, eax
    jmp  .dc_l
.dc_next:
    inc  ebx
    jmp  .dc_l
.dc_dups:
    ; a function name two modules define
    xor  ebx, ebx
.dd_i:
    cmp  ebx, [rel ng_nd]
    jae  .dc_out
    lea  rax, [rel ng_d_kind]
    cmp  byte [rax + rbx], 1
    jne  .dd_inext
    lea  r12, [rbx + 1]
.dd_j:
    cmp  r12d, [rel ng_nd]
    jae  .dd_inext
    lea  rax, [rel ng_d_kind]
    cmp  byte [rax + r12], 1
    jne  .dd_jnext
    lea  rax, [rel ng_d_mod]
    mov  ecx, [rax + rbx*4]
    cmp  ecx, [rax + r12*4]
    je   .dd_jnext
    lea  rax, [rel ng_d_tok]
    mov  rdi, [rax + rbx*8]
    mov  rsi, [rax + r12*8]
    call ng_teq
    test eax, eax
    jz   .dd_jnext
    lea  rax, [rel ng_d_dup]
    mov  byte [rax + rbx], 1
    mov  byte [rax + r12], 1
    mov  dword [rel ng_anydup], 1
.dd_jnext:
    inc  r12d
    jmp  .dd_j
.dd_inext:
    inc  ebx
    jmp  .dd_i
.dc_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; ng_text_put(rsi = text, ecx = length) -> appended to ng_mbuf at rdi;
; returns rdi past it. Helpers for building names.
ng_put:
    test ecx, ecx
    jz   .pu_out
.pu_l:
    lea  rax, [rel ng_mbuf + 500]
    cmp  rdi, rax
    jae  .pu_out
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  ecx
    jnz  .pu_l
.pu_out:
    ret

; ng_keep(rdi = end of the name in ng_mbuf) -> rax = the name copied to
; ng_text, ecx = its length (0 when ng_text is full)
ng_keep:
    lea  rsi, [rel ng_mbuf]
    mov  rcx, rdi
    sub  rcx, rsi
    mov  eax, [rel ng_ntext]
    lea  rdx, [rax + rcx]
    cmp  edx, NG_TEXT
    jae  .kp_full
    mov  [rel ng_ntext], edx
    lea  rdx, [rel ng_text]
    add  rdx, rax
    push rdx
    push rcx
.kp_l:
    test ecx, ecx
    jz   .kp_done
    mov  al, [rsi]
    mov  [rdx], al
    inc  rsi
    inc  rdx
    dec  ecx
    jmp  .kp_l
.kp_done:
    pop  rcx
    pop  rax
    ret
.kp_full:
    xor  eax, eax
    xor  ecx, ecx
    ret

; ng_emit(rsi = a token): copied to the destination
ng_emit:
    mov  rdx, [rel ng_dstn]
    mov  eax, [rdx]
    cmp  eax, NG_MAXTOK - 2
    jae  .em_full
    mov  r11d, [rdx]
    inc  r11d
    mov  [rdx], r11d
    imul rax, rax, TOKEN_SIZE
    add  rax, [rel ng_dst]
    mov  rcx, [rsi]
    mov  [rax], rcx
    mov  rcx, [rsi + 8]
    mov  [rax + 8], rcx
    mov  rcx, [rsi + 16]
    mov  [rax + 16], rcx
    ret
.em_full:
    mov  rdi, rsi
    lea  rsi, [rel ng_msg_full]
    jmp  ng_err

; ng_emit_named(rsi = a token, rdi = text, ecx = length): the token with
; that text instead of its own
ng_emit_named:
    push rdi
    push rcx
    call ng_emit
    pop  rcx
    pop  rdi
    mov  rdx, [rel ng_dstn]
    mov  eax, [rdx]
    test eax, eax
    jz   .en_out
    dec  eax
    imul rax, rax, TOKEN_SIZE
    add  rax, [rel ng_dst]
    mov  qword [rax + TOKEN.type], TOK_IDENT
    mov  [rax + TOKEN.value], rdi
    mov  [rax + TOKEN.length], ecx
.en_out:
    ret

; ng_emit_gt(rsi = a token, for its place): a '>' of our own
ng_emit_gt:
    call ng_emit
    mov  rdx, [rel ng_dstn]
    mov  eax, [rdx]
    dec  eax
    imul rax, rax, TOKEN_SIZE
    add  rax, [rel ng_dst]
    mov  qword [rax + TOKEN.type], TOK_GT
    lea  rcx, [rel ng_gt_text]
    mov  [rax + TOKEN.value], rcx
    mov  dword [rax + TOKEN.length], 1
    ret

; ng_srct(ecx = index) -> rax = address of that token of the source being
; rewritten, or 0 past its end
ng_srct:
    cmp  ecx, [rel ng_srcn]
    jae  .st_none
    imul rax, rcx, TOKEN_SIZE
    add  rax, [rel ng_src]
    ret
.st_none:
    xor  eax, eax
    ret

; ng_stype(ecx = index) -> rax = its type, EOF past the end
ng_stype:
    call ng_srct
    test rax, rax
    jz   .sy_out
    mov  rax, [rax + TOKEN.type]
.sy_out:
    ret

; ng_find_mod(rdi = token) -> eax = the module it names (file or alias), -1
ng_find_mod:
    push rbx
    push r12
    mov  r12, rdi
    xor  ebx, ebx
.fm_l:
    cmp  ebx, [rel ng_nmod]
    jae  .fm_no
    mov  rdi, r12
    lea  rax, [rel ng_mod_name]
    mov  rsi, [rax + rbx*8]
    lea  rax, [rel ng_mod_len]
    mov  edx, [rax + rbx*4]
    call ng_teqs
    test eax, eax
    jnz  .fm_yes
    lea  rax, [rel ng_mod_alias]
    mov  rsi, [rax + rbx*8]
    test rsi, rsi
    jz   .fm_next
    mov  rdi, r12
    lea  rax, [rel ng_mod_alen]
    mov  edx, [rax + rbx*4]
    call ng_teqs
    test eax, eax
    jnz  .fm_yes
.fm_next:
    inc  ebx
    jmp  .fm_l
.fm_yes:
    mov  eax, ebx
    jmp  .fm_out
.fm_no:
    mov  eax, -1
.fm_out:
    pop  r12
    pop  rbx
    ret

; ng_find_decl(rdi = name token, esi = module, or -1 for any; dl = 1 for
; functions only) -> eax = declaration index, or -1
ng_find_decl:
    push rbx
    push r12
    push r13
    push r14
    mov  r12, rdi
    mov  r13d, esi
    movzx r14d, dl
    xor  ebx, ebx
.fd_l:
    cmp  ebx, [rel ng_nd]
    jae  .fd_no
    cmp  r13d, -1
    je   .fd_anymod
    lea  rax, [rel ng_d_mod]
    mov  r11d, [rax + rbx*4]
    cmp  r11d, r13d
    jne  .fd_next
.fd_anymod:
    test r14d, r14d
    jz   .fd_anykind
    lea  rax, [rel ng_d_kind]
    cmp  byte [rax + rbx], 1
    jne  .fd_next
.fd_anykind:
    mov  rdi, r12
    lea  rax, [rel ng_d_tok]
    mov  rsi, [rax + rbx*8]
    call ng_teq
    test eax, eax
    jnz  .fd_yes
.fd_next:
    inc  ebx
    jmp  .fd_l
.fd_yes:
    mov  eax, ebx
    jmp  .fd_out
.fd_no:
    mov  eax, -1
.fd_out:
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; ng_find_t(rdi = name token) -> eax = the template of that name, or -1
ng_find_t:
    push rbx
    push r12
    mov  r12, rdi
    xor  ebx, ebx
.ft_l:
    cmp  ebx, [rel ng_nt]
    jae  .ft_no
    mov  rdi, r12
    lea  rax, [rel ng_t_name]
    mov  rsi, [rax + rbx*8]
    call ng_teq
    test eax, eax
    jnz  .ft_yes
    inc  ebx
    jmp  .ft_l
.ft_yes:
    mov  eax, ebx
    jmp  .ft_out
.ft_no:
    mov  eax, -1
.ft_out:
    pop  r12
    pop  rbx
    ret

; ng_dupname(esi = module, rdi = name token) -> rax = "module__name" kept
; in ng_text, ecx = its length
ng_dupname:
    push r12
    mov  r12, rdi
    lea  rdi, [rel ng_mbuf]
    lea  rax, [rel ng_mod_name]
    mov  rdx, rsi
    mov  rsi, [rax + rdx*8]
    lea  rax, [rel ng_mod_len]
    mov  ecx, [rax + rdx*4]
    call ng_put
    mov  byte [rdi], '_'
    mov  byte [rdi + 1], '_'
    add  rdi, 2
    mov  rsi, [r12 + TOKEN.value]
    mov  ecx, [r12 + TOKEN.length]
    call ng_put
    call ng_keep
    pop  r12
    ret

; ng_use(ebx = index of a template's name in the source, eax = template)
; -> ebx = index past what was used, eax = 1 done, 0 not a use after all.
; Reads NAME < T1, T2 >, finds or makes the copy, writes its name.
ng_use:
    push r12
    push r13
    push r14
    push r15
    push rbp
    mov  r12d, eax                   ; template
    mov  r13d, [rel ng_nargs]        ; the types start here in ng_args
    mov  ebp, r13d
    xor  r14d, r14d                  ; types read
    lea  rcx, [rbx + 2]              ; past NAME <
    mov  r15d, 1                     ; depth
    ; argument starts: kept on ng_mbuf's tail as dwords (8 of them)
    lea  rax, [rel ng_ab]
    mov  [rax], r13d
    xor  r9d, r9d                    ; '>' left over after the close
.us_l:
    push rcx
    call ng_srct
    pop  rcx
    test rax, rax
    jz   .us_bad
    mov  rdx, [rax + TOKEN.type]
    cmp  rdx, TOK_SEMICOLON
    je   .us_bad
    cmp  rdx, TOK_LBRACE
    je   .us_bad
    cmp  rdx, TOK_EOF
    je   .us_bad
    cmp  rdx, TOK_LT
    jne  .us_nolt
    inc  r15d
    jmp  .us_keep
.us_nolt:
    cmp  rdx, TOK_COMMA
    jne  .us_nocomma
    cmp  r15d, 1
    jne  .us_keep
    ; the next type
    inc  r14d
    cmp  r14d, 8
    jae  .us_bad
    lea  rdx, [rel ng_ab]
    mov  r8d, [rel ng_nargs]
    mov  [rdx + r14*4], r8d
    inc  ecx
    jmp  .us_l
.us_nocomma:
    mov  r8d, 1
    cmp  rdx, TOK_GT
    je   .us_close
    mov  r8d, 2
    cmp  rdx, TOK_RSHIFT
    je   .us_close
    mov  r8d, 3
    cmp  rdx, TOK_URSHIFT
    je   .us_close
    jmp  .us_keep
.us_close:
    ; r8d '>' at once: each closes one level; the one that closes the
    ; generic ends the types, the rest come after its name
.us_cl:
    test r8d, r8d
    jz   .us_cl_done
    dec  r8d
    cmp  r15d, 1
    je   .us_end
    dec  r15d
    ; a '>' of the type itself
    push rcx
    push r8
    push rax
    mov  eax, [rel ng_nargs]
    cmp  eax, NG_ARGTOK - 1
    jae  .us_full_pop
    inc  dword [rel ng_nargs]
    imul rax, rax, TOKEN_SIZE
    lea  rdx, [rel ng_args]
    add  rdx, rax
    pop  rax
    push rax
    mov  rcx, [rax + 8]
    mov  [rdx + 8], rcx
    mov  rcx, [rax + 16]
    mov  [rdx + 16], rcx
    mov  qword [rdx + TOKEN.type], TOK_GT
    lea  rcx, [rel ng_gt_text]
    mov  [rdx + TOKEN.value], rcx
    mov  dword [rdx + TOKEN.length], 1
    pop  rax
    pop  r8
    pop  rcx
    jmp  .us_cl
.us_cl_done:
    inc  ecx
    jmp  .us_l
.us_end:
    mov  r9d, r8d                    ; '>' still to write after the name
    inc  ecx
    mov  ebx, ecx                    ; past the generic
    inc  r14d                        ; types read
    lea  rdx, [rel ng_ab]
    mov  r8d, [rel ng_nargs]
    mov  [rdx + r14*4], r8d          ; end of the last
    jmp  .us_have
.us_keep:
    ; a token of a type: into ng_args
    mov  r8d, [rel ng_nargs]
    cmp  r8d, NG_ARGTOK - 1
    jae  .us_full
    inc  dword [rel ng_nargs]
    imul r8, r8, TOKEN_SIZE
    lea  rdx, [rel ng_args]
    add  rdx, r8
    mov  r8, [rax]
    mov  [rdx], r8
    mov  r8, [rax + 8]
    mov  [rdx + 8], r8
    mov  r8, [rax + 16]
    mov  [rdx + 16], r8
    inc  ecx
    jmp  .us_l
.us_full_pop:
    pop  rax
    pop  r8
    pop  rcx
.us_full:
    mov  rdi, rax
    lea  rsi, [rel ng_msg_full]
    call ng_err
    jmp  .us_no
.us_bad:
    mov  [rel ng_nargs], ebp         ; nothing kept
    jmp  .us_no
.us_have:
    push r9
    ; as many types as the template has parameters
    lea  rax, [rel ng_t_np]
    mov  r11d, [rax + r12*4]
    cmp  r11d, r14d
    je   .us_count_ok
    mov  ecx, ebx
    dec  ecx
    call ng_srct
    mov  rdi, rax
    lea  rsi, [rel ng_msg_nargs]
    call ng_err
    pop  r9
    jmp  .us_no
.us_count_ok:
    ; the copy's name: NAME__T1__T2, each type's words joined by '_'
    lea  rdi, [rel ng_mbuf]
    lea  rax, [rel ng_t_name]
    mov  rax, [rax + r12*8]
    mov  rsi, [rax + TOKEN.value]
    mov  ecx, [rax + TOKEN.length]
    call ng_put
    xor  r10d, r10d                  ; type
.us_nm_t:
    cmp  r10d, r14d
    jae  .us_nm_done
    mov  byte [rdi], '_'
    mov  byte [rdi + 1], '_'
    add  rdi, 2
    lea  rax, [rel ng_ab]
    mov  r11d, [rax + r10*4]         ; first token of this type
.us_nm_tok:
    lea  rax, [rel ng_ab]
    cmp  r11d, [rax + r10*4 + 4]
    jae  .us_nm_next
    imul rax, r11, TOKEN_SIZE
    lea  rdx, [rel ng_args]
    add  rax, rdx
    mov  rdx, [rax + TOKEN.type]
    cmp  rdx, TOK_IDENT
    je   .us_nm_word
    cmp  rdx, TOK_NUMBER
    je   .us_nm_word
    cmp  rdx, 100
    jae  .us_nm_word
    mov  byte [rdi], '_'
    inc  rdi
    jmp  .us_nm_adv
.us_nm_word:
    mov  rsi, [rax + TOKEN.value]
    mov  ecx, [rax + TOKEN.length]
    push r10
    push r11
    call ng_put
    pop  r11
    pop  r10
.us_nm_adv:
    inc  r11d
    jmp  .us_nm_tok
.us_nm_next:
    inc  r10d
    jmp  .us_nm_t
.us_nm_done:
    ; an existing copy of that name?
    lea  rsi, [rel ng_mbuf]
    mov  r10, rdi
    sub  r10, rsi                    ; length
    xor  r11d, r11d
.us_find:
    cmp  r11d, [rel ng_ni]
    jae  .us_new
    lea  rax, [rel ng_i_nlen]
    mov  r9d, [rax + r11*4]
    cmp  r9d, r10d
    jne  .us_fnext
    lea  rax, [rel ng_i_name]
    mov  rdx, [rax + r11*8]
    lea  r8, [rel ng_mbuf]
    mov  ecx, r10d
    push r11
    call ng_memeq
    pop  r11
    test eax, eax
    jnz  .us_old
.us_fnext:
    inc  r11d
    jmp  .us_find
.us_old:
    mov  [rel ng_nargs], ebp         ; its types are kept already
    lea  rax, [rel ng_i_name]
    mov  rdi, [rax + r11*8]
    mov  ecx, r10d
    jmp  .us_write
.us_new:
    cmp  r11d, NG_MAXI
    jae  .us_full_pop9
    call ng_keep                     ; rdi = end of the name
    test ecx, ecx
    jz   .us_full_pop9
    lea  rdx, [rel ng_i_name]
    mov  [rdx + r11*8], rax
    lea  rdx, [rel ng_i_nlen]
    mov  [rdx + r11*4], ecx
    lea  rdx, [rel ng_i_t]
    mov  [rdx + r11*4], r12d
    lea  rdx, [rel ng_i_bodyn]
    mov  r9d, -1
    mov  [rdx + r11*4], r9d     ; not made yet
    xor  r10d, r10d
.us_args:
    cmp  r10d, r14d
    jae  .us_args_done
    lea  rdx, [rel ng_ab]
    mov  r8d, [rdx + r10*4]
    mov  r9d, [rdx + r10*4 + 4]
    sub  r9d, r8d
    mov  edx, r11d
    shl  edx, 3
    add  edx, r10d
    lea  rsi, [rel ng_i_argb]
    mov  [rsi + rdx*4], r8d
    lea  rsi, [rel ng_i_argn]
    mov  [rsi + rdx*4], r9d
    inc  r10d
    jmp  .us_args
.us_args_done:
    inc  dword [rel ng_ni]
    mov  rdi, rax
.us_write:
    ; the copy's name, where NAME stood
    push rdi
    push rcx
    mov  ecx, [rel ng_use_at]
    call ng_srct
    mov  rsi, rax
    pop  rcx
    pop  rdi
    call ng_emit_named
    pop  r9
.us_gts:
    test r9d, r9d
    jz   .us_done
    push r9
    mov  ecx, [rel ng_use_at]
    call ng_srct
    mov  rsi, rax
    call ng_emit_gt
    pop  r9
    dec  r9d
    jmp  .us_gts
.us_done:
    mov  eax, 1
    jmp  .us_out
.us_full_pop9:
    pop  r9
    mov  rdi, 0
    lea  rsi, [rel ng_msg_full]
    call ng_err
.us_no:
    xor  eax, eax
.us_out:
    pop  rbp
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    ret

; ng_rw(): rewrites the source tokens (ng_src, ng_srcn) into the destination.
; ng_main says whether they are the program's own (their module per token,
; templates in place) or a copy being made (module ng_ctxmod).
ng_rw:
    push rbx
    push r12
    push r13
    push r14
    push r15
    xor  ebx, ebx
.rw_l:
    cmp  ebx, [rel ng_srcn]
    jae  .rw_out
    cmp  qword [rel ng_err_msg], 0
    jne  .rw_out
    mov  ecx, ebx
    call ng_srct
    mov  r12, rax                    ; the token
    ; its module
    mov  r13d, [rel ng_ctxmod]
    cmp  dword [rel ng_main], 0
    je   .rw_mod
    lea  rax, [rel ng_tokmod]
    movzx r13d, byte [rax + rbx]
    ; a template: skipped, and in the last round its copies written here
    lea  rax, [rel ng_tokflag]
    mov  eax, [rax + rbx*4]
    test eax, eax
    jz   .rw_mod
    dec  eax
    mov  r14d, eax
    cmp  dword [rel ng_round], 2
    jne  .rw_tskip
    call ng_put_copies
.rw_tskip:
    lea  rax, [rel ng_t_end]
    mov  ebx, [rax + r14*4]
    jmp  .rw_l
.rw_mod:
    mov  rax, [r12 + TOKEN.type]
    cmp  rax, TOK_IDENT
    jne  .rw_copy
    ; previous token: after a '.', a name is a field
    xor  r14d, r14d                  ; previous type
    test ebx, ebx
    jz   .rw_noprev
    lea  rcx, [rbx - 1]
    call ng_stype
    mov  r14, rax
.rw_noprev:
    cmp  r14, TOK_DOT
    je   .rw_copy
    ; module.name
    lea  rcx, [rbx + 1]
    call ng_stype
    cmp  rax, TOK_DOT
    jne  .rw_notqual
    lea  rcx, [rbx + 2]
    call ng_stype
    cmp  rax, TOK_IDENT
    jne  .rw_notqual
    mov  rdi, r12
    call ng_find_mod
    cmp  eax, -1
    je   .rw_notqual
    mov  r15d, eax                   ; the module
    lea  rcx, [rbx + 2]
    call ng_srct
    mov  rdi, rax
    mov  esi, r15d
    xor  edx, edx
    call ng_find_decl
    cmp  eax, -1
    je   .rw_notqual                 ; a variable that happens to share the name
    lea  rcx, [rel ng_d_kind]
    cmp  byte [rcx + rax], 3
    je   .rw_qual_t
    lea  rcx, [rel ng_d_dup]
    cmp  byte [rcx + rax], 0
    jne  .rw_qual_dup
    lea  rcx, [rbx + 2]
    call ng_srct
    mov  rsi, rax
    call ng_emit
    add  ebx, 3
    jmp  .rw_l
.rw_qual_dup:
    lea  rcx, [rbx + 2]
    call ng_srct
    push rax
    mov  rdi, rax
    mov  esi, r15d
    call ng_dupname
    mov  rdi, rax
    pop  rsi
    call ng_emit_named
    add  ebx, 3
    jmp  .rw_l
.rw_qual_t:
    add  ebx, 2                      ; the template's name, read next
    jmp  .rw_l
.rw_notqual:
    ; a template's name
    mov  rdi, r12
    call ng_find_t
    cmp  eax, -1
    je   .rw_notemplate
    mov  r15d, eax
    lea  rcx, [rbx + 1]
    call ng_stype
    cmp  rax, TOK_LT
    jne  .rw_t_nolt
    mov  [rel ng_use_at], ebx
    mov  eax, r15d
    push rbx
    call ng_use
    mov  ecx, ebx
    pop  rbx
    test eax, eax
    jz   .rw_copy
    mov  ebx, ecx
    jmp  .rw_l
.rw_t_nolt:
    cmp  rax, TOK_LPAREN
    jne  .rw_copy
    lea  rax, [rel ng_t_isfn]
    cmp  byte [rax + r15], 0
    je   .rw_copy
    mov  rdi, r12
    lea  rsi, [rel ng_msg_notypes]
    call ng_err
    jmp  .rw_out
.rw_notemplate:
    ; a function two modules define, called or named
    cmp  dword [rel ng_anydup], 0
    je   .rw_copy
    mov  rdi, r12
    mov  esi, -1
    mov  dl, 1
    call ng_find_decl
    cmp  eax, -1
    je   .rw_copy
    lea  rcx, [rel ng_d_dup]
    cmp  byte [rcx + rax], 0
    je   .rw_copy
    ; only where a function is meant: f(...), &f, fn f
    lea  rcx, [rbx + 1]
    call ng_stype
    cmp  rax, TOK_LPAREN
    je   .rw_dup
    cmp  r14, TOK_AMPERSAND
    je   .rw_dup
    cmp  r14, TOK_KW_FN
    je   .rw_dup
    cmp  ebx, 2
    jb   .rw_copy
    cmp  r14, 100
    jb   .rw_copy
    lea  rcx, [rbx - 2]
    call ng_stype
    cmp  rax, TOK_KW_FN
    jne  .rw_copy
.rw_dup:
    ; this module's own, if it has one
    mov  rdi, r12
    mov  esi, r13d
    mov  dl, 1
    call ng_find_decl
    cmp  eax, -1
    jne  .rw_dup_own
    mov  rdi, r12
    lea  rsi, [rel ng_msg_ambig]
    call ng_err
    jmp  .rw_out
.rw_dup_own:
    mov  rdi, r12
    mov  esi, r13d
    call ng_dupname
    mov  rdi, rax
    mov  rsi, r12
    call ng_emit_named
    inc  ebx
    jmp  .rw_l
.rw_copy:
    mov  rsi, r12
    call ng_emit
    inc  ebx
    jmp  .rw_l
.rw_out:
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; ng_put_copies(r14d = template): its copies, made already, into the
; destination
ng_put_copies:
    push rbx
    push r12
    xor  ebx, ebx
.pc_l:
    cmp  ebx, [rel ng_ni]
    jae  .pc_out
    lea  rax, [rel ng_i_t]
    mov  r11d, [rax + rbx*4]
    cmp  r11d, r14d
    jne  .pc_next
    lea  rax, [rel ng_i_bodyn]
    mov  ecx, [rax + rbx*4]
    cmp  ecx, -1
    je   .pc_next
    lea  rax, [rel ng_i_bodyb]
    mov  r12d, [rax + rbx*4]
.pc_tok:
    test ecx, ecx
    jz   .pc_next
    push rcx
    imul rsi, r12, TOKEN_SIZE
    lea  rax, [rel ng_itok]
    add  rsi, rax
    call ng_emit
    pop  rcx
    inc  r12d
    dec  ecx
    jmp  .pc_tok
.pc_next:
    inc  ebx
    jmp  .pc_l
.pc_out:
    pop  r12
    pop  rbx
    ret

; ng_make(ebx = a copy): its tokens -- the template's, with each parameter
; replaced by its type -- rewritten into ng_itok
ng_make:
    push rbx
    push r12
    push r13
    push r14
    push r15
    lea  rax, [rel ng_i_t]
    mov  r12d, [rax + rbx*4]         ; template
    ; 1. substituted, into ng_sub
    mov  dword [rel ng_nsub], 0
    lea  rax, [rel ng_sub]
    mov  [rel ng_dst], rax
    lea  rax, [rel ng_nsub]
    mov  [rel ng_dstn], rax
    lea  rax, [rel ng_t_start]
    mov  r13d, [rax + r12*4]         ; fn / struct ... up to the name
    lea  rax, [rel ng_t_lt]
    mov  r15d, [rax + r12*4]         ; '<'
.mk_head:
    lea  rax, [r15 - 1]
    cmp  r13d, eax
    jae  .mk_name
    imul rsi, r13, TOKEN_SIZE
    add  rsi, [rel ng_tok]
    call ng_emit
    inc  r13d
    jmp  .mk_head
.mk_name:
    imul rsi, r13, TOKEN_SIZE
    add  rsi, [rel ng_tok]
    lea  rax, [rel ng_i_name]
    mov  rdi, [rax + rbx*8]
    lea  rax, [rel ng_i_nlen]
    mov  ecx, [rax + rbx*4]
    call ng_emit_named
    lea  rax, [rel ng_t_body]
    mov  r13d, [rax + r12*4]
    lea  rax, [rel ng_t_end]
    mov  r15d, [rax + r12*4]
.mk_body:
    cmp  r13d, r15d
    jae  .mk_subst_done
    imul rsi, r13, TOKEN_SIZE
    add  rsi, [rel ng_tok]
    cmp  qword [rsi + TOKEN.type], TOK_IDENT
    jne  .mk_plain
    ; one of the parameters?
    xor  r14d, r14d
.mk_par:
    lea  rax, [rel ng_t_np]
    cmp  r14d, [rax + r12*4]
    jae  .mk_plain
    mov  eax, r12d
    shl  eax, 3
    add  eax, r14d
    lea  rcx, [rel ng_t_par]
    mov  rdi, [rcx + rax*8]
    push rsi
    call ng_teq
    pop  rsi
    test eax, eax
    jnz  .mk_type
    inc  r14d
    jmp  .mk_par
.mk_type:
    mov  eax, ebx
    shl  eax, 3
    add  eax, r14d
    lea  rcx, [rel ng_i_argb]
    mov  r8d, [rcx + rax*4]
    lea  rcx, [rel ng_i_argn]
    mov  r9d, [rcx + rax*4]
.mk_type_l:
    test r9d, r9d
    jz   .mk_next
    push r8
    push r9
    imul rsi, r8, TOKEN_SIZE
    lea  rax, [rel ng_args]
    add  rsi, rax
    call ng_emit
    pop  r9
    pop  r8
    inc  r8d
    dec  r9d
    jmp  .mk_type_l
.mk_plain:
    call ng_emit
.mk_next:
    inc  r13d
    jmp  .mk_body
.mk_subst_done:
    ; 2. rewritten, so the copy's own uses of generics and modules resolve
    lea  rax, [rel ng_itok]
    mov  [rel ng_dst], rax
    lea  rax, [rel ng_nitok]
    mov  [rel ng_dstn], rax
    lea  rax, [rel ng_sub]
    mov  [rel ng_src], rax
    mov  eax, [rel ng_nsub]
    mov  [rel ng_srcn], eax
    mov  dword [rel ng_main], 0
    lea  rax, [rel ng_t_mod]
    mov  eax, [rax + r12*4]
    mov  [rel ng_ctxmod], eax
    mov  eax, [rel ng_nitok]
    lea  rcx, [rel ng_i_bodyb]
    mov  [rcx + rbx*4], eax
    call ng_rw
    mov  eax, [rel ng_nitok]
    lea  rcx, [rel ng_i_bodyb]
    sub  eax, [rcx + rbx*4]
    lea  rcx, [rel ng_i_bodyn]
    mov  [rcx + rbx*4], eax
    pop  r15
    pop  r14
    pop  r13
    pop  r12
    pop  rbx
    ret

; ng_main_pass(): the program's tokens rewritten into ng_out
ng_main_pass:
    mov  dword [rel ng_nout], 0
    lea  rax, [rel ng_out]
    mov  [rel ng_dst], rax
    lea  rax, [rel ng_nout]
    mov  [rel ng_dstn], rax
    mov  rax, [rel ng_tok]
    mov  [rel ng_src], rax
    mov  rax, [rel ng_cnt]
    mov  [rel ng_srcn], eax
    mov  dword [rel ng_main], 1
    jmp  ng_rw

; ng_run(rdi = tokens, rsi = count) -> rax = the new count, or 0 with
; ng_err_tok / ng_err_msg saying why. Nothing changes when the program has
; no templates and no module names to resolve.
ng_run:
    push rbx
    mov  [rel ng_tok], rdi
    mov  [rel ng_cnt], rsi
    mov  qword [rel ng_err_msg], 0
    mov  qword [rel ng_err_tok], 0
    mov  dword [rel ng_ni], 0
    mov  dword [rel ng_nargs], 0
    mov  dword [rel ng_nitok], 0
    mov  dword [rel ng_ntext], 0
    cmp  rsi, NG_MAXTOK - 2
    jae  .nr_same                    ; too big for the tables: left alone
    call ng_modules
    call ng_decls
    ; 1. the program, for the copies it asks for
    mov  dword [rel ng_round], 1
    call ng_main_pass
    cmp  qword [rel ng_err_msg], 0
    jne  .nr_err
    ; 2. each copy, which may ask for more
    xor  ebx, ebx
.nr_make:
    cmp  ebx, [rel ng_ni]
    jae  .nr_final
    call ng_make
    cmp  qword [rel ng_err_msg], 0
    jne  .nr_err
    inc  ebx
    jmp  .nr_make
.nr_final:
    ; 3. the program again, the copies written where their templates were
    mov  dword [rel ng_round], 2
    call ng_main_pass
    cmp  qword [rel ng_err_msg], 0
    jne  .nr_err
    ; back into the lexer's array
    mov  ecx, [rel ng_nout]
    mov  rdi, [rel ng_tok]
    lea  rsi, [rel ng_out]
    imul rcx, rcx, TOKEN_SIZE
.nr_copy:
    test rcx, rcx
    jz   .nr_copied
    mov  al, [rsi]
    mov  [rdi], al
    inc  rsi
    inc  rdi
    dec  rcx
    jmp  .nr_copy
.nr_copied:
    mov  eax, [rel ng_nout]
    pop  rbx
    ret
.nr_same:
    mov  rax, [rel ng_cnt]
    pop  rbx
    ret
.nr_err:
    xor  eax, eax
    pop  rbx
    ret
