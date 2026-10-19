; A Kron module, written by kronc --module. Edit the .kr file it comes
; from, not this one: the build makes it again.
section .data
__g_semantic_TOK_EOF: dq 0
section .text
section .data
__g_semantic_TOK_IDENTIFIER: dq 1
section .text
section .data
__g_semantic_TOK_INTEGER: dq 2
section .text
section .data
__g_semantic_TOK_FLOAT: dq 3
section .text
section .data
__g_semantic_TOK_STRING: dq 4
section .text
section .data
__g_semantic_TOK_HEX: dq 5
section .text
section .data
__g_semantic_TOK_BOOLEAN: dq 6
section .text
section .data
__g_semantic_TOK_EXPECT_EXPR: dq 98
section .text
section .data
__g_semantic_TOK_LBRACE: dq 10
section .text
section .data
__g_semantic_TOK_RBRACE: dq 11
section .text
section .data
__g_semantic_TOK_LPAREN: dq 12
section .text
section .data
__g_semantic_TOK_RPAREN: dq 13
section .text
section .data
__g_semantic_TOK_LBRACKET: dq 14
section .text
section .data
__g_semantic_TOK_RBRACKET: dq 15
section .text
section .data
__g_semantic_TOK_SEMICOLON: dq 16
section .text
section .data
__g_semantic_TOK_COLON: dq 17
section .text
section .data
__g_semantic_TOK_COMMA: dq 18
section .text
section .data
__g_semantic_TOK_DOT: dq 19
section .text
section .data
__g_semantic_TOK_ASSIGN: dq 20
section .text
section .data
__g_semantic_TOK_ARROW: dq 21
section .text
section .data
__g_semantic_TOK_DOUBLE_COLON: dq 22
section .text
section .data
__g_semantic_TOK_PLUS: dq 30
section .text
section .data
__g_semantic_TOK_MINUS: dq 31
section .text
section .data
__g_semantic_TOK_STAR: dq 32
section .text
section .data
__g_semantic_TOK_SLASH: dq 33
section .text
section .data
__g_semantic_TOK_PERCENT: dq 34
section .text
section .data
__g_semantic_TOK_AMPERSAND: dq 35
section .text
section .data
__g_semantic_TOK_PIPE: dq 36
section .text
section .data
__g_semantic_TOK_CARET: dq 37
section .text
section .data
__g_semantic_TOK_TILDE: dq 38
section .text
section .data
__g_semantic_TOK_LSHIFT: dq 39
section .text
section .data
__g_semantic_TOK_RSHIFT: dq 40
section .text
section .data
__g_semantic_TOK_EQ: dq 41
section .text
section .data
__g_semantic_TOK_NEQ: dq 42
section .text
section .data
__g_semantic_TOK_LT: dq 43
section .text
section .data
__g_semantic_TOK_GT: dq 44
section .text
section .data
__g_semantic_TOK_LTE: dq 45
section .text
section .data
__g_semantic_TOK_GTE: dq 46
section .text
section .data
__g_semantic_TOK_AND: dq 47
section .text
section .data
__g_semantic_TOK_OR: dq 48
section .text
section .data
__g_semantic_TOK_NOT: dq 49
section .text
section .data
__g_semantic_TOK_URSHIFT: dq 50
section .text
section .data
__g_semantic_TOK_PLUS_ASSIGN: dq 51
section .text
section .data
__g_semantic_TOK_MINUS_ASSIGN: dq 52
section .text
section .data
__g_semantic_TOK_STAR_ASSIGN: dq 53
section .text
section .data
__g_semantic_TOK_SLASH_ASSIGN: dq 54
section .text
section .data
__g_semantic_TOK_XOR_ASSIGN: dq 55
section .text
section .data
__g_semantic_KW_VAR: dq 100
section .text
section .data
__g_semantic_KW_CONST: dq 101
section .text
section .data
__g_semantic_KW_FN: dq 102
section .text
section .data
__g_semantic_KW_RETURN: dq 103
section .text
section .data
__g_semantic_KW_IF: dq 104
section .text
section .data
__g_semantic_KW_ELSE: dq 105
section .text
section .data
__g_semantic_KW_LOOP: dq 106
section .text
section .data
__g_semantic_KW_IN: dq 107
section .text
section .data
__g_semantic_KW_WHILE: dq 108
section .text
section .data
__g_semantic_KW_BREAK: dq 109
section .text
section .data
__g_semantic_KW_CONTINUE: dq 110
section .text
section .data
__g_semantic_KW_PRINT: dq 111
section .text
section .data
__g_semantic_KW_RANGE: dq 112
section .text
section .data
__g_semantic_KW_TRUE: dq 113
section .text
section .data
__g_semantic_KW_FALSE: dq 114
section .text
section .data
__g_semantic_KW_NULL: dq 115
section .text
section .data
__g_semantic_KW_IMPORT: dq 116
section .text
section .data
__g_semantic_KW_FROM: dq 117
section .text
section .data
__g_semantic_KW_MODULE: dq 118
section .text
section .data
__g_semantic_KW_STRUCT: dq 119
section .text
section .data
__g_semantic_KW_ENUM: dq 120
section .text
section .data
__g_semantic_KW_NEW: dq 121
section .text
section .data
__g_semantic_KW_DELETE: dq 122
section .text
section .data
__g_semantic_KW_FOR: dq 123
section .text
section .data
__g_semantic_KW_PRINTC: dq 124
section .text
section .data
__g_semantic_KW_U8: dq 130
section .text
section .data
__g_semantic_KW_U16: dq 131
section .text
section .data
__g_semantic_KW_U32: dq 132
section .text
section .data
__g_semantic_KW_U64: dq 133
section .text
section .data
__g_semantic_KW_I8: dq 134
section .text
section .data
__g_semantic_KW_I16: dq 135
section .text
section .data
__g_semantic_KW_I32: dq 136
section .text
section .data
__g_semantic_KW_I64: dq 137
section .text
section .data
__g_semantic_KW_F32: dq 138
section .text
section .data
__g_semantic_KW_F64: dq 139
section .text
section .data
__g_semantic_KW_BOOL: dq 140
section .text
section .data
__g_semantic_KW_STR: dq 141
section .text
section .data
__g_semantic_KW_VOID: dq 142
section .text
section .data
__g_semantic_KW_BOOT_SEQUENCE: dq 200
section .text
section .data
__g_semantic_KW_MMU_CONFIGURATION: dq 201
section .text
section .data
__g_semantic_KW_SCHEDULER_DOMAIN: dq 202
section .text
section .data
__g_semantic_KW_SYSCALL_DISPATCH: dq 203
section .text
section .data
__g_semantic_KW_FILESYSTEM_VOLUME: dq 204
section .text
section .data
__g_semantic_KW_NETWORK_KERNEL: dq 205
section .text
section .data
__g_semantic_KW_HARDWARE_DRIVER: dq 206
section .text
section .data
__g_semantic_KW_INTERRUPT_SERVICE: dq 207
section .text
section .data
__g_semantic_KW_DMA_CHANNEL: dq 208
section .text
section .data
__g_semantic_KW_SECURITY_RING: dq 209
section .text
section .data
__g_semantic_KW_KRON3D_CONTEXT: dq 301
section .text
section .data
__g_semantic_KW_KRON_ISA: dq 500
section .text
section .data
__g_semantic_KW_EXECUTION_MODEL: dq 502
section .text
section .data
__g_semantic_KW_KERNEL_ARCHITECTURE: dq 503
section .text
section .data
__g_semantic_KW_SECURITY_MODEL: dq 504
section .text
section .data
__g_semantic_KW_KRON_HYPERVISOR: dq 505
section .text
section .data
__g_semantic_KW_DEPLOYMENT_MODEL: dq 506
section .text
section .data
__g_semantic_KW_HUMAN_MACHINE: dq 507
section .text
section .data
__g_semantic_KW_POWER_MANAGER: dq 508
section .text
section .data
__g_semantic_KW_PACKAGE_MANAGER: dq 509
section .text
section .data
__g_semantic_KW_GLOBAL_VISIBLE: dq 510
section .text
section .data
__g_semantic_KW_DOMAIN_ISOLATED: dq 511
section .text
section .data
__g_semantic_KW_INTER_CLUSTER_EXPORT: dq 513
section .text
section .data
__g_semantic_KW_OUTB: dq 520
section .text
section .data
__g_semantic_KW_INB: dq 521
section .text
section .data
__g_semantic_KW_POKE: dq 522
section .text
section .data
__g_semantic_KW_PEEK: dq 523
section .text
section .data
__g_semantic_KW_ASM: dq 524
section .text
section .data
__g_semantic_KW_POKE8: dq 525
section .text
section .data
__g_semantic_KW_POKE16: dq 526
section .text
section .data
__g_semantic_KW_POKE32: dq 527
section .text
section .data
__g_semantic_KW_PEEK8: dq 528
section .text
section .data
__g_semantic_KW_PEEK16: dq 529
section .text
section .data
__g_semantic_KW_PEEK32: dq 530
section .text
section .data
__g_semantic_KW_EXECUTABLE_LOADER: dq 531
section .text
section .data
__g_semantic_KW_PTR: dq 532
section .text
section .data
__g_semantic_KW_CALL: dq 533
section .text
section .data
__g_semantic_KW_TRUNC: dq 534
section .text
section .data
__g_semantic_KW_SAVEFILE: dq 535
section .text
section .data
__g_semantic_KW_READKEY: dq 536
section .text
section .data
__g_semantic_KW_BEEP: dq 537
section .text
section .data
__g_semantic_KW_READMOUSE: dq 538
section .text
section .data
__g_semantic_KW_MOUSEX: dq 539
section .text
section .data
__g_semantic_KW_MOUSEY: dq 540
section .text
section .data
__g_semantic_KW_ARENA_TOKEN: dq 541
section .text
section .data
__g_semantic_KW_ROTL: dq 542
section .text
section .data
__g_semantic_KW_ROTR: dq 543
section .text
section .data
__g_semantic_KW_INVCACHE: dq 544
section .text
section .data
__g_semantic_KW_PREFETCH0: dq 545
section .text
section .data
__g_semantic_KW_KRON_PROGRAM: dq 546
section .text
section .data
__g_semantic_KW_KRON_IMPORTS: dq 547
section .text
section .data
__g_semantic_KW_KRON_DEFINITIONS: dq 548
section .text
section .data
__g_semantic_KW_KRON_DOMAIN: dq 549
section .text
section .data
__g_semantic_KW_EPOCH: dq 550
section .text
section .data
__g_semantic_KW_ALIASED: dq 551
section .text
section .data
__g_semantic_KW_SWITCH: dq 552
section .text
section .data
__g_semantic_KW_CASE: dq 553
section .text
section .data
__g_semantic_KW_DEFAULT: dq 554
section .text
section .data
__g_semantic_KW_AS: dq 555
section .text
section .data
__g_semantic_KW_FAIL: dq 556
section .text
section .data
__g_semantic_KW_HINT: dq 557
section .text
section .data
__g_semantic_KW_FAILED: dq 558
section .text
section .data
__g_semantic_KW_PRINTFAIL: dq 559
section .text
section .data
__g_semantic_KW_SIZEOF: dq 560
section .text
section .data
__g_semantic_KW_VEC2_LOAD: dq 561
section .text
section .data
__g_semantic_KW_VEC2_STORE: dq 562
section .text
section .data
__g_semantic_KW_VEC2_ADD: dq 563
section .text
section .data
__g_semantic_KW_VEC2_SUB: dq 564
section .text
section .data
__g_semantic_KW_VEC2_MUL: dq 565
section .text
section .data
__g_semantic_KW_LOADFILE: dq 566
section .text
section .data
__g_semantic_KW_THREAD_START: dq 567
section .text
section .data
__g_semantic_KW_THREAD_WAIT: dq 568
section .text
section .data
__g_semantic_KW_LOCK_INIT: dq 569
section .text
section .data
__g_semantic_KW_LOCK_TAKE: dq 570
section .text
section .data
__g_semantic_KW_LOCK_GIVE: dq 571
section .text
section .data
__g_semantic_KW_CPU_COUNT: dq 572
section .text
section .data
__g_semantic_KW_TICKS: dq 573
section .text
section .data
__g_semantic_KW_TICKS_PER_SEC: dq 574
section .text
section .data
__g_semantic_KW_RAW: dq 575
section .text
section .data
__g_semantic_KW_SLICE: dq 576
section .text
section .data
__g_semantic_KW_THREAD_YIELD: dq 577
section .text
section .data
__g_semantic_KW_SHARED: dq 578
section .text
section .data
__g_semantic_KW_DLL_LOAD: dq 579
section .text
section .data
__g_semantic_KW_DLL_PROC: dq 580
section .text
section .data
__g_semantic_KW_ARG_COUNT: dq 581
section .text
section .data
__g_semantic_KW_ARG_GET: dq 582
section .text
section .data
__g_semantic_KW_TARGET_OS: dq 583
section .text
section .data
__g_semantic_KW_EXTERN: dq 584
section .text
section .data
__g_semantic_AST_NODE_SIZE: dq 56
section .text
section .data
__g_semantic_VIS_DEFAULT: dq 0
section .text
section .data
__g_semantic_VIS_EXPORTED: dq 1
section .text
section .data
__g_semantic_AST_PROGRAM: dq 1000
section .text
section .data
__g_semantic_AST_FUNCTION: dq 1001
section .text
section .data
__g_semantic_AST_BLOCK: dq 1002
section .text
section .data
__g_semantic_AST_VAR_DECL: dq 1003
section .text
section .data
__g_semantic_AST_CONST_DECL: dq 1004
section .text
section .data
__g_semantic_AST_ASSIGN: dq 1005
section .text
section .data
__g_semantic_AST_BINOP: dq 1006
section .text
section .data
__g_semantic_AST_UNOP: dq 1007
section .text
section .data
__g_semantic_AST_CALL: dq 1008
section .text
section .data
__g_semantic_AST_RETURN: dq 1009
section .text
section .data
__g_semantic_AST_IF: dq 1010
section .text
section .data
__g_semantic_AST_WHILE: dq 1011
section .text
section .data
__g_semantic_AST_LOOP_IN: dq 1012
section .text
section .data
__g_semantic_AST_BREAK: dq 1013
section .text
section .data
__g_semantic_AST_CONTINUE: dq 1014
section .text
section .data
__g_semantic_AST_IDENTIFIER: dq 1015
section .text
section .data
__g_semantic_AST_INTEGER_LIT: dq 1016
section .text
section .data
__g_semantic_AST_FLOAT_LIT: dq 1017
section .text
section .data
__g_semantic_AST_STRING_LIT: dq 1018
section .text
section .data
__g_semantic_AST_BOOL_LIT: dq 1019
section .text
section .data
__g_semantic_AST_STRUCT_DEF: dq 1020
section .text
section .data
__g_semantic_AST_ENUM_DEF: dq 1021
section .text
section .data
__g_semantic_AST_IMPORT: dq 1022
section .text
section .data
__g_semantic_AST_MODULE: dq 1023
section .text
section .data
__g_semantic_AST_HARDWARE_BLOCK: dq 1024
section .text
section .data
__g_semantic_AST_PRINT: dq 1025
section .text
section .data
__g_semantic_AST_PRINTC: dq 1061
section .text
section .data
__g_semantic_AST_ISA_DEF: dq 1030
section .text
section .data
__g_semantic_AST_ISA_ENTRY: dq 1031
section .text
section .data
__g_semantic_AST_BOOT_DEF: dq 1032
section .text
section .data
__g_semantic_AST_BOOT_REG: dq 1033
section .text
section .data
__g_semantic_AST_MMU_DEF: dq 1034
section .text
section .data
__g_semantic_AST_MMU_LEVEL: dq 1035
section .text
section .data
__g_semantic_AST_ISR_DEF: dq 1036
section .text
section .data
__g_semantic_AST_CFG_DEF: dq 1037
section .text
section .data
__g_semantic_AST_CFG_ENTRY: dq 1038
section .text
section .data
__g_semantic_AST_SCHED_DEF: dq 1039
section .text
section .data
__g_semantic_AST_SYS_DEF: dq 1040
section .text
section .data
__g_semantic_AST_SYS_ENTRY: dq 1041
section .text
section .data
__g_semantic_AST_OUTB: dq 1042
section .text
section .data
__g_semantic_AST_INB: dq 1043
section .text
section .data
__g_semantic_AST_POKE: dq 1044
section .text
section .data
__g_semantic_AST_PEEK: dq 1045
section .text
section .data
__g_semantic_AST_TRUNC: dq 1062
section .text
section .data
__g_semantic_AST_SAVEFILE: dq 1063
section .text
section .data
__g_semantic_AST_READKEY: dq 1064
section .text
section .data
__g_semantic_AST_BEEP: dq 1065
section .text
section .data
__g_semantic_AST_READMOUSE: dq 1066
section .text
section .data
__g_semantic_AST_MOUSEX: dq 1067
section .text
section .data
__g_semantic_AST_MOUSEY: dq 1068
section .text
section .data
__g_semantic_AST_ASM: dq 1046
section .text
section .data
__g_semantic_AST_INDEX: dq 1047
section .text
section .data
__g_semantic_AST_ADDR_OF: dq 1048
section .text
section .data
__g_semantic_AST_DEREF: dq 1049
section .text
section .data
__g_semantic_AST_POKE8: dq 1050
section .text
section .data
__g_semantic_AST_POKE16: dq 1051
section .text
section .data
__g_semantic_AST_POKE32: dq 1052
section .text
section .data
__g_semantic_AST_PEEK8: dq 1053
section .text
section .data
__g_semantic_AST_PEEK16: dq 1054
section .text
section .data
__g_semantic_AST_PEEK32: dq 1055
section .text
section .data
__g_semantic_AST_PARAM: dq 1056
section .text
section .data
__g_semantic_AST_ARG: dq 1057
section .text
section .data
__g_semantic_AST_FIELD: dq 1058
section .text
section .data
__g_semantic_AST_MEMBER: dq 1059
section .text
section .data
__g_semantic_AST_CALL_INDIRECT: dq 1060
section .text
section .data
__g_semantic_AST_ARENA_ENTRY: dq 1069
section .text
section .data
__g_semantic_ARENA_GROWTH_FIXED: dq 0
section .text
section .data
__g_semantic_ARENA_GROWTH_DOUBLING: dq 1
section .text
section .data
__g_semantic_ARENA_GROWTH_LINEAR: dq 2
section .text
section .data
__g_semantic_ARENA_GROWTH_LAZY: dq 3
section .text
section .data
__g_semantic_AST_MMU_ENTRY: dq 1070
section .text
section .data
__g_semantic_MMU_ENTRY_CACHE: dq 0
section .text
section .data
__g_semantic_MMU_ENTRY_NUMA: dq 1
section .text
section .data
__g_semantic_MMU_ENTRY_GC: dq 2
section .text
section .data
__g_semantic_MMU_ENTRY_PGFAULT: dq 3
section .text
section .data
__g_semantic_MMU_ENTRY_OOM: dq 4
section .text
section .data
__g_semantic_MMU_ENTRY_POOL: dq 5
section .text
section .data
__g_semantic_AST_POOL_DIR: dq 1071
section .text
section .data
__g_semantic_POOL_DIR_CLASS: dq 0
section .text
section .data
__g_semantic_POOL_DIR_COMPACT: dq 1
section .text
section .data
__g_semantic_POOL_DIR_GRAN: dq 2
section .text
section .data
__g_semantic_POOL_DIR_ONALLOC: dq 3
section .text
section .data
__g_semantic_POOL_DIR_ONFREE: dq 4
section .text
section .data
__g_semantic_ALLOC_BUDDY: dq 0
section .text
section .data
__g_semantic_ALLOC_SLAB: dq 1
section .text
section .data
__g_semantic_ALLOC_BUMP: dq 2
section .text
section .data
__g_semantic_ALLOC_FREELIST: dq 3
section .text
section .data
__g_semantic_ALLOC_PREDICTIVE: dq 4
section .text
section .data
__g_semantic_AST_BOOT_ENTRY: dq 1072
section .text
section .data
__g_semantic_AST_CAST: dq 1073
section .text
section .data
__g_semantic_AST_STRUCT_LIT: dq 1074
section .text
section .data
__g_semantic_AST_FINIT: dq 1075
section .text
section .data
__g_semantic_AST_FAIL: dq 1076
section .text
section .data
__g_semantic_AST_FAILED: dq 1077
section .text
section .data
__g_semantic_AST_PRINTFAIL: dq 1078
section .text
section .data
__g_semantic_AST_SIZEOF: dq 1079
section .text
section .data
__g_semantic_AST_ARRAY_LIT: dq 1080
section .text
section .data
__g_semantic_AST_VEC2_LOAD: dq 1081
section .text
section .data
__g_semantic_AST_VEC2_STORE: dq 1082
section .text
section .data
__g_semantic_AST_VEC2_ADD: dq 1083
section .text
section .data
__g_semantic_AST_VEC2_SUB: dq 1084
section .text
section .data
__g_semantic_AST_VEC2_MUL: dq 1085
section .text
section .data
__g_semantic_AST_LOADFILE: dq 1086
section .text
section .data
__g_semantic_AST_THREAD_START: dq 1087
section .text
section .data
__g_semantic_AST_THREAD_WAIT: dq 1088
section .text
section .data
__g_semantic_AST_LOCK_INIT: dq 1089
section .text
section .data
__g_semantic_AST_LOCK_TAKE: dq 1090
section .text
section .data
__g_semantic_AST_LOCK_GIVE: dq 1091
section .text
section .data
__g_semantic_AST_CPU_COUNT: dq 1092
section .text
section .data
__g_semantic_AST_TICKS: dq 1093
section .text
section .data
__g_semantic_AST_TICKS_PER_SEC: dq 1094
section .text
section .data
__g_semantic_AST_THREAD_YIELD: dq 1095
section .text
section .data
__g_semantic_AST_DLL_LOAD: dq 1096
section .text
section .data
__g_semantic_AST_DLL_PROC: dq 1097
section .text
section .data
__g_semantic_AST_ARG_COUNT: dq 1098
section .text
section .data
__g_semantic_AST_ARG_GET: dq 1099
section .text
section .data
__g_semantic_AST_TARGET_OS: dq 1100
section .text
section .data
__g_semantic_AST_LAMBDA: dq 1102
section .text
section .data
__g_semantic_AST_EXTERN: dq 1103
section .text
section .data
__g_semantic_AST_MULTI: dq 1101
section .text
section .data
__g_semantic_BLOCK_SPLICE: dq 0x53504C
section .text
section .data
__g_semantic_PGFLAG_RW_KERNEL: dq 0
section .text
section .data
__g_semantic_PGFLAG_RO_USER: dq 1
section .text
section .data
__g_semantic_PGFLAG_EXEC_DIS: dq 2
section .text
section .data
__g_semantic_PGFLAG_CACHE_BYPASS: dq 3
section .text
section .data
__g_semantic_CACHE_WRITE_BACK: dq 0
section .text
section .data
__g_semantic_CACHE_WRITE_THROUGH: dq 1
section .text
section .data
__g_semantic_GC_MANUAL_ONLY: dq 0
section .text
section .data
__g_semantic_GC_REF_COUNTED: dq 1
section .text
section .data
__g_semantic_GC_MARK_SWEEP: dq 2
section .text
section .data
__g_semantic_GC_GENERATIONAL: dq 3
section .text
section .data
__g_semantic_CFG_HANDLER_MARK: dq 0xFFFF
section .text
section .data
__g_semantic_BLOCK_RAW: dq 0x524157
section .text
section .data
__g_semantic_SLICE_GET_MARK: dq 0x534C4943
section .text
section .data
__g_semantic_AST_SYSCALL: dq 29
section .text
section .data
__g_semantic_SEM_SYM_SIZE: dq 64
section .text
section .data
__g_semantic_SEM_BUCKETS: dq 4096
section .text
section .data
__g_semantic_SEM_MAX_DEPTH: dq 256
section .text
section .data
__g_semantic_SEM_SCOPE_GLOBAL: dq 0
section .text
section .data
__g_semantic_SEM_SCOPE_FUNCTION: dq 1
section .text
section .data
__g_semantic_SEM_SCOPE_BLOCK: dq 2
section .text
section .data
__g_semantic_SEM_SCOPE_HARDWARE: dq 3
section .text
section .data
__g_semantic_SEM_F_CONST: dq 1
section .text
section .data
__g_semantic_SEM_F_FUNCTION: dq 2
section .text
section .data
__g_semantic_SEM_F_DEFINED: dq 16
section .text
section .data
__g_semantic_SEM_T_I64: dq 9
section .text
section .data
__g_semantic_SEM_T_F64: dq 11
section .text
section .data
__g_semantic_SEM_T_STRUCT: dq 13
section .text
section .data
__g_semantic_SEM_T_FN: dq 15
section .text
section .data
__g_semantic_SEM_T_PTR: dq 16
section .text
section .bss
__g_semantic_sem_table: resq 4096
section .text
section .data
__g_semantic_sem_arena: dq 0
section .text
section .data
__g_semantic_sem_arena_ptr: dq 0
section .text
section .data
__g_semantic_sem_arena_end: dq 0
section .text
section .bss
__g_semantic_sem_scopes: resq 1024
section .text
section .data
__g_semantic_sem_depth: dq 0
section .text
section .data
__g_semantic_sem_scope_ids: dq 0
section .text
section .data
__g_semantic_sem_had_error: dq 0
section .text
section .data
__g_semantic_sem_error_line: dq 0
section .text
section .data
__g_semantic_sem_error_tok: dq 0
section .text
section .data
__g_semantic_sem_error_kind: dq 0
section .text
section .data
__g_semantic_sem_raw_depth: dq 0
section .text
section .data
__g_semantic_sem_sug_len: dq 0
section .text
sem_tget:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    mov rax, [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_0
.__ret_0:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_tset:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rbx, r8
    mov rax, r12
    mov rcx, 8
    imul rax, rcx
    mov rcx, rax
    mov rax, r13
    add rax, rcx
    push rax
    mov rax, rbx
    mov rcx, rax
    pop rdx
    mov [rdx], rcx
    mov rax, 0
    jmp .__ret_1
.__ret_1:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_bget:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, r12
    movzx rax, byte [rax]
    mov rbx, rax
    mov rax, rbx
    jmp .__ret_2
.__ret_2:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
sem_memeq:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov r12, r8
    mov rax, 0
    mov rbx, rax
.L4:
    cmp rbx, r12
    jge .L5
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    push rax
    mov rax, r13
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L7
    mov rax, 0
    jmp .__ret_3
    jmp .L8
.L7:
.L8:
    add rbx, 1
.L6:
    jmp .L4
.L5:
    mov rax, 1
    jmp .__ret_3
.__ret_3:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
sem_ult:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 1
    mov rbx, rax
    mov rax, rbx
    shl rax, 63
    mov rbx, rax
    mov rax, r13
    xor rax, rbx
    push rax
    mov rax, r12
    xor rax, rbx
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L10
    mov rax, 1
    jmp .__ret_9
    jmp .L11
.L10:
.L11:
    mov rax, 0
    jmp .__ret_9
.__ret_9:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_bucket:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-40], r14
    mov r14, rcx
    mov r13, rdx
    mov rax, 0x325
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L13:
    cmp rbx, r13
    jge .L14
    mov rax, r12
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, rax
    pop rax
    xor rax, rcx
    mov rcx, 0x1B3
    imul rax, rcx
    and rax, 0xFFF
    mov r12, rax
    add rbx, 1
