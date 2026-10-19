; ==============================================================================
; KRON COMPILER - GLOBAL TYPES AND CONSTANTS
; File: include/kron_types.inc
; Architecture: x86-64 (NASM)
; ==============================================================================

; --- TOKEN TYPES ---
%define TOK_EOF             0
%define TOK_IDENT           1       ; Alias for the parser
%define TOK_IDENTIFIER      1       ; Alias for the lexer
%define TOK_NUMBER          2       ; Numbers (int, float)
%define TOK_INTEGER         2
%define TOK_FLOAT           3
%define TOK_STRING          4
%define TOK_HEX             5
%define TOK_BOOLEAN         6

; --- PUNCTUATION ---
%define TOK_LBRACE          10   ; {
%define TOK_RBRACE          11   ; }
%define TOK_LPAREN          12   ; (
%define TOK_RPAREN          13   ; )
%define TOK_LBRACKET        14   ; [
%define TOK_RBRACKET        15   ; ]
%define TOK_SEMICOLON       16   ; ;
%define TOK_COLON           17   ; :
%define TOK_COMMA           18   ; ,
%define TOK_DOT             19   ; .
%define TOK_ASSIGN          20   ; =
%define TOK_ARROW           21   ; ->
%define TOK_EXPECT_EXPR     98      ; not a real token: 'an expression', for error messages
%define TOK_DOUBLE_COLON    22   ; ::

; --- OPERATORS ---
%define TOK_PLUS            30
%define TOK_MINUS           31
%define TOK_STAR            32
%define TOK_SLASH           33
%define TOK_PERCENT         34
%define TOK_AMPERSAND       35
%define TOK_PIPE            36
%define TOK_CARET           37
%define TOK_TILDE           38
%define TOK_LSHIFT          39
%define TOK_RSHIFT          40
%define TOK_EQ              41   ; ==
%define TOK_NEQ             42   ; !=
%define TOK_LT              43   ; <
%define TOK_GT              44   ; >
%define TOK_LTE             45   ; <=
%define TOK_GTE             46   ; >=
%define TOK_AND             47   ; &&
%define TOK_OR              48   ; ||
%define TOK_NOT             49
%define TOK_URSHIFT         50   ; >>>  logical shift right, no sign fill
; --- compound assignment (grammar section 04) ---
%define TOK_PLUS_ASSIGN     51   ; +=
%define TOK_MINUS_ASSIGN    52   ; -=
%define TOK_STAR_ASSIGN     53   ; *=
%define TOK_SLASH_ASSIGN    54   ; /=
%define TOK_XOR_ASSIGN      55   ; ^=   ; !

; --- KEYWORDS LEVEL 1: PRIMITIVE TYPES ---
%define TOK_KW_VAR          100
%define KW_VAR              100
%define TOK_KW_CONST        101
%define KW_CONST            101
%define TOK_KW_FN           102
%define KW_FN               102
%define TOK_KW_RETURN       103
%define KW_RETURN           103
%define TOK_KW_IF           104
%define KW_IF               104
%define TOK_KW_ELSE         105
%define KW_ELSE             105
%define TOK_KW_LOOP         106
%define KW_LOOP             106
%define TOK_KW_IN           107
%define KW_IN               107
%define TOK_KW_WHILE        108
%define KW_WHILE            108
%define KW_FOR              123
%define TOK_KW_FOR          123
%define KW_PRINTC           124
%define TOK_KW_PRINTC       124
%define TOK_KW_BREAK        109
%define KW_BREAK            109
%define TOK_KW_CONTINUE     110
%define KW_CONTINUE         110
%define TOK_KW_PRINT        111
%define KW_PRINT            111
%define KW_RANGE            112
%define KW_TRUE             113
%define KW_FALSE            114
%define KW_NULL             115
%define KW_IMPORT           116
%define KW_FROM             117
%define KW_MODULE           118
%define KW_STRUCT           119
%define KW_ENUM             120
%define KW_NEW              121
%define KW_DELETE           122