.L15:
    jmp .L13
.L14:
    mov rax, r12
    jmp .__ret_12
.__ret_12:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov r14, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
sem_push_scope:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_semantic_sem_depth]
    push rax
    mov rax, [rel __g_semantic_SEM_MAX_DEPTH]
    sub rax, 1
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jl .L17
    mov rax, 1
    neg rax
    jmp .__ret_16
    jmp .L18
.L17:
.L18:
    mov rax, [rel __g_semantic_sem_scope_ids]
    add rax, 1
    mov [rel __g_semantic_sem_scope_ids], rax
    lea rax, [rel __g_semantic_sem_scopes]
    push rax
    mov rax, [rel __g_semantic_sem_depth]
    mov rcx, 32
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, 0
    push rax
    mov rax, [rel __g_semantic_sem_scope_ids]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_tset
    add rsp, 32
    mov rcx, rbx
    mov rdx, 1
    mov r8, r12
    sub rsp, 32
    call sem_tset
    add rsp, 32
    mov rcx, rbx
    mov rdx, 2
    mov r8, 0
    sub rsp, 32
    call sem_tset
    add rsp, 32
    mov rax, rbx
    push rax
    mov rax, 3
    push rax
    mov rax, [rel __g_semantic_sem_depth]
    sub rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_tset
    add rsp, 32
    mov rax, [rel __g_semantic_sem_depth]
    add rax, 1
    mov [rel __g_semantic_sem_depth], rax
    mov rax, 0
    jmp .__ret_16