; --- RAW HARDWARE TYPES ---
%define KW_U8               130
%define KW_U16              131
%define KW_U32              132
%define KW_U64              133
%define KW_I8               134
%define KW_I16              135
%define KW_I32              136
%define KW_I64              137
%define KW_F32              138
%define KW_F64              139
%define KW_BOOL             140
%define KW_STR              141
%define KW_VOID             142

; --- KEYWORDS LEVEL 2: OS/KERNEL ---
%define KW_BOOT_SEQUENCE        200
%define KW_MMU_CONFIGURATION    201
%define KW_SCHEDULER_DOMAIN     202
%define KW_SYSCALL_DISPATCH     203
%define KW_FILESYSTEM_VOLUME    204
%define KW_NETWORK_KERNEL       205
%define KW_HARDWARE_DRIVER      206
%define KW_INTERRUPT_SERVICE    207
%define KW_DMA_CHANNEL          208
%define KW_SECURITY_RING        209

; --- KEYWORDS LEVEL 3: COMPUTE ENGINES ---
%define KW_GPU_SHADER_PIPELINE  300
%define KW_KRON3D_CONTEXT    301
%define KW_PHYSICS_WORLD        302
%define KW_QUANTUM_CIRCUIT      303
%define KW_AI_INFERENCE         304
%define KW_NEURAL_NETWORK       305
%define KW_TENSOR_ACCELERATOR   306

; --- KEYWORDS LEVEL 4: EXOTIC ---
%define KW_DNA_STORAGE          400
%define KW_PHOTONIC_TENSOR      401
%define KW_ORBITAL_MESH         402
%define KW_PLASMA_REACTOR       403
%define KW_NANO_SWARM           404
%define KW_RELATIVISTIC_TIME    405
%define KW_ZERO_TRUST_FABRIC    406
%define KW_NEUROMORPHIC_MESH    407
%define KW_SYNTHETIC_WETWARE    408

; --- KEYWORDS LEVEL 5: ECOSYSTEM ---
%define KW_KRON_ISA          500
%define KW_LIVING_COMPILER      501
%define KW_EXECUTION_MODEL      502
%define KW_KERNEL_ARCHITECTURE  503
%define KW_SECURITY_MODEL       504
%define KW_KRON_HYPERVISOR   505
%define KW_DEPLOYMENT_MODEL     506
%define KW_HUMAN_MACHINE        507
%define KW_POWER_MANAGER        508
%define KW_PACKAGE_MANAGER      509

; --- VISIBILITY MODIFIERS (interoperability / symbol export) ---
%define KW_GLOBAL_VISIBLE       510
%define KW_DOMAIN_ISOLATED      511
%define KW_ENCLAVE_HIDDEN       512
%define KW_INTER_CLUSTER_EXPORT 513

; --- VISIBILITY FLAGS stored in AST.type_info of an AST_FUNCTION ---
%define VIS_DEFAULT             0
%define VIS_EXPORTED            1

; --- TOKEN STRUCTURE (24 bytes) ---
; Offset 0:  type     (8 bytes - u64)
; Offset 8:  value    (8 bytes - ptr to string)
; Offset 16: length   (4 bytes - u32)
; Offset 20: line     (2 bytes - u16)
; Offset 22: col      (2 bytes - u16)
%define TOKEN_SIZE          24
%define TOKEN.type          0
%define TOKEN.value         8
%define TOKEN.length        16
%define TOKEN.line          20
%define TOKEN.col           22