.__ret_16:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
sem_pop_scope:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_semantic_sem_depth]
    cmp rax, 0
    jne .L20
    mov rax, 1
    neg rax
    jmp .__ret_19
    jmp .L21
.L20:
.L21:
    mov rax, [rel __g_semantic_sem_depth]
    sub rax, 1
    mov [rel __g_semantic_sem_depth], rax
    mov rax, 0
    jmp .__ret_19
.__ret_19:
    mov rsp, rbp
    pop rbp
    ret
sem_insert:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-96], r15
    mov r15, rcx
    mov r14, rdx
    mov [rbp-24], r8
    mov r13, r9
    mov r12, r10
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rel __g_semantic_sem_arena_ptr]
    push rax
    mov rax, [rel __g_semantic_SEM_SYM_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    push rax
    mov rax, [rel __g_semantic_sem_arena_end]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jle .L23
    mov rax, 0
    jmp .__ret_22
    jmp .L24
.L23:
.L24:
    mov rax, [rel __g_semantic_sem_arena_ptr]
    mov [rbp-48], rax
    mov rax, 0
    mov rbx, rax
.L25:
    cmp rbx, 8
    jge .L26
    mov rax, [rel __g_semantic_sem_arena_ptr]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call sem_tset
    add rsp, 32
    add rbx, 1
.L27:
    jmp .L25
.L26:
    mov rax, [rel __g_semantic_sem_arena_ptr]
    push rax
    mov rax, [rel __g_semantic_SEM_SYM_SIZE]
    mov rcx, rax
    pop rax
    add rax, rcx
    mov [rel __g_semantic_sem_arena_ptr], rax
    mov rax, r15
    mov rdx, [rbp-48]
    mov [rdx], rax
    mov rax, r14
    mov rdx, [rbp-48]
    add rdx, 8
    mov [rdx], eax
    mov rax, [rbp-24]
    mov rdx, [rbp-48]
    add rdx, 12
    mov [rdx], eax
    mov rax, r13
    push rax
    mov rax, [rel __g_semantic_SEM_F_DEFINED]
    mov rcx, rax
    pop rax
    or rax, rcx
    mov rdx, [rbp-48]
    add rdx, 20
    mov [rdx], eax
    mov rax, r12
    mov rdx, [rbp-48]
    add rdx, 24
    mov [rdx], rax
    mov rax, [rel __g_semantic_sem_depth]
    cmp rax, 0
    jle .L28
    lea rax, [rel __g_semantic_sem_scopes]
    push rax
    mov rax, [rel __g_semantic_sem_depth]
    sub rax, 1
    mov rcx, 32
    imul rax, rcx
    mov rcx, rax
    pop rax
    add rax, rcx
    mov rbx, rax
    mov rcx, rbx
    mov rdx, 0
    sub rsp, 32
    call sem_tget
    add rsp, 32
    mov rdx, [rbp-48]
    add rdx, 16
    mov [rdx], eax
    mov rax, rbx
    push rax
    mov rax, 2
    push rax
    mov rcx, rbx
    mov rdx, 2
    sub rsp, 32
    call sem_tget
    add rsp, 32
    add rax, 1
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_tset
    add rsp, 32
    jmp .L29
.L28:
.L29:
    mov rcx, r15
    mov rdx, r14
    sub rsp, 32
    call sem_bucket
    add rsp, 32
    mov rbx, rax
    lea rax, [rel __g_semantic_sem_table]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call sem_tget
    add rsp, 32
    mov rdx, [rbp-48]
    add rdx, 32
    mov [rdx], rax
    lea rax, [rel __g_semantic_sem_table]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, [rbp-48]
    sub rsp, 32
    call sem_tset
    add rsp, 32
    mov rax, [rbp-48]
    jmp .__ret_22
.__ret_22:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov r15, [rbp-96]
    mov rsp, rbp
    pop rbp
    ret
sem_lookup:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-40], r12
    mov r12, rcx
    mov rbx, rdx
    lea rax, [rel __g_semantic_sem_table]
    push rax
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call sem_bucket
    add rsp, 32
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_tget
    add rsp, 32
    mov [rbp-24], rax
.L31:
    mov rax, [rbp-24]
    cmp rax, 0
    je .L32
    mov rdx, [rbp-24]
    add rdx, 8
    mov eax, dword [rdx]
    cmp rax, rbx
    jne .L34
    mov rdx, [rbp-24]
    mov rax, [rdx]
    push rax
    pop rcx
    mov rdx, r12
    mov r8, rbx
    sub rsp, 32
    call sem_memeq
    add rsp, 32
    cmp rax, 1
    jne .L36
    mov rax, [rbp-24]
    jmp .__ret_30
    jmp .L37
.L36:
.L37:
    jmp .L35
.L34:
.L35:
    mov rdx, [rbp-24]
    add rdx, 32
    mov rax, [rdx]
    mov [rbp-24], rax
.L33:
    jmp .L31
.L32:
    mov rax, 0
    jmp .__ret_30
.__ret_30:
    mov rbx, [rbp-48]
    mov r12, [rbp-40]
    mov rsp, rbp
    pop rbp
    ret
sem_lookup_tok:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_lookup
    add rsp, 32
    jmp .__ret_38
.__ret_38:
    mov rsp, rbp
    pop rbp
    ret
sem_insert_tok:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov [rbp-8], rcx
    mov r13, rdx
    mov r12, r8
    mov rbx, r9
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop rdx
    pop rcx
    mov r8, r13
    mov r9, r12
    mov r10, rbx
    sub rsp, 32
    call sem_insert
    add rsp, 32
    jmp .__ret_39
.__ret_39:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_node_type:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L41
    mov rax, [rel __g_semantic_SEM_T_I64]
    jmp .__ret_40
    jmp .L42
.L41:
.L42:
    mov rdx, [rbp-8]
    add rdx, 38
    movzx eax, word [rdx]
    and rax, 1
    cmp rax, 0
    je .L43
    mov rax, [rel __g_semantic_SEM_T_F64]
    jmp .__ret_40
    jmp .L44
.L43:
.L44:
    mov rdx, [rbp-8]
    add rdx, 32
    mov eax, dword [rdx]
    cmp rax, 0
    je .L45
    mov rax, [rel __g_semantic_SEM_T_PTR]
    jmp .__ret_40
    jmp .L46
.L45:
.L46:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    cmp rax, 0
    je .L47
    mov rax, [rel __g_semantic_SEM_T_STRUCT]
    jmp .__ret_40
    jmp .L48
.L47:
.L48:
    mov rax, [rel __g_semantic_SEM_T_I64]
    jmp .__ret_40
.__ret_40:
    mov rsp, rbp
    pop rbp
    ret
sem_arr_value:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-8], rcx
    mov rdx, [rbp-8]
    add rdx, 40
    mov rax, [rdx]
    mov rbx, rax
    cmp rbx, 0
    jne .L50
    mov rax, 0
    jmp .__ret_49
    jmp .L51
.L50:
.L51:
    mov rax, rbx
    push rax
    mov rdx, [rbp-8]
    add rdx, 38
    movzx eax, word [rdx]
    shr rax, 4
    and rax, 15
    shl rax, 56
    mov rcx, rax
    pop rax
    or rax, rcx
    jmp .__ret_49
.__ret_49:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
sem_token_number:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov [rbp-56], r14
    mov [rbp-8], rcx
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L53
    mov rax, 0
    jmp .__ret_52
    jmp .L54
.L53:
.L54:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    mov r13, rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    mov r12, rax
    cmp r12, 0
    jne .L55
    mov rax, 0
    jmp .__ret_52
    jmp .L56
.L55:
.L56:
    mov rax, r12
    mov rcx, 2
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jz .L61
    mov rcx, r13
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, 48
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L61
    mov rax, 1
    jmp .L62
.L61:
    mov rax, 0
.L62:
    test rax, rax
    jz .L59
    mov rax, r13
    add rax, 1
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    or rax, 32
    mov rcx, 120
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L59
    mov rax, 1
    jmp .L60
.L59:
    mov rax, 0