; --- AST NODE TYPES ---
%define AST_PROGRAM         1000
%define AST_FUNCTION        1001
%define AST_BLOCK           1002
%define AST_VAR_DECL        1003
%define AST_CONST_DECL      1004
%define AST_ASSIGN          1005
%define AST_BINOP           1006
%define AST_UNOP            1007
%define AST_CALL            1008
%define AST_RETURN          1009
%define AST_IF              1010
%define AST_WHILE           1011
%define AST_LOOP_IN         1012
%define AST_BREAK           1013
%define AST_CONTINUE        1014
%define AST_IDENTIFIER      1015
%define AST_INTEGER_LIT     1016
%define AST_FLOAT_LIT       1017
%define AST_STRING_LIT      1018
%define AST_BOOL_LIT        1019
%define AST_STRUCT_DEF      1020
%define AST_ENUM_DEF        1021
%define AST_IMPORT          1022
%define AST_MODULE          1023
%define AST_HARDWARE_BLOCK  1024
%define AST_PRINT           1025
%define AST_PRINTC          1061

; --- M01: ISA DEFINITION ---
%define AST_ISA_DEF         1030
%define AST_ISA_ENTRY       1031

; --- M02: KERNEL BOOT ---
%define AST_BOOT_DEF        1032
%define AST_BOOT_REG        1033

; --- M03: MEMORY MANAGEMENT ---
%define AST_MMU_DEF         1034
%define AST_MMU_LEVEL       1035

; --- M04: HARDWARE INTERRUPTS ---
%define AST_ISR_DEF         1036

; --- GENERIC key=value CONFIGURATION (M05 onward) ---
%define AST_CFG_DEF         1037
%define AST_CFG_ENTRY       1038

; --- M08: PROCESS SCHEDULER ---
%define AST_SCHED_DEF       1039

; --- M09: SYSCALL DISPATCH ---
%define AST_SYS_DEF         1040
%define AST_SYS_ENTRY       1041

; --- HARDWARE PRIMITIVES (creation tool) ---
%define AST_OUTB            1042
%define AST_INB             1043
%define AST_POKE            1044
%define AST_PEEK            1045
%define AST_TRUNC           1062
%define AST_SAVEFILE        1063
%define AST_READKEY         1064
%define AST_BEEP            1065
%define AST_READMOUSE       1066
%define AST_MOUSEX          1067
%define AST_MOUSEY          1068
%define AST_ASM             1046
%define AST_INDEX           1047
%define AST_ADDR_OF         1048
%define AST_DEREF           1049
%define AST_POKE8           1050
%define AST_POKE16          1051
%define AST_POKE32          1052
%define AST_PEEK8           1053
%define AST_PEEK16          1054
%define AST_PEEK32          1055
%define AST_PARAM           1056
%define AST_ARG             1057
%define AST_FIELD           1058
%define AST_MEMBER          1059
%define AST_CALL_INDIRECT   1060   ; call <ptr-expr>(args) -- left=pointer expr, right=arg list

; --- M03 heap_arena_definition ---
; AST_ARENA_ENTRY: data=name token, left=base_address token,
; type_info=size_bytes token, child_count=growth policy, right=next entry.
; The chain head hangs off AST.left of the enclosing AST_MMU_DEF.
%define AST_ARENA_ENTRY     1069
%define ARENA_GROWTH_FIXED      0   ; fixed_static
%define ARENA_GROWTH_DOUBLING   1   ; doubling_exponential
%define ARENA_GROWTH_LINEAR     2   ; linear_page_stride
%define ARENA_GROWTH_LAZY       3   ; lazy_on_demand_commit

; --- M03: other mmu_configuration sub-blocks ---
; AST_MMU_ENTRY: child_count = which sub-block, data/left/type_info = its
; values, right = next entry.  The chain head hangs off AST.type_info of the
; enclosing AST_MMU_DEF (left is the arena chain, right the page levels).
%define AST_MMU_ENTRY       1070
%define MMU_ENTRY_CACHE     0   ; data = range literal, left = policy code
%define MMU_ENTRY_NUMA      1   ; data = node, left = cpu_mask, type_info = gbps
%define MMU_ENTRY_GC        2   ; data = policy code
%define MMU_ENTRY_PGFAULT   3   ; data = error_code param token, left = block
%define MMU_ENTRY_OOM       4   ; left = block
%define MMU_ENTRY_POOL      5   ; data = pool name, left = directive chain