.L60:
    test rax, rax
    jz .L57
    add r13, 2
    sub r12, 2
.L63:
    cmp r12, 0
    jle .L64
    mov rcx, r13
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rbx, rax
    cmp rbx, 48
    jge .L66
    mov rax, r14
    jmp .__ret_52
    jmp .L67
.L66:
.L67:
    cmp rbx, 57
    jg .L68
    sub rbx, 48
    jmp .L69
.L68:
    or rbx, 32
    mov rax, rbx
    mov rcx, 97
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L72
    mov rax, rbx
    mov rcx, 102
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L72
    mov rax, 0
    jmp .L73
.L72:
    mov rax, 1
.L73:
    test rax, rax
    jz .L70
    mov rax, r14
    jmp .__ret_52
    jmp .L71
.L70:
.L71:
    sub rbx, 87
.L69:
    mov rax, r14
    shl rax, 4
    add rax, rbx
    mov r14, rax
    add r13, 1
    sub r12, 1
.L65:
    jmp .L63
.L64:
    mov rax, r14
    jmp .__ret_52
    jmp .L58
.L57:
.L58:
.L74:
    cmp r12, 0
    jle .L75
    mov rcx, r13
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rbx, rax
    mov rax, rbx
    mov rcx, 48
    cmp rax, rcx
    setl al
    movzx rax, al
    test rax, rax
    jnz .L79
    mov rax, rbx
    mov rcx, 57
    cmp rax, rcx
    setg al
    movzx rax, al
    test rax, rax
    jnz .L79
    mov rax, 0
    jmp .L80
.L79:
    mov rax, 1
.L80:
    test rax, rax
    jz .L77
    mov rax, r14
    jmp .__ret_52
    jmp .L78
.L77:
.L78:
    mov rax, r14
    mov rcx, 10
    imul rax, rcx
    push rax
    mov rax, rbx
    sub rax, 48
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    add r13, 1
    sub r12, 1
.L76:
    jmp .L74
.L75:
    mov rax, r14
    jmp .__ret_52
.__ret_52:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov r14, [rbp-56]
    mov rsp, rbp
    pop rbp
    ret
sem_one_edit:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    mov [rbp-144], rbx
    mov [rbp-136], r12
    mov [rbp-128], r13
    mov [rbp-120], r14
    mov [rbp-112], r15
    mov r15, rcx
    mov [rbp-16], rdx
    mov r14, r8
    mov [rbp-32], r9
    mov rax, [rbp-16]
    mov rcx, [rbp-32]
    sub rax, rcx
    mov [rbp-40], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov r12, rax
    mov rax, 1
    neg rax
    mov rbx, rax
    mov rax, 0
    mov [rbp-80], rax
    mov rax, 0
    mov [rbp-88], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jge .L82
    mov rax, 0
    mov rcx, [rbp-40]
    sub rax, rcx
    mov [rbp-40], rax
    jmp .L83
.L82:
.L83:
    mov rax, [rbp-40]
    cmp rax, 1
    jle .L84
    mov rax, 0
    jmp .__ret_81
    jmp .L85
.L84:
.L85:
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L86
.L88:
    mov rax, r13
    mov rcx, [rbp-16]
    cmp rax, rcx
    jge .L89
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    push rax
    mov rax, r14
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L91
    add r12, 1
    mov rax, rbx
    push rax
    mov rax, 1
    neg rax
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L93
    mov rax, r13
    mov rbx, rax
    jmp .L94
.L93:
    mov rax, r13
    mov [rbp-80], rax
.L94:
    jmp .L92
.L91:
.L92:
    add r13, 1
    cmp r12, 3
    jl .L95
    jmp .L89
    jmp .L96
.L95:
.L96:
.L90:
    jmp .L88
.L89:
    cmp r12, 1
    jne .L97
    mov rax, 1
    jmp .__ret_81
    jmp .L98
.L97:
.L98:
    cmp r12, 2
    je .L99
    mov rax, 0
    jmp .__ret_81
    jmp .L100
.L99:
.L100:
    mov rax, [rbp-80]
    sub rax, rbx
    cmp rax, 1
    je .L101
    mov rax, 0
    jmp .__ret_81
    jmp .L102
.L101:
.L102:
    mov rax, r15
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    push rax
    mov rax, r14
    mov rcx, [rbp-80]
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L103
    mov rax, 0
    jmp .__ret_81
    jmp .L104
.L103:
.L104:
    mov rax, r15
    mov rcx, [rbp-80]
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    push rax
    mov rax, r14
    add rax, rbx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L105
    mov rax, 0
    jmp .__ret_81
    jmp .L106
.L105:
.L106:
    mov rax, 1
    jmp .__ret_81
    jmp .L87
.L86:
.L87:
    mov rax, [rbp-16]
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L107
    mov rax, r15
    mov [rbp-88], rax
    mov rax, r14
    mov r15, rax
    mov rax, [rbp-88]
    mov r14, rax
    mov rax, [rbp-16]
    mov [rbp-88], rax
    mov rax, [rbp-32]
    mov [rbp-16], rax
    mov rax, [rbp-88]
    mov [rbp-32], rax
    jmp .L108
.L107:
.L108:
.L109:
    mov rax, [rbp-56]
    mov rcx, [rbp-32]
    cmp rax, rcx
    jge .L110
    mov rax, r15
    add rax, r13
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    push rax
    mov rax, r14
    mov rcx, [rbp-56]
    add rax, rcx
    push rax
    pop rcx
    sub rsp, 32
    call sem_bget
    add rsp, 32
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L112
    add r13, 1
    mov rax, [rbp-56]
    add rax, 1
    mov [rbp-56], rax
    jmp .L113
.L112:
    add r12, 1
    cmp r12, 1
    jle .L114
    mov rax, 0
    jmp .__ret_81
    jmp .L115
.L114:
.L115:
    add r13, 1
.L113:
.L111:
    jmp .L109
.L110:
    mov rax, 1
    jmp .__ret_81
.__ret_81:
    mov rbx, [rbp-144]
    mov r12, [rbp-136]
    mov r13, [rbp-128]
    mov r14, [rbp-120]
    mov r15, [rbp-112]
    mov rsp, rbp
    pop rbp
    ret
sem_suggest:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rel __g_semantic_sem_sug_len], rax
.L117:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_SEM_BUCKETS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L118
    lea rax, [rel __g_semantic_sem_table]
    push rax
    pop rcx
    mov rdx, rbx
    sub rsp, 32
    call sem_tget
    add rsp, 32
    mov [rbp-32], rax
.L120:
    mov rax, [rbp-32]
    cmp rax, 0
    je .L121
    mov rax, r13
    push rax
    mov rax, r12
    push rax
    mov rdx, [rbp-32]
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-32]
    add rdx, 8
    mov eax, dword [rdx]
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_one_edit
    add rsp, 32
    cmp rax, 1
    jne .L123
    mov rdx, [rbp-32]
    add rdx, 8
    mov eax, dword [rdx]
    mov [rel __g_semantic_sem_sug_len], rax
    mov rdx, [rbp-32]
    mov rax, [rdx]
    jmp .__ret_116
    jmp .L124
.L123:
.L124:
    mov rdx, [rbp-32]
    add rdx, 32
    mov rax, [rdx]
    mov [rbp-32], rax
.L122:
    jmp .L120
.L121:
    add rbx, 1
.L119:
    jmp .L117
.L118:
    mov rax, 0
    jmp .__ret_116
.__ret_116:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_error_at:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-8], rcx
    mov rbx, rdx
    mov rax, [rbp-8]
    mov [rel __g_semantic_sem_error_tok], rax
    mov rdx, [rbp-8]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, rbx
    mov [rel __g_semantic_sem_error_kind], rax
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    mov rax, 0
    jmp .__ret_125
.__ret_125:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
sem_raw_check:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
    mov rax, [rel __g_semantic_sem_raw_depth]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L129
    mov rax, [rel __g_semantic_sem_had_error]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jnz .L129
    mov rax, 0
    jmp .L130
.L129:
    mov rax, 1
.L130:
    test rax, rax
    jz .L127
    mov rax, 0
    jmp .__ret_126
    jmp .L128
.L127:
.L128:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    jne .L131
    mov rax, 0
    jmp .__ret_126
    jmp .L132
.L131:
.L132:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    mov rdx, 7
    sub rsp, 32
    call sem_error_at
    add rsp, 32
    mov rax, 0
    jmp .__ret_126
.__ret_126:
    mov rsp, rbp
    pop rbp
    ret
sem_check_lvalue:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-48], rbx
    mov [rbp-8], rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L134
    mov rax, 0
    jmp .__ret_133
    jmp .L135
.L134:
.L135:
    mov rdx, [rbp-8]
    mov rax, [rdx]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L142
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_INDEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L142
    mov rax, 0
    jmp .L143
.L142:
    mov rax, 1
.L143:
    test rax, rax
    jnz .L140
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_MEMBER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L140
    mov rax, 0
    jmp .L141
.L140:
    mov rax, 1
.L141:
    test rax, rax
    jnz .L138
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_UNOP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L138
    mov rax, 0
    jmp .L139
.L138:
    mov rax, 1
.L139:
    test rax, rax
    jz .L136
    mov rax, 0
    jmp .__ret_133
    jmp .L137