; --- dynamic_allocation_pool directives (AST_POOL_DIR, chained by right) ---
%define AST_POOL_DIR        1071
%define POOL_DIR_CLASS      0   ; data = allocator class code
%define POOL_DIR_COMPACT    1   ; data = trigger literal token
%define POOL_DIR_GRAN       2   ; data = granularity literal token
%define POOL_DIR_ONALLOC    3   ; data = param token, left = block
%define POOL_DIR_ONFREE     4   ; data = param token, left = block

%define ALLOC_BUDDY         0   ; buddy_system_binary
%define ALLOC_SLAB          1   ; slab_cache_fixed
%define ALLOC_BUMP          2   ; bump_arena_linear
%define ALLOC_FREELIST      3   ; free_list_segregated
%define ALLOC_PREDICTIVE    4   ; ai_predictive_prefetch_alloc

; --- boot_sequence: mmu_table_init entries (chained off AST_BOOT_DEF.left)
; and load_kernel_elf (its path token goes in AST_BOOT_DEF.type_info) ---
%define AST_BOOT_ENTRY      1072  ; data = address, left = page flags code
; conversion. right = operand, col = target flags (bit0 float, bit1
; unsigned), type_info = target width in bytes
%define AST_CAST            1073
; struct literal:  data = type name token, right = first AST_FINIT.
; Each AST_FINIT has data = field name token (0 when positional),
; left = value expression, right = next.
%define AST_STRUCT_LIT      1074
%define AST_FINIT           1075
; fail: data = message token, left = hint token (0 when absent)
%define AST_FAIL            1076
%define AST_FAILED          1077
%define AST_PRINTFAIL       1078
; sizeof: data = the type token, type_info = its width in bytes
%define AST_SIZEOF          1079
; array literal: right = chain of AST_ARG holding the elements
%define AST_ARRAY_LIT       1080
; SIMD: left = first operand, right = second (or the address for load/store)
%define AST_VEC2_LOAD       1081
%define AST_VEC2_STORE      1082
%define AST_VEC2_ADD        1083
%define AST_VEC2_SUB        1084
%define AST_VEC2_MUL        1085
; loadfile: data = name, left = buffer, right = capacity
%define AST_LOADFILE        1086
%define AST_THREAD_START    1087
%define AST_THREAD_WAIT     1088
%define AST_LOCK_INIT       1089
%define AST_LOCK_TAKE       1090
%define AST_LOCK_GIVE       1091
%define AST_CPU_COUNT       1092
%define AST_TICKS           1093
%define AST_TICKS_PER_SEC   1094
%define AST_THREAD_YIELD    1095    ; thread_yield(): give the time slice away
%define AST_DLL_LOAD        1096    ; dll_load(name): data = keyword, right = name
%define AST_DLL_PROC        1097    ; dll_proc(lib, name): left = lib, right = name
%define AST_ARG_COUNT       1098    ; arg_count()
%define AST_ARG_GET         1099    ; arg_get(i): right = the index
%define AST_TARGET_OS       1100    ; target_os(): a constant chosen by the target
%define AST_LAMBDA          1102    ; fn(x: T) -> R { ... } as a value: data = its
                                    ; name token (__lambda_N), left = params, right
                                    ; = body, col = return flags as a function's
%define AST_FRAMEADDR       1104    ; made by codegen: data = an offset, the value is rbp-data
%define AST_IMM             1105    ; made by codegen: data = a number
%define AST_EXTERN          1103    ; a function of a system library: data = name
                                    ; token (0 for an empty block), left = params,
                                    ; right = the next of its block, owner_type = the
                                    ; names of its libraries (AST_ARG, data = string
                                    ; token), col = 1 when variadic, child_count = the
                                    ; kind of its result (see __ccall)
%define AST_MULTI           1101    ; a, b = f(): left = targets (AST_ARG, left 0
                                    ; for '_'), right = the call
%define BLOCK_SPLICE        0x53504C ; AST.type_info of a statement list the parser
                                    ; made from one statement: spliced into its block
%define PGFLAG_RW_KERNEL    0   ; read_write_kernel
%define PGFLAG_RO_USER      1   ; read_only_user
%define PGFLAG_EXEC_DIS     2   ; execute_disable
%define PGFLAG_CACHE_BYPASS 3   ; cache_bypass
%define CACHE_WRITE_BACK    0
%define CACHE_WRITE_THROUGH 1
%define GC_MANUAL_ONLY      0
%define GC_REF_COUNTED      1
%define GC_MARK_SWEEP       2
%define GC_GENERATIONAL     3


%define KW_EXECUTABLE_LOADER    531
%define KW_PTR                  532
%define KW_ARENA_TOKEN          541   ; ArenaAllocationToken<T>
%define KW_ROTL                 542   ; rotate_left_native
%define KW_ROTR                 543   ; rotate_right_native
%define KW_INVCACHE             544   ; invalidate_cache_line
%define KW_PREFETCH0            545   ; prefetch_t0_cache
; --- section 01: module header ---
%define KW_KRON_PROGRAM          546   ; kron_program
%define KW_KRON_IMPORTS          547   ; kron_imports
%define KW_KRON_DEFINITIONS     548   ; kron_definitions
%define KW_KRON_DOMAIN           549   ; kron_domain
%define KW_EPOCH                550   ; epoch
%define KW_ALIASED              551   ; aliased
; --- section 04: switch ---
%define KW_SWITCH               552
%define KW_CASE                 553
%define KW_DEFAULT              554
%define KW_CALL                 533   ; 'call' -- indirect call through a function pointer
%define TOK_CALL                533   ; alias, used by the parser like TOK_* names

%define KW_POKE8            525
%define KW_POKE16           526
%define KW_POKE32           527
%define KW_PEEK8            528
%define KW_PEEK16           529
%define KW_PEEK32           530

%define KW_OUTB             520
%define KW_INB              521
%define KW_POKE             522
%define KW_PEEK             523
%define KW_TRUNC            534
%define KW_SAVEFILE         535
%define KW_READKEY          536
%define KW_BEEP             537
%define KW_READMOUSE        538
%define KW_MOUSEX           539
%define KW_MOUSEY           540
%define KW_ASM              524
%define KW_AS               555   ; conversion:  x as f64
; Failure reporting. 'fail' returns at once with a cause and a hint recorded;
; the caller asks with failed() and prints with print_fail(). No stack
; unwinding and no runtime, so it works inside an interrupt handler.
%define KW_FAIL             556
%define KW_HINT             557
%define KW_FAILED           558
%define KW_PRINTFAIL        559
%define KW_SIZEOF           560   ; sizeof(T), resolved at compile time
; loadfile(name, buffer, capacity) -> bytes read, or 0 when the file will not
; open. The counterpart of savefile, which could only write: without this the
; language could produce data but never consume any.
%define KW_LOADFILE         566
; Threads. The engine needs them in three places: hashing leaves in parallel,
; scanning a tenant's records, and serving more than one connection at a
; time. Without them the whole program is one core.
;
;   var h: i64;
;   h = thread_start(&work, 7);      -- start, passing one argument
;   thread_wait(h);                  -- block until it finishes
;
;   lock_init(0);                    -- locks are numbered, not objects
;   lock_take(0);                    -- there are no opaque types
;   lock_give(0);
%define KW_THREAD_START     567
%define KW_THREAD_WAIT      568
%define KW_LOCK_INIT        569
%define KW_LOCK_TAKE        570
%define KW_LOCK_GIVE        571
%define KW_CPU_COUNT        572
; ticks() -> the high-resolution counter, and ticks_per_sec() -> its rate.
; Two calls and a division give elapsed seconds. Without them there is no way
; to tell whether a change made anything faster, and every claim about speed
; is a guess.
%define KW_TICKS            573
%define KW_TICKS_PER_SEC    574
%define KW_RAW              575     ; raw { ... }: where peek and poke belong
%define KW_SLICE            576     ; slice<T>: a run of an arena, see std_arena.kr
%define KW_THREAD_YIELD     577     ; thread_yield()
%define KW_SHARED           578     ; shared var: a global threads may touch
%define KW_DLL_LOAD         579     ; dll_load("x.dll") -> library handle, inside raw
%define KW_DLL_PROC         580     ; dll_proc(lib, "name") -> function address, inside raw
%define KW_ARG_COUNT        581     ; arg_count(): how many command-line arguments, program included
%define KW_ARG_GET          582     ; arg_get(i): address of argument i, NUL-terminated
%define KW_TARGET_OS        583     ; target_os(): 1 Windows, 2 Linux, 3 krn, 4 bare
%define KW_EXTERN           584     ; extern "lib", ... { fn f(...) -> T; }: the system's libraries
; SIMD intrinsics. Two f64 travel in one xmm register, which fits in no
; scalar type, so these only compose by nesting: the result of a load or an
; operation feeds straight into the next one and never lands in a variable.
;
;   vec2_store(&c[i], vec2_mul(vec2_load(&a[i]), vec2_load(&b[i])));
%define KW_VEC2_LOAD        561
%define KW_VEC2_STORE       562
%define KW_VEC2_ADD         563
%define KW_VEC2_SUB         564
%define KW_VEC2_MUL         565