.L136:
.L137:
    mov rax, 5
    mov [rel __g_semantic_sem_error_kind], rax
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    je .L144
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-24], rax
    mov rax, [rbp-24]
    mov [rel __g_semantic_sem_error_tok], rax
    mov rdx, [rbp-24]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    jmp .L145
.L144:
.L145:
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    mov rax, 0
    jmp .__ret_133
.__ret_133:
    mov rbx, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_args:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov [rbp-8], rcx
.L147:
    mov rax, [rbp-8]
    cmp rax, 0
    je .L148
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    cmp rax, 0
    je .L150
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .L151
.L150:
.L151:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-8], rax
.L149:
    jmp .L147
.L148:
    mov rax, 0
    jmp .__ret_146
.__ret_146:
    mov rsp, rbp
    pop rbp
    ret
sem_mmu:
    push rbp
    mov rbp, rsp
    sub rsp, 192
    mov [rbp-160], rbx
    mov [rbp-152], r12
    mov [rbp-144], r13
    mov [rbp-136], r14
    mov [rbp-128], r15
    mov [rbp-8], rcx
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov r15, rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
.L153:
    mov rax, [rbp-16]
    cmp rax, 0
    je .L154
    mov rdx, [rbp-16]
    add rdx, 40
    mov rax, [rdx]
    mov [rbp-32], rax
    mov rax, [rbp-32]
    cmp rax, 0
    je .L156
    mov rdx, [rbp-32]
    add rdx, 16
    mov eax, dword [rdx]
    cmp rax, 0
    je .L158
    mov rdx, [rbp-32]
    add rdx, 8
    mov rax, [rdx]
    mov r13, rax
    mov rdx, [rbp-32]
    add rdx, 16
    mov eax, dword [rdx]
    mov r12, rax
    mov rax, 1
    mov rbx, rax
.L160:
    cmp r12, 0
    jle .L161
    mov rcx, r13
    sub rsp, 32
    call sem_bget
    add rsp, 32
    cmp rax, 48
    je .L163
    mov rax, 0
    mov rbx, rax
    jmp .L161
    jmp .L164
.L163:
.L164:
    add r13, 1
    sub r12, 1
.L162:
    jmp .L160
.L161:
    cmp rbx, 1
    jne .L165
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-40], rax
    mov rdx, [rbp-40]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, 2
    mov [rel __g_semantic_sem_error_kind], rax
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    jmp .L166
.L165:
.L166:
    jmp .L159
.L158:
.L159:
    jmp .L157
.L156:
.L157:
    mov rdx, [rbp-16]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-24], rax
.L167:
    mov rax, [rbp-24]
    cmp rax, 0
    je .L168
    mov rax, 0
    mov rbx, rax
    mov rdx, [rbp-16]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_token_number
    add rsp, 32
    mov r15, rax
    mov rax, r15
    push rax
    mov rdx, [rbp-16]
    add rdx, 40
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_token_number
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r14, rax
    mov rcx, r14
    mov rdx, r15
    sub rsp, 32
    call sem_ult
    add rsp, 32
    cmp rax, 0
    jne .L170
    mov rdx, [rbp-24]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_token_number
    add rsp, 32
    mov r13, rax
    mov rax, r13
    push rax
    mov rdx, [rbp-24]
    add rdx, 40
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_token_number
    add rsp, 32
    mov rcx, rax
    pop rax
    add rax, rcx
    mov r12, rax
    mov rcx, r12
    mov rdx, r13
    sub rsp, 32
    call sem_ult
    add rsp, 32
    cmp rax, 0
    jne .L172
    mov rcx, r15
    mov rdx, r12
    sub rsp, 32
    call sem_ult
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L176
    mov rcx, r13
    mov rdx, r14
    sub rsp, 32
    call sem_ult
    add rsp, 32
    mov rcx, 1
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L176
    mov rax, 1
    jmp .L177
.L176:
    mov rax, 0
.L177:
    test rax, rax
    jz .L174
    mov rax, 1
    mov rbx, rax
    jmp .L175
.L174:
.L175:
    jmp .L173
.L172:
.L173:
    jmp .L171
.L170:
.L171:
    cmp rbx, 1
    jne .L178
    mov rdx, [rbp-24]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-48], rax
    mov rdx, [rbp-48]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, 3
    mov [rel __g_semantic_sem_error_kind], rax
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    jmp .L179
.L178:
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-40], rax
    mov rdx, [rbp-24]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-48], rax
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    mov rdx, [rbp-48]
    add rdx, 16
    mov eax, dword [rdx]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L180
    mov rdx, [rbp-40]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-48]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-40]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_memeq
    add rsp, 32
    cmp rax, 1
    jne .L182
    mov rdx, [rbp-48]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, 1
    mov [rel __g_semantic_sem_error_kind], rax
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    jmp .L183
.L182:
.L183:
    jmp .L181
.L180:
.L181:
.L179:
    mov rdx, [rbp-24]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-24], rax
.L169:
    jmp .L167
.L168:
    mov rdx, [rbp-16]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-16], rax
.L155:
    jmp .L153
.L154:
    mov rax, 0
    jmp .__ret_152
.__ret_152:
    mov rbx, [rbp-160]
    mov r12, [rbp-152]
    mov r13, [rbp-144]
    mov r14, [rbp-136]
    mov r15, [rbp-128]
    mov rsp, rbp
    pop rbp
    ret
sem_call:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov [rbp-128], rbx
    mov [rbp-120], r12
    mov [rbp-112], r13
    mov [rbp-104], r14
    mov [rbp-8], rcx
    mov rax, 0
    mov [rbp-16], rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, 0
    mov [rbp-48], rax
    mov rax, 0
    mov [rbp-56], rax
    mov rax, 0
    mov r14, rax
    mov rax, 0
    mov r13, rax
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    jne .L185
    mov rax, 0
    jmp .__ret_184
    jmp .L186
.L185:
.L186:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_lookup_tok
    add rsp, 32
    mov [rbp-16], rax
    mov rax, [rbp-16]
    cmp rax, 0
    je .L187
    mov rdx, [rbp-16]
    add rdx, 20
    mov eax, dword [rdx]
    push rax
    mov rax, [rel __g_semantic_SEM_F_FUNCTION]
    mov rcx, rax
    pop rax
    and rax, rcx
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L191
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L191
    mov rax, 1
    jmp .L192
.L191:
    mov rax, 0
.L192:
    test rax, rax
    jz .L189
    mov rdx, [rbp-16]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-24], rax
    mov rdx, [rbp-24]
    add rdx, 8
    mov rax, [rdx]
    mov [rbp-32], rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-40], rax
.L193:
    mov rax, [rbp-32]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L196
    mov rax, [rbp-40]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L196
    mov rax, 1
    jmp .L197
.L196:
    mov rax, 0
.L197:
    test rax, rax
    jz .L194
    mov rdx, [rbp-32]
    add rdx, 40
    mov rax, [rdx]
    mov r14, rax
    mov rdx, [rbp-40]
    add rdx, 8
    mov rax, [rdx]
    mov [rbp-48], rax
    mov rax, r14
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L200
    mov rax, [rbp-48]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L200
    mov rax, 1
    jmp .L201
.L200:
    mov rax, 0
.L201:
    test rax, rax
    jz .L198
    mov rdx, [rbp-48]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_AST_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L202
    mov rdx, [rbp-48]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_lookup_tok
    add rsp, 32
    mov [rbp-56], rax
    mov rax, [rbp-56]
    cmp rax, 0
    je .L204
    mov rdx, [rbp-56]
    add rdx, 24
    mov rax, [rdx]
    mov r13, rax
    cmp r13, 0
    je .L206
    mov rax, r13
    sar rax, 56
    and rax, 255
    mov r12, rax
    mov rax, r13
    mov rcx, 0x00FFFFFFFFFFFFFF
    and rax, rcx
    mov r13, rax
    mov rdx, [rbp-32]
    add rdx, 38
    movzx eax, word [rdx]
    shr rax, 4
    and rax, 15
    mov rbx, rax
    cmp r12, 0
    jne .L208
    mov rax, 8
    mov r12, rax
    jmp .L209
.L208:
.L209:
    cmp rbx, 0
    jne .L210
    mov rax, 8
    mov rbx, rax
    jmp .L211
.L210:
.L211:
    cmp r12, rbx
    je .L212
    mov rax, [rel __g_semantic_sem_had_error]
    cmp rax, 0
    jne .L214
    mov rdx, [rbp-48]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    mov rdx, 9
    sub rsp, 32
    call sem_error_at
    add rsp, 32
    jmp .L215
.L214:
.L215:
    jmp .L194
    jmp .L213
.L212:
.L213:
    cmp r13, r14
    jge .L216
    mov rax, [rel __g_semantic_sem_had_error]
    cmp rax, 0
    jne .L218
    mov rdx, [rbp-48]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    mov rdx, 6
    sub rsp, 32
    call sem_error_at
    add rsp, 32
    jmp .L219
.L218:
.L219:
    jmp .L194
    jmp .L217
.L216:
.L217:
    jmp .L207
.L206:
.L207:
    jmp .L205
.L204:
.L205:
    jmp .L203
.L202:
.L203:
    jmp .L199
.L198:
.L199:
    mov rdx, [rbp-32]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-32], rax
    mov rdx, [rbp-40]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-40], rax
.L195:
    jmp .L193
.L194:
    jmp .L190
.L189:
.L190:
    jmp .L188
.L187:
.L188:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_args
    add rsp, 32
    mov rax, 0
    jmp .__ret_184