; --- AST NODE STRUCTURE (56 bytes) ---
; Offset 0:  node_type    (8 bytes)
; Offset 8:  left         (8 bytes - ptr)
; Offset 16: right        (8 bytes - ptr)
; Offset 24: data         (8 bytes - ptr / value)
; Offset 32: child_count  (4 bytes)
; Offset 36: line         (2 bytes)
; Offset 38: col          (2 bytes)
; Offset 40: type_info    (8 bytes)
; Offset 48: owner_type   (8 bytes - ptr)
;
; owner_type is free on every node except AST_FUNCTION, where it holds the
; receiver type token of a method (fn Vec3.length -> token of 'Vec3').  Zero
; means "plain function".  It could not share type_info: on an AST_FUNCTION
; that field already carries the visibility flags below.
%define AST_NODE_SIZE       56
%define AST.node_type       0
%define AST.left            8
%define AST.right           16
%define AST.data            24
%define AST.child_count     32
%define AST.line            36
%define AST.col             38
%define AST.type_info       40
%define AST.owner_type      48

; marker stored in AST.type_info of a CFG entry that is an on_* code handler
%define CFG_HANDLER_MARK    0xFFFF

; --- KRON DATA TYPES ---
%define JTYPE_VOID          0
%define JTYPE_BOOL          1
%define JTYPE_U8            2
%define JTYPE_U16           3
%define JTYPE_U32           4
%define JTYPE_U64           5
%define JTYPE_I8            6
%define JTYPE_I16           7
%define JTYPE_I32           8
%define JTYPE_I64           9
%define JTYPE_F32           10
%define JTYPE_F64           11
%define JTYPE_STR           12
%define JTYPE_STRUCT        13
%define JTYPE_ENUM          14
%define JTYPE_FN            15
%define JTYPE_PTR           16
%define JTYPE_ARENA_TOKEN   17

; --- ERROR CODES ---
%define ERR_OK              0
%define ERR_LEX             1
%define ERR_PARSE           2
%define ERR_SEMANTIC        3
%define ERR_CODEGEN         4
%define ERR_IO              5
%define ERR_OOM             6