.__ret_184:
    mov rbx, [rbp-128]
    mov r12, [rbp-120]
    mov r13, [rbp-112]
    mov r14, [rbp-104]
    mov rsp, rbp
    pop rbp
    ret
sem_block:
    push rbp
    mov rbp, rsp
    sub rsp, 112
    mov [rbp-80], rbx
    mov [rbp-72], r12
    mov [rbp-64], r13
    mov r13, rcx
    mov rax, 0
    mov r12, rax
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
.L221:
    mov rax, 1
    cmp rax, 1
    jne .L222
    mov rdx, [rbp-32]
    add rdx, 40
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_BLOCK_RAW]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L224
    mov rax, [rel __g_semantic_sem_raw_depth]
    add rax, 1
    mov [rel __g_semantic_sem_raw_depth], rax
    add rbx, 1
    jmp .L225
.L224:
.L225:
    mov rax, [rel __g_semantic_SEM_SCOPE_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call sem_push_scope
    add rsp, 32
    add r12, 1
    mov rdx, [rbp-32]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L226
    jmp .L222
    jmp .L227
.L226:
.L227:
    mov rdx, [rbp-40]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_AST_BLOCK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L228
    mov rcx, [rbp-40]
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .L222
    jmp .L229
.L228:
.L229:
    mov rax, [rbp-40]
    mov [rbp-32], rax
.L223:
    jmp .L221
.L222:
.L230:
    cmp r12, 0
    jle .L231
    sub rsp, 32
    call sem_pop_scope
    add rsp, 32
    sub r12, 1
.L232:
    jmp .L230
.L231:
    mov rax, [rel __g_semantic_sem_raw_depth]
    sub rax, rbx
    mov [rel __g_semantic_sem_raw_depth], rax
    mov rax, 0
    jmp .__ret_220
.__ret_220:
    mov rbx, [rbp-80]
    mov r12, [rbp-72]
    mov r13, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
sem_node:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-8], rcx
    mov rax, 0
    mov rbx, rax
    mov rax, 0
    mov [rbp-24], rax
    mov rax, 0
    mov [rbp-32], rax
    mov rax, 0
    mov [rbp-40], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L234
    mov rax, 0
    jmp .__ret_233
    jmp .L235
.L234:
.L235:
    mov rdx, [rbp-8]
    mov rax, [rdx]
    mov rbx, rax
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PROGRAM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L236
    mov rax, [rbp-8]
    mov [rbp-32], rax
.L238:
    mov rax, 1
    cmp rax, 1
    jne .L239
    mov rdx, [rbp-32]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-32]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-40], rax
    mov rax, [rbp-40]
    cmp rax, 0
    jne .L241
    mov rax, 0
    jmp .__ret_233
    jmp .L242
.L241:
.L242:
    mov rdx, [rbp-40]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_AST_PROGRAM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L243
    mov rcx, [rbp-40]
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rax, 0
    jmp .__ret_233
    jmp .L244
.L243:
.L244:
    mov rax, [rbp-40]
    mov [rbp-32], rax
.L240:
    jmp .L238
.L239:
    jmp .L237
.L236:
.L237:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_FUNCTION]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L245
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    jne .L247
    mov rax, 0
    jmp .__ret_233
    jmp .L248
.L247:
.L248:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_SEM_T_FN]
    push rax
    mov rax, [rel __g_semantic_SEM_F_FUNCTION]
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, [rbp-8]
    sub rsp, 32
    call sem_insert_tok
    add rsp, 32
    mov rax, [rel __g_semantic_SEM_SCOPE_FUNCTION]
    push rax
    pop rcx
    sub rsp, 32
    call sem_push_scope
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    sub rsp, 32
    call sem_pop_scope
    add rsp, 32
    mov rax, 0
    jmp .__ret_233
    jmp .L246
.L245:
.L246:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PARAM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L249
    mov rax, [rbp-8]
    mov [rbp-32], rax
.L251:
    mov rax, [rbp-32]
    cmp rax, 0
    je .L252
    mov rdx, [rbp-32]
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_AST_PARAM]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    je .L254
    mov rcx, [rbp-32]
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L255
.L254:
.L255:
    mov rdx, [rbp-32]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    je .L256
    mov rdx, [rbp-32]
    add rdx, 24
    mov rax, [rdx]
    push rax
    mov rcx, [rbp-32]
    sub rsp, 32
    call sem_node_type
    add rsp, 32
    push rax
    mov rax, 0
    push rax
    mov rcx, [rbp-32]
    sub rsp, 32
    call sem_arr_value
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_insert_tok
    add rsp, 32
    jmp .L257
.L256:
.L257:
    mov rdx, [rbp-32]
    add rdx, 16
    mov rax, [rdx]
    mov [rbp-32], rax
.L253:
    jmp .L251
.L252:
    mov rax, 0
    jmp .__ret_233
    jmp .L250
.L249:
.L250:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_VAR_DECL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L258
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    jne .L260
    mov rax, 0
    jmp .__ret_233
    jmp .L261
.L260:
.L261:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_node_type
    add rsp, 32
    push rax
    mov rax, 0
    push rax
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_arr_value
    add rsp, 32
    push rax
    pop r9
    pop r8
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_insert_tok
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L259
.L258:
.L259:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_CONST_DECL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L262
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    jne .L264
    mov rax, 0
    jmp .__ret_233
    jmp .L265
.L264:
.L265:
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_SEM_T_I64]
    push rax
    mov rax, [rel __g_semantic_SEM_F_CONST]
    push rax
    pop r8
    pop rdx
    pop rcx
    mov r9, 0
    sub rsp, 32
    call sem_insert_tok
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L263
.L262:
.L263:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_BLOCK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L266
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_block
    add rsp, 32
    jmp .__ret_233
    jmp .L267
.L266:
.L267:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_ASSIGN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L268
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_check_lvalue
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L269
.L268:
.L269:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_BINOP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L272
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_UNOP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L272
    mov rax, 0
    jmp .L273
.L272:
    mov rax, 1
.L273:
    test rax, rax
    jz .L270
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L271
.L270:
.L271:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_CALL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L274
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_call
    add rsp, 32
    jmp .__ret_233
    jmp .L275
.L274:
.L275:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_RETURN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L276
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_args
    add rsp, 32
    jmp .__ret_233
    jmp .L277
.L276:
.L277:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_MULTI]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L278
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_args
    add rsp, 32
    jmp .__ret_233
    jmp .L279
.L278:
.L279:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_LAMBDA]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L280
    mov rax, [rel __g_semantic_SEM_SCOPE_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call sem_push_scope
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    sub rsp, 32
    call sem_pop_scope
    add rsp, 32
    mov rax, 0
    jmp .__ret_233
    jmp .L281
.L280:
.L281:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PRINT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L292
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PRINTC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L292
    mov rax, 0
    jmp .L293
.L292:
    mov rax, 1
.L293:
    test rax, rax
    jnz .L290
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_CAST]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L290
    mov rax, 0
    jmp .L291
.L290:
    mov rax, 1
.L291:
    test rax, rax
    jnz .L288
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_TRUNC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L288
    mov rax, 0
    jmp .L289
.L288:
    mov rax, 1
.L289:
    test rax, rax
    jnz .L286
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_INB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L286
    mov rax, 0
    jmp .L287
.L286:
    mov rax, 1
.L287:
    test rax, rax
    jnz .L284
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_ARG_GET]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L284
    mov rax, 0
    jmp .L285
.L284:
    mov rax, 1
.L285:
    test rax, rax
    jz .L282
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L283
.L282:
.L283:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_OUTB]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L296
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_BEEP]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L296
    mov rax, 0
    jmp .L297
.L296:
    mov rax, 1
.L297:
    test rax, rax
    jz .L294
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L295
.L294:
.L295:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_POKE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L304
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_POKE8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L304
    mov rax, 0
    jmp .L305
.L304:
    mov rax, 1
.L305:
    test rax, rax
    jnz .L302
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_POKE16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L302
    mov rax, 0
    jmp .L303
.L302:
    mov rax, 1
.L303:
    test rax, rax
    jnz .L300
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_POKE32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L300
    mov rax, 0
    jmp .L301
.L300:
    mov rax, 1
.L301:
    test rax, rax
    jz .L298
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_raw_check
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L299
.L298:
.L299:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PEEK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L312
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PEEK8]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L312
    mov rax, 0
    jmp .L313
.L312:
    mov rax, 1
.L313:
    test rax, rax
    jnz .L310
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PEEK16]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L310
    mov rax, 0
    jmp .L311
.L310:
    mov rax, 1
.L311:
    test rax, rax
    jnz .L308
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_PEEK32]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L308
    mov rax, 0
    jmp .L309
.L308:
    mov rax, 1
.L309:
    test rax, rax
    jz .L306
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_raw_check
    add rsp, 32
    jmp .__ret_233
    jmp .L307
.L306:
.L307:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_DEREF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L316
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_DLL_LOAD]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jnz .L316
    mov rax, 0
    jmp .L317
.L316:
    mov rax, 1
.L317:
    test rax, rax
    jz .L314
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_raw_check
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L315
.L314:
.L315:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_DLL_PROC]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L318
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_raw_check
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L319
.L318:
.L319:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_SYSCALL]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L320
    mov rax, [rel __g_semantic_sem_raw_depth]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L326
    mov rax, [rel __g_semantic_sem_had_error]
    mov rcx, 0
    cmp rax, rcx
    sete al
    movzx rax, al
    test rax, rax
    jz .L326
    mov rax, 1
    jmp .L327