; --- BUFFER SIZES ---
; --- OUTPUT TARGETS ---
%define TARGET_PE           0       ; Windows executable
%define TARGET_ELF          1       ; Linux executable
%define TARGET_KRN          2       ; Kron system executable
%define TARGET_BARE         3       ; flat binary, no operating system
%define TARGET_ARM64        4       ; Linux on ARM64: xarm lowers the Linux program, karm assembles it
%define TARGET_WEB          5       ; WebAssembly in a browser (or node): xwasm
%define TARGET_MACOS        6       ; macOS on Apple silicon: xarm with its macOS shim, Mach-O

%define SRC_BUFFER_SIZE     (4  * 1024 * 1024)   ; 4  MB  source .kr
; acquire_domain resolution (main.asm)
%define IMP_MAX             64      ; modules a program can pull in, in total
%define IMP_DEPTH           8       ; how deep imports may nest
%define IMP_KIDS            16      ; imports one file may declare
%define CG_MAX_LOOPS        64      ; loops nested inside one another
%define BLOCK_RAW           0x524157 ; AST.type_info of a block written as raw { }
%define SLICE_GET_MARK      0x534C4943 ; AST.owner_type of a call the parser made from v[i]
%define SEM_MAX_WARN        64      ; warnings the semantic pass keeps
%define TOKEN_BUFFER_SIZE   (8  * 1024 * 1024)   ; 8  MB  token table
%define AST_BUFFER_SIZE     (32 * 1024 * 1024)   ; 32 MB  AST nodes
%define CODE_BUFFER_SIZE    (8  * 1024 * 1024)   ; 8  MB  generated code
%define SYM_BUFFER_SIZE     (4  * 1024 * 1024)   ; 4  MB  symbol table

; --- CODEGEN TABLE CAPACITIES (raised from the original 64/128 ceilings) ---
%define CG_MAX_VARS         1024   ; local variables per function
; --- intermediate representation (codegen) ---------------------------------
; A function's output is captured as records before it is written, so it can
; be analysed as a whole. See ir_capture in codegen.asm.
%define IR_RAW              1               ; text taken as is
%define IR_LDLOC            2               ; mov rax, [rbp-N]   operand = N
%define IR_STLOC            3               ; mov [rbp-N], rax   operand = N
%define IR_LABEL            4               ; .LN:               operand = N
%define IR_JMP              5               ; jmp .LN
%define IR_JZ               6               ; test rax,rax / jz .LN
%define IR_JNZ              7               ; test rax,rax / jnz .LN
%define IR_RETLBL           8               ; .__ret_N:
%define IR_JMPRET           9               ; jmp .__ret_N
%define IR_FRAME            10              ; sub rsp, N        operand = N
%define IR_LDRCX            11              ; mov rcx, [rbp-N]   operand = N
%define IR_JCC              12              ; j<cc> .LN          operand = N, length = CC_*
; conditions for IR_JCC, in the order of s_jcc_tab
%define CC_E                0
%define CC_NE               1
%define CC_L                2
%define CC_GE               3
%define CC_G                4
%define CC_LE               5
%define CC_B                6
%define CC_AE               7
%define CC_A                8
%define CC_BE               9
%define IR_ALU              13              ; op rax, rcx        operand = ALU_*
%define IR_IMMRCX           14              ; mov rcx, <const>   operand = token, 0 = zero
%define IR_STPARAM          15              ; mov [rbp-N], <arg> operand = N, length = 0..5
%define IR_LDARG            16              ; mov <arg>, [rbp-N] operand = N, length = 0..5
%define IR_IMMARG           17              ; mov <arg>, <const> operand = token, length = 0..5
%define IR_FLDLOC           18              ; movsd xmm0, [rbp-N] operand = N
%define IR_FSTLOC           19              ; movsd [rbp-N], xmm0 operand = N
%define IR_FSTPARAM         20              ; movsd [rbp-N], xmmK operand = N, length = K
%define IR_FLDX1            21              ; movsd xmm1, [rbp-N] operand = N
; operations for IR_ALU, in the order of s_alu_tab
%define ALU_ADD             0
%define ALU_SUB             1
%define ALU_IMUL            2
%define ALU_AND             3
%define ALU_OR              4
%define ALU_XOR             5
%define ALU_CMP             6
; register allocation
%define RA_MAXCAND          64              ; candidates per function: one qword
%define RA_MAXBLK           4096            ; basic blocks per function
%define RA_MAXLBL           65536           ; label ids the map can hold
%define RA_TRACE            0               ; 1 = write the analysis as comments
%define RA_ENABLE           1               ; 0 = analyse only, keep locals in memory
%define RA_REGS             5               ; rbx, r12, r13, r14, r15
; xmm6 .. xmm15: Windows preserves all ten, and a Kron function saves the ones
; it uses itself, on every target. kasm writes the REX byte xmm8 and up need
; on every SSE form it knows (sse_rex).
%define RA_FREGS            10              ; xmm6 .. xmm15
%define IR_MAX_RECS         262144          ; records per function
%define IR_TEXT_SIZE        (4 * 1024 * 1024) ; text per function
%define CG_MAX_FUNCS        4096   ; functions per program: the whole library is over 600
%define CG_MAX_STRUCTS      256    ; struct definitions
%define CG_MAX_GLOBALS      4096   ; file-scope globals
%define CG_MAX_EDGES        65536  ; call edges recorded for the thread check
%define CG_MAX_FIELDS       4096   ; struct fields (all structs combined)
%define CG_MAX_EXTERN       1024   ; extern functions


; --- EXTRA ERROR CODES ---
%define ERR_UNDEF_SYMBOL    7
%define ERR_LINK_FAILED     8
%define ERR_BAD_RELOC       9

; --- LINKER: SYMBOL TABLE ---
; Each entry in the linker's symbol table:
; Offset  0: name_ptr  (8)  pointer to the name
; Offset  8: name_len  (4)  length of the name
; Offset 12: flags     (4)  flags (global, extern, etc)
; Offset 16: address   (8)  resolved address
; Offset 24: reserved  (8)
%define SYM_ENTRY_SIZE      32
%define SYM_NAME            0    ; offset of name_ptr inside the entry
%define SYM_NAME_LEN        8    ; offset name_len
%define SYM_FLAGS           12   ; offset flags
%define SYM_ADDRESS         16   ; resolved offset address

; --- LINKER: RELOCATION TABLE ---
; Each reloc entry:
; Offset  0: offset   (8)  where to apply the patch
; Offset  8: sym_name (8)  pointer to the symbol name
; Offset 16: type     (4)  reloc type
; Offset 20: addend   (4)  value to add
%define RELOC_ENTRY_SIZE    24
%define RELOC_OFFSET        0    ; offset of the offset field inside a reloc entry
%define RELOC_SYM_NAME      8    ; offset of the sym_name field
%define RELOC_TYPE          16   ; offset of the type field
%define RELOC_ADDEND        20   ; offset of the addend field

; Relocation types
%define RELOC_ABS64         0    ; absolute 64-bit patch
%define RELOC_REL32         1    ; relative 32-bit patch (RIP-relative)
%define RELOC_ABS32         2    ; absolute 32-bit patch

; --- ARENA ALLOCATOR (for AST nodes) ---
%define ARENA_SIZE          (64 * 1024 * 1024)   ; 64 MB

; --- SYMBOL TABLE ---
%define SYMTAB_BUCKETS      4096
%define SYMTAB_ENTRY_SIZE   64
; Offset 0:  name_ptr   (8)
; Offset 8:  name_len   (4)
; Offset 12: type       (4)
; Offset 16: scope      (4)
; Offset 20: flags      (4)
; Offset 24: value      (8)
; Offset 32: next       (8)  ; linked list for collisions
; Offset 40: reserved   (24)
%define SYM.name_ptr        0
%define SYM.name_len        8
%define SYM.type            12
%define SYM.scope           16
%define SYM.flags           20
%define SYM.value           24
%define SYM.next            32
%define AST_SYSCALL 29