.L326:
    mov rax, 0
.L327:
    test rax, rax
    jz .L324
    mov rdx, [rbp-8]
    add rdx, 40
    mov rax, [rdx]
    mov rcx, 0
    cmp rax, rcx
    setne al
    movzx rax, al
    test rax, rax
    jz .L324
    mov rax, 1
    jmp .L325
.L324:
    mov rax, 0
.L325:
    test rax, rax
    jz .L322
    mov rdx, [rbp-8]
    add rdx, 40
    mov rax, [rdx]
    push rax
    pop rcx
    mov rdx, 7
    sub rsp, 32
    call sem_error_at
    add rsp, 32
    jmp .L323
.L322:
.L323:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_args
    add rsp, 32
    jmp .__ret_233
    jmp .L321
.L320:
.L321:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_CALL_INDIRECT]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L328
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_args
    add rsp, 32
    jmp .__ret_233
    jmp .L329
.L328:
.L329:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_SAVEFILE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L330
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L331
.L330:
.L331:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_IF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L332
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L333
.L332:
.L333:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_WHILE]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L334
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L335
.L334:
.L335:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_LOOP_IN]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L336
    mov rax, [rel __g_semantic_SEM_SCOPE_BLOCK]
    push rax
    pop rcx
    sub rsp, 32
    call sem_push_scope
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    je .L338
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    mov rax, [rel __g_semantic_SEM_T_I64]
    push rax
    pop rdx
    pop rcx
    mov r8, 0
    mov r9, 0
    sub rsp, 32
    call sem_insert_tok
    add rsp, 32
    jmp .L339
.L338:
.L339:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    sub rsp, 32
    call sem_pop_scope
    add rsp, 32
    mov rax, 0
    jmp .__ret_233
    jmp .L337
.L336:
.L337:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_INDEX]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L340
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    je .L342
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_lookup_tok
    add rsp, 32
    cmp rax, 0
    jne .L344
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-24], rax
    mov rax, [rbp-24]
    mov [rel __g_semantic_sem_error_tok], rax
    mov rdx, [rbp-24]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, 4
    mov [rel __g_semantic_sem_error_kind], rax
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    jmp .L345
.L344:
.L345:
    jmp .L343
.L342:
.L343:
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    jmp .__ret_233
    jmp .L341
.L340:
.L341:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_IDENTIFIER]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L346
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    je .L348
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_lookup_tok
    add rsp, 32
    cmp rax, 0
    jne .L350
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    mov [rbp-24], rax
    mov rax, [rbp-24]
    mov [rel __g_semantic_sem_error_tok], rax
    mov rdx, [rbp-24]
    add rdx, 20
    movzx eax, word [rdx]
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, 1
    mov [rel __g_semantic_sem_had_error], rax
    jmp .L351
.L350:
.L351:
    jmp .L349
.L348:
.L349:
    mov rax, 0
    jmp .__ret_233
    jmp .L347
.L346:
.L347:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_HARDWARE_BLOCK]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L352
    mov rdx, [rbp-8]
    add rdx, 24
    mov rax, [rdx]
    cmp rax, 0
    jne .L354
    mov rax, 0
    jmp .__ret_233
    jmp .L355
.L354:
.L355:
    mov rax, [rel __g_semantic_SEM_SCOPE_HARDWARE]
    push rax
    pop rcx
    sub rsp, 32
    call sem_push_scope
    add rsp, 32
    mov rdx, [rbp-8]
    add rdx, 16
    mov rax, [rdx]
    push rax
    pop rcx
    sub rsp, 32
    call sem_node
    add rsp, 32
    sub rsp, 32
    call sem_pop_scope
    add rsp, 32
    mov rax, 0
    jmp .__ret_233
    jmp .L353
.L352:
.L353:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_AST_MMU_DEF]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jne .L356
    mov rcx, [rbp-8]
    sub rsp, 32
    call sem_mmu
    add rsp, 32
    jmp .__ret_233
    jmp .L357
.L356:
.L357:
    mov rax, 0
    jmp .__ret_233
.__ret_233:
    mov rbx, [rbp-64]
    mov rsp, rbp
    pop rbp
    ret
sem_init:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov [rbp-64], rbx
    mov [rbp-56], r12
    mov [rbp-48], r13
    mov r13, rcx
    mov r12, rdx
    mov rax, 0
    mov rbx, rax
    mov rax, r13
    mov [rel __g_semantic_sem_arena], rax
    mov rax, r13
    mov [rel __g_semantic_sem_arena_ptr], rax
    mov rax, r13
    add rax, r12
    mov [rel __g_semantic_sem_arena_end], rax
.L359:
    mov rax, rbx
    push rax
    mov rax, [rel __g_semantic_SEM_BUCKETS]
    mov rcx, rax
    pop rax
    cmp rax, rcx
    jge .L360
    lea rax, [rel __g_semantic_sem_table]
    push rax
    pop rcx
    mov rdx, rbx
    mov r8, 0
    sub rsp, 32
    call sem_tset
    add rsp, 32
    add rbx, 1
.L361:
    jmp .L359
.L360:
    mov rax, 0
    mov [rel __g_semantic_sem_depth], rax
    mov rax, 0
    mov [rel __g_semantic_sem_scope_ids], rax
    mov rax, 0
    mov [rel __g_semantic_sem_had_error], rax
    mov rax, 0
    mov [rel __g_semantic_sem_error_line], rax
    mov rax, 0
    mov [rel __g_semantic_sem_error_kind], rax
    mov rax, 0
    mov [rel __g_semantic_sem_raw_depth], rax
    mov rax, [rel __g_semantic_SEM_SCOPE_GLOBAL]
    push rax
    pop rcx
    sub rsp, 32
    call sem_push_scope
    add rsp, 32
    mov rax, 0
    jmp .__ret_358
.__ret_358:
    mov rbx, [rbp-64]
    mov r12, [rbp-56]
    mov r13, [rbp-48]
    mov rsp, rbp
    pop rbp
    ret
sem_run:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov rbx, rcx
    cmp rbx, 0
    jne .L363
    mov rax, 1
    neg rax
    jmp .__ret_362
    jmp .L364
.L363:
.L364:
    mov rcx, rbx
    sub rsp, 32
    call sem_node
    add rsp, 32
    mov rax, [rel __g_semantic_sem_had_error]
    cmp rax, 0
    je .L365
    mov rax, 1
    neg rax
    jmp .__ret_362
    jmp .L366
.L365:
.L366:
    mov rax, 0
    jmp .__ret_362
.__ret_362:
    mov rbx, [rbp-32]
    mov rsp, rbp
    pop rbp
    ret
sem_set_error:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-32], rbx
    mov [rbp-24], r12
    mov r12, rcx
    mov rbx, rdx
    mov rcx, r12
    mov rdx, rbx
    sub rsp, 32
    call sem_error_at
    add rsp, 32
    jmp .__ret_367
.__ret_367:
    mov rbx, [rbp-32]
    mov r12, [rbp-24]
    mov rsp, rbp
    pop rbp
    ret
sem_kind:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_semantic_sem_error_kind]
    jmp .__ret_368
.__ret_368:
    mov rsp, rbp
    pop rbp
    ret
sem_line:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_semantic_sem_error_line]
    jmp .__ret_369
.__ret_369:
    mov rsp, rbp
    pop rbp
    ret
sem_col:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, [rel __g_semantic_sem_error_tok]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L371
    mov rax, 0
    jmp .__ret_370
    jmp .L372
.L371:
.L372:
    mov rdx, [rbp-8]
    add rdx, 22
    movzx eax, word [rdx]
    jmp .__ret_370
.__ret_370:
    mov rsp, rbp
    pop rbp
    ret
sem_len:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, [rel __g_semantic_sem_error_tok]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L374
    mov rax, 0
    jmp .__ret_373
    jmp .L375
.L374:
.L375:
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    jmp .__ret_373
.__ret_373:
    mov rsp, rbp
    pop rbp
    ret
sem_name:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, [rel __g_semantic_sem_error_tok]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L377
    mov rax, 0
    jmp .__ret_376
    jmp .L378
.L377:
.L378:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    jmp .__ret_376
.__ret_376:
    mov rsp, rbp
    pop rbp
    ret
sem_suggest_name:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    mov rax, [rel __g_semantic_sem_error_tok]
    mov [rbp-8], rax
    mov rax, [rbp-8]
    cmp rax, 0
    jne .L380
    mov rax, 0
    mov [rel __g_semantic_sem_sug_len], rax
    mov rax, 0
    jmp .__ret_379
    jmp .L381
.L380:
.L381:
    mov rdx, [rbp-8]
    add rdx, 8
    mov rax, [rdx]
    push rax
    mov rdx, [rbp-8]
    add rdx, 16
    mov eax, dword [rdx]
    push rax
    pop rdx
    pop rcx
    sub rsp, 32
    call sem_suggest
    add rsp, 32
    jmp .__ret_379
.__ret_379:
    mov rsp, rbp
    pop rbp
    ret
sem_suggest_len:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    mov rax, [rel __g_semantic_sem_sug_len]
    jmp .__ret_382
.__ret_382:
    mov rsp, rbp
    pop rbp
    ret
